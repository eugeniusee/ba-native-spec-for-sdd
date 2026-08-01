# The Destination Test — Tier-1 depth calibration

Guard 2, at Tier 1, **is** this rule. Read it before generating a question set.

## The rule

> A question is a **legal scoping question** if and only if its expected
> answer's primary destination is a **scope-brief decision section** — Essential
> Scope · Boundaries · Proposed Feature Slicing (rationale) · Assumptions &
> Risks · External Systems — or a Band-2 decision (allocation).
>
> If the only home the answer could have is a **spec.md section** — an FR, an
> acceptance criterion, a flow step, an error row, a data field, a business-rule
> threshold, an NFR target — the question is at **final-spec depth and forbidden
> in the kit**.

**The intuition:** scoping decides *whether and where* something is built — in
this epic or another, this phase or later, this feature slice or that, at
acceptable risk or not. Spec decides *exactly how it behaves*. A question whose
answer cannot change a whether/where decision has no business in a scoping call.

## The five pairs

Deliberately the **same topic at two depths** — the line is depth, not subject.

| ✅ Legal scoping question | ❌ Forbidden final-spec question | Why the ❌ fails |
|---|---|---|
| Beyond booking itself, what must a Client be able to do with an existing appointment at launch — cancel, reschedule, both? | What is the exact cutoff for free cancellation, and is the slot released after a late cancellation? | The ✅ answer sets Essential Scope / Deferred. The ❌ answer can only land as a business rule and its acceptance criterion — spec territory. |
| Do specialists keep their current calendars as the source of truth, or does this system become it? | What happens if the calendar sync is down at the moment a Client confirms a booking? | The ✅ answer names an External System and a constraint that shapes slicing and risk. The ❌ answer is an error path — a WHILE/IF requirement plus an E-row. |
| Is taking payment part of booking at launch, or handled outside this epic? | Which payment providers and currencies must be supported? | The ✅ answer draws a Boundary and checks the sibling epic. The ❌ answer fills an Integration Touchpoints row of a spec in *another epic*. |
| Order of magnitude — how many specialists and monthly bookings should launch carry? | What is the response-time target for slot search under peak load? | The ✅ answer is a sizing assumption that drives allocation and walking-skeleton logic. The ❌ answer is an NFR: metric + target + condition. |
| Who publishes specialist availability today, and does that need to change with this epic? | What fields does a specialist fill in when publishing a slot? | The ✅ answer reveals a role and probably a second feature — Slicing rationale. The ❌ answer is a Data Requirements table. |

## The pattern in the five ❌s

Each one is a real question that someone will genuinely need answered — later,
by Tier 2, from a person who by then has a draft in front of them naming exactly
what is missing. Asking it now costs the same stakeholder minute and buys a fact
with nowhere to live: **the answer's home is a section of a document that does
not exist yet.**

That is why the test is a destination test and not a difficulty test. A hard
scoping question is legal. An easy spec question is not.

## Two things the rule does not do

**It does not constrain the call.** The BA may deliberately ask a spec-depth
question when the room demands it — the person who knows the cancellation policy
is in the chair today and will not be next week. The answer parks in **Captured
Detail** and Tier 2 treats it as answered. The rule constrains what the *kit*
generates.

**It does not license silence about what you cannot ask.** A boundary you cannot
resolve at scoping grade is carried as an Open Question or as honest wording in
the brief — never as a confident guess, and never as an omission.
