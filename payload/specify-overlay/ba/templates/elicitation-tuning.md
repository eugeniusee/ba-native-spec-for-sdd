# Elicitation Tuning — <project>

<!--
  BA-Native Spec — the question-quality ledger. Compiled from the elicitation
  techniques document §10 (three logs). Destination:
  .specify/elicitation-tuning.md — D-P2-11: one runtime ledger, three tables,
  outside .specify/memory/, same D-G1 rationale as gate-tuning.md.

  Doc 3 §10 defines the three logs without pinning a file; this is their home.
  The gate's own tuning ledger (.specify/gate-tuning.md) stays separate —
  different technique, different tuning target.

  Born at the first log entry. Append-only.

  What this feeds: accepted patterns bump the elicitation techniques document's
  version, which then recompiles `ba-tier1` / `ba-tier2` and any technique skill
  anchored to the bumped sections (build plan §3.5, the one-way rule). Iterate
  technique and prompts, not tooling.

  Manual mode should start these logs NOW, on paper, from the first real use —
  they feed Phase 3's metrics directly (build plan §6).
-->

## False-ask log

<!-- Entry condition: a question was asked whose answer a source already stated —
     falsified by the BA producing the source line (Guard 1 / the Citation Test
     violation). Tunes: answered-source loading, citation retrieval.

     The test is falsifiable from the outside, which is what makes it a test.
     Every falsification belongs here. -->

| # | Date | Tier | Epic / Feature | Question asked | Source line that already answered it | Answered-source set it should have come from |
|---|---|---|---|---|---|---|

## Wrong-draft log

<!-- Entry condition: a confidently CITED or UNMARKED drafted value is later
     corrected — the residual risk the legality rule cannot catch (there is no
     question to rule on). Tunes: cite-or-mark honesty, the inference-marking
     threshold.

     The cite-or-mark corollary: a value the framework can infer but no source
     states must be drafted AND marked
     `[NEEDS CLARIFICATION: confirm <value> — basis: <inference>]`.
     An entry here means that corollary was not honoured. -->

| # | Date | Tier | Epic / Feature | Drafted value | Cited source (or "unmarked inference") | Correct value | Why the draft was wrong |
|---|---|---|---|---|---|---|---|

## Dead-answer log

<!-- Entry condition: an asked question's answer changed nothing in any
     destination artifact. Tunes: Guard 2 calibration, destination tagging,
     over-asking.

     Guard 2 at Tier 1 is the Destination Test; at Tier 2 it is the legality
     rule. A dead answer means the destination tag was nominal, not real. -->

| # | Date | Tier | Epic / Feature | Question | Declared destination | What actually changed | Guard-2 reading |
|---|---|---|---|---|---|---|---|

## Accepted patterns

<!-- Patterns promoted out of the three logs into a document-bump proposal.
     Doc-first by construction: nothing here is patched into a compiled skill. -->

| # | Date | Pattern | Log(s) | Proposed doc change | Status |
|---|---|---|---|---|---|

<!-- Status: `candidate` · `accepted — bumps elicitation vX.Y` · `declined — <reason>` -->
