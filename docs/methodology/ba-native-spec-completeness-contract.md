# Geniusee Completeness Contract
### BA-Native Spec · gate contract · v0.4 — the marker namespace closes and CC-FL-04 names one standard: a marker is evidence, never coverage (25 Aug 2026; review incorporated 19 July 2026)

**v0.4 change record:** two assertion rows re-cut, no row added, ruled 25 Aug 2026 (origin: **EC-21** — the field design-defect report *the gate does not distinguish evidence from decision* (25 Aug 2026) and its verified triage `docs/field-notes/2026-08-22-cc-fl-04-coverage-inversion.md`: over 25 draft specs and 131 error-table rows, gate run 4, an `[ASSUMED: …]` tag standing in the *System behavior* cell satisfied CC-FL-04 — 45 tagged rows PASS, 82 plain rows FAIL, zero failures on a tagged row — while a row an IF/THEN FR covered almost word for word failed it for lack of a literal `(FR-nnn)`; the tag was never framework grammar, CC-G-02 read it as content, and CC-FL-03 passed the same row with its behavior cell holding no behavior; BA Lead ruling **`apply all`** over R1–R7, 25 Aug 2026; base commit `6970a0a`, package 0.1.41): **CC-G-02 closes the marker namespace** — the framework defines `[NEEDS CLARIFICATION: …]` and `[CONFLICT: …]` (catalogue-b1 D-B1-2) and no others; any further bracketed token of marker shape is a **mint**, is not content, and fails wherever it stands in place of required content, a table cell included — **converted, never honoured**, on this row's own non-waivable path (name the gap as the pinned marker, then CC-G-03's waivable line). The clause is the class fix: it reaches every assertion that reads a cell — CC-FL-03 and CC-FL-04 together with the rest — through the namespace and never through a per-card patch, and it reaches `canvas.md` through CC-H-01 exactly as before. **CC-FL-04 names one standard, the semantic one** — every row of the alternates/errors table is *governed* by a requirement in this spec: an unwanted-behavior FR (IF … THEN, WHILE) for an error, an event-driven FR (WHEN) where the row is an alternate, or a BR the row applies; the evaluator searches the FR and BR lists and fails only where no governing requirement exists; an inline citation is permitted style, never the pass condition — the standard's own worked example (row E1 uncited, row E2 cited) is the framework's intent, passes under this reading and failed under the other; the evidence names, per row, the governing FR or BR or `none`. **No fifth column:** the template's four columns are the table's whole shape, and no spec already written changes shape. **What a marker's presence means at an A checker is the gate's ground** (gate v0.12 §5.2 — *a marker is evidence, never coverage*, stated once and inherited by every A assertion); **the writer's half** is the writing standard's (v0.6 rule 7 — the spec's one marker grammar) and the pre-flight's (elicitation v0.10 D14 — a mint stops the write at authoring); **CC-G-03 is untouched** — the pinned marker's count, waivable, exactly as written; the `[CONFLICT: …]`-in-a-spec edge (neither a mint nor counted) is routed, never legislated here. The assertion count stands at **62** (24 M · 38 A); no tag, scope rule, glob, non-waivable membership or section moves. Companions: gate v0.12 (§4.1 · §5.2 · §5.3 · §7.1 · §9.2) · writing standard v0.6 (rule 7 · §15) · elicitation v0.10 (§5.3 step 4 · §7.2 · D14).

**v0.3 change record:** one assertion row, ruled 19 Aug 2026 (origin: **EC-02** — deferrals and exclusions were never cross-checked against the acceptance/pass/success lists the sources state, and conflicts stayed silent until delivery; BA Lead ruling **`apply all`**, 19 Aug 2026; base commit `448384b`, package 0.1.28): **§6 gains CC-H-07** — no epic allocated outside the delivery boundary and no global out-of-scope entry may conflict **unresolved** with a `standing` acceptance-shape entry (**`AS-<n>`**, orchestrator §2.4 — the register D-O78 harvests at Frame); a conflict stands **resolved** only by a recorded BA ruling — a step-4 ADV disposition (catalogue-b6 D-B6-17), or the entry itself `superseded — SD-<n>` or `accepted — <reason>`. **The contract states the assertion; classing, counting and run points are the gate's ground** (gate v0.11 §10.2 · §10.4 — the CC-H-02 division of labor verbatim), and the read of the ledger head this assertion needs is the gate's **named** boundary change, legislated there. The assertion count moves **61 → 62** (24 M · 38 A); no other row, tag, scope rule, glob or section moves, and the §3 cadence is consumed as written. Companions: orchestrator v0.30 (D-O78–D-O79) · gate v0.11 · catalogue-b6 v0.7 (D-B6-16–D-B6-17).

**What this is:** the executable definition of *requirements done*. When a feature's spec and the artifacts it depends on satisfy every assertion below — or carry a logged waiver for the ones they don't — the feature may cross into `/speckit.plan`. Not before.
**Design rule:** every line is a pass/fail assertion a checker can answer with evidence. Quality wishes ("roles are well defined") are banned from this document by construction — if it cannot fail with a named gap, it is not in the contract.
**Division of labor:** this contract defines *what is checked* and what verdicts mean. The gate definition (document 4) defines *how it runs* — sequencing, checker implementation, when the BA is prompted. The orchestrator rules (document 5) own the Band-1 aspect gates; aspect thresholds are out of scope here.

---

## 1. Position in the framework

**Upstream — the writing standard (document 1).** The standard defines how a spec is written; its §15 self-check is the **writer's half of this gate** — the same bar, run from the writer's seat, before submission. This contract is the **enforcement half**: an independent, instrumented run that produces evidence. §9 proves the mapping: every §15 item resolves to at least one assertion here, and the contract adds what a writer cannot self-verify (cross-artifact coverage, the traceability graph, scope-brief consistency).

**This run's record is artifact #18.** Each execution of this contract appends to the feature's `gate-report.md` (format in §7). Assertion CC-TR-04 covers artifact #17 (traceability).

**Downstream — Spec Kit.** `/speckit.checklist` and `/speckit.analyze` remain in the pipeline as a **backstop, not the bar. This contract is primary** and strictly stronger: EARS validity, tiered-acceptance discipline, authorization coverage, and scope-brief consistency are invisible to stock Spec Kit. Under Mode A there is no LLM between gate and plan — this contract is therefore the **last inspection before the certified text becomes the read text**. Anything the backstop catches that this contract missed is a contract defect (§10).

---

## 2. How to read an assertion

**ID form:** `CC-<CAT>-<nn>` — **CC** stands for *Completeness Contract*: assertion IDs carry their source document's initials, exactly as `FR-` marks a functional requirement. The prefix prevents collision with in-spec IDs — a report line "CC-FR-02 FAIL — FR-007: …" names the rule on the left and the offending requirement on the right, unambiguously.

**Tags per assertion:**

| Tag | Meaning |
|---|---|
| **Checks** | The artifact(s) the checker reads. Shorthand: `spec` = `specs/NNN-feature/spec.md` · `roles` = `roles-permissions.md` · `gloss` = `glossary.md` · `dm` = `domain-model.md` · `brief` = `.specify/memory/scope/<epic>.md` · `oos` = global out-of-scope · `canvas` = `canvas.md` · `gov` = constitution + governance files · `mem` = `.specify/memory/*` · `trace` = `specs/NNN-feature/traceability.md` · `hist` = prior spec revision |
| **BABOK** | Grounding: task number + quality characteristic, or technique. Locked house decisions cited as `plan Qn/Cn`. |
| **Chk** | **M** = deterministic (parse, lint, ID-graph — becomes scripts in Phase 2) · **A** = agent-evaluated against this contract's wording (becomes gate-agent checks in Phase 2) · **⚑** modifier = the BA individually reviews this assertion's evidence and signs it, even on a PASS (see BA authority). |

**BABOK layering.** The BABOK tags are methodology-layer grounding — the audit trail from every assertion back to the body of knowledge, for BA training, review, and positioning. Compiled build artifacts (Phase-2 checker scripts, gate-agent prompts) carry assertion text + CC-IDs only; the runtime never loads this document. The chain stays verifiable one-way: script → CC-ID → contract line → BABOK anchor.

**BA authority.** There are deliberately **no assertions tagged "BA judgment"**: an assertion that needs unstructured judgment is a quality wish and violates the design rule. The BA's judgment enters as *authority over verdicts*, through three instruments:

1. **Override** — an A-checker's verdict is wrong (false positive). The BA rules PASS on that assertion, with a logged reason; overrides feed checker tuning (§10).
2. **Waiver** — the gap is real and consciously accepted (§8).
3. **Approval** — the gate never self-certifies. FAIL is final until fixed, overridden, or waived; **PASS becomes effective only as a BA act** (BABOK 5.5 Approve Requirements). The 5.5 approval is holistic — a clean report can be approved quickly. **⚑-marked assertions are the exception:** the BA individually reviews that assertion's evidence and signs it even inside an otherwise clean PASS — skimming is not an option on a ⚑ line. The ⚑ set is **CC-XA-01 and CC-XA-06**: the two calls the BA answers for personally — authorization (a false pass is a security incident) and the scope boundary (a false pass ships drift outside the epic's agreed scope).

