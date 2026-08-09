# Specialist Availability Publishing

## Overview & Value

Specialists today hand their working hours to reception, and a Client only
learns what is free by phoning (canvas Problems P-1). This feature lets a
Specialist publish their own bookable time and withdraw time they can no longer
offer. It serves canvas Objective O-2 — reduce lost bookings — by making
Availability visible without a call, and covers the F2 slice of the Appointment
Booking epic scope brief (E-03 §8).

## User Stories

US1 (P1) — As a Specialist, I want to publish my working time as bookable
Slots, so that Clients can book it without phoning the clinic.
Acceptance:
- [ ] Published Slots appear in the Specialist's own Availability only.
- [ ] A Slot whose start time has passed is never published.
- [ ] Slot length follows the service duration on the Specialist's profile
      (BR-001).
- [ ] [NEEDS CLARIFICATION: how far ahead may a Specialist publish — the call
      gave no horizon and the brief carries none]

US2 (P2) — As a Specialist, I want to withdraw a published Slot I can no longer
offer, so that no Client books time I cannot keep.
Acceptance:
- [ ] A Specialist can withdraw only a Slot on their own Availability.
- [ ] A Slot that already carries a booked Appointment is not withdrawn by this
      act (BR-002).

## Functional Requirements

FR-001 (US1) — WHEN a Specialist publishes a working period, THE SYSTEM SHALL
create the Slots that period contains and add them to that Specialist's
published Availability.

FR-002 (US1) — IF a published period overlaps Slots already on that
Specialist's Availability, THEN THE SYSTEM SHALL reject the publication and
display the overlapping Slots.

FR-003 (US2) — WHEN a Specialist withdraws a published Slot that carries no
Appointment, THE SYSTEM SHALL remove the Slot from the published Availability.

FR-004 (US2) — IF a Specialist withdraws a Slot that carries an Appointment in
status "Booked", THEN THE SYSTEM SHALL block the withdrawal and display the
Appointment, so that the Specialist cancels it deliberately and the Client is
notified.

## Flows, States & Errors

Main flow:

1. Specialist opens their own Availability → sees the published Slots for the
   next 30 days.
2. Specialist enters a working period → the Slots it contains are shown for
   confirmation.
3. Specialist confirms → the Slots are published and visible to Clients.

Alternates & errors:

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | The period overlaps published Slots | Reject the publication (FR-002) | The overlapping Slots, with the period unchanged |
| E2 | The withdrawn Slot carries a booked Appointment | Block the withdrawal (FR-004) | The Appointment, and the Client who holds it |

## Non-Functional Requirements

NFR-001 (performance) — A published period of up to 200 Slots becomes visible
to Clients within 5 seconds of confirmation.

NFR-002 (security/privacy) — A Specialist reads and writes their own
Availability only; every write is attributable to an authenticated account.

- Availability: N/A — covered by the global platform availability budget
  (design-standards.md); no feature-specific delta.
- Accessibility: N/A — covered by the global Design & UX accessibility budget;
  no feature-specific delta.
- Localization: N/A — single-locale launch; the global localization standard
  carries the product-level rule.
- Scale: N/A — covered by the global scale budget (design-standards.md); the
  launch volumes of this feature sit inside it.

## Business Rules

BR-001 — Slot duration equals the Specialist's service duration; Slots never
overlap for the same Specialist.

BR-002 — A Slot carrying an Appointment in status "Booked" leaves the published
Availability only through a cancellation, never through a withdrawal.

## Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Availability | specialist_id | reference | yes | an existing Specialist | one Availability per Specialist |
| Slot | start_time | datetime | yes | future only; aligned to the service duration | timezone: the Specialist's |
| Slot | published | boolean | yes | — | drives Client visibility |

States & transitions:

| State | Allowed transitions | Trigger |
|---|---|---|
| Draft | → Published | Specialist confirms the working period |
| Published | → Withdrawn | Specialist withdraws a Slot carrying no Appointment |
| Withdrawn | — (terminal) | — |

## Integration Touchpoints

| System | Direction | What is exchanged | Constraint |
|---|---|---|---|
| Specialist's external calendar | inbound | busy periods that must not be published as Slots | the Specialist's calendar stays in place (constraints.md C-T1); [NEEDS CLARIFICATION: is the inbound read in scope at launch, or does the Specialist publish manually? — brief E-03 OQ-2 / R1, provider contract unsigned] |

## Out of Scope

- Booking and cancelling Appointments — separate feature of this epic
  (004-appointment-booking, brief E-03 §8 F1).
- Recurring working patterns — not planned.
- Clinic staff publishing on a Specialist's behalf — epic Clinic
  Administration (E-06), Later.

## References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Availability, Appointment, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Availability, Client, Slot, Specialist)
- Parent epic scope brief: .specify/memory/scope/E-03.md      (E-03 §8 / F2)
