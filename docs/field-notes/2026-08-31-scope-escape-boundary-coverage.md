# Framework defect note — scope escape: the election briefs the first phase while the frame quotes the boundary, and no surface says so

**For:** the BA-Native Spec (`ba-native-spec-for-sdd`) framework — errata campaign record.
**Reported from:** a live Presale run — project `presale-qr-code`, Presale profile under a standing autonomy grant (AG-1), `Boundary: MVP + Phase 2`, 28–31 Aug 2026. Source analysis: the field defect report *FRAMEWORK-DEFECT — scope coverage* (BA: EK, 31 Aug 2026). This note is the **verified triage**: every claim re-verified first-hand against `origin/main` (HEAD `8867df7`, package 0.1.46, orchestrator v0.41), five corrections added, and the fix recorded.
**Component:** `docs/methodology/ba-native-spec-orchestrator-rules.md` §6.5 · §10.7 — the pinned Presale Tier-1 self-election clause (D-O61) — compiled into **six carriers** (`payload/claude/skills/ba-auto/SKILL.md` · `payload/claude/skills/ba-tier1/SKILL.md` · `payload/claude/agents/ba-orchestrator.md` · `payload/mirror/claude-block.md` · `payload/mirror/AGENTS.md` · `docs/quickstart.md`); and the **absence** of any roadmap-coverage assertion across the completeness contract, the gate runtime and every render surface.
**Severity:** high — client-facing. ~160 eng-h ≈ 20% of the quoted engagement absent from the client-facing WBS; silent for three days across a `/ba-wbs` run reporting `Included 41 · excluded none`.
**Registered:** **EC-22** in the errata campaign's grammar.
**Status:** **fixed at the methodology layer, 31 Aug 2026** — orchestrator **v0.42** (D-O99–D-O101, §45) · completeness contract **v0.5** (CC-H-08) · gate **v0.14** (§10.1 · §10.2 · §10.4) · quickstart. Lane A compile pending at the next package; the fix reaches project estates **by release only**.

---

## 1. Summary — two independent defects, one silence

Under Presale with a standing grant, the run reached Band-2 exit with a confirmed scope frame quoting **two phases** (`Boundary: MVP + Phase 2`) and a roadmap of **14 epics**, 12 allocated to MVP and 2 to Phase 2. The pinned Tier-1 self-election clause read *"every epic allocated to the **first phase**"* — so the run briefed 12, entered 12, specced 12, and the two Phase-2 epics — **E-10 Public API & Bulk Generation** and **E-11 Premium Redirect Features**, both inside the delivery boundary, both named cost-breakdown line items in the client's RFQ §8 (items 9–10) — were **never briefed, never entered, never specced**. The client-facing WBS rendered 41 rows and reported `Included 41 · excluded none`, which was true of the folders it read and false of the engagement.

- **D1 — the election defect.** The self-election iterated the *first phase*, not the *delivery boundary* — while the boundary is the framework's own answer to "what is in this engagement": the Billable column derives from it, `Capacity:` is measured against it. Two rules, one question, no reconciliation.
- **D2 — the detection absence.** No assertion anywhere compared the roadmap's in-boundary rows to the brief set. A repo-wide sweep confirmed **zero** coverage checks of this class.

The silence is the compounding part: each downstream surface held its own completeness contract on a dimension that could not see an epic with no folder — and each was **correct on its own terms**.

## 2. Field evidence (from the source report, verified)

| Fact | Value |
|---|---|
| Roadmap epics | 14 (E-01…E-14); E-10, E-11 allocated Phase 2 |
| Scope frame | `Boundary: MVP + Phase 2` — both phases in-boundary; `Capacity: ~840 eng-h` |
| Briefs written (2026-08-28, AUTO under AG-1) | 12 — E-10 and E-11 skipped by the election |
| Ledger trace | `.specify/aspect-state.md:333` — the Tier-1 ingest allocation entry lists 12 epics |
| `/ba-wbs` run (2026-08-31) | 41 rows · summary `Included 41 · excluded none` · dashboard line 2 `briefs 12/14 epics` |
| Missing effort | ~160 eng-h ≈ 20% of quoted engagement |
| Client ground | RFQ §8 cost breakdown items 9–10 name both epics; RFQ §6 names API documentation (AS-7); RFQ §3.11 carries **no phasing language** excluding them |
| Undetected | 3 days, across a batch run, a health-armed estate and a client-facing export |

## 3. Verified triage — five corrections to the source report, on the record

