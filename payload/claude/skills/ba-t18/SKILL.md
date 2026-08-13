---
name: ba-t18
description: T-18 — Scope allocation, repeatable. Recommends a phase per epic in the four locked factors, renders the recommendation as a diff against the current allocation, and on BA approval writes the Phase cells and appends one Allocation-log entry — including on a no-change rerun. Reads the scope frame read-only and carries one scope-frame advisory per run; accepts BA directives, parsed into three named buckets. Owns the Phase column and the log, and nothing else in the roadmap.
disable-model-invocation: true
---

# `/ba-t18` — scope allocation (repeatable)

**Serves:** the Band-2 act, re-runnable. **Class:** Context ·
**Destination:** `.specify/memory/roadmap.md` — the Phase column and the
`## Allocation log`, and nothing else in the file.

Allocation is **an on-demand, repeatable act — never a phase of the process.**
The run recommends a phase per epic with a rationale in the four locked factors,
presents it as **a diff against the current allocation**, and on BA approval
writes the phases and appends the logged entry — diff plus reason — that the
health check reads.

The decision this run lets the BA make: **what gets built when** — re-decidable
whenever scope knowledge changes, with every change on the record and carrying
its reason.

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t18` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** recorded under the plans file's
> `## Band 2` section, **with its output contract pinned**:
> `{the recommended allocation as a diff vs. current — changed rows from → to with a factor-tagged reason, held rows one line, the four-factor basis — and on approval the Phase cells plus one Allocation-log entry · Context · .specify/memory/roadmap.md}`.

**Name the trigger at invocation.** Every run records under `## Band 2` with its
trigger stated, because the trigger is what the log entry carries and what the
next run's skip-if is measured against.

**Skip-if — refuse the run and say so:** the current allocation stands approved
and **no event has occurred since the last log entry**. The suggestion engine
proposes no run without a named event. A BA-elected run without one is entirely
legal — it logs like any other, and its trigger is the election.

The event set, each with its ground:

| Trigger | The ground |
|---|---|
| **post-decomposition** | rows stand at `Unallocated` — the initial run; what completes the Tier-1 row shape before any kit reads it |
| **post-call** | an ingestion closed: a brief newly `Scoped` or supplemented means scope knowledge changed |
| **delivery learnings** | a cycle closed, or a gate finding named "a Band-2 allocation act" — the BA's decision to rerun, not a signal class |
| **priority shift** | BA-declared: a sponsor or market change. The declaration itself is the trigger, and it is logged as the entry's trigger |
| **scope-frame** | the scope frame is set or changed at P-O0b (scope-frame selection): a budget appears or changes, the delivery boundary moves, or the capacity check fails against the current composition. You **propose** the reallocation with its basis; every mechanic below is unchanged |

**Never this run's ground:** feature sequencing inside a phase, and next-feature
selection — both BA acts at the roadmap.
Epic-set changes belong to T-17 — Epics decomposition.

**On a pass** — render one line:
`T-18 — Scope allocation → .specify/memory/roadmap.md`, and begin. No
confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect` to compose the Band-2 plan, or `/ba-close-band1` where
Band 1 does not yet stand closed. Nothing else runs; nothing else is explained.

## Depth boundary — phase grain, and it is a hard edge

Per epic: **one phase from the project ladder, plus a factor-tagged reason.**
One set-level basis line.

**Effort enters as comparative judgment from estate evidence** — slicing breadth
in the briefs, connection count, constraint load. **Never numeric estimation:**
story points, day counts and velocity are delivery ground and deliberately not
this technique's.

**The capacity check is no exception.** Its rough sizing (P-O0b — scope-frame
selection) lives **only in this run's advisory prose** and enters no artifact —
not the roadmap, not a WBS, not a spec. The depth rule stands exactly as
written.

**Must NOT expand into:**

- **editing rows, names, descriptions or sources.** Those columns belong to
  T-17 — Epics decomposition. A set-change need is proposed as a
  T-17 (Epics decomposition) rerun.
- **flipping statuses.** Status writes are routed edits at band events, owned by
  the routing discipline.
- **slicing features or settling scope questions.** An allocation blocked on an
  open scope question **recommends the call — never the answer.**
- **emitting a delivery sequence inside a phase.** Dependency order is a
  rationale factor; a sequence column would duplicate the BA's own selection act.
- **retiring or creating epics.** An epic leaving scope is proposed as a routed
  pair on the T-17 — Epics decomposition side — graduation reversed. **`Later`
  is a phase, not an exit.**
- **writing a number into any artifact.** Capacity figures are advisory prose
  and nothing else.

## The four factors — the whole rationale vocabulary

Every reason is tagged with the factor (or factors) that decided it:

| Factor | What it weighs |
|---|---|
| **value vs. effort** | what the epic moves against what it costs, effort read comparatively from the estate |
| **dependency order** | what must exist first for this epic to be real |
| **risk** | what is unsigned, unproven, or unowned — and whether the phase should absorb it or wait |
| **walking skeleton** | the MVP rule, stated once: **MVP composes the thinnest end-to-end slice of the core value journey — an MVP row earns its place on that slice or as its dependency.** |

An untagged reason is not a reason. If none of the four decided it, the honest
entry says which BA judgment did.

**The budget envelope enters inside value vs. effort**, as its constraint
ground — a reason may name it directly (`reason: envelope`). **No fifth factor
is created:** the four above are locked, and effort already owns the constraint
side.

## The write discipline — one file, three writers

**Yours are the Phase column and the `## Allocation log`.** Row existence, ID,
Epic, Description and Source — the citations' ground-class included — belong to
T-17 — Epics decomposition; Status flips
are the routing
discipline's. A run needing another writer's ground **proposes that run or a
routed edit — never an inline fix.**

