<!--
  BA-Native Spec — Scope-F assertion cards (build plan §2.5). COMPILED, never
  hand-edited: `tests/check-cards.py --record` regenerates this file from the
  completeness contract at its pinned version and the default mode byte-compares.

  What a card is (build plan §2.5): assertion ID + the contract's exact
  pass-condition text + its Checks set + the non-waivable / ⚑ flag — nothing
  else. The layering rule (contract §2): the runtime never loads the contract
  itself; the chain stays verifiable one-way — card → CC-ID → contract line →
  its grounding anchor. Grounding tags, authoring-time notes, review records
  and rationale prose are methodology-layer content and are not here.

  Who reads this: the `ba-gate` subagent, Stage 3 of a Scope-F run. The M
  assertions are not here — they are the vendored checker scripts.
-->

# Scope-F assertion cards — the A pass

The pass condition is the card's text. A verdict is per assertion, with
evidence; a category-level judgement is invalid gate output.

**Flags** — `⚑` the BA reviews this assertion's evidence and signs it
individually, even inside an otherwise clean PASS · `[non-waivable]` no waiver
can exist for this assertion; the printed line below is the refusal reason.

**Checks shorthand** (the artefacts a card's Checks set names) —
The artifact(s) the checker reads. Shorthand: `spec` = `specs/NNN-feature/spec.md` · `roles` = `roles-permissions.md` · `gloss` = `glossary.md` · `dm` = `domain-model.md` · `brief` = `.specify/memory/scope/<epic>.md` · `oos` = global out-of-scope · `canvas` = `canvas.md` · `gov` = constitution + governance files · `mem` = `.specify/memory/*` · `trace` = `specs/NNN-feature/traceability.md` · `hist` = prior spec revision

## Global assertions (CC-G)

### CC-G-02 · Checks: spec · [non-waivable]
No stub content: every required section contains substantive, feature-specific content or explicit `N/A — <reason>`. Empty bodies, placeholder tokens (TBD, TODO, "to be defined", template boilerplate) fail. **The marker namespace is closed:** the framework defines `[NEEDS CLARIFICATION: …]` and `[CONFLICT: …]` and no others. Any further bracketed token of marker shape — an upper-case label, with or without a colon: `[ASSUMED: …]`, `[TBD]` — is a mint, is not content, and fails wherever it stands in place of required content, a table cell included. A mint is converted to `[NEEDS CLARIFICATION: …]`, never honoured.

> No waiver can exist: An *unnamed* gap cannot be risk-accepted. The path is: name it — convert the stub to `[NEEDS CLARIFICATION: …]`, which fails CC-G-03, which **is** waivable. Every accepted gap is thereby a named gap, by construction.

### CC-G-05 · Checks: spec
Zero implementation prescriptions: no technology choices, endpoints, storage schemas, or UI layout directives. Naming an external system as a mandated constraint (integration touchpoint) is not a violation; choosing the solution stack is.

### CC-G-06 · Checks: spec
Every normative statement (SHALL / MUST) lives inside an ID-bearing structure (FR, BR, NFR, AC). Normative language in Overview, flow prose, or notes fails — an untracked requirement is invisible to the traceability graph.

## C1 · Overview & Value (CC-OV)

### CC-OV-01 · Checks: spec
The Overview states what the feature does and the user/business problem it addresses, with no solution design.

### CC-OV-02 · Checks: spec+canvas+brief
The value claim names at least one objective or problem that resolves to `canvas.md` (Problems / Objectives) or to the parent epic scope brief.

## C2 · User Stories (CC-US)

### CC-US-05 · Checks: spec
Each story expresses one capability. A capability clause that chains behaviors ("and", "manage", "handle") fails.

## C3 · Acceptance Criteria (CC-AC)

### CC-AC-02 · Checks: spec
Every checklist criterion is a single verifiable assertion about observable system behavior.

### CC-AC-03 · Checks: spec
Every Gherkin scenario uses concrete data — named actors, real timestamps, quantities. Placeholder values (`<x>`, "some", "a user") fail.

### CC-AC-04 · Checks: spec
No Gherkin scenario re-narrates its FR: each adds a concrete path or data combination the FR text does not spell out; otherwise it must be a checklist line.

## C4 · Functional Requirements (CC-FR)

### CC-FR-03 · Checks: spec
Each FR specifies one behavior — a single trigger→response. A compound response is legal only as one observable outcome (create + display confirmation); chained independent behaviors fail and must split.

### CC-FR-04 · Checks: spec
Every FR names its actor and its specific object, and its response is externally observable. "Update the record" fails.

## C5 · Flows, States & Errors (CC-FL)

### CC-FL-01 · Checks: spec
The main flow is present as numbered steps, each with actor → action → observable result.

### CC-FL-03 · Checks: spec
Every error row states trigger + system behavior + user-visible outcome; none of the three empty or generic ("show error").

### CC-FL-04 · Checks: spec
Every row of the alternates/errors table is governed by a requirement in this spec: an unwanted-behavior FR (IF … THEN, WHILE) for an error, an event-driven FR (WHEN) where the row is an alternate, or a BR the row's behavior applies. Coverage is semantic — the evaluator searches the spec's FR (§3) and BR (§6) lists and fails only where no governing requirement exists; an inline citation such as `(FR-002)` is permitted style, never the pass condition, and the template's four columns are the table's whole shape. The evidence names, per row, the governing FR or BR, or `none`. Unspecified error handling fails with the row named.

### CC-FL-05 · Checks: spec
Every state name used in flows, FRs, or acceptance exists in the Data section's states table (where the entity has a lifecycle).

## C6 · Non-Functional Requirements (CC-NF)

### CC-NF-01 · Checks: spec
Every NFR is metric + target + condition.

### CC-NF-03 · Checks: spec+gov
No NFR restates a global budget from governance; the spec adds feature-specific deltas only, referencing the global.

## C7 · Business Rules (CC-BR)

### CC-BR-01 · Checks: spec
Every BR is one testable rule with a stable BR-ID; computational rules include the formula or threshold.

### CC-BR-03 · Checks: spec+gov
Cross-feature rules are referenced from governance, never restated.

## C8 · Data Requirements (CC-DA)

### CC-DA-01 · Checks: spec+dm
Every entity named in the spec exists in `domain-model.md`. A new entity requires a domain-model update first, then a reference.

### CC-DA-02 · Checks: spec
The fields table covers every field this feature reads or writes: entity · field · type · required · validation, all filled.

### CC-DA-03 · Checks: spec
Every validation is concrete — format, range, limit, or source of allowed values. "Valid input" fails.

### CC-DA-04 · Checks: spec
Where an entity has a lifecycle: the states table lists every state; every state has allowed transitions with triggers or an explicit terminal mark.

## C9 · Integration Touchpoints (CC-IN)

### CC-IN-01 · Checks: spec+brief
Every external system named anywhere in the spec or the epic scope brief appears in the Integration table — and every table entry is actually used by the feature. If none exist: explicit `N/A — no external touchpoints`.

### CC-IN-02 · Checks: spec
Every integration row is complete: system · direction · what is exchanged (payload meaning) · constraint.

### CC-IN-03 · Checks: spec
Every integration has a declared failure expectation — what happens when the external system is down — linked to a WHILE/IF FR or an error path.

## C10 · Out of Scope (CC-OS)

### CC-OS-02 · Checks: spec
Every exclusion names where it lives instead: a phase, an epic/feature, or "not planned".

### CC-OS-03 · Checks: spec+oos
No exclusion restates the global out-of-scope artifact; product-level boundaries are referenced.

### CC-OS-04 · Checks: spec
Nothing excluded here is simultaneously specified by a story or FR of this spec.

## C12 · Cross-Artifact Dependencies (CC-XA)

### CC-XA-01 · Checks: spec+roles · ⚑ · [non-waivable]
**Authorization coverage:** for every role × entity × action tuple this feature's stories and FRs exercise, `roles-permissions.md` contains an explicit policy row. Missing tuples fail with the tuple named.

> No waiver can exist: Authorization is the one class where a confident agent guess is a security incident, and the constitution's "never infer permissions from personas" principle exists precisely to be unwaivable.

### CC-XA-03 · Checks: spec+gloss
Every domain term used exists in `glossary.md`, and the glossary's canonical term is the one used — no synonym drift within the spec or against the glossary.

### CC-XA-04 · Checks: spec+dm
Every entity relationship the spec relies on (flows, data, FRs) exists in `domain-model.md`.

### CC-XA-06 · Checks: spec+brief · ⚑
The spec stays inside the brief: nothing specified falls into the epic's excluded or deferred scope; every open question in the brief that touches this feature is resolved in the spec or carried as a waiver.

### CC-XA-07 · Checks: spec+mem
Nothing lives only in the spec: every role, term, entity, or constraint the spec introduces exists in its governance/context home. A spec-only definition fails — define upstream, then reference.
