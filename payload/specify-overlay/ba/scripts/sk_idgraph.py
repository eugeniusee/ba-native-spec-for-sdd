#!/usr/bin/env python3
"""sk_idgraph — traceability graph · CC-TR-01…03 · traceability.md · CC-TR-04.

BA-Native Spec · vendored M checker + generator (build plan §2.4).
Anchors: completeness contract §5 C11 · gate definition §8 (generation
mechanics, the file shape, the handle grammar) · §4.2 (the graph is built in
Stage 2, before CC-TR-01…04) · writing standard §12–§13.

  CC-TR-01  every US has ≥ 1 FR and ≥ 1 acceptance item; every FR maps to an
            existing US; zero orphans in either direction.   [non-waivable]
  CC-TR-02  References lists roles-permissions.md, glossary.md,
            domain-model.md and the parent epic scope brief with resolvable
            paths; all four exist.
  CC-TR-03  roles declared in References equal the roles used in the body.
  CC-TR-04  the generated traceability.md covers every FR-ID with its source
            chain: its US, ≥ 1 acceptance handle, and the brief link.

**Generated, never hand-authored** (CC-TR-04). This script emits the candidate;
the gate evaluates CC-TR-04 against it and commits it at Stage 5 on an effective
PASS only (gate §8 step 6). `--out` writes the candidate where the caller says;
without `--out` nothing touches the disk and CC-TR-04 is still evaluated.

Acceptance handles are generated positional handles, stable only within a
snapshot (gate §8 step 1): `US<n>/AC-<i>` for checklist lines,
`US<n>/S-"<name>"` for scenarios. The writing standard defines no AC IDs.

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
    BR_REF_RE, Finding, base_parser, emit, fail, load_spec, memory, ok,
    runtime_defect, table_rows,
)

REQUIRED_REFS = [
    ("roles-permissions.md", "roles-permissions.md"),
    ("glossary.md", "glossary.md"),
    ("domain-model.md", "domain-model.md"),
    ("parent epic scope brief", "scope/"),
]

PATH_RE = re.compile(r"(?<![\w/.])((?:\.?[\w.-]+/)*[\w.-]+\.md)")
ROLES_DECL_RE = re.compile(r"roles?\s+used\s*:\s*(?P<list>[^)]*)", re.IGNORECASE)


# ── the graph ─────────────────────────────────────────────────────────────────


def build_graph(spec, brief_link: str):
    """FR ⇄ US ⇄ acceptance, plus BR refs and the brief link (gate §8 step 1–2)."""
    stories = {s.id: s for s in spec.stories}
    rows = []
    for r in spec.requirements:
        us = [u for u in r.us_refs]
        handles = []
        for u in us:
            st = stories.get(u)
            if st:
                handles.extend(a.handle for a in st.acceptance)
        rows.append({
            "fr": r.id,
            "us": us,
            "acceptance": handles,
            "br": sorted(set(BR_REF_RE.findall(r.raw))),
            "brief": brief_link,
        })
    reverse = {}
    for row in rows:
        for u in row["us"]:
            reverse.setdefault(u, []).append(row["fr"])
    return rows, reverse


def brief_link_for(brief_path: Path, feature: str) -> str:
    """`<E-nn> §8 / <F-id>` — the parent brief's §8 slicing row (gate §8 step 2)."""
    if not brief_path or not Path(brief_path).is_file():
        return ""
    text = Path(brief_path).read_text(encoding="utf-8")
    epic = ""
    m = re.search(r"\((E-\d+)\)", text)
    if m:
        epic = m.group(1)
    if not epic:
        m = re.match(r"(E-\d+)", Path(brief_path).stem)
        epic = m.group(1) if m else Path(brief_path).stem
    slug = (feature or "").strip()
    for cells in table_rows(text):
        if not cells:
            continue
        cell = cells[0]
        if slug and slug in cell:
            fm = re.match(r"\s*(F\d+)\b", cell)
            return "%s §8 / %s" % (epic, fm.group(1) if fm else cell.strip())
    return "%s §8" % epic if epic else ""


# ── CC-TR-01 ──────────────────────────────────────────────────────────────────


