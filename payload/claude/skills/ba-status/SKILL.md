---
name: ba-status
description: Render the aspect-ledger head - the band line, the six aspect states, standing aspect waivers, open reopens, upstream flags and deferred consequences - plus the next available acts. The session-start habit's natural home. Read-only: it renders state, never changes it.
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

## What this skill never does

Never edits the head or appends an event · never confirms a clearing, grants or
lapses a waiver, or rules a reopen · never runs a CC assertion or a health run
(`/ba-gate-health` is the gate's, and its own session-start habit is separate
from this one) · never re-derives the head from the events and silently
"corrects" it — a head that contradicts its events is a defect to report, not to
repair in passing.
