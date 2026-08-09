# Toy-world fixture set — appointment booking

Build plan §2.8's fixture unit: **the corpus's running world reconstructed as
machine inputs.** Every "stakeholder" contribution in the Phase-2 exit script
(§5 steps 4–7) is a file here, so the run is reproducible without improvisation.

---

## The world

The appointment-booking world of writing standard §14, completeness contract §7,
gate definition §14, elicitation techniques §8 and orchestrator §12 — at its
**post-Band-1-closure state** (closure 2026-07-10 · decomposition and Allocation 1
2026-07-11 · Tier-1 call 2026-07-14 · brief `Scoped` 2026-07-15 · Tier-2 spec r5
2026-07-16 · gate run 2 FAIL 2026-07-17 · gate run 3 PASS WITH WAIVERS 2026-07-18).

```
project/                        the world as an installed project
  canvas.md                     13 sections, P-1/P-2, O-1/O-2
  .specify/memory/              the armed spec-anchored estate
    glossary · stakeholders · context · constraints · competitive-analysis
    domain-model · roles-permissions · processes · design-standards
    out-of-scope · roadmap · constitution
    scope/E-03.md               the filled brief (elicitation §8.2)
    scope/E-03.kit.md           the call kit (elicitation §8.1)
  specs/004-appointment-booking/spec.md      = revisions/spec-r6.md
    …/gate-report.md            runs 2 + 3 as the report file the gate would
                                have appended — = expected/gate-run2.entry +
                                expected/gate-run3.entry (the WBS export reads
                                the certification manifest from here)
  specs/005-specialist-availability-publishing/spec.md
                                the brief's F2 slice as a Presale DRAFT — never
                                gated, two open markers; the uncertified side of
                                the WBS export's selection defaults
presale-brief.md                raw presale + kickoff material — the Frame input (S5)
call-notes-E-03.md              scripted call notes — the ingestion input
tier2-answer-sheet.md           the ≤ 7 GQ answers — the Tier-2 input
band1/                          the orchestrator §12 ledgers (S4)
  first-pass/                   what T-01/T-02/T-03 produced (S5) — canvas at
                                framing grade, the pre-RO-1 register, the
                                6-term glossary — plus T-06's constraints file
                                BEFORE the 07-14 Status flip (S6); see that
                                directory's README
  elected/                      the persona charter a BA election would have
                                produced (S6) — deliberately outside the estate,
                                because the canonical timeline is charter-free;
                                see that directory's README
revisions/
  spec-r5.md                    the gate-§14 defect set, seeded
  spec-r6.md                    the same spec after §14.1's five fixes
  roles-permissions-r5.md       the pre-fix policy table (no Specialist cancel row)
negatives/                      one focused FAIL surface per M script
  neg-structure · neg-scan · neg-stories · neg-acceptance · neg-ears
  neg-sections · neg-idgraph · personas.md · health/
a-pass/                         the gate agent's Stage-3 verdicts, recorded (S3)
  run2.json · run3.json         — see that directory's README
gate-runs/                      the BA's P2–P5 rulings per run (S3)
  run2-rulings.json             W-004-01 granted · O-004-01 ruled
  run3-rulings.json             re-affirmed · re-applied · ⚑ ×2 · approval
expected/                       the recorded verdict table per case, plus the
                                two recorded gate-report entries (S3) and the
                                two golden WBS renders (0.1.6):
  wbs-discovery.csv             certified features only — 004's three stories
                                plus the epic's one deferred row
  wbs-presale.csv               every drafted feature — 005's two stories too
```

Run the M suite with `tests/check-m.sh`, the gate suite with
`tests/check-gate.sh`, the orchestrator suite with `tests/check-orchestrator.sh`
and the technique suites with `tests/check-techniques.sh` (batch I) and
`tests/check-techniques2.sh` (batch II) — all from the package root.

### The estate is in framework shape, and that is now checked

`tests/check-band1-artifacts.py` validates `canvas.md` — at framing grade and,
with `--aspect-grade`, against AT-VA/VI/SO — plus `glossary.md`,
`stakeholders.md`, `context.md`, `constraints.md`, `competitive-analysis.md` and
the elected `personas.md`, against the shapes their sheets pin, on **both** the
`band1/first-pass/` set and this mature `project/` set, and asserts that every
first-pass row survives into the mature one. Three things moved at S5 to make
that true — recorded in `BUILD-LOG.md` as D20:

- **canvas §7** now reads *Availability published by Specialists or their Clinic
  Admins* — RO-1's resolution, which the ledger records and the canvas had not
  carried.
- **canvas §3–§5, §7, §11** gained their citations, and §13's Business and
  Regulatory one-liners now cite `constraints.md §2` / `§3` rather than the
  kickoff notes, which say nothing about either.
- **`glossary.md`** gained the `Merged synonyms` column and **`stakeholders.md`**
  became one six-column table — the shapes T-02 §5 and T-03 §5 pin.

Four more moved at S6 — recorded in `BUILD-LOG.md` as D23–D26:

- **`context.md`** became the two named sections T-05 §5 pins, with a
  `Disposition` column in place of the `Constraint` column it carried. That
  column put binding statements in the landscape file, which is the one split
  T-05's depth boundary exists to enforce.
- **`constraints.md`** lost the `ID` column T-06 §5 does not pin and the dates
  inside its `Status` cells; downstream citation is by numbered class —
  `[constraints.md §2]` is Business, everywhere in the world including
  `roadmap.md` and canvas §13.
- **`competitive-analysis.md`** became the five columns T-07 §5 pins, the status
  quo labelled as such, every `Falls short` cell keyed to a `P-n` / `O-n` — and
  it lost the trailing differentiation sentence, which is T-09's ground and never
  this artifact's.
