# ABC-MATRIX-v1 — 相关工作定位表（A/B/C 七格）核查

**性质**：只读核查 + 检索。未修改 `paper-fse-v1.tex`、`references*`、`figures/`、`experiments/`、`LOCAL-RESULTS-ADOPTION-v1.md`、`SELFCHECK-r1.md`。本文件是唯一新建文件。

**审计基线**：`paper-fse-v1.tex`，SHA256 `D681DB3DFE495FFA4D1B1F27CBE679DA30486A4455606A9203B3F295447553EF`，mtime `2026-10-26 14:25:21`，Table 1 位于 `paper-fse-v1.tex:275-305`。
⚠️ 核查过程中该文件被改动过（我第一次读到的是更早一版：LOHA/ACD 记 A=×、Doc-to-LoRA 记 C=×）。**你提到的这两个错标在基线版本里已经被修好了**；下面第 5 节列的是基线版本里**仍然存在**的错标。改动若继续，请以 SHA256 对齐。

**证据等级标记**：`[摘要]` = arXiv abs 页 citation_abstract 原文；`[正文]` = `arxiv.org/html/<id>v1` 去标签正文原文；`[需读正文]` = 摘要不足以下判断，注明该读哪一节。

---

## 0. 先把三条判据变成可执行测试（否则矩阵不唯一）

论文 §2.1 的措辞在实现层面有歧义，不同读法会给出不同矩阵。我用的操作化定义如下，每条都给出为什么必须这么钉：

| 判据 | 我采用的可执行测试 | 为什么必须钉 |
|---|---|---|
| **(A) 写点在边界** | 触发事件是"历史即将/正在离开模型输入"（窗口溢出、chunk 驱逐、compaction、pre-eviction）。**排除**：文档末、任务末、按轮数、手动、离线预编译。 | 若不放"排除"，几乎所有 KV/软 token 方法都满足 A（它们本来就在压缩的那一刻干活），A 就失去区分力。 |
| **(B) 载体是参数** | **本次历史的那份产物**（历史不存在后你所依赖的东西）在参数里。**不算**：可复用的编译器/超网络/Writer LoRA（它生成的是 KV 或 token）、soft token、KV、buffer token。 | 2602.21221 与 2607.28069 都"用了 LoRA"，但产物是 buffer token / KV；不钉死这一条会把两篇判反。 |
| **(C) 监督是分布蒸馏** | 监督是"看得见未压缩历史的教师 vs 只能通过被写载体看历史的学生"的分布级匹配（KL/概率），中间不经过文本化（JSON/QA/摘要）。 | 这是 §2.1 的原话（"bypass text and fit a distribution directly"）。**注意**：按这条，(C) 在 KV 阵营几乎是免费的（KV-Distill/SemPIC/RestoreKV/Still 全是分布蒸馏）——见 §6 的后果分析。 |

一个我在核查中反复遇到、论文必须显式回答的区分：**"产物载体" vs "可复用训练模块"**。LOHA/ACD、RestoreKV、Still、Cartridges、SemPIC、2602.21221 全都训练了一个 LoRA/adapter/Perceiver，但它是**跨历史复用的机制**，不是这份历史的载体。判 (B) 只看后者。

---

## 1. 七格矩阵

### 1.1 A only（A✓ B× C×）

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| 生产 compaction 引擎（本文的对照 arm） | dsh，见 `paper-fse-v1.tex:123` | 窗口满 → 写摘要、丢原文，写点就是边界；载体是文本；监督是提示词摘要，无分布匹配 | `[正文/论文]` "its compaction keeps a summary of at most 32k tokens plus a sliding window"；`paper-fse-v1.tex:63` "at the compaction boundary we write the full-context ..." |
| LCLM（边界候选） | arXiv:2606.09659 | 载体是 latent embeddings（B×）；监督是 encoder-decoder 继续预训练，非蒸馏（C×）；"把自身推理压缩进 latent memory"发生在推理中（A 疑似✓） | `[摘要]` "they can compact the model's own generated reasoning into latent memory during inference ... reducing peak KV usage by up to 7.9×" — **`[需读正文]`** 读 §5/§6 的 agent 用法，确认触发点是"KV 压力/上下文将满"还是"每轮固定压缩" |

> 这一格很薄，但它是**论文最重要的对照格**：它证明"在边界写"本身不新。也正因如此，基线版本把引擎标成 A=× 是自相矛盾的（见 §5-1）。

### 1.2 B only（A× B✓ C×）

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| DPPM | arXiv:2610.11776 | 产物是 history-conditioned LoRA（B✓）；写点在"交互历史之后"（A×）；主目标是 CE，蒸馏只当 ablation（C×） | `[摘要]` "Fusing both outputs produces history-conditioned LoRA adapters"；`[正文]` "we fix DPPM's architecture and compare CE with distillation and reward-based variants ... All variants retain CE." |
| EVAF / Memory Depth | arXiv:2606.29916；arXiv:2606.26806 | surprise×valence 门控 + buffer 填满触发（不是丢弃边界，A×）；载体低秩 adapter（B✓）；replay + L2 anchor，无 KL（C×） | `[正文 2606.26806]` "EVAF uses a surprise-times-valence gate to admit only behavior-relevant events into a small buffer. When the buffer fills, a low-rank adapter is updated with replay and an L2 anchor." |
| Sleeping LLM（Baranov 变体） | Zenodo 10.5281/zenodo.18778766（2026-02-18） | 睡眠阶段/按轮触发（A×）；per-fact LoRA + MEMIT 融进权重（B✓）；per-fact SFT，无蒸馏（C×） | `[摘要]` "two-phase sleep architecture ... slow-wave sleep (SWS) for individual fact consolidation via per-fact LoRA training, and REM sleep for knowledge integration via synthetic multi-fact conversations" |
| Beyond Inference-Only Deployment | arXiv:2605.24657 | 夜间定时（A×）；LoRA 写入权重（B✓）；reflection/synthesis 生成文本再 SFT（C×） | `[摘要]` "nightly consolidation of interaction knowledge into model weights via reflection, synthesis, and Low-Rank Adaptation (LoRA) fine-tuning on a single consumer GPU" |

