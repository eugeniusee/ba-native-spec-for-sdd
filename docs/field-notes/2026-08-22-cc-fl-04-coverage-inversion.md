# Framework defect report — CC-FL-04 reads a marker as coverage, and coverage as a gap

**For:** the BA-Native Spec (`ba-native-sdd`) framework maintainer.
**Reported from:** a live Scope-F gate run — project Nutrivity, run 4, profile Presale, 2026-08-22. Source analysis: `BUGCCFL04.md` (BA: EK); this note is the verified triage, with the source report's evidence recomputed first-hand and three findings added.
**Component:** `docs/methodology/ba-native-spec-completeness-contract.md:140` → compiled to `payload/specify-overlay/ba/cards/assertions-f.md:82` (`CC-FL-04`).
**Severity:** high. A false-PASS generator on a coverage assertion, and a false-FAIL generator on correct specs, in the same assertion, on the same table.
**Status:** no framework-level fix exists. The defect reproduces on every Scope-F run. Amendments proposed in §6; **all land on the methodology layer** and are the maintainer's act.

---

## 1. Summary

`CC-FL-04` guarantees that every error path in a spec's flow table is backed by a
testable requirement. It inverts on two counts:

1. A row whose **System behavior** cell holds an `[ASSUMED: …]` tag instead of a
   behavior **passes**. 45 of 45 such rows passed.
2. A row whose behavior **is covered verbatim by an existing IF/THEN requirement**
   **fails**, because the row carries no literal parenthetical citation. 82 of 86
   such rows failed.

**The more the authoring run invents, the cleaner the gate reads.** An unverified
guess is consumed as evidence of coverage; genuine coverage is reported as a gap.

---

## 2. Evidence — recomputed, not relayed

Run `~/Documents/presale-nutrivity 9`, 25 features, `.specify/ba/runs/*/run-4/a-pass.json`
cross-tabulated against every error row's `[ASSUMED: …]` state, recomputed for this note:

| | Row carries `[ASSUMED: …]` | Plain row |
|---|---|---|
| **FAIL** | **0** | **82** |
| **PASS** | **45** | 4 |

25 of 25 specs carry a run-4 A pass; 82 findings total. The correlation is
near-total and runs backwards. This reproduces the source report's table exactly.

`001-demo-access`, the worked case — CC-FL-04 **FAIL** on `E1`, `E2`, `E4`:

```
| E1 | Credentials match no prepared account | Refuses the sign-in; opens no session | The sign-in screen states that the credentials are not recognised |
| E4 | An Admin / Demo User switches presented role mid-session | Re-renders the visible areas for the newly presented role | The presented role's areas appear; the previous role's areas disappear |
| E5 | Two people sign in to the same prepared account at once | [ASSUMED: yes. Demo accounts are shared during a presentation] | — |
```

`E1` is covered word-for-word by `FR-002 (US1) — IF a user submits credentials
matching no prepared demo account, THEN THE SYSTEM SHALL refuse the sign-in and
leave no session open.` It fails. `E5` states no behavior at all. It passes.

The evaluator's own evidence line names the standard it applied:

> `"evidence": "3 of the section's error rows cite no covering requirement"`

The card says **covered**. The evaluator says **cite**.

---

## 3. Root cause — three findings the source report does not carry

### 3.1 `[ASSUMED: …]` is not a framework marker

The literal string `[ASSUMED` occurs **zero** times in `payload/` and `docs/`. The
framework's one inline gap marker is `[NEEDS CLARIFICATION: …]`. The designed home
for an assumption is a **counted** `A<n> — <assumption> · source: …` line in
Assumptions & Risks (`payload/claude/skills/ba-tier1/SKILL.md:179`), which the run
trail reports as `Assumptions: <n>`.

The run invented an inline marker, placed it in a cell whose contract demands a
behavior, and no assertion rejects it **because nothing knows it exists**.

There is a second cost past the gate: those 45 assumptions never entered the
`Assumptions: <n>` count either. They are invisible in the trail as well as in the
verdict — the BA reads a stop that does not know they were made.

### 3.2 CC-FL-03 is inverted on the same row

The source report reads *"no other assertion failed in this run"* as a clean
baseline. It is not one. `001-demo-access` run-4 records:

> `{"assertion": "CC-FL-03", "verdict": "PASS", "evidence": "every error row carries trigger, system behaviour and user-visible outcome"}`

Against row `E5`, whose System behavior is a tag and whose user-visible outcome is
`—`. CC-FL-03 fails a row with **any of the three empty**. So the source report's
"consider auditing the other CC-* assertions" is not hypothetical — **it has
already happened, on the adjacent assertion, on the same row.**

