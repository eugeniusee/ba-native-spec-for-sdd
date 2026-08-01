# Constraints & Limitations — Clinic Network Booking

<!--
  FIXTURE. T-06's output, Context aspect, 2026-07-09 — then the Status flip the
  2026-07-14 ingestion batch performed on the technical row (assumption A1
  confirmed by the call).

  Reshaped at S6 to the shape the T-06 sheet pins: three numbered class
  sections, each a THREE-column table — Constraint · Status · Source — with the
  Status cell drawn from the two-value vocabulary `Confirmed | Assumed` and
  nothing else in it. The pre-S6 file carried an `ID` column the sheet does not
  pin and dates inside the Status cell, which breaks the mechanical read the
  threshold criterion performs. Downstream citation is by numbered class —
  `[constraints.md §2]` is Business. See BUILD-LOG.md, S6 divergence D24.

  ../../../band1/first-pass/constraints.md is this file BEFORE the flip: the
  technical row stands `Assumed` there. The pair is the worked case for the
  Assumed → kit assumption → Confirmed round trip.

  Business and Regulatory were `open — no source material` on the framed canvas
  because nobody at the kickoff knew either subject. Both rows below come from
  contacts the framed canvas did not have: the routed sponsor call of 07-08 and
  the T-06 class probe of 07-09.
-->

## 1. Technical

| Constraint | Status | Source |
|---|---|---|
| Specialists' existing calendars are retained, not replaced | Confirmed | presale brief · call 2026-07-14 (assumption A1 confirmed) |

## 2. Business

| Constraint | Status | Source |
|---|---|---|
| Launch is tied to the autumn season; the MVP must be live this year | Confirmed | sponsor call — routed 2026-07-08 |

## 3. Regulatory

| Constraint | Status | Source |
|---|---|---|
| The product stores and processes no medical-record data; Client personal data stays inside the binding national personal-data regime | Confirmed | Olena, 2026-07-09 |