**Pass binding.** A PASS certifies the exact spec revision and dependency state evaluated. Any subsequent edit to `spec.md` or to a checked dependency voids the pass — re-gate before handoff. This is Q5 made enforceable: the certified text is the read text.

**BABOK anchors used:** 4.3 Confirm Elicitation Results · 5.1 Trace Requirements · 5.2 Maintain Requirements · 5.3 Prioritize Requirements · 5.5 Approve Requirements · 7.1 Specify & Model Requirements · 7.2 Verify Requirements (characteristics: atomic, complete, consistent, concise, unambiguous, testable, prioritized) · 7.3 Validate Requirements · 7.4 Define Requirements Architecture · techniques 10.1 Acceptance & Evaluation Criteria, 10.2 Backlog Management, 10.9 Business Rules Analysis, 10.12 Data Dictionary, 10.15 Data Modelling, 10.23 Glossary, 10.24 Interface Analysis, 10.30 Non-Functional Requirements Analysis, 10.35 Process Modelling, 10.39 Roles & Permissions Matrix, 10.41 Scope Modelling, 10.43 Stakeholder List/Map/Personas, 10.44 State Modelling, 10.47 Use Cases & Scenarios, 10.48 User Stories.

---

## 3. Two scopes, and when each runs

| Scope | Assertions | Trigger | Effect |
|---|---|---|---|
| **Scope F — feature gate** | CC-G + CC-OV…CC-XA (§4–§5) | Band 3: spec authored → **before Mode-A handoff**. Re-runs after any edit to the spec or a checked dependency (pass binding, §2). | BA-approved PASS unlocks `/speckit.plan` for this feature. FAIL returns the spec with named gaps. |
| **Scope H — project health** | CC-H (§6) | Cadence table below. | FAIL blocks nothing by itself but blocks any Scope-F run that depends on the failing artifact — a feature gate against rotten shared artifacts is meaningless. |

