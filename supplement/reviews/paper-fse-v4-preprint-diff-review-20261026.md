# paper fse v4 更新差异复审

本轮改动部分收窄了措辞，但还不能认为已完成“结论不超出实验数据”的修订。最明确的问题是 §6.2 的训练量比较：16→64 遍时 KL 实际改善，正文却说变差。此外，新增的“only inside cells that were supervised”加入了没有被实验识别的排他结论；“全文表格是否被复现”的负向判断也不能由未做内容测量的 27B 实验推出。

审查日期：2026-10-26。保持非学位、非投稿、初步预印本口径。只审查，未改论文。

本轮逐行检查了以下两个快照的全部 diff，并重读其相邻段落与相关本地数据：

- 基线：[前次审查快照](E:/MasterStudy/AdVance%20ComPact/tmp-v4-preprint-review-20261026/paper-fse-v4.review-snapshot.tex)，19:37:09，SHA-256 `475e09336cdae38ce7d326a12e85d8d4d8ad1eab549579f72413d775761e3aa7`。
- 本轮：[更新审查快照](E:/MasterStudy/AdVance%20ComPact/tmp-v4-preprint-review-20261026/paper-fse-v4.diff-review-snapshot.tex)，19:39:54，1143 行，SHA-256 `4b75949300881109ec0c9ac075d02abddc09546a66405a48bc279fbfdb52e8ae`。
- [完整 diff](E:/MasterStudy/AdVance%20ComPact/tmp-v4-preprint-review-20261026/v4-review-updates.diff)：三个修改区块，均在讨论部分。以下行号以本轮快照为准。

## D01 训练量比较的起点与 KL 方向不一致

位置：L841–845；表 9 的 L831 同样受影响。优先级：高。该错误前次审查未单列，本次复核补出。

新增文字将 0.29→0.50 描述为训练量从 16 到 64 遍的变化，并保留了 `KL moves slightly the wrong way`。[m30_acc5.json](E:/MasterStudy/AdVance%20ComPact/.local-8b/m30_acc5.json) 在相同 40 题、题等权口径下的数据是：

| 遍数 | 总更新数 | 值位 top-1 | KL |
|---:|---:|---:|---:|
| 4 | 144 | 0.220000 | 0.722984 |
| 16 | 576 | 0.288333 | 0.766097 |
| 64 | 2304 | 0.496667 | 0.750835 |

因此，16→64 遍时，准确率上升而 KL **下降、改善**；只有选择 4→64 遍时，才是准确率改善而 KL 恶化。附录现有 4→64 的比较是相符的，正文和表 9 没有采用同一对端点。

两种改法任选一种：

> From four to 64 passes, value-position top-1 on the fixed 40-question set rose from 0.220 to 0.497, while KL increased from 0.7230 to 0.7508.

或者保留 16→64：

> From 16 to 64 passes, value-position top-1 on the fixed 40-question set rose from 0.288 to 0.497, while KL decreased from 0.7661 to 0.7508.

这些是评测集上的教师前缀条件值位 top-1。若要报告训练措辞的拟合准确率，应使用对应训练口径，不能把 40 题的 0.29/0.50 直接称为训练准确率。

## D02 新增 only 限定仍是没有证据的排他归因

位置：L841–843；相邻 L851–857、L903–907、L921–923。优先级：高。

`dominates` 改为 `matters` 是合理收窄；但新增 `only inside cells that were supervised` 反而声称训练量对其他格子没有作用。当前扫描没有在事实覆盖与问答形式覆盖被严格定义、固定其他因素的条件下证明这种排他性。

前次 R01 仍在：56 是 probe 数，36 个 canonical probe 已含所有训练实体的三字段问答。P1 留出的是已有实体/事实与单字段输出形式的组合，不能直接叫未监督事实格子。新增 probe 的实验同时从 3584 增至 5120 更新，因此也没有独立分离覆盖与优化预算。

建议删去 `only inside cells that were supervised`，改用 D01 中直接报告固定题集的句子。将相邻的机制总结改为：

> Performance was sensitive to the training-question distribution in the companion runs. Adding single-field probes improved the held-out single-field evaluation, while also increasing the total number of updates. The relative roles of factual coverage, answer-format coverage, optimization and capacity remain unresolved.

依据：[m37 训练构造](E:/MasterStudy/AdVance%20ComPact/.local-8b/m37_shape.py:75)、[m37 汇总](E:/MasterStudy/AdVance%20ComPact/.local-8b/m37_shape.json)、[m38 汇总](E:/MasterStudy/AdVance%20ComPact/.local-8b/m38_covered.json)。

