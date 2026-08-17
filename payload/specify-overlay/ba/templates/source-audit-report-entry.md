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
-->

## Source audit run <n> — <date>
Profile: <Presale | Discovery> · Mode: <manual | AUTO (AG-<m>) to P-A1>
Sources read: <k> — <list, by Sources-line name>
Unaudited ground: <source — state, per entry | none>
Band read set: specs <NNN…> · briefs <E-nn…> · roadmap · out-of-scope · [wbs]

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
