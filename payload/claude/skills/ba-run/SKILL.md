---
name: ba-run
description: Route runner, batch spec driver, thin alias and custom-technique runner - /ba-run with no argument runs the composed plan as a route on one go; /ba-run specs all drives batch Band-3 entry; catalogue techniques run one-step via their own commands with the P-O3 - technique invocation check compiled in; /ba-run <technique> forwards to the identical path; custom plan lines run here under their pinned contract.
disable-model-invocation: true
---

# `/ba-run [<technique> [args] | specs all | specs <epic-list>]` — route runner, batch driver, alias & custom runner

**Route runner (no argument) — §7.5.** Render the §10.6 route shape once:

```
Route — <destination, one line> · profile: <profile>
| # | Code — technique | Yields |
|---|---|---|
| 1 | T-08 — Value definition | canvas Problems + Objectives |
Stops en route: <the decision points, or none>
Next: step 1 — go?
```

Take the BA's `go`, then run each row in order by reading its technique's skill file
(`.claude/skills/ba-<id>/SKILL.md`) and executing it as the procedure — each row
under its own compiled P-O3 (technique invocation) check and run-end
bookkeeping. Never stop between rows for acknowledgement (§10.1 checkpoint law).
Stop only at: a clearing proposal (P-O4 — clearing confirmation) · a waiver act
(P-O5 — aspect-waiver acts) · a reopen ruling (P-O6 — reopen ruling) · a defer
batch · an overflow ruling (P-O9 — overflow ruling) · a band transition · a
contract miss (name the single unblocking act). Which plan: the open aspect's
composed plan; no aspect open and Band 2 reachable → the `## Band 2` section's
route.

**Batch spec driver — §8.4.** `specs all` (or `specs <epic-list>`): one
P-O8 — Band-3 entry confirmation table for every selected feature (rows
strikeable by number, one confirm); record each confirmed feature's status flip
and band event individually; run Tier 2 — spec-depth gap-filling per feature in
assumption posture, each run writing its own `## Band 3` run-log line; stop once
at the consolidated defer-confirm.

**Catalogue techniques** (`t01`…`t18`, `tier1 <mode> <epic>`, `tier2 <feature>`):
`/ba-run <id>` is a thin alias for `/ba-<id>`. Read the technique's skill file
at `.claude/skills/ba-<id>/SKILL.md` and execute it as the procedure, exactly
as if the BA had typed `/ba-<id>`. Its compiled P-O3 (technique invocation)
check governs; do not re-check here, do not confirm, never ask the BA to retype
anything. One typed command, one run.

**Custom techniques** (a plan line naming no catalogue skill): check P-O3
(technique invocation) here — the line is on the composed plan of an
`open`/`reopened` aspect with a pinned, BA-confirmed contract — then run under
that contract. On a miss, stop in ≤ 2 lines and name the single unblocking act
(`/ba-aspect <aspect>`). At run end, apply the same compiled bookkeeping the
catalogue skills carry: output lands · findings route as one batch · run-log
line · threshold refresh with a one-line `/ba-clear` proposal when the table
completes.

**What this skill never does.** Never demands a second command for a catalogue
technique · never re-runs a compiled P-O3 (technique invocation) check · never
pins or confirms a contract (P-O2 — plan composition, its own act) · never
confirms a threshold or clears an aspect.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
