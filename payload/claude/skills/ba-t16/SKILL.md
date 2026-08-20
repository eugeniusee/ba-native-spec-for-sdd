---
name: ba-t16
description: T-16 — Global out-of-scope. Serves Requirements against AT-RQ-1. Sweeps the solution surface for plausible adjacent expectations, classifies each survivor in the lives-instead vocabulary, names the expectation every row fences, and writes .specify/memory/out-of-scope.md.
disable-model-invocation: true
---

# `/ba-t16` — global out-of-scope

**Serves:** Requirements. **Class:** Context ·
**Destination:** `.specify/memory/out-of-scope.md`.

The product-level fence: **the exclusions someone could plausibly expect *the
product* to include, each naming where it lives instead**. The decision this run
lets the BA make: what the product will not do, on the record, with each
exclusion's destination named.

**The grain is the product, and the other grain is not yours.** Per-feature Out
of Scope fences a feature's neighbors and lives in that spec; this file fences
the product's. No spec exclusion restates this file — product-level boundaries
are *referenced*, and keeping the two grains apart is what makes that possible.

**It runs last in the aspect, deliberately.** The fence is drawn with the full
solution surface and the requirements infrastructure visible — against a visible
estate, not a guess.

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t16` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{the product-level fence — at least one exclusion, each naming where it lives instead and the expectation it fences · Context · .specify/memory/out-of-scope.md}`.

**On a pass** — render one line:
`T-16 — Global out-of-scope → .specify/memory/out-of-scope.md`, and begin. No
confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect requirements` to open and compose. Nothing else runs;
nothing else is explained.
The stop closes per §10.3 rule 9 — `What I need from you:` with the repairing
act as the `(recommended)` option.

**Skip-if — refuse the run and say so:** the file is present, seeded (**≥ 1
exclusion**), stub-free, and **no unfenced adjacency stands** in the current
evidence. Post-closure boundary maintenance — graduation, retirement, new fences
— arrives by **routing batches and reopen signals, not by re-invocation**.
Exhaustive fencing of every conceivable adjacency is **enrichment on BA ask**.

## Depth boundary — product-boundary grade, and it is a hard edge

Per row: **the excluded capability in one line · where it lives instead · the
plausible expectation named, with its citation**.

**Must NOT expand into:**

- **per-feature exclusions.** *Notification preferences — deferred* is a fence
  around one feature's neighbors and belongs in that spec's own section. It never
  enters this file.
- **allocation.** A deferred row carries a **phase hint** as a roadmap candidate;
  naming epics and phases is Band-2 ground.
- **soliciting allocation-grade settlements.** The boundary question stays at
  **whether the product ever**, never **which phase**.
- **duplicating roadmap content after decomposition.** A roadmapped item resolves
  to its epic or leaves this file; it does not live in both.

## Inputs loaded

In this order:

1. `canvas.md` — §§7–9 (function lines, connection rows, localization) and §11
   (the differentiation, whose boundary is often the fence's own argument)
2. `.specify/memory/competitive-analysis.md` — the **Covers** entries the product
   does not cover
3. `.specify/memory/constraints.md` — rows that exclude a data or capability class
4. `.specify/memory/context.md`
5. transcripts and routed findings — declined mentions, "outside the product"
   rulings
6. `.specify/memory/glossary.md`
7. the current `out-of-scope.md` — routed exclusion findings already in it are
   input

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — last,
   with the full surface visible.

2. **Framework act — the adjacency sweep.** Expectation candidates from: each
   function line's **adjacent capabilities** (what a function's neighbor suggests
   the product also does), each connection row's **unclaimed side**, competitor
   **Covers** entries the product does not cover, constraint rows excluding a
   data or capability class, declined mentions in transcripts and routed
   findings. **Per candidate, name the plausible expectation with its source — a
   fence no one would test is noise, and it is dropped with the sweep note.**

3. **Framework act — classification.** Per surviving candidate, one value from
   the lives-instead vocabulary:

   - `not planned` — the product will not do it
   - `deferred — roadmap candidate, <phase hint>` — the product may, later;
     allocation is Band-2's
   - `outside the product — <owner>` — another system or party keeps owning it

   A candidate that is really a feature-grain fence is surfaced as spec ground
   and left out.

4. **Framework act — pre-draft and questions.** Rows drafted, cite or mark per
   row. Unclear boundaries become destination-tagged questions **at product
   grade — whether the product ever does X**, never which phase.

5. **BA act — the rulings.** Every row is a boundary ruling. **≥ 1 exclusion at
   seed** — and where genuinely none exists, the instrument is **the aspect
   waiver on Requirements, never an invented row.** A fence written to satisfy a
   count is ritual compliance, and it is worse than the empty file it hides. A
   candidate contradicting cleared ground — an exclusion fighting a canvas
   function line — is a **reopen signal**.

6. **Framework act — write and report.** Write `out-of-scope.md`. Report which
   criteria the run moved — AT-RQ-1 — and what remains open. The evidence-table
   refresh and the confirmation proposal belong to this skill's run-end block; the
   clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/out-of-scope.md` — a short header stating the two-grain split,
then **one section**:

`## Exclusions`, carrying
`| Exclusion | Where it lives instead | Basis · source |`

**Every `Where it lives instead` cell is one of the three vocabulary values** —
or, after decomposition, a named epic a deferred row resolved to.

**Every `Basis · source` cell names the plausible expectation and cites it.** A
row that cannot say why anyone would have expected the capability is not a fence;
it is a list entry.

The template and a worked example are in `references/example.md`.

Plus routed batches where the sweep found cross-cutting ground.

## Signals

- **Routing batch** — a swept finding whose home is another artifact. Proposed,
  BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Graduation note** — when decomposition lands, a `deferred` row whose
  capability became an epic resolves to that epic or retires, **by a routed edit
  the decomposition run proposes**. This skill is not re-invoked for it, and an
  epic contradicting a standing exclusion is a reopen signal on Requirements.
- **Waiver referral** — where the sweep genuinely finds no adjacency worth
  fencing, say so and name the aspect waiver as the instrument. Do not write a
  row.

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

Never writes a per-feature exclusion · never names an epic or a phase — a
deferred row carries a phase **hint** and nothing more · never asks which phase ·
never invents a row to satisfy the seed minimum · never fences a capability
nobody would have expected · never duplicates a roadmapped item · never edits
`roadmap.md` or the canvas outside an approved batch · never confirms an AT
criterion or clears an aspect · never runs a CC assertion.

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
