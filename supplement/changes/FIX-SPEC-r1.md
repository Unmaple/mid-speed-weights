# 修改需求书 r1 — `paper-fse-v1.tex`

**用途**：给外部复核者（无本项目上下文）逐条验收本次修改。不是论文内容，是变更说明书。

| 项 | 值 |
|---|---|
| 被改文件 | `E:\MasterStudy\AdVance ComPact\paper-fse-v1.tex`（751 行，SHA256 `46068CF7…C538D`） |
| 产物 | `paper-fse-v1.pdf`（9 页，SHA256 `C1A95565…55FDCB`，PDF 字节级会因重编时间戳变化——以 `.tex` 的 hash 为准） |
| 编译 | `$env:TECTONIC_CACHE_DIR='…\tools\tectonic\cache'; .\tools\tectonic\tectonic.exe -r 3 paper-fse-v1.tex` |
| 编译结果 | exit 0；9 页；0 undefined reference / 0 missing citation；overfull hbox ≥10pt 为 **0** |
| 依据 | `SELFCHECK-r1.md` 中 T3 级「仍必须改」清单 P1–P7 |
| 性质 | 只改措辞与可核性，**未新增任何实验、未改任何数字、未改标题、未改章节结构** |

---

## 0. 这次只做什么

论文是一篇**测量型**报告（提出一个载体 + 测它的分布距离与成本），主张是「压缩边界写参数」这一行为，
不是「模型记住了内容」。本次修改的唯一目标是：**让正文里每句可被检查的话，都能被读者当场检查或当场证伪**。
因此不补实验、不补页数、不补图。

---

## 1. 变更清单（8 项 + 3 项附带）

线号均指修改后 `paper-fse-v1.tex`。

### A. P3「等成本」——全文最实质的一处（3 处联动）

原稿三处说 "equal(-)cost/token cost"，但 §3.4 的成本表本身说两边成本**形状不同**（文本按 token 计、进入被注意
序列，单位成本 $O(L)$；$\Delta$ 写一次、用时 $O(1)$），且全文没有定义"等"的是哪个量。这不是措辞问题，是
**自相矛盾**。

| # | 位置 | 改前 | 改后 |
|---|---|---|---|
| A1 | `tex:69–70`（摘要） | `compare it at equal token cost against the output of a real compaction engine` | `compare it against the output of a real compaction engine whose summary budget we sweep over a 16× range while Δ's cost is held fixed` |
| A2 | `tex:219–221`（§1.4 贡献 2） | `into a clean equal-cost comparison rather than a benchmark race` | `into a comparison of cost shapes, a curve rising in |H| against a horizontal line, rather than a benchmark race` |
| A3 | `tex:473–476`（§3.4 新增段） | —（原无） | `No normalization is applied or implied: the two sides are not costed in a common unit, and we do not claim they are. What is held fixed is the supervision input (the same boundary, R, q and decode budget); what is swept is the text carrier's budget. The claim is only that Δ's cost does not move as that sweep narrows—not that the two carriers cost the same.` |

**决策理由**：不发明一个归一化换算去保住 "equal cost" 这个词——那才是构造。可辩护的主张本来更强：
**文本侧预算是扫的（$r$ 从 19.8 到 309.8），$\Delta$ 侧是恒定的**。把词换掉，事实不变。
"16×" 的来历：$309.8/19.8=15.6$，取整为 16。

**请复核**：A3 与 §3.2 对 $r$ 的定义（`tex:425–431`，$r=|H|/|S_{\text{body}}|$，分母不含 frame 与模板头）
是否一致；A1 的 "swept over a 16× range" 是否与 Table 6（`tab:rstar`，caps 1024→64）吻合。

### B. P2 标题 vs §1.4 免责清单——**不改标题**，改摘要

标题 `Remember Rather Than Hand Off` 讲的是**状态存在哪**（权重 vs 以文本交出）；§1.4 的 *What we do not claim*
讲的是**记住什么**（输出分布，非内容）。二者不矛盾，但读者会误读成矛盾。

| # | 位置 | 改动 |
|---|---|---|
| B1 | `tex:76–77`（摘要末） | 新增一句：`Everything measured here concerns *where* the state lives, not what it can recall.` |

**请复核**：这句是否足以让标题与 §1.4（`tex:233–236`）不再被读成打架；是否新增了任何未测量的主张（不应有）。

### C. P4 四份 history 无定义——新增 §5.1

原文只有 "four constructed histories" 六个字，读者读到 Table 4 第一行（25.09%）时无法知道测在什么对象上。

