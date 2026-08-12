---
name: ba-frame
description: Band-1 entry. Initializes the two aspect ledgers at six untouched aspects, takes the flow-profile pick at P-O0 - flow-profile selection before any aspect opens, confirms the presale canvas is present and carried into the repo, and runs T-01 - Discovery canvas framing to produce one when it is absent. The birth act for .specify/aspect-state.md and .specify/aspect-plans.md; after it, the Stakeholders aspect is openable.
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
  ledgers. The canvas, if one has to be produced, is the output of
**T-01 — Discovery canvas framing** under its
  own contract — dispatched, not written here.

## Step 1 — the ledgers

Create both from their templates, at `.specify/` top level:

| File | From | Initial content |
|---|---|---|
| `.specify/aspect-state.md` | `.specify/ba/templates/aspect-state.md` | head: `Band: 1 (open)`; `Profile:` left for Step 2; the six-row table at `untouched`, `Since` and `Basis` empty; all four head lines `none` |
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

## Step 2 — P-O0 (flow-profile selection): pick the profile

**A full checkpoint: render, then stop.** The profile is picked here, **before any
aspect opens**. Render the picker, exactly:

```
Flow profile — pick one before any aspect opens (P-O0 — flow-profile selection):
1. Discovery — the full analysis path. Destination: certified feature specs.
2. Presale — the minimum technique set for limited client access.
   Destination: roadmap + open questions + assumptions on record;
   draft specs optional. Waivers expected.
Waiting for your pick. Switchable later; the switch is logged.
```

Then **stop and wait.** Do not pick. Do not default to Discovery. No aspect opens
until the profile is on record.

**What a profile is (D-O14):** a **recommendation default, never a restriction**.
It filters which techniques the suggestion snapshot surfaces as full rows, and it
declares the flow's destination. It changes no threshold, no assertion, no gate —
the quality machinery is profile-blind. Out-of-profile techniques stay electable
by code at any **P-O2 — plan composition**.

**Discovery** — the full path. All 20 techniques in profile: 18 catalogue plus
the 2 spine techniques. Destination: certified feature specs and handoff (Band 3).

**Presale** — the minimum path to a scoped roadmap under limited client access.
Destination: **Band-2 exit, extendable to draft specs (D-O18)** — a current
roadmap (epics + phases), the open-question roll-up, every assumption on record
via markers and aspect waivers, and, where the presale needs them, **draft
feature specs**. A **draft spec** is not a new class or format: it is an ordinary
`spec.md` that stops before its effective PASS, carrying its unknowns as
`[NEEDS CLARIFICATION]` markers. Aspect waivers are the expected instrument here,
debt named — not an anomaly. **Band-3 drafting is in profile:** feature entry
(P-O8 — Band-3 entry) and **Tier 2 — spec-depth gap-filling** run in **assumption
posture** — draft-and-mark, with the gap questions that cannot reach the client
deferred as a BA-confirmed batch, standing as their markers. Certification and
handoff are not the presale destination: they stay behind existing gate law — no
effective PASS, no certification, no handoff — and are expected after a recorded
switch to Discovery. The gate stays BA-invocable at any time; on a draft spec its
FAIL report is an informative named-gap list — the client Q&A agenda.

In profile for Presale: **T-01 — Discovery canvas framing · T-02 — Glossary
discipline · T-03 — Stakeholder register · T-05 — Context & landscape mapping ·
T-06 — Constraints elicitation · T-08 — Value definition · T-09 — Vision &
differentiation · T-10 — Solution surface review · T-16 — Global out-of-scope ·
T-17 — Epics decomposition · T-18 — Scope allocation · Tier 2 — spec-depth
gap-filling (assumption posture)**, plus **Tier 1 — epic scoping interview** as
electable where a client call exists; where none exists, its ingestion step runs
on captured client material (RFP, client documents) as the notes input. Out of
profile: T-04 — Persona charters · T-07 — Competitive analysis · T-11 — Domain
(conceptual) modeling · T-12 — Roles & permissions · T-13 — Core process mapping ·
T-14 — Design & UX standards · T-15 — Constitution.

Write the pick into the ledger head:

```
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason
```

**Switching later is legal, and it is a ledger event with a reason** — never a
silent head rewrite:

```
<date> · profile · <from → to> · <BA initials> — <reason>
```

## Step 3 — the substrate

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
3. Run **T-01 — Discovery canvas framing** with any presale material the
   BA supplied: read `.claude/skills/ba-t01/SKILL.md` and execute it as the
   procedure — its compiled P-O3 (technique invocation) check governs; no
   second command from the BA. That run authors `canvas.md`; this skill does
   not.
4. Book contract fulfillment in the `## Frame` run log —
   `fulfilled` · `partial — <what is missing>` · `failed — <why>`.

Either way, the canvas's sections then serve as the aspects' shared substrate.

## Step 4 — the band event

Append to `## Events` in the state ledger:

```
<date> · Band 1 entered · Frame · <BA initials> — canvas.md present (presale) | canvas.md produced by T-01 under {…}
  ledgers initialized: six aspects untouched · profile: <Discovery | Presale> (P-O0)
```

Then render the head (the same view `/ba-status` gives) and name the one act now
available: **`/ba-aspect stakeholders`** — the root, whose prerequisites are
satisfied by Band-1 entry itself. With the substrate **and the profile** in place,
Stakeholders is openable.

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
re-initializes a ledger that exists · **never picks the flow profile on the BA's
behalf, and never defaults to one** — P-O0 (flow-profile selection) is a BA act,
and no aspect opens until the pick is on record · never treats a profile as a
restriction: out-of-profile techniques stay electable by code.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
