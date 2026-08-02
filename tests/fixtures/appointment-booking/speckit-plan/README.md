# `/speckit-plan` outputs — the recorded step-10 run

**Build plan §5 step 10.** These five files are what Spec Kit's own
`/speckit-plan` produced from the certified `spec.md` of
`004-appointment-booking`, in a real toy install, at the S9 session
(2026-08-01). They are **evidence, not a build unit** — nothing here is
installed, nothing here is compiled from a methodology document, and no runtime
path reads them.

```
plan.md                  Summary · Technical Context · Constitution Check ·
                         Project Structure · Complexity Tracking
research.md              Phase 0 — the five technology decisions
data-model.md            Phase 1 — entities, constraints, states, authorization
contracts/booking-api.md Phase 1 — the HTTP contract
quickstart.md            Phase 1 — the validation scenarios
```

## Why they are recorded rather than re-derived

The same split every session in this repo uses. `/speckit-plan` is an **agent
act**: it reads a spec and writes a design. A regression suite cannot re-derive
it, exactly as `check-gate.sh` cannot re-derive the gate agent's Stage-3
verdicts (see `../a-pass/README.md`). What `check-exit.sh` *can* assert, and
does, is everything mechanical around the act:

- `setup-plan.sh --json` resolves `FEATURE_SPEC` / `IMPL_PLAN` / `BRANCH`
  without operator intervention — the step that fails when the adapter has not
  written `.specify/feature.json` (S9 divergence D42);
- every certified hash still matches **after** the plan run — step 10(d);
- exactly one `[NEEDS CLARIFICATION]` marker exists across the whole certified
  artifact set, and it is the one carried under waiver W-004-01 — step 10(c);
- these recorded artifacts request no spec edit — step 10(b), asserted against
  the recorded text.

## What the run demonstrated, in the corpus's own terms

**Zero manual rework was real, and it was not free.** The plan completed without
a single spec edit because the spec already carried what planning needs: the
race resolution (US1 scenario), the Hold lifetime (FR-003/FR-004), the
cancellation boundary (BR-002 with FR-006 and FR-008 on either side), the
notification target (FR-007 + NFR-003), the error table (E1–E3), the persisted
fields with their validation (§7), and the state machine (§7). Each of those is
a completeness-contract assertion that failed at least once somewhere in this
fixture world before it passed.

**The waivered marker survived as a marker.** `research.md` decision 3 fences
the calendar-outage question behind an outbox so no implementation work depends
on it, and states plainly what it is *not* deciding. `quickstart.md` has no
scenario for it and says why. That is the behavior the `CLAUDE.md` /
`AGENTS.md` mirrors instruct — *implement around it and surface it; do not
resolve it by guessing* — observed in a real planning pass rather than asserted
in a document.

**The plan's own unknowns are not the spec's.** `plan.md`'s Technical Context
carries `NEEDS CLARIFICATION` on language, dependencies and test runner. Those
are technology decisions no upstream artifact fixes and none should — the
writing standard keeps feature specs technology-free by design — and Phase 0
resolves them as operator decisions. Step 10(c) is therefore asserted over the
**certified artifact set**, not over plan-layer files, which is the honest
reading of "the only `[NEEDS CLARIFICATION]` the coding agent reads".

## One pinned-version note

The plan template's Phase-1 step *"Update agent context by running the agent
script"* has no script to run at Spec Kit **v0.12.5**: `.specify/scripts/bash/`
ships `check-prerequisites.sh`, `common.sh`, `create-new-feature.sh`,
`setup-plan.sh` and `setup-tasks.sh`, and nothing else. The step is a no-op at
our pin. Recorded so that a future pin bump which restores the script is
recognized as a change rather than discovered as a surprise — and because our
own `AGENTS.md` / `CLAUDE.md` mirrors already carry the agent context that step
would have written.
