#!/usr/bin/env python3
"""sk_structure — Stage 1: CC-G-01, document parse, ID inventory.

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: gate definition §4.1–§4.2 (Stage 1) · writing standard §2 (the ten
headings, exact names, exact order) · §3 (story form) · §4 (FR form) · §5
(tiered acceptance) · §7 (NFR) · §8 (BR).

Stage 1 is the parse every later stage reads, so this module is also the
**shared parse surface** for the other nine checkers: they import `parse_spec`,
the record types, and the emit/grammar helpers from here rather than
re-implementing them. That is the gate's own architecture (§4.1: Stage 1
produces the parse + ID inventory Stage 2 consumes), not a convenience — see
BUILD-LOG S2.

Verdicts produced here: CC-G-01 (non-waivable).

CLI:
    sk_structure.py --root <project> --feature 004-appointment-booking
    sk_structure.py --spec path/to/spec.md [--format text|json]

Exit codes (shared by every checker):
    0  every assertion PASS
    1  at least one FAIL
    2  runtime defect — a checker that cannot run is not a spec verdict
       (gate §5.1); fix the runner.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

# No bytecode: these scripts import one another (sk_structure is the shared
# parse surface), and a __pycache__ directory inside the installed
# `.specify/ba/scripts/` would join the install manifest's hash list and
# make it rot on first use.
sys.dont_write_bytecode = True


# ── the ten headings, exact names, exact order (writing standard §2) ───────────

SPEC_HEADINGS = [
    "Overview & Value",
    "User Stories",
    "Functional Requirements",
    "Flows, States & Errors",
    "Non-Functional Requirements",
    "Business Rules",
    "Data Requirements",
    "Integration Touchpoints",
    "Out of Scope",
    "References",
]

# skeleton § numbers, as the gate's read-scope table (§9.2) uses them
SECTION_NUMBER = {name: i + 1 for i, name in enumerate(SPEC_HEADINGS)}

# The six non-waivable assertions (contract §8, locked). Checkers report the
# flag; the report writer renders the "[non-waivable]" marker (gate §6.2) — the
# named-gap line itself stays exactly as the contract's §7 worked example spells
# it, which is what lets a fixture reproduce that example verbatim.
NON_WAIVABLE = {"CC-G-01", "CC-G-02", "CC-FR-01", "CC-TR-01", "CC-XA-01", "CC-XA-02"}


# ── record types ──────────────────────────────────────────────────────────────


@dataclass
class Section:
    name: str
    heading_line: int          # 1-based line number of the "## " line
    lines: list = field(default_factory=list)   # [(lineno, text)]

    @property
    def body(self) -> str:
        return "\n".join(t for _, t in self.lines)

    @property
    def number(self):
        return SECTION_NUMBER.get(self.name)


@dataclass
class Acceptance:
    kind: str                  # "checklist" | "scenario"
    text: str                  # the checklist assertion, or the scenario name
    lineno: int
    handle: str = ""           # generated positional handle (gate §8 step 1)


@dataclass
class Story:
    id: str                    # "US1"
    priority: str              # "P1" | "P2" | "P3" | "" when unparsed
    actor: str
    capability: str
    value: str
    lineno: int
    raw: str
    well_formed: bool
    priorities_found: list = field(default_factory=list)
    acceptance: list = field(default_factory=list)


@dataclass
class Requirement:
    id: str                    # "FR-001"
    us_refs: list
    text: str                  # the EARS body, after the "— "
    raw: str
    lineno: int
    tagged: bool               # carried an "(US<n>)" tag at all


@dataclass
class Rule:
    id: str                    # "BR-001"
    text: str
    lineno: int


@dataclass
class Nfr:
    id: str                    # "NFR-001"
    text: str
    lineno: int


@dataclass
class Spec:
    path: Path
    text: str
    lines: list
    fenced: list
    sections: list
    stories: list
    requirements: list
    rules: list
    nfrs: list
    heading_order: list

    def section(self, name: str):
        for s in self.sections:
            if s.name == name:
                return s
        return None

    def story(self, sid: str):
        for s in self.stories:
            if s.id == sid:
                return s
        return None

    def section_at(self, lineno: int):
        """The section a line sits in, or None above the first heading."""
        best = None
        for s in self.sections:
            if s.heading_line <= lineno and (best is None
                                             or s.heading_line > best.heading_line):
                best = s
        return best

    def id_owner(self, lineno: int) -> str:
        """The ID-bearing element a line belongs to — for naming gap elements.

        Attribution never crosses a section boundary: a marker in §8 belongs to
        §8, not to the last BR-ID above it.
        """
        sec = self.section_at(lineno)
        floor = sec.heading_line if sec else 0
        best = None
        for coll in (self.stories, self.requirements, self.rules, self.nfrs):
            for item in coll:
                if floor <= item.lineno <= lineno and (
                        best is None or item.lineno > best[0]):
                    best = (item.lineno, item.id)
        return best[1] if best else ""

    def element_at(self, lineno: int) -> str:
        """The gap element for a line: its ID owner, else its section."""
        owner = self.id_owner(lineno)
        if owner:
            return owner
        sec = self.section_at(lineno)
        if sec is None:
            return "line %d" % lineno
        n = SECTION_NUMBER.get(sec.name)
        return "§%d %s" % (n, sec.name) if n else sec.name


# ── parsing ───────────────────────────────────────────────────────────────────

FENCE_RE = re.compile(r"^\s*(```|~~~)")
H2_RE = re.compile(r"^##\s+(.+?)\s*$")
STORY_RE = re.compile(
    r"^\s*(US\d+)\s*\(\s*(P[123])\s*\)\s*[—–-]\s*"
    r"As\s+an?\s+(.+?),\s*I\s+want\s+(.+?),\s*so\s+that\s+(.+?)\s*\.?\s*$",
    re.IGNORECASE | re.DOTALL,
)
STORY_ID_RE = re.compile(r"^\s*(US\d+)\b(.*)$")
CHECKLIST_RE = re.compile(r"^\s*[-*]\s*\[[ xX]\]\s*(.+?)\s*$")
SCENARIO_RE = re.compile(r"^\s*Scenario:\s*(.+?)\s*$")
FR_RE = re.compile(r"^\s*(FR-\d+)\s*(\(([^)]*)\))?\s*[—–-]\s*(.*)$")
BR_RE = re.compile(r"^\s*(BR-\d+)\s*(?:\([^)]*\))?\s*[—–-]\s*(.*)$")
# NFRs may carry the category tag CC-NF-02 reads: NFR-0NN (<category>) — …
NFR_RE = re.compile(r"^\s*(NFR-\d+)\s*(?:\([^)]*\))?\s*[—–-]\s*(.*)$")
US_REF_RE = re.compile(r"\bUS\d+\b")
BR_REF_RE = re.compile(r"\bBR-\d+\b")


def _fence_flags(lines):
    """True for every line that sits inside (or on) a fenced code block."""
    inside = False
    flags = []
    for ln in lines:
        if FENCE_RE.match(ln):
            flags.append(True)       # the fence line itself counts as inside
            inside = not inside
            continue
        flags.append(inside)
    return flags


def parse_spec(path: Path) -> Spec:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    fenced = _fence_flags(lines)

    sections = []
    order = []
    current = None
    for i, ln in enumerate(lines, start=1):
        m = H2_RE.match(ln) if not fenced[i - 1] else None
        if m:
            current = Section(name=m.group(1).strip(), heading_line=i)
            sections.append(current)
            order.append(current.name)
            continue
        if current is not None:
            current.lines.append((i, ln))

    stories = _parse_stories(sections, fenced)
    requirements = _parse_requirements(sections, fenced)
    rules = _parse_ids(sections, fenced, "Business Rules", BR_RE, Rule)
    nfrs = _parse_ids(sections, fenced, "Non-Functional Requirements", NFR_RE, Nfr)

    return Spec(
        path=path, text=text, lines=lines, fenced=fenced, sections=sections,
        stories=stories, requirements=requirements, rules=rules, nfrs=nfrs,
        heading_order=order,
    )


def _block_bounds(sec, starts, idx):
    start = starts[idx]
    end = starts[idx + 1] if idx + 1 < len(starts) else (
        sec.lines[-1][0] + 1 if sec.lines else start + 1
    )
    return start, end


def _joined_head(sec, start, end):
    """The statement, joined across wrapped lines, stopping at the first blank."""
    parts = []
    for n, t in sec.lines:
        if not (start <= n < end):
            continue
        if not t.strip():
            break
        parts.append(t.strip())
    return re.sub(r"\s+", " ", " ".join(parts)).strip()


def _parse_stories(sections, fenced):
    sec = next((s for s in sections if s.name == "User Stories"), None)
    if sec is None:
        return []

    starts = [
        n for n, t in sec.lines
        if not fenced[n - 1] and STORY_ID_RE.match(t) and not CHECKLIST_RE.match(t)
    ]

    stories = []
    for idx, start in enumerate(starts):
        start, end = _block_bounds(sec, starts, idx)
        block = [(n, t) for n, t in sec.lines if start <= n < end]
        raw = _joined_head(sec, start, end)

        sid = STORY_ID_RE.match(block[0][1]).group(1)
        m = STORY_RE.match(raw)
        prios = [p.upper() for p in re.findall(r"\(\s*(P[123])\s*\)", raw)]
        if m:
            story = Story(id=sid, priority=m.group(2).upper(),
                          actor=m.group(3).strip(), capability=m.group(4).strip(),
                          value=m.group(5).strip(), lineno=start, raw=raw,
                          well_formed=True, priorities_found=prios)
        else:
            story = Story(id=sid, priority=(prios[0] if prios else ""), actor="",
                          capability="", value="", lineno=start, raw=raw,
                          well_formed=False, priorities_found=prios)

        ac_i = 0
        for n, t in block:
            if n == start:
                continue
            sm = SCENARIO_RE.match(t)
            if sm:
                name = sm.group(1).strip()
                story.acceptance.append(
                    Acceptance("scenario", name, n, '%s/S-"%s"' % (sid, name))
                )
                continue
            if fenced[n - 1]:
                continue          # gherkin bodies live in fences
            cm = CHECKLIST_RE.match(t)
            if cm:
                ac_i += 1
                story.acceptance.append(
                    Acceptance("checklist", cm.group(1).strip(), n,
                               "%s/AC-%d" % (sid, ac_i))
                )
        stories.append(story)
    return stories


def _parse_requirements(sections, fenced):
    sec = next((s for s in sections if s.name == "Functional Requirements"), None)
    if sec is None:
        return []
    reqs = []
    starts = [n for n, t in sec.lines if not fenced[n - 1] and FR_RE.match(t)]
    for idx, _ in enumerate(starts):
        start, end = _block_bounds(sec, starts, idx)
        raw = _joined_head(sec, start, end)
        m = FR_RE.match(raw)
        if not m:
            continue
        tag = m.group(3) or ""
        reqs.append(Requirement(
            id=m.group(1), us_refs=US_REF_RE.findall(tag),
            text=m.group(4).strip(), raw=raw, lineno=start, tagged=bool(m.group(2)),
        ))
    return reqs


def _parse_ids(sections, fenced, section_name, pattern, ctor):
    sec = next((s for s in sections if s.name == section_name), None)
    if sec is None:
        return []
    out = []
    starts = [n for n, t in sec.lines if not fenced[n - 1] and pattern.match(t)]
    for idx, _ in enumerate(starts):
        start, end = _block_bounds(sec, starts, idx)
        raw = _joined_head(sec, start, end)
        m = pattern.match(raw)
        if m:
            out.append(ctor(id=m.group(1), text=m.group(2).strip(), lineno=start))
    return out


# ── findings, verdicts, emission ──────────────────────────────────────────────


@dataclass
class Finding:
    """One failure, in the contract's §7 named-gap grammar."""

    element: str
    problem: str
    fix: str
    evidence: str = ""
    location: str = ""

    def gap_line(self, assertion: str) -> str:
        return "%s FAIL — %s: %s → %s" % (assertion, self.element, self.problem,
                                          self.fix)

    def as_dict(self, assertion: str) -> dict:
        return {
            "element": self.element,
            "problem": self.problem,
            "fix": self.fix,
            "evidence": self.evidence,
            "location": self.location,
            "gap_line": self.gap_line(assertion),
        }


