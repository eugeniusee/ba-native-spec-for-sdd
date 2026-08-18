# Aspect State — negatives base

<!--
  FIXTURE (S4). A minimal, grammar-legal mid-Band-1 ledger: Stakeholders and
  Context first-pass-cleared, Value open, the rest untouched.

  `tests/check-orchestrator.sh` mutates exactly one defect into it per case and
  asserts which rule of `tests/check-ledger.py` trips — the mutation-check idiom
  S3 used for the gate. A mutation may touch both an event and the head: the
  point of each case is one *defect*, recorded consistently, not one edit.

  Keep this file legal. If it ever fails clean validation the whole negative
  suite is measuring nothing.
-->

## Current state
Band: 1 (open)

| Aspect | State | Since | Basis |
|---|---|---|---|
| Stakeholders | first-pass-cleared | 2026-07-08 | evidence table, this file |
| Context | first-pass-cleared | 2026-07-09 | evidence table, this file |
| Value | open | 2026-07-09 | prerequisites: Stakeholders first-pass-cleared |
| Vision | untouched | — | — |
| Solution | untouched | — | — |
| Requirements | untouched | — | — |

Standing aspect waivers:  none
Open reopens:             none
Upstream flags:           none
Deferred consequences:    none
Scope advisories:         none

## Events

2026-07-07 · Band 1 entered · Frame · Y.K. — canvas.md present (presale)

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

2026-07-09 · T2 · Context · open → first-pass-cleared · Y.K. — AT-CX-1..3 evidence table (recorded above)

2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared
