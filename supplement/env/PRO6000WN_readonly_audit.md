# PRO6000WN 只读核验报告

- 主机：`<gpu-host>:<port>`（SSH 别名 `PRO6000WN`，auth=password，凭证由 DSH 工具持有，全程未打印、未读取任何私钥/凭证文件）。**地址与容器 ID 已在发布版中脱敏**，原文见研究机。
- 连接方式：DSH `ssh_exec`（非交互），**可用**
- 远端身份：`root@autodl-container-<redacted>`，Ubuntu 22.04.5 LTS，内核 5.15.0-78-generic，x86_64
- 形态：**AutoDL Docker 容器**（存在 `/.dockerenv`，PID 命名空间独立，容器已运行 19 分钟）
- 核验时间：远端 `Sun Oct 25 09:08–09:12 CST 2026`（本地时钟）
- 全程只读：未 kill/pause/restart 任何进程，未创建 CUDA context，未安装/下载/写入/移动任何文件，未改 SSH 配置

---

## 1. GPU 实际状态（nvidia-smi）

```
index, name, driver, memory.total, memory.used, memory.free, util.gpu, util.mem, power.draw, power.limit, temp
0, NVIDIA RTX PRO 6000 Blackwell Server Edition, 595.71.05, 97887 MiB, 0 MiB, 97252 MiB, 100 %, 0 %, 105.06 W, 600.00 W, 40
```
```
compute apps: (pid, process_name, used_gpu_memory) -> 空（无任何计算进程）
FB Memory: Total 97887 / Reserved 636 / Used 0 / Free 97252 MiB
BAR1: 131072 MiB, used 0
Utilization: GPU 100% / Memory 0% / Encoder 0% / Decoder 0% / JPEG 0% / OFA 0%
GPU Utilization Samples: 14s, 71 samples, Min 100 / Max 100 / Avg 100
clocks.sm 2347 MHz, clocks.mem 12481 MHz, pstate P0, ECC disabled, compute_mode Default
容器内持有 /dev/nvidia* fd 的进程数：0
```

**判读（关键）**
- 型号 / 显存容量 / 驱动版本与用户快照**一致**（RTX PRO 6000 Blackwell SE，97887 MiB，595.71.05，CUDA 13.2）。
- util 恒定 100% **是无效/虚拟化伪造指标**，不是真实负载证据：
  - 显存 used = 0 MiB，compute 进程列表为空，容器内无任何进程打开 nvidia 设备；
  - 功耗仅 105 W（600 W 上限的 18%）、显存控制器利用率 0%、温度 40 °C、71 个采样点 Min=Max=100（真实负载的采样必然抖动）。
- 结论：**GPU 当前实际空闲**；「利用率 100%」不能作为「机器有任务/不可用」的依据，也**不能**反过来当作「可以开跑」的许可。是否存在宿主机其它容器的算力占用，容器视角无法证明，需人或平台侧确认。
- **不存在“显存不足”问题**：97 GB 显存全自由。因此「util 100%」与「显存不足」两者都不构成当前障碍，真正障碍在磁盘与软件栈（见 §2、§3）。

## 2. 存储与挂载（关键阻塞项）

```
df -hT:
overlay           30G  11G  20G  36%  /
172.30.54.6:/data nfs4 7.3T 1.6T 5.3T 24% /autodl-pub      (挂载选项 ro —— 只读)
/dev/md0          xfs  150M   0  150M   0% /init
/dev/sda2         ext4 439G  21G 396G   5% /usr/bin/nvidia-smi (单文件绑定挂载，非可用卷)
/root/autodl-tmp  /dev/md0 xfs 50G  36K  50G  1%
```
- 系统盘：overlay **30G，剩 20G**（与快照一致）。
- **`/root/autodl-tmp` 存在**（与快照“未找到”不符）：是独立 xfs 卷，50G，当前几乎全空（已用 36K）。目录下只有 `.autodl` 管理目录。
- `/autodl-pub`：NFS 7.3T，可用 5.3T，但**以 ro 只读挂载**，只有数据集目录（ImageNet/COCO/nuScenes/…），不能作为权重写入卷。
- 没有其它大容量可写卷（`/root`、`/opt`、`/tmp` 均落在 20G 可用的 overlay 上）。
- 内存：`free -g` 显示 1007 GiB（宿主机物理内存，对应快照“约 1TB”），但 **cgroup v2 `memory.max` = 120 GiB**，容器实际可用约 120 GiB —— 快照的 1TB 是宿主口径，对训练内存规划应按 ~120 GiB 计算。
- CPU：208 逻辑核（2×Intel Xeon Platinum 8470Q，52 核/路），与快照一致。

