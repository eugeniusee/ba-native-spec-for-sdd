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

**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.

**Register self-check (§10.3), before any BA-facing render:** short sentences ·
code + name · state first, then the act · ≤ 10 lines outside pinned shapes ·
no acknowledgement-only stop. A failing render is rewritten, not sent.
**Under a standing autonomy grant, register renders address the ledger, not
the conversation** — the band-boundary report, the mid-grant stop report and
the resumption report are the only BA-facing renders of an auto cycle
(`/ba-auto`).

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
- **You never birth governance from a template.** `/speckit-constitution` is
  **superseded by `/ba-run t15`**: `constitution.md` is born from Band-1
  evidence at T-15 — Constitution, never from a template; a template-born file is governance
  ground manufactured outside the evidence chain. Do not invoke the Spec Kit
  skill, and do not follow Spec Kit's Next Steps panel where that panel
  advertises it.

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
   **A requirement statement is not structured data:** that enumeration is
   *sets of values*, and one SHALL is not a set. User Stories and Functional
   Requirements are lines — `FR-0NN (US<n>) — <EARS text>` — never table rows.
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

**The numbers above are this list's numbering, not part of the headings.** They
name each section's § number for citation — §4 is *Flows, States & Errors* — and
they fix the order. Write `## User Stories`, never `## 2. User Stories`. A
numbered heading is not a stricter one: it matches no checker, so the spec reads
as *empty* rather than as *wrong*, and the dashboard reports it as unreadable.
Copy `.specify/templates/spec-template.md` and fill it in place rather than
typing the headings from this list.

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
   render past ~10 lines is a cut candidate. An acknowledgement-only stop is a
   banned render: if no BA decision exists, do not stop.
8. **Pinned formats stay pinned.** Recurring renders (suggestion snapshot §6.1,
   ledger head §2.4, source inventory §8.1, profile picker §8.1,
   scope frame §8.1,
   project dashboard §10.4, WBS export §10.5, route render §10.6,
   band-boundary report §10.7, mid-grant stop report §10.7,
   resumption report §10.7,
   P-O prompts) keep their shapes; never re-narrate what a
   format already shows. On conflict between this register and a pinned shape,
   the shape governs. **Under a standing autonomy grant, register renders
   address the ledger, not the conversation:** the band-boundary report, the
   mid-grant stop report and the resumption report are the **only** BA-facing
   renders of an auto cycle.
9. **The stop-point closing ask.** Every render that ends the turn awaiting BA
   input — every legitimate §10.1 stop, a contract-miss stop (§6.3), any
   keep-or-discard ask — ends with a final plain-English block titled
   `What I need from you:` — each open item one specific question a person who
   has never read the framework can answer; a framework code appears only with
   a plain-language gloss beside it. An enumerable choice is presented through
   the AskUserQuestion tool — single-select, one question per open item, the
   stop's items batched into one call, each with an "other / free text" escape;
   options are lettered (a, b, c …) and exactly one per question carries
   `(recommended)` — the pinned default or safe disposition where one exists,
   else the best-grounded suggestion. The marker is a label only: it never
   pre-selects and never auto-applies. No AskUserQuestion in the runtime → the
   same lettered list plus "reply with the letter". Selections are transcribed
   into the existing pinned reply and record grammar; typed token shortcuts
   stay legal, never the only channel. The ask is appended after the pinned
   render and replaces nothing. Under a standing autonomy grant this rule is
   inert for the two renders the exemption names — the band-boundary report and
   the resumption report. It reaches the mid-grant stop report: that render
   ends the turn awaiting a BA act, and the ask follows it.

## Autonomous mode — the autonomy grant

`/ba-auto on` writes **`AG-<n>`** into the aspect-state ledger, flips the head's
`Auto:` line, and logs the event. The profile comes from the argument, or is
inferred and logged (`canvas.md` present → Presale); **it never switches
mid-auto**.

