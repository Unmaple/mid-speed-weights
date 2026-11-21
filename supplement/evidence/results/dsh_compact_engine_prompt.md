# `dsh` Compaction Engine Prompt 与压缩机制实录

记录时间：2026-11-17  
提取来源（本机真实 `dsh` 安装包，`@deepseek-ai/dsh-compaction-basic` v`0.1.7-rc.2`）：
- `D:\dsh\node_modules\@deepseek-ai\dsh\node_modules\@deepseek-ai\dsh-compaction-basic\lib\index.js`
- `D:\dsh\node_modules\@deepseek-ai\dsh\node_modules\@deepseek-ai\dsh-compaction\lib\index.js`
- `D:\dsh\node_modules\@deepseek-ai\dsh\node_modules\@deepseek-ai\dsh-compaction-tool-result-pruner\lib\index.js`
- `D:\dsh\node_modules\@deepseek-ai\dsh\node_modules\@deepseek-ai\dsh-command-compact\lib\index.js`

---

## 1. 触发策略与前置裁剪参数

- **自动压缩阈值**（`dsh-compaction-basic/lib/index.js` L15–86, L124–147）：
  - `DEFAULT_THRESHOLD_RATIO = 0.8`（上下文达到模型窗口 80%，且不超过扣减输出预留与 `headroomTokens = 65536` 后的压力上限）
  - `DEFAULT_RETAIN_RATIO = 0.16`（尾部保留最近约 16% 的原始消息不压缩；且 `toolPairingBalancedBefore/After` 保证不截断未闭合的 `tool-call` / `tool-result` 配对）
  - `system/message`（surface node 0）永不被纳入被替换的压缩区间（L401–415）
- **前置确定性 Tool Result 裁剪**（`dsh-compaction-tool-result-pruner/lib/index.js` L8–19）：
  - 不调模型，超过 `thresholdChars = 8192` 的工具返回按首 `headChars = 4096` + `\n\n[... tool result middle pruned ...]\n\n` + 尾 `tailChars = 1024` 确定性截断。

---

## 2. 缓存复用式调用结构（Key Architectural Detail）

见 `buildSummarizationInput`（L683–704）与 `summarizeWithLlm`（L237–311）：
- **不另起系统提示词**，而是完整重放 `system/message` + `header.tools` + 待压缩历史 `regionMessages`，然后把 `COMPACTION_INSTRUCTION` 作为**最后一条 `user` 消息**追加发送（`purpose: "compaction"`），以此直接命中服务端的 KV Prefix Cache。

---

## 3. 原文 Prompt：`COMPACTION_INSTRUCTION`（L243–278）

```text
You are now acting as a compaction engine for this AI coding assistant. Condense the conversation ABOVE into a structured checkpoint that lets another model resume the work with no loss of essential context.

Output EXACTLY the Markdown structure below: keep every section, in order. Use terse bullets, not prose paragraphs. Write "(none)" for an empty section — never drop a section.

## Primary Request and Intent
- [the user's original and evolving goals; quote verbatim where the exact wording matters]

## Key Technical Concepts
- [technologies, frameworks, patterns, and conventions in play]

## Files and Code
- [exact path: why it matters, key changes or snippets]

## Errors and Fixes
- [error: how it was resolved, plus any related user feedback]

## Pending Jobs
- [explicitly requested work not yet completed]

## Current Work
- [precisely what was in progress at this checkpoint]

## Next Step
- [the single next action, directly in line with the most recent request, or "(none)"]

## Critical Context
- [decisions and their rationale, constraints, user preferences, open questions, data needed to continue]

Rules:
- Write concise English engineering prose. Preserve exact file paths, commands, error strings, identifiers, numeric values, function signatures, and syntax fragments.
- Capture user feedback and explicit instructions faithfully, especially corrections.
- Do NOT mention this summarization request or that the context was compacted.
- Output only the checkpoint text: do not call any tool or take any other action.
- If the conversation already contains a <compacted-summary> block, it is a PRIOR checkpoint. Do not copy it forward verbatim: preserve still-true facts, drop stale ones, and merge newer information into a single consolidated summary under the same structure.
```

---

## 4. 替换回对话的 Checkpoint 包装模板（L234–235, L280, L344–356）

摘要生成后，会用一条 `source.kind = "compact-checkpoint"` 的 `user` 消息替换原历史区间，包装前后缀为：

- 前导说明（`CHECKPOINT_PREAMBLE`）：
```text
This is an automatically generated checkpoint condensing an earlier span of the conversation to free up context. Treat the captured context as established background and build on it without restating it. Continue the task directly from the messages that follow, without acknowledging this checkpoint.
```
- 标签包裹（`SUMMARY_OPEN_TAG` / `SUMMARY_CLOSE_TAG`）：
```xml
<compacted-summary>
{summary}
</compacted-summary>
```

---

## 5. 与本仓库 E21 实验的关联说明

- 当前 E21（`e21_dsh_7k`）中的 `summary_only` 对照（[`.local-8b/_e21_dsh_spec.py`](../.local-8b/_e21_dsh_spec.py) 的 `COMPACT_SUMMARY`）为手工编写的理想化压缩摘要，并非调用上述 `COMPACTION_INSTRUCTION` 生成。
- 后续若需把“真实 `dsh` Compaction Engine Prompt 生成的 `<compacted-summary>`”纳入对比，可直接沿用 §3 与 §4 的精确模板对 `FULL_SESSION_DOC` 做一次模型自摘要生成。
