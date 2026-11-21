# paper-fse-v7 预印本审查：结论与证据的对应关系

## 复核更正：以下判断取代后文原审查的优先级和修改要求

**重新核对后，原审查确实存在过度审查：把可成立的结构性论证、局部实验证据和正常的讨论措辞，按“尚未排除所有其他解释”提升成了贡献缺陷。要求将 `Bottleneck identification` 改为 `A carrier cost formulation` 不成立，现明确撤回。保留核心贡献与正文叙事，不按原报告执行一揽子降调。**

| 原项 | 复核后的处理 |
|---|---|
| R01 瓶颈识别 | **撤回 P1 和贡献改名建议。** 固定载体预算、上下文占用和反复读取成本可由实现与结构分析识别，不必都靠实验发现。文中已区分 thesis 与 result，也未声称测得参数的信息容量。K 的需求增长可以作场景论证；若想避免字面上的全称解读，加条件句即可，是可选精确化，不是核心贡献失效。 |
| R02 比较对象 | **保留这一处具体的论文表述错误。** 6.76 对应 2,304-update adapter，4.19 对应 5,120-update adapter；前段干预却是 3,584→5,120，`across this intervention` 会误配来源。改明比较对象即可，数字可复算，不影响主实验或瓶颈贡献。无需补实验。 |
| R03 模板诊断 | **撤回“排除结论无支撑”的笼统指控，降为可选说明。** 原文针对的是具体 eight-section template；干预后排序未变，确实反驳“只要补这套标题就能解释该现象”。我把它扩读成排除一切格式/语言机制，超出了原句要回答的具体异议。补定义或表有助阅读，但不必据此删除实验或扩写附录。 |
| R04 摘要扫描 | **降为方法说明建议。** 文中已定义 body 比率、限定 summary policy，图注已有 hit-cap 说明。提示适配、frame tokens 可补一句，不能把它们当成已测策略曲线无效，更不需要更换摘要或新增对照。 |
| R05 交点及脚本 | **原脚本 bug 是真的，但论文交点数字没有因此算错。** 复核时现有 m30_acc.py 已修正方向并留下更正说明，新增 rstar_from_scores.py 直接从逐题分数复现 6.7573、4.1961。旧 JSON 的派生字段仍是历史错误字符串，不要求覆盖旧实验原件。该问题现已处理；附录 `same bracket logic` 改为插值口径是小型文字澄清，不是科学结论错误。 |
| R06 饱和、复现等 | **撤回整组 P2 式处理。** 原文明确说 further 2× steps 后平台，可以在所测范围内称 saturating；不需要证明所有优化路径都无效。第二个模型配置也出现反转，确实说明现象并非仅见于一个 checkpoint，不必为这个存在性判断隔离模型因素。probe 优先级可以是研究判断。条件解码已有明确限制；PCA 折内拟合是方法改进建议，不等于已证明 0.928 错误。 |
| R07 算术 | **原快照问题真实，已修。** 不再列为当前缺陷。 |
| R08 稀疏注意力 | **降为局部技术措辞澄清。** 源文中的首个 indexer 仍有全范围扫描，因此 O(n) 总体判断并未被稀疏 attention 推翻。我把“没有每层读完整 KV”和“没有线性成本项”混在了同一条批评里。0.89GB 的完整读取说法可更精确，但不影响本文 dense 成本公式和载体成本论证。 |

**当前执行建议：保留 Bottleneck identification；论文只需纠正 R02 的比较对象。脚本错误已修且交点复算通过，其余属于可选精确化，不作为 preprint 发布门槛，不要求增加实验或重写叙事。** 后文保留原审查记录以便追溯，其中与本节冲突的建议不再有效。

---

审查日期：2026-10-26。论文：《Remember Rather Than Hand Off: Mid-Speed Weights for Cross-Compaction Continuity》。按用户指定的**非学位论文、非投稿版预印本**口径审查；不评价录用概率，不套用学位论文的页数、章数、中文摘要字数、文献数量配额、国标著录格式或匿名要求。

**判断：主实验的核心数字及主要不确定性表述基本站得住；仍有需要修改的比较对象错误，以及几处从有限观察跳到必要性、机制或普遍性的结论。主要问题集中在引言和讨论，不能仅靠末尾的局限声明抵消。多数问题可通过改写和补充已有记录解决，不需要为了发预印本强行新增实验。**

