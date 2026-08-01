# T-06 — output template & worked example

## The template

```markdown
# Constraints & Limitations — <project>

## 1. Technical

| Constraint | Status | Source |
|---|---|---|

<rows — or the single line `none identified — <basis>`>

## 2. Business

<same shape>

## 3. Regulatory

<same shape>
```

Three sections, numbered, these names, this order. The numbering is the citation
target: `[constraints.md §2]` is the Business class, and it stays the Business
class.

## Worked example — Context first pass

## 1. Technical

| Constraint | Status | Source |
|---|---|---|
| No software installation at clinics — clinics run standalone, with no clinic-side IT staff | Confirmed | kickoff notes · Olena, 2026-07-09 |
| Specialists' existing calendars stay in use — retained, not replaced | Assumed | canvas: Context/Constraints (presale) |

## 2. Business

| Constraint | Status | Source |
|---|---|---|
| Launch tied to the autumn season | Confirmed | sponsor call — routed 2026-07-08 |

## 3. Regulatory

| Constraint | Status | Source |
|---|---|---|
| Client personal data is processed — national personal-data-protection law applies; no medical-record data in scope | Confirmed | Olena, 2026-07-09 |

## What the example is showing

- **Every class ends.** Three classes, three tables, no silence. Had nobody in the
  room known anything about regulation, the Regulatory section would read
  `none identified — nobody with legal knowledge present at kickoff; to revisit
  before the first release gate` — a ruling with a basis, which is a different
  object from a blank.
- **`Confirmed` and `Assumed` are the whole vocabulary.** The calendar row is
  `Assumed`: the presale material implies it and no stakeholder has confirmed it.
  It is not a marker, not a `[NEEDS CLARIFICATION]`, not a footnote — it is a real
  row with real class and real source, because an assumption is durable context a
  later call checks.
- **The date is in `Source`, never in `Status`.** `Confirmed` · `Olena,
  2026-07-09`. A cell reading `Confirmed — 2026-07-09` would break the mechanical
  read the threshold criterion performs.
- **The autumn row pre-dates this run.** It arrived from a stakeholder call while
  Context was still `untouched` — arrival is never gated. The sweep picked it up
  as existing evidence; probing the business class for a launch window would have
  been an illegal probe, because the file already answered it.
- **Constraint grade, and the ceiling is visible.** "Existing calendars stay in
  use" — one binding statement. Not *"sync completes within 5 seconds"*, which is
  a budget; not *"events are mirrored outbound"*, which is an integration
  specific. Both of those sentences would leave this run for another file.
- **Each row names what imposes it.** Clinics with no IT staff impose the
  no-installation row. National law imposes the regulatory row. The sponsor
  imposes the autumn window. A row whose imposer cannot be named is a solution
  choice, and it does not belong here.

## The Assumed row's later life

The calendar row is `Assumed` at Band 1. It is exactly the kind of line a Tier-1
kit lifts into its assumption register — pre-structured, already classed, already
sourced — so the call can check it. When the call confirms it, the approved batch
comes back and **flips the Status in place**: same row, same position, `Confirmed`
with the confirming source recorded.

That round trip is why `Assumed` exists as a status rather than as a marker. A
marker is an authoring gap that disappears when filled; this is context that
survives being answered.

## The canvas keeps the one-liners

The canvas Context/Constraints element carries summary lines; this file carries
the rows. When a ruling here changes what a summary says, the canvas edit rides a
proposed batch — it is never written from inside this run. The two are a split,
not a duplicate: the canvas says *there is a technical constraint about
calendars*, and this file says which one, whose it is, and whether anyone has
confirmed it.
