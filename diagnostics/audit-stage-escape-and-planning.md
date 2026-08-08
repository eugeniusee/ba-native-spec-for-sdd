# Diagnostic audit — stage escape and the missing planning step

**Date:** 7 August 2026 · **Mode:** read-only. Nothing in the package was
changed. This file is the only file written.

**Scope.** Two problems seen in live runs. Problem 1: the agent started
implementing before the spec was certified. Problem 2: the BA never sees a
menu of techniques to choose from.

**What was read.** The methodology under `docs/methodology/` as ground truth.
The built package under `payload/` — the two mirror files, the four persona
files, the 12 workflow skills, the 20 technique skills, the 13 templates, the
3 cards, the 11 scripts, and `install.sh`.

**A note on names.** Framework codes carry their plain name the first time
they appear. `P-O2` is **plan composition**. `T-04` is **Persona charters**.
`AT-ST-2` is one of the eighteen **aspect-threshold criteria**. `CC-XA-01` is
one of the sixty-one **completeness-contract assertions**. Band 1 is
**discovery**, Band 2 is **decomposition**, Band 3 is **per-feature spec work**.

---

## 1. BUILD-LOG tail — the last five entries

`BUILD-LOG.md` holds nine build sessions plus one propagation lane. The last
five entries are S6, S7, S8, S9 and Lane B. Each entry runs 180–300 lines, so
the header and the one-line summary of each are quoted verbatim below, with
the line range for the full text.

### S6 — lines 1129–1436

> `## S6 — Techniques II · 1 August 2026 · GREEN`
>
> `**Session prompt:** the standing pattern, build plan §4.`
>
> `### Units built — 7 of the 67 (running total 54)`

Divergences recorded: **D23 · D24 · D25 · D26 · D27 · D28 · D29.**

### S7 — lines 1437–1732

> `## S7 — Techniques III + closure · 1 August 2026 · GREEN`
>
> `**Session prompt:** the standing pattern, build plan §4.`
>
> `### Units built — 6 of the 67 (running total 60)`

Divergences recorded: **D30 · D31 · D32 · D33 · D34 · D35.**

### S8 — lines 1733–1987

> `## S8 — Band 2 + spine · 1 August 2026 · GREEN`
>
> `**Session prompt:** the standing pattern, build plan §4.`
>
> `### Units built — 5 of the 67 (running total 65)`

Divergences recorded: **D36 · D37 · D38 · D39 · D40 · D41.**

### S9 — lines 1988–2267

> `## S9 — Adapter + Phase-2 exit · 1 August 2026 · GREEN`
>
> `**Session prompt:** the standing pattern, build plan §4.`
>
> `### Units built — 3 of the 67 (running total 67 — the inventory closes)`

Divergences recorded: **D42 · D43 · D44 · D45 · D46.** The entry closes Phase 2
and hands Phase 3 three inheritances: empty tuning logs, the one-way
maintenance rule, and the behavioral Spec Kit pin.

### Lane B — lines 2268–2448

> `## Lane B — orchestrator rules v0.4 §10.3 · BA-facing communication register · 7 August 2026 · GREEN`
>
> `**Session prompt:** Lane B rebuild — propagate orchestrator rules v0.4 §10.3`
> `into the mirrors, the four personas, and every BA-facing render string.`
>
> `### Units touched — 55 files`

Divergences recorded: **D47 · D48 · D49 · D50.** The entry closes on one open
item: the communication register is compiled but no test checks it.

### Nothing below re-reports D23–D50

Those 28 divergences are about fixture shapes, sheet-to-index agreement, card
structure, exit-test string pinning, and the Spec Kit pin. None of them touches
the stage boundary or the planning step. The findings below are new.

**One thing that is in the tail and needs care.** S6 line 1150 records an
assumption, not a divergence:

> `No subagent this session: the seven skills are all dispatched under`
> `` `ba-discovery`, which S5 built, so its three operating principles and its ``
> `writing-standard discipline did not need restating per skill.`

Finding F-02 below reports that this dispatch is not implemented anywhere in
the package. That is a report about an unimplemented assumption, not a re-report
of a recorded divergence.

---

## 2. Findings

Severity: **critical** — causes the observed failure directly ·
**high** — removes a guard the methodology requires ·
**medium** — degrades the BA's ability to act.

Class: **package defect** — the rule exists, the package does not carry it ·
**methodology gap** — the rule itself does not exist yet.

