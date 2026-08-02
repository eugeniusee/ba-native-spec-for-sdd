# Contract — Booking API

HTTP contract for the Client and Specialist surfaces of feature
`004-appointment-booking`. Every endpoint traces to an FR; every authorization
check traces to a policy row in `.specify/memory/roles-permissions.md`. Times
are ISO-8601 with offset, rendered in the Specialist's published timezone with
the timezone named (`design-standards.md`).

---

## `GET /specialists/{specialist_id}/availability`

Published, bookable Slots for the next 30 days (spec §4 main flow, step 1).

**Auth**: authenticated account (NFR-002).

**Query**: `from` (date, default today) · `to` (date, default today + 30d).

**200**
```json
{ "specialist_id": "…", "timezone": "Europe/Kyiv",
  "slots": [ { "slot_id": "…", "start_time": "2026-07-20T10:00:00+03:00",
               "duration_minutes": 30 } ] }
```

Only Slots with `published = true` and `start_time > now()` appear (US1
acceptance lines 1–2). Response within 2s for up to 5,000 published Slots
(NFR-001).

---

## `POST /slots/{slot_id}/hold`

Place the five-minute exclusive Hold (FR-003).

**Auth**: Client × Appointment × create.

**201**
```json
{ "hold_id": "…", "slot_id": "…", "expires_at": "2026-07-19T12:05:00+03:00" }
```

**409 `slot_unavailable`** — the Slot is already held or booked. Body carries the
refreshed availability (FR-002, error row E2).

---

## `POST /bookings`

Confirm a held Slot into an Appointment (FR-001).

**Auth**: Client × Appointment × create.

**Request**
```json
{ "hold_id": "…", "client_note": "optional, ≤ 500 chars" }
```

**201**
```json
{ "appointment_id": "…", "slot_id": "…",
  "start_time": "2026-07-20T10:00:00+03:00", "status": "Booked" }
```
Side effects, after commit: the Specialist is notified within 60s (FR-007,
NFR-003) and an outbound calendar event is enqueued (research.md decision 3).

**409 `slot_unavailable`** — lost the race, or the Slot was taken after page
load. Body carries the Specialist's current published Availability (FR-002,
error row E2). This is the partial unique index rejecting the second writer, not
an application pre-check (data-model.md).

**410 `hold_expired`** — the Hold reached five minutes without confirmation
(FR-004, error row E1). Body carries the refreshed Availability.

**409 `booking_cap_reached`** — the Client already holds the BR-001 maximum of 3
`Booked` Appointments (FR-005, error row E3). Body states the cap **and lists
that Client's own `Booked` Appointments**, which FR-005 requires:
```json
{ "error": "booking_cap_reached", "cap": 3,
  "booked": [ { "appointment_id": "…", "start_time": "…" } ] }
```

---

## `POST /appointments/{id}/cancel`

Cancel an Appointment. One endpoint, two policy rows, two effects (FR-006,
FR-008, FR-009).

**Auth**: Client × Appointment × cancel **own** — the caller's `client_id` must
equal the Appointment's (US2 acceptance line 1); or Specialist × Appointment ×
cancel on **own Availability** (US3 acceptance line 1). Any other caller: 403.
Ownership is the policy row's scope; it is never inferred from the caller's
persona.

**200**
```json
{ "appointment_id": "…", "status": "Cancelled",
  "slot_released": true, "cancelled_by": "Client" }
```

`slot_released` is BR-002 evaluated at the cancellation instant: `true` when
strictly more than 24h remains before `start_time` (FR-006), `false` inside 24h
(FR-008). Cancellation is never refused for lateness — only the release changes.

When `cancelled_by = "Specialist"`, the Client is notified and the notice names
the Appointment's `start_time` (FR-009, US3 acceptance line 2).

**403 `not_owner`** · **409 `not_cancellable`** — the Appointment is already in a
terminal state (data-model.md states table).

---

## Cross-cutting

- **403 over 404**: an Appointment the caller may not read is not disclosed by
  its error code (NFR-002).
- **Every mutating response reflects committed state.** The calendar dispatch is
  out-of-band and never gates a response (research.md decision 3) — and its
  outage behavior is the spec's open question under W-004-01, so no error code
  here describes one. That is deliberate: the API surface must not encode a
  policy the BA has not yet ruled.
- **Interface copy uses glossary-canonical terms** — Appointment, Slot,
  Specialist, Availability, Hold; never synonyms (`design-standards.md`).
