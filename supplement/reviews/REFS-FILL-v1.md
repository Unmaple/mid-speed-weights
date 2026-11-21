# REFS-FILL-v1 — 8 条 arXiv 占位补全 + CCM / Per-fact 身份定案

核实日期：**2026-10-26**。产物：`references.bib`（46 条 = 正文 44 个 `\cite` 键 + 2 条待入表条目
`ccm` / `perfact`），本文件为逐条依据。**未改动** `paper-fse-v1.tex` / `paper-fse-v1.pdf` / `figures/` /
`experiments/` / `.local-8b/` / `ABC-MATRIX-v1.md` / `REMORY-LCLM-LCC-v1.md` /
`LOCAL-RESULTS-ADOPTION-v1.md` / `SELFCHECK-r1.md`。

取数手段（全部现场取数，无一条凭记忆填）：

- arXiv Atom API：`https://export.arxiv.org/api/query?id_list=<ids>&max_results=20`（9 + 5 个 id，逐一返回 `<title>` /
  `<author><name>` / `<published>` / `<arxiv:primary_category>` / `<arxiv:comment>` / `<summary>`）；
- arXiv abs 页 `https://arxiv.org/abs/<id>`（核对 `<h1 class="title">` / `<div class="authors">` / `<td class="tablecomments">`）；
- DataCite REST `https://api.datacite.org/dois/10.5281/zenodo.18778766` + Zenodo API
  `https://zenodo.org/api/records/18778766` + DOI handle API。

## 0. 一句话结论

| 问题 | 结论 |
|------|------|
| 8 条占位 | **8/8 查到**，标题/作者全部对上名字，**0 条编号存疑**；`title unverified` 与 `Anonymous` 已全部清除 |
| arXiv **2312.03414** | **不是 CCM**。它是 *Compressed Context Memory*（ICLR 2024，Kim et al.），KV 压缩，不是"把历史读回 context" |
| **CCM** 身份 | **已定案：arXiv 2609.35540 *Continuous Context Management***，摘要里直接写 "(CCM)"。**可引用**，但**绝不能挂 2312.03414** |
| Zenodo `10.5281/zenodo.18778766` | **DOI 存在且可解析**。记录标题 = *Sleeping LLM: Two-Phase Memory Consolidation…*（Baranov, 2026），**非同行评审** |
| 它与 *Language Models Need Sleep* | **两个不同工作**（作者、机构、机制全不同，两条记录互不 related） |

---

## 1. 逐条核实表（8 条占位）

"偏离名字"= 记录标题是否与该键名/正文短名所指的系统不同。**8 条全部不偏离**——命中的论文要么标题首词就是该短名，
要么摘要里作者自命名（`statelm2026` 属后者：标题里没有 "StateLM"，摘要里有）。

