# BA quickstart

**For the business analyst.** How to run BA-Native Spec on a real project —
and, if the package is not installed where you are, how to run the same method
from the documents alone.

You do not need to read the methodology corpus to use this. The corpus is what
the package was compiled *from*; the skills carry the operative rules with them.

---

## What this is, in one paragraph

Spec-Driven Development starts at a spec. This is the layer before that: it
takes a project from a presale conversation to a **gate-certified feature
spec** that a coding agent consumes without a human re-explaining anything. It
does that in three bands — discover the project, decompose and scope it, then
deliver features one at a time — with a completeness gate at the end that either
passes or comes back with **named gaps**. You stay the author and the authority
throughout: the framework schedules, drafts, checks, and refuses; it never
decides.

---

## Install

One line, run inside the project folder you want the framework in:

```sh
curl -fsSL https://raw.githubusercontent.com/eugeniusee/ba-native-spec-for-sdd/main/bootstrap.sh | bash
```

No clone, no GitHub account, nothing to check out first. It fetches the package,
runs `git init` for you if the folder is not a repository yet, and installs into
it. You need `git`, `python3` 3.11 or newer, and `bash` on the machine. `uv` is
needed too, but you do not have to install it first: if the machine has none,
the bootstrap installs it for you through astral.sh and says so as it goes.

If the package is already checked out somewhere — or you want to install from a
copy pinned to a known version rather than from `main` — run the installer
directly. This path installs nothing on your behalf, so `uv` has to be there
already:

```sh
cd /path/to/your/project        # must be a git repo
/path/to/ba-native-spec/install.sh
```

Either way it runs pinned Spec Kit v0.12.5, overlays the framework, writes the
`AGENTS.md` and `CLAUDE.md` mirrors, and generates `.specify/ba/manifest.md`.
Re-running is safe: it replaces installer-laid files and the fenced mirror
blocks only, and never touches your content, your ledgers, or `specs/`.

Then open Claude Code in the project. Everything below is a `/` command.

**One thing to notice about a fresh install:** `.specify/memory/` is empty and
there is no `canvas.md`. That is deliberate. An empty file and a missing file
are the same hole to every check in this framework, and a field of
installer-made stubs would make every one of those checks lie. Each artifact is
born by the act that produces it.

---

## Band 1 — discovery

```
/ba-frame
```

Initializes the two ledgers, then asks once for the three things Band 1 is run
against: the **source inventory** — what material exists beyond what you handed
over, Slack channels, email threads, drive folders, call recordings, named,
pasted, attached or declined — the **flow profile**, and the **scope frame** —
delivery boundary, budget envelope, client label, and the rate and team mix
behind the capacity line. All three blocks render together and you answer them
in one reply; the framework pre-fills the frame from whatever material is on
hand, with citations. Sources it can reach are captured verbatim under
`sources/`; ones it cannot take your ruling — supply, skip, or leave pending —
and every named source stands on the ledger head's `Sources:` line with its
state. Then, if there is no
`canvas.md` yet, it runs the discovery-canvas technique to make one from your
presale material.
Six aspects open in dependency order: **Stakeholders → Context · Value → Vision
→ Solution → Requirements**.

Then, per aspect:

```
/ba-aspect stakeholders     # the framework suggests techniques from canvas evidence
                            # you compose the plan: select · drop · reorder · add
/ba-t03                     # run a technique from the plan
/ba-clear stakeholders      # evidence table → you confirm the aspect is cleared
```

`/ba-aspect` proposes; **you compose**. That is the whole shape of Band 1 —
the framework never picks your techniques, and every technique's compiled P-O3
check refuses a run that is not in the plan with its output contract pinned. If something you
learn later invalidates a cleared aspect, `/ba-reopen` rules and executes the
reopen; if an aspect cannot clear yet and you want to proceed anyway,
`/ba-waive-aspect` puts that decision on the record with a revisit trigger.

`/ba-status` renders where you are, at any moment.

When all six are cleared:

```
/ba-close-band1
```

which records the closure and fires the **arming health run** — from here on,
every framework write is silently health-checked, and you hear about it only
when something breaks.

