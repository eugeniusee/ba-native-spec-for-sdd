# Domain Model — Clinic Network Booking

<!--
  FIXTURE. T-11's output, in the shape catalogue-b4 T-11 §5 pins: Entities ·
  Relations · Boundary references, tabular canonical (D-B4-1 — a diagram would
  be a derived view, never this).

  Seeded 2026-07-10 under the Requirements plan and unchanged since: the entity
  set is exactly EG-1's implication surface resolved — the canvas §7 function
  objects (Availability · Slot · Appointment · Specialist) plus the acting
  Client, plus Hold, which the booking journey states and the glossary carries
  from the same run.

  Conceptual grade throughout: no field, no type, no validation, no state
  table. Feature 004's `expires_at` and the five-minute cutoff are spec ground
  (standard §9) and appear nowhere here.
-->

## Entities

| Entity | What it is (one business line) | Source |
|---|---|---|
| Appointment | A Client's booking of a Specialist's Slot | canvas §7 Book · Cancel lines · glossary.md |
| Availability | The bookable time a Specialist publishes | canvas §7 Browse · publish lines · glossary.md |
| Client | Books and cancels own Appointments | canvas: Customers · canvas §7 |
| Hold | A short exclusive reservation of a Slot while a Client confirms | processes.md: booking journey · glossary.md |
| Slot | One bookable unit of Availability | canvas §7 Book line · kickoff notes |
| Specialist | Publishes own Availability; delivers Appointments | canvas: Customers · canvas §7 Notify line |

## Relations

| From | Relation | To | Multiplicity (where stated) | Source |
|---|---|---|---|---|
| Specialist | publishes | Availability | 1 Specialist : own Availability | canvas §7 publish line |
| Availability | consists of | Slot | 1 : 0..* | kickoff notes |
| Client | holds | Appointment | 1 : 0..* | canvas §7 Book · Cancel lines |
| Specialist | delivers | Appointment | 1 : 0..* | canvas: Customers |
| Appointment | occupies | Slot | exactly 1 Slot; a Slot carries at most 1 booked Appointment | kickoff notes |
| Hold | reserves | Slot | at most 1 Hold per Slot | processes.md: booking journey |

## Boundary references (external — not entities)
- Specialists' external calendars — external system; landscape row in `context.md`, connection row canvas §8 (direction outbound) — nothing for the model to resolve.
