#!/usr/bin/env python3
"""sk_health — CC-H-02 · CC-H-03 · CC-H-06 (contract §6, the M third of Scope H).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §6 · gate definition §10 (Scope-H runtime, the
scoped-run map) · catalogue b6 D-B6-2 (the roadmap's row and log grammar) ·
D-B6-3 (the status vocabulary) · catalogue b5 T-15 §5 (the constitution's
`## Governance references` table — CC-H-06's checked set verbatim) ·
elicitation §4 (the brief's §8).

  CC-H-02  roadmap discipline: every epic carries a status; every re-allocation
           entry logs a diff and a reason.
  CC-H-03  every epic entering Band 3 has a scope brief containing a proposed
           feature slicing.
  CC-H-06  every governance file the constitution references exists and is
           stub-free.

CC-H-03's "entering Band 3" resolves through D-B6-3's status vocabulary: an
epic is in or past Band 3 exactly when its status is `In delivery` (its first
feature entered Band 3, at P-O8) or `Delivered`. `Defined` epics have not
entered; `Retired — <reason>` rows have left scope. No status mirror of the
brief exists by design (D-B6-3), so the join is read directly.

Scope H is project-level: this script takes `--root` and never a feature.

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
    Finding, base_parser, emit, fail, is_stub, memory, ok, runtime_defect,
    table_rows,
)

STATUS_VOCAB = ("Defined", "In delivery", "Delivered")
RETIRED_RE = re.compile(r"^Retired\s*[—–-]\s*\S", re.IGNORECASE)
BAND3_STATUSES = ("in delivery", "delivered")
EPIC_ID_RE = re.compile(r"^(E-\d+)")
ALLOC_HEAD_RE = re.compile(r"^###\s+Allocation\s+(?P<n>\S+)\s*[—–-]\s*(?P<rest>.*)$")
NO_CHANGE_RE = re.compile(r"^\s*no change\s*[—–-]\s*(?P<reason>\S.*)$",
                          re.IGNORECASE)


def _section(text: str, title_test):
    parts = re.split(r"^##\s+", text, flags=re.M)
    for chunk in parts[1:]:
        head, _, rest = chunk.partition("\n")
        if title_test(head.strip()):
            return rest
    return ""


def epic_rows(roadmap_text: str):
    body = _section(roadmap_text, lambda h: h.lower().startswith("epics"))
    rows = []
    for cells in table_rows(body or roadmap_text):
        if not cells:
            continue
        m = EPIC_ID_RE.match(cells[0].strip().strip("`"))
        if m:
            rows.append((m.group(1), cells))
    return rows


def allocation_entries(roadmap_text: str):
    body = _section(roadmap_text, lambda h: h.lower().startswith("allocation log"))
    if not body:
        return []
    entries = []
    current = None
    for line in body.splitlines():
        m = ALLOC_HEAD_RE.match(line.strip())
        if m:
            current = {"n": m.group("n"), "head": line.strip(), "lines": []}
            entries.append(current)
            continue
        if current is not None:
            current["lines"].append(line)
    return entries


# ── CC-H-02 ───────────────────────────────────────────────────────────────────


def check_h02(roadmap_path: Path):
    a = "CC-H-02"
    if not roadmap_path.is_file():
        return fail(a, ["roadmap"], [Finding(
            element=str(roadmap_path),
            problem="the roadmap does not exist",
            fix="run epics decomposition (T-17) to birth the roadmap")])

    text = roadmap_path.read_text(encoding="utf-8")
    findings = []

    rows = epic_rows(text)
    if not rows:
        findings.append(Finding(
            element="## Epics",
            problem="no epic rows",
            fix="run epics decomposition (T-17)", location=str(roadmap_path)))

    for eid, cells in rows:
        status = cells[4].strip() if len(cells) > 4 else ""
        if not status:
            findings.append(Finding(
                element=eid, problem="no status",
                fix="give the row a status: Defined · In delivery · Delivered · "
                    "Retired — <reason>",
                location=str(roadmap_path)))
        elif status not in STATUS_VOCAB and not RETIRED_RE.match(status):
            findings.append(Finding(
                element=eid,
                problem='status "%s" is outside the vocabulary' % status,
                fix="use Defined · In delivery · Delivered · Retired — <reason>",
                location=str(roadmap_path)))

    entries = allocation_entries(text)
    if not entries:
        findings.append(Finding(
            element="## Allocation log",
            problem="no allocation entries",
            fix="run scope allocation (T-18); every approved run logs, "
                "including no-change",
            location=str(roadmap_path)))

    for e in entries:
        joined = "\n".join(e["lines"])
        if any(NO_CHANGE_RE.match(ln) for ln in e["lines"]):
            continue
        diff_rows = [c for c in table_rows(joined) if any(x.strip() for x in c)]
        if not diff_rows:
            findings.append(Finding(
                element="Allocation %s" % e["n"],
                problem="entry logs no diff",
                fix="record the changed rows as <from> → <to>, or "
                    "`no change — <reason>`",
                location=str(roadmap_path)))
            continue
        for cells in diff_rows:
            epic_cell = cells[0].strip()
            phase_cell = cells[1].strip() if len(cells) > 1 else ""
            reason_cell = cells[2].strip() if len(cells) > 2 else ""
            if not re.search(r"[—–>-]{1,2}>|→", phase_cell):
                findings.append(Finding(
                    element="Allocation %s · %s" % (e["n"], epic_cell),
                    problem='phase cell "%s" is not a <from> → <to> diff'
                            % phase_cell,
                    fix="record the change as <from> → <to>",
                    location=str(roadmap_path)))
            if not reason_cell:
                findings.append(Finding(
                    element="Allocation %s · %s" % (e["n"], epic_cell),
                    problem="no reason logged for the re-allocation",
                    fix="give the change a factor-tagged reason",
                    location=str(roadmap_path)))

    if findings:
        return fail(a, ["roadmap"], findings)
    return ok(a, ["roadmap"],
              "%d epic row(s) all carry a status; %d allocation entr(y|ies) all "
              "log a diff and a reason" % (len(rows), len(entries)))


# ── CC-H-03 ───────────────────────────────────────────────────────────────────


def check_h03(roadmap_path: Path, scope_dir: Path):
    a = "CC-H-03"
    if not roadmap_path.is_file():
        return fail(a, ["brief", "roadmap"], [Finding(
            element=str(roadmap_path),
            problem="the roadmap does not exist, so no epic's band state is known",
            fix="run epics decomposition (T-17)")])

    text = roadmap_path.read_text(encoding="utf-8")
    findings = []
    checked = 0
    for eid, cells in epic_rows(text):
        status = (cells[4].strip() if len(cells) > 4 else "").lower()
        if status not in BAND3_STATUSES:
            continue
        checked += 1
        brief = scope_dir / ("%s.md" % eid)
        if not brief.is_file():
            findings.append(Finding(
                element=eid,
                problem="epic is in Band 3 with no scope brief at %s"
                        % brief,
                fix="run the Tier-1 scoping interview for the epic",
                location=str(roadmap_path)))
            continue
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        from sk_brief import slicing_section  # noqa: E402
        body = slicing_section(brief.read_text(encoding="utf-8"))
        rows = [c for c in table_rows(body) if any(x.strip() for x in c)]
        if not rows:
            findings.append(Finding(
                element=eid,
                problem="scope brief carries no proposed feature slicing",
                fix="complete the brief's §8 slicing table",
                location=str(brief)))

    if findings:
        return fail(a, ["brief", "roadmap"], findings)
    return ok(a, ["brief", "roadmap"],
              "%d Band-3 epic(s), each with a brief carrying a slicing table"
              % checked)


# ── CC-H-06 ───────────────────────────────────────────────────────────────────


def governance_references(constitution_text: str):
    body = _section(constitution_text,
                    lambda h: h.lower().startswith("governance references"))
    out = []
    for cells in table_rows(body):
        if not cells or not cells[0].strip():
            continue
        p = cells[0].strip().strip("`").strip()
        if p:
            out.append(p)
    return out


def check_h06(root, constitution_path: Path):
    a = "CC-H-06"
    if not constitution_path.is_file():
        return fail(a, ["gov"], [Finding(
            element=str(constitution_path),
            problem="the constitution does not exist",
            fix="run the constitution technique (T-15)")])

    text = constitution_path.read_text(encoding="utf-8")
    refs = governance_references(text)
    if not refs:
        return fail(a, ["gov"], [Finding(
            element="## Governance references",
            problem="the reference spine is absent or empty",
            fix="list the Governance-class files this constitution binds",
            location=str(constitution_path))])

    findings = []
    for ref in refs:
        target = Path(root) / ref
        if not target.is_file():
            findings.append(Finding(
                element=ref,
                problem="referenced by the constitution but the file does not exist",
                fix="create the governance file, or drop the reference",
                location=str(constitution_path)))
            continue
        if is_stub(target.read_text(encoding="utf-8")):
            findings.append(Finding(
                element=ref,
                problem="referenced by the constitution but the file is a stub",
                fix="fill it with substantive content, or drop the reference",
                location=str(target)))

    if findings:
        return fail(a, ["gov"], findings)
    return ok(a, ["gov"], "%d referenced governance file(s), all present and "
              "stub-free" % len(refs))


def main(argv=None) -> int:
    p = base_parser("CC-H-02 · CC-H-03 · CC-H-06 (contract §6)")
    p.add_argument("--roadmap", help="path to roadmap.md")
    p.add_argument("--constitution", help="path to constitution.md")
    p.add_argument("--scope-dir", help="path to memory/scope/")
    args = p.parse_args(argv)

    roadmap = Path(args.roadmap) if args.roadmap else memory(args.root,
                                                             "roadmap.md")
    constitution = Path(args.constitution) if args.constitution else memory(
        args.root, "constitution.md")
    scope_dir = Path(args.scope_dir) if args.scope_dir else memory(args.root,
                                                                   "scope")

    verdicts = [check_h02(roadmap), check_h03(roadmap, scope_dir),
                check_h06(args.root, constitution)]
    return emit("sk_health", verdicts, args.format)


if __name__ == "__main__":
    raise SystemExit(main())
