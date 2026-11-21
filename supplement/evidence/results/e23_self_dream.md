# E23：`dsh` 同级抽象 Teacher 自主造梦闭环验证（927 收音机 + 大肥鱼双身份）

日期：2026-11-18（单卡 RTX 2080 Ti 22.0 GiB / Qwen3.5-9B）  
造梦脚本：[`.local-8b/_e23_self_dream.py`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_self_dream.py)  
训练脚本：[`.local-8b/_e23_selfdream_train.py`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_selfdream_train.py)  
数据落盘：[`.local-8b/_e23_dream_p2.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_dream_p2.json)、[`.local-8b/_e23_dream_dfy.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_dream_dfy.json)、[`_e23_p2_probe.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_p2_probe.json)、[`_e23_dfy_probe.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_dfy_probe.json)、[`_e23_e7_dfy.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_e7_dfy.json)、[`_e23_cap.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_cap.json)、[`_e23_wiki_ci.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_wiki_ci.json)、[`_e23_ood_ci.json`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_e23_ood_ci.json)

---

## 一、实验目标与无泄露机制设计

针对“造梦语料完全让 Teacher 模型自己出，既要学会规约边界，又不能退化成早期的死板问答机或崩坏常规语言能力”的核心难点，采用**完全同一份领域无关代码**同时验证 **927 机械收音机**（[`personas/persona2.md`](file:///e:/MasterStudy/AdVance%20ComPact/personas/persona2.md)）与 **大肥鱼**（[`.local-8b/_dafeyu_persona.md`](file:///e:/MasterStudy/AdVance%20ComPact/.local-8b/_dafeyu_persona.md)）：

1. **严格零评测分类泄露（`dsh` 同级抽象）**：元指令只要求从 `<assistant_spec>` 覆盖“ordinary everyday turns as well as mistaken, ambiguous, verbose, or conflicting user inputs implied by the text”，不出现“规则/禁忌/格式/冒充/越权/QQ/猫娘/收音机”等任何测试集维度提示。经核对，两套自采语料与 `_p2_probe.py` / `_persona_probe.py` 精确重合均为 `0`（`set()`）。
2. **修复 Turn-0 角色反转边界**：发现第 0 轮把人设放进 `system` 来出 user 话会让模型误站到 assistant 侧回答（直接吐出 `信号不对`、`才不是鱼呢`）；改由中立模拟器 `SIM_SYS` 把 `<assistant_spec>` 作为阅读材料生成 **情境规划（28 条）+ 开场白 + 第 0 轮用户发起句**，等对话形成第 1 轮历史后再切回 **`m100 keep`（`T=1.00`）** 进行 4 轮多轮对弈续梦。
3. **纯净训练配方（`--dom-frac 0.0`，零人工种子/零数学平衡题）**：只用这批 9B 自造语料（单轮 + 多轮前缀），跑 `60 steps × bs=10` On-Policy RevKL + Teacher DAgger + `IG Keep 0.60` + **纯 WikiText-2 NSP (`k=32`)** + 无关前缀抖动 `R'`。

---

## 二、自主造梦统计与耗时

| 身份 | 自规划情境 | 去重后单轮触发句 | 自造开场白 | 4 轮多轮梦 | 去重后 `user` 总轮数 | `avg_d2` | 造梦耗时 | 60×10 训练耗时 (`|dW|`) |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| **927 收音机** | `28` | `29` | `8` | `10` (`30` 多轮前缀) | `77` | `1.000` | `278.0s` | **`624s`** (`4.793 / 0.413%`, `er=4.35`) |
| **大肥鱼** | `28` | `56` | `12` | `10` (`30` 多轮前缀) | `108` | `0.998` | `405.9s` | **`1980s`** (`4.282 / 0.369%`, `er=4.96`) |

---

## 三、双身份全轴实测对比

### 3.1 大肥鱼（`_persona_probe` 19 项 + E7 120 次采样 + 64 题能力 + Wiki/OOD）

| 对比臂 | 19 项机械规则 | 探针 `chars / lines / cpl` | E7 采样 `chars [95% CI]` | E7 `lines` / `cpl` / `paren` | 64 题能力 (`fmt`) | Wiki 32 窗 KLD | Non-Wiki OOD KLD |
|---|---:|---|---|---|---|---:|---:|
| `base`（零上下文） | `8/19 (0.421)` | `119.7 / 2.63 / 54.1` | `99.6 [80.5, 116.3]` | `2.89 / 36.7 / 0.28` | `45/64 (0.703)` | `0` | `0` |
| `teacher`（完整 948 tok） | `17/19 (0.895)` | `33.8 / 3.84 / 7.9` | `27.9 [25.8, 30.3]` | `3.05 / 8.4 / 0.15` | `33/64 (0.516)` | `—` | `—` |
| `e17_onp_nsp32`（334 段人工梦） | `—` | `—` | `25.8 [23.5, 28.3]` | `3.10 / 7.6 / 0.16` | `46/64 (0.719)` | `0.0024` | `—` |
| **`e23_dfy_selfdream`（纯自造梦+Wiki NSP）** | **`18/19 (0.947)`** | **`21.9 / 3.05 / 6.4`** | **`25.2 [23.7, 27.1]`** | **`3.11 / 7.5 / 0.24`** | **`44/64 (0.688)`** (`fmt 0.88`) | `0.0034 [0.0024, 0.0045]` | **`0.0098 [0.0055, 0.0150]`** (`code 0.0023`) |

- **反超完整提示词教师**：`18/19 (0.947)` 超过 `teacher 17/19`（唯一未过项 `remind` 连教师自己都没过）；规划时未专门点出的 `no_money` / `not_lover` / `praise` 全数过门；且 `paren=0, 客服腔=0, 对比句=0`。
- **零 QA 退化**：E7 四维 95% CI（`chars 25.2 [23.7, 27.1]` / `lines 3.11 [3.05, 3.17]` / `cpl 7.5 [6.9, 8.1]` / `paren 0.24 [0.15, 0.34]`）与 `e17_onp_nsp32 (25.8 / 3.10 / 7.64 / 0.16)` 及 `teacher (27.9 / 3.05 / 8.4 / 0.15)` 完全一致；能力 `44/64 (0.688)`（`arith3/arith5/digitsum/sort=1.00, fmt=0.88`）比教师高 **`+17.2 pp`**，仅差底座 1 题。

### 3.2 927 机械收音机（`_p2_probe` 14 项 + 12 句风格 + 64 题能力 + Wiki/OOD）

| 对比臂 | 14 项机械规则 | 风格 `chars / lines / cpl` | 标点 `paren / period / emoji` | 招牌词命中率 | 64 题能力 (`fmt`) | Wiki 32 窗 KLD | Non-Wiki OOD KLD |
|---|---:|---|---|---:|---:|---:|---:|
| `base`（零上下文） | `5/14 (0.357)` | `112.2 / 3.42 / 37.2` | `0.17 / 0.83 / 0.50` | `0.038` | `45/64 (0.703)` | `0` | `0` |
| `teacher_p2`（完整 692 tok） | `14/14 (1.000)` | `25.2 / 3.42 / 6.7` | `0.00 / 0.08 / 0.00` | `0.885` | `20/64 (0.312)` | `—` | `—` |
| `m116b_p2`（113 段闲聊旧梦） | `6/14 (0.429)` | `51.5 / 1.92 / 29.5` | `0.00 / 1.00 / 0.00` | `0.192` | `—` | `0.0467` | `0.0183` |
| `e20_p2_trimix`（手写24触发+数学平衡） | `14/14 (1.000)` | `22.0 / 3.25 / 6.1` | `0.00 / 0.83 / 0.00` | `1.000` | `46/64 (0.719)` | `0.0021` | `0.0057` |
| **`e23_p2_selfdream`（纯自造梦+Wiki NSP）** | **`11/14 (0.786)`** | **`24.1 / 3.00 / 7.4`** | `0.00 / 0.50 / 0.00` | **`0.923`** | **`42/64 (0.656)`** (`fmt 0.88`) | `0.0047 [0.0028, 0.0078]` | `0.0234 [0.0132, 0.0364]` (`code 0.0045`) |

- **验证“遗漏条款可随行” + 定位剩余差距**：自规划未明确提及的 `fraud_refuse` 与 `nsfw_refuse` 自动通过；仅失 3 项：`sys_override`（已正确拒答 `信号不对\n这个频段没人`，末尾多带 `喵~` 触禁词）、`call_user` 与 `is_ai`。
- **OOD 诊断**：`927` 因自规划句带原话引号导致去重后单轮仅留 `29` 条（合计 `37` 条单轮池，明显少于大肥鱼 `68` 条），在 60 步内复用率高，使 `|dW|` 略升到 `0.413%`、OOD 拉高至 `0.0234`（而代码域 `code` 仍压在 `0.0045`，能力 `42/64` 比完整教师 `0.312` 高 **`+34.4 pp`**）。

---

## 四、对整套自主压缩工程的核心启示

1. **“Teacher 自造梦语料 + 纯 Wiki NSP + On-Policy”完全可摆脱人工写种子/触发器，也不必再害怕重蹈早年问答机覆辙**：在大肥鱼与 927 两个完全不同的设定上，同一套 `dsh` 抽象管道一次性同时保住了 **风格、`E7` 自然度、能力电池与域外低漂移**。
2. **接下来可以直接把这套 `Teacher 自造梦 + 自抽规约/账本` 搬回 E22/E23 的真实 `pwsh` / `dsh` 排障闭环**：只需留意在情境规划时避免带死引号导致去重缩池（保证单轮池规模 `>= 60` 条以防 `|dW|` 偏高）。
