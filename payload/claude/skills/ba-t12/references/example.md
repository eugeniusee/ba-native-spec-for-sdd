# T-12 — Roles & permissions · output template & worked example

## The template

```markdown
# Roles & Permissions — <project>
Authorization principle: stated in constitution.md —
this file is its enforcement surface, never its statement.

## Roles
| Role | Mandate (one line) | Derived from | Source |
|---|---|---|---|

## Policy
| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|
```

One explicit row per role × entity × action tuple; entity cells verbatim from
`domain-model.md`.

## Worked example — the Requirements seed, charter-free

## Roles

| Role | Mandate (one line) | Derived from | Source |
|---|---|---|---|
| Client | Books and cancels own Appointments | canvas function actors — no personas exist; derivation on register + canvas alone | canvas: Core Functions · stakeholders.md |
| Specialist | Publishes own Availability; delivers Appointments | canvas function actors | canvas: Core Functions · stakeholders.md |

## Policy

| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|
| Client | Availability | view | published Availability only | canvas §7 Browse line |
| Client | Slot | book | available Slots only; creates an Appointment | canvas §7 Book line |
| Client | Appointment | cancel | own only | canvas §7 Cancel line |
| Specialist | Availability | publish | own only | canvas §7 publish line |
| Specialist | Appointment | view | own only | canvas §7 Notify line — one-step consequence |

## What the example is showing

- **Two roles, and both were exercised.** The sponsor — an individual with final
  say over scope and budget — derives **no role**: she is referenced as no actor
  anywhere. Populations and individuals are register ground; roles are *exercised*
  ground. A role model that mirrored the register would be an org chart, and it
  would fail the first check that asks which policy row a story's actor matches.
- **Every entity cell is verbatim from the domain model.** Availability, Slot,
  Appointment — the exact names that file defines. This is the registry
  consistency check applied at authoring time rather than discovered at arming:
  a row citing an entity the model does not define is the failure, and it is
  cheaper to not write it.
- **One row per tuple, and the grain is deliberate.** `Client × Appointment ×
  cancel` is its own row with its own qualifier and its own source. Grouping it
  with `book` under a single "manage" action, or writing `*` in the Action cell,
  would make the later per-tuple sign-off read an expansion instead of a row.
- **The Notify row is a one-step consequence, and it says so.** The canvas line
  says the Specialist is notified of bookings; being notified of an Appointment
  implies being able to see it. One step, cited as one step. Two steps would be
  an inference, and an inference is a question, not a row.

## The tuple that is deliberately absent

`Specialist × Appointment × cancel` is not in the seed. No Band-1 line exercises
it — the canvas says Clients cancel, and nothing says Specialists do.

It enters later, and the path is the point: a feature slices, the gate checks
each tuple that feature exercises, the per-tuple assertion **fails naming the
missing tuple**, and the row arrives as an approved governance change. The seed's
silence is the machinery's entry point, not a gap in the seed.

The same is true of a role the evidence implies but nothing exercises yet — a
clinic administrator population that appears in a call but performs no
authorization act. That is recorded as a **deferral with an event-shaped
trigger** ("when the availability-publishing feature enters Band 3"), never as a
speculative role with speculative rows.

## Had charters existed

The transformation is conditional, and worth showing even where it is dormant.
Suppose a charter for the Clients population existed, named for a person, with
system-facing activity lines *Browse Specialists · Book a Slot · Cancel own
appointment*.

What would change: **nothing in the tables.** The activity lines corroborate the
three Client rows already derived from the canvas and add no fourth. What would
*not* happen: the charter's goals ("wants to be seen quickly"), its behaviors
("books from a phone, in the evening") and its frustrations reach no cell. They
are narrative, and narrative does not authorize.

And the charter's persona name appears **nowhere in this file** — not as a role,
not as an actor, not inside a qualifier. The screen runs at write time, against
the charter file's own name set, so the check is mechanical rather than
remembered. Downstream, that same name set is what the spec-side screen refuses;
this file is simply where the refusal is made unnecessary.
