#!/usr/bin/env python3
"""sk_sections — CC-FL-02 · CC-NF-02 · CC-BR-02 · CC-OS-01 (contract C5–C7, C10).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §5 C5 / C6 / C7 / C10 · writing standard §6
(alternates & errors table) · §7 (the six NFR categories) · §8 (BR-IDs) ·
§11 (Out of Scope).

  CC-FL-02  ≥ 1 alternate or error path documented; happy-path-only fails.
  CC-NF-02  all six categories carry ≥ 1 NFR or an explicit `N/A — <reason>`.
  CC-BR-02  BR-IDs unique; every BR referenced from FRs, acceptance or flows
            exists.
  CC-OS-01  the section contains ≥ 1 exclusion.

**CC-NF-02's machine-readable form** — an S2 implementation freedom inside the
pinned coverage (build plan §2.4's clustering note, applied to recognition).
The contract fixes *what* is checked ("six categories carry ≥ 1 NFR or an
explicit `N/A — <reason>`; silence fails"); neither it nor standard §7 fixes a
parseable shape. Three forms are accepted, and a category recognised by none of
them counts as silent:

    1.  NFR-0NN (<category>) — <metric + target + condition>
    2.  - <Category>: N/A — <reason>            (or "— N/A — <reason>")
    3.  | <Category> | … |                      (a table row led by the category)

A bare keyword occurrence never counts — "Availability search returns results
within 2 seconds" is a *performance* NFR that happens to contain the word
"availability", and a substring scan would silently pass the availability
category on it. That false pass is the class the whole gate exists to prevent
(gate §5.2), so the check demands a label, not a word. Recorded in BUILD-LOG S2;
the spec-template's §5 comment is a recompile candidate for the next bump.

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
    BR_REF_RE, Finding, base_parser, emit, fail, load_spec, ok, table_rows,
)

# ── CC-NF-02: the six categories (contract C6 · standard §7) ──────────────────

NF_CATEGORIES = [
    ("performance", ["performance"]),
    ("security/privacy", ["security/privacy", "security", "privacy"]),
    ("availability", ["availability"]),
    ("accessibility", ["accessibility"]),
    ("localization", ["localization", "localisation"]),
    ("scale", ["scale", "scalability"]),
]

NA_RE = re.compile(r"N/A\s*[—–-]\s*(?P<reason>\S.*)$", re.IGNORECASE)
NFR_TAGGED_RE = re.compile(r"^\s*(NFR-\d+)\s*\(\s*(?P<cat>[^)]+?)\s*\)\s*[—–-]\s*(?P<body>.+)$")
LABEL_RE = re.compile(r"^\s*[-*+]?\s*\**(?P<label>[A-Za-z/ ]+?)\**\s*[:—–-]\s*(?P<rest>.*)$")


def _label_matches(label: str, aliases) -> bool:
    norm = re.sub(r"\s+", " ", label).strip().lower().rstrip(":")
    return norm in [a.lower() for a in aliases]


def check_nf02(spec):
    a = "CC-NF-02"
    sec = spec.section("Non-Functional Requirements")
    if sec is None:
        return fail(a, ["spec"], [Finding(
            element="§5 Non-Functional Requirements",
            problem="section absent",
            fix="add the section and cover all six categories")])

    covered = {}
    for lineno, text in sec.lines:
        if spec.fenced[lineno - 1] or not text.strip():
            continue

        m = NFR_TAGGED_RE.match(text)
        if m:
            for canon, aliases in NF_CATEGORIES:
                if _label_matches(m.group("cat"), aliases):
                    covered.setdefault(canon, ("NFR", m.group(1), lineno))
            continue

        if text.strip().startswith("|"):
            cells = [c.strip() for c in text.strip().strip("|").split("|")]
            if cells and not all(re.fullmatch(r":?-{2,}:?", c or "") for c in cells):
                for canon, aliases in NF_CATEGORIES:
                    if _label_matches(cells[0], aliases) and len(cells) > 1 \
                            and cells[1].strip():
                        covered.setdefault(canon, ("row", cells[1].strip(), lineno))
            continue

        lm = LABEL_RE.match(text)
        if lm:
            rest = lm.group("rest").strip()
            for canon, aliases in NF_CATEGORIES:
                if not _label_matches(lm.group("label"), aliases):
                    continue
                na = NA_RE.search(rest)
                if na and na.group("reason").strip():
                    covered.setdefault(canon, ("N/A", na.group("reason").strip(),
                                               lineno))
                elif rest:
                    covered.setdefault(canon, ("NFR", rest, lineno))

    findings = []
    for canon, _ in NF_CATEGORIES:
        if canon in covered:
            continue
        findings.append(Finding(
            element=canon,
            problem="no NFR and no N/A — <reason>",
            fix="add one or declare N/A with a reason.",
            location="%s:%d" % (spec.path.name, sec.heading_line)))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "6/6 NFR categories covered (%s)"
              % ", ".join("%s: %s" % (c, covered[c][0]) for c, _ in NF_CATEGORIES))


# ── CC-FL-02 ──────────────────────────────────────────────────────────────────

ALT_HEAD_RE = re.compile(r"^\s*#{2,6}\s*.*(alternate|error|exception|unhappy)",
                         re.IGNORECASE)


def check_fl02(spec):
    a = "CC-FL-02"
    sec = spec.section("Flows, States & Errors")
    if sec is None:
        return fail(a, ["spec"], [Finding(
            element="§4 Flows, States & Errors",
            problem="section absent",
            fix="add the section with the main flow and its error paths")])

    rows = list(table_rows(sec.body))
    documented = [r for r in rows if any(c.strip() for c in r)]

    if not documented:
        # a prose alternate/error block also documents a path
        in_block = False
        for _, text in sec.lines:
            if ALT_HEAD_RE.match(text):
                in_block = True
                continue
            if in_block and re.match(r"^\s*(\d+\.|[-*+])\s+\S", text):
                documented = [["prose"]]
                break

    if not documented:
        return fail(a, ["spec"], [Finding(
            element="§4 Flows, States & Errors",
            problem="no alternate or error path — the flow is happy-path only",
            fix=("document every error path: trigger · system behavior · "
                 "user-visible outcome"),
            location="%s:%d" % (spec.path.name, sec.heading_line))])

    return ok(a, ["spec"], "%d alternate/error path(s) documented"
              % len(documented))


# ── CC-BR-02 ──────────────────────────────────────────────────────────────────


def check_br02(spec):
    a = "CC-BR-02"
    findings = []

    seen = {}
    for r in spec.rules:
        if r.id in seen:
            findings.append(Finding(
                element=r.id,
                problem="BR-ID used more than once (lines %d and %d)"
                        % (seen[r.id], r.lineno),
                fix="give the second rule its own next free BR-ID",
                location="%s:%d" % (spec.path.name, r.lineno)))
        else:
            seen[r.id] = r.lineno

    # references from FRs, acceptance and flows
    refs = {}
    for req in spec.requirements:
        for br in BR_REF_RE.findall(req.raw):
            refs.setdefault(br, []).append((req.id, req.lineno))
    for s in spec.stories:
        for item in s.acceptance:
            for br in BR_REF_RE.findall(item.text):
                refs.setdefault(br, []).append((item.handle, item.lineno))
    flows = spec.section("Flows, States & Errors")
    if flows:
        for lineno, text in flows.lines:
            for br in BR_REF_RE.findall(text):
                refs.setdefault(br, []).append(("§4 flows", lineno))

    for br, sites in sorted(refs.items()):
        if br in seen:
            continue
        where, lineno = sites[0]
        findings.append(Finding(
            element=br,
            problem="referenced from %s but not defined in §6 Business Rules"
                    % where,
            fix="define the rule with its BR-ID, or correct the reference",
            location="%s:%d" % (spec.path.name, lineno)))

    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d unique BR-IDs; %d reference(s) all resolve"
              % (len(seen), len(refs)))


# ── CC-OS-01 ──────────────────────────────────────────────────────────────────

EXCLUSION_RE = re.compile(r"^\s*[-*+]\s+(?P<text>\S.*)$")


def check_os01(spec):
    a = "CC-OS-01"
    sec = spec.section("Out of Scope")
    if sec is None:
        return fail(a, ["spec"], [Finding(
            element="§9 Out of Scope",
            problem="section absent",
            fix="add the section with at least one exclusion")])

    exclusions = []
    for lineno, text in sec.lines:
        if spec.fenced[lineno - 1] or text.strip().startswith("<!--"):
            continue
        m = EXCLUSION_RE.match(text)
        if m and not NA_RE.match(m.group("text").strip()):
            exclusions.append((lineno, m.group("text").strip()))

    if not exclusions:
        return fail(a, ["spec"], [Finding(
            element="§9 Out of Scope",
            problem="no exclusion listed",
            fix=("fence off what someone could plausibly expect this feature to "
                 "include — sibling features and adjacent epics always supply "
                 "one; the degenerate case takes a logged waiver, never a "
                 "silent N/A"),
            location="%s:%d" % (spec.path.name, sec.heading_line))])

    return ok(a, ["spec"], "%d exclusion(s) listed" % len(exclusions))


def main(argv=None) -> int:
    p = base_parser("CC-FL-02 · CC-NF-02 · CC-BR-02 · CC-OS-01")
    args = p.parse_args(argv)
    _, spec = load_spec(args)
    verdicts = [check_fl02(spec), check_nf02(spec), check_br02(spec),
                check_os01(spec)]
    return emit("sk_sections", verdicts, args.format)


if __name__ == "__main__":
    raise SystemExit(main())
