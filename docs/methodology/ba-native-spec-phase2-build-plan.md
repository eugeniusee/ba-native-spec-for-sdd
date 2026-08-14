# BA-Native Spec — Phase-2 Build Plan
### BA-Native Spec · build blueprint · v0.2 (review incorporated 30 July 2026)
**v0.2 change record:** twelve D-P2 decisions ruled closed, all recommendations accepted as stated (30 July 2026) — open-decision markers resolved to locked text, §7 converted to the review record. No structural or content changes beyond the ruling application.

**What this is:** the compilation plan that turns the thirteen review-closed Phase-1 documents into the installable Claude Code package plan §8 defines. It fixes the package layout on native primitives (plan Q4/§7), inventories every buildable unit with its source anchors, pins the doc→build compilation rules, sequences the Claude Code build sessions (the Wave-2 batching logic, applied to the build), and scripts the Phase-2 exit test (plan §8: `install → run → artifact set appears → /speckit.plan consumes it` on a toy feature). The building itself happens in Claude Code sessions inside the package repo — each grounded in the pinned methodology docs vendored there. The design points **D-P2-1…12** were ruled closed 30 July 2026 — the adopted text stands inline at each anchor; §7 holds the rulings’ record.

**Sources (versions read this session):** definition & plan v2.13 (§2 Q4/Q5/C4 · §7 · §8) · writing standard v0.3 · completeness contract v0.2 (61 assertions: 24 M · 37 A, 2 ⚑) · elicitation techniques v0.3 (§3.2 · §5 · §7) · gate definition v0.3 (§13 binding table) · orchestrator rules v0.3 (§11 binding table) · Wave-2 sequencing plan v0.4 (§2 template, §8 hooks) · catalogue index v0.2 · catalogue b1 v0.3 · b2–b6 v0.2.

---

## 0. Reading frame — the rules this plan builds under

Two corpus rules govern every compilation decision below; they are restated once and then assumed:

- **The layering rule (contract §2, generalized).** Compiled build artifacts carry **operative text + IDs only** — assertion text + CC-IDs on the gate side, criterion text + AT-IDs on the orchestrator side. The runtime **never loads a methodology document**; the chain stays verifiable one-way: build artifact → ID → document line → BABOK anchor. BABOK tags, mining notes, review records, and rationale prose are methodology-layer content and never ship.
- **The runtime-ledger rule (gate D-G1/D-G8 · orchestrator D-O3).** Operational state is none of the three content classes and lives **outside `.specify/memory/`** — out of CC-H-01's glob, out of the scoped-run write trigger, out of any `memory/` mirror toward the coding agent.

**Environment facts verified 30 July 2026** (they drive several D-P2 decisions):

| Fact | Consequence |
|---|---|
| Claude Code has **merged slash commands into skills**: `.claude/commands/` is a legacy path; the canonical primitive is `.claude/skills/<name>/SKILL.md`, invoked as `/<name>`, with frontmatter control incl. `disable-model-invocation: true` | Both technique skills and workflow commands ship as skills (D-P2-2); the corpus's BA-invoked-never-auto-fired discipline (gate §2.2, orchestrator §7.1) becomes mechanically enforceable via frontmatter |
| Skill/command names allow **lowercase letters, digits, hyphens only** — the command comes from the directory name | The corpus's indicative dotted `/ba.*` names cannot be skill names; the hyphenated `ba-*` namespace replaces them (D-P2-1). Both binding tables carried the caption that pre-authorized the fix; this plan fixes them, and their captions now name this decision (build-log D152) |
| Subagents live at `.claude/agents/<name>.md` (frontmatter: name · description · tools · model) | The four framework agents ship there (D-P2-3) |
| Spec Kit current release **v0.12.5** (6 Jul 2026); v0.10+ uses `--integration` (the `--ai` flags are gone), supports presets/extensions, and pins via `uvx --from git+https://github.com/github/spec-kit.git@vX.Y.Z specify init` | Build-target pin v0.12.5 (D-P2-8); install = pinned init + overlay (D-P2-9) |
| `specify init` lays down `.specify/` (memory/ with a default constitution · scripts/ · templates/ with spec/plan/tasks templates) + the agent's `/speckit.*` commands; a Spec Kit upgrade with `--force` overwrites `.specify/scripts/` and `.specify/templates/` | Everything of ours under `.specify/` lives in a **namespaced `.specify/ba/` home** that Spec Kit upgrades never touch; the one deliberate exception is the `spec-template.md` override (re-overlaid at any pin bump). Spec Kit's default constitution is set aside at install so T-15 births the real one (D-P2-6) |

---

## 1. Package layout

### 1.1 The installed project tree — every file the install lays down

