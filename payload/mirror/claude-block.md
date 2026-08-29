<!-- ba-native-spec:begin -->
## BA-Native Spec

This project runs **BA-Native Spec** — Spec-Driven Analysis on top of Spec Kit.
Analysis is a gated, BA-conducted process; the spec `/speckit-plan` reads has
been certified by a completeness gate. `AGENTS.md` carries the same writing
rules for any AGENTS.md-reading tool — the two files are written from one
source and do not diverge.

### Spec writing essentials

**The premise:** you read exactly what is written. Do not infer, do not fill a
gap with a confident guess — a gap is either marked or it is a defect.

1. **Write the WHAT, never the HOW.** No frameworks, databases, endpoints, or
   UI layouts in a spec. The technical solution belongs to `/speckit-plan`.
2. **One requirement, one statement, one ID.** Never chain behaviors with
   "and/or".
3. **Every domain term comes from `.specify/memory/glossary.md`.** Add it there
   first, then use it. No synonyms.
4. **Structured data goes in tables, never prose.** Sets of values — permissions,
   fields, states, integrations. One SHALL is not a set: stories and FRs are
   lines, never table rows.
5. **Reference, never restate.** Roles, permissions, entities, and global
   standards are defined once in governance/context files.
6. **If it can't be tested, it isn't a requirement.**
7. **Mark gaps, don't hide them** — `[NEEDS CLARIFICATION: <question>]`, the
   spec's only marker: `[ASSUMED: …]`, `[TBD]` and every other bracket tag are
   illegal and fail CC-G-02 as a mint; an assumption is never a behavior —
   draft the value and mark it `[NEEDS CLARIFICATION: confirm <value> — basis:
   <inference>]` (standard rule 7 · elicitation §5.3).
8. **No stubs.** Real content or `N/A — <reason>`.

**The spec skeleton — ten sections, exact names, exact order** (parsed
structurally; never rename or reorder): Overview & Value · User Stories ·
Functional Requirements · Flows, States & Errors · Non-Functional Requirements ·
Business Rules · Data Requirements · Integration Touchpoints · Out of Scope ·
References. **Unnumbered** — the § numbers used to cite them are the standard's
list numbering, never part of the heading (`## User Stories`, not
`## 2. User Stories`). Copy `.specify/templates/spec-template.md` and fill it in
place; a numbered heading matches no checker and reads as an *empty* spec.

**Stories:** `US<N> (P<1|2|3>) — As a <role>, I want <capability>, so that
<value>.` Roles verbatim from `roles-permissions.md`; "as a user" and persona
names fail. At least one P1. IDs stable, never reused.

**Functional requirements — EARS, one SHALL each, response externally
observable:**

| Pattern | Template |
|---|---|
| Ubiquitous | THE SYSTEM SHALL `<response>` |
| Event-driven | WHEN `<trigger>`, THE SYSTEM SHALL `<response>` |
| State-driven | WHILE `<state>`, THE SYSTEM SHALL `<response>` |
| Unwanted behavior | IF `<condition>`, THEN THE SYSTEM SHALL `<response>` |
| Optional feature | WHERE `<feature included>`, THE SYSTEM SHALL `<response>` |

Every FR carries `FR-0NN (US<n>)` and names its actor and specific object.

**Acceptance — one slot, two forms:** a checklist line for a simple rule,
validation, permission, or field constraint; a Gherkin scenario only for
multi-step or branching behavior, always with concrete data. A scenario that
re-narrates its FR must become a checklist line.

**Banned words** — each is a hidden guess: *fast, quickly, easy, simple,
user-friendly, intuitive, appropriate, adequate, sufficient, efficient,
flexible, robust, seamless, some, several, many, minimal, improve, better,
handle, support, manage, process (without an object), etc., and/or, as needed,
if necessary, TBD.* Replace with a number, a named behavior, or a
`[NEEDS CLARIFICATION]`. Exemption: verbatim user-visible copy in quotes.

**NFRs:** metric + target + condition, feature-specific deltas only. All six
categories carry an NFR or an explicit `N/A — <reason>`: performance ·
security/privacy · availability · accessibility · localization · scale.

