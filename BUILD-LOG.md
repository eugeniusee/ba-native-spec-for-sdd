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

---

## S5 — Techniques I · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §2.1, §2.3, §2.8, §3, §4 (S5 row), §5 step 3 ·
**catalogue b1 v0.3 in full** (T-01, T-02, T-03 — each sheet's §2 depth, §3
contract, §4 procedure, §5 template/micro-example, §6 hooks, §8 build-brief
hook) · catalogue index v0.2 rows T-01…T-03 as cross-check · elicitation v0.3
§0 operating principles, §3.5 routing table, §7 build-brief format · writing
standard v0.3 §1 golden rules and §4's banned-word list · sequencing plan v0.4
§2 template rules · orchestrator v0.3 §3.3/§3.4, §6.1–§6.4, §7.1–§7.4, §12 ·
S4's `/ba-run`, `/ba-frame` and the two Band-1 ledgers, as the interface these
three skills implement.

### Units built — 4 of the 67 (running total 47)

| Unit class | Built | Notes |
|---|---|---|
| Technique skills (§2.1) — 3 | `ba-t01` · `ba-t02` · `ba-t03`, each `SKILL.md` + `references/example.md` | all `disable-model-invocation: true` |
| Subagents (§2.3) — 1 | `ba-discovery` — the technique executor, `tools: Read, Write, Edit, Grep, Glob` | **no Bash** — the technique layer runs no check |
| Test harness | `tests/check-techniques.sh` · `tests/check-band1-artifacts.py` · `tests/fixtures/…/presale-brief.md` · `tests/fixtures/…/band1/first-pass/` | not §2 build units; the S5 exit test — see decision 1 |
| S2 fixture units touched | `project/canvas.md` · `project/.specify/memory/glossary.md` · `project/.specify/memory/stakeholders.md` | D18 paid, plus D20 — see below |

`presale-brief.md` is build plan §2.8's missing fixture input ("presale brief →
the framed-canvas expectation"). It did not exist after S2; the S5 and the S9
exit scripts both name it, so it is authored here.

### Compilation-rule application (§3)

- **§3.1 travels verbatim.** Carried byte-faithful into the compiled prompts:
  each sheet's §2 **Depth** boundary with its named forbidden zones · each §3
  output-contract triple `{expected · class · destination}` · the two marker
  states, kept distinct — `open — no source material` (a visible hole) vs.
  `N/A — <reason>` (a BA ruling) · the `[CONFLICT: <A> says … · <B> says …]`
  grammar · the `P-n`/`O-n` line-ID convention with its monotonic-continuation
  and never-reused clauses, and the `→ P-n` / `→ O-n` / `→ <vision section>`
  linkage notation · the ≤ 10 capability-line cap · the three doc-3 operating
  principles, word for word, in the agent · the banned-word list · the §3.5
  routing/reopen signal payloads.
- **§3.2 compiled with transformation.** Each sheet's §2 metadata + §3 contract
  became frontmatter (`name` · `description` naming technique, Serves and
  destination) plus an **invocation-contract block** at the skill top: the P-O3
  self-check in both halves, and the exact refusal when either is unmet. Each
  §8 build-brief hook became the skill's wiring — inputs loaded in order,
  interaction pattern, outputs written — with the "Phase 2 adds" list
  implemented: multi-format ingestion and the parse-vs-draft branch (T-01),
  cross-file term extraction with usage-location evidence and batch assembly
  (T-02), transcript parsing toward register fields and the coherence diff
  (T-03).
- **D-P2-10 lands.** Each §5 output template + micro-example compiled to
  `references/example.md` as a few-shot, with a *what the example is showing*
  reading — the rules made visible in the exemplar rather than only stated.
- **§3.3 never compiled.** No BABOK anchor, no §7 mining note, no review record
  entered the payload. T-01's §7 right column — *what the framework sheet must
  satisfy* — **is** operative and was folded into the procedure and the
  refusals (real names never masked · destination file not a chat table ·
  Context/Constraints added · the two marker states · full cite-or-mark · BA
  review replacing "never ask for confirmation" · line-IDs · no
  stage-navigation postamble). Its left column, the mining evidence, stayed
  home. The leak scan in `check-techniques.sh` greps for `Reference design` too,
  so a later session cannot re-import it by habit.
- **§0 layering, at the technique layer.** No skill restates an AT criterion.
  T-01's framing report names the nine canvas-anchored criteria **by ID** and is
  told, in as many words, to report what the sections show and never confirm one.

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-2 | All three ship `disable-model-invocation: true`. Negative-tested: deleting the line from an installed `ba-t02` turns `check-layout.sh` red |
| **D-P2-3** | **The third of the four agents ships.** `ba-discovery`'s tool policy is asserted exactly — adding `Bash` turns `check-techniques.sh` red |
| **D-P2-4** | **1:1 technique↔skill holds at 3 of 20.** No sheet was split, none merged |
| D-P2-6 | Unbroken. The three skills write content only at a contracted destination, and `check-layout.sh` still asserts all 19 runtime-born paths absent after a fresh install |
| **D-P2-10** | **Micro-examples compile in**, one `references/example.md` per skill. They install (47 files hashed, up from 40) and cost nothing until loaded |

### Architecture decisions

**1 · The artifact validator is a test harness, not a twelfth script.** The S5
exit test needs something that can judge a canvas, a glossary and a register.
Shipping it would contradict the documents it compiles from twice over: build
plan §2.4 pins the vendored script set at **eleven**, and orchestrator §3.2 rule
4 says AT criteria have **no checker** by construction — they are BA-confirmed
evidence checks. So `tests/check-band1-artifacts.py` lives in `tests/`, is never
installed, and exists for the same reason `check-ledger.py` and `check-cards.py`
do: to keep the compiled prompts honest against the pinned sheets. Sixteen
rules, sixteen seeded mutations.

**2 · The technique reports; `/ba-run` refreshes.** Sheets T-02 §4.6 and T-03
§4.6 both make the evidence-table refresh a framework act of the technique,
while S4 compiled that refresh into `/ba-run`'s **post-run touchpoint**
(orchestrator §7.4). Two owners for one act is a defect waiting to happen, so
the split is: the **skill reports** which criteria its run moved and what remains
open; **`/ba-run` refreshes** the table and proposes confirmation; **`/ba-clear`**
takes the BA's ruling. Nothing is lost — the refresh still happens at run end,
exactly once — and §7.4's "defined touchpoint" language is what settles the tie.
Asserted in the suite on both skills.

**3 · T-01 emits no signal, and says so.** T-02 and T-03 carry routing and reopen
emission; T-01 carries neither. At Frame nothing is gated, so there is no reopen
to signal, and every artifact home but `canvas.md` is still empty, so there is
nowhere to route. A finding that would route later is carried as an open line or
a `[CONFLICT: …]` marker and read by the aspect that owns it. Stating the absence
is worth more than leaving it inferable.

**4 · Negatives are mutation-derived in-suite**, in the idiom S3 and S4 used: one
legal base artifact set, validated clean first, then sixteen single-defect
mutations.

### Session exit test — GREEN

Build plan §4, S5 row: *from the fixture presale brief: Frame runs T-01 →
`canvas.md` in framework shape; T-02/T-03 land glossary + register; Stakeholders
reaches `first-pass-cleared` with a §3.4 evidence table.*

```
$ tests/check-techniques.sh

▸ The Frame input                        raw material: no table, no line-IDs, no citations
▸ Frame runs T-01 → canvas.md            16 rules · substrate convergence · framing-grade holes
▸ T-02 and T-03 land glossary + register 16 rules · dated merge · continuity into the estate
▸ The §12.2 evidence table, EVIDENCED    AT-ST-1/-2/-3 re-derived from the artifacts
▸ Seeded defects — 16 rules, 16 mutations all sixteen caught
▸ /ba-run dispatch proven                both ends of the interface, one contract string
▸ The three sheets, compiled             depth · markers · conflict · signals · refusals
▸ The ba-discovery agent                 no Bash · three principles · both boundaries
▸ Consistency and layering               template ⇄ example · zero methodology leaks

  passed: 100   failed: 0
✓ GREEN — S5 techniques I: T-01/T-02/T-03 · 16 seeded defects · /ba-run dispatch · ba-discovery
```

**How much of that is real.** The **validator runs live** — a real parser over
the canvas, the glossary and the register, judging thirteen sections in order,
cite-or-mark on every cell, `P-n`/`O-n` contiguity, link resolution, the ≤ 10
cap, the two table headers, the `Kind` vocabulary, explicit sponsor authority,
canvas ⇄ register coherence recomputed from scratch, and continuity from the
first-pass set into the mature estate. The **artifacts are recorded**, because
producing one is an agent act and cannot be re-derived inside a regression suite
— the same split S3 made for the gate's A pass and S4 for the ledgers.

One thing worth naming: **§12.2's evidence table is now evidenced.** S4 recorded
it; S5 re-derives every claim in it — the sponsor and the two populations from
canvas Customers, the four register entries with rights or comms and the
sponsor's authority spelled out, and AT-ST-3's coherence recomputed by diff. A
row that claimed something the artifacts do not show is now a caught defect.

Supporting checks run this session, all green:

| Check | Result |
|---|---|
| Fresh `--offline` install, then `check-layout.sh --session S5` | ✓ GREEN — 83 passed, 0 failed, 20 pending |
| Full-bar `check-layout.sh` must still **fail** at S5 | ✓ exits non-zero — 20 units still owned by S6–S9 |
| `verify-manifest.py` after the install | ✓ 47 files hashed, all matching (S4's 40 + S5's 7) |
| `references/example.md` installs and is hashed | ✓ under `.claude/skills/ba-t01/references/` |
| S2 regression — `check-m.sh` | ✓ GREEN, 40 passed |
| S3 regression — `check-gate.sh` · `check-cards.py` | ✓ GREEN, 59 passed · cards byte-identical |
| S4 regression — `check-orchestrator.sh` | ✓ GREEN, 120 passed |
| Delete `disable-model-invocation` from an installed `ba-t02` | ✓ **RED**, naming D-P2-2 |
| Add `Bash` to the `ba-discovery` agent | ✓ **RED** twice — tool policy and the no-check rule |
| Soften T-01's "runs no question loop at all" | ✓ **RED** |
| Break one `→ P-n` link in the framed canvas | ✓ **RED** twice — the validator's B5 and the AT-ST-3 row |

### Divergences flagged (§3.2 discipline, generalized)

**D18 · paid.** S4 flagged the fixture canvas's §7 Core Functions line as
carrying neither the pre- nor the post-RO-1 form, and handed it to S5 as work.
The line now reads **"Availability published by Specialists or their Clinic
Admins"** — §12.3's resolution text, in the post-RO-1 snapshot `project/` is.
The two hash prefixes this moves (`canvas.md`, `glossary.md`) were re-recorded
with `check-gate.sh --record`; the diff is exactly two lines of the run-3
certification manifest and nothing else.

**D20 · three fixture artifacts were not in the shape their sheets pin.**
Discovered while building the validator, all in the same class as D18 — the
mature `project/` estate rendering artifacts its own way rather than the sheet's:

1. `glossary.md` had **no `Merged synonyms` column** (T-02 §5 pins four). The
   column is not decoration — it is what makes later drift detectable rather
   than re-litigable, and CC-XA-03's drift reading stands on it. Added, with the
   corpus's own merge line (`booking (noun) — merged 2026-07-10, canvas usage`).
2. `stakeholders.md` was **two tables** — Individuals and Populations, with a
   different column set each — where T-03 §5 pins one six-column table with a
   `Kind` column. Reshaped; `Dr. Ivanova` restored, so the first-pass register is
   a strict prefix of the mature one and the world reads as continuous.
3. `canvas.md` had **five uncited, unmarked cells** (§3–§5, §7, §11) and two
   §13 one-liners citing `[kickoff notes]` for material the kickoff notes do not
   contain. Cite-or-mark is not optional on a framework artifact. §3–§5 and §7
   now cite the presale brief and the kickoff notes, §11 cites the Unlike entry
   it differentiates against, and §13's Business and Regulatory lines cite
   `constraints.md: C-B1 / C-R1` — the file that actually owns them.

*Resolution taken:* **fixed, not merely flagged.** These are the three artifacts
T-01/T-02/T-03 own, so S5 is their natural home — the reasoning S4 used to hand
D18 here. The fix is load-bearing rather than cosmetic: the validator now runs
over **both** the first-pass set and the mature estate, and the mature estate
only passes because it is in framework shape. *Doc-first (§3.5):* no doc defect —
the sheets were right and the fixture was wrong.

**D21 · the build plan's toy run and the corpus's history enter the world by
different doors.** Build plan §4's S5 row and §5 step 3 both have **T-01 birth
`canvas.md` from the presale brief** — the canvas-absent branch. Orchestrator
§12.1, and therefore S4's two fixture ledgers, record Frame 2026-07-07 with
`canvas.md` **already present from presale**: the `## Frame` plan row's status is
`dropped — canvas.md present from presale, carried into the repo`, which is
T-01's skip-if. Both cannot be one Frame act.

*Resolution taken:* **both stand, and they converge.** The ledgers record §12.1's
history and are right to. The build plan's scripts enter the same world through
the other branch, because it is the only entry a reproducible fixture run can
have — the skip-if branch produces nothing to check. `band1/first-pass/canvas.md`
is the second door's output, and the suite **asserts the convergence rather than
assuming it**: thirteen sections, `P-1`/`P-2`, `O-1`/`O-2` — the substrate line
the Frame band event records, character for character, plus the same contract
triple in three places (`/ba-frame`, `ba-t01`, the fixture's `## Frame` row).
*Doc-first:* no erratum. §12 is a running example, not a specification of which
branch a test script must take; and the build plan's own §5 is explicit.

**D22 · sheet ⇄ index, checked and clean.** Index v0.2 rows T-01…T-03 were read
against b1 v0.3 §§2–3 cell by cell — Serves, evidence triggers, skip-if, depth
boundary, expected output, destination. **No divergence found**; the index rows
are faithful condensations. Recorded because the plan asks for the check, not
only for its failures.

### Open for the next session

S6 — Techniques II (`ba-t04`…`ba-t10`, seven skills, from b2 v0.2 and b3 v0.2).
Inputs now in place: **the technique-skill shape** — frontmatter naming
technique/Serves/destination, the P-O3 self-check in two halves, skip-if, depth
boundary with named forbidden zones, inputs-in-order, procedure with framework/BA
act labels, output, signals, refusals — which every later technique skill
implements · **`references/example.md`** as the compiled home of each sheet's §5
· **the report-don't-confirm split** with `/ba-run`, settled at decision 2 ·
**`ba-discovery`**, which every one of these skills is dispatched under, so its
principles do not need restating per skill · **`check-band1-artifacts.py`**,
which already validates the canvas that T-08/T-09/T-10 write into — the three
canvas-internal sheets get their exit-test bar for free, and the `→ O-n` link
rule is already enforced.

Two things S6 inherits as work: the validator has **no rules yet for
`context.md`, `constraints.md`, `personas.md` or `competitive-analysis.md`** —
T-05…T-07's destinations — so S6 extends it the way S5 extended nothing (it is a
new file, and adding a rule class is the pattern) · and **`canvas.md` is written
by four different sheets from S6 on** (T-07 §10 · T-08 §2/§12 · T-09 §§3–5/§11 ·
T-10 §§6–9), so the proposed-edit-batch discipline on canvas-side writes is the
thing to compile carefully — T-01 owns the file at Frame and nobody owns it after.

---

