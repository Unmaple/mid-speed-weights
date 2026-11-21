# paper fse v4 预印本证据审查

更新：已另做 [源码更新差异复审](E:/MasterStudy/AdVance%20ComPact/paper-fse-v4-preprint-diff-review-20261026.md)，覆盖截至 19:39:54 的新版本；补出前次未单列的“16→64 遍 KL 方向”错误，并给出旧问题的新版状态。

当前版本有可保留的初步测量结果，但若要尽量避免“实验数据不支撑结论”，应先修正覆盖实验的对象定义、重放的因果归因、成本论证和若干数值归属。主要问题是局部观察在总结句中被扩大，尤其是 9B 结果被用来解释 27B 的限制。多数问题可以通过改写解决，不需要把补跑大实验作为本版预印本的发布前提。

日期：2026-10-26。论文：*Remember Rather Than Hand Off: Mid-Speed Weights for Cross-Compaction Continuity*。本次只审查，未修改论文正文或实验文件。

## 审查口径与版本

参考 [nju se 自查说明](E:/paperflow/refs/nju-se-thesis-self-check/SKILL.md) 与 [学术型 52 项清单](E:/paperflow/refs/nju-se-thesis-self-check/references/academic-50.md)。该目录没有独立的“非学位论文预印本版”规则；以下是按本次要求作的适用性转换。

保留问题、方法、实验和结论的对应关系、数据自洽、推断边界、引用准确性与可复现性。排除学位论文的页数下限、章节篇幅、中文摘要字数、双语对应、章节小结、固定章序、答辩评级，以及投稿的匿名和版面要求。不以 arXiv 数量、未做 SOTA 全面对比、只有一个主模型或缺少多种子本身判为不合格；这些限制只约束能够声称什么。

审查期间源码被外部更新，因此冻结了 [审查快照](E:/MasterStudy/AdVance%20ComPact/tmp-v4-preprint-review-20261026/paper-fse-v4.review-snapshot.tex)。以下 L 均以此快照为准；原文件后续行号可能移动。

- 源快照修改时间：2026-10-26 19:37:09，北京时间。
- 源快照 SHA-256：`475e09336cdae38ce7d326a12e85d8d4d8ad1eab549579f72413d775761e3aa7`。
- 配套 PDF：13 页，编译于 19:18:48，SHA-256：`643fc816845162c73e3b48ca116935774e1c8853e1f1242ae475e80ccb7d8139`。PDF 页码仅辅助定位，不能视为最新源码的编译验证。
- 阅读了全部源码，抽取全部 PDF 文本，目视检查关键结果页与图 1；核对了相关本地汇总及部分计算脚本。未重新运行训练、GPU 前向或完整张量审计。

## 可以保留的结果

| 主张 | 现有证据及边界 |
|---|---|
| 固定 27B 配置的 Δ 可以减小与全文教师的 KL | 表 4 的四行相对下降可复算为 25.09%、7.65%、27.95%、28.47%；H2 区间跨零，不能将四份历史都写成确定获益 |
| 在 H3 上，Δ 加在摘要之上有额外改善 | 17.80%，区间 [10.43%, 24.20%]；不推广为所有摘要都获益 |
| H20 已测摘要预算点与固定 RD 出现次序反转 | 256-token 点 SR 更近，128-token 点 RD 更近；限定摘要正文长度、固定教师轨迹 KL 和具体生成策略；256 点对调用簇重采样敏感 |
| 其他历史也出现预算相关的点估计次序变化 | 应逐份保留端点区间，不能把 H2/H3 写成与 H1 同等强度的交界定位 |
| H20 原 RD 在这批无关问题上有分布漂移和 NLL 副作用 | KL(off‖on)=0.02587385；NLL 效应 +0.03494754，区间排除零；greedy 正确率仍为 31/32 |
| 本次重放降低了上述副作用 | 漂移点估计下降约 90.74%；相对原 RD 的 NLL 效应改善区间排除零；两个预注册主门均未通过 |
| 9B 更长训练提高了指定值位 top-1 | 40 题从 0.220 到 0.497，而 KL 从 0.7230 到 0.7508；二者不能互相替代，也不是整段自由回答正确率 |

这些结果足以支撑一篇范围明确的初步测量预印本。下列修改旨在使正文始终保持相同证据强度。

## 优先修正

### R01 覆盖实验把 probe 数写成事实格子数，并混淆了事实覆盖与问答形式覆盖

