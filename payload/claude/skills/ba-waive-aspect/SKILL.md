---
name: ba-waive-aspect
description: P-O5 - aspect-waiver acts: grant an AW so a threshold-missing aspect still grants progression, re-affirm standing waivers at band acts and head renders, or lapse one. Project-numbered AW-<n> records with named unmet criteria, reason, risk accepted, approver and an event-shaped revisit trigger. Lapse is not reopen.
disable-model-invocation: true
---

# `/ba-waive-aspect <aspect>` — the AW acts

**Argument:** one of the six aspects (omit it for a re-affirmation pass over all
standing waivers).

The aspect layer's flexibility valve: *gates waivable with logged reason*. It
exists so a threshold that cannot be met **now** does not stall the whole DAG —
at the price of the debt being named and visible until it is paid.

## Invocation contract — check before you run

- **BA act, always.** You assemble the record and refuse an incomplete one; the
  BA grants, re-affirms and lapses. Never grant on inference from "the BA seems
  to want to move on".
- **A waiver attaches to a real, named miss.** Run `/ba-clear <aspect>` first if
  no evidence table exists: the AW's unmet-criteria field is copied from that
  table's misses, each with exactly what is missing. **No pre-emptive waivers** —
  a waiver on an aspect nobody has assessed accepts an unknown, not a risk.
- **This is not the gate's instrument.** An AW never lifts a Stage-0 admission
  block and never satisfies a CC assertion. See the distinctness table below.

## Granting — the record

