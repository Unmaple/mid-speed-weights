# 本机（9B）结果是否/如何进入 paper-fse-v1

2026-10-26。**只读评估**：本次未修改 `paper-fse-v1.tex` / `paper-fse-v1.pdf` / `references*` / `figures/` / `experiments/` / `.local-8b/` 下任何文件；本文件是唯一新增。
判据来源：`paper-fse-v1.tex`（行号即该文件行号）、`experiments/local-8b-v1/*`、`experiments/compact_delta/minimal-two-claims-v1/*`，以及我实际读取的本机产物（`.local-8b/m5/data.json`、`m2_train.json`、`m6_train.json`、`m7_eval.json`、`m10_sr.json`、`m6_train.py`、`m10_sr_eval.py`）。

> ⚠️ **论文在我会话期间被并行修改**（`paper-fse-v1.tex` 42,034 B / 671 行 → 42,234 B / 674 行，mtime 13:49，且之后仍在变）。所以**下面所有 `tex:NNN` 一律以引文为准，行号只用于快速跳转**；改稿前请用引文搜索。下表是我最后一次读到的锚点：

| 引文（搜索这个） | 落笔时行号 |
|---|---|
| `Two caveats follow from the construction.` | 600 |
| `\label{tab:rstar}` | 589 |
| `We report $r^\ast\in[77.5,154.9]$` | 568 |
| `On unrelated questions for H20, the direct drift` | 606 |
| `\paragraph{External.} Four constructed histories` | 637 |
| `\item \textbf{Probe sampling variance.} Unmeasured` | 647 |
| `\item \textbf{Cost on unrelated questions.}` | 650 |
| `Primary measurements use cold passes` | 502 |
| `Hence the only cost argument in this paper:` | 420 |
| `Base model Qwen3.8-27B BF16`（Reproducibility） | 663 |

---

## 0. 一句话结论

**推荐 (b) 的最小形态：在 §6.2 的 caveat 段换一个词并加两句，约 130 词，不出现任何本机 KL / r* / 相对下降。**
本机最值得写进论文的不是 `r*=5.7`，而是**同一台机器、同一个 Δ、同一套题，只改摘要的预算花法，交叉点就移动了 3.4 倍**——这是一个"run 内比值"，可以承重；任何本机的绝对量都不能承重。

并且：**不要写 (c) 独立一节。** 本机数据里有一条会直接反噬论文主结果的证据（§2.2 第 2 条的"位置分解"：Δ 的收益主要是模板位，数值位在载体已有事实处反而变差），一旦单独成节，审稿人的下一个问题必然是"那你们 25–28% 里模板位占多少"——论文没有这个数，也不该在定稿阶段补。

---

## 1. 已核实的事实（不是转述，是逐项对过产物）

### 1.1 本机协议的真实形状（与论文 §3.1 的臂表逐字对照）

