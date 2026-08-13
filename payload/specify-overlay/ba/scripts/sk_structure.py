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
    name: str                  # the canonical §2 name once normalised
    heading_line: int          # 1-based line number of the "## " line
    lines: list = field(default_factory=list)   # [(lineno, text)]
    raw_name: str = ""         # the heading exactly as authored

    def __post_init__(self):
        if not self.raw_name:
            self.raw_name = self.name

    @property
    def body(self) -> str:
        return "\n".join(t for _, t in self.lines)

    @property
    def number(self):
        return SECTION_NUMBER.get(self.name)

    @property
    def recognised(self) -> bool:
        return self.name in SECTION_NUMBER

    @property
    def normalised(self) -> bool:
        """True when the reader had to normalise the authored heading to read it."""
        return self.raw_name != self.name


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
    unrecognised: list = field(default_factory=list)   # Sections matching no §2 name

    def section(self, name: str):
        for s in self.sections:
            if s.name == name:
                return s
        return None

    def section_by_raw(self, raw_name: str):
        """Lookup by the heading as authored — CC-G-01's key, since it judges
        what the BA wrote rather than what the reader resolved."""
        for s in self.sections:
            if s.raw_name == raw_name:
                return s
        return None

    # ── recognition status (build-log S10 · orchestrator §10.4 D-O50) ─────────
    #
    # A section-keyed lookup that misses must never be read as "the spec has
    # none of that". Two different facts wear the same `None`, and the reader
    # is the only party that can tell them apart:
    #
    #   *absent*        — nothing in the document claims to be this section
    #   *unrecognised*  — the document carries headings the reader could not
    #                     match, and one of them may well be this section
    #
    # Consumers ask `section_miss()` and render what it returns; nobody prints
    # "section absent" unconditionally any more.

    @property
    def readable(self) -> bool:
        """False when no `##` heading resolved to one of the ten §2 names.

        The whole-document verdict: a spec that trips this is not a spec with
        no content — it is a spec this reader cannot read, and every count
        taken from it is a blind spot, not a measurement.
        """
        return any(s.recognised for s in self.sections)

    def section_miss(self, name: str) -> str:
        """Why `name` did not resolve — '' when it did.

        Returns the *problem* half of a §7 named-gap line, in found-vs-expected
        grammar when there is something to name.
        """
        if self.section(name) is not None:
            return ""
        if not self.unrecognised:
            return "section absent"
        shown = self.unrecognised[:3]
        found = " · ".join('"%s" (line %d)' % (s.raw_name, s.heading_line)
                           for s in shown)
        more = len(self.unrecognised) - len(shown)
        return ('section not found under its standard heading — the document '
                'carries %d unrecognised heading(s): %s%s; expected "## %s" '
                '(CC-G-01 lists them all)'
                % (len(self.unrecognised), found,
                   (" · …and %d more" % more) if more else "", name))

    def section_miss_fix(self, name: str, absent_fix: str) -> str:
        """The *fix* half: rename what is there, or author what is not."""
        if not self.unrecognised:
            return absent_fix
        return ('rename the heading that carries this content to exactly '
                '"## %s" (standard §2 — the skeleton\'s ordinals are the '
                'list\'s numbering, never part of the heading), or add the '
                'section if it is genuinely missing' % name)

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

# ── reader tolerance — ONE site, and this is it (standard §2) ─────────────────
#
# Two authoring habits are normalised before matching, and nothing else:
#
#   1.  "## 2. User Stories"      → "User Stories"    (the skeleton list's
#       ordinals typed into the heading — standard §2 states outright that they
#       are the list's numbering, not part of the heading)
#   2.  "**US1 (P1)** — As a …"   → "US1 (P1) — As a …"   (the ID emphasised)
#
# This is a **courtesy, not a second legal form** (standard §2, the
# reader-tolerance record). The canonical form stays unnumbered and unbold, and
# CC-G-01 still fails a numbered heading — `check_g01` judges `raw_name`, the
# heading as authored, precisely so that tolerance here cannot quietly legalise
# it. A table-form FR is NOT tolerated: `FR_RE` is unwidened by ruling (standard
# golden rule 4 · §4 — one SHALL is not a set of values), and a §3 that carries
# only rows reports *present, no parseable FR lines* rather than a silent zero.
#
# A second normalisation site is a second thing to drift — the rule this file
# already states about the WBS readers (sk_status §10 note). Do not add one.
HEADING_ORDINAL_RE = re.compile(r"^\d+\.\s+")
EMPH_ID_RE = re.compile(r"^(\s*)\*\*\s*((?:US\d+|FR-\d+|BR-\d+|NFR-\d+)[^*]*?)\s*\*\*")


