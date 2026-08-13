# Geniusee Two-Tier Elicitation Techniques
### BA-Native Spec · elicitation engine · v0.5 — the lean-composition anchor: principle 4 · the Tier-2 drafting posture (13 Aug 2026)
**v0.5 change record:** one ruling package, ruled 13 Aug 2026 (**lean scope posture**; **D9–D10**, §12; origin: Run-1 field feedback, 12 Aug 2026 — the generation posture *thought in breadth*: a twenty-epic full-coverage roadmap where the engagement needed a lean POC composition. The scope frame (orchestrator v0.15 §20 — D-O42–D-O44; catalogue-b6 v0.3 — D-B6-7–D-B6-9) built the post-hoc half — envelope, boundary, the allocation advisory with its two legitimacy tests; this package builds the generation-time half, the posture at the moments scope is *composed*, not only when it is allocated): **the lean-composition anchor** — a fourth operating principle, appended to the three in the preamble, **stated once here and cited by every consumer** (D9). The append is additive by construction: principles 1–3 keep their numbers and their wording, and every `principle 2` / `principle 3` citation in the corpus stands untouched · **the Tier-2 drafting posture** (§5.3 step 1) — the story set is composed against the brief's essential scope and nothing beyond it; an adjacent capability discovered while drafting routes to the brief's Deferred section, never into a story. Under the Presale **assumption posture** the same clause is the anti-"end-to-end completion" guard: assumptions fill unknowns *inside* the essential scope, they never widen it (D10). Companion: catalogue-b6 v0.4 — T-17's probe posture and the Source ground-class, T-18's advisory reading it (D-B6-10–D-B6-11). No guard (§6), no question-legality rule (D6), no cap (D7), no depth-calibration text (§3.3), no signal, and no brief-template section touched; the kit's coverage discipline is unchanged — **discovery stays coverage-complete; only composition is bounded.**
**v0.4 change record:** one additive change, ruled 9 Aug 2026 (satellite design conversation — Presale drafting; orchestrator D-O18–D-O19, its §15): §5.4 gains the **defer** disposition — a question may stand as its `[NEEDS CLARIFICATION]` marker with no answer recorded; the expected disposition under the Presale profile (orchestrator §6.5) for client-unreachable questions, batched for one BA-confirmed ruling. No other change; the guards (§6), question legality (D6), and the cap (D7) untouched.
**v0.3 change record:** reuse premise removed per BA Lead ruling — no framework skills exist yet; every technique skill is authored from scratch in Phase 2, with presale chat skills as reference designs only where they exist. §7 reframed from existing-skill mapping to per-skill build briefs; v0.2's "Stage-4 verification parked to Wave 2" voided (nothing to verify — §3.2 is the kit generator's complete spec); §5.3 and §9.2 wording aligned; dependency bumped to writing standard v0.3. **No methodological change** — every behavioral requirement was already stated in §§3.2 and 5.3.

**What this is:** the two techniques that carry a one-line epic to a gate-ready feature spec. **Tier 1 — Epic Scoping Interview** runs in Band 2: an LLM-prepared call kit, a BA-run stakeholder call, and an ingestion step that produces the epic's scope brief (artifact #12). **Tier 2 — Spec-Depth Gap-Filling** runs in Band 3: a draft-first spec skeleton, then capped gap questions at EARS-ready depth, ending at the completeness gate.

**Why it exists:** plan §9 names **question-quality drift** as a top framework risk — an LLM left to elicit freely asks the already-answered, the not-yet-needed, and the vaguely interesting. This document is the structural prevention: every question the framework may ask is generated under rules that make a bad question illegal by construction, not merely discouraged.

**Operating principles** — the whole engine in four lines:

1. **Draft first, ask second.** Both tiers pre-draft their target artifact from everything already known. The holes in the draft *are* the questions. Tier 1 pre-drafts the scope brief; Tier 2 pre-drafts the spec.
2. **No question without a destination.** Every question names, before it is asked, exactly where its answer will land. A question the framework cannot destination-tag is illegal and must not be emitted.
3. **Cited, marked, or asked — never guessed.** Every statement in a framework-generated draft carries a source citation, a `[NEEDS CLARIFICATION]` marker, or comes from a recorded answer. The confident-guess failure mode the writing standard's preamble warns about is killed at generation time, not caught at review time.
4. **Compose lean.** Generation acts compose **the minimal scope that achieves the stated business goal** — depth along the core journey, never breadth of coverage. Discovery stays coverage-complete; composition stays lean — what enters MVP, an essential-scope set, or a story set passes the two legitimacy tests (goal-blocking · hard-requested). **Recorded breadth is welcome; composed breadth is debt.** The pair is the whole of the principle: it is what reconciles a coverage-complete estate with a lean composition, and neither half stands without the other. Consumers cite this line; none restates it.

---

## 1. Position in the framework — division of labor

| Document | Owns | This document's relationship to it |
|---|---|---|
| **Writing standard** (doc 1) | The shape of every spec: skeleton, EARS, tiered acceptance, banned words | Tier-2 drafts land *in* that shape. This document never restates shape rules — it produces content that must satisfy them. |
| **Completeness contract** (doc 2) | The definition of *done* — 61 pass/fail assertions | This document's outputs are designed to be **read by named assertions**: the scope brief is built section-by-section for CC-XA-05, CC-XA-06, CC-H-03, CC-IN-01, CC-OV-02 (§4); Tier-2 question legality is anchored to the contract (§5.5). |
| **Gate definition** (doc 4) | *How* the gate runs — sequencing, checkers, BA prompts | This document delivers a spec **to** the gate and stops. It never runs a check. |
| **Orchestrator rules** (doc 5) | Aspect DAG, thresholds, reopen & waiver machinery, BA-planning loop | This document **emits signals** into that machinery and stops (below). It never executes a reopen, never rules on a waiver, never defines a threshold. |

**Signals this document emits** (doc 5 receives and executes):

