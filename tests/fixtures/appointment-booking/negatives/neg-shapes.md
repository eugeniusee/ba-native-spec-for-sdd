# Appointment Booking

<!--
  The three authoring shapes the live-estate field report of 14 Aug 2026 found
  (BUILD-LOG S10). Content is spec r6's, unchanged; only the *shapes* differ:

    1. numbered `## N. Heading`      — the skeleton's ordinals typed into the heading
    2. `**US1 (P1)** — As a …`       — the ID emphasised
    3. table-form FRs                — requirement statements written as rows

  Shapes 1 and 2 are read through by sk_structure's normalisation (writing
  standard §2, the reader-tolerance record) — the content is found, and CC-G-01
  still FAILs the headings, because tolerance is a courtesy and not a second
  legal form. Shape 3 is NOT tolerated: line form is the only canonical FR form
  (golden rule 4), so §3 must report *present, no parseable FR lines* — loudly,
  never as a silent zero.
-->

## 1. Overview & Value

Clients book a Specialist's published time by calling a clinic reception desk
during working hours; about 30% of those calls go unanswered and the booking is
lost (canvas Problems P-1). This feature lets a Client browse a Specialist's
published Availability and book a Slot without phoning, and lets both sides
cancel an Appointment they can no longer keep. It serves canvas Objective O-2 —
reduce lost bookings — and covers the F1 slice of the Appointment Booking epic
scope brief (E-03 §8).

## 2. User Stories

**US1 (P1)** — As a Client, I want to book an available Slot with a chosen
Specialist, so that I secure the Appointment without calling the clinic.
Acceptance:
- [ ] Only Slots the Specialist has published are offered.
- [ ] A Slot whose start time has passed is never offered.

**US2 (P1)** — As a Client, I want to cancel my own Appointment, so that the Slot
returns to the Specialist when I give enough notice.
Acceptance:
- [ ] A Client cannot cancel an Appointment that belongs to another Client.
- [ ] Cancellation inside 24h of start_time keeps the Slot unavailable for
      rebooking (BR-002).

**US3 (P2)** — As a Specialist, I want to cancel an Appointment I cannot attend, so
that the Client learns of it at the earliest moment.
Acceptance:
- [ ] A Specialist can cancel only an Appointment on their own Availability.
- [ ] The Client receives a cancellation notice naming the Appointment's
      start_time.

## 3. Functional Requirements

| ID | Story | Requirement |
|---|---|---|
| FR-001 | US1 | WHEN a Client selects an available Slot and confirms, THE SYSTEM SHALL create an Appointment in status "Booked" and display the confirmation to the Client. |
| FR-002 | US1 | IF a Client attempts to book a Slot that is no longer available, THEN THE SYSTEM SHALL reject the booking and display the current published Availability for that Specialist. |
| FR-003 | US1 | WHEN a Client selects an available Slot, THE SYSTEM SHALL place a Hold on that Slot for five minutes. |
| FR-004 | US2 | WHEN a Client cancels an own Appointment more than 24 hours before its start_time (BR-002), THE SYSTEM SHALL set the Appointment status to "Cancelled" and return the Slot to the Specialist's published Availability. |
| FR-005 | US3 | WHEN a Specialist cancels an Appointment on their own Availability, THE SYSTEM SHALL set the Appointment status to "Cancelled" and notify the Client of the cancellation. |

## 4. Flows, States & Errors

Main flow:

1. Client opens a Specialist's profile → sees published Availability for the
   next 30 days.
2. Client selects a Slot → the Slot is held for this Client for five minutes.
3. Client confirms → the Appointment exists in status "Booked"; the confirmation
   is displayed; the Specialist is notified.

Alternates & errors:

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | The Hold reaches five minutes before the Client confirms | Release the Slot (FR-003) | "Slot expired", with the refreshed Availability for that Specialist |
| E2 | The Slot was booked by another Client after page load | Reject the booking (FR-002) | The current published Availability for that Specialist |

## 5. Non-Functional Requirements

NFR-001 (performance) — Availability search returns results within 2 seconds for
a Specialist with up to 5,000 published Slots.

NFR-002 (security/privacy) — An Appointment is readable only by the Client who
owns it and the Specialist who delivers it; every read is attributable to an
authenticated account.

- Availability: N/A — covered by the global platform availability budget
  (design-standards.md); no feature-specific delta.
- Accessibility: N/A — covered by the global Design & UX accessibility budget;
  no feature-specific delta.
- Localization: N/A — single-locale launch; the global localization standard
  carries the product-level rule.
- Scale: N/A — covered by the global scale budget (design-standards.md); the
  launch volumes of this feature sit inside it.

## 6. Business Rules

BR-001 — A Client may hold at most 3 Appointments in status "Booked" at the same
time.

BR-002 — Free cancellation window: strictly more than 24 hours before
start_time. Inside 24h, cancellation is allowed but the Slot is NOT released for
rebooking.

## 7. Data Requirements

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | start_time | datetime | yes | future only; inside the Specialist's published Availability | timezone: the Specialist's |
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | see the states table |
| Hold | expires_at | datetime | yes | start_time of the Hold plus five minutes | drives FR-003 |

States & transitions:

| State | Allowed transitions | Trigger |
|---|---|---|
| Booked | → Cancelled | Client or Specialist cancels — any time before start_time; Slot release per BR-002 |
| Booked | → Completed | Specialist marks the Appointment delivered after start_time |
| Cancelled | — (terminal) | — |
| Completed | — (terminal) | — |

## 8. Integration Touchpoints

| System | Direction | What is exchanged | Constraint |
|---|---|---|---|
| Specialist's external calendar | outbound | Appointment created and cancelled events | the Specialist's calendar stays in place (constraints.md C-T1) |

## 9. Out of Scope

- Reschedule-in-place — deferred inside this epic to Phase 2; cancel and book
  again is the launch path (brief E-03 §3).
- Payments — epic Online Payment (E-07), Phase 2.
- Publishing Specialist Availability — separate feature of this epic
  (005-specialist-availability-publishing, brief E-03 §8 F2).

## 10. References

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Availability, Hold, No-show, Slot)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Availability, Client, Hold, Slot, Specialist)
- Parent epic scope brief: .specify/memory/scope/E-03.md      (E-03 §8 / F1)