`AW-<n>`, **project-numbered** (aspects are project-level; contrast the
contract's per-feature `W-<NNN>-<nn>`). Six fields, all required:

| Field | Content |
|---|---|
| AW ID | `AW-<n>` — next free number in this project |
| Aspect + unmet criteria | the AT-IDs not met, **each with exactly what is missing** |
| Reason | why progression proceeds anyway |
| Risk accepted | what downstream work now builds on, unverified — one line |
| Approver · date | the BA, by name |
| Revisit trigger | **event-shaped** ("when the compliance consultant reports"), never a date wish |

**Refuse the grant** when the unmet criteria are unnamed, when the risk line is
missing, or when the revisit trigger is a date wish rather than an event. Say
which field, and what would fix it. A waiver whose trigger is "in a few weeks"
is a waiver nobody will ever read again — the whole re-affirmation mechanism is
a *lazy read at defined touchpoints*, and only an event can be recognized at one.

Each stop here closes per §10.3 rule 9, under `What I need from you:`. The
assembled record's stop asks one plain lettered question — `a. grant the waiver as assembled (recommended) —
the record is complete and the debt named` · `b. hold — the aspect stays where
it is` · `c. edit a field first — name it`. A refusal's stop asks the one
question that fixes the named field. A re-affirmation pass asks one lettered
question per standing waiver, all in one AskUserQuestion call — `a. re-affirm
(recommended) — the revisit trigger has not fired` · `b. lapse it — the aspect
returns to open`; where the trigger has fired, `(recommended)` sits on the
disposition the fired event grounds.

Record shape, appended to `## Events` in `.specify/aspect-state.md`:

```
AW-1 · Context · unmet: AT-CX-2 — regulatory class has no confirmed constraint and no
  "none identified — <basis>" line
  reason: the compliance consultant is engaged but unavailable until August
  risk accepted: Vision and Solution proceed without a confirmed regulatory boundary
  approver: Y. Kliukin · 2026-07-09
  revisit trigger: when the compliance consultant reports
  status: granted
```

And the head line, one per standing waiver:

```
Standing aspect waivers:  AW-1 · Context · AT-CX-2 (regulatory) — revisit: consultant reports
```

**The transition:** T3 (`open → waived`) or T7 (`reopened → waived`, and the
record then **names the unresolved conflict, citing its RO**).

```
<date> · T3 · Context · open → waived · Y.K. — AW-1
```

## Expected profile debt — a class of this record, not a second instrument

**Read the ledger head's `Profile:` line while you assemble the record.** Where
**every** named miss in the unmet-criteria field resolves to an artifact whose
producing technique is **out of profile** in the standing profile's set, this
waiver is **expected profile debt** — the profile's own arithmetic, not a
judgement about the project. One miss on an in-profile technique's artifact takes
the whole waiver out of the class. Re-read the test at every render: an election
or a profile switch can move a waiver out of it.

**Nothing is added to the record.** Same `AW-<n>`, same six fields, same refusal
rules. Two field conventions fix how the class reads:

- **Reason** names the profile and the out-of-profile techniques whose artifacts
  the misses want — *"Presale profile: AT-RQ-1's remaining artifacts are the
  output of T-11 — Domain (conceptual) modeling, T-12 — Roles & permissions,
  T-13 — Core process mapping and T-15 — Constitution, all out of profile"* —
  never "we ran out of time".
- **Revisit trigger** stays event-shaped, and the canonical one is *"when the
  profile switches to Discovery, or any of the four is elected at
  P-O2 — plan composition"*. Both are events the ledger's Events line already
  records.

```
AW-2 · Requirements · expected profile debt · unmet: AT-RQ-1 — roles-permissions.md,
  domain-model.md, processes.md and constitution.md absent; their techniques are
  all out of profile under Presale
  reason: Presale profile — the destination is a scoped roadmap with draft specs;
    these four artifacts are out of the profile's technique set
  risk accepted: draft specs carry marked roles and unresolved entity names;
    CC-H-01 and CC-H-05 arm over the gap and keep policing it
  approver: Y. Kliukin · 2026-08-20
  revisit trigger: when the profile switches to Discovery, or any of the four is
    elected at plan composition
  status: granted
```

**Render it as the class wherever it renders**, and **argue it at no surface** —
named once, with its class, never as a finding, an anomaly, a defect or a gap the
run should have avoided, and never re-opened lower down or in the closing ask.
At the re-affirmation pass, `(recommended)` sits on `re-affirm` while the trigger
has not fired: re-affirming expected profile debt is a profile decision
confirmed, not an exception forgiven.

**The debt is still real.** Expected is not absent: the criteria stay named in the
head, and at closure the arming happens exactly as it always does — see the
effect below.

## Effect — exactly this much

A `waived` aspect satisfies prerequisites **exactly as `first-pass-cleared`
does**: dependents may open, and Band-1 closure counts it. The unmet criteria
stay named in the head as standing debt. That is the whole effect — a waiver
does not lower a threshold, does not make the missing evidence optional later,
and does not travel to any other layer.

One advisory, said once and not repeated: decomposing on a **waived Solution** is
decomposing a guess. Say it when Band 2 opens over one; the BA's call stands.

**Closure arms over this waiver, expected or not.** `/ba-close-band1` requests the
full Scope-H run exactly as it always does, and the assertions the debt touches —
CC-H-01 and CC-H-05 where the missing artifacts are theirs — **arm over the gap
and keep policing it**, lifted only by an `HA-<nn>` at the gate. A profile that
could disarm an assertion would be a restriction, and a profile is never one.

## Lifecycle

| Event | What happens |
|---|---|
| **Granted** | T3 or T7 |
| **Superseded by clearing** (T4) | the evidence completes, the BA confirms at `/ba-clear`, the AW closes `superseded — <date>` |
| **Lapsed** (T8) | the BA withdraws acceptance; the aspect returns to `open`; the AW closes `lapsed — <date>` |
| **Voided by reopen** (T5 from `waived`) | the conflict machinery supersedes it; the **RO record notes the voided AW** |

**Lapse is not reopen — and the difference matters.** Dependents cleared under
the waiver **keep their states**: their clearing was a valid act on the record.
What a lapse blocks is *new* progression through this aspect until it re-clears
or is re-waived. Content contradiction is the only thing that degrades a
dependent, and that arrives as a reopen signal, never as a lapse side-effect. Do
not flag or degrade dependents on a lapse.

## Re-affirmation — lazy, at defined touchpoints

Every standing AW is listed **one line each — re-affirm (initials) or lapse** at:

- each band-transition act (Band-1 closure, every Band-3 entry), and
- whenever a P-O prompt renders the ledger head.

**Display the revisit trigger at those moments.** That display is the mechanism;
**no scheduler exists.** At Band-1 closure the re-affirmation is explicitly *into
the armed state* — "carried past closure — debt visible to CC-H where it touches
spec-anchored ground."

Record each re-affirmation on the AW as a dated line; do not rewrite the original
record.

## Distinctness — three instruments, never conflated

| | **AW** (this skill) | **W-\<NNN\>-\<nn\>** (`/ba-gate`) | **HA-\<nn\>** (`/ba-gate-health`) |
|---|---|---|---|
| Layer | aspect gate | Scope-F assertion | Scope-H admission |
| Element | one aspect's named AT misses | one feature × assertion × element | one project-health gap |
| Grants | DAG progression + closure eligibility | feature PASS with the gap on record | Scope-F admission despite an H gap |
| Numbered | per project | per feature | per project |
| Home | `.specify/aspect-state.md` | feature `gate-report.md` | `.specify/gate-health.md` |
| Ruled at | **P-O5 — aspect-waiver acts, here** | P2 | P1 / P8 |

**Post-closure, debt on spec-anchored artifacts is HA territory** — the handover
rule. The AW remains the instrument only for aspect-layer acts (T3/T7), which
exist as long as aspects do.

## What this skill never does

Never grants, re-affirms or lapses on the BA's behalf · never accepts a record
missing its unmet criteria, its risk line, or an event-shaped trigger · never
waives an aspect nobody has assessed · never lifts a gate admission block, never
satisfies a CC assertion, never touches a W- or HA-record · never degrades a
dependent on a lapse · never edits content to close the debt it just recorded.

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