Legend: **⬒** laid down by `install.sh` · **◇** born at runtime by the named act (never pre-created — D-P2-6: the installer creates **directories and templates, zero content stubs**, because *absent* and *stubbed* are the same AT/CC-H hole and a field of installer-made stubs would pollute the evidence triggers; Spec Kit's default `constitution.md` is moved to `.specify/ba/speckit-defaults/` at install for the same reason).

```
<project>/
├─ canvas.md                          ◇ T-01 (Frame)
├─ AGENTS.md                          ⬒ portability mirror (standard essentials)
├─ CLAUDE.md                          ⬒ framework block appended (file created if absent)
├─ .claude/
│  ├─ agents/
│  │  ├─ ba-orchestrator.md           ⬒ doc-5 persona (§10.2 discipline, P-O checkpoints)
│  │  ├─ ba-discovery.md              ⬒ Discovery BA — Band-1/2 technique execution persona
│  │  ├─ ba-analyst.md                ⬒ Requirements Analyst — Tier-2 authoring persona
│  │  └─ ba-gate.md                   ⬒ gate agent — A-pass evaluator, read-only tools
│  └─ skills/                         (all with disable-model-invocation: true — D-P2-2)
│     ├─ ba-frame/SKILL.md            ⬒ Band-1 entry (orchestrator §8.1)   D-P2-5
│     ├─ ba-status/SKILL.md           ⬒ ledger-head render
│     ├─ ba-aspect/SKILL.md           ⬒ open + suggestion + composition (P-O1/P-O2)
│     ├─ ba-run/SKILL.md              ⬒ P-O3 contract check → technique dispatch
│     ├─ ba-clear/SKILL.md            ⬒ evidence table → confirmation (P-O4)
│     ├─ ba-waive-aspect/SKILL.md     ⬒ AW acts (P-O5)
│     ├─ ba-reopen/SKILL.md           ⬒ RO ruling + execution (P-O6)
│     ├─ ba-close-band1/SKILL.md      ⬒ closure + arming request (P-O7)
│     ├─ ba-enter-feature/SKILL.md    ⬒ slicing confirmation, NNN assignment (P-O8)
│     ├─ ba-gate/SKILL.md             ⬒ Scope-F run, stages 0–5 (gate §4)
│     ├─ ba-gate-health/SKILL.md      ⬒ Scope-H runs [artifact | full] (gate §10)
│     ├─ ba-handoff/SKILL.md          ⬒ Mode-A adapter front (gate §11.2)
│     ├─ ba-t01/ … ba-t18/            ⬒ 18 catalogue technique skills
│     │   └─ SKILL.md + references/   (output template · micro-example few-shot)
│     ├─ ba-tier1/SKILL.md            ⬒ modes: kit | ingest | supplement   D-P2-4
│     │   └─ references/              (kit + brief templates · §3.3 depth table)
│     └─ ba-tier2/SKILL.md            ⬒ context load → draft → gap loop → submit
│         └─ references/story-drafting.md   (the §7.2 module, compiled)
├─ .specify/
│  ├─ memory/                         Spec Kit home + our Context/Governance estate
│  │  ├─ constitution.md              ◇ T-15
│  │  ├─ glossary.md                  ◇ T-02        stakeholders.md   ◇ T-03
│  │  ├─ personas.md                  ◇ T-04        context.md        ◇ T-05
│  │  ├─ constraints.md               ◇ T-06        competitive-analysis.md ◇ T-07
│  │  ├─ domain-model.md              ◇ T-11        roles-permissions.md    ◇ T-12
│  │  ├─ processes.md                 ◇ T-13        design-standards.md     ◇ T-14
│  │  ├─ out-of-scope.md              ◇ T-16        roadmap.md              ◇ T-17/T-18
│  │  └─ scope/                       ⬒ dir · ◇ <epic>.md + <epic>.kit.md (Tier 1)
│  ├─ templates/
│  │  ├─ spec-template.md             ⬒ OVERRIDDEN → standard-§2 ten-heading skeleton
│  │  └─ plan-template.md · tasks-template.md    (Spec Kit's own — untouched)
│  ├─ scripts/                        (Spec Kit's own helpers — untouched)
│  ├─ ba/                             the framework's namespaced runtime home
│  │  ├─ scripts/                     ⬒ 11 × sk_*.py (§2.4)
│  │  ├─ cards/
│  │  │  ├─ assertions-f.md           ⬒ 34 Scope-F A cards (text + CC-ID only)
│  │  │  ├─ assertions-h.md           ⬒ 3 Scope-H A cards
│  │  │  └─ at-thresholds.md          ⬒ six aspects' AT criteria (text + AT-ID only)
│  │  ├─ templates/                   ⬒ 10 files (§2.6)
│  │  ├─ speckit-defaults/            ⬒ Spec Kit's default constitution, set aside
│  │  └─ manifest.md                  ⬒ generated at install: package version ·
│  │                                     source-doc version vector · Spec Kit pin ·
│  │                                     installed-file hash list
│  ├─ aspect-state.md                 ◇ /ba-frame        (orchestrator §2.4)
│  ├─ aspect-plans.md                 ◇ /ba-frame
│  ├─ gate-health.md                  ◇ arming run       (gate §10.3)
│  ├─ gate-tuning.md                  ◇ first O/E record (gate §7.4)
│  └─ elicitation-tuning.md           ◇ first log entry  D-P2-11
└─ specs/
   └─ NNN-<feature>/                  ◇ /ba-enter-feature (dir + NNN) →
      ├─ spec.md                      ◇ Tier 2
      ├─ traceability.md              ◇ sk_idgraph at gate time (CC-TR-04)
      └─ gate-report.md               ◇ gate, append-only per run
```

**Layout notes.**
- All five runtime ledgers sit at `.specify/*.md` top level, exactly where the corpus pins the four it names; the fifth (`elicitation-tuning.md`) gets its home here — doc 3 §10 defines the three logs without a file (D-P2-11: one file, three tables — false-ask · wrong-draft · dead-answer — same D-G1 rationale as `gate-tuning.md`).
- The `CLAUDE.md` mirror is an **append-only fenced block** (`<!-- ba-native-spec:begin/end -->`): existing project content is never overwritten; re-install replaces only the block. `AGENTS.md` is created if absent, block-appended if present.
- The adapter needs plain `git` only — it never depends on Spec Kit's git extension (not installed by default at v0.12.x); branch/dir plumbing may call the repo-local pinned `.specify/scripts/` helpers where they match, but `sk_handoff.py` owns the hash guard regardless.
- Feature numbering: `/ba-enter-feature` assigns the next free `NNN` under Spec Kit's convention at the P-O8 act, so the Tier-2 destination path exists before the gate's Stage-0 admission and the adapter's later branch checkout matches it.

### 1.2 The package repo tree (what Phase 2 builds; not installed)

```
ba-native-spec/
├─ install.sh                    ⬒-maker: pinned init + overlay + mirror + manifest
├─ VERSION                       package semver
├─ README.md
├─ payload/                      byte-exact copy source for §1.1's ⬒ set
│  ├─ claude/  (agents/ · skills/)
│  ├─ specify-overlay/  (templates/spec-template.md · ba/…)
│  └─ mirror/  (AGENTS.md · claude-block.md)
├─ vendor/
│  └─ spec-kit-v0.12.5.zip       offline-fallback release archive (D-P2-9)
├─ docs/
│  ├─ methodology/               the 13 pinned Phase-1 docs (+ the plan) — the
│  │                             grounding every build session reads; never installed
│  └─ quickstart.md              BA quickstart (Phase-1 manual mode → package mode)
└─ tests/
   ├─ check-layout.sh            asserts §1.1 tree post-install
   ├─ fixtures/appointment-booking/   the toy world (§2.8, §5)
   └─ exit-test.md               the §5 script, agent-runnable
```

---

## 2. Build-unit inventory — 67 units

The **Source anchors** column is deliberately load-bearing: it doubles as the version-bump propagation map (§3.4) — a doc bump recompiles exactly the units anchored to it.

### 2.1 Technique skills — 20

| Unit | Skill | Source anchors |
|---|---|---|
| T-01…T-18 (18) | `ba-t01`…`ba-t18` | Each sheet **in full** (b1 v0.3 · b2–b6 v0.2): §4 procedure + §5 template/micro-example + §2 depth + §6 hooks compile into the skill; **§8 build-brief hook = the compilation note** (what §§2–6 fix vs. what Phase 2 adds); index v0.2 row = cross-check only, sheet governs |
| Tier 1 (1) | `ba-tier1` | Elicitation §3.2 (the complete kit-generator spec, per §7.1) · §3.5 ingestion incl. routing table + contradiction/ambiguity rules · §3.3 depth table (compiled verbatim as the Destination Test) · Tier-1-supplement mini-loop (§3.5 tail) · §4 brief template · D1/D2/D4 locks |
| Tier 2 (1) | `ba-tier2` | Elicitation §5.1–§5.5 (context stack + precedence · draft-first · GQ packet · D6 legality · D7 cap 7 + overflow signal) · §6 both guards · §7.2 story-drafting brief → `references/story-drafting.md` · standard §§2–13 shape rules |

**D-P2-4** — one skill per technique, 1:1 with the pinned count of 20 (sequencing plan §1 · index boundary notes). `ba-tier1` carries three argument-selected modes (`kit <epic>` · `ingest <epic>` · `supplement <epic>`) rather than splitting into three skills; `ba-tier2` embeds §7.2 as its drafting module rather than shipping a separately invocable story skill (a story draft outside the Tier-2 session would have no P-O8/brief anchor). Recommended: adopt — keeps technique count = skill count, and the modes are one technique's phases, not three techniques.

### 2.2 Workflow skills — 12

`ba-frame` · `ba-status` · `ba-aspect` · `ba-run` · `ba-clear` · `ba-waive-aspect` · `ba-reopen` · `ba-close-band1` · `ba-enter-feature` · `ba-gate` · `ba-gate-health` · `ba-handoff`. Source anchors: orchestrator §11 + gate §13 binding tables (name-for-name, dotted→hyphenated per D-P2-1), the P-O1…P-O9 and P1…P8 prompt-point tables, §8 band acts, §9 signal intake, gate §§4–11 stage machinery.

**D-P2-5** — `ba-frame` is the one addition beyond the corpus's eleven indicative names: orchestrator §8.1 defines Band-1 entry as an act (ledger init at six × `untouched` · canvas-present check · the canvas-absent branch into T-01) but neither binding table names its command. Recommended: add it; without a command the two ◇ ledgers have no birth act in package mode.

### 2.3 Subagents — 4

| Agent | Mandate | Source anchors |
|---|---|---|
| `ba-orchestrator` | Schedules, routes, records; hands touch the two aspect ledgers and nothing else | Orchestrator §10.2 discipline · §2–§9 machinery · plan §7 persona |
| `ba-discovery` | Executes Band-1/Band-2 technique skills; carries the three doc-3 operating principles + writing-standard discipline | Plan §7 persona · seq-plan §2 template rules · standard §1 |
| `ba-analyst` | Tier-2 authoring persona (draft-first, cite-or-mark, GQ discipline) | Plan §7 persona · elicitation §5 · standard §§2–15 |
| `ba-gate` | A-pass evaluator: per-assertion verdict + evidence, doubt→FAIL, never edits; **read-only tool policy** enforces gate §11.3 mechanically | Gate §2.1 · §5.2–§5.4 · §13 row "A checkers" |

**D-P2-3** — plan §7 (locked) names three personas; the later, review-closed gate v0.3 §13 adds the gate subagent as its own actor. Recommended reconciliation: **four agents** — the gate evaluator cannot be the analyst (author vs. judge) and cannot be the orchestrator ("never runs a contract check", §10.2). No plan-doc edit implied; §7's list reads as the pre-gate-doc persona set.

### 2.4 Vendored checker scripts — 11 (all 24 M assertions + snapshot + adapter)

Gate §13's five M clusters, expanded to a concrete manifest (clustering inside the pinned coverage is a Phase-2 implementation freedom; the coverage is not):

| Script | Covers | Source anchors |
|---|---|---|
| `sk_snapshot.py` | Snapshot manifest + content hashes · live-diff · §9.2 re-run-set computation · waiver/override anchor diffing | Gate §3 · §7.2 · §9.2 |
| `sk_structure.py` | Stage 1: CC-G-01 ten-heading parse · document parse · US/FR/BR/NFR ID inventory | Gate §4.1–§4.2 · standard §2 |
| `sk_scan.py` | CC-G-03 marker scan · CC-G-04 banned words (standard §4 list vendored; quoted-copy exemption) · CC-XA-02 persona grep | Contract §4/§5/C12 |
| `sk_stories.py` | CC-US-01 grammar · CC-US-02 roles-verbatim lookup · CC-US-03 priorities · CC-US-04 ID reuse vs `hist` | Contract C2 |
| `sk_acceptance.py` | CC-AC-01 (≥ 1 item per story, slot form) | Contract C3 |
| `sk_ears.py` | CC-FR-01 **vendored EARS lint** (standard §4 grammar as patterns — content vendored, no upstream dep) · CC-FR-02 one-SHALL · CC-FR-05 FR-ID↔US linkage + reuse | Contract C4 · standard §4 |
| `sk_sections.py` | CC-FL-02 · CC-NF-02 six-category coverage · CC-BR-02 · CC-OS-01 | Contract C5–C7, C10 |
| `sk_idgraph.py` | Traceability graph build · CC-TR-01…03 · **generates `traceability.md`** (gate §8 shape) · CC-TR-04 | Contract C11 · gate §8 |
| `sk_brief.py` | CC-XA-05 brief-exists + slicing-row lookup | Contract C12 · elicitation §4 |
| `sk_health.py` | CC-H-02 · CC-H-03 · CC-H-06 | Contract §6 |
| `sk_handoff.py` | Adapter: manifest-hash verify (refuse on mismatch, print diverged paths) · branch checkout/create · Spec-Kit dir plumbing · ready report | Gate §11.1–§11.2 · plan Q5 |

**D-P2-7** — language: **Python 3, standard library only** (Spec Kit already requires Python 3.11+, so no new prerequisite; stdlib-only keeps "vendored dependencies only" literal). Recommended: adopt.

### 2.5 Compiled cards — 3

`assertions-f.md` (34 Scope-F A cards) · `assertions-h.md` (3 Scope-H A cards) · `at-thresholds.md` (six aspects' criteria). Each card = ID + exact operative text + Checks set + non-waivable/⚑ flag — nothing else (§0 layering rule). Source anchors: contract §4–§6 verbatim; orchestrator §3.3 verbatim.

### 2.6 Templates & scaffolds — 13

| # | File | Compiled from |
|---|---|---|
| 1 | `spec-template.md` (preset override) | Standard §2 skeleton, exact headings |
| 2 | `ba/templates/canvas-template.md` | b1 T-01 §5 (13 sections, `P-n`/`O-n`) |
| 3 | `ba/templates/scope-brief-template.md` | Elicitation §4 (nine sections, exact headings) |
| 4 | `ba/templates/call-kit-template.md` | Elicitation §3.2 parts A–D |
| 5 | `ba/templates/gate-report-entry.md` | Contract §7 + gate §6.2 runtime block |
| 6 | `ba/templates/traceability-template.md` | Gate §8 (consumed by `sk_idgraph`) |
| 7 | `ba/templates/aspect-state.md` | Orchestrator §2.4 head + events shape |
| 8 | `ba/templates/aspect-plans.md` | Orchestrator §6.4 incl. `## Frame` + `## Band 2` sections |
| 9 | `ba/templates/gate-health.md` | Gate §10.3 head + entries shape |
| 10 | `ba/templates/gate-tuning.md` | Gate §7.4 two tables + §12 escape record |
| 11 | `ba/templates/elicitation-tuning.md` | Doc 3 §10 three tables (D-P2-11) |
| 12 | `AGENTS.md` mirror | Standard essentials: golden rules · §2 skeleton · EARS + tiered acceptance · banned words · reference-never-restate |
| 13 | `claude-block.md` (CLAUDE.md fenced block) | Same essentials + the `/ba-*` command index |

### 2.7 Installer — 1

`install.sh`: preflight (git repo · python3.11+ · uv) → pinned `specify init --here --integration claude` (D-P2-9) → overlay `payload/specify-overlay/` → copy `payload/claude/` → set aside Spec Kit's default constitution → create `memory/scope/` → write mirror files/blocks → generate `ba/manifest.md` → print next step (`/ba-frame`). Idempotent: re-run replaces ⬒ files and fenced blocks only; never touches ◇ content, ledgers, or `specs/`.

### 2.8 Test assets & docs — 3

The **toy-world fixture set** (1): `tests/fixtures/appointment-booking/` — the corpus's running world reconstructed as machine inputs: presale brief → the framed-canvas expectation · scripted E-03 call notes (elicitation §8.2's content as raw notes) · Tier-2 answer sheet (≤ 7 GQ answers) · spec revisions r5/r6 with the gate-§14 defect set seeded · expected-verdict tables per M script. Plus **README.md** (1) and **docs/quickstart.md** (1).

### 2.9 Roll-up — the pinned count

| Class | Count |
|---|---|
| Technique skills | 20 |
| Workflow skills | 12 |
| Subagents | 4 |
| Checker/adapter scripts | 11 |
| Compiled cards | 3 |
| Templates & scaffolds | 13 |
| Installer | 1 |
| Fixture set · README · quickstart | 3 |
| **Total build units** | **67** — of which **63 install** into the target project (fixtures, README, quickstart, and the installer itself stay repo-side) |

---

## 3. Compilation rules — doc → build

### 3.1 Travels verbatim (byte-faithful into build artifacts)

Assertion pass-condition text + CC-IDs (cards) · AT criterion text + AT-IDs (card) · the named-gap grammar · question-packet grammars (kit `Q<n>` block, elicitation §3.2; `GQ<n>` packet, §5.4) · the two guards' operational tests (Citation Test · Destination Test · D6 legality rule) · sheet §4 procedures, §5 output templates, and §2 depth boundaries into skill bodies · all exact-heading sets (spec ten · brief nine · canvas thirteen) · the P1–P8 and P-O1–P-O9 prompt-point definitions as checkpoint scripts · status vocabularies (D4 open-question set · D-B6-3 roadmap set · brief `Draft/Scoped`) · locked constants (must-ask ≤ 12 · Tier-2 cap default 7, BA-adjustable · ≤ 10 capability lines · the six non-waivables · the ⚑ pair).

### 3.2 Compiled with transformation

| Source | Becomes | Rule |
|---|---|---|
| Sheet §2 metadata + §3 contract | Skill frontmatter (`name` · `description` naming technique + Serves + destination) + an **invocation-contract block** at the skill top: the P-O3 self-check (planned + pinned contract, else stop → `/ba-run`) | The catalogue entry is the compile source; the index v0.2 row is a cross-check — **on divergence the sheet governs** and the compiler flags the index defect, never silently resolves |
| Sheet §8 build-brief hook | The skill's wiring section: inputs loaded (context stack, order) · interaction pattern · outputs written · the "Phase 2 adds" list implemented | Doc 3 §7 format, per seq-plan §2 |
| Micro-examples (§5) | `references/example.md` few-shots inside each skill | **D-P2-10** — compile them in: they are runtime-valuable few-shots, cost nothing until loaded (progressive disclosure), and the appointment-booking world is explicitly the corpus's shared exemplar. Recommended: adopt |
| Contract §4–§6 | The three cards + the M scripts' check logic | Text + ID only |
| Elicitation §7.2 two-column table | `ba-tier2/references/story-drafting.md` — right column = the skill's musts; left column = mined mechanics, rewritten framework-shaped | The from-scratch ruling: mined patterns, never imported prose |

### 3.3 Never compiled (methodology layer stays home)

BABOK anchors and the layering chain · sheet §7 mining notes (authoring-time evidence) · review records · rationale prose beyond operative rules · the documents themselves. `docs/methodology/` exists in the package repo for **build sessions and BA study only**; nothing under it is copied by `install.sh`, and no runtime path reads it.

### 3.4 Generated at run time (never shipped)

All 18 content artifacts · ledger contents · kits, briefs, specs · `traceability.md` (`sk_idgraph` at gate time — CC-TR-04's "generated, never hand-authored") · gate-report entries and certification manifests · suggestion snapshots and composed plans · `ba/manifest.md` values (at install).

### 3.5 Version-bump propagation — doc → package, one-way

1. A methodology-doc bump lands in the project files (its own review-closed session, as ever).
2. The bumped doc is copied into `docs/methodology/` at its new version; the **§2 source-anchor column identifies the affected units** — that column *is* the propagation map.
3. A dedicated Claude Code recompile session rebuilds exactly those units; their session exit tests (§4) re-run.
4. Package `VERSION` bumps; `ba/manifest.md`'s doc-version vector updates; install into projects is a re-run of `install.sh` (⬒-only replacement, §2.7).
5. **One-way rule:** compiled text is never patched in place — a wanted runtime change without a doc change is a doc defect first (the "fix in the spec, re-run downstream" discipline, applied to the framework itself). Tuning findings flow doc-first by construction: overrides/escapes → contract §10 · gate §7.4; false-ask/wrong-draft/dead-answer → doc 3 §10; threshold-gap candidates → orchestrator §8.5 — each bumps its document, then recompiles here.

---

## 4. Build order & session batching — 9 Claude Code sessions

**Dependency logic (Wave-2 batching, transposed):** scaffolding before anything that lands in it → the M machinery before the gate that orchestrates it (and the fixtures before both, since scripts are testable the moment they exist against known corpus verdicts) → the gate before the orchestrator's arming/closure acts → foundation techniques before the aspects that consume their outputs (the catalogue's own b1→b6 order, collapsed) → the spine pair last among techniques (Tier 2 presupposes gate + standard machinery) → the adapter and the exit test at the end, when there is a certified artifact set to hand off.

**Session discipline:** every session below runs as a **NEW, separate Claude Code conversation inside the package repo**, grounded in `docs/methodology/` (the pinned doc versions) — one session, one batch, its own exit test green before the next opens; a session record appends to the repo's `BUILD-LOG.md`.

| # | Session | Units built | Inputs | Session exit test |
|---|---|---|---|---|
| S1 | Foundation | Repo skeleton · `install.sh` · payload overlay tree · 13 templates/scaffolds · mirror files · manifest generation · pin verification (D-P2-8) | Plan §7 · this plan §1 · standard §2 · ledger shapes (orch §2.4, gate §10.3) | Fresh dir → `./install.sh` → `tests/check-layout.sh` green: §1.1 tree exact, `/speckit.*` present, all 32 `/ba-*` skills listed, manifest vector correct |
| S2 | M machinery + fixtures | 10 checker scripts (`sk_snapshot`…`sk_health`) · toy-world fixture set | Contract §4–§6 M rows · gate §3/§4.2/§8/§9.2 · standard §4 · corpus worked examples (standard §14, contract §7, gate §14, elicitation §8) | Script suite vs. fixtures: every M assertion exercised with ≥ 1 seeded FAIL and ≥ 1 PASS; fixture r5 reproduces gate run-2's M-detectable gaps verbatim in named-gap grammar; `sk_idgraph` emits a gate-§8-shaped `traceability.md` |
| S3 | Gate | `ba-gate` · `ba-gate-health` skills · `ba-gate` agent · 3 cards · report/certification writer · W/O/HA + P1–P8 flows | Gate v0.3 in full · contract §2/§7/§8 · S2 outputs | Fixture replay of gate §14 runs 2→3 end to end: FAIL with 5 named gaps → fixes applied from fixture r6 → incremental re-gate (carry set per §9.2) → PASS WITH WAIVERS → ⚑ ×2 → approval → certification manifest hashes verify |
| S4 | Orchestrator | `ba-orchestrator` agent · 9 workflow skills (`ba-frame` `ba-status` `ba-aspect` `ba-run` `ba-clear` `ba-waive-aspect` `ba-reopen` `ba-close-band1` `ba-enter-feature`) | Orchestrator v0.3 in full · `at-thresholds.md` (S3) | Orchestrator §12's three exhibits replayed on an empty fixture project: ledger heads/events land in §2.4 shape; P-O checkpoints render; the §8.2 reopen executes end to end |
| S5 | Techniques I | `ba-t01`…`ba-t03` · `ba-discovery` agent · `ba-run` dispatch proven | b1 v0.3 · index rows T-01…T-03 · S4 outputs | From the fixture presale brief: Frame runs T-01 → `canvas.md` in framework shape; T-02/T-03 land glossary + register; Stakeholders reaches `first-pass-cleared` with a §3.4 evidence table |
| S6 | Techniques II | `ba-t04`…`ba-t10` (7) | b2 v0.2 · b3 v0.2 · index rows | Context + Value + Vision + Solution clear on the toy: constraints/context/competitive land; canvas §§2–12 filled per AT-VA/VI/SO; TC-1…TC-3 surface present on any elected persona charter |
| S7 | Techniques III + closure | `ba-t11`…`ba-t16` (6) | b4 v0.2 · b5 v0.2 · index rows | Requirements clears; `/ba-close-band1` succeeds; the arming Scope-H run lands in `gate-health.md` — HEALTHY, or its named gaps fixed via routing in-session |
| S8 | Band 2 + spine | `ba-t17` · `ba-t18` · `ba-tier1` · `ba-tier2` · `ba-analyst` agent | b6 v0.2 · elicitation v0.3 in full · S7's armed toy | E-03 decomposed + allocated (diff + log entry); `ba-tier1 kit` emits ≤ 12 must-ask, every question destination-tagged, zero §3.3 depth violations; scripted ingestion → brief `Scoped` with slicing; `ba-tier2` drafts spec r5 with ≤ 7 GQs from the answer sheet, every drafted value cited-or-marked |
| S9 | Adapter + Phase-2 exit | `ba-handoff` skill · `sk_handoff.py` · Mode-B fallback note · README · quickstart · `tests/exit-test.md` | Gate §11 · plan Q5 · everything prior | **The §5 exit test, end to end, green** — including the seeded-defect FAIL cycle and the hash-refusal negative check |

**Standing session prompt (pattern, per seq-plan §4):** *"BA-Native Spec Phase 2 — session S\<n\> per the build plan §4. Ground in `docs/methodology/` at the manifest's pinned versions and in this plan. Build exactly this session's units to §3's compilation rules; where a sheet and the index diverge, the sheet governs and the divergence is flagged. Run the session exit test; append the session record to `BUILD-LOG.md`. Open D-P2 decisions bind as ruled in the plan's §7."*

---

## 5. Phase-2 exit test — the concrete script

Plan §8's exit criterion, made executable (`tests/exit-test.md`; the toy feature is the corpus's own `004-appointment-booking` inside epic E-03). Steps 4–7 use fixture inputs for every "stakeholder" contribution, so the run is reproducible without improvisation.