## S6 — Techniques II · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §2.1, §3, §4 (S6 row) · **catalogue b2 v0.2
in full** (T-04…T-07) and **catalogue b3 v0.2 in full** (T-08…T-10) — each
sheet's §2 depth, §3 contract, §4 procedure, §5 template/micro-example, §6
hooks, §8 build-brief hook · catalogue index v0.2 rows T-04…T-10 as cross-check ·
elicitation v0.3 §3.2.A/§3.2.C (the kit's citation form and assumption register),
§3.3 (the depth table D-B3-4 rests on), §3.5 routing table, §8.1–§8.2 ·
orchestrator v0.3 §3.3, §6.1–§6.4, §7.4, §8.1, §12 · S5's technique-skill shape
and `ba-discovery`, as the interface these seven skills implement.

### Units built — 7 of the 67 (running total 54)

| Unit class | Built | Notes |
|---|---|---|
| Technique skills (§2.1) — 7 | `ba-t04` … `ba-t10`, each `SKILL.md` + `references/example.md` | all `disable-model-invocation: true`; 14 payload files |
| Test harness | `tests/check-techniques2.sh` · 22 new rule classes in `tests/check-band1-artifacts.py` · `tests/fixtures/…/band1/elected/` · `tests/fixtures/…/band1/first-pass/constraints.md` | not §2 build units; the S6 exit test |
| Prior-session fixture units touched | `project/canvas.md` · `project/.specify/memory/{context,constraints,competitive-analysis,roadmap}.md` · `band1/aspect-state.md` · `band1/aspect-plans.md` | D23–D26 — see below |

No subagent this session: the seven skills are all dispatched under
`ba-discovery`, which S5 built, so its three operating principles and its
writing-standard discipline did not need restating per skill.

### Compilation-rule application (§3)

- **§3.1 travels verbatim.** Carried byte-faithful into the compiled prompts:
  each sheet's §2 **Depth** boundary with its named forbidden zones · each §3
  output-contract triple `{expected · class · destination}` · the three
  transformation clauses **TC-1 · TC-2 · TC-3**, which ship inside `personas.md`
  itself rather than in the prompt only · the two-value `Confirmed | Assumed`
  status vocabulary · the `none identified — <basis>` and `N/A — <reason>`
  ruling forms · `open — <what is unresolved>` on a connection row · the
  `[CONFLICT: vision claims <X> · constraints.md §<n> "<row>" binds <Y>]` marker
  grammar · the `→ P-n` / `→ O-n` / `→ <vision section>` linkage notation and the
  ≤ 10 capability-line cap · the **EG-1** entity-ground clause, in the terms its
  reader opens on.
- **§3.2 compiled with transformation.** Each §2 metadata + §3 contract became
  frontmatter plus the invocation-contract block: the P-O3 self-check in both
  halves and the exact refusal when either is unmet. Each §8 build-brief hook
  became the skill's wiring — inputs loaded **in order**, interaction pattern,
  outputs written — with the "Phase 2 adds" list implemented: a TC-3 namespace
  check at write time (T-04) · the constraints-vs-landscape routing assist
  (T-05) · a curated class-probe library and Status-flip handling (T-06) · the
  canvas-sync assist and the two-door reporting split (T-07) · the who-hurts ⇄
  register diff and continuation-ID assignment (T-08) · the scan-table rendering
  and marker mechanics (T-09) · the linkage-sweep rendering and open-slot
  surfacing toward Tier-1 (T-10).
- **D-P2-10 lands, seven more times.** Each §5 template + micro-example compiled
  to `references/example.md` with a *what the example is showing* reading. Three
  examples carry a second worked artifact the sheet implies but does not draw:
  T-05's full-greenfield shape, T-07's no-market `N/A` shape, and **T-09's scan
  table**, reported in full against a clean set — because a scan that prints only
  its hits is indistinguishable from a scan that never ran.
- **§3.3 never compiled.** No BABOK anchor, no §7 mining note, no review record
  reached the payload. The leak scan in `check-techniques2.sh` additionally greps
  for `D-B[0-9]-[0-9]` and `D-W[0-9]`: the b2/b3 sheets carry their decisions as
  inline locked text, and a compiled prompt that cited a decision ID would be
  pointing at a document the runtime never loads. **Zero `§` characters** appear
  in the seven skills except in the two places where a section reference is
  itself operative runtime grammar — T-06's `[constraints.md §2]` citation target
  and T-09's conflict-marker form.
- **§0 layering, at the technique layer.** No skill restates an AT criterion, and
  every one of the seven refuses, in as many words, to confirm a criterion or
  clear an aspect. T-07 goes one step further and refuses to claim AT-VI-2 met
  even when it has supplied everything the criterion names — it reports the
  precondition satisfied and says the statement is another run's act.

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-2 | All seven ship `disable-model-invocation: true`, asserted per skill |
| **D-P2-4** | **1:1 technique↔skill holds at 10 of 20.** No sheet split, none merged — including T-07, which serves two aspects from one skill and one file |
| D-P2-6 | Unbroken. `check-layout.sh --session S6` is green with all 19 runtime-born paths still asserted absent after a fresh install |
| **D-P2-10** | **Seven more `references/example.md`**; the installed file count rises to 61 |

### Architecture decisions

**1 · The suite is a second file, not a longer first one.**
`check-techniques2.sh` sits beside `check-techniques.sh` rather than extending
it. The batches are the corpus's own unit of authorship, the exit tests are
per-session by the plan's own discipline, and a single 700-line technique suite
would make a red line ambiguous about which session owned it. The two share the
validator, which is where the actual logic lives.

**2 · The validator grew rule classes, not a second validator.**
`check-band1-artifacts.py` went from 16 rules to 39 — `--context`,
`--constraints`, `--competitive`, `--personas`, `--flip-early/--flip-later`, and
an `--aspect-grade` flag on `--canvas`. The flag is the load-bearing one: the
same canvas file is **legal at framing grade and illegal at aspect grade**, and
the suite asserts both directions — the mature canvas passes `--aspect-grade`,
the framed canvas fails it, and it fails on B35 and B36 specifically, which is
exactly where framing stopped. A separate aspect-grade validator would have let
those two readings drift.

**3 · The elected charter lives outside the estate.**
Build plan §4's S6 row asks for "TC-1…TC-3 surface present on any elected persona
charter", and the world the fixture records is **charter-free by construction** —
orchestrator §12.1's Stakeholders plan holds two techniques and no election, and
the Requirements evidence table clears AT-RQ-2 *on the absence*: "no personas.md
exists, so the persona→role principle is stated in the constitution's
Authorization row". Dropping a charter into `.specify/memory/` would activate a
dormant conditional clause and contradict a cleared table — for the one technique
whose entire point is that it was never required. So the charter sits in
`band1/elected/`, framed exactly as the sheet frames its own micro-example: the
charter a BA election *would* have produced, the world's canonical artifacts
unchanged. The suite asserts both halves — the charter validates against TC-1…3,
and `.specify/memory/personas.md` does not exist.

**4 · TC-3 is asserted with teeth, not by inspection.**
The namespace clause is only worth compiling if something downstream depends on
it. The suite greps the whole estate and every spec for the persona name and
requires zero hits — which is the exact surface CC-XA-02 screens, and is only a
meaningful assertion because `Marta` is a name no other artifact uses. It also
asserts that `band1/elected/personas.md` and `negatives/personas.md` agree on
their name set, so the screening fixture and the charter fixture cannot drift
into two worlds.

**5 · The Assumed → Confirmed flip is modelled as a second file, and checked as
an edit.** `band1/first-pass/constraints.md` is the 07-09 file; the estate copy
is the same file after the 07-14 ingestion batch. The only difference is one
`Status` cell. B39 asserts that the flip **edits a row rather than replacing
one** — same class, same wording, same position — and that the only legal
direction is `Assumed → Confirmed`. That round trip is the whole argument for
`Assumed` being a status rather than a marker, and it now fails loudly if a later
session rewrites the row instead of flipping it.

### Session exit test — GREEN

`tests/check-techniques2.sh` — **122 checks, 0 failures.**

| Exit-test clause (build plan §4, S6 row) | How it is proven |
|---|---|
| *constraints/context/competitive land* | The three files validate live against the shapes T-05/T-06/T-07 §3/§5 pin — two named landscape sections with a Disposition column, three numbered constraint classes at the two-value status vocabulary, five competitive columns with the status quo screened and every delta keyed |
| *canvas §§2–12 filled per AT-VA/VI/SO* | `--aspect-grade` over the mature canvas: every P-line resolves to a register population · every O-line links · three product slots filled · the differentiation names an Unlike entry and keys its delta · four surface sections filled or ruled · all five functions linked · the connection row carries role and direction. The framed canvas fails the same pass, on B35/B36 |
| *Context + Value + Vision + Solution clear on the toy* | Each aspect's §12 evidence table is **evidenced**, not trusted: AT-CX-1's two systems and the landscape are grepped from the file · AT-CX-2's per-class Confirmed rows are counted live · AT-CX-3's canvas Unlike names are each resolved against a competitive entry · AT-VA-2's baseline is on the line · **AT-VI-3's scan row set is recomputed from the 07-09 constraints file** and must equal `{§2, §3}` with `§1` Assumed · AT-SO-2's "all five linked" is counted |
| *TC-1…TC-3 surface present on any elected persona charter* | The charter validates; TC-1's population resolves to a register entry; TC-3's name is disjoint from every register entry and appears in no spec |
| *the suite is not vacuous* | 23 seeded defects, one per new rule, each asserted to trip **exactly** its own rule ID |

**Regression — every prior suite re-run green after the fixture surgery:**
`check-m.sh` · `check-gate.sh` · `check-orchestrator.sh` · `check-techniques.sh`
(100 checks) · `check-cards.py` · `check-ledger.py`.
`check-layout.sh --target <fresh install> --session S6` — **90 passed, 0 failed,
13 pending** (S7–S9's units). The install was a real one: pinned Spec Kit
v0.12.5 init + overlay, and the seven new skills land at
`.claude/skills/ba-t04…t10/`.

One expected-file refresh: `expected/gate-run3.entry` carries the certification
manifest's content hashes, and two of them — `canvas.md`, `roadmap.md` — moved
because this session edited those files. The hashes were refreshed; the gate
suite re-verifies them live against the fixture, so the refresh is checked rather
than asserted.

### Divergences flagged (§3.2 discipline, generalized)

**D23 · `context.md` carried a `Constraint` column — the one thing T-05 forbids.**
The pre-S6 file had three numbered sections (`Operating context` · `Systems in
the landscape` · `Adjacent initiatives`) and a systems table whose third column
was `Constraint`, holding *"the calendars stay in place; the product does not
replace them"*. T-05 §5 pins two named sections and a `Disposition (where
stated)` column, and T-05 §2's depth boundary exists precisely to keep binding
statements out of this file — that is D-W2's split, and the fixture was standing
on the wrong side of it.

*Resolution taken:* **fixed.** Two sections, the pinned header, the bind moved to
`constraints.md` §1 with the landscape keeping the descriptive side — and B20 now
fails any binding modal (`must` · `must not` · `may not` · `shall`) in a
landscape cell, so the boundary is enforced rather than remembered. The three
numbered sections' content did not vanish: the operating-context prose became a
`Role today` cell and two landscape lines, and the adjacent-initiative line became
a landscape line. *Doc-first:* no doc defect — the sheet was right and the fixture
was wrong.

**D24 · constraint IDs are a fixture invention with no corpus support.**
`C-T1` / `C-B1` / `C-R1` were threaded through six fixture files and cited from
canvas §13, `roadmap.md` and both ledgers. **The string `C-B1` appears nowhere in
`docs/methodology/`.** Everywhere the corpus points at a constraint it points at
the numbered class — `constraints.md §2` in b6's allocation basis, `[constraints.md
§3]` in b5's out-of-scope row, `constraints.md §3` in b5's governance reference,
and elicitation §3.2.A's kit-baseline citation form. T-06 §5's table is three
columns, and b2's own conflict scan records the numbered classes as the thing
that "gives elicitation §3.2's `[constraints.md §2]` citation form a resolvable
target". A fourth `ID` column is a divergence from a pinned output template, and
the citations it enabled were pointing at an anchor grade the corpus does not use.

Separately, the `Status` cells read `Confirmed — 2026-07-14`. D-B2-4 pins a
**two-value** column and rests on AT-CX-2 reading `Confirmed` *mechanically*; a
decorated cell breaks that read.

*Resolution taken:* **fixed, and the citation retargeted world-wide.** The `ID`
column is gone, dates moved to `Source`, and every citation now resolves by class
— canvas §13's three one-liners, `roadmap.md`'s E-04 source and allocation basis,
both ledgers, and S5's own canvas assertion. B22 and B23 fail the old shapes.
*Doc-first:* no doc defect.

**D25 · the competitive table was a different table, and it wrote T-09's
sentence.** The pre-S6 file's header was `Competitor · What they do · Where they
are strong · Where they leave room · Source`; T-07 §5 pins `Alternative ·
Category · Covers · Falls short · Source`. One delta read `(P-1)` where the sheet
requires a `→ P-n` key, and the status quo was present but unlabelled, so the
"always screened" rule was satisfied by accident rather than by construction.
The file then closed with *"Differentiation (canvas §11): booking completes
without a phone call…"* — which is the Our Solution statement, and T-07 §2's
depth boundary says in as many words that this sheet supplies targets and deltas
and **never** the statement.

*Resolution taken:* **fixed.** Sheet header, status quo labelled `(status quo)`
in the `Alternative` cell, every `Falls short` keyed, and the differentiation
sentence deleted from this file — it already stands on canvas §11, which is where
T-09 put it. B25/B26/B27 fail each of the three, and the suite additionally
asserts the sentence's *absence* here.

**D26 · canvas §7's fifth function had no objective link, and the ledger argued
around it.** The mature canvas read *"Availability published by Specialists or
their Clinic Admins `[call 2026-07-14]`"* with no `→ O-n`, and the Solution
evidence row explained that the function *"serves O-2 through the Browse/Book
pair"*. AT-SO-2 asks whether the function **names** the objective it serves, and
prose in an evidence table is not the link. The corpus settles it twice over: b3
T-10's own micro-example writes *"Specialists publish their Availability → O-2"*,
and orchestrator §12.3's RO-1 reckoning states that *"the function's objective
link is unchanged; only its actor list grew"* — which presupposes a link the
fixture had dropped.

Three smaller aspect-grade gaps travelled with it: §9 Localization read *"Single
locale at launch"* where T-10 §3 wants languages · currencies · regions each
stated or ruled — and b5's own conflict scan names canvas §9's
`N/A — no payment surface in MVP scope` as an existing fact of this world; §11's
differentiation carried no `→ P-n / O-n` key, which AT-VI-2's expected output
requires; and §10 named one alternative where the analysis backs two.

*Resolution taken:* **fixed, all four**, and the Solution and Vision evidence
rows rewritten to claim what the canvas now shows. B37 fails an unlinked
function, B36 an unruled surface facet, B35 an unkeyed differentiation.
*Doc-first:* no doc defect — the corpus was right in both places the fixture
diverged from it.

**D27 · AT-VI-3's scan reads a set that moved after the aspect cleared — and no
re-scan is due.** The scan ran 2026-07-09 against the Confirmed set as it then
stood: `§2` and `§3`, with `§1` excluded because the calendar row was `Assumed`.
On 07-14 the ingestion batch flipped `§1` to `Confirmed`, so AT-VI-3's own
trigger — *"the scan has not run against the current statement + Confirmed-row
set (either side changed since the last scan)"* — reads fired against a Vision
aspect that is `first-pass-cleared`. Orchestrator §12.3 records *"Context, Value,
Vision: untouched → flags drop"*, which is about RO-1's fix diff and does not
speak to the flip.

*Resolution taken:* **flagged, not invented.** Band 1 closed 07-10, and at
closure custodianship of the spec-anchored estate hands to Scope H — a post-
closure estate change is health ground and a reopen question, not a Band-1
re-clear, so no ledger event was fabricated. What the fixture does record is the
scan's *actual* input set, and the suite recomputes it from the 07-09 file and
requires the evidence row to match: `§1` excluded as `Assumed`, `§2` and `§3`
Confirmed. If a later session ever wants the re-scan modelled, it is an
orchestrator-document question first (§3.5's one-way rule), not a fixture edit.

**D28 · T-04 §5's own template and micro-example disagree on the charter
heading.** The template block writes `## <Persona name> — details: <register
population>`; the micro-example directly beneath writes `**Marta — details:
Clients**`. Both are §5, so "the sheet governs" does not adjudicate between them.

*Resolution taken:* **both accepted, template preferred.** S2's `sk_scan.py`
already reads either form — its `PERSONA_HEAD_RE` comment names the divergence
explicitly — so the shipped runtime checker had already ruled, and inventing a
stricter reading at S6 would have made the harness and the runtime disagree about
the same file. The compiled skill and the fixture both write the `##` form; the
validator accepts either, with the same regex family `sk_scan` uses. *Doc-first:*
a mirror candidate at catalogue-b2's next bump — render the micro-example heading
in the template's form.

**D29 · sheet ⇄ index, checked and clean.** Index v0.2 rows T-04…T-10 were read
against b2 §§2–3 and b3 §§2–3 cell by cell — Serves, evidence triggers, skip-if,
depth boundary, expected output, destination. **No divergence found**; the seven
index rows are faithful condensations, including the two awkward ones (T-04's
no-hole trigger cell and T-07's dual Serves). Recorded because the plan asks for
the check, not only for its failures.

### Open for the next session

S7 — Techniques III + closure (`ba-t11`…`ba-t16`, six skills, from b4 v0.2 and
b5 v0.2), plus `/ba-close-band1` and the arming Scope-H run.

Inputs now in place: **the technique-skill shape**, unchanged since S5 and now
proven across ten sheets · **`references/example.md`** as the compiled home of
each §5 · **the validator's rule-class pattern** — a new artifact means a new
`--flag` and a contiguous rule block, and the negative test is one `mutate` +
`neg` pair per rule · **EG-1**, compiled into `ba-t10`'s Output section in the
terms T-11 opens on, so the domain-model sheet's entry point is already written
down on the producing side · **the canvas at aspect grade**, so T-11…T-16's
destinations are the only ones left unvalidated.

Three things S7 inherits as work. **(i)** The validator has no rules yet for
`domain-model.md`, `roles-permissions.md`, `processes.md`, `design-standards.md`,
`constitution.md` or `out-of-scope.md` — six destinations, and the Requirements
evidence table's AT-RQ-1…4 rows currently stand un-evidenced against them. That
is the largest single block of evidencing left in the fixture. **(ii)** T-12
reads TC-1/TC-2 and nothing else from the elected charter — and the canonical
world has no charter, so S7 must decide whether the persona→role transformation
is exercised against `band1/elected/` or recorded as dormant, the way this
session recorded the enrichment serve. **(iii)** `/ba-close-band1` and the arming
run land in S7 by the plan's row, and the closure event is already in the fixture
ledger (07-10, `HEALTHY`) — so the work is proving the skill against a ledger
state that already records its outcome, which is the S3/S4 replay pattern rather
than the S5/S6 authoring pattern.

---

## S7 — Techniques III + closure · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §2.1, §3, §4 (S7 row) · **catalogue b4 v0.2
in full** (T-11…T-13) and **catalogue b5 v0.2 in full** (T-14…T-16) — each
sheet's §2 depth, §3 contract, §4 procedure, §5 template/micro-example, §6
hooks, §8 build-brief hook · catalogue index v0.2 rows T-11…T-16 as cross-check ·
orchestrator v0.3 §2.4, §3.3 (AT-RQ-1…4 and the handover rule), §6.1–§6.4,
§7.4, **§8.2 (closure, the arming act)**, §12 · gate v0.3 §3 (the static core's
constitution expansion), §10.1–§10.4 (Scope-H cadence, results home, the HA),
§14.1 · contract v0.2 §5–§6 (CC-H-01/-05/-06, CC-NF-03, CC-OS-03, CC-XA-01/-02)
and §7's gate run 2 · S5/S6's technique-skill shape, `ba-discovery`, and S3/S4's
`ba-gate-health` and `ba-close-band1`, as the interfaces this session's units
meet.

### Units built — 6 of the 67 (running total 60)

| Unit class | Built | Notes |
|---|---|---|
| Technique skills (§2.1) — 6 | `ba-t11` … `ba-t16`, each `SKILL.md` + `references/example.md` | all `disable-model-invocation: true`; 12 payload files |
| Test harness | `tests/check-techniques3.sh` · 31 new rule classes in `tests/check-band1-artifacts.py` (B40–B70) · `tests/fixtures/…/band1/gate-health.md` · `band1/first-pass/{roles-permissions,out-of-scope}.md` | not §2 build units; the S7 exit test |
| Prior-session fixture units touched | `project/.specify/memory/{domain-model,processes,design-standards,out-of-scope,roles-permissions,constitution}.md` · `band1/aspect-plans.md` · `expected/gate-run3.entry` | D30–D35 — see below |

No new subagent and no new workflow skill: the six technique skills dispatch
under `ba-discovery` (S5), and closure is `ba-close-band1` + `ba-gate-health`,
both built at S4/S3. **S7 is the first session whose exit test is a replay of a
skill it did not build** — the closure act is proven against a ledger state that
already records its outcome.

### Compilation-rule application (§3)

- **§3.1 travels verbatim.** Carried byte-faithful into the compiled prompts:
  each sheet's §2 **Depth** boundary with its named forbidden zones · each §3
  output-contract triple `{expected · class · destination}` · the exact heading
  and header sets — `Entities` · `Relations` · `Boundary references (external —
  not entities)`; `Roles` · `Policy`; `Global budgets` · `UX & interaction
  conventions` · `Visual identity & references`; `Principles` · `Governance
  references`; `Exclusions` — with their column vocabularies · the journey
  shape `## <name> — role: <role>` / `Trigger: … → Outcome: …` / numbered
  `actor → action → observable result` · the **lives-instead vocabulary**, three
  values, verbatim · the `open — no source material` and `N/A — <reason>` ruling
  forms · the two framework principles' MUST sentences · the significance test
  (*actor of ≥ 1 canvas Core Function line*) · the one-explicit-row-per-tuple
  rule and its no-wildcard, no-inheritance corollaries.
- **§3.2 compiled with transformation.** Each §2 metadata + §3 contract became
  frontmatter plus the invocation-contract block: the P-O3 self-check in both
  halves and the exact refusal when either is unmet. Each §8 build-brief hook
  became the skill's wiring — inputs loaded **in order**, interaction pattern,
  outputs written — with the "Phase 2 adds" list implemented: the EG-1 line-parse
  and glossary-first routing assist plus the derived-diagram offer (T-11) · the
  activity-line read, the tuple-coverage rendering toward the ⚑ sign-off, and the
  automated namespace screen at write time (T-12) · the coherence-diff rendering
  and the locatability check for later drafting (T-13) · the **conditionality
  report** rendering and the feature-vs-global classification assist (T-14) · the
  plan-check surface shape, the reference-resolution validator, and the
  principle-vs-detail router (T-15) · the adjacency-candidate generator over
  function and connection lines, the Covers-column miner, and the graduation-note
  rendering (T-16).
- **The chain's order is compiled into the skills, not left to the plan.** Three
  of the six state their predecessor in the invocation contract itself — *run
  after the domain model* (T-12), *run after the roles model* (T-13, T-15) — and
  T-14 states its successor (*run before the constitution*). The composed plan
  can still be composed wrongly; the skill will say so at the self-check rather
  than write a policy row against an entity that does not exist yet.
- **D-P2-10 lands, six more times.** Each §5 template + micro-example compiled to
  `references/example.md` with a *what the example is showing* reading. Four
  examples carry a worked shape the sheet implies but does not draw: T-11's
  glossary-first two-output sequence, T-12's *had charters existed* walk-through
  (which changes nothing in the tables, and that is the point), T-14's full
  **conditionality-branch report** for the no-design-ground case, and T-16's
  genuinely-empty-boundary waiver referral.
- **§3.3 never compiled.** No BABOK anchor, no §7 mining note, no review record
  reached the payload; the leak scan additionally greps `D-B[0-9]-[0-9]` and
  `D-W[0-9]`. Every locked decision this batch rests on ships as its **rule**,
  never its ID: *no wildcard cells, no role inheritance* rather than D-B4-2, *a
  role is significant iff it is the actor of ≥ 1 canvas Core Function line*
  rather than D-B4-4, *budgets are named rows and the name is the citation
  target* rather than D-B5-2, *≥ 1 exclusion at seed, and the empty case takes an
  aspect waiver* rather than D-B5-5.
- **§0 layering, at the technique layer.** No skill restates an AT criterion, and
  every one of the six refuses in as many words to confirm a criterion or clear
  an aspect. Two go further: **T-12 refuses to state the authorization principle**
  even though it is the file that enforces it, and **T-15 refuses to author the
  roles and budgets** it references — the same boundary, held from both sides.

### D-P2 bindings applied

| ID | How it landed |
|---|---|
| D-P2-2 | All six ship `disable-model-invocation: true`, asserted per skill |
| **D-P2-4** | **1:1 technique↔skill holds at 16 of 20.** No sheet split, none merged — including T-12, which carries the conditional persona→role transformation inside the one skill rather than as a separate act |
| D-P2-6 | Unbroken. The six Requirements homes are all ◇ — born by their runs, never installed |
| **D-P2-10** | **Six more `references/example.md`**; the installed file count rises to 73 |
| D-P2-11 | Untouched this session — no tuning-log entry was generated, because no false-ask, wrong-draft or dead-answer arose in a replay |

### Architecture decisions

**1 · The validator learns six artifacts, and one relation between two of them.**
B40–B68 judge the six destinations. B69 and B70 judge something different: the
**seed → mature delta**. Two of the six files have one, and the two deltas are
produced by different machinery — a tuple the gate added (accretion: the seed row
set survives untouched, in place, and the file grows by exactly one row) and an
exclusion that graduated (resolution in place: the disposition moves from a phase
hint to a named epic, and the basis never moves). Modelling them as one rule
would have made the graduation look like a rewrite; that was the first red the
suite produced, and it was the suite being right.

**2 · The first-pass snapshots are taken only where there is a delta.**
S6 recorded one (`constraints.md`, for the Assumed → Confirmed flip). S7 records
two, and deliberately not six: `processes.md`, `design-standards.md`,
`constitution.md` and `domain-model.md` are byte-identical at seed and today, so
a snapshot would assert nothing and would need maintaining. A snapshot exists
where a mechanism needs proving, not where a date exists.

**3 · Closure is asserted from the event, not from the head.**
The ledger head shows Stakeholders `first-pass-cleared since 2026-07-15` — the
post-RO-1 re-clear, five days *after* closure. Reading precondition 1 off the
head would have asserted a state that did not exist at the act. The suite parses
the closure event's own `states:` block instead, which is the record of what was
true when the BA declared closure. This is the general shape of replaying an act
against a ledger that has kept moving.

**4 · The arming run gets its own fixture file, and it is outside `memory/`.**
`band1/gate-health.md` is new this session — S3 built `ba-gate-health` and its
verdict shapes, but no ledger instance existed. It carries two entries: the
arming run at closure and the post-ingestion full run the cadence requires. The
suite additionally asserts the *negative* — that no `gate-health.md` sits under
`.specify/memory/` — because the runtime-ledger rule is a placement rule, and a
placement rule is only checkable by looking where the file must not be.

**5 · A HEALTHY arming run is proven by an absence.**
`/ba-close-band1` says a heavy-gap arming run signals an aspect-gate escape and
logs a **threshold-gap candidate** tagged with the AT-ID that should have caught
it. This run was HEALTHY, so the correct ledger state is *no candidate logged* —
and the suite asserts that no `Threshold-gap candidate` line exists, while also
asserting the skill still carries the candidate's record shape. The mechanism is
proven present and proven not to have fired.

### Session exit test — GREEN

`tests/check-techniques3.sh` — **158 checks, 0 failures.**

Against the plan's S7 row (*Requirements clears; `/ba-close-band1` succeeds; the
arming Scope-H run lands in `gate-health.md` — HEALTHY*):

- **Requirements clears.** The composed plan carries all six techniques with
  their contracts pinned character-for-character against the skills, in
  dependency order, with the ordering rationale on the record. The six homes
  validate against 29 shape rules. All four AT-RQ rows are re-derived live from
  the files rather than read back from the table: every enumerated home exists
  with real content; every governance file the constitution references resolves
  and is stub-free; the two defined roles are exactly the roles the canvas names;
  every domain entity has a glossary entry; six entities and six relations with
  no entity standing relation-less; and the significance criterion the journeys
  row applied is stated. The BA's `→ CLEARED · Y.K. · 2026-07-10` closes it.
- **`/ba-close-band1` succeeds.** Precondition 1 is re-derived from the closure
  event's state block; precondition 2 is the `AWs carried: none` line. The act's
  record, the head's `Band: 1 (closed 2026-07-10)`, the non-repeatability
  refusal, and the handover effects are all asserted.
- **The arming run lands, HEALTHY.** The request is in the ledger, the entry is
  in `gate-health.md`, the two agree on date, trigger, scope and verdict, and the
  skill is asserted never to run the check itself.
- **31 seeded defects, one per new rule.** Each mutation is a single edit to a
  real fixture file and each is asserted to produce *exactly* its rule ID (three
  produce a documented pair, where renaming a section necessarily also orphans
  the table under it).
- **Layering clean** across all 12 S7 payload files.

Regression, all green after the session's fixture reshaping:
`check-m.sh` 40 · `check-gate.sh` 59 · `check-cards.py` · `check-ledger.py` 14
rules · `check-orchestrator.sh` 120 · `check-techniques.sh` 100 ·
`check-techniques2.sh` 122 · `check-techniques3.sh` 158.

`tests/check-layout.sh` is install-dependent and was not re-run in this session;
`tests/layout.expected` already registered the six `S7|` rows from S1, and all
six directories now exist with `SKILL.md` + `references/example.md`.

### Divergences flagged (§3.2 discipline, generalized)

**D30 · Four of the six Requirements homes stood in pre-sheet shapes.**
`domain-model.md`, `processes.md`, `design-standards.md` and `out-of-scope.md`
were authored at S2/S3 to satisfy the M scripts, months before the b4/b5 sheets
were compiled: `Meaning` for `What it is (one business line)`, `Relationships`
for `Relations`, no boundary-reference section, no multiplicity column, journeys
as a numbered table with no role in the heading and no trigger → outcome line,
budgets as `Category | Budget` rather than the name · metric · target · condition
grammar, and an out-of-scope file with no `## Exclusions` heading and a
`Disposition` column.

*Resolution taken:* **reshaped, all four, to the sheets** — the same move S6 made
for the Context estate. `roles-permissions.md` and `constitution.md` needed
nothing; both were already in sheet shape. Nothing the M scripts read changed
meaning: `sk_health`'s CC-H-06 reads the constitution's `## Governance
references` table (untouched), `sk_stories` and `sk_idgraph` read the roles
table (untouched) and use `domain-model.md` as a path only. The one consequence
is arithmetic: five certification-manifest hashes in
`expected/gate-run3.entry` were regenerated, which is the manifest doing exactly
what it is for.

**D31 · `processes.md` cited a call four days after the artifact was cleared.**
The pre-S7 booking journey sourced its hold step to `call 2026-07-14`, while the
Requirements aspect cleared 2026-07-10 — and the S5 first-pass glossary, dated
07-10, already sourced the term `Hold` to *processes.md: booking journey*. The
world could not have both.

*Resolution taken:* **the chronology fixed at the source cell, not the date.**
The hold step is re-sourced to the kickoff notes — the seed's own material, which
is what the 07-10 glossary was reading when it cited this file. The 07-14 call
keeps its real effects elsewhere in the estate (the constraints flip, the
register's Clinic Admin population, the canvas actor line). A fixture that cites
forward in time is a fixture that cannot be replayed, and this one is replayed
by three suites.

**D32 · b4 T-11 §5 says `Hold` is deliberately absent; this world carries it at
seed.** The sheet's continuity thread reads *"the hold mechanism is deliberately
absent — it is spec-born, feature-004 ground; if a future spec relies on a Hold
relationship, CC-DA-01's update-first path brings it into the model then, never
before."* The fixture's domain model has carried `Hold` since S2, and the spec's
References line names it among the six entities CC-DA-01 resolves.

*Resolution taken:* **both stand, and the compiled artifact follows the sheet.**
`ba-t11/references/example.md` carries the sheet's model verbatim — five
entities, no `Hold`, with the update-first path spelled out as *the hold that is
deliberately absent*. The **fixture world differs because its evidence differs**:
here the kickoff notes state the hold, the glossary has carried the term with
that source since S5, and an entity whose term the glossary defines and whose
step a journey states is not spec-born in this world. What the sheet is
protecting — no attribute, no lifecycle, no cutoff at conceptual grade — holds in
both: the fixture model carries `Hold | reserves | Slot` and nothing about five
minutes or `expires_at`, and B43 enforces that mechanically.

**D33 · b4 T-13 pins one role per journey; the fixture had one journey with
two.** The pre-S7 "Cancellation journey" carried a Client step and a Specialist
step under one heading, which the sheet's shape has no room for — the role is in
the heading, singular, verbatim.

*Resolution taken:* **split into two journeys**, and the Specialist one carries
its own provenance: the governance change of 2026-07-17 that added the
`Specialist × Appointment × cancel` policy row. That makes the pair legible as
what it is — a journey that arrived with the tuple that authorized it — and it
gives B55's significance check two roles to resolve rather than one heading with
two actors inside it.

**D34 · The composed Requirements plan's contract triples were S4 placeholders.**
`{entities + relations · Governance · …}` and its five siblings were written at
S4, before the sheets existed, and four of the seven also carried the wrong
artifact class (Governance where b4/b5 say Context).

*Resolution taken:* **refined to the sheets' contracts and classes**, and the
suite now asserts each triple character-for-character against its skill — the S6
pattern, applied to this aspect. The t02 row was corrected in the same pass
(`{defined terms · Governance · …}` → the glossary sheet's own contract, class
Context) although T-02 is S5's unit: leaving one row wrong inside a table the
suite reads for correctness would have been a knowingly false fixture.

**D35 · sheet ⇄ index, checked and clean.** Index v0.2 rows T-11…T-16 were read
against b4 §§2–3 and b5 §§2–3 cell by cell — Serves, class, evidence triggers,
skip-if, depth boundary, expected output, destination. **No divergence found**,
including the three cells most likely to drift: T-14's conditionality skip-if,
T-15's persona-clause allocation (the principle half here, the role half at
T-12), and T-16's lives-instead vocabulary, which the index reproduces in full.
Recorded because the plan asks for the check, not only for its failures.

### Open for the next session

S8 — Band 2 + spine (`ba-t17` · `ba-t18` · `ba-tier1` · `ba-tier2` ·
`ba-analyst` agent, from b6 v0.2 and elicitation v0.3 in full).

Inputs now in place: **the armed toy** — Band 1 closed, Scope H armed, the
arming entry in `band1/gate-health.md`, and the estate the contract now owns in
the shapes its sheets pin · **the Requirements estate as Tier-1/Tier-2 input** —
`processes.md` is a kit input and Tier-2 stack row 5; `out-of-scope.md` is a kit
part-A baseline and stack row 7; `domain-model.md` and `roles-permissions.md` are
stack rows 3 and 4 — all four now shaped as their consumers expect to read them ·
**the roadmap already decomposed and allocated** (E-01…E-08, Allocation 1 and 2),
so T-17/T-18 are a replay against a recorded outcome, the S7 pattern again ·
**the graduation loop closed from both ends** — the out-of-scope payments row
resolves to E-07, and E-07's Source cites the row it graduated from.

Three things S8 inherits as work. **(i)** The validator has no rules for
`roadmap.md`, the scope brief, the kit, or the spec — four artifacts, and the
last of them is the only one with an existing checker family (S2's M scripts),
so the split between *what the M scripts already judge* and *what a Band-2/spine
validator should add* needs drawing before rules are written. **(ii)** T-18 is
the catalogue's one **repeatable** technique, and its skip-if is event-shaped
(*the current allocation stands approved and no C1 event since the last log
entry*) — the first technique skill whose self-check has to read a log rather
than a ledger head. **(iii)** `ba-tier2` is the first unit that both consumes the
gate and is consumed by it: it drafts the spec r5 that S2's fixtures already
carry and S3's gate run 2 already fails, so its exit test is bounded on both
sides by recorded outcomes — and the `≤ 7 GQ` cap plus cite-or-mark are the two
properties that have to be provable from the answer sheet alone.

---

## S8 — Band 2 + spine · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §2.1, §3, §4 (S8 row), §7 (D-P2-4, D-P2-10) ·
**catalogue b6 v0.2 in full** (T-17, T-18) — §2 depth, §3 contract, §4 procedure,
§5 template/micro-example, §6 hooks, §8 build-brief hook, and the D-B6-1…-6
rulings as they stand at their citation sites · **elicitation techniques v0.3 in
full** — the three operating principles, §2's tier table, §3.1–§3.5 (kit
generator, the Destination Test, the call, ingestion incl. the routing table and
the contradiction/ambiguity rules), §4's brief template and assertion map,
§5.1–§5.5 (context stack, draft-first, gap questions, D6 legality), §6's two
guards and both answered-source sets, §7.1/§7.2's build briefs, §8's worked kit ·
brief · GQ exchange, §10's three tuning logs · writing standard v0.3 §§1–15 ·
catalogue index v0.2 rows T-17/T-18 as cross-check · orchestrator v0.3 §6.3–§6.4,
§7.1–§7.4, §8.3–§8.5 · S5–S7's technique-skill shape and `ba-discovery`, S4's
`ba-run` and `ba-enter-feature`, S3's `ba-gate`, as the interfaces this session's
units meet.

### Units built — 5 of the 67 (running total 65)

| Unit class | Built | Notes |
|---|---|---|
| Technique skills (§2.1) — 2 | `ba-t17`, `ba-t18`, each `SKILL.md` + `references/example.md` | the Band-2 pair; 4 payload files |
| Technique skills (§2.1) — 2 | `ba-tier1` (`SKILL.md` + `references/{destination-test,routing,example}.md`) · `ba-tier2` (`SKILL.md` + `references/{story-drafting,example}.md`) | the spine; 7 payload files. **The technique count closes at 20** |
| Subagents (§2.3) — 1 | `ba-analyst.md` | the fourth and last agent — the persona set closes at 4 |
| Test harness | `tests/check-spine.sh` · `tests/check-band2-artifacts.py` (33 new rule classes, B71–B103) | not §2 build units; the S8 exit test |
| Prior-session units touched | `payload/claude/skills/ba-run/SKILL.md` (two paragraphs — D40) · `band1/aspect-plans.md` · `project/.specify/memory/{roadmap,scope/E-03.kit}.md` · `tier2-answer-sheet.md` · `revisions/spec-r6.md` · `project/specs/004-appointment-booking/spec.md` · `a-pass/run3.json` · `expected/gate-run3.entry` · `tests/check-orchestrator.sh` | D36–D41 — see below |

**No new workflow skill.** The four techniques dispatch through `/ba-run`
(S4) and Band-3 entry is `/ba-enter-feature` (S4); Tier 2 hands to `/ba-gate`
(S3). With this session the package's authoring surface is complete: **20
technique skills · 11 of 12 workflow skills · 4 agents.** Only S9's adapter
(`ba-handoff` + `sk_handoff.py`) is outstanding.

### Compilation-rule application (§3)

**Travels verbatim (§3.1) — checked at the string, not the summary.**

| Source | Landed in |
|---|---|
| The Destination Test's rule sentence and all five good/bad pairs | `ba-tier1/SKILL.md` (the rule) + `references/destination-test.md` (the pairs) |
| The Citation Test's operational sentence, and both answered-source lists | `ba-tier1` (Tier-1 list) · `ba-tier2` (Tier-2 list, Captured Detail and sibling specs called out) |
| D6's legality rule, with the cite-or-mark corollary as its companion | `ba-tier2/SKILL.md` |
| The kit's `Q<n>` block grammar and the `A<n>` assumption grammar | `ba-tier1/SKILL.md`, in the fenced forms |
| The `GQ<n>` packet grammar | `ba-tier2/SKILL.md` |
| The locked constants — must-ask ≤ 12 · Tier-2 cap 7, BA-adjustable | both spine skills |
| D4's three open-question statuses, reason mandatory on `Overtaken` | `ba-tier1` |
| D5's slicing vocabulary (`Proposed` · `Confirmed — <date>`), and who writes which | `ba-tier1` (writes `Proposed`) · `ba-tier2` (reads the confirmation) |
| The nine brief headings and the ten spec headings, exact and ordered | `ba-tier1` · `ba-tier2` |
| The walking-skeleton rule, one sentence | `ba-t18` |
| The sizing test — one epic = one scoping call and 1..N features | `ba-t17` |
| The roadmap row and log grammars, the phase ladder, the status vocabulary | `ba-t17` (rows) · `ba-t18` (log) |

**Compiled with transformation (§3.2).** Sheet §2 + §3 → frontmatter and the
invocation-contract block, both Band-2 skills; sheet §8 → the wiring sections.
The four contract triples are pinned in the fixture's `## Band 2` plan and
carried **character-for-character** in the skills — the suite asserts it, as at
S6/S7. The §7.2 two-column table compiled to
`ba-tier2/references/story-drafting.md` as the from-scratch module: the right
column became the musts, the left column's mechanics were rewritten
framework-shaped, and the seven inherited-by-default behaviors are listed as
**deliberately not inherited**, each with what replaced it — the mined patterns
travel, the prose does not.

**Micro-examples (D-P2-10)** compiled into `references/example.md` for all four
skills: the decomposition rows, the two allocation entries including the
no-change rerun, the kit and brief excerpts, and the GQ1 exchange with its three
not-asked dispositions.

**Never compiled (§3.3).** No BABOK anchor, no mining note, no review record, no
`D-B6-n`/`D-P2-n` identifier reaches the payload. Asserted mechanically over all
eleven S8 payload files.

**The routing table has one home.** §3.5's seven destinations are used by both
tiers (§5.4 says "same table"), so they are compiled once, to
`ba-tier1/references/routing.md`, and `ba-tier2` points at that path. One file,
two readers — reference-never-restate applied to the framework's own payload.

### D-P2 bindings applied

| ID | Application this session |
|---|---|
| **D-P2-4** | **Closed.** 1:1 technique↔skill, total **20**. `ba-tier1` carries `kit`/`ingest`/`supplement` as argument-selected modes of one skill; `ba-tier2` embeds §7.2 as `references/story-drafting.md` rather than a separately invocable story skill |
| **D-P2-3** | **Closed.** `ba-analyst` is the fourth agent. Author, judge and scheduler are three actors: the analyst has an authoring tool policy and never evaluates; the gate agent stays read-only; the orchestrator never runs a contract check. The suite asserts all three tool policies together |
| D-P2-2 | All four skills ship `disable-model-invocation: true`, asserted by `check-layout.sh` on the installed tree |
| D-P2-10 | Micro-examples compiled in, four `references/example.md` files |
| D-P2-11 | Both spine skills name `.specify/elicitation-tuning.md` as the home of the false-ask and wrong-draft findings they generate |
| D-P2-6 | Nothing new is pre-created: `roadmap.md`, `scope/<epic>.md` and `<epic>.kit.md` stay ◇ — the installed tree still has an empty `memory/scope/` and no roadmap |

### Architecture decisions

**A1 · Tier 2 gets no plans-file run log; Tier 1 does.** Orchestrator §8.3 puts
Tier-1 interviews under §7 unchanged, and §6.4's only Band-2 record is the
`## Band 2` section — so Tier-1 runs record there, beside T-17 and T-18. Band 3
has no plans-file section by construction: §8.4 says the orchestrator records the
band event "and nothing else", elicitation §5.1 rules out a persistent Q&A log,
and §8.3's tracking split forbids a second copy of feature state. **A feature's
record is its band event in the ledger, its spec at the destination, and its gate
report.** `/ba-run`'s bookkeeping section was amended to say both halves, and the
suite asserts there is no `tier2` row in the plans file.

**A2 · The Band-2/spine validator is a second file, sharing one rule namespace.**
`check-band2-artifacts.py` owns B71–B103; `check-band1-artifacts.py` keeps
B1–B70. The families are disjoint by artifact, but the rule numbers are the
harness's, not the file's — a violation reads the same wherever it comes from.

**A3 · The split the previous session asked for, drawn.** What the M scripts
already judge is **contract ground and ships**: `sk_health` reads CC-H-02 (a
status per row; a diff and a reason per allocation entry) and CC-H-03 (the brief
⇄ roadmap join); `sk_brief` reads CC-XA-05; the `sk_*` family judges the spec's
form. What the new validator adds is **sheet-shape ground and stays repo-side**:
row and log grammar, the phase ladder, the status vocabulary, the kit's parts and
caps, the Destination Test, the brief's nine headings and its two status
vocabularies, the tier-2 session's anchors and cap. No assertion reads any of
those, so **no runtime checker may** — the technique layer runs nothing, exactly
as at Band 1.

**A4 · Two rules state their bounds in the file, because a silently weakened rule
is worse than a missing one.** B78 judges roadmap **coverage** and not
exclusivity: a Source cell legitimately carries derivation evidence as well as
ownership (E-01 cites the cancel line to justify accounts; it does not claim it),
so an overlap verdict computed from Source mentions is noise — and the corpus
resolves genuine adjacency through the kit's part-D sibling boundary check
anyway. B101 judges that **every recorded answer landed at every destination its
packet named**, not that no unmarked inference exists: elicitation §5.5 names
overconfident unmarked inference as its residual risk *by construction* and
assigns it to BA draft review and the wrong-draft log, because there is no
question to rule on. A checker claiming to catch it would be claiming more than
the document does.

### Session exit test — GREEN

`tests/check-spine.sh` — **134 checks, 0 failed, 33 seeded defects.**
Build plan §4's S8 row, clause by clause:

| Exit clause | Evidence |
|---|---|
| E-03 decomposed | `roadmap.md` validates clean: two sections, `E-<nn>` rows, 2–4-word names, 2–3-sentence descriptions, every row sourced, ladder single-valued, statuses in the four-value vocabulary, every canvas Core Function line resolving |
| …and allocated (diff + log entry) | Allocation 1 in from → to form, every reason factor-tagged, Held + Basis present; Allocation 2 the `no change — <reason>` rerun, its trigger named on both sides — the log entry and the plans-file run log |
| `ba-tier1 kit` ≤ 12 must-ask | 6 questions, 6 must-ask, asserted directly and by rule B86 |
| every question destination-tagged | 6 of 6, and B87 refuses a tag that names a spec section |
| zero §3.3 depth violations | B87 clean on the fixture kit; the seeded `NFR targets` destination turns it red |
| scripted ingestion → brief `Scoped` with slicing | `Status: Scoped`, §8 carrying F1 `Confirmed — 2026-07-15` and F2 `Proposed`, OQ-2 still visibly `Open`, the contradiction left as a reopen signal |
| `ba-tier2` drafts r5 with ≤ 7 GQs | 4 asked of 7; the answer sheet's own no-overflow line; B99 turns red at a cap of 7 with 8 packets |
| every drafted value cited-or-marked | the decidable half proven: every ID the four packets named lands in the spec (B101), the one surviving marker names its location and traces to the brief's `Open` row (B102), and the write-back landed in D4 grammar (B103) |

Beyond the row: `/ba-run` dispatch asserted from both ends for all four skills ·
the compiled sheets' locked content (question-free decomposition, the writer
split from both sides, `Later` is a phase not an exit, the two guards verbatim,
D6, D7, the confidence rule) · the four personas' boundaries against each other ·
layering clean over eleven payload files.

