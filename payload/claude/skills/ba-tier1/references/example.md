# Tier 1 — worked kit and worked brief

The appointment-booking world. Epic **E-03 "Appointment Booking"** — roadmap
description: *"Clients book specialists' published slots online instead of
calling. Covers slot browsing, booking, cancellation, and specialist
notifications."* Phase: MVP.

## The kit (`E-03.kit.md`, excerpt)

```
PRE-DRAFTED BASELINE (do not re-ask — cited):
· Actors: Client, Specialist                      [canvas: Customers]
· Problem: ~30% of booking calls unanswered;
  lost bookings                                    [canvas: Problems P-1]
· Objective: reduce lost bookings                  [canvas: Objectives O-2]
· Calendar integration expected                    [canvas: Third-Party Connections]

QUESTION SET (must-ask 6 of 10 shown):
Q1 [destination: Essential Scope] [must-ask]
   Walk me through how a booking happens today, end to end — where does
   it break?
   Why it matters: confirms the value line and surfaces the real capability list.
Q2 [destination: Essential Scope / Boundaries] [must-ask]
   Beyond booking itself, what must a Client be able to do with an
   existing appointment at launch — cancel, reschedule, both?
   Why it matters: sets launch scope vs deferred.
Q3 [destination: Boundaries] [must-ask]
   The roadmap holds payments in "Online Payment" (E-07, Phase 2) —
   confirm nothing payment-shaped belongs in booking at launch.
   Why it matters: sibling boundary; silent overlap is the expensive kind.
Q4 [destination: External Systems] [must-ask]
   Do specialists keep their current calendars as the source of truth,
   or does this system become it?
   Why it matters: integration direction, biggest technical risk, slicing input.
Q5 [destination: Assumptions & Risks] [must-ask]
   Order of magnitude — how many specialists and monthly bookings
   should launch carry?
   Why it matters: allocation and walking-skeleton sizing.
Q6 [destination: Slicing rationale] [must-ask]
   Who publishes specialist availability today, and does that need to
   change with this epic?
   Why it matters: likely a second feature with a different primary role.

RISKS & ASSUMPTIONS TO CHECK:
A1 — Existing calendars must be kept, not replaced · source: canvas
     Third-Party Connections · impact if wrong: integration scope and
     slicing change materially.
A2 — Specialists self-publish availability · source: implied by canvas
     Core Functions · impact if wrong: an admin role enters scope
     (roles-permissions change).
```

### What the kit is showing

- **Four cited facts became a do-not-ask register, not four questions.** The
  actors, the problem, the objective and the integration expectation were all
  citable. Guard 1 turned each into a line the stakeholder does not have to
  repeat — and into evidence, if a question later re-asks one, that the
  generation was wrong.
- **Every question names its section before it names its subject.** Q6's tag
  is *Slicing rationale*: the answer is expected to reveal a second primary role,
  and that is a cut in §8, not a capability in §2.
- **Q3 is a sibling boundary check, phrased as a confirmation.** It exists
  because the roadmap holds payments elsewhere. It is the shape an honest
  T-17 — Epics decomposition
  open edge takes once it reaches the right room.
- **A2's impact line names a governance consequence.** *An admin role enters
  scope* — that is why the assumption is worth a minute of a call: being wrong
  changes `roles-permissions.md`, not a sentence in the brief.
- **The composed agenda is the BA's.** In the real run the BA reordered to
  Q1 → Q2 → Q6 → Q4 → Q3 → Q5 and dropped one question the client had already
  answered by email — a false-ask, logged with its source line.

## The brief (`.specify/memory/scope/E-03.md`, excerpts)

```markdown
# Scope Brief — Appointment Booking (E-03)
Status: Scoped
Call log: 2026-07-14 · Olena (clinic network COO, sponsor) + 2 specialists

## 2. Essential Scope
- Browse a Specialist's published availability
- Book an available slot
- Cancel own appointment
- Notify the Specialist of bookings and cancellations
- Publish specialist availability (→ F2, see §8)

## 3. Boundaries
### Excluded — not this epic
- Payments — epic Online Payment (E-07), Phase 2 (confirmed, Q3)
- Recurring appointments — not planned (confirmed on call)
### Deferred — this epic, later
- Reschedule-in-place — Phase 2; cancel + rebook is acceptable at launch
  (Olena, on call)

## 5. Assumptions & Risks
| ID | A/R | Statement | Source | Impact if wrong | Status |
|---|---|---|---|---|---|
| A1 | A | Existing calendars kept, not replaced | canvas → confirmed on call | integration scope, slicing | Confirmed → routed to constraints.md |
| R1 | R | Calendar provider contract not signed | call (Olena) | sync spec blocked at Tier 2 | Open — owner: Olena |

## 6. Open Questions
| ID | Question | Touches | Status | Answer / reason |
|---|---|---|---|---|
| OQ-1 | Cap on simultaneous booked appointments per Client? | F1 | Answered — 2026-07-16 → spec 004 BR-001 (cap: 3) | resolved at Tier 2 |
| OQ-2 | Which calendar providers must sync at launch? | F1 | Open | blocked on R1 |

## 7. Captured Detail (for Tier 2)
- Cancellation policy: "Late cancellations cost us money — people cancel
  an hour before." (Specialist, verbatim) — no concrete cutoff given.

## 8. Proposed Feature Slicing
| Feature | Covers | Rationale | Status |
|---|---|---|---|
| F1 004-appointment-booking | browse · book · cancel · notify | Client-side journey; independently deliverable | Confirmed — 2026-07-15 |
| F2 005-specialist-availability-publishing | publish availability | distinct primary role (Specialist); distinct journey | Proposed |

## 9. Routing Log
| Finding | Destination | Date |
|---|---|---|
| A1 confirmed → constraint "existing calendars retained" | constraints.md | 2026-07-14 |
| Term "No-show" | glossary.md | 2026-07-14 |
| Clinic admins currently manage some calendars (contradicts canvas self-manage picture) | reopen signal → Stakeholders aspect | 2026-07-14 |
```

### What the brief is showing

- **§2 is five capability lines and not one story.** *Book an available slot* —
  verb, object, and nothing about what the Client sees. The stories that cover
  these lines are drafted a band later, by an author who has the whole context
  stack loaded and a gate waiting.
- **The Captured Detail quote has no cutoff in it, and the brief does not supply
  one.** The specialist said late cancellations cost money; nobody said 24 hours.
  Writing a plausible number here would have been the confident guess this
  framework exists to kill — and Tier 2's first question is exactly that number,
  legally, because the marker is honest.
- **OQ-2 is still `Open` in a brief whose status is `Scoped`.** A scoped brief is
  not a brief with no unknowns; it is a brief whose unknowns are visible with
  status. OQ-2 rides into the spec as a named location and meets its conscious
  acceptance at the gate, as a waiver the BA signs.
- **The third routing row is not a routing at all — it is a reopen.** The call
  contradicted a gated canvas picture. It appears in the log because the log is
  the brief's honesty device, and it went to the reopen machinery because
  contradictions are ruled, never merged.
- **F1 reads `Confirmed — 2026-07-15`; ingestion wrote `Proposed`.** The
  confirmation is Band-3 entry's act, one day later, performed by the BA at
  `/ba-enter-feature`. Ingestion never writes it.
