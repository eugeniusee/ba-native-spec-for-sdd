#!/usr/bin/env python3
"""BA-Native Spec — aspect-ledger grammar validator (S4 exit-test harness).

Reads a `.specify/aspect-state.md` and checks it against the orchestrator
rules' machinery: the §2.4 file shape, the §2.2 state set, the §2.3 transition
table and event grammar, the §3.1 DAG, the §4.1 AW record, the §5.3 RO record
and its no-auto-cascade rule, and the §8.2 closure preconditions.

**This is a test harness, not a build unit.** It is deliberately NOT installed:
build plan §2.4 pins the vendored script set at eleven, and — more to the point —
orchestrator §3.2 rule 4 and §10.2 say the aspect layer has *no checker*
("requests the arming run; runs nothing"). Shipping a runtime ledger validator
would contradict the document it compiles from. It lives in tests/ for the same
reason `check-cards.py` does: to keep the compiled prompts honest against the
pinned doc.

  check-ledger.py <aspect-state.md> [--allow-open-band]
  check-ledger.py <file> --expect L4,L11      # negatives: these rules must trip
  check-ledger.py --rules                     # list the rule IDs

Exit 0 = the ledger is grammar-legal (or, with --expect, tripped exactly the
expected rules). Exit 1 = violations.
"""

import argparse
import pathlib
import re
import sys

# ── the machinery, compiled from orchestrator rules v0.3 ─────────────────────

ASPECTS = ["Stakeholders", "Context", "Value", "Vision", "Solution", "Requirements"]

PREREQ = {                                                        # §3.1, verbatim
    "Stakeholders": [],
    "Context":      ["Stakeholders"],
    "Value":        ["Stakeholders"],
    "Vision":       ["Context", "Value"],
    "Solution":     ["Vision"],
    "Requirements": ["Solution"],
}

STATES = ["untouched", "open", "first-pass-cleared", "waived", "reopened"]  # §2.2

TRANSITIONS = {                                                   # §2.3 — T1..T8
    1: [("untouched", "open")],
    2: [("open", "first-pass-cleared")],
    3: [("open", "waived")],
    4: [("waived", "first-pass-cleared")],
    5: [("first-pass-cleared", "reopened"), ("waived", "reopened")],
    6: [("reopened", "first-pass-cleared")],
    7: [("reopened", "waived")],
    8: [("waived", "open")],
}

# what each transition's basis must name (§2.3 "Record basis" column)
BASIS_MUST_NAME = {
    1: (re.compile(r"prerequisit|Band 1 entered"), "the prerequisite states cited"),
    2: (re.compile(r"AT-[A-Z]{2}-\d|evidence table"), "the evidence table / AT-IDs"),
    3: (re.compile(r"AW-\d+"), "AW-<n>"),
    4: (re.compile(r"AW-\d+"), "the evidence ref + AW closure"),
    5: (re.compile(r"RO-\d+"), "RO-<n>"),
    6: (re.compile(r"RO-\d+"), "RO-<n> closure + delta evidence"),
    7: (re.compile(r"AW-\d+"), "AW-<n> citing RO-<n>"),
    8: (re.compile(r"AW-\d+"), "AW-<n> lapse"),
}

PROGRESSION_GRANTED = {"first-pass-cleared", "waived"}            # §2.2, §4.2

AW_FIELDS = ["reason", "risk accepted", "approver", "revisit trigger", "status"]

# a revisit trigger must be event-shaped, never a date wish (§4.1)
DATE_WISH = re.compile(
    r"\b(\d{4}-\d{2}-\d{2}"
    r"|by (january|february|march|april|may|june|july|august|september|october|november|december)"
    r"|in \d+ (day|week|month)s?"
    r"|next (week|month|quarter|sprint)"
    r"|q[1-4]\b)",
    re.I,
)

RULES = {
    "L1":  "head shape — band line · six rows in DAG order · the four head lines (§2.4)",
    "L2":  "state vocabulary — the five states, and nothing else (§2.2)",
    "L3":  "event grammar — every event line is one of the known forms (§2.3 · §2.4)",
    "L4":  "transition legality — T<n> matches its from → to pair; no other exists (§2.3)",
    "L5":  "DAG — T1 only when every prerequisite is cleared-or-waived (§3.1)",
    "L6":  "basis — every transition names the basis its row demands (§2.3, rule 3)",
    "L7":  "head ⇄ events — the head is what replaying the events produces (§2.4)",
    "L8":  "AW record — six fields, named unmet criteria, event-shaped trigger (§4.1)",
    "L9":  "RO record — <artifact:line>: <conflict> → <resolution path> (§5.3)",
    "L10": "no auto-cascade — one RO reopens exactly one aspect (§5.3, D-O6)",
    "L11": "closure — six cleared-or-waived, zero reopened, AWs re-affirmed (§8.2)",
    "L12": "ledger home — outside .specify/memory/ (D-O3, D-G1/D-G8)",
    "L13": "chronology — events append in non-decreasing date order (§2.4)",
    "L14": "RO lifecycle — received before ruled; open ROs stand in the head (§5.1)",
    "L15": "exclusion — an artifact standing `excluded` is never captured (§8.1, D-O70)",
    "L16": "encounter — a capture referencing an excluded artifact carries its "
           "encounter line (§8.1 · §2.4, D-O70)",
    "L17": "cross-cutting register — `XO-<n> — <class>: <value> (<citation>) — "
           "<state>`, five classes, four states, never `none` (§2.4, D-O72)",
    "L18": "cross-cutting harvest — a capture stating an obligation carries its "
           "`XO-<n>` entry (§8.1, D-O73)",
    "L19": "acceptance-shape register — `AS-<n> — <item> (<citation>) — "
           "<state>`, three states, `none found` legal (§2.4, D-O78)",
    "L20": "change register — `CR-<n> — <the change> (<from>) — <state>`, five "
           "states, an absent line reads `none`; the CR records append in full "
           "(§2.4 · §7.7, D-O102)",
}