---

## Band 2 — decomposition and scoping

```
/ba-aspect band2             # compose the Band-2 plan — snapshot, then your act
/ba-t17                      # epics decomposition → the roadmap
/ba-t18                      # MVP / Phase 2 / Later allocation, with a diff and a reason
/ba-tier1 kit E-03           # a stakeholder-call kit for one epic
```

The kit is a question set at **scoping depth only** — crucial and significant
areas, essential scope. Technical final-spec questions are forbidden there, and
the kit refuses to ask them. **You run the call.** Then:

```
/ba-tier1 ingest E-03        # your notes → the epic's scope brief
```

The brief comes back `Scoped`, with a **proposed feature slicing**: small epic →
one feature, large epic → two or three. Findings that belong somewhere else — a
new role, a new term, a constraint — are routed to their homes for your approval
rather than buried in the brief.

`/ba-t18` is repeatable on purpose. Re-run it whenever scope knowledge
changes; each run logs a diff and a reason on the roadmap.

---

## Band 3 — one feature at a time

```
/ba-enter-feature E-03/appointment-booking
```

Confirms the slicing row, assigns the next `NNN`, creates
`specs/NNN-appointment-booking/`.

```
/ba-tier2 004
```

The Tier-2 session loads the full project context **plus the parent epic's
brief**, drafts a first-cut spec around its user stories, and then asks only the
gaps — capped at seven by default, one at a time, each with a recommended
answer. Two guards are always on: **never ask what is already answered; never
ask what was not needed until now.** Every drafted value is either cited to its
source or marked as an assumption for you to confirm.

```
/ba-gate 004
```

The completeness gate. Machine checkers first, then an evaluator agent against
the contract's assertions, then your rulings: override a false positive, waive a
real gap you consciously accept, sign the two flagged evidence bundles, approve.
A FAIL comes back as named gaps — each with the element and the fix action — and
you fix the spec and re-gate. Re-gates are cheap: only what your edit could have
affected is re-run.

There is no handoff command. When the operator takes 004 into implementation —
the first `/speckit-plan` on it — the framework first checks that every
certified byte is still on disk, checks out the feature branch, and points Spec
Kit at the feature. Clean, it says nothing. **If anything was edited after
certification, implementation does not start**, and one message names the file
and the two ways out: keep the edit and re-gate, or revert it. That refusal is
the framework working, not failing.

Then the operator runs `/speckit-plan`, `/speckit-tasks`, `/speckit-implement`,
and you re-enter to verify the built feature against its acceptance tier.

---

## Presale — the whole path in eight interactions

The walkthrough above is Discovery: you open each aspect, compose each plan, and
rule at every step. Presale is the other profile — the minimum path to a scoped
roadmap and draft specs when client access is thin. It runs the same machinery
at a different granularity, and it is budgeted: **Frame to a rendered WBS fits
in eight of your interactions.** More than eight is a defect in the framework,
not a busy project.

The difference is that a composed plan is a **route**, not a queue of prompts.
You approve the route once; the framework runs its rows and comes back only
where you actually decide something.

**1 — Frame.**

```
/ba-frame Presale
```

The ledgers initialize, the profile and the scope frame are set — one render,
one reply — and the canvas is confirmed or drafted. Then the route renders:

```
Route — Presale: scoped roadmap + draft specs · profile: Presale
| # | Code — technique | Yields |
|---|---|---|
| 1 | T-08 — Value definition | canvas Problems + Objectives |
| 2 | T-09 — Vision & differentiation | canvas §§3–5, 11 |
| 3 | T-16 — Global out-of-scope | memory/out-of-scope.md |
| 4 | T-17 — Epics decomposition | memory/roadmap.md |
| 5 | T-18 — Scope allocation | roadmap Phase + log |
Stops en route: the defer batch · Band-2 transition
Next: step 1 — go?
```

**2 — `go`.** One word. Every row runs in order under its own invocation
discipline. Nothing asks you to acknowledge a step that carries no decision.

**3 — the defer batch.** The route stops where a decision exists: the questions
that cannot reach the client. You confirm the batch; each stands as its marker.

