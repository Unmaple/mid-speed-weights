# v4 修改记录（相对 v3）

| 项 | 值 |
|---|---|
| 源 | `paper-fse-v3.tex`（冻结）→ `paper-fse-v4.tex` |
| 产物 | `paper-fse-v4.pdf`，**12 页**（v3 为 10 页；末页约 90% 满） |
| 编译 | exit 0；0 undefined；overfull ≥10pt 为 **0** |
| 新增数据 | 三历史摘要预算扫描、重放（rehearsal）实验、9B 伴随研究（附录 A） |
| 表号 | 成本 1 · 指标 2 · 保真 3 · 边际 4 · **三历史 5** · $r$ 阶梯 6 · **重放 7** · 定位矩阵 8（全部 `\ref`，无硬编码） |

---

## 第二轮：RQ 重组、takeaway、probe 缺口

### 1. RQ 重组（§4.1 + §5 标题）

三个 RQ 保留数量，但把"问什么"写实，并各自挂到具体的表：

| RQ | 新标题 | 挂什么 |
|---|---|---|
| RQ1 | **Fidelity.** 写入是否让模型更接近教师，各历史多少 | Tables 3, 4 |
| RQ2 | **Location.** 在什么摘要预算上参数载体反超，位置跨历史是否稳定 | Tables 5, 6 + Fig 1 |
| RQ3 | **Price.** 写入对"不需要历史的题"做了什么，代价能否训掉，还差什么 | Table 7 |

§5.3 从 **5 行** 扩成三段式：①漂移/NLL/贪心三个量（为什么需要三个，分别回答三个不同质疑）+ 表 7；
②能否训掉——重放（方法、λ 的含义、两个事前门、λ=0.5 更差）；③三行分离出什么 + 没测什么。

### 2. 每个 RQ 末尾的 takeaway（各 ≤3 行）

- **RQ1**：写入确实把模型推向教师（三历史 25–28%，摘要之上 17.8%）；第四个历史区间跨零，所以效果真实但不均匀。
- **RQ2**：预算宽时文本赢、预算窄时参数赢，四个历史都如此；符号变化落在 10–256 token 之间，**可迁移的是反转、不是位置**。
- **RQ3**：无关题上的漂移是真的（大于摘要的），重放能去掉九成但要用约一个点的保真度换；**代价属于"不喂无关数据就写"，不属于载体**。

### 3. 图注继续压短

| 表 | 现在 |
|---|---|
| 三历史 | `Summary-budget sweep on the three small histories; KL(T‖·), lower is better. SR@k caps the summary at k tokens; the last column is the engine's own summary.`（删掉"三位小数/full precision in the manifest"与 1989/1086/1178——后者已在 §4.2） |
| 重放 | `Cost of the write on H20, and the effect of rehearsal (64 history plus 16 rehearsal updates).`（CI 从表格移入正文一处） |
| $r$ 阶梯 | 删掉 `KL(T‖R0)=0.3569`（Table 3 的 H20 行已有） |

### 4. 正文去重

§5.3 里原本把表 7 的每个格子都在正文重念一遍（含三组 CI），现在表格只放点估计，**CI 只在正文出现一次**；
删掉 "28.47% becomes 27.60%"、"27.11%, NLL +0.0059" 这类与表格重复的复述。顺带消除了表格 23.2pt 的溢出。

### 5. probe 缺口（本次重点）

三处写入，都指向同一件事：**probe 没有方案，整个设计都吊在它上面**。

1. **§6.3 Limitations 第 (3) 条**（新）：「probe 集是最弱的一环，我们没有选它的程序」——16 条均匀抽样、
   既没定义也没测量"好"是什么；没有覆盖准则、没有抽样框、没有数量/分布的敏感性分析；companion 显示
   **只改每 probe 曝光就足以让训练准确率从 0.32 到 1.000**，所以"probe 太少/太偏"与"载体有上限"在现有
   证据里长得一模一样，我们分辨不出。
2. **§8 Threats → Internal (i)**：从"抽样方差没测"升级为"没有覆盖准则、没有质量度量，无法把载体上限与
   probe 上限分开"，并交叉引用 §6.3。
3. **§3.4 训练目标**：一句 `The probe set itself is a placeholder: 16 uniformly drawn probes, with no coverage
   criterion, is not a designed sample of a history`，把这条弱点钉在方法描述处而不是只留在末尾。