1. **Stale citation.** The report cites the clause at orchestrator v0.38; at HEAD the document stands at **v0.41** and the clause is unchanged — the defect is real, the version reference was stale.
2. **Wrong assertion site.** The report proposes the coverage check "at Band-1 closure (P-O7)". Roadmap and briefs are **Band-2 ground** — at P-O7 the check is vacuous by construction. The correct first sight already existed in the cadence: the contract's **post-ingestion batch-end full Scope-H run**. The fix lands there (and at every render), not at P-O7.
3. **Counted, never named.** The dashboard was not silent — line 2 read `briefs 12/14 epics`. A count without names is indistinguishable from ordinary later-phase deferral: the D-O58 blind-spot case, met at a **join** rather than at a grammar. The fix names the epics, their phases and their Billable values.
4. **CC-H-03 is subset-blind by construction, not broken.** It asserts that an epic *entering Band 3* has a brief with a confirmed slicing — a different question at a different moment (P-O8's precondition). It stands untouched; the new row (CC-H-08) owns the coverage question.
5. **Six carriers, not four — and the field patch is evidence, never the fix.** The report's carrier sweep missed `payload/claude/agents/ba-orchestrator.md` (which carries a drifted variant, *"every epic **in** the first phase"* — closed in the same compile) and `docs/quickstart.md`. The report's `sk_wbs.py` detector edit is a **payload edit that breaks the manifest hash**: it stands as evidence and as the reference shape for the Lane A test fixture, and it must be **reverted on the field estate at the next release install** — fixes reach estates by release only.

## 4. Resolution — what landed where

- **D-O99 (orchestrator §6.5 · §10.7).** The election takes the boundary: Tier-1 self-election at Band-2 exit iterates **every epic allocated to a phase inside the scope frame's `Boundary:` set** — the rows the Billable column reads `Yes` for (D-O67's own test). One definition, two consumers: the election and the coverage check read the same set. Under `Boundary: MVP` the effect is **byte-identical** — the regression this note demands holds by construction. No AG expansion; D-O61's row byte-untouched, amended on the record.
- **CC-H-08 (contract v0.5 §6) + runtime (gate v0.14 §10.2 · §10.4).** Every in-boundary roadmap epic has a scope brief; an epic without one is a named gap (`CC-H-08 FAIL — E-10 Public API & Bulk Generation — Phase 2 · Billable Yes — no scope brief`). **M**-class; vacuous where no roadmap or no boundary stands; counts in `n gaps` and **blocks nothing** — the join sits in no feature's `deps(F)`; `HA-<nn>` available for a client-agreed deferral. Run points: full runs (the post-ingestion batch-end run meets the election) and scoped runs on `roadmap.md` and brief-folder edits; never pre-flight. Assertion count 62 → 63.
- **D-O100 (orchestrator §10.4 · §10.5 · §10.7 · §8.4).** One computation, **four display sites**: the dashboard's line-2 continuation `unbriefed inside boundary <n>: …` · the band-boundary report's sixth line `Scope coverage: …` · `/ba-run specs`' confirmation table, opening with the same line · the `/ba-wbs` generation summary's roadmap dimension — every in-boundary epic with zero rows, first missing link named (`no brief` · `brief — no confirmed slicing` · `no spec folder` · `spec — no stories`) and one closing sentence: the WBS understates the quoted scope until they are briefed and specced. Counts render, the BA judges — **no threshold, no block anywhere**.
- **D-O101 (orchestrator §10.7).** The closing ask's third conditional join: where the coverage line renders uncovered epics, one option — `brief the uncovered in-boundary epics first; Tier 1 in ingest mode is inside the grant` — joins before *c*. Recommended stays on continue.
- **Gate §10.1** — the stale *six CC-H* count words go count-free on the record (*every CC-H assertion* / *the CC-H set*): exact at v0.6, silently wrong since v0.11, never stale again.
- **Quickstart** — the Presale paragraph now states the boundary and names the sights.

**Had this stood on 28 Aug:** the election briefs 14; and had anything still gone wrong, the batch-end health run reports `1 gap`-per-epic by name, the dashboard names E-10 and E-11 under line 2, the P-O8 boundary report's `Scope coverage: 12/14 | uncovered inside boundary: E-10 · E-11` renders with a one-letter fix option, and the WBS summary refuses to say `excluded none` over an understated roadmap.

## 5. Regression to hold (Lane A)

- Killed string *"every epic allocated to the first phase"*: **exactly 2** occurrences in the orchestrator document, both historical and byte-deliberate (D-O61's register row, untouched, and the v0.42 change record's origin quotation) · **0** in all six carriers · **0** in the quickstart. The `ba-orchestrator` drift variant (*"every epic in the first phase"*): **0** everywhere.
- Required boundary clause: exactly 1 per carrier.
- Fixture A — `Boundary: MVP + Phase 2`, 14 epics, two Phase-2 rows unbriefed: the four sites name E-10 and E-11; the health run counts 2 gaps and blocks nothing.
- Fixture B — `Boundary: MVP`, same estate shape: election output **byte-identical** to the pre-fix election.
- The field estate's local `sk_wbs.py` patch: reverted / superseded at next release install.