本次仅新增本审查报告和核查产物，未修改论文源码、原 PDF、实验代码或数据。

## 1. 依据、版本与核查范围

参考 [自查流程](<E:/paperflow/refs/nju-se-thesis-self-check/SKILL.md>) 和 [学术型质量清单](<E:/paperflow/refs/nju-se-thesis-self-check/references/academic-50.md>)，重点采用：贡献边界、方法定义、基线公平性、数据与指标、统计口径、可复现性、有效性威胁和结论诚实性。该目录**没有独立的“非学位论文预印本版”规范**；本文是按用户要求对适用条目进行调整，而非声称目录中存在该版本。

完整阅读了 1,173 行 TeX 主文及附录、相关自查材料和实验报告；检查了现有 13 页 PDF 的关键页面，复算了保存的 9B 逐题评分均值与插值交点，核对 H20 预算曲线的统计记录，并抽查了 Doc-to-LoRA、TMEM、DeepSeek-V4.1-Flash 原文。

**核查边界**：没有重跑 GPU 实验，没有重新验证全部 27B 原始 logits，也没有完成所有参考文献的全文事实复核或系统查重。以下区分“本次从逐题数据复算”和“与已有统计验收记录核对”，不把两者混称为独立实验复现。

- 初始源码 SHA-256：`595f09141746a05405d1901c8b42035e1ee65639fadc4fa30698f86482136b64`。
- 初始 PDF SHA-256：`08ca3bda77a93a79c325565a1857092654fcace562f44874bb29ebef5ee69d7f`。
- 本报告 L 行号指初始源码快照，P 指该 PDF 的物理页码。
- 审查期间源码 L146 的 `six words` 被外部更新为 `four words`，行号未变化；这是正确的计数修复，不影响本报告的实质发现。该更新的源码 SHA-256 为 `a0b99d0bb83175f1fb0798e2817d4b62df784f8563b6e4c101ab3974964b780a`。
- 收尾又检测到更新，已额外冻结 [最新源码](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/paper-fse-v7.update-snapshot.tex>) 并逐块检查 [最终差异](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/during-review-final.diff>)，源码 SHA-256 为 `3ed78dc2569d3bee0623f9987746c99b9bc803459d3f991b08ef955949897fa8`。新稿将 60KB/163k 改为 74KB/196k，并给 0.16 加上 about，**R07 的主要错误已处理，不再计为最新稿优先缺陷**。另移动相关工作说明并补表注，未改变实验数字或 R01–R06、R08 的实质判断。L281 之后有少量行号变化；精确定位以初始快照为准，PDF 视觉检查覆盖初始版本，不冒充最新构建检查。
- [冻结源码](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/paper-fse-v7.tex>)、[核查脚本](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/verify_review.py>)、[复算结果及证据哈希](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/verification.json>)、[审查期间改动](<E:/MasterStudy/AdVance ComPact/tmp-v7-preprint-review-20261026/during-review.diff>)均已保留。

优先级：P1＝直接影响贡献或比较结论；P2＝证据不足、方法口径或事实说明需修正；P3＝表达与可读性问题。不是学位论文的“一票否决”判定。

## 2. 建议优先修改的实质问题

### R01 [P1] 引言把待检验的容量动机写成了已经识别的普遍瓶颈

位置：[L136](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:136>)、[L152](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:152>)、[L239](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:239>)，P.1–3；同时涉及摘要 L90–95。

这里存在三种不同强度的断言：

1. 已测引擎采用固定摘要上限与固定尾部窗口。这是可核对的实现事实。
2. 固定长度文本只能表示有限的信息。这是给定词表和编码条件下的结构事实。
3. “信息需求随压缩次数 K 增长”“小且固定就是本文识别的瓶颈”“丢掉的通常不是任务事实”。这些既不是前两条的必然推论，也没有被本文实验测量。

反复压缩的任务可以只需要维护固定大小的最新状态，新增历史也可能重复或失去相关性；因此需要跨边界保留的任务信息量不必随 K 单调增长。固定 adapter 同样有限，参数字节数也不等于可访问的历史信息容量。论文只在四份固定历史上测了教师分布保真，未做连续多次压缩、随 K 增长、语体连续性或同保真容量扩展实验。

正文已有“prologue is the thesis, not the result”，但贡献列表仍使用 **Bottleneck identification** 和无条件的需求增长叙述；这让动机重新变成研究结论。L136 的 `usually` 也没有“通常发生”的统计支撑。引擎提示没有显式要求保留语体，不等于已经观察到它通常丢掉语体。

