# The Presale path — the interaction-budget script

**Orchestrator rules §6.5 (D-O33), made runnable.** Presale end-to-end — Frame
to a rendered WBS — fits in **≤ 8 BA interactions** on the default route.
Exceeding it is a defect, not a style preference. This file is the script the
budget is counted against; `tests/check-budget.sh` counts it.

The path is the one `docs/quickstart.md` walks a BA through. `tests/exit-test.md`
is the precedent for the two-ways-to-run shape below.

---

## What counts as an interaction

**One interaction = one BA act the framework stopped for.** A typed command is
an interaction. A `go` on a rendered route is an interaction. A batch
confirmation is an interaction, however many rows it carries.

**What is not an interaction:** anything the framework renders on its own —
route renders, reports, advisories, the run log. A render the BA reads but does
not answer costs nothing. That asymmetry is the whole point of the checkpoint
law (§10.1): the framework may say as much as it needs, and may stop only where
a decision lives.

**The banned class.** A stop that only collects an acknowledgement — *"confirm
to continue," "type ok," "acknowledge to proceed"* — is a render defect
(§10.3 rule 7). It costs an interaction and buys no decision. `check-budget.sh`
sweeps the workflow skills for the phrasings.

---

## Two ways to run this

**Mechanically —** the assertions this script can carry in shell:

```sh
tests/check-budget.sh          # the budget, the shape, the banned sweep
tests/check-budget.sh -v       # print every check, not just the failures
```

**As an agent, in Claude Code —** open a session in a fresh directory and work
the eight interactions below against the real skills. This is the version that
exercises the budget as a BA meets it. The mechanical run checks that the
package *can* hold the budget — the pinned shapes are compiled, no
acknowledgement-only stop is authored into a skill, and the script itself stays
inside eight. Whether a live agent holds it is what the agent run answers.

---

## Interaction 1 — Frame, in the Presale profile

```
/ba-frame Presale
```

The ledgers initialize, `Profile: Presale` lands in the head, the **scope frame**
is set, and the canvas is confirmed or drafted.

The render's **first block is the source inventory** (D-O45): what is on hand,
then *anything else?* — Slack channels, email threads, drive folders, call
recordings — named, pasted, attached, or `none`. Sources the framework can reach
are captured verbatim under `sources/`; ones it cannot take a BA disposition —
**supply · skip · pending** — and every named source lands on the head's
`Sources:` line with its state.

**The candidate scan rides inside that block** (D-O53). Where the Slack
integration is reachable, the framework scans the workspace on **the project
name alone** and offers **one** best-match channel on the inventory's own line —

```
Slack — closest match on the project name: #acme-portal — include it, or ignore it.
and 2 more matched — name them to see
```

— never a list of channels. No opt-in: the scan runs whenever Slack is
reachable, whether or not a Slack source was already named. Slack unreachable →
the block renders exactly as it did before D-O53, zero delta.

**The confirm path.** The BA's **one reply** confirms the candidate alongside
everything else — no second render, no second stop, no ninth act. A confirmed
candidate stops being a candidate: it is an ordinary named reachable source,
captured verbatim to `sources/slack-acme-portal-<date>.md` and mined under
cite-or-mark, and it lands on the head's `Sources:` line with its state like any
other. **A declined candidate lands nothing** — the ledger records BA-named and
BA-confirmed sources only, and a candidate the reply does not answer is
declined.

The source inventory, the profile picker and the scope-frame block render
**together, as one stop** (D-O42, extended by D-O45). Auto-pickup pre-fills
the frame's values with their citations from the material on hand — delivery
boundary, budget envelope, client label, the parameters — and the BA answers all
three blocks in **one reply**. `Boundary:`,
`Budget:`, `Client label:`, `Parameters:` and the derived `Capacity:` line land
in the head beside `Profile:`. The frame is a safety-floor act: no autonomy
grant ever takes it (§10.7), so it is a BA interaction in every mode — this one.