**阻塞判定**：BF16 约 54 GB，**没有任何单一可写卷能容纳**（数据盘 50G < 54G；系统盘 20G）。必须由人决定扩容数据盘 / 换实例规格 / 改用 FP8 或分片离线方案。

## 3. Python / conda / 依赖栈

```
/root/miniconda3/bin/conda  -> conda 24.4.0
conda env list: base /root/miniconda3 ; qwen38 /root/miniconda3/envs/qwen38
/root/miniconda3/bin/activate 存在
base python 3.12.3
```
env `qwen38`（`/root/miniconda3/envs/qwen38/bin/python`，importlib.metadata 查询，未 import torch）：

| 包 | 版本 / 安装路径 |
|---|---|
| torch | **2.11.0** @ envs/qwen38/lib/python3.12/site-packages |
| transformers | **5.12.1** 同上 |
| triton | 3.6.0 |
| safetensors | 0.8.0 |
| tokenizers | 0.22.2 |
| huggingface-hub | 1.28.0 |
| numpy | 2.3.5 |
| datasets | 5.0.1 |
| tilelang | 0.1.11 |
| **accelerate** | **未安装** |
| **peft** | **未安装** |
| **flash-attn** | **未安装** |
| **flash-linear-attention** | **未安装** |
| **causal-conv1d** | **未安装** |
| vllm / deepspeed / bitsandbytes | 未安装 |

base env 另有 torch 2.8.0+cu128、triton 3.4.0，transformers/accelerate/peft/safetensors 均未安装。

**阻塞判定**：LoRA 微调必需的 `peft` + `accelerate` 缺失；本模型为**混合线性注意力**架构，`flash-linear-attention`/`causal-conv1d` 缺失会退化到慢路径（可行但显著变慢），需人工决定是否安装。

## 4. 既有模型 / 缓存（重要）

- `/root/.cache/huggingface/hub`：**不存在**（`/root/.cache` 下只有 `motd.legal-displayed`）。HF 缓存为空。
- `/root/.modelscope/credentials` 存在 —— **按只读边界未读取其内容**。
- `/root/models/qwen38-27b/` 存在，但检查显示为**残骸**：
  - 81 个条目、66 个 `layers-*.safetensors` **全部是断链**：`-> /.autodl/xx/xx/...`，而 `/.autodl -> ../../.autodl-model/data`，`/.autodl-model/` 为空目录，目标不存在；
  - `dangling = 66 / 66`，`layers-51.safetensors` 已报 No such file；
  - `du -shL` 仅 23 MB —— 只有 config/tokenizer/index 文本存活，**权重不在本实例**；
  - 保留的元数据：`config.json`、`model.safetensors.index.json`（1606 个 weight 条目）、`safetensors-md5sum.txt`、`crc32.txt`、`chat_template.jinja`。
- `/root/model_dspark/`：仅 config.json / README / dflash.py / dspark.py（无权重）。
- `/root/.triton`、`/root/.humming`、`/root/.tilelang` 为工具缓存目录。

**checkpoint 结构（从 config.json 读出，恒为只读）**
```
model_type: qwen3_5 ; architectures: Qwen3_5ForConditionalGeneration  (多模态：text_config + vision_config)
text: num_hidden_layers 64, hidden_size 5120, heads 24 / kv_heads 4, head_dim 256,
      intermediate_size 17408, vocab 248320, dtype bfloat16, ctx 262144,
      full_attention_interval 4 (=> 16 层 full attn + 48 层 linear attn), linear_conv_kernel_dim 4,
      mamba_ssm_dtype 存在 => 需 FLA/Gated-DeltaNet 类 kernel
vision: depth 27, hidden 1152, heads 16
quantization_config: fp8 (fmt e4m3, activation dynamic) —— 本地这份是 FP8 量化版，非 BF16
```
- 由此：该 checkpoint 是 **FP8 量化 + 多模态**，与「BF16 冻结基座」预实验目标**不是同一份权重**；BF16 需另行获取（~54 GB），当前磁盘无法容纳。

## 5. 进程 / 服务侧观察（只读，仅程序名）

```
共 13 个进程（容器刚起 19 分钟）：supervisord, tensorboard, jupyter-lab, autopanel, sshd, proxy, server, bash
ss -ltnp：无对公监听端口输出
```
- 未发现任何训练/推理服务在跑，`nvidia-smi` compute 进程为空 —— 快照中「机器上有已有任务」在本容器内**未得到证实**（宿主侧或其它容器的占用无法从本容器证明）。

## 6. 实际执行的只读命令清单

