# Core Processes — Clinic Network Booking

## Booking journey

| # | Actor | Action | Observable result | Source |
|---|---|---|---|---|
| 1 | Client | Opens a Specialist's profile | Published Availability for the next 30 days | canvas: Core Functions |
| 2 | Client | Selects a Slot | A Hold is placed on the Slot for that Client | call 2026-07-14 |
| 3 | Client | Confirms | An Appointment exists; the Specialist is notified | canvas: Core Functions |

## Cancellation journey

| # | Actor | Action | Observable result | Source |
|---|---|---|---|---|
| 1 | Client | Cancels an own Appointment | The Appointment is Cancelled; Slot release follows the cancellation window rule | call 2026-07-14 |
| 2 | Specialist | Cancels an Appointment they cannot attend | The Appointment is Cancelled; the Client is notified | call 2026-07-14 |
