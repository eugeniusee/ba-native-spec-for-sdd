# BA-Native Spec — the source audit (Scope S)

**Status:** ruled · 21 August 2026 — v0.2 (v0.1 drafted 2026-08-16) ·
document-first under the one-way rule (BUILD-LOG S9, closure note ii): this
document is the source; the package units in §10 compile from it and never the
reverse.

**v0.2 change record:** five rulings — audit integrity, ruled 21 Aug 2026
(**D-S1…D-S5**, amendment record §12; base commit `3f0f59d`, package 0.1.33;
origin: the **field defect report of 2026-08-20**, Part A evidence A1–A5 and
A7 — a `/ba-audit` run 1 over a live band rendered a header claiming **118
obligations over a register of 30**, never ran its backward trace or its
critic pass, **self-authored the CC-S verdicts** where operator policy forbade
subagent dispatch, and **never wrote `decision-list.md`** — and v0.1's own text
made every one of those failures either invisible or inevitable; BA ruling
**"apply all recommendations"**, 21 Aug 2026): **the undispatchable state** —
policy unavailability named as the third state of the Stage-2 dispatch beside
mechanical death, a Stage-0 refusal with its named unblocking act by default
and an **explicitly BA-electable self-evaluated mode** whose every verdict is
stamped and whose run status is forced `INCOMPLETE`; silence is not a legal
path and substituting the orchestrating session for the evaluator absent that
election is a defined violation (**D-S1**, §4 · §11) · **counts are derived,
never asserted** — the five P-A1 header numbers counted from `obligations.md`'s
rows by status at render time, a head disagreeing with the on-disk rows
**invalid audit output** on the bar §5 already sets for a finding without its
quote (**D-S2**, §5) · **per-source coverage accounting and the corpus
declaration** — one register-head line per captured source (sections walked /
sections total · rows produced, a zero-row source stating why), and the
corpus-declaration rule (**D-O81** — orchestrator §8.1, framework law, cited
and never restated) applied at this document's own two retrievals: the Stage-1
walk and the band-wide search set each **name the corpus they must cover**, the
run **states the corpus it covered**, and **a sample never grounds a `gap`**
(**D-S3**, §2 · §3 · §5 — closing the item BUILD-LOG §34 routed as *the same
defect one level up*) · **the workspace holds what it claims** —
`decision-list.md` an explicit Stage-3 write act rather than a side effect, and
the Stage-5 entry **refusing to append** over a workspace missing a required
file (**D-S4**, §5 · §6 · §7) · **finding grain and list-row grain** —
CC-S-04's per-row finding grain untouched and carrying through to the list
across **distinct** dispositions; where a disposition is **shared**, one
enumerated `amend` row governs and its enumeration count must equal the
unmapped-row count it absorbs (**D-S5**, §5). **No new assertion, no new CC-S
family, no new instrument, no new record class, no new prompt point and no new
status value** — P-A1 stays the one checkpoint and §8's interaction budget is
arithmetically untouched. **The CC-S card is not recompiled:** D-S5 fixes a
boundary between two grains and edits neither, so `assertions-s.md` stands
byte-unchanged. **Amended on the record, never rewritten:** §2's two-pass
paragraph, §3's forward-trace search set, §5's pinned P-A1 head and its
amend-enumeration bullet, §6's re-audit paragraph, §7's workspace listing.

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
- **The readability rule (run-1 escape, 17 Aug 2026).** A capture in a
  binary container (docx · xlsx · pdf) is audit ground only through a sibling
  mechanical plain-text rendering — `sources/<name>.extracted.md`, verbatim,
  extraction never interpretation. Stage 0 produces a missing rendering as
  **capture completion** — the audit's one permitted pre-ruling write; every
  pass reads renderings, the original stays the capture of record. Without
  this a `Sources:` line can read `captured` while the assertion pass is
  structurally blind to the file.
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
  Background is `context` and is registered but never a gap. **No document
  holds `context` standing as a whole, a priori** — modality is read per
  statement, and a survey or analysis document can carry obligations (run-1:
  `FORM:411` grounded the band's orthography convention after the evaluation
  had filed the whole document as context).
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
- **The walk declares its corpus, and the register accounts for it per source
  (D-S3).** The corpus-declaration rule is framework law and is **cited here,
  never restated** — orchestrator §8.1, **D-O81**. This is its application at
  the audit, the site BUILD-LOG §34 routed as *the same defect one level up*:
  **the Stage-1 walk names the corpus it must cover** — every captured source,
  and within each source every section — **and the register states the corpus
  it covered.** The register head carries one line per captured source:

