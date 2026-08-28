---
name: ba-gate
description: Run the completeness gate over a feature spec (Scope F, stages 0-5) - admission and pre-flight, structural gate, machine pass, agent pass, verdict review with waivers and overrides, certification. BA-invoked on a submitted spec; produces a PASS that unlocks /speckit-plan, or a FAIL with named gaps.
disable-model-invocation: true
---

# `/ba-gate <feature>` — the Scope-F run

**Argument:** `<feature>` — `004`, `004-appointment-booking`, or the full path.
Resolve it to `specs/NNN-<feature>/` before anything else; if it does not exist,
stop and say so — the gate never creates a feature folder.

## Invocation contract — check before you run

- **BA-invoked, never auto-fired.** This is the last step of Tier 2: the BA has
  reviewed the draft, run the standard's §15 self-check, and submitted. If you
  reached this skill because a file was saved or because a spec "looked ready",
  stop.
- **Two runtime rules govern everything below.** *The gate never authors* — it
  reads, verifies and certifies; it never edits a spec, never edits a
  governance or context artifact, never rewords a requirement to help it pass,
  never waives silently. And *the gate meets its own bar* — a failure line
  without element + fix action, an A verdict without evidence, a skipped check
  without a named blocker: each is invalid output, corrected before the report
  is delivered.
- **No mid-run drip.** Stages 1–3 run to completion without interrupting the
  BA. Results arrive once, at verdict review — earlier only on a Stage-0 block
  or a Stage-1 halt.

## The run workspace

Everything a run produces lives at

```
.specify/ba/runs/<NNN-feature>/run-<n>/
  manifest.json        the snapshot (gate §3)
  workspace/           the copied snapshot — every checker reads THIS
  checkers/*.json      the M pass
  a-pass.json          the gate agent's Stage-3 output
  run.json             the run record the report writer consumes
  cert.json            the certification manifest (effective PASS only)
```

Runtime-generated, never shipped, and outside `.specify/memory/` — a run
workspace is not content. `<n>` is the next run number for this feature: read
`specs/NNN-<feature>/gate-report.md`, take the highest `## Gate run <n>` and add
one. Run numbers are monotonic and **include blocked admissions**, so the
ledger is gapless.

---

## Stage 0 — admission & pre-flight

1. `spec.md` present at `specs/NNN-<feature>/spec.md`? If not, refuse with the
   instruction to author it — nothing else happens.
