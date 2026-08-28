---
name: ba-t05
description: T-05 — Context & landscape mapping. Serves Context against AT-CX-1. Puts the ground the solution lands on onto paper at helicopter grade - the systems that exist today and the organizational landscape - or the sourced greenfield line where systems genuinely do not exist, and writes .specify/memory/context.md.
disable-model-invocation: true
---

# `/ba-t05` — context & landscape mapping

**Serves:** Context. **Class:** Context ·
**Destination:** `.specify/memory/context.md`.

The ground the solution lands on, on paper: the systems that exist today and the
organizational landscape, at helicopter level — so vision and solution work lean
on **stated reality rather than assumed greenfield**, and every later integration
or NFR conversation starts from a named landscape. The decision this run lets the
BA make: the landscape picture is faithful and complete at helicopter grade —
**including the explicit, sourced greenfield ruling** where systems genuinely do
not exist.

**This sheet describes what exists. What *binds* is the constraints technique's
ground.** A landscape fact that binds the solution is routed there; the landscape
keeps the descriptive side of it. That split is the whole difference between the
two runs, and it is not stylistic.

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-t05` is the one-step entry: typing it
**is** the BA's invocation act — P-O3, technique invocation. No prior command
is required; none is requested.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Context aspect, which is `open` or
> `reopened`, **with its output contract pinned**:
> `{context & landscape — existing systems + organizational landscape, or the sourced greenfield line · Context · .specify/memory/context.md}`.

Context opens on Stakeholders being `first-pass-cleared` or waived; if that
edge is unmet, say so rather than running early.

**On a pass** — render one line:
`T-05 — Context & landscape mapping → .specify/memory/context.md`, and begin.
No confirmation dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect context` to open and compose. Nothing else runs; nothing
else is explained.
The stop closes per §10.3 rule 9 — `What I need from you:` with the repairing
act as the `(recommended)` option.

**Skip-if — refuse the run and say so:** AT-CX-1 reads met in the current
evidence table — for instance a landscape carried from a prior engagement and
confirmed current at Frame. Depth beyond helicopter grade — system inventories,
org charts — is **enrichment on BA ask**, never a hole this run fills on its own
initiative.

## Depth boundary — helicopter grade, and it is a hard edge

Elicit **per system**: name · role today · expected disposition **where the
material states it**. Elicit the **org landscape** as short cited lines —
structure and operating model, at project relevance.

**Must NOT descend into:**

- **integration specifics** — directions, payloads, failure expectations. Those
  are scoping and spec ground; asking them here is a question with no destination
  in this file.
- **constraint rows** — a bind has an imposer and lives in `constraints.md`. This
  file records that a system exists and what it does today.
- entities and relations — the domain model's ground
- competitor entries — the competitive technique's ground
- the cast list — the register says who exists and who decides; this file says
  what the organization *is shaped like*

## Inputs loaded

In this order:

1. `canvas.md` — **Third-Party Connections and the Context/Constraints element
   first**; every intended connection implies a today-system to record
2. presale material and kickoff notes
3. `.specify/memory/stakeholders.md`
4. `.specify/memory/glossary.md`
5. the current `.specify/memory/context.md`, if one exists — **routed arrivals
   may already be in it. Arrival is never gated**, so the file can carry content
   that pre-dates this run, and that content is input, not noise.

## Procedure

1. **BA act.** Context is opened and its plan composed; the run is invoked.

2. **Framework act — pre-draft the landscape.** Draft the existing-systems rows
   and the organizational lines from the canvas, the presale material, the
   kickoff notes and any routed arrivals already in the file. **Every line is
   cited or marked.** A disposition is written only where the material states one;
   otherwise the cell says so.

3. **Framework act — the remaining holes become questions.** Each question is
   **destination-tagged before it is asked**: to a systems row, an org line, or
   **the greenfield ruling itself**. A question serving none of the three is
   illegal and must not be emitted.

4. **BA act — answers and the absence rulings.** The BA answers or edits, and
   rules the greenfield and scoped-absence lines. **An absence is sourced, never
   assumed**: `greenfield — no existing systems — <source>` is a ruling with a
   basis behind it, and a scoped absence ("no booking software exists today")
   carries its source the same way. Silence is not evidence of emptiness.

5. **Framework act — boundary routing.** A landscape fact that **binds** the
   solution is proposed to `constraints.md` — the landscape row keeps the
   descriptive side, the constraint row takes the binding side. Neither is
   deleted in favor of the other.

   **First pass and later are different situations, and the difference is
   mechanical.** Within Context's own still-open content a conflict is ordinary
   correction. A finding contradicting **cleared** ground — the register, canvas
   Customers — is a **reopen signal**.

6. **Framework act — write and report.** Write `context.md`. Report which criteria
   the run moved — AT-CX-1 — and what remains open. The evidence-table refresh and
   the confirmation proposal belong to this skill's run-end block; the clearing
   itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/context.md` — two sections:

- **`## Existing systems`** — a table: `System · Role today · Disposition (where
  stated) · Source`, with scoped absence lines beneath where a class is genuinely
  empty. **Full greenfield case:** the table is replaced by the single sourced
  line `greenfield — no existing systems — <source>`.
- **`## Organizational landscape`** — short cited lines.

The template and a worked example are in `references/example.md`.

Plus a proposed batch toward `constraints.md` where the boundary routing found a
bind.

## Signals

- **Routing batch** — landscape facts that bind, proposed to `constraints.md`.
  Proposed, BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.

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

Never writes a constraint row · never asks for an integration direction, payload
or failure expectation · never models an entity or a relation · never records a
competitor · never rewrites the cast list · never assumes greenfield — an absence
without a source is a hole, not a ruling · never treats a routed arrival as
noise · never confirms an AT criterion or clears an aspect · never runs a CC
assertion.

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