```
<source-file> · <sections walked>/<sections total> · <n> rows
  [· zero rows — <why>]
```

  A source producing no rows **states why** — nothing extractable, or a
  section set the pass could not read. Without this line a thirty-row keyword
  probe and a full two-pass walk are the same object on disk, and **a skipped
  collect-all or a skipped critic pass leaves no trace at all** (the field defect of
  2026-08-20: run 1's register was a probe, its critic never ran, and nothing
  on disk said either). A run whose covered corpus falls short of the named one
  is a **sample**, and §3 governs what a sample may conclude.

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

**The search set declares its corpus (D-S3).** *Band-wide* is not a manner of
searching; it is a **corpus**, and the rule that mandates the search names it:
every `specs/NNN-*/spec.md` in the band · every brief under
`.specify/memory/scope/` · the roadmap · the out-of-scope register · every
deferral row · every standing `SA-<nn>` · `exports/wbs.csv` where it exists.
The run **states the corpus it covered**, on the P-A1 head and in the report
entry. **A `gap` is a negative, and a sample never grounds a negative**
(D-O81, orchestrator §8.1 — cited, not restated): where the covered corpus
falls short of the named one, the run says so on its corpus line and **no
`gap` renders out of the part it did not cover**. The row carries its basis
into the next run instead — an unsearched obligation is unfinished work, never
a finding.

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

**The evaluator, and the three states of its dispatch (D-S1).** The A pass is
the `ba-gate` subagent's, and the separation is the point: a session that
authored the register is the last reader who can independently judge it. The
dispatch has **three** states, not two.

1. **Alive.** The subagent evaluates and returns verdicts with evidence. The
   orchestrating session writes them down and edits none of them.
2. **Dead — mechanical.** An API failure, a tool failure, a timeout. The
   dispatch is **re-dispatched** against the same inputs; Stage-1's outputs on
   disk are the resume point and are never rebuilt for a dead dispatch.
3. **UNDISPATCHABLE — policy.** An operator instruction, a permission mode or
   a harness that **forbids agent calls at all**. This is not mechanical death
   and re-dispatch is not its remedy: retrying a forbidden act produces the
   same refusal, and the session that improvises around it becomes the
   evaluator it was forbidden to be (the field defect of 2026-08-20 — run 1
   self-authored every CC-S verdict, and nothing in v0.1 named the state or
   forbade the substitution).

**The default path is refusal.** Dispatch admissibility is an **admission
test**: where the restriction is knowable at Stage 0, the run refuses there
and **names the unblocking act** — *the BA lifts the restriction, or the run
does not proceed to Stage 2*. Where the restriction surfaces only when the
dispatch is attempted, **Stage 2 halts back to that same refusal**; one
refusal text, two entry points.

**The self-evaluated mode is electable, and only by the BA.** At the refusal —
and nowhere else — the BA may elect that the orchestrating session evaluate
CC-S itself. Under that election, and only under it:

- **every verdict is stamped** `self-evaluated — no independent A pass`, in
  `trace.json`'s `a_pass` block and on every render that carries it;
- **the run's recorded status is forced to `INCOMPLETE`** (§7), in every mode,
  and no later act in the run clears it — repairs execute, the entry appends,
  and the status stands;