**Scope-H cadence:**

| Run | Trigger | Coverage |
|---|---|---|
| **Full** | Band-1 closure — the run that arms the system | all spec-anchored artifacts |
| **Full** | after each scope-brief ingestion (batch-end, once cross-cutting findings are routed) | all |
| **Full** | on demand — recommended as a session-start habit | all |
| **Scoped — silent unless FAIL** | every *framework* write to a governance/context artifact | the touched artifact + its dependents |
| **Pre-flight subset** | start of every Scope-F run | this feature's dependencies |
| **Disarmed** | before Band-1 closure — in-band quality belongs to the aspect gates (document 5) | — |

Two operating principles:

- **Smallest sufficient scope.** On any trigger the runner recommends the narrowest scope that answers the question and states scope + rationale before running ("scoped check: glossary + 2 dependents — nothing else changed" · "full run: ingestion touched 4 artifacts"). The BA may widen or narrow. This is plan §9's token-bloat risk enforced at the health layer.
- **Lazy detection.** Out-of-band hand edits trigger nothing — there is no daemon watching the files. Drift, and the pass-voids it causes (§2 pass binding), are caught at the next framework touchpoint: a scoped/full run or the pre-flight subset. Hence the session-start habit; pre-flight remains the hard guarantee.

Scope H is decision **Q7 made enforceable**: Governance and Context artifacts are spec-anchored — kept alive on every change — and Scope H is the check that they actually are.

Cross-artifact *reads* occur wherever consistency demands (several F-categories read `canvas`, `roles`, `gloss`, `dm`, `brief`). Category C12 concentrates the assertions about the **dependencies' own coverage** for this feature.

---

## 4. Global assertions (CC-G) — whole-spec

Apply to `spec.md` as a whole, before and alongside the category checks.

| ID | Assertion (pass condition) | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-G-01 | `spec.md` exists at `specs/NNN-feature/spec.md`; all ten §2-standard headings present, with exact names, in exact order. | spec | 7.4 · 7.1 | M |
| CC-G-02 | No stub content: every required section contains substantive, feature-specific content or explicit `N/A — <reason>`. Empty bodies, placeholder tokens (TBD, TODO, "to be defined", template boilerplate) fail. **The marker namespace is closed:** the framework defines `[NEEDS CLARIFICATION: …]` and `[CONFLICT: …]` and no others. Any further bracketed token of marker shape — an upper-case label, with or without a colon: `[ASSUMED: …]`, `[TBD]` — is a mint, is not content, and fails wherever it stands in place of required content, a table cell included. A mint is converted to `[NEEDS CLARIFICATION: …]`, never honoured. | spec | 7.2 complete | A |
| CC-G-03 | Zero unresolved `[NEEDS CLARIFICATION]` markers. Each is resolved in the text or converted into a logged waiver that names the open question. | spec | 7.2 complete · 4.3 | M |
| CC-G-04 | Zero banned words (standard §4 list) in stories, FRs, acceptance, flows, business rules, NFRs. Exemption: verbatim user-visible copy inside quotation marks. | spec | 7.2 unambiguous | M |
| CC-G-05 | Zero implementation prescriptions: no technology choices, endpoints, storage schemas, or UI layout directives. Naming an external system as a mandated constraint (integration touchpoint) is not a violation; choosing the solution stack is. | spec | 7.1 · standard rule 1 | A |
| CC-G-06 | Every normative statement (SHALL / MUST) lives inside an ID-bearing structure (FR, BR, NFR, AC). Normative language in Overview, flow prose, or notes fails — an untracked requirement is invisible to the traceability graph. | spec | 5.1 · 7.2 | A |

