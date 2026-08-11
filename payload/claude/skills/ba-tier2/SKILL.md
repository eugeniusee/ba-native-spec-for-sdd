---
name: ba-tier2
description: Tier 2, spec-depth gap-filling. Loads the context stack in its pinned order with the parent brief last, drafts the full standard-shape spec first, marks every value it inferred rather than sourced, then asks at most a capped number of impact-ordered gap questions - each naming the contract failure or the marker it closes, each with a recommended answer. Ends at the completeness gate.
disable-model-invocation: true
---

# `/ba-tier2 <feature>` — spec-depth gap-filling

**Serves:** the Band-3 act, per feature. **Class:** Spec ·
**Destination:** `specs/NNN-<feature>/spec.md`.

Tier 2 carries **a confirmed feature slice to a gate-ready spec**. The engine is
one sentence: **draft everything derivable; mark everything not; ask only about
marks that block.**

From decent Band-1/Band-2 context a draft should be ~80–90 % derivable. What is
left is a handful of focused questions with recommended answers — about fifteen
minutes of a BA's attention, not an interrogation.

**This skill delivers a spec to the gate and stops. It never runs a check.**

## Invocation contract — P-O3 (technique invocation), compiled in

**BA-invoked, never auto-fired.** `/ba-tier2 <feature>` is the one-step entry:
typing it **is** the BA's invocation act — P-O3, technique invocation. No prior
command is required; none is requested.

Self-check, and stop if it fails:

> the run carries its pinned output contract:
> `{a gate-ready spec.md in writing-standard shape, the brief §6 write-back, and routed-findings signals where cross-cutting content surfaced · Spec · specs/NNN-<feature>/spec.md}`.

**The entry act has already happened.** Band-3 entry for this feature *is* the
slicing-row confirmation — brief §8 Status reading `Confirmed — <date>` — and
the destination directory already exists with its number assigned. If there is no
confirmed slicing row and no `specs/NNN-<feature>/`, stop and name
`/ba-enter-feature <epic>/<feature>`.

**Preconditions are not re-checked here.** That the brief exists, is `Scoped`,
and proposes this slice is the gate's ground at admission, and re-implementing
those checks in the authoring skill would put a second, drifting copy of them one
band upstream.

**No persistent question log.** Answers land in the spec and in their routed
homes; the session conversation is the working record. Traceability is at
structurally derivable granularity — story to requirement to acceptance — and
question-to-line links are deliberately not v1's.

**On a pass** — render one line:
`Tier 2 — <feature> → specs/NNN-<feature>/spec.md`, and begin. No confirmation
dialog: the command was the act.

**On a miss** — stop in ≤ 2 lines: the failed check, and the single act that
unblocks — `/ba-enter-feature <epic>/<feature>`. Nothing else runs; nothing
else is explained.

## Step 1 — load the context stack, in this order

The order is the precedence order. The brief is **last** because it is the most
specific and freshest layer, loaded on top of everything else.

| # | Artifact | Why it is loaded |
|---|---|---|
| 1 | `.specify/memory/glossary.md` | write in canonical terms from the first token — synonym drift is cheaper to prevent than to repair |
| 2 | `canvas.md` | the value frame, and the fallback target for the spec's value claim |
| 3 | `.specify/memory/roles-permissions.md` | story actors must exist **verbatim**; authorization tuples visible before drafting |
| 4 | `.specify/memory/domain-model.md` | the entities and relationships the spec may rely on |
| 5 | `.specify/memory/processes.md` | flow context — where this feature sits in the journeys |
| 6 | `.specify/memory/context.md` + `constraints.md` | integration and NFR reality |
| 7 | `.specify/memory/out-of-scope.md` | the outer fence — **reference it, never restate it** |
| 8 | sibling feature specs of the same epic | settled shared decisions are **answered-sources**, not open questions |
| 9 | **the parent epic's scope brief — last** | the most specific layer, including **§7 Captured Detail** |

**Precedence, and it splits by kind of claim:**

- On **scope questions for this feature — the brief wins** over general context.
- On **definitions — roles, terms, entities — governance wins always.** A brief
  cannot redefine a role or a term. If brief content implies a definition change,
  **that is a finding** — a routing or reopen signal — and never a local
  override.

## Step 2 — draft first, and draft it all

