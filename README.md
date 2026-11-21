# Remember Rather Than Hand Off: Mid-Speed Weights for Cross-Compaction Continuity

**v10 · 冻结于 2026-10-26 · 13 页**

Mingjie Zeng, Xin Zhou\*, He Zhang — 南京大学计算机软件新技术国家重点实验室（\*通讯作者）

> 摘要（节译自论文）：长会话里历史反复穿过 compact 边界，能活下来的只有文本——摘要、滑窗或账本。三者
> 每次使用都要付费：缓存稠密注意力下，携带的 $k$ 个 token 前缀为每个解码位置增加 $O(k)$ 注意力，$m$ 个
> 位置共 $O(km)$；而未合并的固定 adapter 每位置只增加常数计算，且不占上下文位置。三者还都有上限（摘要至多
> 32k token、滑窗宽度固定），所以穿过边界的东西是一个与历史长度无关的常数，**容量**和**重复代价**一样是天花板。
> 本文问的是：这个载体能不能换成参数。答案是量化了的：27B 单模型、四个历史上，$\Delta$ 相对 tail-only 把与
> 教师的散度降 25.1/28.0/28.5 \%（第四个历史 7.7 \%，区间跨零），在摘要之上再降 17.8 \%；在 20k 历史上，
> 文本载体一直更好，直到摘要被压到 128--256 token（77.5--154.9$\times$ 压缩）才反转。所有测量都是关于状态
> **放在哪里**，不是它能**记得什么**。

