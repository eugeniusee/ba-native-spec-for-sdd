# Story drafting — the Tier-2 module

Read before drafting stories. Everything here is the spec's §2 *User Stories*
section: no standalone tables, no spreadsheet-oriented acceptance formatting.

## The input

The brief's **§2 Essential Scope** lines that *this* feature covers, per the §8
slicing row. Nothing else grounds a story. **A story the brief does not ground is
scope drift**, and it is a defect the gate names.

## The form

```
US<N> (P<1|2|3>) — As a <role>, I want <capability>, so that <value>.
```

**The role rule has two branches, and the standard's §3 is its one home** — read
there, applied here, restated nowhere.

**Where `roles-permissions.md` exists** — the role is verbatim from it. Not "a
more precise role where available": the defined string, exactly. *As a user*
fails outright: which role? A role the file does not define is a governance gap,
proposed and approved **before** the story is written, never invented inside it.

**Where `roles-permissions.md` does not exist**, because the standing flow
profile leaves its producing technique out of profile — read the ledger head's
`Profile:` line — the role is verbatim from the **canvas Core Functions actors**
and **marked at its first use in the spec**:
`[NEEDS CLARIFICATION: confirm role "<actor>" — basis: canvas Core Functions; no
roles-permissions.md under the <profile> profile]`. The marked string is used
unchanged at every later use — the marker is carried **once**, not re-stamped per
story. **Inventing a role, softening an actor to "user", and refusing to draft
are each illegal here.** The file's absence is the profile's shape, and the
marker is what makes it visible.

**This branch lifts nothing at the gate.** `CC-US-02` still fails a story actor no
`roles-permissions.md` defines; under a profile whose destination includes draft
specs that FAIL is the expected named-gap list — the client Q&A agenda — not a
defect. Never delete a marker to make the assertion pass.

**One capability per story, strictly.** Combine when two lines are genuinely one
intent; never chain behaviors. If the sentence needs an *and*, it is two stories.

**The goal is single-intent and the benefit does not restate it.** *"…so that I
can book"* under *"I want to book"* is a sentence that says nothing twice.

**Priorities: P1–P3, with at least one P1.** P1 = the feature fails without it.
P2 = needed, not day-one. P3 = nice-to-have. **If everything is P1, nothing is.**

**IDs are stable and never reused** after deletion. Downstream tasks tag back to
them.

## Sizing

| Signal | Act |
|---|---|
| two lines are one intent, one actor, one step | combine |
| one line spans two actors, or two clearly separable steps | split by actor or step |
| more than ~8 acceptance criteria | split — the story is carrying a feature |
| a single field or a single validation | fold it into the story it constrains |

## Acceptance — one slot, two forms

**Pick by complexity, not by habit.**

- **Checklist line** — a simple rule, a validation, a permission, a field
  constraint. One checkable assertion per line, in the system's perspective, with
  the real field name.
- **Gherkin scenario** — multi-step behavior, branching, an edge case: anywhere a
  **worked example with concrete data** removes ambiguity the requirement alone
  leaves open.

**The anti-duplication rule.** A Gherkin scenario must add concrete data and a
concrete path. **If it reads like the requirement reworded, delete it and write a
checklist line.** Re-narration is the most common way an acceptance section grows
long while saying nothing new.

Every criterion is testable by a person or a machine looking at the built system.
No "etc.", no "and/or", no adverbs standing in for a threshold.

## The seven behaviors this module deliberately does not inherit

Story drafting has well-worn conventions. These seven are the ones that would
quietly break the framework, listed so the break is a decision and not an
accident:

1. **"Use a precise role where available."** Hardened: the role is verbatim from
   the governance file where that file exists; where the profile leaves its
   producing technique out of profile, the role is verbatim from the canvas Core
   Functions actors and marked at first use (standard §3's two branches, cited
   above). What never survives is the soft form — a role nobody wrote down.
2. **No priority model.** Added: P1–P3, at least one P1 — the gate reads it.
3. **Free-running IDs.** Added: stable, never reused.
4. **Checklist-only acceptance.** Added: the Gherkin tier with concrete data,
   plus the anti-re-narration rule.
5. **"Combine when logical."** Bounded: one capability per story, and combining
   must never chain behaviors.
6. **"(Optional) enhancement" stories.** Excluded outright: a story or a bullet
   the brief does not ground is scope drift. **A genuinely good idea becomes a
   routed finding or an Open Question — never silent scope.** An adjacent
   capability the drafting turns up goes to the brief's **Deferred** section,
   which is its existing home.
7. **Freestanding output shape.** Replaced: the output is the spec's §2 section,
   in the standard's shape.

## Glossary-canonical language, cite or mark

Every domain term is the glossary's own string. A term the glossary does not
carry goes there first — a routed edit, approved — and is then used.

Every drafted value in an acceptance line carries a citation or a marker, exactly
as the rest of the draft does. A criterion that asserts a threshold nobody stated
is the confident guess, wearing a checkbox.

## Worked shape

```markdown
US1 (P1) — As a Client, I want to book an available Slot with a chosen
Specialist, so that I secure the Appointment without calling the clinic.
Acceptance:
- [ ] Only Slots the Specialist has published are offered.
- [ ] A Slot whose start time has passed is never offered.
```gherkin
Scenario: Two Clients race for the last Slot
  Given Specialist "Dr. Ivanova" has one available Slot at 2026-07-20 10:00
  And Client A and Client B both have the booking page open
  When Client A confirms the Slot at 10:00
  And Client B confirms the same Slot 3 seconds later
  Then Client A's Appointment is created with status "Booked"
  And Client B's booking is rejected
  And Client B sees Dr. Ivanova's updated availability without the 10:00 Slot
```
```

Two checklist lines for the two flat rules; one scenario for the race, which no
single requirement sentence can pin down — and it carries a name, a time, and a
three-second gap, because a scenario without concrete data is the requirement
again in a longer costume.
