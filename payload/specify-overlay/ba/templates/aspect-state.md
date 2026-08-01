# Aspect State — <project>

<!--
  BA-Native Spec — the aspect-state ledger. Compiled from the orchestrator rules
  §2.4 (D-O3). Destination: .specify/aspect-state.md — deliberately OUTSIDE
  .specify/memory/ (D-G1/D-G8 runtime-ledger rule): out of CC-H-01's
  spec-anchored glob, out of the scoped-run write trigger, out of any memory/
  mirror toward the coding agent.

  Born by /ba-frame at Band-1 entry: head at six × `untouched`, `Band: 1 (open)`.
  File discipline: the head is REWRITTEN IN PLACE; events are APPEND-ONLY.

  States (D-O2): untouched · open · first-pass-cleared · waived · reopened.
  Transitions T1–T8 are all BA acts; an aspect gate never self-clears.
  Event grammar: <date> · T<n> · <aspect> · <from → to> · <BA initials> — <basis ref>
-->

## Current state
Band: 1 (open)

| Aspect | State | Since | Basis |
|---|---|---|---|
| Stakeholders | untouched | — | — |
| Context | untouched | — | — |
| Value | untouched | — | — |
| Vision | untouched | — | — |
| Solution | untouched | — | — |
| Requirements | untouched | — | — |

Standing aspect waivers:  none
Open reopens:             none
Upstream flags:           none
Deferred consequences:    none

<!-- Head line shapes once populated:
  Band: 1 (closed <date>) — Bands 2/3 capable
  Standing aspect waivers:  AW-<n> · <aspect> · <AT-ID(s) unmet> — revisit: <event>
  Open reopens:             RO-<n> · <aspect> — <conflict, one line>
  Upstream flags:           <aspect> flagged: prerequisite <aspect> reopened
  Deferred consequences:    RO-<n>: <item> — trigger: <event>
-->

## Events

<!-- Append-only. Evidence tables, AW records, RO records, band events, and
     threshold-gap candidates append here in full.

  Aspect gate review — <aspect> — <date>
  | AT | Evidence | Met |
  |---|---|---|
  | AT-<AA>-<n> | <file + section pointer> | ✓ | ✗ — <what is missing> |
  → CLEARED · <initials> · <date>            (T2 / T6; or NOT CLEARED / WAIVE)

  AW-<n> · <aspect> · unmet: <AT-IDs, each with exactly what is missing>
    reason: <why progression proceeds anyway>
    risk accepted: <what downstream work now builds on, unverified>
    approver: <name> · <date>
    revisit trigger: <event-shaped — never a date wish>
    status: granted | superseded — <date> | lapsed — <date> | voided by RO-<n>

  RO-<n> · <aspect> — <contradicted artifact:line>: <conflict statement>
    → <resolution path>
    source: <emitter> · received <date> · status: received | open | resolved — <refs> | declined — <reason>
    blast radius: dependents <list> flagged `upstream reopened` (no cascade) ·
                  in flight: <epics/features + certification states> ·
                  ruling: continue-with-visibility | paused: <named items>

  Threshold-gap candidate — <date> · should have been caught by <AT-ID | none — new class>
    <what escaped, and why the threshold missed it>
-->

<!-- Band-1 closure checklist (§8.2), recorded as the closure event:
  1. All six aspects first-pass-cleared or waived; zero reopened.
  2. Every standing AW re-affirmed one line each, explicitly into the armed
     state: "carried past closure — debt visible to CC-H where it touches
     spec-anchored ground."
  3. The orchestrator requests the full Scope-H run (the gate runs it); its
     entry lands in .specify/gate-health.md.
  4. Closure completes when the arming entry exists — regardless of its verdict.
-->
