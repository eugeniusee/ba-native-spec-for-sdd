# Negative — CC-FL-02 · CC-NF-02 · CC-BR-02 · CC-OS-01

<!-- Seeded defects:
     §4 — main flow only, no alternate or error path   → CC-FL-02
     §5 — only the performance category is covered     → CC-NF-02 ×5
     §6 — BR-001 defined twice; FR-002 references an
          undefined BR-009                             → CC-BR-02 ×2
     §9 — no exclusion (a bare N/A, which the contract
          rules is never the degenerate answer)        → CC-OS-01 -->

## Overview & Value

A negative fixture for the section checks.

## User Stories

US1 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.

## Functional Requirements

FR-001 (US1) — WHEN a Client cancels an own Appointment, THE SYSTEM SHALL set
the Appointment status to "Cancelled".

FR-002 (US1) — WHEN a Client cancels an own Appointment inside the BR-009
window, THE SYSTEM SHALL retain the Slot for the Specialist.

## Flows, States & Errors

1. Client opens an own Appointment → sees the cancellation action.
2. Client confirms the cancellation → the Appointment status is "Cancelled".

## Non-Functional Requirements

NFR-001 (performance) — A cancellation is acknowledged within 2 seconds.

## Business Rules

BR-001 — Free cancellation window: strictly more than 24 hours before
start_time.

BR-001 — A Client may hold at most 3 Appointments in status "Booked" at the
same time.

## Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | terminal after Cancelled |

## Integration Touchpoints

N/A — no external touchpoints.

## Out of Scope

N/A — nothing to fence off.

## References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Slot)
- Parent epic scope brief: .specify/memory/scope/E-03.md
