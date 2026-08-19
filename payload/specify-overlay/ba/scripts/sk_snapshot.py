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
    report         verdict assembly (§6.1) + the report entry (§6.2)   [S3]
    certification  render the §11.1 certification block from a manifest

`report` is the gate's **report/certification writer** (build plan §4, S3 row).
It is not a checker and it never judges: it takes the M checkers' JSON, the
gate agent's A-pass JSON, and the BA's P2–P5 rulings, then computes the verdict
by the §6.1 rules and renders the §6.2 entry. The arithmetic of a gate run is
deterministic by construction — an LLM-computed category summary would be the
one number in the framework nobody could verify.

The assertion table below carries **IDs and classes only** — no assertion text.
The layering rule (contract §2) keeps the chain one-way: script → CC-ID →
contract line → BABOK anchor. The one exception is deliberate and mandated:
gate §7.1 step 3 requires a waiver request against a non-waivable assertion to
be refused *"printing the contract's §8 rationale line for that ID"*, so those
six lines are vendored below — operative text the runtime must be able to
print, verified against the contract by `tests/check-cards.py`.

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
           ("CC-H-04", "H", "A"), ("CC-H-05", "H", "A"), ("CC-H-06", "H", "M"),
           ("CC-H-07", "H", "A")]

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


# ── report — verdict assembly (§6.1) + the report entry (§6.2) ───────────────

# contract §8, the locked non-waivable set with each ID's refusal line. Printed
# verbatim on a waiver request (gate §7.1 step 3 — "hard refusal").
_AUTHZ = ('Authorization is the one class where a confident agent guess is a '
          'security incident, and the constitution\'s "never infer permissions '
          'from personas" principle exists precisely to be unwaivable.')
NON_WAIVABLE = {
    "CC-G-01": "An unparseable structure breaks every downstream consumer, "
               "including this gate.",
    "CC-G-02": "An *unnamed* gap cannot be risk-accepted. The path is: name it "
               "— convert the stub to `[NEEDS CLARIFICATION: …]`, which fails "
               "CC-G-03, which **is** waivable. Every accepted gap is thereby "
               "a named gap, by construction.",
    "CC-FR-01": "EARS is the house grammar. Waiving it un-defines what a "
                "requirement is. What genuinely resists EARS is nearly always "
                "an NFR, a business rule, or design in disguise — the fix is "
                "re-classification, not exemption.",
    "CC-TR-01": "A broken story⇄FR graph breaks `/tasks` tagging ([US1], "
                "[US2]) and BA verification downstream.",
    "CC-XA-01": _AUTHZ,
    "CC-XA-02": _AUTHZ,
}

# contract §2 — the two assertions the BA signs individually, even on a PASS.
FLAGGED = ("CC-XA-01", "CC-XA-06")

# contract §8 — the six fields a waiver record must carry.
WAIVER_FIELDS = ("assertion", "element", "reason", "risk", "approver", "revisit")

CATEGORY = {aid: cat for aid, cat, _ in ASSERTIONS}
SCOPE_F_IN_FORCE = len(ASSERTIONS)

# A record applies to a gap when it names the same (assertion, element); an
# empty element in the record means the whole assertion.
LIVE, WAIVED, OVERRIDDEN = "LIVE", "WAIVED", "OVERRIDDEN"


def gap_line(aid, finding, non_waivable=False):
    """The contract's §7 named-gap grammar — the one place it is written.

    D7 (BUILD-LOG S2): checkers emit the bare line and expose non_waivable in
    their JSON; the `[non-waivable]` marker is rendered here, at report
    assembly, because contract §7 prints CC-TR-01's line without it.
    """
    mark = " [non-waivable]" if non_waivable else ""
    return "%s FAIL%s — %s: %s → %s" % (
        aid, mark, finding.get("element", "?"), finding.get("problem", "?"),
        finding.get("fix", "?"))


def _load_verdicts(paths, run_root: Path):
    """Merge checker + A-pass JSON into one assertion→record map."""
    recs, seen = {}, {}
    for rel in paths:
        p = Path(rel)
        if not p.is_absolute():
            p = run_root / rel
        if not p.is_file():
            runtime_defect("report: no verdict file at %s" % p)
        d = json.loads(p.read_text(encoding="utf-8"))
        src = d.get("script", p.stem)
        for a in d.get("assertions", []):
            aid = a["assertion"]
            if aid in recs:
                runtime_defect("report: %s reported twice — by %s and by %s"
                               % (aid, seen[aid], src))
            seen[aid] = src
            recs[aid] = {
                "assertion": aid,
                "verdict": a.get("verdict", "PASS"),
                "non_waivable": bool(a.get("non_waivable")),
                "evidence": a.get("evidence", ""),
                "blocked_by": a.get("blocked_by", ""),
                "findings": [dict(f) for f in a.get("findings", [])],
                "source": src,
            }
    return recs


