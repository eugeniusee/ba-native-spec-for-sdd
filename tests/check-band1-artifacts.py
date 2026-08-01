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

DOMAIN_SECTIONS = ["Entities", "Relations", "Boundary references (external — not entities)"]
ENTITY_HEADER = ["Entity", "What it is (one business line)", "Source"]
RELATION_HEADER = ["From", "Relation", "To", "Multiplicity (where stated)", "Source"]
# per-feature data grade — what conceptual grade must never descend into
FIELD_GRADE_RE = re.compile(
    r"\b(datetime|varchar|integer|boolean|nullable|primary key|foreign key|"
    r"not null|required\?|max ?length)\b|`\w+_(id|at|date)`", re.IGNORECASE)
LIFECYCLE_HEAD_RE = re.compile(r"^(states?|lifecycle|status(es)? )", re.IGNORECASE)

ROLES_SECTIONS = ["Roles", "Policy"]
ROLE_HEADER = ["Role", "Mandate (one line)", "Derived from", "Source"]
POLICY_HEADER = ["Role", "Entity", "Action", "Rule / scope", "Source"]
WILDCARD_RE = re.compile(r"^\s*(\*|all|any|everything)\s*$", re.IGNORECASE)
INHERITANCE_RE = re.compile(r"\binherits?\b|\bextends\b|\bplus all\b", re.IGNORECASE)

JOURNEY_HEAD_RE = re.compile(r"^(?P<name>.+?)\s+—\s+role:\s*(?P<role>.+?)\s*$")
TRIGGER_RE = re.compile(r"^Trigger:\s*(?P<t>.+?)\s*→\s*Outcome:\s*(?P<o>.+?)\s*$")
STEP_RE = re.compile(r"^(?P<n>\d+)\.\s*(?P<body>.+)$")
# helicopter grade — a journey never states a cutoff, an error path or an alternate
CUTOFF_RE = re.compile(
    r"\b\d+\s*(seconds?|minutes?|hours?|days?|sec|min|ms)\b|\bwithin \d|\bafter \d|"
    r"\bexpir|\btimes? out\b|\bretr(y|ies)\b", re.IGNORECASE)
ERRORPATH_RE = re.compile(
    r"\bif (the |a |an )?\w+ fails\b|\botherwise\b|\bon (failure|error)\b|"
    r"\balternate(ly)?\b|\bfallback\b", re.IGNORECASE)

DESIGN_SECTIONS = ["Global budgets", "UX & interaction conventions",
                   "Visual identity & references"]
BUDGET_HEADER = ["Budget", "Metric · target · condition", "Source"]
CONVENTION_HEADER = ["Convention", "Statement", "Source"]
ID_FAMILY_RE = re.compile(r"\b(GB|DS|UX)-\d+\b")

CONSTITUTION_SECTIONS = ["Principles", "Governance references"]
PRINCIPLE_HEADER = ["Principle", "Statement (MUST form)", "Enforcement surface", "Source"]
GOVREF_HEADER = ["File", "Carries"]
MUST_RE = re.compile(r"\bMUST(?: NOT)?\b")
FRAMEWORK_PRINCIPLES = ["Authorization", "Spec-first iteration"]
# Context-class files that must never enter the Governance-only reference spine
CONTEXT_CLASS_STEMS = {"out-of-scope", "context", "constraints", "stakeholders",
                       "processes", "competitive-analysis", "domain-model",
                       "personas", "roadmap"}

