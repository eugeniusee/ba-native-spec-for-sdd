# Gate Tuning — <project>

<!--
  BA-Native Spec — the gate tuning ledger. Compiled from the gate definition
  §7.4 (two tables) and §12 (the escape record); D-G8. Destination:
  .specify/gate-tuning.md — outside .specify/memory/ under the same
  runtime-ledger rule as gate-health.md.

  Born at the first override or escape record. Append-only.

  What this feeds: the completeness contract §10 consumes this file for version
  bumps. Overrides aggregate into false-positive patterns (checker tuning);
  escapes are contract-gap candidates. The one-way rule holds — a wanted runtime
  change without a doc change is a doc defect first: findings bump the document,
  then the affected build units recompile.

  Elicitation's three logs (false-ask · wrong-draft · dead-answer) live
  separately in .specify/elicitation-tuning.md — different technique, different
  tuning target.
-->

## Overrides

<!-- Aggregated by assertion — the false-positive patterns. An assertion
     producing chronic false positives, or ritual compliance, is a logged
     pattern that bumps the contract (contract §10, demotion path). -->

| Assertion | Feature | Override | Element | Why the verdict was wrong | Approver · date |
|---|---|---|---|---|---|

<!-- e.g. CC-AC-04 | 004 | O-004-01 | US2 / scenario "…" | adds the boundary
     datum BR-002 leaves implicit | Y.K. · 2026-07-17 -->

### Aggregation

| Assertion | Override count | Pattern | Disposition |
|---|---|---|---|

<!-- Disposition: `checker tuning — <what to change>` · `contract-gap candidate
     (contract §10)` · `demotion candidate` · `watch — n too low` -->

## Escapes

<!-- A requirements defect that escaped this gate and was caught downstream.
     The backstop's job is to shrink to zero catches — every catch it makes is
     our defect, not its success. -->

| Escape | Caught by | Defect | Should-have | Disposition |
|---|---|---|---|---|

<!-- Escape record, long form (gate §12):

E-<NNN>-<nn> · caught by: /speckit-analyze | /speckit-checklist | plan confusion |
              tasks ambiguity | implementation defect | BA verification
  defect:      <what the spec got wrong or left open>
  should-have: CC-<ID> that ought to have caught it | none — new class
  disposition: contract-gap candidate (contract §10) | checker tuning —
               an assertion that existed but was misjudged is a checker defect,
               not a contract gap
-->
