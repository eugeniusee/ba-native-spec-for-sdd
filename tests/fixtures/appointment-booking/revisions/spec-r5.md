# Appointment Booking

## Overview & Value

Clients book a Specialist's published time by calling a clinic reception desk
during working hours; about 30% of those calls go unanswered and the booking is
lost (canvas Problems P-1). This feature lets a Client browse a Specialist's
published Availability and book a Slot without phoning, and lets both sides
cancel an Appointment they can no longer keep. It serves canvas Objective O-2 —
reduce lost bookings — and covers the F1 slice of the Appointment Booking epic
scope brief (E-03 §8).

## User Stories

US1 (P1) — As a Client, I want to book an available Slot with a chosen
Specialist, so that I secure the Appointment without calling the clinic.
Acceptance:
- [ ] Only Slots the Specialist has published are offered.
- [ ] A Slot whose start time has passed is never offered.
```gherkin
Scenario: Successful booking
  Given a Client selects an available Slot
  When the Client confirms
  Then the Appointment is created with status "Booked"
```

US2 (P1) — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist when I give enough notice.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.
- [ ] Cancellation inside 24h of start_time keeps the Slot unavailable for
      rebooking (BR-002).
- [ ] Cancellation more than 24h before start_time returns the Slot to the
      Specialist's published Availability (BR-002).

US3 (P2) — As a Specialist, I want to cancel an Appointment I cannot attend, so
that the Client learns of it at the earliest moment.
Acceptance:
- [ ] A Specialist can cancel only an Appointment on their own Availability.
- [ ] The Client receives a cancellation notice naming the Appointment's
      start_time.

US4 (P3) — As a Client, I want to choose which notices I receive, so that my
message volume stays under my own control.
Acceptance:
- [ ] A Client can turn off booking-confirmation notices.

## Functional Requirements

FR-001 (US1) — WHEN a Client selects an available Slot and confirms, THE SYSTEM
SHALL create an Appointment in status "Booked" and display the confirmation to
the Client.

FR-002 (US1) — IF a Client attempts to book a Slot that is no longer available,
THEN THE SYSTEM SHALL reject the booking and display the current published
Availability for that Specialist.

FR-003 (US1) — WHEN a Client selects an available Slot, THE SYSTEM SHALL place a
Hold on that Slot for five minutes.

FR-004 (US1) — IF a Hold reaches five minutes without a confirmation, THEN THE
SYSTEM SHALL release the Slot and display the refreshed Availability to the
Client.

FR-005 (US1) — IF a Client already holds the BR-001 maximum of Appointments in
status "Booked", THEN THE SYSTEM SHALL block the booking and display that
Client's own Appointments in status "Booked".

FR-006 (US2) — WHEN a Client cancels an own Appointment more than 24 hours
before its start_time (BR-002), THE SYSTEM SHALL set the Appointment status to
"Cancelled" and return the Slot to the Specialist's published Availability.

FR-007 (US1) — WHEN an Appointment is created, THE SYSTEM SHALL quickly notify
the Specialist of the new Appointment.

FR-008 (US2) — WHEN a Client cancels an own Appointment 24 hours before its
start_time (BR-002), THE SYSTEM SHALL set the Appointment status to "Cancelled"
and keep the Slot unavailable for rebooking.

FR-009 (US3) — WHEN a Specialist cancels an Appointment on their own
Availability, THE SYSTEM SHALL set the Appointment status to "Cancelled" and
notify the Client of the cancellation.

## Flows, States & Errors

Main flow:

1. Client opens a Specialist's profile → sees published Availability for the
   next 30 days.
2. Client selects a Slot → the Slot is held for this Client for five minutes.
3. Client confirms → the Appointment exists in status "Booked"; the confirmation
   is displayed; the Specialist is notified.

Alternates & errors:

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | The Hold reaches five minutes before the Client confirms | Release the Slot (FR-004) | "Slot expired", with the refreshed Availability for that Specialist |
| E2 | The Slot was booked by another Client after page load | Reject the booking (FR-002) | The current published Availability for that Specialist |
| E3 | The Client already holds the BR-001 maximum of Appointments in status "Booked" | Block the booking (FR-005) | The cap stated, with that Client's own Appointments in status "Booked" |

## Non-Functional Requirements

NFR-001 (performance) — Availability search returns results within 2 seconds for
a Specialist with up to 5,000 published Slots.

NFR-002 (security/privacy) — An Appointment is readable only by the Client who
owns it and the Specialist who delivers it; every read is attributable to an
authenticated account.

- Availability: N/A — covered by the global platform availability budget
  (design-standards.md); no feature-specific delta.
- Localization: N/A — single-locale launch; the global localization standard
  carries the product-level rule.
- Scale: N/A — covered by the global scale budget (design-standards.md); the
  launch volumes of this feature sit inside it.

## Business Rules

BR-001 — A Client may hold at most 3 Appointments in status "Booked" at the same
time.

BR-002 — Free cancellation window: strictly more than 24 hours before
start_time. Inside 24h, cancellation is allowed but the Slot is NOT released for
rebooking.

BR-003 — Slot duration equals the Specialist's service duration; Slots never
overlap for the same Specialist.

## Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | start_time | datetime | yes | future only; inside the Specialist's published Availability | timezone: the Specialist's |
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | see the states table |
| Appointment | client_note | text | no | at most 500 characters | visible to the Specialist |
| Hold | expires_at | datetime | yes | start_time of the Hold plus five minutes | drives FR-004 |

States & transitions:

| State | Allowed transitions | Trigger |
|---|---|---|
| Booked | → Cancelled | Client or Specialist cancels — any time before start_time; Slot release per BR-002 |
| Booked | → Completed | Specialist marks the Appointment delivered after start_time |
| Booked | → No-show | Specialist marks the Appointment; only after start_time |
| Cancelled | — (terminal) | — |
| Completed | — (terminal) | — |
| No-show | — (terminal) | — |

## Integration Touchpoints

| System | Direction | What is exchanged | Constraint |
|---|---|---|---|
| Specialist's external calendar | outbound | Appointment created and cancelled events | the Specialist's calendar stays in place (constraints.md C-T1); the failure expectation is not yet fixed — [NEEDS CLARIFICATION: what becomes of a confirmed Appointment while calendar sync is unavailable? — brief E-03 OQ-2 / R1, provider contract unsigned] |

## Out of Scope

- Reschedule-in-place — deferred inside this epic to Phase 2; cancel and book
  again is the launch path (brief E-03 §3).
- Payments — epic Online Payment (E-07), Phase 2.
- Recurring Appointments — not planned.
- Publishing Specialist Availability — separate feature of this epic
  (005-specialist-availability-publishing, brief E-03 §8 F2).

## References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Availability, Hold, No-show, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Availability, Client, Hold, Slot, Specialist)
- Parent epic scope brief: .specify/memory/scope/E-03.md      (E-03 §8 / F1)