1. `hostname; whoami; uname -a; head -3 /etc/os-release; date`
2. `nvidia-smi --query-gpu=... --format=csv` / `--query-compute-apps=pid,process_name,used_memory` / `nvidia-smi -L`
3. `nvidia-smi -q -d MEMORY,UTILIZATION` / `--query-gpu=utilization.*,memory.used,power.draw,clocks.sm`（间隔 2s ×3 采样）/ `--query-gpu=clocks.sm,clocks.mem,pstate,ecc.mode.current,compute_mode`
4. `df -hT -x tmpfs -x devtmpfs` / `findmnt -o TARGET,SOURCE,FSTYPE,SIZE,AVAIL,USE%` / `df -h /root/autodl-tmp` / `findmnt -o TARGET,OPTIONS /autodl-pub`
5. `ls -la /` `/root` `/root/autodl-tmp` `/root/models` `/root/model_dspark` `/root/.cache` `/root/.modelscope` `/autodl-pub` `/autodl-pub/data` `/.autodl-model`
6. `du -sh --max-depth=1 /root/models; du -sh /root/miniconda3; du -shL /root/models/qwen38-27b`
7. `readlink -f` / `ls -lL` / `stat -L` 于 layers-0.safetensors；循环 `[ -e ]` 统计断链数
8. `free -g; nproc; lscpu | grep -E '^Model name|^Socket|^Core|^CPU\(s\)'; cat /sys/fs/cgroup/memory.max`
9. `/root/miniconda3/bin/conda --version; conda env list; ls /root/miniconda3/bin/activate`
10. `/root/miniconda3/envs/qwen38/bin/python` 内 `importlib.metadata`（torch/transformers/accelerate/peft/flash-attn/flash-linear-attention/causal-conv1d/triton/safetensors/vllm/deepspeed/bitsandbytes/datasets/tokenizers/huggingface-hub/numpy/tilelang）；base env 同法 —— **未 import torch、未调用 torch.cuda.***
11. `ps -eo pid,comm,etime,pcpu,pmem --sort=-pcpu | head -12`（仅 comm 程序名，不读 cmdline）；`ps -e | wc -l`；`ss -ltnp`
12. `ls -l /proc/[0-9]*/fd | grep -c nvidia`
13. `python json` 读取 `config.json` / `model.safetensors.index.json` 的架构字段（只读）

未执行：任何写入、安装、下载、kill/pause、CUDA 初始化、基准、日志正文读取、`/root/.ssh` 与 `.modelscope/credentials` 内容读取、私有 key 遍历。

## 7. 明确阻塞项（按优先级）

| # | 阻塞项 | 证据 | 解除方式（需人决定） |
|---|---|---|---|
| B1 | **无 ≥54 GB 可写卷** | overlay 20G 可用；autodl-tmp 50G 可用；/autodl-pub 为 ro NFS | 扩容数据盘 / 换规格 / 用 FP8 或离线分片 |
| B2 | **无 BF16 权重，且现有 qwen38-27b 全为断链残骸** | 66/66 safetensors dangling，du 仅 23 MB | 重新获取 BF16（或按 FP8 走另一套方案） |
| B3 | **缺 peft / accelerate**（LoRA 必需） | metadata 查询未安装 | 允许安装时才可装 |
| B4 | **缺 flash-linear-attention / causal-conv1d / flash-attn** | 同上；模型 64 层中 48 层为线性注意力 | 可退化慢路径，或安装 |
| B5 | **本地 checkpoint 是 FP8 e4m3 + 多模态**，非 BF16 | config.json quantization_config | 与「BF16 冻结基座」目标需重新对齐 |
| B6 | 容器内存上限 **120 GiB**（非 1TB） | cgroup memory.max=128849018880 | 影响 CPU offload/数据加载规划 |
| B7 | 宿主/其它容器的 GPU 占用不可见 | 容器仅见自身 PID 与空显存 | 需人/平台确认共存 |

## 8. 对「BF16 冻结基座 + 少量层未合并 LoRA 单卡预实验」的判断

- 显存侧：97 GB 空闲，27B BF16（~54 GB）权重 + 少量 LoRA 可训练参数 + 梯度检查点下的激活，**单卡 97 GB 在数值上是可行的**（LoRA 优化器状态很小）。
- 磁盘侧：**不可行**（B1+B2），这是当前第一硬阻塞。
- 软件侧：**不可行**（B3 必装；B4 影响速度）。
- 权重侧：需要确认目标模型是否真为 BF16 的 Qwen3.5-27B 文本/多模态版本（本地残骸显示 64 层混合线性注意力 + 多模态 + FP8）。
- GPU 忙/闲：**不是**、也不应作为停做其它检查的理由；实测为空闲，是否开跑由人决定，本次未占用 GPU。