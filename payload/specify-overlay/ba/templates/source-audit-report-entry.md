<!--
  BA-Native Spec — source-audit report entry. Compiled from the source-audit
  definition §5–§7. Destination: .specify/source-audit.md — APPEND-ONLY, one
  block per run; standing SA records live below the entries and survive runs.

  Run numbers are monotonic and band-global, and include refused admissions
  ("Source audit run <n> — refused at Stage 0"), so the ledger is gapless.

  Finding grammar — every listed row:
      CC-S-<nn> — OB-<nnn> · <source-file>#<section> · "<quote>" ·
      band check: <search set → result> · <ruling: applied | SA-<nn> | amended>
  A finding without its quote or its search set is invalid audit output.

  The run-status field (head line 3) is forced to INCOMPLETE where the run was
  self-evaluated — no independent A pass, the BA's explicit election at the
  Stage-0 refusal — and where a required workspace file was missing
  (definition D-S1 · D-S4). The entry does not append at all over a missing
  required file: the register, the trace and the decision list always, the
  repairs file where the ruling produced at least one executable row.

  The corpus field (head line 7) states what the run actually covered. Where
  it reads `sample`, no gap in this entry was drawn from the part that fell
  outside it — a sample never grounds a negative (definition D-S3;
  orchestrator D-O81, cited never restated).

  The register and forward/backward count lines are DERIVED — counted from
  obligations.md's rows by status and from trace.json's backward rows at write
  time, carried <c> + partial <p> + accepted <a> + gaps <g> summing to <t>.
  A count this entry asserts but the workspace does not carry is invalid audit
  output (definition D-S2).
-->

## Source audit run <n> — <date>
Profile: <Presale | Discovery> · Mode: <manual | AUTO (AG-<m>) to P-A1>
Status: <complete | INCOMPLETE — <reason>>
Sources read: <k> — <list, by Sources-line name>
Unaudited ground: <source — state, per entry | none>
Band read set: specs <NNN…> · briefs <E-nn…> · roadmap · out-of-scope · [wbs]
Corpus covered: <the named corpus, walked | sample — <what was not walked>>

Register: <t> obligations (<n_critic> from the critic pass)
Forward: carried <c> · partial <p> · accepted <a> · gaps <g>
Backward: <m> claims · ungrounded <u> · contradictions <x>

Findings and rulings:
<!-- each in finding grammar; "none" if clean -->

Repairs executed:
<!-- per route row: <target> ← <proposal, condensed> → landed | unexecuted — <why>
     · spec edits via ba-analyst dispatch, draft-first · upstream via routing -->

Re-audit delta:
<!-- closed <n> · resolved <n> · newly surfaced <n> (list) · convergence:
     one cycle | second cycle — filed as finding -->

SA records this run:
<!-- SA-<nn> · OB-<nnn> · <source#section> · "<quote>" · reason: <BA's words> ·
     approver · date · revisit: <event-shaped trigger> -->

BA ruling record:
<!-- P-A1: <apply all | apply all except #… | per-row> · <name>, <date>.
     Under AUTO the assembly lines carry AG-<m>; this line never does. -->