OOS_SECTIONS = ["Exclusions"]
OOS_HEADER = ["Exclusion", "Where it lives instead", "Basis · source"]
LIVES_INSTEAD_RE = re.compile(
    r"^(not planned|deferred\s*(—|-)\s*roadmap candidate,\s*\S|"
    r"deferred\s*→\s*\S|outside the product\s*(—|-)\s*\S)", re.IGNORECASE)

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
    "B40": "domain model — three sections: Entities · Relations · Boundary references, in order",
    "B41": "domain model — entities header is Entity · What it is (one business line) · Source; every row carries a business line and a source",
    "B42": "domain model — relations header is From · Relation · To · Multiplicity (where stated) · Source; every From and To resolves to a defined entity; every row is sourced",
    "B43": "domain model — conceptual grade: no field, type or validation; no state or lifecycle table",
    "B44": "domain model — EG-1: every canvas function object resolves to an entity, every connection system to a boundary reference and never to an entity",
    "B45": "roles — two sections: Roles · Policy, in order; the header points at the constitution and never states the principle",
    "B46": "roles — roles header is Role · Mandate (one line) · Derived from · Source; every role carries all four",
    "B47": "roles — policy header is Role · Entity · Action · Rule / scope · Source; every policy row's role resolves to a defined role; every row is sourced",
    "B48": "roles — one explicit tuple per row: no wildcard cell, no inheritance clause, no duplicate tuple",
    "B49": "roles — every policy row's entity is verbatim from domain-model.md",
    "B50": "roles — TC-3: no persona name appears anywhere in the file",
    "B51": "processes — every journey heads `<name> — role: <role>`, the role verbatim from roles-permissions.md",
    "B52": "processes — every journey carries `Trigger: … → Outcome: …` and a Source line",
    "B53": "processes — steps are numbered from 1, contiguous, each `<actor> <action> → <observable result>`, each cited",
    "B54": "processes — helicopter grade: no cutoff or timing value, no error path or alternate",
    "B55": "processes — every significant role (actor of ≥ 1 canvas Core Function line) carries ≥ 1 journey",
    "B56": "design standards — three sections: Global budgets · UX & interaction conventions · Visual identity & references, in order",
    "B57": "design standards — budgets header is Budget · Metric · target · condition · Source; every row states a metric, a target and a condition, and is sourced",
    "B58": "design standards — conventions header is Convention · Statement · Source; every row is sourced",
    "B59": "design standards — every section is real, `open — no source material`, or `N/A — <reason>`",
    "B60": "design standards — budgets are named rows; no new line-ID family is minted",
    "B61": "constitution — two sections: Principles · Governance references, in order",
    "B62": "constitution — principles header is Principle · Statement (MUST form) · Enforcement surface · Source; every statement is in MUST form and names its enforcement surface",
    "B63": "constitution — the two framework principles stand: Authorization · Spec-first iteration",
    "B64": "constitution — the reference spine is Governance-class only, and every entry resolves to an existing, non-stub file",
    "B65": "constitution — principle grade: no policy row, no budget table, no matrix",
    "B66": "out-of-scope — `## Exclusions` with header Exclusion · Where it lives instead · Basis · source",
    "B67": "out-of-scope — ≥ 1 exclusion, and every lives-instead cell is in the vocabulary or a resolved epic",
    "B68": "out-of-scope — every row names the plausible expectation it fences, with a citation",
    "B69": "late entry — every seed row survives into the mature file unchanged, in place; the mature file only grows",
    "B70": "graduation — a deferred exclusion resolves to a named epic in place or retires; its basis never moves",
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


# ─────────────────────────────────────────────────────────────── domain model ─


def canvas_sections(path: pathlib.Path) -> dict[str, str]:
    _, rows = read_table(path)
    return {row[1].strip(): row[2].strip() for row in rows if len(row) >= 3}


