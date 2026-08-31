---
name: ba-map
description: Render the project map - one installed project on one page. The dev-handoff answer per feature with its Spec-Kit compliance percentage over the gate's 24-assertion M set and the risk-if-handed-now rule, the 20-technique coverage against the plans file, the command surfaces evidenced from the estate, the wellbeing verdict, and the activity record. Takes --html for the derived offline render with charts. Read-only - it renders state, never changes it, never proposes content.
disable-model-invocation: true
---

# `/ba-map [--html]` — the project map

**Argument:** none, or `--html` — additionally write the derived HTML render.

One page for one installed project (map definition §1, D-M1): what the BA
work has produced, in what state it stands, whether the specs are ready to
hand to engineering **measurably**, and which of the framework's techniques
and commands have actually been applied. A sibling of `/ba-status` — the
dashboard is the session-start habit; the map is the wider instrument,
reached when you ask for it.

## Invocation contract

- **Read-only.** This skill changes nothing — not a state, not a record, not
  one file in the estate it counts. If rendering reveals that something
  should change, say so and name the skill that does it. Rendering is not
  deciding.
- If `.specify/aspect-state.md` does not exist, say so and name `/ba-frame` —
  Band 1 has not been entered.
- **The one file it may write is the derived HTML render**, and only on
  `--html`. Nothing else, ever.

## Running it

```bash
python3 .specify/ba/scripts/sk_map.py --root .
python3 .specify/ba/scripts/sk_map.py --root . --html
```

The profile is read from the ledger head, never asked.

## The pinned shape (map definition §2)

```
Project map — <project> — <date> · profile: <…> · Band: <…> · verdict: <wellbeing verdict>
Workflow ▕██████░░░░▏ <p>% — §10.4-F · dev-ready (B3) ▕█████░░░░░▏ <q>%
Dev handoff — Spec-Kit compliance per feature (the gate's 24-assertion M set):
  <feature> · <c>% · gaps <g> · W <w> · ⚑ <m> · risk: <r> · handoff: <yes — effective PASS <date> | no — <why>>
Techniques: <r>/20 run · <d> dropped (reason on record) · <p> planned · <n> no record · custom runs <c>
  no record: <codes>                                   (renders only when n > 0)
Commands: <e> evidenced (<list>) · <n> without record (<list>)
Questions: <o> open · <a> answered · markers <m>
Named (D-O58): <kind>: <detail> · …                    (renders only when any)
```

The shape governs (§10.3 rule 8). One handoff line per entered feature. The
two bars are §10.4-F's own — the workflow mean and Band 3's ratio; no bar
carries a number the formula does not already sanction.

## The measures (map definition §3)

**Spec-Kit compliance, per feature** = assertions standing met / 24 — the
gate's own M set, read from the feature's latest gate-report entry: certified
`(24 − W)/24` (a waiver is accepted debt, not a met assertion — the number
keeps the debt visible) · FAIL `(24 − gaps − W)/24`, the standing gap count
as the report states it · ungated `—`, **never 0%** (unmeasured is not zero).
The reader quotes the report and never re-runs an assertion.

**Risk if handed now, per feature** — for a certified feature, §10.4 line 8's
rule unchanged: low = all zero · elevated = any one non-zero · high = an
Override, or ≥ 3 combined, over W · O · surviving markers · HAs. Extended:
FAIL renders `high` with its gap count named; ungated renders `unassessed`,
and the handoff cell says why in words — an ungated feature is not handed off
at any risk level, because the boundary lifts per feature by the effective
PASS alone.

**The project-grain dev-ready % is not new** — it is Band 3's own §10.4-F
ratio, rendered on line 2. **No new composite**: the workflow line stays the
one sanctioned composite; everything here is a per-feature ratio with a named
source, or a rule.

**The wellbeing verdict** is a rule, first match wins (map definition §6):
*question-heavy* — open questions + markers ≥ 10, or a gate FAIL standing, or
a named near-miss, or refresh overdue ≥ 2 · *questions standing* — any of
those debts ≥ 1 · *dev-ready* — the profile's destination reached at zero
standing debt · *in motion* — everything else. Nothing is averaged into a
score; the thresholds are the map definition's text, tunable by version bump,
never silently.

## The coverage panels (map definition §4 · §5)

**Techniques.** The applicable set is fixed at **20** — the eighteen
catalogue techniques plus the two spine techniques (the epic scoping
interview and spec-depth gap-filling). Each renders run (dated) · dropped
(with its recorded reason) · planned · no record, read from the plans file's
composed plans and run logs; a custom technique is counted beside the roster,
never folded in. **An unapplied technique is not a defect** — election is the
BA's; the panel shows the ground actually walked, and an artifact standing
where its technique shows no record is the ledger under-recording the
dashboard's line 6 already names.

**Commands.** Twelve standing surfaces, each marked evidenced only where the
estate carries its record — ledgers, reports, exports. Render-only commands
leave no record by law, so *no record* is never rendered as *never ran*.

## The HTML render (map definition §7)

On `--html`, the command additionally writes `.specify/map.html` — beside the
runtime ledgers, the `/ba-status --html` precedent.

- **Self-contained, no script.** Inline styles and inline SVG only, **zero
  external resources** — it opens on a plane. Detail folds behind CSS-only
  hover/focus tooltips and collapsible sections, never JavaScript.
- **Charts carry one series each** — the two donut gauges, the per-feature
  compliance bars, the 20-slot coverage strip, the activity columns: one
  measure, one hue. State colors appear only beside a text label, never as
  adjacent colored segments.
- **Presentation, never new data.** The same counts, the same formulas, the
  chat render embedded verbatim; regenerated on every invocation, never
  hand-edited. **The chat render stays primary.**

## Named, never absent

Every reader inherits the near-miss law whole (D-O58): an unreadable spec, an
off-shape question row, an unparsed allocation entry is **named** — the path,
the line as authored, the shape expected — and never rendered as absence. The
reader reports; it never repairs.

## What this skill never does

Never edits the head or appends an event · never runs a CC assertion, a gate
run or a health run · never writes a run-log line to close a coverage gap it
reports · never signs, waives, certifies or hands off anything — it renders
the handoff answer and the acts stay their owners' · never invents a
composite beyond the one workflow line §10.4-F sanctions, and never estimates
a count the sources do not carry · never renders an unmeasured value as 0% ·
**never writes, never transitions, never proposes content** — rendering is
its whole act.

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