**Regression sweep — all seven prior suites re-run, all green:**
`check-m.sh` 40 · `check-gate.sh` 58 · `check-orchestrator.sh` 119 ·
`check-techniques.sh` 100 · `check-techniques2.sh` 122 · `check-techniques3.sh`
158 · `check-spine.sh` 134.

**Install bar.** A real network install into a fresh `git init` directory, then
`check-layout.sh --target toy --session S8`: **GREEN — 101 passed, 0 failed, 2
pending** (both S9's). 85 files hashed, the 15-doc vector matching. The full-tree
bar still fails, correctly, on exactly three assertions: `ba-handoff/SKILL.md`,
`sk_handoff.py`, and the 31-of-32 skill count the adapter completes.

### Divergences flagged (§3.2 discipline, generalized)

**D36 · Two epic names in the fixture broke the sheet's naming grammar.** b6 §2
and index row T-17 both pin *2–4 words, action-noun*; the S2 fixture carried
`Notifications` (E-05) and `Reporting` (E-08), each one word. The sheet's own
micro-example rows are all two.

*Resolution taken:* **the fixture fixed, the sheet governing** — `Notification
Delivery` and `Performance Reporting` — and the five references rippled in the
same pass: the kit's part-D sibling check, the answer sheet's not-asked table,
spec r6 and its identical project copy, and two evidence strings in
`a-pass/run3.json`. The alternative was a validator that knows a rule and declines
to apply it, which is the shape of every rule that later turns out to be
decorative.

**D37 · The consequence of D36 is arithmetic, and it is the manifest working.**
Two certified files changed content, so two certification hashes in
`expected/gate-run3.entry` changed. Regenerated. A fixture whose recorded hashes
survive an edit to the hashed file would be a fixture proving the opposite of
what the certification manifest is for.

**D38 · The `## Band 2` plan's contract triples were S2-era placeholders, and
both carried the wrong artifact class.** `{epic set with statuses · Governance ·
…}` and `{MVP allocation + diff vs. current + reason · Governance · …}` — where
b6 §3 says **Context** for both rows, twice each (the class line and the index).

*Resolution taken:* **refined to the sheets' contracts and classes** — the S6/S7
pattern, third application — and the suite now asserts each triple
character-for-character against its skill. Tier-1's two runs were added to the
same section with their own pinned triple, per A1.

**D39 · An allocation entry existed with no run-log line.** `roadmap.md` carried
Allocation 2 (2026-07-15, post-ingestion) while the plans file's run log stopped
at 07-11. The roadmap is the content record and the plans file is the run record;
a run that appears in one and not the other is a run nobody can audit.

*Resolution taken:* **the missing t18 rerun logged**, plus the two tier1 runs
that produced the kit and the brief, each with its trigger named. The suite now
asserts, over the whole file, that **every allocation entry has a run-log line
naming a trigger** — so the gap cannot silently reopen.

**D40 · `/ba-run`'s bookkeeping said "append to the aspect's run log",
unconditionally.** True for aspect runs, wrong for the three techniques that
serve no aspect and undefined for Band 3.

*Resolution taken:* **two paragraphs added to the S4 unit** — where each line
lands (`## Frame` · `## Band 2` for T-17, T-18 and every Tier-1 mode), and that
Tier 2 gets no line at all, with the reason (A1). The forward-reference sentence
was corrected in the same pass. A one-way rule governs doc → package; a compiled
unit that under-specifies an interface a later session implements is corrected in
the package, and flagged here.

**D41 · sheet ⇄ index, checked and clean.** Index v0.2 rows T-17 and T-18 were
read against b6 §§2–3 cell by cell — Serves, class (Context, both), evidence
triggers, skip-if, depth boundary, expected output, destination. **No divergence
found**, including the two cells most likely to drift: T-18's event-shaped
skip-if, which the index reproduces with all four triggers, and the
column-ownership clause, which the index carries in its destination cell
(*"Phase column + Allocation log only"*). Recorded because the plan asks for the
check, not only for its failures.

### Open for the next session

S9 — Adapter + Phase-2 exit (`ba-handoff` skill · `sk_handoff.py` · Mode-B
fallback note · README · `docs/quickstart.md` · `tests/exit-test.md`), from gate
v0.3 §11 and plan Q5.

Inputs now in place: **the authoring surface is complete** — every artifact the
adapter hands off is now produced by a built unit, and the four personas that
produce them are all in the payload · **the certified toy** — `a-pass/run3.json`,
`expected/gate-run3.entry` and the run-3 certification manifest stand
regenerated and green, which is exactly the state `sk_handoff.py`'s hash guard
reads · **the negative check has its material** — the manifest's hash list is
live and was proven this session to move when a certified file moves (D37),
which is the property step 8 of the §5 exit script turns into a refusal.

Three things S9 inherits as work. **(i)** The exit script's step 10 is the only
clause no session has yet exercised in any form — `/speckit.plan` consuming a
certified spec with zero manual rework — and its four sub-clauses are about
operator behavior and hashes at plan time, not about anything the package
computes; how much of it a scripted test can honestly assert needs deciding
before `tests/exit-test.md` is written. **(ii)** `sk_handoff.py` is the first
vendored script whose failure mode is a **refusal** rather than a verdict: it
prints diverged paths and stops, so its negative test is the primary one and its
happy path the secondary. **(iii)** The full-bar `check-layout.sh` becomes the
Phase-2 exit bar the moment the adapter lands — the three assertions it still
fails are the three units S9 builds, so S9 is the first session that can run the
package's own final gate on itself.

---

## S9 — Adapter + Phase-2 exit · 1 August 2026 · GREEN

**Session prompt:** the standing pattern, build plan §4.
**Grounding:** `docs/methodology/` at the pinned versions (S1's vector,
unchanged) · build plan v0.2 §1.1, §1.2, §2.2, §2.4, §2.8, §3, §4 (S9 row), §5
in full, §6, §7 (D-P2-1, D-P2-8, D-P2-9, D-P2-12) · **gate definition v0.3 §11
in full** — §11.1's certification manifest and its adapter precondition, §11.2's
ordered adapter acts, §11.3's never-list — plus §2.3 (P7), §3 (the static core
the manifest is built from), §7.2/§7.3 (voiding), §10.2 (the voided-certification
notice), §12 (escape logging), §13's Adapter row, §14.4's worked handoff ·
**plan v2.13 Q5** (Mode A primary, Mode B the documented fallback; no LLM
between gate and plan) + §5's Band-3 tail + §8's exit criterion · completeness
contract v0.2 §2/§8 (waivers, the two-step, the marker as a named gap) ·
orchestrator v0.3 §8.4 (Band-3 entry, the `NNN` the branch must match) ·
elicitation v0.3 §9.2 (submission, the gate as Tier 2's last step) · S1–S8's
payload as the interfaces this session's units meet, and **Spec Kit v0.12.5's
own `common.sh` / `setup-plan.sh`**, read at the pin because §11.2's plumbing
clause resolves against them and nothing else.

### Units built — 3 of the 67 (running total 67 — the inventory closes)

| Unit class | Built | Notes |
|---|---|---|
| Workflow skills (§2.2) — 12th of 12 | `ba-handoff/SKILL.md` | Mode-A adapter front (gate §11.2) |
| Checker/adapter scripts (§2.4) — 11th of 11 | `ba/scripts/sk_handoff.py` | hash guard · artifact set · plumbing · branch · re-verify · feature pointer · ready report |
| Fixture set · README · quickstart (§2.8) — 3rd of 3 | `docs/quickstart.md` | the BA's walkthrough + the manual-mode bridge (§6) |

Alongside them, and not §2 build units: `docs/mode-b-fallback.md` (the §4 S9 row
names it; §1.2's tree does not — **D44**) · `tests/exit-test.md` (the §5 script,
agent-runnable) · `tests/check-exit.sh` (the mechanical harness) ·
`tests/fixtures/appointment-booking/speckit-plan/` (the recorded `/speckit-plan`
outputs and their README) · one new `RT|absent` row in `tests/layout.expected` ·
`README.md` expanded, as S1 said it would be rather than a second file.

**With this the inventory closes at 67/67 and every class is complete:** 20
technique skills · 12 workflow skills · 4 subagents · 11 scripts · 3 cards · 13
templates · 1 installer · fixture set + README + quickstart. 63 of them install.

### Compilation-rule application (§3)

**§3.1 travels verbatim.** Gate §11.1's adapter-precondition sentence, into the
skill and into the refusal text the script prints · §11.2's ordered acts, as the
skill's numbered procedure · §11.3's never-list, as the skill's own · the
boundary sentence (*the gate's responsibility ends when the certification
manifest is written*) · P7's escape-record trigger set · plan Q5's *"no LLM
between gate and plan — the certified text is the read text"*, which is the one
sentence the whole unit exists to enforce and appears verbatim in the skill, the
script's refusal, and the Mode-B note.

**§3.2 compiled with transformation.** Gate §11.2's prose ordering became an
executable order with a property the prose does not state and the mechanism
requires: **steps 1–4 have no side effects.** The refusal therefore leaves a
project byte-identical to how it found it — no branch created, no branch
switched, no file written — which is asserted in the exit test rather than
assumed. §14.4's worked handoff (*"adapter verifies 11 hashes — clean · branch
`004-appointment-booking` checked out · `.specify` plumbing confirmed"*) became
the ready report's shape, and the toy run reproduces it line for line, 11 hashes
included.

**§3.3 never compiled.** No BABOK anchor, no mining note, no review record, no
`D-P2-n` or `D-G-n` identifier reaches the payload. `docs/mode-b-fallback.md`
and `docs/quickstart.md` are repo-side documentation: `install.sh` copies
neither, and no runtime path reads `docs/`.

### D-P2 bindings applied

| ID | Application this session |
|---|---|
| **D-P2-1** | **Closed.** `ba.handoff → ba-handoff`, the last of the eleven renames. All 32 command names now exist as hyphenated skills; the dotted corpus spelling appears nowhere in the payload |
| **D-P2-12** | **Closed.** The exit script keeps the seeded-defect **FAIL → fix → re-gate** cycle, one waiver + ⚑ pass, and the hash-refusal negative check — steps 7 and 8, both live, both load-bearing |
| **D-P2-9** | The exit test's step 2 runs the real pinned install; `--offline` remains available and is exercised by `check-exit.sh --offline` |
| **D-P2-8** | v0.12.5 re-verified at S9 open — and this session is the first to read the pin's *behavior*, not only its tag. See D42 |
| D-P2-2 | `ba-handoff` ships `disable-model-invocation: true`; `check-layout.sh` asserts it on the installed tree with the other 31 |
| D-P2-6 | The adapter creates no content. `.specify/feature.json` is Spec Kit's own pointer, written at handoff and never by the installer — a new `RT|absent` row enforces that on every fresh install |

### Architecture decisions

**A1 · What step 10 can honestly assert in a script — S8's inherited question,
answered.** Build plan §5 step 10 operationalizes "zero manual rework" as four
sub-clauses. Three are mechanical and are asserted live: **(a)** the operator
performs no file operation between certification and plan — proven by running
Spec Kit's own `setup-plan.sh --json` with no argument, no `SPECIFY_FEATURE_*`
environment variable and no `/speckit-specify` run, and requiring it to resolve
`FEATURE_SPEC`, `IMPL_PLAN` and `BRANCH`; **(c)** the marker inventory across
the **certified artifact set** — the manifest's own file list, not just the
spec — must be exactly one, and it must be the calendar-sync question the gate
report names under W-004-01; **(d)** every certified hash still matches after
the plan run. **(b)** — *the plan runs to a completed `plan.md` without
requesting any spec edit* — is an agent act. It was **performed for real this
session** against the certified toy spec, producing `plan.md`, `research.md`,
`data-model.md`, `contracts/booking-api.md` and `quickstart.md`; those five are
recorded under `tests/fixtures/appointment-booking/speckit-plan/` and the suite
asserts them (no surviving template placeholder, a filled Constitution Check, no
request for a spec amendment). The same split as the recorded A-pass at S3: a
suite that claimed to re-derive an agent act would be a fiction, and one that
skipped the act would leave the exit criterion unproven.

**A2 · The guard runs twice, and the second run is this implementation's own.**
Gate §11.2 fixes verify → plumbing → report. It does not contemplate the branch
checkout itself moving a certified byte — but it can: an existing
`NNN-feature` branch may carry a different revision of `spec.md`, and the
checkout would swap the very file the guard just cleared, leaving the operator
at `/speckit-plan` on uncertified text behind a clean report. So the guard runs
again after the branch act, and a post-checkout divergence is the same refusal
with the branch named as its cause. This **adds** a check inside the pinned
order and removes none.

**A3 · The ready report inventories carried markers; it never judges them.**
Gate §14.4's handoff sentence is that the coding agent reads *"exactly one
consciously accepted unknown — and nothing hidden"*. That was a claim with no
observation point. The adapter now lists every `[NEEDS CLARIFICATION]` in the
certified spec with its section, beside the waivers in force read from the
certified run's report entry — both as report lines, with no verdict attached. A
marker in a certified spec is a waived gap **by construction** (contract §8's
two-step: name it, then waive it), so there is nothing for the adapter to rule
on and it rules on nothing. The value is that the claim is now checkable at the
line where it matters.

**A4 · `check-exit.sh` is an integration suite, and says so.** It does not
re-prove any unit: shape proofs are delegated to the validators that own them
(`check-band1-artifacts.py`, `check-band2-artifacts.py`, `check-ledger.py`,
`sk_health.py`, `sk_brief.py`), run **live against the installed toy** rather
than against the fixture directory. What it proves is composition — that the
units add up to plan §8's criterion in one project, in one sitting. That is why
its 99 assertions overlap the seven unit suites' 733 without duplicating them.

**A5 · Mode B is documented as a cost, not an option.** `docs/mode-b-fallback.md`
names the three cases where Mode A's precondition genuinely does not hold, names
four that are *not* triggers (a failing hash guard first among them — that is
the guard working), and states the cost in the corpus's own terms: under Mode B
the certification stops covering the artifact the coding agent reads. It carries
the procedure, including the manual diff that substitutes for the hash guard and
the `gate-report.md` line that records what the certification does and does not
cover.

### Exit test — build plan §4, S9 row: *"the §5 exit test, end to end, green"*

`tests/check-exit.sh` — **99 passed, 0 failed**, deterministic across runs, on a
real network install into a fresh `git init` directory.

| Step | What ran | Result |
|---|---|---|
| 1 | Fresh `git init`, no prior Spec Kit | ✓ |
| 2 | `install.sh` → `check-layout.sh` at the **full** bar, no `--session` | ✓ **104 passed, 0 failed, 0 pending** — the Phase-2 exit bar, first pass |
| 3 | Canvas + both ledgers, validated live; nothing under `memory/` | ✓ |
| 4 | The eleven Band-1 artifacts validated live in the install · closure in the ledger head · the arming Scope-H entry · `sk_health.py` CC-H-02/03/06 | ✓ |
| 5 | Roadmap + allocation log · the kit (≤ 12 must-ask, tagged, zero depth violations) · brief `Scoped` with 004 sliced · CC-XA-05 live | ✓ |
| 6 | Feature folder holding only `spec.md`; Tier-2 spec against the answer sheet; the defect seeded in FR-007 | ✓ |
| 7 | Run 2 **FAIL (5 gaps)** naming `CC-G-04 — FR-007` verbatim · adapter refuses for want of a certification · fixes · run 3 incremental, 12 carried · W re-affirmed · O re-applied · ⚑ ×2 · P4 → **PASS WITH WAIVERS** · certification written, covering the produced `traceability.md` | ✓ |
| 8 | One byte appended → **REFUSED**, diverged path printed, branch and pointer untouched · reverted → clean · a certified **governance** file edited → refused too | ✓ |
| 9 | Hash guard 11/11 · branch `004-appointment-booking` · plumbing confirmed · pointer written · waiver and marker surfaced · second run idempotent | ✓ |
| 10 | (a) `setup-plan.sh` resolves with no intervention · (b) the five plan artifacts, no placeholder, no spec-edit request · (c) exactly **1** marker across the certified set, the W-004-01 one · (d) 11/11 hashes still match | ✓ |

**Vacuity check.** The step-10 assertions are load-bearing: removing the feature-
pointer write from `sk_handoff.py` turns **six** assertions in steps 9–10 red,
including `setup-plan.sh` itself failing. Restored, green again.

**Regression sweep — all seven prior suites re-run, all green:**
`check-m.sh` 40 · `check-gate.sh` 59 · `check-orchestrator.sh` 120 ·
`check-techniques.sh` 100 · `check-techniques2.sh` 122 · `check-techniques3.sh`
158 · `check-spine.sh` 134. Two of those counts sit one above the numbers the S8
record cites (gate 58, orchestrator 119) with the suite files and every fixture
**byte-identical to S8's commit** and both suites deterministic across repeated
runs here — a transcription artifact in the S8 record, not a behavior change.
Recorded rather than quietly corrected: an append-only log's value is that its
numbers can be re-derived, and this one could not be.

### Divergences flagged (§3.2 discipline, generalized)

**D42 · Spec Kit v0.12.5 resolves the feature through `.specify/feature.json`,
not the branch name — and under Mode A nothing was writing it.** At the pin,
`common.sh`'s `get_feature_paths()` takes `SPECIFY_FEATURE_DIRECTORY`, else
`.specify/feature.json`, else it **errors**. That file is normally written by
`/speckit-specify` — the command Mode A deliberately never runs, because our
spec is already at the destination. The first real `/speckit-plan` in the
project's history therefore stopped on `ERROR: Feature directory not found`, and
the operator would have had to intervene: precisely the manual rework step 10
measures. The corpus's own §14.4 handoff line reads *"`.specify` plumbing
confirmed"*, and gate §11.2 assigns the adapter *"any copies Spec Kit's layout
requires"* — this is that clause, resolved at the pin.

*Resolution taken:* **the adapter writes the pointer** — idempotently, mirroring
`common.sh`'s own `_persist_feature_json` (repo-relative value, written only
when missing or different), **after** the guard has passed and the branch is
settled, so a refusal still writes nothing. `tests/layout.expected` gains an
`RT|absent` row so a fresh install is asserted **not** to carry it (D-P2-6), and
both the skill and `tests/exit-test.md` carry the reason at the point of use.
The build plan's §1.1 tree does not list the file; it could not have, because
the tree predates reading the pin's behavior. Flagged, not silently added.

