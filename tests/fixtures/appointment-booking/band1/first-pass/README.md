# Band-1 first-pass artifacts — what T-01, T-02 and T-03 produced

**FIXTURE (S5).** The three Band-1 artifacts at the state their run logs record,
so the compiled technique prompts have something concrete to be asserted
against — and so the §12.2 evidence table has evidence.

| File | Technique | Dated | The run log line it belongs to |
|---|---|---|---|
| `canvas.md` | T-01 | 2026-07-07 | the Frame act — drafted from `../../presale-brief.md` |
| `stakeholders.md` | T-03 | 2026-07-08 | Stakeholders, the two runs that cleared it |
| `glossary.md` | T-02 | 2026-07-10 | Requirements — `t02 · contract: fulfilled — glossary.md, 6 terms` |

## What is real here and what is recorded

The **validator runs live**: `tests/check-band1-artifacts.py` parses these files
and judges them against the shapes the sheets pin — thirteen canvas sections in
order, cite-or-mark on every cell, `P-n`/`O-n` contiguity, link resolution, the
glossary's four columns and dated merges, the register's six columns and explicit
sponsor authority, canvas ⇄ register coherence, and continuity into
`../../project/`.

The **artifacts are recorded**, because producing one is an agent act and cannot
be re-derived inside a regression suite — the same split S3 made for the gate's A
pass and S4 for the ledgers. What the suite proves is that the machinery these
prompts compile from accepts the corpus's own world and rejects sixteen distinct
violations of it.

## The one divergence this fixture carries deliberately

**The build plan's toy run and the corpus's history enter the world by different
doors, and both stand.**

- Orchestrator §12.1 — and therefore `../aspect-state.md` and `../aspect-plans.md`
  — records Frame 2026-07-07 with `canvas.md` **already present from presale**:
  T-01 is on the `## Frame` plan and its status is
  `dropped — canvas.md present from presale, carried into the repo`. That is the
  skip-if branch, and the ledgers are right to record it.
- The build plan's own scripts — §4's S5 row and §5 step 3 of the Phase-2 exit
  test — enter the same world through the **canvas-absent** branch:
  `/ba-frame` with `presale-brief.md`, and T-01 births `canvas.md`. That is the
  only entry a reproducible fixture run can have, because the other one produces
  nothing to check.

`canvas.md` here is the second door's output. It converges on the first door's
substrate exactly — thirteen sections, `P-1`/`P-2`, `O-1`/`O-2`, the substrate
line the Frame band event records — which is what makes the two readings one
world rather than two. `check-techniques.sh` asserts that convergence rather than
assuming it.

## Framing grade, visible in the diff

`canvas.md` here against `../../project/canvas.md` is the whole difference
between framing grade and aspect grade:

| | first pass (T-01, 07-07) | after the aspects and RO-1 (07-15) |
|---|---|---|
| §7 links | 2 of 5 functions carry `→ O-2` | 4 of 5 — T-10 completed them |
| §7 actors | `Publish Specialist availability` | `Availability published by Specialists or their Clinic Admins` — RO-1's resolution |
| §11 Our Solution | `open — no source material` | the differentiation statement — T-09 |
| §13 Business / Regulatory | `open — no source material` ×2 | cited to `constraints.md §2` / `§3` — T-06 |

Every one of those holes was a trigger, and the aspect that owned it filled it.
None of them was ever a fake `N/A`.
