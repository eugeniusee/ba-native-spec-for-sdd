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
    ap.add_argument("--glossary", type=pathlib.Path)
    ap.add_argument("--register", type=pathlib.Path)
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
