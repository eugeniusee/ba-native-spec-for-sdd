# Geniusee Technique Catalogue — Batch B5
### BA-Native Spec · Wave 2 · Requirements governance & boundary · v0.2 — review closed (29 July 2026)

**What this is:** sheets T-14–T-16 of the 18-sheet catalogue (sequencing plan §1), authored to the §2 uniform template in the pinned within-batch order: design & UX standards → constitution → global out-of-scope. B5 is the referenced-before-referencer batch: the constitution references the roles model (catalogue-b4 T-12) and the design standards (T-14, this batch), so it is authored after both; out-of-scope closes the Band-1 boundary last, with the full solution surface (catalogue-b3 T-10) and roadmap-adjacent expectations visible (plan §3, B5 rationale). Two of the three sheets are the Governance class's remaining pair (#15, #13); the third is the Context-class fence (#10) — class mix again, dependency and rationale trump class in batching (the B4 precedent).

**Rulings in force (restated once):** every sheet authored from scratch; presale skills are reference designs to mine, never components (elicitation v0.3 §7/§11). No ★ sheet exists in this batch — all three follow the elicitation-§7.1 no-reference pattern. Micro-examples stay in the appointment-booking world at its **pre-RO-1 state** (catalogue-b1 convention): Specialists self-publish availability, no Clinic Admin yet, no `personas.md`. Prior-batch sheets (T-01–T-03, catalogue-b1 v0.2 · T-04–T-07, catalogue-b2 v0.2 · T-08–T-10, catalogue-b3 v0.2 · T-11–T-13, catalogue-b4 v0.2) are cited, never restated. Decisions D-B5-1…D-B5-5 stand ruled (2026-07-29, all recommendations accepted as written; review record in the final section — inline D-B5-n citations point there).

---

## T-14 · Design & UX standards
Band 1 · serves: Requirements · class: Governance · target: #15 design & UX standards · ★ —

### 1. Purpose & BABOK grounding
Seeds the global design & UX governance surface: the product-wide budgets and conventions every feature spec references and deltas against, never restates (CC-NF-03; standard rule 5). This file is the governance half of the split catalogue-b4 already fences from both sides — "T-14 governance / `/plan` ground" (T-12 §2 on permission surfaces, T-13 §2 on screen flows): the *global standard* lives here; the concrete screens, components, and layouts stay `/plan`'s. Its budgets are what the CC-NF-03-compliant spec form points at — gate §14.1's canonical fix ("`N/A — covered by the global Design & UX accessibility budget`") resolves to a named row of this file. The decision this technique lets the BA make: which experience commitments are product-wide governance — stated once, referenceable, delta-able — and which are feature or `/plan` ground. BABOK: 10.30 Non-Functional Requirements Analysis · 10.18 Document Analysis · 4.3 Confirm Elicitation Results. House: plan §4.15; CC-NF-03 and CC-H-06 wording; gate §14.1's canonical reference form; D-B5-1…D-B5-3.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-1, via the constitution-reference clause (D-B5-3) — design/UX ground stands in Band-1 evidence (a delivery-form commitment on canvas §6, an accessibility bind or sponsor ruling, brand/design-system material, a global experience expectation in objectives or transcripts) and #15's home is absent or stubbed at seed grade · the composed Requirements plan includes T-15 and the constitution's draft reference set would name a design file that does not exist — CC-H-06's pre-arming image, caught at planning · a §3.5-routed design/UX finding stands unincorporated. |
| Skip-if | AT-RQ-1's design slot reads met — the file present, seeded, stub-free — or the conditionality branch stands ruled (D-B5-3): no design/UX ground in evidence, the constitution carries no design reference, the omission on the aspect record. Enrichment — a full design system, component-level standards — only on BA ask (§6.1), and the deeper surface is `/plan` ground regardless. |
| Depth | Elicits at global-standard grade: per budget — name · metric · target · condition · source (the standard-§7 NFR grammar lifted to governance, D-B5-2); per convention — one product-wide statement with its source or ruling. Must NOT author feature NFRs or feature deltas (spec ground — CC-NF-03's other half) · restate constraint rows as budgets (a constraint has an imposer and lives in `constraints.md` — catalogue-b2 T-06's boundary from the other side; a budget derived from one references it) · descend into screen flows, component specs, wireframes, or UI layouts (`/plan` ground; the catalogue-b4 split's other half) · invent industry-default budgets no evidence grounds — an ungrounded candidate is drafted and marked or asked, never silently seeded (principle 3). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Design & UX standards at seed grade: Global budgets table — named rows in name · metric · target · condition · source form, prose-name referenceable, no new line-ID family (D-B5-2) · UX & interaction conventions table · Visual identity & references section — each section populated with real content, or `open — no source material`, or `N/A — <reason>` (T-01's two-state convention) |
| Artifact class | Governance (spec-anchored — Q7; CC-H-06-checked once the constitution's reference lands; in the CC-H-01 estate from arming) |
| Destination file | `.specify/memory/design-standards.md` (D-B5-1) |

### 4. Procedure
1. **BA act:** under the composed Requirements plan (P-O2), invoke T-14 (P-O3) — before T-15 where both are planned, so the constitution's design reference resolves to an existing file at its own authoring (D-B5-3; the batch's referenced-before-referencer rationale, executed at runtime).
2. **Framework act:** ground sweep — design/UX evidence across the estate: canvas §6 Forms (delivery-form commitments), §9 Localization (presentation-relevant lines), objectives with experience claims, `constraints.md` rows with UX bite, transcripts and kickoff material, routed arrivals. Conditionality check first: if the sweep finds no design/UX ground, report exactly that and stop at the BA ruling — the omit branch (D-B5-3), recorded on the aspect evidence, never a file of empty headings.
3. **Framework act:** budget pre-draft — one named row per product-wide commitment the evidence grounds, in the D-B5-2 grammar, cite-or-mark per row; a target the evidence implies but no source states is drafted and marked for ruling, never silently seeded. Feature-shaped candidates (a threshold that binds one capability only) are surfaced as spec ground and left out — the depth fence applied at drafting.
4. **Framework act:** conventions and references pre-draft — product-wide interaction and language conventions with sources; brand/design-system material carried as references where supplied, `open — no source material` where not. Remaining holes become destination-tagged questions (principle 2).
5. **BA act:** rule — every budget row and convention is a governance ruling (the T-12 discipline: no row enters unruled); marked targets confirmed or dropped; each `N/A — <reason>` and each `open` ruled as such. A finding contradicting cleared ground — a budget fighting a Confirmed constraint row — is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `design-standards.md`; refresh the Requirements evidence table (§7.4). The file enters CC-H-06's checked set when T-15's reference lands and the gate's static core with it; from arming, edits fire the scoped run of gate §10.2's "constitution / governance files" row (CC-H-01 · CC-H-06) with voided-certification notices where the file is in a certified feature's `deps(F)`.