| Signal | Emitted when | Payload |
|---|---|---|
| **Routing signal** | A finding belongs to a governance/context artifact, not the brief or spec | finding · destination artifact · proposed edit |
| **Reopen signal** | A finding *contradicts* content of a gated aspect (e.g., a call reveals the canvas's stakeholder picture is wrong) | finding · contradicted artifact + line · conflict statement |
| **Overflow signal** | Tier-2 blocking questions exceed the cap — the brief is too thin (§5.4) | feature · unfilled blockers list · recommendation: Tier-1 supplement |

**BA authority** (decision Q2, restated once): everything the framework generates in this document is **advisory**. The kit is composable — the BA drops, reorders, adds, rewrites questions; recommended answers are rejectable; caps are adjustable. The rules below constrain **the framework's generation**, never the BA's conduct. In particular: the depth-calibration rule (§3.3) forbids the *kit* from containing final-spec questions — it does not forbid the BA from deliberately asking one when the room demands it (the answer parks in Captured Detail, §4).

---

## 2. The two tiers at a glance

| | **Tier 1 — Epic Scoping Interview** | **Tier 2 — Spec-Depth Gap-Filling** |
|---|---|---|
| Band / trigger | Band 2, per epic, after decomposition (presale-flow Stage 5) | Band 3, per feature, at delivery-loop entry after slicing confirmation |
| Unit | Epic | Feature |
| Input | Epic row from the roadmap (name + 2–3-sentence description + phase) + full project context | Full project context + **parent epic's scope brief** |
| Pre-draft target | Scope brief (holes → kit questions) | `spec.md` in standard §2 shape (markers → gap questions) |
| Question depth | Scoping: *whether and where* something is built | Spec: *exactly how it behaves* — EARS-ready detail, data, rules, flows, errors |
| Question style | Call agenda — BA runs it live with a human stakeholder | One at a time, each with a recommended answer, BA (or stakeholder via BA) confirms/edits/rejects |
| Cap | Must-ask ≤ 12, ranked (locked, D1) | Default 7 per feature, BA-adjustable (locked, D7) |
| Output | Scope brief → `.specify/memory/scope/<epic>.md` | Gate-ready spec → `specs/NNN-feature/spec.md` |
| Downstream reader | Scope allocation (Band 2) · Tier 2 · contract assertions §4 | Completeness gate (doc 4) → `/speckit.plan` |

Both tiers run under the **same two guards** — never ask the answered, never ask the not-yet-needed — with tier-specific operational definitions in §6. The unification: at each tier, both guards resolve to the destination discipline at that tier's depth.

---

## 3. Tier 1 — Epic Scoping Interview

### 3.1 Output contract (decision Q2+)

| Field | Value |
|---|---|
| **Expected output** | The epic's **scope brief** (template §4) — plus the call kit as a working file, and a routed-findings batch (signals to doc 5) |
| **Artifact class** | Context (spec-anchored per Q7 — Scope H keeps it alive) |
| **Destination file** | `.specify/memory/scope/<epic>.md` · kit: `.specify/memory/scope/<epic>.kit.md` (locked, D2) |

### 3.2 What the LLM generates: the call kit

**Inputs:** the epic's roadmap row (Stage-5 shape: name, 2–3-sentence description, phase) · canvas · glossary · stakeholder register · context & constraints · domain model · core processes · global out-of-scope · the roadmap (sibling epics) · sibling epics' scope briefs where they exist.

**Generation mechanism:** the framework **pre-drafts the scope brief** from these inputs. Every line it can support gets written *with its citation*; every hole becomes a candidate question. The kit is therefore not a freestanding questionnaire — it is a draft brief plus the questions that would complete it. This single mechanism enforces principle 2: a question exists only because a specific brief section has a specific hole.

**Kit structure — four parts:**

**A. Pre-drafted brief baseline.** The brief template (§4) with every derivable line filled and cited (`[canvas: Problems]`, `[constraints.md §2]`…). This doubles as the **do-not-ask register**: everything cited here is off-limits to the question set (Guard 1, §6) and visible to the BA as the baseline the stakeholder need not repeat.

**B. Question set.** Per hole:

```
Q<n> [destination: <brief section>] [must-ask | if-time]
  <question, in stakeholder language>
  Why it matters: <one line — what decision the answer changes>
```

Rules:
- **Every question carries a destination tag** naming a brief section. A question the generator cannot tag must not be emitted — this is the depth rule (§3.3) executed at generation time.
- Questions are **ranked**: `must-ask` (the call fails its purpose without the answer) vs `if-time`. **Locked (D1):** must-ask ≤ 12 — a scoping call is 30–60 minutes; twelve answered decisions beat twenty rushed ones. If-time questions overflow without limit; the BA composes the final agenda.
- Question language is **stakeholder-facing** — no framework jargon, no EARS, no artifact names.

**C. Risks & assumptions to check.** Assumptions the context *implies* but no stakeholder has confirmed, each phrased as a checkable statement:

```
A<n> — <assumption> · source: <where the context implies it> ·
       impact if wrong: <which Band-2 decision changes>
```

Plus risk probes: areas where this epic's domain typically hides scope (payment edges, permission edges, integration failure ownership, data migration).

**D. Sibling boundary checks.** Where this epic's edges touch other roadmap epics or existing briefs, a check per touchpoint: *"the roadmap holds X in epic Y — confirm nothing X-shaped belongs here."* These feed the brief's Boundaries section and prevent silent scope overlap across epics.

### 3.3 The depth-calibration rule

**The Destination Test.** A question is a **legal scoping question** if and only if its expected answer's primary destination is a **scope-brief decision section** — Essential Scope · Boundaries · Proposed Feature Slicing (rationale) · Assumptions & Risks · External Systems — or a Band-2 decision (allocation). If the only home the answer could have is a **spec.md section** (standard §2 skeleton: an FR, an acceptance criterion, a flow step, an error row, a data field, a business-rule threshold, an NFR target), the question is at **final-spec depth and forbidden in the kit**.

The intuition behind the test: **scoping decides *whether and where* something is built — in this epic or another, this phase or later, this feature slice or that, at acceptable risk or not. Spec decides *exactly how it behaves*.** A question whose answer cannot change a whether/where decision has no business in a scoping call.

**Volunteered ≠ solicited.** The rule constrains what the kit *asks*, not what the call *captures*. Stakeholders volunteer spec-depth detail; the BA never interrupts value. Volunteered detail is ingested into the brief's **Captured Detail** section (§4) — preserved, sourced, and available to Tier 2 as an answered-source — but the kit never *solicits* it, and ingestion never spawns follow-up spec-depth questions from it.

**Good / bad question pairs** — deliberately the *same topic at two depths*, because the line is depth, not subject:

| ✅ Legal scoping question | ❌ Forbidden final-spec question | Why the ❌ fails the Destination Test |
|---|---|---|
| Beyond booking itself, what must a Client be able to do with an existing appointment at launch — cancel, reschedule, both? | What is the exact cutoff for free cancellation, and is the slot released after a late cancellation? | The ✅ answer sets Essential Scope / Deferred. The ❌ answer can only land as a business rule (BR) and its AC — spec.md territory. |
| Do specialists keep their current calendars as the source of truth, or does this system become it? | What happens if the calendar sync is down at the moment a Client confirms a booking? | The ✅ answer names an External System and a constraint that shapes slicing and risk. The ❌ answer is an error path — a WHILE/IF FR plus an E-row. |
| Is taking payment part of booking at launch, or handled outside this epic? | Which payment providers and currencies must be supported? | The ✅ answer draws a Boundary (and checks the sibling epic). The ❌ answer fills an Integration Touchpoints row of a spec in *another epic*. |
| Order of magnitude — how many specialists and monthly bookings should launch carry? | What is the response-time target for slot search under peak load? | The ✅ answer is a sizing assumption that drives allocation and walking-skeleton logic. The ❌ answer is an NFR: metric + target + condition. |
| Who publishes specialist availability today, and does that need to change with this epic? | What fields does a specialist fill in when publishing a slot? | The ✅ answer reveals a role and probably a second feature — Slicing rationale. The ❌ answer is a Data Requirements table. |

### 3.4 The call

**The BA runs it.** The framework's role is *before* (the kit) and *after* (ingestion); in v1 it is not in the room — no live copilot, no real-time transcription analysis. The BA works from the composed agenda, captures notes or records a transcript, and exercises full judgment — including deliberately crossing the depth line when the moment justifies it (§1, BA authority).

### 3.5 Ingestion: notes/transcript → scope brief

**Inputs:** raw notes and/or transcript, plus the kit (the kit's question IDs and pre-draft are the parsing frame).

**Process:**

1. **Map answers to kit questions.** Each kit question is resolved *answered* (extract → write to its destination section), *partially answered* (write what was given; remainder → Open Questions), or *unanswered* (→ Open Questions, status `Open`).
2. **Classify unsolicited findings.** Everything said outside the kit's frame is classified: scoping-level → the matching brief section · spec-depth → Captured Detail · cross-cutting → the routing batch (next step).
3. **Route cross-cutting findings.** A finding that belongs to a governance/context artifact, not the brief:

   | Finding class | Destination |
   |---|---|
   | New stakeholder / changed decision rights | `stakeholders.md` (register) |
   | New role, or a permission implication | `roles-permissions.md` — **governance change**: proposed, never silently written |
   | New domain term, synonym conflict | `glossary.md` |
   | New entity or relationship | `domain-model.md` |
   | New constraint (technical / business / regulatory) | `constraints.md` |
   | New external system (project-wide relevance) | `context.md` + the brief's External Systems |
   | Product-level exclusion | global `out-of-scope.md` |

   The framework assembles the batch as **proposed edits** (finding · destination · edit text). **The BA approves the batch**; on approval the framework writes, and the contract's Scope-H scoped checks fire silently per its §3 cadence.
4. **Contradiction check.** A call statement that *contradicts* an existing context artifact (canvas says specialists self-manage; the stakeholder says admins do) is never silently reconciled: it becomes a conflict finding — proposed edit + **reopen signal** if the artifact belongs to a gated aspect. Doc 5's machinery takes it from there.
5. **Ambiguity rule.** An unclear or hedged statement becomes an Open Question, never a silent interpretation. (Principle 3 applied to briefs: cited, marked-as-open, or answered — never guessed.)
6. **Assemble and finalize.** Open Questions consolidated (unanswered kit questions + new questions the call raised, each tagged with what it touches); brief status → `Scoped`; kit archived beside it.

**Provenance discipline (lightweight):** lines sourced from the call carry no per-line tag — the brief's call log covers them. Lines *pre-known from context* keep their citations from the kit baseline. Only Assumptions & Risks and Open-Question answers always carry per-line sources, because they are the lines someone will later interrogate.

**Open questions after the call — the CC-XA-06 hook.** Unanswered questions do not block the brief; they **stay in it, visibly, with status**. The contract then forces the reckoning at the right moment: at spec time, every open question touching the feature must be *resolved in the spec* or *converted to a `[NEEDS CLARIFICATION]` marker and carried as a waiver* (CC-XA-06 ⚑ — the BA signs this personally). Nothing silently expires. **Locked (D4) — status vocabulary:** `Open` · `Answered — <date> → <where the answer now lives>` · `Overtaken — <reason>` (the question died because scope changed; the reason is mandatory, so an Overtaken line is an audit record, not a deletion).

**Tier-1 supplement** (referenced by the overflow signal, §5.4): a scoped mini-loop for a brief that proved too thin — the framework generates a mini-kit for the *named gaps only*, the BA resolves them via a short call or async exchange with the stakeholder, ingestion appends to the brief. Same rules, smaller radius.

---

## 4. The Scope Brief (artifact #12) — template

Same principle as the writing standard's skeleton: **exact headings, exact order — checkers and Tier 2 parse structure.** Path: `.specify/memory/scope/<epic>.md`.

```markdown
# Scope Brief — <Epic name> (<E-nn>)
Status: Draft | Scoped
Call log: <date(s)> · <participants> · <notes/transcript link>

## 1. Value Anchor
<Why this epic exists — 1–3 lines, each resolving to canvas Problems /
Objectives by name. The chain CC-OV-02 walks is canvas → brief → spec.>

## 2. Essential Scope
<The capabilities that make the epic real — bulleted, capability level
(verb + object + one-line intent). NOT user stories; stories are Tier 2's
job. This is what story drafting (§5.3) and slicing consume.>

## 3. Boundaries
### Excluded — not this epic
<item — where it lives instead: epic / "not planned">
### Deferred — this epic, later
<item — target phase, and what substitutes at launch>

## 4. External Systems
<Named list: system · direction/role in one line · known constraint.
CC-IN-01 compares this list against the spec's Integration table.>

## 5. Assumptions & Risks
| ID | A/R | Statement | Source | Impact if wrong | Status |

## 6. Open Questions
| ID | Question | Touches | Status | Answer / reason |
<Status per D4: Open · Answered — date → destination · Overtaken — reason.
CC-XA-06 reads the Open rows at spec time.>

## 7. Captured Detail (for Tier 2)
<Spec-depth facts volunteered during the call — grouped by topic, verbatim
where the wording matters. Tier 2 treats this section as an answered-source:
it seeds drafts and recommended answers; it is never re-asked.>

## 8. Proposed Feature Slicing
| Feature | Covers (capabilities from §2) | Rationale for the cut | Status |
<Status: Proposed · Confirmed — <date> (D5). Small epic → one row, 1:1,
and the feature level is invisible in practice; large epic → 2–3 rows
(decision C3). CC-XA-05 and CC-H-03 read this table.>

## 9. Routing Log
| Finding | Destination artifact | Date |
<What deliberately left the brief for a governance/context home — so the
brief is honest about what it does not contain, and nobody re-discovers
a routed finding.>
```

**Assertion map — which contract assertions read which section:**

| Brief section | Assertion | What the checker reads |
|---|---|---|
| File itself + §8 | **CC-XA-05** (M, waivable — urgent-feature valve) | Brief exists at its path; the feature appears in §8; §8 Status column carries the delivery-loop-entry confirmation |
| §8 | **CC-H-03** (M, Scope H) | Every epic entering Band 3 has a brief with a non-empty §8 |
| §3 + §6 | **CC-XA-06** (A ⚑) | Nothing in the spec falls into §3 Excluded/Deferred; every §6 `Open` row touching the feature is resolved in the spec or carried as a waiver |
| §4 | **CC-IN-01** (A) | Every system named in §4 appears in the spec's Integration table (and vice versa, or explicit N/A) |
| §1 | **CC-OV-02** (A) | The spec's value claim resolves here or directly to the canvas |

**Pass-binding consequence** (contract §2, worth stating once): the brief is a **checked dependency** of every feature spec in the epic. Any brief edit — including a Tier-2 write-back to §6 statuses — **voids existing PASSes of sibling features** not yet handed off, forcing a cheap re-gate. Batch brief edits accordingly; don't drip them.

**Locked (D3) — the three sections beyond the plan's #12 list** (the plan names essential scope, boundaries, assumptions & risks, open questions, slicing; the task added external systems): **Value Anchor** (it is what CC-OV-02 resolves against — without it the assertion falls back to the canvas alone and the epic-level *why* is unwritten), **Captured Detail** (it is what makes "volunteered ≠ solicited" lossless *and* powers Guard 1 at Tier 2), and **Routing Log** (it is the brief's honesty device — the record of what deliberately lives elsewhere). Each earns its place through a named assertion or a named guard; none is decoration.

---

## 5. Tier 2 — Spec-Depth Gap-Filling

### 5.1 Output contract (decision Q2+)

| Field | Value |
|---|---|
| **Expected output** | Gate-ready `spec.md` in writing-standard shape — plus a brief write-back (§6 Open-Question statuses) and routed-findings signals where cross-cutting content surfaced |
| **Artifact class** | Spec (per-change governance per Q7) |
| **Destination file** | `specs/NNN-feature/spec.md` |

No persistent Q&A log in v1: answers land in the spec (and routed homes); the session conversation is the working record. This deliberately matches the contract's C11 note — traceability at *structurally derivable* granularity only; finer question-to-line links are post-v1.

### 5.2 Context loading — order and precedence

Loaded in this order, each with its job:

| # | Artifact | Why loaded |
|---|---|---|
| 1 | `glossary.md` | Write in canonical terms from the first token — synonym drift (CC-XA-03) is cheaper to prevent than repair |
| 2 | `canvas.md` | The value frame; CC-OV-02's fallback target |
| 3 | `roles-permissions.md` | Story actors must exist verbatim (CC-US-02); authorization tuples visible before drafting (CC-XA-01 awareness) |
| 4 | `domain-model.md` | Entities and relationships the spec may rely on (CC-DA-01, CC-XA-04) |
| 5 | Core processes | Flow context — where this feature sits in the journeys |
| 6 | `context.md` + `constraints.md` | Integration and NFR reality |
| 7 | Global `out-of-scope.md` | The outer fence (CC-OS-03 — reference, don't restate) |
| 8 | Sibling feature specs of the same epic (if any) | Settled shared decisions — states, terms, touchpoints — are answered-sources, not open questions |
| 9 | **Parent epic scope brief — last** | The most specific and freshest layer, loaded on top of everything |

**Precedence rules:** on scope questions for this feature, **the brief wins** over general context. On *definitions* — roles, terms, entities — **governance wins always**: a brief cannot redefine a role or a term; if brief content implies a definition change, that is a **finding** (routing or reopen signal), never a local override.

### 5.3 Draft-first skeleton

1. **Stories first.** From the brief's Essential Scope lines covered by *this* feature (per §8 slicing), the **story-drafting skill** (built from scratch to the brief in §7.2) drafts user stories with acceptance — roles from `roles-permissions.md` only, P1–P3 with ≥ 1 P1, stable US-IDs, tiered acceptance discipline. **Composed against the brief and nothing beyond it (principle 4):** the set covers the essential-scope lines this feature carries and stops there; an adjacent capability discovered while drafting routes to the brief's **Deferred** section (template §4, brief §3 — its existing home), never into a story. Under the Presale **assumption posture** — this section's draft-and-mark discipline run without client access (orchestrator §6.5) — the same clause is the anti-"end-to-end completion" guard: assumptions fill unknowns *inside* the essential scope; they never widen it.
2. **Skeleton around them.** The full standard-§2 skeleton is drafted: EARS FRs linked to stories, flows with error paths, feature NFRs per category, business rules, data tables, integration touchpoints (seeded from brief §4), Out of Scope (seeded from brief §3 + sibling slices), References.
3. **Cite-or-mark, every line.** Every drafted value carries either a citation (context artifact or brief line) or a `[NEEDS CLARIFICATION: …]` marker. **The confidence rule:** a value the framework can *infer* but no source *states* — an industry-default threshold, a plausible validation limit — is drafted **and marked**: `[NEEDS CLARIFICATION: confirm <value> — basis: <inference>]`. The draft stays maximally complete; the uncertainty stays maximally visible. Each such marker is a recommended-answer question in embryo.

The rule of the whole step: **draft everything derivable; mark everything not; ask only about marks that block.**

### 5.4 Gap questions

From the draft's markers, the framework builds the question queue:

**Ordering (impact-first):**
1. Blocks a P1 story's buildability
2. Would fail a **non-waivable** assertion (CC-G-01/02, CC-FR-01, CC-TR-01, CC-XA-01/02)
3. Would fail a waivable assertion
4. Confirms a low-confidence drafted value

**One at a time** — an answer can resolve or kill queued questions (a confirmed state model collapses three data questions into zero), so the queue re-evaluates after every answer.

**Per-question packet:**

```
GQ<n> of <cap> — [legality: <CC-ID(s)> | marker <ref>] [destination(s): <spec §, artifact>]
  Question: <one question, concrete>
  Recommended answer: <specific, concrete — never "it depends">
  Basis: <source line / captured detail / stated inference>
```

The BA (or the stakeholder through the BA, async) **confirms, edits, rejects, or defers**. The answer is written to its destinations; if it is cross-cutting (a new term, a permission tuple, a constraint) it is *also* routed — same table and same BA-approved-batch discipline as §3.5, same reopen signal on contradiction. Brief §6 statuses are updated for any Open Question the answer resolves (pass-binding note in §4 applies).

**Defer (v0.4 — orchestrator D-O18/D-O19 companion):** the fourth disposition. A deferred question records no answer; the draft keeps its marked recommended value (§5.3 cite-or-mark), the `[NEEDS CLARIFICATION]` marker stands as the record, and brief §6 statuses stay open. Legal for any question; the expected disposition under the **Presale profile** (orchestrator §6.5) for questions that cannot reach the client. Under Presale the framework proposes the client-unreachable subset of the queue as one **deferral batch**; the BA confirms, edits, or dissolves the batch in a single act — the §3.5 batch discipline, never per-question drip, never the framework's own call — and the queue re-evaluates once after it. When Tier 2 resumes with client access after the recorded profile switch to Discovery, every surviving marker is a legal question by §5.5 clause (b): deferred packets re-render, answers land, markers resolve. Resume, not rewrite.

**Locked (D7) — cap policy:** **default 7 questions per feature, BA-adjustable per feature**, impact-ordered as above. Rationale: from decent Band-1/Band-2 context a draft should be ~80–90 % derivable; seven focused, recommended-answer questions is ~15–20 minutes of attention, and everything beyond the cap has a dignified path — it stays as a marker and meets the gate's fail-then-waive machinery (CC-G-03), where the BA decides consciously. **Overflow rule:** if *blocking* questions (classes 1–2) exceed the cap, the correct diagnosis is not a longer interrogation — it is a thin brief. The framework stops and emits the **overflow signal**: recommend a Tier-1 supplement (§3.5) for the named gaps. This keeps the tiers honest: Tier 2 fills gaps, it does not re-run discovery.

### 5.5 Question legality — the contract-anchoring rule (D6, adopted)

**The rule under evaluation (from the plan's open question):** *a Tier-2 question is legal iff its answer closes a would-be CC failure or resolves an open `[NEEDS CLARIFICATION]`.*

**For:** it makes Guard 2 fully testable — every question must name its CC-ID or marker in the legality field of its packet, and a question that cannot is illegal by construction (destination discipline, again). It bounds question volume structurally: the contract is finite, so the space of legal questions is finite. It aligns the incentive exactly: questions exist to reach *done*; the contract *is* done. And it operationalizes "EARS-ready depth" — a question is at the right depth precisely when its answer feeds an assertion.

**The gap in the naive rule:** the contract checks completeness, form, and consistency — a spec can satisfy every assertion while being *factually wrong about the domain*. A drafted BR-002 of "24 hours" parses, links, and passes; the clinic's actual policy might be 48. Validation questions — "is this drafted value *true*?" — are legitimate RE practice (BABOK 7.3) yet close no assertion failure, so the naive rule forbids exactly the questions that catch wrong-but-well-formed content.

**The fix is already in §5.3:** the **cite-or-mark corollary**. Any value drafted from inference rather than source *must* carry a marker. A marked value makes its confirmation question legal under clause (b) of the rule. So the rule's coverage is complete *iff* marking is honest — validation questions are marker-resolutions by construction.

**Residual risk:** overconfident *unmarked* inference — the framework drafts a wrong value and cites a source that doesn't actually state it. No legality rule catches this (there is no question to rule on); it is caught by BA draft review and, in Phase 3, by the wrong-draft log (§10), exactly parallel to how the contract's §10 treats gate escapes.

**Ruled (D6): adopted.** *A Tier-2 question is legal iff its answer (a) closes a named would-be contract failure, or (b) resolves an open `[NEEDS CLARIFICATION]` marker — with the cite-or-mark corollary as the rule's mandatory companion: unconfirmed inference must be marked, which is what makes (b) cover validation.* Every question packet names its anchor; the anchor is checkable; Guard 2 at Tier 2 is thereby a test, not a slogan.

---

## 6. The two guards — testable form

### Guard 1 — never ask what's already answered

**The Citation Test:** before emitting a question, the framework must attempt to answer it from the answered-source set. **If it can cite a source line, the question is illegal — cite the line in the draft instead.** If it cannot cite, it may ask. "Derivable" is bounded at *citable*: a directly stated fact or a one-step consequence of one (glossary defines slot duration = service duration ⇒ never ask slot length). Multi-step speculative inference does not count as answered — that is inference, and inference is draft-and-mark territory (§5.3), not silent knowledge.

The test is falsifiable from the outside, which is what makes it a test: a BA who sees a question whose answer exists **falsifies it by producing the source line**. Every falsification goes to the false-ask log (§10) and tunes the technique.

**Answered-source sets, per tier:**

| Tier | Answered-sources |
|---|---|
| **Tier 1** | canvas · glossary · stakeholder register · context · constraints · domain model · core processes · global out-of-scope · roadmap · **sibling epics' scope briefs** · this epic's own prior brief content |
| **Tier 2** | all Tier-1 sources **+** parent scope brief **including Captured Detail** · governance (constitution, roles-permissions, standards) · **sibling feature specs of the same epic** · this feature's draft-in-progress · answers already given this session |

**Locked (D8):** the two lists above are ratified. The load-bearing inclusions are **Captured Detail** (a volunteered answer is an answer; re-asking it burns stakeholder trust) and **sibling feature specs** (a state model settled in feature 004 is settled for 005).

### Guard 2 — never ask what's not yet needed

**Needed-by-what, per tier:**

| Tier | An answer is *needed* iff it changes… | Operational test |
|---|---|---|
| **Tier 1** | …a Band-2 decision: epic scope content, a boundary, the slicing, the allocation, the risk posture | **The Destination Test (§3.3)** — Guard 2 at Tier 1 *is* the depth-calibration rule |
| **Tier 2** | …this feature's gate outcome | **The legality rule (§5.5)** — closes a named CC failure or resolves a marker |

The symmetry to hold onto: **both guards, at both tiers, collapse into the destination discipline.** Guard 1 says a question must not have an existing source; Guard 2 says it must have a future destination. A legal question is exactly one with no source and one destination.

---

## 7. Skill build briefs — reference designs & framework requirements

**Ruling (BA Lead, 20 July 2026), superseding the plan's ★-reuse premise:** no framework skills exist. Every technique skill is **authored from scratch in Phase 2**. Where a presale-flow chat skill exists, it serves as a **reference design** — proven interaction patterns and content heuristics to mine — never a component to import. This section is therefore the build brief for the two skills this document's techniques require: what the reference design contributes (if one exists), and what the framework skill must satisfy.

### 7.1 Tier-1 call-kit generator

**No reference skill assumed.** "Stage 4 — Questions to Client" exists in the presale flow's vocabulary (the Stage-5/6 presale skills name its answers as a context input), but the framework does not depend on any such artifact existing. **§3.2 is the complete specification of this skill:** pre-drafted brief baseline with citations · destination-tagged questions (a question without a brief-section tag must not be emitted) · must-ask/if-time ranking, must-ask ≤ 12 · risks & assumptions register (statement · source · impact-if-wrong) · sibling boundary checks · the do-not-ask register · stakeholder-facing language · output to `<epic>.kit.md`. Build to §3.2; nothing else is needed.

### 7.2 Tier-2 story-drafting skill

**Reference design exists:** the presale Stage-6 user-stories chat skill (read in full this session). Built from scratch for the framework, with the reference mined and the presale behaviors deliberately left behind:

| Reference design contributes (mine these) | Framework skill must satisfy (from scratch) |
|---|---|
| Story drafting mechanics: strict *As a [role], I want [goal], so that [benefit]* with single-intent goals and non-restated benefits · role discipline grounded in project context, no invented roles · AC as testable one-condition bullets in system perspective, specific field names, no "etc.", 3–6 per story · sizing judgment: combine-when-logical, split-by-actor-step, no story too small/too large (> 8 AC ⇒ split) · per-epic-type story checklists (auth, CRUD, real-time, reporting, notifications) as recall aids | **Roles verbatim from `roles-permissions.md`** — the reference's soft "not 'user' if a more precise role is available" hardens to the standard's ban ("as a user" fails CC-US-02) · **P1–P3 priorities with ≥ 1 P1** (CC-US-03) — the reference has no priority model · **stable US-IDs, never reused** (CC-US-04) · **tiered acceptance** — the reference is checklist-only; the Gherkin tier with concrete data and the anti-re-narration rule (CC-AC-04) come from the standard §5 · **one capability per story** enforced strictly (CC-US-05) — "combine when logical" must never chain behaviors · **no ungrounded invention**: the reference's "(optional) enhancement" behavior is excluded — a bullet or story the brief doesn't ground is scope drift and a CC-XA-06 violation; a genuinely good idea becomes a routed finding or an Open Question, never silent scope · **output shape**: the spec.md §2 *User Stories* section — no standalone tables, no spreadsheet-oriented AC formatting · **glossary-canonical language + cite-or-mark** throughout |

*(For orientation: the presale Stage-5 epics skill defines the epic-table shape — name · 2–3-sentence description · phase — that is Tier 1's input (§3.2). This document depends on that shape, not on that skill; the framework's decomposition technique is Wave-2 authoring.)*

---

## 8. Running example — appointment booking, continued

The world of the writing standard §14 and the contract §7, extended upstream. Epic **E-03 "Appointment Booking"** — roadmap description: *"Clients book specialists' published slots online instead of calling. Covers slot browsing, booking, cancellation, and specialist notifications."* Phase: MVP.

### 8.1 Call-kit excerpt (`E-03.kit.md`)

```
PRE-DRAFTED BASELINE (do not re-ask — cited):
· Actors: Client, Specialist                      [canvas: Customers]
· Problem: ~30% of booking calls unanswered;
  lost bookings                                    [canvas: Problems P-1]
· Objective: reduce lost bookings                  [canvas: Objectives O-2]
· Calendar integration expected                    [canvas: Third-Party Connections]

QUESTION SET (must-ask 6 of 10 shown):
Q1 [destination: Essential Scope] [must-ask]
   Walk me through how a booking happens today, end to end — where does
   it break?
   Why it matters: confirms the value line and surfaces the real capability list.
Q2 [destination: Essential Scope / Boundaries] [must-ask]
   Beyond booking itself, what must a Client be able to do with an
   existing appointment at launch — cancel, reschedule, both?
   Why it matters: sets launch scope vs deferred.
Q3 [destination: Boundaries] [must-ask]
   The roadmap holds payments in "Online Payment" (E-07, Phase 2) —
   confirm nothing payment-shaped belongs in booking at launch.
   Why it matters: sibling boundary; silent overlap is the expensive kind.
Q4 [destination: External Systems] [must-ask]
   Do specialists keep their current calendars as the source of truth,
   or does this system become it?
   Why it matters: integration direction, biggest technical risk, slicing input.
Q5 [destination: Assumptions & Risks] [must-ask]
   Order of magnitude — how many specialists and monthly bookings
   should launch carry?
   Why it matters: allocation and walking-skeleton sizing.
Q6 [destination: Slicing rationale] [must-ask]
   Who publishes specialist availability today, and does that need to
   change with this epic?
   Why it matters: likely a second feature with a different primary role.

RISKS & ASSUMPTIONS TO CHECK:
A1 — Existing calendars must be kept, not replaced · source: canvas
     Third-Party Connections · impact if wrong: integration scope and
     slicing change materially.
A2 — Specialists self-publish availability · source: implied by canvas
     Core Functions · impact if wrong: an admin role enters scope
     (roles-permissions change).
```

### 8.2 Filled scope-brief excerpt (`.specify/memory/scope/E-03.md`)

```markdown
# Scope Brief — Appointment Booking (E-03)
Status: Scoped
Call log: 2026-07-14 · Olena (clinic network COO, sponsor) + 2 specialists
          · transcript: <link>

## 1. Value Anchor
Reduce lost bookings [canvas: Objectives O-2] — ~30% of booking calls go
unanswered today [canvas: Problems P-1]; call confirmed evenings/weekends
are the worst window.

## 2. Essential Scope
- Browse a Specialist's published availability
- Book an available slot
- Cancel own appointment
- Notify the Specialist of bookings and cancellations
- Publish specialist availability (→ F2, see §8)

## 3. Boundaries
### Excluded — not this epic
- Payments — epic Online Payment (E-07), Phase 2 (confirmed, Q3)
- Recurring appointments — not planned (confirmed on call)
### Deferred — this epic, later
- Reschedule-in-place — Phase 2; cancel + rebook is acceptable at launch
  (Olena, on call)

## 4. External Systems
- Specialists' calendars — outbound sync of appointment events;
  system of record stays with this product (Q4). Providers: → OQ-2.

## 5. Assumptions & Risks
| ID | A/R | Statement | Source | Impact if wrong | Status |
|---|---|---|---|---|---|
| A1 | A | Existing calendars kept, not replaced | canvas → confirmed on call | integration scope, slicing | Confirmed → routed to constraints.md |
| R1 | R | Calendar provider contract not signed | call (Olena) | sync spec blocked at Tier 2 | Open — owner: Olena |

## 6. Open Questions
| ID | Question | Touches | Status | Answer / reason |
|---|---|---|---|---|
| OQ-1 | Cap on simultaneous booked appointments per Client? | F1 | Answered — 2026-07-16 → spec 004 BR-001 (cap: 3) | resolved at Tier 2 |
| OQ-2 | Which calendar providers must sync at launch? | F1 | Open | blocked on R1 |

## 7. Captured Detail (for Tier 2)
- Cancellation policy: "Late cancellations cost us money — people cancel
  an hour before." (Specialist, verbatim) — no concrete cutoff given.
- Specialists track no-shows manually today and want that to continue
  in-system. (→ term "No-show" routed to glossary, see §9)

## 8. Proposed Feature Slicing
| Feature | Covers | Rationale | Status |
|---|---|---|---|
| F1 004-appointment-booking | browse · book · cancel · notify | Client-side journey; independently deliverable | Confirmed — 2026-07-15 |
| F2 specialist-availability-publishing | publish availability | distinct primary role (Specialist); distinct journey | Proposed |

## 9. Routing Log
| Finding | Destination | Date |
|---|---|---|
| A1 confirmed → constraint "existing calendars retained" | constraints.md | 2026-07-14 |
| Term "No-show" | glossary.md | 2026-07-14 |
| Clinic admins currently manage some calendars (contradicts canvas self-manage picture) | reopen signal → Stakeholders aspect (doc 5) | 2026-07-14 |
```

The continuity to notice: **OQ-2 is the exact gap the contract's worked example later waives** (W-004-01: "calendar-sync failure expectation deferred · provider contract unsigned") — the risk enters here, stays visible in the brief, and meets its conscious acceptance at the gate. And §7's cancellation quote is the seed of the Tier-2 exchange below.

### 8.3 One Tier-2 gap-question exchange (feature 004)

The draft skeleton, at §5.3 step 3, contains:

```
BR-002 [NEEDS CLARIFICATION: confirm free-cancellation cutoff — captured
detail says late cancellations are costly, no concrete boundary given;
basis for recommendation: common practice 24h]
```

The question packet:

```
GQ1 of 7 — [legality: resolves marker BR-002; unresolved → CC-G-03 fail;
            the value feeds CC-BR-01 (threshold required)]
           [destinations: BR-002 · US2 acceptance · FR-cancellation reference]

Question: What is the free-cancellation boundary, and what happens to the
slot on a late cancellation?

Recommended answer: Free cancellation strictly more than 24 hours before
start_time. Inside 24 hours, cancellation is allowed but the slot is NOT
released for rebooking — this directly addresses the stated cost concern.
Basis: Captured Detail (specialist quote) + common practice for the cutoff;
the not-released clause is the mechanism that protects Specialist income.

BA: confirms.
```

The answer lands: **BR-002** (`Free cancellation window: strictly more than 24 hours before start_time. Inside 24h, cancellation is allowed but the slot is NOT released for rebooking.`) · a checklist AC line under US2 (`- [ ] Cancellation inside 24h of start_time keeps the slot unavailable for rebooking (BR-002)`) · the cancellation FR gains its BR-002 reference. The marker is gone; question count 1 of 7; the queue re-evaluates (two queued data-table questions about slot release die with this answer).

---

## 9. Real-life walkthroughs

### 9.1 Tier 1, end to end

1. **BA:** opens the roadmap, selects E-03, invokes the Tier-1 technique.
2. **Framework:** loads the context stack, pre-drafts the brief (14 lines cited, 9 holes), emits the kit: 10 must-ask + 3 if-time questions, 2 assumptions, 1 sibling boundary check, do-not-ask register of 4 cited facts.
3. **BA:** composes the agenda — drops Q7 (the client answered it by email last week; false-ask logged with the source), adds one client-specific question, reorders for conversational flow, books the call.
4. **BA:** runs the call; transcript captured.
5. **BA:** feeds transcript + margin notes to ingestion.
6. **Framework:** proposes the filled brief + a routing batch (term "No-show" → glossary; A1-confirmed → constraints; clinic-admin mention → stakeholder register) + one conflict finding (call contradicts the canvas's specialists-self-manage picture) with a **reopen signal** on the Stakeholders aspect. Two kit questions unanswered → Open Questions, status `Open`.
7. **BA:** approves the batch, amends one glossary wording, rules the conflict real → doc 5's reopen machinery takes the signal.
8. **Framework:** writes the brief (status `Scoped`) and the routed edits; Scope-H scoped checks fire silently and pass; kit archived beside the brief.

### 9.2 Tier 2, end to end

1. **BA:** selects feature 004 from the roadmap; confirms the slicing row (brief §8 status → `Confirmed`, dated).
2. **Framework:** loads the context stack in §5.2 order, brief last; drafts the full skeleton — 3 stories (P1/P1/P2) via the story-drafting skill to §7.2's requirements, 9 EARS FRs, flows with 3 error rows, data tables, integrations seeded from brief §4. Result: 11 sections filled with citations, 4 markers.
3. **Framework:** builds the question queue — 3 blocking (classes 1–2), 1 low-confidence confirm; cap 7, no overflow. Asks GQ1 (the cancellation cutoff, §8.3) with its recommended answer.
4. **BA:** confirms GQ1. Framework writes BR-002 + AC + FR reference; two queued questions die; brief OQ-1 flips to `Answered → spec 004 BR-001` (pass-binding note: no sibling has a PASS yet, nothing voided).
5. **Framework:** asks GQ2 — the (Specialist × Appointment × cancel) tuple has no policy row in `roles-permissions.md`; recommended edit proposed as a **governance routing signal**, since a spec cannot self-grant a permission (CC-XA-01/CC-XA-07 awareness).
6. **BA:** approves the governance edit; framework routes it; scoped Scope-H check fires silently.
7. **Framework:** GQ3–GQ4 resolved; one marker survives (`OQ-2` calendar providers — still blocked on R1). It stays in the text as a named location, waiver candidate for the gate (the future W-004-01).
8. **BA:** reviews the complete draft, runs the standard's §15 self-check, submits to the gate — **document 4 takes over.**

---

## 10. Continuous improvement — the question-quality loop

Phase 3 measures first-pass correctness and gate catch-rate (plan §8); this document adds the elicitation-side instruments, parallel to the contract's §10:

| Log | Entry condition | What it tunes |
|---|---|---|
| **False-ask log** | A question is asked whose answer a source already stated — falsified by the BA producing the source line (Guard 1 violation) | Answered-source loading, citation retrieval |
| **Wrong-draft log** | A confidently *cited or unmarked* drafted value is later corrected — the residual risk of §5.5 | Cite-or-mark honesty, inference marking threshold |
| **Dead-answer log** | An asked question's answer changed nothing in any destination artifact | Guard 2 calibration, destination tagging, over-asking |

Accepted patterns bump this document's version — iterate technique and prompts, not tooling, exactly as Phase 3 mandates.

---

## 11. Review record (v0.1 → v0.2)

Eight decisions ruled by the BA Lead, 20 July 2026 — all recommendations accepted as stated:

1. **D1 — Kit discipline:** must-ask ≤ 12, ranked must-ask / if-time; BA composes the final agenda (§3.2).
2. **D2 — Kit persistence:** kept as `.specify/memory/scope/<epic>.kit.md` — audit trail, do-not-ask evidence, §10 tuning input (§3.1).
3. **D3 — Brief template additions:** Value Anchor · Captured Detail · Routing Log confirmed as part of artifact #12's structure, each anchored to a named assertion or guard (§4).
4. **D4 — Open-question statuses:** `Open` · `Answered — date → destination` · `Overtaken — reason mandatory` (§3.5).
5. **D5 — Slicing confirmation:** recorded in the Status column of brief §8 — the machine-readable home for CC-XA-05's "confirmed at delivery-loop entry" (§4).
6. **D6 — Contract-anchored question legality (the plan's explicit open question): adopted** — legal iff the answer closes a named would-be CC failure or resolves an open `[NEEDS CLARIFICATION]`, with the cite-or-mark corollary as mandatory companion; residual risk owned by BA draft review + the wrong-draft log (§5.5).
7. **D7 — Tier-2 cap:** default 7 per feature, BA-adjustable, impact-ordered; overflow ⇒ Tier-1 supplement signal, never a longer interrogation (§5.4).
8. **D8 — Answered-source sets:** both lists ratified, including Captured Detail and sibling feature specs (§6).

Additionally ruled: the Stage-4 mapping verification is **parked to Wave 2** (§7) — the plan schedules Stage-4's formal reuse there; the §5-vs-§8 cancellation contradiction found in the writing standard during drafting is routed to a **standard erratum in a separate conversation** (standard v0.2 → v0.3); this document's examples already follow the authoritative BR-002 formulation.

**v0.2 → v0.3 (same day).** BA Lead ruling supersedes the plan's ★-reuse premise: **no framework skills exist; all technique skills are authored from scratch in Phase 2**, with presale chat skills as reference designs only where they exist. Consequences applied: §7 reframed from existing-skill mapping to per-skill build briefs (7.1 kit generator — §3.2 is its complete spec, no reference assumed; 7.2 story-drafting skill — presale Stage-6 skill mined as reference design); the "Stage-4 verification parked to Wave 2" ruling above is **void** — there is nothing to verify; §5.3, §9.2, and the §2/§4 stage vocabulary decoupled from reuse. Standard-erratum routing above is closed: writing standard v0.3 issued. No methodological change.

---

## 12. Review record (v0.4 → v0.5)

Two decisions ruled by the BA Lead, 13 August 2026 — **lean scope posture**, applied as stated. Origin: Run-1 field feedback, 12 August 2026. The framework composed a twenty-epic full-coverage roadmap for an engagement that needed a lean POC composition — breadth where the goal wanted depth. The scope frame (orchestrator §20 · catalogue-b6's second review record) built the post-hoc half: the envelope, the delivery boundary, and the allocation advisory that names untraceable scope inside the boundary. What had no home was the posture at the moment scope is *composed* — the generation-time half this package rules.

**What did not move.** No guard, no question-legality rule (D6), no cap (D7), no depth-calibration text (§3.3), no signal class, no brief-template section, and no assertion — this document defines none. Principles 1–3 keep their numbers and their wording, so every `principle 2` / `principle 3` citation in the corpus resolves exactly as before.

| # | Decision | Ruling (adopted as stated) | Where |
|---|---|---|---|
| **D9** | The lean-composition anchor, and its home — one law about *what generation composes*, cited corpus-wide and restated nowhere | **A fourth operating principle:** *generation acts compose the minimal scope that achieves the stated business goal — depth along the core journey, never breadth of coverage. Discovery stays coverage-complete; composition stays lean — what enters MVP, an essential-scope set, or a story set passes the two legitimacy tests (goal-blocking · hard-requested). Recorded breadth is welcome; composed breadth is debt.* **The coverage-complete / lean-composition pair is part of the law, not a gloss on it** — it is what reconciles the anchor with T-17's coverage-complete requirement and with the scope frame's boundary model (the full picture visible; the lean composition billable). **Home: the preamble's numbered principles**, appended as principle 4 — the least-cost placement, and the one the corpus already reads: principles 2–3 are cited from every catalogue batch and from the orchestrator, so the list is the corpus's principle surface in fact as well as in name. The append renumbers nothing, restructures nothing, and disturbs no locked citation; the lead-in's line count is the only other word that moves. **Register: stated once here; consumers cite it and none restates it** | Preamble · §5.3 (D10) · catalogue-b6 T-17 §2/§4, T-18 §4 (D-B6-10–D-B6-11) |
| **D10** | Tier-2 drafting posture — the story set is where composed breadth enters at spec grain, and §5.3 bounded it nowhere | **One clause at §5.3 step 1.** The drafted story set is composed **against the brief's essential scope and nothing beyond it**; an adjacent capability discovered while drafting routes to the brief's **Deferred** section — its existing home (template §4, brief §3) — and **never becomes a story**. The anchor is cited, not restated. Under the **Presale assumption posture** (orchestrator §6.5 — this section's draft-and-mark discipline run without client access) the same clause is the anti-"end-to-end completion" guard: **assumptions fill unknowns *inside* the essential scope; they never widen it.** Nothing else in §5.3 moves — cite-or-mark, the confidence rule, and the step's own summary line stand as written | §5.3 |

**Conflict scan (13 August 2026) — against standard v0.3 · contract v0.2 · gate v0.6 · orchestrator v0.16 · catalogues b1 v0.4, b2–b5 v0.2, b6 v0.4.** Checked: the append's additivity — `principle 2` and `principle 3` resolve unchanged at every citation site in the corpus (catalogues b1–b6, orchestrator §6.1), and no site cites a principle by count rather than by number · the orchestrator's own §1 runtime rules are a **separate three-item list**, always cited as "§1 principle 2" and never unqualified, so an unqualified `principle 4` is unambiguous and collides with nothing · T-17's coverage-complete and exclusive-partition requirements are untouched — the anchor bounds composition, never discovery, and says so in its own text · the two legitimacy tests are **cited by their shorthand, not re-legislated**: their locked wording stays D-B6-8's · §3.3's Destination Test and the two guards are untouched — the anchor governs what a draft *composes*, the guards what a question may *ask* · D7's cap is untouched: a leaner story set makes fewer markers, which is a consequence, not a rule change · the brief's Deferred section is D3/§4 ground and gains no new field — the clause routes to it, it does not redefine it · the Presale sentence consumes orchestrator §6.5 and D-O19's assumption posture by reference and re-mechanizes neither. **No spine contradiction found; no erratum issued.**

---

*v0.5 · lean scope posture — the lean-composition anchor as **principle 4** (preamble; stated once, cited corpus-wide) · the Tier-2 drafting posture, with the Presale anti-completion guard (§5.3 step 1) — applied 13 Aug 2026 (D9–D10, §12; companion: catalogue-b6 v0.4 — D-B6-10–D-B6-11) · v0.4 · defer disposition added 9 Aug 2026 (§5.4; orchestrator D-O18–D-O19 companion) · v0.3 20 July 2026 · runs on writing standard v0.3 + completeness contract v0.2 · emits signals to orchestrator rules (document 5) · delivers to gate definition (document 4) · decisions D1–D10 locked (§11 · §12) · all framework skills authored from scratch — build briefs in §7*
