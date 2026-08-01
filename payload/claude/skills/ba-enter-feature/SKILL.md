---
name: ba-enter-feature
description: Band-3 entry for one feature (P-O8). Renders the parent brief's slicing row for confirmation, assigns the next free NNN under Spec Kit's convention, creates the specs/NNN-<feature>/ directory, records the band event, and prompts the roadmap status flip to In delivery. The slicing-row write is elicitation mechanics; entry rides that confirmation act.
disable-model-invocation: true
---

# `/ba-enter-feature <epic>/<feature>` — Band-3 entry

**Argument:** `E-03/appointment-booking`, or the feature name alone when only one
brief proposes it.

Band-3 entry for a feature **is** the slicing-row confirmation act. The status
flip is the elicitation layer's mechanics; this skill renders the row, assigns
the number, creates the destination, and records the band event — nothing else.

## Invocation contract — check before you run

- **BA act.** The confirmation is the BA's; you render and record.
- **Band 2 must be closed into.** Band-3 entry presupposes Band-1 closure — the
  head reads `Band: 1 (closed <date>) — Bands 2/3 capable` — and a scope brief
  that proposes the slice. If the head still reads `1 (open)`, stop and name
  `/ba-close-band1`.
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

Name the next act: the Tier-2 session (`/ba-run tier2 <NNN>`), which loads the
context stack, drafts first, runs the guided-question loop under the cap, and
submits to `/ba-gate <NNN>`.

## What this skill never does

Never writes the brief's slicing row itself (elicitation mechanics own the write)
· never creates `spec.md` or any other content file · never re-checks CC-H-03 /
CC-XA-05 preconditions — the gate owns them · never mirrors brief or roadmap
state into the ledger · never edits the roadmap directly (the flip routes as
content under BA approval) · never blocks an entry on an advisory · never enters
Band 3 before Band-1 closure · never assigns an `NNN` that is already taken.
