# Framework design-defect note — the first phase composed wide: a request bought a seat, and the only counterweight was money the framework should never have read

**For:** the BA-Native Spec (`ba-native-spec-for-sdd`) framework — errata campaign record.
**Reported from:** two field estates, read together at the AI-SDD team sync of early September 2026 (protocol on record): **(1)** the Nutrivity BA run on the current framework, Presale profile — the client's material asked for one killer feature inside a small envelope (≈ 50K stated in the client chat), the BA's own WBS answered with four screens and that feature, and the framework's first phase carried more; **(2)** project `presale-qr-code`, Presale under a standing grant — the framework moved the administration epic (subscriptions, users) to Phase 2 against the envelope while the architect's ballpark-driven MVP kept part of it, and no rule in the corpus could say which cut was right.
**Source report:** the team's verbal findings at the sync — the BA who ran Nutrivity, the BA Lead on `presale-qr-code`, the lead's instruction on scope; ruled by the BA Lead in the master conversation, 4 Sep 2026.
**Component:** elicitation principle 4's second legitimacy test (*hard-requested*) × the scope frame's budget envelope, parameters and capacity check (orchestrator §8.1 — D-O42–D-O44) × T-18's step-3 composition and step-4 advisory (catalogue-b6).
**Severity:** high — the first phase is the proposal the client sees and the estimator prices; a wide first phase over-quotes the engagement, and in the field it could not be reconciled against a human cut by any rule the corpus had.
**Registered:** **EC-24** in the errata campaign's grammar.
**Status:** **fixed at the methodology layer, 4 Sep 2026** — orchestrator **v0.45** (D-O104–D-O106, §48) · catalogue-b6 **v0.9** (D-B6-18–D-B6-20) · elicitation **v0.11** (D15) · quickstart. Lane A compile pending at the time of writing; the reporting estates receive the fix by release + owner update only.

---

## 1. Summary — two doors into the first phase, and one of them was a request

Principle 4 composed lean on paper and wide in the field. Its text admitted an epic to MVP on **either** of two tests: the goal cannot be met without it (*goal-blocking*), **or** the client hard-requested it in the docs (*hard-requested*). Clients request in breadth — that is what a brief is — so the second test admitted most of the material, legally, with a `[stated]` citation on every row. The one counterweight was the scope frame's money: a stated envelope, converted to capacity and compared against the composition in T-18's advisory. That counterweight was **advisory by ruling, number-free, and `hold — no move` by default**, so at `apply all` it moved nothing — exactly as D-B6-14 intended for an advisory. Wide in, nothing out.

The QR estate showed the mirror failure: where the envelope *did* move an epic, it moved it on money the architect had sized differently, and the two cuts — the framework's and the ballpark's — had no common ground to be reconciled on. Money is delivery ground; allocation read it as scope ground and produced a scope no one could defend.

## 2. Field evidence (from the sync, as reported)

| | Nutrivity run | `presale-qr-code` |
|---|---|---|
| Client's stated need | one killer feature; a ≈ 50K envelope in the client chat | a QR-code generator product; MVP / Phase 2 split by the architect |
| Human cut | four screens + the one feature (the BA) | part of the administration epic inside MVP (the architect, ballpark-driven) |
| Framework's first phase | wider than the BA's cut — traceable to sources, detailed, flows closed; the project's boundaries not understood | administration epic to Phase 2 on the envelope |
| What the framework could say about the difference | nothing a rule produced — the advisory named legitimate rows, and every row was legitimate under test (ii) | nothing — the ballpark is not a frame value and the envelope was |

The lead's instruction, adopted in substance: *understand the problem the product solves and give only the scope that solves it — the first phase is the leanest logically complete flow, the rest is extension; budgets and ballparks are not inputs.* The BA Lead's addition: *ballparks are not to be moved on at all.* Dates of the two runs are on the meeting record; this note carries the mechanism.

## 3. What holds, and what the triage corrects

