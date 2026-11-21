# 重构说明 v2（相对 v1）

| 项 | v1 | v2 |
|---|---|---|
| 源文件 | `paper-fse-v1.tex`（751 行，冻结为存档） | `paper-fse-v2.tex`（822 行） |
| 产物 | `paper-fse-v1.pdf`（9 页） | `paper-fse-v2.pdf`（10 页） |
| 编译 | exit 0 | exit 0；0 undefined；overfull ≥10pt 为 0 |
| 方法起始页 | **p6** | **p4** |
| 构建脚本 | — | `tools/build_v2.py`（块级搬移 + 清单，可重跑） |

**性质**：块级搬移（90 个块 + 索引清单），正文段落逐字未动。全部改写集中在 §4 处，见第 4 节。

---

## 1. 新旧骨架对照

| 新 | 旧 | 说明 |
|---|---|---|
| 1 Introduction | §1（1.1–1.4 保留原编号内容） | 1.3 两种权重留在 Intro 作"思想段" |
| 2 Background and Preliminaries | 新增节头 | 2.1 判据（原 §2.1）、2.2 与后训练关系（原 §1.5）、2.3 监督来源（原 §2.6）、2.4 量级锚（原 §2.7） |
| 3 Approach | 原 §3 + §4 合并 | 3.1 记号+不变量、3.2 写点、3.3 载体、3.4 目标、3.5 $r$、3.6 生命周期、3.7 成本 |
| 4 Experimental Design | 原 §5 | 4.1 RQ（新）、4.2 histories、4.3 arms（原 §3.1 的臂表）、4.4 指标、4.5 不确定性与数值路径、4.6 决策规则、4.7 实现细节（原 Reproducibility 前半） |
| 5 Results | 原 §6 | 5.1/5.2/5.3 挂 RQ1–RQ3 |
| 6 Discussion | 原 §7.1 + §8 | 6.1 三解释被否、6.2 未经检验的含义、6.3 Limitations（新） |
| 7 Related Work | 原 §2.2–2.5 | 后移；判据与矩阵表已上移 §2.1 |
| 8 Threats to Validity | 原 §7.2 + §8 部分 | 独立成节，construct/internal/external |
| 9 Conclusion | — | 新 |
| * Data Availability | 原 Reproducibility 后半 | 无编号，文末 |

**表号**：ABC 矩阵回到 Table 1，其后依次为成本 2、指标 3、保真 4、边际 5、$r$ 阶梯 6（与 v1 编号一致）。

---

## 2. 判定标准（本次采用）

- **Threats to Validity** = 花更多时间/资源可以消掉或收窄的（工作不足）
- **Limitations** = 方法本身做不到的（加资源也消不掉）

---

## 3. 搬移清单（按新节）

| 新位置 | 来源（v1 行） | 内容 |
|---|---|---|
| 1 Prologue / 1.1 / 1.2 / 1.3 / 1.4 | 88–98 / 105–149 / 150–196 / 197–207 / 208–232 | 原样 |
| 2.1 The Four Criteria | 276–324 | 原 §2.1，含 Table 1（`table*`） |
| 2.2 Relation to Post-Training | 239–268 | 原 §1.5 |
| 2.3 Supervision | 384–391 | 原 §2.6 |
| 2.4 Scale Anchors | 393–399 | 原 §2.7 |
| 3.1 Notation | 403–407、417–423 | 记号 + $R$ 消歧 + $\Delta$ 挂载 |
| 3.2–3.6 | 481–485 / 487–491 / 493–512 / 426–432 / 514–516 | 写点、载体、目标、$r$、生命周期 |
| 3.7 Cost Model | 445–477 | 原 §3.4，含 Table 2 |
| 4.2 Histories | 520–529 | 原 §5.1 |
| 4.4 Metrics | 531–551 + 553–557 | 原 §5.2 + §5.3（后者降为 `\paragraph`） |
| 4.5 Uncertainty & Numerical | 559–565 + 567–571 | 原 §5.4 + §5.5（均降为 `\paragraph`） |
| 4.6 Decision Rules | 573–581 | 原 §5.6 |
| 4.7 Implementation | 736–738 | 原 Reproducibility 前半 |
| 5.1–5.3 | 585–630 / 632–677 / 679–683 | 原 §6.1–6.3 |
| 6.1 | 687–702 | 原 §7.1 |
| 6.2 | 727–734 | 原 §8 的 speculative implication |
| 7.1–7.4 | 270–274 / 326–343 / 345–356 / 358–373 / 375–382 | 原 §2.2–2.5 |
| Data Availability | （原 739–741 改写） | artifact 声明 |