| F | Prob | File + section | Exact quote, or "missing" | Rule broken | Sev | Class |
|---|---|---|---|---|---|---|
| F-01 | 1 | `payload/mirror/claude-block.md` — whole file | **missing.** No sentence anywhere forbids implementing, planning, or prototyping before certification. | Gate §11.3 — *what the gate never does*; §11.1.4 — *the gate stops*; §11.2 — *the operator resumes at `/speckit.plan`* | critical | package defect |
| F-02 | 1 + 2 | `payload/claude/skills/` — all 32 skills | **missing.** Only `ba-gate/SKILL.md:113` and `ba-gate-health/SKILL.md:58` dispatch a persona: *"Dispatch the `ba-gate` subagent."* No skill dispatches `ba-orchestrator`, `ba-discovery`, or `ba-analyst`. | Orchestrator §11 — *the Orchestrator subagent … conducting under §10.2's discipline, with every P-O compiled to a plan-mode checkpoint* | critical | package defect |
| F-03 | 1 | `payload/mirror/claude-block.md:163–165` — "Discipline" | *"A `[NEEDS CLARIFICATION]` marker you find in a certified spec is deliberate … **Implement around it and surface it**; do not resolve it by guessing."* | Gate §11.3 — the certification boundary; the reader of this block is the analysis session, not the coding agent | critical | package defect |
| F-04 | 1 | `payload/mirror/AGENTS.md` — whole file, esp. lines 8–10 and 210–212 | **missing** (the boundary). Present instead: *"the agent reads exactly what is written"* and *"Do not edit a certified spec to make implementation easier."* | Gate §11.3 — the certification boundary | high | package defect |
| F-05 | 1 | `payload/claude/skills/ba-tier2/SKILL.md:231–242` — "What this skill never does" | **missing.** Twelve prohibitions, none about code, plans, or prototypes. The strongest stop is line 201: *"Then stop and name `/ba-gate <feature>`."* | Gate §11.3; contract §1 via gate §12 — *backstop only, never the bar* | high | package defect |
| F-06 | 1 | `payload/claude/agents/ba-analyst.md:158–169` — "What you never do" | **missing.** Fifteen prohibitions, none about code. Line 151: *"Then you **name the gate and stop.**"* | Gate §11.3 — the certification boundary | high | package defect |
| F-07 | 1 | `payload/claude/agents/ba-discovery.md:152–162` — "What you never do" | **missing.** Fourteen prohibitions, none about code. | Gate §11.3 — the certification boundary | medium | package defect |
| F-08 | 1 | `payload/claude/skills/ba-gate/SKILL.md:281`; `ba-handoff/SKILL.md:138`; `agents/ba-gate.md:166`; `agents/ba-orchestrator.md:275` | *"never edit a spec, a memory artifact, or code"* — stated in exactly four places, all of which run **at or after** certification. | Gate §11.3 — correct text, wrong position in the flow | high | package defect |
| F-09 | 2 | `payload/claude/skills/ba-aspect/SKILL.md:98–104` — "Step 4 — P-O2 (plan composition)" | *"Present the snapshot and take the composition: **select · drop · reorder · add custom**."* One sentence. No render shape, no enumerated choices, no wait instruction. | Orchestrator §10.1 P-O2 — plan composition; §6.2 — *the composed plan is the BA's document* | critical | package defect |
| F-10 | 2 | `payload/claude/skills/ba-aspect/SKILL.md:134–140` — "What this skill never does" | **missing.** Seven prohibitions. None says *never composes the plan on the BA's behalf*. Compare `ba-clear/SKILL.md:103`: *"You never confirm. **An aspect gate never self-clears.**"* | Orchestrator §6.2 — composition is the BA's act; §7.1 — *BA-invoked, never auto-fired* | high | package defect |
| F-11 | 2 | `payload/claude/skills/ba-aspect/SKILL.md:85–91` and `:118–123` — the two pinned shapes | Both render `\| 1 \| <name> \| …` — a plain name only. No technique code, no purpose line. | Orchestrator §10.3 rule 5 — *code + name, always … first mention in a sitting adds a one-line purpose*; rule 8 subordinates rule 5 to the pinned shape | medium | methodology gap |
| F-12 | 2 | `payload/claude/skills/ba-aspect/SKILL.md:93–94` — Step 3 | *"Where a catalogue technique fits the hole, name it by its skill (`t03`, `t06`, …) so `/ba-run` can dispatch it."* | Orchestrator §10.3 rule 5 — *a bare code is a render defect*. `t03` is neither the catalogue code `T-03` nor its plain name | medium | package defect |
| F-13 | 2 | `payload/claude/skills/ba-aspect/SKILL.md` — whole file | **missing.** No step lists enrichment techniques. `ba-t04/SKILL.md:35–40` names a path nothing implements: *"T-04 (Persona charters) enters a plan two ways only: the **BA elects it** … or the BA asks for enrichment options and it is **listed among them**."* | Orchestrator §6.2 — *select · drop · reorder · **add custom***; catalogue b1, T-04's election rule | medium | package defect |
| F-14 | 2 | `payload/claude/skills/ba-aspect/SKILL.md:70–80` — Step 3 | *"The unmet criteria are the holes; the holes are the suggestions."* At a freshly opened aspect every criterion is unmet, so every technique serving that aspect is suggested, in order. | Orchestrator §6.1 — *the suggestion is advisory, never a restriction*. The mechanic is correct; nothing converts the output into a choice | medium | package defect |
| F-15 | 2 | `payload/claude/skills/ba-frame/SKILL.md:85–87` — the close | *"Then render the head … and name the one act now available: **`/ba-aspect stakeholders`**."* | No rule broken. Correct per orchestrator §8.1 — the technique plan belongs at P-O2, not at Band-1 entry | — | no finding |

