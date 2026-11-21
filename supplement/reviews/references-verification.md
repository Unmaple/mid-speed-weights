# references 核实表 — `paper-fse-v1.tex` 的 35 条 BibTeX 条目

核实日期：**2026-10-26**。产物：`references.bib`（35 条，键名 = 正文 35 个 `\cite` 键），
`paper-fse-v1.tex` 已从手写 `thebibliography` 切到 `\bibliographystyle{ACM-Reference-Format}` +
`\bibliography{references}`。

**计数：已核实 32 / 部分核实 3 / `Title unverified` 0 / 缺字段 3（缺的是 3 条会议论文的页码）。**

状态定义：

- **已核实**：标题、作者、年份、卷期页（或会议名 + 页码）都能在同一份机器可读记录里对上。
- **部分核实**：条目本身的元数据已核实，但**正文用的短名 / 键名口径**与记录对不上（`LOHA`、`TMEM`、
  `qwen38…` 的"技术报告"口径）。标题有据，所以不标 `Title unverified`。
- **`Title unverified`**：本轮 **0 条**。上一轮手写版里有 19 条 `% title unverified` 的短名条目
  （"Still."、"MiCA."、"TMEM." 之类），本轮把 26 个 arXiv 号一次性送进 arXiv Atom API
  （`https://export.arxiv.org/api/query?id_list=…`，26/26 命中）全部取到真实标题与作者，因此这个标记已经
  没有存在理由。**规则不变**：以后新增的、查不到标题的条目，保留 arXiv 号 + `note = {Title unverified}`，
  不许编标题。

核实手段（全部为 2026-10-26 现场取数，没有一条元数据凭记忆填）：arXiv Atom API、
Crossref REST API（`api.crossref.org/works/<doi>`）、Europe PMC REST、CVF 开放获取页、
NeurIPS virtual 页（含其 JSON-LD）、ICLR 2024 接收列表、genome.gov / huggingface.co 页面本身。

---

## 1. 逐条核实表

"新编号"= 本轮 BibTeX 之后的 `[n]`；"旧编号"= 手写 `thebibliography` 里的 `\bibitem` 序号。

