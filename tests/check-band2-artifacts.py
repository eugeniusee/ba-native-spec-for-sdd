#!/usr/bin/env python3
"""BA-Native Spec — the Band-2 & spine artifact validator (S8).

Judges what T-17, T-18, Tier 1 and Tier 2 produce, against the shapes their
sheets and the elicitation document pin:

  roadmap.md         two sections · row grammar E-<nn> · Epic · Description ·
                     Phase · Status · Source · the phase ladder single-valued ·
                     the four-value status vocabulary · coverage against the
                     canvas capability ground
  roadmap.md log     numbered entries with trigger + BA · diff rows in from → to
                     form, each factor-tagged · Held + Basis, or the no-change
                     form · the log is the Phase column's ground · allocation
                     never creates or retires an epic
  <epic>.kit.md      parts A–D · question blocks destination-tagged and ranked ·
                     must-ask ≤ 12 · the Destination Test · assumption grammar ·
                     stakeholder-facing language
  <epic>.md          the nine sections, exact headings, exact order · the D4
                     open-question vocabulary · the D5 slicing vocabulary ·
                     capabilities not stories
  tier-2 session     GQ packets anchored and numbered · asked ≤ cap · every
                     recorded answer landing at every destination it named ·
                     surviving markers traceable · the brief write-back

WHAT THIS IS NOT.  The rules here are deliberately disjoint from the vendored M
checkers.  `sk_health` already judges CC-H-02 (a status per row; a diff and a
reason per allocation entry) and CC-H-03 (the brief ⇄ roadmap join); `sk_brief`
judges CC-XA-05; the whole `sk_*` family judges the spec.  Those are contract
assertions and they ship.  These are *sheet-shape* properties — grammar,
vocabulary, partition, depth — which no assertion reads and which therefore have
no runtime checker by construction.  What this validates is the fixture the
compiled prompts are asserted against, so those prompts stay honest.

B78's bound, stated because a silently weakened rule is worse than a missing one.
The sheet's coverage pass has two halves — no hole, no overlap.  Only the first
is mechanically derivable from the file: a Source cell legitimately carries
*derivation evidence* as well as ownership (E-01 cites the cancel line to justify
accounts; it does not claim it), so counting Source mentions cannot separate
"cites" from "owns", and an overlap verdict computed that way is noise.  The
corpus resolves genuine adjacency by a different instrument anyway — the kit's
part-D sibling boundary check, asked in the room.  So B78 judges coverage and the
run report owns exclusivity.  Coverage matching is at stem grade, which means a
citing-but-not-owning Source satisfies it: the rule under-reports holes and never
invents one.

B101's bound, for the same reason.  "Cite or mark every value" has one failure
mode no checker can see: overconfident *unmarked* inference — a value drafted
from nothing, carrying no marker and no question to rule on.  The elicitation
document names this as its residual risk by construction and assigns it to BA
draft review and the wrong-draft log, not to a rule.  So B101 judges the half
that is decidable — that every answer the session recorded actually landed at
every destination its packet named — and the undecidable half stays where the
corpus put it.  A spec's *form* is the M checkers' ground regardless.

Same idiom as tests/check-band1-artifacts.py, and the same rule namespace
continued: this file owns B71–B103.  It is a TEST HARNESS and is never installed.

  check-band2-artifacts.py --roadmap F [--canvas F]
  check-band2-artifacts.py --kit F [--roadmap F]
  check-band2-artifacts.py --brief F
  check-band2-artifacts.py --spec F --answers F --brief F [--cap 7]
  ...  [--expect B77,B86]   exit 0 iff exactly those rules are violated
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys

RULES = {
    # ── roadmap, the T-17 side ────────────────────────────────────────────
    "B71": "roadmap — two sections: `## Epics` then `## Allocation log`, in order",
    "B72": "roadmap — epics header is ID · Epic · Description · Phase · Status · Source, in order",
    "B73": "roadmap — every ID is `E-<nn>`, unique, and no retired ID is reused",
    "B74": "roadmap — every Epic name is 2–4 words; every Description is 2–3 sentences",
    "B75": "roadmap — every row cites its discovery ground in Source",
    "B76": "roadmap — Phase is one ladder value: Unallocated · MVP · Phase <n> · Later; no span notation",
    "B77": "roadmap — Status is Defined · In delivery · Delivered · `Retired — <reason>`, and nothing else",
    "B78": "roadmap — coverage: every canvas Core Function line resolves to some row's Source (an unresolved line is a hole)",
    # ── roadmap, the T-18 side ────────────────────────────────────────────
    "B79": "allocation log — entries head `### Allocation <n> — <date> · trigger: … · BA: …`, numbered from 1, contiguous",
    "B80": "allocation log — every diff row is `<from> → <to>` with a reason tagged by one of the four factors, by `BA-directed`, or by `BA-directed (SD-<n>)`",
    "B81": "allocation log — every entry carries Held and Basis, or is the `no change — <reason>` form",
    "B82": "allocation log — allocation never creates or retires an epic: every logged epic resolves to a row, no phase cell is a retirement",
    "B83": "allocation log — the log is the Phase column's ground: every row's Phase equals its latest logged outcome",
    # ── the call kit ──────────────────────────────────────────────────────
    "B84": "kit — four parts A–D, exact headings, in order",
    "B85": "kit — every question is `Q<n> [destination: …] [must-ask|if-time]` + question + `Why it matters:`; numbering from 1, contiguous, unique",
    "B86": "kit — must-ask ≤ 12 (D1)",
    "B87": "kit — the Destination Test: every destination tag names a brief decision section or a Band-2 allocation decision",
    "B88": "kit — part A lines are cited; part C assumptions carry `A<n> — … · source: … · impact if wrong: …`",
    "B89": "kit — stakeholder-facing language: no artifact filenames, no EARS keywords, no CC/AT identifiers in question text",
    # ── the scope brief ───────────────────────────────────────────────────
    "B90": "brief — nine sections, exact headings, exact order",
    "B91": "brief — Status is `Draft` or `Scoped`; a `Scoped` brief carries a call log",
    "B92": "brief — §3 carries both sub-headings, and every item names where it lives instead",
    "B93": "brief — §5 header is ID · A/R · Statement · Source · Impact if wrong · Status; every row sourced",
    "B94": "brief — §6 statuses are `Open` · `Answered — <date> → <destination>` · `Overtaken — <reason>` (D4)",
    "B95": "brief — §8 is non-empty in a Scoped brief; every Status is `Proposed` or `Confirmed — <date>` (D5)",
    "B96": "brief — §9 routing rows carry a destination and a date",
    "B97": "brief — §2 is capability lines, not user stories",
    # ── the tier-2 session ────────────────────────────────────────────────
    "B98": "tier 2 — GQ packets head `GQ<n> of <cap>` with a legality field and a destinations field; numbering contiguous",
    "B99": "tier 2 — questions asked ≤ cap (D7 default 7); an overflow is signalled, never asked through",
    "B100": "tier 2 — every legality anchor names a CC-ID or a marker/open-question reference (D6)",
    "B101": "tier 2 — every recorded answer lands: each ID a packet named as a destination exists in the spec",
    "B102": "tier 2 — every surviving `[NEEDS CLARIFICATION]` marker names its location and traces to a brief §6 `Open` row",
    "B103": "tier 2 — write-back: every open question an answer resolved reads `Answered — <date> → <destination>`",
}

BRIEF_SECTIONS = [
    "1. Value Anchor",
    "2. Essential Scope",
    "3. Boundaries",
    "4. External Systems",
    "5. Assumptions & Risks",
    "6. Open Questions",
    "7. Captured Detail (for Tier 2)",
    "8. Proposed Feature Slicing",
    "9. Routing Log",
]
KIT_PARTS = [
    "A. Pre-drafted brief baseline",
    "B. Question set",
    "C. Risks & assumptions to check",
    "D. Sibling boundary checks",
]
EPIC_HEADER = ["ID", "Epic", "Description", "Phase", "Status", "Source"]
RISK_HEADER = ["ID", "A/R", "Statement", "Source", "Impact if wrong", "Status"]

# The Destination Test's legal set: the brief's decision sections, plus the
# Band-2 allocation decision.  Everything else is either a spec section (and so
# final-spec depth) or an untaggable question.
LEGAL_DESTINATIONS = (
    "essential scope",
    "boundaries",
    "slicing",            # "Proposed Feature Slicing", "Slicing rationale"
    "assumptions",        # "Assumptions & Risks"
    "risks",
    "external systems",
    "allocation",
    "value anchor",
    "captured detail",
    "open questions",
)
# Destinations that name a spec section: the question is at final-spec depth.
SPEC_DESTINATIONS = (
    "functional requirement", "acceptance", "flow", "error", "data ",
    "business rule", "nfr", "non-functional", "integration touchpoint",
    "fr-", "br-", "us-", "spec.md", "state", "field",
)

FACTORS = ("value vs. effort", "dependency order", "risk", "walking skeleton")
# The §5 Reason grammar pins three tag forms, not one: a factor, `BA-directed`
# (D-B6-9's directed rows), and `BA-directed (SD-<n>)` — the SD-sourced
# candidate a BA confirmed at step 4 (D-B6-12). A directed row carries the BA's
# ruling in place of a factor, so it satisfies the tag requirement on its own.
DIRECTED_RE = re.compile(r"\bBA-directed\b(\s*\(SD-\d+\))?", re.I)
PHASE_RE = re.compile(r"^(Unallocated|MVP|Phase \d+|Later)$")
EPIC_ID_RE = re.compile(r"^E-\d{2,}$")
STATUS_OK = ("Defined", "In delivery", "Delivered")
RETIRED_RE = re.compile(r"^Retired\s+—\s+\S")
DATE_RE = re.compile(r"\b\d{4}-\d{2}-\d{2}\b")
CITATION_RE = re.compile(r"[\[\(][^\]\)\n]+[\]\)]|\b\w[\w-]*\.md\b|canvas\s*[:§]|→\s*[PO]-\d+")
GROUND_CLASS_RE = re.compile(r"`?\[(?:stated|inferred)\]`?")
MARKER_RE = re.compile(r"\[NEEDS CLARIFICATION:([^\]]*)\]")
ALLOC_HEAD_RE = re.compile(
    r"^###\s+Allocation\s+(?P<n>\d+)\s+—\s+(?P<date>\d{4}-\d{2}-\d{2})\s+·\s+"
    r"trigger:\s*(?P<trigger>[^·]+?)\s+·\s+BA:\s*(?P<ba>\S.*)$"
)
NO_CHANGE_RE = re.compile(r"^no change\s+—\s+\S")
GQ_HEAD_RE = re.compile(r"^GQ(?P<n>\d+)\s+of\s+(?P<cap>\d+)\s*—\s*(?P<rest>.*)$")
STORY_RE = re.compile(r"\bAs an?\b.*\bI want\b", re.IGNORECASE)
EARS_RE = re.compile(r"\b(THE SYSTEM SHALL|WHEN .*SHALL|WHILE .*SHALL|SHALL)\b")
CCAT_RE = re.compile(r"\b(CC-[A-Z]{1,3}-\d{2}|AT-[A-Z]{2}-\d)\b")
NUMERIC_RE = re.compile(
    r"\b(?:at most|no more than|within|up to|strictly more than|more than|maximum of|exactly)?\s*"
    r"(\d[\d,]*)\s*(hours?|hour|minutes?|seconds?|days?|characters?|slots?|h\b)?", re.IGNORECASE
)


class Report:
    def __init__(self) -> None:
        self.violations: list[tuple[str, str]] = []

    def fail(self, rule: str, detail: str) -> None:
        self.violations.append((rule, detail))

    @property
    def rule_ids(self) -> list[str]:
        seen: list[str] = []
        for rule, _ in self.violations:
            if rule not in seen:
                seen.append(rule)
        return sorted(seen, key=lambda r: int(r[1:]))


# ───────────────────────────────────────────────────────────── parse helpers ─


def strip_comments(text: str) -> str:
    return re.sub(r"<!--.*?-->", "", text, flags=re.DOTALL)


def split_row(line: str) -> list[str]:
    body = line.strip()
    if not body.startswith("|"):
        return []
    body = body[1:]
    if body.endswith("|"):
        body = body[:-1]
    return [c.strip() for c in body.split("|")]


def is_separator(cells: list[str]) -> bool:
    return bool(cells) and all(re.fullmatch(r":?-{2,}:?", c) for c in cells if c)


def table_in(lines: list[str]) -> tuple[list[str], list[list[str]]]:
    header: list[str] = []
    rows: list[list[str]] = []
    for line in lines:
        cells = split_row(line)
        if not cells:
            continue
        if is_separator(cells):
            continue
        if not header:
            header = cells
        else:
            rows.append(cells)
    return header, rows


def sections(text: str, level: int = 2) -> list[tuple[str, list[str]]]:
    """[(heading, body lines)] for headings at exactly `level`."""
    hashes = "#" * level
    out: list[tuple[str, list[str]]] = []
    cur: tuple[str, list[str]] | None = None
    for line in strip_comments(text).splitlines():
        m = re.match(rf"^{hashes}\s+(?!#)(.*)$", line)
        if m:
            if cur:
                out.append(cur)
            cur = (m.group(1).strip(), [])
        elif cur:
            cur[1].append(line)
    if cur:
        out.append(cur)
    return out


def body_of(text: str, prefix: str, level: int = 2) -> list[str]:
    for head, lines in sections(text, level):
        if head.lower().startswith(prefix.lower()):
            return lines
    return []


def sentence_count(cell: str) -> int:
    return len([s for s in re.split(r"(?<=[.!?])\s+", cell.strip()) if s.strip()])


def cited(cell: str) -> bool:
    # The Source ground-class (`[stated]` / `[inferred]`) is a class token, not
    # a citation: a cell carrying only tokens cites nothing. Strip them before
    # the test so B75 keeps asserting what it has always asserted.
    return bool(CITATION_RE.search(GROUND_CLASS_RE.sub("", cell)))


# ────────────────────────────────────────────────────────────────── roadmap ─


def check_roadmap(path: pathlib.Path, canvas: pathlib.Path | None, rep: Report) -> None:
    text = path.read_text(encoding="utf-8")
    heads = [h for h, _ in sections(text)]

    epics_i = next((i for i, h in enumerate(heads) if h.lower().startswith("epics")), None)
    log_i = next((i for i, h in enumerate(heads) if h.lower().startswith("allocation log")), None)
    if epics_i is None or log_i is None:
        rep.fail("B71", f"sections present: {heads or '(none)'} — need `## Epics` and `## Allocation log`")
        return
    if epics_i > log_i:
        rep.fail("B71", "`## Allocation log` stands before `## Epics`")

    header, rows = table_in(body_of(text, "epics"))
    if header != EPIC_HEADER:
        rep.fail("B72", f"header is {header}")
        return

    ids: list[str] = []
    phases: dict[str, str] = {}
    sources: dict[str, str] = {}
    retired: set[str] = set()
    skip_phase: set[str] = set()
    for cells in rows:
        if len(cells) != 6:
            rep.fail("B72", f"row has {len(cells)} cells: {cells[:2]}")
            continue
        eid, name, desc, phase, status, source = cells
        eid = eid.strip("`")
        # A malformed or duplicated ID is one defect, not two: the row is still
        # registered so the allocation pass resolves it and stays quiet.
        if not EPIC_ID_RE.fullmatch(eid):
            rep.fail("B73", f"ID is not `E-<nn>`: {eid!r}")
            phases.setdefault(eid, phase)
            sources.setdefault(eid, source)
            skip_phase.add(eid)
            continue
        if eid in ids:
            rep.fail("B73", f"{eid} appears twice")
        ids.append(eid)
        phases[eid] = phase
        sources[eid] = source

        words = len(name.split())
        if not 2 <= words <= 4:
            rep.fail("B74", f"{eid} name is {words} words: {name!r}")
        n = sentence_count(desc)
        if not 2 <= n <= 3:
            rep.fail("B74", f"{eid} description is {n} sentence(s), not 2–3")
        if not cited(source):
            rep.fail("B75", f"{eid} Source cites nothing: {source!r}")
        if not PHASE_RE.fullmatch(phase.strip()):
            rep.fail("B76", f"{eid} Phase is {phase!r} — not one ladder value (span notation is banned)")
            skip_phase.add(eid)
        if status not in STATUS_OK and not RETIRED_RE.match(status):
            rep.fail("B77", f"{eid} Status is {status!r}")
        if RETIRED_RE.match(status):
            retired.add(eid)

    # a retired row's ID retires with it: no later row may reuse it
    for eid in retired:
        if ids.count(eid) > 1:
            rep.fail("B73", f"{eid} is retired and reused")

    if canvas is not None:
        check_coverage(canvas, sources, rep)

    check_allocation(text, phases, skip_phase, rep)


def canvas_functions(path: pathlib.Path) -> list[str]:
    """The Core Functions capability lines, as bare verb phrases.

    The canvas is one markdown table — `| n | Section | content |` — with the
    section's lines separated by ` · `, exactly as the framing sheet pins it.
    """
    _, rows = table_in(strip_comments(path.read_text(encoding="utf-8")).splitlines())
    cell = ""
    for cells in rows:
        if len(cells) >= 3 and "core functions" in cells[1].strip().lower():
            cell = cells[2]
            break
    out: list[str] = []
    for part in re.split(r"\s+·\s+", cell):
        body = re.sub(r"`[^`]*`", "", part)
        body = re.sub(r"[\[\(][^\]\)]*[\]\)]", "", body)
        body = body.strip(" .·`")
        if body:
            out.append(body)
    return out


STOPWORDS = {"their", "there", "these", "those", "which", "other", "about", "own"}


def stems(phrase: str) -> set[str]:
    return {w[:5].lower() for w in re.findall(r"[A-Za-z][A-Za-z'-]{3,}", phrase)
            if w.lower() not in STOPWORDS}


def check_coverage(canvas: pathlib.Path, sources: dict[str, str], rep: Report) -> None:
    """Coverage only — see B78's bound in the module docstring."""
    funcs = canvas_functions(canvas)
    if not funcs:
        rep.fail("B78", f"no Core Functions lines found in {canvas.name}")
        return
    for fn in funcs:
        want = stems(fn)
        if not want:
            continue
        if not any(want & stems(src) for src in sources.values()):
            rep.fail("B78", f"canvas function {fn!r} resolves to no epic Source — a hole")


