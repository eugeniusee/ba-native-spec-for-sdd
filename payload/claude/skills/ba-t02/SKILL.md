---
name: ba-t02
description: T-02 — Glossary discipline - the deliberate sweep-and-merge consolidation run. Serves Requirements against AT-RQ-3; suggestion-anchored there, BA-electable into any open aspect's plan. Writes .specify/memory/glossary.md - canonical terms, business-level definitions, and the merge record that makes later drift detectable.
disable-model-invocation: true
---

# `/ba-t02` — glossary discipline

**Serves:** Requirements. **Class:** Context ·
**Destination:** `.specify/memory/glossary.md`.

One project, one language: canonical terms, business-level definitions, synonyms
merged with the losing term left **on record**. The decision this run lets the BA
make is which term wins each merge, and whether the language is closed enough to
seed the spec estate.

## Two modes, and only one of them is this run

- **The standing discipline** — a new term or a synonym conflict routes to
  `glossary.md` as it arrives; the writer adds a term before its first use.
  This operates from the first Frame act on and is **not a technique run**.
  Nothing about it is invoked, and this skill does not own it.
- **The consolidation run** — the deliberate sweep-and-merge pass below. That is
  what `/ba-t02` is.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t02`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of an aspect that is `open` or `reopened`,
> **with its output contract pinned**: `{glossary — canonical-term entries,
> definition-complete, merges dated · Context · .specify/memory/glossary.md}`.

Normally that plan is the **Requirements** plan, worked against AT-RQ-3's holes.
An earlier deliberate sweep is legal by BA election into any open aspect's
composed plan — the BA composes freely. What is **not** legal is the framework
proposing this technique outside Requirements: a suggestion must name the hole it
fills, and outside Requirements there is no AT hole to name.

On a miss, stop and name `/ba-run`, or `/ba-aspect <aspect>` to compose it in.

**Skip-if — refuse the run and say so:** AT-RQ-3 reads met in the current
evidence table — every leaned-on term defined, no known synonym pair unmerged, no
stub entries. Enrichment past the criterion — translations, extended usage
notes — happens **only on BA ask**, never on the framework's initiative.

## Depth boundary — business-level definitions, and it is a hard edge

Elicit **one term, one project meaning, plus the merge record**.

**Must NOT descend into:**

- per-field data definitions — a data dictionary is not a v1 artifact
- entity attributes or relations — that is the domain-model ground of
  T-11 — Domain (conceptual) modeling
- state vocabularies — spec Data-section ground
- UI copy
- **role definitions belong to T-12 — Roles & permissions.** A glossary entry
  that restates a role double-defines it. Role nouns are *used* in definitions
  here, never *defined* here.

The testable edge: **a definition that enumerates fields or transitions has
crossed the line.** Cut it back to the business meaning.

## Inputs loaded

In this order:

1. `.specify/memory/glossary.md` — the current entries, if the file exists
2. `canvas.md` — the first sweep surface
3. every artifact under `.specify/memory/` written to date

Post-Band-1 reruns add the scope briefs and any specs to the sweep surface.

## Procedure

1. **BA act.** The run is invoked under the composed plan.

2. **Framework act — the term sweep.** Extract candidate domain terms from the
   sweep surface and diff them against existing entries. The output is a **hole
   list**, and every hole names itself:
   - undefined terms — each with the locations it is used in
   - suspected synonym pairs — each with the usage locations of both sides
   - stub entries — a term with no definition

3. **Framework act — drafts.** One definition per hole, cited from its usage
   context or marked. Per synonym pair, a **canonical pick recommended with a
   one-line merge rationale**. Recommended, not decided.

4. **BA act — rulings.** The BA rules the canonical picks, confirms or edits the
   definitions, approves the merges. **A genuine meaning conflict — one term, two
   incompatible uses — is ruled here, never silently averaged.** Take the ruling;
   do not infer it from the drafts looking reasonable.

5. **Framework act — write, then repair the drift.** Write `glossary.md`. Where a
   merge de-canonicalizes a term other artifacts already use, assemble the
   affected lines as a **proposed-edit batch**: finding · destination · edit
   text. The BA approves the batch; then the framework writes. Never edit another
   artifact silently on the strength of a merge.

6. **Framework act — report, do not confirm.** Report which criterion the run
   moved — AT-RQ-3 — and what remains open. The evidence-table refresh and the
   confirmation proposal belong to `/ba-run`'s post-run touchpoint; the clearing
   itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/glossary.md`, plus the routed batch where merges touch other
artifacts. The template and a worked example are in `references/example.md`.

**Every entry is definition-complete and every merge is dated.** A term with no
definition is a stub, and a stub is the same hole as an absent entry.

## Signals

- **Routing batch** — the drift-repair edits of step 5. Proposed, BA-approved,
  then written.
- **Reopen signal** — where a ruled resolution *contradicts* content of an aspect
  that is already cleared or waived, the signal rides the same batch: finding ·
  contradicted artifact + line · conflict statement. Emit it and stop.
  `/ba-reopen` receives and rules it; this skill never executes a reopen.

## What this skill never does

Never defines a role · never writes fields, attributes, relations, states or UI
copy into a definition · never picks a canonical term on the BA's behalf · never
averages two incompatible meanings into one entry · never edits another artifact
outside an approved batch · never confirms AT-RQ-3 or clears an aspect · never
enriches past the criterion unasked · never runs a CC assertion.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
