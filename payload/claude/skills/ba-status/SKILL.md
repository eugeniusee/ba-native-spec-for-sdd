---
name: ba-status
description: Render the aspect-ledger head - the band line, the flow profile, the six aspect states, standing aspect waivers, open reopens, upstream flags and deferred consequences - plus the next available acts and the project dashboard, nine lines with per-band coverage bars, the workflow line, the ledger-coverage self-report and the banded handoff-risk rule. Takes --html for the derived offline render. The session-start habit's natural home. Read-only: it renders state, never changes it, never proposes content.
disable-model-invocation: true
---

# `/ba-status [--html]` — the ledger head

**Argument:** none, or `--html` — additionally write the derived HTML render.

One screen, read from `.specify/aspect-state.md` and the estate it conducts.
This is the **session-start habit's natural home**: the corpus has no daemon,
so the way drift and standing debt get seen is that somebody looks, at a
defined touchpoint, and this is that touchpoint.

## Invocation contract

- **Read-only.** This skill changes nothing — not a state, not a record, not the
  head, not one file in the estate it counts. If rendering reveals that
  something should change, say so and name the skill that does it. Rendering is
  not deciding.
- If `.specify/aspect-state.md` does not exist, say so and name `/ba-frame` —
  Band 1 has not been entered.
- **The one file it may write is the derived HTML render**, and only on
  `--html`. Nothing else, ever.

## The render

Read the head verbatim; do not recompute it from the events, and do not
summarize it into prose. Then add the derived lines below it.

```
Band: 1 (open) | 1 (closed <date>) — Bands 2/3 capable
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason
Boundary: <ladder value(s) — MVP | MVP + Phase 2 | …> — set <date> (P-O0b); switches append to Events with a reason
Budget: <amount + currency> | none stated  (<citation | BA-supplied | open — no source material>)
Client label: <free text — PoC · prototype · pilot…>  (<citation | BA-supplied | open — no source material>)
Parameters: rate <amount>/h · team mix <…> (eng-share <n>%) · capacity check <on | off>
Capacity: ~<n> eng-h (envelope ÷ rate × eng-share) | — (no envelope)

| Aspect | State | Since | Basis |
|---|---|---|---|
| Stakeholders  | first-pass-cleared | 2026-07-08 | evidence table, this file |
| Context       | … |
| Value         | … |
| Vision        | … |
| Solution      | … |
| Requirements  | … |

Standing aspect waivers:  none | AW-<n> · <aspect> · <AT-IDs unmet> — revisit: <event>
Open reopens:             none | RO-<n> · <aspect> — <conflict, one line>
Upstream flags:           none | <aspect> flagged: prerequisite <aspect> reopened
Deferred consequences:    none | RO-<n>: <item> — trigger: <event>
```

### Derived — what is available now

Compute from the states and the DAG (`Stakeholders → Context, Value`;
`Context + Value → Vision`; `Vision → Solution`; `Solution → Requirements`):

- **Openable** — every `untouched` aspect whose prerequisites are all
  `first-pass-cleared` or `waived`. Name the act: `/ba-aspect <aspect>`.
  An aspect whose prerequisite is `reopened` is **not** openable — a reopen
  blocks *new* opening through itself, while existing dependent states stand.
- **Open aspects** — for each, its named misses (the aspect's visible to-do,
  from the last evidence refresh) and its next planned technique, if the plan
  has one.
- **Closure eligibility** — all six `first-pass-cleared` or `waived`, and zero
  `reopened`. Say which of the two conditions is unmet when it is not.

### The lazy read — revisit triggers, displayed here

Whenever the head carries a standing AW, a deferred consequence, or an open
reopen, **display its revisit trigger on this render**. That display *is* the
mechanism: **no scheduler exists** anywhere in the framework, and a trigger
nobody reads is a trigger that never fires. This render and the band acts are where the
BA reads them.

