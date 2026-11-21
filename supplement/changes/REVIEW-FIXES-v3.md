# 审查修改记录 v3（对应 `…-review.md` 的 R01–R12）

| 项 | 值 |
|---|---|
| 源 | `paper-fse-v2.tex`（822 行，冻结）→ `paper-fse-v3.tex`（853 行） |
| 产物 | `paper-fse-v3.pdf`，10 页 |
| 编译 | exit 0；0 undefined reference / missing citation；overfull ≥10pt 为 **0** |
| 本轮范围 | 审查建议的 **①②③④** 组；**⑤ 组未做**（见第 6 节） |
| 数字变化 | 只有被判定为错误的三处（方向、神经元量级、载体字节数口径）；**所有实测 KL/CI 未动** |

---

## 1. 事实错误（6 处，审查 R05 / R11 / R12 命中）

| 位置 | 改前 | 改后 | 依据 |
|---|---|---|---|
| §5.2 开头 | "the SR arm **falls** as the summary is compressed and **must cross** it" | "$\KL(T\|\St)$ **rises** as the summary is compressed---from 0.0946 at $r{=}19.8$ to 0.3286 at $r{=}309.8$"，并把必然相交改为"在相邻两个预算点上观察到符号变化" | 表 5/图 1 的实测值 |
| 图 1 图注 | "The SR curve **falls** with the compression ratio…the crossing is bracketed" | 方向删除，改为分面板描述 + 阴影带含义 | 同上 |
| §1.2 量级锚 | $8.6\times10^{11}$ neurons | $8.61\times10^{10}$ | Azevedo et al. 2009：86.1 billion |
| §3.1 记号 | $\Delta=\sum_{l=60}^{63}B_lA_l$ | $\Delta\triangleq\{\Delta_l\}_{l\in\{60,\ldots,63\}}$，$\Delta_l=B_lA_l$，$W_l'=W_l+\Delta_l$，并加一句"不同层的因子不能相加" | 各层作用于不同隐层 |
| §5.3、§6.1(1)、§1.2 | $\KL(R\|R{+}\Delta)$、$\KL(T\|R)$、against $R$ | $\KL(\armR\|\armRD)$、$\KL(T\|\armR)$、against $\armR$ | §3.1 已规定裸 $R$ 只表示 tail |
| 表 1 图注 | "This work satisfies **all three**" | 删除该句（四列却说三）；改为"The four criteria of §2.1 applied to representative systems" | 列数为 4 |

---

## 2. 过强结论（3 处，审查 R06）

| 位置 | 改前 | 改后 |
|---|---|---|
| §6.1(1) | "Seeing the history **did not make the teacher worse**" | "We did not detect a difference…the interval is compatible with a small improvement as well as with a small degradation, so this is an absence of a detected effect, not evidence that the teacher is unaffected" |
| §1.2 | "we found **no measurable** degradation" | "we did not detect a degradation" |
| §6.1(3) | "so it is **not the main bottleneck** either" | "with two ranks at one sampling condition we cannot rank it against the other unscanned axes"；并补 27.90% 与表 3 的 27.95% 的来历（同一 H3，不同拟合） |

---

## 3. 图注整改（7 个对象，按"图注只是图注"）

| 对象 | 旧图注里的论证 | 新图注 | 论证搬去 |
|---|---|---|---|
| Table 1（成本） | "Text carriers pay on the use side; Δ pays once…" | `Cost shape of four carriers.` | §3.7 首句（已含） |
| Table 2（指标） | "The three families are **not interchangeable**: 248,320 vs one token" | `The three metric families.` | §4.4 首段末句 |
| Table 3（保真） | "H2's interval crosses zero, so its gain is not claimed" | `Fidelity of Δ relative to the tail-only arm R0, on four histories.` | §5.1 首段 |
| Table 4（边际） | "Only H3 and H20-S2 above zero" + "---" 三行解释 + 跨 run 说明 | `Marginal gain of Δ on top of the summary carrier.` | §5.1 新增一段（含"两行不是同一协议的配对 run"） |
| Table 5（$r$ 阶梯） | 匕首注（复用 $S_1$ 1002 token）+ cap-64 截断说明 | `…paired whole-question intervals. †Body shorter than the cap.`（只留 legend） | §5.2 第二段（并补"未分离重生成与截断"） |
| Table 6（定位矩阵） | 合取论证 + 读法劝告 + 行不尽 | `The four criteria of §2.1 applied to representative systems from four families. ✓/× mark satisfaction only…; rows are not exhaustive.` | §2.1 末句（"What is scarce is the conjunction" 原就在此） |
| Figure 1 | 方向 + 交叉区间 | 分面板 + 图例对应 + 阴影带含义（$\S$\ref{sec:crossover}） | §5.2 |

