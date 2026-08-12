# Geniusee Gate Definition
### BA-Native Spec · contract runtime · v0.6 — the AUTO waiver lane and the safety floor (§7.1, 13 Aug 2026)
**v0.6 change record:** one additive paragraph, 13 Aug 2026 (WS-3 — autonomous mode; orchestrator D-O36 · D-O37, its §19, v0.14): §7.1 records that under a standing autonomy grant (orchestrator §4.4, §10.7) a **P2 waiver on a real gap may be taken AUTO**, stamped `AUTO (AG-<n>)` in the report entry and standing for ratification at `off` — while **overrides are never AUTO**, the **non-waivable set is untouchable under any mode** (the auto path fixes and re-gates, never bypasses), and **P3 ⚑, P4 approval and handoff (§11) sit outside every AG** — the safety floor. No verdict rule, no waiver field, no assertion and no stage changes; the gate stays profile-blind and now mode-blind by the same logic — a waiver's six §8 fields, its anchor and its lifecycle are identical whoever states it. No other changes.
**v0.5 change record:** one additive bullet + one dependency refresh, 9 Aug 2026 (Presale drafting follow-up; orchestrator D-O18, build-log D65 context): §6.1 gains the **FAIL-as-agenda** cross-reference — on a draft spec under the Presale profile, the FAIL report's named-gap lines double as the client Q&A agenda (orchestrator §6.5); no verdict machinery changes, the gate stays profile-blind (orchestrator D-O14). Footer dependency line: elicitation v0.3 → v0.4. No other changes.
**v0.4 change record:** one additive sentence — §11.3's boundary sentence gains the cross-reference to orchestrator §10.2's framework-wide session-mode rule (D-O11, ruled 7 Aug 2026). No other changes.
**v0.3 change record:** one catalogue-b6 mirror — D-B6-1 → §11.1: the manifest example's rendered word "backlog (E-03 rows)" → "roadmap (E-03 rows)" (a rendered example, not a rule). No other changes.

**What this is:** the runtime of the Completeness Contract — how a gate run actually executes, end to end: admission, snapshotting, checker execution, verdict assembly, waiver and override handling, traceability generation, re-gates, Scope-H health runs, and the boundary where Mode A takes over. The contract (document 2) defines *what is checked and what verdicts mean*; this document defines *how it runs* — its own header fixes that division, and this document never re-defines an assertion, a verdict meaning, or the non-waivable set. On any conflict, **the contract wins and this document takes an erratum.**

**Why it exists:** under Mode A there is no LLM between gate and plan — the certified text is the read text (plan Q5). The contract calls itself "the last inspection before the certified text becomes the read text"; this document is the inspection *machinery*, precise enough that a human BA can run it manually from the documents alone (Phase-1 exit criterion) and mechanical enough that Phase 2 can compile it into scripts, a gate subagent, and slash commands without inventing behavior.

**Two runtime rules of this document's own:**

1. **The gate never authors.** It reads, verifies, and certifies. It never edits a spec, never edits a governance or context artifact, never rewords a requirement "to help it pass," never waives silently. Every content change is a human act or a doc-3 routed act; the gate records it and re-checks.
2. **The gate meets its own bar** — the contract's §7 rule extended to the whole runtime: a failure line without element + fix action, an A verdict without evidence, a skipped check without a named blocker — each is invalid gate output and is corrected before the report is delivered.

---

## 1. Position — who this runtime talks to

| Document | Owns | This runtime's relationship |
|---|---|---|
| **Plan** (doc 0) | Band-3 sequence · Q5 Mode-A handoff · Q4 native primitives · Phase-3 metrics | Fixes where the gate sits in the loop and what it hands to. §4 stages implement the plan's "completeness gate → pass, or back with named gaps." |
| **Writing standard** (doc 1) | How a spec is written; §15 self-check | §15 is the writer's half of the gate; this runtime is the engine of the enforcement half. |
| **Completeness contract** (doc 2) | WHAT is checked · verdict meanings · waiver/override semantics · non-waivable set · Scope-H cadence | Executed here, never re-defined. Every CC-ID this document mentions resolves there. |
| **Elicitation techniques** (doc 3) | Tier-2 delivery · question legality (§5.5) · routing discipline (§3.5) | Delivers specs in; receives named gaps back — each FAIL line is a Tier-2 legality anchor. Upstream fixes triggered by gate gaps execute via doc-3's routing discipline, not by the gate. |
| **Orchestrator rules** (doc 5) | Band-1 aspect gates · aspect reopen/waiver machinery · BA-planning loop | This gate never runs an aspect gate and owns no aspect threshold. Contradiction-shaped gate findings emit **reopen signals** there. |
| **Spec Kit** | `/speckit.plan` onward · `/checklist` · `/analyze` | Downstream backstop only (§12). The Mode-A adapter is the sole contact point (§11). |

**Explicit non-responsibilities:** Band-1 aspect gating (doc 5) · content authoring and fixing (doc 3 / BA) · scope and allocation decisions (Band 2 / doc 5) · anything past `/speckit.plan` (operator).

---

## 2. Actors, invocation & BA prompt points

### 2.1 Actors

| Actor | Role in a run |
|---|---|
| **M checker** | Deterministic verdicts — parse, lint, ID-graph, grep, diff. Phase 2: vendored scripts. Phase 1: the BA following the mechanical procedures in §4–§5. |
| **Gate agent** (A) | Evaluates A assertions against the contract's exact wording; produces per-assertion verdict + evidence. Never edits anything. |
| **BA** | Sole authority over verdicts: **override · waiver · ⚑ sign-off · approval** (contract §2), plus health-acceptance and escape rulings (§10, §12). |
| **Mode-A adapter** | Post-gate plumbing + the hash guard (§11). A separate thin tool — not part of the run. |
| **Operator** | Resumes at `/speckit.plan`. Outside the gate entirely. |

### 2.2 Invocation

