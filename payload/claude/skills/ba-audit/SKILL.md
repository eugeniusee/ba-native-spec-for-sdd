---
name: ba-audit
description: Run the source audit over the whole band (Scope S) - build the obligations register from the captured sources, trace it forward into every spec, brief, roadmap row and deferral, trace every scope-bearing claim backward to its ground, evaluate the CC-S assertions, and render one decision list at P-A1 - source-audit ruling - where every finding carries its source quote, its band-wide search set and a default. On the BA's ruling it executes the repairs by dispatch and routing, re-audits incrementally, and appends the report entry. BA-invoked, band-level, one checkpoint.
disable-model-invocation: true
---

# `/ba-audit [--full]` — the Scope-S run

**Argument:** none — the scope is the band; that is the point. `--full` forces
a from-scratch run where an incremental one would otherwise compose (run > 1).

## Invocation contract — check before you run

- **BA-invoked, never auto-fired.** Run after the band exists: under Presale,
  after the batch drafting; under Discovery, once two or more features are
  drafted. If you reached this skill because an export finished or a spec
  "looked done", stop.
- **Band-level or nothing.** Coverage is a union property and divergence is a
  cross-spec property. This skill never audits one spec in isolation — that
  narrower read is the gate's Scope F, and it is not this act.
- **Two runtime rules govern everything below.** *The audit never rules* — it
  extracts, traces, evaluates and proposes; scope enters and leaves the band
  only by the BA's P-A1 ruling. And *the audit meets its own bar* — a finding
  without file + place + verbatim quote, or without its band-wide search set
  named, is invalid output, corrected before the list is rendered.
- **No mid-run drip.** Stages 0–3 run to completion without interrupting the
  BA. Findings arrive once, at P-A1 — earlier only on a Stage-0 refusal.

## The run workspace

```
.specify/ba/runs/band-audit/run-<n>/
  obligations.md       the register (regenerated, never hand-edited)
                       — REQUIRED, head-first: Stage 1's per-source coverage
  trace.json           forward + backward traces — REQUIRED
  decision-list.md     the P-A1 list, as rendered and as ruled
                       — REQUIRED, a clean run included (zero rows)
  repairs.json         the executed route, per-row outcome — REQUIRED where
                       the ruling produced at least one executable row
```

The four are this run's own evidence, and **Stage 5 checks them before the
entry appends** (definition §7, **D-S4**). `<n>` is monotonic and band-global:
read `.specify/source-audit.md`, take the highest `## Source audit run <n>`,
add one. The report ledger and the standing
`SA-<nn>` records live at `.specify/source-audit.md` — append-only,
operational state, never quoted into a spec.

---

## Stage 0 — admission

1. At least one `specs/NNN-*/spec.md` exists? If not, refuse and name the act:
   `/ba-run specs all` (Presale) or `/ba-enter-feature` (Discovery).
2. Read the ledger head. The `Sources:` line is the audit's ground: every
   source standing `captured` is read from `sources/` or its recorded
   attachment; every source standing `named — pending`, `skipped` or
   **`excluded — <reason>`** goes on the report head as **unaudited ground**,
   verbatim, with its state — **an exclusion hides nothing, and it is a BA
   ruling on the record, never a gap to fill.** The
   audit never reaches for material the inventory did not capture — a thin
   `Sources:` line is a finding about the inventory, not a license to browse.
   **A reference inside a capture that resolves to an excluded artifact is
   never followed** (D-O70): the encounter is recorded on the ledger's source
   grammar, one line per distinct excluded artifact per capture, and the audit
   reads no further.
3. Assemble the band read set, all read-only: every `specs/NNN-*/spec.md` and
   its `gate-report.md` · every `.specify/memory/scope/<E-nn>.md` ·
   `.specify/memory/roadmap.md` · out-of-scope · `canvas.md` · standing
   `SA-<nn>` records · `exports/wbs.csv` when present.
4. **Readability.** Every captured source must be readable by the passes'
   toolset — plain text. For a capture in a binary container (docx · xlsx ·
   pdf), ensure a sibling mechanical rendering exists —
   `sources/<name>.extracted.md`, verbatim, extraction never interpretation —
   and point every pass at the rendering; the original stays the capture of
   record. Producing a missing rendering is **capture completion, not a band
   edit**: the one write Stage 0 may make, each landing on the run entry.
   Without it a `Sources:` line can read `captured` while the assertion pass
   is structurally blind to the file (run-1 escape, 17 Aug 2026).