**4 — the Band-2 transition.** The route stops again at the band act. Note that
T-17 and T-18 rerun on the default route — the roadmap is never quietly
MVP-only.

**5 — batch entry and drafting.**

```
/ba-run specs all
```

One table with every feature's slicing row. Strike what you do not want by
number, confirm the rest in one act. Every confirmed feature enters Band 3, and
Tier 2 drafts each one in assumption posture — derivable content written,
inferred values marked.

**6 — the consolidated defer-confirm.** All the drafting's unreachable questions
arrive once, at the end, as one batch. Not once per feature.

**7 — the export.**

```
/ba-wbs
```

**8 — spare.** The budget has one interaction of slack in it by design, for the
correction the route did not anticipate.

What you hand the client is the roadmap, the draft specs with their assumptions
on the record, and the WBS. Certification is not the presale destination — it
sits behind gate law and happens after a recorded switch to Discovery. The
switch has a route, and the eight interactions end at the WBS, so the route sits
outside the budget:

**9 — to dev-ready.**

```
/ba-dev-ready 004 005
```

Or just say it — *віддай 004 і 005 в розробку* — and the same route renders. You
say `go` once, and that one word is three things: the profile switch to
Discovery, recorded; a grant scoped to exactly these features; and the route's
start. If a grant was already running, the framework closes it first and asks
you to ratify its trail — the one stop on the way, and an existing one. Then it
runs on its own: the four techniques Presale leaves out (domain model, roles and
permissions, core processes, constitution) drafted from the material on hand
with the assumptions marked, each spec completed against them, the gate run on
each feature with real gaps waived and named. It stops when every feature stands
**done, awaiting ratification**, and tells you plainly what is left for you:
ratify the batch, then per feature sign the two flagged bundles and approve the
PASS. Those are the acts that must be a person's, and the framework never takes
them.

**If the destination is out of reach,** say so plainly — "I need a WBS by
Friday" — and the framework answers with one repair route in the shape above,
ending in `go?`. It will not hand you a list of commands to type.

---

## When a change arrives

The estate stands — specs drafted or certified, the WBS sent — and someone
brings a change: the client wants a feature added, a designer wants a flow
simplified, a sponsor wants a module cut. You do not have to work out which
file it hits or which command moves it. Hand it to the framework:

```
/ba-change the client wants to drop online payment from booking — clients pay at the clinic
```

Or paste the message, attach the document, name the Slack thread — or just say
it in your own words. The change is captured word for word under `sources/`
and logged as `CR-<n>` before anything else happens, so even a change you
decline leaves a record.

Then one render, in three parts. **Targets:** every artifact the change touches
and the state each is in — a certified spec, a draft, a scope brief, an epic on
the roadmap, a rule in the constitution — read from the ledgers, never guessed;
if the change names something the estate does not hold, the framework asks
which of the things it does hold you mean. **Consequences:** for each target,
what taking the change would do under the rules that already exist — this spec's
PASS lapses and it re-gates cheaply; this brief edit means its sibling re-gates
too and the scope-boundary check comes back to you; this epic moves phase
through the allocation log; this acceptance item the client gave us is
superseded by their own new statement; three WBS rows drop. Never a block —
visibility. **The route:** one route in the shape you know, built only from acts
the framework already has, ending in one question:

```
What I need from you:
1. Take this change, decline it, or hold it?
   a. take — run the route above (recommended)
   b. decline — nothing moves; your reason goes on the record
   c. hold — until an event you name; it comes back when that moment renders
```

`take` is the `go`. The route runs through the stops those acts already own —
the allocation diff for your approval, the brief-edit batch, the re-gate's
verdict review — and when the last of them has written its own record the
change reads `landed` on the ledger head with a pointer to every place it went.
`decline` records your reason and moves nothing. `hold` parks it against an
event — *when 004 enters delivery* — and it comes back on its own when that
moment renders; never a date.

`/ba-status` shows every change and its state in one tail line. Under
autonomous mode a change you bring mid-run is asked about right then, and a
change nobody has ruled yet is named on every auto report — the framework never
takes one on its own, and never recommends declining one: that call is yours.

