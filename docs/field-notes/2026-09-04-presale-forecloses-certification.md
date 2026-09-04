# Framework defect note — the profile forecloses certification and says so nowhere: three out-of-profile artifacts sit in every gate snapshot, and a refusal that names only what is missing reads as "nothing was generated"

**For:** the BA-Native Spec (`ba-native-spec-for-sdd`) framework — errata campaign record.
**Reported from:** a live Presale run — project Nutrivity (Swiss hospital nutrition and menu-planning platform), Presale profile picked 2026-09-02, `Boundary: MVP`, a standing grant AG-1 from 2026-09-02 closed and ratified in full on 2026-09-03, estate at **package 0.1.52** — one package behind the framework at triage time (0.1.53).
**Source report:** *Field Defect Report — "Presale specs not generated"*, 2026-09-03, written by the run's own agent in read-only mode on the BA Lead's instruction after the BA reported, at the team sync, that *several key specifications were not generated* and that *`discovery-canvas.md` is missing*.
**Component:** the profile picker (orchestrator §8.1, P-O0) × §6.5's Presale destination × the gate's static core (gate §3) and Stage 0 (gate §4.1, `sk_snapshot.py --require-complete`) × the health acceptance's *admission only* (gate §10.4, D-G9) × the BA-facing register (orchestrator §10.3).
**Severity:** high in effect, low in mechanism — no data was lost and nothing ran against a rule; but the profile choice silently foreclosed every gate run for the project, the consequence surfaced on day two after 20 specs, one aspect waiver and one health acceptance, and by the time it reached the BA Lead it had become *the specs were not generated*.
**Registered:** **EC-25** in the errata campaign's grammar.
**Status:** **fixed at the methodology layer, 4 Sep 2026** — orchestrator **v0.46** (D-O107–D-O108, §49) · gate **v0.16** (D-G10) · catalogue-b1 **v0.9** (D-B1-9, the 0.1.53 pass's routed divergence D-7) · quickstart. Lane A compile pending at the time of writing; the reporting estate receives the fix by release + owner update only.

---

## 1. Summary — the premise was wrong, and the defect underneath it is real

The report's first act was to check its own premise against disk, and it fell: **20 of 20 entered features carry a `spec.md`**, all 20 structurally complete against the writing standard's ten-section skeleton with at least one story and one FR; and **no artifact named `discovery-canvas.md` exists anywhere in the framework** — the canvas is `canvas.md` at the repo root, present (13 153 bytes), produced by T-01 at Frame; the name is T-01's technique title, *Discovery canvas framing*, read as a filename.

What is absent is **five memory artifacts** — `roles-permissions.md` (T-12), `domain-model.md` (T-11), `processes.md` (T-13), `design-standards.md` (T-14), `constitution.md` (T-15) — plus `personas.md` (T-04) and `competitive-analysis.md` (T-07). Every one is the output of a technique **out of the Presale set**, exactly as the estate's own suggestion snapshots printed at each aspect (*Outside this profile — electable by code*), exactly as §6.5 predicts for AT-RQ-1, and the run recorded the prescribed waiver, AW-1, as expected profile debt (§4.5). Up to here the run was compliant and the framework did what it says.

**The defect is the coupling nobody stated.** Three of the five — `roles-permissions.md`, `domain-model.md`, `constitution.md` — are **structural members of every feature's `deps(F)`** (gate §3's static core). The compiled snapshot builds with `--require-complete`, and at Stage 0 step 3 it returned exit 1 for every one of the 20 features, before pre-flight, before any assertion:

```
snapshot: missing roles/mem — .specify/memory/roles-permissions.md
snapshot: missing dm/mem — .specify/memory/domain-model.md
snapshot: missing constitution/gov/mem — .specify/memory/constitution.md
exit=1
```

So the Presale choice, taken at P-O0 with the picker reading *draft specs optional. Waivers expected.*, foreclosed certification for the whole project — and **no rule anywhere in the package stated that consequence at the point of choice**. It surfaced on 2026-09-03, after the whole route had run.

## 2. Field evidence (from the source report, verified against its own citations)

| | Count / fact |
|---|---|
| Features entered at Band 3 | 20 (13 on 09-02, 7 on 09-03) |
| `spec.md` present · structurally complete | 20 · 20 |
| `gate-report.md` present | 0 — Stage 0 refuses every feature at step 3 |
| Memory artifacts absent | 5 (+ 2 conditional) — all out of the Presale set |
| Aspect waiver recorded for the debt | AW-1 (Requirements, 2026-09-02) — the §6.5 ruled case |
| Standing Scope-H gaps, all under HA-01 | 12 — CC-H-01 ×5 · CC-H-05 ×6 · CC-H-06 ×1; six of the CC-H-05 gaps are roles named in `stakeholders.md` and defined nowhere, because T-12 never ran |
| Spec markers restating the same absence | 41 of 134 `[NEEDS CLARIFICATION]` |
| The refusal as the BA received it | *"no feature can be gated until T-12, T-11 and T-15 have run. All three are out of profile under Presale."* — true, and silent on the twenty existing specs |
| What the BA reported at the sync | *"several key specifications were not generated"* · *"`discovery-canvas.md` is missing"* |

