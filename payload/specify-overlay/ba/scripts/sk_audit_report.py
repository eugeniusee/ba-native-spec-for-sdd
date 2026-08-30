#!/usr/bin/env python3
"""sk_audit_report — the coverage report (source-audit definition §6b, D-S6).

BA-Native Spec · the render behind `/ba-audit` Stage 5b, and behind
`/ba-audit --report`.

Anchors: source-audit definition §6b (the whole of it — the four pinned sheets,
the title block, the derivation rule, the coverage percentage, `--report`) · §2
(the register's row grammar and its per-source coverage block) · §5 (the P-A1
head and the SA record grammar) · §7 (the required set) · orchestrator §10.5 /
D-O23 (the render conventions this export borrows: xlsx primary and written
first, csv canonical and title-block-free) · build plan D-P2-7 (Python 3,
standard library only).

**Derived, never asserted.** Every cell of the workbook is counted or copied
from the closed run's post-repair state; a field the workspace does not carry
renders an **empty cell**. This script authors nothing and asserts nothing of
its own — the one number it computes is the coverage percentage, and §6b fixes
its formula.

  Read set, all read-only:
    .specify/ba/runs/band-audit/run-<n>/obligations.md   the register
    .specify/ba/runs/band-audit/run-<n>/decision-list.md the P-A1 head, the
                                                         list, and the ruling
    .specify/ba/runs/band-audit/run-<n>/trace.json       required, not rendered
    .specify/ba/runs/band-audit/run-<n>/repairs.json     per-row outcomes,
                                                         where the route ran
    .specify/source-audit.md                             the ledger: the run's
                                                         entry (under --latest)
                                                         and the standing SAs

  Written: exports/audit-report.xlsx (primary, written first — the D-O23
           pattern) · exports/audit-report.csv (the Coverage Matrix alone)

`repairs.json` has one shape this reader pins and several it tolerates. The
pinned shape is a per-row list keyed by the decision-list row number:

    {"rows": [{"#": 3, "target": "specs/003-…/spec.md", "outcome": "landed"},
              {"#": 5, "outcome": "unexecuted — no epic owns the module"}]}

A bare list of the same objects reads the same way, as does a flat mapping of
row number to outcome. Anything else leaves the `Outcome` column empty — an
unreadable file is not an outcome, and a guess is not a derivation.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True

sys.path.insert(0, str(Path(__file__).resolve().parent))

import sk_xlsx  # noqa: E402

# ── the four pinned sheets (§6b) ─────────────────────────────────────────────
#
# The names, the order and the columns are the ruling's, not this script's. The
# Coverage Matrix leads because it is the sheet the csv carries.

SHEET_MATRIX = "Coverage Matrix"
SHEET_SOURCES = "Per-Source Summary"
SHEET_FINDINGS = "Findings & Rulings"
SHEET_SA = "SA Register"

MATRIX_COLUMNS = [
    "OB", "Source", "Section", "Quote", "Modality", "Phase claim",
    "Carrier", "Status", "Finding #",
]
MATRIX_WIDTHS = [10, 24, 18, 64, 12, 18, 30, 14, 12]

SOURCES_COLUMNS = [
    "Source", "Sections walked", "Sections total", "Obligations",
    "Carried", "Partial", "Accepted", "Gaps", "Coverage %", "Note",
]
SOURCES_WIDTHS = [32, 16, 15, 13, 10, 10, 11, 8, 12, 44]

FINDINGS_COLUMNS = [
    "#", "CC-S", "Evidence — source · section · \"quote\"", "Band check",
    "Proposal → target", "Default", "Ruling", "Outcome",
]
FINDINGS_WIDTHS = [6, 10, 56, 40, 44, 12, 26, 32]

SA_COLUMNS = [
    "SA", "OB", "Source", "Quote", "Decision", "Reason", "Approver",
    "Date", "Revisit",
]
SA_WIDTHS = [10, 10, 26, 52, 26, 44, 18, 12, 34]

TOTAL_LABEL = "TOTAL"

# ── the two further sheets (§6b, D-S11) ──────────────────────────────────────
#
# Five and six render the run's **movement**. The four above keep their names,
# their order and their columns, and the csv still carries the Coverage Matrix
# alone. The measure list is the ruling's, in the ruling's order: a row that
# moved here moved in the document first.

SHEET_BA = "Before & After"
SHEET_FIXLOG = "Fix Log"

BA_COLUMNS = [
    "Measure", "Previous closed run", "At P-A1", "After repairs",
    "\u0394 since previous", "\u0394 by this ruling", "Note",
]
BA_WIDTHS = [52, 20, 12, 15, 18, 19, 52]

FIXLOG_COLUMNS = [
    "Run", "#", "From run", "OB", "CC-S", "Proposal \u2192 target", "Ruling",
    "Target file", "Outcome", "Why",
]
FIXLOG_WIDTHS = [6, 5, 10, 10, 10, 44, 26, 34, 16, 44]

# Each measure: (label, kind). `kind` decides which columns render:
#   count  — all three grounds, both deltas
#   ratio  — as count, deltas in points
#   find   — findings/rulings: no `\u0394 by this ruling`
#   repair — post-ruling fact: no `At P-A1`, no `\u0394 by this ruling`
BA_MEASURES = [
    ("Run", "meta"),
    ("Sources read", "count"),
    ("Obligations", "count"),
    ("\u2014 carried", "count"),
    ("\u2014 partial", "count"),
    ("\u2014 accepted", "count"),
    ("\u2014 gaps", "count"),
    ("Coverage % (carried + accepted \u00f7 obligations)", "ratio"),
    ("Claims checked", "count"),
    ("\u2014 ungrounded", "count"),
    ("\u2014 contradictions", "count"),
    ("Specs in band", "count"),
    ("Stories", "count"),
    ("Acceptance items", "count"),
    ("Defects (partial + gaps + ungrounded + contradictions)", "count"),
    ("Defect density (defects per 100 acceptance items)", "ratio"),
    ("Findings raised", "find"),
    ("\u2014 CC-S-01 forward coverage", "find"),
    ("\u2014 CC-S-02 backward grounding", "find"),
    ("\u2014 CC-S-03 list union", "find"),
    ("\u2014 CC-S-04 client acceptance tables", "find"),
    ("\u2014 CC-S-05 unconditional NFRs", "find"),
    ("\u2014 CC-S-06 deferral legitimacy", "find"),
    ("\u2014 CC-S-07 persona coverage", "find"),
    ("\u2014 CC-S-08 cross-band consistency against sources", "find"),
    ("Ruled apply", "find"),
    ("Ruled SA", "find"),
    ("Ruled amend", "find"),
    ("Repairs landed", "repair"),
    ("Repairs \u2192 SA", "repair"),
    ("Repairs unexecuted", "repair"),
    ("Repairs superseded", "repair"),
    ("Resumed from earlier runs", "repair"),
]

# The eight families, code beside the plain-language gloss the html and the
# tail both render (§6b — a code never renders bare).
FAMILY_GLOSS = [
    ("CC-S-01", "forward coverage"),
    ("CC-S-02", "backward grounding"),
    ("CC-S-03", "list union"),
    ("CC-S-04", "client acceptance tables"),
    ("CC-S-05", "unconditional NFRs"),
    ("CC-S-06", "deferral legitimacy"),
    ("CC-S-07", "persona coverage"),
    ("CC-S-08", "cross-band consistency against sources"),
]

# ── the register's grammar (§2) ──────────────────────────────────────────────

OB_START_RE = re.compile(r"^OB-\d+\s*·")
OB_HEAD_RE = re.compile(r"^(?P<ob>OB-\d+)\s*·\s*(?P<rest>.*)$")

# `<source-file> · <sections walked>/<sections total> · <n> rows [· <note>]`
COVERAGE_LINE_RE = re.compile(
    r"^(?P<src>[^·]+?)\s*·\s*(?P<walked>\d+)\s*/\s*(?P<total>\d+)\s*·\s*"
    r"(?P<rows>\d+)\s+rows\s*(?:·\s*(?P<note>.*?))?\s*$"
)

SA_START_RE = re.compile(r"^SA-\d+\s*·")
ISO_DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
OB_REF_RE = re.compile(r"\bOB-\d+\b")

MIDDOT = "·"

# The four statuses §2 names, in the order a status string must be tested:
# `partial` before `carried` because "carried — partial at 003 US-4" is a
# partial, and a substring test the other way round would call it carried.
STATUS_ORDER = ("partial", "accepted", "gap", "carried")
STATUS_KEYS = ("carried", "partial", "accepted", "gap")


def norm_status(text: str) -> str:
    low = text.lower()
    for key in STATUS_ORDER:
        if key in low:
            return key
    return ""


def split_middot(text: str):
    return [part.strip() for part in text.split(MIDDOT)]


# ── reading the register ─────────────────────────────────────────────────────


class Row:
    """One `OB-<nnn>` row of the post-repair register."""

    __slots__ = ("ob", "source", "section", "quote", "modality", "phase",
                 "carrier", "status", "status_key", "critic", "whole")

    def __init__(self, ob, source, section, quote, modality, phase, carrier,
                 status, critic, whole):
        self.ob = ob
        self.source = source
        self.section = section
        self.quote = quote
        self.modality = modality
        self.phase = phase
        self.carrier = carrier
        self.status = status
        self.status_key = norm_status(status)
        self.critic = critic
        self.whole = whole      # every field the grammar names parsed

    def cells(self, finding=""):
        return [self.ob, self.source, self.section, self.quote, self.modality,
                self.phase, self.carrier, self.status, finding]


def _records(text, start_re):
    """Logical records: a start line plus its indented continuations.

    A blank line, a markdown heading and the next start line all end a record —
    the register wraps its rows and nothing else in the file does.
    """
    out, cur = [], None
    for line in text.splitlines():
        stripped = line.strip()
        if start_re.match(stripped):
            if cur is not None:
                out.append(cur)
            cur = stripped
        elif cur is not None:
            if not stripped or stripped.startswith("#") or stripped.startswith("|"):
                out.append(cur)
                cur = None
            else:
                cur += " " + stripped
    if cur is not None:
        out.append(cur)
    return out


def parse_ob_record(rec):
    """Split one register record into §2's seven fields.

    The quote is scanned to its closing double quote rather than to the next
    separator, because a client's sentence may carry a middot of its own. Where
    the grammar's trailing fields carry more separators than the grammar names,
    the first is the modality and the last is the status — the middle folds into
    the carrier, which is the only field a path or a citation can lengthen.
    """
    m = OB_HEAD_RE.match(rec)
    if not m:
        return None
    ob, rest = m.group("ob"), m.group("rest")
    whole = True

    src_sec, sep, rest = [p.strip() for p in rest.partition(MIDDOT)]
    if not sep:
        whole = False
    source, _, section = src_sec.partition("#")

    quote = ""
    if rest.startswith('"'):
        q = re.match(r'^"(?P<q>.*)"\s*(?:·\s*(?P<rest>.*))?$', rest, re.S)
        if q:
            quote = q.group("q")
            rest = (q.group("rest") or "").strip()
        else:
            whole = False
            quote, rest = rest.strip('"'), ""
    else:
        quote, sep, rest = [p.strip() for p in rest.partition(MIDDOT)]
        if not sep:
            whole = False

    tail = split_middot(rest) if rest else []
    critic = any(t.strip().lower() == "critic" for t in tail)
    tail = [t for t in tail if t.strip().lower() != "critic"]
    if len(tail) >= 4:
        modality, phase = tail[0], tail[1]
        status = tail[-1]
        carrier = (" %s " % MIDDOT).join(tail[2:-1])
    else:
        whole = False
        padded = tail + [""] * (4 - len(tail))
        modality, phase, carrier, status = padded[:4]

    return Row(ob, source.strip(), section.strip(), quote, modality, phase,
               carrier, status, critic, whole)


def read_register(path):
    """The per-source coverage block and the rows, in file order."""
    text = path.read_text(encoding="utf-8")
    head = []
    for line in text.splitlines():
        stripped = line.strip().lstrip("-*").strip()
        if OB_START_RE.match(stripped):
            break
        m = COVERAGE_LINE_RE.match(stripped)
        if m:
            head.append({
                "source": m.group("src").strip().strip("`"),
                "walked": int(m.group("walked")),
                "total": int(m.group("total")),
                "rows": int(m.group("rows")),
                "note": (m.group("note") or "").strip(),
            })
    rows = [r for r in (parse_ob_record(rec)
                        for rec in _records(text, OB_START_RE)) if r]
    return head, rows


# ── reading the decision list ────────────────────────────────────────────────


def table_cells(line):
    body = line.strip()
    if body.startswith("|"):
        body = body[1:]
    if body.endswith("|"):
        body = body[:-1]
    return [c.strip() for c in body.split("|")]


def read_decision_list(path):
    """The P-A1 head, the list rows, and the ruling as ruled.

    The `Rulings:` line the list renders is a *menu* — it carries the literal
    `<#…>` placeholders. Only a line without them is a ruling, and the last such
    line is the one that stands: a menu read as a ruling would print `apply`
    against every row of a list nobody has answered yet.
    """
    text = path.read_text(encoding="utf-8")
    head, table, rulings_line = {}, [], None
    header, sep_seen = None, False

    for line in text.splitlines():
        s = line.strip()
        m = re.match(r"^Source audit\s*[—-]\s*run\s*(?P<n>\d+)\s*·\s*"
                     r"(?P<date>[^·]+?)\s*·\s*profile:\s*(?P<profile>.*?)\s*$", s)
        if m:
            head["run"] = m.group("n")
            head["date"] = m.group("date").strip()
            head["profile"] = m.group("profile").strip()
            continue
        for field in ("Sources read:", "Corpus covered:", "Obligations:",
                      "Claims:", "Status:"):
            if s.startswith(field):
                head.setdefault(field.rstrip(":"), s)
        if s.lower().startswith("rulings:") and "<#" not in s:
            rulings_line = s
            continue
        if s.startswith("|"):
            cells = table_cells(s)
            if header is None:
                header = cells
            elif not sep_seen and all(set(c) <= set("-: ") for c in cells):
                sep_seen = True
            elif sep_seen:
                table.append(cells)

    return head, header or [], table, rulings_line


def rulings_by_row(line):
    """`apply all except 3 · 3: SA the client withdrew it` → {row: ruling}."""
    out, apply_all, excepted = {}, False, set()
    if not line:
        return out, apply_all, excepted
    body = re.sub(r"^[Rr]ulings:\s*", "", line)
    for tok in split_middot(body):
        if not tok:
            continue
        m = re.match(r"^#?(\d+)\s*:\s*(.+)$", tok)
        if m:
            out[m.group(1)] = m.group(2).strip()
            continue
        low = tok.lower()
        if low.startswith("apply all except"):
            apply_all = True
            excepted |= set(re.findall(r"\d+", tok))
        elif low.startswith("apply all"):
            apply_all = True
    return out, apply_all, excepted


def read_repairs(path):
    """Per-row outcomes, keyed by decision-list row number. Tolerant by design."""
    if not path.exists():
        return {}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (ValueError, OSError):
        return {}

    rows = None
    if isinstance(data, dict) and isinstance(data.get("rows"), list):
        rows = data["rows"]
    elif isinstance(data, list):
        rows = data
    elif isinstance(data, dict):
        flat = {}
        for k, v in data.items():
            if str(k).strip().lstrip("#").isdigit() and isinstance(v, str):
                flat[str(k).strip().lstrip("#")] = v
        return flat

    out = {}
    for item in rows or []:
        if not isinstance(item, dict):
            continue
        key = ""
        for k in ("#", "row", "n", "id", "finding"):
            if item.get(k) not in (None, ""):
                key = str(item[k]).strip().lstrip("#")
                break
        if not key:
            continue
        value = ""
        for k in ("outcome", "result", "status"):
            if isinstance(item.get(k), str) and item[k].strip():
                value = item[k].strip()
                break
        if not value:
            continue
        why = item.get("why") or item.get("reason")
        if isinstance(why, str) and why.strip() and "—" not in value:
            value = "%s — %s" % (value, why.strip())
        out[key] = value
    return out


def read_repair_rows(path):
    """The `repairs.json` rows as authored — every field, in list order.

    `read_repairs` above flattens to `{row: outcome}`, which is what the four
    pinned sheets need and all they need. The Before & After and Fix Log sheets
    need the row's own fields — `from-run`, `target`, `why` — so they read the
    file again rather than widen a shape the suite pins (D-S11).
    """
    if not path.exists():
        return []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (ValueError, OSError):
        return []
    rows = data.get("rows") if isinstance(data, dict) else data
    if not isinstance(rows, list):
        return []
    out = []
    for item in rows:
        if not isinstance(item, dict):
            continue
        key = ""
        for k in ("#", "row", "n", "id", "finding"):
            if item.get(k) not in (None, ""):
                key = str(item[k]).strip().lstrip("#")
                break
        outcome = ""
        for k in ("outcome", "result", "status"):
            if isinstance(item.get(k), str) and item[k].strip():
                outcome = item[k].strip()
                break
        out.append({
            "#": key,
            "from-run": item.get("from-run", ""),
            "target": item.get("target", "") or "",
            "outcome": outcome,
            "why": item.get("why") or item.get("reason") or "",
        })
    return out


# ── reading the ledger ───────────────────────────────────────────────────────


ENTRY_RE = re.compile(r"^##\s+Source audit run\s+(?P<n>\d+)\s*[—-]\s*(?P<date>.*?)\s*$")


def read_ledger(path):
    """Entries by run number (head fields only) and the standing SA records."""
    entries, sa = {}, {}
    if not path.exists():
        return entries, sa
    text = path.read_text(encoding="utf-8")

    current = None
    for line in text.splitlines():
        s = line.strip()
        m = ENTRY_RE.match(s)
        if m:
            current = {"run": m.group("n"), "date": m.group("date")}
            entries[m.group("n")] = current
            continue
        if current is not None and s.startswith("Status:"):
            current.setdefault("status", s[len("Status:"):].strip())

    # Standing records live below the entries and survive runs; an entry's own
    # `SA records this run:` block repeats them. Last occurrence wins — the
    # standing copy is the project-level record (§5).
    for rec in _records(text, SA_START_RE):
        quote = ""
        qm = re.search(r'"([^"]*)"', rec)
        if qm:
            quote = qm.group(1)
            rec = rec[:qm.start()] + rec[qm.end():]
        tokens = [t for t in split_middot(rec) if t]
        if not tokens:
            continue
        row = {"sa": tokens[0], "ob": "", "source": "", "quote": quote,
               "decision": "", "reason": "", "approver": "", "date": "",
               "revisit": ""}
        approver_at = None
        for i, tok in enumerate(tokens[1:], start=1):
            low = tok.lower()
            if tok.startswith("OB-") and not row["ob"]:
                row["ob"] = tok
            elif low.startswith("source:"):
                row["source"] = tok.split(":", 1)[1].strip()
            elif low.startswith("decision:"):
                row["decision"] = tok.split(":", 1)[1].strip()
            elif low.startswith("reason:"):
                row["reason"] = tok.split(":", 1)[1].strip()
            elif low.startswith("approver:"):
                row["approver"] = tok.split(":", 1)[1].strip()
                approver_at = i
            elif low.startswith("revisit:"):
                row["revisit"] = tok.split(":", 1)[1].strip()
            elif ISO_DATE_RE.match(tok):
                row["date"] = tok
        if not row["date"] and approver_at is not None:
            nxt = tokens[approver_at + 1] if approver_at + 1 < len(tokens) else ""
            if nxt and ":" not in nxt:
                row["date"] = nxt
        sa[row["sa"]] = row
    return entries, sa


# ── the sheets ───────────────────────────────────────────────────────────────


def coverage_pct(carried, accepted, total):
    """`(carried + accepted) ÷ obligations`, whole percent (§6b).

    `partial` and `gap` are the uncovered remainder and take no half credit. A
    source with no obligations renders an empty cell: 0 ÷ 0 is not 100%, and it
    is not 0% either.
    """
    if total <= 0:
        return ""
    return "%d%%" % int(100.0 * (carried + accepted) / total + 0.5)


def matrix_rows(rows, findings_by_ob):
    return [r.cells(findings_by_ob.get(r.ob, "")) for r in rows]


def source_rows(head, rows):
    """One row per captured source, in register-head order, then a TOTAL row."""
    order, seen = [], {}
    for entry in head:
        order.append(entry["source"])
        seen[entry["source"]] = entry
    for r in rows:
        if r.source and r.source not in seen:
            order.append(r.source)
            seen[r.source] = None

    by_source = {}
    for r in rows:
        by_source.setdefault(r.source, []).append(r)

    out, sums = [], {k: 0 for k in STATUS_KEYS}
    tot_rows = tot_walked = tot_total = 0
    for name in order:
        entry = seen.get(name)
        mine = by_source.get(name, [])
        counts = {k: 0 for k in STATUS_KEYS}
        for r in mine:
            if r.status_key:
                counts[r.status_key] += 1
        notes = []
        if entry:
            if entry["note"]:
                notes.append(entry["note"])
            if entry["walked"] < entry["total"]:
                notes.append("sample — %d/%d sections walked"
                             % (entry["walked"], entry["total"]))
            tot_walked += entry["walked"]
            tot_total += entry["total"]
        tot_rows += len(mine)
        for k in STATUS_KEYS:
            sums[k] += counts[k]
        out.append([
            name,
            str(entry["walked"]) if entry else "",
            str(entry["total"]) if entry else "",
            str(len(mine)),
            str(counts["carried"]), str(counts["partial"]),
            str(counts["accepted"]), str(counts["gap"]),
            coverage_pct(counts["carried"], counts["accepted"], len(mine)),
            (" %s " % MIDDOT).join(notes),
        ])

    out.append([
        TOTAL_LABEL,
        str(tot_walked) if head else "",
        str(tot_total) if head else "",
        str(len(rows)),
        str(sums["carried"]), str(sums["partial"]),
        str(sums["accepted"]), str(sums["gap"]),
        coverage_pct(sums["carried"], sums["accepted"], len(rows)),
        "",
    ])
    return out


def _column_index(header, *needles):
    for i, name in enumerate(header):
        low = name.lower()
        if any(n in low for n in needles):
            return i
    return None


def findings_rows(header, table, rulings_line, repairs):
    """The decision list as ruled, one row per list row, with its outcome."""
    idx = {
        "n": _column_index(header, "#"),
        "cc": _column_index(header, "cc-s"),
        "evidence": _column_index(header, "evidence"),
        "band": _column_index(header, "band check", "where it looked"),
        "proposal": _column_index(header, "proposal"),
        "default": _column_index(header, "default"),
        "ruling": _column_index(header, "ruling"),
        "outcome": _column_index(header, "outcome"),
    }
    per_row, apply_all, excepted = rulings_by_row(rulings_line)

    def cell(cells, key):
        i = idx[key]
        return cells[i].strip() if i is not None and i < len(cells) else ""

    out = []
    for cells in table:
        n = cell(cells, "n").lstrip("#").strip()
        ruling = cell(cells, "ruling")
        if not ruling:
            ruling = per_row.get(n, "")
        if not ruling and apply_all and n and n not in excepted:
            ruling = "apply"
        outcome = cell(cells, "outcome") or repairs.get(n, "")
        out.append([n, cell(cells, "cc"), cell(cells, "evidence"),
                    cell(cells, "band"), cell(cells, "proposal"),
                    cell(cells, "default"), ruling, outcome])
    return out


def sa_rows(sa):
    def key(item):
        m = re.search(r"\d+", item[0])
        return (int(m.group(0)) if m else 0, item[0])

    return [[r["sa"], r["ob"], r["source"], r["quote"], r["decision"],
             r["reason"], r["approver"], r["date"], r["revisit"]]
            for _, r in sorted(sa.items(), key=key)]


def title_block(head, status):
    """Four lines, off the same ground the entry's head is assembled from.

    Lines 3 and 4 are the P-A1 head's own lines, copied verbatim — the workbook
    and the ledger read the same corpus declaration or they read a different
    run.
    """
    first = "Source audit run %s — %s · profile: %s" % (
        head.get("run", ""), head.get("date", ""), head.get("profile", ""))
    return [
        first,
        "Status: %s" % status,
        head.get("Sources read", "Sources read:"),
        head.get("Corpus covered", "Corpus covered:"),
    ]


# ── the band count (§6b, D-S10) ──────────────────────────────────────────────


def count_band(root):
    """specs · stories · acceptance items, through the gate's own parser.

    This is the renderer's **one** act that reads specs, and it reads them to
    count, never to judge (§10 unit 8). The session pastes the printed block
    into `trace.json`; the render then reads the recorded block and re-counts
    nothing, because the estate moves after a run closes and the record does
    not (§6b).
    """
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import sk_structure  # noqa: E402  — imported here: --band is the only caller

    specs = sorted((root / "specs").glob("[0-9][0-9][0-9]-*/spec.md"))
    n_specs = n_stories = n_items = 0
    unreadable = []
    for path in specs:
        try:
            spec = sk_structure.parse_spec(path)
        except Exception:
            unreadable.append(str(path.relative_to(root)))
            continue
        n_specs += 1
        n_stories += len(spec.stories)
        for story in spec.stories:
            n_items += len(story.acceptance)
    return {"specs": n_specs, "stories": n_stories,
            "acceptance_items": n_items, "unreadable": unreadable}


def read_trace(path):
    """`trace.json` as it stands. A trace from before D-S9 carries no `band`
    and no `re_audit`; the render reads what stands and leaves the rest
    empty (§7)."""
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {}


# ── the two ratios (§6b, D-S10) ──────────────────────────────────────────────


def defect_density(partial, gaps, ungrounded, contradictions, items):
    """defects ÷ acceptance items × 100, one decimal. Empty at zero items,
    exactly as zero obligations renders an empty coverage cell."""
    if not items:
        return ""
    defects = (partial or 0) + (gaps or 0) + (ungrounded or 0) + (contradictions or 0)
    return "%.1f" % (defects * 100.0 / items)


def _defects(fwd, bwd):
    return ((fwd.get("partial") or 0) + (fwd.get("gaps") or 0)
            + (bwd.get("ungrounded") or 0) + (bwd.get("contradictions") or 0))


# ── one column's ground → the pinned measures (§6b) ──────────────────────────


def measure_block(forward, backward, band, sources_read=None):
    """The count and ratio measures for one of the three grounds.

    Every value is read from the block it belongs to and nothing is inferred:
    a ground that carries no `band` yields empty band rows, which is what an
    older run's evidence supports.
    """
    fwd = forward or {}
    bwd = backward or {}
    bnd = band or {}
    out = {}
    out["Sources read"] = sources_read if sources_read is not None else ""
    out["Obligations"] = fwd.get("rows", "")
    out["— carried"] = fwd.get("carried", "")
    out["— partial"] = fwd.get("partial", "")
    out["— accepted"] = fwd.get("accepted", "")
    out["— gaps"] = fwd.get("gaps", "")
    out["Coverage % (carried + accepted ÷ obligations)"] = coverage_pct(
        fwd.get("carried") or 0, fwd.get("accepted") or 0, fwd.get("rows") or 0)
    out["Claims checked"] = bwd.get("rows", "")
    out["— ungrounded"] = bwd.get("ungrounded", "")
    out["— contradictions"] = bwd.get("contradictions", "")
    out["Specs in band"] = bnd.get("specs", "")
    out["Stories"] = bnd.get("stories", "")
    out["Acceptance items"] = bnd.get("acceptance_items", "")
    if fwd:
        out["Defects (partial + gaps + ungrounded + contradictions)"] = _defects(fwd, bwd)
    else:
        out["Defects (partial + gaps + ungrounded + contradictions)"] = ""
    out["Defect density (defects per 100 acceptance items)"] = defect_density(
        fwd.get("partial"), fwd.get("gaps"), bwd.get("ungrounded"),
        bwd.get("contradictions"), bnd.get("acceptance_items") or 0)
    return out


def effective_rulings(rulings_line, row_numbers):
    """`{row: ruling}` with the `apply all [except …]` form resolved.

    `rulings_by_row` returns the explicit rows, the `apply all` flag and the
    excepted set; a row carries its own ruling where the list gives one, `apply`
    where the blanket form covers it, and nothing where the list ruled nothing.
    """
    explicit, apply_all, _excepted = rulings_by_row(rulings_line) if rulings_line \
        else ({}, False, set())
    out = {}
    for num in row_numbers:
        key = str(num).strip().lstrip("#")
        if key in explicit:
            out[key] = explicit[key]
        elif apply_all:
            out[key] = "apply"
    return out


def finding_block(header, table, rulings_line):
    """Findings raised, by family, and the three ruling counts — from the
    decision list, which is where a ruling lives."""
    out = {"Findings raised": len(table)}
    fam_i = _column_index(header, "cc-s", "assertion")
    counts = {code: 0 for code, _ in FAMILY_GLOSS}
    for row in table:
        cell = row[fam_i] if fam_i is not None and fam_i < len(row) else ""
        for code, _ in FAMILY_GLOSS:
            if code in cell:
                counts[code] += 1
                break
    for code, gloss in FAMILY_GLOSS:
        out["— %s %s" % (code, gloss)] = counts[code]
    i_num = _column_index(header, "#")
    nums = [(row[i_num] if i_num is not None and i_num < len(row) else "")
            for row in table]
    rulings = effective_rulings(rulings_line, nums)
    tally = {"apply": 0, "sa": 0, "amend": 0}
    for value in rulings.values():
        v = (value or "").strip().lower()
        for key in tally:
            if v.startswith(key):
                tally[key] += 1
                break
    out["Ruled apply"] = tally["apply"]
    out["Ruled SA"] = tally["sa"]
    out["Ruled amend"] = tally["amend"]
    return out


def repair_block(repairs):
    """The post-ruling facts. A repair is not a *before* of anything, so these
    rows leave `At P-A1` empty (§6b)."""
    rows = repairs or []
    def n(pred):
        return sum(1 for r in rows if pred(r))
    outcome = lambda r: str(r.get("outcome", "")).strip().lower()
    return {
        "Repairs landed": n(lambda r: outcome(r).startswith("landed")),
        "Repairs → SA": n(lambda r: outcome(r).startswith("sa")),
        "Repairs unexecuted": n(lambda r: outcome(r).startswith("unexecuted")),
        "Repairs superseded": n(lambda r: outcome(r).startswith("superseded")),
        "Resumed from earlier runs": n(lambda r: r.get("from-run") not in (None, "")),
    }


# ── the previous closed run (§6b) ────────────────────────────────────────────


def previous_closed(root, entries, this_run):
    """The latest entry before this run whose workspace holds §7's required set.

    The selection `--report` already makes, applied downward from this run: a
    refused admission opened no workspace and is **stepped past and named**,
    never treated as a zero. Where nothing earlier qualifies the column is
    empty and the `Run` row says so.
    """
    stepped = []
    try:
        here = int(str(this_run).lstrip("#"))
    except ValueError:
        return None, stepped
    earlier = [n for n in entries if str(n).isdigit() and int(n) < here]
    for n in sorted(earlier, key=int, reverse=True):
        work = workspace_of(root, n)
        if work.is_dir() and not missing_from(work):
            return n, stepped
        stepped.append(n)
    return None, stepped


def previous_ground(root, run):
    """That run's own post-repair state: its `re_audit` block where it wrote
    one, else the Stage-2 blocks it closed on. A run from before D-S9 carries
    no band block, and its band rows render empty."""
    if run is None:
        return {}, {}, {}
    trace = read_trace(workspace_of(root, run) / "trace.json")
    ra = trace.get("re_audit") or {}
    if ra:
        return ra.get("forward") or {}, ra.get("backward") or {}, ra.get("band") or {}
    return trace.get("forward") or {}, trace.get("backward") or {}, trace.get("band") or {}


# ── sheet 5 · Before & After (§6b, D-S11) ────────────────────────────────────


def _delta(after, before, points=False):
    """A signed figure, empty where either side is empty (§6b)."""
    if after in ("", None) or before in ("", None):
        return ""
    strip = lambda v: str(v).strip().rstrip("%")
    try:
        a, b = float(strip(after)), float(strip(before))
    except (TypeError, ValueError):
        return ""
    d = a - b
    if points:
        return ("%+.1f" % d).rstrip("0").rstrip(".") + " pts" if d else "0 pts"
    if d == int(d):
        return "%+d" % int(d) if d else "0"
    return "%+.1f" % d


def _cells(row):
    """The writer is text-only (sk_xlsx, unchanged by D-S11): every cell a
    string, an absent figure the empty cell §6b asks for."""
    return ["" if c is None else str(c) for c in row]


def before_after_rows(prev_run, prev_cols, p_a1, after, findings_p, findings_a,
                      repairs_a, notes):
    """One row per pinned measure, in the ruling's order."""
    rows = []
    for label, kind in BA_MEASURES:
        note = notes.get(label, "")
        if kind == "meta":                                   # the `Run` row
            rows.append(_cells([label, prev_run or "", p_a1.get("__run__", ""),
                                after.get("__run__", ""), "", "", note]))
            continue
        if kind == "repair":
            a = repairs_a.get(label, "")
            rows.append(_cells([label, prev_cols.get(label, ""), "", a,
                                _delta(a, prev_cols.get(label, "")), "", note]))
            continue
        if kind == "find":
            b = findings_p.get(label, "")
            a = findings_a.get(label, "")
            rows.append(_cells([label, b, a, "", _delta(a, b), "", note]))
            continue
        pts = kind == "ratio"
        b = prev_cols.get(label, "")
        m = p_a1.get(label, "")
        a = after.get(label, "")
        rows.append(_cells([label, b, m, a, _delta(a, b, pts),
                            _delta(a, m, pts), note]))
    return rows


