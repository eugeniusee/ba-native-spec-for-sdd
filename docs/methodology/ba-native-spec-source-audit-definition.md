# BA-Native Spec — the source audit (Scope S)

**Status:** draft for maintainer review · 2026-08-16 · document-first under the
one-way rule (BUILD-LOG S9, closure note ii): this document is the source; the
package units in §10 compile from it and never the reverse.

**Provenance.** Drafted from the Nutrivity band evaluation of 2026-08-14 — a
human-scored comparison of the generated band against the full client corpus
(77 obligations, two artifacts, findings S-01…S-23 / H-01…H-13 / B-01…B-03).
The defect classes named there are the assertion families named here. The
evaluation workbook is the calibration answer key (§9).

---

## 1. Purpose and position

The completeness gate proves a **spec is complete in itself** — one feature,
against the contract. Nothing yet proves the **band is faithful to the
client** — that every obligation the client's material carries is either
carried somewhere in the band or consciously declined on the record, and that
nothing in the band claims what no source supports.

The source audit is that proof. **Scope S — source fidelity.** It runs over
the whole band at once — every drafted spec, every brief, the roadmap, the
out-of-scope register, the WBS export — because both of its questions are
band-level questions:

- **Coverage is a union property.** An obligation absent from `003` may be
  carried by `005`. No gap may be reported against one spec until the whole
  band has been searched, and every reported gap names where it looked.
- **Duplication and divergence are cross-spec properties.** The same
  obligation carried twice with diverging acceptance is invisible to any
  per-feature run.

The audit is to the gate what pre-flight is to admission: complementary, never
a replacement. It changes no verdict, waives nothing the contract owns, and
certifies nothing. Its whole output is a **decision list** the BA rules on in
one act, and the ruled repairs.

**When it runs.** BA-invoked, after the band exists: under Presale, after the
batch drafting (`/ba-run specs all`) — before or after `/ba-wbs`, both orders
are legal since the export is derived; under Discovery, any time after two or
more features are drafted. Running it mid-band is not an error, but its
negative findings are provisional by construction and the render says so.

## 2. The obligations register

The audit's ground truth is the **obligations register** — one row per
obligation extracted from the source estate:

- **The source estate** is: every capture under `sources/` · every attachment
  or pasted source recorded on the ledger head's `Sources:` line as
  `captured` · `canvas.md`'s cited client statements. A source standing
  `named — pending` or `skipped` is listed in the report head as **unaudited
  ground** — the audit never reads what the inventory did not capture.
- **What extracts.** Every numbered section, list item, table row, worked
  example, demo scenario, acceptance-criteria table and stated constraint in a
  client document; every client-authored ask and every recorded scope decision
  in a captured channel. Tables and worked examples are obligations, not
  illustrations.
- **Row grammar:**

```
OB-<nnn> · <source-file>#<section-or-anchor> · "<quote, ≤ 2 lines, verbatim>"
  · modality: shall | should | context
  · phase claim: <prototype | MVP | later | unstated>
  · carrier: <spec NNN §/US | brief E-nn §n | roadmap row | out-of-scope entry
    | deferral row | SA-<nn>> | none
  · status: carried | partial | accepted | gap
```

