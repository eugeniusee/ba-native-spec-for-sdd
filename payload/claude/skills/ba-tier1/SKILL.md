---
name: ba-tier1
description: Tier 1, the epic scoping interview. Three argument-selected modes - kit generates the pre-drafted brief baseline plus destination-tagged questions for one epic's scoping call; ingest turns the call's notes into the finished scope brief with its routed batch; supplement runs the same loop at small radius for named gaps only. The BA runs the call; this skill is before and after, never in the room.
disable-model-invocation: true
---

# `/ba-tier1 <mode> <epic>` — the epic scoping interview

**Serves:** the Band-2 act, per epic. **Class:** Context ·
**Destination:** `.specify/memory/scope/<epic>.md` ·
kit: `.specify/memory/scope/<epic>.kit.md`.

Tier 1 carries **a one-line epic to a scoped brief**. Three modes, one technique:

| Mode | Invocation | What it does |
|---|---|---|
| **kit** | `/ba-tier1 kit E-03` | pre-drafts the brief from everything known and emits the call kit — the questions that would complete it |
| **ingest** | `/ba-tier1 ingest E-03` | turns the call's notes or transcript into the finished brief, plus the routed batch and the signals |
| **supplement** | `/ba-tier1 supplement E-03` | the same loop at small radius: a mini-kit for **named gaps only**, ingested as an append |

**The BA runs the call.** The framework's role is *before* and *after*. There is
no live copilot, no transcription analysis, nothing in the room. The BA works
from the composed agenda, exercises full judgment — including deliberately
crossing the depth line when the moment justifies it — and brings back notes.

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-tier1 <mode> <epic>` is the one-step
entry: typing it **is** the BA's invocation act — P-O3, technique invocation.
No prior command is required; none is requested.

Self-check, and stop if it fails:

> the run is **on the composed plan** recorded under the plans file's
> `## Band 2` section, **with its output contract pinned**:
> `{the epic's scope brief at the nine-section shape, the call kit beside it, and a routed-findings batch · Context · .specify/memory/scope/<epic>.md}`.

**Per-mode preconditions:**

- **kit** — the epic exists as a roadmap row **at the complete shape**: name,
  2–3-sentence description, **and a phase**. A row still reading `Unallocated` is
  a row whose allocation has not happened; say so and name `/ba-t18`. The kit
  leans on sibling phases, and it cannot lean on a blank.
- **ingest** — the kit exists at `<epic>.kit.md`, and the BA supplies the notes
  or transcript. Without the kit there is no parsing frame: the kit's question
  IDs and its pre-draft *are* the frame.
- **supplement** — a brief exists and **the gaps are named** — normally by a
  Tier-2 overflow signal. A supplement with no named gap list is a second full
  call wearing a smaller name; refuse it and ask which gaps.

**Under a standing autonomy grant, the run elects this technique itself.** The
grant reaches every act that **spends no client access and makes no external
commitment**, so `kit` and `ingest` over **captured client material** are
self-elected and stamped `AUTO (AG-<n>)`, standing for ratification at `off`.
Under Presale with no client call available, that election fires at **Band-2
exit for every epic allocated to the first phase** — kit then brief, per epic.
**The call itself is never elected here:** a live client session is client
access and stays the BA's act, so the framework writes the kit and **books
nobody's time**. The notes input in that case is the captured material at
`sources/` — RFP, client documents, transcripts on hand — never an invention,
and never a session the framework arranged.