1. **Fresh project.** `mkdir toy && cd toy && git init` — empty repo, no prior Spec Kit.
2. **Install.** `../ba-native-spec/install.sh` → `tests/check-layout.sh` green; `ba/manifest.md` records package version, doc vector, Spec Kit pin v0.12.5.
3. **Frame.** `/ba-frame` with `fixtures/…/presale-brief.md` → T-01 births `canvas.md` (13 sections, `P-n`/`O-n`); both aspect ledgers initialized, six × `untouched`.
4. **Band 1.** Aspects opened in DAG order; per aspect: suggestion → composed plan → technique runs (the S5–S7 set) → `/ba-clear` with its evidence table. All six reach `first-pass-cleared` (the script includes one deliberate `/ba-waive-aspect` + lapse round-trip to exercise AW mechanics). `/ba-close-band1` → arming Scope-H entry in `gate-health.md`.
5. **Band 2.** `/ba-run t17` → roadmap rows incl. E-03 at the locked shape; `/ba-run t18` → MVP allocation with diff + logged reason. `/ba-run tier1 kit E-03` → kit passes its own checks (≤ 12 must-ask · every question destination-tagged · zero Destination-Test violations against the §3.3 table); `/ba-run tier1 ingest E-03` with the scripted call notes → brief `Scoped`, routing batch approved, `004-appointment-booking` proposed in §8 slicing.
6. **Band 3 — spec.** `/ba-enter-feature E-03/004-appointment-booking` (slicing row → `Confirmed`) → Tier-2 session: context stack loaded in §5.2 order, draft-first skeleton, ≤ 7 GQs answered from the answer sheet, spec.md written — then the script **seeds one defect** (re-inserts `quickly` into FR-007, the gate-§14 exemplar).
7. **Gate — FAIL → fix → PASS** (D-P2-12 — this cycle is deliberately in the exit script, not optional). `/ba-gate 004` → **FAIL naming CC-G-04 — FR-007** in named-gap grammar (this is the "gate blocks with named gaps" v1-done item, proven). Fix per the fixture (adverb → NFR-003) → incremental re-gate → one waiver granted on CC-IN-03 (the corpus's W-004-01 scenario) → **PASS WITH WAIVERS** → ⚑ sign-offs on CC-XA-01 + CC-XA-06 evidence bundles → P4 approval → certification manifest written, `traceability.md` committed.
8. **Negative check.** One byte edited in `spec.md` post-certification → `/ba-handoff 004` **refuses**, printing the diverged path → edit reverted → hashes verify clean.
9. **Handoff.** `/ba-handoff 004` → hash guard passes · branch `004-appointment-booking` checked out · Spec Kit dirs confirmed · ready report.
10. **`/speckit.plan` consumes it — zero manual rework**, operationalized as all four: (a) the operator performs **no file operation** between certification and plan; (b) plan runs to a completed `plan.md` without requesting any spec edit; (c) the only `[NEEDS CLARIFICATION]` the coding agent reads is the one carried under the waiver — nothing hidden, nothing else open; (d) every certified hash still matches at plan time.

**Pass = all ten steps green in one scripted run.** This clears the Phase-2 slice of the v1-done checklist (one-command install · gated discovery with BA-planned techniques · decomposition + Tier-1 briefs + logged allocation · both question guards live · classed artifact set · named-gap blocking · zero-rework `/speckit.plan`); "one real feature shipped end-to-end" stays Phase 3's, by design.

---

## 6. Phase-1 manual mode — what BAs run today, while the build proceeds

The corpus already certifies this: **a BA can run the whole method from the documents alone** — that was Phase 1's exit criterion, met at corpus level. Concretely, today: Band 1–3 machinery by hand from orchestrator §11's manual paragraph (ledgers maintained from the §2.4/§6.4 templates, thresholds from §3.3, reopen/waiver from §4–§5, band acts from §8); every technique from its sheet's §4 procedure and §5 template (b1–b6), Tier 1/Tier 2 from elicitation §§3–6; specs to standard §2 with the §15 self-check; the gate per gate §13's manual paragraph — §4.2 as the checklist, M procedures as mechanical instructions, A assertions read against the snapshot with §5.4 evidence discipline, the §6.2 report filled by hand. Manual substitutions: recorded revision marks for hashes (gate §3), eyeball EARS review via standard §4 for the lint, the session-start habit for the scoped-H auto-fire. Two things manual mode should start **now**, because they feed Phase 3's metrics directly: the tuning logs (false-ask · wrong-draft · dead-answer · escapes) on paper from the first real use, and any threshold-gap candidates — both flow doc-first into the §3.5 loop when the package lands.

---

## 7. Review record (v0.1 → v0.2)

Twelve decisions ruled by the BA Lead, 30 July 2026 — **all recommendations accepted as stated.** The locked text stands inline at each anchor; the table below stands as the rulings’ record.

| ID | Decision | Ruling (adopted as recommended) |
|---|---|---|
| D-P2-1 | Command namespace: the corpus's dotted `/ba.*` names are illegal as skill names (lowercase + digits + hyphens only) | Adopt hyphenated **`ba-*`**, name-for-name: `ba.gate → ba-gate`, `ba.gate-health → ba-gate-health`, `ba.handoff → ba-handoff`, `ba.status → ba-status`, `ba.aspect → ba-aspect`, `ba.run → ba-run`, `ba.clear → ba-clear`, `ba.waive-aspect → ba-waive-aspect`, `ba.reopen → ba-reopen`, `ba.close-band1 → ba-close-band1`, `ba.enter-feature → ba-enter-feature`. Both binding tables pre-authorized this in their captions, which now name this decision as the fixer (build-log D152) |
| D-P2-2 | Primitive mapping under the merged commands-into-skills model | All 32 commands + techniques as `.claude/skills/`, every one with `disable-model-invocation: true` — the BA-invoked-never-auto-fired discipline enforced by frontmatter, not by convention; the legacy `.claude/commands/` path unused |
| D-P2-3 | Subagent set: plan §7's three personas vs. gate §13's gate subagent | **Four agents** (`ba-orchestrator` · `ba-discovery` · `ba-analyst` · `ba-gate`); §7's trio reads as the pre-gate-doc persona set — the evaluator can be neither author nor scheduler |
| D-P2-4 | Skill granularity for the spine pair | 1:1 technique↔skill, total 20; `ba-tier1` with `kit/ingest/supplement` modes; `ba-tier2` embeds the §7.2 story-drafting module as a reference file |
| D-P2-5 | Band-1 entry command | Add **`ba-frame`** (12th workflow skill) — orchestrator §8.1's act needs a birth command for the two ◇ ledgers |
| D-P2-6 | Install-time content policy | **Directories + templates only, zero content stubs** (absent ≡ stubbed for every AT/CC-H trigger; installer-made stubs would pollute the evidence); Spec Kit's default `constitution.md` set aside to `ba/speckit-defaults/` so T-15 births the real file |
| D-P2-7 | Checker-script language | Python 3 **stdlib-only** (Spec Kit already requires 3.11+; "vendored dependencies only" stays literal) |
| D-P2-8 | Spec Kit build-target pin | **v0.12.5** (latest tag, 6 Jul 2026); re-verified at S1 open; Phase 4 owns the rollout freeze — this pin is what Phase 2 builds and exit-tests against |
| D-P2-9 | Install mechanics for Spec Kit contact | Pinned `uvx --from git+https://github.com/github/spec-kit.git@v0.12.5 specify init --here --integration claude`, then overlay our delta; `vendor/spec-kit-v0.12.5.zip` as the offline fallback; **no** Spec-Kit-preset-API packaging at v1 (overlay is churn-proof; the preset API is younger than our pin discipline) |
| D-P2-10 | Micro-examples in skills | Compile in as `references/example.md` few-shots — runtime-valuable, token-free until loaded, one shared exemplar world |
| D-P2-11 | Elicitation tuning logs' home | **`.specify/elicitation-tuning.md`** — one runtime ledger, three tables (false-ask · wrong-draft · dead-answer), outside `memory/`, same D-G1 rationale as `gate-tuning.md` |
| D-P2-12 | Exit-test shape | Include the seeded-defect **FAIL → fix → re-gate** cycle, one waiver + ⚑ pass, and the hash-refusal negative check (§5 steps 7–8) — otherwise "gate blocks with named gaps" and "the certified text is the read text" go unproven at exit |

---

*v0.2 · review incorporated 30 July 2026 · Phase-2 opening deliverable per plan §0 next-action · compiles from: plan v2.13 · standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.3 · orchestrator v0.3 · seq-plan v0.4 · catalogue b1 v0.3, b2–b6 v0.2 · index v0.2 · environment pins verified 30 Jul 2026: Claude Code merged-skills model · Spec Kit v0.12.5 · consumed by: the S1–S9 build sessions (§4) and the plan §0 tracker · replace-on-update, stable file name*