### 1.3 C only（A× B× C✓）

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| Cartridges | arXiv:2506.06266 | 离线按语料训练一份 KV（A×）；既有经典 CD 又显式用 CD 目标（C✓）；产物是 KV（B×） | `[摘要]` "we propose self-study, a training recipe in which we generate synthetic conversations about the corpus and train the Cartridge with a context-distillation objective"；"training a smaller KV cache offline on each corpus" |
| SemPIC | arXiv:2607.28069 | 离线构造每文档 KV（A×）；行为蒸馏（C✓）；**LoRA 是 Writer，产物是 KV**（B×） | `[摘要]` "trains a LoRA-enabled Writer to compile native per-layer document KVs through behavioral distillation while retaining the pretrained decoder as an unchanged Reader" |
| Latent Context Compilation | arXiv:2602.21221 | 按 context 编译一次（A×）；蒸馏（C✓）；**"disposable LoRA 只是编译器"，产物是 buffer token**（B×） | `[摘要]` "By utilizing a disposable LoRA module as a compiler, we distill long contexts into compact buffer tokens -- stateless, portable memory artifacts" |

> 这一格是"LoRA 出现 ≠ 载体是参数"的现场证据。它在讨论"为什么你们的 Δ 是参数而不是 token"时最有用。

### 1.4 A+B（A✓ B✓ C×）—— **只有一篇**

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| TMEM | arXiv:2606.04536 | 上下文预算 `L_max` 到点才进入写入模式、写完清空工作上下文（A✓）；产物 fast LoRA `Δ_t`（B✓）；监督先抽成 grounded QA 再 SFT（C×） | `[正文]` "When the context budget is reached, the agent enters a memory-writing mode: it distills the current session into grounded QA-style supervision and applies a lightweight online SFT update to Δ_t"；`[正文]` "after a trigger, the working context is cleared, and in TMEM the extracted content is retained through Δ_t rather than as prompt text"；`[正文]` 写入提示词 "Return ONLY a JSON array. Each item must be: { \"instruction\": ..., \"output\": ... }" |

### 1.5 A+C（A✓ B× C✓）

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| LOHA/ACD | arXiv:2609.31430 | observation 离开窗口那一刻才转成 soft token（A✓）；载体 soft token（B×）；ACD 是逐 token KL（C✓） | `[正文]` "each new observation enters as text and becomes eligible for compression when it leaves the window"；`[摘要]` "LOHA compresses older tool observations into soft tokens"；`[正文]` "a distillation term aligns predictions from the latent view with those of the frozen base model given the full text"（KL 支撑：`ℓ_distill`、top-64 logits + tail bucket 的粗化 KL） |
| REMORY | arXiv:2610.11287 | 在 compaction 时补 soft memory token（A✓）；载体 token（B×）；"让冻结 LLM 逼近全历史下的续写"=分布匹配（C✓） | `[摘要]` "Long-horizon agents compact their history ... a neural memory network that supplements the summary with a bounded sequence of soft memory tokens ... the network learns to generate tokens that help a frozen LLM approximate the continuation it would produce with the full history" |
| Still | arXiv:2606.07878 | 压缩即丢弃原始 KV，且可迭代进入 long-horizon（A✓）；载体 compact K/V（B×）；forward KL 蒸馏（C✓） | `[正文]` "The training signal is forward KL divergence from a full-context teacher to the compact-cache student, masked to answer-side tokens only"；`[摘要]` "Because compaction is a forward pass, Still can be applied iteratively, entering a long-horizon regime" |
| RestoreKV | arXiv:2608.01247 | **pre-eviction** 那次 pass 就是写点（A✓）；产物是 restore KV cache，adapter 之后关闭（B×）；对称 KL 自蒸馏（C✓） | `[正文]` "after context prefill and before eviction, eight restore tokens attend to the full KV cache in a single LoRA-adapted restore pass, producing a compact restore cache of context-conditioned KV pairs"；`[正文]` "We minimize the token-averaged symmetric KL divergence ... The teacher distributions are detached ... the backbone θ and base importance scorer remain frozen"；`[摘要]` "the adapters are disabled for all subsequent queries and decoding" |
| MemoryWalker / SDCC | arXiv:2609.00865 | **每次 eviction** 就做一次 KL 更新（A✓）；但更新落在策略上、不是这份历史的产物（B×）；forward KL（C✓） | `[摘要]` "At each eviction, it minimizes forward KL between the compressed student and a stop-gradient teacher on the reconstructed pre-eviction prefix." |

> 结论性观察：**A+C 是"压缩蒸馏"整族**——软 token 派（LOHA/ACD、REMORY）与 KV 派（Still、RestoreKV）在 A/B/C 上**完全同格**，只有载体形态不同。现在的 Table 1 把它们拆在了两行、且 C 列给了 `---`。

### 1.6 B+C（B✓ C✓ A×）—— **最拥挤的一格**

| 工作 | 出处 | 为什么是这一格 | 原句 |
|---|---|---|---|
| Askell et al.（LAB） | arXiv:2112.00861 | CD 的规范形式，学生不看 context（C✓）；写入整模型参数（B✓）；写点与"历史销毁"无关（A×） | `[正文]` "we finetune a model p_θ(X) with a loss given by L(θ)=D_KL(p_0(X|C)‖p_θ(X)) where p_0 is the initial model, the context C is fixed"；`[摘要/贡献]` "We introduce 'context distillation' and show that it behaves similarly to prompting." |
| Snell et al. | arXiv:2209.15189 | 同一模型自蒸馏（C✓）；写参数（B✓）；按任务/指令离线做（A×） | `[摘要]` "we condition the model on ''[instructions] + [task-input]'' ... then we fine-tune the same model to predict its own ''[final answer]'' conditioned on the ''[task-input]'', without seeing the ''[instructions]''" |
| Doc-to-LoRA | arXiv:2602.15902 | 超网络一前向产出 LoRA（B✓）；"approximate CD"（C✓）；文档级、推理时（A×） | `[摘要]` "a lightweight hypernetwork that meta-learns to perform approximate CD within a single forward pass ... generates a LoRA adapter"；`[正文]` "The teacher has access to the prompt c, while the student does not."（Eq.1 `min KL(p_θ(y|x,c)‖p_θc(y|x))`） |
| Doc-to-Atom | arXiv:2606.12400 | micro-LoRA 原子（B✓）；多目标蒸馏（C✓）；按文档（A×） | `[摘要]` "Each atom is compiled into an independent micro-LoRA adapter ... The entire system is trained end-to-end through a multi-objective distillation framework." |
| Cache2LoRA | arXiv:2610.24107 | 生成 LoRA 替代文档（B✓）；forward KL + retention（C✓）；按文档/查询（A×） | `[正文]` "the student uses the generated LoRA and the corresponding answering prompt, without the document. At each teacher-answer prefix, we match the student's next-token distribution to the teacher's using forward KL" |
| RPMem | arXiv:2609.23466 | session → latent → LoRA（B✓）；forward-KL 上下文蒸馏（C✓）；写点在 session 末（A×） | `[摘要]` "compiles each session into a model-independent latent memory ... mapped to backbone-specific low-rank adaptation (LoRA) parameters"；`[正文]` "the token-level forward-KL loss"（`p^{ctx}` vs `p^{mem}`）+ "Context distillation optimizes parameters to reproduce behavior induced by a given context" |
| ASCENT | arXiv:2610.05303 | 持久 LoRA fast weights（B✓）；特权信息自蒸馏（C✓）；写点在**任务终止**（A×，见 §2-Q7 的边界讨论） | `[摘要]` "A stable version of the LLM, its frozen initial copy, receives the verified trajectory as privileged information and predicts next-token distributions along it with this hindsight. Distilling them into persistent LoRA fast weights updates the agent for later tasks" |
| CD as Latent Memory Management | arXiv:2605.28889 | 每 context 一份独立 LoRA（B✓）；CD（C✓）；建库按 context（A×） | `[摘要]` "We distill each context into an independent LoRA adapter, forming a modular memory bank that enables explicit memory selection" |
| Rethinking Continual Experience Internalization | arXiv:2606.04703 | 经验→参数（B✓）；显式 context distillation（C✓）；多轮迭代、非边界（A×） | `[摘要]` "off-policy context-distillation on high-quality teacher trajectories provides a substantially more stable training signal than on-policy context-distillation" |