**On a pass** — render one line:
`Tier 1 <mode> — <epic> → <mode's destination>`, and begin. No confirmation
dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-aspect band2` to compose the Band-2 plan. Nothing else runs;
nothing else is explained.
The stop closes per §10.3 rule 9 — `What I need from you:` with the repairing
act as the `(recommended)` option.

## The two guards — both are tests, and both are falsifiable

**Guard 1 — never ask what is already answered. The Citation Test:**

> Before emitting a question, attempt to answer it from the answered-source set.
> **If you can cite a source line, the question is illegal — cite the line in the
> draft instead.** If you cannot cite, you may ask.

*Derivable* is bounded at **citable**: a directly stated fact, or a one-step
consequence of one. (The glossary defines slot duration as the service duration
⇒ never ask slot length.) Multi-step speculative inference does not count as
answered — that is inference, and inference is draft-and-mark territory.

The test is falsifiable from outside, which is what makes it a test: **a BA who
sees a question whose answer exists falsifies it by producing the source line.**
Every falsification is a false-ask — log it to
`.specify/elicitation-tuning.md` with the source line.

**Tier-1 answered-sources:** `canvas.md` · `glossary.md` · `stakeholders.md` ·
`context.md` · `constraints.md` · `domain-model.md` · `processes.md` ·
`out-of-scope.md` · `roadmap.md` · **sibling epics' scope briefs** · this epic's
own prior brief content.

**Guard 2 — never ask what is not yet needed. The Destination Test** — at
Tier 1, Guard 2 *is* the depth-calibration rule:

> A question is a **legal scoping question** if and only if its expected
> answer's primary destination is a **scope-brief decision section** — Essential
> Scope · Boundaries · Proposed Feature Slicing (rationale) · Assumptions &
> Risks · External Systems — or a Band-2 decision (allocation). If the only home
> the answer could have is a **spec.md section** (an FR, an acceptance criterion,
> a flow step, an error row, a data field, a business-rule threshold, an NFR
> target), the question is at **final-spec depth and forbidden in the kit**.

The intuition: **scoping decides *whether and where* something is built — in
this epic or another, this phase or later, this feature slice or that, at
acceptable risk or not. Spec decides *exactly how it behaves*.** A question whose
answer cannot change a whether/where decision has no business in a scoping call.

The five worked good/bad pairs — the same topic at two depths, because the line
is depth and not subject — are in `references/destination-test.md`. **Read them
before generating a question set.**

**Volunteered ≠ solicited.** The rule constrains what the kit *asks*, never what
the call *captures*. Stakeholders volunteer spec-depth detail and the BA never
interrupts value: it is ingested into the brief's **Captured Detail**, preserved
and sourced, available to Tier 2 as an answered-source. The kit never solicits
it, and ingestion never spawns follow-up spec-depth questions from it.

**Everything you generate is advisory.** The BA drops, reorders, adds, rewrites;
recommended answers are rejectable; caps are adjustable. These rules constrain
**the framework's generation**, never the BA's conduct in the room.

---

## Mode: kit

### Inputs loaded

The epic's roadmap row first — it is the unit being scoped — then the estate:

1. `.specify/memory/roadmap.md` — **this epic's row at the locked shape**, plus
   the **sibling rows** (their names and phases are what part D checks against)
2. `canvas.md`
3. `.specify/memory/glossary.md` · `stakeholders.md`
4. `.specify/memory/context.md` · `constraints.md`
5. `.specify/memory/domain-model.md` · `processes.md`
6. `.specify/memory/out-of-scope.md`
7. **sibling epics' scope briefs** where they exist

### The generation mechanism — one mechanism, and it is the whole discipline

**Pre-draft the scope brief from these inputs.** Every line you can support gets
written **with its citation**; every hole becomes a candidate question.

The kit is therefore **not a freestanding questionnaire — it is a draft brief
plus the questions that would complete it.** This single mechanism enforces the
destination rule mechanically: a question exists only because a specific brief
section has a specific hole.

### The kit — four parts

**A. Pre-drafted brief baseline.** The brief template with every derivable line
filled and cited (`[canvas: Problems P-1]`, `[constraints.md §2]`…). This doubles
as **the do-not-ask register**: everything cited here is off-limits to the
question set, and visible to the BA as the baseline the stakeholder need not
repeat.

**B. Question set.** Per hole:

```
Q<n> [destination: <brief section>] [must-ask | if-time]
  <question, in stakeholder language>
  Why it matters: <one line — what decision the answer changes>
```

- **Every question carries a destination tag** naming a brief section. **A
  question you cannot tag must not be emitted** — that is the Destination Test
  executed at generation time rather than reviewed after it.
- **Ranked:** `must-ask` — the call fails its purpose without the answer — vs.
  `if-time`. **must-ask ≤ 12.** A scoping call is 30–60 minutes; twelve answered
  decisions beat twenty rushed ones. If-time questions overflow without limit;
  the BA composes the final agenda.
- **Stakeholder-facing language** — no framework jargon, no EARS, no artifact
  names, no criterion IDs. The person answering has never read this framework.

**C. Risks & assumptions to check.** Assumptions the context *implies* but no
stakeholder has confirmed, each phrased as a checkable statement:

```
A<n> — <assumption> · source: <where the context implies it> ·
       impact if wrong: <which Band-2 decision changes>