def canonical_heading(raw: str) -> str:
    """The §2 heading a raw `## ` text denotes — the ordinal stripped if that
    is what makes it one of the ten. A heading that is not standard either way
    is returned unchanged, so it still reports as the BA wrote it."""
    stripped = HEADING_ORDINAL_RE.sub("", raw).strip()
    return stripped if stripped in SECTION_NUMBER else raw


def normalise_line(text: str) -> str:
    """Strip `**` wrapping an ID anchor at a line's start. Emphasis anywhere
    else in the line is untouched — only the anchor blocks recognition."""
    return EMPH_ID_RE.sub(r"\1\2", text)


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
            raw = m.group(1).strip()
            current = Section(name=canonical_heading(raw), heading_line=i,
                              raw_name=raw)
            sections.append(current)
            order.append(current.raw_name)      # CC-G-01 judges what was authored
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
        unrecognised=[s for s in sections if not s.recognised],
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
    joined = re.sub(r"\s+", " ", " ".join(parts)).strip()
    return normalise_line(joined)


def _parse_stories(sections, fenced):
    sec = next((s for s in sections if s.name == "User Stories"), None)
    if sec is None:
        return []

    starts = [
        n for n, t in sec.lines
        if not fenced[n - 1] and STORY_ID_RE.match(normalise_line(t))
        and not CHECKLIST_RE.match(t)
    ]

    stories = []
    for idx, start in enumerate(starts):
        start, end = _block_bounds(sec, starts, idx)
        block = [(n, t) for n, t in sec.lines if start <= n < end]
        raw = _joined_head(sec, start, end)

        sid = STORY_ID_RE.match(normalise_line(block[0][1])).group(1)
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
    starts = [n for n, t in sec.lines
              if not fenced[n - 1] and FR_RE.match(normalise_line(t))]
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


# ── present-but-unparseable, inside a recognised section ─────────────────────
#
# The second half of the same law. A recognised section whose anchored lines
# all failed to parse is *not* an empty section, and a consumer that prints
# "0 FRs" there is making the same claim the section-lookup miss made: that the
# document says nothing, when in fact the reader read nothing.
#
# Table-form FRs are the case the field found (standard golden rule 4 forbids
# them and `FR_RE` stays unwidened by ruling), but the shape is general: any
# line carrying an ID of the section's class that produced no record.

ID_MENTION = {
    "FR": re.compile(r"\bFR-\d+\b"),
    "BR": re.compile(r"\bBR-\d+\b"),
    "NFR": re.compile(r"\bNFR-\d+\b"),
    "US": re.compile(r"\bUS\d+\b"),
}


def unparsed_report(spec, section_name: str, kind: str, parsed) -> str:
    """A phrase naming what a recognised section carries but the reader could
    not parse — '' when the section is absent, or when anything did parse.

    The point is to make a zero *loud*: "present, no parseable FR lines,
    5 table row(s) carrying FR IDs" is a fact about the shape; "0" is a false
    fact about the project.
    """
    sec = spec.section(section_name)
    if sec is None or parsed:
        return ""
    mention = ID_MENTION[kind]
    rows = [r for r in table_rows(sec.body) if any(mention.search(c) for c in r)]
    loose = [n for n, t in sec.lines
             if not spec.fenced[n - 1] and mention.search(t)
             and not t.strip().startswith("|")]
    if not rows and not loose:
        return ""
    carried = []
    if rows:
        carried.append("%d table row(s) carrying %s IDs" % (len(rows), kind))
    if loose:
        carried.append("%d line(s) mentioning an %s ID in a shape the standard "
                       "does not define" % (len(loose), kind))
    return ("section present, no parseable %s lines — %s. %s statements are "
            "lines, never table rows (standard §4 · golden rule 4)"
            % (kind, "; ".join(carried), kind))


def _parse_ids(sections, fenced, section_name, pattern, ctor):
    sec = next((s for s in sections if s.name == section_name), None)
    if sec is None:
        return []
    out = []
    starts = [n for n, t in sec.lines
              if not fenced[n - 1] and pattern.match(normalise_line(t))]
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


PARSE_BLOCKER = ("CC-G-01 — no `##` heading matched standard §2, so nothing "
                 "in the spec could be read")


def blocked_on_unreadable(spec, verdicts):
    """Downgrade PASS to SKIPPED when the spec could not be read at all.

    A PASS is a claim about the spec. On a spec whose headings resolved to
    none of the ten, no checker is entitled to one: `0 banned words in 0
    scanned lines` and `0 unique BR-IDs` are the same silent zero the field
    report found on the dashboard, wearing a green verdict instead of a count.

    A FAIL stands — it is usually the found-vs-expected line naming the real
    problem, and suppressing it would hide the diagnosis. SKIPPED is the gate's
    own instrument for *not evaluated* (§5.1), so this reports the blind spot
    in the grammar the gate already has, and invents nothing.
    """
    if spec is None or spec.readable:
        return verdicts
    return [v if v.verdict == "FAIL"
            else skipped(v.assertion, v.checks, PARSE_BLOCKER)
            for v in verdicts]


