# BA-Native Spec — the source audit (Scope S)

**Status:** ruled · 30 August 2026 — v0.5 (v0.4 ruled 2026-08-25; v0.3 ruled
2026-08-23; v0.2 ruled 2026-08-21; v0.1 drafted 2026-08-16) · document-first
under the one-way rule (BUILD-LOG S9, closure note ii): this document is the
source; the package units in §10 compile from it and never the reverse.

**v0.5 change record:** three rulings — **the report shows the movement**,
ruled 30 Aug 2026 (**D-S9** · **D-S10** · **D-S11**, amendment record §15; base
commit `f7aeb94`, package 0.1.44; origin: the **owner ruling of 30 Aug 2026**,
`apply all` over a six-item list raised on 29 Aug — *"enrich ba-audit with a
beautiful stats report — findings, fixes with a log, before/after, a ratio of
defect vs total content (acceptance criteria)"*): the coverage report showed a
closed run's **end state and nothing else** — a reader could not see what the
ruling fixed, what moved since the last report, or how defective the band is
per unit of its own content — and every one of those figures already stood on
disk with no render over it: **the delta is recorded** (§6 · §7) — `trace.json`'s
Stage-2 blocks are written once and **never rewritten**, the re-audit adds one
block of its own, `re_audit` (the post-repair counts, the band's size, every
register row that moved with the list row that moved it), and the band's size
— specs · stories · acceptance items — is counted by the gate's own parser
through `sk_audit_report.py --band` and **pasted, never typed** (**D-S9**) ·
**the two ratios** (§6b) — coverage % exactly as D-S6 fixed it, and **defect
density = (partial + gaps + ungrounded + contradictions) per 100 acceptance
items**, one decimal, empty at zero items, each rendered beside its components
and **never blended into a score** (**D-S10**) · **the reader sees the
movement** (§6b · §7) — two further pinned sheets after D-S6's four, `Before &
After` (previous closed run · at P-A1 · after repairs, both deltas) and `Fix
Log` (every `repairs.json` row across every run, newest first, a resumed row
joined to the run that **ruled** it — the seam §14 routed, closed here), the
dashboard render **`exports/audit-stats.html`** joining the required set
beside the workbook and the csv, `--report` re-rendering all three, and a
five-line plain-language **closing tail** printed by the renderer at run
close, asking nothing (**D-S11**). The four sheets D-S6 pinned stand exactly as
pinned and the golden csv holds; **nothing about what the audit checks moves**,
no CC-S family is touched, `assertions-s.md` stands byte-unchanged, D-S8's
resumption stays one run deep, and §8's budget is arithmetically untouched.

**v0.4 change record:** two rulings — **the repair route becomes executable**,
ruled 25 Aug 2026 (**D-S7** · **D-S8**, amendment record §14; base commit
`3b028bd`, package 0.1.40; origin: the **field audit run of 2026-08-23** —
Nutrivity, the first `/ba-audit` run on the post-wave package): the audit's
Stage 4 **mandated a dispatch the dispatch target's own definition forbade**,
and the field session — correctly — refused both the dispatch and the
self-authoring the refusal would otherwise have invited, leaving **14 of 19
ruled repair rows unexecuted** with nothing in the framework to bring them
back: **the named exception** (§6) — the `ba-analyst` fence gains **one**
carve-out, `/ba-audit`'s **post-ruling** Stage-4 repair route, draft-first and
assumption posture exactly as Stage 4 already specifies; the audit's *authors
nothing itself* bar **stands untouched**, and the D-S1 separation the fence
protects is the **evaluator's**, which this carve-out does not touch —
**silent self-substitution stays a defined violation**, and a repair row whose
dispatch is refused stands `unexecuted` with its `why`, never self-authored
(**D-S7**) · **the standing ruling carries** (§6) — a row standing **ruled and
unexecuted** in the most recent run that wrote a `repairs.json` **re-enters the
next run's Stage-4 route ahead of that run's new rows**, on the ruling it
already carries: **no re-ruling, no second P-A1 render, no new flag, no new
instrument and no new file** — `unexecuted` is already the state, the required
set (§7) already holds the ruling and the target, and the resumption is a
**read** (**D-S8**). **Nothing about what the audit checks moves**, no CC-S
family is touched and `assertions-s.md` stands byte-unchanged.

**v0.3 change record:** one ruling — the coverage report, ruled 23 Aug 2026
(**D-S6**, amendment record §13; base commit `3b028bd`, package 0.1.39;
origin: the **owner ruling of 23 Aug 2026** — a closed run's whole coverage
picture stands inside `obligations.md`, three directories down, in a markdown
grammar built for a walker and not for a reader: the decision list renders
**findings**, and nothing renders the **register**): **Stage 5b — the coverage
report** (§6b). **A run is not closed until it renders**
`exports/audit-report.xlsx` and `exports/audit-report.csv` from the **closed
run's post-repair state** — the render standing **after the re-audit delta and
before the entry appends**, the two files joining §7's required set at the
force **D-S4** already sets, and the entry carrying a pinned `Coverage report:`
field, because an entry that appends first and renders second names a file that
may not exist — the D-S4 defect one artifact along · **four pinned sheets** —
`Coverage Matrix`, one row per post-repair `OB` row (source · section ·
verbatim quote · modality · phase claim · carrier · status · finding #) ·
`Per-Source Summary` (per captured source: sections walked, obligations, the
four status counts, coverage %) · `Findings & Rulings` (the decision list as
ruled, each row carrying its outcome) · `SA Register` (the standing records) —
and **the csv carries the Coverage Matrix alone**, the canonical render ·
**`/ba-wbs`'s render conventions over the `sk_xlsx.py` helpers** — xlsx primary
and written first, csv canonical and title-block-free, a title block above the
bold header row, wrapped text, column widths, no cell merges — with **§10.5's
stakeholder register expressly not carried**: this export is **BA-facing
operational state**, the report ledger's own class, and the audit's evidence bar
governs its cells, quotes verbatim and `CC-S` · `OB` · `SA` codes as themselves
· **every number derived** — **D-S2 extended from the P-A1 head to the
workbook**, the renderer asserting nothing of its own, an empty source rendering
an **empty cell**, and the Coverage Matrix's row count, the `TOTAL` row and the
entry's `Register:` line one figure counted three ways · **coverage % is
`(carried + accepted) ÷ obligations`**, whole percent, `partial` and `gap` the
uncovered remainder taking **no half credit** (a weighting is a number this
framework does not produce), the four counts rendering beside it and a zero-row
source rendering an empty cell · **a sampled corpus renders twice** — the title
block and every affected source's `Note` — **D-S3** applied to the most
authoritative-looking render the framework produces · **`--report`** — a
re-render of the two files from the latest closed run: no walk, no dispatch, no
ruling, no repair, **no append**, no checkpoint, exclusive with `--full`, and
refusing over a missing required file by **naming it**. **No new assertion, no
new CC-S family, no new instrument, no new record class, no new prompt point, no
new stop and no new status value** — P-A1 stays the one checkpoint and §8's
interaction budget is arithmetically untouched. **The CC-S card is not
recompiled:** D-S6 adds a render and no assertion, so `assertions-s.md` stands
byte-unchanged. **A new §6b and not a renumber** — the section anchors are cited
from the skill, the entry template and the harness, and additive numbering is
the estate's own precedent. **Amended on the record, never rewritten:** §6's
re-audit bullet and its append condition, §7's artifact listing and its required
set, §10's unit list (item 7's `check-audit.sh` lands with this amendment;
`sk_audit.py` stays pending), §11's never-list.

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

- **The route's rows, in order (D-S8).** **Rows standing ruled and unexecuted
  come first**, ahead of this run's new rows — see *the standing ruling
  carries*, below.
- **Spec edits** — dispatched to the `ba-analyst` subagent per target spec,
  draft-first, assumption posture: the approved proposal is a draft whose
  inferred values are marked, exactly as Tier-2 fixes are. **This is the one
  act that dispatches the authoring persona directly, and it is named as an
  exception in that persona's own fence (D-S7).** **The permission it uses is
  framework-grain and not this document's:** a compile-source persona is
  dispatchable **only as a batch author executing an already-ruled route**, and
  never for an act that would stop and take a BA decision (**orchestrator
  D-O98**, §11). **This route satisfies that condition**, and why it does is
  set out below. The audit itself never authors a line.
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
  Render the delta — obligations closed, claims resolved, anything new — **and
  record it (D-S9)**: the re-audit writes `trace.json`'s `re_audit` block (§7)
  — the post-repair forward and backward counts, the band's size counted again
  through `sk_audit_report.py --band`, and **every register row whose status
  moved**, with the `repairs.json` row whose repair moved it — and **rewrites
  nothing above it**: the Stage-2 blocks are the P-A1 state and stay as
  written, exactly as `decision-list.md`'s *as rendered* head does. **A run
  whose route had no executable row re-audits too** — the block writes with
  counts equal to Stage 2's and an empty `rows` list, because *nothing moved*
  is a result, and a block a renderer has to guess about is not. The entry's
  `Re-audit delta:` line is **derived from the block**, never narrated: *closed*
  counts the rows moving from `partial` or `gap` to `carried` or `accepted`,
  *resolved* is the fall in `ungrounded + contradictions`, *newly surfaced*
  counts the rows the block records with no *before*. Then **Stage 5b renders
  the coverage report** over the post-repair state (§6b), **and the entry
  appends last**. Convergence is expected in one cycle; a second cycle that
  still finds new rows is itself a finding.
- **The entry refuses an incomplete workspace (D-S4).** Before appending,
  the run checks the workspace against §7's required set — **the coverage
  report's two files included, and checked after Stage 5b has written them**
  (D-S6). **Where a required file is missing the entry does not append** — the
  run **names the missing file** and stands `INCOMPLETE`. An append is a claim
  on the append-only ledger that the run behind it happened; an entry that
  outruns its own workspace makes that claim false for every later reader, and
  the ledger is the one surface no later run can correct.
- **Escapes.** A source obligation that surfaces downstream — client review,
  gate run, implementation — which no audit run listed is filed in
  `.specify/gate-tuning.md` as an escape with class `audit escape`, naming the
  CC-S family that ought to have caught it (or "none — new class"). The
  audit's backstops shrink to zero catches the same way the gate's do.

**The named exception — why the audit may dispatch the author (D-S7).** The
authoring persona's own definition fences it: *a compile source, not a dispatch
target — no skill dispatches it, and none should*. **The fence is right, and
this is its one exception.** It exists because that text **compiles into** the
Tier-2 skill that authors specs, and the persona's body binds it to that
skill's **context order, its cap, its legality rule and its output contract**.
A skill that reached past Tier 2 and dispatched the persona bare would supply
**none** of those: an author working without a definition, producing a spec
nobody scoped, capped or contracted. That is the failure the fence forbids, and
it is a real one.

**The audit's Stage-4 dispatch is not that act, and the difference is the
ruling.** This dispatch is **post-ruling**: by the time it fires, P-A1 has
already fixed every input the Tier-2 definition would have supplied — the
**target spec**, the obligation with its **verbatim quote**, the **approved
proposal**, and the **posture** (draft-first, inferred values marked, exactly
as Tier-2 fixes land). The audit does not ask for a spec; it hands a **ruled
edit** to a spec that already stands. The definition the fence protects is not
missing here — **it arrives as the ruling**. The fence therefore names this
route as its **single** exception, and the exception is written where the route
is: here, in this document. The persona's fence **cites** this rule; it does
not restate it.

**One act, two documents, and the split is by subject.** The **condition** —
which kind of dispatch a compile-source persona may accept at all — is
framework law and lives at **orchestrator §11 (D-O98)**: *dispatchable only as
a batch author executing an already-ruled route, never for an act that would
stop and take a BA decision.* **This document owns the route:** that Stage 4
meets that condition, what the P-A1 ruling fixes, what happens where the
dispatch is refused, and how a stranded row resumes. **That is how a route
qualifies at all** — by **its own law** establishing it as post-ruling and
batch-shaped, never by an enumeration kept at §11; a route whose document
establishes nothing does not qualify by resembling this one. **Neither document
restates the other.** D-O98 changes nothing in the ruling above — it states the
permission this exception always relied on, and names this persona as one of
the two it finds dispatchable, `ba-gate` being the other.

**The bar this does not move.** *The audit authors nothing itself* (§11) stands
exactly as written. D-S7 changes **who may be dispatched**, never **who may
write** — and the audit is still not on that list.

**Why this does not reopen the substitution D-S1 forbids.** The separation the
A pass rests on is the **evaluator's**: a session that authored the register is
the last reader who can independently judge it, which is why §4's undispatchable
state has a refusal and an election and not an improvisation. **D-S7 runs the
other way.** It exists so the audit **need not** author — it makes the lawful
path available where the route previously had none. **Silent self-substitution
remains a defined violation of §4**, untouched and unweakened by this ruling,
and the two acts are not neighbours: one is the judge writing the verdict it was
to have received, the other is the router handing a ruled edit to the author
whose job it already is.

**And the refusal has a landing.** Where the dispatch itself is
**undispatchable** — §4's third state, a policy restriction on agent calls at
all — the repair route **does not improvise**: the row lands `unexecuted` with
its `why`, and **D-S8 brings it back**. Self-authoring is no more the remedy one
stage along than it was at the A pass, and for the same reason. **A route that
cannot execute a row stops nothing else**: the remaining rows run, the re-audit
runs, the report renders and the entry appends with the run's true status.

**The standing ruling carries — ruled, unexecuted rows resume (D-S8).** A row
the BA has ruled and the route could not execute is **not spent**. **Its
ground already exists and no instrument is added to hold it:** `repairs.json`
records the row `unexecuted` **with its `why`**, keyed by the decision-list row
number, and `decision-list.md` holds that row **as ruled** — both §7 **required**
files, present by construction. The resumption is a **read**.

- **The rule.** At Stage 4, **before this run's own rows**, the route reads
  **the most recent run whose workspace holds a `repairs.json`** and re-enters
  **every row standing `unexecuted`**, each on the ruling it already carries.
- **No second ruling. P-A1 does not see it again** — that checkpoint rules the
  **findings this run's A pass raised**, and a resumed row is a **standing
  ruling, not a finding**. Re-rendering it would ask the BA to rule twice on
  one proposal, which is how a ruling loses its force.
- **Resumed rows run first.** A ruling the BA has already given outranks a
  proposal they have not yet seen executed.
- **The record is one key, not a second file.** The resumed row lands in
  **this** run's `repairs.json` on the existing grammar, naming the run that
  ruled it: `{"#": 3, "from-run": 7, "target": "<path>", "outcome": "landed"}`.
  `from-run` is **absent** on a row this run ruled, and its presence is the
  whole of the resumption's trail.
- **A re-refusal resumes again.** A resumed row that still cannot execute lands
  `unexecuted` with its `why` — which may differ from last run's — and resumes
  at the next run. **No count of attempts closes a row**, and a row does not
  expire: only **execution**, or a **ruling**, ends it.
- **Closure without execution is named, never silent.** Where the obligation
  behind a resumed row is no longer live — the post-repair register no longer
  carries it, or a standing SA now covers it — the row closes
  `superseded — <reason>` in this run's `repairs.json`, naming what closed it.
  The read that brings a row back is the same read that would have to drop it,
  and it may not drop one quietly.
- **What this adds: nothing.** No new flag on the decision list, no second
  ruling grammar, no new required file, no new prompt point, no new stop and
  **no new BA interaction** — §8's budget is arithmetically untouched. The
  route's own grammar already had every part; what it lacked was the rule that
  reads it.

## 6b. Stage 5b — the coverage report

The decision list renders **findings**. Nothing renders the **register**. A
closed run's whole coverage picture — every obligation, its quote, its carrier,
its status — stands inside `obligations.md`, three directories down, in a
markdown grammar built for a walker and not for a reader. **Stage 5b is the
reader's copy, and it is permanent** (**D-S6**).

**The run is not closed until it renders.** After the re-audit delta (§6) and
**before the entry appends**, the run writes three files:

```
exports/audit-report.xlsx   the primary render — four pinned sheets (D-S6)
                            and two further sheets after them (D-S11)
exports/audit-report.csv    the canonical render — the Coverage Matrix alone
exports/audit-stats.html    the dashboard render — one self-contained file,
                            the movement (D-S11)
```

All three join §7's required set at the force **D-S4** already sets: **where the
render does not complete the entry does not append** — the run names the file
it could not write and stands `INCOMPLETE`. The ordering is the whole point. An
entry that appends first and renders second is an entry naming a file that may
not exist, and that is the D-S4 defect one artifact along.

**What the four sheets render is the closed run's post-repair state**, and
never the P-A1 state: the register as Stage 5's re-audit left it, the decision
list as ruled, the repairs as executed. A report over the pre-repair register
would show the BA the band their own ruling has already fixed. **D-S11 renders
the P-A1 state once, as the `At P-A1` column of the `Before & After` sheet —
beside the post-repair state and never instead of it**, which is the difference
between a before that shows what a ruling fixed and a report that shows the band
unfixed.

### The four sheets

Pinned — the names, the order and the columns:

**1 · `Coverage Matrix`** — one row per row of the post-repair
`obligations.md`:

```
| OB | Source | Section | Quote | Modality | Phase claim | Carrier | Status | Finding # |
```

The `OB-<nnn>` code is the **row key**; the eight columns after it are §2's row
grammar, one field per column, split at the grammar's own separators. **The
quote is verbatim** — the register's quote, unshortened and unrewritten: a
matrix whose quotes are summaries is not evidence. `Carrier` renders `none`
where the register says `none`. `Finding #` carries the P-A1 list number where
the row produced one and is **empty** where it produced none — never a dash,
never a zero.

**2 · `Per-Source Summary`** — one row per captured source, off §2's per-source
coverage block, plus one `TOTAL` row:

```
| Source | Sections walked | Sections total | Obligations | Carried | Partial | Accepted | Gaps | Coverage % | Note |
```

`Note` carries the register head's own words — a zero-row source's stated
reason, and **`sample — <what was not walked>` wherever the run's corpus fell
short of the corpus it named**.

**Coverage % is `(carried + accepted) ÷ obligations`, whole percent.** §1 states
what the audit proves — every obligation *carried somewhere in the band or
consciously declined on the record* — and that sentence is the numerator.
`partial` and `gap` are the uncovered remainder and take **no half credit**: a
weighting would be a number this framework does not produce. The four status
counts render beside the percentage, so any other reading is the reader's own
arithmetic and never the export's. A source holding **zero** obligations renders
an **empty** `Coverage %` cell — 0 ÷ 0 is not 100%, and it is not 0% either.

**3 · `Findings & Rulings`** — the decision list as ruled, one row per list row:

```
| # | CC-S | Evidence — source · section · "quote" | Band check | Proposal → target | Default | Ruling | Outcome |
```

`Ruling` is what the BA ruled — `apply` · `SA` · `amend — <the ruling>`;
`Outcome` is `repairs.json`'s per-row result — `landed` · `SA-<nn>` ·
`unexecuted — <why>`. **A clean run renders the sheet with its header row and
no rows**: *nothing found* is a result, and a sheet a workbook omits is a result
the reader cannot tell apart from a run that never checked — D-S4's own logic,
applied to the render.

**4 · `SA Register`** — the standing `SA-<nn>` records of
`.specify/source-audit.md`, this run's included:

```
| SA | OB | Source | Quote | Decision | Reason | Approver | Date | Revisit |
```

**Standing records, not this run's alone.** An SA is project-level, and a
reader asking *what did we decline?* is asking the register, not the run.

### The two further sheets (D-S11)

The four sheets above render a closed run's **state**. Two more render its
**movement**, appended after them — the four keep their names, their order and
their columns, and the csv still carries the Coverage Matrix alone.

**5 · `Before & After`** — three columns of counts and two of deltas, one row
per pinned measure:

```
| Measure | Previous closed run | At P-A1 | After repairs | Δ since previous | Δ by this ruling | Note |
```

The rows, pinned in this order, the `Measure` cell carrying the text shown:

```
Run
Sources read
Obligations
— carried
— partial
— accepted
— gaps
Coverage % (carried + accepted ÷ obligations)
Claims checked
— ungrounded
— contradictions
Specs in band
Stories
Acceptance items
Defects (partial + gaps + ungrounded + contradictions)
Defect density (defects per 100 acceptance items)
Findings raised
— CC-S-01 forward coverage
— CC-S-02 backward grounding
— CC-S-03 list union
— CC-S-04 client acceptance tables
— CC-S-05 unconditional NFRs
— CC-S-06 deferral legitimacy
— CC-S-07 persona coverage
— CC-S-08 cross-band consistency against sources
Ruled apply
Ruled SA
Ruled amend
Repairs landed
Repairs → SA
Repairs unexecuted
Repairs superseded
Resumed from earlier runs
```

**The three count columns have three grounds, and the render reads each from
its own.** `At P-A1` is `decision-list.md`'s *as rendered* head and
`trace.json`'s Stage-2 blocks — **two surfaces, one number** on the before
side, and a disagreement is invalid audit output on D-S2's bar. `After
repairs` is the post-repair register, `trace.json`'s `re_audit` block and
`repairs.json` — the same ground the four sheets render, so the obligation
count here is the Coverage Matrix's row count, the `TOTAL` row and the entry's
`Register:` line **one figure counted four ways**. `Previous closed run` is
**the latest ledger entry before this run whose workspace holds §7's required
set** — the selection `--report` already makes, applied from this run's number
downward: a refused admission is stepped past and **named on the `Run` row's
`Note`**, and where no earlier run qualifies the column is empty and the `Run`
row reads `none — first closed run`. That run's cells are read from **its own**
workspace and ledger entry — its `re_audit` block where it wrote one, else its
entry's three count lines — and a run from before this ruling, which carries
no `band` block and no `re_audit`, renders its band rows **empty**: an older
run is still a closed run, and an empty cell is what its evidence supports.

**The deltas.** `Δ since previous` is `After repairs` less `Previous closed
run`; `Δ by this ruling` is `After repairs` less `At P-A1`. Both render for the
count and ratio rows (`Sources read` through `Defect density`) as signed
figures — `+3` · `-2` · `0`, percentage points on the `Coverage %` row — and
**empty where either side is empty**. The finding, ruling and repair rows carry
`Δ since previous` and leave `Δ by this ruling` empty: a ruling has no *before*
of its own. The `At P-A1` column carries the finding and ruling rows and leaves
the repair rows empty, because a repair is a post-ruling fact. `Resumed from
earlier runs` counts this run's `repairs.json` rows carrying `from-run`.

**`Note` carries what the numbers cannot.** The `Run` row's stepped-past
refusals or its `none — first closed run`; the `Coverage %` row's
`sample — <what was not walked>` verbatim from the corpus line wherever the run
sampled (D-S3's double render, extended to the headline); and the `Acceptance
items` and `Defect density` rows' `sample — <k> spec(s) unreadable: <paths>`
wherever `trace.json`'s `band.unreadable` is non-empty. A density over a band
the parser could not fully read is a density over a sample, and it says so on
its own row.

**6 · `Fix Log`** — one row per row of **every** `repairs.json` under
`.specify/ba/runs/band-audit/run-*/`, newest run first, list order within a
run:

```
| Run | # | From run | OB | CC-S | Proposal → target | Ruling | Target file | Outcome | Why |
```

`Run`, `#`, `From run`, `Target file`, `Outcome` and `Why` are the
`repairs.json` row's own fields. **`OB`, `CC-S`, `Proposal → target` and
`Ruling` are joined by `#` to the decision list of the run that ruled the row**
— the `from-run` run where the key is present, the row's own run where it is
not. **That join is the seam §14 routed** — *a row resumed from an earlier run
has its ruling in that run's list and its outcome in this one* — and this is
its answer: `Findings & Rulings` stays **this run's list alone**, exactly as
D-S6 pinned it, and the Fix Log carries the cross-run join with `From run`
filled on every resumed row. Two rows may share a `#` — one resumed, one this
run's own — and `From run` is what tells them apart. A run that wrote no
`repairs.json` contributes no rows; a refused admission has no workspace and
contributes none. Every cell the files do not carry renders **empty**.

**The sweep is a render, not a resumption.** §14 named — and did not open —
*a repair-history sweep across all prior runs*. This sheet **reads** every
run's `repairs.json`; it resumes nothing, re-rules nothing and writes nothing.
**D-S8's resumption stays one run deep** exactly as ruled: the rule that brings
a row back reads the most recent run that wrote a `repairs.json`, and a sheet
that shows the whole trail changes nothing about which row comes back or when.

### The two ratios (D-S10)

**Coverage %** is fixed above under the Per-Source Summary, and this ruling
does not touch its formula, its rounding or its empty cell. It is **the
client's number** — *of what the client asked for, how much does the band carry
or consciously decline?* — and its denominator is the client's material.

**Defect density is the band's number.** It answers *how defective is the band
per unit of its own content?*, and its denominator is the band:

```
defects          = partial + gaps + ungrounded + contradictions
acceptance items = every checklist line and every Gherkin scenario standing
                   beneath a story, across every specs/NNN-*/spec.md in the
                   band — the writing standard's §5 unit, counted by the
                   gate's own parser (sk_structure — CC-AC-01's own count)
defect density   = defects ÷ acceptance items × 100, one decimal place
```

**The four states are the numerator because they are exactly the states a
finding is raised against.** An obligation standing `partial` or `gap` is the
uncovered remainder D-S6 already refuses half credit for; a claim standing
`ungrounded` or `contradicts` is CC-S-02's and CC-S-08's whole subject; and a
deferral whose basis a source contradicts — CC-S-06's case — **stands `gap`
under §3, never `accepted`**, because `accepted` requires *a basis no source
contradicts*. No finding lives outside the four, so the count needs no
family-by-family exception list. `accepted` is not a defect: it is the
conscious declining §1 names, on the record.

**Acceptance items are the denominator because they are the unit the client
reads and the engineer implements.** Obligations as a denominator would only
restate coverage from the other end (100 − coverage %) and say nothing about
the band's size; claims checked is the audit's own sample of the band, not the
band. The count is **mechanical**: `sk_audit_report.py --band --root .` prints
the block, the session **pastes it verbatim** into `trace.json` — at Stage 2
and again at Stage 5 (§7) — and a band block typed by hand is a D-S2 violation,
because an acceptance figure counted by eye is an asserted number. The render
**reads the recorded block and re-counts nothing**: the estate moves after a
run closes, the record does not, and a `--report` taken weeks later must
render the run, not the estate.

**Both ratios render beside their components, and no third number blends
them.** A score that weighed coverage against density would be a number this
framework does not produce — the reason D-S6 gave for refusing half credit,
applied to the pair. Zero acceptance items renders an **empty** density cell,
as zero obligations renders an empty coverage cell; a non-empty
`band.unreadable` renders the density over the readable rest **with its sample
note on the row**.

### The dashboard render — `exports/audit-stats.html` (D-S11)

The workbook is the record and the csv is the diff; **neither is a picture.**
Stage 5b writes a third file, `exports/audit-stats.html` — **one self-contained
file**: inline CSS, inline SVG, no script, no external asset, opening offline
in any browser and dropping into a channel as a file. **Every figure on it is
the `Before & After` sheet's own figure, from the one derivation** — the html
adds no number the sheet does not carry, and a figure that differs between the
two is invalid audit output on D-S2's bar.

Pinned — the sections, in this order; the styling is the renderer's:

1. **The title block** — the same four lines as every sheet.
2. **The headline** — coverage % and defect density, each `at P-A1 → after
   repairs` for this ruling and `previous closed run → after repairs` since
   the last report; the fix counts — landed · unexecuted · declined (SA) ·
   resumed.
3. **The movement** — the four obligation statuses and the two claim
   statuses, three bars per measure (previous closed run · at P-A1 · after
   repairs), in inline SVG, the counts written on the bars.
4. **What moved** — `re_audit.rows` as a table: OB · the register's verbatim
   quote · before → after · the row that moved it (`from run <n>` where
   resumed).
5. **Findings by family** — the eight CC-S rows, code beside its plain-language
   gloss, this run against the previous closed run.
6. **The fix log** — the `Fix Log` sheet's rows under two headings: *Fixes
   since the previous report (run <n>)*, then *Earlier runs*.

**Plain language leads, codes beside a gloss.** A heading reads *Coverage —
obligations carried or consciously declined*, not `CC-S-01`; a code renders
beside its words, never bare. **The html is the workbook's class** — BA-facing
operational state, never client-facing, §10.5's stakeholder register expressly
not carried — and quotes stay verbatim on it as they do in the matrix.

### The closing tail (D-S11)

**After the entry appends, and again under `--report`, the run renders five
lines into the conversation — before the closing ask, asking nothing:**

```
Coverage <c0>% → <c1>% by this ruling · <cp>% → <c1>% since the previous report (run <n>).
Defects per 100 acceptance items <d0> → <d1> · <dp> → <d1> since run <n>.
Fixes: <k> landed · <u> unexecuted — resume next run · <s> declined (SA) · <r> resumed from earlier runs.
Findings this run: <f> — <n> forward coverage (CC-S-01) · <n> <gloss> (CC-S-nn) · …
Report: exports/audit-stats.html — the picture · audit-report.xlsx · audit-report.csv.
```

**The tail is the renderer's, not the session's** — `sk_audit_report.py`
prints it at the end of every render and the skill echoes it verbatim, so the
five lines are the sheet's figures once more and never a summary composed from
memory (the field defect of 2026-08-20, one render along). Line 4 names only
the families with a non-zero count, each code beside its gloss. Where there is
no previous closed run, the *since* halves of lines 1 and 2 read `first closed
run — no previous report`; where the previous closed run carries no band block,
line 2's *since* half reads `no acceptance count on run <n>`; and where the
sheet leaves any other cell empty, the tail leaves its figure empty too. **Where the run stands `INCOMPLETE`, the entry's
`Status:` line renders verbatim as a line above the five**, so the reader who
reads only the chat reads the status. The tail **asks nothing** — §8's budget
is untouched — and the closing ask that follows it is orchestrator §10.3
rule 9's, unchanged.

### The render conventions, and the register that is not carried

The render conventions are **`/ba-wbs`'s**, over the same `sk_xlsx.py` helpers:
the **xlsx is the primary and is written first**, the **csv is the canonical,
diff-friendly render and carries the Coverage Matrix alone, with no title
block**; a title block sits above the **bold header row** of every sheet; text
wraps, every column carries a width, and there are **no cell merges** — a value
repeats per row. Stable paths, overwritten per run, derived and never
hand-edited: a hand edit dies at the next render.

**§10.5's stakeholder register is expressly not carried.** The WBS is a
client-facing artifact and its cell rules exist for that reader. **This export
is BA-facing operational state** — the report ledger's own class (§7; quickstart
rule 3: never quoted into a spec) — and the **audit's evidence bar** governs its
cells instead: **verbatim quotes stay verbatim**, and `CC-S`, `OB` and `SA`
codes render as themselves. A client-facing derivative of this workbook would be
a different artifact and is not ruled here.