**Not covered yet, on purpose:** a feature already in implementation or
delivered still follows the gate's own sentence — fix the spec, re-gate, and
implementation takes it up again — but a named route and a roadmap status for
that case wait for a field run.

---

## The command index

| Command | What it does |
|---|---|
| `/ba-frame` | Band-1 entry: ledgers initialized, profile and scope frame set, canvas confirmed or created |
| `/ba-status` | Where everything stands |
| `/ba-aspect <aspect>` | Open an aspect: suggestions → you compose the plan |
| `/ba-t<NN>` · `/ba-tier1` · `/ba-tier2` [args] | Run a planned technique — one step |
| `/ba-clear <aspect>` | Evidence table → you confirm the clearing |
| `/ba-waive-aspect <aspect>` | Grant · re-affirm · lapse an aspect waiver |
| `/ba-reopen <aspect>` | Rule and execute a reopen |
| `/ba-close-band1` | Closure + the arming health run |
| `/ba-enter-feature <epic>/<feature>` | Band-3 entry: confirm slicing, assign `NNN` |
| `/ba-gate <feature>` | The completeness gate |
| `/ba-gate-health [artifact\|full]` | Project health across the shared artifacts |
| `/ba-wbs [--include NNN …]` | The client-facing WBS → `exports/wbs.xlsx` + `.csv` |
| `/ba-dev-ready <feature …>` | From the presale estate to dev-ready: the switch, a scoped grant, the four missing techniques, specs completed, the gate per feature — you say `go` once |
| `/ba-change <the change …>` | A stakeholder's change, received and located: what it touches, what taking it does under the standing rules, one route from existing acts — take · decline · hold |
| `/ba-run` | Run the composed plan as a route — the render, then every row on one `go` |
| `/ba-run specs all` · `specs <epic-list>` | Batch Band-3 entry, then Tier 2 per feature |
| `/ba-auto on [<profile>]` · `/ba-auto off` | Autonomous mode: grant, then close and ratify |
| `/ba-humanizer on` · `/ba-humanizer off` | Every reply and every prose artifact passes through the humanizer until you switch it off — slower while on |

Techniques run one-step: `/ba-t01`…`/ba-t18`,
`/ba-tier1 <kit|ingest|supplement> <epic>`, `/ba-tier2 <NNN>`. `/ba-run <technique>`
remains as a thin alias and the custom-technique entry. Nothing fires by itself —
every one of these is invoked by you, enforced in the skills' own frontmatter,
not by convention. The one exception is not a command at all: the certified-text
check that used to be `/ba-handoff` now runs by itself when implementation takes
a feature (Band 3, above).

---

## Autonomous mode

Sometimes you want the framework to keep going while you are not at the
keyboard. `/ba-auto on` writes an **autonomy grant** — a dated, revocable record
that says *state my decisions in advance and show me the trail afterwards*. It
moves the **moment** you decide. It never moves **what** gets decided.

```bash
/ba-auto on            # profile inferred if you don't name it, and logged
/ba-auto off           # closes the grant, prints the resumption report
```

**What runs on its own.** Plans compose as recommended and execute as a route ·
defer batches are accepted · an aspect clears when its evidence is complete, and
otherwise takes a waiver with the misses named and a revisit trigger of
`BA ratification sweep (auto off)` · reopens default to Real, with the blast
radius stated and nothing cascaded · Band-1 closure carries its arming run with
it, so a run never stands closed-but-unarmed · gate waivers are taken on real
gaps. Every one of those acts is stamped `AUTO (AG-<n>)` in the ledger.

**The line it works to is cost, not confidence.** Auto will start any act that
**spends none of your client's access and commits nobody outside the run** — and
every such act comes back in the ratification batch like all the others. So
under Presale with no call booked, it scopes every epic inside your delivery
boundary itself from the material you captured (kit and brief per epic) — the
same set the WBS bills — enters the features, and drafts their specs. If a
billable epic is ever left unbriefed, the status line, the band-boundary report
and the WBS summary name it by name. What it will never do is **spend someone's time**: it writes
the call kit and leaves the call for you to arrange.