def check_allocation(text: str, phases: dict[str, str], skip_phase: set[str],
                     rep: Report) -> None:
    body = body_of(text, "allocation log")
    entries: list[tuple[int, list[str]]] = []
    cur: tuple[int, list[str]] | None = None
    for line in body:
        m = ALLOC_HEAD_RE.match(line.strip())
        if m:
            if cur:
                entries.append(cur)
            cur = (int(m.group("n")), [])
            continue
        if line.strip().startswith("### "):
            rep.fail("B79", f"entry head off-grammar: {line.strip()!r}")
            if cur:
                entries.append(cur)
            cur = None
            continue
        if cur:
            cur[1].append(line)
    if cur:
        entries.append(cur)

    if not entries:
        return
    for want, (got, _) in enumerate(entries, start=1):
        if got != want:
            rep.fail("B79", f"entry numbering is {[n for n, _ in entries]} — not contiguous from 1")
            break

    latest: dict[str, str] = {}
    for n, lines in entries:
        joined = "\n".join(lines).strip()
        if NO_CHANGE_RE.match(joined.splitlines()[0].strip() if joined else ""):
            continue
        header, rows = table_in(lines)
        if not rows:
            rep.fail("B81", f"Allocation {n}: neither a diff table nor the `no change — <reason>` form")
            continue
        for cells in rows:
            if len(cells) < 3:
                rep.fail("B80", f"Allocation {n}: diff row has {len(cells)} cells")
                continue
            epic, move, reason = cells[0], cells[1], cells[2]
            eid = epic.split()[0].strip("`") if epic.split() else ""
            if eid not in phases:
                rep.fail("B82", f"Allocation {n}: {eid or epic!r} is not a roadmap row — allocation never creates an epic")
                continue
            if "→" not in move:
                rep.fail("B80", f"Allocation {n}: {eid} phase cell is {move!r}, not `<from> → <to>`")
                continue
            frm, to = (p.strip() for p in move.split("→", 1))
            if not PHASE_RE.fullmatch(to):
                rep.fail("B82" if "retire" in to.lower() else "B80",
                         f"Allocation {n}: {eid} moves to {to!r}")
                continue
            if not (any(f in reason.lower() for f in FACTORS)
                    or DIRECTED_RE.search(reason)):
                rep.fail("B80", f"Allocation {n}: {eid} reason names neither a factor nor BA-directed: {reason!r}")
            latest[eid] = to
        low = "\n".join(lines).lower()
        if "held:" not in low or "basis:" not in low:
            rep.fail("B81", f"Allocation {n}: Held and Basis are not both present")

    for eid, phase in phases.items():
        if eid in skip_phase:
            continue          # already reported as a malformed ID or phase cell
        if eid in latest and latest[eid] != phase.strip():
            rep.fail("B83", f"{eid} Phase reads {phase!r}; the log's latest outcome is {latest[eid]!r}")


