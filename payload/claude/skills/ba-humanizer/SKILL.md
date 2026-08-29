---
name: ba-humanizer
description: The humanizer switch - /ba-humanizer on turns the mode on and it stands until /ba-humanizer off, across sessions; default off. While on, every render a ba-* agent sends the BA and every artifact whose content is prose at the moment it is written passes through the vendored humanizer skill in embedded mode before display or write. The fence is the machine-read line, never the file - the two runtime ledgers entire, gate and audit records, BUILD-LOG.md, every pinned shape, every ID and marker token, tables, code fences, front matter, paths, commands, numbers, dates and quotes pass byte-untouched, and sk_humanizer_guard.py asserts it at every file write. A guard failure writes the original and names the anchor; it is never a stop and never a block. Slower while on - every render is generated twice.
disable-model-invocation: true
---

# `/ba-humanizer on | off` — the humanizer switch

**Argument:** `on` or `off`. Nothing else.

The switch says **when** the vendored `humanizer` skill runs. It is the BA's
**standing instruction**, not a grant: it persists across sessions, it takes no
ratification, and only the BA sets or clears it. **Default `off`** — a ledger
without the line reads `off`.

Law: orchestrator rules **§10.3 rule 10** (D-O97, §43) · the ledger line **§2.4**
· the dashboard tail **§10.4** · the interplay with an autonomy grant **§10.7**.

## `on` — the entry act

Two writes, and nothing else:

1. **The head line.** Rewrite `Humanizer:` in `.specify/aspect-state.md`
   **in place, line-anchored** — a full-line match at line start, never a
   substring search (the ledger edit discipline, §2.4):

   ```
   Humanizer: on — since <date> · <initials>
   ```

   **Where the line is absent, insert it directly after the `Auto:` line.** A
   ledger written before this ruling has no such line; that ledger reads `off`
   and is legal.

2. **The event.** Append to Events:

   ```
   <date> · humanizer on · <initials>
   ```

Then say, in one line, that the mode is on and what it costs (below).

## `off` — symmetric

The same two writes, inverted — `Humanizer: off` on the head line, and

```
<date> · humanizer off · <initials>
```

**No ratification, no batch, no trail.** Nothing was taken on the BA's behalf: a
rewrite that preserved every claim is not a decision awaiting approval.

## The scope, while on

Two surfaces, and only two:

- **Every render** any `ba-*` agent emits to the BA.
- **Every artifact whose content is prose at the moment it is written** —
  `spec.md` bodies, `exports/design-guide.md`, the handoff brief, client-facing
  summaries, any other prose markdown the framework writes.

The pass runs through `.claude/skills/humanizer/` in its **embedded mode**:
final text only, every claim kept, nothing invented, neutral technical voice.

**The WBS export is never passed separately.** `/ba-wbs` reads `spec.md`, which
was humanized when it was written, and stays a pure render of what it read.

## The fence — what passes byte-untouched

The fence is the **machine-read line**, never the file. A `spec.md` body's
sentences are rewritten; its skeleton is not.

- **`.specify/aspect-state.md` and `.specify/aspect-plans.md` — entirely.**
  Gate and audit records. `BUILD-LOG.md`.
- **Every pinned shape, block and line** the corpus names as pinned — the
  scope-frame block, the band-boundary report, the resumption report, the
  mid-grant stop report, the `What I need from you:` title line with its
  lettered options and `(recommended)` markers, the WBS title block, the
  design-guide pinned record, the dashboard's nine lines, `Next act:` lines.
- **Every ID and marker token** — `SD-<n>` · `XO-<n>` · `AS-<n>` · `ADV-<n>` ·
  `AG-<n>` · `OB-<nnn>` · `AW-<n>` · `RO-<n>` · `AT-…` · `CC-…` · `W-…` ·
  `D-O<n>` · `US<n>` · `FR-<n>` · `OQ-<n>` · §-refs · `[NEEDS CLARIFICATION]` ·
  ⚑ · every bracketed marker of the writing standard's grammar.
- **Every row of a markdown table**, every code fence and its contents, YAML
  front matter, file paths, commands, link targets, numbers, dates, quotes,
  citations.

**Sentences and paragraphs are rewritten. Structure never is** — no paragraph
holding a pinned line is merged or split, and no heading moves.

**The writing standard is senior.** Its marker grammar and its normative verbs
stand; on any conflict the standard's rule holds and the humanizer yields.
**When in doubt, byte-untouched.**

## The guard — asserted, never declined

Every **file write** under `on` runs the guard before the write lands:

```
.specify/ba/scripts/sk_humanizer_guard.py --original <path> --candidate <path>
```

It asserts three things: every exempt token of the original present in the
candidate **with the same count and order** · every pinned line, table row, code
fence and front-matter block **byte-equal** · every pinned region **unchanged in
line count**.

- **Exit 0 — the candidate is written.**
- **Exit 1 — the ORIGINAL is written, unhumanized**, and the render carries one
  additive tail line naming the anchor the guard failed on:

  ```
  Humanizer: skipped — guard failed on <anchor>
  ```

**It is never a stop and never a block.** A failed rewrite means one rewrite was
unsafe, not that the artifact is. The original is what would have been written
with the switch `off`, and it is always writable. Nothing is recorded in the
ledger: the tail line is the whole of the report.

**A chat render is checked by you, not by the script.** The reader is a person
and there is no file to diff, so apply the same fence as a **self-check before
emitting**: pinned shapes, IDs, markers, tables and fences intact, or send the
unhumanized render. A script where the reader is a machine, a rule where the
reader is a person.

## Where the state shows

`/ba-status` renders one additive tail line after its pinned render:

```
Humanizer: <on — since <date> · <initials> | off>
```

The dashboard's nine lines are untouched, and the tail **always renders** — `off`
is a state, not the absence of one.

## The cost, stated plainly

**Every render is generated twice while `on`** — once by the act, once by the
rewrite — so the mode is **slower**, and long renders are slower still.
`/ba-humanizer off` is the remedy, and it takes effect on the next render.

## What this skill never does

Never sets the switch on its own — the switch is the BA's, in both directions ·
never touches a ledger, a record, a pinned shape or a marker · never edits the
head line by substring · never blocks, halts or defers a write when the guard
fails — it writes the original and names the anchor · never asks for
ratification, and never writes an autonomy grant or reads one as permission ·
never re-fetches or re-pins the vendored skill.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report, the mid-grant stop report and
the resumption report are the only BA-facing renders of an auto cycle
(`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**,
by the effective PASS at `/ba-gate <feature>` alone; the certified-text check
runs by itself when implementation takes the feature and is never a lift
condition. Wanting to implement is never evidence of readiness:
the only exit is the gate.
