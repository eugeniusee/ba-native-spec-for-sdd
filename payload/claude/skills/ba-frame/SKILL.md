---
name: ba-frame
description: Band-1 entry. Initializes the two aspect ledgers at six untouched aspects, confirms the presale canvas is present and carried into the repo, and runs T-01 to produce one when it is absent. The birth act for .specify/aspect-state.md and .specify/aspect-plans.md; after it, the Stakeholders aspect is openable.
disable-model-invocation: true
---

# `/ba-frame` — Band-1 entry

**Argument:** none, or a path to the presale material the canvas will be framed
from (`/ba-frame fixtures/presale-brief.md`).

This is the first act of the framework in a project. It initializes the two
aspect ledgers and establishes the **substrate**: the presale canvas that Band 1
works over. With the substrate in place, Stakeholders — the DAG's root — becomes
openable.

## Invocation contract — check before you run

- **BA-invoked, never auto-fired.** Nothing about an install, a file appearing,
  or a project "looking new" triggers this. The BA runs it once, deliberately.
- **Refuse a second Frame.** If `.specify/aspect-state.md` already exists, stop
  and say so, printing the head. Band-1 entry happened; re-initializing would
  erase the event history, and bands never regress — nothing ever "returns to
  Band 1". A reopen degrades one aspect's state in place; it does not re-enter
  the band.
- **The orchestrator never authors.** This skill writes exactly two files, both
  ledgers. The canvas, if one has to be produced, is **T-01's** output under its
  own contract — dispatched, not written here.

## Step 1 — the ledgers

Create both from their templates, at `.specify/` top level:

| File | From | Initial content |
|---|---|---|
| `.specify/aspect-state.md` | `.specify/ba/templates/aspect-state.md` | head: `Band: 1 (open)`; the six-row table at `untouched`, `Since` and `Basis` empty; all four head lines `none` |
| `.specify/aspect-plans.md` | `.specify/ba/templates/aspect-plans.md` | the eight empty sections: `## Frame`, the six aspects, `## Band 2` |

Both files sit **outside `.specify/memory/`** and stay there. Orchestration state
is a runtime record, not one of the three content classes: out of CC-H-01's
spec-anchored glob, out of the scoped-run write trigger, out of any `memory/`
mirror toward the coding agent. Creating either one under `memory/` is a defect,
not a preference.

The six rows are always these six, in DAG order:

```
Stakeholders · Context · Value · Vision · Solution · Requirements
```

## Step 2 — the substrate

Check for `canvas.md` at the project root.

**Canvas present** (the presale entry — the normal case): confirm it is carried
into the repo, note it as the substrate in the Frame band event, and stop. Do not
lint it, do not re-shape it, do not fill it: the aspect gates read it as evidence
when they run, and the Frame act is not an aspect gate.

**Canvas absent** (a non-presale entry): producing one is the first Frame act — a
technique run *before any aspect opens*, so it is planned and contracted like any
other run, but its record lands in the plans file's `## Frame` section rather
than an aspect's.

1. Pin the output contract, and state it before running:
   `{presale canvas incl. the Context/Constraints element · Context · canvas.md}`
2. Record the plan line in `## Frame`.
3. Dispatch **T-01** (`/ba-run t01`) with any presale material the BA supplied.
   T-01 authors `canvas.md`; this skill does not.
4. Book contract fulfillment in the `## Frame` run log —
   `fulfilled` · `partial — <what is missing>` · `failed — <why>`.

Either way, the canvas's sections then serve as the aspects' shared substrate.

## Step 3 — the band event

Append to `## Events` in the state ledger:

```
<date> · Band 1 entered · Frame · <BA initials> — canvas.md present (presale) | canvas.md produced by T-01 under {…}
  ledgers initialized: six aspects untouched
```

Then render the head (the same view `/ba-status` gives) and name the one act now
available: **`/ba-aspect stakeholders`** — the root, whose prerequisites are
satisfied by Band-1 entry itself.

## What Frame is not

- **Not an aspect gate.** No AT criterion is read, no threshold is confirmed, no
  aspect changes state. All six stay `untouched` until the BA opens one.
- **Not a content act.** The canvas is not reviewed for quality here. Silence,
  stubs and holes in it are the aspect gates' business — that is exactly what
  makes them thresholds.
- **Not an arming act.** Scope H stays **disarmed** through all of Band 1: in-band
  quality belongs to the aspect gates. `/ba-close-band1` arms it, and not before.

## What this skill never does

Never edits `canvas.md` or anything under `.specify/memory/` · never opens an
aspect (that is `/ba-aspect`, a BA act) · never pre-creates a content stub —
absent and stubbed are the same hole to every AT criterion, and an installer- or
Frame-made stub would pollute the evidence · never runs a CC assertion · never
re-initializes a ledger that exists.
