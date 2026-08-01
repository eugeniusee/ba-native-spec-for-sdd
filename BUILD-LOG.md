# BA-Native Spec — Phase-2 Build Log

One record per Claude Code build session (build plan §4). Append-only: a session
record is written when its exit test is green and is never rewritten. Divergences
between the build plan and verified reality are flagged here, at the session that
found them — never silently resolved.

---

## S1 — Foundation · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (vector below) · build
plan v0.2 §1, §2.6, §2.7, §3 · plan §7 · standard §2 · orchestrator §2.4, §6.4 ·
gate §6.2, §7.4, §8, §10.3 · contract §7 · elicitation §3.2, §4, §10 ·
catalogue b1 T-01 §5.

### Units built — 16 of the 67

| Unit class | Built | Notes |
|---|---|---|
| Repo skeleton | `VERSION` · `README.md` · `.gitignore` · `payload/` · `vendor/` · `tests/` | §1.2 tree |
| Installer (§2.7) — 1 | `install.sh` | pinned init + overlay + mirror + manifest |
| Templates & scaffolds (§2.6) — 13 | `spec-template.md` · 10 × `ba/templates/*` · `AGENTS.md` · `claude-block.md` | all 13, each to its pinned anchor |
| Manifest generation | `.specify/ba/manifest.md` (generated at install) | package version · doc vector · Spec Kit pin · sha256 list |
| Test harness | `tests/check-layout.sh` · `tests/layout.expected` · `tests/verify-manifest.py` | not a §2 build unit; required by the S1 and Phase-2 exit tests |

`README.md` is the **package-repo** README (build state, layout, how to install
and test). The BA-facing shipping README and `docs/quickstart.md` remain S9's,
per §4 — S9 expands this file rather than creating a second one.

`vendor/spec-kit-v0.12.5.zip` is **not committed** (upstream's release artifact,
gitignored). `vendor/README.md` carries the one-line command to populate it; the
`--offline` path was exercised against the real archive this session.

### Compilation-rule application (§3)

- **§3.1 travels verbatim:** the ten spec headings · the nine brief headings ·
  the thirteen canvas sections with `P-n`/`O-n` · the kit's four parts and its
  `Q<n>` grammar · the D4 open-question vocabulary · brief `Draft`/`Scoped` ·
  slicing `Proposed`/`Confirmed — <date>` · must-ask ≤ 12 · Tier-2 cap 7 ·
  ≤ 10 capability lines · the six non-waivables · the ⚑ pair · the named-gap
  grammar · the AW/RO/W/O/HA record fields · the event grammar.
- **§3.3 never compiled:** no BABOK tag, mining note, review record, or
  rationale prose entered the payload. `docs/methodology/` is read by build
  sessions only; `install.sh` copies nothing from it. Verified: the only
  methodology contact at install time is reading four header lines per document
  for the version vector.
- **§0 layering rule** holds for everything shipped so far. The three compiled
  cards (S3) are where it will next be load-bearing.

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-1 | `ba-*` namespace used throughout the mirrors and `layout.expected`; no dotted name anywhere in the payload |
| D-P2-2 | Both mirrors state the BA-invoked-never-auto-fired discipline; `disable-model-invocation: true` is the skills' own frontmatter, enforced from S3 on |
| D-P2-3 | Four agents registered by name in `layout.expected` (S3/S4/S5/S8) |
| D-P2-4 | 20 technique skills registered 1:1; `ba-tier1` modes and `ba-tier2` documented in the command index |
| D-P2-5 | `ba-frame` registered as the 12th workflow skill |
| **D-P2-6** | **Mechanically enforced.** `install.sh` creates directories and templates only. `check-layout.sh` asserts 19 runtime-born (◇) paths are **absent** after a fresh install and fails if any exists — `absent` and `stubbed` are the same hole, so the test proves the installer made none. Spec Kit's default `constitution.md` is set aside to `.specify/ba/speckit-defaults/` |
| D-P2-7 | `verify-manifest.py` and the installer's two helpers are Python 3 stdlib-only |
| **D-P2-8** | **Pin re-verified at S1 open** — see below |
| D-P2-9 | Pinned `uvx --from git+…@v0.12.5 specify init --here --integration claude`, plus the `--offline` vendor-zip fallback; both exercised |
| D-P2-10 | Deferred to the technique sessions (S5–S8) — `references/example.md` is per-skill |
| D-P2-11 | `elicitation-tuning.md` template built: one file, three tables (false-ask · wrong-draft · dead-answer), outside `memory/` |
| D-P2-12 | Deferred to S9 (the exit-test script) |

### Pin verification (D-P2-8)

`git ls-remote --tags github/spec-kit` on 1 Aug 2026:

- **`v0.12.5` exists and resolves** (commit `12efa87f…`). The pin is valid; the
  package builds and exit-tests against it, as ruled.
- **Upstream has moved on: latest tag is `v0.15.1`.** The build plan pinned
  v0.12.5 as "latest tag, 6 Jul 2026"; that is no longer true. D-P2-8 also rules
  that *"Phase 4 owns the rollout freeze — this pin is what Phase 2 builds and
  exit-tests against"*, so the ruling binds unchanged and no pin bump is taken
  here. Recorded as a **Phase-4 input**, not an S1 action.

### Source-doc version vector (as installed)

| Document | Version | | Document | Version |
|---|---|---|---|---|
| definition & plan | **v2.14** | | catalogue index | v0.2 |
| writing standard | v0.3 | | catalogue b1 | v0.3 |
| completeness contract | v0.2 | | catalogue b2 | v0.2 |
| elicitation techniques | v0.3 | | catalogue b3 | v0.2 |
| gate definition | v0.3 | | catalogue b4 | v0.2 |
| orchestrator rules | v0.3 | | catalogue b5 | v0.2 |
| Wave-2 sequencing plan | v0.4 | | catalogue b6 | v0.2 |
| Phase-2 build plan | v0.2 | | | |

The vector is read from the vendored documents' own headers at install time, so
it cannot drift from what the payload was compiled against. `verify-manifest.py`
re-derives it and fails on any mismatch.

### Session exit test — GREEN

Build plan §4, S1 row: *fresh dir → `./install.sh` → `tests/check-layout.sh`
green: §1.1 tree exact, `/speckit.*` present, all 32 `/ba-*` skills listed,
manifest vector correct.*

```
$ mkdir toy && cd toy && git init
$ ../ba-native-spec/install.sh
$ tests/check-layout.sh --target toy --session S1

▸ Tree (build plan §1.1)
  ✓ 27 expected path(s) in place
  ✓ 19 runtime-born (◇) path(s) correctly absent — zero installer stubs (D-P2-6)
▸ Spec Kit
  ✓ 10 speckit-* skills registered
▸ spec-template override (standard §2)
  ✓ ten headings, exact names, exact order — the override is in place
▸ /ba-* skill registry — 32 expected
  ✓ layout.expected registers all 32 by name (12 workflow + 20 technique)
  ○ 0 of 32 installed — 32 pending, itemized by owning session
▸ Manifest
  package version 0.1.0 ✓ · Spec Kit pin v0.12.5 ✓
  source-doc vector: 15 documents, all matching the vendored set ✓
  installed-file hashes: 14 files, all matching ✓

  passed: 50   failed: 0   pending: 50
✓ GREEN at the sessions SK..S1 bar
```

