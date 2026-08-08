# T-07 — Competitive analysis · output template & worked example

## The template

```markdown
# Competitive Analysis — <project>

| Alternative | Category | Covers | Falls short | Source |
|---|---|---|---|---|
```

One table, five columns, this order. Full no-market case: the table is replaced
by the single line `N/A — <reason>`.

## Worked example — Context first pass

| Alternative | Category | Covers | Falls short | Source |
|---|---|---|---|---|
| Phone booking (status quo) | current way of working | booking and cancellation via clinic phone lines | ~30% of calls go unanswered → P-1; no self-serve channel outside clinic hours → O-2 | canvas P-1 · kickoff notes |
| MedSlot | booking marketplace | clinics list openly; clients book across networks | the network's own channel and client relationship are ceded to the marketplace → O-1; per-booking commission | kickoff notes (Olena named it) |
| Calendar-link scheduling tools | generic scheduling | single-person booking links | no clinic or network structure; no cancellation-policy handling → O-1 | kickoff notes |

Canvas batch (proposed): `Competition.Unlike` ← "Phone status quo · MedSlot ·
calendar-link scheduling tools".

## What the example is showing

- **The status quo is row one, and it is the point.** Nobody named "phone
  booking" as a competitor at kickoff; the screen surfaced it. It is also the
  alternative carrying the sharpest delta — the ~30% figure that the whole value
  case rests on.
- **Every delta is keyed.** `→ P-1`, `→ O-2`, `→ O-1`. The keys are what make the
  column differentiation ground rather than commentary: the vision statement will
  lean on exactly these deltas and cite exactly these lines.
- **One delta is deliberately unkeyed — and it rides along.** "per-booking
  commission" names no `P-n` or `O-n`. It sits beside a keyed delta in the same
  cell, so the row is legal; on its own it would not have earned a row.
- **`Covers` is honest about strength.** "clinics list openly; clients book
  across networks" is a real capability, stated as such. An analysis whose
  competitors do nothing well is not an analysis.
- **Category is a positioning word, not a taxonomy.** "current way of working",
  "booking marketplace", "generic scheduling" — three words each, enough to say
  what kind of alternative this is.
- **No statement anywhere.** Nothing in this table says what *our* product does
  better. The table supplies the targets and the deltas; the sentence that
  differentiates against them is written by the vision run, against this file.

## The canvas split, in one line

The canvas gets the **names**: "Phone status quo · MedSlot · calendar-link
scheduling tools". This file keeps the **analysis**. That is why the canvas edit
is a proposed batch and not a write from inside this run — the two artifacts hold
different grades of the same fact, and neither is a copy of the other.

## The two doors, and what each one closes

Run under the **Context** plan, this table answers *"the Unlike section is empty
and no `N/A` ruling stands"*. It closes that hole.

Run under the **Vision** plan, it answers *"the differentiation has no named
target"*. It does **not** close that criterion — it makes the criterion
closeable. The report says so in those words, because a report claiming
otherwise would hand the vision run a criterion it has not earned.

## The no-market shape

```markdown
N/A — internal reconciliation tool for one finance team; no external or internal
alternative exists, and the manual spreadsheet it replaces is recorded in
`context.md` rather than screened as a competitor. `[Olena, 2026-07-09]`
```

The reason is the ruling. A bare `N/A` is a blank wearing a ruling's clothes, and
the criterion reads it as the hole it is.