- **The union rule.** Where two sources define the same list, set or scope,
  the register row carries the **union**, and names both sources. An addendum
  extends its base document; the base document never truncates the addendum.
  (Nutrivity defect class: seven conflict types kept from the base document
  while the catalogue's eighth — histamine — fell, S-05.)
- **Modality is read from the source, not assigned.** An unconditional
  statement ("German only") is `shall`. A recommendation is `should`.
  Background is `context` and is registered but never a gap.
- **A comment is not a carrier.** Only a story, an acceptance item, a brief
  line, a roadmap row, an out-of-scope entry, a deferral row or an SA record
  carries an obligation. An open question, a `[NEEDS CLARIFICATION]` marker or
  a Comments-cell mention carries nothing — that is the defect class that let
  "German only" become thirty confirm-comments and zero stories (S-01).
- **Two extraction passes, different angles.** The register is built by a
  primary walk, then a **completeness critic** pass re-walks each source
  asking only *what here maps to no register row*. The critic exists because a
  register built by one reading audits that reading's own blind spots with
  that reading's own blindness. Rows the critic adds are marked `critic`.

## 3. The two traces

**Forward — every obligation to its carrier.** For each register row, search
the whole band: every `specs/NNN-*/spec.md` (§2 stories, §3 requirements,
acceptance, §6 rules, §8 integrations), every brief, the roadmap, the
out-of-scope register, standing SA records. Statuses:

- `carried` — a carrier holds the obligation's content.
- `partial` — a carrier holds part; the finding names the missing part.
- `accepted` — an SA record covers it (§5), or an out-of-scope /
  deferral entry covers it **with a basis no source contradicts**.
- `gap` — no carrier anywhere. Reportable only with the search set named.

**Backward — every claim to its ground.** For each scope-bearing claim in the
band — a story, an integration row, a role, a phase label, a stated basis —
find its source. Statuses: `grounded` (cites or matches a source) ·
`assumption` (marked as such — legal, counted) · `ungrounded` (matches
nothing — proposed for removal or for an assumption mark) · `contradicts` (a
source states otherwise — the quote renders beside the claim).

## 4. The Scope-S assertions (CC-S)

Compiled to `.specify/ba/cards/assertions-s.md`; the `ba-gate` subagent
evaluates them exactly as it evaluates Scope H — per assertion, with evidence,
never editing. Eight families:

- **CC-S-01 — forward coverage.** Every `shall` row is `carried`, `partial`
  (finding), or `accepted`. A `should` row may also stand `gap` if the
  decision list offered it and the BA declined (→ SA).
- **CC-S-02 — backward grounding.** No `ungrounded` and no `contradicts`
  claim stands unresolved.
- **CC-S-03 — list union.** Every union row (§2) is carried at union width —
  a carrier holding the base set while the addendum's extension stands
  uncarried is this family's named gap.
- **CC-S-04 — client acceptance tables.** Every row of a client-authored
  acceptance table maps to at least one carrier. (Nutrivity: 4 of 9 failed —
  profile editing, weekly/station generation, nutrient checks, label preview.)
- **CC-S-05 — unconditional NFRs.** Language, locale and formats, currency,
  authentication, responsiveness, retention, performance envelopes stated
  without condition are carried as stories or acceptance — never as questions.
- **CC-S-06 — deferral legitimacy.** Every deferral row and out-of-scope
  entry touching a registered obligation carries a basis, and no source
  contradicts that basis. (Nutrivity: nutrient computation deferred to
  Phase 2 while the catalogue mandates prototype approximation, S-03.)
- **CC-S-07 — persona coverage.** Every user group a source names holds at
  least one carrier or one SA record.
- **CC-S-08 — cross-band consistency against sources.** Integration names,
  role names and phase labels used in the band exist in the sources or the
  band's own registries, and contradict neither. (Nutrivity: a fifth role
  outside the registry's four, S-08; KISIM as a prototype-row integration
  against two sources' exclusions, S-09.)

**M/A split.** CC-S-08's registry checks and every search-set mechanic are
machine work where a checker exists; the register build, the semantic mapping
and CC-S-01…07 are the A pass. Until a dedicated `sk_audit.py` lands (§10),
the M share runs as pinned agent procedure — collect-all, never halting.

## 5. P-A1 — source-audit ruling: the decision list and the SA record

One checkpoint. Everything the audit found arrives **once**, as one numbered
list, after the whole run — never as a drip. Pinned shape:

```
Source audit — run <n> · <date> · profile: <profile>
Sources read: <k> · unaudited ground: <named | none>
Obligations: <t> · carried <c> · partial <p> · accepted <a> · gaps <g>
Claims: <m> checked · ungrounded <u> · contradictions <x>
| # | CC-S | Evidence — source · place · "quote" | Band check — where it looked | Proposal → target | Default |
|---|------|--------------------------------------|-------------------------------|-------------------|---------|
Rulings: apply all · apply all except <#…> · <#>: SA <reason> · <#>: amend <note>
```

- **Evidence is verbatim.** File name, section, quote. A finding without its
  quote is invalid audit output, corrected before render — the gate's own
  output bar, applied here.
- **The band check renders per row.** *"searched 001–006 §2/§3/acceptance,
  briefs E-01–E-04, roadmap, out-of-scope, WBS — no carrier"*, or *"partial
  at 003 US-4 — extend there"*. A row that names no search set does not
  render.
- **Every row carries a default** — `apply` or `SA` — so `apply all` is a
  complete, safe ruling. The audit proposes; **the BA rules; the audit never
  rules.** Rows needing a choice no default can make render `amend` and ask
  exactly one question each.
- **A declined proposal becomes an SA record** — never silence:

```
SA-<nn> · OB-<nnn> · source: <file#section> · "<quote>"
  · decision: not carried this band · reason: <BA's words>
  · approver: <name> · date · revisit: <event-shaped trigger>
```

  Project-level like `HA-<nn>`, recorded in `.specify/source-audit.md`,
  re-read by every later run (a covered row is `accepted`, not re-proposed).
  An SA whose obligation a *new* source re-asserts goes back on the list.
- **Under an AG** (`/ba-auto on`): the run through the decision-list
  *assembly* may be AUTO. **P-A1 itself is the floor** — scope enters and
  leaves the band by a BA ruling in every mode. Auto stops at the rendered
  list, exactly as the gate stops at "done, awaiting ratification".

## 6. Repair execution, re-audit, escapes

On the ruling, the audit becomes a repair route (§10.6 route shape, one `go`
already given by the ruling itself — no second confirmation):

- **Spec edits** — dispatched to the `ba-analyst` subagent per target spec,
  draft-first, assumption posture: the approved proposal is a draft whose
  inferred values are marked, exactly as Tier-2 fixes are. The audit itself
  never authors a line.
- **Upstream artifact changes** (glossary, roles, out-of-scope, roadmap) — the
  routing discipline verbatim: proposed edit → the P-A1 ruling is the
  approval → write → the scoped health run fires silently.
- **Target selection.** A repair lands in the spec whose epic owns the
  obligation's module — read from the brief's slicing and the band's own
  citation pattern; `partial` rows extend their existing carrier rather than
  minting a sibling. Where no spec owns it, the proposal says so and offers
  the brief (new slicing row) instead — a Band-2 act, named as such.
- **Re-audit.** After repairs, re-run **incrementally**: rows touched by the
  diff, everything not clean last run, plus CC-S-03/CC-S-08 whole-band always.
  Render the delta — obligations closed, claims resolved, anything new — and
  append the report entry. Convergence is expected in one cycle; a second
  cycle that still finds new rows is itself a finding.
- **Escapes.** A source obligation that surfaces downstream — client review,
  gate run, implementation — which no audit run listed is filed in
  `.specify/gate-tuning.md` as an escape with class `audit escape`, naming the
  CC-S family that ought to have caught it (or "none — new class"). The
  audit's backstops shrink to zero catches the same way the gate's do.

## 7. Artifacts and paths

```
.specify/ba/runs/band-audit/run-<n>/
  obligations.md       the register, this run (regenerated, never hand-edited)
  trace.json           forward + backward trace, machine-readable
  decision-list.md     the rendered P-A1 list, as ruled
  repairs.json         the executed route + per-row outcome
.specify/source-audit.md   append-only report ledger + standing SA records
.specify/ba/cards/assertions-s.md          the Scope-S card (compiled)
.specify/ba/templates/source-audit-report-entry.md   the pinned entry shape
```

Run numbers are monotonic and band-global. The report ledger is operational
state under quickstart rule 3: never quoted into a spec.

## 8. The Presale interaction budget

The audit adds **one** BA interaction — the P-A1 ruling — and fits the
standing budget's spare (quickstart: eight, one spare by design). The repair
route and the re-audit ask nothing. A run that needs a second interaction
outside `amend` rows is a register-rule defect, not a busy project.

## 9. Calibration — the golden case

`tests/fixtures/nutrivity-audit/expected-findings.md` pins the Nutrivity
evaluation as the answer key: the findings a Scope-S run over that band must
raise, each with its CC-S family and its source quote — and three **negative
controls** that must not fire, because the cross-band search or a legitimate
deferral covers them. The calibration bar: every `must-fire` raised, zero
`must-not-fire` raised. A framework change that moves either number is a
regression until argued otherwise. New golden cases are added per engagement
type as they are human-scored; one case is calibration, not validation — the
Nutrivity priorities hold for architecture-level rules and are re-weighed
against a second scored band before depth rules (§4's family texts) are tuned
to them.

## 10. Compilation and integration units

Package units this document compiles to — each lands with its check or lands
red:

1. `payload/claude/skills/ba-audit/SKILL.md` — the skill: stages, pinned
   shapes, the three standing blocks byte-identical (register suite).
2. `payload/specify-overlay/ba/cards/assertions-s.md` — the CC-S card,
   `check-cards.py` shape.
3. `payload/specify-overlay/ba/templates/source-audit-report-entry.md` — the
   pinned entry.
4. `tests/fixtures/nutrivity-audit/expected-findings.md` — the golden case.
5. `tests/layout.expected` — rows for 1–3; `RT|absent` for
   `.specify/source-audit.md` and the run workspace.
6. Landed with the v0.24 sitting: the mirror command-table row · the
   BUILD-LOG entry · the `tests/layout.expected` rows. P-A1 needs no
   catalogue-index row — it is this document's own prompt point, exactly as
   the gate's P1–P8 are the gate's (orchestrator §10.1's boundary sentence).
7. **Pending, maintainer acts:** `check-audit.sh` — the audit's own suite, on
   the `check-gate.sh` model · `sk_audit.py` for the M share (until then §4's
   fallback governs) · the ratification sweep over this sitting's owner
   rulings · the first calibration run against §9's golden case.

## 11. What the audit never does

Never changes a gate verdict, a waiver, an override or a certification · never
edits anything before the P-A1 ruling · never authors repair content itself —
it dispatches the authoring persona and routes upstream edits · never treats a
question, marker or comment as a carrier · never reports a gap without the
band-wide search set named · never reads a source the inventory did not
capture · never re-proposes a standing SA absent new source ground · never
runs auto past P-A1.