---

## 5. The twelve categories (Scope F)

**Derivation (locked in review).** The plan (§5, Band 3) fixes the gate's nature — multi-artifact, stubs fail, named gaps — without enumerating categories. The twelve map 1:1 onto the locked spec skeleton (standard §2): ten sections become eleven categories (User Stories splits into *Stories* and *Acceptance*; *References* folds into *Traceability*, which also absorbs standard §13), plus **C12 Cross-Artifact Dependencies** for the plan's multi-artifact clause.

### C1 · Overview & Value (CC-OV)
*Intent: the feature is anchored to real, named value — BABOK 7.3 as a checkable link, not a vibe.*

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-OV-01 | The Overview states what the feature does and the user/business problem it addresses, with no solution design. | spec | 7.3 | A |
| CC-OV-02 | The value claim names at least one objective or problem that resolves to `canvas.md` (Problems / Objectives) or to the parent epic scope brief. | spec+canvas+brief | 7.3 | A |

### C2 · User Stories (CC-US)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-US-01 | ≥ 1 story exists; every story matches `US<N> (P<1|2|3>) — As a <role>, I want <capability>, so that <value>` with all three clauses filled. | spec | 10.48 | M |
| CC-US-02 | Every story actor matches a role defined verbatim in `roles-permissions.md`. Unmatched actors — including "user" and persona names — fail. | spec+roles | 10.39 | M |
| CC-US-03 | Every story carries exactly one priority; the feature has ≥ 1 P1. | spec | 5.3 | M |
| CC-US-04 | Story IDs are unique; IDs of deleted stories are not reused (checked against prior revision where one exists). | spec+hist | 5.2 | M |
| CC-US-05 | Each story expresses one capability. A capability clause that chains behaviors ("and", "manage", "handle") fails. | spec | 7.2 atomic | A |

### C3 · Acceptance Criteria (CC-AC)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-AC-01 | Every story carries ≥ 1 acceptance item directly beneath it (checklist line or Gherkin scenario). | spec | 10.1 | M |
| CC-AC-02 | Every checklist criterion is a single verifiable assertion about observable system behavior. | spec | 7.2 testable | A |
| CC-AC-03 | Every Gherkin scenario uses concrete data — named actors, real timestamps, quantities. Placeholder values (`<x>`, "some", "a user") fail. | spec | 10.47 · 7.2 testable | A |
| CC-AC-04 | No Gherkin scenario re-narrates its FR: each adds a concrete path or data combination the FR text does not spell out; otherwise it must be a checklist line. | spec | 7.2 concise | A |

### C4 · Functional Requirements (CC-FR)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-FR-01 | Every FR parses as exactly one of the five EARS patterns or a legal combination; keywords capitalized. (Vendored EARS lint.) | spec | 7.2 unambiguous | M |
| CC-FR-02 | Exactly one SHALL per FR; no "or" alternation between responses. | spec | 7.2 atomic | M |
| CC-FR-03 | Each FR specifies one behavior — a single trigger→response. A compound response is legal only as one observable outcome (create + display confirmation); chained independent behaviors fail and must split. | spec | 7.2 atomic | A |
| CC-FR-04 | Every FR names its actor and its specific object, and its response is externally observable. "Update the record" fails. | spec | 7.2 unambiguous | A |
| CC-FR-05 | Every FR carries `FR-0NN (US<n>)`; the referenced story exists; FR-IDs are unique; deleted IDs are not reused. | spec+hist | 5.1 | M |

### C5 · Flows, States & Errors (CC-FL)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-FL-01 | The main flow is present as numbered steps, each with actor → action → observable result. | spec | 10.35 | A |
| CC-FL-02 | ≥ 1 alternate or error path is documented. A happy-path-only flow fails. | spec | 10.47 · 7.2 complete | M |
| CC-FL-03 | Every error row states trigger + system behavior + user-visible outcome; none of the three empty or generic ("show error"). | spec | 7.2 complete | A |
| CC-FL-04 | Every row of the alternates/errors table is governed by a requirement in this spec: an unwanted-behavior FR (IF … THEN, WHILE) for an error, an event-driven FR (WHEN) where the row is an alternate, or a BR the row's behavior applies. Coverage is semantic — the evaluator searches the spec's FR (§3) and BR (§6) lists and fails only where no governing requirement exists; an inline citation such as `(FR-002)` is permitted style, never the pass condition, and the template's four columns are the table's whole shape. The evidence names, per row, the governing FR or BR, or `none`. Unspecified error handling fails with the row named. | spec | 5.1 | A |
| CC-FL-05 | Every state name used in flows, FRs, or acceptance exists in the Data section's states table (where the entity has a lifecycle). | spec | 10.44 | A |

