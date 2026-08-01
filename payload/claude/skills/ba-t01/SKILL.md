---
name: ba-t01
description: T-01 Discovery canvas framing. Serves Frame - carries a presale canvas into the repo in framework shape, or drafts one where no presale ran, and extends it with the Context/Constraints element. Writes canvas.md at the repo root, the shared evidence substrate every Band-1 aspect gate reads.
disable-model-invocation: true
---

# `/ba-t01` — discovery canvas framing

**Serves:** `Frame` — the Band-1 entry act, not an aspect.
**Class:** Context · **Destination:** `canvas.md`, repo root.

Band 1's shared evidence substrate. The thirteen sections are exactly the
canvas-anchored threshold estate: every section is read by a named criterion —
Customers → AT-ST-1 · Problems → AT-VA-1 · Objectives → AT-VA-2 · Product
The/Is/That → AT-VI-1 · Competition Unlike + Context/Constraints → AT-CX-3 ·
Our Solution → AT-VI-2 · Forms / Core Functions / Third-Party / Localization →
AT-SO-1/-2/-3. This run seeds them at **framing grade**; the owning aspects
complete and clear them.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t01`.

Self-check, and stop if either half fails:

> the run is **on a composed plan** — for T-01 that is the `## Frame` section of
> `.specify/aspect-plans.md`, not an aspect section — **with its output contract
> pinned**: `{presale canvas incl. the Context/Constraints element · Context · canvas.md}`.

On a miss, stop and name `/ba-run` (which owns P-O3) or `/ba-frame` (which owns
the Frame plan line). Do not proceed on an unpinned contract.

**Skip-if — refuse the run and say which:** `canvas.md` is already present in
framework shape (thirteen sections, `P-n`/`O-n` line-IDs) and confirmed carried.
**A framed canvas is never re-framed.** Deepening its sections is aspect-sheet
ground — T-03 and T-05…T-10 — and the trigger cannot recur, because Band-1 entry
happens once.

## Depth boundary — framing grade, and it is a hard edge

Elicit at **section-level population from presale material**: named sponsor and
populations · one-line problems and objectives with line-IDs · the three
product-statement slots · enumerated functions · forms · connections ·
constraint one-liners.

**Must NOT descend into aspect-grade completion** — register rows (T-03),
constraint classes with `none identified — <basis>` bases (T-06),
function→objective linkage sweeps (T-10) — **nor anything spec-depth**, which is
Tier-2 ground.

**T-01 runs no question loop at all.** Holes stay visibly open; they are the
aspect suggestion engine's input. A question here would pre-empt the aspect that
owns the hole.

## Inputs loaded

All presale material the BA supplied, in whatever format it arrives — canvas
export, brief, deck, transcript, or nothing at all. **No context stack exists
yet:** Frame is first, and there is no `.specify/memory/` estate to read.

## Procedure

1. **BA act.** The run is invoked at the Frame act with the material on hand — or
   with none (a greenfield conversation).

2. **Framework act — parse or draft, and detect which.**
   - *A presale canvas exists:* parse it into the output template. Content is
     carried **verbatim per section**, and each carried line is tagged
     `[presale canvas]`. Other supplied material is read for what it adds, with
     its own citation.
   - *No canvas exists:* pre-draft all thirteen sections from what the BA
     supplied, cite-or-mark per line.

   **Real names are the requirement, never masked.** This canvas is the
   project's own repo artifact: the sponsor is named, the populations are named.
   A placeholder fails AT-ST-1.

3. **Framework act — line-IDs.** `P-n` on Problems, `O-n` on Objectives.
   Linkage notation `→ P-n` (Objectives) and `→ O-n` — or
   `→ <vision section>` — (Core Functions) is written **only where the material
   states it, never inferred silently**: linkage completion is AT-VA-2 / AT-SO-2
   aspect ground. Continuation: post-framing writes extend each sequence
   monotonically to the next unused `n`; a retired line's ID is never reused.

4. **Framework act — holes and conflicts, surfaced not smoothed.**
   - A section with no material is marked `open — no source material`. Never a
     fake `N/A`, never blank. The two states are distinct and stay distinct:
     `open — no source material` is a visible hole the suggestion engine reads;
     `N/A — <reason>` is a BA ruling.
   - Contradicting sources are carried **side by side** under a
     `[CONFLICT: <A> says … · <B> says …]` marker. Nothing is silently averaged.
     No reopen exists at Frame — nothing is gated yet — so the owning aspect
     resolves the conflict at first pass.

5. **Framework act — the framing report.** Session output, not a file:
   - sections populated, with their sources
   - sections open
   - conflicts carried
   - `N/A` candidates, each with a basis
   - which canvas-anchored criteria already show first-pass evidence —
     AT-ST-1 · AT-CX-3 · AT-VA-1 · AT-VA-2 · AT-VI-1 · AT-VI-2 · AT-SO-1 ·
     AT-SO-2 · AT-SO-3, by ID. Report what the sections show; **never confirm a
     criterion** — that is an aspect gate's act, never this run's.

6. **BA act — review and landing.** The BA corrects carried lines, rules each
   `N/A` candidate (`N/A — <reason>`, or leaves it open), then confirms the
   landing: `canvas.md` present and carried into the repo. The root aspect is now
   openable.

   **Ask for this review; never skip it.** The framework proposes, the BA rules.

## Output

`canvas.md` at the repo root — **deliberately outside `.specify/memory/`**, and
the only file this run writes. The framing report is session output; it is not a
file and does not land in a ledger.

The installed skeleton is `.specify/ba/templates/canvas-template.md` — copy it,
do not retype it. `references/example.md` carries the same thirteen sections with
a worked framing-grade example beside them.

**Stop at the output.** No next-act postamble: what happens after the canvas
lands is the orchestrator's, and `/ba-frame` says it.

## Signals

None. T-01 emits no routing batch and no reopen — at Frame there is nothing
gated to contradict, and every artifact home but this one is still empty. A
finding that would route elsewhere is carried as an open line or a `[CONFLICT: …]`
marker in the canvas and read by the aspect that owns it.

## What this skill never does

Never re-frames a canvas already in framework shape · never asks a question ·
never invents a name, a population, or a link the material does not state ·
never writes a fake `N/A` where the truth is `open — no source material` · never
resolves a conflict between sources · never confirms an AT criterion or clears
an aspect · never writes any file but `canvas.md` · never edits
`.specify/memory/`, a ledger, a brief or a spec.
