# BA-Native Spec — the project map (`/ba-map`)

**Status:** ruled · 31 August 2026 — v0.1 · document-first under the one-way
rule (BUILD-LOG S9, closure note ii): this document is the source; the package
units in §9 compile from it and never the reverse.

**v0.1 change record:** seven rulings — **the project map**, ruled 31 Aug 2026
(**D-M1**–**D-M7**, amendment record §10; base commit `8867df7`, package
0.1.46; origin: the **owner ruling of 31 Aug 2026** — *"build the artifacts
map … show what is generated in which state … a measurable (score/%) result
for 'are we ready to pass the specs to the devs considering the compliance
with Speckit' and the risk assessment … for a single project"* — over the
prototype shape approved the same day): one render answers, for one installed
project, what the BA work has produced, in what state it stands, whether the
specs are ready to hand to engineering measurably, and which of the
framework's techniques and commands have actually been applied.

---

## 1. Position — what this is, and is not (D-M1)

**D-M1 — the map is one project, read-only.** `/ba-map` renders **one
installed project** — the project it is invoked in — under the orchestrator
rules **§10.4 read discipline**, unchanged: read-only, render-only; the
command never writes, never transitions, never proposes content; the one file
it may write is the derived HTML render, and only on `--html`. It is a
**sibling of `/ba-status`**, not a replacement: `/ba-status` is the
session-start habit and the nine-line dashboard; `/ba-map` is the wider
instrument — the dev-handoff answer, the coverage panels, the charts — reached
when the BA asks for the map. A cross-project mode does not exist in this
edition; if one is ever wanted it is a new ruling, not a flag.

**Sources.** Exactly §10.4's two source classes — the ledgers (activity) and
the estate on disk (coverage) — **plus two reads of records the dashboard does
not open**: the install manifest (`.specify/ba/manifest.md` — the package
edition and install date; the installer's own certificate, D-P2-14's ground)
and the **body of each feature's latest gate-report entry** (the standing gap
count and the waivers in force — the report's own words, §3). Every count the
map shares with `/ba-status` is computed by `sk_status.py`'s own readers,
imported and never restated — the §10.5 one-fact-one-reader rule.

## 2. The pinned chat render — primary (D-M7, shape half)

```
Project map — <project> — <date> · profile: <…> · Band: <…> · verdict: <wellbeing verdict, §6>
Workflow ▕██████░░░░▏ <p>% — §10.4-F · dev-ready (B3) ▕█████░░░░░▏ <q>%
Dev handoff — Spec-Kit compliance per feature (the gate's 24-assertion M set):
  <feature> · <c>% · gaps <g> · W <w> · ⚑ <m> · risk: <r> · handoff: <yes — effective PASS <date> | no — <why>>
Techniques: <r>/20 run · <d> dropped (reason on record) · <p> planned · <n> no record · custom runs <c>
  no record: <codes>                                   (renders only when n > 0)
Commands: <e> evidenced (<list>) · <n> without record (<list>)
Questions: <o> open · <a> answered · markers <m>
Named (D-O58): <kind>: <detail> · …                    (renders only when any)
```

The shape governs (§10.3 rule 8). One handoff line per entered feature, in
folder order. The two bars are §10.4-F's own: the workflow mean, and Band 3's
ratio — no bar carries a number the formula does not already sanction. On
`--html` a tail line names the written file, the `/ba-status --html`
precedent verbatim: derived, regenerated per invocation, never hand-edited.

## 3. Dev handoff — the measurable answer (D-M2 · D-M3)

The question the panel answers is the owner's own: *are we ready to pass the
specs to the devs, considering the compliance with Spec Kit?* The gate **is**
the Spec-Kit-compliance instrument — its M set certifies the spec
`/speckit-plan` consumes with zero manual rework — so the measure reads the
gate's record and never re-runs an assertion.

**D-M2 — Spec-Kit compliance, per feature.** `compliance = assertions
standing met / 24` — the M set's own size (build plan §2.4; check-m's 24
exercised assertions), read from the feature's **latest gate-report entry**:

- **certified** — `(24 − W) / 24`, W = the waivers in force. A waiver is
  accepted debt, not a met assertion: an effective PASS with waivers renders
  below 100%, and the debt stays visible in the number.
- **FAIL(n)** — `(24 − n − W) / 24`, n = the standing gap count **as the
  report states it** (an incremental run's verdict already carries the
  standing set; this reader quotes it, never re-derives it).
- **ungated, or an entry without a readable verdict** — `—`, never 0%
  (§10.4-F's zero-denominator discipline: unmeasured is not zero).

**The project-grain number is not new.** The dev-ready % of the project is
**Band 3's own §10.4-F ratio** — certified/entered under Discovery,
drafted/readable under Presale — rendered on line 2. **No new composite
enters this document** (D-O27: the workflow line is the one sanctioned
composite; everything else here is a per-feature ratio with a named source,
or a rule).

**D-M3 — risk if handed now, per feature.** For a **certified** feature the
verdict is §10.4 line 8's rule, unchanged and unsoftened: over W · O ·
surviving markers · HAs in the dependency set — low = all zero · elevated =
any one non-zero · high = an Override, or ≥ 3 combined; never averaged.
Extended to the states line 8 does not reach: **FAIL(n)** → `high` with its
gap count named; **ungated** → `unassessed` — and the handoff cell answers in
words: an ungated feature is not handed off at any risk level, because the
session boundary lifts **per feature by the effective PASS alone** (§10.2 ·
gate §11). The panel's head line answers the question for the project: YES
when every entered feature is certified; NOT YET with the blockers named;
under Presale, the §6.5 note — certification and handoff out of profile —
rendered as law, never as failure.

## 4. Technique coverage — the ground actually walked (D-M4)

**D-M4 — the roster is fixed at 20, and unapplied is not a defect.** The
applicable set is the framework's own total: **18 catalogue techniques
(T-01…T-18, the catalogue index) + 2 spine techniques (Tier 1 — epic scoping
interview · Tier 2 — spec-depth gap-filling; elicitation §3.1 · §5.1)**. The
roster compiles into the unit at build time with this citation — the layering
rule's compiled-IDs form; no runtime path reads the catalogue.

Each technique renders one of four states, read from the plans file
(`.specify/aspect-plans.md`, §6.4) — its composed-plan rows and §7.3 run-log
lines, matched by code:

| State | Read from |
|---|---|
| **run** — with its first date | a run-log line, or a plan row whose Status starts `run` |
| **dropped** — with its recorded reason | a plan row whose Status starts `dropped` |
| **planned** | any other plan-row status |
| **no record** | nothing in the plans file names the code |

A technique run under a custom name (the Q2+ path, orchestrator §6.3) never
matches a code and is **counted beside the roster**, named with its date —
never folded into the 20. **Unapplied is not a defect**: election is the
BA's (D-O14 — the profile filters suggestions, restricts nothing), and this
panel shows the ground actually walked, not a completion target. An estate
artifact standing where its technique shows `no record` is the **ledger
under-recording** the dashboard's line 6 already names — the map repeats that
line's fact (§6) and repairs nothing.

## 5. Command coverage — evidenced from the estate (D-M5)

**D-M5 — twelve standing surfaces, each with a named evidence read.** The
map marks a command *evidenced* only where the estate carries its record:

| Command | Evidence |
|---|---|
| `/ba-frame` | the aspect-state ledger exists; the `Band 1 entered` event's date |
| `/ba-close-band1` | the head's Band line carries `closed <date>` |
| `/ba-enter-feature` | ≥ 1 `specs/NNN-*/` folder |
| `/ba-gate` | ≥ 1 `## Gate run` entry across the reports, counted |
| `/ba-gate-health` | ≥ 1 recorded health run; the standing verdict beside it |
| `/ba-reopen` | an `RO-<n>` reference on the ledger |
| `/ba-waive-aspect` | a waived aspect, or a standing AW |
| `/ba-wbs` | the `exports/` directory; else line 8's own ready/blocked read |
| `/ba-audit` | `.specify/source-audit.md` exists |
| `/ba-dev-ready` | the recorded Presale → Discovery profile switch |
| `/ba-auto` | the head's `Auto:` line |
| `/ba-humanizer` | the head's `Humanizer:` line; absent reads `off` (D-O97) |

**Render-only commands leave no record by law** — `/ba-status`, `/ba-wbs`'s
render half, this map itself — so *no record* is never rendered as *never
ran*: the panel states the caveat once, and a command without record may
still have run. The map never writes a record to close the gap.

## 6. The wellbeing verdict — a rule, not a score (D-M6)

**D-M6 — the verdict rule.** One word on the head line, first match wins,
over counts the render already carries — q = open §6 questions across the
briefs · ⚑ = surviving `[NEEDS CLARIFICATION]` markers across drafted specs ·
a **named near-miss** = an unreadable spec, an off-shape question row, or an
unparseable allocation entry (D-O58's set) · overdue = line 5's refresh
count:

- **question-heavy** — q + ⚑ ≥ 10, or a gate FAIL standing, or a named
  near-miss, or refresh overdue ≥ 2.
- **questions standing** — q + ⚑ ≥ 1, or refresh overdue = 1, or the run log
  under-records the estate (line 6's fact).
- **dev-ready** — the profile's destination reached at zero standing debt:
  every entered feature certified (≥ 1 entered) under Discovery; `/ba-wbs`
  ready under Presale.
- **in motion** — everything else: work moving, no debt on record yet.

The rule is the whole of the verdict — nothing is averaged into a score (the
line-8 pattern), and the thresholds are **this text**, tunable by version
bump, never silently. The verdict names attention, not blame: *question-heavy*
is a project whose open unknowns have outgrown its answers, which is exactly
when a BA plans elicitation.

## 7. The HTML render — `--html` → `.specify/map.html` (D-M7, render half)

**D-M7 — the two renders.** The chat render (§2) is primary and pinned. On
`--html` the command additionally writes **`.specify/map.html`** beside the
runtime ledgers — the D-O29 derived-render law, extended three ways for an
instrument with charts:

- **Self-contained, no script.** Inline styles and inline SVG only; **zero
  external resources and zero `<script>`** — the offline law as
  `audit-stats.html` carries it. Detail folds behind CSS-only disclosure:
  hover/focus tooltips and `<details>` — never JavaScript.
- **Charts carry one series each.** The donut gauges (workflow · dev-ready),
  the per-feature compliance bars, the 20-slot coverage strip and the
  activity columns each encode **one measure in one hue**. The four state
  colors appear only in their **status role — always beside a text label,
  never as adjacent colored segments** (the CVD floor fails the gray and
  amber adjacencies; a chart that needs a categorical legend of states is not
  drawn).
- **Presentation, never new data.** The same counts, the same formulas, the
  chat render embedded verbatim; regenerated on every invocation, never
  hand-edited; the chat render stays primary.

## 8. Near-misses — D-O58 applies whole

Every reader this map runs inherits §10.4's blind-spots law unchanged: a
near-miss is **named** — the path, the line as authored, the shape expected —
and **never rendered as absence**; `missing` is claimed only where nothing is
there. The map adds one naming of its own: the **manifest edition** renders
on the head line, read from the project's own manifest — the map and the
manifest install together, so the edition names the instrument as well as the
estate. The reader reports; it never repairs.

## 9. Package units — what compiles from this document

| Unit | Carries |
|---|---|
| `payload/specify-overlay/ba/scripts/sk_map.py` | §1's read discipline · §2's chat shape · §3's formulas · §4's roster and states · §5's evidence table · §6's rule · §7's render law · §8 |
| `payload/claude/skills/ba-map/SKILL.md` | the route, the pinned shape, the never-list, the three standing blocks |
| `tests/check-map.sh` | the shape · the golden counts · the formula edges · the verdict rule both sides · the HTML law · read-only proof · the skill |

## 10. Amendment record

- **v0.1 — 31 August 2026.** Drafted and ruled in one session (D-M1–D-M7):
  the single-project position, the compliance and risk formulas, the
  20-technique roster, the command evidence table, the verdict rule, the two
  renders. Origin: the owner ruling of 31 Aug 2026 over the same-day
  prototype; base `8867df7`, package 0.1.46.
