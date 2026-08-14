# Geniusee Technique Catalogue — Batch B4
### BA-Native Spec · Wave 2 · Requirements core chain · v0.2 — review incorporated (29 July 2026)

**What this is:** sheets T-11–T-13 of the 18-sheet catalogue (sequencing plan §1), authored to the §2 uniform template in the pinned within-batch order: domain model → roles & permissions → core processes. B4 is the wave's hard dependency chain, one session (plan §3, B4 rationale): entities (T-11) exist before the policy rows that reference them by name (T-12, CC-H-05), and roles exist before the journeys of significant roles cite them (T-13). The batch consumes both standing cross-batch pins: T-11 opens on **EG-1** (catalogue-b3, T-10 §5, D-B3-5 — the completed Core Function lines and Third-Party rows as the entity-implication surface), and T-12 lands the wave's first cross-batch dependency — the persona→role transformation consuming **TC-1…TC-3** (catalogue-b2, T-04 §5, D-B2-2). Class mixes here (Context + Governance) — dependency trumps class in batching (plan §3, B4 rationale).

**Rulings in force (restated once):** every sheet authored from scratch; presale skills are reference designs to mine, never components (elicitation v0.3 §7/§11). No ★ sheet exists in this batch — all three follow the elicitation-§7.1 no-reference pattern. Micro-examples stay in the appointment-booking world at its **pre-RO-1 state** (catalogue-b1 convention): Specialists self-publish availability, no Clinic Admin yet; the Requirements seeds land 07-09 → 07-10, before Band-1 closure arms Scope H. Prior-batch sheets (T-01–T-03, catalogue-b1 v0.2 · T-04–T-07, catalogue-b2 v0.2 · T-08–T-10, catalogue-b3 v0.2) are cited, never restated. This batch's Requirements ground carries the handover rule (orchestrator §3.3): AT-RQ is the pre-arming image of CC-H — these sheets seed what Scope H then owns for life. Decisions D-B4-1…D-B4-4 are locked (review record below); the locked text stands inline at each sheet.

---

## T-11 · Domain (conceptual) modeling
Band 1 · serves: Requirements · class: Context · target: #8 domain model · ★ —

