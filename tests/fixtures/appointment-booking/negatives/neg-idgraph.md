# Negative — CC-TR-01 · CC-TR-02 · CC-TR-03 · CC-TR-04

<!-- Seeded defects:
     US2   — zero FRs reference it (unbuilt story)          → CC-TR-01
     FR-002— maps to US7, which does not exist              → CC-TR-01 · CC-TR-04
     §10   — domain-model.md is not listed, and the brief
             path does not resolve                          → CC-TR-02 ×2
     §10   — "Specialist" is declared but never used        → CC-TR-03 -->

## Overview & Value

A negative fixture for the traceability graph.

## User Stories

US1 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to me for rebooking.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.

US2 (P2) — As a Client, I want to choose which notices I receive, so that my
message volume stays under my own control.
Acceptance:
- [ ] A Client can turn off booking-confirmation notices.

## Functional Requirements

FR-001 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL set
the Appointment status to "Cancelled".

FR-002 (US7) — WHEN a Client opens an own Appointment, THE SYSTEM SHALL display
its start_time.

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
- Parent epic scope brief: .specify/memory/scope/E-99.md