# ── sheet 6 · Fix Log (§6b, D-S11) ───────────────────────────────────────────


def fixlog_rows(root, entries):
    """Every `repairs.json` row under every run, newest run first, list order
    within a run.

    `OB`, `CC-S`, `Proposal → target` and `Ruling` are joined by `#` to the
    decision list of the run that **ruled** the row — the `from-run` run where
    the key is present, the row's own run where it is not. That join is the
    seam §14 routed. The sweep is a **render**: it resumes nothing, re-rules
    nothing and writes nothing, and D-S8's resumption stays one run deep.
    """
    lists = {}

    def ruled_in(run):
        if run not in lists:
            work = workspace_of(root, run)
            try:
                _h, header, table, rline = read_decision_list(work / "decision-list.md")
            except Exception:
                lists[run] = ({}, {})
                return lists[run]
            by_num = {}
            i_num = _column_index(header, "#")
            i_ob = _column_index(header, "ob")
            i_fam = _column_index(header, "cc-s", "assertion")
            i_prop = _column_index(header, "proposal")
            for row in table:
                key = (row[i_num].strip().lstrip("#")
                       if i_num is not None and i_num < len(row) else "")
                if not key:
                    continue
                cell = lambda i: (row[i].strip() if i is not None and i < len(row) else "")
                ob = cell(i_ob)
                if not ob:
                    # A list with no OB column still names its obligations in
                    # the evidence cell; the join reads what the file carries.
                    found = OB_REF_RE.findall(" ".join(row))
                    ob = ", ".join(dict.fromkeys(found))
                by_num[key] = {"ob": ob, "fam": cell(i_fam), "prop": cell(i_prop)}
            lists[run] = (by_num, effective_rulings(rline, by_num.keys()))
        return lists[run]

    runs = sorted((n for n in entries if str(n).isdigit()), key=int, reverse=True)
    out = []
    for run in runs:
        work = workspace_of(root, run)
        if not work.is_dir():
            continue                       # a refusal has no workspace: no rows
        rows = read_repair_rows(work / "repairs.json")
        for r in rows or []:
            num = str(r.get("#", "")).strip().lstrip("#")
            frm = r.get("from-run")
            frm = "" if frm in (None, "") else str(frm)
            by_num, rulings = ruled_in(frm or run)
            src = by_num.get(num, {})
            out.append(_cells([
                run, num, frm, src.get("ob", ""), src.get("fam", ""),
                src.get("prop", ""), (rulings.get(num) or "").strip(),
                r.get("target", ""), r.get("outcome", ""), r.get("why", ""),
            ]))
    return out