### C6 · Non-Functional Requirements (CC-NF)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-NF-01 | Every NFR is metric + target + condition. | spec | 10.30 · 7.2 testable | A |
| CC-NF-02 | All six categories — performance · security/privacy · availability · accessibility · localization · scale — carry ≥ 1 NFR or an explicit `N/A — <reason>`. Silence fails. (Reason quality falls under CC-G-02.) | spec | 7.2 complete | M |
| CC-NF-03 | No NFR restates a global budget from governance; the spec adds feature-specific deltas only, referencing the global. | spec+gov | standard rule 5 · 5.2 | A |

### C7 · Business Rules (CC-BR)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-BR-01 | Every BR is one testable rule with a stable BR-ID; computational rules include the formula or threshold. | spec | 10.9 | A |
| CC-BR-02 | BR-IDs are unique; every BR referenced from FRs, acceptance, or flows exists. | spec | 5.1 | M |
| CC-BR-03 | Cross-feature rules are referenced from governance, never restated. | spec+gov | standard rule 5 | A |

### C8 · Data Requirements (CC-DA)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-DA-01 | Every entity named in the spec exists in `domain-model.md`. A new entity requires a domain-model update first, then a reference. | spec+dm | 10.15 | A |
| CC-DA-02 | The fields table covers every field this feature reads or writes: entity · field · type · required · validation, all filled. | spec | 10.12 | A |
| CC-DA-03 | Every validation is concrete — format, range, limit, or source of allowed values. "Valid input" fails. | spec | 7.2 unambiguous | A |
| CC-DA-04 | Where an entity has a lifecycle: the states table lists every state; every state has allowed transitions with triggers or an explicit terminal mark. | spec | 10.44 | A |

### C9 · Integration Touchpoints (CC-IN)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-IN-01 | Every external system named anywhere in the spec or the epic scope brief appears in the Integration table — and every table entry is actually used by the feature. If none exist: explicit `N/A — no external touchpoints`. | spec+brief | 10.24 | A |
| CC-IN-02 | Every integration row is complete: system · direction · what is exchanged (payload meaning) · constraint. | spec | 10.24 | A |
| CC-IN-03 | Every integration has a declared failure expectation — what happens when the external system is down — linked to a WHILE/IF FR or an error path. | spec | 7.2 complete | A |

### C10 · Out of Scope (CC-OS)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-OS-01 | The section contains ≥ 1 exclusion. Sibling features of the same epic and adjacent roadmap epics always supply a plausible expectation to fence off; the degenerate case takes a logged waiver, never a silent N/A. | spec | 10.41 | M |
| CC-OS-02 | Every exclusion names where it lives instead: a phase, an epic/feature, or "not planned". | spec | 10.41 | A |
| CC-OS-03 | No exclusion restates the global out-of-scope artifact; product-level boundaries are referenced. | spec+oos | standard rule 5 | A |
| CC-OS-04 | Nothing excluded here is simultaneously specified by a story or FR of this spec. | spec | 7.2 consistent | A |

### C11 · Traceability & References (CC-TR)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-TR-01 | The chain is complete: every US has ≥ 1 FR and ≥ 1 acceptance item; every FR maps to an existing US; zero orphans in either direction. | spec | 5.1 | M |
| CC-TR-02 | The References section lists `roles-permissions.md`, `glossary.md`, `domain-model.md`, and the parent epic scope brief with resolvable paths; all four files exist. | spec+mem | 5.1 | M |
| CC-TR-03 | Roles declared in References equal the roles used in the spec body — no unused declarations, no undeclared uses. | spec | 5.1 | M |
| CC-TR-04 | `traceability.md` exists in the feature folder and covers every FR-ID with its source chain (aspect → technique / scope-brief item → FR → acceptance). The file is **generated at gate time**, never hand-authored — a PASS certifies it as the snapshot of the evaluated revision (mechanics in document 4). | trace | 5.1 | M |

Generation granularity for CC-TR-04 = what is structurally derivable: FR ⇄ US ⇄ acceptance · US → parent scope brief · technique provenance where the framework itself produced the content. Finer links to individual brief items would need a new structured tag in the writing standard — post-v1.

### C12 · Cross-Artifact Dependencies (CC-XA)
*Intent: the plan's multi-artifact clause. The spec references upstream truth; this category asserts that the upstream truth actually covers this feature. Both ⚑ assertions live here (§2, BA authority).*

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-XA-01 | **Authorization coverage:** for every role × entity × action tuple this feature's stories and FRs exercise, `roles-permissions.md` contains an explicit policy row. Missing tuples fail with the tuple named. | spec+roles | 10.39 | A ⚑ |
| CC-XA-02 | No persona name appears as an actor anywhere in the spec; authorization derives from roles only (constitution principle; plan §4.6 persona→role transformation enforced). | spec+mem | plan Q1a/§4 · 10.43 | M |
| CC-XA-03 | Every domain term used exists in `glossary.md`, and the glossary's canonical term is the one used — no synonym drift within the spec or against the glossary. | spec+gloss | 10.23 · 5.2 | A |
| CC-XA-04 | Every entity relationship the spec relies on (flows, data, FRs) exists in `domain-model.md`. | spec+dm | 10.15 | A |
| CC-XA-05 | The parent epic scope brief exists at its path, and this feature appears in the epic's feature slicing (proposed in the brief, confirmed at delivery-loop entry per plan C3). | brief | 10.41 · plan C2/C3 | M |
| CC-XA-06 | The spec stays inside the brief: nothing specified falls into the epic's excluded or deferred scope; every open question in the brief that touches this feature is resolved in the spec or carried as a waiver. | spec+brief | 4.3 · 7.2 consistent | A ⚑ |
| CC-XA-07 | Nothing lives only in the spec: every role, term, entity, or constraint the spec introduces exists in its governance/context home. A spec-only definition fails — define upstream, then reference. | spec+mem | standard rule 5 · 5.2 | A |

---

## 6. Project health assertions (Scope H, CC-H)

| ID | Assertion | Checks | BABOK | Chk |
|---|---|---|---|---|
| CC-H-01 | Every spec-anchored artifact (`.specify/memory/*`, `canvas.md`, `constitution.md`) exists and passes the stub test (CC-G-02 logic). | mem+canvas+gov | 5.2 | A |
| CC-H-02 | Roadmap discipline: every epic carries a status; every re-allocation entry logs a diff and a reason. | roadmap | 10.2 · plan C1 | M |
| CC-H-03 | Every epic entering Band 3 has a scope brief containing a proposed feature slicing. | brief+roadmap | plan C2/C3 | M |
| CC-H-04 | Glossary hygiene: every entry is defined (no stub entries); no duplicate or synonymous entries left unmerged. | gloss | 10.23 · 5.2 | A |
| CC-H-05 | Role registry consistency: every role referenced anywhere in `memory/` or existing specs exists in `roles-permissions.md`; no policy row references an undefined role or entity. | roles+mem | 10.39 | A |
| CC-H-06 | Every governance file the constitution references exists and is stub-free. | gov | 5.2 | M |
| CC-H-07 | No standing acceptance-shape conflict is unresolved: every epic allocated outside the delivery boundary and every global out-of-scope entry that matches a `standing` `AS-<n>` entry (orchestrator §2.4) carries a recorded BA ruling — an ADV disposition, `superseded — SD-<n>`, or `accepted — <reason>`. | roadmap+oos+ledger head | 10.1 · 7.2 consistent | A |

---

## 7. Failure output — the gate report (artifact #18)

**Named-gap grammar.** Every failure line has the form:

```
CC-<ID> FAIL — <element>: <what is wrong> → <fix action>
```

`<element>` is the specific FR-ID, US-ID, term, tuple, table row, or section. **A failure that does not name its element and its action is itself invalid gate output** — the gate meets its own bar.

**Report format** — appended per run to `specs/NNN-feature/gate-report.md`:

```
## Gate run <n> — <date>
Feature: <NNN-feature> · Spec revision: <id/hash> · Scopes: F (+H pre-flight)
Verdict: PASS | PASS WITH WAIVERS | FAIL (<n> gaps)

Failures:            (each in named-gap grammar; non-waivable marked)
Waivers in force:    (table, §8 format)
Overrides this run:  (table, §8 format)
⚑ sign-offs:         (CC-XA-01 · CC-XA-06: evidence reviewed, BA initials —
                      required for any effective PASS)
Category summary:    (per category: checked / passed / failed / waived counts)
BA approval:         <name, date> — required for any effective PASS
```

**Worked example** (running example from the standard — appointment booking):

```
## Gate run 2 — 2026-07-17
Feature: 004-appointment-booking · Spec revision: r5 · Scopes: F (+H pre-flight)
Verdict: FAIL (5 gaps)

Failures:
CC-XA-01 FAIL [non-waivable] — (Specialist × Appointment × cancel): no policy
  row in roles-permissions.md, but US3/FR-009 exercise it → add the row
  (governance change) or remove Specialist-initiated cancellation from scope.
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable
  target, or move the concern to an NFR with metric + condition.
CC-AC-04 FAIL — US1 / scenario "Successful booking": re-narrates FR-001,
  no new data or path → convert to a checklist line, or make it carry the
  race-for-last-slot path with concrete data.
CC-NF-02 FAIL — accessibility: no NFR and no N/A — <reason> → add one
  or declare N/A with a reason.
CC-TR-01 FAIL — US4: zero FRs reference it (story is unbuilt) → author its
  FRs or drop/demote the story.

Waivers in force:
W-004-01 · CC-IN-03 · calendar-sync failure expectation deferred ·
  reason: provider contract unsigned · risk: manual reconciliation during
  pilot · approver: Y.K. · revisit: before Phase-3 pilot exit.

Overrides this run:
O-004-01 · CC-AC-04 · US2 / scenario "Cancellation at the 24h boundary":
  checker flagged re-narration; BA rules it adds the boundary datum BR-002
  leaves implicit · approver: Y.K. → logged for checker tuning.

⚑ sign-offs: — (verdict FAIL)

Category summary: 61 checked · 54 passed · 5 failed · 1 waived · 1 overridden
BA approval: — (verdict FAIL; resubmit after fixes; W-004-01 remains valid
  unless §Integration Touchpoints or the brief is edited)
```

---

## 8. Waivers & overrides

**Waiver = the gap is real and consciously accepted.** Delivery proceeds with the risk on the record, never silently.

| Field | Content |
|---|---|
| Waiver ID | `W-<NNN>-<nn>` per feature |
| Assertion + element | The CC-ID and the specific named gap being waived |
| Reason | Why the gap is accepted now |
| Risk accepted | What can go wrong downstream, in one line |
| Approver · date | The BA, by name |
| Revisit trigger | The event that forces re-evaluation ("before pilot exit", "when provider contract signs") |

**Lifecycle:** a waiver is valid for the feature's current delivery cycle · it is voided automatically when the waived section or checked dependency is edited · it is re-affirmed (one line) at each re-gate. Waivers live in the feature's `gate-report.md`. The void-on-edit rule is section-level and deliberately coarse: the framework cannot reliably judge whether an edit relates to the waived gap, so it errs toward asking — a false re-affirmation costs one line; a stale waiver costs an incident. Revisit triggers are read by the BA at re-affirmation, not scheduled by the framework (no daemon — §3 lazy detection).

**Markers and waivers.** A waived `[NEEDS CLARIFICATION]` marker stays in the spec text as the gap's named location; the waiver is its acceptance record. Under Mode A the coding agent therefore reads a deliberately marked, consciously accepted unknown — never a hidden one. **A marker's presence discharges nothing:** whether a marked cell satisfies the obligation an assertion asks about is answered by the cell's stated content, never by the marker — the rule is the gate's (v0.12 §5.2, *a marker is evidence, never coverage*), stated once there; the waiver over the CC-G-03 gap is the only act that accepts what the marker names.

**Override = the checker is wrong.** Same record shape, `O-<NNN>-<nn>`, with "why the verdict was a false positive" instead of risk; every override feeds the tuning log (§10). An override means the assertion *passes*; a waiver means it *fails and we proceed anyway*. Never conflate them.

**Non-waivable set (locked):**

| ID | Why no waiver can exist |
|---|---|
| CC-G-01 | An unparseable structure breaks every downstream consumer, including this gate. |
| CC-G-02 | An *unnamed* gap cannot be risk-accepted. The path is: name it — convert the stub to `[NEEDS CLARIFICATION: …]`, which fails CC-G-03, which **is** waivable. Every accepted gap is thereby a named gap, by construction. |
| CC-FR-01 | EARS is the house grammar. Waiving it un-defines what a requirement is. What genuinely resists EARS is nearly always an NFR, a business rule, or design in disguise — the fix is re-classification, not exemption. |
| CC-TR-01 | A broken story⇄FR graph breaks `/tasks` tagging ([US1], [US2]) and BA verification downstream. |
| CC-XA-01, CC-XA-02 | Authorization is the one class where a confident agent guess is a security incident, and the constitution's "never infer permissions from personas" principle exists precisely to be unwaivable. |

Everything else is waivable with a full record. **CC-XA-05 is waivable by design:** it is the urgent-feature escape valve — a feature may enter delivery without Tier-1 scoping only through a logged waiver naming that risk. A formal hotfix path is post-v1.

---

## 9. Coverage — writing-standard §15 mapping

The self-check is the writer rehearsing this gate; the gate re-runs it with instruments and adds what a writer cannot self-verify.

