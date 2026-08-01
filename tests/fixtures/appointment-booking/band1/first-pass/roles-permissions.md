# Roles & Permissions — Clinic Network Booking
Authorization principle: stated in constitution.md (plan §4.14) —
this file is its enforcement surface, never its statement.

<!--
  FIXTURE (S7). T-12's output at the Requirements seed, 2026-07-10 — the state
  the AT-RQ-2 evidence row was written against.

  Six policy rows. Specialist × Appointment × cancel is deliberately absent: no
  Band-1 line exercises it, and the seed covers Band-1-evident tuples only.
  It enters 2026-07-17 through the gate — CC-XA-01 FAIL naming the tuple, then
  a routed governance change — and the mature file at
  ../../project/.specify/memory/roles-permissions.md carries it as row seven.

  Read the two files as a pair: every seed row survives there unchanged, in
  place, with its wording and its source; the only difference is the row the
  gate added. check-techniques3.sh asserts exactly that.
-->

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
