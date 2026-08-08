# T-11 — Domain (conceptual) modeling · output template & worked example

## The template

```markdown
# Domain Model — <project>

## Entities
| Entity | What it is (one business line) | Source |
|---|---|---|

## Relations
| From | Relation | To | Multiplicity (where stated) | Source |
|---|---|---|---|---|

## Boundary references (external — not entities)
- <system> — external system; lives in context.md / canvas §8
```

Three sections, these names, this order. The tables are canonical; a diagram, if
the BA wants one, is generated from them and says so.

## Worked example — the Requirements seed

## Entities

| Entity | What it is (one business line) | Source |
|---|---|---|
| Client | Books and cancels own Appointments | canvas: Customers · Core Functions |
| Specialist | Publishes own Availability; delivers Appointments | canvas: Customers · Core Functions |
| Availability | The bookable time a Specialist publishes | canvas: Core Functions · kickoff notes |
| Slot | One bookable unit of Availability | canvas: Core Functions · kickoff notes |
| Appointment | A Client's booking of a Specialist's Slot | canvas: Core Functions · kickoff notes |

## Relations

| From | Relation | To | Multiplicity (where stated) | Source |
|---|---|---|---|---|
| Specialist | publishes | Availability | 1 Specialist : own Availability | canvas §7 publish line |
| Availability | consists of | Slot | 1 : 0..* | kickoff notes |
| Client | holds | Appointment | 1 : 0..* | canvas §7 Book · Cancel lines |
| Specialist | delivers | Appointment | 1 : 0..* | canvas: Customers |
| Appointment | occupies | Slot | exactly 1 Slot; a Slot carries at most 1 booked Appointment | kickoff notes |

## Boundary references (external — not entities)
- Specialists' external calendars — external system; landscape row in `context.md`, connection row canvas §8 with its direction open — nothing for the model to resolve.

## What the example is showing

- **The entity set is the sweep's result, not a guess.** Availability, Slot and
  Appointment are the objects of the canvas function lines — *browse a
  Specialist's published Availability*, *book an available Slot*, *cancel own
  Appointment*. Client and Specialist are the two acting parties the canvas
  Customers section names. Nothing was invented; the surface implied all five.
- **The calendar system is a boundary reference, not an entity.** It came off the
  same sweep, from the connection row rather than the function lines, and it
  leaves the model pointing at the two files that own it. The direction on that
  connection row is still open, and this run does not ask for it — the open slot
  is scoping ground, and soliciting its settlement is another technique's job.
- **Multiplicity only where a source states it.** *1 : 0..\** on
  Availability–Slot because the kickoff notes said so. The occupies row carries
  the fuller sentence because the kickoff notes stated both halves — one Slot per
  Appointment, at most one booked Appointment per Slot. Nothing carries a
  multiplicity that was merely reasonable.
- **The occupies row is a business invariant, and it is doing downstream work.**
  It is what a later feature's race scenario and its NFR operationalize, and what
  the gate resolves that spec's flows against. That is why it is written at
  business grade here rather than left for the spec to assert on its own.
- **Conceptual grade, and the ceiling is visible.** *An Appointment occupies a
  Slot* — one business line. Not *`expires_at`, datetime, required*, which is a
  field; not *Booked → Cancelled → Completed*, which is a lifecycle. Both of
  those sentences leave this run for the spec.

## The hold that is deliberately absent

The example carries no `Hold`. A five-minute hold mechanism is spec-born — it is
one feature's answer to a race, not a fact about the domain the core functions
imply — so at seed the model is silent about it.

If a later spec relies on a Hold relationship, it arrives by the **update-first**
path: the model is updated, *then* the spec references it. It never arrives as a
spec entity that the model learns about afterwards. That ordering is the whole
point of seeding one reference surface: the surface leads, and everything
downstream names against it.

## Glossary first, always

An entity candidate whose term the glossary does not yet carry produces **two**
outputs: a glossary proposal, and — once that lands — an entity row here. The
order is not politeness. If the entity row went first, this file would be
defining a term, and two files would define it differently by the end of the
month. The glossary owns meaning; this file owns relational identity.