位置：L850–859、L902–906、L920–928、L1120–1124；主要在 PDF P.9–10、P.12。优先级：高。

“56 of 96 (entity, field) cells”没有对应到真实训练构成。[m37_shape.json](E:/MasterStudy/AdVance%20ComPact/.local-8b/m37_shape.json) 的 `n_train=56` 是 36 个三字段、12 个双字段、8 个单字段 **probe 的数量**。[训练脚本](E:/MasterStudy/AdVance%20ComPact/.local-8b/m37_shape.py:75) 将全部 36 个实体的三字段 probe 放进 `all36`，字段为 timeout、replicas、rev。事实格子若定义为实体×字段，名义上是 36×3=108，且已有三字段训练覆盖；它不是“56 个已覆盖、8 个从未监督事实格子”的实验。

留出的 P1 测的是：实体及其值在三字段答案中见过，单字段形式在其他实体上见过，这种组合能否迁移。0.3125 是指定值位 top-1；它本身不等于一个定义清楚的随机水平，也不能支持“八个格子没有一例回答出来”。当前写法把事实是否见过、问题形式是否见过、值位是否命中混成了一个结论。

附录称两组“differ only in what the probes asked about”也不准确：新增 24 个 probe 时，更新数从 3584 到 5120，同时改变了监督内容、形式和总优化预算。固定 rank 不能证明“coverage, not rank, is the binding constraint”，也没有排除容量与覆盖的交互。

建议替换承重段：

> With 56 training probes, the adapter achieved 0.3125 value-position top-1 on eight held-out single-field questions, although their entities and values had appeared in three-field training answers. Adding 24 single-field probes in different wording raised this score to 0.84375. This intervention changes both the training distribution and the total number of updates; it suggests sensitivity to entity–answer-format coverage, but does not isolate a factual coverage limit or a capacity limit.

相应删除“不是实体字段上的函数”“只获得监督点集”“nothing else”“we saw no case of an unsupervised cell being answered”等推论。将这一研究动机写为“需要定义并测量不同形式的覆盖”，仍然成立。

### R02 9B 结果不能给 27B 的交叉点提供保守界

位置：L861–865。优先级：高。

9B 上一次改变训练分布后，准确率口径的交点点估计从 6.76 变为 4.19，不能证明稀疏 probe 只能低估载体能力。主实验是另一模型、历史、训练与摘要协议，以 KL 为主指标；论文自己的 9B 训练量实验还显示准确率改善与 KL 恶化可以并存。因此没有已证明的单调关系，不能称 27B 测量为 `a conservative estimate`，更不能赋予上下界含义。

“roughly twice as much text”也应直接报告量：6.76/4.19≈1.61，且这是既定曲线与指标下的派生交点，不是容量单位。

建议：

> In the companion protocol, the point estimate of the accuracy-based crossing changed from 6.76 to 4.19 after the training intervention. Our 27B crossing remains conditional on its probe set; the direction and magnitude of a coverage intervention at 27B are unmeasured.

### R03 重放缓解副作用不等于识别副作用的唯一来源

位置：L773–776、L784–786，PDF P.7–8。优先级：高。

“如果代价来自写权重，重放就不可能消除它”并不成立。一个由权重更新产生的效应，本来就可能被另一组权重更新抵消或减小。实际还有约 0.00240 的漂移；相关收益损失的区间为 [−2.18,+0.69]pp，无关 NLL 效应区间仍允许小幅损害，两项主门没有通过。

实验支持的是“副作用对训练目标敏感，而且这次干预减轻了它”，不支持“代价属于没有无关数据，不属于载体”，也不支持“the detectable part”代表某个被识别出的因果成分。

建议正文及 takeaway 一并改为：

> On H20, this rehearsal intervention reduced the drift point estimate by 90.7% and reduced the off-topic NLL effect relative to the original write. It did not meet both pre-registered success conditions. These results show that the measured side effect is sensitive to the training objective; they do not identify an intrinsic or avoidable lower bound for parameter carriers.

依据：[重放主报告](E:/MasterStudy/AdVance%20ComPact/experiments/compact_delta/minimal-set-20261026/replay-train-main-v1/RESULTS-replay-main-v1.md)。

### R04 0.01597 的实验臂归属错误，漂移大小的推断也需收窄

位置：L751–755、L784–786；PDF P.7–8。优先级：高。

原始 [h20-drift-ci95.json](E:/MasterStudy/AdVance%20ComPact/experiments/compact_delta/h20-drift-v1/h20-drift-ci95.json) 中：

| 配对对象 | 正向 KL 均值 |
|---|---:|
| R → RD | 0.02587385 |
| R → S1R | 0.01663098 |
| R → S2R | 0.01596555 |
| S1R → S1RD，即相对同一摘要的 adapter 自身漂移 | 0.00819530 |
| S2R → S2RD | 0.01008793 |

所以 `0.01597 for a summary plus Δ` 应改为第二份摘要 S2，不能拿另一个量替上而不解释参考臂。若想比较 R→S1RD 的总漂移，需使用那个确切配对的结果。

RD 漂移比 S1/S2 大是点估计排序。原报告中“摘要漂移−RD 漂移”的两个配对区间分别为 [−0.03793,+0.01309]、[−0.03714,+0.01005]，均跨零，不能把相对更大写成统计确定的结论。

建议：

> The RD drift point estimate is 0.02587, compared with 0.01663 and 0.01597 for the two summaries. The paired intervals for these differences cross zero.

另外，“confidence near a decision boundary”没有相应 margin 或边界测量支持。可以直接写“gold likelihood changed while the measured greedy correctness outcomes did not”，不定位变化发生在决策边界附近。

### R05 成本论证仍把固定大小配置写成了同等保真下的优势

位置：摘要 L71–85；L132–153、L214–226、L391–424、L1031–1037。优先级：高。

这里有三个不同问题。

1. 未合并低秩 adapter 在每次使用时仍有额外矩阵乘，不能将总成本写成“paid once”。L394 自己已正确承认常数逐 token 成本，应在摘要和贡献中统一。
2. `O(L)` 没有区分注入 prefix 的 prefill、缓存驻留和后续 decode，也没有固定复杂度的自变量。以标准稠密注意力、固定网络维度为简化假设，k 个缓存历史 token 对 m 次 decode 的增量注意力工作量为 O(km)；固定 rank adapter 的额外计算同样随处理 token 数 m 增长，只是相对历史长度 n 固定。混合/稀疏/递推架构还需要另列假设。
3. “保持保真，文本必须随 H 增长，而 Δ 是水平线”只证明了把 Δ 的大小固定，未证明其保真随历史增长仍保持。文本 k 与 adapter 参数数都可以固定，也都可能损失信息。当前扫的是固定 H、固定 Δ 下摘要预算，不是保持同等保真的跨历史长度成本曲线。

正文已承认没有共同成本单位和工程实测，因此“参数是唯一剩余预算的选项”“cheap to serve”也超出当前结果。L282 的 `same token budget` 应改成 `a swept summary-token budget with a fixed adapter configuration`。

可保留的成本句：

> For a fixed adapter configuration, parameter storage and the additional adapter computation per processed token do not grow with history length, and the adapter adds no text prefix. Writing and subsequent adapter execution both have costs. We have not measured an equal-fidelity or equal-cost scaling curve.

3 bits/token、文本 KB、人类 MB 与 adapter 的 BF16/FP32 字节数不是同一种可用容量。已有说明可以保留数量级类比，但不应用它们推出“容量才是瓶颈”或参数能够容纳更多可恢复历史内容。相关理论判断应改成条件假设。

### R06 对 Doc-to-LoRA 的描述削弱了创新边界的可信度

位置：L987–995；相关的 L104–107、L209–211、L232–235、L1001–1005。优先级：高。

