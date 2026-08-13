# Phase-2 exit test — the script

**Build plan §5, made runnable.** Ten steps, one project, one sitting. Pass =
all ten green in a single scripted run. This clears the Phase-2 slice of the
v1-done checklist: one-command install · gated discovery with BA-planned
techniques · decomposition + Tier-1 briefs + logged allocation · both question
guards live · a classed artifact set · named-gap blocking · zero-rework
`/speckit-plan`. *"One real feature shipped end-to-end"* stays Phase 3's, by
design.

The toy feature is the corpus's own `004-appointment-booking` inside epic
`E-03`. Every stakeholder contribution is a fixture file, so the run is
reproducible without improvisation.

---

## Two ways to run this

**Mechanically —** the whole script, unattended:

```sh
tests/check-exit.sh              # temp project, removed on exit
tests/check-exit.sh --keep -v    # keep the project, print every check
tests/check-exit.sh --offline    # install from vendor/spec-kit-v0.12.5.zip
```

**As an agent, in Claude Code —** open a session in a fresh directory and work
the ten steps below by invoking the real skills. This is the version that
exercises the framework as a BA meets it: `/ba-frame`, `/ba-aspect`,
`/ba-t<NN>` · `/ba-tier1` · `/ba-tier2` (one step each; `/ba-run` aliases them),
`/ba-clear`, `/ba-close-band1`, `/ba-enter-feature`, `/ba-gate`, `/ba-handoff`.

**What the difference is, exactly.** Some acts in this framework are agent acts
— composing an aspect plan, running a technique, drafting a spec, evaluating the
34 A assertions, planning an implementation. A shell script cannot re-derive
them, and pretending otherwise would make this suite a fiction. So
`check-exit.sh` runs every **mechanical** act live — the installer, the ten M
checkers, snapshot / re-run-set / anchor-diff, verdict assembly, certification,
the adapter, Spec Kit's own `setup-plan.sh` — and **stages recorded outputs**
for the agent acts, each one validated live, in that install, by the validator
that owns its shape. Recorded never means unchecked. The agent-run version below
closes the remaining loop by producing those outputs for real.

---

## Step 1 — Fresh project

```sh
mkdir toy && cd toy && git init
```

Empty repo, no prior Spec Kit.

**Green when:** `.git/` exists and `.specify/` does not.

---

## Step 2 — Install

```sh
/path/to/ba-native-spec/install.sh
tests/check-layout.sh --target .        # no --session: the FULL bar
```

**Green when:** `check-layout.sh` reports **GREEN — the full §1.1 tree is in
place**, with zero pending. That means: the §1.1 tree exact · Spec Kit's own
`/speckit-*` skills registered · all 32 `/ba-*` skills installed, each with
`disable-model-invocation: true` · the `ba-gate` agent read-only by tool policy ·
the ten-heading `spec-template.md` override in place, in order · every
runtime-born (◇) path **absent** — the installer laid down zero content stubs ·
`.specify/ba/manifest.md` recording the package version, the 15-document vector
and the Spec Kit pin **v0.12.5**, with every installed-file hash matching.

The full bar is the Phase-2 exit bar. Until S9 it could not pass, because three
of its entries were S9's units.

---

## Step 3 — Frame

```
/ba-frame
```
with `tests/fixtures/appointment-booking/presale-brief.md` as the input material.

T-01 births `canvas.md`; the two aspect ledgers initialize. In the agent run
`/ba-frame` renders the profile picker and the scope-frame block together, as
one stop, and takes both answers in one reply (P-O0 · P-O0b). The mechanical run
stages the corpus's own Band-1 ledger, which records a July-2026 engagement with
no frame on file — the same reason it carries no `Auto:` line.

**Green when:** `canvas.md` carries the thirteen sections in order, `P-n`/`O-n`
line-IDs on exactly the two sections that own them, every cell cited or marked ·
`.specify/aspect-state.md` and `.specify/aspect-plans.md` exist **at
`.specify/` top level**, six aspects × `untouched` · nothing landed under
`.specify/memory/` — a runtime ledger is not content, and inside `memory/` it
would join CC-H-01's glob and fire the scoped-H write trigger on itself.