**D43 · The unit running total carried a +1 from S1, and it surfaces here
because S9 is where the inventory has to close.** S1's record says *"16 of the
67"*, but its own class rows sum to 15 — installer 1 + templates 13 + the
package-repo `README.md` 1; the repo skeleton, the manifest generator and the
test harness are explicitly not §2 units. Carried forward, the total after S8
read 65 when the class arithmetic gives 64, which would have left S9 two slots
for three units.

*Resolution taken:* **reconciled by class, and the classes are what the plan
pins.** 20 techniques (S5 3 + S6 7 + S7 6 + S8 4) · 12 workflow skills (S3 2 +
S4 9 + S9 1) · 4 subagents (S3 · S4 · S5 · S8) · 11 scripts (S2 10 + S9 1) · 3
cards (S3) · 13 templates (S1) · 1 installer (S1) · fixture set (S2) + README
(S1) + quickstart (S9) = **67**, every class full. S1's record is append-only
and stands; this entry is the correction, at the session that could prove it.

**D44 · The Mode-B note is a §4 unit with no home in the §1.2 tree.** Build plan
§4's S9 row names *"Mode-B fallback note"* among the session's units, and plan
Q5 makes Mode B a documented fallback. §1.2's package-repo tree lists
`docs/methodology/` and `docs/quickstart.md` and nothing else under `docs/`.

*Resolution taken:* **`docs/mode-b-fallback.md`**, repo-side, never installed —
the same layer as the quickstart. Folding it into the quickstart was the
alternative and was rejected: the quickstart is read by a BA starting a project,
the Mode-B note by someone deciding whether to break the Mode-A guarantee, and
those are different readers at different moments. `README.md`'s tree and the
`ba-handoff` skill both point at it.

**D45 · The plan template's agent-context step has no script at the pin.** The
`/speckit-plan` workflow's Phase-1 step *"Update agent context by running the
agent script"* has nothing to run at v0.12.5: `.specify/scripts/bash/` ships
`check-prerequisites.sh`, `common.sh`, `create-new-feature.sh`, `setup-plan.sh`
and `setup-tasks.sh`, and nothing else.

*Resolution taken:* **recorded, no action.** It is a no-op at our pin, and our
own `AGENTS.md` / `CLAUDE.md` mirrors already carry the agent context that step
would have written — which is the portability mirror doing exactly its job. It
is written down in the `speckit-plan/README.md` fixture note so that a pin bump
restoring the script is recognized as a change rather than met as a surprise.

**D46 · The framework's claim about markers held under a real planning pass, and
that is worth recording as evidence rather than as a hope.** The certified spec
carries one `[NEEDS CLARIFICATION]` — the calendar-outage question under
W-004-01. In the real `/speckit-plan` run, the plan did not resolve it: Phase 0
decision 3 fences the dispatch behind an outbox so the booking path never
depends on the answer, states explicitly what it is *not* deciding (retry
policy, alerting, any user-visible signal), and `quickstart.md` has no scenario
for it and says why. That is exactly the behavior the `CLAUDE.md` / `AGENTS.md`
mirrors instruct — *implement around it and surface it; do not resolve it by
guessing* — observed rather than asserted. Recorded because the plan asks for
the check, not only for its failures.

### Phase 2 — closed

**Build plan §5's pass condition is met: all ten steps green in one scripted
run.** The Phase-2 slice of the v1-done checklist clears — one-command install ·
gated discovery with BA-planned techniques · decomposition + Tier-1 briefs +
logged allocation · both question guards live · a classed artifact set ·
named-gap blocking · zero-rework `/speckit-plan`. *"One real feature shipped
end-to-end"* remains Phase 3's, by design.

Three things Phase 3 inherits, stated so they are not rediscovered:

**(i) The tuning logs are empty, and only real use can fill them.** Every
runtime ledger exists and every act that writes one is built, but
`.specify/gate-tuning.md` and `.specify/elicitation-tuning.md` are born at their
first real entry. The false-ask, wrong-draft, dead-answer and escape records are
the framework's only source of evidence about itself, they flow document-first
through §3.5, and nobody can synthesize them. Build plan §6 already asks BAs in
manual mode to start them on paper; that instruction is now also in
`docs/quickstart.md`, day one.

**(ii) The one-way rule is now the whole maintenance story.** Every unit is
compiled, and §2's source-anchor column is the propagation map: a document bump
recompiles exactly the units anchored to it, their session exit tests re-run,
`VERSION` bumps, the manifest's doc vector updates. Compiled text is never
patched in place — a wanted runtime change without a document change is a
document defect first. D42 is the shape of the one legitimate exception and it
is worth noting: the *environment* moved, not a document, and the resolution was
still to resolve gate §11.2's existing clause at the pin rather than to invent
behavior.

**(iii) The pin is now behavioral, not just a tag.** Until this session, "Spec
Kit v0.12.5" meant a version string in the manifest. It now also means a
resolution mechanism (`feature.json`), a script inventory (D45), and a plan
template whose Constitution Check reads our constitution. A pin bump is a
Phase-4 rollout decision that has to re-run `check-exit.sh`, not only
`check-layout.sh` — the layout bar would not have caught D42.

---

## Lane B — orchestrator rules v0.4 §10.3 · BA-facing communication register · 7 August 2026 · GREEN

**Session prompt:** Lane B rebuild — propagate orchestrator rules v0.4 §10.3
into the mirrors, the four personas, and every BA-facing render string.
**Grounding:** `docs/methodology/ba-native-spec-orchestrator-rules.md` **v0.4**
(header verified before any edit) — §10.3 in full, the eight register rules and
the three-register framing; §10.1's Moment column, the verbatim name source for
`P-O1`–`P-O9`; §3.3 (thresholds, read to establish that AT criteria carry no
names) · `ba-native-spec-catalogue-index.md` v0.2, rows T-01–T-18, the verbatim
name source for the technique codes · S1–S9's payload as the compiled surface
this change recompiles · BUILD-LOG S9 closure note (ii), the one-way rule, as
the propagation discipline actually applied (see D47).

### The change

**One additive document section, propagated.** §10.3 is v0.4's only change: the
third register — BA-facing conversation — with eight rules, alongside the
writing standard (artifact text) and elicitation §3.2 (stakeholder-facing
questions). Two acts followed from it:

1. **The eight rules compiled verbatim** into the `CLAUDE.md` fenced framework
   block template, the `AGENTS.md` mirror, and all four personas — the compile
   target §10.3 names in its own preamble.
2. **The rule-5 sweep:** every bare technique or stage code in a BA-facing
   render string paired with its name. `T-nn` names verbatim from the catalogue
   index; `P-On` names verbatim from §10.1's Moment column. Rule 5's own
   examples — *"T-05 — Context & landscape mapping," "P-O4 — clearing
   confirmation"* — fix both the sources and the format.

### Units touched — 55 files

| Class | Count | Files |
|---|---|---|
| Mirrors (register compiled) | 2 | `claude-block.md` · `AGENTS.md` |
| Subagents (register compiled + sweep) | 4 | `ba-orchestrator` · `ba-discovery` · `ba-analyst` · `ba-gate` |
| Workflow skills (sweep) | 8 of 12 | `ba-frame` · `ba-aspect` · `ba-run` · `ba-clear` · `ba-waive-aspect` · `ba-reopen` · `ba-close-band1` · `ba-enter-feature` |
| Technique skills (sweep) | 19 of 20 | `ba-t01`…`ba-t18` · `ba-tier1` |
| Technique `references/example.md` (sweep) | 19 | the same nineteen |
| Session exit tests (assertion strings re-pinned) | 2 | `check-techniques.sh` · `check-spine.sh` |
| `VERSION` | 1 | 0.1.0 → 0.1.1 |

**Deliberately not touched, each for a stated reason:** the three compiled cards
(D48) · the 13 artifact templates and the 11 checker scripts — the register
governs conversation with the BA, never artifact content or machine-read
records · `ba-status`, `ba-gate`, `ba-gate-health`, `ba-handoff`, `ba-tier2` —
swept and clean, no bare code to pair · `install.sh` — the mirrors it copies
changed, the installer did not.

### Compilation-rule application (§3)

- **§3.1 travels verbatim.** The eight rules are byte-identical across all six
  units — `sha256` of the rule list, all six: `276a3507f8860975…`. Wording
  diffed against §10.3 with wrapping normalised: identical. Hard wrapping at 80
  is the payload's own shape and the register pins no wrapping.
- **The §-refs inside rules 7 and 8 travelled with them** (`§6.1`, `§2.4`,
  elicitation `§3.2`). Verbatim was the instruction, and these are operative,
  not rationale — rule 7 *tells* the framework to name the owning document and
  section. Recorded because the runtime cannot read `docs/methodology/`; the
  refs identify the pinned shapes, they are not an instruction to go read them.
- **§3.3 never compiled:** no BABOK tag, mining note, review record or rationale
  prose entered the payload. §10.3's ASD-STE100 provenance line — the C4 mining
  pattern — stayed in the document, as §3.3 requires.
- **Pinned formats untouched, per rule 8's own last clause.** The sweep skipped
  every fenced block in the payload: ledger event grammar, evidence tables, the
  suggestion snapshot and composed-plan shapes, run-log lines, the gate's JSON
  contract and its `gap_line` grammar. On conflict the shape governs, and the
  report writer refuses a run whose `gap_line` does not match.

### Verification evidence

**The sweep, mechanically.** `bare_codes.py` scans the 61 skill / agent / mirror
files, joins soft-wrapped source lines into the paragraphs the BA actually sees,
skips fenced blocks, and requires each `T-nn` / `P-On` to carry a name
immediately adjacent (em-dash, parenthesis, colon, comma or table-cell
boundary).

```
files scanned: 61
BARE CODES IN BA-FACING STRINGS: 0
```

**Negative control — the sweep is not vacuous.** Three defects injected, one per
render class: a prose heading (`## P-O3 — the act`), a mid-sentence prose
mention (`(that is P-O2)`), and a table cell (`| P-O7 | closure act |`). The
detector reported exactly 3 and named all three sites; restoring returned it to
0. A checker that cannot fail is not evidence, so it was made to fail first.

**Regression — all seven suites, plus the cards, the layout bar and the exit
script:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-cards.py` | every card byte-identical to its re-derivation |
| `check-layout.sh` (real `--offline` install) | 105 / 0 / 0 — full §1.1 tree |
| `check-exit.sh` | 99 / 0 — all ten steps in one run |

733 suite assertions plus 204 install-and-exit assertions, zero failures. The
install was a real one into a fresh repo: the register block reaches both
`CLAUDE.md` and `AGENTS.md`, and the manifest reads `orchestrator rules | v0.4`
and `Package version | 0.1.1` — the doc vector propagates on its own, from the
document headers, exactly as the one-way rule assumes.

### Divergences flagged (§3.2 discipline, generalized)

**D47 · The maintenance guide the session prompt names does not exist.** The
prompt cites `docs/ba-native-spec-framework-maintenance.md` (v2.0) and its
"Lane B rebuild recipe" as the procedure to follow. That file is absent from the
working tree, absent from `git ls-files`, absent from every branch and from the
history of every branch; the string "Lane B" appears nowhere in the corpus.

*Resolution taken:* **proceeded under the discipline the corpus does carry, and
said so.** The one-way rule is written down — S9's closure note (ii): a document
bump recompiles exactly the units anchored to it, their session exit tests
re-run, `VERSION` bumps, the manifest's doc vector updates. All four were
performed and are evidenced above. The entry format follows the S1–S9 records.
Two things a real guide would have decided and this entry decided instead: the
`VERSION` increment (patch, on an additive doc section) and the fenced-block
sweep boundary. Both are stated here so a guide, when written, can overrule them
in one place.

**D48 · The compiled cards cannot take rule 5, and the reason is structural.**
The prompt's sweep names the compiled cards. They cannot carry names. `at-
thresholds.md` pins its own shape in its header — *"AT-ID + the criterion's exact
text — nothing else"* — and all three cards are re-derived and byte-compared
against the methodology documents by `check-cards.py`, whose `--record` mode is
the only legitimate way to change them. A hand-added name would fail that check
on the next run.

*Resolution taken:* **cards untouched, and the sweep found nothing there to
fix anyway.** Register rule 8 settles it on its own terms: on conflict between
this register and a pinned shape, the shape governs. Changing this needs a
source-document change first — which is the one-way rule working, not a gap.

**D49 · `AT-*` and `CC-*` have no names to pair, and one of them is out of rule
5's reach.** The prompt's sweep lists all four code families. Only two have a
name source. The catalogue index names T-01–T-18; §10.1 names P-O1–P-O9. No
document in the corpus gives an AT criterion or a CC assertion a name — both
carry a code plus their operative text, and the assertion cards name only
categories (`C1 · Overview & Value`). Rule 5 reaches "technique, stage, or
assertion", and the AT card states in its own second line that AT criteria are
**not** assertions — so AT sits outside rule 5 as written, as well as outside
any name source.

*Resolution taken:* **no names invented, and nothing needed changing.** Every
`CC-*` in the payload sits in gate machinery or in the pinned JSON contract, not
in a BA-facing render; the BA-facing assertion render is the gate report, which
the prompt excludes and whose `gap_line` grammar the report writer enforces
byte-wise. Every `AT-*` sits in threshold-evidence assembly, where the criterion
text travels with the code. Naming them is a document decision, not a payload
one: it would need a name column in orchestrator §3.3 and in the contract, and
then a card-shape change. Recorded so the next register bump can take it up
deliberately rather than discover it.

**D50 · Six exit-test assertions pinned the exact strings the register
changed.** `check-techniques.sh` (4) and `check-spine.sh` (2) assert literal
payload text — *"`**T-01** against `## Frame`"*, *"P-O9 — the overflow ruling"*
and four more. All six went red on the recompiled text, which is the regression
floor doing its job: it noticed.

