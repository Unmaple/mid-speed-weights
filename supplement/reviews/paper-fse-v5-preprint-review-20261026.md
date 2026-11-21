# paper-fse-v5 修复复核与回归审查

审查日期：2026-10-26。对象为《Remember Rather Than Hand Off: Mid-Speed Weights for Cross-Compaction Continuity》。按非学位论文、非投稿版的预印本口径，重点检查结论与实验支持是否相称，不以篇幅、匿名或学位论文格式作为门槛。

**结论：v5 有实质修复，但还不能把 R01–R11 全部视为闭合。** 数字读出对象、总更新数、漂移实验臂归属、27B“保守估计”以及 Doc-to-LoRA 保留原上下文的错误均已纠正。仍有三个应优先修正的问题：9B 的 KL 方向错误；正文其他段落重新作出已撤回的内容/覆盖归因；成本复杂度没有改正确。另外发现新增的统计口径错误、adapter 来源表述错误和相关工作对比风险。

本次未修改论文源码或用户原 PDF。已检查完整源码和 v4→v5 diff，复算关键 9B 数据，独立编译并检查关键 PDF 页面。

## 版本与范围

- v5 源码：`paper-fse-v5.tex`，1,174 行，修改时间 2026-10-26 20:09:09。
- SHA-256：`23e48e20565732bb760b9a68afd48887b7f09a7dad6c8b1b36b04bd0cd35aa79`。
- 基线同时核对首次 v4 审查快照 `475e0933…` 和上次 diff 审查快照 `4b759493…`；下列“新增”相对于这两份已审版本而言。
- 所有 L 行号均指本次 v5 快照；P 为当前 PDF 的物理页码。
- [源码快照](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/paper-fse-v5.review-snapshot.tex>)、[v4→v5 diff](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/v4-to-v5.diff>)、[检查结果](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/verification.json>)。

收尾时检测到 20:20:49 的更新，SHA-256 为 `28b27a8fc8882292b1f9287c152bd7ad4f3c403704b57ec23e57603d53acfa1d`。已单独复核[本次审查期间的 diff](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/v5-during-review.diff>)：仅 L975 的相关工作矩阵列宽和 L994 的换行/缩短单元格文字，无行号增减，上述发现继续适用。[更新快照](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/paper-fse-v5.review-update-snapshot.tex>)保留该版本。

又补查了 20:23:14 的[第二次排版更新](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/v5-during-review-update2.diff>)，冻结 SHA-256 为 `dd58045097a3437fa4eb94f31ed630d268dcd8b915dcf94b27db0a897f53f715`：将设计空间表移到 §4 开头，并把三张表从顶部浮动改为底部浮动；忽略整块移动后没有增删实验或结论。各项实质发现仍然成立。报告原有页码、行号以第一份快照为准，尤其 §4 内部行号和后续 PDF 页码可能随浮动调整；[第二次更新快照](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/paper-fse-v5.review-update2-snapshot.tex>)及其独立编译产物保留以便核对。

最终又对 20:24:18、SHA-256 `a8755e6802f5740d8dfdb61e2e51bb18951d2795aef8f7302bb8ff7fbe9b8912` 的[第三次更新做了 diff 复核](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/v5-during-review-update3.diff>)：仅将 §5.3 的原有说明整块移到重放表之前，没有改动结论或数值。本报告实质判断覆盖这次更新；独立编译与最终图形检查覆盖上一份冻结版本，不将它冒充为最后这次重排的构建结果。

## 前两轮问题的修复状态

