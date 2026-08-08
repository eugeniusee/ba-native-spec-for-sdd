---
name: ba-t15
description: T-15 — Constitution. Serves Requirements against AT-RQ-1 and the persona-principle clause of AT-RQ-2. Seeds the two framework principles unconditionally, sweeps the estate for project principles through the principle-vs-detail screen, resolves the Governance-class reference spine, and writes .specify/memory/constitution.md.
disable-model-invocation: true
---

# `/ba-t15` — constitution

**Serves:** Requirements. **Class:** Governance ·
**Destination:** `.specify/memory/constitution.md`.

The project constitution: **the named, testable principles that bind everything
downstream of the gate**, plus the reference spine to the governance files
carrying their detail. Principles live here; detailed matrices live in the
referenced files. The decision this run lets the BA make: which commitments are
constitutional — binding on every feature and every downstream agent — and which
are detail for a referenced file.

**This is the file the coding agent's plan step actually reads.** Write it for
that surface: **MUST-form statements a check can gate a plan against**, never
aspiration. A principle a check could not gate a plan against is rewritten
testable or demoted to a referenced file's detail.

**It authors the principle the whole authorization chain leans on** — *never
infer permissions from personas*. The roles file is that principle's enforcement
surface; the per-feature spec check is its enforcement act; **this file is its
statement**, and nowhere else states it.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t15`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{constitution at principle grade — named MUST-form principles incl. the two framework seeds, plus the Governance-class reference spine · Governance · .specify/memory/constitution.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect requirements` to open and
compose. **Run after the roles model** — the Authorization principle's
enforcement surface must exist to be named — **and after design standards where
design ground exists**, so every reference resolves at authoring.

**Skip-if — refuse the run and say so:** the constitution is present, seeded,
stub-free, **every reference resolving**, and the persona clause
satisfied-or-dormant. Dormant is what charter absence leaves it — and the
Authorization principle stands regardless. Enrichment beyond principle grade is
**on BA ask**.

## Depth boundary — principle grade, and it is a hard edge

Per principle: **name · MUST-form statement · enforcement surface · source**,
plus the Governance-class reference spine.

**Must NOT expand into:**

- **matrices, policy rows or budget tables.** Those are the referenced files'
  ground. A detail-heavy candidate routes to its file and **the principle stays**
  — one line, pointing.
- **restating writing-standard or gate machinery as principles.** Requirement
  grammar, table discipline, reference-never-restate: those are pre-handoff rules
  the gate enforces on the spec, not rules the plan check enforces on the plan.
  Restating them here re-enforces spec rules on the wrong artifact.
- authoring roles or budgets — the roles and design-standards runs' ground
- per-feature rules with formulas or thresholds — spec ground

## Inputs loaded

In this order:

1. `.specify/memory/roles-permissions.md` — the Authorization principle's
   enforcement surface must exist to be named
2. `.specify/memory/design-standards.md` where present — the conditional
   reference
3. `.specify/memory/constraints.md` — the **Confirmed** rows, the main source of
   project principles
4. `canvas.md` — §12 Objectives, for non-negotiables stated as objectives
5. transcripts, sponsor rulings and routed findings
6. `.specify/memory/glossary.md`
7. the current `constitution.md` — routed arrivals are input

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — last of
   the governance chain, so every reference resolves.

2. **Framework act — seed the framework principles.** Two, and both enter
   **unconditionally**:

   - **Authorization** — permissions derive from the roles file's policy rows
     only; **never inferred from personas or narrative material.** Seeded whether
     or not charters exist: the per-feature check names this principle as its
     basis without conditioning on personas, and seeding it now costs one line
     and pre-empts a retrofit the day charters arrive.
   - **Spec-first iteration** — requirements defects are fixed in the spec and
     re-run downstream, **never hand-patched in code.** This is the one house
     discipline that binds conduct *after* the handoff, which is exactly the
     surface the plan check reads.

   Each named, MUST-form, with its enforcement surface cited.

3. **Framework act — the evidence sweep.** Project principles from Confirmed
   constraint rows that bind product conduct globally, objectives stating
   non-negotiables, sponsor rulings, routed arrivals. Per candidate, the
   **principle-vs-detail screen**: a candidate carrying matrix- or row-grade
   detail **routes to its governance or context file, and only the principle line
   stays here**. Cite or mark per line.

4. **Framework act — the reference spine.** List the **Governance-class** estate
   this constitution binds. Each reference is checked to resolve to an
   **existing, stub-free file** — a reference that would dangle is a planning
   defect surfaced now, not a health failure discovered at arming.
   **Context-class files are never referenced here**; the spine is
   Governance-only.

5. **BA act — the rulings.** Every principle is a BA ruling. Apply the plan-check
   note at review: **a principle a check could not gate a plan against is
   rewritten testable or demoted** to a referenced file's detail. A candidate
   contradicting cleared ground is a **reopen signal**.

6. **Framework act — write and report.** Write `constitution.md`. Report which
   criteria the run moved — AT-RQ-1, plus AT-RQ-2's persona clause read
   met-or-dormant — and what remains open. The evidence-table refresh and the
   confirmation proposal belong to `/ba-run`'s post-run touchpoint; the clearing
   itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/constitution.md` — a short header naming the plan check as its
reader and the reference-never-restate split, then **two sections, these names,
this order**:

`## Principles` · `## Governance references`

Principles carry
`| Principle | Statement (MUST form) | Enforcement surface | Source |`.
Governance references carry `| File | Carries |`.

**Principles are named, not numbered.** Nothing cites a principle by line, so no
ID family is minted.

**The references table is the checked set.** Editing the spine changes what every
future health run and every future gate run reads — it is the definition of
*"the constitution plus every governance file it references"*, and it is hashed
into every certification manifest.

The template and a worked example are in `references/example.md`.

Plus routed batches where the screen sent detail to its files.

## Signals

- **Routing batch** — the detail half of a screened candidate, proposed to its
  own governance or context file. Proposed, BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Dangling reference** — a spine entry that would not resolve, reported as a
  planning defect before the file is written, with the run that would fix it
  named.

## What this skill never does

Never carries a matrix, a policy row or a budget table · never authors a role or
a budget · never restates spec-shape rules as principles · never writes a
principle no check could gate a plan against · never references a Context-class
file in the spine · never references a file that does not exist or is a stub ·
never conditions the Authorization principle on personas existing · never mints a
principle ID family · never edits a referenced governance file outside an
approved batch · never confirms an AT criterion or clears an aspect · never runs
a CC assertion.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