def check_domain(
    path: pathlib.Path, canvas: pathlib.Path | None, rep: Report
) -> list[str]:
    """→ the defined entity names, for the roles run's verbatim check."""
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != DOMAIN_SECTIONS:
        rep.fail("B40", f"{path.name}: sections are {names}, expected {DOMAIN_SECTIONS}")
    body = dict(secs)

    entities: list[str] = []
    header, rows = table_of(body.get("Entities", []))
    if header != ENTITY_HEADER:
        rep.fail("B41", f"{path.name}: entities header is {header}, expected {ENTITY_HEADER}")
    for row in rows:
        if len(row) < 3:
            rep.fail("B41", f"{path.name}: malformed entity row {row!r}")
            continue
        name, line, source = (c.strip() for c in row[:3])
        if not name:
            rep.fail("B41", f"{path.name}: an entity row has no name")
            continue
        entities.append(name)
        if not line:
            rep.fail("B41", f"{path.name}: {name} — no business line")
        if not source:
            rep.fail("B41", f"{path.name}: {name} — no source")
        if FIELD_GRADE_RE.search(line):
            rep.fail("B43", f"{path.name}: {name} — field-grade detail in a business line: {line!r}")

    header, rows = table_of(body.get("Relations", []))
    if header != RELATION_HEADER:
        rep.fail("B42", f"{path.name}: relations header is {header}, expected {RELATION_HEADER}")
    for row in rows:
        if len(row) < 5:
            rep.fail("B42", f"{path.name}: malformed relation row {row!r}")
            continue
        frm, rel, to, _mult, source = (c.strip() for c in row[:5])
        for end, label in ((frm, "From"), (to, "To")):
            if end not in entities:
                rep.fail(
                    "B42",
                    f"{path.name}: relation {frm!r} {rel!r} {to!r} — {label} {end!r} "
                    "resolves to no defined entity",
                )
        if not source:
            rep.fail("B42", f"{path.name}: relation {frm!r} {rel!r} {to!r} — no source")

    whole = strip_comments(path.read_text(encoding="utf-8"))
    for name, lines in secs:
        if LIFECYCLE_HEAD_RE.match(name):
            rep.fail("B43", f"{path.name}: §{name} is a lifecycle table — spec ground")
    if FIELD_GRADE_RE.search("\n".join(body.get("Relations", []))):
        rep.fail("B43", f"{path.name}: field-grade detail in the relations table")

    boundary = [ln.strip() for ln in body.get(DOMAIN_SECTIONS[2], []) if ln.strip().startswith("- ")]

    if canvas is not None:
        sections = canvas_sections(canvas)
        for seg in segments(sections.get("Third-Party Connections", "")):
            system = CITATION_RE.sub("", seg).split("—")[0].strip().rstrip(".,;")
            if not system or NA_RE.search(seg):
                continue
            if any(system.lower() in b.lower() for b in boundary):
                pass
            else:
                rep.fail(
                    "B44",
                    f"{path.name}: connection system {system!r} is disposed by no "
                    "boundary reference",
                )
            if any(system.lower() == e.lower() for e in entities):
                rep.fail("B44", f"{path.name}: connection system {system!r} stands as an entity")
        for seg in segments(sections.get("Core Functions", "")):
            body_txt = CITATION_RE.sub("", seg)
            if not body_txt.strip():
                continue
            if not any(re.search(rf"\b{re.escape(e)}s?\b", body_txt, re.IGNORECASE) for e in entities):
                rep.fail(
                    "B44",
                    f"{path.name}: function {body_txt.strip()[:60]!r} names no entity — "
                    "its object resolves to no entry",
                )
    _ = whole
    return entities


# ────────────────────────────────────────────────────────── roles & permissions ─


