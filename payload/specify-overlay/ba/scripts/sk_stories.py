#!/usr/bin/env python3
"""sk_stories — CC-US-01…04 (contract C2).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §5 C2 · writing standard §3 (story form, the
"as a user" ban, P1–P3, stable IDs) · catalogue b4 T-12 §5 (the `## Roles`
table this checker reads verbatim).

  CC-US-01  ≥ 1 story; every story matches the standard §3 form with all three
            clauses filled.
  CC-US-02  every story actor matches a role defined verbatim in
            roles-permissions.md — "user" and persona names fail.
  CC-US-03  exactly one priority per story; the feature has ≥ 1 P1.
  CC-US-04  story IDs unique; IDs of deleted stories not reused (vs `hist`).

CC-US-04's `hist` reach, on the record (build plan §3.2): with one prior
revision the mechanically decidable form of "not reused" is *an ID whose story
changed identity between revisions*. Compared on the normalised actor +
capability clauses. A `--retired` list carries IDs the BA has retired across
more than one revision (the corpus's US4, dropped at r5→r6); any listed ID
reappearing fails. Both are named-gap-grammar failures naming the ID.

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
    Finding, base_parser, emit, fail, load_spec, memory, ok, parse_spec,
    runtime_defect, table_rows,
    blocked_on_unparsed, blocked_on_unreadable,
)

# CC-US-02/03/04 count nothing but §2's parsed stories: on a §2 that is present
# and carries US IDs in a shape the reader does not parse, their zero is the
# reader's, not the spec's — SKIPPED, not PASS (gate §5.1, section grain;
# build-log D139). CC-US-01 is untouched: it is the FAIL these three cite.
US_SCOPE = {"CC-US-02": ("User Stories",),
            "CC-US-03": ("User Stories",),
            "CC-US-04": ("User Stories",)}

EMPHASIS_RE = re.compile(r"[*_`]")


def normalise(text: str) -> str:
    return re.sub(r"\s+", " ", EMPHASIS_RE.sub("", text or "")).strip().lower()


def clean_actor(text: str) -> str:
    return re.sub(r"\s+", " ", EMPHASIS_RE.sub("", text or "")).strip()


# ── roles-permissions.md — the verbatim role registry ─────────────────────────


def defined_roles(roles_path: Path):
    """The Role column of the `## Roles` table (catalogue b4 T-12 §5)."""
    text = roles_path.read_text(encoding="utf-8")
    body = None
    for chunk in re.split(r"^##\s+", text, flags=re.M)[1:]:
        head, _, rest = chunk.partition("\n")
        if head.strip().lower().startswith("roles"):
            body = rest
            break
    if body is None:
        body = text
    roles = []
    for cells in table_rows(body):
        if not cells:
            continue
        name = clean_actor(cells[0])
        if name and name not in roles:
            roles.append(name)
    return roles


# ── CC-US-01 ──────────────────────────────────────────────────────────────────


def check_us01(spec):
    a = "CC-US-01"
    if not spec.stories:
        return fail(a, ["spec"], [Finding(
            element="§2 User Stories",
            problem="zero user stories",
            fix=("author at least one story in the standard §3 form: "
                 "US<N> (P<1|2|3>) — As a <role>, I want <capability>, "
                 "so that <value>"),
        )])

    findings = []
    for s in spec.stories:
        if s.well_formed and s.actor and s.capability and s.value:
            continue
        if not s.well_formed:
            problem = ("does not match US<N> (P<1|2|3>) — As a <role>, "
                       "I want <capability>, so that <value>")
        else:
            empty = [n for n, v in (("role", s.actor), ("capability", s.capability),
                                    ("value", s.value)) if not v]
            problem = "the %s clause is empty" % " and ".join(empty)
        findings.append(Finding(
            element=s.id, problem=problem,
            fix="rewrite the story to the standard §3 form with all three clauses filled",
            evidence=s.raw, location="%s:%d" % (spec.path.name, s.lineno),
        ))
    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "%d/%d stories parse the standard §3 form"
              % (len(spec.stories), len(spec.stories)))


# ── CC-US-02 ──────────────────────────────────────────────────────────────────


def check_us02(spec, roles_path: Path):
    a = "CC-US-02"
    if not roles_path.is_file():
        runtime_defect("roles-permissions.md not found at %s" % roles_path)
    roles = defined_roles(roles_path)
    if not roles:
        runtime_defect("no roles parsed from %s — the Roles table is empty"
                       % roles_path)

    lowered = {r.lower(): r for r in roles}
    findings = []
    for s in spec.stories:
        actor = clean_actor(s.actor)
        if not actor:
            continue                       # CC-US-01 owns the empty clause
        if actor in roles:
            continue
        if actor.lower() in lowered:
            findings.append(Finding(
                element=s.id,
                problem=('actor "%s" does not match role "%s" verbatim'
                         % (actor, lowered[actor.lower()])),
                fix='use the role exactly as roles-permissions.md defines it',
                evidence=s.raw, location="%s:%d" % (spec.path.name, s.lineno),
            ))
            continue
        findings.append(Finding(
            element=s.id,
            problem=('actor "%s" is not a role defined in roles-permissions.md'
                     % actor),
            fix=("use a defined role, or add the role to roles-permissions.md "
                 "first (a governance change) and then reference it"),
            evidence=s.raw, location="%s:%d" % (spec.path.name, s.lineno),
        ))
    if findings:
        return fail(a, ["spec", "roles"], findings)
    return ok(a, ["spec", "roles"],
              "%d/%d story actors matched verbatim against %d defined role(s)"
              % (len(spec.stories), len(spec.stories), len(roles)))


# ── CC-US-03 ──────────────────────────────────────────────────────────────────


def check_us03(spec):
    a = "CC-US-03"
    findings = []
    for s in spec.stories:
        n = len(s.priorities_found)
        if n == 1:
            continue
        if n == 0:
            findings.append(Finding(
                element=s.id, problem="no priority",
                fix="add exactly one priority — (P1), (P2) or (P3)",
                evidence=s.raw, location="%s:%d" % (spec.path.name, s.lineno)))
        else:
            findings.append(Finding(
                element=s.id,
                problem="%d priorities (%s)" % (n, ", ".join(s.priorities_found)),
                fix="keep exactly one priority",
                evidence=s.raw, location="%s:%d" % (spec.path.name, s.lineno)))

    if spec.stories and not any("P1" in s.priorities_found for s in spec.stories):
        findings.append(Finding(
            element="§2 User Stories",
            problem="no P1 story — the feature has no story it fails without",
            fix="promote the story the feature cannot ship without to P1",
            location=spec.path.name))

    if findings:
        return fail(a, ["spec"], findings)
    p1 = sum(1 for s in spec.stories if "P1" in s.priorities_found)
    return ok(a, ["spec"], "%d stories, one priority each; %d × P1"
              % (len(spec.stories), p1))


# ── CC-US-04 ──────────────────────────────────────────────────────────────────


def check_us04(spec, hist_path, retired):
    a = "CC-US-04"
    findings = []

    seen = {}
    for s in spec.stories:
        if s.id in seen:
            findings.append(Finding(
                element=s.id,
                problem="story ID used more than once (lines %d and %d)"
                        % (seen[s.id], s.lineno),
                fix="give the second story its own next free US-ID",
                location="%s:%d" % (spec.path.name, s.lineno)))
        else:
            seen[s.id] = s.lineno

    for rid in retired:
        if rid in seen:
            findings.append(Finding(
                element=rid,
                problem="retired story ID reused",
                fix="assign the next free US-ID; retired IDs are never reused",
                location="%s:%d" % (spec.path.name, seen[rid])))

    basis = "no prior revision"
    if hist_path:
        hp = Path(hist_path)
        if not hp.is_file():
            runtime_defect("prior revision not found at %s" % hp)
        prior = parse_spec(hp)
        prior_by_id = {s.id: s for s in prior.stories}
        basis = "vs %s (%d prior stories)" % (hp.name, len(prior.stories))
        for s in spec.stories:
            old = prior_by_id.get(s.id)
            if old is None:
                continue
            if normalise(old.capability) != normalise(s.capability) or \
               normalise(old.actor) != normalise(s.actor):
                findings.append(Finding(
                    element=s.id,
                    problem=('ID carries a different story than in the prior '
                             'revision (was "%s / %s")'
                             % (clean_actor(old.actor), old.capability)),
                    fix=("restore the story, or give the new capability the next "
                         "free US-ID — a deleted ID is never reused"),
                    evidence=s.raw,
                    location="%s:%d" % (spec.path.name, s.lineno)))

    if findings:
        return fail(a, ["spec", "hist"], findings)
    return ok(a, ["spec", "hist"],
              "%d unique story IDs, none reused (%s)" % (len(seen), basis))


def main(argv=None) -> int:
    p = base_parser("CC-US-01…04 — user stories (contract C2)")
    p.add_argument("--roles", help="path to roles-permissions.md")
    p.add_argument("--hist", help="prior spec revision, for the ID-reuse check")
    p.add_argument("--retired", default="",
                   help="comma-separated US-IDs retired in earlier revisions")
    args = p.parse_args(argv)

    _, spec = load_spec(args)
    roles_path = Path(args.roles) if args.roles else memory(args.root,
                                                            "roles-permissions.md")
    retired = [r.strip() for r in args.retired.split(",") if r.strip()]

    verdicts = [
        check_us01(spec),
        check_us02(spec, roles_path),
        check_us03(spec),
        check_us04(spec, args.hist, retired),
    ]
    verdicts = blocked_on_unparsed(spec, verdicts, US_SCOPE)
    return emit("sk_stories", blocked_on_unreadable(spec, verdicts), args.format)


if __name__ == "__main__":
    raise SystemExit(main())
