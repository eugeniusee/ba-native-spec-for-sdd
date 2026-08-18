# T-01 — Discovery canvas framing · output template & worked example

The installed skeleton is `.specify/ba/templates/canvas-template.md`. It is the
file to copy; this page repeats its shape only so the example below can be read
against it, and adds the worked framing-grade example.

## The thirteen sections

```markdown
# Discovery Canvas — <project>
| # | Section | Content |
|---|---|---|
| 1 | Customers | sponsor + user populations — real names or real groups |
| 2 | Problems | P-1, P-2… — one line each, naming who hurts |
| 3 | Product.The | name / title of the solution |
| 4 | Product.Is | solution type |
| 5 | Product.That | what it enables for the customer |
| 6 | Forms | delivery formats |
| 7 | Core Functions | ≤ 10 capabilities; `→ O-n` — or `→ <vision section>` — where the link is stated |
| 8 | Third-Party Connections | system · direction · role, one line each |
| 9 | Localization | languages · currencies · regions |
| 10 | Competition.Unlike | named competitors (+ URLs where known) |
| 11 | Competition.Our Solution | differentiation against ≥ 1 Unlike entry |
| 12 | Objectives | O-1, O-2… — measurable where possible; `→ P-n` links |
| 13 | Context/Constraints | one-liners per class (technical · business · regulatory); detail owned by `constraints.md` from the Context aspect on; scope-frame lines land here where a frame stands — budget envelope · delivery boundary · client label · scope decisions (`SD-<n>`), each cited |
```

## Worked example — after the framing run, before any aspect work

| # | Section | Content |
|---|---|---|
| 1 | Customers | Sponsor: Olena — clinic network COO `[presale brief]`. Populations: Clients — book appointments · Specialists — deliver them `[presale canvas]` |
| 2 | Problems | P-1 — ~30% of booking calls go unanswered; bookings are lost `[presale canvas]` |
| 7 | Core Functions | Browse a Specialist's published availability → O-2 · Book an available slot → O-2 · Cancel own appointment · Specialists publish their availability `[presale canvas]` |
| 12 | Objectives | O-1 — Take booking self-serve online for the network, MVP this year → P-1 `[presale brief]` · O-2 — Reduce lost bookings → P-1 `[presale canvas]` |
| 13 | Context/Constraints | Technical: specialists' existing calendars stay in use `[presale canvas: Third-Party]` · Business: open — no source material · Regulatory: open — no source material |

## What the example is showing

- **Every line is cited or marked.** `[presale canvas]`, `[presale brief]`,
  `[presale canvas: Third-Party]` — or the line says `open — no source material`.
  There is no third option and no unmarked assertion.
- **Real names.** "Olena — clinic network COO", not "the sponsor".
- **Line-IDs on exactly two sections.** `P-1` on Problems, `O-1`/`O-2` on
  Objectives. Nothing else is numbered, because nothing downstream cites the
  other sections by line.
- **Links only where the material states them.** Three Core Functions carry
  `→ O-2`; "Cancel own appointment" and "Specialists publish their availability"
  carry none, because the presale material links them to nothing. Completing
  those links is AT-SO-2's ground, at the Solution aspect — not this run's.
- **Two open constraint classes.** Business and Regulatory read
  `open — no source material`. They are AT-CX-2's holes, ready-made as triggers
  for the Context aspect's plan. A fake `N/A` here would have hidden them.
- **Framing grade, visibly.** One problem line, not a problem inventory. No
  register rows, no constraint table, no journey. The sections are seeded, not
  completed.
