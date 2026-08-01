# Presale material — Clinic Network Booking

<!--
  FIXTURE (S5). The Frame act's input: everything presale and the kickoff call
  knew, before any framework artifact existed. This is raw material, not a
  framework artifact — no thirteen sections, no line-IDs, no Context/Constraints
  element, no citations. Turning it into `canvas.md` in framework shape is
  exactly T-01's act.

  Two sources, deliberately distinguishable, because the framed canvas has to
  cite one or the other on every line: the presale summary written by the
  presale team, and the notes from the 2026-07-04 kickoff call. Where both say
  the same thing, the framed canvas cites the kickoff notes — the later,
  first-hand source.

  Used by: tests/check-techniques.sh (the S5 exit test) and, at S9, the Phase-2
  exit script's step 3.
-->

## A. Presale summary

**Client.** A network of eight clinics. The COO, **Olena**, brought the request
and owns the budget.

**What they want built.** *Clinic Network Booking* — a self-service booking
surface for the clinic network. It lets a client secure a specialist's published
time without phoning the clinic.

**Why now.** Booking today runs through the phone. The network wants an MVP live
this year.

**Delivery.** Responsive web. One locale at launch — the network operates in one
country and has no plans to change that inside the MVP horizon.

**What exists today.** Nothing digital for booking. The specialists each keep
their own calendar, in whatever tool they already use, and the network has said
plainly that those calendars stay in place.

## B. Kickoff call notes — 2026-07-04

Present: Olena (COO), two specialists, presale lead.

- Olena approves scope, phases and budget herself; nothing needs a board. She
  wants a weekly call for the duration and is happy to be the single channel.
- The people who use it: **clients**, who book and cancel appointments, and
  **specialists**, who publish their availability and deliver the appointments.
  Clients are not reachable directly during discovery — anything client-facing
  goes through Olena. Two of the specialists are reachable, also via Olena;
  **Dr. Ivanova** volunteered as the specialist voice for discovery.
- Olena's number: roughly **30% of booking calls go unanswered**, and when a call
  goes unanswered the booking is simply lost. That is the thing she wants fixed.
- The specialists raised a second problem of their own: they lose income to late
  cancellations, which today they learn about by phone, often too late to refill
  the time.
- What it has to do, in their words: browse a specialist's published
  availability, book an available slot, cancel your own appointment, let
  specialists publish their availability, and notify the specialist when
  something is booked or cancelled.
- On the two that matter most: "if people can see the free time and book it
  themselves, we stop losing the ones we never answered" — browsing and booking
  are how the lost-bookings number comes down.
- The specialists' existing calendars are not going away. Appointments must show
  up there — events pushed out to the calendar the specialist already keeps.
- Today's alternative, everywhere in the region: phone-and-paper scheduling at
  the incumbent clinics.
- Nothing was said about what the product would do better than the phone-and-paper
  alternative beyond "it is online" — Olena wanted to leave positioning for later.
- Nothing was said about legal, data-protection or commercial constraints, and
  nobody was in the room who would have known.
