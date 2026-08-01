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
    "L3":  "event grammar — every event line is one of the known forms (§2.3)",
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

HEAD_LINES = ["Standing aspect waivers:", "Open reopens:",
              "Upstream flags:", "Deferred consequences:"]


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


def check(path: pathlib.Path, allow_open_band: bool) -> Report:
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

    # ── replay the events ───────────────────────────────────────────────────
    state = {a: "untouched" for a in ASPECTS}
    since = {a: "" for a in ASPECTS}
    band_entered = False
    closed_on = None
    last_date = ""
    ro_reopened = {}          # RO-id -> [aspects it reopened]
    ro_status = {}            # RO-id -> received | open | resolved | declined
    ro_seen = set()
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

    return rep


def main():
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("ledger", nargs="?")
    ap.add_argument("--expect", default="",
                    help="comma-separated rule IDs this ledger MUST trip (negatives)")
    ap.add_argument("--allow-open-band", action="store_true",
                    help="permit Band-2/3 events without a closure event (partial fixtures)")
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

    rep = check(path, a.allow_open_band)

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