### 1. Purpose & BABOK grounding
Seeds the conceptual model — the business entities the core functions imply, with business-level relations — so every downstream artifact names entities against one reference surface instead of minting its own. This is the chain's first link by construction: T-12's policy rows reference these entities by name (CC-H-05), T-13's journeys touch them, and at gate time CC-DA-01/CC-XA-04 resolve every spec entity and relationship here. The sweep opens on exactly the EG-1 surface (catalogue-b3, D-B3-5 — cited, never restated): function objects as entity candidates, connection systems as boundary references. Conceptual level only — business entities and relations, kept distinct from per-feature data (plan Q3 boundary; plan §4.8). The decision this technique lets the BA make: this is the entity vocabulary of the domain — what exists, how it relates, and what stays outside the boundary. BABOK: 10.15 Data Modelling · 10.13 Concept Modelling · 10.23 Glossary (term discipline) · 4.3 Confirm Elicitation Results. House: plan §4.8; D-O1 (Requirements allocation); AT-RQ-4 wording (entity clause); EG-1 (D-B3-5, catalogue-b3).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-4 (entity clause) — `domain-model.md` absent or stubbed (nothing seeded) · an EG-1 function object (canvas §7) resolves to no entity entry — the entity-implication pattern · entities stand relation-less where the function lines' verb–object structure implies a relation ("with business-level relations" unmet) · a §3.5-routed entity or relationship arrival stands unincorporated in the model. |
| Skip-if | AT-RQ-4's entity clause reads met in the current evidence table (e.g., a conceptual model carried from a prior engagement, confirmed current against the framed canvas). Enrichment beyond the threshold — attribute inventories, data dictionaries (post-v1, plan §10), full ERD notation — only on BA ask (§6.1). |
| Depth | Elicits at conceptual grade: per entity — glossary-canonical name, one business line, source; per relation — from · relation · to, multiplicity written only where a source states it. Must NOT descend into per-feature fields, types, or validations (spec Data ground, standard §9 — the plan-Q3 boundary) · state and lifecycle tables (CC-DA-04 spec ground) · term definitions (T-02's ground — a definitional gap routes to the glossary first, rule 3; the entity line adds relational identity, never a rival definition) · policy rows (T-12) · journeys (T-13) · treating external systems as entities (they are boundary references — `context.md` and canvas §8 own them) · integration payloads or directions (brief §4 / CC-IN spec ground). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Domain model at seed grade: Entities table (glossary-canonical names, one business line each, sourced) · Relations table (from · relation · to · multiplicity-where-stated · source) · Boundary references list (each EG-1 connection system disposed as external, pointing at its `context.md` / canvas §8 home). Canonical form is tabular; any diagram is a derived view, never the source of truth (D-B4-1, locked) |
| Artifact class | Context (spec-anchored — Q7; joins the CC-H-01 estate at arming) |
| Destination file | `.specify/memory/domain-model.md` |

### 4. Procedure
1. **BA act:** open Requirements (T1 — Solution cleared or waived); compose the plan (P-O2); invoke T-11 (P-O3) — first of the chain: entities before the policy rows and journeys that name them (plan §3, B4 rationale).
2. **Framework act:** EG-1 sweep — open on the completed canvas §7 function lines and §8 connection rows (D-B3-5, catalogue-b3): each function object (verb + object, objects glossary-canonical) becomes an entity candidate; each connection system becomes a boundary-reference candidate, never an entity. Routed arrivals already in the file join the candidate set (arrival is never gated, §2.2). Cite-or-mark per line (principle 3).
3. **Framework act:** relation pass — business-level relations proposed from the function lines' verb–object structure and from presale/kickoff statements; multiplicity written only where a source states it, never inferred silently (cite-or-mark; an inferred multiplicity is drafted and marked).
4. **Framework act:** remaining holes become destination-tagged questions — an entity's identity or its one-line meaning, a relation's existence or multiplicity (principle 2; conceptual grade bounds the set, no numeric cap needed).
5. **BA act:** rule — confirm or edit entities and relations; rule each boundary reference (external stays external). Boundary routing + asymmetry (T-03 step 5's pattern): a candidate whose term is not yet in the glossary → glossary proposal first, entity row here (rule 3; §3.5 new-term row) · an entity implying an unrecorded today-system → `context.md` proposal (T-05's ground) · a finding contradicting cleared ground — a canvas function line, the register — is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `domain-model.md`; refresh the Requirements evidence table (§7.4) — AT-RQ-4 entity clause. The seeded entity set now stands as the reference surface T-12's policy rows and T-13's journeys cite by name — and, post-arming, the surface CC-H-05's entity side reads (gate §10.2).

### 5. Output template & micro-example
```markdown
# Domain Model — <project>

## Entities
| Entity | What it is (one business line) | Source |
|---|---|---|

## Relations
| From | Relation | To | Multiplicity (where stated) | Source |
|---|---|---|---|---|

## Boundary references (external — not entities)
- <system> — external system; lives in context.md / canvas §8
```
Micro-example — Requirements seed (pre-RO-1):

| Entity | What it is (one business line) | Source |
|---|---|---|
| Client | Books and cancels own Appointments | canvas: Customers · Core Functions |
| Specialist | Publishes own Availability; delivers Appointments | canvas: Customers · Core Functions |
| Availability | The bookable time a Specialist publishes | canvas: Core Functions · kickoff notes |
| Slot | One bookable unit of Availability | canvas: Core Functions · kickoff notes |
| Appointment | A Client's booking of a Specialist's Slot | canvas: Core Functions · kickoff notes |

| From | Relation | To | Multiplicity (where stated) | Source |
|---|---|---|---|---|
| Specialist | publishes | Availability | 1 Specialist : own Availability | canvas §7 publish line |
| Availability | consists of | Slot | 1 : 0..* | kickoff notes |
| Client | holds | Appointment | 1 : 0..* | canvas §7 Book · Cancel lines |
| Specialist | delivers | Appointment | 1 : 0..* | canvas: Customers |
| Appointment | occupies | Slot | exactly 1 Slot; a Slot carries at most 1 booked Appointment | kickoff notes |

Boundary references (external — not entities):
- Specialists' external calendars — external system; landscape row in `context.md` (catalogue-b2, T-05), connection row canvas §8 with direction open (D-B3-4) — nothing for the model to resolve.

Continuity, three threads: **(i)** the entity set is exactly EG-1's implication surface resolved — the function objects Availability, Slot, Appointment (catalogue-b3, T-10 §5) plus the two acting parties; **(ii)** the occupies-row's at-most-1 multiplicity is the business invariant feature 004's NFR-002 and race scenario later operationalize (standard §5, §7) — CC-XA-04 resolves that spec's flows against these rows; **(iii)** the hold mechanism (standard §6's 5-minute hold; glossary term Hold, standard §12) is deliberately absent — it is spec-born, feature-004 ground; if a future spec relies on a Hold relationship, CC-DA-01's update-first path brings it into the model then, never before.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-4 (entity clause) — entities the core functions imply, with business-level relations |
| Health hooks | CC-H-01 — `domain-model.md` in the spec-anchored estate from arming |
| Consumer hooks | CC-DA-01 — every spec entity exists here; new entity = model update first, then reference · CC-XA-04 — every entity relationship a spec relies on exists here |

Cross-layer consumers, on the record: **CC-H-05's entity side** reads this surface post-arming — no policy row may reference an entity undefined here (gate §10.2's domain-model row; T-12 applies the rule at authoring time) · Tier-1 kit input and Guard-1 answered-source (elicitation §3.2, §6) · Tier-2 context stack row 4 — entities and relationships the spec may rely on (elicitation §5.2) · gate static-core member and certification-manifest entry (gate §3, §11.1) · the §3.5 routing row lands every new entity or relationship finding here.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba-run T-11`; contract check at P-O3. Inputs loaded: `canvas.md` (§§7–8 first — the EG-1 surface) · `glossary.md` · `.specify/memory/context.md` · current `domain-model.md` (routed arrivals) · presale material and kickoff notes. Interaction: EG-1 sweep → relation pass → destination-tagged questions → BA rulings incl. boundary-reference rulings → write + routed batches (glossary-first, context). Outputs written: `.specify/memory/domain-model.md`, plus routed batches where the rulings demand them. §§2–5 above fix the method; Phase 2 adds the EG-1 line-parse rendering, the glossary-first routing assist, and an optional diagram derivation from the tables (a derived view only — D-B4-1, locked).

---

## T-12 · Roles & permissions, incl. the persona→role transformation
Band 1 · serves: Requirements · class: Governance · target: #14 roles-permissions · ★ —

### 1. Purpose & BABOK grounding
Seeds the role model and the resource×action policy — every role any Band-1 artifact references, defined once, with explicit policy rows for the tuples Band-1 evidence exercises — and houses the persona→role transformation (D-W3): where charters exist, TC-1 anchors each candidate to its register population and TC-2's activity lines are the sole transformation input; nothing else in a charter reaches authorization (catalogue-b2, T-04 §5, D-B2-2 — cited, never restated). The authorization *principle* is not authored here: "never infer permissions from personas" lives in `constitution.md` (#13 — T-15's ground, plan §4.14); this file is the principle's enforcement surface. Governance grade throughout: every role and row is a BA ruling, and the output is exactly what the ⚑ non-waivable CC-XA-01 sign-off later reads, tuple by tuple. The decision this technique lets the BA make: who may act, on what, and how far — stated as rows a checker and a coding agent read identically. BABOK: 10.39 Roles & Permissions Matrix · 10.43 Stakeholder List/Map/Personas (transformation input) · 4.3 Confirm Elicitation Results. House: plan §4.6 (personas-never-authorization), §4.14; D-W3; TC-1…TC-3 (D-B2-2, catalogue-b2); AT-RQ-2 and CC-XA-01/-02 wording.

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-2 — `roles-permissions.md` absent or stubbed · a role referenced by any Band-1 artifact (canvas function-line actors, register activity rows) has no role definition — the reference-surface pattern · personas exist and a persona name stands as an actor anywhere in a Band-1 artifact (the no-persona-as-role clause; the constitution-principle half of AT-RQ-2 is T-15's hole, not this sheet's) · a §3.5-routed role or permission finding stands unincorporated. |
| Skip-if | AT-RQ-2 reads met in the current evidence table (e.g., a role model carried from presale governance, confirmed; persona clause clean or dormant — charter absence leaves it dormant, catalogue-b2 T-04 §6). Enrichment beyond the threshold — exhaustive matrices for tuples no Band-1 evidence exercises — only on BA ask (§6.1). |
| Depth | Elicits at governance seed grade: per role — name, one-line mandate, derivation evidence, source; per policy row — one explicit role × entity × action tuple with its rule/scope qualifier and source. Must NOT infer permissions from persona narrative — TC-2 activity lines are the only charter input; goals, behaviors, frustrations never reach this file (plan §4.6) · author the constitution's principle text (T-15 ground) · mint persona-named roles or actors (TC-3; CC-XA-02's screened set) · complete per-feature tuple coverage for unsliced features (CC-XA-01 is gate-time, per-feature ground — the seed covers Band-1-evident tuples; later tuples enter by the gate and reopen paths, §6 note) · descend into UI permission surfaces or screen grades (T-14 governance / `/plan` ground) · map journeys (T-13). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Roles & permissions at seed grade: Roles table (role · mandate · derived-from · source; derivation naming its evidence — canvas actors, register rows, or charter TC-1/TC-2 lines) · Policy table — one explicit row per role × entity × action tuple, rule/scope qualifier per row, entities verbatim from `domain-model.md` (CC-H-05 applied at authoring time), no wildcard rows and no role inheritance at v1 (D-B4-2, locked); zero persona names anywhere (TC-3) |
| Artifact class | Governance (spec-anchored — Q7; joins the CC-H-01 estate at arming) |
| Destination file | `.specify/memory/roles-permissions.md` (plan §4.14) |

### 4. Procedure
1. **BA act:** under the composed Requirements plan (P-O2), invoke T-12 (P-O3) — after T-11: entities exist before policy rows reference them (CC-H-05; plan §3, B4 rationale).
2. **Framework act:** role derivation — candidate roles from the actors Band-1 artifacts reference: canvas §7 function-line actors and register activity rows (AT-RQ-2's own reference surface). A population or individual referenced as no actor derives no role — a stakeholder is register ground; an authorization role exists only where references or features exercise it (orchestrator §12.3's RO-1 deferral is the canonical statement). Cite-or-mark per candidate.
3. **Framework act:** the transformation — runs iff `personas.md` exists, exactly as AT-RQ-2's persona clause is conditional: per charter, TC-1 resolves the candidate's anchor (one register population); TC-2's system-facing activity lines are read as role-and-action evidence — the sole transformation input (D-B2-2, catalogue-b2 — cited, never restated). TC-3 screen: no persona name may surface as a role, an actor, or a row cell — the screened set is `personas.md`'s names (CC-XA-02).
4. **Framework act:** policy pre-draft — per derived role, explicit tuple rows (D-B4-2, locked), each citing its function line, activity line, or routed finding; entity cells verbatim from `domain-model.md`; a scope qualifier no source states is drafted and marked, never guessed (principle 3). Remaining holes become destination-tagged questions — a role's mandate, a row's scope (principle 2).
5. **BA act:** rule — every role and every row is a governance ruling; no row enters unruled (the §3.5 routing row's discipline — a governance change is proposed, never silently written — applied to the artifact's own seeding). The per-row evidence line is what makes the later CC-XA-01 ⚑ per-tuple sign-off cheap. A finding contradicting cleared ground — the register, a canvas line — is a reopen signal (§3.5 step 4 → P-O6).
6. **Framework act:** write `roles-permissions.md`; refresh the Requirements evidence table (§7.4) — AT-RQ-2. What stays deliberately out, on the record: tuples no Band-1 evidence exercises enter later per-feature — at gate time CC-XA-01 names the missing tuple and the row routes as a governance change (contract §7's gate run 2 is the worked case), or a reopen deferral injects it event-shaped (orchestrator §12.3's F2-trigger pattern). The seed's silences are the machinery's entry points, not gaps.

### 5. Output template & micro-example
```markdown
# Roles & Permissions — <project>
Authorization principle: stated in constitution.md (plan §4.14) —
this file is its enforcement surface, never its statement.

## Roles
| Role | Mandate (one line) | Derived from | Source |
|---|---|---|---|

## Policy
| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|
(one explicit row per tuple — D-B4-2, locked; entities verbatim from domain-model.md)
```
Micro-example — Requirements seed (pre-RO-1, canonical charter-free world):

| Role | Mandate (one line) | Derived from | Source |
|---|---|---|---|
| Client | Books and cancels own Appointments | canvas function actors — no personas exist; derivation on register + canvas alone | canvas: Core Functions · stakeholders.md |
| Specialist | Publishes own Availability; delivers Appointments | canvas function actors | canvas: Core Functions · stakeholders.md |

| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|
| Client | Availability | view | published Availability only | canvas §7 Browse line |
| Client | Slot | book | available Slots only; creates an Appointment | canvas §7 Book line |
| Client | Appointment | cancel | own only | canvas §7 Cancel line |
| Specialist | Availability | publish | own only | canvas §7 publish line |
| Specialist | Appointment | view | own only | canvas §7 Notify line — one-step consequence (Guard-1 citable grade) |

Continuity, four threads: **(i)** Specialist × Appointment × cancel is deliberately absent — no Band-1 line exercises it; it enters 2026-07-17 exactly as contract §7's gate run 2 records (CC-XA-01 FAIL naming the tuple → the row routes as a governance change) — the seed's silence is the mechanism working. **(ii)** Olena derives no role: sponsor individual, referenced as no actor — populations and individuals are register ground, roles are exercised ground (step 2's rule; orchestrator §12.3's deferral logic). **(iii)** the RO-1 deferred Clinic Admin role (trigger: F2 Band-3 entry) is the other canonical late-entry path — this table stays two-role at pre-RO-1. **(iv)** demonstrative transformation: had the Marta charter existed (catalogue-b2, T-04 §5's example), TC-2's activity lines — Browse · Book · Cancel own — corroborate the Client rows and add none, and "Marta" appears in no cell (TC-3 = CC-XA-02's screened set); the world's canonical artifacts are unchanged by it.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-2 — every referenced role defined; persona clause clean where personas exist |
| Health hooks | CC-H-05 — role registry consistency: every role referenced in `memory/` or specs exists here; no policy row references an undefined role or entity · CC-H-01 — in the spec-anchored estate from arming |
| Consumer hooks | CC-US-02 — every story actor matches a role defined verbatim here · CC-XA-01 ⚑ (non-waivable) — per role × entity × action tuple a feature exercises, an explicit policy row; the BA signs its evidence even on PASS · CC-TR-03 — References-declared roles equal spec-body roles |

Cross-layer consumers, on the record: **CC-XA-02** (non-waivable) enforces role-only authorization — this file is the only legal actor source; the screened persona set is `personas.md`'s names (TC-3) · Tier-2 context stack row 3 — loaded before drafting so actors exist verbatim and tuples are visible (elicitation §5.2) · Tier-2 answered-source, **deliberately not a Tier-1 kit input** — governance enters at Tier 2 (elicitation §3.2, §6: the Tier-1 answered-source list carries no roles file); a call finding that implies a permission routes here as a proposed governance change (§3.5) · gate static-core member and certification-manifest entry (gate §3, §11.1) · **T-15 (B5)** authors the constitution principle AT-RQ-2's persona clause and CC-XA-02 lean on — named at inventory identity only.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba-run T-12`; contract check at P-O3. Inputs loaded: `.specify/memory/domain-model.md` first (the entity reference surface) · `canvas.md` (§7 actors) · `.specify/memory/stakeholders.md` · `.specify/memory/personas.md` where it exists (TC-1/TC-2 read) · `glossary.md` · current roles file. Interaction: role derivation → conditional transformation (TC branch) → policy pre-draft with per-row evidence → destination-tagged questions → BA rulings on every role and row → TC-3/CC-XA-02 namespace screen at write time → write. Outputs written: `.specify/memory/roles-permissions.md`, plus routed batches where rulings demand them. §§2–5 above fix the method and the transformation's consumption of TC-1…TC-3; Phase 2 adds the TC-2 activity-line parser, a tuple-coverage rendering toward the CC-XA-01 sign-off view, and the automated TC-3 screen.

---

## T-13 · Core process mapping
Band 1 · serves: Requirements · class: Context · target: #9 core processes · ★ —

### 1. Purpose & BABOK grounding
Seeds the major journeys of each significant role — helicopter view with step descriptions, not tied to features (plan §4.9) — so every later scoping and drafting act can locate itself inside a journey instead of reconstructing one. Roles are cited verbatim from T-12's role model; entities by their `domain-model.md` names (T-11) — the chain's third link consumes the first two. This artifact is written for its consumption: a Tier-2 context-stack member (elicitation §5.2 row 5 — "where this feature sits in the journeys"), loaded into every Tier-2 run, and a Tier-1 kit input and answered-source (elicitation §3.2, §6). The decision this technique lets the BA make: these are the domain's major journeys, each owned by a named role, stated at a grade a later reader can navigate. BABOK: 10.35 Process Modelling · 10.47 Use Cases & Scenarios (journey grade, not scenario grade) · 4.3 Confirm Elicitation Results. House: plan §4.9; D-O1 (Requirements allocation); AT-RQ-4 wording (journeys clause).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements |
| Evidence triggers | AT-RQ-4 (journeys clause) — the core-processes file absent or stubbed · a significant role (D-B4-4, locked: actor of ≥ 1 canvas Core Function line) carries zero journeys — the primary-roles pattern · a §3.5-routed process finding stands unincorporated. |
| Skip-if | AT-RQ-4's journeys clause reads met in the current evidence table (e.g., journey maps carried from presale material, confirmed against the framed canvas and the role model). Enrichment beyond the threshold — swimlane suites, BPMN, exhaustive journey inventories — only on BA ask (§6.1). |
| Depth | Elicits at helicopter grade: per journey — name · role (verbatim from `roles-permissions.md`) · trigger → outcome · numbered steps as actor → action → observable result, entities by domain-model name. Must NOT descend into error paths and alternates (spec Flows ground, standard §6 — journeys are feature-agnostic; the unhappy paths are per-feature) · feature slicing or epic decomposition (Band-2 ground, T-17/T-18) · story or AC drafting (Tier-2 ground) · business-rule thresholds and timing values (spec BR ground — a journey never states a cutoff) · soliciting scoping settlements — who does a step today and whether that changes is legal Tier-1 ground (elicitation §3.3's table; the journey records what sources state) · screen flows or UX sequences (T-14 governance / `/plan` ground). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Core processes at seed grade: per significant role, the major journeys — each with name, role cited verbatim, trigger → outcome, and numbered helicopter steps touching domain-model entities by name; step numbering is journey-local (no cross-file line-ID scheme — D-B1-1's boundary: nothing downstream cites steps by line; consumers load the whole file) |
| Artifact class | Context (spec-anchored — Q7; joins the CC-H-01 estate at arming) |
| Destination file | `.specify/memory/processes.md` (D-B4-3, locked) |

### 4. Procedure
1. **BA act:** under the composed Requirements plan (P-O2), invoke T-13 (P-O3) — after T-12: journeys cite roles verbatim (plan §3, B4 rationale).
2. **Framework act:** significance pass — the significant-role set per D-B4-4 (locked: actor of ≥ 1 canvas §7 function line), proposed with its evidence; the BA may elect further roles (Q2 composition freedom).
3. **Framework act:** journey pre-draft — per significant role, major journeys assembled from the canvas §7 function lines (grouped into end-to-end sequences), the value lines they serve (`→ O-n` — a journey exists to move an objective), `context.md` where today's landscape shapes a step, and presale/kickoff statements; roles verbatim, entities by domain-model name; cite-or-mark per step (principle 3).
4. **Framework act:** coherence pass — every journey's role resolves to the role model; every entity touched resolves to the domain model; a miss is a proposed edit on T-11/T-12 ground (routed by batch), never a local definition (standard rule 5).
5. **Framework act:** remaining holes become destination-tagged questions — a journey's trigger or outcome, a step's actor or observable result — at helicopter grade only; a hole answerable only at spec depth is not asked (depth rule; principle 2).
6. **BA act:** rule — confirm or edit journeys; rule the significance set. A finding contradicting cleared ground — a canvas function line, the register, an objective — is a reopen signal (§3.5 step 4 → P-O6).
7. **Framework act:** write the file; refresh the Requirements evidence table (§7.4) — AT-RQ-4 journeys clause. With T-11 + T-12 + T-13 landed, the requirements infrastructure stands at seed grade for the aspect's remaining sheets (B5's governance trio — inventory identity only); post-clearing, this file loads into every Tier-2 run and every Tier-1 kit — write steps a later reader can locate a feature inside.

