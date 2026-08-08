<!-- ba-native-spec:begin -->
# Spec writing rules — BA-Native Spec

This project's specifications are written to the Geniusee Spec Writing Standard.
These are the essentials, mirrored here so any AGENTS.md-reading tool carries
them. The full method lives with the BA; this file is the writing contract.

**The premise:** the agent reads exactly what is written. It will not ask a
colleague and it will not politely infer — it fills every gap with a confident
guess. These rules exist so there are no gaps worth guessing about.

This file carries two addressed modes. Read the one addressed to you. The
writing rules below the two apply in both.

## Analysis session — the default mode

**Reader: you, in this conversation.** Every conversation in this project starts
here and stays here, for every feature that has not both passed the gate and been
handed off.

**Session mode — the analysis boundary (framework-wide).** Every conversation
this framework conducts is an **analysis session**. An analysis session produces
analysis artifacts only. It never produces an implementation plan, a task list, a
prototype, or code — not as a proposal, not as a "next step," not as initiative.
The boundary lifts **per feature**, and only by the pair: effective PASS at the
gate **and** completed handoff (gate §11). Downstream of that pair, implementation
belongs to the coding agent and the operator; the analysis session continues
unchanged for every other feature. Standing project instructions (the compiled
CLAUDE.md block, AGENTS.md) carry two addressed modes — analysis-session rules
and coding-agent rules — and every instruction names its reader; an instruction
addressed to the coding agent is inert in an analysis session. Wanting to
implement is never evidence of readiness: the only exit is the gate.

Here that pair is `/ba-gate <feature>` reaching an effective PASS, then
`/ba-handoff <feature>` completing. Until both land for a feature, you are in
analysis mode for it.

- **You never author.** You schedule, route, and record. Content is authored by
  techniques and the BA; checks are run by the gate. If a step seems to need you
  to edit `canvas.md`, a file under `.specify/memory/`, a brief, a spec or code —
  it is not your step.
- **You never decide alone.** Where a skill names a P-O checkpoint, stop there
  and take the ruling; never infer it from the evidence looking complete, from
  context, or from the BA having ruled the same way before.

## Coding agent — downstream of handoff

**Reader: the coding agent working a feature that has passed the gate and
completed `/ba-handoff <feature>`.** If that pair has not landed for the feature
in front of you, these rules are inert. You are in an analysis session, and the
section above governs.

- **The certified text is the read text.** A spec that reached `/speckit-plan`
  was certified by the gate and its hashes were verified at handoff. **Do not
  edit a certified spec to make implementation easier** — spec errors are fixed
  in the spec and re-run downstream, never hand-patched in code.
- **A `[NEEDS CLARIFICATION]` marker you find in a certified spec is deliberate**
  — a consciously accepted, waivered unknown. Implement around it and surface
  it; do not resolve it by guessing.
- **Never invent a role, term, entity, or constraint.** If a spec needs one that
  does not exist upstream, that is a gate defect — report it, don't author it.

## Golden rules

1. **Write the WHAT, never the HOW.** No frameworks, no databases, no
   endpoints, no UI layouts. The technical solution belongs to `/speckit-plan`.
2. **One requirement, one statement, one ID.** Never chain behaviors with
   "and/or". Two SHALLs' worth of behavior in one sentence means two
   requirements.
3. **Every domain term comes from the glossary.** Not in
   `.specify/memory/glossary.md`? Add it there first, then use it. Never
   introduce a synonym.
4. **Structured data goes in tables, never prose.** Permissions, fields, states,
   integrations — tables. Prose invites the agent to guess; tables don't.
5. **Reference, never restate.** Roles, permissions, domain entities, and global
   standards are defined once in the governance/context files. A spec that
   redefines a role fails the gate.
6. **If it can't be tested, it isn't a requirement.**
7. **Mark gaps, don't hide them.** Unknowns get an explicit
   `[NEEDS CLARIFICATION: <question>]`. A visible gap is workable; an invisible
   one becomes wrong code.
8. **No stubs.** A heading with placeholder text under it fails the gate. Fill
   it with real content or mark it `N/A — <reason>`.

## The spec skeleton — ten sections, exact names, exact order

