# Domain Model — Clinic Network Booking

## Entities

| Entity | Meaning | Source |
|---|---|---|
| Appointment | A booked meeting between one Client and one Specialist at one Slot. | glossary.md |
| Availability | The set of Slots a Specialist has published as open for booking. | glossary.md |
| Client | A person who books care for themselves. | glossary.md |
| Hold | A short exclusive reservation of a Slot for one Client while they confirm. | processes.md |
| Slot | A bookable unit of a Specialist's time. | glossary.md |
| Specialist | A practitioner who publishes Availability and delivers Appointments. | glossary.md |

## Relationships

| From | Relationship | To | Source |
|---|---|---|---|
| Specialist | publishes | Availability | canvas: Core Functions |
| Availability | is composed of | Slot | glossary.md |
| Client | books | Appointment | canvas: Core Functions |
| Appointment | occupies | Slot | processes.md |
| Hold | reserves | Slot | processes.md |
| Specialist | delivers | Appointment | canvas: Core Functions |
