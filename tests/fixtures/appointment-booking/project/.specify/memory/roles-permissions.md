# Roles & Permissions — Clinic Network Booking
Authorization principle: stated in constitution.md (plan §4.14) —
this file is its enforcement surface, never its statement.

<!--
  FIXTURE. T-12's output, in the shape catalogue-b4 T-12 §5 pins: Roles table ·
  Policy table, one explicit role × entity × action tuple per row with its
  rule/scope qualifier (D-B4-2 — no wildcard cell, no inheritance at v1), entity
  cells verbatim from domain-model.md (CC-H-05 applied at authoring time), zero
  persona names anywhere (TC-3 = CC-XA-02's screened set).

  Seeded 2026-07-10 with six rows. The seventh — Specialist × Appointment ×
  cancel — was deliberately absent at seed: no Band-1 line exercised it. It
  entered 2026-07-17 exactly as contract §7's gate run 2 records: CC-XA-01 FAIL
  naming the tuple → the row routed as a governance change. The seed state is
  ../../band1/first-pass/roles-permissions.md; the seed's silence is the
  mechanism working, not a gap.

  Two things this table deliberately does not carry: Olena derives no role
  (sponsor individual, referenced as no actor — populations and individuals are
  register ground, roles are exercised ground), and the RO-1 Clinic Admin role
  stays deferred against its F2 trigger.
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
| Specialist | Appointment | cancel | own only; the Client is notified | gate run 2 CC-XA-01 → governance change approved 2026-07-17 |