**The title block** — four lines, above the header row of **every** sheet,
because a sheet a reader opens alone must still say which run it came from:

```
Source audit run <n> — <date> · profile: <profile>
Status: <complete | INCOMPLETE — <reason>>
Sources read: <k> · unaudited ground: <named, with states | none>
Corpus covered: <the named corpus, walked | sample — <what was not walked>>
```

Its ground is **the ground the entry's own head is assembled from**, so the
workbook and the ledger cannot disagree: lines 1, 3 and 4 are `decision-list.md`'s
pinned P-A1 head — lines 3 and 4 **copied verbatim** — and line 2 is the run's
recorded status where the ledger already carries the entry, the P-A1 head's
**conditional** `Status:` line where it does not, and `complete` where neither
speaks. Stage 5b renders **before** the append, so on a fresh run the P-A1 head
is the only ground there is; under `--report` the entry stands and its status
is the truer one.

**A sampled corpus renders twice.** Once on the title block, as the run's own
`Corpus covered:` line verbatim; and once **per source**, on the `Note` of every
source whose register-head line shows fewer sections walked than the source
holds — `sample — <walked>/<total> sections walked`, beside whatever the head
itself said. A spreadsheet is the most authoritative-looking render this
framework produces, and a sample it does not name is **D-S3**'s defect in its
most persuasive form.

