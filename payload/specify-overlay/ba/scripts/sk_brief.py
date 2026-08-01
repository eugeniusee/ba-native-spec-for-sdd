#!/usr/bin/env python3
"""sk_brief — CC-XA-05: brief exists + slicing-row lookup (contract C12).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §5 C12 · elicitation techniques §4 (the brief's
nine exact headings; the §8 slicing table and its Status vocabulary, D5) ·
plan C2/C3.

  CC-XA-05  the parent epic scope brief exists at its path, and this feature
            appears in the epic's feature slicing — proposed in the brief,
            confirmed at delivery-loop entry.

Waivable by design (contract §8): CC-XA-05 is the urgent-feature escape valve.
The checker still fails it plainly; the BA grants the waiver, never the script.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

# No bytecode: these scripts import one another (sk_structure is the shared
# parse surface), and a __pycache__ directory inside the installed
# `.specify/ba/scripts/` would join the install manifest's hash list and
# make it rot on first use.
sys.dont_write_bytecode = True


sys.path.insert(0, str(Path(__file__).resolve().parent))

from sk_structure import (  # noqa: E402
    Finding, base_parser, emit, fail, ok, runtime_defect, table_rows,
)

CONFIRMED_RE = re.compile(r"^Confirmed\s*[—–-]\s*(?P<date>\S+)", re.IGNORECASE)
PROPOSED_RE = re.compile(r"^Proposed\b", re.IGNORECASE)


def slicing_section(text: str) -> str:
    """The brief's §8 Proposed Feature Slicing body (elicitation §4)."""
    parts = re.split(r"^##\s+", text, flags=re.M)
    for chunk in parts[1:]:
        head, _, rest = chunk.partition("\n")
        if re.match(r"\s*8\.\s", head) or "feature slicing" in head.lower():
            return rest
    return ""


def check_xa05(brief_path: Path, feature: str, epic: str):
    a = "CC-XA-05"
    if not brief_path.is_file():
        return fail(a, ["brief"], [Finding(
            element=str(brief_path),
            problem="the parent epic scope brief does not exist at its path",
            fix=("run the Tier-1 scoping interview for %s, or waive CC-XA-05 "
                 "with the urgent-feature risk on the record"
                 % (epic or "the parent epic")),
        )])

    text = brief_path.read_text(encoding="utf-8")
    body = slicing_section(text)
    if not body.strip():
        return fail(a, ["brief"], [Finding(
            element="%s §8 Proposed Feature Slicing" % (epic or brief_path.stem),
            problem="the slicing section is absent or empty",
            fix="complete the brief's §8 slicing table before delivery-loop entry",
            location=str(brief_path))])

    rows = [c for c in table_rows(body) if any(x.strip() for x in c)]
    match = None
    for cells in rows:
        if feature and feature in cells[0]:
            match = cells
            break

    if match is None:
        return fail(a, ["brief"], [Finding(
            element=feature,
            problem="does not appear in the epic's §8 feature slicing",
            fix=("add the slice to the brief's §8 table, or waive CC-XA-05 with "
                 "the urgent-feature risk on the record"),
            location=str(brief_path))])

    status = match[-1].strip() if len(match) >= 2 else ""
    if CONFIRMED_RE.match(status):
        return ok(a, ["brief"], 'slicing row found, status "%s"' % status)

    if PROPOSED_RE.match(status):
        return fail(a, ["brief"], [Finding(
            element=feature,
            problem=('slicing row status is "%s" — the delivery-loop-entry '
                     'confirmation is missing' % status),
            fix=("confirm the slicing row at delivery-loop entry "
                 "(/ba-enter-feature) — Status: Confirmed — <date>"),
            location=str(brief_path))])

    return fail(a, ["brief"], [Finding(
        element=feature,
        problem=('slicing row carries no recognised status ("%s")' % status),
        fix="set the Status cell to Proposed or Confirmed — <date> (D5)",
        location=str(brief_path))])


def main(argv=None) -> int:
    p = base_parser("CC-XA-05 — brief exists + slicing-row lookup")
    p.add_argument("--brief", help="explicit path to the parent epic scope brief")
    p.add_argument("--epic", default="", help="parent epic id, e.g. E-03")
    args = p.parse_args(argv)

    if not args.feature and not args.brief:
        runtime_defect("need --feature (and --epic or --brief)")

    if args.brief:
        brief = Path(args.brief)
    elif args.epic:
        brief = Path(args.root) / ".specify" / "memory" / "scope" / (
            "%s.md" % args.epic)
    else:
        runtime_defect("need --epic or --brief to locate the parent brief")

    epic = args.epic or brief.stem
    return emit("sk_brief", [check_xa05(brief, args.feature or "", epic)],
                args.format)


if __name__ == "__main__":
    raise SystemExit(main())
