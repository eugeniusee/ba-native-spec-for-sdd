#!/usr/bin/env python3
"""Verify an installed .specify/ba/manifest.md against the package repo.

Three claims, each checkable:

  1. Package version      — matches the package repo's VERSION.
  2. Source-doc vector    — every row matches the version in the header of the
                            vendored document it names. This is what makes the
                            build plan §3.5 propagation map trustworthy: a doc
                            bump that did not recompile shows up here.
  3. Installed-file hashes— every listed file exists and hashes as recorded.
                            A drifted hash means the installed tree is not what
                            the manifest certifies. AGENTS.md and CLAUDE.md are
                            merge targets: they hash over the installer-owned
                            fenced block, markers included, never the whole file
                            (D-P2-14) — content outside the fence is the
                            project's own and is not ⬒. A missing fence is real
                            drift.

Exit 0 on all three; 1 otherwise. Python 3 standard library only (D-P2-7).
"""

import hashlib
import pathlib
import re
import sys

VERSION_RE = re.compile(r"\bv(\d+\.\d+)\b")

# D-P2-14 — the ⬒-set rule for the two fenced-block merge targets.
MERGE_TARGETS = ("AGENTS.md", "CLAUDE.md")
BEGIN, END = "<!-- ba-native-spec:begin -->", "<!-- ba-native-spec:end -->"


def fenced_block(path):
    """The installer-owned region of a merge target — markers included."""
    text = path.read_text(encoding="utf-8")
    i, j = text.find(BEGIN), text.find(END)
    if i < 0 or j < 0 or j < i:
        return None
    return text[i:j + len(END)]

DOCS = {
    "definition & plan": "ba-native-spec-definition-and-plan-v2.md",
    "writing standard": "ba-native-spec-writing-standard.md",
    "completeness contract": "ba-native-spec-completeness-contract.md",
    "elicitation techniques": "ba-native-spec-elicitation-techniques.md",
    "gate definition": "ba-native-spec-gate-definition.md",
    "orchestrator rules": "ba-native-spec-orchestrator-rules.md",
    "Wave-2 sequencing plan": "ba-native-spec-wave2-sequencing-plan.md",
    "catalogue index": "ba-native-spec-catalogue-index.md",
    "catalogue b1": "ba-native-spec-catalogue-b1.md",
    "catalogue b2": "ba-native-spec-catalogue-b2.md",
    "catalogue b3": "ba-native-spec-catalogue-b3.md",
    "catalogue b4": "ba-native-spec-catalogue-b4.md",
    "catalogue b5": "ba-native-spec-catalogue-b5.md",
    "catalogue b6": "ba-native-spec-catalogue-b6.md",
    "Phase-2 build plan": "ba-native-spec-phase2-build-plan.md",
}


def doc_version(path: pathlib.Path) -> str:
    if not path.exists():
        return "MISSING"
    for line in path.read_text(encoding="utf-8").splitlines()[:4]:
        m = VERSION_RE.search(line)
        if m:
            return "v" + m.group(1)
    return "unversioned"


def main(argv: list[str]) -> int:
    target = pathlib.Path(argv[1]).resolve()
    pkg_root = pathlib.Path(argv[2]).resolve()
    manifest = target / ".specify" / "ba" / "manifest.md"
    text = manifest.read_text(encoding="utf-8")

    problems: list[str] = []

    # 1 — package version -------------------------------------------------------
    m = re.search(r"^\|\s*Package version\s*\|\s*(\S+)\s*\|", text, re.M)
    declared = m.group(1) if m else None
    expected = (pkg_root / "VERSION").read_text(encoding="utf-8").strip()
    if declared == expected:
        print(f"package version {declared} ✓")
    else:
        problems.append(f"package version: manifest says {declared!r}, VERSION says {expected!r}")

    # Spec Kit pin (reported; the pin's authority is install.sh + D-P2-8) -------
    m = re.search(r"^\|\s*Spec Kit pin\s*\|\s*(\S+)", text, re.M)
    print(f"Spec Kit pin {m.group(1) if m else '(not recorded)'} ✓")

    # 2 — source-doc version vector --------------------------------------------
    section = text.split("## Source-doc version vector", 1)
    if len(section) != 2:
        problems.append("manifest carries no source-doc version vector")
        rows = {}
    else:
        body = section[1].split("## Installed files", 1)[0]
        rows = {
            k.strip(): v.strip()
            for k, v in re.findall(r"^\|\s*([^|]+?)\s*\|\s*(v[\d.]+|MISSING|unversioned)\s*\|$", body, re.M)
        }

    missing = sorted(set(DOCS) - set(rows))
    extra = sorted(set(rows) - set(DOCS))
    for label in missing:
        problems.append(f"doc vector: no row for {label!r}")
    for label in extra:
        problems.append(f"doc vector: unexpected row {label!r}")

    drifted = []
    for label, filename in DOCS.items():
        if label not in rows:
            continue
        actual = doc_version(pkg_root / "docs" / "methodology" / filename)
        if rows[label] != actual:
            drifted.append(f"{label}: manifest {rows[label]}, vendored doc {actual}")
    problems.extend(f"doc vector drift — {d}" for d in drifted)

    if not missing and not extra and not drifted:
        print(f"source-doc vector: {len(rows)} documents, all matching the vendored set ✓")

    # 3 — installed-file hashes -------------------------------------------------
    block = re.search(r"## Installed files — sha256.*?```\n(.*?)```", text, re.S)
    checked = 0
    if not block:
        problems.append("manifest carries no installed-file hash list")
    else:
        for line in block.group(1).splitlines():
            line = line.strip()
            if not line:
                continue
            rel, _, digest = line.rpartition("  ")
            rel, digest = rel.strip(), digest.strip()
            if not rel or len(digest) != 64:
                problems.append(f"hash list: unparseable line {line!r}")
                continue
            f = target / rel
            if not f.is_file():
                problems.append(f"hash list: {rel} is recorded but absent")
                continue
            if rel in MERGE_TARGETS:
                block = fenced_block(f)
                if block is None:
                    problems.append(
                        f"hash list: {rel} carries no ba-native-spec fence — "
                        f"the installer-owned block is gone (real drift)")
                    continue
                actual = hashlib.sha256(block.encode("utf-8")).hexdigest()
            else:
                actual = hashlib.sha256(f.read_bytes()).hexdigest()
            if actual != digest:
                problems.append(f"hash list: {rel} content differs from the manifest record")
            checked += 1
        if not any(p.startswith("hash list") for p in problems):
            print(f"installed-file hashes: {checked} files, all matching ✓")

    if problems:
        print()
        for p in problems:
            print(f"✗ {p}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
