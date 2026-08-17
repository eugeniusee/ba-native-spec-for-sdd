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
  trace.json           forward + backward traces
  decision-list.md     the P-A1 list, as rendered and as ruled
  repairs.json         the executed route, per-row outcome
```

`<n>` is monotonic and band-global: read `.specify/source-audit.md`, take the
highest `## Source audit run <n>`, add one. The report ledger and the standing
`SA-<nn>` records live at `.specify/source-audit.md` — append-only,
operational state, never quoted into a spec.

---

## Stage 0 — admission

1. At least one `specs/NNN-*/spec.md` exists? If not, refuse and name the act:
   `/ba-run specs all` (Presale) or `/ba-enter-feature` (Discovery).
2. Read the ledger head. The `Sources:` line is the audit's ground: every
   source standing `captured` is read from `sources/` or its recorded
   attachment; every source standing `named — pending` or `skipped` goes on
   the report head as **unaudited ground**, verbatim, with its state. The
   audit never reaches for material the inventory did not capture — a thin
   `Sources:` line is a finding about the inventory, not a license to browse.
3. Assemble the band read set, all read-only: every `specs/NNN-*/spec.md` and
   its `gate-report.md` · every `.specify/memory/scope/<E-nn>.md` ·
   `.specify/memory/roadmap.md` · out-of-scope · `canvas.md` · standing
   `SA-<nn>` records · `exports/wbs.csv` when present.

## Stage 1 — the obligations register (collect-all)

Build `obligations.md` per the source-audit definition §2: every numbered
section, list item, table row, worked example, scenario and acceptance table
of every captured source; every client-authored ask and recorded decision in
a captured channel. Row grammar:

```
OB-<nnn> · <source-file>#<section> · "<quote ≤ 2 lines>" · shall|should|context
  · phase claim · carrier | none · status
```

Three rules are load-bearing and non-negotiable:

- **Union.** Two sources defining one list or scope → one row at union width,
  both sources named. An addendum extends its base; the base never truncates
  the addendum.
- **A comment is not a carrier.** Stories, acceptance items, brief lines,
  roadmap rows, out-of-scope entries, deferral rows and SA records carry.
  Questions, markers and Comments cells do not.
- **The critic pass.** After the primary walk, re-walk each source asking
  only: *what here maps to no register row?* Rows it adds are marked
  `critic`. Skipping the critic is skipping the audit's own audit.

## Stage 2 — the traces and the assertion pass (never halts, collect-all)

Trace forward (every OB row → its carrier across the whole band read set) and
backward (every scope-bearing claim — story, integration, role, phase label,
stated basis — → its ground). Then dispatch the `ba-gate` subagent: the run
workspace path, `.specify/ba/cards/assertions-s.md`, and the explicit CC-S
list to evaluate — all eight families on a full run, the incremental set on a
re-run. Write its JSON to `trace.json`'s `a_pass` block. Do not edit its
verdicts; a missing or surplus assertion is a runtime defect — re-dispatch.

**Incremental composition (run > 1, unless `--full`):** rows whose source or
whose carrier files the diff touched · everything not clean last run ·
CC-S-03 and CC-S-08 whole-band always. Everything else carries with its basis.

## Stage 3 — P-A1 · source-audit ruling

Assemble and render the pinned decision list — once, whole:

```
Source audit — run <n> · <date> · profile: <profile>
Sources read: <k> · unaudited ground: <named, with states | none>
Obligations: <t> · carried <c> · partial <p> · accepted <a> · gaps <g>
Claims: <m> checked · ungrounded <u> · contradictions <x>
| # | CC-S | Evidence — source · place · "quote" | Band check — where it looked | Proposal → target | Default |
|---|------|--------------------------------------|-------------------------------|-------------------|---------|
Rulings: apply all · apply all except <#…> · <#>: SA <reason> · <#>: amend <note>
```

- Every row: verbatim quote with file and section · the named search set
  ("searched 001–006 §2/§3/acceptance, briefs E-01–E-04, roadmap,
  out-of-scope, WBS — no carrier" · "partial at 003 US-4 — extend there") ·
  one concrete proposal with its target · a default of `apply` or `SA`, so
  **`apply all` is a complete, safe ruling**. A row no default fits renders
  `amend` and asks exactly one question.
- Contradiction rows render both texts — the claim and the source quote —
  side by side. The BA rules which stands; the audit never does.
- The profile is read from the head, never asked. Under Presale this list is
  also client-agenda raw material; the render stays internal.
- **The floor.** Under a standing AG, Stages 0–3 may run AUTO; **P-A1 is the
  BA's in every mode.** Auto ends here at "list rendered, awaiting ruling",
  stamped `AUTO (AG-<n>)` in the entry.

Write the ruling into `decision-list.md`. A declined row becomes an SA record
in `.specify/source-audit.md` — all fields, reason in the BA's words, revisit
trigger event-shaped. The writer refuses an incomplete record.

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

**Escapes.** A source obligation surfacing downstream that no audit run
listed → `.specify/gate-tuning.md`, class `audit escape`, naming the CC-S
family that ought to have caught it, or "none — new class". The audit's
backstop shrinks to zero catches the same way the gate's does.

## What this skill never does

Never changes a gate verdict, a waiver, an override or a certification ·
never edits any file before the P-A1 ruling · never authors repair content —
it dispatches `ba-analyst` and routes upstream edits · never treats a
question, a marker or a comment as a carrier · never renders a finding
without file + place + quote and the band-wide search set · never reads a
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
the conversation** — the band-boundary report and the resumption report are the
only BA-facing renders of an auto cycle (`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