| 键名 | arXiv | 查到? | 新标题（记录原文） | 作者（记录原文 → bib 写法） | 偏离名字? | 依据（字段原句） |
|------|-------|-------|--------------------|------------------------------|-----------|------------------|
| `ascent2026` | 2610.05303 | ✅ | **ASCENT: Online Test-Time Training of Long-Horizon Agents via Self-Distillation of Verified Experience** | Haodong Lu, Dong Gong（2 人，**全列，不写 et al.**） → `Lu, H. and Gong, D.` | 否（ASCENT = 标题首词） | `<title>` 如上；`<published>2026-10-04T15:27:20Z`；`<arxiv:primary_category term="cs.LG"/>`；`<arxiv:comment>Preprint</arxiv:comment>` |
| `lclm2026` | 2606.09659 | ✅ | **End-to-End Context Compression at Scale** | Ang Li, Sean McLeish, Haozhe Chen, …（**共 15 人**） → `Li, A. and McLeish, S. and Chen, H. and others` | 否——摘要自命名：*"We introduce Latent Context Language Models (LCLMs), a family of compressors that improve the Pareto frontier…"* | `<author><name>Ang Li</name></author><author><name>Sean McLeish</name></author><author><name>Haozhe Chen</name></author>…`（15 条 `<author>`）；`<published>2026-06-08T15:43:16Z`；`cs.CL` |
| `sleep2026` | 2606.03979 | ✅ | **Language Models Need Sleep: Learning to Self-Modify and Consolidate Memories** | Ali Behrouz, Farnoosh Hashemi, Adel Javanmard, Vahab Mirrokni（4 人） → `Behrouz, A. and Hashemi, F. and Javanmard, A. and others` | 否（占位标题是它的前半句，已补全） | `<title>Language Models Need Sleep: Learning to Self-Modify and Consolidate Memories</title>`；`<published>2026-06-02T17:56:55Z`；`<arxiv:comment>A version of this work has been publicly available from September 2025 on OpenReview</arxiv:comment>`；`cs.LG` |
| `sempic2026` | 2607.28069 | ✅ | **SemPIC: Learning Semantic Position-Independent KV Caches** | Hui Xie, Peng Xiao, Yutong Deng, …（6 人） → `Xie, H. and Xiao, P. and Deng, Y. and others` | 否（摘要：*"We present SemPIC, which trains a LoRA-enabled Writer to compile native per-layer document KVs through behavioral distillation…"*） | `<title>SemPIC: Learning Semantic Position-Independent KV Caches</title>`；`<published>2026-07-30T11:45:24Z`；`cs.AI` |
| `xkv2025` | 2503.18893 | ✅ | **xKV: Cross-Layer KV-Cache Compression via Aligned Singular Vector Extraction** | Chi-Chih Chang, Wei-Cheng Lin, Chien-Yu Lin, …（11 人） → `Chang, C.-C. and Lin, W.-C. and Lin, C.-Y. and others` | 否（摘要：*"we propose xKV, a post-training compression method that jointly factorizes grouped-layer KV-Cache…"*） | `<title>xKV: Cross-Layer KV-Cache Compression via Aligned Singular Vector Extraction</title>`；`<published>2025-03-24T17:06:37Z`；`cs.CL`；`<arxiv:comment>ICML 2026</arxiv:comment>` |
| `statelm2026` | 2602.12108 | ✅ | **The Pensieve Paradigm: Stateful Language Models Mastering Their Own Context** | Xiaoyuan Liu, Tian Liang, Dongyang Ma, …（7 人） → `Liu, X. and Liang, T. and Ma, D. and others` | 否，但**标题里没有 "StateLM"**（与 LOHA/TMEM 同类：短名来自摘要）——摘要：*"We introduce StateLM, a new class of foundation models endowed with an internal reasoning loop to manage their own state."* **同一篇**，不是编号错 | `<title>The Pensieve Paradigm: Stateful Language Models Mastering Their Own Context</title>`；`<published>2026-02-12T16:00:01Z`；`cs.AI` |
| `rlm2025` | 2512.24601 | ✅ | **Recursive Language Models** | Alex L. Zhang, Tim Kraska, Omar Khattab（**正好 3 人，全列**） → `Zhang, A. L. and Kraska, T. and Khattab, O.` | 否（摘要：*"We propose Recursive Language Models (RLMs), a general inference paradigm that treats long prompts as part of an external environment…"*） | `<title>Recursive Language Models</title>`；`<published>2025-12-31T03:43:41Z`；`<arxiv:comment>9 pages, 43 with Appendix</arxiv:comment>`；`cs.AI` |
| `docatlas2026` | 2608.07527 | ✅ | **DocAtlas: Long-Document Understanding as Mutable-State Interaction** | Hongchen Wei, Yuanzhe Wang, Bei Liu, …（11 人） → `Wei, H. and Wang, Y. and Liu, B. and others` | 否（摘要：*"We present DocAtlas, a system that treats long-document understanding as a mutable-state information-seeking process."*） | `<title>DocAtlas: Long-Document Understanding as Mutable-State Interaction</title>`；`<published>2026-07-21T09:45:34Z`；`cs.CL` |

### 1.1 三条口径说明（**不是**偏离，但会被误读成偏离）

1. **`year` 取 arXiv v1 投稿年，不取会议年。** 所以 `xkv2025` 的 year 仍是 **2025**（v1 = 2025-03-24），尽管
   `<arxiv:comment>` 写 *ICML 2026*。键名也是 2025，不改。若正文要写 "ICML 2026"，那是 venue 不是 year。
