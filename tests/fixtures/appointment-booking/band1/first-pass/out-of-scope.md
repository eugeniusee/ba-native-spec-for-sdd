# Out of Scope — Clinic Network Booking (global)
The product-level fence (plan §4.10). Per-feature exclusions live in each
spec's Out of Scope section (standard §11) and reference this file,
never restate it (CC-OS-03).

<!--
  FIXTURE (S7). T-16's output at the Requirements seed, 2026-07-10 — the state
  the AT-RQ-1 evidence row was written against, before any decomposition.

  Four exclusions, the lives-instead vocabulary exercised at Band-1 grade
  (D-B5-5): pre-decomposition there is no epic to name, so the payments row
  reads `deferred — roadmap candidate, beyond MVP`. At Band 2 (2026-07-11)
  decomposition lands E-07 Online Payment and a routed edit resolves the row to
  the named epic — the mature file at
  ../../project/.specify/memory/out-of-scope.md is the post-graduation state.

  Graduation by machinery, not re-runs: T-16 is not re-invoked, the row is
  edited by the routed batch decomposition proposes.
-->

## Exclusions

| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
| Payments taken inside the product | deferred — roadmap candidate, beyond MVP | a booking product for paid care plausibly takes payment at booking; the MVP surface rules it out — canvas §9 `currencies: N/A — no payment surface in MVP scope` `[canvas §9 · kickoff notes]` |
| Medical records / clinical data — the product holds none | outside the product — the clinics' existing record-keeping remains the system of record | the clinic domain makes the expectation plausible; the regulatory bind excludes it `[constraints.md §3]` |
| Video consultation | not planned | a product that books clinician time plausibly also hosts it; declined at kickoff `[Olena, kickoff]` |
| Multi-clinic resource scheduling — rooms, equipment | deferred — roadmap candidate, beyond MVP | scheduling Specialists makes scheduling their rooms a plausible neighbour across an eight-clinic network `[context.md: organizational landscape · Olena, kickoff]` |