本文称这一方法族在其生命周期中仍将原上下文保留在窗口。已核对的 [Doc-to-LoRA 原论文 §3–4](https://arxiv.org/html/2602.15902v1) 明确评估仅给查询、不给原始上下文的目标模型。因此“我们的 A 消失、对方文档始终存在”不能作为区分该工作的依据；“有界文档切换载体收益很小”也不符合该文的研究动机与报告结果。

建议：

> Prior context-internalization methods, including Doc-to-LoRA, already evaluate inference without the original context. Our study focuses on a compaction-triggered, session-local write and on its comparison with a real summary-generation policy across token budgets.

同理，TMEM 的 QA 提取与本文分布监督确有区别，但这不自动证明本文获得更大的有效监督带宽，或能保留 TMEM 不能保留的 disposition。本文仍受 probe、答案前缀和计分位置限制；没有带宽或 disposition 的实测比较。将 `we trade auditability for bandwidth` 改成监督通道的描述，或明确为待验证假设。

[TMEM 原论文](https://arxiv.org/html/2606.04536v1) 已研究 episode 内 LoRA 更新；“不存在中间载体”“仅有文本或参数”“first measurement”等排他表述需限定为本文的设计范围与测量组合。当前证据不要求再做一轮完整优先权搜索，只需避免广泛的首创断言。

### R07 数字位置的条件线性读出不能写成从 Δ 本身读出整张表

位置：L843–845、L1126–1128。优先级：高。

[m32_digitdecode.py](E:/MasterStudy/AdVance%20ComPact/.local-8b/m32_digitdecode.py:7) 的标签是单个数字 0–9，而不是完整数值身份、事实身份或整张表。特征是运行模型时的 `B_l A_l x_l`，它依赖输入激活和教师强制的答案前缀；不是只给 adapter 权重、不提供输入就恢复内容。[结果](E:/MasterStudy/AdVance%20ComPact/.local-8b/m32_digitdecode.json) 为 36 个 probe 的 250 个数字位置，使用 `m31_rd_4608.pt`。

此外，0.192 是样本中最大数字类别占比，应称多数类基线；随机标签结果另有均值和分位数。0.472 的 base 特征取自在相同已装 adapter 的前向路径上的基础 MLP 输出，也不等于独立运行一个关闭 adapter 的模型得到的对照。

建议：

> On 250 teacher-forced digit positions from 36 probes, a linear classifier decoded the next digit from adapter-contribution activations with 0.928 accuracy, versus 0.472 from the base-MLP-output features collected in the same forward pass and a 0.192 majority-class baseline. This establishes conditional decodability at those positions, not reconstruction of the table from adapter weights alone.

### R08 2304 已是总更新数，不能再乘 36

位置：L817、L1065–1067、L1102–1104。优先级：高，事实错误。

[m31_long.json](E:/MasterStudy/AdVance%20ComPact/.local-8b/m31_long.json) 明确记录 `S2304.steps=2304`、`passes=64`；这是 36 个训练 probe×64 遍。文中 `36 entities × 2,304 updates` 会变成 82944 次，放大 36 倍。脚本也只迭代总共 `st` 次更新。

建议：

> The companion run used 2,304 total updates, corresponding to 64 passes over 36 training probes, plus teacher-target collection.

9B 的时间不能直接预测 27B 的时间；“27B did not fit in this version's study budget”可以作为研究范围说明，但不能用错误乘法证明其成本，或在未测量时声称部署便宜。

### R09 总结中的“可迁移反转”和交界位置强于分历史证据

位置：L638–654、L722–724、L1082–1083。优先级：中。

H2 的 10-token 点配对区间跨零；H3 的 200-token 点接近 RD，区间跨零。这些数据支持点估计曲线有次序变化，不支持所有历史都已用两个确定端点夹住交点。H3 在原始 1178-token 摘要处才有明确文本优势，因此它的确定反转区间也不能直接压成“约 200 token”。

把四份合成历史的观察叫作 `what transfers` 容易被读成样本外可迁移性；本文没有用新历史验证先前得出的规律。L638 的“token count is the more nearly transferable quantity”也没有与压缩比的迁移误差比较相支撑，建议删除。

建议：

> The sampled point estimates reverse order on all four histories. H1 provides a clear two-endpoint bracket; H20's 256-token endpoint is sensitive to cluster resampling, and the proposed short-history endpoints for H2 and H3 remain uncertain. The location and out-of-sample stability of a crossing are not established.

不必删掉 H20 的 128–256 正文 token 次序反转测量；继续明确它是离散预算点的区间，且不是交点的置信区间。

### R10 ρ 与 summary channel 的负结果缺少自足定义

位置：L526–527、L801–805，PDF P.8。优先级：中。

正文使用 `12 core CEs`、`ρ`、floor、slope，却没有给出 ρ 的公式、CE 的 12 个单元分别是什么、所用摘要目标与问题答案 KL 的关系，也没有给出预注册分母阈值。读者无法复算那两组三元百分比。即使本地实验报告有定义，本论文的承重结果也应自足。

建议补一个短定义及支撑表/附录，或者删去这一解释段。用“this heading-template intervention did not materially change the observed ratios”替换“模板不是原因”的普遍归因。标题 `Three Explanations We Ruled Out` 的第一项实际上明确写“没有检出、不能排除”，建议改成 `Checks on Three Alternative Explanations`。

### R11 H20 边际收益虽已披露来源不同，但表格仍让读者误以为可直接配对

位置：L595–622，PDF P.6。优先级：中。

表 5 给 H20-S1 的一个 SR 绝对值、SRD 留空，再列相对收益和区间；正文承认绝对值来自不同运行。这是诚实披露，但还需指明**相对收益及区间自身**究竟由哪组同运行、同题配对结果计算。不能让当前展示的另一运行 SR 充当它的分母，也不能把 provenance 差异当作“不需要配对”的理由。

优先从现有文件补出每行真实的同运行 SR/SRD 均值及来源；若不便展示，将 H20 两行单列为补充实验，只报原运行的相对收益，并移除与其不匹配的绝对值。无需重跑实验。

## 其余需要顺手修正的陈述与标注

| 位置 | 问题与改法 |
|---|---|
| L930–933 | `same entity count` 与 L445–450 矛盾：H1–H3 为 4 实体，H20 为 12 实体。共同点可以写同一生成器和事务语法；重放只测 H20，不应说其权衡在四份历史都已测量 |
| L779–782 | `§3.7` 已过时，成本模型现在是 §3.5；用标签引用。`exactly where the rehearsal trade would break first` 是未测预测，改为 `whether the trade-off changes near saturation remains open` |
| L558 与 L467 | 设计空间表写“Compression ratio |S|/|H|”，正文 r 定义为反比 |H|/|S_body|。前者改叫 retained-text fraction，或全篇统一 r 的方向 |
| 摘要 L79、表 6/7 | “16× sweep”只对应 H20 的名义 cap 1024→64；实际正文 1002/64≈15.66，短历史原摘要到 10 token 的跨度更大。注明范围即可 |
| L351–358、L906–913 | 区分每个边界写入和每个 session 只写一次。当前只测一个边界；重复 compaction 的累计更新、覆盖与生命周期没有被验证 |
| L456 | 看到问题的 selector 不必然提高文本性能。改为“question-aware retrieval may change the comparison; we did not evaluate it” |
| 图 1，PDF P.8 | 点估计与表 7 一致。图例 `R` 应统一为 `R0`；图内 `see report for sensitivity` 没有可定位目标，可直接写“cluster sensitivity in §5.2”。图注可注明是逐点、条件区间 |
| 相关工作矩阵 L954–966 | A 不成立时 A′ 按定义应为 n/a，但若干行写 ×/—；CCM 在 A 成立时却写 n/a。统一“不适用”“未报告”“已知不满足”，避免表格在缺证据处给出强判断 |
| L498–501、L793 | 无关集是 32 题合计 50 个 gold 计分位置，不是每题 50 个；建议明确 total，表 8 的 NLL 单位也写明 nats/scored position |
| L1089–1095 | on request 可作为本版数据声明，但不等于读者现在能复核。“auditable”宜限定为保留来源记录；最好附现有 table→manifest 的索引，不必先上传全部张量 |

## 52 项清单的适用性记录

“符合”只表示当前文字在所述范围内足够，不代表完整复现实验或认证不存在学术不端。不同问题可能映射到同一条清单，不按映射次数重复计数，也不沿用学位论文评议算法。

| 条目 | 本次处理 |
|---|---|
| RED-1 学术规范 | 核对了若干原始汇总与引文；发现 R01/R04/R08 的口径或归属问题，不据此认定伪造，也不能认证不存在抄袭 |
| RED-2 文题对应 | compaction、参数载体、低秩写入均有工作对应；“remember/continuity”的行为含义需受主指标限制 |
| RED-3、RED-4 | 学位页数与工作量页数门槛不适用 |
| RED-5 | 已有形式化、目标函数、五臂协议与实验设置；细节缺口见 R10/R11 |
| A01 摘要要素 | 具备问题、方法、设置与数字；成本与广泛背景结论需按 R05/R06 收窄 |
| A02 研究问题 | 三个 RQ 清楚，均有结果对应 |
| A03、A04 贡献与边界 | 有贡献列表；成本、优先权和覆盖机制声明需修正 |
| A05 相关工作组织 | 按路线分组，适合论文结构 |
| A06 近期代表工作 | 有近期工作；本次不要求新建 SOTA 基准，准确性按 R06 处理 |
| A07 形式化 | 输入、载体、目标函数和约束基本清楚 |
| A08、A09 方法详实与伪代码 | 简单写入方法不强制加架构图和伪代码；补 batch、训练 seed、软件路径及 probe 抽样框有助复现 |
| A10、A11 数据与偏差 | 已说明合成、规模、划分和限制；9B 的样本对象需改正，不能把 56 probes 写成事实格子 |
| A12 指标 | 主实验分布指标与任务指标明确区分；9B 值位与线性读出需按 R07 限定 |
| A13 基线 | 五臂足以服务本次初步测量；不能据此宣称优于所有参数化或检索方法 |
| A14 复现性 | 有模型 revision、优化配置与 bootstrap seed；未完整给运行 seed、batch 等，H20 来源与 ρ 定义需补齐 |
| A15 消融 | 已扫 rank、更新数和重放；不能称已经独立识别所有瓶颈 |
| A16 统计 | 整题配对 bootstrap 合理；区间条件、少量簇已披露；没有检出、等效、机制排除须按 R03/R04/R09 区分 |
| A17 总表 | 有结果表；H20 边际行的分母与来源需按 R11 校正 |
| A18 案例 | 可选补一个成功/失败 probe，非本版发布硬门槛 |
| A19 失败分析 | 有教师、格式、容量检查，但标题和排除力度需收窄 |
| A20 泛化 | 跨历史与 9B 伴随协议可作探索；不够支持保守界或机制普遍性 |
| A21 开销 | 可以保留参数/字节/更新数与条件复杂度；无实测总成本优势，且更新数有 R08 错误 |
| A22 效度 | 有 construct/internal/external 三类讨论；需与正文承重句保持一致 |
| A23 LLM 特殊项 | 以教师分布为经验参照的研究不强制额外幻觉率；披露 prompt、目标与评分路径即可，不将教师一致性叫事实正确性 |
| A24 局限 | 已充分列举局限；局限章节中的正向归因仍须修正 |
| A25 文献对照 | 主题对照存在；不强制每篇都跑基线，关键是准确描述 |
| A26 工程比重 | 方法和测量为主体，符合定位 |
| A27 展望 | probe、历史多样性、模型泛化与已知限制对应；删去未经识别的“只学到这些”前提 |
| A28 符号 | R/R0、压缩比方向、ρ 与硬编码章节见上文 |
| A29 时效 | 近期文献充足；不套用预印本最多五篇的学位限制 |
| A30 相关工作篇幅 | 学位论文 6–12 页要求不适用 |
| S01–S03 | 不要求学位目录三级、绪论组织结构段或每章小结；仍保留基本标题编号检查 |
| S04、S05 | 摘要应具体；中文篇幅与中英对照不适用 |
| S06、S07 | 题目可保留为研究主题；需统一术语、比较对象与单位 |
| S08 | 未见实际使用的 TODO/致谢模板污染；定义 todo 宏和源码注释本身不算残留 |
| S09、S10 | 方法、实验设计、结果、讨论基本分开；不要求固定章序 |
| F01 | 46 个 cite 键与 46 个 bib 条目匹配，无缺失键；不作真实性全量认证 |
| F02、F03 | 采用一致 ACM 体例；不强制 GB/T，不限制 arXiv 数量 |
| F04、F05 | 使用 LaTeX 公式；静态检查未见缺失 ref 标签或重复 label，硬编码节号仍需修正 |
| F06、F07 | 可引用模型卡、代码与预印本作相应事实来源；文献论证准确性比条目类型数量更重要 |

## 建议的修改顺序

1. 先修事实与对象：56/96、0.01597、36×2304、数字读出对象。
2. 再修推断：重放的唯一归因、coverage 胜过 rank、27B 保守界、交叉点的迁移与确定性。
3. 同步摘要、贡献、takeaway、limitations、future work、conclusion，避免只在末尾添加一段免责声明。
4. 最后补齐 ρ 与 H20 来源，统一符号及章节引用，再编译 PDF。

可采用的核心结论是：

> On four constructed histories with one fixed 27B model, a session-local low-rank write reduced divergence from a full-context teacher in three cases. For the tested summary-generation policy, the sampled fidelity ordering changed as the text budget narrowed. Rehearsal reduced measured off-topic side effects in one history, while neither pre-registered success condition was met. These measurements do not establish task-level memory, equal-cost superiority, a universal crossing point, or a general limit of low-rank carriers.

本次保留了论文最有数据支撑的部分：受控的载体比较、离散预算次序反转以及重放的条件权衡。需要撤回的是由这些观察推出的更广成本、容量、机制和可迁移性结论。