本仓库 = 论文本体（`paper/`）+ 辅助材料（`supplement/`）。v10 之后的后续研究（睡眠重放方向、D1/P02 等，
2026-10-27 起）不在本仓库内，见 [§未上传](#未上传的内容)。

---

## 论文本体 `paper/`

| 文件 | 作用 | 字节 | SHA-256（前 16 位） |
|---|---|---|---|
| [`paper-fse-v10.tex`](paper/paper-fse-v10.tex) | 源文件，1229 行，acmart sigconf（XeLaTeX） | 84 292 | `C5F7C19299183782` |
| [`paper-AVCP-v10.pdf`](paper/paper-AVCP-v10.pdf) | 交付 PDF，13 页（与 `.tex` 同一次构建） | 378 196 | `A72C1D986E4CAEA9` |
| [`paper-fse-v10-zh.md`](paper/paper-fse-v10-zh.md) | 中文全译（摘要、§1–§9、数据可用性、附录 A） | 64 255 | `051154EA162DDBCD` |
| [`arxiv-submission-v10.zip`](paper/arxiv-submission-v10.zip) | arXiv 提交包（见下） | 215 702 | `8C8FCBBCA90B419C` |
| [`references.bib`](paper/references.bib) | 46 条 BibTeX（正文 44 个 `\cite` 键） | 20 322 | `042090533751DDAE` |
| [`figures/fig1-rstar.png`](paper/figures/fig1-rstar.png) | 图 1（$\KL(T\|\cdot)$ 对压缩比 $r$，两栏面板） | 197 843 | `A73F57AD04042453` |
| [`paper-fse-v10.blg`](paper/paper-fse-v10.blg) | 交付版本的 BibTeX 日志（字节一致性的凭证） | 866 | — |

**构建可复现性**：仅用本目录的 `paper/` 重编，得到 13 页、正文抽取文本的 SHA-256 与
`paper-AVCP-v10.pdf` **完全一致**（`2d67768e5a5915aa`），即图片与参考文献齐备，不缺外部依赖。
PDF 的字节级差异只来自构建时间戳/ID。

## 构建

```bash
cd paper
tectonic -r 3 paper-fse-v10.tex        # 首次会下载 acmart 等 bundle
# 或：xelatex paper-fse-v10.tex && bibtex paper-fse-v10 && xelatex ×2
```

重编会在参考文献末尾出现一条 4.59 pt overfull hbox、在 §3.1 出现 7.96 pt 一条，v6–v10 一直如此，
记录在 [`V10-CHANGES.md`](supplement/changes/V10-CHANGES.md)。

## 版本链

| 版本 | 身份 |
|---|---|
| v1–v3 | 结构重写（`RESTRUCTURE-v2`、`REVIEW-FIXES-v3`） |
| v4 | 外部预印本审查的快照（`paper-fse-v4-preprint-review-20261026.md`） |
| v5 | v4 + 审查项 R01–R11 |
| v6 | v5 + V01–V05（数字与 artifact 的对应） |
| v7 | v6 + 编辑项 B/C + 审阅者修的三处算术 |
| v8 | v7 + R02/R05b（交点对象、交叉检验脚本方向） |
| v9 | v8 + 五处句级缺陷 |
| **v10** | **v9 + 五处出处（A2/A6/A7/A8/A10）；已交付** |

逐条改动在 `supplement/changes/V4-CHANGES.md` … `V10-CHANGES.md`。v1–v9 的 pdf/tex 字节副本留在
研究机上（`paper-archive/`，4.6 MB），本仓库只放当前版，避免把读者引向旧数字。

## 辅助材料 `supplement/`

按"读者要复核一个数字时该打开哪份文件"组织；逐份说明见 [`supplement/README.md`](supplement/README.md)。

| 目录 | 内容 | 用途 |
|---|---|---|
| [`supplement/evidence/`](supplement/evidence) | 两份 run ledger（`实验结论.md`、`r-star及后续实验阶段报告-2026-10-26.md`）、研究理由报告三份、`待验证假设与实验设计.md`、`results/`（58 份逐实验读数） | 论文里每个数字的出处 |
| [`supplement/CORE-DOCS-2026-10-27.html`](supplement/CORE-DOCS-2026-10-27.html) | 六份核心文档合订本（单文件 HTML，可离线读） | 辅助材料的"读完版" |
| [`supplement/companion-docs/`](supplement/companion-docs) | 合订本里的六份原文 + 七份 E 规格 + 三份设计备忘 | v10 之后的支线（见下方边界说明） |
| [`supplement/reviews/`](supplement/reviews) | 四轮外部预印本审查、SELFCHECK、相关工作定位、引用核实 | 结论为什么这么写 |
| [`supplement/changes/`](supplement/changes) | V4–V10 变更记录、重构说明、修改需求书 | 逐版可审计 |
| [`supplement/env/`](supplement/env) | 环境固定（`ENV-PIN.md`）、服务器只读核验、哈希扫描脚本 | 重建设备 |

**边界**：`supplement/companion-docs/` 里的睡眠重放方向（`SLEEP-REPLAY-v1`、
`EXPERIMENTS-SLEEP-REPLAY-v1`、`E6/E8/E9/E10/E11/E13/E14` 等）写于 v10 冻结**之后**，是续作，不是 v10
的证据。`SLEEP-REPLAY-v1.md` 自己也写明"不是论文文本，v10 已冻结，本文档不触发任何修改"。放在这里是因为
它们解释了 v10 的边界在哪，并且被合订本收录。`supplement/evidence/results/` 同理：时间跨度 2026-10-25 →
2026-11-21，只有 10-27 之前的部分进了 v10。

## 证据索引：论文里的数字去哪查

| 论文位置 | 关键量 | 来源 |
|---|---|---|
| §5.1 表 4 / 表 5 | 25.1 / 28.0 / 28.5 / 7.7 / 17.8 \% | `实验结论.md`；`results/e6_arms_curve.md`（28.4667 的复算） |
| §5.2 图 1 / 表 6 / 表 7 | $r^\ast$ 区间 77.5–154.9$\times$；128/256 token 反转 | 两份 run ledger；`results/r-ladder.md`、`results/rd_fits_h.md` |
| §5.3 表 8 | 无关问题代价 0.026 vs 0.017 nats/position | `实验结论.md`（5 处）；`results/e19_info_gate.md` |
| §1.1 / §1.4 / §3.3 | 载体 5,767,168 参数、11 MiB BF16（22 MiB FP32） | `实验结论.md`；`reviews/paper-fse-v4-preprint-review-20261026.md` R02（复算） |
| §1.1 | 125 MB / 375 KB（>2 个数量级） | `实验结论.md` |
| 附录 A | 0.32→1.000（4→64 passes）、173 s / 224 s、解码 0.928 | `r-star及后续实验阶段报告-2026-10-26.md` |
| 参考文献 | 46 条 | `references.bib`；`reviews/references-verification.md`、`reviews/REFS-FILL-v1.md` |
| §4 协议（历史、arms、判据） | H1/H2/H3/H20、T/R0/SR/RD/SRD | `evidence/待验证假设与实验设计.md` |
| 研究动机与取舍 | 为什么是 compact 边界 | `evidence/研究理由报告-MidSpeedWeights.md` |

## arXiv 包

`paper/arxiv-submission-v10.zip` 内的 `main.tex` 与 `paper-fse-v10.tex` **逐行相同，只少了开头的 97 行注释**
（0 处正文差异，已核对），另含预生成的 `main.bbl`、`references.bib`、`figures/fig1-rstar.png`。arXiv 端
因此不需要跑 BibTeX——直接提交 zip 即可。

## 未上传的内容

研究机上的工作树约 **125 GB**，其中与论文无关或体量过大的部分没有进仓库：

| 路径 | 体量 | 为什么不传 |
|---|---|---|
| `.local-8b/` | 93.0 GB | 权重、张量、逐实验脚本（m1…m99、`hf/`、`llama.cpp` 源码树）；论文 Data Availability 提到的原始张量在这里 |
| `experiments/` | 31.8 GB | 1,173 个 `.py` + 1,040 个 `.pt` + 日志；`.pt` 是原始张量 |
| `tools/` | 170 MB | `tectonic.exe` 51 MB + TeX cache；构建工具不应入仓 |
| `.research/` | 944 MB | 派单/回执类中间件，与论文无引用关系 |
| `tmp*/`、`pip-*`、`scratch/`、`probe6000/`、`personas/`、`hb-witness/` | 约 100 MB | 编译沙箱与临时目录 |
| `paper-archive/` | 4.6 MB | v1–v9 旧版；如需完整版本链，把该目录拷进 `paper/archive/` 再 `git add` |

即：**本仓库能复现"论文怎么写的"，不能复现"张量从哪来"。** 后者需要单独的 artifact 发布（见下）。

## Data Availability

v10 正文（§Data Availability）写的仍是 "the manifests and statistics scripts are available from the
authors on request"。本仓库就是那句承诺里"文档"的那一半。若希望正文直接指向仓库，需要发布 **v11** 并
改这一行（v10 的 `.tex`/`.pdf` 已按 SHA-256 冻结，不应原地改）：

```diff
- the manifests and statistics scripts are available from the authors on request.
+ the manifests, statistics scripts and per-number source documents are available at
+ https://github.com/<user>/<repo>, and the base model is pinned at
+ 1d4bf0f2ff6012fd82039f2fa52739d0dd7c60c0.
```

同时注意：正文承诺的**逐表 manifest**（输入文件、原始张量、两者的 SHA-256）与原始张量目前只在研究机上
（上表第一行）。要真正兑现，需要在发布时补一个 `manifests/` 子集，或把该句收窄为"resolved numbers 的
来源文档见仓库"。

## 许可

[`LICENSE`](LICENSE) 是**占位文件，尚未选定许可**。文本（论文、中文译本、审查与变更记录）与研究数据
（`results/`、账本）建议 CC BY 4.0；`supplement/env/tools-hash-scan.ps1` 这类脚本建议 MIT。上传为公开
仓库前请替换 `LICENSE`。

## 上传

```bash
cd github-upload
git init -b main
git add .
git commit -m "v10 preprint: Remember Rather Than Hand Off (paper + supplementary materials)"
git remote add origin git@github.com:<user>/<repo>.git
git push -u origin main
```

提交前建议过一遍：`git status --short | Measure-Object -Line`（应为 120 个左右文件、约 2.5 MB）、
`git ls-files -s | Select-String '\.pt$|\.gz$|local-8b'`（应为空）。`.gitignore` 已经挡掉本研究机上的
大目录与张量，即便在这个工作树里 `git init` 也不会误传。