**最小修法**：贡献 (1) 改为 `A carrier cost formulation`；把 K 论证改成条件句，给当前引擎加范围限定。无需补实验即可保留研究动机：

> In the engine studied here, the text carried across a boundary has a fixed budget. If the task-relevant information that must survive grows beyond that budget, it may become a bottleneck. We do not measure that growth or an equal-fidelity capacity advantage here; we compare teacher-distribution fidelity while varying the summary budget on fixed histories.

把 `What is dropped is usually not a task fact` 改成 `A possible omission is non-factual conversational conditioning, which we do not evaluate here.` 人类记忆、3 bits/token 与参数存储量可作背景类比，但不再承担“已经识别出容量瓶颈”的证据功能。

### R02 [P1] 6.76→4.19 的比较对象与所指干预不一致

位置：[L874](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:874>)、[L884](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:884>)，P.9。

前一段介绍的是 56→80 个训练 probes、3,584→5,120 次更新、P1 值位 top-1 0.3125→0.84375 的干预。后一段却说交点“across this intervention”由 6.76 变为 4.19。

本次从 [m30_acc5.json](<E:/MasterStudy/AdVance ComPact/.local-8b/m30_acc5.json>) 的逐题评分复算，实际来源为：

| 数值 | 对应 adapter | 更新数 | 说明 |
|---|---|---:|---|
| 准确率交点约 6.7573 | `rd_2304` / `m31_rd_2304.pt` | 2,304 | canonical 36-probe 运行 |
| P1 top-1 0.3125 | `m37_rdshapes.pt` | 3,584 | 56-probe shape-diverse 运行 |
| 准确率交点约 4.1961；P1 top-1 0.84375 | `rd_covered` / `m38_rdcovered.pt` | 5,120 | 80-probe 运行 |

因此两个交点**可以复算，不能说数字编错**；错误在于把 2,304→5,120 的跨 checkpoint 比较写成紧邻段落的 3,584→5,120 干预。现有“同时改变更新数”的免责声明没有修复这个来源错配。

**最小修法**：明确拆成两组比较：

> Separately, comparing the 2,304-update canonical-probe adapter with the 5,120-update covered adapter gives accuracy-based interpolated crossing estimates of 6.76 and 4.20. This is a different checkpoint comparison from the 3,584-to-5,120-update P1 intervention above, and changes both probe composition and optimization exposure.

若坚持把交点变化归到前一干预，应先获得 3,584-update adapter 在同一 40 题曲线上的评分。当前记录不足以替代这一缺失比较。

证据另见：[m37_shape.json](<E:/MasterStudy/AdVance ComPact/.local-8b/m37_shape.json>)、[m38_covered.json](<E:/MasterStudy/AdVance ComPact/.local-8b/m38_covered.json>)及本次 verification.json。

### R03 [P2] 模板诊断仍未在论文中定义，却承担排除解释的结论

位置：[L822](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:822>)，P.9。是上一轮 V07 的实质遗留。

论文直接说 summary channel 的负结果不由缺少格式模板解释，但没有给出该 channel 的具体任务、固定目标、计分前缀、三份目标的 CE，或正负结果分别属于哪些历史。读者也无法从主实验的五臂 KL 表推出该诊断结论。

原始报告能支持的具体事实是：沿固定摘要正文的真实前缀做 teacher forcing，加入共同八标题提示后，各核心 CE 下降，H20 两个目标上的 RD 劣于 R、H3 上 RD 略优于 R 的方向没有反转。例如模板后的 R/RD CE：

| 固定目标 | R | RD | RD−R，nats/正文 token |
|---|---:|---:|---:|
| H20-S1 | 0.969532 | 1.020872 | +0.051340 |
| H20-S2 | 0.902995 | 0.954784 | +0.051789 |
| H3-S | 0.722462 | 0.699941 | −0.022521 |

这些观察支持“这一次标题提示干预未改变方向”，不足以全面排除格式、语言或目标构造的影响。H3 还有小幅正向，笼统称整个 channel 的 negative result 也不准确。

**最小修法**：若该诊断不服务核心结论，删除 §6.1 的第 (2) 项。若保留，补短附录定义与小表，末句改为：