### Finding detail — the quotes that did not fit the table

**F-01 · what the CLAUDE.md block actually contains.** The block is 168 lines.
Its three instruction sections are *Spec writing essentials* (how to write a
spec), *Commands — the `/ba-*` namespace* (a list of 32 commands), and
*Discipline* (four bullets). The nearest thing to a session-level guard is at
lines 75–76:

> All 32 are **BA-invoked, never auto-fired** (`disable-model-invocation: true`).
> Do not invoke them on your own initiative and do not simulate their effects.

That guard is real, and it works — but it fences only the `/ba-*` commands. It
says nothing about leaving the framework and doing the work by hand. The block
never states which stage the project is in, and never states what the reading
agent may not do.

**F-02 · the dispatch gap, verified both ways.** Grepping all 32 skill files
for `ba-orchestrator`, `ba-discovery`, `ba-analyst`, "subagent" or "dispatch"
returns two hits only, both naming `ba-gate`. Meanwhile
`payload/claude/agents/ba-orchestrator.md:3` claims the reverse:

> Invoked by the /ba-frame, /ba-status, /ba-aspect, /ba-run, /ba-clear,
> /ba-waive-aspect, /ba-reopen, /ba-close-band1 and /ba-enter-feature skills.

The claim lives in the persona's own description. No skill implements it. Note
what this costs: `ba-orchestrator.md:22–27` carries the general stop rule for
every prompt point —

> **You never decide alone.** … Where a skill names a P-O checkpoint, stop there
> and take the ruling; never infer it from the evidence looking complete, from
> context, or from the BA having ruled the same way before.

— and `ba-orchestrator.md:275–277` carries the code prohibition. Neither loads
when the BA runs `/ba-aspect`.

**F-03 · the block speaks to the wrong reader.** Two of the four *Discipline*
bullets address an agent that is building software:

> **The certified text is the read text.** A spec that reached `/speckit-plan`
> passed the gate and its hashes were verified at handoff. Editing it silently
> voids that certification.

> **A `[NEEDS CLARIFICATION]` marker you find in a certified spec is
> deliberate** — a consciously accepted, waivered unknown. **Implement around it
> and surface it**; do not resolve it by guessing.

`install.sh:312` merges this block into the project's own `CLAUDE.md`. The BA
works in that project. So the agent conducting the analysis reads, in its
standing instructions, that its job is to implement around markers.

**F-08 · every place the boundary is stated, in full.** Four files, all
post-certification:

- `payload/claude/skills/ba-gate/SKILL.md:244–246` — *"**The gate stops.**
  Nothing past this line is the gate's act. The adapter (`/ba-handoff`) owns
  the plumbing and the hash guard; the operator owns the pipeline from
  `/speckit-plan`; the BA re-enters at Band-3 verification."*
- `payload/claude/skills/ba-gate/SKILL.md:281–284` and
  `payload/claude/agents/ba-gate.md:166–168` — *"Never invoke a `/speckit-*`
  command · never edit a spec, a memory artifact, or code · never reword content
  to pass its own checks."*
- `payload/claude/skills/ba-handoff/SKILL.md:138–141` — *"Never edits a spec, a
  memory artifact, a ledger, or code · … · never invokes any `/speckit-*`
  command (the operator does)."*
- `payload/claude/agents/ba-orchestrator.md:275–277` — *"Never author or edit any
  content artifact — `canvas.md`, anything under `.specify/memory/`, a brief, a
  spec, code."*

**A clean negative, stated because absence matters.** Spec Kit's
implementation-side commands are **not** reachable or suggested from any BA-flow
prompt before certification. Every mention of `/speckit-plan`,
`/speckit-tasks` or `/speckit-implement` in the package sits in
`ba-gate/SKILL.md` Stage 5, `ba-handoff/SKILL.md`, `sk_handoff.py`, the
`gate-tuning.md` template, or the two mirrors' *write the WHAT, never the HOW*
rule. `payload/claude/skills/ba-handoff/SKILL.md:111–112` is the only place the
chain appears, and it is correctly placed and correctly owned:

> Then: `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`, operator
> steering. The BA re-enters at Band-3 verification, against the acceptance tier.

