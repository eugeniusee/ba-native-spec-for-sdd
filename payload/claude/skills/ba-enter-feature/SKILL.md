---
name: ba-enter-feature
description: P-O8 - Band-3 entry, for one feature. Renders the parent brief's slicing row for confirmation, assigns the next free NNN under Spec Kit's convention, creates the specs/NNN-<feature>/ directory, records the band event, and prompts the roadmap status flip to In delivery. The slicing-row write is elicitation mechanics; entry rides that confirmation act.
disable-model-invocation: true
---

# `/ba-enter-feature <epic>/<feature>` — Band-3 entry

**Argument:** `E-03/appointment-booking`, or the feature name alone when only one
brief proposes it.

Band-3 entry for a feature **is** the slicing-row confirmation act. The status
flip is the elicitation layer's mechanics; this skill renders the row, assigns
the number, creates the destination, and records the band event — nothing else.

**Entering several features at once:** `/ba-run specs all` (or
`specs <epic-list>`) is the batch path — one P-O8 — Band-3 entry table over
every selected feature, then Tier 2 per feature (orchestrator §8.4). This
skill's per-feature act is unchanged; the batch driver performs it once per
confirmed row.

## Invocation contract — check before you run

- **BA act.** The confirmation is the BA's; you render and record.
- **Band 2 must be closed into.** Band-3 entry presupposes Band-1 closure — the
  head reads `Band: 1 (closed <date>) — Bands 2/3 capable` — and a scope brief
  that proposes the slice. If the head still reads `1 (open)`, stop and name
  `/ba-close-band1`.
- **Presale profile — entry proceeds (D-O18).** If the ledger head reads
  `Profile: Presale`, run this act normally: Band-3 drafting is **in** profile.
  Presale's destination extends to **draft specs**, and a **draft spec** is not a
  new class or format — it is an ordinary `spec.md` that stops before its
  effective PASS, carrying its unknowns as `[NEEDS CLARIFICATION]` markers. What
  stays outside the profile is unchanged, and is not this skill's to relax:
  certification and handoff sit behind existing gate law — no effective PASS, no
  certification, no handoff — and are expected after a recorded switch to
  Discovery. Never switch the profile here.
- **Preconditions are NOT re-checked here.** Brief exists · brief is `Scoped` ·
  the slicing table is present — those belong to CC-H-03 and CC-XA-05 at gate
  time, and the Scope-F pre-flight is the hard guarantee. Rendering the row is
  enough; re-implementing the gate's checks here would put a second, drifting
  copy of them in the orchestrator.

## Step 1 — render the slicing row

Read the parent brief at `.specify/memory/scope/<epic>.md`, §8 (the slicing
table), and render the row for this feature exactly as it stands — its slice
statement, its dependencies, its current `Status`.

Take the BA's confirmation. On confirmation the row's `Status` becomes:

```
Confirmed — <date>
```

That write is **elicitation mechanics performing a framework write**, not an
orchestrator write: it happens under the routing discipline, and because the
system is armed, the scoped Scope-H run fires silently on it, with sibling
pass-voiding handled at the gate where it applies. Reference it; do not run it.

`Confirmed — <date>` is the machine-readable home CC-XA-05 reads at gate time.
Its absence is why an unconfirmed slice fails admission later — which is the
point of the act, and the reason it is a checkpoint rather than a formality.

## Step 2 — assign NNN and create the destination

Take the **next free `NNN`** under Spec Kit's convention: scan `specs/` for
existing `NNN-*` directories and use the lowest unused three-digit number,
zero-padded, in creation order. Create:

```
specs/NNN-<feature>/
```

**The directory only — zero content stubs.** No `spec.md`, no
`gate-report.md`, no `traceability.md`: each is born by its own act, and an empty
file created here would be indistinguishable from a real hole to every assertion
that looks for one. Tier 2 authors `spec.md`; the gate appends the report and
generates the traceability file.

The destination path exists **before** Tier 2 writes into it, so the gate's
Stage-0 admission and the adapter's later branch checkout both resolve to the
same `NNN-<feature>` name.

## Step 3 — the band event, and only the band event

Append to `## Events` in `.specify/aspect-state.md`:

```
<date> · 004-appointment-booking entered Band 3 · <BA initials> — E-03 brief §8 slicing row
```

**That is the whole record.** Do not copy the slice statement, the brief's
status, or the roadmap row into the ledger: the **roadmap tracks epics**, the
**briefs track their own status and slicing**, and the ledger records **band
events only**. A second copy of content state rots in parallel — the tracking
split is deliberate.

## Step 4 — the two prompts this act raises

**Roadmap status.** When this is the epic's **first** feature to enter Band 3,
prompt the roadmap flip: `Defined → In delivery`. The vocabulary is locked to
four values — `Defined` · `In delivery` · `Delivered` · `Retired — <reason>` —
and deliberately has no `Scoped` value, because the brief already tracks
`Draft`/`Scoped` and the join is read directly. The flip is a **routed content
edit** under BA approval, never an inline fix here.

**Standing AW re-affirmation.** A band-transition act renders every standing
aspect waiver, one line each, with its revisit trigger displayed — re-affirm or
lapse (`/ba-waive-aspect`). This is the lazy read; no scheduler exists.

## Step 5 — advisories, never blocks

Render an advisory — **visibility, never a block** — when either applies:

- The parent epic's ground touches an aspect flagged `reopened` or
  `upstream reopened`. Name the aspect and the open RO; the BA proceeds or pauses.
- A **deferred consequence** in the head names this feature as its trigger event.
  This is the lazy read firing: print the deferred item and name the act that
  executes it (typically a governance batch via routing). Example shape — *"RO-1
  deferred a Clinic Admin role in `roles-permissions.md`, trigger: F2 Band-3
  entry — that trigger is this act."*

Neither advisory stops the entry. Record the BA's response in the band event
where they chose to pause something.

## Close

Name the next act: the Tier-2 session (`/ba-tier2 <NNN>`), which loads the
context stack, drafts first, and runs the guided-question loop under the cap.

**Under Discovery** it submits to `/ba-gate <NNN>`.

**Under Presale** it runs in **assumption posture**: draft-and-mark is unchanged,
**assumptions fill unknowns *inside* the essential scope and never widen it**,
and the gap questions that cannot reach the client are offered as **one
BA-confirmed deferral batch** — the framework proposes the client-unreachable
subset, the BA confirms, edits, or dissolves it in a single act, never
per-question drip and never the framework's own call. A deferred question records
no answer; its `[NEEDS CLARIFICATION]` marker stands as the record. The queue
re-evaluates once after the batch. The gate stays BA-invocable at any time, and
on a draft spec its FAIL report is an informative named-gap list — the client Q&A
agenda. Do **not** name certification or handoff as the next step: both need an
effective PASS, which is Discovery's destination, after a recorded switch.

## Under a standing grant — the band-boundary report

The P-O8 — Band-3 entry stamp is **AUTO** under a grant (`/ba-auto`), and entry
is ratified in one batch at `off` — unchanged. **Band-3 entry is a band boundary**, so it is one
of the four events that end the run's turn. After the stamp, render the pinned
band-boundary report — naming the feature — and **stop there**; the grant
stands, and the BA's next message resumes the run:

```
Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>
Auto-trail since <start | last boundary>: <n> acts
Assumptions: <n> · Open questions: <n>
Next act: <one line> — any reply continues · /ba-auto off renders the resumption report
```

The steps above record to the ledger, not the conversation: under a grant
nothing between acts is narrated. The standing-AW re-affirmation of step 4 is a
BA act and is **not** waived by the grant — it rides the next BA turn, named on
the report's `Next act:` line.

## What this skill never does

Never writes the brief's slicing row itself (elicitation mechanics own the write)
· never creates `spec.md` or any other content file · never re-checks CC-H-03 /
CC-XA-05 preconditions — the gate owns them · never mirrors brief or roadmap
state into the ledger · never edits the roadmap directly (the flip routes as
content under BA approval) · never blocks an entry on an advisory · never blocks
entry on the Presale profile — drafting is in profile · never switches the
profile itself · never offers certification or handoff as the next step under
Presale · never enters Band 3 before Band-1 closure · never assigns an `NNN` that
is already taken.

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