### Every number is derived (D-S2, extended)

D-S2 fixed the P-A1 head. **The same rule governs every cell of this workbook.**
The Coverage Matrix's rows are the register's rows; the Per-Source Summary's
counts are those rows grouped by source; the percentage is computed from them;
the Findings sheet is `decision-list.md` **as ruled** joined to `repairs.json`'s
outcomes; the SA Register is the ledger's records. **The renderer asserts
nothing of its own, and a field the workspace does not carry renders an empty
cell** — never a guess, never a default. That is `/ba-wbs`'s never-invents
clause, and it is this render's too.

**Three surfaces, one number.** The Coverage Matrix's row count, the
Per-Source Summary's `TOTAL` row and the entry's `Register:` line are one figure
counted three ways. **A disagreement is invalid audit output** on the bar D-S2
already sets, corrected before the render stands — never rendered and explained.

**A fourth surface, and the before side (D-S11).** The `Before & After` sheet's
`After repairs` obligation count is that same figure counted a fourth way; its
`At P-A1` count is `decision-list.md`'s *as rendered* head and `trace.json`'s
Stage-2 `forward` block, **one figure counted two ways**; and every figure on
`audit-stats.html` is the sheet's. Each disagreement is the same defect, on the
same bar.

### `--report` — the re-render

