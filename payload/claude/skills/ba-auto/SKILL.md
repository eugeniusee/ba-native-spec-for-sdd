---
name: ba-auto
description: Autonomous mode - /ba-auto on writes the autonomy grant AG-<n>, flips the ledger head's Auto line and runs the surviving checkpoints under the policy table, each act stamped AUTO; /ba-auto off closes the grant and renders the pinned resumption report for one batch ratification. The grant reaches every act that spends no client access and makes no external commitment - self-elections included, each stamped and ratified in the batch; a client call is never booked, and an un-electable act renders as a choice, never as blocked. The safety floor sits outside every grant - the two flagged sign-offs, the effective PASS and the scope frame at P-O0b - scope-frame selection stay BA-only; the certified-text check is implementation's own first act at take-up, on no floor and under no grant. A halt mid-grant - the safety floor, or the grant's own scope exhausted - renders the pinned mid-grant stop report and hands control back with the grant still standing. Never grants itself a grant.
disable-model-invocation: true
---

# `/ba-auto on [<profile>] | off` — autonomous mode

**Argument:** `on`, optionally with `Discovery` or `Presale` · or `off`.

An autonomy grant moves the **moment** the BA states a decision. It never moves
the **content** of one. Everything the BA decided before is still the BA's; what
changes is that the grant states it in advance, once, and every act taken under
it is stamped and comes back for ratification.

## `on` — the entry act

Three writes, and nothing else:

1. **The grant.** Append `AG-<n>` to `.specify/aspect-state.md` Events:

   ```
   AG-<n> · scope: <full workflow | until <event>> · granted-by: <initials> ·
   <date> · revoke: /ba-auto off, or <condition>
   ```

2. **The head line.** Rewrite `Auto:` in place —
   `Auto: on — AG-<n> · scope <…> · since <date>`.
3. **The event.**
   `<date> · auto on · AG-<n> · scope <…> · <initials> — profile <…> (stated | inferred: <basis>)`

**The profile.** Taken from the argument. Absent, **infer and log it**:
`canvas.md` present → Presale, absent → Discovery. Say which, and say it was
inferred. **The profile never switches mid-auto** — a switch is a BA decision
moment, and a grant that could re-aim its own flow would be a blank cheque. To
switch: `off`, ratify, switch, `on` again.

## The policy table — what runs AUTO

Every checkpoint still happens. The table says who states it.

| Stop | Under the grant |
|---|---|
| **P-O0b — scope-frame selection** | **Never AUTO — the safety floor.** Auto-pickup still pre-fills every value with its citation and the block still renders; it then waits for the BA, standing grant or not. The boundary and the envelope are what every later act is measured against, and a grant that could set them would be a run choosing its own budget |
| P-O2 — plan composition, and the route `go` | Compose **as-recommended from the snapshot**, AUTO. The grant **is** the `go`. Record the snapshot verbatim — it is the ratification's evidence |
| Defer batches · the consolidated defer-confirm | Accepted AUTO. **Unclear stays an Open Question, never an invention** |
| P-O4 — clearing confirmation | All criteria met → clear AUTO. Any miss → **auto-AW**: a full waiver record, misses named, revisit trigger `BA ratification sweep (auto off)`. An auto-AW whose every miss resolves to an out-of-profile technique's artifact carries its **expected profile debt** class into the record and the band-boundary report, where it renders as the class and not as a finding |
| P-O5 — aspect-waiver acts | Grants and re-affirmations AUTO |
| P-O6 — reopen ruling | Default **Real**. State the blast radius; **execute no cascade** — flags, never state changes |
| P-O7 — Band-1 closure · P-O8 — Band-3 entry | AUTO stamp |
| The arming run — `/ba-gate-health full`, the closing step of P-O7 — Band-1 closure | **Inside the grant.** Closure completes only when the arming entry exists, so a run must **never stand "closed but unarmed"** — that would put Band 2 on the road with Scope H silently disarmed. Request it as part of the closure, before the band-boundary report. **The gate runs it; you request it** — unchanged. The **P8 HA review** it raises rides the ratification batch |
| P-O9 — overflow ruling | The **supplement lane** only: the Tier 1 — epic scoping interview supplement mini-loop fills the named gaps, assumption posture held. Never cap-adjust, never defer |
| **P-O10 — change ruling** (`/ba-change`) | **Never AUTO — and not on the floor.** A change arrives from outside the workflow the grant runs; no `scope:` field contains it, and a grant cannot self-elect a request nobody made. Brought by the BA mid-grant, the change renders its impact and its ask in that sitting with the AG standing; a `take` is the route's `go` under the grant, its acts in the ratification batch like any other. A `received` change left unruled rides the three pinned reports as one conditional tail line — visibility, never an option in the ask. The floor keeps its three acts |
| The gate's verdict review | **Waivers AUTO on real gaps**, stamped in the report entry. **Overrides never.** On a non-waivable assertion: **fix** — name the gap in the text, or reclassify — **and re-gate.** Never bypass |

