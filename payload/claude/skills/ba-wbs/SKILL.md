---
name: ba-wbs
description: Render the client-facing work breakdown structure - one row per User Story, grouped by epic in roadmap order, with the parent brief's deferred items as their own later-phase rows - to exports/wbs.xlsx and exports/wbs.csv, then print the generation summary. Read-only: it reads the specs, their gate reports, the parent briefs and the roadmap, and writes nothing but the two export files.
disable-model-invocation: true
---

# `/ba-wbs [--include NNN …]` — the WBS export

**Argument:** none, or one or more `--include NNN` — each admits one
uncertified feature by number.

The client-facing **WBS — work breakdown structure** — spreadsheet, generated
from what the framework already produces. Two precedents joined: the ledger
render's read discipline (`/ba-status` — reads, never writes the estate, never
transitions, never proposes content) and the gate's derived-file precedent
(`traceability.md` — generated, never hand-authored).

This is **not a technique**. It makes no BA decision, lands nothing in the
estate, and carries no checkpoint: the BA's invocation is the whole act.

## Invocation contract

- **Read-only.** The four sources below are opened for reading. The only files
  this skill creates are the two exports. It never edits a spec, a brief, a
  report or the roadmap.
- **Stage-neutral.** Invocable at any time, like `/ba-status`. No gate
  interaction, no `/speckit-*` call, no implementation content.
- **One generator, both profiles.** A Presale draft spec is an ordinary
  `spec.md` before its effective PASS — same parser, same renderer. The
  profiles differ only in the selection defaults.
- **Derived, never hand-edited.** A hand edit to `exports/wbs.xlsx` dies at the
  next run, and an estimate column added by hand dies with it: the render has
  no such column to re-emit. Numbers live in the client's copy of the file.

## The read set — all read-only

| Source | Read for |
|---|---|
| `specs/NNN-*/spec.md` | §2 stories and their acceptance · §3 requirements and their `(US<n>)` links · §4 flows (role names) · §6 Business Rules · §8 Integration table · §10 References (the parent brief, the roles) |
| `specs/NNN-*/gate-report.md` | the latest run entry: verdict · waivers in force · the certification line |
| `.specify/memory/scope/<E-nn>.md` | the epic name from the header · §3 `Deferred — this epic, later` items |
| `.specify/memory/roadmap.md` | Phase · epic row order |
| `.specify/aspect-state.md` | the ledger head's **profile** — the selection-default source · **`Client label:`** and **`Boundary:`** — the title block's and the Billable column's ground (D-O67) · **`Cross-cutting:`** — the third title-block line's and the generation summary's naming ground (D-O75) |

No new artifact, no new BA step, no new field anywhere.

## Selection

One output row per User Story; rows grouped by epic in roadmap row order.

- **Discovery default** — features whose latest gate-report entry carries a
  certification manifest. An uncertified feature enters only by explicit
  per-feature instruction: `--include NNN`.
- **Presale default** — every drafted feature.

**Nothing is silently dropped or silently included.** The generation summary
names every `specs/NNN-*` folder with its disposition and its open-marker
counts. **No numeric threshold exists** — counts render, the BA judges.

**The summary also names every `Cross-cutting:` register entry not in a
terminal state (D-O75).** `carried` · `accepted` · `default` are terminal; a
`captured` entry renders by ID with its class and value. Counts render, the BA
judges, and **the export never blocks**: this command stays read-only and
invocable at any time, and an obligation leaving Frame uncarried is a named
fact on the summary, never a silent drop.

