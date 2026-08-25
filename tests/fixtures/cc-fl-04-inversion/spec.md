# Feature Specification: Appointment Reminder Dispatch

**Feature ID:** 900-reminder-dispatch · **Epic:** E-09 · **Status:** fixture

## Overview & Value

Clients booked into an appointment receive a reminder before it starts, so that
no-show rates fall. The value is measured as the no-show rate over a rolling
30 days. This is a **regression fixture**, not a delivery spec — see README.md.

## User Stories

US1 (P1) — As a Client, I want a Reminder before my Appointment, so that I do
not miss it.
Acceptance:
- [ ] Exactly one Reminder is sent per Appointment per scheduled time.
- [ ] An Appointment starting more than 24 hours out is not reminded yet.
```gherkin
Scenario: The reminder provider rejects the address permanently
  Given Client "R. Petrenko" has an Appointment at 2026-09-01 09:00
  And the scheduler selected it at 2026-08-31 09:00
  When the reminder provider returns a permanent delivery failure
  Then the Reminder is marked undeliverable
  And the Appointment appears in the front-desk follow-up queue
```

US2 (P2) — As a Client, I want the Reminder to reflect a rescheduled time, so
that I arrive when the Appointment actually is.
Acceptance:
- [ ] A reschedule after a sent Reminder produces exactly one corrected Reminder.
- [ ] The corrected Reminder states the new time, not the original.

## Functional Requirements

FR-001 (US1) — WHEN an Appointment starts within 24 hours, THE SYSTEM SHALL
send one Reminder to that Client's stored contact address.

FR-002 (US1) — IF the reminder provider returns a permanent delivery failure,
THEN THE SYSTEM SHALL mark the Reminder undeliverable and place the Appointment
in the front-desk follow-up queue.

FR-003 (US2) — WHEN an Appointment is rescheduled after its Reminder was sent,
THE SYSTEM SHALL send one corrected Reminder stating the new time.

## Flows, States & Errors

1. The scheduler selects appointments starting within 24 hours.
2. The system sends one reminder per appointment.
3. The client receives the reminder and the appointment is marked reminded.

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| 1 | The reminder provider returns a permanent delivery failure | The reminder is marked undeliverable and the appointment enters the front-desk follow-up queue | The client receives nothing; the front desk sees the appointment listed for a call |
| 2 | The client's stored contact address is missing | [ASSUMED: the reminder is skipped] | [ASSUMED: nothing is shown] |
| 3 | The appointment is rescheduled after its reminder was sent | A corrected reminder is sent stating the new time (FR-003) | The client receives one corrected reminder |

## Non-Functional Requirements

NFR-001 (performance) — A reminder is dispatched within 60 seconds of the
scheduler selecting its appointment, at the 95th percentile.
NFR-002 (security/privacy) — A reminder states the appointment time and the
clinic name, and no clinical detail.
NFR-003 (availability) — N/A — the dispatcher inherits the platform budget in
governance; this feature adds no delta.
NFR-004 (accessibility) — N/A — the reminder is a provider-rendered message
with no interface of this feature's own.
NFR-005 (localization) — A Reminder renders in the Client's stored locale, for
each locale the clinic publishes.
NFR-006 (scale) — The dispatcher sustains 5 000 Reminders per hour without the
NFR-001 budget degrading.

## Business Rules

BR-001 — One reminder is sent per appointment per scheduled time; a reschedule
creates a new scheduled time and therefore permits one further reminder.

## Data Requirements

| Entity | Field | Type | Required | Notes |
|---|---|---|---|---|
| Reminder | appointment_id | reference | yes | the appointment reminded |
| Reminder | state | enum | yes | see the states table |

**Reminder states:** `pending` → `sent` → `delivered` · `pending` → `sent` →
`undeliverable`.

## Integration Touchpoints

The reminder provider is the one external system: outbound send, inbound
delivery receipt. Contract owner is the platform team.

## Out of Scope

- Inbound Client replies to a Reminder — not planned.
- Reminder channel selection by the Client — deferred, Phase 2 (epic
  Notification Delivery, E-05).
- Reminders for appointments outside the 24-hour window — not planned.

## References

Fixture for the CC-FL-04 coverage inversion — see README.md and
`docs/field-notes/2026-08-22-cc-fl-04-coverage-inversion.md` §6.4.
