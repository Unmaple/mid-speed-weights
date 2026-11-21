# v7 change log — editorial items B (delete) and C (move)

Input: the B/C list of `paper-fse-v6-review` (line numbers given there are keyed to v5; every
anchor below was re-located by text in v6 before editing).

Rule applied: **no claim and no number changes.** Every deletion was checked against its own
sentence — the main clause must still be true and complete without the deleted part. Every move
preserves the moved text.

| # | Where (v6 line) | Deleted | Resulting sentence | Safe because |
|---|---|---|---|---|
| B1 | 137 (§1.1) | "We do not test this bias hypothesis here." | "…the current instruction simply does not ask for it. That it is not a rhetorical worry is supported by…" | previous sentence already scopes the argument ("not a result of this paper") |
| B2 | 436 (§3.5) | ", and we do not claim they are" | "No normalization is applied or implied: the two sides are not costed in a common unit." | the bare statement is the claim |
| B3 | 641 (§5.1) | ", and we do not report a single number for it" | "The fourth history's interval crosses zero, so the effect is real but not uniform." | the interval is on the page (Table 4, [−1.39, 16.96]) |
| B4 | 734 (§5.2) | "---so this is not a result in which our method wins; it localizes where it stops losing" | "Second, the direction of the comparison at low $r$ is the expected one: at $r\approx 20$ the text carrier is unambiguously better." | the fact is stated; the self-deprecation was rhetoric |
| B5 | 779 (§5.3) | ", and no such bound is claimed" | "…it does not identify an intrinsic lower bound for parameter carriers." | same negation, said once |
| B6 | 824 (§6.1-2) | "(per-cell values in the artifact, not reproduced here)" | "…lowered every core cross-entropy but left the observed ordering between arms essentially unchanged." | **see OPEN-1** |
| B7 | 879 (§6.2) | ", and we do not read rank as ruled out" | "…it does not isolate a factual coverage limit, nor a capacity limit." | third restatement of one negation |
| B8 | 895–899 (§6.3) | "and any procedure that *did* accumulate would have to face the risk. We have not built such a procedure, and we make no claim that it works." | "…has no mechanism to act through here; that is a structural argument, not a measurement." | the section is titled "An Implication We Have Not Tested" |
| B9 | 1015 (§7.4) | ", and we do not claim it does" | "So ``the text is gone and only the parameters remain'' is not what separates our work from theirs." | the sentence is already a denial |
| B10 | 1065 (§7.4) | "We do not repeat ``parameters are stronger'';" | "We claim only that the *cost shape* differs, so…" | the concession is the preceding sentence |
| B11 | 693–695 (§5.2) | "We treat the sweep as conditional on one summary construction policy; we did not run the alternative of truncating one summary instead of regenerating each, so regeneration and truncation are not separated here either." | "Two properties of the sweep bound what the bracket means. [r=19.8 reuse] … [cap-64 truncation] … are not separated." | **see OPEN-2** |
| C1 | 781–786 (§5.3) | whole paragraph "What we did not measure" | §5.3 now runs: cost → rehearsal → what the three rows separate → Takeaway | moved verbatim to §8 |
| C1b | 1079 (§8) | — | new paragraph **"Measured, and not measured."** between External and Scope of the runs, carrying the three gaps | §8 is the正位 for measurement gaps |
| C1c | 907 (§6.4-4) | "Whether the cost grows with training is unmeasured (Appendix A lists the same gap)." | "…but not for free (§5.3)." | consequence of C1b: the same gap was now stated twice |
| C1d | 452 (§4.1 RQ3) | — | "…and what is still unmeasured? (§5.3, Table 8; the gaps are listed in §8)" | RQ3 promised an answer that has moved; pointer follows it |
| C2 | 911–919 (§6.4-3) | six of eight sentences (the 0.32→1.000 number, the "first thing this line of work has to solve" close) | "**The probe set is the weakest link, and we have no procedure for choosing one.** We draw 16 probes uniformly, with no coverage criterion over the history's content, no sampling frame, and no sensitivity analysis in their number or spread; a probe set that is too small, too clustered, or drawn from one part of the history would look exactly like a limit of the carrier, and we cannot currently tell the two apart (§8)." | §8 Internal (i) carries the long form; §6.5 is still the place the probe problem is argued as the blocker |

Net effect: **−233 words** (12,341 → 12,108 in the PDF text, references included).
§5.3 no longer ends by dismantling its own Takeaway.

## Build

- `tools/tectonic -r 3 paper-fse-v7.tex`, exit 0, **13 pages**, **0 undefined references**.
- Overfull boxes: 7.96 pt at §3.1 (`lines 367–369`) and 4.59 pt at the end of the bibliography
  (`line 1173`). **Both are byte-identical to v6** (verified by compiling a copy of v6:
  `7.95801` / `4.592`), i.e. pre-existing and below the 10 pt threshold.
- v6 additionally had `Overfull \vbox (1.89pt too high)` on its last page; **v7 no longer has it**
  (the last page carries 8,428 characters instead of 9,479).
- Page fill by page is otherwise unchanged from v6 (p8 is the full-width Figure 1 page in both).
- Hashes: tex `595F0914…`, pdf `7E4422CB…`. v6 remains `28DB2305…` / `2DD9DBCC…`.

## OPEN-1 — B6 depends on V07, which I do not have

The deleted parenthetical was the only pointer to where the heading-template check lives. I could
not find its per-cell values in `.local-8b`: no artifact has a template/heading key except
`m24_poskl.json` / `m25_digitmass.json`, where `"template"` is a *position class* (surface template
tokens), not the eight-section arm. `m11_content_floor.json` is a different experiment (two meters,
A/B).

So §6.1(2) currently reads as an assertion with nothing behind it — the exact state the
parenthetical was apologising for, minus the apology. If V07 is "put those per-cell values in an
appendix table", the run's output has to be located first; tell me which file it is (or which
report it was transcribed from) and I will build the table in v8.

## OPEN-2 — B11 removes the only mention of regeneration-vs-truncation

The deleted sentence was the one place the paper said the sweep mixes two construction policies.
The two survivors are the `r=19.8` reuse of `S₁` (body below cap, not freshly generated) and the
cap-64 truncation. A reviewer can still ask: "you truncate at 64 and regenerate at 512 — is the low
end of your sweep a truncation artefact?" Nothing now answers that.

If the intended reading is "the cap-64 point is a legal budget point, not a construction study", the
scope statement belongs in the same sentence as the truncation confound. Say the word and I will put
one clause back in v8; it is 12 words, not a paragraph.

## Also noted, not touched

- `figures/fig1-rstar.png` still contains the in-figure text "256-token call-cluster CI crosses
  zero; see report for sensitivity." — a dangling pointer of exactly the kind B6 removed, but in a
  raster. (The legend already says `R0`; that part of the old figure item is done.)
- §6.4 item 8 ("Session-local and non-accumulating") still restates the collapse argument that B8
  trimmed in §6.3. Not in the B list, so left alone.