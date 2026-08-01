---
name: ba-clear
description: The aspect-gate confirmation act (P-O4). Assembles the threshold-evidence table for one aspect - per AT criterion an evidence pointer and met/not-met with every miss named - and takes the BA's CLEARED / NOT CLEARED / WAIVE ruling. Handles first-pass clearing (T2/T4) and delta re-clearing after a reopen (T6). An aspect gate never self-clears.
disable-model-invocation: true
---

# `/ba-clear <aspect>` — the confirmation act

**Argument:** one of the six aspects.

This is the **aspect gate**: the threshold check that clears one aspect. It runs
no CC assertion and produces no gate report. It is not "the gate" — that word,
unqualified, always means the contract runtime.

## Invocation contract — check before you run

- Aspect state must be `open`, `waived` (completing the evidence, T4) or
  `reopened` (re-clearing, T6). An `untouched` aspect has nothing to confirm —
  name `/ba-aspect`. A `first-pass-cleared` aspect is already cleared; re-running
  the table is legal as a read, but there is no transition to make.
- **Thresholds, not completeness.** Every criterion asks for the minimum evidence
  that makes dependent work non-speculative — never "the aspect is done". Aspects
  are never done; they stay alive for the project's lifetime.
- **Output discipline is inherited, not re-checked.** What the techniques wrote is
  already standard-shaped. Read the results; do not re-lint them, do not send the
  BA back for prose polish, and never fail a criterion for a reason the criterion
  does not state.

## Step 1 — assemble the evidence table

Read this aspect's criteria from `.specify/ba/cards/at-thresholds.md`. Use the
card's text as the pass condition — never a remembered paraphrase, never a
stricter reading.

Per criterion: **an evidence pointer (file + section)** and **met / not met, with
every miss named.**

```
Aspect gate review — <Aspect> — <date>
| AT | Evidence | Met |
|---|---|---|
| AT-ST-1 | canvas Customers: sponsor "Olena (network COO)"; populations Clients, Specialists | ✓ |
| AT-ST-2 | stakeholders.md: 4 entries, rights/comms filled; sponsor authority explicit | ✓ |
| AT-ST-3 | populations ⇄ register coherent; no contradiction | ✓ |
→ CLEARED · Y.K. · 2026-07-08
```

Three rules govern what may appear in the Evidence column:

- **Evidence, not vibes.** Name the artifact or canvas section the BA can point
  at and the condition it visibly meets. "Stakeholders are well understood" is
  not an entry; it is the absence of one.
- **Silence fails.** Where a criterion enumerates classes or sections, each shows
  real content **or** an explicit `N/A — <reason>` / `none identified — <basis>`
  line. An empty class is a miss, not a pass by default.
- **A miss names its element.** `✗ — constraints.md: regulatory class empty, no
  "none identified" line` — never a bare `✗`, never "needs work".

**Two conditionality notes are locked and travel with their criteria:**

- **AT-RQ-1 / design standards.** `design-standards.md` is *evidence-conditional*,
  reached only through "`constitution.md` plus every governance file it
  references". Where design/UX ground exists in Band-1 evidence, the
  constitution's reference lifts the file into the criterion's demand; where none
  exists, the constitution omits the reference, **the omission stands on the
  aspect record**, and AT-RQ-1 passes without it. Record which of the two applies.
- **AT-RQ-4 / "primary roles".** A role is significant at Band-1 grade **iff it
  stands as the actor of ≥ 1 canvas Core Function line**; the BA may elect
  further roles into the journey set. Significance is a checkable fact here, not
  an adjective.

## Step 2 — delta evidence (re-clearing after a reopen, T6)

When the aspect is `reopened`, do **not** re-confirm the whole table. **State the
scope before assembling it**, then re-confirm only:

(a) the criteria whose evidence the contradiction **or the fix** touched, and
(b) the corrected line itself.

**Untouched criteria carry, with the basis written down** —
`carried — evidence untouched by RO-<n> fix diff`. Say so in the table rather
than silently omitting the row; a carried verdict with no basis is the same
defect as a clearing with no evidence.

**Dependent reckoning**, one line each: diff each flagged dependent's evidence
table against the fix.

- **Touched** → the BA re-confirms that dependent; or, if the fix *contradicts*
  it, that dependent reopens too — a new RO, ruled on its own at `/ba-reopen`.
- **Untouched** → the flag drops, one line, with its basis.

## Step 3 — P-O4: the BA rules

Present the table and take one of three:

| Ruling | Execution |
|---|---|
| **CLEARED** — initials, date | **T2** (`open →`) or **T4** (`waived →`, and the AW closes `superseded — <date>`) or **T6** (`reopened →`, and the RO closes `resolved — <refs>`, flags drop) |
| **NOT CLEARED** | no transition; the named misses stand as the aspect's visible to-do |
| **WAIVE** | hand to `/ba-waive-aspect <aspect>` — T3 from `open`, T7 from `reopened` |

You may **propose** confirmation when a refresh shows all criteria met
("threshold evidence complete — confirm?"). You never confirm. **An aspect gate
never self-clears.**

## Step 4 — record

The table appends to `## Events` in `.specify/aspect-state.md` **as the
transition's basis** — the clearing names its evidence. Then the event line, and
the head row rewritten in place:

```
<date> · T2 · Stakeholders · open → first-pass-cleared · Y.K. — AT-ST-1..3 evidence table (below)
```

On a **NOT CLEARED**, append the table too, marked `→ NOT CLEARED`. A refused
clearing is a record, not a non-event: the misses are the to-do, and their
history is how threshold tuning later sees what kept costing cycles.

Close by naming what the clearing unlocked — the dependents now openable — or,
on a miss, the techniques that would fill the named holes.

## The handover rule — Requirements, and only once

AT-RQ is deliberately the **pre-arming image** of CC-H-01/-04/-05/-06. This
aspect gate confirms that ground **once**; `/ba-close-band1` arms Scope H; from
that moment the contract owns it.

**AT-RQ is never re-run on armed ground.** Post-closure debt on spec-anchored
artifacts is CC-H's, lifted by an `HA-<nn>` at the gate — never by an aspect
waiver. Re-clearing a `reopened` Requirements aspect post-closure touches only
the contradicted evidence under the delta rule, never the CC-H estate.

## What this skill never does

Never confirms on the BA's behalf · never passes a criterion on inference where
the card demands a visible line · never invents, softens or re-words an AT
criterion · never re-lints technique output · never runs a CC assertion or a
health run · never edits the artifact it is reading to make a criterion pass —
that is authoring, and the fix routes as content under BA approval · never
re-confirms untouched criteria in a delta review without recording that they
carried · never grants the waiver itself.
