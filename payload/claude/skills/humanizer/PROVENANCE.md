# PROVENANCE — `humanizer`

A **vendored third-party skill.** It is not framework-authored, and it carries no `ba-`
prefix: that prefix marks framework-owned skills, and a guest does not wear the house
colours (D-O89).

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
replaced with one that states the fence, so a loader that offers skills on description
match cannot offer this one for framework prose:

> Rewrites free prose to remove AI-writing patterns (upstream: blader/humanizer). EXPLICIT
> INVOCATION ONLY — apply solely when the BA explicitly asks to humanize a text. Never apply
> to canonical framework artifacts: spec.md bodies, WBS/exports and pinned renders, ledger
> heads and pinned blocks, gate/audit/BUILD-LOG records. When in doubt, do not apply.

The block scalar changes from `|` to `>-` so the value folds to exactly that single line.

**(b) Scope-fence block added at the top of the body**, immediately after the `# Humanizer`
heading and before all upstream body prose, marked in its own first line as a local
addition. It states the explicit-invocation rule, the absolute canonical-artifact fence,
the decline-and-point-to-the-writing-standard response, and the lawful surface.

**No pattern, example, rule or instruction of the upstream skill is edited, reordered or
removed.** All 35 patterns stand as upstream wrote them.

## Estate law

**D-O89** — orchestrator rules **§38**, compiled as **§10.3 rule 10**
(`docs/methodology/ba-native-spec-orchestrator-rules.md`).

Basis: the team sync of **20 Aug 2026**, AI item #2 (*"Женя: додати скіл Humanizer у
фреймворк"*), accepted by the owner; and the owner's **option-A** ruling of **21 Aug 2026**,
sequenced after **EC-16**.

- **Explicit BA request only.** The skill never self-triggers. §10.3 rules 1–9 remain the
  only law over framework prose.
- **The canonical fence is absolute.** Never `spec.md` bodies, §10.5 pinned exports and
  renders, ledger heads and pinned blocks, gate and audit records, or `BUILD-LOG.md` — and
  an **explicit** ask against one is **declined**, with a pointer to the writing standard.
  The fence is a property of the artifact, never of the asker.
- **Lawful surface:** free prose the BA supplies or requests — client-facing summaries,
  e-mails, arbitrary text.

Rejected on the record: **pipeline wiring** (a mandatory humanizer pass on named surfaces) —
mutation risk on pinned shapes, and it contradicts *"counts render, the BA judges"*.
Routed, not legislated: **distilling the 35 patterns into §10.3** on the section's own
ASD-STE100 mined-as-reference precedent — parked to the master conversation pending field
runs.