### 1.7 A+B+C

| 工作 | 出处 | 依据 |
|---|---|---|
| **本工作（AVCP）** | `paper-fse-v1.tex:293` | 唯一。见 §2-Q7 的空格论证与 ASCENT 风险。 |

**空格声明**：截至本次检索，A+B+C 格**没有第二篇**。(A∧B) 也只有 TMEM 一篇，但它是 C×；(A∧C) 与 (B∧C) 各 5–9 篇。这不是"没找到"，是**结构性的**：见 §6。

### 1.8 一格都不占（别的范式）

| 工作 | 出处 | 为什么一格都不占 | 原句 |
|---|---|---|---|
| xKV | arXiv:2503.18893 | 训练无关的后训练 KV 低秩分解：没有"写"，没有监督信号，载体是 KV | `[摘要]` "we propose xKV, a post-training compression method that jointly factorizes grouped-layer KV-Cache into a shared low-rank subspace" |
| StateLM（Pensieve） | arXiv:2602.12108 | 载体是自管上下文（工具调用），B×；A×；C× | `[摘要]` "We equip our model with a suite of memory tools, such as context pruning, document indexing, and note-taking, and train it to actively manage these tools." |
| Recursive Language Models | arXiv:2512.24601 | 长 prompt 当外部环境递归自调用，B×、A×、C× | `[摘要]` "treats long prompts as part of an external environment and allows the LLM to programmatically examine, decompose, and recursively call itself over snippets of the prompt" |
| DocAtlas | arXiv:2608.07527 | 外部 harness + 备注/树检索，B× | `[摘要]` "an external environment that determines what document information is searched, read, stored, reviewed, and shown to the model at each step" |
| LCLM | arXiv:2606.09659 | 若 §0 的 A 判据收紧（排除"连续 chunk 压缩"），则 A×、B×（latent embeddings）、C×（继续预训练） | `[摘要]` "encoder-decoder compressors, which map a long token sequence to a shorter sequence of latent embeddings consumed by a decoder ... we continually pre-train a family of 0.6B-encoder, 4B-decoder models" |

**未核实、建议从表里删或替换的名字**（见 §5-9）：
- **LCC**：在 KV 压缩文献里 "LCC" 是 benchmark 列名（LongBench-Chat 类），没有找到对应的"方法"论文。**建议删除**。
- **CCM**：最可能是 *Compressed Context Memory*（arXiv:2312.03414，插入 `[COMP]` 指示 token 的压缩模型；转引见 2412.19442："CCM [101] inserts a special indicator token, [COMP], into the input sequence and compresses the accumulating past"）。**要么按 2312.03414 核实并给引用，要么删**。

---

## 2. 七个问题的逐条回答

### Q1. (C) 这一格到底有谁？

按 §0 的 (C)（分布级、文本无关的教师-学生匹配），已有 + 新增共 **13 篇**，其中 2024–2026 的"把 context 蒸馏进参数"的明确工作 5 篇（含你已知的 Doc-to-LoRA）：

| 工作 | 出处 | 摘要/正文原句（证据） | 载体 | 写点 |
|---|---|---|---|---|
| Askell et al. 2021 | 2112.00861 | `[正文]` "we finetune a model p_θ(X) with a loss given by L(θ)=D_KL(p_0(X|C)‖p_θ(X))" | 全参 | 离线 |
| Snell et al. 2022 | 2209.15189 | `[摘要]` "fine-tune the same model to predict its own ''[final answer]'' conditioned on the ''[task-input]'', without seeing the ''[instructions]''" | 全参 | 离线 |
| Doc-to-LoRA 2026 | 2602.15902 | `[摘要]` "meta-learns to perform approximate CD within a single forward pass ... generates a LoRA adapter" | LoRA | 文档级 |
| **CD as Latent Memory Management** 2026 | 2605.28889 | `[摘要]` "We distill each context into an independent LoRA adapter, forming a modular memory bank" | LoRA/context | 建库 |
| **RPMem** 2026 | 2609.23466 | `[正文]` "the token-level forward-KL loss"，`p^{ctx}` vs `p^{mem}`；`[正文]` "Context distillation optimizes parameters to reproduce behavior induced by a given context" | LoRA/session | session 末 |
| **Doc-to-Atom** 2026 | 2606.12400 | `[摘要]` "Each atom is compiled into an independent micro-LoRA adapter ... trained end-to-end through a multi-objective distillation framework" | micro-LoRA | 文档级 |
| **Cache2LoRA** 2026 | 2610.24107 | `[正文]` "match the student's next-token distribution to the teacher's using forward KL ... without the document" | LoRA | 文档/查询 |
| **ASCENT** 2026 | 2610.05303 | `[摘要]` "Distilling them into persistent LoRA fast weights updates the agent for later tasks" | LoRA | 任务末 |
| **Rethinking Continual Exp. Internalization** 2026 | 2606.04703 | `[摘要]` "off-policy context-distillation on high-quality teacher trajectories" | 参数 | 多轮 |
| Cartridges 2025 | 2506.06266 | `[摘要]` "train the Cartridge with a context-distillation objective" | KV | 离线 |
| SemPIC 2026 | 2607.28069 | `[摘要]` "compile native per-layer document KVs through behavioral distillation" | KV | 离线 |
| Latent Context Compilation 2026 | 2602.21221 | `[摘要]` "we distill long contexts into compact buffer tokens" | buffer token | 按 context |
| LOHA/ACD / Still / RestoreKV / REMORY / MemoryWalker | 见 §1.5 | 逐 token / 全词表 KL | 软 token / KV | 边界 |