def check_roles(
    path: pathlib.Path,
    entities: list[str] | None,
    persona_names: list[str] | None,
    rep: Report,
) -> list[str]:
    """→ the defined role names, for the process run's verbatim check."""
    raw = strip_comments(path.read_text(encoding="utf-8"))
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != ROLES_SECTIONS:
        rep.fail("B45", f"{path.name}: sections are {names}, expected {ROLES_SECTIONS}")
    head = raw.split("##", 1)[0]
    if "constitution.md" not in head:
        rep.fail("B45", f"{path.name}: the header does not point at the constitution")
    if MUST_RE.search(head):
        rep.fail(
            "B45",
            f"{path.name}: the header states the principle in MUST form — this file is "
            "its enforcement surface, never its statement",
        )
    body = dict(secs)

    roles: list[str] = []
    header, rows = table_of(body.get("Roles", []))
    if header != ROLE_HEADER:
        rep.fail("B46", f"{path.name}: roles header is {header}, expected {ROLE_HEADER}")
    for row in rows:
        if len(row) < 4:
            rep.fail("B46", f"{path.name}: malformed role row {row!r}")
            continue
        role, mandate, derived, source = (c.strip() for c in row[:4])
        if not role:
            rep.fail("B46", f"{path.name}: a role row has no role")
            continue
        roles.append(role)
        for cell, label in ((mandate, "mandate"), (derived, "derivation"), (source, "source")):
            if not cell or cell == "—":
                rep.fail("B46", f"{path.name}: {role} — no {label}")

    header, rows = table_of(body.get("Policy", []))
    if rows and header != POLICY_HEADER:
        rep.fail("B47", f"{path.name}: policy header is {header}, expected {POLICY_HEADER}")
    seen: set[tuple[str, str, str]] = set()
    for row in rows:
        if len(row) < 5:
            rep.fail("B47", f"{path.name}: malformed policy row {row!r}")
            continue
        role, entity, action, scope, source = (c.strip() for c in row[:5])
        if role not in roles:
            rep.fail("B47", f"{path.name}: policy row role {role!r} resolves to no defined role")
        if not source:
            rep.fail("B47", f"{path.name}: {role} × {entity} × {action} — no source")
        if not scope or scope == "—":
            rep.fail("B47", f"{path.name}: {role} × {entity} × {action} — no rule/scope qualifier")
        for cell, label in ((role, "Role"), (entity, "Entity"), (action, "Action")):
            if WILDCARD_RE.match(cell):
                rep.fail(
                    "B48",
                    f"{path.name}: {label} cell {cell!r} is a wildcard — the row grain "
                    "must equal the check grain",
                )
        if INHERITANCE_RE.search(scope):
            rep.fail("B48", f"{path.name}: {role} × {entity} × {action} — inheritance clause: {scope!r}")
        tup = (role, entity, action)
        if tup in seen:
            rep.fail("B48", f"{path.name}: tuple {role} × {entity} × {action} is written twice")
        seen.add(tup)
        if entities is not None and entity not in entities:
            rep.fail(
                "B49",
                f"{path.name}: entity cell {entity!r} is not verbatim from domain-model.md",
            )

    if persona_names:
        for name in persona_names:
            if re.search(rf"\b{re.escape(name)}\b", raw):
                rep.fail("B50", f"{path.name}: persona name {name!r} appears in the role model")
    return roles


# ──────────────────────────────────────────────────────────────── processes ─


def parse_journeys(path: pathlib.Path) -> list[tuple[str, str, list[str]]]:
    out: list[tuple[str, str, list[str]]] = []
    for heading, lines in md_sections(path):
        m = JOURNEY_HEAD_RE.match(heading)
        if m:
            out.append((m.group("name").strip(), m.group("role").strip(), lines))
        else:
            out.append((heading, "", lines))
    return out


def check_processes(
    path: pathlib.Path,
    roles: list[str] | None,
    canvas: pathlib.Path | None,
    rep: Report,
) -> None:
    journeys = parse_journeys(path)
    if not journeys:
        rep.fail("B51", f"{path.name}: no journey sections")
        return

    covered: set[str] = set()
    for name, role, lines in journeys:
        if not role:
            rep.fail("B51", f"{path.name}: §{name} carries no `— role: <role>` clause")
        elif roles is not None and role not in roles:
            rep.fail("B51", f"{path.name}: §{name} — role {role!r} resolves to no defined role")
        else:
            covered.add(role)

        text = [ln.strip() for ln in lines if ln.strip()]
        if not any(TRIGGER_RE.match(ln) for ln in text):
            rep.fail("B52", f"{path.name}: §{name} carries no `Trigger: … → Outcome: …` line")
        if not any(ln.startswith("Source:") for ln in text):
            rep.fail("B52", f"{path.name}: §{name} carries no Source line")

        steps = [m for m in (STEP_RE.match(ln) for ln in text) if m]
        if not steps:
            rep.fail("B53", f"{path.name}: §{name} carries no numbered step")
        nums = [int(m.group("n")) for m in steps]
        if nums != list(range(1, len(nums) + 1)):
            rep.fail("B53", f"{path.name}: §{name} step numbering is {nums} — expected 1…{len(nums)}")
        for m in steps:
            step = m.group("body")
            if "→" not in step:
                rep.fail("B53", f"{path.name}: §{name} step {m.group('n')} states no observable result")
            if uncited(step):
                rep.fail("B53", f"{path.name}: §{name} step {m.group('n')} is neither cited nor marked")

        for ln in text:
            bare = CITATION_RE.sub("", ln)
            if CUTOFF_RE.search(bare):
                rep.fail("B54", f"{path.name}: §{name} states a cutoff or timing value: {ln.strip()[:70]!r}")
            if ERRORPATH_RE.search(bare):
                rep.fail("B54", f"{path.name}: §{name} carries an error path or alternate: {ln.strip()[:70]!r}")

    if canvas is not None and roles is not None:
        sections = canvas_sections(canvas)
        surface = sections.get("Core Functions", "") + " " + sections.get("Customers", "")
        for role in roles:
            if not re.search(rf"\b{re.escape(role)}s?\b", surface, re.IGNORECASE):
                continue
            if role not in covered:
                rep.fail(
                    "B55",
                    f"{path.name}: {role} is an actor the canvas surface names and carries "
                    "no journey",
                )