---

## 1. 开场围栏段：内容留，位置下移（你批准的那条）

- 原位置：§1 开场白之后、§1.1 之前（`\paragraph{What this version actually establishes.}`）
- 新位置：**§1.4 贡献列表之后**，并改标题为 `What this paper establishes, and what it does not`
- 正文一字未改，只改了一句连接：`This paper reports` → `What this paper reports is`

理由（如前述）：放在证据之前像致歉；放在贡献之后是"给主张划界"，且与 §6.4 Limitations 不再重复。

---

## 2. 新数据：三历史摘要预算扫描 → §5.2（RQ2）

**新增表 5**：H1/H2/H3 的 R、RD、SR@10、SR@50、SR@200、原摘要（1989/1086/1178 token），KL(T‖·)，三位小数。

**新增两段正文**，结论是：

| 历史 | 反转位置 | 区间检验 |
|---|---|---|
| H1 | 50–200 token | **两端都排除零**（$+0.0650$ / $-0.0568$）——唯一干净夹住的反转 |
| H2 | 10–50 token | 只有 50 端排除零（$-0.0352$）；10 端跨零 |
| H3 | ≈200 token | 200 端不可区分（$-0.0012$，CI $[-0.0193,+0.0169]$） |

**同时撤回了 v3 一句**：原文说 "it is the token figure, not $r$, that could transfer across histories"。
四份历史的反转位置分别是 10–50、50–200、≈200、128–256 → **可迁移的是"存在反转"，不是"位置"**。
新写法：`what transfers across histories is the existence of a reversal, not its location`。

摘要与结论各补半句（"the same reversal appears on three shorter histories at budgets from 10 to 200
tokens"）。

---

## 3. 新数据：重放（rehearsal）→ 新 §6.2 + 表 7

**这是 v3 里唯一一句"已被自家实验推翻"的话**：L3 原写 `rehearsal is a registered design without results in
this version`，现在有结果了。

新 §6.2 `Rehearsal: Attacking the Cost`（label `sec:rehearsal`）：

| | RD（64 步） | 重放 λ=1 | 重放 λ=0.5 |
|---|---|---|---|
| 相关 KL(T‖·) | 0.2553 | 0.2584 | 0.2602 |
| 相关降幅 | 28.47% | 27.60% | 27.11% |
| 无关 NLL 效应 | +0.0349 | −0.0016 | +0.0059 |
| 无关漂移 | 0.02587 | 0.00240 | 0.00316 |

写法要点（全部照实）：

1. λ=1 把漂移压下 **90.7%**，NLL 效应区间**跨零**（"不再可区分于无效应"）；
2. 但**两项事前门都没过**：相关非劣下界 $<-2$pp（$-0.86$pp，CI $[-2.18,+0.69]$），无关 NLL 上界 $>0$
   （$+0.0020$）；
3. λ=0.5 两头都更差，**不据此在 sealed test 上继续扫 λ**；
4. 结论句只推进到可辩护的一步：**代价不是"写分布进权重"的固有属性，而是"不喂无关数据就写"的属性**。

L3 的措辞同步改为："Rehearsal reduces this drift by an order of magnitude at a small fidelity cost, but not
for free (\S\ref{sec:rehearsal})"。

---

## 4. 9B 伴随研究（附录 A）的三处更正

| 位置 | v3/初版 v4 | 现在 |
|---|---|---|
| 附录 A 写预算段 | "KL is nearly flat (0.766 at 16, 0.751 at 64) while top-1 0.29→0.50" | 换成更利落的对照：**4 遍 → 64 遍，KL 0.7230 → 0.7508（变差），top-1 0.220 → 0.497（翻倍）**；并明写"不据此认为 KL 失效，两个量回答不同问题" |
| §8 Threats Construct | "two adapters that differ by 0.015 nats … so KL saturates before behaviour does" | 改为同一对照，**去掉因果解读**："the two metrics answer different questions, so we report them side by side and never read one as the other" |
| 附录 A 反转位置 | — | 保留 540–650 token，并明确"form reproduces, token count does not transfer"；**不写"等价于 500 token"**（报告禁止该读法） |

---

## 5. 一处数字更正