# ── the html's inputs, from the one derivation (§6b) ─────────────────────────
#
# Every figure the dashboard shows is the Before & After sheet's own figure.
# These four shape it for the render and compute nothing new.


def headline_cards(p_a1, after, prev_cols, repairs_now, prev_run):
    cov, dens = ("Coverage % (carried + accepted ÷ obligations)",
                 "Defect density (defects per 100 acceptance items)")
    since = ("first closed run — no previous report" if prev_run is None
             else "%s → %s since run %s" % (prev_cols.get(cov, "") or "—",
                                            after.get(cov, "") or "—", prev_run))
    since_d = ("first closed run — no previous report" if prev_run is None
               else "%s → %s since run %s" % (prev_cols.get(dens, "") or "—",
                                              after.get(dens, ""), prev_run))
    return [
        ("Coverage — obligations carried or consciously declined",
         "%s → %s" % (p_a1.get(cov, "") or "—", after.get(cov, "") or "—"), since),
        ("Defect density — defects per 100 acceptance items",
         "%s → %s" % (p_a1.get(dens, "") or "—", after.get(dens, "") or "—"),
         since_d),
        ("Fixes this run",
         "%s landed" % repairs_now["Repairs landed"],
         "%s unexecuted · %s declined (SA) · %s resumed"
         % (repairs_now["Repairs unexecuted"], repairs_now["Repairs → SA"],
            repairs_now["Resumed from earlier runs"])),
    ]


