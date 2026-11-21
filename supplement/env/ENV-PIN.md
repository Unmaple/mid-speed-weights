# ENV-PIN · PRO6000WN 实验环境与容灾清单

2026-10-25。本文是**重建环境 + 迁移服务器**的唯一依据。所有数值为实测，不是估计；未标注来源的项见 `probe6000/RESULTS.md` 与各实验 `launch.json`。

---

## 1. 硬件与系统

| 项 | 值 |
|---|---|
| 主机 | `PRO6000WN`（`<gpu-host>:<port>`，登录用户 root；地址已脱敏，见文首说明） |
| GPU | NVIDIA RTX PRO 6000 Blackwell Server Edition，**97,887 MiB** |
| 驱动 | **595.71.05** |
| 系统 | Ubuntu 22.04.5 LTS |

## 2. Python 环境（**不是单目录，重建时最容易翻车**）

| 项 | 值 |
|---|---|
| 解释器 | `/root/q38_probe/venv/bin/python` → Python **3.12.9** |
| venv 性质 | **9.5 MB 的壳**，`include-system-site-packages = true` |
| 真身 | `/root/miniconda3/envs/qwen38`（整个 miniconda **17 GB**） |
| torch | **2.11.0+cu130**（CUDA **13.0**） |
| transformers | **5.12.1** |
| accelerate | **1.15.0** |
| safetensors | 已装 |
| **peft** | **未装**（LoRA 是手写实现，不依赖 peft） |
| **flash_linear_attention** | **未装** → 48 层 GDN 走 torch 回退，这是 18 tok/s decode 的主因 |
| **causal_conv1d** | **未装** |
| vllm | 未装 |

> 重建要点：装同样的 `torch 2.11.0+cu130` + `transformers 5.12.1` + `accelerate 1.15.0`。**驱动低于 595 时无法直接用 cu130 构建**，必须换 torch，届时所有 logits 需重新标定。

## 3. 模型

| 项 | 值 |
|---|---|
| HF repo | `Qwen/Qwen3.8-27B` |
| revision（pinned） | `1d4bf0f2ff6012fd82039f2fa52739d0dd7c60c0` |
| 本地路径 | `/root/models/qwen38-bf16`（32 个符号链接，跨 `/root/autodl-tmp/q38bf16` + `/root/q38bf16-ovf`） |
| 体积 | **52 GB**（`du -L`） |
| 下载脚本 | `probe6000/01_download_qwen38_bf16.py`（本地已有） |
| 类 | `Qwen3_5ForConditionalGeneration` |
| 参数量 | 27,356,728,560（全 BF16，**50.956 GiB**） |
| 层 | **64** = 16 全注意力 + 48 线性注意力（`layer_types` 交替：每 4 层 1 个 full） |
| hidden / heads / KV heads / head_dim | 5120 / 24 / **4** / **256** |
| 词表 | **248,320** |
| **`max_position_embeddings`** | **262,144** ← **原生窗口是 256k，不是 1M** |

**KV 单价**：16 层全注意力 × 2(K,V) × 4 KV头 × 256 dim × 2 B = **65,536 B = 64 KiB/token**（与报告一致）。

## 4. 磁盘

| 卷 | 容量 | 剩余（2026-10-25 22:12） |
|---|---:|---:|
| `/`（overlay） | 30 G | **1.5 G（96% 满）** |
| `/root/autodl-tmp`（md0） | 50 G | 14 G |

**迁移硬要求**：新机器可写卷 ≥ **60 GB**（模型 52 G + 数据 8 G）。当前这台自己就在边缘。

## 5. 显存预算（实算）

| 上下文 | KV | + 权重 50.96 GiB | 合计 | 96 GB 单卡 |
|---|---:|---:|---:|---|
| 20k（已实测） | 1.25 GiB | 51 | 52 | ✅ 实测峰值 57–60 |
| **200k（目标实验档）** | **12.2 GiB** | 51 | **63.2** | ✅ 余约 33 |
| 262k（原生上限） | 16 GiB | 51 | 67 | ✅ 余 29 |
| 800k | 48.8 GiB | 51 | **99.8** | ❌ |

**口径修正（用户 2026-10-25）**：800k 教师只用于分析当前 1M 上下文的生产配置，**不是本实验的必要条件**。本实验要证明的是“**高压缩比时能把额外信息压进权重**”，取 262k 窗口即可：

```
窗口 262k → 信封 E(≈7k) + 保留尾 R + 摘要 cap
         → 被遮蔽段 A ≈ 200k
         → S = 4k 或 8k
         → r = |A|/|S| ≈ 50 或 25
```

