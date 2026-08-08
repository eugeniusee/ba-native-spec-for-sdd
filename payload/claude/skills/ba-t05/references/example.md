# T-05 — Context & landscape mapping · output template & worked example

## The template

```markdown
# Context & Landscape — <project>

## Existing systems

| System | Role today | Disposition (where stated) | Source |
|---|---|---|---|

<scoped absence lines beneath the table — or, full greenfield:
`greenfield — no existing systems — <source>`>

## Organizational landscape

- <short cited lines>
```

Two sections, these names, this order. The absence lines sit **beneath** the
table because they are part of the systems picture, not a separate finding.

## Worked example — Context first pass

## Existing systems

| System | Role today | Disposition (where stated) | Source |
|---|---|---|---|
| Specialists' external calendars | every Specialist's working schedule lives in a personal calendar; providers not yet named → open | retained, not replaced — presale-stated | canvas: Third-Party Connections · Context/Constraints |
| Phone lines at clinics | today's booking channel; ~30% of calls go unanswered → P-1 | superseded as the primary booking channel → O-1 | canvas: Problems P-1 · kickoff notes |

No booking software exists today — nothing to migrate on the booking side
`[kickoff notes]`.

## Organizational landscape

- Single clinic network; central operations under the COO (sponsor)
  `[canvas: Customers · kickoff notes]`
- Specialists are affiliated per clinic; clinics take bookings independently,
  with no shared clinic-side IT `[kickoff notes]`

## What the example is showing

- **Helicopter grade, and the ceiling is visible.** "every Specialist's working
  schedule lives in a personal calendar" is a role-today line. *Which* provider,
  *which* direction the events flow, *what* happens when the provider is
  unreachable — none of that is here, and none of it was asked. Those are
  scoping questions with no destination in this file.
- **`→ open` is a real cell value.** "providers not yet named → open" says the
  landscape has an unresolved edge and says which edge. It is not a blank, and it
  is not a guess. A later call fills it or a Tier-1 kit converts it to a
  must-ask.
- **The disposition column is conditional by design.** Both rows carry one
  because the material states one. A system whose future nobody has stated gets an
  empty disposition and a cell that says so — never an inferred "replaced".
- **The scoped absence carries its source.** "No booking software exists today"
  is a ruling with `[kickoff notes]` behind it. Silence in the material would
  have produced a question, not this line.
- **Two problems and one objective are cited, and none is authored.** `→ P-1` and
  `→ O-1` point at canvas lines this run does not own. Pointing is cheap;
  rewriting them would be the value technique's ground.
- **Org lines are short and about shape.** Who reports to whom at project
  relevance, how clinics operate — not who decides what. Decision rights are the
  register's column.

## The routing this example performs

"Retained, not replaced" **describes** a disposition. The same fact *binds* the
solution — the product may not replace those calendars — and that binding form is
proposed to `constraints.md` as a technical row. Both sides stand: the landscape
keeps the description, the constraints file takes the bind with its imposer and
its status.

That is the whole split, in one row. If you find yourself writing "must" or "may
not" in this file, the sentence belongs in the other one.

## The full-greenfield shape

Where there genuinely is nothing:

```markdown
## Existing systems

greenfield — no existing systems — `[kickoff notes: Olena, 2026-07-09]`
```

The table is gone, not empty. The line carries its source, because an unsourced
greenfield claim is an assumption wearing a ruling's clothes — and every later
integration conversation would inherit it.