| 旧编号 | v5 状态 | 判断依据 |
|---|---|---|
| R01 覆盖实验被写成事实未见/覆盖胜过容量 | 部分修复 | L876–888、L1151–1158 已准确说明事实见过、格式组合留出及更新数混杂；L866–867、L904–908、L944–952 又恢复排他性解释，见 V02 |
| R02 把 9B 改善外推成 27B 保守界 | 已修复主要问题 | L885–888 改成特定指标上 1.61 倍的交点变化，明确 27B 方向和大小未测 |
| R03 重放结果被写成副作用可消除及唯一归因 | 主要修复 | L779–810 披露 80 对 64 更新、两项门均未通过，撤回载体本质归因；个别过强措辞仍见后文小项 |
| R04 0.01597 的实验臂及漂移显著性 | 已修复主要问题 | L771–777 正确归为两份摘要，明确配对漂移差区间跨零；摘要数值方向本身正确 |
| R05 文本与参数的成本复杂度 | 未闭合，局部更明确地写错 | 新摘要把“每个携带 token、每个下一位置”写成 O(L)，见 V03 |
| R06 相关工作及新颖性 | 主要事实已修复，仍有新增对比风险 | 承认 Doc-to-LoRA 无原文推理，撤回“first”和更多带宽的实证口吻；L1017–1018 的新对比见 V06 |
| R07 数字线性读出被称为表格重建 | 已修复主要问题 | L1160–1164 明确 250 个 teacher-forced 数字位置、基线及条件可解码性，明确不是从权重独立重建表格 |
| R08 36×2304 更新数 | 已修复 | 三处统一为 2,304 总更新、36 probes 的 64 passes |
| R09 交点与迁移强度 | 部分修复并引入新错误 | 已改为样本点估计，说明未做样本外验证；新增“只有 H1 两端区间排零”不符合表 7，见 V04 |
| R10 未定义的摘要诊断 | 部分修复 | 标题和未定义 rho 已删除，但未定义诊断仍承担“排除解释”的结论，见 V07 |
| R11 H20 边际表跨运行绝对值 | 已修复主要问题 | 已移除不匹配的绝对值，说明相对量来自各自运行内部配对；建议把最后一句改成“separate paired comparisons”以免读成没有配对 |
| D01 16→64 passes 的 KL 方向 | 未修复 | 表 9 和 §6.2 仍写反；附录及 Threats 已是正确的 4→64 比较，见 V01 |
| D02 只有监督过的 cells 才能改善 | 未修复 | L866 的 “only inside cells” 仍在，见 V02 |
| D03 未测的 27B 表格恢复被写成失败 | 未修复 | L907 仍说本实验不重现表格，与“未测”不一致，见 V02 |
| D04 从 Δ 读出整张表 | 已修复主要问题 | 已改为数字位置条件解码；但 L907 的“holds a table”论证仍应单独撤回 |

## 应优先修正的遗留问题

### V01 [P1] 9B 的 KL 方向仍写反，主文与附录冲突

位置：[L855](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:855>)、[L865–868](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:865>)，P.9；与 L1078–1079、L1146–1147 冲突。属于旧 D01 遗漏。

`m30_acc5.json` 的同一 40 题集合可直接复算：

| passes / 总更新 | 值位 top-1 | KL(T‖RD)，越低越好 |
|---|---:|---:|
| 4 / 144 | 0.220000 | 0.722984 |
| 16 / 576 | 0.288333 | 0.766097 |
| 64 / 2304 | 0.496667 | 0.750835 |

因此 **16→64 时 top-1 和 KL 都改善**；只有选取 **4→64** 这对端点，才是准确率上升而 KL 变差。v5 的表 9 和主文仍将 0.29→0.50 与“KL moves the other/wrong way”配成同一比较，结论不符合数据。

最小修法：主文和表 9 统一采用附录已正确使用的 4→64 比较，注明是在 40 题值位评估上；或者保留 16→64，写明 KL 从 0.7661 降到 0.7508，另用一句独立描述 4→64 的指标分离。不要把 40 题评估准确率写成训练集准确率。

证据：[原始数据](<E:/MasterStudy/AdVance ComPact/.local-8b/m30_acc5.json>)；本次重新按 40 题等权平均，结果与 `all` 汇总一致。

### V02 [P1] 覆盖段已收窄，Limitations 和 Future Work 又把同一结论说满

位置：[L865–870](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:865>)、[L904–908](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:904>)、[L944–952](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:944>)；P.9–10。主要是 R01、D02、D03 遗留。

L876–888 的新解释是对的：留出的单字段问题涉及的事实已经出现在三字段训练中，新增 probes 同时改变训练分布和更新数，不能隔离事实覆盖或容量。可是其他段落仍说：