Agents parse structure. Do not rename, reorder, add, or drop a section.

1. **Overview & Value** — why this feature exists; 2–4 sentences.
2. **User Stories** — the skeleton (P1–P3), each with acceptance criteria.
3. **Functional Requirements** — EARS statements, FR-IDs.
4. **Flows, States & Errors** — main flow, alternates, every error path.
5. **Non-Functional Requirements** — measurable, feature-specific only.
6. **Business Rules** — BR-IDs.
7. **Data Requirements** — table.
8. **Integration Touchpoints** — table.
9. **Out of Scope** — what this feature deliberately does NOT do, and where each
   exclusion lives instead.
10. **References** — links to `roles-permissions.md`, `glossary.md`,
    `domain-model.md`, and the parent epic scope brief.

## User stories

```
US<N> (P<1|2|3>) — As a <role from roles-permissions.md>,
I want <capability>, so that <value>.
```

The role must exist verbatim in `.specify/memory/roles-permissions.md`.
"As a user" is banned — *which* role? Persona names are never actors.
**P1** = the feature fails without it · **P2** = needed, not day-one ·
**P3** = nice-to-have. At least one P1; if everything is P1, nothing is.
Story IDs are stable and never reused after deletion.

## Functional requirements — EARS grammar

Every functional requirement uses one of five patterns. Keywords in CAPS.
One SHALL per requirement. The response must be externally observable.

| Pattern | Template | Use when |
|---|---|---|
| Ubiquitous | THE SYSTEM SHALL `<response>` | Always true, no trigger |
| Event-driven | WHEN `<trigger>`, THE SYSTEM SHALL `<response>` | Something happens |
| State-driven | WHILE `<state>`, THE SYSTEM SHALL `<response>` | True during a state |
| Unwanted behavior | IF `<condition>`, THEN THE SYSTEM SHALL `<response>` | Errors, abuse, failure |
| Optional feature | WHERE `<feature included>`, THE SYSTEM SHALL `<response>` | Configurable capability |

Patterns combine: `WHILE <state>, WHEN <trigger>, THE SYSTEM SHALL <response>`.

```
FR-001 (US1) — WHEN a Client selects an available slot and confirms,
THE SYSTEM SHALL create an Appointment in status "Booked" and display
the confirmation to the Client.
```

Every FR links to at least one story; an FR with no story is scope creep, a
story with no FRs is unbuilt. Numbering is stable and never reused. Name the
real actor and the specific object.

## Acceptance criteria — one slot, two forms

- **Checklist line** → simple rule, validation, permission, field constraint.
  One checkable assertion.
- **Gherkin scenario** → multi-step behavior, branching, edge case — anywhere a
  worked example with **concrete data** removes ambiguity the FR leaves open.

**Anti-duplication rule:** a scenario must add concrete data and a concrete
path. If it reads like the EARS rule reworded, delete it and write a checklist
line. Never re-narrate the rule. Placeholder values (`<x>`, "a user") fail.

## Banned words

Each one is a hidden guess:

> fast, quickly, easy, simple, user-friendly, intuitive, appropriate, adequate,
> sufficient, efficient, flexible, robust, seamless, some, several, many,
> minimal, improve, better, handle, support, manage, process (without an
> object), etc., and/or, as needed, if necessary, TBD

Replace each with a number, a named behavior, or a `[NEEDS CLARIFICATION]`.
Exemption: verbatim user-visible copy inside quotation marks.

## Non-functional requirements

Pattern: **metric + target + condition.** Global budgets live in governance —
reference them; the spec adds feature-specific deltas only. Prompt yourself per
category and either write a measurable NFR or `N/A — <reason>`:
performance · security/privacy · availability · accessibility · localization ·
scale. Silence fails.

## Flows, states & errors

Main flow: numbered steps, actor → action → observable result. Then every error
path with **trigger + system behavior + user-visible outcome** — none of the
three empty or generic. A flow with only the happy path fails the gate.

## Out of scope

The fence at the end of the spec: agents "helpfully" build adjacent
functionality, and this section tells them an absence is deliberate. Every
exclusion states where it lives instead — a later phase, another epic/feature,
or explicitly "not planned". Do not duplicate the product-level boundary in
`.specify/memory/out-of-scope.md`.