# ───────────────────────────────────────────────────────── design standards ─


def check_design(path: pathlib.Path, rep: Report) -> None:
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != DESIGN_SECTIONS:
        rep.fail("B56", f"{path.name}: sections are {names}, expected {DESIGN_SECTIONS}")
    body = dict(secs)
    raw = strip_comments(path.read_text(encoding="utf-8"))

    header, rows = table_of(body.get("Global budgets", []))
    if header != BUDGET_HEADER:
        rep.fail("B57", f"{path.name}: budgets header is {header}, expected {BUDGET_HEADER}")
    for row in rows:
        if len(row) < 3:
            rep.fail("B57", f"{path.name}: malformed budget row {row!r}")
            continue
        budget, spec, source = (c.strip() for c in row[:3])
        if not budget:
            rep.fail("B57", f"{path.name}: a budget row has no name")
        if len(segments(spec)) < 3:
            rep.fail(
                "B57",
                f"{path.name}: {budget!r} — {spec!r} is not metric · target · condition",
            )
        if not source:
            rep.fail("B57", f"{path.name}: {budget!r} — no source")

    header, rows = table_of(body.get("UX & interaction conventions", []))
    if header != CONVENTION_HEADER:
        rep.fail("B58", f"{path.name}: conventions header is {header}, expected {CONVENTION_HEADER}")
    for row in rows:
        if len(row) < 3:
            rep.fail("B58", f"{path.name}: malformed convention row {row!r}")
            continue
        convention, statement, source = (c.strip() for c in row[:3])
        if not convention or not statement:
            rep.fail("B58", f"{path.name}: a convention row is incomplete: {row!r}")
        if not source:
            rep.fail("B58", f"{path.name}: {convention!r} — no source")

    for name, lines in secs:
        text = "\n".join(lines).strip()
        _, table = table_of(lines)
        if table:
            continue
        if not text:
            rep.fail("B59", f"{path.name}: §{name} is blank — real content, `open`, or `N/A — <reason>`")
        elif OPEN_MARKER not in text and not NA_RE.search(text):
            if BARE_NA_RE.search(text):
                rep.fail("B59", f"{path.name}: §{name} carries a bare `N/A` with no reason")

    if ID_FAMILY_RE.search(raw):
        hit = ID_FAMILY_RE.search(raw).group(0)
        rep.fail("B60", f"{path.name}: line-ID family {hit!r} — budgets are cited by name")


# ─────────────────────────────────────────────────────────────── constitution ─


