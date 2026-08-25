#!/usr/bin/env python3
"""sk_handoff — the Mode-A adapter: hash guard · branch · plumbing · ready report.

BA-Native Spec · vendored runtime script (build plan §2.4, S9).
Anchors: gate definition §11.1 (the certification manifest and its adapter
precondition) · §11.2 (the adapter's ordered acts) · §14.4 (the worked handoff
this implementation reproduces) · plan Q5 (Mode A: no LLM between gate and
plan — the certified text is the read text).

**This script is not a checker and not a judge.** It verifies, it plumbs, it
reports. It never edits a spec, never edits a memory artifact, never re-runs an
assertion, never grants anything. Its one authority is a **refusal**: on any
divergence between the certification manifest and the live files it stops,
prints the diverged paths, and demands a re-gate.

Order of acts (gate §11.2, "In order")
--------------------------------------
    1. resolve the feature and its certification manifest
    2. HASH GUARD — every certified path, before any side effect
    3. the certified artifact set is in place
    4. Spec Kit plumbing — the pipeline this hands to actually exists
    5. branch create/checkout
    6. RE-VERIFY — a checkout can move a certified file; see below
    7. the feature pointer Spec Kit resolves paths through
    8. the ready report

Steps 1–4 have no side effects, so a refusal at any of them leaves the project
exactly as it was: no branch created, no branch switched, no file written. That
ordering is the point of the guard — a refused handoff must not be half-done.

**Step 7 is gate §11.2's "any copies Spec Kit's layout requires", made
concrete at the pin.** At v0.12.5 `setup-plan.sh` no longer derives the feature
from the branch name: `get_feature_paths()` resolves it from
`SPECIFY_FEATURE_DIRECTORY`, else from `.specify/feature.json`, else it errors.
That file is normally written by `/speckit-specify` — the command Mode A
deliberately does not run, because our spec is already at the destination. So
without this act `/speckit-plan` stops on `ERROR: Feature directory not found`
and the operator has to intervene — which is precisely the "manual rework"
Mode A exists to make zero. The pointer is Spec Kit's own file, holding no
content of ours; it is written idempotently, after the guard has passed and the
branch is settled, and never inside `.specify/memory/`.

**Step 6 is this implementation's own.** Gate §11.2 fixes verify → plumbing →
report; it does not contemplate the branch checkout itself moving a certified
byte. It can: if the `NNN-feature` branch already exists and carries a different
revision of `spec.md`, the checkout swaps the very file the guard just cleared,
and the operator would resume `/speckit-plan` on uncertified text with a clean
report behind it. So the guard runs again after the branch act, and a
post-checkout divergence is the same refusal — with the branch named as its
cause. This adds a check inside the pinned order; it removes none.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

# No bytecode: a __pycache__ directory inside the installed
# `.specify/ba/scripts/` would join the install manifest's hash list and make it
# rot on first use.
sys.dont_write_bytecode = True

READY, REFUSED, DEFECT = 0, 1, 2

MARKER_RE = re.compile(r"\[NEEDS CLARIFICATION[^\]]*\]")

# The certification manifest records the compiled A cards the run gated under
# (gate §9.2). The hash guard does not read them: the guard's question is "is
# the certified text still the read text", and the cards are not the read text
# — they are the assertions that read it. Guarding them would void an effective
# PASS the moment the framework re-cuts a card, and §9.2 is explicit that
# nothing voids retroactively — the PASS stands until the feature's next
# re-gate, and re-gates under the current cards then.
CARDS_LABEL = "cards"
RUN_HEAD_RE = re.compile(r"^## Gate run (\S+) — (.*)$")


def runtime_defect(msg: str):
    """Not a verdict and not a refusal — the run could not be composed."""
    print("sk_handoff: runtime defect — %s" % msg, file=sys.stderr)
    raise SystemExit(DEFECT)


def sha256(path: Path) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


# ── 1. resolve the feature and its certification ─────────────────────────────


def resolve_feature(root: Path, arg: str) -> str:
    """`004` · `004-appointment-booking` · `specs/004-appointment-booking` → dir name."""
    specs = root / "specs"
    if not specs.is_dir():
        runtime_defect("no specs/ directory under %s" % root)

    name = arg.strip().strip("/")
    if name.startswith("specs/"):
        name = name.split("/", 1)[1].strip("/")

    candidates = sorted(d.name for d in specs.iterdir() if d.is_dir())
    if name in candidates:
        return name

    hits = [c for c in candidates if c.split("-", 1)[0] == name]
    if len(hits) == 1:
        return hits[0]
    if len(hits) > 1:
        runtime_defect("'%s' matches %d feature directories: %s"
                       % (arg, len(hits), ", ".join(hits)))
    runtime_defect("no feature directory for '%s' under specs/ "
                   "(present: %s)" % (arg, ", ".join(candidates) or "none"))


def find_certification(root: Path, feature: str, explicit=None):
    """The certification manifest of the feature's latest certified run.

    The gate writes it at `.specify/ba/runs/<feature>/run-<n>/cert.json`
    (ba-gate skill, Stage 5) and writes it *only* on an effective PASS — so
    "no cert.json" and "no effective PASS" are the same fact, and the refusal
    says so.
    """
    if explicit:
        p = Path(explicit)
        if not p.is_file():
            return None, "the certification manifest at %s does not exist" % p
        return p, None

    runs = root / ".specify" / "ba" / "runs" / feature
    if not runs.is_dir():
        return None, ("no gate run has ever been recorded for %s — "
                      "the feature has no certification" % feature)

    certs = []
    for d in runs.iterdir():
        c = d / "cert.json"
        if not c.is_file():
            continue
        m = re.match(r"run-(\d+)$", d.name)
        certs.append((int(m.group(1)) if m else -1, c))
    if not certs:
        return None, ("no certification manifest under %s — a certification is "
                      "written only on an effective PASS, so this feature has "
                      "not passed the gate" % runs)
    certs.sort()
    return certs[-1][1], None


# ── 2/6. the hash guard ──────────────────────────────────────────────────────


def verify(manifest, root: Path):
    """(diverged, checked) — diverged is [(path, why)], in manifest order."""
    diverged = []
    guarded = [e for e in manifest["files"]
               if CARDS_LABEL not in e.get("labels", [])]
    for e in guarded:
        p = root / e["path"]
        if not p.is_file():
            diverged.append((e["path"], "missing"))
        elif sha256(p) != e["sha256"]:
            diverged.append((e["path"], "content changed"))
    return diverged, len(guarded)


# ── 3/4. the artifact set, and the pipeline this hands to ────────────────────


def artifact_set(root: Path, feature: str):
    """The three files a certified feature folder holds (gate §11.1, §8)."""
    fdir = Path("specs") / feature
    present, missing = [], []
    for name in ("spec.md", "traceability.md", "gate-report.md"):
        rel = str(fdir / name)
        (present if (root / rel).is_file() else missing).append(rel)
    return present, missing


def feature_pointer(root: Path, feature: str, write=True):
    """`.specify/feature.json` — how Spec Kit v0.12.x resolves FEATURE_DIR.

    Mirrors `common.sh`'s `_persist_feature_json`: a repo-relative
    `feature_directory`, written only when missing or different. Returns
    (state, value).
    """
    fj = root / ".specify" / "feature.json"
    want = "specs/%s" % feature

    current = None
    if fj.is_file():
        try:
            current = json.loads(fj.read_text(encoding="utf-8")).get(
                "feature_directory")
        except (OSError, ValueError):
            current = None

    if current == want:
        return "current", want
    if not write:
        return ("would-write" if current is None else "would-repoint"), want

    fj.parent.mkdir(parents=True, exist_ok=True)
    fj.write_text(json.dumps({"feature_directory": want}) + "\n",
                  encoding="utf-8")
    return ("written" if current is None else "repointed"), want


def plumbing(root: Path):
    """Spec Kit's expected structure — the pipeline the operator resumes into."""
    checks = [
        ("plan-template", ".specify/templates/plan-template.md", True),
        ("tasks-template", ".specify/templates/tasks-template.md", True),
        ("scripts/", ".specify/scripts", True),
        ("/speckit-plan", ".claude/skills/speckit-plan/SKILL.md", True),
    ]
    ok_names, missing = [], []
    for label, rel, required in checks:
        p = root / rel
        if p.exists():
            ok_names.append(label)
        elif required:
            missing.append((label, rel))
    return ok_names, missing


