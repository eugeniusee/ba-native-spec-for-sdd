---
name: ba-aspect
description: Open a Band-1 aspect and compose its technique plan - prerequisite check, T1 opening, the evidence-grounded suggestion snapshot, and the BA's composition with output contracts pinned before any run. Carries prompt points P-O1 - aspect opening and P-O2 - plan composition. Also re-plans an aspect that is already open or reopened. The seventh argument band2 composes the plans file's Band 2 section by the same discipline - nothing opens, roadmap-state holes ground the rows, and Band-1 closure is the one precondition.
disable-model-invocation: true
---

# `/ba-aspect <aspect>` — open + plan

**Argument:** one of `stakeholders` · `context` · `value` · `vision` ·
`solution` · `requirements` — or `band2`, the seventh, non-aspect value:
compose the `## Band 2` section's plan (the fork below). Case-insensitive;
resolve an aspect to the ledger's spelling before writing anything.

Two prompt points in one act: **P-O1 — aspect opening** opens the aspect;
**P-O2 — plan composition** composes its plan. On an aspect that is already
`open` or `reopened`, this skill re-plans — P-O1 (aspect opening) is skipped and
the composition appends. With `band2`, one prompt point only: nothing opens, and
the fork below composes the `## Band 2` section's plan at P-O2 — plan
composition.

## Invocation contract — check before you run

- **BA-invoked.** Opening is a BA act, not a consequence of prerequisites having
  cleared. When prerequisites clear, `/ba-status` *says* the aspect is openable;
  it does not open it.
- **The ledgers must exist.** No `.specify/aspect-state.md` → Band 1 has not been
  entered; stop and name `/ba-frame`.
- **The flow profile must be on record.** No `Profile:` line in the ledger head →
  **P-O0 — flow-profile selection** was never taken; stop and name `/ba-frame`.
  The snapshot filters by profile and cannot render without one. Never pick a
  profile here, and never assume Discovery.
- **The scope frame must be on record.** No `Boundary:` line in the ledger head →
  **P-O0b — scope-frame selection** was never taken; stop and name `/ba-frame`.
  With the substrate, the profile and the scope frame in place, and not before,
  the root is openable. Never set a frame here.
- **The suggestion is advisory, never a restriction.** The decision is *BA
  planning, LLM assists*: you suggest a recommended technique set and sequence
  from the evidence; the BA composes the real plan.

## Render rules — standing, over every string this skill shows the BA

These govern prose, table cells, headers, the out-of-profile line and the close
alike. Inside a pinned shape the shape governs (register rule 8); nothing here
licenses editing one.

- **Code + name, always** (register rule 5). Every technique, stage or assertion
  code carries its name: `T-03 — Stakeholder register`, `T-06 — Constraints
  elicitation`, `P-O2 — plan composition`. First mention in a sitting adds a
  one-line purpose. **A bare code is a render defect — in prose exactly as in a
  row.** A technique named mid-sentence carries its name there too: write
  `T-01 — Discovery canvas framing owned canvas Customers`, never the code alone.
- **Codes render canonical — capital T, hyphen, two digits**, as in
  `T-04 — Persona charters`. A lowercase or hyphenless variant is a render
  defect, in the out-of-profile line exactly as in a row. The lowercase form is
  the command name and nothing else: name invocations as `/ba-t03`,
  `/ba-t06`, and never let that form leak into a render.
- **Plain words** (register rule 2). Say **root**, never "DAG". Framework
  document vocabulary stays in the documents.
- **One term per concept** (register rule 4). **Prerequisite** — never also
  "precondition", never "dependency". Same for aspect, threshold, waiver,
  reopen.
- **State the prerequisite basis once.** Step 1 checks it; Step 2 cites it as
  the opening basis. It is not restated a third time in the same sitting.

## Step 1 — T1's prerequisite check

| Aspect | Prerequisite |
|---|---|
| Stakeholders | — (root; Band 1 entered is the whole prerequisite) |
| Context | Stakeholders |
| Value | Stakeholders |
| Vision | Context **and** Value |
| Solution | Vision |
| Requirements | Solution |