§4.2 三份小历史的摘要正文长度：`1990, 1087, 1179` → **`1989, 1086, 1178`**（以阶段报告的实测值为准，
表 5 图注同步）。

---

## 6. 本轮未做

| 项 | 状态 |
|---|---|
| R01 成本量词、R03 Doc-to-LoRA、R04 固定容量限定、R07 $\rho$/12 CE、R09 摘要干预、R10 Cost 改名 | 仍挂起（第 ⑤ 组） |
| 图 1 重绘（图内 `R` 应为 `R0`、`see report for sensitivity` 无指向） | 仍挂起，需改绘图脚本 |
| `线性注意力继承.md` 的实现路线 | **未改**：阶段报告明确"不能用从头逐层 mask A 冒充状态继承"，要做需 state save/restore；这是设计决策，等你定 |
| 共享前缀 AR、Doc-to-LoRA 准备 | 按判断不写（未验收 / 无结果） |

---

## 7. 验收要点

- [ ] §1.4 贡献列表之后有 `What this paper establishes, and what it does not`，§1.1 之前不再有免责段
- [ ] 表 5 存在且三个历史的反转位置与正文一致（10–50 / 50–200 / ≈200）
- [ ] §5.2 不再出现 "token figure … could transfer across histories" 的可迁移断言
- [ ] §6.2 表 7 的四个数（0.2553/0.2584/0.2602、28.47/27.60/27.11、+0.0349/−0.0016/+0.0059、0.02587/0.00240/0.00316）与正文一致
- [ ] §6.4 L3 不再说 "registered design without results"
- [ ] 附录 A 的 KL/准确率对照是 4 遍 vs 64 遍，且没有"KL 失效"的因果句
---

## 第三轮：9B 从附录提到正文 + 算力交代 + Future Work

### 1. 新 §6.2「A Replication at Another Scale」+ 表 8

9B 不再只活在附录。正文给它一节，**只讲形状、不并列数字**：

| Observation | 9B companion run |
|---|---|
| Crossing | exists; at 540–650 summary tokens |
| Write budget | top-1 0.29→0.50 from 16 to 64 passes; KL moves the other way |
| Off-topic drift | not measured at saturation |

正文三句对应三件事：反转存在但位置不同（可迁移的是"存在"）、写预算在饱和前主导且 KL 与 top-1 反向、
饱和后表格可从 Δ 本身读出（所以"拟合分布"是预算不是属性）。并明写 `replication probe, not a second
experiment` 与 `must not be subtracted from, or pooled with`。

细节（解码探针、未扫轴、协议）仍在附录 A。

### 2. 正文引用改指向

原来 6 处直接引 `Appendix A` 的承重句，改为引新 §6.2；附录只在需要细节时被引：

| 位置 | 改动 |
|---|---|
| §1.4 贡献 (4) | `Appendix A reports…` → `§6.2 reports…` |
| §6.4 L1 / L4 / probe 条 | → `§6.2` |
| §8 Construct | → `§6.2` |
| §8 Internal (iii) | → `the companion run (§6.2) scans to 64 passes at 9B` |

### 3. §8 Threats 新增「Scope of the runs」

按你的要求把**算力与工程成本**写进 TTV：

> One saturated write costs 36 entities × 2,304 updates plus a teacher pass over the full history…the
> engineering around state handling, prefix caching and byte-exact verification cost more than the GPU hours did.
> We therefore did not finish the study: the 27B ladder stops at 16 passes per probe, the saturated regime is
> reported from a 9B companion rather than from this model, and a second seed, a matched-budget cost comparison
> and a wider history set were not run. **What is missing is missing because of cost, not because the hypothesis
> was dropped.**

附录 A 开头也补了同一件事的一句（为什么这条路在 27B 上放不下）。

### 4. 新 §6.5「Future Work」——按你指定的三项排序

1. **Choosing the probes**（写成 the blocker）：没有覆盖准则、没有 probe 质量度量 → 载体失败与 probe 没问到
   分不开，且"这一行的所有负结果都不可解释"；需要抽样框 + 覆盖度量 + 数量/分布的敏感性分析。
2. **History diversity**：四份历史来自同一个生成器（同实体数、同事务语法、同类问题），交叉点与重放权衡都
   只在它们身上测过；需要**结构**不同（代码库、日志流、无类型字段的长对话），不是单纯更长。