# ── event forms ──────────────────────────────────────────────────────────────

DATE = r"\d{4}-\d{2}-\d{2}"
RE_TRANSITION = re.compile(
    rf"^({DATE}) · T(\d) · (\w+) · (.+?) → (.+?) · (.+?) — (.+)$")
RE_BAND_ENTER = re.compile(rf"^({DATE}) · Band 1 entered · Frame · (.+?) — (.+)$")
RE_BAND_CLOSE = re.compile(rf"^({DATE}) · Band 1 closed · (.+)$")
RE_BAND3 = re.compile(rf"^({DATE}) · (\S+) entered Band 3 · (.+?) — (.+)$")
RE_CYCLE_CLOSE = re.compile(rf"^({DATE}) · (\S+) cycle closed · (.+?) — (.+)$")
RE_REVIEW = re.compile(rf"^Aspect gate review — (\w+) — ({DATE})$")
RE_RO_RECV = re.compile(rf"^RO-(\d+) · received · ({DATE}) · source: (.+)$")
RE_RO = re.compile(r"^RO-(\d+) · (\w+) — (.+)$")
RE_AW = re.compile(r"^AW-(\d+) · (\w+) · unmet: (.+)$")
RE_GAP = re.compile(
    rf"^Threshold-gap candidate — ({DATE}) · should have been caught by (.+)$")

# The `CR-<n>` record class (§2.4 · §7.7, D-O102) — three record lines, all
# appending to Events IN FULL on the RO pattern.  No new event kind exists:
# these are records, exactly as `RO-<n>` and `AW-<n>` are, and they are matched
# here for the same reason those are — a record the grammar does not know is a
# record nobody can read back.
RE_CR_RECV = re.compile(
    rf"^CR-(\d+) · received · ({DATE}) · from: (.+?) · (\S+) — (.+)$")
RE_CR_RULED = re.compile(rf"^CR-(\d+) · ruled · ({DATE}) · (.+?) — (.+)$")
RE_CR_LANDED = re.compile(rf"^CR-(\d+) · landed · ({DATE}) — (.+)$")
CR_RULINGS = ("take", "decline", "hold")

# The five head-line events §2.4 pins, verbatim (D-O14 · D-O36–D-O38 · D-O43 ·
# D-O48). Each rewrites a head line rather than an aspect state, so none feeds
# L7's replay; all five carry a date and take part in L13's chronology.
#
# `auto` is one form in two shapes — `on` carries the grant's scope, `off` does
# not — exactly as §2.4 renders the pair. The alignment padding after `auto on`
# is cosmetic (the exhibit column-aligns `on` under `off`) and is tolerated;
# everything else is the pinned grammar and nothing else.
RE_PROFILE = re.compile(rf"^({DATE}) · profile · (.+?) → (.+?) · (.+?) — (.+)$")
RE_SCOPE_FRAME = re.compile(
    rf"^({DATE}) · scope-frame · (.+?) → (.+?) · (.+?) — (.+)$")
RE_SOURCE = re.compile(rf"^({DATE}) · source · (.+?) · (.+?) · (.+?) — (.+)$")
RE_AUTO_ON = re.compile(
    rf"^({DATE}) · auto on +· AG-(\d+) · scope (.+?) · (.+?) — (.+)$")
RE_AUTO_OFF = re.compile(rf"^({DATE}) · auto off · AG-(\d+) · (.+?) — (.+)$")
RE_RATIFICATION = re.compile(
    rf"^({DATE}) · ratification · AG-(\d+) · (.+?) — (.+)$")

# The `Sources:` state vocabulary, closed at five — D-O48's four, extended on
# the record by D-O70's `excluded — <reason>`. In an event the date rides the
# event itself, so bare `captured` is the common render.
RE_SOURCE_STATE = re.compile(
    r"^(captured(\s+\S.*)?|named — pending|skipped — \S.*"
    r"|excluded — \S.*|none)$")

# The encounter of a reference to an excluded artifact rides the same `source`
# event grammar and is not a state (D-O70): `<artifact> · encounter — not
# followed · <initials> — excluded <date>`. No new event kind exists.
RE_ENCOUNTER = re.compile(r"^encounter — not followed$")

HEAD_LINES = ["Standing aspect waivers:", "Open reopens:",
              "Upstream flags:", "Deferred consequences:",
              "Scope advisories:", "Cross-cutting:", "Acceptance shapes:"]

# ── the cross-cutting register (§2.4, D-O72) ─────────────────────────────────
#
# `Cross-cutting: XO-1 — language: English (…) — default · XO-<n> — <class>:
# <value> (<citation>) — <state> · …`.  Both vocabularies are closed by ruling —
# five classes, four states — and the line is NEVER `none`: the language line's
# engagement default always stands (D-O74).  The state token is matched at a
# ` — ` boundary from the right, because `carried — <unit>` carries a separator
# of its own: the LAST state token on an entry is that entry's state.
XO_CLASSES = ("language", "device", "accessibility", "branding", "compliance")
XO_STATES = ("captured", "carried", "accepted", "default")
RE_XO = re.compile(r"^XO-(?P<n>\d+)\s+—\s+(?P<cls>[^:]+):\s*(?P<rest>.+)$")
RE_XO_STATE = re.compile(r"\s+—\s+(?P<state>%s)\b" % "|".join(XO_STATES))

# ── the acceptance-shape register (§2.4, D-O78) ──────────────────────────────
#
# `Acceptance shapes: AS-<n> — <acceptance item> (<citation>) — <state> · …` or
# `none found`, which is a legal, RECORDED state — unlike the cross-cutting
# line, whose engagement default always stands.  The state vocabulary is closed
# at three by ruling.  The state token is matched at a ` — ` boundary from the
# right for the same reason XO's is: `superseded — SD-<n>` and
# `accepted — <reason>` each carry a separator of their own, so the LAST state
# token on an entry is that entry's state.
AS_STATES = ("standing", "superseded", "accepted")
RE_AS = re.compile(r"^AS-(?P<n>\d+)\s+—\s+(?P<rest>.+)$")
RE_AS_STATE = re.compile(r"\s+—\s+(?P<state>%s)\b" % "|".join(AS_STATES))