`/ba-audit --report` **re-renders the three export files from the latest closed
run and runs no audit.** It reads that run's workspace and the ledger, writes
the three files, prints the closing tail (§6b, D-S11), and — that done — it
does nothing else: **no walk, no dispatch, no ruling, no
repair, no append, no checkpoint**. The ledger already carries the run, and a
second entry for a re-render would be a claim that a second run happened. It is
**exclusive with `--full`**, and it is the whole act.

Where the ledger holds no entry, `--report` **refuses and names `/ba-audit`** as
the act. Where the closed run's workspace is missing a required file (§7), it
**refuses and names the file** — the same bar, and the reason a re-render is
never a repair: the evidence a report renders is evidence the run was supposed
to leave.

**A refused admission is stepped past; a holed workspace is not.** Run numbers
are gapless and include the Stage-0 refusals of §4, which open **no workspace at
all** — so a `--report` taken right after one meets it first. `--report` steps
past every such entry and **says which**: a refusal is not a closed run, and
refusing over evidence that was never supposed to exist is the wrong answer,
while a re-render of run 4 that quietly renders run 2 is the wrong artifact
under the right name. **The latest entry that did open a workspace is the run it
renders** — and where *that* workspace is short of §7's required set it refuses
and names the file, never stepping back another run. That run closed, D-S4
guaranteed its evidence at the append, and a hole in it is evidence gone
missing: the one thing a step backwards must not paper over.

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
                       — and READ BY THE NEXT RUN: every row standing
                       `unexecuted` resumes ahead of that run's own (D-S8)
