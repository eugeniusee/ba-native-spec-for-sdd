---
name: ba-frame
description: Band-1 entry. Initializes the two aspect ledgers at six untouched aspects, takes the source inventory — scanning a reachable Slack workspace on the project name and offering one best-match candidate channel the BA confirms or declines — and the flow-profile pick at P-O0 - flow-profile selection and the scope frame at P-O0b - scope-frame selection in one render before any aspect opens, confirms the presale canvas is present and carried into the repo, and runs T-01 - Discovery canvas framing to produce one when it is absent. The birth act for .specify/aspect-state.md and .specify/aspect-plans.md; after it, the Stakeholders aspect is openable.
disable-model-invocation: true
---

# `/ba-frame` — Band-1 entry

**Argument:** none, or a path to the presale material the canvas will be framed
from (`/ba-frame fixtures/presale-brief.md`).

This is the first act of the framework in a project. It initializes the two
aspect ledgers and establishes the **substrate**: the presale canvas that Band 1
works over. With the substrate, the profile and the scope frame in place,
Stakeholders — the DAG's root — becomes openable.

## Invocation contract — check before you run

- **BA-invoked, never auto-fired.** Nothing about an install, a file appearing,
  or a project "looking new" triggers this. The BA runs it once, deliberately.
- **Refuse a second Frame.** If `.specify/aspect-state.md` already exists, stop
  and say so, printing the head. Band-1 entry happened; re-initializing would
  erase the event history, and bands never regress — nothing ever "returns to
  Band 1". A reopen degrades one aspect's state in place; it does not re-enter
  the band.
- **The orchestrator never authors.** This skill writes the two ledgers and,
  where the inventory captures a reachable source, one verbatim artifact per
  capture under `sources/` (Step 2). **Extraction is capture, never
  interpretation** — a capture is captured material, not authored content. The
  canvas, if one has to be produced, is the output of
**T-01 — Discovery canvas framing** under its
  own contract — dispatched, not written here.

## Step 1 — the ledgers

Create both from their templates, at `.specify/` top level:

| File | From | Initial content |
|---|---|---|
| `.specify/aspect-state.md` | `.specify/ba/templates/aspect-state.md` | head: `Band: 1 (open)`; `Profile:`, `Sources:` and the five scope-frame lines left for Step 2; the six-row table at `untouched`, `Since` and `Basis` empty; all four head lines `none` |
| `.specify/aspect-plans.md` | `.specify/ba/templates/aspect-plans.md` | the eight empty sections: `## Frame`, the six aspects, `## Band 2` |

Both files sit **outside `.specify/memory/`** and stay there. Orchestration state
is a runtime record, not one of the three content classes: out of CC-H-01's
spec-anchored glob, out of the scoped-run write trigger, out of any `memory/`
mirror toward the coding agent. Creating either one under `memory/` is a defect,
not a preference.

The six rows are always these six, in DAG order:

```
Stakeholders · Context · Value · Vision · Solution · Requirements
```

## Step 2 — the source inventory + P-O0 (flow-profile selection) + P-O0b (scope-frame selection)

**One render, one reply.** The source inventory, the profile picker and the
scope-frame block are the Frame act's **single stop**. They render together and
the BA answers all three in one reply: sources named, pasted, attached or
declined, then the profile pick, then the frame confirmed or corrected. Frame
costs **one** BA interaction, not three, and the Presale path's ≤ 8 budget with
its one interaction of slack stands unchanged. The reply itself may **carry**
sources: pasted content and attachments are captured exactly like a read
channel.

**Before you render — auto-pickup.** Scan the sources on hand — client
documents, a Slack extract, the canvas — for budget and scope constraints, and
**pre-fill the frame's values with their citations**. Cite-or-mark governs:
every value carries a citation or an explicit `open — no source material`.
Never guess a value. **`none stated` is a legal, recorded answer** for the
envelope — it becomes a named client question, never silence.

Auto-pickup runs against the **material on hand at render time** — the
inventory's first line is exactly that list. Sources the BA names, pastes or
attaches in the reply are captured *after* it, which is what the correction stop
below is for.

**A full checkpoint: render all three blocks, then stop.** The inventory is
taken and the profile and the frame are set here, **before any aspect opens**.
Render the source inventory **first**, ahead of the picker and the frame,
exactly:

```
Sources on hand: <list of supplied material>.
Slack — closest match on the project name: #<channel> — include it, or ignore it.   (renders only when Slack is reachable and the scan matched)
and <N> more matched — name them to see                                             (renders only when N ≥ 1)
Anything else? Slack channel(s) · email threads · drive folders · call recordings —
name them, paste them, or attach them; or "none".
```

It exists because nothing else asks. **T-01 — Discovery canvas framing** works
from the material *on hand*, and no act in the framework asked what stood beyond
it. The inventory is **Frame-act ground, never a technique's**:
**T-01 — Discovery canvas framing** asks nothing.

**The Slack candidate scan — the framework proposes, you dispose.** Where the
Slack integration is **reachable**, scan the workspace for a channel whose name
matches the project's, and offer the **best match** on the inventory's own line.

- **No opt-in, and no precondition.** Run the scan whenever Slack is reachable —
  whether or not the BA has already named a Slack source. The hole it closes is
  the source **nobody thought to name**.
- **Slack unreachable is zero delta.** Render the block exactly as it stands
  without the two candidate lines. Say nothing about a scan that did not run.
- **The key is the project name, and nothing else** — the name as it stands in
  the material on hand. **Never the client's name** (it returns every engagement
  with that client) and **never domain terms** (they return the workspace). **No
  project name on hand → no key and no scan:** a guessed key is a guess, and
  cite-or-mark forbids one.
- **List, then filter — there is no other method.** Enumerate the workspace's
  channels by **paging the broad listing to completion**, and filter
  **locally** for the project name. Name-keyed search against the Slack search
  endpoint is **removed from the scan entirely** — not demoted to a fallback,
  removed: the search tool's matching is reliable for **exact names and
  left-anchored prefixes only**; infix is fuzzy — which is why the scan lists
  and filters rather than searches.
- **A zero from a name-keyed search is inconclusive.** It says a query failed
  an opaque matcher, not that the channel is absent. Render "no match" **only
  after the local filter over the complete listing comes back empty** — never
  from a zero-result.
- **The match rule.** Tokenize channel names on `_` and `-`, case-insensitive;
  a channel is a candidate **iff every token of the project name appears among
  the channel's tokens**. The listing resolves names and metadata, never a
  message.
- **The best match is deterministic, from names alone:** exact name equality
  first, then fewest extra tokens, alphabetical tie-break. The complete listing
  is what makes `and <N> more matched` honest — a fuzzy search could never
  certify the count.
- **Resolve names, never content.** Read what channels are *called*. Read **no
  message** until the BA confirms the candidate — then read it under the capture
  mechanics below, unchanged.
- **One candidate, never a list.** Render exactly **one** channel — the best
  match — plus one count line where others matched:
  `and <N> more matched — name them to see`. **Two or more channels is a render
  defect** — the BA is confirming a source, not running a search.

**Disposition — the BA's, in the same one reply.**

- **Confirmed** — the candidate stops being a candidate. It is an **ordinary
  named reachable source** and inherits everything below unchanged: verbatim
  capture to `sources/slack-<channel>-<date>.md`, cite-or-mark mining, the
  `Sources:` head entry with its state, the three dispositions where a later read
  fails, and the correction stop where the capture contradicts the frame the BA
  has just confirmed. That stop is the one already budgeted — **the scan adds no
  second consumer of the slack.**
- **Declined** — **no ledger entry at all.** The `Sources:` line records
  **BA-named and BA-confirmed sources only**, and its four states are closed: a
  proposal the BA did not take was never a source. **Do not invent a fifth
  state.**
- **A candidate the reply does not answer is declined.** This does not weaken
  *silence never resolves a source* below: that rule governs a source the **BA
  named**. Your own proposal is not a hole in the BA's inventory, and ageing it
  into `named — pending` would manufacture the state that rule exists to prevent.

The candidate rides **inside** this block: one render, one reply, **no new
prompt point** and no extra BA interaction. The single reply that names other
sources, picks the profile and confirms the frame confirms or declines the
candidate in step.

Then the profile picker, in the same render, exactly:

```
Flow profile — pick one before any aspect opens (P-O0 — flow-profile selection):
1. Discovery — the full analysis path. Destination: certified feature specs.
2. Presale — the minimum technique set for limited client access.
   Destination: roadmap + open questions + assumptions on record;
   draft specs optional. Waivers expected.
Waiting for your pick. Switchable later; the switch is logged.
```