**The AUTO stamp, every act, no exceptions:**

```
<date> · AUTO (AG-<n>) · <act> · <basis>
```

## What the grant reaches — the cost boundary

The table above says who **states** each surviving stop. This rule says which
**acts** you may start on your own:

> **AUTO may self-elect any act that spends no client access and makes no
> external commitment. Every self-election lands in the ratification batch like
> any other AUTO act.**

**How a self-elected act starts (D-O103).** The grant **is** the covering act.
A self-election inside `scope:` and this boundary runs on the execution
mechanism: read the elected skill's file at `.claude/skills/ba-<id>/SKILL.md`
and execute it as the procedure, under that skill's own compiled discipline —
stamped and trailed like every other AUTO act. Ask for no keystroke and wait
for none; the flag hides the button, never the file. Outside a covering act,
stop in ≤ 2 lines and name the one BA act that unblocks.

**The test.** An act is outside the boundary when it **spends client access** — a
call, a workshop, an interview slot, a stakeholder's reply — or makes an
**external commitment** a person outside the run must honour. Those stay the
BA's election, standing grant or not: **you schedule nobody's time.** Everything
else — reading the estate, drafting, ingesting captured material, requesting a
check, writing a ledger record — is yours to elect and stamp.

**`recommended` is not the boundary, and never was.** An act the suggestion
grammar can only render `optional` is not an act you may skip: under Presale,
Tier 1 — epic scoping is always `optional` — no threshold criterion demands a
brief — so a run that waited for `recommended` would never produce one, and
would never reach the draft specs the profile puts in its own destination.

**Election stays the BA's act.** Under a grant, the BA's act is the one the mode
already runs on — **deferred batch ratification**, the same instrument that
covers Band-1 closure itself. Stamp the self-election, trail it, ratify it at
`off`.

**Presale with no client call — the pinned instance.** At **Band-2 exit**,
self-elect **Tier 1 — epic scoping, ingest mode over captured client material**
(`sources/`, the notes input the profile already legalizes) for **every epic
allocated to a phase inside the scope frame's `Boundary:` set** — the rows the
WBS's Billable column reads `Yes` for, the quoted scope itself and never a
subset of it — writing the **kit and the brief per epic** — then continue
**P-O8 — Band-3 entry** → **Tier 2 — spec-depth gap-filling** in
assumption posture → draft specs. **The call stays BA-elected:** a live client
session is client access, so write the kit and **never book the session it was
written for.** An epic whose slicing hangs on an open question **still gets its
brief** — record the dependency in the brief's Open Questions and name it in the
resumption report.

## An un-electable act renders as a choice, never as a failure

An act **outside the cost boundary, outside the grant's own `scope:`, or
awaiting a BA election** renders as law:

```
Destination reached — <what stands> · extension available by election: <act — code + name> · <what it needs>
```

**`blocked`, `locked`, `cannot proceed` describe a defect.** An un-electable act
is a **pending choice**, and rendering the second as the first sends the BA
hunting a fault that does not exist. **No pinned shape changes** — this governs
what may fill the band-boundary report's `Next act:` line, the resumption
report's `Next manual act:` line, and every run narration.

## The safety floor — outside every grant

Three acts a grant never reaches, in every profile:

- **The two flagged sign-offs** — CC-XA-01 (authorization) and CC-XA-06 (the
  scope boundary), at the gate's ⚑ review.