### 5. Output template & micro-example
```markdown
# Core Processes — <project>

## <Journey name> — role: <role, verbatim from roles-permissions.md>
Trigger: <what starts it> → Outcome: <what stands changed>
1. <actor> <action> → <observable result>   (entities by domain-model name)
Source: <citations>
```
Micro-example — Requirements seed (pre-RO-1):

**Book an appointment — role: Client**
Trigger: a Client needs a Specialist appointment without phoning (→ P-1) → Outcome: Appointment booked; the Specialist knows.
1. Client browses a Specialist's published Availability → open Slots shown. `[canvas §7 Browse line]`
2. Client books an available Slot → Appointment created; confirmation shown to the Client; the Specialist is notified. `[canvas §7 Book · Notify lines]`
Source: canvas §7 · kickoff notes · serves O-2

**Cancel own appointment — role: Client**
Trigger: the Client's plans change → Outcome: Appointment cancelled; the Specialist knows.
1. Client cancels own Appointment → Appointment cancelled; the Specialist is notified. `[canvas §7 Cancel · Notify lines]`
Source: canvas §7 · serves O-2 (the Slot's rebooking disposition is deliberately unstated — spec BR ground)

**Publish availability — role: Specialist**
Trigger: the Specialist's schedule for the period ahead is set → Outcome: Availability stands published; Slots browsable by Clients.
1. Specialist publishes own Availability → Slots become browsable by Clients. `[canvas §7 publish line]`
Source: canvas §7 · serves O-2

Continuity, four threads: **(i)** brief §8's F1 slice — "Client-side journey; independently deliverable" (elicitation §8.2) — is the first two journeys read back; F2 is the third's feature; Tier-2 for 004 loads this file at stack row 5 to place the feature inside the booking journey. **(ii)** the hold step and the race path are deliberately absent — the 5-minute hold and every error path are feature-004 spec ground (standard §6); helicopter grade carries none of it. **(iii)** the publish journey's role stays Specialist at pre-RO-1 — the actor set RO-1 later grows lives on the canvas line, and the journey follows at re-clear, its outcome unchanged (orchestrator §12.3's pattern). **(iv)** answered-source scope, precisely: a kit never asks what a to-be journey states (Guard 1 — "what does a Client do to book" is citable here), while kit Q1's as-is walk ("how does a booking happen today") stays legal — the as-is is context and competitive ground (catalogue-b2 T-05/T-07), not this file's.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-4 (journeys clause) — the major journeys of the primary roles, seeded |
| Health hooks | CC-H-01 — the file in the spec-anchored estate from arming (`.specify/memory/*` glob; gate §10.2's processes row) |
| Consumer hooks | — (no Scope-F assertion reads this artifact directly; it sits outside the gate's static core, gate §3 — its consumption is elicitation-side) |

Cross-layer consumers, on the record: Tier-2 context stack row 5 — flow context, loaded into every Tier-2 run (elicitation §5.2) · Tier-1 kit input and Guard-1 answered-source (elicitation §3.2, §6) · decomposition (T-17, B6) consumes the discovery estate with these journeys in it (plan §3, B6 rationale — inventory identity only) · the §3.5 routing surface for process findings a call surfaces.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba-run T-13`; contract check at P-O3. Inputs loaded: `.specify/memory/roles-permissions.md` and `.specify/memory/domain-model.md` first (the citation surfaces) · `canvas.md` (§§2, 7, 12) · `.specify/memory/context.md` · `glossary.md` · current file. Interaction: significance pass → journey pre-draft → coherence pass → destination-tagged questions → BA rulings → write + routed batches. Outputs written: `.specify/memory/processes.md` (D-B4-3, locked), plus routed batches where the coherence pass found misses. §§2–5 above fix the method; Phase 2 adds the coherence-diff rendering (role/entity resolution), a consumption check that steps stay locatable for Tier 2, and an optional swimlane render as a derived view (D-B4-1's rule, applied by analogy).

---

## Review record (v0.1 → v0.2)

Four decisions ruled by the BA Lead, 29 July 2026 — **all recommendations accepted as stated.** The locked text stands inline at each sheet; the table below stands as the rulings' record.

| # | Decision | Ruling (adopted as recommended) | Basis |
|---|---|---|---|
| **D-B4-1** | Domain-model canonical form — tables, diagram, or both? | **Tabular canonical form** (Entities + Relations tables); any diagram — Mermaid, image — is a **derived view, never the source of truth**. CC-DA-01, CC-XA-04, and CC-H-05's entity side are A/M checks needing parseable names and relations; standard rule 4 puts structured data in tables; Mode A's "certified text is the read text" makes a diagram-as-source unreadable to the chain. Alternative — diagram-first with tables generated — rejected: inverts the checkability and puts a render step between evidence and checker. | Standard rule 4; CC-DA-01 · CC-XA-04 · CC-H-05; Q5 |
| **D-B4-2** | Policy-row granularity — explicit tuples, or grouped/wildcard rows? | **One explicit row per role × entity × action tuple**, rule/scope qualifier per row; **no wildcard rows, no role inheritance at v1.** CC-XA-01's own wording demands "an explicit policy row" per tuple and fails "with the tuple named" — the row grain must equal the check grain; the ⚑ per-tuple sign-off and CC-H-05's mechanical read both read rows, not expansions. Alternative — grouped actions or `*` cells — rejected: makes tuple presence a computed fact and the sign-off's evidence indirect; inheritance is post-v1 ground if ever. | CC-XA-01 (⚑, non-waivable) · CC-H-05; contract §7 named-gap grammar |
| **D-B4-3** | Core-processes destination file — the one unpinned path in the chain | **`.specify/memory/processes.md`.** Two corpus lists already use the bare noun in filename-stem position — plan §7's layout ("…constraints, domain-model, **processes**, backlog…") and gate §10.2's scoped-run map row ("canvas · context · constraints · stakeholders · **processes** · out-of-scope"), where every sibling noun maps 1:1 to `<noun>.md` — so this choice needs **zero mirror edits**. Alternative — `core-processes.md` (matches the artifact label "core processes" in AT-RQ-1/-4 and the elicitation stacks) — costs hygiene mirrors in plan §7 and gate §10.2 for a self-description gain the D-B2-3 pattern doesn't demand: labels and stems already diverge in the estate ("global out-of-scope" ↔ `out-of-scope.md`). | Plan §7; gate §10.2; D-B2-3 (catalogue-b2); CC-H-01 glob |
| **D-B4-4** | Role-significance criterion for T-13 — plan §4.9 says "each significant role"; AT-RQ-4 says "the primary roles"; neither defines the set | **Evidence-grounded significance: a role is significant at Band-1 grade iff it stands as the actor of ≥ 1 canvas Core Function line**; the BA may elect further roles into the journey set (Q2 composition freedom). This reads "primary roles" through AT-RQ-4's own symmetry — the entity clause resolves against what the core functions imply; the journeys clause resolves against who the core functions name — and keeps significance a checkable fact, not an adjective. Roles entering later (the RO-1 deferral pattern) bring their journeys when their evidence does. | AT-RQ-4; plan §4.9; Q2; orchestrator §12.3 |

**Conflict scan — against the five spine documents (standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.2 · orchestrator v0.2) and prior batches (catalogue-b1 v0.2 · catalogue-b2 v0.2 · catalogue-b3 v0.2).** Checked: AT-RQ-2 and AT-RQ-4 wording and clause allocation (orchestrator §3.3 — the entity clause to T-11, the journeys clause to T-13, per the inventory) · CC-DA-01, CC-XA-04, CC-US-02, CC-TR-03, CC-XA-01 ⚑, CC-XA-02, CC-H-01, CC-H-05 wording, read-sets, and non-waivable statuses (contract §5–§6, §8) · destination paths — `domain-model.md` (contract §2 shorthand · orchestrator §2.1 · standard §12), `roles-permissions.md` (plan §4.14), `processes.md` (D-B4-3) — all inside CC-H-01's glob · the cross-batch pins consumed exactly as pinned: EG-1's sweep semantics in D-B3-5's own words (function objects → entity candidates, connection systems → boundary references) and TC-1…TC-3 with T-04's boundary lines honored in both directions (TC-2 the sole transformation input; TC-3's screened set = CC-XA-02's; access-rule findings route here, charter fields beyond TC-1/TC-2 never read) · micro-example continuity: pre-RO-1 held — two roles, no Clinic Admin; Specialist × Appointment × cancel absent at seed, entering 2026-07-17 exactly as contract §7's gate run 2 records; Olena derives no role (orchestrator §12.3's population-vs-role logic at seed time); the occupies-row multiplicity is NFR-002 / race-scenario ground (standard §5, §7); Hold deliberately absent pending CC-DA-01's update-first path; the journeys read back brief §8's F1/F2 slices and hold the publish line's pre-RO-1 actor (RO-1's re-clear touches the canvas line; the journey's outcome is unchanged); kit Q1's as-is walk stays legal beside the to-be answered-source (Guard 1). Three reconciliations on record, none a contradiction: **(a)** AT-RQ-1's seed-grade existence demand touches all three files, but its hook allocation is T-14/T-15/T-16's per the inventory — these sheets' triggers name AT-RQ-4/AT-RQ-2 patterns, the absent-or-stubbed pattern being those criteria's own first miss. **(b)** the constitution-principle half of AT-RQ-2 is T-15's hole, stated as such in T-12 §2 — the sheet enforces the principle operationally without authoring it (plan §4.14's split). **(c)** forward references (T-14…T-18, B5/B6) stand at inventory identity only — the sequencing invariant intact (the B2 scan's precedent). One interpretive extension, flagged for the record as a **mirror candidate at the orchestrator's next version bump: D-B4-4** (a significant/primary-roles criterion note beside AT-RQ-4, §3.3) — no spine statement contradicts it. D-B4-1 and D-B4-2 are applications of standing wording (standard rule 4; CC-XA-01's "explicit policy row") and need no mirror; **D-B4-3 needs zero mirrors by construction** — its deciding argument. **No spine contradiction found; no erratum issued.**

---

*v0.2 · review incorporated 29 July 2026 · sheets T-11–T-13 of 18 · authored to sequencing-plan §2 template (D-W9 order: contract before procedure) · no ★ in batch — all three to the elicitation-§7.1 no-reference pattern · class mix Context + Governance — dependency trumps class (plan §3, B4) · cross-batch pins consumed: EG-1 (D-B3-5) opened by T-11 · TC-1…TC-3 (D-B2-2) consumed by T-12 · decisions D-B4-1…D-B4-4 locked (review record above) · pending mirror at the orchestrator's next bump: D-B4-4 → §3.3 · consumed by: batches B5–B6 (cite, never restate) · next: B5 — Requirements governance & boundary (T-14…T-16), standing batch prompt §4, new conversation*