exports/audit-report.xlsx  the coverage report — four pinned sheets (§6b)
                       — REQUIRED, rendered before the entry appends
exports/audit-report.csv   the same run's Coverage Matrix, canonical
                       — REQUIRED, rendered with it
exports/audit-stats.html   the same run's dashboard render — the movement
                       (§6b, D-S11) — REQUIRED, rendered with them
.specify/source-audit.md   append-only report ledger + standing SA records
.specify/ba/cards/assertions-s.md          the Scope-S card (compiled)
.specify/ba/templates/source-audit-report-entry.md   the pinned entry shape
```

Run numbers are monotonic and band-global. The report ledger is operational
state under quickstart rule 3: never quoted into a spec.

**`trace.json`'s pinned grammar (D-S9).** Three blocks written at Stage 2 and
**never rewritten**, one block written at Stage 5 by the re-audit and by
nothing else:

```
{
  "run": <n>,
  "forward":  {"rows": <t>, "carried": <c>, "partial": <p>, "accepted": <a>, "gaps": <g>},
  "backward": {"rows": <m>, "ungrounded": <u>, "contradictions": <x>},
  "band":     {"specs": <s>, "stories": <st>, "acceptance_items": <ac>, "unreadable": [<spec paths>]},
  "a_pass":   {…as §4 pins it…},
  "re_audit": {
    "forward":  {…the same five keys, post-repair…},
    "backward": {…the same three keys, post-repair…},
    "band":     {…the same four keys, post-repair…},
    "rows":     [{"OB": "OB-<nnn>", "before": <status | none>, "after": <status | none>,
                  "via": <repairs.json row #>, "from-run": <n>}, …]
  }
}
```

`forward` and `backward` are the P-A1 state and equal the head
`decision-list.md` renders from the register. `band` is the block
`sk_audit_report.py --band` printed, pasted verbatim (§6b, D-S10);
`unreadable` names every `specs/NNN-*/spec.md` the parser could not read, and
the counts cover the rest. `re_audit.rows` carries **every register row whose
status differs** between the P-A1 register and the post-repair one, every row
the re-audit **added** (`before: none`) and every row it **dropped** (`after:
none`); `via` is the `repairs.json` row whose repair moved it, `from-run`
beside it where that row carries one, and both absent where no repair row
moved it. **Claims move as counts only** — the trace keys no claim, and this
ruling mints no key. A run that reaches Stage 5 writes `re_audit` **even when
nothing moved** (§6). A `trace.json` from before this ruling carries no `band`
and no `re_audit`; the render reads what stands and leaves the rest empty.

**The required set is the append condition (D-S4 · D-S6).** The four workspace
files and the **three export files** (D-S11) are the run's own evidence, and
§6's re-audit step checks them before the entry appends. `repairs.json` is
conditional because an empty route file records nothing and *absent* and
*stubbed* are the same hole; the other three are unconditional because each of
them records a **result**, and a run with no findings has results too. **The
conditional file is also the forward-reading one (D-S8):** where a run wrote
one, the next run reads it before running its own rows, and a row standing
`unexecuted` resumes on the ruling `decision-list.md` already holds. That is
why the resumption needs no instrument — **it reads two files this section
already requires**, and a run that skipped writing them would have had no
entry. **The three
exports are unconditional for the same reason**: a clean run's coverage report
is the run's strongest result, and the register it renders is exactly what a
clean verdict is a claim about; the entry's `Coverage report:` field names all
three, and an entry from before D-S11 names two — the reader tolerates the
older line, and `--report` over that run renders three regardless. The exports live under `exports/` and not in the
run workspace because they are the reader's copy, not the walk's evidence —
**derived, regenerable by `--report`, and overwritten per run**; the workspace
is what they are derived *from*, which is why a missing workspace file refuses
the re-render as it refuses the append. **The run's recorded status** — `complete`, or
`INCOMPLETE` with its reason — is a pinned field of the entry (§5's `Status:`
line and the entry template's own), never prose: a status stated only in
sentences is a status the next run can forget to write.

## 8. The Presale interaction budget

The audit adds **one** BA interaction — the P-A1 ruling — and fits the
standing budget's spare (quickstart: eight, one spare by design). The repair
route and the re-audit ask nothing; the closing tail (§6b, D-S11) renders
and asks nothing. A run that needs a second interaction outside `amend` rows
is a register-rule defect, not a busy project.

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
   pinned entry. **Amended with v0.5:** the `Coverage report:` field names
   three files, and the `Re-audit delta:` line is derived from `trace.json`'s
   `re_audit` block (D-S9 · D-S11).
4. `tests/fixtures/nutrivity-audit/expected-findings.md` — the golden case.
5. `tests/layout.expected` — rows for 1–3; `RT|absent` for
   `.specify/source-audit.md` and the run workspace.
6. Landed with the v0.24 sitting: the mirror command-table row · the
   BUILD-LOG entry · the `tests/layout.expected` rows. P-A1 needs no
   catalogue-index row — it is this document's own prompt point, exactly as
   the gate's P1–P8 are the gate's (orchestrator §10.1's boundary sentence).
7. **Amended on the record with v0.3 — `check-audit.sh` lands here.** The
   audit's own suite, on the `check-gate.sh` model, its first subject **D-S6's
   render**: the four pinned sheets and their columns, the csv carrying the
   Coverage Matrix alone, the title block, the derived counts and the
   three-surface reconciliation, the coverage-percentage rule with its
   zero-obligation and no-half-credit cases, the sampled-corpus double render,
   `--report`'s two refusals, and the required-set append condition. **D-S2 and
   D-S3 are mechanically checkable through it** — the render derives what the
   P-A1 head asserts, so a check of the render is a check of the derivation.
   **Still pending, maintainer acts:** `sk_audit.py` for the M share of §4
   (until then §4's fallback governs) · the ratification sweep over the v0.2
   sitting's owner rulings · **the upstream fix of the run-1 escape**:
   capture-time renderings belong at `/ba-frame` (orchestrator §8.1 capture
   mechanics) so every consumer — Tier-2 source mining included — reads the
   same ground; until that lands, Stage 0's capture completion covers audit
   runs only. **Amended with v0.5 — its second subject is D-S9–D-S11:** the two
   further sheets with their pinned rows and columns, the previous-closed-run
   selection with a refusal stepped past and the first-run case, both deltas,
   the two ratios with the density's three cases (a figure · the empty cell at
   zero items · the sample note at an unreadable spec), `--band` against a
   fixture band, the html's six pinned sections, the five-line tail, the
   three-file required set, the Fix Log's cross-run join with two rows sharing
   a `#`, and the four-surface reconciliation. **The closed-run fixture gains a
   run 5** — a closed run in v0.5 grammar with movement, a resumed row from run
   2, and run 4's refusal standing between them — and **run 2 stays
   byte-untouched**, so the golden csv holds as the render of `--run 2`.
8. `payload/specify-overlay/ba/scripts/sk_audit_report.py` — the Stage-5b
   renderer (**D-S6**): reads the closed run's post-repair workspace and the
   ledger, writes `exports/audit-report.xlsx` and `exports/audit-report.csv`.
   Python 3, standard library only (build plan D-P2-7). It derives and never
   asserts; it authors nothing and edits no estate file. **Amended with v0.5
   (D-S9–D-S11):** it writes exactly **three** files — `exports/audit-stats.html`
   the third — over the same derivation, reads every run's `repairs.json` and
   the previous closed run's workspace and entry for the two further sheets,
   prints the five-line closing tail at the end of every render, and under
   `--band --root <estate>` counts the band through `sk_structure` and prints
   the `band` block for the session to paste — its one act that reads specs,
   and it reads them to count, never to judge.
9. `payload/specify-overlay/ba/scripts/sk_xlsx.py` — **the multi-sheet
   extension** (**D-S6**). `write()` keeps its single-sheet contract and its
   bytes: `/ba-wbs`'s workbook is unchanged by this amendment, and the suite
   asserts it. `write_book()` is the four-sheet writer, the same two cell
   formats, the same inline strings, the same fixed timestamps, one title block
   per sheet. **Untouched by v0.5:** `write_book()` takes six sheets as it took
   four, and the writer stays text-only — no number cell, no colour, no chart;
   the picture is the html's job (D-S11).
10. `tests/layout.expected` — the row for unit 8. The two export files take no
   row: `exports/` holds no installer-laid file and the layout bar asserts the
   installed tree, not a run's output.
11. **New with v0.4 — `payload/claude/agents/ba-analyst.md`** (**D-S7**). The
   authoring persona's fence is a compile target of **this** document at
   exactly one point: the **named exception**. The fence keeps its force; it
   gains the carve-out and **cites §6's rule rather than restating it** — the
   agent file states *that* the exception exists and *whose* route it is, and
   this document states what the exception is and why. A persona file is not a
   place law lives; it is a place law is obeyed. **The fence's wording is the
   orchestrator's compile target, not this document's** (**D-O98**, §11): the
   sentence states the framework **condition** — *dispatchable only as a batch
   author executing an already-ruled route* — and names this route as an
   instance that meets it, never as the definition. **Two compile sources, one
   sentence, disjoint subjects.**

## 11. What the audit never does

Never changes a gate verdict, a waiver, an override or a certification · never
edits anything before the P-A1 ruling — except a missing source rendering at
Stage 0 (§2's readability rule) · never authors repair content itself —
it dispatches the authoring persona under §6's named exception and routes
upstream edits (D-S7) · never dispatches that persona for anything but a
**post-ruling** repair at a ruled target, and never self-authors a repair whose
dispatch was refused — the row stands `unexecuted` with its `why` (D-S7) ·
never re-rules a row that stands ruled and unexecuted, and never drops one
without naming what closed it (D-S8) · never treats a
question, marker or comment as a carrier · never reports a gap without the
band-wide search set named · never reports a gap out of a corpus it did not
cover (D-S3) · never renders a header number it did not derive from the
register on disk (D-S2) · never evaluates its own CC-S assertions absent the
BA's explicit self-evaluated election, and never treats a policy refusal as a
dead dispatch to retry (D-S1) · never appends a report entry over a workspace
missing a required file, the coverage report's two files included (D-S4 ·
D-S6) · never renders a coverage report over anything but the closed run's
post-repair state · never renders a workbook number it did not count from that
state, and never fills a cell the workspace left empty (D-S2 extended, D-S6) ·
never renders a coverage percentage over a sampled corpus without naming the
sample on the title block and on the source's own row (D-S3 · D-S6) · never
treats the coverage report as client-facing content — it is operational state,
and §10.5's stakeholder register is not its rule (D-S6) · never appends,
repairs or rules under `--report` (D-S6) · never rewrites `trace.json`'s
Stage-2 blocks at re-audit, and never writes `re_audit` from anywhere but the
re-audit (D-S9) · never types a band count — the block is the script's, pasted
(D-S9 · D-S10) · never blends coverage % and defect density into one score, and
never renders either without its components beside it (D-S10) · never renders
a before/after figure it did not read from the run's own recorded state, and
never re-counts the estate under `--report` (D-S10 · D-S11) · never resumes,
re-rules or writes from the Fix Log's sweep — D-S8 stays one run deep (D-S11) ·
never composes the closing tail from memory — the renderer prints it, the
session echoes it (D-S11) · never appends over a missing `audit-stats.html`
(D-S4 · D-S11) · never reads a source the inventory did not capture · never
re-proposes a standing SA absent new source ground · never runs auto past
P-A1.

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

## 13. Amendment record — the coverage report (v0.2 → v0.3)

Origin: the **owner ruling of 23 August 2026**. Ruled and applied the same day
(base commit `3b028bd`, package 0.1.39). One ruling, and it is a **render**, not
an assertion: nothing about what the audit checks moves, and nothing about what
it may rule moves. What moves is what a closed run leaves behind for a reader.

| ID | Decision | Ruling |
|---|---|---|
| **D-S6** | A closed run left no artifact a reader could open | **Stage 5b — the coverage report — is permanent, and the run is not closed until it renders.** `exports/audit-report.xlsx` and `exports/audit-report.csv`, from the **closed run's post-repair state**, written **after the re-audit delta and before the entry appends**, both joining §7's required set at **D-S4**'s force and named by a pinned `Coverage report:` field on the entry. **Four pinned sheets** — `Coverage Matrix` (one row per post-repair `OB` row: the code as key, then source · section · verbatim quote · modality · phase claim · carrier · status · finding #) · `Per-Source Summary` (sections walked, obligations, the four status counts, coverage %, note) with a `TOTAL` row · `Findings & Rulings` (the list as ruled, each row's outcome from `repairs.json`) · `SA Register` (the standing records). The **csv carries the Coverage Matrix alone**. **`/ba-wbs`'s render conventions** over the same `sk_xlsx.py` helpers — xlsx first, csv canonical and title-block-free, a title block above the bold header row, wrapped text, widths, **no merges** — and **§10.5's stakeholder register expressly not carried**: this is BA-facing operational state and the audit's evidence bar governs its cells. **D-S2 extends from the head to the workbook** — every number counted from the post-repair state at render time, an absent field an empty cell, and the matrix's row count, the `TOTAL` row and the entry's `Register:` line one figure counted three ways. **Coverage % = `(carried + accepted) ÷ obligations`**, whole percent, no half credit for `partial`, an empty cell at zero obligations. **A sampled corpus renders twice** (D-S3). **`--report`** re-renders from the latest closed run — no audit, no append, no checkpoint, exclusive with `--full`, refusing by **naming** the missing entry or the missing file |

**Why a render was ruled and not an assertion.** The audit's own bar — *a
finding without file, place and verbatim quote is invalid output* — has always
been met inside the run workspace. The defect this ruling closes is one layer
past that: the evidence existed and **nobody could read it**. A markdown row
grammar is a good format for the walker that writes it and a poor one for the BA
who has to answer *what did we cover?* The workbook adds no claim the register
did not already carry; it changes who can check the claim. That is why no CC-S
family moves and why `assertions-s.md` stands byte-unchanged.

**Why the render precedes the append.** D-S4 ruled that an entry may not outrun
its own workspace. A report rendered *after* the entry would reopen exactly that
hole — the ledger asserting a closed run whose reader's copy does not exist —
and the fix is ordering, not a second condition. The two exports therefore join
the required set rather than getting a status of their own.

**Why `--report` appends nothing.** The ledger is append-only and one entry per
run. A re-render produces no new evidence and closes no new run; an entry for it
would be a claim that a second run happened, which is the same falsehood D-S4
forbids from the other direction.

**Why coverage % takes no half credit.** `partial` is an open obligation whose
missing part is named — it is work, not a fraction. Weighting it would put a
manufactured number on the framework's most authoritative-looking surface, and
this framework does not estimate numerically. The four counts render beside the
percentage so the reader can weigh it themselves; that arithmetic is the
reader's, never the export's.

**Deliberately not built here.** `sk_audit.py` — the M share of §4 — stays on
§10's pending list: the render derives from a register that already exists, and
a mechanical checker of the *walk* is a different act on different ground. A
**client-facing** derivative of the coverage report is likewise not ruled: this
workbook is operational state by construction, and a client render would need
§10.5's register and a ruling of its own.

**Deliberately not legislated here.** Whether a run may be closed with a
**stale** report — the workspace edited by hand after the render — is a
workspace-hygiene question adjacent to D-S2 and outside this ruling. The
register says *regenerated, never hand-edited* and `--report` is one command;
that is the answer in practice, not on the record. Named, not ruled.

## 14. Amendment record — the repair route becomes executable (v0.3 → v0.4)

Origin: the **field audit run of 2026-08-23** — Nutrivity, the first
`/ba-audit` run on the post-wave package — and the **BA ruling of 25 August
2026** (registration **EC-20**; base commit `3b028bd`, package 0.1.40). The run
report is **chat-only and is not in this repository**; it was not read. Only the
anchors dictated in the ruling were used, verbatim, and **no inferred mapping is
presented anywhere as a citation** — the EC-17, EC-18 and EC-19 precedent, held.

**What the field found.** Stage 4 **mandated** *"dispatch the `ba-analyst`
subagent per target spec"*, while the dispatch target's own definition read *"A
compile source, not a dispatch target … No skill dispatches it, and none
should."* **Both sides shipped on one commit**, and the contradiction is total:
the route's only path for a spec repair was an act another surface forbade. The
field session did the right thing twice — it refused the dispatch **and** refused
to author the edits itself — executed the five rows the upstream lanes could
carry unambiguously, and stood down with **14 of 19 ruled repair rows
unexecuted** and the run `INCOMPLETE`. **Nothing in the framework brought those
rows back**, which is the second defect and the more expensive one: a BA ruling
had been given, recorded, and then quietly stranded.

| ID | Decision | Ruling |
|---|---|---|
| **D-S7** | The route mandated a dispatch the target forbade | **The `ba-analyst` fence gains one named exception: `/ba-audit`'s post-ruling Stage-4 repair route**, draft-first and assumption posture exactly as Stage 4 already specifies. **The law of the exception lives here (§6); the persona's fence cites it and never restates it** (§10 unit 11). **Why the fence existed and still does:** the persona text **compiles into** the Tier-2 skill, and the persona's body binds it to that skill's context order, cap, legality rule and output contract — a bare dispatch is **an author working without a definition**. **Why this route is the exception:** the dispatch is **post-ruling**, so P-A1 has already fixed every input the Tier-2 definition would supply — target spec, verbatim quote, approved proposal, posture; **the definition arrives as the ruling**. **The bar that does not move:** *the audit authors nothing itself* (§11) — D-S7 changes who may be **dispatched**, never who may **write**. **Why the D-S1 class does not reopen:** that separation is the **evaluator's**, and this carve-out exists so the audit **need not** author — **silent self-substitution stays a defined violation of §4**, untouched. **Where the dispatch is undispatchable** (§4's third state) the row lands `unexecuted` with its `why` and **stops nothing else** — the remaining rows run, the re-audit runs, the report renders, and the entry appends with the run's true status |
| **D-S8** | A ruling was given, recorded, and stranded | **A row standing ruled and `unexecuted` in the most recent run that wrote a `repairs.json` re-enters the next run's Stage-4 route, ahead of that run's own rows, on the ruling it already carries.** **No re-ruling and no second P-A1 render** — that checkpoint rules the findings **this** run's A pass raised, and a resumed row is a **standing ruling, not a finding**. **No new flag, no new instrument, no new file:** `repairs.json` already records `unexecuted` with its `why` keyed by the row number, `decision-list.md` already holds the row **as ruled**, and both are §7 **required** files — **the resumption is a read**. **The trail is one key** — `from-run` on the resumed row in this run's `repairs.json`, absent on a row this run ruled. **A re-refusal resumes again** with its (possibly different) `why`; **no count of attempts closes a row** and a row does not expire — only execution, or a ruling. **Closure without execution is named:** where the obligation is no longer live in the post-repair register or a standing SA now covers it, the row closes `superseded — <reason>`; the read that brings a row back may not drop one quietly. **No new prompt point, no new stop, no new BA interaction** — §8's budget is arithmetically untouched |

