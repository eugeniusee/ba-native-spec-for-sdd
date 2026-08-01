# Aspect State — Clinic Network Booking

<!--
  FIXTURE (S4). The orchestrator rules §12 exhibits, recorded as one continuous
  ledger: Band-1 entry (07-07) → the Stakeholders planning loop and clearing
  (§12.1, §12.2) → the remaining five aspects (07-08 → 07-10) → Band-1 closure,
  the arming act (§12.2) → RO-1, the §8.2 reopen, end to end (§12.3) → 004's
  Band-3 entry (07-15).

  Every literal §12 gives — the RO-1 record, the Stakeholders evidence table,
  the closure line, the deferral and its trigger — is carried verbatim. The
  five intermediate aspect gates are the fixture's own, evidenced against the
  artifacts in ../project/.

  `tests/check-ledger.py` validates this file against the §2.2/§2.3/§3.1/§4.1/
  §5.3/§8.2 machinery; `tests/check-orchestrator.sh` asserts the exhibits.
-->

## Current state
Band: 1 (closed 2026-07-10) — Bands 2/3 capable

| Aspect | State | Since | Basis |
|---|---|---|---|
| Stakeholders | first-pass-cleared | 2026-07-15 | delta evidence table, this file (RO-1) |
| Context | first-pass-cleared | 2026-07-09 | evidence table, this file |
| Value | first-pass-cleared | 2026-07-09 | evidence table, this file |
| Vision | first-pass-cleared | 2026-07-09 | evidence table, this file |
| Solution | first-pass-cleared | 2026-07-10 | evidence table, this file |
| Requirements | first-pass-cleared | 2026-07-10 | evidence table, this file |

Standing aspect waivers:  none
Open reopens:             none
Upstream flags:           none
Deferred consequences:    RO-1: a Clinic Admin role in roles-permissions.md — trigger: F2 (availability publishing) Band-3 entry

## Events

2026-07-07 · Band 1 entered · Frame · Y.K. — canvas.md present (presale), carried into the repo
  ledgers initialized: six aspects untouched; plans file empty
  substrate: canvas.md — 13 sections, P-1/P-2, O-1/O-2

2026-07-07 · T1 · Stakeholders · untouched → open · Y.K. — root; Band 1 entered 2026-07-07

2026-07-08 · T2 · Stakeholders · open → first-pass-cleared · Y.K. — AT-ST-1..3 evidence table (below)

Aspect gate review — Stakeholders — 2026-07-08
  | AT | Evidence | Met |
  |---|---|---|
  | AT-ST-1 | canvas Customers: sponsor "Olena (network COO)"; populations Clients, Specialists | ✓ |
  | AT-ST-2 | stakeholders.md: 4 entries, rights/comms filled; sponsor authority explicit | ✓ |
  | AT-ST-3 | populations ⇄ register coherent; no contradiction | ✓ |
  → CLEARED · Y.K. · 2026-07-08

2026-07-08 · T1 · Context · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-08 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-09 · T2 · Context · open → first-pass-cleared · Y.K. — AT-CX-1..3 evidence table (below)

Aspect gate review — Context — 2026-07-09
  | AT | Evidence | Met |
  |---|---|---|
  | AT-CX-1 | context.md §1–§3: eight clinics, phone-only booking today; Specialists' external calendars in §2 | ✓ |
  | AT-CX-2 | constraints.md: technical C-T1 · business C-B1 · regulatory C-R1 — each class carries ≥ 1 confirmed constraint | ✓ |
  | AT-CX-3 | canvas §10 Competition.Unlike (phone-and-paper) · §13 Context/Constraints (technical · business · regulatory) filled | ✓ |
  → CLEARED · Y.K. · 2026-07-09

2026-07-09 · T2 · Value · open → first-pass-cleared · Y.K. — AT-VA-1..2 evidence table (below)

Aspect gate review — Value — 2026-07-09
  | AT | Evidence | Met |
  |---|---|---|
  | AT-VA-1 | canvas §2 Problems: P-1 names Clients (unanswered calls) · P-2 names Specialists (late cancellations) — both resolve to register populations | ✓ |
  | AT-VA-2 | canvas §12 Objectives: O-1 → P-1, O-2 → P-1, each concrete enough to cite | ✓ |
  → CLEARED · Y.K. · 2026-07-09

2026-07-09 · T1 · Vision · untouched → open · Y.K. — prerequisites: Context first-pass-cleared, Value first-pass-cleared

2026-07-09 · T2 · Vision · open → first-pass-cleared · Y.K. — AT-VI-1..3 evidence table (below)

Aspect gate review — Vision — 2026-07-09
  | AT | Evidence | Met |
  |---|---|---|
  | AT-VI-1 | canvas §3–§5 Product.The/Is/That: all three slots filled | ✓ |
  | AT-VI-2 | canvas §11 Competition.Our Solution differentiates against the §10 Unlike entry (phone-and-paper) | ✓ |
  | AT-VI-3 | statement read once against constraints.md C-T1/C-B1/C-R1 — no contradiction; the calendars stay in place and the statement claims no replacement | ✓ |
  → CLEARED · Y.K. · 2026-07-09

2026-07-09 · T1 · Solution · untouched → open · Y.K. — prerequisites: Vision first-pass-cleared

2026-07-10 · T2 · Solution · open → first-pass-cleared · Y.K. — AT-SO-1..3 evidence table (below)