@dataclass
class Verdict:
    """One assertion's result — the gate §5.4 evidence record, M flavour."""

    assertion: str
    verdict: str                       # PASS | FAIL | SKIPPED
    checks: list = field(default_factory=list)
    evidence: str = ""                 # terse counts on PASS (gate §5.1)
    findings: list = field(default_factory=list)
    blocked_by: str = ""

    @property
    def non_waivable(self) -> bool:
        return self.assertion in NON_WAIVABLE

    def as_dict(self) -> dict:
        return {
            "assertion": self.assertion,
            "verdict": self.verdict,
            "non_waivable": self.non_waivable,
            "checks": self.checks,
            "evidence": self.evidence,
            "blocked_by": self.blocked_by,
            "findings": [f.as_dict(self.assertion) for f in self.findings],
        }


def fail(assertion, checks, findings, evidence=""):
    return Verdict(assertion, "FAIL", checks, evidence, findings)


def ok(assertion, checks, evidence):
    return Verdict(assertion, "PASS", checks, evidence)


def skipped(assertion, checks, blocker):
    return Verdict(assertion, "SKIPPED", checks, blocked_by=blocker)


def emit(script, verdicts, fmt, stream=sys.stdout) -> int:
    """Print the verdict set; return the process exit code."""
    if fmt == "json":
        json.dump({"script": script,
                   "assertions": [v.as_dict() for v in verdicts]},
                  stream, indent=2, ensure_ascii=False)
        stream.write("\n")
    else:
        for v in verdicts:
            if v.verdict == "PASS":
                print("%s PASS — %s" % (v.assertion, v.evidence), file=stream)
            elif v.verdict == "SKIPPED":
                print("%s SKIPPED — blocked by %s" % (v.assertion, v.blocked_by),
                      file=stream)
            else:
                for f in v.findings:
                    print(f.gap_line(v.assertion), file=stream)
    return 1 if any(v.verdict != "PASS" for v in verdicts) else 0


