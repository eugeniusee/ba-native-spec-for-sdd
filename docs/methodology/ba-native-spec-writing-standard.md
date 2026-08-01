# Geniusee Spec Writing Standard
### BA-Native Spec · house rulebook · v0.3
**v0.3 change record:** erratum only — §5 US2 cancellation AC aligned with authoritative BR-002 (was "rejected inside 24h" → now "allowed, slot retained"); §9 states-table trigger note clarified (BR-002 governs slot release, not transition permission). Sweep: §4 EARS example already BR-002-consistent; §§6, 10, 14 contain no cancellation-rule statements.

**Who this is for:** every BA writing specifications that an AI coding agent will build from.
**Why it exists:** the agent reads exactly what you write. It will not ask a colleague, it will not politely infer — it fills every gap with a confident guess. This standard exists so there are no gaps worth guessing about.

---

## 1. Golden rules

1. **Write the WHAT, never the HOW.** No frameworks, no databases, no endpoints, no UI layouts. The technical solution belongs to `/plan`, not the spec. If you catch yourself naming a technology, stop.
2. **One requirement, one statement, one ID.** Never chain behaviors with "and/or". If a sentence contains two SHALLs' worth of behavior, split it.
3. **Every domain term comes from the glossary.** If the term isn't in `glossary.md`, add it there first — then use it. Never introduce a synonym ("booking" vs "appointment" — pick one, glossary decides).
4. **Structured data goes in tables, never prose.** Permissions, fields, states, integrations — tables. Prose invites the agent to guess; tables don't.
5. **Reference, never restate.** Roles, permissions, domain entities, global standards are defined once in governance/context files. A spec that redefines a role fails the gate.
6. **If it can't be tested, it isn't a requirement.** Every statement must be verifiable by a person or a machine looking at the built system.
7. **Mark gaps, don't hide them.** Unknowns get an explicit `[NEEDS CLARIFICATION: question]` marker. A visible gap is workable; an invisible one becomes wrong code.
8. **No stubs.** A section heading with placeholder fluff under it fails the gate. Either fill it with real content or mark it `N/A — <reason>`.

---

## 2. The spec skeleton

Every `spec.md` contains these sections, in this order, with these exact headings (agents parse structure — do not rename or reorder):

1. **Overview & Value** — why this feature exists; 2–4 sentences.
2. **User Stories** — the skeleton (P1–P3), each with acceptance criteria.
3. **Functional Requirements** — EARS statements, FR-IDs.
4. **Flows, States & Errors** — main flow, alternates, every error path.
5. **Non-Functional Requirements** — measurable, feature-specific only.
6. **Business Rules** — BR-IDs.
7. **Data Requirements** — table.
8. **Integration Touchpoints** — table.
9. **Out of Scope** — what this feature deliberately does NOT do, and where each exclusion lives instead.
10. **References** — links to `roles-permissions.md`, `glossary.md`, `domain-model.md`, parent epic scope brief.

A running example is used throughout this standard: **appointment booking** — a Client books an appointment with a Specialist.

---

## 3. User Stories

**Format:**

```
US<N> (P<1|2|3>) — As a <role from roles-permissions.md>,
I want <capability>, so that <value>.
```

**Rules:**
- The role must exist in `roles-permissions.md`. "As a user" is banned — *which* role?
- **P1** = the feature fails without it. **P2** = needed, not day-one. **P3** = nice-to-have. If everything is P1, nothing is.
- Every story carries its own acceptance criteria (§5), directly beneath it.
- Story IDs (US1, US2…) are stable — downstream tasks tag back to them.

**Good:**
> US1 (P1) — As a **Client**, I want to book an available time slot with a chosen Specialist, so that I secure the appointment without calling.

**Bad:**
> As a user, I want to easily manage my bookings.
> *(Which role? "Easily" is untestable. "Manage" is three features hiding in one word.)*

---

## 4. Functional Requirements — EARS grammar