| 新 | 旧 | 键名 | 状态 | 核实来源 | 本轮补 / 改 |
|---|--:|------|------|----------|------------|
| 17 | 1 | `landauer1986` | 已核实 | <https://doi.org/10.1207/s15516709cog1004_4> | 作者改为姓在前 + 名首字母；标题大小写按记录 |
| 24 | 2 | `schlag2021` | 已核实（**编号纠错**） | <https://arxiv.org/abs/2102.11174> | arXiv 号 **2102.08442 → 2102.11174**（原号是无关论文 SCAPE） |
| 25 | 3 | `shannon1951` | 已核实 | <https://doi.org/10.1002/j.1538-7305.1951.tb01366.x> | 30(1):50–64、DOI |
| 9 | 4 | `deletang2024` | 已核实 | arXiv 2309.10668 + ICLR 2024 接收列表（<https://iclr.cc/virtual/2024/papers.html>，poster 17997） | 12 位作者；会场从"草稿声称"升级为已核实 |
| 27 | 5 | `snell2022` | 已核实 | <https://arxiv.org/abs/2209.15189> | 三位作者全名 |
| 26 | 6 | `shumailov2024` | 已核实 | <https://doi.org/10.1038/s41586-024-07566-y> | 6 位作者、期号 8022、DOI |
| 31 | 7 | `mita2026` | 已核实 | <https://arxiv.org/abs/2602.01219> | 真标题 *Mixture-of-Top-$k$ Attention: Efficient Attention via Scalable Fast Weights*（手写版只有 "MiTA"）；Venue 取 arXiv comment 的 "NeurIPS 2026" |
| 19 | 8 | `still2026` | 已核实 | <https://arxiv.org/abs/2606.07878> | 真标题 *Still: Amortized KV Cache Compaction in a Single Forward Pass* + 5 位作者（手写版只有 "Still."） |
| 2 | 9 | `restorekv2026` | 已核实 | <https://arxiv.org/abs/2608.01247> | 真标题 + 3 位作者 |
| 11 | 10 | `cartridges2025` | 已核实 | <https://arxiv.org/abs/2506.06266> | 真标题 + 11 位作者 |
| 14 | 11 | `cartridges_scale2026` | 已核实 | <https://arxiv.org/abs/2606.04557> | 真标题 + 3 位作者 |
| 35 | 12 | `loha2026` | **已核实** | <https://arxiv.org/abs/2609.31430> | 真标题 *Compress What You See, Not What You Say: Anchored Context Distillation for Latent-Observation Software Engineering Agents*，Zhensheng Zou / Guoqing Wang / Dan Hao（PKU）。**"LOHA" 已在摘要中确证**：*"we combine Latent Observations, Hard Actions (LOHA), a context layout …, with Anchored Context Distillation (ACD), a training method"* —— LOHA 是布局，ACD 是训练法，同属一篇，正文写 "LOHA/ACD" 正确 |
| 32 | 13 | `remory2026` | 已核实 | <https://arxiv.org/abs/2610.11287> | 真标题 + 8 位作者 |
| 3 | 14 | `doclive2026` | 已核实 | <https://arxiv.org/abs/2609.17346> | 真标题 + 4 位作者（含 `de Gispert` 复姓写法） |
| 7 | 15 | `overridegap2026` | 已核实 | <https://arxiv.org/abs/2604.23750> | 真标题 + 4 位作者 |
| 12 | 16 | `evaf2026` | 已核实 | <https://arxiv.org/abs/2606.29916> | 真标题 + 单作者 Han, H. |
| 34 | 17 | `rpmem2026` | 已核实 | <https://arxiv.org/abs/2609.23466> | 真标题 + 9 位作者 |
| 6 | 18 | `dppm2026` | 已核实 | <https://arxiv.org/abs/2610.11776> | 真标题 + 10 位作者 |
| 23 | 19 | `tmem2026` | **已核实** | <https://arxiv.org/abs/2606.04536> | 真标题 *Scaling Self-Evolving Agents via Parametric Memory*，Tao Ren 等 11 位作者。**"TMEM" 已确证在摘要中**：*"We introduce \texttt{TMEM}, a self-evolving parametric memory framework in which the agent not only compresses history into explicit memory but also absorbs distilled supervision into fast LoRA weights $\Delta_t$…"* —— TMEM 是作者自命名，正文直接用 TMEM 正确 |
| 10 | 20 | `doctoatom2026` | 已核实 | <https://arxiv.org/abs/2606.12400> | 真标题 + 6 位作者 |
| 4 | 21 | `doctolora2026` | 已核实 | <https://arxiv.org/abs/2602.15902> | 真标题 + 4 位作者 |
| 29 | 22 | `compacttheory2026` | 已核实 | <https://arxiv.org/abs/2608.01326> | 真标题 + 4 位作者 + `primaryClass=cs.DS` |
| 30 | 23 | `lostincompact2026` | 已核实 | <https://arxiv.org/abs/2608.11242> | 真标题 + 5 位作者 |
| 13 | 24 | `memdepth2026` | 已核实 | <https://arxiv.org/abs/2606.26806> | 真标题 + 单作者 Han, H. |
| 5 | 25 | `collapse2026` | 已核实（**标题纠错**） | <https://arxiv.org/abs/2606.04703> | 标题 = *Rethinking Continual Experience Internalization for Self-Evolving LLM Agents*（手写版的 "Progressive capability collapse…" 是转述，已弃用）+ 10 位作者 |
| 28 | 26 | `tavor2026` | 已核实 | <https://arxiv.org/abs/2602.01395> | 4 位作者全名（原来只写 "Tavor et al."） |
| 15 | 27 | `selectkd2026` | 已核实 | CVF 页 <https://openaccess.thecvf.com/content/CVPR2026/html/Huang_SelecTKD_…_CVPR_2026_paper.html>（页面 papertitle / authors / "CVPR 2026, pp. 19287-19297"） | 4 位作者、**页码 19287–19297**、ePrint 2510.24021 |
| 16 | 28 | `maxdiv2026` | 已核实 | <https://neurips.cc/virtual/2026/loc/sydney/poster/155838>（其 JSON-LD 的 author 数组） | 8 位作者全名（原来无作者）、NeurIPS 2026 |
| 21 | 29 | `adaptivekd2025` | 已核实（**年份纠错**） | <https://doi.org/10.1007/978-981-97-8502-5_15> | Crossref：LNCS 章节、**2024**（不是 2025）、200–214、Springer。键名保留 `2025` 以免动正文 |
| 18 | 30 | `genome` | 已核实 | <https://www.genome.gov/about-genomics/educational-resources/fact-sheets/human-genome-project>（HTTP 200，`<title>` = "Human Genome Project Fact Sheet"） | 作者 = National Human Genome Research Institute（原来只写 "NHGRI"）+ 访问日期 |
| 20 | 31 | `brain` | 已核实（**来源纠错**） | <https://doi.org/10.1016/S0531-5565(02)00151-1> + Europe PMC 作者表 | 改为 **Pakkenberg et al. 2003, Exp. Gerontol. 38(1–2):95–99**（突触数这条的真实原始来源，7 位作者全名）。上一轮 bib 把这条做成了 BioNumbers BNID 112056 的网页条目 |
| 1 | 32 | `azevedo2009` | 已核实（**拆条**） | <https://doi.org/10.1002/cne.21974> | 9 位作者、J. Comp. Neurol. 513(5):532–541。神经元数 8.6×10¹¹ 归这条，与 `brain` 分开（正文本来就已经分开引） |
| 33 | 33 | `qwen3report2025` | 已核实 | <https://arxiv.org/abs/2505.09388> | arXiv 列 60 位作者，取前 6 位 + `and others`；`primaryClass=cs.CL` |
| 22 | 34 | `qwen38report2026` | **部分核实** | <https://huggingface.co/Qwen/Qwen3.8-27B>（HTTP 200，页面即模型卡） | 不是技术报告：`@misc` + `howpublished = {Hugging Face}` + 短 note。arXiv 标题检索 `ti:"Qwen3.8"` 只有 Omni / Next-Architecture / FlashNext-RL 等，**没有 27B 技术报告** |
| 8 | 35 | `deepseekv41flash2026` | 已核实 | <https://arxiv.org/abs/2609.19969> | 593 位作者取 `{{DeepSeek-AI} and others}`；`primaryClass=cs.CL` |