> This heading-template intervention did not reverse the observed R-versus-RD ordering on the three fixed targets. It does not rule out effects of language instructions or target construction.

证据：[模板实验原报告](<E:/MasterStudy/AdVance ComPact/experiments/compact_delta/s-reproduction-template-v1/RESULTS-main-v1.md>)。不应仅删除“数值在 artifact”一语而保留同样强的排除结论。

### R04 [P2] 摘要扫描的方法描述遗漏了提示适配、普遍截断和外框开销

位置：[L512](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:512>)、[L665](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:665>)、[L700](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:700>)，P.5–8。

已做对：论文明确定义 r 只使用 summary body；承认 H20 原 S1 复用和 cap64 结构破损；图1的小字还写了 H20 所有新摘要触 cap。这些并非完全隐瞒。

仍缺少的关键方法信息是：

- H20 的 512/256/128/64 四个新摘要**全部** hit cap、无 EOS，并非只有 cap64 截断。
- 三份短历史的九个新摘要也全部 hit cap、无 EOS；新点有预算适配附语，原摘要没有该附语。因此相对原点的变化包含提示策略变化，新 cap 之间也有预算对应提示文字的变化。
- H20 的 body 512/256/128/64 对应 frame 后 574/319/191/127 tokens；短历史新点外框额外 62–63 tokens。body=10 不是总上下文增量=10。这在论文强调载体成本时尤其应明确。
- 表2已经写 `regenerate at cap vs truncate; not separated`，但正文没有交代实际如何生成并终止各点，表2不能代替方法说明。

**后果**：结果是这个“预算适配提示＋实际终止方式＋外框”的具体摘要策略曲线，不能把全部变化单独归因于信息容量下降。交点作为该策略的观察仍可保留。

**最小修法**：在 §4 或 §5.2 增加一段，报告以上事实；在表7补 frame token 列或脚注，在表6说明 cap 仅约束 body。无需删去失败或极短点，也无需另造完整摘要替换原数据。

证据：[H20 统计原件](<E:/MasterStudy/AdVance ComPact/experiments/compact_delta/minimal-set-20261026/cap-main-v1/MAIN-REVIEW-batch3-and-budget-curve-v1.json>)、[三历史方法与结果](<E:/MasterStudy/AdVance ComPact/experiments/compact_delta/summary-cap-threeH-20261026/RESULTS-main-v3.md>)。

### R05 [P2] 9B 的插值估计被称为“相同 bracket 逻辑”，且交付脚本的方向判断有错

位置：[L851](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:851>)、[L1137](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:1137>)，P.9、12。

27B 主实验采用离散点夹住次序反转，明确不插值。附录却称 `The same bracket logic` 得到 5.5、6.8、5.85，并把 540–650 tokens 写成 crossing 的范围。

本次复算表明：5.5011、6.7573、5.8420 可由同一对 1024/512 cap 点之间在 **log(r)** 上线性插值得到；5.5 与 6.8 分别来自不同指标，不能把它们包成一个统计区间。实际共同的采样端点 r 是 3.52 与 7.22。

此外，当前 [m30_acc.py](<E:/MasterStudy/AdVance ComPact/.local-8b/m30_acc.py:184>) 的准确率交点条件写反：cap 从宽到窄时，SR−RD 由正变负，代码却找 `a <= 0 < b`，并在 `a > 0` 时立即输出“最宽 cap 已低于 RD”。保存的 m30_acc5.json 因而把这些交点字段写成错误字符串。**逐题评分可以复现论文数值，但现交付的交点字段和脚本不能直接复现该数值。** 本审查保留该错误，未代替用户修改实验代码。

**最小修法**：

1. 附录明确写 `exploratory log-r interpolations`，分别列 KL 和值位 top-1 的估计，不称为相同 bracket 或置信区间。
2. 记录插值轴、端点、指标与 checkpoint；将表9的 `exists; at 540--650` 改成“sampled ordering reverses; interpolated location depends on the metric”。
3. 修正独立统计脚本并留下更正记录，不需要重跑 GPU。若暂不修脚本，直接仅报告离散端点即可。

### R06 [P2] “饱和”“载体属性被排除”“探针最重要”仍超出了有限扫描

位置：[L866](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:866>)、[L937](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:937>)、[L954](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:954>)、[L1142](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:1142>)，P.9–10、12。

仍有以下推论：