The roadmap carries **outcomes and reasons only.** A BA edit against the
recommendation is a one-line note in the run log — tuning input — and never a
line in the roadmap.

## Inputs loaded

1. `.specify/memory/roadmap.md` — the current rows and the standing log. **The
   last entry is the diff baseline**; without reading it there is no diff.
2. `.specify/memory/scope/*.md` — every brief that exists: essential scope,
   boundaries, §5 assumptions & risks, §8 slicing breadth
3. `.specify/memory/constraints.md` — time-bound and business rows
4. `canvas.md` — the value ground: `→ O-n` links, `P-n` severity
5. dependency ground: `.specify/memory/domain-model.md` relations · canvas
   connection rows · the journeys in `processes.md` the core value line crosses
6. `.specify/memory/out-of-scope.md` — resolved rows carry phase hints on the
   epics they graduated into
7. `.specify/aspect-state.md` — the ledger head's scope-frame fields:
   `Boundary:` · `Budget:` · `Parameters:` · the derived `Capacity:`.
   **Read-only.** This run never writes a ledger.
8. on rerun: delivery state — the roadmap statuses, and any closed cycles

## Procedure

1. **BA act.** Invoked on an event or by election; the trigger is named. The
   invocation optionally carries **directives** — free text, or explicit
   `<epic> → <phase>` moves, with reasons where the BA gives them. They are
   parsed at step 3.

2. **Framework act — evidence assembly.** The inputs above, read against the
   current allocation. State the baseline explicitly: which log entry this diff
   is measured from.

3. **Framework act — the recommendation.** Per epic a phase and a reason tagged
   with its deciding factor(s). Rendered **as the diff**:

   - **changed rows** in `from → to` form, each with its factor-tagged reason
   - **held rows** on one line
   - **the basis** — one line across the four factors

   Where an allocation is blocked on an open scope question, **name the question
   and the Tier-1 act that answers it.** Do not guess the answer: that is
   principle 3 at phase grain.

   **The scope-frame advisory — one per run, on the record.** Visibility, never
   a block; the BA's call stands.

   - *Number-free form, always.* Name every epic sitting in a phase **inside the
     delivery boundary** without a trace to either legitimacy test — the product
     cannot meet its business goal without it, or the client hard-requested it
     in the docs — and say what is missing.
   - *The class reads mechanically.* A `[stated]` row carrying a hard-request
     citation satisfies the second test on its face. **`[inferred]` rows inside
     the boundary are the advisory's first-named candidates — first-named,
     never disqualified:** an `[inferred]` row the product cannot meet its goal
     without passes the first test exactly as a stated one does. The two tests
     are the composition half of **principle 4**; the class makes them
     checkable at the row, and settles nothing on its own.
   - *With `Capacity check: on`,* add the rough comparison, explicitly
     assumption-grade: `MVP phase ≈ <n> eng-h against capacity ≈ <m> — rough,
     assumption-grade. Slide-down candidates: <epics>.` With the check `off` the
     advisory stands in its number-free form and **nothing else changes.**

   Its record is this run's output and the plans-file run log — **never the
   roadmap.** That file carries outcomes and reasons only, and a capacity figure
   written into it would breach the numbers-in-advisory-prose-only rule.

   **Directed reallocation — the optional input, parsed into three buckets, each
   named in the run output:**

   | Bucket | What you do with it |
   |---|---|
   | **phase-shaped** — "Authentication to Phase 2", "keep all AI epics in MVP, slide the rest", "squeeze MVP to fit 40K" | Translate into a move list, **echo it back** (*"understood as: …"*), and apply it as **pinned rows tagged `BA-directed`** in the diff |
   | **not phase-shaped** — a split, a merge, a new epic, "cut it entirely", a cost question | **Routed as proposals, never executed inline.** A set change proposes a T-17 (Epics decomposition) rerun · "cut it entirely" proposes `Later` or a retire act, the BA picking · a cost question is answered in capacity-check prose, not a diff |
   | **impossible** — an unknown epic, an off-vocabulary phase, self-contradicting directives | **Named lines in the response**, never a silent skip |

   **Never contest a directive.** Compute its consequences through the four
   factors and render those as recommendations with reasons. A directive that
   conflicts with a factor produces **a named advisory in the same diff — never
   a block.** A partial directive ("X into MVP", nothing else) leaves you to
   propose what slides down to fit.

   **One run → one diff → one approval → one log entry**, whatever the input
   shape.