def check_tr01(spec):
    a = "CC-TR-01"
    findings = []
    story_ids = [s.id for s in spec.stories]
    referenced = {}
    for r in spec.requirements:
        for u in r.us_refs:
            referenced.setdefault(u, []).append(r.id)

    for s in spec.stories:
        if s.id not in referenced:
            findings.append(Finding(
                element=s.id,
                problem="zero FRs reference it (story is unbuilt)",
                fix="author its FRs or drop/demote the story.",
                location="%s:%d" % (spec.path.name, s.lineno)))
        if not s.acceptance:
            findings.append(Finding(
                element=s.id,
                problem="zero acceptance items",
                fix="add at least one acceptance item directly beneath it",
                location="%s:%d" % (spec.path.name, s.lineno)))

    for r in spec.requirements:
        if not r.us_refs:
            findings.append(Finding(
                element=r.id,
                problem="maps to no story (orphan requirement)",
                fix="tag it FR-0NN (US<n>), or delete it as scope creep",
                location="%s:%d" % (spec.path.name, r.lineno)))
            continue
        for u in r.us_refs:
            if u not in story_ids:
                findings.append(Finding(
                    element=r.id,
                    problem="maps to %s, which does not exist" % u,
                    fix="point it at an existing story, or author that story",
                    location="%s:%d" % (spec.path.name, r.lineno)))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d stories, %d FRs — zero orphans in either direction"
              % (len(spec.stories), len(spec.requirements)))


# ── CC-TR-02 ──────────────────────────────────────────────────────────────────


def declared_paths(spec):
    sec = spec.section("References")
    if sec is None:
        return None, []
    paths = []
    for lineno, text in sec.lines:
        if spec.fenced[lineno - 1] or text.strip().startswith("<!--"):
            continue
        for m in PATH_RE.finditer(text):
            paths.append((m.group(1), lineno))
    return sec, paths


def check_tr02(spec, root):
    a = "CC-TR-02"
    sec, paths = declared_paths(spec)
    if sec is None:
        return fail(a, ["spec", "mem"], [Finding(
            element="§10 References",
            problem="section absent",
            fix="add References listing the four upstream artifacts")])

    findings = []
    for label, needle in REQUIRED_REFS:
        hit = next((p for p, _ in paths if needle in p), None)
        if hit is None:
            findings.append(Finding(
                element=label,
                problem="not listed in References",
                fix="add the reference with its resolvable path",
                location="%s:%d" % (spec.path.name, sec.heading_line)))
            continue
        target = (Path(root) / hit).resolve()
        if not target.is_file():
            findings.append(Finding(
                element=label,
                problem='path "%s" does not resolve to an existing file' % hit,
                fix="correct the path, or create the artifact upstream first",
                location="%s:%d" % (spec.path.name, sec.heading_line)))

    if findings:
        return fail(a, ["spec", "mem"], findings)
    return ok(a, ["spec", "mem"], "4/4 required references listed and resolving")


# ── CC-TR-03 ──────────────────────────────────────────────────────────────────


def check_tr03(spec, roles_path):
    a = "CC-TR-03"
    sec = spec.section("References")
    if sec is None:
        return fail(a, ["spec"], [Finding(
            element="§10 References", problem="section absent",
            fix="add References declaring the roles this spec uses")])

    declared = []
    for _, text in sec.lines:
        m = ROLES_DECL_RE.search(text)
        if m:
            declared = [r.strip() for r in re.split(r"[,·]", m.group("list"))
                        if r.strip()]
            break

    if not Path(roles_path).is_file():
        runtime_defect("roles-permissions.md not found at %s" % roles_path)
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    from sk_stories import defined_roles  # noqa: E402
    registry = defined_roles(Path(roles_path))

    body = "\n".join(
        t for s in spec.sections if s.name != "References" for _, t in s.lines
    )
    used = [r for r in registry if re.search(r"\b%s\b" % re.escape(r), body)]

    findings = []
    for r in sorted(set(declared) - set(used)):
        findings.append(Finding(
            element=r,
            problem="declared in References but not used in the spec body",
            fix="remove the declaration, or use the role where it belongs",
            location="%s:%d" % (spec.path.name, sec.heading_line)))
    for r in sorted(set(used) - set(declared)):
        findings.append(Finding(
            element=r,
            problem="used in the spec body but not declared in References",
            fix="add it to the roles-used declaration in References",
            location="%s:%d" % (spec.path.name, sec.heading_line)))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d role(s) declared = %d used" % (len(declared),
                                                             len(used)))


# ── traceability.md generation + CC-TR-04 ─────────────────────────────────────


