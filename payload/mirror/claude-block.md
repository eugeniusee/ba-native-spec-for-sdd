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
4. **Structured data goes in tables, never prose.**
5. **Reference, never restate.** Roles, permissions, entities, and global
   standards are defined once in governance/context files.
6. **If it can't be tested, it isn't a requirement.**
7. **Mark gaps, don't hide them** — `[NEEDS CLARIFICATION: <question>]`.
8. **No stubs.** Real content or `N/A — <reason>`.

**The spec skeleton — ten sections, exact names, exact order** (parsed
structurally; never rename or reorder): Overview & Value · User Stories ·
Functional Requirements · Flows, States & Errors · Non-Functional Requirements ·
Business Rules · Data Requirements · Integration Touchpoints · Out of Scope ·
References.

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

All 32 are **BA-invoked, never auto-fired** (`disable-model-invocation: true`).
Do not invoke them on your own initiative and do not simulate their effects.

**Workflow — 12**

| Command | Act |
|---|---|
| `/ba-frame` | Band-1 entry: initialize the two aspect ledgers, confirm the canvas |
| `/ba-status` | Render the aspect-ledger head |
| `/ba-aspect <aspect>` | Open an aspect; suggestion snapshot → plan composition |
| `/ba-run <technique> [args]` | Contract check, then dispatch a technique |
| `/ba-clear <aspect>` | Evidence table → clearing confirmation |
| `/ba-waive-aspect <aspect>` | Grant · re-affirm · lapse an aspect waiver |
| `/ba-reopen <aspect>` | Rule and execute a reopen signal |
| `/ba-close-band1` | Closure preconditions → closure record → arming health run |
| `/ba-enter-feature <epic>/<feature>` | Band-3 entry: confirm slicing, assign `NNN` |
| `/ba-gate <feature>` | Scope-F gate run, stages 0–5 |
| `/ba-gate-health [artifact \| full]` | Scope-H project health run |
| `/ba-handoff <feature>` | Mode-A adapter: hash guard, branch, ready report |

**Techniques — 20** (invoke via `/ba-run <id>`; the contract check lives there)

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
   render past ~10 lines is a cut candidate.
8. **Pinned formats stay pinned.** Recurring renders (suggestion snapshot §6.1,
   ledger head §2.4, P-O prompts) keep their shapes; never re-narrate what a
   format already shows. On conflict between this register and a pinned shape,
   the shape governs.

### Discipline

- **Runtime ledgers are not content.** `.specify/aspect-state.md`,
  `aspect-plans.md`, `gate-health.md`, `gate-tuning.md`, and
  `elicitation-tuning.md` are the framework's operational state. Never edit
  them, never mirror them into a spec, never treat them as project context.
- **The certified text is the read text.** A spec that reached `/speckit-plan`
  passed the gate and its hashes were verified at handoff. Editing it silently
  voids that certification. Spec errors are fixed **in the spec** and re-run
  downstream — never hand-patched in code.
- **A `[NEEDS CLARIFICATION]` marker you find in a certified spec is deliberate**
  — a consciously accepted, waivered unknown. Implement around it and surface
  it; do not resolve it by guessing.
- **Never invent a role, term, entity, or constraint.** If a spec needs one that
  does not exist upstream, that is a gate defect — report it, don't author it.
<!-- ba-native-spec:end -->
