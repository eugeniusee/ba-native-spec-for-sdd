#!/usr/bin/env python3
"""check-cards — the three compiled cards vs. their pinned source documents.

BA-Native Spec · S3 test harness (not a build unit; build plan §2.5 is).

Build plan §3.1 rules assertion pass-condition text + CC-IDs and AT criterion
text + AT-IDs as **travelling verbatim** into the compiled cards, and §2.5 fixes
a card as `ID + exact operative text + Checks set + non-waivable/⚑ flag —
nothing else`. This script is that rule made mechanical: it re-derives every
card from the vendored methodology documents and byte-compares.

    check-cards.py            verify (exit 1 on any divergence)
    check-cards.py --record   (re)generate the cards from the vendored docs

`--record` is the compiler; the default mode is the regression floor. A doc
version bump therefore recompiles the cards by re-running --record and shows
the delta as a diff (build plan §3.5 step 3).

It also asserts the §0 layering rule on the shipped files: zero BABOK anchors,
zero mining notes, zero review records, zero rationale prose — a card carries
the operative line and nothing that would let the runtime read the methodology.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import difflib
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
PKG = HERE.parent
DOCS = PKG / "docs" / "methodology"
CARDS = PKG / "payload" / "specify-overlay" / "ba" / "cards"

CONTRACT = DOCS / "ba-native-spec-completeness-contract.md"
ORCH = DOCS / "ba-native-spec-orchestrator-rules.md"


# ── table parsing ─────────────────────────────────────────────────────────────


def split_row(line: str):
    """Split a markdown table row, honouring `code spans` that contain pipes."""
    cells, buf, tick = [], [], False
    for ch in line.strip().strip("|"):
        if ch == "`":
            tick = not tick
        if ch == "|" and not tick:
            cells.append("".join(buf).strip())
            buf = []
        else:
            buf.append(ch)
    cells.append("".join(buf).strip())
    return cells


def assertion_rows(src: str):
    """Every (id, text, checks, chk) row of contract §4–§6, in document order."""
    rows = []
    for line in src.splitlines():
        if not re.match(r"^\|\s*CC-[A-Z]+-\d\d\s*\|", line):
            continue
        cells = split_row(line)
        if len(cells) != 5:       # §8's two-column non-waivable table
            continue
        rows.append(tuple(cells))
    return rows


def non_waivable_set(src: str):
    """contract §8 — the locked set, with each ID's rationale line."""
    out = {}
    in_table = False
    for line in src.splitlines():
        if line.startswith("**Non-waivable set (locked):**"):
            in_table = True
            continue
        if in_table:
            if line.startswith("Everything else is waivable"):
                break
            if not line.startswith("| CC-"):
                continue
            cells = split_row(line)
            if len(cells) != 2:
                continue
            for cc in [c.strip() for c in cells[0].split(",")]:
                out[cc] = cells[1]
    return out


def checks_shorthand(src: str):
    """contract §2 — the Checks shorthand legend, verbatim."""
    for line in src.splitlines():
        if line.startswith("| **Checks** |"):
            return split_row(line)[1]
    raise SystemExit("check-cards: contract §2 Checks row not found")


def category_titles(src: str):
    """contract §5 — `C<n> · <name> (CC-<CAT>)`, keyed by category code."""
    titles = {}
    for line in src.splitlines():
        m = re.match(r"^### (C\d+ · .+ \(CC-([A-Z]+)\))\s*$", line)
        if m:
            titles[m.group(2)] = m.group(1)
    return titles


# ── the AT side (orchestrator §3.3) ───────────────────────────────────────────


def at_blocks(src: str):
    """§3.3's six aspect blocks: (aspect heading, [(AT-ID, criterion)…])."""
    lines = src.splitlines()
    start = lines.index("### 3.3 The thresholds")
    end = lines.index("### 3.4 The confirmation act")
    body = lines[start + 1:end]

    blocks, head, rows = [], None, []
    for line in body:
        m = re.match(r"^\*\*(.+?)\*\*\s*$", line)
        if m and not line.startswith("**AT-") and not line.startswith("**The ") \
                and not line.startswith("**D-O"):
            if head:
                blocks.append((head, rows))
            head, rows = m.group(1), []
            continue
        if re.match(r"^\|\s*AT-[A-Z]{2}-\d\s*\|", line):
            cells = split_row(line)
            rows.append((cells[0], cells[1]))
    if head:
        blocks.append((head, rows))
    return blocks


def at_notes(src: str):
    """The two locked conditionality notes attached to AT-RQ criteria."""
    notes = {}
    for para in src.split("\n\n"):
        p = para.strip()
        m = re.match(r"^\*\*(AT-RQ-\d) (conditionality|significance) — ", p)
        if m:
            notes[m.group(1)] = " ".join(p.split())
    return notes


def handover_rule(src: str):
    for para in src.split("\n\n"):
        if para.strip().startswith("**The handover rule.**"):
            return " ".join(para.split())
    raise SystemExit("check-cards: §3.3 handover rule not found")