- the election itself is recorded on the run entry, in the BA's own words.

**Silence is not a legal path.** A run that meets the undispatchable state and
neither refuses nor carries an election has committed a **defined violation**
of this section, whatever its verdicts say, and its entry is void. The
election is a **ruling, not an argument**: it is taken at the refusal's closing
ask (orchestrator §10.3 rule 9), where the restriction is already known —
never typed at invocation, where it is not.

## 5. P-A1 — source-audit ruling: the decision list and the SA record

One checkpoint. Everything the audit found arrives **once**, as one numbered
list, after the whole run — never as a drip. Pinned shape:

```
Source audit — run <n> · <date> · profile: <profile>
Sources read: <k> · unaudited ground: <named | none>
Corpus covered: <the named corpus, walked | sample — <what was not walked>>
Obligations: <t> · carried <c> · partial <p> · accepted <a> · gaps <g>
Claims: <m> checked · ungrounded <u> · contradictions <x>
Status: INCOMPLETE — self-evaluated, no independent A pass
| # | CC-S | Evidence — source · place · "quote" | Band check — where it looked | Proposal → target | Default |
|---|------|--------------------------------------|-------------------------------|-------------------|---------|
Rulings: apply all · apply all except <#…> · <#>: SA <reason> · <#>: amend <note>
```

The `Status:` line is **conditional** — it renders only under the self-evaluated
election (§4, D-S1) and is absent from every other run's head. `Corpus covered:`
is unconditional: a run states what it covered, or states that it covered a
sample and what fell outside it (D-S3, §3).

- **Evidence is verbatim.** File name, section, quote. A finding without its
  quote is invalid audit output, corrected before render — the gate's own
  output bar, applied here.
- **The counts are derived, never asserted (D-S2).** The five header numbers —
  `Obligations: <t> · carried <c> · partial <p> · accepted <a> · gaps <g>` —
  are **counted from `obligations.md`'s rows by status at render time**, and
  from nothing else. `<t>` is the register's row count; `<c>`, `<p>`, `<a>`
  and `<g>` are the rows standing at each status, and **`c + p + a + g = t`**.
  `Sources read: <k>` counts the per-source lines of §2's coverage block; the
  `Claims:` line counts `trace.json`'s backward rows the same way. **A header
  whose numbers do not equal the on-disk row counts is invalid audit output** —
  the bar the bullet above sets for a finding without its quote, applied to the
  head — and is corrected before render, never rendered and explained. A
  plausible number is not a derived one: **a figure a prior run rendered, a
  fixture carries or the session remembers is evidence of nothing** (the field
  defect of 2026-08-20 — run 1's head claimed 118 obligations over a register
  of 30, and 118 is the number the calibration fixture of §9 carries).
- **The band check renders per row.** *"searched 001–006 §2/§3/acceptance,
  briefs E-01–E-04, roadmap, out-of-scope, WBS — no carrier"*, or *"partial
  at 003 US-4 — extend there"*. A row that names no search set does not
  render.
- **Every row carries a default** — `apply` or `SA` — so `apply all` is a
  complete, safe ruling. The audit proposes; **the BA rules; the audit never
  rules.** Rows needing a choice no default can make render `amend` and ask
  exactly one question each — **and enumerate every item they cover by
  name**: a ruling taken over unnamed members is an invalid render (run-1:
  an amend naming three of five dropped categories cost a mandatory scenario
  its carrier until the BA flipped it).
