---
name: ba-t04
description: T-04 — Persona charters. Serves Stakeholders as enrichment - BA-elected, never framework-suggested, because no threshold criterion demands a persona. Pre-drafts one transformation-ready charter per elected register population - goals, behaviors and environment, frustrations, system-facing activities - and writes .specify/memory/personas.md.
disable-model-invocation: true
---

# `/ba-t04` — persona charters

**Serves:** Stakeholders — **enrichment**. **Class:** Context ·
**Destination:** `.specify/memory/personas.md`.

Register populations enriched with human context — goals, behaviors and
environment, frustrations, and the concrete activities a population performs
around the system — so framing, communication and later story judgment work from
lived pictures rather than population labels. The decision this run lets the BA
make: which populations deserve charters, and that each charter is **faithful to
its register entry**.

A charter is context and only context. **A persona never travels into the build
as authorization.**

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t04` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of an aspect that is `open` or `reopened` —
> typically Stakeholders, while the register context is fresh, though any open
> aspect is legal — **with its output contract pinned**:
> `{persona charters — one per elected register population, transformation-ready per TC-1…TC-3 · Context · .specify/memory/personas.md}`.

**On a pass** — render one line:
`T-04 — Persona charters → .specify/memory/personas.md`, and begin. No
confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect` to open and compose. Nothing else runs; nothing else is
explained.

**This technique is never suggested.** No threshold criterion demands a persona,
so the framework has no hole to name — and a suggestion that cannot name its
hole must not be emitted. T-04 (Persona charters) enters a plan two ways only:
the **BA elects it** into an open aspect's composed plan, or the BA asks for
enrichment options and it is **listed among them**. If you arrived here from a
framework suggestion, the suggestion was illegal; stop and say so.

**Skip-if — refuse the run and say which:** **always skippable.** Charter absence
is a legal end state, not a hole — the persona clause that reads this file is
conditional, and stays dormant while the file does not exist. Redundancy: the
elected populations already carry current charters.

## Depth boundary — charter grade, and it is a hard edge

Elicit, **per elected population**: goals · behaviors & environment ·
frustrations (`→ P-n` written **only where the material states the link**) ·
system-facing activities at capability level, verb + object.

**Must NOT descend into:**

- permissions or access rules. **A persona is never authorization.** An access
  expectation surfacing here is a routed **governance finding** — proposed to
  `roles-permissions.md`, never written into a charter.
- role definitions or role names — governance ground, and the namespace rule
  below keeps the two sets disjoint
- journey step maps — the process technique's ground
- story or acceptance-criteria drafting — spec ground, Tier 2
- demographic color that informs no decision

## Inputs loaded

In this order:

1. `.specify/memory/stakeholders.md` — **first**; every charter details exactly
   one entry in it
2. `canvas.md`
3. presale material and any transcripts on hand
4. `.specify/memory/glossary.md` — for canonical term use in the activity lines

## Procedure

1. **BA act.** The BA elects T-04 — Persona charters into an open aspect's
   composed plan and **names
   the populations to charter**; the run is invoked. Re-composition is legal
   while the aspect is `open`, so an election mid-aspect is ordinary.

2. **Framework act — pre-draft one charter per elected population.** Draft from
   `stakeholders.md`, `canvas.md` and the presale material and transcripts on
   hand. **Every line is cited or marked** — a citation to its source, or an
   explicit marker. A `→ P-n` link on a frustration is written **only where the
   material states it, never inferred**.

3. **Framework act — the remaining holes become questions.** Each question is
   **destination-tagged before it is asked**, to a named charter field. **A
   question serving no field is illegal and must not be emitted.** There is no
   numeric cap and none is needed: charter grade bounds the set structurally.

4. **BA act — answers and the faithfulness ruling.** The BA answers or edits, and
   rules each charter **faithful to its register entry**: a charter **enriches the
   register row it details, and never rivals the cast list**.

5. **Framework act — the boundary sweep.** Read the drafted lines back:
   - a line stating an **access rule or a role definition** is extracted as a
     proposed **governance finding** for `roles-permissions.md` — proposed, never
     silently written
   - a charter describing a population **absent from the register** is a register
     gap → a proposed register edit

   **First pass and later are different situations, and the difference is
   mechanical.** While the hosting aspect is still `open`, a conflict with its own
   content is ordinary correction. A finding contradicting **cleared** ground —
   the register, or canvas Customers once Stakeholders has cleared — is a
   **reopen signal**.

6. **Framework act — write and report.** Write `personas.md`; report the run
   `fulfilled`. **Enrichment feeds no evidence-table row** — the refresh runs and
   changes nothing, by design. Say that plainly rather than implying the aspect
   moved.

## Output

`.specify/memory/personas.md` — the three transformation clauses at the head,
then one charter per elected population: a heading
`## <Persona name> — details: <register population>` and a two-column table with
six fields — Goals · Behaviors & environment · Frustrations · System-facing
activities · Source.

**The three clauses are the file's contract, and they ship in the file itself:**

> **TC-1 — Details:** exactly one register population per charter, resolving to a
> `stakeholders.md` entry.
> **TC-2 — System-facing activities:** capability-level lines (verb + object);
> they are read as candidate role-and-action evidence — **nothing else in a
> charter is transformation input**.
> **TC-3 — Namespace:** persona names are charter-local human forenames, disjoint
> from role names, register populations and register individuals; **a persona
> name is never used as an actor anywhere.**

TC-3 is not advice. The set of names in this file is the screening surface a
non-waivable spec assertion greps for; a name reused as an actor fails it. Check
the namespace at write time, before the file lands.

`references/example.md` carries the template and a worked charter.

Plus the routed batches the sweep found — governance findings, register edits.

## Signals

- **Routing batch** — governance findings toward `roles-permissions.md`; register
  edits where a chartered population is missing from the cast. Proposed,
  BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.

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

Never enters a plan by framework suggestion — there is no hole to name · never
states a permission, an access rule or a role · never reuses a register
population, a register individual or a role name as a persona name · never
invents a link, a frustration or an activity the material does not state · never
emits a question without a charter-field destination · never charters a
population the register does not carry without proposing the register edit ·
never edits `stakeholders.md`, `canvas.md` or `roles-permissions.md` outside an
approved batch · never confirms an AT criterion or clears an aspect · never
claims this run moved an evidence table.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
