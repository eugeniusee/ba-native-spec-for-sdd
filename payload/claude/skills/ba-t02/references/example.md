# T-02 — Glossary discipline · output template & worked example

## The template

```markdown
# Glossary — <project>

| Term | Definition | Merged synonyms | Source |
|---|---|---|---|
```

Four columns, this order. The **Merged synonyms** column is not optional
decoration: it is what makes later drift detectable rather than re-litigable —
the losing term stays visible, with the date it lost.

## Worked example — after the Band-1 consolidation run

| Term | Definition | Merged synonyms | Source |
|---|---|---|---|
| Appointment | A confirmed engagement between a Client and a Specialist, occupying one Slot | booking (noun) — merged 2026-07-09, canvas usage | canvas: Core Functions |
| Slot | A bookable time interval a Specialist publishes | — | canvas: Core Functions |
| Availability | The set of a Specialist's published Slots open to Clients | — | canvas: Core Functions |

## What the example is showing

- **One term, one project meaning.** "A confirmed engagement between a Client and
  a Specialist, occupying one Slot" — a business sentence. No fields, no status
  values, no lifecycle. A definition that enumerated `start_time`, `duration`,
  `status` would have crossed into spec-Data ground.
- **The merge is on record, and dated.** "booking (noun) — merged 2026-07-09,
  canvas usage". The losing term is not deleted; it is retained with its date and
  the basis for the pick. Six months later, a spec that says "booking" is
  detectable drift, not an argument.
- **`—` is a real value.** Slot and Availability have no merged synonyms, and the
  column says so. An empty cell would read as unswept.
- **Roles are used, never defined.** "Client" and "Specialist" appear inside
  these definitions as ordinary nouns. Neither has its own entry restating what
  the roles file already defines — that would double-define them.
- **Every entry carries its source.** "canvas: Core Functions" — the usage
  context the definition was drafted from.

## Accretion after the run — the standing discipline, not a rerun

The consolidation run is a sweep, not a gate on the file. Terms keep arriving
afterwards and require no run at all:

- **"No-show"** routes in from a Tier-1 ingestion batch, as an ordinary routed
  finding to this file's destination.
- **"Hold"** is added by the Tier-2 writer *before its first use in a spec* —
  the writer's own discipline, since every domain term comes from the glossary.

Both land through the standing discipline. `/ba-t02` runs again only when
AT-RQ-3 shows a hole again — an undefined leaned-on term, an unmerged pair, or a
stub.
