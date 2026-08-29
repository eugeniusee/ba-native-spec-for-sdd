# PROVENANCE — `humanizer`

A **vendored third-party skill.** It is not framework-authored, and it carries no `ba-`
prefix: that prefix marks framework-owned skills, and a guest does not wear the house
colours (D-O89). **The switch that runs it is ours and does wear the prefix** —
`/ba-humanizer on|off`, at `payload/claude/skills/ba-humanizer/` (D-O97).

## Upstream

| | |
|---|---|
| Project | **blader/humanizer** |
| URL | https://github.com/blader/humanizer |
| Pinned version | **2.11.2** (the ruling named 2.11.0 — see *Pin ruling* below) |
| Upstream commit | `38b88903a5080c72a8c0472e79dcc9ffbf07938b` (`38b8890`) — *"Simplify Humanizer packaging and README (#230)"*, 18 Aug 2026 |
| Licence | **MIT** — `LICENSE` vendored **verbatim**, byte-identical to upstream at the pin |
| Vendored on | **21 August 2026**, package 0.1.37 |
| Vendored files | `SKILL.md` · `LICENSE` · this file |

## Pin ruling

The estate ruling of 21 Aug 2026 named the pin **v2.11.0**. Upstream stood at **v2.11.2**
when the vendoring ran, so the pin went back to the owner rather than being resolved in
the pass. The measured delta between 2.11.0 (`43c9767`) and 2.11.2:

- `SKILL.md` — **four lines**: the frontmatter `description`, the `metadata.version`
  string, and the opening body sentence. **All 35 patterns byte-identical.**
- Everything else in the two releases is packaging (`.claude-plugin/`, the Desktop package,
  `scripts/validate-package.py`, `README.md`) — files this estate does not vendor.
- Because local delta (a) below replaces the `description` block outright, the choice
  reaches the shipped artifact as **one prose line**.

**Ruled 21 Aug 2026: pin 2.11.2 at `38b8890`** — the commit that sets the version, not the
clone HEAD (`e2e92e7`), which stands one README-only commit later.

Refresh is a ruling, never a routine: nothing in the estate watches upstream for drift.

## Local deltas — exactly two

Everything not listed here is **byte-identical** to upstream `SKILL.md` at `38b8890`.

**(a) Frontmatter `description` replaced.** Upstream's relevance-triggering description is
replaced with one that states **when this runs and what it never touches**, so a loader
that offers skills on description match reads the switch and the fence off the description
itself:

> Rewrites prose to remove AI-writing patterns (upstream: blader/humanizer). Runs under the
> BA's switch `/ba-humanizer on` over every render and every prose artifact — embedded mode,
> final text only, every claim kept, nothing invented. Never touches machine-read lines:
> ledgers, gate/audit records, pinned shapes, IDs and markers, tables, code — a guard asserts
> it. Off by default; `/ba-humanizer off` stops it.

The block scalar changes from `|` to `>-` so the value folds to exactly that single line.

**(b) Scope-fence block added at the top of the body**, immediately after the `# Humanizer`
heading and before all upstream body prose, marked in its own first line as a local
addition. It states **when the skill runs** (the BA's switch, default off, the scope while
on), **embedded mode** (final text only, every claim kept, nothing invented), **the fence at
the machine-read line** (the two runtime ledgers, gate/audit records, `BUILD-LOG.md`, the
pinned shapes, the ID and marker tokens, tables, code fences, front matter, paths, commands,
link targets, numbers, dates, quotes, citations), the **structure-never rule**, the writing
standard's **seniority**, and the **guard** that asserts it at every file write.

**No pattern, example, rule or instruction of the upstream skill is edited, reordered or
removed.** All 35 patterns stand as upstream wrote them.

**Amended 28 Aug 2026, package 0.1.44 — D-O97.** Both delta texts above are rewritten to
the switch law; **the count stays two, and the pin is unchanged** — nothing upstream was
re-fetched, and the region from the first upstream body line onward was re-verified
byte-identical against a fresh checkout at `38b8890`.

## Estate law — D-O89, 21 Aug 2026 (two clauses superseded; see below)

**D-O89** — orchestrator rules **§38**, compiled as **§10.3 rule 10**
(`docs/methodology/ba-native-spec-orchestrator-rules.md`).

Basis: the team sync of **20 Aug 2026**, AI item #2 (*"Женя: додати скіл Humanizer у
фреймворк"*), accepted by the owner; and the owner's **option-A** ruling of **21 Aug 2026**,
sequenced after **EC-16**.

What D-O89 ruled, in summary — **the first two items are superseded by D-O97 and are
recorded here as history, never as instruction**; the operative law is the section below:

- **Invocation.** *Superseded.* D-O89 confined the skill to an ask from the BA. **D-O97
  replaced that with the switch.**
- **The fence.** *Superseded.* D-O89 fenced by artifact — `spec.md` bodies, §10.5 pinned
  exports and renders, ledger heads and pinned blocks, gate and audit records,
  `BUILD-LOG.md` — and refused an ask against one. **D-O97 moved the fence to the
  machine-read line and made a script assert it.**
- **Lawful surface.** *Standing, and widened by D-O97* — free prose the BA supplies or
  requests, and, while the switch is on, framework prose too.

Rejected on the record: **pipeline wiring** (a mandatory humanizer pass on named surfaces) —
mutation risk on pinned shapes, and it contradicts *"counts render, the BA judges"*.
Routed, not legislated: **distilling the 35 patterns into §10.3** on the section's own
ASD-STE100 mined-as-reference precedent — parked to the master conversation pending field
runs.

## Estate law — amended 28 Aug 2026

**D-O97** — orchestrator rules **§43**, compiled as **§10.3 rule 10, rewritten in place**
(`docs/methodology/ba-native-spec-orchestrator-rules.md`); §2.4 · §10.4 · §10.7 · §38's
appended note.

Basis: the owner's ruling of **28 Aug 2026** — *"має бути команда humanizer on/off … всі
відповіді і артефакти агента проганяються через humanizer … працює, поки користувач не
змінить свою думку"* — taken as `apply all`, read against the team sync of 20 Aug 2026.

**Superseded from the D-O89 list above — the two clauses, named:**

- *The invocation clause* — D-O89's rule that the skill ran on an explicit ask and on
  nothing else. The skill now runs under the BA's switch, `/ba-humanizer on|off`, over
  **every render and every prose artifact** while on. Default **off**; the mode persists
  across sessions until `off`.
- *The canonical fence is absolute / an explicit ask against one is declined.* **The fence
  moves from the artifact to the machine-read line.** A `spec.md` body's prose is rewritten;
  its headings, ids, markers, tables and fences are not. Nothing is declined — the guard
  asserts it, and on failure the original is written with one tail line naming the anchor.

**Standing, unweakened:** the vendoring · the pin (2.11.2 @ `38b8890`) · MIT, verbatim ·
this file · the guest's bare name without `ba-` · and the rejection of an **always-on
mandatory** pass, which the switch answers rather than reverses.

**The two local deltas stay exactly two**, their text amended under D-O97; **the pin is
unchanged and nothing upstream was re-fetched.** Everything from the first upstream body
line (`Rewrite AI-sounding text …`) onward remains byte-identical to `38b8890`, re-verified
against a fresh checkout at this pass.