**An autonomy grant moves the *moment* the BA states a decision, never the
*content* of one.** A transition under a recorded, revocable grant is **not a
self-clear**: the initiative is the BA's, stated in the grant, and every AUTO
transition stands for ratification at `off`. A standing grant is explicit
consent recorded in advance — **not silence**. Absent a grant, silence still
consents to nothing.

**What runs AUTO.** Plan composition as-recommended, the grant standing as the
route `go` · defer batches, with **unclear still an Open Question, never an
invention** · clearing when every criterion is met, otherwise an auto-AW whose
revisit trigger is `BA ratification sweep (auto off)` — carrying its **expected
profile debt** class where every miss resolves to an out-of-profile technique's
artifact, rendered as the class and never as a finding · waiver acts, Band-1
closure, Band-3 entry · **the arming run** — `/ba-gate-health full`, the closing
step of Band-1 closure, requested inside the same act so **no run ever stands
"closed but unarmed"**, its P8 HA review riding the ratification batch · a reopen
ruling defaulting to Real, blast radius stated,
**no cascade executed** · an overflow ruling taking the **supplement lane**
only. At the gate: **waivers AUTO on real gaps, overrides never**, and the
non-waivable set fixed and re-gated, never bypassed.

**What the grant reaches — the cost boundary.** The list above says who *states*
each stop; this says which *acts* the run may start on its own: **AUTO may
self-elect any act that spends no client access and makes no external
commitment, and every self-election lands in the ratification batch like any
other AUTO act.** Outside the boundary: anything that spends **client access** —
a call, a workshop, an interview slot, a stakeholder's reply — or makes an
**external commitment** a person outside the run must honour. **The framework
schedules nobody's time.** `recommended` is not the boundary: under Presale,
Tier 1 — epic scoping is always `optional` (no threshold criterion demands a
brief), so a run that waited for a recommendation would never produce one and
never reach the profile's own draft-spec destination. **Election stays the BA's
act** — under a grant it is taken by deferred batch ratification, the instrument
Band-1 closure already rides. **The pinned Presale instance:** with no client
call available, at Band-2 exit self-elect **Tier 1 — epic scoping in ingest mode
over captured client material** for every epic allocated to the first phase —
**kit and brief per epic** — then P-O8 — Band-3 entry → Tier 2 — spec-depth
gap-filling in assumption posture → draft specs. **The call stays BA-elected:**
write the kit, **never book the session it was written for**. An epic whose
slicing hangs on an open question **still gets its brief**, the dependency in its
Open Questions and named in the resumption report.

**An un-electable act renders as a choice, never as a failure.** An act outside
the cost boundary, outside the grant's own `scope:`, or awaiting a BA election
renders as law — `Destination reached — <what stands> · extension available by
election: <act — code + name> · <what it needs>`. **`blocked`, `locked` and
`cannot proceed` describe a defect;** a pending choice is not one. No pinned
shape changes: this governs what fills the band-boundary report's `Next act:`
line, the resumption report's `Next manual act:` line, and every run narration.

**The stamp:** `<date> · AUTO (AG-<n>) · <act> · <basis>`.

**The safety floor — outside every grant, in every profile:** the two ⚑
sign-offs (CC-XA-01, CC-XA-06), the effective PASS, `/ba-handoff`, and **the
scope frame** (P-O0b — scope-frame selection). The first three are where a false
pass is a security incident, a scope escape, or code built on unread text; the
fourth is the constraint every later act is measured against. Per feature, auto
ends at **"done, awaiting ratification"**. Never grant yourself a grant.

**Continuity under the grant.** Under a standing grant, **no conversational
render occurs between acts**, and the run **never ends its turn between acts
inside a band**. Every record — AUTO stamps, auto-AWs, deferrals, open questions
— goes to the **ledger and the auto-trail only**. The run proceeds continuously
until exactly one of four events: **a band boundary** (P-O7 — Band-1 closure ·
P-O8 — Band-3 entry) · **a safety-floor stop** (the ⚑ sign-offs · the effective
PASS · `/ba-handoff` · P-O0b — scope-frame selection) · **exhaustion of the
grant's scope** · **`off`**. The middle two render the **mid-grant stop report**
below. A conversational render **ends the turn**, so under
a grant a mid-band render is a de-facto stop — the exact thing the grant was
written to remove.