def render(feature, rows, reverse, run, rev, date, provenance, cycle,
           orphan_line):
    out = []
    out.append("# Traceability — %s" % feature)
    out.append("GENERATED at gate run %s · spec %s · %s · do not edit"
               % (run, rev, date))
    out.append("Provenance: %s · delivery cycle %s" % (provenance, cycle))
    out.append("")
    out.append("| FR | Story | Acceptance | BR refs | Brief link |")
    out.append("|---|---|---|---|---|")
    for r in rows:
        out.append("| %s | %s | %s | %s | %s |" % (
            r["fr"],
            " · ".join(r["us"]) or "—",
            " · ".join(r["acceptance"]) or "—",
            " · ".join(r["br"]) or "—",
            r["brief"] or "—",
        ))
    out.append("")
    rev_parts = ["%s → %s" % (u, ", ".join(frs))
                 for u, frs in sorted(reverse.items(),
                                      key=lambda kv: _uskey(kv[0]))]
    out.append("Reverse index: %s" % (" · ".join(rev_parts) or "—"))
    out.append("Orphan check: %s" % orphan_line)
    out.append("")
    return "\n".join(out)


def _uskey(us):
    m = re.search(r"\d+", us)
    return int(m.group(0)) if m else 0


def check_tr04(rows, feature, out_path):
    a = "CC-TR-04"
    if not rows:
        return fail(a, ["trace"], [Finding(
            element="traceability.md",
            problem="no FR rows to generate — the graph is empty",
            fix="author the FRs; the file is generated, never hand-authored")])

    findings = []
    for r in rows:
        missing = []
        if not r["us"]:
            missing.append("its US")
        if not r["acceptance"]:
            missing.append("an acceptance handle")
        if not r["brief"]:
            missing.append("the brief link")
        if missing:
            findings.append(Finding(
                element=r["fr"],
                problem="row is missing %s" % " and ".join(missing),
                fix=("close the underlying chain — the file is generated at "
                     "gate time and cannot be hand-completed"),
                location=str(out_path) if out_path else "candidate"))

    if findings:
        return fail(a, ["trace"], findings)
    return ok(a, ["trace"], "%d/%d FR rows carry US + acceptance + brief link"
              % (len(rows), len(rows)))


def main(argv=None) -> int:
    p = base_parser("CC-TR-01…04 + traceability.md generation")
    p.add_argument("--roles", help="path to roles-permissions.md")
    p.add_argument("--brief", help="parent epic scope brief")
    p.add_argument("--out", help="write the generated candidate here")
    p.add_argument("--print-candidate", action="store_true")
    p.add_argument("--run", default="1", help="gate run number, for the banner")
    p.add_argument("--rev", default="r1", help="spec revision, for the banner")
    p.add_argument("--date", default="", help="run date, for the banner")
    p.add_argument("--cycle", default="", help="delivery cycle, for the banner")
    p.add_argument("--provenance", default="Tier-2 spec-depth gap-filling")
    args = p.parse_args(argv)

    spec_path, spec = load_spec(args)
    feature = args.feature or spec_path.parent.name
    roles_path = Path(args.roles) if args.roles else memory(args.root,
                                                            "roles-permissions.md")

    brief = Path(args.brief) if args.brief else None
    if brief is None:
        _, paths = declared_paths(spec)
        hit = next((pp for pp, _ in paths if "scope/" in pp), None)
        if hit:
            brief = Path(args.root) / hit
    link = brief_link_for(brief, feature) if brief else ""

    rows, reverse = build_graph(spec, link)

    v_tr01 = check_tr01(spec)
    orphan = ("none (CC-TR-01 PASS, run %s)" % args.run
              if v_tr01.verdict == "PASS"
              else " · ".join(f.gap_line("CC-TR-01") for f in v_tr01.findings))

    date = args.date or "—"
    cycle = args.cycle or (date[:7] if re.match(r"\d{4}-\d{2}", date) else "—")
    candidate = render(feature, rows, reverse, args.run, args.rev, date,
                       args.provenance, cycle, orphan)

    if args.out:
        Path(args.out).parent.mkdir(parents=True, exist_ok=True)
        Path(args.out).write_text(candidate, encoding="utf-8")
    if args.print_candidate:
        sys.stdout.write(candidate)
        if args.format == "text":
            sys.stdout.write("\n")

    verdicts = [
        v_tr01,
        check_tr02(spec, args.root),
        check_tr03(spec, roles_path),
        check_tr04(rows, feature, args.out),
    ]
    return emit("sk_idgraph", verdicts, args.format)


if __name__ == "__main__":
    raise SystemExit(main())
