---
name: ba-t12
description: T-12 — Roles & permissions, incl. the persona-to-role transformation. Serves Requirements against AT-RQ-2. Derives roles from the actors Band-1 artifacts reference, pre-drafts one explicit policy row per role x entity x action tuple with entities verbatim from the domain model, screens persona names out, and writes .specify/memory/roles-permissions.md.
disable-model-invocation: true
---

# `/ba-t12` — roles & permissions

**Serves:** Requirements. **Class:** Governance ·
**Destination:** `.specify/memory/roles-permissions.md`.

The role model and the resource × action policy — **every role any Band-1
artifact references, defined once**, with explicit policy rows for the tuples
Band-1 evidence exercises. The decision this run lets the BA make: who may act,
on what, and how far — stated as rows a checker and a coding agent read
identically.

**This file is the authorization principle's enforcement surface, never its
statement.** *"Never infer permissions from personas"* is a constitutional
principle and lives in `constitution.md`. This run applies it; it does not
author it, and the file's header says so in one line.

**Governance grade throughout: every role and every row is a BA ruling.** No row
enters unruled. The per-row evidence line is what makes the later per-tuple
sign-off cheap — the BA signs its evidence even when the gate passes.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t12`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{roles + one explicit policy row per role × entity × action tuple, entities verbatim from the domain model, zero persona names · Governance · .specify/memory/roles-permissions.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect requirements` to open and
compose. **Run after the domain model** — entities must exist before policy rows
reference them by name.

**Skip-if — refuse the run and say so:** AT-RQ-2 reads met in the current
evidence table — every referenced role defined, and the persona clause **clean or
dormant** (dormant is what charter absence leaves it, and charter absence is
legal). Exhaustive matrices for tuples no Band-1 evidence exercises are
**enrichment on BA ask**.

## Depth boundary — governance seed grade, and it is a hard edge

Per role: **name · one-line mandate · derivation evidence · source**. Per policy
row: **one explicit role × entity × action tuple with its rule/scope qualifier
and source**.

**Must NOT expand into:**

- **inferring permissions from persona narrative.** Where charters exist, the
  **system-facing activity lines are the only charter input**. Goals, behaviors
  and frustrations never reach this file.
- authoring the constitution's principle text — that is the constitution's ground
- **minting persona-named roles or actors.** The persona namespace and the role
  namespace are disjoint, and the screen is mechanical.
- **complete per-feature tuple coverage for unsliced features.** The seed covers
  Band-1-evident tuples. Later tuples enter by the gate and reopen paths, and
  that is the design.
- UI permission surfaces or screen grades — governance-standards and `/plan`
  ground · journeys — the process run's ground

## Inputs loaded

In this order:

1. `.specify/memory/domain-model.md` — **first**: the entity reference surface
   the policy rows cite verbatim
2. `canvas.md` — §7 function-line actors, the primary derivation evidence
3. `.specify/memory/stakeholders.md` — the register, for the population anchors
4. `.specify/memory/personas.md` **where it exists** — read for exactly two
   things and nothing else (see step 3)
5. `.specify/memory/glossary.md`
6. the current roles file — **arrival is never gated**; routed role or permission
   findings already in it are input

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — after
   the domain model.

2. **Framework act — role derivation.** Candidate roles come from the actors
   Band-1 artifacts reference: canvas function-line actors, register activity
   rows. **A population or individual referenced as no actor derives no role** —
   a stakeholder is register ground, and an authorization role exists only where
   references or features exercise it. Cite or mark per candidate.

3. **Framework act — the transformation, conditional.** It runs **iff
   `personas.md` exists**, exactly as the persona clause is conditional. Per
   charter:

   - the charter's **register population anchor** resolves the candidate
   - the charter's **system-facing activity lines** are read as role-and-action
     evidence — **the sole transformation input**
   - the **namespace screen**: no persona name may surface as a role, an actor,
     or a row cell. The screened set is the charter file's names.

   Where no charters exist, say so and move on. The transformation being dormant
   is a legal state, not a gap.

4. **Framework act — policy pre-draft.** Per derived role, **explicit tuple
   rows** — one row per role × entity × action, each citing its function line,
   activity line or routed finding. **Entity cells verbatim from the domain
   model.** A scope qualifier no source states is drafted and marked, never
   guessed. Remaining holes become destination-tagged questions — a role's
   mandate, a row's scope.

5. **BA act — the rulings.** Every role and every row is a governance ruling; **no
   row enters unruled.** A finding contradicting **cleared** ground — the
   register, a canvas line — is a **reopen signal**.

6. **Framework act — write and report.** Screen the namespace at write time, then
   write `roles-permissions.md`. Report which criteria the run moved — AT-RQ-2 —
   and what remains open. The evidence-table refresh and the confirmation
   proposal belong to `/ba-run`'s post-run touchpoint; the clearing itself is the
   BA's, at `/ba-clear`.

## Output

`.specify/memory/roles-permissions.md` — a one-line header pointing at the
constitution for the principle, then **two sections, these names, this order**:

`## Roles` · `## Policy`

Roles carry `| Role | Mandate (one line) | Derived from | Source |`. Policy
carries `| Role | Entity | Action | Rule / scope | Source |`.

**One explicit row per tuple. No wildcard cells, no role inheritance.** The row
grain equals the check grain: the per-tuple sign-off and the registry-consistency
read both read rows, not expansions. A `*` in an Action cell makes tuple presence
a computed fact and the sign-off's evidence indirect.

**Zero persona names anywhere in the file.**

The template and a worked example are in `references/example.md`.

Plus routed batches where the rulings demand them.

## Signals

- **Routing batch** — findings whose home is another artifact: a new entity to
  the domain model, a population to the register. Proposed, BA-approved, then
  written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Deferred role** — a role the evidence implies but nothing yet exercises is
  recorded as a deferral with an **event-shaped trigger**, not as a speculative
  row. It enters when its evidence does.

## What this skill never does

Never infers a permission from a persona's goals, behaviors or frustrations ·
never writes a persona name into any cell · never states the authorization
principle — it points at the constitution · never writes a wildcard row or an
inheritance clause · never cites an entity the domain model does not define ·
never lets a row enter unruled · never invents tuples for features that do not
exist yet · never maps a journey or authors a screen permission · never edits
`domain-model.md`, `stakeholders.md` or `constitution.md` outside an approved
batch · never confirms an AT criterion or clears an aspect · never runs a CC
assertion.
