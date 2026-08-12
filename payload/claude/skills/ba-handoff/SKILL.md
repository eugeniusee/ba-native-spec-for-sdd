---
name: ba-handoff
description: Hand a gate-certified feature to Spec Kit (Mode A). Verifies every certification hash against the live files, refuses on any divergence, checks out the feature branch, confirms Spec Kit's structure, and reports ready. The operator resumes at /speckit-plan. BA-invoked after an effective PASS; it never edits anything.
disable-model-invocation: true
---

# `/ba-handoff <feature>` — the Mode-A handoff

**Argument:** `<feature>` — `004`, `004-appointment-booking`, or the full path.

This is the boundary. The gate's responsibility ended when the certification
manifest was written; the operator's begins at `/speckit-plan`. Between them
sits exactly one act: **verify that the certified text is still the live text**,
then plumb.

## Invocation contract — check before you run

- **BA-invoked, after an effective PASS.** Not on a save, not on a commit, not
  because a spec "looks done". If `/ba-gate <feature>` has not produced an
  effective PASS, there is no certification manifest and this skill refuses.
- **This skill authors nothing.** No spec edit, no memory artifact, no ledger
  entry, no commit. Its only effects are a git branch checkout and a printed
  report — and it produces neither until the guard is clean.
- **A refusal is a result, not an error.** The adapter refusing is the framework
  working: it is the runtime enforcement of *the certified text is the read
  text* (plan Q5). Do not work around it, do not re-hash, do not "just check the
  diff and continue". Route the fix and re-gate.
- **Never under an AG.** Handoff is the safety floor, with the two ⚑ sign-offs
  and the effective PASS: an autonomy grant (`/ba-auto on`) never reaches this
  act and never AUTO-stamps it. Under auto a feature stops at "done, awaiting
  ratification" — this command is what the BA runs after.

## The act

```bash
python3 .specify/ba/scripts/sk_handoff.py <NNN-feature> --root .
```

In order, with **no side effect until step 5**:

1. **Resolve** the feature folder and locate its certification manifest — the
   latest `.specify/ba/runs/<NNN-feature>/run-<n>/cert.json`. The gate writes
   that file only on an effective PASS, so its absence and "this feature never
   passed" are the same fact.
2. **The hash guard.** Every path in the manifest, re-hashed against the live
   file. Any mismatch or missing file → **REFUSE**, printing each diverged path
   and why.
3. **The certified artifact set** — `spec.md`, `traceability.md`,
   `gate-report.md` — is in place in the feature folder.
4. **Spec Kit's structure** — `plan-template.md`, `tasks-template.md`,
   `.specify/scripts/`, and the `/speckit-plan` skill itself. A handoff into a
   project with no pipeline to hand to is not a handoff.
5. **The branch.** `NNN-feature` is checked out; created from the current HEAD
   if it does not exist. The name matches the folder `/ba-enter-feature`
   assigned, which is why the two resolve to the same thing here.
6. **The guard again.** A checkout can itself move a certified file — an
   existing branch may carry a different revision of `spec.md`. A divergence
   found here is the same refusal, with the branch named as its cause.
7. **The feature pointer.** `.specify/feature.json` is set to
   `specs/NNN-feature` — this is how Spec Kit v0.12.x resolves `FEATURE_DIR`,
   `FEATURE_SPEC` and `IMPL_PLAN`. It is normally written by
   `/speckit-specify`, the command Mode A deliberately never runs (our spec is
   already at the destination), so without this act `/speckit-plan` stops on
   *ERROR: Feature directory not found* and the operator has to intervene —
   which is exactly the manual rework Mode A exists to make zero. Spec Kit's
   own file, holding none of our content, written idempotently.
8. **The ready report.**

Useful flags: `--verify-only` (the guard alone — the cheap pre-handoff check,
and the right thing to run when someone asks "is 004 still certified?") ·
`--no-branch` (verify and report, touch no git state) · `--dry-run` (report the
branch act without performing it) · `--format json`.

## Reading the result

**Ready.** The report names the certified run, the number of hashes verified,
the branch state, the plumbing, the waivers in force, and every carried
`[NEEDS CLARIFICATION]` marker with its section. Read the last two lines aloud
to yourself before moving on: they are the whole contract with the coding agent.

**REFUSED — certified path(s) diverged.** Someone edited a certified file after
certification: the spec, a governance or context artifact in the manifest, or
the generated `traceability.md`. The PASS is void. Two honest routes, and no
third:

- the edit was wanted → keep it and **re-gate** (`/ba-gate <feature>`; a re-gate
  after a small edit is cheap by construction — the incremental re-run set);
- the edit was not wanted → revert it, and the hashes verify again.

Voiding is a state change, not an event: nothing watched for the edit, and this
check is where it surfaces. That is the design.

**REFUSED — no certification.** The feature has no effective PASS. Run the gate.

**REFUSED — artifact set incomplete / Spec Kit structure incomplete.** A gate
run that ended before Stage 5, or an install that never completed. Named
plainly, with the act that fixes it.

## After ready

The operator runs `/speckit-plan`. **No file operation happens in between** —
that is the Mode-A property the whole chain exists to protect: no LLM between
gate and plan, no re-summarizing, no "let me just tidy the spec first". The
certified text is what the coding agent reads.

What the coding agent will find, and what it means:

- **A `[NEEDS CLARIFICATION]` marker in a certified spec is deliberate** — a
  consciously accepted unknown, named in the text and waived on the record. The
  report lists them; the gate report names the waiver each one sits under.
  Implement around it and surface it. Never resolve it by guessing.
- **Nothing else is open.** Every other gap either passed, was overridden as a
  false positive, or is one of the markers above.

Then: `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`, operator
steering. The BA re-enters at Band-3 verification, against the acceptance tier.

**Anything that changes after this line opens a new delivery cycle** — fix in
the spec → re-gate → re-handoff. Spec errors are never hand-patched in code.

**P7 — escape filing.** If something downstream catches a requirements defect
this gate missed — a `/speckit-analyze` or `/speckit-checklist` finding,
plan-time confusion, an implementation defect traced to spec ambiguity — file
the escape record in `.specify/gate-tuning.md` naming the CC-ID that ought to
have caught it, or `none — new class`. The backstop's job is to shrink to zero
catches.

## When Mode A does not apply

Mode A is the primary and the default: our artifacts are already written where
Spec Kit reads them, so the handoff is a verification, not a transfer. **Mode B**
— importing the spec through Spec Kit's own `/speckit-specify` — is the
documented fallback for the cases where that is not true (a project not
installed by our installer, a Spec Kit layout we do not control, a pinned
version whose structure moved). It is not this skill's act and it is not
free: an LLM re-reads and re-writes the spec between gate and plan, which is
precisely the property Mode A exists to keep. See `docs/mode-b-fallback.md` in
the package repo for the procedure and the re-gate obligation it carries.

## What this skill never does

Never edits a spec, a memory artifact, a ledger, or code · never re-runs an
assertion or forms a verdict · never grants, waives, or accepts anything ·
never invokes any `/speckit-*` command (the operator does) · never commits,
merges, or pushes · never continues past a divergence · never re-hashes to
"update" a manifest — a manifest is written by the gate, at certification, and
nowhere else.

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
