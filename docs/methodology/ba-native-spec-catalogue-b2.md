# Geniusee Technique Catalogue — Batch B2
### BA-Native Spec · Wave 2 · Stakeholders & Context breadth · v0.2 — review incorporated (26 July 2026)

**What this is:** sheets T-04–T-07 of the 18-sheet catalogue (sequencing plan §1), authored to the §2 uniform template in the pinned within-batch order: personas → context → constraints → competitive. B2 completes the two root-adjacent aspects: T-04 rides B1's fresh register context (charters enrich register entries) and pins the transformation-ready charter shape T-12 (B4) consumes — the wave's first cross-batch dependency; T-06 and T-07 seed B3 (AT-VI-3 reads constraint rows; AT-VI-2 reads Unlike entries).

**Rulings in force (restated once):** every sheet authored from scratch; presale skills are reference designs to mine, never components (elicitation v0.3 §7/§11). No ★ sheet exists in this batch — all four follow the elicitation-§7.1 no-reference pattern. Micro-examples stay in the appointment-booking world at its **pre-RO-1 state** (catalogue-b1 convention): Specialists self-publish availability, no Clinic Admin yet. Prior-batch sheets (T-01–T-03, catalogue-b1 v0.2) are cited, never restated. Decisions D-B2-1…D-B2-4 are locked (review record below); the locked text stands inline at each sheet.

---

## T-04 · Persona charters
Band 1 · serves: Stakeholders (enrichment — typically BA-elected, orchestrator §6.1 rule) · class: Context · target: #6 personas (transformation-ready) · ★ —