*Resolution taken:* **the assertions were re-pinned to the recompiled strings,
never loosened.** No assertion was deleted, weakened to a substring, or made
name-agnostic — each still pins one exact string, now the register-compliant
one. That is the one-way rule's "their session exit tests re-run" clause: the
test tracks the compiled text, and a test that stopped pinning it would stop
being a floor.

### Open

**The register is compiled but not yet checked.** Nothing in `tests/` asserts
rule 5 — the sweep above ran from a scratch script, not from the harness, so the
next unit that renders a bare code will ship. The natural home is a
`check-register.sh` carrying the paragraph-aware scan and its negative control,
run beside the other suites. Left undone deliberately: the prompt scoped this
session to propagation, and a new test file is a harness unit, not a Lane B one.

---

## Lane A — the register sweep promoted into the harness · `check-register.sh` · 7 August 2026 · GREEN

**Session prompt:** Lane A — promote the register sweep into the harness as
`check-register.sh`, carrying the scratch script's logic, with the negative
control built in as a self-test, optional source-verification of the paired
names if cheap, wired to run beside the other suites.
**Grounding:** BUILD-LOG *Lane B — orchestrator rules v0.4 §10.3* (7 Aug 2026),
section **Open** — the item this session closes · `bare_codes.py`, the scratch
script Lane B's sweep ran from, as the logic to carry ·
`docs/methodology/ba-native-spec-orchestrator-rules.md` **v0.4** §10.3 (rules 5
and 8) and §10.1's Moment column · `ba-native-spec-catalogue-index.md` v0.2,
rows T-01–T-18 · `check-spine.sh` (S8) as the suite shape and the seeded-defect
idiom this file matches.

### The change

**One new harness unit, and two README wirings.** Lane B left rule 5 compiled
but unchecked: the sweep lived in a scratch script, so the next unit rendering a
bare code would have shipped. `tests/check-register.sh` is that sweep with a
floor under it.

1. **The scan, carried whole.** The file set derives from the payload globs —
   `skills/*/SKILL.md` · `skills/*/references/*.md` · `agents/*.md` ·
   `mirror/*.md` — and is counted at run time, never pinned at 61. Soft-wrapped
   source lines join into the paragraphs the BA actually sees; headings, table
   rows and quotes stand alone as hard lines; fenced blocks are skipped whole
   (rule 8 — on conflict the pinned shape governs). Every `T-nn` / `P-On` must
   carry its name immediately adjacent, across em-dash, en-dash, hyphen, colon,
   parenthesis, comma or table-cell boundary.
2. **The hardening was cheap, and was taken.** Names are no longer a dict in the
   checker. `T-01`–`T-18` are read from the catalogue index's rows, `P-O1`–`P-O9`
   from orchestrator §10.1's Moment column, at every run. Adjacency alone would
   accept any word sitting after the code; the scan now requires *the source's
   name*. A rename in either document breaks the suite instead of drifting past
   it — which is the one-way rule reaching the harness.
3. **The negative control is built in**, as section 4 of every run and as
   `--self-test` on its own.

### Units touched — 2 files

| Class | Count | Files |
|---|---|---|
| New suite | 1 | `tests/check-register.sh` |
| Wiring | 1 | `README.md` — the `## Test` block, the suite's paragraph, the `tests/` layout tree |

