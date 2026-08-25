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


# ── the writers (the D-O23 pattern — xlsx first, then csv) ───────────────────


def write_xlsx(path, title, matrix, sources, findings, sa):
    return sk_xlsx.write_book(path, [
        (SHEET_MATRIX, MATRIX_COLUMNS, matrix, MATRIX_WIDTHS, title),
        (SHEET_SOURCES, SOURCES_COLUMNS, sources, SOURCES_WIDTHS, title),
        (SHEET_FINDINGS, FINDINGS_COLUMNS, findings, FINDINGS_WIDTHS, title),
        (SHEET_SA, SA_COLUMNS, sa, SA_WIDTHS, title),
    ])


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
    g = p.add_mutually_exclusive_group(required=True)
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

    out_dir = Path(args.out_dir)
    if not out_dir.is_absolute():
        out_dir = root / out_dir
    xlsx_path, csv_path = out_dir / "audit-report.xlsx", out_dir / "audit-report.csv"

    if not args.summary_only:
        write_xlsx(xlsx_path, title, matrix, sources, findings, sa_table)
        write_csv(csv_path, matrix)   # the Coverage Matrix alone (§6b)

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
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
