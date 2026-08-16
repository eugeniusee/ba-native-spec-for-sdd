---
name: ba-auto
description: Autonomous mode - /ba-auto on writes the autonomy grant AG-<n>, flips the ledger head's Auto line and runs the surviving checkpoints under the policy table, each act stamped AUTO; /ba-auto off closes the grant and renders the pinned resumption report for one batch ratification. The safety floor sits outside every grant - the two flagged sign-offs, the effective PASS, the handoff and the scope frame at P-O0b - scope-frame selection stay BA-only. Never grants itself a grant.
disable-model-invocation: true
---

# `/ba-auto on [<profile>] | off` — autonomous mode

**Argument:** `on`, optionally with `Discovery` or `Presale` · or `off`.

An autonomy grant moves the **moment** the BA states a decision. It never moves
the **content** of one. Everything the BA decided before is still the BA's; what
changes is that the grant states it in advance, once, and every act taken under
it is stamped and comes back for ratification.

## `on` — the entry act

Three writes, and nothing else:

1. **The grant.** Append `AG-<n>` to `.specify/aspect-state.md` Events:

   ```
   AG-<n> · scope: <full workflow | until <event>> · granted-by: <initials> ·
   <date> · revoke: /ba-auto off, or <condition>
   ```

2. **The head line.** Rewrite `Auto:` in place —
   `Auto: on — AG-<n> · scope <…> · since <date>`.
3. **The event.**
   `<date> · auto on · AG-<n> · scope <…> · <initials> — profile <…> (stated | inferred: <basis>)`

**The profile.** Taken from the argument. Absent, **infer and log it**:
`canvas.md` present → Presale, absent → Discovery. Say which, and say it was
inferred. **The profile never switches mid-auto** — a switch is a BA decision
moment, and a grant that could re-aim its own flow would be a blank cheque. To
switch: `off`, ratify, switch, `on` again.

## The policy table — what runs AUTO

Every checkpoint still happens. The table says who states it.

| Stop | Under the grant |
|---|---|
| **P-O0b — scope-frame selection** | **Never AUTO — the safety floor.** Auto-pickup still pre-fills every value with its citation and the block still renders; it then waits for the BA, standing grant or not. The boundary and the envelope are what every later act is measured against, and a grant that could set them would be a run choosing its own budget |
| P-O2 — plan composition, and the route `go` | Compose **as-recommended from the snapshot**, AUTO. The grant **is** the `go`. Record the snapshot verbatim — it is the ratification's evidence |
| Defer batches · the consolidated defer-confirm | Accepted AUTO. **Unclear stays an Open Question, never an invention** |
| P-O4 — clearing confirmation | All criteria met → clear AUTO. Any miss → **auto-AW**: a full waiver record, misses named, revisit trigger `BA ratification sweep (auto off)` |
| P-O5 — aspect-waiver acts | Grants and re-affirmations AUTO |
| P-O6 — reopen ruling | Default **Real**. State the blast radius; **execute no cascade** — flags, never state changes |
| P-O7 — Band-1 closure · P-O8 — Band-3 entry | AUTO stamp |
| P-O9 — overflow ruling | The **supplement lane** only: the Tier 1 — epic scoping interview supplement mini-loop fills the named gaps, assumption posture held. Never cap-adjust, never defer |
| The gate's verdict review | **Waivers AUTO on real gaps**, stamped in the report entry. **Overrides never.** On a non-waivable assertion: **fix** — name the gap in the text, or reclassify — **and re-gate.** Never bypass |

**The AUTO stamp, every act, no exceptions:**

```
<date> · AUTO (AG-<n>) · <act> · <basis>
```

## The safety floor — outside every grant

Four acts a grant never reaches, in every profile:

- **The two flagged sign-offs** — CC-XA-01 (authorization) and CC-XA-06 (the
  scope boundary), at the gate's ⚑ review.
- **The effective PASS** — the gate's ⚑ sign-off and approval steps.
- **`/ba-handoff <feature>`.**
- **The scope frame** — P-O0b (scope-frame selection), at `/ba-frame`.