This relocates the root cause. The defect is not CC-FL-04's wording alone; it is
that an **unrecognised bracketed marker is read as cell content by every assertion
that reads a cell.**

### 3.3 The template is not shape-broken — the literal reading is already licensed

The source report's claim 4 (*template/assertion contract break*) does not hold. The
writing standard's own worked example carries the citation **inside the System
behavior cell** (`docs/methodology/ba-native-spec-writing-standard.md:173`):

```
| E2 | Slot taken during page view | Reject booking (FR-00x) | Current availability for that Specialist |
| E3 | Client at BR-001 limit (§8) | Block booking | Limit explained + list of own Booked appointments |
```

The affordance is designed and documented. It never propagated into the comment in
`payload/specify-overlay/templates/spec-template.md:41-46` — the only form the
authoring agent reads at runtime. **Option B needs no fifth column and invalidates
no existing spec.** It is a propagation gap, not a contract break.

**And the same example settles the semantic-vs-literal question on the framework's
own evidence:** row `E1` of that table (`Hold expires (5 min) before confirm |
Release slot | …`) carries no citation. Under the literal reading the methodology's
canonical example **fails its own assertion**. The literal reading is therefore not
the framework's intent, and Option A is the only self-consistent choice.

---

## 4. Why the existing epistemics did not catch it

`CC-G-02` already fails placeholder tokens — *"TBD, TODO, 'to be defined', template
boilerplate"*. It is a closed enumeration of tokens the framework anticipated. An
authoring run that mints a **new** marker steps outside the list, and CC-G-02 reads
its cell as substantive content.

The machinery for the correct outcome already exists and was simply not reached.
CC-G-02's refusal reason (contract line 315) states the destination exactly:

> An *unnamed* gap cannot be risk-accepted. The path is: name it — convert the stub
> to `[NEEDS CLARIFICATION: …]`, which fails CC-G-03, which **is** waivable. Every
> accepted gap is thereby a named gap, by construction.

That is precisely where an `[ASSUMED: …]` row belongs. And CC-G-03 is an **M**
assertion — a script, not a judgement — so a marker routed there is caught
mechanically rather than re-litigated by an evaluator every run.

---

## 5. Precedent — same defect family, already on the record

This is the same shape as the two Slack-scan escapes (`2026-08-16`, `2026-08-20`):
**a state asserting a completeness nothing verified.** There, `captured` was true of
the transport and false of the artifact; `complete` was true of the query and false
of the workspace. Here, **`covered` is true of the cell and false of the spec.**

The corpus-declaration rule proposed in the 2026-08-20 note (§6.5) governs
retrievals. This defect is its authoring-side twin: a *marker* is treated as
carrying a property it only names. Worth closing as one class.

---

## 6. Proposed amendments

Drafted in the framework's register for direct incorporation. **All are
methodology-layer edits.** `assertions-f.md` is compiled — `tests/check-cards.py`
byte-compares it against these documents, so every amendment below lands in the
contract and the cards are regenerated with `tests/check-cards.py --record`.

### 6.1 Amend `CC-G-02` (contract line 84) — close the marker class, not one token

Replace the assertion text with:

> No stub content: every required section contains substantive, feature-specific
> content or explicit `N/A — <reason>`. Empty bodies, placeholder tokens (TBD,
> TODO, "to be defined", template boilerplate) fail. **The marker namespace is
> closed: the framework defines `[NEEDS CLARIFICATION: …]` and `[CONFLICT: …]` and
> no others. Any further `[…]` token is a mint, is not content, and fails wherever
> it stands in place of the required content — including a table cell. An
> unrecognised marker is converted, never honoured.**

**The namespace must be enumerated, not inferred.** A first drafting of this clause
read *"any `[…]` other than `[NEEDS CLARIFICATION: …]`"* and was wrong: the
framework defines a **second** marker, `[CONFLICT: <A> says … · <B> says …]`
(D-B1-2 — `payload/specify-overlay/ba/templates/canvas-template.md:13`,
`ba-t01`, `ba-t09`, `ba-analyst:193`, `ba-discovery:181`). It reaches CC-G-02's
logic through **CC-H-01** (contract line 215), which applies the stub test to
`canvas.md` — and the Nutrivity `canvas.md` carries one. The narrower wording
would have failed CC-H-01 on the very run that reported this defect. Ten
occurrences of `[CONFLICT:` and 28 of `[NEEDS CLARIFICATION:` across `payload/`
and `docs/`; **no third marker exists**, which is what makes closing the
namespace safe.