# ── the change register (§2.4, D-O102) ───────────────────────────────────────
#
# `Changes: CR-<n> — <the change, one line> (<from>) — <state> · …` or `none`.
# The state vocabulary is closed at five by ruling.  The line is NOT in
# HEAD_LINES and is never required: §2.4 rules that an absent line reads `none`,
# so a ledger written before D-O102 is legal and reads correctly — the
# `Humanizer:` line's own law (D-O97).  Presence is optional; shape, once
# present, is not.  The state token is matched at a ` — ` boundary from the
# right for the reason XO's and AS's are: `held — trigger: <event>`,
# `routed — <acts>`, `landed — <refs>` and `declined — <reason>` each carry a
# separator of their own, so the LAST state token on an entry is its state.
CR_STATES = ("received", "held", "routed", "landed", "declined")
RE_CR = re.compile(r"^CR-(?P<n>\d+)\s+—\s+(?P<rest>.+)$")
RE_CR_STATE = re.compile(r"\s+—\s+(?P<state>%s)\b" % "|".join(CR_STATES))
# Entries are separated by ` · ` like every other register's — but this line is
# the first whose LAST field legitimately carries that separator itself:
# `landed — <refs>` names an `Allocation <n>` entry, a routing-log line, a gate
# run and an `SD-<n>` in one field, joined by ` · ` (§7.7's landed record).
# Splitting on every ` · ` would read each ref as a malformed entry.  The id is
# what disambiguates it, which is what the id grammar is for: split only where
# the next chunk OPENS a new `CR-<n> — `.
RE_CR_SPLIT = re.compile(r"\s+·\s+(?=CR-\d+\s+—\s+)")

# L18's marker set — the harvest floor, and it claims nothing more.  Each entry
# is a phrasing that names its class unmistakably in captured client prose; a
# fact worded any other way is not detected here, exactly as L16 asserts the
# floor of the encounter rule and leaves its ceiling to the law.  Under-reports
# by construction; never invents.
XO_MARKERS = {
    "language": re.compile(
        r"\b(multi-?lingual|multi-?language|bilingual|localis\w*|localiz\w*"
        r"|(ui|interface|content|support)[ -]languages?)\b", re.I),
    "accessibility": re.compile(r"\b(wcag|accessibility|screen[ -]reader)\b", re.I),
    "branding": re.compile(r"\b(brand[ -](guideline|book|manual)s?|style[ -]guide"
                           r"|colou?r[ -]palette)\b", re.I),
}


class Report:
    def __init__(self):
        self.violations = []          # (rule, line-no, message)

    def bad(self, rule, lineno, msg):
        self.violations.append((rule, lineno, msg))

    @property
    def tripped(self):
        return sorted({r for r, _, _ in self.violations})


def parse_blocks(lines, start, end):
    """Group the Events body into (first-line-no, header, continuation-lines)."""
    blocks = []
    i = start
    while i < end:
        raw = lines[i]
        if not raw.strip() or raw.startswith("<!--") or raw.startswith("  ") \
                or raw.startswith("\t"):
            i += 1
            continue
        header = raw.rstrip()
        cont = []
        j = i + 1
        while j < end:
            nxt = lines[j]
            if nxt.strip() and (nxt.startswith("  ") or nxt.startswith("\t")):
                cont.append((j + 1, nxt.strip()))
                j += 1
            elif not nxt.strip():
                j += 1
                if j < end and lines[j].strip() and (lines[j].startswith("  ")
                                                     or lines[j].startswith("\t")):
                    continue
                break
            else:
                break
        blocks.append((i + 1, header, cont))
        i = j
    return blocks