Then the scope frame, in the same render, immediately after it, exactly:

```
Scope frame — before any aspect opens (P-O0b — scope-frame selection):
1. Delivery boundary: <phase(s) of the ladder this engagement pays for> — default MVP
2. Budget envelope: <amount + currency> | none stated
3. Client label: <free text — how the client names it: PoC, prototype, pilot…> [cite | BA-supplied | open — no source material]
Parameters (defaults shown; edit or confirm):
  Rate: $50/h · Team mix: 3 fullstack eng + 1 QA + 1 BA + 1 PM (eng-share ~60%) · Capacity check: on
Waiting for your confirmation. Switchable later; the switch is logged.
```

Then **stop and wait.** Do not pick. Do not default to Discovery. Do not confirm
the frame on the BA's behalf. **Do not rule a source disposition on the BA's
behalf, and never read silence as one.** No aspect opens until the profile and
the frame are on record.

### Capture mechanics and reachability

**A source the framework can reach** — a Slack channel behind a connected
integration, a drive folder it can open — is read **bounded by what the BA
named** (the channel, an optional date range) and **captured verbatim into a
source artifact**. The artifact is then mined like any transcript under
cite-or-mark. **Extraction is capture, never interpretation:** the artifact is
the citation ground, and a mined line cites the artifact, never the live channel.

**A source the framework cannot reach** is said so plainly, with three
dispositions offered — **the BA rules; silence never resolves it**:

- **supply** — the BA pastes the relevant content or attaches an export;
  captured the same way;
- **skip** — recorded `skipped — <reason>`: a BA ruling,
  **T-01 — Discovery canvas framing**'s `N/A — <reason>` pattern at source grain;
- **pending** — recorded `named — pending`: a visible hole, Frame proceeds, and
  the source can arrive later.

Every named source lands on the ledger head's `Sources:` line with its state —
one of the four, never absence.

**Where a capture lands — `sources/` at repo root**, deliberately outside
`.specify/memory/` (the `canvas.md` placement), **one artifact per capture,
named for its origin**: `sources/slack-<channel>-<date>.md` ·
`sources/drive-<folder>-<date>.md`. **Placement only:** a capture is **captured
material, not certified content**. It joins **T-01 — Discovery canvas framing**'s
material on hand and reads like a supplied transcript; no assertion reads
`sources/`, and it enters no estate glob.

**A binary capture lands readable (§8.1 readability clause).** A source
arriving as docx · xlsx · pdf is captured **with a sibling mechanical
plain-text rendering** — `sources/<name>.extracted.md`, verbatim, extraction
never interpretation. Readers read the rendering; the original stays the
capture of record and citations name the source, never the rendering.
Without it a `Sources:` line can read `captured` while a later pass cannot
parse the file at all (Scope-S run-1 escape, 17 Aug 2026).

### The correction stop — P-O0b re-taken, never a new prompt point

A capture may **contradict or fill** a scope-frame value the BA has just
confirmed: the documents say `none stated`, the Slack channel's first message
says ≤ $50K. Where it does, render a **correction proposal** — the field · the
confirmed value · the captured value with its citation · the frame re-confirmed
or held.

This is **P-O0b — scope-frame selection, re-taken**: the frame's own switch act,
legal at any time and logged as the `scope-frame` event. It is **not a new
prompt point** — the P-O table is complete as it stands. It is a justified stop
under the checkpoint law: a materially different outcome hangs on it, and it
rides the ≤ 8 budget's one interaction of slack (7 + 1). **Captures consistent
with the frame produce no stop** — report and proceed.

**P-O0b (scope-frame selection) is a safety-floor act.** No autonomy grant
reaches it, in any
profile: the boundary and the envelope are what every later act is measured
against, and a grant that could set them would be a run choosing its own budget.
Under a standing grant the pre-fill still runs and the block still renders — and
it still waits for the BA.

**What a profile is (D-O14):** a **recommendation default, never a restriction**.
It filters which techniques the suggestion snapshot surfaces as full rows, and it
declares the flow's destination. It changes no threshold, no assertion, no gate —
the quality machinery is profile-blind. Out-of-profile techniques stay electable
by code at any **P-O2 — plan composition**.

**Discovery** — the full path. All 20 techniques in profile: 18 catalogue plus
the 2 spine techniques. Destination: certified feature specs and handoff (Band 3).