def movement_bars(prev_cols, p_a1, after):
    """The four obligation statuses and the two claim statuses, three readings
    each — previous closed run · at P-A1 · after repairs."""
    measures = [
        ("Carried", "— carried"), ("Partial", "— partial"),
        ("Accepted", "— accepted"), ("Gaps", "— gaps"),
        ("Claims ungrounded", "— ungrounded"),
        ("Claims contradicting", "— contradictions"),
    ]
    return [(label, [prev_cols.get(key, ""), p_a1.get(key, ""),
                     after.get(key, "")]) for label, key in measures]


def moved_rows(re_audit, rows, repairs):
    """`re_audit.rows` as a table — the register's verbatim quote beside each,
    and the repair row that moved it."""
    quotes = {r.ob: r.quote for r in rows}
    by_num = {}
    for r in repairs or []:
        by_num[str(r.get("#", "")).strip().lstrip("#")] = r
    out = []
    for row in (re_audit.get("rows") or []):
        via = str(row.get("via", "") or "").strip().lstrip("#")
        frm = row.get("from-run")
        label = ""
        if via:
            label = "repair #%s" % via
            if frm not in (None, ""):
                label += " (from run %s)" % frm
        out.append([row.get("OB", ""), quotes.get(row.get("OB", ""), ""),
                    row.get("before", "none") or "none",
                    row.get("after", "none") or "none", label])
    return out