3. **Model generality**：同规模第二个模型跑同一五臂协议，而不是在现有模型上再加一个臂。

### 5. 表号

成本 1 · 指标 2 · 保真 3 · 边际 4 · 三历史 5 · $r$ 阶梯 6 · 重放 7 · **9B 8** · 定位矩阵 9。

---

## 第四轮：G/H 覆盖实验（新数据）

### 数据要点（9B，本机，仍不与 27B 互比）

| 组 | 现象 |
|---|---|
| G（形状多样化） | 三种形状全部背到 1.000；留出的 8 个一格探针停在 **0.312**（= 未做形状训练时一样）；同一实体换措辞识别 0.969 |
| H（把格子铺满） | 只加 24 条一字段探针（教师 173 s + 训练 224 s ≈ 7 分钟），留出格 **0.312 → 0.844** |
| H 的 $r^\ast$ | 准确率口径 6.76 → **4.19**；KL 口径 5.50 → 3.16；等价比从 540–650 token 变成 **890–1180** |
| H 对完整历史 | 换问法分层上 Δ 与完整 1309-token 表打平（0.938 vs 0.947），KL 只有一半（0.0890 vs 0.1894）；40 题合计仍差的部分 = 未覆盖的格子 |

### 文章改了四处

1. **表 8 加一行** `Probe coverage`：`a held-out cell stays at 0.31; covering it lifts it to 0.84`
2. **§6.2 新增一段**「What the adapter can answer is the set it was asked about」：56/96 格子训练后留出格仍在随机 →
   Δ 得到的是**被监督的点集，不是实体×字段上的函数**；覆盖后 0.312→0.844；并写两条后果：
   ① $r^\ast$ 是**覆盖度的函数**（6.76→4.19）；② 我们 27B 的 $r^\ast$ 是在稀疏 probe 下测的，**应读作保守下界**
3. **§6.4 L4 改写**：从「correction, not a store, at this budget」改为「**stores what it was asked about,
   not the history**」，并说明这是**覆盖限制而非容量限制**、probe 集才是绑定约束
4. **§6.5 probe 条重写**：有机制、有数字、并加一句 —— **「every $r^\ast$ in this literature should be
   reported with the probe set that produced it」**

附录新增 `Coverage` 段，但只写协议与成本（两组的训练构成、3584/5120 次更新、173 s + 224 s），结果留在 §6.2，
避免两处重复。

### 页数

12 → **13 页**（末页约 35%）。若要压回 12，可去掉 §6.3「An Implication We Have Not Tested」（7 行，纯展望、
无证据）或压缩 §5.2 的两段 caveat；两处都不影响任何数字。

---

## 第五轮：§3 合并、设计空间表、L5 归位

### 1. §3 从 7 节压到 5 节（108 行，每节 21.6 行）

| 前 | 后 |
|---|---|
| 3.1 Notation（19 行） | **3.1 Setup and Invariants**（29 行；同时补回被 v2 丢掉的 I1–I3） |
| 3.2 Write Point（7）+ 3.6 Lifecycle（5） | **3.2 Writing at the Boundary**（11 行） |
| 3.3 Carrier（8） | 3.3 Carrier |
| 3.4 Training Objective（23） | 3.4 Training Objective |
| 3.5 Compression Ratio（9） | **降为 §4.3 的 `\paragraph{Compression ratio.}`** |
| 3.7 Cost Model（35） | 3.5 Cost Model |

同时修掉一个内容洞：**v2 重构时丢掉了 v1 的 `§3.3 Three Invariants` 整块**，而 §1.4 贡献 (ii) 与 TTV (iv)
一直在引用它。已按 v1 原文恢复。

### 2. 新 §4.8 The Design Space + 表 3（按你的六旋钮定义，不是配置值表）

| Knob | 类型与本文做法 |
|---|---|
| 压缩比 $\|S\|/\|H\|$ | 连续；H20 五个预算，短历史各三个 |
| $\Delta$ 容量（rank） | 整数；报 16 与 64 |
| $\Delta$ 层位 | **组合型 $\binom{64}{k}$**；固定 60–63，从未变动 |
| Probe 集 | **没有参数化**；16 条均匀抽样，全部答案位置 |
| 载体类型 | 二选一（低秩 / 残差块）；只做低秩 |
| 写入预算 | 整数；0/16/64/256 更新，每 probe ≤16 遍 |

