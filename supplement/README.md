# supplement/ — 辅助材料索引

**正式版本是经老师审核的 [v10 PDF](../paper/paper-AVCP-v10.pdf)（13 页，2026-10-26 冻结）。** 本目录是辅助材料：
研究账本、实验说明、旧版审阅、变更记录和 v10 之后的续作。**若这里的表述、数据或结论与 v10 PDF 有冲突，以 v10 PDF 为准**；
本目录里的旧稿与续作保留原文，只加标注，不改数字。

本目录回答两个问题：**这句话的数字从哪来**、**为什么最后写成这样**。
根目录的 [README](../README.md) 是论文入口；本目录各层材料按下面的"类型"列区分，从任何一个入口进来都应先看清自己读的是哪一类。

## 先读哪份

| 目的 | 打开 | 类型 |
|---|---|---|
| 只想看"论文里那些数" | `evidence/实验结论.md` | 运行账本（现行） |
| 想看 $r^\ast$、重放、9B 复现 | `evidence/r-star及后续实验阶段报告-2026-10-26.md` | 运行账本（现行） |
| 想一次读完核心文档 | `CORE-DOCS-2026-10-27.html`（六份合订，浏览器直接打开） | 续作快照（v10 之后） |
| 想知道某个实验的完整读数 | `evidence/results/`，入口是 `evidence/results/README.md` | 逐实验读数（多为 v10 之后） |
| 想知道作者为什么改了某句话 | `changes/V4-CHANGES.md` … `V10-CHANGES.md` | 变更记录（现行） |
| 想看审稿意见与回应 | `reviews/` | 旧稿（对 v1–v7，非 v10） |

**一条硬规则**（记在 `changes/V10-CHANGES.md` 末尾）：判断"这个实验存不存在"，先查两份 run ledger，
再去翻 `.local-8b/*.json`。v10 的 11 条候选缺陷里有 3 条是因为顺序反了而误判的。

---

## evidence/ — 证据层

| 文件 | 体量 | 性质 |
|---|---|---|
| `实验结论.md` | 92 KB | **运行账本 1（现行）**。2026-10-25 起集中维护的当日实验结果与可支持的判断。PDF 表 4/表 5 的相对值、表 8 的漂移点估计（0.02587 对 0.01663/0.01597）、载体规模 5,767,168 参数都记在这里；125 MB 与 333× 中的 125 MB 出自 PDF 文献 [22]，不在本文件 |
| `r-star及后续实验阶段报告-2026-10-26.md` | 32 KB | **运行账本 2（现行）**。H20 上首次定位摘要/Δ 次序反转区间，以及其后的重放、三历史摘要扫描、共享前缀工程、Doc-to-LoRA 与 GDN 核查。附录 A 的训练量口径（训练措辞 0.32→1.000、40 题 0.220→0.497）见 §6.1，0.928 读出见 §6.3；**173 s / 224 s 不在本文件**，计时见 `changes/V4-CHANGES.md`，口径见 `changes/V10-CHANGES.md` 的 A10 |
| `阶段总结-2026-10-25-暂停.md` | 11 KB | 暂停与关机交接：什么跑完了、什么没跑、末态是什么 |
| `研究理由报告-MidSpeedWeights.md` | 91 KB | 研究动机与完整依据。§11 是 17:38 前的预实验，§12 是其后的新增证据 |
| `研究理由报告-简版.md` | 11 KB | 一页版动机（"Agent 的记忆只有两个时标"） |
| `研究理由报告-修订记录.md` | 4 KB | 主报告的修订过程与自我更正，从主报告移出 |
| `待验证假设与实验设计.md` | 46 KB | HYP 台账：每条假设的判据、跑没跑、结论。§4 的 arms（T/R0/SR/RD/SRD）与不变原则在这里 |
| `results/` | 58 份 / 691 KB | 逐实验读数（`e6_…`、`r-ladder`、`rd_fits_h`、`compute-account`、`FAILURES.md` 等），
 `results/README.md` 是索引 |

**时间边界**：`results/` 覆盖 2026-10-25 → 2026-11-21。只有 10-27 之前的部分进了 v10；10-28 之后
（`ROUND-2026-11-*`、`e21`、`e22`、`e23`、`HANDOFF-*` 等）属于 v10 之后的续作，保留是因为它们是同一份
读数索引的一部分，不是因为论文引用了它们。

## companion-docs/ — 合订本与它收录的原文

`CORE-DOCS-2026-10-27.html` 把下面六份平铺成一个离线可读的单文件（"核心文档合订本"，2026-10-27 23:24）：

