# Negative — CC-G-01

<!-- Seeded defect: §1's heading is renamed and §6's is dropped. Two of the ten
     standard §2 headings therefore go missing and one non-standard heading
     appears — a Stage-1 halt in a real run (gate §4.1). -->

## Overview and Value

The heading above is not the standard §2 heading "Overview & Value".

## User Stories

US1 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.

## Functional Requirements

FR-001 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL set
the Appointment status to "Cancelled".

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
