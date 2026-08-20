# Framework defect report — the Slack candidate scan certifies its filter, not the workspace

**For:** the BA-Native Spec (`ba-native-sdd`) framework maintainer.
**Reported from:** a live `/ba-frame Presale` run — project Nutrivity, 2026-08-20.
**Component:** `.claude/skills/ba-frame/SKILL.md` → *Step 2 — the source inventory* → **The Slack candidate scan**, lines 167–214.
**Severity:** high. A false negative on a named-class source, rendered to the BA as an established fact, at the single Frame stop.
**Status:** operator-level workaround applied in the affected run; **no framework-level fix exists**. The defect reproduces on every run.

---

## 1. Summary

The Slack candidate scan rendered `no match` over a listing it described as complete. The listing covered **225 of 705** channels. The target channel — `#est_nutrivity`, the project's own presale channel, active, present in the workspace throughout — sat in the 480 channels the scan never enumerated.

The scan obeyed every rule the skill states. The rules govern the retrieval **method** and never the retrieval **corpus**, so a silently filtered enumeration satisfies them completely.

The BA caught the error. Nothing in the framework could have.

---

## 2. Evidence

Workspace `geniusee.slack.com`, enumerated 2026-08-20.

| Slice | Channels | Reached by the scan as specified |
|---|---|---|
| Public, not archived | 225 | yes |
| Public, archived | 163 | **no** |
| Private, incl. archived | 317 | **no** |
| **Total** | **705** | **225 — 31.9%** |

Matches on the project-name token `nutrivity`, over the full 705: exactly one — `#est_nutrivity` (`C0B8T2GKYT1`), private, not archived, created 2026-06-09.

The workspace convention for presale/estimation channels is `est_<project>`, with roughly ninety instances. **Not one of them appears in the 225 channels the scan enumerated.** An entire naming convention was absent from a listing the scan reported as complete.

---

## 3. Root cause

Two causes, at different levels. Only the second is the framework's.

### 3.1 Operator-level (not the subject of this report)

The scan was run against a retrieval tool whose visibility and archive-state parameters were left at their defaults. Both defaults narrow. The operator did not set them.

### 3.2 Framework-level — the defect

**The skill legislates how to enumerate and never what to enumerate.** Its governing bullet reads:

> **List, then filter — there is no other method.** Enumerate the workspace's channels by **paging the broad listing to completion**, and filter **locally** for the project name.

`the workspace's channels` is the only statement of corpus in the entire section, and it is carried as an unexamined noun phrase. Nothing tells the scan that a retrieval endpoint has axes — visibility, archive state — along which it silently narrows by default. So *"paging the broad listing to completion"* is fully satisfied by paging a **filtered** listing to completion. The rule is not violated. It is simply not load-bearing.

**The termination signal is the second half of the defect.** The scan is instructed to page *to completion*, and it takes completion from the tool's own end-of-results marker. That marker certifies exhaustion of **the query's filtered result set**. It says nothing about the workspace. The skill treats a transport-level terminator as a domain-level completeness proof, and never marks the difference.

The consequence is precise: **the scan can prove it finished. It cannot prove what it finished over.** Every downstream guarantee the section builds — the honest `<N>` count, the deterministic best-match ranking, the excluded-channel filtering — rests on a completeness the framework never requires anyone to establish.

---

## 4. Why the existing epistemics did not catch it

The section already contains careful reasoning about false negatives — but it is aimed at one hazard only:

> **A zero from a name-keyed search is inconclusive.** It says a query failed an opaque matcher, not that the channel is absent. Render "no match" **only after the local filter over the complete listing comes back empty** — never from a zero-result.

This is correct and it was obeyed. The scan did not render `no match` from a keyed zero; it rendered it from a local filter over a paged listing, exactly as instructed.

**The rule's protection is conditional on `the complete listing` being complete, and the framework provides no way to establish that.** It hardened the fuzzy-matcher path and left the listing path with no epistemics at all — on the assumption that a listing is self-evidently complete. That assumption is the defect.

A second gap compounds it. The pinned render shape defines a line for a **match**:

```
Slack — closest match on the project name: #<channel> — include it, or ignore it.   (renders only when Slack is reachable and the scan matched)
```

There is **no line for a no-match**. Silence on no-match is sound as far as it goes — it prevents a false claim by preventing any claim. But it leaves the scan with a result and no sanctioned way to report it, which produces steady pressure to improvise one. In this run the operator improvised `complete listing paged (225 channels), no match` — an unpinned line asserting a coverage the framework never asked anyone to verify. **The absence of a safe line manufactured an unsafe one.**

---

## 5. Precedent — same defect family, already on the record

This is the second escape of one shape: **a `Sources:` state asserting a completeness nothing verified.**

The skill already carries the first, at line 357, as the rationale for the binary-readability clause:

> Without it a `Sources:` line can read `captured` while a later pass cannot parse the file at all (Scope-S run-1 escape, 17 Aug 2026).

There, `captured` was true of the transport and false of the artifact. Here, `complete` is true of the query and false of the workspace. Both were fixed — or in this case, need fixing — one clause at a time, at the site of the escape.

**Two instances in four days establish the class.** The recommendation in §6.5 is that it be closed as a class rather than patched a third time.

---

## 6. Proposed amendments

Drafted in the framework's register for direct incorporation. All line references are to `.claude/skills/ba-frame/SKILL.md` as of this report.

### 6.1 Amend the *List, then filter* bullet (line 181) — declare the corpus

Replace the opening of the bullet with:

> - **List, then filter — there is no other method, and the listing declares its corpus.** Enumerate the workspace's channels by **paging the broad listing to completion**, and filter **locally** for the project name. **The corpus is every channel the workspace holds — both visibilities, every archive state.** A retrieval parameter left at its default is **presumed narrowing**: visibility and archive state are set **explicitly**, never by omission. Name-keyed search against the Slack search endpoint is **removed from the scan entirely** — *[remainder of the bullet unchanged]*

Rationale: `the workspace's channels` must name its axes or it is decorative. The presale channel this scan exists to find is, by the commercial nature of presale work, **private** — the default excludes precisely the class the feature targets.

### 6.2 New bullet, immediately after line 191 — the terminator is not a proof

> - **An end-of-results terminator certifies the query, never the workspace.** The tool reports exhaustion of **its own filtered result set**. Completeness is a property the scan **establishes**, never a signal it **receives**. A listing is complete only where every retrieval axis was set explicitly; until then it is a sample — and a sample reports what it found, never what does not exist.

### 6.3 New bullet, immediately after 6.2 — the falsification obligation

> - **A zero from the local filter requires a positive control.** The keyed-search epistemics above do not transfer to a listing: a listing zero is no safer, only quieter. Before `no match` is rendered or acted on, **prove the listing surfaces a channel known to sit inside it.** An unfalsified negative is not a finding — it is an assumption wearing a finding's words.

### 6.4 Amend the pinned render shape (lines 154–159) — give no-match a line that carries its corpus

Add one conditional line to the block:

```
Slack — no channel matches the project name · listed <n> channels (public + private, archived included).   (renders only when Slack is reachable and the scan found no match)
```

And add to *What this skill never does*:

> never renders a coverage claim the scan did not establish, and never volunteers a line the pinned shape does not define — a scan result outside the pinned lines is a render defect

Rationale: the no-match case needs a **sanctioned** line, not an absent one. Forcing `<n>` and the corpus into the pinned shape converts an improvised claim into an auditable one, and removes the pressure that produced this defect. A scan that cannot fill the line honestly cannot render it.

### 6.5 Lift to a framework-wide principle — recommended

Both §5 escapes and this defect share one shape: **a state line asserting a completeness no rule required anyone to establish.** Patching the third site will not close the class.

Recommended as a new decision record, next free `D-O` number:

> **The corpus-declaration rule.** Any rule that depends on a retrieval — a listing, a search set, a sweep, a glob — **names the corpus that retrieval must cover**, and the retrieval **states the corpus it covered**. A completeness claim is carried by the act that establishes it, never inherited from the tool that terminated it. **Where the corpus is not stated, the result is a sample, and a sample never grounds a negative.**

**Known sites carrying the class today:**

| Site | Retrieval | Corpus stated |
|---|---|---|
| `ba-frame` — Slack candidate scan, L181 | workspace channel listing | no — **this defect** |
| `ba-audit` — `P-A1`, the band-wide search set | band-wide search per finding | partially — the set is *required on every row* but its coverage axes are never defined |
| `ba-frame` — §8.1 readability clause, L351 | binary capture | closed, 17 Aug 2026 — by clause, not by principle |

`ba-audit`'s **band-wide search set** is the highest-value follow-up. The audit's entire two-way trace rests on it, its findings carry it as evidence, and the rule that mandates it never says what "band-wide" ranges over. It is the same defect one level up, and its false negatives land in a source audit rather than an inventory.

---

## 7. Tool-level facts worth encoding

Observed directly during the corrected run. Durable, and reusable by any future integration-backed scan.

**Tool:** `slack_search_channels` (Slack MCP connector).

| Parameter | Behaviour |
|---|---|
| `channel_types` | **defaults to `public_channel`** — narrowing. Accepts `public_channel,private_channel` |
| `include_archived` | **defaults to `false`** — narrowing |
| `limit` | max 20; larger values **clamp silently**, with no warning in the response |
| `query` | required. `"*"` behaves as **match-all** — this is how a broad listing is obtained at all |
| `cursor` | base64 of the literal string `CURRENT_PAGE:<n>` |

Two consequences worth writing into the framework:

1. **The endpoint has no listing mode.** A broad listing exists only as a `*` query against a search endpoint. The skill's instruction to *page the broad listing* therefore describes an affordance the tool does not directly offer, which is part of why the corpus went unexamined. The rule should say so.
2. **Pages are directly addressable.** Because the cursor is a transparent encoding of a page number, the listing can be **fanned out in parallel** rather than walked serially. In this run that turned a ~35-call serial walk into three parallel batches. Requesting past the final page returns `execution_failed: page_limit_exceeded`, which is a clean, cheap terminator for a parallel sweep.

**Reference corpus sizes, `geniusee.slack.com`, 2026-08-20:** public incl. archived **388** · private incl. archived **317** · total **705**. A scan reporting a materially smaller enumeration of this workspace is filtering.

---

## 8. Blast radius in the affected run

Recorded for completeness; the run itself was corrected before any aspect opened.

Had the false negative stood, Band 1 would have opened on a corpus excluding the provider side of the engagement. Specifically: `Budget: none stated` would have carried through the band with `Capacity: —`, leaving T-18 — Scope allocation's advisory number-free; and all five harvested scope decisions would have remained `SD-?` candidates, since the client documents are client-declared and the agreement evidence — where it exists — lives in the estimation channel. Every artifact downstream would have cited a corpus that silently excluded the negotiation record, with nothing in the ledger marking the hole.

No ledger event was written for this defect. The event grammar is closed and holds no kind for an orchestrator execution fault; inventing one would be its own violation.