Each prerequisite must read `first-pass-cleared` **or** `waived`. A `waived`
prerequisite satisfies the edge exactly as a cleared one does — that is what the
waiver valve is for — and the debt stays named in the head, not here.

A prerequisite reading `reopened` **blocks the opening**: a reopen blocks new
opening through itself. Say which prerequisite, in which state, and name
`/ba-reopen` or `/ba-clear` as the way through. Do not offer to open anyway.

State already `open` / `reopened` → skip to Step 2 (re-planning is legal at any
time in either state). State `first-pass-cleared` or `waived` → **refuse**: there
is no `first-pass-cleared → open` transition. Dissatisfaction with cleared
content, absent a contradiction, is ordinary content work — run more techniques
under the existing plan, route more findings; arrival is never gated. Only a
contradiction degrades a cleared aspect, and that arrives as a reopen signal.

## Step 2 — P-O1 (aspect opening): the opening act

Present the prerequisite states as the basis and take the BA's act. On **open**:

- T1 executes: `untouched → open`.
- Head: the aspect's row updates — state, `Since` = today, `Basis` = the
  prerequisite states cited.
- Event, in the grammar:

```
<date> · T1 · <Aspect> · untouched → open · <BA initials> — prerequisites: <Aspect> first-pass-cleared[, <Aspect> waived under AW-<n>]
```

Root aspect: the basis reads `Band 1 entered <date>`.

## Step 3 — the suggestion snapshot (framework, advisory)

Read the aspect's AT criteria from `.specify/ba/cards/at-thresholds.md` against
the current artifact evidence. **The unmet criteria are the holes; the holes are
the suggestions.**

Every suggestion line is **evidence-grounded**: it names the hole — the AT-ID and
exactly what is missing — that it exists to fill. **A suggestion that cannot name
its hole must not be emitted.** Suggesting into a criterion that is already met
is legal only as enrichment the BA asked for; your own initiative stops at the
threshold.

**Filter by the profile.** Read `Profile:` from the ledger head. An in-profile
technique renders as a full row. An out-of-profile technique renders no row — it
collapses into the one-line list at the foot, electable by code. A profile is a
recommendation default, never a restriction.

**The enrichment block is standing.** Techniques that serve this aspect with no
unmet criterion behind them render on every snapshot, not only when the BA asks.
Listing is not recommending: an enrichment row carries `optional`, never
`recommended`.

**Declared preconditions render — visibility, never a block.** Each catalogue
technique declares in the index's `Preconditions` column the **other techniques'
artifacts** its own contract and template text demand, graded **hard** (a
contracted cell cannot be authored without it) or **soft** (one input among
several), `—` where it takes none. Check each rendered technique's declaration
against what is **on disk**, and carry every open one on the block's single
`Preconditions open:` line — `—` when none is open.

- **The election sees what it is taking on.** The line renders before the
  composition act, so the BA elects knowing which cells will land marked.
- **Never pull the producer in.** Electing a technique elects **that** technique.
  You never add its producer to the plan; composition is the BA's act.
- **Never block.** An open precondition never makes a technique un-electable and
  never refuses a run. The run proceeds in assumption posture with the dependent
  cells drafted and **marked**.
- **No new column and no new status value.** `Status` stays the closed set below;
  the precondition is one line in the block, never a cell.

**`Status` is a closed set** — `recommended — criterion unmet` · `done — <date>` ·
`optional` · `dropped — <date>`. A `dropped` row resurfaces marked; it is never
re-pushed. Nothing else may appear in that column.

Write the snapshot into the aspect's section of `.specify/aspect-plans.md`,
verbatim in this shape — it is kept as audit trail and as tuning input:

```
Suggestion — <aspect> — <date> · profile: <Discovery | Presale>
State: <n> of <m> threshold criteria met. Nothing runs until you compose the plan
(P-O2 — plan composition).

| # | Code — technique | Purpose (one line) | Addresses | Status |
|---|---|---|---|---|
| 1 | T-05 — Context & landscape mapping | Maps today's systems and org landscape | AT-CX-1 — <the named hole> | recommended — criterion unmet |
| 2 | <code — name · custom — name> | <purpose> | <AT-ID — hole · —> | done — <date> · dropped — <date> |

Enrichment — electable, no unmet criterion behind them:
| E1 | T-04 — Persona charters | Charters the elected user populations | — | optional |

Outside this profile (electable by code): <codes> — say "show all" for full rows.
Preconditions open: <technique — artifact (producer), hard|soft: what it grounds> · <…> · —
Sequence rationale: <one line>
```

Where a catalogue technique fits the hole, render it under the standing render
rules above — code + name, canonical form, everywhere in the snapshot including
the out-of-profile line. Where no catalogue technique fits, sketch a **custom**
technique — the loop is catalogue-agnostic by design: a technique is runnable iff
its contract is pinned, wherever the contract came from.

## Step 4 — P-O2 (plan composition): the BA's plan

**A full checkpoint: render, then stop.** The BA's four acts are Q2's, verbatim:
**select · drop · reorder · add custom**.

Render the snapshot to the BA in the Step 3 shape — **the whole pinned block,
every line of it, in its own order**: the `Suggestion` header with the profile,
the `State:` line, the in-profile table, the standing enrichment block, the
out-of-profile line, the `Preconditions open:` line, the `Sequence rationale:`
line. The BA-facing render and the `.specify/aspect-plans.md` write carry the
same shape; the file is not the only place it renders whole.

**Two lines the render drops most often, and never may.** The `State:` line is
**two sentences** — the count, then *Nothing runs until you compose the plan
(P-O2 — plan composition)*. Both stand in the block, directly under the header;
neither moves to the tail of the message. And `Sequence rationale: <one line>`
closes **every** snapshot, single-row ones included.

Then render the choice line, exactly:

```
Compose the plan — P-O2 (plan composition). Four acts, in any combination:
1. select      — take rows by number
2. drop        — remove rows by number
3. reorder     — give the sequence you want
4. add custom  — name a technique not listed; you pin its output contract
Out-of-profile techniques are electable by code. Say "show all" for full rows.
Waiting for your composition. Nothing runs until you state it.
```

Then **stop and wait.** Do not compose. Do not record. Do not start a run.
**Silence is never consent; a rendered suggestion is never a plan.** The composed
plan exists only once the BA has stated it, and it is recorded verbatim as
stated. The composed plan is the BA's document; the snapshot stays beside it
unchanged. Never edit a snapshot to match what the BA chose — the divergence
between the two *is* the tuning signal.

**The closing ask (§10.3 rule 9) — appended after the pinned snapshot and the
choice line, never replacing either.** Close the render with the final
plain-English block, and present the choice through the AskUserQuestion tool —
single-select, one call, an "other / free text" escape; the four acts stay the
typed channel, and every selection is transcribed into the composed-plan record
verbatim. The shape, for this stop:

```
What I need from you:
1. The plan for <aspect> — take the suggestion as your plan?
   a. compose it as suggested (recommended) — every full row closes a named hole
   b. change it first — select / drop / reorder / add custom, by row number
Reply with the letter, or state the four acts in your own words.
```

You may **propose** a sequence when the evidence points one way. You never
compose. **The plan is the BA's act.**

Re-composition is legal at any time while the aspect is `open` or `reopened`. It
runs this same checkpoint and appends.

**Output contracts are pinned before any run.** Every planned technique —
catalogue or custom — carries `{expected output · artifact class · destination
file}` before it may run:

- **Catalogue techniques** come pre-pinned by their sheets. Read the pinned
  triple from the technique's own skill — its invocation self-check carries it —
  and **render it verbatim, all three fields**: the expected output in full, the
  artifact class string whole **including any parenthetical qualifier**, and the
  destination file. **Never compress a pre-pinned contract.** A dropped field
  list, a trimmed class string, a paraphrase — each is a render defect, not a
  summary: `Context (spec-anchored — Q7)` never renders as `Context`. It renders
  **for visibility**, not for confirmation: what is pre-pinned is already pinned,
  and asking the BA to confirm it invents a checkpoint the loop does not have.
- **Custom techniques** — the one path that takes a confirmation. The BA supplies
  the contract, or you propose it and the BA confirms. **An unconfirmed contract
  makes the run illegal** — do not mark such a technique planned-runnable, and
  the technique's compiled P-O3 (technique invocation) check will refuse it.
  This is the same discipline as refusing a question without a destination, one
  level up.

Append to the aspect's section, dated:

```
Composed plan — <date> · <initials>
| # | Code — technique | Source | Output contract {expected · class · destination} | Status |
|---|---|---|---|---|
| 1 | <code — name · custom — name> | catalogue | {…} | planned |
```

`Status` values: `planned` · `run <date>` · `dropped — <reason>`. Re-composition
appends a new dated plan block; **the plan never rewrites its own history**.

## The `band2` fork — the `## Band 2` section's plan

`/ba-aspect band2` composes the plans file's non-aspect `## Band 2` section
(§6.4) — the same planning loop, aimed at the band's own record home. **Nothing
opens: P-O1 (aspect opening) does not run.** Band 2 is a band, not an aspect;
its entry happened at Band-1 closure (§8.2), and this fork only composes.

- **The one precondition is the band's own door.** Read the ledger head:
  Band-1 closure must stand. Not closed → stop and name `/ba-close-band1`.
  The aspect machinery is skipped — no prerequisite table, no profile gate, no
  threshold criteria. Of the invocation contract above, **the ledgers must
  exist** still holds; the head it brings is what this fork reads.
- **The snapshot is §6.1's shape with two substitutions** — the `Band 2` header
  in place of the aspect, and the **roadmap-state hole** in place of the AT-ID.
  No separate Band-2 shape exists. Recommended rows are grounded on roadmap
  state exactly as an aspect's are grounded on unmet criteria: **no roadmap on
  disk** → the T-17 — Epics decomposition row, recommended — the section's
  first act · **rows `Unallocated`** → the T-18 — Scope allocation row,
  recommended, the unallocated count named · **per-epic kit gaps** ground
  Tier-1 (the epic scoping interview) rows — enrichment, electable, `optional`,
  never `recommended`. The `State:` line carries the roadmap state in place of
  the criteria count — there is no threshold table to count against. Everything
  else is Step 3's own rules, unchanged: the closed `Status` set, the standing
  enrichment block, the out-of-profile line, the `Preconditions open:` line,
  the `Sequence rationale:` line,
  and the verbatim write — into `## Band 2`.
- **Composition is Step 4, unchanged.** The same choice line, the same stop.
  The composed plan appends under `## Band 2`, dated, in the same row shape —
  re-composition is legal at any point inside the band, and a rerun's row names
  its trigger (T-18 — Scope allocation reruns and per-epic Tier-1 kits take
  their rows exactly as an aspect's re-composition appends). Under a standing
  autonomy grant, the P-O2 — plan composition policy row applies unchanged.

Everything below — the close, the never-list, the register self-check, the
session boundary — reaches the fork unchanged: you never compose. **The plan is
the BA's act.**

## Close

Render: the aspect's state, its named misses (the unmet AT criteria), and the
next act — `/ba-t<NN>` for the first planned line.

## What this skill never does

Never opens an aspect whose prerequisite is unmet or `reopened` · never re-opens
a cleared aspect · never runs a technique (that is the technique's own one-step
command, a BA act at P-O3 — technique invocation) · never confirms a threshold
(that is `/ba-clear`) · never authors content or edits an artifact — it writes the two ledgers only ·
never emits a suggestion that cannot name its AT hole · never treats its own
suggestion as a restriction on the BA's plan · **never composes or records a plan
the BA did not compose**.

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
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