2. **`sleep2026` 的 year = 2026**（v1 = 2026-06-02），**不是 2025**，虽然 comment 说该工作自 2025-09 就在 OpenReview 上。
3. **作者数 ≤ 3 的全列**（`ascent2026` 2 人、`rlm2025` 3 人）；`lclm2026` 15 人、`docatlas2026` 11 人、`xkv2025` 11 人、
   `statelm2026` 7 人、`sempic2026` 6 人、`sleep2026` 4 人 → 前 3 + `and others`。

### 1.2 本轮**没有**"编号存疑"条目

上几轮 LOHA / TMEM 的教训是"标题对不上"和"标题对上了但短名不在记录里"要分开判。本轮 8 条的判据是
**标题 / 摘要任一处出现该短名**：`ASCENT`、`LCLM`、`SemPIC`、`xKV`、`StateLM`、`RLM`、`DocAtlas` 全部在摘要自命名处命中，
`sleep2026` 命中标题前半句。没有一条需要"保留占位"。

---

## 2. CCM：arXiv **2312.03414** 不是 CCM；CCM = **2609.35540**

### 2.1 2312.03414 到底是什么

| 字段 | 记录值 |
|------|--------|
| 标题 | **Compressed Context Memory For Online Language Model Interaction** |
| 作者 | Jang-Hyun Kim, Junyoung Yeom, Sangdoo Yun, Hyun Oh Song（4 人，SNU） |
| 年份 / 版本 | v1 2023-12-06，v2 2024；`<arxiv:comment>` = **ICLR 2024** |
| 分类 | cs.LG (primary), cs.CL |
| 键名 "CCM" 在记录中 | **不出现**。摘要自命名的是 *"a compressed context memory system"* |

摘要原句（判定机制的证据）：

> "This paper presents a context key/value compression method for Transformer language models in online scenarios …
> we propose a compressed context memory system that continually compresses the accumulating attention key/value pairs
> into a compact memory space … Our compression process involves integrating a lightweight conditional LoRA into the
> language model's forward pass during inference, without the need for fine-tuning the model's entire set of weights."

### 2.2 它是不是"把历史读回 context"的记忆系统？——**不是**

- **机制**：把不断增长的 attention KV 对**在线压进一块紧凑内存**。没有 retrieval、没有把摘要文本重新塞回 prompt、
  没有工具调用。它属于 **compact-KV 那一类**（`Still`/`RestoreKV`/`Cartridges`/`SemPIC`/`xKV` 的邻居），不属于
  `RLM`/`StateLM`/`DocAtlas` 那一类。
- **判据 (B) 载体**：×。内存是**压缩后的 KV**，不是参数。conditional LoRA 只在压缩前向里参与计算，
  并不等于"记忆驻留在参数里"——论文 §2.1 已经预判了这个偷换（"That training touched the parameters does not
  by itself satisfy (B)"）。
- **判据 (A) 写点**：×。在线持续压缩，**没有"历史被销毁的那一刻"**这个边界事件，也无生命周期。
- **(C)**：摘要未提蒸馏，压缩目标是重建/语言建模，按本文口径不算 ✓。

⇒ `(A)× (B)× (C)×`，且**机制上与原表被删那一行（"× / × read back into context / spatial"）不是同一件事**。
原行把它和 `RLM / StateLM / DocAtlas` 并列，就是拿一个 KV 压缩方法去代表"模型读回自己的 context"，
即便编号给它也对不上机制。**这就是那条 CCM 当时删得对的原因之一。**

### 2.3 但 CCM 的身份**已经定案**——是 2609.35540，不是"不明"

`ABC-MATRIX-v1.md`（L127 一处、L270–275 一处）提到过另一个 CCM 候选 `2609.35540`。我直接向 arXiv 核实了它：

| 字段 | 记录值 |
|------|--------|
| 标题 | **Continuous Context Management** |
| 作者 | William Hoy, Jingxuan Fan, Nurcin Celik, Xu Pan（4 人） |
| 年份 / 分类 | 2026-09-28，v1；cs.AI |