1. **Stories first.** From the brief's §2 Essential Scope lines that *this*
   feature covers per the §8 slicing row, draft the user stories with their
   acceptance. The full drafting module — role discipline, sizing, priorities,
   the two acceptance forms, and the seven behaviors this framework deliberately
   does not inherit — is `references/story-drafting.md`. **Read it before
   drafting stories.**

2. **Skeleton around them.** The complete ten-section skeleton, in the standard's
   exact headings and exact order: requirements in EARS linked to stories · flows
   **with their error paths** · feature NFRs prompted per category · business
   rules · data tables · integration touchpoints seeded from brief §4 · Out of
   Scope seeded from brief §3 and the sibling slices · References.

3. **Cite or mark, every line.** Every drafted value carries either a citation —
   a context artifact or a brief line — or a marker.

   **The confidence rule, and it is the load-bearing one:**

   > A value you can *infer* but no source *states* — an industry-default
   > threshold, a plausible validation limit — is drafted **and marked**:
   > `[NEEDS CLARIFICATION: confirm <value> — basis: <inference>]`.

   The draft stays maximally complete; the uncertainty stays maximally visible.
   **Each such marker is a recommended-answer question in embryo** — which is
   exactly what makes the next step's legality rule cover validation questions at
   all. Marking is not a confession of weakness; unmarked inference is the one
   failure mode no rule downstream can catch.

## Step 3 — the gap questions

**Order by impact:**

1. blocks a P1 story's buildability
2. would fail a **non-waivable** assertion
3. would fail a waivable assertion
4. confirms a low-confidence drafted value

**One at a time.** An answer can resolve or kill queued questions — a confirmed
state model collapses three data questions into zero — so **the queue
re-evaluates after every answer.** Asking a batch wastes the BA's attention on
questions that were about to die.

**The packet:**

```
GQ<n> of <cap> — [legality: <CC-ID(s)> | marker <ref>] [destination(s): <spec §, artifact>]
  Question: <one question, concrete>
  Recommended answer: <specific, concrete — never "it depends">
  Basis: <source line / captured detail / stated inference>
```

**The recommended answer is never a hedge.** "It depends on the business" is not
a recommendation; it is the question asked twice. Recommend the concrete value
you would defend, name the basis, and let the BA confirm, edit, reject, or defer.

**Defer — the fourth disposition.** A deferred question records **no answer**:
the draft keeps its marked recommended value, the `[NEEDS CLARIFICATION]` marker
stands as the record, and the brief's Open Question statuses stay open. Legal for
any question, and the **expected** disposition under the **Presale** profile for
questions that cannot reach the client. Under Presale, propose the
client-unreachable subset of the queue as **one deferral batch** — the BA
confirms, edits, or dissolves it in a single act, never per-question drip and
never the framework's own call — then re-evaluate the queue **once** after it.
When Tier 2 resumes with client access after a recorded switch to Discovery,
every surviving marker is a legal question under the legality rule below (it
resolves an open marker): the deferred packets re-render, answers land, markers
resolve. Resume, not rewrite.

**The cap: 7 per feature by default, BA-adjustable per feature.** Everything
beyond the cap has a dignified path — it stays as a marker and meets the gate's
fail-then-waive machinery, where the BA decides consciously and on the record.

**The overflow rule.** If **blocking** questions — classes 1 and 2 — exceed the
cap, the correct diagnosis is **not a longer interrogation. It is a thin brief.**
Stop and emit the **overflow signal**: feature · the unfilled blockers, listed ·
the recommendation of a Tier-1 supplement for those named gaps. **This run takes
the BA's ruling in the same sitting**, per P-O9 — overflow ruling: **supplement**
— the Tier-1 mini-loop for the named gaps only · **cap adjust** — resume under
the BA-adjusted cap · **defer** — a band event plus a roadmap note, via the
routing discipline.

**This keeps the tiers honest: Tier 2 fills gaps; it does not re-run discovery.**

## Question legality — the rule, and it is a test

> A Tier-2 question is legal **iff** its answer **(a)** closes a named would-be
> contract failure, or **(b)** resolves an open `[NEEDS CLARIFICATION]` marker.

Every packet names its anchor in the legality field. **A question that cannot
name one is illegal by construction** — that is Guard 2 at Tier 2, and it is
falsifiable rather than aspirational: the contract is finite, so the space of
legal questions is finite.

**The cite-or-mark corollary is the rule's mandatory companion.** The contract
checks completeness, form and consistency — a spec can satisfy every assertion
while being factually wrong about the domain. A drafted "24 hours" parses, links
and passes; the clinic's actual policy might be 48. Validation questions — *is
this drafted value true?* — close no assertion failure. They are legal under
clause (b) **precisely because honest marking put a marker there.** Coverage is
complete iff marking is honest.

