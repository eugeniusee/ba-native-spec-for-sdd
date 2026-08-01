---
name: ba-reopen
description: Receive, rule and execute a reopen signal (P-O6). Logs RO-<n> unconditionally, proposes the contradicted-artifact-to-aspect mapping, takes the BA's Real / Not real / Brief-shaped ruling, then executes - T5, the stated blast radius with no auto-cascade, resolution routed as content, and event-shaped deferrals. The corpus's upstream valve; the gate emits, this executes.
disable-model-invocation: true
---

# `/ba-reopen [<aspect>]` — the reopen machinery

**Argument:** optional — the aspect the emitter proposed. Omit it and the mapping
is proposed from the contradicted artifact.

*Downstream findings reopen upstream aspects.* Everything upstream-shaped that
the framework emits lands here: **the gate emits; this executes.**

## Step 1 — receive, unconditionally

| Source | Emission moment | Payload — the emitter's, received **verbatim** |
|---|---|---|
| Tier-1 ingestion (batch assembly) | BA present | finding · contradicted artifact + line · conflict statement |
| Tier-2 routing (a session answer contradicts gated content) | BA present | same |
| `/ba-gate` lane 3 (a gap reveals a contradiction with gated content) | verdict review, BA present | same; the FAIL line supplies finding + element |

Log it as `RO-<n>` (**project-numbered**), status `received`, **before any
ruling**. Logging is unconditional, so a declined signal is an audit record,
never a silent drop.

```
RO-1 · received · 2026-07-14 · source: Tier-1 ingestion E-03
```

Never paraphrase the payload into your own words: the contradicted line is the
evidence, and a reworded conflict statement is a different conflict.

**No daemon is needed, by construction.** Every emission moment above is a
BA-present moment — batch approval, a Tier-2 session, verdict review. Receive and
decide happen in the same sitting; nothing polls, nothing queues unattended.

## Step 2 — P-O6: the ruling

**Propose the aspect mapping** — contradicted artifact → owning aspect:

| Aspect | Owns (for mapping) |
|---|---|
| Stakeholders | `stakeholders.md` · personas · canvas Customers |
| Context | `context.md` · `constraints.md` · competitive analysis · canvas Competition→Unlike, Context/Constraints |
| Value | canvas Problems · Objectives |
| Vision | canvas Product→The/Is/That · Competition→Our Solution |
| Solution | canvas Forms · Core Functions · Third-Party Connections · Localization |
| Requirements | `glossary.md` · `domain-model.md` · `processes.md` · `out-of-scope.md` · `constitution.md` · `roles-permissions.md` · design/UX standards |

The **roadmap and the scope briefs belong to no aspect** — they are Band-2
ground.

Present the mapping with the contradicted line, and take the BA's ruling:

- **Real** → the reopen executes (Step 3).
- **Not real** — a misreading, a stale quote, a non-conflict → RO closes
  `declined — <reason>`, **and the decline is flagged toward the emitter's
  continuous-improvement loop** (`.specify/elicitation-tuning.md` for a Tier-1/2
  emitter, `.specify/gate-tuning.md` for a gate lane-3 emitter). *Which* log
  receives it is the emitter's classification, never yours. **A false reopen
  signal is somebody's tuning input, never just noise.**
- **Real but brief-shaped** — it contradicts a **scope brief**, not an aspect
  artifact → **not a reopen.** It routes back as a brief edit under the
  elicitation mechanics, with the pass-binding consequences the corpus already
  defines. Close the RO naming that route. Where the finding *also* contradicts
  an aspect-owned artifact, it names that artifact and maps normally.

## Step 3 — execute, on Real

### 3a. State

**T5** — the aspect → `reopened`. Head row rewritten; event appended:

```
<date> · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-1
```

RO-`<n>` goes `open` with the full named record — the grammar admits no short
form:

```
RO-1 · Stakeholders — canvas.md:Core Functions "Specialists self-publish
availability" + stakeholders.md (no admin population): call establishes
clinic admins manage some specialists' calendars → correct the actor
picture (register + canvas), assess role implication.
```

`RO-<n> · <aspect> — <contradicted artifact:line>: <conflict statement> → <resolution path>`.

Reopening from `waived` **voids the AW**; the RO record notes the voided AW.

### 3b. Blast radius — proposed, stated, **then** ruled

Before anything else happens, assemble and state the affected set:

- **Dependent aspects: listed, NOT auto-reopened.** They keep their states and
  take an `upstream reopened` flag in the head — **visibility, not a state
  change.** Auto-cascade would punish five aspects for one wrong line; the delta
  reckoning at re-clear reads the *actual fix* instead. Never write a T5 for a
  dependent here.
- **Band-2/3 work in flight:** epics whose briefs cite the contradicted content
  (kit-baseline citations make this findable) · features whose `deps(F)` include
  the contradicted artifact, **with their certification states listed**.
  **Nothing here voids or preserves a PASS** — certifications are the gate's
  ground: if resolving the conflict edits a checked artifact, the gate voids and
  notices, exactly as for any framework write. Your list is advisory visibility
  and says so.
- **Default: continue-with-visibility. No freeze.** The BA may explicitly pause
  named items, recorded in the RO. **Pausing is the exception that must be
  chosen, never the rule that must be undone.**

Record it on the RO:

```
  blast radius: dependents Context · Value · Vision · Solution · Requirements
                flagged `upstream reopened` (no cascade) ·
                in flight: E-03 brief cites [canvas: Customers] — flagged;
                feature 004 pre-Tier-2; no certifications exist to void ·
                ruling: continue-with-visibility
```

### 3c. Resolution routes as content

**You never author.** Resolving edits go through the routing batch discipline:
proposal → **BA approval** → the framework writes → the scoped Scope-H run fires
silently *if armed*.

Often the resolving edits **ride the very batch that emitted the signal** —
Tier-1 ingestion proposes them in the same sitting. The RO then **binds those
edits as its resolution refs** rather than spawning a second batch. Prefer that
whenever the batch is still open; a second batch for the same fix is bookkeeping
theatre.

### 3d. Deferred consequences are event-shaped

A consequence the BA elects not to execute now — a role addition that only
matters when a proposed feature enters delivery — is recorded **in the RO with
its trigger event**, listed in the head under `Deferred consequences`, and
**lazy-read when that trigger's touchpoint renders**. Never scheduled, never
converted to a date.

```
  deferred: a Clinic Admin role in roles-permissions.md — trigger: F2
            (availability publishing) Band-3 entry
```

## Step 4 — re-clear

Hand to **`/ba-clear <aspect>`**, which runs the delta rule: re-confirm only the
criteria the contradiction or the fix touched plus the corrected line; untouched
criteria **carry with their basis written down**; each flagged dependent is
diffed against the fix and either re-confirmed or reopened on its own RO.

On confirmation: **T6** → `first-pass-cleared`; RO closes
`resolved — <refs>`; flags drop.

**Alternative close:** **T7** — the BA accepts the conflict unresolved →
`/ba-waive-aspect`, the AW **citing the RO**; the head carries both until
superseded.

## Two things that are not reopen signals

- The gate's **voided-certification notice** is gate-to-BA. The cheap re-gate is
  BA-invoked at the gate. Do not receive it here.
- Gate lane 3's alternative outcome — **"a Band-2 allocation act"** — is a BA
  decision to rerun allocation, not a signal class. Name `/ba-run t18`.

## What this skill never does

Never rules Real on the BA's behalf · never auto-cascades into dependent aspects
· never freezes work by default · never voids, preserves or comments on a
certification's validity · never authors the resolving edit or writes any content
artifact · never drops a signal silently — every received RO ends `resolved`,
`declined` or `open` · never converts a deferred consequence into a schedule ·
never re-clears the aspect itself.
