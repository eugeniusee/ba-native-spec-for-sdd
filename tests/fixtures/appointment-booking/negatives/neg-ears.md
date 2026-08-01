# Negative — CC-FR-01 · CC-FR-02 · CC-FR-05

<!-- Seeded defects:
     FR-001 — prose, not EARS; and no SHALL           → CC-FR-01 · CC-FR-02
     FR-002 — two SHALLs in one requirement           → CC-FR-02
     FR-003 — "or" alternation between responses      → CC-FR-02
     FR-004 — links to US9, which does not exist      → CC-FR-05
     FR-005 — carries no (US<n>) tag at all           → CC-FR-05
     FR-006 — lower-case EARS keywords                → CC-FR-01 -->

## Overview & Value

A negative fixture for the EARS lint and the FR link checks.

## User Stories

US1 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.

## Functional Requirements

FR-001 (US1) — The system creates a cancellation record when the Client
confirms.

FR-002 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL set
the Appointment status to "Cancelled" and THE SYSTEM SHALL notify the
Specialist.

FR-003 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL
release the Slot or retain the Slot for the Specialist.

FR-004 (US9) — WHEN a Client opens an own Appointment, THE SYSTEM SHALL display
its start_time.

FR-005 — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL record the
cancellation time.

FR-006 (US1) — when a Client cancels an own Appointment, the system shall
display the cancellation confirmation.

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