### 5. Output template & micro-example
```markdown
# Design & UX Standards — <project>
Global governance surface (plan §4.15). Feature specs reference budgets
and conventions here and add feature-specific deltas only (CC-NF-03) —
never restate.

## Global budgets
| Budget | Metric · target · condition | Source |
|---|---|---|
(named rows — D-B5-2; the budget name is the citation target,
gate §14.1's reference form)

## UX & interaction conventions
| Convention | Statement | Source |
|---|---|---|

## Visual identity & references
<brand / design-system references — or `open — no source material`
 or `N/A — <reason>`>
```
Micro-example — Requirements seed (pre-RO-1):

| Budget | Metric · target · condition | Source |
|---|---|---|
| Accessibility — Client-facing surfaces | WCAG 2.1 AA conformance · all Client-facing pages · at launch | Olena, 2026-07-09 |
| Mobile responsiveness — Client pages | page interactive · ≤ 3 s · mid-range phone on a mobile network | ruled 2026-07-10 — basis: phone-first commitment `[kickoff notes]` |

| Convention | Statement | Source |
|---|---|---|
| Phone-first Client surfaces | Client-facing pages are designed phone-first; desktop is secondary | canvas §6 Forms |
| Glossary-canonical interface copy | Interface text uses glossary-canonical terms — Appointment, Slot, Specialist — never synonyms | glossary discipline (#2) · kickoff notes (Client audience) |

Visual identity & references: `open — no source material`

Continuity, four threads: **(i)** the accessibility row is the exact global gate §14.1's canonical fix cites — feature 004's silent CC-NF-02 category is closed with "`N/A — covered by the global Design & UX accessibility budget; no feature-specific delta`", the CC-NF-03-compliant form pointing at this named row: seeded here, referenced there, the chain closed. **(ii)** the mobile budget is what feature NFR-001 (standard §7: availability search ≤ 2 s for 5,000 slots) sits beside as a feature-specific delta — CC-NF-03's add-deltas-only shape, shown from the governance side. **(iii)** the ruled mobile target demonstrates step 5's discipline: the phone-first ground is cited, the 3-second number is a BA ruling — no source stated it, so no silent seed. **(iv)** the `open` visual-identity slot is suggestion-engine ground, not a stub — the populated sections carry the seed (AT-RQ-1's "real initial content"), and the open slot stays visible for later brand material.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-1 — via the constitution-reference clause (D-B5-3): where the constitution references a design file, that file exists, seeded, stub-free at seed grade |
| Health hooks | CC-H-06 (M) — checked from the moment the constitution's reference lands: the referenced governance file exists and is stub-free · CC-H-01 — in the spec-anchored estate from arming |
| Consumer hooks | CC-NF-03 (A) — no spec NFR restates a global budget; deltas reference it. Enforcement-only by design (contract §9): the writer can't self-verify it; the gate reads spec+gov |

Cross-layer consumers, on the record: gate static-core member **via the constitution's reference** ("`constitution.md` + every governance file it references", gate §3) and a certification-manifest entry wherever read (gate §11.1) · scoped-run map row "constitution / governance files" → CC-H-01 · CC-H-06, with the voided-certification notice where in a certified feature's `deps(F)` (gate §10.2) · **deliberately absent from both elicitation stacks** (§3.2, §5.2) — budgets are gate-enforced ground, not drafting context; the CC-NF-03-compliant reference/delta form enters through the gate's fix lanes (gate §14.1 is the worked case) · the catalogue-b4 depth fences resolve here: T-12's permission-surface zone and T-13's screen-flow zone name this file as the governance side, `/plan` as the concrete side.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-14`; contract check at P-O3. Inputs loaded: `canvas.md` (§6 Forms, §9 Localization, §12 Objectives) · `.specify/memory/constraints.md` · `.specify/memory/context.md` · `glossary.md` · presale and kickoff material · current `design-standards.md`. Interaction: ground sweep with the conditionality check → budget pre-draft in the D-B5-2 grammar → conventions and references pre-draft → destination-tagged questions → BA rulings on every row → write. Outputs written: `.specify/memory/design-standards.md`, plus routed batches where the sweep finds cross-cutting ground. §§2–5 above fix the method and the row grammar; Phase 2 adds the conditionality report rendering, a budget-candidate probe set per experience class, and the feature-vs-global classification assist toward the depth fence.

---

## T-15 · Constitution
Band 1 · serves: Requirements · class: Governance · target: #13 constitution · ★ —

### 1. Purpose & BABOK grounding
Seeds the project constitution: the named, testable principles that bind everything downstream of the gate, plus the reference spine to the governance files carrying their detail — principles live here, detailed matrices live in the referenced memory files (plan §4.13; the plan-Q3 class split applied at file grain). This is the file Spec Kit's Constitution Check reads at `/plan` (Q5), so it is written for that surface: MUST-form statements a check can gate against, never aspiration. It authors the principle the whole authorization chain leans on — "never infer permissions from personas" (plan §4.14) — whose enforcement surface is catalogue-b4 T-12's file and whose per-feature check is the non-waivable CC-XA-02: T-12 §2 names this exact hole as T-15's, and this sheet closes it (cited, never restated). The decision this technique lets the BA make: which commitments are constitutional — binding on every feature and every downstream agent — and which are detail for a referenced file. BABOK: 10.9 Business Rules Analysis · 10.18 Document Analysis · 4.3 Confirm Elicitation Results. House: plan §4.13/§4.14, Q3, Q5, Q7; AT-RQ-1/-2 and CC-XA-02/CC-H-06 wording; D-B5-3, D-B5-4.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-1 — `constitution.md` absent or stubbed at seed grade, or a governance file its references name is missing or stubbed (CC-H-06's pre-arming image, read from the reference side) · AT-RQ-2, persona-principle clause — `personas.md` exists and the constitution does not state the persona→role principle: the hole catalogue-b4 T-12 §2 allocates here; the role-definition half stays T-12's · a §3.5-routed principle-grade finding (a sponsor ruling that binds product conduct globally) stands unincorporated. |
| Skip-if | Constitution present, seeded, stub-free, every reference resolving, and the persona clause satisfied-or-dormant — dormant while `personas.md` is absent, though the principle stands regardless (D-B5-4). Enrichment beyond principle grade on BA ask (§6.1). |
| Depth | Elicits at principle grade: per principle — name · MUST-form statement · enforcement surface · source; plus the Governance-class reference spine. Must NOT carry matrices, policy rows, or budget tables (the referenced files' ground — plan §4.13's split; a detail-heavy candidate routes to its file and the principle stays) · restate writing-standard or gate machinery as principles — EARS, tables, reference-never-restate are pre-handoff surfaces enforced by the gate, not `/plan`'s Constitution Check (D-B5-4) · author roles or budgets (T-12 / T-14 ground) · descend into per-feature rules with formulas or thresholds (spec BR ground). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Constitution at seed grade: Principles table — named principles in MUST form, each with enforcement surface + source, including the two framework principles (D-B5-4: Authorization — unconditional; Spec-first iteration) and every evidence-grounded project principle · Governance references table — Governance-class files only, each resolving to an existing, stub-free file at write time (CC-H-06's authoring-time form) |
| Artifact class | Governance (spec-anchored — Q7; the gate's static-core constant and CC-H-06's root from arming) |
| Destination file | `.specify/memory/constitution.md` (plan §7 layout; the corpus's bare `constitution.md` shorthand — contract CC-H-01, gate §3/§11.1 — resolves here) |

### 4. Procedure
1. **BA act:** under the composed Requirements plan (P-O2), invoke T-15 (P-O3) — after T-12 (the Authorization principle's enforcement surface must exist to be named) and after T-14 where design ground exists (D-B5-3): referenced-before-referencer at runtime, so every reference resolves at authoring.
2. **Framework act:** seed the framework principles (D-B5-4) — **Authorization**: permissions derive from `roles-permissions.md` policy rows only, never inferred from personas or narrative (plan §4.14's text; seeded unconditionally, personas or not) · **Spec-first iteration**: defects traced to requirements are fixed in the spec and re-run downstream, never hand-patched in code (plan §5's discipline, elevated to the surface `/implement`-side agents read). Each named, MUST-form, enforcement surface cited.
3. **Framework act:** evidence sweep for project principles — `constraints.md` Confirmed rows that bind product conduct globally, objectives stating non-negotiables, sponsor rulings in transcripts, routed arrivals; per candidate, the principle-vs-detail screen: a candidate carrying matrix- or row-grade detail routes to its governance/context file (§3.5) and only the principle line stays — cite-or-mark per line (principle 3).
4. **Framework act:** reference spine — the Governance-class estate this constitution binds: `roles-permissions.md` always (plan §4.14), `design-standards.md` where T-14 landed (D-B5-3's conditional). Each reference checked to resolve to an existing, stub-free file — a reference that would dangle is a planning defect surfaced now, not a CC-H-06 failure discovered at arming. Context-class files are never referenced here: the spine is Governance-only (Q3; gate §10.2 keeps `out-of-scope.md` under CC-H-01 alone).
5. **BA act:** rule — every principle is a BA ruling (the T-12 discipline); the Constitution Check note applied at review: a principle a check could not gate a plan against is rewritten testable or demoted to a referenced file's detail (standard rule 6, at governance grade). A candidate contradicting cleared ground is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `constitution.md`; refresh the Requirements evidence table (§7.4) — AT-RQ-1 plus the AT-RQ-2 persona clause read met-or-dormant. From arming, the file is the gate's static-core constant, CC-H-06's root, and the Constitution Check's read text at every `/plan` (Q5 — no LLM between gate and plan; the certified text is the read text).

### 5. Output template & micro-example
```markdown
# Constitution — <project>
Read by Spec Kit's Constitution Check at /plan (Q5). Principles live
here; detailed matrices live in the referenced governance files
(plan §4.13 — reference, never restate).

## Principles
| Principle | Statement (MUST form) | Enforcement surface | Source |
|---|---|---|---|
(named principles, no new line-ID family — referenced by name,
the D-B5-2 logic extended)

## Governance references
| File | Carries |
|---|---|
(Governance-class files only — the CC-H-06 checked set; each resolves
to an existing, stub-free file at write time)
```
Micro-example — Requirements seed (pre-RO-1, no `personas.md`):

| Principle | Statement (MUST form) | Enforcement surface | Source |
|---|---|---|---|
| Authorization | Permissions MUST derive from `roles-permissions.md` policy rows only; they are never inferred from personas or narrative material | `roles-permissions.md` · CC-XA-01/-02 at every gate | framework seed (D-B5-4) |
| Spec-first iteration | Requirements defects MUST be fixed in the spec and re-run downstream — never hand-patched in code | delivery loop (plan §5) · BA verification | framework seed (D-B5-4) |
| Data boundary | The system MUST NOT store or process medical-record data; Client personal-data handling stays inside the binding regime | `constraints.md` §3 · feature gates, security/privacy category | constraints.md §3 — Olena, 2026-07-09 |

| File | Carries |
|---|---|
| `.specify/memory/roles-permissions.md` | role model + resource×action policy — the Authorization principle's detail (plan §4.14) |
| `.specify/memory/design-standards.md` | global budgets + UX conventions (T-14) |

Continuity, four threads: **(i)** no `personas.md` exists at pre-RO-1, and the Authorization principle stands anyway — D-B5-4's unconditional seeding demonstrated: AT-RQ-2's persona clause reads dormant, the statement is already in force, and when charters later arrive (catalogue-b2 T-04's demonstrative Marta) TC-3's screen has its constitutional basis waiting rather than a retrofit. **(ii)** the references table is CC-H-06's checked set verbatim and the gate's static-core expansion — "`constitution.md` + every governance file it references" (gate §3) resolves to exactly these three files at this world state, hashed into every certification manifest (gate §11.1's worked line). **(iii)** the Data-boundary row shows the principle-vs-detail screen: the binding regime's detail stays in `constraints.md` §3, referenced; the constitutional MUST is one line. **(iv)** the Spec-first row is plan §5's iteration discipline elevated to the one surface downstream agents actually read at `/plan` — the Constitution Check gating exactly the conduct Mode A depends on.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-1 — `constitution.md` seeded, stub-free, plus every governance file it references · AT-RQ-2, persona-principle clause only — the constitution states the persona→role principle (the hole catalogue-b4 T-12 §2 allocates here; the role-definition half is T-12's) |
| Health hooks | CC-H-06 (M) — this file's reference set **is** the checked set: every governance file it references exists and is stub-free · CC-H-01 — in the spec-anchored estate from arming |
| Consumer hooks | CC-XA-02 (M, **non-waivable**) — no persona name as an actor anywhere in a spec; authorization derives from roles only, and the constitution principle stated here is the check's named basis (contract §8: the principle "exists precisely to be unwaivable") |

Cross-layer consumers, on the record: **Spec Kit's Constitution Check** reads this file at `/plan` — Mode A's certified-text rule makes the seeded text the checked text (Q5; gate §11.2's adapter guards the hash) · gate static-core constant: this file's references section defines the "`+ every governance file it references`" expansion (gate §3), so editing the spine changes every future run's read set · scoped-run map row → CC-H-01 · CC-H-06 with voided-certification notices (gate §10.2) · **deliberately absent from both elicitation stacks** (§3.2, §5.2) — principles bind the pipeline, not the draft; CC-XA-02's spec-side M check is the principle's per-feature enforcement · the spine is Governance-class only: `out-of-scope.md` (#10, Context) is deliberately not referenced — gate §10.2 keeps it under CC-H-01 alone.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-15`; contract check at P-O3. Inputs loaded: `.specify/memory/roles-permissions.md` (enforcement-surface existence) · `.specify/memory/design-standards.md` where present · `.specify/memory/constraints.md` (Confirmed rows) · `canvas.md` (§12 Objectives) · transcripts and routed findings · `glossary.md` · current `constitution.md`. Interaction: framework-principle seed → evidence sweep with the principle-vs-detail screen → reference-spine resolution check → destination-tagged questions → BA rulings on every principle → write. Outputs written: `.specify/memory/constitution.md`, plus routed batches where the screen sends detail to its files. §§2–5 above fix the method, the seed set, and the spine rule; Phase 2 adds the Constitution Check surface formatting (Spec Kit's expected shape), an automated reference-resolution validator (CC-H-06's pre-image), and the principle-vs-detail router.

---

## T-16 · Global out-of-scope
Band 1 · serves: Requirements · class: Context · target: #10 out-of-scope · ★ —

### 1. Purpose & BABOK grounding
Draws the product-level fence: the exclusions someone could plausibly expect *the product* to include, each naming where it lives instead — the global half of the two-grain boundary the standard §11 splits ("feature-level exclusions live [in the spec]; the product-level scope boundary lives in `.specify/memory/`"; plan §4.10). Agents helpfully build adjacent functionality; per-feature Out of Scope fences the feature's neighbors, this file fences the product's — and CC-OS-03 keeps the grains apart: no spec exclusion restates this file; product-level boundaries are referenced. It closes the Band-1 boundary deliberately last, with the full solution surface (catalogue-b3 T-10) and the requirements infrastructure (catalogue-b4) visible — the fence is drawn against a visible estate, not a guess (plan §3, B5 rationale). The decision this technique lets the BA make: what the product will not do, on the record, with each exclusion's destination named. BABOK: 10.41 Scope Modelling · 10.18 Document Analysis · 4.3 Confirm Elicitation Results. House: plan §4.10; standard §11's split; CC-OS-03 and AT-RQ-1 wording; D-B5-5.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-1 — global `out-of-scope.md` (named directly in the criterion's enumeration) absent or stubbed at seed grade · the solution surface carries plausible adjacent expectations with no standing fence — the sweep pattern: canvas §7 functions' unclaimed neighbors, §8 connections' unclaimed sides, `competitive-analysis.md` Covers entries the product does not cover, constraint-driven exclusions · a §3.5-routed exclusion finding (a declined capability, an "outside the product" ruling in a transcript) stands unincorporated. |
| Skip-if | File present, seeded (≥ 1 exclusion, D-B5-5), stub-free, and no unfenced adjacency stands in the current evidence. Post-closure boundary maintenance — graduation, retirement, new fences — arrives by routing batches and reopen signals (D-B5-5), not re-invocation. Exhaustive fencing of every conceivable adjacency is enrichment, on BA ask only (§6.1). |
| Depth | Elicits at product-boundary grade: per row — the excluded capability in one line · where it lives instead, in the Band-1 vocabulary (D-B5-5) · the plausible expectation named, with its citation. Must NOT author per-feature exclusions (spec §9 ground — standard §11's split; gate §14.1's "Notification preferences" fence is the worked feature-grain case, and it never enters this file) · perform allocation — a deferred row carries a phase hint as a roadmap candidate; naming epics and phases is Band-2 ground (T-17/T-18, inventory identity) · solicit allocation-grade settlements — the boundary question stays at whether-the-product-ever, never which-phase (the depth line elicitation §3.3 draws from the other side) · duplicate roadmap content post-Band-2 — a roadmapped item leaves this file (D-B5-5 graduation). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Global out-of-scope at seed grade: ≥ 1 product-level exclusion (D-B5-5), each row — Exclusion (one line) · Where it lives instead (`not planned` · `deferred — roadmap candidate, <phase hint>` · `outside the product — <owner>`) · Basis · source (the plausible expectation named, cited); a genuinely empty boundary is an aspect-gate matter (AW), never an invented row |
| Artifact class | Context (spec-anchored — Q7; joins the CC-H-01 estate at arming) |
| Destination file | `.specify/memory/out-of-scope.md` (standard §11's "lives in `.specify/memory/`"; gate §10.2's bare-noun stem row — the D-B4-3 zero-mirror argument, applied) |

### 4. Procedure
1. **BA act:** under the composed Requirements plan (P-O2), invoke T-16 (P-O3) — last in the batch's authoring order for the same reason it runs late in the aspect: the fence is drawn with the full solution surface and requirements infrastructure visible (B5 rationale).
2. **Framework act:** adjacency sweep — expectation candidates from: canvas §7 function lines' adjacent capabilities (what a function's neighbor suggests the product also does), §8 connection rows' unclaimed sides, `competitive-analysis.md` Covers entries the product does not cover, constraint rows that exclude a data or capability class, declined mentions in transcripts and routed findings. Per candidate, the plausible expectation is named with its source — a fence no one would test is noise, dropped with the sweep note.
3. **Framework act:** classification — per surviving candidate, the lives-instead vocabulary (D-B5-5): `not planned` (the product will not do it) · `deferred — roadmap candidate, <phase hint>` (the product may, later; allocation is Band-2's) · `outside the product — <owner>` (another system or party keeps owning it). A candidate that is really a feature-grain fence is surfaced as spec ground and left out (the depth fence applied at drafting).
4. **Framework act:** pre-draft rows, cite-or-mark; unclear boundaries become destination-tagged questions at product grade — whether the product ever does X — never which-phase (principle 2 + the depth rule).
5. **BA act:** rule — every row is a boundary ruling; ≥ 1 exclusion at seed (D-B5-5), and where genuinely none exists the instrument is the aspect waiver on Requirements, never an invented row (contract §10's ritual-compliance warning, transposed). A candidate contradicting cleared ground — an exclusion fighting a canvas function line — is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `out-of-scope.md`; refresh the Requirements evidence table (§7.4) — AT-RQ-1. The graduation path stands on the record (D-B5-5): when Band 2 lands, a deferred row that becomes an epic resolves to it and retires from this file via a routed edit; an epic contradicting a standing exclusion is a reopen signal on Requirements — the boundary stays alive by the machinery, not by re-runs.

### 5. Output template & micro-example
```markdown
# Out of Scope — <project> (global)
The product-level fence (plan §4.10). Per-feature exclusions live in each
spec's Out of Scope section (standard §11) and reference this file,
never restate it (CC-OS-03).

## Exclusions
| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
(lives-instead vocabulary at Band-1 grade — D-B5-5: `not planned` ·
`deferred — roadmap candidate, <phase hint>` · `outside the product —
<owner>`; after Band 2, deferred rows resolve to named epics or retire)
```
Micro-example — Requirements seed (pre-RO-1, before any decomposition):

| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
| Medical records / clinical data — the system holds none | outside the product — clinics' existing record-keeping remains the system of record | regulatory bind excludes medical-record data `[constraints.md §3]`; the clinic domain makes the expectation plausible |
| Online payments | deferred — roadmap candidate, beyond MVP | canvas §9: currencies `N/A — no payment surface in MVP scope` · kickoff notes |
| Cross-network marketplace listing | not planned | MedSlot covers it `[competitive-analysis.md]`; the differentiation is the network's own channel `[canvas §11]` |

Continuity, four threads: **(i)** the payments row is the graduation case (D-B5-5): at Band 2, decomposition lands an "Online payment" epic (Phase 2) — a routed edit resolves the row to the epic and retires it from this file; standard §11's per-feature example ("Payments — Phase 2, epic 'Online payment'") is the post-graduation state, and this row is its Band-1 ancestor. **(ii)** gate §14.1's fence — "Notification preferences — deferred, Phase 2" — is deliberately absent here: feature grain, written into 004's own Out of Scope at fix time; the standard-§11 split shown from both sides in one world. **(iii)** the three rows exercise the full lives-instead vocabulary, one value each. **(iv)** the marketplace row's basis reads the Covers column (catalogue-b2 T-07) and the differentiation (catalogue-b3 T-09) — the fence quoting the vision's own boundary; the Tier-1 kit lifts these rows as brief-§3 baseline (part A) and runs the same logic's cross-epic form as part-D boundary checks (elicitation §3.2).

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-1 — global `out-of-scope.md` exists, seeded, stub-free at seed grade (directly enumerated) |
| Health hooks | CC-H-01 — gate §10.2's row: `out-of-scope` edits run CC-H-01, with the voided-certification notice where in a certified feature's manifest |
| Consumer hooks | CC-OS-03 (A) — no spec exclusion restates this file; product-level boundaries are referenced (spec+oos read set) |

Cross-layer consumers, on the record: **Tier-1 kit input** (elicitation §3.2) — part-A baselines cite rows into brief §3, and part-D sibling-boundary checks run the fence logic across epics · **Tier-2 context stack row 7** — "the outer fence (CC-OS-03 — reference, don't restate)" loaded before drafting (elicitation §5.2) · gate static-core member (§3) and certification-manifest entry — the §11.1 worked line names `out-of-scope.md` explicitly · decomposition and allocation (T-17/T-18, B6 — inventory identity) read the boundary and feed the graduation path (D-B5-5); an epic contradicting a standing exclusion is a reopen signal on Requirements.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-16`; contract check at P-O3. Inputs loaded: `canvas.md` (§§7–9, §11) · `.specify/memory/competitive-analysis.md` (Covers entries) · `.specify/memory/constraints.md` · `.specify/memory/context.md` · transcripts and routed findings · `glossary.md` · current `out-of-scope.md`. Interaction: adjacency sweep → classification in the D-B5-5 vocabulary → pre-draft with product-grade boundary questions → BA rulings (≥ 1 at seed) → write. Outputs written: `.specify/memory/out-of-scope.md`, plus routed batches where the sweep finds cross-cutting ground. §§2–5 above fix the method, the row grammar, and the graduation mechanics; Phase 2 adds the adjacency-candidate generator over function and connection lines, the Covers-column miner, and the Band-2 graduation-note rendering toward decomposition and allocation.

---

## Review record — D-B5-1…D-B5-5 (ruled 2026-07-29)

Five decisions ruled in a single pass, 2026-07-29 — every recommendation accepted as written; the ruling column below is the locked text.

| # | Decision | Ruling | Basis |
|---|---|---|---|
| **D-B5-1** | T-14 destination filename — the one unpinned path in the batch (orchestrator §2.1 lists "design/UX standards (#15)" with no filename; plan §7's parenthetical covers it under "…"; gate §10.2's row is the generic "constitution / governance files") | **`.specify/memory/design-standards.md`.** The hyphenated-label pattern of `roles-permissions.md` and D-B2-3's `competitive-analysis.md`: label-derived, shortest unambiguous stem ("Design & UX standards" compresses to the load-bearing noun). Zero mirrors by construction — no corpus list names it in stem position, and gate §10.2's generic row already covers it (the D-B4-3 argument's inverse: nothing to reconcile). Alternatives — `design-ux-standards.md` (fuller label, longer stem for no resolution gain) and `ux-standards.md` (drops the half CC-NF-03's budgets live under) — rejected. Filename precedent: D-B2-3 pinned `competitive-analysis.md` in-sheet with no mirror; same here. | D-B2-3, D-B4-3 (catalogue-b2/-b4); plan §7; gate §10.2 |
| **D-B5-2** | Global-budget row form — named rows or a new line-ID family (`GB-n`)? | **Named rows in the standard-§7 grammar lifted to governance — budget name · metric · target · condition · source; no new ID family.** The corpus's one canonical budget citation is by prose name — gate §14.1's "`covered by the global Design & UX accessibility budget`" — and line-ID families exist only where downstream cites demand line grain (D-B1-1's own scope logic: `P-n`/`O-n` because CC-OV-02 and kit baselines point at lines). CC-NF-03 is an A-check comparing content against governance, not resolving IDs; a `GB-n` family would be machinery nothing reads. The same logic extends to T-15: constitution principles are named, not numbered — nothing cites a principle by line either. | Gate §14.1; D-B1-1 (catalogue-b1); CC-NF-03; standard §7 |
| **D-B5-3** | #15's mandatoriness — is a design-standards file required in every project? | **Evidence-conditional, with the constitution-reference clause as AT-RQ-1's mandatoriness mechanism.** AT-RQ-1's letter reaches #15 only through "`constitution.md` plus every governance file it references" — unlike `out-of-scope.md`, it is not directly enumerated. Reading: where design/UX ground exists in Band-1 evidence, T-14 runs (before T-15, so the reference resolves at authoring) and the constitution's reference lifts the file into AT-RQ-1's demand, CC-H-06's checked set, and the gate's static core; where none exists (a headless/API product), the constitution omits the reference, the file is omitted on the aspect record, and AT-RQ-1 passes without it. Precedent for a conditional artifact: personas (#6) are BA-elected enrichment (inventory T-04). Orchestrator §2.1's unconditional listing is the evidence/reopen map, not a mandatoriness claim. **Mirror candidate at the orchestrator's next bump:** a one-line conditionality note beside AT-RQ-1 (§3.3), the D-B4-4 pattern. | AT-RQ-1 wording (orchestrator §3.3); CC-H-06; inventory T-04 row; D-B4-4 precedent |
| **D-B5-4** | The constitution's seed principle set — what enters unconditionally, and where does house methodology stop? | **Two framework principles seed every constitution: Authorization (unconditional — not only when personas exist) and Spec-first iteration; project principles enter by evidence; methodology shape-rules stay out.** Authorization unconditional: CC-XA-02 (M, non-waivable) names the constitution principle as its basis without conditioning on personas, the gate's static core reads `constitution.md` in every run, and unconditional presence costs one line while pre-empting a retrofit at persona arrival — AT-RQ-2's "if personas exist" is the threshold's minimum, not a prohibition on seeding earlier. Spec-first iteration (plan §5: "spec errors are fixed in the spec … never hand-patched in code") is the one house discipline that binds `/plan`-and-after conduct — exactly the Constitution Check's surface. EARS, tables, reference-never-restate stay out: pre-handoff rules enforced by the gate on the spec, not by `/plan` on the plan — restating them here would re-enforce spec rules on the wrong artifact. | Plan §4.14, §5; CC-XA-02 (contract §8); AT-RQ-2; gate §3; Q5 |
| **D-B5-5** | T-16's exclusion grammar — the lives-instead vocabulary at Band-1 grade, the seed minimum, and the Band-2 graduation path | **Three lives-instead values at Band-1 grade:** `not planned` · `deferred — roadmap candidate, <phase hint>` · `outside the product — <owner>` — pre-decomposition there is no epic to name, so the standard-§11 rule ("a phase, an epic/feature, or 'not planned'") compiles to these targets at product grain; after Band 2, deferred rows resolve to named epics or retire. **≥ 1 exclusion at seed:** AT-RQ-1's "seeded = real initial content, not headings" read at this file — CC-OS-01's logic at product grade, where the solution surface always supplies a plausible adjacency; the genuinely-empty case takes an aspect waiver, never an invented row (contract §10's ritual-compliance warning). **Graduation by machinery, not re-runs:** a deferred row becoming an epic retires via a routed edit; an epic contradicting a standing exclusion is a reopen signal on Requirements — no new instrument, no daemon. | Standard §11; CC-OS-01…03; AT-RQ-1; contract §10; orchestrator §5/§9 |

**Conflict scan (finalized at review close, 2026-07-29) — against the five spine documents (standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.2 · orchestrator v0.2) and prior batches (catalogue-b1…b4, all v0.2).** Checked: AT-RQ-1 and AT-RQ-2 wording and clause allocation (orchestrator §3.3 — the persona-principle clause to T-15 exactly as catalogue-b4 T-12 §2 allocates it; the reference clause as T-14's reach mechanism, D-B5-3) · CC-H-01, CC-H-06 (M), CC-NF-03 (A, enforcement-only per contract §9), CC-OS-01…04, CC-XA-02 (M, non-waivable) wording, read-sets, and checker classes (contract §5–§6, §8–§9) · destination paths — `constitution.md` inside `.specify/memory/` (plan §7's parenthetical; the contract's and gate's bare-name shorthand resolves there), `out-of-scope.md` (standard §11's explicit `.specify/memory/` placement + gate §10.2's bare-noun stem, the D-B4-3 argument), `design-standards.md` (D-B5-1, zero mirrors) — all inside CC-H-01's glob · gate §3 static core and §11.1 manifest line honored: the constitution's reference spine is the "+ every governance file it references" expansion; `out-of-scope.md` a named manifest entry · gate §10.2 rows honored in both directions: "constitution / governance files" → CC-H-01 · CC-H-06 (T-14, T-15); `out-of-scope` → CC-H-01 only — which is why T-15's spine is Governance-class-only and never references #10 · elicitation stacks reconciled: `out-of-scope.md` is a Tier-1 kit input (§3.2) and Tier-2 stack row 7 (§5.2); constitution and design standards are **deliberately absent from both** — principles and budgets bind the pipeline at gate/`/plan` time, and CC-NF-03's enforcement-only status (contract §9) is the spine's own statement that the writer does not self-verify against the budgets · catalogue-b4's fences honored from this side: T-12/T-13's "T-14 governance / `/plan` ground" split resolves in T-14 §1–§2; the T-15 hole closed exactly as T-12 §2/§6 names it, cited never restated · micro-example continuity: pre-RO-1 held (no `personas.md` — the Authorization principle's unconditional seeding shown against it); the accessibility budget is the exact global gate §14.1's canonical fix cites; the mobile budget sits beside feature NFR-001 as CC-NF-03's global-vs-delta pair; the Data-boundary principle references constraints.md §3 (catalogue-b2 T-06's row) without restating it; the payments row reconciles canvas §9's `N/A — no payment surface in MVP scope` (catalogue-b3 T-10) with standard §11's "Payments — Phase 2, epic 'Online payment'" as Band-1 ancestor → post-graduation state; the notification-preferences fence (gate §14.1/CC-TR-01 fix) stays feature-grain and out of the global file; the marketplace row reads T-07's Covers column and T-09's differentiation. Forward references (T-17/T-18, B6) stand at inventory identity only — the sequencing invariant intact (the B2 scan's precedent). One extension flagged as a **mirror candidate at the orchestrator's next version bump: D-B5-3** (a conditionality note beside AT-RQ-1, §3.3 — the D-B4-4 pattern); D-B5-1 and D-B5-5 need zero mirrors by construction; D-B5-2 and D-B5-4 are applications of standing wording (gate §14.1's reference form; plan §4.14/§5). **No spine contradiction found; no erratum issued.**

---

*v0.2 · review closed 29 July 2026 — all five recommendations accepted as written · sheets T-14–T-16 of 18 · authored to sequencing-plan §2 template (D-W9 order: contract before procedure) · no ★ in batch — all three to the elicitation-§7.1 no-reference pattern · class mix Governance ×2 + Context ×1 — dependency and rationale trump class (plan §3, B5) · closes the Band-1 catalogue: with B5, all 16 Band-1 sheets stand · decisions D-B5-1…D-B5-5 ruled (review record above) · one mirror candidate: D-B5-3 → orchestrator §3.3 conditionality note at its next version bump · next: B6 — Band-2 pair (T-17…T-18), standing batch prompt §4, new conversation*