**Holds:**
- The lean anchor (elicitation D9, principle 4) and T-18's walking-skeleton rule are the right instruments. The failure is a second admission test standing beside them, not their absence.
- D-B6-14's law — an advisory moves nothing at `apply all` — is right and stays. The fix removes the ground that made the advisory the only counterweight; it does not turn the advisory into a block.
- D-O44's own design: the capacity check was declared *a separately removable module* with *zero tentacles*. It is removed exactly as foreseen — one section, nothing else moves.
- Discovery stays coverage-complete (T-17), the roadmap always carries the whole scope, and *recorded breadth is welcome; composed breadth is debt* holds word for word.

**Corrected against the corpus at HEAD:**
- *Give it the budget so it fits* was never the mechanism: the envelope only ever reached an advisory. The field belief that the budget drove the QR allocation is half right — it drove one move; it could not drive a cut.
- The switch the sync asked for (*lean, or everything*) already exists and needs no building: `Boundary:` — the whole scope stands on the roadmap, the first phase is lean, and the boundary is what the proposal bills (D-O106).
- The Nutrivity run's other finding — specifications missing under the Presale profile — is a separate defect on a separate mechanism and is not triaged here.

## 4. The rulings — orchestrator v0.45 (D-O104–D-O106), catalogue-b6 v0.9 (D-B6-18–D-B6-20), elicitation v0.11 (D15)

**D-O104 — the first phase composes on necessity alone.** The key business need is the canvas's Problems and the Objectives they link to (`P-n → O-n`), narrowed by any statement in the material or a standing `SD-<n>` that names the engagement's one feature. The first phase is the least set of epics with which that need is met by a complete flow — the journey runs from its first step to the outcome the need names and never stops halfway. A seat is earned on one ground only: the flow cannot complete without it. Every other cited row allocates to a later phase, so nothing is dropped to compose lean. A hard request the flow does not need is recorded ground and a named candidate, never a seat.

**D-O105 — the money leaves the frame.** Frame line 2, the parameters, the head's `Budget:` · `Parameters:` · `Capacity:` lines and D-O44's two operations are retired as a whole. An estimate of any provenance — a stated budget, a ballpark, an architect's sizing, a rate card — is delivery ground, never allocation ground: recorded where discovery records constraints, cited by the audit, read by no allocation act. The scope-frame trigger narrows to the boundary and the harvested registers.

**D-O106 — the switch is the boundary, and lean is the default.** No lean/full mode: `Boundary: MVP` is the lean proposal, `MVP + Phase 2` is more, and nothing else changes between the two. Lean needs no act — with nothing chosen and nothing typed the first phase is the lean set and the proposal bills it; widening is always an explicit, logged act (owner ruling, 4 Sep 2026).

**D-B6-18…D-B6-20** — T-18's step 3 carries the law; the advisory's two tests become one seat test plus a `(request)` flag that also names every hard-requested epic the lean cut leaves out, so the cut is visible where it was made and `apply all` leaves it standing; the capacity read retires from step 2, the Depth cell, the inputs and the trigger. **D15** — principle 4 carries one test, uniform across epics, essential scope and stories: a lean phase composed of fat epics is not lean.

## 5. The acceptance test (the regression target)

1. Nutrivity replay: with the client's material as the estate, T-18's first-phase recommendation holds the one feature's flow and its dependencies only; every other epic stands on a later phase as a cited row; every hard-requested epic outside the first phase appears in the advisory tagged `(request)`; `apply all` leaves the lean cut standing.
2. The frame renders five numbered lines and no parameters; no head line carries `Budget:`, `Parameters:` or `Capacity:`; a stated budget is recorded where discovery records constraints and read by no allocation act.
3. A T-18 run over an estate whose sources state a budget produces a diff whose reasons name no envelope and no figure.
4. `Boundary: MVP` bills the lean first phase in `/ba-wbs`; `MVP + Phase 2` bills more — and nothing else changes between the two.
5. The default proved as a default: a Frame confirmed with no edits and a T-18 run with no directive and no SD compose the lean first phase and bill it — nothing chosen, nothing typed; the run's own default ruling at step 4 (`apply all`) leaves the cut standing.

## 6. Boundary

This note and the rulings touch the framework repo only. Both reporting estates stand as run — the Nutrivity estate's wide first phase and the QR estate's envelope-moved epic are the failing baselines — and receive the fix by release and owner update, never by patching an estate in place.
