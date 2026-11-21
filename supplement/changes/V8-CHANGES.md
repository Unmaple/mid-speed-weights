# v8 change log — the two provenance fixes, and nothing else

Input: `paper-fse-v7.tex` as rebuilt inside `tmp-v7-preprint-review-20261026` (live v7, sha
`3ED78DC2…`; the frozen snapshot the review opened is `595F0914…`). Authorised scope: the two hard
problems only — the crossing's comparison pair, and the crossing statistics script. Two
consequential edits were unavoidable and are listed as such.

---

## 1. R02 — the crossing was hung on the wrong pair of checkpoint

**Was** (§6.2, "First, the crossing moves with the probe set"):

> …the accuracy-based point estimate goes from 6.76 to 4.19 **across this intervention**…

"This intervention" is the paragraph above: 56 → 80 training probes, **3,584 → 5,120** updates,
value-position top-1 0.3125 → 0.84375. The crossing numbers are not from that pair:

| number | adapter | updates | probes | source |
|---|---|---:|---:|---|
| 0.3125 | `m37_rdshapes.pt` | 3,584 | 56→80 | `m37_shape.json` |
| 0.969 | `m31_rd_2304.pt` | 2,304 | 36 | `m34_rewording.json` (`adapter`) |
| **6.76** | `m31_rd_2304.pt` | **2,304** | 36 | `m30_acc5.json` `rd_2304` |
| 0.84375 | `m38_rdcovered.pt` | 5,120 | 80 | `m38_covered.json` |
| **4.20** | `m38_rdcovered.pt` | **5,120** | 80 | `m30_acc5.json` `rd_covered` |

**Is**: the sentence names both adapters and their update counts, ties each to the accuracy figure
already on the page, and says out loud that this is a different pair from the intervention above:

> First, the crossing moves with the probe set: the accuracy-based point estimate is 6.76 on the
> 2,304-update adapter (the one that scored 0.969) and 4.20 on the 5,120-update covered adapter (the
> one that scored 0.84375), a factor of 1.61 on that curve and indicator, not a capacity ratio. This
> is a different pair from the 3,584-to-5,120 update intervention above — probe composition and
> optimization exposure differ together — so it locates a sensitivity, not a probe-only effect.

**Recomputation** (`.local-8b/rstar_from_scores.py`, per-question scores, log-$r$ linear between
adjacent caps): `rd_2304 = 6.7573`, `rd_covered = 4.1961`, paraphrase stratum of `rd_2304` = 5.8420.
So the paper's 6.76 was right and **4.19 → 4.20** for correct rounding; factor 6.7573/4.1961 = 1.610
is unchanged. If you prefer 4.19 (truncation), it is a one-character revert.

---

## 2. R05b — the crossing test in `m30_acc.py` tested the wrong sign

`caps` is ordered `[1024, 512, 256, 128, 64]`, i.e. widest → narrowest, so `SR − RD` in
value-position top-1 goes **positive → negative**. The loop tested `a <= 0 < b` (the reverse), and
its early exit fired on `a > 0`, so the "already below at the widest cap" string was written for
every arm regardless of scores. Both halves are now:

```python
                # caps are ordered widest -> narrowest, so SR-RD crosses + -> -.
                if a > 0 >= b and sr[k + 1] != sr[k]:
                    ...
                if a <= 0:
                    star = "SR 在最宽的 cap 处就已不高于 RD"
```

Verified three ways: `python -m py_compile m30_acc.py` (exit 0); `.local-8b/rstar_from_scores.py`
reproduces 6.7573 / 4.1961 from `m30_acc5.json` per-question scores with an independent
implementation; and the widow string is now reachable only when the widest cap really is not above
RD (true for `rd_full`, and for `rd_144`/`rd_576`/`rd_covered` on the paraphrase stratum, which the
old code could not distinguish).

**No GPU rerun.** **`m30_acc5.json` is not rewritten**: the four stale `r_star_acc_*` strings stay in
the run record. That is deliberate — the record of what a run wrote is not something a later script
should silently overwrite — and it is documented in the script header under
`CORRECTION 2026-10-26`. Nothing in the paper is computed from those fields.

Pre-fix script sha: `B134A1C6…` is the **post**-fix file; the pre-fix content is recoverable from
`paper-fse-v7-preprint-review-20261026` review notes (R05) if a digest is ever needed.

---

## 3. Consequential: Data Availability (S4.7)

"all inputs, tensors and statistics scripts are frozen by SHA" stops being literally true once a
statistics script is corrected. Now:

> All inputs, tensors and statistics scripts are frozen by SHA, apart from one documented correction
> to a post-hoc crossing test; failures and truncations are retained.

Twelve words. Revert if you would rather keep the sentence intact and carry the correction only in
the repo.

## 4. Consequential: R01's one sentence (your correction applied, contribution kept)

`Bottleneck identification` **stays** as contribution (1), and the surrounding narrative is
untouched. Only the unconditional growth clause became conditional:

> *Demand*: when the information that must survive a boundary grows with the session, a fixed carrier
> budget becomes a bottleneck — any text carrier is capped at a summary of cap tokens plus a window of
> $0.16W$, independent of $K$.

The two things you said must not be claimed are now not claimed: demand growth is a condition, not a
premise; and no sentence says the experiments isolated capacity as the cause of loss.

---

## Build

- 13 pages, exit 0, **0 undefined references**, 0 `??`.
- Overfull `\hbox` 7.96 pt (§3.1) and 4.59 pt (end of bibliography): **identical to v6/v7**, pre-existing.
- `Overfull \vbox (2.1pt)` on the last page, same class as v6's 1.89 pt (v7 had none). Checked: the
  last block ends at y = 709.1 pt against a 710 pt text bottom, no clipping, no footer collision.
- Hashes: v8 tex `EAAAAF7C…`, pdf `541DC283…`; v7 live `3ED78DC2…`; v7 frozen snapshot `595F0914…`.

## Not done (your call: not release gates)

| item | why I am still flagging it |
|---|---|
| **R05a** appendix: "The same bracket logic places the crossing at 5.5 / 6.8 … i.e. 540–650 tokens" | Same error family as R02, and now the only place the paper describes crossing-finding wrongly: §5.2 says "we do not interpolate", the appendix calls an interpolation "the same bracket logic", and 540–650 is a range spanned by two different metrics, not a location range. Two sentences + one Table 9 cell. |
| **R04** sweep method facts (all new points hit cap without EOS; the new points carry a budget-adaptation instruction the reused S₁ does not; body 512 → 574 tokens after the frame) | The paper's independent variable is $r$; a reader cannot reconstruct how the new points were produced. One sentence. It is also the sentence deleted under B11. |
| **R08** `This is a cost argument and is independent of any particular model` (§1.4) | Four words that contradict §3.5's own "with cached dense attention and fixed model dimensions". Cheapest fix on the list. |
| **R03** §6.1(2), the heading-template check | Still asserts more than three fixed targets can carry (on H3 the RD−R sign is the other way, −0.0225). Numbers do exist: `s-reproduction-template-v1/RESULTS-main-v1.md`. My earlier "not in the artifact" was wrong — I searched the wrong tree. |
| **m32** the 0.928 decode accuracy | Comes from `m31_rd_4608.pt`, not the 2,304-update adapter of the main 9B crossing; PCA is fitted before the folds. Fine as an exploratory readout, but the checkpoint should be named. |