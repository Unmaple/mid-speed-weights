# Remember Rather Than Hand Off

**Mid-Speed Weights for Cross-Compaction Continuity**

Mingjie Zeng · Xin Zhou (通讯作者) · He Zhang

南京大学计算机软件新技术国家重点实验室（State Key Laboratory for Novel Software Technology, Nanjing University）

**[阅读 v10 论文 PDF](paper/paper-AVCP-v10.pdf)** · [中文辅助译文](paper/paper-fse-v10-zh.md) · [辅助材料索引](supplement/README.md)

版本说明：经老师审核的 [v10 PDF](paper/paper-AVCP-v10.pdf) 是本文的正式版本（2026-10-26 冻结，13 页）。仓库中的中文译文、TeX 源码、实验账本、旧版审阅及后续研究供参考。若表述、数据或结论与 v10 PDF 有冲突，以 v10 PDF 为准。

## 论文研究什么

长会话在压缩时通常以摘要或保留的上下文尾段传递历史。本文比较另一种载体：在压缩边界将全上下文教师的输出分布写入会话局部、未合并的低秩适配器 Δ。清除 Δ 后，模型恢复到与冻结基座逐位相同的状态。实验使用单个 27B 模型和四段合成历史。

| 问题 | v10 的结果 |
| --- | --- |
| Δ 是否更接近全上下文教师？ | 相比仅保留尾段的 R0，三段历史的 KL 分别降低 25.1%、28.0% 和 28.5%。第四段的点估计为 7.7%，区间跨零。H3 中，在摘要上加 Δ 使 KL 进一步降低 17.8%。见 §5.1。 |
| 什么时候 Δ 比摘要更接近教师？ | 在约 20k token 的 H20 上，采样点的排序在摘要正文 128–256 token 之间反转，对应 77.5–154.9 倍压缩。256-token 端点对整簇重采样敏感。见 §5.2。 |
| 写入会影响无关问题吗？ | H20 的无关题上，Δ 的漂移点估计约为 0.026 nats/位置（正文点估计 0.02587），两种摘要约为 0.017 和 0.016（0.01663 / 0.01597）。与摘要的配对差区间跨零。见 §5.3。 |

主实验测量的是输出分布保真度。独立事实准确率、交叉点的跨模型稳定性和同成本下的载体比较仍待验证。

## 追溯论文中的结果

- **表 4、表 5（§5.1，分布拟合）**：运行账本 [实验结论 · 三份历史的主实验结果](supplement/evidence/实验结论.md#三份历史的主实验结果) 与 [20k 历史与两档摘要的当前结果](supplement/evidence/实验结论.md#20k-历史与两档摘要的当前结果)。表 5 的 H20 两行来自各自的比较，账本记的是绝对值，PDF 按原文只给相对值。
- **图 1、表 6、表 7（§5.2，摘要预算）**：同一份账本的「H20 五点摘要预算曲线与重放训练验收」「三历史摘要预算扫描完成」两节；[阶段报告](supplement/evidence/r-star及后续实验阶段报告-2026-10-26.md) 第 2、4 节是这批运行的整理稿。
- **表 8（§5.3，无关题漂移与排练）**：账本的「H20直接漂移与上下文参考」「原H20最小集：16条基座重放」「H20 λ=0.5重放附加臂」三节；阶段报告第 3 节是整理稿。
- **附录 A（9B 伴随实验）**：阶段报告第 6 节（§6.1 的训练量口径、§6.3 的线性读出 0.928）。**173 s / 224 s 两个计时见 [V4-CHANGES](supplement/changes/V4-CHANGES.md)，口径（这组秒数是“额外 24 个探针”的增量成本，且没有 artifact 记录）见 [V10-CHANGES](supplement/changes/V10-CHANGES.md) 的 A10。**

首页只指向运行账本与整理稿这两类材料；旧版审阅、v10 之前的历史文件、v10 之后的续作见[辅助材料索引](supplement/README.md)。逐表清单和统计脚本按论文的 Data Availability 声明向作者索取。

## 源文件

[TeX 源文件](paper/paper-fse-v10.tex) · [参考文献](paper/references.bib) · [图 1](paper/figures/fig1-rstar.png) · [arXiv 源文件包](paper/arxiv-submission-v10.zip)

使用 Tectonic 重编论文需要 TeX bundle，首次运行可能会下载。

```sh
cd paper
tectonic -r 3 paper-fse-v10.tex
```

材料的许可状态见 [LICENSE](LICENSE)，当前尚未选定开放许可。
