# REMORY / LCLM / LCC — 三条判据核查 v1

> 只读核查。未修改 `paper-fse-v1.tex`、`references.bib`、`ABC-MATRIX-v1.md`、`experiments/`、`.local-8b/`。
> 全文检索方式：把 `arxiv.org/html/<id>` 下载到系统临时目录（`%TEMP%\abc-check\`），去标签后本地 grep；**没有**在工作区新建除本文件以外的任何文件。
> 证据规则：每条结论附 arXiv 号 + 原句；摘要说不清的一律落到正文小节。**没有按标题或缩写推断任何一条判据。**

---

## 0. 结论速览

| Work | 身份 | A 写点在边界 | B 载体是参数 | C 分布蒸馏 | A′（A 成立时才定义） |
|---|---|---|---|---|---|
| **REMORY** | arXiv 2610.11287v3（确证，高） | **✓** compaction boundary | **×** 序列内 soft tokens | **✓** reverse KL，frozen teacher | **部分**：会话局部 + 每边界重写；但 **Δ≠0**（有损，逐位回原只能靠外部 archive） |
| **LCLM** | arXiv 2606.09659v2（确证，高） | **×** 摊销式 prefill 压缩（§7.2 的 rolling compaction 按固定 token 数触发） | **×** latent soft tokens | **×** token 级 CE + 文本重建 SFT（全文 0 处 KL/distillation） | n/a |
| **LCC** | 推定 arXiv 2602.21221v1（**缩写未被论文自证**，中） | **×** 文档/上下文在推理时一次性编译 | **×** buffer tokens 以 KV 形式入上下文 | **✓** KL 对 full-context teacher | n/a |

一句话：**三者判据互不相同，现在那一行必须拆成三行。** REMORY 是 A∧C 但没有 B 的第三个例子，而且它的 A 就发生在 compaction boundary 本身。

---

## 1. 身份确认

### 1.1 REMORY — 确证（置信度：高）

- 标题：*REMORY: Learning Residual Memory for Context Compaction*
- arXiv：[2610.11287](https://arxiv.org/abs/2610.11287)（v1 2026-10-08，v3 2026-10-21；核查用 v3）
- 第一作者：**Hanchen Xia**（Fudan University / Shanghai Academy of AI for Science；通讯作者之一）；其余：Baoyou Chen, Yutang Ge, Naihao Deng, Senqiao Yang, Zilong Dong, Weihao Yuan, Siyu Zhu
- 年份：2026
- 自证原句："We introduce Remory, a neural memory network that supplements the summary with a bounded sequence of soft memory tokens."（v3 Abstract）

### 1.2 LCLM — 确证（置信度：高）

- 标题：*End-to-End Context Compression at Scale*
- arXiv：[2606.09659](https://arxiv.org/abs/2606.09659)（v1 2026-06-08，v2 2026-10-18；核查用 v2）
- 第一作者：**Ang Li**（NYU；与 Sean McLeish、Haozhe Chen 共同一作）
- 年份：2026
- **缩写由论文自己给出**："We introduce Latent Context Language Models (**LCLMs**), a family of compressors that improve the Pareto frontier across general-task performance, compression speed, and peak memory usage."（v2 Abstract）
- 旁证：代码 `github.com/LeonLixyz/LCLM`；模型 `huggingface.co/latent-context/0.6b-4b-LCLM-{4x,8x,16x}`。
- 结论：**LCLM = Latent Context Language Models = 2606.09659**，这一点不需要猜。

### 1.3 LCC — 只能"推定"，不能确证（置信度：中）

- 候选实体：*Latent Context Compilation: Distilling Long Context into Compact Portable Memory*
  - arXiv：[2602.21221](https://arxiv.org/abs/2602.21221)（v1 2026-01-31，仅一版）
  - 第一作者：**Zeju Li**（CUHK + ByteDance）；Yizhou Zhou, Qiang Xu
  - 年份：2026
- **但缩写 LCC 不是这篇论文自己用的**：全文（含附录、参考文献）检索 `LCC` → **0 命中**；论文始终写全称 "Latent Context Compilation"。
- 我也在 arXiv 全库做了反向检索，确认没有另一篇在本领域内自称 LCC 的论文：
  - `ti:"LCC"` → 全部是 LCC-HVDC 电网、LCC 纠错码、Shell-LCC 等无关领域；唯一沾边的是 `LCC-LLM`（恶意软件归因，2605.05807），与上下文压缩无关。
  - `abs:"LCC" AND abs:"context"/"memory"/"compression"` → 无上下文压缩/记忆方向的命中。
  - `ti:"latent context compression"` → 0 命中（所以 LCC 也不像 "Latent Context Compression" 的缩写）。
  - 同缩写的其他东西（都要排除）：LCC-HVDC（电网换相换流器）、LCC（局部可校正码，TCS）、"Linguistic Completeness Conjecture"（Zenodo 语言学预印本）、PyPI `local-context-compiler`（工具，不是论文）。
- **结论：LCC 在本领域没有可自证的论文实体。** 按首字母 + 主题，唯一合理候选是 2602.21221；下文 §3.3 的表**只在这个前提下成立**。若我方的 LCC 另有所指（记忆有误或社区简称），**请留空，不要用 2602.21221 顶替**——这条我按你的硬性要求只做到"给出候选 + 标注未证实"。

---

## 2. 判据：逐条 + 原句

### 2.1 REMORY（2610.11287v3）

| 判据 | 判定 | 依据原句（arXiv:2610.11287v3） |
|---|---|---|
| **A 写点在边界** | **✓** | §2.1："At **compaction boundary** $i$, $H_i$ contains the previous summary and residual memory, when present, together with the interaction since the last boundary. Given the new summary $S_i$, the memory network constructs $M_i=\mathcal{C}_\phi(H_i;S_i)$." <br>§1："Long-horizon agents compact their history to continue within a finite context window… Input length follows a sawtooth pattern: it grows with interaction, **drops at compaction**, and grows again." <br>§1 把写点直接挂在 `/compact` 上："popular coding agents such as Claude Code and Codex CLI provide `/compact` to free context space." <br>§3.2："The intervention adds up to 4,096 residual slots **at compaction**." |
| **B 载体是参数** | **×** | §2.1："$M_i$ is **a sequence of vectors in the frozen actor's input space**. The concatenation $[S_i;M_i]$ forms an analogue of a residual connection along the sequence dimension." / "The tokens are conditioned on the summary and **appended after it**." / "Their output is **continuous memory rather than vocabulary tokens**." / "Gradients through the **frozen actor** train this interface **without changing the actor's parameters**." |
| **C 监督是分布蒸馏** | **✓** | §2.2 Eq.(2)(3)："$p_j=p_\theta(\cdot\mid C_{\mathrm{full}},y_{<j}),\ q_j=p_\theta(\cdot\mid C_{\mathrm{mem}},y_{<j})$ … We optimize the memory parameters through **student-to-teacher reverse KL**: $\mathcal{L}(\phi)=\sum_j w_j D_{\mathrm{KL}}(q_j\Vert p_j)/\sum_j w_j$." 且 "The loss covers the **full vocabulary** and complete response"、"Only $\phi$ is updated." |
| **A′ 生命周期**（A 成立，故有定义） | **部分 ✓ / Δ≠0** | 会话局部：$M_i=\mathcal{C}_\phi(H_i;S_i)$ 以本条会话的历史为条件；用完即弃：下一边界把旧记忆当作输入重新压（"$H_i$ contains the previous summary and residual memory … since the last boundary"）。**逐位回原不成立**：§2.2 "Memory may overlap with summary content; **it need not reconstruct every omitted fact**." 精确记录只能走外部工具：§1 "**Exact records remain accessible through ordinary archive and file-retrieval tools**." |

**两点要点（防止再误判）**
1. REMORY 新训练了一个 1.94B / 1.502B 参数的 memory network，**训练确实改了参数**，但那是压缩器（reader-side encoder），历史本身仍以 soft token 形式留在序列里 → **B=×，不受"训练改参数"影响**。
2. 论文未给出具体触发阈值（多少 token 触发 compact），只说由 CLI harness 的 `/compact` 策略驱动（§3.2 "compaction policy fixed"）。所以 A 的判定基于"写在 compaction 这一刻"，而不是基于任何数值阈值；若要主张"满窗自动触发"，需另查 Codex CLI 文档，论文内无此句。

### 2.2 LCLM（2606.09659v2）

| 判据 | 判定 | 依据原句（arXiv:2606.09659v2） |
|---|---|---|
| **A 写点在边界** | **×** | 主用法是**摊销式输入压缩**，不是"历史即将被丢弃"：§3 "An LCLM consists of an encoder with a pooling method that maps token chunks to soft tokens, an adapter …, and a decoder that consumes the soft tokens as latent context. Given a sequence of input tokens $x_{1:T}$ and a compression ratio $N$, **the encoder maps each contiguous block of $N$ input tokens to a single latent token**."（压缩发生在 prefill 前，与窗口是否将满无关）<br>次用法（§7.2 online latent compaction）是**固定 token 数日程**，不是边界事件："**After the first 768 generated tokens**, we encode the oldest 512 generated tokens into latent memory tokens … and the procedure **repeats after every further 512 generated tokens**. **Earlier latent blocks are reused thereafter.**"（Fig. 7 图注："**every 512 uncompressed tokens** are encoded into 32 latent tokens"）<br>且它是在窗口远未写满时就做裁剪：§7.2 "no compacted trajectory exceeds **4,135 tokens**"（上限 32,768）。 |
| **B 载体是参数** | **×** | §3：decoder "consumes **the soft tokens as latent context**"；"the decoder then consumes these projected latent tokens **in place of the corresponding input tokens**"。注意 Stage 2/3 解冻了 decoder（"We unfreeze the decoder with a small learning rate"）——**训练改了参数，但推理时历史不在参数里**，按定义 B=×。 |
| **C 监督是分布蒸馏** | **×** | §4.1："We then compute the **next-token prediction loss** on the uncompressed tokens only."；SFT 是"**supervised fine-tuning** on compressed inputs"；辅助重建是**文本目标 SFT**："we compress the text and **ask the model to repeat the original content**"（§4.1 Auxiliary reconstruction data）。<br>全文本地检索：`Kullback` 0 次、`\bKL\b` 0 次、`divergence` 0 次、`soft target` 0 次、`reverse KL` 0 次 → 无任何分布匹配/教师 logits 监督。 |
| **A′ 生命周期** | **n/a**（A 不成立） | — |

补充（对我方叙事有用）：§7.2 结尾把"扩展到 agent 的工具观测与累积工作历史"列为 future work："Another promising direction is to **extend online latent compaction beyond chain-of-thought to tool observations and an agent's accumulated working history**"——即它的在线压缩是 CoT 场景，不是 agent 历史被销毁的那一刻。

### 2.3 LCC（推定 = 2602.21221v1）

> 前提：LCC 指 Latent Context Compilation。若我方含义不同，本表作废（见 §1.3）。

| 判据 | 判定 | 依据原句（arXiv:2602.21221v1） |
|---|---|---|
| **A 写点在边界** | **×** | 写点是"对一段上下文做一次编译"，不是销毁边界：§3 "a framework designed to distill a long context $C$ into a compact sequence of buffer tokens $T_{buf}$ **at inference time**."；§3.5 "Upon convergence, we perform a final forward pass to compute the KV cache for $T_{buf}$. The LoRA module $\phi$ is then discarded."；附录 E "Once compiled, the heavy raw context $C$ is **permanently replaced** by the compact buffer tokens."（写入触发 = 编译一个文档，与窗口满/evict 无关） |
| **B 载体是参数** | **×** | §1 Table 1 自己把它归为 "Inference Dependency = **Buffer Tokens (KV Cache Only)**"、"Frozen Parameter ✓"；Fig. 1 "The resulting **Buffer Tokens are retained as a standard KV cache**"；Abstract "decoupling memory density from **model parameters**"。它明确把"参数承载"当作要避免的对照（TTA/TTT 一栏）。注意：LoRA 只在编译期存在、之后丢弃 → **训练改过参数 ≠ B**。 |
| **C 监督是分布蒸馏** | **✓** | §3.1 Eq.(2)：$\min_{T_{buf}}\mathcal{L}=\mathbb{E}_{x\sim\mathcal{D}_{query}}\left[D_{\mathrm{KL}}\left(P_\theta(\cdot\mid C,x)\parallel P_\theta(\cdot\mid T_{buf},x)\right)\right]$；Fig. 1 "The model **minimizes KL divergence against a full-context teacher**"；Eq.(3)(4) 的 $\mathcal{L}_{reg}$、$\mathcal{L}_{recon}$ 也都是对 frozen teacher 的 KL（"We utilize the **frozen base model as a teacher to generate soft labels**"）；§4.6 还做了 KL vs MSE 消融（"the unequivocal superiority of **probabilistic distillation**"）。 |
| **A′ 生命周期** | **n/a**（A 不成立） | 附注：该文恰好是 A′ 的反面——"**stateless, portable** memory artifacts"、"**permanently replaced**"，既非会话局部也非可回原。若要写脚注可以用这句话，但 A′ 列按你的规则仍是 n/a。 |

---

## 3. 可直接粘进 LaTeX 的建议

### 3.1 首选：拆成三行（严格按现有列宽，可整块替换现第 286 行）

```latex
REMORY & \checkmark\ at the compaction boundary & $\times$ soft memory tokens in sequence & \checkmark\ distribution distillation (reverse KL, frozen teacher) & $\times$ $\Delta{\neq}0$: session-local, rewritten at each boundary & trains the reader, not the carrier \\
LCLM & $\times$ amortized prefill compression & $\times$ latent soft tokens in sequence & $\times$ token-level CE $+$ text-target reconstruction & n/a & spatial \\
LCC & $\times$ one-shot compile of a context, at inference & $\times$ buffer tokens (KV) in sequence & \checkmark\ KL to a full-context teacher & n/a & write point \\
```

（`LCC` 一行仅在 §1.3 的前提成立时使用；否则删掉该行，留空。）

### 3.2 如果一定只留一行（不推荐，但可辩护）

```latex
REMORY / LCLM / LCC & --- & $\times$ soft tokens / latent KV in sequence & --- & --- & token side \\
```

说明：三者唯一共同点是 **B=×**。A 与 C 必须留 `---`（不是 `—` 的"无判定"意思也不是"不满足"）；**A′ 不能写 `n/a`**，因为 REMORY 的 A 成立、A′ 有定义，只有 LCLM/LCC 才是 n/a——一行里写 `n/a` 会变成对 REMORY 的事实错误。

---

## 4. 拆行建议（哪几个能合、哪几个必须单列）

1. **REMORY 必须单列，或并入「LOHA/ACD」那一行**：三者的 A/B/C 剖面**完全同型**（A=✓、B=×、C=✓）。
   - 若要合并，行名写 `LOHA/ACD / REMORY`，A 列写 `\checkmark\ at the window / compaction boundary`。
   - 但注意 A′ 列现在那行是 `n/a`，**和 A=✓ 自相矛盾**（§2.1 说"A′ 只在 A 成立时有定义"，LOHA/ACD 满足 A，就不该是 n/a）。合并后建议统一改为 `$\times$ $\Delta{\neq}0$`。这一步会牵动另一行，我不在本次只读任务里改。
   - **推荐：单列**。理由：REMORY 的写点是**文本摘要式 compaction 边界**（summary 取代历史），与 LOHA/ACD 的"窗口边界"虽同属 (A)，但在我们的论证里更贴题，单列更有说服力。
2. **LCLM 必须单列**：A=×、B=×、C=×（全否），与现表任何一行都不同型。可归入一个"摊销式 soft-token 压缩"小类（AutoCompressor / Gist / ICAE 一类，目前表里没有这些例子），`Reading` 用 `spatial`。
3. **LCC 必须单列**：A=×、B=×、**C=✓**。它和 `Doc-to-LoRA` 只差 B（Doc-to-LoRA 是 B=✓），和 `Still/RestoreKV/...` 只差 C，和 `RLM/StateLM/...` 只差 C——所以不能并进任何现成行。
4. 结论：**现在的 `REMORY / LCLM / LCC` 一行三拆，一行都不能省**；LCLM 与 LCC 不能合（C 相反），REMORY 与 LCLM/LCC 不能合（A、C 都不同）。

---

## 5. 对论文正文的连带影响（供你决定改不改，我没有改）

- 表注现在写 "Text compression triggered at the window boundary (LOHA/ACD) also satisfies (A) but not (B)…"。REMORY 把这句话**加强**了一个档：不仅窗口边界，**连 compaction boundary（历史被摘要取代的那一刻）也能在 A∧C 下由 soft token 承载**。也就是说 (A) 不区分参数/软 token，这一点在"最贴我方写点"的边界上同样成立，而不是只在 LOHA/ACD 的窗口边界成立。
- 相应地，正文 §2.1 的"本工作特异性 = (A)∧(B)∧(C) 在 compaction boundary 的合取"**结论不变**（三者 B 全是 ×），但"最近的邻居"集合要加一个 REMORY——它恰好是"在 compaction boundary 上做分布蒸馏，但写的是 soft token 而不是参数"，是最干净的"只差 (B)"对照。这是支持性证据，不是威胁，但**必须主动写出来**，否则审稿人会问。
- §3.2 的 "Keeping History on the Token Side" 已引 REMORY（"REMORY uses bounded soft memory tokens"），措辞与本次核查一致，不需要改；如需补一句，可加"其监督是 reverse KL 的分布蒸馏（2610.11287 §2.2），与 LOHA/ACD 同型"。

---

## 6. 无法确证 / 需另查的项（明确列出）

| 项 | 状态 | 说明 |
|---|---|---|
| **LCC 的缩写归属** | **无法确证** | 2602.21221 全文 0 次 `LCC`；arXiv 全库无本领域自称 LCC 的论文；同缩写还有其他领域含义。**候选是推定，不是证据。** 若我方无法追溯到"当初为什么叫 LCC"，该行应留空或只写全称。 |
| **LCLM 缩写归属** | 已确证 | 论文自证 "Latent Context Language Models (LCLMs)" + 代码库 LCLM。 |
| **REMORY 的触发阈值** | 论文未给 | 只知写点在 `/compact`（compaction boundary）；具体"多少 token 触发"由 CLI harness 决定，论文无该数值（§3.2 只说 "compaction policy fixed"）。不影响 A=✓。 |
| **REMORY 是否"自动 vs 手动"compact** | 论文未明说 | 论文引用 Claude Code / Codex CLI 的 `/compact` 作为现状；未声明实验中是自动满窗触发还是手动。若正文需要写"自动"，**需读 Codex CLI 文档，不能引用本文**。 |
| **LCC 的 A′** | 定义上不存在 | A=×，按 §2.1 规则写 n/a；但其"stateless/portable/permanently replaced"是 A′ 的反面，只能作脚注，不能填进 A′ 列。 |
| **REMORY 的 Δ=0** | 确证为"不成立" | "it need not reconstruct every omitted fact" + 精确记录靠外部 archive/retrieval。所以 A′ 不能打 ✓。 |

---

## 附：核查所用 URL

- REMORY: https://arxiv.org/abs/2610.11287 ／ 全文 https://arxiv.org/html/2610.11287v3
- LCLM: https://arxiv.org/abs/2606.09659 ／ 全文 https://arxiv.org/html/2606.09659v2
- LCC（推定）: https://arxiv.org/abs/2602.21221 ／ 全文 https://arxiv.org/html/2602.21221v1
