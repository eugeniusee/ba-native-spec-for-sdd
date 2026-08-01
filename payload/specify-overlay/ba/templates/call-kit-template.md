# Scoping Call Kit — <Epic name> (<E-nn>)
Prepared: <date> · For call: <date> · Participants: <from stakeholders.md comms lines>

<!--
  BA-Native Spec — Tier-1 epic scoping call kit. Compiled from the elicitation
  techniques document §3.2 (parts A–D). Destination:
  .specify/memory/scope/<epic>.kit.md — kept as audit trail, do-not-ask
  evidence, and tuning input (D2, locked).

  The kit is not a freestanding questionnaire: it is a pre-drafted brief plus
  the questions that would complete it. A question exists only because a
  specific brief section has a specific hole.
-->

## A. Pre-drafted brief baseline — the do-not-ask register

<!-- The scope-brief template with every derivable line filled and cited
     (`[canvas: Problems P-1]`, `[constraints.md §2]`, `[stakeholders.md]`…).
     Everything cited here is off-limits to the question set (Guard 1, the
     Citation Test) and visible to the BA as the baseline the stakeholder need
     not repeat. -->

· <derived line>                                    [<citation>]
· <derived line>                                    [<citation>]

## B. Question set

<!-- Ranking: `must-ask` (the call fails its purpose without the answer) vs
     `if-time`. must-ask ≤ 12 (D1, locked) — a scoping call is 30–60 minutes;
     twelve answered decisions beat twenty rushed ones. If-time overflows
     without limit; the BA composes the final agenda.

     Every question carries a destination tag naming a brief section. A question
     the generator cannot tag must not be emitted.

     The Destination Test (§3.3): legal iff the answer's primary destination is
     a scope-brief decision section — Essential Scope · Boundaries · Proposed
     Feature Slicing (rationale) · Assumptions & Risks · External Systems — or a
     Band-2 allocation decision. If the only home the answer could have is a
     spec.md section (an FR, an acceptance criterion, a flow step, an error row,
     a data field, a business-rule threshold, an NFR target), the question is at
     final-spec depth and forbidden in the kit.

     Language is stakeholder-facing — no framework jargon, no EARS, no artifact
     names. -->

```
Q<n> [destination: <brief section>] [must-ask | if-time]
  <question, in stakeholder language>
  Why it matters: <one line — what decision the answer changes>
```

## C. Risks & assumptions to check

<!-- Assumptions the context implies but no stakeholder has confirmed, each
     phrased as a checkable statement. Plus risk probes: areas where this epic's
     domain typically hides scope — payment edges, permission edges, integration
     failure ownership, data migration. -->

```
A<n> — <assumption> · source: <where the context implies it> ·
       impact if wrong: <which Band-2 decision changes>
```

## D. Sibling boundary checks

<!-- Where this epic's edges touch other roadmap epics or existing briefs, one
     check per touchpoint. These feed the brief's Boundaries section and prevent
     silent scope overlap across epics. -->

- The roadmap holds <X> in epic <Y> — confirm nothing <X>-shaped belongs here.

---

## Composed agenda (BA)

<!-- The BA drops, reorders, adds, and rewrites. Everything above is advisory
     (Q2). A dropped question whose answer already existed is a false-ask —
     log it to .specify/elicitation-tuning.md with the source line. -->