- **Scope F is BA-invoked**, on a submitted spec — the last step of Tier 2 (doc 3 §9.2 step 8: BA reviews the draft, runs the §15 self-check, submits to the gate). Never auto-fired on a file save.
- **Scope H runs per the contract's §3 cadence**: full at Band-1 closure / after each ingestion batch / on demand (session-start habit); **scoped runs auto-fire on framework writes**, silent unless FAIL; the pre-flight subset fires inside every Scope-F Stage 0.
- **Re-gates are BA-invoked** after fixes, or in response to a voided-certification notice (§9, §10).

### 2.3 BA prompt points — the complete list

Nothing outside this table interrupts the BA. **No mid-run drip:** stages 1–3 run to completion without BA interaction; results arrive once, at verdict review — earlier only on a Stage-0 block or Stage-1 halt.

| # | Moment | Trigger | The BA's act |
|---|---|---|---|
| P1 | Admission block | Pre-flight Scope-H gap without a health acceptance (§10.4) | Fix the artifact (routing discipline) or grant an HA record (§10.4) |
| P2 | Verdict review | Run complete; provisional results ready | Rule overrides on false positives · grant waivers on real, accepted gaps · re-affirm or lapse in-force waivers · otherwise accept the FAIL list |
| P3 | ⚑ sign-offs | Provisional verdict is PASS / PASS WITH WAIVERS | Review the CC-XA-01 and CC-XA-06 evidence bundles individually; sign, or flip to FAIL with a named gap |
| P4 | Approval (BABOK 5.5) | After ⚑ | Holistic approval → the PASS becomes **effective** |
| P5 | Waiver re-affirmation | Re-gate with waivers in force | One line per surviving waiver: re-affirm (initials) or lapse; revisit triggers are displayed here (lazy read — no scheduler) |
| P6 | Scoped-H surfacing | A scoped health run FAILs, or a certification is voided (§10.2) | Route the fix; queue the cheap re-gate |
| P7 | Escape filing | A downstream catch (§12) | File the escape record |
| P8 | HA review | A full Scope-H run completes (§10.1) | One line per standing health acceptance: re-affirm (initials) or lapse; revisit triggers are displayed here (lazy read — no scheduler) (§10.4) |

---

## 3. The snapshot — what a run binds to

**Dependency set.** `deps(F)` for a feature = the artifacts the Scope-F assertions' *Checks* columns read:

- **Static core:** `specs/NNN-feature/spec.md` (the subject) · `roles-permissions.md` · `glossary.md` · `domain-model.md` · parent scope brief `.specify/memory/scope/<epic>.md` · `canvas.md` · `constitution.md` + every governance file it references · global `out-of-scope.md` · the roadmap rows of the parent epic · the prior spec revision (`hist`, for ID-reuse checks).
- **Dynamic reads:** any additional `memory/` artifact an A checker actually consults this run (e.g., CC-XA-07 chasing a constraint's home). Recorded as read.

**Snapshot manifest.** At admission the runtime records `(path, content hash)` for the static core, and appends dynamic reads as they occur. **Every checker reads the snapshot, never the live files.** Verdicts, waiver anchors, and the certification all bind to this manifest — this is the contract's pass binding made mechanical.

**Divergence.** A live-file edit during or after the run does not corrupt the run; it means the resulting PASS will not survive the adapter's hash check (§11) or the next run's fresh snapshot. Lazy detection, exactly as the contract's §3 defines it — no daemon; the adapter is the hard guarantee.

**Phase-1 manual equivalent:** "hash" = a recorded revision mark per file + the discipline of not editing during a run. Phase 2: content hashes and a copied run workspace.

---

## 4. Scope-F run — stages & sequencing

### 4.1 The six stages

| Stage | Name | What happens | Halting behavior |
|---|---|---|---|
| **0** | Admission & pre-flight | `spec.md` present at its path (else refuse with instruction); snapshot assembled; **pre-flight = the six CC-H assertions evaluated over `deps(F)` only** | Any H gap not covered by a health acceptance (§10.4) → **run blocked**; recorded as a numbered entry ("blocked at pre-flight") with the named H gaps; nothing else evaluated. "A feature gate against rotten shared artifacts is meaningless" — enforced here. |
| **1** | Structural gate | CC-G-01 (ten headings, exact names, exact order) + document parse + ID inventory (US/FR/BR/NFR, tags) | Structure unparseable or CC-G-01 FAIL → **halt**; report structural gaps only (they are non-waivable anyway). Isolated malformed IDs in an otherwise parseable document are *not* a halt — they fail their category's M assertions in Stage 2. |
| **2** | Machine pass | The remaining 20 M assertions, in the §4.2 order; the traceability graph is built here; the candidate `traceability.md` is generated and CC-TR-04 evaluated against it | Never halts — collect-all. |
| **3** | Agent pass | All 34 A assertions, category by category, each independently (§5.2); element-level skips where an M failure blocks evaluation | Never halts — collect-all. |
| **4** | Verdict review | Provisional results → **P2** (overrides, waivers, re-affirmations) → verdict computed (§6.1). If the verdict is pass-bound → **P3** ⚑ sign-offs → **P4** approval | — |
| **5** | Certification | Only on an **effective PASS**: commit `traceability.md` · finalize the report entry · write the certification manifest (§11) | — |

**Collect-all rationale:** the BA gets the complete gap list in one report — one fix cycle, not a drip. The two exceptions (Stage-0 block, Stage-1 halt) exist because those failures invalidate everything downstream of them.

**Skip semantics.** An assertion whose evaluation is meaningless while a named prerequisite fails is marked `SKIPPED — blocked by CC-<ID>`, at **element granularity**: if US3 is unparseable, CC-US-05 skips for US3 and still evaluates US1–US2. A run containing any skip **cannot PASS** — the blocker is among the failures; skips convert to verdicts only after it clears.

### 4.2 Execution order across categories

**Stage 1:** CC-G-01 · parse · ID inventory.

**Stage 2 (M):** CC-G-03 (marker scan) → CC-G-04 (banned-word scan) → CC-US-01…04 → CC-AC-01 → CC-FR-01 (vendored EARS lint) → CC-FR-02 → CC-FR-05 → CC-FL-02 → CC-NF-02 → CC-BR-02 → CC-OS-01 → CC-XA-02 (persona grep) → CC-XA-05 (brief + slicing-row lookup) → **traceability graph build** → CC-TR-01…03 → candidate `traceability.md` generated (§8) → CC-TR-04.

**Stage 3 (A):** category order C1 → C12 for readability — the assertions are independent, so order carries no logic: CC-OV → CC-G-02/05/06 → CC-US-05 → CC-AC-02…04 → CC-FR-03/04 → CC-FL-01/03/04/05 → CC-NF-01/03 → CC-BR-01/03 → CC-DA-01…04 → CC-IN-01…03 → CC-OS-02…04 → CC-XA-01 ⚑ / 03 / 04 / 06 ⚑ / 07.

**M before A, always:** machine checks are cheap, their gaps are the most precisely named, and their failures define the skip set for the agent pass — no agent tokens are burned judging the atomicity of a requirement that doesn't parse.

---

## 5. Checker execution — M · A · ⚑

### 5.1 M checkers

Deterministic, binary, no warnings. **Inputs:** the snapshot only. **Output per assertion:** PASS with terse evidence (counts — "9/9 FRs parse EARS"), or FAIL lines in named-gap grammar, one per element. An M checker that cannot run (a missing input beyond a Stage-0/1 condition) is a runtime defect, not a spec verdict — fix the runner.

### 5.2 A checkers

- **Independence:** each assertion gets its own verdict + evidence block. A checkers may share one artifact-loading pass per category (token economy), but a category-level "looks fine" is invalid gate output — per-assertion or nothing.
- **Inputs:** the assertion's exact contract wording + only its *Checks* artifacts, from the snapshot.
- **Evidence:** every verdict cites quoted line(s) + location. FAIL adds the fix action (named-gap grammar). A PASS cites at least one evidence pointer; ⚑ assertions always produce the full bundle (§5.3).
- **No partials.** A verdict of MAYBE does not exist. **Doubt rule:** if, after reading the evidence, the checker cannot affirm the pass condition, the verdict is **FAIL with the doubt named** ("cannot verify X because Y"). A doubt line is a normal FAIL line — element + fix action, named-gap grammar; "cannot verify" never excuses an unnamed gap. The economics are asymmetric by design: a false FAIL costs one override line and tunes the checker (§7.3); a false PASS is an escape — the expensive class the whole gate exists to prevent (contract §10).

### 5.3 ⚑ procedure — CC-XA-01 and CC-XA-06

⚑ is not a checker class; it is a **review obligation on top of the A verdict**, triggered only when the provisional verdict is pass-bound (P3). On a FAIL verdict, ⚑ lines read "— (verdict FAIL)", per the contract's worked example.

| Assertion | Evidence bundle the BA reviews |
|---|---|
| **CC-XA-01** | The extracted tuple table — every (role × entity × action) the stories and FRs exercise, each with its source line — set against the quoted policy rows that cover it. The BA's signature covers **extraction completeness**: the checker can miss a tuple, and a missed tuple is precisely the false pass that becomes a security incident. |
| **CC-XA-06** | Two lists: (a) spec claims mapped against the brief's §3 Excluded/Deferred — each marked "no conflict" or the conflict quoted; (b) every brief §6 `Open` row touching this feature × its resolution — spec location, or marker + waiver. The BA signs the scope boundary personally. |

**Decline path:** the BA refuses to sign → the assertion flips to FAIL with the BA's own named gap (the BA authors the line) → verdict FAIL.

### 5.4 Evidence record — one schema for everything

```
CC-<ID> · <element | whole> · PASS | FAIL | SKIPPED (blocked by CC-…) |
                              WAIVED (W-…) | OVERRIDDEN (O-…) | CARRIED (run n−1)
  evidence: <quoted line(s) + file:location> | <counts, for terse M PASS>
  reasoning: <one line — A checkers only>
  fix action: <required on FAIL — named-gap grammar>
```

The report (§6.2) prints failures, waivers, overrides, and ⚑ bundles in full; clean passes compress into the category summary.

---

## 6. Verdict assembly, the report entry & gap routing

### 6.1 Verdict rules

- **Live failure** = a FAIL line neither overridden nor waived after P2.
- **FAIL (n):** n = live failure lines (assertion × element — one assertion can contribute several gaps). Any SKIPPED element forces FAIL regardless (its blocker is among the failures).
- **PASS WITH WAIVERS:** zero live failures, zero skips, ≥ 1 waiver in force (fresh or re-affirmed).
- **PASS:** zero live failures, zero skips, zero waivers in force.
- **Provisional → effective:** a pass-bound verdict becomes effective only through P3 (⚑, individually) + P4 (approval, holistic). A FAIL needs no approval — it is final until fixed, overridden, or waived (contract §2).
- **FAIL as agenda (Presale drafts):** on a draft spec under the **Presale** profile, the FAIL report carries a second, informative job — its named-gap lines are the client Q&A agenda (orchestrator §6.5, D-O18). Nothing in the verdict machinery changes: the gate stays profile-blind (orchestrator D-O14); the FAIL stays final until fixed, overridden, or waived; certification still requires an effective PASS. A cross-reference on the §11.3 pattern, not new law.

### 6.2 The report entry — contract §7 core + runtime record

Appended per run to `specs/NNN-feature/gate-report.md` (artifact #18). Append-only; run numbers are monotonic per feature and **include blocked admissions** ("Gate run n — blocked at pre-flight"), so the ledger is gapless. The contract's §7 fields appear unchanged; the runtime appends its own block:

```
## Gate run <n> — <date>
Feature: … · Spec revision: <hash-short> · Scopes: F (+H pre-flight)
Verdict: PASS | PASS WITH WAIVERS | FAIL (<n> gaps)

Failures:             (named-gap grammar; non-waivable marked)
Waivers in force:     (contract §8 table; re-affirmations noted)
Overrides this run:   (contract §8 table; re-applications noted)
⚑ sign-offs:          (CC-XA-01 · CC-XA-06 evidence-reviewed lines, or "— (verdict FAIL)")
Category summary:     (totals: in force · evaluated · carried · passed · failed ·
                       waived · overridden · skipped; per-category breakdown on FAIL)
BA approval:          (name, date — required for any effective PASS)

Runtime record (gate definition §6.2):
Snapshot:             <k> files hashed — manifest at end of entry
Pre-flight:           clean | <n> gap(s) lifted by HA-<nn>, …   (§10.4)
Carried from run n−1: <CC-IDs + basis | none>          (§9.2)
Skipped:              <CC-ID · element ← blocker | none>
Certification:        <manifest | — (not an effective PASS)>
```

The report is the feature's audit trail: Phase-3's catch-rate metric reads it, and the certification manifest inside it is what the adapter verifies.

### 6.3 Gap routing — three fix lanes

Every FAIL line already names its fix action; the action falls into exactly one lane:

| Lane | When | Executes via |
|---|---|---|
| **Spec edit** | The gap lives in spec content | Tier-2 fix cycle. **Each FAIL line is, verbatim, a legality anchor:** a Tier-2 question packet cites this CC-ID in its legality field (doc 3 §5.5 clause a). Anchor ≠ obligation — draft-first applies to fixes too: rewrite from existing sources; ask only where the fix needs genuinely unknown information. |
| **Upstream artifact change** | The fix action names a governance/context file (a policy row, a glossary entry, a domain entity) | Doc-3 §3.5 routing discipline: proposed edit → BA approves → write → scoped Scope-H fires silently. The gate never writes upstream. |
| **Scope / aspect decision** | The gap reveals a contradiction with gated content, or a scope question above the feature | **Reopen signal** to doc 5, or a Band-2 allocation act. The gate emits; doc 5 executes. |

---

## 7. Waiver & override runtime

### 7.1 Waiver flow

1. A run names the gap (a waiver attaches only to a gap a run has produced — **no pre-emptive waivers**; an anticipated gap is simply a gap-to-be, and the incremental policy keeps the naming run cheap).
2. At P2 the BA requests the waive.
3. The runtime validates: **assertion waivable?** If in the non-waivable set → hard refusal, printing the contract's §8 rationale line for that ID. All six contract §8 fields present? Revisit trigger event-shaped ("when provider contract signs" — not a date wish)?
4. `W-<NNN>-<nn>` assigned (next per feature); logged in the entry's waiver table with its **anchor**: assertion, element, spec section, and the *Checks* dependencies at grant time.
5. The gap's status flips to WAIVED; the verdict recomputes within the same review.

**The CC-G-02 two-step, enforced:** a request to waive a stub is refused with the instruction — name the gap in the text as `[NEEDS CLARIFICATION: …]` (a spec edit → re-gate), then waive the resulting CC-G-03 gap. Every accepted gap is thereby a named gap, by construction.

**Under a standing autonomy grant** (orchestrator §4.4, §10.7), P2 waivers on real gaps may be taken AUTO — stamped `AUTO (AG-<n>)` in the report entry, standing for ratification at `off`. Overrides are never AUTO. The non-waivable set is untouchable under any mode: the auto path fixes and re-gates. P3 ⚑, P4 approval, and handoff (§11) sit outside every AG — the safety floor.

### 7.2 Waiver lifecycle events

- **In force:** the feature's current delivery cycle.
- **Void-on-edit:** at each re-gate the runtime diffs the new snapshot against the waiver's anchor. An edit touching the waived element's section, or any artifact in the waived assertion's *Checks* set → waiver **voided**, gap live again; a fresh request is possible. Section-level and coarse, exactly as the contract rules — a false re-affirmation costs one line; a stale waiver costs an incident.
- **Re-affirmation:** at each re-gate, every surviving waiver is listed one line at P5; the BA re-affirms (initials) or lapses it (lapse → gap live). The revisit trigger is displayed at this moment — the lazy read; no scheduler exists.
- **Cycle close:** the contract binds waivers to "the feature's current delivery cycle" without anchoring the cycle's end; this runtime anchors it — **the cycle closes when the BA's post-implementation verification for this feature closes** (Band 3's last step). All waivers expire at close; a later change to the feature opens a new cycle (§9.4), and an expired waiver whose gap persists must be **re-requested in full**, never re-affirmed. Expiry is passive — no scheduler; it is detected at the first re-gate of the new cycle (lazy detection, contract §3).

### 7.3 Override flow

At P2 the BA rules an A verdict a false positive, with the reason ("why the verdict was wrong"). `O-<NNN>-<nn>` assigned, carrying **the same anchor a waiver carries** (§7.1 step 4: assertion, element, spec section, *Checks* dependencies at ruling time); the assertion **passes by override** this run; the record feeds the tuning log. An override means the assertion passes; a waiver means it fails and we proceed anyway — the runtime never conflates the two records.

**Override persistence:** at re-gate the overridden element enters the re-run set as non-clean (§9.2), and the persistence check resolves it before any checker is invoked: a clean diff of the O-anchor (element evidence and *Checks* dependencies unchanged between snapshots) → the override is **auto re-applied** and logged ("O-… re-applied — evidence unchanged"), the checker not run; any change to the anchor → the checker is **re-armed** for a fresh verdict. The BA may also **revoke** a standing override at P2 — revocation sends the element to a fresh verdict before the run's verdict computes. Without persistence, the BA re-overrides the same known false positive every re-gate — ritual, which the contract's §10 explicitly treats as a defect signal.

### 7.4 Tuning feed

Project-level **`.specify/gate-tuning.md`** — a runtime ledger, housed outside `memory/` for the same reasons as the health ledger (§10.3) — two tables: **Overrides** (aggregated by assertion — the false-positive patterns) and **Escapes** (§12). Contract §10 consumes this file for version bumps. Doc 3's three elicitation logs (false-ask, wrong-draft, dead-answer) stay separate — different technique, different tuning target.

---

## 8. Traceability generation — CC-TR-04 mechanics

**Never hand-authored; generated every run; committed only on certification.**

**Procedure (Stage 2, after the graph build):**

1. From the snapshot-derived graph: US inventory (ID, priority, actor) · FR inventory (ID, US link, BR references) · acceptance items per story. Acceptance items get **generated positional handles** — `US<n>/AC-<i>` for checklist lines, `US<n>/S-"<name>"` for scenarios. Handles are generated, not spec IDs (the writing standard defines no AC IDs); they are stable only within a snapshot. Stable AC-IDs would be a writing-standard change — post-v1.
2. **Brief link:** every US → the parent brief's path + this feature's §8 slicing row. Capability-level links (US → a specific Essential-Scope line) need a structured tag the standard doesn't define — post-v1, exactly per the contract's C11 granularity note.
3. **Technique provenance** at derivable granularity: a file-level provenance line ("produced via Tier-2 spec-depth gap-filling, delivery cycle <date>") — v1 keeps no per-question log (doc 3 §5.1), so finer provenance does not exist to record.
4. Emit the candidate file with a banner: feature · spec revision · gate run · timestamp · **"GENERATED — do not edit; regenerated at every effective PASS."**
5. **CC-TR-04 evaluates the candidate** — coverage: every FR-ID has a row carrying its US, ≥ 1 acceptance handle, and the brief link.
6. **Commit at Stage 5** on effective PASS; hash into the certification manifest. **Discard on FAIL** — a previously committed file may remain on disk, but its certifying PASS is already void (the edits that produced the FAIL voided it), its banner names the revision it snapshots, and the next effective PASS overwrites it.

**File shape (sketch):**

```markdown
# Traceability — 004-appointment-booking
GENERATED at gate run 3 · spec r6 · 2026-07-18 · do not edit
Provenance: Tier-2 spec-depth gap-filling · delivery cycle 2026-07

| FR | Story | Acceptance | BR refs | Brief link |
|---|---|---|---|---|
| FR-001 | US1 | US1/AC-1 · US1/S-"Two Clients race for the last slot" | — | E-03 §8 / F1 |
…
Reverse index: US1 → FR-001, FR-002 · US2 → FR-003, FR-009 · …
Orphan check: none (CC-TR-01 PASS, run 3)
```

---

## 9. Re-gate mechanics

### 9.1 What voids a PASS

Any edit to `spec.md` · any edit to an artifact in the certification manifest · any framework-routed write touching a manifest artifact (the scoped-H run announces it — §10.2) · a parent-brief edit — including a sibling feature's Tier-2 write-back to brief §6 statuses (doc 3's pass-binding consequence). Voiding is a state change, not an event handler: it is *detected* at the next touchpoint — a re-gate, or the adapter's hash check — never watched for.

### 9.2 Incremental re-gate

The contract's smallest-sufficient-scope principle, applied to Scope F:

**Re-run set** = **all M** (cheap; they are the graph-integrity backbone) ∪ **everything not clean last run** (failed · waived · overridden · skipped — waived elements resolve through the §7.2 lifecycle, overridden elements through the §7.3 persistence check, before any checker runs) ∪ **every A assertion whose read set intersects the diff** ∪ **every whole-spec A on any spec edit**.

**Carried verdicts** = the rest — labeled `CARRIED (run n−1)` with the basis ("read set untouched by the diff"). An effective PASS from an incremental run certifies the **full** assertion set: fresh verdicts plus carried verdicts whose read sets are provably untouched. A **full run** is always available on BA demand and is recommended hygiene after many accumulated small edits.

**Read-scope table** (skeleton § numbers per writing standard §2):

| Category | Read set |
|---|---|
| CC-G (all) | whole spec |
| C1 OV | skeleton §1 + canvas + brief |
| C2 US · C3 AC | skeleton §2 (+ roles, hist for US) |
| C4 FR | skeleton §3 (+ hist) |
| C5 FL | skeleton §4 + §7 (states table) |
| C6 NF | skeleton §5 + governance |
| C7 BR | skeleton §6 + governance |
| C8 DA | skeleton §7 + domain model |
| C9 IN | skeleton §8 + brief |
| C10 OS | skeleton §9 + global out-of-scope |
| C11 TR | whole spec + memory + traceability |
| C12 XA | whole spec + roles / glossary / domain model / brief / memory |

**Authority note:** the contract's *Checks* column is authoritative; this table is a compiled view of it, regenerated on any contract version bump. A carry basis always resolves to contract text, never to this table alone.

### 9.3 The cheap re-gate — brief-edit sibling case

Brief edited → every certified-but-unhandedoff sibling's PASS voids. The cheap re-gate for each such sibling = **all M** + the brief-reading A set — **CC-OV-02 · CC-IN-01 · CC-XA-06 ⚑** (CC-XA-05 is M, already in) — + P5 re-affirmation of any waiver whose *Checks* include the brief. Everything else carries.

Note the deliberate floor: **CC-XA-06 is both brief-reading and ⚑** — a brief edit is therefore never signature-free for a certified sibling. A scope-boundary change always gets a human look. This is also why doc 3 says *batch brief edits* — the ⚑ cost is paid per batch, not per drip.

### 9.4 Where pass binding ends

Pass-binding obligations end **at handoff** — the adapter's hash check is the final enforcement; after the certified text has been read by `/speckit.plan`, later upstream edits do not retro-void anything (the code exists). Any post-handoff change to the spec opens a **new delivery cycle**: fix in the spec → re-gate (incremental is fine) → re-handoff. The plan's iteration discipline, enforced: spec errors are never hand-patched in code.

---

## 10. Scope-H runtime

### 10.1 Execution per trigger (contract §3 cadence, operationalized)

| Trigger | Runner behavior |
|---|---|
| **Full** (Band-1 closure · post-ingestion batch · on demand) | All six CC-H over all spec-anchored artifacts. Verdict: `HEALTHY` or `n gaps` in named-gap grammar. Entry appended to `.specify/gate-health.md` (§10.3); standing health acceptances are re-affirmed or lapsed here, one line each (P8, §10.4). The Band-1 closure run **arms the system**; before it, Scope H is disarmed (in-band quality belongs to doc 5's aspect gates). |
| **Scoped** (every framework write to a governance/context artifact) | The touched artifact's H assertions per §10.2 + its cross-reference dependents. **Silent unless FAIL.** |
| **Pre-flight** (Stage 0 of every Scope-F run) | The six CC-H restricted to `deps(F)`. This is the **hard guarantee** — the block is enforced here, freshly, every time; there is no standing lock and no daemon. |

### 10.2 Scoped-run map & the voided-certification notice

| Edited artifact | H assertions run | Cross-effects |
|---|---|---|
| glossary | CC-H-01 (gloss) · CC-H-04 | notice for certified-unhandedoff features (glossary is in every `deps(F)`) |
| roles-permissions | CC-H-01 · CC-H-05 | same |
| domain-model | CC-H-01 · CC-H-05 (policy rows referencing entities) | same |
| scope brief `<epic>` | CC-H-01 · CC-H-03 (that epic) | notice for that epic's certified features (§9.3) |
| roadmap | CC-H-02 · CC-H-03 | — |
| constitution / governance files | CC-H-01 · CC-H-06 | notice where in `deps(F)` |
| canvas · context · constraints · stakeholders · processes · out-of-scope | CC-H-01 | notice where the artifact is in a certified feature's manifest |

**Voided-certification notice:** the contract locks scoped runs as *silent unless FAIL*, and check results stay exactly that. But when a framework write voids a sibling's certification, the scoped run additionally emits **one line**: "PASS of 004 voided by <artifact> edit — cheap re-gate recommended." The silence rule governs *check results* (contract §3); a voided certification is a *pass-binding state change* (contract §2) that the contract nowhere binds to silence — announcing at write time beats discovering at handoff, and no erratum arises. The adapter's hash check remains the guarantee either way — this notice is a courtesy, not a control.

### 10.3 Results home

Artifact #18 is per-feature; Scope H is project-level and needs its own ledger: **`.specify/gate-health.md`** — append-only run entries (same named-gap grammar) plus one mutable head section, **Current gaps & acceptances** (standing H gaps · HA records with their revisit triggers), so Stage-0 admission and the BA's session-start habit can cite standing state at a glance. Pre-flight still runs fresh — the head section is convenience, never the guarantee.

**Deliberately outside `memory/`.** The ledger is a runtime artifact — none of the three content classes (plan Q3/Q7) — and `memory/` is the home of spec-anchored Governance and Context content. Housing it outside the contract's `.specify/memory/*` glob keeps it out of CC-H-01's spec-anchored set (the gate never audits its own ledger), out of the scoped-run write trigger (an H run's own write-back must not fire an H run), and out of any `memory/` mirror toward the coding agent's context (Mode A: the certified text is the read text; an operational ledger is not certified content). The tuning log follows the same rule (§7.4).

### 10.4 Blocking & the health acceptance

An unresolved H gap **blocks any Scope-F run whose `deps(F)` contains the failing artifact** — enforced at Stage 0, nowhere else. Scope-H gaps take **no per-feature waivers**: W-records are feature-scoped by construction, and accepting shared-artifact rot through one feature's waiver would be incoherent.

The instrument is a **project-level health acceptance** — `HA-<nn>`, same fields as a waiver (reason · risk accepted · approver · revisit trigger), project-numbered, recorded in the ledger's head section (§10.3). An HA-covered gap does not block admission. Without an acceptance instrument, any cosmetic H gap (an unmerged glossary synonym) freezes *all* delivery; with it, acceptance is conscious, visible, and revisited. Safety holds: the Scope-F assertions still guard the same ground wherever the gap actually bites a feature (an accepted glossary duplicate still fails CC-XA-03 in the spec that trips over it).

**HA mechanics, mirrored from the record types that already exist:**

- **Admission only.** An HA lifts Stage-0 blocks and nothing else — no Scope-F assertion ever reads it; it satisfies nothing. Runs it admits cite it in the entry's runtime record ("Pre-flight: <n> gap(s) lifted by HA-<nn>").
- **Persistence** — the §7.3 mechanism, applied at the H layer: when the accepted gap's artifact is edited, the scoped H run re-evaluates the gap. Evidence unchanged at element granularity (the same duplicate pair, byte-identical) → the HA **auto re-applies**, logged; evidence changed or gap reshaped → the HA **voids**, the gap goes live, admission blocks return, and a fresh grant is possible at the next P1. Voiding on real change creates the fix-it pressure at the natural moment; auto re-apply on unchanged evidence avoids re-blocking the whole project over an unrelated edit — an HA's blast radius is every feature's admission, which is why it gets the override's persistence rather than the waiver's blanket void-on-edit.
- **Review cadence.** Every full Scope-H run lists each standing HA, one line: re-affirm (initials) or lapse; revisit triggers are displayed at that moment (P8) — the lazy read; no scheduler exists.

---

## 11. Effective PASS → Mode-A handoff

### 11.1 Certification — the gate's last acts, in order

1. `traceability.md` committed to the feature folder (§8).
2. The report entry finalized — ⚑ lines and BA approval inked (P3, P4).
3. **The certification manifest** appended to the entry: every file the run read or produced, with content hashes —

```
Certification: run 3 · effective PASS · 2026-07-18
  specs/004-appointment-booking/spec.md           a41c…
  specs/004-appointment-booking/traceability.md   9f02…   (generated run 3)
  .specify/memory/roles-permissions.md            77b3…
  .specify/memory/glossary.md                     …
  .specify/memory/domain-model.md                 …
  .specify/memory/scope/E-03.md                   …
  canvas.md · constitution.md · out-of-scope.md · roadmap (E-03 rows) · [hist r5]
Adapter precondition: every hash matches the live file at handoff — any
mismatch → refuse handoff, print the diverged paths, demand re-gate.
```

4. **The gate stops.** Nothing past this line is the gate's act.

### 11.2 The adapter (Mode A) — a separate thin tool

In order: **verify every manifest hash** against the live files — the runtime enforcement of "the certified text is the read text"; refuse on any mismatch → cheap re-gate. Then the Spec Kit plumbing per plan Q5/§7: create or checkout the `NNN-feature` branch · ensure the `.specify` preset's expected directory structure and any copies Spec Kit's layout requires · confirm the certified artifact set is in place · report ready. **The operator resumes at `/speckit.plan`.**

### 11.3 What the gate never does

Never invokes any `/speckit.*` command · never edits a spec, a memory artifact, or code · never rewords content to pass its own checks · never waives or accepts silently · never runs a Band-1 aspect gate.

**Boundary sentence:** *the gate's responsibility ends when the certification manifest is written. The adapter owns the plumbing and the hash guard; the operator owns the pipeline from `/speckit.plan`; the BA re-enters at Band-3 verification.* *The session-wide form of this boundary — no implementation before PASS + handoff, for any reader — is orchestrator §10.2's session-mode rule (D-O11); this section is its gate-local instance.*

---

## 12. Downstream backstops & escape logging

`/speckit.checklist` and `/speckit.analyze` run where Spec Kit puts them, operator-invoked, **backstop only — never the bar** (contract §1). A backstop finding is never fixed downstream: it routes as an escape → spec fix → re-gate → re-handoff.

**Escape sources:** a `/checklist` or `/analyze` finding · plan- or tasks-time confusion · an implementation defect traced to spec ambiguity · a BA-verification defect traced to the spec.

**Escape record** — appended to `.specify/gate-tuning.md` (§7.4), the runtime counterpart of contract §10:

```
E-<NNN>-<nn> · caught by: /speckit.analyze | /speckit.checklist | plan confusion |
              tasks ambiguity | implementation defect | BA verification
  defect:      <what the spec got wrong or left open>
  should-have: CC-<ID> that ought to have caught it | none — new class
  disposition: contract-gap candidate (contract §10) | checker tuning (this doc /
               Phase-2 prompts) — an assertion that existed but was misjudged is a
               checker defect, not a contract gap
```

The standing goal, restated from the contract: **the backstop's job is to shrink to zero catches** — every catch it makes is our defect, not its success.

---

## 13. Phase-2 binding & Phase-1 manual mode

| Runtime element | Phase-2 primitive (names indicative — Phase 2 fixes them) |
|---|---|
| Scope-F run (stages 0–5) | `/ba.gate <feature>` slash command orchestrating scripts + agent + prompts |
| M checkers | Vendored scripts: heading/order parser · stub, marker & banned-word scanners · EARS lint (vendored) · ID-graph builder (doubles as the traceability generator) · snapshot differ |
| A checkers | Gate subagent; compiled prompt cards = assertion text + CC-ID only (the contract's BABOK-layering rule — the runtime never loads document 2 itself) |
| P2–P5 · P8 prompts | Plan-mode review checkpoints |
| Scope H | `/ba.gate-health [artifact | full]`; scoped runs hooked to the framework's write actions |
| Adapter | `/ba.handoff <feature>` per §11 |

**Phase-1 manual mode:** the BA runs the stages by hand — §4.2 is the checklist, §5's M procedures are mechanical instructions, A assertions are read against the snapshot with the §5.4 evidence discipline, and the §6.2 template is filled by hand. This document + the contract + the standard satisfy the Phase-1 exit criterion for the gate: a human BA can run it from the documents alone.

---

## 14. Worked example — 004-appointment-booking, runs 2 → 3

Continuing the contract §7 worked example (run 2: FAIL, 5 gaps) to the gate's full lifecycle.

### 14.1 Dispositions of run 2's gaps

| Gap | Lane (§6.3) | Fix |
|---|---|---|
| CC-XA-01 — missing (Specialist × Appointment × cancel) | Upstream | Policy row proposed via doc-3 routing → BA approved 2026-07-17 → written; scoped Scope-H fired silently, clean. Nothing to void — 004 held no certification. |
| CC-G-04 — FR-007 "quickly" | Spec | Adverb removed; the timing concern moved to NFR-003: *notification delivered within 60 seconds of confirmation, normal load*. |
| CC-AC-04 — US1 re-narrating scenario | Spec | Replaced with the race-for-the-last-slot scenario, concrete data (standard §5's shape). |
| CC-NF-02 — accessibility silent | Spec | Explicit `N/A — covered by the global Design & UX accessibility budget; no feature-specific delta` (the CC-NF-03-compliant form). |
| CC-TR-01 — US4 unbuilt | Spec (scope) | US4 dropped; ID retired, never reused (CC-US-04); the capability fenced: Out of Scope gains *"Notification preferences — deferred, Phase 2"* (CC-OS-02-compliant). |

No Tier-2 questions were needed: all five fixes drafted from existing sources. The legality anchors existed and went unused — anchor ≠ obligation.

### 14.2 Run 3 composition (incremental, §9.2)

Diff r5 → r6 touched skeleton §§2, 3, 5, 9 + `roles-permissions.md`. Re-run set: all 21 M · whole-spec A (CC-G-02/05/06, CC-XA-03/06/07, CC-OS-04) · section-scoped A over §§2/3/5/9 · governance-reading A (CC-NF-03, CC-BR-03, CC-XA-01) · run-2's non-clean set. **Carried (13):** CC-OV-01/02 · CC-FL-01…05 · CC-DA-01…04 · CC-IN-01/02 — read sets untouched. CC-IN-03 stands WAIVED. O-004-01 auto re-applies — US2's acceptance block is byte-identical between snapshots (element granularity is what makes the carry legal while §2 as a whole changed).

### 14.3 Run 3 report entry (condensed)

```
## Gate run 3 — 2026-07-18
Feature: 004-appointment-booking · Spec revision: r6 · Scopes: F (+H pre-flight)
Verdict: PASS WITH WAIVERS

Failures: none
Waivers in force:
W-004-01 · CC-IN-03 · calendar-sync failure expectation deferred · reason:
  provider contract unsigned · risk: manual reconciliation during pilot ·
  approver: Y.K. · revisit: before Phase-3 pilot exit · re-affirmed run 3
  (§Integration Touchpoints and brief untouched since grant).
Overrides this run:
O-004-01 · CC-AC-04 · re-applied — evidence unchanged since run 2.
⚑ sign-offs:
CC-XA-01 — 7 exercised tuples extracted; 7 explicit policy rows matched,
  incl. the (Specialist × Appointment × cancel) row added 2026-07-17 ·
  evidence reviewed · Y.K.
CC-XA-06 — no spec content in brief §3 Excluded/Deferred; OQ-1 Answered →
  BR-001; OQ-2 Open → carried as [NEEDS CLARIFICATION] under W-004-01 ·
  evidence reviewed · Y.K.
Category summary: 55 in force · 41 evaluated · 13 carried · 1 waived —
  0 failed · 0 skipped · 1 overridden (re-applied)
BA approval: Y. Kliukin · 2026-07-18 — effective PASS

Runtime record:
Snapshot: 11 files hashed — manifest below
Pre-flight: clean
Carried from run 2: CC-OV-01/02 · CC-FL-01…05 · CC-DA-01…04 · CC-IN-01/02
  (read sets untouched by r5→r6 diff)
Skipped: none
Certification: (manifest as §11.1) — adapter precondition in force
```

### 14.4 Handoff

`traceability.md` committed (run 3, r6) · adapter verifies 11 hashes — clean · branch `004-appointment-booking` checked out · `.specify` plumbing confirmed · operator runs `/speckit.plan`. The coding agent reads exactly one consciously accepted unknown — the OQ-2 marker under W-004-01 — and nothing hidden. Gate's responsibility: ended at the manifest.

---

## 15. Review record (v0.1 → v0.2)

Nine decisions ruled, 24 July 2026 — D-G1…D-G3 by the BA Lead directly; D-G4…D-G9 on the BA Lead's delegated authority, same session.

1. **D-G1 · Scope-H results home** — file design adopted (append-only entries + mutable "Current gaps & acceptances" head); **location amended**: `.specify/gate-health.md`, outside `memory/` — a runtime ledger is none of the three content classes, must stay out of CC-H-01's `.specify/memory/*` glob and the scoped-run write trigger, and clear of any `memory/` mirror toward the coding agent's context (§10.3).
2. **D-G2 · A-checker doubt bias** — adopted: cannot affirm ⇒ FAIL with the doubt named; a doubt line carries element + fix action like any FAIL (§5.2).
3. **D-G3 · Incremental re-gate policy** — adopted as recommended; authority note added: the read-scope table is a compiled view of the contract's *Checks* columns, regenerated on any contract bump (§9.2).
4. **D-G4 · Override persistence** — adopted, sharpened: the O-record carries the waiver's anchor shape (§7.1 step 4); persistence resolves before checker invocation inside the §9.2 re-run set; the BA's revocation right at P2 stated (§7.3).
5. **D-G5 · Certification manifest + adapter hash guard** — adopted as recommended (§11).
6. **D-G6 · Voided-certification notice** — adopted; ruled **compatible** with the contract's silence rule: silence governs check results (contract §3), voiding is a pass-binding state change (contract §2) the contract nowhere binds to silence — no erratum (§10.2).
7. **D-G7 · Delivery-cycle close** — adopted: the cycle closes at BA post-implementation verification close; waivers expire at close and are re-requested, never re-affirmed, in a new cycle; expiry is passive, detected at the new cycle's first re-gate (§7.2).
8. **D-G8 · Tuning-log home** — content adopted; **location amended** to `.specify/gate-tuning.md`, co-located with the health ledger under the D-G1 rule (§7.4, §12).
9. **D-G9 · Health-gap acceptance** — adopted, mechanics pinned: an HA lifts admission only and is never read by Scope F; its persistence mirrors the override's (auto re-apply on unchanged element evidence, void on change — chosen over the waiver's blanket void-on-edit because an HA's blast radius is project-wide admission); review cadence = one line per standing HA at every full Scope-H run, prompt point P8 added (§10.4, §2.3).

**Conflict scan against contract v0.2:** none found; two compatibility readings recorded above (D-G6; D-G9 — the contract is silent on admission machinery, and the HA extends §2 BA authority to admission effects while preserving the block's purpose: "a feature gate against rotten shared artifacts is meaningless" stays enforced, consciously). **No erratum issued.**

---

*v0.6 · the AUTO waiver lane and the safety floor applied 13 Aug 2026 (§7.1; orchestrator D-O36 · D-O37, WS-3) · FAIL-as-agenda cross-reference applied 9 Aug 2026 (orchestrator D-O18 follow-up) · session-boundary cross-reference applied 7 Aug 2026 (D-O11) · D-B6-1 mirror applied 30 July 2026 · review incorporated 24 July 2026 · runtime of completeness contract v0.2 — 61 assertions: 24 M · 37 A (2 ⚑) · consumes writing standard v0.3 (its §15 = the writer's half) · receives specs from elicitation techniques v0.4 (Tier 2) and returns named gaps as its legality anchors · emits reopen signals to orchestrator rules (document 5) · hands to the Mode-A adapter at the certification manifest · runtime ledgers: `.specify/gate-health.md` · `.specify/gate-tuning.md` · v0.1→v0.2 review record in §15*
