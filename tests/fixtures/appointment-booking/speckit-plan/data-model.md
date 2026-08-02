# Phase 1 Data Model — Appointment Booking

Derived from the spec's §7 Data Requirements and the project domain model
(`.specify/memory/domain-model.md`). **Nothing here is invented**: every entity
exists in the domain model, every field and validation comes from the spec, and
the state table is the spec's own. Where this file adds detail the spec does not
carry — column types, indexes — it is storage mechanics implementing a stated
rule, and the rule is cited.

## Entities

### Appointment

| Field | Type | Required | Validation | Source |
|---|---|---|---|---|
| `id` | uuid | yes | — | storage mechanics |
| `slot_id` | uuid → Slot | yes | the Slot exists and is in the Specialist's published Availability | spec §7; domain model *Appointment occupies Slot* |
| `client_id` | uuid → Client | yes | — | domain model *Client holds Appointment* |
| `start_time` | timestamptz | yes | future only; inside the Specialist's published Availability | spec §7 |
| `status` | enum | yes | `Booked` · `Cancelled` · `Completed` · `No-show` | spec §7 |
| `client_note` | text | no | at most 500 characters; opaque — never parsed, classified, indexed, or sent to the calendar payload | spec §7 + research.md decision 4 |
| `created_at` | timestamptz | yes | — | storage mechanics |
| `cancelled_at` | timestamptz | no | set when `status` becomes `Cancelled` | implied by BR-002's boundary test |
| `cancelled_by` | enum | no | `Client` · `Specialist` | FR-006/FR-008 vs. FR-009 |

Timezone: stored in UTC, rendered in the Specialist's published timezone with
the timezone named (`design-standards.md`, Time rendering).

**Constraints**

- `UNIQUE (slot_id) WHERE status = 'Booked'` — the single-winner guarantee.
  US1's race scenario and FR-002 are this index; a violation *is* the FR-002
  rejection path (research.md decision 2).
- `CHECK (char_length(client_note) <= 500)` — spec §7.
- BR-001 (a Client holds at most 3 `Booked` Appointments) is enforced in the
  booking transaction, not as a table constraint: it counts rows across the
  Client's other Appointments, and FR-005 requires the blocked Client be shown
  their own `Booked` set — an application-level check with a `SELECT … FOR
  UPDATE` on the Client's booked rows.

### Slot

| Field | Type | Required | Validation | Source |
|---|---|---|---|---|
| `id` | uuid | yes | — | storage mechanics |
| `availability_id` | uuid → Availability | yes | — | domain model *Availability consists of Slot* |
| `specialist_id` | uuid → Specialist | yes | — | domain model |
| `start_time` | timestamptz | yes | — | spec §7 |
| `duration` | interval | yes | equals the Specialist's service duration | BR-003 |
| `published` | boolean | yes | only published Slots are offered | US1 acceptance line 1 |

**Constraints**

- `EXCLUDE USING gist (specialist_id WITH =, tstzrange(start_time, start_time +
  duration) WITH &&)` — BR-003, *"Slots never overlap for the same Specialist"*.
- A Slot whose `start_time` has passed is never offered (US1 acceptance line 2)
  — a query predicate, not a stored flag; nothing in the spec says a past Slot
  changes state.

### Hold

| Field | Type | Required | Validation | Source |
|---|---|---|---|---|
| `id` | uuid | yes | — | storage mechanics |
| `slot_id` | uuid → Slot | yes | — | domain model *Hold reserves Slot* |
| `client_id` | uuid → Client | yes | — | FR-003 (the Hold is for the selecting Client) |
| `created_at` | timestamptz | yes | — | storage mechanics |
| `expires_at` | timestamptz | yes | `created_at` + 5 minutes | spec §7; FR-003 |

**Constraints**

- `UNIQUE (slot_id) WHERE expires_at > now()` — domain model, *at most 1 Hold
  per Slot*.
- Expiry is evaluated on read (`expires_at > now()`), so an expired Hold stops
  blocking without a sweeper. FR-004's user-visible "Slot expired" message is a
  frontend timer over the same `expires_at`; the two agree because they read one
  value.

### Availability · Client · Specialist

Referenced, not defined here. `Availability` and the two actors are project-level
entities (`domain-model.md`) owned outside this feature —
`005-specialist-availability-publishing` owns the publishing side (spec §9 Out
of Scope). This feature reads them and writes neither.

## States & transitions

The spec's table (§7), unchanged:

| State | Allowed transitions | Trigger |
|---|---|---|
| `Booked` | → `Cancelled` | Client or Specialist cancels — any time before `start_time`; Slot release per BR-002 |
| `Booked` | → `Completed` | Specialist marks the Appointment delivered after `start_time` |
| `Booked` | → `No-show` | Specialist marks the Appointment; only after `start_time` |
| `Cancelled` | — (terminal) | — |
| `Completed` | — (terminal) | — |
| `No-show` | — (terminal) | — |

**Slot release is not a state of the Appointment.** BR-002 splits on the
cancellation instant: strictly more than 24h before `start_time` → the Slot
returns to published Availability (FR-006); inside 24h → the Appointment is
`Cancelled` all the same, and the Slot stays unavailable (FR-008). Both paths
land in the same terminal state, so release is a separate effect on the Slot and
must be tested as a pair either side of the boundary.

## Authorization

Every access check resolves to a policy row in
`.specify/memory/roles-permissions.md` (constitution — Authorization). This
feature exercises:

| Role | Resource | Action | Scope |
|---|---|---|---|
| Client | Appointment | create | own |
| Client | Appointment | read | own |
| Client | Appointment | cancel | own (US2 acceptance line 1) |
| Specialist | Appointment | read | own Availability |
| Specialist | Appointment | cancel | own Availability (US3 acceptance line 1) |

No permission is derived from a persona or from story narrative. NFR-002
restates the read scope as a security requirement; it is the same rows.
