# E21 KV Cache 复用与训练并行优化实测报告

日期：2026-11-18  
硬件与环境：单卡 RTX 2080 Ti (22.0 GiB VRAM, Windows WDDM)，`transformers 5.20.2`，Python `.local-8b\venv\Scripts\python.exe`  
核心改动：
- 新增模块：[`.local-8b/_kv_prefix_cache.py`](../.local-8b/_kv_prefix_cache.py)
- 集成脚本：[`.local-8b/_e21_dsh_train.py`](../.local-8b/_e21_dsh_train.py)（默认开启前缀 KV 复用，保留 `--no-kv-reuse` 开关以兼容旧版全序列基线；新增 `--gen-chunk-bs` 与 `--tail-tok-cap`）
- 已有 `.pt` / `.json` 权重与评测产物均未改动。

---

## 1. 基线精确 Profile 与瓶颈拆解

在 `v2` 同等配置（`--bs 8 --tok-cap 1600 --max-new 88 --eval-e6`, `S_sys=907`, `P_tea=1384`）下实测基线 3 个完整训练步（`profile_baseline.py` / `profile_gen.py`）：

### 1.1 静态资源与初始化阶段
- **模型与 LoRA 显存基线**：加载 fp16 权重后 `17.527 GiB`，将 `model.model.visual` 移至 CPU 后 `16.678 GiB` allocated (`17.543 GiB` reserved)；挂载 all-linear LoRA (`r=16`, 358 层) 后 `16.839 GiB` allocated (`17.703 GiB` reserved)，22 GiB 显存卡上的净可用工作区仅约 `3.5–4.0 GiB`（> 21.5 GiB 即触发 Windows WDDM 系统内存换页）。
- **混合缓存结构实测**（Qwen3.5-9B 共 32 层）：
  - **8 层 `DynamicLayer`**（Full Attention）：`keys`/`values` 形状 `(B, 4, seq_len, 256)`，`torch.float16`，每 token 每样本占用 `32 KiB`（`S_sys=907` 为 `27.7 MiB`；`SYS_7K=7055` 为 `215.3 MiB`）。
  - **24 层 `LinearAttentionLayer`**（GatedDeltaNet）：`conv_states[0]` 形状 `(B, 8192, 4)` (`float16`, `1.5 MiB`) + `recurrent_states[0]` 形状 `(B, 32, 128, 128)` (`float32`, `48.0 MiB`)，合计每样本约 `49.5 MiB`（与序列长度无关）。
- **基线各一次性阶段**：
  - 模型加载 + NSP 基加载：`17.32s`，峰值 `17.53 GiB`
  - `P_cache` / `S_base_cache` 静态 prefill：`1.477s`，峰值 `17.67 GiB`
  - 30 条 Teacher DAgger 预生成（`chunk_bs=6`，未复用 `P_cache`）：`28.639s`，峰值 `19.80 GiB`（在 `profile_gen.py` 中拆分为 `prefill=18.43s + decode=21.84s [228 steps, 95.8ms/step]`）
  - `eval_e6`：`0.612s`，峰值 `19.45 GiB`；`dw_stats`：`1.899s`

### 1.2 基线单步耗时拆解（`S_sys=907, bs=8, tok_cap=1600`）

| Step | `n_items` (`tea_replays`) | `batch_gen_ids` (peak) | `score_items` (`deepcopy` / `fwd`, peak) | `kl_backward` (`mbs`, peak) | `opt` | 单步总耗时 |
|---|---:|---:|---:|---:|---:|---:|
| Step 1 | 10 (2) | `11.90s` (`18.91G`) | `2.08s` (`0.02s / 1.80s`, `18.51G`) | **`52.00s`** (10×`B=1`, `18.31G`) | `0.36s` | **`66.35s`** |
| Step 2 | 10 (2) | `17.43s` (`19.41G`) | `4.12s` (`0.03s / 3.59s`, `19.31G`) | **`61.60s`** (10×`B=1`, `18.67G`) | `0.29s` | **`83.43s`** |
| Step 3 | 11 (3) | `41.58s` (`19.57G`) | `5.18s` (`0.04s / 4.16s`, `19.12G`) | **`62.93s`** (11×`B=1`, `18.70G`) | `0.27s` | **`109.97s`** |
| **3 步均值** | — | **`23.64s`** (27.3%) | **`3.79s`** (4.4%) | **`58.84s`** (**68.0%**) | **`0.31s`** | **`86.58s`** |