- **The effective PASS** — the gate's ⚑ sign-off and approval steps.
- **The scope frame** — P-O0b (scope-frame selection), at `/ba-frame`.

The first two are the acts where a false pass is a security incident or a
scope escape. The third is the constraint every later act is measured against:
a boundary or an envelope the framework set for itself would be a run choosing
its own budget. Three acts the BA answers for personally. **The certified-text
check is not on the floor:** a script containing no judgment cannot be listed
as an act the BA answers for personally — it runs as implementation's own
first act, automatically, at take-up (gate §11.2), and a grant reaches it no
more than it reaches any coding-side act, because it is not this mode's act at
all. Per feature, auto therefore ends at **"done, awaiting ratification"**:
the draft is complete, the gate has run, and the ⚑ sign-offs and the PASS wait
for a human — left pending, named in the stop report's tail, while the run
proceeds to the next feature in its scope (§7.6).

## Continuity under the grant

Under a standing grant, **no conversational render occurs between acts**, and
the run **never ends its turn between acts inside a band**. Every record — AUTO
stamps, auto-AWs, deferrals, open questions — goes to the **ledger and the
auto-trail only**. The run proceeds continuously until exactly one of four
events:

1. **A band boundary** — P-O7 — Band-1 closure, or P-O8 — Band-3 entry. Stamp,
   render the band-boundary report below, end the turn.
2. **A safety-floor stop** — the two ⚑ sign-offs, the effective PASS, or
   P-O0b — scope-frame selection. The run halts where the remaining scope
   depends on the floor act — the scope frame's case; a feature's ⚑ sign-offs
   and its PASS are left pending, named in the tail, and the run proceeds
   (§7.6). Where it halts, render the **mid-grant stop report** below, end
   the turn.
3. **Exhaustion of the grant's scope** — the `scope:` field of `AG-<n>`. The
   same report, its first line naming the scope edge instead of the floor.
4. **`off`** — `/ba-auto off`, or the BA interrupting.

**Why this is a rule and not a preference:** a conversational render **ends the
turn**. Under a grant, a mid-band render is therefore a **de-facto stop** — the
exact thing the grant was written to remove. A run that narrates each aspect has
not run autonomously; it has spent the BA's attention at every act while holding
a grant that says it need not.

## The band-boundary report — a pinned shape

The **only** BA-facing render inside an auto cycle, beside the resumption report
at `off`. The stamps at P-O7 — Band-1 closure and P-O8 — Band-3 entry are
**unchanged** — still AUTO, still ratified in one batch at `off`. This is a **render, not a ratification point**: it takes
no BA ruling. After the stamp, render it and **end the turn**. **The grant
stands** — the BA's next message, whatever it says, resumes the run:

```
Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>
Auto-trail since <start | last boundary>: <n> acts
Assumptions: <n> · Open questions: <n>
Health refresh: <current | overdue: <r> runs vs cadence>
Scope coverage: <in-boundary epics briefed <b>/<e> | uncovered inside boundary: E-nn <name> · … | — no roadmap or no boundary yet>
Next act: <one line> — any reply continues · /ba-auto off renders the resumption report
```

The auto-trail count is **since the last boundary**, not since the grant.

**Where a standing scope advisory stands, the decision-list tail follows this
report's last line** — the shape above is untouched (below).

**The health line is display only.** It carries the refresh state computed
exactly as the dashboard's line 5 computes it — recorded `gate-health.md` runs
against the gate's cadence, one full run per scope-brief ingestion batch — so
the two renders can never disagree. **The refresh act is not yours:**
`/ba-gate-health` runs it and the BA invokes it. A grant does not extend to it,
the report never fires it, and an `overdue` line is a fact rendered, not a stop.

**The closing ask — this report's pinned tail.** The five pinned lines stand
byte-untouched, and the register's `What I need from you:` block follows as an
additive tail — after the report's last line, and after the decision-list tail
where that renders. The tail is **pinned, never composed at the stop**:

```
What I need from you:
1. Band <n> is closed under the grant. How do we proceed?
   a. continue — <the report's Next act line, in plain words> (recommended)
   b. pause and ratify — /ba-auto off; the resumption report renders
   c. correct something first — name it
Reply with a letter, or in your own words — any reply continues.
```