Two further facts the report establishes and this note takes as read: **HA-01 did not lift the refusal** — a health acceptance lifts pre-flight blocks (Stage 0 step 5), never an admission refusal (step 3); the run misread §10.4's *admission only* as covering both, and corrected itself. And **the BA's own WBS was not in the estate**, so the report's WBS comparison stands *not established*; the owner has parked it.

## 3. What holds, and what the triage corrects

**Holds:**
- The Presale profile's law: a recommendation default, never a restriction (D-O14); certification and handoff not the presale destination (§6.5, since v0.5); the four artifacts named as the profile's own arithmetic (§4.5); AW-1 the prescribed record (D-O83). Nothing here moves.
- The gate's refusal. A feature gate against an undefined role model and an undefined domain is meaningless — the static core is the static core. The refusal is correct and stays; the defect is that nothing warned.
- The report's B1 finding and its fix shape — say it at the picker — adopted as the point-of-choice half of D-O107.
- The report's B2 finding — name which Stage-0 block an HA lifts — adopted as gate D-G10.
- The agent's own judgement (report §3.5), stated as such: it drafted 20 specs after finding the artifacts absent, because the profile's destination includes draft specs and AW-1 had accepted the debt. Correct, and exactly what §6.5 asks for.

**Corrected:**
- *Specifications were not generated* — false; every one exists. *`discovery-canvas.md` is missing* — no such artifact; the canvas is present. The В-2 item on the team's board is reclassified from *spec completeness* to *the profile forecloses certification silently*.
- *Switch to Discovery to certify* — the switch alone produces nothing; the three techniques must run (elected at a P-O2 under either profile). The picker line and the refusal name both acts.
- *The HA fixes it* — no instrument lifts a missing static-core member. The gate document said *admission only* and never said which step; it now does.
- The report proposed a picker text; the ruling takes its substance in three shorter lines, and adds the second sight the report could not see from inside the run: the refusal itself must say what exists, what is missing and the act — the register rule that turns *cannot be gated* back into a sentence a person can act on.

## 4. The rulings — orchestrator v0.46 (D-O107–D-O108), gate v0.16 (D-G10), catalogue-b1 v0.9 (D-B1-9)

**D-O107 — the profile says what it forecloses.** §6.5 states the mechanism once (three static-core members out of the Presale set → admission refused for every feature until they exist, no instrument lifts it, two acts: elect the three at a P-O2, or switch to Discovery and run them); the picker's line 2 gains the consequence and the two acts; the gate's admission refusal renders in the D-O108 shape. No new stop, no new instrument, no new register, no status line — the owner's instruction is *the less bureaucracy the better*.

**D-O108 — a refusal names what exists and the act.** §10.3's twelfth rule, compiled into the framework block and all four personas: whenever a render says a feature cannot be gated, certified, handed off or admitted, the same render says what does exist, what is missing with its producing technique by code and name, and the one act that unblocks, in that order. *Cannot be gated* alone is a banned render.

**D-G10 — the two Stage-0 refusals told apart.** Admission: `spec.md` at its path and the static core complete — a missing member is a runtime condition, not a verdict; refused before the snapshot binds, no entry, no run number, no instrument lifts it. Pre-flight: the CC-H set over `deps(F)`; an H gap blocks unless `HA-<nn>` covers it. §10.4's *Admission only* now says *and admission means pre-flight*.

**D-B1-9 — the canvas mirror loses the budget envelope** (the 0.1.53 compile pass's routed divergence D-7, from EC-24): the frame no longer carries a budget line (orchestrator D-O105), and a stated budget is a business-constraint one-liner canvas §13 already holds from the material.

**Trued in the same edition — four v0.45 remnants** the 0.1.53 pass registered rather than patched: the orchestrator trailer's locked range, D-O73's stop-count line number, §7.7's locate table, D-O65's *the budget has its own line*.

## 5. The acceptance test (the report's own two tests, adopted, plus the register)

1. **Reproduce the mechanism (the diagnosis).** On the reporting estate as it stands — `Profile: Presale`, the three artifacts absent — `sk_snapshot.py build … --require-complete` for any entered feature returns exit 1 naming exactly the three artifacts. Expected to stay true after the fix: the refusal is correct.
2. **The point of choice (the repair).** On a fresh estate, `/ba-frame` renders a profile picker whose option 2 names the consequence and the two acts. Pass condition: a BA who reads only the picker can answer *can I certify a feature under this profile?* correctly, without opening `sk_snapshot.py`.
3. **The point it bites (the register).** On the reporting estate, `/ba-gate 001-nutrition-profile-record` refuses at admission with three parts in order — the spec exists with its marker count · the three missing artifacts with T-11 · T-12 · T-15 by code and name · the act (elect at a P-O2, or switch to Discovery and run them) — and HA-01 does not lift it (the report's B2 test).
4. **The HA boundary named.** `/ba-gate-health` and `/ba-gate` say which Stage-0 step an HA lifts and that a missing static-core member is not it.

## 6. Boundary

This note and the rulings touch the framework repo only. The reporting estate stands as run — its 20 draft specs, AW-1 and HA-01 are the failing baseline for tests 1 and 3 — and receives the fix by release and owner update, never by patching `.claude/skills/*` in place. The estate's `PostToolUse` hook regenerating `status-dashboard.html` (`.claude/settings.json`) is project tooling, not framework, and is noted here only because the report declared it as its one unavoidable side effect.
