# Aspect Plans — <project>

<!--
  BA-Native Spec — the planning record. Compiled from the orchestrator rules
  §6.4, incl. the Frame section (D-B1-4) and the Band-2 section
  (D-B6-5). Destination: .specify/aspect-plans.md — outside .specify/memory/
  under the same D-G1/D-G8 rule as the state ledger.

  Born empty by /ba-frame. Per aspect: the suggestion snapshot (framework,
  advisory — kept verbatim as audit trail and tuning input), the composed plan
  (the BA's document — select · drop · reorder · add custom), and the run log.

  Re-composition is legal at any time while an aspect is `open` or `reopened` —
  appended and dated; the plan never rewrites its own history.

  Output contracts are pinned BEFORE any run (Q2+): {expected output · artifact
  class · destination file}. Catalogue techniques come pre-pinned by their
  sheets; custom techniques take a BA-supplied or BA-confirmed contract. An
  unconfirmed contract makes the run illegal.

  Edit discipline (field defect 2026-08-20, B8): section headings and head
  lines are edited line-anchored — full-line match at line start — never by
  substring search. This comment deliberately names sections without their
  literal heading strings.
-->

<!-- Section shape, repeated for each heading below:

Suggestion — <Aspect> — <date>          (orchestrator §6.1 block — kept verbatim)
| # | Technique (catalogue \| custom sketch) | Addresses | Expected contribution |
|---|---|---|---|
| 1 | <name> | AT-<..> — <the named hole> | <what evidence the run should produce> |
Sequence rationale: <one line>

Composed plan — <date> · <initials>
| # | Code — technique | Source | Output contract {expected · class · destination} | Status |
|---|---|---|---|---|
| 1 | <code — name · custom — name> | catalogue \| custom | {…} | planned · run <date> · dropped — <reason> |

Run log:
<date> · <technique> · contract: fulfilled | partial — <what is missing> | failed — <why>
  signals: <RO-/routing-/overflow entries logged with source = this run | none>
-->

## Frame

<!-- T-01's plan line and run log (D-B1-4) — the one catalogue technique invoked
     outside an aspect plan, at the Band-1 entry act. -->

## Stakeholders

## Context

## Value

## Vision

## Solution

## Requirements

## Band 2

<!-- T-17's and T-18's plan lines and run logs (D-B6-5), same row shape —
     composed at `/ba-aspect band2` (P-O2 — plan composition, §8.3): the
     section takes its plan exactly as an aspect takes one. Every
     rerun names its trigger; contract-fulfillment bookkeeping per §7.3.
     Allocation is on-demand and repeatable (C1): each rerun = recommended
     re-allocation with rationale + diff vs. current + BA approval; the living
     roadmap logs the change with reason.

     Tier-1 runs are per epic, so their run lines name their epic — one line
     per mode per epic:
       <date> · TIER-1 kit E-nn · contract: …
       <date> · TIER-1 ingest E-nn · contract: … -->

## Band 3

<!-- Tier-2 run lines, one per feature:
       <date> · TIER-2 NNN-feature · contract: …

     §7.3 owes a contract-fulfillment line for every run; §6.4 enumerates
     section homes for the aspects, Frame and Band 2, and names none
     for a Band-3 run. This section is the PACKAGE's placement of a line the
     methodology mandates but does not house — recorded as a build divergence,
     awaiting a one-line §6.4 re-ruling. Nothing else about Band 3 is recorded
     here: the band event stays in the state ledger (§8.4), the spec at its
     destination, the verdict in the gate report. -->