2. Determine the parent epic (the spec's References section names the brief) and
   the prior revision, if any.
3. Build the snapshot:

```bash
python3 .specify/ba/scripts/sk_snapshot.py build \
  --root . --feature <NNN-feature> --epic <E-nn> --run <n> --date <YYYY-MM-DD> \
  --out .specify/ba/runs/<NNN-feature>/run-<n>/manifest.json \
  --workspace .specify/ba/runs/<NNN-feature>/run-<n>/workspace \
  --require-complete
```

   A missing static-core member is a runtime condition, not a spec verdict —
   report it and stop.

4. **Pre-flight** — the seven CC-H assertions restricted to `deps(F)`. This is
   the hard guarantee, run fresh every time; the ledger head in
   `.specify/gate-health.md` is convenience, never the guarantee. Run
   `sk_health.py` for the M third and dispatch the A third (CC-H-01 · CC-H-04 ·
   CC-H-05 · CC-H-07) to the `ba-gate` agent with `assertions-h.md`, both
   against the snapshot workspace. **CC-H-07 reads the ledger head's
   `Acceptance shapes:` line as ground — read-only, never a trigger, and the
   ledger is never audited.**
5. Any H gap **not covered by a health acceptance** blocks the run — **P1**.
   Put the gaps into `run.json`'s `preflight` block, each with its `ha` field
   set to the covering `HA-<nn>` or `null`, and run the report writer: it emits
   the "blocked at pre-flight" entry, which you append to `gate-report.md`.
   Then present **P1** to the BA: fix the artifact by the routing discipline
   (the gate never writes upstream), or grant an `HA-<nn>` at
   `.specify/gate-health.md`. Nothing else is evaluated. *A feature gate
   against rotten shared artifacts is meaningless.*

## Stage 1 — structural gate

```bash
python3 .specify/ba/scripts/sk_structure.py --format json \
  --root <run>/workspace --feature <NNN-feature> > <run>/checkers/structure.json
```

CC-G-01 FAIL, or a document that will not parse → **halt**. Report the
structural gaps only; they are non-waivable anyway. An isolated malformed ID in
an otherwise parseable document is *not* a halt — it fails its category's M
assertions in Stage 2.

## Stage 2 — machine pass (never halts, collect-all)

The remaining 20 M assertions, in the gate's execution order — `sk_scan` →
`sk_stories` → `sk_acceptance` → `sk_ears` → `sk_sections` → `sk_brief` →
`sk_idgraph`. Each writes its JSON into `<run>/checkers/`; each reads
`--root <run>/workspace`.

`sk_idgraph` also builds the traceability graph and emits the **candidate**
`traceability.md` (`--out <run>/workspace/specs/<NNN-feature>/traceability.md`,
with `--run`, `--rev`, `--date` for the banner); CC-TR-04 is evaluated against
that candidate. The candidate is committed only at Stage 5, on an effective
PASS. On a FAIL it is discarded.

## Stage 3 — agent pass (never halts, collect-all)

Dispatch the `ba-gate` subagent. Give it: the snapshot workspace path, the path
to `.specify/ba/cards/assertions-f.md`, and **the explicit list of A assertions
to evaluate** — all 34 on a full run, the re-run set on an incremental one
(below) — the two ⚑ assertions among them, on every run and under any standing
grant: ⚑ is the signature, never the evaluation (gate §5.3). Tell it which
elements are already blocked by an M failure so it can skip at element
granularity. A blocker is always a `CC-<ID>` or §5.1's parse gap — never a
mode, a grant or a flag (§5.3).

Write its JSON to `<run>/a-pass.json`. Do not edit its verdicts. If it returns
an assertion you did not ask for, or omits one you did, that is a runtime
defect — re-dispatch, do not paper over it.

## Incremental re-gate — composing stages 2 and 3 (re-runs only)

For run `n > 1`, compose the re-run set before the passes:

```bash
python3 .specify/ba/scripts/sk_snapshot.py rerun-set \
  --prev <run n-1>/manifest.json --curr <run n>/manifest.json \
  --prev-spec <prior spec.md> --curr-spec <current spec.md> \
  --non-clean "<CC-IDs that failed/were waived/overridden/skipped last run>" \
  --format json
```

Re-run set = **all M** ∪ everything not clean last run ∪ every A whose read set
intersects the diff ∪ every whole-spec A on any spec edit ∪ every A assertion
whose compiled card differs from the prior run's — a changed card is never
carried: when the manifest's cards hash differs, the A set re-runs whole with
the basis `cards changed`. The rest are
**carried**, each with its basis; they go into `run.json`'s `carried` list —
and `rerun-set`'s `cards_changed` goes into `run.json`'s field of that name, so
the entry's `Carried from run n−1:` line reads `none — cards changed` rather
than a bare `none`. An
effective PASS from an incremental run certifies the full assertion set: fresh
verdicts plus carried verdicts whose read sets are provably untouched. A full
run is always available on BA demand and is the right hygiene after many
accumulated small edits.

**Resolve the standing records before invoking any checker:**

- Each **waiver** in force → `anchor-diff --kind waiver`. Clean → it survives to
  P5. Dirty → **voided**, the gap is live again, and a fresh request is
  possible.
- Each **override** → `anchor-diff --kind override`. Clean → it **auto
  re-applies** ("evidence unchanged"), and its checker is *not* run for that
  element. Dirty → the checker is **re-armed** for a fresh verdict. Without
  this the BA re-overrides the same known false positive every re-gate, and
  ritual is a defect signal.

## Stage 4 — verdict review

Assemble `run.json`:

```json
{
  "feature": "…", "run": 3, "date": "…", "spec_revision": "…",
  "scopes": "F (+H pre-flight)",
  "manifest": "manifest.json",
  "checkers": ["checkers/structure.json", "…"],
  "a_pass": "a-pass.json",
  "carried":   [{"assertion": "CC-OV-01", "basis": "read set untouched by the diff"}],
  "cards_changed": false,
  "waivers":   [], "overrides": [], "signoffs": {}, "approval": null,
  "preflight": {"status": "clean"}
}
```

Then render the provisional result:

```bash
python3 .specify/ba/scripts/sk_snapshot.py report <run>/run.json
```

The writer computes the verdict — it is not yours to compute. **FAIL (n)** with
n live failure lines, or any skip at all; **PASS WITH WAIVERS** with zero live
failures, zero skips and ≥ 1 waiver in force; **PASS** with none of those.

**FAIL as agenda — one appended line under Presale (gate §6.1).** A FAIL on a
presale draft has a second, informative job: its named-gap lines are the client
Q&A agenda. Render that job when **both** hold — the ledger head at
`.specify/aspect-state.md` reads `Profile: Presale`, and this feature has no
effective PASS on record (no `cert.json` under
`.specify/ba/runs/<NNN-feature>/`, the same fact the adapter reads). Then append
exactly one line under the presented FAIL:

```
These named-gap lines are also the client Q&A agenda.
```

Read the profile from the head. **Never ask the BA for it.** If the head is
missing, or its `Profile:` line does not read `Presale`, append nothing and say
nothing about profiles — silence is the correct render.

This is a render and nothing else. The verdict stays FAIL and stays final until
fixed, overridden or waived; the named-gap lines are unchanged; no waiver,
override or approval is implied; certification still needs an effective PASS.
The line goes to what the BA sees, never into the `gate-report.md` entry — that
entry's shape is pinned. On a pass-bound verdict, under `Profile: Discovery`, or
on a feature already certified, the render is exactly what it was.

**P2 — verdict review.** Present the provisional result and take the BA's
rulings, then re-render with them in `run.json`:

- **Override** — the A verdict is a false positive. `O-<NNN>-<nn>`, with the
  reason ("why the verdict was wrong") and the same anchor a waiver carries.
  The assertion passes by override this run; the record feeds
  `.specify/gate-tuning.md`. The BA may also **revoke** a standing override
  here; revocation sends the element to a fresh verdict.
- **Waiver** — the gap is real and consciously accepted. `W-<NNN>-<nn>`, all six
  contract fields, revisit trigger **event-shaped** ("when the provider contract
  signs", not a date wish). The writer refuses an incomplete record and refuses
  a non-waivable assertion outright, printing that ID's reason. **No
  pre-emptive waivers** — a waiver attaches only to a gap a run has produced.
  - **The CC-G-02 two-step, enforced.** A request to waive a *stub* is refused
    with the instruction: name the gap in the text as
    `[NEEDS CLARIFICATION: …]` (a spec edit → re-gate), then waive the
    resulting CC-G-03 gap. Every accepted gap is a named gap, by construction.
  - A waived marker stays in the spec as the gap's named location. Where one
    accepted gap surfaces as more than one assertion line — the underlying gap
    and the `[NEEDS CLARIFICATION]` marker that names it — put the extra line
    on the same record's `also` list rather than minting a second W-number.
  - **One advisory, said once and not repeated (D-O18).** Waiving marker
    failures to certify a spec that is still carrying its unknowns as markers is
    **certifying guesses**. Say it once, here, when marker gaps are among the
    waivers requested — most often on a spec drafted under the Presale profile,
    where deferred questions left their markers standing. The instrument is
    named: the **contract waiver** `W-<NNN>-<nn>`, granted at this step. Never
    the **aspect waiver** `AW-<n>` — that is `/ba-waive-aspect`'s act over a
    Band-1 aspect, and it certifies nothing. It is an advisory and never a
    refusal: the writer's refusals are the non-waivable list and the incomplete
    record, and this adds nothing to them. The BA's call stands.
- **P5 — re-affirmation** (re-gates only): one line per surviving waiver —
  re-affirm (initials) or lapse (lapse → the gap is live). Display the revisit
  trigger at this moment; this is the lazy read, and no scheduler exists.
  Waivers expire at the close of the feature's delivery cycle (the BA's
  post-implementation verification); an expired waiver whose gap persists is
  **re-requested in full**, never re-affirmed.

**Routing the gaps.** Every FAIL line already names its fix action, and each
falls in exactly one lane: **spec edit** (the Tier-2 fix cycle — each FAIL line
is verbatim a legality anchor for a Tier-2 question; anchor ≠ obligation,
draft-first applies to fixes too) · **upstream artifact change** (the routing
discipline: proposed edit → BA approves → write → the scoped health run fires
silently; the gate never writes upstream) · **scope / aspect decision** (emit a
reopen signal to `/ba-reopen`, or a Band-2 allocation act — the gate emits, the
orchestrator executes).

**P3 — ⚑ sign-offs.** Only when the provisional verdict is pass-bound. Present
the CC-XA-01 and CC-XA-06 evidence bundles **individually and in full**;
skimming is not an option on a ⚑ line. The BA signs, or declines — a decline
flips the assertion to FAIL with the BA's own named gap, and the verdict with
it. On a FAIL verdict both lines read `— (verdict FAIL)`.

**P4 — approval.** Holistic: the BA approves and the PASS becomes
**effective**. A clean report may be approved quickly, but the gate never
self-certifies. A FAIL needs no approval — it is final until fixed, overridden
or waived.

**Every gate stop closes per §10.3 rule 9** — after the pinned report lines,
the plain-English ask under `What I need from you:`, one AskUserQuestion call
per stop, framework codes glossed. P2 — verdict review: one lettered question per named gap —
`a. leave it standing — fix it in the spec (recommended) — every FAIL line
already names its fix action` · `b. waive — the gap is real and consciously
accepted; the six-field record follows` · `c. override — the verdict is wrong;
the reason follows`. P3 — the ⚑ sign-offs, one question per bundle —
`a. sign it (recommended) — the evidence bundle above supports it` ·
`b. decline — name your gap, the verdict flips`. P4 — approval:
`a. approve — the PASS becomes effective (recommended) — the report is clean`
· `b. hold — say what you want re-checked`. The marker never pre-selects:
the sign-offs and the approval stay the BA's own acts, outside every grant.

**The safety floor — never under an AG.** An autonomy grant (`/ba-auto on`)
reaches P2 and stops there: waivers on real gaps may be taken AUTO, stamped
`AUTO (AG-<n>)` in the report entry and standing for ratification at `off`;
**overrides are never AUTO**, and the non-waivable set is untouchable under any
mode — the auto path names the gap in the text or reclassifies, then re-gates,
and never bypasses. **P3 — the ⚑ sign-offs — and P4 — approval — sit outside
every grant**, in every profile. Under auto a feature ends at "done, awaiting
ratification"; these two acts wait for the BA. **The floor is the signature,
never the evaluation:** the two ⚑ assertions are computed at Stage 3 on every
run and under any grant (§5.3); what waits for the BA is the P3 signature on
the computed bundle, and nothing else.

## Stage 5 — certification (effective PASS only)

1. Commit the candidate `traceability.md` from the workspace to
   `specs/<NNN-feature>/`.
2. Finalize the entry — ⚑ lines and approval inked — and append it:

```bash
python3 .specify/ba/scripts/sk_snapshot.py report <run>/run.json \
  --certification-out <run>/cert.json \
  --append specs/<NNN-feature>/gate-report.md
```

   with `"produced": ["specs/<NNN-feature>/traceability.md"]` in `run.json`, so
   the certification covers what the run produced and not only what it read.

3. **The gate stops.** Nothing past this line is the gate's act. The adapter
   owns the plumbing and the hash guard — run by implementation itself at
   take-up (gate §11.2), no BA command; the operator owns the pipeline from
   `/speckit-plan`; the BA re-enters at Band-3 verification.

## After certification

A PASS is voided by any edit to `spec.md`, to any artifact in the certification
manifest, or to the parent brief — including a sibling feature's write-back to
the brief's §6 statuses. Voiding is a state change, not an event handler: it is
*detected* at the next touchpoint — a re-gate or the adapter's hash check —
never watched for. The cheap re-gate after a brief edit is all M + the
brief-reading A set (CC-OV-02 · CC-IN-01 · CC-XA-06 ⚑) + P5 re-affirmation of
any waiver whose Checks include the brief; everything else carries. Note the
floor: CC-XA-06 is both brief-reading and ⚑, so a brief edit is never
signature-free for a certified sibling.

**P6 — surfacing.** When a scoped health run FAILs, or announces that this
feature's certification is voided, route the fix and queue the cheap re-gate.
The notice is a courtesy; the adapter's hash check is the guarantee.

Pass-binding obligations end **at handoff**. Any post-handoff change opens a new
delivery cycle: fix in the spec → re-gate → re-handoff. Spec errors are never
hand-patched in code.

**P7 — escape filing.** A requirements defect this gate missed and something
downstream caught — a `/speckit-analyze` or `/speckit-checklist` finding,
plan- or tasks-time confusion, an implementation defect traced to spec
ambiguity, a BA-verification defect — is filed as an escape record in
`.specify/gate-tuning.md`, naming the CC-ID that ought to have caught it (or
"none — new class"). An assertion that existed but was misjudged is a **checker
defect**; an assertion that did not exist is a **contract-gap candidate**. The
fix never happens downstream: escape → spec fix → re-gate → re-handoff. The
backstop's job is to shrink to zero catches — every catch it makes is our
defect, not its success.

## What this skill never does

Never invokes any `/speckit-*` command · never edits a spec, a memory artifact,
or code · never rewords content to pass its own checks · never waives, accepts
or approves on the BA's behalf · never runs a Band-1 aspect gate (that is
`/ba-clear`) · never writes into `.specify/memory/` · never asks the BA for the
flow profile — it is read from the ledger head or not read at all · never lets
the profile touch a verdict, a threshold or an assertion: the quality machinery
is profile-blind, and the appended agenda line is a render.

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
