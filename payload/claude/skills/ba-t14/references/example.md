# T-14 — Design & UX standards · output template & worked example

## The template

```markdown
# Design & UX Standards — <project>
Global governance surface. Feature specs reference budgets and conventions
here and add feature-specific deltas only — never restate.

## Global budgets
| Budget | Metric · target · condition | Source |
|---|---|---|

## UX & interaction conventions
| Convention | Statement | Source |
|---|---|---|

## Visual identity & references
<brand / design-system references — or `open — no source material`
 or `N/A — <reason>`>
```

The budget name is the citation target. There is no ID column, because nothing
downstream cites a budget by number.

## Worked example — the Requirements seed

## Global budgets

| Budget | Metric · target · condition | Source |
|---|---|---|
| Accessibility — Client-facing surfaces | WCAG 2.1 AA conformance · all Client-facing pages · at launch | Olena, 2026-07-09 |
| Mobile responsiveness — Client pages | page interactive · ≤ 3 s · mid-range phone on a mobile network | ruled 2026-07-10 — basis: phone-first commitment `[kickoff notes]` |

## UX & interaction conventions

| Convention | Statement | Source |
|---|---|---|
| Phone-first Client surfaces | Client-facing pages are designed phone-first; desktop is secondary | canvas §6 Forms |
| Glossary-canonical interface copy | Interface text uses glossary-canonical terms — Appointment, Slot, Specialist — never synonyms | glossary discipline · kickoff notes |

## Visual identity & references
`open — no source material`

## What the example is showing

- **The accessibility row is a citation target, and it gets cited.** When a
  feature spec's accessibility category would otherwise sit silent, the compliant
  line reads `N/A — covered by the global Design & UX accessibility budget; no
  feature-specific delta` — and it resolves to *this named row*. Seeded here,
  referenced there, the chain closed. That is the whole reason budgets are named
  rather than numbered.
- **The mobile budget shows the global-vs-delta pair.** A feature's own NFR — an
  availability search returning in ≤ 2 s for 5,000 slots — sits *beside* this
  budget as a feature-specific delta. It does not restate it, and it does not
  replace it. Both are true, at different grains.
- **The ruled target is the discipline made visible.** The phone-first ground is
  cited; the *three seconds* is a BA ruling, and the row says so — `ruled
  2026-07-10 — basis: …`. Nobody stated three seconds, so nothing pretended
  somebody had. The alternative — quietly seeding an industry default — produces
  a budget the project never agreed to and a gate that enforces it.
- **The open visual-identity slot is not a stub.** The populated sections carry
  real seed content; this one slot stands explicitly open, so later brand
  material has a visible home. `open — no source material` is a state; a blank
  heading is an absence, and the two are read differently by everything
  downstream.

## The conditionality branch, spelled out

Suppose the sweep had come back empty — no delivery-form commitment, no
accessibility bind, no experience claim anywhere in Band-1 evidence. A headless
integration product is the obvious case.

The correct output is then **no file at all**:

> Ground sweep — design & UX: canvas §6 Forms `N/A — no human-facing surface`,
> §9 Localization `N/A`, objectives carry no experience claim, constraints carry
> no UX bite, transcripts none. **No design/UX ground found.**
> Proposal: omit `design-standards.md`; the constitution carries no design
> reference. Recorded on the Requirements aspect evidence.

That branch is *why* this run goes before the constitution: the constitution's
reference is what lifts this file into the threshold's demand, and a reference to
a file that does not exist is a defect surfaced at planning rather than at
arming.

## What is deliberately not here

- **A constraint restated.** *Client personal data stays inside the binding
  national regime* is a constraint — it has an imposer, and it lives in
  `constraints.md`. A privacy-related budget derived from it would reference that
  row; it would not copy its sentence.
- **A feature threshold.** *The availability search returns in ≤ 2 s for 5,000
  slots* binds one capability. It was surfaced during the sweep and handed to
  spec ground, not absorbed into a global budget it would quietly widen.
- **A screen.** *The cancel button is bottom-right, in the destructive palette*
  is `/plan`'s. The convention row above says a cancellation is confirmed in one
  explicit step that names what is being cancelled — that is the governance, and
  the button is the implementation.