### 缺字段的 3 条（都是页码，不是标题/作者）

| 键名 | 缺什么 | 为什么 |
|------|--------|--------|
| `deletang2024` | 页码 | ICLR 2024 是 OpenReview 论文集，无连续页码；arXiv 记录也没有 journal-ref |
| `mita2026` | 页码 | 只有 arXiv comment 里的 "NeurIPS 2026"，proceedings 尚未给出页码 |
| `maxdiv2026` | 页码 | NeurIPS virtual 页只给 poster 场次，无页码 |

`ACM-Reference-Format` 对 `@inproceedings` 还会要 `publisher`/`address`，本轮**没有填**（不编）。后果只是
BibTeX 打 13 条 `Warning--empty publisher/address/pages`，不进 PDF、不影响编号（见 §4）。

---

## 2. 手写版里被纠正的 7 处（正文措辞未动，只动参考文献）

| # | 键名 | 手写版 | 现在（有据） |
|---|------|--------|--------------|
| 1 | `schlag2021` | arXiv:**2102.08442** | **2102.11174**（2102.08442 是 SCAPE，Kim/Niekum/Deshpande, CoRL 2021） |
| 2 | `collapse2026` | *Progressive capability collapse in multi-round experience internalization*（转述） | *Rethinking Continual Experience Internalization for Self-Evolving LLM Agents* |
| 3 | `qwen38report2026` | "Qwen Team. Qwen3.8-27B Technical Report"（不存在） | `@misc` 模型卡，`howpublished = {Hugging Face}` |
| 4 | `adaptivekd2025` | PRCV, LNCS, **2025** | LNCS 章节，**2024**，200–214 |
| 5 | `qwen38report2026` | 无技术报告 | 确认不存在 Qwen3.8-27B 技术报告；已按 **HF 模型卡**入 bib（`@misc` + `howpublished`），正文口径为 "the Qwen line pushes in the same direction"，不声称其为技术报告 |
| 6 | `brain` / `azevedo2009` | 神经元数、突触数都挂在 "B. Pakkenberg et al." 上 | 神经元数 → `azevedo2009`（8.6×10¹¹ 的真实来源）；突触数 → `brain` = Pakkenberg 2003 |
| 7 | 19 条短名条目 | "Still."、"RestoreKV."、"EVAF." … + `% title unverified` | 全部换成 arXiv 记录里的真标题与真作者 |