**And the roadmap dimension — *nothing silently dropped*, applied to the
quoted scope.** The summary additionally names **every in-boundary roadmap
epic that contributed zero rows** — the head's `Boundary:` set against the
rendered rows, the Billable test's own set — each by name with its phase, its
Billable value and **the first missing link the read set already sees**: `no
brief` · `brief — no confirmed slicing` · `no spec folder` · `spec — no
stories`. One closing sentence follows: *the WBS understates the quoted scope
until they are briefed and specced.* The field case is the argument — a
summary that named every `specs/NNN-*` folder held *nothing silently dropped*
on the specs dimension while two in-boundary epics had **no folder to name**.
Counts render, the BA judges: **no numeric threshold and no block**, and the
read set is unchanged. The epics with no brief are the same set CC-H-08 rules
on and the same one `/ba-status` line 2, the band-boundary report's `Scope
coverage:` line and `/ba-run specs`' confirmation table show — one
computation, four display sites; the summary adds only the downstream links a
briefed-but-unrendered epic fails at.

Void detection is never re-run here: it stays lazy, and it is the gate's.
"Certified" means the report's last entry says so, with the run date shown.

## Running it

```bash
python3 .specify/ba/scripts/sk_wbs.py --root .
python3 .specify/ba/scripts/sk_wbs.py --root . --include 005
```

The profile is read from the ledger head, never asked. `--profile` overrides it
for a headless run; `--summary-only` prints the summary and writes nothing.

## The pinned columns

Nine, ending at Billable.

| Column | Source | Rule |
|---|---|---|
| **Epic** | the brief header / the roadmap Epic column | name only, never the `E-nn` code |
| **Topic** | the story's "I want" capability clause | condensed to a short action phrase; a transformation of present text, never a stored field |
| **User Story** | §2, the full sentence | verbatim; the `US<n> (P<1\|2\|3>)` prefix dropped |
| **Acceptance Criteria** | the story's linked requirements restated as plain sentences · the acceptance items under the story · the Business Rules those requirements or that acceptance reference, folded as their own items | one numbered list per row |
| **Integrations** | §8, this spec's own table | system names only; uniform across the feature's rows |
| **Comments / Questions** | `[NEEDS CLARIFICATION]` marker text, brackets stripped · the waiver reason with its `W-<NNN>-<nn>` tag and date | **nothing else** — the draft gate run's FAIL report stays out; it is the client Q&A agenda, a separate artifact |
| **Role** | the story's actor first · then any role named in the story's linked requirements, its flows, or a Business Rule folded into that row's acceptance | comma-separated |
| **Phase** | the roadmap epic's Phase, on every story row under the epic · a deferred row carries its item's target phase | — |
| **Billable** | derived — the row's Phase (a deferred row: its target phase) tested against the ledger head's `Boundary:` set | `Yes` inside the boundary · `No` outside · **blank where the Phase cell is blank**, and **blank where no boundary stands in the frame** — an absent source renders an empty cell, never a guess, and never a default `Yes` or `No` |

**No estimate column exists.** The set ends at Billable. Estimating is the
client's act, outside the export: the framework never estimates numerically
(the depth rule of T-18 — Scope allocation), and it renders no column
inviting a number it refuses to produce. **Where no boundary stands in the frame
the Billable cell renders blank** — the export's own never-invents clause,
stated at the rule it governs: the test has no ground, so the column has no
value, and a default `Yes` or `No` would be the export answering a question the
frame has not. **Billable is a derived `Yes`/`No`,
never a number** — the never-numeric guarantee is untouched, held by structure.

## Deferred rows

Each parent brief's §3 `Deferred — this epic, later` item renders as **its own
row**: Epic filled, Topic = the item, Phase = the item's target phase,
Comments / Questions = the launch-substitute note. User Story, Acceptance
Criteria, Integrations and Role stay empty. **Billable derives by the same rule
as any row** — its target phase tested against the boundary; **where the target
phase is absent the Billable cell renders blank**, the Comments cell already
carrying the launch-substitute note that says why the row exists (D-O67).

This is the read-only restoration of within-epic phase spread. Certified specs
carry no deferred scope by contract, so these rows are the spread's sole
carrier.

## The register — cell text is stakeholder-facing

Cell text — **and the xlsx title block (D-O67)** — is stakeholder-facing.
Plain sentences. **No EARS keywords in caps, no CC-IDs, no marker brackets.**
Two deliberate exceptions: the waiver tag as provenance in Comments /
Questions, and quoted status values inside acceptance text.

A requirement is restated by bringing the caps down — the words stay, the
shouting goes. Rewriting the verb would be authoring, and this skill never
authors. **Never invents:** an absent source renders an empty cell, never a
guess.

The generation summary is BA-facing and follows the communication register.

**The export is never passed through the humanizer separately** (§10.3 rule 10,
D-O97). It reads `spec.md`, which was humanized when it was written, and this
render stays a pure render of what it read. Passing it again would rewrite cells
that are transformations of text already rewritten — and the title block, the
column row and the `Yes`/`No` derivation are pinned besides.

## Formats & paths

One build, both renders, one row model:

- `exports/wbs.xlsx` — the primary, client-presentable render: the three-line
  title block above the bold header row, wrapped text, column widths, **no cell
  merges** — the Epic value repeats per row.
- `exports/wbs.csv` — the canonical, diff-friendly render.

Stable paths, overwritten per run.

### The title block — the xlsx render only (D-O67 · D-O75 · D-O77)

Three lines above the bold header row — D-O67's two, and D-O75's third:

```
<Client label> — <project>
Delivery boundary: <ladder value(s)> — billable phases: <list> · generated <date>
Cross-cutting: <class>: <value> (XO-<n>) · … | none stated
```

The label is **verbatim, the client's own word** (PoC · prototype · pilot…),
read from the ledger head; where the label stands `open — no source material`
the line renders **the project name alone — the export never invents**.

**Where no delivery boundary stands in the frame the second line renders
`Delivery boundary: none stated · generated <date>` — never an empty value**
(D-O77): the export's own never-invents clause stated at the line it governs,
beside the Billable column's own blank-where-no-boundary rule.

The third line renders **every non-`default` register entry**, and
**`none stated`** where only the English default stands. **The language default
itself never renders here** — an engagement default is framework law, not a
client fact, and the export states client ground only: the label's own `open`
logic, applied.

**The csv carries no title block:** it is the canonical, diff-friendly render,
and lines above the column row break its shape. The per-row fact both renders
share is the Billable column. **Budget never enters the header.**

## Under Presale

Comments / Questions is where the assumption record surfaces: every deferred
question stands as its marker beside its marked recommended value, and the
column renders that standing record to the client. The FAIL report of a draft
gate run stays out of the file — it is the client Q&A agenda, and it is a
separate artifact.

## What this skill never does

Never writes a spec, a brief, a gate report or the roadmap · never runs or
invokes the gate · never re-runs void detection · never renders an estimate
column — estimating is the client's act, outside the export · never invents a
cell where the source is silent · never renders the language engagement default
into the title block — the export states client ground only · never blocks on an
uncarried cross-cutting obligation: it names it on the summary · never renders a CC-ID, an EARS keyword in caps, or a
marker bracket into a client-facing cell · never carries the FAIL report's
named-gap lines into Comments / Questions · never changes a state, a profile or
a stage — rendering is its whole act.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report, the mid-grant stop report and
the resumption report are the only BA-facing renders of an auto cycle
(`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**,
by the effective PASS at `/ba-gate <feature>` alone; the certified-text check
runs by itself when implementation takes the feature and is never a lift
condition. Wanting to implement is never evidence of readiness:
the only exit is the gate.