def runtime_defect(message: str):
    """A checker that cannot run is a runtime defect, not a verdict (gate §5.1)."""
    print("sk: runtime defect — %s" % message, file=sys.stderr)
    raise SystemExit(2)


# ── shared CLI plumbing ───────────────────────────────────────────────────────


def base_parser(description: str) -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description=description)
    p.add_argument("--root", default=".",
                   help="project root, or the snapshot workspace (gate §3): "
                        "every checker reads the snapshot, never the live files")
    p.add_argument("--feature", help="NNN-feature directory under specs/")
    p.add_argument("--spec", help="explicit spec.md path (overrides --feature)")
    p.add_argument("--format", choices=("text", "json"), default="text")
    return p


def resolve_spec(args) -> Path:
    if getattr(args, "spec", None):
        return Path(args.spec)
    if getattr(args, "feature", None):
        return Path(args.root) / "specs" / args.feature / "spec.md"
    runtime_defect("need --spec or --feature")


def memory(root, name: str) -> Path:
    return Path(root) / ".specify" / "memory" / name


def load_spec(args):
    path = resolve_spec(args)
    if not path.is_file():
        runtime_defect("spec not found at %s" % path)
    return path, parse_spec(path)


def read_text(path: Path, what: str) -> str:
    if not Path(path).is_file():
        runtime_defect("%s not found at %s" % (what, path))
    return Path(path).read_text(encoding="utf-8")