**Flows:** numbered main flow (actor → action → observable result) plus every
error path with trigger + system behavior + user-visible outcome. Happy-path
only fails.

**Out of Scope:** at least one exclusion; each names where it lives instead.

### Commands — the `/ba-*` namespace

All 35 are **BA-invoked, never auto-fired** (`disable-model-invocation: true`).
Do not invoke them on your own initiative and do not simulate their effects.

**Workflow — 17**

| Command | Act |
|---|---|
| `/ba-frame` | Band-1 entry: initialize the two aspect ledgers, then one render and one reply — take the source inventory (captures land under `sources/`, states on the head's `Sources:` line), pick the flow profile (P-O0 — flow-profile selection) and set the scope frame (P-O0b — scope-frame selection, auto-pickup pre-filled) — confirm the canvas |
| `/ba-status [--html]` | Render the aspect-ledger head and the nine-line project dashboard; `--html` also writes the derived offline render |
| `/ba-aspect <aspect>` · `/ba-aspect band2` | Open an aspect (suggestion snapshot → plan composition), or compose the `## Band 2` section's plan — nothing opens; Band-1 closure is the door |
| `/ba-t<NN>` · `/ba-tier1` · `/ba-tier2` | One-step technique run — the P-O3 (technique invocation) check compiled in; `/ba-run <id>` = alias + custom runner |
| `/ba-run` | Run the composed plan as a route: the pinned route render, then every row on one `go` — no per-row acknowledgement |
| `/ba-run specs all` · `/ba-run specs <epic-list>` | Batch Band-3 entry: one P-O8 (Band-3 entry) table, then Tier 2 per feature, one consolidated defer-confirm |
| `/ba-clear <aspect>` | Evidence table → clearing confirmation |
| `/ba-waive-aspect <aspect>` | Grant · re-affirm · lapse an aspect waiver |
| `/ba-reopen <aspect>` | Rule and execute a reopen signal |
| `/ba-close-band1` | Closure preconditions → closure record → arming health run |
| `/ba-enter-feature <epic>/<feature>` | Band-3 entry: confirm slicing, assign `NNN` |
| `/ba-gate <feature>` | Scope-F gate run, stages 0–5 |
| `/ba-gate-health [artifact \| full]` | Scope-H project health run |
| `/ba-wbs [--include NNN …]` | The WBS export — `exports/wbs.xlsx` + `exports/wbs.csv`, read-only |
| `/ba-dev-ready <feature …>` | From the presale estate to dev-ready: the switch, a scoped grant, the four missing techniques, specs completed, the gate per feature — you say `go` once |
| `/ba-design` | The design-guide export — `exports/design-guide.md`, read-only: what the captured material states about visual identity, cited; the pinned none-record where it states nothing |
| `/ba-audit [--full \| --report]` | The Scope-S source audit over the whole band: obligations register → two-way trace → one P-A1 (source-audit ruling) decision list, every row carrying its source quote, its band-wide search set and a default → ruled repairs → incremental re-audit → the coverage report, `exports/audit-report.xlsx` + `exports/audit-report.csv`, four pinned sheets over the post-repair state; a run is not closed until it renders, and `--report` re-renders it from the latest closed run without a new audit |
| `/ba-auto on [<profile>]` · `/ba-auto off` | Autonomous mode: write or close the autonomy grant `AG-<n>`; `off` renders the pinned resumption report for one batch ratification |

**Techniques — 20** (one-step via `/ba-<id>`; the P-O3 (technique invocation) check compiled into each; `/ba-run <id>` aliases)

| ID | Technique | Lands in |
|---|---|---|
| `t01` | Discovery canvas framing | `canvas.md` |
| `t02` | Glossary discipline | `memory/glossary.md` |
| `t03` | Stakeholder register | `memory/stakeholders.md` |
| `t04` | Persona charters | `memory/personas.md` |
| `t05` | Context & landscape mapping | `memory/context.md` |
| `t06` | Constraints elicitation | `memory/constraints.md` |
| `t07` | Competitive analysis | `memory/competitive-analysis.md` · canvas §10 |
| `t08` | Value definition | `canvas.md` §§2, 12 |
| `t09` | Vision & differentiation | `canvas.md` §§3–5, 11 |
| `t10` | Solution surface review | `canvas.md` §§6–9 |
| `t11` | Domain (conceptual) modeling | `memory/domain-model.md` |
| `t12` | Roles & permissions | `memory/roles-permissions.md` |
| `t13` | Core process mapping | `memory/processes.md` |
| `t14` | Design & UX standards | `memory/design-standards.md` |
| `t15` | Constitution | `memory/constitution.md` |
| `t16` | Global out-of-scope | `memory/out-of-scope.md` |
| `t17` | Epics decomposition | `memory/roadmap.md` |
| `t18` | Scope allocation (repeatable) | `memory/roadmap.md` — Phase + log |
| `tier1 <kit\|ingest\|supplement> <epic>` | Epic scoping interview | `memory/scope/<epic>.md` |
| `tier2` | Spec-depth gap-filling | `specs/NNN-<feature>/spec.md` |

**Superseded — 1**

`/speckit-constitution` — **superseded by `/ba-run t15`**. `constitution.md`
is born from Band-1 evidence at T-15 — Constitution, never from a template; a template-born
file is governance ground manufactured outside the evidence chain. Do not
invoke the Spec Kit skill, and do not follow Spec Kit's Next Steps panel
where that panel advertises it.

### Stops and routes — the checkpoint law

A stop is legitimate only where the BA decides between materially different
outcomes or accepts debt: plan composition, clearing, waiver, override, reopen
ruling, defer batch, overflow ruling, profile switch, band transition. A stop
that only collects an acknowledgement is a banned class — where no decision
exists, proceed and report.

**Plan-as-route.** The composed plan is a route. One BA act — `go` on the
rendered route, or `/ba-run` with no argument — runs its rows in order, each
under its own P-O3 (technique invocation) discipline, without per-row
acknowledgement. The route stops only at the decision points above, or on a
contract miss, which stops it with the single unblocking act named. No state
change without a BA act: the `go` **is** that act, its extent named in the
render. Silence is never consent — a route runs only on a stated `go`.

**The route render — pinned shape:**

```
Route — <destination, one line> · profile: <profile>
| # | Code — technique | Yields |
|---|---|---|
| 1 | T-08 — Value definition | canvas Problems + Objectives |
Stops en route: <the decision points, or none>
Next: step 1 — go?
```

**Auto-repair.** When the BA states a destination the current state cannot
reach, propose the repair as one act: the mismatch in one line, the repair route
in the shape above, then `go?`. Handing the BA a list of commands to type is a
banned render — after the `go`, execute the mechanics yourself. **The
dev-ready outcome is a recognized destination:** a plain sentence naming it
renders the `/ba-dev-ready <feature …>` route (its own skill) and waits for
its `go` — named by outcome, never by mechanism.

### Autonomous mode — the autonomy grant

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
sign-offs (CC-XA-01, CC-XA-06), the effective PASS, and **the scope frame**
(P-O0b — scope-frame selection). The first two are where a false pass is a
security incident or a scope escape; the third is the constraint every later
act is measured against. Three acts the BA answers for personally. The
certified-text check is not on the floor: it runs by itself as
implementation's own first act at take-up (gate §11.2), and a grant reaches
it no more than it reaches any coding-side act. Per feature, auto ends at
**"done, awaiting ratification"**: the ⚑ sign-offs and the PASS wait for a
human — left pending, named in the stop report's tail, while the run proceeds
(§7.6). Never grant yourself a grant. The floor is the signature, never the
evaluation: the two ⚑ assertions are computed at Stage 3 on every run and under
any grant — gate §5.3, which this floor consumes by reference.

**Continuity under the grant.** Under a standing grant, **no conversational
render occurs between acts**, and the run **never ends its turn between acts
inside a band**. Every record — AUTO stamps, auto-AWs, deferrals, open questions
— goes to the **ledger and the auto-trail only**. The run proceeds continuously
until exactly one of four events: **a band boundary** (P-O7 — Band-1 closure ·
P-O8 — Band-3 entry) · **a safety-floor stop** (the ⚑ sign-offs · the effective
PASS · P-O0b — scope-frame selection) · **exhaustion of the grant's scope** ·
**`off`**. The middle two render the **mid-grant stop report** below. A floor
stop halts the run only where the remaining scope depends on the floor act —
the scope frame's case; a feature's ⚑ sign-offs and its PASS are left pending,
named in the tail, and the run proceeds (§7.6). A conversational render **ends the turn**, so under
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

**Its closing ask — a pinned tail, never composed at the stop**, after the
report's last line and after the decision-list tail where that renders:

```
What I need from you:
1. Band <n> is closed under the grant. How do we proceed?
   a. continue — <the report's Next act line, in plain words> (recommended)
   b. pause and ratify — /ba-auto off; the resumption report renders
   c. correct something first — name it
Reply with a letter, or in your own words — any reply continues.
```

`<n>` is the band the boundary leaves behind — Band 1 at P-O7 — Band-1
closure, Band 2 at P-O8 — Band-3 entry. Where the health line renders
`overdue`, one option joins before c, re-lettering c to d — `run
/ba-gate-health full first — it is overdue; no grant reaches it, this stays
your act` — recommended staying on continue: the health line is display only
and the refresh act stays the BA's. Where the decision-list tail renders, its
items join the ask as questions in **T-18 — Scope allocation's** step-4 shape,
`hold as advisory — no move` recommended; the typed ruling grammar stays the
shortcut. Still a render, not a ratification point: the ask takes no ruling on
the trail, option b routes to the existing `off` act, and the recommended
option is the continue.

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

**Its closing ask — the same pinned tail**, after the report's last line and
after the decision-list tail where that renders:

```
What I need from you:
1. <n> AUTO acts stand for ratification. Your call?
   a. ratify all (recommended)
   b. ratify all except — name the acts
   c. discuss first — ask me anything about the trail
Reply with a letter, or type the Ratify line's own grammar: accept all / list exceptions.
```

Taking (a) is the existing one-batch ratification exactly — the typed grammar
and the ask can never disagree (the apply-all precedent: **T-18 — Scope
allocation's** step-4 ask, where taking every recommended option **is**
`apply all`). Option b is `list exceptions` in lettered form over the full
trail above; option c invents no state — the acts already stand awaiting
ratification. Advisory items join as questions exactly as at the band
boundary. **Ratification stays the grant's instrument at `off`.**

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

### BA-facing communication register

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
   render and replaces nothing. Under a standing autonomy grant the two renders
   the exemption names — the band-boundary report and the resumption report —
   keep their pinned shapes byte-untouched, and each carries the ask as an
   additive tail in its own pinned shape: what the exemption grants is shape,
   not silence. The rule reaches the mid-grant stop report in full: that render
   ends the turn awaiting a BA act, and the ask follows it.
10. **The humanizer switch (D-O97).** The estate carries a vendored `humanizer`
    skill — upstream `blader/humanizer`, pinned, MIT — at
    `.claude/skills/humanizer/`, and a switch that says when it runs:
    `/ba-humanizer on|off`. The switch is the **BA's standing instruction** —
    it persists across sessions until `off`, takes no ratification, and no
    grant reaches it. **Default off:** a ledger with no `Humanizer:` line reads
    `off`. **While on**, every render you send the BA and **every artifact
    whose content is prose at the moment it is written** — `spec.md` bodies,
    `exports/design-guide.md`, the handoff brief, client-facing summaries, any
    other prose markdown the framework writes — passes through the vendored
    skill in embedded mode (final text only, every claim kept, nothing
    invented) **before display or write**. **The fence is the machine-read
    line, never the file.** Byte-untouched: the two runtime ledgers entire,
    gate and audit records, `BUILD-LOG.md`; every pinned shape, block and line;
    every ID and marker token (`SD-<n>`, `XO-<n>`, `AS-<n>`, `ADV-<n>`,
    `AG-<n>`, `OB-<nnn>`, `AT-…`, `CC-…`, `D-O<n>`, `US<n>`, `FR-<n>`, §-refs,
    `[NEEDS CLARIFICATION]`, ⚑); every table row, code fence, front-matter
    block, path, command, link target, number, date and quotation. Rewrite
    sentences and paragraphs; **never rewrite structure**, and never merge or
    split a paragraph holding a pinned line. **The writing standard is
    senior** — on conflict it holds and the humanizer yields. **The guard is
    asserted, never declined:** every file write under `on` runs
    `sk_humanizer_guard.py`; pass writes the candidate, fail writes the
    **original** and appends one tail line
    `Humanizer: skipped — guard failed on <anchor>` — never a stop, never a
    block. A chat render is checked by you as a self-check before emitting.
    Ruling: **D-O97, §43**; pin and provenance **D-O89, §38**, standing.
11. **Named by outcome (D-O96).** A route or a command is named by the
    **outcome the BA wants, in the BA's words** — never by its mechanism.
    `/ba-dev-ready` (§7.6) is the ruled instance; a plain sentence naming the
    outcome is a legal entry to any named route, on the D-O32 pattern. A name
    that says how the framework gets there is a naming defect, corrected at
    the name.

### Analysis session — the default mode

**Reader: you, in this conversation.** Every conversation in this project starts
here and stays here, for every feature that has not reached its effective PASS. The rules below are yours.

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
this framework conducts is an **analysis session**. An analysis session
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not
as initiative. The boundary lifts **per feature**, by the **effective PASS at
the gate alone** (gate §11; D-O95 — the pair's second member, the handoff as a
BA act, is gone: the certified-text check runs as implementation's own first
act, gate §11.2, and is never a lift condition). Downstream of the PASS,
implementation belongs to the coding agent and the operator; the analysis
session continues unchanged for every other feature. Standing project
instructions (the compiled CLAUDE.md block, AGENTS.md) carry two addressed
modes — analysis-session rules and coding-agent rules — and every instruction
names its reader; an instruction addressed to the coding agent is inert in an
analysis session. Wanting to implement is never evidence of readiness: the only
exit is the gate.

Here that is `/ba-gate <feature>` reaching an effective PASS. Until it lands
for a feature, you are in analysis mode for it.

- **You never author.** You schedule, route, and record. Content is authored by
  techniques and the BA; checks are run by the gate. If a step seems to need you
  to edit `canvas.md`, a file under `.specify/memory/`, a brief, a spec or code —
  it is not your step.
- **You never decide alone.** Where a skill names a P-O checkpoint, stop there
  and take the ruling; never infer it from the evidence looking complete, from
  context, or from the BA having ruled the same way before.
- **Runtime ledgers are not content.** `.specify/aspect-state.md`,
  `aspect-plans.md`, `gate-health.md`, `gate-tuning.md`, and
  `elicitation-tuning.md` are the framework's operational state. Never edit
  them, never mirror them into a spec, never treat them as project context.

### Coding agent — downstream of handoff

**Reader: the coding agent taking a feature into implementation.** Your
first act on the feature is not yours: before `/speckit-plan` or any
implementation act, the certified-text check runs —
`python3 .specify/ba/scripts/sk_handoff.py <feature> --root .` — and you
proceed only on a silent exit. A refusal means the feature is not yours to
build yet: its message names the file and the two routes, and you take
neither — you report it. A feature with no effective PASS refuses the same
way.

- **The certified text is the read text.** A spec that reached `/speckit-plan`
  passed the gate and its hashes were verified when you took it up. Editing
  it silently voids that certification. Spec errors are fixed **in the spec** and re-run
  downstream — never hand-patched in code.
- **A `[NEEDS CLARIFICATION]` marker you find in a certified spec is deliberate**
  — a consciously accepted, waivered unknown. Implement around it and surface
  it; do not resolve it by guessing.
- **Never invent a role, term, entity, or constraint.** If a spec needs one that
  does not exist upstream, that is a gate defect — report it, don't author it.
<!-- ba-native-spec:end -->
