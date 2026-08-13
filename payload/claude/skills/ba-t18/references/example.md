# T-18 — Scope allocation · output template & worked example

## The template

```markdown
## Allocation log

### Allocation <n> — <date> · trigger: <post-decomposition | post-ingestion E-nn | cycle close NNN | priority shift | scope-frame | BA-directed> · BA: <name>

| Epic | Phase | Reason |
|---|---|---|
| E-<nn> <name> | <from> → <to> | <factor(s)>: <reason> |

Held: <unchanged rows, one line> · Basis: <one line across the four factors>
```

## Worked example — the initial run

**Allocation 1 — 2026-07-11 · trigger: post-decomposition · BA: Y.K.**

| Epic | Phase | Reason |
|---|---|---|
| E-01 Accounts & Access | Unallocated → MVP | dependency order: E-03's "Cancel own appointment" presumes accounts |
| E-03 Appointment Booking | Unallocated → MVP | walking skeleton: the thinnest end-to-end slice of the booking journey; value: `→ O-1 · O-2`; risk noted — calendar direction open (canvas: Third-Party) |
| E-07 Online Payment | Unallocated → Phase 2 | value vs. effort: no payment surface needed for O-2 at launch; integration-heavy; phase hint carried from the graduated out-of-scope row |

Held: — (first run: all eight rows allocated; five omitted here) · Basis: MVP
composes the booking journey end to end inside the autumn window
(constraints.md §2 — launch tied to the autumn season) — O-1's "MVP this year"
made a plan.

## Worked example — the rerun that moved nothing

**Allocation 2 — 2026-07-15 · trigger: post-ingestion E-03 · BA: Y.K.**

no change — the brief confirms the MVP composition: reschedule-in-place stays
deferred inside E-03 (brief §3), not a phase move; R1 (calendar provider contract
unsigned) held as in-epic risk with a named owner, not a re-phase.

## What the examples are showing

- **Three rows, three different deciding factors.** E-01 is pure dependency
  order. E-03 is the walking skeleton, with a risk noted rather than a risk
  acted on. E-07 is value against effort. A log where every reason reads
  "value vs. effort" is a log where the factors were never actually applied.
- **E-03 carries a risk in its reason and stays MVP anyway.** Naming a risk is
  not the same as re-phasing for it. The open calendar direction is visible in
  the entry, so the next rerun does not rediscover it.
- **E-07's reason ends by citing the phase hint it inherited.** The hint came in
  the Source cell T-17 — Epics decomposition wrote when the exclusion graduated.
  That is the whole mechanism by which a fence's phase intuition survives into
  an allocation decision without either technique writing the other's column.
- **The basis line is one line, and it names the constraint that bounds
  everything else.** The autumn window is why the MVP is thin. Without that line
  the three reasons look like preferences.
- **Allocation 2 changed nothing and is on the record anyway.** It names its
  trigger, its reason, and the two candidate moves it consciously declined. A
  rerun that leaves no trace is indistinguishable from a rerun that never
  happened — and the next reader would have no way to tell whether the ingestion
  was ever weighed.

## The two boundaries the second entry is holding

**A deferral inside an epic is not a phase move.** Reschedule-in-place is
deferred *within* E-03 — it lives in the brief's Deferred section, at feature
grain, with what substitutes at launch stated beside it. Moving E-03 itself, or
writing `MVP → Phase 2` in one cell, would both be wrong: the first re-phases an
epic that is not moving, the second invents span notation the roadmap does not
carry.

**An unsigned contract is a risk with an owner, not a phase.** R1 stays in the
brief's §5 where it has an owner and an impact-if-wrong. Pushing E-03 to Phase 2
because one of its dependencies is unsigned would move the whole walking skeleton
for a risk the brief is already tracking at the right grain.

## The diff baseline, stated

Every entry is measured against **the previous entry**, not against the file as
it happens to read. On the first run the baseline is the birth value: every row
at `Unallocated`, which is why entry 1's `from` column is uniform and no later
entry's ever will be.