def family_rows(findings_prev, findings_now):
    """The eight CC-S rows, gloss leading and the code beside it."""
    out = []
    for code, gloss in FAMILY_GLOSS:
        key = "— %s %s" % (code, gloss)
        out.append((gloss[:1].upper() + gloss[1:], code,
                    findings_prev.get(key, ""), findings_now.get(key, "")))
    return out


# ── the dashboard render — exports/audit-stats.html (§6b, D-S11) ─────────────
#
# One self-contained file: inline CSS, inline SVG, no script, no external
# asset. **Every figure here is the Before & After sheet's own figure, from the
# one derivation** — the html adds no number the sheet does not carry, and a
# figure that differs between the two is invalid audit output on D-S2's bar.
# Plain language leads and a code never renders bare.

HTML_CSS = """
:root{--ink:#1a1a1a;--dim:#5b5b5b;--rule:#d8d5cf;--bg:#faf9f7;--pale:#efece6;
--prev:#b9b2a6;--pa1:#c98a4b;--after:#4a7c59}
*{box-sizing:border-box}
body{margin:0;padding:2.2rem 2rem 4rem;background:var(--bg);color:var(--ink);
font:15px/1.55 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif}
.wrap{max-width:1080px;margin:0 auto}
h1{font-size:1.35rem;margin:0 0 .2rem;font-weight:640}
h2{font-size:1.02rem;margin:2.4rem 0 .7rem;font-weight:640;
border-bottom:1px solid var(--rule);padding-bottom:.35rem}
.title-block{color:var(--dim);font-size:.86rem;margin-bottom:.4rem}
.title-block div{margin:.1rem 0}
.cards{display:flex;flex-wrap:wrap;gap:.8rem;margin:.4rem 0 .2rem}
.card{flex:1 1 220px;background:#fff;border:1px solid var(--rule);
border-radius:7px;padding:.85rem 1rem}
.card .k{font-size:.78rem;color:var(--dim);text-transform:uppercase;
letter-spacing:.04em}
.card .v{font-size:1.5rem;font-weight:650;margin:.25rem 0 .1rem}
.card .s{font-size:.83rem;color:var(--dim)}
table{border-collapse:collapse;width:100%;font-size:.87rem;background:#fff}
th,td{text-align:left;padding:.42rem .6rem;border:1px solid var(--rule);
vertical-align:top}
th{background:var(--pale);font-weight:620}
td.n,th.n{text-align:right;white-space:nowrap}
.q{color:var(--dim)}
.legend{font-size:.82rem;color:var(--dim);margin:.3rem 0 .7rem}
.sw{display:inline-block;width:.62rem;height:.62rem;border-radius:2px;
margin:0 .25rem 0 .8rem;vertical-align:baseline}
.sub{font-size:.9rem;font-weight:640;margin:1.1rem 0 .45rem}
.empty{color:var(--dim);font-style:italic}
"""