Every functional requirement is written in one of the five EARS patterns. Keywords in CAPS. One SHALL per requirement. The system response must be externally observable.

| Pattern | Template | Use when |
|---|---|---|
| **Ubiquitous** | THE SYSTEM SHALL `<response>` | Always true, no trigger |
| **Event-driven** | WHEN `<trigger>`, THE SYSTEM SHALL `<response>` | Something happens |
| **State-driven** | WHILE `<state>`, THE SYSTEM SHALL `<response>` | True during a state |
| **Unwanted behavior** | IF `<condition>`, THEN THE SYSTEM SHALL `<response>` | Errors, abuse, failure |
| **Optional feature** | WHERE `<feature included>`, THE SYSTEM SHALL `<response>` | Configurable capability |

Patterns combine when needed: `WHILE <state>, WHEN <trigger>, THE SYSTEM SHALL <response>`.

**Format:**

```
FR-001 (US1) — WHEN a Client selects an available slot and confirms,
THE SYSTEM SHALL create an Appointment in status "Booked" and display
the confirmation to the Client.
```

**Rules:**
- Every FR links to at least one story: `FR-00N (US<n>)`. An FR with no story is scope creep; a story with no FRs is unbuilt.
- Numbering is stable and never reused after deletion.
- Name the real actor and object — "THE SYSTEM SHALL update the record" fails (*which* record, visible how?).

**Good / bad pairs:**

| ✅ | ❌ | Why the bad one fails |
|---|---|---|
| WHEN a Client cancels an Appointment more than 24 hours before its start time, THE SYSTEM SHALL set the Appointment status to "Cancelled" and release the slot. | The system should handle cancellations appropriately. | "Should," "handle," "appropriately" — three guesses invited. |
| IF a Client attempts to book a slot that was taken after page load, THEN THE SYSTEM SHALL reject the booking and display the current availability for that Specialist. | Double bookings must not happen. | States a wish, not a system behavior. What does the Client see? |
| WHILE a Specialist's calendar sync is unavailable, THE SYSTEM SHALL queue booking confirmations and mark them "Pending sync". | The system supports calendar integration. | "Supports" specifies nothing buildable. |

**Banned words** (each one is a hidden guess): *fast, quickly, easy, simple, user-friendly, intuitive, appropriate, adequate, sufficient, efficient, flexible, robust, seamless, some, several, many, minimal, improve, better, handle, support, manage, process (without an object), etc., and/or, as needed, if necessary, TBD.*
If you need one of these, replace it with a number, a named behavior, or a `[NEEDS CLARIFICATION]`.

---

## 5. Acceptance Criteria — tiered

Acceptance lives under each story. **One slot, two forms — pick by complexity:**

**Decision rule:**
- **Checklist line** → simple rule, validation, permission, field constraint. One checkable assertion.
- **Gherkin scenario** → multi-step behavior, branching, edge case — anywhere a *worked example with concrete data* removes ambiguity the FR alone leaves open.

**Anti-duplication rule:** a Gherkin scenario must add concrete data and a concrete path. If it reads like the EARS rule reworded — delete it and write a checklist line. Never re-narrate the rule.

**Checklist form (simple):**

```
US2 acceptance:
- [ ] A Client cannot book a slot in the past.
- [ ] A Client sees only slots marked available by the Specialist.
- [ ] Cancellation inside 24h of start_time keeps the slot unavailable for rebooking (BR-002, §8).
```

**Gherkin form (non-trivial — note the concrete data):**

```gherkin
Scenario: Two Clients race for the last slot
  Given Specialist "Dr. Ivanova" has one available slot at 2026-07-20 10:00
  And Client A and Client B both have the booking page open
  When Client A confirms the slot at 10:00
  And Client B confirms the same slot 3 seconds later
  Then Client A's Appointment is created with status "Booked"
  And Client B's booking is rejected
  And Client B sees Dr. Ivanova's updated availability without the 10:00 slot
```