这个 regime 单卡放得下（63 GiB），**不需要多卡、不需要 rope 外推、不需要 FP8**。当前 7k 历史的小 pilot 是 r≈4，跨到 r≈25–50 才是主张真正成立的区间。

### 5.1 200k 档的工程含义（必须先算清，否则实验跑不动）

- **单次 200k prefill ≈ 82 s**（按 G10 实测根前缀约 2,424 tok/s）。
- 沿用现在的"逐题两次全文 prefill"：88 题 × 2 × 82 s ≈ **4 h/历史**，不可接受 → **共享前缀从"优化"变成硬前置**。
- 共享前缀后：根 82 s + 88 题 ×（suffix ≈29 tok + 答案 64 tok 解码）≈ **分钟级**。
- **copy-based fork 在 200k 会失效**：每分支 12.2 GiB，权重 51 GiB，同时最多 **2–3 份**（51 + 24–37 GiB）。批大小被压到 2–3；要更大批必须**真分页共享**（根 KV 一份，分支只存 suffix）。


## 6. 备份（已完成）

| 项 | 值 |
|---|---|
| 远端打包 | `/root/autodl-tmp/_backup/q38-artifacts-v1.tar` |
| 本地副本 | `.research/backup/q38-artifacts-v1.tar` |
| 大小 | **838,758,400 B（800 MiB）** |
| SHA256 | `55bdd7612cb32c35ced804474ea121c7368afc604a93549b6e27d2d720e029f8` |
| 文件数 | **37** |
| 校验 | 两端 SHA256 **一致**（2026-10-25 22:12） |

内容：三份历史的 `adapter_RD/SRD` + `teacher.pt` + `train_end_ref_*`；H20 的 `adapter_RD/S1RD/S2RD` + `teacher.pt` + 三个 `train_end_ref`；`gate_v1` 的两个 adapter + `teacher_hidden.pt`；G12 扫描的 8 个 mark adapter；`pre_runtime_fix/H1` 两个；以及 `teacher_capture_batched_v6` 两个**失败门禁**的 provisional 产物。

> 解包：`tar -xf q38-artifacts-v1.tar`，相对路径为 `q38_probe/...` 与 `autodl-tmp/...`。
> **未备份且不需要备份**：模型 52 GB（可重下）、conda env 17 GB（可重建，版本见 §2）、各 run 的 JSON（**本地工作区已有全量**）。

## 7. 换服务器后必须重做的数值复核

库版本或驱动变化会让 logits 漂移，**这不是理论担心**：同 dtype 下 cold vs cached 已经测到真实答案 KL 0.0018、head maxabs **1.2**（旧门禁 0.05），起因疑似 GDN recurrent state 按 BF16 写入。所以迁移后**必须**重跑下列检查，通过前不得与旧数字直接比较：

1. 加载验收：0 missing / 0 unexpected，参数 50.956 GiB；
2. head 重建：同次 forward 取 hidden 过冻结 lm_head，与 direct logits 差应为 0；
3. cold 可重复性：同一输入两次前向逐位一致；
4. T 自 KL：完整历史教师对自身 KL 应为 0；
5. cache 路径敏感性：cold vs 分段 cache 的逐位置差异完整报告，**不用新容差掩盖**。

## 8. 重建顺序（新机器）

1. 装驱动 ≥ 595 / CUDA 13.0 → 建 conda env（3.12.9）→ 装 torch 2.11.0+cu130 / transformers 5.12.1 / accelerate 1.15.0 / safetensors；
2. 下 `Qwen/Qwen3.8-27B`（revision 见 §3），按需分卷（50 G 盘装不下 52 G，必须两卷 + 符号链接）；
3. 把 `.research/backup/q38-artifacts-v1.tar` 传回远端并解到 `/root` 下（保持 `q38_probe/` 与 `autodl-tmp/` 结构）；
4. 跑 §7 的五项复核；
5. 全部通过后才恢复正式测量；旧 JSON 一律不动。

## 9. 已知缺口（不是本次要修的，但要记录）

- `peft` / `flash_linear_attention` / `causal_conv1d` 未装 → GDN 走 torch 回退，decode 18 tok/s。装专用内核会改变数值路径，属于独立验收项，不能顺手装。
- `overlay` 只剩 1.5 G，任何大文件（新 checkpoint 副本、pip 缓存）都可能 ENOSPC；新产物优先写 `/root/autodl-tmp`。
- 模型跨两卷 + 32 个符号链接，`du` 必须加 `-L`，否则显示 4.0 K。