def check(path: pathlib.Path, allow_open_band: bool, captures=None) -> Report:
    rep = Report()
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    # ── L12 — the ledger's home ─────────────────────────────────────────────
    parts = [p.lower() for p in path.resolve().parts]
    if "memory" in parts and ".specify" in parts:
        rep.bad("L12", 0, f"{path} sits under .specify/memory/ — orchestration state "
                          "is a runtime record and lives outside it (D-O3)")

    # ── locate the two sections ─────────────────────────────────────────────
    try:
        i_head = next(i for i, l in enumerate(lines) if l.strip() == "## Current state")
    except StopIteration:
        rep.bad("L1", 0, "no `## Current state` section — the head is the file's contract")
        return rep
    try:
        i_ev = next(i for i, l in enumerate(lines) if l.strip() == "## Events")
    except StopIteration:
        rep.bad("L1", 0, "no `## Events` section — events are append-only and must have a home")
        return rep

    head = lines[i_head + 1:i_ev]

    # ── L1 / L2 — the head ──────────────────────────────────────────────────
    band_line = next((l for l in head if l.startswith("Band:")), None)
    if band_line is None:
        rep.bad("L1", i_head + 2, "no `Band:` line in the head")
        band_closed = None
    else:
        m = re.match(rf"^Band: 1 \(open\)$|^Band: 1 \(closed ({DATE})\) — Bands 2/3 capable$",
                     band_line.strip())
        if not m:
            rep.bad("L1", i_head + 2, f"band line is not one of the two locked shapes: {band_line!r}")
            band_closed = None
        else:
            band_closed = m.group(1)

    rows = {}
    row_order = []
    for off, l in enumerate(head):
        m = re.match(r"^\|\s*(\w+)\s*\|\s*([a-z-]+)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|$", l)
        if not m:
            continue
        aspect, state, since, basis = m.groups()
        if aspect in ("Aspect",):
            continue
        row_order.append(aspect)
        rows[aspect] = {"state": state, "since": since, "basis": basis,
                        "lineno": i_head + 2 + off}
        if aspect not in ASPECTS:
            rep.bad("L1", i_head + 2 + off, f"unknown aspect in the head table: {aspect!r}")
        if state not in STATES:
            rep.bad("L2", i_head + 2 + off,
                    f"{aspect}: state {state!r} is not one of the five ({' · '.join(STATES)})")

    if row_order != ASPECTS:
        rep.bad("L1", i_head + 2,
                f"the six rows must be present in DAG order {' · '.join(ASPECTS)}; got "
                f"{' · '.join(row_order) if row_order else '(none)'}")

    head_text = "\n".join(head)
    for hl in HEAD_LINES:
        if hl not in head_text:
            rep.bad("L1", i_head + 2, f"the head is missing its `{hl}` line")

    def head_line_value(prefix):
        for l in head:
            if l.startswith(prefix):
                return l[len(prefix):].strip()
        return ""

    # ── L17 — the cross-cutting register's grammar (§2.4, D-O72) ────────────
    #
    # Presence is L1's above; this is the line's own shape. Both vocabularies
    # are closed by ruling, ids are unique, and `none` is not a value the line
    # can take: the language engagement default always stands (D-O74).
    xo_line = head_line_value("Cross-cutting:")
    if xo_line:
        if xo_line.lower() in ("none", "none found", "none stated"):
            rep.bad("L17", i_head + 2,
                    "the `Cross-cutting:` line reads `none` — the language "
                    "engagement default always stands, so this line is never "
                    "empty (D-O74)")
        seen_xo = {}
        for chunk in xo_line.split(" · "):
            chunk = chunk.strip()
            if not chunk or chunk.startswith("<"):
                continue
            m = RE_XO.match(chunk)
            if not m:
                rep.bad("L17", i_head + 2,
                        f"register entry does not parse as "
                        f"`XO-<n> — <class>: <value> (<citation>) — <state>`: {chunk!r}")
                continue
            n, cls, rest = int(m.group("n")), m.group("cls").strip().lower(), m.group("rest")
            if n in seen_xo:
                rep.bad("L17", i_head + 2, f"XO-{n} appears twice on the line")
            seen_xo[n] = True
            if cls not in XO_CLASSES:
                rep.bad("L17", i_head + 2,
                        f"XO-{n}: class {cls!r} is not one of the five "
                        f"({' · '.join(XO_CLASSES)}) — the set is closed, and a sixth "
                        "enters only by decision number on the record")
            last = None
            for sm in RE_XO_STATE.finditer(rest):
                last = sm
            if last is None:
                rep.bad("L17", i_head + 2,
                        f"XO-{n}: no state — one of "
                        f"{' · '.join(XO_STATES)}, never absence")
            elif last.group("state") in ("carried", "accepted") \
                    and not rest[last.end():].strip(" —"):
                rep.bad("L17", i_head + 2,
                        f"XO-{n}: `{last.group('state')}` carries no "
                        f"{'unit' if last.group('state') == 'carried' else 'reason'} — "
                        "no state ends an obligation without one")

    # ── L19 — the acceptance-shape register's grammar (§2.4, D-O78) ─────────
    #
    # Presence is L1's above; this is the line's own shape.  The state
    # vocabulary is closed at three, ids are unique, and `none found` is a
    # legal, recorded value — the acceptance register is not the cross-cutting
    # one, which the language default keeps non-empty.  A `superseded` entry
    # names its `SD-<n>`; an `accepted` one names its reason: no state ends an
    # acceptance item without one.
    as_line = head_line_value("Acceptance shapes:")
    if as_line and as_line.lower() not in ("none found", "none"):
        seen_as = {}
        for chunk in as_line.split(" · "):
            chunk = chunk.strip()
            if not chunk or chunk.startswith("<"):
                continue
            m = RE_AS.match(chunk)
            if not m:
                rep.bad("L19", i_head + 2,
                        f"register entry does not parse as "
                        f"`AS-<n> — <acceptance item> (<citation>) — <state>`: {chunk!r}")
                continue
            n, rest = int(m.group("n")), m.group("rest")
            if n in seen_as:
                rep.bad("L19", i_head + 2, f"AS-{n} appears twice on the line")
            seen_as[n] = True
            if "(" not in rest or ")" not in rest:
                rep.bad("L19", i_head + 2,
                        f"AS-{n}: no verbatim citation — cite-or-mark applies "
                        "to every harvested item (D-O78)")
            last = None
            for sm in RE_AS_STATE.finditer(rest):
                last = sm
            if last is None:
                rep.bad("L19", i_head + 2,
                        f"AS-{n}: no state — one of "
                        f"{' · '.join(AS_STATES)}, never absence")
                continue
            st = last.group("state")
            tail = rest[last.end():].strip(" —")
            if st == "superseded" and not re.match(r"^SD-\d+\b", tail):
                rep.bad("L19", i_head + 2,
                        f"AS-{n}: `superseded` names no `SD-<n>` — the "
                        "supersession is recorded, never silent (D-O78)")
            elif st == "accepted" and not tail:
                rep.bad("L19", i_head + 2,
                        f"AS-{n}: `accepted` carries no reason — a declined "
                        "item is a record, never silence")

    # ── L20 — the change register's grammar (§2.4, D-O102) ─────────────────
    #
    # The line is optional by ruling — an absent line reads `none`, so a ledger
    # written before D-O102 is legal.  What is asserted is the shape once the
    # line stands: ids unique, five states and nothing else, and no state
    # ending a change without what that state exists to name.  A `held` trigger
    # is event-shaped, never a date — the deferred-consequence law (§5.3), and
    # the same `DATE_WISH` guard the AW's revisit trigger takes: no scheduler
    # exists anywhere in the framework, so a date is a wish nothing reads.
    cr_line = head_line_value("Changes:")
    if cr_line and cr_line.lower() not in ("none", "none found"):
        seen_cr = {}
        for chunk in RE_CR_SPLIT.split(cr_line):
            chunk = chunk.strip()
            if not chunk or chunk.startswith("<"):
                continue
            m = RE_CR.match(chunk)
            if not m:
                rep.bad("L20", i_head + 2,
                        f"register entry does not parse as "
                        f"`CR-<n> — <the change, one line> (<from>) — <state>`: {chunk!r}")
                continue
            n, rest = int(m.group("n")), m.group("rest")
            if n in seen_cr:
                rep.bad("L20", i_head + 2, f"CR-{n} appears twice on the line")
            seen_cr[n] = True
            if "(" not in rest or ")" not in rest:
                rep.bad("L20", i_head + 2,
                        f"CR-{n}: no `(<from>)` — who brought the change is half "
                        "of what this register holds (D-O102)")
            last = None
            for sm in RE_CR_STATE.finditer(rest):
                last = sm
            if last is None:
                rep.bad("L20", i_head + 2,
                        f"CR-{n}: no state — one of "
                        f"{' · '.join(CR_STATES)}, never absence")
                continue
            st = last.group("state")
            tail = rest[last.end():].strip(" —")
            if st == "held":
                trig = re.sub(r"^trigger:\s*", "", tail)
                if not tail.startswith("trigger:") or not trig:
                    rep.bad("L20", i_head + 2,
                            f"CR-{n}: `held` names no trigger — a hold is "
                            "event-shaped and never open-ended (D-O102)")
                elif DATE_WISH.search(trig):
                    rep.bad("L20", i_head + 2,
                            f"CR-{n}: the hold trigger {trig!r} is a date wish, not "
                            "an event — no scheduler exists; only an event can be "
                            "recognized at a touchpoint")
            elif st in ("routed", "landed", "declined") and not tail:
                what = {"routed": "acts", "landed": "refs",
                        "declined": "reason"}[st]
                rep.bad("L20", i_head + 2,
                        f"CR-{n}: `{st}` names no {what} — no state ends a change "
                        "without one (D-O102)")

    # ── replay the events ───────────────────────────────────────────────────
    state = {a: "untouched" for a in ASPECTS}
    since = {a: "" for a in ASPECTS}
    excluded = {}                 # artifact → line-no of its standing exclusion
    encountered = set()           # artifacts whose encounter line was written
    band_entered = False
    closed_on = None
    last_date = ""
    ro_reopened = {}          # RO-id -> [aspects it reopened]
    ro_status = {}            # RO-id -> received | open | resolved | declined
    ro_seen = set()
    cr_status = {}            # CR-id -> received | held | routed | landed | declined
    cr_seen = set()
    aw_status = {}            # AW-id -> granted | superseded | lapsed | voided

    for lineno, header, cont in parse_blocks(lines, i_ev + 1, len(lines)):
        body = " ".join(c for _, c in cont)

        m = RE_TRANSITION.match(header)
        if m:
            date, tn, aspect, frm, to, who, basis = m.groups()
            tn = int(tn)
            if date < last_date:
                rep.bad("L13", lineno, f"event dated {date} follows {last_date}")
            last_date = max(last_date, date)

            if aspect not in ASPECTS:
                rep.bad("L4", lineno, f"unknown aspect {aspect!r}")
                continue
            for s in (frm, to):
                if s not in STATES:
                    rep.bad("L2", lineno, f"{s!r} is not one of the five states")
            if tn not in TRANSITIONS:
                rep.bad("L4", lineno, f"T{tn} does not exist — the table is T1..T8")
            elif (frm, to) not in TRANSITIONS[tn]:
                legal = " | ".join(f"{a} → {b}" for a, b in TRANSITIONS[tn])
                rep.bad("L4", lineno,
                        f"T{tn} is `{legal}`, not `{frm} → {to}`"
                        + ("  — and there is no first-pass-cleared → open transition at all: "
                           "only a contradiction degrades a cleared aspect"
                           if (frm, to) == ("first-pass-cleared", "open") else ""))
            if state[aspect] != frm:
                rep.bad("L7", lineno,
                        f"{aspect} is {state[aspect]!r} at this point, but the event "
                        f"transitions from {frm!r}")

            pat, want = BASIS_MUST_NAME.get(tn, (None, ""))
            if pat and not pat.search(basis):
                rep.bad("L6", lineno, f"T{tn} basis must name {want}; got {basis!r}")
            if not who.strip():
                rep.bad("L6", lineno, "no BA initials on the transition")

            if tn == 1:
                if not band_entered:
                    rep.bad("L5", lineno,
                            f"{aspect} opened before Band 1 was entered (§8.1 Frame)")
                for p in PREREQ[aspect]:
                    if state[p] not in PROGRESSION_GRANTED:
                        rep.bad("L5", lineno,
                                f"{aspect} may open only when {p} is cleared-or-waived; "
                                f"{p} is {state[p]!r}"
                                + (" — a reopen blocks new opening through itself"
                                   if state[p] == "reopened" else ""))
            if tn == 5:
                ro = re.search(r"RO-(\d+)", basis)
                if ro:
                    rid = ro.group(1)
                    ro_reopened.setdefault(rid, []).append(aspect)
                    if rid not in ro_seen:
                        rep.bad("L14", lineno,
                                f"T5 cites RO-{rid}, which was never logged `received` — "
                                "intake is unconditional and comes first")
                    ro_status[rid] = "open"
                    if len(ro_reopened[rid]) > 1:
                        rep.bad("L10", lineno,
                                f"RO-{rid} now reopens {len(ro_reopened[rid])} aspects "
                                f"({' · '.join(ro_reopened[rid])}) — dependents are flagged "
                                "`upstream reopened`, never auto-reopened")
            if tn in (6, 7):
                ro = re.search(r"RO-(\d+)", basis)
                if ro:
                    ro_status[ro.group(1)] = "resolved" if tn == 6 else "waived-closed"
            if tn in (3, 7):
                aw = re.search(r"AW-(\d+)", basis)
                if aw:
                    aw_status.setdefault(aw.group(1), "granted")
            if tn == 4:
                for aw in re.findall(r"AW-(\d+)", basis):
                    aw_status[aw] = "superseded"
            if tn == 8:
                for aw in re.findall(r"AW-(\d+)", basis):
                    aw_status[aw] = "lapsed"

            state[aspect] = to
            since[aspect] = date
            continue

        m = RE_BAND_ENTER.match(header)
        if m:
            band_entered = True
            last_date = max(last_date, m.group(1))
            continue

        m = RE_BAND_CLOSE.match(header)
        if m:
            date = m.group(1)
            if date < last_date:
                rep.bad("L13", lineno, f"closure dated {date} follows {last_date}")
            last_date = max(last_date, date)
            unmet = [a for a in ASPECTS if state[a] not in PROGRESSION_GRANTED]
            reopened = [a for a in ASPECTS if state[a] == "reopened"]
            if reopened:
                rep.bad("L11", lineno,
                        f"closure declared with {' · '.join(reopened)} `reopened` — "
                        "a live conflict is neither cleared nor waived")
            other = [a for a in unmet if a not in reopened]
            if other:
                rep.bad("L11", lineno,
                        "closure declared with "
                        + " · ".join(f"{a} {state[a]}" for a in other)
                        + " — all six must be first-pass-cleared or waived")
            standing = [a for a, s in aw_status.items() if s == "granted"]
            if standing and "re-affirmed" not in body:
                rep.bad("L11", lineno,
                        f"AW-{' · AW-'.join(sorted(standing))} standing, but the closure "
                        "event records no re-affirmation into the armed state")
            if "arming run" not in body:
                rep.bad("L11", lineno,
                        "the closure event does not record the requested arming Scope-H run "
                        "— closure completes when that entry exists")
            closed_on = date
            continue

        if RE_BAND3.match(header) or RE_CYCLE_CLOSE.match(header):
            date = header[:10]
            if not closed_on and not allow_open_band:
                rep.bad("L11", lineno, "a Band-3 event before Band-1 closure")
            last_date = max(last_date, date)
            continue

        m = RE_REVIEW.match(header)
        if m:
            aspect, date = m.groups()
            if aspect not in ASPECTS:
                rep.bad("L3", lineno, f"evidence table for unknown aspect {aspect!r}")
            ats = re.findall(r"AT-[A-Z]{2}-\d", " ".join(c for _, c in cont))
            if not ats:
                rep.bad("L6", lineno,
                        f"the {aspect} evidence table names no AT criterion — "
                        "a clearing names its evidence")
            verdict = [c for _, c in cont if c.startswith("→")]
            if not verdict:
                rep.bad("L6", lineno,
                        f"the {aspect} evidence table carries no `→ CLEARED / NOT CLEARED "
                        "/ WAIVE` ruling — the framework proposes, the BA rules")
            else:
                v = verdict[0]
                if not re.match(r"^→ (CLEARED|NOT CLEARED|WAIVE)\b", v):
                    rep.bad("L6", lineno, f"unknown aspect-gate ruling: {v!r}")
            for n, c in cont:
                if c.startswith("|") and "✗" in c and "—" not in c:
                    rep.bad("L6", n, f"a miss with no named element: {c!r}")
            continue

        m = RE_RO_RECV.match(header)
        if m:
            rid = m.group(1)
            ro_seen.add(rid)
            ro_status[rid] = "received"
            last_date = max(last_date, m.group(2))
            continue

        m = RE_RO.match(header)
        if m:
            rid, aspect, rest = m.groups()
            ro_seen.add(rid)
            joined = rest + " " + " ".join(
                c for _, c in cont
                if not re.match(r"^(source|status|blast radius|ruling|deferred|resolution):", c))
            if aspect not in ASPECTS:
                rep.bad("L9", lineno, f"RO-{rid} maps to unknown aspect {aspect!r}")
            if ":" not in joined or "→" not in joined:
                rep.bad("L9", lineno,
                        f"RO-{rid} is not in the §5.3 grammar `<contradicted artifact:line>: "
                        f"<conflict statement> → <resolution path>`: {joined.strip()!r}")
            st = next((c.split(":", 1)[1].strip() for _, c in cont
                       if c.startswith("status:")), "")
            if st:
                kind = st.split()[0].rstrip(",")
                if kind not in ("received", "open", "resolved", "declined"):
                    rep.bad("L14", lineno, f"RO-{rid}: unknown status {st!r}")
                ro_status[rid] = kind
            if "blast radius:" in " ".join(c for _, c in cont):
                br = " ".join(c for _, c in cont)
                if "no cascade" not in br:
                    rep.bad("L10", lineno,
                            f"RO-{rid}'s blast radius does not state the no-cascade rule — "
                            "dependents are flagged, never auto-reopened")
                if "ruling:" not in br:
                    rep.bad("L9", lineno,
                            f"RO-{rid}'s blast radius is stated but never ruled "
                            "(continue-with-visibility, or named pauses)")
            continue

        # ── the CR record class (§7.7, D-O102) — records, not a new event kind ──
        m = RE_CR_RECV.match(header)
        if m:
            cid, date = m.group(1), m.group(2)
            cr_seen.add(cid)
            cr_status[cid] = "received"
            if date < last_date:
                rep.bad("L13", lineno, f"CR record dated {date} follows {last_date}")
            last_date = max(last_date, date)
            continue

        m = RE_CR_RULED.match(header)
        if m:
            cid, date, ruling = m.group(1), m.group(2), m.group(4)
            if cid not in cr_seen:
                rep.bad("L20", lineno,
                        f"CR-{cid} is ruled with no `received` record before it — "
                        "the record exists before any classification (§7.7)")
            cr_seen.add(cid)
            verb = ruling.split(" — ")[0].split(" · ")[0].strip()
            if verb not in CR_RULINGS:
                rep.bad("L20", lineno,
                        f"CR-{cid}: unknown ruling {verb!r} — the ruling is one of "
                        f"{' · '.join(CR_RULINGS)} (P-O10)")
            else:
                cr_status[cid] = {"take": "routed", "decline": "declined",
                                  "hold": "held"}[verb]
            if verb == "hold":
                trig = ruling.split("trigger:", 1)[1].strip() if "trigger:" in ruling else ""
                if not trig:
                    rep.bad("L20", lineno,
                            f"CR-{cid}: `hold` names no trigger — event-shaped, "
                            "never a date (§7.7)")
                elif DATE_WISH.search(trig):
                    rep.bad("L20", lineno,
                            f"CR-{cid}: the hold trigger {trig!r} is a date wish, "
                            "not an event — no scheduler exists")
            elif verb == "decline" and not ruling.split(" · ")[0].partition(" — ")[2].strip():
                rep.bad("L20", lineno,
                        f"CR-{cid}: `decline` carries no reason — the reason is the "
                        "record, and a declined change is never a silent drop (§5.1)")
            if "targets:" not in ruling:
                rep.bad("L20", lineno,
                        f"CR-{cid}: the ruling names no `targets:` — a change is "
                        "ruled against the estate it was located in (§7.7)")
            if date < last_date:
                rep.bad("L13", lineno, f"CR record dated {date} follows {last_date}")
            last_date = max(last_date, date)
            continue

        m = RE_CR_LANDED.match(header)
        if m:
            cid, date, refs = m.group(1), m.group(2), m.group(3)
            if cid not in cr_seen:
                rep.bad("L20", lineno,
                        f"CR-{cid} lands with no `received` record before it — "
                        "every change is received once, before anything else (§7.7)")
            cr_seen.add(cid)
            if not refs.strip():
                rep.bad("L20", lineno,
                        f"CR-{cid}: `landed` names no refs — the CR binds the records "
                        "its route wrote and duplicates none of them (§7.7)")
            cr_status[cid] = "landed"
            if date < last_date:
                rep.bad("L13", lineno, f"CR record dated {date} follows {last_date}")
            last_date = max(last_date, date)
            continue

        m = RE_AW.match(header)
        if m:
            aid, aspect, unmet = m.groups()
            if aspect not in ASPECTS:
                rep.bad("L8", lineno, f"AW-{aid} names unknown aspect {aspect!r}")
            if not re.search(r"AT-[A-Z]{2}-\d", unmet):
                rep.bad("L8", lineno,
                        f"AW-{aid}: the unmet field names no AT-ID — a waiver names its "
                        "unmet criteria, each with exactly what is missing")
            elif "—" not in unmet and not any("—" in c for _, c in cont[:1]):
                rep.bad("L8", lineno,
                        f"AW-{aid}: the unmet criteria are named but not what is missing")
            fields = {c.split(":", 1)[0].strip(): c.split(":", 1)[1].strip()
                      for _, c in cont if ":" in c}
            for f in AW_FIELDS:
                if f not in fields or not fields[f]:
                    rep.bad("L8", lineno, f"AW-{aid}: missing the `{f}` field")
            trig = fields.get("revisit trigger", "")
            if trig and DATE_WISH.search(trig):
                rep.bad("L8", lineno,
                        f"AW-{aid}: revisit trigger {trig!r} is a date wish, not an event — "
                        "no scheduler exists; only an event can be recognized at a touchpoint")
            st = fields.get("status", "")
            if st:
                aw_status[aid] = st.split()[0].rstrip(",")
            continue

        if RE_GAP.match(header):
            continue

        # ── the five §2.4 head-line events ──────────────────────────────────
        m = RE_SOURCE.match(header)
        if m:
            date, name, src_state = m.group(1), m.group(2), m.group(3)
            if RE_ENCOUNTER.match(src_state):
                # not a state — the encounter of a reference the run refused to
                # follow, on the same grammar (D-O70). It never changes the
                # artifact's standing.
                encountered.add(name)
            elif not RE_SOURCE_STATE.match(src_state):
                rep.bad("L3", lineno,
                        f"source {name!r} carries state {src_state!r} — the vocabulary is "
                        "closed at five: `captured <date>` · `named — pending` · "
                        "`skipped — <reason>` · `excluded — <reason>` · `none` "
                        "(§2.4, D-O48 extended by D-O70)")
            else:
                # L15 — the exclusion law: never captured, at any later moment.
                # An exclusion is liftable, so the standing state is the latest.
                if src_state.startswith("excluded — "):
                    excluded[name] = lineno
                elif name in excluded and src_state.startswith("captured"):
                    rep.bad("L15", lineno,
                            f"source {name!r} stands `excluded` and is captured anyway — "
                            "an excluded artifact is never captured and never mined; "
                            "lift the exclusion first, with its reason (§8.1, D-O70)")
                else:
                    excluded.pop(name, None)
            if date < last_date:
                rep.bad("L13", lineno, f"source event dated {date} follows {last_date}")
            last_date = max(last_date, date)
            continue

        m = (RE_PROFILE.match(header) or RE_SCOPE_FRAME.match(header)
             or RE_AUTO_ON.match(header) or RE_AUTO_OFF.match(header)
             or RE_RATIFICATION.match(header))
        if m:
            date = m.group(1)
            if date < last_date:
                rep.bad("L13", lineno, f"event dated {date} follows {last_date}")
            last_date = max(last_date, date)
            continue

        # anything else in Events is not a known form
        rep.bad("L3", lineno, f"unrecognized event line: {header!r}")

    # ── L7 — the head is what the replay produces ───────────────────────────
    for a in ASPECTS:
        if a not in rows:
            continue
        if rows[a]["state"] != state[a]:
            rep.bad("L7", rows[a]["lineno"],
                    f"head says {a} is {rows[a]['state']!r}; replaying the events gives "
                    f"{state[a]!r}")
        if since[a] and rows[a]["since"] not in ("", "—") and rows[a]["since"] != since[a]:
            rep.bad("L7", rows[a]["lineno"],
                    f"head says {a} since {rows[a]['since']}; its last transition is "
                    f"{since[a]}")

    if band_closed and not closed_on:
        rep.bad("L7", i_head + 2,
                f"head reads `closed {band_closed}` but no closure event exists")
    if closed_on and not band_closed:
        rep.bad("L7", i_head + 2,
                f"a closure event dated {closed_on} exists but the head still reads `1 (open)`")

    # ── L14 — open reopens stand in the head ────────────────────────────────
    open_ros = sorted(r for r, s in ro_status.items() if s in ("received", "open"))
    head_ros = head_line_value("Open reopens:")
    for r in open_ros:
        if f"RO-{r}" not in head_ros:
            rep.bad("L14", i_head + 2,
                    f"RO-{r} is unresolved but the head's `Open reopens:` reads "
                    f"{head_ros!r} — an open conflict must be visible at every render")
    if not open_ros and head_ros not in ("none", ""):
        rep.bad("L14", i_head + 2,
                f"the head lists {head_ros!r} but no RO is open in the events")

    # ── L8/L11 — standing AWs stand in the head ─────────────────────────────
    head_aws = head_line_value("Standing aspect waivers:")
    for aid, st in sorted(aw_status.items()):
        if st == "granted" and f"AW-{aid}" not in head_aws:
            rep.bad("L8", i_head + 2,
                    f"AW-{aid} is standing but absent from the head's "
                    "`Standing aspect waivers:` line — the debt must stay named")

    # ── L16 — the encounter is recorded, never silently skipped ─────────────
    #
    # The law's third clause: a reference inside ANY capture that resolves to an
    # excluded artifact is never followed — *and the encounter is recorded* on
    # the source grammar. Silence is what makes an exclusion indistinguishable
    # from a source nobody thought of, which is the hole the inventory closes.
    # Checkable only against the captures themselves, so it runs when they are
    # handed over; the dedup rule bounds the count from above, and what is
    # asserted here is the floor: referenced at least once → at least one line.
    if captures is not None and excluded:
        for name, lineno in sorted(excluded.items()):
            if name in encountered:
                continue
            for cap in sorted(captures.rglob("*.md")):
                if name in cap.read_text(encoding="utf-8", errors="replace"):
                    rep.bad("L16", lineno,
                            f"{cap.name} references the excluded artifact {name!r} and no "
                            "encounter line records it — the reference is never followed, "
                            "and the encounter is never silent (§8.1 · §2.4, D-O70)")
                    break

    # ── L18 — the harvest floor: a captured obligation reaches the register ──
    #
    # D-O73's mid-band clause, at its decidable half: a cross-cutting fact
    # standing in a capture appends its `XO-<n>` entry — the register line is
    # the record, and silence is what the ruling forbids. Detection is at the
    # marker grade above and UNDER-REPORTS by construction: a fact worded
    # outside the marker set is not seen here, exactly as L16 asserts the floor
    # of the encounter rule and claims nothing beyond it. Runs only when the
    # captures are handed over.
    if captures is not None:
        classes_held = set()
        for chunk in head_line_value("Cross-cutting:").split(" · "):
            m = RE_XO.match(chunk.strip())
            if not m:
                continue
            cls = m.group("cls").strip().lower()
            sm = None
            for sm in RE_XO_STATE.finditer(m.group("rest")):
                pass
            # the reserved English default is the framework's own law, never a
            # captured client fact — it satisfies nothing on this line
            if sm is not None and sm.group("state") == "default":
                continue
            classes_held.add(cls)
        for cap in sorted(captures.rglob("*.md")):
            text = cap.read_text(encoding="utf-8", errors="replace")
            for cls, marker in sorted(XO_MARKERS.items()):
                if cls in classes_held:
                    continue
                m = marker.search(text)
                if m:
                    rep.bad("L18", i_head + 2,
                            f"{cap.name} states a {cls} obligation ({m.group(0)!r}) and the "
                            f"`Cross-cutting:` line carries no {cls} `XO-<n>` entry — a "
                            "captured obligation is registered, never left to silence "
                            "(§8.1, D-O73)")
                    classes_held.add(cls)

    return rep


