---
name: ba-change
description: The change route - /ba-change <the change ...>, or a plain sentence naming the change. A stakeholder's change after the estate stands had six correct landing mechanics and no front door, no record class and no consequence render; this is the front door. The change is received unconditionally as a late source and logged CR-<n> before any classification, located in the estate with the state of every target it touches, its consequences named under standing law by citation and never as a block, and routed through one route composed only from acts the corpus already has - then ruled at P-O10: take, decline or hold. Never rules take on the BA's behalf, never authors a spec, brief, roadmap or governance line, never voids or preserves a certification, never freezes work in flight, never drops a change silently.
disable-model-invocation: true
---

# `/ba-change <the change …>` — the change route

**What this does, in plain words.** The estate stands — the specs are drafted
or certified, the WBS is out — and a stakeholder brings a change: the client
wants a feature added, a designer wants a flow simplified, a sponsor wants a
module cut or a step made richer. You do not have to work out which file it
hits or which command moves it. Hand the change to the framework: it receives
the change as a source, finds every artifact the change touches, says what
taking it would do under the law that already stands, proposes one route made
only of acts the corpus already has, and asks one question — take it, decline
it, or hold it (orchestrator §7.7).

## Invocation — two entry forms, and one re-entry

**Argument:** the change, in whatever form you have it — typed, pasted,
attached, or a named Slack thread, mail or drive item.

- **The command:** `/ba-change the client wants to drop online payment from
  booking — clients pay at the clinic`.
- **A plain sentence naming the change** — *«клієнт хоче прибрати оплату з
  бронювання»* — enters the same route: the repair-route pattern (D-O32).
  **Named by what you have in hand, never by mechanism** (§10.3 rule 11).
- **`/ba-change CR-<n>`** re-enters a change already on the record — one
  standing `received`, or one `held` whose trigger has just rendered. The
  source is already captured, so Step 0 appends nothing; the route re-renders
  its impact from the estate as it stands **now** and asks P-O10 again.

## Step 0 — receive, unconditionally

**The change is a late source, and it takes the source law by reference,
unchanged.** `/ba-frame` owns those mechanics; this skill cites them and
re-implements none of them:

| What arrives | How it is captured — `/ba-frame`'s own mechanics |
|---|---|
| A paste, or the change typed into the command | captured verbatim, exactly like a read channel (D-O45) |
| An attachment | the same capture; a docx · xlsx · pdf lands with its sibling mechanical plain-text rendering `sources/<name>.extracted.md` (§8.1) |
| A named Slack thread, mail or drive item | read **bounded by what you named**, captured verbatim (D-O46) |

The destination is `sources/change-<n>-<date>.md` — one artifact per capture,
placement only (D-O47). The capture is then mined under cite-or-mark, one
`Sources:` head entry takes its state (D-O48), and the `source` event appends
on the existing grammar. **No new event kind exists.**

**Then the record, before any classification.** `CR-<n>` — **project-numbered**
— appends to Events in full, status `received`, and the head's `Changes:` line
takes its entry:

```
CR-3 · received · 2026-09-01 · from: client — M. Petrenko, Slack #proj-cardio · sources/change-3-2026-09-01.md — remove online payment from the booking flow; clients pay at the clinic
```

`CR-<n> · received · <date> · from: <who — role, and name or channel> · <source path> — <the change, one line>`.

**Logging is unconditional**, on the reopen's own rule (§5.1): a declined
change is an audit record, never a silent drop. **The one-line summary is the
only rewording on the record** — the captured source is the evidence, and a
reworded request is a different request.

**The head line is rewritten in place, line-anchored** (D-O88) — a full-line
match at line start, never a substring search — and **inserted directly after
`Scope advisories:` where the line is absent**. An absent line reads `none`, so
a ledger written before this ruling is legal and reads correctly.

**The record comes before the classification, always.** Nothing below runs
until the `CR-<n> · received` line stands in Events and on the head.

## Step 1 — locate: the targets, and the state of each