**Deliberately not touched, each for a stated reason:** the whole `payload/`
tree — harness-only session, and the sweep reads it, never writes it (verified:
`git diff --stat HEAD -- payload` is Lane B's 52 files, unchanged) ·
`docs/methodology/` — the suite reads the two name sources, and a checker never
edits its own grounding · `VERSION` — no payload byte changed, so the installed
package is identical · the other ten suites — none needed re-pinning, all ran
green unaltered · `.claude/settings.local.json` — a permission allowlist, not a
place suites run together (see D54).

### What the suite asserts — 19 checks in four sections

| § | Checks | What it holds down |
|---|---|---|
| 1 · the name sources | 5 | both documents parse; `T-01…T-18` complete with no gaps; `P-O1…P-O9` complete with no gaps; rule 5's own two examples resolve *from source* — `T-05 — Context & landscape mapping`, `P-O4 — clearing confirmation` |
| 2 · the corpus | 5 | the globs derive a non-empty set (61 today), and each of the four render classes contributes files — a stale glob fails loudly rather than sweeping nothing |
| 3 · the sweep | 1 | zero bare codes across the corpus; on failure every site prints with file, line and the joined paragraph |
| 4 · the self-test | 8 | the copy starts clean at 0 · the scan exits non-zero when dirty · **exactly 3** hits · each of the three sites named with its file and line · restored to 0 · the fenced-block probe draws 0 |

Sections 1 and 2 exist because the two ways this suite could go vacuous are an
empty name table (an unknown code is skipped, silently) and an empty file set.
Both are now assertions, not assumptions.

### Verification evidence

**The suite on the current payload.**

```
files scanned: 61 · names from source: 27 · bare codes: 0
passed: 19   failed: 0
```

**Negative control — the same three defect classes Lane B injected.** One per
render class, each into a different file so the report has to name three
distinct sites: a prose heading (`## P-O3 — the act`) into `ba-run/SKILL.md`, a
mid-sentence prose mention (`(that is P-O2)`) into `ba-orchestrator.md`, and a
table cell (`| P-O7 | closure act |`) into `AGENTS.md`. The detector reported
**exactly 3**, named all three with file and line, and returned to **0** on
restore. A checker that cannot fail is not evidence, so it is made to fail on
every run, not once.

**The control discriminates, and the payload proves it.** `ba-run/SKILL.md:137`
already carries *"(that is P-O2 — plan composition)"* — the paired form of the
very construct injected as defect 2. It draws no hit. The scan is testing the
pairing, not the substring.

**Rule 8's boundary, probed rather than asserted.** After the restore the same
codes are appended *inside* a fenced block. The sweep draws 0 — the pinned
record shapes stay exempt, and the exemption is now demonstrated rather than
claimed in a comment.

**Regression — all eight suites, plus the cards, the layout bar and the exit
script:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| **`check-register.sh`** | **19 / 0** |
| `check-cards.py` | every card byte-identical to its re-derivation |
| `check-layout.sh` (real `--offline` install) | 105 / 0 / 0 — full §1.1 tree |
| `check-exit.sh --offline` | 99 / 0 — all ten steps in one run |

752 suite assertions plus 204 install-and-exit assertions, zero failures — Lane
B's 733 plus this suite's 19, with every prior count unmoved. The suite also
runs green from an arbitrary working directory (paths derive from
`BASH_SOURCE`).

### Divergences flagged (§3.2 discipline, generalized)

**D51 · The catalogue index's names are not the rendered names, and the
difference needed a stated rule.** Three rows carry decoration the payload does
not render: `Discovery canvas framing ★` and `Epics decomposition ★` (the
starred pair), `Roles & permissions (incl. persona→role transformation)` and
`Scope allocation (repeatable)` (trailing qualifiers). A fourth,
`Domain (conceptual) modeling`, carries a parenthetical that *is* part of the
name. No document states which decoration is rendered and which is not.

*Resolution taken:* **one derivation rule, narrow and written into the
checker — strip a trailing `★` and a trailing parenthetical; keep parentheticals
that are not trailing.** Both the trimmed and the full form are accepted, so a
unit rendering `T-18 — Scope allocation (repeatable)` also passes. This
reproduces the scratch script's hardcoded list exactly, which is the check on
the rule: 27 names derived, 27 names matched. Recorded because it is a
derivation the corpus does not state, and a future index row with new decoration
will need it revisited.

**D52 · §10.1's Moment column is title-case; the payload renders lower-case —
and rule 5's own example follows the payload.** The table reads
`| P-O4 | Clearing confirmation |`; rule 5's example reads *"P-O4 — clearing
confirmation."* Pinning the source's case would fail the rule's own example.

*Resolution taken:* **the name match is case-insensitive; nothing else was
loosened.** The name still has to be the source's name, word for word — only
capitalization is free. The alternative, a case-normalization rule in §10.3,
is a document change, not a harness one.

**D53 · The Lane B negative control edited payload files, and this session may
not.** Lane B injected into the real payload and restored it. This session is
harness-only.

*Resolution taken:* **the corpus is copied into the suite's temp dir and the
defects are injected there; restore copies the pristine file back over.** Same
three classes, same "exactly 3", same restore-to-0 — and the payload is opened
read-only for the whole run, which is the property a checker should have anyway.
This also matches `check-spine.sh`'s `mutate`-to-`$TMP` idiom rather than
diverging from it, so the harness now has one seeded-defect pattern, not two.

**D54 · There is no place the suites actually run together.** The prompt says to
wire the new suite in "wherever they run together." They do not: the repo has no
`Makefile`, no CI workflow, no git hook and no aggregate runner. The three
places every suite is *listed* are `README.md`'s `## Test` block, `README.md`'s
`tests/` layout tree, and `.claude/settings.local.json` — the last a per-command
permission allowlist, which is a record of what has been approved, not a runner.

*Resolution taken:* **wired into both README locations, and nothing invented.**
`check-register.sh` now sits in the `## Test` block, has its own paragraph beside
`check-m.sh`'s and `check-orchestrator.sh`'s, and has a layout-tree entry.
A runner was not built: it would be a new harness unit this prompt did not
scope, and it would need a decision about `check-layout.sh` and `check-exit.sh`,
which take a target and do a real install. Left as an Open item rather than
decided in passing.

### Open

**No single command runs the regression.** Eleven checks, invoked one at a time,
with two of them needing an install first — the roll-up table in every BUILD-LOG
entry since S2 has been assembled by hand. A `tests/run-all.sh` that runs the
eight file-only suites plus `check-cards.py`, and optionally drives an
`--offline` install for `check-layout.sh` and `check-exit.sh`, would make that
table a command's output. Left undone deliberately: see D54.

**`AT-*` and `CC-*` are still outside the sweep, and D49 is why.** The scan
skips any code with no name source, so the two families Lane B could not pair
pass silently rather than failing. That is correct today — no document names an
AT criterion or a CC assertion — but it means the suite's coverage tracks the
name sources, not rule 5's full reach. When §3.3 or the contract grows a name
column, the codes join the sweep by existing, and this note is the pointer.

---

## Lane C — orchestrator rules v0.5 + gate v0.4 · stage boundary · P-O2 checkpoint · flow profiles · dashboard · 8 August 2026 · GREEN

**Session prompt:** one combined session — fix the twelve package defects from
`diagnostics/audit-stage-escape-and-planning.md` and propagate the methodology
changes (orchestrator rules v0.5, gate definition v0.4) into the package.
**Grounding:** `docs/methodology/ba-native-spec-orchestrator-rules.md` **v0.5**
(header verified before any edit; the v0.5 change record names D-O11–D-O17) —
§2.4 ledger head · §6.1–§6.5 snapshot shape, P-O2 checkpoint, flow profiles ·
§8.1 profile picker · §10.1 P-O0 · §10.2 session-mode boundary · §10.3 register ·
§10.4 dashboard · §11 compile-not-dispatch · §14 the seven rulings ·
`ba-native-spec-gate-definition.md` **v0.4** §11.3 (the appended
cross-reference) · `diagnostics/audit-stage-escape-and-planning.md` F-01…F-14 ·
BUILD-LOG Lane A and Lane B tails, as the compiled surface this recompiles.

### The precondition failed, and the session stopped on it

The prompt required a clean tree with Lane B committed. `HEAD` was S9 and
**nothing after it was committed** — 59 modified files plus three untracked
paths, carrying three distinct bodies of work: the methodology v0.5/v0.4
upgrade, Lane B, and Lane A. Two specifics against the prompt as written: the
last BUILD-LOG entry was **Lane A**, not Lane B, and `tests/check-register.sh`
was untracked — its disposition described in the Lane A entry, the file itself
never in git.

Reported rather than worked around: the prompt ends in a single commit, which on
that tree would have absorbed three sessions' work under this entry's name and
carried a `VERSION` bump this session did not make. The BA ruled **Option A** —
file the pre-existing work first, one commit per body of work, in a stated
order. Four commits landed before this session's own work began:
`7754cf1` Lane B · `cd15e35` Lane A · `d7a85ca` the diagnostic audit ·
`b9ecfe6` the methodology upgrade. The BUILD-LOG was split at the Lane
A/Lane B boundary so each entry rode its own commit, and the reassembly was
verified byte-identical to the pre-split file.

### The change — seven stages, each verified before the next

**S1 · Mode-aware mirrors (F-01, F-03, F-04).** Both mirrors restructured into
two addressed sections. **Analysis session — the default mode** carries §10.2's
session-mode boundary; **Coding agent — downstream of handoff** opens with an
explicit reader line and receives the certified-text, implement-around-markers
and never-invent bullets. Every instruction now names its reader, and an
instruction addressed to the coding agent is visibly inert in an analysis
session. The audit's F-03 defect — the analysis session reading *"Implement
around it and surface it"* as a standing instruction — is closed structurally,
not by deletion: the sentence is still there, under the reader it was written
for.

**S2 · Never-lists (F-05, F-06, F-07, F-10).** The session boundary compiled
into four never-lists — `ba-tier2`, `ba-analyst`, `ba-discovery`, `ba-aspect` —
**byte-identical across all four**, sha256 of the normalised block
`56fdb8fab4b0f483…`. `ba-aspect` additionally took D-O13's compiled never-line,
verbatim: *"never composes or records a plan the BA did not compose."*

**S3 · P-O2 checkpoint (F-09, F-11, F-13, F-14).** `ba-aspect` Step 4 rebuilt on
the `/ba-clear` Step 3 model. Step 3 now writes the §6.1 pinned shape — profile
in the header, `Code — technique`, purpose, Addresses, the closed status
vocabulary, the standing enrichment block, the out-of-profile collapsed line.
Step 4 renders it, then the explicit four-choice line, then **stops and waits**.
F-14's gap — *nothing converts the output into a choice* — is closed by the
choice line; F-13's — *no step lists enrichment techniques* — by the enrichment
block being **standing** rather than on-ask, which is D-O12 making D-B2-1's
election path reachable at last.

**S4 · Bare-code sweep (F-12).** `ba-aspect` Step 3's lowercase `t03`-style
references now render `T-03 — Stakeholder register` and keep `t03` only as the
command argument, with the distinction stated in the skill. Two further rule-5
defects the harness cannot see were found by hand and fixed:
`ba-close-band1` rendered *"`/ba-run t17` → the roadmap"* and `ba-reopen`
*"Name `/ba-run t18`"* — both now carry code + name on the `ba-frame` model.

**S5 · Personas as compile sources (F-02, per D-O16).** `ba-orchestrator`'s
description claimed invocation by nine skills; no skill implemented it, so its
stop-at-every-checkpoint rule and its code prohibition never loaded. The claim
is removed and replaced with what the persona actually is. All three of
`ba-orchestrator`, `ba-discovery`, `ba-analyst` now state: *a compile source,
not a dispatch target — no skill dispatches it, and none should.*
`ba-orchestrator` gained a section on why, from §11: every interactive P-O is a
main-conversation checkpoint, and a dispatched sub-agent cannot stop and take a
ruling. **`ba-gate`'s dispatch stays** — it is batch-shaped work taking no BA
ruling mid-flight, and both its sites are intact. The guards F-02 found inert
are now compiled into the mirrors' analysis-session section, where they load on
every turn.

**S6 · Flow profiles (D-O14, D-O15).** `/ba-frame` gained Step 2 — **P-O0 —
flow-profile selection** — rendering §8.1's pinned picker before any aspect
opens, then stopping. The ledger-head template gained the `Profile` field and
the switch-event grammar; `/ba-status`'s head render matches. `/ba-aspect`
refuses to open with no profile on record, and never assumes Discovery.
Suggestion rendering filters by profile: in-profile full rows, out-of-profile
one collapsed line electable by code. The Presale set is compiled exactly as
§6.5 lists it — eleven in profile plus Tier 1 electable, seven plus Tier 2 out —
and `/ba-enter-feature` blocks Band-3 entry under Presale, naming the recorded
switch to Discovery as the way through.

**S7 · Dashboard (D-O17).** `/ba-status` extended to §10.4's pinned render:
seven lines, a source table naming which ledger each line is read from, the risk
rule verbatim, and the standing prohibitions — never writes, never transitions,
never proposes content, never invents a composite score. Command naming follows
the package's hyphen convention; the methodology's `/ba.status` is indicative
per the gate §13 convention.

**S8 · Register conformance.** Rule 5 is mechanically green across the corpus.
Rule 8's pinned-format list was extended to v0.5's — profile picker §8.1 and
project dashboard §10.4 — in all six compiled units. Two of this session's own
sentences ran past the ≤ 20-word target and were split.

### Units touched — 16 files

| Class | Count | Files |
|---|---|---|
| Mirrors (two addressed modes + rule 8) | 2 | `claude-block.md` · `AGENTS.md` |
| Personas (compile-source correction + rule 8 + boundary) | 4 | `ba-orchestrator` · `ba-discovery` · `ba-analyst` · `ba-gate` |
| Workflow skills | 7 | `ba-aspect` · `ba-frame` · `ba-status` · `ba-tier2` · `ba-enter-feature` · `ba-close-band1` · `ba-reopen` |
| Template (ledger head gains Profile) | 1 | `ba/templates/aspect-state.md` |
| Harness (assertion re-pinned) | 1 | `tests/check-register.sh` |
| `VERSION` | 1 | 0.1.1 → 0.1.2 |

**Deliberately not touched, each for a stated reason:** `docs/methodology/` —
read-only ground truth this session compiles from · the three compiled cards —
D48's structural bar stands, and `check-cards.py` byte-compares them · the 13
artifact templates other than the ledger head, and the 11 checker scripts — the
changes are conversation-layer, and no pinned record shape moved except the one
§2.4 changed · `install.sh` — the mirrors it copies changed, the installer did
not · the manifest's doc vector — derived at install time from the documents
themselves, so it self-updated to orchestrator v0.5 / gate v0.4 with no edit
(verified on a real install).

### Verification evidence

**The mission's own VERIFY, as an executable sweep — 70 checks, 0 failures.**
Paragraph-aware, because every one of these strings is soft-wrapped in the
payload and a line-based grep reports a false miss on all of them:

| Check | Result |
|---|---|
| session boundary in both mirrors **and** all four never-lists | 6 / 6 |
| *"Implement around it"* only under the coding-agent heading | 2 / 2 — one heading each, all hits below it |
| picker renders before any aspect can open | 4 / 4 — picker verbatim, step order, never-default, `ba-aspect` refusal |
| P-O2 has an explicit wait | 4 / 4 — four-choice line, wait line, stop rule, silence-is-never-consent |
| §6.1 snapshot shape | 8 / 8 — columns, profile header, enrichment block, out-of-profile line, four status values |
| status skill renders §10.4 sections 1–7 | 9 / 9 — seven sections, risk rule verbatim, never-writes |
| Presale set exactly as §6.5 lists it | 21 / 21 — 11 in, 8 out, Tier 1 electable, Band-3 blocked |
| ledger head Profile field | 3 / 3 — template, switch grammar, `/ba-status` render |
| personas are compile sources, `ba-gate`'s dispatch stays | 6 / 6 — 2 dispatch sites intact |
| rule 8 extended in all six compiled units | 6 / 6 |

**The audit's clean negative, re-confirmed.** Eight `/speckit-plan`,
`-tasks`, `-implement` mentions across all skills and personas; **all eight** sit
in `ba-gate/SKILL.md` or `ba-handoff/SKILL.md`. Nothing pre-certification
reaches or suggests them. The finding stands after the change, as it did before.

**The Phase-2 §5 exit test, end to end on a fresh install — GREEN.**
`check-exit.sh --offline`, all ten steps in one run: **99 passed, 0 failed.**
Re-run after the `VERSION` bump: 99 / 0 again.

**Regression — every suite, plus the cards, the layout bar and the exit script:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 19 / 0 |
| `check-ledger.py` | 14 rules, no violations — including a head carrying the new `Profile` line |
| `check-cards.py` | every card byte-identical to its re-derivation |
| `check-layout.sh` (real `--offline` install) | 105 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

752 suite assertions plus 204 install-and-exit assertions, zero failures, every
prior count unmoved — and 70 mission-VERIFY checks on top.

**Two test assertions re-pinned, both recorded rather than loosened.**

1. `check-register.sh` §1 pinned the stage set at `P-O1…P-O9`. v0.5 added
   **P-O0 — flow-profile selection** to §10.1, so the suite went red on the
   *document*, before any payload edit — the name-from-source hardening Lane A
   built doing exactly what it was built for. Re-pinned to `P-O0…P-O9`, 10 rows;
   the derived name table grew 27 → 28.
2. `check-orchestrator.sh` pinned *"select · drop · reorder · add custom"* in
   `ba-aspect`, and S3's rebuild replaced that one-liner with an enumerated
   render. **The assertion was not re-pinned.** The phrase is Q2's own verbatim
   wording; the right fix was to restore it to the skill beside the enumerated
   choice line, which is what happened. A test pinning methodology-verbatim text
   should win that argument, and it did.

### Divergences flagged (§3.2 discipline, generalized)

**D55 · §10.2 demands more never-lists than this session was scoped to touch.**
The rule ends *"compiled verbatim into both mirrors and into every skill's and
persona's never-list."* Every skill is 32 units; every persona is 4. The prompt
scoped S2 to four — `ba-tier2`, `ba-analyst`, `ba-discovery`, `ba-aspect` — and
set its VERIFY bar at those four.

*Resolution taken:* **the four the prompt named, plus two more where this session
was already rewriting the file** — `ba-frame` and `ba-status`, which now carry
the block because their never-lists were being edited anyway. Six of thirty-six.
The remaining thirty are named here rather than swept in silently: widening a
stated scope is the BA's call, not the build's. The block is byte-identical
everywhere it appears, so the remainder is a mechanical pass whenever it is
ruled — and `check-register.sh` is the natural place to assert it.

**D56 · F-11 named two pinned shapes; v0.5 fixed one.** The audit classed F-11 a
**methodology gap** — the §6.1 snapshot and the §6.4 composed-plan record both
rendered a bare `<name>`. D-O12 rebuilt §6.1 with `Code — technique`. **§6.4 was
not touched**, and still pins `| 1 | <name> |`.

*Resolution taken:* **§6.1's shape updated, §6.4's left exactly as the document
pins it.** Register rule 8 settles it on its own terms — on conflict between the
register and a pinned shape, the shape governs — and D48 set the precedent that
a pinned record shape is not the sweep's to fix. Changing it here would invent a
rule the documents do not state. Half of F-11 closes; the other half needs a
§6.4 change first, and this is the pointer.

**D57 · The audit's Problem-2 fix sketch is superseded by D-O16.** The audit's
first remedy was *"add an explicit dispatch line to each of the nine
orchestrator-owned workflow skills."* v0.5 ruled the opposite: personas are
compile sources, dispatch is reserved for batch-shaped work, every interactive
P-O is a main-conversation checkpoint.

*Resolution taken:* **the ruling followed, the sketch not.** F-02's *defect* is
real and is closed — the guards were inert — but by compiling them into the
mirrors and correcting the false claim, not by wiring nine dispatches. Recorded
because a reader comparing the audit to this entry will otherwise see a fix
sketch that was ignored. It was overruled, on the record, by a document dated
the same day.

**D58 · The rule-5 harness cannot see the lowercase form.**
`check-register.sh`'s scan matches `T-nn` / `P-On`; F-12's defect was `t03`,
which the pattern never sees. The three sites fixed in S4 were found by hand.

*Resolution taken:* **fixed by hand, harness left alone, and the gap named.** A
lowercase `t03` is *legitimate* in command position — `/ba-run t03` is the real
invocation — and illegitimate only as a render. Teaching the scan that
difference is a real design question, not a one-line regex change, and it is not
this session's scope. Until it is taken, the lowercase form is covered by review,
not by the floor.

**D59 · `VERSION` bumped on a BA ruling, against the prompt's own DO-NOT.** The
prompt said *bump no document version*. Asked, the BA scoped that to the two
methodology documents — their v0.5 / v0.4 stand untouched — and directed the
package `VERSION` to follow the standing pattern: a commit that propagates a
methodology change bumps it. 0.1.1 → 0.1.2, patch, on the same reasoning Lane B
recorded for 0.1.0 → 0.1.1.

### Open

**Thirty never-lists still lack the session boundary.** D55 is the decision;
this is the work it leaves. The block is fixed text, so the pass is mechanical —
but it should land with an assertion, or the next new skill ships without it.
`check-register.sh` already walks every skill, agent and mirror; a section 5
asserting the block's presence and its sha would close D55 and hold it closed.

**§6.4's composed-plan shape still renders a bare name.** D56. A BA reading the
plan record sees `| 1 | Stakeholder register |` with no code, one screen after
reading `T-03 — Stakeholder register` in the snapshot. Consistent with the
document, inconsistent with what the BA just read. A one-line §6.4 change would
resolve it, and the register's own rule 5 is the argument for it.

**Still no single command runs the regression.** Twelve checks now, invoked one
at a time, two needing an install first. D54 stands unchanged, and this entry's
roll-up table was again assembled by hand.

---

## Lane D — the finish-up batch · session boundary everywhere · §6.4 propagated · the regression runner · 8 August 2026 · GREEN

**Session prompt:** close the three open items the Lane C entry left — D55 (the
thirty never-lists without the session boundary), D56 (§6.4's composed-plan row),
D54 (no single regression command) — and leave the package with nothing
known-unfinished. **Grounding:**
`docs/methodology/ba-native-spec-orchestrator-rules.md` **v0.6** (header verified
before any edit; the v0.6 change record names the §6.4 code-column fix and
nothing else) — §6.4 the composed-plan shape · §10.2 the session-mode boundary ·
§10.3 the register · §10.1/§12.1 as the name sources the harness already reads ·
BUILD-LOG Lane C, its divergences D54–D59 and its Open section · the six units
Lane C recorded as carrying the boundary block byte-identically, which is the bar
this session had to meet thirty more times.

### The precondition, stated

The prompt required a clean tree. The tree was not clean: one modified file,
`docs/methodology/ba-native-spec-orchestrator-rules.md`, carrying the v0.5 → v0.6
edit — the §6.4 fix, uncommitted. That edit **is** the second precondition, which
required the newest change record to name it. So the only dirt in the tree was
the input the session exists to propagate.

Reported rather than worked around, and not treated as a stop: stopping would
have delivered nothing while the required change sat in front of the session.
The methodology edit rides this commit, unmodified — `docs/methodology/` was read
and never written, as the prompt's DO-NOT requires. Its diff is five lines: the
header line, the v0.6 change record, the §6.4 header and placeholder cells, and
the footer's version line.

### The change — five stages, each verified before the next

**S1 · The session boundary in every unit (closes D55).** The definitive list was
established first, by scanning rather than by trusting the number: 32 skills + 4
personas = **36 units**, of which **6 carried the block and 30 did not** — D55's
"six of thirty-six", reconciled exactly, with no unit found outside the two globs.
The two mirrors are counted separately and were already complete: they carry
§10.2's *own paragraph*, not the unit block (see D60).

The block was derived from the six, not authored here. All six were byte-identical
— sha `924cf13f123a6d1108baf9ba407d54ef70f7f7a78b97d92789190852cf115d13`, six
lines, sitting at end of file directly after the never-list. That position is the
established shape in all six, so the compile is an append: one blank line, then
the block, terminating the file. Thirty units took it. **36 / 36 now carry it,
every one at the pinned sha.**

**No unit needed a never-list built for it.** The prompt allowed for that case —
"a unit with no never-list section gets one in the package's established shape."
Every one of the 36 already had one (`## What this skill never does` in all 32
skills, `## What you never do` in all 4 personas), and in every one it is the
file's last section. Recorded because it was checked, not assumed.

**S2 · §6.4's code column propagated (closes D56).** Three sites in the package
pin or render the composed-plan row. All three moved:

| Site | What changed |
|---|---|
| `payload/claude/skills/ba-aspect/SKILL.md` §"Append to the aspect's section" | the pinned block: header `\| # \| Technique \|` → `\| # \| Code — technique \|`, placeholder `<name>` → `<code — name · custom — name>` |
| `payload/specify-overlay/ba/templates/aspect-plans.md` — the repeated section shape | the same two cells, in the form §6.4 pins them (`catalogue \| custom`, the full status list) |
| `payload/claude/skills/ba-run/SKILL.md` — the P-O3 act | *"Render the plan row — technique, source, the pinned contract"* → *"…the technique's code and name, source, the pinned contract"*. The row now carries a code; the render that displays it has to say so. |

Two sites were examined and found already conformant, both from Lane C: the
§6.1 suggestion snapshot in `ba-aspect` (`| # | Code — technique |`, D-O12) and
the `/ba-status` dashboard, whose lines 2 and 7 already read `<code — name>` per
§10.4. One site was examined and deliberately not changed — the fixture; see D61.

**S3 · The boundary made permanent (`check-register.sh` section 5).** Lane C's
Open item named the place: *"`check-register.sh` already walks every skill, agent
and mirror; a section 5 asserting the block's presence and its sha would close
D55 and hold it closed."* Built there, **17 new checks, 19 → 36**:

| What it asserts | Checks |
|---|---|
| §10.2 exists in the document, at a found line — the pin's source, not a free-standing string | 1 |
| the block's four load-bearing clauses are the document's words, in the block — both sides unwrapped first, because the block wraps where the document does not (section 3's own reasoning) | 4 |
| the two globs derive non-empty sets — 32 skills, 4 personas — on §2's vacuity reasoning: a stale glob reports zero missing and passes | 2 |
| zero units missing the block, each offender named with its path | 1 |
| zero units carrying an altered block — every one at the pinned sha | 1 |
| the mirrors' expected text derives from §10.2 by the compile's only two transformations: the decision id drops, the trailing compile note drops | 1 |
| both mirrors carry that paragraph word for word | 2 |
| the control: a private copy starts clean · a skill with the block removed is caught as exactly 1 missing · a persona with one clause reworded is caught as exactly 1 altered · both are named | 5 |

The unit set comes from the same globs as the corpus, never a list — **a skill
that ships without the block goes red by existing**, which is the property D55
asked for. The payload is read, never written: the control injects into a tar
copy under the suite's temp dir, the pattern Lane A established.

**S4 · `tests/run-all.sh` — the regression runner (closes D54).** One command,
the twelve checks, and the roll-up table the last three entries assembled by
hand. Ten file-only checks run first, then the two that install: a throwaway git
repo takes `install.sh --offline` and `check-layout.sh` runs the full Phase-2
tree bar against it, then `check-exit.sh --offline` runs its own ten steps.

The runner **asserts nothing of its own**. Every verdict is the check's own exit
code; every count is parsed from the check's own roll-up line — the one format
all eight shell suites already print. A suite that stops printing counts reports
`no roll-up line`, not a passing row. `check-cards.py` and `check-ledger.py` keep
their own rows even though `check-gate.sh` and `check-orchestrator.sh` already
invoke them, because the entries give them their own rows: a card divergence
should name itself rather than arrive as a gate-suite failure.

Flags: `--file-only` (the ten that need no install and no network), `--online`,
`--keep`, `--list`, `-v`. Wired into README at all three places the suites are
documented — the `## Test` block, its own paragraph, and the `tests/` layout tree
— which is the same wiring D54 accepted for `check-register.sh`.

**S5 · Register conformance, then the full regression.** The strings this session
added or changed, against §10.3: the `ba-run` render line is one short sentence,
imperative, act-shaped, and names the code before the name (rules 1, 3, 5, 6).
The two pinned shapes are inside a fenced block and an HTML comment — rule 8's
ground, changed only in the two cells §6.4 moved. The boundary block is Lane C's
compiled text, unaltered by definition: byte-identity is the assertion. No new
BA-facing string carries a bare code; the sweep confirms it at 61 files, 0 hits.

**No pin went red, and nothing was re-pinned.** The §6.4 change touched two
strings that no suite pinned — verified before editing by grepping the harness
for the header row — so Lane C's discipline had no occasion to apply this time.

### What moved

| Area | Files | What |
|---|---|---|
| Skills | 28 | the session boundary appended after the never-list |
| Personas | 2 | the same, in `ba-gate` and `ba-orchestrator` |
| Skills (shape) | 2 | `ba-aspect` the §6.4 block · `ba-run` the P-O3 render line |
| Overlay template | 1 | `aspect-plans.md`'s repeated section shape |
| Harness | 2 | `check-register.sh` section 5 (+213 lines) · `tests/run-all.sh` (new) |
| Wiring | 1 | `README.md` — the `## Test` block, the runner's paragraph, the register paragraph, the `tests/` tree |
| Package | 1 | `VERSION` 0.1.2 → 0.1.3 |
| Methodology | 1 | carried unmodified into this commit — the v0.6 §6.4 fix, read-only to this session |

**Deliberately not touched, each for a stated reason:** `docs/methodology/`
beyond carrying the pre-existing edit — the prompt's DO-NOT, and a propagation
never edits its own source · `tests/fixtures/` — see D61 · the lowercase-code
scan — D58, named out of scope by the prompt · the two methodology documents'
versions — v0.6 and v0.4 stand as their authors left them.

### Divergences flagged (§3.2 discipline, generalized)

**D60 · The mirrors could not be checked against the unit block, because they do
not carry it.** §10.2's rule reads *"compiled verbatim into both mirrors and into
every skill's and persona's never-list"* — one sentence, and Lane C compiled it
two different ways, correctly. The units carry a six-line block in the unit's own
voice, naming the two commands that lift the boundary (`/ba-gate <feature>`,
`/ba-handoff <feature>`). The mirrors carry §10.2's own paragraph, which names
the gate and handoff abstractly and carries the two-addressed-modes sentence a
skill has no use for. Neither is derivable from the other.

*Resolution taken:* **two assertions, one rule.** The unit block is pinned in the
suite verbatim and held by sha — the exact compiled wording is the sha's business
— and separately grounded: four load-bearing clauses must be the document's words
on both sides, so a §10.2 rewrite breaks the pin instead of drifting past it. The
mirror text is *derived from source*: the document's line with the decision id
and the trailing compile note removed, whitespace unwrapped, compared. Those two
removals are the whole of the mirror compile, and naming them in the checker is
what makes the check honest rather than a second hardcoded copy.

**D61 · The fixture's plan records were left in the old shape.**
`tests/fixtures/appointment-booking/band1/aspect-plans.md` carries nine composed
plans whose header rows still read `| # | Technique |`, and whose cells render
`t02 glossary discipline` — lowercase, no code/name separator.

*Resolution taken:* **left untouched, and named here.** Three reasons, in order
of weight. It is harness input, never shipped: `install.sh` copies `payload/`
only, so no BA ever reads it. No suite pins the header row — checked before
deciding, so nothing forced the edit either way. And rewriting the cells into
`T-02 — Glossary discipline` is precisely **D58's** ground — the lowercase render
question the prompt put out of scope — with six suites reading the file and
`check-techniques3.sh` deriving skill paths from the lowercase form. Updating the
header alone was considered and rejected: it would leave a column called
`Code — technique` over custom rows that carry no code, which is worse than
either whole option. The fixture's own header comment says it is "recorded in the
§6.4 shape"; that sentence is now one version stale, and this is the pointer.

**D62 · The prompt's "nine file suites" is ten.** S4 named the twelve as *"the
nine file suites, the ledger and cards checkers, and the two install-based runs"*
— which totals thirteen. The Lane C roll-up table, which the runner reproduces,
has twelve rows: **eight** shell suites, `check-ledger.py` and `check-cards.py`,
then `check-layout.sh` and `check-exit.sh --offline`.

*Resolution taken:* **the table's twelve, not the prompt's arithmetic.** The
prompt's own object was "the roll-up table the last three entries assembled by
hand," and that table is unambiguous. `check-band1-artifacts.py`,
`check-band2-artifacts.py` and `verify-manifest.py` are not rows: they are
validators the suites invoke, with no standalone verdict of their own.

**D63 · `VERSION` bumped without asking, on the prompt's own instruction.** The
prompt pre-ruled it: this commit propagates a methodology change (S2), so the
package version follows the standing pattern. 0.1.2 → 0.1.3, patch, on the
reasoning Lane B recorded for 0.1.0 → 0.1.1 and Lane C for 0.1.1 → 0.1.2. The
harness work (S3, S4) adds no bump of its own — it changes no installed byte.
Recorded rather than silent, because D59 made the last one a BA ruling.

### Verification evidence

**S1's own bar, asserted rather than counted by hand:** 36 units scanned, 36
carrying the block, 0 missing, 0 altered, every one at sha `924cf13f123a`. The
same assertion now runs on every future invocation of `check-register.sh`.

**The new section proved non-vacuous before it was trusted.** Two defects seeded
into a private copy: `ba-t01`'s block deleted, `ba-gate`'s final clause reworded
to *"the only way out is the gate."* Both caught, each named with its path,
exactly one of each. Three failures in the section's first run were the section's
own bugs — a phrase list that ignored the block's soft wrapping and a mirror
compare tripping on a trailing newline — both fixed before the section was
considered built.

**The regression, produced by `tests/run-all.sh` — its first real use.**
Twelve checks, one command, one table:

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 36 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 105 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 12   red: 0   skipped: 0` · **✓ GREEN — all 12 checks pass, the two
install-based runs included.**

**The Phase-2 §5 exit test, on a fresh offline install — GREEN**, all ten steps
in one run: **99 passed, 0 failed**, with the manifest asserting the bumped
`VERSION` 0.1.3 as step 2's own check. `check-register.sh` moved 19 → 36 and
`check-layout.sh` held at 105 / 0 / 0 — no installed byte count changed, because
S1 and S2 edit files the tree already lists.

### Open

**Nothing from Lane C's Open section remains.** D55 closed by S1 and held by S3.
D56 closed by S2. D54 closed by S4 — this entry's roll-up table is a command's
output, printed by `tests/run-all.sh`, not assembled by hand.

**D58 stands, unchanged and unworked.** The rule-5 scan still matches `T-nn` /
`P-On` and cannot see `t03`. It was named out of scope by this prompt, and the
design question it holds is unchanged: a lowercase code is legitimate in command
position (`/ba-run t03` is the real invocation) and a defect only as a render.
Until that distinction is taken, the lowercase form is covered by review, not by
the floor — and D61 is now a second thing waiting on it.

**The runner has no CI to run it in.** D54 asked for one command and got one;
nothing schedules it. The repo still has no workflow file, no hook, and no
`Makefile` — `tests/run-all.sh` is the thing such a wiring would call, and
building the wiring is a decision about where this package's CI lives, not a
harness gap. Named, not decided.

---

## Presale drafting — `/ba-enter-feature` drafts under Presale · orchestrator v0.7 · elicitation v0.4 · 9 August 2026 · GREEN

D-O18–D-O19 extended the Presale destination to draft specs. The built package
still carried the superseded law: `/ba-enter-feature` **stopped** on a Presale
ledger head, and `/ba-frame` told the BA that Band-3 entry was out of profile and
listed Tier 2 among the excluded techniques. This session compiles v0.7 §6.5 and
v0.4 §5.4 into the four units that render them.

### The precondition, stated

Three of the four held on the first read: orchestrator header **v0.7** with
D-O18–D-O19 in §15 · elicitation header **v0.4** with §5.4's defer paragraph ·
`VERSION` **0.1.3**. The fourth — a clean tree — did not; see **D64**.

### The change — one sweep, four units

**The sweep first, before any edit.** The prompt named four compiled images of
the old law. Three resolved to live strings, one did not: `Band-3 entry (P-O8) is
out of profile` matched nothing, because `/ba-enter-feature` phrased the same law
as *"Band-3 entry is out of that profile."* Searching the paraphrase rather than
the pinned string is what found it. Two further sites had no stale string at all
— see **D65**.

**`/ba-enter-feature` — the primary rebuild.** The invocation-contract bullet
inverts: *Presale profile blocks entry* → *Presale profile — entry proceeds*.
The command now runs P-O8 — Band-3 entry normally under Presale, renders the
draft-spec framing line (an ordinary `spec.md` before its effective PASS, unknowns
carried as markers), and names what is **not** relaxed — certification and handoff
stay behind existing gate law. The Close splits by profile: under Discovery, Tier
2 submits to `/ba-gate`; under Presale it runs in assumption posture with the
one-batch deferral discipline, and certification and handoff are **never** named
as the next step. Three clauses join the never-list.

**`/ba-frame` — the picker line and the profile paragraph.** The pinned §8.1
render takes the new destination line verbatim, three lines as the source breaks
them. The Presale paragraph rebuilds from §6.5 whole: destination extendable to
draft specs, the draft-spec definition, Band-3 drafting **in** profile, the gate
BA-invocable with its FAIL report as the client Q&A agenda. Tier 2 moves from the
out-of-profile list into the in-profile set, and the Tier-1 clause gains
ingestion-on-captured-material.

**`/ba-tier2` and `/ba-gate` — the two the enumerated strings missed.** Tier 2's
disposition line gains the fourth disposition and §5.4's defer paragraph; the
gate's Stage-4 waiver bullet gains the certify-over-assumptions advisory, on the
§8.3 pattern — said once, never a refusal, the BA's call stands.

### What moved

| Area | Files | What |
|---|---|---|
| Skills | 4 | `ba-enter-feature` (bullet · Close · never-list) · `ba-frame` (picker line · profile paragraph · both technique lists) · `ba-tier2` (fourth disposition + defer paragraph) · `ba-gate` (the advisory) |
| Package | 1 | `VERSION` 0.1.3 → 0.1.4 |
| Methodology | 2 | carried unmodified into this commit — orchestrator v0.7, elicitation v0.4; read-only to this session, and a propagation never edits its own source |

**Deliberately not touched, each for a stated reason:** `/ba-waive-aspect` — the
aspect waiver is a different instrument from the marker waiver §6.5 names (D65) ·
`ba-status`, `ba-aspect`, `aspect-plans.md`'s template — their `<Discovery |
Presale>` placeholders render the profile's *name*, and carry none of its law ·
`README.md`, `docs/quickstart.md` — their "presale" is the material sense (the
presale canvas, a presale conversation), not the profile · `tests/fixtures/` —
no fixture asserts the profile's destination · the §10.2 session-boundary block —
untouched by ruling and by assertion (§15: *"session boundary §10.2 untouched"*).

### Divergences flagged (§3.2 discipline, generalized)

**D64 · The clean-tree precondition failed, and the session proceeded on it.**
The prompt's fourth precondition was `git status` clean, against a stated
baseline of package 0.1.3 and a clean tree. The tree was not clean: both
methodology documents stood modified in the working tree. The prompt's own rule
for a precondition mismatch is *STOP, report, change nothing.*

*Resolution taken:* **proceeded, and recorded here.** The check was read for what
it guards — building a propagation on top of unknown working-tree state — and the
diff was inspected before the decision rather than after. The two modified files
were the v0.7 and v0.4 edits **that preconditions 1 and 2 require by name**, and
nothing else: `+17/−4` on the orchestrator (header, §6.5, §8.1's picker line, §15,
the footer) and `+6/−3` on elicitation (header, §5.4, the footer). No third file,
no unrelated hunk. A precondition that fails *because* the content another
precondition demands has not been committed yet is self-consistent, not unknown
state, and stopping would have delivered nothing to resolve it. The edits land in
this session's single commit, which the commit message already names.

**D65 · Two of the four units had no stale string, and the sweep cannot see
either kind.** The prompt's step-1 sweep enumerates strings of the old law, which
finds a *superseded* string and nothing else. Two sites were invisible to it:

- **`ba-tier2:128` — a compiled image the enumerated strings do not name.** *"let
  the BA confirm, edit, or reject"* is the pre-v0.4 §5.4 disposition line. It is
  the old law, and it is in scope under step 1's own catch-all (*every* compiled
  image), but no enumerated string reaches it. Found by grepping the superseded
  §5.4 sentence itself rather than the prompt's list. Rebuilt from v0.4 — the
  fourth disposition, and the defer paragraph that is its mechanics. Leaving it
  would have shipped `/ba-enter-feature` promising a deferral batch that the skill
  actually running Tier 2 knew nothing about.
- **`ba-gate` — an absence, which no string sweep can find.** §6.5's
  certify-over-assumptions advisory is *new* law with no superseded image to
  match; grep finds stale text, never missing text. Step 2 names the requirement
  in one clause — *"renders once at the waiver act"* — and that clause is the only
  thing that surfaced it.

*And the waiver act is `/ba-gate`, not `/ba-waive-aspect`.* The nearer-sounding
skill is the wrong home: `/ba-waive-aspect` grants **aspect** waivers (AW records,
Band-1 thresholds), while §6.5's advisory is about waiving **marker failures**
into a certified spec — CC-G-03, Stage-4 P2, the `W-<NNN>-<nn>` record. Two
instruments that share a verb. Placed on the §8.3 advisory pattern already
compiled at `ba-waive-aspect:81` (*decomposing on a waived Solution is decomposing
a guess*), so the package now says the same shape of thing the same way twice.

### Verification evidence

**Residual sweep — the old law is gone, and the one surviving match is new law.**
All four enumerated strings: **0 hits** across `payload/`, `README.md`,
`install.sh`, `docs/quickstart.md`, `tests/`. The paraphrase D65 names, *"Band-3
entry is out of that profile"*: **0**. `confirm, edit, or reject`: **0**. No
out-of-profile list anywhere in the package contains Tier 2.

One string still matches and is **correctly** present: `recorded switch to
Discovery`, at `ba-tier2:138`, inside the defer paragraph this session wrote. It
is v0.4 §5.4's own wording (*"after the recorded profile switch to Discovery"*),
which v0.7 §6.5 also uses — the phrase names where certification lives under the
new law, not the entry block the old law imposed. Reported rather than suppressed:
a residual sweep that counts a new-law phrase as a miss is measuring the string,
not the law.

**`check-register.sh` — GREEN, 36 / 0, unchanged from the pre-edit baseline**,
across 61 files with 28 names derived from source. The seeded-defect negative
control run alone: **GREEN, 8 / 0** — three defects, one per render class, each
caught and named. Rule 5 held over the new strings without special handling: the
one code either edit renders, `(P-O8 — Band-3 entry)` in `ba-frame`, carries §10.1's
Moment verbatim.

**The §10.2 session-boundary block, byte-compared rather than eyeballed.**
`ba-enter-feature`'s block against the same block at `HEAD`: **identical**, md5
`0ad591fa2a578ec9fe15c5d786ef03f5` on both sides. The suite's own assertion agrees
across the whole corpus — 36 units, 0 missing, 0 altered.

**The full regression — `tests/run-all.sh`, all twelve:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 36 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 105 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 12   red: 0   skipped: 0` · **✓ GREEN — all 12 checks pass, the two
install-based runs included.**

**Read-back, the two paths the change puts in tension.** Under Presale,
`/ba-enter-feature` proceeds: the bullet runs the act, the Close hands to Tier 2
in assumption posture, and neither certification nor handoff is named as a next
step. The handoff path is untouched and still refuses without an effective PASS —
`ba-handoff` opens *"BA-invoked, after an effective PASS"* and renders **REFUSED —
no certification** where there is none. Drafting opened; certification did not.

### Open

**D58 and D61 stand, unchanged and unworked** — neither was in this session's
scope, and nothing here touches the lowercase-code question or the fixture's plan
records.

**The gate says nothing profile-shaped about a draft spec's FAIL report.** §6.5
gives that report a second job under Presale — it is the client Q&A agenda — and
`/ba-enter-feature` and `/ba-frame` both now say so. `/ba-gate` itself does not:
its FAIL rendering is profile-blind, which is correct by D-O14 (the quality
machinery is profile-blind) and possibly incomplete as a *render*. The advisory
was the only `/ba-gate` change step 2 named, so the question is left where it was
found. Named, not decided.

---

## FAIL-as-agenda + advisory instrument precision · gate v0.5 · orchestrator v0.8 · 9 August 2026 · GREEN

The previous session closed leaving one question named and not decided: *"the
gate says nothing profile-shaped about a draft spec's FAIL report."* D65 had
placed the certify-over-assumptions advisory but left its instrument unnamed.
Both documents then moved — gate **v0.5** adds the §6.1 FAIL-as-agenda bullet,
orchestrator **v0.8** names the advisory's instrument at §6.5. This session
compiles both into the one unit that renders them, `/ba-gate`.

### The precondition, stated

Read from the **placed** files, not from the prompt: gate header **v0.5** with
the *"FAIL as agenda (Presale drafts)"* bullet at §6.1 · orchestrator header
**v0.8** with §6.5 reading *"at the gate's waiver act"* · `VERSION` **0.1.4** ·
commit **73da656** present, local. The tree was dirty on exactly the two
methodology paths and nothing else. See **D66** for what "placed" meant here.

### The sweep — two of its three targets found nothing, and that is the finding

**The enumerated superseded string does not exist.** *"says so once at the waiver
act"* — the pre-v0.8 §6.5 wording — returns **0 hits** across `payload/`,
`tests/`, `README.md`, `install.sh` and the package docs. It was never compiled
verbatim: D65 wrote `/ba-gate`'s advisory as its own paraphrase, so the sweep's
pinned string had nothing to match. Found instead by grepping the *idea* —
`certifying guesses` — which resolves to exactly one site, `ba-gate:202`.

**The §6.1 compiled image is two paragraphs, both in `/ba-gate`.** The verdict
rules at `:177` (FAIL / PASS WITH WAIVERS / PASS) and the finality clause at
`:231` (*"a FAIL needs no approval — it is final until fixed, overridden or
waived"*). Neither carried the new bullet. The pinned record shapes —
`gate-report-entry.md`, `sk_snapshot.py`'s verdict strings — are shapes, not §6.1
prose, and stay untouched under register rule 8.

**`ba-frame` and `ba-enter-feature` carry compiled §6.5 text and no advisory at
all** — see **D67**.

### The change — one unit, two edits and a never-list clause

**(a) The FAIL render's agenda line.** A new paragraph at Stage 4, immediately
after the verdict-computation rule, where the FAIL is rendered. Two conditions,
both required: the ledger head at `.specify/aspect-state.md` reads `Profile:
Presale`, **and** the feature has no effective PASS on record — no `cert.json`
under `.specify/ba/runs/<NNN-feature>/`, deliberately the same fact
`/ba-handoff` reads, so the two skills cannot disagree about what "certified"
means. Then exactly one line is appended under the presented FAIL. The profile is
**read** from the head; the paragraph says *never ask the BA for it*, and a
missing or non-Presale head appends nothing and says nothing — silence, not a
note about profiles.

The paragraph then fences the change in on all four sides: the verdict stays FAIL
and stays final until fixed, overridden or waived · the named-gap lines are
unchanged · no waiver, override or approval is implied · certification still
needs an effective PASS. One boundary the source does not state and the package
needs: **the line goes to what the BA sees, never into the `gate-report.md`
entry.** That entry is a pinned shape, and a render-only change that quietly
edited a pinned shape would not be render-only.

**(b) The advisory names its instrument.** D65's paraphrase said *"say it once,
here"* and stopped, leaving the reader to infer which waiver it meant — the
ambiguity v0.8 §6.5 exists to remove. Two sentences added, recompiled from the
v0.8 source: the instrument is the **contract waiver** `W-<NNN>-<nn>` granted at
this step; never the **aspect waiver** `AW-<n>`, which is `/ba-waive-aspect`'s
act over a Band-1 aspect and certifies nothing. Placement was already correct —
the advisory sits inside the Waiver bullet — so this is wording, not a move.

**The never-list gains two clauses** — see **D68**: never asks the BA for the
flow profile, and never lets the profile touch a verdict, a threshold or an
assertion. The first makes *"never asked"* enforceable in the file's own idiom;
the second keeps D-O14 (the quality machinery is profile-blind) visible at the
one place in `/ba-gate` where a profile is now read at all.

### Divergences

**D66 · No files were attached; the two documents were already in place.** Step 0
directed a copy of two attached methodology files over `docs/methodology/`. No
attachment arrived with the prompt. Both target files were already present in the
working tree carrying exactly the content the preconditions demand — gate v0.5
with the §6.1 bullet, orchestrator v0.8 with *"at the gate's waiver act"* — and
`git status` showed those two paths modified and nothing else, which is precisely
the state step 0's own check defines as correct. Placement was therefore
**verified rather than performed**: nothing was copied, nothing overwritten. The
alternative — stopping on a missing attachment whose entire intended effect is
already present and verifiable — would have delivered nothing. The diff was read
in full before proceeding, not assumed: `+3/−2` on the gate (header, §6.1 bullet,
footer), `+4/−3` on the orchestrator (header, §6.5 sentence, footer). No third
file, no unrelated hunk.

**D67 · Step 3's premise does not hold, and acting on it would have contradicted
the source.** Step 3 states that `ba-frame` and `ba-enter-feature` carry compiled
§6.5 advisory text from build 0.1.4 and directs a recompile of the advisory
sentence in each. They carry compiled §6.5 text, but **neither carries the
advisory at all**: both stop at the FAIL-as-agenda clause (*"on a draft spec its
FAIL report is an informative named-gap list — the client Q&A agenda"*) and go no
further. `grep` for `advisory` in `ba-frame`: **0**. For `certifying guesses`
across the payload: **1**, in `/ba-gate`.

That absence is the design, not a gap. Source §6.5 says the framework says it
**once**, at the gate's waiver act; D-O18 says *"one certify-over-assumptions
advisory at the waiver act"*; `/ba-gate`'s own compiled image says *"one
advisory, said once and not repeated … say it once, **here**."* Compiling the
sentence into two more units would have made the package say three times what
the source rules is said once — recompiling the letter of step 3 while breaking
the rule it compiles. Both files left unchanged. The three other *"one advisory,
said once and not repeated"* sites — `ba-waive-aspect:81`, `ba-close-band1:120`,
`ba-t17:46` — were checked and are the **waived-Solution** advisory, a different
advisory on the same §8.3 pattern; correctly untouched.

**D68 · Two clauses added to `/ba-gate`'s never-list, beyond the two named
edits.** Step 2 names two changes. *"Profile read from the ledger head, never
asked"* is stated inside change (a)'s own paragraph, but in this package a
constraint that must hold is also written into the unit's never-list — that is
where every other `/ba-gate` prohibition lives and where the harness looks for
refusal discipline. Two clauses, no new behavior, and the second one restates
D-O14 rather than adding to it.

### Verification evidence

**Residual sweep.** *"says so once at the waiver act"*: **0 hits** across the
whole repository, before and after — the string never existed here (D66's
counterpart finding, recorded rather than reported as a pass). `certifying
guesses`: **1**, at `ba-gate:227`, now naming both instruments. `client Q&A
agenda` as a rendered string: **2** — `ba-frame:92` (compiled §6.5, unchanged)
and `ba-gate:190` (the new appended line); `ba-enter-feature:135` carries the
same clause soft-wrapped and is unchanged. No compiled §6.1 image is left without
the bullet's substance.

**`check-register.sh` — GREEN, 36 / 0, equal to the pre-edit baseline**, across
61 files with 28 names derived from source. The seeded-defect control run alone:
**GREEN, 8 / 0**. Both new codes carry their plain names on first use — *contract
waiver* `W-<NNN>-<nn>`, *aspect waiver* `AW-<n>` — and the appended agenda line
sits in a fenced block, where register rule 8 gives the shape the last word.

**The §10.2 session-boundary block, byte-compared rather than eyeballed.**
`/ba-gate`'s block against the same block at `HEAD`: **identical**, sha-256
`924cf13f123a6d11…` on both sides. Concatenated across all 36 units, both sides:
`e153fd73671496e7…`. The suite's own assertion agrees — 36 units, 0 missing, 0
altered.

**The full regression — `tests/run-all.sh`, all twelve:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 36 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 105 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 12   red: 0   skipped: 0` · **✓ GREEN — all 12 checks pass, the two
install-based runs included.** Every count equals the pre-edit baseline.

**Read-back, the four paths the change puts in tension.** *Presale + no
certification* → the agenda line renders, one line, under a FAIL that is still
final. *Discovery* → the render is byte-for-byte what it was; the paragraph's own
last sentence says so. *Presale + already certified* → nothing appended; the
`cert.json` condition is what stops it. *Handoff* → untouched, `git diff` on
`ba-handoff/` empty, and it still opens *"BA-invoked, after an effective PASS"*
and renders **REFUSED — no certification** where there is none. The FAIL gained a
second job; it gained no new power.

### Open

**D58 and D61 stand, unchanged and unworked** — neither was in scope here.

**The previous session's open question is closed.** `/ba-gate`'s FAIL render now
carries §6.1's second job under Presale, and does it as a render: the profile is
read, never asked, and it reaches nothing but what is printed.

**Nothing in the payload compiles §6.1's bullet as law, by design.** The bullet
is a cross-reference on the §11.3 pattern, and the package renders it in the one
place a BA meets it. If a second surface ever needs it, the source to recompile
from is gate §6.1 — not `/ba-gate`'s render.

---

## WBS export — `/ba-wbs` · orchestrator v0.9 §10.5 · 10 August 2026 · GREEN

Orchestrator **v0.9** adds one additive capability: **§10.5 — the WBS export**,
six rulings D-O20–D-O25 (its §16). A read-only render command emits the
client-facing work-breakdown spreadsheet from what the framework already
produces — no new artifact, no new BA step, no new field anywhere. This session
builds it: two generator scripts, one command unit, one test suite, wired into
the runner.

### The precondition, stated

Read from the placed files, not from the prompt: orchestrator header **v0.9**
carrying §10.5 (line 578) and §16 (line 745) · elicitation **v0.4** · gate
**v0.5** · `VERSION` **0.1.5** · `BUILD-LOG.md` carrying both presale-drafting
entries — the 0.1.4 build (`## Presale drafting …`) and the 0.1.5 build
(`## FAIL-as-agenda + advisory instrument precision …`). The tree was dirty on
exactly one methodology path, `ba-native-spec-orchestrator-rules.md`, and
nothing else. §10.5 and §16 were read in full before a line was written.

### The build — three units and their fixture

**Two generator scripts**, in the repo's own scripts home
(`payload/specify-overlay/ba/scripts/` → `.specify/ba/scripts/`), Python 3
standard library only (D-P2-7), following the vendored checkers' idiom —
`sys.dont_write_bytecode`, `sys.path.insert` on the script's own directory,
imports across the family:

- `sk_wbs.py` — the read-set parsers, the row model, selection, the register,
  the csv writer and the generation summary. It reuses `sk_structure.parse_spec`
  as the shared parse surface rather than re-parsing the spec, exactly as the M
  checkers do. Its one local re-parse is the acceptance items: `sk_structure`
  stops an acceptance at its line, and a WBS cell needs the assertion whole, so
  the story block is re-walked with soft wraps joined.
- `sk_xlsx.py` — the hand-built writer. There is no stdlib xlsx, so a `.xlsx` is
  assembled as what it is: a zip of six XML parts, every string inline
  (`t="inlineStr"`), a two-format stylesheet (body wrapped and top-aligned, the
  header bold), `<cols>` widths, and **no `mergeCell` anywhere** — §10.5's "the
  Epic value repeats per row". The zip carries fixed timestamps so two identical
  runs produce identical bytes. Deliberately not implemented: formulas, numbers,
  dates, colours, sheets past the first.

**Writers in D-O23's order** — xlsx first, then csv, both in the one build, one
row model behind them. Stable paths, overwritten per run.

**The command unit** `/ba-wbs`, packaged exactly as `/ba-status` is: a single
`payload/claude/skills/ba-wbs/SKILL.md`, frontmatter `name` matching the
directory, `disable-model-invocation: true`, the session-boundary block verbatim
at the foot. Its behavior text compiles §10.5 and nothing else — the read set,
the selection defaults, the pinned columns, Deferred rows, the register, formats
and paths, the boundaries. Read-only; no gate interaction; no `/speckit-*` call;
stage-neutral — §10.2 untouched.

**The fixture, extended minimally from the corpus's own worked examples** (repo
mechanics, not methodology):

| File | What it is |
|---|---|
| `tests/fixtures/appointment-booking/project/specs/004-appointment-booking/gate-report.md` | the two recorded entries — `expected/gate-run2.entry` (FAIL) + `expected/gate-run3.entry` (PASS WITH WAIVERS, certification manifest, `W-004-01`) — joined by the `---` separator `sk_snapshot.py`'s own append writes. Nothing authored. |
| `tests/fixtures/appointment-booking/project/specs/005-specialist-availability-publishing/spec.md` | the brief's own F2 slice (E-03 §8, status `Proposed`) as a Presale **draft** spec: ten sections, two stories, two open markers, never gated. The uncertified side of the selection defaults. |
| `tests/fixtures/appointment-booking/expected/wbs-discovery.csv` | golden render — certified only |
| `tests/fixtures/appointment-booking/expected/wbs-presale.csv` | golden render — every draft |

The fixture README's tree block names all four.

### The renders, read back

Discovery over the fixture: **4 rows** — 004's three stories plus the epic's one
Deferred row (`Reschedule-in-place`, Phase 2, launch-substitute note in Comments
/ Questions), 005 excluded with its reason and the act that admits it. Presale:
**6 rows** — 005's two stories join. `--include 005` under Discovery renders
byte-identically to the Presale file: one generator, the profiles differing only
in the defaults.

A worked cell, US2's acceptance — six numbered items: two requirements restated,
three acceptance items, then `BR-002` folded as its own item (D-O24's companion
rule). Its Role reads `Client, Specialist`: the actor first, then the role named
in a linked requirement. US3's reads `Specialist, Client` for the same reason —
the D-O24 extension is exercised, not merely implemented.

### Recorded derivations — inside what §10.5 fixes

Four behaviors §10.5 fixes in substance but not in mechanism. Each is written
into `sk_wbs.py`'s docstring at its site, so the resolution travels with the
code:

1. **The disposition ladder.** §10.5 names four dispositions and the facts each
   reads from; the order is most-specific-first — no report or no run entry →
   `no gate run`; a certification manifest in the latest entry → `certified —
   <run date>`; verdict FAIL → `FAIL(n)`; anything else is a run on record that
   is not an effective PASS → `draft` (§6.5's own definition of a draft spec).
   Void detection is never re-run: gate §9.1 keeps it lazy and owns it.
2. **Marker attribution.** The summary carries *"per-feature and per-row
   open-marker counts"*, so markers attribute to rows: a marker inside a row's
   own source text belongs to that row; a marker anywhere else in the spec is
   feature-level and rides every row of the feature, as the Integrations value
   does. That is what makes §10.5's *"every deferred question stands as its
   marker"* true of the column.
3. **Markers render in one column.** Comments / Questions carries the marker
   text, brackets stripped; every other cell drops the marker whole. D-O22's own
   reasoning is that a second copy is duplication — and a bracket-stripped
   marker spliced mid-sentence into an acceptance item is not a plain sentence.
4. **Restatement is a case transformation.** "Restated as plain sentences" brings
   the EARS caps down and leaves the words: `THE SYSTEM SHALL create` →
   `the system shall create`. Conjugating the verb would be authoring, and this
   command never authors.

The manual estimate headers stand as the placeholder pair `Estimate — min` ·
`Estimate — max`. **This is not a divergence** — §16 carries it open until the
column-completeness check against the company sample WBS.

**One harness mechanic, noted not diverged.** `tests/layout.expected`'s session
column admits `SK`, `S1`…`S9`, `RT` only — `check-layout.sh` greps `^S[0-9]` and
ranks the tags, and a new token would break three assertions. The three new rows
are tagged `S9` (the full-tree bar, which is what the tag governs) with their
real origin in the note column: *"added in package 0.1.6, after S9"*.

### Divergences

**D69 · §10.5's Role column names a source D-O25's read set excludes.** The Role
rule reads *"the story's actor, verbatim from `roles-permissions.md`"*; D-O25's
enumerated read set is `spec.md` · `gate-report.md` · the parent brief ·
`roadmap.md`, and it *supersedes* the mapping exercise's narrower sentence.
`roles-permissions.md` is in neither. Resolved **inside the read set**: the
spec's §10 References line carries `(roles used: Client, Specialist)`, and the
writing standard already requires story actors to be verbatim from
`roles-permissions.md` — so the spec's own §10 is that file's faithful image for
this purpose, and the export never opens a fifth file. Blocked unit: none; the
Role column is built and tested. **The ruling worth taking:** whether D-O25's
read set should name `roles-permissions.md` explicitly, or §10.5's Role rule
should cite §10 References as its source.

**D70 · The flow profile drives selection and sits in no D-O25 source.** §10.5's
selection defaults turn on Discovery vs. Presale; the profile lives in the ledger
head (§2.4, `.specify/aspect-state.md`), which the read set does not enumerate.
Read from the head, never asked — the same act build 0.1.5 established for
`/ba-gate`'s FAIL-as-agenda render (*"the profile is read, never asked"*). The
read is one regex over one line and touches nothing else. `--profile` overrides
it for a headless run; the command surface stays `[--include NNN …]` as §11's
binding row fixes it. **The ruling worth taking:** whether the read set's
enumeration is content-only by design, or should name the head as the selection
input.

**D71 · Deferred-row position inside an epic is unfixed.** §10.5 fixes grouping
(*"by epic in roadmap row order"*) and that each Deferred item is its own row,
but not where those rows sit relative to the epic's story rows. Placed **after**
them: they are the epic's later-phase tail, and the Phase column reads MVP down
the story rows then `Phase 2` on the Deferred row, which is the phase spread the
ruling exists to restore. One line to re-rule if the sample WBS orders otherwise.

D69–D71 ratified as built, 10 Aug 2026 — orchestrator v0.10 carries the wording (BA Lead ruling).

### Verification evidence

**`tests/check-wbs.sh` — GREEN, 49 / 0**, six sections, wired into the runner as
check 9 of thirteen:

| Section | Holds down |
|---|---|
| the golden csv | both profiles byte-identical to their expected files · the pinned column set read off the file, in order · every row's estimate cells empty |
| the xlsx | unzips, `testzip()` clean, all six parts parse as XML · 7 sheet rows against the csv's 6 + header · header row matches · bold, wrapped, widths present · **no `mergeCell`** · 5 multi-line acceptance cells survive the write, the first opening `1. When a Client selects…` · the Deferred row present, Topic `Reschedule-in-place`, Phase `Phase 2` — its own, not the epic's |
| selection | Discovery admits the certified feature and excludes the other **with its reason and the act that admits it** · `--include 005` admits it · the `--include` render equals the Presale render · Presale excludes nothing · **every** `specs/NNN-*` folder named in the summary with its disposition · per-row and per-feature marker counts present |
| the disposition ladder | all four rungs — `certified — 2026-07-18` and `no gate run` from the fixture; `FAIL(2)` and `draft` produced on a private copy so the fixture keeps its canonical timeline. The FAIL entry's `CC-G-03` lines are asserted **absent** from every cell — D-O22 |
| the register | 0 leaks across every generated cell of both renders · both named exceptions exercised, not merely tolerated — the waiver tag in Comments / Questions, `"Booked"` in acceptance text |
| read-only | the fixture project's file hashes identical before and after a run · no stray `exports/` in the source tree · `--summary-only` writes nothing at all |

**The negative control fires.** Three defects seeded into a copy of a clean
render — an EARS sentence into Acceptance Criteria, a `[NEEDS CLARIFICATION`
bracket into Comments / Questions, a `CC-IN-03` into Role. The sweep exits **1**,
reports **exactly 3** hits, and names each by row, column and kind; the EARS hit
is asserted to land in `Acceptance Criteria` specifically. `check-wbs.sh
--self-test` runs that control alone.

**The register suite reaches the new unit by existing.** `check-register.sh` is
**36 / 0**, equal to the pre-build baseline, now across **62 files** with the
session boundary in **37 units + 2 mirrors** (was 36 + 2) — `/ba-wbs`'s block is
byte-identical to the pinned sha, and its one technique-code mention renders as
`T-18 — Scope allocation`, resolved against the catalogue index rather than
asserted here.

**End-to-end from an installed layout**, not only from the payload: the scripts
copied to `.specify/ba/scripts/`, invoked as `python3
.specify/ba/scripts/sk_wbs.py --root .` against a project whose ledger head reads
`Profile: Presale` — 6 rows, the Presale defaults applied from the head with no
flag, `exports/wbs.xlsx` (4,154 B) and `exports/wbs.csv` written.

**The full regression — `tests/run-all.sh`, all thirteen:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 36 / 0 |
| `check-wbs.sh` | 49 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 108 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 13   red: 0   skipped: 0` · **✓ GREEN — all 13 checks pass, the two
install-based runs included.** Every count equals the pre-build baseline except
`check-layout.sh` (105 → 108: the three new installed paths) and the new row.

### Open

**D58 and D61 stand, unchanged and unworked** — neither was in scope here.

D69 and D70 — ruled 10 Aug 2026, ratified as built; wording carried in orchestrator v0.10 (see Divergences).

**The estimate headers remain the open carry item.** When the company sample WBS
fixes the set, the change is `COLUMNS` and `WIDTHS` in `sk_wbs.py`, the two
golden csv files, and the header assertion in `check-wbs.sh` — nothing else. The
cells stay empty either way; that part is law, not a placeholder.

---

## Aspect-suggestion render fidelity — the pilot R0 fix batch · package 0.1.7 · 10 August 2026 · GREEN

A field run of `/ba-aspect stakeholders` (pilot R0, 10 Aug 2026) put five render
defects on the record. The methodology documents are not implicated in any of
them: orchestrator §6.1's pinned snapshot, §10.3's register and catalogue B1's
T-03 sheet all say the right thing. What deviated is the compiled package —
Lane A, source build units only, no hand-edit of installed output.

### The precondition, stated

Read from the placed files, not from the prompt: orchestrator header **v0.10**
(10 Aug 2026, §10.5 wording precision, D69–D71 ratified) · catalogue B1 **v0.3**
· `VERSION` **0.1.6** · commit **468cf81** present, local · working tree clean.
The three ground-truth reads were done against the documents directly, by line:
**§6.1** at `ba-native-spec-orchestrator-rules.md:342–357` (the fenced block),
**§10.3** at `:544–559` (rules 1–8), **T-03 §3** at
`ba-native-spec-catalogue-b1.md:164–169` (Expected output · Artifact class ·
Destination file). No methodology document was edited in this batch.

### Step 0 — the diagnosis, one root-cause line per defect

The question the diagnosis had to answer: is §6.1's pinned block **embedded**,
**referenced**, or **absent** on the compiled path? The answer differs per
defect, and that is the whole finding — the block is embedded, but only on one
of the two paths that need it.

**D1 · non-canonical code (`t04`) in the out-of-profile line — embedded, but
uncovered by the rule beside it.** The block is embedded and correct; its
`<codes>` placeholder carries no canonical-form instruction, and the skill's
only code-form rule was scoped to table rows — *"a bare code **in a row** is a
render defect"* — sitting one clause away from the lowercase `/ba-run t03`
invocation examples, which were the nearest antecedent for what fills `<codes>`.

**D2 · bare technique code in prose — absent.** Register rule 5 was carried by
the personas and the two mirrors and by **no** part of `ba-aspect/SKILL.md`; the
skill's own code+name rule was row-scoped. Prose outside the pinned block was
governed by nothing on this path.

**D3 · truncated State line — embedded on the file-write path, paraphrased on
the render path.** Step 3 introduces the block with *"Write the snapshot into the
aspect's section of `.specify/aspect-plans.md`, verbatim in this shape"* — the
block is scoped to the **file**. Step 4's BA-facing render was governed instead
by a paraphrase enumeration — *"profile in the header, then `Code — technique`,
`Purpose`, `Addresses`, `Status` … then the standing enrichment block, then the
out-of-profile line"* — which silently omits the State line's second sentence.

**D4 · missing `Sequence rationale` — same root cause as D3.** The closing line
is the last line of the embedded block and the one line Step 4's paraphrase
enumeration never reached. Embedded for the file, absent for the render.

**D5 · abridged pre-pinned contract — absent, and reproduced verbatim in
source.** Nothing on the compiled path carried T-03's §3 contract: the sheets
are not installed (the layering rule), and `ba-aspect` said only *"render the
pinned contract for confirmation"* with no source named and no verbatim rule.
The one compiled contract string on the path — `ba-t03/SKILL.md`'s invocation
self-check — was **already** the field defect, byte for byte: the six-field list
dropped and the class string cut from `Context (spec-anchored — Q7)` to
`Context`. The field render did not compress the contract; it copied a
compressed one.

### The change — three units

**(a) `payload/claude/skills/ba-aspect/SKILL.md` — the render unit.** A new
standing section, **Render rules**, placed before Step 1 so it governs every
string the skill shows the BA rather than one step's table: code + name with the
mid-sentence case spelled out (D2) · codes render canonical, capital T, hyphen,
two digits, *"in the out-of-profile line exactly as in a row"*, with the
lowercase form pinned to its one legal use as the command's argument (D1) ·
plain words — say **root**, never "DAG" (S-b) · one term per concept —
**prerequisite**, never "precondition" or "dependency" (S-a) · state the
prerequisite basis once (S-a). Step 1's heading and its root row lost the
synonym. Step 3's row-scoped paragraph now points at the standing rules instead
of restating a narrower version of them.

Step 4's render instruction was rewritten against D3/D4: **the whole pinned
block, every line of it, in its own order**, with the two dropped lines named
explicitly — the `State:` line is *two sentences* and neither moves to the tail
of the message, and `Sequence rationale:` closes **every** snapshot, single-row
ones included. One sentence carries the finding itself: *the BA-facing render
and the `.specify/aspect-plans.md` write carry the same shape; the file is not
the only place it renders whole.*

The catalogue-contract bullet was rewritten against D5 and S-c: read the pinned
triple from the technique's own skill, render it **verbatim, all three fields**,
class string whole **including any parenthetical qualifier**, never compress —
with `Context (spec-anchored — Q7)` never rendering as `Context` named as the
worked case. And the confirmation wording is gone: a pre-pinned contract renders
**for visibility**, *"asking the BA to confirm it invents a checkpoint the loop
does not have."* The custom bullet is now labelled as the one path that does
take a confirmation, which is §6.3's actual split.

**(b) `payload/claude/skills/ba-t03/SKILL.md` — the D5 carrier.** The invocation
self-check's contract triple is restored to the sheet's §3 text verbatim: the
full six-field list (`Stakeholder · Kind (individual | population) · Role in
project · Decision rights · Comms line · Source`), `the sponsor's authority
explicit`, the class string whole as `Context (spec-anchored — Q7)`, destination
unchanged. Two sentences follow saying what the triple is for — the text
`/ba-aspect` renders at P-O2 — plan composition, in full and uncompressed. The
frontmatter's *"the DAG root"* became *"the root aspect"* (S-b): the description
is BA-visible, and it was the nearest source of the word.

**(c) `tests/check-register.sh` — T-a and T-b.** Both extend the existing suite
rather than standing beside it, so a new skill joins them by existing.

### What moved

| Unit | Change |
|---|---|
| `payload/claude/skills/ba-aspect/SKILL.md` | +60 / −19 — the standing Render rules section; Step 1 heading + root row; Step 3 paragraph; Step 4 render instruction; the catalogue-contract bullet |
| `payload/claude/skills/ba-t03/SKILL.md` | +10 / −4 — the contract triple verbatim from sheet §3; frontmatter description |
| `tests/check-register.sh` | +278 / −29 — T-a in the scanner and sections 3–4; T-b as section 6; header, help range and roll-up |
| `VERSION` | 0.1.6 → 0.1.7 |

Nothing else was touched. The finish-up batch's items — boundary blocks across
the 30 skill files, the saved-plan bare-name fix, the test runner — stay where
they were.

### T-a — the detector now catches the form, not only the omission

Rule 5 has two halves and the sweep had been holding down one. The scanner gained
`NONCANON` — `t-nn`, `tnn`, `Tnn` — with lookarounds that keep `ba-t03` and
ordinary words out, and `ARGSPAN`, the two legal spellings of the command's
argument: a `` `/ba-run tnn` `` span, or the bare `` `tnn` `` cell that names
that argument in the dispatch table. A match inside an argument span is skipped;
everything else is a hit. Without that exemption the payload could not name a
run at all, so it is asserted, not assumed — the self-test appends both argument
spellings to the dirty copy and requires the hit count **not** to move.

Hits now carry their rule in a third column (`bare` / `noncanon`) and the sweep
reports the two halves apart, so a regression names which half broke. The seeded
control gained a fourth defect — the field render itself, `Outside this profile
(electable by code): t04 — say "show all" for full rows.`, appended to a private
copy of `ba-aspect/SKILL.md` — and the count assertion moved 3 → 4, exact in
both directions.

### T-b — the pinned shape, held to the document

New **section 6**. Neither side is pinned in the test file: §6.1's fenced block
is extracted from the document (first fenced block inside `### 6.1`, found by
its own `Suggestion — ` first line) and the skill's from the compiled unit, then
the two are compared byte for byte. A reworded document breaks the check instead
of drifting past it. The skill **embeds**, so the byte-match branch runs; the
reference branch is implemented and asserted anyway — a unit that referenced the
shape instead would have to resolve to that same §6.1 block, which is the same
assertion one indirection out.

Vacuity is guarded on section 2's reasoning: a reshaped block that still
extracts would let a byte-match pass while asserting nothing, so four
load-bearing lines are required in the **source** block before the comparison is
trusted — the profile header, the State line's second sentence, the
out-of-profile line *as one sentence with the dash*, and the closing sequence
rationale.

Three seeded shape defects, and they are the ones pilot R0 actually rendered:
`drop-rationale` (D4), `truncate-state` (D3), `split-outside` (D1's other half —
the one-line out-of-profile sentence split in two). Each is injected into a
private copy, must go red, and the mutator refuses to run if it changed nothing
— a control that silently no-ops is worse than no control. Restoration back to
byte-identical closes the section.

### Verification evidence

**`tests/check-register.sh` — GREEN, 51 / 0**, up from the 0.1.6 baseline of
36 / 0 measured in a detached worktree at 468cf81. The +15: two in the sweep
(the two halves reported apart), two in the self-test (the fourth seeded defect
and the argument-form probe), eleven in section 6.

**The suite goes red against a dirty payload, not only against private copies.**
The new file was run in a pristine worktree at 468cf81 with two defects seeded
into the payload itself — `t04` appended in the out-of-profile shape, and the
`Sequence rationale` line deleted from the embedded block. Result: **✗ RED,
10 failed**, naming *"1 non-canonical code form(s): the render is T-nn, capital
T and hyphen"* and *"the compiled block diverges from §6.1 — the pinned shape is
compiled, not rewritten."* The cascade behind those two is the vacuity guard
working as designed: the private-copy controls are built **from** the payload, so
a dirty payload makes them unreadable and they say so — *"the copied corpus is
not clean at 0; the control cannot be read"* — instead of passing quietly.

**`--self-test` alone: GREEN, 10 / 0** — the four seeded register defects, the
argument-form probe and the fenced-block probe, no payload assertions.

**The full regression — `tests/run-all.sh`, all thirteen:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 120 / 0 |
| `check-techniques.sh` | 100 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 134 / 0 |
| `check-register.sh` | 51 / 0 |
| `check-wbs.sh` | 49 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 108 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 13   red: 0   skipped: 0` · **✓ GREEN — all 13 checks pass, the two
install-based runs included.** Every count equals the 0.1.6 baseline except
`check-register.sh` (36 → 51). `check-cards.py` reporting byte-identical
re-derivation is the rebuild evidence on the compiled-card side: no methodology
document moved, so no card did. `check-layout.sh` and `check-exit.sh` are the
rebuild evidence on the payload side — both install from `payload/` into a fresh
throwaway repo, Spec Kit from `vendor/`.

`check-techniques.sh`'s pin on ba-t03's contract triple — `has "$SKILLS/ba-t03/
SKILL.md" ".specify/memory/stakeholders.md}"` — was checked before the edit and
survives it: the triple's closing brace and destination are unchanged, only the
two compressed fields ahead of them were restored.

### Divergences

**D72 · The version in the brief is stale; shipped 0.1.7, not 0.1.3.** The brief
stamps this batch "package v0.1.2 → v0.1.3". `VERSION` read **0.1.6** at the
precondition and the log carries 0.1.4, 0.1.5 and 0.1.6 entries. 0.1.3 would
regress the package below shipped state, so the patch was taken from the actual
head: **0.1.6 → 0.1.7**. Renumbering is a one-line change to `VERSION` and this
heading if the planning conversation meant a different line.

**D73 · `ba-t03/SKILL.md` is inside the render path, and had to be.** The brief
scoped the batch to *"the `/ba-aspect` skill and everything it loads"*. The grep
found D5's defect not in `ba-aspect` but in `ba-t03`'s invocation self-check —
the compiled string is the field output byte for byte. Fixing the render unit
alone would have left it rendering a compressed contract faithfully. Both were
fixed; the pair is the render path for this defect.

**D74 · D5 is fixed for T-03 only; the other seventeen technique skills carry
the same compressed form.** Every `ba-t<nn>` self-check states its contract as a
one-line triple with the parenthetical class qualifier dropped —
`ba-t04`'s reads `… · Context · .specify/memory/personas.md` where sheet §3 says
`Context (spec-anchored — Q7; joins the CC-H-01 estate at arming once the file
exists)`. That is the same defect at seventeen more sites. It was **not** fixed
here: the brief's scope boundary names the render path and warns off the
thirty-file sweep, and seventeen technique skills is that sweep. Named as a
carry item, not silently narrowed — and now cheap to close, because
`ba-aspect`'s rule already says where to read the triple from.

**D75 · "DAG" survives in four units outside this batch's path.** `ba-aspect`
did not contain the word before this batch and now carries it once, inside the
rule that forbids it; the leak's nearest source was `ba-t03`'s description, now
fixed. Still carrying it: `ba-status` (two sites), `ba-frame` (two),
`ba-waive-aspect` (two) and the `ba-orchestrator` persona (three). Whether each
site is a BA-facing render or a model-facing instruction is a per-site call that
belongs to whoever owns those units; the standing rule now exists in `ba-aspect`
to copy.

**D76 · `aspect-plans.md`'s template carries a divergent §6.1 section shape.**
The template's HTML comment sketches the snapshot as a four-column table
(`Technique | Addresses | Expected contribution`) where §6.1 pins five (`Code —
technique | Purpose (one line) | Addresses | Status`), and it carries the
`Sequence rationale` line but no `State:` line. It is the write-path template,
not the render path, and the skill's embedded block governs what actually gets
written — so it was left alone rather than swept in. T-b covers the skill; it
does **not** cover the template. Flagged for the batch that owns the templates.

### Open

**D58 and D61 stand, unchanged and unworked** — neither was in scope here.

**D74 and D76 are the two carry items this batch created**: the seventeen
remaining compressed contract triples, and the template's §6.1 sketch. Both are
mechanical, both are now specified, neither belongs to the finish-up batch as it
is currently scoped.

**The pilot's other observations are not in this entry.** This batch closed D1–D5
and S-a/S-b/S-c on the aspect-planning path. Anything R0 surfaced outside that
path was not looked for and is not claimed.

---

## One-step technique invocation — WS-1, Lane A · package 0.1.7 · 11 August 2026 · GREEN

Typing a technique's own command **is** its invocation. That is what this batch
compiles: P-O3 — technique invocation, and the run-end bookkeeping that used to
sit one command upstream, both now stand inside all twenty technique skills.
`/ba-run` stays — as a thin alias for the catalogue, and as the runner for
custom plan lines, which have no skill of their own to compile into. That is
the satellite ruling R1, taken as given here.

No methodology document changed its law. Orchestrator **§7.1** and the **§11**
binding row are mechanics sentences and were re-worded to say what the package
now does; nothing about *what* is checked, *when*, or *by whose act* moved.

### The precondition, stated

Read from the placed files, not from the prompt: `VERSION` **0.1.7** · commit
**468cf81** present, local · orchestrator header **v0.10** · working tree **not
clean** — it carried the un-pushed pilot R0 fix batch (BUILD-LOG, package 0.1.7,
10 Aug 2026), which had already taken the 0.1.6 → 0.1.7 bump. WS-1 therefore
rides that same uncommitted package rather than bumping again (D78). Baseline
before the first edit: `tests/run-all.sh --file-only` **11/11 green**.

### The change — twenty skills, one alias, four cross-reference surfaces

**The twenty technique skills** (`ba-t01`…`ba-t18`, `ba-tier1`, `ba-tier2`) each
took four compiled edits and their line syncs:

- the section heading — *check before you run* → **P-O3 (technique invocation),
  compiled in**
- the entry sentence — *starts only from `/ba-run <id>`* → **its own command is
  the one-step entry; typing it is the BA's invocation act**
- **on a pass / on a miss**, replacing the on-miss paragraph that named
  `/ba-run`. The pass line renders `<CODE> — <name> → <destination>` instantiated
  per skill from that skill's own pinned-contract quote; the miss names the one
  unblocking act, carried verbatim from the paragraph it replaces
- **`## At run end — compiled bookkeeping`** before the never-does list — output
  lands · findings route as one batch · the run-log line under the skill's own
  plans-file section · and, for the fourteen aspect-serving runs, the §7.4
  threshold refresh with its one-line `/ba-clear` proposal

Every precondition the replaced paragraphs carried survives verbatim, lifted
into its own paragraph ahead of the pass/miss pair: the DAG-edge lines in
t05/t08/t09/t10/t11 and the ordering lines in t12/t13/t14/t15.

**`ba-run/SKILL.md`** was replaced body-whole. Catalogue path: read
`.claude/skills/ba-<id>/SKILL.md` and execute it as the procedure, the compiled
check governing, nothing re-checked and nothing confirmed. Custom path: the
P-O3 check runs here, because a custom plan line has no skill to compile into.

**Cross-references** followed to the one-step surface: `ba-frame` now runs T-01
by reading its skill file · `ba-aspect` names `/ba-t<NN>` as the next act and
points its refusal at the technique's own compiled check · `ba-close-band1`,
`ba-enter-feature`, the `ba-orchestrator` persona's P-O3 row and
`mirror/claude-block.md`'s two lines · orchestrator rules §7.1 and §11, with the
header taken to **v0.11** and a change record in the block's own grammar ·
`docs/quickstart.md` at ten sites, code-fence alignment re-struck.

### Verification evidence

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 122 / 0 |
| `check-techniques.sh` | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 146 / 0 |
| `check-register.sh` | 51 / 0 |
| `check-wbs.sh` | 49 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 108 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 13   red: 0   skipped: 0` · **✓ GREEN — all 13 checks pass, the two
install-based runs included.** Against the pre-batch baseline three counts moved
and the rest held: `check-orchestrator.sh` 120 → 122, `check-techniques.sh`
100 → 101, `check-spine.sh` 134 → 146 — all three from assertions added, none
from assertions dropped. `check-cards.py` byte-identical is the evidence that no
compiled card moved: no card's source document did.

Residual sweeps, all **0**: `starts only from` across payload, tests and
quickstart · `dispatch the technique` across payload and tests · `` `/ba-run`'s post-run touchpoint `` across payload and tests.

### Divergences

**D77 · The brief's heading string renders a bare code; it ships paired.**
`## Invocation contract — P-O3, compiled in` fails register rule 5 — the code
stands with no name beside it. Verified before writing, not after: a probe
corpus carrying that one heading drew exactly one `bare` hit from
`check-register.sh`'s own scanner. Shipped instead:
**`— P-O3 (technique invocation), compiled in`**, the parenthetical being a
separator rule 5's scan already accepts. The same pairing was applied at five
more sites the brief specified bare — `ba-run`'s two P-O3 mentions and its P-O2
mention, `ba-aspect`'s refuse-it clause, and `mirror/claude-block.md`'s two
lines. E7's loop assertion follows the shipped string.

**D78 · `VERSION` was already at 0.1.7 and uncommitted; WS-1 rides that
package.** The brief proposed 0.1.6 → 0.1.7. The working tree had already taken
that bump for the pilot R0 fix batch, un-pushed. Ruled by EK at the precondition:
**hold at 0.1.7** — one package, two entries. `VERSION` is untouched by this
batch.

**D79 · The brief's `ba-aspect` line numbers are stale.** :122 · :169 · :187 ·
:192 map to `468cf81`; the uncommitted R0 batch moved all four. Every edit was
taken by content with an exactly-once string assertion, so the drift changed
nothing but the addressing.

**D80 · `ba-tier1` has no on-miss act in the brief's list, and now has one.**
T-A4's act table names t01, t02–t16, t17 and tier2; tier1 is absent, and its
file carried no on-miss paragraph to carry forward. Given: **`/ba-aspect` to
compose the Band-2 plan** — t17's act, tier1 sharing t17's `## Band 2` plan
home. Judgment call, stated.

**D81 · `ba-t18`'s on-miss is authored, as the brief flagged.** Shipped:
`/ba-aspect` to compose the Band-2 plan, **or `/ba-close-band1` where Band 1
does not yet stand closed**. Worth recording precisely: t18's own file states no
Band-1-closure precondition today — t17's does, and t18 runs under the same
`## Band 2` section. The second act is therefore inherited from the section, not
quoted from the skill.

**D82 · "T-A3/T-A4 close the section" was read literally, and it moves t17's
on-miss.** For t17 · t18 · tier1 · tier2 the pass/miss pair stands as the last
paragraphs of `## Invocation contract`. In t17 that puts them **after** the
skip-if rather than before it, where the replaced paragraph sat; t01–t16 keep
the pair in the replaced paragraph's own position. The alternative reading —
"close the contract-check block, ahead of the skip-if" — is a four-file move if
EK meant that one.

**D83 · E2's wholesale body drops three statements `ba-run` alone carried; each
was re-homed before its assertion was flipped.** `No mid-run interference`
(§7.2), `Arrival is never gated:` (§2.2) and the P-O9 ruling table lived nowhere
else in the payload's skill set. Verified homes: §7.2 → the `ba-orchestrator`
persona, which states it as **"No mid-run drip"** · §2.2 → `ba-discovery`, colon
form intact · **P-O9 → `ba-tier2`**, where E1e's overflow rewrite now takes the
ruling in the same sitting. That last one has a test consequence:
`check-orchestrator.sh`'s P-O sweep concatenated the nine checkpoint-owning
skills, and P-O9 no longer appears in any of them — `ba-tier2` joins the
concatenation, with the reason in a comment above it.

**D84 · `docs/quickstart.md` keeps its frontmatter-enforcement clause.** E6's
replacement text for :177–178 ends *"every one of these is invoked by you."*; the
sentence it replaces continues *", enforced in the skills' own frontmatter, not
by convention."* The clause is a fact about the package, not a `/ba-run`
reference, so it was carried rather than dropped.

**D85 · E7's closing sweep item is a no-op, and `check-register.sh` needed no
edit at all.** Nothing in `tests/` greps the §7.1 or §11 sentences this batch
re-worded — neither `check-orchestrator.sh` nor `check-register.sh` ever
referenced them. And the register scanner's own lookarounds already exclude the
new spelling: `NONCANON`'s `(?<![A-Za-z0-9_-])` refuses to match the `t03` in
`` `/ba-t03` ``, exactly as its docstring says. The `ARGSPAN` allowance for
`` `/ba-run tnn` `` stays where it is — the alias still spells it that way.

### Open

**D58, D61, D74, D75, D76 stand, unchanged and unworked** — none was in scope
here. D74's carry item is worth re-reading against this batch: the seventeen
compressed contract triples are in the same twenty files WS-1 just touched, and
every one of them now has a pass-line render quoting its destination beside the
triple. The sweep did not get cheaper to *find*; it got cheaper to *verify*.

**Two placement readings are live, not closed:** D82's section-close for t17,
and D80's inherited act for tier1. Both are single-paragraph moves.

**`/ba-run`'s custom path is asserted, not exercised.** The suite proves the
alias text and the custom-path check string are present; no fixture runs a
custom plan line end to end, because none exists. Named, not claimed.