def _matches(record, aid, element):
    if record.get("assertion") != aid:
        return False
    e = (record.get("element") or "").strip()
    return not e or e == (element or "").strip()


def _covered_by(record, aid, element):
    """A waiver covers its own (assertion, element) plus any `also` pairs.

    One consciously accepted gap can surface as more than one assertion line:
    contract §8 "Markers and waivers" keeps a waived `[NEEDS CLARIFICATION]`
    marker in the text as the gap's named location, so the marker's CC-G-03
    line and the underlying gap are the same acceptance. `also` names those
    extra lines on the one record rather than minting a second W-number.
    """
    if _matches(record, aid, element):
        return True
    for extra in record.get("also", []):
        if _matches(extra, aid, element):
            return True
    return False


def _validate_waivers(waivers):
    """gate §7.1 step 3 — waivable? all six fields? event-shaped revisit?"""
    refusals = []
    for w in waivers:
        if w.get("status") in ("lapsed", "voided"):
            continue
        aid = w.get("assertion", "?")
        if aid in NON_WAIVABLE:
            refusals.append(
                "REFUSED — %s is non-waivable: %s" % (aid, NON_WAIVABLE[aid]))
            continue
        missing = [f for f in WAIVER_FIELDS if not str(w.get(f, "")).strip()]
        if missing:
            refusals.append("REFUSED — %s (%s): waiver record incomplete, "
                            "missing %s (contract §8)"
                            % (w.get("id", "W-?"), aid, ", ".join(missing)))
    return refusals


def _disposition(recs, waivers, overrides):
    """Attach LIVE / WAIVED / OVERRIDDEN to every finding (§6.1, §7.1, §7.3)."""
    live, waived, overridden, skipped = [], [], [], []
    in_force = [w for w in waivers if w.get("status") not in ("lapsed", "voided")]
    applied = [o for o in overrides if o.get("status") != "revoked"]

    for aid in sorted(recs, key=lambda a: [x[0] for x in ASSERTIONS].index(a)
                      if a in CATEGORY else 999):
        rec = recs[aid]
        if rec["verdict"] == "SKIPPED":
            skipped.append((aid, rec.get("element", "whole"),
                            rec.get("blocked_by", "?")))
        for f in rec["findings"]:
            element = f.get("element", "")
            o = next((o for o in applied if _matches(o, aid, element)), None)
            w = next((w for w in in_force if _covered_by(w, aid, element)), None)
            if o is not None:
                f["_status"], f["_record"] = OVERRIDDEN, o.get("id", "O-?")
                overridden.append((aid, f))
            elif w is not None:
                f["_status"], f["_record"] = WAIVED, w.get("id", "W-?")
                waived.append((aid, f))
            else:
                f["_status"], f["_record"] = LIVE, None
                live.append((aid, f))
    return live, waived, overridden, skipped, in_force, applied


def _verdict(live, skipped, in_force):
    """gate §6.1, verbatim."""
    if live or skipped:
        return "FAIL (%d gaps)" % len(live)
    if in_force:
        return "PASS WITH WAIVERS"
    return "PASS"


def _category_summary(recs, carried, live, waived, overridden, skipped,
                      in_force, applied):
    """gate §6.2's totals. Three granularities, and they are not the same one:

    * **assertion** counts — in force · evaluated · carried · passed · skipped
    * **failure-line** count — failed (assertion × element; one assertion can
      contribute several gaps, contract §7)
    * **record** counts — waived · overridden (W-/O- records in force this run)

    Both worked examples reconcile under exactly this reading: contract §7's
    "61 checked · 54 passed" = the 55 Scope-F assertions + the 6 CC-H pre-flight
    ones, and gate §14.3's "55 in force · 1 waived · 1 overridden (re-applied)".

    The contract's §7 example is a **pinned worked run** and is quoted as it
    stands: it predates CC-H-07 (contract v0.3), whose row the v0.3 change
    record adds without moving any other section. The live pre-flight set is
    `SCOPE_H` above — seven — and the summary this function computes is the
    Scope-F one either way; the reconciliation note is history, not arithmetic
    the runtime performs.
    """
    failed_ids = {aid for aid, _ in live}
    waived_ids = {aid for aid, _ in waived}
    skipped_ids = {aid for aid, _, _ in skipped}
    clean = set(recs) - failed_ids - waived_ids - skipped_ids
    return {
        "in force": SCOPE_F_IN_FORCE,
        "evaluated": len(recs),
        "carried": len(carried),
        "passed": len(clean),
        "failed": len(live),
        "waived": len(in_force),
        "overridden": len(applied),
        "skipped": len(skipped),
    }


