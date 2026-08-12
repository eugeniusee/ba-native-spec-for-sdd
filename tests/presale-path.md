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

The ledgers initialize, `Profile: Presale` lands in the head, the canvas is
confirmed or drafted. Under Presale the canvas confirms as **one artifact-level
batch** — one confirm per artifact, never per section (D-O14 profile default),
so the drafting does not spend the budget a section at a time.

The framework then renders the route. The render is not an interaction.

**Green when:** the head reads `Profile: Presale`, `canvas.md` is present, and a
route render in the §10.6 shape has been emitted.

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
render after their epic's story rows, and the estimate columns are empty.

---

## Interaction 8 — slack

Held deliberately unspent. The budget carries one interaction of slack for the
correction the route did not anticipate — a struck row that should have stayed,
a defer that should have been asked. A path that needs a ninth act has spent the
slack and failed the budget.

---

## The auto-repair case

Not on the tally — it replaces interactions rather than adding them. When the BA
states a destination the current state cannot reach ("I need a WBS by Friday"),
the framework answers as **one act**: the mismatch in one line, the repair route
in the §10.6 shape, then `go?`. Handing the BA a list of commands to type is a
banned render (D-O32) — and it is also how a budget gets blown, since every
command in that list would be an interaction the framework asked the BA to spend.
