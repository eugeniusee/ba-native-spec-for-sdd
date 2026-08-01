---
name: ba-t03
description: T-03 Stakeholder register. Serves Stakeholders, the DAG root, against AT-ST-2 and AT-ST-3. Pre-drafts the project's cast - populations and decision-relevant individuals with role-in-project, decision rights and comms line - asks only destination-tagged questions for what is left, and writes .specify/memory/stakeholders.md.
disable-model-invocation: true
---

# `/ba-t03` — stakeholder register

**Serves:** Stakeholders (root). **Class:** Context ·
**Destination:** `.specify/memory/stakeholders.md`.

The project's cast list as an artifact: populations and decision-relevant
individuals, each with a role-in-project and decision rights or a comms line —
the who's-who that Tier-1 calls, transcript parsing and every downstream
who-question resolve against. The decision this run lets the BA make: the cast
is coherent with the canvas and complete enough that dependent aspects open on
**named people, not placeholders**.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t03`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Stakeholders aspect, which is `open`
> or `reopened`, **with its output contract pinned**: `{stakeholder register —
> one row per population and per decision-relevant individual, sponsor authority
> explicit · Context · .specify/memory/stakeholders.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect stakeholders` to open and
compose.

**Skip-if — refuse the run and say so:** AT-ST-2 and AT-ST-3 both read met in the
current evidence table — for instance a register carried from a prior engagement
and confirmed current at Frame. **Persona work is never this run's ground**: if
what the BA wants is charters, that is T-04, and it is enrichment the BA elects,
never a hole this technique fills.

## Depth boundary — the cast at project grade, and it is a hard edge

Elicit **populations as first-class entries, plus named individuals where
decision- or comms-relevant**; per entry: role-in-project · decision rights ·
comms line.

**Must NOT descend into:**

- persona charters — T-04's ground
- authorization roles or permission rows — T-12's governance ground. **A register
  population is never a role.** The register says who exists and who decides;
  governance says who may act on what.
- org-chart completeness beyond project relevance
- engagement scheduling — that is BA conduct, not artifact content

## Inputs loaded

In this order:

1. `canvas.md` — **Customers first**; it is the population baseline the coherence
   pass diffs against
2. presale material and any transcripts on hand
3. `.specify/memory/glossary.md` — for canonical term use

## Procedure

1. **BA act.** Stakeholders is opened and its plan composed; the run is invoked.

2. **Framework act — pre-draft the register.** Draft it from canvas Customers,
   presale material and any transcripts: one row per population and per named
   individual. **Every field is cited or marked** — a citation to its source, or
   an explicit marker. Nothing is guessed into a cell.

3. **Framework act — the remaining holes become questions.** Each question is
   **destination-tagged before it is asked**: to a named register field, or to a
   named criterion miss (AT-ST-1 · AT-ST-2 · AT-ST-3). **A question that serves
   neither is illegal and must not be emitted.**

   There is no numeric cap here and none is needed: threshold grade bounds the
   set structurally. If the question list is growing past the register's fields,
   the run has drifted below its depth boundary — stop and cut back.

4. **BA act — answers and the sponsor line.** The BA answers from knowledge or
   takes the question to the stakeholder, and edits rows. **The sponsor's
   decision authority is stated explicitly** — that is AT-ST-2's named condition,
   and "the sponsor is Olena" is not it: what Olena decides is.

5. **Framework act — the coherence pass.** Diff canvas Customers ⇄ register, both
   ways — AT-ST-3's ground:
   - every canvas Customers population resolves to a register entry
   - no register entry contradicts the canvas picture

   A mismatch is surfaced as a **proposed edit**, on the register side or the
   canvas side; canvas-side fixes ride a proposed-edit batch the BA approves
   before anything is written.

   **First pass and later are different situations, and the difference is
   mechanical, not stylistic.** While the aspect is still `open`, a conflict is
   ordinary correction — there is nothing gated, so no reopen exists to signal.
   Once the aspect has been cleared or waived, the same contradiction arriving
   later is a **reopen signal**, not a correction.

6. **Framework act — write and report.** Write `stakeholders.md`. Report which
   criteria the run moved — AT-ST-1 · AT-ST-2 · AT-ST-3 — and what remains open.
   The evidence-table refresh and the confirmation proposal belong to `/ba-run`'s
   post-run touchpoint; the clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/stakeholders.md` — one table, six columns:
`Stakeholder · Kind · Role in project · Decision rights · Comms line · Source`.
`Kind` is `individual` or `population`. The template and a worked example are in
`references/example.md`.

Plus a canvas-side proposed-edit batch when the coherence pass demands one.

## Signals

- **Routing batch** — the coherence pass's canvas-side edits, and any finding
  that belongs to another artifact's home. Proposed, BA-approved, then written.
- **Reopen signal** — only once the aspect has been cleared or waived: finding ·
  contradicted artifact + line · conflict statement. Emit it and stop.
  `/ba-reopen` receives and rules it; this skill never executes a reopen.

## What this skill never does

Never writes a persona charter · never defines a role or a permission · never
emits a question without a destination · never guesses a name, a decision right
or a comms line into a cell · never leaves the sponsor's authority implicit ·
never edits `canvas.md` outside an approved batch · never resolves a coherence
mismatch on the BA's behalf · never confirms an AT criterion or clears an
aspect · never runs a CC assertion.