Aspect gate review — Solution — 2026-07-10
  | AT | Evidence | Met |
  |---|---|---|
  | AT-SO-1 | canvas §6 Forms · §7 Core Functions · §8 Third-Party Connections · §9 Localization — all four filled | ✓ |
  | AT-SO-2 | canvas §7: four of five function lines carry `→ O-2`; "Publish Specialist Availability" serves O-2 through the Browse/Book pair, recorded on the line | ✓ |
  | AT-SO-3 | canvas §8: Specialists' external calendars — direction `outbound`, role "appointment events mirrored to the calendar the Specialist already keeps" | ✓ |
  → CLEARED · Y.K. · 2026-07-10

2026-07-10 · T1 · Requirements · untouched → open · Y.K. — prerequisites: Solution first-pass-cleared

2026-07-10 · T2 · Requirements · open → first-pass-cleared · Y.K. — AT-RQ-1..4 evidence table (below)

Aspect gate review — Requirements — 2026-07-10
  | AT | Evidence | Met |
  |---|---|---|
  | AT-RQ-1 | glossary.md · roles-permissions.md · domain-model.md · processes.md · out-of-scope.md · constitution.md all seeded with real Band-1 content; the constitution's Governance references names roles-permissions.md AND design-standards.md, so the D-B5-3 conditionality lifts design-standards.md into the demand — it exists, seeded (budgets + UX conventions) | ✓ |
  | AT-RQ-2 | roles-permissions.md defines Client and Specialist, the two roles Band-1 artifacts reference; no personas.md exists, so the persona→role principle is stated in the constitution's Authorization row and no persona is used as a role | ✓ |
  | AT-RQ-3 | glossary.md defines Appointment · Availability · Client · Hold · Slot · Specialist — every term the canvas and Band-1 artifacts lean on; no synonym pair left unmerged | ✓ |
  | AT-RQ-4 | domain-model.md seeds the six entities the canvas §7 core functions imply, with business-level relations; processes.md seeds the booking and cancellation journeys of Client and Specialist — the two actors of ≥ 1 canvas Core Function line (D-B4-4) | ✓ |
  → CLEARED · Y.K. · 2026-07-10

2026-07-10 · Band 1 closed · Y.K.
  states: Stakeholders first-pass-cleared · Context first-pass-cleared ·
          Value first-pass-cleared · Vision first-pass-cleared ·
          Solution first-pass-cleared · Requirements first-pass-cleared
  AWs carried: none
  arming run: requested — /ba-gate-health full, trigger "Band-1 closure — the arming run";
              entry landed in .specify/gate-health.md: HEALTHY
  effects: Scope H armed — custodianship of the spec-anchored estate hands over;
           Band 2 unlocked

RO-1 · received · 2026-07-14 · source: Tier-1 ingestion E-03

2026-07-14 · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-1

RO-1 · Stakeholders — canvas.md:Core Functions "Specialists self-publish
  availability" + stakeholders.md (no admin population): call establishes
  clinic admins manage some specialists' calendars → correct the actor
  picture (register + canvas), assess role implication.
  source: Tier-1 ingestion E-03 · received 2026-07-14 · ruled Real (P-O6) 2026-07-14
  blast radius: dependents Context · Value · Vision · Solution · Requirements
                flagged `upstream reopened` (no cascade) ·
                in flight: E-03 brief cites [canvas: Customers] baseline — flagged;
                feature 004 about to enter Tier-2; no certifications exist to void ·
                ruling: continue-with-visibility — Tier-2 for 004 proceeds
  resolution: rides the approved 2026-07-14 ingestion batch — stakeholders.md gains
              the Clinic Admin population (comms via Olena); the canvas line becomes
              "availability published by Specialists or their Clinic Admins"
  deferred: a Clinic Admin role in roles-permissions.md — trigger: F2 (availability
            publishing) Band-3 entry
  status: open

2026-07-15 · T6 · Stakeholders · reopened → first-pass-cleared · Y.K. — RO-1 closure (resolved — batch 07-14 refs · canvas line · deferral F2 trigger); delta evidence table (below)

Aspect gate review — Stakeholders — 2026-07-15
  delta scope, stated before assembling: the contradiction and the fix touch the
  register's population set and the canvas actor line; AT-ST-1 is untouched by both.
  | AT | Evidence | Met |
  |---|---|---|
  | AT-ST-1 | carried — evidence untouched by RO-1 fix diff | ✓ |
  | AT-ST-2 | stakeholders.md: Clinic administrators population added, comms via Olena | ✓ |
  | AT-ST-3 | canvas ⇄ register coherent again — the canvas actor line names Specialists or their Clinic Admins, both register-resolvable | ✓ |
  dependent reckoning, one line each:
  | Dependent | Diff vs. the fix | Outcome |
  |---|---|---|
  | Solution | canvas Core Functions line touched — AT-SO-2 re-read: the function's objective link is unchanged, only its actor list grew | re-confirmed; flag drops |
  | Requirements | AT-RQ-2 re-read: the canvas names a population performing an activity, not an authorization role; no feature exercises it; RO-1's deferral covers it | re-confirmed; flag drops |
  | Context | untouched by the fix diff | flag drops |
  | Value | untouched by the fix diff | flag drops |
  | Vision | untouched by the fix diff | flag drops |
  → CLEARED · Y.K. · 2026-07-15

2026-07-15 · 004-appointment-booking entered Band 3 · Y.K. — E-03 brief §8 slicing row
  slicing row Status → Confirmed — 2026-07-15 (elicitation mechanics performed the write)
  roadmap prompt: E-03 Defined → In delivery (first feature of the epic to enter Band 3)
  advisory rendered: RO-1's deferred Clinic Admin role names F2's entry as its trigger,
                     not this one — no act due