**Why one exception and not a second agent.** The alternative on the record was
a **separate dispatch-target agent compiled from the same source** — a repair
persona the audit could call without touching the fence. It was **rejected on
duplication**: two files compiled from one source drift, and the day they
disagree the framework has two answers to *how does a spec edit land* with
nothing to say which governs. The fence's purpose is that an author never works
without a definition; a **named exception** serves that purpose exactly, and a
**copy** serves it only until someone edits one copy.

**Why not let the audit author the repairs itself.** The other alternative —
the audit authoring post-ruling repairs under the Tier-2 drafting law — was
**rejected on separation**. The audit is the surface that finds the defect and
renders the finding; making it also the surface that writes the fix collapses
finder and author into one actor, one stage after §4 spent an entire section
keeping finder and **judge** apart. The audit's *authors nothing itself* bar is
not an inconvenience the route has to route around; it is the same principle as
D-S1, at the repair grain.

**Why resumed rows run first.** A ruling the BA has already given outranks a
proposal they have not yet seen executed. The ordering is not a preference — it
is what keeps the stranding from re-occurring under load: a run that finds
twenty new rows must not push last run's ruled work behind them, because the
row that never reaches the front is the row that is stranded again.

**Deliberately not built here.** **The coverage report's rendering of a resumed
row.** §6b's `Findings & Rulings` sheet joins **this** run's decision list to
**this** run's `repairs.json`; a row resumed from an earlier run has its ruling
in **that** run's list and its outcome in this one, and how the sheet shows the
seam — a `from-run` column, a rendered join, or nothing at all — is a **render**
question adjacent to D-S6 and outside these two rulings. The `from-run` key is
ruled here so the trail exists on disk; **what a sheet does with it is not**.
Named and routed, not built. **`sk_audit.py`** stays on §10's pending list,
where v0.2 and v0.3 both left it.

