#!/usr/bin/env python3
"""sk_humanizer_guard — the humanizer write guard (orchestrator rules §10.3 rule 10, D-O97).

BA-Native Spec · the assertion behind `/ba-humanizer on`.
Anchors: orchestrator §10.3 rule 10 (the fence and this guard) · §43 (the
ruling) · §2.4 (the two runtime ledgers, exempt entire) · §8.1 · §10.4 · §10.5 ·
§10.6 · §10.7 · §10.8 (the pinned shapes) · the writing standard §2/§4 (the
marker grammar, senior on every conflict).

**What this is.** D-O97 moves the humanizer fence from the *artifact* to the
*machine-read line*: a `spec.md` body's sentences are rewritten, its headings,
ids, markers, tables and fences are not. That move is only safe because it is
asserted. This script is the assertion. It takes the original and the candidate
rewrite of one file and answers one question — **did the rewrite touch anything
a machine reads?**

**Asserted, never declining (D-O97).** This script decides nothing about the
prose and refuses no work. Exit 0 means the candidate is safe to write. Exit 1
names the first failing anchor on stderr so the caller can write the ORIGINAL
and append the pinned tail line:

    Humanizer: skipped — guard failed on <anchor>

A failed rewrite means one rewrite was unsafe, never that the artifact is: the
original is what the framework would have written with the switch `off`.

**The seven checks, in the order they fire** — the first failure names the
anchor and nothing after it runs:

  0. path        a wholly-exempt file must come back byte-identical (§2.4)
  1. frontmatter the leading YAML block, byte-equal
  2. fences      every code fence and its contents, byte-equal, in order
  3. tables      every markdown table row, byte-equal, in order
  4. pinned      every pinned line, byte-equal, in order (PINNED_LINES below)
  5. regions     every pinned block, unchanged in line count (a paragraph
                 holding a pinned line is never merged or split)
  6. tokens      every exempt token, same class, same count, SAME ORDER

Order matters in check 6 on purpose. A multiset comparison would accept a
rewrite that moved `FR-3`'s sentence above `FR-2`'s, which renumbers nothing and
misreads everything downstream of the order.

Python 3, standard library only (D-P2-7). Deterministic: no network, no clock,
no model call — the same two files give the same verdict on every machine.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True


# ─────────────────────────────────────────────────── the wholly-exempt paths ──
#
# §10.3 rule 10 names these by class, not by glob: the two runtime ledgers
# entire, gate and audit records, BUILD-LOG.md, the compiled cards. A file whose
# path matches must come back byte-identical — there is no prose in it the
# humanizer owns, and a diff here is a bug in the caller, never a close call.

EXEMPT_PATHS = (
    (".specify/aspect-state.md",   "§2.4 — the aspect-state ledger"),
    (".specify/aspect-plans.md",   "§2.4 — the plans ledger"),
    (".specify/gate-health.md",    "gate §10.3 — the health ledger"),
    (".specify/gate-tuning.md",    "gate §7.4 — the tuning record"),
    (".specify/source-audit.md",   "source-audit definition §5 — the audit ledger"),
    (".specify/elicitation-tuning.md", "doc 3 §10 — the elicitation log"),
    ("gate-report.md",             "gate §6 — the run record"),
    ("BUILD-LOG.md",               "the build record"),
    ("/.specify/ba/cards/",        "gate §3 — the compiled cards"),
)


# ────────────────────────────────────────────────────── the pinned line set ──
#
# Derived from the corpus, never invented here. Each entry is the line's own
# opening text and the section that pins it — grep any one of them and the
# document that owns the shape comes back. A pinned line must survive the
# rewrite byte for byte, in the order it stood.

PINNED_LINES = (
    ("Sources on hand:",                  "§8.1 — the source inventory (D-O45)"),
    ("Slack — closest match on the project name:", "§8.1 — the candidate line (D-O53)"),
    ("Slack — no channel matches the project name", "§8.1 — the no-match line (D-O80)"),
    ("Slack — listing interrupted at",    "§8.1 — the cut line (D-O85)"),
    ("Anything else? Slack channel(s)",   "§8.1 — the inventory tail (D-O45)"),
    ("Flow profile — pick one",           "§8.1 — the profile picker (P-O0)"),
    ("Scope frame — before any aspect opens", "§8.1 — the scope frame (P-O0b, D-O42)"),
    ("Waiting for your pick.",            "§8.1 — the picker's closing line"),
    ("Waiting for your confirmation.",    "§8.1 — the frame's closing line"),
    ("Project status —",                  "§10.4 — the dashboard head (D-O17)"),
    ("Workflow ",                         "§10.4 — the workflow line (§10.4-F)"),
    ("unbriefed inside boundary",         "§10.4 — line 2's coverage continuation (D-O100)"),
    ("Delivery boundary:",                "§10.5 — the WBS title block (D-O67 · D-O77)"),
    ("Route —",                           "§10.6 — the route render (D-O31)"),
    ("Stops en route:",                   "§10.6 — the route render (D-O31)"),
    ("Band boundary —",                   "§10.7 — the band-boundary report (D-O52)"),
    ("Auto-trail",                        "§10.7 — the trail line (D-O52 · D-O87)"),
    ("Assumptions:",                      "§10.7 — the report line (D-O52)"),
    ("Health refresh:",                   "§10.7 — the health line (D-O59)"),
    ("Scope coverage:",                   "§10.7 — the coverage line (D-O100)"),
    ("Next act:",                         "§10.7 — the band-boundary report (D-O52)"),
    ("Auto paused —",                     "§10.7 — the mid-grant stop report (D-O86)"),
    ("Stands:",                           "§10.7 — the mid-grant stop report (D-O86)"),
    ("Resume from:",                      "§10.7 — the mid-grant stop report (D-O86)"),
    ("Auto off —",                        "§10.7 — the resumption report (D-O52)"),
    ("Stopped at:",                       "§10.7 — the resumption report (D-O52)"),
    ("Ratify:",                           "§10.7 — the resumption report (D-O52)"),
    ("Next manual act:",                  "§10.7 — the resumption report (D-O52)"),
    ("Destination reached",               "§10.7 — the un-electable render (D-O63)"),
    ("Scope advisories —",                "§10.7 — the decision-list tail (D-O69)"),
    ("What I need from you:",             "§10.3 rule 9 — the closing ask (D-O82)"),
    ("Design guide —",                    "§10.8 — the design-guide record (D-O76)"),
    ("Client provided none",              "§10.8 — the none-record (D-O76)"),
    ("Humanizer: skipped — guard failed on", "§10.3 rule 10 — this guard's own tail"),
)

# A lettered option of a closing ask carries its `(recommended)` marker and its
# letter: rule 9 makes both load-bearing, so the whole line is pinned.
OPTION_RE = re.compile(r"^\s{0,6}[a-z]\.\s")


# ───────────────────────────────────────────────────── the exempt token set ──
#
# Every class §10.3 rule 10 names, with the section or document that rules it.
# The order of this tuple is the order the classes are reported in; the order of
# the *tokens* inside a file is what check 6 asserts.

TOKEN_CLASSES = (
    ("scope decision",  r"\bSD-\d+\b",                     "§2.4 (D-O65)"),
    ("cross-cutting",   r"\bXO-\d+\b",                     "§2.4 (D-O72)"),
    ("acceptance shape", r"\bAS-\d+\b",                    "§2.4 (D-O78)"),
    ("advisory",        r"\bADV-\d+\b",                    "§2.4 (D-O68)"),
    ("autonomy grant",  r"\bAG-\d+\b",                     "§4.4 (D-O35)"),
    ("aspect waiver",   r"\bAW-\d+\b",                     "§4.1"),
    ("reopen",          r"\bRO-\d+\b",                     "§5"),
    ("audit obligation", r"\bOB-\d+\b",                    "source-audit definition §2"),
    ("threshold",       r"\bAT-[A-Z]{2}-\d+\b",            "§3.3"),
    ("assertion",       r"\bCC-[A-Z]{1,3}-\d+\b",          "completeness contract"),
    ("waiver tag",      r"\bW-\d{3}-\d+\b",                "gate §7.1"),
    ("decision",        r"\bD-[A-Z0-9]+-?\d*\b",           "the review records"),
    ("prompt point",    r"\bP-O\d+[a-z]?\b",               "§10.1"),
    ("technique",       r"\bT-\d{2}\b",                    "the catalogue index"),
    ("user story",      r"\bUS\d+\b",                      "standard §2"),
    ("requirement",     r"\bFR-\d+\b",                     "standard §3"),
    ("open question",   r"\bOQ-\d+\b",                     "doc 3 D4"),
    ("feature",         r"\b\d{3}-[a-z0-9-]+\b",           "§8.4 — the NNN-* folder"),
    ("section ref",     r"§\s?\d+(?:\.\d+)*",              "every methodology document"),
    ("clarification",   r"\[NEEDS CLARIFICATION[^\]]*\]",  "standard §2"),
    ("flag",            r"⚑",                              "gate P3"),
    ("bracket marker",  r"\[(?:ASSUMPTION|DEFERRED|INFERRED|OPEN)[^\]]*\]",
                                                           "standard §4 — the marker grammar"),
    ("code span",       r"`[^`\n]+`",                      "paths · commands · link targets"),
    ("link target",     r"\]\([^)\s]+\)",                  "markdown link targets"),
    ("url",             r"https?://[^\s)\]]+",             "link targets"),
    ("date",            r"\b\d{4}-\d{2}-\d{2}\b",          "every record's date field"),
    ("number",          r"(?<![\w.-])\d+(?:[.,]\d+)?(?![\w-])", "counts and amounts"),
    ("quote",           r"[“][^”\n]{0,400}[”]", "cite-or-mark (doc 3, principle 3)"),
)

FENCE_RE = re.compile(r"^\s*```")
TABLE_RE = re.compile(r"^\s*\|")
FM_RE = re.compile(r"\A---\r?\n.*?\r?\n---\r?\n", re.S)


def fail(anchor: str) -> int:
    """Name the first failing anchor and stop. The caller writes the original."""
    sys.stderr.write("guard failed on %s\n" % anchor)
    return 1


def frontmatter(text: str) -> str:
    m = FM_RE.match(text)
    return m.group(0) if m else ""


def fences(text: str):
    """Every fenced block, fence lines included, in order."""
    out, buf, inside = [], [], False
    for line in text.splitlines():
        if FENCE_RE.match(line):
            buf.append(line)
            if inside:
                out.append("\n".join(buf))
                buf = []
            inside = not inside
            continue
        if inside:
            buf.append(line)
    if buf:                                    # an unterminated fence is its own block
        out.append("\n".join(buf))
    return out


def outside_fences(text: str):
    """(line-number, line) for every line that is not inside a code fence."""
    out, inside = [], False
    for n, line in enumerate(text.splitlines(), 1):
        if FENCE_RE.match(line):
            inside = not inside
            continue
        if not inside:
            out.append((n, line))
    return out


def tables(text: str):
    return [l for _, l in outside_fences(text) if TABLE_RE.match(l)]


def pinned_of(line: str):
    """The pinned entry this line is an instance of, or None."""
    s = line.strip()
    for head, where in PINNED_LINES:
        if s.startswith(head):
            return head, where
    if OPTION_RE.match(line) and "(recommended)" in line:
        return "(recommended) option", "§10.3 rule 9 — the lettered options (D-O82)"
    return None


def pinned_lines(text: str):
    """(line, head, where) for every pinned line outside a fence, in order."""
    out = []
    for _, line in outside_fences(text):
        hit = pinned_of(line)
        if hit:
            out.append((line, hit[0], hit[1]))
    return out


def regions(text: str):
    """head → line count of the block each pinned line opens.

    A block runs from the pinned line to the next blank line or the end of the
    text. §10.3 rule 10: no paragraph holding a pinned line is merged or split,
    so the count is the assertion that neither happened.
    """
    lines = [l for _, l in outside_fences(text)]
    out = []
    for i, line in enumerate(lines):
        hit = pinned_of(line)
        if not hit:
            continue
        n = 0
        for l in lines[i:]:
            if not l.strip():
                break
            n += 1
        out.append((hit[0], n, hit[1]))
    return out


def tokens(text: str):
    """[(class, token)] in the order they stand in the text."""
    found = []
    for label, pattern, _where in TOKEN_CLASSES:
        for m in re.finditer(pattern, text):
            found.append((m.start(), label, m.group(0)))
    found.sort(key=lambda t: (t[0], t[1]))
    return [(label, tok) for _pos, label, tok in found]


def token_where(label: str) -> str:
    for l, _p, where in TOKEN_CLASSES:
        if l == label:
            return where
    return "§10.3 rule 10"


def exempt_path(path: Path):
    """The exempt-path entry this file matches, or None."""
    p = str(path).replace("\\", "/")
    for needle, where in EXEMPT_PATHS:
        if p.endswith(needle) or needle in p:
            return needle, where
    return None


def check(original: str, candidate: str, path: Path) -> int:
    # ── 0. the wholly-exempt paths ──────────────────────────────────────────
    hit = exempt_path(path)
    if hit and original != candidate:
        return fail("%s — %s: exempt entire, and it changed" % (hit[0], hit[1]))

    # ── 1. front matter ─────────────────────────────────────────────────────
    if frontmatter(original) != frontmatter(candidate):
        return fail("the YAML front matter — byte-equal, never rewritten")

    # ── 2. code fences ──────────────────────────────────────────────────────
    fo, fc = fences(original), fences(candidate)
    if len(fo) != len(fc):
        return fail("the code fences — %d in the original, %d in the candidate"
                    % (len(fo), len(fc)))
    for i, (a, b) in enumerate(zip(fo, fc), 1):
        if a != b:
            return fail("code fence %d — %s" % (i, a.splitlines()[0].strip()[:60]))

    # ── 3. tables ───────────────────────────────────────────────────────────
    to, tc = tables(original), tables(candidate)
    if len(to) != len(tc):
        return fail("the table rows — %d in the original, %d in the candidate"
                    % (len(to), len(tc)))
    for a, b in zip(to, tc):
        if a != b:
            return fail("the table row %s" % a.strip()[:60])

    # ── 4. pinned lines ─────────────────────────────────────────────────────
    po, pc = pinned_lines(original), pinned_lines(candidate)
    if len(po) != len(pc):
        heads = {h for _l, h, _w in po} ^ {h for _l, h, _w in pc}
        return fail("the pinned lines — %d in the original, %d in the candidate%s"
                    % (len(po), len(pc),
                       (" (%s)" % ", ".join(sorted(heads))) if heads else ""))
    for (la, ha, wa), (lb, _hb, _wb) in zip(po, pc):
        if la != lb:
            return fail("the pinned line %r — %s" % (ha, wa))

    # ── 5. pinned regions ───────────────────────────────────────────────────
    ro, rc = regions(original), regions(candidate)
    for (ha, na, wa), (_hb, nb, _wb) in zip(ro, rc):
        if na != nb:
            return fail("the block at %r — %d lines in the original, %d in the "
                        "candidate; %s" % (ha, na, nb, wa))

    # ── 6. exempt tokens — class, count and order ───────────────────────────
    ko, kc = tokens(original), tokens(candidate)
    if len(ko) != len(kc):
        lost = [t for t in ko if ko.count(t) > kc.count(t)]
        first = lost[0] if lost else None
        return fail("the exempt tokens — %d in the original, %d in the candidate%s"
                    % (len(ko), len(kc),
                       ("; first lost: %s %s (%s)"
                        % (first[0], first[1], token_where(first[0]))) if first else ""))
    for i, (a, b) in enumerate(zip(ko, kc)):
        if a != b:
            return fail("the exempt token at position %d — %s %s became %s %s (%s)"
                        % (i + 1, a[0], a[1], b[0], b[1], token_where(a[0])))

    return 0


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="The humanizer write guard — asserts that a rewrite touched "
                    "no machine-read line (orchestrator §10.3 rule 10, D-O97)")
    p.add_argument("--original", metavar="PATH",
                   help="the text as the framework wrote it")
    p.add_argument("--candidate", metavar="PATH",
                   help="the humanized rewrite, not yet written")
    p.add_argument("--path", default="", metavar="PATH",
                   help="the destination path, when it differs from --original "
                        "(the exempt-path check reads it)")
    p.add_argument("--list", action="store_true",
                   help="print the pinned lines and token classes with their "
                        "sources, and exit")
    args = p.parse_args(argv)

    if args.list:
        print("Wholly-exempt paths")
        for needle, where in EXEMPT_PATHS:
            print("  %-34s %s" % (needle, where))
        print("\nPinned lines")
        for head, where in PINNED_LINES:
            print("  %-46s %s" % (head, where))
        print("\nExempt token classes")
        for label, pattern, where in TOKEN_CLASSES:
            print("  %-17s %-38s %s" % (label, pattern, where))
        return 0

    if not args.original or not args.candidate:
        p.error("--original and --candidate are both required")
    orig = Path(args.original)
    cand = Path(args.candidate)
    for f in (orig, cand):
        if not f.is_file():
            sys.stderr.write("guard failed on a missing file: %s\n" % f)
            return 1

    dest = Path(args.path) if args.path else orig
    return check(orig.read_text(encoding="utf-8"),
                 cand.read_text(encoding="utf-8"),
                 dest)


if __name__ == "__main__":
    sys.exit(main())
