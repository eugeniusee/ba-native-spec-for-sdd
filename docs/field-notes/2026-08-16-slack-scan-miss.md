# Post-mortem — Slack channel scan missed `#est_nutrivity` on the first `/ba-frame` run

**Date:** 2026-08-16
**Context:** Band-1 entry (`/ba-frame`) for project **Nutrivity** (presale).
**Actor:** Claude Code executing the `ba-frame` skill's Slack candidate scan.
**Target channel that should have been offered:** `#est_nutrivity` (private, created 2026-06-09 by Andriy Frantsishkevych, not archived).
**Tool under test:** `mcp__…__slack_search_channels` (self-described: "Search for Slack channels by name or description").
**Audience:** framework maintainers — for deciding a fix so the scan is predictable next time.

> This is a maintainer hand-off document, deliberately placed outside the framework's parsed paths (`.specify/`, `specs/`). It records tool behavior, not project content.

---

## TL;DR

The channel exists and was reachable the whole time. The first-run scan issued **one query — the bare project name `nutrivity` — got zero results, and concluded "no match."** That conclusion was wrong for two compounding reasons:

1. **Workspace naming convention.** Project channels are prefixed: the channel is `est_nutrivity`, not `nutrivity`. The bare project name is an *infix*, not the channel name.
2. **The search tool does not do reliable "contains" matching.** It reliably matches the **exact full name** and **left-anchored prefixes** of the full name; a bare infix like `nutrivity` or its stem `nutri` returns **zero** — even though it is a literal substring of the channel name.

A single zero-result from this tool is therefore **not evidence of absence**. The robust fix is to **list channels and filter locally**, not to trust a single name-keyed search.

---

## What the skill's scan is contracted to do

From `ba-frame/SKILL.md` (the Slack candidate scan section):

- Run whenever Slack is reachable; offer the **best match** on one line.
- **"The key is the project name, and nothing else"** — never the client's name, never domain terms.
- **"One candidate, never a list."**
- Render the candidate lines **"only when Slack is reachable and the scan matched"**; on no match, render the block without them and "say nothing about a scan that did not run."

The contract fixes the **key** (project name) and the **render** (one candidate). It does **not** specify how to search a workspace whose channels are named by convention, and it implicitly treats one search's zero-result as "no match." That gap is the root of the miss.

---

## What happened — first run

| Step | Query issued | Result |
|---|---|---|
| First-run scan | `nutrivity` (bare project name) | **0 results** → rendered "no candidate" |

That was the entire first-run scan: one query, one zero, done.

On your "try harder" prompt, a wider scan still failed with name-keyed guesses, then succeeded only via a broad listing:

| Query | Rationale | Result |
|---|---|---|
| `nutri` | project-name stem | 0 results |
| `blackthorn` | delivery partner | 0 results |
| `presale` | engagement type | 0 results |
| `spital`, `swiss`, `menu`, `hospital nutrition menu` | domain terms | 0 results |
| `general` | probe: is the tool live? | 2 results (`#general`, `#engineering`) — **tool is live** |
| `random` | probe | 1 result |
| `a`, `e` (single char) | broad listing fallback | 20/page listings — `#est_nutrivity` appears on page 2 of `a` |

The channel was found **only** by paging a broad listing and reading names locally — never by a project-name query.

---

## Diagnosis — the tool's matching semantics

Confirmatory probes against the known-existing `#est_nutrivity`:

| # | Query | Query form vs. channel name `est_nutrivity` | Result | Hit? |
|---|---|---|---|---|
| 1 | `nutrivity` | infix (after `est_` prefix) — also a literal suffix | **0 results** | ❌ |
| 2 | `nutri` | infix | **0 results** | ❌ |
| 3 | `est_nutrivity` | exact full name | 1 result | ✅ |
| 4 | `est_nutri` | left-anchored prefix | 1 result | ✅ |
| 5 | `est` | left-anchored prefix (returns all `est_*`) | 20 results | ✅ |
| 6 | `vity` | 4-char suffix/infix | 4 results (`est_nutrivity`, `…productivity…` ×2, `gitlab_activity`) | ✅ |

