# Out of Scope — Clinic Network Booking (global)
The product-level fence (plan §4.10). Per-feature exclusions live in each
spec's Out of Scope section (standard §11) and reference this file,
never restate it (CC-OS-03).

<!--
  FIXTURE. T-16's output, in the shape catalogue-b5 T-16 §5 pins: `## Exclusions`
  with Exclusion · Where it lives instead · Basis · source, the lives-instead
  vocabulary at Band-1 grade (D-B5-5) and each row naming the plausible
  expectation it fences, with its citation.

  Seeded 2026-07-10, last in the Requirements plan — the fence drawn with the
  full solution surface and the requirements infrastructure visible. One
  post-Band-2 change on the record: the payments row was `deferred — roadmap
  candidate, beyond MVP` at seed and resolved to the named epic E-07 by routed
  edit at decomposition, 2026-07-11 (D-B5-5's graduation path). The seed state
  is ../../band1/first-pass/out-of-scope.md.

  Product grain throughout: feature-004's own notification-preference fence is
  feature grain and lives in that spec's Out of Scope section, never here.
-->

## Exclusions

| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
| Payments taken inside the product | deferred → E-07 Online Payment | a booking product for paid care plausibly takes payment at booking; the MVP surface rules it out — canvas §9 `currencies: N/A — no payment surface in MVP scope` `[canvas §9 · kickoff notes]` |
| Medical records / clinical data — the product holds none | outside the product — the clinics' existing record-keeping remains the system of record | the clinic domain makes the expectation plausible; the regulatory bind excludes it `[constraints.md §3]` |
| Video consultation | not planned | a product that books clinician time plausibly also hosts it; declined at kickoff `[Olena, kickoff]` |
| Multi-clinic resource scheduling — rooms, equipment | deferred — roadmap candidate, beyond MVP | scheduling Specialists makes scheduling their rooms a plausible neighbour across an eight-clinic network `[context.md: organizational landscape · Olena, kickoff]` |