The first three are the acts where a false pass is a security incident, a scope
escape, or code built on unread text. The fourth is the constraint every later
act is measured against: a boundary or an envelope the framework set for itself
would be a run choosing its own budget. Per feature, auto therefore ends at
**"done, awaiting ratification"**: the draft is complete, the gate has run, the
last two acts wait for a human.

## Continuity under the grant

Under a standing grant, **no conversational render occurs between acts**, and
the run **never ends its turn between acts inside a band**. Every record — AUTO
stamps, auto-AWs, deferrals, open questions — goes to the **ledger and the
auto-trail only**. The run proceeds continuously until exactly one of four
events:

1. **A band boundary** — P-O7 — Band-1 closure, or P-O8 — Band-3 entry. Stamp,
   render the band-boundary report below, end the turn.
2. **A safety-floor stop** — the two ⚑ sign-offs, the effective PASS,
   `/ba-handoff <feature>`, or P-O0b — scope-frame selection.
3. **Exhaustion of the grant's scope** — the `scope:` field of `AG-<n>`.
4. **`off`** — `/ba-auto off`, or the BA interrupting.

**Why this is a rule and not a preference:** a conversational render **ends the
turn**. Under a grant, a mid-band render is therefore a **de-facto stop** — the
exact thing the grant was written to remove. A run that narrates each aspect has
not run autonomously; it has spent the BA's attention at every act while holding
a grant that says it need not.

## The band-boundary report — a pinned shape

The **only** BA-facing render inside an auto cycle, beside the resumption report
at `off`. The stamps at P-O7 — Band-1 closure and P-O8 — Band-3 entry are
**unchanged** — still AUTO, still ratified in one batch at `off`. This is a **render, not a ratification point**: it takes
no BA ruling. After the stamp, render it and **end the turn**. **The grant
stands** — the BA's next message, whatever it says, resumes the run:

```
Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>
Auto-trail since <start | last boundary>: <n> acts
Assumptions: <n> · Open questions: <n>
Health refresh: <current | overdue: <r> runs vs cadence>
Next act: <one line> — any reply continues · /ba-auto off renders the resumption report
```

The auto-trail count is **since the last boundary**, not since the grant.

**The health line is display only.** It carries the refresh state computed
exactly as the dashboard's line 5 computes it — recorded `gate-health.md` runs
against the gate's cadence, one full run per scope-brief ingestion batch — so
the two renders can never disagree. **The refresh act is not yours:**
`/ba-gate-health` runs it and the BA invokes it. A grant does not extend to it,
the report never fires it, and an `overdue` line is a fact rendered, not a stop.

## `off` — the resumption report

`/ba-auto off` (or the BA interrupting) closes the grant and renders this
**pinned shape**, unchanged:

```
Auto off — <date>
Stopped at: <point> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail: <n> acts — one line each: <date> · AUTO (AG-<n>) · <act> · <basis>
Assumptions: <n> · Open questions: <n>
Ratify: accept all / list exceptions
Next manual act: <one line>
```

A run cut off mid-flight leaves its artifact a **draft** — never half-land an
output and call it done. **Ratification is one batch act.** Exceptions reopen
their items manually, each by its own ordinary checkpoint. Append the events:

```
<date> · auto off · AG-<n> · <initials> — <n> AUTO acts, awaiting ratification
<date> · ratification · AG-<n> · <initials> — accepted all | exceptions: <list>
```

## What this skill never does

Never AUTO-stamps a ⚑ sign-off, an effective PASS, a handoff, or a scope
frame · **never grants itself an AG** — the grant is the BA's act, and a framework that could write its
own would have no boundary at all · never invents where unclear — that is an
Open Question · never switches the profile mid-auto · never executes a reopen
cascade · never takes an override, a cap adjust or a defer at
P-O9 — overflow ruling · never runs a CC assertion itself · never leaves an act
unstamped, never leaves an unratified trail unnamed at `off` · **never ends the
turn or renders to the conversation between acts inside a band** — mid-run
records go to the ledger only, and a cycle's only BA-facing renders are the
band-boundary report and the resumption report.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report and the resumption report are the
only BA-facing renders of an auto cycle (`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
