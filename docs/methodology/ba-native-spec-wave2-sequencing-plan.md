# Geniusee Wave-2 Sequencing Plan
### BA-Native Spec · technique-catalogue authoring plan · v0.4 — D-B2-1 mirror applied (30 July 2026; review incorporated 25 July 2026)
**v0.4 change record:** one catalogue-b2 mirror, additive — D-B2-1 (enrichment-serve trigger semantics note) → §2. No other changes.
**v0.3 change record:** D-W8 erratum only — glossary ★ removed (B1 kickoff verified: no presale glossary skill exists among the user skills): §1 T-02 row · §5.1 stored row text · §5.3 stored bullet text. No other changes.

**What this is:** the authoring plan for Wave 2 — the technique catalogue. It pins the exact sheet inventory (§1), the uniform sheet template every sheet follows (§2), the dependency-ordered conversation batches (§3), and the standing batch prompt that runs each authoring session (§4). §5 carries the three plan-doc corrections ready to apply. §6 is the review record — nine decisions locked, 25 July 2026.

**Why it exists:** Wave 1 closed the spine — the machinery is complete without the catalogue (orchestrator §11: the custom-contract path carries Band 1 until the catalogue lands). Wave 2 is mass authoring: ~18 sheets across multiple conversations. Without a pinned inventory, a uniform template, and a dependency order, the batches would drift in structure and re-litigate scope per session. This document is authored once so the batches never have to think about anything but their sheets.

