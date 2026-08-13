#!/usr/bin/env python3
"""sk_ears — CC-FR-01 (vendored EARS lint) · CC-FR-02 · CC-FR-05 (contract C4).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §5 C4 · writing standard §4 (the five EARS
patterns, keywords in CAPS, one SHALL per requirement, `FR-0NN (US<n>)`).

  CC-FR-01  every FR parses as exactly one of the five EARS patterns or a legal
            combination; keywords capitalized.            [non-waivable]
  CC-FR-02  exactly one SHALL per FR; no "or" alternation between responses.
  CC-FR-05  every FR carries `FR-0NN (US<n>)`; the story exists; FR-IDs unique;
            deleted IDs not reused.

**The lint is vendored, not delegated** (build plan §2.4): the grammar below is
standard §4's five patterns written as patterns, with no upstream dependency.

    ubiquitous        THE SYSTEM SHALL <response>
    event-driven      WHEN <trigger>, THE SYSTEM SHALL <response>
    state-driven      WHILE <state>, THE SYSTEM SHALL <response>
    unwanted          IF <condition>, THEN THE SYSTEM SHALL <response>
    optional feature  WHERE <feature included>, THE SYSTEM SHALL <response>
    combination       WHERE…, WHILE…, WHEN…/IF…THEN, THE SYSTEM SHALL <response>

The combination form is the standard's own ("WHILE <state>, WHEN <trigger>,
THE SYSTEM SHALL <response>") generalised to the prefix order WHERE → WHILE →
WHEN|IF; each prefix is optional, the `THE SYSTEM SHALL <response>` core is not.

CC-FR-02's alternation test reads the response clause with quoted spans and
parentheticals masked, so an enum (`status "Booked" or "Cancelled"`) is not an
alternation while two alternative responses are.

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
    Finding, base_parser, emit, fail, load_spec, ok, parse_spec, runtime_defect,
    unparsed_report,
    blocked_on_unreadable,
)

CORE = r"THE SYSTEM SHALL\s+(?P<response>\S.*)$"
EARS_RE = re.compile(
    r"^(?P<where>WHERE\s+.+?,\s+)?"
    r"(?P<while_>WHILE\s+.+?,\s+)?"
    r"(?:(?P<when>WHEN\s+.+?,\s+)|(?P<if_>IF\s+.+?,\s+THEN\s+))?"
    + CORE
)
EARS_RE_I = re.compile(EARS_RE.pattern, re.IGNORECASE)

QUOTED_RE = re.compile(r"\"[^\"\n]*\"|“[^”\n]*”|\([^)\n]*\)")
SHALL_RE = re.compile(r"\bSHALL\b")
FR_ID_RE = re.compile(r"^FR-\d{3}$")


def pattern_name(m) -> str:
    parts = []
    if m.group("where"):
        parts.append("optional-feature")
    if m.group("while_"):
        parts.append("state-driven")
    if m.group("when"):
        parts.append("event-driven")
    if m.group("if_"):
        parts.append("unwanted-behavior")
    if not parts:
        return "ubiquitous"
    return "+".join(parts) if len(parts) > 1 else parts[0]


def _mask(text: str) -> str:
    return QUOTED_RE.sub(lambda m: " " * len(m.group(0)), text)


# ── CC-FR-01 ──────────────────────────────────────────────────────────────────


def check_fr01(spec):
    a = "CC-FR-01"
    if not spec.requirements:
        # *Zero* is only honest when the section was read and held nothing.
        # A §3 that is present but written in a shape this reader does not
        # parse — table rows, the field case — says so instead: a count the
        # source does not support is the thing §10.4 forbids.
        name = "Functional Requirements"
        if spec.section(name) is None:
            problem = spec.section_miss(name)
            fix = spec.section_miss_fix(
                name, "author the FRs in EARS form, each linked to its story")
        else:
            problem = (unparsed_report(spec, name, "FR", spec.requirements)
                       or "zero functional requirements")
            fix = ("rewrite each requirement as a line — "
                   "`FR-0NN (US<n>) — <EARS text>` (standard §4)"
                   if unparsed_report(spec, name, "FR", spec.requirements)
                   else "author the FRs in EARS form, each linked to its story")
        return fail(a, ["spec"], [Finding(
            element="§3 Functional Requirements",
            problem=problem,
            fix=fix,
        )])

    findings = []
    parsed = {}
    for r in spec.requirements:
        body = r.text.rstrip()
        body = body[:-1] if body.endswith(".") else body
        m = EARS_RE.match(body)
        if m and m.group("response").strip(" ."):
            parsed[r.id] = pattern_name(m)
            continue
        mi = EARS_RE_I.match(body)
        if mi and mi.group("response").strip(" ."):
            findings.append(Finding(
                element=r.id,
                problem="EARS keywords are not capitalized",
                fix="write WHEN / WHILE / IF / THEN / WHERE / THE SYSTEM SHALL in CAPS",
                evidence=r.raw, location="%s:%d" % (spec.path.name, r.lineno)))
            continue
        findings.append(Finding(
            element=r.id,
            problem="does not parse as one of the five EARS patterns",
            fix=("rewrite it in an EARS pattern, or re-classify it — what "
                 "resists EARS is nearly always an NFR, a business rule, or "
                 "design in disguise"),
            evidence=r.raw, location="%s:%d" % (spec.path.name, r.lineno)))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d/%d FRs parse EARS"
              % (len(parsed), len(spec.requirements)))


# ── CC-FR-02 ──────────────────────────────────────────────────────────────────


def check_fr02(spec):
    a = "CC-FR-02"
    findings = []
    for r in spec.requirements:
        n = len(SHALL_RE.findall(r.text))
        if n != 1:
            findings.append(Finding(
                element=r.id,
                problem=("%d SHALLs in one requirement" % n) if n > 1
                        else "no SHALL",
                fix=("split it into one requirement per behavior, one SHALL each"
                     if n > 1 else
                     "state the system response with exactly one SHALL"),
                evidence=r.raw, location="%s:%d" % (spec.path.name, r.lineno)))
            continue
        m = EARS_RE.match(r.text) or EARS_RE_I.match(r.text)
        response = m.group("response") if m else r.text.split("SHALL", 1)[-1]
        masked = _mask(response)
        if re.search(r"\bor\b", masked, re.IGNORECASE):
            findings.append(Finding(
                element=r.id,
                problem='"or" alternation between responses',
                fix=("split the alternatives into separate requirements, each "
                     "with its own trigger and one response"),
                evidence=response.strip(),
                location="%s:%d" % (spec.path.name, r.lineno)))
    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d/%d FRs carry exactly one SHALL, no alternation"
              % (len(spec.requirements), len(spec.requirements)))


# ── CC-FR-05 ──────────────────────────────────────────────────────────────────


def check_fr05(spec, hist_path, retired):
    a = "CC-FR-05"
    findings = []
    story_ids = {s.id for s in spec.stories}

    seen = {}
    for r in spec.requirements:
        if not FR_ID_RE.match(r.id):
            findings.append(Finding(
                element=r.id,
                problem="ID is not in the FR-0NN form",
                fix="renumber it as FR-0NN",
                location="%s:%d" % (spec.path.name, r.lineno)))
        if r.id in seen:
            findings.append(Finding(
                element=r.id,
                problem="FR-ID used more than once (lines %d and %d)"
                        % (seen[r.id], r.lineno),
                fix="give the second requirement its own next free FR-ID",
                location="%s:%d" % (spec.path.name, r.lineno)))
        else:
            seen[r.id] = r.lineno

        if not r.tagged or not r.us_refs:
            findings.append(Finding(
                element=r.id,
                problem="no story link — the requirement is scope creep",
                fix="tag it FR-0NN (US<n>) naming the story it builds",
                evidence=r.raw, location="%s:%d" % (spec.path.name, r.lineno)))
        else:
            for us in r.us_refs:
                if us not in story_ids:
                    findings.append(Finding(
                        element=r.id,
                        problem='references %s, which does not exist' % us,
                        fix="point it at an existing story, or author that story",
                        evidence=r.raw,
                        location="%s:%d" % (spec.path.name, r.lineno)))

    for rid in retired:
        if rid in seen:
            findings.append(Finding(
                element=rid, problem="retired FR-ID reused",
                fix="assign the next free FR-ID; retired IDs are never reused",
                location="%s:%d" % (spec.path.name, seen[rid])))

    basis = "no prior revision"
    if hist_path:
        hp = Path(hist_path)
        if not hp.is_file():
            runtime_defect("prior revision not found at %s" % hp)
        prior = parse_spec(hp)
        basis = "vs %s (%d prior FRs)" % (hp.name, len(prior.requirements))
        prior_by_id = {r.id: r for r in prior.requirements}
        for r in spec.requirements:
            old = prior_by_id.get(r.id)
            if old is None:
                continue
            if _core(old.text) != _core(r.text) and \
               sorted(old.us_refs) != sorted(r.us_refs):
                findings.append(Finding(
                    element=r.id,
                    problem=("ID carries a different requirement than in the "
                             "prior revision (was linked to %s)"
                             % ", ".join(old.us_refs or ["—"])),
                    fix=("restore it, or give the new behavior the next free "
                         "FR-ID — a deleted ID is never reused"),
                    evidence=r.raw,
                    location="%s:%d" % (spec.path.name, r.lineno)))

    if findings:
        return fail(a, ["spec", "hist"], findings)
    return ok(a, ["spec", "hist"],
              "%d FRs, unique IDs, every story link resolves (%s)"
              % (len(spec.requirements), basis))


def _core(text: str) -> str:
    return re.sub(r"\s+", " ", (text or "")).strip().lower()


def main(argv=None) -> int:
    p = base_parser("CC-FR-01 · CC-FR-02 · CC-FR-05 (contract C4)")
    p.add_argument("--hist", help="prior spec revision, for the ID-reuse check")
    p.add_argument("--retired", default="",
                   help="comma-separated FR-IDs retired in earlier revisions")
    args = p.parse_args(argv)

    _, spec = load_spec(args)
    retired = [r.strip() for r in args.retired.split(",") if r.strip()]
    verdicts = [check_fr01(spec), check_fr02(spec),
                check_fr05(spec, args.hist, retired)]
    return emit("sk_ears", blocked_on_unreadable(spec, verdicts), args.format)


if __name__ == "__main__":
    raise SystemExit(main())