---

## Step 4 — Band 1

Per aspect, in DAG order: `/ba-aspect <aspect>` → suggestion snapshot → the BA
composes the plan → `/ba-t<NN>` for each → `/ba-clear <aspect>` with
its evidence table. All six reach `first-pass-cleared`.

The script includes one deliberate `/ba-waive-aspect` + lapse round trip, to
exercise the AW mechanics rather than assume them.

```
/ba-close-band1
```

**Green when:** the eleven Band-1 artifacts stand in `.specify/memory/` (plus
`canvas.md` at the root), each in the shape its sheet pins — validated live by
`tests/check-band1-artifacts.py` · the ledger head reads
`Band: 1 (closed <date>) — Bands 2/3 capable` · the closure act **requested the
arming run**, and `/ba-gate-health full` left its entry in
`.specify/gate-health.md` · `sk_health.py` passes CC-H-02 / CC-H-03 / CC-H-06
against the estate.

---

## Step 5 — Band 2

```
/ba-t17                          # epics decomposition → roadmap rows
/ba-run t18                      # MVP allocation — via the alias, on purpose
/ba-tier1 kit E-03               # the call kit
   … the BA runs the call …
/ba-tier1 ingest E-03            # with fixtures/…/call-notes-E-03.md
```

**Green when:** `roadmap.md` carries the epic rows at the locked shape, E-03
among them, and an allocation log entry with a `from → to` diff and a reason ·
the kit emits **≤ 12 must-ask** questions, every one destination-tagged, with
**zero Destination-Test violations** against the §3.3 depth table · the
ingestion leaves the brief **`Scoped`**, its routing batch approved, and
`004-appointment-booking` proposed in §8 slicing.

---

## Step 6 — Band 3, the spec

```
/ba-enter-feature E-03/004-appointment-booking      # slicing row → Confirmed
/ba-tier2 004                                       # the Tier-2 session
```

Context stack loaded in §5.2 order · draft-first skeleton · **≤ 7** guided
questions, answered from `fixtures/…/tier2-answer-sheet.md` · `spec.md` written.

Then **seed one defect**: re-insert `quickly` into FR-007 — the gate §14
exemplar. (Fixture `revisions/spec-r5.md` is the Tier-2 draft carrying it.)

**Green when:** `specs/004-appointment-booking/` exists holding **only**
`spec.md` — `traceability.md` and `gate-report.md` are each born by their own
act and absent until then · the spec's answers match the sheet, every drafted
value cited-or-marked, the cap respected · FR-007 carries the seeded adverb.

---

## Step 7 — Gate: FAIL → fix → PASS

```
/ba-gate 004
```

**Green when the run FAILs**, naming **CC-G-04 — FR-007** in named-gap grammar:

```
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target,
or move the concern to an NFR with metric + condition.
```

This is the *"gate blocks with named gaps"* v1-done item, proven rather than
claimed. Every failure line names its element **and** its fix action; a line
without both is invalid gate output. No certification block is written, and
`/ba-handoff 004` at this moment **refuses for lack of a certification** — a
feature that never passed has nothing to hand off.

Then fix per the fixture — the adverb out, the timing concern into **NFR-003**
with metric and condition — and re-gate:

```
/ba-gate 004
```

**Green when:** the re-gate is **incremental** — 12 assertions carried on
untouched read sets, the rest re-run (gate §9.2) · **W-004-01** on CC-IN-03
survives its anchor diff and is re-affirmed at P5 · **O-004-01** auto re-applies,
evidence unchanged · both ⚑ evidence bundles are signed at P3 · the BA approves
at P4 → **PASS WITH WAIVERS**, effective · `traceability.md` is committed and
the **certification manifest** is written, covering what the run produced as
well as what it read.

---

## Step 8 — Negative check

```sh
printf ' ' >> specs/004-appointment-booking/spec.md     # one byte
```
```
/ba-handoff 004
```

**Green when the adapter REFUSES**, printing the diverged path:

```
REFUSED — 1 certified path(s) diverged from the live files
  specs/004-appointment-booking/spec.md — content changed
→ re-gate before handoff; the certified text is the read text.
  Nothing was done: no branch was created or checked out.
```

and when **nothing else happened**: no branch created or switched, no feature
pointer written. The guard precedes every side effect, so a refused handoff is
never half-done.

Revert the byte → the hashes verify clean. Then edit a certified **governance**
artifact instead (`.specify/memory/glossary.md`) and confirm the refusal reaches
past the feature folder: the manifest is the gate's static core, not just the
spec.

---

## Step 9 — Handoff

```
/ba-handoff 004
```

**Green when:** every certified hash matches · branch `004-appointment-booking`
is checked out — the name `/ba-enter-feature` assigned · Spec Kit's structure is
confirmed and its feature pointer written · the ready report names the
certification, the waiver in force, and **every carried
`[NEEDS CLARIFICATION]`** with its section. Running it a second time is
idempotent.

---

## Step 10 — `/speckit-plan` consumes it, zero manual rework

```
/speckit-plan
```

"Zero manual rework" is not a feeling. It is these four, each checked:

**(a) The operator performs no file operation between certification and plan.**
Spec Kit's own `setup-plan.sh --json` resolves `FEATURE_SPEC`, `IMPL_PLAN` and
`BRANCH` with no argument, no environment variable, and no `/speckit-specify`
run. At v0.12.5 that resolution goes through `.specify/feature.json`, which the
adapter writes — see the note below.

**(b) The plan runs to a completed `plan.md` without requesting any spec edit.**
Summary, Technical Context, Constitution Check (from
`.specify/memory/constitution.md`), Project Structure — plus Phase 0
`research.md` and Phase 1 `data-model.md`, `contracts/`, `quickstart.md`. No
template placeholder survives. Nothing is sent back to the BA.

**(c) The only `[NEEDS CLARIFICATION]` the coding agent reads is the one carried
under the waiver.** Checked over the **certified artifact set** — every file the
certification manifest lists, not just the spec: exactly one marker, the
calendar-sync question under **W-004-01**, and the gate report names the waiver
it sits under. Nothing hidden, nothing else open.

**(d) Every certified hash still matches at plan time.** The plan writes only
new files; it never touches certified ones.

> **A note on (b) and the plan's own unknowns.** `plan.md`'s Technical Context
> legitimately carries `NEEDS CLARIFICATION` for language, dependencies and test
> runner. Those are technology decisions no upstream artifact fixes and none
> should — the writing standard keeps feature specs technology-free by design —
> and Phase 0 resolves them as operator decisions. They are the *plan's*
> unknowns, not the spec's, which is why (c) is asserted over the certified
> artifact set. A spec that pre-decided the stack would be a worse spec, not a
> more complete one.

---

## Pass

All ten green in one run. `tests/check-exit.sh` prints:

```
✓ GREEN — all ten steps of the Phase-2 exit script pass in one run.
```

---

## Two things this script is deliberate about

**The FAIL cycle is not optional** (D-P2-12). A script that only ever exercised
the happy path would leave *"the gate blocks with named gaps"* and *"the
certified text is the read text"* as claims. Step 7's seeded defect and step 8's
one-byte edit are what turn them into observations.

**Spec Kit's feature pointer is the adapter's job** (S9 divergence D42). At
v0.12.5, `setup-plan.sh` no longer derives the feature from the branch name: it
resolves `FEATURE_DIR` from `SPECIFY_FEATURE_DIRECTORY`, else from
`.specify/feature.json`, else it errors. That file is normally written by
`/speckit-specify` — the command Mode A deliberately never runs, because our
spec is already at the destination. Without the adapter writing it,
`/speckit-plan` stops on *ERROR: Feature directory not found* and the operator
has to intervene, which is exactly the manual rework this step measures. Gate
§11.2 already assigns the adapter *"any copies Spec Kit's layout requires"*;
this is that clause at the pin. Pull the write out of `sk_handoff.py` and six
assertions in step 9–10 go red, which is how it should be.
