# T-08 — output template & worked example

## The template

The canvas is one table; this run completes two of its rows.

```markdown
| # | Section | Content — aspect grade |
|---|---|---|
| 2 | Problems | P-n — one line each: the pain, who hurts (register populations), evidence where sourced |
| 12 | Objectives | O-n — one line each: the change sought, `→ P-n`, baseline/measure where sourced |
```

## Worked example — Value first pass

| # | Section | Content |
|---|---|---|
| 2 | Problems | P-1 — ~30% of booking calls go unanswered; bookings are lost — hurts: Clients (cannot get through to book) · Specialists (booked work never lands) `[presale canvas · kickoff notes]` |
| 12 | Objectives | O-1 — Take booking self-serve online for the network, MVP this year → P-1 `[presale brief]` · O-2 — Reduce lost bookings → P-1; baseline: the ~30% unanswered-call rate `[presale canvas · kickoff notes]` |

## What the example is showing

- **Who hurts is named, and the names resolve.** `Clients` and `Specialists` are
  register populations, not adjectives. That resolution is the whole of the first
  criterion: a P-line hurting "users" resolves to nobody and fails, however true
  it reads.
- **One pain, two populations, one line.** P-1 is a single problem that hurts two
  populations differently, and it says how each is hurt. Splitting it into two
  P-lines would double the ID space for one fact.
- **Every objective carries its link.** `→ P-1` on both. An unlinked objective is
  a wish; the link is what says which pain it answers.
- **The baseline is what "concrete enough to cite" buys.** O-2 carries "the ~30%
  unanswered-call rate". That number travels: a feature's overview will cite O-2,
  and the number is what makes the citation mean something. O-1 has no baseline
  because the material gives none — "MVP this year" is its own concreteness.
- **Framing grade is visibly behind this.** At framing, O-2 read "reduce lost
  bookings" with no baseline and no link — the material stated neither. Both are
  written here, and the link was **proposed with its basis** before the BA ruled
  it.
- **Nothing here is a capability.** "Take booking self-serve online" is a change
  sought, at objective grade. "Browse a Specialist's published Availability" is a
  capability, and if it had surfaced in this run it would have left as a proposed
  Core Functions batch — not been written into Objectives.

## Line-IDs, continued

The framed canvas already carried `P-1`, `P-2`, `O-1`, `O-2`. This run keeps every
one of those numbers exactly where it found it, and any new line takes `P-3` or
`O-3`.

If a line is retired — the BA rules that a framing-grade problem was never really
one — the ID goes with it. `P-2` is not recycled onto a later problem, and the
run log records the removal. Every downstream citation of `P-2` then fails loudly
instead of silently pointing at something else, which is the entire reason for the
rule.

## The three things that leave this run instead of landing in it

1. **A newly named population.** "Front-desk staff also lose time to the calls" —
   a real who-hurts, absent from the register. The line is not written around the
   gap; a register edit and a canvas Customers edit are proposed as a batch, and
   the BA approves them before anything lands.
2. **A capability.** "We need a waitlist" is not an objective. It is proposed to
   Core Functions, where the solution run will complete or cut it. Arrival is
   never gated — the proposal lands even though Solution has not opened.
3. **A contradiction with cleared ground.** If the cast has already cleared and a
   finding says one of its populations does not exist, that is a reopen signal —
   emitted with the contradicted artifact and line named, and handed on. It is
   not a quiet edit and it is not this run's to execute.
