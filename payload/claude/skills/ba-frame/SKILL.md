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
| `.specify/aspect-state.md` | `.specify/ba/templates/aspect-state.md` | head: `Band: 1 (open)`; `Profile:`, `Sources:` and the eight scope-frame lines left for Step 2 — the `Cross-cutting:` line born carrying its English default (D-O74), the `Acceptance shapes:` line born `none found` (D-O78); the six-row table at `untouched`, `Since` and `Basis` empty; all six standing-instrument head lines `none` — `Standing aspect waivers:` · `Open reopens:` · `Upstream flags:` · `Deferred consequences:` · `Scope advisories:` (the advisory register, D-O68) · `Changes:` (the change register, D-O102 — an absent line reads `none`, and `/ba-change` writes it thereafter); `Auto: off` and **`Humanizer: off`** born from the template — the humanizer switch is off at ledger creation, and an absent line reads `off` (D-O97) |
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
documents, a Slack extract, the canvas — for scope constraints — the boundary,
decisions, obligations, acceptance shapes; **no amount** (D-O105) — and
**pre-fill the frame's values with their citations**. Cite-or-mark governs:
every value carries a citation or an explicit `open — no source material`.
Never guess a value. **`none stated` is a legal, recorded answer** — it becomes
a named client question, never silence.

**The scope-decision harvest (D-O65) — auto-pickup extends from values to
decisions.** Scan the same sources for **negotiated engagement-scope decisions**
and pre-fill line 3, one entry per decision:
`SD-<n> — <the decision, one line> (<verbatim citation>)`. **The class is narrow
by ruling:** a decision *agreed between client and provider about engagement
composition* — an option selection among proposals, an explicit trim, an agreed
scope/module list, an agreed staging — and nothing else. Requirements, wishes
and priorities are discovery ground — they belong to
**T-01 — Discovery canvas framing**; the budget has its own line; timeline is
neither. **Every harvested decision carries its verbatim citation**,
and the verbatim ground lives in the cited source artifact — no new artifact
class. **`none found` is a legal, recorded state** — it lands on the head line,
never as silence. **An ambiguous candidate is asked, never guessed:** render it
on the same line as `SD-? — <candidate, one line> (<citation>) — keep or
discard`, resolved in the same single Frame reply.

**The stop count is untouched:** the SD line rides inside the P-O0b block — one
render, one reply (D-O42, extended by D-O45 and by D-O65), no new prompt point.
**Autonomy is untouched by composition:** P-O0b sits on the never-AUTO safety
floor (D-O42), so SD confirmation is BA-only under any grant.

**The cross-cutting harvest (D-O73) — auto-pickup extends from decisions to
obligations.** Before rendering the block, scan the same sources for
**cross-cutting obligations** — the five classes of the head's `Cross-cutting:`
line: **language · device · accessibility · branding · compliance** — and
pre-fill line 4 with one entry per obligation:
`XO-<n> — <class>: <value, one line> (<verbatim citation>)`. Cite-or-mark
applies unchanged: **every harvested obligation carries its verbatim
citation**, and the verbatim ground lives in the cited source artifact — no new
artifact class. **An ambiguous candidate is asked, never guessed:** it renders
on the same line as
`XO-? — <candidate, one line> (<citation>) — keep or discard`, resolved in the
same single Frame reply.

**The stop count is untouched here too:** line 4 rides inside the P-O0b block —
one render, one reply (D-O42, amended on the record by D-O73 exactly as D-O65
amended it, never superseded), no new prompt point, and the ≤ 8 Presale budget
stands arithmetically untouched. **Autonomy is untouched by composition:** P-O0b
sits on the never-AUTO safety floor (D-O42), so XO confirmation is BA-only under
any grant.

**The acceptance-shape harvest (D-O78) — auto-pickup extends from obligations to
acceptance shapes.** Before rendering the block, scan the same sources for
**engagement-level acceptance shapes** — a pass list, success criteria, a
definition of done, an acceptance table governing the delivery as a whole — and
pre-fill **line 5** with one entry per **item**:
`AS-<n> — <acceptance item, one line> (<verbatim citation>)`.