If a displayed trigger's event has plainly happened, say so plainly and name the
act (`/ba-waive-aspect <aspect>` to re-affirm or lapse; `/ba-clear <aspect>` if
the debt is now evidenced). Do not act on it.

## The project dashboard

The wider view, rendered under the head. **Read-only, two source classes.**

| Class | Reads | For |
|---|---|---|
| **Activity** | the ledgers — the aspect-state head and events, `.specify/aspect-plans.md` (composed plans and run logs), `.specify/gate-health.md`, the W/O/HA records | what the framework has done |
| **Coverage** | the estate on disk — `specs/NNN-*/` and their `spec.md`, the latest `gate-report.md` entry per feature, the briefs and kits in `.specify/memory/scope/`, `.specify/memory/roadmap.md`, the briefs' open-question statuses | how much of the project the work has reached |

Coverage reads the estate on the WBS export's precedent: the same certified
check, the same parent-epic hop off the spec's own §10 References. Two renders
of one fact must never disagree, so neither re-reads it its own way.

### Running it

```bash
python3 .specify/ba/scripts/sk_status.py --root .
python3 .specify/ba/scripts/sk_status.py --root . --html
```

The profile is read from the ledger head, never asked. `--profile` overrides it
for a headless run.

### The pinned shape

```
Project status — <project> — <date> · profile: <…> · Band: <…>
Workflow ▕██████░░░░▏ <p>% — §10.4-F
1 · Band 1 — Foundations ▕██████████▏ <s>/6 settled (<c> cleared · <w> waived — debt on record) · closed <date> | open
2 · Band 2 — Scoping     ▕████████░░▏ briefs <b>/<e> epics · kits <k>/<e> · roadmap current <date> | missing
3 · Band 3 — Delivery    ▕██████░░░░▏ entered <n> across <x>/<e> epics · drafted <d>/<n> · gated <g> (latest: <verdicts>) · certified <c> · handed off <h>
      Presale note: certification & handoff out of profile — destination: draft specs + the Q&A agenda (§6.5)
4 · Questions: <o> open · <a> answered · <v> overtaken · oldest: <ref — one line, standing since <where>>
5 · Health: Scope H <armed — HEALTHY | n gaps | disarmed (pre-closure)> · refresh <current | overdue: <r> runs vs cadence> · acceptances: <n>
6 · Ledger coverage: <clean | run log under-records: <k> on disk vs <l> logged (<where>)>
7 · Techniques: <runs> run / <planned> planned · next planned: <code — name>
8 · Discovery → Handoff risk per certified feature: | Feature | W | O | surviving markers | HAs in deps | Risk |
       Rule: low = all zero · elevated = any one non-zero · high = an Override, or ≥ 3 combined
    Presale  → Exit readiness: roadmap <current?> · drafted <d>/<n> · open markers <m> · `/ba-wbs` <ready | blocked: <why>>
9 · Next: <the one act the state points to — code + name>
Auto: <on — AG-<n> · scope <…> · since <date> | off — last AG-<n> ratified <date>>
      trail <n> AUTO acts · unratified <u>     (renders only once an AG exists)
```

### The counts, each with its source

| Count | Is |
|---|---|
| **settled** | `first-pass-cleared` or `waived` in the head |
| **briefs · kits** | files in `.specify/memory/scope/`, against the roadmap's epic rows |
| **entered** | a `specs/NNN-*/` folder exists |
| **drafted** | its `spec.md` carries at least one User Story |
| **gated** | at least one `gate-report.md` entry; the latest verdict is shown |
| **certified** | the latest entry carries a certification manifest — the gate's own fact, never re-verified here |
| **handed off** | the handoff record present |
| **epic breadth** | distinct parent epics among the entered features |
| **open markers** | surviving `[NEEDS CLARIFICATION]` markers across drafted specs |

`/ba-wbs` reads *ready* when the roadmap is current and at least one spec is
drafted; *blocked* names the missing piece.

### The formula

