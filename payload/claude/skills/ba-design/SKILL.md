---
name: ba-design
description: Render the design guide - everything the client's captured material states about visual identity - to exports/design-guide.md. Extraction only, every entry cited verbatim; where the client provided none, the pinned none-record renders so silence is impossible. Read-only, in the /ba-wbs family: it reads the ledger head's cross-cutting register and the captured sources, and writes nothing but the one export file.
disable-model-invocation: true
---

# `/ba-design` — the design-guide export

**Argument:** none.

The **design guide** — everything the client's material states about **visual
identity**, rendered for handoff to whoever designs. A read-only render command
in the `/ba-wbs` family, and it takes that command's read discipline verbatim:
it reads, never writes the estate, never transitions, never proposes content.

This is **not a technique**. It makes no BA decision, lands nothing in the
estate, and carries no checkpoint: the BA's invocation is the whole act.

## Invocation contract

- **Read-only.** The sources below are opened for reading. The only file this
  skill creates is `exports/design-guide.md`. It never edits a spec, a brief, a
  report, the roadmap or a ledger.
- **Stage-neutral.** Invocable at any time, like `/ba-status` and `/ba-wbs`. No
  gate interaction, no `/speckit-*` call, no implementation content.
- **Derived, never hand-edited.** A hand edit dies at the next run: the file is
  regenerated on demand at a stable path, overwritten per run.
- **Extraction only, never interpretation.** Every entry is what the material
  states, carried in the client's own words and cited. A palette the material
  does not name is not this file's to choose — and naming one would be
  authoring, which this skill never does.

## The read set — all read-only

| Source | Read for |
|---|---|
| `.specify/aspect-state.md` | the ledger head's **`Cross-cutting:`** line — the `branding` `XO-<n>` entry with its verbatim citation: the render's anchor (D-O72 · D-O76) |
| `sources/` | the captured source artifacts the Frame act's inventory landed — the citation ground for every entry; a binary capture is read through its sibling `sources/<name>.extracted.md` rendering |
| `canvas.md` | §13 Context/Constraints, where the scope-frame mirror carried the register's cited detail |
| `.specify/memory/design-standards.md` | where **T-14 — Design & UX standards** has run and left stated design ground |

No new artifact, no new BA step, no new field anywhere.

## What it renders

`exports/design-guide.md`, carrying everything the captured material **states**
about visual identity:

- **palette values** — the colours the material names, in the notation it uses;
- **referenced visual assets** — logos, mockups, style guides, brand files, each
  with **where it lives**;
- **stated brand and design constraints** — typography, tone, layout rules,
  accessibility of the visual surface where the material states it.

**Every entry cites verbatim.** Cite-or-mark governs exactly as it governs a
mined line: the citation names the captured source artifact, never a live
channel. A `branding` `XO-<n>` entry standing on the head is the render's
anchor — **the entry's citation is the guide's first line of ground.**

An **excluded** artifact is never read here either: the exclusion law holds at
every reader, and a reference to one inside a capture is never followed.

## The none-record — silence is impossible

Where the captured material states nothing, **the file still renders**, carrying
this record exactly:

```
Design guide — <project> · generated <date>
Client provided none — no palette, visual reference or brand constraint stands
in <k> captured source(s). (branding: no XO entry | XO-<n> accepted — <reason>)
```

An empty design estate is **a fact the client can be asked about, never an
absence nobody can see** — the `none stated` family, applied to design ground.
A run that wrote no file at all would be indistinguishable from a run nobody
made.

## Boundaries

- **Production only.** **The consumption format — how a designer agent reads
  this file — is out of scope by ruling** and lives nowhere in this corpus.
  This skill produces the guide; it says nothing about who reads it or how.
- **No gate interaction, no estate write, no new prompt point.** The session
  boundary stands untouched.
- **Stable path, overwritten per run** — `exports/design-guide.md`, beside the
  WBS export's own two files.

## The register — entry text is stakeholder-facing

Entry text is stakeholder-facing. Plain sentences. **No CC-IDs, no marker
brackets, no `XO` codes in the prose** — the register ID belongs to the
provenance line, where it is provenance and not vocabulary.

## What this skill never does

Never writes a spec, a brief, a gate report, the roadmap or a ledger · never
edits the `Cross-cutting:` register it reads · never runs or invokes the gate ·
never interprets a capture — extraction is the whole act · never invents a
palette value, an asset or a constraint the material does not state · never
reads or follows an artifact standing `excluded — <reason>` · never omits the
file when the material is silent — the none-record is the render · never
changes a state, a profile or a stage — rendering is its whole act.

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report and the resumption report are the
only BA-facing renders of an auto cycle (`/ba-auto`).

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