5. **Dispatch admissibility** (source-audit definition §4, **D-S1**). Stage 2's
   A pass is the `ba-gate` subagent's, and the separation is the point: the
   session that built the register is the last reader who can independently
   judge it. Before Stage 1 spends a walk, establish that a subagent dispatch
   is **permitted** — an operator instruction, a permission mode or a harness
   may forbid agent calls outright. Where it is forbidden, **refuse here**:
   render `Source audit run <n> — refused at Stage 0`, state the restriction as
   it was stated, say plainly that **this is not a tool failure and re-dispatch
   is not its remedy**, and name the unblocking act — *the BA lifts the
   restriction, or the run does not proceed to Stage 2*. Then the closing ask
   (§10.3 rule 9), one AskUserQuestion call, two lettered options, exactly one
   recommended: **(a) lift the restriction and re-run** *(recommended)* —
   glossed "let the audit dispatch its own independent evaluator, then run
   `/ba-audit` again" · **(b) run self-evaluated** — glossed "I judge my own
   findings; every verdict is stamped `self-evaluated — no independent A pass`
   and the run is recorded INCOMPLETE". **The election is the BA's, and it is
   taken here** — where the restriction is already known. There is no
   invocation flag for it, it is never inferred from silence, and **running on
   without either answer is a defined violation** of the definition's §4,
   whatever the verdicts say. Record the election on the run entry in the BA's
   own words.

## Stage 1 — the obligations register (collect-all)

Build `obligations.md` per the source-audit definition §2: every numbered
section, list item, table row, worked example, scenario and acceptance table
of every captured source; every client-authored ask and recorded decision in
a captured channel. Row grammar:

```
OB-<nnn> · <source-file>#<section> · "<quote ≤ 2 lines>" · shall|should|context
  · phase claim · carrier | none · status
```

Four rules are load-bearing and non-negotiable:

- **Union.** Two sources defining one list or scope → one row at union width,
  both sources named. An addendum extends its base; the base never truncates
  the addendum.
- **A comment is not a carrier.** Stories, acceptance items, brief lines,
  roadmap rows, out-of-scope entries, deferral rows and SA records carry.
  Questions, markers and Comments cells do not.
- **The critic pass.** After the primary walk, re-walk each source asking
  only: *what here maps to no register row?* Rows it adds are marked
  `critic`. Skipping the critic is skipping the audit's own audit.
- **The walk declares its corpus, and the head accounts for it per source**
  (**D-S3**; the corpus-declaration rule is framework law — orchestrator §8.1,
  **D-O81** — reached by reference, never restated here). The corpus is **every
  captured source, and within each source every section**. `obligations.md`
  opens with one line per captured source, before the first row:

```
<source-file> · <sections walked>/<sections total> · <n> rows
  [· zero rows — <why>]
```

  A source producing no rows **states why** — nothing extractable, or a section
  set this pass could not read. Without these lines a keyword probe and a full
  two-pass walk are the same object on disk, and a skipped collect-all or a
  skipped critic leaves no trace at all. Where the walk covered less than the
  corpus it named, the run carries **`sample`** into Stage 3's `Corpus covered:`
  line and names what fell outside — and a sample never grounds a `gap`
  (Stage 2).

## Stage 2 — the traces and the assertion pass (never halts, collect-all)

Trace forward (every OB row → its carrier across the whole band read set) and
backward (every scope-bearing claim — story, integration, role, phase label,
stated basis — → its ground).

**The search set declares its corpus** (**D-S3**). *Band-wide* is a corpus, not a
manner of searching, and this is the corpus it must cover: every
`specs/NNN-*/spec.md` in the band · every brief under
`.specify/memory/scope/` · the roadmap · the out-of-scope register · every
deferral row · every standing `SA-<nn>` · `exports/wbs.csv` where it exists —
Stage 0's read set, walked whole. The run **states the corpus it covered** on
Stage 3's `Corpus covered:` line. **A `gap` is a negative:** where what you
covered falls short of what is named here, say so on that line and **render no
`gap` out of the part you did not cover** — the row carries its basis into the
next run, because an unsearched obligation is unfinished work, not a finding.

Then dispatch the `ba-gate` subagent: the run
workspace path, `.specify/ba/cards/assertions-s.md`, and the explicit CC-S
list to evaluate — all eight families on a full run, the incremental set on a
re-run. Write its JSON to `trace.json`'s `a_pass` block. Do not edit its
verdicts; a missing or surplus assertion is a runtime defect — re-dispatch.
Hand the subagent text renderings only — never a binary source path (its
toolset is Read/Grep/Glob).