def _per_category(recs, carried, live, waived, overridden, skipped):
    order, rows = [], {}
    for aid, cat, _ in ASSERTIONS:
        if cat not in rows:
            order.append(cat)
            rows[cat] = {"passed": 0, "failed": 0, "waived": 0,
                         "overridden": 0, "skipped": 0, "carried": 0}
    for c in carried:
        rows[CATEGORY[c["assertion"]]]["carried"] += 1
    for aid, _ in live:
        rows[CATEGORY[aid]]["failed"] += 1
    for aid, _ in waived:
        rows[CATEGORY[aid]]["waived"] += 1
    for aid, _ in overridden:
        rows[CATEGORY[aid]]["overridden"] += 1
    for aid, _, _ in skipped:
        rows[CATEGORY[aid]]["skipped"] += 1
    failed_ids = {aid for aid, _ in live} | {aid for aid, _ in waived} \
        | {aid for aid, _, _ in skipped}
    for aid in recs:
        if aid not in failed_ids:
            rows[CATEGORY[aid]]["passed"] += 1
    return order, rows


def _waiver_line(w, run):
    status = w.get("status", "fresh")
    tail = ("fresh" if status == "fresh"
            else "re-affirmed run %s" % run if status == "re-affirmed"
            else status)
    line = ("%s · %s · %s · reason: %s · risk: %s · approver: %s · "
            "revisit: %s · %s"
            % (w.get("id", "W-?"), w.get("assertion", "?"),
               w.get("gap") or w.get("element") or "whole", w.get("reason", "?"),
               w.get("risk", "?"), w.get("approver", "?"),
               w.get("revisit", "?"), tail))
    if w.get("also"):
        line += ("\n  also covers %s — the marker that names this gap "
                 "(contract §8)"
                 % " · ".join("%s (%s)" % (a.get("assertion"), a.get("element"))
                              for a in w["also"]))
    if w.get("basis"):
        line += "\n  (%s)" % w["basis"]
    return line


def _override_line(o, run):
    status = o.get("status", "fresh")
    tail = ("fresh" if status == "fresh"
            else "re-applied — evidence unchanged since run %s"
            % o.get("since", int(run) - 1 if str(run).isdigit() else "?")
            if status == "re-applied" else status)
    return ("%s · %s · %s · %s · approver: %s · %s"
            % (o.get("id", "O-?"), o.get("assertion", "?"),
               o.get("element", "whole"), o.get("reason", "?"),
               o.get("approver", "?"), tail))


def _blocked_entry(run, spec):
    gaps = spec.get("preflight", {}).get("gaps", [])
    live_gaps = [g for g in gaps if not g.get("ha")]
    out = ["## Gate run %s — %s — blocked at pre-flight"
           % (run, spec.get("date", "—")),
           "Feature: %s · Scopes: H (pre-flight over deps(F))"
           % spec.get("feature", "?"),
           "Verdict: BLOCKED AT PRE-FLIGHT (%d H gap%s)"
           % (len(live_gaps), "" if len(live_gaps) == 1 else "s"),
           "",
           "Pre-flight gaps:"]
    for g in live_gaps:
        out.append(g.get("gap_line") or gap_line(g.get("assertion", "CC-H-?"), g))
    lifted = [g for g in gaps if g.get("ha")]
    if lifted:
        out.append("Lifted by health acceptance: "
                   + " · ".join("%s (%s)" % (g["ha"], g.get("assertion", "?"))
                                for g in lifted))
    out += ["",
            "Nothing else was evaluated — a feature gate against rotten shared "
            "artifacts is",
            "meaningless (gate §4.1, Stage 0). Fix the artifact by the routing "
            "discipline, or",
            "grant a health acceptance at P1, then re-submit."]
    return "\n".join(out) + "\n"


