# Quickstart — validating Appointment Booking

Runnable scenarios that prove the feature works end to end. Each maps to a
requirement in the certified spec; a scenario that passes for the wrong reason
is worse than no scenario, so each names what would make it a false pass.

## Prerequisites

- PostgreSQL 16 running; `backend/` migrations applied
- `backend/` and `frontend/` dependencies installed
- Seed: one Specialist with published Availability, two Client accounts

```sh
cd backend && make db-reset && make seed && make run     # API on :8000
cd frontend && npm run dev                               # UI on :5173
```

## 1 — The happy path (US1, FR-001, FR-003, FR-007)

```sh
cd backend && pytest tests/integration/test_booking_happy_path.py -v
```

Expected: a Slot is held, `expires_at` is exactly five minutes out, confirmation
creates the Appointment in status `Booked`, and the Specialist notification is
enqueued. **False pass to watch for**: the notification asserted as "enqueued"
without asserting it is dispatched within 60s of confirmation (NFR-003).

## 2 — The race for the last Slot (US1 scenario, FR-002)

```sh
cd backend && pytest tests/integration/test_slot_race.py -v
```

Two Clients confirm the same Slot three seconds apart. Expected: exactly one
Appointment exists for the Slot; the loser gets `409 slot_unavailable` with the
Specialist's refreshed Availability, which no longer offers the Slot.

**This is the test that must not be weakened.** If it starts passing because the
service serializes requests in the test harness rather than because the partial
unique index rejects the second writer, the guarantee is gone in production and
the test still shows green. Assert the database state, not just the HTTP codes.

## 3 — The cancellation boundary, both sides (US2, BR-002, FR-006, FR-008)

```sh
cd backend && pytest tests/integration/test_cancellation_window.py -v
```

Two Appointments: one 25 hours out, one 23 hours out. Both cancel successfully
and both end `Cancelled`. Expected difference: the 25h Slot returns to published
Availability; the 23h Slot does not. **False pass to watch for**: testing only
one side. The rule is a boundary, and a boundary tested from one side is an
assertion that the rule exists, not that it is right.

## 4 — Ownership (US2/US3 acceptance, NFR-002)

```sh
cd backend && pytest tests/contract/test_authorization.py -v
```

Client B cannot cancel Client A's Appointment; a Specialist cannot cancel an
Appointment outside their own Availability. Both get `403`, and the error body
does not disclose that the Appointment exists.

## 5 — The three error rows (spec §4, E1–E3)

```sh
cd backend && pytest tests/integration/test_error_paths.py -v
```

E1 Hold expiry → `410 hold_expired` + refreshed Availability · E2 taken after
page load → `409 slot_unavailable` + current Availability · E3 BR-001 cap →
`409 booking_cap_reached` **carrying the Client's own booked Appointments**, not
just the cap number (FR-005).

## 6 — Client journey, keyboard-only (design standards)

```sh
cd frontend && npx playwright test tests/journey-booking.spec.ts
```

Browse → select → confirm → cancel, phone viewport, keyboard only, no pointer
events. Expected: every step reachable and completable; times rendered with the
Specialist's timezone named. Covers the WCAG 2.2 AA keyboard-completion clause
of the global accessibility budget.

## 7 — Non-overlapping Slots (BR-003)

```sh
cd backend && pytest tests/unit/test_slot_exclusion.py -v
```

Inserting a Slot overlapping an existing one for the same Specialist is rejected
by the exclusion constraint. Different Specialists may overlap freely.

---

## What is deliberately not validated here

**Calendar-sync outage behavior.** The spec carries a `[NEEDS CLARIFICATION]`
marker for it under waiver **W-004-01** — the provider contract is unsigned and
the BA has not ruled. There is no scenario for it because there is no
requirement to test against, and writing one would mean inventing the policy.
What *is* validated (scenario 1) is that the booking path does not depend on the
calendar: confirmation succeeds and the event is enqueued out of band. When the
question is answered, it is answered in the spec, re-gated, and a scenario
arrives with it.
