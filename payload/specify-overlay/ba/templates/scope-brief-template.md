# Scope Brief — <Epic name> (<E-nn>)
Status: Draft | Scoped
Call log: <date(s)> · <participants> · <notes/transcript link>

<!--
  BA-Native Spec — epic scope brief (artifact #12). Compiled from the elicitation
  techniques document §4. Destination: .specify/memory/scope/<epic>.md
  Born by /ba-run tier1 ingest <epic>; the kit archives beside it as <epic>.kit.md.

  Nine sections, exact headings, exact order — checkers and Tier 2 parse
  structure. CC-XA-05, CC-XA-06 ⚑, CC-H-03, CC-IN-01 and CC-OV-02 read named
  sections of this file.

  Provenance: lines sourced from the call carry no per-line tag (the call log
  covers them); lines pre-known from context keep their kit-baseline citations;
  §5 Assumptions & Risks and §6 answers always carry per-line sources.

  Pass binding: this brief is a checked dependency of every feature spec in the
  epic. Any edit — including a Tier-2 write-back to §6 statuses — voids existing
  PASSes of sibling features not yet handed off. Batch brief edits; do not drip.
-->

## 1. Value Anchor

<Why this epic exists — 1–3 lines, each resolving to canvas Problems /
Objectives by name (P-n / O-n). The chain CC-OV-02 walks is canvas → brief → spec.>

## 2. Essential Scope

<The capabilities that make the epic real — bulleted, capability level
(verb + object + one-line intent). NOT user stories; stories are Tier 2's job.
This is what story drafting and slicing consume.>

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
|---|---|---|---|---|---|

## 6. Open Questions

| ID | Question | Touches | Status | Answer / reason |
|---|---|---|---|---|

<!-- ID grammar (D12, locked — elicitation engine §4): `OQ-<n>` — OQ-1, OQ-2,
     … numbered PER BRIEF. The number is this brief's own sequence: it restarts
     in every brief and is never globally unique. Epic context rides beside the
     ID in a render, never inside it (`E01-Q1` is not an ID) — the epic is this
     brief's own and every reader already carries it.
     Status vocabulary (D4, locked): `Open` · `Answered — <date> → <where the
     answer now lives>` · `Overtaken — <reason>` (reason mandatory: an Overtaken
     line is an audit record, not a deletion).
     CC-XA-06 ⚑ reads the Open rows at spec time — each is resolved in the spec
     or carried as a waiver. Nothing silently expires. -->

## 7. Captured Detail (for Tier 2)

<Spec-depth facts volunteered during the call — grouped by topic, verbatim where
the wording matters. Tier 2 treats this section as an answered-source: it seeds
drafts and recommended answers; it is never re-asked.>

## 8. Proposed Feature Slicing

| Feature | Covers (capabilities from §2) | Rationale for the cut | Status |
|---|---|---|---|

<!-- Status: `Proposed` · `Confirmed — <date>` (D5 — the delivery-loop-entry act,
     performed at P-O8 / /ba-enter-feature). Small epic → one row, 1:1; large
     epic → 2–3 rows. CC-XA-05 and CC-H-03 read this table. -->

## 9. Routing Log

| Finding | Destination artifact | Date |
|---|---|---|

<!-- What deliberately left the brief for a governance/context home — so the
     brief is honest about what it does not contain, and nobody re-discovers a
     routed finding. -->