正文一句话把这张表与 future work 第一条连起来：**空间里有一个轴没有维度，所以无法遍历**。

### 3. L5 归位（按你批准的 D 条）

- L5 现在只留机制：**"按格子存、不合成"是机制性质**；把覆盖例子（0.31→0.84）移到 **TTV Internal (i)**
- "Scope of the runs" 不动（已有 "What is missing is missing because of cost"）

### 4. 表号

成本 1 · 指标 2 · **设计空间 3** · 保真 4 · 边际 5 · 三历史 6 · $r$ 阶梯 7 · 重放 8 · 9B 9 · 定位矩阵 10（全 `\ref`）

### 补充（设计空间表的定稿）

- 表 3 从 6 行扩到 **7 行**：新增 `Summary construction`（categorical：regenerate at cap vs truncate，**未分离**）
- `Δ capacity (rank)` 改为 `16 and 64 reported, 128 prepared and not run`（原文漏了 128 曾准备）
- 正文计数改为 **three swept / two fixed / one not separated / one no parameterisation**（原写 two/four，与七行不符）
- §4.7 末尾补一句：`We did not instrument batch size, wall clock or peak memory, so the cost claims of §3.5 are analytical rather than measured.`——把原配置表唯一独有的价值用一行文字兑现，不新增表
- `Cost Model` 加 `\label{sec:costmodel}` 供上述引用

---

## 第六轮：机制断言清理（§5/§6 逐句审计）

按"机制断言 = 说机制*是什么样*，而非这次测到*多少*"的标准过了 §5/§6。共改 8 处：

| # | 位置 | 改前 | 改后 |
|---|---|---|---|
| 1 | §5.3 | "what we **measure is** a shift of confidence near a decision boundary" | "the drift we measure does not change answers。**We read this as** movement of confidence…which is an interpretation, not a second measurement" |
| 2 | §5.3 | "The cost **therefore belongs to** writing without the off-topic data, **not to the carrier**" | "**Within this setting**—one history, one seed, two rehearsal weights—the cost is not a necessary consequence of writing a distribution" |
| 3 | §5.3 takeaway | "The cost belongs to writing without off-topic data, not to the carrier" | "In this setting the cost is removable rather than intrinsic" |
| 4 | §5.2 | "$r^\ast$ is a property of the **triple** (method, history, summarization policy)" | "**quadruple** (＋**probe set**)，并说明第四项来自 §6.2" |
| 5 | §6.2 | "the adapter then **matches** a full 1,309-token table" | "the two arms are **level on their point estimates**…**no interval is available**, so we do not read it as equivalence" |
| 6 | §6.2 | "it **cannot synthesise** an answer for a cell it was never asked about" | "eight held-out cells at chance (**20 judged positions**)… **we observed no case** in which an unsupervised cell was answered" |
| 7 | §6.2 | "The write budget **dominates** below saturation" | "The write budget **matters** below saturation, **but only inside cells that were supervised**" |
| 8 | §6.3 | "so it **does not carry** the collapse risk" | "the risk **has no mechanism to act through here**; that is a **structural argument, not a measurement**" |
| 9 | §6.4 L1 | "we do **not claim** it stores the content…at the **write budget**…while a **larger budget** can" | "**Distribution fit is not a content claim**…coverage 决定；本文覆盖下它不复现表，companion 全铺时复现" |
| 10 | §6.4 L5 | "**This is a property of the mechanism**, not of this run…composes no new ones" | "**What the carrier answers is what it was asked about**…八格 0.312→覆盖后 0.844…**we saw no case**…coverage, not rank, is the binding constraint **in these runs**" |
| 11 | §6.5 | "acquires the cells it was supervised on **and nothing else**" | "**in our runs** the adapter acquires the cells it was supervised on" |

**同时解除 L1 与 L5 的内部矛盾**（原 L1 说"不存内容"、L5 说"存格子"），并把归因从 **budget** 换成 **coverage**。

§6 里现在只剩一处显式机制断言（L5），且带证据范围（8 格 / 20 判定 / 两组实验）。

---

## 第七轮：按 v4-preprint-review 的 R01–R11 修正

### 批 1：事实与对象（review 判定为真错，已用 artifact 核实）

