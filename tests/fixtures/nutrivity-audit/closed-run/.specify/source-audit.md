# Source audit — report ledger and standing SA records

Append-only. One block per run, oldest first; the standing SA records live
below the entries and survive runs.

## Source audit run 1 — 2026-08-21
Profile: Presale · Mode: manual
Status: complete
Sources read: 3 — FR.md, CAT.md, PRIV.md
Unaudited ground: none
Band read set: specs 001–018 · briefs E-01–E-06 · roadmap · out-of-scope
Corpus covered: FR.md §1–§8, CAT.md §1–§11, PRIV.md §1–§3 — walked whole

Register: 9 obligations (0 from the critic pass)
Forward: carried 7 · partial 1 · accepted 1 · gaps 0
Backward: 24 claims · ungrounded 0 · contradictions 0

## Source audit run 2 — 2026-08-23
Profile: Presale · Mode: manual
Status: complete
Sources read: 4 — FR.md, CAT.md, PRIV.md, UI-inspiration.md
Unaudited ground: pricing-appendix.xlsx — excluded — client withdrew it
Band read set: specs 001–018 · briefs E-01–E-06 · roadmap · out-of-scope · wbs
Corpus covered: sample — CAT.md §5–§8 and §10 were not walked; every other captured source walked whole
Coverage report: exports/audit-report.xlsx · exports/audit-report.csv

Register: 12 obligations (1 from the critic pass)
Forward: carried 6 · partial 2 · accepted 2 · gaps 2
Backward: 31 claims · ungrounded 1 · contradictions 1

Findings and rulings:
CC-S-01 — OB-004 · FR.md#M6 · "low-stock warning · warning for ingredients close to expiry" · band check: specs 001–018, briefs, roadmap, out-of-scope, WBS — no carrier · applied
CC-S-06 — OB-008 · CAT.md#§4 · "Calculate / approximate potassium per meal and day" · band check: specs 001–018, briefs, roadmap, out-of-scope — deferral contradicted · SA-03
CC-S-04 — OB-003, OB-009 · FR.md#M4, CAT.md#§9 · "User can view and edit anonymized demo profiles" · band check: 004 and 011 §2/acceptance — base width · amended

SA records this run:
SA-03 · OB-008 · source: CAT.md#§4 · "Calculate / approximate potassium per meal and day"
  · decision: not carried this band · reason: the client withdrew the nutrient-computation ask at the 21 Aug call
  · approver: EK · 2026-08-23 · revisit: a source re-asserts nutrient computation

BA ruling record:
P-A1: apply all except 2 · EK, 2026-08-23.

## Source audit run 4 — 2026-08-24 — refused at Stage 0
Profile: Presale · Mode: manual
Status: INCOMPLETE — refused at Stage 0: subagent dispatch forbidden by an
operator instruction; the BA took neither option, so no walk was spent.

A refused admission takes a run number so the ledger stays gapless, and it
opens no workspace. `--report` steps past it: a refusal is not a closed run.

## Source audit run 5 — 2026-08-30
Profile: Presale · Mode: manual
Status: complete
Sources read: 3 — FR.md, CAT.md, PRIV.md
Unaudited ground: none
Band read set: specs 001–018 · briefs E-01–E-06 · roadmap · out-of-scope
Corpus covered: sample — CAT.md §5–§8 were not walked; every other captured source walked whole
Coverage report: exports/audit-report.xlsx · exports/audit-report.csv · exports/audit-stats.html

Register: 5 obligations (0 from the critic pass)
Forward: carried 3 · partial 1 · accepted 0 · gaps 1
Backward: 14 claims · ungrounded 2 · contradictions 1
Re-audit delta: carried 3 → 4 · partial 1 → 0 · gaps 1 → 1 · ungrounded 2 → 1 · 3 rows moved

Findings and rulings:
CC-S-04 — OB-003 · FR.md#M4 · "User can view and edit anonymized demo profiles" · band check: 004 §2/acceptance — base width · applied
CC-S-01 — OB-014 · CAT.md#§9 · "Dietitian can annotate a meal plan before sign-off" · band check: specs 001–018, briefs, roadmap — no carrier · SA-04
CC-S-02 — specs/018 NFR-001 · "encrypted at rest" · band check: FR.md, PRIV.md — no source states it · applied

SA records this run:
SA-04 · OB-014 · source: CAT.md#§9 · "Dietitian can annotate a meal plan before sign-off"
  · decision: not carried this band · reason: the client deferred annotation to Phase 2
  · approver: EK · 2026-08-30 · revisit: the client schedules dietitian sign-off

BA ruling record:
P-A1: apply all except 2 · EK, 2026-08-30.

## Standing SA records

SA-01 · OB-006 · source: FR.md#§3.3 · "view meal status per patient"
  · decision: not carried this band · reason: nursing workflow is Phase 2 by the client's own sequencing
  · approver: EK · 2026-08-21 · revisit: the client schedules a ward rollout
SA-02 · OB-012 · source: PRIV.md#§6 · "Audit log retained for 90 days"
  · decision: not carried this band · reason: retention is an operations setting, not a prototype behaviour
  · approver: EK · 2026-08-21 · revisit: the first production deployment is scoped
SA-03 · OB-008 · source: CAT.md#§4 · "Calculate / approximate potassium per meal and day"
  · decision: not carried this band · reason: the client withdrew the nutrient-computation ask at the 21 Aug call
  · approver: EK · 2026-08-23 · revisit: a source re-asserts nutrient computation
SA-04 · OB-014 · source: CAT.md#§9 · "Dietitian can annotate a meal plan before sign-off"
  · decision: not carried this band · reason: the client deferred annotation to Phase 2
  · approver: EK · 2026-08-30 · revisit: the client schedules dietitian sign-off