| §15 self-check item | Contract assertions |
|---|---|
| 1 · Zero technology / endpoints / UI layout | CC-G-05 |
| 2 · Every FR: one SHALL, EARS, linked story, observable | CC-FR-01…05 |
| 3 · Zero banned words / marked clarifications | CC-G-04, CC-G-03 |
| 4 · Every story has acceptance; Gherkin concrete and additive | CC-AC-01…04 |
| 5 · Structured data in tables; entities in domain model | CC-DA-01…02, CC-XA-04 |
| 6 · Every error path: trigger + behavior + outcome | CC-FL-02…04 |
| 7 · Every NFR: metric + target + condition or N/A | CC-NF-01…02 |
| 8 · Roles/terms referenced, never redefined | CC-US-02, CC-TR-03, CC-XA-03, CC-XA-07 |
| 9 · Out of Scope: every exclusion names its home | CC-OS-01…04 |
| 10 · No stubs; unknowns carry `[NEEDS CLARIFICATION]` | CC-G-02, CC-G-03 |

**Enforcement-only additions** (no §15 counterpart, by design — the writer can't self-verify them): CC-OV-02, CC-G-06, CC-FL-05, CC-NF-03, CC-BR-02…03, CC-DA-03…04, CC-IN-01…03, CC-TR-01…02, CC-TR-04, CC-XA-01…02, CC-XA-05…06, and all of Scope H.

---

## 10. Continuous improvement — the catch-rate rule

Phase 3 measures **first-pass correctness and gate catch-rate** (plan §8). This contract is the catch-rate's denominator.

**Rule:** any requirements defect that escapes this gate and is caught downstream — by `/speckit.checklist`, `/speckit.analyze`, plan- or tasks-time confusion, or an implementation defect traced back to spec ambiguity — is logged as a **contract-gap candidate**, tagged with the assertion that should have caught it (or "none — new class"). Accepted candidates and accumulated override patterns (§8) bump the contract version. The backstop's job is to shrink to zero catches; every catch it makes is our defect, not its success.

The same evidence path governs demotion: an assertion producing ritual compliance (e.g., invented exclusions to satisfy CC-OS-01) or chronic false positives is a logged pattern that bumps the contract. Phase 3's mandate — iterate contract and prompts, not tooling — runs through this section.

---

## 11. Review record (v0.1 → v0.2)

Ten decisions ruled by the BA Lead, 19 July 2026:

1. **Category set** — the derived twelve confirmed and locked (§5).
2. **Non-waivable set** — the six confirmed; CC-XA-05 deliberately waivable as the urgent-feature valve (§8).
3. **Checker taxonomy** — M/A plus BA authority (override · waiver · approval); no J-tagged assertions (§2).
4. **⚑ scope** — extended to CC-XA-01 + CC-XA-06: per-assertion evidence sign-off even on PASS (§2).
5. **`[NEEDS CLARIFICATION]`** — fail-then-waive; converted markers stay in the text as named locations (§8).
6. **CC-OS-01** — ≥ 1 exclusion mandatory; degenerate case = waiver, not N/A (§5 C10).
7. **Scope-H cadence** — revised after real-world walkthrough: full at closure / ingestion / on-demand · scoped silent checks on framework writes · disarmed pre-closure · lazy detection + smallest-sufficient-scope principles (§3).
8. **Waiver lifecycle** — cycle-bound · void-on-edit (section-level, coarse by design) · re-affirm-on-re-gate (§8).
9. **Traceability file** — generated at gate time; structurally derivable granularity only (§5 C11).
10. **`CC-` prefix** — confirmed; CC = Completeness Contract (§2).

---

*v0.4 · two cards re-cut, no row added (EC-21, `apply all`): CC-G-02 — the marker namespace closed at the framework's two markers, any other bracketed token of marker shape a mint that is not content and fails wherever it stands, a cell included, converted and never honoured — the class fix reaching every cell-reading assertion through the namespace · CC-FL-04 — one standard, the semantic one: governed by an IF/THEN or WHILE FR for an error, a WHEN FR for an alternate, or a BR, the evaluator searching the FR and BR lists, a citation style and never the pass condition, the four-column table untouched, the evidence per row naming the FR, the BR or `none` · CC-G-03 untouched · assertion count unchanged at 62 (24 M · 38 A) — applied 25 Aug 2026 (companions: gate v0.12 §4.1 · §5.2 · §5.3 · §7.1 · §9.2 — a marker evidence and never coverage, compute always and sign separately, a changed card never carried · writing standard v0.6 rule 7 · elicitation v0.10 D14) · v0.3 · CC-H-07 — the acceptance cross-check row (§6), applied 19 Aug 2026 (EC-02, `apply all`; classing, counting and run points the gate's — gate v0.11 §10.2 · §10.4) · assertion count: 62 (6 global · 49 across C1–C12 · 7 project-health) · v0.2 · review incorporated 19 July 2026 · ⚑: CC-XA-01 · CC-XA-06 · non-waivable: CC-G-01 · CC-G-02 · CC-FR-01 · CC-TR-01 · CC-XA-01 · CC-XA-02 · runs on top of writing standard v0.6 · consumed by gate definition (document 4)*