- 数字位置线性可读，所以分布拟合“是写了多少，而不是载体的属性”。条件可解码性不能排除架构、目标函数、优化路径、位置或 probe 分布的作用。
- 64→128 passes 的换问法值位 top-1 约 0.5933→0.5892，被称为 saturated regime。只能说在这两个预算上该指标没有点估计增益，不能证明所有优化路径或泛化能力已饱和。训练措辞值位 top-1 达 1.0 也只是该训练指标达到上限。
- “what a probe set asks about moved the reading more than anything else we varied”。不同干预同时改变更新数、题分布、指标或模型；没有可比较的因素效应排名。
- 9B 用不同模型、历史、题集和摘要方法观察到另一条反转曲线，支持“另一个配置也出现类似现象”；不足以把模型因素单独识别出来，断言形状不是某 checkpoint 的 artifact。

**最小修法**：分别改为“在所测位置可条件解码”“在所测两档预算上的指标平台”“探针组成是值得进一步控制的因素”“在另一配置也观察到反转”。研究者可以据此优先研究 probe 设计，但不要把优先顺序写成已验证的因果排名。

另注意：[m32_digitdecode.json](<E:/MasterStudy/AdVance ComPact/.local-8b/m32_digitdecode.json>) 的 0.928 来自 **m31_rd_4608.pt**，不是用于主 9B 交点的 2,304-update adapter。附录宜标出 checkpoint。其脚本虽按 probe 划分五折，PCA 却在全体特征上先拟合；若将结果作为严格的样本外读出准确率，应将 PCA 放进训练折。当前应保持为探索性条件读出，不能由此推出静态权重完整重建或载体能力的排他解释。

### R07 [P2] 容量背景存在可直接复算的加法与单位口径错误

位置：[L158](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:158>)、[L181](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:181>)，P.2。

**状态更新：本项记录初始快照的问题。审查收尾的新稿已改成约 196k tokens、74KB 和 about 0.16，主要错误已处理。下面保留复算依据；精确采用哪个 W 与 cap 的数值可再统一注明，不要求把数量级示例写成精确实测容量。**

论文说百万窗口下 surviving total 是约 163k tokens，即 0.16W 加摘要 cap；两者加起来并不是 163k：

| W 的解释 | 0.16W + 32,000 | 按论文示意的 3 bits/token 换算 |
|---|---:|---:|
| 1,000,000 | 192,000 tokens | 72,000 bytes |
| 2²⁰ | 199,772 tokens | 74,915 bytes |

163k 更接近尾部本身，遗漏了摘要项；相应 surviving 约 60KB 也应同步核对。若 cap 只是上限而非实际长度，应明确说上限或给出实际取值，不能把不同情形混成一个数。

另外，163,840/2²⁰ = **0.15625**，不是 0.16；严格取 0.16×2²⁰ 应为 167,772，按 64KiB/token 为约 10.24GiB。163,840 tokens 对应 10.0GiB 本身算对了，错的是它与窗口比例的配对。

3 bits/token 已被标为示意而非转录熵测量，这个限定应保留。它不能进一步被拿来证明参数载体具有多少可用的信息容量；人类记忆估计与这些 bytes 也不支持可检验的等容量比较。

### R08 [P2] Dense 成本模型不宜直接当成 DeepSeek 稀疏注意力的完整读取过程

位置：[L184](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:184>)、[L201](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:201>)、[L239](<E:/MasterStudy/AdVance ComPact/paper-fse-v7.tex:239>)，P.2–3。

§3.5 的条件化结论是正确且可保留的：固定模型维度、cached dense attention 下，k 个 prefix tokens 的增量是每个 decoded position O(k)、m 个位置 O(km)；固定 adapter 每个 processed token 有常数额外计算。

但引言由 890 bytes/token 跳到“0.89GB 被每个生成 token 扫描”，以及无条件的 `Sparsification reduces the constant, not n`，把存储量、索引扫描和实际 attention 读取混在一起。DeepSeek 原文 §2.3 描述 Top-512 选择、候选池和跨层复用：首个 Full Mode 索引器仍扫描可见范围，后续索引器可限定候选池，attention 读取被选中的 entries。因此不能从总 KV 字节数直接推出每层每步都读完整 0.89GB。也不能反向宣称其整网成本已与长度无关。

**最小修法**：保留存储量例子，将计算段改成“具体读取成本取决于稀疏路由、索引与复用；本文后续成本推导限定于 cached dense attention”，撤回 `independent of any particular model` 的无条件表述。预印本可以给解析模型，不必把未做的等算力测量补成实验结论。