## IDs & traceability

| Artifact | ID scheme | Links to |
|---|---|---|
| User story | US1, US2… | ← epic scope brief |
| Functional requirement | FR-001… | → US`<n>` (mandatory) |
| Business rule | BR-001… | referenced by FRs/AC where relevant |
| NFR | NFR-001… | feature-level |
| Acceptance | lives under its story | → US`<n>` implicitly |

The chain the gate verifies: **every story has FRs and acceptance; every FR has
a story; no orphans in either direction.**

## Self-check before the gate

- [ ] Zero technology names, endpoints, or UI layout decisions
- [ ] Every FR: one SHALL, EARS pattern, linked story, observable response
- [ ] Zero banned words (or each replaced / marked `[NEEDS CLARIFICATION]`)
- [ ] Every story has acceptance; every scenario has concrete data and adds a
      path the FR doesn't spell out
- [ ] All structured data in tables; every entity exists in the domain model
- [ ] Every error path has trigger + behavior + user-visible outcome
- [ ] Every NFR has metric + target + condition (or explicit `N/A` + reason)
- [ ] All roles/terms referenced, none redefined
- [ ] Out of Scope: every exclusion names where it lives instead
- [ ] No stub sections; unknowns carry `[NEEDS CLARIFICATION]`

## BA-facing communication register

The framework speaks in three registers, one owner each: **artifact text** — the
writing standard; **stakeholder-facing questions** — elicitation §3.2 (no
framework jargon, no EARS, no artifact names); **BA-facing conversation** — this
register. Everything rendered to the BA — prompt points, status lines,
suggestion snapshots, verdicts, free conversation — falls under it. It never
touches artifact content: spec precision, EARS grammar, and pinned record shapes
are out of its reach.

1. **Short sentences.** One point per sentence; target ≤ 20 words. Split before
   you subordinate.
2. **Common words.** The everyday word, never the formal synonym: *use*, not
   *utilize* · *before*, not *prior to* · *then*, not *subsequently* · *start*,
   not *commence* · *need*, not *necessitate*. The pattern, not a closed list.
3. **Active voice; imperative for BA acts.** "Run the check," never "the check
   should be performed."
4. **One term per concept.** Framework vocabulary verbatim — aspect, threshold,
   waiver, reopen. Never rotate synonyms for one thing.
5. **Code + name, always.** Every technique, stage, or assertion rendered to the
   BA carries its code *and* its name: "T-05 — Context & landscape mapping,"
   "P-O4 — clearing confirmation." First mention in a sitting adds a one-line
   purpose. A bare code is a render defect.
6. **State first, then the act.** Open every render with where the work stands
   and what the BA does next. Background only on ask.
7. **Only what the next decision needs.** No methodology explanation mid-flow —
   name the owning document and section instead. Outside pinned formats, a
   render past ~10 lines is a cut candidate.
8. **Pinned formats stay pinned.** Recurring renders (suggestion snapshot §6.1,
   ledger head §2.4, profile picker §8.1, project dashboard §10.4,
P-O prompts) keep their shapes; never re-narrate what a
   format already shows. On conflict between this register and a pinned shape,
   the shape governs.

## Where things live

| What | Where |
|---|---|
| Discovery canvas | `canvas.md` (repo root) |
| Glossary, stakeholders, personas, context, constraints, competitive analysis | `.specify/memory/` |
| Domain model, roles & permissions, processes, design standards, out-of-scope, roadmap | `.specify/memory/` |
| Constitution | `.specify/memory/constitution.md` |
| Epic scope briefs | `.specify/memory/scope/<epic>.md` |
| Feature spec, traceability, gate report | `specs/NNN-<feature>/` |

**Never edit** `.specify/aspect-state.md`, `.specify/aspect-plans.md`,
`.specify/gate-health.md`, `.specify/gate-tuning.md`, or
`.specify/elicitation-tuning.md` — those are the framework's runtime ledgers,
not content. This binds both readers.

The certified-spec rule moved: it is a coding-agent rule and now sits under
**Coding agent — downstream of handoff**, above.
<!-- ba-native-spec:end -->
