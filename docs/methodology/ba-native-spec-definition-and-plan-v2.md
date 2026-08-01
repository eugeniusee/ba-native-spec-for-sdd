# BA-Native Spec *(working codename)*
## Framework Definition & Development Plan — v2.14

**Owner:** Yevhen Kliukin (BA Lead / Agentic AI Transformation Lead, Geniusee)
**Status:** Phase 0 CLOSED · **PHASE 1 COMPLETE** — Wave 1 (5 spine docs) + Wave 2 (18-sheet catalogue + index), all review-closed; exit criterion met: a BA can run the method from the documents alone · **PHASE 2 OPEN** — build plan v0.2 closed, S1 next · updated 30 July 2026 — current state in §0
**Positioning:** made by a BA, for BAs · **Category: Spec-Driven Analysis** — the analysis layer that makes Spec-Driven Development actually work

---

## 0. Current state & working model

**Working model:** each Phase 1 document is authored in its own conversation. The finished documents + this plan live in the **project files** as the single source of truth; every new conversation grounds itself in them. This document is the **index and state tracker** — updated at the end of every working session. One live version per document in project files: replace on update, stable file names (no version suffix in the project-file name).

**Progress tracker:**

| # | Deliverable | Status | File |
|---|---|---|---|
| 0 | Definition & plan (this doc) | 🟢 living · v2.14 | ba-native-spec-definition-and-plan |
| 1 | Spec writing standard | 🟢 v0.3 (erratum applied) | ba-native-spec-writing-standard |
| 2 | Completeness contract | 🟢 v0.2 — review incorporated | ba-native-spec-completeness-contract |
| 3 | Two-tier elicitation techniques (Tier-1 scoping-call kit · Tier-2 spec-depth gap-filling) | 🟢 v0.3 — D1–D8 locked · pending mirror at next bump: D-P2-11 (ledger home `.specify/elicitation-tuning.md` for the §10 logs) → §10 | ba-native-spec-elicitation-techniques |
| 4 | Gate definition (runs the contract; named gaps; waiver log) | 🟢 v0.3 — D-B6-1 mirror applied → §11.1 (30 July 2026); review incorporated; 9 decisions closed, zero contract errata; refine during pilot · no pending mirrors | ba-native-spec-gate-definition |
| 5 | Orchestrator rules (aspect DAG, thresholds, reopen/waiver, BA-planning loop) | 🟢 v0.3 — five catalogue mirrors applied 30 July 2026 (D-B1-4 + D-B6-5 → §6.4 · D-B5-3 + D-B4-4 → §3.3 · D-B6-3 → §8.4); review incorporated; D-O1–D-O10 locked (all recommendations accepted); zero errata · no pending mirrors | ba-native-spec-orchestrator-rules |
| 6 | Wave 2 breadth — the technique catalogue: 18 sheets, all authored from scratch (★ = presale reference design to mine: canvas, epics — glossary ★ dropped per D-W8); incl. the Band-2 pair (epics decomposition · scope allocation), persona charters, glossary discipline; 6 batches per the sequencing plan | 🟢 **Wave 2 COMPLETE** — 6/6 batches (T-01–T-18) review-closed: catalogue-b1 v0.3 (B3 mirrors D-B3-1 · D-B3-3 applied 30 July 2026) · catalogue-b2…b6 v0.2 · seq-plan v0.4 (D-B2-1 → §2 applied 30 July 2026) · catalogue index v0.2 regenerated per D-W6 (all 18 rows unchanged — provenance only; sheet governs on divergence, regenerated at any batch bump) · no pending mirrors | ba-native-spec-wave2-sequencing-plan · ba-native-spec-catalogue-b1 · ba-native-spec-catalogue-b2 · ba-native-spec-catalogue-b3 · ba-native-spec-catalogue-b4 · ba-native-spec-catalogue-b5 · ba-native-spec-catalogue-b6 · ba-native-spec-catalogue-index |
| 7 | Phase 2 build · Phase 3 pilot · Phase 4 rollout | 🟡 **Phase 2 OPEN** — build plan v0.2 review-closed (67 build units · 9 Claude Code sessions S1–S9 · exit test scripted); next: S1 foundation session | ba-native-spec-phase2-build-plan |