# ────────────────────────────────────────────────────────────────────── kit ─


def check_kit(path: pathlib.Path, roadmap: pathlib.Path | None, rep: Report) -> None:
    text = path.read_text(encoding="utf-8")
    heads = [h for h, _ in sections(text)]
    want = [p.split(".")[0] for p in KIT_PARTS]
    got = [h.split(".")[0] for h in heads if re.match(r"^[A-D]\.", h)]
    if got != want:
        rep.fail("B84", f"parts present: {got or '(none)'} — need A · B · C · D, in order")
    for part in KIT_PARTS:
        if not any(h.lower().startswith(part.split(".")[0].lower() + ".") for h in heads):
            continue
        matched = [h for h in heads if h.startswith(part.split(".")[0] + ".")]
        if matched and not matched[0].lower().startswith(part.lower()):
            rep.fail("B84", f"part heading is {matched[0]!r}, not {part!r}")

    qbody = "\n".join(body_of(text, "B. Question set"))
    blocks = re.findall(
        r"^Q(?P<n>\d+)\s*\[destination:\s*(?P<dest>[^\]]*)\]\s*\[(?P<rank>must-ask|if-time)\]"
        r"(?P<rest>(?:\n(?!Q\d).*)*)",
        qbody, re.M,
    )
    stray = [m.group(0) for m in re.finditer(r"^Q\d+.*$", qbody, re.M)
             if not re.match(r"^Q\d+\s*\[destination:[^\]]*\]\s*\[(must-ask|if-time)\]\s*$", m.group(0))]
    for s in stray:
        rep.fail("B85", f"question head off-grammar: {s.strip()!r}")

    seen: list[int] = []
    must = 0
    for n, dest, rank, rest in blocks:
        n = int(n)
        if n in seen:
            rep.fail("B85", f"Q{n} appears twice")
        seen.append(n)
        if "why it matters:" not in rest.lower():
            rep.fail("B85", f"Q{n} carries no `Why it matters:` line")
        if not rest.strip():
            rep.fail("B85", f"Q{n} has no question text")
        if rank == "must-ask":
            must += 1

        low = dest.lower()
        if any(bad in low for bad in SPEC_DESTINATIONS):
            rep.fail("B87", f"Q{n} destination {dest!r} names a spec section — final-spec depth")
        elif not any(good in low for good in LEGAL_DESTINATIONS):
            rep.fail("B87", f"Q{n} destination {dest!r} is not a brief decision section")

        qtext = rest.strip()
        if re.search(r"\b\w[\w-]*\.md\b", qtext) or CCAT_RE.search(qtext) or EARS_RE.search(qtext):
            rep.fail("B89", f"Q{n} question text carries framework jargon")

    if seen and sorted(seen) != list(range(1, len(seen) + 1)):
        rep.fail("B85", f"question numbering is {sorted(seen)} — not contiguous from 1")
    if must > 12:
        rep.fail("B86", f"{must} must-ask questions — the cap is 12")

    # baseline entries wrap: a continuation line belongs to the bullet above it,
    # and the citation usually sits on the continuation.
    entries: list[str] = []
    for line in body_of(text, "A. Pre-drafted brief baseline"):
        body = line.strip()
        if not body or body.startswith("```") or body.startswith("<"):
            continue
        if body.startswith(("·", "-", "*")):
            entries.append(body)
        elif entries:
            entries[-1] += " " + body
    for entry in entries:
        if not cited(entry):
            rep.fail("B88", f"baseline line is uncited: {entry!r}")

    cbody = "\n".join(body_of(text, "C. Risks & assumptions to check"))
    for m in re.finditer(r"^A(\d+)\s*—(?P<rest>(?:.*)(?:\n(?!A\d+\s*—).*)*)", cbody, re.M):
        rest = m.group("rest")
        if "source:" not in rest.lower() or "impact if wrong:" not in rest.lower():
            rep.fail("B88", f"A{m.group(1)} lacks a source or an impact-if-wrong clause")

    if roadmap is not None and re.search(r"^D\.", text, re.M):
        rtext = roadmap.read_text(encoding="utf-8")
        dbody = "\n".join(body_of(text, "D. Sibling boundary checks"))
        for m in re.finditer(r"\(?(E-\d{2,})\)?", dbody):
            if m.group(1) not in rtext:
                rep.fail("B87", f"sibling check names {m.group(1)}, absent from the roadmap")


