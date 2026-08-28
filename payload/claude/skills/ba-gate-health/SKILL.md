---
name: ba-gate-health
description: Run the project-health check (Scope H) over the spec-anchored artifacts - full at Band-1 closure, after an ingestion batch, or on demand; scoped to one artifact and its dependents after a framework write. Records the run in .specify/gate-health.md, reviews standing health acceptances, and announces any certification a write has voided.
disable-model-invocation: true
---

# `/ba-gate-health [full | <artifact>]` — the Scope-H run

**Argument:** `full` (or empty) → all spec-anchored artifacts · an artifact path
or name → the scoped run for that artifact and its dependents.

Scope H asks one question: **are the shared artifacts every feature gate leans
on still sound?** A Scope-H FAIL blocks nothing by itself — it blocks any
Scope-F run whose `deps(F)` contains the failing artifact, and that block is
enforced at Stage 0 of `/ba-gate`, nowhere else.

## Invocation contract — check before you run

- **Armed only after Band-1 closure.** Before the closure act, Scope H is
  **disarmed**: in-band quality belongs to the aspect gates (`/ba-clear`). If
  `.specify/gate-health.md` does not exist and this is not the arming run
  dispatched by `/ba-close-band1`, stop and say so.
- **The arming run is inside a standing autonomy grant** (`/ba-auto`): it is the
  closing step of P-O7 — Band-1 closure, so it arrives dispatched under the
  grant like any other AUTO act, and **the run may never stand "closed but
  unarmed"**. Every later refresh stays **BA-invoked** — a grant does not extend
  to it, and the band-boundary report's health line renders the state without
  firing one. The **P8 review** below rides the ratification batch when the
  arming run raises it.
- **Smallest sufficient scope.** State the scope and the rationale *before*
  running — "scoped check: glossary + 2 dependents — nothing else changed",
  "full run: ingestion touched 4 artifacts". The BA may widen or narrow.
- **Lazy detection.** Nothing watches the files. Out-of-band hand edits trigger
  nothing; drift is caught at the next touchpoint. Hence the session-start
  habit — and the Scope-F pre-flight remains the hard guarantee.

## The three run modes

| Mode | When | Coverage | Voice |
|---|---|---|---|
| **Full** | Band-1 closure (the arming run) · after each scope-brief ingestion batch · on demand | all seven CC-H over every spec-anchored artifact | always reported; the entry appends to the ledger |
| **Scoped** | every framework write to a governance or context artifact | the touched artifact's assertions + its cross-reference dependents | **silent unless FAIL** |
| **Pre-flight** | Stage 0 of every Scope-F run — *dispatched by `/ba-gate`, not by this skill* | the seven CC-H restricted to `deps(F)` | reported into that run's entry |

### The scoped-run map