def check_constitution(path: pathlib.Path, root: pathlib.Path | None, rep: Report) -> None:
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != CONSTITUTION_SECTIONS:
        rep.fail("B61", f"{path.name}: sections are {names}, expected {CONSTITUTION_SECTIONS}")
    body = dict(secs)

    header, rows = table_of(body.get("Principles", []))
    if header != PRINCIPLE_HEADER:
        rep.fail("B62", f"{path.name}: principles header is {header}, expected {PRINCIPLE_HEADER}")
    stated: list[str] = []
    for row in rows:
        if len(row) < 4:
            rep.fail("B62", f"{path.name}: malformed principle row {row!r}")
            continue
        principle, statement, surface, source = (c.strip() for c in row[:4])
        if not principle:
            rep.fail("B62", f"{path.name}: a principle row has no name")
            continue
        stated.append(principle)
        if not MUST_RE.search(statement):
            rep.fail(
                "B62",
                f"{path.name}: {principle} — {statement[:60]!r} is not in MUST form; a check "
                "cannot gate a plan against an aspiration",
            )
        if not surface:
            rep.fail("B62", f"{path.name}: {principle} — names no enforcement surface")
        if not source:
            rep.fail("B62", f"{path.name}: {principle} — no source")
    for framework in FRAMEWORK_PRINCIPLES:
        if framework not in stated:
            rep.fail("B63", f"{path.name}: the {framework} principle is not seeded")

    header, rows = table_of(body.get("Governance references", []))
    if header != GOVREF_HEADER:
        rep.fail("B64", f"{path.name}: references header is {header}, expected {GOVREF_HEADER}")
    for row in rows:
        if len(row) < 2 or not row[0].strip():
            rep.fail("B64", f"{path.name}: malformed reference row {row!r}")
            continue
        ref = row[0].strip().strip("`").strip()
        stem = pathlib.Path(ref).stem
        if stem in CONTEXT_CLASS_STEMS:
            rep.fail(
                "B64",
                f"{path.name}: {ref} is Context-class — the spine is Governance-only",
            )
        if not row[1].strip():
            rep.fail("B64", f"{path.name}: {ref} — the Carries cell is empty")
        if root is not None:
            target = root / ref
            if not target.is_file():
                rep.fail("B64", f"{path.name}: {ref} resolves to no file under {root}")
            elif len(target.read_text(encoding="utf-8").strip().splitlines()) < 3:
                rep.fail("B64", f"{path.name}: {ref} is a stub")

    for _, lines in secs:
        head, _rows = table_of(lines)
        if head and head not in (PRINCIPLE_HEADER, GOVREF_HEADER):
            rep.fail(
                "B65",
                f"{path.name}: a table with header {head} stands here — matrices, policy "
                "rows and budget tables belong to the referenced files",
            )


# ──────────────────────────────────────────────────────────── global out-of-scope ─


def check_oos(path: pathlib.Path, rep: Report) -> None:
    secs = md_sections(path)
    names = [n for n, _ in secs]
    if names != OOS_SECTIONS:
        rep.fail("B66", f"{path.name}: sections are {names}, expected {OOS_SECTIONS}")
    body = dict(secs)

    header, rows = table_of(body.get("Exclusions", []))
    if header != OOS_HEADER:
        rep.fail("B66", f"{path.name}: header is {header}, expected {OOS_HEADER}")
    if not rows:
        rep.fail(
            "B67",
            f"{path.name}: no exclusion — the genuinely-empty boundary takes an aspect "
            "waiver, never an invented row",
        )
    for row in rows:
        if len(row) < 3:
            rep.fail("B66", f"{path.name}: malformed exclusion row {row!r}")
            continue
        exclusion, lives, basis = (c.strip() for c in row[:3])
        if not exclusion:
            rep.fail("B66", f"{path.name}: a row states no exclusion")
            continue
        if not LIVES_INSTEAD_RE.match(lives):
            rep.fail(
                "B67",
                f"{path.name}: {exclusion!r} — {lives!r} is outside the lives-instead "
                "vocabulary",
            )
        if uncited(basis):
            rep.fail(
                "B68",
                f"{path.name}: {exclusion!r} — the basis names no cited expectation; a "
                "fence nobody would test is not a fence",
            )


# ────────────────────────────────────────────────────────────────── late entry ─


