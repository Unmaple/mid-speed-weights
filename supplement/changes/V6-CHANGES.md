# v6 说明（v5 → v6，只改 V01–V05）

| 文件 | 身份 | .tex SHA-256 |
|---|---|---|
| `paper-fse-v4.tex` | 被 R01–R11 审过的版本，与 review 快照逐字节相同 | `475e0933…` |
| `paper-fse-v5.tex` | v4 + R01–R11；已被 V01–V05 审过 | `2D6CD97E…` |
| `paper-fse-v6.tex` | **v5 + V01–V05**，本版 | `28DB2305…` |

13 页、exit 0、0 undefined、overfull ≥10pt 为 0。

---

## V01 9B 的 KL 方向：配错了端点（真错）

`m30_acc5.json`（40 题值位评估）：

| arm | 值位 top-1 | KL(T‖RD) |
|---|---:|---:|
| rd_144（4 遍） | 0.2200 | 0.7230 |
| rd_576（16 遍） | 0.2883 | 0.7661 |
| rd_2304（64 遍） | 0.4967 | 0.7508 |

**16→64：两者都改善**（top-1 升、KL 0.7661→0.7508 降）。**只有 4→64 分离**（KL 0.7230→0.7508 变差）。
v5 的表 9 与 §6.2 把 `0.29→0.50`（16→64）与 "KL moves the other way" 配成同一比较，与数据矛盾。

改法：
- 表 9 行改为 `top-1 0.220→0.497 and KL 0.7230→0.7508, 4 to 64 passes`
- §6.2 明写两对：4→64 分离、16→64 同向；并注明这是 **40 题值位评估**，不是训练集准确率

## V02 覆盖结论在 Limitations / Future Work 被说满（越界）

§6.2 已收窄（干预同时改变训练分布与更新数），但 L1、L5、§6.5 仍残留排他表述。统一改为：

> The companion shows sensitivity to training exposure and to entity–answer-format coverage; the intervention
> changes both probe composition and update count, so it does not isolate their effects. At 27B we measured
> distributional fidelity, not independent table reconstruction or factual accuracy.

删除：`set by coverage rather than by the objective`、`at the coverage of this paper it does not reproduce the
table / at full coverage it does`、`a probe set is not a sample … but a choice of what the carrier will be able to
answer`、`only inside cells that were supervised`。

## V03 注意力成本的量纲（真错，R05 那轮引入）

v5 写"一个携带 token 在每个位置花 O(L)"——把"整段扫描 O(L)"又乘了位置数。正确分解：

- k 个携带 token：每个解码位置 +O(k)，m 个位置合计 **O(km)**
- **单个**携带 token 对单个位置：**O(1)**

同时撤回无条件的"一条上升曲线 vs 一条水平线"：固定 k 的文本载体同样不随 |H| 增长，那条论证依赖"保真不变时
k 必须随 H 增长"，而我们没测。

落在四处：摘要、§1.4 贡献 (1)(2)、§3.5 的 quote、§7.5。

## V04 "只有 H1" 与自己的表 7 冲突（真错）

表 7 里 H20 的 128 点 `[+0.0137,+0.1037]`、256 点 `[−0.0897,−0.0010]` **都不含零**；只有 256 点在**调用簇**
重采样下跨零。改为分别说明两种口径（H1 两端口径都排除零；H20 问题级排除、256 点对簇敏感；H2/H3 不确定）。

## V05 0.969 不是"同一 adapter"（真错）

0.9688 来自 `m34`（adapter `m31_rd_2304`）；0.3125 来自 `m37`（3,584 步）；0.84375 来自 `m38`（5,120 步）。
改为"一次独立的 2,304 更新运行"，并删掉"wording generalises and format does not"这一由单次测试推出的二元性质。

---

## 未动

§9 结论的措辞已在 v5 中按上一轮指令修正（`what repeats is the reversal` 已不存在），v6 未再改。
其余章节、表号、label、参考文献全部未动。