来源：[DeepSeek-V4.1-Flash 原文 §2.3](https://arxiv.org/html/2609.19969v1#S2.SS3)。890 bytes/token 本身与原文相符。

## 3. 不影响主结果、但建议一并修正的表述

| 位置 | 问题与最小修改 |
|---|---|
| L103–105、L1115，摘要与结论 | 0.026 对 0.017 是漂移点估计比较；正文已说 paired drift-difference CI 跨零。摘要/结论补 `point estimates`，避免读成已经证明 Δ 比摘要有更大漂移。NLL 的正向显著效应可另说，不与漂移差显著性混用。 |
| L781–790，P.7–8 | `detectable part ... go away` 容易把“不再检出”写成已识别并消除的因果成分。直接报告 NLL +0.0349→−0.0016 和新 CI 跨零；约九成漂移下降可以保留。相关侧约 0.86pp 是点估计，区间跨零，不称已确定的代价大小。 |
| L429，表1 | `one training pass` 与实际 64 optimizer updates、16 probes 的重复曝光容易冲突。改为 `one boundary write (64 updates in the main run)`。 |
| L508 | 无记忆 R0 是 baseline，不是已经证明的性能或 KL 数学 lower bound。改 `tail-only, no-memory baseline`。 |
| L920–922、L1077–1078、L943–946 | 仍有 `bounds how much`、`covering ... raises`、`size ... established` 等表述。改成“这些配置的观察差异”；保留更新数混杂条件。不能把两次运行的差解释成 probe 单因素效应的上下界。 |
| L1091–1093 | “这正是 rehearsal trade 会最先破裂的地方”未测。改为 `Whether the rehearsal trade changes near that budget remains open.` |
| L270–278 与表10 | A' 定义为仅 A 成立时适用，但多行 A=× 时 A' 又填写 × 或 ---。统一为 n/a；若要展示一般生命周期，另设不依赖 A 的列。 |
| L1021–1023 | TMEM 使用抽取 QA 是原文事实，但“不能表述的 dispositions、cross-event consistency 不进入监督”不能从 JSON/QA 形式推出。限定为“取决于抽取问题及目标覆盖”；本文的 direct full-vocab 也受 probes 和 teacher path 约束。 |
| L316–321 | 跨历史迁移不是会话记忆失效的充分条件：会话可局部，又共享语体或模式。建议将其表述为需检查的特异性，而非“一旦泛化就是失败”的二分规则。 |
| §4.7、Data Availability | bootstrap seed 已给出，但训练 seed、AdamW 配置、软件版本、probes 生成方式与附录 9B 摘要策略描述仍宜补成一张小表。`available on request` 对此预印本不自动判不合格；不要把它当作论文内部定义和关键表格的替代。 |

相关工作抽查：Doc-to-LoRA 原文确实使用同基座 contextual teacher/context-free student 的蒸馏，并允许不再消费原 context 的推理；TMEM 原文确实在 context threshold 触发 QA 抽取和 LoRA 更新。本文承认这些事实是正确的，**不建议重新恢复“只有本文做到文字移除后由参数承载”的新颖性论证**。[Doc-to-LoRA](https://arxiv.org/html/2602.15902v1)、[TMEM](https://arxiv.org/html/2606.04536v1)。

## 4. 哪些结论可以保留

| 结论 | 本次判读 |
|---|---|
| 在固定单模型和四份构造历史上，三份 R→RD 的教师 KL 相对下降约 25–28%，第四份区间跨零 | 与表4及已有统计记录一致；保留当前范围限定。 |
| H3 在摘要上加入 Δ 后 KL 相对下降 17.8% | 与表5一致；不要写成所有历史都有相同额外收益。 |
| H20 指定摘要策略下，SR256 点优于 RD、SR128 点弱于 RD | 与保存统计中的差 −0.043631、+0.056866 一致；保留簇重采样使 256 端点跨零的说明。 |
| 四条已测曲线的点估计均反转 | 与报告一致；H1 两端较清楚，H2/H3 的端点不确定，不称已经验证普适交点。 |
| H20 原 adapter 在无关题上 gold NLL 增加 +0.0349，CI 排零，而 greedy 仍 31/32 | 与记录一致；不是“完全无害”，也不是已经观察到正确率下降。 |
| rehearsal 在这一 history/seed 下把漂移由 0.02587 降到 0.00240，两个正式门仍未通过 | 可保留；不宣称已证明无损消除副作用。 |
| 9B 4→64 passes 时 40 题值位 top-1 0.220→0.497，而 KL 0.7230→0.7508；16→64 时两指标都改善 | 本次从逐题数据复算一致。旧 KL 方向错误已修好，不应继续报为未修。 |
| m34 的约 0.969 与 m37/m38 的 0.3125/0.84375 属不同 checkpoints | v7 已明确交代这一点，旧“同一 adapter”错误已修好；R02 是另一个交点配对问题。 |
| 数字预测位置存在条件可解码信号 | 可作为探索性读出保留；注明 4,608-update checkpoint 和处理方法，不写成静态权重完整恢复。 |

报告数字尽量保留原记录，不用新的实验或指标掩盖负面结果。正文已经很好的部分——分布距离与任务能力分开、区间跨零不称等效、不同 9B/27B 协议不混池、等成本未测——应继续保留。

## 5. 自查清单的适用结果与图文检查

| 自查方向 | 预印本判读 |
|---|---|
| 标题、研究问题、贡献，ACA-RED-2 / A-02–04 | 主题与工作一致；“continuity”需要理解为单边界后的分布保真观察，未测反复压缩中的长期连续性。贡献中的容量瓶颈应按 R01 收窄。 |
| 形式化与方法，ACA-RED-5 / A-07–09 / A-28 | 输入、五臂、优化式和不变量较明确；没有伪代码不单独判错，成本表、符号及实际写入预算应按上文统一。 |
| 数据、偏差与指标，A-10–12 / A-18–20 / A-23 | 已说 synthetic、单生成器、教师依赖和无任务 gold。缺真实会话和任务成功测量是范围限制，不必为了预印本硬加 benchmark；不能据此声称已验证真实长期记忆或语体保持。 |
| 基线、消融与公平性，A-13 / A-15 / A-17 | 实际摘要引擎和多预算对照有价值；这是指定策略对照。提示适配、截断、未做等字节/等算力匹配需明确。不是方法优越性论文，无须机械要求凑齐若干 SOTA 或 3–5 个消融。 |
| 可复现性与统计，A-14 / A-16 | 有配对整题 bootstrap、固定 teacher path 和簇敏感性；不把 token 当独立样本。单训练 seed 和四 history 限制已说。当前最具体的可复算问题是 R02/R05，不是必须再补一个 p-value。 |
| 开销，A-21 | 参数、字节和更新数是实测/可计数对象，wall clock 等主协议成本未测；允许只做带条件的解析模型。不能得出速度、存储效率或等成本优势。 |
| 效度、局限与未来工作，A-22 / A-24 / A-27 | 章节存在且大体诚实，但 R06 等强断言在讨论、Future Work 中复现；局限声明不能替代局部改写。 |
| 相关工作与文献，A-05–06 / A-25 / A-29 / F 类 | 按路线组织；抽查三个关键原文，未作全表事实背书。45 个引用键在 46 条 bib 中均存在，TeX 的 ref/label 未发现缺失。ACM 体例可保留，不套学位论文 GB/T 配额。 |
| 学位论文专属门槛，ACA-RED-3–4、S 类相应条目 | 不适用；13 页不是本次缺陷，不要求凑 50 页或 35 页方法实验。 |

PDF 关键页视觉检查覆盖 P.1、2、7、8、9、11、12：表格、图例、交点阴影与主要数字可辨；未发现需要单独阻止预印本发布的明显图文排版问题。图1清楚区分绝对 KL 与配对差，簇敏感性的小字说明已经存在。表7和图1对 r、128/256 点的对应关系一致。没有 UML 图，不套软件工程学位论文 UML 门槛。

参考文献和实验数量的充足性不按固定配额判定。未发现可据以指控数据伪造的证据；这也不等于完成了研究诚信审计。R02/R05 属可定位的来源与统计脚本问题，应修正并留记录。

## 6. 执行建议（复核后）

保留核心瓶颈贡献与现有叙事。只纠正 R02 的比较对象说明；无需补实验。R05 的代码修正及独立复算脚本已存在并经本次执行核对。其余按本文开头的复核更正处理，不作为发布门槛，也不再据此把论文贡献降成单纯成本公式或可行性演示。