# ── 5. the branch ────────────────────────────────────────────────────────────


def git(root: Path, *args):
    return subprocess.run(["git", "-C", str(root), *args],
                          capture_output=True, text=True)


def branch_act(root: Path, branch: str, dry_run=False):
    """(state, detail) — never invents; git's own error text travels."""
    if git(root, "rev-parse", "--git-dir").returncode != 0:
        return "error", "not a git repository: %s" % root

    current = git(root, "rev-parse", "--abbrev-ref", "HEAD").stdout.strip()
    exists = git(root, "rev-parse", "--verify", "--quiet",
                 "refs/heads/%s" % branch).returncode == 0

    if current == branch:
        return "current", "already checked out"
    if dry_run:
        return ("would-checkout" if exists else "would-create",
                "from %s" % current)

    if exists:
        r = git(root, "checkout", branch)
        return ("checkout", "switched from %s" % current) if r.returncode == 0 \
            else ("error", (r.stderr or r.stdout).strip())

    r = git(root, "checkout", "-b", branch)
    return ("create", "created from %s" % current) if r.returncode == 0 \
        else ("error", (r.stderr or r.stdout).strip())


# ── 7. the ready report's content ────────────────────────────────────────────


def carried_markers(root: Path, feature: str):
    """Every `[NEEDS CLARIFICATION]` in the certified spec, with its heading.

    Reported, never judged. Gate §14.4's handoff sentence is that the coding
    agent "reads exactly one consciously accepted unknown — and nothing
    hidden"; this is the inventory that makes the claim checkable at the
    handoff line rather than assumed. A marker in a certified spec is a waived
    gap by construction (contract §8's two-step: name it, then waive it), so
    the adapter surfaces it and stops there.
    """
    spec = root / "specs" / feature / "spec.md"
    if not spec.is_file():
        return []
    out, heading = [], "—"
    for line in spec.read_text(encoding="utf-8").splitlines():
        if line.startswith("## "):
            heading = line[3:].strip()
        for m in MARKER_RE.finditer(line):
            out.append({"section": heading, "marker": m.group(0)})
    return out


