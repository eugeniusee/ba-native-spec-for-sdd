# Negative — CC-G-03 · CC-G-04 · CC-XA-02

<!-- Seeded defects: an unresolved marker (CC-G-03), three banned words in
     §§3/5/6 (CC-G-04), and a persona name used as an actor (CC-XA-02 —
     run with --personas negatives/personas.md). -->

## Overview & Value

Clients cancel Appointments by phone today; this feature moves the act into the
product. It serves canvas Objective O-2.

## User Stories

US1 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist.
Acceptance:
- [ ] Marta can cancel only her own Appointment.

## Functional Requirements

FR-001 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL
quickly set the Appointment status to "Cancelled".

FR-002 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL
handle the Slot release
[NEEDS CLARIFICATION: is the Slot released inside the free-cancellation window?].

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

BR-001 — Free cancellation window: TBD.

## Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | terminal after Cancelled |

## Integration Touchpoints

N/A — no external touchpoints.

## Out of Scope

- Specialist-initiated cancellation — separate story of this epic.

## References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Slot)
- Parent epic scope brief: .specify/memory/scope/E-03.md
