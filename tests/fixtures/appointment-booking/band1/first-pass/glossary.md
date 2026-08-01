# Glossary — Clinic Network Booking

<!--
  FIXTURE (S5). T-02's output at the Requirements consolidation run, 2026-07-10 —
  the six terms the AT-RQ-3 evidence row names: Appointment · Availability ·
  Client · Hold · Slot · Specialist.

  One merge on the record: "booking" lost to "Appointment", dated. The canvas and
  the kickoff notes both used "booking" as a noun; the merge is what makes a
  later "booking" detectable drift rather than an argument.

  Read it against ../../project/.specify/memory/glossary.md, which is this file
  plus "No-show" — routed in from the 2026-07-14 Tier-1 ingestion under the
  standing discipline, with no consolidation run. Every entry here survives there
  unchanged; check-techniques.sh asserts that.
-->

| Term | Definition | Merged synonyms | Source |
|---|---|---|---|
| Appointment | A booked meeting between one Client and one Specialist at one Slot. | booking (noun) — merged 2026-07-10, canvas usage | canvas: Core Functions |
| Availability | The set of Slots a Specialist has published as open for booking. | — | canvas: Core Functions |
| Client | A person who books care for themselves. Authorization detail lives in roles-permissions.md. | — | canvas: Customers |
| Hold | A short exclusive reservation of a Slot for one Client while they confirm. | — | processes.md: booking journey |
| Slot | A bookable unit of a Specialist's time, of the Specialist's service duration. | — | canvas: Core Functions |
| Specialist | A practitioner who publishes Availability and delivers Appointments. | — | canvas: Customers |
