# Implementation Plan: Appointment Booking

**Branch**: `004-appointment-booking` | **Date**: 2026-08-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/004-appointment-booking/spec.md`

## Summary

Clients browse a Specialist's published Availability and book a Slot without
phoning the clinic; both sides can cancel. The booking path is a five-minute
exclusive Hold followed by confirmation, so the race for the last Slot resolves
deterministically (US1) — that single-winner guarantee is the primary technical
requirement of the feature. Cancellation is asymmetric by business rule: outside
24h the Slot returns to published Availability, inside 24h it does not (BR-002).
Specialists' external calendars stay in place and receive outbound events only;
the behavior of a confirmed Appointment during a sync outage is a consciously
deferred unknown carried in the spec under waiver W-004-01.

## Technical Context

**Language/Version**: NEEDS CLARIFICATION — no stack is fixed upstream. The
project has no existing booking software to extend (`context.md`, Existing
systems: *"No booking software exists today — nothing digital to migrate on the
booking side"*), so this is a greenfield choice for the operator, not a fact the
spec withheld. Resolved as a decision in [research.md](./research.md).

**Primary Dependencies**: NEEDS CLARIFICATION — follows from the language
decision. See research.md.

**Storage**: Relational, transactional. Not a free choice: FR-001/FR-002/FR-003
require that two concurrent confirmations on one Slot produce exactly one
Appointment, and BR-003 requires non-overlapping Slots per Specialist. Both are
uniqueness constraints over rows. Engine choice in research.md.

**Testing**: NEEDS CLARIFICATION — follows from the language decision. The
required *coverage* is fixed by the spec regardless of framework: the E1–E3
error table, the US1 race scenario, and each BR.

**Target Platform**: Web, phone-first Client surfaces (`design-standards.md`,
UX conventions: *"Client-facing pages are designed phone-first; desktop is
secondary"*). Specialist surfaces are secondary in this feature — only the
cancellation path (US3) and the notification receipt (FR-007) are in scope.

**Project Type**: Web application — a Client-facing frontend plus a backend that
owns the Hold/booking transaction and the outbound calendar events.

**Performance Goals**: Availability search ≤ 2s for a Specialist with up to
5,000 published Slots (NFR-001). Specialist notification of a confirmed
Appointment within 60s under normal load (NFR-003).

**Constraints**: Hold lifetime exactly five minutes (FR-003/FR-004) · a Client
may hold at most 3 Appointments in status "Booked" (BR-001) · free-cancellation
boundary strictly > 24h before `start_time` (BR-002) · times rendered in the
Specialist's published timezone, timezone named (`design-standards.md`) ·
availability 99.5% monthly, WCAG 2.2 AA at launch with keyboard-only completion
of every primary journey (`design-standards.md` global budgets) · no
medical-record data anywhere in the system (constitution, Data boundary).

**Scale/Scope**: 200 Specialists and 10,000 Appointments per month at launch
(`design-standards.md`, Scale budget). Feature scope: 3 user stories, 9
functional requirements, 3 business rules, 2 entities to persist plus the Hold.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Gates derived from `.specify/memory/constitution.md`:

| Principle | Gate for this feature | Pre-Phase-0 | Post-Phase-1 |
|---|---|---|---|
| **Authorization** — permissions derive from `roles-permissions.md` policy rows only, never inferred from personas or narrative | Every authorization check in the design resolves to a policy row. The tuples this feature exercises: (Client × Appointment × create/read/cancel-own), (Specialist × Availability × publish), (Specialist × Appointment × read/cancel-own). The spec's US2/US3 acceptance lines state ownership scoping explicitly, and the gate's CC-XA-01 sign-off confirmed all seven exercised tuples matched explicit rows at run 3 | PASS | PASS — `contracts/` derives every check from the policy table; no endpoint infers a permission from a persona or from a story's narrative |
| **Spec-first iteration** — requirements defects are fixed in the spec and re-run downstream, never hand-patched in code | The plan introduces no requirement of its own. Anything this planning pass found missing goes back as a spec fix + re-gate, not as a design decision | PASS — nothing missing was found; see "What this plan did not need to ask for" | PASS |
| **Data boundary** — no medical-record data stored or processed; Client personal data stays inside the binding regime (`constraints.md` §3) | The persisted field set is checked against this. `Appointment.client_note` (free text, at most 500 chars, visible to the Specialist) is the only field that could carry clinical content, and it is Client-authored | PASS | PASS with a design obligation recorded: `client_note` is stored as opaque Client text — never parsed, classified, indexed for search, or forwarded in the external-calendar payload. See research.md decision 4 |

**Violations requiring justification:** none. Complexity Tracking below is empty.

## Project Structure

### Documentation (this feature)

```text
specs/004-appointment-booking/
├── spec.md              # certified — gate run 3, effective PASS 2026-07-18
├── traceability.md      # generated by the gate (sk_idgraph), run 3
├── gate-report.md       # append-only, runs 2-3
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit-tasks - NOT created here)
```

### Source Code (repository root)

```text
backend/
├── src/
│   ├── models/          # Appointment · Slot · Availability · Hold
│   ├── services/        # booking (Hold -> confirm) · cancellation ·
│   │                    # notification · calendar-sync (outbound)
│   └── api/             # availability · bookings · cancellations
└── tests/
    ├── contract/        # one suite per contracts/ file
    ├── integration/     # US1 race · BR-002 boundary pair · E1-E3
    └── unit/            # BR-001 cap · BR-003 non-overlap · Hold expiry

frontend/
├── src/
│   ├── components/      # availability calendar · slot picker · cancel confirm
│   ├── pages/           # specialist profile · my appointments
│   └── services/        # API client
└── tests/
```

**Structure Decision**: Web application (frontend + backend). The spec's
surfaces are Client-facing and phone-first, while the single-winner guarantee
(US1), the Hold lifecycle (FR-003/FR-004), the BR-001 cap and the outbound
calendar events all have to be enforced server-side — a Slot cannot be held
honestly by a browser. The split follows the spec's own boundary; it is not an
added layer.

## Complexity Tracking

> Fill ONLY if Constitution Check has violations that must be justified.

None. The Constitution Check passed at both gates with no violation.

## What this plan did not need to ask for

Recorded because it is the property the upstream gate exists to produce, and it
is cheap to state and expensive to assume:

- **No spec edit was requested.** Everything needed to plan — the race
  resolution, the Hold lifetime, the cancellation boundary, the notification
  target, the error paths, the persisted fields and their validation, the state
  machine — was already in the spec at the depth planning needs.
- **No term, role, or entity was invented.** Every name used here resolves to
  `glossary.md`, `roles-permissions.md` or `domain-model.md` through the spec's
  References section.
- **One unknown was read, and it was labelled.** The `[NEEDS CLARIFICATION]`
  marker in §8 Integration Touchpoints — the behavior of a confirmed Appointment
  while calendar sync is unavailable — is a consciously accepted gap carried
  under waiver **W-004-01** (brief E-03 OQ-2; provider contract unsigned). It is
  designed *around*, not guessed at: research.md decision 3 fences it so the
  booking path never depends on the answer, and the open question stays open.
- **The remaining unknowns are the plan's own, not the spec's.** Language,
  framework and test runner are technology decisions no upstream artifact fixes
  and none should — the writing standard keeps feature specs technology-free by
  design. They are marked in Technical Context above and decided in Phase 0.
