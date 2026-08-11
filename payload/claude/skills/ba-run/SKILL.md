---
name: ba-run
description: Thin alias and custom-technique runner - catalogue techniques run one-step via their own commands with the P-O3 - technique invocation check compiled in; /ba-run <technique> forwards to the identical path; custom plan lines run here under their pinned contract.
disable-model-invocation: true
---

# `/ba-run <technique> [args]` — alias & custom runner

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

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