---

## 3. `\bibliographystyle`：选了 `ACM-Reference-Format`（没有退回 `plainnat`/`unsrtnat`）

- **可用性已实测**：`tools/tectonic/cache` 的 bundle 里有它。证据是编译产物 `.blg` 的
  `The style file: ACM-Reference-Format.bst`，以及 `.bbl` 头
  `%%% File created by BibTeX with style ACM-Reference-Format-Journals [18-Jan-2012]`。
- **它是 acmart 的官方样式**：论文本来就是 `\documentclass[sigconf,nonacm]{acmart}`，ACM 投稿要求
  参考文献用这一样式，所以不需要退而用 `plainnat` / `unsrtnat`。
- **一个副作用要知道**：该样式按**作者字母序**排条目，所以 `[n]` 不再等于正文出现顺序
  （第一处引用 `\cite{schlag2021}` 现在是 **[24]**，见 §5）。这是 ACM 格式本身的行为，不是错。
- **如果你更想要"按出现顺序编号"**：把 `paper-fse-v1.tex` 里 `\end{document}` 前那行
  `\bibliographystyle{ACM-Reference-Format}` 换成 `\bibliographystyle{unsrtnat}`
  （acmart 已自动载入 natbib，`.bst` 也在 bundle 里），其余不动，重编即可。

正文 `\cite{...}` 的 **35 个键一个都没改**。

---

## 4. 编译验证

命令（`TECTONIC_CACHE_DIR` 必须先设，否则 panic/exit 101）：

```powershell
$env:TECTONIC_CACHE_DIR = 'E:\MasterStudy\AdVance ComPact\tools\tectonic\cache'
.\tools\tectonic\tectonic.exe -r 3 paper-fse-v1.tex
```

| 检查项 | 结果 |
|--------|------|
| Tectonic 退出码 | **0** |
| BibTeX 是否被自动调用 | 是（`note: Running BibTeX on paper-fse-v1.aux ...`） |
| 使用的 `.bst` | `ACM-Reference-Format.bst`（`.blg` 第 4 行） |
| undefined citation | **0**（`.log` 里没有任何 `Citation ... undefined` / `LaTeX Warning`） |
| `.bbl` 里 `\bibitem` 数 | **35** |
| `.aux` 里 `\bibcite` 数 | **35** |
| 被引键集合 vs bib 条目集合 | 差集为空（无缺、无多余、无重复）；正文 44 次 `\cite` 命中 35 个不同键 |
| PDF 里 `[1]`…`[35]` | 35 个编号全部出现，`REFERENCES` 标题正常 |
| PDF 里的 `?` | 全是正文疑问句标点，**没有一个是缺引用占位符** |
| BibTeX 警告 | 13 条，全是 `@inproceedings` 的 `empty publisher/address/pages`（见 §1 末），不进 PDF |
| Overfull `\hbox` | **30**；同一正文版本下切换前也是 27 → 切换后 27（逐条宽度相同），另外 3 处来自这段时间正文新增的段落 |
| 最严重 Overfull | **49.12 pt**，正文 "Three Explanations…" 一节的数学/百分比串（当前版本 `paper-fse-v1.tex:593–597`），**切换前后同一处** |
| 页数 | 见下（与正文篇幅绑定，不是参考文献格式引起的独立变量） |

