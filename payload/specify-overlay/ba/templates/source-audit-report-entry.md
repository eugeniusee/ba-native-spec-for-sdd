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

  The coverage-report field (head line 8) names the three files Stage 5b rendered
  from this run's post-repair state — the reader's copy of the register
  (definition §6b, D-S6). It is a REQUIRED field and the render precedes this
  append: an entry naming a file that does not exist is the D-S4 defect one
  artifact along. Where the render did not complete, this entry does not append
  at all — the run names the file it could not write and stands INCOMPLETE.
  `/ba-audit --report` re-renders all three from the latest closed run and
  appends nothing: one run, one entry.

  The re-audit delta line is DERIVED from `trace.json`'s `re_audit` block —
  the post-repair counts beside the P-A1 ones and the rows that moved
  (definition §7, D-S9 · D-S11). A delta this entry asserts but the trace does
  not carry is invalid audit output, exactly as a count is.
-->

## Source audit run <n> — <date>
Profile: <Presale | Discovery> · Mode: <manual | AUTO (AG-<m>) to P-A1>
Status: <complete | INCOMPLETE — <reason>>
Sources read: <k> — <list, by Sources-line name>
Unaudited ground: <source — state, per entry | none>
Band read set: specs <NNN…> · briefs <E-nn…> · roadmap · out-of-scope · [wbs]
Corpus covered: <the named corpus, walked | sample — <what was not walked>>
Coverage report: exports/audit-report.xlsx · exports/audit-report.csv · exports/audit-stats.html

Register: <t> obligations (<n_critic> from the critic pass)
Forward: carried <c> · partial <p> · accepted <a> · gaps <g>
Backward: <m> claims · ungrounded <u> · contradictions <x>

Findings and rulings:
<!-- each in finding grammar; "none" if clean -->

Repairs executed:
<!-- per route row: <target> ← <proposal, condensed> → landed | unexecuted — <why>
     · spec edits via ba-analyst dispatch, draft-first · upstream via routing -->

Re-audit delta:
<!-- from trace.json's re_audit block: carried <c0> → <c1> · partial <p0> → <p1>
     · gaps <g0> → <g1> · ungrounded <u0> → <u1> · <n> rows moved · convergence:
     one cycle | second cycle — filed as finding -->

SA records this run:
<!-- SA-<nn> · OB-<nnn> · <source#section> · "<quote>" · reason: <BA's words> ·
     approver · date · revisit: <event-shaped trigger> -->

BA ruling record:
<!-- P-A1: <apply all | apply all except #… | per-row> · <name>, <date>.
     Under AUTO the assembly lines carry AG-<m>; this line never does. -->
