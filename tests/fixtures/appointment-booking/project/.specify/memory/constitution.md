# Constitution — Clinic Network Booking
Read by Spec Kit's Constitution Check at /plan (Q5). Principles live
here; detailed matrices live in the referenced governance files
(plan §4.13 — reference, never restate).

<!--
  FIXTURE. T-15's output, in the shape catalogue-b5 T-15 §5 pins: Principles
  table (named, MUST form, enforcement surface, source — no ID family, nothing
  cites a principle by line) · Governance references table, Governance-class
  files only.

  Seeded 2026-07-10 after T-12 and T-14, so both references resolve to existing
  stub-free files at authoring — CC-H-06's authoring-time form, checked before
  arming could discover it.

  Two framework principles enter unconditionally (D-B5-4): Authorization —
  seeded although no personas.md exists, so AT-RQ-2's persona clause reads
  dormant while the statement is already in force · Spec-first iteration. The
  Data-boundary row is the principle-vs-detail screen at work: the regime's
  detail stays in constraints.md §3, referenced, and the constitutional MUST is
  one line. `out-of-scope.md` is deliberately not in the spine — it is
  Context-class, and gate §10.2 keeps it under CC-H-01 alone.
-->

## Principles

| Principle | Statement (MUST form) | Enforcement surface | Source |
|---|---|---|---|
| Authorization | Permissions MUST derive from `roles-permissions.md` policy rows only; they are never inferred from personas or narrative material | `roles-permissions.md` · CC-XA-01/-02 at every gate | framework seed (D-B5-4) |
| Spec-first iteration | Requirements defects MUST be fixed in the spec and re-run downstream — never hand-patched in code | delivery loop (plan §5) · BA verification | framework seed (D-B5-4) |
| Data boundary | The system MUST NOT store or process medical-record data; Client personal-data handling stays inside the binding regime | `constraints.md` §3 · feature gates, security/privacy category | constraints.md §3 — Olena, 2026-07-09 |

## Governance references

| File | Carries |
|---|---|
| `.specify/memory/roles-permissions.md` | role model + resource×action policy — the Authorization principle's detail (plan §4.14) |
| `.specify/memory/design-standards.md` | global budgets + UX conventions (T-14) |