**Reliable behavior:** exact full name (3) and left-anchored prefixes (4, 5) always hit.

**Unreliable behavior:** infix matching is inconsistent. `vity` (6) matched as an infix/suffix across three channels, yet `nutri` (2) and `nutrivity` (1) — also literal substrings of the channel name — returned **zero**. There is no simple rule (prefix-only, suffix-only, or contains) that fits all six rows. The matcher is **fuzzy/relevance-based and internally inconsistent**, so:

> **A zero result from `slack_search_channels` does not mean the channel is absent.** It only means the query did not clear the matcher's opaque threshold — which the bare project name reliably fails to do when the channel carries a convention prefix.

**Not a truncation artifact.** The misses returned *zero* results, not a full-looking page that happened to omit the target — so this is a matching failure, not pagination.

**Positive control:** the same channel appears in every broad/prefix listing (`a`, `e`, `est`, `vity`), so **list-then-filter-locally** finds it deterministically.

---

## Root causes

- **RC1 — Workspace channel-naming convention (environmental).** This workspace prefixes project channels: `est_<project>` (e.g. `est_imperial-brands`, `est_leroy-merlin-tender`, `est_us-based-ai-health-startup`, `est_nutrivity`). The bare project name is never the channel name; it is a token after the prefix. `est_` appears to denote the estimation/presale stage.
- **RC2 — Tool matching semantics (tooling).** `slack_search_channels` reliably matches only exact names and left-anchored prefixes; infix matching (which the project-name key depends on, given RC1) is inconsistent and often returns zero. Negative results are not authoritative.
- **RC3 — Skill procedure gap (framework).** The `ba-frame` scan keys on the **bare project name only**, performs a **single query**, and treats a **single zero-result as "no match."** It has no separator/convention normalization and no list-then-filter fallback. It also conflates *scan breadth* with *render breadth*: "one candidate, never a list" is a rule for what the BA sees, but it was effectively applied to how hard the scan looked.
- **RC4 — Execution (this run).** On the first pass the executor accepted the single zero-result as absence instead of listing-and-filtering. The skill's terse "one key" wording nudged toward the minimal scan, but a robust executor should have enumerated channels before concluding absence.

---

## Recommended fixes (for maintainers to weigh)

Prioritized; (1) alone closes the defect.

1. **Scan by list-then-filter, not by name-keyed search.** On Frame, enumerate channels (page the broad listing, or use a `conversations.list`-style call), then filter **locally** for the project name. This is convention-agnostic and immune to RC2. *Evidence: local filtering of the full listing finds `est_nutrivity` every time.*
2. **Tokenize channel names on `_` and `-` before matching.** `est_nutrivity` → `{est, nutrivity}`; match the project name against tokens. This both finds prefixed channels and avoids domain-term false positives.
3. **Treat zero as inconclusive.** Never render "no channel" from a single search's zero-result. Absence may be asserted only after the list-then-filter path (fix 1) comes back empty.
4. **Keep the render collapsed, widen the scan.** Preserve "one candidate + count line" for what the BA sees, but decouple it from scan effort — the scan should be exhaustive internally.
5. **Optionally detect and surface the workspace prefix.** A dominant prefix (`est_` on many channels) is useful context for the BA and improves future scans; it could also be offered as a secondary key.
6. **Record the tool's limitation in the skill.** A one-line note — "`slack_search_channels` matches exact names and prefixes reliably; infix matches are unreliable; prefer list-then-filter" — prevents re-derivation.

---

## Caveats & reproducibility

- The truth table is **reproducible** (queries above against the live workspace), but the tool's exact internal algorithm is **inferred from behavior, not documented** — the `vity`/`nutri` inconsistency shows the matcher is fuzzy, so treat the rule "exact + prefix reliable, infix unreliable" as an operational heuristic, not a spec.
- Probes resolved **channel names only**; **no channel messages were read**, consistent with the scan's "resolve names, never content" rule.
- Scope of the finding is this workspace's convention plus this tool's behavior. Both are exactly what a predictable scan must tolerate.
