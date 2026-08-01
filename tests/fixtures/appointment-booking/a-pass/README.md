# Recorded A-pass sheets — gate runs 2 and 3

Stage 3 of a Scope-F run is the **gate agent** reading `assertions-f.md` against
the snapshot (gate §4.1, §5.2). An agent pass is not deterministic, so it cannot
be re-derived inside a regression suite the way the M pass is. These two files
are the corpus's run-2 and run-3 A verdicts **recorded once**, in the same JSON
shape the M checkers emit, so everything downstream of the A pass — disposition,
verdict assembly (§6.1), the report entry (§6.2), waiver/override lifecycle,
certification — is exercised end to end and deterministically.

What is *not* proven by this: that a live `ba-gate` agent produces these
verdicts. That is the agent prompt's job and it is proven by running it, not by
a fixture. What *is* proven: given the corpus's own A verdicts, the machinery
reproduces gate §14's runs 2 → 3 exactly.

## Dispositions worth knowing

**`CC-AC-03` passes on r5's US1 scenario, and its defect is booked at
`CC-AC-04`.** The scenario ("Given a Client selects an available Slot") carries
no timestamp and no quantity, but it also carries none of CC-AC-03's named
placeholder forms (`<x>`, "some", "a user") — it names the Client role and the
resulting status. Contract §7's worked example books this scenario solely as a
re-narration, and the recorded sheet follows the corpus.

**`O-004-01` attaches to a checklist line, not to a Gherkin scenario.**
Contract §7 renders the override's element as *US2 / scenario "Cancellation at
the 24h boundary"*; this fixture's US2 carries the 24h boundary as **checklist
lines**, not a scenario. That makes the recorded verdict a textbook false
positive — CC-AC-04 governs Gherkin scenarios and does not reach a checklist
line — which is exactly what an override is for, and it re-applies at run 3
because US2's acceptance block is byte-identical across r5 → r6 (gate §7.3,
§14.2). The instrument and its mechanics are the corpus's; only the element's
rendering differs from §7's prose.
