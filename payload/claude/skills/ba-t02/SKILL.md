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

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t02` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of an aspect that is `open` or `reopened`,
> **with its output contract pinned**: `{glossary — canonical-term entries,
> definition-complete, merges dated · Context · .specify/memory/glossary.md}`.

Normally that plan is the **Requirements** plan, worked against AT-RQ-3's holes.
An earlier deliberate sweep is legal by BA election into any open aspect's
composed plan — the BA composes freely. What is **not** legal is the framework
proposing this technique outside Requirements: a suggestion must name the hole it
fills, and outside Requirements there is no AT hole to name.

**On a pass** — render one line:
`T-02 — Glossary discipline → .specify/memory/glossary.md`, and begin. No
confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect <aspect>` to compose it in. Nothing else runs; nothing
else is explained.
The stop closes per §10.3 rule 9 — `What I need from you:` with the repairing
act as the `(recommended)` option.

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
   confirmation proposal belong to this skill's run-end block; the clearing itself
   is the BA's, at `/ba-clear`.

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

## At run end — compiled bookkeeping

1. **The primary output lands** at its contracted destination — this run's own
   act under its pinned contract, **and in this skill's own pinned output
   shape**: the heading literals and ID grammars pinned above. A shape
   divergence is a **contract miss** (orchestrator §6.3) — stop and report the
   shape expected against the line as written; never record `fulfilled`, and
   never downgrade to `partial`.
   The stop closes per §10.3 rule 9 — `What I need from you:` with the
   repairing act as the `(recommended)` option.
2. **Cross-cutting findings route** as one proposed batch: the framework
   assembles the edits · the BA approves the batch · the framework writes. In
   Band 1 proper Scope H is disarmed and nothing fires; post-closure runs get
   the armed cadence automatically.
3. **Run log** — append under the aspect's section in
   `.specify/aspect-plans.md`:
   `<date> · <CODE> · contract: fulfilled | partial — <what is missing> | failed — <why>`
   `  signals: RO-<n> received | routing batch <ref> approved | none`
   Then set the plan row's Status to `run <date>`. `partial` and `failed` are
   recorded, never silently retried.
4. **Threshold refresh (the §7.4 touchpoint)** — refresh the aspect's
   threshold-evidence table against `.specify/ba/cards/at-thresholds.md`.
   All met → propose in one line: "threshold evidence complete —
   `/ba-clear <aspect>`?" Some unmet → name the misses, one line each.
   Proposing is not confirming; an aspect gate never self-clears.

## What this skill never does

Never defines a role · never writes fields, attributes, relations, states or UI
copy into a definition · never picks a canonical term on the BA's behalf · never
averages two incompatible meanings into one entry · never edits another artifact
outside an approved batch · never confirms AT-RQ-3 or clears an aspect · never
enriches past the criterion unasked · never runs a CC assertion.

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