Supporting checks run this session, all green:

| Check | Result |
|---|---|
| Full-bar run (no `--session`) must **fail** at S1 | ✓ exits non-zero — the bar is real, not vacuous |
| Plant `canvas.md`, re-check | ✓ **FAIL** naming the D-P2-6 violation |
| Pre-existing `CLAUDE.md` content survives install | ✓ preserved; block appended, then replaced in place |
| Install twice more | ✓ exactly one `ba-native-spec:begin` marker in each mirror |
| `--force-speckit` with no constitution | ✓ re-laid default removed; `memory/constitution.md` stays absent |
| `--force-speckit` with an **authored** constitution | ✓ byte-identical afterwards; stored default not overwritten |
| Plain re-run with an authored constitution | ✓ untouched |
| `--offline` against the real `vendor/` archive | ✓ green, identical result to the network path |
| `--dry-run` | ✓ wrote nothing |
| `spec-template.md` override survives `specify init --force` | ✓ ten headings, exact order |

**One defect found and fixed in-session.** The first cut of the constitution
set-aside misclassified an authored `constitution.md` as Spec Kit's default and
moved it out of `memory/` — losing T-15's artifact on any `--force-speckit`
re-run. Root cause: it inferred "default" from *"unchanged across init"*, but
the pinned `specify init --force` does **not** overwrite an existing
`constitution.md`, so authored content also looks unchanged. Replaced with a
content-identity test — at v0.12.5 the default `memory/constitution.md` is
byte-identical to Spec Kit's own `templates/constitution-template.md`, verified
not assumed — plus a stash/restore around the init in case a future pin does
overwrite. All four cases in the matrix above now pass.

### Divergences flagged (§3.2 discipline, generalized)

**D1 · Spec Kit's command namespace is hyphenated skills, not dotted commands.**
The corpus writes `/speckit.plan`, `/speckit.analyze`, `/speckit.checklist`
(plan Q5/§8 · gate §11.3, §12, §13 · build plan §1.1, §4, §5). At the pinned
v0.12.5 with `--integration claude`, Spec Kit installs **skills** at
`.claude/skills/speckit-<name>/SKILL.md`, invoked `/speckit-plan`,
`/speckit-analyze`, `/speckit-checklist`. This is the same merged-commands-into-
skills fact that produced D-P2-1 for our namespace — upstream has applied it to
itself. *Resolution taken:* the payload and `layout.expected` use the verified
hyphenated names; the corpus's dotted spelling reads as indicative, exactly as
both binding tables pre-authorize for our own names. *Downstream:* S9 owns
`sk_handoff.py`'s Spec Kit plumbing, the quickstart, and exit-test step 10 —
all must use the hyphenated names. *Doc-first (§3.5):* this is a **plan/gate
erratum candidate**, not a compiled-text patch.

**D2 · Definition & plan is at v2.14, not the build plan's cited v2.13.**
Build plan v0.2's Sources line reads "definition & plan v2.13"; the vendored
document's header reads v2.14 (its §0 tracker already records Phase 2 open and
S1 next, so v2.14 is the current one). *Resolution taken:* the manifest records
**v2.14** — the version actually vendored and read. No compiled text depends on
the difference. *Doc-first:* build-plan Sources-line erratum candidate.

**D3 · The S1 exit test names a bar S1 cannot meet alone.** §4's S1 row requires
"all 32 `/ba-*` skills listed", but S3–S8 build those skills; §1.1's tree is
likewise complete only at S9. *Resolution taken:* `layout.expected` declares the
**whole** §1.1 tree with every entry tagged by its owning session, and
`check-layout.sh` runs at two bars — `--session Sn` (this session's) and the full
tree (the Phase-2 exit bar, §5 step 2). At S1 all 32 skills are **registered by
name** and the 32 not yet installed are itemized with their owning session, so a
partial build reads as partial. The full-bar run correctly fails today, which is
what makes the S1 pass meaningful rather than vacuous. *Doc-first:* build-plan
§4 wording candidate — "all 32 registered; installed set reported by session".

**D4 · Spec Kit v0.12.5 lays down more under `.specify/` than §1.1 lists** —
`workflows/`, `integrations/`, `init-options.json`, `integration.json`,
`templates/checklist-template.md`, `templates/constitution-template.md`.
All are Spec Kit's own and untouched by us. *Resolution taken:* `layout.expected`
asserts what §1.1 names and tolerates upstream's extras rather than pinning a
closed tree that a pin bump would break. No erratum — §1.1 was never claiming to
enumerate Spec Kit's internals.

**D5 · Layering-rule interpretation: `D-xx` decision IDs inside template
comments.** §0 fixes compiled artifacts as "operative text + IDs only", naming
the CC- and AT- families; §3.3 sends BABOK anchors, mining notes, review records,
and rationale prose home. A leak scan of `payload/` finds **zero** BABOK anchors,
mining notes, and review records. It does find ~17 one-token decision-ID tags
(`D-B1-1`, `D-O3`, `D-G1`…) in the templates' HTML comments, each sitting beside
the operative rule it fixes ("line-IDs on exactly two sections (D-B1-1)").
*Reading taken:* these are provenance pointers of the same kind as a CC-ID — they
keep the one-way chain template → decision → document line verifiable, which is
what §0 exists to preserve — not rationale prose, which is absent. They live in
comments, in templates, never in a card or a runtime-loaded prompt.
*Flagged, not settled:* if the BA Lead reads §0's named ID families as
exhaustive, the fix is a one-pass strip of `D-xx` tags from
`payload/specify-overlay/ba/templates/` — no other unit is affected, and no
operative text changes.

### Open for the next session

S2 — M machinery + fixtures. Inputs already in place: `.specify/ba/scripts/`
exists and is empty by design; `traceability-template.md` is the shape
`sk_idgraph.py` must emit; `gate-report-entry.md` is the block the report writer
fills. `layout.expected` already names all 11 scripts, so S2's exit is measurable
the moment it starts (`--session S2`).

---

## S2 — M machinery + fixtures · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector, unchanged
— re-read from the vendored headers this session) · build plan v0.2 §2.4, §2.8,
§3 · contract v0.2 §4–§6 M rows, §7, §8 · gate v0.3 §3, §4.1–§4.2, §5.1, §6.1,
§7.2–§7.4, §8, §9.2, §10–§11, §14 · standard v0.3 §2–§9 · elicitation v0.3 §4,
§8 · catalogue b2 T-04 §5 · b4 T-12 §5 · b5 T-15 §5 · b6 (D-B6-2, D-B6-3).

### Units built — 11 of the 67 (running total 27)

