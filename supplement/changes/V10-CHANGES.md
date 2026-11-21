# v10 — five attachments fixed, three of my own findings retracted

Standard used: **a reader who recomputes or checks the statement gets a different answer**. Not "the sentence
is not a theorem". Under that standard, 11 candidate defects became 5.

## Changed

| # | where | was | is | evidence |
|---|---|---|---|---|
| A2 | §1.1 | `three orders larger` | `more than two orders larger` | 125 MB / 375 KB = 333× = **2.52** orders; also holds at the 74 KB end (3.2), so the replacement is a lower bound |
| A6 | App. A "Write budget" | `the value-position top-1 … moves from 0.32` | `the trained-wordings value-position top-1 … moves from 0.32` | the r-star report's table has separate columns: 训练措辞 0.32 / 换问法 0.20 / 40 题 0.220, and its own note says the two evaluations have different denominators. The next sentence quotes the 40-question 0.220; without the label the paragraph looks self-contradictory |
| A7 | §1.4, §3.3 | `the smallest and most auditable carrier/option` | `the most auditable carrier/option` | the paper scanned **rank 16** = 1,441,792 parameters (实验结论.md L9: 27.90% → 20.03%), smaller than the shipped 5,767,168 |
| A8 | App. A "Crossing", Table 9 cell, §6.2 | `The same bracket logic places the crossing at … two to five times` | `A log-r interpolation between the same two sampled endpoints places … The sampled bracket is wider: it spans the 512- and 1024-token budgets, two to eight times` | §5.2 says `we do not interpolate a single value`; 5.5/6.8/5.85 are log-r interpolations from `rd_2304` alone; the sampled bracket is r∈[3.52,7.22] = 512–1024 tokens = 2–8× of 128–256. §6.2 and Table 9 now say the same thing, so the three places agree |
| A10 | App. A "Coverage" | `Cost of the second: 173 s … 224 s` | `Adding those 24 probes cost 173 s … 224 s` | no artifact records these seconds; the only two sources call them the incremental cost of the 24 added probes |

## Retracted — these were my errors, not the paper's

| # | why it is not a defect |
|---|---|
| **A1** (2,304 updates) | The sentence is the **counterfactual cost of the 9B recipe at 27B**, and the next sentence says `ran the saturated regime once, on Qwen3.5-9B with its own history, question pool and summary method`. The cost argument does not depend on the number. |
| **A3** (`undetectable on SR → SRD`) | **It was measured.** 实验结论.md L9: `SRD 为 17.63% vs 17.44%，差区间跨零` — a rank-16 SRD arm exists and its paired interval crosses zero. The sentence is exactly right. I had searched `.local-8b` only and concluded "no arm exists"; the run ledger is in the two reports, not in the json. |
| **A4** (§6.1(2) template) | I judged it from three data lines of a report whose header I never read. The paper says *all four arms* took the template; if SR/SRD are among them, "moves the floor rather than the ordering" is a valid inference and my deletion would have removed a working defence. |

Demoted to "wording, not error": **A5** (`not a property of the carrier` — §6.1(3)'s rank is a different knob from
"how much was written") and **A9** (the interval's numbers are right; only the scheme's name differs from the
artifact field name).

## The process error worth recording

Three of eleven came from trusting an subagent's artifact walk over the two documents that are the **run ledger**
(`实验结论.md`, `r-star及后续实验阶段报告-2026-10-26.md`). Every "does this experiment exist?" question must be
answered there first, and only then in `.local-8b/*.json`.

## Build

13 pages, exit 0, 0 undefined, 0 `??`. The two overfull `\hbox` (7.96 pt §3.1, 4.59 pt bibliography) are
unchanged from v6–v9; no `\vbox` warning.

Hashes: v10 tex `C5F7C192…`, pdf `A72C1D98…`; v9 tex `720741F9…`.