def cmd_report(args) -> int:
    run_file = Path(args.run_file)
    spec = json.loads(run_file.read_text(encoding="utf-8"))
    run_root = run_file.resolve().parent
    run = spec.get("run", "1")
    date = spec.get("date", "—")

    preflight = spec.get("preflight", {}) or {}
    if [g for g in preflight.get("gaps", []) if not g.get("ha")]:
        text = _blocked_entry(run, spec)
        _emit(text, args)
        return 1

    recs = _load_verdicts(list(spec.get("checkers", []))
                          + ([spec["a_pass"]] if spec.get("a_pass") else []),
                          run_root)

    # the gate meets its own bar (gate §1 rule 2): every failure line this
    # writer renders must equal the line its checker already produced.
    for aid, rec in recs.items():
        for f in rec["findings"]:
            if f.get("gap_line") and f["gap_line"] != gap_line(aid, f):
                runtime_defect(
                    "report: %s's finding does not round-trip the named-gap "
                    "grammar\n  checker: %s\n  writer : %s"
                    % (aid, f["gap_line"], gap_line(aid, f)))

    waivers = spec.get("waivers", []) or []
    overrides = spec.get("overrides", []) or []
    refusals = _validate_waivers(waivers)
    if refusals:
        for r in refusals:
            print(r, file=sys.stderr)
        return 2

    carried = spec.get("carried", []) or []
    live, waived, overridden, skipped, in_force, applied = _disposition(
        recs, waivers, overrides)
    verdict = _verdict(live, skipped, in_force)
    pass_bound = verdict.startswith("PASS")

    signoffs = spec.get("signoffs", {}) or {}
    approval = spec.get("approval") or {}
    effective = bool(pass_bound
                     and all(signoffs.get(a) for a in FLAGGED)
                     and approval.get("name"))

    summary = _category_summary(recs, carried, live, waived, overridden,
                                skipped, in_force, applied)

    out = ["## Gate run %s — %s" % (run, date),
           "Feature: %s · Spec revision: %s · Scopes: %s"
           % (spec.get("feature", "?"), spec.get("spec_revision", "?"),
              spec.get("scopes", "F (+H pre-flight)")),
           "Verdict: %s%s" % (verdict, "" if effective or not pass_bound
                              else "  (provisional — awaiting %s)"
                              % (" + ".join(
                                  ([ "⚑ sign-offs"] if not all(
                                      signoffs.get(a) for a in FLAGGED) else [])
                                  + (["BA approval"] if not approval.get("name")
                                     else [])))),
           "",
           "Failures:"]
    if live:
        for aid, f in live:
            out.append(gap_line(aid, f, recs[aid]["non_waivable"]))
    else:
        out.append("none")

    out += ["", "Waivers in force:"]
    out += [_waiver_line(w, run) for w in in_force] or ["none"]

    out += ["", "Overrides this run:"]
    out += [_override_line(o, run) for o in applied] or ["none"]

    out += ["", "⚑ sign-offs:"]
    if not pass_bound:
        out += ["%s — (verdict FAIL)" % a for a in FLAGGED]
    else:
        for a in FLAGGED:
            s = signoffs.get(a)
            out.append("%s — %s · evidence reviewed · %s"
                       % (a, s.get("summary", "?"), s.get("initials", "?"))
                       if s else
                       "%s — NOT SIGNED (required for an effective PASS)" % a)

    out += ["", "Category summary: "
            + " · ".join("%d %s" % (v, k) for k, v in summary.items())]
    if not pass_bound:
        order, rows = _per_category(recs, carried, live, waived, overridden,
                                    skipped)
        for cat in order:
            r = rows[cat]
            if any(r[k] for k in ("failed", "waived", "overridden", "skipped")):
                out.append("  %-3s %s" % (cat, " · ".join(
                    "%d %s" % (r[k], k) for k in
                    ("passed", "failed", "waived", "overridden", "skipped",
                     "carried") if r[k])))

    out += ["", "BA approval: " + (
        "%s · %s — effective PASS" % (approval["name"], approval.get("date", "—"))
        if effective else
        "— (verdict FAIL; resubmit after fixes)" if not pass_bound else
        "— (provisional PASS; approval outstanding)")]

    manifest = None
    if spec.get("manifest"):
        mp = Path(spec["manifest"])
        if not mp.is_absolute():
            mp = run_root / spec["manifest"]
        manifest = json.loads(mp.read_text(encoding="utf-8"))
        # gate §11.1: the certification manifest lists "every file the run read
        # or produced". The snapshot holds what it read; `produced` adds what
        # Stage 2 generated and Stage 5 commits — `traceability.md` (CC-TR-04:
        # generated, never hand-authored).
        known = {e["path"] for e in manifest["files"]}
        for item in spec.get("produced", []):
            rel = item if isinstance(item, str) else item["path"]
            labels = ["trace"] if isinstance(item, str) else item.get(
                "labels", ["trace"])
            if rel in known:
                continue
            p = Path(manifest.get("root", ".")) / rel
            if not p.is_file():
                runtime_defect("report: run 5 cannot certify a file it did not "
                               "produce — %s is absent" % rel)
            manifest["files"].append({"labels": labels, "path": rel,
                                      "sha256": sha256(p)})

    out += ["", "Runtime record (gate definition §6.2):",
            "Snapshot:             %s"
            % ("%d files hashed — manifest at end of entry"
               % len(manifest["files"]) if manifest else "—"),
            "Pre-flight:           %s" % (
                "clean" if not preflight.get("gaps") else
                "%d gap(s) lifted by %s"
                % (len(preflight["gaps"]),
                   ", ".join(sorted({g["ha"] for g in preflight["gaps"]})))),
            "%-21s %s" % (
                "Carried from run %s:"
                % (int(run) - 1 if str(run).isdigit() and int(run) > 1 else "—"),
                " · ".join(c["assertion"] for c in carried) or "none")]
    if carried:
        bases = sorted({c.get("basis", "read set untouched by the diff")
                        for c in carried})
        out.append("                      (%s)" % "; ".join(bases))
    out += ["Skipped:              %s"
            % (" · ".join("%s · %s ← %s" % s for s in skipped) or "none"),
            "Certification:        %s"
            % ("manifest below" if effective else "— (not an effective PASS)")]

    if effective and manifest:
        out.append("")
        out.append(_certification_block(manifest, run, date))
        if getattr(args, "certification_out", None):
            manifest["run"], manifest["date"] = run, date
            Path(args.certification_out).write_text(
                json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8")

    _emit("\n".join(out) + "\n", args)
    return 0 if pass_bound else 1


def _emit(text, args):
    if getattr(args, "append", None):
        p = Path(args.append)
        p.parent.mkdir(parents=True, exist_ok=True)
        prefix = "" if not p.exists() or not p.read_text(
            encoding="utf-8").strip() else "\n---\n\n"
        with p.open("a", encoding="utf-8") as fh:
            fh.write(prefix + text)
        print("report: appended %d line(s) to %s"
              % (text.count("\n"), args.append))
    else:
        sys.stdout.write(text)


# ── certification — render the §11.1 block ───────────────────────────────────


def _certification_block(m, run=None, date=None) -> str:
    width = max((len(e["path"]) for e in m["files"]), default=40)
    run = run if run is not None else m.get("run", "?")
    out = ["Certification: run %s · effective PASS · %s"
           % (run, date if date is not None else m.get("date", "—"))]
    for e in m["files"]:
        note = ""
        if "trace" in e["labels"]:
            note = "   (generated run %s)" % run
        if "hist" in e["labels"]:
            note = "   [hist]"
        out.append("  %-*s  %s%s" % (width, e["path"], e["sha256"][:4] + "…",
                                     note))
    out.append("Adapter precondition: every hash matches the live file at "
               "handoff — any\nmismatch → refuse handoff, print the diverged "
               "paths, demand re-gate.")
    return "\n".join(out)


def cmd_certification(args) -> int:
    m = json.loads(Path(args.manifest).read_text(encoding="utf-8"))
    print(_certification_block(m))
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

    rp = sub.add_parser("report", help="verdict assembly + the §6.2 entry")
    rp.add_argument("run_file", help="the run record — see the ba-gate skill")
    rp.add_argument("--append", help="append the entry to this gate-report.md")
    rp.add_argument("--certification-out",
                    help="write the §11.1 certification manifest here "
                         "(effective PASS only) — the adapter verifies it")
    rp.set_defaults(fn=cmd_report)

    c = sub.add_parser("certification", help="render the §11.1 block")
    c.add_argument("manifest")
    c.set_defaults(fn=cmd_certification)

    args = p.parse_args(argv)
    return args.fn(args)


if __name__ == "__main__":
    raise SystemExit(main())