- **Finding grain and list-row grain — the precedence (D-S5).** CC-S-04's
  *each unmapped row is its own finding* (§4) and the amend-enumeration rule
  above govern **different objects**, and the boundary is stated here so no
  reader has to guess which yields. **The finding grain is CC-S-04's, and this
  ruling does not touch it:** at the A pass every unmapped row of a
  client-authored acceptance table is its own finding, quoting the row.
  **The list-row grain is this section's.** Where the unmapped rows carry
  **distinct dispositions**, CC-S-04's grain carries through — each renders
  its own numbered row, because a ruling is taken per disposition and two
  dispositions cannot ride one answer. Where several unmapped rows share **one**
  disposition, **one enumerated `amend` row governs them**, naming every row it
  absorbs; and **the enumeration count must equal the unmapped-row count it
  absorbs**. That equality is the whole force of the rule: an amend covering
  five findings and naming three fails by **arithmetic**, not by a reader's
  attention — which is exactly how run-1's three-of-five render survived to the
  BA. The A pass's finding count and the list's absorbed count are reconciled
  before render; a mismatch is an invalid render, corrected there.
- **The list is written, not merely rendered (D-S4).** `decision-list.md` is a
  **Stage-3 act**: the rendered list is written to the run workspace before the
  ruling is asked for, and the ruling is written back into the same file when it
  is given — *as rendered and as ruled*. It is never a by-product of some later
  stage happening to save its state, and **a clean run writes it too**, with its
  `Rulings:` line and zero rows: *nothing found* is a result, and a result the
  workspace does not hold is a result no later run and no reader can check
  (the field defect of 2026-08-20 — run 1 rendered a list into the conversation
  and left the workspace without one).
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
- **The entry refuses an incomplete workspace (D-S4).** Before appending,
  the run checks the workspace against §7's required set. **Where a required
  file is missing the entry does not append** — the run **names the missing
  file** and stands `INCOMPLETE`. An append is a claim on the append-only
  ledger that the run behind it happened; an entry that outruns its own
  workspace makes that claim false for every later reader, and the ledger is
  the one surface no later run can correct.
- **Escapes.** A source obligation that surfaces downstream — client review,
  gate run, implementation — which no audit run listed is filed in
  `.specify/gate-tuning.md` as an escape with class `audit escape`, naming the
  CC-S family that ought to have caught it (or "none — new class"). The
  audit's backstops shrink to zero catches the same way the gate's do.

## 7. Artifacts and paths

```
.specify/ba/runs/band-audit/run-<n>/
  obligations.md       the register, this run (regenerated, never hand-edited)
                       — REQUIRED, head-first: §2's per-source coverage block
  trace.json           forward + backward trace, machine-readable — REQUIRED
  decision-list.md     the rendered P-A1 list, as rendered and as ruled
                       — REQUIRED, including on a clean run (zero rows)
  repairs.json         the executed route + per-row outcome — REQUIRED where
                       the ruling produced at least one executable row
.specify/source-audit.md   append-only report ledger + standing SA records
.specify/ba/cards/assertions-s.md          the Scope-S card (compiled)
.specify/ba/templates/source-audit-report-entry.md   the pinned entry shape
```

Run numbers are monotonic and band-global. The report ledger is operational
state under quickstart rule 3: never quoted into a spec.

