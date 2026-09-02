# Framework defect note — the grant authorises acts it has no way to start: the flag hides the button, and nothing said the file is the procedure

**For:** the BA-Native Spec (`ba-native-spec-for-sdd`) framework — errata campaign record.
**Reported from:** a live Presale run — project `presale-qr-code`, Presale profile under a standing autonomy grant (`AG-1 · scope full workflow · since 2026-08-28`), estate at **package 0.1.42** — nine packages behind the framework at triage time (0.1.51).
**Source report:** field defect report #5, *the autonomy grant authorises acts it has no way to start*, 2 Sep 2026, filed by the BA after one scope change cost ten typed commands under the grant switched on to prevent exactly that.
**Component:** `disable-model-invocation: true` in every `ba-*` skill's frontmatter (build plan D-P2-2) × the acts the corpus authorises without a keystroke — the route `go` (orchestrator §7.5), the named routes (§7.6 · §7.7), the AG self-election (§10.7).
**Severity:** high — under a full-workflow grant the run halts at every command boundary; the D-O32 banned render (handing the BA a command list) was the session's only observed behaviour.
**Registered:** **EC-23** in the errata campaign's grammar.
**Status:** **fixed at the methodology layer, 2 Sep 2026** — orchestrator **v0.44** (D-O103, §47): *the procedure is the skill*. The flag stays on all 39 skills; the execution mechanism is legislated at §7.5 with §10.7's start paragraph. Lane A compile pending at the time of writing; the reporting estate receives the fix by release + owner update only.

---

## 1. Summary — two gates on one act, and the second had no law

The grant opens **gate 1 — who rules at a stop** — and it works as designed: plans compose AUTO, clearings clear, waivers land, every act is stamped and ratified at `off`. **Gate 2 — who starts the work** — is a static frontmatter boolean that removes the skill from the model's tool surface entirely. No grant field reaches it; YAML evaluated at load time cannot read runtime ledger state. Result in the field: the run ruled everything and started nothing, stopping at every technique boundary for a human keystroke that carried no decision.

The report proposed dropping the flag (F1). The triage found the estate already contains a third path the report could not see: **execute the skill file as a procedure** — compiled into `/ba-run` since package 0.1.46 (*"run each row in order by reading its technique's skill file and executing it as the procedure"*), **legislated nowhere**, present in **one carrier of the several that need it**, and absent from the reporting estate, which predates it. The defect is a **legislation gap surfacing as a mechanism gap**.

## 2. Field evidence (from the source report, verified)

One BA decision on 2026-09-02 — promote three deferred blocks whose target epic stood at MVP:

| | Count |
|---|---|
| Typed slash commands, spent | 2 (`/ba-t17`, `/ba-t18`) |
| Typed slash commands still ahead at filing | 8 (6 × Tier 1 kit/ingest · `/ba-run specs` · `/ba-wbs`) |
| BA decisions actually taken | 8 — T-17 set + batch · OQ-2 ruling · the edit restatement · T-18 diff + ADV-4/5/6/7 |

**Ten keystrokes, zero decisions among them.** Every genuine ruling stayed a ruling and survives the fix untouched — T-17 step 5 and T-18 step 4 are their own prompt points and still stop.

Flag census at triage, framework HEAD `f616719` (0.1.51): **39 of 39 `ba-*` skills carry `disable-model-invocation: true`** — D-P2-2 exactly as ruled. The one flagless skill in the payload is the vendored `humanizer` guest (39 of 40 files), whose upstream bytes the D-O97 pin keeps; its fence is the switch and the guard. Observation only.

## 3. What holds, and what the triage corrects

**Holds:**
- D1 — two gates, one opened. The structural analysis is exact, and wider than filed: the same gap reaches **every route** — §7.5, `/ba-dev-ready`, `/ba-change` — not only the AG self-election.
- The severity. In the reporting estate there was no compliant behaviour available: render the route and breach D-O32, or refuse the grant's own law.
- The hazard analysis in *Why it was built this way*. A technique firing as a side effect of conversation is real, and the flag is the estate's one mechanical guarantee against it.

**Corrected against the framework at HEAD (the estate is nine packages stale):**
- The safety floor is **three acts** (D-O94), not four — `/ba-handoff` is retired; the certified-text check runs by itself at implementation take-up (gate §11.2) and was never grant-reachable.
- The four-events quote is D-O51's hold-condition list; it needs no fifth entry once the mechanism exists — the command-boundary stop was the gap, not a class.
- D3's *no third option* is **false for `/ba-run` since 0.1.46** and true in effect elsewhere: the mechanism existed as one skill's compiled clause, so a session that had not read that file had nothing to generalize from — and in the field, did not.

## 4. The ruling — D-O103, orchestrator v0.44 (§7.5 · §10.7)

**The procedure is the skill.** A compiled `ba-*` skill is two things: a **BA command at the tool surface** — the flag keeps it off the model's surface, **D-P2-2 upheld, all 39 flags stay** — and a **procedure file** the conducting session reads and executes when, and only when, an **already-stated BA act covers the run**: a route `go` (§7.5), a named route's `go` (§7.6 · §7.7), or a standing AG's self-election inside `scope:` and the D-O61 cost boundary (§10.7). The covered run executes under the skill's own compiled discipline — its P-O3 check, its stops, its record grammar — and the executor re-checks nothing and asks for no retype. **Absent a covering act: stop in ≤ 2 lines and name the one BA act that unblocks** — the report's invocation-authority test, placed at the executor instead of 39 frontmatters.

Of the report's fix set: **F2 was already law** (the §10.7 AUTO stamp — every act, no exceptions); **F3 already true** (the floor sits outside every grant and no mechanism reaches it); **F4 moot** (D-O51's four events are true as written once the mechanism exists). **F1 — dropping the flag — is parked with an event trigger**, not rejected: it reopens only where execute-by-reading fails in the field on an estate carrying this ruling. Trading a mechanical guarantee for a textual clause across ~35 files is the hazard P-O3 exists to prevent, and the runtime check the report wanted is delivered at the executor with a stronger record than a keystroke leaves.

## 5. The acceptance test (the report's own, adopted as the regression target)

1. `Auto: on`, scope covering Band 2 → one BA act carries T-17 → T-18 → Tier 1 → P-O8 → Tier 2 → `/ba-wbs`, stopping only at T-17 step 5, T-18 step 4, and the band boundary.
2. `Auto: off` → every skill refuses a non-BA invocation in ≤ 2 lines and names the unblocking act.
3. The floor's three acts refuse under both settings.
4. Replay 2026-09-02: the same decision costs **zero typed commands after the first**, and the same eight rulings.

## 6. Boundary

This note and the ruling touch the framework repo only. The reporting estate stands as filed — its remaining eight-command leg is the failing baseline — and receives the fix by release and owner update, never by patching `.claude/skills/*` in place (installer output, manifest-hashed).
