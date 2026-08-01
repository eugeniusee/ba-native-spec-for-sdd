# The elected charter — what T-04 would have produced, and why it lives here

**FIXTURE (S6).** `personas.md` in this directory is a **persona charter the BA
elected**, in the shape the T-04 sheet pins — the three transformation clauses at
the head, one charter per elected register population, six fields, sourced.

## Why it is not in `../../project/.specify/memory/`

**The canonical timeline runs charter-free.** The composed Stakeholders plan
holds two techniques and adds nothing; no `personas.md` is ever born in it; and
the Requirements evidence table records that absence in as many words —
*"no personas.md exists, so the persona→role principle is stated in the
constitution's Authorization row and no persona is used as a role"*. The persona
clause of AT-RQ-2 is conditional, and in this world it stays **dormant**.

That is not a gap in the fixture. It is the shape of the technique: T-04 is
**enrichment**, no threshold criterion demands it, and **charter absence is a
legal end state**. A world in which the BA never elected charters is the world
the corpus actually records.

So the charter sits here, one directory away from the estate, exactly as the
sheet frames its own micro-example: *this is the charter a BA election would have
produced from the same facts; the world's canonical artifacts are unchanged by
it.* Dropping the file into `.specify/memory/` would silently activate a dormant
criterion and contradict a cleared evidence table — for a technique whose entire
point is that it was never required.

## What the suite proves against it

`tests/check-techniques2.sh` runs the artifact validator over this file and
asserts the three clauses mechanically, not by eye:

- **TC-1** — the charter's `details:` population resolves to an entry in the
  first-pass register (`../first-pass/stakeholders.md`)
- **TC-2** — every system-facing activity is a capability line, verb + object,
  and its objects are glossary-canonical
- **TC-3** — the persona name is disjoint from every register population, every
  register individual, and every role in `roles-permissions.md`

TC-3 is the one with teeth downstream: this file's name set is the screening
surface a non-waivable spec assertion greps for. The suite asserts that the
certified spec contains no name from here — which is only a meaningful assertion
because the name (`Marta`) is one no other artifact uses.

## The two files that carry the same charter

`../../negatives/personas.md` carries the same charter for a different purpose:
it is the screening surface the marker/banned-word checker's negative case reads,
so that a spec seeded with a persona-as-actor has something to fail against. The
suite asserts the two agree on the name set rather than letting them drift into
two worlds.
