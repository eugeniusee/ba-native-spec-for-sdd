# Scripted call notes — E-03 Appointment Booking · 2026-07-14

Raw BA notes from the Tier-1 scoping call. These are the **machine input** to
`/ba-run tier1 ingest E-03`; the brief at
`project/.specify/memory/scope/E-03.md` is the expected ingestion output.
Nothing here is improvised at run time — this file is the stakeholder.

Participants: Olena (clinic network COO, sponsor) · Dr. Ivanova (Specialist) ·
Dr. Kovalenko (Specialist). BA: Y.K.

---

**Q1 — how booking happens today, where it breaks.**
Olena: reception takes calls 09:00–18:00. Evenings and weekends nobody picks
up. "Roughly a third of the calls we never answer, and most of those people
just don't call back." Specialists confirm: the worst window is evenings and
weekends.

**Q2 — what must a Client do with an existing appointment at launch?**
Olena: cancel, yes — that is the one that costs us. Reschedule is nice but
"cancel and book again is fine for launch". Recurring appointments: "we don't
do those and we're not planning to."

**Q6 — who publishes availability today, and does that change?**
Dr. Ivanova: I keep my own calendar and I'd keep publishing my own times.
Olena, later in the call: at two of the clinics an administrator maintains the
calendars for the older specialists. — BA note: this contradicts the canvas
picture that specialists self-manage. Not reconciled in the room.

**Q4 — calendars: source of truth?**
Both Specialists: keep our calendars. Olena: "the booking system should be the
system of record for appointments, but it has to write into the calendar we
already use." Which providers — Olena does not know yet; the provider contract
is not signed. Owner: Olena.

**Q3 — payments.**
Olena: not at launch, that's the payment project. Confirmed nothing
payment-shaped belongs in booking.

**Q5 — order of magnitude.**
Olena: about 200 specialists across the network; "eight, maybe ten thousand
appointments a month once everyone is on it."

**Volunteered, outside the kit's frame.**
- Dr. Kovalenko: "Late cancellations cost us money — people cancel an hour
  before." Asked for a concrete cutoff; none given.
- Dr. Ivanova: no-shows are tracked on paper today and should stay tracked in
  the system.
- Dr. Kovalenko: "If I'm ill I want to cancel the appointment myself, not ring
  reception."
- Olena: nobody should see another Client's appointments.

**Unanswered at the end of the call.**
- Cap on simultaneous booked appointments per Client — Olena wants a cap but
  no number was agreed. (→ OQ-1)
- Which calendar providers must sync at launch. (→ OQ-2, blocked on the
  unsigned contract)