- “only inside cells that were supervised”：未识别出这种排他规律；值位评估也不等于只有指定事实格子能学习。
- “axis, set by coverage rather than by the objective”：实验未控制更新数，未比较能隔离这一归因的目标函数，不能排除 objective。
- “At the coverage of this paper it does not reproduce the table”：27B 没有独立事实金标的表格重建测量，未测不能写成已经失败。
- “in the companion, at full coverage, it does”：训练问题上的 teacher-forced 值位 top-1、部分换问法评估和数字位置读出，不等于完整表格的独立自由生成重建。
- “a probe set is not a sample … but a choice of what the carrier will be able to answer”：把有限格式组合上的观察变成确定的可回答集合，也超出证据。

建议用同一口径覆盖所有这些位置：

> The companion shows sensitivity to training exposure and to entity–answer-format coverage. The intervention changes both probe composition and update count, so it does not isolate their effects. At 27B we measured distributional fidelity, not independent table reconstruction or factual accuracy.

Future Work 可以据此提出设计 probe 采样框，但不要把“覆盖决定一切”作为已验证前提。

证据：[m37](<E:/MasterStudy/AdVance ComPact/.local-8b/m37_shape.json>)、[m38](<E:/MasterStudy/AdVance ComPact/.local-8b/m38_covered.json>)、[数字读出](<E:/MasterStudy/AdVance ComPact/.local-8b/m32_digitdecode.json>)。

### V03 [P1] 新摘要明确混淆了“单个携带 token”与“整个上下文”的注意力成本

位置：[L84–86](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:84>)、[L232–242](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:232>)、[L429–444](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:429>)、L1050–1057。属于 R05 遗留及新版单位表述回归。

v5 写一个携带 token 在下一 episode 的**每个位置**成本为 O(L)。对固定模型维度、缓存前缀的标准稠密注意力解码：设携带前缀有 k 个 token，后续生成 m 个 token，那么该前缀给每个新 query 增加 k 个 key/value 比较，增量为 O(k)，整段解码增量为 O(km)。**单个携带 token 对单个新位置的贡献为 O(1)**；整个 attended sequence 的扫描才随其长度增长。若 L 指完整 episode 长度，则不能再给每个位置乘一次 L。

同样，L435–438 把固定宽度滑窗、固定上限摘要、固定注入条数的 ledger 一概归为随历史 |H| 上升的曲线，与前文“这些载体有固定 cap”矛盾。固定 k 和固定 adapter 的使用端增量都可相对历史长度保持常数；常数、上下文占用和可达保真度不同，不能据此宣布一条必然增长、另一条水平。L159 的 “paid once”也仍遗漏未合并 adapter 每个处理 token 的矩阵运算，虽然后文已有补充。

最小修法：把复杂度条件写实，保留已成立的“不注入文本前缀”“固定配置不随 |H| 增长”，删除无条件的两条不同形状曲线论证。可写：

> With cached dense attention and fixed model dimensions, a k-token carried prefix adds O(k) attention work per decoded token and O(km) over m decoded tokens. A fixed unmerged adapter adds a constant amount of computation per processed token and occupies no context positions. We do not measure a common-unit cost comparison or equal-fidelity scaling with history length.

写入端另列教师采集、64 次优化和目标位置数，不把“配置固定”扩展成总成本与历史无关。无需新实验即可收窄为成立的分析。

## 新增或在重写中暴露的具体问题

### V04 [P2] “只有 H1 两端区间排零”遗漏了 H20 的问题级区间

位置：[L742–744](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:742>)，P.7；文件头 L22 也重复。**新增。**

表 7 已报告 H20 在 256 token 时的配对区间为 [−0.0897,−0.0010]，128 token 时为 [+0.0137,+0.1037]，两者都排除零。因此无条件说 “only H1 … intervals both exclude zero” 与同文表格冲突。

H20 的问题是 256-token 端点在**调用簇重采样**下跨零，正文 L702–704 已正确披露。若想突出 H1，应明确它的两个端点在问题级和簇级口径下都排除零，而不能把两种口径混在一起。

建议：

> H1's 50- and 200-token endpoints exclude zero under both question- and cluster-level resampling. H20's 128- and 256-token endpoints exclude zero under question-level resampling, while its 256-token endpoint is sensitive to cluster resampling. The proposed short-history brackets for H2 and H3 remain uncertain.