# ── the same law, one grain down: the section (D139 · gate §5.1) ──────────────
#
# A *readable* spec can still hand a checker a zero it never measured: §3 is
# present, and every requirement in it is a table row. `blocked_on_unreadable`
# does not fire — the spec is readable — so the assertions that merely count
# parsed FRs rendered `0/0 FRs carry exactly one SHALL` in green, beside
# CC-FR-01's red about the same section. Same instrument, one grain down.
#
# The predicate is `unparsed_report()` itself, unchanged: it is already the
# *present · carries IDs of its class · parsed nothing* test, and it returns ""
# for a section that is absent, that parsed something, or that is **genuinely
# empty**. A genuinely empty section's zero is a measurement and it stands
# (gate §5.1) — this downgrade is only ever about a zero the reader produced.
#
# The blocker is led by the assertion that FAILs on the shape where the M set
# carries one, and is the gap line alone where it does not: §6 Business Rules
# has no M assertion that fails on an unparseable §6, and gate §6.1's
# any-skip-forces-FAIL rule is what holds the floor there.

SECTION_CLASS = {
    # section name                  ID kind · the Spec field the checkers count
    #                               · the assertion that FAILs on the shape
    "User Stories":                ("US",  "stories",      "CC-US-01"),
    "Functional Requirements":     ("FR",  "requirements", "CC-FR-01"),
    "Business Rules":              ("BR",  "rules",        ""),
    "Non-Functional Requirements": ("NFR", "nfrs",         ""),
}


def unparsed_blocker(spec, section_name: str) -> str:
    """The blocker line for a section present but parsed nothing — '' when the
    section parsed, is absent, or is genuinely empty."""
    kind, field_name, assertion = SECTION_CLASS[section_name]
    report = unparsed_report(spec, section_name, kind, getattr(spec, field_name))
    if not report:
        return ""
    return "%s§%d %s: %s" % ("%s — " % assertion if assertion else "",
                             SECTION_NUMBER[section_name], section_name, report)


def blocked_on_unparsed(spec, verdicts, scopes):
    """Downgrade a PASS whose count is zero because its section did not parse.

    `scopes` maps an assertion ID to the section names its evidence counts
    objects out of. A FAIL is never touched (gate §5.1) — it is normally the
    found-vs-expected line naming the parse gap itself, and suppressing it
    would hide the diagnosis.
    """
    out = []
    for v in verdicts:
        blockers = [b for b in (unparsed_blocker(spec, s)
                                for s in scopes.get(v.assertion, ()))
                    if b]
        out.append(skipped(v.assertion, v.checks, " · ".join(blockers))
                   if v.verdict == "PASS" and blockers else v)
    return out


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

    found = spec.heading_order          # headings as authored
    findings = []

    # *Absent* means nothing in the document resolved to it — a heading the
    # reader normalised is present, and is reported below as the form error it
    # is, never as a missing section. Reporting it twice would send the BA to
    # author a section that already exists (the field report's sharpest line).
    missing = [h for h in SPEC_HEADINGS if spec.section(h) is None]
    for h in missing:
        findings.append(Finding(
            element="§%d %s" % (SECTION_NUMBER[h], h),
            problem="required heading absent",
            fix='add "## %s" in its standard §2 position' % h,
            location=spec_path.name,
        ))

    extra = [h for h in found if h not in SPEC_HEADINGS]
    for h in extra:
        sec = spec.section_by_raw(h)
        # A heading the reader normalised is still a heading the standard does
        # not allow: tolerance is a courtesy, not a second legal form
        # (standard §2). Say both things — the content was read, the form is
        # still wrong — so the BA is not left thinking the section vanished.
        if sec is not None and sec.normalised:
            problem = ('heading carries the §2 skeleton\'s ordinal — the '
                       'ordinals are that list\'s numbering, never part of the '
                       'heading; its content was read as "%s"' % sec.name)
            fix = 'rename it to exactly "## %s"' % sec.name
        else:
            problem = "heading is not one of the ten standard §2 headings"
            fix = "rename it to its standard heading or remove the section"
        findings.append(Finding(
            element=h,
            problem=problem,
            fix=fix,
            location="%s:%d" % (spec_path.name,
                                sec.heading_line if sec else 0),
        ))

    if not missing and not extra:
        present = [s.name for s in spec.sections if s.recognised]
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