def certified_run_entry(root: Path, feature: str, run):
    """The gate-report block for the certified run — read-only, for the report."""
    rp = root / "specs" / feature / "gate-report.md"
    if not rp.is_file():
        return None
    blocks, cur = [], None
    for line in rp.read_text(encoding="utf-8").splitlines():
        m = RUN_HEAD_RE.match(line)
        if m:
            cur = {"run": m.group(1), "lines": [line]}
            blocks.append(cur)
        elif cur is not None:
            cur["lines"].append(line)
    for b in blocks:
        if str(b["run"]) == str(run):
            return b
    return blocks[-1] if blocks else None


def block_field(block, field: str):
    """The lines under `<field>:` in a report entry, up to the next blank line."""
    if not block:
        return []
    out, on = [], False
    for line in block["lines"]:
        if line.strip() == "%s:" % field:
            on = True
            continue
        if on:
            if not line.strip():
                break
            out.append(line.strip())
    return [l for l in out if l.lower() != "none"]


# ── the run ──────────────────────────────────────────────────────────────────


def refuse(title, lines, tail, args, payload=None):
    if args.format == "json":
        print(json.dumps({"result": "REFUSED", "reason": title,
                          "diverged": lines, **(payload or {})},
                         indent=2, ensure_ascii=False))
    else:
        print("REFUSED — %s" % title)
        for l in lines:
            print("  %s" % l)
        for l in tail:
            print(l)
    return REFUSED


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="Mode-A adapter — hash guard · branch · plumbing · ready")
    p.add_argument("feature", help="004 · 004-appointment-booking · specs/…")
    p.add_argument("--root", default=".", help="project root (default: .)")
    p.add_argument("--cert", help="explicit certification manifest (default: "
                                  "the feature's latest run cert.json)")
    p.add_argument("--branch", help="branch name (default: the feature name)")
    p.add_argument("--no-branch", action="store_true",
                   help="verify and report; touch no git state")
    p.add_argument("--verify-only", action="store_true",
                   help="the hash guard alone — the cheap pre-handoff check")
    p.add_argument("--dry-run", action="store_true",
                   help="report the branch act without performing it")
    p.add_argument("--format", choices=("text", "json"), default="text")
    args = p.parse_args(argv)

    root = Path(args.root).resolve()
    feature = resolve_feature(root, args.feature)
    branch = args.branch or feature

    # ── 1. the certification ────────────────────────────────────────────────
    cert_path, why = find_certification(root, feature, args.cert)
    if cert_path is None:
        return refuse("%s carries no certification" % feature, [why],
                      ["→ run /ba-gate %s to an effective PASS before handoff."
                       % feature], args)
    try:
        manifest = json.loads(cert_path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        runtime_defect("the certification manifest at %s will not parse: %s"
                       % (cert_path, exc))
    run, date = manifest.get("run", "?"), manifest.get("date", "—")

    # ── 2. the hash guard — before any side effect ──────────────────────────
    diverged, checked = verify(manifest, root)
    if diverged:
        return refuse(
            "%d certified path(s) diverged from the live files" % len(diverged),
            ["%s — %s" % (path, why) for path, why in diverged],
            ["→ re-gate before handoff; the certified text is the read text.",
             "  Nothing was done: no branch was created or checked out."],
            args, {"stage": "hash-guard", "feature": feature,
                   "certification": {"run": run, "date": date}})

    if args.verify_only:
        if args.format == "json":
            print(json.dumps({"result": "CLEAN", "feature": feature,
                              "certification": {"run": run, "date": date},
                              "checked": checked}, indent=2, ensure_ascii=False))
        else:
            print("clean — %d/%d certified hash(es) match the live files "
                  "(run %s · %s)" % (checked, checked, run, date))
        return READY

    # ── 3. the certified artifact set ───────────────────────────────────────
    present, missing = artifact_set(root, feature)
    if missing:
        return refuse("the certified artifact set is incomplete",
                      ["%s — missing" % m for m in missing],
                      ["→ re-gate: the gate commits traceability.md and appends "
                       "the report at Stage 5.",
                       "  Nothing was done: no branch was created or checked "
                       "out."],
                      args, {"stage": "artifact-set", "feature": feature})

    # ── 4. Spec Kit plumbing ────────────────────────────────────────────────
    plumb_ok, plumb_missing = plumbing(root)
    if plumb_missing:
        return refuse("Spec Kit's structure is incomplete — there is no "
                      "pipeline to hand to",
                      ["%s — expected at %s" % (label, rel)
                       for label, rel in plumb_missing],
                      ["→ re-run install.sh (pinned specify init + overlay).",
                       "  Nothing was done: no branch was created or checked "
                       "out."],
                      args, {"stage": "plumbing", "feature": feature})

    # ── 5. the branch ───────────────────────────────────────────────────────
    if args.no_branch:
        state, detail = "skipped", "--no-branch"
    else:
        state, detail = branch_act(root, branch, args.dry_run)
        if state == "error":
            return refuse("the branch act failed", [detail],
                          ["→ resolve the git state and re-run; the guard "
                           "passed, so nothing else stands in the way."],
                          args, {"stage": "branch", "feature": feature})

    # ── 6. re-verify: a checkout can move a certified file ──────────────────
    if state in ("checkout", "create"):
        diverged, _ = verify(manifest, root)
        if diverged:
            return refuse(
                "the branch act moved %d certified path(s)" % len(diverged),
                ["%s — %s" % (path, why) for path, why in diverged],
                ["→ branch '%s' carries a different revision of the certified "
                 "text." % branch,
                 "  You are now on that branch; re-gate there, or return to the "
                 "revision that was certified."],
                args, {"stage": "post-branch", "feature": feature,
                       "branch": branch})

    # ── 7. the feature pointer Spec Kit resolves paths through ──────────────
    ptr_state, ptr_value = feature_pointer(
        root, feature,
        write=not (args.no_branch or args.dry_run))

    # ── 8. the ready report ─────────────────────────────────────────────────
    block = certified_run_entry(root, feature, run)
    waivers = block_field(block, "Waivers in force")
    markers = carried_markers(root, feature)

    if args.format == "json":
        print(json.dumps({
            "result": "READY", "feature": feature,
            "certification": {"run": run, "date": date,
                              "manifest": str(cert_path), "files": checked},
            "branch": {"name": branch, "state": state, "detail": detail},
            "feature_pointer": {"state": ptr_state, "value": ptr_value},
            "plumbing": plumb_ok, "artifacts": present,
            "waivers": waivers, "markers": markers,
        }, indent=2, ensure_ascii=False))
        return READY

    print("Ready — %s" % feature)
    print("  Certification:    run %s · effective PASS · %s" % (run, date))
    print("  Hash guard:       %d/%d certified path(s) match the live files"
          % (checked, checked))
    print("  Branch:           %s (%s)" % (branch, detail))
    print("  Spec Kit:         %s" % " · ".join(plumb_ok))
    print("  Feature pointer:  .specify/feature.json → %s (%s)"
          % (ptr_value, ptr_state))
    print("  Artifact set:     %s" % " · ".join(Path(a).name for a in present))
    print("  Waivers in force: %s"
          % ("\n                    ".join(waivers) if waivers else "none"))
    if markers:
        print("  Carried unknowns: %d × [NEEDS CLARIFICATION] — %s"
              % (len(markers), " · ".join(m["section"] for m in markers)))
        print("                    consciously accepted; the coding agent "
              "implements around them")
    else:
        print("  Carried unknowns: none")
    print("")
    print("The operator resumes at /speckit-plan. The certified text is the "
          "read text:")
    print("any edit from here voids the certification — fix in the spec, "
          "re-gate, re-handoff.")
    return READY


if __name__ == "__main__":
    raise SystemExit(main())
