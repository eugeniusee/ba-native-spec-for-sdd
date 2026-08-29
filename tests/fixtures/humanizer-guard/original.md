# Feature Specification: Appointment Booking (004-appointment-booking)

## 2. User Stories

US1 (P1) — As a patient, I want to book an appointment with a named clinician so
that I do not have to telephone the clinic during working hours. It is a
comprehensive solution that leverages the existing scheduling infrastructure in
order to deliver a seamless booking experience.

Acceptance: a confirmed booking appears in the patient's calendar within 30
seconds. [NEEDS CLARIFICATION: does the confirmation e-mail go to the clinician
as well?]

## 3. Functional Requirements

| ID | Requirement | Story |
|---|---|---|
| FR-1 | The system SHALL confirm a booking within 30 seconds. | US1 |
| FR-2 | The system SHALL send the patient a confirmation e-mail. | US1 |

FR-1 and FR-2 are both linked to US1 and are covered by AT-RQ-1. The waiver
W-004-02 stands against CC-AC-03 and is recorded in the gate report of
2026-08-14.

## 6. Business Rules

The clinic's own constraint is cited verbatim: “bookings close ninety minutes
before the slot”. It reaches this spec through SD-2 and is carried by XO-3 —
language: English. See §10.5 for the export that renders it.

## 10. References

Run `/ba-gate 004` before handoff. The design guide lives at
[the export](exports/design-guide.md); the roadmap row is E-07.

What I need from you:
1. The confirmation e-mail — does the clinician get one too?
   a. yes — both (recommended)
   b. patient only