# ── rendering — the compiler ──────────────────────────────────────────────────

HEADER_F = """<!--
  BA-Native Spec — Scope-F assertion cards (build plan §2.5). COMPILED, never
  hand-edited: `tests/check-cards.py --record` regenerates this file from the
  completeness contract at its pinned version and the default mode byte-compares.

  What a card is (build plan §2.5): assertion ID + the contract's exact
  pass-condition text + its Checks set + the non-waivable / ⚑ flag — nothing
  else. The layering rule (contract §2): the runtime never loads the contract
  itself; the chain stays verifiable one-way — card → CC-ID → contract line →
  its grounding anchor. Grounding tags, authoring-time notes, review records
  and rationale prose are methodology-layer content and are not here.

  Who reads this: the `ba-gate` subagent, Stage 3 of a Scope-F run. The M
  assertions are not here — they are the vendored checker scripts.
-->

# Scope-F assertion cards — the A pass

The pass condition is the card's text. A verdict is per assertion, with
evidence; a category-level judgement is invalid gate output.

**Flags** — `⚑` the BA reviews this assertion's evidence and signs it
individually, even inside an otherwise clean PASS · `[non-waivable]` no waiver
can exist for this assertion; the printed line below is the refusal reason.

**Checks shorthand** (the artefacts a card's Checks set names) —
{shorthand}
"""

HEADER_H = """<!--
  BA-Native Spec — Scope-H assertion cards (build plan §2.5). COMPILED, never
  hand-edited: regenerated by `tests/check-cards.py --record`.

  Same card shape and same layering rule as assertions-f.md. Scope H is
  project-level: no feature, no waiver instrument. A Scope-H gap takes no
  per-feature waiver — the instrument is the project-level health acceptance
  `HA-<nn>`, which lifts Stage-0 admission and nothing else.

  Who reads this: the `ba-gate` subagent on the A third of a Scope-H run
  (full · scoped · the Stage-0 pre-flight subset).
-->

# Scope-H assertion cards — the A pass

The pass condition is the card's text. A verdict is per assertion, with
evidence.

**Checks shorthand** (the artefacts a card's Checks set names) —
{shorthand}
"""

HEADER_AT = """<!--
  BA-Native Spec — aspect-threshold criteria (build plan §2.5). COMPILED from
  orchestrator rules §3.3, never hand-edited: regenerated by
  `tests/check-cards.py --record`.

  Card shape: AT-ID + the criterion's exact text — nothing else. Same layering
  rule as the assertion cards: card → AT-ID → orchestrator line.

  Who reads this: `/ba-clear` (the §3.4 confirmation act) and `/ba-close-band1`.
-->

# Aspect-threshold criteria — the six first-pass gates

AT criteria are **BA-confirmed evidence checks**, not assertions: no M/A split,
no checker, no gate report, no waiver-vs-override calculus. Per criterion the
framework assembles an evidence pointer (file + section) and met / not met with
every miss named; the BA rules CLEARED, NOT CLEARED, or WAIVE. **An aspect gate
never self-clears.**

A threshold asks for the minimum evidence that makes dependent work
non-speculative — never "the aspect is done".
"""


def render_f(rows, nw, shorthand, titles):
    out = [HEADER_F.format(shorthand=shorthand).rstrip(), ""]
    current = None
    for aid, text, checks, _babok, chk in rows:
        if not chk.startswith("A"):
            continue
        cat = aid.split("-")[1]
        if cat == "H":
            continue
        if cat != current:
            current = cat
            out.append("## " + (titles.get(cat) or "Global assertions (CC-G)"))
            out.append("")
        flags = ""
        if "⚑" in chk:
            flags += " · ⚑"
        if aid in nw:
            flags += " · [non-waivable]"
        out.append("### %s · Checks: %s%s" % (aid, checks, flags))
        out.append(text)
        if aid in nw:
            out.append("")
            out.append("> No waiver can exist: %s" % nw[aid])
        out.append("")
    return "\n".join(out).rstrip() + "\n"


def render_h(rows, shorthand):
    out = [HEADER_H.format(shorthand=shorthand).rstrip(), ""]
    out.append("## Project health (CC-H)")
    out.append("")
    for aid, text, checks, _babok, chk in rows:
        if aid.split("-")[1] != "H" or not chk.startswith("A"):
            continue
        out.append("### %s · Checks: %s" % (aid, checks))
        out.append(text)
        out.append("")
    return "\n".join(out).rstrip() + "\n"


def render_at(blocks, notes, handover):
    out = [HEADER_AT.rstrip(), ""]
    for head, rows in blocks:
        out.append("## " + head)
        out.append("")
        for aid, text in rows:
            out.append("### " + aid)
            out.append(text)
            if aid in notes:
                out.append("")
                out.append("> " + notes[aid])
            out.append("")
    out.append("## The handover rule")
    out.append("")
    out.append(handover)
    return "\n".join(out).rstrip() + "\n"


