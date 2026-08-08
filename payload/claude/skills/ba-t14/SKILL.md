---
name: ba-t14
description: T-14 — Design & UX standards. Serves Requirements against AT-RQ-1 via the constitution-reference clause. Sweeps the estate for design and UX ground, runs the conditionality check first, pre-drafts named global budgets and product-wide conventions in the name-metric-target-condition grammar, and writes .specify/memory/design-standards.md.
disable-model-invocation: true
---

# `/ba-t14` — design & UX standards

**Serves:** Requirements. **Class:** Governance ·
**Destination:** `.specify/memory/design-standards.md`.

The global design & UX governance surface: **the product-wide budgets and
conventions every feature spec references and deltas against, never restates**.
The decision this run lets the BA make: which experience commitments are
product-wide governance — stated once, referenceable, delta-able — and which are
feature or `/plan` ground.

**This file is the governance half of a split, and the other half is not yours.**
The *global standard* lives here; concrete screens, components and layouts stay
`/plan`'s. A budget named here is what a spec's category line points at when it
writes `N/A — covered by the global <name> budget; no feature-specific delta`.

**This run is evidence-conditional, and the conditionality check comes first.**
Where no design/UX ground exists in Band-1 evidence — a headless product, an API
— the honest output is *no file*, recorded on the aspect record. A file of empty
headings is the one outcome this run must not produce.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t14`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{design & UX standards at global grade — named budgets, product-wide conventions, each section real or ruled · Governance · .specify/memory/design-standards.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect requirements` to open and
compose. **Run before the constitution** where both are planned, so the
constitution's design reference resolves to an existing file at its own
authoring.

**Skip-if — refuse the run and say so:** AT-RQ-1's design slot reads met — the
file present, seeded, stub-free — **or** the conditionality branch stands ruled:
no design/UX ground, no constitution reference, the omission on the aspect
record. A full design system or component-level standards are **enrichment on BA
ask**, and the deeper surface is `/plan` ground regardless.

## Depth boundary — global-standard grade, and it is a hard edge

Per budget: **name · metric · target · condition · source**. Per convention: **one
product-wide statement with its source or ruling**.

**Must NOT expand into:**

- **feature NFRs or feature deltas.** A threshold that binds one capability only
  is spec ground, and it is surfaced as such rather than absorbed here.
- **restating a constraint as a budget.** A constraint has an imposer and lives
  in `constraints.md`. A budget derived from one **references** it.
- screen flows, component specs, wireframes or UI layouts — `/plan` ground
- **inventing industry-default budgets no evidence grounds.** An ungrounded
  candidate is drafted and marked, or asked. It is never silently seeded because
  it sounded professional.

## Inputs loaded

In this order:

1. `canvas.md` — §6 Forms (delivery-form commitments), §9 Localization
   (presentation-relevant lines), §12 Objectives (experience claims)
2. `.specify/memory/constraints.md` — rows with UX bite; the ones a budget may
   derive from and must not restate
3. `.specify/memory/context.md`
4. `.specify/memory/glossary.md`
5. presale and kickoff material, transcripts
6. the current `design-standards.md` — routed arrivals are input

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — before
   the constitution.

2. **Framework act — the ground sweep, conditionality first.** Sweep the estate
   for design/UX evidence: delivery-form commitments, localization lines,
   objectives with experience claims, constraint rows with UX bite, transcripts,
   routed arrivals. **If the sweep finds no design/UX ground, report exactly
   that and stop at the BA ruling** — the omit branch, recorded on the aspect
   evidence. Never a file of empty headings.

3. **Framework act — budget pre-draft.** One named row per product-wide
   commitment the evidence grounds, in the **name · metric · target · condition ·
   source** grammar, cite or mark per row. A target the evidence implies but no
   source states is **drafted and marked for ruling**. Feature-shaped candidates
   — a threshold binding one capability only — are surfaced as spec ground and
   left out.

4. **Framework act — conventions and references pre-draft.** Product-wide
   interaction and language conventions with their sources; brand and
   design-system material carried as references where supplied, `open — no source
   material` where not. Remaining holes become destination-tagged questions.

5. **BA act — the rulings.** Every budget row and every convention is a
   governance ruling; **no row enters unruled**. Marked targets are confirmed or
   dropped; each `N/A — <reason>` and each `open` is ruled as such. A budget
   fighting a Confirmed constraint row is a **reopen signal**.

6. **Framework act — write and report.** Write `design-standards.md`. Report
   which criteria the run moved — AT-RQ-1's design slot — and what remains open.
   The evidence-table refresh and the confirmation proposal belong to `/ba-run`'s
   post-run touchpoint; the clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/design-standards.md` — a two-line header stating the
reference-never-restate rule, then **three sections, these names, this order**:

`## Global budgets` · `## UX & interaction conventions` ·
`## Visual identity & references`

Budgets carry `| Budget | Metric · target · condition | Source |`. Conventions
carry `| Convention | Statement | Source |`. Visual identity carries real
references, or `open — no source material`, or `N/A — <reason>`.

**Budgets are named rows, and the name is the citation target.** No new line-ID
family is minted here: nothing downstream cites a budget by number, and a
citation reads *"the global accessibility budget"*. An ID family nothing reads is
machinery, not discipline.

The template and a worked example are in `references/example.md`.

Plus routed batches where the sweep found cross-cutting ground.

## Signals

- **Conditionality report** — when the sweep finds no design/UX ground, the
  report itself is the output: what was swept, what was found, and the proposal
  to omit the file and its constitution reference.
- **Routing batch** — a swept finding whose home is another artifact: a
  constraint to `constraints.md`, a surface commitment to the canvas. Proposed,
  BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Spec-ground referral** — a feature-shaped threshold, named and handed to the
  spec side rather than absorbed. Reporting it is the whole action.

## What this skill never does

Never writes a feature NFR or a feature delta · never restates a constraint row
as a budget — it references it · never invents a target no evidence grounds ·
never mints a budget ID family · never descends into screens, components or
layouts · never writes a file of empty headings when the sweep came back empty ·
never lets a row enter unruled · never edits `constraints.md`, `canvas.md` or
`constitution.md` outside an approved batch · never confirms an AT criterion or
clears an aspect · never runs a CC assertion.
