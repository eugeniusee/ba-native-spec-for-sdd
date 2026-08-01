#!/usr/bin/env python3
"""BA-Native Spec — the Band-1 artifact validator (S5).

Judges what T-01, T-02 and T-03 produce, against the shapes their sheets pin:

  canvas.md          thirteen sections, exact names, exact order · every cell
                     cited or marked · `P-n`/`O-n` line-IDs on exactly two
                     sections, contiguous and unique · every `→ P-n`/`→ O-n`
                     link resolving · ≤ 10 capability lines · Customers naming
                     a sponsor and ≥ 1 further population, no placeholders
  glossary.md        Term · Definition · Merged synonyms · Source — that header,
                     that order · no stub entries · every merge dated
  stakeholders.md    Stakeholder · Kind · Role in project · Decision rights ·
                     Comms line · Source — that header, that order · Kind from
                     the two-value vocabulary · every entry carrying a role plus
                     rights or a comms line · the sponsor's authority explicit
  coherence          every canvas Customers entity resolving to a register entry
  continuity         an earlier artifact surviving unchanged inside a later one

Same idiom as tests/check-ledger.py: this is a TEST HARNESS, never installed.
The framework ships no runtime checker for Band-1 artifacts and must not — AT
criteria are BA-confirmed evidence checks with no checker by construction, and
the technique layer runs nothing. What this validates is the fixture the
compiled prompts are asserted against, so those prompts stay honest.

  check-band1-artifacts.py --canvas F [--glossary F] [--register F]
  check-band1-artifacts.py --early F --later F --kind glossary|register
  ...  [--expect B4,B7]   exit 0 iff exactly those rules are violated
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys

CANVAS_SECTIONS = [
    "Customers",
    "Problems",
    "Product.The",
    "Product.Is",
    "Product.That",
    "Forms",
    "Core Functions",
    "Third-Party Connections",
    "Localization",
    "Competition.Unlike",
    "Competition.Our Solution",
    "Objectives",
    "Context/Constraints",
]

GLOSSARY_HEADER = ["Term", "Definition", "Merged synonyms", "Source"]
REGISTER_HEADER = [
    "Stakeholder",
    "Kind",
    "Role in project",
    "Decision rights",
    "Comms line",
    "Source",
]

KIND_VOCABULARY = {"individual", "population"}

CONTEXT_SECTIONS = ["Existing systems", "Organizational landscape"]
CONTEXT_HEADER = ["System", "Role today", "Disposition (where stated)", "Source"]
GREENFIELD_RE = re.compile(r"greenfield\s*—\s*no existing systems\s*—\s*\S")
BINDING_MODALS = re.compile(r"\b(must not|may not|must|shall)\b", re.IGNORECASE)

CONSTRAINT_SECTIONS = ["1. Technical", "2. Business", "3. Regulatory"]
CONSTRAINT_HEADER = ["Constraint", "Status", "Source"]
STATUS_VOCABULARY = {"Confirmed", "Assumed"}
NONE_IDENTIFIED_RE = re.compile(r"none identified\s*—\s*\S")

COMPETITIVE_HEADER = ["Alternative", "Category", "Covers", "Falls short", "Source"]
STATUS_QUO_RE = re.compile(r"status quo|current way of working", re.IGNORECASE)

TC_CLAUSES = ("TC-1 — Details:", "TC-2 — System-facing activities:", "TC-3 — Namespace:")
CHARTER_HEAD_RE = re.compile(
    r"^\s*(?:#{1,6}\s+|\*\*)(?P<name>[A-Z][\w'’-]*)\s*[—–-]\s*details\s*:\s*(?P<pop>[^*\n]+?)\s*\**\s*$",
    re.IGNORECASE,
)
CHARTER_FIELDS = [
    "Goals",
    "Behaviors & environment",
    "Frustrations",
    "System-facing activities",
    "Source",
]

SURFACE_SECTIONS = ["Forms", "Core Functions", "Third-Party Connections", "Localization"]
PRODUCT_SLOTS = ["Product.The", "Product.Is", "Product.That"]
VISION_LINK_RE = re.compile(r"→\s*(Product\.(?:The|Is|That)|Our Solution)")
KEY_RE = re.compile(r"→\s*[PO]-\d+")

OPEN_MARKER = "open — no source material"
NA_RE = re.compile(r"N/A\s*—\s*\S")
BARE_NA_RE = re.compile(r"N/A(?!\s*—\s*\S)")
CITATION_RE = re.compile(r"\[[^\]\n]+\]")
DATE_RE = re.compile(r"\b\d{4}-\d{2}-\d{2}\b")
PLACEHOLDERS = ("tbd", "todo", "<", "the sponsor", "n/n", "xxx")

RULES = {
    "B1": "canvas — thirteen sections, exact names, exact order",
    "B2": "canvas — every cell cited or marked; no unmarked assertion",
    "B3": "canvas — no blank cell, and no bare `N/A` without a reason",
    "B4": "canvas — `P-n`/`O-n` on Problems/Objectives, from 1, contiguous, unique",
    "B5": "canvas — every `→ P-n` / `→ O-n` link resolves to a defined ID",
    "B6": "canvas — Core Functions carries ≤ 10 capability lines",
    "B7": "canvas — Customers names a sponsor and ≥ 1 further population, no placeholders",
    "B8": "glossary — header is Term · Definition · Merged synonyms · Source, in order",
    "B9": "glossary — no stub entry: definition and source present in every row",
    "B10": "glossary — every merge is dated",
    "B11": "register — header is Stakeholder · Kind · Role in project · Decision rights · Comms line · Source, in order",
    "B12": "register — Kind is `individual` or `population`",
    "B13": "register — every entry carries a role, plus decision rights or a comms line, plus a source",
    "B14": "register — the sponsor's decision authority is explicit",
    "B15": "coherence — every canvas Customers entity resolves to a register entry",
    "B16": "continuity — the earlier artifact survives unchanged inside the later one",
    "B17": "context — two sections, `Existing systems` then `Organizational landscape`",
    "B18": "context — systems header is System · Role today · Disposition (where stated) · Source, or the sourced greenfield line stands instead",
    "B19": "context — every systems row and every landscape line is cited or marked",
    "B20": "context — no binding statement in the landscape; a bind belongs to constraints.md",
    "B21": "constraints — three numbered class sections: 1. Technical · 2. Business · 3. Regulatory, in order",
    "B22": "constraints — header is Constraint · Status · Source, in order",
    "B23": "constraints — Status is `Confirmed` or `Assumed`, and nothing else",
    "B24": "constraints — every class carries a row or `none identified — <basis>`; every row is sourced",
    "B25": "competitive — header is Alternative · Category · Covers · Falls short · Source, in order",
    "B26": "competitive — the status quo is screened as an alternative",
    "B27": "competitive — every `Falls short` cell keys a `→ P-n` / `→ O-n`; every row is sourced",
    "B28": "personas — the three transformation clauses TC-1 · TC-2 · TC-3 stand in the file",
    "B29": "personas — every charter carries the `<Name> — details: <population>` heading and all five fields",
    "B30": "personas — TC-1: each charter's population resolves to a register entry",
    "B31": "personas — TC-3: no persona name collides with a register population or individual",
    "B32": "canvas aspect grade — AT-VA-1: every P-line names a who-hurts resolving to a register population",
    "B33": "canvas aspect grade — AT-VA-2: every O-line carries a `→ P-n` link",
    "B34": "canvas aspect grade — AT-VI-1: the three Product slots are filled, none left open",
    "B35": "canvas aspect grade — AT-VI-2: Our Solution names an Unlike entry and keys its delta",
    "B36": "canvas aspect grade — AT-SO-1: the four surface sections are filled or `N/A — <reason>`, none left open",
    "B37": "canvas aspect grade — AT-SO-2: every Core Function line carries `→ O-n` or a vision-section link",
    "B38": "canvas aspect grade — AT-SO-3: every connection row carries its role, and a direction stated or explicitly open",
    "B39": "status flip — a flipped constraint row keeps its class, wording and position; only Status moves",
}


class Report:
    def __init__(self) -> None:
        self.violations: list[tuple[str, str]] = []

    def fail(self, rule: str, detail: str) -> None:
        self.violations.append((rule, detail))

    @property
    def rule_ids(self) -> list[str]:
        seen: list[str] = []
        for rule, _ in self.violations:
            if rule not in seen:
                seen.append(rule)
        return sorted(seen, key=lambda r: int(r[1:]))


# ───────────────────────────────────────────────────────────── table parsing ─


def strip_comments(text: str) -> str:
    return re.sub(r"<!--.*?-->", "", text, flags=re.DOTALL)


def split_row(line: str) -> list[str]:
    body = line.strip()
    if body.startswith("|"):
        body = body[1:]
    if body.endswith("|"):
        body = body[:-1]
    return [c.strip() for c in body.split("|")]


def is_separator(cells: list[str]) -> bool:
    return bool(cells) and all(re.fullmatch(r":?-{2,}:?", c) for c in cells)


def read_table(path: pathlib.Path) -> tuple[list[str], list[list[str]]]:
    """First markdown table in the file: (header cells, data rows)."""
    lines = [ln for ln in strip_comments(path.read_text(encoding="utf-8")).splitlines()]
    header: list[str] | None = None
    rows: list[list[str]] = []
    for ln in lines:
        if not ln.strip().startswith("|"):
            if header is not None and rows:
                break
            continue
        cells = split_row(ln)
        if is_separator(cells):
            continue
        if header is None:
            header = cells
        else:
            rows.append(cells)
    return header or [], rows


def segments(cell: str) -> list[str]:
    parts = [p.strip() for p in re.split(r"\s+·\s+", cell)]
    return [p for p in parts if p]


def md_sections(path: pathlib.Path) -> list[tuple[str, list[str]]]:
    """`## Heading` → its body lines, in file order. Comments stripped."""
    out: list[tuple[str, list[str]]] = []
    current: tuple[str, list[str]] | None = None
    for ln in strip_comments(path.read_text(encoding="utf-8")).splitlines():
        m = re.match(r"^##\s+(.*?)\s*$", ln)
        if m:
            current = (m.group(1), [])
            out.append(current)
        elif current is not None:
            current[1].append(ln)
    return out


def table_of(lines: list[str]) -> tuple[list[str], list[list[str]]]:
    """The first markdown table inside a block of lines."""
    header: list[str] | None = None
    rows: list[list[str]] = []
    for ln in lines:
        if not ln.strip().startswith("|"):
            if header is not None and rows:
                break
            continue
        cells = split_row(ln)
        if is_separator(cells):
            continue
        if header is None:
            header = cells
        else:
            rows.append(cells)
    return header or [], rows


def uncited(text: str) -> bool:
    return not CITATION_RE.search(text)


# ───────────────────────────────────────────────────────────────────── canvas ─


def parse_customers(cell: str) -> tuple[list[str], list[str]]:
    """(sponsors, everyone named) from the Customers cell, label-shape tolerant."""
    named: list[str] = []
    sponsors: list[str] = []
    label = None
    for seg in segments(cell):
        text = CITATION_RE.sub("", seg).strip()
        m = re.match(r"^(Sponsors?|Populations?)\s*:\s*(.*)$", text, re.IGNORECASE)
        if m:
            label = m.group(1).lower()
            text = m.group(2).strip()
        if not text:
            continue
        name = re.split(r"\s+—\s+", text, maxsplit=1)[0].strip().rstrip(".,;")
        if not name:
            continue
        named.append(name)
        if label and label.startswith("sponsor"):
            sponsors.append(name)
        elif re.search(r"\bsponsor\b", text, re.IGNORECASE):
            sponsors.append(name)
    return sponsors, named


def check_canvas(path: pathlib.Path, rep: Report) -> dict[str, list[str]]:
    header, rows = read_table(path)
    sections: dict[str, str] = {}
    order: list[str] = []
    for row in rows:
        if len(row) < 3:
            rep.fail("B1", f"{path.name}: malformed row {row!r}")
            continue
        name, content = row[1].strip(), row[2].strip()
        order.append(name)
        sections[name] = content

    if order != CANVAS_SECTIONS:
        extra = [s for s in order if s not in CANVAS_SECTIONS]
        missing = [s for s in CANVAS_SECTIONS if s not in order]
        detail = f"{path.name}: got {len(order)} section(s)"
        if missing:
            detail += f"; missing {missing}"
        if extra:
            detail += f"; unexpected {extra}"
        if not missing and not extra:
            detail += "; out of order"
        rep.fail("B1", detail)

    for name, content in sections.items():
        if not content:
            rep.fail("B3", f"{path.name}: §{name} is blank")
            continue
        if BARE_NA_RE.search(content) and not NA_RE.search(content):
            rep.fail("B3", f"{path.name}: §{name} carries a bare `N/A` with no reason")
        cited = bool(CITATION_RE.search(content))
        if not cited:
            unmarked = [
                s
                for s in segments(content)
                if OPEN_MARKER not in s and not NA_RE.search(s)
            ]
            if unmarked:
                rep.fail(
                    "B2",
                    f"{path.name}: §{name} — neither cited nor marked: {unmarked[0]!r}",
                )

    ids: dict[str, list[str]] = {"P": [], "O": []}
    for prefix, section in (("P", "Problems"), ("O", "Objectives")):
        body = sections.get(section, "")
        found = [
            m.group(1)
            for m in re.finditer(rf"(?<![\w-]){prefix}-(\d+)\b", body)
            if f"→ {prefix}-{m.group(1)}" not in body[max(0, m.start() - 3) : m.end()]
        ]
        defined = []
        for seg in segments(body):
            m = re.match(rf"^{prefix}-(\d+)\b", CITATION_RE.sub("", seg).strip())
            if m:
                defined.append(m.group(1))
        nums = [int(n) for n in defined]
        if sorted(nums) != list(range(1, len(nums) + 1)) or len(set(nums)) != len(nums):
            rep.fail(
                "B4",
                f"{path.name}: §{section} line-IDs are {defined or '[]'} — "
                f"expected {prefix}-1…{prefix}-{len(nums) or 1}, unique and contiguous",
            )
        ids[prefix] = [f"{prefix}-{n}" for n in defined]
        _ = found

    whole = "\n".join(sections.values())
    for m in re.finditer(r"→\s*([PO])-(\d+)", whole):
        ref = f"{m.group(1)}-{m.group(2)}"
        if ref not in ids[m.group(1)]:
            rep.fail("B5", f"{path.name}: link `→ {ref}` resolves to no defined line-ID")

    functions = segments(sections.get("Core Functions", ""))
    if len(functions) > 10:
        rep.fail("B6", f"{path.name}: {len(functions)} capability lines, cap is 10")

    customers = sections.get("Customers", "")
    sponsors, named = parse_customers(customers)
    if not sponsors:
        rep.fail("B7", f"{path.name}: §Customers names no sponsor / decision-maker")
    if len(named) - len(sponsors) < 1:
        rep.fail("B7", f"{path.name}: §Customers names no user population")
    low = CITATION_RE.sub("", customers).lower()
    hit = [p for p in PLACEHOLDERS if p in low]
    if hit:
        rep.fail("B7", f"{path.name}: §Customers carries a placeholder: {hit[0]!r}")

    return {"customers": named, "sponsors": sponsors}


# ─────────────────────────────────────────────────────────────────── glossary ─


def check_glossary(path: pathlib.Path, rep: Report) -> dict[str, str]:
    header, rows = read_table(path)
    if header != GLOSSARY_HEADER:
        rep.fail("B8", f"{path.name}: header is {header}, expected {GLOSSARY_HEADER}")
    terms: dict[str, str] = {}
    for row in rows:
        if len(row) < 4:
            rep.fail("B9", f"{path.name}: malformed row {row!r}")
            continue
        term, definition, merged, source = (c.strip() for c in row[:4])
        terms[term] = definition
        if not term:
            rep.fail("B9", f"{path.name}: a row has no term")
        if not definition:
            rep.fail("B9", f"{path.name}: {term} — stub entry, no definition")
        if not source:
            rep.fail("B9", f"{path.name}: {term} — no source")
        if not merged:
            rep.fail("B9", f"{path.name}: {term} — Merged synonyms cell is blank; use `—`")
        elif merged != "—" and not DATE_RE.search(merged):
            rep.fail("B10", f"{path.name}: {term} — merge {merged!r} carries no date")
    return terms


# ─────────────────────────────────────────────────────────────────── register ─


def check_register(path: pathlib.Path, rep: Report) -> dict[str, str]:
    header, rows = read_table(path)
    if header != REGISTER_HEADER:
        rep.fail("B11", f"{path.name}: header is {header}, expected {REGISTER_HEADER}")
    entries: dict[str, str] = {}
    sponsor_rows = 0
    for row in rows:
        if len(row) < 6:
            rep.fail("B13", f"{path.name}: malformed row {row!r}")
            continue
        who, kind, role, rights, comms, source = (c.strip() for c in row[:6])
        entries[who] = role
        if kind.lower() not in KIND_VOCABULARY:
            rep.fail("B12", f"{path.name}: {who} — Kind {kind!r} is outside the vocabulary")
        if not role or role == "—":
            rep.fail("B13", f"{path.name}: {who} — no role in project")
        if (not rights or rights == "—") and (not comms or comms == "—"):
            rep.fail("B13", f"{path.name}: {who} — neither decision rights nor a comms line")
        if not source:
            rep.fail("B13", f"{path.name}: {who} — no source")
        if re.search(r"\bsponsor\b", role, re.IGNORECASE):
            sponsor_rows += 1
            if not rights or rights == "—":
                rep.fail("B14", f"{path.name}: {who} is the sponsor, and decides nothing on the record")
    if sponsor_rows == 0:
        rep.fail("B14", f"{path.name}: no entry carries the sponsor role")
    return entries


# ──────────────────────────────────────────────────────────────────── context ─


def check_context(path: pathlib.Path, rep: Report) -> None:
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != CONTEXT_SECTIONS:
        rep.fail("B17", f"{path.name}: sections are {names}, expected {CONTEXT_SECTIONS}")

    body = dict(secs)
    systems = body.get("Existing systems", [])
    text = "\n".join(systems)
    header, rows = table_of(systems)

    if GREENFIELD_RE.search(text):
        if rows:
            rep.fail("B18", f"{path.name}: a greenfield ruling stands AND a systems table — one or the other")
    elif header != CONTEXT_HEADER:
        rep.fail("B18", f"{path.name}: systems header is {header}, expected {CONTEXT_HEADER}")

    for row in rows:
        if len(row) < 4:
            rep.fail("B18", f"{path.name}: malformed systems row {row!r}")
            continue
        system, role, disposition, source = (c.strip() for c in row[:4])
        if not system or not role:
            rep.fail("B19", f"{path.name}: {system or row!r} — no role today")
        if not source:
            rep.fail("B19", f"{path.name}: {system!r} — no source")
        for cell in (role, disposition):
            if BINDING_MODALS.search(cell):
                rep.fail(
                    "B20",
                    f"{path.name}: {system!r} — binding language in the landscape: {cell!r}",
                )

    # absence lines below the table carry a citation — wrapped prose is one line
    paragraphs: list[str] = []
    for line in systems:
        s = line.strip()
        if not s or s.startswith("|") or s.startswith("<"):
            paragraphs.append("")
            continue
        if paragraphs and paragraphs[-1]:
            paragraphs[-1] += " " + s
        else:
            paragraphs.append(s)
    for para in (p for p in paragraphs if p):
        if uncited(para) and not GREENFIELD_RE.search(para):
            rep.fail("B19", f"{path.name}: absence line neither cited nor marked: {para!r}")

    landscape = body.get("Organizational landscape", [])
    bullets = [ln.strip() for ln in landscape if ln.strip().startswith("- ")]
    if not bullets:
        rep.fail("B17", f"{path.name}: Organizational landscape carries no lines")
    joined: list[str] = []
    for ln in landscape:
        s = ln.strip()
        if s.startswith("- "):
            joined.append(s)
        elif s and joined:
            joined[-1] += " " + s
    for line in joined:
        if uncited(line):
            rep.fail("B19", f"{path.name}: landscape line neither cited nor marked: {line!r}")
        if BINDING_MODALS.search(CITATION_RE.sub("", line)):
            rep.fail("B20", f"{path.name}: binding language in the landscape: {line!r}")


# ──────────────────────────────────────────────────────────────── constraints ─


def check_constraints(path: pathlib.Path, rep: Report) -> dict[str, tuple[str, str]]:
    """→ {constraint text: (class, status)} for the flip check."""
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != CONSTRAINT_SECTIONS:
        rep.fail("B21", f"{path.name}: sections are {names}, expected {CONSTRAINT_SECTIONS}")

    found: dict[str, tuple[str, str]] = {}
    for name, lines in secs:
        text = "\n".join(lines)
        header, rows = table_of(lines)
        if NONE_IDENTIFIED_RE.search(text):
            if rows:
                rep.fail("B24", f"{path.name}: §{name} carries rows AND a none-identified line")
            continue
        if not rows:
            rep.fail("B24", f"{path.name}: §{name} is silent — no row, no `none identified — <basis>`")
            continue
        if header != CONSTRAINT_HEADER:
            rep.fail("B22", f"{path.name}: §{name} header is {header}, expected {CONSTRAINT_HEADER}")
        for row in rows:
            if len(row) < 3:
                rep.fail("B22", f"{path.name}: §{name} malformed row {row!r}")
                continue
            constraint, status, source = (c.strip() for c in row[:3])
            if not constraint:
                rep.fail("B24", f"{path.name}: §{name} — a row states no constraint")
            if not source:
                rep.fail("B24", f"{path.name}: §{name} — {constraint!r} carries no source")
            if status not in STATUS_VOCABULARY:
                rep.fail(
                    "B23",
                    f"{path.name}: §{name} — Status {status!r} is outside "
                    f"{sorted(STATUS_VOCABULARY)}; dates and callers belong in Source",
                )
            found[constraint] = (name, status)
    return found


def check_flip(early: pathlib.Path, later: pathlib.Path, rep: Report) -> None:
    quiet = Report()
    a, b = check_constraints(early, quiet), check_constraints(later, quiet)
    for constraint, (cls, status) in a.items():
        if constraint not in b:
            rep.fail(
                "B39",
                f"{constraint!r} is in {early.name} and gone from {later.name} — "
                "a flip edits a row, it does not replace one",
            )
            continue
        later_cls, later_status = b[constraint]
        if later_cls != cls:
            rep.fail("B39", f"{constraint!r} moved class: {cls} → {later_cls}")
        if later_status != status and (status, later_status) != ("Assumed", "Confirmed"):
            rep.fail(
                "B39",
                f"{constraint!r} Status went {status} → {later_status}; "
                "the only legal flip is Assumed → Confirmed",
            )


# ──────────────────────────────────────────────────────────────── competitive ─


def check_competitive(path: pathlib.Path, rep: Report) -> None:
    text = strip_comments(path.read_text(encoding="utf-8"))
    header, rows = table_of(text.splitlines())

    if not rows:
        if not NA_RE.search(text):
            rep.fail("B26", f"{path.name}: no entries and no `N/A — <reason>` ruling")
        return

    if header != COMPETITIVE_HEADER:
        rep.fail("B25", f"{path.name}: header is {header}, expected {COMPETITIVE_HEADER}")

    screened = False
    for row in rows:
        if len(row) < 5:
            rep.fail("B25", f"{path.name}: malformed row {row!r}")
            continue
        alt, category, covers, falls, source = (c.strip() for c in row[:5])
        if STATUS_QUO_RE.search(alt) or STATUS_QUO_RE.search(category):
            screened = True
        if not covers:
            rep.fail("B27", f"{path.name}: {alt!r} — Covers is empty")
        if not source:
            rep.fail("B27", f"{path.name}: {alt!r} — no source")
        if not KEY_RE.search(falls):
            rep.fail(
                "B27",
                f"{path.name}: {alt!r} — `Falls short` keys no `→ P-n` / `→ O-n`; "
                "an unkeyed delta is decoration, not differentiation ground",
            )
    if not screened:
        rep.fail("B26", f"{path.name}: the status quo is not among the screened alternatives")


# ─────────────────────────────────────────────────────────────────── personas ─


def check_personas(path: pathlib.Path, register: dict[str, str] | None, rep: Report) -> list[str]:
    raw = strip_comments(path.read_text(encoding="utf-8"))
    for clause in TC_CLAUSES:
        if clause not in re.sub(r"\s+", " ", raw):
            rep.fail("B28", f"{path.name}: transformation clause missing: {clause!r}")

    charters: list[tuple[str, str, list[str]]] = []
    current: tuple[str, str, list[str]] | None = None
    for ln in raw.splitlines():
        m = CHARTER_HEAD_RE.match(ln.strip())
        if m and m.group("name").lower() not in ("tc", "field"):
            current = (m.group("name").strip(), m.group("pop").strip(), [])
            charters.append(current)
        elif current is not None:
            current[2].append(ln)

    if not charters:
        rep.fail("B29", f"{path.name}: no charter carries a `<Name> — details: <population>` heading")
        return []

    names: list[str] = []
    for name, population, lines in charters:
        names.append(name)
        _, rows = table_of(lines)
        fields = {row[0].strip(): (row[1].strip() if len(row) > 1 else "") for row in rows}
        for field in CHARTER_FIELDS:
            if field not in fields:
                rep.fail("B29", f"{path.name}: {name} — no `{field}` field")
            elif not fields[field]:
                rep.fail("B29", f"{path.name}: {name} — `{field}` is empty")
        if register is not None:
            if not any(population.lower() == who.lower() for who in register):
                rep.fail(
                    "B30",
                    f"{path.name}: {name} details {population!r}, which resolves to no register entry",
                )
            for who in register:
                if name.lower() == who.lower():
                    rep.fail(
                        "B31",
                        f"{path.name}: persona name {name!r} collides with register entry {who!r}",
                    )
    return names


# ──────────────────────────────────────────────────────── canvas aspect grade ─


def check_canvas_aspect_grade(
    path: pathlib.Path, register: dict[str, str] | None, rep: Report
) -> None:
    _, rows = read_table(path)
    sections = {row[1].strip(): row[2].strip() for row in rows if len(row) >= 3}

    # AT-VA-1 — every P-line names a who-hurts that resolves
    if register is not None:
        for seg in segments(sections.get("Problems", "")):
            body = CITATION_RE.sub("", seg)
            if not re.match(r"^P-\d+", body.strip()):
                continue
            if not any(re.search(rf"\b{re.escape(who)}\b", body, re.IGNORECASE) for who in register):
                rep.fail("B32", f"{path.name}: {body.strip()[:60]!r} names no register population")

    # AT-VA-2 — every O-line carries its link
    for seg in segments(sections.get("Objectives", "")):
        body = seg.strip()
        if not re.match(r"^O-\d+", CITATION_RE.sub("", body).strip()):
            continue
        if not re.search(r"→\s*P-\d+", body):
            rep.fail("B33", f"{path.name}: {CITATION_RE.sub('', body).strip()[:60]!r} carries no `→ P-n`")

    # AT-VI-1 — the three slots
    for slot in PRODUCT_SLOTS:
        content = sections.get(slot, "")
        if not content or OPEN_MARKER in content:
            rep.fail("B34", f"{path.name}: §{slot} is empty or still open")

    # AT-VI-2 — Our Solution names a target and keys its delta
    ours = sections.get("Competition.Our Solution", "")
    unlike = sections.get("Competition.Unlike", "")
    if not ours or OPEN_MARKER in ours:
        rep.fail("B35", f"{path.name}: §Competition.Our Solution is empty or still open")
    else:
        low = ours.lower()
        named = any(
            CITATION_RE.sub("", seg).strip().lower() in low
            for seg in segments(unlike)
            if CITATION_RE.sub("", seg).strip()
        )
        if not named:
            rep.fail("B35", f"{path.name}: the differentiation names no Unlike entry")
        if not KEY_RE.search(ours):
            rep.fail("B35", f"{path.name}: the differentiation keys no `→ P-n` / `→ O-n`")

    # AT-SO-1 — the surface, filled or ruled
    for name in SURFACE_SECTIONS:
        content = sections.get(name, "")
        if not content or OPEN_MARKER in content:
            rep.fail("B36", f"{path.name}: §{name} is empty or still open")

    # AT-SO-2 — every function linked
    for seg in segments(sections.get("Core Functions", "")):
        if not re.search(r"→\s*O-\d+", seg) and not VISION_LINK_RE.search(seg):
            rep.fail(
                "B37",
                f"{path.name}: function {CITATION_RE.sub('', seg).strip()[:60]!r} "
                "carries no `→ O-n` and no vision-section link",
            )

    # AT-SO-3 — role, and direction stated or explicitly open
    connections = sections.get("Third-Party Connections", "")
    if connections and not NA_RE.search(connections):
        for seg in re.split(r"\s+·\s+(?=[A-Z])", connections):
            body = CITATION_RE.sub("", seg).strip()
            if not body:
                continue
            parts = re.split(r"\bdirection\b", body, maxsplit=1, flags=re.IGNORECASE)
            if len(parts) < 2:
                rep.fail("B38", f"{path.name}: connection {body[:50]!r} states no direction")
                continue
            head, after = parts[0], parts[1]
            if not re.search(r"[—:-]\s*\S", after):
                rep.fail("B38", f"{path.name}: connection {body[:50]!r} — direction slot is empty")
            if "—" not in head:
                rep.fail("B38", f"{path.name}: connection {body[:50]!r} carries no role clause")


# ────────────────────────────────────────────────────── coherence, continuity ─


def check_coherence(canvas: dict[str, list[str]], register: dict[str, str], rep: Report) -> None:
    for name in canvas["customers"]:
        if not any(name.lower() == who.lower() for who in register):
            rep.fail("B15", f"canvas Customers names {name!r}, which resolves to no register entry")


def check_continuity(early: pathlib.Path, later: pathlib.Path, kind: str, rep: Report) -> None:
    quiet = Report()
    if kind == "glossary":
        a, b = check_glossary(early, quiet), check_glossary(later, quiet)
        label = "term"
    else:
        a, b = check_register(early, quiet), check_register(later, quiet)
        label = "entry"
    for key, value in a.items():
        if key not in b:
            rep.fail("B16", f"{label} {key!r} is in {early.name} and gone from {later.name}")
        elif b[key] != value:
            rep.fail(
                "B16",
                f"{label} {key!r} changed between {early.name} and {later.name}:\n"
                f"        was:  {value}\n        now:  {b[key]}",
            )


# ─────────────────────────────────────────────────────────────────────── main ─


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--canvas", type=pathlib.Path)
    ap.add_argument("--aspect-grade", action="store_true",
                    help="judge the canvas at ASPECT grade too (AT-VA/VI/SO), not framing grade")
    ap.add_argument("--glossary", type=pathlib.Path)
    ap.add_argument("--register", type=pathlib.Path)
    ap.add_argument("--context", type=pathlib.Path)
    ap.add_argument("--constraints", type=pathlib.Path)
    ap.add_argument("--competitive", type=pathlib.Path)
    ap.add_argument("--personas", type=pathlib.Path)
    ap.add_argument("--flip-early", type=pathlib.Path)
    ap.add_argument("--flip-later", type=pathlib.Path)
    ap.add_argument("--early", type=pathlib.Path)
    ap.add_argument("--later", type=pathlib.Path)
    ap.add_argument("--kind", choices=("glossary", "register"))
    ap.add_argument("--expect", default=None, help="comma-separated rule IDs that MUST be the violations")
    args = ap.parse_args()

    rep = Report()
    canvas_facts: dict[str, list[str]] | None = None
    register_facts: dict[str, str] | None = None
    checked: list[str] = []

    if args.canvas:
        canvas_facts = check_canvas(args.canvas, rep)
        checked.append("canvas")
    if args.glossary:
        check_glossary(args.glossary, rep)
        checked.append("glossary")
    if args.register:
        register_facts = check_register(args.register, rep)
        checked.append("register")
    if canvas_facts is not None and register_facts is not None:
        check_coherence(canvas_facts, register_facts, rep)
        checked.append("coherence")
    if args.canvas and args.aspect_grade:
        check_canvas_aspect_grade(args.canvas, register_facts, rep)
        checked.append("canvas(aspect grade)")
    if args.context:
        check_context(args.context, rep)
        checked.append("context")
    if args.constraints:
        check_constraints(args.constraints, rep)
        checked.append("constraints")
    if args.competitive:
        check_competitive(args.competitive, rep)
        checked.append("competitive")
    if args.personas:
        check_personas(args.personas, register_facts, rep)
        checked.append("personas")
    if args.flip_early or args.flip_later:
        if not (args.flip_early and args.flip_later):
            print("--flip-early and --flip-later go together", file=sys.stderr)
            return 2
        check_flip(args.flip_early, args.flip_later, rep)
        checked.append("status-flip")
    if args.early or args.later:
        if not (args.early and args.later and args.kind):
            print("--early, --later and --kind go together", file=sys.stderr)
            return 2
        check_continuity(args.early, args.later, args.kind, rep)
        checked.append(f"continuity({args.kind})")
    if not checked:
        print("nothing to check — pass --canvas / --glossary / --register / --early+--later", file=sys.stderr)
        return 2

    if args.expect is not None:
        want = sorted((r.strip() for r in args.expect.split(",") if r.strip()), key=lambda r: int(r[1:]))
        got = rep.rule_ids
        if got == want:
            return 0
        print(f"expected violations {want}, got {got}")
        for rule, detail in rep.violations:
            print(f"      {rule}  {detail}")
        return 1

    if rep.violations:
        for rule, detail in rep.violations:
            print(f"  ✗ {rule}  {RULES[rule]}\n        {detail}")
        return 1

    print(f"✓ {' · '.join(checked)} — {len(RULES)} rules, no violations")
    return 0


if __name__ == "__main__":
    sys.exit(main())