**The dispatch has three states, not two** (definition §4, **D-S1**). A
dispatch that **dies** — API failure, tool failure — is re-dispatched against
the same inputs; Stage-1 outputs on disk are the resume point and are never
rebuilt for a dead dispatch. A dispatch that is **UNDISPATCHABLE** — forbidden
by an operator instruction, a permission mode or the harness — **is not a
dispatch that died**, and re-dispatch is not its remedy: retrying a forbidden
act returns the same refusal, and a session that improvises around it becomes
the evaluator it was forbidden to be. Where the restriction surfaces only here,
**halt back to the Stage-0 refusal** and its closing ask — one refusal, two
entry points. Under the BA's self-evaluated election and **only** under it, this
session may evaluate CC-S itself: **every verdict is stamped
`self-evaluated — no independent A pass`** in `trace.json`'s `a_pass` block and
on every render carrying it, and **the run's recorded status is forced
`INCOMPLETE`** — no later act in the run clears it.

**Both traces write their rows.** The backward trace is not optional and not
implied by the forward one: `trace.json` carries its rows, and Stage 3's
`Claims:` line counts them. A backward trace that did not run renders `0`
against an empty block — visible — never a number the render supplies.

**Incremental composition (run > 1, unless `--full`):** rows whose source or
whose carrier files the diff touched · everything not clean last run ·
CC-S-03 and CC-S-08 whole-band always. Everything else carries with its basis.

## Stage 3 — P-A1 · source-audit ruling

Assemble and render the pinned decision list — once, whole:

```
Source audit — run <n> · <date> · profile: <profile>
Sources read: <k> · unaudited ground: <named, with states | none>
Corpus covered: <the named corpus, walked | sample — <what was not walked>>
Obligations: <t> · carried <c> · partial <p> · accepted <a> · gaps <g>
Claims: <m> checked · ungrounded <u> · contradictions <x>
Status: INCOMPLETE — self-evaluated, no independent A pass
| # | CC-S | Evidence — source · place · "quote" | Band check — where it looked | Proposal → target | Default |
|---|------|--------------------------------------|-------------------------------|-------------------|---------|
Rulings: apply all · apply all except <#…> · <#>: SA <reason> · <#>: amend <note>
```

`Corpus covered:` is unconditional. `Status:` is **conditional** — it renders
only under the self-evaluated election (Stage 0 · Stage 2) and is absent from
every other run's head.