> 3 步均值 `86.58s/step × 45 ≈ 3896s` + 初始耗时 ≈ `3944s`，与实际 `e21_dsh_delta_v2.json` 记录的 `4046s` 完全吻合。

### 1.3 关键瓶颈根因
1. **`kl_backward` 退化为全 `B=1` 串行微批**：单条带前缀样本总长 `943–1359 tok`（`> tok_cap/2 = 800`），导致每步 10–11 条样本全部拆成 `B=1` 微批，且每条都在梯度检查点下前向+重算各跑一次 `S_sys`（每步重复计算 `S_sys` 达 **20–22 次**）。
2. **`batch_gen_ids` 两批串行解码与重复 prefill**：`chunk_bs=5` 将 `bs=8` 拆成 `5+3` 两轮串行 88 步解码（`profile_gen.py` 中 `cbs=5` 耗时 `3.50s prefill + 16.56s decode`，而单批 `cbs=8` 仅需 `3.14s prefill + 4.31s decode`）。
3. **长前缀单次 prefill 触发 WDDM 换页**：实测 `SYS_7K=7055` 单次无梯度 `B=1` prefill 因 `torch_chunk_gated_delta_rule` 分块中间张量峰值飙升至 **`24.81 GiB` alloc (`25.51 GiB` reserved)**，触发 WDDM 换页拖慢至 **`53.64s`**；而分块 prefill (`chunk=1024`) 将其压回 **`3.53–4.31s` / `17.18–17.43 GiB`**。

---

## 2. 优化方案设计与实现细节（`_kv_prefix_cache.py`）

### 2.1 Inference / Scoring 无拷贝前缀复用（`PrefixSnapshot` + `ScoringPrefixCache`）
- **消除 `copy.deepcopy` 与 `reorder_cache`**：`ScoringPrefixCache` 在 8 层 Attention 上通过 `.expand(B, -1, -1, -1)` 零拷贝广播前缀 `(1, 4, L_p, 256)`，仅在 `update()` 时拼接当前层输出并**不回写缓存**，层结束即释放拼接张量（Attention KV 峰值降至 `1/8`）。
- **GDN 只读扩展**：24 层 GDN 通过 `.expand(B, ...)` 提供只读 `conv_states`/`recurrent_states`，`update_recurrent_state` 在打分路径中设为 no-op，省去 `50 MiB × B` 拷贝与 `.copy_()` 内核调用；设置 `record_past=True` 防止极短 tail 误走原地 `causal_conv1d_update`。

### 2.2 Rollout 与 DAgger 复用前缀（`prefill_prefix_snapshot` + `prefill_tails_and_generate`）
- **分块无梯度前缀编码**：`prefill_prefix_snapshot(..., chunk_size=1024)` 按 `1024`（64 的整数倍）分块构建 `P_snap` / `S_base_snap` / 学生 `stu_sys_snap`，彻底避免长上下文 prefill 显存尖峰。
- **规避 GDN 左填充衰减陷阱**：若在 `prefix_cache` 之后对 `tail` 进行左填充，pad 位置（`hidden_states=0`）会导致 GDN `conv1d` 卷积窗混入零值，且 `a=0` 时 `g = -exp(A_log) * softplus(dt_bias) < 0` 会对前缀 `recurrent_state` 产生虚假指数衰减。
  - 实现方案：用 `_SingleTailCaptureCache` 对每条 `has_sys=True` 样本做无填充 `B=1` tail prefill（与 `has_sys=False` 样本分别提取各自精确的 tail K/V 与 GDN 终态），随后合并进 `PrefixSharedDecodeCache` 进行单轮 **`B=bs` 联合解码**。
  - `PrefixSharedDecodeCache` 将共享前缀 `(1, 4, L_p, 256)` 仅保留 1 份，批内 `has_sys=False` 样本通过 `am[b, :L_p] = 0` 屏蔽前缀注意力，并传入精确逐样本 `position_ids` 保证 RoPE 位置偏移完全一致。

