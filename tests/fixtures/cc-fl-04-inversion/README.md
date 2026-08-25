# CC-FL-04 coverage inversion — regression record

The field note's §6.4 fixture, built for EC-21
(`docs/field-notes/2026-08-22-cc-fl-04-coverage-inversion.md`).

## This is a record, not an assert

**Nothing here runs in `tests/run-all.sh`, and nothing here should be made to.**
The A pass is an LLM judgement, so this fixture is a **spec plus an
expected-verdict record run against a live gate** — not a deterministic assert.
Its §6.4 wording is the reason: a suite that pinned an agent's verdict would be
pinning the agent, not the rule. What `run-all.sh` does assert about this
edition is mechanical and lives elsewhere: the compiled cards
(`tests/check-cards.py`), the two gate surfaces and the re-run rule
(`tests/check-gate.sh`), the authoring carriers (`tests/check-spine.sh`).

## How to run it

Install a project, drop `spec.md` in as a feature, and gate it:

```bash
python3 .specify/ba/scripts/sk_snapshot.py build --root <project> \
  --feature 900-reminder-dispatch --epic E-09 --run 1 --date <date> \
  --out <run>/manifest.json --workspace <run>/workspace
```

Then run Stage 3 the way `/ba-gate` does and read the three rows of §4's
alternates/errors table off the A pass.

## The three rows, and what each must produce

| Fixture row | The row in `spec.md` | Expected |
|---|---|---|
| behavior present, covered by an IF/THEN FR, no inline citation | row 1 — permanent delivery failure, governed by FR-002, **uncited** | **PASS** (field note §6.2) |
| behavior replaced by `[ASSUMED: …]`, no FR anywhere | row 2 — missing contact address | **FAIL** — CC-G-02 (§6.1), and CC-FL-03 |
| alternate covered by an event-driven `WHEN` FR | row 3 — rescheduled appointment, governed by FR-003 | **PASS** (field note §6.2) |

The Expected column names the verdicts the record is **keyed on** — the ones
whose movement is the whole point of the edition — and is not an exhaustive
verdict list for the row.

**Row 2 is the one that matters.** The field note: it is the currently-inverted
case, and it should now fail on the **global** assertion, not on CC-FL-04 —
which is what makes §6.1 a class fix rather than a local one.

**Row 1 is the other half of the inversion.** Before this edition it failed for
want of a literal `(FR-002)` in the cell; CC-FL-04 now searches the FR and BR
lists and the citation is style, never the pass condition (contract v0.4).

## The M pass sees nothing — verified

`spec.md` passes every machine checker: CC-G-01 10/10 headings · CC-FR-01 3/3
EARS · CC-FR-02 3/3 one SHALL · CC-FL-02 3 paths · CC-NF-02 six categories ·
CC-AC-01 both stories · CC-OS-01 three exclusions — and **CC-G-03 reports `0
unresolved [NEEDS CLARIFICATION] markers`**, because a mint is not a marker.
That zero is the escape in one line: nothing deterministic fires on row 2, so
the whole weight falls on the A pass, which is where CC-G-02's closed namespace
now catches it. Re-check it with `sk_structure.py`, `sk_ears.py`,
`sk_sections.py`, `sk_acceptance.py` and `sk_scan.py` against a project root
holding this spec.

## Why the fixture is shaped the way it is

Rows 1 and 3 are deliberately *uncited* and *cited* respectively, so the record
separates the two things that were conflated: whether a requirement governs the
row (the coverage) and whether the row points at it (the style). Row 2 mints a
tag in both the behavior and the outcome cell, which is the field's own shape —
45 such rows across 25 draft specs, every one of them passing CC-FL-04 and
CC-FL-03 before this edition.