**Presale** — the minimum path to a scoped roadmap under limited client access.
Destination: **Band-2 exit, extendable to draft specs (D-O18)** — a current
roadmap (epics + phases), the open-question roll-up, every assumption on record
via markers and aspect waivers, and, where the presale needs them, **draft
feature specs**. A **draft spec** is not a new class or format: it is an ordinary
`spec.md` that stops before its effective PASS, carrying its unknowns as
`[NEEDS CLARIFICATION]` markers. Aspect waivers are the expected instrument here,
debt named — not an anomaly. **Band-3 drafting is in profile:** feature entry
(P-O8 — Band-3 entry) and **Tier 2 — spec-depth gap-filling** run in **assumption
posture** — draft-and-mark, with the gap questions that cannot reach the client
deferred as a BA-confirmed batch, standing as their markers. Certification and
handoff are not the presale destination: they stay behind existing gate law — no
effective PASS, no certification, no handoff — and are expected after a recorded
switch to Discovery. The gate stays BA-invocable at any time; on a draft spec its
FAIL report is an informative named-gap list — the client Q&A agenda.

In profile for Presale: **T-01 — Discovery canvas framing · T-02 — Glossary
discipline · T-03 — Stakeholder register · T-05 — Context & landscape mapping ·
T-06 — Constraints elicitation · T-08 — Value definition · T-09 — Vision &
differentiation · T-10 — Solution surface review · T-16 — Global out-of-scope ·
T-17 — Epics decomposition · T-18 — Scope allocation · Tier 2 — spec-depth
gap-filling (assumption posture)**, plus **Tier 1 — epic scoping interview** as
electable where a client call exists; where none exists, its ingestion step runs
on captured client material (RFP, client documents) as the notes input. Out of
profile: T-04 — Persona charters · T-07 — Competitive analysis · T-11 — Domain
(conceptual) modeling · T-12 — Roles & permissions · T-13 — Core process mapping ·
T-14 — Design & UX standards · T-15 — Constitution.

### The frame's values — what each one is, and what reads it

**The boundary accepts ladder values only** — `MVP` · `MVP + Phase 2` · … : the
project's phase ladder, `MVP` first, numbered phases after it, `Later` as the
open tail. **PoC and prototype are never boundary or phase values.** They live
in Client label and nowhere else.

**The machinery reads the boundary and the envelope. The label is
communication, read by nothing.** Its landed home is the canvas —
T-01 — Discovery canvas framing carries it into §13 Context/Constraints as a
cited line.

**Capacity — two operations, two risk classes.**

- **Envelope → capacity conversion, always on.** Pure arithmetic, no judgment:
  `envelope ÷ rate = team hours` → team mix → `× eng-share = parallel
  engineering hours`. It restates a stated constraint in other units and lands
  as the head's derived `Capacity:` line. **It is not estimation.** Recompute it
  whenever the envelope or a parameter changes; render `—` where no envelope
  stands.
- **The capacity check — a separately removable module, default `on`.**
  Assumption-grade rough sizing of the phase composition against capacity, with
  exactly one consumer: T-18 — Scope allocation's advisory text. Two hard
  limits. **Numbers appear only inside advisory prose** — never in the roadmap,
  a WBS, a spec, or any other artifact. And **zero tentacles** — no other rule
  depends on the module: with `Capacity check: off` the advisory degrades to its
  number-free form and nothing else changes.

Write the pick and the frame into the ledger head:

```
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason
Sources: <kind — state, per named source>  (captured <date> | named — pending | skipped — <reason> | none)
Boundary: <ladder value(s) — MVP | MVP + Phase 2 | …> — set <date> (P-O0b); switches append to Events with a reason
Budget: <amount + currency> | none stated  (<citation | BA-supplied | open — no source material>)
Client label: <free text — PoC · prototype · pilot…>  (<citation | BA-supplied | open — no source material>)
Parameters: rate <amount>/h · team mix <…> (eng-share <n>%) · capacity check <on | off>
Capacity: ~<n> eng-h (envelope ÷ rate × eng-share) | — (no envelope)
```

**Switching later is legal, and it is a ledger event with a reason** — never a
silent head rewrite:

```
<date> · profile · <from → to> · <BA initials> — <reason>
<date> · scope-frame · <from → to> · <BA initials> — <reason>
```