**What never runs on its own.** The two ⚑ sign-offs, the effective PASS, and the
**scope frame** you confirm at `/ba-frame`. Those three are yours in every mode —
the first two are where a false pass becomes a security incident or a scope
escape, and the third is the boundary everything else is measured against. (The
certified-text check is not on this list: it is a script with no judgment in it,
and it runs by itself when implementation takes the feature.) Auto therefore
takes a feature to **"done, awaiting ratification"**, leaves the sign-offs and the
PASS for you, and moves on to the next feature in its scope.

**It never tells you something is blocked when it is your choice.** Where the
next act is one auto may not take on its own, the report says
`Destination reached … extension available by election: …` and names the act.
A pending decision reads as a decision, not as a fault to go hunting for.

**Two things it will not do to you.** It never guesses: where something is
unclear it writes an Open Question, exactly as in manual mode. And it never
grants itself the grant — `on` is your act, `off` is your act, and so is the
ratification between them.

**At `off`** you get one report: where it stopped, the full auto-trail one line
per act, the assumption and open-question counts, and the next manual act.
Ratify in one go, or list the exceptions — each exception reopens as an ordinary
decision.

---

## Four rules worth knowing on day one

1. **Fix it in the spec.** A requirements defect found during implementation is
   fixed in the spec and re-run downstream — never hand-patched in code. This is
   the discipline the whole framework exists to make affordable.
2. **A `[NEEDS CLARIFICATION]` marker is a decision, not a mess.** It means a
   gap you consciously accepted, named where it lives, waived on the record. The
   coding agent implements around it and surfaces it. It never guesses.
3. **The ledgers are not content.** `.specify/aspect-state.md`,
   `aspect-plans.md`, `gate-health.md`, `gate-tuning.md` and
   `elicitation-tuning.md` are operational state. Don't edit them, don't quote
   them into a spec.
4. **Start the tuning logs now.** Every question the framework asked that was
   already answered, every draft it got wrong, every question that produced
   nothing — one line each. They are how the framework gets better at *your*
   projects, and they are the only inputs nobody else can supply.

---

## If the package is not installed: Phase-1 manual mode

The method predates the package and does not depend on it. A BA can run all of
it from the thirteen methodology documents alone — that was Phase 1's exit
criterion, and it was met at corpus level. In the package repo they sit in
`docs/methodology/`.

| What you need | Where it is |
|---|---|
| Band machinery, ledgers, thresholds, reopen/waiver | Orchestrator rules — §11's manual paragraph, ledger templates §2.4 / §6.4, thresholds §3.3, reopen/waiver §4–§5, band acts §8 |
| Each technique's procedure and output template | Catalogue b1–b6 — every sheet's §4 and §5 |
| Tier 1 and Tier 2 | Elicitation techniques §§3–6 |
| How a spec is written | Writing standard §2 (the ten headings), §4 (EARS + banned words), §15 (the self-check) |
| The gate | Gate definition §13's manual paragraph — §4.2 as the checklist, §5's M procedures as mechanical instructions, A assertions read against the snapshot with §5.4 evidence discipline, §6.2 filled by hand |

Three manual substitutions: recorded revision marks stand in for content hashes ·
an eyeball EARS review against the standard's §4 stands in for the lint · a
session-start habit stands in for the scoped health run that would otherwise
auto-fire.

**Two things to start on paper immediately**, because they feed the next phase
directly and nobody can reconstruct them later: the **tuning logs** (false-ask ·
wrong-draft · dead-answer · escapes) from your first real use, and any
**threshold-gap candidate** you notice — a moment where an aspect cleared but
should not have, or vice versa. Both flow document-first into the framework when
the package lands.

---

## Where to look next

- `tests/exit-test.md` — the ten-step script that proves an install end to end;
  it doubles as a worked walkthrough of the whole loop on a toy feature.
- `docs/mode-b-fallback.md` — what to do when the handoff cannot write directly
  into Spec Kit's layout, and what that costs.
- `docs/methodology/` — the corpus, if you want the *why* behind any rule. It is
  never installed and no runtime path reads it; it is for study and for the
  build sessions.