**答案**：如果 (C) 只指"分布蒸馏"，这一格**很挤**；如果 (C) 指规范 CD（学生输入里完全没有历史，历史只能通过被写载体存在），则只剩 **Askell / Snell / Doc-to-LoRA / Doc-to-Atom / Cache2LoRA / RPMem / ASCENT / 2605.28889 / 2606.04703**（9 篇，全部 B+C）。两种读法**必须选一个并写进 §2.1**，否则同一张表可以被任意解读（见 §6）。

### Q2. LOHA/ACD（2609.31430）到底占哪几格？

**A✓ B× C✓ → A+C。**

- **A = ✓**，依据不是"缩写里有 A"，而是正文对触发点的定义：`[正文]` "each new observation enters as text and becomes eligible for compression when it leaves the window"；`[正文]` "an observation changes from text to soft tokens when it leaves the window. This invalidates decoder prefix-cache entries from the first changed observation onward"。这正是"历史被压缩/即将丢弃的那一刻"。（旧稿标 A=× 是错的；基线版本已改成 ✓，是对的。）
- **B = ×**，载体是 soft token，不是参数：`[摘要]` "LOHA compresses older tool observations into soft tokens while retaining the agent's own turns and the last K observations in text"。它的 patch/adapter 是**训练一次、跨任务复用的读取器**（"reading patch"），不是这份历史的载体——所以不能因为"训练了 adapter"就记 B✓。
- **C = ✓**，ACD 是货真价实的分布匹配：`[摘要]` "ACD distills the base model's full-text predictions into the latent view while anchoring its behavior on plain-text inputs to the same base model"；`[正文]` "a distillation term aligns predictions from the latent view with those of the frozen base model given the full text, while an anchor term constrains the adapted model's predictions on full-text inputs"。正文用 `ℓ_distill`（逐 token KL，top-64 logits + 尾部桶的粗化 KL）与 `ℓ_anchor` 两项。
- **它对 (C) 的意义**：ACD 是"**压缩视图蒸馏**"——教师看全文，学生看软 token。这**是**分布蒸馏，但学生并不是"无上下文"，所以它**不是** §1.5/§2.1 那种意义下的 context distillation。这正是 (C) 需要加限制词的理由（§6）。
- 一句话判词：**LOHA/ACD 占 A+C，不占 B；它证明"在边界写 + 蒸馏"可以完全不碰参数。**

### Q3. TMEM（2606.04536）的 C 是 × 吗？

**是 ×。依据是正文，不是摘要**（摘要只说 "distilled supervision"，容易被误读成 C✓）：

`[正文]` "When the context budget is reached, the agent enters a memory-writing mode: it distills the current session into **grounded QA-style supervision** and applies a lightweight online SFT update to Δ_t"。
`[正文]` 写入提示词（Figure 1）："**Return ONLY a JSON array. Each item must be: { \"instruction\": \"<question>\", \"output\": \"<answer>\" }**"、"Output the generated SFT QA pairs in the specified JSON format."
`[正文]` "the trigger counter uses the token length of the current working context plus explicit memory; after a trigger, **the working context is cleared**"。

所以：**先 JSON-QA 抽取 → 再 SFT**，监督是文本化标签，不是分布匹配 → **C=×**。基线版本这一行（A✓ / B✓ / C× / A′✓）**是对的**，可以保留。注意表述分寸：TMEM 自己用了 "distill" 一词，但那是"把会话提炼成 QA"的提炼，不是 KL 蒸馏——论文 §2.3 现在的写法（"its supervision first passes through a JSON-QA extraction"）是准确且站得住的。

### Q4. RestoreKV（2608.01247）：写点算 (A) 吗？载体是 KV 还是参数？监督是什么？

- **写点 = ✓（算 A）**。它明确把写放在驱逐发生的那一刻之前：`[正文]` "after context prefill and **before eviction**, eight restore tokens attend to the full KV cache in a single LoRA-adapted restore pass, producing a compact restore cache of context-conditioned KV pairs"。判别测试（写的时候历史还在不在？）也过：写这件事的存在理由就是"驱逐即将丢掉的东西"，且写完立即进入被压缩状态。
- **载体 = KV，不是参数（B=×）**。产物是 restore cache（KV pairs）；LoRA 是**共享机制**、跨 context 复用：`[摘要]` "although the information lost through eviction is context-specific, the mechanism for generating its compact complement can be **shared across contexts**"；`[摘要]` "the adapters are **disabled** for all subsequent queries and decoding"。所以"驱逐后用 LoRA 补出 restore KV"里，**LoRA 是笔画，KV 是字**。
- **监督 = 分布蒸馏（C✓）**：`[正文]` "We minimize the token-averaged **symmetric KL divergence** ... teacher distributions are detached ... the backbone θ and base importance scorer remain frozen"，即从 frozen full-cache teacher 自蒸馏。中间无文本化。
- **合计：A✓ B× C✓ → A+C**，并且它是全表里 **A′（可删/可关闭）最接近本文**的一篇（adapter 关闭后就是原模型）。基线版本把它记成 A=× / C=`---`，**两处都错**。

### Q5. Still（2606.07878）/ Cartridges（2506.06266）：写点、载体