```

Plus risk probes — where this epic's domain typically hides scope: payment
edges, permission edges, integration failure ownership, data migration.

**D. Sibling boundary checks.** Where this epic's edges touch other roadmap
epics or existing briefs, one check per touchpoint: *"the roadmap holds X in
epic Y — confirm nothing X-shaped belongs here."* These feed the brief's
Boundaries section and prevent silent scope overlap. **This is where a T-17 —
Epics decomposition open edge lands** — an adjacency carried honestly in a
description becomes a check asked in the right room.

### Output

`.specify/memory/scope/<epic>.kit.md` — the four parts in order, then the
**Composed agenda** section left for the BA. The kit is kept, not discarded: it
is the audit trail, the do-not-ask evidence, and the tuning input.

The installed template is `.specify/ba/templates/call-kit-template.md`; a worked
kit is in `references/example.md`.

---

## Mode: ingest

### Inputs

The raw notes and/or transcript the BA supplies, **plus the kit** — the kit's
question IDs and pre-draft are the parsing frame. **Where no call happened**, the
input is the **captured client material** at `sources/` — RFP, client documents,
transcripts on hand — read exactly as call notes are read: it answers what it
answers, and every remaining kit question becomes an Open Question. The six
steps below do not change with the input.

### Process — six steps, in order

1. **Map answers to kit questions.** Each kit question resolves to exactly one
   of three states: **answered** (extract → write to its destination section) ·
   **partially answered** (write what was given; the remainder → Open Questions)
   · **unanswered** (→ Open Questions, status `Open`).

2. **Classify unsolicited findings.** Everything said outside the kit's frame is
   classified: **scoping-level** → the matching brief section · **spec-depth** →
   Captured Detail · **cross-cutting** → the routing batch.

3. **Route cross-cutting findings.** A finding that belongs to a governance or
   context artifact, not the brief, is assembled as a **proposed edit** —
   finding · destination · edit text. The seven destinations are in
   `references/routing.md`. **The BA approves the batch**; on approval the
   framework writes, and the armed scoped health check fires silently.

   The approval stop closes per §10.3 rule 9 — one plain lettered question:
   `a. approve the batch as listed (recommended) — every edit is cited` ·
   `b. approve all except — give the numbers` · `c. hold the batch`.

   **A new role or permission implication is a governance change: proposed,
   never silently written.**

4. **Contradiction check.** A call statement that *contradicts* an existing
   context artifact is **never silently reconciled**: it becomes a conflict
   finding — proposed edit, plus a **reopen signal** if the artifact belongs to a
   gated aspect. Emit it; `/ba-reopen` rules and executes.

5. **Ambiguity rule.** An unclear or hedged statement becomes an **Open
   Question, never a silent interpretation.** Cited, marked-as-open, or answered
   — there is no fourth option.

6. **Assemble and finalize.** Open Questions consolidated — unanswered kit
   questions plus the new questions the call raised, each tagged with what it
   touches, each carrying an **`OQ-<n>` ID numbered per brief** (D12,
   elicitation engine §4 — the sequence restarts in every brief; epic context
   rides beside the ID, never inside it). Brief status → `Scoped`. Kit archived
   beside it.

### Provenance discipline — deliberately light

Lines sourced from the call carry **no per-line tag** — the brief's call log
covers them. Lines **pre-known from context keep their kit-baseline citations**.
Only **§5 Assumptions & Risks and §6 Open-Question answers** always carry
per-line sources, because they are the lines someone will later interrogate.

### Open questions after the call

Unanswered questions **do not block the brief. They stay in it, visibly, with
status.** The reckoning comes at the right moment — at spec time, every open
question touching the feature must be resolved in the spec or converted to a
marker and carried as a waiver the BA signs personally. Nothing silently expires.

**Status vocabulary — exactly three values:**

| Status | Form |
|---|---|
| `Open` | — |
| `Answered` | `Answered — <date> → <where the answer now lives>` |
| `Overtaken` | `Overtaken — <reason>` |

**The reason on an Overtaken row is mandatory** — it makes the line an audit
record rather than a deletion.

### Output

`.specify/memory/scope/<epic>.md` — **nine sections, exact headings, exact
order.** Checkers and Tier 2 parse this structure; the order is not style.

```
1. Value Anchor   2. Essential Scope   3. Boundaries   4. External Systems
5. Assumptions & Risks   6. Open Questions   7. Captured Detail (for Tier 2)
8. Proposed Feature Slicing   9. Routing Log
```

The installed template is `.specify/ba/templates/scope-brief-template.md`; a
worked brief is in `references/example.md`.

Two sections carry vocabularies rather than free text:

- **§8 Status** — `Proposed`, or `Confirmed — <date>` once Band-3 entry confirms
  the slice. **You write `Proposed`.** The confirmation is the act of P-O8 —
  Band-3 entry, performed at `/ba-enter-feature`.
- **§3** carries both sub-headings — `### Excluded — not this epic` and
  `### Deferred — this epic, later` — and every item names where it lives
  instead, or its target phase and what substitutes at launch.