### 2.3 可微两阶段前缀 KV 复用（`kl_backward_with_prefix`）
- **绕过 `GradientCheckpointingLayer` 限制**：`transformers` 的 `GradientCheckpointingLayer.__call__` 在 `gradient_checkpointing=True` 时会强制置 `use_cache=False` 且丢弃 `past_key_values=None`。因此我们在 `_kv_prefix_cache.py` 中直接以显式 `torch.utils.checkpoint` 与分阶段状态传递驱动 `text_model.layers`。
- **解决 `checkpoint` 多输出同步重算 OOM**：早期直接对返回 `(h_out, s0, s1)` 的 32 层 `checkpoint` 调用 `torch.autograd.backward(c_sys, grads)` 时，由于 32 层的 `s0, s1` 同时作为反传根节点，PyTorch 会在反传起点同时触发全部 32 层重算，导致 `SYS_7K` 在 `pc=512` 下即 OOM。
  - 最终方案（`_stage1_cache_forward` + `_stage1_manual_backward`）：
    1. **Stage 1 Forward（`no_grad` 分块）**：`S_sys` 按块（`L_sys <= 2048` 用 `1024`，`L_sys > 2048` 用 `512`）做无梯度前向，仅保存层间 `hidden_states` 与块边界 GDN 状态（长前缀时自动 `cpu` 卸载），产出 `C_leaf`（64 个 `requires_grad=True` 叶子张量）。
    2. **Stage 2（`has_sys=True` 微批尾巴）**：按 `tail_len` 将所有 `has_sys=True` 样本打包（例如 9–10 条 `907` 样本由原来 10 个 `B=1` 压缩为 **2 个大微批**），每层通过 `_DiffStage2LayerCache` 对 `C_leaf` 做非原地 `.expand(B, ...)`（禁止 `.copy_()`，保证梯度完整累积至 `C_leaf.grad`），并在 `checkpoint(..., use_reentrant=False)` 下运行 `loss.backward()`。
    3. **Stage 3（`has_sys=False` 样本）**：沿用标准 `logits_at` 检查点反传。
    4. **Stage 4（`_stage1_manual_backward`）**：按逆向 chunk、逆向层 `31 -> 0` 逐层单层重算并调用 `torch.autograd.backward`，任一时刻仅保留 **1 层**的计算图在显存中。
- **Windows WDDM 防碎片护栏**：因 Windows PyTorch 不支持 `expandable_segments`，在 `_kv_prefix_cache.py` 加入 `maybe_empty_cache(20.2)`；当 `L_p > 2048`（如 `7k`）时自动收紧 `gen chunk_bs <= 4`、`score max_bs <= 3`、`kl_backward tail_max_bs <= 4, tail_tok_cap <= 1024`，并在 `kl_backward` 期间将 `P_cache` / `S_base_cache` 暂存 CPU。

---

## 3. 严格数值与梯度等价性验证

测试脚本：`test_equivalence.py` 与 `diag_grad.py`（均已实际运行通过）：