**Still（2606.07878）**
- 写点：**A✓（弱形式）**。"compaction 就是丢弃原文的那一刻"，且它是流式 chunk 边压边丢：`[正文]` "It is crucial for prefill to occur sequentially this way in tandem with compaction because this matches the use case at inference over long contexts"；`[摘要]` "Because compaction is a forward pass, Still can be applied iteratively, entering a long-horizon regime unavailable to per-context methods"。若你的 A 要求"会话级显式 compact 事件"，它就该是 ×——**这是 A 判据必须写清的地方**，不是 Still 的问题。
- 载体：**KV（B×）**。`[摘要]` "a small per-layer Perceiver trained once against a frozen base model that produces **compact keys and values** in a single forward pass"。Perceiver 是**训练一次**的模块（"trained once"），不是每份历史的产物。
- 监督：**C✓**。`[正文]` "forward KL divergence from a full-context teacher to the compact-cache student, masked to answer-side tokens only"。
- 合计 **A+C**。

**Cartridges（2506.06266）**
- 写点：**A×（离线、每语料一份，部署前训练）**。`[摘要]` "training a smaller KV cache **offline** on each corpus ... At inference time, we load this trained KV cache"。语料并没有"即将被丢弃"这个事件。
- 载体：**KV（B×）**，即 Cartridge 本身。
- 监督：**C✓**，而且是**显式命名的** context distillation：`[摘要]` "we propose self-study, a training recipe in which we generate synthetic conversations about the corpus and **train the Cartridge with a context-distillation objective**"。
- 合计 **C only**。→ 现在把它塞进 "Still / RestoreKV / Cartridges / XKV / SemPIC" 一行、C 记 `---`，是**把三个不同格混成一行**（见 §5-2）。

### Q6. Sleeping LLM 系列 / Memory Depth（2606.26806）

**"Sleeping LLM" 在文献里有两个不同的东西，Table 1 现在这一行（"× by round or manual / ✓ merged into base / × Q&A extraction"）对两者都不成立：**

**(a) arXiv:2606.03979** *Language Models Need Sleep: Learning to Self-Modify and Consolidate Memories*
- 写点：**×**。睡眠阶段（周期性、按轮）——`[摘要]` "we introduce a 'Sleep' paradigm that allows the models to continually learn, distill their short-term fragile memories into stable long-term knowledge with replay, and recursively improve themselves with 'Dreaming' process"。
- 载体：**✓ 参数**（蒸馏进更大网络/权重）——`[摘要]` "Memory Consolidation: an upward distillation process, called Knowledge Seeding, where the memories of a smaller-self are distilled into a larger network"。
- 监督：**✓ 蒸馏，不是 Q&A 抽取**——`[摘要]` "the combination of on-policy distillation with Reinforcement Learning (RL)-based imitation learning"。
- 合计 **B+C**。→ Table 1 的 "× Q&A extraction" **没有依据**，应改成 ✓。

**(b) Zenodo 10.5281/zenodo.18778766** *Sleeping LLM: Two-Phase Memory Consolidation for Lifelong Learning from 3B to 70B Parameters*（Baranov, 2026-02-18，"Sleeping LLM research series"）
- 写点：×（睡眠/分阶段）。
- 载体：✓（per-fact LoRA + MEMIT 溶解表 → "merged into base" 成立）。
- 监督：×（per-fact SFT/召回测试 + REM 合成多事实对话），**但不是 Q&A 抽取**。
- 合计 **B only**。

**Memory Depth / EVAF（2606.26806 + 2606.29916）**
- 写点：**×**。触发是 surprise×valence 门 + buffer 填满，不是历史丢弃边界；`[正文 2606.26806]` "uses a surprise-times-valence gate to admit only behavior-relevant events into a small buffer. When the buffer fills, a low-rank adapter is updated with replay and an L2 anchor."；`[摘要]` "only 2–3 parametric writes per 200 events"。
- 载体：**✓**（"durable goal-conditioned tendencies written into a small parametric store"，低秩 adapter）。
- 监督：**×**。replay + L2 anchor；两篇正文里 **没有任何 KL/蒸馏**表述（我对 `2606.29916` 与 `2606.26806` 全文做了 "KL"/"distill" 检索，零命中）。
- 合计 **B only**。

### Q7. 有没有我们漏掉的、同时占 A+B 的？（最关键的一格）

**结论：除 TMEM 外没有找到第二篇确定的 A+B。A+B+C 格为空。但这个结论有一个必须处理的边界案例。**

**边界案例（唯一真正危险的一篇）：ASCENT（arXiv:2610.05303）**
`[摘要]` "We study Online Agentic Test-Time Training (OaTTT), which trains the LLM's weights on its own execution trajectories during deployment. The agent executes each task once ... and **the executed trajectory with its verification result is the only learning signal for weight updates that persist across tasks**." + "Distilling them into **persistent LoRA fast weights** ... A stable version of the LLM, **its frozen initial copy**, receives the verified trajectory as **privileged information** and predicts next-token distributions along it with this hindsight."

- 载体：参数 ✓（persistent LoRA）。
- 监督：规范 CD ✓（教师 = 拿到轨迹的冻结副本；学生 = 没有轨迹的同一模型；分布匹配；无文本化）。
- 写点：**任务终止时**。你的 A 定义里"任务末"被显式排除 → 现判 A×。**但"任务终止"恰好也是那条轨迹被丢弃的时刻**；如果审稿人不接受"任务末 ≠ 边界"这个人造切分，ASCENT 就是 **A+B+C**，本文的"没有人同时占三格"立刻被打破。

**我的建议（这条比矩阵本身更重要）**：不要把护城河押在 A 的定义上，押在 **A′（生命周期）** 上，并在 §2.1 把区别写成可判定的两点：
1. ASCENT 的写是**跨任务累积、不可回滚**的（persistent LoRA，无 Δ=0），本文的产物是**会话内、用完即弃、Δ=0 位级还原**；
2. ASCENT 写的是**任务轨迹/技能**（要泛化到后续任务），本文写的是**这段历史**（要不可泛化）。
这两句现在散在 §2.2/§2.5 里，建议前移到 §2.1 的 A′ 定义旁边，并在 Table 1 里给 ASCENT 加脚注（"episode-end write; persistent, non-revertible"），**主动**把它点名，比被审稿人点名好。