Rationale: this is the class fix. It closes the escape across **every** assertion
that reads a cell — CC-FL-03 and CC-FL-04 together, and the thirty-two others —
rather than patching one card and leaving the next mint to be discovered in
production. It routes an `[ASSUMED: …]` row down the path CC-G-02's own refusal
reason already defines, and lands it on CC-G-03, which is script-checked.

### 6.2 Amend `CC-FL-04` (contract line 140) — name one standard, and it is the semantic one

Replace the assertion text with:

> Every error path's system behavior is **governed by a requirement in this spec**:
> an unwanted-behavior FR (IF/THEN, WHILE), an event-driven FR (WHEN) where the row
> is an alternate rather than an error, or a referenced BR. **Coverage is semantic —
> the evaluator searches the spec's requirement list and fails only where no
> governing requirement exists. An inline citation is permitted style, never the
> pass condition.** Unspecified error handling fails.

Rationale: resolves the two standards the present sentence licenses, in the
direction §3.3 shows the framework already intends — the methodology's own worked
example fails the literal reading. Folding `WHEN` in closes the secondary defect
(alternates judged as errors) without splitting the table, so no existing spec
changes shape.

### 6.3 Propagate the citation form into the runtime template — the only payload-layer item

`payload/specify-overlay/templates/spec-template.md:41-46`. Amend the comment so the
form the writing standard already demonstrates is visible to the authoring agent:

```
<!-- Main flow as numbered steps: actor → action → observable result.
     Then the alternates/errors table — every row: trigger · system behavior ·
     user-visible outcome. A happy-path-only flow fails. (CC-FL-01…05)

     Every row's behavior must be governed by a requirement in this spec — an
     IF/THEN or WHILE FR for an error, a WHEN FR for an alternate, or a BR.
     Cite it inline in the System behavior cell where it aids the reader;
     the citation is style, the coverage is the requirement. An assumption is
     never a behavior — it belongs in Assumptions & Risks as A<n>, or as
     [NEEDS CLARIFICATION: …] where it blocks the row.

     | # | Trigger | System behavior | User-visible outcome |
     |---|---|---|---| -->
```

### 6.4 Regression fixture (source report Rec 4) — with one caveat on its nature

The A pass is an LLM judgement, so a fixture is a **spec + expected-verdict record**
run against a live gate, not a deterministic assert in `run-all.sh`. Three rows:

| Fixture row | Expected |
|---|---|
| behavior present, covered by an IF/THEN FR, no inline citation | **PASS** (§6.2) |
| behavior replaced by `[ASSUMED: …]`, no FR anywhere | **FAIL** — CC-G-02 (§6.1), and CC-FL-03 |
| alternate covered by an event-driven `WHEN` FR | **PASS** (§6.2) |

Row 2 is the one that matters: it is the currently-inverted case, and it should now
fail on the **global** assertion, not on CC-FL-04 — which is the check that §6.1
landed as a class fix rather than a local one.

### 6.5 What these amendments do not do — the prevention half is unwritten

§6.1–6.3 make the gate **catch** a minted marker. Nothing above stops one being
**minted**. The authoring personas draft under assumption posture with no rule
naming where an assumption goes: `ba-analyst.md` carries the `[CONFLICT: …]`
instrument and the *never assumed* discipline for **rulings**, but says nothing
about an assumption inside an artifact cell, and `ba-tier2` describes the posture
without prescribing a form. The counted home exists — `A<n> — <assumption> ·
source: …` in Assumptions & Risks (`ba-tier1/SKILL.md:179`) — and is simply not
routed to from the drafting path.

So after §6.1 the Nutrivity shape fails **loudly** instead of passing silently,
which is the defect closed. But the run still mints the marker, and the BA meets
it as 45 new failures rather than 45 counted assumptions. **The authoring-side
rule is a second act on payload ground** — `ba-analyst` / `ba-tier2` — and is not
drafted here, because a behavioral rule for a persona is a ruling, not a
propagation.

---

---

## 7. Blast radius in the affected run

82 findings across 25 features are **not** all false positives, and the triage below
them is real: the run has 82 flagged rows against 33 IF/WHILE requirements in total,
and five features (`004`, `010`, `011`, `014`, `018`) carry flagged rows with zero
IF/WHILE FRs to match. Behavior is being written into flow tables and never restated
as a requirement.

**The defect is that the assertion cannot tell that real finding apart from a
correctly-covered row, while waving through the 45 rows that specify nothing at
all.** After §6.1–6.2 the 82 must be re-derived; the number will fall, and what
remains will be the genuine gap.