def _esc(value):
    return (str("" if value is None else value)
            .replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))


def _bars(measures):
    """Three bars per measure — previous closed run · at P-A1 · after repairs —
    with the counts written on them. Inline SVG, no script."""
    rowh, barh, gap, left, top = 62, 15, 4, 210, 26
    width, plot = 940, 640
    peak = 0
    for _label, vals in measures:
        for v in vals:
            if isinstance(v, (int, float)):
                peak = max(peak, v)
    peak = peak or 1
    height = top + rowh * len(measures) + 8
    out = ['<svg viewBox="0 0 %d %d" width="100%%" height="%d" '
           'role="img" aria-label="the movement, three bars per measure">'
           % (width, height, height)]
    colours = ["var(--prev)", "var(--pa1)", "var(--after)"]
    names = ["previous closed run", "at P-A1", "after repairs"]
    for i, (label, vals) in enumerate(measures):
        y0 = top + i * rowh
        out.append('<text x="0" y="%d" font-size="12.5" fill="#1a1a1a">%s</text>'
                   % (y0 + 14, _esc(label)))
        for j, v in enumerate(vals):
            y = y0 + j * (barh + gap)
            if not isinstance(v, (int, float)):
                out.append('<text x="%d" y="%d" font-size="11" fill="#8a8a8a">'
                           '%s —</text>' % (left, y + 12, _esc(names[j])))
                continue
            w = max(1.0, plot * (float(v) / peak))
            out.append('<rect x="%d" y="%d" width="%.1f" height="%d" rx="2" '
                       'fill="%s"><title>%s · %s</title></rect>'
                       % (left, y, w, barh, colours[j], _esc(names[j]), _esc(v)))
            out.append('<text x="%.1f" y="%d" font-size="11" fill="#3a3a3a">%s</text>'
                       % (left + w + 6, y + 12, _esc(v)))
    out.append("</svg>")
    return "\n".join(out)


def write_html(path, title, headline, movement, moved, families, fixlog,
               prev_run):
    """The six pinned sections, in the ruling's order."""
    h = ['<!doctype html><html lang="en"><head><meta charset="utf-8">',
         '<meta name="viewport" content="width=device-width,initial-scale=1">',
         "<title>%s</title>" % _esc(title[0] if title else "Source audit"),
         "<style>%s</style></head><body><div class=\"wrap\">" % HTML_CSS]

    # 1 · the title block — the same four lines as every sheet
    h.append('<h1>%s</h1><div class="title-block">' % _esc(title[0] if title else ""))
    for line in (title[1:] if title else []):
        h.append("<div>%s</div>" % _esc(line))
    h.append("</div>")

    # 2 · the headline
    h.append("<h2>Headline — what this ruling moved, and what has moved since "
             "the last report</h2><div class=\"cards\">")
    for k, v, s in headline:
        h.append('<div class="card"><div class="k">%s</div>'
                 '<div class="v">%s</div><div class="s">%s</div></div>'
                 % (_esc(k), _esc(v), _esc(s)))
    h.append("</div>")

    # 3 · the movement
    h.append("<h2>The movement — obligations and claims, three readings each</h2>")
    h.append('<div class="legend">'
             '<span class="sw" style="background:var(--prev)"></span>previous closed run'
             '<span class="sw" style="background:var(--pa1)"></span>at P-A1'
             '<span class="sw" style="background:var(--after)"></span>after repairs'
             "</div>")
    h.append(_bars(movement))

    # 4 · what moved
    h.append("<h2>What moved — every register row whose status changed</h2>")
    if moved:
        h.append("<table><tr><th>OB</th><th>The obligation, as the source states it"
                 "</th><th>Before → after</th><th>Moved by</th></tr>")
        for ob, quote, before, after, via in moved:
            h.append("<tr><td>%s</td><td class=\"q\">%s</td><td>%s → %s</td>"
                     "<td>%s</td></tr>"
                     % (_esc(ob), _esc(quote), _esc(before), _esc(after), _esc(via)))
        h.append("</table>")
    else:
        h.append('<p class="empty">No register row changed status in this run.</p>')

    # 5 · findings by family
    h.append("<h2>Findings by family — this run against the previous closed run</h2>")
    h.append("<table><tr><th>Check</th><th class=\"n\">Previous closed run</th>"
             "<th class=\"n\">This run</th></tr>")
    for gloss, code, prev, now in families:
        h.append("<tr><td>%s <span class=\"q\">(%s)</span></td>"
                 "<td class=\"n\">%s</td><td class=\"n\">%s</td></tr>"
                 % (_esc(gloss), _esc(code), _esc(prev), _esc(now)))
    h.append("</table>")

    # 6 · the fix log, under two headings
    h.append("<h2>The fix log — every repair, newest first</h2>")
    recent = [r for r in fixlog if prev_run is None or int(str(r[0])) > int(str(prev_run))]
    earlier = [r for r in fixlog if not (prev_run is None or int(str(r[0])) > int(str(prev_run)))]
    for heading, rows in (
            ("Fixes since the previous report (run %s)" % _esc(prev_run)
             if prev_run is not None else "Fixes this run", recent),
            ("Earlier runs", earlier)):
        h.append('<div class="sub">%s</div>' % heading)
        if not rows:
            h.append('<p class="empty">None.</p>')
            continue
        h.append("<table><tr><th>Run</th><th>#</th><th>From run</th><th>OB</th>"
                 "<th>Check</th><th>What was proposed</th><th>Ruling</th>"
                 "<th>Target file</th><th>Outcome</th><th>Why</th></tr>")
        for r in rows:
            h.append("<tr>%s</tr>" % "".join("<td>%s</td>" % _esc(c) for c in r))
        h.append("</table>")

    h.append("</div></body></html>")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(h), encoding="utf-8")
    return path