Read the ledgers and the estate and name **every target** the change touches,
each with the **state the record establishes** — never a guess:

| Target class | The read behind the state |
|---|---|
| The scope frame | the head's `Boundary:` · `Scope decisions:` · `Acceptance shapes:` lines (§2.4) — `standing`, or `none found` |
| A roadmap epic | `.specify/memory/roadmap.md` rows (T-17 — Epics decomposition) — the `E-<nn>`, its Phase and its Status: `not yet existing` · `Unallocated` · `<phase>` · `Defined` · `In delivery` · `Delivered` · `Retired` |
| A scope brief | `.specify/memory/scope/E-<nn>.md` — absent → `none`; present → the brief's own status, `Draft` or `Scoped` |
| A governance or context artifact | `.specify/memory/*` — glossary · roles · domain model · constraints · out-of-scope · constitution · canvas — mapped to its aspect by §5's mapping table, and carrying that aspect's state: cleared ground, or armed H ground after closure |
| A feature spec | `specs/NNN-*/spec.md` and its **latest** `gate-report.md` entry — `not yet existing` · `draft — no PASS` · `certified, not taken` · `taken by implementation` · `delivered` |

**The two feature states that are read from plumbing, not from the report.**

- **`taken by implementation`** — the gate §11.2 plumbing leaves, read exactly
  as `sk_handoff.py` reads them for its own take-up check: the `NNN-*` feature
  branch, and the `.specify/feature.json` pointer. The pointer is
  single-valued — one feature at a time — so it establishes take-up for the
  feature it names and for no other.
- **`delivered`** — the roadmap row reading `Delivered`, or the feature's
  cycle-close band event in the ledger (§8.5).

**Where no reliable read exists for a state, say so and stop guessing.** A
state this skill cannot establish renders as the fact that it could not be
established, with the read that failed named — the near-miss law (D-O58),
applied at the state grain. It is never rendered as a state the estate did not
say.

**The names-nothing-findable stop.** Where the change names something the
estate does not hold — a screen no spec describes, an epic under a name the
roadmap does not carry — the render **stops at the targets line and asks**,
through the AskUserQuestion tool, one call, one question:

```
What I need from you:
1. The change names "the payment step" — I cannot find it in the estate. Which of these does it mean?
   a. 004-appointment-booking — the booking spec (recommended) — its §2 carries a payment story
   b. E-07 Online payment — the roadmap epic, Phase 2
   c. something else — name it, and I will locate it
Reply with the letter, or name it in your own words.
```

The lettered candidates are **the things the estate does hold**, plus the
free-text escape (§10.3 rule 9). **One stop, and the CR stays `received`** —
nothing is classified while the target is unknown. **The framework never
resolves the ambiguity itself:** a change located by guess is a change applied
to the wrong file.

## Step 2 — the impact render

For every target, the consequence of taking the change **under law that
already stands — cited, never restated, and never a block**:

| The change touches | The consequence, by reference |
|---|---|
| a spec **certified, not taken** | any edit voids its PASS (gate §9.1) → the **incremental re-gate** (gate §9.2), CC-XA-06 ⚑ where the boundary moves |
| a spec **draft — no PASS** | an ordinary edit: **Tier 2 — spec-depth gap-filling** again, markers as usual |
| a spec **taken by implementation** | the **new delivery cycle** gate §9.4 states: fix in the spec → re-gate → re-handoff, the last being implementation's own first act (gate §11.2) — **the route ends at the re-gate** |
| a spec **delivered** | the same cycle; **the post-delivery route and status are parked** — say so in plain words |
| a **scope brief** | a brief edit under the elicitation routing mechanics → every certified-but-untaken sibling's PASS voids → the cheap re-gate with **CC-XA-06 ⚑** (gate §9.3): a scope-boundary change always gets a human look |
| a **roadmap epic** — its phase | a **T-18 — Scope allocation** rerun, trigger `BA-directed`, reason `CR-<n>` — diff vs. current, BA approval, one logged entry |
| a **roadmap epic** — the set (new · split · merge · retire) | a **T-17 — Epics decomposition** rerun **proposal** — the Epic column is that technique's |
| a **governance or context artifact** | a routed edit under the elicitation routing mechanics — a proposed batch, BA approval, the scoped-H run silent unless FAIL, the **voided-certification notice** per certified feature whose `deps(F)` hold it (gate §10.2) |
| **cleared Band-1 ground** the change contradicts | a **reopen** — `RO-<n>`, P-O6 — reopen ruling, the blast radius stated (§5) |
| the **scope frame** — a negotiated trim, a boundary or budget move | harvested as `SD-<n>` on the late-arrival path · the routed scope-frame-change proposal taken as **P-O0b — scope-frame selection, re-taken** · the `scope-frame` event · **T-18 — Scope allocation**'s scope-frame trigger |
| a standing **`AS-<n>`** the change contradicts | both sides cited; where the change is the client's own later statement the entry takes `superseded — SD-<n>` on take; where it is not — a designer's simplification against the client's pass list — the contradiction **stands named**, and a `take` needs the reason on the record |
| the **WBS** | rows that move, drop or appear — **counts, never numbers** (§10.5's never-numeric rule); the re-render is `/ba-wbs`, read-only, after landing |

**The posture is the blast radius's (§5.3): advisory visibility, never a
freeze.** **Nothing in this render voids or preserves a PASS** — certifications
are the gate's ground, and the gate voids at the edit and notices at the write,
exactly as for any framework write.

**Where a `Boundary:` stands**, the render also says whether the change moves
work **across it** — into or out of the billable set — because that is the line
the client reads.

**The WBS counts are read, never written.** Run the export's own reader in
summary mode — `python3 .specify/ba/scripts/sk_wbs.py --root . --summary-only`
— which prints the per-epic row counts and writes no file. The counts on the
render are that reader's, so the render and the sheet can never disagree.
**Where a count cannot be established**, the line reads

```
WBS: count not established — <why>
```

— **never zero.** A count nobody could compute is not a count of nothing
(D-O58), and printing `0 rows` would tell the client the change costs nothing.

## Step 3 — the route, then the ruling

**One route in the pinned route shape** (§10.6), composed **only from acts the
corpus already has**, in the order the law makes them depend on each other:

1. the **scope-frame change** (P-O0b — scope-frame selection) and the **T-18 —
   Scope allocation** rerun first, where the frame moved
2. the **T-17 — Epics decomposition** proposal, where the epic set changed
3. the **brief edit** — the elicitation routing batch
4. the **reopen** (`/ba-reopen`), where cleared ground is contradicted
5. **Band-3 entry** (P-O8 — Band-3 entry, `/ba-enter-feature`), where a feature
   is new
6. **Tier 2 — spec-depth gap-filling** on every touched draft
7. the **re-gate** on every touched certified spec (`/ba-gate <feature>`)

**Every write goes through its owning mechanic and that mechanic's own stop** —
P-O0b, the routing-batch approval, **T-18 — Scope allocation**'s step-4
approval, P-O6 — reopen
ruling, P-O8 — Band-3 entry, gate P2 — and the render lists them under
`Stops en route:`. **No stop is new.** The route composes to the estate's edge
and names, after it, what waits on a BA-elected act — a Tier-1 call under
Discovery, the ⚑ sign-offs, the PASS.

**The route never authors content.** Proposals are the owning technique's,
approvals are yours, and a CR that wrote a spec line would be a fourth writer
on a file with three.

### The ruling — P-O10 — change ruling

Then the sitting's one stop, in the closing-ask shape (§10.3 rule 9), through
the AskUserQuestion tool where the runtime has it:

```
What I need from you:
1. Take this change, decline it, or hold it?
   a. take — run the route above (recommended)
   b. decline — nothing moves; your reason goes on the record
   c. hold — until an event you name; it comes back when that moment renders
Reply with the letter, or rule it in your own words.
```

**The marker rule.** `take` carries `(recommended)` **by default**: the change
is the stakeholder's later statement, and the framework's posture toward a
client's later statement is already ruled — it governs. `hold` carries it
**instead** where the render names a **standing `AS-<n>` — an acceptance item
the client gave us — that the change contradicts and does not itself
supersede**: the framework never recommends walking into a conflict it has just
named. `decline` **never** carries it — declining a stakeholder's change is
your judgement alone. **The marker is a label, never a pre-selection.**

### `take` — the `go`

A `take` **executes the route** exactly as `/ba-run` executes a composed route:
the rows in order, no per-row acknowledgement, stopping only at the rows' own
prompt points. Each row runs by reading its skill file at
`.claude/skills/ba-<id>/SKILL.md` and executing it as the procedure — the
execution mechanism (§7.5, D-O103), whose named instance is `/ba-run`'s
row-execution clause. The CR moves to `routed — <acts>`, and the ruling appends:

```
CR-3 · ruled · 2026-09-01 · Y.K. — take · targets: E-07 Online payment (Phase 2 · Defined) · 004-appointment-booking (certified, not taken) · AS-2 (standing → superseded — SD-4)
```

`CR-<n> · ruled · <date> · <initials> — <take | decline — <reason> | hold — trigger: <event>> · targets: <target — state · …>`.

### `decline` — the record is the ruling

A `decline — <reason>` closes the CR `declined` with the ruled line above, the
head reads `declined — <reason>`, and **nothing else in the estate moves**. The
source stays captured on the `Sources:` line. Nothing else is written.

### `hold` — event-shaped, never a date

A `hold — trigger: <event>` writes `held — trigger: <event>` on the head, on
the deferred-consequence pattern (§5.3). **Never a date, never a schedule** —
no scheduler exists, and only an event can be recognized at a touchpoint. The
head's line is **lazy-read when that trigger's touchpoint renders**, and the
framework names it once there and asks P-O10 again. The touchpoints this route
wires:

| Touchpoint | The read |
|---|---|
| `/ba-enter-feature` — Band-3 entry | the head's `Changes:` line, before the slicing row renders |
| `/ba-t18` — Scope allocation | the same read, before the allocation diff renders |
| the cycle-close prompt (§8.5) | the same read, at the band event |

**A trigger naming no touchpoint any of these render is named as such at the
ruling** — the hold is still legal, and the CR comes back the next time you run
`/ba-change CR-<n>`. A hold that silently waits on nothing is the one thing
this state must not become.

## Step 4 — landing

Each act of the route writes **its own record in its own grammar** — the
`Allocation <n>` entry with its trigger and reason, the brief's routing-log
line, the `RO-<n>`, the harvested `SD-<n>`, the gate-report entry of the
re-gate, the roadmap status flip at its band event. **The CR closes when the
last of them stands:**

```
CR-3 · landed · 2026-09-02 — SD-4 harvested · AS-2 superseded — SD-4 · Allocation 4 (E-07 Phase 2 → Later) · brief E-03 routing log 09-02 · 004 spec r7 · gate run 4 on 004 (⚑ and PASS pending) · WBS: 3 rows drop — /ba-wbs to re-render
```

`CR-<n> · landed · <date> — <refs>`. The head's entry reads `landed — <refs>`.

**The CR duplicates none of these records** — it names them, so the one-line
answer to *what happened to the client's change of 1 September?* stands on the
head and points at every place the change landed.

**The `Next:` line names `/ba-wbs` where rows moved** — read-only, after
landing, never as part of the route.

**A route that halts** at a stop you do not clear leaves the CR `routed`, with
the halted act named in the `Next:` line of the render that stopped it.

## Autonomy — never AUTO, and not on the floor

A change arrives **from outside the workflow any grant runs**, so no `AG-<n>`'s
`scope:` field contains it: the arrival is not an act the run could take, and
**a grant cannot self-elect a request nobody made.**

Brought by you mid-grant, the change renders its impact and its ask **in that
sitting** — you are present, having brought it — with the grant standing. A
`take` is the route's `go` under the grant, its acts standing in the
ratification batch like any other, and the paused run resumes after the route
lands.

**A `received` change a prior sitting left unruled rides the three pinned
reports as one conditional tail line** — the band-boundary report, the
mid-grant stop report and the resumption report — **visibility, and never an
option in any closing ask.** The ruling needs the impact render first, and it
is taken by naming the change.

**The safety floor keeps its three acts.** The floor lists acts *inside* the
workflow that a grant would otherwise take, and this act was never inside it.

## Budget

Outside the Frame → WBS span the ≤ 8 Presale budget measures, by construction —
a change arrives after the estate stands. One interaction, the ruling, plus the
stops the route's own acts already own.

## The pinned impact render (§7.7)

```
Change — CR-3 · remove online payment from the booking flow; clients pay at the clinic · from: client — M. Petrenko, Slack #proj-cardio · captured: sources/change-3-2026-09-01.md · 2026-09-01
Targets: E-07 Online payment — Phase 2 · Defined · 004-appointment-booking — certified, not taken · AS-2 "bookings end-to-end incl. payment" — standing
| # | Touches | Consequence under standing law |
|---|---|---|
| 1 | scope frame — a negotiated trim | SD-4 harvested (D-O65) · P-O0b re-taken · scope-frame event · T-18 scope-frame trigger |
| 2 | E-07 Online payment — Phase 2 | T-18 rerun, BA-directed, reason CR-3: candidate E-07 → Later, diff vs. current (catalogue-b6 §4) |
| 3 | 004 spec — certified, not taken | edit voids the PASS (gate §9.1) → incremental re-gate; the boundary moves → CC-XA-06 ⚑ (gate §9.2 · §9.3) |
| 4 | AS-2 — standing | the client's own later statement: superseded — SD-4 on take (D-O78) |
| 5 | brief E-03 §3 Deferred · §8 slicing | brief edit (§3.5) → sibling 005's PASS voids → cheap re-gate (gate §9.3) |
| 6 | WBS | 3 rows drop (E-07) · 2 rows change (004) — counts; /ba-wbs to re-render after landing |
Boundary: the change moves E-07 out of the billable set (Boundary: MVP + Phase 2 · E-07 → Later)
Route — CR-3 landed: E-07 re-allocated, 004 re-gated, briefs and registers in step · profile: Discovery
| # | Code — technique | Yields |
|---|---|---|
| 1 | P-O0b — scope-frame change · SD-4 | Scope decisions: line · scope-frame event · AS-2 superseded — SD-4 |
| 2 | T-18 — Scope allocation · BA-directed (CR-3) | Allocation 4 — diff vs. current, one logged entry |
| 3 | §3.5 routing batch — brief E-03 | §3 Deferred + §8 slicing rows edited · routing-log line |
| 4 | Tier 2 — spec-depth gap-filling · 004 | spec r7 — the payment step removed, markers on the record |
| 5 | Gate · 004, 005 | incremental re-gates; CC-XA-06 ⚑ and the PASS left for you |
Stops en route: P-O0b — the scope-frame change (your confirm) · T-18 step-4 approval · §3.5 batch approval · gate P2 — all existing
What I need from you:
1. Take this change, decline it, or hold it?
   a. take — run the route above (recommended)
   b. decline — nothing moves; your reason goes on the record
   c. hold — until an event you name; it comes back when that moment renders
Reply with the letter, or rule it in your own words.
```

## What this skill never does

Never rules `take` on your behalf · never authors a spec, brief, roadmap or
governance line · never voids, preserves or comments on a certification's
validity · never freezes work in flight · never drops a change silently — every
received CR ends `landed`, `declined` or `held`, or stands `routed` with its
halted act named · never converts a hold into a schedule · never touches the
client-facing xlsx: the register is internal, and a client-facing change log is
parked.

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