| 编号 | 改前 | 改后 | 依据 |
|---|---|---|---|
| **R08** | `36 entities × 2,304 updates`（两处 + TTV） | `2,304 updates, 64 passes over 36 probes` | `m31_long.json`：`steps=2304`、`passes=64`；原写法放大 36 倍 |
| **R04** | `0.01597 for a summary plus Δ` | `the two summaries`（并补"两个配对区间跨零，只报排序"） | `h20-drift-ci95.json`：0.01663=S1R、0.01597=S2R，均为摘要臂 |
| **R07** | "decodes that value's identity…0.192 chance…table readable from Δ" | "linear classifier decoded **the next digit** … 0.250 teacher-forced digit positions … 0.192 **majority-class baseline** … conditional decodability, not reconstruction" | `m32_digitdecode`：标签为单个数字；0.192 为多数类 |
| 设计空间表 | `Compression ratio $|S|/|H|$` | `$r=|H|/|S_{\text{body}}|$` | 与 §4.3 定义一致 |
| 引用 | `(\S3.7)` | `\S\ref{sec:costmodel}` | 成本模型已迁至 §3.5 |
| Future work | `same entity count` | `four entities in H1–H3 against twelve in H20` | §4.2 |

### 批 2：推断收窄

| 编号 | 改动 |
|---|---|
| **R01** | 覆盖段重写：不再说"56 of 96 cells"，改为"56 training probes / 八个单字段留出题 0.3125→0.84375"；明写该干预**同时改变训练分布与更新数（3584→5120）**，不隔离事实覆盖或容量；删去"不是函数 / 只获得点集 / nothing else / 未见过一例"等推论；L5 与 §6.5 同步 |
| **R02** | 删掉 `conservative estimate`；改为"27B 交点以其探针集为条件；27B 上同等干预的方向与幅度未测"；`roughly twice` → **1.61×**（6.76/4.19），并注明是曲线派生量 |
| **R03** | 删掉"若代价来自写权重，重放不可能消除它"这一错误前提；改为"权重更新造成的效应本可被另一组更新减小；实验支持副作用对训练目标敏感"，takeaway 同步 |
| **R05** | 摘要与 §1.4：`O(L) per token, not O(1)` → 说明是 per carried token，且 adapter 也有常数逐 token 成本；`paid once` → `paid once on the write side, then at a constant per processed token`；§3.5 的"保真随 \|H\| 增长"改为条件陈述（我们固定 H 扫文本预算）；"same token budget" → "swept token budget with a fixed adapter"；"only option with budget left" → 限定为"文本预算必须小的时候"；"cheap to serve" → "the artifact is small" |
| **R06** | Doc-to-LoRA 段重写：承认其**已在无上下文条件下评估**，不再以"文本消失"为区分；差异改为触发点与测量方式；TMEM 的"trades bandwidth for auditability"改为"监督通道不同"，并注明"带宽更多"是未测假设；§1.3 的"only two forms"加上框架限定与第三类（递推状态）；摘要与 §1.4 的 `first measurement` → `controlled measurement` |
| **R09** | "What transfers across histories"整段重写为"四个历史点估计都反转；只有 H1 两端区间都不含零；位置与样本外稳定性均未确立"；删掉"token count is the more nearly transferable quantity"；takeaway 同步 |
| **R10** | ρ 与"12 core CEs"的具体数值删除，改为定性陈述 + 指向 artifact；决策规则里的 ρ 一并删除；标题 `Three Explanations We Ruled Out` → `Checks on Three Alternative Explanations` |
| **R11** | 表 5 的 H20-S1 不再显示来自另一运行的 0.0946；正文改为"两行各自来自本运行的配对比较，绝对值不复现" |
| 其余 | "看到问题的 selector 只会改善文本侧" → "may change the comparison; we did not evaluate one"；无关题 50 个计分位置改为**合计**；附录 Coverage 与"What it does not settle"合并并修正"differ only in..."；矩阵 CCM 行 A′=n/a → `---` |

### 未做（review 未要求或本版不便）

- 真实运行 seed、batch size、软件路径（A08/A14 建议，属补材料）
- H20 边际行"同运行 SR/SRD 均值"的原始取数（review 说无需重跑，但需从文件补；留待下一轮）
- 图 1 重绘（图例 `R`、`see report for sensitivity`）