**Next action:** S1 (foundation — repo skeleton, installer, templates, mirror files, manifest) per the build plan §4 standing session prompt — a NEW separate **Claude Code** conversation inside the package repo, grounded in the vendored `docs/methodology/` set, not in this project. Session records return to the plan conversation for tracker updates.

---

## 1. Why this exists (unchanged from v1, condensed)

Geniusee is moving to an AI-native SDLC: development shrinks to a single agent operator running Claude Code, making the **specification the primary production artifact**. The SDLC bottleneck moves upstream into elicitation and specification — the BA's ground. The market corner "broad, orchestrated BA-cycle coverage × native handoff to a coding agent" is empty: SDD frameworks (Spec Kit, Kiro, BMAD, OpenSpec) assume analysis is done; RE-quality tools never hand off to agents; skill packs have no orchestration. **Skills are commodity; orchestration is the moat.**

Hard constraints: one direction, no parallel pilots · open, file-based, ownable — closed SaaS excluded by principle · Claude Code is the execution layer; artifacts stay portable.

---

## 2. Phase 0 decision log (LOCKED)

| # | Question | Decision |
|---|---|---|
| Q1a | Aspect model | **Six aspects, anchored on the presale canvas:** Stakeholders · Context *(new)* · Value · Vision · Solution · Requirements. Canvas = the discovery vision board, extended with a Context/Constraints element. |
| Q1b | Dependency strictness | **Gated** on the DAG (Stakeholders → Context + Value → Vision → Solution → Requirements), with two safety valves: gates are **minimum first-pass thresholds** (not full completeness) + **reopen & waiver** (downstream findings reopen upstream aspects; gates waivable with logged reason). |
| Q2 | Technique selection | **BA planning, LLM assists.** LLM suggests a recommended technique set + sequence from canvas evidence — advisory, never a restriction. BA composes the real plan: select from catalogue (→ skills library), drop, reorder, **add custom techniques**. |
| Q2+ | Output contracts | Every technique — catalogue or custom — carries **{expected output · artifact class · destination file}**. Predefined for catalogue; for custom the BA supplies it or LLM proposes and BA confirms. The LLM writes each output into its mapped place. |
| Q3 | Artifact model | **Discrete artifact files in three classes** — Spec (per-feature, buildable) / Governance (cross-cutting rules) / Context (reference to understand) — each mapping to a real Spec Kit home. "Fits Spec Kit in the end" is the organizing rule. |
| Q3+ | Acceptance grammar | **EARS always** for functional requirements. Acceptance is **tiered**: Gherkin only for non-trivial behavior (concrete data, never re-narrating the rule); one-line checklist criteria for simple rules/validations/permissions. No duplication by construction. |
| Q4 | Skeleton | **Native Claude Code primitives** (subagents, skills, slash commands, checklist gate + `.specify` preset). BMAD is reference design only — its linear persona relay doesn't fit the gated-pool + BA-planning model; technique skills are authored from scratch, with presale skills mined as reference designs (elicitation v0.3 ruling). |
| Q5 | Handoff | **Mode A primary:** compiler writes certified artifacts directly into `specs/NNN-feature/` + `.specify/memory/`; thin adapter does Spec Kit plumbing (branch, dirs); operator resumes at `/speckit.plan`. No LLM between gate and plan — the certified text is the read text. Mode B (thin `/specify` import) = documented fallback. |
| Q6 | Name | Working codename **BA-Native Spec** (umbrella: BA-Native). Category label: **Spec-Driven Analysis**. Final trademark/domain sanity check before anything external. |
| Q7 | Spec governance | **Spec-anchored for Governance + Context classes** (kept alive on every change); **per-change for feature specs** (v1). The expensive-to-lose, cross-cutting artifacts never rot; feature specs stay lightweight. |
| Q8 | v1 / post-v1 scope | **v1 = everything agreed** (see §4), including epics decomposition + the two new capabilities (§5). Post-v1: BMAD adapter · deeper per-IDE tuning beyond AGENTS.md mirror · risk register, ADRs/decision log, data dictionary, test-scenario generation. **Jama/DOORS regulated-traceability backbone: CUT entirely** (closed systems excluded by principle). |
| C1 | Allocation cadence *(post-close clarification)* | **Scope allocation is an on-demand, repeatable technique, not a phase.** Apply or re-apply any time scope exists — after decomposition, after scoping calls, after delivery learnings, after priority shifts. Each rerun = recommended re-allocation with rationale + **diff vs. current**; BA approves; the living roadmap logs the change with reason. |
| C2 | Elicitation depth *(post-close clarification)* | **Two-tier elicitation.** **Tier 1 — Epic scoping interview** (decomposition stage): per-epic stakeholder call; from the one-line description + project context the LLM prepares a call kit — question set + risks & assumptions to check — at scoping depth only (crucial/significant areas, essential scope; technical final-spec questions forbidden); the BA runs the call; notes/transcript ingested into a per-epic **scope brief**. **Tier 2 — Spec-depth gap-filling** (build loop): draft-first from scope brief + context, capped questions at EARS-ready detail. Paired question discipline: **never ask what's already answered; never ask what's not yet needed at this stage.** |
| C3 | Decomposition vocabulary *(post-close clarification)* | **Three-level chain: Epic → Feature → User story + AC. Nothing dropped — "feature" is the only new term.** **Epic** (Stage 5 ★) = unit of decomposition, Tier-1 scoping calls, and allocation; lives in *our* layer (roadmap + scope briefs in `.specify/memory/`), no Spec Kit equivalent. **Feature** (adopted from Spec Kit) = the packaging unit: one feature = one `specs/NNN-feature/` branch = one spec.md = one build cycle; one epic → 1..N features — slicing is *proposed in the epic's scope brief* (evidence-based, post-call) and *confirmed at delivery-loop entry*; small epic = 1:1 and the middle level is invisible in practice. **User story + AC** (Stage 6 ★) = kept and central: stories are the spec.md **skeleton** (Spec Kit's native prioritized-stories shape, P1–P3), each with tiered acceptance; EARS FRs sit alongside as the system rules; tasks tag back to stories ([US1], [US2]). |
| C4 | Technique provenance *(ruled 20 Jul; consolidated into this log 25 Jul)* | **No reuse of existing Geniusee skills as components — every framework technique skill is authored from scratch in Phase 2**, purpose-built to the framework's contracts (three-field output contract, writing standard, completeness contract, gate). The presale chat skills (canvas, glossary, questions-to-client, epics, user stories) are **reference designs only** — mined for question sets and structure, never dropped in as-is: they emit chat-table deliverables, predate the framework's output discipline, and forking them would split each into two diverging versions while the presale flow still uses the originals. **★ now reads "presale reference design to mine," not "drops in natively"** — the superseded wording in Q4, §4's legend, and §8 was corrected via the Wave-2 sequencing plan §5 (25 Jul). Count pinned: 18 catalogue sheets + 2 spine techniques (sequencing plan §1). Already propagated: elicitation v0.3 (§7 = per-skill build briefs). |