| Edited artifact | Assertions run | Cross-effects |
|---|---|---|
| `glossary.md` | CC-H-01 · CC-H-04 | notice for certified-but-unhandedoff features (the glossary is in every `deps(F)`) |
| `roles-permissions.md` | CC-H-01 · CC-H-05 | same |
| `domain-model.md` | CC-H-01 · CC-H-05 (policy rows referencing entities) | same |
| `scope/<epic>.md` | CC-H-01 · CC-H-03 (that epic) | notice for that epic's certified features |
| `roadmap.md` | CC-H-02 · CC-H-03 · CC-H-07 (the roadmap half — rows outside the head's `Boundary:` set against standing `AS-<n>` entries) | — |
| `constitution.md` / a governance file | CC-H-01 · CC-H-06 | notice where it sits in a `deps(F)` |
| `canvas.md` · `context.md` · `constraints.md` · `stakeholders.md` · `processes.md` · `out-of-scope.md` | CC-H-01 · CC-H-07 — `out-of-scope.md` only (the fence half — fence rows against standing `AS-<n>` entries) | notice where the artifact is in a certified feature's manifest |

## Running it

**The M third** — CC-H-02 · CC-H-03 · CC-H-06:

```bash
python3 .specify/ba/scripts/sk_health.py --format json --root .
```

**The A third** — CC-H-01 · CC-H-04 · CC-H-05 · CC-H-07: dispatch the `ba-gate`
subagent with `.specify/ba/cards/assertions-h.md` and the assertion list for
this scope. On a full run that is all four; on a scoped run, only the ones the
map names.

**CC-H-07 — the acceptance cross-check.** It reads three grounds: the
aspect-state head's **`Acceptance shapes:`** line (`standing` `AS-<n>` entries),
the **roadmap** (rows allocated outside the head's `Boundary:` set), and
**`out-of-scope.md`** (fence rows) — and, as resolution evidence, the head's
**`Scope advisories:`** line and the allocation log's step-4 ADV rulings.
**Element grain is the conflicting pair** — one deferred or excluded item × one
`standing` AS entry — in named-gap grammar:

```
CC-H-07 FAIL — E-05 (Phase 2) × AS-2 "reminders fire" — no recorded ruling
```

**Resolved:** any recorded ADV disposition for the finding — `hold as advisory`
included, because the BA saw it and chose visibility, which is a ruling — or the
AS entry itself standing `superseded — SD-<n>` or `accepted — <reason>`. **A
ruled conflict is not a finding — the record is the ruling itself**, and it is
not re-named. **Unresolved:** a live CC-H-07 gap — it counts in `n gaps`, it
blocks wherever `roadmap` or `out-of-scope.md` sits in `deps(F)`, and
**`HA-<nn>` applies exactly as to any H gap.** **The ledger head is ground,
never a trigger and never audited** — read-only, outside every glob and outside
the scoped-run write set.

Both read the artifacts as they stand. A Scope-H run has no snapshot of its
own: it is a health reading of the live estate, and its findings are what the
next Scope-F snapshot will bind to.

## The entry

Append to `.specify/gate-health.md` — deliberately outside `.specify/memory/`,
so the gate never audits its own ledger, an H run's write-back never fires
another H run, and no operational state reaches the coding agent's context.
The template at `.specify/ba/templates/gate-health.md` carries the shape. Two
disciplines: the **head is rewritten in place**, run entries are **append-only**.

```
## Health run <n> — <date> — <full | scoped: <artifact>> — <trigger>
Coverage: …
Scope rationale: …
Verdict: HEALTHY | <n> gaps

Gaps:              CC-H-<nn> FAIL — <element>: <what is wrong> → <fix action>
HA review (P8):    HA-<nn> — re-affirmed <initials> | lapsed <initials> · revisit: <event>
Voided certifications: …
```

Update the head's **Current gaps & acceptances** with the standing gaps and the
HA records, each gap marked `[covered by HA-<nn>]` or `[live]`.

**A scoped run is silent unless it FAILs.** Do not print a clean scoped result;
that silence is the contract's rule and the reason scoped runs can fire on
every framework write without becoming noise.

## Fixing a gap

The gate never writes upstream. Route every gap: proposed edit → BA approves →
write → the scoped run for the touched artifact fires (silently, if clean).
`/ba-reopen` is the lane when the gap contradicts gated Band-1 content.

## Health acceptances — the only H instrument (P1 · P8)

Scope-H gaps take **no per-feature waivers**: a W-record is feature-scoped by
construction, and accepting shared-artifact rot through one feature's waiver
would be incoherent. The instrument is the project-level **`HA-<nn>`**, same
fields as a waiver (reason · risk accepted · approver · revisit trigger),
recorded in the ledger head.

- **Admission only.** An HA lifts a Stage-0 block and nothing else. No Scope-F
  assertion ever reads it; it satisfies nothing. A run it admits cites it:
  "Pre-flight: <n> gap(s) lifted by HA-<nn>". Safety holds — the Scope-F
  assertions still guard the same ground wherever the gap actually bites a
  feature.
- **Persistence** — the override's mechanism, one layer up. When the accepted
  gap's artifact is edited, the scoped run re-evaluates: evidence unchanged at
  element granularity → the HA **auto re-applies**, logged; evidence changed or
  the gap reshaped → the HA **voids**, the gap goes live, admission blocks
  return, and a fresh grant is possible at the next P1. Voiding on real change
  creates the fix-it pressure at the natural moment; auto re-apply keeps an
  unrelated edit from re-blocking every feature's admission at once.
- **P8 — review cadence.** Every **full** run lists each standing HA, one line:
  re-affirm (initials) or lapse. Display the revisit trigger at that moment —
  the lazy read; no scheduler exists.
- **Granting one (P1).** Refuse a grant whose revisit trigger is a date wish
  rather than an event, or whose risk line is missing. An HA's blast radius is
  every feature's admission; it is the most expensive acceptance in the
  framework and gets the strictest record.

## The voided-certification notice

When a framework write voids a certified-but-unhandedoff feature's PASS, emit
**one line**, even on an otherwise silent scoped run:

```
PASS of <NNN> voided by <artifact> edit — cheap re-gate recommended
```

This is **P6**: the BA routes the fix and queues the cheap re-gate for that
feature. The silence rule governs *check results*; a voided certification is a
pass-binding state change, and announcing it at write time beats discovering it
at handoff. The adapter's hash check remains the guarantee either way — this
notice is a courtesy, not a control.

## What this skill never does

Never edits an artifact to make a gap go away · never grants an acceptance on
the BA's behalf · never runs a Scope-F assertion · never blocks anything
directly — the block lives at `/ba-gate`'s Stage 0 · never writes inside
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