`<n>` is the band the boundary leaves behind — Band 1 at P-O7 — Band-1
closure, Band 2 at P-O8 — Band-3 entry: the head line's own fact, said in
plain words. **Three conditional joins, and no other.** Where the health line
renders `overdue`, one option joins before c, re-lettering c to d:
`run /ba-gate-health full first — it is overdue; no grant reaches it, this
stays your act`. **Recommended stays on continue** — the health line is
display only and the refresh act stays the BA's; the option words a choice
the BA already owned, and the grant still does not reach the run. Where the
`Scope coverage:` line renders uncovered epics, one option joins before c the
same way — after the health option where both render, the letters shifting in
order: `brief the uncovered in-boundary epics first — <the line's list>;
Tier 1 in ingest mode is inside the grant, the run resumes toward Band 3
after`. **Recommended stays on continue** here too, and the wording differs
from the health option deliberately: the health act stays outside every grant,
while this one sits **inside the cost boundary** — the option words an act the
run may perform on the BA's letter. Still no AG expands, no new stop and no
new prompt point exists. Where the decision-list tail renders, its items
**join the ask as questions** — one lettered question per `ADV-<n>` row,
after the proceed question, in **T-18 — Scope allocation's** step-4 shape: the row's finding with a plain
gloss beside the id, the three dispositions lettered, `hold as advisory — no
move` carrying `(recommended)` — so taking every recommended option is
`apply all` exactly; the typed ruling grammar stays the shortcut, never the
only channel. **This is still a render, not a ratification point:** the ask
takes no ruling on the trail — ratification stays one batch act at `off`,
option b routes to that existing act, and **any reply continues — the
recommended option is the continue.** Present it per the register: one
AskUserQuestion call for the whole stop where the runtime has the tool, the
same lettered list with "reply with the letter" where it does not.

## The mid-grant stop report — a pinned shape

Hold conditions **2 and 3** — a **safety-floor stop** and **exhaustion of the
grant's scope** — are **one class**: auto halts **mid-grant** and hands control
back. The grant is **not closed** and **no ratification is asked**. One shape
covers both; the difference between them is its **first line**. Render it and
**end the turn**:

```
Auto paused — <date> · <safety floor: <act — code + name> | scope exhausted: <the AG's scope edge, as AG-<n> states it>>
Stands: <what the run completed, one line> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail since <start | last boundary>: <n> acts · Assumptions: <n> · Open questions: <n>
Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>
```

**Four lines, then the closing ask.** The register's `What I need from you:`
block follows the last pinned line — appended, never replacing one. **The AUTO
exemption does not reach this render:** it ends the turn **awaiting a BA act**,
which is the closing ask's own trigger. The exemption stands for the
band-boundary report and the resumption report, and for those two only — and
what it grants those two is **shape, not silence**: each carries its own
**pinned** ask tail, in its section above and below, where this report's ask
is **composed at the stop** under the register's rules.

**What each event does to the grant — say which, never leave it inferred.** At
a **safety-floor stop** the grant **stands**: the floor's three acts sit outside
every grant on their own account, the BA performs the act, and the run
continues under the same `AG-<n>`. At **scope exhaustion** the grant **reaches
no further**: `AG-<n>` stands as a record awaiting ratification, and you may
self-elect nothing past the edge its own `scope:` field states. The
`Resume from:` line carries which of the two it is.

**It opens no new path, and it is not a ratification point.** Every option the
closing ask may offer already exists: **`off`** — the resumption report and one
batch ratification · **the act itself**, where the floor's act is the BA's to
perform · **the extension by election**, in the words above —
`Destination reached — … extension available by election: …`. **Ratification
stays the grant's instrument at `off`**, and this report asks for none.

**Where a standing scope advisory stands, the decision-list tail does not
follow this report.** That list is ruled at ratification and at
**T-18 — Scope allocation's** step-4 approval, and a mid-grant stop is neither.

## `off` — the resumption report

`/ba-auto off` (or the BA interrupting) closes the grant and renders this
**pinned shape**, unchanged:

```
Auto off — <date>
Stopped at: <point> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail: <n> acts — one line each: <date> · AUTO (AG-<n>) · <act> · <basis>   (the pinned default)
Auto-trail: <n> acts — ratified in this reply · full trail: .specify/aspect-state.md Events   (renders instead, and only, where a full ratification already stands)
Assumptions: <n> · Open questions: <n>
Ratify: accept all / list exceptions
Next manual act: <one line>
```

A run cut off mid-flight leaves its artifact a **draft** — never half-land an
output and call it done. **Ratification is one batch act.** Exceptions reopen
their items manually, each by its own ordinary checkpoint.

**The trail line has one conditional, and one only.** Where a **full**
ratification already stands when the report renders — the reply that ends the
grant accepts the batch **with nothing excepted**, or a `ratification` event
for `AG-<n>` is already on the ledger — the trail line **is** its count plus
the ledger pointer. Absent that, print the **full one-line-per-act trail**: it
is the pinned default and it stays. **A ratification that names exceptions
prints the full trail** — an act nobody can see is an act nobody can except.
**Nothing is lost either way:** the acts live append-only in
`.specify/aspect-state.md`, and the short line is a **pointer to that record**,
never a substitute for it. **The report is still six lines.**

**The closing ask — this report's pinned tail.** The six pinned lines stand
byte-untouched, in both trail forms, and the register's `What I need from
you:` block follows as the same additive tail — after the report's last line,
and after the decision-list tail where that renders. **Pinned, never composed
at the stop**:

```
What I need from you:
1. <n> AUTO acts stand for ratification. Your call?
   a. ratify all (recommended)
   b. ratify all except — name the acts
   c. discuss first — ask me anything about the trail
