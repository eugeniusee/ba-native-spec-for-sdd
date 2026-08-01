# Constraints & Limitations — Clinic Network Booking

<!--
  FIXTURE (S6). T-06's output at the Context aspect, 2026-07-09 — BEFORE the
  2026-07-14 call.

  One thing separates this file from ../../project/.specify/memory/constraints.md:
  the technical row's Status. Here it is `Assumed` — the presale material implies
  the calendars stay in use and no stakeholder has confirmed it. There it is
  `Confirmed`, flipped in place by the approved ingestion batch of 07-14, the row
  keeping its class, its wording and its position.

  That round trip is why `Assumed` is a status and not a marker: the Tier-1 kit
  lifts this exact row into its assumption register as A1, the call checks it,
  and the answer comes back as a Status flip rather than as a new row.

  The Business row pre-dates this run — it arrived from the routed sponsor call
  of 07-08 while Context was still `untouched`. Arrival is never gated, so the
  sweep found it here and the business class was never probed.
-->

## 1. Technical

| Constraint | Status | Source |
|---|---|---|
| Specialists' existing calendars are retained, not replaced | Assumed | presale brief |

## 2. Business

| Constraint | Status | Source |
|---|---|---|
| Launch is tied to the autumn season; the MVP must be live this year | Confirmed | sponsor call — routed 2026-07-08 |

## 3. Regulatory

| Constraint | Status | Source |
|---|---|---|
| The product stores and processes no medical-record data; Client personal data stays inside the binding national personal-data regime | Confirmed | Olena, 2026-07-09 |
