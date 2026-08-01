# T-09 — output template & worked example

## The template

```markdown
| # | Section | Content — aspect grade |
|---|---|---|
| 3 | Product.The | name / working title |
| 4 | Product.Is | solution type, one line |
| 5 | Product.That | what it enables for the customer, one line |
| 11 | Competition.Our Solution | differentiation vs ≥ 1 named Unlike entry, keyed `→ P-n / O-n`; conflict markers where a scan hit is held |
```

## Worked example — Vision first pass

| # | Section | Content |
|---|---|---|
| 3 | Product.The | Network Booking Portal — working title `[Olena, 2026-07-09]` |
| 4 | Product.Is | a self-serve online booking service for the clinic network |
| 5 | Product.That | lets Clients book a Specialist's published Slots — and cancel their own Appointments — without phoning the clinic |
| 11 | Competition.Our Solution | Unlike phone booking (the status quo), it is open outside clinic hours and drops no calls → P-1 · O-2; unlike MedSlot, it is the network's own channel — client relationship kept, no per-booking commission → O-1 |

## The scan, reported in full

Every `Confirmed` row of `constraints.md`, read once against the statement above.
`Assumed` rows excluded.

| Confirmed row | Read against the statement | Verdict |
|---|---|---|
| §1 — no software installation at clinics | self-serve web; nothing is installed at a clinic | compatible |
| §2 — launch tied to the autumn season | the statement claims no delivery date; O-1 carries "MVP this year" and agrees | compatible |
| §3 — no medical-record data in scope | no vision claim touches data handling | compatible |

**Zero hits — nothing to resolve or name.**

## What the example is showing

- **Three slots, three sentences.** `The` is a name. `Is` is a category. `That` is
  what the customer can now do. Anything longer is marketing copy, and anything
  naming a framework is an architecture decision wearing a vision slot.
- **The differentiation names its targets.** "phone booking (the status quo)" and
  "MedSlot" are entries in `competitive-analysis.md`, by name. "Unlike other
  booking tools" would name nothing and fail the criterion however confident it
  sounds.
- **It leans on the deltas rather than inventing them.** "drops no calls",
  "no per-booking commission" — both are `Falls short` cells in the competitive
  table. This run reads that file; it never writes it.
- **Every claim is keyed.** `→ P-1 · O-2` and `→ O-1`. The keys are what tie the
  differentiation back to a value case that has already cleared.
- **Two of three entries named, and that is a margin, not a shortfall.** The
  criterion asks for at least one named entry. Naming two costs nothing and
  survives one of them being dropped later.
- **The clean scan is the normal case, and it is still reported in full.** Three
  rows, three verdicts, one line each. A report saying only "no conflicts" would
  be indistinguishable from a run that never opened the file.

## The other outcome — a hit, and what it costs

Suppose the regulatory row read *"the product may not hold any client
identity data"* and `Product.That` claimed *"remembers your Specialist and your
usual slot"*. That is a hit, and there are exactly three ways out:

1. **Revise the statement.** The normal case: the claim is dropped or narrowed,
   and the scan re-runs clean.
2. **Challenge the constraint.** The BA thinks the row is wrong. Context is
   cleared ground by now, so this is a **reopen signal** — never a quiet edit to
   `constraints.md`. The marker below stands until the reopen resolves.
3. **Name it and carry it.** Both hold. The marker goes on the statement line:

   ```
   [CONFLICT: vision claims remembered Specialist and usual slot ·
    constraints.md §3 "the product may not hold any client identity data"
    binds no stored client profile]
   ```

**Clearing over a named conflict is legal.** The criterion says "resolved **or**
named as an open conflict before clearing", and the marker *is* the naming. It
stays on the canvas and it goes into the clearing's evidence line, where the next
reader finds it. What is not legal is a hit that is neither resolved nor named —
that is silence, and silence fails.

## The missing target, and why it is not a question

If the competitive table were empty, the differentiation would have nothing to
name. This run does not go and find competitors — that is another technique's
ground, and asking the BA for them here would be a question with no destination
in the canvas.

What it does instead is surface a **plan-composition prompt**: *run the
competitive technique under this Vision plan first*. The BA re-composes, that run
supplies the entries and deltas, and this one resumes against them. The slots
that do not depend on a target are written meanwhile — the run proceeds on what
stands.