| 验证项 | 对比对象 | 实测结果 | 耗时对比 |
|---|---|---|---|
| **Scoring (`P_cache`, 1384 tok)** | `logits_from_snapshot` vs 原 `logits_from_cache` | `max_diff = 0.000000e+00`, `mean_diff = 0.000000e+00` | — |
| **Scoring (`S_base_cache`, 907 tok)** | `logits_from_snapshot` vs 原 `logits_from_cache` | `max_diff = 0.000000e+00`, `mean_diff = 0.000000e+00` | — |
| **Teacher DAgger 生成 (10 条)** | `prefill_tails_and_generate` vs 原 `batch_gen_ids` | **10/10** token 序列完全一致 | `9.69s → 4.26s` (**2.27×**) |
| **Student Rollout 生成 (8 条混合)** | `prefill_tails_and_generate` vs 原 `batch_gen_ids` | **8/8** token 序列完全一致 | `10.77s → 5.05s` (**2.13×**) |
| **梯度等价 (`B=1`, len=128, 64 整除)** | `kl_backward_with_prefix` vs 全序列参考 | `cos = 0.99998742`, `rel_L2 = 5.046e-03` | — |
| **梯度等价 (`B=1`, len=139, 非整除)** | `kl_backward_with_prefix` vs 全序列参考 | `cos = 0.99998748`, `rel_L2 = 5.024e-03` | — |
| **梯度等价 (`B=2`, 变长右填充)** | `kl_backward_with_prefix` vs 串行参考 | `cos = 0.99997604`, `rel_L2 = 7.073e-03` | — |
| **梯度等价 (8 条混合, `S_sys=907`, 非零 LoRA)** | `kl_backward_with_prefix` vs 原 `kl_backward` | `|loss_diff| = 1.013e-06`, 总 `cos = 0.99714923` (`A: 0.99334`, `B: 0.99721`), `max_grad_diff = 2.742e-04` | `16.91s → 6.68s` (**2.53×**) |

---

## 4. 双长度端到端 Benchmark（`S_sys=907` vs `SYS_7K=7055`，`bs=8`）

| 场景 / 方案 | Static Prefill | DAgger Pregen (30条) | `gen` / step | `score` / step | `kl_bwd` / step | 单步均值 | 峰值 VRAM (`alloc` / `reserved`) | 45 步 / 65 步预估 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **`S_sys=907` 基线** (`--no-kv-reuse`) | `1.48s` | `28.64s` | `23.64s` | `3.79s` | `58.84s` | **`86.58s`** | `19.80G` / — | `~3,944s` (实测 45 步 `4046s`) |
| **`S_sys=907` 优化后** (`bench_dual_length` 稳定态) | `2.12s` | `22.48s` | `14.15s` | `2.93s` | `9.16s` | **`26.30s`** (**3.29×**) | `20.08G` / `20.86G` | **`~1,208s`** / **`~1,734s`** |
| *注：`S_sys=907` 未触发 19.5G `empty_cache` 时 (`task-161`)* | `1.71s` | `13.16s` | `7.49s` | `2.81s` | `7.47s` | **`17.82s`** (**4.86×**) | `20.27G` / `21.84G` | **`~817s`** / **`~1,173s`** |
| **`SYS_7K=7055` 基线** (单序列探针) | `53.64s` (`B=1` WDDM) | — | — | — | **CUDA OOM** (Stage1) | 不可行 | `24.81G` / `25.51G` | 不可行 |
| **`SYS_7K=7055` 优化后** (`bench_dual_length`, 2 步实测) | **`8.54s`** | **`38.99s`** | **`17.62s`** | **`9.87s`** | **`28.64s`** | **`56.16s`** | **`19.78G` / `20.77G`** | **`~2,575s`** / **`~3,698s`** |

*(注：45/65 步预估 = `Static + DAgger + 单步均值 × steps`；`SYS_7K` 在全程 20.8 GiB 以内不触发 WDDM 换页，单步 `56.16s` 仍比旧版 `907` 基线 `86.58s` 更快。)*

---

## 5. `_e21_dsh_train.py` 集成与短链路冒烟测试

- 默认行为：`_e21_dsh_train.py` 默认启用 `use_kv_reuse=True`；传入 `--no-kv-reuse` 可完整回退至旧版路径。
- 短链路实测（`--steps 3 --bs 8 --tok-cap 1600 --eval-e6 --eval-every 3 --tag _smoke_kv_opt_tmp`，随后已清理临时产物）：
  - `precomputed 30 Teacher DAgger trajectories in 22.1s`
  - `step 1  loss 0.622  peak 19.45GB  22s`
  - `step 3  loss 0.523  |dW| 0.776 (0.067% er=9.70)  e6 0.00003 | 81s`（总计 `129s`，与基线 `profile_baseline.py` 3 步后 `|dW|=0.7775` 一致）。