| 文件 | 角色 |
|---|---|
| `SLEEP-REPLAY-v1.md` | 记要 v1（母文档）：三条撤回、两条候选律、E0–E5 的由来 |
| `EXPERIMENTS-SLEEP-REPLAY-v1.md` | 协议 v1：E0–E5 的臂、预算、预注册判据、红线、跑序 |
| `BIOMIMETIC-REGISTER-v1.md` | 仿生对照表（活文档） |
| `CLAIMS-OFFENSIVE-v1.md` | 进攻性主张清单：每条标明现在能否写 |
| `STYLE-METRICS-v1.md` | 文风量化的方法提案 |
| `TOPIC-HOW-LLM-DREAMS-v1.md` | 短选题文档 |

另收 10 份被上述协议引用的规格与备忘：

- E 规格：`E0b-POSKL-v1.md`、`E6-EXTERNAL-NULL-v1.md`、`E8-CONTEXT-INVARIANCE-v1.md`、
  `E9-E10-DECAY-TARGET-v1.md`、`E11-COVERAGE-SHARPNESS-v1.md`、`E13-SAMPLED-REPLAY-v1.md`、
  `E14-KL-SELECTED-TEACHING-v1.md`
- 设计备忘：`DELTA-ENVELOPE-v1.md`、`DESIGN-AGENTIC-REPLAY-v1.md`、`DESIGN-SKILL-DISTILL-v1.md`

> **这些不是 v10 的证据。** 它们写于 v10 冻结之后，`SLEEP-REPLAY-v1.md` 自己写明"不是论文文本，v10 已冻结，
> 本文档不触发任何修改"。放在这里是因为合订本收录了它们，而且它们标出了 v10 的边界在哪（例如"重放的梯度
> 成本不是 $O(|H|)$"这条不能写进 v10）。

## reviews/ — 审查与核查

| 文件 | 说明 |
|---|---|
| `Remember Rather Than Hand Off …-review.md` | 对 v1 PDF（9 页）的外部预印本审查，R01–R12 |
| `paper-fse-v4-preprint-review-20261026.md` | v4 快照的证据审查（R01–R11 的来源） |
| `paper-fse-v4-preprint-diff-review-20261026.md` | 对 v4 更新差异的复审 |
| `paper-fse-v5-preprint-review-20261026.md` | v5 修复复核与回归审查（V01–V05） |
| `paper-fse-v7-preprint-review-20261026.md` | v7 审查：结论与证据的对应关系（B/C 编辑项与两处算术） |
| `SELFCHECK-r1.md` | 三级降级自查（学位论文 → 期刊 → 抢发预印本），52+49 条清单的适用性转换 |
| `ABC-MATRIX-v1.md` | 相关工作定位表 A/B/C 七格的只读核查 |
| `REMORY-LCLM-LCC-v1.md` | 三条判据（REMORY / LCLM / LCC）的核查 |
| `LOCAL-RESULTS-ADOPTION-v1.md` | 本机 9B 结果是否/如何进入论文的只读评估（v10 附录 A 的由来） |
| `references-verification.md` | 35 条 BibTeX 的逐条核实表 |
| `REFS-FILL-v1.md` | 8 条 arXiv 占位补全与 CCM / per-fact 身份定案（46 条的来源） |

## changes/ — 逐版可审计

| 文件 | 说明 |
|---|---|
| `V4-CHANGES.md` … `V10-CHANGES.md` | 每一版相对上一版改了什么、依据是哪份文档的哪一行 |
| `RESTRUCTURE-v2.md` | v1 → v2 的结构重写说明 |
| `REVIEW-FIXES-v3.md` | 对应外部审查 R01–R12 的修改记录（v3） |
| `FIX-SPEC-r1.md` | 给外部复核者的逐条验收说明（无项目上下文也能读） |

`V10-CHANGES.md` 值得一提：它记录 11 条候选缺陷如何被压到 5 条，以及被撤回的 3 条**是审查者自己的错**，
不是论文的错——包括那条"该先查 run ledger"的流程教训。

## env/ — 环境

| 文件 | 说明 |
|---|---|
| `ENV-PIN.md` | PRO6000WN 的环境与容灾清单，重建环境/迁移服务器的唯一依据 |
| `PRO6000WN_readonly_audit.md` | 服务器只读核验报告（未打印任何凭证） |
| `tools-hash-scan.ps1` | 哈希扫描脚本（论文里 SHA-256 由它产生） |

---

## 已知的空指针

这些文档里的相对链接指向研究机上的 `.local-8b/`、`experiments/`、`tools/`，本仓库不包含它们（体量与理由见
根 README 的"未上传的内容"）。所以：

- `实验结论.md`、`results/*.md` 里的 `m31_rd_2304.pt`、`.local-8b/m53_carrier_cost.py` 一类路径**在仓库里点不开**，
  它们是"这些数字来自哪次运行"的记号，不是可下载资产；
- 论文 Data Availability 承诺的逐表 manifest 与原始张量同样不在这里。
- 需要真正可复现的 artifact 时，应单独发布一包 `manifests/`（输入文件、张量校验和、基座 commit
  `1d4bf0f2ff6012fd82039f2fa52739d0dd7c60c0`），而不是把 93 GB 塞进 git。