**Ruling in force (restated once, authoritative over plan v2.5's text):** every technique sheet is authored **from scratch**; presale chat skills are **reference designs to mine, never components** (elicitation v0.3 §7/§11, BA Lead 20 July 2026). Superseded and not inherited: plan row 6's "~13 / 5 reuse" premise · the §4 ★ legend ("drops in natively") · Q4's reuse clause · §8's "reusing the 5 existing skills" wording. The corrections in §5 retire that wording from the plan itself. ★ in this document always means: *a presale reference design exists to mine.*

**Not in Wave 2 (spine-owned or already specified):**

| Item | Owner |
|---|---|
| #12 Epic scope briefs — Tier-1 technique | Elicitation doc §3 (complete) |
| #16 Feature spec — Tier-2 technique + story-drafting build brief | Elicitation doc §5, §7.2 (complete) |
| #17 Traceability | Generated at gate time — gate §8, CC-TR-04 ("never hand-authored") |
| #18 Gate report | Gate §6.2 / contract §7 |
| Tier-1 call-kit generator build brief | Elicitation §7.1 (§3.2 is its complete spec) |
| Risk register · ADRs · data dictionary · test-scenario generation | Post-v1 (plan §10) |

---

## 1. The pinned inventory — 18 sheets

**Derivation:** plan §4's 18 artifacts, minus the four spine-owned above, leaves **14 artifacts** needing technique coverage (#1–#11, #13–#15). Fifteen sheets cover them (roadmap #11 takes the Band-2 pair; everything else 1:1), plus **three canvas-internal aspect sheets** (Value · Vision · Solution — aspects whose evidence home is the canvas itself, orchestrator §2.1) so the suggestion engine has catalogue coverage for all six aspects. **D-W1, D-W2, D-W4 (locked)** fix the count: **"~18" resolves to exactly 18.** Sheet IDs `T-01…T-18` are assigned in authoring order (§3).

| ID | Technique sheet | Target artifact(s) | Class | Serves (aspect \| act) | Primary gate hooks (AT · CC) | ★ Reference design |
|---|---|---|---|---|---|---|
| T-01 | Discovery canvas framing | #1 canvas (+ Context/Constraints element, Q1a) | Context | Frame act (orchestrator §8.1) — evidence substrate for all canvas-anchored AT | AT-ST-1 · AT-CX-3 · AT-VA-1/2 · AT-VI-1/2 · AT-SO-1/2/3 · CC-H-01; read by CC-OV-02 | ★ presale canvas skill |
| T-02 | Glossary discipline | #2 glossary | Context | Requirements (used from Frame on — golden rule 3) | AT-RQ-3 · CC-H-04; read by CC-XA-03 | — |
| T-03 | Stakeholder register | #3 stakeholder register | Context | Stakeholders | AT-ST-2 · AT-ST-3 · CC-H-01; resolution target of AT-VA-1 | — |
| T-04 | Persona charters | #6 personas (transformation-ready) | Context | Stakeholders (enrichment — typically BA-elected, §6.1 rule) | CC-XA-02 · AT-RQ-2 (persona→role principle clause) · CC-H-01 | — |
| T-05 | Context & landscape mapping | #4 context | Context | Context | AT-CX-1 · CC-H-01 | — |
| T-06 | Constraints elicitation | #5 constraints & limitations | Context | Context | AT-CX-2 · CC-H-01; read by AT-VI-3, kit baselines | — |
| T-07 | Competitive analysis | #7 competitive analysis | Context | Context + Vision (dual-aspect) | AT-CX-3 · AT-VI-2 · CC-H-01 | — |
| T-08 | Value definition | canvas Problems · Objectives | (canvas-internal) | Value | AT-VA-1 · AT-VA-2; anchor of the CC-OV-02 chain | — |
| T-09 | Vision & differentiation | canvas Product→The/Is/That · Our Solution | (canvas-internal) | Vision | AT-VI-1 · AT-VI-2 · AT-VI-3 (constraint-contradiction scan) | — |
| T-10 | Solution surface review | canvas Forms · Core Functions · 3rd-Party · Localization | (canvas-internal) | Solution | AT-SO-1 · AT-SO-2 · AT-SO-3; seeds brief §4 / CC-IN-01 chain and AT-RQ-4 entities | — |
| T-11 | Domain (conceptual) modeling | #8 domain model | Context | Requirements | AT-RQ-4 (entities+relations) · CC-H-01; read by CC-DA-01 · CC-XA-04 | — |
| T-12 | Roles & permissions (incl. persona→role transformation) | #14 roles-permissions | Governance | Requirements | AT-RQ-2 · CC-H-05; read by CC-US-02 · CC-XA-01 ⚑ · CC-TR-03 | — |
| T-13 | Core process mapping | #9 core processes | Context | Requirements | AT-RQ-4 (journeys clause) · CC-H-01; Tier-2 context-stack member | — |
| T-14 | Design & UX standards | #15 design & UX standards | Governance | Requirements | AT-RQ-1 · CC-H-06; read by CC-NF-03 (global budgets) | — |
| T-15 | Constitution | #13 constitution | Governance | Requirements | AT-RQ-1 · CC-H-06; carries the persona→role principle backing CC-XA-02; Spec Kit Constitution Check surface | — |
| T-16 | Global out-of-scope | #10 out-of-scope | Context | Requirements | AT-RQ-1 · CC-H-01; read by CC-OS-03 | — |
| T-17 | Epics decomposition | #11 roadmap (epic rows: name · 2–3-sentence description · phase — Tier-1's locked input shape, elicitation §2/§3.2) | Context | Band-2 act | CC-H-02 (statuses) · CC-H-03 chain (briefs attach to these epics) | ★ presale epics skill |
| T-18 | Scope allocation (repeatable) | #11 roadmap (allocation + re-allocation diffs) | Context | Band-2 act, re-runnable (plan C1) | CC-H-02 (diff + reason per rerun) | — |

**Coverage proof (artifact → sheet):** #1→T-01 · #2→T-02 · #3→T-03 · #4→T-05 · #5→T-06 · #6→T-04 · #7→T-07 · #8→T-11 · #9→T-13 · #10→T-16 · #11→T-17+T-18 · #13→T-15 · #14→T-12 · #15→T-14. Fourteen of fourteen covered; no orphan sheets.

**Totals:** Wave-2 catalogue = 18 sheets · framework technique total = **20** (18 catalogue + Tier 1 + Tier 2) — the plan's "~18 techniques" arithmetic updates accordingly (§5.4).

---

## 2. The uniform sheet template

Every sheet follows this skeleton, sections in this order, exact headings (the standard §2 discipline, applied to our own artifacts). Target length **60–120 lines per sheet** including the micro-example — a sheet is a technique definition, not a treatise. All micro-examples stay in the corpus's running world (appointment booking: E-03, Client/Specialist, Dr. Ivanova, Olena).

```markdown
## T-<nn> · <Technique name>
Band <n> · serves: <aspect(s) | Frame | Band-2 act> · class: <Context | Governance>
· target: <artifact # + name> · ★ <reference design | —>

### 1. Purpose & BABOK grounding
What this technique elicits or produces, in 2–4 sentences, and the decision
it lets the BA make. BABOK anchors in contract-§2 style: task number +
technique number (e.g., 10.43 Stakeholder List/Map/Personas · 4.3 Confirm
Elicitation Results). House decisions cited as `plan Qn/Cn`.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | <aspect(s)> · or `Frame` / `Band-2 act` (D-W7, locked) |
| Evidence triggers | The AT-ID holes this technique fills, each with the
|   | evidence pattern that indicates it ("AT-CX-2 — a constraint class
|   | carries neither a confirmed row nor a none-identified basis").
|   | Band-2 sheets: band-state triggers instead (closure done; C1 rerun
|   | events: post-decomposition, post-call, delivery learnings, priority
|   | shift). Every trigger names its hole — §6.1's evidence-grounded rule. |
| Skip-if | When suggesting is illegal or pointless: the criterion is cleared
|   | (§6.1 — enrichment only on BA ask) + technique-specific redundancy
|   | conditions with named sources ("greenfield confirmed in context.md"). |
| Depth | The band's depth boundary, doc-3 §3.3 pattern: what this technique
|   | elicits at threshold grade, and what it must NOT descend into
|   | (spec-depth detail is Tier-2 ground; naming the forbidden zone makes
|   | a bad question illegal by construction). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | <the artifact or section set, named precisely> |
| Artifact class | Context | Governance |
| Destination file | <exact path — .specify/memory/… · canvas.md section> |

### 4. Procedure
Numbered steps; each labeled framework act or BA act (rule: the framework
proposes and assembles, the BA rules). Techniques that draft or ask inherit
doc 3's three operating principles verbatim: draft-first · no question
without a destination · cited, marked, or asked — never guessed. Signal
emission points named where they occur (routing / reopen → orchestrator §9).

### 5. Output template & micro-example
The destination artifact's section skeleton, then a filled micro-example in
writing-standard discipline: tables for structured data, glossary-canonical
terms, zero banned words, cite-or-mark. Running example world only.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks — AT criteria this output clears (aspect-gate evidence; never contract assertions, orchestrator §3.2) | AT-… |
| Health hooks — CC-H assertions that keep the artifact alive post-arming | CC-H-… |
| Consumer hooks — Scope-F assertions that later read this artifact (the shape contract downstream checkers assume) | CC-… |

### 7. Reference-design mining notes
★ sheets: the doc-3 §7.2 two-column table — *reference design contributes
(mine these)* | *framework sheet must satisfy (from scratch)* — behaviors
deliberately left behind listed explicitly. Non-★ sheets, one line:
"No reference design — built to this sheet alone" (the §7.1 pattern).

### 8. Phase-2 build-brief hook
The seed the Phase-2 skill is built to (doc 3 §7 format): invocation
(`/ba-run T-<nn>`, contract check at P-O3 — orchestrator §11) · inputs
loaded (context stack, order) · interaction pattern · outputs written ·
what §§2–6 above already fix vs. what Phase 2 must add. Short — the sheet
is the spec; this section is the compilation note.
```

**D-W9 (locked):** the skeleton places the output contract (§3) *before* the procedure (§4) — a deliberate reorder of the tasked field sequence, so that metadata + contract sit adjacent as one catalogue entry and the procedure lands an already-pinned contract.

Two template rules, stated once: **(a)** section 2's metadata plus section 3's contract together form the sheet's **catalogue entry** — the exact surface orchestrator §6.1/§6.3 consumes; a sheet missing either is not catalogue-admissible. **(b)** a sheet defines its technique at Band-1/Band-2 runtime depth only — skill implementation detail beyond section 8's hook belongs to Phase 2, exactly as spec detail beyond `/plan`'s seam belongs to Spec Kit.

**Enrichment-serve trigger semantics (D-B2-1, catalogue-b2, locked):** where a sheet's Serves value is an enrichment serve — never threshold ground — no AT hole exists to name, and its Evidence-triggers cell states exactly that no-hole fact: framework-initiated suggestion never fires (orchestrator §6.1 — a suggestion that cannot name its hole must not be emitted); entry paths are BA election into any open aspect's composed plan and listing on an explicit BA ask. Extends D-W7's polymorphic field reading to the enrichment case.

---

## 3. Dependency order & conversation batches

Six batches, 3/4/3/3/3/2, in strict order; within-batch authoring order as listed — shape locked (D-W5). Grouping constraints honored: glossary-first (B1) · personas→roles chain (T-04 in B2 precedes T-12 in B4 — order required, adjacency not; T-04's transformation-ready charter shape is the contract T-12 consumes) · domain model before data-heavy ground (T-11 opens B4, before roles' entity-referencing policy rows and processes' entity-touching journeys) · Band-2 pair together (B6).

| Batch | Sheets (authoring order) | Rationale |
|---|---|---|
| **B1 — Frame & foundation** | T-01 canvas ★ → T-02 glossary ★ → T-03 stakeholder register | The anchor and the language rule first: every later sheet cites canvas sections and glossary-canonical terms (golden rule 3); the register is the root aspect and the resolution target for AT-VA-1, personas, and Tier-1 comms. Both ★-mining sheets land in one session — the mining pattern is established once. |
| **B2 — Stakeholders & Context breadth** | T-04 personas → T-05 context → T-06 constraints → T-07 competitive | Completes the two root-adjacent aspects. Personas ride B1's fresh register context; constraints and competitive seed B3 (AT-VI-3 reads constraint rows; AT-VI-2 reads Unlike entries). Four sheets, but the lightest four in the set. |
| **B3 — Canvas-internal aspects** | T-08 value → T-09 vision → T-10 solution | The DAG's middle, authored in DAG order in one sitting: vision consumes B2's constraints + competitive; solution links functions to session-fresh objectives (AT-SO-2) and seeds the domain-model entities B4 opens with. |
| **B4 — Requirements core chain** | T-11 domain model → T-12 roles & permissions → T-13 core processes | The hard dependency chain, one session: entities (T-11) before the policy rows that reference them (T-12, CC-H-05); roles before the journeys of significant roles (T-13). T-12 also lands the persona→role transformation, consuming T-04's charter shape. Class mixes (Context + Governance) — dependency trumps class in batching. |
| **B5 — Requirements governance & boundary** | T-14 design & UX standards → T-15 constitution → T-16 out-of-scope | Referenced-before-referencer: the constitution references roles (B4) and design standards (T-14), so it is authored after both; out-of-scope closes the Band-1 boundary with the full solution surface and roadmap-adjacent expectations visible. |
| **B6 — Band-2 pair** | T-17 epics decomposition ★ → T-18 scope allocation | After the complete Band-1 catalogue — decomposition consumes the whole discovery estate; allocation reads decomposition's output and defines the C1 rerun/diff machinery. Two sheets, below the 3-sheet aim, deliberately: the pair is isolated by design and both are heavier than average (T-17 mines a ★ and fixes the roadmap shape Tier 1 depends on; T-18 defines repeatability mechanics). |

**Sequencing invariant:** a batch may cite only sheets from earlier batches (or its own, earlier in order). A forward reference discovered mid-authoring is a sequencing defect — logged in that batch's open decisions, resolved by deferring the referencing content, never by pulling a future sheet forward.

**Wave-2 close act (D-W6):** after B6 review-closes, assemble the **catalogue index** — one metadata + contract row per technique, the single machine-readable surface the suggestion engine and Phase 2 read — as `ba-native-spec-catalogue-index`; flip plan row 6 to 🟢.

---

## 4. The standing batch prompt

One reusable prompt per authoring conversation; `{SLOTS}` parameterized per batch from §1 and §3. Everything else is carried verbatim.

```text
We're continuing BA-Native Spec — Phase 1, Wave 2 authoring. This session
authors Batch {B-ID} — {BATCH-NAME} of the technique catalogue, per the
Wave-2 sequencing plan.

Ground yourself in the project files first:
- "ba-native-spec-wave2-sequencing-plan" — §1 (inventory rows for this
  batch), §2 (the uniform sheet template — every sheet follows it exactly),
  §3 (this batch's position and within-batch order).
- "ba-native-spec-definition-and-plan" — §3 aspect model, §4 artifacts,
  §5 bands; the locked Q/C decisions each sheet grounds in.
- "ba-native-spec-orchestrator-rules" — §3.3 (the AT criteria this batch's
  evidence triggers name), §6 (the catalogue entry the metadata + contract
  must satisfy).
- "ba-native-spec-completeness-contract" — the CC-H and Scope-F assertions
  in this batch's gate hooks.
- "ba-native-spec-writing-standard" — output discipline for every template
  and micro-example.
- "ba-native-spec-elicitation-techniques" — §3.3 depth calibration, the
  three operating principles (§ preamble), §7's mining-table format.
- Prior batch files: {PRIOR-BATCH-FILES | "none — this is B1"} — cite, never
  restate, their sheets.

Rulings in force: every sheet is authored from scratch; presale skills are
reference designs to mine, never components (elicitation v0.3 §7/§11).
Tier 1 / Tier 2 are spine-owned and not sheets. Micro-examples stay in the
appointment-booking world. Target 60–120 lines per sheet.

Sheets in scope, in this order:
{FOR EACH SHEET:
  T-{nn} {name} — target: {artifact}, class: {class}, serves: {aspect|act}
  · ★ reference: {skill | none}
  · gate hooks: {AT-IDs · CC-H-IDs · consumer CC-IDs}
  · batch-specific notes: {dependency notes from plan §3, if any}}

Task: author all sheets of this batch in one markdown file —
"ba-native-spec-catalogue-{b-id}" (v0.1, draft for my review) — each sheet
to the §2 template, complete with catalogue metadata, pre-pinned Q2+
contract, procedure, output template + micro-example, gate hooks, mining
notes ({★ two-column table | "no reference design" line}), and the Phase-2
build-brief hook.

Working mode: draft the complete file first — don't interview me before
drafting. Where a design decision is genuinely open, make a recommendation
inline (mark it ▸, label D-{B-ID}-1, D-{B-ID}-2, …) and collect them in a
final open-decisions section. At review close that section converts to the
batch's review record, including a conflict scan against the five spine
documents and all prior batches; a spine contradiction found mid-authoring
is routed as an erratum to a separate conversation, never patched here.
End the session by emitting the updated plan §0 tracker row 6 line
reflecting this batch's completion.
```

---

## 5. Plan-doc corrections — applied 25 July 2026 → plan v2.6

### 5.1 §0 tracker — row 6, corrected

```markdown
| 6 | Wave 2 breadth — the technique catalogue: 18 sheets, all authored from scratch (★ = presale reference design to mine: canvas, epics); incl. the Band-2 pair (epics decomposition · scope allocation), persona charters, glossary discipline; 6 batches per the sequencing plan | 🟡 sequencing plan v0.2 closed (D-W1–D-W9) · batches 0/6 | ba-native-spec-wave2-sequencing-plan |
```

*(On batch progress, the status cell becomes "🟡 B<n>/6 done"; on Wave-2 close, "🟢 catalogue complete — 18 sheets".)*

### 5.2 §4 — ★ legend line, corrected

```markdown
★ = a presale-flow chat skill exists as a **reference design** — mined for
proven interaction patterns and content heuristics at sheet-authoring time,
never imported as a component (elicitation v0.3 §7/§11 ruling). Everything
else from the wide menu = custom / addable later.
```

### 5.3 §8 — Wave 2 bullet, rewritten

```markdown
- **Wave 2 — breadth: the technique catalogue.** 18 technique sheets
  authored **from scratch** to the uniform sheet template (Wave-2
  sequencing plan): the Band-1 catalogue — 16 sheets incl. the Frame
  canvas technique, persona charters, glossary discipline, and the
  canvas-internal aspect trio (Value · Vision · Solution) — plus the
  Band-2 pair (epics decomposition · repeatable scope allocation). Each
  sheet pre-pins its Q2+ output contract and carries catalogue metadata
  for the BA-planning loop (doc 5 §6), gate hooks (AT thresholds ·
  CC-H keep-alive · Scope-F consumers), an output template in
  writing-standard discipline, and a Phase-2 build-brief hook (doc 3 §7
  format). Presale skills serve as reference designs to mine where they
  exist (canvas ★ · epics ★) — never as components.
  Authored in 6 batched conversations per the sequencing plan's
  dependency order.
```

### 5.4 Companion line edits (arithmetic + consistency, not design)

- §8 Phase-1 intro: "17 artifacts + ~18 techniques" → **"17 artifacts + 20 techniques (2 spine + 18 catalogue)"**.
- §0 next-action line: replace the "~13 technique sheets" sentence with: **"Next action: run Wave-2 batches B1–B6 per the sequencing plan, standing batch prompt §4."**
- *Applied (hygiene):* Q4's closing clause "and existing Geniusee skills drop in natively" → "technique skills are authored from scratch, with presale skills mined as reference designs (elicitation v0.3 ruling)". The Q4 decision itself — native primitives, BMAD reference-only — is untouched; only the superseded supporting clause is corrected. Revert if the locked log should stay verbatim.

---

## 6. Review record (v0.1 → v0.2)

Nine decisions ruled by the BA Lead, 25 July 2026 — **all recommendations accepted as stated.** The locked text stands inline at each section (§1 inventory · §2 template · §3 batches); the recommendation column below stands as the rulings' record.

| # | Decision | Ruling (adopted as recommended) | Basis |
|---|---|---|---|
| **D-W1** | Canvas-internal aspect trio (T-08/09/10) — author as catalogue sheets, or leave Value/Vision/Solution to the custom-contract path? | **Author as sheets.** Each maps to named AT holes (AT-VA/VI/SO) with real technique substance (problem/objective analysis · differentiation + constraint-contradiction scan · function-to-objective linkage); without them, three of six aspects have zero catalogue coverage and every Band-1 run there rides the custom path — legal (orchestrator §6.3) but defeats the catalogue's purpose. | Orchestrator §2.1, §6.1 |
| **D-W2** | Context (T-05) and Constraints (T-06) — two sheets or one merged? | **Two.** Separate artifacts (#4, #5), separate AT criteria (AT-CX-1 vs AT-CX-2), distinct procedures: landscape mapping vs class-driven constraint elicitation with the none-identified-basis discipline. | Plan §4; orchestrator §3.3 |
| **D-W3** | Persona→role transformation home | **Procedure lives in T-12 (roles sheet), consuming T-04's transformation-ready charter shape** — the transformation is an authorization-side act, and CC-XA-02/AT-RQ-2 enforcement sits with the roles artifact. T-04 pins the charter fields the transformation reads. | Plan §4.6; contract CC-XA-02 |
| **D-W4** | The pinned count | **18.** Sensitive to D-W1/D-W2 only: trio folded into T-01 enrichment and context+constraints merged → floor 15. Under the recommendations, "~18" resolves to exactly 18 and the framework total to 20 (with Tier 1/2). | §1 derivation |
| **D-W5** | Batch shape | **Six batches, 3/4/3/3/3/2.** Alternative: fold B6 into B5 (5 sessions, one 5-sheet batch mixing Band-1 governance with the Band-2 pair) — rejected: B6's isolation matches the band boundary and both Band-2 sheets are heavy. B4+B5 merge (6 sheets) exceeds the 5-sheet cap. | §3 |
| **D-W6** | Output file convention | **One catalogue file per batch** (`ba-native-spec-catalogue-b1…b6`, stable names, replace-on-update) **+ one catalogue index assembled at Wave-2 close** — the metadata + contract table, one row per technique: the single machine-readable surface the suggestion engine (and Phase 2) reads; the batch files remain the full definitions. Alternative: 18 per-sheet files — cleaner 1:1 with Phase-2 build briefs, heavier project-file management. | Plan §0 working model; orchestrator §6.1 |
| **D-W7** | Template accommodation for non-aspect techniques (T-01 Frame; T-17/T-18 Band-2) | **One template, polymorphic Serves field** (`aspect(s) | Frame | Band-2 act`); evidence triggers take AT holes for aspect sheets, band-state triggers for the others (closure done · C1 rerun events). No second template — the catalogue entry stays one shape. | Orchestrator §8.1, plan C1 |
| **D-W8** | Glossary ★ verification | **Verify at B1 kickoff** whether a presale glossary skill actually exists to mine (plan §4 marks #2 ★; it is not among the skills read during Wave 1). If absent: T-02 is authored to the §7.1 no-reference pattern — no methodological change — and a one-line plan erratum drops the ★ from #2. | Elicitation §7.1 |

| **D-W9** | Template section order — contract before procedure | **Keep the reorder** (contract §3 ahead of procedure §4, vs. the tasked sequence): metadata + contract adjacent = the catalogue entry as one contiguous block (orchestrator §6.1 + §6.3 read exactly these two), and the procedure then lands an already-pinned contract — mirroring the runtime rule that no technique runs unpinned. Reverting to the tasked order costs nothing methodologically; this is layout, flagged for the record. | Orchestrator §6.3 |

**Conflict scan against the spine (standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.2 · orchestrator v0.2):** none found — every AT-ID, CC-ID, artifact number, and section reference in §§1–4 resolves to its source. **The §5 corrections were applied in the same sitting: plan v2.5 → v2.6.** No erratum issued.

---

*v0.4 · D-B2-1 mirror applied 30 July 2026 · D-W8 erratum applied 26 July 2026 · review incorporated 25 July 2026 · executes the from-scratch ruling (elicitation v0.3 §7/§11) · inventory: 18 sheets, 6 batches · template: 8 sections, catalogue entry = metadata + pre-pinned Q2+ contract · consumed by: every Wave-2 batch conversation (standing prompt §4) · decisions D-W1–D-W9 locked (§6) · plan corrections applied → plan v2.6*
