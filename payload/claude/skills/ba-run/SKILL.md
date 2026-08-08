---
name: ba-run
description: Invoke a planned technique - the P-O3 - technique invocation contract check, dispatch to the technique skill, then the bookkeeping at run end (contract fulfillment, routed findings, emitted signals) and the post-run refresh of the aspect's threshold evidence. The only legal way to start a technique run.
disable-model-invocation: true
---

# `/ba-run <technique> [args]` — technique invocation

**Argument:** the technique's skill name (`t03`, `t11`, `tier1 kit E-03`,
`tier2 004`) or a custom technique's name from the composed plan.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** You may surface *"next planned:
\<technique\>"* when a prompt point renders; the run starts only as a BA act.

**Exactly one thing is checked at invocation** — nothing else:

> the technique is **on the composed plan** with a **pinned output contract**.

Not "is it a good idea", not "has the aspect enough evidence already", not "is
this the sequence you planned". The BA plans freely within an open aspect; that
freedom is the point of the planning loop.

**On a miss, stop and say which half failed:**

- *Not on a plan* → name `/ba-aspect <aspect>` to compose it in. A run outside
  the plan has no contract, and an output with no contracted destination is
  exactly what the loop exists to prevent.
- *On the plan, contract unpinned or unconfirmed* → **the run is illegal.**
  Render the missing part of `{expected output · artifact class · destination
  file}` and send the BA back to P-O2 — plan composition. Do not
  propose-and-proceed in one breath: a proposed contract becomes real when the
  BA confirms it, and that confirmation is the act of P-O2 — plan composition.

Some techniques are planned outside an aspect and check against their own plans
file sections: **T-01 — Discovery canvas framing** against `## Frame`; **T-17 —
Epics decomposition, T-18 — Scope allocation and every Tier-1 mode** against `##
Band 2`. **Tier 2 — spec-depth gap-filling** carries its contract per feature,
entered at P-O8 (Band-3 entry) — the contract check is the same, and its record
is not the plans file (below).

## P-O3 (technique invocation) — the act

Render the plan row — technique, source, the pinned contract — and take the
BA's invocation. Then dispatch the technique's skill (`/ba-t03`, `/ba-tier1`, …)
or, for a custom technique, run it under the contract the BA pinned.

## The run itself is not orchestrated

The technique executes per its own definition. Content authorship, question
legality, and interaction rules are the technique's own.

**No mid-run interference.** Do not interrupt, sample, or steer a run in
progress; do not render a P-O checkpoint while one is running. Everything below
happens **at run end**. If the run needs a BA decision, that decision belongs to
the technique's own prompt points, not to yours.

## At run end — three things happen, and you invent none of them

1. **The primary output lands** at its contracted destination — the technique's
   own act under its pinned contract. You do not write it and you do not
   "improve" it on arrival.
2. **Cross-cutting findings route** under the elicitation routing discipline,
   unchanged: the framework assembles proposed edits · **the BA approves the
   batch** · the framework writes · the scoped Scope-H check fires silently —
   **once armed**.
   - In Band 1 proper, **Scope H is disarmed and nothing fires**. In-band quality
     is the aspect gates', by design: the next threshold review reads the
     results, and nothing is silently certified pre-closure.
   - Post-closure runs get the armed cadence automatically — no new rule.
   - **Arrival is never gated:** a finding routes to its destination artifact
     whatever state that artifact's aspect is in. A Stakeholders interview that
     surfaces a business constraint writes `constraints.md` while Context is
     still `untouched`, and Context's aspect gate reads it as existing evidence
     when it runs.
3. **Signals emitted by the run enter intake in the same sitting** — reopen
   (`/ba-reopen`), overflow (P-O9 — overflow ruling, below), and the routing
   batch above. Receive and decide happen together, because every emission
   moment is a BA-present moment.

## The bookkeeping — your added duty, and it is pure bookkeeping

Append to the aspect's run log in `.specify/aspect-plans.md`:

```
<date> · <technique> · contract: fulfilled | partial — <what is missing> | failed — <why>
  signals: RO-<n> received | routing batch <ref> approved | overflow: <feature> | none
```

Then set the plan row's `Status` to `run <date>`.

`partial` and `failed` are **recorded, not retried silently**. A technique that
did not fulfil its contract leaves its hole open, and the hole is what the next
threshold refresh will name.

**Where the line lands.** An aspect's runs append under that aspect's section;
those of T-01 — Discovery canvas framing under `## Frame`.
**T-17 — Epics decomposition, T-18 — Scope allocation and every Tier-1 mode
land under `## Band 2`**, each rerun naming its trigger.

**Tier 2 gets no plans-file line.** A feature's record is its band event in the
ledger, the spec at its contracted destination, and the gate report — and a
second copy of feature state in the plans file is exactly the parallel-rotting
mirror the tracking split forbids. What still lands in the ledger, against the
feature: the Band-3 entry event, and a P-O9 overflow ruling if one is taken.

## Post-run aspect update — the defined touchpoint

After each run (and after each approved ingestion batch), refresh the aspect's
threshold-evidence table against `.specify/ba/cards/at-thresholds.md`:

- **All criteria met** → *propose* confirmation: "threshold evidence complete —
  confirm?" and name `/ba-clear <aspect>`. Proposing is not confirming; an
  aspect gate never self-clears.
- **Some unmet** → the misses stand as the aspect's named to-do, visible at the
  next prompt and on `/ba-status`.

**This is lazy detection's home in Band 1.** Evidence is assembled at this
touchpoint and on BA demand — never watched.

## P-O9 — overflow ruling

A Tier-2 session that hits the question cap with blockers still unfilled emits an
**overflow signal**: feature · unfilled blockers list · Tier-1-supplement
recommendation. Log it against the feature and take the BA's ruling:

| Ruling | Execution |
|---|---|
| **supplement** | schedule the Tier-1-supplement mini-loop as a technique invocation (a fresh P-O3 — technique invocation) **for the named gaps only** |
| **cap adjust** | Tier 2 resumes under the BA-adjusted cap — the cap is BA-adjustable by design |
| **defer** | band event + roadmap note via the routing discipline |

## What this skill never does

Never starts a run that is not on a composed plan with a pinned contract · never
pins or confirms a contract itself (that is P-O2 — plan composition) · never
interrupts a run in progress · never writes the technique's output, and never
edits it afterwards · never approves a routing batch on the BA's behalf · never
fires a Scope-H run (the armed cadence is the gate's; before closure nothing
fires at all) · never confirms a threshold · never marks a partial contract
fulfilled.