| Unit class | Built | Notes |
|---|---|---|
| Checker scripts (§2.4) — 10 | `sk_snapshot` · `sk_structure` · `sk_scan` · `sk_stories` · `sk_acceptance` · `sk_ears` · `sk_sections` · `sk_idgraph` · `sk_brief` · `sk_health` | Python 3, stdlib only (D-P2-7). `sk_handoff.py` stays S9's |
| Fixture set (§2.8) — 1 | `tests/fixtures/appointment-booking/` | the corpus world as machine inputs: presale estate · call notes · Tier-2 answer sheet · spec r5/r6 · negatives · expected-verdict tables |
| Test harness | `tests/check-m.sh` | not a §2 build unit; the S2 exit test itself |

**All 24 M assertions are covered**, across the ten scripts: CC-G-01 · CC-G-03 ·
CC-G-04 · CC-US-01…04 · CC-AC-01 · CC-FR-01/02/05 · CC-FL-02 · CC-NF-02 ·
CC-BR-02 · CC-OS-01 · CC-TR-01…04 · CC-XA-02 · CC-XA-05 · CC-H-02/03/06.
The count reconciles: contract v0.2 has 24 M (21 Scope-F + 3 Scope-H), gate
§4.1's Stage 2 runs "the remaining 20" after CC-G-01 in Stage 1, and §14.2 says
"all 21 M" for a Scope-F re-run. All three statements agree.

### Compilation-rule application (§3)

- **§3.1 travels verbatim:** the ten spec headings · the five EARS patterns and
  their combination form · the banned-word list (standard §4, vendored — no
  upstream dependency) · the story grammar and its P1–P3 vocabulary · the
  named-gap grammar · the six NFR categories · the brief §8 status vocabulary
  (`Proposed` · `Confirmed — <date>`) · the roadmap status vocabulary (D-B6-3) ·
  the acceptance-handle grammar (`US<n>/AC-<i>` · `US<n>/S-"<name>"`) · the
  traceability banner and table shape (gate §8) · the certification-manifest
  block (gate §11.1).
- **§3.3 never compiled:** no assertion *text* enters any script. `sk_snapshot`'s
  assertion table carries **CC-ID + category + M/A class only** — the data the
  §9.2 re-run computation needs, and nothing a card would carry. The A-side
  assertion text is S3's three compiled cards. Leak scan of the ten scripts:
  zero BABOK anchors, zero mining notes, zero review records. Doc *section*
  citations appear in docstrings as provenance pointers of the same kind as a
  CC-ID (the S1 D5 reading, applied one layer down).
- **§0 layering rule** holds: a script resolves to a CC-ID, the CC-ID to a
  contract line, the contract line to its BABOK anchor. Nothing runs the other
  way.

### Architecture decision — the shared parse surface

`sk_structure.py` is both the CC-G-01 checker and the module the other nine
import (`parse_spec`, the record types, the named-gap `Finding`/`Verdict` API,
the emit helpers). That is the gate's own architecture, not a convenience:
§4.1 makes Stage 1 the parse and ID inventory that Stage 2 consumes. It also
keeps the pinned inventory literal — **11 `sk_*.py`, no twelfth shared module.**

