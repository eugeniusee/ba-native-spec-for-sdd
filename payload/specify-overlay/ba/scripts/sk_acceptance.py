#!/usr/bin/env python3
"""sk_acceptance — CC-AC-01 (contract C3).

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §5 C3 · writing standard §5 (one slot, two
forms — checklist line or Gherkin scenario, directly beneath the story).

  CC-AC-01  every story carries ≥ 1 acceptance item directly beneath it.

"Directly beneath" is the parse's own boundary: an acceptance item belongs to
the story whose block it sits in — from that story's line to the next story's
line, or to the end of §2 (sk_structure). Items that drift below the last story
belong to it; items above the first story belong to no story and are reported,
because an acceptance item with no story is the mirror hole CC-TR-01 names on
the FR side.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import sys
from pathlib import Path

# No bytecode: these scripts import one another (sk_structure is the shared
# parse surface), and a __pycache__ directory inside the installed
# `.specify/ba/scripts/` would join the install manifest's hash list and
# make it rot on first use.
sys.dont_write_bytecode = True


sys.path.insert(0, str(Path(__file__).resolve().parent))

from sk_structure import (  # noqa: E402
    Finding, base_parser, emit, fail, load_spec, ok,
)


def check_ac01(spec):
    a = "CC-AC-01"
    if not spec.stories:
        return fail(a, ["spec"], [Finding(
            element="§2 User Stories",
            problem="no stories, so no acceptance can be attached",
            fix="author the stories first (CC-US-01), each with its acceptance",
        )])

    findings = []
    for s in spec.stories:
        if s.acceptance:
            continue
        findings.append(Finding(
            element=s.id,
            problem="no acceptance item beneath the story",
            fix=("add at least one acceptance item directly beneath it — a "
                 "checklist line for a simple rule, a Gherkin scenario with "
                 "concrete data for non-trivial behavior"),
            location="%s:%d" % (spec.path.name, s.lineno),
        ))
    if findings:
        return fail(a, ["spec"], findings)

    total = sum(len(s.acceptance) for s in spec.stories)
    return ok(a, ["spec"], "%d/%d stories carry acceptance (%d items)"
              % (len(spec.stories), len(spec.stories), total))


def main(argv=None) -> int:
    p = base_parser("CC-AC-01 — acceptance criteria (contract C3)")
    args = p.parse_args(argv)
    _, spec = load_spec(args)
    return emit("sk_acceptance", [check_ac01(spec)], args.format)


if __name__ == "__main__":
    raise SystemExit(main())