证据：本论文表 7；[三历史逐点结果](<E:/MasterStudy/AdVance ComPact/experiments/compact_delta/summary-cap-threeH-20261026/RESULTS-main-v3.md>)。仍不应将离散预算 bracket 写成交点置信区间。

### V05 [P2] 0.969 不是该段覆盖干预中的“同一 adapter”

位置：[L882–883](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:882>)，P.9。**新版明确加入 “the same adapter”，延续并加重旧版来源混用。**

0.968750 来自 `m34_rewording.json`，其 adapter 明确为 `m31_rd_2304.pt`。同段 0.3125 来自 `m37_rdshapes.pt` 的 3,584 步训练，0.84375 来自 `m38_rdcovered.pt` 的 5,120 步训练，三个数字并非同一 checkpoint 的对照。

另外，0.969 是同三字段/同顺序、不同问法下的**值位 top-1**，不是“实体识别准确率”；“wording generalises and format does not”仍把特定测试条件概括为二元性质。

建议：

> In a separate 2,304-update run, value-position top-1 was 0.969 on reworded three-field questions with the answer shape held fixed. These tests show different sensitivities under the tested wording and answer-format changes; they do not isolate a general wording-versus-format distinction.

证据：[m34](<E:/MasterStudy/AdVance ComPact/.local-8b/m34_rewording.json>)、[m37 程序](<E:/MasterStudy/AdVance ComPact/.local-8b/m37_shape.py>)、[m38 程序](<E:/MasterStudy/AdVance ComPact/.local-8b/m38_covered.py>)。

### V06 [P2] Doc-to-LoRA 新对比容易重新造成错误的新颖性区分

位置：[L1012–1018](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:1012>)，P.10。**新增对比措辞风险。**

前半段承认无原文推理是正确修复。但结尾 “a comparison of two carriers rather than of a mechanism against its absence” 容易暗示先前工作只做有无机制的比较。如果这是相对于 Doc-to-LoRA 的区分，则不成立：其 §5 明列 in-parameter 与 in-context 基线，Figure 3 和 Figure 4 还扫 LLMLingua-2 压缩率，与 adapter 作比较。它已有跨载体和压缩预算的比较。

可以保留本论文更具体的组合：正在运行的压缩引擎、compaction 触发、固定教师轨迹、指定 KL 与无关漂移测量。建议删除最后这一对比半句，改为：

> Our study focuses on a compaction-triggered write and compares it with a production summary-generation policy over a token-budget sweep, using fixed teacher-path fidelity and off-topic drift measurements.

