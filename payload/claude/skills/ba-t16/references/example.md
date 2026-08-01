# T-16 — output template & worked example

## The template

```markdown
# Out of Scope — <project> (global)
The product-level fence. Per-feature exclusions live in each spec's
Out of Scope section and reference this file, never restate it.

## Exclusions
| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
```

The lives-instead vocabulary at Band-1 grade: `not planned` ·
`deferred — roadmap candidate, <phase hint>` · `outside the product — <owner>`.
After decomposition, deferred rows resolve to named epics or retire.

## Worked example — the Requirements seed, before any decomposition

| Exclusion | Where it lives instead | Basis · source |
|---|---|---|
| Medical records / clinical data — the system holds none | outside the product — clinics' existing record-keeping remains the system of record | regulatory bind excludes medical-record data `[constraints.md §3]`; the clinic domain makes the expectation plausible |
| Online payments | deferred — roadmap candidate, beyond MVP | canvas §9: currencies `N/A — no payment surface in MVP scope` · kickoff notes |
| Cross-network marketplace listing | not planned | a competitor covers it `[competitive-analysis.md]`; the differentiation is the network's own channel `[canvas §11]` |

## What the example is showing

- **Three rows, three vocabulary values, one each.** That is not a coincidence of
  this project — it is what a real fence looks like. *Somebody else owns it*,
  *maybe later*, and *never* are genuinely different answers, and collapsing them
  into a single "out of scope" column loses the only information a reader wants.
- **Every row names the expectation it fences.** The medical-records row does not
  merely state a legal bind; it says *the clinic domain makes the expectation
  plausible*. That clause is the row's justification for existing. A fence around
  something nobody would have expected — *the product does not sell insurance* —
  is noise, and the sweep drops it with a note rather than writing it.
- **The marketplace row reads two other files and adds neither.** The competitor
  analysis supplies the *Covers* entry the product does not cover; the canvas
  supplies the differentiation the fence quotes. The boundary is the vision's own
  boundary, restated as an exclusion — not a new opinion formed here.
- **The payments row carries a phase *hint*, not a phase.** *Beyond MVP* is what
  the evidence supports at Band 1. `Phase 2` would be an allocation, and
  allocation happens after decomposition, by a different act, with a diff and a
  logged reason.

## The graduation path

The payments row is the case worth following all the way through.

At Band 1 it reads `deferred — roadmap candidate, beyond MVP`. At Band 2,
decomposition lands an **Online payment** epic — and a **routed edit** resolves
this row to that epic, or retires it from this file.

What does *not* happen: this technique is not re-invoked; nobody re-sweeps the
adjacencies; no daemon watches the roadmap. The boundary stays alive by the
machinery already running — routing batches for graduation, and a **reopen signal
on Requirements** if an epic ever contradicts a standing exclusion. And once the
row has graduated, a later feature spec fencing *Payments — Phase 2, epic "Online
payment"* is writing the **post-graduation** form of this same boundary at its own
grain, referencing rather than restating.

## The two grains, in one world

A feature spec for appointment booking fences *Notification preferences —
deferred, Phase 2* in its own Out of Scope section. That fence is **feature
grain**: it tells a reader of that spec which neighbouring capability the feature
deliberately does not build.

It never enters this file. This file's payments row tells a reader of the
*product* that money does not move inside it. Both are true; they answer
different questions; and the check that keeps them apart is the one that refuses
a spec exclusion which merely restates a product-level boundary.

## When the fence is genuinely empty

Suppose the sweep finds nothing: every adjacency is claimed, every competitor
*Covers* entry is covered, no constraint excludes a class, nothing was declined.

The answer is **not** an invented row. It is the aspect waiver on Requirements,
with the debt named — *the product boundary is undrawn; the first scoping call
will surface it*. A row written to satisfy a minimum is ritual compliance: it
passes the criterion and fences nothing, which is strictly worse than an honest
gap with a revisit trigger on it.

In practice the solution surface almost always supplies a plausible adjacency,
which is why the seed minimum is one and not zero. But *almost always* is not
*always*, and the waiver is the valve.
