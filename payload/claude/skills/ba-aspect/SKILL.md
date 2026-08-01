---
name: ba-aspect
description: Open a Band-1 aspect and compose its technique plan - prerequisite check, T1 opening, the evidence-grounded suggestion snapshot, and the BA's composition with output contracts pinned before any run. Carries prompt points P-O1 (open) and P-O2 (compose). Also re-plans an aspect that is already open or reopened.
disable-model-invocation: true
---

# `/ba-aspect <aspect>` — open + plan

**Argument:** one of `stakeholders` · `context` · `value` · `vision` ·
`solution` · `requirements`. Case-insensitive; resolve it to the ledger's
spelling before writing anything.

Two prompt points in one act: **P-O1** opens the aspect, **P-O2** composes its
plan. On an aspect that is already `open` or `reopened`, this skill re-plans —
P-O1 is skipped and the composition appends.

## Invocation contract — check before you run

- **BA-invoked.** Opening is a BA act, not a consequence of prerequisites having
  cleared. When prerequisites clear, `/ba-status` *says* the aspect is openable;
  it does not open it.
- **The ledgers must exist.** No `.specify/aspect-state.md` → Band 1 has not been
  entered; stop and name `/ba-frame`.
- **The suggestion is advisory, never a restriction.** The decision is *BA
  planning, LLM assists*: you suggest a recommended technique set and sequence
  from the evidence; the BA composes the real plan.

## Step 1 — the prerequisite check (T1's precondition)

| Aspect | Prerequisite |
|---|---|
| Stakeholders | — (root; Band 1 entered is the whole precondition) |
| Context | Stakeholders |
| Value | Stakeholders |
| Vision | Context **and** Value |
| Solution | Vision |
| Requirements | Solution |

Each prerequisite must read `first-pass-cleared` **or** `waived`. A `waived`
prerequisite satisfies the edge exactly as a cleared one does — that is what the
waiver valve is for — and the debt stays named in the head, not here.

A prerequisite reading `reopened` **blocks the opening**: a reopen blocks new
opening through itself. Say which prerequisite, in which state, and name
`/ba-reopen` or `/ba-clear` as the way through. Do not offer to open anyway.

State already `open` / `reopened` → skip to Step 2 (re-planning is legal at any
time in either state). State `first-pass-cleared` or `waived` → **refuse**: there
is no `first-pass-cleared → open` transition. Dissatisfaction with cleared
content, absent a contradiction, is ordinary content work — run more techniques
under the existing plan, route more findings; arrival is never gated. Only a
contradiction degrades a cleared aspect, and that arrives as a reopen signal.

## Step 2 — P-O1: the opening act

Present the prerequisite states as the basis and take the BA's act. On **open**:

- T1 executes: `untouched → open`.
- Head: the aspect's row updates — state, `Since` = today, `Basis` = the
  prerequisite states cited.
- Event, in the grammar:

```
<date> · T1 · <Aspect> · untouched → open · <BA initials> — prerequisites: <Aspect> first-pass-cleared[, <Aspect> waived under AW-<n>]
```

Root aspect: the basis reads `Band 1 entered <date>`.

## Step 3 — the suggestion snapshot (framework, advisory)

Read the aspect's AT criteria from `.specify/ba/cards/at-thresholds.md` against
the current artifact evidence. **The unmet criteria are the holes; the holes are
the suggestions.**

Every suggestion line is **evidence-grounded**: it names the hole — the AT-ID and
exactly what is missing — that it exists to fill. **A suggestion that cannot name
its hole must not be emitted.** Suggesting into a criterion that is already met
is legal only as enrichment the BA asked for; your own initiative stops at the
threshold.

Write the snapshot into the aspect's section of `.specify/aspect-plans.md`,
verbatim in this shape — it is kept as audit trail and as tuning input:

```
Suggestion — <Aspect> — <date>
| # | Technique (catalogue | custom sketch) | Addresses | Expected contribution |
|---|---|---|---|
| 1 | <name> | AT-<..> — <the named hole> | <what evidence the run should produce> |
Sequence rationale: <one line>
```

Where a catalogue technique fits the hole, name it by its skill (`t03`, `t06`, …)
so `/ba-run` can dispatch it. Where none does, sketch a **custom** technique —
the loop is catalogue-agnostic by design: a technique is runnable iff its
contract is pinned, wherever the contract came from.

## Step 4 — P-O2: composition (the BA's plan)

Present the snapshot and take the composition: **select · drop · reorder · add
custom**. The composed plan is the BA's document; the snapshot stays beside it
unchanged. Never edit a snapshot to match what the BA chose — the divergence
between the two *is* the tuning signal.

**Output contracts are pinned before any run.** Every planned technique —
catalogue or custom — carries `{expected output · artifact class · destination
file}` before it may run:

- **Catalogue techniques** come pre-pinned by their sheets; render the pinned
  contract for confirmation rather than inventing one.
- **Custom techniques**: the BA supplies the contract, or you propose it and the
  BA confirms. **An unconfirmed contract makes the run illegal** — do not mark
  such a technique planned-runnable, and `/ba-run` will refuse it. This is the
  same discipline as refusing a question without a destination, one level up.

Append to the aspect's section, dated:

```
Composed plan — <date> · <initials>
| # | Technique | Source | Output contract {expected · class · destination} | Status |
|---|---|---|---|---|
| 1 | <name> | catalogue | {…} | planned |
```

`Status` values: `planned` · `run <date>` · `dropped — <reason>`. Re-composition
appends a new dated plan block; **the plan never rewrites its own history**.

## Close

Render: the aspect's state, its named misses (the unmet AT criteria), and the
next act — `/ba-run <technique>` for the first planned line.

## What this skill never does

Never opens an aspect whose prerequisite is unmet or `reopened` · never
re-opens a cleared aspect · never runs a technique (that is `/ba-run`, its own
BA act at P-O3) · never confirms a threshold (that is `/ba-clear`) · never
authors content or edits an artifact — it writes the two ledgers only · never
emits a suggestion that cannot name its AT hole · never treats its own
suggestion as a restriction on the BA's plan.