摘要原句（**记录自己给出 "CCM" 这个缩写**，这是本次定案的判据）：

> "We study **Continuous Context Management (CCM)**, which performs compaction at every turn to prevent interaction
> history from accumulating in the active prompt. At each turn, a CCM agent emits an updated memory together with an
> environment action; its next prompt contains the original task, retained memory, and newest observation rather than
> the complete transcript."

⇒ 这就是被删那行要的 CCM：**每轮压缩、把 memory 文本读回 context**（(B)＝×，记忆仍是 context 里的文本），
和 `RLM / StateLM / DocAtlas` 同族。**已作为 `@misc{ccm}` 写进 `references.bib`。**

### 2.4 CCM 结论

**可引用**，但两个动作必须同时做：

1. **引用用 2609.35540**，不要用 2312.03414。`2312.03414` 若出现在表里，就是又一次 LOHA/TMEM 式误判
   （标题里有个 "context memory" 就被认成 CCM）。
2. 若恢复该行，**三格都要重打**，不能沿用被删行的 `× / × / ---`：
   - **(A)** 建议 **✓**：摘要明说 "performs compaction at every turn … prevents history from accumulating"，
     写入点就是历史被丢弃的那一刻——这与本表引擎行（`A = ✓`，"an observation changes from text to soft tokens
     when it leaves the window"）是同一条检验。若坚持 `×`，等于说"每轮压缩不算销毁边界"，与引擎行自相矛盾。
   - **(B)** **×**：memory 以文本回读，不进参数。
   - **(C)** 建议 **✓**：摘要 "We use **GRPO with privileged full-history distillation** to improve CCM in
     open-weight models" —— 学生从全历史教师的**分布**里学，按本文 §2.1 的 (C) 定义（"Anything trained on a
     distribution gets a tick here"）应打 ✓，**不该写 "---"**。
   - **A′**：A 若为 ✓，A′ 才需要写；该文是 per-turn 运行态记忆，看起来不是 session-local/可逐位回退，
     建议 `× per-turn, not revertible` 并在正文不主张。

> 一句话给正文：**CCM = Continuous Context Management（2609.35540, Hoy et al. 2026）**。
> **2312.03414 = Compressed Context Memory（Kim et al., ICLR 2024），与 CCM 无关，不要引。**

---

## 3. Per-fact LoRA editing（Zenodo **10.5281/zenodo.18778766**）

### 3.1 DOI 是否存在——**存在，且可解析**

- DataCite REST：`HTTP 200`，`state = findable`，`registered = 2026-02-26T01:19:58Z`；
- DOI handle：`responseCode = 1`，`URL → https://zenodo.org/doi/10.5281/zenodo.18778766`；
- Zenodo 记录 API：`https://zenodo.org/api/records/18778766`，1 个文件 `4-Sleeping-LLM.pdf`，许可 CC-BY-4.0。

| 字段 | 记录值 |
|------|--------|
| 标题 | **Sleeping LLM: Two-Phase Memory Consolidation for Lifelong Learning from 3B to 70B Parameters** |
| 作者 | **Baranov, Vladimir**（单一作者，affiliation = **Independent**） |
| 年份 | **2026**（issued 2026-02-18） |
| 出版者 / 类型 | Zenodo / **Preprint**（`resourceTypeGeneral: Preprint`） |
| 同行评审 | **无**。Zenodo 自发布 preprint，无社区、无期刊、作者为独立研究者 |
| 系列 | concept DOI `10.5281/zenodo.18778765`；`Continues` 18778764、`IsContinuedBy` 18778768（至少 3 篇的版本链） |

### 3.2 关键：**标题里没有 "Per-fact LoRA editing" 这个短语**

记录的**正文**才是线索能对上的地方（摘要原句）：

> "We present a two-phase sleep architecture … with slow-wave sleep (SWS) for **individual fact consolidation via
> per-fact LoRA training**, and REM sleep for knowledge integration via synthetic multi-fact conversations. …
> **MEMIT** achieves near-zero perplexity cost for fact injection … per-fact gating achieves 95% consolidation success at 8B"

