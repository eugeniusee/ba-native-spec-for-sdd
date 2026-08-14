---
name: ba-t11
description: T-11 — Domain (conceptual) modeling. Serves Requirements against AT-RQ-4's entity clause. Sweeps the completed canvas surface for the entities the core functions imply, proposes business-level relations, disposes every connection system as a boundary reference, and writes .specify/memory/domain-model.md.
disable-model-invocation: true
---

# `/ba-t11` — domain (conceptual) modeling

**Serves:** Requirements. **Class:** Context ·
**Destination:** `.specify/memory/domain-model.md`.

The conceptual model — the business entities the core functions imply, with
business-level relations — seeded so **every downstream artifact names entities
against one reference surface instead of minting its own**. The decision this run
lets the BA make: this is the entity vocabulary of the domain — what exists, how
it relates, and what stays outside the boundary.

**This is the requirements chain's first link, and the order is load-bearing.**
The roles run's policy rows reference these entities by name; the process run's
journeys touch them; at gate time the spec's entities and relationships resolve
here. Run it before either.

**The canonical form is tabular.** Entities and Relations are tables because what
reads them — a checker resolving a spec entity, the role registry's consistency
check, a coding agent reading certified text — needs parseable names and
relations. A diagram is a **derived view**, produced from the tables if the BA
wants one, and never the source of truth.

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t11` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{domain model at seed grade — entities the core functions imply, relations at business level, boundary references disposed external · Context · .specify/memory/domain-model.md}`.

Requirements opens on Solution being `first-pass-cleared` or waived — the
surface this run sweeps has to be finished before there is anything to sweep.

**On a pass** — render one line:
`T-11 — Domain (conceptual) modeling → .specify/memory/domain-model.md`, and
begin. No confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect requirements` to open and compose. Nothing else runs;
nothing else is explained.

**Skip-if — refuse the run and say so:** AT-RQ-4's **entity clause** reads met in
the current evidence table — a conceptual model already stands, confirmed current
against the framed canvas. Enrichment beyond the threshold — attribute
inventories, data dictionaries, full ERD notation — is **on BA ask**, never a
hole this run fills on its own initiative.

## Depth boundary — conceptual grade, and it is a hard edge

Per entity: **glossary-canonical name · one business line · source**. Per
relation: **from · relation · to · multiplicity written only where a source
states it**.

**Must NOT expand into:**

- **per-feature fields, types or validations.** That is spec Data ground. The
  model says *an Appointment occupies a Slot*; it never says *`expires_at`,
  datetime, required*.
- **state and lifecycle tables.** Also spec ground.
- **term definitions.** A definitional gap routes to the glossary **first**, and
  the entity line adds relational identity — never a rival definition of a term
  the glossary already owns.
- policy rows — the roles run's ground · journeys — the process run's ground
- **treating an external system as an entity.** Those are boundary references;
  `context.md` and the canvas connection section own them.
- integration payloads or directions — brief and spec ground

## Inputs loaded

In this order:

1. `canvas.md` — **§§7–8 first**: the completed Core Function lines and
   Third-Party Connection rows. This is the sweep's opening surface and the
   reason this run waits for a cleared Solution.
2. `.specify/memory/glossary.md` — the canonical names entities must carry
3. `.specify/memory/context.md` — the systems that will stay external
4. the current `.specify/memory/domain-model.md` — **routed entity or
   relationship arrivals may pre-date any run. Arrival is never gated**, so rows
   already in the file join the candidate set as input, not as duplicates.
5. presale material and kickoff notes

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — first
   of the chain.

2. **Framework act — the sweep.** Open on the completed canvas surface:

   - each **function object** (verb + object, the objects glossary-canonical)
     becomes an **entity candidate**
   - each **connection system** becomes a **boundary-reference candidate, never
     an entity**

   Routed arrivals already in the file join the candidate set. **Cite or mark
   every line** — a candidate with no source is drafted and marked, never
   silently seeded.

3. **Framework act — the relation pass.** Propose business-level relations from
   the function lines' verb–object structure and from presale and kickoff
   statements. **Multiplicity is written only where a source states it** — an
   inferred multiplicity is drafted and marked, never asserted silently.

4. **Framework act — the questions.** Remaining holes become destination-tagged
   questions: an entity's identity or its one-line meaning, a relation's
   existence or its multiplicity. Conceptual grade bounds the set — no numeric
   cap is needed, because the ceiling is the grade.

5. **BA act — the rulings.** The BA confirms or edits entities and relations, and
   **rules each boundary reference** — external stays external. Boundary routing,
   with its asymmetry:

   - a candidate whose term is not yet in the glossary → **glossary proposal
     first**, entity row here
   - an entity implying an unrecorded today-system → a `context.md` proposal
   - a finding contradicting **cleared** ground — a canvas function line, the
     register — is a **reopen signal**

6. **Framework act — write and report.** Write `domain-model.md`. Report which
   criteria the run moved — AT-RQ-4's entity clause — and what remains open.
   The evidence-table refresh and the confirmation proposal belong to this
   skill's run-end block; the clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/domain-model.md` — **three sections, these names, this order**:

`## Entities` · `## Relations` · `## Boundary references (external — not entities)`

Entities carry `| Entity | What it is (one business line) | Source |`. Relations
carry `| From | Relation | To | Multiplicity (where stated) | Source |`. Boundary
references are a list, each disposing one connection system as external and
pointing at the file that owns it.

**Every `From` and every `To` names a defined entity.** A relation reaching an
undefined name is not a relation; it is a missing entity row or a boundary
reference in disguise.

The template and a worked example are in `references/example.md`.

Plus routed batches where the rulings demand them — glossary-first, then context.

## Signals

- **Routing batch** — glossary proposals for terms this run leaned on, context
  proposals for today-systems an entity implied. Proposed, BA-approved, then
  written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Derived view** — a diagram, on BA ask, generated from the tables and labelled
  as derived. It never becomes the file's source of truth.

## At run end — compiled bookkeeping

1. **The primary output lands** at its contracted destination — this run's own
   act under its pinned contract.
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

Never writes a field, a type or a validation · never carries a state or lifecycle
table · never defines a term the glossary owns — it routes there first · never
mints an entity for an external system · never asserts a multiplicity no source
states · never writes a policy row or a journey · never edits `glossary.md` or
`context.md` outside an approved batch · never confirms an AT criterion or clears
an aspect · never runs a CC assertion.

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