Reply with a letter, or type the Ratify line's own grammar: accept all / list exceptions.
```

**Taking (a) is the existing one-batch ratification exactly** — it lands as
`accept all`, the ratification event appends and the grant closes, so **the
typed grammar and the ask can never disagree**: the apply-all precedent,
**T-18 — Scope allocation's** step-4 ask, where taking every recommended
option **is** `apply all`. Option b is `list exceptions` in lettered form —
the named acts reopen manually, each by its own ordinary checkpoint, and the
full trail stands above the ask: an act nobody can see is an act nobody can
except. Option c invents no state — the acts already stand awaiting
ratification, and reading the record before ruling on it was always legal.
Where the decision-list tail renders, its items join the ask as questions
exactly as at the band boundary — the **T-18 — Scope allocation** step-4
shape, `hold as advisory — no move` recommended, the typed ruling grammar the
shortcut. **Ratification stays the grant's instrument at `off`** — the ask
restates it in plain words and adds nothing to it. Present it per the
register: one AskUserQuestion call where the runtime has the tool, the
lettered list with "reply with the letter" where it does not.

Append the events:

```
<date> · auto off · AG-<n> · <initials> — <n> AUTO acts, awaiting ratification
<date> · ratification · AG-<n> · <initials> — accepted all | exceptions: <list>
```

## The scope-advisory decision list — a conditional tail on both reports

Where the ledger head's `Scope advisories:` line carries at least one
**`standing`** entry, the **band-boundary report** and the **resumption report**
each render the list as a **tail after their last pinned line**. **The pinned
shapes above do not change** — five lines and six, byte for byte — and the tail
is **an addition, never a replacement**. Where no entry stands, **nothing
renders**:

```
Scope advisories — <n> standing · decide each (P-A1 row shape — source-audit definition §5)
Rulings: apply all · apply all except <#…> · <#>: <letter> <argument>
```

**The row shape is P-A1's — cited, never restated here:** one numbered list,
each row carrying the advisory finding **with its verbatim citation**, lettered
dispositions, and a **default such that `apply all` is a complete, safe
ruling**. Two shapes for one list would drift; there is one, and it lives in the
source-audit definition.

**The dispositions, three:**

- **(a) `hold as advisory — no move` — the default.** Visibility is preserved
  and **nothing moves**. The row renders again at the next ratification for as
  long as the finding stands.
- **(b) `direct a move → <phase>`.** The move **rides T-18 — Scope allocation's
  existing machinery** as a **BA-directed candidate** into the next allocation
  diff, tagged `BA-directed (ADV-<n>)` — **never an inline phase edit**: the
  roadmap's Phase column has one writer, and that technique is it.
- **(c) `accept — <reason>`** with an **event-shaped revisit trigger**, on the
  **SA record pattern** (source-audit definition §5, cited). The entry moves to
  `accepted <date>` on the head line and stops re-rendering — **and returns to
  the list the moment a new source or a new `SD-<n>` re-asserts the finding.**
  An accept is a **recorded BA judgement, never a dismissal**: no disposition
  removes a finding without a reason.

**Where the ruling lands.** Under a standing AG it rides the **existing
`ratification` event**; in manual mode it lands in the **T-18 — Scope allocation
run-log entry** whose step-4 approval carried the list. Either way the head
line's state changes and **no new event kind exists**.

**The manual carrier is T-18 — Scope allocation's step-4 approval** — the
advisory's own run, where the BA already edits and approves the diff. **No new
prompt point and no new stop:** the P-O table is complete as it stands, and the
≤ 8 Presale budget is arithmetically untouched — the list renders inside acts
that already happen. There is **no act named *the manual ratification batch***
and this creates none: **ratification stays the AG's instrument**, and manual
mode rules the list where the finding is born.

**Autonomy — the list is a BA act, and an AG never answers it.** **Assembling**
the list may be AUTO like any other assembly; **ruling** it is not — the P-A1
floor. **No policy row is added and none moves**, the safety floor keeps its
three acts, and a run under a grant renders the tail and **ends its turn**
exactly as the two reports already do. **Internal surfaces only:** the decision
list never reaches the client-facing WBS export or any other client artifact.

## A received change — a conditional line on all three reports

Where the ledger head's `Changes:` line carries at least one **`received`**
entry, the **band-boundary report**, the **mid-grant stop report** and the
**resumption report** each render one line as a **tail after their last pinned
line** — after the decision-list tail where that renders, and **before the
closing ask**. Where no `received` entry stands, **nothing renders**:

```
Changes awaiting your ruling: CR-<n> — <the change, one line> (<from>) · …
```

**The pinned shapes do not change.** The band-boundary report's six lines, the
mid-grant stop report's four and the resumption report's six stand
byte-untouched; the line is an addition, never a replacement.

**Visibility, and never an option in any closing ask.** The ruling is
**P-O10 — change ruling**'s (`/ba-change`): it needs the impact render first,
and it is taken by naming the change — `/ba-change CR-<n>`, or the change in
the BA's own words — never inside a continue or a ratification. **One policy
row, no new stop beyond P-O10, no new event kind and no new state:** a report
that already ends the turn now says one more true thing.

**Unlike the decision list, this line reaches the mid-grant stop report too.**
That report rules nothing and closes no grant — which is why the advisory list
stays off it — but a change awaiting a ruling is not a ruling asked for; it is
a fact the BA reads while the run is paused.

## What this skill never does

Never AUTO-stamps a ⚑ sign-off, an effective PASS, or a scope frame ·
**never grants itself an AG** — the grant is the BA's act, and a framework that could write its
own would have no boundary at all · **never answers the scope-advisory decision
list** — assembling it is AUTO, ruling it is the BA's act in every mode · never
invents where unclear — that is an
Open Question · never switches the profile mid-auto · never executes a reopen
cascade · never takes an override, a cap adjust or a defer at
P-O9 — overflow ruling · never runs a CC assertion itself · never leaves an act
unstamped, never leaves an unratified trail unnamed at `off` · **never books a
client call, a workshop or an interview slot, and never makes a commitment a
person outside the run must honour** — that is the cost boundary, and it is the
BA's election · never stamps a Band-1 closure without requesting the arming run
in the same act · **never renders an un-electable act as `blocked` or `locked`** —
it is a choice, and it renders as one · **never ends the
turn or renders to the conversation between acts inside a band** — mid-run
records go to the ledger only, and a cycle's only BA-facing renders are the
band-boundary report, the mid-grant stop report and the resumption report ·
**never halts mid-grant without the stop report** — a run that hands control
back and says nothing has made the BA guess what stopped it.

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