| # | 位置 | 改动 |
|---|---|---|
| C1 | `tex:519–528` | 新增小节 `§5.1 Histories and Questions`：来源（同一生成器的合成 agent 会话，非真实用户会话）、H1–H3（四实体 / 36 个结构化事务 / 各约 7.1k token / 摘要正文 1990、1087、1179 token，故同 cap 下 $r$ 不同）、H20（19.8k token，104 个事务、12 个实体，两版摘要 $S_1$ 正文 1002 token 与 $S_2$）、每题集 16 train / 8 val / 64 test + 同 32 道无关题、以及"四份 history 内容不同，重复出现不是抽样" |

**新增事实的唯一来源**（不得凭空）：`实验结论.md`
- 第 39 行：`三份合成历史约7.1k序列化 token，每份四实体、36个结构化事务；S 分别为1990、1087、1179 token，R 包含四实体中三个的最终 audit`
- 第 200 行：`选中104个事务…独立实现的状态机重放104个事务、12个实体、九类事件`
- 第 202 行：`19,851 token 的篇幅`（论文按 $r$ 的口径写作 "19.8k"，两者差 11 token，均为约数表述）

**请复核**：是否把我写的每个数追回到上面三行；"16/8/64 + 32" 是否与 §5.2、`Reproducibility`（`tex:736–737`）自洽。

### D. P5 "auditable" 无 artifact 声明——改成可兑现，不编 URL

| # | 位置 | 改动 |
|---|---|---|
| D1 | `tex:739–741`（Reproducibility） | 新增：`Each table has a manifest listing the input files it was computed from, the raw tensors, and the SHA-256 digests and base-model commit hash of both; the manifests and statistics scripts are available from the authors on request.` |

**决策理由**：不写不存在的仓库地址或 DOI（会变成第二个 P5）。"on request" 是可兑现的最弱承诺，
同时把粒度说清楚（每张表一份 manifest、含 SHA-256 与基座 commit），读者能据此索要**具体**文件。

**请复核**：这句是否与 §5.5（`tex:568–570`，"Every run stores raw tensors and SHA digests"）重复或冲突；
是否过度承诺（原文没说"公开"）。

### E. P6 符号一符三义——只需一句消歧

$R$ 在 §3.1 是"保留的尾段"，而 $\mathrm{KL}(T\|R_0)$ 里的 $R_0$ 是"无记忆 arm"。读者无法判断表里的 $R_0$ 是尾段还是 arm。

| # | 位置 | 改动 |
|---|---|---|
| E1 | `tex:417–419` | 新增：`The bare symbol R always names the retained tail; the no-memory arm always carries its label, R0 = E+R+q. Every KL(·‖·) below is between model states, never between a state and a token sequence.` |

**请复核**：全文表格与正文是否已统一用 `R0`（`\armR` 宏）；$W$ 的定义是否仍存在（`tex:135`：`the model window $W$ (up to one million tokens here)`）。

### F. P7 定位表的 9 个系统无引用——已随文献补齐关闭

Table 1 的 14 行现在全部挂 `\cite`（文献 35 → 46 条）。本次只加半句 caption：

| # | 位置 | 改动 |
|---|---|---|
| F1 | `tex:319–322`（Table 1 caption） | 追加：`Rows are representative, not exhaustive: each judgment reflects our reading of the cited work, and × on a column means the cited system does not do that thing, not that it does it badly.` |

**请复核**：这句是否削弱了"合取为空"这一主张（不应削弱——它限定的只是行的穷尽性，不是判据本身）。

---

## 2. 附带改动（不在 P1–P7 内，但同一类缺陷，请一并复核）

| # | 位置 | 改动 | 原因 |
|---|---|---|---|
| G1 | `tex:444–445` | `\subsection{Cost Model}` 后新增 `Table~\ref{tab:cost} gives each carrier's cost on the write side and the use side.`；并加 `\label{tab:cost}`（`tex:461`） | 原标题下**只有表、没有正文**，表浮走后两个标题直接相邻 |
| G2 | `tex:530–534` | `§5.2 Three Metric Families` 新增 4 行正文（"三族不可互换：漂移小不是保真证据，似然不是分布"）；加 `\label{tab:metrics}`（`tex:549`） | 同上，且这是全文指标定义处，缺正文等于没定义 |
| G3 | `tex:585–586`、`\label{tab:fit}`（`tex:602`）、`\label{tab:marginal}`（`tex:623`） | `§6.1 Distributional Fit` 新增一句指路，并给 Table 4/5 加 label + `\ref` | 结果章两张核心表此前从未被正文引用 |
| G4 | `tex:16–18` | 导言区 `\setlength{\emergencystretch}{1.5em}` | 修 3 处跨栏溢出（46.8pt / 23.9pt / 22.1pt → 0）。**这是唯一一处版式改动，不触碰内容** |
| G5 | `tex:410`、`tex:412` | 臂表描述由 `full-context teacher (empirical reference)` → `full-context teacher`；`output of the real compaction engine` → `output of the compaction engine` | 该 `align*` 此前 15.7–29.8pt 溢出到栏外；"empirical reference" 的语义在 §3.4（`tex:509`）保留 |

