---
name: ba-t13
description: T-13 — Core process mapping. Serves Requirements against AT-RQ-4's journeys clause. Establishes the significant-role set, pre-drafts each role's major journeys at helicopter grade with roles cited verbatim and entities named from the domain model, runs the coherence pass, and writes .specify/memory/processes.md.
disable-model-invocation: true
---

# `/ba-t13` — core process mapping

**Serves:** Requirements. **Class:** Context ·
**Destination:** `.specify/memory/processes.md`.

The major journeys of each significant role — **helicopter view with step
descriptions, not tied to features** — so every later scoping and drafting act
can locate itself inside a journey instead of reconstructing one. The decision
this run lets the BA make: these are the domain's major journeys, each owned by a
named role, stated at a grade a later reader can navigate.

**This artifact is written for its consumption.** It loads into every spec-depth
drafting session as flow context, and into every scoping kit. Write steps a later
reader can locate a feature inside — that is the whole test of a good step.

**Significance is a checkable fact, not an adjective.** A role is significant at
Band-1 grade **iff it stands as the actor of ≥ 1 canvas Core Function line**. The
BA may elect further roles into the journey set; the floor is not negotiable.

## Invocation contract — check before you run

**BA-invoked, never auto-fired.** This skill starts only from `/ba-run t13`.

Self-check, and stop if either half fails:

> the run is **on the composed plan** of the Requirements aspect, which is `open`
> or `reopened`, **with its output contract pinned**:
> `{the major journeys of each significant role — role verbatim, trigger → outcome, numbered helicopter steps · Context · .specify/memory/processes.md}`.

On a miss, stop and name `/ba-run`, or `/ba-aspect requirements` to open and
compose. **Run after the roles model** — journeys cite roles verbatim, and a
verbatim citation needs something to be verbatim against.

**Skip-if — refuse the run and say so:** AT-RQ-4's **journeys clause** reads met
in the current evidence table — journey maps already stand, confirmed against the
framed canvas and the role model. Swimlane suites, BPMN and exhaustive journey
inventories are **enrichment on BA ask**.

## Depth boundary — helicopter grade, and it is a hard edge

Per journey: **name · role verbatim · trigger → outcome · numbered steps as
actor → action → observable result**, entities by domain-model name.

**Must NOT expand into:**

- **error paths and alternates.** Journeys are feature-agnostic; the unhappy
  paths are per-feature and belong to the spec's flows.
- feature slicing or epic decomposition — Band-2 ground · story or acceptance
  drafting — spec-depth ground
- **business-rule thresholds and timing values. A journey never states a
  cutoff.** *A Hold is placed on the Slot* is a step; *the Hold expires after
  five minutes* is a rule, and it belongs to the spec.
- **soliciting scoping settlements.** Who does a step today, and whether that
  changes, is legal scoping-interview ground. This run records what sources
  state; it does not negotiate the to-be.
- screen flows or UX sequences — governance-standards and `/plan` ground

## Inputs loaded

In this order:

1. `.specify/memory/roles-permissions.md` and `.specify/memory/domain-model.md`
   — **first, both**: the two citation surfaces. Roles are quoted verbatim from
   the first; entities are named from the second.
2. `canvas.md` — §7 function lines (the journey material and the significance
   evidence), §2 Problems and §12 Objectives (a journey exists to move one)
3. `.specify/memory/context.md` — where today's landscape shapes a step
4. `.specify/memory/glossary.md`
5. the current file — **arrival is never gated**; routed process findings already
   in it are input

## Procedure

1. **BA act.** Under the composed Requirements plan, the run is invoked — after
   the roles model.

2. **Framework act — the significance pass.** Propose the significant-role set
   with its evidence: every actor of ≥ 1 canvas Core Function line. The BA may
   elect further roles.

3. **Framework act — journey pre-draft.** Per significant role, assemble the
   major journeys from the canvas function lines **grouped into end-to-end
   sequences**, the value lines they serve, `context.md` where today's landscape
   shapes a step, and presale and kickoff statements. Roles verbatim; entities by
   domain-model name; **cite or mark per step**.

4. **Framework act — the coherence pass.** Every journey's role resolves to the
   role model; every entity touched resolves to the domain model. **A miss is a
   proposed edit on that file's ground, routed by batch — never a local
   definition.**

5. **Framework act — the questions.** Remaining holes become destination-tagged
   questions: a journey's trigger or outcome, a step's actor or observable
   result — **at helicopter grade only**. A hole answerable only at spec depth is
   not asked.

6. **BA act — the rulings.** The BA confirms or edits journeys and rules the
   significance set. A finding contradicting **cleared** ground — a canvas
   function line, the register, an objective — is a **reopen signal**.

7. **Framework act — write and report.** Write the file. Report which criteria
   the run moved — AT-RQ-4's journeys clause — and what remains open. The
   evidence-table refresh and the confirmation proposal belong to `/ba-run`'s
   post-run touchpoint; the clearing itself is the BA's, at `/ba-clear`.

## Output

`.specify/memory/processes.md` — one section per journey:

```
## <Journey name> — role: <role, verbatim from roles-permissions.md>
Trigger: <what starts it> → Outcome: <what stands changed>
1. <actor> <action> → <observable result>
Source: <citations>
```

**Step numbering is journey-local.** Nothing downstream cites a step by line —
consumers load the whole file — so there is no cross-file line-ID family here and
none is invented.

**Every significant role carries ≥ 1 journey.** A significant role with none is
the journeys clause's own first miss.

The template and a worked example are in `references/example.md`.

Plus routed batches where the coherence pass found misses.

## Signals

- **Routing batch** — a role or an entity the coherence pass could not resolve,
  proposed to its own file. Proposed, BA-approved, then written.
- **Reopen signal** — only once the contradicted aspect has been cleared or
  waived: finding · contradicted artifact + line · conflict statement. Emit it and
  stop; the reopen skill receives and rules it.
- **Depth refusal** — a hole that only spec depth can answer is reported as such
  and left unasked. Reporting it is the signal; asking it would be the defect.

## What this skill never does

Never writes an error path or an alternate · never states a threshold, a cutoff
or a timing value · never cites a role the role model does not define, or names
an entity the domain model does not carry · never defines a role or an entity
locally — it routes · never slices features or names epics · never drafts a story
or an acceptance criterion · never solicits a scoping settlement · never invents
a step-ID family · never confirms an AT criterion or clears an aspect · never
runs a CC assertion.
