---
name: ba-t18
description: T-18 — Scope allocation, repeatable. Recommends a phase per epic in the four locked factors, renders the recommendation as a diff against the current allocation, and on BA approval writes the Phase cells and appends one Allocation-log entry — including on a no-change rerun. Owns the Phase column and the log, and nothing else in the roadmap.
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

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t18`.

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

**Never this run's ground:** feature sequencing inside a phase, and next-feature
selection — both BA acts at the roadmap.
Epic-set changes belong to T-17 — Epics decomposition.

## Depth boundary — phase grain, and it is a hard edge

Per epic: **one phase from the project ladder, plus a factor-tagged reason.**
One set-level basis line.

**Effort enters as comparative judgment from estate evidence** — slicing breadth
in the briefs, connection count, constraint load. **Never numeric estimation:**
story points, day counts and velocity are delivery ground and deliberately not
this technique's.

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

## The write discipline — one file, three writers

**Yours are the Phase column and the `## Allocation log`.** Row existence, ID,
Epic, Description and Source belong to T-17 — Epics decomposition; Status flips
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
7. on rerun: delivery state — the roadmap statuses, and any closed cycles

## Procedure

1. **BA act.** Invoked on an event or by election; the trigger is named.

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
### Allocation <n> — <date> · trigger: <post-decomposition | post-ingestion E-nn | cycle close NNN | priority shift> · BA: <name>

| Epic | Phase | Reason |
|---|---|---|
| E-<nn> <name> | <from> → <to> | <factor(s)>: <reason> |

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

## What this skill never does

Never edits a row, a name, a description or a source · never flips a status ·
never creates or retires an epic · never slices features · never sequences work
inside a phase · never estimates in numbers · never writes a span of phases ·
never guesses past an open scope question · never skips the log entry on a
no-change rerun · never rewrites a standing entry · never approves its own
recommendation · never fires a health run.