**A second clean negative.** No skill carries an unguarded "propose next steps"
or "continue" instruction. Every closing render names one act and names it by
command — `ba-frame` names `/ba-aspect stakeholders`, `ba-aspect` names
`/ba-run <technique>`, `ba-enter-feature` names `/ba-run tier2 <NNN>`,
`ba-tier2` names `/ba-gate <feature>`. The unguarded surface is not inside a
skill. It is the conversation between skills, where only `CLAUDE.md` and
`AGENTS.md` are in force — which is F-01 and F-04.

---

## 3. Root-cause hypothesis

### Problem 1 — the escape into implementation

The package fences the framework's own parts and forgets to fence the room they
sit in. Every persona and every skill is told what it may not do, and four of
them are told not to touch code. But those instructions only exist while that
persona or skill is running — and F-02 shows that three of the four personas
never run at all. Between commands the agent is governed by `CLAUDE.md` and
`AGENTS.md` alone, and neither one says that this session is doing analysis or
that implementation waits for certification. Worse, the `CLAUDE.md` block was
written for the coding agent that reads a finished spec: it tells its reader to
implement around markers and not to edit certified text. So after `/ba-tier2`
produced the first draft and handed back, the agent fell out of a skill that had
just said "stop and name the gate" into standing instructions that describe it
as the implementer. It did the natural next thing.

### Problem 2 — the invisible planning step

P-O2 — plan composition — is present in the package but is not built as a
checkpoint. Orchestrator §11 says every prompt point compiles to a plan-mode
checkpoint; `/ba-clear` shows what that looks like, with a worked evidence table,
a three-row ruling table, and the sentence *"You never confirm."* `/ba-aspect`
has none of that for P-O2. It has one sentence — "Present the snapshot and take
the composition" — followed immediately by the instruction to write the composed
plan into the ledger. Nothing pins a menu shape, nothing enumerates the BA's
four choices as choices, and the skill's own never-list omits the one
prohibition that would hold the line. Meanwhile the suggestion snapshot at a
fresh aspect legitimately lists every technique serving that aspect, in order,
because every threshold criterion is still unmet. So the agent renders a
complete ordered sequence, sees no instruction to stop, and records it as the
plan. Combined with F-02 — the orchestrator persona and its "stop at every P-O
checkpoint" rule never load — nothing anywhere tells it otherwise.

---

## 4. Fix sketch

Not applied. Three to five lines each, naming what a fix would touch.

### Problem 1

1. Add a stage-boundary section to `payload/mirror/claude-block.md` — the
   project's stage, and the rule that no plan, no task list, no prototype and no
   code exists before an effective PASS plus `/ba-handoff`. Mirror it into
   `payload/mirror/AGENTS.md`.
2. Split the mirrors' coding-agent bullets from the BA-session bullets, so
   "Implement around it and surface it" is visibly addressed to the agent
   downstream of handoff, not to the reader running the analysis.
3. Add the code prohibition to the three never-lists that lack it:
   `agents/ba-analyst.md`, `agents/ba-discovery.md`, `skills/ba-tier2/SKILL.md`.
4. Both mirrors are compiled units. Under the one-way rule (BUILD-LOG S9,
   closure note ii) this needs a source-document change first — the boundary
   sentence belongs in gate §11.3 or orchestrator §10.2 as a framework-wide
   rule, not only as the gate's own prohibition.

### Problem 2

1. Add an explicit dispatch line to each of the nine orchestrator-owned workflow
   skills and to each technique skill — the shape `ba-gate/SKILL.md:113` already
   uses. Without it the persona guards are inert (this fix also covers Problem 1).
2. Give P-O2 a pinned render in `skills/ba-aspect/SKILL.md` Step 4: the numbered
   candidate list, each row carrying code + plain name + one-sentence purpose,
   then the four choices — select, drop, reorder, add custom — as an enumerated
   ruling table, on the `/ba-clear` Step 3 model.
3. Add to that step a listing of BA-electable enrichment techniques, so T-04
   (Persona charters) and an early T-02 (Glossary discipline) are reachable.
4. Add to `ba-aspect`'s never-list: *never composes or records a plan the BA did
   not compose*.
5. Items 2 and 3 change a pinned shape, so under communication-register rule 8
   the shape governs — orchestrator §6.1 and §6.4 need the code and purpose
   columns first. That part is a rules change, not a repo change.

---

## 5. What was checked and found clean

- No BA-flow prompt reaches or suggests `/speckit-plan`, `/speckit-tasks` or
  `/speckit-implement` before certification.
- No skill carries an unguarded "propose next steps" or "continue" instruction.
- Every technique skill declares the aspect-threshold criteria it serves in its
  own frontmatter description, so the suggestion engine has a real source.
- `/ba-frame` correctly does not render a technique plan at Band-1 entry.
- `/ba-handoff` and `/ba-gate` Stage 5 place the certification boundary
  correctly and own it correctly.