# ──────────────────────────────────────────────────────────────────── brief ─


def check_brief(path: pathlib.Path, rep: Report) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    heads = [h for h, _ in sections(text)]
    if heads != BRIEF_SECTIONS:
        rep.fail("B90", f"sections are {heads}")

    head_block = text.split("## ", 1)[0]
    m = re.search(r"^Status:\s*(.+)$", head_block, re.M)
    status = (m.group(1).strip() if m else "")
    if status not in ("Draft", "Scoped"):
        rep.fail("B91", f"Status is {status!r}")
    if status == "Scoped" and not re.search(r"^Call log:\s*\S", head_block, re.M):
        rep.fail("B91", "a `Scoped` brief carries no call log")

    b3 = body_of(text, "3. Boundaries")
    subs = [l.strip() for l in b3 if l.strip().startswith("### ")]
    if not any("excluded" in s.lower() for s in subs) or not any("deferred" in s.lower() for s in subs):
        rep.fail("B92", f"§3 sub-headings are {subs}")
    for line in b3:
        body = line.strip()
        if body.startswith("- ") and "—" not in body and "-" not in body[2:]:
            rep.fail("B92", f"§3 item names no destination: {body!r}")

    header, rows = table_in(body_of(text, "5. Assumptions & Risks"))
    if header and header != RISK_HEADER:
        rep.fail("B93", f"§5 header is {header}")
    for cells in rows:
        if len(cells) >= 4 and not cells[3].strip():
            rep.fail("B93", f"§5 row {cells[0]!r} is unsourced")

    _, oq_rows = table_in(body_of(text, "6. Open Questions"))
    open_rows: dict[str, str] = {}
    for cells in oq_rows:
        if len(cells) < 4:
            continue
        oid, st = cells[0], cells[3].strip()
        open_rows[oid] = st
        if st == "Open":
            continue
        if st.startswith("Answered"):
            if not (DATE_RE.search(st) and "→" in st):
                rep.fail("B94", f"§6 {oid}: `Answered` without a date and a destination — {st!r}")
        elif st.startswith("Overtaken"):
            if not re.match(r"^Overtaken\s+—\s+\S", st):
                rep.fail("B94", f"§6 {oid}: `Overtaken` without a mandatory reason — {st!r}")
        else:
            rep.fail("B94", f"§6 {oid} status is {st!r}")

    sl_header, sl_rows = table_in(body_of(text, "8. Proposed Feature Slicing"))
    if status == "Scoped" and not sl_rows:
        rep.fail("B95", "§8 is empty in a `Scoped` brief")
    for cells in sl_rows:
        if len(cells) < 4:
            rep.fail("B95", f"§8 row has {len(cells)} cells")
            continue
        st = cells[3].strip()
        if st != "Proposed" and not re.match(r"^Confirmed\s+—\s+\d{4}-\d{2}-\d{2}$", st):
            rep.fail("B95", f"§8 {cells[0]!r} Status is {st!r}")

    _, rl_rows = table_in(body_of(text, "9. Routing Log"))
    for cells in rl_rows:
        if len(cells) < 3 or not cells[1].strip() or not DATE_RE.search(cells[2]):
            rep.fail("B96", f"§9 row {cells[0][:40]!r} lacks a destination or a date")

    for line in body_of(text, "2. Essential Scope"):
        if STORY_RE.search(line):
            rep.fail("B97", f"§2 carries a user story: {line.strip()!r}")

    return open_rows