**§2 is capabilities, not stories.** Verb + object + a one-line intent. A line
that reads *"As a Client, I want…"* is Tier 2's work done two bands early and
with no acceptance to check it.

### The pass-binding consequence — state it once, at write time

The brief is a **checked dependency of every feature spec in its epic.** Any
brief edit — including a Tier-2 write-back to §6 statuses — **voids existing
PASSes of sibling features not yet handed off**, forcing a cheap re-gate.

**Batch brief edits; do not drip them.** Say this out loud when writing a brief
whose epic already has a certified sibling.

---

## Mode: supplement

The scoped mini-loop for a brief that proved too thin — normally arriving as a
Tier-2 overflow signal, with the blockers already named.

**Same rules, smaller radius:**

1. Generate a **mini-kit for the named gaps only.** Every question still carries
   its destination tag and still passes both guards. A question outside the named
   gap list does not belong to this run — it belongs to the next full call, or to
   nothing.
2. The BA resolves them — a short call, or an async exchange.
3. **Ingestion appends to the brief.** The existing content is not rewritten; the
   §6 rows the supplement answered flip to `Answered — <date> → <destination>`,
   and new findings route as always.

The supplement is what keeps the tiers honest: **Tier 2 fills gaps; it does not
re-run discovery**, and the correct response to too many blocking questions is a
better brief, never a longer interrogation.

---

## Signals

| Signal | When | Payload |
|---|---|---|
| **Routing** | a finding belongs to a governance/context artifact | finding · destination · proposed edit — as a batch **the BA approves before anything is written** |
| **Reopen** | a finding *contradicts* content of a gated aspect | finding · contradicted artifact + line · conflict statement |

You emit; you never execute. `/ba-reopen` rules and runs the reopen; the routing
batch is written only after the BA approves it.

## At run end — compiled bookkeeping

1. **The primary output lands** at its contracted destination — this run's own
   act under its pinned contract, **and in this skill's own pinned output
   shape**: the heading literals and ID grammars pinned above. A shape
   divergence is a **contract miss** (orchestrator §6.3) — stop and report the
   shape expected against the line as written; never record `fulfilled`, and
   never downgrade to `partial`.
   The stop closes per §10.3 rule 9 — `What I need from you:` with the
   repairing act as the `(recommended)` option.
2. **Cross-cutting findings route** as one proposed batch: the framework
   assembles the edits · the BA approves the batch · the framework writes. In
   Band 1 proper Scope H is disarmed and nothing fires; post-closure runs get
   the armed cadence automatically.
3. **Run log** — append under `## Band 2` in `.specify/aspect-plans.md`,
   each rerun naming its trigger. **This run is per epic, so the line names its
   epic** — one line per mode per epic, never one line for the technique:
   `<date> · <CODE> <mode> <E-nn> · contract: fulfilled | partial — <what is missing> | failed — <why>`
   `  signals: RO-<n> received | routing batch <ref> approved | none`
   Then set the plan row's Status to `run <date>`. `partial` and `failed` are
   recorded, never silently retried.

   Every record names its element and its action. A run log that says only
   which technique ran cannot say **how much of the estate it reached** — and
   `/ba-status`'s ledger-coverage line reads exactly that, epic by epic.
   **Append forward only:** a run that was never logged stays unlogged; the
   line records this run, and history is never reconstructed after the fact.

## What this skill never does

Never runs a kit against an epic row that has no phase · never emits a question
without a destination tag · never emits a question whose answer it could cite ·
never asks a spec-depth question — thresholds, fields, error paths, NFR targets ·
never exceeds twelve must-asks · never solicits Captured Detail, and never spawns
follow-up questions from it · never writes a governance file directly · never
silently reconciles a contradiction · never interprets a hedged statement ·
never deletes an Open Question — it is answered or `Overtaken — <reason>` ·
never writes `Confirmed` into §8 · never drafts stories, requirements or
acceptance · **never books, schedules or commits a client call — under a
standing grant or outside one, the session is the BA's act and the framework
spends nobody's time** · never runs a check, clears an aspect, or rules a
reopen.

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
