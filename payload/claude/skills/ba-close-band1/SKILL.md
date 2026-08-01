---
name: ba-close-band1
description: The Band-1 closure act (P-O7) - the arming act. Checks the two preconditions (six aspects cleared or waived, zero reopened; every standing AW re-affirmed into the armed state), records the closure event, then requests the full Scope-H run from /ba-gate-health that arms the system. Closure completes when the arming entry exists, whatever its verdict. Band 2 unlocks.
disable-model-invocation: true
---

# `/ba-close-band1` — the arming act

**Argument:** none.

The single most consequential act in the framework: it hands custodianship of the
spec-anchored estate from the aspect gates to the contract, and unlocks Band 2.
**One door, one logged key.**

## Invocation contract — check before you run

- **BA act.** You check the preconditions, assemble the re-affirmations, and
  record; the BA declares closure.
- **Not repeatable.** If the head already reads `Band: 1 (closed <date>)`, stop
  and print it. Bands are cumulative capabilities, not a pointer — nothing ever
  returns to Band 1, and a reopen after closure degrades one aspect in place
  while the band capabilities stand.

## Precondition 1 — the six states

All six aspects `first-pass-cleared` **or** `waived`; **zero `reopened`** — *a
live conflict is neither.* Both facts are visible in the head; read them there.

On a miss, print the offending rows and stop, naming the act that would clear
each:

| Blocking state | The way through |
|---|---|
| `untouched` / `open` | `/ba-clear <aspect>` — or `/ba-waive-aspect <aspect>` if the evidence will not come now |
| `reopened` | `/ba-clear <aspect>` after the fix lands (T6), or `/ba-waive-aspect` accepting the conflict unresolved (T7) |

**Do not offer to close anyway.** The waiver valve is the flexibility mechanism
and it is already on the table: an aspect that would otherwise delay closure is
waived with its debt named, closure proceeds, Band 2 opens. **There is no
partial-band entry.**

## Precondition 2 — every standing AW re-affirmed

List each standing waiver **one line, with its revisit trigger displayed** — this
is the lazy read, and no scheduler exists. The BA re-affirms (initials) or lapses
each.

The re-affirmation here is explicitly **into the armed state**:

> carried past closure — debt visible to CC-H where it touches spec-anchored ground

A **lapse** at this moment returns that aspect to `open` (T8) and precondition 1
is no longer met: say so and stop. Dependents keep their states — lapse is not
reopen.

## P-O7 — the act

Take the BA's declaration and record the closure event in `## Events`:

```
2026-07-10 · Band 1 closed · Y.K.
  states: Stakeholders first-pass-cleared · Context first-pass-cleared ·
          Value first-pass-cleared · Vision first-pass-cleared ·
          Solution first-pass-cleared · Requirements first-pass-cleared
  AWs carried: none | AW-1 · Context · AT-CX-2 — re-affirmed Y.K. into the armed state
  arming run: requested
```

Head: `Band: 1 (closed <date>) — Bands 2/3 capable`.

## The arming run — requested, never run here

**The orchestrator requests the full Scope-H run; the gate runs it.** Invoke:

```
/ba-gate-health full
```

with the trigger stated as *Band-1 closure — the arming run*. Its entry lands in
`.specify/gate-health.md`, which is that skill's ledger and not yours. From this
run on, the **armed cadence** governs: scoped silent checks on framework writes,
the pre-flight subset at every Scope-F Stage 0, and the session-start habit.

**Closure completes when the arming entry exists — regardless of its verdict.**

Gaps the arming run finds are the gate's ground from that moment: fixed via
routing, or accepted via an `HA-<nn>`. They do **not** reverse the closure and do
**not** send the Requirements aspect back to `/ba-clear`.

Instead — and this is the point of AT-RQ being the pre-arming image of the same
ground — **a heavy-gap arming run signals an aspect-gate escape, not closure
prematurity.** Log each such gap as a **threshold-gap candidate** in
`## Events`, tagged with the AT-ID that should have caught it, or
`none — new class`:

```
Threshold-gap candidate — 2026-07-10 · should have been caught by AT-RQ-1
  arming run CC-H-06 FAIL — constitution references design-standards.md, absent;
  the criterion's conditionality note was read as "not demanded" where the
  constitution's reference in fact lifts it into the demand.
```

Accepted candidates bump the orchestrator rules document — thresholds and prompts
are what get iterated, not tooling.

## Effects — say them, in this order

1. **Scope H armed.** Custodianship of the spec-anchored estate hands over: from
   here, debt on those artifacts is CC-H's and lifted by `HA-<nn>` records at
   `/ba-gate-health` — **never by an aspect waiver**. AT-RQ is never re-run on
   armed ground.
2. **Band 2 unlocked.** Decomposition and allocation become available:
   `/ba-run t17` → the roadmap; `/ba-run t18` → the MVP allocation, on-demand and
   repeatable, each rerun carrying rationale + a diff vs. current + BA approval,
   logged with reason in the living roadmap.
3. **The aspects stay alive.** All six remain reopenable through Bands 2–3; the
   thresholds do not come back, but the machinery does.

One advisory, rendered once when it applies: closing over a **waived Solution**
means Band 2 decomposes a guess. Say it; the BA's call stands.

## What this skill never does

Never runs a Scope-H check itself — it *requests* the arming run (no Bash, and
that is the mechanical half of the rule) · never closes with a `reopened` aspect
or an unmet state · never offers a partial-band entry · never re-affirms or
lapses a waiver on the BA's behalf · never blocks closure on the arming run's
verdict · never converts an arming-run gap into an aspect waiver · never edits
`.specify/gate-health.md`, any content artifact, or anything under
`.specify/memory/`.
