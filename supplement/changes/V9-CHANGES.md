# v9 — five sentences found by reading the PDF

None of these came from the audit list; they are prose defects visible on the page.

| # | where | change | why |
|---|---|---|---|
| S1 | §6.1(1) | dropped "so this is an absence of a detected effect, not evidence that the teacher is unaffected" | The preceding clause — the interval covers both a small improvement and a small degradation — *is* the self-limitation. Saying it again in the abstract vocabulary of "absence of effect" adds nothing and, worse, invites the reader to admire the caution instead of the number. |
| S2 | §6.3 | dropped "that is a structural argument, not a measurement" | The subsection is titled "An Implication We Have Not Tested". Third statement of the same thing. (This tail was the wording prescribed in the B8 item; it reads as repetition once it is on the page.) |
| S3 | §6.4(7) | "a hypernetwork over the history would amortize them **\cite{doctolora2026}**" | Doc-to-LoRA *is* the hypernetwork that amortises the write; the sentence was making that point without citing the work that makes it. |
| S4 | §7.1 | dropped "which is a comparison of two carriers rather than of a mechanism against its absence" | **False about this paper**: Tables 4 and 5 headline RD against R0 — a carrier against the no-memory baseline, i.e. exactly mechanism-versus-absence. It was also an unverified claim about other people's experiments. The surviving sentence still states the real difference: the trigger, and the swept text budget. |
| S5 | §7.1 → §7.2 | the 46.4% conflict cost moved from the TMEM subsection to the end of §7.1 | It is a reported cost of the Doc-to-LoRA family, which is §7.1's subject. §7.2 argues one thing only (the supervision channel) and now ends on it. |

Net: **−37 words**. No claim changed except S4, which removes a false one.

Build: 13 pages, exit 0, 0 undefined, 0 `??`. The two overfull `\hbox` (7.96 pt §3.1, 4.59 pt bibliography)
are unchanged from v6/v7/v8; the last page is short again, so no `\vbox` warning.

Hashes: v9 tex `720741F9…`, pdf `EED541AA…`; v8 tex `EAAAAF7C…`.