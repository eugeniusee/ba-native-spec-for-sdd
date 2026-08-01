# Constitution — Clinic Network Booking
Read by Spec Kit's Constitution Check at /plan (Q5). Principles live
here; detailed matrices live in the referenced governance files
(plan §4.13 — reference, never restate).

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
