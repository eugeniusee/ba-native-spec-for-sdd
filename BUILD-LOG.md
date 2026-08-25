# BA-Native Spec — Phase-2 Build Log

One record per Claude Code build session (build plan §4). Append-only: a session
record is written when its exit test is green and is never rewritten. Divergences
between the build plan and verified reality are flagged here, at the session that
found them — never silently resolved.

## Versioning discipline (ruled 14 Aug 2026, binding from F-05 on)

**Patch bumps are automatic.** Every build pass increments `VERSION` itself as a
patch increment — `0.1.15` → `0.1.16` — and records the new version in its own
entry. A pass that changed nothing that ships still says so; a pass that shipped
work and left `VERSION` behind is a defect, not a deferral.

**Minor and major stamps are the BA Lead's act, and only his.** He takes them at
his own initiative. **The framework never prompts for one** — not in a report,
not in an entry's Open section, not as a question at the end of a pass. A pass
that proposes a minor bump has asked for a ruling nobody requested.

**Registered, not retrofitted.** Entries written before this ruling state the
older convention — *"version stamping is the BA Lead's act,"* patch included —
and they stand exactly as written: this log is append-only, and a record that was
true when written is amended by a later ruling on the record, never by rewriting
it. Read the older entries against this section, not around it.

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

---

## WBS export — the References-shape defect · package 0.1.8 · 11 August 2026 · GREEN

A field run of `/ba-wbs` over a 36-spec estate produced **an empty export** —
`exports/wbs.xlsx` and `exports/wbs.csv` with the header row and nothing under
it — while the generation summary still reported rows per feature. Three
defects, one visible.

### The defect, reproduced before it was fixed

**`sk_wbs.py` read §10 References more strictly than the gate does.** Its
`reference_line()` required a labelled bullet — `- Parent epic scope brief: …`,
`- Roles & permissions: …` — which is the template's shape but not the only
shape that certifies. The gate's own reader is permissive:

- **CC-TR-02** (`sk_idgraph.declared_paths`) finds each required reference by
  its **path**, anywhere in a non-fenced, non-comment References line. The label
  is decorative.
- **CC-TR-03** finds the roles declaration with `roles?\s+used\s*:` anywhere in
  such a line — bulleted or not, parenthesised or not.

So a References section of bare-path bullets plus a standalone `Roles used:
Client, Specialist` line **passes the gate and certifies** — and the export read
neither the parent brief nor the roles off it. `spec_epic_id()` returned empty,
no feature matched an epic in the grouping loop, and every row was dropped
before the writers ran.

Reproduced against the fixture before touching the fix: both fixture specs'
§10 rewritten to the bare-path shape → `sk_idgraph.py` returns **CC-TR-02 PASS
— 4/4 required references listed and resolving** and **CC-TR-03 PASS — 2 role(s)
declared = 2 used**; `sk_wbs.py` on the same tree returns **0 rows**. The gate's
verdict and the render's verdict on one spec disagreed, and the render was the
one that was wrong.

**Two more defects the first one hid behind:**

- **A feature whose epic does not resolve was dropped silently.** §10.5's rule is
  that *nothing is silently dropped or silently included* — the summary names
  every `specs/NNN-*` folder. An unlinkable feature was named in the disposition
  table and then vanished from the file with no line saying so.
- **The summary counted rows that were never written.** The per-feature Rows
  column read `len(f.rows)` — rows *built*, not rows *emitted*. That is why the
  empty run still reported 3 and 2: the table could disagree with the file it
  described, and did.

### The fix — three changes, all in `sk_wbs.py`

1. **The gate's readers, imported rather than restated.** `PATH_RE` and
   `ROLES_DECL_RE` now come `from sk_idgraph`, and a new `reference_lines()`
   walks the same line set `declared_paths` walks. The epic id is the stem of
   the References path containing `scope/` — CC-TR-02's own needle for the
   parent brief — with a bare `E-nn` mention as fallback; the roles vocabulary
   is CC-TR-03's declaration, split on its two separators. **The gate is the
   authority on what a valid References section looks like, and this render is
   never stricter than the check that certified the spec it renders.** A second
   copy of those patterns is a second thing to drift, so there is no second copy.
2. **An unlinked feature renders at the tail** with Epic and Phase empty — an
   absent source renders an empty cell, never a guess — and the summary gains an
   `Unlinked: <folder> — §10 References names no parent epic scope brief` line.
   Nothing is dropped without a word.
3. **The summary counts emitted rows**, per feature and in the headline, and
   gains a `No rows: <folder> — selected, but §2 yielded no User Story` line for
   a feature that contributes nothing.

Consistent with **orchestrator v0.10**, which ratified D69 as built: the Role
scan's vocabulary is *"the spec's own §10 References 'roles used' line"* and
`roles-permissions.md` stays outside the read set. v0.10 fixes the **source**;
it does not fix that line's **shape**, which is why the gate's reader is the
right authority for it.

### Verification evidence

**`tests/check-wbs.sh` — GREEN, 62 / 0** (was 49 / 0). Two new sections, thirteen
new assertions:

| Section | Holds down |
|---|---|
| §10 References, read as the gate reads it | the premise proved, not asserted — `sk_idgraph.py` returns CC-TR-02 PASS and CC-TR-03 PASS on the bare-path shape · the export is **byte-identical across both References shapes** · the epic resolves from a bare path · Role cells populate · a feature with no resolvable epic is **named** in the summary, its rows **still render**, its Epic cell is **empty**, and its Role cell still reads |
| the summary counts what was written | the headline row count equals the file's rows · no feature is credited rows the file does not carry — checked on the normal render and on the unlinked case |

**The fix's own negative control.** The two new sections were run against the
pre-fix parser (`git stash push` on `sk_wbs.py` alone): **7 failures**, including
*"the render disagrees with itself across References shapes"*, *"the unlinkable
feature vanished without a word in the summary"*, and *"the per-feature rows sum
to 5, the file has 3"* — the lying summary, caught by its own assertion. Restored:
62 / 0.

The two golden renders are **unchanged** — `expected/wbs-discovery.csv` and
`expected/wbs-presale.csv` byte-identical before and after. The fix widens what
the parser accepts; it changes nothing about what it produces from the shape it
already read.

**The full regression — `tests/run-all.sh`, all thirteen:**

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
| `check-wbs.sh` | 62 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 108 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 13   red: 0   skipped: 0` · **✓ GREEN.** Every count equals the 0.1.7
baseline except `check-wbs.sh` (49 → 62).

### Divergences

**None.** The fix implements §10.5 as written; nothing here required a behavior
the document does not fix.

### Open

**The lesson, named so it is not relearned.** The 0.1.6 suite tested the export
against one fixture, and that fixture used the template's shape. Every assertion
passed and the unit was still unusable on a real estate. A parser that consumes
a gate-checked artifact should read it **through the gate's own reader**, not
through a second reader written against the template — and where it cannot, the
suite needs a second authored shape, not a second run of the first one.

**The estate needs no edit.** The 36 specs' References sections are valid as
authored; re-authoring them would have been spec editing on certified-path text
for no gain the gate asks for. The defect was the render's.

**Field action:** re-run `/ba-wbs`. The header-only `exports/wbs.xlsx` left by
the failed run is overwritten in place — the paths are stable and every run
rewrites both files.

## Dashboard v2 — `/ba-status` at orchestrator §10.4 · the two bookkeeping defects · package 0.1.9 · 12 August 2026 · GREEN

The first live Presale field render of `/ba-status` (11 Aug) was read against a
real estate and found to be answering a question nobody had: the D-O17 shape
predated Presale drafting (D-O18) and the WBS export (D-O20–D-O25), so it
reported six aspect states and a certification count over a project whose actual
work was **eight epics, one brief, two draft specs and no certifications at
all**. No Band-2 coverage. No denominators — `2 certified` says nothing without
the `of what`. And the Discovery-shaped lines read as failure under a profile
that rules them out of scope.

The satellite design conversation ruled the rebuild (D-O26–D-O29, orchestrator
§17, v0.11). The same render surfaced **two package defects of its own**, and
both ride this build: the run log under-records what the framework does, and the
health head cannot say whether it is stale.

This build propagates the methodology change. It writes nothing under
`docs/methodology/`.

### S1 — the nine-line shape (D-O26)

`/ba-status` renders §10.4's pinned nine lines. The command keeps its ledger-head
half unchanged — the head read verbatim, the openable-aspect derivation, the lazy
read of revisit triggers — and its dashboard half is now
`.specify/ba/scripts/sk_status.py`, on the `/ba-wbs` precedent: a render command
whose counts are a script's, whose shape is the document's.

**Two source classes (D-O28).** Activity reads the ledgers. Coverage reads the
estate on disk — `specs/NNN-*/`, the latest `gate-report.md` entry per feature,
the briefs and kits, the roadmap. Every number renders with a named source, and
a count whose source is silent renders `—`.

**The read is §10.5's, imported, not restated.** `sk_status.py` takes
`read_gate_report`, `spec_epic_id`, `feature_folders`, `read_roadmap`,
`read_profile` and `MARKER_RE` from `sk_wbs.py` — which in turn takes its §10
References readers from the gate's own `sk_idgraph`. The dashboard and the export
therefore cannot disagree about what *certified* means or which epic a spec hangs
under. That is the 0.1.8 lesson applied before it could be relearned: a second
reader is a second thing to drift.

**Formula §10.4-F (D-O27), verbatim in the skill.** B1 = settled/6 · B2 =
briefs/epics · B3 = drafted/entered under Presale, certified/entered under
Discovery; the workflow line is their mean. Bars are ten cells. **A zero
denominator renders `—`, never 0%** — on the bands and on the workflow line
alike: a project with no epics is not 0% through Band 2, it has not been asked
the question yet. The workflow line is the **one sanctioned composite**; the
skill's never-list was amended to say so and to keep every other composite
banned.

**Line 8 switches on profile (D-O26).** Discovery renders the handoff-risk table
with its four countable facts and the unchanged banded rule. Presale renders exit
readiness — roadmap currency, drafted/entered, open markers, and whether
`/ba-wbs` can run. Out-of-profile facts render as **law**: under Presale,
"certification & handoff out of profile" names where the method ends, not where
the project is behind.

### S2 — line 6 · the ledger-coverage self-report (D-O26)

The instrument names its own blind spots. Line 6 compares the estate on disk
against the §7.3 run-log lines in `.specify/aspect-plans.md` and names the
divergence: `run log under-records Band 3: 2 on disk vs 0 logged`.

Only run lines that **name an element** are counted, because only those can be
read against the estate — a `## Band 2` section also holds the project-wide T-17
(epics decomposition) and T-18 (scope allocation) lines, which produce no
per-epic artifact. An epic-named Tier-1 line stands against its brief or its kit
one to one; a feature-named Band-3 line stands against its entered feature.

### S3 — line 5 · the refresh state — defect fix 1 of 2

**The defect:** the health head could be months stale and the render said nothing.
Line 5 now compares the **full runs recorded** in `.specify/gate-health.md`
against the gate's own cadence — one full run per scope-brief ingestion batch,
plus the arming run at Band-1 closure (contract §3) — and reports
`current` or `overdue: <n> runs vs cadence`, showing both sides.

**Display only.** The refresh act stays `/ba-gate-health`'s. The line reports and
names no act of its own; the skill's never-list says so, and the suite asserts
the render never proposes the refresh as automatic. A Scope H that has never run
still reads `disarmed (pre-closure)` — a fact, not a gap.

### S4 — the run log records what it books — defect fix 2 of 2

**The defect, in two halves.** `ba-tier1` runs **per epic** and booked
`<date> · <CODE> · contract: …` — no epic named, so five per-epic runs left five
indistinguishable lines and the log could not say how much of the estate the work
had reached. `ba-tier2` booked **nothing at all**: *"no plans-file line: the
feature's record is its band event in the ledger, the spec, and the gate report."*

§7.3 owes a contract-fulfillment line for **every** run, and the document's third
runtime rule is that every record names its element and its action. Both were
fixed to that:

- **Tier 1** — `<date> · <CODE> <mode> <E-nn> · contract: …`, one line per mode
  per epic. This restores what §6.4's own exhibit already carries: the fixture's
  Band-2 log has read `tier1 kit E-03` and `tier1 ingest E-03` since S8. The
  skill's compiled line had lost the element the exhibit shows.
- **Tier 2** — `<date> · TIER-2 <NNN-feature> · contract: …` under `## Band 3`.
  It does not replace the feature's other records; it is the run's own line.

**Forward-only, stated in both skills.** A run that was never logged stays
unlogged. Nothing was reconstructed, and **the fixture was not touched** — which
is why the fixture still renders `under-records Band 3: 2 on disk vs 0 logged`.
The instrument reporting a real historical gap is the instrument working.

`/ba-run` needed no change: it forwards a catalogue technique to that technique's
own skill, so both fixes reach the alias path unmodified.

### S5 — the `--html` derived render (D-O29)

`/ba-status --html` additionally writes `.specify/status.html` — beside the
runtime ledgers, under the D-G1/D-G8 rule that keeps them out of
`.specify/memory/`, so the file never enters CC-H-01's spec-anchored glob and its
own write never fires a scoped health run.

Self-contained: inline styles only, **zero external resources** — no stylesheet,
no font, no script, no fetched image. The same counts and the same formula; the
chat render is embedded verbatim, because presentation is the whole of the
difference. Derived on the gate's `traceability.md` precedent — regenerated every
invocation, never hand-edited, and the suite proves a hand edit dies at the next
run. The chat render stays primary.

### S6 — register, tests, version

Register (§10.3) conformance holds: `check-register.sh` is **51 / 0** unchanged,
with every P-O and technique code in the new strings carrying its name.

**One re-pin, recorded.** `check-spine.sh` pinned the defect:

```
has "$TI2" "no plans-file line" "Tier 2 keeps no plans-file line — …"
```

That assertion held down package behavior, not methodology-verbatim text, so it
was **re-pinned to the fixed behavior** rather than loosened — four assertions in
its place (Tier-1's element, Tier-2's section, Tier-2's element, the forward-only
rule), with the reason and the previous needles recorded inline at the site.
No methodology-verbatim pin was touched anywhere.

### Verification evidence

**`tests/check-status.sh` — GREEN, 94 / 0**, a new suite on the `check-wbs.sh`
precedent. Nine sections:

| Section | Holds down |
|---|---|
| the pinned shape | the nine lines, once each, in order, with §10.4's prefixes · four ten-cell bars · the workflow line naming its own formula |
| the counts | every number against the §12 estate, whose values are known — settled, briefs/kits, entered, drafted, gated, certified, the questions and their oldest open one |
| formula §10.4-F | Discovery 54% and Presale 71% computed from the same estate — the B3 term swap is visible in the mean · a full ratio fills ten cells · **zero denominators render `—`, and `0/0` appears nowhere** |
| line 5 · refresh | `current` on the fixture · `overdue: 1 run vs cadence (2 recorded of 3 …)` once a second brief is ingested · `—` while disarmed · the act never proposed |
| line 6 · coverage | the fixture's own Band-3 divergence, named with both sides · a seeded Band-2 gap caught the same way · `clean` when there is nothing to under-record |
| line 8 · profile | each variant present under its own profile and **absent under the other** · the risk rule stated in full · out-of-profile facts as law |
| the HTML render | eight external-resource probes, all absent · inline styling present · the same counts embedded · a hand edit dying at the next run |
| read-only | the estate hashes identical across four runs · a run without `--html` writes nothing · the fixture unchanged |
| the skill | the pinned shape and formula §10.4-F carried verbatim against the document's own text · the never-list amended, not dropped · the session boundary intact |

**The full regression — `tests/run-all.sh`, all fourteen:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 122 / 0 |
| `check-techniques.sh` | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 149 / 0 |
| `check-register.sh` | 51 / 0 |
| `check-wbs.sh` | 62 / 0 |
| `check-status.sh` | 94 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 110 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |

`ran: 14   red: 0   skipped: 0` · **✓ GREEN**, the fresh-install layout bar and
the Phase-2 exit test included. Every count equals the 0.1.8 baseline except
`check-spine.sh` (146 → 149, the re-pin), `check-layout.sh` (108 → 110,
`sk_status.py` plus `.specify/status.html` asserted runtime-born-absent), and the
new `check-status.sh`. **The runner is now fourteen checks, not thirteen** — its
header, its `--list` output and its roll-up were updated in step.

### Divergences

**D86 · §6.4 houses no run log for a Band-3 run, and §7.3 owes one.** §7.3's
bookkeeping table mandates a contract-fulfillment line for every run and names
the file (`.specify/aspect-plans.md`); §6.4 enumerates the section homes — one
per aspect, `## Frame` (D-B1-4), `## Band 2` for T-17 and T-18 (D-B6-5) — and
names none for Tier 2. Read against it, §8.4's *"the orchestrator records the
band event … and nothing else"* can be read as closing the question. *Resolution
taken:* the two govern different acts — §8.4 scopes the **band event**, §7.3
scopes the **run** — so Tier 2 books its line, and the package places it in a
`## Band 3` section created on first use. This placement is **the build's, not a
ruling**: the template comment says so at the site. *Doc-first (§3.5):*
**orchestrator amendment candidate** — one line in §6.4 naming Band-3's section
home, and one clause in §8.4 confirming its "nothing else" is about the band
event. Not legislated here.

**D87 · §10.4 counts "handed off" from a handoff record the package does not
write.** The count definition reads *"handed off = the handoff record present"*.
`/ba-handoff` produces no per-feature record: it re-points `.specify/feature.json`
(single-valued, one feature at a time) and cuts the branch. Neither is countable
per feature, and reading git state would add a source class §10.4 does not name.
*Resolution taken:* the count renders **`handed off —`**, its missing source
named — §10.4's own discipline, the instrument reporting its blind spot rather
than guessing. The suite pins it. *Doc-first (§3.5):* **package or orchestrator
question** — either `/ba-handoff` gains a durable per-feature record, or §10.4's
count definition names a source that exists. One line either way; not chosen
here.

### Open

**The line-9 ladder stops at Band 1, deliberately.** `Next:` names an act from
what the documents already fix — the DAG says which aspect is openable (§5),
§8.2 says when closure is due, the plans file says which technique is next
planned. Past Band 1 no document fixes an ordering, so the render prints `—`
rather than inventing one, and the skill's derived section is where the BA reads
the available acts. If the field wants a Band-2/3 next-act ladder, it is a
ruling, not a build decision.

**The HTML file's name is indicative.** §10.4 says so — `.specify/status.html`,
beside the ledgers, is the package's choice under a name the document leaves to
Phase 2.

**The methodology file is not in this commit.** Its working-tree revision reverts
§7.1 and the §11 Technique-run binding row to their pre-0.1.7 wording and
overwrites the v0.11 one-step-invocation change record, because it was authored
against the pre-0.1.7 base. That is a methodology repair, and this build does not
write methodology. The package ships dashboard v2 against §10.4 as ruled; the
document reconciliation is the BA Lead's, outside this commit.

---

## Install UX — the bootstrap one-liner · the uv-free fallback held at D88 · 12 August 2026 · GREEN

The install UX was ruled in two levels: **L1**, a one-line install needing no
clone and no GitHub account, and **L2**, an install that survives a machine with
no `uv`. **L1 ships**, proven end to end over the network into an empty
directory. **L2 does not**, and the reason is a reading rather than a
preference: the path L2 was to reuse is not uv-free. D88 carries it, nothing was
improvised in its place, and `install.sh` is byte-identical to 0.1.9.

This build writes no methodology and touches no spine document. It adds
`bootstrap.sh` and one suite, wires that suite into the runner, and rewrites the
install sections of the two repo docs.

### S1 — `bootstrap.sh` — Level 1

```sh
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/eugeniusee/ba-native-spec-for-sdd/main/bootstrap.sh | bash
```

A public raw URL and a public tarball: no auth anywhere on the path. The script
fetches `archive/refs/heads/main.tar.gz` into a `mktemp -d` workdir under a
cleanup trap, unpacks it, and hands over to the package's own `install.sh
--target "$PWD"`. `BNS_SOURCE=<checkout>` substitutes a local checkout for the
download — the test hook, and the identical code path from the handover on.

**It installs nothing of its own.** Every file the target ends up with is
`install.sh`'s work. The installer's output is not captured, not filtered and not
summarized, and its exit code is the one bootstrap leaves with. Remaining
arguments pass through untouched — `… | bash -s -- --offline`.

**The git guard is satisfied, not relaxed.** `install.sh` still refuses a target
that is not a repository; bootstrap owns the `git init` and announces it before
doing it, so the installer's preflight reads exactly as it always did.

**The self-guard.** The package repo *builds* the payload and is not a place to
install it into. Detection is the triple **VERSION + `payload/` + `install.sh`**,
checked before the download and before any write; the refusal names both the
fact and the fix.

`--help` is answered by bootstrap rather than forwarded: the installer's usage is
one download and one `git init` away, and neither is a side effect anybody asked
for by typing `--help`.

### S2 — Level 2, read and held (D88)

The ruling was: *uv missing + `vendor/spec-kit-v0.12.5.zip` present → take the
existing `--offline` path.* The preflight was read first, as instructed, and
today's behavior confirmed: `command -v uvx` or die. The second half does not
hold. `--offline` selects where the Spec Kit **source** comes from; the run
itself is `uvx --from "$SPECKIT_FROM" specify init` on **both** paths —
`vendor/README.md` has said so since S1. The vendored archive is upstream's
source tree, its CLI declares nine third-party dependencies, not one is vendored
as a wheel, and not one is importable from a stock `python3`. Verified, not
assumed.

Taking the offline path on a uv-less machine would therefore replace an accurate
refusal *at preflight, before any write* with a later death carrying a wrong
reason — *"Re-run with --offline once vendor/… is in place"* — while already
offline. That is a regression, so the change was not made and the installer was
left untouched.

What a uv-less machine can do today is `--skip-speckit`: the whole BA payload
lands, with no Spec Kit under it. A partial install, and the suite names it as
one rather than letting it read as L2.

### S3 — `tests/check-install.sh` — 43 / 0

A new suite on the `check-exit.sh` precedent: it installs for real, into
throwaway directories of its own.

| Section | Holds down |
|---|---|
| 1 · (a) bootstrap → a fresh non-git directory | exit 0 · `.git` created, and announced before it was · `/ba-frame` laid down · `.specify/ba/manifest.md` present, carrying this package version · all 33 `/ba-*` skills — a bootstrap install is a full install · the installer's own voice surfaced verbatim · `--offline` forwarded · `--help` with no side effects |
| 2 · (c) the self-guard | non-zero exit and a naming refusal on a decoy carrying the triple · the refusal writes nothing · the real repo carries the triple the decoy imitates · bootstrap refuses inside this working tree too, which is byte-for-byte unchanged after |
| 3 · (b) the uv-free case | the vendor archive in place · `uvx` shadowed off PATH with `python3` surviving the shadowing · the refusal, its reason and its zero writes · **the cause pinned in the installer's own text** · `--skip-speckit` completing uv-free, and what that costs |

Section 3 pins **today's** behavior, and the pin that matters is on the cause:
the assertion reads `install.sh` itself for `uvx --from "$SPECKIT_FROM" specify
init`. The day L2 becomes reachable, that assertion goes red and names itself —
the pin cannot be outlived silently. Both the target behavior and the re-pin
instruction are recorded inline at the site, on the `check-spine.sh` precedent
from 0.1.9.

The self-guard is exercised against a decoy **first**, deliberately: a regressed
guard must not be able to install into this working tree mid-suite. The run
inside the real repo comes after it and passes `--dry-run`, which `install.sh`
honours by writing nothing at all — so even a regressed guard leaves the tree
clean, and the suite asserts that it did.

### S4 — the runner, and the two docs

`run-all.sh` is **fifteen checks**, not fourteen: the header, `--list`, `--help`,
the `--file-only` skip row, the roll-up table and the GREEN line all moved in
step. `check-install.sh` joins the install-based group and owns its own targets —
a bootstrap run must start from a directory that is not yet a repository, which
no runner-made repo can be. (`--help` also stopped cutting its own last line;
the range was one short.)

`README.md` and `docs/quickstart.md` now **lead with the one-liner** and keep the
clone + `install.sh` path as the documented manual variant, for a pinned copy or
an existing checkout. README's layout tree gained `bootstrap.sh` and
`check-install.sh`, and its test-section counts — already two behind — were
brought to fifteen and twelve. The external front-door guide
(install-and-first-run) is out of scope here and is rewritten separately.

### Verification evidence

**`tests/check-install.sh` — GREEN, 43 / 0.** Plus one manual run the suite
cannot own, because it needs the public network and a pushed `main`: the
one-liner's **download** branch, end to end into an empty directory —
tarball fetched anonymously, unpacked, `git init`, full install with Spec Kit,
`rc=0`.

**The full regression — `tests/run-all.sh`, all fifteen:**

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 122 / 0 |
| `check-techniques.sh` | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 149 / 0 |
| `check-register.sh` | 51 / 0 |
| `check-wbs.sh` | 62 / 0 |
| `check-status.sh` | 94 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 110 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |
| `check-install.sh` | 43 / 0 |

`ran: 15   red: 0   skipped: 0` · **✓ GREEN**. Every pre-existing count equals
the 0.1.9 baseline exactly — 1167 assertions, unchanged, plus 43 new ones. The
payload was not touched, and the numbers say so.

### Divergences

**D88 · the `--offline` path is not uv-free, so L2 is not reachable by reusing
it.** `--offline` swaps the Spec Kit *source* from `git+…@v0.12.5` to the
unpacked `vendor/spec-kit-v0.12.5.zip`; the invocation is `uvx --from
"$SPECKIT_FROM" specify init` either way. The archive is upstream's **source
tree**, not a runnable CLI: `specify-cli` declares `typer`, `click`, `rich`,
`platformdirs`, `readchar`, `pyyaml`, `packaging`, `pathspec`, `json5`, and eight
of the nine are absent from a stock `python3` (probed). No wheelhouse is
vendored. *Resolution taken:* **the change was not made.** `install.sh` is
unchanged; `tests/check-install.sh` §3 pins the current refusal and, more
importantly, its cause. *Candidates, neither chosen here:* **(i)** vendor the
CLI's wheels and run the pinned Spec Kit from a `python3 -m venv` +
`--no-index --find-links` install — a genuinely air-gapped, uv-free path, and
new machinery in `vendor/`; **(ii)** on uv-missing-but-networked machines, build
that venv with a plain `pip install <vendored source>` — uv-free but not
offline, and a second install mechanism to maintain. Both are the BA Lead's
call, not a build decision.

**D89 · bootstrap hands over as a child process, not `exec`.** The ruling asked
for a `mktemp -d` workdir under a cleanup trap *and* an `exec` of the installer.
The two exclude each other: `install.sh` is read **out of that workdir**, and
`exec` replaces the shell, so the `EXIT` trap never fires and every bootstrap run
would leave an unpacked package tree in `$TMPDIR`. *Resolution taken:* run the
installer as a child, then `exit` with its code. The caller's contract is the one
that was ruled — output verbatim, exit code the installer's — and the workdir is
actually cleaned up. Related, same site: the child is given `</dev/null`, because
the flagship invocation is `curl … | bash`, where the script itself is on stdin
and bash reads a piped script a line at a time; anything downstream that read
stdin would eat the rest of the script.

**D90 · the tarball carries no `vendor/` archive, so L1 and L2 cannot compose.**
`vendor/spec-kit-*.zip` is gitignored by design — it is upstream's release
artifact, not ours to commit — so it is absent from
`archive/refs/heads/main.tar.gz`. A bootstrap install therefore has no vendored
Spec Kit to fall back to: `bootstrap.sh --offline` over the download branch dies
with *"offline install needs …/vendor/spec-kit-v0.12.5.zip"* (reproduced). This
holds **independently of D88**: even a fixed L2 would not reach a one-liner user.
*Resolution taken:* documented, not worked around — README's install section says
it in place. *Candidates:* bootstrap fetches the pinned archive from upstream's
own release URL when `--offline` is asked for, or the offline story is declared
clone-only. Not chosen here.

### Open

**`VERSION` is untouched at `0.1.9`.** Version stamping is the BA Lead's act; a
bump is proposed in this workstream's report, not taken here.

**`--dry-run` through bootstrap still `git init`s.** The ruling makes the init
unconditional and it was left that way. The consequence is narrow but real: a
dry run in a non-repository directory writes the one thing bootstrap writes
before `install.sh` — which then honours `--dry-run` and writes nothing itself.
Making the init dry-run-aware is a one-line change and was not taken, because it
is behavior the ruling did not ask for.

**The download branch is verified by hand, not by the suite.** It needs the
public network and a `main` that already carries `bootstrap.sh` — a chicken-and-
egg the suite cannot hold. `BNS_SOURCE` covers everything from the handover on;
what remains uncovered is `curl` + `tar` + "find the unpacked directory", and
that is what the manual run above exercised.

---

## Install UX — the bootstrap ensures `uv` · D88 resolved, Option B · 12 August 2026 · GREEN

D88 held that the `--offline` path is not uv-free, so **L2 — an install that
survives a machine with no `uv`** — was not reachable by reusing it. The ruling
on that divergence is **Option B: neither of D88's two candidate machineries is
taken, and the gap is closed one layer up.** `install.sh` stays byte-identical to
0.1.9 for the second build running. `bootstrap.sh` gains one step: it installs
`uv` when the machine has none.

The reading that makes Option B honest is about where each layer stands. On the
bootstrap path the network is not an assumption about the machine — the package
tarball was downloaded over it seconds earlier. So "install `uv`" is a step
bootstrap can always take, while `install.sh`, which must also serve a clone on a
machine that is offline by design, cannot.

**What was explicitly not taken.** D88 named two candidates and this build takes
neither: **(i)** vendoring the Spec Kit CLI's wheels and running the pinned Spec
Kit from a `python3 -m venv` + `--no-index --find-links` install; **(ii)**
building that venv with a plain `pip install <vendored source>` on
networked-but-uv-less machines. Both add a second install mechanism inside the
package. Option B adds none — it makes `uv` present and lets the one install
mechanism that exists run exactly as it does today. `vendor/` is untouched, the
offline story is unchanged, and `install.sh` is not opened.

**D90 is mooted for the bootstrap path, and only there.** D90 recorded that the
tarball carries no `vendor/` archive, so L1 and L2 cannot compose — a one-liner
user had no vendored Spec Kit to fall back to. Under Option B that fallback is
not the route a uv-less one-liner user takes: they get `uv`, then the pinned Spec
Kit over the network they have already demonstrated. The *fact* D90 records is
unchanged and so is the behavior — `bootstrap.sh --offline` over the download
branch still dies with *"offline install needs …/vendor/spec-kit-v0.12.5.zip"*.
What is gone is the need for it.

### S1 — the ensure step in `bootstrap.sh`

Placed **after** the `git init` step and **before** the handover: the target is a
repository before anything else happens, and `install.sh` is reached only with
`uv` in hand.

- `command -v uv` → present: `already installed ✓`, and nothing else happens.
- Missing: a notice — *"uv not found — installing via astral.sh, one-time"* —
  then astral.sh's own installer, `curl -LsSf https://astral.sh/uv/install.sh | sh`.
- Then `export PATH="$HOME/.local/bin:$PATH"`, because the installer edits shell
  rc files and this process will never re-source them, and one re-check.
- Still missing → `die`, naming the installer that ran, its exit code, and the
  manual command. **No retry loop:** a second identical run is not new
  information.

**The step is unconditional.** `uv` is a documented prerequisite of the package;
reading the pass-through flags here to guess whether this particular run will
reach `uvx` would be a second, drifting copy of the installer's preflight.

`BNS_UV_INSTALLER` substitutes a script for the astral.sh installer, on the
`BNS_SOURCE` precedent and with the same contract: leave a working `uv` where
bootstrap will find it. It is what lets the suite exercise this without curling
astral.sh and without writing into the developer's real `~/.local/bin`.

Everything else in `bootstrap.sh` — source resolution, the self-guard, the git
init, the child-process handover — is unchanged. The file's own header lost the
line *"This script installs nothing of its own"*, which is no longer true: it
installs one thing, on one condition, and now says which and why.

### S2 — `tests/check-install.sh` — 43 → 64

A new **section 4**, driven on section 3's shadowed PATH:

| Case | Holds down |
|---|---|
| (d) the hook leaves a `uv` | the gap detected and announced · the hook ran · bootstrap found *that* `uv`, at that path — the `PATH` export reaches this process · the target is already a repository — the step sits after `git init` · the handover happened · the payload laid down: a uv-less machine now installs |
| (e) the hook leaves none | non-zero exit · the refusal names what failed, which installer it ran, and the manual command · no handover · `git init` and nothing else in the target |

Both runs pass `--skip-speckit`. What section 4 owns is bootstrap's own step —
including that it runs whatever the flags say — and (d)'s install then completes
on the uv-free route section 3 established, rather than on a stub `uv` that could
not have run Spec Kit anyway. The `uvx` half is the live run's, below.

Section 1 gains two assertions: the step runs on the bootstrap path, and it took
whichever branch this machine's `PATH` puts it on — the suite states which one it
exercised instead of assuming a developer machine.

**Section 3 is unchanged, and still accurate.** D88 was resolved above
`install.sh`, not inside it: the installer still refuses without `uv`, at
preflight, before any write, and the pin on the *cause* — `uvx --from
"$SPECKIT_FROM" specify init` on both paths — still goes red the day that
changes. Only the section's framing moved, from "today's behavior, not the
workstream's target" to what it now is: the installer's behavior, which the
resolution did not touch.

### S3 — the two repo docs

`README.md` and `docs/quickstart.md` move `uv` off the bootstrap path's
prerequisite list: there it is installed for you if missing. The manual clone +
`install.sh` path keeps it as a stated prerequisite and now says why in the same
breath — that path installs nothing on your behalf. README's Requirements section
separates the two paths rather than listing one set of four tools for both, and
its `vendor/` note stops reading as *"uv is required on both paths, full stop"*
when the bootstrap now supplies it. The external front-door guide stays out of
scope.

### Verification evidence

**The full regression — `tests/run-all.sh`, all fifteen, before and after.** The
"before" is not the recorded baseline read back: 270d213 was cloned to a scratch
directory, its `vendor/` archive populated, and the suite run there this session.

| Check | Before (270d213) | After |
|---|---|---|
| `check-m.sh` | 40 / 0 | 40 / 0 |
| `check-gate.sh` | 59 / 0 | 59 / 0 |
| `check-orchestrator.sh` | 122 / 0 | 122 / 0 |
| `check-techniques.sh` | 101 / 0 | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 | 158 / 0 |
| `check-spine.sh` | 149 / 0 | 149 / 0 |
| `check-register.sh` | 51 / 0 | 51 / 0 |
| `check-wbs.sh` | 62 / 0 | 62 / 0 |
| `check-status.sh` | 94 / 0 | 94 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations | unchanged |
| `check-cards.py` | every card byte-identical to its re-derivation | unchanged |
| `check-layout.sh` | 110 / 0 / 0 | 110 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 | 99 / 0 |
| `check-install.sh` | 43 / 0 | **64 / 0** |

`ran: 15   red: 0   skipped: 0` on both · **✓ GREEN** on both. Diffed, the two
roll-ups differ in exactly one row. **1210 → 1231 assertions**, all 21 of them
new and all in the install-UX suite; the payload was not touched and the numbers
say so.

**The astral.sh branch, by hand.** No assertion may curl astral.sh, so the real
branch was run once before this commit: `uv` shadowed off `PATH`, `HOME` pointed
at a scratch directory so the developer's own `uv` could not be the one found —
the machine is genuinely uv-less from bootstrap's side. `curl -LsSf
https://astral.sh/uv/install.sh | sh` ran, `uv` landed in the scratch `HOME`,
bootstrap found it and handed over, and `install.sh` ran the pinned Spec Kit
through the `uv` that had not existed a minute earlier. **rc 0.**

### Divergences

**None.** The workstream spec was implementable as written — placement, the
notice, the `PATH` export, the single re-check, the no-retry refusal, the
unconditional step, and the `BNS_UV_INSTALLER` hook all landed as specified, and
the D-sequence therefore does not continue past D90.

### Open

**`VERSION` is untouched at `0.1.9`.** Version stamping is the BA Lead's act; a
bump is proposed in this workstream's report, not taken here. The manifest that
carries the version is generated at install time, so a bump costs one file.

**The live one-liner is verified after the push, not before it.** Same
chicken-and-egg the previous entry named: the documented command reads
`bootstrap.sh` from raw `main` and the tarball from `main`'s archive, so a
`main` that already carries this commit is the precondition for testing it. The
run is reported in the workstream report; the astral.sh branch it exercises is
the one verified by hand above, from a local source.

**`--dry-run` through bootstrap now also installs `uv`.** The ensure step is
unconditional and `--dry-run` is a pass-through flag, so a dry run on a uv-less
machine installs `uv` before `install.sh` declines to write anything. This is the
same shape as the `git init` note in the previous entry — bootstrap's own two
steps are not dry-run-aware — and it is behavior the ruling did not ask to be
made conditional.

---

## Manual-mode UX — the checkpoint law · plan-as-route · batch specs · package 0.1.10 · 13 August 2026 · GREEN

A manual-mode field read of the Presale path (12 Aug) found the framework
stopping in the wrong places. Not too often in the aggregate — in the wrong
*class* of place. It stopped at **step boundaries**: after a technique ran, to be
told to run the next one the BA had already put on the plan. And when a stated
destination was out of reach, it answered with a **list of commands to type**,
which is the framework asking the BA to do the framework's job. Both are stops
that buy no decision, and both are budget the BA spends on nothing.

WS-2 ruled the interaction model (D-O30–D-O34, orchestrator §18, v0.13). This
build compiles it. Nothing about ownership moved: the BA decides everything the
BA decided before. What changed is the **size of the act** that carries a
decision, and where the framework is permitted to stop.

**Re-parameterized before the first edit.** The session was briefed against
`3f7858d` at VERSION 0.1.7 → 0.1.8, orchestrator v0.11 → v0.12, decisions
D-O26–D-O30. HEAD was five commits ahead: 0.1.8 and 0.1.9 had shipped with other
payloads, v0.12 was dashboard v2, and **D-O26–D-O29 were already allocated**
(§10.4's own heading names them). The brief's own escape clause — *"keep them
unless the log shows collisions"* — fired. Ruled by the BA Lead, 13 Aug: a clean
+4 shift, D-O30–D-O34, VERSION 0.1.10, orchestrator v0.13, and a standing law for
the rest of the build — **locate every anchor by content in the live text, never
the brief-era snapshot; where the live form differs, edit the live form and log
it**. Five of the nine divergences below are that law firing.

### S1 — the checkpoint law (D-O30)

§10.1 gains the rule its table always implied but never said: **a stop is
legitimate only where the BA decides between materially different outcomes or
accepts debt.** Plan composition, clearing, waiver, override, reopen ruling,
defer batch, overflow ruling, profile switch, band transition — that is the list,
and it is a list of *decision moments, not step boundaries*. Anything else is the
banned class: where no decision exists, the framework proceeds and reports.

§10.3 rule 7 carries the render half — *"An acknowledgement-only stop is a banned
render: if no BA decision exists, do not stop"* — so the law reaches the surface
where renders are actually composed, and compiles into the four personas and the
two mirrors with the rest of the register.

### S2 — plan-as-route and the route render (D-O31)

New §7.5. **The composed plan is a route.** One BA act — `go` on the rendered
route, or `/ba-run` with no argument — runs its rows in order, each under its own
compiled P-O3 (technique invocation) check and its own run-end bookkeeping. It
stops only at a §10.1 decision point, or on a contract miss, which stops it with
the single unblocking act named.

**The invariant is not weakened, and the entry says why.** No state change
without a BA act — the `go` *is* that act, and its extent is named in the render
before it is taken. D-O13 is restated unchanged: silence is never consent, a
route runs only on a stated `go`. That sentence is asserted in three places by
`check-budget.sh`, because it is the sentence a future edit would quietly drop.

New §10.6 pins the render, and it joins §10.3 rule 8's list of pinned formats.
The shape is compiled into `ba-run`, `ba-orchestrator` and the CLAUDE.md block —
every file that renders a route renders the same one.

### S3 — auto-repair (D-O32)

§10.2. An unreachable destination is answered as **one act**: the mismatch in one
line, the repair route in the §10.6 shape, then `go?`. Handing the BA a list of
commands to type is a banned render — and it is also how a budget gets blown,
since every command in that list is an interaction the framework asked the BA to
spend. After the `go`, the framework executes its own mechanics.

### S4 — Presale defaults and the ≤ 8 budget (D-O33)

§6.5 gains four things. The **Band-2 pair reruns** (T-17 — epics decomposition,
T-18 — scope allocation) are on the default route, so the roadmap is never
quietly MVP-only and the BA does not discover it post-hoc. Canvas confirmation
under Presale is **one artifact-level batch** — one confirm per artifact, never
per section (a profile default under D-O14; the catalogue sheet is untouched).
Plan-as-route is the profile's default interaction mode, with Discovery keeping
its density **by BA choice, not inheritance**.

And the number: **Presale end-to-end — Frame to a rendered WBS — fits in ≤ 8 BA
interactions.** Exceeding it is a defect, not a style preference. A budget nobody
counts is a wish, so `tests/presale-path.md` is the script and `check-budget.sh`
counts it — headings numbered 1…N, asserted contiguous, asserted ≤ 8. The eighth
interaction is held deliberately unspent as slack.

### S5 — batch Band-3 entry (D-O34)

§8.4 and `/ba-run specs all | specs <epic-list>`. One P-O8 — Band-3 entry table
over every selected feature; the BA strikes rows by number and confirms the rest
in one act. Per-row mechanics are unchanged — status flip, band event, the §8.4
advisory where one fires. Tier 2 then drafts every entered feature in assumption
posture and stops **once**, at the consolidated defer-confirm, rather than once
per feature.

### S6 — the harness

`tests/check-budget.sh`, row 16, 37 checks: the budget counted off the script ·
the §10.6 shape held down in all four files that carry it · the checkpoint law
and rule 7 in the document and in all six register carriers · **the
acknowledgement-only sweep** across the whole skill/persona/mirror surface, with
a seeded `confirm to continue` proving the sweep is not blind. The banned list is
printed on every run (`--list` prints it alone) — ten phrasings, seeded from the
ruling's three and extended by judgment, so a future reader sees the list rather
than only its verdict.

`check-register.sh` gains section 7: the register self-check compiled
byte-identical into all 39 units, its clauses each grounded in the §10.3 rule
they compile, with a stripped unit and a paraphrased one as controls.
`check-orchestrator.sh` gains the section inventory — a section referenced but
absent is the failure mode — plus the persona's compiled law. `check-spine.sh`
gains the two new `/ba-run` forms at the dispatch interface.

### Test run — 16 of 16

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 135 / 0 |
| `check-techniques.sh` | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 155 / 0 |
| `check-register.sh` | 59 / 0 |
| `check-wbs.sh` | 62 / 0 |
| `check-status.sh` | 94 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 110 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |
| `check-install.sh` | 64 / 0 |
| `check-budget.sh` | 37 / 0 |

`ran: 16   red: 0   skipped: 0` · **✓ GREEN**, the three install-based runs
included. Counts equal the 0.1.9 baseline except `check-orchestrator.sh`
(122 → 135), `check-spine.sh` (149 → 155), `check-register.sh` (51 → 59), and
the new `check-budget.sh`. **The runner is now sixteen checks, not fifteen** —
its header, `--list` output, roll-up and the README's four count strings updated
in step.

### Divergences

**D91 · `docs/quickstart.md` has no Presale walkthrough to rewrite.** E14 reads
*"Presale walkthrough rewritten to the ≤ 8 path"*. The live quickstart is
band-structured — Band 1 / Band 2 / Band 3 — and the word *presale* appears twice,
both times incidentally. *Resolution taken:* **authored** a new section,
`## Presale — the whole path in eight interactions`, between Band 3 and the
command index, carrying the eight-step path and one §10.6 route render. The three
band walkthroughs are untouched: Discovery is still the density the quickstart
teaches first, which is the §6.5 ruling's own position.

**D92 · the batch path was specified against a two-record world; D86 made it
three.** E6 and E9 enumerate what each confirmed row keeps — *"its status flip,
its band event"* — the pair that was true at `3f7858d`. Commit `b8e66fa` (D86)
gave every Tier-2 run its own `## Band 3` run-log line, so a batch that drafts
eight features owes eight run-log lines. Written as briefed, the batch driver
would have silently dropped the bookkeeping §7.3 mandates. *Resolution taken:*
both texts extended to name the run-log line — §8.4 as *"each run owing its own
`## Band 3` run-log line (§7.3, build-log D86)"*, `ba-run` as *"each run writing
its own `## Band 3` run-log line"*. This is a faithful reading of *"keeps its own
mechanics unchanged"*, not a new ruling; `check-spine.sh` pins both.

**D93 · register rule 8's pinned-formats list drifted at v0.9 and was never
propagated.** The document's list gained `WBS export §10.5` when the export was
ruled; the six files the register compiles into — two mirrors, four personas —
still carried the pre-v0.9 list, with a compile artifact (`P-O prompts)` flush
left at column 0) marking where the insertion had been made and not re-wrapped.
Appending §10.6 to a list already missing §10.5 would have shipped the drift one
version further. *Resolution taken:* all six synced to the document's live list —
both entries added in one pass, the indentation repaired.

**D94 · the CLAUDE.md block's command index was one command and two counts
behind.** `/ba-wbs` (shipped 0.1.6) was absent from the workflow table, so the
block advertised *"All 32"* against a payload of 33 skills and *"Workflow — 12"*
against a set of 13. *Resolution taken:* the row added, both counts corrected to
33 and 15 (the two new `/ba-run` forms included). Left alone: the build plan's
D-P2-2 also reads *"All 32 commands"*, and that is a decision record of what was
ruled at the time, not a live render — it is not this build's to rewrite.

**D95 · row 16 is file-only, and it runs after the install-based rows.** The
ruling fixes `check-budget.sh` at row 16, and rows 13–15 are the install-based
runs — so the new check is a file-only check sitting below them. *Resolution
taken:* it runs outside the `--file-only` branch, in a group of its own labelled
for what it is: a **whole-surface** check that sweeps every skill, persona and
mirror, run last so it reads the surface as the rest of the suite leaves it. Row
16 as ruled, and `--file-only` runs thirteen checks, not twelve.

**Two more, resolved as ruled and recorded for completeness.** §10.3 rule 8's
list was extended in its **live v0.12 form** — the one carrying the dashboard's
own extension — never the brief-era snapshot (ruling point 3). And WS-2's review
record became **§18**: §16 is the WBS ruling set, §17 dashboard v2.

### Open

**The budget is asserted against a script, not against a live agent.**
`check-budget.sh` proves the package *can* hold ≤ 8 — the pinned shapes are
compiled, no acknowledgement-only stop is authored into any skill, and the
scripted path stays inside eight. Whether a live agent holds it on a real estate
is what the agent-run half of `presale-path.md` is for, and that run is a field
act, not a harness act. The two-ways-to-run split is `exit-test.md`'s precedent
and its limitation, inherited knowingly.

**The banned list is judgment, and says so.** Ten phrasings catch the shapes an
acknowledgement-only stop takes in English. A model can invent an eleventh. The
list is printed on every run precisely so its edges stay visible; extending it is
a one-line edit at the top of the suite.

**`/ba-run` now carries four behaviors** — route runner, batch spec driver, thin
alias, custom runner — selected by argument shape. That is a lot for one command,
and it is the shape the ruling names (§11's two new binding rows). If the field
finds the overload confusing, splitting the batch driver into its own command is
a one-line re-ruling and a file move; nothing in §7.5 or §8.4 depends on the two
living together.

## Autonomous mode — the autonomy grant · the §10.7 policy table · the safety floor · package 0.1.11 · 13 August 2026 · GREEN

WS-2 closed the question of **where** the framework may stop. WS-3 answers the
one a BA asks immediately afterwards: **may it keep going while I am not at the
keyboard?**

The corpus's answer had been implicitly no, and for two good reasons that had
to be amended rather than ignored. D-O13 reads consent as an act taken in the
moment — *silence is never consent*. §1 principle 2 reads any unprompted
transition as a self-clear — *an aspect gate never self-clears*. Both are load
bearing, and a build that quietly loosened either would have traded the
framework's whole guarantee for convenience. So WS-3 amends both **by new
ruling, on the record**, and buys the amendment with an instrument and a floor:
a grant that is written down, revocable, and ratified afterwards; and three acts
the grant can never reach.

**Nothing about ownership moved.** The BA decides everything the BA decided
before. What an autonomy grant moves is the **moment** the BA states a decision.
It never moves the **content** of one — which is why the ambiguity law survives
verbatim (unclear is still an Open Question, never an invention) and the
non-waivable set is untouchable in every mode.

**Parameters, allocated from the live tree.** HEAD was exactly the orientation
commit `b1767a9`, so the WS-2 §4 footprint scan found nothing to reconcile — but
the parameter rule fired anyway, because the brief pinned no numbers: VERSION
0.1.10 → **0.1.11** · orchestrator v0.13 → **v0.14** · gate v0.5 → **v0.6** ·
the D-O high-water mark 34 → the contiguous block **D-O35–D-O41** · review
record **§19** · test row **17** · divergences from **D96**.

### S1 — the autonomy grant (D-O35)

New §4.4. `AG-<n> · scope · granted-by · date · revoke` — written by
`/ba-auto on`, closed at `off` by the ratification act, homed in the aspect-state
ledger as the `Auto:` head line plus Events entries at on, off and ratification.

**It is the fourth instrument, and it joins none of the three tables.** §4.3's
AW / W / HA table is about waivers: instruments that move *what is required*. An
AG waives nothing and rules nothing — it moves *when the BA states it*. The
distinctness clause is in the instrument's own record, and it ends by naming the
floor: an AG never grants ⚑ sign-offs, effective PASS, or handoff.

### S2 — `/ba.auto on|off` and the policy table (D-O36 · D-O39)

New §10.7. Entry does three things — writes the grant, flips the head line, logs
the event — and the profile is taken from the argument or **inferred and
logged** (`canvas.md` present → Presale). It **never switches mid-auto**: a
grant that could re-aim the flow it is running is a blank cheque, not a grant.

Then one policy row per surviving §10.1 stop. Plan composition goes
as-recommended and the grant **is** the route `go`. Defer batches are accepted.
Clearing clears when every criterion is met and otherwise takes an **auto-AW** —
a full waiver record, misses named, revisit trigger `BA ratification sweep (auto
off)`, so debt under auto is never silent. Reopens default to Real with the
blast radius **stated** and **no cascade executed**. P-O9 — overflow ruling takes
**the supplement lane and only that lane** (D-O39): not cap adjust, because a run
must not enlarge its own budget; not defer, because that is debt the BA takes
knowingly. At the gate: waivers AUTO on real gaps, **overrides never**, and on
the non-waivable set the auto path **fixes and re-gates** — it never bypasses.

`off` renders the **resumption report**, a pinned shape joining §10.3 rule 8's
list. An interrupted run leaves its artifact a draft. Ratification is one batch
act; exceptions reopen manually, each by its own ordinary checkpoint.

### S3 — the safety floor, kept (D-O37)

Three acts sit outside every grant, in every profile: the two ⚑ sign-offs
(CC-XA-01 authorization, CC-XA-06 the scope boundary), the effective PASS, and
`/ba-handoff`. They are the acts where a false pass is a security incident, a
scope escape, or code built on unread text.

The consequence is stated as a terminus rather than a prohibition: per feature,
auto ends at **"done, awaiting ratification."** The draft is complete, the gate
has run, and the last two acts wait for a human. Gate v0.6 carries the same floor
in its own §7.1, beside the AUTO waiver lane it opens.

### S4 — the mode in the ledger head (D-O38)

`Auto:` joins the §2.4 head after `Profile:`, and the Events grammar gains the
on / off / ratification lines. `/ba.status` gains an **append-only** auto-trail
section — mode, grant record, trail count, unratified count — that renders only
once a grant exists. The nine numbered dashboard lines are untouched, and the
section is four ledger reads under §10.4's read discipline: rendering the trail
is not ratifying it.

The mode has to be *read*, not just recorded, so E11's one-line **mode read**
compiles byte-identical into the whole standing-instructions carrier set —
40 skills, personas and mirrors: *before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.*

### S5 — the two locked amendments (D-O40 · D-O41)

Ruled by the BA Lead in the same sitting, because autonomous mode is incoherent
without them, and each amends a standing ruling **by new ruling** in the D-O27
manner:

**D-O40 → D-O13.** A standing AG is *explicit consent recorded in advance — not
silence.* D-O13's own case is untouched: absent a grant, a rendered suggestion is
still never a plan, and silence still consents to nothing. Both sentences are
asserted, in both places, precisely because a future edit would drop the second
while keeping the first.

**D-O41 → §1 principle 2.** A transition under a **recorded, revocable** grant is
*not a self-clear* — the initiative is the BA's, stated in the grant, and every
AUTO transition stands for ratification at `off`. The three qualifiers are the
whole amendment; a transition missing any one of them is a self-clear again.

### S6 — the harness

`tests/check-auto.sh`, row 17, 88 checks, in seven sections: the AG record and
the `Auto:` head line held down in the §2.4 exhibit and the shipped template ·
the §10.7 policy table across all four surfaces that carry it, each miss named ·
**the safety-floor sweep** · the resumption report extracted from §10.7 and
byte-compared against the three files that render it · the mode read
byte-identical across the 40 carriers · the ratification grammar · the two
amendments, with D-O13's own case asserted beside its amendment.

**The floor sweep is the section that matters.** It joins the render surface
into the paragraphs a reader sees, cuts them into sentences, and flags any
sentence carrying both an `AUTO` token and a floor act without a prohibition —
because the only legitimate reason to say "AUTO" and "handoff" in one breath is
to say that the one never touches the other. Three seeded breaches prove it
fires, one per floor act; two negated forms prove it can read a prohibition
rather than just pattern-match near one. The floor list, the AUTO tokens and the
negation list all print on every run (`--list` prints them alone), so the sweep's
edges stay visible the way `check-budget.sh`'s banned list does.

`check-orchestrator.sh` gains the two new sections and §19 in its inventory, the
amended rule-8 list, the v0.14 header assertion, and a **contiguity check on the
whole D-O block** — 1…41, no gap, no reuse. `check-register.sh` gains section 8:
the three standing blocks in one **order** across every carrier. `check-spine.sh`
gains the supplement lane at Tier 2, with both refusals named.

### Test run — 17 of 17

| Check | Result |
|---|---|
| `check-m.sh` | 40 / 0 |
| `check-gate.sh` | 59 / 0 |
| `check-orchestrator.sh` | 148 / 0 |
| `check-techniques.sh` | 101 / 0 |
| `check-techniques2.sh` | 122 / 0 |
| `check-techniques3.sh` | 158 / 0 |
| `check-spine.sh` | 159 / 0 |
| `check-register.sh` | 62 / 0 |
| `check-wbs.sh` | 62 / 0 |
| `check-status.sh` | 94 / 0 |
| `check-ledger.py` | grammar-legal — 14 rules, no violations |
| `check-cards.py` | every card byte-identical to its re-derivation; layering clean |
| `check-layout.sh` | 111 / 0 / 0 |
| `check-exit.sh --offline` | 99 / 0 |
| `check-install.sh` | 64 / 0 |
| `check-budget.sh` | 37 / 0 |
| `check-auto.sh` | 88 / 0 |

`ran: 17   red: 0   skipped: 0` · **✓ GREEN**, the three install-based runs
included. Counts equal the 0.1.10 baseline except `check-orchestrator.sh`
(135 → 148), `check-spine.sh` (155 → 159), `check-register.sh` (59 → 62),
`check-layout.sh` (110 → 111 — the new skill's row), and the new
`check-auto.sh`. **The runner is now seventeen checks, not sixteen** — its
header, `--list` output, roll-up and the README's four count strings updated in
step.

### Divergences

**D96 · The ruling block is seven numbers, not five.** The brief names R3, R4
and R5 explicitly and refers to "locked amendments D-O13 + self-clear" without
numbering them. *Resolution taken:* WS-2's shape, extended — R1–R5 →
**D-O35–D-O39** (the AG instrument · `/ba.auto` and the policy table · the safety
floor · the ledger head and the dashboard · P-O9's supplement lane) — and the two
locked amendments take **D-O40** and **D-O41** of their own. An amendment by new
ruling *is* a ruling: D-O27 already amended D-O17 that way and took its own
number. The block stays contiguous from the live high-water mark, which is what
the parameter rule requires, and `check-orchestrator.sh` now asserts that
contiguity rather than trusting it.

**D97 · The self-clear sweep cross-referenced five sites of twenty-one.** E3
says to sweep every *"never self-clears"* echo and add the pointer *"where it
reads naturally"*. The live tree carries twenty-one across docs and payload.
*Cross-referenced:* orchestrator §1 principle 2 (the amendment itself) · §3.4's
confirmation act · the orchestrator persona's rule 2 · `ba-clear/SKILL.md` ·
the `aspect-state.md` template. *Left alone, deliberately:* the fourteen
`ba-t<NN>` skills' line *"Proposing is not confirming; an aspect gate never
self-clears"* — that sentence governs the **run-end proposal**, which is exactly
as true under a grant as without one (the confirmation moves to `/ba-clear`,
where the AUTO stamp lands), so a pointer there would aim away from the act the
line governs; and `payload/specify-overlay/ba/cards/at-thresholds.md`, a compiled
card fixed at *AT-ID + exact text — nothing else* (build plan §2.5) and
regenerated by `check-cards.py --record` — a methodology cross-reference cannot
travel into it without breaking the compile rule. The contract's own *"the gate
never self-certifies"* is a contract line, not this document's to edit, and the
floor keeps the gate's approval outside every grant regardless.

**D98 · The gate skill took the whole §7.1 paragraph, not only the floor line.**
E12 assigns *"one floor line"* to `ba-handoff` and the gate-executing surfaces;
`ba-handoff` and `ba-gate.md` took exactly that. *Resolution taken:*
`ba-gate/SKILL.md` took the floor line **plus the AUTO waiver lane**, because P2
is where that lane is operative and this skill is the surface that runs P2. A
floor line alone would have told the gate what it may not do under a grant
without telling it what it may — and the compiled surface would then refuse a
waiver the ruling grants. This compiles E9 in full rather than in half.

**D99 · Row 17 joins row 16 in a whole-surface group of two.** WS-2's D95 fixed
`check-budget.sh` at row 16 — file-only, but run after the install-based rows
because it reads the render surface entire. `check-auto.sh` has the same shape:
its floor sweep covers every skill, persona, mirror, template and card.
*Resolution taken:* row 17 beside it rather than renumbering 13–16. The
whole-surface group is now two, not one, and `--file-only` runs **fourteen**
checks, not thirteen.

**D100 · The mode read is asserted once — in `check-auto.sh`; `check-register.sh`
got the order instead.** E11 places the mode-read line in "check-register's
carrier set" while E14 gives `check-auto.sh` the assertion "mode-read line across
the carrier set". Asserting the same bytes in both suites would be the same
assertion twice. *Resolution taken:* `check-auto.sh` §5 owns the byte-identity
sweep and its two controls; `check-register.sh` gained section 8 — the **order**
of the three standing blocks (mode read → self-check → boundary), which no suite
asserted before and which is squarely check-register's territory. Exactly-once
holds, and the new section is a new fact rather than a second opinion.

**D101 · Three payload edits beyond the brief's compile list, each forced by an
E-item's own text.** (a) `ba-tier2/SKILL.md` gains the supplement-lane paragraph:
D-O39 rules a **Tier-2** act, and the skill that raises the overflow signal is the
only surface that executes it — `check-spine.sh` asserts it there. (b) The
`aspect-state.md` template gains the `Auto:` head line, the AG record, the AUTO
stamp and the three events: E5 rules the §2.4 head grammar, and the template *is*
§2.4's shipped form — its own header says so. (c) `ba-clear/SKILL.md` gains the
auto-AW branch: E4's P-O4 row has two outcomes, and `/ba-clear` is the skill that
takes both.

**D102 · The skill count moved 33 → 34, and five pinned strings with it.**
`/ba-auto` is the thirty-fourth `/ba-*` skill. *Resolution taken:*
`layout.expected`'s workflow header (13 → 14) plus its new row ·
`check-layout.sh`'s registry bar, four sites · `check-install.sh`'s bootstrap
assertion · the CLAUDE.md block's *"All 33"* and *"Workflow — 15"* · README's
*"in all 33 skills and 4 personas"*. *Left alone:* the build plan's D-P2-2, which
reads *"All 32 commands"* — a decision record of what was ruled at the time, not
a live render (WS-2's D94 precedent, applied again).

### Open

**The floor sweep is a text sweep, and text is not behavior.** It proves no
compiled sentence in the payload authorizes an AUTO-stamped ⚑ sign-off,
effective PASS or handoff. It cannot prove a live agent under a standing grant
will not do it anyway — the floor's real enforcement is that the three acts are
the BA's own, and a stamp the framework never wrote is a stamp the BA never
signed. The same limitation `check-budget.sh` records for the interaction budget,
inherited knowingly, and for the same reason: the agent-run half is a field act.

**The negation list is judgment, like the banned list before it.** Ten
prohibition shapes catch how English says *never*. A model can phrase an
eleventh. The list prints on every run so its edges stay visible; extending it is
a one-line edit at the top of the suite.

**The `Auto:` line is not retrofitted into the §12 fixture ledger.** The
appointment-booking ledger records acts from July 2026 — before the profile field
and long before autonomous mode. It carries neither line, and `check-ledger.py`
accepts it, for the same reason it accepts the missing `Profile:` line: the head
rule requires the four standing lines, not the optional ones. A fixture that
claimed a mode nobody could have entered would be a worse record than one that
does not mention it.

**The auto-trail count has no writer yet in `sk_status.py`.** §10.4's section and
the skill's compiled instructions define what renders; the vendored dashboard
script renders the nine numbered lines. The trail section is agent-rendered off
the ledger, which is where its four facts live — and it renders only when a grant
exists, so a project that has never run autonomously sees no difference. Whether
the script should learn to count AUTO stamps is a build item behind the first
field grant, not a ruling.


---

## The Scope Frame — documents-first pass, Lane B · orchestrator v0.15 · 13 August 2026 · GREEN

Run-1 field feedback, 12 August 2026: the framework generated a twenty-epic
full-roadmap WBS against a client POC constraint of ≤ $50K that lived in Slack
and in client documents. **No home existed at Frame for budget or
engagement-scale constraints**, so the constraint arrived after the WBS and
forced a full re-run. The ruling is the **scope frame** — a second pinned Frame
block, a set of ledger-head fields, one new C1 trigger, one advisory, and an
optional directive input.

**Documents only, by the apply package's own scope.** The three source documents
are edited; the payload, the skills, the templates, the cards and the suites are
a follow-up conversation. Nothing was written that a ruling did not cover.

**Code registration note** (the D-O20–D-O25 precedent): the apply package's own
task code **F-01** collides with the 7 August 2026 diagnostic audit's finding
codes F-01…F-14 (`diagnostics/audit-stage-escape-and-planning.md`), so no F-code
appears in this block or in the documents. The ruling is named by its content —
*the scope frame* — and its decisions register as **D-O42–D-O44 · D-B6-7–D-B6-9 ·
D-B1-5**, each block contiguous from the live high-water mark read in the file.
No code is reused.

**Parameters, allocated from the live tree.** HEAD is `f8c4459`, the package's
own orientation commit, so nothing needed reconciling. The D-O high-water mark
41 → the contiguous block **D-O42–D-O44** · D-B6 6 → **D-B6-7–D-B6-9** · D-B1 4
→ **D-B1-5** · divergences from **D103**. Versions are proposed, not stamped, so
no VERSION, no edition number and no review-record section is written here.

**Proposed, then stamped in the same sitting.** The pass ran to its deliverable
with versions unstamped and two suite parameters deliberately red (D103, D104)
rather than quietly relaxed, and surfaced three conflicts as numbered questions.
The BA Lead ruled all three on the spot — **P-O0b is a safety-floor act**, never
AUTO under any grant · **one render, one reply** at Frame, so the ≤ 8 budget
stands · the client label's §10.5 slot **deferred** to the §10.5 rework bump —
and the stamp followed: orchestrator **v0.15** · catalogue-b6 **v0.3** ·
catalogue-b1 **v0.4** · index **v0.3**, regenerated. `VERSION` and the payload
are untouched; the package rebuild is still the follow-up conversation.

### S1 — the orchestrator (D-O42 · D-O43 · D-O44)

§2.4's head gains five lines beside `Profile:` — `Boundary:` · `Budget:` ·
`Client label:` · `Parameters:` · the derived `Capacity:` — plus the
`scope-frame` switch event and the paragraph that fixes their grammar. §8.1
gains the pinned **scope-frame block (P-O0b)**, the auto-pickup rule, the
ladder-values-only negative rule, and the two capacity operations — the
always-on conversion and the removable, default-on check. §10.1 gains the
**P-O0b** row; §10.3 rule 8's pinned-formats list and §11's Frame binding row
extend in step, the way every prior pinned shape has.

### S2 — T-18, catalogue-b6 (D-B6-7 · D-B6-8 · D-B6-9)

The C1 event set gains the **scope-frame event**. §4 step 3 gains the
**scope-frame advisory** in both forms — number-free always, plus the
assumption-grade capacity comparison where the check is on — and **directed
reallocation**, parsed into the three buckets (phase-shaped · not phase-shaped ·
impossible). The Depth cell states the boundary the advisory must not cross:
capacity figures live in this run's advisory prose and enter no artifact. The
log grammar gains the `scope-frame` and `BA-directed` trigger values.

### S3 — T-01, catalogue-b1 (D-B1-5)

One additive mirror clause, no restructuring: the framing run carries the scope
frame's detail into canvas §13 Context/Constraints as cited lines. The ledger
head holds the machine-readable summary; the canvas holds the cited detail. The
§5 template row and the §8 build hook name the landing site and the source.

### S4 — the three rulings, taken in the same sitting

**The frame is the floor's fourth act.** P-O0b joins the ⚑ sign-offs, the
effective PASS and `/ba-handoff` outside every autonomy grant — §10.7's floor
paragraph names four acts, §4.4's instrument sentence names four, and the policy
table gains a row that says *never AUTO* and why: the boundary and the envelope
are what every later act is measured against, and a grant that could set them
would be a run choosing its own budget. The floor is **extended by new ruling**,
in the D-O27 manner — nothing it already reserved was weakened.

**One render, one reply.** The picker and the frame block are the Frame act's
single stop. Frame costs one BA interaction, D-O33's ≤ 8 Presale budget and its
slack stand untouched, and `tests/presale-path.md` interaction 1 now carries the
frame explicitly — including why it is an interaction in every mode.

**The label's WBS slot is deferred, by ruling.** §8.1's mirror-candidate flag
becomes a named deferral: the Estimate-column removal, the client-label header,
and boundary/billable marking travel as one §10.5 rework bump. The flag pattern
is D-B6-1's; what changed is that it now names the bundle it rides.

### Test run — 17 of 17

`check-m` 40/0 · `check-gate` 59/0 · `check-orchestrator` 151/0 ·
`check-techniques` 101/0 · `check-techniques2` 122/0 · `check-techniques3`
158/0 · `check-spine` 159/0 · `check-register` 62/0 · `check-wbs` 62/0 ·
`check-status` 94/0 · `check-ledger` grammar-legal — 14 rules, no violations ·
`check-cards` every card byte-identical to its re-derivation · `check-layout`
111/0/0 · `check-exit --offline` 99/0 · `check-install` 64/0 · `check-budget`
37/0 — the Presale path still 8 ≤ 8 · `check-auto` 88/0. **Zero red, nothing
skipped**, the three install-based runs included. The two reds the pass opened
with closed at the stamp, not by relaxation: `check-orchestrator` asserts the
live edition and the contiguous block 1…44, `check-auto` asserts ordering and a
four-act floor.

### Divergences

**D103 · The D-O block runs 1…44 while the review record stops at D-O41.**
`check-orchestrator.sh` asserts contiguity against a hard-coded
`set(range(1, 42))` — the assertion WS-3's D96 added so contiguity would be
checked rather than trusted. The apply package rules *propose, do not stamp*,
so the body cites `D-O42`–`D-O44` and no §20 review record exists to hold them.
*Resolution taken:* held red through the deliverable, then closed at the stamp —
**§20 Review record (v0.14 → v0.15)** landed with the three rows, the header,
change record and footer took v0.15, and the bound moved `range(1, 42)` →
`range(1, 45)`. The assertion was never relaxed to buy a green board; it went
green because the thing it asserts became true.

**D104 · `check-auto.sh` asserts `Auto:` on the line immediately after
`Profile:`, and five scope-frame lines now sit between them.** The ruling the
assertion serves — D-O38 — says `Auto:` joins the §2.4 head **after**
`Profile:`, which the head still satisfies; the strictness is the test's, not
the ruling's. The placement is deliberate: `Profile:` (P-O0) and the scope-frame
fields (P-O0b) are both Frame-time picks and belong together, and *beside
Profile* is the ruling's own wording. *Resolution taken:* the document
stands and the check became an ordering check — `Auto:` after `Profile:`, not
adjacent to it — with the two rulings it now serves named in its own comment.

**D105 · §10.7's policy table gains no row for P-O0b.** D-O36 rules **one policy
row per surviving §10.1 stop**, and P-O0b is a new §10.1 stop. The table already
carries no row for P-O0, P-O1 or P-O3 — P-O0 is handled in §10.7's entry
paragraph instead (argument, else inferred and logged; never switches mid-auto)
— so the gap has a precedent but no ruling. *Resolution taken:* surfaced as open
question 1 rather than invented — an AUTO policy over a budget constraint is a
ruling, not an application. **Ruled the same sitting: P-O0b is BA-only, standing
AG or not, and the scope frame joins the safety-floor set as its fourth act.**
Applied at §10.7 (the floor paragraph and a policy row) and §4.4 (the
instrument's own naming of the floor); `check-auto.sh`'s two byte-identity
assertions on the floor text moved with it (see D110).

**D106 · The new Frame stop and the ≤ 8 interaction budget have not been
reconciled.** §6.5's D-O33 fixes the Presale path — Frame to a rendered WBS —
at ≤ 8 BA interactions, and `tests/presale-path.md` spends seven with the eighth
held as slack. A P-O0b that stops and waits on its own makes the live path nine
unless it rides the Frame act's existing interaction. `check-budget.sh` still
reads 8 ≤ 8 because it counts the script, and the script is a payload-lane file
the documents-only pass did not touch — **the suite measures the script, not the
live path**, and that limitation is load-bearing here. *Resolution taken:*
surfaced as open question 2. **Ruled the same sitting: P-O0b folds into the Frame
act's interaction 1 — one render carrying both blocks, one BA reply.** §8.1 gains
the operative sentence, `tests/presale-path.md` interaction 1 was rewritten to
carry the frame, and §6.5's ≤ 8 with its one interaction of slack is untouched.
The heading count is unchanged at eight, so the budget check reads the same
number for a different and now correct reason.

**D107 · The client label's second destination has no slot.** The ruling makes
the label communication for two surfaces: the canvas and the client-facing WBS.
The canvas half landed (D-B1-5). §10.5's pinned columns define no header or
label line, and the apply package holds §10.5 untouched. *Resolution taken:*
recorded in §8.1 as a mirror candidate rather than silently added to a pinned
render, and surfaced as open question 3. **Ruled the same sitting: deferred.**
The flag now names the bundle it rides — the §10.5 rework, where the
Estimate-column removal, this label header, and boundary/billable marking travel
as one bump. §10.5's pinned columns stay untouched in this edition.

**D108 · The catalogue index diverges from T-18's sheet on three cells.**
`ba-native-spec-catalogue-index.md` v0.2 carries T-18's Evidence triggers,
Depth boundary and Expected output as they read before this pass. Its own
header rules replace-on-update — *regenerated at any batch-file version bump* —
and the sheet governs on any divergence. *Resolution taken:* held as a note through
the deliverable, by the apply package's instruction, then **regenerated at the
stamp** — index **v0.3**, T-18's Evidence-triggers, Depth and Expected-output
cells re-derived from the sheet, 17 of 18 rows unchanged, both provenance lines
updated. T-01's row needed no change: the mirror clause is procedure-level and
touches no cell the index carries.

**D109 · The ruling is seven numbers, not three.** The apply package tables its
design as §2.1–§2.7 rather than as an R-list, so the granularity of the decision
block was the applier's to choose: one number per touched document, or one per
ruled sub-section. *Resolution taken:* **one per sub-section**, the WS-2/WS-3
shape (R1–R5 → five numbers each) — **D-O42** the pinned P-O0b block · **D-O43**
the ledger head and its switch event · **D-O44** the capacity arithmetic ·
**D-B6-7** the scope-frame trigger · **D-B6-8** the advisory · **D-B6-9**
directed reallocation · **D-B1-5** the canvas mirror. The deciding argument is
D-O44's own content: §2.3 rules the capacity check *separately removable*, and a
module that can be removed by one ruling needs a number of its own to remove.
Coarser numbering would have made its deletion an amendment to a ruling about
something else. Each block stays contiguous from the live high-water mark, which
is what the parameter rule requires.

**D110 · Four suite parameters moved, not two.** The stamp instruction named
two — `check-orchestrator`'s contiguity bound and `check-auto`'s adjacency test.
Two more were forced by rulings the same instruction gave, each by the assertion's
own text. (a) `check-auto.sh` carries **byte-identity assertions on the floor
text** in two places — §4.4's instrument sentence and §10.7's naming of the floor
acts. A ruling that makes the floor four acts moves both, or the suite asserts a
three-act floor the document no longer states. (b) `check-orchestrator.sh` pins
**the live edition** in the file's first two lines and the ruling block in its
change record; v0.15 moved both, and the same pass added the v0.14 stack line the
shape had always implied, an assertion for `D-O42–D-O44`, and `## 20. Review
record` to the section inventory. *Resolution taken:* all four applied, none
loosened — every one still asserts a fact, and the facts moved. The floor's
**sweep token list** was deliberately left alone: it hunts compiled payload
sentences, the payload carries no scope-frame text yet, and a token that can
match nothing is a check that proves nothing. It joins the list in the rebuild,
with the compiled surfaces it exists to sweep.

### Open

**The advisory's numbers are governed by prose, and prose is not a compiler.**
Two rules keep capacity figures out of the estate — the §8.1 numbers-only-in-
advisory-prose limit and T-18's Depth clause — and both are sentences a live
agent reads. The WBS side has a real guard (§10.5's Estimate cells re-emit empty
every run); the roadmap side has the D-B6-4 column ownership and nothing
narrower. A check that greps `roadmap.md` for digits in an Allocation-log reason
is the obvious candidate, and it is a build item, not a ruling.

**Auto-pickup reads sources the framework does not control.** It scans client
documents, Slack extracts and the canvas for budget and scope constraints and
pre-fills the block with citations. Cite-or-mark bounds the risk — every value
carries a citation or `open — no source material`, and the BA confirms or
corrects before anything is recorded — but a mis-parsed envelope that the BA
confirms without reading is a wrong constraint with a real citation behind it.
The confirmation stop is the whole of the guard, which is one more reason
question 2's answer matters.

**The capacity check claims zero tentacles, and the claim is testable.** The
module's removability is stated in §8.1 and rests on one consumer: the T-18
advisory text. A sweep that proves no other rule in the corpus or the payload
reads `Capacity:` would turn the claim into a checked fact. Nothing in this pass
proves it — the claim is a design commitment, held on the record until the
rebuild can test it.

---

## The Scope Frame — package rebuild pass · payload · templates · mirrors · suite · package 0.1.12 · 13 August 2026 · GREEN

The follow-up the documents pass named. `46d51b2` landed the scope frame in the
three source documents and left the payload, the templates, the mirrors and the
suites untouched by its own scope. This pass compiles them — **one way: the
documents govern, and nothing was written that a ruling does not state.**

**Grounding.** Orchestrator v0.15 §8.1 (the P-O0b pinned block · auto-pickup ·
ladder-values-only · the two capacity operations), §2.4 (the head fields and the
switch grammar), §10.1 (the P-O0b row), §10.3 rule 8, §10.7 (the never-AUTO row
and the four-act floor), §4.4, §11 · catalogue-b6 v0.3 T-18 (D-B6-7…D-B6-9) ·
catalogue-b1 v0.4 T-01 §4.2 (D-B1-5) · build-log D103–D110 for what was left
here on purpose.

**Parameters, allocated from the live tree.** HEAD was `46d51b2`, the documents
pass's own commit, so nothing needed reconciling. VERSION 0.1.11 → **0.1.12** ·
divergences from **D111**. No decision number is allocated: this pass rules
nothing. Every sentence it compiled is a sentence D-O42–D-O44, D-B6-7–D-B6-9 or
D-B1-5 already states.

**Proposed, then stamped in the same sitting** — the documents pass's own
pattern. The pass ran to its deliverable with the version unstamped and two
questions open, and the BA Lead ruled both on the spot: **D113 is a carry item**,
its BUILD-LOG flag the recorded state and no document pass now · **D115's bullet
stands**, on a rationale the pass had not seen (below). `VERSION` took **0.1.12**
after the rulings, not before.

### S1 — `/ba-frame`: one render, one reply (D-O42 · D-O43 · D-O44)

Step 2 becomes **P-O0 + P-O0b**, a single stop. The two pinned blocks are
byte-identical to §8.1's, and they render together; the BA answers both in one
reply. Auto-pickup goes in front of the render — scan the sources on hand,
pre-fill with citations, cite-or-mark per value, `none stated` legal and
recorded. Then the frame's own rules: the boundary takes **ladder values only**
and PoC/prototype live in Client label, which the machinery reads for nothing;
capacity is **two operations** — the always-on conversion that lands the head's
derived line, and the separately removable, default-on check whose numbers never
leave advisory prose. The six head lines are written from §2.4's exhibit
verbatim, the switch grammar carries both `profile` and `scope-frame`, and the
band event records the frame beside the profile.

The never-list gains three clauses: never set or confirm the frame for the BA ·
never take P-O0b under a grant · never write a capacity figure into an artifact.

### S2 — the ledger template and the head's other renders (D-O43)

`aspect-state.md` is born with the five lines beside `Profile:`, the
`scope-frame` switch event joins the Events grammar, and the template's comment
block carries the frame's law — ladder values, the label the machinery ignores,
`Capacity:` as arithmetic and never estimation, the check as a removable module
with one consumer. `/ba-status` renders the head as it now stands: the same six
lines, byte-for-byte. The §10.4 dashboard is **untouched** — its pinned nine
lines are a different shape and no ruling moved them.

### S3 — T-18: the trigger, the advisory, the directives (D-B6-7 · D-B6-8 · D-B6-9)

The C1 trigger table gains **scope-frame**. The frame joins the inputs
**read-only**, and the envelope enters **inside value vs. effort** — the four
factors stand, no fifth. §4 step 3 gains the **advisory in both forms**:
number-free always, the assumption-grade capacity comparison only where the
check is on, its record the run output and the plans-file run log and **never
the roadmap**. Then **directed reallocation**, the three buckets in a table —
phase-shaped moves echoed back and pinned as `BA-directed` rows, everything else
routed as a proposal or named as impossible, and the framework never contesting
a directive. The log grammar takes `scope-frame` and `BA-directed`, in the skill
and in its reference example; the depth rule names the capacity check as no
exception and the Must-NOT list gains the numbers clause.

### S4 — T-01: the canvas mirror (D-B1-5)

One additive clause at §4 step 2, and nothing restructured. Where a frame
stands, its detail carries into **canvas §13** as cited lines — envelope,
boundary, label — each with its source or an explicit `open — no source
material`. The head holds the machine-readable summary; the canvas holds the
cited detail. The canvas template's §13 row names the landing site, the inputs
name the source read-only, and the never-list refuses to set or edit the frame.

### S5 — the floor's fourth act, everywhere it is stated in full (D-O42)

Four surfaces state the safety floor in full, and all four now name four acts:
the `/ba-auto` skill (which also gains the **never-AUTO P-O0b policy row**), the
orchestrator persona, the CLAUDE.md block and `AGENTS.md`. The gate-side
surfaces are unchanged by design — `ba-gate` and `ba-handoff` name the floor
members inside their own scope, and the frame is not a gate act. Register rule
8's pinned-formats list gains **scope frame §8.1** in all five carriers, beside
the profile picker it already carried. The CLAUDE.md block's `/ba-frame` row
names both picks and the one render they share.

**The mirrors' T-18 half needed nothing, and that is a finding rather than a
skip.** The work list named the T-18 additions for the CLAUDE.md mirror, but the
mirror carries T-18 as one namespace row — ID, name, destination — and none of
D-B6-7…D-B6-9 moves any of the three: the technique is still `t18 · Scope
allocation (repeatable) · memory/roadmap.md — Phase + log`. The trigger, the
advisory and the directives are procedure, and the mirror carries no
technique's procedure. Compiling them there would have put substance in a
surface whose whole design is an index.

### S6 — the suite, and the token that could match nothing

`check-auto.sh`'s floor sweep goes from three acts to four: `scope frame` and
`P-O0b` join the token list, the seeded control fires four breaches instead of
three, and the negated-form control is unchanged. Five assertions are added, not
relaxed — the four full-floor surfaces must name the scope frame, and the
skill's policy table must carry the never-AUTO row. D110 deferred exactly this
and said why; the compiled text it needed now exists.

`docs/quickstart.md` and `tests/exit-test.md` follow the same act: Frame asks
once for the profile and the frame together, and the exit script says which of
its two run modes sees it.

### Test run — 17 of 17

`check-m` 40/0 · `check-gate` 59/0 · `check-orchestrator` 151/0 ·
`check-techniques` 101/0 · `check-techniques2` 122/0 · `check-techniques3`
158/0 · `check-spine` 159/0 · `check-register` 62/0 · `check-wbs` 62/0 ·
`check-status` 94/0 · `check-ledger` grammar-legal — 14 rules, no violations ·
`check-cards` every card byte-identical to its re-derivation · `check-layout`
111/0/0 · `check-exit --offline` 99/0 · `check-install` 64/0 · `check-budget`
37/0 — the Presale path still 8 ≤ 8 · `check-auto` **93/0**, up from 88 by the
five new assertions. **Zero red, nothing skipped**, the three install-based runs
included. The floor sweep runs at four acts across 76 files.

### Divergences

**D111 · The apply package names v0.1.7 as the current version; the tree reads
0.1.11.** Three package bumps landed between the package's authoring and this
pass — 0.1.8 (the WBS References defect), 0.1.9/0.1.10 (dashboard v2, manual-mode
UX) and 0.1.11 (autonomous mode). *Resolution taken:* the package's own §0 rule
governs — *live sources govern over any snapshot* — so the proposal is measured
from the tree: **0.1.11 → 0.1.12**, unstamped, the BA Lead's to take.

**D112 · The floor list is token-shaped, so "three to four" is four acts and
seven tokens.** The instruction counts acts; `FLOOR` counts strings, and it
already spent five on three acts (`⚑` · `sign-off` · `effective PASS` ·
`/ba-handoff` · `handoff`). *Resolution taken:* the fourth act took two tokens —
`scope frame`, the noun the ruling uses, and `P-O0b`, the code §10.1 gives it.
Both were checked against the clean surface before the control was moved: the
payload sweeps to zero with them in, so neither is matching prose it should not.
The list prints in full on every run and under `--list`, so the count stays
readable rather than asserted.

**D113 · Orchestrator §11's Frame-binding table still names a three-act floor.**
Its Autonomous-mode row reads "the safety floor (⚑ sign-offs · effective PASS ·
handoff) sits outside it", while §10.7's floor paragraph and §4.4's instrument
sentence both name four after D-O42. The documents are read-only in this pass.
*Resolution taken:* nothing was compiled from the stale row — the payload's floor
text comes from §10.7 and §4.4 — and the row was surfaced as **open question 1**.
**Ruled the same sitting: a carry item.** One clause at the next orchestrator
bump; **this entry is the recorded state** until then, and no document pass runs
for it now. The payload is already correct against §10.7 and §4.4, so the drift
costs nothing while it stands — it is a source-document tidy, not a defect with
a live consequence.

**D114 · The orchestrator persona's one-screen head sentence lists neither the
frame nor `Profile:`.** "The head stays one screen: the band line, the six-row
state table, standing aspect waivers, open reopens, upstream flags, deferred
consequences" has never named `Profile:` or `Auto:` either. *Resolution taken:*
left as found. Extending it for the frame alone would make an enumeration that
is already partial read as complete. Recorded for that surface's own next pass;
the head's authoritative shape is the template's and `/ba-status`'s, and both
carry all six lines.

**D115 · `/ba-aspect` gained a refusal the documents state as a precondition.**
§8.1's operative sentence is "With the substrate, the profile, and the scope
frame in place, Stakeholders — the root — is openable (T1)", and the skill
already refuses on a missing `Profile:` line — the same sentence's other half.
*Resolution taken:* compiled as the exact analogue — a missing `Boundary:` line
stops and names `/ba-frame`. Flagged because the two halves looked asymmetric in
force: the profile refusal has a mechanical reason (the suggestion snapshot
filters by profile and cannot render without one) and the frame refusal appeared
to have none — nothing at aspect opening reads the frame; T-18 does, one band
later. The pass argued the stop was unreachable on a ledger `/ba-frame` made, and
offered to delete the bullet.

**Ruled the same sitting: the bullet stands, and "unreachable" was the wrong
read.** It holds only for ledgers *this* `/ba-frame` made. **Every pre-v0.15
ledger has no `Boundary:` line**, and on those the refusal is exactly the
migration guard the frame needs: it forces the frame onto a legacy project
*before* aspect work resumes, rather than letting Band-1 runs continue against a
boundary and an envelope nobody ever set — the Run-1 failure mode that produced
the ruling in the first place. The second reason is alignment: §8.1's openability
sentence names three preconditions, and a payload that enforced two of them would
be compiling the sentence by half. The asymmetry with the profile bullet is real
and deliberate — the profile refusal protects a render, the frame refusal
protects a migration.

**D116 · The fixture ledger carries no scope frame, deliberately.**
`tests/fixtures/appointment-booking/band1/aspect-state.md` records a July-2026
engagement; there was no frame to record, and `check-ledger.py`'s L1 requires the
four standing head lines, not the optional ones. *Resolution taken:* the `Auto:`
precedent, applied unchanged — the fixture stands, and `tests/exit-test.md` Step
3 now says which of its two run modes sees the Frame stop. A fixture claiming a
frame nobody set would be a worse record than one that does not mention it.

### Open

**The zero-tentacles claim is now a checked fact on the payload side.** The
documents pass left it as a design commitment: the capacity check is removable
because exactly one consumer reads it. Swept across the compiled surface,
`Capacity:` appears in five places and no others — the three that carry the head
shape (`/ba-frame`, `/ba-status`, the ledger template), `/ba-frame`'s own
arithmetic that produces it, and T-18's read list and advisory that consume it.
Two writers, one reader, no third party. The corpus side of the claim is still
prose, and a sweep asserting it in the suite is a build item, not a ruling.

**The advisory's numbers are still governed by prose.** Unchanged from the
documents pass, and now with one more surface to hold: T-18's skill states the
boundary twice — in the depth rule and in the Must-NOT list — and `/ba-frame`
states it a third time at the module that produces the figures. Three sentences
are not a compiler. The candidate check is unchanged: grep an Allocation-log
reason for digits.

**Auto-pickup's parser is a live agent, and the confirmation stop is the whole
guard.** The compiled skill says scan, pre-fill, cite-or-mark, then wait. What
it cannot say is how well the scan reads a Slack extract. D-O42's one-render
ruling makes that stop cheap — one interaction for both blocks — which is the
argument for why the guard survives contact with a budget-conscious BA.

---

## Lean Scope Posture — documents-first pass, Lane B · elicitation v0.5 · catalogue-b6 v0.4 · 13 August 2026 · GREEN

Run-1 field feedback, 12 August 2026, second half: the generation posture
**thought in breadth** — a twenty-epic full-coverage roadmap where the
engagement needed a lean POC composition. The scope frame (the two passes above)
built the **post-hoc** half: envelope, delivery boundary, and T-18's advisory
with its two legitimacy tests. This pass builds the **generation-time** half —
the posture at the moments scope is *composed*, not only when it is allocated.

**Documents only, by the apply package's own scope.** Four source documents plus
one suite parameter are edited; the payload, the skills, the templates, the cards
and the compiled mirrors are a follow-up conversation. Nothing was written that a
ruling does not state.

**Code registration note** (the F-01 precedent, applied unchanged). The apply
package's own task code collides with the 7 August 2026 diagnostic audit's
finding codes F-01…F-14
(`diagnostics/audit-stage-escape-and-planning.md`), so **no F-code appears in
this block or in the documents**. The ruling is named by its content — *lean
scope posture* — and its decisions register as **D9–D10 · D-B6-10–D-B6-11**. The
same rule caught one leak at review: the package names the forward
assumptions-vs-facts item by an F-code, and D-B6-11's ruling text names it by its
content instead — *a separate item of the same Run-1 field feedback, unruled at
this sitting*.

**Parameters, allocated from the live tree.** HEAD is `2ba3140`, the F-01 rebuild
commit, so nothing needed reconciling. The doc-3 decision high-water mark 8 →
the contiguous block **D9–D10** · D-B6 9 → **D-B6-10–D-B6-11** · **no D-O number
is allocated** — the orchestrator's only edit applies D-O42, which already ruled
the fourth act, so the block stands at D-O44 · divergences from **D117**.

**Proposed, then stamped in the same sitting** — the F-01 pattern, applied
unchanged. The pass ran to its deliverable with the four editions written in as
proposals, no open conflict, and two shape decisions surfaced for ruling rather
than settled by the pass. The BA Lead ruled all of it on the spot: **the
ground-class roll-up stands as ruled into D-B6-11** — class per citation, the row
rolling up to `stated` on any one `[stated]` citation, with the all-`stated`
alternative standing on record as rejected · **tracker F-codes never enter the
corpus** — the forward item is named by its content, and the registration rule is
now a standing rule rather than the F-01 precedent it was read from ·
**writing the editions pre-stamp is accepted, the commit being the stamp act.**
The stamp followed: elicitation **v0.5** · catalogue-b6 **v0.4** · orchestrator
**v0.16** · index **v0.4**. `VERSION` stands at 0.1.12, untouched — the package
rebuild is still the follow-up conversation.

### S1 — the anchor, and where it lives (D9)

The anchor is one law, and the whole ruling turned on finding it a home that
costs nothing. **Doc 3's preamble list is that home.** Its "Operating principles"
are already what the corpus cites — `principle 2` and `principle 3` are read from
every catalogue batch and from the orchestrator — so the list is the corpus's
principle surface in fact as well as in name, and a fourth entry **appends**:
principles 1–3 keep their numbers and their wording, and every existing citation
resolves exactly as before. One other word moves — the lead-in's *three lines* →
*four lines*. The fallback the package named — a short clause in the orchestrator
— was therefore **not needed and not taken**, and the orchestrator says so in its
own change record.

Principle 4 carries the pinned text with the register's grammar: compose the
minimal scope that achieves the stated business goal, depth along the core
journey and never breadth of coverage; **discovery stays coverage-complete,
composition stays lean**; recorded breadth is welcome, composed breadth is debt.
The coverage-complete pair is written as **part of the law**, not a gloss — it is
what reconciles the anchor with T-17's coverage-complete requirement and with the
frame's boundary model, and the principle says so in its last line: consumers
cite it, none restates it.

### S2 — T-17: the probe posture and the Source ground-class (D-B6-10 · D-B6-11)

The probe guard already existed — *fires only where estate evidence grounds it*.
What it lacked was its reason, and the anchor supplies it: **a probe is a recall
check against estate evidence, never a generator**, stated once at §4 step 2 and
carried into §2's Must-NOT list in prohibition form. The rationale is on the
record in D-B6-10 rather than in the sheet: on a thin Presale estate the
checklist's own areas — administration · settings · data & content · reporting —
are the composition's primary breadth-inflation vector, because each names a
plausible capability no estate line has to support.

The **ground-class** extends D-B6-2's Source grammar by exactly one token per
citation: `[stated]` where an estate line states the capability directly,
`[inferred]` where the row exists by dependency reasoning or by a probe firing on
indirect evidence. **Both classes are legal rows** — the sheet says so twice, and
coverage-complete is untouched by construction. Two shapes needed deciding and
both are ruled in D-B6-11: the class is **per citation**, because rows are
commonly born from a stated line *plus* an inferred dependency; and it **rolls
up** — a row is `inferred` only when every citation is — because T-18 reads rows,
not citations. A seventh column was rejected: CC-H-02's row image and D-B6-2's
six columns are the checked surface, and a token fits inside a cell the grammar
already mandates.

The three micro-example rows re-render under the new grammar and **no world state
is authored** — the 13 August scope-frame scan's own constraint, honored. E-01
turns out to be the worked case free of charge: both its citations are inferred
(*own* ⇒ accounts; the role model), so the reference design's mandatory first
epic arrives the framework's way — by a probe that found evidence rather than by
a rule — and is visibly derived at birth.

### S3 — T-18: the advisory reads the class (D-B6-11, consumer half)

One line at §4 step 3, no new mechanic: a `[stated]` row carrying a hard-request
citation satisfies legitimacy test (ii) on its face, and `[inferred]` rows inside
the delivery boundary are the advisory's **first-named candidates**. The sheet
states the boundary of that reading in the same breath — *first-named, never
disqualified*: an inferred row the product cannot meet its goal without passes
test (i) exactly as a stated one does. The two tests are cited as principle 4's
composition half and their D-B6-8 wording is not touched.

### S4 — Tier 2: the drafting posture (D10)

One clause at §5.3 step 1, where the story set is composed: **against the brief's
essential scope and nothing beyond it**, with an adjacent capability discovered
while drafting routing to the brief's Deferred section — its existing home — and
never becoming a story. Under the Presale assumption posture the same clause is
the anti-"end-to-end completion" guard: assumptions fill unknowns *inside* the
essential scope, they never widen it. Cite-or-mark, the confidence rule and the
step's summary line stand as written.

### S5 — the ride-along: D113 closed

**D113 is closed by this pass.** §11's Phase-2 binding table named a three-act
safety floor in its Autonomous-mode row while §10.7 and §4.4 had both named four
since D-O42; the row now names the scope frame (P-O0b) beside the ⚑ sign-offs,
the effective PASS and the handoff, in §10.7's own order. The carry ruling
(R-F01-14a — *one clause at the next orchestrator bump*) is discharged exactly as
written: one clause, no new decision number, nothing else in the document moved.

**Two surfaces deliberately left as found**, and both are locked historical text
rather than stale rules: **D-O37's review-record row** and the **v0.14 change
record** each name three acts, which is what D-O37 ruled. D-O42 amended the floor
by new ruling, and §10.7 already carries the amendment in its own sentence — *the
fourth act added by D-O42*. Rewriting a locked ruling to match its amendment is
the one thing this corpus never does, and the D-O41 precedent (§1 principle 2,
amended by new ruling and left standing) is the pattern.

A full sweep of every floor statement in the corpus ran before the edit: the
orchestrator carries five, of which one was stale (§11), two are locked history,
and two are already correct (§4.4, §10.7); §10.2's pointer enumerates no acts, so
nothing there could drift. The **gate's** three statements are correct by design
and untouched — `ba-gate` and `/ba-handoff` name the floor members inside their
own scope, and the frame is not a gate act.

### S6 — the index, and the one suite parameter

The catalogue index regenerates at the b6 bump: **T-17's row only** — its Depth
and Expected-output cells re-derived for the probe posture and the ground-class.
T-18's index cells are genuinely unchanged, because D-B6-10–D-B6-11 move its §4
procedure and its §8 build hook, not its §2 metadata or §3 contract, and the
index is a condensation of exactly those two. Seventeen of eighteen rows
untouched.

One suite parameter moves with the document, the F-01 precedent applied
unchanged: `check-orchestrator.sh` pins the live edition in the header, so v0.15
→ **v0.16**, and the edition it displaces joins the change-record stack as its
own assertion — the same shape the pin has taken at every prior bump. The suite
is **17/17 green** with the pin moved and red without it, which is the pin doing
its job.

### Divergences flagged

**D117 · The compiled principle mirrors name three, and the corpus now has
four.** `payload/claude/agents/ba-discovery.md:19` heads its list "The three
operating principles — the whole engine" and `ba-analyst.md:90` "The three
operating principles, at spec depth"; both compile doc 3's preamble, which now
carries four. *Resolution taken:* none — the documents are the only surface in
this pass's scope, and the drift is the rebuild's first work item, not a defect
with a live consequence: the three compiled principles are each still correct and
still complete as far as they go. The count word is the tell, and it is what the
rebuild must not compile past.

**D118 · The payload carries none of this package's content.** Enumerated so the
follow-up conversation starts from a list rather than a sweep:
`ba-t17/SKILL.md` — the Source grammar at its §5 template, its §4 draft step and
its column-ownership table (four sites), plus the probe checklist's recall-check
sentence · `ba-t18/SKILL.md` — the advisory's ground-class reading · the two
persona mirrors above (D117) · `ba-tier2/SKILL.md` and `ba-enter-feature`'s
assumption-posture paragraph — the §5.3 composition clause. *Resolution taken:*
nothing compiled. The pass touched no payload file, so no skill states a rule its
source document does not.

**D119 · The Wave-2 sequencing plan's authoring template names three
principles.** `ba-native-spec-wave2-sequencing-plan.md` at its §4 procedure
template ("doc 3's three operating principles verbatim: draft-first · no question
without a destination · cited, marked, or asked") and in the grounding list a
sheet author loads ("the three operating principles (§ preamble)"). *Resolution
taken:* left as found. The plan is outside the ruled touched set, and Wave 2 is
closed at 18/18 sheets — the template has no pending consumer, so this is a
source-document tidy for that document's own next pass, exactly D113's class. It
is recorded here because a nineteenth sheet authored from the template would
inherit three principles instead of four.

**D120 · "§1 principle 2" names a list that is neither in §1 nor called
principles.** The orchestrator's own list is headed **"Three runtime rules of
this document's own"** and sits in the preamble, *above* `## 1. Position`; the
corpus cites it as "§1 principle 2" — in D-O41's locked ruling row, in §19's
origin paragraph, and in the §3.4 echo. *Resolution taken:* left as found, and
flagged now rather than later because this pass makes an unqualified `principle
4` meaningful. There is no ambiguity today — the orchestrator's list has three
items and no fourth, so an unqualified `principle 4` can only be doc 3's — but
the drift is on two axes at once (the noun and the section) and the citation
lives partly in locked review-record text, so it is a ruling's business, not a
pass's.

**Ruled the same sitting: carried.** The cite-string rename — `§1 principle` →
`runtime rule` — lands at the next convenient bump, and **this entry is the
recorded state** until then; no document pass runs for it now. D113's disposition
exactly, one carry item closing as another opens, and the same reason it costs
nothing while it stands: every reader of "§1 principle 2" lands on the only
three-item list the document has.

### Open

**The anchor's enforcement is prose, and deliberately so.** No assertion was
added — the package forbids one, and the enforcement is what D-B6-8 already
settled for the scope frame: the advisory plus a visible class. What the
ground-class buys over the frame's position is that the advisory's first-named
candidates are now **derived mechanically from the row** rather than judged from
the description, which is the difference between a reader's opinion and a
checkable read. Whether that read is *good* is a Run-2 question.

**"Both classes are legal" is the load-bearing sentence, and the one most likely
to erode in use.** The failure mode is not a framework that refuses inferred
rows; it is a BA — or a compiled skill — reading `[inferred]` as *suspect* and
quietly dropping rows the estate genuinely implies. The sheet states the
non-inference twice (the ruling and the advisory line) and the D-B6-11 row states
it a third time as the boundary on the forward assumptions-vs-facts work. Three
sentences are not a compiler; the candidate check at the rebuild is a fixture
whose roadmap carries an inferred row inside the boundary that survives an
allocation run.

**The lean posture has no test at the composition moment.** T-18's advisory fires
after allocation, and the ground-class is visible at birth — but nothing checks
that a decomposition run *composed* leanly, because the estate is the input and
coverage-complete is still the requirement. That is the design: the anchor bounds
what enters a phase, an essential-scope set, or a story set, and those are all
downstream of T-17. The Run-1 failure was a twenty-epic **roadmap**, and what
this package changes about that roadmap is the probe posture that inflated it and
the class that makes each row's derivation visible — not a cap on the row count,
which no ruling states and none should.


## Lean Scope Posture — package rebuild pass · personas · T-17 · T-18 · Tier 2 · the classed fixture · package 0.1.13 · 13 August 2026 · GREEN

The follow-up the documents pass named, and it started from that pass's own list
rather than from a sweep. `c55f56f` landed the lean scope posture in four source
documents and left the payload untouched by its own scope; **D117** enumerated
the compiled principle mirrors and **D118** the payload's T-17/T-18/Tier-2
surface. This pass compiles them — **one way: the documents govern, and nothing
was written that a ruling does not state.**

**Grounding.** Elicitation v0.5's preamble (principle 4, the anchor's pinned
text) and §5.3 step 1 (the composition clause · Deferred routing · the Presale
anti-completion corollary) · catalogue-b6 v0.4 T-17 §2 (the Must-NOT clause and
the ground-classed row grammar), §3, §4 steps 2–3 and §5's re-rendered rows ·
T-18 §4 step 3 (the advisory's mechanical read) · build-log D117–D118 for the
site list, verified against each of the above before a line moved.

**Parameters, allocated from the live tree.** HEAD was `c55f56f`, the documents
pass's own commit, so nothing needed reconciling — the remote still stands at
`f8c4459`, three commits behind (`46d51b2` · `2ba3140` · `c55f56f` unpushed),
which changes nothing here: the working tree is the live source and it governs. Divergences from **D121**.
**No decision number is allocated: this pass rules nothing** — D121's ruling
is the BA Lead's, taken mid-pass and recorded below. Every sentence it
compiled is a sentence D9–D10 or D-B6-10–D-B6-11 already states.

**Twenty payload edits, seven suite edits, every one assertion-checked** — the
anchor found exactly once or the whole run aborts before writing. The full suite
is **17/17 GREEN**, and red on a reverted payload at every one of the eighteen
new assertions, which is the suite doing its job rather than agreeing with
itself.

### S1 — the two persona mirrors (D117 closed)

`ba-discovery.md` and `ba-analyst.md` head their lists at **four** and carry the
anchor. The count word was the tell D117 named, and it moved with the content it
counts, never ahead of it. Principle 4 arrives as the **pinned text** — *the
minimal scope that achieves the stated business goal · depth along the core
journey, never breadth of coverage · discovery coverage-complete, composition
lean · the two legitimacy tests · recorded breadth welcome, composed breadth
debt* — with only the closing clause compiled per persona, exactly as principles
1–3 were compiled before it: the discovery BA sweeps the estate exhaustively and
composes from it leanly; the analyst's grain is the story set, composed against
the brief's essential scope and nothing beyond it. The corpus-authoring register
line (*consumers cite this line; none restates it*) is the one sentence that did
**not** compile — it governs document authors, not a runtime persona, and the
mirrors are the preamble rather than a consumer of it.

**The sweep found no third mirror.** Every compiled surface that could count or
quote the principles was read: `claude-block.md`, `AGENTS.md`, the eleven other
personas and thirty-four skills, `quickstart.md`, `exit-test.md`, the templates,
the cards and the status renders. The only other `principle`-numbered citation in
the payload is `ba-t18`'s `principle 3 at phase grain`, which is untouched and
still resolves. D117 named two; two is all there was.

### S2 — T-17: the probe posture and the Source ground-class (D118, first half)

The probe posture lands at **two sites and no more**, mirroring the sheet: the
operative sentence at the candidate sweep — *a probe is a recall check against
estate evidence, never a generator* — leading the existing *fires only where
estate evidence grounds it* guard it strengthens, and the prohibition form as a
new depth-boundary bullet. The never-list's standing clause (*never invents a row
a probe suggested but no evidence grounds*) was left exactly as found: it is the
same prohibition, already compiled, and a third statement site is how a
prohibition starts drifting from itself.

The **ground-class** compiles at four sites — the depth boundary's row grammar,
the column-ownership table plus its phase-hint paragraph, the draft step, and the
output grammar — carrying the notation per citation, *both classes are legal
rows*, and the roll-up: a row is `inferred` only when every one of its citations
is. The worked example re-renders: E-01 doubly `[inferred]`, E-03 doubly
`[stated]`, E-07 `[stated]`, and a new bullet reading E-01 as the class's worked
case, which is the sheet's own reading and no new world state.

**The pinned output contract was checked and deliberately not moved.** §3's
Expected-output cell gained *every citation ground-classed* inside its
`Source (D-B6-2 grammar…)` parenthetical — and the compiled contract string has
never carried that parenthetical: it read `· Source;` before the ruling, when the
cell read `Source (D-B6-2 grammar)`. The pin names the **column**, not the cell's
grammar, so the ruling passes through it by construction. Nothing followed:
`check-spine.sh`'s character-for-character assertion stands, and the fixture's
July-2026 composed plan was not touched.

### S3 — T-18: the advisory reads the class (D118, second half)

One bullet inside the scope-frame advisory, no new mechanic: a `[stated]` row
with a hard-request citation satisfies the second legitimacy test on its face;
`[inferred]` rows inside the boundary are the advisory's **first-named
candidates — first-named, never disqualified**, and an inferred row the product
cannot meet its goal without passes the first test exactly as a stated one does.
The two tests are cited as **principle 4's** composition half and their wording
is not touched. One clause joins the writer split — the ground-class is written
by T-17 and only read here — which is D-B6-11's own column-ownership finding and
the thing that keeps the class from acquiring a second author.

### S4 — Tier 2: the drafting posture (D118, the drafting surface)

The composition clause lands at the moment the story set is composed —
`ba-tier2`'s *stories first* step, before the drafting module is loaded: composed
against the brief and nothing beyond it, an adjacent capability routing to the
brief's **Deferred** section and never becoming a story, and the Presale
corollary in the same breath. `story-drafting.md`'s excluded behavior 6 already
sent a good idea to a routed finding or an Open Question; it now names the ruled
destination for the adjacency case beside them — the module is where a drafter
stands when adjacency appears, and the skill carries the framing. Two halves of
one clause, not one clause twice. `ba-enter-feature`'s assumption-posture
paragraph gains the corollary's own sentence: assumptions fill unknowns *inside*
the essential scope and never widen it.

### S5 — the suite, and the one defect it caught

**Eighteen assertions added, none moved and none relaxed** — every one against a
fact that became true in this pass: the count word and principle 4 on both
personas, T-17's probe posture in both forms plus the notation, both-classes-legal
and the roll-up, T-18's first-named-never-disqualified line and its anchor
citation, Tier 2's three clauses, the module's destination, and
`ba-enter-feature`'s corollary. Proven live twice over: the pass counts rose by
exactly eighteen, and a stashed payload turned all eighteen red.

`check-register.sh` caught a real defect in this pass's own prose — the new
writer-split sentence rendered **`T-18` bare**, without its name, against §10.3
rule 5. Fixed at the source (`T-18 — Scope allocation`) rather than by exempting
the line, and the matching assertion moved with it. The register check earned its
row: nothing else in seventeen checks would have seen it.

### Divergences flagged

**D121 · The fixture roadmap carries no ground-class, and this pass did not add
one.** `tests/fixtures/appointment-booking/project/.specify/memory/roadmap.md`
records the canonical 2026-07-11 decomposition — the same world the sheet's
micro-example renders — and its eight Source cells stand in the pre-ruling
grammar. *Resolution taken:* the **D116 precedent**, applied unchanged: a fixture
recording a world state that predates a ruling stands as found. The sheet classes
exactly three rows (E-01, E-03, E-07); classing the other five would mean ruling
five derivations no document states — E-08's *canvas: Objectives O-2 —
measurement ground* is an objective rather than a capability line, and which
class that is, is a judgment, not a compilation. Classing only the sheet's three
would leave the fixture internally inconsistent, which is worse than either
whole option. **Raised as open question 1**, because the documents pass's own
Open section names this fixture as the rebuild's *candidate check* — a roadmap
carrying an inferred row inside the boundary that survives an allocation run.
The fixture already **is** that case in substance: E-01 is inferred by the
sheet's own reading, sits in MVP, and survives Allocation 1. Only the tokens are
missing, and the five rulings are what they cost.

**D121 · closed the same sitting, EK-ruled: re-render now, all eight rows.** The
three sheet-classed rows carry their classes; the five derived ones follow the
class definition itself — a capability line in the estate is `[stated]`,
dependency- or probe-derived ground is `[inferred]` — with **objective-ground
ruled `[inferred]` by definition**: an objective states a goal, not a capability,
and the epic is derived from it. The derivations, each read off the citation it
classes:

| Row | Citation | Class | Why |
|---|---|---|---|
| E-01 | canvas Core Functions "Cancel own appointment" (*own* ⇒ accounts) · roles-permissions.md | `[inferred]` ×2 | sheet-classed — the *own* scoping and the role model imply accounts; no line states them |
| E-02 | canvas: Core Functions — browse line | `[stated]` | a canvas Core Functions capability line |
| E-02 | domain-model.md (Specialist) | `[inferred]` | an entity, not a capability; profile content and the service durations Slot length derives from are dependency ground |
| E-03 | the five-function canvas line · processes.md booking journey | `[stated]` ×2 | sheet-classed — a capability list and a journey |
| E-04 | canvas: Third-Party Connections | `[stated]` | a connection row, which the class definition names by name; canvas §8 states outbound mirroring directly |
| E-04 | constraints.md §1 | `[inferred]` | a constraint — *the calendars Specialists already keep stay in place* — from which the sync need derives |
| E-05 | canvas: Core Functions — notify line | `[stated]` | a capability line |
| E-06 | call 2026-07-14 — clinic administrators (RO-1 deferral) | `[stated]` | the client stated the capability in the room (*"at two of the clinics an administrator maintains the calendars"*), and the canvas absorbed it into Core Functions line 7 citing that same call — an estate line stating the capability directly |
| E-07 | out-of-scope.md payments deferred row — graduated | `[stated]` | sheet-classed |
| E-08 | canvas: Objectives O-2 — measurement ground | `[inferred]` | **EK-ruled** — objective-ground by definition |

**Row roll-ups: E-01 and E-08 `inferred`; the other six `stated`.** Two of the
eight rows are inferred and both are legal, which is the *both classes are legal*
sentence carrying its own worked corpus rather than a single showcase row. E-08
also gives the class its second reading: an inferred row that sits in `Later` —
outside any delivery boundary — is not an advisory candidate at all, which is the
difference between the class and a verdict.

**`ba-t17/references/example.md` was checked and needed nothing.** Its bullet
reads E-01 as the class's worked case, inferred and surviving allocation
first-named; the classed fixture confirms that reading rather than changing it.
E-08's arrival adds no second candidate inside a boundary, and the fixture ledger
carries no scope frame at all (D116), so the example's mechanism sentence stands
as written.

**D122 · carried, EK-ruled** — it joins D119 as the corpus's last two *three
principles* strings, both source-document tidies for one sweep at a future
convenient bump. No document pass runs for either now.

**D123 · The ground-class token satisfies the validator's citation regex.**
`check-band2-artifacts.py`'s `CITATION_RE` matches any bracketed run, so once
every Source cell carries `[stated]` or `[inferred]`, a cell of **class tokens
alone** would have passed **B75** — *every row cites its discovery ground*.
Found while re-pointing B75's mutation anchor at the re-rendered cell.
*Resolution taken:* the class tokens are stripped before the citation test. This
is not a new rule and not a relaxed one — it is B75 continuing to assert exactly
what it asserted before the grammar extended underneath it, which is the same
discipline every suite parameter has moved under. A **34th seeded defect** was
added to prove it: a Source cell reduced to `` `[inferred]` `` and nothing else
now fails B75, where before this pass it would have passed. The three count
strings moved with it, 33 → 34.

**D124 · The certification manifest caught the fixture edit, as designed.**
`expected/gate-run3.entry` pins a sha256 per estate file, and `roadmap.md`'s
changed with the re-render — `6088…` → `0021…`. *Resolution taken:* the recorded
hash was updated to the value the live snapshot computes, and nothing else in the
entry moved: the diff was exactly one line, which is the manifest reporting a
content change rather than a defect. Recorded because a golden-file edit should
never be silent, and because it is the standing cost of touching the fixture —
any future fixture re-render pays it again.

**D122 · The Phase-2 build plan's persona row still names three principles.**
`ba-native-spec-phase2-build-plan.md` §7's `ba-discovery` row reads *"carries the
three doc-3 operating principles + writing-standard discipline"*. *Resolution
taken:* left as found — source documents are read-only in this pass, and this is
**D119's class exactly**: a source-document tidy for that document's own next
pass, with no live consumer, since the persona it describes now carries four and
the suite asserts it. Recorded so the two carries travel together — the Wave-2
sequencing plan's authoring template (D119) and this row are the corpus's last
two *three principles* strings.

**Nothing else diverged.** The four D117/D118 sites were each verified against
the source before editing and each closed. `sk_health.py` never reads the Source
column, so **CC-H-02 compiles unchanged** exactly as the conflict scan predicted;
the repo-side validator's `B75` (*every row cites its discovery ground*) and
`B78` (*coverage by stem match*) both read past a leading token, so the extended
grammar is legal to them without a parameter move. No assertion was added to the
contract, no threshold moved, and no new phase or status value exists.

### Open

**The anchor's enforcement is still prose, and now it is compiled prose.** What
this pass changes is the reach: the posture is stated where generation happens —
the sweep, the draft step, the story set — rather than only in the preamble a
runtime never loads. Whether a compiled sentence at the composition moment
actually bounds a composition is a Run-2 question, and the same one the documents
pass left open.

**The erosion risk moved into the payload with the class.** `[inferred]` read as
*suspect* is the failure mode, and the compiled surface now states the
non-inference twice — *both classes are legal rows* in T-17, *first-named, never
disqualified* in T-18 — with an assertion behind each. That is two sentences and
two checks where the sheet had three sentences and none. It is better than the
document's position and still not a compiler.

**The candidate check is built.** D121 was ruled in the sitting, and the fixture
now carries the case the documents pass named: `[inferred]` E-01 inside MVP,
surviving Allocation 1, with a second inferred row parked in `Later` to show the
class is not a verdict. What is checked is the grammar and the corpus; what is
still not checked is a *run* — no test drives a decomposition and reads the class
it wrote. That remains a Run-2 question, and a smaller one than it was.

**The class now has two authors and one of them is a regex.** D123's fix means
the validator knows the difference between a citation and a class token; nothing
enforces that distinction inside a compiled skill, which states it in prose. If a
third token ever joins the grammar, `GROUND_CLASS_RE` is the second place it has
to land, and only the suite will say so.


---

## Source Inventory at Frame — documents-first pass, Lane B · orchestrator v0.17 · catalogue-b1 v0.5 · index v0.5 · 13 August 2026 · GREEN

Run-1 field feedback, 12 August 2026, second finding: the client's ≤ $50K POC
constraint sat in the **first message of a connected Slack channel** and was
never read. T-01's intake works from the material *on hand* (catalogue-b1 §4
step 1) and **nothing in the framework asked what existed beyond it**. The scope
frame gave the constraint a home; it did not give the framework a reason to go
looking. The ruling is the **source inventory** — a first block on the Frame
render, capture mechanics with a pinned destination, honest dispositions for
unreachable sources, and a ledger-head line that makes *was Slack checked?* a
one-glance question.

**Documents only, by the apply package's own scope.** Three files are edited —
the orchestrator, catalogue-b1, and `tests/presale-path.md` (named explicitly by
the package's §2.7 budget-conformance clause). The payload, the skills, the
templates, `docs/quickstart.md`, `tests/exit-test.md` and `tests/layout.expected`
are the follow-up conversation; every site they owe is enumerated in D126–D127
below. Nothing was written that a ruling did not cover.

**Code registration note** (the D-O42–D-O44 precedent, applied unchanged): the
apply package's own task code **F-04** collides with the 7 August 2026 diagnostic
audit's finding codes F-01…F-14 (`diagnostics/audit-stage-escape-and-planning.md`),
so no F-code appears in this block or in the documents. The ruling is named by
its content — *the source inventory* — and its decisions register as
**D-O45–D-O49 · D-B1-6**, each block contiguous from the live high-water mark
read in the file. No code is reused.

**Parameters, allocated from the live tree.** HEAD is `75f3630` (package 0.1.13).
The D-O high-water mark 44 → the contiguous block **D-O45–D-O49** · D-B1 5 →
**D-B1-6** · divergences from **D125**. Versions were proposed, not stamped, so
the pass ran to its deliverable with no edition number and no review-record
section written, and one suite parameter deliberately red (D125) rather than
quietly relaxed.

**Proposed, then stamped in the same sitting** (the scope-frame precedent). The
BA Lead confirmed both surfaced judgement calls on the spot — **the correction
stop is P-O0b re-taken, no new prompt point** · **`sources/` is placement only,
captures never join the CC-H-01 estate, the carve-out stands as written** — and
added one line to the D-O49 record: since P-O0b sits on the never-AUTO safety
floor, **the correction stop is BA-only under autonomy by composition**, so the
contradiction case can never be AUTO-accepted and no §10.7 policy row is needed.
The stamp followed: orchestrator **v0.17** (§21 review record, five rows) ·
catalogue-b1 **v0.5** (D-B1-6) · index **v0.5**, regenerated with all 18 rows
unchanged. `VERSION` and the payload are untouched; the package rebuild is still
the follow-up conversation.

### S1 — the orchestrator §8.1 (D-O45 · D-O46 · D-O47 · D-O49)

§8.1 gains the **source inventory** as the Frame render's pinned first block,
ahead of the picker and the frame, with the act sentence moved from two pinned
blocks to three. **One render, one reply** extends from D-O42's two blocks to
three: the BA answers sources, profile and frame in one reply, Frame still costs
**one** interaction, and D-O33's ≤ 8 budget with its slack is untouched. The
reply itself may carry sources — pasted content and attachments capture like a
read channel.

**Capture mechanics (D-O46).** Reachable → read bounded by what the BA named,
**captured verbatim into a source artifact**, then mined under cite-or-mark;
extraction is capture, never interpretation, and the artifact — not the live
channel — is the citation ground. Unreachable → said plainly, with three
dispositions the **BA** rules: `supply` · `skipped — <reason>` (the `N/A`
pattern at source grain) · `named — pending` (a visible hole, Frame proceeds).
Silence resolves nothing.

**Capture destination (D-O47).** The corpus was searched first, as the package
required: **no home existed.** D-O19's clause names captured client material as
Tier-1's notes input, and every catalogue sheet reads *presale material and
transcripts on hand* as supplied — never from a path. So one is pinned on the
canvas precedent: **`sources/` at repo root**, deliberately outside
`.specify/memory/`, one artifact per capture named for its origin. **Placement
only** — the block says so explicitly, because the canvas precedent carries
estate membership the capture must not inherit: no assertion reads `sources/`,
and CC-H-01's glob (`.specify/memory/*`, `canvas.md`, `constitution.md`) is
untouched.

**The correction stop (D-O49).** Auto-pickup runs on the material on hand *at
render time*; sources named in the reply are captured *after* it. Where a capture
contradicts or fills a frame value the BA just confirmed — the Run-1 case exactly
— the framework renders a correction proposal and **re-takes P-O0b**. That
resolution is deliberate and is the pass's one judgement call: §10.1 says
*nothing outside this table interrupts the BA*, so a new stop needed either a new
prompt point or an existing one. The frame is switchable at any time and its
switch is already a P-O0b act with a logged `scope-frame` event — so the
correction **is** P-O0b, taken a second time. No P-O row was invented, and the
stop rides the budget's slack (7 + 1). Consistent captures produce no stop.

**Late sources (D-O49).** Zero new machinery, as ruled: content routes through
doc 3 §3.5's existing ingestion; a budget- or scope-shaped finding fires the
scope-frame-change proposal (D-O43) and its T-18 trigger (D-B6-7). Both cited,
neither re-legislated.

### S2 — the orchestrator §2.4 (D-O48)

The head gains a sixth Frame-time line, `Sources:`, placed **between `Profile:`
and `Boundary:`** — D-O43's scope-frame group stays contiguous and D-O38's
`Auto:`-after-`Profile:` ordering still holds (`check-auto`'s ordering probe is
green). The state vocabulary is closed at four: `captured <date>` ·
`named — pending` · `skipped — <reason>` · `none`. The ruling required an Events
entry *per the existing grammar* without naming a shape, so the scope-frame
switch line was mirrored at source grain —
`<date> · source · <name> · <state> · <BA initials> — <basis>` — and the exhibit
carries a populated example. §10.3 rule 8's pinned-formats list and §11's Frame
binding row extend in step, the way every prior pinned shape has.

### S3 — T-01, catalogue-b1 (D-B1-6)

Inputs only, as ruled. §4 step 1 states that captured source artifacts join the
material on hand, read like a supplied transcript and **cited by artifact, never
by the live channel**; §8's build hook names `sources/` in its inputs list. The
boundary is stated once and only once: the inventory is **Frame-act ground and
never this run's** — T-01 neither names a source nor rules a disposition, and the
no-question-loop rule of its §2 Depth cell is untouched. No procedure step, no
section, no line-ID scheme, no AT hook and no micro-example moved.

### S4 — budget-document conformance (`tests/presale-path.md`)

The package's §2.7 asked for the correction stop **without a numbered
interaction**, or a numbered question. It went in cleanly: interaction 1's text
gains the inventory block and the disposition set, and the correction stop lands
as an italic note inside that section. `check-budget.sh` counts
`^## Interaction <n>` headings and still reads **8 ≤ 8**. Interaction 8's slack
now names its third consumer, and the Green-when line asks for the `Sources:`
line. No question was needed.

### Test run — 16 of 17

`check-m` 40/0 · `check-gate` 59/0 · `check-techniques` 104/0 ·
`check-techniques2` 122/0 · `check-techniques3` 158/0 · `check-spine` 174/0 ·
`check-register` 62/0 · `check-wbs` 62/0 · `check-status` 94/0 · `check-auto`
93/0 · `check-budget` 37/0 — **the Presale path still 8 ≤ 8** · `check-ledger`
grammar-legal, 14 rules, no violations · `check-cards` every card byte-identical
to its re-derivation · `check-orchestrator` **156/0** at the stamp (152/1 before
it) · `check-install` 64/0 · `check-exit --offline` all ten steps · `check-layout`
GREEN at the full §1.1 tree, run against a fresh `install.sh` into an empty git
repo — the source tree is not an installed project, so a bare run of it reports
86 unmet on any commit, this one included. **Zero red, nothing skipped**, the
three install-based runs included.

### The records, where they landed

Written as drafted, so they are not restated here — reference-never-restate, the
discipline the corpus applies to its own log. **Orchestrator §21 (v0.16 →
v0.17)** carries D-O45–D-O49 with the *what did not move* paragraph and the
conflict scan against contract v0.2 · gate v0.6 · elicitation v0.5 · standard
v0.3 · catalogues b1 v0.5, b2–b5 v0.2, b6 v0.4. **Catalogue-b1's Review record
(v0.4 → v0.5)** carries D-B1-6 with its own scan. Two notes on what the stamp
added beyond the draft:

**D-O49 gained the autonomy line, EK-ruled.** *Since P-O0b sits on the never-AUTO
safety floor (§10.7 · §4.4, D-O42), the correction stop is BA-only under autonomy
**by composition** — the contradiction case can never be AUTO-accepted.* It is a
derivation, not a new reservation: no §10.7 policy row was added, no floor act
was added, and `check-auto`'s four-act sweep across 76 files is green unchanged.
The line was put in the record rather than in §8.1 because the ruling named the
record, and because a rule that derives from the floor should be read where the
floor's consequences are already argued.

**The index changed no cell, and says so.** D-B1-6 moves T-01's §4 step 1 and its
§8 build hook — procedure and build-brief ground — while the index carries §2
metadata + §3 contract only. Its footer states the reasoning rather than leaving
an unexplained version bump: the captured artifacts are an **input**, and T-01's
Destination file is still `canvas.md`. All 18 rows unchanged, the v0.2 precedent.

**Elicitation stayed untouched, and needed no cite.** D-O19's captured-material
clause lives in orchestrator §6.5; the destination is stated once in §8.1 and
cited from T-01's inputs, exactly as the package directed; §3.5's ingestion is
consumed by reference for late sources. Nothing there was re-legislated.

### Divergences

**D125 · The D-O block runs 1…49 while the review record stops at D-O44.**
`check-orchestrator.sh` asserts contiguity against a hard-coded
`set(range(1, 45))`, and the header assertion pins the live edition at `v0.16`.
The apply package rules *propose, do not stamp*, so the body cites `D-O45`–`D-O49`
and no §21 review record exists to hold them. **This is D103's case, repeated
exactly.** *Resolution taken:* held red through the deliverable rather than
relaxed, then **closed at the stamp** — §21 landed with its five rows, the
header, change record and footer took v0.17, and the bound moved
`range(1, 45)` → `range(1, 50)`. The assertion was never relaxed to buy a green
board; it went green because the thing it asserts became true. Three assertions
were **added** in the same edit rather than merely retargeted: the §21 section
inventory entry, `v0.16` joining the edition stack the header check vacates, and
`D-O45–D-O49` as the named ruling block — so the suite now holds five editions
and five ruling blocks, not four.

**D126 · `sources/` is a new runtime-born path and `tests/layout.expected` has
no row for it.** The file enumerates the installed tree and asserts runtime-born
paths **absent** on a fresh install (D-P2-6) — `RT|absent|canvas.md|◇ T-01
(Frame)` is the precedent this one follows exactly. *Resolution taken:* left as
found — `layout.expected` is a test file and this pass is documents-only. The
rebuild pass owes one row: `RT|absent|sources|◇ /ba-frame source inventory
(orchestrator §8.1)`. Recorded because a pinned home with no layout row is a hole
that only shows up as a green board.

**D127 · Three carriers still say the Frame render is two blocks answered in one
reply.** Enumerated so the rebuild pass has the list rather than a search:
`payload/claude/skills/ba-frame/SKILL.md` (three lines — the one-render-one-reply
paragraph at 54–55 and the checkpoint paragraph at 67, plus the pinned block
itself and the head shape) · `docs/quickstart.md:73` (*"you answer both in one
reply"*) · `tests/exit-test.md:87`. The head-shape carriers owing a `Sources:`
line are three: `payload/claude/skills/ba-frame/SKILL.md` ·
`payload/claude/skills/ba-status/SKILL.md` ·
`payload/specify-overlay/ba/templates/aspect-state.md`. *Resolution taken:* left
as found — payload, quickstart and the exit script are the follow-up
conversation's ground by the package's own scope line. None is stale against a
*ruled* document until the stamp lands.

**D128 · The fixture ledger will carry no `Sources:` line, by the D116
precedent.** `tests/fixtures/appointment-booking/band1/aspect-state.md` records a
July-2026 engagement: there was no inventory to take, and `check-ledger.py`'s L1
requires the four standing head lines, not the optional ones — it runs green
against the fixture unchanged, and did in this pass. *Resolution taken:* the
`Auto:` and scope-frame precedent, applied unchanged. A fixture claiming sources
nobody inventoried would be a worse record than one that does not mention them.
Recorded so the rebuild pass does not "fix" it.

**Nothing else diverged.** The corpus was swept for an existing captured-material
home before `sources/` was pinned, as the package required, and the negative
result is what D-O47 rests on. `check-budget` absorbed the correction stop with
no numbered interaction, so §2.7's escape hatch went unused. CC-H-01's glob, the
P-O table, the four-act safety floor, the ≤ 8 budget, T-01's depth rule and the
13-section canvas shape are each untouched, and no assertion was added anywhere.

### Open

**The inventory asks; nothing makes the framework able to answer.** Whether a
named Slack channel is *reachable* is a runtime fact about the installed
integrations, and the documents can only say what to do in each branch. The
honest reading is that D-O46's unreachable branch will be the common one for a
while, and its value is the recorded disposition, not the capture.

**`sources/` is pinned by prose and nothing enforces it.** No assertion reads the
directory — deliberately, since the package forbade new assertions — so a capture
written somewhere else fails no check. The `Sources:` line is the only place a
missing capture becomes visible, and only to a reader.

**The correction stop's fit to P-O0b is a reading, not a ruling.** It is the
resolution that invents no prompt point and satisfies §10.1's *nothing outside
this table* clause, and the BA Lead should see it named as a choice: the
alternative was a `P-O0c` row, which would have been a new prompt point the
package did not rule.


---

## Source Inventory at Frame — package rebuild pass · `/ba-frame` · templates · mirrors · suite · 13 August 2026 · GREEN

The follow-up to `b11ead2`, run against the live tree. The F-04 documents pass
enumerated its own rebuild surface — **D126** (`sources/` owes a
`layout.expected` row) · **D127** (three carriers still say the Frame render is
two blocks; three head-shape carriers owe a `Sources:` line) · **D128** (the
fixture ledger keeps no `Sources:` line, a kept state) — and that enumeration was
the work list. Compilation only: orchestrator §8.1 · §2.4 · §10.3 rule 8 · §11
and catalogue-b1 T-01 §4.1/§8 govern; nothing was written that a ruling does not
state.

**Parameters, allocated from the live tree.** HEAD is `b11ead2` (orchestrator
v0.17 · catalogue-b1 v0.5 · index v0.5, package 0.1.13). The divergence
high-water mark is D128 → the contiguous block **D129–D131**. `VERSION` is
untouched: the bump is **proposed, not stamped** (§4 below).

**Method, as the package required.** Every edit ran as an assertion-checked
Python replacement — the anchor found exactly once or the run aborts before
writing; 32 anchors across 15 files, zero residual markers by grep. Twelve source
documents were read and none edited. The full suite is **17/17 GREEN**, the three
install-based runs included, and **red at every new assertion class** on a seeded
payload — the non-vacuity control below.

### S1 — `/ba-frame`: the render's first block (D-O45–D-O49)

The source inventory compiles as the render's **first block**, ahead of the
picker and the frame, **byte-identical to §8.1's pinned text** (a fenced-block
comparison against the document is one of the new assertions, not an eyeball).
Step 2's heading names it first; *one render, one reply* extends from two blocks
to three, with the reply's own carried sources — pasted content and attachments
captured like a read channel.

**Capture mechanics** land as their own subsection: the bounded read, the
verbatim capture, *extraction is capture, never interpretation* with the artifact
as citation ground, and the three dispositions the BA rules — `supply` ·
`skipped — <reason>` · `named — pending` — under *silence never resolves it*.
`sources/` at repo root is pinned with its **placement-only** clause carried
intact: no assertion reads it, no estate glob takes it.

**Auto-pickup ordering** compiles §8.1's own sentence: the scan runs against the
material on hand **at render time** — the inventory's first line is exactly that
list — and sources named, pasted or attached in the reply are captured *after*
it. That is what the correction stop exists for (D130 below).

**The correction stop** compiles as **P-O0b re-taken** — the frame's own switch
act, logged as the `scope-frame` event, explicitly *not a new prompt point*,
riding the budget's slack (7 + 1), silent on consistent captures. **No fifth
floor act, no new P-O row, and the never-AUTO derivation stays in D-O49's record**
— it is not behavior text, by the package's own instruction. `check-auto` is
93/0 unchanged and `ba-auto/SKILL.md` is byte-for-byte untouched.

The head write gains its `Sources:` line, the Events grammar gains the `source`
line at source grain, late sources get D-O49's zero-new-machinery paragraph, and
the never-list gains two clauses: never rule a disposition on the BA's behalf,
and never interpret a capture or land one under `.specify/memory/`.

### S2 — the ledger head, in all three carriers (D-O48 · D127)

`Sources:` lands **between `Profile:` and `Boundary:`** in the shipped template,
the `/ba-status` render and the `/ba-frame` head write — one grammar, three
copies, now asserted in all three plus the §2.4 exhibit, with a position probe
per carrier. **D-O38's `Auto:`-after-`Profile:` ordering still holds**:
`check-auto`'s probe was run green before the edit and green after it. The
template's comment block gains the source-inventory note and the `source` event
grammar.

### S3 — D127's carriers, and the ones the enumeration did not reach

The two-block phrasing is gone from all three named sites —
`ba-frame/SKILL.md` · `docs/quickstart.md` · `tests/exit-test.md` — and a sweep
for a fourth found **none**: zero hits across the payload, docs, tests and README
for *both in one reply* · *two pinned blocks* · *render both blocks* · *not two*.
The head-shape carriers were exactly the three D127 named. What the enumeration
did **not** cover is D131 below.

### S4 — D126: `sources/` in `layout.expected`

`RT|absent|sources|◇ /ba-frame source inventory (orchestrator §8.1)` — the row
D126 itself drafted, resolved **inside the suite's own semantics** with no new
class invented. `RT` is already *runtime-born (◇) — asserted ABSENT on a fresh
install*, and `check-layout.sh` tests RT rows with `[ -e ]`, which covers a
directory as readily as `canvas.md`'s file. So the placement-only ruling is
honoured exactly: nothing installs `sources/`, it exists only once a capture
lands, and no assertion treats it as estate. `check-layout` moves 111 → 112, and
the `/ba-*` skill count reads `^S[0-9]|file|` rows only, so it is untouched at 34.

### S5 — D128: the fixture, left alone

`tests/fixtures/appointment-booking/band1/aspect-state.md` carries **no**
`Sources:` line and was not edited. `check-ledger.py`'s L1 requires the four
*standing* head lines — `Standing aspect waivers:` · `Open reopens:` ·
`Upstream flags:` · `Deferred consequences:` — never the optional Frame-time
ones, so the July-2026 engagement stays green as a record of a project that
inventoried no source. No suite assertion was added that would force the line
onto a pre-frame ledger; the `/ba-aspect` frame-refusal precedent was not needed,
because nothing conflicted.

### S6 — the sweep: register rule 8, and the command row

§10.3 rule 8's pinned-formats list gained `source inventory §8.1` in the
documents pass, and **six compiled carriers** owed it — the four personas
(`ba-orchestrator` · `ba-analyst` · `ba-gate` · `ba-discovery`) and both mirrors
(`AGENTS.md` · `claude-block.md`). `claude-block.md`'s `/ba-frame` command row
gained the inventory with its capture home and head line, mirroring §11's Frame
binding row. **`ba-auto`'s four-act floor text did not change** and no §10.7
policy row was added — the documents rule that the stop is BA-only *by
composition*, which is a derivation and not a reservation.

### Suite conformance — 42 assertions added, none relaxed

A new **section 5b** in `check-orchestrator.sh` for the compiled surface, and a
new **section 4b** for D132's five event forms. Every probe reads a fact the
documents state and the package now carries. Nothing existing was retargeted,
loosened or deleted; the count moves **156 → 198**, `check-layout` 111 → 112, and
every other check is byte-for-byte the number it was.

- the pinned block **byte-identical to §8.1's**, compared as a fenced block
  rather than by needle, so a paraphrase fails;
- first-block placement · three blocks one reply · Frame-act-ground · extraction
  is capture · the artifact as citation ground · the three dispositions ·
  *silence never resolves it* · `sources/` one-per-capture · placement-only ·
  not-a-new-prompt-point · P-O0b re-taken · no stop on a consistent capture ·
  late sources;
- the `Sources:` head line in the §2.4 exhibit **and all three carriers**, plus a
  position probe (`Profile:` < `Sources:` < `Boundary:`) per carrier;
- the `source` Events grammar in the document, the skill and the template;
- `sources/` classed runtime-born in `layout.expected`, **with its negative**: a
  row installing it under any build session is a failure, which is the
  placement-only ruling made mechanical.

**The non-vacuity control.** Five breakages were seeded into private copies — a
one-word edit inside the pinned block, the correction stop inverted, the head
line deleted from `ba-status`, the head line pulled out of position in the
template, and `sources/` re-classed as installer-laid. **Eight assertions fired
across all five probe classes**, and restoring returned the suite to 184/0. An
assertion that has not been shown to fail is a comment.

### Divergences

**D129 · `/ba-frame` said it writes exactly two files, and the ruling makes that
false.** The skill's invocation contract read *"This skill writes exactly two
files, both ledgers"* — a sentence whose point is that **the orchestrator never
authors content**, and whose count the capture mechanics break: a reachable
source is captured at Frame, into `sources/`. *Resolution taken:* the sentence
was amended, not deleted — the skill writes the two ledgers **and one verbatim
artifact per capture**, with D-O46's *extraction is capture, never
interpretation* carried in the same breath so the never-authors principle stands
where the count used to. Recorded because a load-bearing sentence changed shape,
and because the alternative — leaving a false count in an invocation contract —
is the kind of stale guard that reads as law for a year.

**D130 · The apply package's work-list glosses the auto-pickup ordering against
§8.1's own sentence.** §1.1 reads *"Auto-pickup ordering: inventory answered →
captures read → pre-fill → confirmation."* §8.1 states the opposite sequence:
*"**Before** rendering the block the framework scans the sources on hand… and
pre-fills the values"* and *"Auto-pickup runs against the material on hand **at
render time**… Sources the BA names, pastes, or attaches in the reply are
captured **after** it."* *Resolution taken:* **the document governs**, per the
package's own one-way-compilation rule, and §8.1's sentence compiled verbatim in
sense. The gloss is reconcilable as a description of the *correction* cycle —
inventory answered, captures read, the pre-fill revisited, the frame
re-confirmed — which is precisely what the correction stop is; read as the
ordering of auto-pickup itself it contradicts the ruling. Recorded rather than
silently resolved, because the two readings produce different skills.

**D131 · Register rule 8's list was a sixfold carrier the D127 enumeration did
not name.** D127 enumerated the two-block carriers and the head-shape carriers
and was complete for both. It did not reach §10.3 rule 8's pinned-formats list,
which the documents pass extended with `source inventory §8.1` and which compiles
into four personas and two mirrors — six files, none of them a Frame-render
description or a head shape. *Resolution taken:* swept and fixed under work-list
item 6, which asked for exactly this class. Recorded so the next pass reads
D127-style enumerations as *complete for the classes they name*, not as the whole
rebuild surface: a ruling that touches §10.3 always touches six compiled copies.

**D132 · `check-ledger.py` rejects five pinned head-event forms, `source`
now among them.** Probed rather than assumed, because the template this pass
edited teaches the BA to write one. L3 — *every event line is one of the known
forms* — recognizes transitions, band events, review tables, RO and AW records
and gap candidates. It recognizes **none** of the five head-line events §2.4
pins: `profile` · `scope-frame` · `auto on|off` · `ratification` · `source`. A
live ledger carrying any of them fails validation, and the shipped template
carries all five grammars in its comment block. **This pass did not introduce
it** — `profile` predates the scope frame, `scope-frame` landed with package
0.1.12 and the `auto` pair with 0.1.11; each rebuild compiled the grammar into
the template and left the validator un-extended, and the board stayed green
because no fixture in the tree carries one. The `Sources:` **head line** itself
validates clean in all four states — head lines are not events, and L1 checks
only the four standing ones.

*Resolution taken — **EK-ruled and fixed in this pass**.* **L3 accepts exactly
the five §2.4-pinned event forms, verbatim grammar, nothing else.** The basis is
that each form is already ruled and pinned: the validator is **not legislating,
it is conforming to standing law**, so one ruling covers all five and reopens
none of them. **Why it could not wait:** the F-04 correction-stop path is the
Run-1 scenario itself, and it logs a `source` event *and* a `scope-frame` event
on a live ledger — the validator would have failed a legal run of the very
mechanism this pass compiled. Shipping the inventory with a validator that
rejects its own event was not an option the record could carry.

The extension is **six rows probing five forms** (`auto` is one form in two
shapes) and every row runs **both ways** — the pinned grammar must validate, and
a malformed variant of the same form must trip L3: `Presale to Discovery` with
no arrow · a scope-frame with no `<from → to>` · a source state outside the
closed four · `pending` where `named — pending` is the vocabulary · `AG-one`
where the grant is numbered · a bare `ratification` with no AG. Two further
probes hold the boundary: `skipped — <reason>` validates with its reason riding
the state, and a sixth form nobody ruled is still rejected. `check-orchestrator`
moves 184 → **198**; the fixture, which carries none of the five, is unchanged
and still validates.

**Nothing else diverged.** The four-act safety floor, the P-O table, CC-H-01's
glob, the ≤ 8 Presale budget, T-01's depth rule, the 13-section canvas and the
34-skill registry are each untouched. No new rule, threshold or behavior was
invented, and no assertion anywhere was relaxed.

### Test run — 17 of 17

`check-m` 40/0 · `check-gate` 59/0 · `check-orchestrator` **198/0** (156 before
this pass; +42) · `check-techniques` 104/0 · `check-techniques2` 122/0 ·
`check-techniques3` 158/0 · `check-spine` 174/0 · `check-register` 62/0 ·
`check-wbs` 62/0 · `check-status` 94/0 · `check-ledger` grammar-legal, 14 rules,
no violations — L3 extended by the five §2.4 forms (D132), the fixture unchanged · `check-cards` every card byte-identical to its re-derivation ·
`check-layout` **112/0/0** (111 before; the `sources/` row) · `check-exit
--offline` 99/0 · `check-install` 64/0 · `check-budget` 37/0 — the Presale path
still **8 ≤ 8** · `check-auto` 93/0, the floor and the ordering probe both
unchanged. **Zero red, nothing skipped.**

Two rule-5 defects were caught by the suite in this pass's *own* new prose — a
bare `T-01` and a bare `T-18` — and fixed to code + name before the board went
green. The register scan reads compiled text it did not exist to police; that it
caught the compiler is the point of running it last.

### Version — proposed 0.1.14, **stamped 0.1.14**

Proposed as a compiled-surface pass with no new machinery and no installed file
added — the same class as 0.1.12 (the scope frame's rebuild) and 0.1.13 — and
**stamped by the BA Lead in the same sitting**, together with the D132 ruling.
`VERSION` reads **0.1.14**. The full suite was re-run at the stamp, not before
it: **17/17 GREEN**, `check-orchestrator` 198/0, `check-layout` 112/0/0.

This commit and `b11ead2` go to `origin/main` together — Run 2 installs v0.1.14
from GitHub, so the documents pass and its compilation land as one installable
state rather than a half-compiled one.

### Open

*(D132 was this pass's one open question. It was ruled at the stamp and fixed
here; what follows is what remains genuinely open.)*

**`sources/` is still enforced by prose, and now by exactly one absence.**
`layout.expected` asserts the directory absent on a fresh install and refuses to
let a build session claim it — that is a real assertion, and it is the only one.
Nothing reads a capture, nothing checks that a captured artifact is verbatim, and
a capture written to the wrong path still fails no check. The docs pass's own
Open entry stands; the rebuild narrowed it by one row rather than closing it.

**The head line is asserted in three carriers and populated by none.** Every
`Sources:` assertion in this pass reads a *template* or a *render shape*. No
fixture carries a populated line, by D128's own ruling, so the four-state
vocabulary has no worked exhibit in the suite — the same gap the scope frame's
lines had until a fixture earns one. The round-trip was **measured rather than
assumed**: a populated `Sources:` line validates against `check-ledger.py` in all
four states, and the `source` **event** did not until D132 was ruled and fixed
in this pass. Both now validate — against synthetic ledgers built in the suite,
not against a fixture that records a real engagement's sources. That exhibit is
still owed.

## Silent-Zero Parser — field defect, one cycle, Lane B · standard v0.4 · orchestrator v0.18 · elicitation v0.6 · 14 August 2026 · GREEN

The first entry driven by a **field defect report** rather than a ruling package.
A live Presale estate — six drafted specs, `/ba-status` — rendered `drafted 0/6`,
`open markers 0` and `/ba-wbs blocked: no spec carries a User Story yet` against
six specs carrying stories, EARS requirements, NFRs, flows and out-of-scope
sections. `sk_structure.parse_spec` could not read their headings, and **every
consumer inherited the zero and stated it as a fact about the project.**

The sharpest line in the report is a `sk_sections` remedy: `CC-FL-02 FAIL — §4
Flows, States & Errors: section absent → add the section with the main flow and
its error paths` — printed against a spec whose §4 was present. The fix the
checker proposed would have had the BA author a second copy of a section that
already existed.

**Rulings taken by the BA Lead in the planning conversation, applied as stated:**
**R1 = (c)** — reader tolerance *and* writer discipline, tolerance living in
`sk_structure` only · **R2 = (a)** — the line is the only canonical FR form,
`FR_RE` unwidened · and the bug half, which is conformance rather than new
ruling: `parse_spec` must distinguish *absent* from *unrecognised*, and every
consumer must render the distinction.

**Parameters, allocated from the live tree.** HEAD is `3f715d2` (package 0.1.14 ·
orchestrator v0.17 · standard v0.3 · elicitation v0.5). The divergence high-water
mark is **D132** → the contiguous block **D133–D139**. `VERSION` is untouched by
instruction: the stamp is the BA Lead's exclusive act and is **pending**.

**Method.** Documents before code, per the standing order — the three methodology
documents were edited and version-bumped before a line of Python moved. Every
edit ran as an assertion-checked replacement (anchor found exactly once or the
run aborts before writing). The full suite is **17/17 GREEN**, the three
install-based runs included.

### Verification of the report against the live tree

Every cited line and quoted passage was checked before anything was changed. The
report cites the *installed* surface (`.specify/ba/scripts/…`); the line numbers
match this repo's **payload source** exactly, which is itself a useful fact — the
payload compiles byte-for-byte to the install surface.

| Report claim | Live tree | Verdict |
|---|---|---|
| `sk_structure.py:236-247` — splitter stores the heading verbatim | `current = Section(name=m.group(1).strip(), …)` at 242 | ✓ |
| `H2_RE` = `^##\s+(.+?)\s*$` | line 201 | ✓ |
| `STORY_ID_RE` at :207 · `FR_RE` at :210 | exact | ✓ |
| `sk_structure.py:282` returns `None`, `[]` at :284 | exact | ✓ |
| `sk_status.py:350` `"drafted": bool(spec.stories)` | exact | ✓ |
| `sk_status.py:462` markers gated on `if f["drafted"]` | exact | ✓ |
| `sk_status.py:69-74` — the second-copy-is-a-second-drift note | exact | ✓ |
| `.claude/skills/ba-tier2/SKILL.md:107,253` — prose restatement | exact | ✓ |
| spec-template writes the headings unnumbered | `## User Stories` at :26 | ✓ |
| §10.4 *"never estimates a count the sources do not carry"* | **no such string** | ✗ — D133 |

**D133 — the report's §6 quotation is a paraphrase, not a quotation.** §10.4
carries three sentences that do the same work — *every number is a count with a
named source* (¶1) · *a zero denominator renders `—`, never 0%* (§10.4-F) · line
6's *the instrument reports its own blind spots, never papers over them* — and
the apply prompt's own restatement of the law is verbatim-correct. The finding
stands on the real text; **the paraphrase is registered rather than propagated**,
and the §22 review record cites the founding sentence instead.

### Reproduction — the three blockers, stacked

`tests/fixtures/appointment-booking/negatives/neg-shapes.md`: spec r6's content,
unchanged, carrying all three shapes. The report's §2 experiment reproduces its
table row for row:

| Spec text | stories | FRs | NFRs | rules | epic |
|---|---|---|---|---|---|
| as authored | 0 | 0 | 0 | 0 | `''` |
| `## 2. User Stories` → `## User Stories` | 0 | 0 | 2 | 2 | `E-03` |
| … + `**US1 (P1)**` → `US1 (P1)` | **3** | 0 | 2 | 2 | `E-03` |

and `sk_sections` printed the false remedy verbatim.

**A fourth symptom the report did not name: the vacuous PASS.** The same run
produced `CC-BR-02 PASS — 0 unique BR-IDs; 0 reference(s) all resolve` and
`CC-G-04 PASS — 0 banned words in 0 scanned lines (§§2–6)`. That is the identical
silent zero wearing a green verdict instead of a count, and it is arguably worse:
a `drafted 0` invites a question, a PASS closes one. **D137** below.

### The documents pass (before any code)

**Writing standard v0.3 → v0.4.** §2 states outright that the skeleton list's
ordinals are its own numbering and never part of the headings, naming §14's
micro-example as the authority on the literal bytes. The **reader-tolerance
record** is written down as law before being coded — the two normalisations, and
the explicit clause that they make nothing legal. Golden rule 4 gains the R2
boundary: its own enumeration (permissions, fields, states, integrations) is
*sets of values*, and one SHALL is not a set. §4's rule list gains the line-form
rule; §15's self-check gains a shapes-first line.

**Orchestrator v0.17 → v0.18, D-O50, §22.** §10.4 gains the count *u*, excluded
from the drafted numerator **and from its denominator**, which becomes *r* =
readable entered specs; line 3 gains one conditional continuation naming path,
heading found and heading expected, on the auto-trail's *renders only when*
pattern. `/ba.wbs`'s blocked reason must be the true one. The nine numbered lines
keep their numbering; §10.4-F is untouched, because the zero-denominator rule it
already carries is exactly what governs the all-unreadable case.

**Elicitation v0.5 → v0.6, D11, §13.** §5.3 step 2 — the skeleton is emitted from
the template **file**, never from a restatement. New §5.3 step 4 — the shape
pre-flight, four checks, failing loudly at authoring time in found-vs-expected
grammar. §7.2 gains both as build requirements.

**D134 — the reader is deliberately more permissive than the writer.** A numbered
heading is read by `sk_structure` and rejected by the Tier-2 pre-flight. Stated
as intended asymmetry in both documents: tolerance is for specs the framework did
not write, discipline is for the ones it did.

### The code pass

**D135 — CC-G-01 judges the heading as authored, not as normalised.** The ruling
fixes tolerance at the parse and states that the canonical form does not move; it
does not say which side of that line the *assertion* falls on. Taken minimally:
`heading_order` keeps raw headings, `Section` carries both `name` (canonical) and
`raw_name` (as authored), and `check_g01` keys on `raw_name`. Had normalisation
fed CC-G-01, a numbered heading would have passed the gate and the tolerance
would have become the second legal form the ruling forbids. **Verified both
ways:** `neg-shapes` FAILs CC-G-01 with ten form findings; the conforming fixture
still PASSes `10/10 headings, exact names, exact order`.

**D136 — a normalised heading is reported once, as a form error, never also as
absent.** The first cut reported each heading twice — *required heading absent*
**and** *carries the ordinal* — twenty findings for ten headings, and the
"absent" half was the field's own bug reproduced inside the fix. `missing` is now
computed over resolved sections (`spec.section(h) is None`), not over raw names.

**Tolerance, one site.** `HEADING_ORDINAL_RE` and `EMPH_ID_RE` with
`canonical_heading()` and `normalise_line()`, in `sk_structure` and nowhere else,
under a comment naming the file's own no-second-site rule. `FR_RE` is untouched.

**The recognition status.** `Spec.readable` · `Spec.unrecognised` ·
`section_miss()` / `section_miss_fix()` returning the found-vs-expected halves of
a §7 named-gap line · `unparsed_report()` for present-but-unparseable inside a
recognised section.

**D137 — no assertion PASSes on an unreadable spec.** `blocked_on_unreadable()`
downgrades PASS to **SKIPPED**, leaving FAIL alone — a FAIL is usually the
found-vs-expected line naming the real problem, and suppressing it would hide the
diagnosis. This uses the gate's own §5.1 *not evaluated* instrument and invents
nothing. Applied at six emit boundaries.

**The eleven importers, swept.** Five `section absent` sites (`sk_sections` ×3,
`sk_idgraph` ×2) now render found-vs-expected · `sk_ears` CC-FR-01 renders the
shape failure instead of *zero functional requirements* · `sk_acceptance` no
longer claims *no stories* about a spec it could not read · `sk_status` carries
`readable`/`parse_failure` per feature, the *r* denominator in all three render
sites including the HTML one (D-O29's *same counts*), and the true `/ba-wbs`
blocker · `sk_wbs` gives an unreadable spec its own disposition so §10.5's
nothing-silently-dropped rule holds. `sk_brief`, `sk_health`, `sk_scan`,
`sk_snapshot`, `sk_stories` read the estate or route through the swept surface.

### The writer half — and the root cause the report did not reach

The report found that `ba-tier2/SKILL.md` couples writer and reader *by
description*. The live file was worse than that. Its **Output** section rendered
the skeleton as:

```
1. Overview & Value   2. User Stories   3. Functional Requirements
```

under the label *"the ten sections, exact headings, exact order"*. **The skill
was not merely failing to hand over the template — it was displaying the numbered
form as the exact headings.** That is the drift's origin, and it explains why six
specs in one estate all acquired the same habit.

Step 2 now opens by copying `.specify/templates/spec-template.md` and filling it
in place, with *where template and restatement disagree, the template governs*.
The Output block renders the ten headings as `## ` lines, unnumbered, with the
ordinals explicitly disclaimed. New step 4 is the pre-flight, as a four-row
required/never table.

**D138 — the ruling propagates to the mirrors.** `mirror/AGENTS.md` carried the
same numbered skeleton list under *ten sections, exact names, exact order*, and
`mirror/claude-block.md` and `claude/agents/ba-analyst.md` carried golden rule 4
unqualified. All three take the ruling; the prompt named the Tier-2 source, and
leaving the identical list uncorrected in the file every agent reads would have
left the defect's origin in place under a different filename.

### Tests

**Two fixtures.** `neg-shapes.md` — the two tolerated habits plus table FRs.
`neg-alien.md` — headings no tolerance reaches, the *unrecognised* case. Both
join `check-m.sh`'s `spec_case` sweep with recorded verdict tables (20 verdicts
each), and the tables are themselves the assertion:

- **neg-shapes** — content found (`CC-US-*`, `CC-AC-01`, `CC-FL-02`, `CC-NF-02`,
  `CC-OS-01`, `CC-BR-02` all PASS), `CC-G-01` FAIL on the form, `CC-FR-01` FAIL
  on the table rows.
- **neg-alien** — **not one PASS**: every assertion FAILs with found-vs-expected
  or is SKIPPED behind CC-G-01.

**Eleven message-level assertions** in `check-m.sh` — the verdict tables pin
*which* verdicts fire, but the defect was never a wrong verdict; it was a
true-sounding sentence. So the suite pins the sentences: the tolerances read
through · `FR_RE` unwidened · the zero is loud · CC-G-01 still fails a numbered
heading · **and never also reports it absent** · found-vs-expected printed ·
`section absent` never printed when headings went unrecognised · no vacuous PASS
· `CC-G-04` never passes having scanned nothing.

**Nine assertions** in `check-status.sh`: the unreadable spec named by path with
found-vs-expected · `drafted 1/1` not `1/2` · with every spec unreadable
`drafted —`, never `0/0` and never 0% · both failures named · `/ba-wbs` naming
the parse failure · **and never** *no spec carries a User Story yet*.

**Suite pins moved with the ruling:** `check-orchestrator.sh` pinned the live
edition at v0.17 and the D-O block at 1…49; both now read v0.18 and 1…50.

**Result: 17/17 GREEN**, the three install-based runs included. `check-m` 53/0
(was 40/0) · `check-status` 103/0 (was 94/0) · `check-orchestrator` 199/0 ·
`check-layout` 112/0/0 · `check-exit` 99/0. Coverage held: 24 of 24 M assertions
still exercised both ways.

### Version — proposed 0.1.15, **not stamped**

A compiled-surface pass plus a parser change and two new fixtures; no installed
file added, no new machinery, no new BA step. **`VERSION` is untouched by
instruction** — the stamp is the BA Lead's exclusive act and is pending. The
suite was run to green *before* the stamp, so the stamp costs one command.

### Open

**D139 — the vacuous PASS survives on a *readable* spec whose section is
unparseable.** `neg-shapes` still yields `CC-FR-02 PASS — 0/0 FRs carry exactly
one SHALL` and `CC-FR-05 PASS — 0 FRs`. `blocked_on_unreadable` does not fire,
because the spec *is* readable — only its §3 is not. The gate verdict is
nonetheless correct (CC-FR-01 is non-waivable and FAILs), so nothing certifies on
a vacuous pass; but the render still shows two greens next to a red about the
same section. **Carried, not fixed** — the general rule (an assertion whose
denominator is zero because its source did not parse renders SKIPPED, not PASS)
is a ruling, not a conformance fix, and it touches assertions the field report
did not reach.

**The estate's own remediation is out of scope by instruction** (step 8) and
untouched from here: its table FRs still need converting to line form, and its
sixth story's `STORY_RE` failure — 5 of 6 well-formed after both prefixes are
stripped — is very likely a real spec defect rather than a parser one.

**The pre-flight is prose, and nothing executes it.** It is a compiled
instruction in `ba-tier2/SKILL.md`, held down by the register suite as text, not
by a checker that runs it. A `sk_preflight` reading the four shapes off the
standard would close that, and would also give the Tier-2 skill a mechanical exit
condition it currently lacks. Not ruled, not built.

## Silent-Zero Parser II — the vacuous PASS at section grain, one cycle, Lane B · gate v0.7 · 14 August 2026 · GREEN

The second cycle of the same field defect, and the shortest kind of entry: one
open divergence, one ruling, one paragraph of law, one helper, six assertions.

The previous entry closed carrying **D139** — the vacuous PASS survives on a
*readable* spec whose section is unparseable. `neg-shapes` still rendered
`CC-FR-02 PASS — 0/0 FRs carry exactly one SHALL` and `CC-FR-05 PASS — 0 FRs`
in green, beside `CC-FR-01 FAIL — §3 …: section present, no parseable FR lines`
in red, about the same section. `blocked_on_unreadable` could not fire: the spec
*is* readable — only its §3 is not.

**Ruling taken by the BA Lead, applied as stated: R3 = (a)** — D139 closes by
extending D137's law to section grain. On a readable spec where a section is
present but unparseable, every assertion scoped to that section's parsed objects
that would PASS vacuously (0/0) renders **SKIPPED** instead. FAILs are never
touched. Same instrument as D137 — the gate's §5.1 SKIPPED; nothing new invented.

**Parameters.** HEAD is `761ab4d` (package 0.1.14 · gate v0.6 · standard v0.4 ·
orchestrator v0.18 · elicitation v0.6), pushed to origin at the head of this pass
— the previous cycle's commit had never left the machine. The divergence
high-water mark is **D139** → the contiguous block **D140–D143**. `VERSION` is
untouched by instruction: the stamp is the BA Lead's exclusive act and remains
**pending** for 0.1.15, which now carries both cycles.

### The document pass (before any code)

**Gate definition v0.6 → v0.7, §5.1.** One additive paragraph — *a zero the
reader produced is not a count* — stating the rule **once**, at both grains:

> **A zero the reader produced is not a count — SKIPPED, at either grain.** A
> PASS's terse evidence is the whole of its support, so `0/0 FRs carry exactly
> one SHALL` supports nothing: an M assertion whose count is zero **because its
> source did not parse** renders `SKIPPED`, never PASS. Two grains, one rule.
> **Spec grain:** no `##` heading resolved to one of the ten standard names, so
> nothing in the document could be read → every PASS in the run becomes
> `SKIPPED — blocked by CC-G-01`. **Section grain:** the document reads, but a
> section is *present and carries lines of its class that did not parse* (a §3
> written as table rows is the field case) → every assertion counting that
> section's parsed objects at zero becomes SKIPPED, blocked by that section's
> parse gap stated in found-vs-expected grammar — led by the `CC-<ID>` that
> fails on the shape where the M set carries one (CC-FR-01 for §3, CC-US-01 for
> §2), and by the gap line alone where it does not (§6 Business Rules). **FAIL
> is never touched:** a FAIL is normally the very line naming the parse gap, and
> suppressing it would hide the diagnosis. A section that is present, read and
> **genuinely empty** is not this case — that zero is a measurement and it
> stands. Skips carry their §4.1 consequence unchanged: the run cannot PASS,
> §6.1 forcing FAIL on any skip whether or not a sibling assertion also failed.

**D140 — the spec-grain half is ratified as built, and says so.** D137 shipped
the behavior in the previous cycle; its law is written here, one cycle later, in
the same paragraph as the new half. Recording the pattern rather than hiding it:
the document states the rule at both grains as one rule, and the change record
names which half is new and which is ratification. The alternative — writing
only the section half and leaving D137's behavior standing on a build-log entry
— would leave the runtime carrying an unlegislated downgrade at the grain the
gate is most often run at. The footer's dependency line was refreshed in the same
bump (writing standard v0.3 → v0.4, elicitation v0.4 → v0.6; both went stale in
the previous cycle, which did not touch this document).

**D141 — the section-grain blocker is a parse gap, not always an assertion ID.**
§4.1's grammar is `SKIPPED — blocked by CC-<ID>`, and at spec grain D137 could
satisfy it exactly: CC-G-01 is right there, failing. At section grain the M set
carries an assertion that fails on the shape for §3 (CC-FR-01) and §2 (CC-US-01)
— and **none for §6 Business Rules**: CC-BR-02 is the only M assertion over §6,
and it is the one skipping. Under-determined by the ruling, taken minimally: the
blocker is the section's own parse gap in found-vs-expected grammar, led by the
`CC-<ID>` where one exists. Two consequences registered rather than left to be
discovered: §4.1's *the blocker is among the failures* gains a five-word
exception pointer, and §6.1's *any SKIPPED element forces FAIL regardless* is
sharpened to say that *regardless* is the operative word — that rule, not the
presence of a sibling FAIL, is what keeps such a run off PASS. The two
alternatives were both worse: naming CC-G-01 at section grain is a false
attribution (CC-G-01 PASSes there), and authoring a new assertion to fail on an
unparseable §6 is exactly the *invent nothing new* the ruling forbids.

### The code pass

**One helper, beside D137's, in `sk_structure` and nowhere else.**
`blocked_on_unparsed(spec, verdicts, scopes)` downgrades a PASS whose count is
zero because its section did not parse; `unparsed_blocker()` builds the blocker
line; `SECTION_CLASS` maps the four ID-bearing sections to their kind, the `Spec`
field the checkers count, and the assertion that fails on the shape.

**The signal was already there.** The ruling allowed adding a present-but-
unparseable signal in `sk_structure` where one was missing. None was: D137's
`unparsed_report()` is already keyed by ID class over `FR` · `BR` · `NFR` · `US`,
and it is *exactly* the predicate this rule needs — it returns `""` for a section
that is absent, that parsed something, **or that is genuinely empty**. So the
downgrade reuses it verbatim and the single-signal-site rule stands untouched.
That last case is the rule's own boundary and it fell out for free: a section the
reader read and found empty keeps its zero, because that zero is a measurement.

**D142 — the sweep's criterion: counts over *parsed objects*, not counts over
raw lines.** All 21 Scope-F M assertions were read against the 0/0 shape. In
scope, seven — **CC-US-02 · CC-US-03 · CC-US-04** (§2) · **CC-FR-02 · CC-FR-05**
(§3) · **CC-BR-02** (§6) · **CC-TR-01** (§2 + §3, the only two-section scope).
Out of scope, and why, so the next sweep does not re-derive it:

| Assertion | Reads | Its zero |
|---|---|---|
| CC-US-01 · CC-AC-01 · CC-FR-01 | parsed objects | already a **FAIL** — nothing to downgrade |
| CC-FL-02 · CC-NF-02 · CC-OS-01 | the section's **raw lines** | a FAIL; CC-NF-02 even reads table rows as a legal form |
| CC-G-01 · CC-G-03 · CC-G-04 · CC-XA-02 | headings and raw lines, document-wide | a measurement — a table-form §3's lines *are* scanned |
| CC-TR-02 · CC-TR-03 | §10's raw lines | CC-TR-02 FAILs; CC-TR-03's `0 declared = 0 used` is a real spec property |
| CC-TR-04 | the generated graph | already a FAIL on an empty graph |
| CC-XA-05 | the brief + its slicing row | not section-scoped at all |

No M assertion counts `spec.nfrs` at all, so the **CC-NF-\*** row of the sweep is
empty by construction rather than by judgement — worth stating, since the ruling
named it explicitly.

**D143 — CC-TR-01 takes the downgrade where it is computed, not only where it is
emitted.** Its verdict is read twice: once into the verdict set, and once into
the generated `traceability.md` as `Orphan check: none (CC-TR-01 PASS, run n)`.
Applying the downgrade only at the emit boundary would have skipped the verdict
and still written the PASS sentence into a second file — the same true-sounding
sentence the whole defect is made of. Both downgrades now run at the point of
computation, and the render gained a third branch: `not evaluated — CC-TR-01
blocked by <blocker>`. **This closed a spec-grain leak D137 left standing** — on
an unreadable spec the candidate previously read `Orphan check: none (CC-TR-01
PASS, run 1)` while the verdict set said SKIPPED. Found by extending the rule,
not by looking for it.

### Tests

**The D139 fixture renders as the ruling specified.** `neg-shapes` — readable,
table-form §3 — now gives `CC-FR-01 FAIL` + `CC-FR-02 SKIPPED` + `CC-FR-05
SKIPPED`, each skip naming CC-FR-01 and the five table rows it counted.

**One verdict table moved, and only where the class legitimately changed.**
`neg-shapes.expect`: `CC-FR-02|PASS → SKIPPED`, `CC-FR-05|PASS → SKIPPED`. Two
lines of twenty; the other eighteen are byte-identical, and no other case's table
moved at all — `neg-alien`'s four SKIPPEDs were already there under D137. The
table was edited line-by-line rather than re-recorded wholesale, so the diff is
the assertion.

**Six new assertions in `check-m.sh`**, continuing the previous cycle's rule that
the suite pins the *sentences*, not only the verdicts: CC-FR-02/05 SKIP on a
readable spec whose §3 did not parse · the skip names its blocker (`CC-FR-01` +
the found-vs-expected line) · neither ever renders a count it did not measure ·
the generated `traceability.md` never records a PASS the verdict set skipped
(D143) · a present, read and genuinely empty section keeps its zero (the
measurement boundary) · and the §6 case renders the gap line as its own blocker
(D141). The last two build their two-line specs in `$TMP` and read
`unparsed_blocker` directly — the boundary is a property of the predicate, and
pinning it at the predicate is cheaper than a fixture pair.

**Coverage held at 24 of 24** M assertions exercised both ways: CC-FR-02 and
CC-FR-05 lost their `neg-shapes` PASS and keep it in eight and seven other cases
respectively.

**Result: 17/17 GREEN**, the three install-based runs included. `check-m` 59/0
(was 53/0 — the six new assertions, no other movement) · `check-gate` 59/0 ·
`check-orchestrator` 199/0 · `check-status` 103/0 · `check-layout` 112/0/0 ·
`check-exit` 99/0 · `check-install` 64/0 · `check-budget` 37/0 · `check-auto`
93/0. The four the previous entry recorded — orchestrator, status, layout, exit
— stand on their previous counts exactly.

### Version — 0.1.15 proposed for both cycles, **not stamped**

Unchanged from the previous entry's proposal: no installed file added, no new
machinery, no new BA step. One methodology document bumped (gate v0.6 → v0.7),
one parse-surface downgrade (two functions and a section map), four checker call
sites, one fixture verdict table.
**`VERSION` is untouched by instruction.** Both cycles now sit on origin.

### Open

**Nothing from D139 remains.** The vacuous PASS is closed at both grains.

**The A pass is not swept.** This rule is an M-checker output rule and lives in
§5.1; `ba-gate.md`'s SKIPPED bullet governs the A pass at element granularity and
carries no text this ruling contradicts, so it was checked and left alone — the
D138 propagation test does not fire where the mirrors carry different text. But
an A checker judging CC-FR-03 over a §3 that parsed nothing has the same shape,
and nothing yet stops it returning a PASS. **Not ruled, not built** — it needs
the agent's own instruction to change, which is a ruling.

**The carried items of the previous cycle stand unchanged:** the estate's own
remediation is out of scope by instruction, and the Tier-2 pre-flight is still
prose that nothing executes.

## Ratification & stamp — the two silent-zero cycles, package 0.1.15 · 14 August 2026 · GREEN

The BA Lead's stamp pass over the two entries above. No document edited, no code
edited, no test edited: the ratification is an act, and this section is its
record.

### The ratification — one act, 14 August 2026

**D133–D143 · EK-ratified 14 Aug 2026** — the whole silent-zero block, both
cycles, in one act: the reader tolerance at one site (D133–D136), the blind spot
named at spec grain (D137–D138), D139 raised and closed (D139–D141), and the
sweep and its two consequences (D142–D143). Nothing in the block stands open.

**D-O50 · EK-ratified 14 Aug 2026** — orchestrator v0.18's §22, the unreadable
spec on the dashboard: the count *u*, its exclusion from both the drafted
numerator and its denominator, and `/ba.wbs`'s true blocked reason.

**D11 · EK-ratified 14 Aug 2026** — elicitation v0.6's §13, the writer/reader
coupling: the skeleton emitted from the template **file** and the §5.3 step-4
shape pre-flight.

The three carriers stand as built and as registered: **standard v0.4 ·
orchestrator v0.18 · elicitation v0.6 · gate v0.7**.

### R4 = (a) — ruled 14 August 2026, scheduled, not built

**The A pass takes §5.1's rule by reference.** The previous entry's Open section
named the gap — an A checker judging CC-FR-03 over a §3 that parsed nothing has
the same shape as the M checkers did, and nothing stops it returning a PASS. The
BA Lead rules **(a)**: §5.1's SKIPPED-on-unsupported-parse rule extends to the A
pass **by reference to §5.1, never by restatement**. The agent surface cites the
rule; it does not carry a second copy of it, and a second copy is a second thing
to drift — the same principle the parse layer's single-signal-site rule states.

**Scheduled as the next cycle. Not built in this pass** — this pass is the stamp,
and the ruling is registered here so the next cycle opens against registered text
rather than against a recollection. The A-pass gap therefore moves out of *Open*
and into *ruled, pending build*.

### The stamp — 0.1.15

`VERSION` 0.1.14 → **0.1.15**, covering both cycles as both entries proposed.

**The release path is a manual convention, not a script.** There is no Makefile
and no release target: a package commit is the compile work plus the `VERSION`
write in one commit whose subject reads `package <version> — <disposition>`
(`3f715d2` is the pattern). Nothing in the repository is regenerated by the bump
— **no payload artifact carries the version**. `VERSION` is read at *install*
time (`install.sh:28`) and stamped into the generated `.specify/ba/manifest.md`;
`verify-manifest.py`, `check-exit.sh` and `check-install.sh` then assert that the
manifest's version equals `VERSION`. So the bump propagates only through a fresh
install, and the three install-based runs are what prove it.

**D144 — this stamp commit carries no compile work, and that is a departure from
the pattern it follows.** `3f715d2` carried the compile *and* the stamp together;
here the two cycles' payload work already landed at `761ab4d` and `43b46e6`, both
pushed, so the stamp commit is `VERSION` + this section and nothing else. The
alternative — folding the stamp back into the code commits — would have required
rewriting two commits already on origin. Registered rather than smoothed over:
the diff is `VERSION` and `BUILD-LOG.md`, and a reader comparing this commit to
`3f715d2` should not read the absent payload diff as an omission.

**Suite 17/17 GREEN at the stamp**, the three install-based runs included —
re-run after the write, so the version the manifest checks assert is 0.1.15.


## Continuity Under a Grant — the AG's only stop is a band boundary, Lane B · orchestrator v0.19 · 14 August 2026 · GREEN

The field defect, reported 13 August 2026: an auto run under a standing AG
**halted after every aspect**. Nothing in the machinery had failed. §10.7's
policy table was obeyed row by row, every act was taken AUTO, every stamp
landed, and the grant was never violated. What the run then did was render a
narrative summary of the aspect to the BA — and **a conversational render ends
the agent's turn**. The summary was therefore a stop, and a grant whose entire
purpose is to remove stops was delivering one per aspect. The BA had granted
autonomy and was still pressing a key ten times a band.

Ruled by Eugene K., 14 August 2026, option **(a)**: under a standing AG the only
stop is a band boundary.

### The gate, and the renumber it forced

The ruling package was written against **VERSION 0.1.14 / orchestrator v0.17**
and allocated **D-O50** and **D-O51**. The tree at `2b2cb8c` read **0.1.15 /
v0.18**, and **D-O50 was already taken and EK-ratified** — the unreadable spec on
the dashboard (§22), cited at nine sites including four payload scripts. §22 was
taken in step. The gate the package specified was run first and **stopped the
build before any write**.

**D145 — the package's numbering was stale by one cycle, and the shift went to
the incoming package, not the shipped one.** Re-ruled by Eugene K. the same day:
continuity = **D-O51**, band-boundary report = **D-O52**, review record = **§23**,
header = **v0.19**. Renumbering the incoming package moves **no existing
citation**; renumbering the shipped D-O50 would have rewritten EK-ratified text
plus `sk_structure.py`, `sk_status.py` (three sites) and `sk_wbs.py` to make room.
The cheap direction was also the correct one. Recorded because a reader comparing
the ruling package to the landed sections will find two different numbers for the
same rule.

**R4 carries again.** The stamp entry above scheduled the gate's A-pass item
(§5.1's SKIPPED-on-unsupported-parse rule extended **by reference**) for "the next
cycle". This cycle is orchestrator-side and does not touch it; per Eugene's
ruling of 14 August 2026 it **carries to the next cycle**, still ruled and still
unbuilt.

### The documents (before any payload)

**§10.7** gains two blocks after the policy table's apparatus — placed *after*
the safety-floor paragraph and the AUTO stamp grammar rather than immediately
after the table, because the continuity rule names the floor as stop event 2 and
the boundary report uses the stamp grammar: both would forward-reference from the
earlier slot.

**Continuity under a grant (D-O51)** — no conversational render between acts, the
turn never ended inside a band, every record to the ledger and the auto-trail,
and the run continuous until exactly one of four events: a band boundary · a
safety-floor stop · exhaustion of the grant's scope · `off`.

**The band-boundary report (D-O52)** — the pinned four-line shape, rendered after
the P-O7/P-O8 stamp, the turn ended, the AG left standing.

**§10.3 rule 8** gains the list entry and one clause — the smallest legal
placement, no rule renumbered. **§23** carries both rows and the conflict scan.
Header → **v0.19** with its change record; the footer gains the v0.19 entry,
`D-O1–D-O52`, and `v0.18→v0.19 in §23`.

**Conflict scan — contract v0.2 · gate v0.7 · elicitation v0.6 · standard v0.4:
none found, nothing changed in any of them.** The gate is the only sibling that
legislates under a grant (§7.1's AUTO-waiver paragraph) and it **already
addresses the report entry, not the conversation** — D-O51's rule reached
independently, one document earlier. The contract names no render. The standard
owns artifact text and elicitation owns stakeholder-facing questions; by §10.3's
own division of the three registers neither reaches BA-facing conversation.

### The payload — 40 files, 49 substitutions, exactly-once throughout

Every substitution asserted `str.count(old) == 1` before writing, with a residual
grep sweep after. Three scripted passes: the skills and personas, the two mirror
compile targets, and the register-rule-5 repair below.

**D146 — the sweep's file set was wider than the brief's.** The brief named
`payload/claude/skills/*.md` and `ba-orchestrator.md`. Both **mirror compile
targets** — `payload/mirror/claude-block.md` and `payload/mirror/AGENTS.md` —
carry register rule 8, the register self-check *and* the resumption report's
pinned shape, and a `payload/claude/**` glob does not reach them. Mirroring the
clause everywhere except the two files that compile into `CLAUDE.md` and
`AGENTS.md` would have left the rule absent from the surface every session reads
first. Both extended.

**D147 — the two band-boundary skills were entirely AG-blind, and that is where
the defect actually lived.** `ba-close-band1` (P-O7) and `ba-enter-feature`
(P-O8) contained **zero** occurrences of `AUTO`, `grant` or `AG-` before this
cycle. Nothing at either boundary knew a grant could be standing, so nothing knew
to render a boundary report — the run reached P-O7 with no instruction but its
ordinary manual-mode renders. Both gained the pinned shape and the continuity
clause. This is the difference between mirroring a rule and landing it: the
`ba-auto` skill alone would have documented a report that no skill ever fired.

**D148 — the register clause was applied uniformly to all 38 carriers of the
shared self-check block, not selectively.** The block is byte-identical across
all 38 (verified by hash before the write) — it is **one compile target already
duplicated by design**, not 38 independent copies. Extending it uniformly is one
string; extending it selectively creates two variants of a compiled block, which
is the drift the R4 ruling of this same day named — *a second copy is a second
thing to drift*. The clause itself is by-reference: it states where renders are
addressed and points at `/ba-auto`, and does not restate the four stop events.

**D149 — `/ba-auto` and `/ba.auto` are both live in the corpus, and the ruled
pinned shape uses the hyphen.** §10.7's prose and heading use `/ba.auto`; §4.4's
AG record, every payload skill and the ruled band-boundary shape use `/ba-auto`.
The shape was landed **verbatim as ruled** — a pinned shape is not the place to
silently normalise a command name, and the payload is hyphen-consistent already,
so the shape matches the surface that renders it. Flagged, not fixed: the split
predates this cycle and normalising it is a corpus-wide act needing its own
ruling.

### Tests

`check-auto.sh` gains **section 4b** on its existing pattern — the §10.7 block is
*extracted from the document*, never pinned in the suite, so a reworded document
goes red instead of drifting past. Its shape extractor was parameterised by block
head (`argv[3]`, defaulting to the resumption report) rather than duplicated.

**49 new checks:** the continuity rule joined across four carriers · the
four-event clause · the render-not-a-ratification-point clause · the never-does
turn rule · the boundary shape extracted from §10.7 and byte-compared into **five**
renderers · six vacuity probes on the source block · a control that reworks one
line and must go red · rule 8's list on four surfaces · the register clause on
seven. **93 → 142 checks in the file.**

**D150 — three `check-orchestrator.sh` assertions were pinned to the pre-package
state and had to move with it.** Rule 8's list was asserted as one contiguous
string (`WBS export §10.5, route render §10.6, resumption report §10.7`) that the
new entry splits; the header check pinned `v0.18`; the D-O contiguity check
pinned `range(1, 51)`. All three updated, and the list assertion **split into
two** — the WBS/route pair, then both §10.7 renders with the boundary report
ahead of the resumption report — so the ordering the register now fixes is itself
asserted rather than incidentally spanned. A new `D-O51–D-O52` block assertion
joins the per-edition series. **196 → 201 checks.**

**Register rule 5 caught eight defects in this cycle's own prose.** The first
payload draft rendered `P-O7` and `P-O8` bare at five sites; `check-register.sh`
failed them and its four seeded controls could not be read past the real hits.
Repaired to `P-O7 — Band-1 closure` / `P-O8 — Band-3 entry` and re-run clean. The
pinned shape's own `P-O7 Band-1 closure | P-O8 Band-3 entry` is inside a fence
and correctly exempt.

**Suite 17/17 GREEN**, the three install-based runs included.

### Version — not stamped

`VERSION` stays **0.1.15**. The stamp is Eugene's separate act, as instructed.

### Open

Nothing in this block stands open. **D-O51–D-O52 await ratification.** Two items
carry: **R4** (the gate's A-pass §5.1-by-reference rule, ruled 14 Aug 2026, still
unbuilt) and **D149** (the `/ba-auto` · `/ba.auto` split, flagged this cycle,
needing a corpus-wide ruling of its own).


## Command-surface hygiene — one spelling, `/ba-`, Lane B · 14 August 2026 · GREEN

D149, raised in the entry above and ruled the same day by Eugene K.: **the
canonical form is the hyphen — `/ba-auto`.** It is the executable surface; the
dot notation is legacy doc spelling and never runs. A corpus that prints
`/ba.status` to a BA prints a command that does nothing.

No document ruling, no decision number, no version bump: this is a spelling
sweep over text that was already wrong the moment Phase 2 renamed the namespace
(D-P2-1). `VERSION` untouched at 0.1.15.

### The hit set, before any substitution

`grep -rn "/ba\."` over `docs/`, `payload/`, `tests/`, `README.md`, `install.sh`,
`bootstrap.sh`, `diagnostics/` and `vendor/` — **BUILD-LOG.md excluded by ruling,
history stays as written.**

**66 matching lines, 76 occurrences.** By form: `/ba.run` 31 · `/ba.wbs` 11 ·
`/ba.status` 9 · `/ba.auto` 9 · `/ba.gate-health` 2 · `/ba.*` 2 · and one each of
`/ba.frame`, `/ba.aspect`, `/ba.clear`, `/ba.gate`, `/ba.handoff`, `/ba.reopen`,
`/ba.waive-aspect`, `/ba.close-band1`, `/ba.enter-feature`, `/ba.t<NN>`,
`/ba.tier1`, `/ba.tier2`.

**The payload was already clean — zero hits.** Every skill, persona and mirror
has spelled the command with a hyphen since Phase 2. The split lived entirely in
the methodology documents, which is why it survived: no test reads a command name
out of a document except one, and that one asserted the dot form on both sides.

### The sweep — 74 substitutions, 10 files

Regex `/ba\.([a-z][a-z0-9-]*)` → `/ba-\1`, per file, with three assertions each:
a **glob guard** refusing any file containing `/ba.*`, a residual count of **0**
dot forms after, and a hyphen count equal to *before + n*. Orchestrator rules 51 ·
catalogue-b2 4 · catalogues b1/b3/b4/b5 and the gate 3 each · catalogue-b6 2 ·
wave2 sequencing 1 · `check-budget.sh` 1. Residual sweep after: **zero dot forms
outside BUILD-LOG.md and the one held file.**

`tests/check-budget.sh:279` asserted a document string carrying `/ba.run specs
all`. It sits in `tests/`, so it swept in the same pass and stayed in sync with
the line it checks — the assertion never went red, which is the only reason the
suite did not catch this split years earlier. Recorded as the reason, not as luck.

**D151 — two `/ba.*` occurrences are namespace globs, not commands, and are held
unswept.** Both are in `ba-native-spec-phase2-build-plan.md` — line 23 and
D-P2-1's row at line 318 — and both *name the dotted namespace as a category* in
order to retire it: *"the corpus's dotted `/ba.*` names are illegal as skill
names … adopt hyphenated `ba-*`"*. Substituting them yields *"the corpus's dotted
`/ba-*` names are illegal … adopt hyphenated `ba-*`"* — a sentence that
contradicts itself and destroys the provenance of the very ruling this sweep
applies. The file is held whole; the rest of the corpus is swept. **D-P2-1's
mapping table was never in scope:** its pairs are written without a leading slash
(`ba.gate → ba-gate`), so a `/ba\.` sweep cannot reach them — verified after the
run, not assumed.

**D151 · closed as HELD — ruled by Eugene K., 14 August 2026.** The two `/ba.*`
namespace globs stay **as written**: they are the **provenance record of the
rename itself**, and the principle is the one that excluded BUILD-LOG.md from
this sweep — a record of how the corpus came to spell something is not a surface
that spelling applies to. Closed, not deferred: no future cycle should re-open
these two lines looking for a dot form to fix.

**One consequence noted, not acted on.** §11's and the gate §13's binding tables
carry the caption *"names indicative — Phase 2 fixes them"*, and their rows now
show the fixed names. The caption is stale in the sense that the fixing has
happened, but it is also the clause D-P2-1 cites as its own pre-authorization.
Left as written — retiring it is a document act, not a spelling sweep.

### The hygiene backlog — document acts, deliberately not this sweep's tail

Ruled by Eugene K., 14 August 2026: the stale caption becomes **its own item,
beside D82**, and not a clause appended to a spelling pass. The backlog gets a
named home here because it had none — carry items had been living inside the
entries that raised them, which is why D82 has been readable but not findable.

**D152 · the "names indicative — Phase 2 fixes them" caption is stale.**
Orchestrator §11's Phase-2 binding table and gate §13's equivalent both carry it,
and both now show the **fixed** names — the caption describes a future that has
already happened. Retiring it is not a deletion: D-P2-1 cites that exact clause as
its own pre-authorization (*"Both binding tables pre-authorize this"*), so the
caption has to be **re-worded to the past** rather than removed, in both tables,
in one act, with D-P2-1's citation still landing. A document act for a future
cycle. **Not urgent and not a defect:** every row under the caption is correct as
it stands; only the caption's tense is wrong.

**D82 · the t17 section-close placement** (raised at the technique-skill batch,
still live). For t17 the pass/miss pair sits **after** the skip-if rather than
before it. The alternative reading — *close the contract-check block, ahead of the
skip-if* — is a four-file move. Unchanged by this cycle, restated here so the two
items sit in one place.

Both are **document acts**: no code, no test, no threshold, no decision content —
only text that says something slightly other than what it now means.

### Tests

**Suite 17/17 GREEN**, the three install-based runs included. No assertion needed
repair: the only test pinned to a dot string swept with the corpus.

### Open

**Nothing from this cycle stands open.** **D149 closed** — one spelling, `/ba-`,
everywhere a BA can read one. **D151 closed as HELD** — the two namespace globs
stay as written, ruled 14 Aug 2026. **D152 and D82** sit in the hygiene backlog
above as document acts for a future cycle; neither is a defect. **R4** still
carries — the gate's A-pass §5.1-by-reference rule, ruled 14 Aug 2026, still
unbuilt.


## Slack Candidate Scan at Frame — the framework proposes, the BA disposes, Lane B · orchestrator v0.20 · package 0.1.16 · 15 August 2026 · GREEN

F-05. The field test, 14 August 2026: the BA Lead observed that the Slack MCP
**resolves the relevant project channel by name** — the framework could have
found the Run-1 channel itself, and did not. §21 built an inventory that closed
the hole where the framework never wondered what stood beyond the material on
hand; it left open the one where **the BA does not think to name** a channel the
framework could have named for them. The ruling package (BA Lead, 14 Aug 2026;
R1-a · R2-c · R3-c · R4-b, all final) closes it: **the framework proposes
candidates, the BA disposes.**

Documents-first, then the rebuild, in the ordered form the package specified.

### The divergence found before a byte was written — the decision number is taken

**D153 — the package names `D-O50` and `§21`; both are occupied.** The package
was written against **orchestrator v0.17**, and two bumps have landed since:
**D-O50** is the unreadable spec (v0.18, §22, 14 Aug) and **D-O51–D-O52** are
continuity under a grant (v0.19, §23, 14 Aug); **§21** is the v0.16→v0.17 record
that ruled the source inventory itself. Reusing a locked number, or writing a
second decision into a closed review record, would put two rulings on one
citation — the collision v0.12's change record had to rebase around, and the
reason the contiguity assertion exists at all. **Registered as D-O53 in a new
§24 (v0.19 → v0.20).** No ruling content changed; every clause of R1-a/R2-c/
R3-c/R4-b applies verbatim, and the package's stated origin line rides D-O53's
change record unaltered.

### The clause set — one decision, one section

**D-O53, §8.1 + §11 + §24.** Four ruled parts, applied as stated:

- **R1-a — reachability alone is the trigger.** The scan runs whenever the Slack
  integration is reachable at Frame — the runtime fact D-O46 already reads — with
  **no opt-in and no condition on whether the BA named a Slack source**. An
  opt-in would ask the BA to know what the inventory exists to discover.
  **Slack unreachable is zero delta:** the block renders exactly as before, and
  nothing is said about a scan that did not run.
- **R2-c — the project name is the only key**, as it stands in the material on
  hand. No client name (it returns every engagement with that client), no domain
  terms (they return the workspace).
- **R3-c — one candidate, never a list.** Exactly one best-match channel, plus
  `and <N> more matched — name them to see` where others matched.
- **R4-b — a declined candidate enters no ledger entry.** The `Sources:` line
  records **BA-named and BA-confirmed sources only**. A confirmed candidate stops
  being a candidate and inherits **D-O45–D-O49 unchanged**: verbatim capture to
  `sources/slack-<channel>-<date>.md`, cite-or-mark mining, the head entry with
  its state, the dispositions, the conditional correction stop.

**The placement law held without strain, and the budget is arithmetically
untouched.** The two candidate lines ride **inside** D-O45's pinned first block,
on §10.4's own `(renders only when …)` convention (D-O38 · D-O50) — one render,
one BA reply, **no new prompt point, no new P-O, no new pinned format**. §10.3
rule 8's list is untouched: the source inventory is already on it, and a shape
that gains two conditional lines is the same pinned shape. **D-O33's ≤ 8 with its
7 + 1 slack stands** — no stop is added, and the correction stop a confirmed
capture may fire is D-O49's, already ruled and already budgeted. **No conflict to
report, so none is reported:** the STOP condition the package set never fired.

### Three consequences the package did not state, stated here rather than assumed

**D154 — the scan resolves names, never content.** It reads what channels are
*called*; it reads **no message** until the BA confirms, and then under D-O46
unchanged. The alternative — reading a matched channel to rank it better — would
capture client material the BA never named, which is the inventory's own
discipline inverted.

**D155 — a candidate the reply does not answer is declined, and D-O46 is not
weakened.** R4-b rules that a decline records nothing; it does not say what an
unanswered candidate is. It is a decline. D-O46's *silence never resolves a
source* stands untouched because it governs a source **the BA named** — letting
the framework's own proposal age into `named — pending` would have the framework
manufacturing the very state that rule exists to prevent. Both halves are stated
in §8.1 and in D-O53, because a boundary between two silence rules that is not
written down is a boundary that drifts.

**D156 — no project name on hand → no key and no scan.** R2-c fixes the key set
and is silent on the empty case. A scan needs a key; a guessed key is a guess,
and cite-or-mark forbids one (doc 3, principle 3). The block renders as before.

### The versioning discipline — registered where versioning discipline lives

**D157.** The package rules that **patch bumps are automatic** — every build pass
increments `VERSION` itself and records it — while **minor and major stamps are
the BA Lead's act, taken at his own initiative, never prompted for.**

**Its home is the BUILD-LOG conventions header, not the orchestrator.** The
package offered either. Versioning discipline already lives here — but only as
recurring per-entry prose (*"version stamping is the BA Lead's act"*: entries at
the 0.1.9 bootstrap pair, the two silent-zero cycles, the gate cycle, the hygiene
sweep), never as a stated convention anyone could cite. The orchestrator's house
rules are §1's three runtime rules over BA machinery; it carries no package
version surface at all, and putting a package convention there would give a
methodology document a Phase-2 concern it has never had.

**Older entries stand exactly as written.** They state the earlier convention —
patch included — and this log is append-only: a record true when written is
amended by a later ruling **on the record**, never by rewriting it. The new
section says so in its own text, so a reader meeting the old sentences knows to
read them against it rather than around it. The D-O51–D-O52 pattern, applied to
a convention instead of a decision.

### Catalogue-b1 (T-01) — checked, and no companion line proposed

**No.** D-B1-6 already fences exactly this ground, in the words the ruling would
otherwise restate: *the inventory is Frame-act ground and never this run's — T-01
neither names a source nor rules a disposition, and asks nothing.* A candidate is
proposed by the Frame act and disposed by the BA, so both halves land inside the
existing fence. And a confirmed candidate's capture is not a new artifact class:
`sources/slack-<channel>-<date>.md` is the **very path shape** D-B1-6 names as
T-01's material on hand. The intake boundary does not move, so nothing needs
saying at T-01 — and restating a fence that already holds is how two copies of
one rule begin to drift, which is the argument §5.1-by-reference (R4) was ruled
on. **Catalogue-b1 stays v0.5; the index is not regenerated.**

### Files touched — six

| File | Change |
|---|---|
| `docs/methodology/…-orchestrator-rules.md` | v0.19 → **v0.20**: edition line · v0.20 change record · §8.1 pinned block (+2 conditional lines) · §8.1 candidate-scan clause · §11 Frame binding row · **§24** review record · footer v-change record (`D-O1–D-O53`, `v0.19→v0.20 in §24`) |
| `payload/claude/skills/ba-frame/SKILL.md` | rebuilt from the document: the pinned block byte-identical to §8.1's · the operative clause · the frontmatter description |
| `tests/presale-path.md` | interaction 1 gains the candidate render and the **confirm path**; interaction 8 records that the scan adds no second consumer of the slack |
| `tests/check-orchestrator.sh` | §5c added; header edition check v0.19 → v0.20; contiguity `range(1,53)` → `range(1,54)` |
| `BUILD-LOG.md` | the versioning-discipline conventions section (D157) + this entry |
| `VERSION` | 0.1.15 → **0.1.16** |

**Mirrors, personas and templates: zero delta, verified not assumed.** The four
personas and both mirrors cite the source inventory **by name** in §10.3 rule 8's
pinned-formats list and never carry the block, so a shape change inside the block
reaches none of them. `grep -rl "Sources on hand"` returns three files before the
pass and three after: the document, `ba-frame`, and the check that compares them.

### Method

Exactly-once (`str.count`) assertion before every substitution, abort on any
miss, residual sweep after — **12 substitutions, all 1×**, and two aborts that
did their job: a truncated needle and a line-wrapped one, both caught before a
byte was written. One real drift surfaced and was fixed rather than tested
around: the document said *the BA is being asked to confirm a source, not to run
a search* and the skill said *the BA is confirming a source, not running a
search*. Two wordings of one rule is the drift the byte-identity check exists to
prevent, one layer up from the fence it guards; the document was brought to the
skill's shorter form, so one needle now serves both carriers.

### Tests

**`check-orchestrator.sh` 201 → 238 (+37), 0 failed.** New §5c, in the 5b
pattern — the assertions the two rendered lines cannot carry themselves:

- **R3-c mechanically, not in prose:** the pinned block is parsed and
  `#<channel>` counted — **exactly one**, in both carriers. A second channel
  token *is* the render defect, so counting it is the rule rather than a
  paraphrase of it. The count line is asserted verbatim.
- **R1-a:** no opt-in · no wait on a named Slack source · unreachable = zero
  delta, in document and skill.
- **R2-c:** the project name as the only key · no name → no key and no scan ·
  names never content.
- **R4-b:** BA-named-and-BA-confirmed only · an unanswered candidate is declined
  · the D-O47 capture path unchanged · no second consumer of the slack. Plus the
  ledger half **at its own grain**: the `Sources:` head line is re-read in all
  four carriers and must have grown **no fifth state** — a decline that records
  nothing cannot need one, and D-O48's vocabulary is closed.
- **Placement:** §10.1's P-O table is parsed and its **eleven rows** counted, so
  *no new prompt point* is an assertion and not an intention.

**`check-budget.sh` 37 / 0, unchanged, and that is the point.** The fixture
gained prose inside interaction 1, not a heading: the count stays **8**.

**Suite 17/17 GREEN**, the three install-based runs included — re-run **after**
the `VERSION` write, so the manifest assertions checked 0.1.16, and the doc
vector resolves the orchestrator at v0.20.

### Version

`VERSION` 0.1.15 → **0.1.16**, taken by this pass under D157 — the first
automatic patch increment under the new discipline. No minor is proposed and none
is hinted at: that stamp is the BA Lead's initiative alone.

### Open

**Nothing from this cycle stands open.** **D-O53 awaits ratification**, with
**D153–D157** beneath it. Three items carry, none touched here: **R4** (the
gate's A-pass §5.1-by-reference rule, ruled 14 Aug 2026, still unbuilt) and the
hygiene backlog — **D152** (the stale *names indicative* caption) beside **D82**
(the t17 section-close placement).


## The Backlog Cleared and R4 Built — one pass, two lanes, Lanes A + B · gate v0.8 · package 0.1.17 · 15 August 2026 · GREEN

Two lanes in one pass. **Lane A** empties the hygiene backlog the command-surface
sweep named and deliberately did not take — **D152**, the stale caption, and
**D82**, the on-pass/on-miss placement. **Lane B** builds **R4**, the one item
that had been ruled and unbuilt across three cycles.

**State as found:** `main` at `5bf248b`, `VERSION` **0.1.16**, orchestrator
**v0.20**, gate **v0.7**, standard v0.4, elicitation v0.6, tree clean, suite
**17/17 GREEN** before a byte moved. The three carried items were exactly the
three this pass takes.

---

### Lane A · D152 — the caption trued, four occurrences, residual zero

D152's requirement, from the entry that raised it: *"Retiring it is not a
deletion: D-P2-1 cites that exact clause as its own pre-authorization … so the
caption has to be **re-worded to the past** rather than removed, in both tables,
in one act, with D-P2-1's citation still landing."*

The sweep found **four** occurrences of *"names indicative — Phase 2 fixes
them"* across `docs/`, not two — two captions and two citations of a caption:

| Site | What it is | Now reads |
|---|---|---|
| gate `§13`, the Runtime-element table header | the caption | `Phase-2 primitive (names as fixed by Phase 2 — D-P2-1)` |
| orchestrator `§11`, the binding table's lead sentence | the caption | `Names as fixed by Phase 2 — D-P2-1, the hyphenated ba-* namespace (the gate §13 convention).` |
| build plan `§0`, the environment-constraints row | a citation | `Both binding tables carried the caption that pre-authorized the fix; this plan fixes them, and their captions now name this decision (build-log D152)` |
| build plan `§7`, **D-P2-1's own decision row** | a citation | `Both binding tables pre-authorized this in their captions, which now name this decision as the fixer (build-log D152)` |

**No column was deleted and no row moved** — every row under both captions was
already correct, which is what D152 said: only the caption's tense was wrong.
Exactly-once (`str.count`) asserted before each of the four substitutions;
**residual sweep across `docs/` returns 0**, both capitalizations.

### Lane A · D82 — the pair moves into the replaced paragraph's own slot

**Ruled by Eugene K., 15 August 2026:** align t17, t18, tier1, tier2 to the
t01–t16 position — *the pass/miss pair sits in the replaced paragraph's own
position, **before** the skip-if, not after it.*

The item it closes, as raised at the technique-skill batch:

> **D82 · "T-A3/T-A4 close the section" was read literally, and it moves t17's
> on-miss.** For t17 · t18 · tier1 · tier2 the pass/miss pair stands as the last
> paragraphs of `## Invocation contract`. In t17 that puts them **after** the
> skip-if rather than before it, where the replaced paragraph sat; t01–t16 keep
> the pair in the replaced paragraph's own position. The alternative reading —
> "close the contract-check block, ahead of the skip-if" — is a four-file move
> if EK meant that one.

**The payload skill files are the authored source for this section, and were
edited directly.** A sweep of `docs/` for `On a pass` · `On a miss` ·
`Invocation contract` returns **zero hits**: no methodology document carries the
invocation-contract paragraphs. The catalogues carry the technique *sheets*; the
contract block is a payload-layer compile of orchestrator P-O3, authored in the
twenty `SKILL.md` files. There is no source to fix and rebuild from.

**The target slot was recovered from the record, not estimated.** `3f7858d` —
the commit that compiled P-O3 into all twenty skills — shows the paragraph t17's
pair replaced: *"On a contract miss, stop and name `/ba-run`, or `/ba-aspect` to
compose the Band-2 plan."*, standing between the advisory paragraph and the
Skip-if. That is exactly where the pair now stands.

**Verification, all four files:** each carries the pair **exactly once**
(`str.count` on both halves), and each of t17 · t18 now carries it **before** its
skip-if. tier1 and tier2 carry no skip-if at all and close their contracts with
the pair — see **D159**.

---

### Lane B · R4 — the ruling, quoted

Registered 14 August 2026 and carried through three cycles unbuilt. From the
stamp entry, verbatim:

> ### R4 = (a) — ruled 14 August 2026, scheduled, not built
>
> **The A pass takes §5.1's rule by reference.** The previous entry's Open
> section named the gap — an A checker judging CC-FR-03 over a §3 that parsed
> nothing has the same shape as the M checkers did, and nothing stops it
> returning a PASS. The BA Lead rules **(a)**: §5.1's SKIPPED-on-unsupported-parse
> rule extends to the A pass **by reference to §5.1, never by restatement**. The
> agent surface cites the rule; it does not carry a second copy of it, and a
> second copy is a second thing to drift — the same principle the parse layer's
> single-signal-site rule states.

Four things are fixed by that text, and all four are what got built: **what**
extends (§5.1's SKIPPED-on-unsupported-parse rule) · **where to** (the A pass) ·
**in what form** (by reference to §5.1, never by restatement) · **on which
surface** (the agent surface cites; it carries no second copy).

### Lane B · the documents, then the payload

**Documents first.** `gate-definition` **v0.7 → v0.8**: the edition line, a v0.8
change record, the footer v-change record, and the one operative addition —
**§5.2 gains a fifth bullet**, *Unsupported parse — §5.1's rule, taken by
reference*. It states that the A pass stands inside §5.1's scope, points at that
section for the rule's two grains, its blocker naming, its FAIL clause and its
genuinely-empty carve-out, and says in terms that it **carries no second copy of
it**.

**§5.1 is untouched — not one word moves.** That is the point of the ruling: the
rule keeps one home. `git diff` on the document shows the §5.1 paragraph
unchanged and the §5.2 bullet added, and nothing between them.

**Then the payload.** `payload/claude/agents/ba-gate.md` — the A-pass evaluator,
the surface the ruling names — takes the citation inside its existing **SKIPPED**
bullet: the unsupported-parse case is one of that bullet's named prerequisite
failures, never a PASS, and it is *"the gate's §5.1 SKIPPED-on-unsupported-parse
rule … reaching this pass by reference: it is stated once, at §5.1, and this
surface cites it and carries no second copy of it."* The verdict grammar the
agent renders (`SKIPPED — blocked by CC-<ID>`) is the bullet's own and did not
have to be restated. **No compiled skill file was hand-edited in this lane**;
nothing under `payload/claude/skills/` moves for R4.

**The cards are untouched, correctly.** A card is `ID + exact operative text +
Checks set + flag — nothing else` (build plan §2.5), and gate §13 fixes the A
pass's card as *assertion text + CC-ID only*. A runtime rule has no business in
one, and `check-cards.py` re-derives all three byte-identically after the bump.

### Tests — the shape read mechanically, not the intent

**`check-gate.sh` gains section 7 — seven assertions** (the mutation section
renumbers 7 → 8, and a whitespace-flattening `fhas` helper joins the three
the file already had, so a sentence that wraps in the source is one string to the
assertion). The by-reference form is a *shape*, and the section reads it twice:

1. **The citation is present in both layers** — four `fhas` assertions: §5.2's
   bullet lead and its no-copy clause; the agent surface's citation of §5.1 by
   name and by section, and its own no-copy sentence.
2. **Neither layer carries §5.1's text.** A `nodup.py` step lifts §5.1's rule
   paragraph **live from the document**, normalizes it to words, and asserts
   that **no six-word run of it** appears in the agent surface — and then that
   none appears in §5.2's own bullet either. Nothing is hand-listed, so the check
   keeps holding if §5.1 is ever re-worded. Measured margins as shipped: the
   agent surface's longest shared run with §5.1 is **4 words** (`source did not
   parse`), §5.2's bullet's is **2**.
3. **The mutation, per the house rule** — the no-copy read is worth nothing
   unless a real paste makes it fire. §5.1's `**Spec grain:**` sentence is
   appended to a private copy of the agent surface, and the check is asserted to
   **fail** on it. It does.

**`check-spine.sh` gains four assertions**, one per D82 file, inside the loop
that already walks t17 · t18 · tier1 · tier2: the pair stands **exactly once**
and, where the file carries a `**Skip-if`, **ahead of it**. Proved non-vacuous
against two mutants of `ba-t17` — the pair pushed back below the skip-if (fires)
and a second copy pasted in (fires).

**Result: 17/17 GREEN**, the three install-based runs included, re-run after the
`VERSION` write so the manifest checks assert 0.1.17. `check-gate` **66/0** (was
59/0 — the seven new assertions) · `check-spine` **178/0** (was 174/0 — the four)
· every other check on its previous count exactly: `check-m` 59/0 ·
`check-orchestrator` 238/0 · `check-techniques` 104/0 · `check-techniques2`
122/0 · `check-techniques3` 158/0 · `check-register` 62/0 · `check-wbs` 62/0 ·
`check-status` 103/0 · `check-layout` 112/0/0 · `check-exit` 99/0 ·
`check-install` 64/0 · `check-budget` 37/0 · `check-auto` 142/0 · `check-ledger`
and `check-cards` clean.

### Files touched — ten

| File | Change |
|---|---|
| `docs/methodology/…-gate-definition.md` | v0.7 → **v0.8**: edition line · v0.8 change record · **§5.2's by-reference bullet** · footer v-change record — **and** §13's caption (D152) |
| `docs/methodology/…-orchestrator-rules.md` | §11's binding-table caption (D152) |
| `docs/methodology/…-phase2-build-plan.md` | the two citations of the caption — the §0 constraints row and D-P2-1's own row (§7) (D152 · D158) |
| `payload/claude/agents/ba-gate.md` | the SKIPPED bullet takes the §5.1 citation (R4) |
| `payload/claude/skills/ba-t17/SKILL.md` | the pass/miss pair moves before the skip-if (D82) |
| `payload/claude/skills/ba-t18/SKILL.md` | the same move (D82) |
| `tests/check-gate.sh` | the `fhas` helper · **§7**, seven assertions incl. the mutation · old §7 renumbered §8 · header note |
| `tests/check-spine.sh` | the D82 placement assertion in the four-skill loop, four assertions |
| `VERSION` | 0.1.16 → **0.1.17** |
| `BUILD-LOG.md` | this entry |

### Divergences — D158–D161

**D158 — D152's sweep reached two *citations* of the caption, one of them inside
a locked decision row.** The captions were two; the phrase was four. The Phase-2
build plan quotes it twice — in its environment-constraints row, and in
**D-P2-1's own decision row**, which cites the caption as its pre-authorization.
Both were reworded so the claim survives without the retired phrase: D-P2-1's row
now says the captions *"name this decision as the fixer"*, which is a stronger
citation than the one it replaced, not a weaker one. **Registered because the
house convention is that locked rows are amended on the record, never by
rewriting** — the orchestrator v0.16 change record states it in terms — and this
pass rewrote one. It was rewritten rather than left because D152's own text
conditions the act on *"D-P2-1's citation still landing"*, and a row quoting a
phrase that exists nowhere lands nothing; the instruction's residual sweep was
also to return zero, and it does. **The reversal is one substitution** if the BA
Lead prefers the locked row untouched at a residual of 1.

**D159 — the D82 move is two files, not four.** t17 and t18 moved. tier1 and
tier2 did not, because **neither carries a `**Skip-if` at all** — the ruling's
criterion has no target in them, and both already stand at the t01–t16 shape with
the pair closing the invocation contract. `3f7858d` settles it on the record:
that commit inserted tier1's pair straight after the per-mode preconditions and
tier2's after the last contract paragraph, and neither file has ever carried a
skip-if. D82's *"four-file move"* was the blast-radius estimate for the four
files carrying the pattern, not a count of paragraphs to relocate. **A second
reading is named and was not taken:** *"close the contract-check block"* would
also lift tier2's pair ahead of its two explanatory paragraphs (*Preconditions
are not re-checked here* · *No persistent question log*), since t04 and t07 put
their non-check paragraphs **after** the pair. The ruling's stated criterion is
the skip-if, so that move was not made — it is one act away if the BA Lead means
the wider reading.

**D160 — the singular *name indicative* idiom survives at three orchestrator
sites, and is not D152's phrase.** §10.4's HTML-render paragraph carries *"(name
indicative, Phase 2 fixes it)"* — for the `--html` flag and again for the derived
file's location — and the v0.9 change record and D-O29's review-record row carry
*"(name indicative)"* for `/ba-wbs` and `--html`. All are stale in the same
*sense*: `/ba-status --html` and `/ba-wbs` both ship. None of them is the
binding-table caption D152 names; two of the three are locked historical text;
the third is live prose about a **file name**, not a command table. **Left as
written and registered as the backlog's next item** — it needs a ruling of its
own, exactly as D152 did, and folding it into a caption act would repeat the
mistake the hygiene backlog was created to stop.

**D161 — R4 is silent on the doubt rule's boundary, and this pass took no reading
of it.** §5.2's doubt rule fires *"if, after reading the evidence, the checker
cannot affirm"*; §5.1's rule now reaches the same pass for the case where the
source **did not parse**. A hostile reading has both triggers over one situation,
with different grammar — `SKIPPED` with a named blocker, or `FAIL` with the doubt
named. **The build does not need it settled and does not settle it:** each rule
names its own trigger, both outcomes are non-PASS, and §6.1 forces FAIL on any
skip regardless — so the gap R4 closed is closed under either reading, and the
false PASS the ruling existed to stop cannot return through the ambiguity. Draft
text that would have fixed the boundary in §5.2 was written and **removed before
it shipped**; legislating it is a ruling, not a build. The two readings, for
whoever rules it: **(a)** the parse-gap case is §5.1's alone, and the doubt rule
governs only a checker that read parsable evidence · **(b)** the doubt rule stays
available where an A checker judges over a partly-parsed source. One sentence in
§5.2 settles it.

### Version

`VERSION` 0.1.16 → **0.1.17**, one automatic patch increment for the whole pass
under D157. No minor is proposed and none is hinted at.

### Open

**Nothing from this pass stands open.** **D152 closed** — the caption states the
settled fact at both tables, residual zero. **D82 closed** — the pair sits in the
replaced paragraph's own slot in every file that has one, pinned by four
assertions. **R4 built and closed** — §5.1's rule reaches the A pass by
reference, the citation on both layers, the no-second-copy half read mechanically
off §5.1's own text. **The carried-items list is empty for the first time since
14 Aug 2026.**

**D158–D161 await ratification**, with **D-O53 · D153–D157** still standing from
the previous entry. The hygiene backlog is not empty: **D160** is its new
occupant, and it is a document act, not a defect.

---

## The Scan Lists and Filters — F-06 rebuilt under ruling + the D161-(a) boundary sentence, Lane B · orchestrator v0.21 · gate v0.9 · package 0.1.18 · 16 August 2026 · GREEN

One pass, two rulings, documents first. **F-06** rebuilds the Slack candidate
scan's *method* — list-then-filter, the only one — under a four-ruling package,
with the post-mortem that forced it written into the repo verbatim as the
decision's origin. **D161-(a)** closes the doubt-rule boundary the 0.1.17 build
registered and deliberately did not settle: one sentence in gate §5.2.

**State as found:** `main` at `30bd739`, tree **clean**, `VERSION` **0.1.17**,
orchestrator **v0.20**, gate **v0.8**, suite **17/17 GREEN** before a byte
moved. The brief warned of uncommitted work at package 0.1.17; the tree carried
none — see **D162**. Built on top of HEAD as instructed; nothing reset, nothing
stashed.

### The origin, on the record

`docs/field-notes/2026-08-16-slack-scan-miss.md` — the 16 Aug 2026 field
post-mortem, written from the attachment **verbatim** (byte-for-byte: `shasum`
`43f310a9…` identical on both sides), directory created for it. The finding it
records: the Frame scan for project Nutrivity issued **one** name-keyed query
(`nutrivity`), got zero, and rendered "no candidate" while `#est_nutrivity`
existed and was reachable — the workspace prefixes project channels
(`est_<project>`), and `slack_search_channels` matches exact names and
left-anchored prefixes reliably while infix matching is fuzzy and internally
inconsistent (`vity` hits, `nutri` returns zero against the same channel). A
single zero-result is not evidence of absence.

### The ruling package (BA Lead, 16 Aug 2026, final), quoted

> **R1-a** — list-then-filter is the ONLY scan method. The scan enumerates the
> workspace's channels by paging the broad listing to completion and filters
> LOCALLY for the project name. Name-keyed search against the Slack search
> endpoint is removed from the scan entirely — not demoted to a fallback,
> removed. "No match" may be rendered only after the local filter over the
> COMPLETE listing comes back empty: a zero from a name-keyed search is
> inconclusive by ruling and can never justify a "no candidate" render.
>
> **R2-a** — the local filter's match rule: tokenize channel names on `_` and
> `-`, case-insensitive; a channel is a candidate iff every token of the
> project name appears among the channel's tokens. (The KEY is unchanged from
> D-O53 R2-c: the project name and nothing else. What changes is how the key
> is applied.)
>
> **R3-a** — when the filter yields several candidates, ranking is
> deterministic from names alone: exact name equality first, then fewest extra
> tokens, alphabetical tie-break. The render stays D-O53 R3-c verbatim: one
> best candidate + "and <N> more matched — name them to see". Note in the
> clause: the complete listing is what makes <N> honest — a fuzzy search could
> never certify the count.
>
> **R4-a** — prefix detection/surfacing (the post-mortem's fix 5) is REJECTED:
> list-then-filter makes it redundant and surfacing a prefix would widen the
> render against R3-c. Record the rejection in the decision so it is not
> re-proposed.
>
> Fix 6 rides the clause as one line: the search tool's matching is reliable
> for exact names and left-anchored prefixes only; infix is fuzzy — which is
> why the scan lists and filters rather than searches.

And the second ruling, riding the pass:

> **D161-(a)** — ruled 16 Aug 2026: gate §5.2 gains ONE sentence fixing the
> doubt-rule boundary per reading (a): the parse-gap case is §5.1's alone,
> taken by reference per the v0.8 bullet; the doubt rule governs only a checker
> that read parsable evidence.

### The documents, then the payload

**Orchestrator v0.20 → v0.21.** §8.1's candidate-scan clause gains its METHOD
half — three paragraphs between the keys paragraph and names-never-content:
*the method is list-then-filter, and there is no other* (enumeration to
completion, local filter, name-keyed search removed entirely, the fix-6 tool
fact, the zero-is-inconclusive law with its only-after-the-complete-listing
render condition) · *the filter's match rule* (the `_`/`-` case-insensitive
tokenization, the every-token-iff rule, the key D-O53's unchanged, the listing
resolving names and metadata, never a message) · *the best match is
deterministic, from names alone* (exact equality → fewest extra tokens →
alphabetical, the render D-O53's verbatim, the complete listing what makes
`<N>` honest). **D-O54** registered in the new **§25** review record —
contiguity verified against the locked range as found (`D-O1–D-O53`; no D-O54
anywhere in repo before this pass) — with the R4-a rejection recorded in the
decision row so prefix surfacing is not re-proposed, and the origin line citing
the field-notes path. Edition line, v0.21 change record, footer segment, locked
range to D-O54, review-record list to §25. **Unchanged and binding, stated in
the change record:** every D-O53 ruling (trigger · R2-c key · R3-c render ·
R4-b ledger), D154 names-never-content, D155 unanswered-candidate-is-declined,
D156 no-project-name → no key → no scan, the scan internal work — zero new BA
interactions, D-O33's ≤ 8 with its 7 + 1 slack arithmetically untouched. The
pinned inventory block's two candidate lines: **byte-untouched** (5b's
byte-identity check holds as-is).

**Gate v0.8 → v0.9.** §5.2's doubt-rule bullet gains the one ruled sentence —
*"**The boundary is ruled (a):** the doubt rule governs **only a checker that
read parsable evidence** — a Checks source that did not parse is §5.1's case
alone, taken by reference per the Unsupported-parse bullet below, and never a
doubt-line FAIL."* — plus edition line, v0.9 change record, footer segment.
**§5.1 untouched — not one word** (`git diff` shows zero hits on its rule
paragraph); the v0.8 by-reference bullet untouched; no assertion, verdict
meaning, stage, evidence schema or waiver machinery moves.

**Then the payload, from the documents — no compiled skill hand-edited against
its source.** `ba-frame/SKILL.md` takes the method as four bullets between the
key bullet and *Resolve names, never content* — list-then-filter with the
removal and the tool fact, the zero-is-inconclusive law, the match rule, the
deterministic ranking — wording aligned with §8.1 so every law is one shared
assertion string across both carriers. **`ba-gate.md` takes the D161 sentence:
it reaches the agent surface** because the surface carries both grammars the
ambiguity confused — the doubt rule (*There is no MAYBE*) and the SKIPPED
bullet's unsupported-parse citation — and the executor is exactly the actor
that must pick between them; one sentence lands in the no-MAYBE paragraph
(*"The doubt rule governs only evidence you could read: a source that did not
parse is never a doubt line — it is the SKIPPED bullet's unsupported-parse
case above, §5.1's alone, by reference."*), ahead of *When in doubt, fail*.
The no-second-copy law holds mechanically: check-gate's live six-word-shingle
read passes over the grown surface.

### Tests

**check-orchestrator.sh 238 → 266 (+28).** New §5d: the four laws asserted in
**both carriers** (document §8.1 and ba-frame) — the list-then-filter method
(paging to completion, local filter, removed-entirely, not-demoted), the
zero-is-inconclusive law with its render condition, the tokenization rule, the
deterministic ranking **as one string in ruled order** plus the honest-count
note and the fix-6 tool fact — 12 assertions × 2 carriers. Then the **residual
read** ×2: extract the scan clause (doc: D-O53 lead → profile picker; skill:
scan lead → *Then the profile picker*), require each of six permitted
search-wording sentences **exactly once**, strip them, and require the
remainder search-free — a pasted "fall back to a quick search" sentence was
probed against it and **caught**, so the read is not vacuous. Stack lines for
v0.20/D-O54; the live-edition pin moves to v0.21; the D-O contiguity check
extends to 1…54. The R3-c one-candidate mechanical check and the whole §5c set:
**untouched, green**. **check-gate.sh 66 → 67 (+1):** one `fhas` on the D161
boundary sentence, beside the §5.2 by-reference assertions; section 7's shingle
reads and the pasted-§5.1 mutation stay green over the changed surfaces.
**Battery: 17/17 GREEN** before and after; every substitution ran behind an
exactly-once `str.count` assert (12 doc/payload + 6 test-file substitutions),
residual sweeps after (no stale `D-O1–D-O53`, no live-edition claim off
v0.21, no scan-method wording anywhere but the two carriers).

### Files touched — nine

| File | Change |
|---|---|
| `docs/methodology/…-orchestrator-rules.md` | v0.20 → **v0.21**: edition line · v0.21 change record · **§8.1's three METHOD paragraphs** · **§25/D-O54** with the R4-a rejection on the record · footer, locked range, review-record list |
| `docs/methodology/…-gate-definition.md` | v0.8 → **v0.9**: edition line · v0.9 change record · **§5.2's one boundary sentence** · footer |
| `docs/field-notes/2026-08-16-slack-scan-miss.md` | **new** — the post-mortem, verbatim (checksum-identical to the attachment); directory created |
| `payload/claude/skills/ba-frame/SKILL.md` | the four method bullets, compiled from §8.1 |
| `payload/claude/agents/ba-gate.md` | the D161 boundary sentence in the no-MAYBE paragraph |
| `tests/check-orchestrator.sh` | §5d (+26) · stack lines (+2) · edition pin v0.21 · contiguity 1…54 |
| `tests/check-gate.sh` | the D161 boundary assertion (+1) |
| `VERSION` | 0.1.17 → **0.1.18** |
| `BUILD-LOG.md` | this entry |

### Divergences — D162–D163

**D162 — the brief's state warning did not match the tree.** The pass brief
warned the working tree carried UNCOMMITTED work at package 0.1.17 and forbade
resetting it. As found: the tree was **clean** — the 0.1.17 work is HEAD itself
(`30bd739`). No protective handling was needed or possible; the pass built on
top of HEAD exactly as the warning's intent required. Recorded so the
discrepancy is on the record, not silently absorbed.

**D163 — the pass's own residual read caught the pass's own first draft.** The
ba-frame method bullet's lead was drafted *"List, then filter — never search by
name"* — and the new §5d residual read went red on it: the lead's own `search`
token is not among the six permitted removal sentences shared by both carriers.
Reworded to *"List, then filter — there is no other method"* (the document
lead's own shape). Kept as ruled rather than widening the permitted set:
the permitted list is the removal wording itself, identical in both carriers,
and a lead that needs the token can say the law without it. First red-to-green
of the read, before it ever guarded a future edit.

### Version

`VERSION` 0.1.17 → **0.1.18**, one automatic patch increment for the whole
pass under D157. No minor is proposed and none is hinted at.

### Open

**Nothing from this pass stands open.** **F-06 built** — the scan lists and
filters, the method pinned in both carriers under 26 assertions and a residual
read with a proven bite. **D161 closed by ruling (a)** — the boundary sentence
stands in gate §5.2 and on the A-pass surface, §5.1 and the v0.8 bullet
untouched. The post-mortem is in the repo verbatim, cited as D-O54's origin.

**D162–D163 await ratification**, with **D158–D160** still standing from the
previous entry and **D-O53 · D153–D157** beneath them. The hygiene backlog
still holds **D160** (the singular *name indicative* idiom, a document act) —
this pass adds nothing to it. Not committed: the BA Lead commits at his own
initiative.

---

## The Record Home Gets Its Producer — `/ba-aspect band2`, the seventh argument, Lane B ruled · orchestrator v0.22 · package 0.1.19 · 16 August 2026 · GREEN

One ruling package, documents first, then the rebuild. Origin: the Blackthorn
pilot's T-17 dead end, 12 August 2026 — `/ba-run T-17` stopped at its own
precondition, a composed plan under `## Band 2`, and the corpus named no act
that composes one, while the `ba-t17`/`ba-t18`/`ba-tier1` self-checks,
`/ba-run`'s route resolution and §6.4's "§8.1 and §8.3 define the acts" all
presupposed it. **D-O55** gives the record home its producer: the **seventh,
non-aspect argument** of the existing command — §6.1's snapshot with **two
substitutions** (the `Band 2` header for the aspect; the **roadmap-state hole**
for the AT-ID), the stop at **P-O2 — plan composition**, the record under
`## Band 2`. No new command, no separate shape, no seeding at `/ba-close-band1`.

**State as found:** `main` at `30bd739`, `VERSION` on disk **0.1.18** — the
tree carried the complete, uncommitted, GREEN scan-method package (orchestrator
v0.21 · D-O54 · §25 · gate v0.9 · D162–D163), its entry closing *"Not
committed: the BA Lead commits at his own initiative."* The brief's base pin
read 0.1.17 at a clean 30bd739 — see **D164**. Suite **17/17 GREEN as found**
before a byte moved. The brief's relative-targets header applied as written:
**v0.22 · D-O55 · §26 · 0.1.19 · divergences from D164.** Step-0 battery:
every quoted B–D anchor at exactly one (two wrap artifacts and one historical
duplicate — D166 · D167); the K1 truth check confirmed `ba-frame`'s
canvas-absent branch ("Record the plan line in `## Frame`", the file's one
such line and the corpus's one such act, AUTO-under-AG excepted per D-O40);
the `band2` corpus scan returned **zero command-surface hits** (15 grep hits,
every one a test-infra filename or a status-script internal).

### The documents pass — eleven assertion-checked replacements

- **§8.3** — the new first bullet: plan composition, P-O2, the seventh
  `/ba-aspect` argument (D-O55); the two substitutions; no prerequisite check
  and no threshold table; Band-1 closure the one door; re-composition appended
  and dated; §10.7's P-O2 row unchanged under an AG.
- **§8.2** — the Effects line names the act at the door: **Band 2 unlocked** —
  its plan composable at `/ba-aspect band2`.
- **§6.2** — one appended sentence: P-O2 serves the plans file's non-aspect
  `## Band 2` section by the same discipline; the section's plan is never the
  framework's to write.
- **§10.1** — the P-O2 Trigger cell widened in place: an aspect's snapshot, or
  `## Band 2`'s. **No row added.**
- **§8.1** — the exception clause, K1(a) wording: the canvas-absent Frame line
  is **the one plan line the framework composes without a BA act** — a standing
  AG's AUTO compositions are the BA's stated act recorded in advance (D-O40),
  never the framework's own.
- Header to **v0.22**, the change record in the corpus voice, review record
  **§26** (the defect and its consumers, the eight rulings, the two scope
  corrections, the K1(a) decision, the explicit not-edited record — §6.4 and
  §7.1 stand untouched, each for its stated reason), footer: locked range to
  **D-O55**, review-records list gains v0.21→v0.22 in §26, the v0.22 summary
  block prepended. The change record's inventory was written clause-by-verified
  clause; "no companion carrier" only after the corpus scan — catalogue-b6's
  D-B6-5 and catalogue-b1's D-B1-4 both pin record homes, neither names a
  composition act, both consumed by reference unchanged.

### The rebuild pass — sixteen replacements, ten files

`ba-aspect` (the description, the argument line, the routing sentence, the
`band2` fork — door, two substitutions, roadmap-state grounding for T-17 —
Epics decomposition and T-18 — Scope allocation rows, Tier-1 rows enrichment
and `optional`, composition per Step 4 into `## Band 2`, the never-list's reach
stated) · `ba-close-band1` (the unlock block names `/ba-aspect band2` ahead of
the technique commands and states it never seeds) · `ba-run` (the miss guidance
gains the band2 branch; the compiled P-O3 custom check trued to §7.1's own
wording — D168; the route-resolution line verified and untouched, this batch's
consumer) · `ba-t17` · `ba-t18` (closure tail kept) · `ba-tier1` (the on-miss
acts now name `/ba-aspect band2`) · the mirror's command surface · quickstart's
Band-2 block (the composition step ahead of `/ba-t17`) · the orchestrator
agent (plans-file paragraph, P-O2 row, policy paragraph) · the overlay
template's `## Band 2` comment (the act named beside D-B6-5). Residual sweeps:
`` `/ba-aspect` to compose `` at **0** across payload and docs; pointers naming
composition without the argument at **0**.

### Tests, then the fixture

Additive assertions, none weakened — baseline → after per script:
`check-orchestrator.sh` 266 → **279** (the §8.3/§8.2/§6.2/§10.1/§8.1 doc
surfaces, the ba-aspect fork, ba-close-band1's checkpoint pointer, the agent's
P-O2 row) · `check-spine.sh` 178 → **181** (the three on-miss acts resolve) ·
`check-techniques3.sh` 158 → **159** (the unlock block's next act) ·
`check-register.sh` 62 → **63** (the mirror surface) · `check-status.sh`
103 → **104** (the template comment). Two standing pins re-aimed to the new
truth, the checks' own function: the edition pin (v0.21 → v0.22) and the D-O
contiguity set ({1..54} → {1..55}) — exactly as the sibling pass re-aimed both
for v0.21/D-O54. `docs/quickstart.md` has no owning check; its step is asserted
nowhere, recorded here rather than inventing an owner. **`check-register.sh`
hardened** — `doc_block`/`unit_block` now fail loudly on a second
`Suggestion — ` block instead of silently taking the first: selection by the
block's own header, not by position. Labeled as ruled: **intent over accident,
not a blocker** — the suite stood green either way. **The fixture**
(`appointment-booking/band1/aspect-plans.md`): the missing Band-2 suggestion
snapshot inserted above `Composed plan — 2026-07-11 · Y.K.`, dated 2026-07-11
inside the fixture's world, holes consistent with it (no roadmap on disk at
snapshot time; no tier1 row — no epics exist yet). **Insert-only verified
byte-identically**: removing the inserted block restores the original; git
numstat 7 insertions, 0 deletions. Shape and row judgment calls: D169.

**Full suite 17/17 GREEN, the three install-based runs included**, after one
red-to-green of the batch's own making: the fork's first draft rendered
"T-18's reruns" bare, and the register sweep (rule 5) went red on it — D171.

### Findings

**The Phase-3 finding (ruling 5 — logged here, no `diagnostics/` register: one
finding does not earn one).** When `/ba-run` hit the Band-2 dead end in the
Blackthorn pilot, it **offered to write the Band-2 plan line itself** on the
BA's confirmation — against its own prohibition, *"never pins or confirms a
contract itself (that is P-O2 — plan composition)"*. The contract text it
rendered was **verbatim from `ba-t17/SKILL.md`**, so nothing was invented — the
violation is procedural, not substantive; prescribed behaviour on an unpinned
contract is to stop and send the BA to P-O2. Logged, not fixed as a run-time
behaviour item here — the structural fix is this package: the dead end now has
a legal exit, and the on-miss acts name it.

### Closed, and named as follow-up

**D80 closed** — `ba-tier1`'s on-miss act, given as *"`/ba-aspect` to compose
the Band-2 plan"*, now resolves: `/ba-aspect band2` exists and composes it.
**D81 closed** — `ba-t18`'s on-miss likewise, its closure tail standing
unchanged. **The resolvability sweep is named as follow-up and NOT built**
(ruling 8): every on-miss and next-act pointer in the payload names an act, and
nothing checks those acts resolve — D80/D81's defect class, of which this batch
fixes one instance. A corpus-wide sweep is its own batch with its own ruling.

### Files

| File | Change |
|---|---|
| `docs/methodology/ba-native-spec-orchestrator-rules.md` | v0.21 → **v0.22** — §8.3 · §8.2 · §6.2 · §10.1 · §8.1 · header/record · §26 · footer |
| `payload/claude/skills/ba-aspect/SKILL.md` | the `band2` fork — the seventh argument |
| `payload/claude/skills/ba-close-band1/SKILL.md` | the unlock block points at the checkpoint |
| `payload/claude/skills/ba-run/SKILL.md` | the band2 miss branch; the P-O3 check trued to §7.1 |
| `payload/claude/skills/ba-t17/SKILL.md` · `ba-t18` · `ba-tier1` | on-miss acts resolve |
| `payload/mirror/claude-block.md` · `docs/quickstart.md` · `payload/claude/agents/ba-orchestrator.md` · `payload/specify-overlay/ba/templates/aspect-plans.md` | register consistency |
| `tests/check-orchestrator.sh` · `check-spine.sh` · `check-techniques3.sh` · `check-register.sh` · `check-status.sh` | +19 assertions · two pins re-aimed · the register hardening |
| `tests/fixtures/appointment-booking/band1/aspect-plans.md` | the Band-2 suggestion snapshot, insert-only |
| `VERSION` | 0.1.18 → **0.1.19** |
| `BUILD-LOG.md` | this entry |

### Divergences — D164–D171

**D164 — the base pin did not match the tree, in the direction opposite to
D162.** The brief pinned `VERSION` 0.1.17 at a clean `30bd739`; found: HEAD
`30bd739` carrying the complete, uncommitted, GREEN 0.1.18 scan-method package,
its entry reserving its commit to the BA Lead. The brief's own relative-targets
header ("the pins above are verification values, not literals to force")
resolved every number: v0.22 · D-O55 · §26 · 0.1.19 · D164+. Proceeded on the
sibling package as base after verifying every anchor against the tree as found
and the suite green over it.

**D165 — the commit is withheld at close; "Commit and push on GREEN" cannot
execute as written.** Any commit of this pass necessarily carries the sibling
package's files — the orchestrator doc, `BUILD-LOG.md` and `VERSION` hold both
passes' changes — and that package's own record reads *"the BA Lead commits at
his own initiative."* Committing it under this pass's message on this pass's
initiative would override a sibling's explicit reservation on my own judgment.
Both packages stand complete and GREEN; the prepared commit is in the close-out
report; one word from the ruling venue executes it.

**D166 — the §6.2 anchor is not unique in the document.** *"each stamped AUTO
and standing for ratification at `off`."* occurs twice: §6.2's living sentence
and the §19 review record's D-O40 row quoting it (comma variant: `auto on`,
vs `auto on` bare). Step 0.4 reads STOP at ≥ 2; the edit's own prose names the
site ("§6.2's paragraph"), so the anchor was extended by its unique leading
clause and the append landed at the named site. The historical record is
untouched.

**D167 — two quoted anchors wrap across lines in their files.** `ba-run`'s
route-resolution line (*"…the `## Band 2` section's / route"*) and `ba-t18`'s
closure tail (*"…`/ba-close-band1` where / Band 1…"*) count 0 as flat strings
at the 80-column fill. Verified whitespace-joined — both present verbatim —
and treated as found; the replacement texts re-wrap their paragraphs whole.

**D168 — one line beyond the brief's named edit in `ba-run`.** The compiled
P-O3 custom check read *"on the composed plan of an `open`/`reopened` aspect"*
— narrower than §7.1's own *"or its own plans-file section"* — which would have
left the new band2 miss branch dead: a legal `## Band 2` custom line would
have failed the check it precedes. Trued to the document's wording. Compile
truing, no methodology change; §7.1 itself was not edited (its case was always
legal — this is the not-edited record's other half, applied to the compile).

**D169 — the fixture snapshot is written in the fixture world's own §6.1
idiom,** not the live fenced block: the four-column `Technique (catalogue |
custom sketch) | Addresses | Expected contribution` shape its three sibling
snapshots carry, no profile suffix and no `State:` line — the fixture's July
world predates both (its state head carries no `Profile:` line). Two row
judgment calls, stated: `t18`'s Addresses names the hole as the born state
(*"rows Unallocated — every epic is born unallocated"*), grounded in `t17`'s
own pinned contract (*"Phase (Unallocated at birth)"*); and no `tier1` row
renders — no epics exist at snapshot time, and the world's idiom carries no
enrichment block.

**D170 — the fork's `State:` line carries the roadmap state.** §6.1's `State:`
line counts threshold criteria; Band 2 has no threshold table, so a count
there would render machinery that does not exist. The ruling names two
substitutions; this slot is where the replaced AT machinery surfaces a second
time, and the fork renders the roadmap state in it — the substitution applied
at the only slot whose literal reading has no referent.

**D171 — the register sweep caught the pass's own first draft.** The fork's
third bullet rendered *"T-18's reruns"* — a bare code in a BA-facing string —
and `check-register.sh` went red on it (rule 5), with its self-test cascade
behind it. Reworded to *"T-18 — Scope allocation reruns"*. The document's §8.3
bullet keeps the ruled possessive: the methodology layer is not a BA-facing
render, and the register's 63-file corpus does not reach it. Second
red-to-green of a sweep against its own pass in two packages — the checks are
earning their keep.

### Version

`VERSION` 0.1.18 → **0.1.19**, one automatic patch increment for the whole
pass under D157. No minor is proposed and none is hinted at.

### Open

**Nothing from this pass stands open but the commit act itself (D165).** The
record home has its producer: `/ba-aspect band2` composes, the door names the
act, the on-miss acts resolve (D80 · D81 closed), the fixture carries the
snapshot its world was missing, and the resolvability sweep stands **named and
not built**, awaiting its own ruling. **D164–D171 await ratification**, with
the sibling pass's **D162–D163** standing beneath them and **D158–D160 ·
D-O53 · D153–D157** beneath those. The hygiene backlog still holds **D160**;
this pass adds nothing to it. Both packages — 0.1.18 and 0.1.19 — stand
complete, GREEN and uncommitted on one tree: the prepared commit is in the
close-out report, and the BA Lead's word executes it.

## The Shape-Guard Set — writers keep the pinned shape, readers name the near-miss, Lane B ruled · orchestrator v0.23 · elicitation v0.7 · package 0.1.20 · 17 August 2026 · GREEN

Five rulings, one pass, documents first. One law seen from both ends: **the shape
a skill pins is the contract between its writer and its readers.** Origin: the
field defect of 16 Aug 2026 (Nutrivity) — a T-18 run under a standing AG wrote its
allocation heading in **ledger stamp grammar** instead of the artifact's own pinned
`### Allocation <n> — <date> · trigger: <…> · BA: <name>`. The entry was right in
substance, landed at its contracted destination, and recorded `contract: fulfilled`.
It was **invisible to every reader of the log it joined.** Nothing stopped the
writer; nothing made a reader say so.

**Ruling → number map.** R1 → **D-O56** · R2 → **D-O57** · R3 → **D-O58** (its H-02
half **stopped**, D177) · R4 → **D12** (elicitation lane) · R5 → **D-O59**. Package
divergences **D172–D180**.

### State as found — the base pin did not match, and the ruling superseded it

`VERSION` read **0.1.19**, not the briefed 0.1.17, at HEAD `30bd739`: the tree
carried **two complete, GREEN, uncommitted packages** — 0.1.18 (the scan method,
orchestrator v0.21, D-O54/§25) and 0.1.19 (`/ba-aspect band2`, v0.22, D-O55/§26) —
each reserving its commit to the BA Lead (D165). Stopped and reported, per the
prompt's own precondition. **Ruled the same sitting:** commit 0.1.18 and 0.1.19 in
order, each under its own record, then build the shape-guard set on the clean
0.1.19 base. D172 · D173 · D174 carry that lane.

### The two reserved packages, committed in order

`c4e977d` **package 0.1.18** · `b901adc` **package 0.1.19**. The split was real
work: **four files carried both passes** — `BUILD-LOG.md` (a pure append, split at
its entry boundary: 8076 HEAD + 196 + 224 = 8496, exact), `VERSION`,
the orchestrator doc (9 hunks — 5 reverted whole, 3 mixed and hand-separated) and
`check-orchestrator.sh` (edition pin, contiguity range, and section 6b).
**Verified, not assumed:** the reconstructed 0.1.18 tree reported
`check-orchestrator.sh` **266** — the exact count 0.1.18's own entry recorded — and
every per-script baseline the 0.1.19 entry named (gate 67 · spine 178 · register 62
· status 103 · techniques3 158) came back identical. The full 0.1.19 state was then
restored and proven **byte-identical to the tree as found**: `git diff` against
`30bd739` reproduced the pre-split patch at sha256 `163bf673…`. The split is
lossless, and both packages were GREEN 17/17 at their own commits.

### The documents, then the payload, then the code

**Orchestrator v0.22 → v0.23** (§27, D-O56–D-O59). §10.7's AUTO stamp-grammar block
gains the artifact-side rule — the stamp is an **additional tail**, replacing no
pinned field, the **BA field carrying the grantor** (D-O56). §6.3 gains what
fulfillment requires — the skill's **pinned output shape**, heading literals and ID
grammars, in addition to content; a divergence is a **contract miss**, never
`fulfilled` and never `partial`. **Stated once**; §7.3's row cites it and §7.1
carries it **by reference** while keeping *checked at invocation, nothing else*
intact — the law is write-side and says so (D-O57 · D178). §10.4 gains the
near-miss law as the general rule D-O50 was the first case of, with two pinned
applications and two new conditional render lines (D-O58). §10.7's band-boundary
report gains its **fifth line** — health refresh, computed exactly as §10.4 line 5
computes it, display only, no AG expansion; **D-O52's "four lines" amended on the
record, its row untouched** (D-O59).

**Elicitation v0.6 → v0.7** (§14, D12). Brief §6's `OQ-<n>` grammar pinned as law
where §4's skeleton pins the section's shape — numbered **per brief**, the sequence
restarting and never globally unique; **epic context beside the ID, never inside
it**. The grammar D-O58's line-4 reader matches. **No example was rewritten to fit
the rule** — the worked example already read `OQ-1`/`OQ-2`, which is the evidence
the grammar was real before it was law.

**Payload, from the documents.** `ba-t18` takes the AG heading variant and the
sentence naming the wrong form it replaces; its `references/example.md` gains a
third worked example — a rerun under AG-1, with the tail and the `BA:` grantor.
**Twenty-three skills take D-O57 by reference through one shared string**: the
run-end bookkeeping's item 1, identical in twenty carriers, extended once and
applied twenty times, plus `ba-frame`'s fulfillment step and `ba-run`'s custom
path. The template and `ba-tier1` take D12's grammar and cite its home. **Five
carriers take the health line** — `ba-auto`, `ba-close-band1`, `ba-enter-feature`,
`claude-block.md`, `AGENTS.md` — because `check-auto.sh` diffs all five
**byte-identically** against §10.7 (D178).

**Code — `sk_status.py` only.** `roadmap_log_offenders()` reads the `###` lines
under `## Allocation log` that miss the heading grammar; `roadmap_state()` makes
lines **2 and 8** render from **one computation** — `log unreadable: <a>`
outranking `missing`, with its own continuation naming count, first offender **as
authored**, and the shape expected. `brief_questions()` stops `continue`-ing the
off-shape row and carries it out as `state: off-shape`, which every existing
consumer already ignores by construction; line 4 counts and names it with its
epic. `html_facts` mirrors both, the facts table being the same counts by its own
docstring (D179).

### Tests

Additive, none weakened: `check-orchestrator.sh` 279 → **304** (+25 — the four
rulings' doc surfaces, T-18's carriers, and a loop asserting **every** skill that
books fulfillment cites §6.3 rather than restating it) · `check-status.sh` 104 →
**115** (+11 — the two readers, live, over a mutated estate) · `check-spine.sh` 181
→ **189** (+8 — D12 across its four carriers) · `check-auto.sh` 142 → **143** (+1 —
the health line in the boundary block's vacuity list; the five-carrier byte-identity
diff and its reworded-line control already stood and now guard the fifth line too).
**Two standing pins re-aimed:** the edition pin (v0.22 → v0.23) and the D-O
contiguity set ({1..55} → {1..59}).

**The reader tests are behavioural, not textual.** `check-status.sh` 6c rewrites the
fixture's two allocation headings into the **exact ledger grammar the field defect
produced** and asserts the render reads `roadmap log unreadable: 2`, quotes the
first offender as authored, names the shape expected, and **never** says
`roadmap missing`; then rewrites one `OQ-1` to `E03-Q1` and asserts
`off-shape 1: first "E03-Q1" (E-03)`. **Three controls** assert the clean estate
renders neither line and still reads `roadmap current 2026-07-15` — a near-miss
report that fires at zero is noise. **R1's other half asserted cheaply:** a heading
carrying `· AUTO (AG-1)` still parses and still yields its date, which is exactly
why the tail is the ruled form and the rewrite is not.

**Suite 17/17 GREEN**, the three install-based runs included — **verified in
isolation from a concurrent foreign pass** (D180), after two red-to-greens of this
pass's own making: an assertion literal missing the emphasis markers the §6.3 text
carries, and two in `check-spine.sh` (a casing difference against the doc, and
backslash-escaped backticks inside single quotes, which grep took literally).

### The lane that stopped — R3's H-02 half

**D176 · the conflict, recorded and not worked around.** R3 made the H-02 finding
conditional: *if the existing acceptance mechanism covers silencing a superseded
historical near-miss — wire it; if it does not fit — stop and report.* **It does not
fit,** on the gate's own words. The instrument is the project-level health
acceptance `HA-<nn>` (gate §10.4, D-G9), and its first mechanic reads: *"**Admission
only.** An HA lifts Stage-0 blocks and nothing else — no Scope-F assertion ever
reads it; **it satisfies nothing**."* An HA never removes a finding from a report;
it stops the finding from blocking admission. The mismatch is structural, not
cosmetic: HA persistence is keyed on **the accepted gap's artifact being edited**,
and the allocation log's own law is **append-only** — a superseded entry is *never*
edited, so the offending bytes stay byte-identical forever. The HA would auto
re-apply indefinitely over a defect that by law can never be repaired.

**And building the finding without a silencing path would have been harmful, not
merely noisy.** An unresolved H gap **blocks any Scope-F run whose `deps(F)`
contains the failing artifact** (gate §10.4). The roadmap is a shared artifact.
A permanently unrepairable H-02 finding on it would freeze delivery project-wide
with no legal fix. The lane stopped whole; `sk_health.py` is **untouched**. The
conflict returns to the planning venue: either the near-miss is a **report-only**
finding class that does not block, or the acceptance instrument gains a silencing
power it does not have — both are rulings, and neither is this pass's to invent.

### Files

| File | Change |
|---|---|
| `docs/methodology/…-orchestrator-rules.md` | v0.22 → **v0.23** — §10.7 ×2 · §6.3 · §7.3 · §7.1 · §10.4 · **§27/D-O56–D-O59** · header, footer, locked range, review-record list |
| `docs/methodology/…-elicitation-techniques.md` | v0.6 → **v0.7** — §4's brief skeleton (§6's ID grammar) · **§14/D12** · header, footer, locked range |
| `payload/claude/skills/ba-t18/SKILL.md` · `references/example.md` | the AG heading variant · a third worked example under a grant |
| 20 × technique `SKILL.md` · `ba-frame` · `ba-run` | D-O57 by reference — one shared string, twenty carriers, plus two paths of their own |
| `ba-auto` · `ba-close-band1` · `ba-enter-feature` · `payload/mirror/claude-block.md` · `AGENTS.md` | the health line — all five, byte-identical to §10.7 |
| `ba-tier1/SKILL.md` · `templates/scope-brief-template.md` | D12's grammar, carried and cited |
| `payload/specify-overlay/ba/scripts/sk_status.py` | the two near-miss readers · one shared roadmap-state computation · the HTML facts mirror |
| `tests/check-orchestrator.sh` · `check-status.sh` · `check-spine.sh` · `check-auto.sh` | +45 assertions · two pins re-aimed · one stale caption trued |
| `VERSION` | 0.1.19 → **0.1.20** |
| `BUILD-LOG.md` | this entry |

### Divergences — D172–D180

**D172 — the base pin did not match the tree, and the ruling superseded the
precondition.** The prompt pinned `VERSION` 0.1.17 at `30bd739` and said *stop and
report* if it moved. It had: two GREEN uncommitted packages stood on that commit.
Stopped and reported; the BA Lead ruled option 3 — commit both in order, then build
on the clean 0.1.19 base, with numbers resolving forward (v0.23 · §27 · D-O56+ ·
D172+ · 0.1.20) and R2 targeting the **post-D168** wording of the compiled P-O3
check. Recorded because the precondition was overridden by ruling, not by judgment.

**D173 — the "prepared records" were not on disk.** The ruling asked for each
package committed *under its own prepared record verbatim*. Those prepared commit
texts lived in the prior sessions' close-out reports; only `.git/COMMIT_EDITMSG`
survived and it held **0.1.17's**. The records that exist verbatim are the two
BUILD-LOG entries, and each commit message was composed **from its own entry** in
house style. Both entries stand unedited in this file and are quoted verbatim in
the close report.

**D174 — the intermediate 0.1.18 tree was reconstructed, and two prose strings in
it are this pass's words, not the original pass's.** Splitting required rebuilding
the v0.21 state of the orchestrator doc and `check-orchestrator.sh`. Everything
load-bearing was recovered exactly — the v0.21 **footer segment survived verbatim**
inside the v0.22 footer, and both files' assertion counts hit their recorded
targets. **Two strings could not be recovered and were composed:** the v0.21
**edition line** (overwritten by v0.22's; nothing pins its prose — the test greps
only the `v0.21` token) and the edition-pin **ok/bad message** in
`check-orchestrator.sh`. Both follow the established pattern and the pass's own
naming. Flagged rather than presented as recovered.

**D175 — a stale caption inherited from 0.1.19, trued here.** `check-orchestrator.sh`
read `set(range(1, 56))` while its ok-message still said *"the D-O block runs
1…54"*: the 0.1.19 pass re-aimed the range and left the caption behind. Found
during the split (at 0.1.18 the caption was **correct**, which is how it surfaced).
Left untouched in the 0.1.19 commit — a sibling's reserved package is not edited to
taste — and trued in this pass, with the range, in one move. D152's defect class,
one instance.

**D176 — R3's H-02 lane stopped; the conflict is recorded above and returns to the
planning venue.** `sk_health.py` is untouched. Stated in full in its own section
because the reasoning, not the verdict, is what the venue needs.

**D177 — R2's placement judgment: the law is at §6.3, not §7.1.** The ruling named
§7.1's compiled-check text and §6.3. §7.1's standing sentence reads *"Checked at
invocation, nothing else"*, and a write-side shape test stated there would
contradict it. Resolved without weakening either: the law is stated **once at
§6.3**, §7.3's fulfillment row cites it, and §7.1 gains a paragraph that carries it
**by reference** and says explicitly that it fires at run end and is not a second
admission test. The ruling's substance — one home, compiled checks by reference —
is delivered; only the home moved, and the §7.1 sentence stands unedited.

**D178 — R5 reached five carriers, not the two named.** The ruling named §10.7 and
`ba-auto`. `check-auto.sh` diffs the report block **byte-identically** against five
carriers, so extending two would have gone red — and would have re-created, inside
this very pass, the divergence the pass exists to prevent. All five extended
identically; the byte-identity check is the assertion that keeps them so.

**D179 — R3 reached `html_facts`.** The named set was the text dashboard's lines
2/4/8. The HTML render embeds the chat render verbatim in its `<pre>`, so the
near-miss lines reached it regardless; its **facts table** summarises the same
counts by its own docstring (*"the same counts the chat render carries"*) and would
have summarised them wrongly. One row extended, one added, both conditional.

**D180 — a concurrent foreign pass entered the tree mid-build; this commit is
scoped away from it.** At 02:21, twenty minutes after the 0.1.19 commit and one
minute before the first full-suite run of this pass, the companion **Nutrivity
estate** work (its own prompt, as the brief said) began writing into the same
working tree: a new `ba-audit` skill, a source-audit definition doc, a card, a
template, a fixture directory, and **seven lines in the tracked
`tests/layout.expected`**. It is incomplete — the suite goes **red** on it, the
manifest registering 35 skills against 34 installed. **Nothing of it is committed
here**, and nothing of it was edited or reverted in the working tree: it is left
exactly as found for its own pass to finish. This pass's green was therefore
verified **in isolation** — the tree copied aside, the five foreign paths removed
and `tests/layout.expected` reverted to HEAD in the copy only, suite **17/17
GREEN**. The commit names its 38 paths explicitly rather than staging the tree.

### Version

`VERSION` 0.1.19 → **0.1.20**, one automatic patch increment for the whole pass
under D157. No minor is proposed and none is hinted at.

### Open

**Four rulings built, one lane stopped.** D-O56 · D-O57 · D-O58 · D-O59 and D12
stand, with the writer guarded, fulfillment answering for the shape, the two named
readers speaking, and the boundary report carrying health. **R3's H-02 half is the
one open item** — the acceptance mechanism does not fit and no mechanism was
invented (D176); it needs a ruling on whether a near-miss finding is report-only or
whether the HA gains a silencing power. **The resolvability sweep** stands named
and unbuilt from 0.1.19, unchanged by this pass. **D172–D180 await ratification**,
with **D164–D171** and **D162–D163** now committed beneath them and **D158–D161 ·
D-O53 · D153–D157** beneath those. The hygiene backlog holds **D160**; **D175
cleared its 0.1.19 occupant**. The companion Nutrivity estate pass stands
uncommitted in the tree, untouched, awaiting its own close (D180).


## The Near-Miss Gets Its Class — supersession-keyed, live vs settled, Lane B ruled · gate v0.10 · package 0.1.21 · 17 August 2026 · GREEN

One ruling, one section, documents first. **D176's stopped lane, closed.** The
0.1.20 pass built D-O58's two dashboard readers and **stopped** its H-02 half: the
acceptance instrument did not fit, and no mechanism was invented. The BA Lead ruled
**option (c) — supersession-keyed classing**, neither a report-only class nor an
`HA-<nn>` power. **Ruling → number map:** option (c) → **D181** (closing D176).
Divergences **D182–D184**.

**State as found:** HEAD `5777b74`, `VERSION` **0.1.20**, gate **v0.9**, suite green
over this pass's own ground. The companion Nutrivity estate work stands
**uncommitted and unchanged** from 0.1.20 — its owner has not committed, and
**nothing of it was touched** (D184).

### The law

**Gate v0.9 → v0.10, §10.4.** A near-miss in the roadmap's `## Allocation log` — a
`###` line that does not parse as an allocation heading — is classed on
**supersession, in log order**:

- **LIVE** while **no well-formed entry follows it**. A full CC-H-02 finding: it
  counts in `n gaps`, it blocks under §10.4's own rule, and its fix is **the log's
  own law** — *supersede with a correctly-shaped entry; never edit*. **No
  well-formed entries at all is the live case**, which falls out of the walk rather
  than being special-cased.
- **SETTLED** once a well-formed entry follows it. **Still named** — path · the line
  **as authored** · the shape expected · `superseded-by <Allocation n>` — and
  rendered **outside the gap count**: blocking nothing, requiring no acceptance.

**The rationale is on the record, because it is the whole reason (c) is not (a) or
(b).** The repair here is **always legal** — a corrective append to an append-only
log — so a live finding clears **by the log's own mechanism** and never needs an
instrument to forgive it. That is exactly what separates this from the gaps
`HA-<nn>` exists for, where the artifact must be *edited* to clear and the BA may
rationally accept the debt instead. **`HA-<nn>` and D-G9 are untouched.** The
blind-spots law holds at both ends: settled history is **named, never silenced**.

### The mechanism the law needed — and why `evidence` could not be it

`emit`'s text render prints **only findings on FAIL**; `evidence` renders on PASS
alone. A settled note parked in `evidence` would therefore **vanish the moment the
same assertion also carried a live gap** — the invisible-record defect this entire
workstream exists to close, rebuilt inside the fix for it. No "named but not a gap"
channel existed in the verdict grammar (`runtime_defect` is a hard exit; the
unreadable-*u* precedent lives in the dashboard, not in `Verdict`).

**`sk_structure.py` gains a `notes` channel** — a list on `Verdict`, in `as_dict`,
in `fail()` and `ok()`, **rendered on PASS and FAIL alike** as
`<assertion> NOTE — …`, and touching **neither the gap list nor the exit code**.
Shared machinery, so the blast radius was checked before it was written: `check-m.sh`
reads only `script` / `assertion` / `verdict` from the JSON and is tolerant of new
keys; every other consumer reads the text render, where notes are additive lines.

**`sk_health.py` takes the classing.** `allocation_near_misses()` walks the log's
`###` lines in order and pairs each offender with the next well-formed entry after
it — present → settled with its `superseded-by`, absent → live. Live near-misses
become `Finding`s; settled ones become notes. One further correction rides the same
predicate (D183): **`no allocation entries` no longer fires when unparsed `###`
lines are present** — that sentence aims the fix at whoever would create the log
when the real repair is one line away, which is D-O58's own error one layer down.

### Tests

`check-m.sh` 59 → **71** (+12) · `check-gate.sh` 67 → **77** (+10). **Behavioural,
not textual, and staged as one story on one estate:** the fixture's last well-formed
entry is rewritten into **the exact ledger grammar the field produced**, and the run
must FAIL, name the line, prescribe *supersede*, forbid *edit*, **block** (rc ≠ 0),
and **not** say `no allocation entries`. The corrective append the law prescribes is
then made — and the same near-miss must flip to **PASS**, stop blocking (rc = 0),
**keep its NOTE** with `superseded-by Allocation 3`, and leave the gap count. A
third append adds a **trailing, unsuperseded** near-miss: the assertion goes FAIL on
it while the settled note **survives that FAIL** — the assertion that proves the
channel earns its existence. `check-gate.sh` pins the nine doc surfaces plus one
negative: **the contract's CC-H-02 row is asserted unedited.**

**Suite 17/17 GREEN**, verified in isolation from the companion pass (D184), after
one red-to-green of this pass's own making — `GATE_DOC` used above its definition —
and one repeat of 0.1.20's own slip: **backslash-escaped quotes inside single
quotes**, which `grep -F` takes literally. Second occurrence in two passes (D182).

### Files

| File | Change |
|---|---|
| `docs/methodology/…-gate-definition.md` | v0.9 → **v0.10** — §10.4's classing block · header change record · footer |
| `payload/specify-overlay/ba/scripts/sk_structure.py` | the `notes` channel — `Verdict` field · `as_dict` · `fail`/`ok` · `emit` on both verdicts |
| `payload/specify-overlay/ba/scripts/sk_health.py` | `allocation_near_misses()` · the live/settled split in CC-H-02 · the conditional `no allocation entries` |
| `tests/check-m.sh` · `tests/check-gate.sh` | +22 assertions |
| `VERSION` | 0.1.20 → **0.1.21** |
| `BUILD-LOG.md` | this entry |

### Divergences — D182–D184

**D182 — the same escaping slip, twice in two passes.** `has` is `grep -Fq`, so a
pattern written `'…\"x\"…'` is searched for **with the backslashes**. It cost a
red-to-green in 0.1.20's `check-spine.sh` block and again here. Recorded as a
pattern, not an incident: single quotes already protect double quotes, and the
backslash is always wrong inside them.

**D183 — one correction beyond the ruling's own text, on the ruling's own logic.**
`no allocation entries` fired whenever no entry *parsed* — including when unparsed
`###` lines were sitting right there. Under (c) that sentence is exactly the
absence-claim D-O58 forbids, one layer below the dashboard, and it would have
rendered **beside** the live near-miss finding, sending the BA to T-17/T-18 while
the true repair was a one-line append. Now conditional on there being no near-misses
either. Named because the ruling did not ask for it and the predicate it uses is the
ruling's own.

**D184 — the companion pass is still in the tree, still untouched, still
quarantined.** Unchanged from 0.1.20's D180: its owner has not committed. Nothing of
it was edited, reverted, or staged; green was proven in a copy with its five
untracked paths removed and its `tests/layout.expected` edit reverted **in the copy
only**. This commit names its 7 paths explicitly. **No overlap** — this pass touched
the gate doc, two overlay scripts and two checks; the companion's set is disjoint.

### Version

`VERSION` 0.1.20 → **0.1.21**, one automatic patch increment for the whole pass
under D157. No minor is proposed and none is hinted at.

### Open

**D176 is closed; nothing from this pass stands open.** The near-miss has a class at
both layers now — the dashboard names it (D-O58), and the health check classes it
(D181), with the repair always legal and the acceptance instrument untouched.
**D181–D184 await ratification**, with **D172–D180** ratified 17 Aug 2026 and
**D164–D171 · D162–D163** committed beneath them. The hygiene backlog holds
**D160**. The **resolvability sweep** stands named and unbuilt from 0.1.19. One
observation, not a backlog item and not built: the gate document carries **no live
edition pin** in `check-gate.sh` while the orchestrator does — which is why gate
v0.9 → v0.10 moved no assertion. The companion Nutrivity estate pass stands
uncommitted in the tree, untouched, awaiting its own close (D184).


## The Band Gets Its Audit — Scope S lands corpus-first; the estimate removal collides with its twin and yields · package 0.1.22 · 17 August 2026 · GREEN

**Session prompt:** owner-directed pass (BA Lead, in-conversation ruling, remote
Cowork session): remove the WBS estimate columns, land the source audit
(`/ba-audit`) as a corpus-first companion set, and register the command across
the package surface.

### The collision, recorded plainly

While this pass prepared its estimate-column edits, a parallel session on the
owner's machine ruled and landed the same removal in fuller discipline —
**D-O60, orchestrator v0.24, §28 review record** ("the export ends at Phase").
The mtime guard rejected this pass's writes to the three collided files —
`ba-native-spec-orchestrator-rules.md` · `ba-wbs/SKILL.md` · `sk_wbs.py` — and
the D-O60 versions stand adopted; this pass's parallel copies are discarded.
Nothing was force-written. Files landed by this pass that serve the same
ruling: `tests/check-wbs.sh` (WANT header at eight columns; the empty-cells
assertion replaced by a no-estimate-header assertion; `N_ROWS` kept for the
xlsx row-count check) and `VERSION` 0.1.21 → **0.1.22** — the reconciliation of
this entry against the D-O60 session's own close, if it writes one, belongs to
the ratification sweep.

### The source audit (Scope S), corpus-first

New companion document `docs/methodology/ba-native-spec-source-audit-definition.md`
— the band-level source-fidelity audit: obligations register (OB rows, the
union rule, comment-is-not-a-carrier, the critic pass) · forward and backward
traces · eight CC-S assertion families · one prompt point **P-A1 —
source-audit ruling** (that document's own, as the gate's P1–P8 are the
gate's; §10.1's boundary sentence) · `SA-<nn>` source acceptances · the repair
route by dispatch and routing · incremental re-audit · `audit escape` filings
to gate-tuning. Compiled units landed: `payload/claude/skills/ba-audit/SKILL.md`
(standing blocks byte-identical) · `payload/specify-overlay/ba/cards/assertions-s.md`
· `payload/specify-overlay/ba/templates/source-audit-report-entry.md` ·
`tests/fixtures/nutrivity-audit/expected-findings.md` (the golden case: 18
must-fire rows, 4 negative controls) · `tests/layout.expected` rows (three
files + one RT-absent ledger) · the mirror command row (`claude-block.md`;
Workflow 16 → 17, "All 34" → 35). Origin on the record: the Nutrivity band
evaluation of 14 August 2026 (77 obligations, findings S-01…S-23), delivered
as the evaluation workbook and report.

### Files touched by this pass — 10

`docs/methodology/ba-native-spec-source-audit-definition.md` (new) ·
`payload/claude/skills/ba-audit/SKILL.md` (new) ·
`payload/specify-overlay/ba/cards/assertions-s.md` (new) ·
`payload/specify-overlay/ba/templates/source-audit-report-entry.md` (new) ·
`tests/fixtures/nutrivity-audit/expected-findings.md` (new) ·
`tests/layout.expected` · `tests/check-wbs.sh` · `payload/mirror/claude-block.md`
· `BUILD-LOG.md` · `VERSION`.

### Open

The §10.5 remainder (the label header · boundary/billable marking) stands
deferred as D-O60 leaves it. The audit's own suite (`check-audit.sh`) and
`sk_audit.py` for the M share stand named and unbuilt — until then the skill's
pinned agent procedure governs the M share. This pass's owner rulings await
the ratification sweep, alongside any close the D-O60 session writes. First
calibration run of `/ba-audit` against the Nutrivity golden case stands next.
Verification: `tests/run-all.sh --file-only`, with `check-wbs.sh`,
`check-register.sh` and `check-layout.sh` the interested checks.

## The Export Ends at Phase — the estimate columns removed, the carry item closed by removal, owner-ruled · orchestrator v0.24 · package 0.1.22 · 17 August 2026 · GREEN

**Session prompt:** owner-directed pass (BA Lead, in-conversation ruling): remove
the two estimate columns from the WBS export end to end — *we do not use them at
all; estimates are the client's concern; the WBS ships without estimate columns*
— under the one-way rule, source document first, then package, then tests. The
standing carry item was named in the prompt as **resolved by the decision**, to
be recorded as such rather than left dangling.

### The ruling — D-O60, and why removal beats an empty column

For eleven editions §10.5 rendered two headers the framework guaranteed never to
fill. That guarantee — T-18's never-numeric depth rule, restated at D-O44(b) —
was carried by **behaviour**: every run had to remember to emit the pair empty,
and one defect in the row model would have put a number under a header with the
framework's own name on it. **Removal moves the guarantee to structure.** There
is no cell to fill, no always-empty assertion to keep passing, and no blank
rendered to the client to read as something the framework meant to compute and
could not. Estimating is the client's act and stands outside the export.

**The §16 carry item is closed by removal, not by finalization.** It had asked
*what the exact estimate header set should be* and waited since 10 August 2026 on
the company sample WBS to answer it. The answer is that the question was the
wrong one: there is no header set left to finalize. Closed at its own site with
the date and a pointer to §28 — the sentence recording what it asked stands
beside the ruling that closed it, since a carry item is a live obligation and not
a historical claim.

**Document first, then the package, then the tests.** Orchestrator v0.23 →
**v0.24**: the change record at head · §10.5's pinned columns now eight, ending
at Phase, with the removed row replaced by the absence law · §10.5's regeneration
clause · §8.1's two estimate-dependent clauses trued (the deferral line, and the
capacity check's *the Estimate columns stay empty by law*) · §16's carry item
closed · **§28, the review record, carrying D-O60** · the footer chain. **D-O42's
and D-O44's locked rows are not rewritten** — both name the empty columns, and
both are amended on the record by D-O60's row, per the house convention the
D-O52 → D-O59 pattern set.

### The one bump, split — recorded so nothing dangles

D-O42 deferred **three** items to a single §10.5 rework and ruled they travel as
one bump: this removal, the **client-label header**, and **boundary/billable
marking**. Only the first was ruled here. The other two are recorded as **still
deferred**, at §8.1 where the deferral lives and again at §28 — spending a bump
on one of its items does not close the rest, and a bump recorded as spent would
have retired two rulings nobody ruled on.

### Files

| File | Change |
|---|---|
| `docs/methodology/…-orchestrator-rules.md` | v0.23 → **v0.24** — the change record · §10.5 pinned columns + regeneration clause · §8.1 ×2 · §16 carry item closed · **§28 (D-O60)** · footer |
| `payload/claude/skills/ba-wbs/SKILL.md` | the pinned-columns table (row gone, absence law stated) · the derived-never-hand-edited bullet · the never-list — *never renders an estimate column* |
| `payload/specify-overlay/ba/scripts/sk_wbs.py` | `COLUMNS` and `WIDTHS` at eight · the pair dropped from `cells()` · the header comment · the summary's closing line |
| `payload/specify-overlay/ba/scripts/sk_xlsx.py` | one docstring sentence — the empty-cell styling no longer justified by columns that no longer exist; the behaviour is unchanged |
| `tests/fixtures/appointment-booking/expected/` | both golden csvs regenerated — `wbs-discovery.csv` · `wbs-presale.csv`, verified equal to the old files minus exactly the two columns |
| `tests/check-wbs.sh` | the generator-level absence guard, added **on top of** the collided pass's header guard (D187) · the exec bit restored (D186) |
| `tests/check-orchestrator.sh` | the live edition pin v0.23 → **v0.24** · the D-O contiguity range 1…59 → **1…60** |
| `tests/presale-path.md` | Interaction 7's *green when* — the column set ends at Phase |
| `tests/fixtures/nutrivity-audit/expected-findings.md` | **NC-03** rewritten: no estimate column exists in the export; one appearing is a regression |
| `BUILD-LOG.md` | this entry |

**Suite GREEN**, verified in an isolated snapshot rather than in the live tree,
because a parallel pass was writing to it during the run (D185): `check-wbs.sh`
**64 / 0**, and `tests/run-all.sh --file-only` **14 checks, 0 red, 3 skipped**
(the install-based three, as `--file-only` intends). No red-to-green of this
pass's own making.

### Divergences — D185–D188

**D185 — two passes, one removal, in one tree.** A parallel Cowork session ruled
and landed the same removal in the same sitting; its own entry above records the
collision from its end and yields, adopting D-O60 · v0.24 · §28 as the version of
record. From this end: **nothing of that pass was reverted, staged, or
force-written.** Its two landed files stand — `tests/check-wbs.sh`'s header guard
and `VERSION` 0.1.21 → 0.1.22 — and this pass built on top of both. Recorded as
the pattern D184's quarantine anticipated, now with the sets **overlapping**
rather than disjoint: the resolution was to build on the other pass's landed
edits with relative targets, never to replace them.

**D186 — the collided write cost `check-wbs.sh` its exec bit.** The file came
back `100755 → 100644` (mode `-rw-------`). `run-all.sh` invokes each suite as
`"$@"`, by path — so the WBS suite would have died on a permission error before
reaching a single assertion, and the failure would have read as a broken check
rather than a lost mode. Restored to 755. Named because a mode is invisible in a
content diff and this is the second class of damage a collided write can do.

**D187 — the header guard is not enough; the guard belongs one layer down.** The
flipped assertion reads the rendered golden csv for an estimate header. But the
goldens are **regenerated from the generator** — so a pass that re-added a column
to `COLUMNS` and regenerated the goldens in the same sitting would satisfy a
header-only guard with a file that carries the column. **A self-fulfilling
assertion.** The guard added here reads `sk_wbs.COLUMNS` and `sk_wbs.WIDTHS`
directly: eight columns, none named estimate, and the width vector cut in step —
the last catching the `ValueError` the xlsx writer would otherwise raise at run
time. The absence is now asserted where the column would be re-added, not only
where it would land.

**D188 — the doc bump moved two assertions no estimate grep predicts.**
`check-orchestrator.sh` pins the live edition (`v0.23`) and asserts the D-O block
runs contiguously (`set(range(1, 60))`). Neither contains the word *estimate*, so
neither appears in the prompt's grep of `tests/`, and both go red the moment the
document takes a new edition and a new decision number. Recorded as the standing
cost of a D-O allocation: **an orchestrator ruling is never a one-file test
change**, and the two pins are where it always surfaces.

### Version

`VERSION` stands at **0.1.22**, taken by the parallel pass under D157 for this
sitting. **No second increment:** D157 rules one automatic patch bump per build
pass, and both passes are one sitting against one package — a second bump would
claim two releases for one change.

### Open

**The §10.5 remainder** — the client-label header and boundary/billable marking —
**stands deferred**, carried at §8.1 and §28 as its own item now that the bump is
split. **D-O60 awaits ratification**, with D-O56–D-O59 ratified 17 Aug 2026
beneath it. **D185–D188 await ratification.** The hygiene backlog holds **D160**;
the **resolvability sweep** stands named and unbuilt from 0.1.19. The commit is
**withheld**: the tree carries the parallel pass's Scope-S estate — five
untracked paths and its `tests/layout.expected` edit — and the two passes' records
now reference each other, so the sitting closes as **one commit, the owner's**.

## The Audit Meets Word — Stage-0 readability, renderings as capture completion, dispatch resilience · package 0.1.23 · 17 August 2026 · GREEN

**Origin:** the first Scope-S calibration run (Nutrivity, 18 specs, 118-row
register, both traces built, no unaudited ground). Two escapes, filed here and
carried on the run entry: (1) the `ba-gate` subagent's toolset — Read/Grep/
Glob — cannot parse a `.docx` capture, so a `Sources:` line can read
`captured` while the A pass is structurally blind to the file; the executor
recovered mid-run by extracting verbatim plain text for all five documents.
(2) An API connection drop killed a dispatch; the retry correctly rebuilt
nothing.

**Ruled into the corpus and the skill (owner sitting):** the readability
rule — a binary capture is audit ground only through a sibling mechanical
rendering `sources/<name>.extracted.md`; Stage 0 produces a missing rendering
as capture completion, the audit's one permitted pre-ruling write, each
landing on the run entry · dispatches receive renderings only, and a dead
dispatch is re-dispatched with Stage-1 outputs as the resume point.

**Files touched — 4:** `docs/methodology/ba-native-spec-source-audit-definition.md`
· `payload/claude/skills/ba-audit/SKILL.md` · `BUILD-LOG.md` · `VERSION`
(0.1.22 → **0.1.23**, one patch increment under D157).

**Open:** the upstream fix — capture-time renderings at `/ba-frame`
(orchestrator §8.1) so Tier-2 mining reads the same ground — stands named for
the next orchestrator bump. `check-audit.sh` · `sk_audit.py` unchanged
standing.

## The Capture Is Readable and the Amend Names Its Members — run-1 lessons ruled in · orchestrator v0.25 · package 0.1.24 · 17 August 2026 · GREEN

**Session prompt:** owner-directed close of the first Scope-S calibration
(run 1, fresh Nutrivity band): rule the run's three lessons into the corpus so
the next iteration starts clean.

**Ruled (owner sitting, no new decision numbers):** the **§8.1 readability
clause** — a binary capture (docx · xlsx · pdf) lands with a sibling
mechanical rendering `sources/<name>.extracted.md`; readers read the
rendering, the original stays the capture of record; D-O46/D-O47 locked
wording untouched, clause additive (orchestrator v0.24 → **v0.25**; `ba-frame`
skill compiled in step; the audit's 0.1.23 Stage-0 completion becomes the
fallback instance) · the **amend-enumeration rule** — an `amend` row names
every item it covers; ruling over unnamed members is invalid render
(definition §5 · skill Stage 3; run-1 cost: a mandatory scenario's carrier,
flipped by the BA) · the **no-a-priori-context rule** — no source document is
`context` as a whole; modality reads per statement (definition §2; run-1:
`FORM:411` grounded an orthography convention).

**Recorded:** `tests/fixtures/nutrivity-audit/run-1-outcome.md` — the second
calibration point beside the pinned August key: precision clean (4/4 NC, zero
false positives), 4 same-class fires, 12 band-fixed, 2 challenged-and-cleared
with evidence.

**Files touched — 8:** orchestrator rules · `ba-frame/SKILL.md` ·
`ba-audit/SKILL.md` · source-audit definition · run-1-outcome.md (new) ·
`tests/check-orchestrator.sh` · `BUILD-LOG.md` · `VERSION` (0.1.23 →
**0.1.24**). **The suite's live-edition pin moves with the edition:**
`check-orchestrator.sh` pins the header at **v0.25** and demotes the
superseded **v0.24** to a change-record `has` — the suite edit belongs to the
sitting that moved the edition.

**Open:** `check-audit.sh` · `sk_audit.py` stand named and unbuilt; the
ratification sweep covers this sitting's owner rulings with the prior ones.
Nothing else from run 1 stands open — the band closed at zero gaps, zero
ungrounded, zero contradictions.

## The Grant Learns What It Costs — the AUTO-mode fix set · orchestrator v0.26 · package 0.1.25 · 17 August 2026 · GREEN

**Session prompt:** apply the AUTO-mode fix ruling handed over from the first
end-to-end `/ba-auto` run on a live Presale engagement (17 Aug 2026). Four
rulings, framework-only scope, register per the review-record convention.

**The trace the ruling came from.** The run took Band 1 and Band 2 correctly and
then held for good: *"Band-3 entry is blocked — it reads the parent brief's
slicing row at `.specify/memory/scope/<epic>.md`, and no brief exists."* Three
defects sit under that one sentence. The grant reached **recommended** acts
only, and under Presale **Tier 1 — epic scoping** can never be recommended — no
AT criterion demands a brief, because briefs are Band-2 ground and Band 2 is
aspect-less (D-O1) — so the one act that produces briefs was permanently out of
reach of the one mode meant to run without the BA, **on every project**. The
arming request sat outside the grant, so the run stood **"closed but unarmed"**
and Band 2 executed with Scope H silently disarmed. And the resumption report
rendered an un-electable act as *"next act … blocked"* — failure framing for a
pending choice.

**Ruled (BA Lead, applied as ruled; D-O61–D-O64, §29, orchestrator v0.25 →
v0.26):** the **cost boundary** — *AUTO may self-elect any act that spends no
client access and makes no external commitment; every self-election lands in the
ratification batch like any other AUTO act* — replacing the `recommended`
proxy, with the Presale dead end closed by a pinned instance at Band-2 exit
(Tier 1 in ingest mode over captured material, kit and brief per first-phase
epic, then P-O8 → Tier 2 → draft specs) while **the client call stays the BA's
election** · the **arming run inside the grant** as P-O7's closing step, gate P8
riding the ratification batch, the request/run split untouched · the **render
rule** — `Destination reached … extension available by election: …`, never
`blocked`, extending D-O26 from one read-only render to every render an auto run
makes · **§10.7 ruled the mode's corpus home**, the four hold conditions named.

**Untouched, deliberately:** the safety floor's four acts · thresholds ·
assertions · gate law · the §10.2 session boundary · every pinned shape (D-O63
rules what fills a slot, never the slot). **No engagement run was edited,
resumed or patched** — the held run of 17 Aug 2026 stands as the failing
baseline a fresh run is measured against.

**One reading recorded, not invented.** The handoff's *"Kit mode — a live client
call — remains BA-elected"* is applied as: the **kit artifact** is written (its
own verification trace expects *briefs + kits generated for all first-phase
epics*, and ingest mode cannot parse without the kit as its frame), and **the
call** — the thing that spends a person's time, which is the rationale the
ruling gives — is what stays the BA's election.

**Files touched — 17:** orchestrator rules (§6.5 · §8.2 · §10.7 · §29 · header ·
footer) · `ba-auto/SKILL.md` · `ba-orchestrator.md` · `mirror/claude-block.md` ·
`mirror/AGENTS.md` · `ba-close-band1/SKILL.md` · `ba-gate-health/SKILL.md` ·
`ba-tier1/SKILL.md` · `ba-enter-feature/SKILL.md` · `docs/quickstart.md` ·
`README.md` · `tests/check-auto.sh` · `tests/check-orchestrator.sh` ·
`tests/check-layout.sh` · `tests/check-install.sh` · `BUILD-LOG.md` · `VERSION`
(0.1.24 → **0.1.25**).

**The suite:** `check-auto.sh` gains **section 8** (D-O61–D-O64) and a third
probe, `has_flow` — quote markers stripped, whitespace collapsed on both sides —
so one needle asserts the same law across the document and four compiled
surfaces however each wraps it. 143 → **208** checks. `check-orchestrator.sh`
pins the header at **v0.26**, demotes v0.25 to a change-record `has`, and moves
the D-O contiguity range to 1…64.

**Three incidental corrections, made in step and named here rather than made
quietly — none of them this ruling's:**

1. **`check-layout.sh` and `check-install.sh` hardcoded 34 `/ba-*` skills** while
   the package has shipped **35** since `/ba-audit` landed at 0.1.22 and
   `layout.expected` registered it by name. The three install-based runs were
   therefore **red at HEAD, before this sitting** — verified against a clean
   `git archive HEAD` copy, not assumed. Constants moved to 35 (`15 workflow +
   20 technique`); the manifest itself needed nothing.
2. **`docs/quickstart.md` stated the safety floor as three acts** — pre-D-O42,
   missing the scope frame. Now four.
3. **`README.md` said three seeded floor breaches** where `check-auto.sh` has
   seeded four since the scope frame landed. Now four.

**Verification stands where the ruling put it:** a **fresh** auto run over
captured inputs, not a patched one. Expected trace — Band-1 closure ending with
the arming entry in `.specify/gate-health.md` → briefs and kits for every
first-phase epic → features into Band 3 → draft specs with markers → holds only
for batch ratification and open-question answers, epics whose slicing depends on
an open question flagged with their briefs still produced.

**Open:** nothing from this ruling. `check-audit.sh` · `sk_audit.py` stand named
and unbuilt from the prior sitting; the ratification sweep covers this sitting's
rulings with the prior ones.

## The Frame Hears the Negotiation — EC-10's scope-decision harvest + the §10.5 render pair · orchestrator v0.27 · package 0.1.26 · 19 August 2026 · GREEN

**Session prompt:** the Lane B compile pass — propagate the four bumped
documents into the runtime (orchestrator v0.27 · catalogue-b6 v0.5 ·
elicitation v0.8 · catalogue-b1 v0.6). Compiled units only; the one-way rule in
force.

**The escape this pass opened with, and how it closed.** The pass halted at its
own precondition before touching anything. The EC-10 / §10.5 doc sitting had
branched from package 0.1.24 (orchestrator v0.25, D-O1–D-O60) and never saw
package 0.1.25's orchestrator **v0.26 — the AUTO-mode fix set** (D-O61–D-O64).
The working-tree document therefore **double-allocated v0.26 and D-O61–D-O63,
dropped D-O64, and deleted the shipped edition outright** — 54 deleted lines
against HEAD, `self-elect` · `cost boundary` · `Destination reached` all at zero
occurrences, the footer's locked range regressed to D-O1–D-O63. Six compiled
runtime surfaces were left carrying law their own corpus no longer contained —
the one-way rule running backwards — and the tree stood **RED at 26 failures**
before a single edit. Nothing was compiled; the collision was reported instead.
**Resolved the same day by rebase** (BA Lead, 18 Aug 2026): the sitting's three
rulings renumbered **D-O61–D-O63 → D-O65–D-O67**, its review record re-sited
**§29 → §30**, the header taken to **v0.27**, the locked range to D-O1–D-O67,
and a provenance note written into the change record. **The AUTO-mode fix set is
untouched** — D-O61–D-O64 and §29 stand exactly as 0.1.25 shipped them. The
three sibling documents were re-pointed to v0.27 / §30 / D-O65–D-O67 with zero
D-O61–D-O63 residuals. This pass then compiled against the rebased editions.

**What the ruling gives the runtime.** **The scope-decision harvest (D-O65)** —
P-O0b auto-pickup extends from the budget line to negotiated engagement-scope
decisions as a class, each captured `SD-<n> — <the decision, one line>
(<verbatim citation>)` under cite-or-mark, `none found` a legal recorded state,
an ambiguous candidate asked inside the block and never guessed. The home is
**line 4 of the P-O0b pinned block** and the **`Scope decisions:` head line**.
Late arrival is zero new machinery: the routed scope-frame-change proposal, the
`scope-frame` event and the correction stop, all by reference · **the precedence
principle (D-O66)** — an SD governs allocation, never discovery; stated once at
the orchestrator and cited everywhere else, never restated · **the carried
§10.5 pair (D-O67)** — the pinned set becomes **nine columns ending at
Billable**, `Yes`/`No` derived from the row's Phase against the head's
`Boundary:` set and **blank on a blank Phase**; the **xlsx title block** carries
the client label verbatim with the delivery-boundary line, **the csv staying
pure rows**; the read set gains the head's `Client label:` and `Boundary:`
fields.

**The never-numeric guarantee stands.** No estimate column returns. Billable is
a derived `Yes`/`No` and never a number, so the guarantee is held by structure
exactly as D-O60 left it — and the suite's tail assertion moves from *ends at
Phase* to *ends at Billable* rather than being dropped.

**Files touched — 24:** the four methodology documents (owner-supplied, rebased)
· `ba-frame/SKILL.md` · `ba-status/SKILL.md` · `ba-t01/SKILL.md` +
`references/example.md` · `ba-t18/SKILL.md` + `references/example.md` ·
`ba-wbs/SKILL.md` · `ba-analyst.md` · `ba-discovery.md` ·
`templates/aspect-state.md` · `scripts/sk_wbs.py` · `scripts/sk_xlsx.py` ·
`tests/check-wbs.sh` · `tests/check-spine.sh` · `tests/check-orchestrator.sh` ·
`tests/check-band2-artifacts.py` · `tests/presale-path.md` · the two golden
`expected/wbs-*.csv` files · `BUILD-LOG.md` · `VERSION` (0.1.25 → **0.1.26**).

**The suite: 1830 checks, 17 of 17 green.** `check-wbs.sh` 64 → **80** — the
column-tail assertions flipped to nine-ending-at-Billable, a new section 2b
running a **seeded frame** through the derivation (in-boundary `Yes`,
out-of-boundary `No` under a narrowed boundary, blank on blank, nothing but
Yes/No ever), the xlsx title block read back off the sheet with the label
verbatim and the budget absent from it, the csv asserted to open on its column
row, an open label rendering the project name alone, and **two seeded-defect
controls** — a set that loses its tail, and a csv that grows a title block.
`check-spine.sh` 189 → **206** — the T-18 SD consumption asserted on the sheet,
plus **four seeded allocation-log fixtures**: a `BA-directed (SD-1)` row that
must validate, a factor-tagged row that must behave exactly as before the ruling
(the regression guard), and two defects caught by name — **B80** (an untagged
reason) and **B82** (an SD tag does not license a new epic).
`check-orchestrator.sh` pins the header at **v0.27**, demotes v0.26 to a
change-record `has`, adds the D-O65–D-O67 block and moves the D-O contiguity
range to 1…67.

**Three incidental corrections, made in step and named here rather than made
quietly — none of them this ruling's:**

1. **`check-band2-artifacts.py`'s B80 accepted only the four factors.** The §5
   Reason grammar has pinned `BA-directed` since D-B6-9, so a directed row has
   been failing the validator ever since — the gap was invisible only because no
   fixture carried one. B80 now accepts a factor, `BA-directed`, or
   `BA-directed (SD-<n>)`, and its rule text says so.
2. **`ba-t01/references/example.md`'s canvas row 13 never carried the
   scope-frame mirror at all** — the D-B1-5 clause was ruled but never compiled.
   Re-extracting the row for D-B1-7 brought both halves.
3. **`ba-t18/references/example.md`'s Reason cell read `<factor(s)>` alone** —
   pre-D-B6-9. It now carries the full pinned tag set.

**One reading recorded, not invented.** §10.5 rules Billable blank on a blank
Phase but does not name the absent-**boundary** case. It is taken as blank on
the section's own *never invents* clause — *an absent source renders an empty
cell, never a guess* — rather than defaulting to `Yes` or `No`. Flagged to the
master conversation rather than settled here.

**Open:** nothing from this ruling. `check-audit.sh` · `sk_audit.py` stand named
and unbuilt from the earlier sittings; the ratification sweep covers this
sitting's rulings with the prior ones.

## The Standing Advisory Becomes a Decision — EC-11 + EC-13 + Рт5 propagated · orchestrator v0.28 · catalogue-b6 v0.6 · package 0.1.27 · 19 August 2026 · GREEN

**Session prompt:** the Lane B compile pass — propagate the two bumped documents
into the runtime (orchestrator v0.28, D-O68–D-O71, §31 · catalogue-b6 v0.6,
D-B6-14–D-B6-15). Compiled units only; the one-way rule in force. Owner-directed
through commit and push.

**Precondition, clean.** HEAD `acdff37`, VERSION 0.1.26, tree carrying exactly
the two owner-supplied documents. The orchestrator stood at v0.28 with the
D-O68–D-O71 change record, §31, the footer locked range D-O1–D-O71 and base
commit `acdff37` stamped; catalogue-b6 at v0.6 with D-B6-14–D-B6-15; elicitation
v0.8 and catalogue-b1 v0.6 untouched. Baseline residual: `check-orchestrator.sh`
305 / 4 — the header pin at v0.27, the D-O contiguity range at 1…67, the §2.4
`Sources:` exhibit and the byte-identity of ba-frame's pinned inventory block.
All four are this pass's own consumers; they were taken, not reported as a stop.

**What the ruling gives the runtime.** **The standing-advisory register
(D-O68)** — a `Scope advisories:` head line joins §2.4's standing-instrument
group, one `ADV-<n>` per standing scope-frame advisory finding with its epic and
its state (`standing` · `accepted <date>` with an event-shaped revisit trigger ·
`none`). The head holds the machine-readable summary; the verbatim finding stays
in the plans-file run log, where D-B6-8 already put it. It is a register, not an
instrument — it joins no §4.3 table · **the advisory decision list (D-O69 ·
D-B6-14)** — the finding renders as one numbered list in the source-audit
definition's **P-A1 row shape, cited and never restated**: a conditional tail on
the band-boundary and resumption reports under a standing grant, and **T-18's
step-4 approval** in manual mode. Three dispositions, `hold as advisory — no
move` the default so `apply all` is a complete, safe ruling; a move riding
T-18's existing candidate machinery and **never an inline phase edit**;
`accept — <reason>` on the SA record pattern with its revisit trigger, and no
disposition ending a finding without a reason. Assembling the list may be AUTO;
**ruling it never is — an AG never answers it** · **the ADV tag (D-B6-15)** — the
§5 Reason tag set gains its third value, `BA-directed (ADV-<n>)`, so the finding
that moved a row survives into the allocation log · **the excluded source
(D-O70)** — `excluded — <reason>` joins the `Sources:` state vocabulary at
named-artifact grain, a container covering its contents: never captured, never
mined, and **a reference to one inside any capture is never followed** — with the
encounter recorded, one Events line per distinct excluded artifact per capture,
deduplicated, on the existing source grammar. No new event kind. Excluded
channels leave the D-O53 scan and leave `<N>`, named in one conditional line;
exclusions are switchable on the frame's precedent and late arrival is zero new
machinery · **Billable blank where no boundary stands (D-O71)** — codification of
§10.5's own never-invents clause, never a default `Yes` or `No`.

**The pinned shapes are untouched.** The band-boundary report's five lines and
the resumption report's six stand byte-identical to §10.7 in every carrier — the
suite's byte-match proves it, and the decision list is its own fenced block
appended after them. D-O45's inventory block gained one conditional line and is
byte-identical to §8.1 again.

**Files touched — 23:** the two methodology documents (owner-supplied) ·
`ba-frame/SKILL.md` · `ba-auto/SKILL.md` · `ba-close-band1/SKILL.md` ·
`ba-enter-feature/SKILL.md` · `ba-t18/SKILL.md` + `references/example.md` ·
`ba-status/SKILL.md` · `ba-audit/SKILL.md` · `ba-wbs/SKILL.md` ·
`mirror/AGENTS.md` · `mirror/claude-block.md` · `templates/aspect-state.md` ·
`scripts/sk_wbs.py` · `tests/check-ledger.py` · `tests/check-orchestrator.sh` ·
`tests/check-auto.sh` · `tests/check-spine.sh` · `tests/check-wbs.sh` ·
`tests/check-band2-artifacts.py` · the two fixture ledgers · `BUILD-LOG.md` ·
`VERSION` (0.1.26 → **0.1.27**).

**The consumer list, in full.**

1. **`ba-frame`** — Step 1's initial content names **five** standing-instrument
   head lines, the fifth the advisory register · the `Sources:` head line gains
   `excluded — <reason>` · a new *The excluded source* section carries grain, the
   law in three clauses, the encounter line with its dedup rule, the switchable
   clause and late arrival · the pinned inventory block gains
   `<k> channel(s) excluded by BA ruling` · the Slack scan filters excluded
   channels out of the ranking and out of `<N>` · the Events grammar gains the
   encounter line · the never-does list gains the exclusion law.
2. **The report surfaces** — the conditional decision-list tail on every carrier
   that renders either report: `ba-auto` (the full law — P-A1 shape, three
   dispositions, the ruling's home, the manual carrier, the autonomy clause),
   both mirrors (the same law, condensed), `ba-close-band1` and
   `ba-enter-feature` (the tail with its conditional rule, the law cited to
   `/ba-auto`). `ba-auto`'s never-does list gains *never answers the list*.
3. **`ba-t18` and the allocation machinery** — the advisory renders as a decision
   list with its three dispositions · the step-4 approval carries it, ruled row
   by row in the same breath as the diff, logged in this run's entry · the §5
   Reason tag set gains `BA-directed (ADV-<n>)` in the skill and in the worked
   example · `check-band2-artifacts.py`'s **B80** extends to the new tag.
4. **`ba-status` and the shipped ledger template** — the `Scope advisories:` head
   line beside the other four, the `Sources:` fifth state, and the template's
   event exhibit gains the encounter line.
5. **`ba-wbs` and `sk_wbs.py`** — the Р5 sentence carried at the Billable column
   rule and in the no-estimate paragraph; `billable_cell`'s docstring records
   that its absent-boundary behaviour is now **law rather than a reading**. The
   exporter's behaviour is unchanged — it already rendered blank.
6. **`ba-audit`** — a consumer the map did not list, and not a self-resolution:
   D-O70's never-follow clause reaches *any* capture, and Scope S is the
   framework's other capture reader. Its Stage-0 `Sources:` read enumerated three
   states; it now enumerates the fifth as unaudited ground with its reason — an
   exclusion hides nothing and is never a gap to fill — and it never follows a
   reference that resolves to an excluded artifact.

**The suite: 1930 checks, 17 of 17 green** (1826 → 1930).
`check-orchestrator.sh` 305 → **349** — the header pinned at v0.28, the
D-O68–D-O71 block and §31 asserted, the D-O contiguity range moved to 1…71, the
`Sources:` head-line sweep taken to five states, and two new sections: **5d** the
excluded source (the law's three clauses at the document, the encounter line in
all three carriers, the never-follow clause at both capture readers, the scan
filter, and the validator live) and **5e** the register with its decision list
(the head line in all three carriers, the P-A1 citation, the three dispositions,
the ruling's home, the manual carrier, the autonomy clause), plus **5f** D-O71's
sentence at §10.5 and at `ba-wbs`. `check-auto.sh` 208 → **250** — the tail
asserted on all five report carriers, the law on the three that state it, and a
**seeded control**: a standing advisory that reaches no report tail goes red.
`check-spine.sh` 206 → **221** — T-18's decision-list half on the sheet, the
`hasnt` guard that the P-A1 shape is cited and not restated, and **two new seeded
fixtures**: a `BA-directed (ADV-1)` row that must validate, and an untagged ADV
move caught by name as **B80**. `check-wbs.sh` 80 → **83** — a seeded frame that
stands and names **no boundary**, asserting the render still carries phased rows
(the case is not vacuous) and that every Billable cell is blank.
`check-ledger.py` **14 → 16 rules** — the source-state vocabulary opened to five,
the `encounter — not followed` form recognised as a form and not a state, and two
new rules: **L15**, an artifact standing `excluded` that is captured anyway, and
**L16**, the encounter guard — a capture referencing an excluded artifact with no
encounter line — enabled by a new `--captures <dir>` argument. Both are seeded
and both fail by name.

**Divergences — six, none self-resolved.**

1. **§8.1's D-O53 paragraph still reads "its four-state vocabulary is closed"**
   (the declined-candidate rule) while D-O70 makes the vocabulary five. The
   edition amended D-O48's vocabulary on the record and left D-O53's operative
   sentence at four. The document is compiled as written. At the carrier the
   sentence could not be: `ba-frame` had compiled it as *"its four states are
   closed … **Do not invent a fifth state.**"*, which would forbid the state the
   law now requires. Rendered as *"its state vocabulary is closed at the five
   below and nothing else: a proposal the BA did not take was never a source, and
   never gets a state of its own"* — the rule's force preserved (a declined
   proposal enters no ledger entry and never ages into a state), the count made
   true. **Flagged to the master conversation, not settled here.**
2. **D-O46's decision row reads "one of the four, never absence"** where §8.1's
   operative line now reads five. Same class as (1) — a locked row amended by a
   later ruling on the record. The carriers compile from the operative line.
3. **The encounter line's dedup is per (capture, artifact), but the pinned Events
   grammar names only the artifact.** A validator therefore cannot verify the
   per-capture dedup from the ledger. **L16 asserts the floor and claims nothing
   more** — referenced at least once → at least one encounter line, which is the
   *silence is impossible* half of the law. The dedup ceiling stands unasserted
   and is named here rather than approximated.
4. **`Scope advisories:` joins L1's required head lines.** A ledger written
   before this edition is now L1-illegal — the consequence every earlier head
   line carried. Two fixture ledgers gained the line:
   `band1/aspect-state.md` and `band1/negatives/base.md`.
5. **`ba-audit` was a consumer the map did not list** (item 6 above). Compiled
   from D-O70's *any capture* clause, not invented.
6. **One correction made in step, named rather than made quietly:** the new
   `ba-auto` disposition (b) text rendered a **bare `T-18`** on its second
   mention, which register rule 5 forbids — caught by `check-register.sh` in the
   same run and rewritten. The register sweep never regressed; this is recorded
   because it was a defect this pass authored, not one it inherited.

**The open queue item was left exactly as it stands, by instruction:** the xlsx
title block's delivery-boundary line still renders `not set` / `none` where no
boundary stands. D-O71 rules the **Billable cell**, not the title block, and no
edit reached it — it awaits its own ruling.

**Open:** nothing from this ruling. `check-audit.sh` · `sk_audit.py` stand named
and unbuilt from the earlier sittings; the ratification sweep covers this
sitting's rulings with the prior ones.

## Cross-Cutting Obligations Become First-Class — EC-01 + owner ruling Р8 propagated · orchestrator v0.29 · catalogue-b1 v0.7 · package 0.1.28 · 19 August 2026 · GREEN

**Session prompt:** the Lane B compile pass — propagate the two bumped documents
into the runtime (orchestrator v0.29 · catalogue-b1 v0.7). Compiled units only;
the one-way rule in force.

**Precondition, clean.** The orchestrator carried v0.29 with **D-O72–D-O77**,
§32 and the footer locked at D-O1–D-O77, base commit `506e58c` stamped;
catalogue-b1 carried v0.7 with **D-B1-8**; catalogue-b6 v0.6 and elicitation
v0.8 stood untouched; `git log --oneline -1` read `506e58c`, VERSION `0.1.27`.
The suite's only residual at baseline was the expected one — `check-orchestrator.sh`
pinned at v0.28 and D-O contiguity 1…71, this pass's own consumer.

**What the ruling gives the runtime.** **The cross-cutting obligations register
(D-O72)** — a `Cross-cutting:` head line joins §2.4's scope-frame group beside
`Scope decisions:`, one **`XO-<n>`** entry per obligation with its class ·
one-line value · verbatim citation · state. **Classes closed at five** —
language · device · accessibility · branding · compliance — a sixth only by
decision number on the record. **States closed at four** — `captured` ·
`carried — <unit>` · `accepted — <reason>` with its revisit trigger · `default`
— and **the line is never `none`:** the language engagement default always
stands. Runtime and standing, deliberately disjoint from the source audit's
per-run `OB-<nnn>` · **the capture (D-O73)** — **line 5 of the pinned P-O0b
block**, harvested by the D-O65 auto-pickup pattern, ambiguity asked as
`XO-? … keep or discard` inside the single Frame reply; mid-band, a fact
recognized under cite-or-mark in any later capture or mining pass appends its
entry and one `scope-frame` Events line — no new prompt point, no new event
kind, no new stop · **the language unit (D-O74 — owner ruling Р8)** — English
the **recorded** default, framework law as its own ground and never a fabricated
citation; a stated non-English or multi-language obligation **materializes as
one dedicated localization epic holding at least one cited story**, never only a
register line, a mark, a question or a comment · **the carry (D-O75)** — a
**third xlsx title-block line** rendering non-`default` entries, `none stated`
where only the default stands, **the csv untouched**; the generation summary
**names every entry not in a terminal state**, and the export never blocks ·
**the design guide (D-O76)** — a new `/ba-design`, read-only in the `/ba-wbs`
family, emitting `exports/design-guide.md` with its pinned `client provided
none` record · **`Delivery boundary: none stated` (D-O77 — Р7)**, closing the
open queue item 0.1.27 left standing.

**Р6, closed at its own site.** The last pass rendered §8.1's D-O53 sentence as
*"its state vocabulary is closed at the five below and nothing else"* because
the document still said four and the carrier could not compile a count the law
had overtaken — divergence 1 of package 0.1.27. The codification landed, and
`ba-frame` now re-extracts the document's own words: *"its **five-state
vocabulary** (D-O48 extended by D-O70) **is closed**, and a proposal the BA did
not take was never a source, and **never gets a state of its own.**"* The
divergence closes; nothing was self-resolved to close it.

**Files touched — 28.** The two methodology documents (owner-supplied) ·
`ba-frame/SKILL.md` · `ba-status/SKILL.md` · `ba-t01/SKILL.md` +
`references/example.md` · `ba-t17/SKILL.md` · `ba-tier2/SKILL.md` ·
`ba-wbs/SKILL.md` · **`ba-design/SKILL.md` (new)** · `mirror/claude-block.md` ·
`templates/aspect-state.md` · `templates/canvas-template.md` ·
`scripts/sk_wbs.py` · `scripts/sk_xlsx.py` · `tests/check-orchestrator.sh` ·
`tests/check-wbs.sh` · `tests/check-spine.sh` · `tests/check-ledger.py` ·
`tests/check-band2-artifacts.py` · `tests/check-layout.sh` ·
`tests/check-install.sh` · `tests/layout.expected` · the two fixture ledgers ·
`README.md` · `BUILD-LOG.md` · `VERSION` (0.1.27 → **0.1.28**).

**The suite: 17 of 17 green.** `check-orchestrator.sh` **347 → 409** — the
header pinned at v0.29, v0.28 demoted to a change-record `has`, the
D-O72–D-O77 block, contiguity moved to **1…77**, and two new sections: §5g (the
register in all four carriers, the closed vocabularies, line 5 of the pinned
block, the mid-band clause, the language unit across the orchestrator, T-17 and
Tier 2) and §5h (the third title-block line, the summary's naming, the
none-stated boundary, and `/ba-design` with its frontmatter, its destination and
its pinned none-record). Five new seeded defects, all failing by name — a sixth
class, a state outside the four, the line rendered `none`, a captured obligation
the register never received, and its own control showing the guard is keyed to
the register and not to the capture. `check-wbs.sh` **83 → 99** — the xlsx
reader moved to three title rows, the seeded frame grown a register, line 3 read
back off the sheet with its class · value · `(XO-<n>)` provenance, the
engagement default asserted **absent** from it, the citation asserted absent
too, the csv asserted still pure rows, `Delivery boundary: none stated ·
generated <date>` read back off the no-boundary render, and the summary's
`Cross-cutting — entries not carried:` line asserted to name the `captured`
entry and to stay silent on `carried`, `accepted` and `default`. Two new seeded
controls: a title block that lost its third line, and — running the generator's
own `title_block()` with D-O75's filter defeated — the default leaking into the
client's copy. `check-spine.sh` **221 → 232** — T-17's compiled unit form on the
sheet, plus five new roadmap fixtures: a carried obligation that resolves, an
`accepted` decline, the English default alone as the regression guard, and **two
defects by name — B104** for a stated non-English language that produced no spec
unit, and B104 again for a `carried` naming a unit the roadmap does not hold.
`check-ledger.py` **16 → 18 rules** — **L17**, the register's grammar (five
classes, four states, ids unique, `carried`/`accepted` carrying their unit and
reason, and never `none`), and **L18**, the harvest floor from the captures.
`check-band2-artifacts.py` **B71–B103 → B71–B104**, with a new `--frame`
argument. `check-layout.sh` **116 → 117** and the `/ba-*` registry moved from 35
to **36** (16 workflow + 20 technique), `check-install.sh`'s bootstrap count
with it.

**Divergences — six, none self-resolved.**

1. **D-O73's mid-band clause names no compiled unit.** It says a fact
   recognized *"in any later capture or mining pass"* appends its entry, and
   the corpus has four surfaces that mine. The clause is compiled **once**, at
   `ba-frame` — §8.1's carrier, beside D-O65's own late-arrival paragraph — and
   the mining surfaces reach it through the register they read rather than
   through a clause copied into each. Copying it into T-01, T-17 and Tier 2
   would have been four restatements of one rule, which the register rules
   forbid; naming it here rather than choosing silently.
2. **D-O74's story half is compiled but not asserted as a live join.** The
   epic half is decidable — the register names its carrier and the roadmap
   either holds it or does not — and **B104** judges exactly that. The story
   half needs a spec and a register handed to one validator together, which no
   harness does today; it stands as Tier 2's compiled drafting rule, asserted
   as text on the sheet. **The bound is written into
   `check-band2-artifacts.py`'s own docstring** beside B78's and B101's, not
   left to inference.
3. **L18's detection is marker-keyed, and it under-reports by construction.**
   Three of the five classes carry markers unambiguous enough to key on in
   captured client prose — language, accessibility, branding. **Device and
   compliance carry none**: every phrasing tried returned false positives on
   ordinary text, and a rule that cries wolf on a clean capture is worse than a
   rule with a stated floor. L18 asserts the floor and claims nothing more —
   the L16 pattern, and the rule text says so.
4. **`Cross-cutting:` joins L1's required head lines.** A ledger written before
   this edition is now L1-illegal — the consequence every earlier head line
   carried, `Scope advisories:` last sitting. Two fixture ledgers gained the
   line: `band1/aspect-state.md` and `band1/negatives/base.md`.
5. **`/ba-design` ships as a skill with no generator script.** §10.8 names
   none, and the act is extraction from client prose — palette values, asset
   references, stated brand constraints — which no parser can do. The layout
   manifest registers the skill alone, and `exports/design-guide.md` is
   runtime-born like the WBS pair.
6. **`docs/quickstart.md` was deliberately not extended.** It carries no
   `/ba-audit` row either — the last command added took the same route — so the
   file is a curated walkthrough and not a command registry. Named rather than
   skipped quietly.

**Five incidental corrections, made in step and named here rather than made
quietly — none of them this ruling's:**

1. **`ba-frame`'s Step-1 table read "the five scope-frame lines."** It has been
   six since D-O65 added `Scope decisions:` and was never updated. Now seven,
   and it names the `Cross-cutting:` line's birth value.
2. **`canvas-template.md`'s §13 row carried no scope-frame mirror at all** —
   D-B1-7's SD line was ruled 18 Aug and never compiled there, the exact
   sibling of last pass's `ba-t01/references/example.md` correction. Both the
   SD line and the XO line brought in step.
3. **`check-orchestrator.sh`'s banner claimed "14 seeded defects, one per
   rule"** while the file carried 18 rules and ran 22 seeded defects. Corrected
   to the true counts at both sites.
4. **`check-spine.sh`'s closing banner claimed 34 seeded defects** while the
   file ran 39 — the SD and ADV fixtures of the last two sittings never reached
   it. The per-rule section keeps its own 34, now said so.
5. **`README.md` read "byte-identical in all 34 skills"** — stale since
   `/ba-audit` landed. Now 36.

**The queue item 0.1.27 left open is closed by ruling.** The xlsx title block's
delivery-boundary line rendered `not set` / `none` where no boundary stood; the
last pass flagged it because D-O71 ruled the **Billable cell** and not the
block. **D-O77 rules the line** — `Delivery boundary: none stated · generated
<date>`, never an empty value — and `check-wbs.sh` reads it back off the sheet.

**Open:** nothing from this ruling. Routed by the edition and not built here:
the audit-side reconciliation family (runtime `XO` ↔ audit `OB`), the gate
consequence, and the design-guide **consumption** format — all three out of
scope by the document's own fences. `check-audit.sh` · `sk_audit.py` stand named
and unbuilt from the earlier sittings.

## The Deferral Answers to the Acceptance Shape — EC-02 propagated · orchestrator v0.30 · catalogue-b6 v0.7 · gate v0.11 · contract v0.3 · package 0.1.29 · 19 August 2026 · GREEN

**Session prompt:** the Lane B compile pass — propagate the four bumped
documents into the runtime (orchestrator v0.30 · catalogue-b6 v0.7 · gate v0.11
· contract v0.3). Compiled units only; the one-way rule in force.

**Precondition, clean.** The orchestrator carried v0.30 with **D-O78–D-O79**,
§33 and the footer locked at D-O1–D-O79, base commit `448384b` stamped;
catalogue-b6 carried v0.7 with **D-B6-16–D-B6-17**; the gate carried v0.11 with
CC-H-07's runtime and its named ledger-head read; the contract carried v0.3 with
the **CC-H-07** row and the count **62 (24 M · 38 A)**; catalogue-b1 v0.7 and
elicitation v0.8 stood untouched; `git log --oneline -1` read `448384b`, VERSION
`0.1.28`. The suite's residuals at baseline were the expected ones —
`check-orchestrator.sh` pinned at v0.29 and D-O contiguity 1…77, and
`check-cards.py` / `check-gate.sh` failing on the compiled A card the contract's
new row had overtaken. Three consumers, all this pass's own.

**What the ruling gives the runtime.** **The acceptance-shape register (D-O78)**
— an `Acceptance shapes:` head line joins §2.4's scope-frame group beside
`Cross-cutting:`, one **`AS-<n>`** entry per acceptance **item** with its
one-line item · verbatim citation · state. **Item grain** — a three-item pass
list is three entries, each independently checkable. **The class narrow by
ruling** — engagement-level shapes only, and **per-feature acceptance criteria
are spec ground (the contract's CC-AC's), never harvested**. **States closed at
three** — `standing` · `superseded — SD-<n>` (the later negotiated statement
controls: D-O66 · elicitation D13, recorded and never silent) · `accepted —
<reason>` with its revisit trigger — and **`none found` is a legal, recorded
state**, unlike the cross-cutting line the English default keeps non-empty.
Runtime and standing, deliberately disjoint from the audit's per-run `OB-<nnn>`
· **the capture (D-O78)** — **line 6 of the pinned P-O0b block**, harvested by
the D-O65 auto-pickup pattern, ambiguity asked as `AS-? … keep or discard`
inside the single Frame reply; mid-band and late arrival append the entry and
one `scope-frame` Events line, a newly standing entry re-asserting an `accepted`
advisory finding through D-O68's existing revisit trigger — no new prompt point,
no new event kind, no new stop · **the acceptance cross-check (D-O79)** — stated
once, at the frame surface: **no act that postpones or excludes scope completes
silently against a `standing` AS entry.** The four deferring acts named — an
epic allocated or held outside the delivery boundary, a slide-down candidate, an
SD-directed trim, a standing `out-of-scope.md` fence row. A match is a **named,
cited finding** taking an `ADV-<n>` id and rendering in T-18's existing step-4
decision list, ruled with the existing three dispositions — never a block at the
act, never silence, never a new surface · **the consumption (D-B6-16–D-B6-17)**
— the head's `Acceptance shapes:` line joins T-18's step-2 evidence read as
**ground the four locked factors read, never a fifth factor**, and the advisory
gains its **third reading rule** beside the ground-class and the SD rule: the
finding cites **both sides verbatim** and is tagged **`(AS-<n>)`** beside its
`ADV-<n>` id · **the backstop (contract v0.3 · gate v0.11)** — **CC-H-07**, the
conflicting pair the element, resolved by any recorded ADV disposition (`hold as
advisory` included — the BA saw it and chose visibility, which is a ruling) or
by the entry standing `superseded`/`accepted`; unresolved is a live H gap that
counts and blocks, with `HA-<nn>` the conscious valve.

**Files touched — 23.** The four methodology documents (owner-supplied) ·
`ba-frame/SKILL.md` · `ba-status/SKILL.md` · `ba-t18/SKILL.md` ·
`ba-gate/SKILL.md` · `ba-gate-health/SKILL.md` · `templates/aspect-state.md` ·
`templates/gate-health.md` · `cards/assertions-h.md` (recompiled) ·
`scripts/sk_snapshot.py` · `tests/check-orchestrator.sh` · `tests/check-gate.sh`
· `tests/check-cards.py` · `tests/check-ledger.py` · `tests/check-spine.sh` ·
`tests/check-band2-artifacts.py` · the two fixture ledgers · `BUILD-LOG.md` ·
`VERSION` (0.1.28 → **0.1.29**).

**The suite: 17 of 17 green.** `check-orchestrator.sh` **409 → 448** — the
header pinned at v0.30, v0.29 demoted to a change-record `has`, the D-O78–D-O79
block, contiguity moved to **1…79**, and one new section: §5i (the register in
all four carriers, the closed three states, `none found` legal, line 6 of the
pinned block, the mid-band re-assertion, and the cross-check's four deferring
acts with the supersession law and the CC-H-07 backstop). Four new seeded
defects, all failing by name — a state outside the closed three, a harvested
item with no verbatim citation, a `superseded` naming no `SD-<n>`, an `accepted`
carrying no reason — with `none found` asserted legal as the regression guard
that keeps L19 off the XO line's law. `check-gate.sh` **77 → 105** — a new §6c:
the contract's CC-H-07 row with its Checks set and its **A** class, the count
61 → 62 and the footer's seven project-health, the compiled card, §10.4's
element grain · resolved/unresolved classing · three run points · the named
ledger-head boundary, §10.2's roadmap and fence halves, and both compiled gate
surfaces. Live: an unresolved conflicting pair driven through the report writer
**blocks** — exit 1, `BLOCKED AT PRE-FLIGHT (1 H gap)`, the pair rendered as the
element in named-gap grammar, nothing else evaluated — and its control, an
`HA-<nn>` lifting it exactly as it lifts any H gap. `check-spine.sh` **232 →
253** — T-18's AS ground line and the third reading rule asserted from the
sheet, with `hasnt` holding the principle unrestated, plus six new roadmap
fixtures: a conflict named and cited on both sides, a `superseded` entry firing
nothing, a standing entry no deferral answers to, and **three defects by name —
B105** for a deferral completing silently against a standing entry, **B105** for
an AS-tagged finding missing its verbatim citation pair, and **B105** for a tag
naming no standing entry. `check-ledger.py` **18 → 19 rules** — **L19**, the
acceptance register's grammar (three states, ids unique, citation required,
`superseded` naming its SD and `accepted` its reason, `none found` legal) —
and `Acceptance shapes:` joins L1's required head lines.
`check-band2-artifacts.py` **B71–B104 → B71–B105**. `check-cards.py`'s pinned
Scope-H A-card count **3 → 4**, the card recompiled by `--record`.

**Divergences — seven, none self-resolved.**

1. **CC-H-07's compiled home is the A third, not `sk_health.py`.** The session
   brief named `sk_health.py` — the M third's script. **The contract's own §6
   class column says `A`**, and its change record's count moves 24 M · 37 A →
   **24 M · 38 A**: the M third is arithmetically untouched. So the assertion
   compiles at `cards/assertions-h.md` (via `check-cards.py --record`), at
   `ba-gate`'s A-third dispatch and at `ba-gate-health`'s A third, and
   `sk_health.py` is **not edited**. The law governed the brief, named here
   rather than reconciled quietly.
2. **The gate's §10.1 count cells still read "six CC-H."** v0.11 adds CC-H-07's
   run points at §10.4 and its map rows at §10.2 without renumbering §10.1's
   Full and Pre-flight cells, while the contract's own footer counts **7
   project-health**. A carrier cannot compile "six" at the very site where it
   dispatches seven, so `ba-gate`, `ba-gate-health` and `templates/gate-health.md`
   render **seven** — the Р6 precedent of package 0.1.28 (divergence 1) applied
   at its sibling site. **The documents are not edited.**
3. **The contract §7 worked example still totals "61 checked · 54 passed."**
   v0.3's change record says no other section moves, so the pinned example
   stands as the owner left it. `sk_snapshot.py`'s reconciliation docstring
   keeps the quoted figure verbatim and gains one clause naming it as
   pre-CC-H-07 history — the live pre-flight set is `SCOPE_H`, now seven — and
   `check-gate.sh`'s assertion label is untouched. Nothing self-resolved.
4. **`ba-t16` is deliberately not edited.** D-O79 rules a fence row **reached by
   the principle, never by editing its sheet**, and §33's conflict scan states
   catalogue-b5 (T-16) untouched. The fence row is checked at T-18's run and
   stands to CC-H-07 meanwhile; T-16's sheet gains nothing. Named rather than
   skipped quietly.
5. **No canvas mirror and no WBS title-block line for `AS`.** D-O78 gives the
   register the head and the cited source artifact only — unlike D-O72's `XO`,
   which took a catalogue-b1 §13 mirror (D-B1-8) and a §10.5 title-block line
   (D-O75). catalogue-b1 stands at v0.7 and §10.5 is untouched by this edition,
   so `ba-t01`, `canvas-template.md`, `ba-wbs` and `sk_wbs.py` gain nothing.
   The asymmetry is the ruling's, named rather than assumed away.
6. **B105's silence half under-reports by construction.** Whether a deferred row
   *conflicts* with an acceptance item is a judgement — which is exactly why the
   contract classes CC-H-07 as **A**. B105 judges the two decidable halves: the
   finding's **shape** (the `(AS-<n>)` tag names an entry the head holds
   `standing`; the row cites both sides, with the id tags stripped before
   counting so a row cannot cite itself) and a **stem-keyed silence floor on the
   epic name only** — the L18 / B78 pattern. A conflict worded any other way is
   CC-H-07's at the gate. **The bound is written into
   `check-band2-artifacts.py`'s own docstring** beside B78's, B101's and B104's,
   not left to inference.
7. **`Acceptance shapes:` joins L1's required head lines.** A ledger written
   before this edition is now L1-illegal — the consequence every earlier head
   line carried, `Cross-cutting:` last sitting and `Scope advisories:` before
   it. Both fixture ledgers gained the line at `none found`.

**No incidental corrections this pass.** Two banner counts moved and both are
this pass's own delta, not inherited staleness: `check-orchestrator.sh`'s
seeded-defect total **22 → 26** across **18 → 19** ledger rules, and
`check-spine.sh`'s **39 → 42**. §4's own "14 rules, 14 mutations" was verified
accurate and left alone.

**Open:** nothing from this ruling. Routed by the edition and not built here:
the reconciliation family (runtime `AS` ↔ audit `OB`) and §10.1's P-O0b act
cell, whose enumeration still omits cross-cutting obligations — a v0.29-era
omission §33 names and routes, deliberately untouched by scope discipline.
`check-audit.sh` · `sk_audit.py` stand named and unbuilt from the earlier
sittings.

## The Listing Declares Its Corpus — the second escape of one class, ruled at its site · orchestrator v0.31 · package 0.1.30 · 20 August 2026 · GREEN

**Session prompt:** land the maintainer defect report *"the Slack candidate
scan certifies its filter, not the workspace"* (Nutrivity run, 20 Aug 2026) as
a field note, rule D-O80–D-O81 into the orchestrator, compile the `ba-frame`
carrier, extend the harness, run the build pass. Documents first, then package.

**Precondition, clean.** `git log -1` read `3efa67e`, VERSION `0.1.29`, tree
clean. The orchestrator carried v0.30 with **D-O78–D-O79**, §33 and the footer
locked at D-O1–D-O79. **The suite had no residuals at baseline** — all 17
checks green, `check-orchestrator.sh` at **448**. Unlike every propagation
sitting since S2, this pass opens on a *field* origin rather than a bumped
document: nothing was pre-ruled, so the documents are written here and the
carrier follows them in the same pass.

**Origin — the escape, on the record verbatim.** A live `/ba-frame Presale`
run, project Nutrivity. The Slack candidate scan rendered *no match* over a
listing it described as complete. **The listing covered 225 of 705 channels.**
The target — `#est_nutrivity`, the project's own presale channel, private,
active in the workspace throughout — sat in the 480 the scan never enumerated,
and an entire naming convention (`est_<project>`, ~90 instances) was absent
from an enumeration reported as complete. **The scan obeyed every rule D-O53
and D-O54 state.** Those rules govern the retrieval **method** and never the
retrieval **corpus**, so *"paging the broad listing to completion"* is fully
satisfied by paging a **filtered** listing to completion: the rule was not
violated, it was simply not load-bearing. The BA caught it; nothing in the
framework could have. The report is written **byte-for-byte, unedited** — its
`.claude/` path references included — to
`docs/field-notes/2026-08-20-slack-scan-corpus-miss.md`, because it records the
run as it happened and a post-mortem edited to match the repo is a post-mortem
that has already started lying.

**What the ruling gives the runtime.** **The listing's corpus (D-O80)** —
**the corpus is every channel the workspace holds, both visibilities and every
archive state**, and a retrieval parameter left at its default is **presumed
narrowing**: visibility and archive state are set **explicitly, never by
omission**. **An end-of-results terminator certifies the query, never the
workspace** — the tool reports exhaustion of *its own filtered result set*, so
**completeness is a property the scan establishes, never a signal it
receives**, and until every axis is explicit the listing is a **sample**, a
sample reporting what it found and never what does not exist. **The
falsification half, in operational form** — **a zero-channel listing is a tool
fault, never a finding**, and where a Slack source already stands on the
`Sources:` line the listing **must surface it: a listing that misses a known
channel is void**, and no render rests on it. **The durable tool facts** ride
the clause on the D-O54 pattern, so they are never re-derived — visibility and
archive parameters **default narrow** (public, non-archived); the endpoint
**has no listing mode**, the broad listing being a match-all query with both
axes set explicitly; the terminator certifying the query's result set, never
the workspace · **the two render deltas (D-O80)** — the match line gains an
**`(archived)`** marker rendering only where the candidate is archived, and
**one new conditional line** carries the no-match case with its corpus:
`Slack — no channel matches the project name · listed <n> channels (public +
private, archived included).` The no-match case previously had **no line at
all** — sound as far as it goes, since it prevents a false claim by preventing
any claim, but it left the scan with a result and no sanctioned way to report
it, and in the field run the operator improvised one asserting a coverage no
rule had asked anyone to verify. **The absence of a safe line manufactured an
unsafe one.** Forcing `<n>` and the corpus into the pinned shape converts an
improvised claim into an auditable one, and **a scan that cannot fill the line
honestly cannot render it** · **the corpus-declaration rule (D-O81)** —
framework law, stated once: **any rule that depends on a retrieval — a listing,
a search set, a sweep, a glob — names the corpus that retrieval must cover, and
the retrieval states the corpus it covered; a completeness claim is carried by
the act that establishes it, never inherited from the tool that terminated it;
where the corpus is not stated, the result is a sample, and a sample never
grounds a negative.** **Applied this sitting at the escape site only.**

**Why the class, and not a third patch.** The shape is *a state line asserting
a completeness no rule required anyone to establish.* The first instance is
already on the record as the binary-readability clause (v0.25, 17 Aug 2026):
`captured` was true of the transport and false of the artifact. Here `complete`
is true of the query and false of the workspace. **Two instances in four days
establish the class** — so the principle takes its own decision number and is
stated once, while its **application** stays deliberately narrow.

**Files touched — 6.** `docs/field-notes/2026-08-20-slack-scan-corpus-miss.md`
(**new**, verbatim) · `docs/methodology/ba-native-spec-orchestrator-rules.md`
(v0.30 → **v0.31**; §8.1's two new paragraphs, D-O45's pinned block amended,
§34, the head change record, the footer at D-O1–D-O81) ·
`payload/claude/skills/ba-frame/SKILL.md` · `tests/check-orchestrator.sh` ·
`BUILD-LOG.md` · `VERSION` (0.1.29 → **0.1.30**).

**The suite: 17 of 17 green.** `check-orchestrator.sh` **448 → 498** — the
header pinned at v0.31, v0.30 demoted to a change-record `has`, the
D-O80–D-O81 block, contiguity moved to **1…81**, and one new §5d section
carrying the corpus law, the terminator law and the falsification law in **both
carriers**, the two render deltas asserted in both, a `hasnt` retiring the
unmarked match line, D-O81 and the tool facts asserted **document-only** with
the carrier asserted clean of them, the four volatile mechanics of report §7
asserted **absent** from the law, the field note asserted present with its own
evidence (`225 of 705`), and a **cross-carrier byte-identity check on the whole
pinned source-inventory block** with a seven-line count guard — a divergence
there *is* the render defect the pinned shape exists to prevent. **Every other
check unmoved:** `check-gate.sh` 105, `check-spine.sh` 253, `check-auto.sh`
250, `check-budget.sh` 37, `check-register.sh` 63, `check-wbs.sh` 99,
`check-status.sh` 115, `check-m.sh` 71, techniques 104 / 122 / 159,
`check-layout.sh` 117, `check-exit.sh` 99, `check-install.sh` 64,
`check-ledger.py` 19 rules, `check-cards.py` byte-identical. **No card
recompiled and no contract assertion added** — the ruling touches no CC row.

**Divergences — five, none self-resolved.**

1. **The D-O54 residual read gained a document-only permitted list.** D-O81's
   law paragraph lands **inside the scan clause** — immediately after D-O80's,
   where the ruling places it — and the law names retrieval kinds generically
   (*"a listing, a search set, a sweep, a glob"*) and routes P-A1's
   band-wide search set. Both carry the token `search`, which the residual
   read exists to forbid inside that clause. Neither is scan-method wording,
   so both are permitted **by exact phrase, at the document only**; the skill
   carries no D-O81 text and **its permitted set is unchanged**. The check
   keeps its whole force — each removal sentence must still appear exactly
   once, and a future *"fall back to search"* edit still leaves wording no
   permitted phrase covers. Named here rather than reconciled quietly.
2. **D-O81 is document-only by ruling, and the carrier is asserted clean of
   it.** §34 compiles **`ba-frame` alone**, and framework law is reached by
   reference, never recompiled into every carrier that depends on it — so
   `hasnt "$FRAME" "The corpus-declaration rule"` is an assertion, not an
   omission. The durable tool facts ride the same split.
3. **Report §6.3 is adopted in operational form, not as drafted.** The draft
   asked the scan to *"prove the listing surfaces a channel known to sit inside
   it"* — a synthetic positive control the scan would have to invent, which is
   a second unexamined corpus. The adopted form uses an artifact **the ledger
   already holds**: where a Slack source stands on the `Sources:` line, the
   listing must surface it or is void. Same falsification, no invented probe.
4. **`tests/presale-path.md` is deliberately not edited.** It carries an
   **instantiated** render (`#acme-portal`, not archived), not the pinned
   template, and the `(archived)` marker renders **only where the candidate is
   archived** — so the example stands correct and unchanged under this ruling.
   Named rather than skipped quietly.
5. **No seeded defect added; the banner stays at 26 across 19 rules.** The
   ruling adds **no ledger grammar** — no event kind, no head line, no state.
   The field note records that no ledger event was written for this defect
   because the event grammar is closed and holds no kind for an orchestrator
   execution fault, and **inventing one to hold a post-mortem would be its own
   violation** of the discipline this ruling tightens. §4's *"14 rules, 14
   mutations"* and the 26 / 19 totals were re-counted and are accurate as they
   stand.

**No incidental corrections this pass.** Nothing tripped outside the surfaces
this ruling touches; the two harness constants that moved — the pinned block's
line count 6 → 7 and the D-O contiguity bound 79 → 81 — are this pass's own
delta, not inherited staleness.

**Open:** nothing from this ruling. **Routed by the edition and deliberately
not built here: the P-A1 band-wide search set's corpus application** — the
report's highest-value follow-up, the same defect one level up: the audit's
two-way trace rests on that set, its findings carry it as evidence, and the
rule mandating it never says what *band-wide* ranges over, so its false
negatives land in a source audit rather than an inventory. Legislating a second
application from the post-mortem of the first would be exactly the
unexamined-corpus move D-O81 exists to forbid, and the audit's own corpus axes
are not established by this sitting's evidence. Standing and carried unchanged:
the reconciliation family (runtime `AS` ↔ audit `OB`); §10.1's P-O0b act cell,
whose enumeration still omits cross-cutting obligations (a v0.29-era omission
§33 names and routes); `check-audit.sh` · `sk_audit.py`, named and unbuilt from
the earlier sittings.

## The Stop Speaks Plainly — the closing ask at every stop point · orchestrator v0.32 · package 0.1.31 · 20 August 2026 · GREEN

**Session prompt:** codify the 20 Aug 2026 field feedback — a live Presale run
halted and the BA could not tell what was expected — as **one cross-cutting
render rule** at orchestrator §10.3 under the next free D-O; sweep
`payload/claude/skills/*` and `payload/claude/agents/*` so every compiled stop
point gains the closing-ask pattern; **reshape closing asks only — no step
redesigned, no pinned output shape touched**; run the standard build pass.
Documents before code.

**Precondition, clean — then a sibling appeared.** `git log -1` read `3d378ee`,
VERSION `0.1.30`, tree clean; all 17 checks green at baseline
(`check-orchestrator.sh` 498, `check-budget.sh` 37). **Mid-session a
concurrent pass began writing in this tree:**
`docs/methodology/ba-native-spec-phase2-build-plan.md` moved to a v0.3
**EC-16 installer-integrity** edit (D-P2-13…D-P2-15) that is no part of this
ruling and appeared after this pass's baseline read. Standing law applied: this
pass stages **named paths only**, the sibling's file is left in the working
tree exactly as found and is **not** in this pass's commit, and green was
re-verified in an **isolated copy** holding HEAD plus this pass's files alone.

**Origin — the defect, verbatim.** When a step halts and waits for the BA, the
closing ask is framework jargon: *"Reply with: sources · profile · frame
confirmed, including the SD-?/XO-?/AS-? keep-or-discard calls."* The BA — the
framework's own operator — has to ask *"what do you expect from me?"*. **A
stop-render UX defect, not a mechanics defect:** the stop was legitimate under
the checkpoint law, the pinned blocks intact, the harvest lines cited. The last
mile — the sentence that turns a legal stop into an answerable question — had
no law anywhere in the corpus, so every stop improvised it. The class sits in
§10.3's charter (the BA-facing register), and per the v0.31 lesson — a class
patched at one escape site escapes at the next — the fix is one register rule,
not a Frame patch.

**What the ruling gives the runtime (D-O82 — §10.3 rule 9).** Every render
that ends the turn awaiting BA input — every legitimate §10.1 stop, a
contract-miss stop (§6.3), any keep-or-discard ask — **ends with a final
plain-English block titled `What I need from you:`**, each open item one
specific question a person who has never read the framework can answer,
framework codes only with a plain-language gloss beside them · **enumerable
choices ride the AskUserQuestion tool** — single-select, one question per open
item, all items of the stop batched into one call, each with an "other / free
text" escape; items past the tool's per-call capacity ride the lettered block
in the same render, still one stop and one reply · **options lettered, exactly
one `(recommended)` per question** — the pinned default or safe disposition
where one exists, else the best-grounded suggestion — **a label that never
pre-selects and never auto-applies** · no AskUserQuestion in the runtime → the
same lettered list plus "reply with the letter" · **selections transcribed
into the existing pinned reply and record grammar**, typed token strings an
optional shortcut and never the only channel · **additive on the D-O56 tail
precedent** — appended after the pinned render, nothing replaced, reordered or
dropped · **AUTO exempt (D-O51)** — no mid-run questions exist there, the
band-boundary and resumption reports byte-untouched · **arithmetic untouched**
— one stop stays one interaction, D-O33's ≤ 8 stands, no new stop, no new
prompt point, no new register, no new event kind, no threshold moved, no
assertion added or weakened, no gate rule touched.

**Files touched — 41.**
`docs/methodology/ba-native-spec-orchestrator-rules.md` (v0.31 → **v0.32**:
the head change record, §10.3 rule 9, §35, the footer at D-O1–D-O82) · **the
six register carriers**, rule 9 compiled after rule 8 —
`payload/mirror/claude-block.md` · `payload/mirror/AGENTS.md` ·
`payload/claude/agents/ba-orchestrator.md` · `ba-analyst.md` ·
`ba-discovery.md` · `ba-gate.md` · **the stop-point sweep, 30 skills** — the
tailored asks at `ba-frame` (the Frame single stop with a worked five-question
shape, and the correction stop) · `ba-aspect` (P-O2 — plan composition, with
its shape) · `ba-run` (the route `go`, the batch confirmation table, the
consolidated defer-confirm) · `ba-clear` (P-O4 — clearing confirmation, with
its shape) · `ba-waive-aspect` (grant · refusal · re-affirmation) ·
`ba-reopen` (P-O6 — reopen ruling, with its shape) · `ba-close-band1` (the
precondition miss and the re-affirmation list) · `ba-enter-feature` (P-O8 —
Band-3 entry) · `ba-gate` (P2 · P3 · P4) · `ba-audit` (P-A1 — source-audit
ruling) · `ba-tier1` (the routing-batch approval) · `ba-tier2` (question
packets · the deferral batch · P-O9 — overflow ruling) · `ba-t01` (the
review-and-landing batch) · `ba-t17` (the step-5 rulings and the graduation
batch) · `ba-t18` (the step-4 approval with its worked shape) — and the
uniform sentence at **both miss stops in all 20 technique-class skills**
(`ba-t01`…`ba-t18` · `ba-tier1` · `ba-tier2`): *"The stop closes per §10.3
rule 9 — `What I need from you:` with the repairing act as the `(recommended)`
option."* · `tests/check-orchestrator.sh` · `tests/check-budget.sh` ·
`BUILD-LOG.md` · `VERSION` (0.1.30 → **0.1.31**).

**The suite: 17 of 17 green.** `check-orchestrator.sh` **498 → 501** — the
header pinned at v0.32, v0.31 demoted to a change-record `has`, the D-O82 and
§35 rows, contiguity moved to **1…82**. `check-budget.sh` **37 → 50** — the
new §6 on the closing ask: seven document literals of rule 9 held down
(`What I need from you:` · exactly one `(recommended)` · never pre-selects ·
appended after the pinned render · AG-inert · one stop one interaction), the
compiled clause read in **all six register carriers** on section 3's
joined-read loop, the ask named in **all 15 stop-carrying skills** (a named
set, not a glob — a read-only render legitimately carries none), the uniform
sentence at **both miss stops in all 20 technique-class units**, and a
stripped control that fires. **Every other check unmoved:** `check-gate.sh`
105, `check-spine.sh` 253, `check-auto.sh` 250, `check-register.sh` 63,
`check-wbs.sh` 99, `check-status.sh` 115, `check-m.sh` 71, techniques
104 / 122 / 159, `check-layout.sh` 117, `check-exit.sh` 99,
`check-install.sh` 64, `check-ledger.py` 19 rules, `check-cards.py`
byte-identical. **No card recompiled and no contract assertion added** — the
ruling touches no CC row.

**Decisions named — five, none silent.**

1. **The register self-check is deliberately not extended.** It compiles rules
   1, 5, 6, 7 and the checkpoint law, byte-pinned across 42 units, and rule
   9's enforcement sites are the stop points themselves — every one of which
   now carries the pattern in its own text. Extending the pinned block would
   re-hash 42 units and the harness pin to add a second enforcement channel
   without adding protection. §35 records the same reasoning at the document.
2. **The AUTO surfaces are untouched by the sweep.** `ba-auto` is not in the
   file list; the band-boundary and resumption reports stand byte-identical
   (check-auto's 3-unit byte check, unmoved at 250). The exemption is the
   ruling's own clause, not an omission.
3. **The tool-capacity clause is stated in the rule, not improvised at
   render.** AskUserQuestion carries at most four questions per call; the
   Frame stop routinely holds five or more open items. Rule 9 says the excess
   rides the lettered block in the same render — one stop, one reply — which
   is the ruling's own fallback channel doing double duty, and the worked
   shape in `ba-frame` shows a five-item block for exactly this reason.
4. **`tests/presale-path.md` is deliberately not edited.** It is the budget's
   counting script — `## Interaction` headings against ≤ 8 — and the ask adds
   no interaction, so the count it holds down is unchanged. Its instantiated
   renders predate the rule and are not the pinned template. Named rather
   than skipped quietly.
5. **The gate's judgment stops keep their weight.** P3 — the ⚑ sign-offs and
   P4 — approval gain the ask like every stop, and the marker sits on the
   best-grounded option (`sign it` beside a complete evidence bundle) — but
   the marker is a label by rule text, the sign-offs and the approval stay
   outside every grant, and nothing signs itself. The non-waivable set and
   the safety floor stand exactly where they stood.

**No incidental corrections this pass.** Nothing tripped outside the surfaces
this ruling touches; the harness constants that moved — the contiguity bound
81 → 82, the header pin, budget's new section — are this pass's own delta.

**Open:** nothing from this ruling. **In flight beside it, named above:** the
sibling EC-16 installer-integrity pass (build plan v0.3, D-P2-13…D-P2-15),
writing in this tree during this sitting — its file left untouched and
uncommitted here; its own BUILD-LOG entry and package bump belong to it.
Standing and carried unchanged: the reconciliation family (runtime `AS` ↔
audit `OB`); §10.1's P-O0b act cell, whose enumeration still omits
cross-cutting obligations (a v0.29-era omission §33 names and routes); the
P-A1 band-wide search set's corpus application (routed by v0.31, deliberately
unbuilt); `check-audit.sh` · `sk_audit.py`, named and unbuilt from the earlier
sittings.

## The Guard On Our Side Of The Fence — EC-16 installer integrity reaches the code · build plan v0.3 · package 0.1.32 · 21 August 2026 · GREEN

**Session prompt:** propagate the committed Phase-2 build plan **v0.3** into
`install.sh` and `payload/mirror/` per **D-P2-13 · D-P2-14 · D-P2-15(a)**;
documents before code — the committed doc is the ruling record and every code
edit traces to its locked text, cite-never-restate; falsify on a scratch
target; close per the standing build discipline.

**Precondition, clean.** `git log -1` read `bd01ee4` (the EC-16 authoring
commit, build plan v0.3) on `c1c2bfc` (the 0.1.31 sibling), VERSION `0.1.31`,
tree clean, all 17 checks green at baseline. The four doc fingerprints the
prompt names were verified before any edit: version line **v0.3** · D-P2-13
and D-P2-14 as locked decision rows · **D-P2-15 locked to (a)**, the one-line
empty-⬒ trace standing on the D-P2-6 install-time content policy row and not
an open row · **§8 amendment record** present. **One deviation from the
precondition, named:** `origin/main` sat at `3d378ee`, two commits behind —
`git merge-base --is-ancestor` confirmed a clean fast-forward, no divergence,
so this pass proceeded and its push carries all three commits.

**Origin — the defect.** **EC-16 · installer integrity**, registered 20 Aug
2026 from a field bootstrap install of 0.1.30 into a live presale project.
The ruling record is the committed build plan **§8**; it is cited here and
never restated. Two holes on the ⬒ side of the install, one footnote — the
pinned kit's own `/speckit-constitution` recreating from template the file
D-P2-6 sets aside, and the manifest whole-file-hashing the two fenced-block
merge targets it does not own outright.

**What the pass gives the runtime.** **D-P2-13 — the supersession notice.**
Both mirror sources carry it, and therefore the fenced block in every
installed `CLAUDE.md` and `AGENTS.md`: **`/speckit-constitution` superseded by
`/ba-run t15`**, `constitution.md` born from Band-1 evidence at **T-15 —
Constitution**, never from a template, with both do-nots stated — do not
invoke the Spec Kit skill, and do not follow Spec Kit's Next Steps panel where
that panel advertises it. Placement follows each file's own structure:
`claude-block.md` gains a **`Superseded — 1`** entry closing the `/ba-*`
command index, beside its `Workflow — 17` and `Techniques — 20` lists;
`AGENTS.md`, which carries no command index, gains a **third prohibition** in
the analysis-session bullet list, in that list's own grammar — *"You never
birth governance from a template."* **The guard lives entirely on our side of
the fence:** Spec Kit's `SKILL.md` and its Next Steps panel are pinned
upstream content and are untouched. **D-P2-14 — the fenced-block hash.** The
manifest's ⬒ set hashes the installer-owned block for the two merge targets,
never the whole file, and the manifest header states the rule to its reader.
**D-P2-15(a) — zero code edits, by ruling.** `install.sh:245`'s carry-over
comment was established accurate about the install act and stands byte-
unchanged; the trace is doc-side and already landed with the authoring commit.

**Two semantics ruled at the gate, nothing silently resolved.** The locked
text leaves both open, so both were surfaced as lettered questions before any
line was written. **Q1 — marker inclusivity: (a) inclusive.** The hashed
region runs from `<!-- ba-native-spec:begin -->` through
`<!-- ba-native-spec:end -->`, markers included — one definition of "the
block", the same value `merge()` already writes, and marker tampering
registers as drift. §8's "on first contact the block is the whole file" is
literally true only under this reading. **Q2 — a merge target that exists but
carries no fence at hash time: (c) fail the install loudly.** The fence is
absent immediately after the installer wrote it, so the merge failed and a
manifest must not certify a broken install; the verify side stands as §8 locks
it — a missing fence is **real drift**.

**D-P2-14 has two code surfaces, not one — named, not assumed.**
`tests/verify-manifest.py` is the install manifest's verifier and re-hashed
whole files; changing the generator alone would have shipped red. Both sides
move together, which is the same ⬒-set rule on its read side.
**`sk_handoff.py` is correctly untouched** — its whole-file hashing serves the
**certification** manifest (gate §11.1), a different artifact.

**Files touched — 6.** `payload/mirror/claude-block.md` ·
`payload/mirror/AGENTS.md` (D-P2-13; both files also carry the 0.1.31
sibling's stop-point closing-ask block — **pure insertions, the sibling's
block byte-untouched**) · `install.sh` (D-P2-14: the manifest generator's
merge-target branch, the `fenced_block()` helper, the fail-loudly guard, and
the manifest header prose) · `tests/verify-manifest.py` (the same rule on the
read side: docstring claim 3, the constants and helper, the verify branch) ·
`BUILD-LOG.md` · `VERSION` (0.1.31 → **0.1.32**). **No file added or removed
— `tests/layout.expected` is untouched, verified rather than assumed.**

**Falsification — a scratch target, four probes, then re-run on the shipped
text.** A throwaway git repo carrying a **pre-existing `CLAUDE.md` with
project content outside the fence** — the false-drift case itself. (1) Both
installed fenced blocks carry the supersession line **and** the sibling's
stop-point block, one fence pair each, the pre-existing content preserved.
(2) The manifest rows for both merge targets match the **block** hash and not
the whole-file hash. (3) An edit **outside** the fence leaves the verifier at
exit 0 — the false ⬒-drift is closed; an edit **inside** the fence is
reported; the fence **removed** is reported as real drift in the verifier's
own words. (4) Three consecutive installs: exactly one supersession line, one
fence pair, project content kept, and the manifest byte-stable across
re-installs. **The fail-loudly branch was exercised against the shipped code**
— the generator extracted verbatim from `install.sh` and run on a
fence-stripped target exits **1** with its named message; end-to-end it is
unreachable by construction, because the merge step re-fences before the
manifest runs, and that is recorded rather than glossed.

**The suite: 17 of 17 green.** `check-m.sh` 71 · `check-gate.sh` 105 ·
`check-orchestrator.sh` 501 · techniques 104 / 122 / 159 · `check-spine.sh`
253 · `check-register.sh` 63 · `check-wbs.sh` 99 · `check-status.sh` 115 ·
`check-ledger.py` 19 rules · `check-cards.py` byte-identical ·
`check-layout.sh` 117 · `check-exit.sh` 99 · `check-install.sh` 64 ·
`check-budget.sh` 50 · `check-auto.sh` 250. **Every count unmoved** — this
pass moves no harness constant, recompiles no card and adds no contract
assertion; it touches no CC row and no AT threshold.

**One red caught and fixed inside the pass.** The first full run came back
**RED at `check-register.sh` (56 / 7)**: both new mirror paragraphs rendered
**`T-15` bare**, violating register rule 5 — a known code must carry its name
— and the suite's own self-test cascaded off the two defects, its control
corpus no longer clean at 0. Fixed at source by rendering the canonical
**`T-15 — Constitution`**, the form the payload already uses at
`ba-t15/SKILL.md` and `ba-frame`; `check-register.sh` returned **63 / 0** and
the full suite went green. Recorded because the sweep caught a real defect in
this pass's own new text, which is what it exists to do.

**Decisions named — three, none silent.**

1. **Placement was a build judgment, taken per file and not uniformly.** §2.6
   fixes the mirror rows' *content*; the doc does not pin an insertion point.
   `claude-block.md` has a command index, so the supersession belongs at its
   end in the section's own `**Heading — count**` shape. `AGENTS.md` has none,
   so the line belongs where that file states the agent's prohibitions. A
   uniform placement would have put a command entry into a file with no
   command list.
2. **The installer's closing-print counter-line was not implemented.** §8
   records it as named-not-ruled and the prompt forbids it; Spec Kit's Next
   Steps panel is reprinted by our installer, and whether our own print should
   answer it beside the panel remains an open question for the master
   conversation.
3. **No row marker was added to the manifest's two merge-target rows.** The
   hash list is parsed as `path  digest` by `verify-manifest.py`; annotating
   those rows would break the parser to restate what the header now says in
   prose. The rule is stated once, where a reader meets the list.

**No incidental corrections this pass.** Nothing tripped outside the surfaces
these decisions touch.

**Open — one, routed and deliberately unbuilt.** **D-P2-14 has no regression
assertion.** The generator and the verifier now agree on fenced-block hashing,
and every install-based run exercises them together — but they would agree
just as green if both regressed to whole-file hashing, because no check
asserts *which* rule is in force. The hand falsification above is exactly the
missing assertion, and its natural home is `check-install.sh`. Not built here:
the prompt scopes this pass to edits taken strictly from the doc's locked
text, and a new check is not among them. **Highest-value follow-up of this
pass.** Standing and carried unchanged: the reconciliation family (runtime
`AS` ↔ audit `OB`); §10.1's P-O0b act cell and its cross-cutting omission; the
P-A1 band-wide search set's corpus application; `check-audit.sh` ·
`sk_audit.py`, named and unbuilt from the earlier sittings.

## The Comment Stops Naming The Heading — B8 ledger-template comment hardening, Lane A mechanical · package 0.1.33 · 21 August 2026 · GREEN

**Session prompt:** close **B8** of the 2026-08-21 errata registration
(`claude_ba-native-spec-errata-ec17-19-registration-2026-08-21.md`, R-2), ruled
by the BA as **"apply all recommendations"** on the 2026-08-20 field defect
report. Five assertion-guarded edits across the two payload ledger templates,
count-verified before and after; Lane A, mechanical only — no rule, assertion,
threshold, check or methodology document moves.

**Precondition, clean.** `origin/main` and `HEAD` both at `9ca5731` (the EC-16
propagation commit, package 0.1.32) — the queue's first item landed and pushed
before this one opened. VERSION `0.1.32`, tree clean. The three entry counts
the prompt names read exactly **3 · 3 · 2**: `## Frame` and `## Band 2` three
times each in `aspect-plans.md`, `Band: 1 (open)` twice in `aspect-state.md`
— in each file one body occurrence and the comment-block hazards beside it.

**Origin — the defect.** Field defect report **2026-08-20, Part B item B8**,
from the Nutrivity presale run. Both runtime-ledger templates embedded their
own live heading and head-line strings inside their comment blocks. One
substring-anchored edit matched a **comment** instead of the body and deleted
`## Frame` plus all six aspect sections from a live plans ledger — silent at
the time, and unrecoverable without the session transcript. The template
taught the hazard to every ledger born from it.

**What moved — comment prose, and nothing else.** In
`payload/specify-overlay/ba/templates/aspect-plans.md`: the head comment now
reads *"the Frame section (D-B1-4) and the Band-2 section"*, the Band-3
comment now enumerates *"the aspects, Frame and Band 2"*, and the first
comment block closes on a new **edit-discipline paragraph** — headings and
head lines are edited **line-anchored**, full-line match at line start, never
by substring search, and the comment says plainly that it names its sections
without their literal heading strings. In `aspect-state.md`: the born-by line
now reads *"head at six × `untouched`, Band 1 open"*, and the file-discipline
line gains the same **line-anchored** rule beside the rewrite-in-place /
append-only pair it already carried. Post-state, verified by sweep: each
literal string occurs **exactly once per file** — the body occurrence the
checks read — and both body anchors survive line-anchored (`^## Frame$`,
`^## Band 2$`, `^Band: 1 (open)$`), one each.

**Every edit was guarded, not trusted.** Each of the five `old` strings was
required to match **exactly once** in its file before any byte was written —
a 0 or ≥2 match was a stop — and the count was re-checked at apply time
against the running buffer, so no earlier edit could silently widen a later
one. The seven-value residual sweep ran after: three killed-string counts at
1, three body-anchor counts at 1, and the discipline note present once per
file.

**What did not move.** No rule. No D-number minted. No assertion, no
threshold, no check edited. No methodology document touched — template comment
text is compile commentary, not law, and B8 is a hazard in the commentary.
**EC-17–EC-19**, registered the same day, are untouched by this pass. The two
live-ledger fixtures under `tests/fixtures/appointment-booking/band1/` were
read and do **not** carry the hazard — their comment blocks embed no literal
heading or head-line string — so nothing was needed there.

**The suite: 17 of 17 green.** `check-m.sh` 71 · `check-gate.sh` 105 ·
`check-orchestrator.sh` 501 · techniques 104 / 122 / 159 · `check-spine.sh`
253 · `check-register.sh` 63 · `check-wbs.sh` 99 · `check-status.sh` 115 ·
`check-ledger.py` 19 rules · `check-cards.py` byte-identical ·
`check-layout.sh` 117 · `check-exit.sh` 99 · `check-install.sh` 64 ·
`check-budget.sh` 50 · `check-auto.sh` 250. **Every count unmoved**, as a
comment-only pass must leave them. `check-orchestrator.sh` reads the **body**
`## Frame` heading, which this pass did not touch; nothing in the suite
asserted the comment fragments, checked before the first edit and confirmed by
the run.

**No incidental corrections this pass.** Nothing tripped outside the two
comment blocks.

**Open — one, named and deliberately unbuilt.** **The discipline is stated,
not enforced.** Both templates now tell a reader to edit line-anchored, but
nothing asserts it: no check forbids a comment from re-embedding a literal
heading string, and an agent that never reads the comment is unguarded by it.
The natural homes are a template-hygiene assertion in the suite and an
edit-discipline line in the orchestrator's ledger-write rules — **both are
Lane B**, and this pass is Lane A by ruling, so neither was built here.
Standing and carried unchanged: **D-P2-14 has no regression assertion** (the
highest-value follow-up of the 0.1.32 pass); the reconciliation family
(runtime `AS` ↔ audit `OB`); §10.1's P-O0b act cell and its cross-cutting
omission; the P-A1 band-wide search set's corpus application; `check-audit.sh`
· `sk_audit.py`, named and unbuilt from the earlier sittings.

## The Register Stops Lying About Its Own Coverage — EC-17 audit integrity, documents before code · source-audit definition v0.2 · package 0.1.34 · 21 August 2026 · GREEN

**Session prompt:** close **EC-17 — audit integrity**, items **B1–B4** and
**B11** of the 2026-08-20 field defect report, under the BA's ruling **"apply
all recommendations"** (21 Aug 2026). Five rulings legislated into
`docs/methodology/ba-native-spec-source-audit-definition.md` **first**, then
propagated into `payload/claude/skills/ba-audit/SKILL.md`, every carrier edit
tracing to the doc's locked text. Question protocol: nothing silently
resolved.

**Precondition, clean.** `HEAD` and `origin/main` both at `3f0f59d` (the B8
template-hardening commit, package 0.1.33), VERSION `0.1.33`, tree clean, all
17 checks green at baseline — `check-orchestrator.sh` 501, `check-budget.sh`
50, `check-cards.py` byte-identical. No sibling pass appeared in the tree at
any point; the three files this pass staged are the only files that moved.

**Origin — the defect.** A `/ba-audit` run 1 over a live band rendered a P-A1
head claiming **118 obligations over a register that held 30**, never ran its
backward trace or its critic pass, **self-authored every CC-S verdict** where
operator policy forbade subagent dispatch, and **never wrote
`decision-list.md`**. The register lied about its own coverage and the
definition made every one of those failures either invisible or inevitable:
the counts were free text nobody had to derive, the walk declared no corpus so
a thirty-row keyword probe and a full two-pass walk were the same object on
disk, Stage 2's dispatch clause anticipated only mechanical death so a policy
refusal had no legal state at all, and the run's own workspace was never the
condition of its ledger entry. **Documents before code by ruling:** the law
moved first and every carrier string traces to it.

**The eight questions, ruled before a byte moved.** Three the prompt marked,
five the rulings left genuinely open; all eight answered **as recommended**.
*(1)* **B11 precedence** — shared disposition → one enumerated amend row,
CC-S-04's grain across distinct dispositions, enumeration count equal to the
absorbed count. *(2)* **Status line** — lifted from *draft for maintainer
review* to **ruled**, v0.2 minted, the maintainer's own ruling the basis a
draft was waiting on. *(3)* **Scope** — `check-audit.sh` and `sk_audit.py`
**PARKED**; doc + carrier only. *(4)* **The election's channel** — a BA ruling
at the Stage-0 refusal's closing ask, **no invocation flag**: an election
typed before the restriction is known is an election made blind, and the
skill's argument line stays `[--full]`. *(5)* **Detection point** — Stage 0
tests admissibility **and** a Stage-2 discovery halts back to that same
refusal; one refusal text, two entry points. *(6)* **INCOMPLETE's home** — a
pinned `Status:` field on the report entry, which made
`source-audit-report-entry.md` a **third carrier** this pass touches. *(7)*
**R3's render surfaces** — register head **and** both pinned heads. *(8)*
**R4's required set** — conditional and named per file.

**What moved — the law first (v0.1 → v0.2, D-S1…D-S5).** The `D-S` decision
space is new and was verified free before minting. **D-S1 (B1) — §4 · §11:**
the dispatch has **three** states, not two — alive · dead-mechanical
(re-dispatched) · **UNDISPATCHABLE**, policy unavailability, which *is not a
dispatch that died* and for which re-dispatch is not the remedy. Default path
is a **Stage-0 refusal with its named unblocking act**; the **BA-electable
self-evaluated mode** stamps every verdict `self-evaluated — no independent A
pass` and **forces the run status to `INCOMPLETE`**, uncleared by any later
act. **Silence is not a legal path**, and substituting the orchestrating
session for the evaluator absent the election is a **defined violation**.
**D-S2 (B2) — §5:** the five header numbers are **counted from
`obligations.md`'s rows by status at render time**, `c + p + a + g = t`, with
`Sources read:` and the `Claims:` line deriving the same way; a head
disagreeing with the on-disk rows is **invalid audit output** on the bar §5
already set for a finding without its quote, corrected before render and never
rendered-and-explained. **D-S3 (B3) — §2 · §3 · §5:** per-source coverage
accounting in the register head — `<sections walked>/<sections total> · <n>
rows`, a zero-row source stating why — plus the **corpus-declaration rule
(D-O81, orchestrator §8.1) applied at this document's own two retrievals**:
the Stage-1 walk and the band-wide search set each **declare the corpus they
must cover**, the run **states the corpus it covered**, and **a sample never
grounds a `gap`**. **D-S4 (B4) — §5 · §6 · §7:** `decision-list.md` is an
explicit **Stage-3 write act** — written before the ruling is asked for,
written back when it is given, **and written on a clean run too**, zero rows
and its `Rulings:` line — with §7 marking the **required set** and §6's Stage-5
entry **refusing to append** over a missing required file. **D-S5 (B11) —
§5:** the finding grain is CC-S-04's and untouched; the list-row grain is §5's,
and the enumeration equality is the force.

**§34's routed item is closed by D-S3, and closed on its own terms.** BUILD-LOG
§34 and D-O81 named the P-A1 band-wide search set's corpus application *the
same defect one level up*, **named and left unbuilt on purpose** — because
legislating a second application from the post-mortem of the first would be
the unexamined-corpus move the rule exists to forbid, and *the audit's own
corpus axes were not established by that sitting's evidence*. This sitting has
that evidence: a live audit run whose negatives rested on an undeclared
corpus. The condition the routing set is met, and the item is closed rather
than carried. **Framework law is cited, never restated** — D-O81's own
sentence appears nowhere in either surface, verified by grep.

**What moved — the carrier, second.** `ba-audit/SKILL.md`: Stage 0 gains item
**5, dispatch admissibility** — the refusal, its `refused at Stage 0` grammar,
and the two-option closing ask under §10.3 rule 9 with **(a) lift and re-run**
recommended · Stage 1 gains the walk's corpus declaration and the per-source
coverage block, and its self-description corrected **"Three rules" → "Four
rules"** · Stage 2 gains **the search set's corpus declaration**, the
three-state dispatch paragraph, the self-evaluated stamp, and *both traces
write their rows* — a backward trace that did not run renders `0` against an
empty block, visible, never a number the render supplies · Stage 3's pinned
head gains `Corpus covered:` (unconditional) and a conditional `Status:` line,
plus the derived-counts rule, the D-S5 precedence and `decision-list.md` as
this stage's act · Stage 5 gains the workspace check before the append · the
run-workspace block marks the required set · the *never does* list gains four
clauses. **The mirror command table, the skill's `[--full]` argument line and
`tests/layout.expected` are untouched** — the election is a ruling, not a flag.

**What moved — the pinned entry template, third.**
`payload/specify-overlay/ba/templates/source-audit-report-entry.md` gains
`Status: <complete | INCOMPLETE — <reason>>` and `Corpus covered:` on the entry
head, with three comment paragraphs carrying the status forcing, the sample
rule and the count derivation. **The comment names its own fields without
their literal head-line strings** — B8's edit discipline, applied one day
after it was legislated and at a template B8 itself did not reach.

**The CC-S card did not move, and that is an assertion.**
`payload/specify-overlay/ba/cards/assertions-s.md` stands **byte-unchanged**,
verified by `git diff --quiet`. D-S5 fixes a boundary *between* CC-S-04's
finding grain and §5's list-row grain and edits neither: the card's *each
unmapped row is its own finding* is true of the A pass exactly as written, and
the absorption that looks like a contradiction happens one stage later, at a
render the card does not own. Named in the doc's §12 and here rather than left
as a silent non-edit.

**The suite: 17 of 17 green, every count unmoved.** `check-m.sh` 71 ·
`check-gate.sh` 105 · `check-orchestrator.sh` 501 · techniques 104 / 122 / 159
· `check-spine.sh` 253 · `check-register.sh` 63 · `check-wbs.sh` 99 ·
`check-status.sh` 115 · `check-ledger.py` 19 rules · `check-cards.py`
byte-identical · `check-layout.sh` 117 · `check-exit.sh` 99 ·
`check-install.sh` 64 · `check-budget.sh` 50 · `check-auto.sh` 250.
**No count moved in either direction** — nothing in the suite asserts the
edited text, checked before the first edit and confirmed after the last. The
two pre-existing anchors *inside* the edited carrier were re-verified
explicitly: `check-orchestrator.sh:986`'s D-O70 never-follow clause and
`check-budget.sh:349`'s closing ask both still present.

**Falsification, and what it caught.** A single printed sweep over all four
surfaces: eight **killed** behaviours at zero (the live draft status line, the
stale "Three rules", the two-state dispatch run-on, a P-A1 head with no corpus
line above `Obligations:` in either surface, D-O81 restated rather than cited
in either surface), eight **pinned lines** at exactly one occurrence each
line-anchored, eleven **law strings** present in doc *and* carrier, D-O81
cited in both, and the CC-S card byte-clean. **The sweep caught a real
propagation miss on its first run:** D-S3 legislates *two* retrievals and the
carrier had taken only one — Stage 1's walk declared its corpus, Stage 2's
band-wide search set did not. Fixed, and a second red then caught the carrier
saying *names its corpus* where §3's locked text says *declares its corpus*;
the **carrier was moved to the doc's wording, never the reverse**. Two further
reds were probe defects, not surface defects, and are recorded as such: §12's
own account of the status lift legitimately contains the string *draft for
maintainer review*, and §12's D-S3 cell legitimately quotes §2's coverage
grammar — both probes were re-anchored to the live line rather than to any
mention.

**Citation honesty, on the record.** The prompt's basis line names **Part A
evidence A1–A5 and A7**, and that set-level citation stands verbatim at the
doc's head, at §12 and in the footer. **The field defect report itself is not
in the repository and is not in `~/Downloads`** — it was never read this
session. Four per-clause `A<n>` anchors were drafted from the prompt's
plain-words description of the run and then **removed before commit**,
because attaching a specific anchor to a specific clause would have been
inference presented as citation: six anchors, four described failures, no
determinable mapping. The **B-item anchors are exact** — they are stated in
the prompt itself (B1→D-S1 · B2→D-S2 · B3→D-S3 · B4→D-S4 · B11→D-S5). If the
report's per-anchor mapping is wanted in the doc, it is a one-line follow-up
against the report.

**What did not move.** No new CC-S family and no assertion text — the card is
byte-identical. No new instrument, no new record class, no new prompt point,
no new status value in any register, no new event kind, no threshold. **P-A1
stays the one checkpoint** and §8's ≤ 8 Presale interaction budget is
arithmetically untouched: the Stage-0 refusal is a refusal, not an interaction
the budget counts, exactly as a refused admission has always been. No skill
outside `ba-audit` moved, no agent moved, no check was edited, no fixture was
edited, `tests/layout.expected` unchanged. The orchestrator, gate, contract and
build-plan documents are untouched — D-O81 is reached by reference from both
new surfaces.

**Two structures this pass added, named rather than slipped in.** The document
had **no version number, no change record and no footer line** — every sibling
methodology document carries all three. Minting v0.2 without them would leave a
versioned document whose history has nowhere to live, so the head gains a
**`v0.2 change record:`** paragraph, the tail gains the standard italic
**footer**, and §11 is followed by a new **§12 amendment record** on the build
plan's §8 model. Structure added to carry this ruling, not content invented.

**Incidental, noticed and deliberately not fixed.** §9's calibration fixture
(`tests/fixtures/nutrivity-audit/run-1-outcome.md`) states **"register 118
obligations"** in prose — and **118 is exactly the number the live run
rendered over a register of 30**. Whether a fixture may carry a live-looking
count in a form a run can echo is a **fixture-hygiene** question, adjacent to
D-S2 and outside EC-17's five rulings. Named in the doc's §12 under
*deliberately not legislated here* and routed here; **not fixed in this pass**.

**Open — re-routed, and one now newly specified.** **`check-audit.sh`** —
parked by ruling, and **D-S2/D-S3 now fix exactly what its first assertions
check**: the header-count derivation (`c + p + a + g = t` against
`obligations.md`), the per-source coverage block, the two corpus declarations
and the required-set append condition; named at §10 item 7 of the definition
and re-routed here. **`sk_audit.py`** — parked; its ground is a register that
exists only at run time. **Fixture hygiene** — §9's `118`, above. **Standing
and carried unchanged:** the B8 discipline is stated in three templates and
**still enforced by nothing** (no check forbids a comment re-embedding a
literal heading string); **D-P2-14 has no regression assertion**; the
reconciliation family (runtime `AS` ↔ audit `OB`); §10.1's P-O0b act cell and
its cross-cutting omission. **EC-18 and EC-19**, registered 2026-08-21, are
untouched by this pass.


## The Profile Stops Fighting Its Own Destination — EC-18 presale circularity, documents before code · orchestrator v0.33 · standard v0.5 · package 0.1.35 · 21 August 2026 · GREEN

**Session prompt:** close **EC-18 — presale circularity**, items **B5**, **B6**
and **B7** of the 2026-08-20 field defect report, under the BA's ruling **"apply
all recommendations"** (21 Aug 2026). Three rulings legislated into the
methodology documents **first** — orchestrator, writing standard, elicitation
engine, all six catalogue batches, the sequencing plan's uniform sheet template
and the catalogue index — then propagated into sixteen carriers, every carrier
string tracing to the doc's locked text. Question protocol: nothing silently
resolved.

**Precondition, clean.** `HEAD` and `origin/main` both at `289bcaf` (the EC-17
audit-integrity commit, package 0.1.34), VERSION `0.1.34`, tree clean, all 17
checks green at baseline — `check-orchestrator.sh` 501, `check-techniques2.sh`
122, `check-techniques3.sh` 159, `check-spine.sh` 253, `check-budget.sh` 50,
`check-cards.py` byte-identical. No sibling pass appeared in the tree at any
point; the 35 files this pass staged are the only files that moved.

**Origin — the three defects.** A compliant Presale run **always** waives
Requirements and arms `CC-H-01`/`CC-H-05`, because `AT-RQ-1` demands
`roles-permissions.md`, `domain-model.md`, core processes and `constitution.md`
while D-O15 (set amended by D-O19) leaves **T-12, T-11, T-13 and T-15 out of
profile** — the waiver is the profile's arithmetic and the run re-argued it at
every surface it touched (**B5**). The writing standard's rule 7 said draft-and-
mark while `story-drafting.md` said a role absent from `roles-permissions.md` is
"a governance gap, proposed and approved **before** the story is written" — two
rules over one draft, and the field run improvised the reconciliation (**B6**).
Electing T-12 alone silently pulled in two artifacts — `domain-model.md` (T-11
output) and `constitution.md` (T-15 output) — declared nowhere the election could
see (**B7**). **Documents before code by ruling:** the law moved first and every
carrier string traces to it.

**The four questions, ruled before a byte moved.** Three the prompt marked, one
the rulings left genuinely open; all four answered **as recommended**. *(1)*
**CC-H arming under the expected waiver** — the arming **stands**; only the
rendering changes. *(2)* **D-O83's home** — orchestrator **§4**, a new **§4.5**,
not a third locked note beside AT-RQ-1 in §3.3: the rule classifies an *aspect
waiver*, so it lives with the instrument, and §3.3's notes compile verbatim into
`at-thresholds.md`, which carries operative criterion text and nothing else.
*(3)* **R2's home** — **writing standard §3**, where the role rule already lives;
`story-drafting.md`, the Tier-2 skill and elicitation §5.2/§5.3/§7.2 cite it.
*(4)* **What a declared precondition does at a P-O2 election** — **visibility,
never a block**. One consequence followed mechanically and was stated rather than
asked: "visible at election" places the declaration in the sheet's **§2
metadata**, which obliges the sequencing plan's uniform template to carry the
field and the index to gain the matching column, by each document's own rule.

**What moved — the law first (orchestrator v0.32 → v0.33, D-O83–D-O84).** New
**§4.5 — Expected profile debt**: the **mechanical test** (a waiver is expected
profile debt **iff every** named miss resolves to an artifact whose producing
technique is out of profile; one in-profile miss takes the whole waiver out of
the class; the test is **re-read at every render, never cached**) · **the record
is the AW, unchanged** — `AW-<n>`, the six fields of §4.1, **no new instrument
and no fourth row in §4.3's table** — with two field conventions so the class
reads the same everywhere (the **Reason** names the profile and the out-of-profile
techniques; the **Revisit trigger** stays event-shaped, canonically *"when the
profile switches to Discovery, or any of the four is elected at plan
composition"*) · **the rendering, and only that** — the class is named **once per
surface** and **re-litigated at none of them**, never as a finding, an anomaly, a
defect or an avoidable gap · **the arming stands** — §8.2 step 3's full Scope-H
run happens as written, `CC-H-01` and `CC-H-05` **arm over the gap and keep
policing it**, lifted only by an `HA-<nn>` per the §3.3 handover rule. §3.3 gains
a **citation into §4.5** and §6.5's Presale paragraph gains the class beside its
own *"debt named — not an anomaly"*, both naming **AT-RQ-1 under Presale as the
ruled case**. §10.7's P-O4 row carries the class into the auto-AW it already
writes. **D-O84** lands in §6.1: a sheet declares its preconditions, graded
**hard** or **soft**, and an absent one renders on the snapshot's **single new
pinned line, `Preconditions open:`** — the election sees what it is taking on ·
never a silent pull-in, composition staying the BA's act · never a refusal, the
run proceeding in **assumption posture** with the dependent cells drafted and
**marked** under doc 3's principle 3, which every technique already inherits.

**What moved — the second law, one home (writing standard v0.4 → v0.5).** §3's
role rule gains its **second branch**: where `roles-permissions.md` **exists**,
nothing moves — the file's defined string, verbatim, a missing role a governance
gap approved **before** the story. Where it **does not exist** because the
standing profile leaves its producing technique out of profile, the role is
**verbatim from the canvas Core Functions actors** — the same actor surface the
role model itself derives from — and **marked at its first use**, the marked
string used unchanged thereafter, **the marker carried once and not re-stamped
per story**. Three things stay illegal: inventing a role · softening an actor to
"user" · **refusing to draft**. And the branch **lifts nothing at the gate** —
`CC-US-02` still fails those actors, and under a draft-spec destination that FAIL
is §6.5's own informative named-gap list, the client Q&A agenda. The elicitation
engine (v0.8 → v0.9) stops restating *"roles from `roles-permissions.md` only"*
at §5.2 row 3, §5.3 step 1 and §7.2 and **cites §3's two branches** instead; its
stack order, membership and the governance-wins precedence clause are untouched.

**What moved — the third law, and the sweep it demanded (all six batches, the
sequencing plan, the index).** The sequencing plan's **uniform §2 template gains
a fifth field, `Preconditions`** (v0.4 → v0.5), and **all eighteen sheets carry
it** — b1 v0.8, b2–b5 v0.3, b6 v0.8 — because a `—` only means "takes nothing"
if every sheet has been asked. **The reported case, T-12:** `domain-model.md`
(T-11) **hard** — the Policy table's entity cells are verbatim from it, §3, §4
step 4 and the §5 template comment all saying so — and `constitution.md` (T-15)
**soft**, the sheet already disclaiming the principle's authorship. **The sweep
found five more:** **T-04** — `stakeholders.md` (T-03) **hard**, TC-1's Details
cell resolving to a register entry · **T-08** — `stakeholders.md` (T-03)
**hard**, §3's who-hurts resolving to a register population · **T-09** —
`constraints.md` (T-06) **hard**, the AT-VI-3 scan's Confirmed rows, and
`competitive-analysis.md` (T-07) **soft** · **T-11** — `context.md` (T-05)
**soft**, the Boundary-references pointer canvas §8 alone satisfies · **T-13** —
`roles-permissions.md` (T-12) **and** `domain-model.md` (T-11), **both hard**,
the two halves of its own §4 step-4 coherence pass · **T-15** —
`roles-permissions.md` (T-12) **hard**, the Authorization principle's enforcement
surface the reference spine must resolve to, and `design-standards.md` (T-14)
**soft** · **T-16** — `competitive-analysis.md` (T-07) **soft**, one of four
independently sufficient sweep patterns · **T-17** — four **soft**, the grouping
and graduation inputs beside the canvas Core Functions primary. **Examined and
declared `—`, with the reason on the record:** T-01, T-02, T-03, T-05, T-06,
T-07, T-10, T-14 and **T-18** — the last the only one that needed an argument,
`roadmap.md` being **its own destination file** under the one-file-three-writers
discipline (D-B6-4) rather than another technique's artifact, its rows already
presupposed by the sheet's own first C1 trigger. **No dependency in the sweep
was structurally undegradable**, so the prompt's escape question never fired: the
index gained the matching column (v0.5 → v0.6) and **no standing cell changed**.

**What moved — the carriers, third.** Sixteen files, every string tracing to the
doc. **R1:** `ba-clear` (a new *Expected profile debt* section — the test, the
ruled AT-RQ-1 case, the class render, the three things it never does, and the
`(recommended)` marker moving to `waive instead` where every miss is expected) ·
`ba-waive-aspect` (the class as a section of the *record*, the two field
conventions, the worked `AW-2`, and the arming clause) · `ba-close-band1` (the
re-affirmation naming the class into the armed state) · `ba-status` (the head
line's class form) · `ba-auto`, `ba-orchestrator`, both mirrors (the auto-AW row).
**R2:** `story-drafting.md` (both branches, its home named, and behavior #1's
"or the story does not get written" replaced) · `ba-tier2` (stack row 3 and the
drafting step, both citing §3). **R3:** the nine technique skills that have a
precondition, each declaring it **with code + name** per register rule 5, each
closing with the same refusal — *never refuses this run and never pulls its
producer in* · `ba-aspect` (the rule, the pinned line in the block, and both
render-whole lists).

**The suite: 17 of 17 green. Four counts moved; every other count is unmoved.**
`check-orchestrator.sh` **501 → 520** — three from the change-record stack (the
v0.32 assertion the bump displaced, `D-O83–D-O84`, `## 36`), the header pin
re-anchored to v0.33 and the contiguity check to `1…84`, plus a sixteen-assertion
**EC-18 section**: §4.5's existence, the mechanical test both ways, the AW
unchanged, the no-re-litigation rule, the arming standing, §3.3's citation, the
threshold staying profile-blind, §6.5's class, §6.1's rule and its pinned line,
visibility-never-a-block, no-silent-pull-in, a live `check-cards.py` call proving
the card survived the edition, and a `hasnt` on the relaxation that must never
appear. `check-techniques2.sh` **122 → 127** and `check-techniques3.sh`
**159 → 166** — the declarations on T-04/T-08/T-09 and T-11…T-16, plus a loop
asserting **no sheet converts a precondition into a refusal**. `check-spine.sh`
**253 → 266** — the two role branches in `story-drafting.md` and the Tier-2
skill, T-17's declaration, and a `flat_has`-guarded probe that the absolute
*"or the story does not get written"* rule is gone. `check-register.sh` **63**,
`check-budget.sh` **50**, `check-auto.sh` **250**, `check-status.sh` **115**,
`check-gate.sh` **105**, `check-m.sh` **71**, `check-wbs.sh` **99**,
`check-techniques.sh` **104**, `check-layout.sh` **117/0/0**, `check-exit.sh`
**99**, `check-install.sh` **64** — all unmoved.

**The compiled cards did not move, and that is an assertion.** `at-thresholds.md`
is **byte-identical** — the intended outcome of homing D-O83 in §4.5 rather than
§3.3, and now checked by a live `check-cards.py` call inside the orchestrator
suite. `assertions-f.md`, `assertions-h.md` and `assertions-s.md` are
byte-identical: **no CC wording moved**, `CC-H-01`, `CC-H-05` and `CC-US-02`
keeping their pass conditions, read sets and classes verbatim.

**Falsification, and what it caught.** A single printed sweep over the
methodology and the payload, in three parts — the killed behaviours absent, the
sheet grammar complete, the required strings at their one home with their
citations counted. It caught four things, two of them real. **Real:** the class
name never rendered in `ba-close-band1`, which carried only the hyphenated
adjectival form — the head line now names it; and the register's rule-5 sweep
found **25 bare codes** in the new precondition text, every `(T-11)` written
without its technique name, which is exactly the defect that rule exists for —
all nine declarations plus `ba-clear` and `ba-waive-aspect` were rewritten to
code + name, and the seven cascading self-test failures cleared with them.
**Probe errors, corrected rather than papered over:** one probe counted the
change record's own quotation of the killed string *"roles from
`roles-permissions.md` only"* as a live hit — legitimate text, the EC-17
precedent exactly, and the probe was re-anchored to live lines; another counted
index columns with a pipe-naive `awk` and mis-read the one row carrying an
escaped pipe in a code span.

**What did not move.** **No threshold text** — §3.3's eighteen criteria, their
grade, allocation and the handover rule stand as **D-O4** locked them, and the
two locked conditionality notes (D-B5-3, D-B4-4) are untouched; the paragraph
§3.3 gains is a citation, not a third note. **No profile set** — D-O15 and D-O19
are not re-ruled; T-11, T-12, T-13 and T-15 stay out of the Presale profile,
electable at any P-O2 exactly as D-O14 has always had them, which is the pass's
whole point: the run's repair path was already legal and is now on the record
rather than improvised. **No instrument** — §4.3's three stay three and the AG
stays outside them; §4.1–§4.4 are byte-unchanged. **No assertion, no gate
verdict rule, no waiver-vs-override calculus.** **§8.2 untouched** — closure's
preconditions, its four steps, D-O7 and D-O62 each stand; §4.5 states the arming
consequence by citing them. **No new prompt point, no new aspect state, no new
transition, no new event kind, no new ledger field, no new record class, no new
signal, no new status value** — §6.1's closed `Status` vocabulary (D-O12) is
untouched and the snapshot gains exactly **one pinned line**. **No fixture moved,
no template moved, `tests/layout.expected` unchanged**, and §8's ≤ 8 Presale
interaction budget is arithmetically untouched — a render that names a class is
the render it already was. **The completeness contract, the gate definition, the
source-audit definition and the phase-2 build plan are untouched.**

**Citation honesty, on the record.** The prompt's basis line names the **field
defect report of 20 August 2026, items B5–B7**. **That report is not in the
repository and is not in `~/Downloads`** — `docs/field-notes/` holds only the
2026-08-20 *Slack-scan corpus miss*, a different document on a different
component — so it was never read this session. Per the prompt's own instruction
and the EC-17 precedent, **only the dictated anchors were used, verbatim**, and
**no inferred mapping is presented anywhere as a citation**: B5 → D-O83, B6 →
standard §3, B7 → D-O84, each stated in the prompt itself. Where a doc names a
count from the report — the 16 draft specs and 37 markers of B6 — it is the
prompt's own figure, carried unchanged.

**Incidental, noticed and deliberately not fixed.** **T-13, T-15 and T-12 already
carried their dependency in §4 step 1** ("after T-11", "after T-12") — the fact
was on the sheet all along and B7's complaint is precisely that a *procedure*
step is not a surface an **election** reads. That is now stated in b4's change
record rather than treated as a contradiction, and the step-1 sentences stand
byte-unchanged. **A precondition's grade is an authoring judgement, not a
derived value** — nothing computes `hard` from a sheet's text, so a future sheet
edit can outgrow its own declaration with no check noticing. **Routed, not fixed
here.**

**Open — routed from this pass.** **No check derives the precondition grade** —
`hard`/`soft` is asserted string-wise, never re-derived from the §3/§5 text it
summarizes; the same class of gap as D-P2-14's missing regression assertion.
**The catalogue index has no compiler** — it is regenerated by hand at every
batch bump, and its own "on divergence the sheet governs" clause is enforced by
nothing; a `check-index.py` re-deriving all eleven columns from the six batches
is the natural sibling of `check-cards.py` and is **named, unbuilt**. **The
`Preconditions open:` line has no fixture** — `tests/fixtures/.../aspect-plans.md`
carries no snapshot exercising it, so the render is asserted in the skill and
never executed. **Standing and carried unchanged:** the B8 comment discipline
still enforced by nothing; the reconciliation family (runtime `AS` ↔ audit `OB`);
§10.1's P-O0b act cell and its cross-cutting omission; `check-audit.sh` ·
`sk_audit.py`, named and unbuilt. **EC-19**, registered 2026-08-21, is untouched
by this pass.

## The Undefined Cases Get Law — EC-19 errata, documents before code · orchestrator v0.34 · package 0.1.36 · 21 August 2026 · GREEN

**Session prompt:** close **EC-19**, last of the three errata — items
**B9-residual**, **B10** and **B12** of the 2026-08-20 field defect report,
plus the **routed-not-fixed** half of the B8 pass — under the BA's standing
ruling **"apply all recommendations"** (21 Aug 2026). Four rulings legislated
into the orchestrator **first**, then propagated into 44 carriers, every
carrier string tracing to the doc's locked text. Question protocol: nothing
silently resolved.

**Precondition, clean.** `HEAD` and `origin/main` both at `77985a6` (the EC-18
presale-circularity commit, package 0.1.35), VERSION `0.1.35`, tree clean, all
17 checks green at baseline — `check-orchestrator.sh` 520, `check-auto.sh` 250,
`check-spine.sh` 266, `check-cards.py` byte-identical. No sibling pass appeared
in the tree at any point; the 47 files this pass staged are the only files that
moved.

**Origin — one shape, three escapes and a stranded discipline.** B9-residual:
v0.31 ruled the endpoint facts, the corpus declaration and that a sample never
grounds a negative, and left one case open — a listing **cut before
completion**. The field run hit it (paging denied by a permission classifier at
page 3), rendered the candidate line, withheld the coverage line, and had
**nothing on the record to be right by**. B10: `/ba-auto` names four stop
events and only **two** had a pinned render; both untethered stops — the
Presale destination reached under the first grant, two ⚑ sign-offs under the
second — fired in one session, and the render was improvised **twice**. B12:
the BA said *"accept and shut up"* and the pinned resumption shape still
demanded the full trail, one line per act, ~27 lines. B8's routed half: the
line-anchored ledger-edit discipline was stated in two template comment blocks
and existed nowhere as law. **Documents before code by ruling:** the
orchestrator moved first and every carrier string traces to it.

**Citation honesty, on the record.** The prompt's basis line names the field
defect report of 20 August 2026, items **B9 · B10 · B12**. **That report is not
in the repository and is not in `~/Downloads`** — `docs/field-notes/` holds the
2026-08-20 *Slack-scan corpus miss*, a different document on a different
component — so it was never read this session. Per the prompt's own instruction
and the **EC-17 / EC-18 precedent**, **only the dictated anchors were used,
verbatim**, and **no inferred mapping is presented anywhere as a citation**: B9
→ D-O85, B10 → D-O86, B12 → D-O87, B8-routed → D-O88, each stated in the prompt
itself. Where the doc names a figure from the report — the cut at page 3, the
~27-line trail — it is the prompt's own figure, carried unchanged.

**Three questions surfaced before a byte moved; all three ruled as
recommended.** *(1)* **R1's residue.** The prompt's gate — *ask only if the
declaration grammar cannot carry the interrupted case without extension* — did
**not** fire: D-O81's grammar carries it, and the pinned block gains one
conditional line as an **instance** of that grammar, on the same
amended-on-the-record footing D-O70 and D-O80 already used. What the ruling
genuinely left open was the block's **second** count line: `and <N> more
matched` **withholds** with the no-match line, because D-O54 already says *the
complete listing is what makes `<N>` honest*. `<k> channel(s) excluded by BA
ruling` **renders unchanged** — it states the scan's own act, never the
workspace. *(2)* **One shape for both untethered stops**, against D-O63's law
line standing alone and against two separate shapes. *(3)* **The trail
conditional is deterministic** — it **collapses**, not *may collapse*.

**What moved — the law first (orchestrator v0.33 → v0.34, D-O85–D-O88).**
**D-O85 — the interrupted listing** (§8.1, D-O80's corpus rules extended on the
record): a cut yields a **partial corpus**, and the three consequences are
**not symmetric** — a **positive stands** on D-O53's candidate line unchanged ·
a **negative and the coverage line are never grounded by it**, the pinned
`no channel matches …· listed <n> channels` line being one line carrying both a
negative and a completeness claim · the **count line withholds with them**
(D-O54 applied, not new law) · the **cut renders**, never silently, on **one
new conditional line** of D-O45's pinned block · and a **retryable cut is
retried first**, a cut never converted into a negative by narrowing an axis or
falling back to the endpoint D-O54 removed. **D-O86 — the mid-grant stop
report** (§10.7, new): D-O51's hold conditions **2 and 3** are **one class** —
auto halts mid-grant and hands control back, the grant **not closed** and **no
ratification asked** — and get **one pinned shape, four lines**, the **event
named first**, the resumption act and the grant's standing last, with the
**D-O82 closing ask following as the tail that rule already defines**. **At a
safety-floor stop the grant stands; at scope exhaustion it reaches no further**
— stated, never inferred. **§10.7's shape count moves two → three.** **D-O87 —
the trail after ratification** (§10.7, D-O52's shape amended on the record):
**one conditional on the trail line alone** — a **full** ratification already
standing collapses it to its count plus the ledger pointer; absent that the
full one-line-per-act trail is the pinned default; **a ratification naming
exceptions renders the full trail**, because an act nobody can see is an act
nobody can except. **The report is still six lines.** **D-O88 — the ledger edit
discipline** (§2.4, new): head lines and section headings of the two runtime
ledgers are edited **line-anchored**, full-line match at line start, **never by
substring search**; the reach is those two files at the grain the defect has,
body content arriving by append and having no anchor to get wrong.

**The two amendments this forced, both on the record.** **§10.3 rule 9's AUTO
exemption** is narrowed to the **two renders it names**: its stated rationale —
*"no mid-run questions exist there"* — is exactly what B10's two events
falsify, since both **end the turn awaiting BA input**, which is D-O82's own
trigger. **§10.3 rule 8's pinned-format list and its *only BA-facing renders*
sentence** now carry **three** shapes, not two. **Rule 8's precedence itself is
untouched** — the shape governs, rule 7 still does not reach a pinned shape —
and D-O87 **dissolves** the B12 conflict **inside the shape** rather than
resolving it against rule 7, which is stated explicitly so the next session
never has to infer it.

**What moved — the carriers, second. 44 files, every string tracing to the
doc.** **R1:** `ba-frame` — the pinned block (byte-identical to §8.1's, now
eight lines) and a new **interrupted-listing branch** in the scan clause, four
sub-rules deep, carrying no framework-law text of its own. **R2 · R3:**
`ba-auto` (hold conditions 2 and 3 naming their render, the new
**mid-grant stop report** section, the resumption shape's two trail forms, the
conditional stated as *one and only*, the never-list's render claim now three
and gaining *never halts mid-grant without the stop report*, and the
front-matter description) · both **mirrors** (the third shape compiled byte-
identical, the trail conditional, the advisory tail explicitly **not** extended
to the new report) · `ba-orchestrator` (the safety-floor paragraph naming the
halt render). **The register sweep:** the compiled self-check block lives in
**42 payload files** and every one of them now names three BA-facing renders —
guarded before a byte moved, all four exact strings counted across the payload
(42 · 3 · 3 · 6) and re-counted after. **R4:** both ledger templates cite
**§2.4, D-O88** instead of standing alone, their day-old discipline text kept.

**The suite: 17 of 17 green. Two counts moved; every other count is unmoved.**
`check-orchestrator.sh` **520 → 564** — three from the change-record stack (the
v0.33 assertion the bump displaced, `D-O85–D-O88`, `## 37`), the header pin
re-anchored to v0.34, the contiguity guard to `1…88`, the pinned-block line
count **7 → 8** with its comment extended, the two render-delta constants
re-pinned and two new ones added (`CUT_LINE`, `COUNT_LINE`), plus a
**37-assertion EC-19 section**: D-O85's asymmetry in all three parts and both
carriers, a `hasnt` on the killed coverage path, D-O86's shape lines and the
rule-9 narrowing, a live probe that **every** D-O51 hold condition names a
render, D-O87's collapsed line and the stated precedence, D-O88 with its
routed-not-built marker, and both templates' citation. `check-auto.sh`
**250 → 278** — the **mid-grant stop report extracted from §10.7 and compared
byte-for-byte against all three compiled units** (the resumption report's own
machinery, reused at a third head), a five-phrase vacuity guard, a **four-line
count guard** so a fifth line cannot arrive unruled, a dropped-line **control**
that must go red, the hold-condition sweep on four surfaces, and D-O87's two
trail forms in the extracted shape. `check-m.sh` **71**, `check-gate.sh`
**105**, `check-techniques.sh` **104**, `check-techniques2.sh` **127**,
`check-techniques3.sh` **166**, `check-spine.sh` **266**, `check-register.sh`
**63**, `check-wbs.sh` **99**, `check-status.sh` **115**, `check-ledger.py` **19
rules**, `check-layout.sh` **117/0/0**, `check-exit.sh` **99**,
`check-install.sh` **64**, `check-budget.sh` **50** — all unmoved.

**The compiled cards did not move, and that is an assertion.**
`at-thresholds.md`, `assertions-f.md`, `assertions-h.md` and `assertions-s.md`
are **byte-identical to `77985a6`**, checked by name and by
`check-cards.py`'s own re-derivation: no CC wording moved, no threshold text
moved, and nothing this edition ruled travels into a card.

**The new checks were proved non-vacuous, not assumed.** Four seeded breaches,
each reverted: the mid-grant stop report dropped from hold condition 2 (the
live hold-condition probe fired) · D-O85's *a positive stands* inverted (fired)
· the interrupted line removed from the pinned block (the byte-identity compare
**and** the eight-line guard both fired) · one line dropped from AGENTS.md's
copy of the new shape (the three-carrier byte-match fired). The suite returned
to 564 / 278 green after each restore.

**Falsification, and what it caught.** One printed sweep over the doc and the
carriers, in five parts — the killed states absent, the required strings at
their one home, the citations pointing at them. **It caught two things, both
probe errors, corrected rather than papered over:** the sweep expected the
third shape in **45** payload files when the register self-check block lives in
**42** — the probe now compares the two **sets** rather than trusting a guessed
number, which is the stronger assertion; and it expected the collapsed trail
line **once** in the document when it legitimately stands **three** times —
pinned block, D-O87's ruling, §37's record row — exactly the pattern the
no-match line has carried since v0.31, and the EC-18 precedent for a probe that
counts a document's own quotation as a live hit. **No finding against the work
survived.**

**What did not move.** **D-O53's key and D-O54's method, match rule and
deterministic ranking** — D-O85 rules what a listing that never finished may
ground, and changes nothing about how a listing is taken or filtered. **D-O80
and D-O81 stand word for word**, extended and never rewritten, and the **P-A1
band-wide-search-set application stays routed**, as v0.31 left it. **The safety
floor keeps its four acts** (D-O37, D-O42) — D-O86 renders a stop, it does not
move one. **No §10.7 policy row added and none moved.** **D-O36's one-batch
ratification at `off` stands** — D-O87 shortens a **report**, never a record:
the AUTO stamps append to `.specify/aspect-state.md` unchanged. **D-O63's law
line is untouched** and keeps its slots. **D-O69's decision-list tail is not
extended to the new report** — stated on both surfaces, never left to
inference. **No new prompt point, no new stop, no new event kind, no new ledger
field, no new record class, no new state, no new transition, no new instrument,
no new status value, no threshold text and no assertion text.** **No fixture
moved, no template body moved, `tests/layout.expected` unchanged**, and D-O33's
≤ 8 Presale interaction budget is arithmetically untouched — every render this
edition adds fires at a turn-ending stop that already happened. **The writing
standard, the elicitation engine, all six catalogue batches, the sequencing
plan, the index, the completeness contract, the gate definition, the
source-audit definition and the phase-2 build plan are untouched.**

**Incidental, noticed and deliberately not fixed.** **`ba-close-band1` and
`ba-enter-feature` each say "one of the four events that end the run's turn"
without enumerating them** — read and left alone: each scopes itself to its own
band-boundary event and names its own render, so neither carries a stale count.
**Routed, not fixed here.**

**Open — routed from this pass.** **The `Ratify:` line under a prior
ratification** — where D-O87's condition fires, the resumption report still
renders `Ratify: accept all / list exceptions`, an ask for a ruling already
given; that is a **second conditional on a second line**, which is a second
ruling, and the prompt ruled one. **The enforcing check for D-O88** — nothing
asserts a line-anchored edit and nothing forbids a template from re-embedding a
literal heading string; **named routed-not-built for the regression-floor
pass**, as the B8 pass left it and as D-O88 now says on the record. **The `<m>`
in the interrupted line is often `unknown`** — a tool that denies page three
rarely states how many pages there were, so the honest render carries a hole
the grammar allows and no rule can fill. **The mid-grant stop report has no
fixture** — the shape is asserted in four places and executed in none, the
`Preconditions open:` gap of the previous pass, one shape over. **Standing and
carried unchanged:** no check derives a precondition grade; the catalogue index
has no compiler; the reconciliation family (runtime `AS` ↔ audit `OB`);
§10.1's P-O0b act cell and its cross-cutting omission; `check-audit.sh` ·
`sk_audit.py`, named and unbuilt. **The EC wave is closed:** EC-17, EC-18 and
EC-19 are all landed, and no errata item from the 2026-08-21 registration
remains open.

**Correction, on the record.** This entry and the `8b5601c` commit message both
first said **46 carriers**; the true count is **44** — 36 skills, 4 personas, 2
mirrors, 2 ledger templates, verified against `git show --name-only`. The two
figures in this entry are corrected; the commit message stands as written and
is wrong on that one number. Nothing else moves: the 49 staged paths are the
44 carriers plus the orchestrator document, two checks, `VERSION` and
`BUILD-LOG.md`.

---

## The Estate Takes A Guest — the humanizer vendored, explicit invocation only, documents before code · orchestrator v0.35 · package 0.1.37 · 21 August 2026 · GREEN

**Session prompt:** close the sync-board item **"Женя: додати скіл Humanizer у
фреймворк"** (team sync 20 Aug 2026, AI #2) under the owner's ruling **option
A** — *"вендоримо pinned SKILL.md у payload + обгороджуємо застосування, після
EC-16"* (21 Aug 2026). Lane B: legislate in the orchestrator **first**, then
vendor. Question protocol: nothing silently resolved; every failed assertion a
stop.

**Precondition, clean.** `HEAD` and `origin/main` both at `8a914e0` (the EC-19
BUILD-LOG correction, package 0.1.36), VERSION `0.1.36`, tree clean.
**Sequencing satisfied, and not by the prompt's own test:** the prompt asked for
an EC-16 entry in the BUILD-LOG *tail*, and there is none — three EC passes have
landed on top of it since. EC-16 is established instead by its own closure
heading at **line 10095**, *"The Guard On Our Side Of The Fence — EC-16
installer integrity reaches the code · package 0.1.32 · GREEN"*, with the EC-19
tail confirming EC-17, EC-18 and EC-19 all landed after it. **The stronger
check, recorded rather than substituted silently.**

**Origin — a directive that fights the framework if you just do it.** The team's
complaint is real and it is not about the artifacts: framework-adjacent prose
reads as machine-written, and there is a mature MIT skill upstream that does
exactly this repair. **Installing it unfenced is the problem.** A skill with a
broad `description:` is offered on relevance, and framework prose is relentlessly
relevant to a prose-repair skill — it would reach `spec.md` bodies, the pinned
exports and the ledger heads, **every surface the writing standard already
owns.** Two owners of one sentence is one owner too many, and the second one
wins **silently**, because a rewrite that preserves meaning leaves no diff a
reader would question. Option A ships the tool and fences the tool.

**The pin moved under the ruling — stopped, rendered, ruled.** The ruling named
**v2.11.0**; upstream stood at **v2.11.2** (`e2e92e7` HEAD, 18 Aug 2026). Per
the prompt, the pin is the owner's, so the pass **stopped before writing a
byte** and reported — with the delta measured rather than guessed: `SKILL.md`
between `43c9767` (2.11.0) and 2.11.2 is **four lines** — the frontmatter
description, the version string, and the opening body sentence — **all 35
patterns byte-identical**, the intervening releases being packaging changes to
files this estate does not vendor. Because local delta (a) replaces the
`description` block outright, the choice reached the shipped artifact as **one
prose line.** **Owner ruled: pin 2.11.2 at `38b8890`** — the commit that *sets*
the version, not the clone HEAD, which stands one README-only commit later.
**LICENSE asserted MIT and byte-identical at both points.**

**D-O89, ruled and applied.** *The humanizer vendored as an estate skill —
explicit invocation only; the canonical-artifact fence is absolute.* The skill
ships at `payload/claude/skills/humanizer/`, pinned to upstream
**https://github.com/blader/humanizer**, **v2.11.2**, commit
**`38b88903a5080c72a8c0472e79dcc9ffbf07938b`**, MIT, licence vendored verbatim,
provenance recorded beside it. **Invocation is explicit BA request only** — the
skill never self-triggers, and §10.3 rules 1–9 remain the only law over
framework prose. **It never applies to a canonical artifact** — `spec.md`
bodies, §10.5 pinned exports and renders, ledger heads and pinned blocks, gate
and audit records, `BUILD-LOG.md` — and an **explicit** ask against one is
**declined with a pointer to the writing standard**, because **the fence is a
property of the artifact and never of the asker.** Lawful surface: free prose
the BA supplies or requests. **Naming is law, not habit:** the directory and
skill keep upstream's `humanizer` and take no `ba-` prefix — the prefix marks
framework-owned skills, and a vendored guest does not wear the house colours.

**Rejected and routed, both on the record.** **(B) pipeline wiring** — a
mandatory humanizer pass on named surfaces — **rejected**: it mutates pinned
shapes (a pass that may merge paragraphs may move a line the framework's
assertions count), and it contradicts *"counts render, the BA judges."* **(C)
distilling the 35 patterns into §10.3** on this section's own **ASD-STE100
mined-as-reference precedent** — **not rejected, routed**: parked to the master
conversation pending field runs, and named in §38 so it is not rediscovered as
a new idea.

**Documents first, then the payload.** Orchestrator **v0.34 → v0.35**: the
change-record header entry, **§38** (review record v0.34 → v0.35), the D-O89
decision row, and **§10.3 rule 10** — the humanizer boundary, additive, rules
1–9 untouched word for word. Every edit assertion-guarded, each anchor
`count == 1` before replacement and re-grepped after.

**The compilation obligation §10.3 carries, honoured.** §10.3 states its rules
are *"compiled verbatim into the CLAUDE.md framework block and all four
personas"* — v0.32 compiled rule 9 into **six** carriers. Rule 10 inherits that
and is now byte-identical in all six: `payload/mirror/claude-block.md`,
`payload/mirror/AGENTS.md`, and the four personas. **The register self-check
line is untouched** — it compiles a curated subset (rules 1, 5, 6, 7), not every
rule, so rule 10 adds no clause and the byte-identical pin across 42 units still
holds.

**Payload — three files, exactly two deltas.** `SKILL.md` carries **(a)** the
frontmatter `description` replaced with the fence-stating text (block scalar `|`
→ `>-` so the value folds to exactly the specified single line), so a loader
that offers skills on description match cannot offer this one for framework
prose; and **(b)** a **Scope fence (BA-Native Spec estate law, D-O89)** block at
the top of the body, immediately after the `# Humanizer` heading and before all
upstream prose, its first line marking it a local addition. **`diff` against
upstream shows those two hunks and nothing else — all 35 patterns stand as
upstream wrote them.** `LICENSE` is byte-identical to upstream (`cmp` clean).
`PROVENANCE.md` records URL, pin, commit, date, the measured 2.11.0→2.11.2
delta, the pin ruling, and both local deltas.

**Manifest, installer, registry — the guest is installer-laid, so the estate
certifies it.** Three places enumerate skills selectively and the `ba-*` glob
does not reach a guest by design: `install.sh`'s manifest hash-list gained a
**separate** `humanizer/**/*` entry — **never a widened `ba-*` glob**, because
the prefix distinction is what D-O89 just legislated; `install.sh`'s re-install
cleanup gained an explicit `rm -rf` for the vendored directory, without which it
would linger through a re-install and stop being a true ⬒-replacement; and
`tests/layout.expected` gained three rows on the **S9 late-addition precedent**
(`ba-audit`'s block). **The copy needed nothing** — `payload/claude/` is carried
wholesale. **Verified against a real install:** 99 files hashed (was 96), all
three humanizer files certified, `verify-manifest.py` exit 0; a planted
`STALE.md` in the installed skill was gone after re-install, and the manifest
re-verified. **No mirror artifact invented** — `payload/mirror/claude-block.md`
holds a `/ba-*` **command** table, not a skills index, and a guest invoked by
asking is not a command; rule 10 in that same file is where the BA learns it
exists.

**Four test globs narrowed, and why that is the fix and not a weakening.** The
standing-instruction sweeps — session boundary (§10.2), register self-check
(§10.3), the mode read, and the mode → self-check → boundary stack order — take
their unit set from `payload/claude/skills/*/SKILL.md`, so the vendored file
entered the framework corpus and was demanded to carry framework standing blocks
(42 units → 43, six reds in `check-register.sh` and two in `check-auto.sh`).
**The alternative fix was a third local delta**, which would have made the guest
a framework unit and broken the byte-identity guarantee. All four globs now read
`skills/ba-*/SKILL.md` — **framework units only**, which is precisely the
distinction the naming ruling exists to carry. **The rule-5 code sweep was left
at `*`** deliberately: the guest is BA-facing prose, it renders no framework
code today, and keeping it in that corpus is a live safety net.

**Correction applied, as ruled.** The document's trailing version line still
read **`decisions D-O1–D-O82 locked`** while the document carried D-O88 — a
**two-edition lag**, standing since v0.33. Surfaced before writing and ruled by
the owner: corrected to **`D-O1–D-O89`**, on the record here rather than
repaired silently.

**What did not move.** **The writing standard is untouched** — D-O89 protects it
by naming it, never by amending it. **§10.3 rules 1–9 stand word for word**, and
rule 9's D-O86 amendment is not touched again. **No pinned shape is edited** —
the fence exists so that none needs to be. **No skill renamed, none
re-prefixed:** the 36 framework skills keep `ba-`, and both hard-coded 36-counts
(`check-layout.sh`, `check-install.sh`) are arithmetically untouched **because**
the guest takes no prefix. **No new prompt point, no new stop, no new event
kind, no new register, no new ledger field, no new record class, no new state,
no new transition, no new instrument, no new status value, no threshold text and
no assertion text.** **No fixture moved, no template body moved, no card moved**
— `check-cards.py` reports every card byte-identical to its re-derivation.
**D-O33's ≤ 8 Presale interaction budget is arithmetically untouched:** an
explicit-only skill adds no render to a run that never asks. **The elicitation
engine, all six catalogue batches, the sequencing plan, the index, the
completeness contract, the gate definition, the source-audit definition and the
phase-2 build plan are untouched.**

**Suite — 17/17 GREEN**, the three install-based runs included. Movement, all
upward and all accounted: `check-orchestrator.sh` 562 → **566** (the two new
edition rows plus the two pins that had gone stale), `check-register.sh` 57 →
**63**, `check-auto.sh` 276 → **278**. `check-spine.sh` 266,
`check-layout.sh` 120/0/0, `check-install.sh` 64, `check-cards.py`
byte-identical — all unmoved.

**Noticed, not touched.** An untracked **`_to_delete/`** directory (`z2`, `w2`,
`x5`) appeared in the working tree **mid-session** — it was not present at the
clean precondition and is **no part of this pass**. Under the concurrent-pass
discipline it was neither staged nor removed: staging was by **named path
only**, and the 17 paths this pass staged are the only files that moved.

**Open — routed from this pass.** **Option (C), the pattern distillation** — the
35 upstream patterns read against §10.3's ten rules, distilled where they earn a
rule and dropped where they do not; **parked to the master conversation pending
field runs.** **Nothing enforces the fence but the skill's own text** — the
scope block and the description state it, and no check asserts that a humanizer
invocation did not touch a canonical path; the fence is documentary, as the
estate's other skill-level boundaries are, and an **enforcing check belongs with
the regression-floor pass where D-O88's check already waits.** **The upstream
pin will drift** — 2.11.2 was already two releases past the ruling's 2.11.0
within four days, and nothing in the estate watches for it; **refresh is a
ruling, never a routine.**

## The Slack Item Is Never Folded — the Frame closing ask shaped by the line that rendered, documents before code · orchestrator v0.36 · package 0.1.38 · 22 August 2026 · GREEN

**Session prompt:** codify the **owner ruling of 22 Aug 2026** — one clause at
the D-O53/D-O80 source-inventory law, under the next free D-O — then propagate:
the `ba-frame` closing-ask worked shape outcome-shaped, the affected harness
pins moved in step (`check-budget.sh`; `check-orchestrator.sh`
version/contiguity). Law: **documents before code** — the clause lands in the
orchestrator first.

**Precondition, clean.** `HEAD` and `origin/main` both at `be66dd8` (the
humanizer pass, package 0.1.37), VERSION `0.1.37`, tree clean; the orchestrator
header at **v0.35** and the ruling block **contiguous through D-O89** — the
baseline the prompt names, verified on entry. The suite was run **before any
edit**: 17/17 GREEN (`check-orchestrator.sh` 566 · `check-budget.sh` 50), so
every count that moves in this pass is this pass's own.

**Origin — the scan was right and the ask lost it.** Field feedback, 22 Aug
2026, a live Presale Frame run under D-O82: the Frame closing ask carries its
Slack item in **match shape only** — *"The Slack channel #\<channel\> — read it
as a source?"*. When the scan rendered the **no-match** or the **interrupted**
line (the pinned pair D-O80 and D-O85 put into the inventory block), there was
no `#<channel>` to fill, the question **silently dropped**, and the Slack
outcome dissolved into item 1's generic *"Sources — is the list complete?"*.
Every mechanic behind the render was correct — corpus declared, negative
withheld, cut named — and the last mile folded a first-class outcome into a
generic completeness question: the D-O82 defect class one layer up.

**D-O90, ruled and applied.** *The Slack item is never folded.* Whenever
**any** of the three pinned Slack lines rendered (**match · no-match ·
interrupted**), the Frame closing ask carries **one dedicated Slack question —
immediately after the sources-completeness item — shaped by the line that
rendered**: match → the existing question, unchanged; no match → *"I listed
\<n\> channels (public + private, archived included) and none matches the
project name. Is there a channel I should read anyway?"*, with
proceed-without-Slack recommended; interrupted → the cut named in plain words
(*"covered \<n\> of \<m\> — I could not establish the full channel list"*) with
**re-run recommended — a negative never rests on a sample (D-O80/D-O81)** —
name-it-yourself and proceed-without the BA's overrides. **Where no Slack line
rendered, the existing reachability dispositions govern and no item is
invented; the Slack outcome never rides inside the sources-completeness
question.** Additive per §10.3 rule 9 and the D-O56 tail precedent — the three
pinned inventory lines byte-untouched, one stop one interaction, D-O33's ≤ 8
untouched, no new stop, no new prompt point, no new register, no threshold
moved, no assertion weakened. Landed as: the **§8.1 clause** at the
source-inventory law's tail · the **v0.36 change record** · **§39**, the
review record — which also puts on the record why a §8.1 clause and not a
rule-9 amendment (the register already says every open item becomes a
question; what no rule said is that the Slack outcome **is** an open item
whenever a Slack line rendered), and why proceed-without is never recommended
under a cut (it would convert the interruption into a resting negative — the
conversion D-O85 forbids) · the **footer line**, decisions D-O1–D-O90.

**The compile — `ba-frame` alone, the D-O80 precedent.** The closing-ask
section gains the D-O90 law paragraph — one dedicated question, exactly one of
three item-2 variants, never two and never zero, the numbering closing up
where none renders — and the worked shape's Slack item becomes **three item-2
variants carrying their render conditions in the pinned-block annotation
pattern** (*the match | no-match | interrupted variant — renders only when its
line rendered*), the match text **as shipped**, its question and options
byte-identical. **The pinned `Sources on hand:` block is byte-untouched** —
`check-orchestrator.sh`'s byte-parity probe still extracts exactly one block
per file and finds them identical. The six register carriers: untouched — rule
9 is consumed, not amended.

**The harness moves in step.** `check-orchestrator.sh`: the **D-O90** and
**§39** pins beside the D-O89/§38 pair, the header pin **v0.35 → v0.36**, the
contiguity gate **1…89 → 1…90** (`set(range(1, 91))`). `check-budget.sh`: the
**D-O90 block** at section 6's tail — the §8.1 law and the never-rides
sentence in the document, the law paragraph plus all three variants at their
fixed strings in `ba-frame` (the match text, the no-match corpus-and-ask, both
recommended dispositions, the cut named in plain words, the proceed-without
escape) — with `$FRAME` joining the missing-source guard and the GREEN roll-up
line naming the block.

**Suite — 17/17 GREEN, the three install-based runs included, verified in an
isolated copy of the tree** (the concurrent-pass discipline). Movement, all
upward and all accounted: `check-orchestrator.sh` 566 → **568** (the two new
pins), `check-budget.sh` 50 → **61** (the eleven D-O90 probes). Everything
else unmoved: `check-m.sh` 71, `check-gate.sh` 105, `check-techniques*.sh`
104/127/166, `check-spine.sh` 266, `check-register.sh` 63, `check-wbs.sh` 99,
`check-status.sh` 115, `check-ledger.py` grammar-legal, **`check-cards.py`
byte-identical**, `check-layout.sh` 120/0/0, `check-exit.sh --offline` 99,
`check-install.sh` 64, `check-auto.sh` 278.

**Files touched — six, staged by named path:**
`docs/methodology/ba-native-spec-orchestrator-rules.md` (v0.36 — header ·
change record · §8.1 clause · §39 · footer) ·
`payload/claude/skills/ba-frame/SKILL.md` (the law paragraph · the
three-variant worked shape) · `tests/check-orchestrator.sh` (the D-O90/§39
pins · the version pin · contiguity) · `tests/check-budget.sh` (the D-O90
block · `$FRAME` · the roll-up line) · `VERSION` (0.1.38) · `BUILD-LOG.md`
(this entry).

**Nothing else moves.** No pinned shape edited, no fixture, no template, no
card, no register carrier, no catalogue, no gate rule, no threshold moved; the
Presale script still counts **8 ≤ 8**.

## The Bare Boundary Asks — the closing ask joins the two exempt auto reports as pinned tails, documents before code · orchestrator v0.37 · package 0.1.39 · 22 August 2026 · GREEN

**Session prompt:** codify the **owner ruling of 22 Aug 2026** — one amendment
of D-O82's AUTO exemption, under the next free D-O — then propagate: `ba-auto`'s
both report sections and its exemption paragraph, the §10.3 rule 9 exemption
sentence and §10.7's report paragraphs in the orchestrator, the affected
harness pins moved in step (`check-budget.sh`; `check-orchestrator.sh`
version/contiguity). Law: **documents before code** — the amendment lands in
the orchestrator first.

**Precondition, clean.** `HEAD` at `2224020` (the D-O90 pass, package 0.1.38),
VERSION `0.1.38`, tree clean; the orchestrator header at **v0.36** and the
ruling block **contiguous through D-O90** — the baseline the prompt names,
verified on entry per its own gate (a 0.1.37 tree would have stopped the
pass). The suite was run **before any edit**: 17/17 GREEN
(`check-orchestrator.sh` 568 · `check-budget.sh` 61), so every count that
moves in this pass is this pass's own.

**Origin — the run ends the turn bare.** Field feedback, 22 Aug 2026, a live
`/ba-auto` Presale run: at every band boundary — P-O7 — Band-1 closure,
P-O8 — Band-3 entry — and at the resumption report, the run ends the turn with
*"Next act: … — any reply continues"* and nothing else. The BA has to invent
an arbitrary reply ("go", "move on") and **never sees the real choices** —
continue, drop to ratification, or correct something. The D-O82 AUTO
exemption, as narrowed by D-O86, is what keeps the closing ask off these two
renders: the D-O82 defect class, surviving inside D-O82's own exemption.

**D-O91, ruled and applied.** *The closing ask joins the two exempt reports as
pinned tails — D-O82's AUTO exemption amended on the record, never rewritten.*
The **band-boundary report** and the **resumption report** keep their pinned
shapes **byte-untouched**, and each gains the §10.3 rule 9 closing ask as an
**additive tail** (the D-O56 precedent), **pinned at the mode's corpus home,
never composed at the stop**. The band tail asks `Band <n> is closed under the
grant. How do we proceed?` — **continue (recommended)**, the report's
`Next act:` line in plain words · **pause and ratify**, routing to the
existing `off` act · **correct something first**; `<n>` is the band the
boundary leaves behind — Band 1 at P-O7, Band 2 at P-O8. Where the health
line renders `overdue`, one conditional option joins before c — *run
`/ba-gate-health full` first — it is overdue; no grant reaches it, this stays
your act* — **recommended staying on continue** (the health line is
display-only, D-O59, and the refresh stays BA-invoked). Where the D-O69
decision-list tail renders, its items **join the ask as questions in T-18's
step-4 shape** (`hold as advisory — no move (recommended)` …), the typed
ruling grammar staying the shortcut. The resumption tail asks `<n> AUTO acts
stand for ratification. Your call?` — **ratify all (recommended)** · **ratify
all except** — name the acts · **discuss first**; **taking (a) is the
existing one-batch ratification exactly** — the typed grammar and the ask can
never disagree (the D-O82 apply-all precedent). **Invariants stated in the
clause:** D-O52 stands — the boundary report is still a render, not a
ratification point, the ask asks for no ruling on the trail, option b routes
to the existing `off` act, and *any reply continues* stays true — the
recommended option **is** the continue; D-O51 continuity untouched — the ask
appears only at renders that already end the turn, no new stop, no new prompt
point, no mid-band question; pinned shapes byte-untouched, no new register,
no threshold moved, no assertion weakened; ratification stays the grant's
instrument at `off`. Landed as: the **§10.3 rule 9 exemption sentence amended
on the record** (D-O86 and D-O91 both named, the D-O86 narrowing sentence and
the arithmetic sentence byte-kept) · **two tail paragraphs new at §10.7**, one
per report, each with its pinned fence · the **v0.37 change record** · **§40**,
the review record — which also puts on the record why the exemption is amended
and not repealed (its pinned-shapes half keeps, its no-ask half is the
defect: both renders end the turn awaiting BA input, rule 9's own trigger),
why the mid-grant report keeps its composed ask (a floor stop names an act
the tail cannot enumerate in advance), and that §37's routed `Ratify:`-line
item **stays routed** — where a full ratification already stands, the tail's
question renders over a ruling already given, the second conditional being a
second ruling this sitting does not rule · the **footer line**, decisions
D-O1–D-O91.

**The compile — nine carriers, the D-O69 tail's own set.** The **band tail**
into every band-boundary renderer — `ba-auto` (full: fence, both conditional
joins, the presentation sentence), `ba-close-band1` (fence + `Band 1 here`
gloss, conditionals cited to `/ba-auto`), `ba-enter-feature` (fence +
`Band 2 here` gloss, same citation), both mirrors (fence + compressed
conditionals). The **resumption tail** into every resumption renderer —
`ba-auto` (full) and both mirrors (fence + compressed prose). `ba-auto`'s
mid-grant **exemption paragraph amended** — its "for those two only" sentence
now closes *"…and what it grants those two is shape, not silence"*, this
report's ask staying composed at the stop. **Rule 9's amended sentence
re-compiled into the six register carriers** (four personas, two mirrors) —
the "inert for the two renders" sentence replaced by the pinned-tail grant,
one identical replacement across all six. **The three pinned report fences
are byte-untouched in every carrier** — `check-auto.sh`'s byte-parity probes
still extract and match them exactly as before this pass.

**The harness moves in step.** `check-orchestrator.sh`: the **D-O91** and
**§40** pins beside the D-O90/§39 pair, the header pin **v0.36 → v0.37**, the
contiguity gate **1…90 → 1…91** (`set(range(1, 92))`). `check-budget.sh`: the
stale exemption pin (*"under a standing AG this rule does not apply"*)
replaced by the amended pair (amended-on-the-record-twice · the
additive-tail grant), the **D-O91 block** at section 6's tail — both question
lines and all six option lines pinned in the document, the health option and
the T-18-shape join, the D-O52 render-not-ratification pin, the
never-disagree pin, the two carrier sweeps (the band tail on all 5 renderers,
the resumption tail on all 3), and four `ba-auto` probes (shape-not-silence ·
the `<n>` gloss · any-reply-continues · all-recommended-is-apply-all) — with
`$AUTO` `$CB1` `$ENTF` `$AGENTS` joining the missing-source guard and the
GREEN roll-up line naming the block.

**Suite — 17/17 GREEN, the three install-based runs included, verified in an
isolated copy of the tree** (the concurrent-pass discipline). Movement, all
upward and all accounted: `check-orchestrator.sh` 568 → **570** (the two new
pins), `check-budget.sh` 61 → **83** (the twenty-two D-O91 probes: two
replacing the one stale exemption pin, twenty-one new). Everything else
unmoved: `check-m.sh` 71, `check-gate.sh` 105, `check-techniques*.sh`
104/127/166, `check-spine.sh` 266, `check-register.sh` 63, `check-wbs.sh` 99,
`check-status.sh` 115, `check-ledger.py` grammar-legal, **`check-cards.py`
byte-identical**, `check-layout.sh` 120/0/0, `check-exit.sh --offline` 99,
`check-install.sh` 64, `check-auto.sh` 278.

**Files touched — fourteen, staged by named path:**
`docs/methodology/ba-native-spec-orchestrator-rules.md` (v0.37 — header ·
change record · §10.3 rule 9 · two §10.7 tail paragraphs · §40 · footer) ·
`payload/claude/skills/ba-auto/SKILL.md` (both tails · the exemption
paragraph) · `payload/claude/skills/ba-close-band1/SKILL.md` ·
`payload/claude/skills/ba-enter-feature/SKILL.md` (the band tail each) ·
`payload/claude/agents/ba-analyst.md` · `payload/claude/agents/ba-discovery.md`
· `payload/claude/agents/ba-gate.md` · `payload/claude/agents/ba-orchestrator.md`
(the rule 9 sentence each) · `payload/mirror/claude-block.md` ·
`payload/mirror/AGENTS.md` (the rule 9 sentence · both tails each) ·
`tests/check-orchestrator.sh` (the D-O91/§40 pins · the version pin ·
contiguity) · `tests/check-budget.sh` (the D-O91 block · the four paths · the
exemption pin moved · the roll-up line) · `VERSION` (0.1.39) · `BUILD-LOG.md`
(this entry).

**Nothing else moves.** No pinned report shape edited — five lines, six lines
and four stand byte-identical in every carrier; no fixture, no template, no
card, no catalogue, no gate rule, no threshold moved, no policy row, no
safety-floor act; the mid-grant stop report untouched; the Presale script
still counts **8 ≤ 8**.

## The Coverage Report — a run is not closed until it renders, documents before code · source-audit definition v0.3 · package 0.1.40 · 23 August 2026 · GREEN

**Session prompt:** rule in a **permanent Stage 5b** for `/ba-audit` — the
coverage report: a run is not closed until it renders
`exports/audit-report.xlsx` (+ `audit-report.csv`, the Coverage Matrix sheet,
canonical) from the closed run's post-repair state; four pinned sheets —
Coverage Matrix (per-OB: source · section · verbatim quote · modality · phase
claim · carrier · status · finding #), Per-Source Summary (totals, statuses,
coverage % per source), Findings & Rulings (the decision list as ruled, with
outcomes), SA Register; `/ba-wbs` render conventions over the `sk_xlsx.py`
helpers; `--report` to re-render from the latest closed run without a new
audit. Land it **document-first in the source-audit definition**, compile the
skill, carry the suite, BUILD-LOG and VERSION per house discipline at the
current edition.

**Precondition, clean.** `HEAD` and `origin/main` both at `3b028bd` (the D-O91
pass, package 0.1.39), VERSION `0.1.39`, tree clean but for one untracked
sibling artifact — `docs/field-notes/2026-08-22-cc-fl-04-coverage-inversion.md`,
the CC-FL-04 triage, **neither staged nor touched** under the concurrent-pass
discipline. The source-audit definition stood at **v0.2** with the ruling block
**contiguous through D-S5**. The suite was run **before any edit**: 17/17
GREEN, so every count that moves in this pass is this pass's own.

**Origin — the evidence existed and nobody could read it.** The audit's own bar
has always been met *inside the run workspace*: every finding carries file,
place and verbatim quote, and D-S2 made the P-A1 head derive its numbers from
`obligations.md`'s rows. The defect is one layer past that. The decision list
renders **findings**; **nothing renders the register**. A closed run's whole
coverage picture — every obligation, its quote, its carrier, its status — sits
three directories down in a markdown row grammar built for the walker that
writes it and not for the BA who has to answer *what did we cover?* The
framework already ships the answer's shape one lane over: `/ba-wbs` renders a
derived spreadsheet from artifacts the estate already produces. Scope S had no
equivalent.

**D-S6, ruled and applied.** *Stage 5b — the coverage report — is permanent,
and the run is not closed until it renders.* `exports/audit-report.xlsx` and
`exports/audit-report.csv`, from the **closed run's post-repair state** — the
register as Stage 5's re-audit left it, the decision list **as ruled**, the
repairs as executed. **The render stands after the re-audit delta and before
the entry appends**, both files joining §7's required set at **D-S4**'s own
force, and the entry gaining a pinned `Coverage report:` field: an entry that
appends first and renders second names a file that may not exist, which is the
D-S4 defect one artifact along, so the fix is **ordering**, not a second
condition. **Four pinned sheets** — `Coverage Matrix`, one row per post-repair
`OB` row with the code as key and §2's row grammar as its eight columns, the
quote **verbatim** and the finding number **empty** where the list named none ·
`Per-Source Summary`, off §2's per-source coverage block, with a `TOTAL` row ·
`Findings & Rulings`, the list as ruled with each row's outcome from
`repairs.json` · `SA Register`, the **standing** records and not this run's
alone. **The csv carries the Coverage Matrix alone** and is the canonical
render. **`/ba-wbs`'s render conventions over the same `sk_xlsx.py` helpers** —
xlsx primary and written first, csv canonical and title-block-free, a title
block above the bold header row of **every** sheet, wrapped text, widths, **no
cell merges** — with **§10.5's stakeholder register expressly not carried**:
this export is **BA-facing operational state**, the report ledger's own class,
and the audit's evidence bar governs its cells, so quotes stay verbatim and
`CC-S` · `OB` · `SA` codes render as themselves. **D-S2 extends from the P-A1
head to the workbook** — every number counted from the post-repair state at
render time, an absent field an **empty cell**, and the matrix's row count, the
`TOTAL` row and the entry's `Register:` line **one figure counted three ways**.
**Coverage % = `(carried + accepted) ÷ obligations`**, whole percent, `partial`
and `gap` the uncovered remainder taking **no half credit** — a weighting is a
number this framework does not produce — and an **empty cell at zero
obligations**, because 0 ÷ 0 is not 100% and is not 0% either. **A sampled
corpus renders twice** (D-S3): the title block carries the run's own
`Corpus covered:` line verbatim, and every source the register head shows short
of its own section count carries `sample — <walked>/<total> sections walked` on
its `Note` — a spreadsheet is the most authoritative-looking render the
framework produces, and a sample it does not name is D-S3's defect in its most
persuasive form. **`--report`** re-renders the pair from the **latest closed
run** — the highest entry on the ledger, never the highest directory on disk —
with no walk, no dispatch, no ruling, no repair, **no append** and no
checkpoint; exclusive with `--full`; refusing by **naming** the missing entry
(`/ba-audit` the act) or the missing required file. **A refused admission is
stepped past; a holed workspace is not** — Stage-0 refusals take run numbers
and open no workspace at all, so `--report` steps past them **and says which**
(refusing over evidence that was never supposed to exist is the wrong answer,
and quietly rendering run 2 under a request for run 4 is the wrong artifact
under the right name), while a workspace that exists and is **short** is
refused where it stands: that run closed, D-S4 guaranteed its evidence, and a
hole in it is the one thing a step backwards must not paper over. **No new assertion, no new
CC-S family, no new instrument, no new record class, no new prompt point, no
new stop and no new status value** — P-A1 stays the one checkpoint and §8's
budget is arithmetically untouched. **The CC-S card is not recompiled** — D-S6
adds a render and no assertion, and `assertions-s.md` stands byte-unchanged
(`check-cards.py` byte-identical). Landed as: the **v0.3 header and change
record** · **§6b**, the new section, additive rather than a renumber because
the section anchors are cited from the skill, the entry template and the
harness · **§6's re-audit bullet and append condition amended on the record** ·
**§7's artifact block and required set** · **§10's unit list**, items 8–10 new
and item 7 amended · **§11's never-list** · **§13**, the amendment record —
which also puts on the record why a render was ruled and not an assertion, why
the render precedes the append, why `--report` appends nothing, and why
coverage takes no half credit · the **footer line**, decisions D-S1–D-S6.

**The compile — the skill, and the entry template.** `ba-audit/SKILL.md`: the
title and argument line take `--report` and state its exclusivity with
`--full`; the frontmatter description names the report and the not-closed-until
rule; the run-workspace block gains the two exports as **REQUIRED** and Stage 5
now **checks all six**; Stage 5's text names the close's order — delta, then
Stage 5b, **and the entry appends last**; **Stage 5b** is a stage of its own,
carrying the four sheets with their columns, the title block and its ground,
the sampled-corpus rule, the three-surface reconciliation, the conventions with
the stakeholder register expressly excluded, and the `--report` act with both
refusals; the never-list gains five clauses. Stage 4 gains **one sentence
pinning `repairs.json`'s row key** — `{"rows": [{"#": 3, …, "outcome": …}]}` —
because the `Outcome` column has to find it and nothing had ever fixed the
shape. `source-audit-report-entry.md`: head line 8, `Coverage report:`, with
its comment block. **The three standing blocks are byte-untouched.**

**The code — two units.** `sk_xlsx.py` gains **`write_book()`**, the multi-sheet
writer: one Override per worksheet, `rId1…rIdN` the sheets and `rId(N+1)` the
stylesheet, one title block per sheet, Excel's own sheet-name rules enforced
(31 characters, the six forbidden marks, no duplicate names) rather than
written. **`write()` keeps its contract and its bytes** — it is now
`write_book()` with one sheet, and the WBS workbook was regenerated against the
pre-change writer and compared: **byte-identical, both profiles**, csv
included. `sk_audit_report.py` is the Stage-5b renderer — stdlib only, read-only
over the workspace and the ledger, writing exactly two files. It **derives and
never asserts**: the register's rows are parsed at §2's own separators with the
quote scanned to its closing double quote (a client's sentence may carry a
middot of its own), the finding number rides the `OB` codes the list rows name,
the ruling comes off the as-ruled `Rulings:` line — **the menu line, which
carries the literal `<#…>` placeholders, is skipped**, because a menu read as a
ruling would print `apply` against every row of a list nobody has answered — and
an unreadable `repairs.json` leaves the `Outcome` column empty rather than
guessing.

**The harness — the eighteenth check.** `tests/check-audit.sh` **lands**, the
audit's own suite, and §10 item 7 is amended on the record to say so
(`sk_audit.py` stays pending). Six sections, 144 checks: the document (v0.3,
D-S6, §6b, §7's required set, §10, §11, §13, the footer, the entry template,
the mirror's command-table row) ·
the skill (Stage 5b compiled, the argument line, the nevers, the three standing
blocks) · the render against a new fixture — the **golden csv**, the four
sheets read back by name and column, the title block on every sheet, a quote
carrying its own middot surviving whole, the finding number on both members of
an enumerated `amend`, the derived counts, the **three surfaces one number**
reconciliation against the ledger's own `Register:` line, the coverage
formula's three cases (67% · 50% with its sample note · the **empty** cell at
zero obligations), a **`CC-S` code rendering as itself** — the stakeholder
register's only mechanical consequence — and the clean run rendering a
header-only Findings sheet under the P-A1 head's conditional `INCOMPLETE`, and
`--latest` **stepping past a Stage-0 refusal** while a holed workspace is
refused where it stands · the **four refusals**, each
naming what is missing · the writer's single-sheet contract and its name rules
· read-only, the fixture hashed across two renders. The fixture is
`tests/fixtures/nutrivity-audit/closed-run/` — two workspaces and a ledger:
**run 2** closed and on the ledger, **run 3** clean and not yet appended, **run
4** a Stage-0 refusal with a run number and no workspace. `--latest` must pick
run 2, so a directory scan and a naive `max(entry)` are both caught. `run-all.sh` goes
**seventeen → eighteen**, the new row at 10 beside the WBS export.
`tests/layout.expected` gains the renderer's row; the two export files take no
row — `exports/` holds no installer-laid file, and the layout bar asserts the
installed tree, not a run's output.

**Suite — 18/18 GREEN, the three install-based runs included, verified in an
isolated copy of the tree** (the concurrent-pass discipline). Movement, all
accounted: **`check-audit.sh` new at 144**, `check-layout.sh` 120 → **121** (the
renderer's row). Everything else unmoved: `check-m.sh` 71, `check-gate.sh` 105,
`check-orchestrator.sh` 570, `check-techniques*.sh` 104/127/166,
`check-spine.sh` 266, `check-register.sh` 63, **`check-wbs.sh` 99** — the
`sk_xlsx` extension moved nothing in the WBS lane — `check-status.sh` 115,
`check-ledger.py` grammar-legal, **`check-cards.py` byte-identical**,
`check-exit.sh --offline` 99, `check-install.sh` 64, `check-budget.sh` 83,
`check-auto.sh` 278.

**Files touched — fourteen paths, staged by name:**
`docs/methodology/ba-native-spec-source-audit-definition.md` (v0.3 — header ·
change record · §6b · §6 · §7 · §10 · §11 · §13 · footer) ·
`payload/claude/skills/ba-audit/SKILL.md` (the argument line · the workspace ·
Stage 4's `repairs.json` key · Stage 5's order · Stage 5b · the never-list) ·
`payload/specify-overlay/ba/templates/source-audit-report-entry.md` (the
`Coverage report:` field) ·
`payload/specify-overlay/ba/scripts/sk_xlsx.py` (`write_book()` · the name
rules · `write()` re-expressed, bytes unchanged) ·
`payload/specify-overlay/ba/scripts/sk_audit_report.py` (new — the renderer) ·
`tests/check-audit.sh` (new — the eighteenth check) ·
`tests/fixtures/nutrivity-audit/closed-run/**` (new — two workspaces and a
ledger) · `tests/fixtures/nutrivity-audit/expected/audit-report.csv` (new — the
golden) · `tests/layout.expected` (the renderer's row · the script count) ·
`tests/run-all.sh` (seventeen → eighteen) ·
`payload/mirror/claude-block.md` (the `/ba-audit` command-table row — the
argument and the report) · `README.md` (the two suite-count lines) ·
`VERSION` (0.1.40) · `BUILD-LOG.md` (this entry).

**Nothing else moves.** No CC-S assertion, no card — `assertions-s.md` stands
byte-unchanged and `check-cards.py` says so; no orchestrator edit and therefore
no D-O, no §41 and no orchestrator version bump — `/ba-wbs`'s §10.5 is **read
from**, never amended; no WBS column, no title-block line and no export byte in
the WBS lane; no fixture of the appointment-booking estate, no template beyond
the entry's one field, no gate rule, no threshold moved, no policy row, no
safety-floor act, no new prompt point and no new stop. The Presale script still
counts **8 ≤ 8**.

**Open — routed from this pass.** **`sk_audit.py`**, the M share of §4, stays on
§10's pending list: the render derives from a register that already exists, and
a mechanical checker of the *walk* is a different act on different ground. **A
client-facing derivative** of the coverage report is not ruled — this workbook
is operational state by construction, and a client render would need §10.5's
stakeholder register and a ruling of its own. **Whether a run may close with a
stale report** — the workspace hand-edited after the render — is named in §13
and not ruled: the register says *regenerated, never hand-edited* and
`--report` is one command, which is the answer in practice and not on the
record.

## The Repair Route Becomes Legal — the Stage-4 routing conflict and the ledger-edit law's short reach · source-audit definition v0.4 · orchestrator v0.38 · package 0.1.41 · 25 August 2026 · GREEN

**Session prompt (EC-20):** close the two defects the first post-wave field
audit found — (1) `/ba-audit` Stage 4 **mandates** dispatching the `ba-analyst`
subagent for spec edits while `ba-analyst`'s own definition **forbids any skill
from dispatching it**, so 14 ruled repair rows stand unexecuted and every
future repair route is blocked; (2) the session's own substring edit matched a
literal `## As ruled` inside `decision-list.md`'s header note and **truncated
the rendered table** — the exact B8 hazard class, which D-O88 does not reach
because it names *the two runtime ledgers*. Three rulings: **R1** the repair
lane becomes legal, **R2** ruled-unexecuted rows resume, **R3** D-O88's reach
widens. **Documents before code.**

**Precondition — the brief's base pins were stale in the forward direction, and
that is a divergence, not a stop (house precedent D162/D164).** The brief
expected `be66dd8` / VERSION `0.1.37` / audit definition **v0.2** / orchestrator
**v0.35 past D-O89**. What stood: `be66dd8` an **ancestor of HEAD** — clean
fast-forward confirmed — with HEAD at **`3b028bd`** (package 0.1.39, D-O91,
orchestrator **v0.37**) and **two unpushed commits** ahead of `origin/main`
(0.1.38 · 0.1.39); and, on the working tree, a **complete, GREEN, uncommitted
sibling package 0.1.40** — the coverage-report pass of 23 August, which had
already taken the source-audit definition to **v0.3** and edited **both** of
this pass's carrier surfaces (§6b, §7, §10, §13; the skill's Stage-4
`repairs.json` key, Stage 5, Stage 5b, the never-list). **D-1 · the pins are
verification values.** Every target moved to the next free number **above the
actual high-water**: audit definition **v0.3 → v0.4** with **D-S7 · D-S8** and
**§14**; orchestrator **v0.37 → v0.38** with **D-O92** and **§41**; VERSION
**0.1.40 → 0.1.41**. **D-2 · built on top of the sibling, never over it.** The
0.1.40 work was read, relied on and left byte-exact — its `repairs.json` row
key is, as it happens, exactly the ground R2's resumption reads. The suite was
run **before any edit**: **18/18 GREEN**, so every count that moves below is
this pass's own.

**Field evidence — the anchors, and nothing but the anchors.** The 2026-08-23
run report is **chat-only and not in this repository**; it was not read. Only
the anchors dictated in the session prompt were used, **verbatim**, and **no
inferred mapping is presented anywhere as a citation** — the EC-17 · EC-18 ·
EC-19 precedent, held. The three anchors: the conflict, **both sides live on
`3b028bd`** — Stage 4's *"Spec edits — dispatch the `ba-analyst` subagent per
target spec, draft-first, assumption posture… This skill authors nothing
itself"* against `ba-analyst.md:3`'s *"A compile source, not a dispatch target
— this text compiles into the Tier-2 skill that does the work. No skill
dispatches it, and none should."* · the outcome — the session refused the
dispatch **and** refused to author, executed the five unambiguous upstream rows
(out-of-scope basis restated · deferral narrowed · vocabulary declared ·
roadmap pointer · SA-01/SA-02) and left **14 of 19** ruled rows unexecuted,
status **INCOMPLETE** · the truncation — a substring edit matching an earlier
`## As ruled` mention in the file's own header note, caught on read-back.

**R1 · D-S7 — the fence gains one named exception.** *The `ba-analyst` fence
gains exactly one carve-out: `/ba-audit`'s **post-ruling** Stage-4 repair
route, draft-first and assumption posture exactly as Stage 4 already
specifies.* **The law lives in the audit definition (§6, D-S space); the agent
file cites it and never restates it** (§10 unit 11). **Why the fence existed and
still does:** the persona text **compiles into** the Tier-2 skill, and the
persona's body binds it to that skill's context order, cap, legality rule and
output contract — a bare dispatch is **an author working without a
definition**, producing a spec nobody scoped, capped or contracted. **Why this
route is the exception:** the dispatch is post-ruling, so P-A1 has already
fixed every input the Tier-2 definition would have supplied — target spec,
verbatim quote, approved proposal, posture. **The definition arrives as the
ruling.** **Why the A5 class does not reopen:** D-S1's separation is the
**evaluator's** — the judge writing the verdict it was to have received — and
this carve-out runs the other way, existing so the audit **need not** author.
**Silent self-substitution stays a defined violation of §4**, untouched and
unweakened; the audit's *authors nothing itself* bar (§11) stands exactly as
written. **D-S7 moves who may be dispatched, never who may write.** And the
refusal now has a landing: where the dispatch is **undispatchable** (§4's third
state) the row stands `unexecuted` with its `why` — never self-authored — and
**stops nothing else**: the remaining rows run, the re-audit runs, the report
renders, the entry appends with the run's true status.

**R2 · D-S8 — the standing ruling carries.** *A row standing ruled and
`unexecuted` in the most recent run that wrote a `repairs.json` re-enters the
next run's Stage-4 route, **ahead of that run's own rows**, on the ruling it
already carries.* **Drawn from the route's own grammar, adding nothing:**
`repairs.json` already records `unexecuted` **with its `why`**, keyed by the
decision-list row number (the 0.1.40 pass's key), and `decision-list.md`
already holds the row **as ruled** — **both §7 required files**, so the
resumption is a **read**. **No re-ruling and no second P-A1 render** — that
checkpoint rules the findings *this* run's A pass raised, and a resumed row is
a **standing ruling, not a finding**. **The trail is one key**, `from-run`,
absent on a row this run ruled. **A re-refusal resumes again** with its
possibly-different `why`; **no count of attempts closes a row**, and a row does
not expire — only execution, or a ruling. **Closure without execution is
named** `superseded — <reason>`, never silent: the read that brings a row back
is the read that would have to drop it. **No new flag, no new instrument, no
new file, no new prompt point, no new stop, no new BA interaction** — §8's
budget is arithmetically untouched. **The 14 field rows are the acceptance
case:** after a package update, the next `/ba-audit` executes them with the BA
re-ruling nothing.

**R3 · D-O92 — the edit discipline binds by class.** *The line-anchored rule
binds **every file a skill rewrites in place that carries section headings or
its own commentary**.* The two runtime ledgers as D-O88 ruled them, and the
**run-workspace files** join — **`decision-list.md` the ruled instance**.
**Bound by class and named at one instance, deliberately not an enumerated
list:** the hazard is a property of the **act** — an agent going back into a
standing file to change one line, anchored on a short string the file also says
about itself — and an enumerated set would be wrong the day a new artifact
landed without an edit to that line. **D-O88's exclusion is unchanged:** an
**append** has no anchor to get wrong, and a file **written whole** —
`obligations.md` regenerated, `trace.json` written entire — has none either.
**The B8 comment treatment travels with the rule:** a file carrying its own
note **names its sections without reproducing the literal heading strings** —
the two payload templates' discipline since 0.1.33, now binding at every
authoring site, because **the note the run wrote is what the run's own edit
then matched**. **D-O88's ruling text is byte-untouched** — the reach paragraph
is amended on the record, nothing rewritten.

**Default-taken decisions, with their alternatives (the standing delegation).**
**D-3 · R1 resolved as Recommended** — the named exception, law in D-S space,
the fence citing it. Alternatives on the record and **rejected in §14**: *the
audit authors post-ruling repairs itself under the Tier-2 drafting law* —
rejected on **separation**, since it collapses finder and author one stage
after §4 spent a section keeping finder and judge apart; *a separate
dispatch-target agent compiled from the same source* — rejected on
**duplication**, since two files from one source drift and the day they
disagree the framework has two answers to *how does a spec edit land*. The
compile-source rationale was checked for a hidden constraint against dual use
and none was found: the constraint it encodes is *an author never works without
a definition*, which a named exception serves exactly and a copy serves only
until someone edits one copy. **D-4 · R3 resolved as Recommended** — bind by
class, name `decision-list.md`, no open list. **D-5 · the resumption reads one
run deep**, not the whole band: an unexecuted row that resumes and fails again
is re-recorded by the run that tried it, so the chain carries itself forward; a
repair-history sweep is named in §14 and **not opened**. **D-6 · `from-run` is
ruled as a `repairs.json` key**, so the trail exists on disk, while **what a
sheet does with it is routed** (below). **D-7 · the two payload ledger
templates were left byte-untouched** — both were already correct under the
widened rule, and a citation churn would move bytes and no law.

**Files touched — eight paths, staged by name:**
`docs/methodology/ba-native-spec-source-audit-definition.md` (v0.4 — header ·
change record · §6 the route order, the spec-edits bullet, the two ruling
blocks · §7 the `repairs.json` forward reader and the required-set paragraph ·
§10 unit 11 · §11 · §14 · footer) ·
`docs/methodology/ba-native-spec-orchestrator-rules.md` (v0.38 — header ·
change record · §2.4 the reach widened on the record · §41 · footer) ·
`payload/claude/skills/ba-audit/SKILL.md` (Stage 3's write act · Stage 4's row
order and spec-edits bullet · the never-list) ·
`payload/claude/agents/ba-analyst.md` (the frontmatter fence · the body's
caller paragraph) · `tests/check-orchestrator.sh` (the edition ladder · the
D-O high-water 91 → 92 · the EC-20 block) · `tests/check-audit.sh` (the v0.4
pins · the EC-20 block) · `VERSION` (0.1.41) · `BUILD-LOG.md` (this entry).

**Nothing else moves.** **No card** — `assertions-s.md` stands byte-unchanged
and `check-cards.py` says so; **no CC-S family text and no assertion**, because
nothing about what the audit *checks* moved. No new skill, no new agent, no new
template, no new script, no new fixture and **no new check file** — the suite
stays at **eighteen**, so `README.md`'s two count lines and `tests/run-all.sh`
do not move, and `tests/layout.expected` takes no row. No mirror edit: the
command-table row describes `/ba-audit`'s invocation and report, neither of
which changed. No gate rule, no threshold, no policy row, no safety-floor act,
no new event kind, no new ledger field, no new state or transition, **no new
prompt point and no new stop** — D-O33's ≤ 8 Presale budget and §8's audit
budget are both arithmetically untouched. **This edition adds no render at
all.**

**Routed, not fixed.** **The coverage report's rendering of a resumed row** —
§6b's `Findings & Rulings` sheet joins *this* run's decision list to *this*
run's `repairs.json`, and a row resumed from an earlier run has its ruling in
*that* run's list; whether the sheet grows a `from-run` column, renders the
join, or shows nothing is a **render** question adjacent to D-S6 and outside
these three rulings. The key is ruled so the trail exists on disk; the sheet is
named and left. **D-O88's enforcing check** — nothing asserts a line-anchored
edit and nothing forbids a template from re-embedding a literal heading string;
**D-O92 enlarges that check's subject and does not build it**, and it stays at
the regression-floor pass where D-O88 left it. **`sk_audit.py`**, the M share
of §4, stays on §10's pending list, where v0.2 and v0.3 both left it. **How far
back the resumption may read** is named in §14 and not ruled.

**Suite — 18/18 GREEN, the three install-based runs included.** Movement, all
accounted, and both moves are this pass's own assertions: **`check-audit.sh`
144 → 178** (the v0.4 header and footer pins, and the EC-20 block — the
exception's law in the document, the fence's carve-out and its cite-never-restate
line, the body's caller paragraph, the fence sentence still *present and
amended* rather than deleted, the resumption's seven clauses, §7's forward
reader, Stage 4's row order and `from-run` key, the never-list's three new
fences, and the contradiction-pair probe itself) · **`check-orchestrator.sh`
570 → 584** (the edition ladder to D-O92 · §41 · header v0.38, the **D-O
high-water 91 → 92**, and the EC-20 block — bind-by-class, the ruled instance,
the refusal to enumerate, D-O88's exclusion kept, the comment treatment, the
enforcing check still named-unbuilt, plus the writer's own citation and a probe
that **no authored heading string stands at line start** in the skill that
writes the file). **Everything else unmoved:** `check-m.sh` 71 ·
`check-gate.sh` 105 · `check-techniques*.sh` 104/127/166 · `check-spine.sh`
**266** — the analyst's own suite is unmoved, and its **layering sweep passes
over the amended fence** · `check-register.sh` 63 — the three standing blocks
and the self-check byte-match survive the skill edits · `check-wbs.sh` 99 ·
`check-status.sh` 115 · `check-ledger.py` grammar-legal ·
**`check-cards.py` byte-identical** · `check-layout.sh` 121 ·
`check-exit.sh --offline` 99 · `check-install.sh` 64 · `check-budget.sh` 83 ·
`check-auto.sh` 278.

**Falsified, one command, four claims.** *The contradiction pair is gone* — the
bare fence terminator no longer stands in `ba-analyst.md`, the carve-out is
there, Stage 4 cites it and the law is in D-S space; **the other two agent
fences are untouched and still bare** (`ba-discovery` · `ba-orchestrator` — no
skill dispatches either, and none should). *The resumption is present at its
homes* — definition §6, §7's `repairs.json` line, the skill's Stage 4, and the
`from-run` key. *No authored `## As ruled`* — zero at line start anywhere under
`payload/`; the two fixtures hold the string as a **real heading** of a real
run's file, which is the content the rule protects, not a note that quotes it.
*The widening is cited where the workspace files are written* — the skill's
Stage-3 write act cites §2.4 **D-O88 · D-O92** and the law binds by class.

**Not committed by this session — the reservation is the sibling's, not mine.**
The tree carries the **uncommitted 0.1.40 package** and HEAD carries **two
unpushed commits** (0.1.38 · 0.1.39). Every shared file — `VERSION`,
`BUILD-LOG.md`, the source-audit definition, the `ba-audit` skill — holds both
passes' work, so **no commit of this pass can be scoped to exclude 0.1.40**,
and a push would carry all three packages to `origin/main`. Overriding a
sibling's reservation is not the session's call (the D165 precedent) — and note
the refinement this pass adds to it: **0.1.40 carries no *"Not committed"*
closing line**, so the reservation is inferred not from a declaration but from
the **arithmetic of the shared files**, which is the stronger test and the one
that should be applied first. **Put to the venue at the pass and ruled
`withhold`** (25 Aug 2026): the tree is left exactly as found and the prepared
command stands in the pass record. **Suite green on the closed tree**, this
entry and `VERSION 0.1.41` included.

**D-8 · the peer collision, and the restore — recorded because it nearly
shipped as a silent regression.** At **22:13 on 25 Aug**, after this pass had
closed GREEN, a **peer session working the same EC-20 registration** overwrote
`docs/methodology/ba-native-spec-orchestrator-rules.md` **from a `be66dd8`
(0.1.37) base** — two commits stale. Three effects in one file: the committed
**D-O90** (§39, the Slack item is never folded) and **D-O91** (§40, the bare
boundary asks) were **reverted off the working copy**, §10.7's two pinned ask
blocks with them; the peer **re-allocated `D-O90` · `§39` · `v0.36`** for a
*different* ruling — its own answer to EC-20's R1, narrowing the orchestrator's
**D-O16** reservation clause at persona grain rather than excepting the fence
from D-S space; and this pass's **D-O92 · §41 · v0.38** was deleted. The suite
went **RED 2/18** on exactly the D-O90/D-O91 text the write removed, which is
how it was caught — **a commit of the whole tree at that moment would have
pushed the revert to `origin/main` under a message naming none of it.**
**Resolved on the BA's ruling at the pass:** the document was **restored to the
HEAD baseline with this pass's D-O92 replayed on top** — D-O90, D-O91 and D-O92
now standing together, ruling block contiguous, suite re-verified GREEN. **The
peer's version was neither reverted nor discarded**: it is parked verbatim at
`~/Downloads/orchestrator-PEER-EC20-v0.36-stale-base-2026-08-25.md` for that
session to **rebase onto HEAD**, where its ruling takes the next free numbers —
**D-O93 · §42** — and where its R1 answer must be reconciled against **D-S7**,
since two documents ruling one act is precisely the duplication §14 rejected.
**That reconciliation is not this pass's to take.** The mtime evidence is on
the record: the doc written at 22:13:41 against this session's own last edit to
it hours earlier, and the file byte-stable from the snapshot to the restore.
