#!/usr/bin/env python3
"""sk_snapshot — snapshot manifest · live diff · re-run set · anchor diffing.

BA-Native Spec · vendored runtime script (build plan §2.4).
Anchors: gate definition §3 (the snapshot and what a run binds to) · §7.2 /
§7.3 (waiver void-on-edit, override persistence — both anchor diffs) · §9.2
(the incremental re-gate's re-run set and its read-scope table) · §11.1 (the
certification manifest the adapter later verifies) · §14.2 (the worked
composition this implementation reproduces).

Not an assertion checker: this is the machinery every checker reads *through*.
Every checker reads the snapshot, never the live files (gate §3), so a run
builds a workspace here and points the checkers at it with `--root`.

Subcommands
-----------
    build          assemble deps(F), hash it, write the manifest (+ workspace)
    verify         manifest vs. the live files — the adapter's hash guard
    rerun-set      the §9.2 incremental composition: re-run vs. carried
    anchor-diff    is a waiver/override anchor clean between two manifests?
    certification  render the §11.1 certification block from a manifest

The assertion table below carries **IDs and classes only** — no assertion text.
The layering rule (contract §2) keeps the chain one-way: script → CC-ID →
contract line → BABOK anchor.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
from pathlib import Path

# No bytecode: these scripts import one another (sk_structure is the shared
# parse surface), and a __pycache__ directory inside the installed
# `.specify/ba/scripts/` would join the install manifest's hash list and
# make it rot on first use.
sys.dont_write_bytecode = True


sys.path.insert(0, str(Path(__file__).resolve().parent))

from sk_structure import parse_spec, runtime_defect  # noqa: E402

# ── the assertion table — IDs + class + category only (contract §4–§6) ────────

ASSERTIONS = [
    ("CC-G-01", "G", "M"), ("CC-G-02", "G", "A"), ("CC-G-03", "G", "M"),
    ("CC-G-04", "G", "M"), ("CC-G-05", "G", "A"), ("CC-G-06", "G", "A"),
    ("CC-OV-01", "OV", "A"), ("CC-OV-02", "OV", "A"),
    ("CC-US-01", "US", "M"), ("CC-US-02", "US", "M"), ("CC-US-03", "US", "M"),
    ("CC-US-04", "US", "M"), ("CC-US-05", "US", "A"),
    ("CC-AC-01", "AC", "M"), ("CC-AC-02", "AC", "A"), ("CC-AC-03", "AC", "A"),
    ("CC-AC-04", "AC", "A"),
    ("CC-FR-01", "FR", "M"), ("CC-FR-02", "FR", "M"), ("CC-FR-03", "FR", "A"),
    ("CC-FR-04", "FR", "A"), ("CC-FR-05", "FR", "M"),
    ("CC-FL-01", "FL", "A"), ("CC-FL-02", "FL", "M"), ("CC-FL-03", "FL", "A"),
    ("CC-FL-04", "FL", "A"), ("CC-FL-05", "FL", "A"),
    ("CC-NF-01", "NF", "A"), ("CC-NF-02", "NF", "M"), ("CC-NF-03", "NF", "A"),
    ("CC-BR-01", "BR", "A"), ("CC-BR-02", "BR", "M"), ("CC-BR-03", "BR", "A"),
    ("CC-DA-01", "DA", "A"), ("CC-DA-02", "DA", "A"), ("CC-DA-03", "DA", "A"),
    ("CC-DA-04", "DA", "A"),
    ("CC-IN-01", "IN", "A"), ("CC-IN-02", "IN", "A"), ("CC-IN-03", "IN", "A"),
    ("CC-OS-01", "OS", "M"), ("CC-OS-02", "OS", "A"), ("CC-OS-03", "OS", "A"),
    ("CC-OS-04", "OS", "A"),
    ("CC-TR-01", "TR", "M"), ("CC-TR-02", "TR", "M"), ("CC-TR-03", "TR", "M"),
    ("CC-TR-04", "TR", "M"),
    ("CC-XA-01", "XA", "A"), ("CC-XA-02", "XA", "M"), ("CC-XA-03", "XA", "A"),
    ("CC-XA-04", "XA", "A"), ("CC-XA-05", "XA", "M"), ("CC-XA-06", "XA", "A"),
    ("CC-XA-07", "XA", "A"),
]

SCOPE_H = [("CC-H-01", "H", "A"), ("CC-H-02", "H", "M"), ("CC-H-03", "H", "M"),
           ("CC-H-04", "H", "A"), ("CC-H-05", "H", "A"), ("CC-H-06", "H", "M")]

# The whole-spec A set, verbatim from gate §14.2's worked composition.
WHOLE_SPEC_A = {"CC-G-02", "CC-G-05", "CC-G-06", "CC-XA-03", "CC-XA-06",
                "CC-XA-07", "CC-OS-04"}

# Read-scope table (gate §9.2) — a compiled view of the contract's Checks
# columns. The authority note applies: a carry basis always resolves to
# contract text, never to this table alone.
READ_SCOPE = {
    "G":  {"spec_sections": "all", "artifacts": []},
    "OV": {"spec_sections": [1], "artifacts": ["canvas", "brief"]},
    "US": {"spec_sections": [2], "artifacts": ["roles", "hist"]},
    "AC": {"spec_sections": [2], "artifacts": []},
    "FR": {"spec_sections": [3], "artifacts": ["hist"]},
    "FL": {"spec_sections": [4, 7], "artifacts": []},
    "NF": {"spec_sections": [5], "artifacts": ["gov"]},
    "BR": {"spec_sections": [6], "artifacts": ["gov"]},
    "DA": {"spec_sections": [7], "artifacts": ["dm"]},
    "IN": {"spec_sections": [8], "artifacts": ["brief"]},
    "OS": {"spec_sections": [9], "artifacts": ["oos"]},
    "TR": {"spec_sections": "all", "artifacts": ["mem", "trace"]},
    "XA": {"spec_sections": "all",
           "artifacts": ["roles", "gloss", "dm", "brief", "mem"]},
}

# A snapshot entry carries every shorthand the contract's Checks columns use
# for it, not just one: `roles-permissions.md` is `roles` AND `gov` (a
# governance file the constitution references) AND `mem` (it lives under
# `.specify/memory/`). A single-label entry would silently carry a
# governance-reading A assertion across a roles edit — gate §14.2 re-runs
# CC-BR-03/CC-NF-03 on exactly that diff.
MEMORY_LABELS = {"roles", "gloss", "dm", "brief", "gov", "oos", "roadmap",
                 "constitution", "mem"}


def sha256(path: Path) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


# ── deps(F) — the static core (gate §3) ───────────────────────────────────────


def constitution_refs(root: Path):
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    from sk_health import governance_references  # noqa: E402
    c = root / ".specify" / "memory" / "constitution.md"
    if not c.is_file():
        return []
    return governance_references(c.read_text(encoding="utf-8"))


def deps(root: Path, feature: str, epic: str, hist):
    """(labels, relative path) for every member of the static core (gate §3)."""
    fdir = "specs/%s" % feature
    core = [
        (["spec"], "%s/spec.md" % fdir),
        (["roles", "mem"], ".specify/memory/roles-permissions.md"),
        (["gloss", "mem"], ".specify/memory/glossary.md"),
        (["dm", "mem"], ".specify/memory/domain-model.md"),
        (["canvas"], "canvas.md"),
        (["constitution", "gov", "mem"], ".specify/memory/constitution.md"),
        (["oos", "mem"], ".specify/memory/out-of-scope.md"),
        (["roadmap", "mem"], ".specify/memory/roadmap.md"),
    ]
    if epic:
        core.insert(4, (["brief", "mem"], ".specify/memory/scope/%s.md" % epic))
    # "constitution.md + every governance file it references" (gate §3): the
    # referenced files gain the `gov` label wherever they already sit.
    refs = {re.sub(r"^\./", "", r.strip()) for r in constitution_refs(root)}
    for labels, path in core:
        if path in refs and "gov" not in labels:
            labels.append("gov")
    known = {p for _, p in core}
    for rel in sorted(refs - known):
        labels = ["gov", "mem"] if rel.startswith(".specify/memory/") else ["gov"]
        core.append((labels, rel))
    if hist:
        core.append((["hist"], hist))
    return core


def cmd_build(args) -> int:
    root = Path(args.root).resolve()
    entries = []
    missing = []
    for labels, rel in deps(root, args.feature, args.epic, args.hist):
        p = (root / rel) if not Path(rel).is_absolute() else Path(rel)
        if not p.is_file():
            missing.append((labels, rel))
            continue
        entries.append({"labels": labels, "path": rel, "sha256": sha256(p)})

    manifest = {
        "feature": args.feature,
        "epic": args.epic,
        "run": args.run,
        "date": args.date,
        "root": str(root),
        "files": entries,
        "missing": [{"labels": l, "path": p} for l, p in missing],
    }

    if args.workspace:
        ws = Path(args.workspace)
        if ws.exists():
            shutil.rmtree(ws)
        for e in entries:
            dst = ws / e["path"]
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(root / e["path"], dst)
        manifest["workspace"] = str(ws)

    out = json.dumps(manifest, indent=2, ensure_ascii=False)
    if args.out:
        Path(args.out).parent.mkdir(parents=True, exist_ok=True)
        Path(args.out).write_text(out + "\n", encoding="utf-8")
    else:
        print(out)

    if missing and args.require_complete:
        for labels, rel in missing:
            print("snapshot: missing %s — %s" % ("/".join(labels), rel),
                  file=sys.stderr)
        return 1
    return 0


# ── verify — the adapter's hash guard (gate §11.1 precondition) ───────────────


def cmd_verify(args) -> int:
    manifest = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    root = Path(args.root).resolve() if args.root != "." else Path(
        manifest.get("root", ".")).resolve()

    diverged = []
    for e in manifest["files"]:
        p = root / e["path"]
        if not p.is_file():
            diverged.append((e["path"], "missing"))
        elif sha256(p) != e["sha256"]:
            diverged.append((e["path"], "content changed"))

    if diverged:
        print("REFUSED — %d certified path(s) diverged from the live files:"
              % len(diverged))
        for path, why in diverged:
            print("  %s — %s" % (path, why))
        print("→ re-gate before handoff; the certified text is the read text.")
        return 1

    print("clean — %d/%d hashes match the live files"
          % (len(manifest["files"]), len(manifest["files"])))
    return 0


# ── rerun-set — the §9.2 incremental composition ──────────────────────────────


def changed_sections(prev_spec: Path, curr_spec: Path):
    """Skeleton § numbers whose bodies differ between two revisions."""
    if not prev_spec or not Path(prev_spec).is_file():
        return "all"
    a = parse_spec(Path(prev_spec))
    b = parse_spec(Path(curr_spec))
    amap = {s.number: s.body for s in a.sections if s.number}
    bmap = {s.number: s.body for s in b.sections if s.number}
    out = []
    for n in sorted(set(amap) | set(bmap)):
        if amap.get(n) != bmap.get(n):
            out.append(n)
    return out


def cmd_rerun_set(args) -> int:
    prev = json.loads(Path(args.prev).read_text(encoding="utf-8"))
    curr = json.loads(Path(args.curr).read_text(encoding="utf-8"))

    prev_h = {e["path"]: e["sha256"] for e in prev["files"]}
    curr_h = {e["path"]: e["sha256"] for e in curr["files"]}
    labels = {e["path"]: e["labels"] for e in curr["files"]}
    labels.update({e["path"]: e["labels"] for e in prev["files"]})

    diff_paths = sorted(
        p for p in set(prev_h) | set(curr_h) if prev_h.get(p) != curr_h.get(p)
    )
    diff_labels = set()
    for p in diff_paths:
        diff_labels.update(labels.get(p, ["?"]))
    spec_edited = "spec" in diff_labels
    mem_edited = bool(diff_labels & MEMORY_LABELS)

    secs = "all"
    if spec_edited and args.prev_spec:
        secs = changed_sections(Path(args.prev_spec), Path(args.curr_spec))
    elif not spec_edited:
        secs = []

    non_clean = {x.strip() for x in (args.non_clean or "").split(",") if x.strip()}

    rerun, carried, basis = [], [], {}
    for aid, cat, chk in ASSERTIONS:
        if chk == "M":
            rerun.append(aid)
            basis[aid] = "all M re-run (graph-integrity backbone)"
            continue
        if aid in non_clean:
            rerun.append(aid)
            basis[aid] = "not clean last run"
            continue
        if spec_edited and aid in WHOLE_SPEC_A:
            rerun.append(aid)
            basis[aid] = "whole-spec A on a spec edit"
            continue
        scope = READ_SCOPE[cat]
        hit = False
        if scope["spec_sections"] == "all":
            hit = spec_edited
        elif secs != "all":
            hit = any(n in secs for n in scope["spec_sections"])
        else:
            hit = spec_edited
        if not hit:
            for art in scope["artifacts"]:
                if art in diff_labels:
                    hit = True
        if hit:
            rerun.append(aid)
            basis[aid] = "read set intersects the diff"
        else:
            carried.append(aid)
            basis[aid] = "read set untouched by the diff"

    result = {
        "diff": diff_paths,
        "changed_spec_sections": secs,
        "rerun": rerun,
        "carried": carried,
        "basis": basis,
        "counts": {"rerun": len(rerun), "carried": len(carried)},
    }

    if args.format == "json":
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        print("diff: %s" % (", ".join(diff_paths) or "none"))
        print("changed spec sections: %s"
              % (secs if secs == "all" else
                 ", ".join("§%d" % n for n in secs) or "none"))
        print("re-run (%d): %s" % (len(rerun), " · ".join(rerun)))
        print("carried (%d): %s" % (len(carried), " · ".join(carried) or "none"))
    return 0


# ── anchor-diff — waiver void-on-edit (§7.2) / override persistence (§7.3) ────


ELEMENT_ID_RE = re.compile(r"\b(US\d+|FR-\d+|BR-\d+|NFR-\d+)\b")
ACCEPTANCE_HINT_RE = re.compile(r"acceptance|scenario|/\s*AC-", re.IGNORECASE)


def element_block(spec_path, element: str):
    """The anchor's own text, at element granularity (gate §7.3).

    Returns None when the element cannot be resolved — the caller then falls
    back to the section granularity of the read-scope table. Element
    granularity is what makes an override's carry legal "while §2 as a whole
    changed" (gate §14.2).
    """
    if not element or not spec_path or not Path(spec_path).is_file():
        return None
    m = ELEMENT_ID_RE.search(element)
    if not m:
        return None
    eid = m.group(1)
    spec = parse_spec(Path(spec_path))

    if eid.startswith("US"):
        story = spec.story(eid)
        if story is None:
            return ""            # the element is gone — that is a change
        acceptance = "\n".join("%s|%s" % (a.kind, a.text) for a in story.acceptance)
        if ACCEPTANCE_HINT_RE.search(element):
            return acceptance
        return story.raw + "\n" + acceptance

    for coll in (spec.requirements, spec.rules, spec.nfrs):
        for item in coll:
            if item.id == eid:
                return item.text
    return ""


def cmd_anchor_diff(args) -> int:
    prev = json.loads(Path(args.prev).read_text(encoding="utf-8"))
    curr = json.loads(Path(args.curr).read_text(encoding="utf-8"))
    prev_h = {e["path"]: e["sha256"] for e in prev["files"]}
    curr_h = {e["path"]: e["sha256"] for e in curr["files"]}
    labels = {e["path"]: e["labels"] for e in curr["files"]}
    labels.update({e["path"]: e["labels"] for e in prev["files"]})

    aid = args.assertion
    cat = next((c for a, c, _ in ASSERTIONS if a == aid), None)
    if cat is None:
        runtime_defect("unknown assertion %s" % aid)
    scope = READ_SCOPE[cat]

    touched = []
    granularity = "section"
    for path in sorted(set(prev_h) | set(curr_h)):
        if prev_h.get(path) == curr_h.get(path):
            continue
        entry_labels = set(labels.get(path, []))
        if "spec" in entry_labels:
            # element granularity first (gate §7.3): an anchor whose own block
            # is byte-identical between snapshots is clean even when the
            # surrounding section changed.
            before = element_block(args.prev_spec, args.element)
            after = element_block(args.curr_spec, args.element)
            if before is not None and after is not None:
                if before != after:
                    touched.append(path)
                granularity = "element"
            elif scope["spec_sections"] == "all":
                touched.append(path)
            elif args.prev_spec and args.curr_spec:
                secs = changed_sections(Path(args.prev_spec),
                                        Path(args.curr_spec))
                if secs == "all" or any(n in secs
                                        for n in scope["spec_sections"]):
                    touched.append(path)
            else:
                touched.append(path)
        elif entry_labels & set(scope["artifacts"]):
            touched.append(path)

    clean = not touched
    kind = args.kind
    if args.format == "json":
        print(json.dumps({"assertion": aid, "element": args.element,
                          "kind": kind, "clean": clean, "touched": touched,
                          "granularity": granularity},
                         indent=2, ensure_ascii=False))
    else:
        if clean:
            verb = ("W-anchor clean — waiver survives to P5 re-affirmation"
                    if kind == "waiver" else
                    "O-anchor clean — override auto re-applies, checker not run")
            print("%s · %s: %s" % (aid, args.element or "whole", verb))
        else:
            verb = ("W-anchor dirty — waiver VOIDED, gap live again"
                    if kind == "waiver" else
                    "O-anchor dirty — checker re-armed for a fresh verdict")
            print("%s · %s: %s" % (aid, args.element or "whole", verb))
            for t in touched:
                print("  touched: %s" % t)
    return 0 if clean else 1


# ── certification — render the §11.1 block ───────────────────────────────────


def cmd_certification(args) -> int:
    m = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    width = max((len(e["path"]) for e in m["files"]), default=40)
    print("Certification: run %s · effective PASS · %s"
          % (m.get("run", "?"), m.get("date", "—")))
    for e in m["files"]:
        note = ""
        if "trace" in e["labels"]:
            note = "   (generated run %s)" % m.get("run", "?")
        if "hist" in e["labels"]:
            note = "   [hist]"
        print("  %-*s  %s%s" % (width, e["path"], e["sha256"][:4] + "…", note))
    print("Adapter precondition: every hash matches the live file at handoff — "
          "any\nmismatch → refuse handoff, print the diverged paths, demand "
          "re-gate.")
    return 0


def main(argv=None) -> int:
    p = argparse.ArgumentParser(description="snapshot · diff · re-run set · anchors")
    sub = p.add_subparsers(dest="cmd", required=True)

    b = sub.add_parser("build", help="assemble deps(F), hash it, write the manifest")
    b.add_argument("--root", default=".")
    b.add_argument("--feature", required=True)
    b.add_argument("--epic", default="")
    b.add_argument("--hist", default=None)
    b.add_argument("--run", default="1")
    b.add_argument("--date", default="—")
    b.add_argument("--out")
    b.add_argument("--workspace", help="copy the snapshot here; checkers read it")
    b.add_argument("--require-complete", action="store_true",
                   help="exit non-zero if any static-core member is missing")
    b.set_defaults(fn=cmd_build)

    v = sub.add_parser("verify", help="manifest vs. the live files")
    v.add_argument("manifest")
    v.add_argument("--root", default=".")
    v.set_defaults(fn=cmd_verify)

    r = sub.add_parser("rerun-set", help="the §9.2 incremental composition")
    r.add_argument("--prev", required=True)
    r.add_argument("--curr", required=True)
    r.add_argument("--prev-spec")
    r.add_argument("--curr-spec")
    r.add_argument("--non-clean", default="",
                   help="CC-IDs that failed/waived/overridden/skipped last run")
    r.add_argument("--format", choices=("text", "json"), default="text")
    r.set_defaults(fn=cmd_rerun_set)

    a = sub.add_parser("anchor-diff", help="waiver/override anchor cleanliness")
    a.add_argument("--prev", required=True)
    a.add_argument("--curr", required=True)
    a.add_argument("--assertion", required=True)
    a.add_argument("--element", default="")
    a.add_argument("--kind", choices=("waiver", "override"), default="waiver")
    a.add_argument("--prev-spec")
    a.add_argument("--curr-spec")
    a.add_argument("--format", choices=("text", "json"), default="text")
    a.set_defaults(fn=cmd_anchor_diff)

    c = sub.add_parser("certification", help="render the §11.1 block")
    c.add_argument("manifest")
    c.set_defaults(fn=cmd_certification)

    args = p.parse_args(argv)
    return args.fn(args)


if __name__ == "__main__":
    raise SystemExit(main())
