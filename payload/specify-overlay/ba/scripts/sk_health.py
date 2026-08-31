#!/usr/bin/env python3
"""sk_health — CC-H-02 · CC-H-03 · CC-H-06 · CC-H-08 (contract §6, the M third
of Scope H).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §6 · gate definition §10 (Scope-H runtime, the
scoped-run map, and CC-H-08's classing) · catalogue b6 D-B6-2 (the roadmap's
row and log grammar) · D-B6-3 (the status vocabulary) · catalogue b5 T-15 §5
(the constitution's `## Governance references` table — CC-H-06's checked set
verbatim) · elicitation §4 (the brief's §8) · orchestrator D-O67 (the Billable
test) · D-O100 (one computation, four display sites).

  CC-H-02  roadmap discipline: every epic carries a status; every re-allocation
           entry logs a diff and a reason.
  CC-H-03  every epic entering Band 3 has a scope brief containing a proposed
           feature slicing.
  CC-H-06  every governance file the constitution references exists and is
           stub-free.
  CC-H-08  boundary coverage: every roadmap epic allocated to a phase inside
           the ledger head's `Boundary:` set has a scope brief.

CC-H-03's "entering Band 3" resolves through D-B6-3's status vocabulary: an
epic is in or past Band 3 exactly when its status is `In delivery` (its first
feature entered Band 3, at P-O8) or `Delivered`. `Defined` epics have not
entered; `Retired — <reason>` rows have left scope. No status mirror of the
brief exists by design (D-B6-3), so the join is read directly.

CC-H-08 asks a different question at a different moment, and the two rows are
disjoint by ruling: CC-H-03 conditions on *entering Band 3*, so an epic that
never enters is invisible to it — which is exactly how two in-boundary epics
went unbriefed for three days under a green health run (EC-22). CC-H-08 is
conditioned on the **boundary**, so it sees them.

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

# CC-H-08's three grounds are already read elsewhere, and are imported rather
# than restated: `read_frame` is the ledger head's `Boundary:` line (§2.4),
# `read_roadmap_at` the header-resolved epic roster, and `billable_cell` the
# Billable test itself — the row's Phase (a Deferred row: its target phase)
# tested against the boundary set (§10.5, D-O67). D-O100 puts one computation
# behind four display sites; a second copy of any of the three would be a
# second thing to drift.
from sk_wbs import billable_cell, read_frame, read_roadmap_at  # noqa: E402

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


ALLOC_SHAPE = "### Allocation <n> — <date> · trigger: <…> · BA: <name>"


def allocation_near_misses(roadmap_text: str):
    """`###` lines under the log that miss the heading grammar, classed.

    A near-miss reaches the log's own ground and fails its shape (gate §10.4;
    orchestrator D-O58). Its class is keyed on **supersession, in log order**:
    LIVE while no well-formed entry follows it, SETTLED once one does. No
    well-formed entry anywhere is the live case, which falls out of the walk
    rather than being special-cased.
    """
    body = _section(roadmap_text, lambda h: h.lower().startswith("allocation log"))
    if not body:
        return []
    seq = []
    for line in body.splitlines():
        head = line.strip()
        if not head.startswith("###"):
            continue
        m = ALLOC_HEAD_RE.match(head)
        seq.append(("ok", m.group("n")) if m else ("miss", head))
    out = []
    for i, (kind, value) in enumerate(seq):
        if kind != "miss":
            continue
        following = next((v for k, v in seq[i + 1:] if k == "ok"), "")
        out.append({"line": value, "superseded_by": following})
    return out


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
    near = allocation_near_misses(text)
    notes = []
    for nm in near:
        if nm["superseded_by"]:
            # Settled: named, never silenced — and never a gap. The malformed
            # line stays on the record because the log is append-only, so a
            # reader that met it and said nothing would be the original defect
            # wearing a green verdict.
            notes.append(
                '%s — heading "%s" does not parse, expected `%s`; '
                "superseded-by Allocation %s (settled — named, not a gap)"
                % (roadmap_path, nm["line"], ALLOC_SHAPE, nm["superseded_by"]))
        else:
            findings.append(Finding(
                element="## Allocation log",
                problem='heading "%s" does not parse as an allocation entry'
                        % nm["line"],
                fix="supersede it with a correctly-shaped entry — `%s`; the "
                    "log is append-only and is never edited" % ALLOC_SHAPE,
                location=str(roadmap_path)))
    if not entries and not near:
        # Only a log with nothing in it at all sends the BA to T-18. Where
        # `###` lines are present and unparsed, the near-miss findings above
        # are the true report, and "no allocation entries" would aim the fix
        # at whoever would create the log instead of at the line (D-O58).
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
        return fail(a, ["roadmap"], findings, notes=notes)
    return ok(a, ["roadmap"],
              "%d epic row(s) all carry a status; %d allocation entr(y|ies) all "
              "log a diff and a reason" % (len(rows), len(entries)),
              notes=notes)


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


# ── CC-H-08 ───────────────────────────────────────────────────────────────────


def boundary_coverage(roadmap_path: Path, scope_dir: Path, root):
    """The boundary-coverage set — one computation, four display sites (D-O100).

    Returns `(in_boundary, uncovered)`:

      * **in_boundary** — `[(eid, name, phase)]`, every roadmap epic whose
        Phase falls inside the ledger head's `Boundary:` set. The membership
        test is `billable_cell` itself, imported from the export: the set is
        exactly the rows the WBS bills, by construction rather than by a
        second reading of the same rule (§10.5's own Billable test, D-O67).
        A **blank Phase** sits outside the set exactly as its Billable cell
        sits blank — an absent source is never a guess.
      * **uncovered** — the subset with no `<E-nn>.md` in the brief folder.
        **Existence, not content:** whether the brief carries a confirmed
        slicing is CC-H-03's question, at CC-H-03's moment.

    `in_boundary` is **None** where the check is **vacuous** — no roadmap
    stands, or no boundary stands in the frame. Vacuous is *never a gap*: the
    pre-decomposition and boundary-less states render `—`, the absent-source
    law (D-O67 · D-O71), and the four display sites print that dash rather
    than a ratio they have no ground for.

    The gate computes and rules here; the renders read. `/ba-status`'s line-2
    continuation, the band-boundary report's `Scope coverage:` line,
    `/ba-run specs`' confirmation table and `/ba-wbs`'s generation summary all
    call this function, so no two of them can ever disagree.
    """
    _, boundary, _ = read_frame(Path(root))
    if not boundary or not roadmap_path.is_file():
        return None, []

    order, names, phases = read_roadmap_at(roadmap_path)
    in_boundary, uncovered = [], []
    for eid in order:
        phase = phases.get(eid, "")
        if billable_cell(phase, boundary) != "Yes":
            continue
        row = (eid, names.get(eid, ""), phase)
        in_boundary.append(row)
        if not (Path(scope_dir) / ("%s.md" % eid)).is_file():
            uncovered.append(row)
    return in_boundary, uncovered


def check_h08(roadmap_path: Path, scope_dir: Path, root):
    a = "CC-H-08"
    checks = ["brief", "roadmap", "ledger head"]
    in_boundary, uncovered = boundary_coverage(roadmap_path, scope_dir, root)

    # Vacuous, never a gap. The verdict is a PASS by construction, and its
    # evidence says which source is absent — the dash the renders print,
    # said in the gate's own grammar.
    if in_boundary is None:
        return ok(a, checks, "— no roadmap or no boundary in the frame: "
                             "the check is vacuous, never a gap")
    if not in_boundary:
        return ok(a, checks, "— no roadmap row falls inside the boundary: "
                             "a zero denominator renders the dash, never 0%")

    if uncovered:
        # Element grain is the epic, named with its phase and its Billable
        # value — a count without names is indistinguishable from ordinary
        # later-phase deferral, which is the blind spot this row exists to
        # close (D-O58 met at a join, EC-22). The phase is the ladder value
        # **verbatim**, the WBS Phase column's own rule (D-O67): the pinned
        # line reads `E-10 … — Phase 2 · Billable Yes` because the roadmap
        # cell reads `Phase 2`, and a value of `MVP` renders `MVP`.
        return fail(a, checks, [Finding(
            element="%s %s — %s · Billable Yes" % (eid, name, phase),
            problem="no scope brief",
            fix="run Tier 1 — epic scoping in ingest mode over the captured "
                "material for the epic",
            location=str(Path(scope_dir) / ("%s.md" % eid)))
            for eid, name, phase in uncovered])

    return ok(a, checks, "%d in-boundary epic(s), each with a scope brief"
              % len(in_boundary))

def main(argv=None) -> int:
    p = base_parser("CC-H-02 · CC-H-03 · CC-H-06 · CC-H-08 (contract §6)")
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
                check_h06(args.root, constitution),
                check_h08(roadmap, scope_dir, args.root)]
    return emit("sk_health", verdicts, args.format)


if __name__ == "__main__":
    raise SystemExit(main())
