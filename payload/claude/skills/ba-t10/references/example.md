# T-10 — output template & worked example

## The template

```markdown
| # | Section | Content — aspect grade |
|---|---|---|
| 6 | Forms | delivery formats — constraint-aware, or `N/A — <reason>` |
| 7 | Core Functions | ≤ 10 capability lines (verb + object), each `→ O-n` or `→ <vision section>` |
| 8 | Third-Party Connections | system — role; direction stated or `open — <what is unresolved>`; or `N/A — <reason>` |
| 9 | Localization | languages · currencies · regions — each stated or `N/A — <reason>` |
```

## Worked example — Solution first pass

| # | Section | Content |
|---|---|---|
| 6 | Forms | Responsive web application — phone-first for Clients (they book after work from phones); nothing installed at clinics (constraints §1) `[kickoff notes]` |
| 7 | Core Functions | Browse a Specialist's published Availability `→ O-2` · Book an available Slot `→ O-2` · Cancel own Appointment `→ Product.That` · Notify the Specialist of bookings and cancellations `→ O-2` `[kickoff notes]` · Specialists publish their Availability `→ O-2` |
| 8 | Third-Party Connections | Specialists' external calendars — the Specialist's schedule lives there; booked Appointments must be visible in it; direction — open: source of truth for Availability unresolved `[context.md · kickoff notes]` |
| 9 | Localization | One interface language at launch — the network's home language; regions: the network's clinics, one country; currencies: `N/A — no payment surface in MVP scope` `[kickoff notes · canvas: Objectives O-1]` |

## What the example is showing

- **Five functions, ceiling ten, and every one linked.** Four point at `O-2`; one
  points at `→ Product.That` by section name, because "cancel your own
  appointment" is what the vision slot promises and no objective states it. Both
  notations are legal; the vision one exists precisely so a function serving the
  statement is not forced onto a made-up objective.
- **Verb + object, and the objects are glossary terms.** `Availability`, `Slot`,
  `Appointment` — capitalized because they are defined terms, not because they are
  important. The next technique reads exactly these object nouns as entity
  candidates, which is why the wording is disciplined here rather than tidied
  later.
- **The Forms line is constraint-aware, and it says so.** "nothing installed at
  clinics" is not a new constraint; it is the drafting acknowledging a Confirmed
  row. A Forms line proposing a clinic desktop install would have been a defect
  caught here, before any scan.
- **The open direction is the point of the connection row.** The row carries its
  role — "the Specialist's schedule lives there; booked Appointments must be
  visible in it" — and states the direction as `open: source of truth for
  Availability unresolved`. That satisfies first-pass grade. The run **did not
  ask** who the source of truth is, because that answer is a scoping decision with
  no destination on this canvas.
- **`N/A` carries its reason; the rest of Localization does not need one.**
  Languages and regions are stated from the material. Currencies are ruled
  `N/A — no payment surface in MVP scope` — a ruling with a basis, not a blank.
- **Silence would have failed all four.** An empty Localization row is
  indistinguishable from an unexamined one, and the criterion treats them the
  same way.

## The open slot's later life

`direction — open: source of truth for Availability unresolved` is a **ready-made
hole**. When the epic that owns this connection is scoped, the Tier-1 kit lifts
that exact slot into a must-ask question, and the call settles it.

If this run had solicited the settlement, that later question would have been
illegal — a question the material already answers must not be asked. Leaving the
slot open is what keeps the scoping question legal. The discipline is not
politeness about scope; it is what makes the downstream machinery work.

## The function that serves nothing

If a sixth line read "Rate a Specialist" and no objective or vision element
covered it, the run says so in those words: *this function serves nothing on the
current canvas.* Two ways out, both the BA's:

- **cut it** — it was a capability nobody asked for, and the surface is smaller
- **add the objective** — a proposed batch toward Objectives. Value has already
  cleared, but an **addition** is not a contradiction: it routes, it does not
  reopen.

What the run never does is invent the link to make the line legal.

## Where a contradiction goes, by this point in the band

Every upstream aspect is cleared when this run happens. So a finding that fights
an objective, the vision statement, a constraint or the cast is a **reopen
signal** — emitted with the contradicted artifact and line named, and handed on.
The ordinary-correction branch that earlier runs use has gone quiet here: if you
reach for it, name the still-open aspect that owns the content, and if you cannot,
it is a signal.