**Every named source records an event too** — the switch grammar at source
grain, appended for the life of the project:

```
<date> · source · <name> · <state> · <BA initials> — <basis>
```

**A constraint that arrives after Frame is a routed scope-frame-change
proposal** — a new client document, a client message — never a silent edit. It
fires T-18 — Scope allocation's scope-frame trigger.

**A late source brings zero new machinery.** A channel, thread or folder that
appears mid-band routes its content through the existing ingestion, and a
budget- or scope-shaped finding fires that same proposal and the same
**T-18 — Scope allocation** trigger. The capture itself follows the mechanics above unchanged: the
`Sources:` line appends the source with its state, and the Events entry records
it.

## Step 3 — the substrate

Check for `canvas.md` at the project root.

**Canvas present** (the presale entry — the normal case): confirm it is carried
into the repo, note it as the substrate in the Frame band event, and stop. Do not
lint it, do not re-shape it, do not fill it: the aspect gates read it as evidence
when they run, and the Frame act is not an aspect gate.

**Canvas absent** (a non-presale entry): producing one is the first Frame act — a
technique run *before any aspect opens*, so it is planned and contracted like any
other run, but its record lands in the plans file's `## Frame` section rather
than an aspect's.

1. Pin the output contract, and state it before running:
   `{presale canvas incl. the Context/Constraints element · Context · canvas.md}`
2. Record the plan line in `## Frame`.
3. Run **T-01 — Discovery canvas framing** with any presale material the
   BA supplied: read `.claude/skills/ba-t01/SKILL.md` and execute it as the
   procedure — its compiled P-O3 (technique invocation) check governs; no
   second command from the BA. That run authors `canvas.md`; this skill does
   not.
4. Book contract fulfillment in the `## Frame` run log —
   `fulfilled` · `partial — <what is missing>` · `failed — <why>`. `fulfilled`
   requires the artifact in its **pinned output shape** as well as at its
   destination; a shape divergence is a miss (orchestrator §6.3).

Either way, the canvas's sections then serve as the aspects' shared substrate.

## Step 4 — the band event

Append to `## Events` in the state ledger:

```
<date> · Band 1 entered · Frame · <BA initials> — canvas.md present (presale) | canvas.md produced by T-01 under {…}
  ledgers initialized: six aspects untouched · profile: <Discovery | Presale> (P-O0)
  scope frame set (P-O0b): boundary <…> · budget <…> · label <…> · capacity <…>
```

Then render the head (the same view `/ba-status` gives) and name the one act now
available: **`/ba-aspect stakeholders`** — the root, whose prerequisites are
satisfied by Band-1 entry itself. With the substrate, **the profile and the
scope frame** in place, Stakeholders is openable.

## What Frame is not

- **Not an aspect gate.** No AT criterion is read, no threshold is confirmed, no
  aspect changes state. All six stay `untouched` until the BA opens one.
- **Not a content act.** The canvas is not reviewed for quality here. Silence,
  stubs and holes in it are the aspect gates' business — that is exactly what
  makes them thresholds.
- **Not an arming act.** Scope H stays **disarmed** through all of Band 1: in-band
  quality belongs to the aspect gates. `/ba-close-band1` arms it, and not before.

## What this skill never does

Never edits `canvas.md` or anything under `.specify/memory/` · never opens an
aspect (that is `/ba-aspect`, a BA act) · never pre-creates a content stub —
absent and stubbed are the same hole to every AT criterion, and an installer- or
Frame-made stub would pollute the evidence · never runs a CC assertion · never
re-initializes a ledger that exists · **never picks the flow profile on the BA's
behalf, and never defaults to one** — P-O0 (flow-profile selection) is a BA act,
and no aspect opens until the pick is on record · never treats a profile as a
restriction: out-of-profile techniques stay electable by code ·
**never sets or confirms the scope frame on the BA's behalf, and never takes
P-O0b (scope-frame selection) under an autonomy grant** — the frame is a
safety-floor act · **never rules a source disposition on the BA's behalf, and
never reads silence as one** · never interprets a capture into the artifact it
writes, and never lands one under `.specify/memory/` — a capture is verbatim,
and `sources/` is its home · never writes a capacity figure into the canvas, the roadmap,
a WBS or any other artifact: capacity is a head line and advisory prose, nothing
else.

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