**我为此排查并排除的候选（都给了原句，见 §1）**：
| 候选 | 为什么不是 A+B |
|---|---|
| RestoreKV 2608.01247 | 载体是 KV（B×），虽然写点在 pre-eviction ✓ |
| Still 2606.07878 | 载体是 KV（B×） |
| MemoryWalker 2609.00865 | 每次 eviction 都做 KL ✓，但更新的是策略、不是这份历史的产物（B×，且是训练期） |
| EVAF / Memory Depth | surprise 门控（A×），无蒸馏（C×） |
| Cartridges / SemPIC / Latent Context Compilation | 离线预编译（A×） |
| 2605.24657（nightly） | 夜间定时（A×）+ 文本合成（C×） |
| DPPM 2610.11776 | CE 主目标（C×），写点在历史之后（A×） |
| Sleeping LLM (a)/(b) | 睡眠阶段/按轮（A×） |
| TMEM 2606.04536 | **是 A+B**，但 C×（JSON-QA） |

**检索局限（必须写进你的 limitation，否则这条"空格"会被质疑）**：本次为关键词/摘要驱动，覆盖 arXiv cs.CL/cs.AI 2025-10 → 2026-10 的主要命中，外加作者页/会议页/Zenodo 的少量补充。**没覆盖**：非英文文献、OpenReview 匿名稿、以及用另一套词汇描述同一件事的工作（`weight consolidation`、`fast weights`、`memory consolidation`、`neurogenesis`、`sleep` 等）。建议再做一轮以 "*eviction* OR *compaction*" × "*distill* OR *KL*" × "*LoRA* OR *weights*" 的正则式 arXiv 全文检索（`arxiv.org/search` 的 full-text 或 Google Scholar），把 ASCENT 这类"任务末"工作扫干净。

---

## 3. 对现有 Table 1 的错标清单（基线 SHA256 `D681DB3D...`，行号见 `paper-fse-v1.tex`）

按行给，每条都是"现在是什么 → 应改成什么 → 依据"。

### 3.1 `paper-fse-v1.tex:283` 生产引擎行
| 列 | 现在 | 应改为 | 依据 |
|---|---|---|---|
| A | `×` | **`✓ at the window boundary`** | 引擎的 compaction 就是边界触发；本行自己的 Reading 是 "spatial"，与 A 无关。而且 §1（`paper-fse-v1.tex:63`）写的是 "at the compaction boundary we write the full-context ..."，表与正文自相矛盾。 |
| C | `---` | **`×`** | 提示词摘要，无任何分布级监督。 |

> 改完之后这一行就是"**A only**"，它把本文与引擎的区别精确压到 (B)(C) 两列——比现在的 × 更有说服力。若你坚持 A=×，必须在 §2.1 给 A 加一句"写入必须是**参数/载体写入**"的限定，否则判据与表格冲突。

### 3.2 `paper-fse-v1.tex:284` KV 行 —— **这一行必须拆**
| 系统 | 现在 | 应改为 | 依据 |
|---|---|---|---|
| Still | A× / C`---` | **A✓ / C✓** | `[正文]` "iterative ... in tandem with compaction"；`[正文]` "forward KL divergence from a full-context teacher to the compact-cache student" |
| RestoreKV | A× / C`---` | **A✓ / C✓** | `[正文]` "before eviction ... restore pass"；`[正文]` "token-averaged symmetric KL divergence ... frozen full-cache teacher" |
| Cartridges | A× / C`---` | **A× / C✓** | `[摘要]` "train the Cartridge with a context-distillation objective"（A 保持 ×） |
| SemPIC | A× / C`---` | **A× / C✓** | `[摘要]` "compile native per-layer document KVs through behavioral distillation" |
| xKV | A× / C`---` | **A× / C×**，且注明"**无监督**（训练无关）" | `[摘要]` "xKV, a post-training compression method that jointly factorizes grouped-layer KV-Cache" |
| A′ 列 | `× prefix lifetime` | **`n/a`（A=× 的行）/ 或 Still·RestoreKV 单独给 `✓ 可关闭`** | 违背自己 §2.1 的规则："Where (A) fails the question does not arise, and we write 'n/a'" |
| 引用 | 无（除 Still/RestoreKV/Cartridges） | 补 **SemPIC = 2607.28069**、**xKV = 2503.18893** | — |

拆成三行：`Still, RestoreKV`（A+C）/ `Cartridges, SemPIC`（C only）/ `xKV`（none）。

### 3.3 `paper-fse-v1.tex:285` LOHA/ACD
- A✓、B×、C✓ 在基线版本里**全部正确**，无需改。
- 唯一建议：Reading "trains the reader, not the carrier" 保留（准确），但把 REMORY 并进来（同格，见 §4）。

### 3.4 `paper-fse-v1.tex:286` REMORY / LCLM / LCC —— 三个不同格，必须拆
| 系统 | 现在 | 应改为 | 依据 |
|---|---|---|---|
| REMORY | A`---` / C`---` | **A✓ / C✓**（→ A+C，与 LOHA/ACD 同格） | `[摘要]` "Long-horizon agents compact their history ... a neural memory network that supplements the summary with a bounded sequence of soft memory tokens ... learns to generate tokens that help a frozen LLM approximate the continuation it would produce with the full history" |
| LCLM | A`---` | **A ✓（borderline）或 ×**，并在脚注写清 | `[摘要]` "they can compact the model's own generated reasoning into latent memory during inference" — **`[需读正文]`** §5/§6 确认触发 |
| LCC | 列在表里 | **删除或换算** | 未找到对应方法论文；"LCC" 在 KV 压缩文献里是 benchmark 列名 |

B 列（"soft tokens in sequence"）对 REMORY/LCLM 正确；LCC 未核实。

### 3.5 `paper-fse-v1.tex:287` RLM / StateLM / DocAtlas / CCM
- A×、B× 两项**判断正确**（都是"读回上下文/外部环境"），但**全文与 bib 里一次都没出现**（SELFCHECK P7 已点名）。现在能补的引用：
  - **StateLM = arXiv:2602.12108**（`[摘要]` "a suite of memory tools, such as context pruning, document indexing, and note-taking"）
  - **RLM = arXiv:2512.24601**（`[摘要]` "treats long prompts as part of an external environment"）
  - **DocAtlas = arXiv:2608.07527**（`[摘要]` "an external environment that determines what document information is searched, read, stored, reviewed, and shown to the model at each step"）
  - **CCM**：核实为 *Compressed Context Memory*（2312.03414）再加引用，否则删。
- C 列 `---` 建议改 `×`（这三者都没有分布级监督；`---` 会被读成"未评估"）。

