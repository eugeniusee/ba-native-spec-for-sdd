# Roadmap — Clinic Network Booking

## Epics

| ID | Epic | Description | Phase | Status | Source |
|---|---|---|---|---|---|
| E-01 | Accounts & Access | Clients and Specialists act under their own accounts. Covers registration, sign-in, and the role split the policy model defines. | MVP | Defined | canvas: Core Functions "Cancel own appointment" (*own* ⇒ accounts) · roles-permissions.md (Client · Specialist) |
| E-02 | Specialist Profiles | Specialists present themselves to Clients. Covers profile content, service list, and the service durations Slot length derives from. | MVP | Defined | canvas: Core Functions — browse line · domain-model.md (Specialist) |
| E-03 | Appointment Booking | Clients book specialists' published slots online instead of calling. Covers slot browsing, booking, cancellation, and specialist notifications. | MVP | In delivery | canvas: Core Functions — browse · book · cancel · publish · notify (`→ O-2`) · processes.md: booking journey |
| E-04 | Calendar Sync | Appointment events reach the calendars Specialists already keep. Covers outbound event mirroring and the failure posture when a provider is unreachable. | Phase 2 | Defined | canvas: Third-Party Connections · constraints.md C-T1 |
| E-05 | Notifications | Clients and Specialists learn about bookings and changes without checking the product. Covers channel selection and per-event delivery. | Phase 2 | Defined | canvas: Core Functions — notify line |
| E-06 | Clinic Administration | Clinic staff act on behalf of the Specialists they support. Covers the administrator role and the calendars it manages. | Later | Defined | call 2026-07-14 — clinic administrators (RO-1 deferral) |
| E-07 | Online Payment | Clients pay for appointments in the product rather than at the clinic. Covers taking payment at booking; wider payment scope enters at this epic's scoping call. | Phase 2 | Defined | out-of-scope.md: payments deferred row — graduated this run |
| E-08 | Reporting | The network sees how booking is performing. Covers lost-booking, no-show, and utilisation views. | Later | Defined | canvas: Objectives O-2 — measurement ground |

## Allocation log
(append-only — allocation ground; D-B6-4)

### Allocation 1 — 2026-07-11 · trigger: post-decomposition · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-01 Accounts & Access | Unallocated → MVP | dependency order: E-03's "Cancel own appointment" presumes accounts |
| E-02 Specialist Profiles | Unallocated → MVP | dependency order: Slot length derives from a Specialist's service duration |
| E-03 Appointment Booking | Unallocated → MVP | walking skeleton: the thinnest end-to-end slice of the booking journey; value: `→ O-1 · O-2`; risk noted — calendar direction open (canvas: Third-Party) |
| E-04 Calendar Sync | Unallocated → Phase 2 | risk: provider contract unsigned; value: booking works without it at launch |
| E-05 Notifications | Unallocated → Phase 2 | value vs. effort: in-product notification carries launch; channel breadth is not on the O-2 path |
| E-06 Clinic Administration | Unallocated → Later | value vs. effort: no launch population depends on it |
| E-07 Online Payment | Unallocated → Phase 2 | value vs. effort: no payment surface needed for O-2 at launch; integration-heavy; phase hint carried from the graduated out-of-scope row |
| E-08 Reporting | Unallocated → Later | dependency order: measurement needs delivered booking volume first |

Held: — (first run: all eight rows allocated) · Basis: MVP composes the booking journey end to end inside the autumn window (constraints.md C-B1 — launch tied to the autumn season) — O-1's "MVP this year" made a plan.

### Allocation 2 — 2026-07-15 · trigger: post-ingestion E-03 · BA: Y.K.
no change — the brief confirms the MVP composition: reschedule-in-place stays deferred inside E-03 (brief §3), not a phase move; R1 (calendar provider contract unsigned) held as in-epic risk with a named owner, not a re-phase.
