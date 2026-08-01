# T-15 — output template & worked example

## The template

```markdown
# Constitution — <project>
Read by the plan step's Constitution Check. Principles live here;
detailed matrices live in the referenced governance files —
reference, never restate.

## Principles
| Principle | Statement (MUST form) | Enforcement surface | Source |
|---|---|---|---|

## Governance references
| File | Carries |
|---|---|
```

Named principles, no ID family. The references table is Governance-class only,
and each entry resolves to an existing, stub-free file at write time.

## Worked example — the Requirements seed, no charters

## Principles

| Principle | Statement (MUST form) | Enforcement surface | Source |
|---|---|---|---|
| Authorization | Permissions MUST derive from `roles-permissions.md` policy rows only; they are never inferred from personas or narrative material | `roles-permissions.md` · the per-tuple and persona-name checks at every gate | framework seed |
| Spec-first iteration | Requirements defects MUST be fixed in the spec and re-run downstream — never hand-patched in code | delivery loop · BA verification | framework seed |
| Data boundary | The system MUST NOT store or process medical-record data; Client personal-data handling stays inside the binding regime | `constraints.md` §3 · feature gates, security/privacy category | constraints.md §3 — Olena, 2026-07-09 |

## Governance references

| File | Carries |
|---|---|
| `.specify/memory/roles-permissions.md` | role model + resource×action policy — the Authorization principle's detail |
| `.specify/memory/design-standards.md` | global budgets + UX conventions |

## What the example is showing

- **Authorization is seeded although no charters exist.** There is no
  `personas.md` in this project, so the persona clause of the threshold reads
  *dormant* — and the principle stands anyway. The day a charter arrives, the
  constitutional basis for screening its name is already in force rather than
  being retrofitted under pressure. One line, paid for early.
- **Spec-first iteration is the one house rule that belongs here.** It binds
  conduct *after* the handoff — which is precisely the surface the plan check
  reads. Contrast: requirement grammar and table discipline are enforced by the
  gate on the spec, before any of this is read. Putting them here would ask the
  plan check to re-enforce spec rules on the wrong artifact.
- **The Data-boundary row is the principle-vs-detail screen at work.** The
  binding regime's detail — which law, whose ruling, what it covers — stays in
  the constraint row, referenced. What is constitutional is one MUST sentence.
  Had the whole regulatory analysis been pasted here, the plan check would be
  reading a legal memo and the constraint file would have a rival.
- **Every principle names its enforcement surface.** That column is what makes
  the file testable rather than aspirational: a principle nothing enforces is a
  wish, and a wish that a check cannot gate a plan against gets rewritten or
  demoted.

## The reference spine, and what it is *not*

The two references above are the checked set — and the gate's static core expands
to exactly *"the constitution plus every governance file it references"*. At this
world state that is three files, and all three are hashed into every
certification manifest.

**`out-of-scope.md` is deliberately absent from the spine.** It is Context-class,
not Governance-class. It is spec-anchored and health-checked like everything else
under `memory/`, but referencing it here would pull a Context file into a
Governance-only structure and quietly widen what the reference-resolution check
owns. The spine is a class boundary, not a list of important files.

Editing this table is therefore a consequential act: it changes what every future
health run reads, and what every future gate run hashes.

## The check that runs at write time

Before the file is written, each spine entry is resolved: does the file exist,
and does it carry real content?

A reference to a file that does not exist is not a health failure to be
discovered later — it is a **planning defect, surfaced now**, and it usually
means a run was left out of the composed plan. The ordering rule (roles before
this, design standards before this where design ground exists) exists to make
that failure structurally impossible rather than merely detectable.
