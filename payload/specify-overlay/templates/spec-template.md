# <Feature name>

<!--
  BA-Native Spec — feature spec skeleton.
  Compiled from the Geniusee Spec Writing Standard §2 (the ten sections, exact
  names, exact order). CC-G-01 parses these headings: do not rename, do not
  reorder, do not add or drop a section.

  Shape rules, EARS grammar, the banned-word list, and the tiered-acceptance
  decision rule live in AGENTS.md / the CLAUDE.md framework block — referenced,
  never restated here (standard golden rule 5).

  Every section carries substantive, feature-specific content or an explicit
  `N/A — <reason>`. A heading with placeholder text under it fails CC-G-02;
  an unknown carries `[NEEDS CLARIFICATION: <question>]`, which fails CC-G-03
  and is waivable at the gate. Delete these comments as you fill the file.
-->

## Overview & Value

<!-- 2–4 sentences: what the feature does, and the user/business problem it
     addresses. No solution design. The value claim must resolve by name to a
     canvas Problem/Objective line-ID or to the parent epic scope brief §1
     (CC-OV-01, CC-OV-02). -->

## User Stories

<!-- US<N> (P<1|2|3>) — As a <role>, I want <capability>, so that <value>.
     Roles verbatim from .specify/memory/roles-permissions.md. At least one P1.
     Acceptance criteria sit directly beneath each story — checklist lines for
     simple rules, Gherkin with concrete data for non-trivial behavior.
     (CC-US-01…05, CC-AC-01…04) -->

## Functional Requirements

<!-- FR-0NN (US<n>) — one EARS pattern, one SHALL, named actor and object,
     externally observable response. (CC-FR-01…05) -->

## Flows, States & Errors

<!-- Main flow as numbered steps: actor → action → observable result.
     Then the alternates/errors table — every row: trigger · system behavior ·
     user-visible outcome. A happy-path-only flow fails. (CC-FL-01…05)

     | # | Trigger | System behavior | User-visible outcome |
     |---|---|---|---| -->

## Non-Functional Requirements

<!-- NFR-0NN — metric + target + condition. Feature-specific deltas only;
     global budgets are referenced from governance, never restated.
     All six categories carry an NFR or an explicit `N/A — <reason>`:
     performance · security/privacy · availability · accessibility ·
     localization · scale. Silence fails. (CC-NF-01…03)

     The category must be LABELLED — a keyword inside the sentence does not
     count, so a category is recognised in exactly one of three forms:
         NFR-0NN (<category>) — <metric + target + condition>
         - <Category>: N/A — <reason>
         | <Category> | … |            (a table row led by the category)
     Anything else reads as silence and fails CC-NF-02. -->

## Business Rules

<!-- BR-0NN — one testable rule per line, with the formula or threshold where
     there is one. Cross-feature rules are referenced from governance.
     (CC-BR-01…03) -->

## Data Requirements

<!-- Fields table — entity · field · type · required · validation · notes.
     Entities must already exist in .specify/memory/domain-model.md.
     Where an entity has a lifecycle, add the states table: state · allowed
     transitions · trigger, with terminal states marked. (CC-DA-01…04) -->

## Integration Touchpoints

<!-- | System | Direction | What is exchanged | Constraint |
     Every external system named anywhere in this spec or the parent brief §4
     appears here, and every row is actually used. Each integration declares
     its failure expectation. If none: `N/A — no external touchpoints`.
     (CC-IN-01…03) -->

## Out of Scope

<!-- At least one exclusion; each names where it lives instead — a phase, an
     epic/feature, or "not planned". Do not restate the global out-of-scope
     artifact. Nothing excluded here may also be specified above.
     (CC-OS-01…04) -->

## References

<!-- - Roles & permissions: .specify/memory/roles-permissions.md   (roles used: …)
     - Glossary: .specify/memory/glossary.md                       (terms: …)
     - Domain model: .specify/memory/domain-model.md               (entities: …)
     - Parent epic scope brief: .specify/memory/scope/<epic>.md
     Roles declared here equal the roles used in the body — no unused
     declarations, no undeclared uses. (CC-TR-02, CC-TR-03) -->