Under Presale the canvas confirms as **one artifact-level batch** — one confirm
per artifact, never per section (D-O14 profile default), so the drafting does
not spend the budget a section at a time.

*Note — the conditional correction stop is not a ninth act.* Where a capture
contradicts or fills a frame value the BA just confirmed — the documents say
`none stated`, Slack says ≤ $50K — the framework renders the correction proposal
and **re-takes P-O0b**, the frame's own switch act. That is one stop, drawn from
interaction 8's slack (7 + 1), and it fires only on a contradiction: captures
consistent with the frame produce no stop at all.

The framework then renders the route. The render is not an interaction.

**Green when:** the head reads `Profile: Presale`, carries the five scope-frame
lines and a `Sources:` line with a state per named source, `canvas.md` is
present, one reply answered all three blocks, and a route render in the §10.6
shape has been emitted. Where Slack was reachable: **exactly one** candidate
channel rendered — never two — the confirmed one carries a `Sources:` entry and
a `sources/slack-<channel>-<date>.md` capture, and a declined one carries
neither.

---

## Interaction 2 — `go`

```
go
```

One word runs the route: T-08 — Value definition, T-09 — Vision &
differentiation, T-16 — Global out-of-scope, T-17 — Epics decomposition,
T-18 — Scope allocation, each under its own compiled P-O3 (technique
invocation) check, each with its run-log line. **Nothing stops between rows.**

**Green when:** every row on the rendered route has run, each has a run-log
line, and no prompt was rendered between rows.

---

## Interaction 3 — the defer batch

The route stops where a decision lives: the questions that cannot reach the
client. The BA confirms the batch; each question stands as its marker
(doc 3 §5.4).

**Green when:** the stop names a decision, the batch is confirmed in one act,
and every deferred question carries a marker.

---

## Interaction 4 — the Band-2 transition

The route stops at the band act. T-17 and T-18 have rerun on the default route
as the graduation sweep and the reallocation, so the roadmap is not MVP-only —
the BA does not discover this post-hoc.

**Green when:** the roadmap carries every epic with its phase, and the
transition was a BA act.

---

## Interaction 5 — batch Band-3 entry

```
/ba-run specs all
```

One P-O8 — Band-3 entry table over every feature the briefs propose. The BA
strikes rows by number and confirms the rest **in one act**. Each confirmed row
keeps its own mechanics: status flip, band event, the §8.4 advisory where one
fires.

**Green when:** one table rendered, one confirmation taken, and one band event
recorded per confirmed feature.

---

## Interaction 6 — the consolidated defer-confirm

Tier 2 — spec-depth gap-filling drafts every entered feature in assumption
posture, each run writing its own `## Band 3` run-log line. The unreachable
questions arrive **once**, at the end, as one batch — not once per feature.

**Green when:** every entered feature has a draft `spec.md` with its markers,
every Tier-2 run has a run-log line, and exactly one defer-confirm was rendered
across the whole batch.

---

## Interaction 7 — the export

```
/ba-wbs
```

**Green when:** `exports/wbs.xlsx` and `exports/wbs.csv` exist, deferred rows
render after their epic's story rows, and the column set ends at Phase — no
estimate column exists, estimating being the client's act outside the export.

---

## Interaction 8 — slack

Held deliberately unspent. The budget carries one interaction of slack for the
correction the route did not anticipate — a struck row that should have stayed,
a defer that should have been asked, the Frame correction stop where a capture
contradicts the scope frame (D-O45 · D-O49). A capture from a **confirmed
candidate channel** fires that same stop and no other: the scan adds **no second
consumer** of the slack (D-O53). A path that needs a ninth act has spent the
slack and failed the budget.

---

## The auto-repair case

Not on the tally — it replaces interactions rather than adding them. When the BA
states a destination the current state cannot reach ("I need a WBS by Friday"),
the framework answers as **one act**: the mismatch in one line, the repair route
in the §10.6 shape, then `go?`. Handing the BA a list of commands to type is a
banned render (D-O32) — and it is also how a budget gets blown, since every
command in that list would be an interaction the framework asked the BA to spend.