---

## 4. 新写的文字（逐条，全部标依据）

| # | 位置 | 新写内容 | 依据 |
|---|---|---|---|
| N1 | 3.1 | "The five arms compared in this paper are defined in §4.3; here we fix only the notation." | 臂表已搬走，需前向引用 |
| N2 | 4.1 | 三条 RQ + "The three questions map one-to-one onto §5." | 由 §1.4 三条贡献换句式，无新主张 |
| N3 | 4.3 | 首句 + 五个 arm 的散文版 | 原 `align*` 块逐项改写为行文，六项描述词一字未改 |
| N4 | 6.3 | Limitations 七条 | L1–L3 由原 §1.4 免责清单 (i)(ii)(iii) + 原 §7.2/§8 搬来改写；L4 用 Table 4/5 的 0.0946 与 0.2553；L5 依据原 §4.1/§4.3；L6 依据原 §4.3 + §2.2 的超网络；L7 由原 §4.4 生命周期 + §8 累积段 |
| N5 | 8 | Threats 四段（construct / internal / external） | C1、I1–I3、E1 由原 §7.2 四段拆分合并；**新增两句**：度量指向未拆分（依据 §4.2 的值条目 vs 表面词项）、不变量未做失效臂（依据 §3.1 的 I1–I3 与 Data Availability 的 SHA） |
| N6 | 9 | Conclusion | 全部数字取自 Table 4/5/6 与 §5.3，无新数 |
| N7 | Data Availability | artifact 声明 | 原 Reproducibility 后半 |

---

## 5. 格式改动（内容不变，供逐条核对）

1. `align*` 臂表 → 行文（v1 `409–415` 的 7 行 → N3）；五个 arm 的表达式与描述词全部保留。
2. 原 §5.3/5.4/5.5 三个子节 → `\paragraph{Position sets and weighting.}` / `{Uncertainty.}` / `{Numerical path.}`，正文原样。
3. 6.2 段首的 `\emph{A speculative implication (not tested).}` 删除（与节标题重复）。
4. 交叉引用重编号：`(\S7.1)` → `(\S6.1)`；`(\S1.5)` → `(\S2.2)`。
5. 新增 label：`sec:criteria`、`sec:histories`、`sec:arms`、`sec:cost`；`sec:protocol` 移到 §4、`sec:related` 移到 §7。

---

## 6. 未变的东西（可机械核对）

- 所有 KL 数值、CI、$r^\ast\in[77.5,154.9]$、drift 0.025874 / 0.016631 / 0.015966、0.0946、0.2553、18.14\%、6.82\%：**逐字未动**
- 46 条文献、5 个臂、6 张表 + 1 图：数量未变
- 未新增实验、未新增数据、未改标题、未改摘要
- v1 文件未被修改（仍是 9 页版本）

---

## 7. 复核建议顺序

1. 打开 v2 目录页（p1）确认摘要与 v1 逐字一致
2. 比对 `6.3 Limitations` 与 v1 §1.4 免责清单：是否有内容被扩大或缩小
3. 比对 `8 Threats to Validity` 与 v1 §7.2：四条是否等价拆分
4. 检查 `3.1` 与 `4.3` 之间：臂是否都在 4.3 定义、3.1 是否只保留记号
5. 检查 Table 1（矩阵）是否仍能支撑 §1.3 的论断（现在相距 2 页，而非 7 页）