本项不是要求增加基线或否定论文定位，而是避免从一个已纠正的前作事实转移到另一个缺证据的独特性断言。依据：[Doc-to-LoRA 原文 §5、Fig.3–4](https://arxiv.org/html/2602.15902v1#S5)。

## 删除数字后仍未自足的结果

### V07 [P2] summary channel 的“负结果”仍缺对象、定义和支撑表

位置：[L825–828](<E:/MasterStudy/AdVance ComPact/paper-fse-v5.tex:825>)，P.9。R10 未完全修复。

删除 rho 和 12 个 CE 可以消除未定义符号，却不能代替对诊断任务的说明。现在读者仍不知道目标是哪三份摘要、四个条件是什么、CE 沿哪条前缀评分，以及“negative result”具体意味着什么。主结果中 SRD 在部分历史改善，这里的 summary reproduction 是另一任务，必须区分。

现有产物能支持：沿固定摘要真实前缀做 teacher forcing，共同八标题模板使各核心 CE 下降，H20 两目标上 RD 相对 R 的 CE 劣势未反转，H3 的小幅优势也未反转；不能因此全面排除格式、语言和目标构造的影响。

最小修法有两种：直接删去该诊断项；或用短附录给出任务定义和小表，措辞改成“this heading-template intervention did not reverse the observed ordering”。不要继续以 “does not account for” 作机制排除。

证据：[模板对照结果与公式](<E:/MasterStudy/AdVance ComPact/experiments/compact_delta/s-reproduction-template-v1/RESULTS-main-v1.md>)。

## 其余修订建议

| 位置 | 尚存问题及最小修法 |
|---|---|
| L794–806 | “the detectable part … go away”不能识别出一个被消除的因果成分；“exactly where the rehearsal trade would break first”是尚未测量的预测。改成实测效应、区间及“whether the trade changes near saturation remains open” |
| L639–642 | H20 各自运行内部有配对，结尾 “rather than as matched pairs”会混淆。建议“These are separate within-run paired comparisons, not absolute values from the shared sweep run” |
| L270–278 对照表 10 | A 不成立时，A′按定义应为 n/a；Doc-to-LoRA、DPPM、RPMem 等仍写 —，Sleep 等仍写 ×。统一为“不适用 / 未报告 / 不满足”，CCM 改成 — 只是局部修复 |
| 图 1，P.8 | 图例仍写 R 而正文写 R0；“see report for sensitivity”没有明确目标。改为 R0 和“cluster sensitivity in §5.2” |
| L92 与 L487–489 | 16×是 H20 名义 cap 1024→64，实际 body 是 1002→64≈15.66×；短历史跨度不同。摘要可加“nominal cap”限定 |
| L519 | “32 questions share a fixed gold prefix”易读成所有问题使用同一串前缀。建议“Each unrelated question is scored on its own fixed gold prefix, for 50 positions in total” |
| L151–166、L234–239 | 人类记忆、语言熵和参数字节不是同口径容量指标；已有声明但仍以此承重论证瓶颈。建议仅作动机，不推出参数载体具有更大的可用记忆或固定文本在所有架构下随历史成本增长 |
| L933–937 | “per session”与“at the boundary”仍需统一：本文只测一个边界，没有验证同一 session 多次压缩的累计写入与覆盖。补一句范围说明即可 |

## 编译、引用与 PDF 验证

- 使用本地缓存的 Tectonic，独立输出至诊断目录，编译退出码 0，得到 13 页 PDF；用户原 PDF 未覆盖。
- 用户 PDF 与独立编译 PDF 的逐页提取文字完全一致，未发现拿旧 PDF 审新版源码的情况。
- 所有 label/ref 对应，未发现重复 label；46 个使用中的引用 key 均存在于 `references.bib`。这不是对全部未变动参考文献内容的新一轮真实性认证，本次联网复核聚焦改写中的 Doc-to-LoRA。
- 已查看摘要、成本模型、实验定义、设计空间和结果表、图 1、§6.1–6.2、相关工作矩阵、附录和参考文献页。新设计空间行没有明显表格溢出，未发现新增的缺图、问号引用或阻断性 LaTeX 错误。
- 仍有两处轻微 Overfull hbox：L360–362 的 I2 行约 7.96pt；文末约 4.59pt。另有 fancyhdr、图片说明及部分 BibTeX 缺字段警告；这些不是本版证据结论的主要风险，也不按投稿版要求升级为发布门槛。
- [独立编译 PDF](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/build/paper-fse-v5.pdf>)、[TeX 日志](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/build/paper-fse-v5.log>)。
- 20:23:14 的冻结版本也已独立编译通过，仍为 13 页，并复查移动后的表格和矩阵排版：[更新版 PDF](<E:/MasterStudy/AdVance ComPact/tmp-v5-preprint-review-20261026/frozen-update2/paper-fse-v5.pdf>)。20:24:18 的最后重排仅做 diff 复核，见版本说明。

## 建议修订顺序

1. 修正表 9 和 §6.2 的 16→64 KL 方向，统一比较端点。
2. 全文同步覆盖/内容结论，特别删除 Limitations 中“27B 已不能重建表格”的未测断言。
3. 重写成本的计量单位和条件，撤回固定文本载体必然随 |H| 增长的概括。
4. 修正 H1/H20 区间口径和 0.969 的 adapter 来源，删除 Doc-to-LoRA 的隐含错误对比。
5. 给摘要复现诊断补最小定义和表，或删掉该项；最后处理符号和图内指向。

这轮主要需要修正和同步文字，不能用新增限制声明抵消前文相反的结论。未测的独立表格重建、等成本优势、跨历史迁移与饱和重放权衡，可以继续明确留作开放问题。