**The required set is the append condition (D-S4).** The four files are the
run's own evidence, and §6's re-audit step checks them before the entry
appends. `repairs.json` is conditional because an empty route file records
nothing and *absent* and *stubbed* are the same hole; the other three are
unconditional because each of them records a **result**, and a run with no
findings has results too. **The run's recorded status** — `complete`, or
`INCOMPLETE` with its reason — is a pinned field of the entry (§5's `Status:`
line and the entry template's own), never prose: a status stated only in
sentences is a status the next run can forget to write.

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
   the `check-gate.sh` model, and **D-S2/D-S3 now fix what its first
   assertions check**: the header-count derivation (`c + p + a + g = t`
   against `obligations.md`), the per-source coverage block, the two corpus
   declarations, and the required-set append condition · `sk_audit.py` for the
   M share (until then §4's fallback governs) · the ratification sweep over this sitting's owner
   rulings · **the upstream fix of the run-1 escape**: capture-time renderings
   belong at `/ba-frame` (orchestrator §8.1 capture mechanics) so every
   consumer — Tier-2 source mining included — reads the same ground; until
   that lands, Stage 0's capture completion covers audit runs only.

## 11. What the audit never does

Never changes a gate verdict, a waiver, an override or a certification · never
edits anything before the P-A1 ruling — except a missing source rendering at
Stage 0 (§2's readability rule) · never authors repair content itself —
it dispatches the authoring persona and routes upstream edits · never treats a
question, marker or comment as a carrier · never reports a gap without the
band-wide search set named · never reports a gap out of a corpus it did not
cover (D-S3) · never renders a header number it did not derive from the
register on disk (D-S2) · never evaluates its own CC-S assertions absent the
BA's explicit self-evaluated election, and never treats a policy refusal as a
dead dispatch to retry (D-S1) · never appends a report entry over a workspace
missing a required file (D-S4) · never reads a source the inventory did not
capture · never re-proposes a standing SA absent new source ground · never
runs auto past P-A1.

## 12. Amendment record — EC-17, audit integrity (v0.1 → v0.2)

Origin: the **field defect report of 2026-08-20**, Part A evidence **A1–A5**
and **A7** — a `/ba-audit` run 1 over a live band. Ruled by the BA,
**"apply all recommendations"**, 21 August 2026 (registration EC-17; base
commit `3f0f59d`, package 0.1.33). The report is the ground and is **cited
here, never restated**. The five rulings below are the report's items **B1–B4**
and **B11**. **Two questions the amendment carried were ruled at the sitting:**
the CC-S-04 / amend-row precedence (D-S5, the recommended reading), and this
document's status line — **lifted from *draft for maintainer review* to
*ruled***, the maintainer's own ruling being the basis a draft was waiting on.

| ID | Decision | Ruling |
|---|---|---|
| **D-S1** | The dispatch had two states and the field found a third | **UNDISPATCHABLE — policy unavailability — is named beside mechanical death.** §4 carries the three states, the Stage-0 refusal with its named unblocking act, the Stage-2 halt back to that same refusal where the restriction surfaces only at dispatch, and the **BA-electable self-evaluated mode** — stamped verdicts, a run status forced `INCOMPLETE`, the election recorded in the BA's words. **Silence is not a legal path** and the substitution absent the election is a **defined violation**. The election is a **ruling at the refusal's closing ask** (orchestrator §10.3 rule 9), not an invocation argument: an election typed before the restriction is known is an election made blind, and the skill's argument line is untouched |
| **D-S2** | A header number nobody had to derive | **The five P-A1 header numbers are counted from `obligations.md`'s rows by status at render time**, with `c + p + a + g = t`; `Sources read:` and the `Claims:` line derive the same way. A head disagreeing with the on-disk rows is **invalid audit output** on the bar §5 already sets for a finding without its quote, corrected before render. A number a prior run rendered, a fixture carries or the session remembers is **evidence of nothing** — run 1's 118 is §9's calibration figure, and its register held 30 rows |
| **D-S3** | A completeness claim with no corpus behind it | **Per-source coverage accounting** in the register head — one line per captured source, `<sections walked>/<sections total> · <n> rows`, a zero-row source stating why — so a keyword probe and a full two-pass walk are **different objects on disk**. And the **corpus-declaration rule (D-O81, orchestrator §8.1) applied at this document's own two retrievals**: the Stage-1 walk and the band-wide search set each **name** the corpus they must cover, the run **states** the corpus it covered, and **a sample never grounds a `gap`** — where the covered corpus falls short, no gap renders out of the uncovered part. **This closes the item BUILD-LOG §34 routed as *the same defect one level up*** and left named-and-unbuilt on purpose; the audit's own corpus axes are established here, by this report's evidence, which is the condition that routing set. **Framework law is cited, never restated** — no second copy of D-O81 |
| **D-S4** | The workspace did not hold what the entry claimed | **`decision-list.md` becomes an explicit Stage-3 write act** — the list written before the ruling is asked for, the ruling written back into the same file, and **a clean run writes it too**, zero rows and its `Rulings:` line, because *nothing found* is a result. §7 marks the **required set** — `obligations.md`, `trace.json`, `decision-list.md` unconditionally; `repairs.json` where the ruling produced at least one executable row — and **§6's Stage-5 entry refuses to append** over a missing required file, naming it, the run standing `INCOMPLETE`. `repairs.json` is conditional because *absent* and *stubbed* are the same hole (build plan D-P2-6's own logic) |
| **D-S5** | CC-S-04's per-row grain vs the amend row's enumeration | **The two govern different objects and the boundary is stated.** The **finding grain is CC-S-04's and is untouched**: at the A pass every unmapped acceptance row is its own finding, quoting the row. The **list-row grain is §5's**: distinct dispositions render distinct rows — a ruling is taken per disposition and two cannot ride one answer — while a **shared** disposition is governed by **one enumerated `amend` row**, and **its enumeration count must equal the unmapped-row count it absorbs**. The equality is the force: run-1's three-of-five render failed by arithmetic, and nothing in v0.1 could say so |

**The CC-S card is not recompiled, and that is an assertion.**
`payload/specify-overlay/ba/cards/assertions-s.md` stands **byte-unchanged**
this amendment. D-S5 fixes a boundary **between** CC-S-04's grain and §5's, and
edits neither: the card's *each unmapped row is its own finding* is true of the
A pass exactly as written, and the absorption it might seem to contradict
happens one stage later, at the render the card does not own.

**Deliberately not built here.** `check-audit.sh` and `sk_audit.py` stay on
§10's pending list. D-S2 and D-S3 now fix what the first of those must assert
— named in §10 item 7 and re-routed in the build log — but a legislative pass
does not grow a test-harness lane, and the M-share checker's ground is a
register that exists only at run time.

**Deliberately not legislated here.** §9's calibration fixture carries the
figure `118` in prose, and run 1 rendered that figure over a register of 30.
Whether a fixture may state a live-looking count in a form a run can echo is a
**fixture-hygiene** question, adjacent to D-S2 and outside the five rulings
this amendment was authored to. Named, not ruled.

---

*v0.2 · audit integrity — the register stops lying about its own coverage: the undispatchable state named beside mechanical death, its Stage-0 refusal with the named unblocking act and the BA-electable self-evaluated mode whose verdicts are stamped and whose run stands `INCOMPLETE`, silence no legal path and the substitution absent the election a defined violation (§4 · §11) · the five P-A1 header numbers derived from the register's rows by status at render time, `c + p + a + g = t`, a head disagreeing with the on-disk rows invalid audit output (§5) · per-source coverage accounting in the register head and the corpus-declaration rule applied at both of this document's retrievals — the Stage-1 walk and the band-wide search set naming the corpus they must cover, the run stating the corpus it covered, a sample never grounding a `gap` (§2 · §3 · §5) · `decision-list.md` an explicit Stage-3 write act on a clean run too, §7's required set, and the Stage-5 entry refusing to append over a missing required file (§5 · §6 · §7) · CC-S-04's finding grain untouched and carrying through the list across distinct dispositions, one enumerated `amend` row governing a shared disposition with its enumeration count equal to the unmapped-row count it absorbs (§5) — applied 21 Aug 2026 (D-S1…D-S5, amendment record §12; base `3f0f59d`, package 0.1.33; origin: the field defect report of 2026-08-20, Part A evidence A1–A5 · A7; BA ruling "apply all recommendations", 21 Aug 2026) · v0.1 · drafted 16 Aug 2026 from the Nutrivity band evaluation of 14 Aug 2026 · Scope S — source fidelity, band-level, one BA checkpoint at P-A1 · complementary to the completeness gate and changing no verdict it owns · reaches framework law by reference, never by restatement (orchestrator D-O81 · §10.3 rule 9) · decisions D-S1–D-S5 locked · amendment records: v0.1→v0.2 in §12 · compiles to the units in §10 and never the reverse*