4. **BA act — edit and approve.** The BA edits and approves; **the approved diff
   is the ruling.** A BA edit against the recommendation is noted one line in the
   run log.

5. **Framework act — write.** Phase cells updated; **one** log entry appended.

   **Every approved run logs, including no-change.** A rerun that moves nothing
   appends `no change — <reason>`: the review act is audit ground even when the
   picture holds, and a silent rerun is indistinguishable from a rerun that never
   happened. The armed scoped health check fires silently on the write; its
   M-check reads this entry for its diff and its reason.

6. **Framework act — boundary routing.** What is not phase-shaped leaves:

   | Finding | Where it goes |
   |---|---|
   | a set-change need — split · merge · new · retire | a **T-17 (Epics decomposition) rerun proposal** |
   | a contradiction with gated Band-1 content | a **reopen signal** (`/ba-reopen`) |
   | an open scope question | **that epic's Tier-1 act** |

## Output

Appended to `.specify/memory/roadmap.md` under `## Allocation log`:

```markdown
### Allocation <n> — <date> · trigger: <post-decomposition | post-ingestion E-nn | cycle close NNN | priority shift | scope-frame | BA-directed> · BA: <name>

| Epic | Phase | Reason |
|---|---|---|
| E-<nn> <name> | <from> → <to> | <factor(s) | BA-directed>: <reason> |

Held: <unchanged rows, one line> · Basis: <one line across the four factors>
```

or, for a rerun that moved nothing:

```markdown
### Allocation <n> — <date> · trigger: <…> · BA: <name>
no change — <reason>
```

**Entries are numbered and append-only.** The log is never rewritten: an entry
that later proved wrong is superseded by the next entry, never edited into
agreement with it.

**The phase ladder is project-defined and single-valued:** `MVP` first, then
numbered phases (`Phase 2`, `Phase 3`…), with `Later` as the open tail.
`Unallocated` is a birth value only. **No span notation** — an epic whose scope
spreads across phases keeps that spread in the brief's Deferred section, where it
belongs to the epic's own scope decision.

The template and a worked example are in `references/example.md`.

## Signals

- **T-17 — Epics decomposition rerun proposal** — a set-change need, named and
  handed back.
- **Reopen signal** — a contradiction with gated Band-1 content. Emit and stop.
- **Tier-1 referral** — an open scope question blocking a phase call: the
  question and the act that answers it, never a guessed answer.
- **A directive that is not phase-shaped** — routed as a proposal, named in the
  run output, never executed inline.

## At run end — compiled bookkeeping

1. **The primary output lands** at its contracted destination — this run's own
   act under its pinned contract.
2. **Cross-cutting findings route** as one proposed batch: the framework
   assembles the edits · the BA approves the batch · the framework writes. In
   Band 1 proper Scope H is disarmed and nothing fires; post-closure runs get
   the armed cadence automatically.
3. **Run log** — append under `## Band 2` in `.specify/aspect-plans.md`,
   each rerun naming its trigger:
   `<date> · <CODE> · contract: fulfilled | partial — <what is missing> | failed — <why>`
   `  signals: RO-<n> received | routing batch <ref> approved | none`
   Then set the plan row's Status to `run <date>`. `partial` and `failed` are
   recorded, never silently retried.

## What this skill never does

Never edits a row, a name, a description or a source · never flips a status ·
never creates or retires an epic · never slices features · never sequences work
inside a phase · never estimates in numbers · never writes a span of phases ·
never guesses past an open scope question · never skips the log entry on a
no-change rerun · never rewrites a standing entry · never approves its own
recommendation · never fires a health run · **never writes a capacity figure
into the roadmap, a WBS, a spec or any other artifact** — the advisory's numbers
live in its prose and nowhere else · never sets or edits the scope frame, and
never writes a ledger · never contests a BA directive, and never executes a
directive that is not phase-shaped inline.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