### 页数：切换本身多占约 0.5 栏，够不够多出一页取决于正文

同一份正文做 A/B（只换参考文献块，其余字节不动）：

| 正文版本 | 手写 `thebibliography` | ACM BibTeX | 差 |
|---|---|---|---|
| 切换时的 7 页正文（628 行） | 7 页 | **7 页** | 0 |
| 之后被别人加过正文的 646 行版本 | 7 页（参考文献占 p7 左栏下部 + 右栏上部 ≈1.7 栏） | **8 页**（p7 两栏 + p8 顶部 12 条 ≈2.2 栏） | +0.5 栏 ≈ +0.27 页 |

原因很直接：ACM 样式会排全作者、全标题、DOI 和 `arXiv:… [class]`，手写版用的是 "et al." + 短文摘。
把 `\bibsep` 压到 0 也只省几行，实测仍 8 页（`tools/tectonic/work/ab-bibsep/`）。

如果必须回到 7 页，可选项（按侵入性排序）：① ACM 通常允许参考文献不计入页数限制，直接接受 8 页；
② 在 `references.bib` 里把作者数 >6 的条目截成前 6 位 + `and others`（ACM 印 "et al."）；
③ 压正文（超出本次改动边界，未动）。

---

## 5. 新编号映射（键名 → `[n]`）

旧编号 = 手写 `thebibliography` 的顺序（1…35）。

| 新 `[n]` | 键名 | 旧 `[n]` |
|--:|------|--:|
| 1 | `azevedo2009` | 32 |
| 2 | `restorekv2026` | 9 |
| 3 | `doclive2026` | 14 |
| 4 | `doctolora2026` | 21 |
| 5 | `collapse2026` | 25 |
| 6 | `dppm2026` | 18 |
| 7 | `overridegap2026` | 15 |
| 8 | `deepseekv41flash2026` | 35 |
| 9 | `deletang2024` | 4 |
| 10 | `doctoatom2026` | 20 |
| 11 | `cartridges2025` | 10 |
| 12 | `evaf2026` | 16 |
| 13 | `memdepth2026` | 24 |
| 14 | `cartridges_scale2026` | 11 |
| 15 | `selectkd2026` | 27 |
| 16 | `maxdiv2026` | 28 |
| 17 | `landauer1986` | 1 |
| 18 | `genome` | 30 |
| 19 | `still2026` | 8 |
| 20 | `brain` | 31 |
| 21 | `adaptivekd2025` | 29 |
| 22 | `qwen38report2026` | 34 |
| 23 | `tmem2026` | 19 |
| 24 | `schlag2021` | 2 |
| 25 | `shannon1951` | 3 |
| 26 | `shumailov2024` | 6 |
| 27 | `snell2022` | 5 |
| 28 | `tavor2026` | 26 |
| 29 | `compacttheory2026` | 22 |
| 30 | `lostincompact2026` | 23 |
| 31 | `mita2026` | 7 |
| 32 | `remory2026` | 13 |
| 33 | `qwen3report2025` | 33 |
| 34 | `rpmem2026` | 17 |
| 35 | `loha2026` | 12 |

正文里几处容易被翻旧的引用（已核对 PDF 文本终稿）：

- `\cite{genome}` → **[18]**（"3×10⁹ base pairs [18]"）
- `\cite{azevedo2009}` → **[1]**（"8.6×10¹¹ neurons [1]"）
- `\cite{brain}` → **[20]**（"10¹⁴ synapses [20]"）
- `\cite{qwen3report2025,qwen38report2026}` → **[22, 33]**