**The class is narrow by ruling:** it names what the client will accept the
delivery against; **per-feature acceptance criteria are spec ground and are
never harvested here** — requirements and wishes stay discovery ground
(**T-01 — Discovery canvas framing**'s). **Item grain:** "accepted when booking
works end-to-end, reminders fire, admin can export" is **three entries**, each
independently checkable.

Cite-or-mark applies unchanged: **every harvested item carries its verbatim
citation**, the verbatim ground living in the cited source artifact — no new
artifact class. **`none found` is a legal, recorded state** — it lands on the
head line, never as silence. **An ambiguous candidate is asked, never guessed:**
it renders on the same line as
`AS-? — <candidate, one line> (<citation>) — keep or discard`, resolved in the
same single Frame reply.

**The stop count is untouched here too:** line 5 rides inside the P-O0b block —
one render, one reply (D-O42, amended on the record by D-O78 exactly as D-O65
and D-O73 amended it, never superseded), no new prompt point, and the ≤ 8
Presale budget stands arithmetically untouched. **Autonomy is untouched by
composition:** P-O0b sits on the never-AUTO safety floor (D-O42), so AS
confirmation is BA-only under any grant.

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
Slack — closest match on the project name: #<channel> (archived) — include it, or ignore it.   (renders only when Slack is reachable and the scan matched; "(archived)" only when the candidate is archived)
Slack — no channel matches the project name · listed <n> channels (public + private, archived included).   (renders only when Slack is reachable, the listing completed, and the scan found no match)
Slack — listing interrupted at <act>: covered <n> of <m | unknown> pages — corpus not established; no negative rests on it.   (renders only when the listing was cut before completion; a matched candidate still renders on its own line)
and <N> more matched — name them to see                                             (renders only over a completed listing, when N ≥ 1)
<k> channel(s) excluded by BA ruling                                                 (renders only when k ≥ 1)
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
- **List, then filter — there is no other method, and the listing declares its
  corpus.** Enumerate the workspace's channels by **paging the broad listing to
  completion**, and filter **locally** for the project name. **The corpus is
  every channel the workspace holds — both visibilities, every archive state.**
  A retrieval parameter left at its default is **presumed narrowing**:
  visibility and archive state are set **explicitly**, never by omission.
  Name-keyed search against the Slack search endpoint is **removed from the
  scan entirely** — not demoted to a fallback, removed: the search tool's
  matching is reliable for **exact names and left-anchored prefixes only**;
  infix is fuzzy — which is why the scan lists and filters rather than
  searches.
- **A zero from a name-keyed search is inconclusive.** It says a query failed
  an opaque matcher, not that the channel is absent. Render "no match" **only
  after the local filter over the complete listing comes back empty** — never
  from a zero-result.
- **An end-of-results terminator certifies the query, never the workspace.**
  The tool reports exhaustion of its own filtered result set. Completeness is a
  property the scan **establishes**, never a signal it **receives** — until
  every axis is set explicitly the listing is a sample, and a sample reports
  what it found, never what does not exist.
- **A zero-channel listing is a tool fault, never a finding.** And where a
  Slack source already stands on the `Sources:` line, the listing **must
  surface it — a listing that misses a known channel is void**, and no render
  rests on it.
- **A listing cut before completion yields a partial corpus.** A permission
  denial, a rate limit, a tool fault — any interruption. **Retry a retryable
  cut first:** a listing that completes on retry is complete and declares
  nothing. Where the cut stands, the corpus is a **sample**, and the sample is
  not symmetric:
  - **A positive stands.** A hit is a hit — render the candidate line
    unchanged and let the BA dispose of it as they dispose of any candidate.
  - **No negative, and no counts.** Never render
    `Slack — no channel matches the project name …`: it is one line carrying
    both a negative and a completeness claim, and a partial corpus grounds
    neither. Never render `and <N> more matched` — the complete listing is
    what makes `<N>` honest. **`<k> channel(s) excluded by BA ruling` still
    renders:** it states what *you* removed on the BA's own ruling, never what
    the workspace holds.
  - **Render the cut — never stay silent about it.** The interrupted line of
    the block above: what you covered, where it was cut, and that the corpus
    is **not established**.
  - **Never convert a cut into a negative.** No fallback to the endpoint
    removed above · no narrowing of an axis to make a listing "finish" — a
    default is presumed narrowing · no second scan whose smaller corpus is
    reported as the first one's.
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
- **Excluded channels leave the scan (D-O70).** A channel standing
  `excluded — <reason>` on the `Sources:` line is **filtered out of the
  candidate ranking and out of `<N>`**, and where the filter removed any, the
  block renders one line: `<k> channel(s) excluded by BA ruling`. **Filtered
  and named, never silently dropped** — the complete listing is what makes
  `<N>` honest, so a count that quietly omitted an exclusion would break the
  one guarantee paging the listing bought. And **never re-ask a ruling the BA
  already made** — at the single Frame stop, of all places.

**Disposition — the BA's, in the same one reply.**

- **Confirmed** — the candidate stops being a candidate. It is an **ordinary
  named reachable source** and inherits everything below unchanged: verbatim
  capture to `sources/slack-<channel>-<date>.md`, cite-or-mark mining, the
  `Sources:` head entry with its state, the three dispositions where a later read
  fails, and the correction stop where the capture contradicts the frame the BA
  has just confirmed. That stop is the one already budgeted — **the scan adds no
  second consumer of the slack.**
- **Declined** — **no ledger entry at all.** The `Sources:` line records
  **BA-named and BA-confirmed sources only**, its **five-state vocabulary**
  (D-O48 extended by D-O70) **is closed**, and a proposal the BA did not take
  was never a source, and **never gets a state of its own.**
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
2. Client label: <free text — how the client names it: PoC, prototype, pilot…> [cite | BA-supplied | open — no source material]
3. Scope decisions: <SD-<n> — <the decision, one line> (<citation>), per harvested decision> | none found
4. Cross-cutting: <XO-<n> — <class>: <value, one line> (<citation>), per harvested obligation> | XO-1 English default only
5. Acceptance shapes: <AS-<n> — <acceptance item, one line> (<citation>), per harvested item> | none found
Waiting for your confirmation. Switchable later; the switch is logged.
```

Then **stop and wait.** Do not pick. Do not default to Discovery. Do not confirm
the frame on the BA's behalf. **Do not rule a source disposition on the BA's
behalf, and never read silence as one.** No aspect opens until the profile and
the frame are on record.

**The closing ask (§10.3 rule 9) — appended after the three pinned blocks,
never inside them.** Close the render with the final plain-English block: every
open item of this one stop — each source disposition, the profile pick, the
frame confirmation, every `SD-? / XO-? / AS-?` keep-or-discard candidate —
becomes one specific question a person who has never read the framework can
answer, every code glossed in plain language beside it. Present the enumerable
items through the AskUserQuestion tool — single-select, one question per open
item, the stop's items batched into one call, each with an "other / free text"
escape; items past the tool's per-call capacity ride the lettered block itself.
Options are lettered; exactly one per question carries `(recommended)` — the
pre-filled, cited value where one stands; for a keep-or-discard candidate, the
disposition its citation grounds best, `discard` where the ground is thin. The
marker never pre-selects and never auto-applies. Transcribe the selections into
the single Frame reply's existing grammar — the typed reply ("none · Presale ·
frame confirmed …") stays a legal shortcut, never the only channel.

**The Slack item is never folded (D-O90).** Whenever any of the three pinned
Slack lines rendered in the inventory above — match · no-match · interrupted —
the ask carries **one dedicated Slack question, immediately after the
sources-completeness item**, shaped by the line that rendered: exactly one of
the three item-2 variants below — never two, and never zero. **The Slack
outcome never rides inside the sources-completeness question.** Where no Slack
line rendered — Slack unreachable, or not integrated — the reachability
dispositions below govern and **no item is invented**: the ask proceeds from
the sources item straight to the profile question and the numbering closes up.

The shape, for this stop:

```
What I need from you:
1. Sources — is the list above complete?
   a. complete as shown (recommended)
   b. add more — name, paste or attach them
2. The Slack channel #<channel> — read it as a source?   (the match variant — renders only when the match line rendered)
   a. include it (recommended) — its name matches the project
   b. ignore it
2. I listed <n> channels (public + private, archived included) and none matches the project name. Is there a channel I should read anyway?   (the no-match variant — renders only when the no-match line rendered)
   a. none — proceed without Slack (recommended)
   b. yes — name it
2. I covered <n> of <m> pages — I could not establish the full channel list. How should we proceed?   (the interrupted variant — renders only when the interrupted line rendered)
   a. re-run the listing to completion (recommended — a negative never rests on a sample)
   b. name the channel yourself
   c. proceed without Slack
3. Which flow fits this engagement?
   a. Presale — limited client access; destination: roadmap + open questions (recommended) — canvas.md is present
   b. Discovery — the full analysis path to certified specs
4. The scope frame — do the pre-filled values hold?
   a. confirm as rendered (recommended) — every value carries its citation
   b. correct — name the line and the new value
5. SD-? — "<candidate, one line>": a negotiated scope decision, or not?
   a. keep it (recommended) — the citation reads as an agreed trim
   b. discard it — not a negotiated decision
Reply with the letters, or answer the questions above in your own words.
```

One render, one reply — the ask adds no interaction and no prompt point, and
the three pinned blocks above stand byte-untouched.

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
**one of the five, never absence.** The fifth is `excluded — <reason>` (D-O70,
below); D-O48's closed four-state vocabulary is extended on the record, never
rewritten.

### The excluded source — `excluded — <reason>` (D-O70)

The BA may rule any **named artifact** out of the framework's reach — a file, a
URL, a channel, a folder — **at the inventory or at any later moment**. Record
the ruling `excluded — <reason>` on the `Sources:` line.

**It is a state, not a triage outcome.** Reachability is irrelevant to it, so
the three dispositions above — supply · skip · pending — **stand exactly as they
are and gain nothing**: the artifact an exclusion most often has to reach is the
**reachable** one, which a triage-only vocabulary could never name.

**Grain is the named artifact, and a container is one.** Excluding a channel, a
folder or a URL **covers everything inside it**; a narrower exclusion is named
narrowly. Never make a BA enumerate the contents of a folder they have chosen
not to read.

**The law, in three clauses.**

1. An excluded artifact is **never captured**.
2. It is **never mined** — no capture of it exists to mine.
3. A link or reference encountered inside **any** capture that resolves to an
   excluded artifact is **never followed**.

**The encounter is recorded, never silently skipped.** Append one Events line
per **distinct excluded artifact per capture, deduplicated**, on the existing
source grammar — **no new event kind exists**:

```
<date> · source · <artifact> · encounter — not followed · <BA initials> — excluded <date>
```

The actor field carries the **BA's initials**: the framework is acting under the
BA's own exclusion ruling. **Deduplication is the whole of the flood control** —
a capture carrying forty references to one excluded folder writes **one** line,
and a capture carrying none writes none.

**An exclusion hides nothing.** The artifact stands on the `Sources:` line with
its reason, every encounter stands in Events, and **only capture and following
stop**. An exclusion that produced no record would be indistinguishable from a
source nobody thought of — which is the hole the inventory exists to close.

**Switchable, on the frame's own precedent.** An exclusion is **liftable at any
time**: the state changes on the `Sources:` line, the switch appends a `source`
Events line with its reason, and the lifted artifact becomes an **ordinary named
source under the mechanics above, unchanged** — captured verbatim, mined under
cite-or-mark. **Late arrival is zero new machinery:** an artifact arriving
mid-band that matches a standing exclusion is **not captured**, and its arrival
writes the encounter line. No new event kind, no new state, no new stop.

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
confirmed — the Run-1 case, on the line that then carried the envelope: the
documents said `none stated`, the Slack channel's first message said ≤ $50K.
That line has since left the frame (D-O105), and **the mechanism stands for
every line that remains.** Where it fires, render a **correction proposal** —
the field · the confirmed value · the captured value with its citation · the
frame re-confirmed or held.

This is **P-O0b — scope-frame selection, re-taken**: the frame's own switch act,
legal at any time and logged as the `scope-frame` event. It is **not a new
prompt point** — the P-O table is complete as it stands. It is a justified stop
under the checkpoint law: a materially different outcome hangs on it, and it
rides the ≤ 8 budget's one interaction of slack (7 + 1). **Captures consistent
with the frame produce no stop** — report and proceed.

The correction proposal closes per §10.3 rule 9: one plain lettered question
per contradicted field — take the captured value, its citation glossed, or
hold the value you confirmed — exactly one option `(recommended)`: the
disposition the citation grounds best, the later negotiated client statement
where the two are that pair (the D-O66 precedence principle, by reference).

**P-O0b (scope-frame selection) is a safety-floor act.** No autonomy grant
reaches it, in any
profile: the boundary is what every later act is measured against, and a grant
that could set it would be a run choosing its own scope.
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

**The machinery reads the boundary. The label is
communication, read by nothing.** Its landed home is the canvas —
T-01 — Discovery canvas framing carries it into §13 Context/Constraints as a
cited line.

**The first phase is lean by law, and the switch is the boundary (D-O104 ·
D-O106 — stated at elicitation principle 4 and T-18 — Scope allocation's step 3;
reached here by citation).** The first phase composes on **necessity alone** —
the least set of epics with which the key business need is met by a complete
flow — so the boundary **selects among phases the lean law already composed**:
`MVP` is the lean proposal, `MVP + Phase 2` is more, and nothing else changes
between the two — no second switch exists and none is to be built. **Lean is
the default and needs no act (D-O106):** absent any BA act — no directive, no
standing SD, no boundary switch, nothing typed — the first phase is the lean
set, `Boundary:` stands at its default `MVP`, and the proposal bills exactly
that; widening is always an **explicit, logged act** — a boundary switch at
P-O0b, a `BA-directed` move at T-18 — Scope allocation's step 4, a standing
SD — never a default
and never a silence.

**The cross-cutting register — `Cross-cutting:` (D-O72).** One **`XO-<n>`**
entry per cross-cutting obligation — a constraint the client's material states
once and the whole product must honor — with its **class**, its **one-line
value**, its **verbatim citation** and its **state**.

**The class set is closed at five: language · device · accessibility ·
branding · compliance.** A sixth class enters only by decision number on the
record.

**The state vocabulary is closed at four, and nothing else:**

- **`captured`** — registered, carrier pending;
- **`carried — <unit>`** — the story, epic or title-block line that holds it;
- **`accepted — <reason>`**, with an event-shaped revisit trigger — a declined
  obligation is a record, never silence;
- **`default`** — reserved for the language line's engagement default, which
  always stands: **this line is never `none`.**

The head holds the machine-readable summary; the verbatim ground lives in the
cited source artifact, and the canvas mirror is
**T-01 — Discovery canvas framing**'s — §13 Context/Constraints, beside the
scope decisions. Switches and mid-band arrivals ride the existing
**`scope-frame`** event grammar — **no new event kind exists**. **This register
is runtime and standing; the source audit's `OB-<nnn>` register is per-run and
derived** — deliberately disjoint ID spaces, and a runtime `XO` row is exactly
the ground the audit's forward trace expects to find carried.

**The language obligation's unit form (D-O74).** **English is the engagement's
ultra-default language, and the default is recorded, never silent:** the
`Cross-cutting:` line always carries
`XO-1 — language: English (engagement default — framework law, D-O74) — default`
where no source states otherwise — the framework recording **its own law as its
own ground**, never a fabricated client citation.

The moment the corpus states **(a) any UI/content/support language other than
English, or (b) multi-language support of any kind**, that obligation **must
materialize as an explicit unit of the specification: one dedicated
localization epic** — named in the client's own wording where one stands —
**holding at least one story carrying the verbatim citation**; a single-language
obligation legally holds exactly one story. **Never only a register line, a
mark, an open question or a Comments-cell mention** — *a comment is not a
carrier.*

The dedicated epic takes its **own Phase and its own Billable cell**, so the
obligation is independently allocable and stands as a visible WBS row; the `XO`
entry then stands **`carried — <the epic>`**, and a BA who declines the unit
records **`accepted — <reason>`** with its revisit trigger — never silence.
**The unit-form law is language-only by ruling:** the other four classes carry
via the register, the WBS title block and the source audit's forward trace.
**Discovery is untouched by construction:** the obligation is cited estate
ground the **T-17 — Epics decomposition** sweep reads — the law binds what
carries an obligation, never what the sweep finds.

**The acceptance-shape register — `Acceptance shapes:` (D-O78).** One
**`AS-<n>`** entry per acceptance **item** — one line of an engagement-level
acceptance shape: a pass list, success criteria, a definition of done, an
acceptance table governing the delivery as a whole — with its **one-line item**,
its **verbatim citation** and its **state**, or **`none found`**.

**Item grain:** a three-item pass list is **three entries**, each independently
checkable. **The class is narrow by ruling:** it names what the client will
accept the delivery against; **per-feature acceptance criteria are spec ground
and are never harvested here.**

**The state vocabulary is closed at three, and nothing else:**

- **`standing`** — the client's acceptance item, live and uncontested;
- **`superseded — SD-<n>`** — a later negotiated scope decision is the
  controlling client statement (D-O66; elicitation principle 4's D13), and the
  supersession is **recorded, never silent**;
- **`accepted — <reason>`**, with an event-shaped revisit trigger — a declined
  item is a record, never silence.

The head holds the machine-readable summary; the verbatim ground lives in the
cited source artifact. Switches and mid-band arrivals ride the existing
**`scope-frame`** event grammar — **no new event kind exists**. **This register
is runtime and standing; the source audit's `OB-<nnn>` register is per-run and
derived** — deliberately disjoint ID spaces, the cross-cutting register's
pattern exactly.

**The acceptance cross-check (D-O79) — stated once, here; every deferring act
reaches it by reference.** **No act that postpones or excludes scope completes
silently against a `standing` acceptance-shape entry.**

**The deferring acts, named:**

- an epic **allocated or held outside the delivery boundary** — a
  **T-18 — Scope allocation** phase move or held row, the lean cut's left-out
  rows first among them (D-O104);
- a **slide-down candidate** — a class the capacity check once named; empty
  since D-O105;
- an **SD-directed trim** — D-O66's application;
- a **standing `out-of-scope.md` fence row**.

Where such an act's subject matches a `standing` `AS-<n>` entry, the conflict is
a **named, cited finding — never a block at the act, and never silence**: it
takes an **`ADV-<n>`** id (the `Scope advisories:` register) and renders in
**T-18 — Scope allocation**'s existing step-4 decision list, ruled with the
existing three dispositions. The run mechanics are that sheet's and are never
legislated here. **A fence row is reached by this principle, never by editing
its sheet:** a fence written outside any **T-18 — Scope allocation** run
surfaces at the next run's list and stands to the gate meanwhile.

**The supersession law.** Where a negotiated SD trims an item an acceptance
shape requires, the SD is the later, negotiated client statement — the AS entry
records **`superseded — SD-<n>`**, the conflict is surfaced once and ruled, and
**no finding fires again for that item.**

**The standing backstop is the gate's.** **CC-H-07** holds every unruled
standing conflict as a **live H gap**, blocking under the gate's own law with
`HA-<nn>` the conscious-acceptance valve; **a conflict any ADV disposition has
ruled is not a gap — the record is the ruling itself.** **No new prompt point,
no new stop, no new event kind, no threshold:** the list, the dispositions, the
register grammar and the gate's blocking law are each consumed as they stand.

Write the pick and the frame into the ledger head:

```
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason
Sources: <kind — state, per named source>  (captured <date> | named — pending | skipped — <reason> | excluded — <reason> | none)
Boundary: <ladder value(s) — MVP | MVP + Phase 2 | …> — set <date> (P-O0b); switches append to Events with a reason
Client label: <free text — PoC · prototype · pilot…>  (<citation | BA-supplied | open — no source material>)
Scope decisions: SD-<n> — <the decision, one line> (<citation>) · … | none found
Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default · XO-<n> — <class>: <value, one line> (<citation>) — <state> · …
Acceptance shapes: AS-<n> — <acceptance item, one line> (<citation>) — <state> · … | none found
```

**Switching later is legal, and it is a ledger event with a reason** — never a
silent head rewrite:

```
<date> · profile · <from → to> · <BA initials> — <reason>
<date> · scope-frame · <from → to> · <BA initials> — <reason>
```

**Every named source records an event too** — the switch grammar at source
grain, appended for the life of the project, and the encounter of a reference to
an excluded artifact on the same grammar (D-O70):

```
<date> · source · <name> · <state> · <BA initials> — <basis>
<date> · source · <artifact> · encounter — not followed · <BA initials> — excluded <date>
```

**A constraint that arrives after Frame is a routed scope-frame-change
proposal** — a new client document, a client message — never a silent edit. It
fires T-18 — Scope allocation's scope-frame trigger.

**A late scope decision brings zero new machinery either (D-O65).** An `SD-<n>`
surfacing after Frame is a frame line arriving late: it rides that same routed
scope-frame-change proposal with its **T-18 — Scope allocation** trigger, logs
as the existing
`scope-frame` event — **no new event kind exists** — and a capture contradicting
a just-confirmed SD rides the correction stop above. All by reference; nothing
is re-legislated here.

**A cross-cutting obligation recognized mid-band brings zero new machinery
either (D-O73).** A cross-cutting fact recognized under cite-or-mark in **any
later capture or mining pass** appends its `XO-<n>` entry to the head's
`Cross-cutting:` line and one **`scope-frame`** Events line — **no new event
kind** — and a capture contradicting a confirmed entry rides the correction stop
above, already budgeted. Where the recognized obligation is a stated
non-English or multi-language one, the unit-form law above governs what carries
it: the register line is the record, never the carrier.

**An acceptance shape recognized mid-band brings zero new machinery either
(D-O78).** An acceptance shape recognized under cite-or-mark in **any later
capture or mining pass** appends its `AS-<n>` entry to the head's
`Acceptance shapes:` line and one **`scope-frame`** Events line — **no new event
kind** — a capture contradicting a confirmed entry rides the correction stop
above, already budgeted, and a **newly standing entry re-asserts any `accepted`
advisory finding through its existing revisit trigger**: nothing new fires.

**A late source brings zero new machinery.** A channel, thread or folder that
appears mid-band routes its content through the existing ingestion, and a
scope-shaped finding — a boundary, a decision, an obligation, an acceptance
shape — fires that same proposal and the same
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
  scope frame set (P-O0b): boundary <…> · label <…>
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
safety-floor act · **never guesses a cross-cutting obligation, and never lets a
harvested one stand without its verbatim citation** — an ambiguous candidate is
asked inside the block, never resolved by the framework · **never renders the
`Cross-cutting:` line as `none`** — the English default always stands ·
**never guesses an acceptance shape, never lets a harvested item stand without
its verbatim citation, and never harvests a per-feature acceptance criterion**
— that is spec ground · **never lets a deferring act complete silently against
a `standing` `AS-<n>` entry, and never blocks one either** — the conflict is a
named, cited finding in **T-18 — Scope allocation**'s decision list ·
**never renders a coverage claim the scan did not establish, and never
volunteers a line the pinned shape does not define — a scan result outside the
pinned lines is a render defect** · **never rules a source disposition on the BA's behalf, and
never reads silence as one** · **never captures an artifact standing
`excluded — <reason>`, never mines one, and never follows a reference to one
inside any capture — and never lets an encounter go unrecorded** · never
interprets a capture into the artifact it writes, and never lands one under
`.specify/memory/` — a capture is verbatim, and `sources/` is its home · never writes an estimate figure of any provenance into the canvas,
the roadmap, a WBS or any other artifact, and never reads one as allocation
ground: an estimate is delivery ground (D-O105), and no head line carries one.

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
