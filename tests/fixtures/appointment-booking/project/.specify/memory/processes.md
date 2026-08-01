# Core Processes — Clinic Network Booking

<!--
  FIXTURE. T-13's output, in the shape catalogue-b4 T-13 §5 pins: per journey a
  `## <name> — role: <role verbatim>` heading, a `Trigger: … → Outcome: …`
  line, numbered actor → action → observable-result steps, and a Source line.

  Significance per D-B4-4: Client and Specialist are the actors of ≥ 1 canvas §7
  Core Function line, so both carry journeys. Journeys 1–3 seeded 2026-07-10;
  journey 4 arrived 2026-07-17 with the approved governance change that added
  the Specialist × Appointment × cancel policy row.

  Helicopter grade throughout: no error path, no alternate, no cutoff. The
  five-minute hold expiry, the race path and the Slot's rebooking disposition
  are feature-004 spec ground (standard §6, §8) and appear nowhere here.
-->

## Book an appointment — role: Client
Trigger: a Client needs a Specialist appointment without phoning (→ P-1) → Outcome: Appointment booked; the Specialist knows.
1. Client browses a Specialist's published Availability → open Slots shown. `[canvas §7 Browse line]`
2. Client selects an available Slot → a Hold is placed on the Slot for that Client. `[kickoff notes]`
3. Client confirms → Appointment created; confirmation shown to the Client; the Specialist is notified. `[canvas §7 Book · Notify lines]`
Source: canvas §7 · kickoff notes · serves O-2

## Cancel own appointment — role: Client
Trigger: the Client's plans change → Outcome: Appointment cancelled; the Specialist knows.
1. Client cancels own Appointment → Appointment cancelled; the Specialist is notified. `[canvas §7 Cancel · Notify lines]`
Source: canvas §7 · serves O-2 (the Slot's rebooking disposition is deliberately unstated — spec BR ground)

## Publish availability — role: Specialist
Trigger: the Specialist's schedule for the period ahead is set → Outcome: Availability stands published; Slots browsable by Clients.
1. Specialist publishes own Availability → Slots become browsable by Clients. `[canvas §7 publish line]`
Source: canvas §7 · serves O-2 (the canvas line names Specialists or their Clinic Admins after RO-1; the journey's role and outcome are unchanged)

## Withdraw an appointment — role: Specialist
Trigger: the Specialist cannot attend a booked Appointment → Outcome: Appointment cancelled; the Client knows.
1. Specialist cancels an Appointment they hold → Appointment cancelled; the Client is notified. `[roles-permissions.md: Specialist × Appointment × cancel · governance change 2026-07-17]`
Source: gate run 2 CC-XA-01 → governance change approved 2026-07-17 · routed into this file the same day
