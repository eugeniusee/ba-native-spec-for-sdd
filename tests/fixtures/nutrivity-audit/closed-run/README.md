# Fixture — a closed Scope-S run, for the Stage-5b render

Two run workspaces and a report ledger, shaped to the source-audit definition's
own grammars (§2 rows and coverage block · §5 P-A1 head, list and SA record ·
§7 required set). Nothing here is a live project: the specs the rows cite do
not exist, and nothing reads them — the coverage report renders the **run's
own evidence**, which is exactly the property the fixture exists to hold down.

- **run 2** — a closed run, on the ledger: 12 obligations over four sources,
  one of them sampled and one of them zero-row; all four statuses present; a
  quote carrying a middot of its own; a row wrapped across two lines; a critic
  row; three findings, one of them an enumerated `amend` absorbing two rows;
  a menu `Rulings:` line **and** the as-ruled line beneath it; `repairs.json`
  in the pinned per-row shape.
- **run 3** — a clean run that has **not** appended: three obligations, zero
  findings, no `repairs.json`, and the conditional self-evaluated `Status:`
  line. This is the Stage-5b path — the render precedes the append, so the
  P-A1 head is the only ground the title block has.

- **run 4** — a **refused admission**, on the ledger with a run number and no
  workspace at all. The template makes these gapless on purpose, so a
  `--report` right after a Stage-0 refusal hits one first.

`--latest` must pick **run 2**: the latest *closed* run is the highest entry on
the ledger **whose workspace is complete** — never the highest directory on
disk (run 3 is complete and unlisted), and never a refused admission (run 4 is
listed and empty). The render says which entries it stepped past.