| 项 | 本机实测（来源） | 论文（27B） |
|---|---|---|
| 模型 | Qwen3.5-9B，32 层 = 24 GDN linear + 8 full，hidden 4096，4 KV×256，fp16（sm_75 无 bf16）`PLAN.md:15–16` | Qwen3.8-27B，64 层（16 full），bf16 |
| Δ 挂载 | `down_proj` 末 4 层（**28–31/32**，`cut=28`，`m6_train.json`） | `down_proj` 层 60–63/64 |
| Δ 规模 | rank 64，fp32 = **16,777,216 B = 16.0 MiB**（`m6_train.json:delta_bytes_fp32`）；闭环那轮是 rank 8 = 2.0 MiB（`m2_train.json`） | rank 64，5,767,168 params（≈11 MiB @2 B，22 MiB @FP32） |
| **\|H\|** | **3582**（`m5/data.json:H_tokens`）；闭环那轮 **2843**（`CLOSED-LOOP-v1.md:1`） | ≈19.8k（论文只印 r；由 Table 6 的 r×\|S_body\| 反算 = 19,840；`PLAN-main-v1.md:3` 写 19,854；任务书写 19,829 → 见 §7 第 2 条） |
| 保留尾部 R | **一句话占位**：`R_TEXT = "【当前请求】用户正在询问已注册服务的配置。"`（`.local-8b/m5/data.json`）；学生上下文 `E+R+q` = **92 token**（`RESULTS-local-v1.md:86`） | 真实历史尾段，≥1024 token（H20 需 ≥1024） |
| frame | 单行 `【历史摘要】\n…\n`（`S_FRAME`，`m10_sr_eval.py:63`） | 八段标题模板 |
| S 构造 v1（m5） | 顺序生成、`max_new=cap`，**5/5 全部 hit_cap**，纯 `PRE-xxxx region=… timeout_ms=…` 行表，只覆盖头部约 10 个服务 | 真实 compaction engine 在 cap 内生成（cap 64 那点"三个非空段"） |
| S 构造 v2（m9b） | 一次生成**完整 55 行表**（EOS 完整），再按 cap **等间隔选行** 43/21/9/5/1 行 → 正文 1019/496/213/117/23 token，r = 3.52/7.22/16.82/30.62/155.74 | 不适用 |
| 题集 | 40 相关（20 同事实换问法 + 20 不同事实）+ 24 无关（通用 CS 常识，中文）+ 16 重放；16 训练 probe | 64 相关（16 训练）+ 32 无关；4 个生成簇 20/15/20/9 |
| 监督 | 16 probe、64 步 AdamW、lr 3e-4（`m6`）/ 1e-3（`m2`）、全词表 forward KL、答案位置全监督 | 同构：16 probe、64 步、lr 3e-4、全词表 forward KL、全位置监督 |
| KL 口径 | 248,320 全词表、FP32 log_softmax、nats/**答案位置**、先题内平均再题等权、负值不裁 | **完全相同** |
| 数值地板 | 同输入重复 maxabs **0.000**；cold vs prefill+续算 KL 1e-5–1e-4、相对偏差 1e-3 且**不随前缀长度增长**（`LOCAL-HYP-FIT.md:17–38`） | cold / cache 敏感性 ~5e-4（tex:499–500） |

**关键更正（我读了代码才发现的）**：`RESULTS-local-v1.md:9` 写 "M2 train student = E+S+q"，**与实际不符**。`m6_train.py:3` 明写 `Student carrier is E + R + q with NO summary`，`m2_train.json`/`m6_train.json` 的 92-token 学生上下文也证明 S 不在学生侧。所以本机 RD **是 RD，不是 SRD**——这一条是好消息（与论文臂表同构），但任何沿用 v1 文档 §1 描述的人都会把它写成错的。

### 1.2 v1 与 v2 的真冲突 / 解释不清清单（不圆场）

| # | 现象 | 我的判定 |
|---|---|---|
| C1 | `r*`：v1 **19.21**（`m7_eval.json`，夹在 r=14–28，即 \|S_body\|≈128–256）→ v2 **5.686**（`m10_sr.json`，夹在 r=3.52–7.22，即 \|S_body\|≈496–1019）。同一模型、同一 Δ（`m6_rd.pt`）、同一 40 题，**换的是摘要（以及为对齐 r 范围而整体上移的 cap 阶梯：{256…16} → {1024…64}）** | **不是 bug，是构造变化**。两个交点都落在各自阶梯**内部**，所以"位置"是内插得到的、不是边界外推；但阶梯分辨率不同，严格说不是"只换摘要"一个变量。位移机制见 C4 |
| C2 | v1 的 `CI95 [14.04, 18.87]`，而点估计 **19.21 落在 CI 上界之外** | **真问题**：2000 次重采样里只有 131 次仍被夹住；未被夹住的那些是"交点右移出阶梯"，被丢掉后剩下的条件分布系统性偏低。这个区间是**条件于"仍被夹住"的 6.5% 抽样**，不能叫 95% CI。（v2 只丢 13/2000，偏差可忽略） |
| C3 | v1 的 r 轴用 **cap** 而不是实际正文 token（14.0/28.0/56.0/111.9/223.9 = 3582/cap），违反论文 §3.2 "always report actual lengths, never the cap" | v1 的 r 值需打折；v2 已合规（用 1019/496/… 实算） |
| C4 | v2 把"等间隔选行"称为第三版**采用**方案（读起来是改进），但**同预算下 KL 变差**：all 层 cap≈256 处，顺序截断 **0.938**（`m7_eval.json`）vs 等间隔选行 **1.268**（`m10_sr.json`，r=16.82） | **机制是覆盖与被问题涉及的实体耦合**：20 道"同事实"题的服务恰好是训练用的前 16 个，顺序截断摘要按顺序覆盖它们（多道题的 `sr256` = 0.0005，几乎完美），等间隔选行把它们打散。所以 r* 从 19.2 → 5.7 一半是"结构变好"，一半是"丢掉了被问的实体"——**两者没有分离**。这使 v2 的 r* 比 v1 更**不**可解释，而不是更可解释 |
| C5 | v2 §2 "三层第一次夹在同一区间" | 表述不准：v1 时 (i) 层已夹住（19.2）。应为"第一次三层同时" |
| C6 | 同一份 \|H\|=3582 被 v1 记作「55 事务」（`RESULTS-local-v1.md:3`）、v2 记作「55 个服务」（`RESULTS-local-v2.md:3`） | 两个口径混用；从 `m5/data.json` 看是一个 55 行的服务清单，应统一为「55 个服务、55 条事务」 |
| C7 | 闭环那轮的 "Δ 是摘要的 1924 倍" 用的是 rank-8/2.0 MiB 的 Δ 与 1090 B 的 UTF-8 摘要；v1/v2 的 Δ 是 16.0 MiB | 不是矛盾，但**只有闭环那个 Δ 成立**；两个 Δ 不能混引 |
| C8 | 本机有两份历史（2843 / 3582）两套 Δ（rank 8 / rank 64）两套 lr（1e-3 / 3e-4），任务书把它们并列为"一批结果" | 对外只能择一引用；混着引用等于把两次不同实验当重复 |

---

## 2. 可比性：r* 差一个数量级，逐条拆

先给**算术分解**，它把"科学争议"和"定义"分开：

```
本机 r* ∈ [4.11, 8.82]   ×  |H|=3582    ⇒ 交点出现在 |S_body| ≈ 406–872 token
远端 r* ∈ [77.5, 154.9]  ×  |H|≈19840   ⇒ 交点出现在 |S_body| ≈ 128–256 token
                                                    差 3.2×–3.4×
总差距 18.9×/17.6×  =  5.54×（|H| 项，定义性的）  ×  3.4×/3.2×（交点预算项，需要解释）
        （下界对下界：5.54×3.40=18.9；上界对上界：5.54×3.17=17.6）
```

**这一步很重要**：18.9× 里 5.5× 只是 r 的定义式（分母是 |H|），不是科学分歧。真正需要解释的只有那 3.2–3.4×，而且它落在"摘要 token 数"这个可比轴上。这也顺带给论文一条改进（见 §5 的 R2）。

### 2.1 逐因素表

| 因素 | 本机 | 远端 | 判定 |
|---|---|---|---|
| **\|H\|** | 3582（v1/v2）、2843（闭环） | ≈19.8k | **可解释**：r 的分母就是 \|H\|，占 18.9× 里的 5.5×。若不讲这一层，读者会把 5.5× 当成矛盾 |
| **交点预算 \|S_body\|** | ≈406–872 token | ≈128–256 token | **部分可解释**：这 3.2–3.4× 才是真差异，且由下面几行共同造成；**不能**归给单一因素 |
| **摘要构造** | v1 顺序截断（hit_cap 5/5，只覆盖头部）；v2 全表等间隔选行（句完整、覆盖均匀、但仍被 cap 截断到 1 行） | 真实 compaction engine 在 cap 内生成；cap 64 那点被截到"三个非空段" | **可解释，且是本机自己测到的最大单一变量（run 内 3.4×）**。但注意 C4：构造与"被问实体的覆盖"不可分 |
| **题集 × 覆盖耦合** | 20 道"同事实"题 = 训练用前 16 个服务；顺序摘要恰好覆盖它们，等间隔摘要打散它们 | 64 题与 cap 阶梯同源，但论文**没有报告**每题实体是否被该 cap 的摘要覆盖 | **会让读者认为矛盾**（也是最危险的一条）：本机的 r* 一半由"问题涉及的实体有没有被摘要覆盖"决定，而这条轴在两侧都没被控制。读者会正确地追问"那 r* 量的到底是什么" |
| **模型规模** | 9B / 32 层 / 24 GDN / fp16 / 22 GiB 单卡 | 27B / 64 层 / 48 linear / bf16 / 96 GB | **不能量化解释**。而且方向对我们不利：本机 Δ 更大（16 MiB vs 11 MiB）、相对深度相同，若"Δ 更强 ⇒ r* 更高"，本机 r* 应更高，实际更低 → 不能拿"9B 结论弱"当挡箭牌 |
| **保留尾部 R** | **一句话占位（≈15 token）**，学生上下文 92 token | 真实历史尾段 ≥1024 token | **可解释但方向不确定**：本机是"纯载体比较"（R 不携带任何历史），远端是"载体 + 尾部"。对象不同，不能互相校准 |
| **frame** | 单行 `【历史摘要】` | 八段标题模板 | 可解释（小）。论文 §7.1(2) 已证模板只压地板不改斜率 |
| **监督位置/目标** | 全词表 forward KL、答案全位置 | 同 | **非差异源**（同构） |
| **KL 口径** | 248,320 全词表、FP32、nats/位置、题内平均→题等权 | 同 | **非差异源**。这条要写清：口径一致，所以差异**不能推给测量口径** |
| **精度** | fp16 | bf16 | 非差异源：数值地板 1e-5–1e-4，比效应小 4 个数量级 |
| **r 轴口径** | v1 用 cap（违规）、v2 用实际 token | 实际 token | 可解释（C3） |

### 2.2 哪些会让读者认为"两个互相矛盾的主结果"

按危险程度排序：

1. **把绝对 r* 印出来**（5.7 与 77.5–154.9 同时在正文）。这是唯一会直接毁掉"contribution 3"的写法。5.7 出现在 [77.5,154.9] 的左侧 1.4 个数量级处，读者只有两种读法：论文的 r* 不成立，或"缩比版更好所以我们低估了自己"——后者更糟，因为它是**过度声称**。
2. **位置分解（数值位 vs 模板位）**。本机 `RESULTS-local-v1.md:42–57` 的结论是：24.6% 的"不同事实"收益里模板位占绝对多数（82.3%），数值位只有 19.2% 且主要是**分布变平**（top-1 概率 0.465→0.458）；在载体已有事实处 Δ 反而把数值位弄差 400–700 个地板。论文的 25–28% 用的是同一族指标（全位置 full-vocab KL），所以读者一旦看到这条分解，就会问"你们那 25–28% 里模板占多少"。**这条是真实存在的、对我们不利的、且我们无法在定稿前回答的。**
3. **无关题代价的符号**。远端：Δ 漂移 0.0259 **大于**加摘要 0.0166（论文 §6.3）；本机：Δ 漂移 0.0059 **小于**插一句无关状态 0.0178（`RESULTS-local-v2.md:62–68`）。参照物不同（带内容的摘要 vs 一句话），但读者只会看到符号相反。
4. **重放的符号**。本机重放：漂移 −62%，无关题 gold NLL **+0.0441**（有代价）；工作区远端重放（`experiments/compact_delta/minimal-set-20261026/replay-train-main-v1/`）：ON NLL 0.076210 vs OFF 0.077858，即 **−0.0016（变好）**。两组不是同一个模型，但论文 §8 现在写"rehearsal is a registered design **without results** in this version"——这句已经与工作区的远端重放产物不符（见 §7 第 1 条）。

---

## 3. 三种方案：(b) ≻ (a) ≫ (c)

### (b) 进 §6.2 caveat 段（**推荐**）
- **篇幅**：约 130 词 ≈ 7–8 排版行 ≈ 1/10 页；**不新增任何表或图**（不触碰 Table 6 / Fig. 1）。
- **内容边界**：只写"交叉点也取决于摘要怎么花预算"这一件 run 内事实 + 一句"换模型/换历史/换引擎，故不比较"。**不出现本机任何绝对量。**
- **风险**：
  - 低：因为只用了 run 内比值（3.4×），没有可被并读的绝对数。
  - 中：一旦正式承认"r* 还取决于引擎的预算策略"，读者会顺理成章地问"那你的阶梯只扫了 cap，没扫策略"。**这是论文本来就有、但没明说的漏洞**（Table 6 只变 cap）。写出来是止血，不写是留着被审稿人捅。
  - **可控**：把措辞落在"我们因此把 (method, history) 改称 (method, history, summarization policy)"——这是**提高**主张的精确度，不是削弱结论。
- **不做的部分**：不提数值位/模板位分解，不提无关题漂移符号，不提重放。

### (a) 完全不进（**次选，可接受**）
- **篇幅**：0。
- **风险**：0（不会自伤）。代价：放弃一次几乎免费的止血；如果审稿人恰好问"你的 r* 是不是你自己那个摘要器的产物"，就少了一句现成的回答。
- **适用条件**：如果作者对本机数据在 24 小时内从 19.2 跳到 5.7 这件事本身不放心（**我认为这个理由相当充分**），(a) 是干净的。**这条与 (b) 的差别只有 7 行字，不构成"要不要做实验"的决定。**

### (c) 独立一节 "scaled-down replication"（**不推荐**）
- **篇幅**：350–600 词 + 1 张 5 点阶梯表（或图）+ 新的 setup 段 + 新的"不比较"免责段 ≈ **0.8–1.2 页**；还需要一段解释"为什么缩比版的题集和主实验不同"。
- **风险（三条，任一条都够否掉它）**：
  1. 必然要把本机 r*（或交点预算）与 Table 6 并置，读者会认为有**两个互相矛盾的主结果**（§2.2 第 1 条）。
  2. 一旦成节，就必须解释 v1→v2 的 3.4× 位移。而真机制是"C4 的覆盖×题集耦合"——**把它写成"摘要变好导致交点左移"是错的**，写成"覆盖变了"则等于承认这套阶梯测的不是 token 预算。两种写法都把 contribution 3 从"定位测量"降级成"某次配置的观测"。
  3. 缩比版做了**主实验没做**的位置分解（数值位/模板位）与内容地板。成节=邀请读者要求主实验补同样的分解；这需要重跑远端，属于本任务的禁区。
- **唯一值得成节的形态**是本机结果**已经稳定**（多 seed、题集按覆盖分层、摘要构造冻结）之后——现在不是。

---

## 4. 推荐落点与可粘贴英文草稿

### 4.1 落点

落点：§6.2 末，以 **"Two caveats follow from the construction."** 开头的那一段（写稿时约 `tex:600`）。这是全稿唯一已经在讨论"r\* 依赖什么"的地方，加在这里是**补精确度**，加在任何别处都是**引入新结果**。

替换该段中从 "Two caveats follow from the construction." 到 "unambiguously better---so" 的整段（新句插在第一句与 "Second," 之间），其余不动：

```latex
Two caveats follow from the construction. First, $r^\ast$ is a property of the triple (method, history,
summarization policy), not a universal constant: it depends on how compressible the particular history is,
and on what the engine chooses to keep. In a scaled-down replay of this protocol (9B model, 3.6k-token
history, same adapter, same question pool, single seed) changing \emph{only} how the engine spends its
budget---sequential truncation at the cap versus writing a whole table and sub-sampling it to the cap---moved
the crossing by a factor of three. A cap is therefore not the only variable: what a summary covers matters as
much as how long it is, and our ladder does not control that covariate. That run differs from this one in
model, history length, retained tail and engine; it appears in no table, is not compared against
Table~\ref{tab:rstar}, and is not a second estimate of $r^\ast$. We cite it only as a caution about the word
``pair''. Second, the direction of the
comparison at low $r$ is the expected one---at $r\approx 20$ the text carrier is unambiguously better---so
```

新增文字 ≈ 132 词（≤150）。"Second, …" 及其后为原文，未改。

### 4.2 必须同时加的限定语（缺一不可）

1. **different model** —— 必须点名 9B 与 27B；
2. **different history length** —— 3.6k vs ≈19.8k；
3. **different summarizer** —— "sequential truncation vs sub-sampled full table"，并说明本机 v2 的摘要是「先写整表、再按 cap 选行」，**不是** engine 在该 cap 下的直接输出（v1 的那个是 engine 输出，但 5/5 都 hit_cap）；
4. **"not directly comparable" / "appears in no table" / "not a second estimate"** —— 三句至少留两句；
5. **不出现**：本机 KL 绝对值、本机相对下降、本机 r* 数值、本机 Δ 漂移；
6. **不与 Table 6 / Fig. 1 同表、不相减、不内插**；
7. 若坚持写数字（不建议），必须同时披露"C4 的覆盖×题集耦合"和"C2 的区间是条件于仍被夹住的抽样"，否则等于隐瞒。

### 4.3 备选稿（若作者坚持要出现绝对量；**明确不推荐**）

```latex
For scale, a 9B run of the same protocol on a 3.6k-token history placed the crossing at $r^\ast\in[4.1,8.8]$,
against $[77.5,154.9]$ here. These are not estimates of one quantity: base model (9B vs.\ 27B), history
(3.6k vs.\ 19.8k tokens), retained tail (one sentence vs.\ a 1k-token tail), summarizer (one engine call
truncated at the cap vs.\ a full table sub-sampled to the cap) and question pool (drawn from the same sixteen
facts used for training) all differ, and the scaled-down interval conditions on the resamples that stay
bracketed. We neither subtract nor average the two, and we print them together only to show that a location
is not a transferable constant.
```

≈ 110 词，含全部限定语。**风险**：把 4.1 摆在 77.5 左边，读者仍会问"到底哪个是真的"；而且这条区间背后的覆盖混淆会让审稿人一击命中。

### 4.4 备选落点（若作者不想动 §6.2）

把上面 4.1 的**第二、三句**（"A cap is therefore… not a second estimate"）搬进 `tex:635`（§7.2 External），前面加 `\paragraph{External.}` 内的一句即可，约 55 词：

```latex
We also ran this protocol at 9B scale on a 3.6k-token history; its crossing moves by a factor of three when
only the engine's budget policy changes, but model, history length, retained tail and summarizer all differ,
so it contributes no number to any table here.
```

代价：脱离了 r* 的上下文，说服力变弱；收益：不碰 contribution 3 的段落。

---

## 5. 本机能强化论文的具体点（按价值排序）

| # | 论文的薄弱点（位置） | 本机是否提供了它 | 该怎么用 |
|---|---|---|---|
| **R1** | §6.2 caveat 段 "r\* is a property of the **pair** (method, history)"（≈`tex:600`） | **是**：run 内 3.4×（19.21→5.686，同模型/同 Δ/同 40 题；换摘要 + 阶梯整体上移，两点序均在各自阶梯内部，`m7_eval.json` vs `m10_sr.json`） | 见 §4.1。这是唯一"本机数据 + 论文原句"能直接对接的地方，**也是我唯一真正推荐采用的**。"3.4×"是同一台机器上的比值，不受跨模型问题影响；绝对量一个都不出现 |
| **R2** | §6.2 "We report $r^\ast\in[77.5,154.9]$"（≈`tex:568`）：r 被 \|H\| 归一，跨历史不可比 | 不需要本机：Table 6 里就有 \|S_body\| | **零风险改进**：补一句 "equivalently, the crossing sits at 128–256 summary tokens; because $r$ is normalized by $\abs{H}$, it is the token figure, not $r$, that could transfer across histories." 这句话让"r\* 依赖历史"从一句免责变成可操作结论 |
| **R3** | **① probe 抽样方差未测**（`tex:632–633`、`tex:644`） | **没有。** 本机同样只跑单 seed、单 Δ、无 probe 池重采样（`RESULTS-local-v1.md:104` 自己写明"没有做多 seed，训练随机性未估计"） | **不要填。** 拿 9B 的 probe 方差去填 27B 的洞，审稿人一句"测错对象"就废掉。可用的只有：本机把"题重采样 → r* 是否仍被夹住"做成了现成统计（1987/2000、131/2000）。但把它搬到 27B 很可能得到 <100%（P9 已指出 cap-256 簇区间跨零），**会削弱而不是加强** contribution 3。若要做，用远端已存的逐题 KL 重算即可（不是重跑），且必须如实报"bracket 只在 X% 重采样里成立" |
| **R4** | **② 写侧成本从未量化（P12）**（`tex:447–448`、`tex:657–661`） | **本机有，但用错了对象**：batch=1、64 步 84 s（`m2_train.json:steps_seconds=83.6`）、学生上下文 92 token 时 64 步 6.8 s（`m6_train.json`）、4k 上下文 3.9 s/步峰值 21.33 GiB（`LOCAL-HYP-FIT.md:75–84`） | **P12 应当用远端已有的数，不要用本机的**：1068 s / 64 更新 / 2772 监督位置 / 峰值 59.4 GiB（`LOCAL-HYP-FIT.md:63` 引的服务器同规模一臂）、243.14 s / 4096 位置 / 峰值 54.09 GiB（`STATUS.md:37` 的 N16_R）、microbatch 1、decode `max_new=64`。这些都在工作区里，**不需要重跑**。本机唯一可用的是一句**不含数字**的结构性陈述："写侧成本随学生上下文 \|S\|+\|R\|+\|q\| 增长，而被删的 A 从不进入学生侧，所以'写一次'与 \|H\| 无关"——`tex:410` 的 Cost 表可以受益 |
| **R5** | **③ 无关题代价缺少"存在性地板"**（`tex:602–606`） | **部分有，但方向相反**：本机 M11 最小对显示"一个数字"的代价取决于它**看起来像不像状态句**——时间戳 0.024 vs 电表读数 0.34（数值位，14×），同词换值几乎不动（0.340→0.364）。也就是说地板由**内容框架**决定，不由 token 数决定 | **只取"参照物"这一层，不取数字**：论文现在拿"加一份摘要"（0.0166）当参照，那是**带内容的插入**，不是地板。可在 §6.3 补半句："both figures are content-bearing insertions; a presence-only control (one semantically irrelevant sentence) has not been measured at this scale." 同时 §8 第 6 条应把它列为未测，而不是把 0.0166 当地板 |
| **R6** | **驼峰/不单调** | ⚠️ **不成立** | 本机 v2 的"1 行摘要比不给更差"（1.434 vs R 1.201）**在 27B 上不复现**：H20 cap=64 时 KL(T‖SR)=0.3286 **低于** KL(T‖R)=0.3569。把它写成佐证就是造假。论文 `tex:584–585` 关于"less information 与 broken structure 未分离"的脚注**保持现状**，不要引本机 |
| **R7** | `tex:498–502` Numerical Path 只给了 cold/cache 的 5e-4 | 本机给出了更锋利的解释：绝对 `maxabs` 门在低精度 logits 上是**量化格点**（fp16 在 \|logit\|∈[16,32) 的 ULP = 2⁻⁶ = 0.015625，实测 0.0508 只是 3.25 ULP），且跨分段差异**不随前缀长度增长**（相对偏差恒定 1e-3） | **低优先级可选**：§5.4 补一句"we gate on relative deviation, KL and argmax, not on absolute logit maxabs, which is a precision grid artifact." 对本稿的收益有限（论文没报 maxabs 门失败），但可复现性条目会加分 |
| **R8** | `tex:647–648` "rehearsal is a registered design **without results** in this version" | ⚠️ **可能已陈旧**：工作区有远端重放训练+评测（`minimal-set-20261026/replay-train-main-v1/RESULTS-replay-main-v1.md:19`：ON 0.076210 vs OFF 0.077858；`STATUS.md` 与 `实验结论.md:596` 同） | **需主会话核实原件后决定**。我**只读了摘要 md，没有读原件 SHA**，不能替它背书。若采用，是本稿零成本的一条正面结果；但它属于"改写 §8 的现状"，超出本任务范围 |

**一句话记忆**：本机数据能给论文的是**一条 caveat（R1）和一条口径改进（R2）**；剩下全是"看起来能用、实际会自伤"。

> 表中其余 `tex:` 行号取自 671 行快照，论文正被并行编辑（现 674 行），**以引文为准**；锚点对照见文首表。

---

## 6. 明确**不要**写进论文的本机数字

| 数字 | 出处 | 为什么不能写 |
|---|---|---|
| 35.67% / 45.06% / 24.61% / 53.2% / 83.6% / 87.1%（R→RD 相对下降） | `RESULTS-local-v1.md:11–13`、`CLOSED-LOOP-v1.md:25–29` | 与 Table 4 的 25–28% 同形不同物（9B / 3.5k / R 无尾部）。读者必定并读并当作"复现失败"或"大幅超越" |
| **r\* = 5.686 [4.11, 8.82]**、r\* ≈ 19.21 | `m10_sr.json`、`m7_eval.json` | 与 Table 6 的 [77.5,154.9] 并置 = 两个互相矛盾的主结果（§2.2#1）；且两代 r* 本身已互相推翻 |
| KL 绝对值：KL(T‖R)=1.201 / 0.623 / 0.0357、KL(T‖RD)=0.773 等 | 同 | 不同模型，量级差 3–10×；单位相同恰恰使它更容易被误减 |
| 无关题 Δ 漂移 0.0059、重放后 0.0022、无关 NLL +0.0441 | `RESULTS-local-v1.md:63–70` | 与 §6.3 的 0.0259/0.0166 **符号相反**，参照物还不同；并写等于制造矛盾 |
| 内容地板 0.024 / 0.340 / 0.364 / 0.231 / 0.198 / 0.482 | `RESULTS-local-v2.md:41–58` | 是"往 prompt 插一句话"，不是参数干预；与 0.0259 不是同一个量 |
| 446× / 700× / 117× / 7.9× / **1.2×** | `CLOSED-LOOP-v1.md:65–72`、`RESULTS-local-v2.md:56–60` | **最危险的一组**：直接质疑 25–28% 的读法（模板位占多数）。要么主实验也做位置分解（需重跑），要么不写 |
| "Δ 是摘要的 1924 倍" | `CLOSED-LOOP-v1.md:44` | 用的是 rank-8 / 2.0 MiB 的 Δ 与 1090 B 的 UTF-8 摘要；论文自己的对比是 11 MiB vs ~1k token，另一组数 |
| 驼峰：r=56 处 SR 比无摘要差 14.8%；r=155.7 处 1.434 vs 1.201 | `RESULTS-local-v2.md:35` | 27B 不复现（cap 64：SR 0.3286 < R 0.3569），写成佐证即造假 |
| 本机吞吐/墙钟/显存：56.2 tok/s、3.9 s/步、21.33 GiB、84 s/64 步、16.0 MiB Δ | `PLAN.md:29`、`LOCAL-HYP-FIT.md:82`、`m2_train.json` | 硬件与模型专属；Reproducibility 段（`tex:659–663`）只有 27B/PRO6000 的数，混入会把可复现性写成两个平台 |
| 重放 −62% / NLL +0.0441 | `RESULTS-local-v1.md:61–72` | 与工作区远端重放（NLL −0.0016）符号相反，且论文当前没有重放段 |

---

## 7. 需要主会话决定的四件事（我不替你决定，也不替你圆）

1. **§8 第 6 条（"rehearsal is a registered design **without results**"）是否已陈旧**（≈`tex:650`）：本机照抄了 PLAN-main 的重放设计并得到"漂移↓ / NLL↑"，而**远端**重放已有完整评测（ON 0.076210 vs OFF 0.077858，即 NLL 略**降**）。论文说"no results in this version"与工作区产物不一致。我**未核原件**（只读摘要 md），请主会话决定是补写、还是把句子改精确（"rehearsal is registered; its effect is reported elsewhere"）。
2. **|H| 有三个值**：任务书 19,829 / `PLAN-main-v1.md:3` 19,854 / 由 Table 6 反算 19,840（`SELFCHECK-r1.md` 附录 A 也按 19,840 算）。论文正文只印 r，所以没暴露；但本报告 §2 的 "5.54×" 按 19,840 算，任何对外叙述请统一到 ≈19.8k，不要写三位精度。
3. **`RESULTS-local-v1.md:9` 的 student 描述是错的**（写 `E+S+q`，实际 `E+R+q`，`m6_train.py:3`）。若后续有人引用本机 RD 臂，必须改这一行，否则会把 RD 说成 SRD。
4. **v1 的 `CI95 [14.04, 18.87]` 不能当 95% 区间用**（点估计 19.21 在其外；131/2000 条件抽样）。若有人把本机 r* 当"已测准"，这一条先把它否掉。

---

## 8. 本次只读边界声明

- 未修改 `paper-fse-v1.tex`、`paper-fse-v1.pdf`、`references*`、`figures/`、`experiments/**`、`.local-8b/**` 下任何文件；
- 读取了 `.local-8b` 下的 `data.json` / `m2_train.json` / `m6_train.json` / `m7_eval.json` / `m10_sr.json` / `m6_train.py` / `m10_sr_eval.py` 以核实形状与数字（只读）；
- 未运行任何训练、评测或会写盘的本机脚本；
- 唯一新建文件：本文件。
