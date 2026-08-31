---
name: ba-close-band1
description: P-O7 - Band-1 closure, the arming act. Checks the two preconditions (six aspects cleared or waived, zero reopened; every standing AW re-affirmed into the armed state), records the closure event, then requests the full Scope-H run from /ba-gate-health that arms the system. Closure completes when the arming entry exists, whatever its verdict. Band 2 unlocks.
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

**An expected-profile-debt waiver re-affirms as its class.** Where every miss on
the waiver resolves to an out-of-profile technique's artifact, the line names the
class — `AW-<n> · <aspect> · expected profile debt · re-affirmed <initials> into
the armed state` — and does not argue it — it is the profile's own arithmetic, and
re-affirming it is a profile decision confirmed, not an exception forgiven. The
arming is unaffected: step 3 requests the full Scope-H run exactly as written, and
CC-H-01 and CC-H-05 **arm over the gap and keep policing it** — expected is not
absent, and from here the debt is the contract's, lifted only by an `HA-<nn>`.

A **lapse** at this moment returns that aspect to `open` (T8) and precondition 1
is no longer met: say so and stop. Dependents keep their states — lapse is not
reopen.

Both manual stops here close per §10.3 rule 9 — `What I need from you:` — one
AskUserQuestion call each.
The precondition-1 miss: one lettered question per blocking aspect —
`a. clear it — /ba-clear <aspect>` · `b. waive it — /ba-waive-aspect
<aspect>, the debt named` · `c. hold — closure waits`; exactly one option per
question carries `(recommended)` — `clear` where that aspect's evidence table
is complete, else `waive`, the valve this section itself names. The
re-affirmation list: one lettered question per standing waiver —
`a. re-affirm into the armed state (recommended) — the revisit trigger has not
fired` · `b. lapse — the aspect returns to open and closure stops`. Under a
standing grant nothing here changes: the band-boundary report and its
decision-list tail keep their pinned shapes (rule 9 is inert under AUTO).

## P-O7 (Band-1 closure) — the act

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

**Under a standing grant this request is inside the grant** — it is the closing
step of P-O7 — Band-1 closure, not a second act. Make it in the same act as the
stamp: **a run may never stand "closed but unarmed"**, because that puts Band 2
on the road with Scope H silently disarmed. The division of labour is unchanged
— you request, the gate runs — and the **P8 HA review** the full run raises
rides the ratification batch with every other AUTO act.

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
2. **Band 2 unlocked.** The next act is `/ba-aspect band2` (P-O2 — plan
   composition): the `## Band 2` section takes its composed plan before any
   technique runs — this skill points at that checkpoint and never seeds the
   plan. Under it, decomposition and allocation become available:
   **T-17 — Epics decomposition** (`/ba-t17`) → the roadmap; **T-18 — Scope
   allocation** (`/ba-t18`) → the MVP allocation, on-demand and
   repeatable, each rerun carrying rationale + a diff vs. current + BA approval,
   logged with reason in the living roadmap.
3. **The aspects stay alive.** All six remain reopenable through Bands 2–3; the
   thresholds do not come back, but the machinery does.

One advisory, rendered once when it applies: closing over a **waived Solution**
means Band 2 decomposes a guess. Say it; the BA's call stands.

## Under a standing grant — the band-boundary report

The P-O7 — Band-1 closure stamp is **AUTO** under a grant (`/ba-auto`), and
closure is ratified in one batch at `off` — unchanged. **The arming run is
inside the grant:** request `/ba-gate-health full` in the same act, and render
the report only once its entry exists — never before. **Band-1 closure is a band boundary**, so it is
one of the four events that end the run's turn. After the stamp, render the
pinned band-boundary report and **stop there**; the grant stands, and the BA's
next message resumes the run:

```
Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>
Auto-trail since <start | last boundary>: <n> acts
Assumptions: <n> · Open questions: <n>
Health refresh: <current | overdue: <r> runs vs cadence>
Scope coverage: <in-boundary epics briefed <b>/<e> | uncovered inside boundary: E-nn <name> · … | — no roadmap or no boundary yet>
Next act: <one line> — any reply continues · /ba-auto off renders the resumption report
```

**Where a standing scope advisory stands, the decision-list tail follows the
report's last line** — the pinned shape above is untouched, and the tail is an
addition, never a replacement. Where no entry stands, nothing renders:

```
Scope advisories — <n> standing · decide each (P-A1 row shape — source-audit definition §5)
Rulings: apply all · apply all except <#…> · <#>: <letter> <argument>
```

The row shape, the three dispositions and the ruling's home are `/ba-auto`'s —
cited here, never restated. **Assembling the list may be AUTO; ruling it never
is: an AG never answers it.**

**The closing ask — the report's pinned tail.** After the report's last line —
and after the decision-list tail where that renders — the render ends with the
pinned `What I need from you:` block; it is **never composed at the stop**:

```
What I need from you:
1. Band <n> is closed under the grant. How do we proceed?
   a. continue — <the report's Next act line, in plain words> (recommended)
   b. pause and ratify — /ba-auto off; the resumption report renders
   c. correct something first — name it
Reply with a letter, or in your own words — any reply continues.
```

`<n>` is the band this boundary leaves behind — **Band 1 here**. The three
conditional joins — the overdue health option before c with recommended
staying on continue, the uncovered-epics option joining the same way after it
(`brief the uncovered in-boundary epics first`, recommended still on continue,
Tier 1 in ingest mode being inside the grant), and the decision-list items
joining as questions in **T-18 — Scope allocation's** step-4 shape — and the
presentation are `/ba-auto`'s, cited here, never restated. Still a render, not
a ratification point: the ask takes no ruling on the trail, and **the
recommended option is the continue**.

The effects above go to the ledger, not the conversation: under a grant nothing
between acts is narrated, and this report is the whole of what the BA sees.

## What this skill never does

Never runs a Scope-H check itself — it *requests* the arming run (no Bash, and
that is the mechanical half of the rule) · never closes with a `reopened` aspect
or an unmet state · never offers a partial-band entry · never re-affirms or
lapses a waiver on the BA's behalf · **never leaves the run "closed but
unarmed"** — the arming request goes with the stamp, under a grant and outside
one alike · never blocks closure on the arming run's
verdict · never converts an arming-run gap into an aspect waiver · never edits
`.specify/gate-health.md`, any content artifact, or anything under
`.specify/memory/`.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report, the mid-grant stop report and
the resumption report are the only BA-facing renders of an auto cycle
(`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**,
by the effective PASS at `/ba-gate <feature>` alone; the certified-text check
runs by itself when implementation takes the feature and is never a lift
condition. Wanting to implement is never evidence of readiness:
the only exit is the gate.