**Bad Gherkin (re-narration — would fail review):**

```gherkin
Given a Client selects an available slot
When the Client confirms
Then the appointment is booked      ← this is FR-001 reworded; zero new information
```

---

## 6. Flows, States & Errors

Where agents improvise most. Be explicit about the unhappy paths.

**Main flow** — numbered, actor → action → observable result:

```
1. Client opens a Specialist's profile → sees available slots (next 30 days).
2. Client selects a slot → slot is held for this Client for 5 minutes.
3. Client confirms → Appointment "Booked"; confirmation shown; Specialist notified.
```

**Alternates & errors** — every error path names its trigger, the system behavior, and what the user sees:

| # | Trigger | System behavior | User-visible outcome |
|---|---|---|---|
| E1 | Hold expires (5 min) before confirm | Release slot | "Slot expired" + refreshed availability |
| E2 | Slot taken during page view | Reject booking (FR-00x) | Current availability for that Specialist |
| E3 | Client at BR-001 limit (§8) | Block booking | Limit explained + list of own Booked appointments |

A flow with only the happy path fails the gate.

---

## 7. Non-Functional Requirements — measurable only

Pattern: **metric + target + condition.** Global NFR budgets live in governance; the spec adds only feature-specific ones.

| ✅ | ❌ |
|---|---|
| NFR-001 — Availability search returns results within 2 seconds for a Specialist with up to 5,000 published slots. | The booking page must be fast. |
| NFR-002 — Slot hold consistency: after a successful confirm, no other Client can book the same slot (zero double-bookings). | The system must be reliable. |

Prompt yourself per category and either write a measurable NFR or `N/A — <reason>`: performance · security/privacy · availability · accessibility · localization · scale.

---

## 8. Business Rules

The "invisible rules" — policies, calculations, invariants. One per line, testable, with the formula when there is one.

```
BR-001 — A Client may hold at most 3 Appointments in status "Booked"
         at the same time.
BR-002 — Free cancellation window: strictly more than 24 hours before
         start_time. Inside 24h, cancellation is allowed but the slot
         is NOT released for rebooking.
BR-003 — Slot duration = Specialist's service duration; slots never overlap
         for the same Specialist.
```

Rules that apply across features (e.g., global refund policy) belong in governance — reference them, don't restate.

---

## 9. Data Requirements

Fields, types, validation, lifecycle — always tables. Entities must exist in `domain-model.md`; the spec adds *this feature's* fields and rules only.

**Fields:**

| Entity | Field | Type | Required | Validation | Notes |
|---|---|---|---|---|---|
| Appointment | start_time | datetime | yes | future only; within Specialist's published availability | timezone: Specialist's |
| Appointment | status | enum | yes | Booked / Cancelled / Completed / No-show | see states below |
| Appointment | client_note | text | no | max 500 chars | visible to Specialist |

**States & transitions (when the entity has a lifecycle):**

| State | Allowed transitions | Trigger |
|---|---|---|
| Booked | → Cancelled | Client or Specialist cancels — any time before start_time; slot release per BR-002 |
| Booked | → Completed | Specialist marks done after start_time |
| Booked | → No-show | Specialist marks; only after start_time |
| Cancelled | — (terminal) | — |

If the agent has to invent a field, a validation, or a transition — this section was incomplete.

---

## 10. Integration Touchpoints

| System | Direction | What is exchanged | Constraint |
|---|---|---|---|
| Specialist's external calendar | outbound | Appointment created/cancelled events | sync failure → see WHILE FR + E-path; never blocks booking |

Name every external system this feature touches. The contract details land in `/plan`'s `contracts/` — the spec names the touchpoint, direction, payload meaning, and the failure expectation.

---

## 11. Out of Scope

The fence at the end of the spec. Agents "helpfully" build adjacent functionality — this section tells them an absence is deliberate, not forgotten.