---

## 附录 A：Qwen3.8-27B 的 KV 尺寸核对（供 §1.2 用，本轮未改）

### A.1 权威来源（三路互证，全部一致）

1. **`/root/models/qwen38-bf16/config.json`**（`text_config`）：
   `num_hidden_layers=64`、`full_attention_interval=4`、`num_attention_heads=24`、`num_key_value_heads=4`、`head_dim=256`、`hidden_size=5120`、`dtype=("bfloat16")`、`max_position_embeddings=262144`、`mtp_num_hidden_layers=1`；
   `layer_types` 是 64 项数组：**48 个 `linear_attention` + 16 个 `full_attention`**（每个 4 层的第 4 层是全注意力，即 1-based 的 4, 8, 12, …, 64）；
   `linear_*`：`linear_num_key_heads=16`、`linear_num_value_heads=48`、`linear_key_head_dim=128`、`linear_value_head_dim=128`、`linear_conv_kernel_dim=4`、`mamba_ssm_dtype=float32`。
2. **模型卡**（<https://huggingface.co/Qwen/Qwen3.8-27B>）：
   "Number of Layers: 64"；"Hidden Layout: **16 × (3 × (Gated DeltaNet → FFN) → 1 × (Gated Attention → FFN))**"；"Gated Attention: Number of Attention Heads: **24 for Q, 4 for KV**, Head Dimension: **256**, RoPE dim 64"；"Context Length: 262,144 natively, extensible to 1,000,000"。
3. **权重张量头**（`model.safetensors.index.json` + safetensors header，直接读 shape）：
   `layers.3.self_attn.k_proj.weight = [1024, 5120]`（BF16），`v_proj = [1024, 5120]`，`q_proj = [12288, 5120]`。
   **1024 = 4 KV heads × 256 = 实锤的 KV 宽度**；12288 = 24 × 256 × 2（`attn_output_gate` 使 Q 侧翻倍）。`index.json` 里 `self_attn` 只出现在 4,8,…,64 共 **16** 层，`linear_attn` 出现在其余 48 层。

### A.2 推导

每个全注意力层每 token 的 K 和 V 各有 `num_kv_heads × head_dim = 4 × 256 = 1024` 个元素，BF16 = 2 B：

```
单层每 token = 2 (K,V) × 4 heads × 256 dim × 2 B = 4 096 B = 4 KiB
全模型每 token = 4 KiB × 16 层全注意力 = 65 536 B = 64 KiB
```

$$
2 \times 16 \times 4 \times 256 \times 2\ \text{B} = 65\,536\ \text{B} = 64\ \mathrm{KiB/token} \; (= 65.5\ \mathrm{kB/token})
$$

**结论：论文 §1.2 的 64 KiB/token 是对的，不需要改成 72 KiB/token。**

72 KiB 需要 `73728 / 4096 = 18` 个全注意力层，或等价的 KV 宽度。config 只有 16 层（64 层 × 1/4），权重形状也只有 1024 的 KV 宽度——**没有任何来源支持 72**。最接近的"更高"读数是把 MTP 投机解码草稿层（`mtp_num_hidden_layers=1`，`index.json` 里确有 `mtp.layers.0.self_attn.{k,v}_proj = [1024,5120]`）的 KV 也算进去：16 + 1 = 17 层 = **68 KiB/token**，仍不是 72。按 72 KiB 反推会得到 ~163k×72 KiB = 11.2 GiB，也解释不了草稿里的 10.4 GiB。

### A.3 163k / 800k 的常驻量（64 KiB/token，1 GiB = 2³⁰ B）

| 历史长度 | 字节 | GiB (2³⁰) | GB (10⁹) | 草稿写的 |
|---|---|---|---|---|
| 163 000 | 10 682 368 000 | **9.95** | 10.68 | 10.4 GiB ✗ |
| 163 840 (=160 Ki) | 10 737 418 240 | **10.00** | 10.74 | 10.4 GiB ✗ |
| 800 000 | 52 428 800 000 | **48.83** | 52.43 | 49 GiB ✓ |
| 819 200 (=800 Ki) | 53 687 091 200 | **50.00** | 53.69 | 49 GiB ≈ |