def main():
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("ledger", nargs="?")
    ap.add_argument("--expect", default="",
                    help="comma-separated rule IDs this ledger MUST trip (negatives)")
    ap.add_argument("--allow-open-band", action="store_true",
                    help="permit Band-2/3 events without a closure event (partial fixtures)")
    ap.add_argument("--captures", default="",
                    help="the run's sources/ directory — enables L16, the encounter guard")
    ap.add_argument("--rules", action="store_true")
    a = ap.parse_args()

    if a.rules:
        for k in sorted(RULES):
            print(f"{k:4} {RULES[k]}")
        return 0

    if not a.ledger:
        ap.error("a ledger path is required")
    path = pathlib.Path(a.ledger)
    if not path.is_file():
        print(f"✗ no such ledger: {path}", file=sys.stderr)
        return 2

    captures = pathlib.Path(a.captures) if a.captures else None
    if captures is not None and not captures.is_dir():
        print(f"✗ no such captures directory: {captures}", file=sys.stderr)
        return 2
    rep = check(path, a.allow_open_band, captures)

    if a.expect:
        want = sorted({r.strip() for r in a.expect.split(",") if r.strip()})
        got = rep.tripped
        if got == want:
            print(f"✓ {path.name}: tripped exactly {', '.join(want)}")
            for r, n, m in rep.violations:
                print(f"    {r} line {n}: {m}")
            return 0
        print(f"✗ {path.name}: expected {', '.join(want) or '(none)'}, "
              f"tripped {', '.join(got) or '(none)'}", file=sys.stderr)
        for r, n, m in rep.violations:
            print(f"    {r} line {n}: {m}", file=sys.stderr)
        return 1

    if not rep.violations:
        print(f"✓ {path.name}: grammar-legal — "
              f"{len(RULES)} rules, no violations")
        return 0

    print(f"✗ {path.name}: {len(rep.violations)} violation(s)", file=sys.stderr)
    for r, n, m in rep.violations:
        print(f"  {r} line {n}: {m}", file=sys.stderr)
        print(f"       rule: {RULES[r]}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
