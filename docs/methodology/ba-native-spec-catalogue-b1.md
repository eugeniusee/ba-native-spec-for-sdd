# Geniusee Technique Catalogue — Batch B1
### BA-Native Spec · Wave 2 · Frame & foundation · v0.3 — B3 mirrors applied (30 July 2026; review incorporated 25 July 2026)
**v0.3 change record:** two catalogue-b3 mirrors, both additive — D-B3-1 (line-ID continuation clause beside D-B1-1, T-01 §4 step 3) · D-B3-3 (T-01 §5 Core Functions cell gains `→ <vision section>` beside `→ O-n`). No other changes.

**What this is:** sheets T-01–T-03 of the 18-sheet catalogue (sequencing plan §1), authored to the §2 uniform template in the pinned within-batch order: canvas framing → glossary discipline → stakeholder register. B1 is the anchor batch: every later sheet cites canvas sections and glossary-canonical terms (standard rule 3), and the register is the root aspect's artifact — the resolution target for AT-VA-1, for persona charters (B2), and for Tier-1 comms.

**Rulings in force (restated once):** every sheet authored from scratch; presale skills are reference designs to mine, never components (elicitation v0.3 §7/§11). Micro-examples stay in the appointment-booking world at its **pre-RO-1 state** — Band-1 first pass: Specialists self-publish availability, no Clinic Admin yet (orchestrator §12's baseline; that walkthrough remains strictly downstream of these artifacts). **D-W8 verified at B1 kickoff:** no presale glossary skill exists among the user skills (canvas ★ · epics ★ · user-stories ★ only) → T-02 is authored to the elicitation-§7.1 no-reference pattern; the pre-authorized plan erratum is listed in the review record.

---

## T-01 · Discovery canvas framing
Band 1 · serves: Frame (orchestrator §8.1) · class: Context · target: #1 presale canvas + Context/Constraints element (Q1a) · ★ presale canvas skill

### 1. Purpose & BABOK grounding
Carries the presale canvas into the repo as Band 1's shared evidence substrate — or produces one where no presale ran — and extends it with the Context/Constraints element (Q1a). The 13 sections are exactly the canvas-anchored AT estate; every section is read by a named criterion: Customers→AT-ST-1 · Problems→AT-VA-1 · Objectives→AT-VA-2 · Product The/Is/That→AT-VI-1 · Competition Unlike + Context/Constraints→AT-CX-3 · Our Solution→AT-VI-2 · Forms/Core Functions/Third-Party/Localization→AT-SO-1/2/3. The decision this technique lets the BA make: confirm the substrate and open the root aspect (T1). BABOK: 10.8 Business Model Canvas · 10.18 Document Analysis · 10.41 Scope Modelling · 4.3 Confirm Elicitation Results. House: plan Q1a; orchestrator §8.1 — this sheet's pinned contract is identical to the custom contract §8.1 names for the canvas-absent branch, so the Frame act is catalogue-served from this sheet on (orchestrator §6.3's until-the-catalogue-lands clause resolves for this slot).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | `Frame` (D-W7 — band-state triggers, not AT holes) |
| Evidence triggers | Band-1 entry with `canvas.md` absent (the §8.1 canvas-absent branch — the first Frame act, before any aspect opens) · Band-1 entry with a presale canvas on hand but not in framework shape: chat-table form, no Context/Constraints element, not carried into the repo. |
| Skip-if | `canvas.md` present in framework shape (13 sections, line-IDs per D-B1-1, locked) and confirmed carried — the §8.1 Frame confirmation covers it. A framed canvas is never re-framed: deepening its sections is aspect-sheet ground (T-03…T-10), and the trigger cannot recur — Band-1 entry happens once (D-O8: no band regression). |
| Depth | Elicits at framing grade: section-level population from presale material — named sponsor and populations, one-line problems and objectives with line-IDs, the three product-statement slots, enumerated functions, forms, connections, constraint one-liners. Must NOT descend into aspect-grade completion — register rows (T-03), constraint classes with none-identified bases (T-06), function→objective linkage sweeps (T-10) — nor anything spec-depth (Tier-2 ground). T-01 runs no question loop at all: holes stay visibly open and become the aspect suggestion engine's input (§6.1 — the holes are the suggestions). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Framed canvas: the 12 presale sections + the Context/Constraints element, populated at framing grade under cite-or-mark, with `P-n`/`O-n` line-IDs (D-B1-1, locked); unpopulated sections explicitly marked open, never blank |
| Artifact class | Context (spec-anchored — Q7; joins the CC-H-01 estate at arming) |
| Destination file | `canvas.md` — repo root (plan §7 layout; deliberately outside `.specify/memory/`) |

### 4. Procedure
1. **BA act:** at Band-1 entry (Frame, orchestrator §8.1), invoke T-01 (P-O3) with all presale material on hand — canvas export, briefs, decks, transcripts — or nothing (greenfield conversation). The run is recorded under the `Frame` section of `aspect-plans.md` (D-B1-4, locked).
2. **Framework act:** if a presale canvas exists — parse it into the output template, content carried verbatim per section, each carried line tagged `[presale canvas]`; other supplied material is mined (10.18) with its own citations. If none exists — pre-draft all 13 sections from what the BA supplied, cite-or-mark per line (principle 3).
3. **Framework act:** line-ID assignment — `P-n` on Problems, `O-n` on Objectives (D-B1-1, locked). Linkage notation `→ P-n` (objectives) and `→ O-n` (core functions) is written only where the material states it, never inferred silently — linkage completion is AT-VA-2 / AT-SO-2 aspect ground. Continuation (D-B3-1, catalogue-b3, locked): post-framing writes extend each sequence monotonically — next unused `n`; a retired line's ID is never reused.
4. **Framework act:** hole and conflict surfacing — a section with no material is marked `open — no source material` (never a fake N/A); contradicting sources are carried side-by-side under a `[CONFLICT: <A> says … · <B> says …]` marker (D-B1-2, locked — no reopen exists at Frame: nothing is gated yet; the owning aspect resolves the conflict at first pass).
5. **Framework act:** the framing report (session output, not a file): sections populated with sources · sections open · conflicts · N/A candidates each with a basis · which canvas-anchored AT criteria already show first-pass evidence.
6. **BA act:** review — correct carried lines, rule each N/A candidate (`N/A — <reason>` or leave open), then confirm the landing: `canvas.md` present and carried into the repo — the §8.1 Frame confirmation. The root aspect is now openable (T1).

### 5. Output template & micro-example
```markdown
# Discovery Canvas — <project>
| # | Section | Content |
|---|---|---|
| 1 | Customers | sponsor + user populations — real names or real groups (AT-ST-1 ground) |
| 2 | Problems | P-1, P-2… — one line each, naming who hurts |
| 3 | Product.The | name / title of the solution |
| 4 | Product.Is | solution type |
| 5 | Product.That | what it enables for the customer |
| 6 | Forms | delivery formats |
| 7 | Core Functions | ≤ 10 capabilities; `→ O-n` — or `→ <vision section>` (D-B3-3, catalogue-b3, locked) — where the link is stated |
| 8 | Third-Party Connections | system · direction · role, one line each |
| 9 | Localization | languages · currencies · regions |
| 10 | Competition.Unlike | named competitors (+ URLs where known) |
| 11 | Competition.Our Solution | differentiation against ≥ 1 Unlike entry |
| 12 | Objectives | O-1, O-2… — measurable where possible; `→ P-n` links |
| 13 | Context/Constraints | one-liners per class (technical · business · regulatory); detail owned by `constraints.md` (#5) from the Context aspect on |
```
Micro-example — excerpt after the framing run, before any aspect work:

| # | Section | Content |
|---|---|---|
| 1 | Customers | Sponsor: Olena — clinic network COO `[presale brief]`. Populations: Clients — book appointments · Specialists — deliver them `[presale canvas]` |
| 2 | Problems | P-1 — ~30% of booking calls go unanswered; bookings are lost `[presale canvas]` |
| 7 | Core Functions | Browse a Specialist's published availability → O-2 · Book an available slot → O-2 · Cancel own appointment · Specialists publish their availability `[presale canvas]` |
| 12 | Objectives | O-1 — Take booking self-serve online for the network, MVP this year → P-1 `[presale brief]` · O-2 — Reduce lost bookings → P-1 `[presale canvas]` |
| 13 | Context/Constraints | Technical: specialists' existing calendars stay in use `[presale canvas: Third-Party]` · Business: open — no source material · Regulatory: open — no source material |

Continuity: the unlinked self-publish line is exactly what RO-1 later contradicts (orchestrator §12); the two open constraint classes are exactly AT-CX-2's future holes — T-06's triggers, ready-made.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-ST-1 · AT-CX-3 · AT-VA-1 · AT-VA-2 · AT-VI-1 · AT-VI-2 · AT-SO-1 · AT-SO-2 · AT-SO-3 — this output is their evidence substrate; T-01 seeds them at framing grade, the owning aspects complete and clear them (an aspect gate, never this run, confirms) |
| Health hooks | CC-H-01 — `canvas.md` joins the spec-anchored estate at arming |
| Consumer hooks | CC-OV-02 — the spec's value claim resolves to canvas Problems/Objectives; the `P-n`/`O-n` line-IDs are what its citations and the Tier-1 kit baselines point at (`[canvas: Problems P-1]`, elicitation §8.1) |

### 7. Reference-design mining notes
★ Reference design exists: the presale canvas chat skill (read in full this session).

| Reference design contributes (mine these) | Framework sheet must satisfy (from scratch) |
|---|---|
| The 12-section structure and section names verbatim — it *is* the locked substrate Q1a anchors the aspect model on (plan §3's mapping resolves to these exact names) · input tolerance: pasted text plus uploaded files of any format, read before generating · fill heuristics: Customers ≤ 5 segments (typically 1–2), Core Functions ≤ 10, competitors with URLs, objectives measurable incl. deadlines/milestones · the honest-absence rule: never invent; absence declared explicitly · proto cite-or-mark: the "(inferred from input)" marking · the post-generation coverage note (what is covered vs. which sections need follow-up) — the seed of the framing report | **Anonymization inverted** — the reference masks client, project, and people names for presale-chat safety; the framework canvas is the project's own repo artifact and real names are the requirement (AT-ST-1: placeholders fail) · **chat-table output → destination file**: `canvas.md` under the pinned contract, not a copy-paste table (Q2+) · **Context/Constraints element added** — section 13, Q1a's extension; the reference has no constraints home · **"No information available" hardens** into two distinct states: `open — no source material` (a visible hole the suggestion engine reads) vs. `N/A — <reason>` (a BA ruling) — AT silence-fails logic; the reference's single token conflates them · **"(inferred from input)" hardens** to full cite-or-mark (principle 3): every line a citation or a marker · **"never ask for confirmation" inverts** to BA review plus the §8.1 Frame confirmation (runtime rule 2: the framework proposes, the BA rules) · **line-IDs added** (`P-n`/`O-n`, D-B1-1) — the corpus already cites them; the reference numbers nothing · **stage-navigation postamble dropped** ("Ready for Stage 2…") — next acts belong to the orchestrator, not the technique |

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-01` at the Frame act — the one catalogue technique invoked outside an aspect plan (D-B1-4, locked: recorded under a `Frame` section of `aspect-plans.md`); contract check at P-O3 (orchestrator §11). Inputs loaded: presale material as supplied, files of any format — no context stack exists yet; Frame is first. Interaction: parse-or-draft → framing report → BA review + N/A rulings → write + §8.1 confirmation. Outputs written: `canvas.md` only; the framing report is session output. §§2–6 above fix structure, contract, procedure, and depth; Phase 2 adds multi-format file ingestion, parse-vs-draft branch detection, P-O3 wiring, and the framing-report rendering.

---

## T-02 · Glossary discipline
Band 1 · serves: Requirements (used from Frame on — standard rule 3) · class: Context · target: #2 glossary / ubiquitous language · ★ — (D-W8: no reference design exists)

### 1. Purpose & BABOK grounding
Establishes and consolidates the project's one language: canonical terms, business-level definitions, synonyms merged with the losing term on record. Two modes, deliberately split (D-B1-3, locked): the **standing discipline** — standard rule 3 plus the elicitation-§3.5 routing row (new term / synonym conflict → `glossary.md`) — operates from the first Frame act on and is not a technique run; the **consolidation run** (this sheet's procedure) is the deliberate sweep-and-merge pass the Requirements plan carries against AT-RQ-3. The decision this technique lets the BA make: which term wins each merge, and whether the language is closed enough to seed the spec estate. BABOK: 10.23 Glossary · 5.2 Maintain Requirements · 4.3 Confirm Elicitation Results. House: standard rule 3; contract CC-XA-03 / CC-H-04 wording; plan Q1a (canvas terms are the first sweep surface).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Requirements (suggestion-anchored there; the standing discipline serves every act from Frame on — D-B1-3, locked) |
| Evidence triggers | AT-RQ-3 — a term the canvas or a Band-1 artifact leans on carries no glossary entry · a known synonym pair stands unmerged ("booking" vs "Appointment") · an entry is a stub — term without definition (CC-H-04's pre-arming image). |
| Skip-if | AT-RQ-3 reads met in the current evidence table — every leaned-on term defined, no known pair unmerged, no stubs. Enrichment beyond the criterion (translations, extended usage notes) only on BA ask (§6.1). |
| Depth | Elicits business-level definitions: one term, one project meaning, plus the merge record. Must NOT descend into per-field data definitions (data dictionary — post-v1, plan §10), entity attributes or relations (T-11 domain-model ground), state vocabularies (spec Data-section ground), or UI copy. A definition that enumerates fields or transitions has crossed the line. Role names are T-12 ground: a glossary entry restating a role double-defines (standard rule 5) — role nouns are *used* in definitions here, never *defined* here. |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Glossary — canonical-term entries: Term · Definition · Merged synonyms · Source; every entry definition-complete, every merge dated |
| Artifact class | Context (spec-anchored — Q7) |
| Destination file | `.specify/memory/glossary.md` |

### 4. Procedure
1. **BA act:** invoke under the composed plan (P-O3) — normally the Requirements plan, against AT-RQ-3 holes; earlier, by BA election, in any open aspect's composed plan (D-B1-3, locked — legal by Q2 composition freedom + ungated arrival; the framework's own suggestion never proposes it outside Requirements, per §6.1's evidence-grounded rule).
2. **Framework act:** term sweep — candidate domain terms extracted from `canvas.md` and every Band-1 artifact to date, diffed against existing entries → the hole list: undefined terms · suspected synonym pairs, each with usage locations · stub entries.
3. **Framework act:** drafts — one definition per hole, cited from its usage context or marked (principle 3); per synonym pair, a canonical pick recommended with a one-line merge rationale.
4. **BA act:** rules — canonical picks, definitions confirmed or edited, merges approved. A genuine meaning conflict (one term, two incompatible uses) is ruled here, never silently averaged.
5. **Framework act:** writes `glossary.md`. Where a merge de-canonicalizes a term other artifacts use, the affected lines are assembled as a proposed-edit batch (elicitation §3.5 discipline) — the BA approves, the framework writes; if a resolution contradicts gated aspect content, the reopen signal rides the same batch (§3.5 step 4).
6. **Framework act:** refresh the Requirements evidence table (§7.4) — the AT-RQ-3 row updates; confirmation is proposed only when the whole aspect's table reads met.

### 5. Output template & micro-example
```markdown
# Glossary — <project>
| Term | Definition | Merged synonyms | Source |
|---|---|---|---|
```
Micro-example — after the Band-1 consolidation run:

| Term | Definition | Merged synonyms | Source |
|---|---|---|---|
| Appointment | A confirmed engagement between a Client and a Specialist, occupying one Slot | booking (noun) — merged 2026-07-09, canvas usage | canvas: Core Functions |
| Slot | A bookable time interval a Specialist publishes | — | canvas: Core Functions |
| Availability | The set of a Specialist's published Slots open to Clients | — | canvas: Core Functions |

Later accretion, on the record and requiring no run — the standing discipline at work: "No-show" routes in at Tier-1 ingestion (elicitation §8.2 §9, Routing Log); "Hold" is added by the Tier-2 writer before its first use (standard rule 3).

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-RQ-3 — every term the canvas and Band-1 artifacts lean on is defined; no known synonym pair left unmerged |
| Health hooks | CC-H-04 — entry completeness and merge hygiene, post-arming |
| Consumer hooks | CC-XA-03 — every spec term exists here and the canonical form is the one used; the Merged-synonyms column is what makes drift detectable rather than re-litigable |

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern). D-W8 verified at B1 kickoff, 25 July 2026: no presale glossary skill exists among the user skills; the pre-authorized erratum (★ off artifact #2) is listed in the review record.

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-02`; contract check at P-O3. Inputs loaded: `glossary.md` (current) · `canvas.md` · every `.specify/memory/` artifact to date; post-Band-1 reruns add briefs and specs to the sweep surface. Interaction: sweep report → drafted entries + merge proposals → BA rulings → write + drift-repair batch. Outputs written: `.specify/memory/glossary.md`, plus the routed batch where merges touch other artifacts. §§2–6 above fix the method; Phase 2 adds cross-file term extraction, usage-location evidence, and batch-assembly wiring.

---

## T-03 · Stakeholder register
Band 1 · serves: Stakeholders · class: Context · target: #3 stakeholder register · ★ —

### 1. Purpose & BABOK grounding
Produces the project's cast list as an artifact: populations and decision-relevant individuals, each with a role-in-project and decision rights or a comms line — the who's-who that Tier-1 calls, transcript parsing, and every downstream who-question resolve against. Root-aspect ground: AT-VA-1's "who hurts" resolves to this register's populations; T-04 persona charters (B2) enrich its entries; the sponsor's decision authority is made explicit here or nowhere. The decision this technique lets the BA make: the cast is coherent with the canvas and complete enough that dependent aspects open on named people, not placeholders. BABOK: 10.43 Stakeholder List/Map/Personas · 3.2 Plan Stakeholder Engagement · 4.3 Confirm Elicitation Results. House: plan §4.3; orchestrator §2.1 (Stakeholders artifact homes).

### 2. Catalogue metadata (BA-planning loop — orchestrator §6)
| Field | Value |
|---|---|
| Serves | Stakeholders (root) |
| Evidence triggers | AT-ST-2 — `stakeholders.md` absent or stubbed · an entry lacks role-in-project, or lacks both decision rights and a comms line · the sponsor's decision authority is nowhere explicit. AT-ST-3 — a canvas Customers population resolves to no register entry · a register entry contradicts the canvas picture. |
| Skip-if | AT-ST-2 and AT-ST-3 read met in the current evidence table (e.g., a register carried from a prior engagement, confirmed current at Frame). Persona work is never this sheet's ground — enrichment, BA-elected, T-04 (§6.1 rule). |
| Depth | Elicits the cast at project grade: populations as first-class entries plus named individuals where decision- or comms-relevant; role-in-project; decision rights; comms line. Must NOT descend into persona charters (T-04), authorization roles or permission rows (T-12 governance — a register population is never a role; the persona→role principle's register cousin), org-chart completeness beyond project relevance, or engagement scheduling (BA conduct, not artifact content). |

### 3. Output contract (Q2+ — pre-pinned; orchestrator §6.3)
| Field | Value |
|---|---|
| Expected output | Stakeholder register — one row per population and per decision-relevant individual: Stakeholder · Kind (individual \| population) · Role in project · Decision rights · Comms line · Source; the sponsor's authority explicit |
| Artifact class | Context (spec-anchored — Q7) |
| Destination file | `.specify/memory/stakeholders.md` |

### 4. Procedure
1. **BA act:** open Stakeholders (T1 — the root opens at Band-1 entry once the Frame confirmation stands); compose the plan (§6.2); invoke T-03 (P-O3).
2. **Framework act:** pre-draft the register from canvas Customers, presale material, and any transcripts on hand — one row per population and per named individual; every field cited or marked (principle 3).
3. **Framework act:** the remaining holes become questions, each destination-tagged to a register field or a named AT miss (principle 2 — a question serving neither is illegal; threshold grade bounds the set structurally, so no numeric cap is needed).
4. **BA act:** answers from knowledge or takes the question to the stakeholder; edits rows; states the sponsor's decision authority explicitly (AT-ST-2's named condition).
5. **Framework act:** coherence pass — canvas Customers ⇄ register diff (AT-ST-3's ground): every population resolves; a mismatch is surfaced as a proposed edit on the register or the canvas side — canvas-side fixes ride a proposed-edit batch (§3.5). At first pass, with the aspect still `open`, a conflict is ordinary correction — no reopen exists to signal. Post-clearing, the same contradiction arriving later is exactly orchestrator §12's RO-1 path (Tier-1 ingestion → reopen → register + canvas corrected) — referenced here, never re-mechanized.
6. **Framework act:** write `stakeholders.md`; refresh the evidence table (§7.4); propose confirmation when AT-ST-1…3 read met — the BA clears (P-O4), and Context and Value become openable.

### 5. Output template & micro-example
```markdown
# Stakeholder Register — <project>
| Stakeholder | Kind | Role in project | Decision rights | Comms line | Source |
|---|---|---|---|---|---|
```
Micro-example — Band-1 first pass (pre-RO-1):

| Stakeholder | Kind | Role in project | Decision rights | Comms line | Source |
|---|---|---|---|---|---|
| Olena | individual | Sponsor — clinic network COO | Final call on scope, phases, budget | weekly sync · direct | canvas: Customers |
| Clients | population | End users — book and cancel appointments | — | no direct access at discovery — via Olena | canvas: Customers |
| Specialists | population | Publish availability; deliver appointments | own their calendars and published availability | 2 specialists reachable via Olena | canvas: Customers · kickoff notes |
| Dr. Ivanova | individual | Specialist voice for discovery | — | via Olena | kickoff notes |

Continuity: the Clinic Admin population is deliberately absent — it enters at RO-1 (orchestrator §12), when the Tier-1 call contradicts this first-pass picture and the reopen machinery corrects register and canvas together.

### 6. Gate hooks
| Hook | IDs |
|---|---|
| Threshold hooks | AT-ST-2 · AT-ST-3 |
| Health hooks | CC-H-01 — `stakeholders.md` in the spec-anchored estate from arming |
| Consumer hooks | — (no Scope-F assertion reads the register directly) |

Cross-layer consumers, on the record: **AT-VA-1's resolution target** — canvas Problems' who-hurts resolves to these populations · T-04 persona charters (B2) enrich entries here · Tier-1 kits read comms lines and call participants (elicitation §3.2 inputs) · the §3.5 routing table lands new-stakeholder findings here.

### 7. Reference-design mining notes
No reference design — built to this sheet alone (elicitation §7.1 pattern).

### 8. Phase-2 build-brief hook
Invocation: `/ba.run T-03`; contract check at P-O3. Inputs loaded: `canvas.md` (Customers first) · presale material and transcripts · `glossary.md`. Interaction: pre-draft → destination-tagged questions → BA rulings incl. the sponsor-authority line → coherence pass → write. Outputs written: `.specify/memory/stakeholders.md`, plus a canvas-side batch when coherence demands one. §§2–6 above fix the method; Phase 2 adds transcript parsing toward register fields and the evidence-table refresh wiring.

---

## Review record (v0.1 → v0.2)

Four decisions ruled by the BA Lead, 25 July 2026 — **all recommendations accepted as stated.** The locked text stands inline at each sheet; the table below stands as the rulings' record.

| # | Decision | Ruling (adopted as recommended) | Basis |
|---|---|---|---|
| **D-B1-1** | Canvas line-ID convention — the corpus already cites `[canvas: Problems P-1]` / `[canvas: Objectives O-2]` (elicitation §8.1–8.2), and AT-VA-2 / AT-SO-2 need pointable linkage, but no spine document pins a scheme | Stable line-IDs on exactly two sections: `P-<n>` Problems, `O-<n>` Objectives — assigned at framing, never reused; linkage notation `→ P-n` / `→ O-n` inline in Objectives and Core Functions; all other sections unnumbered (nothing downstream cites them by line) | elicitation §8; AT-VA-2, AT-SO-2; CC-OV-02 |
| **D-B1-2** | Frame-time contradictions — conflicting presale sources with nothing yet gated (no reopen machinery applies) | Carry both readings side-by-side under a visible `[CONFLICT: <A> says … · <B> says …]` marker; the owning aspect resolves it at first pass; never silently merged (principle 3 at Frame). No RO is logged — RO machinery starts at first clearing | orchestrator §5.1 (all intake sources are post-gating); principle 3 |
| **D-B1-3** | T-02's two modes + early-run legality — the glossary accretes from Frame on (rule 3 + §3.5 routing) while suggestion is Requirements-anchored; may a BA run T-02 before Requirements opens? | Split confirmed: the standing discipline is law, not a run; the consolidation run is Requirements-plan ground. An early deliberate sweep = BA-elected inclusion in any open aspect's composed plan — legal by Q2 composition freedom + ungated arrival; the framework's own suggestion never proposes it outside Requirements (§6.1's evidence-grounded rule) | plan Q2; orchestrator §2.2, §6.1 |
| **D-B1-4** | T-01's invocation home — the planning record (§6.4) has per-aspect sections only, but T-01 runs at Frame, before any aspect opens | `aspect-plans.md` gains one `## Frame` section holding T-01's plan line and run log, same row shape — the single non-aspect section, mirroring the polymorphic Serves field (D-W7). No orchestrator change: §8.1 already defines the act; this pins only where its record lands | orchestrator §6.4, §8.1; D-W7 |

**D-W8 — executed (locked ruling, not an open decision).** Verified at B1 kickoff: no presale glossary skill exists (user skills present: canvas ★ · epics ★ · user-stories ★ · three non-presale). T-02 is authored to the §7.1 no-reference pattern — no methodological change, exactly as the ruling pre-decided. Pre-authorized erratum — review is closed, **apply now** via the plan's replace-on-update (no separate erratum conversation needed; D-W8 pre-ruled both branches):
- plan §4, artifact 2: "Glossary / ubiquitous language ★" → drop the ★
- plan §0 row 6 and sequencing plan §5.1's stored row text: "★ = presale reference design to mine: canvas, glossary, epics" → "canvas, epics"
- sequencing plan §1, T-02 row: "★ presale glossary skill *(verify — D-W8)*" → "—"
- plan §8 Wave-2 bullet and sequencing plan §5.3's stored text: "(canvas ★ · glossary ★ · epics ★)" → "(canvas ★ · epics ★)"

**Conflict scan — against the five spine documents (standard v0.3 · contract v0.2 · elicitation v0.3 · gate v0.2 · orchestrator v0.2) and prior batches (none — B1 is first).** Checked: every AT-ID and its wording (orchestrator §3.3) · CC-H-01/-04, CC-OV-02, CC-XA-03 wording (contract §5–§6) · destination paths (`canvas.md` at repo root per plan §7 and CC-H-01's glob; `.specify/memory/` for #2/#3 per orchestrator §2.1) · canvas section names against plan §3's aspect mapping · T-01's contract ≡ orchestrator §8.1's canvas-absent custom contract · micro-example continuity: pre-RO-1 world state (the self-publish line present, no Clinic Admin), `P-1`/`O-2` IDs, Olena / Dr. Ivanova / E-03 corpus figures. One additive extension, flagged for the record: **D-B1-4 extends the plans-file shape** (a `Frame` section beside the six aspect sections) — no orchestrator statement contradicts it; mirror candidate for orchestrator §6.4 at that document's next version bump. **No spine contradiction found; no erratum issued** beyond the pre-authorized D-W8 plan lines above.

---

*v0.3 · B3 mirrors applied 30 July 2026 (D-B3-1 · D-B3-3) · review incorporated 25 July 2026 · sheets T-01–T-03 of 18 · authored to sequencing-plan §2 template (D-W9 order: contract before procedure) · ★ mining pattern established at T-01 · D-W8 executed — T-02 to the no-reference pattern; plan erratum ready to apply · decisions D-B1-1…D-B1-4 locked (review record above) · consumed by: batches B2–B6 (cite, never restate) · next: B2 — Stakeholders & Context breadth (T-04…T-07), standing batch prompt §4*
