# Roles & Permissions — Clinic Network Booking
Authorization principle: stated in constitution.md (plan §4.14) —
this file is its enforcement surface, never its statement.

## Roles

| Role | Mandate (one line) | Derived from | Source |
|---|---|---|---|
| Client | Books and cancels own Appointments | canvas function actors — no personas exist; derivation on register + canvas alone | canvas: Core Functions · stakeholders.md |
| Specialist | Publishes own Availability; delivers Appointments | canvas function actors | canvas: Core Functions · stakeholders.md |

## Policy

| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|
| Client | Availability | view | published Availability only | canvas §7 Browse line |
| Client | Slot | book | available Slots only; creates an Appointment | canvas §7 Book line |
| Client | Appointment | cancel | own only | canvas §7 Cancel line |
| Client | Appointment | view | own only | canvas §7 Cancel line — one-step consequence |
| Specialist | Availability | publish | own only | canvas §7 publish line |
| Specialist | Appointment | view | own only | canvas §7 Notify line — one-step consequence |
