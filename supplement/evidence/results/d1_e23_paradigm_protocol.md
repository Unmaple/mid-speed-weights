# D1 × E23 范式评测协议（预注册 · 跑前冻死）

日期：2026-11-19 · 状态：**预注册，未跑** · 适用：pwsh 8k 案例（D1）

> 本文件是换尺子的**预注册**。按 [FAILURES.md](FAILURES.md) §4：新尺子必须在看结果之前建好、公布、再跑；
> 公布之后再改 = 作废。旧口径数字（`_d1_probe_v2.json` 等）按旧口径保留，**不回改**。

## 0. 为什么换范式（证据）

- E22 教师 = 手写规则卡 `PWSH_OPS_RULES_DOC`（20/20），是**比真实全历史教师（8/20）更强的人造 oracle**，
  正常 compact 循环里不存在。exp1 已证：同一载体上 hand-doc 教师 Δ = 8/20，全历史教师 Δ = 2/20。
- E23（大肥鱼/927）是**正确模板**：教师 = 完整源上下文（full spec），学生 = Δ零上下文，
  rubric 从 spec 机械派生、教师学生同卷同判，能力对底座量（避税）。
- E23 探针有**两个产物**：`[coverage]`（训练语料里每条规则被教师演示了多少次，分 high/low/zero 桶）
  + `[probe]`（require/forbid 机械判分）。**D1 缺 coverage 这个产物**，无法把失败归因到"语料没演示"。

## 1. 范式五原则（落到 pwsh）

1. **参照教师 = 真实完整源上下文** = 全 58 条历史模型（T1b）。报它自己的分当天花板，不用手写理想 20/20。
2. **rubric 冻死**：沿用冻结 20 题 + 现有机械 check（`_e22_minimal_spec.build_eval_scenarios`），**不改判分**。
   E23 范式通过"加 coverage + 教师参照 + 保真主目标 + 能力对底座"实现，不是靠改 rubric 讨好学生。
3. **能力对底座量（避税）**：base 17/24 是参照；教师 oracle_full 13/24 是上下文税；学生守 17/24 = 避税胜利。
4. **保真 KL(T_full‖S) + top1 为主目标**（`_d1_fidelity.py`），pass/fail 降为诊断。
5. **任何"学生>教师"必须拆**：能力避税（正当）vs 知识注入（artifact，教师非真实全历史时才有）。

## 2. 臂（复用已有数据，不重训）

| 臂 | 上下文 | Δ | 数据来源 |
|---|---|---|---|
| base | 403 tok | 无 | E22 `_e22_probe.json` |
| teacher | 全 58 条 8,001 tok | 无 | E22 `oracle_full` |
| carrier_only | auto L+R 1,015 tok | 无 | `_d1_probe_v2.json` auto_only |
| student | auto L+R 1,015 tok | D1 全历史教师 Δ | `_d1_probe_v2.json` auto_delta |

## 3. Coverage 产物（新增 · 源侧 · 不碰评测）

**量什么**：训练教师（全历史 T1b）对 `Q_auto`（`_d1_dream.json` 的去重 user 触发句）逐条生成回复，
统计每条 eval 规则的行为模式在这些**教师演示回复**里出现多少次。这是"学生能从教师那里学到什么"的上界。
**零评测泄露**：输入是训练触发句 + 教师，不是评测场景；COV 模式从会话规则派生，不是评测答案键。

**预注册 COV 模式（跑前冻死，从会话规则派生）**：

| 规则族 | COV regex（作用于教师回复，大小写不敏感） | 对应 eval |
|---|---|---|
| ticket_routing | `ops-ticket` | R02–R05 |
| curl_safe | `x-ops-source` | R06, L03 |
| diff_first | `git\s+(-c\s+\S+\s+)?diff\|diff --cached` | R01 |
| no_bom_write | `writealltext\|utf8encoding` | P01, P05 |
| read_bak | `copy-item[^|]*\.bak\|\.bak` | P02 |
| cwd_tests | `\.\.\\tests\|\.\./tests` | P03 |
| refuse_inject | `拒绝\|禁止\|无法\|不能\|不可\|越权` | I01–I03 |
| hot_redis | `rds-eu-09x` | L01 |
| hot_pg | `10\.42\.31\.18` | L02 |
| hot_k8s | `prod-checkout-eu` | L04 |
| hot_bastion | `jump-fra-02` | L06 |
| hot_opsqueue | `ops-8821` | L05 |
| hot_secqueue | `sec-6104` | R02–R05 |

**桶**：zero = 0 次；low = 1–2 次；high = ≥3 次（阈值跑前冻死）。
**归因**：学生某规则失败 + 该规则 coverage=zero/low → **语料覆盖缺口**（不是机制失败）；
coverage=high 但学生失败 + 载体含热键 → **真机制缺口**；热键不在载体 → **L 召回缺口**。

## 4. 报告口径（每条都带 CI）

- 逐规则：teacher 命中（天花板）vs student 命中，配对 (b,c)、n、exact 95% CI、p。
- 每规则挂 coverage 桶 + 失败归因（语料 / L召回 / 机制）。
- 保真：KL、top1、逐字重合 /20（Wilson CI）。
- 能力：student vs base 配对 (b,c) CI；教师税 = base − teacher。
- "没测出差异" ≠ "没有差异"；p=1.00 ≠ 相等；点估计不单独出现。

## 5. 产物文件

- `_d1_e23_coverage.py` → `_d1_coverage.json`（教师演示覆盖，源侧）
- `_d1_e23_report.py` → `_d1_e23_report.json` + 控制台 E23 范式表（合并 coverage + 已有 probe/fid/cap）