- Every row: verbatim quote with file and section · the named search set
  ("searched 001–006 §2/§3/acceptance, briefs E-01–E-04, roadmap,
  out-of-scope, WBS — no carrier" · "partial at 003 US-4 — extend there") ·
  one concrete proposal with its target · a default of `apply` or `SA`, so
  **`apply all` is a complete, safe ruling**. A row no default fits renders
  `amend`, asks exactly one question — **and enumerates every item it covers
  by name**: a ruling taken over unnamed members is an invalid render,
  corrected before P-A1 (run-1: an amend naming three of five dropped
  categories cost a mandatory scenario its carrier).
- **The header counts are derived, never asserted** (**D-S2**). The five
  numbers — `Obligations: <t> · carried <c> · partial <p> · accepted <a> ·
  gaps <g>` — are **counted from `obligations.md`'s rows by status at render
  time**, and from nothing else; `c + p + a + g = t`. `Sources read: <k>`
  counts Stage 1's per-source lines; the `Claims:` line counts `trace.json`'s
  backward rows. **A header whose numbers do not equal the on-disk row counts
  is invalid output** — the same bar this skill's invocation contract sets for
  a finding without its quote — and is corrected before the list renders, never
  rendered and explained. **A number a prior run rendered, a fixture carries or
  this session remembers is evidence of nothing.** Count the file.
- **Finding grain and list-row grain** (**D-S5**). CC-S-04's *each unmapped row
  is its own finding* governs the **A pass** and is untouched. This list's rows
  are the **ruling** grain: unmapped rows with **distinct dispositions** render
  distinct rows, because two dispositions cannot ride one answer; unmapped rows
  sharing **one** disposition are governed by **one enumerated `amend` row**
  naming every row it absorbs — and **its enumeration count must equal the
  unmapped-row count it absorbs**. Reconcile the two counts before rendering: a
  mismatch is an invalid render, and it is what let run-1's three-of-five amend
  reach the BA.
- Contradiction rows render both texts — the claim and the source quote —
  side by side. The BA rules which stands; the audit never does.
- The profile is read from the head, never asked. Under Presale this list is
  also client-agenda raw material; the render stays internal.
- **The floor.** Under a standing AG, Stages 0–3 may run AUTO; **P-A1 is the
  BA's in every mode.** Auto ends here at "list rendered, awaiting ruling",
  stamped `AUTO (AG-<n>)` in the entry.
- **The closing ask (§10.3 rule 9).** After the pinned list and its `Rulings:`
  line, the plain-English ask under `What I need from you:` — one lettered
  question per row, all in one
  AskUserQuestion call, each row's default the `(recommended)` option —
  `apply` glossed "make the proposed edit at the named target", `SA` glossed
  "decline it, on the record with your reason" — and an `amend` row carrying
  its one question verbatim with the members it covers named. Taking every
  recommended option is `apply all` exactly; the typed ruling grammar above
  stays the shortcut.

**Write `decision-list.md` — it is this stage's act, not a side effect**
(**D-S4**). The rendered list is written to the run workspace **before** the
ruling is asked for, and the ruling is written back into the same file when it
is given — *as rendered and as ruled*. **A clean run writes it too**, with its
`Rulings:` line and zero rows: *nothing found* is a result, and a result the
workspace does not hold is a result no later run and no reader can check. A
declined row becomes an SA record in `.specify/source-audit.md` — all fields,
reason in the BA's words, revisit trigger event-shaped. The writer refuses an
incomplete record.

## Stage 4 — the repair route

The P-A1 ruling is the route's `go`; ask for no second confirmation. Render
the §10.6 route shape and run the rows:

- **Spec edits** — dispatch the `ba-analyst` subagent per target spec,
  draft-first, assumption posture: approved proposals land as drafts with
  inferred values marked, exactly as Tier-2 fixes land. This skill authors
  nothing itself.
- **Upstream artifact changes** (glossary · roles-permissions · out-of-scope ·
  roadmap) — the routing discipline: the ruled proposal is the approval →
  write → the scoped health run fires silently.
- **Unowned obligations** — where no spec's epic owns the module, the row's
  proposal already named the brief and the Band-2 act; execute nothing
  band-2-shaped here beyond recording the routed signal.
- Record each row's outcome in `repairs.json`. A row that cannot execute
  stops nothing else; it lands in the report as `unexecuted — <why>`.

## Stage 5 — re-audit, delta, entry

Re-run Stages 1–2 incrementally over the repair diff. Render the delta —
obligations closed · claims resolved · anything newly surfaced — and append
the entry to `.specify/source-audit.md` per the pinned template
(`.specify/ba/templates/source-audit-report-entry.md`). Convergence is one
cycle; a second cycle still finding new rows files itself as a finding.

**Check the workspace before appending** (**D-S4**). The required set:
`obligations.md` · `trace.json` · `decision-list.md` **always**, a clean run
included; `repairs.json` **where the ruling produced at least one executable
row**. **Where a required file is missing the entry does not append** — name
the missing file and record the run `INCOMPLETE`. An append is a claim on an
append-only ledger that the run behind it happened; an entry that outruns its
own workspace makes that claim false for every later reader, and the ledger is
the one surface no later run can correct. The entry's `Status:` field carries
`complete`, or `INCOMPLETE` with its reason — the self-evaluated election
(Stage 0) forces the second in every mode.

**Escapes.** A source obligation surfacing downstream that no audit run
listed → `.specify/gate-tuning.md`, class `audit escape`, naming the CC-S
family that ought to have caught it, or "none — new class". The audit's
backstop shrinks to zero catches the same way the gate's does.

## What this skill never does

Never changes a gate verdict, a waiver, an override or a certification ·
never edits any file before the P-A1 ruling — except producing a missing `sources/*.extracted.md` rendering at Stage 0, capture completion and never band content · never authors repair content —
it dispatches `ba-analyst` and routes upstream edits · never treats a
question, a marker or a comment as a carrier · never renders a finding
without file + place + quote and the band-wide search set · never reports a
gap out of a corpus it did not cover · never renders a header number it did
not derive from the register on disk · never evaluates its own CC-S assertions
absent the BA's explicit self-evaluated election, and never retries a policy
refusal as if it were a dead dispatch · never appends a report entry over a
workspace missing a required file · never reads a
source the inventory did not capture · never re-proposes a standing SA
absent new source ground · never asks the BA for the profile — head or
nothing · never runs a per-feature audit — the band is the scope · never
proceeds past P-A1 under auto.

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
