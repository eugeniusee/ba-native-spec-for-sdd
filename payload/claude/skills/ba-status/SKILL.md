---
name: ba-status
description: Render the aspect-ledger head - the band line, the flow profile, the six aspect states, standing aspect waivers, open reopens, upstream flags and deferred consequences - plus the next available acts and the project dashboard, seven ledger-counted lines with the banded handoff-risk rule. The session-start habit's natural home. Read-only: it renders state, never changes it, never proposes content.
disable-model-invocation: true
---

# `/ba-status` — the ledger head

**Argument:** none.

One screen, read from `.specify/aspect-state.md`. This is the **session-start
habit's natural home**: the corpus has no daemon, so the way drift and standing
debt get seen is that somebody looks, at a defined touchpoint, and this is that
touchpoint.

## Invocation contract

- **Read-only.** This skill changes nothing — not a state, not a record, not the
  head. If rendering the head reveals that something should change, say so and
  name the skill that does it. Rendering is not deciding.
- If `.specify/aspect-state.md` does not exist, say so and name `/ba-frame` —
  Band 1 has not been entered.

## The render

Read the head verbatim; do not recompute it from the events, and do not
summarize it into prose. Then add the derived lines below it.

```
Band: 1 (open) | 1 (closed <date>) — Bands 2/3 capable
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason

| Aspect | State | Since | Basis |
|---|---|---|---|
| Stakeholders  | first-pass-cleared | 2026-07-08 | evidence table, this file |
| Context       | … |
| Value         | … |
| Vision        | … |
| Solution      | … |
| Requirements  | … |

Standing aspect waivers:  none | AW-<n> · <aspect> · <AT-IDs unmet> — revisit: <event>
Open reopens:             none | RO-<n> · <aspect> — <conflict, one line>
Upstream flags:           none | <aspect> flagged: prerequisite <aspect> reopened
Deferred consequences:    none | RO-<n>: <item> — trigger: <event>
```

### Derived — what is available now

Compute from the states and the DAG (`Stakeholders → Context, Value`;
`Context + Value → Vision`; `Vision → Solution`; `Solution → Requirements`):

- **Openable** — every `untouched` aspect whose prerequisites are all
  `first-pass-cleared` or `waived`. Name the act: `/ba-aspect <aspect>`.
  An aspect whose prerequisite is `reopened` is **not** openable — a reopen
  blocks *new* opening through itself, while existing dependent states stand.
- **Open aspects** — for each, its named misses (the aspect's visible to-do,
  from the last evidence refresh) and its next planned technique, if the plan
  has one.
- **Closure eligibility** — all six `first-pass-cleared` or `waived`, and zero
  `reopened`. Say which of the two conditions is unmet when it is not.

### The lazy read — revisit triggers, displayed here

Whenever the head carries a standing AW, a deferred consequence, or an open
reopen, **display its revisit trigger on this render**. That display *is* the
mechanism: **no scheduler exists** anywhere in the framework, and a trigger
nobody reads is a trigger that never fires. This render and the band acts are where the
BA reads them.

If a displayed trigger's event has plainly happened, say so plainly and name the
act (`/ba-waive-aspect <aspect>` to re-affirm or lapse; `/ba-clear <aspect>` if
the debt is now evidenced). Do not act on it.

## The project dashboard

The wider view, rendered under the head. **Read-only, from the ledgers alone.**
Every number is a **ledger count**. Nothing is estimated. **No composite score is
invented** — the seven lines are seven facts, not a rating.

Sources, one per line — read them, do not reconstruct them:

| Line | Read from |
|---|---|
| 1 · Aspects | the head's six-row table |
| 2 · Techniques | `.specify/aspect-plans.md` — composed plans and run logs |
| 3 · Questions | the briefs' open-question statuses, `.specify/memory/scope/<epic>.md` |
| 4 · Artifact health | `.specify/gate-health.md` — the latest Scope-H entry |
| 5 · Delivery | the certification manifests, plus the band events in the state ledger |
| 6 · Handoff risk | W- and O-records, surviving `[NEEDS CLARIFICATION]` markers in the certified spec, HA records touching the feature's dependency set |
| 7 · Next | the state, read against the DAG and the plans file |

The pinned shape:

```
Project status — <project> — <date> · profile: <…> · Band: <…>
1 · Aspects: <k>/6 cleared · <w> waived (debt on record) · <r> reopened
2 · Techniques: <done> run / <planned> planned · next planned: <code — name>
3 · Questions: <o> open · <a> answered · <v> overtaken · oldest open: <ref>
4 · Artifact health: Scope H <armed — HEALTHY | n gaps | disarmed (pre-closure)> · standing acceptances: <n>
5 · Delivery: <c> certified · <h> handed off · <b> in Band 3
6 · Handoff risk per certified feature: | Feature | W | O | surviving markers | HAs in deps | Risk |
    Rule: low = all zero · elevated = any one non-zero · high = an Override, or ≥ 3 combined
7 · Next: <the one act the state points to — code + name>
```

**The risk rule is the whole of line 6's verdict** — a stated rule over four
countable facts: waivers (W), overrides (O), surviving `[NEEDS CLARIFICATION]`
markers, and health acceptances touching the feature's dependency set. It is
tunable in the field by version bump, **never silently**. Do not soften it, do
not add a fifth factor, do not average it into a score.

Line 2 and line 7 carry **code + name** — `T-05 — Context & landscape mapping`,
never a bare code. Where a source is missing, say which and render the line as
`—`; never guess a count. A Scope H that has never run reads
`disarmed (pre-closure)`, which is a fact, not a gap.

## What this skill never does

Never edits the head or appends an event · never confirms a clearing, grants or
lapses a waiver, or rules a reopen · never runs a CC assertion or a health run
(`/ba-gate-health` is the gate's, and its own session-start habit is separate
from this one) · never re-derives the head from the events and silently
"corrects" it — a head that contradicts its events is a defect to report, not to
repair in passing · **never writes, never transitions, never proposes content** —
rendering is its whole act · never invents a composite score or estimates a
count the ledgers do not carry.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