LATE_ENTRY_KINDS = {
    "roles": ("Policy", POLICY_HEADER),
    "out-of-scope": ("Exclusions", OOS_HEADER),
}


def _kind_rows(path: pathlib.Path, kind: str) -> list[tuple[str, ...]]:
    section, _ = LATE_ENTRY_KINDS[kind]
    body = dict(md_sections(path))
    _, rows = table_of(body.get(section, []))
    return [tuple(c.strip() for c in row) for row in rows]


def check_late_entry(early: pathlib.Path, later: pathlib.Path, kind: str, rep: Report) -> None:
    a, b = _kind_rows(early, kind), _kind_rows(later, kind)

    if kind == "out-of-scope":
        # graduation, not accretion: a deferred row resolves to a named epic in
        # place, or retires. Its exclusion and its basis never move.
        by_exclusion = {row[0]: row for row in b}
        for row in a:
            exclusion, lives, basis = row[0], row[1], row[2]
            if exclusion not in by_exclusion:
                continue  # retired — the other legal graduation outcome
            _, later_lives, later_basis = by_exclusion[exclusion][:3]
            if later_basis != basis:
                rep.fail(
                    "B70",
                    f"{exclusion!r}: the basis changed between {early.name} and "
                    f"{later.name} — graduation resolves a disposition, not an argument",
                )
            if later_lives == lives:
                continue
            if not (lives.lower().startswith("deferred")
                    and re.match(r"^deferred\s*→\s*\S", later_lives, re.IGNORECASE)):
                rep.fail(
                    "B70",
                    f"{exclusion!r}: {lives!r} → {later_lives!r} is not a graduation; "
                    "only a deferred row resolves to a named epic",
                )
        return

    if len(b) < len(a):
        rep.fail("B69", f"{later.name} has fewer rows than {early.name} — the seed only grows")
    for i, row in enumerate(a):
        if row not in b:
            rep.fail(
                "B69",
                f"seed row {row[0]!r} … {row[-1][:30]!r} is in {early.name} and not in "
                f"{later.name} — a late entry adds a row, it does not rewrite one",
            )
            continue
        if b.index(row) != i:
            rep.fail("B69", f"seed row {row[0]!r} moved from position {i} to {b.index(row)}")


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
    ap.add_argument("--domain", type=pathlib.Path)
    ap.add_argument("--roles", type=pathlib.Path)
    ap.add_argument("--processes", type=pathlib.Path)
    ap.add_argument("--design", type=pathlib.Path)
    ap.add_argument("--constitution", type=pathlib.Path)
    ap.add_argument("--oos", type=pathlib.Path)
    ap.add_argument("--root", type=pathlib.Path,
                    help="project root the constitution's references resolve against")
    ap.add_argument("--seed-early", type=pathlib.Path)
    ap.add_argument("--seed-later", type=pathlib.Path)
    ap.add_argument("--seed-kind", choices=tuple(LATE_ENTRY_KINDS))
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
    persona_names: list[str] = []
    if args.personas:
        persona_names = check_personas(args.personas, register_facts, rep)
        checked.append("personas")

    entities: list[str] | None = None
    roles: list[str] | None = None
    if args.domain:
        entities = check_domain(args.domain, args.canvas, rep)
        checked.append("domain-model")
    if args.roles:
        roles = check_roles(args.roles, entities, persona_names, rep)
        checked.append("roles-permissions")
    if args.processes:
        check_processes(args.processes, roles, args.canvas, rep)
        checked.append("processes")
    if args.design:
        check_design(args.design, rep)
        checked.append("design-standards")
    if args.constitution:
        check_constitution(args.constitution, args.root, rep)
        checked.append("constitution")
    if args.oos:
        check_oos(args.oos, rep)
        checked.append("out-of-scope")
    if args.seed_early or args.seed_later:
        if not (args.seed_early and args.seed_later and args.seed_kind):
            print("--seed-early, --seed-later and --seed-kind go together", file=sys.stderr)
            return 2
        check_late_entry(args.seed_early, args.seed_later, args.seed_kind, rep)
        checked.append(f"late-entry({args.seed_kind})")

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