**§10.4-F.** B1 = settled/6 · B2 = briefs/epics · B3 = drafted/entered under
Presale, certified/entered under Discovery. Workflow % = the mean of the three;
each band's bar is its own ratio at ten cells; the top bar is the mean. A zero
denominator renders `—`, never 0%. The formula is this text — tunable by
version bump, never silently.

**The workflow line is the one sanctioned composite.** Every other composite
stays banned: do not average the risk table into a score, do not roll the nine
lines into a rating, do not invent a second percentage anywhere on this render.

### The auto-trail section

**Append-only, and conditional.** The nine numbered lines are untouched. The
`Auto:` section renders **only once an autonomy grant exists in the ledger** — a
project that has never run autonomously shows nothing here. Four facts, each a
ledger read: **mode** from the head's `Auto:` line · **the grant** — its id,
scope, and the on-date or the ratification date · **trail** = AUTO-stamped acts
in Events under that grant · **unratified** = those no ratification event covers
yet.

Rendering the trail is not ratifying it. This skill never writes a grant, an
AUTO stamp, or a ratification — `/ba-auto` owns all three.

### Three lines that need saying plainly

- **Line 5 is display only.** It compares the full runs recorded in
  `.specify/gate-health.md` against the gate's own cadence — one full run per
  scope-brief ingestion batch, plus the arming run at Band-1 closure. Reporting
  `overdue` is the whole of this line's act. **The refresh belongs to
  `/ba-gate-health`**, which this skill never runs and never proposes as
  automatic.
- **Line 6 is the instrument reporting its own blind spots.** It compares the
  Band-2 and Band-3 artifacts on disk against their run-log lines in
  `.specify/aspect-plans.md` and names the divergence in both directions. An
  under-recording ledger is a fact to show, never one to paper over — and never
  one to repair in passing: this skill does not write the run log.
- **Line 8 renders one variant, by profile.** Out-of-profile facts render as
  **law, not failure**: under Presale, "certification & handoff out of profile"
  is where the method ends, not where the project is behind. Never render an
  out-of-profile count as a gap.

**The risk rule is the whole of line 8's Discovery verdict** — a stated rule
over four countable facts: waivers (W), overrides (O), surviving
`[NEEDS CLARIFICATION]` markers, and health acceptances touching the feature's
dependency set. It is tunable in the field by version bump, **never silently**.
Do not soften it, do not add a fifth factor, do not average it into a score.

Line 7 and line 9 carry **code + name** — `T-05 — Context & landscape mapping`,
never a bare code. Where a source is missing, say which and render the value as
`—`; never guess a count. A Scope H that has never run reads
`disarmed (pre-closure)`, which is a fact, not a gap.

## The HTML render

On `--html`, the command additionally writes `.specify/status.html` — beside the
runtime ledgers, under the same rule that keeps them out of `.specify/memory/`.

- **Self-contained.** Inline styles only, **zero external resources** — no
  stylesheet, no font, no script, no image fetched from anywhere. It opens on a
  plane.
- **The same counts and the same formula.** Presentation, never new data: the
  chat render is embedded in the file verbatim.
- **Derived, never hand-edited.** Regenerated on every invocation; a hand edit
  dies at the next run. It is the gate's `traceability.md` precedent, applied
  to a dashboard.
- **The chat render stays primary.** The file is for sharing and for reading
  later, never the thing the BA is answered with.

## What this skill never does

Never edits the head or appends an event · never confirms a clearing, grants or
lapses a waiver, or rules a reopen · never runs a CC assertion or a health run
(`/ba-gate-health` is the gate's, and its own session-start habit is separate
from this one) · never writes a run-log line to repair the divergence line 6
reports · never re-derives the head from the events and silently "corrects" it —
a head that contradicts its events is a defect to report, not to repair in
passing · **never writes, never transitions, never proposes content** —
rendering is its whole act · never invents a composite beyond the one workflow
line the formula sanctions, and never estimates a count the sources do not
carry · never writes, closes or ratifies an autonomy grant, and never renders
the auto-trail section when no grant exists.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