# ── the closing tail (§6b, D-S11) ────────────────────────────────────────────


def closing_tail(cov, dens, fixes, findings, prev_run, prev_has_band, status):
    """Five lines into the conversation, before the closing ask, asking nothing.

    **The tail is the renderer's, not the session's** — it prints at the end of
    every render and the skill echoes it verbatim, so the five lines are the
    sheet's figures once more and never a summary composed from memory (the
    field defect of 2026-08-20, one render along).
    """
    c_p, c0, c1 = cov            # previous · at P-A1 · after repairs
    d_p, d0, d1 = dens
    first = prev_run is None
    lines = []
    if status:
        lines.append(status)     # an INCOMPLETE run says so above the five

    since_c = ("first closed run — no previous report" if first
               else "%s → %s since the previous report (run %s)"
                    % (c_p or "—", c1 or "—", prev_run))
    lines.append("Coverage %s → %s by this ruling · %s."
                 % (c0 or "—", c1 or "—", since_c))

    if first:
        since_d = "first closed run — no previous report"
    elif not prev_has_band:
        since_d = "no acceptance count on run %s" % prev_run
    else:
        since_d = "%s → %s since run %s" % (d_p or "—", d1 or "—", prev_run)
    lines.append("Defects per 100 acceptance items %s → %s · %s."
                 % (d0 or "—", d1 or "—", since_d))

    k, u, s, r = fixes
    lines.append("Fixes: %s landed · %s unexecuted — resume next run · "
                 "%s declined (SA) · %s resumed from earlier runs." % (k, u, s, r))

    # Line 4 names only the families with a non-zero count, code beside gloss.
    named = ["%s %s (%s)" % (n, gloss, code)
             for code, gloss, n in findings[1] if n]
    lines.append("Findings this run: %s%s." % (
        findings[0], (" — " + " · ".join(named)) if named else ""))

    lines.append("Report: exports/audit-stats.html — the picture · "
                 "audit-report.xlsx · audit-report.csv.")
    return lines


# ── the writers (the D-O23 pattern — xlsx first, then csv) ───────────────────


def write_xlsx(path, title, matrix, sources, findings, sa, ba=None, fixlog=None):
    """The four pinned sheets, then the two that render the movement (D-S11).

    The four keep their names, their order and their columns; `write_book()`
    takes six sheets as it took four and the writer stays text-only — the
    picture is the html's job.
    """
    sheets = [
        (SHEET_MATRIX, MATRIX_COLUMNS, matrix, MATRIX_WIDTHS, title),
        (SHEET_SOURCES, SOURCES_COLUMNS, sources, SOURCES_WIDTHS, title),
        (SHEET_FINDINGS, FINDINGS_COLUMNS, findings, FINDINGS_WIDTHS, title),
        (SHEET_SA, SA_COLUMNS, sa, SA_WIDTHS, title),
    ]
    if ba is not None:
        sheets.append((SHEET_BA, BA_COLUMNS, ba, BA_WIDTHS, title))
    if fixlog is not None:
        sheets.append((SHEET_FIXLOG, FIXLOG_COLUMNS, fixlog, FIXLOG_WIDTHS, title))
    return sk_xlsx.write_book(path, sheets)


def write_csv(path, matrix):
    # The Coverage Matrix alone, and no title block: the csv is the canonical,
    # diff-friendly render and lines above the column row break its shape (§6b,
    # the D-O67 pattern).
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh, quoting=csv.QUOTE_MINIMAL)
        w.writerow(MATRIX_COLUMNS)
        for row in matrix:
            w.writerow(row)
    return path


# ── the generation summary (BA-facing register, orchestrator §10.3) ──────────


def summary(head, rows, sources, findings, sa, unlisted, unparsed, other,
            stepped_past, xlsx_path, csv_path):
    counts = {k: 0 for k in STATUS_KEYS}
    for r in rows:
        if r.status_key:
            counts[r.status_key] += 1
    critic = sum(1 for r in rows if r.critic)

    out = [
        "Coverage report — run %s · %d obligations → %s · %s"
        % (head.get("run", "?"), len(rows), xlsx_path, csv_path),
        "Sheets: %s %d · %s %d · %s %d · %s %d"
        % (SHEET_MATRIX, len(rows), SHEET_SOURCES, len(sources),
           SHEET_FINDINGS, len(findings), SHEET_SA, len(sa)),
        "Coverage: %s — carried %d · partial %d · accepted %d · gaps %d"
        % (coverage_pct(counts["carried"], counts["accepted"], len(rows)) or "—",
           counts["carried"], counts["partial"], counts["accepted"],
           counts["gap"]),
        head.get("Corpus covered", "Corpus covered: —"),
    ]
    if stepped_past:
        out.append("Stepped past: run %s — no closed workspace; the latest "
                   "closed run is %s" % (", ".join(sorted(stepped_past,
                                                          key=int)),
                                         head.get("run", "?")))
    if critic:
        out.append("Critic pass: %d %s" % (critic, "row" if critic == 1 else "rows"))
    if other:
        out.append("Status not in the four: %d rows — the cell carries the "
                   "register's own word, the counts do not" % other)
    if unlisted:
        out.append("No coverage line in the register head: %s — the rows "
                   "render, the sections columns stay empty"
                   % ", ".join(unlisted))
    if unparsed:
        out.append("Row grammar incomplete: %s — every field each row carried "
                   "renders, the rest stay empty" % ", ".join(unparsed))
    out.append("Next: open %s — the register as the run left it" % xlsx_path)
    return "\n".join(out)


# ── CLI ──────────────────────────────────────────────────────────────────────


REQUIRED = ("obligations.md", "trace.json", "decision-list.md")


def workspace_of(root, run):
    return root / ".specify" / "ba" / "runs" / "band-audit" / ("run-%s" % run)


def missing_from(work):
    """What §7's required set is short of, in the order §7 lists it."""
    if not work.is_dir():
        return ["the workspace itself"]
    return [name for name in REQUIRED if not (work / name).exists()]


def latest_closed(root, entries):
    """The latest run that opened a workspace, and what was stepped past.

    Run numbers are gapless and include Stage-0 refusals, which open **no
    workspace at all**. A refusal is not a closed run, so `--report` steps past
    it rather than refusing over evidence that was never supposed to exist —
    and it says which entries it stepped past, because a re-render of run 4
    that quietly renders run 2 is the wrong artifact under the right name.

    A workspace that exists but is **short** of §7's required set is a
    different thing and is never stepped past: that run closed, D-S4 guaranteed
    its evidence at the append, and a hole is evidence gone missing. The caller
    refuses over it and names the file.
    """
    skipped = []
    for n in sorted(entries, key=int, reverse=True):
        if workspace_of(root, n).is_dir():
            return n, skipped
        skipped.append(n)
    return None, skipped


