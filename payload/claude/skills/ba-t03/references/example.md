# T-03 — output template & worked example

## The template

```markdown
# Stakeholder Register — <project>

| Stakeholder | Kind | Role in project | Decision rights | Comms line | Source |
|---|---|---|---|---|---|
```

One table, six columns, this order. `Kind` is `individual` or `population` —
populations are first-class entries, not a footnote under the people.

## Worked example — Band-1 first pass

| Stakeholder | Kind | Role in project | Decision rights | Comms line | Source |
|---|---|---|---|---|---|
| Olena | individual | Sponsor — clinic network COO | Final call on scope, phases, budget | weekly sync · direct | canvas: Customers |
| Clients | population | End users — book and cancel appointments | — | no direct access at discovery — via Olena | canvas: Customers |
| Specialists | population | Publish availability; deliver appointments | own their calendars and published availability | 2 specialists reachable via Olena | canvas: Customers · kickoff notes |
| Dr. Ivanova | individual | Specialist voice for discovery | — | via Olena | kickoff notes |

## What the example is showing

- **The sponsor's authority is stated, not implied.** "Final call on scope,
  phases, budget" — that sentence is what AT-ST-2 asks for. "Sponsor" alone in
  the role column would leave the criterion unmet.
- **Every entry has rights *or* a comms line, and most have both.** Clients carry
  `—` under decision rights and a real comms line ("no direct access at
  discovery — via Olena"). The dash is a ruling, not a blank: it says the
  population decides nothing, and the comms column says how to reach them anyway.
- **Populations and individuals sit in one table.** Clients and Specialists are
  populations; Olena and Dr. Ivanova are named because they are decision- or
  comms-relevant. Nobody is listed for completeness.
- **Every row cites its source.** "canvas: Customers", "kickoff notes",
  "canvas: Customers · kickoff notes" where two sources agree.
- **No charters, no roles.** "Publish availability; deliver appointments" is a
  role-in-project line, not a persona narrative and not a permission. Goals,
  frustrations and environment are T-04's; a `(Specialist × Availability ×
  publish)` policy row is T-12's.
- **Coherence with the canvas is visible.** Canvas Customers names Olena,
  Clients and Specialists; all three resolve to entries here. That diff is what
  AT-ST-3 reads.

## A later contradiction is not a correction

This register deliberately has no Clinic Admin population. If a later call
establishes that clinic admins manage some specialists' calendars, that
statement **contradicts** both this register and the canvas line it agrees with.
Once Stakeholders has been cleared, that is a reopen signal — emitted with the
contradicted artifact and line named, and handed to `/ba-reopen`. It is not a
quiet edit to this table, and it is not this skill's to execute.