### 3.6 `paper-fse-v1.tex:288` RPMem / DPPM / ASCENT / Doc-to-Atom —— **本行 3/4 条 C 标反了**
| 系统 | 现在 | 应改为 | 依据 |
|---|---|---|---|
| RPMem | C `× textified first` | **C✓**（→ B+C） | `[正文]` "the token-level forward-KL loss"（`p^{ctx}` vs `p^{mem}`）+ `[正文]` "Context distillation optimizes parameters to reproduce behavior induced by a given context" |
| Doc-to-Atom | C `× textified first` | **C✓**（→ B+C） | `[摘要]` "The entire system is trained end-to-end through a multi-objective distillation framework" |
| ASCENT | C `× textified first` | **C✓**（→ B+C；A 见 §2-Q7 边界） | `[摘要]` "Distilling them into persistent LoRA fast weights" |
| DPPM | C `× textified first` | **C× 但理由要改**：`× CE on answers (distillation only as an ablation variant)` | `[正文]` "we fix DPPM's architecture and compare CE with distillation ... All variants retain CE." |

关键：**"textified first" 这个理由是错的**。RPMem/ASCENT/Doc-to-Atom **没有**文本化，它们是真 KL 蒸馏；DPPM 是 CE，也不是文本化。这一格错得最容易被审稿人抓住（一句话就能反证）。

### 3.7 `paper-fse-v1.tex:289` Doc-to-LoRA
- A×、B✓、C✓ **正确**。
- 问题不在错标，在 **C 列只有它一个 B+C**，而实际 B+C 有 9 篇（§1.6）。这会让"B+C 是常见组合"这一事实消失，也让"本文同时占三格"看起来比实际更容易。

### 3.8 `paper-fse-v1.tex:290` Sleeping LLM family —— **"Q&A extraction" 无据，且两个同名工作必须分开**
- 现在：`× by round or manual / ✓ merged into base / × Q&A extraction / × permanent overwrite`
- 应改为两条：
  1. **Language Models Need Sleep（arXiv:2606.03979）**：A× / B✓ / **C✓（蒸馏）** → **B+C**；A′ 改 `n/a`。
     `[摘要]` "distill their short-term fragile memories into stable long-term knowledge with replay"；"Knowledge Seeding, where the memories of a smaller-self are distilled into a larger network"。
  2. **Sleeping LLM（Zenodo 10.5281/zenodo.18778766）**：A× / B✓ / **C×（per-fact SFT + MEMIT，不是 Q&A）** → **B only**；A′ 改 `n/a`。
     `[摘要]` "slow-wave sleep (SWS) for individual fact consolidation via per-fact LoRA training, and REM sleep for knowledge integration via synthetic multi-fact conversations"。
- **"Q&A extraction" 必须删**：两条摘要都不支持；它恰好也是 TMEM 的特征，写在这里会让"TMEM 的 C=× 是唯一的"这个卖点变糊。
- A′ 列 `× permanent overwrite` 也违反自己的规则（A=× 时应写 n/a）。

### 3.9 `paper-fse-v1.tex:291` TMEM
- A✓ / B✓ / C× / A′✓ **全部正确**，原句见 §2-Q3。建议补引用位置到 §2.3 而非只放表里。
- 唯一建议：Reading "differs in C" 保留，但在 caption 里加半句"and is the only A+B entry in this table"——这正是本文需要的对照。

### 3.10 全表级问题（不是某一行）
1. **`A′` 列在 A=× 的行仍然打 `×`**（284、290 行），与 §2.1 自己的规则冲突（"Where (A) fails ... we write 'n/a'"）。→ 统一改 `n/a`。
2. **(C) 的定义没有排除"压缩视图蒸馏"**。按现在的措辞（"bypass text and fit a distribution"），KV 蒸馏全族（Still/RestoreKV/SemPIC/Cartridges）与软 token 蒸馏全族（LOHA/ACD/REMORY）都满足 C。这不是错，但**必须显式承认**，否则读者会问"为什么 LOHA 的 C 是 ✓ 而 Cartridges 的 C 是 `---`"——一句话就能问倒整张表。
3. **9 个无引用名字**（SELFCHECK P7）：本次能给 5 个真引用（SemPIC、xKV、StateLM、RLM、DocAtlas），2 个建议删（LCC、CCM 未核实），其余（ASCENT 已核实为 2610.05303；Sleeping LLM 已核实为 2606.03979 + Zenodo）也都补上。
4. **表里没有"这篇在哪个 arXiv 号"这一列**。建议加一列或脚注给 id，因为表内所有判断现在都不可溯源（这正是 SELFCHECK P7 的核心指控）。

---

## 4. 聚类建议（哪些工作可以合成一行）

依据：**在 A/B/C 上完全同格**，且载体形态相同。合行的好处是表变短、每行的"为什么在这一格"更容易一眼验证；同时把"空格"显性化。

| 建议行 | 成员（arXiv） | 同格理由（一句话） | 该行在 A/B/C |
|---|---|---|---|
| **① edits KV directly（无监督，训练无关）** | xKV 2503.18893 | 后训练低秩分解，既无写点也无监督 | — / — / — |
| **② KV 蒸馏（离线/按 context 编译）** | Cartridges 2506.06266、SemPIC 2607.28069 | 都离线把语料/文档编成 KV，都用行为/上下文蒸馏 | A× B× **C✓** |
| **③ KV 蒸馏（在驱逐边界）** | Still 2606.07878、RestoreKV 2608.01247 | 都在"原始 KV 被丢弃"那一刻蒸馏出替代 KV；RestoreKV 还额外可关闭 | **A✓** B× **C✓** |
| **④ soft token in sequence（在窗口边界写）** | LOHA/ACD 2609.31430、REMORY 2610.11287 | 都在 observation 离开窗口/压缩时写入定长软 token，都用分布匹配训读取器 | **A✓** B× **C✓** |
| **⑤ soft/buffer token（离线编译）** | Latent Context Compilation 2602.21221、（LCLM 2606.09659 可选） | 编译产物是 token，不是参数；"disposable LoRA"只是编译器 | A× B× C✓（LCLM 为 ×） |
| **⑥ context → LoRA（context distillation 一族）** | Doc-to-LoRA 2602.15902、Doc-to-Atom 2606.12400、Cache2LoRA 2610.24107、RPMem 2609.23466、CD-as-Latent-Memory 2605.28889、2606.04703 | 产物是每份 context/session 一个 LoRA，监督是 KL/CD | A× **B✓ C✓** |
| **⑦ 同 ⑥ 但写点在任务末** | ASCENT 2610.05303 | 唯一"轨迹即将丢弃时蒸馏进权重"的一篇；必须单列并加脚注 | A×（争议）**B✓ C✓** |
| **⑧ 参数记忆，但监督文本化/任务标签** | TMEM 2606.04536（JSON-QA） | 唯一 A+B | **A✓ B✓** C× |
| **⑨ 参数记忆，非边界触发、非蒸馏** | DPPM 2610.11776、EVAF/Memory Depth 2606.29916+2606.26806、Sleeping LLM(Zenodo)、Beyond-Inference-Only 2605.24657 | 都"写参数"，但触发是 buffer/轮数/夜间/surprise，监督是 CE/SFT/合成 | A× **B✓** C× |
| **⑩ read back into context / tools** | StateLM 2602.12108、RLM 2512.24601、DocAtlas 2608.07527 | 历史留在环境/工具里，不写 | — / — / — |
| **⑪ text compaction at the boundary（本文的对照）** | dsh 引擎 | 在边界写，但写的是文本 | **A✓** B× C× |