**Rule:** every exclusion states *where it lives instead* — a later phase, another epic/feature, or explicitly "not planned".

```
## Out of Scope
- Payments — Phase 2, epic "Online payment"
- Recurring appointments — not planned
- Specialist availability editing — separate feature (same epic)
```

Feature-level exclusions live here; the product-level scope boundary lives in `.specify/memory/` (the global Out-of-scope artifact). Don't duplicate the global list — state only what someone could plausibly expect *this feature* to include.

---

## 12. References (never restatements)

End every spec with:

```
References:
- Roles & permissions: .specify/memory/roles-permissions.md   (roles used: Client, Specialist)
- Glossary: .specify/memory/glossary.md                       (terms: Appointment, Slot, Hold)
- Domain model: .specify/memory/domain-model.md               (entities: Appointment, Slot)
- Parent epic scope brief: .specify/memory/scope/<epic>.md
```

The spec *lists which roles it uses* and *which actions they perform in this feature* — but the permission definitions live in one place only. If this feature needs a permission that doesn't exist yet, update `roles-permissions.md` first (that's a governance change), then reference it.

---

## 13. IDs & traceability

| Artifact | ID scheme | Links to |
|---|---|---|
| User story | US1, US2… | ← epic (scope brief) |
| Functional requirement | FR-001… | → US<n> (mandatory) |
| Business rule | BR-001… | referenced by FRs/AC where relevant |
| NFR | NFR-001… | feature-level |
| Acceptance | lives under its story | → US<n> implicitly |
| Tasks (downstream) | generated by /tasks | tagged [US1], [US2] |

The chain the gate will verify: **every story has FRs and acceptance; every FR has a story; no orphans in either direction.**

---

## 14. Putting it together (micro-example)

```markdown
## Overview & Value
Clients currently book by phone; ~30% of calls go unanswered (Objectives:
reduce lost bookings). This feature lets a Client book a Specialist's
published slot directly.

## User Stories
US1 (P1) — As a Client, I want to book an available slot with a chosen
Specialist, so that I secure the appointment without calling.
Acceptance:
- [ ] Only slots published by the Specialist are offered.
- [ ] A slot in the past is never offered.
Scenario: Two Clients race for the last slot
  Given ... (concrete data, as in §5)

## Functional Requirements
FR-001 (US1) — WHEN a Client selects an available slot and confirms,
THE SYSTEM SHALL create an Appointment in status "Booked" and display
the confirmation to the Client.
FR-002 (US1) — IF a Client attempts to book a slot that is no longer
available, THEN THE SYSTEM SHALL reject the booking and display current
availability for that Specialist.

*(Flows/errors, NFRs, business rules, data, integrations follow as §6–§10.)*

## Out of Scope
- Payments — Phase 2, epic "Online payment"
- Recurring appointments — not planned
- Specialist availability editing — separate feature (same epic)

## References
- Roles: .specify/memory/roles-permissions.md (Client, Specialist) · Glossary · Domain model · Epic scope brief
```

---

## 15. Self-check before the gate

Before submitting a spec, verify:

- [ ] Zero technology names, endpoints, or UI layout decisions
- [ ] Every FR: one SHALL, EARS pattern, linked story, observable response
- [ ] Zero banned words (or each replaced / marked `[NEEDS CLARIFICATION]`)
- [ ] Every story has acceptance; every Gherkin scenario has concrete data and adds a path the FR doesn't spell out
- [ ] All structured data in tables; every entity exists in the domain model
- [ ] Every error path has trigger + behavior + user-visible outcome
- [ ] Every NFR has metric + target + condition (or explicit N/A + reason)
- [ ] All roles/terms referenced, none redefined
- [ ] Out of Scope: every exclusion names where it lives instead
- [ ] No stub sections; unknowns carry `[NEEDS CLARIFICATION]`

The formal completeness contract (document 2) runs on top of this — this self-check is the writer's half of that gate.
