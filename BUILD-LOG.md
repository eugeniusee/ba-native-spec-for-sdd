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
