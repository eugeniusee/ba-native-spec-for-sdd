---
name: ba-dev-ready
description: The dev-ready route - /ba-dev-ready <feature ...>, or a plain sentence naming the outcome, renders one route in the pinned shape and executes on one stated go. The go is three records in one act - the recorded profile switch Presale to Discovery with the order as its reason, the grant AG-<n> scoped to exactly the ordered features with the profile Discovery stated, and the route's own go. The route drafts the four artifacts Presale leaves out in assumption posture, completes each ordered spec against them, and requests the gate per feature - waivers AUTO on real gaps, never bypassed; the two flagged sign-offs and the PASS stay with the BA, left pending per feature while the run proceeds, and the route halts at scope exhaustion with the pinned mid-grant stop report naming the human tail. Never signs a sign-off, never approves a PASS, never ratifies, never grants itself the grant.
disable-model-invocation: true
---

# `/ba-dev-ready <feature …>` — from the presale estate to dev-ready

**What this does, in plain words.** After the WBS, you say which features go to
development. The framework takes them from the presale estate to **done,
awaiting ratification** — the four artifacts Presale left out drafted, each
spec completed against them, the gate run per feature — and leaves you exactly
the acts that must be a person's: the ratification, then per feature the two ⚑
sign-offs and the PASS (orchestrator §7.6).

## Invocation — two entry forms, one route

**Argument:** one or more features — `004`, `004-appointment-booking`, several
at once. BA-invoked, after `/ba-wbs`.

- **The command:** `/ba-dev-ready 004 005`.
- **A plain sentence naming the outcome** — *"віддай 004 і 005 в розробку"* —
  renders the same route: the repair-route pattern (D-O32) extended to this
  destination. Named by outcome, never by mechanism (§10.3 rule 11).

Both forms render the route below and wait for one stated `go`. Silence is
never consent; the render names the grant's scope before you say it.

**The `go` is the act — three records in one act:**

1. **The recorded profile switch** — the later switch at P-O0 — flow-profile
   selection, its Events line:
   `<date> · profile · Presale → Discovery · <initials> — /ba-dev-ready <features>`.
   The reason is the order itself.
2. **The grant** — `AG-<n> · scope: until every ordered feature stands done,
   awaiting ratification · granted-by: <initials>`, written by `/ba-auto on`'s
   own three writes with the profile **Discovery, stated by this route** —
   never inferred from `canvas.md`. The order **is** the grant: a grant is your
   stated act recorded in advance, and you said `go` to a render that names the
   grant's scope.
3. **The route's own `go`** — plan-as-route (§7.5), rows in order, no per-row
   acknowledgement.

**Where a grant already stands, the existing `off` comes first:** `/ba-auto
off`, the resumption report, one batch ratification. The profile never
switches mid-auto; the ratification is your act, so it is the route's one
conditional stop — an existing stop, never a new one. After it the order
stands as the continue, and no second `go` is asked.

## The route render — the pinned route shape (§10.6), this instance

```
Route — dev-ready: 004, 005 → done, awaiting ratification (AG-<n> written at go, scope: these features) · profile: Discovery (switched at go)
| # | Code — technique | Yields |
|---|---|---|
| 1 | T-11 — Domain (conceptual) modeling | memory/domain-model.md (assumption posture) |
| 2 | T-12 — Roles & permissions | memory/roles-permissions.md (assumption posture) |
| 3 | T-13 — Core process mapping | memory/processes.md (assumption posture) |
| 4 | T-15 — Constitution | memory/constitution.md (assumption posture) |
| 5 | Tier 2 — spec-depth gap-filling · 004, 005 | specs completed, markers on the record |
| 6 | Gate · 004, 005 | gate-report.md entries — waivers AUTO on real gaps, ⚑ and PASS left for you |
Stops en route: none — where a grant already stands, its off and ratification come first; scope exhaustion ends the route
Next: step 1 — go?
```

## The route, in order — each step reached by its owning skill

Steps 1 and 2 are the conditional `off` and the `go` above. Then:

3. **The four techniques out of Presale profile** — **T-11 — Domain
   (conceptual) modeling** (`/ba-t11`) · **T-12 — Roles & permissions**
   (`/ba-t12`) · **T-13 — Core process mapping** (`/ba-t13`) ·
   **T-15 — Constitution** (`/ba-t15`) — each run by its own skill,
   self-elected in **assumption posture** over the estate on hand: legal under
   the cost boundary (§10.7 — no client access spent, no external commitment),
   every election standing in the ratification batch. Under Discovery they are
   in profile; their artifacts lift the expected profile debt at its source,
   and AW state is untouched by the route — standing waivers meet the sweep at
   `off` as ever.
4. **Tier 2 — spec-depth gap-filling per ordered feature** (`/ba-tier2`),
   assumption posture, the draft completed against the artifacts step 3
   landed; markers as usual, the consolidated defer-confirm accepted AUTO
   (§10.7's defer row — unclear stays an Open Question, never an invention).
5. **The gate per ordered feature** — requested, never run, by this route
   (`/ba-gate <feature>`). Gate P2's policy row applies **as written** (§10.7):
   waivers AUTO on real gaps, the non-waivable set fixed and re-gated, never
   bypassed; the ⚑ bundle is computed on every run (gate §5.3); the
   *certifying guesses* advisory renders exactly where gate law puts it — at
   the waiver act, once.
6. **Done, awaiting ratification — per feature, and the run proceeds.** The
   run leaves each feature's two ⚑ sign-offs and its PASS **pending** — they
   stay with the BA — and moves to the next ordered feature.

## The halt — the pinned mid-grant stop report

The route halts at **scope exhaustion** (hold condition 3) and renders
`/ba-auto`'s pinned shape, byte-identical:

```
Auto paused — <date> · <safety floor: <act — code + name> | scope exhausted: <the AG's scope edge, as AG-<n> states it>>
Stands: <what the run completed, one line> · mid-flight: <none | run aborted, artifact stays draft>
Auto-trail since <start | last boundary>: <n> acts · Assumptions: <n> · Open questions: <n>
Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>
```

Its `Resume from:` line names the human tail in plain words — this route's
instance:

```
Resume from: /ba-auto off → ratify the batch → per feature: the two ⚑ sign-offs, then the effective PASS (004, 005)
```

The register's `What I need from you:` closing ask follows as the report's
tail (§10.3 rule 9).

**A safety-floor stop halts this route only where the remaining scope depends
on the floor act** — the scope frame's case (P-O0b — scope-frame selection):
nothing downstream can proceed until the frame stands. A floor act nothing in
the remaining scope depends on — a feature's ⚑ sign-offs, its PASS — is left
pending, named in the tail, and the run proceeds. The sign-offs stay per
feature: each bundle is signed on its own.

## After the tail — nothing to remember

Once a feature carries its effective PASS, the certified-text check runs by
itself when implementation takes the feature (gate §11.2): the route ends at
the PASS and hands nothing over by command.

## Budget

The ≤ 8 Presale budget spans Frame to the rendered WBS; this route begins
after the WBS and sits outside that span — one interaction, the `go`, plus the
ratification where a grant stood.

## What this skill never does

The safety floor sits outside every grant, and this route carries no
exception: never signs a ⚑ sign-off · never approves a PASS · never ratifies —
the batch is yours at `off` · never runs the adapter — the certified-text
check is implementation's own first act, at take-up (gate §11.2) · never books
a client call, a workshop or an interview slot, and never makes a commitment a
person outside the run must honour · never switches the profile except by this
route's `go`, recorded · **never grants itself the grant** — the order is the
grant, and you stated it.

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