**Deliberately not legislated here.** **How far back the resumption reads.** The
rule reads **the most recent run that wrote a `repairs.json`**, and it is one
run deep by construction: an unexecuted row that resumes and fails again is
re-recorded by the run that tried it, so the chain carries itself forward
without a scan of the whole band. Whether a **repair-history sweep** across all
prior runs should ever exist — after a long gap, or a band re-opened — is a
different act on different ground, and this ruling does not open it.

## 15. Amendment record — the report shows the movement (v0.4 → v0.5)

Origin: the **owner ruling of 30 August 2026** — `apply all` over a six-item
list raised on 29 Aug (*"enrich ba-audit with a beautiful stats report —
findings, fixes with a log, before/after, a ratio of defect vs total content
(acceptance criteria)"*). Ruled and applied the same day (base commit
`f7aeb94`, package 0.1.44). Three rulings; one is a **record**, one a
**definition**, one a **render**. Nothing about what the audit checks moves,
nothing about what it may rule moves, and nothing about which row resumes
moves.

| ID | Decision | Ruling |
|---|---|---|
| **D-S9** | The register was regenerated in place and the re-audit's delta was narrated, so the P-A1 state survived only as five numbers and no row's movement was on disk | **The delta is recorded.** `trace.json`'s Stage-2 blocks (`forward` · `backward` · `band`) are written once and **never rewritten**; the re-audit writes one block of its own, `re_audit` — the post-repair counts, the band's size counted again, and **every register row whose status moved** with the `repairs.json` row that moved it (`via`, `from-run` beside it where resumed), rows added as `before: none`, rows dropped as `after: none`, claims as counts only. **A run that reaches Stage 5 writes the block even when nothing moved.** The band's size — specs · stories · acceptance items · unreadable specs — is `sk_audit_report.py --band`'s block, **pasted verbatim, never typed**, at Stage 2 and at Stage 5. The entry's `Re-audit delta:` line derives from the block. No new file; the grammar is pinned in §7 |
| **D-S10** | Coverage % was the report's only ratio, and it measures the client's material, not the band | **Two ratios, each beside its components, never blended.** Coverage % stands exactly as D-S6 fixed it. **Defect density = (partial + gaps + ungrounded + contradictions) ÷ acceptance items × 100**, one decimal — the four states because they are exactly the states a finding is raised against (a contradicted deferral stands `gap` under §3), acceptance items because they are the unit the client reads and the engineer implements, counted by the gate's own parser and read from the recorded block, never re-counted from the estate. An empty cell at zero items; a sample note on the row where `band.unreadable` is non-empty. **No score weighs the two** |
| **D-S11** | A closed run's report showed its end state — not what the ruling fixed, not what moved since the last report, and no picture | **The reader sees the movement.** Two further pinned sheets appended after D-S6's four, which stand untouched — `Before & After` (`Previous closed run` · `At P-A1` · `After repairs` · both deltas · `Note`, over the pinned measure rows) and `Fix Log` (every `repairs.json` row across every run, newest first, joined by `#` to the decision list of the run that **ruled** it — the seam §14 routed, closed here; `Findings & Rulings` stays this run's alone). The previous closed run is `--report`'s own selection applied downward, refusals stepped past and named, the first closed run rendering `none`. **`exports/audit-stats.html`** — one self-contained file, six pinned sections, inline SVG, plain language leading and codes beside a gloss — **joins the required set** beside the workbook and the csv at D-S4's force; `--report` re-renders all three. **A five-line closing tail**, printed by the renderer and echoed verbatim, after the append and under `--report`, asking nothing. **Four surfaces, one number** on the after side, two on the before side, the html's figures the sheet's |

**Why the record came first.** Every figure the ruling asked for stood on disk
before it — the P-A1 head, the post-repair register, the ledger's count lines,
`repairs.json` — except two: **which row moved**, lost when the register was
regenerated in place, and **how big the band is**, counted by nobody. D-S9 adds
those two and nothing else, and it adds them to a file §7 already requires. A
render over a recorded delta derives; a render over a narrated one guesses, and
the whole of D-S2 is that the audit does not guess.

**Why three columns and not two.** *Before* is two different questions. The
P-A1 state against the post-repair state is *what did this ruling fix?*; the
previous closed run against this one is *what has moved since we last looked?*
— and the band drifts between runs (specs drafted, sources captured), so the
previous run's *after* is not this run's *before*. A two-column render would
have to pick one question and silently answer the other with the wrong number.
Three columns, two deltas, each named for the question it answers.

**Why a density and not a score.** The framework refused half credit for
`partial` (D-S6) because a weighting is a manufactured number on the most
authoritative-looking surface it produces. A quality score blending coverage
and density would be the same manufacture one level up. Two ratios, each with
its components beside it, is the most the record supports; the reader's
arithmetic beyond that is the reader's.

**Why the html joins the required set.** D-S6's argument for the two exports —
*an entry naming a file that may not exist is the D-S4 defect one artifact
along* — does not weaken for a third file the entry names. The html is rendered
in the same act, from the same derivation, by the same script; a render that
wrote the workbook and not the picture has half-happened, and a run does not
close on half a render.

**Why the sweep is not a resumption.** §14 declined to open *a repair-history
sweep across all prior runs* because the question there was **which row comes
back** — and one run deep is the right depth for that. The Fix Log asks a
different question — *what happened to every ruled row, ever?* — and reads
every file to answer it while resuming nothing. D-S8's rule is untouched in
letter and in force; what changes is only that the reader can now see the trail
it leaves.

**Why the tail is the renderer's.** The field defect of 2026-08-20 was a
session rendering numbers it remembered. A closing summary composed by the
session from the sheet it just wrote is one step short of the same defect, and
the step is not worth taking: the script that counted prints, the session
repeats. That is D-S2 applied to the last five lines the BA reads.

**Deliberately not built here.** **Charts, numbers, colours in the workbook** —
`sk_xlsx.py` stays a text-only writer, because `/ba-wbs`'s export is asserted
byte-identical through it and a hand-rolled chart part is a week of risk on the
wrong file; the picture is the html's. **A client-facing derivative** — still
not ruled, §13's reasons standing. **`sk_audit.py`** — still on §10's pending
list, where v0.2, v0.3 and v0.4 each left it.

**Deliberately not legislated here.** **A run-over-run trend across every
closed run** — one row per run, coverage and density down the ledger — is
derivable from the ledger and this ruling's blocks and is not rendered: the ask
was *before/after*, which is two runs, and a third column is not a trend.
Named, not ruled. **Whether a stale `band` block should refuse the render** — a
workspace whose specs moved after Stage 5 and before the append — is the same
workspace-hygiene question §13 named and left, one block along.

---

*v0.5 · the report shows the movement — the delta recorded: `trace.json`'s Stage-2 blocks written once and never rewritten, the re-audit adding one `re_audit` block of its own (post-repair counts, the band's size, every register row whose status moved with the `repairs.json` row that moved it, rows added and dropped named, claims as counts only, the block written even when nothing moved) and the band's size — specs · stories · acceptance items · unreadable specs — counted by the gate's own parser through `sk_audit_report.py --band` and pasted verbatim, never typed, the entry's `Re-audit delta:` line derived from it (D-S9) · the two ratios — coverage % exactly as D-S6 fixed it, and defect density = (partial + gaps + ungrounded + contradictions) per 100 acceptance items, one decimal, the four states because they are exactly the states a finding is raised against, acceptance items because they are the unit the client reads and the engineer implements, read from the recorded block and never re-counted from the estate, empty at zero items, a sample note at an unreadable spec, and no score blending the two (D-S10) · the reader sees the movement — two further pinned sheets after D-S6's four untouched: `Before & After` (previous closed run · at P-A1 · after repairs · both deltas · note, over the pinned measure rows, the previous closed run `--report`'s own selection applied downward with refusals stepped past and named) and `Fix Log` (every `repairs.json` row across every run, newest first, joined to the decision list of the run that ruled it — §14's routed seam closed, D-S8's resumption one run deep untouched); `exports/audit-stats.html` — one self-contained file, six pinned sections, inline SVG, plain language leading with codes beside a gloss — joining the required set at D-S4's force with `--report` re-rendering all three; a five-line closing tail printed by the renderer and echoed verbatim, after the append and under `--report`, asking nothing; four surfaces one number on the after side, two on the before side, the html's figures the sheet's (D-S11) (§6 · §6b · §7 · §8 · §10 · §11) — applied 30 Aug 2026 (D-S9 · D-S10 · D-S11, amendment record §15; base `f7aeb94`, package 0.1.44; origin: the owner ruling of 30 Aug 2026, `apply all` over the six-item list of 29 Aug) · *v0.4 · the repair route becomes executable — the `ba-analyst` fence gains one named exception, `/ba-audit`'s post-ruling Stage-4 repair route, draft-first and assumption posture as Stage 4 already specifies, the law of the exception living in §6 and the persona's fence citing it; the fence itself unweakened — a bare dispatch is an author working without a definition, and this route's definition arrives as the P-A1 ruling itself (target spec, verbatim quote, approved proposal, posture); the audit's *authors nothing itself* bar untouched — who may be dispatched moves, who may write does not — and the D-S1 evaluator separation untouched with silent self-substitution still a defined violation of §4; an undispatchable dispatch landing the row `unexecuted` with its `why` and stopping nothing else (D-S7) · the standing ruling carries — a row standing ruled and `unexecuted` in the most recent run that wrote a `repairs.json` re-entering the next run's Stage-4 route ahead of that run's own rows, no re-ruling and no second P-A1 render, the resumption a read over two files §7 already requires, the trail one `from-run` key, a re-refusal resuming again with no count of attempts closing a row, and closure without execution named `superseded — <reason>` and never silent; no new flag, no new instrument, no new file, no new prompt point, no new stop and no new BA interaction — §8's budget arithmetically untouched (D-S8) (§6 · §7 · §10 · §11) — applied 25 Aug 2026 (D-S7 · D-S8, amendment record §14; base `3b028bd`, package 0.1.40; origin: the field audit run of 2026-08-23, Nutrivity — the first `/ba-audit` run on the post-wave package; BA ruling 25 Aug 2026, registration EC-20) · *v0.3 · the coverage report — a run is not closed until it renders `exports/audit-report.xlsx` and `exports/audit-report.csv` from the closed run's post-repair state, the render standing after the re-audit delta and before the entry appends and both files joining §7's required set at D-S4's force; four pinned sheets — Coverage Matrix one row per post-repair OB row with its verbatim quote, Per-Source Summary with the four status counts and coverage %, Findings & Rulings as ruled with each row's outcome, SA Register standing; the csv the Coverage Matrix alone and canonical; `/ba-wbs`'s render conventions over the `sk_xlsx.py` helpers and §10.5's stakeholder register expressly not carried — operational state, the audit's evidence bar governing the cells, quotes verbatim and codes as themselves; D-S2 extended from the head to the workbook, every number counted from the post-repair state and an absent field an empty cell, the matrix's rows, the TOTAL row and the entry's `Register:` line one figure counted three ways; coverage % = (carried + accepted) ÷ obligations with no half credit for `partial` and an empty cell at zero obligations; a sampled corpus rendered twice (D-S3); `--report` re-rendering from the latest closed run with no audit, no append and no checkpoint, refusing by naming what is missing (§6b · §6 · §7 · §10 · §11) — applied 23 Aug 2026 (D-S6, amendment record §13; base `3b028bd`, package 0.1.39; origin: the owner ruling of 23 Aug 2026) · *v0.2 · audit integrity — the register stops lying about its own coverage: the undispatchable state named beside mechanical death, its Stage-0 refusal with the named unblocking act and the BA-electable self-evaluated mode whose verdicts are stamped and whose run stands `INCOMPLETE`, silence no legal path and the substitution absent the election a defined violation (§4 · §11) · the five P-A1 header numbers derived from the register's rows by status at render time, `c + p + a + g = t`, a head disagreeing with the on-disk rows invalid audit output (§5) · per-source coverage accounting in the register head and the corpus-declaration rule applied at both of this document's retrievals — the Stage-1 walk and the band-wide search set naming the corpus they must cover, the run stating the corpus it covered, a sample never grounding a `gap` (§2 · §3 · §5) · `decision-list.md` an explicit Stage-3 write act on a clean run too, §7's required set, and the Stage-5 entry refusing to append over a missing required file (§5 · §6 · §7) · CC-S-04's finding grain untouched and carrying through the list across distinct dispositions, one enumerated `amend` row governing a shared disposition with its enumeration count equal to the unmapped-row count it absorbs (§5) — applied 21 Aug 2026 (D-S1…D-S5, amendment record §12; base `3f0f59d`, package 0.1.33; origin: the field defect report of 2026-08-20, Part A evidence A1–A5 · A7; BA ruling "apply all recommendations", 21 Aug 2026) · v0.1 · drafted 16 Aug 2026 from the Nutrivity band evaluation of 14 Aug 2026 · Scope S — source fidelity, band-level, one BA checkpoint at P-A1 · complementary to the completeness gate and changing no verdict it owns · reaches framework law by reference, never by restatement (orchestrator D-O81 · D-O98 · §10.3 rule 9) · decisions D-S1–D-S11 locked · amendment records: v0.1→v0.2 in §12 · v0.2→v0.3 in §13 · v0.3→v0.4 in §14 · v0.4→v0.5 in §15 · compiles to the units in §10 and never the reverse*