# ─────────────────────────────────────────────────────────────── tier-2 pass ─


def check_tier2(spec: pathlib.Path, answers: pathlib.Path, brief: pathlib.Path | None,
                cap: int, rep: Report) -> None:
    atext = answers.read_text(encoding="utf-8")
    stext = spec.read_text(encoding="utf-8")

    # A packet body runs to the next packet, the next heading, or a rule — not to
    # the end of the file; the trailing prose is the session's, not the packet's.
    packets = list(re.finditer(
        r"^GQ(?P<n>\d+)\s+of\s+(?P<cap>\d+)\s*—(?P<rest>(?:.*)(?:\n(?!GQ\d|#{1,6}\s|---).*)*)",
        atext, re.M))
    stray = [m.group(0).splitlines()[0] for m in re.finditer(r"^GQ\d+\b.*$", atext, re.M)
             if not GQ_HEAD_RE.match(m.group(0).strip())]
    for s in stray:
        rep.fail("B98", f"packet head off-grammar: {s.strip()!r}")

    nums: list[int] = []
    resolved_oqs: set[str] = set()
    for m in packets:
        n = int(m.group("n"))
        nums.append(n)
        rest = m.group("rest")
        resolved_oqs.update(re.findall(r"(OQ-\d+)", rest))
        if int(m.group("cap")) != cap:
            rep.fail("B98", f"GQ{n} names cap {m.group('cap')}, session cap is {cap}")
        if "legality:" not in rest:
            rep.fail("B98", f"GQ{n} carries no legality field")
        elif not (CCAT_RE.search(rest) or re.search(r"marker|OQ-\d+|§6", rest, re.I)):
            rep.fail("B100", f"GQ{n} legality anchor names neither a CC-ID nor a marker")
        if "destination" not in rest.lower():
            rep.fail("B98", f"GQ{n} carries no destinations field")

    if nums and sorted(nums) != list(range(1, len(nums) + 1)):
        rep.fail("B98", f"GQ numbering is {sorted(nums)} — not contiguous from 1")
    # The overflow rule is emitted *instead of* asking on: a session that asked
    # past its cap did not signal, whatever the prose says about it afterwards.
    if len(nums) > cap:
        rep.fail("B99", f"{len(nums)} questions asked against a cap of {cap} — the cap is where asking stops")

    # every recorded answer lands where its packet said it would
    spec_ids = set(re.findall(r"\b(?:BR|FR|NFR)-\d{3}\b", stext)) \
        | set(re.findall(r"\bUS\d+\b", stext))
    for m in packets:
        n = int(m.group("n"))
        body = m.group("rest")
        named = set(re.findall(r"\b(?:BR|FR|NFR)-\d{3}\b", body)) \
            | set(re.findall(r"\bUS\d+\b", body))
        for rid in sorted(named - spec_ids):
            rep.fail("B101", f"GQ{n} named {rid} as a destination; the spec carries no such ID")

    open_rows = check_brief(brief, rep) if brief is not None else {}

    for m in MARKER_RE.finditer(stext):
        inner = m.group(1)
        if not re.search(r"OQ-\d+|basis:|brief", inner, re.I):
            rep.fail("B102", f"marker names no location or basis: {inner.strip()[:70]!r}")
            continue
        oq = re.search(r"(OQ-\d+)", inner)
        if oq and open_rows and open_rows.get(oq.group(1), "").strip() != "Open":
            rep.fail("B102", f"marker cites {oq.group(1)}, whose brief row is not `Open`")

    # Only questions the session actually asked write back — an OQ named in the
    # "not asked, and why" table is a marker that survives, not an answer.
    for oid in sorted(resolved_oqs):
        if oid not in open_rows:
            continue
        st = open_rows[oid].strip()
        if st == "Open":
            rep.fail("B103", f"{oid} was answered this session; its brief row still reads `Open`")
        elif st.startswith("Answered") and not (DATE_RE.search(st) and "→" in st):
            rep.fail("B103", f"{oid} write-back is off-grammar: {st!r}")


# ───────────────────────────────────────────────────────────────────── main ─


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--roadmap", type=pathlib.Path)
    ap.add_argument("--canvas", type=pathlib.Path,
                    help="judge coverage & exclusivity against this canvas's Core Functions")
    ap.add_argument("--kit", type=pathlib.Path)
    ap.add_argument("--brief", type=pathlib.Path)
    ap.add_argument("--spec", type=pathlib.Path)
    ap.add_argument("--answers", type=pathlib.Path, help="the Tier-2 answer sheet")
    ap.add_argument("--cap", type=int, default=7)
    ap.add_argument("--expect", default=None, help="comma-separated rule IDs that MUST be the violations")
    args = ap.parse_args()

    rep = Report()
    checked: list[str] = []

    if args.roadmap:
        check_roadmap(args.roadmap, args.canvas, rep)
        checked.append("roadmap")
    if args.kit:
        check_kit(args.kit, args.roadmap, rep)
        checked.append("kit")
    if args.spec:
        if not args.answers:
            print("--spec needs --answers (the recorded session)", file=sys.stderr)
            return 2
        check_tier2(args.spec, args.answers, args.brief, args.cap, rep)
        checked.append("tier2")
    elif args.brief:
        check_brief(args.brief, rep)
        checked.append("brief")

    if not checked:
        print("nothing to check — pass --roadmap / --kit / --brief / --spec+--answers", file=sys.stderr)
        return 2

    if args.expect is not None:
        want = sorted((r.strip() for r in args.expect.split(",") if r.strip()), key=lambda r: int(r[1:]))
        got = rep.rule_ids
        if got == want:
            return 0
        print(f"expected violations {want}, got {got}")
        for rule, detail in rep.violations:
            print(f"      {rule}  {detail}")
        return 1

    if rep.violations:
        for rule, detail in rep.violations:
            print(f"  ✗ {rule}  {RULES[rule]}\n        {detail}")
        return 1

    print(f"✓ {' · '.join(checked)} — {len(RULES)} rules, no violations")
    return 0


if __name__ == "__main__":
    sys.exit(main())
