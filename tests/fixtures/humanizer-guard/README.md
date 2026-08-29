# `humanizer-guard` — the write-guard fixtures (D-O97, orchestrator §10.3 rule 10)

One original and four candidates, read by `tests/check-humanizer.sh` section (c)
against `.specify/ba/scripts/sk_humanizer_guard.py`.

The original is a **spec-shaped prose file**: exactly the surface D-O97 opened.
It carries, on purpose, one of everything the fence names — a `US<n>` story with
its `(P1)` priority, a `[NEEDS CLARIFICATION]` marker, a two-row markdown table
of `FR-<n>` requirements, an `AT-…` threshold, a `CC-…` assertion, a `W-…`
waiver tag, a dated record reference, a verbatim quotation, an `SD-<n>` and an
`XO-<n>`, a §-ref, a backticked command, a markdown link target, and a
`What I need from you:` closing ask with lettered options carrying
`(recommended)`. It also carries two deliberately AI-sounding sentences
(*"comprehensive solution that leverages … in order to deliver a seamless
booking experience"*), so the good candidate has something real to rewrite.

| Candidate | Expected | Why |
|---|---|---|
| `good.md` | **exit 0** | The two AI-sounding sentences are reworded and nothing else moves — every token, table row, marker and pinned line stands byte-identical, in order |
| `bad-marker-dropped.md` | **exit 1** | The `[NEEDS CLARIFICATION]` marker is paraphrased into prose. The marker grammar is the writing standard's, and a paraphrase of it is a claim the spec no longer makes |
| `bad-table-reworded.md` | **exit 1** | One `FR-2` table row is reworded. Tables are machine-read: the gate's own readers parse this row |
| `bad-paragraphs-merged.md` | **exit 1** | The closing ask is folded into one paragraph. The block is pinned (§10.3 rule 9) and its lettered options are load-bearing — this is the structure-never rule, caught at the pinned line |

The three bad candidates are each **one edit away from `good.md`**, not from the
original: a guard that only fires when several things change at once is a guard
that passes the case it was written for.
