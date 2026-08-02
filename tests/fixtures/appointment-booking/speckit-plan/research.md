# Phase 0 Research — Appointment Booking

Resolves the `NEEDS CLARIFICATION` entries in the plan's Technical Context. Each
is a **technology decision the operator owns**, not a requirements gap: none of
them is a question for the BA, and none of them would be answered by editing the
spec. Where a decision is forced by a requirement, the requirement is cited.

---

## Decision 1 — Language, runtime and framework

**Decision**: Python 3.11 + FastAPI on the backend; TypeScript + React on the
frontend.

**Rationale**: The forcing requirements are transactional, not linguistic — any
mainstream stack with a real relational driver satisfies them. FastAPI is chosen
for the explicit request/response schemas the `contracts/` files need, and
because the load in `design-standards.md` (200 Specialists, 10k Appointments per
month) is far below the point where runtime performance discriminates between
candidates. React is chosen for the phone-first Client surfaces and because
WCAG 2.2 AA with keyboard-only journeys is well-trodden ground there.

**Alternatives considered**: Node/NestJS end-to-end (one language, but no
advantage on the constraint that actually binds — the booking transaction);
Rails (fast to a CRUD booking screen; the Hold/confirm race still has to be
written by hand either way); serverless functions (rejected — the five-minute
Hold and the single-winner guarantee want one transactional boundary, not
several).

---

## Decision 2 — Storage engine and the single-winner guarantee

**Decision**: PostgreSQL 16. One Appointment per Slot is enforced by a **partial
unique index** on `(slot_id)` where `status = 'Booked'`, not by application-level
checking. The Hold is a row in `hold` with a partial unique index on `(slot_id)`
where `expires_at > now()`.

**Rationale**: This is the one decision the spec actually forces. US1's race
scenario requires that when two Clients confirm the same Slot three seconds
apart, exactly one Appointment is created and the loser sees the refreshed
Availability (FR-002). A read-then-write check in the application cannot
guarantee that under concurrency; a uniqueness constraint can, and the loser's
constraint violation is precisely the FR-002 path. BR-003 ("Slots never overlap
for the same Specialist") is an exclusion constraint over a time range on the
same reasoning.

**Alternatives considered**: Optimistic locking with a version column (works,
but re-implements in code what the index gives for free, and each new write path
has to remember it); Redis-based distributed lock for the Hold (adds a second
source of truth for Slot state — with the durable answer still needed in
Postgres for FR-004's expiry); MongoDB (no multi-document uniqueness of the
shape BR-003 wants).

---

## Decision 3 — Calendar sync, and how the open question is fenced

**Decision**: Outbound calendar events are dispatched **asynchronously, after
commit**, from an outbox table. The booking transaction never waits on the
calendar provider, and a sync failure never changes an Appointment's status.

**Rationale**: The spec carries a deliberate, waivered unknown here:

> `[NEEDS CLARIFICATION: what becomes of a confirmed Appointment while calendar
> sync is unavailable? — brief E-03 OQ-2 / R1, provider contract unsigned]`

That is a **product decision under waiver W-004-01**, not a design gap, and this
plan does not get to make it. What the plan can do is make sure the answer, when
it arrives, is cheap to apply: put the dispatch behind an outbox, so the space
of possible answers (retry forever · retry with a bound then alert · surface a
degraded badge to the Specialist · block new bookings) is a change to the outbox
consumer alone and never to the booking path.

**What is deliberately NOT decided**: retry policy, alerting, and any
Client-visible or Specialist-visible signal during an outage. Those are the
waiver's content. Any implementation choice that would prejudge them is out of
bounds — an implementer who invents a policy here has resolved a marker by
guessing, which the constitution's spec-first principle forbids and the framework
routes back as a spec fix + re-gate.

**Alternatives considered**: Synchronous dispatch inside the booking transaction
(rejected — it makes an unsigned third-party contract a dependency of the
critical path, and would force the open question to be answered now, in code);
periodic full reconciliation (a reasonable *addition* later; it does not remove
the need for a per-event path).

---

## Decision 4 — `client_note` and the data boundary

**Decision**: `Appointment.client_note` is stored as opaque Client-authored
text: length-validated at 500 characters, rendered to the owning Client and the
delivering Specialist, and nothing else. It is never parsed, classified, indexed
for search, used for analytics, or included in the outbound calendar payload.

**Rationale**: The constitution's Data-boundary principle is a MUST — no
medical-record data stored or processed, Client personal data inside the binding
regime (`constraints.md` §3). A free-text field visible to a clinician is the
one place in this feature where clinical content can plausibly arrive. It cannot
be prevented at the keyboard, so the boundary is held at *processing*: opaque
storage is not processing, and keeping it out of the third-party calendar
payload keeps it inside the regime.

**Alternatives considered**: Dropping the field (rejected — it is in the spec's
Data Requirements table and removing it would be a code-side spec edit, which the
spec-first principle forbids); free-text search over notes (rejected — indexing
is processing, and it buys nothing any requirement asks for).

---

## Decision 5 — Testing

**Decision**: `pytest` + `httpx` for the backend, Playwright for the frontend
journey tests.

**Rationale**: Follows decision 1. The *coverage* was already fixed by the spec
and does not depend on this choice — the US1 race, the BR-002 pair either side
of the 24-hour boundary, the BR-001 cap, BR-003 non-overlap, and the E1–E3 error
rows. Playwright covers the keyboard-only completion the accessibility budget
requires.

**Alternatives considered**: unittest (no fixture ergonomics for the
concurrency tests); Cypress (comparable; Playwright's keyboard-driving is the
tiebreaker given the WCAG budget).

---

## Unresolved after Phase 0

**None of this plan's own.** The one open item in this feature is the calendar-
outage question above — carried in the spec under waiver W-004-01, owned by the
BA, and fenced by decision 3 so no implementation work is blocked on it.
