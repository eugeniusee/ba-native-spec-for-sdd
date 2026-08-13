# Aspect State — <project>

<!--
  BA-Native Spec — the aspect-state ledger. Compiled from the orchestrator rules
  §2.4 (D-O3). Destination: .specify/aspect-state.md — deliberately OUTSIDE
  .specify/memory/ (D-G1/D-G8 runtime-ledger rule): out of CC-H-01's
  spec-anchored glob, out of the scoped-run write trigger, out of any memory/
  mirror toward the coding agent.

  Born by /ba-frame at Band-1 entry: head at six × `untouched`, `Band: 1 (open)`,
  the flow profile picked at P-O0 — flow-profile selection and the scope frame
  set at P-O0b — scope-frame selection, both in one render, one reply.
  File discipline: the head is REWRITTEN IN PLACE; events are APPEND-ONLY.

  States (D-O2): untouched · open · first-pass-cleared · waived · reopened.
  Transitions T1–T8 are all BA acts; an aspect gate never self-clears
  (AG transitions: /ba-auto — BA-granted, ratifiable).
  Event grammar: <date> · T<n> · <aspect> · <from → to> · <BA initials> — <basis ref>

  Flow profile (D-O14): a recommendation default, never a restriction. It filters
  which techniques the suggestion snapshot surfaces as full rows; it changes no
  threshold, no assertion, no gate. Out-of-profile techniques stay electable by
  code at any P-O2 — plan composition. A switch is a ledger event with a reason:
  Profile switch grammar: <date> · profile · <from → to> · <BA initials> — <reason>

  Scope frame (D-O42 · D-O43 · D-O44): set at P-O0b — scope-frame selection, in
  the same render as the profile pick. The head holds the machine-readable
  summary; the cited detail lives on the canvas, §13 Context/Constraints (T-01).
  Boundary takes ladder values only — MVP · MVP + Phase 2 · … ; PoC and prototype
  are never boundary or phase values, they live in Client label, which the
  machinery reads for nothing. `Capacity:` is arithmetic, never estimation —
  envelope ÷ rate × eng-share, recomputed whenever the envelope or a parameter
  changes, rendering `—` where no envelope stands. The capacity check is a
  separately removable module, default on, with one consumer: T-18's advisory.
  Frame switch grammar: <date> · scope-frame · <from → to> · <BA initials> — <reason>

  Autonomous mode (D-O36 · D-O38): `/ba-auto on` writes the autonomy grant AG-<n>,
  flips the Auto head line and logs the event; `/ba-auto off` closes it with the
  resumption report and one batch ratification. An AG moves the moment of consent,
  never the content of a ruling; the safety floor (the two flagged sign-offs, the
  effective PASS, the handoff, and the scope frame — P-O0b) sits outside every
  grant.
  AG record:   AG-<n> · scope: <full workflow | until <event>> · granted-by: <initials> ·
               <date> · revoke: /ba-auto off, or <condition>
  AUTO stamp:  <date> · AUTO (AG-<n>) · <act> · <basis>
-->

## Current state
Band: 1 (open)
Profile: <Discovery | Presale> — picked <date> (P-O0); switches append to Events with a reason
Boundary: <ladder value(s) — MVP | MVP + Phase 2 | …> — set <date> (P-O0b); switches append to Events with a reason
Budget: <amount + currency> | none stated  (<citation | BA-supplied | open — no source material>)
Client label: <free text — PoC · prototype · pilot…>  (<citation | BA-supplied | open — no source material>)
Parameters: rate <amount>/h · team mix <…> (eng-share <n>%) · capacity check <on | off>
Capacity: ~<n> eng-h (envelope ÷ rate × eng-share) | — (no envelope)
Auto: off

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
  Auto: on — AG-<n> · scope <full workflow | until <event>> · since <date>
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

  <date> · scope-frame · <from → to> · <initials> — <reason>
  <date> · auto on  · AG-<n> · scope <…> · <initials> — profile <…> (stated | inferred: <basis>)
  <date> · auto off · AG-<n> · <initials> — <n> AUTO acts, awaiting ratification
  <date> · ratification · AG-<n> · <initials> — accepted all | exceptions: <list>
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
