# Project Health — <project>

<!--
  BA-Native Spec — the Scope-H ledger. Compiled from the gate definition §10.3
  (D-G1). Destination: .specify/gate-health.md — deliberately OUTSIDE
  .specify/memory/: a runtime ledger is none of the three content classes, and
  housing it here keeps it out of CC-H-01's spec-anchored glob, out of the
  scoped-run write trigger (an H run's own write-back must not fire an H run),
  and clear of any memory/ mirror toward the coding agent's context.

  Born by the ARMING full Scope-H run at Band-1 closure (/ba-close-band1 →
  /ba-gate-health full). Before that run, Scope H is DISARMED — in-band quality
  belongs to the aspect gates.

  File discipline: the head is REWRITTEN IN PLACE; run entries are APPEND-ONLY.
  The head exists so Stage-0 admission and the BA's session-start habit can cite
  standing state at a glance — pre-flight still runs fresh every time; the head
  is convenience, never the guarantee.
-->

## Current gaps & acceptances

Standing H gaps:  none
Health acceptances: none

<!-- Line shapes once populated:
  Standing H gaps:
    CC-H-<nn> — <element>: <what is wrong> → <fix action>       [covered by HA-<nn> | live]
  Health acceptances:
    HA-<nn> · CC-H-<nn> · <element> · reason: <why accepted now> ·
      risk: <one line> · approver: <name> · <date> · revisit: <event-shaped trigger>

  HA mechanics (§10.4): an HA lifts Stage-0 admission blocks and NOTHING else —
  no Scope-F assertion ever reads it. Persistence mirrors the override's: the
  accepted gap's artifact is edited → the scoped H run re-evaluates; evidence
  unchanged at element granularity → auto re-apply, logged; evidence changed or
  gap reshaped → the HA voids, the gap goes live, admission blocks return.
  Scope-H gaps take no per-feature waivers.
-->

## Runs

<!-- Append-only. One entry per full run; scoped runs are silent unless FAIL.

## Health run <n> — <date> — <full | scoped: <artifact>> — <trigger>
Coverage: <all spec-anchored artifacts | <artifact> + dependents>
Scope rationale: <the narrowest scope that answers the question — stated before running>
Verdict: HEALTHY | <n> gaps

Gaps:              (named-gap grammar; "none" if HEALTHY)
CC-H-<nn> FAIL — <element>: <what is wrong> → <fix action>

HA review (P8):    (full runs only — one line per standing HA)
HA-<nn> — re-affirmed <initials> | lapsed <initials> · revisit trigger: <event>

Voided certifications: <"PASS of <NNN> voided by <artifact> edit — cheap re-gate
                        recommended" | none>
-->

<!-- Cadence (contract §3, operationalized in gate §10.1):
  Full    — Band-1 closure (the run that arms the system) · after each scope-brief
            ingestion batch · on demand (recommended session-start habit)
  Scoped  — every framework write to a governance/context artifact; the touched
            artifact's H assertions + its cross-reference dependents; SILENT
            UNLESS FAIL
  Pre-flight — Stage 0 of every Scope-F run, the seven CC-H restricted to deps(F);
            this is the hard guarantee
  Disarmed — before Band-1 closure
-->