**新写进正文的（非新主张，均为搬迁）**：§5.1 一段（表 4 的限定）、§5.2 两段（扫掠的两个性质 + 256-token 点的聚类敏感性）。

---

## 4. 定位大表：§2.1 → §7（Related Work 导语之后）

- 采信审查 R12 的核心点：**表格每一格都是对别人系统的断言，证据在 §7**；放在 Preliminaries 等于先打分后给依据。
- 判据（A/B/C/A′）留在 §2.1，只在末尾加一句：`Table~\ref{tab:matrix} in \S\ref{sec:related} applies the four criteria to representative systems from four families; those judgments are argued in the subsections there, not in the table.`
- 表号随之变为 **Table 6**（其余表前移一位：成本 1、指标 2、保真 3、边际 4、$r$ 阶梯 5）。所有引用均为 `\ref`，无硬编码。

---

## 5. 载体尺寸与版本号（审查 R02、R08 的一部分）

用你们自己的训练清单核对：`experiments/compact_delta/engineering-gate-v1/train.json` 里 `n_params = 5767168`，与 $4\times64\times(5120+17408)$ 完全一致。据此：

| 量 | 值 | 出现处 |
|---|---|---|
| 参数量（4 层 × rank 64 × down_proj） | 5,767,168 | §3.1、§3.3、§1.4 |
| 单份尺寸 | **11 MiB（BF16）/ 22 MiB（FP32）** | 同上，三处统一 |
| 三层投影设计预算 | **33 MiB（BF16）/ 66 MiB（FP32）**，17,301,504 参数 | §1.4 |
| 旧的 42 MB | **删除**（既不是 BF16 也不是 FP32 的值） | 原 §1.2、§1.4 |
| 基座 revision | `1d4bf0f2ff6012fd82039f2fa52739d0dd7c60c0`（§4.7 用短号，Data Availability 给全号） | §4.7、Data Availability |

---

## 6. 未做（第 ⑤ 组，等验收后再看）

| 审查编号 | 事项 | 为什么留 |
|---|---|---|
| R01 | 成本量词（per carried token vs per episode）与"只付一次"的范围 | 只需半句，但会改动摘要与 §3.7 的措辞，和 R10 一起做更省事 |
| R03 | Doc-to-LoRA 的概括（对方 eval 是否移除上下文） | 需先核实原文；改法是软化，不主张其评估协议 |
| R04 | "固定容量"推出"保真"的越界 | 用 `实验结论.md:270` 的原话加一句限定即可 |
| R07 | $\rho$ 无定义、12 个 core CE 无表 | 要么补定义与小表，要么删具体数值 |
| R09 | 摘要预算是重新生成还是截断 | 需先在实验记录里确认 |
| R10 | §5.3 "Cost" 改名（实为分布漂移） | 与 R01 一起改 |
| — | 图 1 重绘（见 §7） | 需改绘图脚本 |

---

## 7. 一处仍需重绘：图 1 的图内文字

图注已改对，但 **PNG 内部还留着三处旧文字**（`figures/fig1-rstar.png`）：

1. 图例 `R: no summary / no adapter` → 应为 `R0`
2. 图内注 `256-token call-cluster CI crosses zero; see report for sensitivity` → "the report" 不存在；正文 §5.2 已承担这句
3. 图内注 `Original 1002 token summary reused.` → 属于论证，按同一原则应在正文（§5.2 已写）

重绘需要找到 `experiments/compact_delta/minimal-set-20261026/` 下的绘图脚本；本版先不动，改完正文后单独处理。

---

## 8. 验收清单（6 条，可逐条勾）

- [ ] §5.2 开头写 "rises"，并给出 0.0946 → 0.3286 两个端值；不再出现 "must cross"
- [ ] 图注不再解释方向，只描述面板与阴影带
- [ ] §1.2 的神经元是 $8.61\times10^{10}$
- [ ] $\Delta$ 在 §3.1 是集合；全文 KL 只出现 $\armR$/$\armRD$，没有裸 $R$
- [ ] 六张表的图注都只剩"是什么"；论证在 §3.7 / §4.4 / §5.1 / §5.2 / §2.1
- [ ] 11 / 22 / 33 MiB 三处一致，42 MB 已消失；revision hash 在正文与 Data Availability 各一处