def refuse(message) -> int:
    print(message, file=sys.stderr)
    return 2


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="the coverage report — source-audit definition §6b (D-S6)")
    p.add_argument("--root", default=".", help="project root")
    p.add_argument("--band", action="store_true",
                   help="count the band through the gate's own parser and "
                        "print the `band` block for the session to paste into "
                        "trace.json (§6b, D-S10) — reads specs to count, never "
                        "to judge")
    g = p.add_mutually_exclusive_group(required=False)
    g.add_argument("--run", metavar="N", help="render this run's workspace")
    g.add_argument("--latest", action="store_true",
                   help="render the latest closed run (the `/ba-audit "
                        "--report` act): the highest-numbered entry on the "
                        "ledger")
    p.add_argument("--out-dir", default="exports",
                   help="destination for audit-report.xlsx and .csv")
    p.add_argument("--summary-only", action="store_true",
                   help="print the summary; write no files")
    args = p.parse_args(argv)

    root = Path(args.root).resolve()

    if args.band:
        # The one act that reads specs. It prints; the session pastes. A band
        # block typed by hand is a D-S2 violation, because an acceptance figure
        # counted by eye is an asserted number (§6b).
        print(json.dumps({"band": count_band(root)}, indent=2, sort_keys=True))
        return 0
    if not (args.run or args.latest):
        return refuse("one of --run, --latest or --band is required.")

    ledger_path = root / ".specify" / "source-audit.md"
    entries, sa = read_ledger(ledger_path)

    stepped_past = []
    if args.latest:
        if not entries:
            return refuse(
                "no closed run on %s — nothing to re-render. Run /ba-audit."
                % ledger_path)
        run, stepped_past = latest_closed(root, entries)
        if run is None:
            return refuse(
                "no run on %s opened a workspace — every entry is a Stage-0 "
                "refusal, and a refusal is not a closed run. Run /ba-audit."
                % ledger_path)
    else:
        run = str(args.run).strip().lstrip("#")

    work = workspace_of(root, run)
    if not work.is_dir():
        return refuse("no run workspace at %s — the run left no evidence to "
                      "render." % work)
    gaps = missing_from(work)
    if gaps:
        return refuse("%s is missing from %s — a re-render is not a "
                      "repair, and the report renders what the run was "
                      "supposed to leave." % (gaps[0], work))

    head, rows = read_register(work / "obligations.md")
    dl_head, dl_header, dl_table, rulings_line = read_decision_list(
        work / "decision-list.md")
    repairs = read_repairs(work / "repairs.json")
    repair_rows = read_repair_rows(work / "repairs.json")

    head_fields = dict(dl_head)
    head_fields.setdefault("run", run)

    # The status is the run's recorded one where the ledger already carries the
    # entry, and the P-A1 head's conditional line where it does not — Stage 5b
    # renders before the append, so on a fresh run the second is the only
    # ground there is.
    entry = entries.get(run)
    if entry and entry.get("status"):
        status = entry["status"]
    elif dl_head.get("Status"):
        status = dl_head["Status"][len("Status:"):].strip()
    else:
        status = "complete"

    findings_by_ob = {}
    idx_n = _column_index(dl_header, "#")
    for cells in dl_table:
        n = (cells[idx_n].strip().lstrip("#").strip()
             if idx_n is not None and idx_n < len(cells) else "")
        if not n:
            continue
        for ob in OB_REF_RE.findall(" ".join(cells)):
            prev = findings_by_ob.get(ob)
            findings_by_ob[ob] = "%s, %s" % (prev, n) if prev else n

    matrix = matrix_rows(rows, findings_by_ob)
    sources = source_rows(head, rows)
    findings = findings_rows(dl_header, dl_table, rulings_line, repairs)
    sa_table = sa_rows(sa)
    title = title_block(head_fields, status)

    # ── the movement (§6b, D-S9–D-S11) ──────────────────────────────────────
    #
    # Three grounds, each read from its own: `At P-A1` from trace.json's
    # Stage-2 blocks, `After repairs` from its `re_audit` block, and
    # `Previous closed run` from that run's own workspace. Nothing is inferred
    # across a column, and a ground that carries no band renders empty.
    trace = read_trace(work / "trace.json")
    re_audit = trace.get("re_audit") or {}
    sources_read = len(head)

    p_a1 = measure_block(trace.get("forward"), trace.get("backward"),
                         trace.get("band"), sources_read)
    after = measure_block(re_audit.get("forward"), re_audit.get("backward"),
                          re_audit.get("band"), sources_read if re_audit else "")
    p_a1["__run__"] = run
    after["__run__"] = run

    prev_run, prev_skipped = previous_closed(root, entries, run)
    p_fwd, p_bwd, p_band = previous_ground(root, prev_run)
    prev_cols = measure_block(p_fwd, p_bwd, p_band, "") if prev_run else {}

    findings_now = finding_block(dl_header, dl_table, rulings_line)
    if prev_run:
        try:
            _ph, p_header, p_table, p_rline = read_decision_list(
                workspace_of(root, prev_run) / "decision-list.md")
            findings_prev = finding_block(p_header, p_table, p_rline)
        except Exception:
            findings_prev = {}
        prev_cols.update(repair_block(read_repair_rows(
            workspace_of(root, prev_run) / "repairs.json")))
    else:
        findings_prev = {}
    repairs_now = repair_block(repair_rows)

    # `Note` carries what the numbers cannot (§6b).
    notes = {}
    if prev_run is None:
        notes["Run"] = "none — first closed run"
    elif prev_skipped:
        notes["Run"] = "stepped past run %s — no closed workspace" % (
            ", ".join(str(n) for n in prev_skipped))
    walked = [e for e in head if e.get("walked") is not None
              and e.get("total") is not None and e["walked"] < e["total"]]
    if walked:
        notes["Coverage % (carried + accepted ÷ obligations)"] = (
            "sample — %s" % "; ".join(
                "%s %s/%s sections walked" % (e["source"], e["walked"], e["total"])
                for e in walked))
    band_now = (re_audit.get("band") or trace.get("band") or {})
    unreadable = band_now.get("unreadable") or []
    if unreadable:
        note = "sample — %d spec(s) unreadable: %s" % (
            len(unreadable), ", ".join(unreadable))
        notes["Acceptance items"] = note
        notes["Defect density (defects per 100 acceptance items)"] = note

    ba_table = before_after_rows(prev_run, prev_cols, p_a1, after,
                                 findings_prev, findings_now, repairs_now, notes)
    fixlog = fixlog_rows(root, entries)

    out_dir = Path(args.out_dir)
    if not out_dir.is_absolute():
        out_dir = root / out_dir
    xlsx_path, csv_path = out_dir / "audit-report.xlsx", out_dir / "audit-report.csv"
    html_path = out_dir / "audit-stats.html"

    if not args.summary_only:
        write_xlsx(xlsx_path, title, matrix, sources, findings, sa_table,
                   ba_table, fixlog)
        write_csv(csv_path, matrix)   # the Coverage Matrix alone (§6b)
        write_html(html_path, title,
                   headline_cards(p_a1, after, prev_cols, repairs_now, prev_run),
                   movement_bars(prev_cols, p_a1, after),
                   moved_rows(re_audit, rows, repair_rows),
                   family_rows(findings_prev, findings_now),
                   fixlog, prev_run)

    def shown(path):
        try:
            return str(path.relative_to(root))
        except ValueError:
            return str(path)

    listed = {e["source"] for e in head}
    unlisted = sorted({r.source for r in rows if r.source and r.source not in listed})
    unparsed = [r.ob for r in rows if not r.whole]
    other = sum(1 for r in rows if not r.status_key)

    print(summary(head_fields, rows, sources, findings, sa_table, unlisted,
                  unparsed, other, stepped_past,
                  shown(xlsx_path), shown(csv_path)))

    # The tail is the renderer's, not the session's: the skill echoes these
    # five lines verbatim, so they are the sheet's figures once more (§6b).
    print()
    for line in closing_tail(
            (prev_cols.get("Coverage % (carried + accepted ÷ obligations)", ""),
             p_a1.get("Coverage % (carried + accepted ÷ obligations)", ""),
             after.get("Coverage % (carried + accepted ÷ obligations)", "")),
            (prev_cols.get("Defect density (defects per 100 acceptance items)", ""),
             p_a1.get("Defect density (defects per 100 acceptance items)", ""),
             after.get("Defect density (defects per 100 acceptance items)", "")),
            (repairs_now["Repairs landed"], repairs_now["Repairs unexecuted"],
             repairs_now["Repairs → SA"], repairs_now["Resumed from earlier runs"]),
            (findings_now.get("Findings raised", 0),
             [(code, gloss, findings_now.get("— %s %s" % (code, gloss), 0))
              for code, gloss in FAMILY_GLOSS]),
            prev_run, bool(p_band), status if status.lower() != "complete" else ""):
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