# ── markdown-table helper (shared by the artifact-reading checkers) ────────────


def table_rows(body: str):
    """Yield the data rows of every markdown table in `body` as cell lists.

    Header rows and `---` separators are dropped; a row is data iff a separator
    row has already been seen in the same table.
    """
    seen_sep = False
    for line in body.splitlines():
        s = line.strip()
        if not s.startswith("|"):
            seen_sep = False
            continue
        cells = [c.strip() for c in s.strip("|").split("|")]
        if all(re.fullmatch(r":?-{2,}:?", c or "") for c in cells if c != ""):
            seen_sep = True
            continue
        if seen_sep:
            yield cells


def is_stub(body: str) -> bool:
    """CC-G-02 logic, reused by the health checks: empty or placeholder."""
    stripped = re.sub(r"<!--.*?-->", "", body, flags=re.S)
    stripped = "\n".join(
        ln for ln in stripped.splitlines() if not ln.strip().startswith("<")
    ).strip()
    if not stripped:
        return True
    placeholders = ("tbd", "todo", "to be defined", "to be determined",
                    "placeholder", "lorem ipsum", "fill me in")
    low = stripped.lower()
    if any(p in low for p in placeholders):
        return True
    # a file whose only content is headings carries no substance
    if all(ln.strip().startswith("#") or not ln.strip()
           for ln in stripped.splitlines()):
        return True
    return False