- **49 GiB 站得住**（800 000 × 64 KiB = 48.83 GiB）。
- **10.4 GiB 复现不出来**：163k 无论按 163 000 还是 163 840 都得 9.95 / 10.0 GiB；10.4 GiB 对应的是 **170 393** 个 token。（正文现已按 163 840 → 10.0 GiB 写。）

### A.4 另外那笔账：线性注意力状态（不进 per-token 数）

48 个 Gated DeltaNet 层的循环状态是 O(1) 于序列长度，逐层 `48 v-heads × 128 × 128 = 786 432` 元素：
按 `mamba_ssm_dtype=float32` 约 **3 MiB/层 → 144 MiB/序列**（若按 BF16 存则 72 MiB）；再加 conv 状态 `4 × 10 240` 元素/层（BF16 约 80 KiB、FP32 约 160 KiB，48 层合计 3.8 / 7.7 MiB）。
**这笔是常数，不随 token 增长，不要和 64 KiB/token 加在一起。** 正文若要严谨，可写"另有约 0.15 GiB 量级的线性注意力状态，与 n 无关"。

### A.5 公开文档交叉核对

| 来源 | 链接 | 原文数字 | 与 config 是否冲突 |
|---|---|---|---|
| HF 模型卡 Qwen3.8-27B | <https://huggingface.co/Qwen/Qwen3.8-27B> | 64 层；16×(3×GDN+1×Gated Attn)；Q 24 heads / KV 4 heads；head dim 256；原生 262 144 | **不冲突**，逐项一致 |
| Qwen3.8-Next 架构报告 | <https://arxiv.org/abs/2608.30320> | "layer-wise hybrid of Gated DeltaNet (GDN) and global attention, with **one full-attention layer in every four**" | 不冲突（同代同族的层配比）；但它是 125B MoE，不是 27B dense，不能拿来当 27B 的数字 |
| Qwen3 Technical Report | <https://arxiv.org/abs/2505.09388> | 无 27B 的 KV 数（世代较早，架构不同） | 不可用于本条 |
| Qwen3.8-27B Technical Report | **不存在**（arXiv `ti:"Qwen3.8"` 检索无此条） | — | 已在 bib 里改引模型卡 |

**公开文档与 config 没有冲突。** 冲突只存在于"config"和"用户记忆的 72 KiB"之间。

### A.6 一句话结论

> §1.2 的 64 KiB/token 与 `2×16×4×256×2 B` 推导正确，**不要改成 72 KiB**；800k ≈ 49 GiB 保留；163k → 10.0 GiB（按 163 840 算）。72 KiB 需要 18 个全注意力层，config、模型卡、权重形状三处都不支持；若把 MTP 草稿层 KV 也驻留，是 68 KiB。

---

## 附：本轮用到的取数脚本（都在 `tools/tectonic/work/`，可重跑）

| 脚本 | 作用 |
|------|------|
| `fetch_meta.py` | 26 个 arXiv 号批量查 Atom API，落 `arxiv_meta.json` |
| `fetch_crossref.py` | 5 个 DOI 查 Crossref，外加 Pakkenberg 标题检索 |
| `fetch_live.py` / `fetch_extra.py` / `fetch_venue.py` | genome / HF / CVF / NeurIPS / Europe PMC / ICLR 列表现场取数 |
| `switch_to_bibtex.py` | 把 `thebibliography` 块整块换成两行 `\bibliography`（含 35 个 `\bibitem` 计数断言） |
| `check_bib.py` / `aux_map.py` | 键集合自检 + 从 `.aux` 读权威编号 |
| `compare_logs.py` / `overfull_lines.py` / `pdf_entries.py` | 改动前后 Overfull 对比、PDF 条目与 `?` 检查 |