---

## 3. The aspect model & canvas mapping

| Aspect | Canvas section(s) | Gate prerequisite |
|---|---|---|
| **Stakeholders** | Customers (+ sponsors/users) | — (root) |
| **Context** | Competition→Unlike + new Context/Constraints element (regulatory, existing systems, org) | Stakeholders |
| **Value** | Problems, Objectives | Stakeholders |
| **Vision** | Product→The/Is/That, Competition→Our Solution | Context + Value |
| **Solution** | Forms, Core Functions, Third-Party Connections, Localization | Vision |
| **Requirements** | *(beyond the canvas — the completeness contract)* | Solution |

The canvas covers aspects 1–5 and stops exactly where the agent's needs begin (no roles matrix, data model, business rules, NFRs). **Carrying the canvas forward into the agent-ready spec is the framework's value-add.**

---

## 4. Artifact taxonomy — v1 set (18 artifacts)

**Class CONTEXT** → `.specify/memory/` + `AGENTS.md` mirror + `canvas.md` *(spec-anchored)*

1. Presale canvas ★ (vision board; + Context/Constraints element)
2. Glossary / ubiquitous language
3. Stakeholder register (who's who — comms, decision rights, transcript parsing)
4. Context (existing systems, tech landscape, org)
5. Constraints & limitations (own artifact — technical / business / regulatory)
6. Personas (context only; **mandatory persona→roles transformation** — personas never travel into the build as authorization)
7. Competitive analysis
8. Domain (conceptual) model — entities & relations, business level; kept separate from per-feature data
9. Core process descriptions — major journeys of each significant role, helicopter view with step descriptions; not tied to features
10. Out-of-scope (global scope boundary; per-feature Out of Scope section lives in the spec)
11. **Backlog / roadmap** — epics + phase allocation; the living pointer that drives delivery; re-allocations logged with diff + reason
12. **Epic scope briefs** — per-epic essential scope, boundaries, key assumptions & risks, open questions, **+ proposed feature slicing**; produced by Tier-1 scoping interviews (call kit → BA-run call → ingestion); the seed of the future spec(s). Maps to the existing Stage-4 questions-to-client skill ★

**Class GOVERNANCE** → `constitution.md` + `.specify/memory/` *(spec-anchored)*

13. Constitution — principles + standards; *references* detailed governance files
14. Roles & permissions — role model + resource×action policy in `memory/roles-permissions.md`; the authorization *principle* lives in the constitution ("never infer permissions from personas") so the Constitution Check enforces it
15. Design & UX standards (global)

**Class SPEC** → `specs/NNN-feature/` *(per-change)*

16. Feature spec — **skeleton = user stories (P1–P3, Stage-6 skill ★), each with tiered acceptance (Gherkin or checklist)** · EARS functional requirements (FR-IDs) alongside as the system rules · feature NFRs · data requirements · business rules · flows/states/errors · integration touchpoints · per-feature Out of Scope · references (never restates) roles + glossary + domain model — matches Spec Kit's native spec.md shape
17. Traceability (aspect → technique → requirement → acceptance)
18. Gate report (contract pass evidence, waivers)

★ = a presale-flow chat skill exists as a **reference design** — mined for proven interaction patterns and content heuristics at sheet-authoring time, never imported as a component (elicitation v0.3 §7/§11 ruling). Everything else from the wide menu = custom / addable later.

---

## 5. Full process lifecycle (LOCKED)

**Band 1 — Project discovery (gated aspect pool).**
Frame → per aspect: LLM suggests techniques from canvas evidence → **BA composes the plan** (select / drop / reorder / add custom, output contracts pinned) → techniques run → outputs land in their classed artifact files → gate thresholds clear. Reopen + waiver available throughout.

**Band 2 — Decomposition, scoping & allocation** *(repeatable)*.
Epics decomposition ★ → **Epic scoping interviews** *(Tier 1)*: for each epic (one-line input), the LLM prepares a stakeholder-call kit — question set + risks & assumptions to check — calibrated to scoping depth (crucial/significant areas, essential scope; technical final-spec questions forbidden); the **BA runs the call**; notes/transcript are ingested into the epic's scope brief (#12) — including a **proposed feature slicing** (small epic → one feature; large epic → 2–3 features) — cross-cutting findings routed to their homes → **Scope allocation** *(on-demand, repeatable)*: LLM recommends MVP / Phase 2 / later per epic with rationale — value vs. effort, dependency order, risk, walking-skeleton MVP logic — **BA edits and approves**; re-run whenever scope knowledge changes; each rerun logs a diff + reason on the living roadmap (#11).

**Band 3 — Per-feature delivery loop (repeats).**
Select the next epic from the roadmap → confirm its feature slicing from the scope brief (1:1 for small epics) → **per feature:**
**Spec-depth elicitation** *(Tier 2)*: loads full project context (canvas, glossary, roles, domain model, process maps) **+ the parent epic's scope brief** → **drafts a first-cut spec skeleton around its user stories (Stage-6 ★)** → asks only the remaining gap questions — capped, one at a time, recommended answers offered — now legitimately at spec depth (EARS-ready detail, data, rules, flows, errors). **Both guards apply: never ask what's already answered; never ask what wasn't needed until now.** Cross-cutting findings (new role / term / constraint) route to their governance/context homes and may trigger an aspect reopen →
Spec authored (EARS + tiered acceptance + contract sections) →
**Completeness gate** — a multi-artifact check: roles constitution covers the feature's resources, glossary current, spec sections filled with real content (a stubbed heading fails) → pass, or back with named gaps →
**Mode A handoff** → `/speckit.plan` → `/tasks` → `/analyze` → `/implement` (Claude Code, operator steers) →
**BA verifies** against the acceptance tier → roadmap updated → next feature.

Iteration discipline unchanged: spec errors are fixed in the spec and re-run downstream — never hand-patched in code.

---

## 6. Requirements grammar (LOCKED)

- **EARS — mandatory** for every functional requirement: the rule the agent implements.
- **Acceptance — one slot, tiered:** Gherkin Given-When-Then only where behavior is non-trivial (multi-step flows, branching, edge cases), always with concrete data, never re-narrating the EARS rule (if it reads like the rule reworded → it's a checklist line instead). Simple rules, validations, fields, permissions → one-line checkable criteria.
- Structured tables for structured data (permissions, fields, states). No implementation detail in specs — the *how* belongs to `/plan`.

---

## 7. Architecture & packaging (LOCKED)

- **Native Claude Code build:** personas → subagents (Discovery BA, Requirements Analyst, Orchestrator) · techniques → skills · workflow → slash commands · gate → checklist + plan-mode review · Spec Kit contact isolated in a `.specify` preset + thin Mode-A adapter (branch/dirs/copy).
- **Layout:** `canvas.md` · `AGENTS.md`/`CLAUDE.md` mirror · `.specify/memory/` (constitution, roles-permissions, glossary, stakeholders, context, constraints, domain-model, processes, backlog + scope briefs…) · `specs/NNN-feature/` (spec, traceability, gate-report).
- **Installer:** one command into a project dev folder (install.sh / npx-style), copying `.claude/` (agents, skills, commands) + `.specify/` (preset) + doc scaffolds.
- **Portability:** plain files throughout; AGENTS.md mirror carries the standard to any AGENTS.md-reading tool. Vendored dependencies only (e.g., EARS lint content) — no upstream runtime dependencies.

---

## 8. Development plan

**Phase 0 — CLOSED.** This document is the record.

**Phase 1 — Methodology authoring — COMPLETE 30 July 2026** *(conversational, artifact-by-artifact review; ~2–3 weeks now that v1 scope is 17 artifacts + 20 techniques (2 spine + 18 catalogue))*
Two waves:
- **Wave 1 — the spine:** house spec standard (EARS + tiered acceptance) · completeness contract v1 as checkable assertions · feature-spec technique + **two-tier elicitation** (Tier-1 scoping-call kit + ingestion; Tier-2 spec-depth gap-filling) · the gate · orchestrator rules (DAG, thresholds, reopen/waiver, BA-planning loop). **COMPLETE — all five documents authored and review-closed (25 July 2026).**
- **Wave 2 — breadth: the technique catalogue.** 18 technique sheets authored **from scratch** to the uniform sheet template (Wave-2 sequencing plan): the Band-1 catalogue — 16 sheets incl. the Frame canvas technique, persona charters, glossary discipline, and the canvas-internal aspect trio (Value · Vision · Solution) — plus the Band-2 pair (epics decomposition · repeatable scope allocation). Each sheet pre-pins its Q2+ output contract and carries catalogue metadata for the BA-planning loop (doc 5 §6), gate hooks (AT thresholds · CC-H keep-alive · Scope-F consumers), an output template in writing-standard discipline, and a Phase-2 build-brief hook (doc 3 §7 format). Presale skills serve as reference designs to mine where they exist (canvas ★ · epics ★) — never as components. Authored in 6 batched conversations per the sequencing plan's dependency order.
Exit: a human BA could run the method manually from the documents alone.

**Phase 2 — Build the installable package** *(~1–2 weeks in Claude Code)*
Repo skeleton · subagent/skill/command/template/checklist/config files · `.specify` preset · Mode-A adapter · installer · vendored EARS lint. Exit: `install → run → artifact set appears → /speckit.plan consumes it` on a toy feature.

**Phase 3 — Validate on one real feature** *(one delivery cycle)*
Full loop live: discovery → decomposition → allocation → interview → spec → gate → `/plan` → `/implement` → verify. **Metrics: first-pass correctness + gate catch-rate.** Iterate contract and prompts, not tooling.

**Phase 4 — Harden & roll out**
Pin Spec Kit version · BA docs + training · AGENTS.md portability mirror · internal vs. open-source decision · v1.0 tag.

**Definition of v1 done:**
- [ ] One-command install into a Claude Code project
- [ ] BA runs gated discovery with BA-planned techniques (LLM suggests, BA decides; custom techniques with pinned output contracts)
- [ ] Epics decomposed; Tier-1 scoping interviews produce per-epic scope briefs incl. proposed feature slicing (call kit → BA-run call → ingestion); LLM-recommended, BA-approved allocation on the living roadmap, re-runnable with logged diffs
- [ ] Two-tier elicitation live: Tier-1 scoping never asks final-spec questions; Tier-2 spec-depth never re-asks the answered
- [ ] Compiler emits the classed artifact set; gate blocks with **named gaps** (stubs fail)
- [ ] `/speckit.plan` consumes Mode-A output with zero manual rework
- [ ] One real feature shipped end-to-end, verified against its acceptance tier
- [ ] No closed-SaaS dependency; plain files; AGENTS.md mirror present

---

## 9. Risks & mitigations (updated)

| Risk | Mitigation |
|---|---|
| Spec Kit churn | All contact isolated in adapter + preset; version pinned; fallback = reimplement the thin spine natively — method and spec standard survive |
| LLM non-determinism | Gate + BA review + tiered machine-checkable acceptance |
| Question-quality drift | Context-first loading; draft-first capped interviews; the never-ask-the-answered rule; curated catalogue |
| Token/cost bloat | Lean specs; capped questioning; one feature per cycle |
| Scope creep | v1 = Claude Code + Spec Kit only; post-v1 list is explicit; Jama/DOORS cut |
| Upstream fragility | Vendor everything in; no runtime upstream deps |
| Phase 1 heaviness (18 artifacts) | Two-wave authoring: spine first — breadth only after the spine works |

---

## 10. Post-v1 (explicit)

BMAD adapter · deeper per-IDE tuning beyond the AGENTS.md mirror · risk register, ADRs/decision log, data dictionary, test-scenario generation as catalogue techniques. **Removed from roadmap entirely: Jama/DOORS regulated-traceability backbone.**
