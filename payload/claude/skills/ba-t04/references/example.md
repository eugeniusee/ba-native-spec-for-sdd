# T-04 — Persona charters · output template & worked example

## The template

```markdown
# Personas — <project>

Transformation contract:
TC-1 — Details: exactly one register population per charter, resolving to
       a `stakeholders.md` entry.
TC-2 — System-facing activities: capability-level lines (verb + object);
       they are read as candidate role-and-action evidence — nothing
       else in a charter is transformation input.
TC-3 — Namespace: persona names are charter-local human forenames,
       disjoint from role names, register populations, and register
       individuals; a persona name is never used as an actor anywhere.

## <Persona name> — details: <register population>

| Field | Content |
|---|---|
| Goals |  |
| Behaviors & environment |  |
| Frustrations |  |
| System-facing activities |  |
| Source |  |
```

The three clauses ship **inside** the file, above the charters. They are not a
comment about the file; they are the contract the transformation reads, and the
file is where its reader looks.

## Worked example — one elected charter

## Marta — details: Clients

| Field | Content |
|---|---|
| Goals | Book a Specialist in the evening without phoning; cancel without calling the clinic |
| Behaviors & environment | Books after work from a phone; gives up after two unanswered calls `[kickoff notes]` |
| Frustrations | Daytime calls to the clinic go unanswered → P-1 `[canvas: Problems P-1]` |
| System-facing activities | Browse a Specialist's published Availability · Book an available Slot · Cancel own Appointment |
| Source | register: Clients · kickoff notes · canvas P-1 |

## What the example is showing

- **TC-1 in the heading, not in a footnote.** `details: Clients` names exactly one
  register population, and `Clients` is an entry in `stakeholders.md`. One
  population per charter — a charter covering "Clients and Specialists" would
  give the transformation two anchors and no answer.
- **TC-2 is the only line that travels.** `Browse a Specialist's published
  Availability · Book an available Slot · Cancel own Appointment` — verb +
  object, objects glossary-canonical. Goals, behaviors and frustrations are human
  context and stay here; they are read by people, never by the transformation.
- **TC-3, visibly.** `Marta` is a forename that appears nowhere else: not in the
  register (`Olena`, `Dr. Ivanova`, `Clients`, `Specialists`), not among the
  roles (`Client`, `Specialist`). That disjointness is what makes the screening
  grep safe — every name here is a name no spec may use as an actor.
- **The heading marker is load-bearing.** `## <Name> — details: <population>` is
  what the screen keys on; a bold `**<Name> — details: <population>**` line reads
  the same way. Without the marker the `TC-1 …` lines themselves would parse as
  persona names.
- **The frustration carries a link because the material carries it.** `→ P-1` is
  written because the kickoff notes and the canvas both say the unanswered calls
  are the pain. Goals are unlinked — nothing states which problem the evening
  preference answers, so nothing is inferred.
- **Every line cited.** Where a line is drawn from the register entry itself, the
  Source column says so — `register: Clients`.

## What is not here, and why

No permission, no access rule, no role. Marta "cancels her own appointment" as a
described activity; `(Client × Appointment × cancel)` is a policy row and belongs
in `roles-permissions.md`. If the material had said *"clients may only cancel up
to 24 hours before"*, that sentence would not enter this table at all — it would
leave the run as a proposed governance finding.

No journey either. "Books after work from a phone" is an environment line, not a
numbered step map.

## The charter that has no register row

If the elected population is not in `stakeholders.md`, the charter is not
written around the gap. The run proposes the register edit and says so, because a
charter enriches a cast entry and cannot precede one.
