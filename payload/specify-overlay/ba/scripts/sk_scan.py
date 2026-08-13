#!/usr/bin/env python3
"""sk_scan — CC-G-03 marker scan · CC-G-04 banned words · CC-XA-02 persona grep.

BA-Native Spec · vendored M checker (build plan §2.4).
Anchors: completeness contract §4 (CC-G-03, CC-G-04) · §5 C12 (CC-XA-02) ·
writing standard §4 (the banned-word list, vendored — no upstream dependency) ·
catalogue b2 T-04 §5 (TC-3: the screened set is `personas.md`'s names).

CC-G-04 scan scope is the contract's own wording — "stories, FRs, acceptance,
flows, business rules, NFRs" — i.e. skeleton §§2–6. Overview, Data,
Integration, Out of Scope and References are out of scope for this assertion by
construction.

Two compilation notes, on the record (build plan §3.2):

* **The list is vendored verbatim** from standard §4. The one transformation is
  a declared inflection set for the five verb entries (handle · support ·
  manage · improve · process), because the standard's own bad examples use
  inflected forms ("The system supports calendar integration"). Nothing else is
  stemmed, and no word outside the list is ever flagged.
* **"process (without an object)"** is the list's only conditional entry. It is
  implemented as: flag `process` unless the next token is a determiner, a
  possessive, a quotation mark, or a capitalised noun — the object test the
  standard's parenthetical states.

The quoted-copy exemption (contract CC-G-04) masks spans inside straight or
typographic double quotes before the scan runs.

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
    Finding, base_parser, emit, fail, load_spec, memory, ok,
    blocked_on_unreadable,
)

# ── the vendored banned-word list (writing standard §4) ───────────────────────

BANNED_SIMPLE = [
    "fast", "quickly", "easy", "simple", "user-friendly", "intuitive",
    "appropriate", "adequate", "sufficient", "efficient", "flexible",
    "robust", "seamless", "some", "several", "many", "minimal",
]

# verbs from the same list, with the declared inflection set
BANNED_VERBS = {
    "improve": ["improve", "improves", "improved", "improving"],
    "better": ["better"],
    "handle": ["handle", "handles", "handled", "handling"],
    "support": ["support", "supports", "supported", "supporting"],
    "manage": ["manage", "manages", "managed", "managing"],
}

BANNED_PHRASES = ["and/or", "as needed", "if necessary"]
BANNED_LITERAL = ["etc.", "TBD"]

# "process (without an object)" — the list's conditional entry
PROCESS_RE = re.compile(r"\bprocess(es|ed|ing)?\b(?P<tail>.{0,24})",
                        re.IGNORECASE)
OBJECT_LEAD = {
    "a", "an", "the", "this", "that", "these", "those", "each", "every",
    "any", "all", "its", "their", "his", "her", "our", "your", "my",
    "both", "either", "no",
}

MARKER_RE = re.compile(r"\[NEEDS CLARIFICATION(?::\s*(?P<q>[^\]]*))?\]")
QUOTED_RE = re.compile(r"\"[^\"\n]*\"|“[^”\n]*”")

BANNED_SCAN_SECTIONS = (
    "User Stories",
    "Functional Requirements",
    "Flows, States & Errors",
    "Non-Functional Requirements",
    "Business Rules",
)


def _mask_quoted(text: str) -> str:
    """Blank out verbatim user-visible copy inside quotation marks."""
    return QUOTED_RE.sub(lambda m: " " * len(m.group(0)), text)


def _banned_hits(line: str):
    """Yield (word, matched-text) for every banned entry in one masked line."""
    masked = _mask_quoted(line)

    for w in BANNED_SIMPLE:
        for m in re.finditer(r"\b%s\b" % re.escape(w), masked, re.IGNORECASE):
            yield w, m.group(0)

    for canonical, forms in BANNED_VERBS.items():
        for f in forms:
            for m in re.finditer(r"\b%s\b" % re.escape(f), masked, re.IGNORECASE):
                yield canonical, m.group(0)

    for p in BANNED_PHRASES:
        for m in re.finditer(r"\b%s\b" % re.escape(p), masked, re.IGNORECASE):
            yield p, m.group(0)

    for lit in BANNED_LITERAL:
        for m in re.finditer(re.escape(lit), masked, re.IGNORECASE):
            yield lit, m.group(0)

    for m in PROCESS_RE.finditer(masked):
        tail = m.group("tail").strip()
        if not tail:
            yield "process (without an object)", m.group(0).strip()
            continue
        first = re.split(r"[\s,.;:)]+", tail, maxsplit=1)[0]
        if not first:
            yield "process (without an object)", m.group(0).strip()
        elif first.lower() in OBJECT_LEAD or first[:1].isupper() or first[:1] == '"':
            continue                       # an object follows — legal use
        else:
            yield "process (without an object)", m.group(0).strip()


# ── CC-G-03 ───────────────────────────────────────────────────────────────────


def check_g03(spec):
    a = "CC-G-03"
    findings = []
    for i, line in enumerate(spec.lines, start=1):
        for m in MARKER_RE.finditer(line):
            question = (m.group("q") or "").strip()
            element = spec.element_at(i)
            findings.append(Finding(
                element=element,
                problem=('unresolved [NEEDS CLARIFICATION] marker%s'
                         % (' — "%s"' % question if question else "")),
                fix=("resolve it in the text, or convert it into a logged waiver "
                     "that names the open question"),
                evidence=line.strip(),
                location="%s:%d" % (spec.path.name, i),
            ))
    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "0 unresolved [NEEDS CLARIFICATION] markers")


# ── CC-G-04 ───────────────────────────────────────────────────────────────────


def check_g04(spec):
    a = "CC-G-04"
    findings = []
    scanned = 0
    for name in BANNED_SCAN_SECTIONS:
        sec = spec.section(name)
        if sec is None:
            continue
        for lineno, text in sec.lines:
            if spec.fenced[lineno - 1]:
                continue           # gherkin bodies are quoted-copy by nature
            if not text.strip():
                continue
            scanned += 1
            seen = set()
            for word, hit in _banned_hits(text):
                if word in seen:
                    continue
                seen.add(word)
                findings.append(Finding(
                    element=spec.element_at(lineno),
                    problem='banned word "%s"' % hit,
                    fix=("replace with a measurable target, or move the concern "
                         "to an NFR with metric + condition."),
                    evidence=text.strip(),
                    location="%s:%d" % (spec.path.name, lineno),
                ))
    if findings:
        return fail(a, ["spec"], findings)
    return ok(a, ["spec"], "0 banned words in %d scanned lines (§§2–6)" % scanned)


# ── CC-XA-02 ──────────────────────────────────────────────────────────────────

# A charter heading, per catalogue b2 T-04 §5: `## <Name> — details: <population>`
# (or the micro-example's bold form). The heading marker is required — without
# it the transformation-contract lines ("TC-1 — Details: exactly one register
# population…") parse as persona names, and a spec that mentions TC-1 would
# then fail a non-waivable assertion on a name that is not a persona.
PERSONA_HEAD_RE = re.compile(
    r"^\s*(?:#{1,6}\s+|\*\*)(?P<name>[A-Z][\w'’-]*)\s*[—–-]\s*details\s*:",
    re.IGNORECASE,
)


def persona_names(personas_path: Path):
    if not personas_path.is_file():
        return []                      # dormant: no charters, nothing screened
    names = []
    for line in personas_path.read_text(encoding="utf-8").splitlines():
        m = PERSONA_HEAD_RE.match(line.strip())
        if m:
            nm = m.group("name").strip()
            if nm and nm.lower() not in ("tc", "field") and nm not in names:
                names.append(nm)
    return names


def check_xa02(spec, personas_path: Path):
    a = "CC-XA-02"
    names = persona_names(personas_path)
    if not names:
        return ok(a, ["spec", "mem"],
                  "no personas.md charters — persona clause dormant")

    findings = []
    for i, line in enumerate(spec.lines, start=1):
        for nm in names:
            if re.search(r"\b%s\b" % re.escape(nm), line):
                findings.append(Finding(
                    element='persona "%s"' % nm,
                    problem=("persona name appears in the spec; authorization "
                             "derives from roles only"),
                    fix=("replace it with the role from roles-permissions.md "
                         "that carries the capability"),
                    evidence=line.strip(),
                    location="%s:%d" % (spec.path.name, i),
                ))
    if findings:
        return fail(a, ["spec", "mem"], findings)
    return ok(a, ["spec", "mem"],
              "%d persona name(s) screened, 0 occurrences" % len(names))


def main(argv=None) -> int:
    p = base_parser("CC-G-03 · CC-G-04 · CC-XA-02")
    p.add_argument("--personas", help="path to personas.md (default: memory/)")
    args = p.parse_args(argv)

    _, spec = load_spec(args)
    personas = Path(args.personas) if args.personas else memory(args.root,
                                                                "personas.md")

    verdicts = [check_g03(spec), check_g04(spec), check_xa02(spec, personas)]
    return emit("sk_scan", blocked_on_unreadable(spec, verdicts), args.format)


if __name__ == "__main__":
    raise SystemExit(main())