# ── CC-G-01 ───────────────────────────────────────────────────────────────────


def check_g01(spec_path: Path, spec) -> Verdict:
    """`spec.md` exists at its path; ten headings, exact names, exact order."""
    a = "CC-G-01"
    if spec is None:
        return fail(a, ["spec"], [Finding(
            element=str(spec_path),
            problem="spec.md is not present at specs/NNN-feature/spec.md",
            fix="author the spec at its path, or correct the feature argument",
        )])

    found = spec.heading_order
    findings = []

    missing = [h for h in SPEC_HEADINGS if h not in found]
    for h in missing:
        findings.append(Finding(
            element="§%d %s" % (SECTION_NUMBER[h], h),
            problem="required heading absent",
            fix='add "## %s" in its standard §2 position' % h,
            location=spec_path.name,
        ))

    extra = [h for h in found if h not in SPEC_HEADINGS]
    for h in extra:
        findings.append(Finding(
            element=h,
            problem="heading is not one of the ten standard §2 headings",
            fix="rename it to its standard heading or remove the section",
            location="%s:%d" % (spec_path.name, spec.section(h).heading_line),
        ))

    if not missing and not extra:
        present = [h for h in found if h in SPEC_HEADINGS]
        if present != SPEC_HEADINGS:
            findings.append(Finding(
                element="heading order",
                problem=("the ten headings are present but out of standard §2 "
                         "order (found: %s)" % " · ".join(present)),
                fix="reorder the sections to the standard §2 sequence",
                location=spec_path.name,
            ))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "10/10 headings, exact names, exact order")


def inventory(spec) -> dict:
    """The Stage-1 ID inventory the later stages read."""
    return {
        "US": [s.id for s in spec.stories],
        "FR": [r.id for r in spec.requirements],
        "BR": [r.id for r in spec.rules],
        "NFR": [n.id for n in spec.nfrs],
        "acceptance": {s.id: [a.handle for a in s.acceptance]
                       for s in spec.stories},
    }


def main(argv=None) -> int:
    p = base_parser("Stage 1: CC-G-01, document parse, ID inventory")
    p.add_argument("--inventory", action="store_true",
                   help="print the Stage-1 ID inventory as JSON and exit")
    args = p.parse_args(argv)

    path = resolve_spec(args)
    spec = parse_spec(path) if path.is_file() else None

    if args.inventory:
        if spec is None:
            runtime_defect("spec not found at %s" % path)
        json.dump(inventory(spec), sys.stdout, indent=2, ensure_ascii=False)
        sys.stdout.write("\n")
        return 0

    return emit("sk_structure", [check_g01(path, spec)], args.format)


if __name__ == "__main__":
    raise SystemExit(main())