---

## 3. 明确不改的（请勿按"应该改"处理）

1. **标题不改**。理由见 B：标题说的是状态位置，不是记忆内容；把它换成描述性标题会丢掉预印本唯一的记忆点，
   而误读已由 B1 一句消解。
2. **不发明 "equal cost" 的归一化公式**。理由见 A。
3. **不写仓库/DOI/artifact 链接**。理由见 D。
4. **不补 CCS Concepts、不切匿名版**。这是投稿版要求，本稿是署名优先预印本（`tex:38–41` 已写明一行切换法）。
5. **不补实验**。所有改动都不引入新数字。

---

## 4. 仍然开放、本版故意不动的问题

| ID | 问题 | 位置 | 为什么不挡发 |
|---|---|---|---|
| P9 | $r^\ast$ 左端点 $r=77.5$ 的配对 CI 上界贴近 0（$[-0.0897,-0.0010]$），正文未提其脆弱性 | `tex:631–637` | 已报区间且声明"不插值单点"，读者可自行判断 |
| P11 | 42 MB 设计预算 vs 3×11 MiB ≈ 33 MiB 算不平 | `tex:141`、`tex:227` | 已写明"设计目标，不是结果"；真要改需给每层参数量 |
| P12 | 写侧成本无数（batch size、平均 answer 长度、墙钟、峰值显存） | `tex:501–502` | 不影响任何分布距离数字 |
| P13 | 摘要 "17.8% on top of a summary **in one history**"，但 Table 5 有两行在零以上（H3 17.80、H20-S2 10.69） | `tex:73` | 少报不少报错，方向安全 |
| P8 | §7.1 用 "12 个 core CE 降 0.06–0.10 nats/token" 与 $\rho$ 反证，这 12 个数全文无表 | `tex:695` | 属自证段，读者无法核；下一步应做成小表或降级为 unscanned |
| — | `references-verification.md` 表头仍写"32 verified / 3 partial"，实际 34/0 + 1 model card | 该文件 | 内部文档，不影响 PDF |

---

## 5. 验收（逐条可执行）

**自动**：按 §0 的命令编译 → 期望 `exit 0`、`9 pages`、日志中 `undefined`/`missing citation` 为 0、
`Overfull \hbox (≥10pt)` 为 0。

**人工 8 条**：
1. 摘要里不再出现 `equal` + `cost` 的组合；出现的是 "sweep … 16× range … cost held fixed"。
2. 摘要末句 "where the state lives, not what it can recall" 与 §1.4 (i) 是否同一口径。
3. §5.1 的每个数字都能在 `实验结论.md` 第 39 / 200 / 202 行找到（7.1k、四实体、36 事务、1990/1087/1179、104 事务、12 实体、19.8k、1002）。
4. §5.1 与 `Reproducibility` 的题集数一致（16/8/64 + 32）。
5. Reproducibility 的 artifact 句不含任何未提供的地址；不承诺"公开"。
6. `§3.1` 消歧句之后，全文再无裸 $R$ 被当作 arm 使用（表头与正文均为 `R0`）。
7. Table 1 caption 的新句没有把"合取为空"降级成"结论不确定"。
8. 全文未新增任何实验数字；Table 1–6 与式 (2) 现在都有正文 `\ref`（`tab:cost`/`tab:metrics`/`tab:fit`/`tab:marginal`/`tab:rstar`/`eq:obj`）。

---

## 6. 一句话给复核者

> 这次改的全是"读者能不能当场核对"的句子，没有一句新增主张：把自相矛盾的 "equal cost" 换成可观察的
> "swept vs fixed"、把没有对象的四份 history 写成可追查的对象、把不可兑现的 *auditable* 落到"每表一份
> manifest、on request"、把一符三义的 $R$ 消歧、把三张从没被正文引用的表接上 `\ref`。
> 标题、实验、数字、结构一律不动。