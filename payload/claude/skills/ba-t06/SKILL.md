---
name: ba-t06
description: T-06 — Constraints elicitation. Serves Context against AT-CX-2. Probes the binding rules class by class - technical, business, regulatory - to the silence-fails discipline, rules each candidate Confirmed or Assumed, closes every empty class with a sourced basis, and writes .specify/memory/constraints.md.
disable-model-invocation: true
---

# `/ba-t06` — constraints elicitation

**Serves:** Context. **Class:** Context ·
**Destination:** `.specify/memory/constraints.md`.

The binding rules — technical, business, regulatory — elicited **class by class**,
to the silence-fails discipline: **every class ends with confirmed rows or a
sourced `none identified — <basis>` line**, so downstream vision and spec work
cannot build on an unexamined absence. The decision this run lets the BA make:
which candidates are confirmed constraints, which stand as assumptions, and what
basis closes an empty class.

**A constraint is imposed, and its imposer is its source.** That is what separates
this run from landscape mapping: that sheet describes what exists, this one probes
for what **binds**. A solution decision with no imposer is a choice, not a
constraint, and it belongs to vision or solution work.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t06`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Context aspect, which is `open` or
> `reopened`, **with its output contract pinned**:
> `{constraints & limitations — three class sections, each a Confirmed row or none identified — <basis> · Context · .specify/memory/constraints.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect context` to open and compose.

**Skip-if — refuse the run and say so:** AT-CX-2 reads met in the current
evidence table — **every class shows a Confirmed row or its none-identified
basis**. Exhaustive constraint inventories beyond the threshold are **enrichment
on BA ask**, never a hole this run fills on its own initiative.

## Depth boundary — constraint grade, and it is a hard edge

Elicit **one binding statement per row — classed, statused, sourced**.

**Must NOT expand into:**

- **NFR budgets with metrics and targets.** A constraint says *"existing
  calendars stay in use"*; it never says *"sync completes within N seconds"*. The
  second sentence is a budget and belongs to the design-standards or spec NFR
  ground.
- business rules with formulas or thresholds — spec ground
- legal analysis beyond naming the binding regime and its bite
- **solution decisions dressed as constraints.** Ask for the imposer. If there
  isn't one, it is a choice.

## Inputs loaded

In this order:

1. `canvas.md` — the Context/Constraints element; each one-liner there should
   have a row behind it here
2. `.specify/memory/context.md` — the dispositions, which are binding candidates
   in descriptive clothing
3. the current `.specify/memory/constraints.md` — **routed constraints may
   pre-date any run. Arrival is never gated**, so rows already in the file are
   input, not duplicates to re-elicit.
4. presale material and any transcripts on hand

## Procedure

1. **BA act.** Under the composed Context plan, the run is invoked.

2. **Framework act — the sweep.** Gather candidates from the canvas one-liners,
   the landscape dispositions, the presale material, and the rows already in the
   file. **Each candidate is classed and carries its source** before it is shown
   to the BA.

3. **Framework act — class probes, into holes only.** Probe each class where the
   sweep left a hole, and nowhere else:
   - **technical** — systems retained or replaced · platform and hosting
     mandates · data residency
   - **business** — launch windows · budget and contract commitments · policy
     mandates
   - **regulatory** — personal-data regimes · sector rules · accessibility
     mandates

   Every probe is **destination-tagged**: a class row, or that class's
   none-identified ruling. **A probe an existing row already answers is illegal**
   — the sweep read the file precisely so this run does not ask the BA for what it
   is holding.

4. **BA act — the rulings.** The BA rules each candidate:
   - **Confirmed** — an imposer is on record
   - **Assumed** — implied by the material, no stakeholder confirmation. **This is
     a disposition, not a limbo:** the row is real, durable context, and a later
     call may flip its status.
   - **rejected** — not binding. Dropped, with the run log noting why.

   And rules each empty class's `none identified — <basis>`. **Silence fails: an
   empty class with no basis is a hole, not an answer.**

5. **Framework act — routing and asymmetry.** Where rows change what the canvas
   one-liners say, propose the canvas summary edit as a batch — the canvas keeps
   the one-liners, this file keeps the detail. A constraint contradicting
   **cleared** ground — the register, canvas Customers — is a **reopen signal**;
   within Context's own still-open content it is ordinary correction.

6. **Framework act — write and report.** Write `constraints.md`. Report which
   criteria the run moved — AT-CX-2, per class — and what remains open. The
   evidence-table refresh and the confirmation proposal belong to `/ba-run`'s
   post-run touchpoint; the clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/constraints.md` — **three numbered class sections, in this
order**: `## 1. Technical` · `## 2. Business` · `## 3. Regulatory`. Each carries a
table with three columns —

`| Constraint | Status | Source |`

— **or** the single line `none identified — <basis>`.

**`Status` is a two-value vocabulary: `Confirmed` or `Assumed`.** Nothing else.
The criterion that reads this file reads `Confirmed` mechanically, and a third
value or a decorated one breaks that read. Dates and callers belong in `Source`.

The numbered classes are the citation target downstream: `[constraints.md §2]`
resolves to the Business class. That is why the sections are numbered and why the
numbering does not move.

The template and a worked example are in `references/example.md`.

Plus a canvas-side proposed-edit batch where the rows change the one-liner
summaries.

## Signals

- **Routing batch** — canvas Context/Constraints summary edits; any finding whose
  home is another artifact. Proposed, BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Status flip** — when a later approved batch confirms an `Assumed` row, the
  flip is a write to this file with the confirming source recorded. It is an
  edit, not a new row, and the row keeps its place.

## What this skill never does

Never writes a metric, a target or a budget · never states a business rule
threshold · never records a solution choice as a constraint — if no imposer can
be named, it is not one · never leaves a class empty and silent · never invents a
`none identified` basis the BA has not ruled · never asks a probe an existing row
answers · never puts a date or a caller in the `Status` cell · never edits
`canvas.md` outside an approved batch · never confirms an AT criterion or clears
an aspect · never runs a CC assertion.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