Future Work 去掉 `and nothing else`、加入 `in our runs` 有进步。但后半句仍将 probe 集确定为载体“将能回答什么”的集合。可以收窄为“probe 选择影响已经测到的表现，尚无足够的覆盖模型”，不必先证明它完全不能回答未监督组合，才能主张 probe 设计值得研究。

## D03 区分 companion 是修正，但没有证明 27B 不复现表格或 coverage 决定一切

位置：L882–886。优先级：高。

在 `at full coverage` 前补上 `in the companion`，修正了正向结果的模型归属。但整句还保留两个不成立的推断：

1. `At the coverage of this paper it does not reproduce the table`：27B 主实验没有独立内容金标/整表恢复测量；KL 不为零不能直接证明它不记得或不能复述表格。未建立“能”也不等于建立“不能”。
2. `axis, set by coverage rather than by the objective`：实验没有在匹配更新量的条件下独立识别覆盖效应，也没有比较足以排除目标函数作用的不同目标；因此不能用 rather than 作因果排除。

伴随实验的完整覆盖版本确实表现很好：[m39_full.json](E:/MasterStudy/AdVance%20ComPact/.local-8b/m39_full.json) 为 156 个 probe、9984 次更新；固定 40 题的值位 top-1 为 0.99375，换问法层为 1.000，见 [评测汇总](E:/MasterStudy/AdVance%20ComPact/.local-8b/m30_acc5.json)。这支持指定条件下的高值位命中，仍应避免写成未经定义的完整表格恢复或自由回答保证。

建议整项改为：

> Distributional fidelity does not establish content recall. The 27B study does not measure factual recall independently of the teacher. In the companion study, expanded probe coverage and additional updates produced high value-position top-1 on the evaluated questions. These observations do not isolate the effects of coverage, optimization or the training objective.

## D04 从 Δ 本身读出整表的结论仍未修复

位置：L844–846；附录 L1127–1129。优先级：高，前次 R07 未解决。

本轮改写了其后面的解释，但仍保留 `the supervised table becomes readable from Δ itself`。真实实验是：对带输入激活及教师答案前缀的 adapter contribution，线性预测下一个数字；标签是 0–9，250 个数字位置，不是从权重独立解出整表。

建议：

> At selected teacher-forced digit positions, the next digit was linearly decodable from adapter-contribution activations.

数值 0.928 可以保留，但应同时明确多数类基线、样本数与条件路径。依据：[m32 解码脚本](E:/MasterStudy/AdVance%20ComPact/.local-8b/m32_digitdecode.py:7)、[m32 结果](E:/MasterStudy/AdVance%20ComPact/.local-8b/m32_digitdecode.json)。

## 前次主要问题在新版中的状态

本轮不是全量重新认证；下表复查了前次主要问题对应的承重句。

| 前次项 | 本轮状态 |
|---|---|
| R01 事实格子/probe/输出形式混淆 | 未解决；最新 L852 仍是 56/96，L1121 仍称两组 only differ in what probes asked |
| R02 27B 保守估计/界 | 未解决；L865–866 仍用 companion 推出 conservative estimate |
| R03 重放不属于载体的归因 | 未触及；L773–776、L785–787 仍保留 |
| R04 0.01597 被归为摘要加 Δ | 未触及；L751–755 仍保留 |
| R05 同等保真成本、paid once | 未触及；摘要与成本论证仍保留 |
| R06 Doc-to-LoRA 上下文一直在窗口 | 未触及；相关工作原句仍在 |
| R07 条件数字读出写成整表读出 | 未解决，见 D04 |
| R08 36×2304 更新 | 未触及；L817 仍是相同乘法 |
| R09 四历史交点/迁移力度 | 未触及 |
| R10 ρ 与 summary channel 定义 | 未触及 |
| R11 H20 边际收益来源与分母 | 未触及 |

## 这一轮建议采取的最小修订

先统一训练量端点与 KL 方向，再删除 `only`、`rather than`、`conservative estimate` 等未被识别的排他或界限判断。对 coverage 段直接报告训练构造和观测分数；对 27B 写“没有测量内容恢复”，对 9B 写“指定教师前缀条件下的值位表现”。前次报告列出的事实错误仍应修正。

本轮没有要求新增实验。上述措辞修正足以让已有结果更准确地落在证据范围内；若想保留一般机制、唯一瓶颈或保守界的判断，才需要设计能够区分这些解释的新对照。