**The residual risk, named so it stays visible:** overconfident *unmarked*
inference — a wrong value drafted with a citation that does not actually state
it. No legality rule catches it, because there is no question to rule on. It is
caught by BA draft review, and it is what the wrong-draft log in
`.specify/elicitation-tuning.md` exists to tune.

**Guard 1 still applies, unchanged.** Before asking, attempt to answer from the
answered-source set; if you can cite a line, **cite it in the draft instead of
asking.** The Tier-2 answered-sources are every Tier-1 source **plus** the parent
brief **including its §7 Captured Detail** · governance — constitution,
roles-permissions, standards · **sibling feature specs of the same epic** · this
feature's draft-in-progress · answers already given this session.

Two of those are load-bearing and worth stating out loud: **a volunteered answer
is an answer** — re-asking Captured Detail burns stakeholder trust — and **a
state model settled in feature 004 is settled for 005**.

## Step 4 — land the answers

Each confirmed answer is written to **all** its destinations at once — the
business rule, the acceptance line, and the requirement's reference to it are one
answer's landing, not three.

**Cross-cutting answers are also routed.** A new term, a permission tuple, a
constraint — same seven destinations and the same BA-approved-batch discipline as
Tier-1 ingestion; the table is `.claude/skills/ba-tier1/references/routing.md`.
**A spec never self-grants a permission:** the governance edit is proposed,
approved and written first, and the spec then references it.

**Brief write-back.** Every brief §6 Open Question an answer resolves flips to
`Answered — <date> → <where the answer now lives>`. This is a brief edit, and the
pass-binding consequence applies: **it voids existing PASSes of sibling features
not yet handed off.** Batch the write-back; do not drip it.

## Step 5 — hand to the gate

Run the standard's own self-check over the finished draft, then say plainly what
survives: **every remaining marker is a named location**, each traceable to a
brief Open Question or a stated basis, and each a waiver candidate the BA will
decide on consciously at the gate.

Then stop and name `/ba-gate <feature>`. **You do not run it, and you do not
pre-judge its verdict.**

## Output

`specs/NNN-<feature>/spec.md` — the ten sections, exact headings, exact order:

```
1. Overview & Value   2. User Stories   3. Functional Requirements
4. Flows, States & Errors   5. Non-Functional Requirements   6. Business Rules
7. Data Requirements   8. Integration Touchpoints   9. Out of Scope
10. References
```

Plus the brief §6 write-back, and the routed batch where cross-cutting content
surfaced.

The house rules that bind every line — the golden rules, the EARS grammar, the
banned-word list, the tiered acceptance forms — are in `AGENTS.md` and the
`CLAUDE.md` block. `references/story-drafting.md` carries the story module. A
worked gap-question exchange is in `references/example.md`.

## Signals

| Signal | When | Payload |
|---|---|---|
| **Overflow** | blocking questions exceed the cap | feature · unfilled blockers list · Tier-1-supplement recommendation |
| **Routing** | an answer's content belongs to a governance/context artifact | finding · destination · proposed edit, as a BA-approved batch |
| **Reopen** | an answer *contradicts* content of a gated aspect | finding · contradicted artifact + line · conflict statement |

## At run end — compiled bookkeeping

1. **The primary output lands** at its contracted destination — this run's own
   act under its pinned contract.
2. **Cross-cutting findings route** as one proposed batch: the framework
   assembles the edits · the BA approves the batch · the framework writes. In
   Band 1 proper Scope H is disarmed and nothing fires; post-closure runs get
   the armed cadence automatically.
3. **Record** — no plans-file line: the feature's record is its band event
   in the ledger, the spec at its destination, and the gate report.

## What this skill never does

Never drafts before the context stack is loaded in order · never lets a brief
override a role, a term or an entity definition · never leaves an inferred value
unmarked · never asks a question it could answer by citation · never asks a
question whose legality field it cannot fill · never asks two questions at once ·
never exceeds the cap without the BA's adjustment · never answers past the cap
instead of emitting the overflow signal · never recommends "it depends" · never
writes a permission into `roles-permissions.md` itself · never deletes a marker
it did not resolve · never invents a role, term, entity or constraint the estate
does not carry · never runs a checker, a gate, or a health check · never confirms
its own slicing row.

**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