Consequence handled in-session: cross-imports make CPython write
`__pycache__/` into `.specify/ba/scripts/`, which `install.sh`'s manifest glob
would hash and which would then rot on first use. Two guards, because one is not
enough: every script sets `sys.dont_write_bytecode = True` before importing a
sibling (the fix in S2's own units), **and** `install.sh`'s two overlay copies
now skip `__pycache__/` and `*.pyc` (a one-line hygiene fix to an S1 unit — the
payload had already collected a stale `__pycache__` from this session's own
direct runs, and the installer copied it into the target). Verified after the
fix: running the installed checkers leaves zero `__pycache__` directories and
`verify-manifest.py` still matches all 24 hashed files.

### Implementation freedoms taken (inside the pinned coverage)

Build plan §2.4 rules that clustering inside the pinned coverage is a Phase-2
freedom and the coverage is not. Four recognition decisions were needed where
no document fixes a parseable shape; each is documented in its script's
docstring and listed here so a later session can find them.

| # | Decision | Why this way |
|---|---|---|
| 1 | **CC-NF-02 demands a category *label***: `NFR-0NN (<category>) — …`, `- <Category>: N/A — <reason>`, or a table row led by the category. A bare keyword never counts. | "Availability search returns results within 2 seconds" is a *performance* NFR containing the word "availability". A substring scan would pass the availability category on it — a false PASS, the expensive class the gate exists to prevent (gate §5.2). |
| 2 | **The banned-word list gains a declared inflection set** for its five verb entries (handle · support · manage · improve · process). Nothing else is stemmed. | The standard's own bad example is "The system **supports** calendar integration". Matching only the base form would miss the example the rule was written from. |
| 3 | **"process (without an object)"** — flag `process` unless the next token is a determiner, possessive, quotation mark, or capitalised noun. | It is the list's only conditional entry; the parenthetical *is* the object test. |
| 4 | **CC-US-04 / CC-FR-05 ID reuse** is decided against `--hist` as *an ID whose element changed identity between revisions*, plus an explicit `--retired` list for IDs dropped more than one revision back. | With a single prior revision that is the whole mechanically decidable surface. The corpus's US4 (dropped at r5→r6, never reused) is the `--retired` case. |

M checkers have **no override instrument** — contract §2 gives the BA override
authority over *A*-checker false positives. Every recognition rule above is
therefore deliberately conservative: it fails only on evidence the document
names, never on a heuristic guess.

### Session exit test — GREEN

Build plan §4, S2 row: *script suite vs. fixtures: every M assertion exercised
with ≥ 1 seeded FAIL and ≥ 1 PASS; fixture r5 reproduces gate run-2's
M-detectable gaps verbatim in named-gap grammar; `sk_idgraph` emits a
gate-§8-shaped `traceability.md`.*

```
$ tests/check-m.sh

▸ Scope-F spec cases (contract §4–§5, M rows)        9 cases, 20 verdicts each
▸ CC-XA-05 — brief + slicing row (contract C12)      3 cases
▸ Scope H (contract §6, M rows)                      2 cases
▸ Gate run-2 reproduction                            3 lines verbatim ✓
▸ traceability.md generation (gate §8)               7 shape checks ✓
▸ snapshot · re-run set · anchors                    13 checks ✓
▸ Coverage — every M assertion, ≥ 1 FAIL and ≥ 1 PASS
  ✓ TOTAL 24 of 24 M assertions exercised both ways

  passed: 40   failed: 0
✓ GREEN — S2 M machinery + fixtures
```

The three gate-run-2 lines reproduce **byte-for-byte** from `spec-r5.md`:

```
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target, or move the concern to an NFR with metric + condition.
CC-NF-02 FAIL — accessibility: no NFR and no N/A — <reason> → add one or declare N/A with a reason.
CC-TR-01 FAIL — US4: zero FRs reference it (story is unbuilt) → author its FRs or drop/demote the story.
```

Run 2's other two gaps — CC-XA-01 (the missing `(Specialist × Appointment ×
cancel)` policy row) and CC-AC-04 (US1's re-narrating scenario) — are **A**
assertions. Both are seeded in the same fixture, waiting for S3.

Supporting checks run this session, all green:

| Check | Result |
|---|---|
| Full-bar `check-layout.sh` must still **fail** at S2 | ✓ exits non-zero — 40 units still owned by S3–S9 |
| `check-layout.sh --session S2` after a real `--offline` install | ✓ GREEN — 60 passed (S1's 50 + the ten scripts), 0 failed |
| The ten scripts run **from the installed location** | ✓ imports resolve; no `__pycache__` written |
| Mutation test — delete `"quickly"` from the vendored banned list | ✓ **RED**: r5's verdict table and the verbatim-line check both fail. The suite is not vacuous |
| Every failure line matches `CC-… FAIL — <element>: <what> → <fix>` | ✓ the gate meets its own bar (gate §1 rule 2) |
| `sk_snapshot rerun-set` vs. gate §14.2 | ✓ diff = spec + roles-permissions; changed sections = §§2, 3, 5, 9; all 21 Scope-F M in the re-run set; carried set matches (see D6) |
| `sk_snapshot anchor-diff` vs. gate §14.3 | ✓ W-004-01 (CC-IN-03) clean → P5 re-affirmation; O-004-01 (CC-AC-04, US2 acceptance) auto re-applies at **element** granularity while §2 as a whole changed; a changed block (US1 acceptance) re-arms the checker |
| Post-certification byte edit → `sk_snapshot verify` | ✓ **REFUSED**, naming the diverged path (gate §11.1 adapter precondition; the §5-step-8 negative check, proven early) |

**One defect found and fixed in-session.** The first cut of the snapshot's
label model gave each file a single shorthand, so `roles-permissions.md` was
`roles` and nothing else. The r5→r6 re-run set then *carried* the
governance-reading A assertions (CC-BR-01/03, CC-NF-03) across a
roles-permissions edit — a silent carry of exactly the assertions gate §14.2
re-runs on that diff, and the class of bug that lets a stale PASS certify. Root
cause: the contract's *Checks* shorthands are not a partition — one file wears
several. Replaced with multi-label entries (`roles-permissions.md` is `roles`
**and** `gov` **and** `mem`, with `gov` derived from the constitution's own
reference spine per gate §3). The carried set now matches §14.2.

### Divergences flagged (§3.2 discipline, generalized)

**D6 · Gate §14.2's carried list includes CC-FL-02, which is an M assertion.**
The same paragraph opens the re-run set with *"all 21 M"*, and CC-FL-02 is M
(contract §5 C5). It cannot be both re-run and carried. *Resolution taken:* the
rule governs the example — `sk_snapshot` re-runs all 21 M and carries the twelve
A assertions §14.2 lists minus CC-FL-02 (CC-OV-01/02 · CC-FL-01/03/04/05 ·
CC-DA-01…04 · CC-IN-01/02). `check-m.sh` asserts exactly that set, with the
reason inline. *Doc-first (§3.5):* **gate erratum candidate** — §14.2's carried
list should read "CC-FL-01, CC-FL-03…05". A rendered example, not a rule; no
compiled text depends on the difference.

**D7 · The `[non-waivable]` marker is a report-assembly concern, not a checker
output.** Contract §7's worked example prints it on the CC-XA-01 line; gate
§6.2 says failures are printed "named-gap grammar; non-waivable marked". If a
checker emitted the marker inline, r5 could not reproduce §7's CC-TR-01 line
verbatim — §7 prints that one *without* the marker. *Resolution taken:* checkers
emit the bare named-gap line and expose `non_waivable: true` in their JSON; the
report writer renders the marker. This keeps both statements true. *No erratum
implied* — the two documents describe different layers. **S3 owns rendering it.**

**D8 · CC-G-03 fails on r6, and that is correct.** Gate §14.3's run-3 report
reads "Failures: none" while r6 still carries the OQ-2 `[NEEDS CLARIFICATION]`
marker under W-004-01. An M checker cannot see a waiver: it reports the gap, and
P2 flips it to WAIVED during verdict assembly (gate §6.1). `expected/r6.expect`
records CC-G-03 FAIL with that reasoning; a checker that suppressed the gap
because someone waived it would be reporting a decision, not a fact. *No erratum
— the layers differ.* **S3 owns the flip.**

**D9 · The spec-template's §5 comment does not name CC-NF-02's parseable
form.** The template (S1's unit) restates the contract's requirement — six
categories carry an NFR or an explicit `N/A — <reason>` — without naming a shape
a checker can read, because no document fixes one. S2 fixed the shape (freedom 1
above) but did **not** edit an S1 artifact: the one-way rule (§3.5) says
compiled text is not patched in place. *Flagged, not settled:* a two-line
addition to the template's §5 comment naming the three accepted forms is a
**recompile candidate**, cheapest to take at S3 when the cards land beside it.
A BA writing from the template today still gets a named gap with a fix action —
the machinery works, it just costs one avoidable cycle.

**D10 · A run workspace needs a home under `.specify/ba/`.** Gate §3 fixes the
Phase-2 snapshot as "content hashes and a copied run workspace", and every
checker must read the snapshot rather than the live files. Build plan §1.1 lists
no directory for it (correctly — it is §3.4 runtime-generated content, never
shipped). *Resolution taken:* `sk_snapshot build --workspace <dir>` takes the
path from its caller and creates nothing by default; the gate skill will pass a
path under `.specify/ba/` — the framework's namespaced runtime home, outside
`.specify/memory/`, so the runtime-ledger rule holds. *Doc-first:* build-plan
§1.1 note candidate, not an erratum. **S3 picks the path.**

### Open for the next session

S3 — Gate. Inputs now in place: the ten M checkers with a stable JSON contract
(`{script, assertions:[{assertion, verdict, non_waivable, checks, evidence,
findings:[{element, problem, fix, gap_line, evidence, location}]}]}`) ·
`sk_snapshot` for Stage 0's snapshot, §9.2's re-run composition, §7.2/§7.3's
anchor persistence, and §11.1's certification block · the fixture world with
both A-side run-2 gaps seeded and `expected/*.expect` as the regression floor.
S3 owns: the three compiled cards, the `[non-waivable]` rendering (D7), the
waiver flip on CC-G-03 (D8), the run-workspace path (D10), and — cheaply, while
the cards are open — the D9 template comment.

---

## S3 — Gate · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged — re-read from the vendored headers this session) · build plan v0.2
§2.2, §2.3, §2.5, §3, §4 (S3 row) · gate v0.3 **in full** · contract v0.2 §2,
§4–§6, §7, §8, §10 · orchestrator v0.3 §2.1–§2.4, §3.2–§3.4, §4.3 · standard
v0.3 §2, §15 · S2's ten checkers and the fixture world.

### Units built — 6 of the 67 (running total 33)

| Unit class | Built | Notes |
|---|---|---|
| Compiled cards (§2.5) — 3 | `assertions-f.md` (34 A) · `assertions-h.md` (3 A) · `at-thresholds.md` (18 AT / 6 aspects) | text + ID + Checks + flags, nothing else |
| Workflow skills (§2.2) — 2 | `ba-gate` (Scope-F, stages 0–5) · `ba-gate-health` (Scope H: full · scoped · the P8/HA cadence) | `disable-model-invocation: true` |
| Subagents (§2.3) — 1 | `ba-gate` — the A-pass evaluator, `tools: Read, Grep, Glob` | read-only by tool policy |
| Report/certification writer | `sk_snapshot.py report` (+ `--certification-out`) | inside the pinned 11 scripts — see D12 |
| Test harness | `tests/check-gate.sh` · `tests/check-cards.py` · a frontmatter block in `check-layout.sh` | not §2 build units; the S3 exit test |

**The `[non-waivable]` rendering (D7), the CC-G-03 waiver flip (D8), the D9
template comment and the run-workspace path (D10)** — the four items S2 left
open — are all taken this session; each is recorded below.

### Compilation-rule application (§3)

- **§3.1 travels verbatim, and it is now mechanically enforced.**
  `tests/check-cards.py` **re-derives all three cards from the vendored
  documents and byte-compares** — `--record` is the compiler, the default mode
  is the regression floor. A doc bump recompiles the cards by re-running
  `--record` and shows the delta as a diff (§3.5 step 3). Carried verbatim: the
  34 + 3 A pass-conditions · their Checks sets · the ⚑ pair · the six
  non-waivable IDs with their refusal lines · the contract §2 Checks shorthand
  legend · the twelve category titles · the 18 AT criteria with the two locked
  conditionality notes (D-B5-3, D-B4-4) and the handover rule.
- **§2.5's "nothing else", applied literally.** The cards carry **no category
  or aspect intent lines**. Gate §5.2 fixes an A checker's inputs as *"the
  assertion's exact contract wording + only its Checks artifacts"*, so the
  intent prose is framing, not input. Recorded as a reading, not a silent cut.
- **§3.3 never compiled:** a leak scan of the six new payload files finds zero
  BABOK anchors, mining notes, review records or rationale prose. One hit was
  found and fixed in-session — the `ba-gate` skill's P4 paragraph opened
  "BABOK 5.5, holistic"; the anchor is methodology-layer and was removed. The
  scan is now part of `check-cards.py` and runs on every card.
- **§0 layering rule** — one deliberate, documented exception: gate §7.1 step 3
  requires a waiver request against a non-waivable assertion to be refused
  *"printing the contract's §8 rationale line for that ID"*, so those six lines
  are vendored in `sk_snapshot.py`. Four of the six name **M** assertions, so a
  card is not their home. `check-cards.py` verifies them against the contract
  like a card; mutating one byte turns the suite red (proven).

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-1 | `/ba-gate` · `/ba-gate-health`, hyphenated, name-for-name with gate §13's indicative `/ba.gate` · `/ba.gate-health` |
| **D-P2-2** | **Mechanically enforced from this session on.** `check-layout.sh` now asserts, on every installed `/ba-*` skill: frontmatter `name` = directory · a non-empty `description` · `disable-model-invocation: true`. Negative-tested: deleting the line turns the layout check red |
| **D-P2-3** | The fourth agent ships. Its read-only tool policy is asserted too — `tools: Read, Grep, Glob` exactly; adding `Edit` turns the check red (gate §11.3 made mechanical, not advisory) |
| D-P2-6 | Unbroken: the three cards and the two skills are templates/prompts, not content; the 19 runtime-born paths stay absent after a fresh install |
| D-P2-7 | The `report` subcommand is Python 3, stdlib only |
| D-P2-10 | Not applicable to gate units — `references/example.md` is the technique skills' (S5–S8) |
| D-P2-12 | The FAIL → fix → re-gate cycle, one waiver + ⚑ pass, and a hash-refusal check are **already exercised here** at feature scale; S9 owns the same shape as the Phase-2 exit script |

### Architecture decisions

**1 · The report/certification writer is a subcommand, not a twelfth script.**
Build plan §4's S3 row names it a unit; §2 does not count it — it is content
inside the gate skill, and §2.4 pins **11** `sk_*.py`. It landed as
`sk_snapshot.py report`, the run-machinery script that already owned the §11.1
certification block. The alternative — an LLM assembling the report from the
skill prompt — would put the one number nobody can verify (the category summary,
the `FAIL (n)` count) inside a model's arithmetic. See D12.

**2 · Three granularities in the category summary, and they are not the same
one.** `in force · evaluated · carried · passed · skipped` are **assertion**
counts; `failed` is a **failure-line** count (assertion × element — one
assertion can contribute several gaps); `waived` and `overridden` are **record**
counts (W-/O- records in force this run). Under exactly this reading both
worked examples reconcile — see the reconciliation below.

**3 · One accepted gap, several assertion lines.** W-004-01 accepts the
calendar-sync failure expectation (CC-IN-03) *and* the `[NEEDS CLARIFICATION]`
marker that names it (CC-G-03). Contract §8's "Markers and waivers" makes those
one acceptance, and the corpus mints one W-number for it. The record therefore
carries an `also` list for the extra lines rather than a second W-number; the
rendered line says so.

**4 · The run workspace (D10).** `.specify/ba/runs/<NNN-feature>/run-<n>/` —
manifest · workspace · checkers · a-pass · run record · certification manifest.
Under `.specify/ba/`, outside `memory/`, runtime-generated and never shipped, so
the runtime-ledger rule holds and the installer's overlay copy (additive) leaves
it alone.

**5 · Stage 5 certifies what the run *produced*, not only what it read.**
Gate §11.1 says "every file the run read or produced"; the snapshot holds only
the reads. `report` takes a `produced` list, hashes it, and appends it to the
certification manifest — that is how `traceability.md` gets certified, which
CC-TR-04 requires and the adapter later verifies. Found by inspecting the first
recorded entry against §11.1, not by a test.

### Contract §7 ⇄ gate §14.3 — the two examples reconcile exactly

The run-2 entry this machinery produces reads
`55 in force · 55 evaluated · 0 carried · 48 passed · 5 failed · 1 waived · 1 overridden · 0 skipped`.
Contract §7's worked example reads `61 checked · 54 passed · 5 failed · 1 waived
· 1 overridden`. They are the same run: **61 = 55 Scope-F + 6 CC-H pre-flight**,
and **54 = 48 + those same 6 H passes**. Nothing is left over. Gate §6.2 fixes
the field list, contract §7 counts the pre-flight inside "checked" — no
divergence, and the arithmetic is now asserted in `check-gate.sh`.

### Session exit test — GREEN

Build plan §4, S3 row: *fixture replay of gate §14 runs 2→3 end to end: FAIL
with 5 named gaps → fixes applied from fixture r6 → incremental re-gate (carry
set per §9.2) → PASS WITH WAIVERS → ⚑ ×2 → approval → certification manifest
hashes verify.*

```
$ tests/check-gate.sh

▸ Compiled cards (build plan §2.5)            34 · 3 · 18, verbatim, layering clean
▸ Gate run 2 — full Scope-F run on r5         FAIL (5 gaps), all five verbatim
▸ Gate run 3 — incremental re-gate on r6      PASS WITH WAIVERS, effective
▸ The gate never self-certifies               provisional without P3 / P4
▸ Waiver instrument — hard refusals           non-waivable · incomplete record
▸ P1 — pre-flight block and the HA lift       blocked · admitted, HA cited
▸ Mutation checks — the suite is not vacuous  2 seeded, both caught

  passed: 59   failed: 0
✓ GREEN — S3 gate: cards · Scope-F stages 0–5 · W/O/HA · P1–P8 · certification
```

**How much of that is real.** The **M pass runs live** — the ten S2 checkers
against a real snapshot workspace. The **A pass is a recorded sheet**
(`tests/fixtures/appointment-booking/a-pass/`), because Stage 3 is an agent act
and cannot be re-derived inside a regression suite. Everything downstream of the
A pass runs for real: disposition, verdict assembly, the report entry, the
waiver/override/HA lifecycles, certification, and the hash verification. What
the suite does **not** prove is that a live `ba-gate` agent returns those
verdicts — that is the agent prompt's job, proven by running it, and the
fixture's README says so in as many words. Both recorded entries are byte-frozen
in `expected/gate-run2.entry` and `expected/gate-run3.entry`.

Supporting checks run this session, all green:

| Check | Result |
|---|---|
| Full-bar `check-layout.sh` must still **fail** at S3 | ✓ exits non-zero — 34 units still owned by S4–S9 |
| `check-layout.sh --session S3` after a real `--offline` install | ✓ GREEN — 69 passed, 0 failed |
| `verify-manifest.py` after the install | ✓ 30 files hashed, all matching (S2's 24 + the six S3 units) |
| S2 regression — `check-m.sh` after the `sk_snapshot` extension | ✓ GREEN, 40 passed |
| Delete `disable-model-invocation` from an installed skill | ✓ **RED**, naming D-P2-2 |
| Add `Edit` to the `ba-gate` agent's tools | ✓ **RED**, naming gate §11.3 |
| Mutate one byte of a vendored §8 refusal line | ✓ **RED**, printing doc vs. script |
| Drop the CC-XA-01 verdict from the A sheet | ✓ verdict moves to FAIL (4 gaps) — the gap list is real |
| A finding whose line does not round-trip the named-gap grammar | ✓ exit 2, runtime defect — the writer refuses the run |
| Post-certification byte edit to the generated `traceability.md` | ✓ `verify` REFUSES, naming the diverged path |
| Installed checkers run from `.specify/ba/scripts/` | ✓ no `__pycache__` written |

**One defect found and fixed in-session.** The first certification manifest
listed only the ten files the run *read*; `traceability.md` — the file the run
*generates*, that CC-TR-04 asserts and the adapter must verify — was absent.
Gate §11.1's wording is "every file the run read or produced", and a
certification that omits the produced file lets a post-certification edit to
`traceability.md` pass the adapter's hash guard silently. Fixed by the
`produced` list (decision 5 above); the negative check is in the suite.

### Divergences flagged (§3.2 discipline, generalized)

**D11 · Contract §7's worked example prints CC-TR-01's failure line without the
`[non-waivable]` marker, and CC-XA-01's with it.** Both IDs are in §8's locked
non-waivable set, and gate §6.2 rules the Failures block "named-gap grammar;
**non-waivable marked**". The two cannot both be right. *Resolution taken:* the
rule governs the example — every failing member of the locked six carries the
marker, so the run-2 entry renders `CC-TR-01 FAIL [non-waivable] — US4: …`,
which is §7's line plus the marker §6.2 requires. This is the same shape as S2's
D6 ruling. The checker-layer statement is untouched and still verbatim: no
checker emits the marker (asserted), and `check-m.sh` still reproduces §7's
CC-TR-01 line byte-for-byte from `sk_scan`/`sk_idgraph`. *Doc-first (§3.5):*
**contract erratum candidate** — §7's example should mark CC-TR-01. A rendered
example, not a rule; no compiled text depends on the difference.

**D12 · The report/certification writer is a build-plan unit with no home in
the §2 inventory.** §4's S3 row lists it among the units built; §2.9's roll-up
counts 67 units of which the script class is pinned at **11**, and §2.4's
`sk_snapshot` row names snapshot · live-diff · re-run set · anchor diffing —
not report assembly. *Resolution taken:* implemented as `sk_snapshot.py report`.
The count stays literal at 11 scripts, and `sk_snapshot` is the run-machinery
script — it already renders the §11.1 certification block that §2.4 assigns it,
and the §6.2 entry is the same layer. *Doc-first:* **build-plan §2.4 row-wording
candidate** — sk_snapshot's Covers cell should read "… · verdict assembly (§6.1)
+ report entry (§6.2) + certification (§11.1)". No coverage changed; no
assertion moved.

**D13 · Gate §14.3's "13 carried / 41 evaluated" inherits S2's D6.** With
CC-FL-02 correctly re-run as an M assertion, run 3's composition is **42
evaluated · 12 carried · 1 waived = 55**, where §14.3 reads 41 · 13 · 1 = 55.
The delta is exactly CC-FL-02 and nothing else, which is what makes it a
verification of D6 rather than a new finding. *Resolution taken:* the numbers
above are what the machinery produces and what `check-gate.sh` asserts, with the
basis inline. *Doc-first:* folded into D6's existing **gate erratum candidate**;
§14.3's two totals move with §14.2's carried list.

**D14 · The fixture's US2 carries the 24h boundary as checklist lines, where
contract §7's override example names a Gherkin scenario.** O-004-01 is therefore
modelled as a textbook false positive — CC-AC-04 governs Gherkin scenarios and
does not reach a checklist line — which is precisely what the override
instrument exists for, and it auto re-applies at run 3 because US2's acceptance
block is byte-identical across r5 → r6 (the mechanic §14.2 demonstrates).
*Resolution taken:* the instrument, the anchor and the persistence are the
corpus's; only the element's rendering differs, and the a-pass README records
it. *No erratum implied* — the fixture (an S2 unit) and the example describe the
same mechanic on slightly different text.

**D15 · S2's D9 taken.** The `spec-template.md` §5 comment now names CC-NF-02's
three accepted forms (`NFR-0NN (<category>) — …` · `- <Category>: N/A — <reason>`
· a table row led by the category) and says that a keyword inside a sentence
does not count. This is not a new operative rule: it is S2's recognition freedom
(recorded there, inside the pinned coverage) propagated into the artifact a BA
actually writes from, so the machinery stops costing one avoidable cycle. The
one-way rule (§3.5) is respected — no *runtime behavior* changed, and the
underlying doc gap is unchanged: **standard §7 / contract C5-C6 wording
candidate**, still open, still doc-first.

### Open for the next session

S4 — Orchestrator. Inputs now in place: `at-thresholds.md` (the 18 criteria
`/ba-clear` reads at the §3.4 confirmation act, with the two locked
conditionality notes and the handover rule) · the gate's arming contract, so
`/ba-close-band1` has a concrete dispatch target (`/ba-gate-health full`, whose
"disarmed before closure" precondition is written into that skill) · the
W/AW/HA distinctness table honoured on the gate side, so S4's AW machinery has
nothing to reconcile. `check-layout.sh` now asserts skill frontmatter on
whatever is installed, so S4's nine skills are covered the moment they land.

---

## S4 — Orchestrator · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §2.2, §2.3, §3, §4 (S4 row) · **orchestrator
v0.3 in full** · `at-thresholds.md` (S3) · gate v0.3 §10.1/§10.4/§13 for the
arming contract and the HA boundary · contract v0.2 §3 (cadence) and §8 (W
semantics, for the distinctness table) · elicitation v0.3 §3.5/§5.4/D5/D7 for
the three signal classes · S3's two gate skills and the gate agent, as the
neighbours these nine must not overlap.

### Units built — 10 of the 67 (running total 43)

| Unit class | Built | Notes |
|---|---|---|
| Subagents (§2.3) — 1 | `ba-orchestrator` — the conductor, `tools: Read, Write, Edit, Grep, Glob` | **no Bash** — the mechanical half of "requests the arming run; runs nothing" (§10.2) |
| Workflow skills (§2.2) — 9 | `ba-frame` · `ba-status` · `ba-aspect` · `ba-run` · `ba-clear` · `ba-waive-aspect` · `ba-reopen` · `ba-close-band1` · `ba-enter-feature` | all `disable-model-invocation: true` |
| Test harness | `tests/check-orchestrator.sh` · `tests/check-ledger.py` · `tests/fixtures/appointment-booking/band1/` | not §2 build units; the S4 exit test — see decision 1 |
| S1 unit touched | `ba/templates/aspect-plans.md` — the snapshot header recompiled to §6.1's block shape | see D16 |

### Compilation-rule application (§3)

- **§3.1 travels verbatim.** Carried byte-faithful into the compiled prompts:
  the five states with their progression effects · **T1–T8** with preconditions
  and record bases, and the statement that no other transition exists · the
  event grammar `<date> · T<n> · <aspect> · <from → to> · <BA initials> —
  <basis ref>` · the DAG, including Vision's two-edge gate · the artifact-home
  table for evidence and reopen mapping · the AW record's six fields · the RO
  record grammar · the three-instrument distinctness table (AW / W / HA) · the
  signal-intake table with its two explicit non-signals · the **P-O1…P-O9**
  definitions · Q2's `select · drop · reorder · add custom` · Q2+'s
  `{expected output · artifact class · destination file}` · D-B6-3's four
  roadmap statuses · the handover rule.
- **§0 layering, at the aspect layer.** No skill restates an AT criterion.
  `/ba-clear` and `/ba-aspect` read `.specify/ba/cards/at-thresholds.md` and are
  told, in as many words, never to restate one from memory and never to soften
  one. The chain stays: skill → AT-ID → card → orchestrator line. The two locked
  conditionality notes (D-B5-3 design standards · D-B4-4 primary roles) travel
  with their criteria into `/ba-clear`, because they change what the criterion
  demands rather than explaining it.
- **§3.2 compiled with transformation.** §11's binding table is the compile
  source: each row became a skill with frontmatter (`name` · `description`
  naming the act and its prompt point) and an **invocation-contract block** at
  the top — the preconditions the skill checks, and the exact refusal when one
  is unmet. Each P-O became a checkpoint script: what is rendered, what the BA
  rules, what executes on each ruling.
- **§3.3 never compiled.** A leak scan over the ten payload files finds zero
  BABOK anchors, mining notes, review records or rationale prose; the scan runs
  in `check-orchestrator.sh` on every run.

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-1 | Eight of the nine are §11's indicative names, hyphenated name-for-name: `/ba.status → /ba-status`, `/ba.aspect`, `/ba.run`, `/ba.clear`, `/ba.waive-aspect`, `/ba.reopen`, `/ba.close-band1`, `/ba.enter-feature` |
| D-P2-2 | All nine ship `disable-model-invocation: true`; `check-layout.sh` asserts it on whatever is installed. Negative-tested this session: deleting the line from an installed `ba-clear` turns the layout check red |
| D-P2-3 | The second of the four agents ships. Its tool policy is asserted exactly — adding `Bash` turns `check-orchestrator.sh` red, naming §10.2 |
| **D-P2-5** | **`ba-frame` ships** — the one addition beyond the corpus's eleven indicative names. Without it §8.1's Band-1 entry act has no command and the two ◇ ledgers have no birth |
| D-P2-6 | Unbroken. The installer still lays down zero content stubs, and both ledgers are asserted **absent** after a fresh install — `/ba-frame` births them. `/ba-enter-feature` creates `specs/NNN-<feature>/` as a **directory only**, and says so |
| D-P2-11 | `.specify/elicitation-tuning.md` is named in `/ba-reopen` as one of the two destinations a declined signal is flagged toward — which log is the emitter's classification, not the orchestrator's |

### Architecture decisions

**1 · The ledger validator is a test harness, not a twelfth script.** The S4
exit test needs something that can actually judge a ledger, and the obvious move
would be `sk_aspect.py`. It is the wrong move twice over: build plan §2.4 pins
the vendored script set at **eleven**, and — more decisively — orchestrator §3.2
rule 4 says AT criteria have *no checker*, while §10.2 says this layer "requests
the arming run; runs nothing". A shipped runtime ledger checker would contradict
the document it compiles from. So `tests/check-ledger.py` lives in `tests/`, is
never installed, and exists for exactly the reason `check-cards.py` does: to
keep the compiled prompts honest against the pinned doc. The installed tree is
unchanged — 40 files hashed, and the layout check still counts eleven scripts.

**2 · The head is a derived quantity, and that is now mechanically checked.**
§2.4's file discipline — *head rewritten in place, events append-only* — has a
consequence the document does not spell out: the head must be exactly what
replaying the events produces. `check-ledger.py` replays every event from six ×
`untouched` and compares state, `Since`, the band line, the open reopens and the
standing waivers against the head. A ledger whose head has drifted from its own
history is now a caught defect rather than a slow rot.

**3 · `/ba-enter-feature` owns the NNN assignment; the agent persona does not.**
Build plan §1.1 gives the command the act ("assigns the next free `NNN` … so the
Tier-2 destination path exists before the gate's Stage-0 admission"), while
§10.2 confines the orchestrator's hands to two ledger files. Both stand: the
**skill** creates the directory — a directory, never a file, per D-P2-6 — and
the **agent persona** keeps its two-file confinement and never performs it. See
D17.

**4 · Negatives are mutation-derived in-suite, not committed as fixtures.** One
legal base ledger plus fourteen single-defect mutations, in the idiom S3 used
for the gate. Each case reads as "this one change made it illegal", and the base
is validated clean first — if the base ever goes illegal the whole negative
suite is measuring nothing, and the suite says so.

### Session exit test — GREEN

Build plan §4, S4 row: *orchestrator §12's three exhibits replayed on an empty
fixture project: ledger heads/events land in §2.4 shape; P-O checkpoints render;
the §8.2 reopen executes end to end.*

```
$ tests/check-orchestrator.sh

▸ The §12 replay is grammar-legal            both ledgers, 14 rules, no violations
▸ Exhibit 1 — the BA-planning loop            snapshot · both Q2+ paths · routed finding
▸ Exhibit 2 — the threshold cleared, closure  T2 · evidence table · the arming act
▸ Exhibit 3 — RO-1, the reopen, end to end    receive · Real · T5 · no cascade · T6
▸ Seeded defects — 14 rules, 14 mutations     all fourteen caught
▸ The nine P-O checkpoints                    P-O1…P-O9, with their refusals
▸ The orchestrator agent                      no Bash · two-ledger confinement
▸ Layering                                    zero methodology-layer leaks

  passed: 120   failed: 0
✓ GREEN — S4 orchestrator: §12 exhibits ×3 · ledger grammar · 14 seeded defects · P-O1–P-O9
```

**How much of that is real.** The **validator runs live** — a real parser over
the state ledger, replaying every event against the §2.3 transition table, the
§3.1 DAG, the §4.1 AW fields, the §5.3 RO grammar and the §8.2 closure
preconditions. The **ledgers are recorded**, because writing one is an agent act
and cannot be re-derived inside a regression suite — the same split S3 made for
the gate's A pass. Every literal §12 supplies is carried verbatim (the RO-1
record, the Stakeholders evidence table, the closure, the deferral and its
trigger); the five intermediate aspect gates are the fixture's own, evidenced
against the real artifacts in `fixtures/appointment-booking/project/`. What the
suite proves is that the machinery these prompts compile from **accepts the
corpus's own exhibits and rejects fourteen distinct violations of it** — not
that a live agent produces them. That is the prompt's job, proven by running it.

Supporting checks run this session, all green:

| Check | Result |
|---|---|
| Fresh `--offline` install, then `check-layout.sh --session S4` | ✓ GREEN — 79 passed, 0 failed, 24 pending |
| Full-bar `check-layout.sh` must still **fail** at S4 | ✓ exits non-zero — 25 units still owned by S5–S9 |
| `verify-manifest.py` after the install | ✓ 40 files hashed, all matching (S3's 30 + S4's 10) |
| Both ledgers absent after a fresh install | ✓ `/ba-frame` is their birth act, not the installer (D-P2-6) |
| S2 regression — `check-m.sh` | ✓ GREEN, 40 passed |
| S3 regression — `check-gate.sh` · `check-cards.py` | ✓ GREEN, 59 passed · cards byte-identical |
| Delete `disable-model-invocation` from an installed S4 skill | ✓ **RED**, naming D-P2-2 |
| Add `Bash` to the `ba-orchestrator` agent | ✓ **RED**, naming §10.2 |
| Soften §12.3's "flagged `upstream reopened` (no cascade)" in the fixture | ✓ **RED** twice — the exhibit assertion *and* the validator's L10 |

### Divergences flagged (§3.2 discipline, generalized)

**D16 · §6.4's plan-record example labels the suggestion block
`Suggestion snapshot — <date>`, while §6.1's block header — and §12.1's exhibit
— is `Suggestion — <aspect> — <date>`.** The two cannot both be the shape that
is "kept verbatim". *Resolution taken:* **§6.1 governs**, because §6.4's own
annotation says so — it labels its example "(§6.1 shape — kept verbatim)". The
S1 template's comment carried §6.4's label, so it was recompiled to §6.1's
header this session, and the fixture snapshots use §6.1's block. This is a
compilation correction, not a runtime change: no behaviour moved, and the
one-way rule holds. *Doc-first (§3.5):* **orchestrator erratum candidate** —
§6.4's example line should read `Suggestion — <aspect> — <date>`. A rendered
example, not a rule.

**D17 · Build plan §1.1 assigns `/ba-enter-feature` the creation of
`specs/NNN-<feature>/`, while orchestrator §10.2 confines the orchestrator's
hands to two ledger files and §8.4 says it "records the band event — and nothing
else".** *Resolution taken:* the two statements govern different actors. The
**skill** performs the assignment and creates the directory; the **agent
persona** does not, and its instructions say so explicitly. The reading is
defensible on the corpus's own terms: §8.4's "nothing else" is about what the
*record* contains — it is the tracking-split rule, not a filesystem permission —
and a directory is not content, which is exactly the line D-P2-6 draws. *No
erratum implied;* recorded as a reading so a later session does not silently
re-decide it.

**D18 · §12.3's resolution rewrites the canvas Core Functions line to
"availability published by Specialists or their Clinic Admins", but the S2
fixture's `canvas.md` §7 reads "Publish Specialist Availability" — neither the
pre- nor the post-RO-1 form — while its `stakeholders.md` *does* carry the
post-RO-1 Clinic administrators row.** The fixture world is therefore
post-RO-1 on the register side and its-own-rendering on the canvas side.
*Resolution taken:* **flagged, not fixed.** The canvas is an S2 unit that
`check-m.sh` and `check-gate.sh` both read (CC-XA-01's tuple extraction stands
on it), and rewriting it inside S4 would risk two green suites to improve a line
no S4 assertion reads — the S4 ledger states the resolution exactly as §12.3
does. *Doc-first:* not a doc defect. **S2 fixture-consistency candidate**,
naturally paid at S5, where T-01 is the skill that lands a canvas.

**D19 · §12.2 compresses five of the six aspect gates into one sentence** ("the
remaining aspects clear over 07-08 → 07-10, Requirements last"). The exhibit
gives no evidence tables for Context, Value, Vision, Solution or Requirements.
*Resolution taken:* the fixture authors them, evidenced line-by-line against the
real artifacts in `fixtures/appointment-booking/project/` — including the two
locked conditionality notes, which is how AT-RQ-1's design-standards branch and
AT-RQ-4's "actor of ≥ 1 canvas Core Function line" get exercised at all. Marked
in the fixture header as the fixture's own, so nobody later reads them as
corpus text. *No erratum:* §12 is a running example, not a specification of six
tables.

### Open for the next session

S5 — Techniques I (`ba-t01`…`ba-t03` · the `ba-discovery` agent · `/ba-run`
dispatch proven). Inputs now in place: **`/ba-run`'s invocation contract**, which
fixes what a technique skill is dispatched with (a plan row with a pinned
`{expected · class · destination}` triple) and what it must return (the primary
output at its destination, plus routed findings and emitted signals as separate
things) — that is the interface every technique skill from S5 on implements ·
the **`## Frame` plans section**, which is where T-01's plan line and run log
land, and `/ba-frame` already dispatches T-01 by name on the canvas-absent
branch · the **post-run touchpoint**, so a technique's output is read against
the AT card the moment it lands, which is what makes S5's exit test ("Stakeholders
reaches `first-pass-cleared` with a §3.4 evidence table") reachable at all ·
`check-layout.sh` covers the new skills' frontmatter the moment they land, and
`check-orchestrator.sh`'s layering scan extends to them by adding a path.

One thing S5 inherits as work, not as input: **D18's canvas** — T-01 is the
skill that lands a canvas, so the fixture's §7 line is naturally reconciled
there rather than by an out-of-band edit.