合并后的七格计数（这是你应该放进正文的那句话）：

```
A only        : ⑪                      (1)
B only        : ⑨                      (4)
C only        : ② ⑤                    (3–4)
A+B           : ⑧ TMEM                 (1)
A+C           : ③ ④                    (4)
B+C           : ⑥ ⑦                    (7)
A+B+C         : 本文                    (1)
none          : ① ⑩                    (4)
```

**这张计数表本身就是论文该讲的故事**：(A) 与 (C) 在 KV/软 token 阵营几乎免费（③④②⑤ 全部满足 C），(B) 在 context-to-LoRA 阵营几乎免费（⑥⑦ 全部满足 B），**只有 (A)∧(B) 是空的**（TMEM 之外无人），而 (A)∧(B)∧(C) 只有本文。建议正文直接把这句话写出来，比现在"逐列打勾"的读法强得多，也把 SELFCHECK P7 的"9 个名字无引用"风险降到最低（合并后每行都有 1–7 个可查 id）。

---

## 5. 我建议你在正文里补的三句话（不改表也能落地）

1. **给 (C) 加限定**（§2.1）："(C) holds when the teacher sees the uncompressed history and the student's only access to it is through the artifact being written; works whose student still reads a compressed view (soft tokens, compact KV) are marked C as *compression distillation* and are footnoted as such." → 这样 LOHA/ACD、Still、RestoreKV、REMORY 的 ✓ 与 Doc-to-LoRA 的 ✓ 可以共存而不混淆。
2. **给 (A) 加"会话内"与"非任务末"**（§2.1）：把 §2.2 的 "at the end of a session, a task, a document, or a number of rounds" 前移，并点名 ASCENT（episode-end, persistent, non-revertible）为最接近的反例 → 主动防守。
3. **把护城河挪到 A′**（§2.1/§2.5）："(A) and (C) are commodity in the compression literature; what is rare is (A) together with (B); what is rarer still is (A) with (B) and a lifecycle that returns the model to bitwise identity." 这与 §5（`paper-fse-v1.tex:449`）的论证方向一致，但现在是隐含的。

---

## 5.5 版本漂移：核查期间论文被改过两次（请以本节对齐）

- 我第一次读到的版本：`paper-fse-v1.tex` 里 **LOHA/ACD = A×、Doc-to-LoRA = C×**（这正是你提到的两个错标）。
- 审计基线：SHA256 `D681DB3D…`，mtime `2026-10-26 14:25:21`。此版本已把 LOHA/ACD 改成 A✓/C✓、Doc-to-LoRA 改成 C✓。
- **最新版本（写本文件时）**：SHA256 `0D4FF0A9…`，mtime `2026-10-26 14:29:19`。相对基线又变了：
  - L286 的 `REMORY / LCLM / LCC` 行**已拆开**，REMORY 独立成行且标为 `A✓ at the compaction boundary / B× soft memory tokens / C✓ reverse KL, full-vocab / A′× Δ≠0` —— **与本文 §1.5 的判定完全一致**，此行无需再改（只需确认 C 的措辞与 (C) 的新定义对齐）。
  - LCLM/LCC 从表中消失（与我"LCC 建议删除"的结论一致；LCLM 若要保留需按 §1.1 加 borderline 脚注）。
  - L285 LOHA/ACD 的 A′ 由 `n/a` 改为 `× dies with the context` —— 判定合理（软 token 会随上下文一起消失，不是"可回滚的参数 Δ"）。
  - **截至最新版本仍未改的项**：L283 引擎（A 应为 ✓、C 应为 ×）、L284 KV 五行混格（Still/RestoreKV 应为 A✓C✓；Cartridges/SemPIC 应为 C✓；xKV 应为 C× 且注明无监督；A′ 列在 A=× 的行应写 n/a）、L288 缺 5 个引用、L289 四个系统的 C 有 3 个标反（RPMem/Doc-to-Atom/ASCENT 应为 C✓，DPPM 的理由要改成 CE）、L291 Sleeping LLM（"Q&A extraction" 无据，且需拆成 arXiv:2606.03979 与 Zenodo 两条）。
- 另注：`REMORY-LCLM-LCC-v1.md`（14:28:43）已由另一个 worker 产出，本文件 §1.5/§3.4 的 REMORY 结论与它应当一致；若有分歧，以原句为准。

---

## 6. 未完成项（诚实清单）

| 项 | 状态 | 需要什么 |
|---|---|---|
| LCLM 的 A | `[需读正文]` | arXiv:2606.09659 §5/§6 的 agent 用法：压缩触发是"KV 压力/上下文将满"还是每轮固定 |
| CCM 的身份 | 未核实 | 若指 2312.03414，读摘要确认监督形式；否则从表中删 |
| LCC | 未找到方法论文 | 建议删 |
| Cache2LoRA 的写点 | `[摘要]` 足够判 A×（按文档/查询），但"reusable frozen document cache"是否算离线预编译，需读 §3 | arXiv:2610.24107 §3 |
| KV-Distill（Zweiger et al. 2026） | 作为 Still 的对话 baseline 被提到，未取 id | 若要在表里出现需补 id 与摘要 |
| 非 arXiv 来源（OpenReview 匿名、Zenodo、会议 poster） | 只覆盖到被引到的少数 | 若要主张"A+B+C 为空"，建议再做一轮 full-text 正则检索（见 §2-Q7 的局限声明） |