- **canvas §7, §9, §10, §11, §12** reached aspect grade: the fifth function
  carries the `→ O-2` the ledger's RO-1 reckoning always claimed it had, §9 names
  its three facets with the currencies ruling explicit, §10 names both
  alternatives the analysis backs, §11 keys its delta, and O-2 carries the
  baseline AT-VA-2's "concrete enough to cite" is asking for.

### Two facts worth knowing before reading a verdict

**r6 still carries one `[NEEDS CLARIFICATION]` marker**, so `sk_scan` reports
CC-G-03 FAIL on it. That is correct: the marker is OQ-2's named location, and
gate §14.3 shows it carried under waiver **W-004-01** at P2. An M checker never
applies a waiver — it reports the gap, and the runtime (S3) flips it to WAIVED
during verdict assembly (gate §6.1). A checker that hid the gap because someone
waived it would be reporting a decision, not a fact.

**`roles-permissions.md` in `project/` is the post-fix table** — it carries the
`(Specialist × Appointment × cancel)` row added 2026-07-17 in response to gate
run 2's CC-XA-01 gap. `revisions/roles-permissions-r5.md` is the pre-fix table;
`check-m.sh` builds the r5 snapshot from it, which is what makes the r5→r6
diff touch a governance artifact exactly as gate §14.2 records.

---

## Expected verdicts, per M script

`✓` = PASS · `✗` = FAIL. The machine-readable tables are in `expected/*.expect`
(`script|CC-ID|VERDICT`, one line each); this table is their rendering.

### Scope F — the spec cases

| Case | G-01 | G-03 | G-04 | US-01 | US-02 | US-03 | US-04 | AC-01 | FR-01 | FR-02 | FR-05 | FL-02 | NF-02 | BR-02 | OS-01 | TR-01 | TR-02 | TR-03 | TR-04 | XA-02 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **r5** — gate run 2 | ✓ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ |
| **r6** — gate run 3 | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| neg-structure | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| neg-scan | ✓ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| neg-stories | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| neg-acceptance | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ | ✓ |
| neg-ears | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ | ✓ |
| neg-sections | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ | ✓ |
| neg-idgraph | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✓ |

Collateral failures are deliberate and recorded, never suppressed: a story with
no acceptance breaks the traceability chain too, and leaves the FR row without a
handle (neg-acceptance → CC-TR-01 · CC-TR-04); an FR pointing at a story that
does not exist fails both the link check and the graph (neg-ears, neg-idgraph →
CC-FR-05 · CC-TR-01 · CC-TR-04). A negative that failed *only* its target
assertion would be a fixture that does not resemble a real spec.

### CC-XA-05 — brief + slicing row

| Case | Verdict | Why |
|---|---|---|
| `brief-confirmed` — 004 vs. E-03 | ✓ | §8 row present, `Confirmed — 2026-07-15` |
| `brief-proposed` — 005 vs. E-03 | ✗ | §8 row present but still `Proposed` — the delivery-loop-entry confirmation is missing |
| `brief-absent` — 004 vs. E-99 | ✗ | no brief at the path — the urgent-feature valve, waivable by design |

### Scope H

| Case | H-02 | H-03 | H-06 |
|---|---|---|---|
| `health-clean` — `project/` | ✓ | ✓ | ✓ |
| `health-gaps` — `negatives/health/` | ✗ | ✗ | ✗ |

`health-gaps` seeds: an epic row with no status · an epic row whose status is
outside the D-B6-3 vocabulary · an allocation entry whose diff row carries
neither a `from → to` nor a reason · an `In delivery` epic with no scope brief ·
a constitution referencing a governance file that does not exist.

---

## The three lines this fixture exists to reproduce

Gate run 2 (contract §7) names five gaps. Three are M-detectable, and `check-m.sh`
asserts them **verbatim** — byte-for-byte, from `revisions/spec-r5.md`:

```
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target, or move the concern to an NFR with metric + condition.
CC-NF-02 FAIL — accessibility: no NFR and no N/A — <reason> → add one or declare N/A with a reason.
CC-TR-01 FAIL — US4: zero FRs reference it (story is unbuilt) → author its FRs or drop/demote the story.
```

The other two — CC-XA-01 (the missing `(Specialist × Appointment × cancel)`
policy row) and CC-AC-04 (US1's re-narrating scenario) — are **A** assertions.
Both are seeded in the same fixture and are S3's to catch: r5's US1 carries the
`Successful booking` scenario that re-narrates FR-001, and
`revisions/roles-permissions-r5.md` is the table that lacks the tuple.

---

## Authoring notes

- **NFR numbering.** r5 carries NFR-001 and NFR-002; r6 adds **NFR-003**
  (*notification … within 60 seconds of confirmation, under normal load*) — the
  exact ID and content gate §14.1 records for the CC-G-04 fix. The other four
  NFR categories are covered in both revisions by explicit
  `- <Category>: N/A — <reason>` lines, which is why NFR-003 is the next free ID
  at r6 rather than a renumbering.
- **The E-03 brief** is elicitation §8.2's excerpt completed to the nine exact
  headings, with one line added to §7 Captured Detail (the Specialist's
  "if I'm ill I want to cancel it myself") — the ground US3 and the
  `(Specialist × Appointment × cancel)` tuple both stand on.
- **`negatives/personas.md`** exists only so CC-XA-02 has a non-dormant case.
  The canonical world is charter-free (catalogue b4 T-12 §5, thread ii), so
  `project/` deliberately has no `personas.md` and CC-XA-02 reads *dormant* there.