⇒ "Per-fact LoRA editing" 是对**方法**的描述，不是标题。表格里若写这个名字，读者按标题检索不到该记录。
**建议表内名字：`Sleeping LLM (Zenodo)`**（备选：`Sleeping LLM / per-fact LoRA (Zenodo)`）。
`perfact` 这个键名保留（不改正文 `\cite` 键），但**打印出来的名字必须是 "Sleeping LLM: …"**。

### 3.3 它和 *Language Models Need Sleep*（arXiv 2606.03979）是**两个不同工作**

| | arXiv 2606.03979 | Zenodo 18778766 |
|---|---|---|
| 标题 | *Language Models Need Sleep: Learning to Self-Modify and Consolidate Memories* | *Sleeping LLM: Two-Phase Memory Consolidation … from 3B to 70B Parameters* |
| 作者 | Ali Behrouz, Farnoosh Hashemi, Adel Javanmard, Vahab Mirrokni（4 人） | Vladimir Baranov（1 人，独立） |
| 时间 | v1 2026-06-02（comment：自 2025-09 在 OpenReview） | 2026-02-18 |
| 机制 | Knowledge Seeding（on-policy distillation + RL 模仿）→ Dreaming（RL 合成课程自改进） | SWS = per-fact LoRA、MEMIT 注入、per-fact staged gating；REM = 合成多事实对话整合 |
| 载体 | 训练进基座参数 | LoRA adapter / MEMIT 编辑，再做分阶段溶解（1.0→0.5→0.1→0.0） |
| 互引 | 记录无 `journal_ref`/`doi`，related 字段无 Zenodo | related 字段只有 18778764/18778765/18778768，**没有** arXiv 2606.03979 |

⇒ **不同工作，必须分两条。** 把 Zenodo 那条并进 `sleep2026` 会造成"一个短名指两篇不同论文"，
正是 `ABC-MATRIX-v1.md:365` 已经点出的"需拆成 arXiv:2606.03979 与 Zenodo 两条"。

### 3.4 Per-fact 结论

**可引用（作为预印本）**，已写入 `@misc{perfact}`；但引用文本必须带"非同行评审"标记，且**不能**与 `sleep2026` 合并。
若审稿风险偏好保守，降级方案是"正文只作背景一句话、不进对抗性表格行"——但那是表述策略，不是"不可引用"：
DOI 真实、记录完整、作者/年份/标题都能对上。

---

## 4. 表格里该写哪个名字（可直接抄）

| 表内位置 | 写这个 | 引用键 |
|---|---|---|
| RLM / StateLM / DocAtlas 那一行（若恢复） | `RLM / StateLM / DocAtlas / CCM` | `rlm2025`, `statelm2026`, `docatlas2026`, **`ccm`**（= 2609.35540） |
| 睡眠/巩固那一行 | `Language Models Need Sleep` | `sleep2026` |
| 新增/恢复的 Zenodo 行 | `Sleeping LLM (Zenodo)` | **`perfact`** |

**不要**在表里出现 `CCM~\cite{...}` 却指到 2312.03414。

---

## 5. `references.bib` 改了什么 / 校验到什么程度

改动范围：仅文件末尾的 8 条占位行 → 8 条规范 `@misc`（键名不变、顺序不变），并新增 `ccm` / `perfact` 两条；
文件头注释里的条目计数由"35 entries"改为实际值。

校验（本机无 `bibtex`/`pdflatex` 可执行文件，故未跑 BibTeX；用结构化解析 + 正则核对代替）：

- 条目数 **46**；`\cite` 键 **44**，**无缺失键**、**无重复键**；
- 未引用条目 = `ccm`, `perfact`（**故意**：BibTeX 只打印被引条目，故这两条不会改变 `[n]` 编号，也不会进 PDF）；
- 46 个条目体逐条大括号配平，`author`/`title`/`year` 全在，8 条 arXiv 条目全带 `eprint` + `archivePrefix`；
- **`title unverified` 0 处、`Anonymous` 0 处**。

**建议的下一步（我没有做，因为会动 PDF）**：`pdflatex → bibtex → pdflatex ×2` 后确认编号未变；
若恢复 CCM 行，记得同时按 §2.4 重打 (A)(C) 两格。