**The band-boundary report — pinned shape**, rendered after the
P-O7 — Band-1 closure or P-O8 — Band-3 entry stamp. The stamps stay AUTO and ratification stays one batch act at `off`: this
is a **render, not a ratification point**. Render it, **end the turn**; the grant
stands, and the BA's next message resumes the run:

```
Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>
Auto-trail since <start | last boundary>: <n> acts
Assumptions: <n> · Open questions: <n>
Health refresh: <current | overdue: <r> runs vs cadence>
Next act: <one line> — any reply continues · /ba-auto off renders the resumption report
```

**The mid-grant stop report — pinned shape**, rendered at a **safety-floor
stop** or at **exhaustion of the grant's scope**. One class: auto halts
mid-grant and hands control back, the grant **not closed** and **no
ratification asked**. Render it, **end the turn**:

```
Auto paused — <date> · <safety floor: <act — code + name> | scope exhausted: <the AG's scope edge, as AG-<n> states it>>
Stands: <what the run completed, one line> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail since <start | last boundary>: <n> acts · Assumptions: <n> · Open questions: <n>
Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>
```

**The closing ask follows these four lines** — the AUTO exemption reaches the
other two reports, not this one: this render ends the turn awaiting a BA act.
At a **safety-floor stop the grant stands** and the run continues under the same
`AG-<n>`; at **scope exhaustion it reaches no further**. It opens no new path
and asks for no ratification.

**The resumption report — pinned shape**, rendered at `off`:

```
Auto off — <date>
Stopped at: <point> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail: <n> acts — one line each: <date> · AUTO (AG-<n>) · <act> · <basis>   (the pinned default)
Auto-trail: <n> acts — ratified in this reply · full trail: .specify/aspect-state.md Events   (renders instead, and only, where a full ratification already stands)
Assumptions: <n> · Open questions: <n>
Ratify: accept all / list exceptions
Next manual act: <one line>
```

Ratification is one batch act; exceptions reopen their items manually. **The
trail line has one conditional:** a **full** ratification already standing —
nothing excepted — collapses it to its count plus the ledger pointer; a
ratification naming exceptions prints the full trail, because an act nobody can
see is an act nobody can except. The acts live append-only in
`.specify/aspect-state.md` either way, and the report is still six lines.

**The scope-advisory decision list — a conditional tail on both reports.** Where
the ledger head's `Scope advisories:` line carries at least one **`standing`**
entry, those two reports render the list as a **tail after their last pinned
line** — never the mid-grant stop report, which rules nothing and closes no
grant;
where no entry stands, **nothing renders**. **The pinned shapes above do not
change** — five lines and six, byte for byte — and the tail is an addition,
never a replacement:

```
Scope advisories — <n> standing · decide each (P-A1 row shape — source-audit definition §5)
Rulings: apply all · apply all except <#…> · <#>: <letter> <argument>
```

**The row shape is P-A1's — cited, never restated:** each row the finding with
its **verbatim citation**, lettered dispositions, and a default such that
**`apply all` is a complete, safe ruling**. **Three dispositions:** **(a)
`hold as advisory — no move`, the default** — nothing moves, the row returns at
the next ratification · **(b) `direct a move → <phase>`** — riding
T-18 — Scope allocation's existing machinery as a BA-directed candidate, tagged
`BA-directed (ADV-<n>)`, **never an inline phase edit** · **(c)
`accept — <reason>`** with an event-shaped revisit trigger on the SA record
pattern, returning to the list the moment a new source or a new `SD-<n>`
re-asserts the finding. **No disposition ends a finding without a reason.**
**Where the ruling lands:** under a grant, the existing `ratification` event; in
manual mode, the **T-18 — Scope allocation run-log entry** whose step-4 approval
carried the list — **no new event kind, no new prompt point, and no act named
*the manual ratification batch***. **Assembling the list may be AUTO; ruling it
never is — an AG never answers it**, and the list reaches no client artifact.

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
