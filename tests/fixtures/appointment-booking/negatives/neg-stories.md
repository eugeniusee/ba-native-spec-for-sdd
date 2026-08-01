# Negative — CC-US-01…04

<!-- Seeded defects, one per assertion:
     US1  — the "so that" clause is missing            → CC-US-01
     US2  — the actor is "user", not a defined role    → CC-US-02
     US3  — two priorities, and no story is P1         → CC-US-03
     US2  — the ID is used twice                       → CC-US-04
     No marker and no banned word: this file is also the CC-G-03 PASS case. -->

## Overview & Value

A negative fixture for the story checks. It carries the whole skeleton so that
only the story assertions fail.

## User Stories

US1 (P2) — As a Client, I want to cancel my own Appointment.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.

US2 (P2) — As a user, I want to see my own Appointments, so that I know what is
booked.
Acceptance:
- [ ] Only the Client's own Appointments are listed.

US3 (P2) (P3) — As a Specialist, I want to cancel an Appointment I cannot
attend, so that the Client learns of it early.
Acceptance:
- [ ] A Specialist can cancel only an Appointment on their own Availability.

US2 (P3) — As a Client, I want to see a Specialist's published Availability, so
that I can choose a time.
Acceptance:
- [ ] Only published Slots are listed.

## Functional Requirements

FR-001 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL set
the Appointment status to "Cancelled".

FR-002 (US2) — WHEN a Client opens the Appointment list, THE SYSTEM SHALL
display that Client's own Appointments.

FR-003 (US3) — WHEN a Specialist cancels an Appointment on their own
Availability, THE SYSTEM SHALL set the Appointment status to "Cancelled".

## Flows, States & Errors

1. Client opens an own Appointment → sees the cancellation action.

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | The start_time has passed | Reject the cancellation | The Appointment shown as past, with no cancellation action |

## Non-Functional Requirements

NFR-001 (performance) — A cancellation is acknowledged within 2 seconds.
- Security/privacy: N/A — covered by the global privacy budget; no feature-specific delta.
- Availability: N/A — covered by the global platform availability budget; no feature-specific delta.
- Accessibility: N/A — covered by the global Design & UX accessibility budget; no feature-specific delta.
- Localization: N/A — single-locale launch; the global localization standard carries the rule.
- Scale: N/A — covered by the global scale budget; the launch volumes sit inside it.

## Business Rules

BR-001 — Free cancellation window: strictly more than 24 hours before
start_time.

## Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | terminal after Cancelled |

## Integration Touchpoints

N/A — no external touchpoints.

## Out of Scope

- Booking itself — separate story of this epic.

## References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Slot)
- Parent epic scope brief: .specify/memory/scope/E-03.md