### 1. Purpose & BABOK grounding
Enriches register populations with human context — goals, behaviors and environment, frustrations, and the concrete activities a population performs around the system — so framing, communication, and later story judgment work from lived pictures rather than population labels. Strictly context (plan §4.6): a persona never travels into the build as authorization; every charter is authored **transformation-ready** — the pinned contract in §5 is what the persona→role transformation (T-12, B4, per plan §3's chain and D-W3) reads. The decision this technique lets the BA make: which populations deserve charters, and that each charter is faithful to its register entry. BABOK: 10.43 Stakeholder List/Map/Personas · 4.3 Confirm Elicitation Results. House: plan §4.6 (personas-never-authorization); sequencing plan D-W3 (transformation home = T-12; this sheet pins the shape); orchestrator §6.1 (enrichment rule); contract CC-XA-02 wording.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Stakeholders — enrichment; never threshold ground (D-B2-1, locked: D-W7's polymorphic field read once more — an enrichment serve carries no-hole trigger semantics). |
| Evidence triggers | **None at threshold grade — deliberately.** No AT criterion demands personas, so the framework's own initiative stops short of this sheet (§6.1: suggestion is evidence-grounded; a suggestion that cannot name its hole must not be emitted). Entry paths: **BA election** into an open aspect's composed plan (Q2 — typically Stakeholders while B1's register context is fresh, plan §3 B2 rationale; any open aspect is legal, arrival being ungated) · **listing on an explicit BA ask** for enrichment options (§6.1's enrichment-on-ask clause). |
| Skip-if | Always skippable — charter absence is a legal end state (AT-RQ-2's persona clause is conditional: "if personas exist"). Redundancy: the elected populations already carry current charters. |
| Depth | Elicits at charter grade: per elected population — goals · behaviors & environment · frustrations (`→ P-n` only where the material states the link) · system-facing activities at capability level (verb + object). Must NOT state permissions or access rules (T-12 governance ground — the persona→role principle applied at authoring time: an access expectation surfacing here is a routed governance finding, never charter content) · define roles or role names (T-12) · descend into journey step maps (T-13) or story/AC drafting (Tier-2 ground) · accrete demographic color that informs no decision. |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Persona charters — one per elected register population, each transformation-ready per the pinned contract (§5, D-B2-2 — locked): Persona name · Details (register population) · Goals · Behaviors & environment · Frustrations · System-facing activities · Source |
| Artifact class | Context (spec-anchored — Q7; joins the CC-H-01 estate at arming once the file exists) |
| Destination file | `.specify/memory/personas.md` (D-B2-3, locked) |

### 4. Procedure
1. **BA act:** elect T-04 into an open aspect's composed plan (P-O2 — re-composition is legal while the aspect is `open`, §6.2) and name the populations to charter; invoke (P-O3).
2. **Framework act:** pre-draft one charter per elected population from `stakeholders.md`, `canvas.md`, and presale material/transcripts on hand; every line cited or marked (principle 3); `→ P-n` frustration links written only where the material states them, never inferred.
3. **Framework act:** remaining holes become questions, each destination-tagged to a charter field (principle 2 — a question serving no field is illegal; charter grade bounds the set, no numeric cap needed).
4. **BA act:** answer or edit; rule each charter **faithful to its register entry** — a charter enriches the register row it details, never rivals the cast list.
5. **Framework act:** boundary sweep — a drafted line stating an access rule or role definition is extracted as a proposed **governance finding** (elicitation §3.5 routing: `roles-permissions.md` — a governance change, proposed, never silently written); a charter describing a population absent from the register is a register gap → proposed register edit. Contradiction asymmetry (T-03 step 5's pattern): while the hosting aspect is still `open`, a conflict with its own content is ordinary correction; a finding contradicting **cleared** ground — the register or canvas Customers after Stakeholders clears — is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `personas.md`; log the run `fulfilled`. Enrichment feeds no evidence-table row — the §7.4 refresh runs and changes nothing, by design.

### 5. Output template & micro-example
```markdown
# Personas — <project>

Transformation contract (D-B2-2, locked — read by T-12, plan §3 chain):
TC-1 — Details: exactly one register population per charter, resolving to
       a `stakeholders.md` entry.
TC-2 — System-facing activities: capability-level lines (verb + object);
       T-12 reads them as candidate role-and-action evidence — nothing
       else in a charter is transformation input.
TC-3 — Namespace: persona names are charter-local human forenames,
       disjoint from role names, register populations, and register
       individuals; a persona name is never used as an actor anywhere
       (CC-XA-02's screened set = this file's names).

## <Persona name> — details: <register population>
| Field | Content |
|---|---|
```
Micro-example — one Client charter (pre-RO-1 facts):

**Marta — details: Clients**

| Field | Content |
|---|---|
| Goals | Book a Specialist in the evening without phoning; cancel without calling the clinic |
| Behaviors & environment | Books after work from a phone; gives up after two unanswered calls `[kickoff notes]` |
| Frustrations | Daytime calls to the clinic go unanswered → P-1 `[canvas: Problems P-1]` |
| System-facing activities | Browse a Specialist's published Availability · Book an available Slot · Cancel own Appointment |
| Source | register: Clients · kickoff notes · canvas P-1 |

Continuity: the canonical E-03 timeline runs **charter-free** — the composed Stakeholders plan holds two techniques and adds nothing (orchestrator §12.1), and AT-RQ-2's persona clause is never exercised there (§12.2). This example shows the charter a BA election would have produced from the same pre-RO-1 facts; the world's canonical artifacts are unchanged by it. The evening pain in Goals/Behaviors is the belief the 2026-07-14 call later confirms (elicitation §8.2 §1's "call confirmed evenings/weekends are the worst window").

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-2 (persona→role principle clause) — **activated, never cleared, by this output:** once `personas.md` exists, Requirements first pass demands the constitution's persona→role principle and zero persona-as-role usage anywhere; charter absence leaves the clause dormant |
| Health hooks | CC-H-01 — `personas.md` joins the spec-anchored estate at arming |
| Consumer hooks | CC-XA-02 — the persona-name set this file defines is the checker's screening surface: no name from here may appear as an actor in any spec (M-checked; non-waivable, contract §8) |

Cross-layer consumers, on the record: **T-12 (B4)** — the persona→role transformation reads TC-1/TC-2 and nothing else (plan §3's chain; D-W3) · **T-15 constitution (B5)** carries the principle AT-RQ-2 and CC-XA-02 lean on · Tier-2 story drafting never reads charters for actors — roles come verbatim from `roles-permissions.md` (elicitation §7.2) · deliberately absent from both elicitation context stacks (§3.2, §5.2): charters inform BA judgment and Band-1 framing, not per-feature drafting.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-04`; contract check at P-O3. Inputs loaded: `stakeholders.md` first · `canvas.md` · presale material and transcripts · `glossary.md`. Interaction: population election → pre-draft → destination-tagged questions → BA faithfulness rulings → boundary sweep (governance and register findings extracted as proposed batches) → write. Outputs written: `.specify/memory/personas.md`, plus routed batches where the sweep found any. §§2–5 above fix the method and the transformation contract; Phase 2 adds transcript mining toward charter fields and a TC-3 namespace check at write time.

---

## T-05 · Context & landscape mapping
Band 1 · serves: Context · class: Context · target: #4 context · ★ —

### 1. Purpose & BABOK grounding
Puts the ground the solution lands on onto paper: the systems that exist today and the organizational landscape, at helicopter level — so Vision and Solution work lean on stated reality rather than assumed greenfield, and every later integration or NFR conversation starts from a named landscape. Deliberately split from constraints (D-W2): this sheet describes what exists; what binds is T-06's ground — a landscape fact that binds the solution is routed there, and the landscape keeps the description. The decision this technique lets the BA make: the landscape picture is faithful and complete at helicopter grade — including the explicit, sourced greenfield ruling where systems genuinely do not exist (AT-CX-1). BABOK: 6.1 Analyze Current State · 10.32 Organizational Modelling · 10.24 Interface Analysis · 10.18 Document Analysis. House: plan §4.4; Q1a (Context, the new aspect); sequencing plan D-W2; orchestrator §2.1 (Context artifact homes).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Context |
| Evidence triggers | AT-CX-1 — `context.md` absent or stubbed · existing systems stated nowhere and no sourced greenfield line stands · the organizational landscape is unstated · a system named elsewhere (canvas Third-Party Connections; a §3.5 routed arrival) has no landscape entry. |
| Skip-if | AT-CX-1 reads met in the current evidence table (e.g., a landscape carried from a prior engagement, confirmed current at Frame). Depth beyond helicopter grade — system inventories, org charts — only on BA ask (§6.1). |
| Depth | Elicits at helicopter grade: per system — name · role today · expected disposition where the material states it; org landscape — structure and operating model in short cited lines, at project relevance. Must NOT descend into integration specifics — directions, payloads, failure expectations (brief §4 and spec Integration ground, CC-IN) · constraint rows (T-06 — D-W2's split) · entities and relations (T-11) · competitor entries (T-07) · the cast list (T-03 register ground: people and rights there, organizational shape here). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Context & landscape — Existing-systems table (System · Role today · Disposition, where stated · Source) with scoped absence lines where a class is genuinely empty; Organizational landscape as short cited lines. Full greenfield case: the table is replaced by the sourced `greenfield — no existing systems` line (AT-CX-1's form) |
| Artifact class | Context (spec-anchored — Q7) |
| Destination file | `.specify/memory/context.md` |

### 4. Procedure
1. **BA act:** open Context (T1 — Stakeholders cleared or waived); compose the plan (P-O2); invoke T-05 (P-O3).
2. **Framework act:** pre-draft from `canvas.md` (Third-Party Connections — each intended connection implies a today-system to record; the Context/Constraints one-liners), presale material, kickoff notes, and any routed arrivals already in the file (arrival is never gated — §2.2); cite-or-mark per line (principle 3).
3. **Framework act:** holes become destination-tagged questions — a systems row, an org line, or the greenfield ruling (principle 2).
4. **BA act:** answer or edit; rule the greenfield or scoped-absence lines — sourced, never assumed (AT-CX-1: "with its source").
5. **Framework act:** boundary routing — a landscape fact that binds the solution is proposed to `constraints.md` (elicitation §3.5 row: new constraint; T-06's ground), the landscape row keeping the descriptive side. Contradiction asymmetry (T-03 step 5's pattern): a finding contradicting cleared ground — register, canvas Customers — is a reopen signal (§3.5 step 4 → P-O6); within Context's own still-open content, ordinary correction.
6. **Framework act:** write `context.md`; refresh the Context evidence table (§7.4) — the AT-CX-1 row updates; confirmation is proposed only when the whole aspect's table reads met.

### 5. Output template & micro-example
```markdown
# Context & Landscape — <project>

## Existing systems
| System | Role today | Disposition (where stated) | Source |
|---|---|---|---|
<rows; scoped absence lines beneath — or, full greenfield:
`greenfield — no existing systems — <source>`>

## Organizational landscape
- <short cited lines>
```
Micro-example — Context first pass (pre-RO-1):

| System | Role today | Disposition (where stated) | Source |
|---|---|---|---|
| Specialists' external calendars | every Specialist's working schedule lives in a personal calendar; providers not yet named → open | retained, not replaced — presale-stated, unconfirmed | canvas: Third-Party · Context/Constraints |
| Phone lines at clinics | today's booking channel; ~30% of calls go unanswered → P-1 | superseded as the primary booking channel → O-1 | canvas: Problems P-1 · kickoff notes |

No booking software exists today — nothing to migrate on the booking side `[kickoff notes]` (the AT-CX-1 greenfield form, scoped).

Organizational landscape:
- Single clinic network; central operations under the COO (sponsor) `[canvas: Customers · kickoff notes]`
- Specialists are affiliated per clinic; clinics take bookings independently, with no shared clinic-side IT `[kickoff notes]`

Continuity: who publishes availability is deliberately stated only on the canvas (Core Functions) — the exact line RO-1 later corrects (orchestrator §12.3); the landscape carries the system facts that survive that correction. "Providers not yet named → open" is OQ-2's seed (elicitation §8.2), and the unconfirmed calendar disposition is the binding candidate the constraints sheet (T-06) takes up.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-CX-1 — systems and org landscape at helicopter grade, or the sourced greenfield line |
| Health hooks | CC-H-01 — `context.md` in the spec-anchored estate from arming |
| Consumer hooks | — (no Scope-F assertion reads `context.md` directly) |

Cross-layer consumers, on the record: Tier-1 kit inputs and Tier-2 context stack row 6 load it — "integration and NFR reality" (elicitation §3.2, §5.2) · the §3.5 routing row lands each new project-wide external system here · brief §4 External-Systems entries trace back to landscape rows.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-05`; contract check at P-O3. Inputs loaded: `canvas.md` (Third-Party Connections, Context/Constraints first) · presale material and kickoff notes · `stakeholders.md` · `glossary.md` · current `context.md`. Interaction: pre-draft → destination-tagged questions → greenfield/absence rulings → boundary routing to `constraints.md` → write. Outputs written: `.specify/memory/context.md`, plus routed batches where boundary routing found binds. §§2–5 above fix the method; Phase 2 adds multi-format landscape mining and the constraints-vs-landscape routing assist.

---

## T-06 · Constraints elicitation
Band 1 · serves: Context · class: Context · target: #5 constraints & limitations · ★ —

### 1. Purpose & BABOK grounding
Elicits the binding rules — technical, business, regulatory — class by class, to the silence-fails discipline: every class ends with confirmed rows or a sourced `none identified` basis, so downstream vision and spec work cannot build on an unexamined absence. What distinguishes it from landscape mapping (D-W2): class-driven probing for what **binds**, not description of what exists — a constraint is imposed, and its imposer is its source. The decision this technique lets the BA make: which candidates are confirmed constraints, which stand as assumptions, and what basis closes an empty class. BABOK: 10.18 Document Analysis · 10.25 Interviews · 7.2 Verify Requirements (complete) · 4.3 Confirm Elicitation Results. House: plan §4.5; sequencing plan D-W2; AT-CX-2 wording; elicitation §3.2.C (the kit's assumption register — the Assumed rows' consumer; D-B2-4, locked).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Context |
| Evidence triggers | AT-CX-2 — a class (technical · business · regulatory) carries neither a confirmed row nor a `none identified — <basis>` line · a swept candidate stands unruled (not yet in the table) · a canvas §13 one-liner has no `constraints.md` row behind it (T-01's split: detail owned here from the Context aspect on). |
| Skip-if | AT-CX-2 reads met in the current evidence table — every class shows a Confirmed row or its none-identified basis. Enrichment beyond the threshold (exhaustive constraint inventories) only on BA ask (§6.1). |
| Depth | Elicits at constraint grade: one binding statement per row — classed, statused, sourced. Must NOT expand into NFR budgets with metrics and targets (T-14 governance / spec NFR ground — a constraint says "existing calendars stay in use", never "sync completes within N seconds") · business rules with formulas or thresholds (spec BR ground) · legal analysis beyond naming the binding regime and its bite · solution decisions dressed as constraints (a choice is Vision/Solution ground; a constraint has an imposer). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Constraints & limitations — three numbered class sections (1 Technical · 2 Business · 3 Regulatory), each a table: Constraint · Status (`Confirmed \| Assumed` — D-B2-4, locked) · Source — or the single line `none identified — <basis>`; canvas §13 keeps the one-liner summaries (T-01's split) |
| Artifact class | Context (spec-anchored — Q7) |
| Destination file | `.specify/memory/constraints.md` |

### 4. Procedure
1. **BA act:** under the composed Context plan (P-O2), invoke T-06 (P-O3).
2. **Framework act:** sweep — candidates from canvas §13 one-liners, `context.md` dispositions, presale material, and rows already in the file (arrival is never gated, §2.2 — routed constraints may pre-date any run); each candidate classed, with its source.
3. **Framework act:** class probes into holes only (principle 2; destination = a class row or its none-identified ruling): technical — systems retained or replaced · platform and hosting mandates · data residency; business — launch windows · budget and contract commitments · policy mandates; regulatory — personal-data regimes · sector rules · accessibility mandates. A probe an existing row answers is illegal (Guard-1 logic at Band 1).
4. **BA act:** rule each candidate — **Confirmed** (imposer on record) · **Assumed** (implied by material, no stakeholder confirmation — a disposition, not a limbo: the row is real context; D-B2-4, locked) · rejected (not binding; dropped, run log noting why) — and rule each empty class's `none identified — <basis>`.
5. **Framework act:** routing and asymmetry — canvas §13 summaries updated by proposed edit where rows change the one-liners (§3.5 discipline); a constraint contradicting cleared ground — register, canvas Customers — is a reopen signal (§3.5 step 4 → P-O6); within still-open Context content, ordinary correction (T-03 step 5's pattern).
6. **Framework act:** write `constraints.md`; refresh the Context evidence table (§7.4) — AT-CX-2 per class; confirmation is proposed only when the whole aspect's table reads met.

### 5. Output template & micro-example
```markdown
# Constraints & Limitations — <project>

## 1. Technical
| Constraint | Status | Source |
|---|---|---|
<rows — or the single line `none identified — <basis>`>

## 2. Business
<same shape>

## 3. Regulatory
<same shape>
```
Micro-example — Context first pass (pre-RO-1):

**1. Technical**

| Constraint | Status | Source |
|---|---|---|
| No software installation at clinics — clinics run standalone, with no clinic-side IT staff | Confirmed | kickoff notes · Olena, 2026-07-09 |
| Specialists' existing calendars stay in use — retained, not replaced | Assumed | canvas: Context/Constraints (presale) |

**2. Business**

| Constraint | Status | Source |
|---|---|---|
| Launch tied to the autumn season | Confirmed | sponsor call — routed 2026-07-08 |

**3. Regulatory**

| Constraint | Status | Source |
|---|---|---|
| Client personal data is processed — national personal-data-protection law applies; no medical-record data in scope | Confirmed | Olena, 2026-07-09 |

Continuity, three threads: **(i)** the autumn row pre-dates this run — arrival is never gated; it landed from the Stakeholders-plan call while Context was still `untouched` (orchestrator §12.1). **(ii)** the Assumed calendar row is T-05's presale-stated disposition in binding form — and exactly what the E-03 Tier-1 kit lifts as assumption A1 (elicitation §8.1: "impact if wrong: integration scope and slicing change materially"); the 2026-07-14 call confirms it and the routing batch flips the Status (elicitation §8.2 §9's "A1 confirmed → constraints.md"). **(iii)** the numbered class sections are what the kit-baseline citation form `[constraints.md §2]` (elicitation §3.2.A) resolves against — §2 = Business.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-CX-2 — per class, ≥ 1 Confirmed row or the `none identified — <basis>` line; silence fails |
| Health hooks | CC-H-01 — `constraints.md` in the spec-anchored estate from arming |
| Consumer hooks | — (no Scope-F assertion reads `constraints.md` directly) |

Cross-layer consumers, on the record: **AT-VI-3 (T-09, B3)** reads the Confirmed rows once against the vision statement — this batch's first B3 seed · Tier-1 kit baselines cite rows (`[constraints.md §2]`, elicitation §3.2) and kit part C mines Assumed rows as the pre-structured seed of the assumption register (D-B2-4, locked) · Tier-2 context stack row 6 loads it ("integration and NFR reality") · canvas §13 summary sync keeps AT-CX-3's element half current (T-01's split).

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-06`; contract check at P-O3. Inputs loaded: `canvas.md` §13 · `context.md` · current `constraints.md` · presale material. Interaction: sweep → class probes into holes → BA rulings (Confirmed / Assumed / rejected / none-identified) → canvas-summary batch and routing → write. Outputs written: `.specify/memory/constraints.md`, plus the canvas batch where summaries change. §§2–5 above fix the method; Phase 2 adds a curated class-probe library, Status-flip handling when a later routing batch confirms an Assumed row (the elicitation §8.2 path), and the canvas-sync assist.

---

## T-07 · Competitive analysis
Band 1 · serves: Context + Vision (dual-aspect) · class: Context · target: #7 competitive analysis · ★ —

### 1. Purpose & BABOK grounding
Names the alternatives the product is unlike — direct competitors, adjacent tools, and the status quo — and records, per entry, the differentiation-relevant deltas keyed to canvas problems and objectives, so the vision statement differentiates against named targets instead of a vague field. Dual-aspect by design: the landscape of alternatives is Context reference; the keyed deltas are Vision's raw material (AT-VI-2's "against ≥ 1 named Unlike entry"). The decision this technique lets the BA make: which alternatives matter at this grade, and which deltas are real enough to differentiate on — or that no market exists (`N/A — <reason>`). BABOK: 10.5 Benchmarking & Market Analysis · 10.18 Document Analysis · 4.3 Confirm Elicitation Results. House: plan §4.7; Q1a / plan §3 (Competition→Unlike anchors Context; Our Solution anchors Vision); AT-CX-3 and AT-VI-2 wording.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Context + Vision — the catalogue's one dual-aspect sheet; suggestible under either plan, each suggestion naming its own hole (§6.1). |
| Evidence triggers | AT-CX-3 (Context plan) — canvas Competition→Unlike empty or stubbed, with no `N/A — <reason>` ruling. AT-VI-2 (Vision plan) — differentiation work lacks a named target: Our Solution is due but zero Unlike entries exist, or existing entries carry no deltas to differentiate on. |
| Skip-if | Canvas Unlike filled with entries this artifact backs, or an explicit `N/A — <reason>` stands (AT-CX-3's own escape — e.g., an internal tool with no market; the reason is the ruling) — and no AT-VI-2 target-side hole remains. Deeper teardowns only on BA ask (§6.1). |
| Depth | Elicits at positioning grade: per entry — alternative · category · what it covers · where it falls short against named `P-n`/`O-n` · source. Must NOT descend into feature-matrix exhaustiveness or pricing/UX teardowns (enrichment, BA ask) · author the Our Solution statement (T-09 ground, B3 — this sheet supplies targets and deltas, never the statement) · market sizing or business-case math (presale/Value ground) · constraint rows (a competitor-imposed bind — an exclusivity clause — routes to `constraints.md`). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Competitive analysis — one entry per named alternative, the status quo screened always: Alternative · Category · Covers · Falls short (`→ P-n / O-n`) · Source; plus the canvas summary write — Unlike names (+ URLs where known) to canvas §10 (the T-01 split: canvas holds names, this artifact holds the analysis) |
| Artifact class | Context (spec-anchored — Q7) |
| Destination file | `.specify/memory/competitive-analysis.md` (D-B2-3, locked) · canvas §10 summary via proposed-edit batch |

### 4. Procedure
1. **BA act:** invoke under the Context plan against AT-CX-3 — or under the Vision plan against AT-VI-2 where the target side is still missing there (both entries legal; P-O3).
2. **Framework act:** sweep — candidates from presale material, canvas Unlike seeds, and stakeholder mentions in transcripts; **the status quo is always screened as an alternative** — the strongest competitor is often the current way of working.
3. **Framework act:** pre-draft entries, cite-or-mark (principle 3); deltas written only where a `P-n`/`O-n` link is real — a delta that names no problem or objective is decoration, not differentiation ground.
4. **BA act:** rule the set — which alternatives matter at this grade; confirm or edit deltas; rule `N/A — <reason>` where a market genuinely does not exist.
5. **Framework act:** canvas batch — the Unlike summary (names + URLs) proposed to canvas §10 (§3.5 discipline). Cross-routing: a competitor-imposed bind → `constraints.md`; a finding contradicting cleared ground → reopen signal (§3.5 step 4 → P-O6); within still-open Context or Vision content, ordinary correction (T-03 step 5's pattern).
6. **Framework act:** write; refresh the hosting aspect's evidence table (§7.4) — AT-CX-3 under Context; under Vision, the refresh shows AT-VI-2's named-target precondition satisfied — the criterion itself reads met only when Our Solution states the differentiation (T-09 ground).

### 5. Output template & micro-example
```markdown
# Competitive Analysis — <project>
| Alternative | Category | Covers | Falls short | Source |
|---|---|---|---|---|
```
Micro-example — Context first pass (pre-RO-1):

| Alternative | Category | Covers | Falls short | Source |
|---|---|---|---|---|
| Phone booking (status quo) | current way of working | booking and cancellation via clinic phone lines | ~30% of calls go unanswered → P-1; no self-serve channel outside clinic hours → O-2 | canvas P-1 · kickoff notes |
| MedSlot | booking marketplace | clinics list openly; clients book across networks | the network's own channel and client relationship are ceded to the marketplace → O-1; per-booking commission | kickoff notes (Olena named it) |
| Calendar-link scheduling tools | generic scheduling | single-person booking links | no clinic or network structure; no cancellation-policy handling → O-1 | kickoff notes |

Canvas batch (proposed → §3.5): §10 Competition.Unlike ← "Phone status quo · MedSlot · calendar-link scheduling tools".

Continuity: T-09 (B3) authors Our Solution against these entries — AT-VI-2's "≥ 1 named Unlike entry" resolves to this table, and the deltas keyed `→ P-1 / O-1 / O-2` are its differentiation raw material. The status-quo row's P-1 delta is the same fact feature 004's Overview later cites (standard §14), and its off-hours clause is the belief the 2026-07-14 call confirms (elicitation §8.2 §1).

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-CX-3 — the Unlike half: named entries (this artifact's canvas summary) or the `N/A — <reason>` ruling; the Context/Constraints-element half rides T-01's framing and T-06's summary sync · AT-VI-2 — target side only: supplies the named entries and deltas the differentiation must name; the statement itself clears it (T-09, B3) |
| Health hooks | CC-H-01 — `competitive-analysis.md` in the spec-anchored estate from arming |
| Consumer hooks | — (no Scope-F assertion reads this artifact directly) |

Cross-layer consumers, on the record: **T-09 (B3)** authors Our Solution against these entries — the batch's second B3 seed · canvas §10/§11 are the AT surfaces this artifact backs · deliberately absent from both elicitation context stacks (§3.2, §5.2) — differentiation is Band-1 vision ground, not per-feature context; a feature needing a competitive fact cites the canvas's Our Solution line.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-07`; contract check at P-O3. Inputs loaded: `canvas.md` (Unlike, Problems, Objectives first) · presale material and transcripts · `context.md`. Interaction: sweep including the status quo → pre-draft with keyed deltas → BA set ruling or `N/A` → canvas batch + cross-routing → write. Outputs written: `.specify/memory/competitive-analysis.md`, plus the canvas §10 batch. §§2–5 above fix the method; Phase 2 adds optional BA-directed web retrieval of public competitor material, URL capture, and the canvas-sync assist.

---

## Review record (v0.1 → v0.2)

Four decisions ruled by the BA Lead, 26 July 2026 — **all recommendations accepted as stated.** The locked text stands inline at each sheet; the table below stands as the rulings' record.

| # | Decision | Ruling (adopted as recommended) | Basis |
|---|---|---|---|
| **D-B2-1** | Evidence-trigger semantics for an enrichment sheet — the §2 template requires triggers naming AT holes; T-04 (the inventory's one enrichment serve) fills none | **State the no-hole fact as the trigger cell:** framework-initiated suggestion never fires (§6.1 — a suggestion that cannot name its hole must not be emitted); entry paths are BA election into any open aspect's composed plan and listing on an explicit BA ask. Extends D-W7's polymorphic reading to the enrichment case; mirror candidate for the sequencing plan's §2 field note at its next bump. | Orchestrator §6.1; D-W7; plan §3 B2 rationale |
| **D-B2-2** | The transformation contract — which charter fields does T-12's persona→role transformation read, and under what rules? | **Three clauses, pinned in T-04 §5:** TC-1 exactly one register population per charter · TC-2 System-facing activities (capability lines) as the sole transformation input · TC-3 disjoint persona namespace, never used as an actor. Rationale: the transformation needs a role-candidate anchor (the population) and action evidence (the activities) — and nothing else: goals, behaviors, frustrations are human context that must not leak toward authorization (plan §4.6). TC-3 makes CC-XA-02 mechanically checkable — the screened set is this file's names. B4's T-12 builds on these clauses; ratifying them here is what makes the wave's first cross-batch dependency safe. | Plan §4.6; D-W3; CC-XA-02 (M, non-waivable) |
| **D-B2-3** | Destination files for artifacts #6 and #7 — plan §7's memory list ends in an ellipsis; neither file is named anywhere in the corpus | **`.specify/memory/personas.md` · `.specify/memory/competitive-analysis.md`** — the established memory-estate pattern (artifact noun, kebab-case), inside CC-H-01's glob, matching every named sibling (glossary, stakeholders, context, constraints, domain-model). No alternative carries an argument. | Plan §7; orchestrator §2.1; CC-H-01 |
| **D-B2-4** | Constraint Status column — how does an identified-but-unconfirmed constraint live in `constraints.md`? | **Two-value Status column: `Confirmed · Assumed`.** AT-CX-2's "confirmed constraint" reads `Confirmed` mechanically; `Assumed` rows are durable, visible context — and the pre-structured mining surface for the Tier-1 kit's assumption register (elicitation §3.2.C: "assumptions the context implies but no stakeholder confirmed" — an Assumed row is exactly that, with class and source attached). Alternative — no column, unconfirmed candidates as `[NEEDS CLARIFICATION]` markers — rejected: an assumption is durable context a later call checks, not a transient authoring gap; markers are gap devices. The E-03 calendar-retention line is the worked case: Assumed at Band 1 → kit assumption A1 → Status flipped by the 07-14 routing batch (elicitation §8.1–8.2). | AT-CX-2; elicitation §3.2.C, §8.1–8.2 |

**Conflict scan — against the five spine documents (standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.2 · orchestrator v0.2) and prior batches (catalogue-b1 v0.2).** Checked: AT-CX-1/-2/-3, AT-VI-2/-3, AT-RQ-2 wording (orchestrator §3.3) · CC-XA-02 and CC-H-01 wording, CC-XA-02's non-waivable status (contract §5–§6, §8) · destination paths inside CC-H-01's glob · the T-03 register shape T-04 enriches (catalogue-b1) · micro-example continuity: pre-RO-1 state held — the self-publish claim confined to the canvas, no Clinic Admin, the T-05 org lines avoiding the line RO-1 corrects; the constraint timeline reconciling orchestrator §12.1 (autumn row routed 07-08, pre-existing at the T-06 run) with elicitation §8.1–8.2 (calendar retention Assumed at Band 1 → kit A1 → confirmed 07-14). Four reconciliations on record, none a contradiction: **(a)** T-06's numbered class sections give elicitation §3.2's `[constraints.md §2]` citation form a resolvable target — reconciliation by template design, not an erratum. **(b)** T-04's references to T-12 name a future sheet: sanctioned by plan §3's grouping constraint ("T-04's transformation-ready charter shape is the contract T-12 consumes") — the dependency points backward from B4 to B2; the sequencing invariant (no citing future sheet *content*) is intact, as is B1's own precedent of naming future sheet IDs at inventory identity. **(c)** T-04's micro-example is framed as a would-have-produced charter because the canonical timeline is charter-free (orchestrator §12.1) — the world's facts are used, its canonical artifacts untouched. **(d)** competitive analysis and personas are deliberately absent from both elicitation context stacks (§3.2, §5.2) — recorded as boundary lines in T-04/T-07 §6, not gaps. One additive extension, flagged for the record: **D-B2-1 extends the §2 template's trigger semantics to the enrichment case** — no spine or plan statement contradicts it (orchestrator §6.1 is its basis); mirror candidate for the sequencing plan §2 at its next version bump. **No spine contradiction found; no erratum issued.**

---

*v0.2 · review incorporated 26 July 2026 · sheets T-04–T-07 of 18 · authored to sequencing-plan §2 template (D-W9 order: contract before procedure) · no ★ in batch — all four to the elicitation-§7.1 no-reference pattern · cross-batch pin: the T-04 transformation contract (TC-1…TC-3, D-B2-2) for T-12 (B4) · B3 seeds: constraints Confirmed rows → AT-VI-3 · Unlike entries + keyed deltas → AT-VI-2 · decisions D-B2-1…D-B2-4 locked (review record above) · pending mirror at next sequencing-plan bump: D-B2-1 → §2 · consumed by: batches B3–B6 (cite, never restate) · next: B3 — canvas-internal aspects (T-08…T-10), standing batch prompt §4, new conversation*