# ── the layering scan ─────────────────────────────────────────────────────────

LEAK_PATTERNS = [
    (r"BABOK", "a BABOK anchor"),
    (r"(?<![§v\d.])\b10\.\d\d?\b", "a BABOK technique number"),
    (r"Mined from|mining note", "a mining note"),
    (r"Review record|ruled by the BA Lead", "a review record"),
]


def leak_scan(path: Path, text: str):
    bad = []
    for pattern, what in LEAK_PATTERNS:
        for m in re.finditer(pattern, text):
            line = text[:m.start()].count("\n") + 1
            bad.append("%s:%d — %s (%r)" % (path.name, line, what, m.group(0)))
    return bad


# ── main ──────────────────────────────────────────────────────────────────────


def main(argv):
    record = "--record" in argv
    contract = CONTRACT.read_text(encoding="utf-8")
    orch = ORCH.read_text(encoding="utf-8")

    rows = assertion_rows(contract)
    nw = non_waivable_set(contract)
    shorthand = checks_shorthand(contract)
    titles = category_titles(contract)
    blocks = at_blocks(orch)

    expected = {
        CARDS / "assertions-f.md": render_f(rows, nw, shorthand, titles),
        CARDS / "assertions-h.md": render_h(rows, shorthand),
        CARDS / "at-thresholds.md": render_at(blocks, at_notes(orch),
                                              handover_rule(orch)),
    }

    failures = []

    # counts, from the documents themselves — the pinned inventory (§2.5)
    f_a = [r for r in rows if r[4].startswith("A") and r[0].split("-")[1] != "H"]
    h_a = [r for r in rows if r[4].startswith("A") and r[0].split("-")[1] == "H"]
    at_ids = [aid for _, rs in blocks for aid, _ in rs]
    for label, got, want in (("Scope-F A cards", len(f_a), 34),
                             ("Scope-H A cards", len(h_a), 3),
                             ("AT criteria", len(at_ids), 18),
                             ("aspects", len(blocks), 6),
                             ("non-waivable set", len(nw), 6)):
        if got != want:
            failures.append("count: %s = %d, pinned %d" % (label, got, want))

    # the six refusal lines the runtime must be able to print (gate §7.1 step 3)
    # live in sk_snapshot.py, outside the cards, because four of the six name M
    # assertions. They are contract §8 text and are verified here like a card.
    sys.path.insert(0, str(PKG / "payload" / "specify-overlay" / "ba" / "scripts"))
    try:
        import sk_snapshot                                          # noqa: E402
    except Exception as exc:                                        # pragma: no cover
        failures.append("cannot import sk_snapshot to verify its refusal "
                        "lines: %s" % exc)
    else:
        if sk_snapshot.NON_WAIVABLE != nw:
            for cc in sorted(set(nw) | set(sk_snapshot.NON_WAIVABLE)):
                if sk_snapshot.NON_WAIVABLE.get(cc) != nw.get(cc):
                    failures.append(
                        "sk_snapshot.NON_WAIVABLE[%s] is not the contract §8 "
                        "line:\n      doc:    %s\n      script: %s"
                        % (cc, nw.get(cc), sk_snapshot.NON_WAIVABLE.get(cc)))
        if set(sk_snapshot.FLAGGED) != {r[0] for r in rows if "⚑" in r[4]}:
            failures.append("sk_snapshot.FLAGGED is not the contract's ⚑ set")

    if record:
        CARDS.mkdir(parents=True, exist_ok=True)
        for path, text in expected.items():
            path.write_text(text, encoding="utf-8")
            print("  · recorded %s (%d lines)" % (path.name,
                                                  text.count("\n")))
    else:
        for path, want in expected.items():
            if not path.is_file():
                failures.append("missing card: %s" % path)
                continue
            got = path.read_text(encoding="utf-8")
            if got != want:
                diff = "\n".join(list(difflib.unified_diff(
                    want.splitlines(), got.splitlines(),
                    "re-derived from the pinned doc", str(path), lineterm=""))[:40])
                failures.append("%s diverges from its source document:\n%s"
                                % (path.name, diff))

    for path in expected:
        if path.is_file():
            failures.extend(leak_scan(path, path.read_text(encoding="utf-8")))

    print("▸ Compiled cards (build plan §2.5, §3.1 verbatim rule)")
    print("  %-28s %d A cards" % ("assertions-f.md", len(f_a)))
    print("  %-28s %d A cards" % ("assertions-h.md", len(h_a)))
    print("  %-28s %d criteria across %d aspects"
          % ("at-thresholds.md", len(at_ids), len(blocks)))
    print("  %-28s %d IDs, each with its refusal line"
          % ("non-waivable set", len(nw)))
    if failures:
        print("\n  ✗ %d failure(s):" % len(failures))
        for f in failures:
            print("    - %s" % f)
        return 1
    print("  ✓ every card byte-identical to its re-derivation; layering clean")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
