# Appointment Booking

<!--
  The *unrecognised* case (BUILD-LOG S10 · orchestrator §10.4 D-O50). Headings
  this reader cannot resolve to any of the ten standard §2 names, and which the
  §2 tolerances do not reach either — not an ordinal, not emphasis, simply
  another vocabulary.

  This is what must NEVER render as `drafted 0` or as `section absent`. The
  content plainly exists; the reader cannot read it. The instrument's job is to
  say exactly that: the heading it found, and the heading it expected.
-->

## Background

Clients book a Specialist's published time by calling a clinic reception desk
during working hours; about 30% of those calls go unanswered and the booking is
lost (canvas Problems P-1).

## What the user needs

US1 (P1) — As a Client, I want to book an available Slot with a chosen
Specialist, so that I secure the Appointment without calling the clinic.
Acceptance:
- [ ] Only Slots the Specialist has published are offered.

## Behaviour

FR-001 (US1) — WHEN a Client selects an available Slot and confirms, THE SYSTEM
SHALL create an Appointment in status "Booked" and display the confirmation to
the Client.

## Error handling

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | The Slot was booked by another Client after page load | Reject the booking (FR-001) | The current published Availability for that Specialist |

## Quality attributes

NFR-001 (performance) — Availability search returns results within 2 seconds for
a Specialist with up to 5,000 published Slots.

## Policies

BR-001 — A Client may hold at most 3 Appointments in status "Booked" at the same
time.

## Not doing

- Payments — epic Online Payment (E-07), Phase 2.

## Links

- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Parent epic scope brief: .specify/memory/scope/E-03.md      (E-03 §8 / F1)
