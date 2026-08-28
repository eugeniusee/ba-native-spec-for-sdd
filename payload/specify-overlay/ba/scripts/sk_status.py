#!/usr/bin/env python3
"""sk_status — the project dashboard (orchestrator rules §10.4, D-O26–D-O29).

BA-Native Spec · the render behind `/ba-status`.
Anchors: orchestrator §10.4 (the whole of it — the two source classes, the
nine-line pinned shape, the count definitions, formula §10.4-F, the HTML
render) · §10.3 (the BA-facing register every line follows) · §6.5 (the flow
profiles line 8 switches on) · §7.3 (the run log line 6 counts against) ·
§6.4 (the plans file that holds it) · §10.5 (the read precedent this reuses —
the certified check and the epic hop are imported, never restated) · contract
§3 (the Scope-H cadence line 5 measures against) · gate §11.1 (the
certification manifest).

**Read-only, always.** Every source below is opened for reading and never
written. The only file this script can create is the `--html` derived render.

  Activity — the ledgers (§10.4, source class 1):
    .specify/aspect-state.md     the head's six states · band line · profile ·
                                 standing AWs · open reopens · health line
    .specify/aspect-plans.md     composed plans (§6.4) · run logs (§7.3)
    .specify/gate-health.md      the head's gaps and acceptances · the runs

  Coverage — the estate on disk (§10.4, source class 2; the §10.5 precedent):
    specs/NNN-*/spec.md          entered · drafted (≥ 1 User Story) · markers
    specs/NNN-*/gate-report.md   gated · the latest verdict · certified
    .specify/memory/scope/*.md   briefs · kits · the §6 open questions
    .specify/memory/roadmap.md   the epic roster · the allocation log's date

  Written: nothing, unless --html (.specify/status.html, regenerated per run)

Four derivations this script fixes, each inside what §10.4 states:

  · **Bar cells.** "Its own ratio at ten cells" — `int(ratio * 10 + 0.5)`.
    The named count always renders beside the bar, so the bar decorates a
    fact rather than carrying one.
  · **The mean over a missing band.** §10.4-F takes the mean of three ratios
    and rules that a zero denominator renders `—`, never 0%. A band with no
    denominator therefore contributes no ratio: the mean is taken over the
    ratios that exist, and renders `—` when none do. A project with no epics
    is not 0% through Band 2 — it has not been asked the question yet.
  · **The cadence denominator.** §10.4 names it: one full run per scope-brief
    ingestion batch. An ingested brief is one that reached `Status: Scoped`
    (elicitation §4), so the expected count is the briefs at that status,
    plus the arming run once Band 1 is closed (§8.2 · contract §3).
  · **Handed off.** §10.4's count definition names its missing source: the
    implementation entry check (gate §11.2) re-points `.specify/feature.json`
    and cuts the branch, neither of which is a per-feature count, and no
    per-feature handoff record exists to count. The count renders `—` with
    its missing source named, per §10.4's own discipline: the instrument
    reports its blind spots. A countable record stays a future ruling.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import html
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True

sys.path.insert(0, str(Path(__file__).resolve().parent))

from sk_structure import SPEC_HEADINGS, parse_spec, table_rows  # noqa: E402

# The estate is read with the WBS export's own readers, imported rather than
# restated. §10.5 already fixed what "certified" means on disk and how a spec
# names its parent epic; this render must never read them differently — a
# second copy of either is a second thing to drift (the sk_wbs precedent, and
# the reason its own §10 reader is imported from the gate).
from sk_wbs import (  # noqa: E402
    MARKER_RE,
    brief_epic_name,
    feature_folders,
    read_gate_report,
    read_profile,
    read_roadmap,
    spec_epic_id,
)
from sk_health import ALLOC_HEAD_RE, _section, allocation_entries  # noqa: E402

# ── the pinned shape (§10.4) ─────────────────────────────────────────────────

CELLS = 10
BAR_FULL, BAR_EMPTY = "█", "░"
BAR_OPEN, BAR_CLOSE = "▕", "▏"

# The six aspects, in DAG order (plan Q1a; §5). The head's own row order.
ASPECTS = ["Stakeholders", "Context", "Value", "Vision", "Solution", "Requirements"]
SETTLED = ("first-pass-cleared", "waived")

DATE = r"\d{4}-\d{2}-\d{2}"

# The derived HTML render's home: beside the runtime ledgers, which is where
# §10.4 puts it (D-O29). `.specify/` holds the three ledgers already, and the
# file joins them under the same D-G1/D-G8 rule — outside `.specify/memory/`,
# so it never enters CC-H-01's spec-anchored glob and its own write never
# fires a scoped H run.
HTML_NAME = "status.html"


def bar(ratio) -> str:
    """One ten-cell bar. A ratio of None — no denominator — renders empty."""
    if ratio is None:
        return BAR_OPEN + BAR_EMPTY * CELLS + BAR_CLOSE
    filled = int(ratio * CELLS + 0.5)
    filled = max(0, min(CELLS, filled))
    return BAR_OPEN + BAR_FULL * filled + BAR_EMPTY * (CELLS - filled) + BAR_CLOSE


def ratio_of(num, den):
    """`—`, never 0%, when the denominator is zero (§10.4-F)."""
    if not den:
        return None
    return num / den


def pct(ratio) -> str:
    return "—" if ratio is None else "%d%%" % int(ratio * 100 + 0.5)


# ── the ledgers (activity) ───────────────────────────────────────────────────


def read_head(root: Path):
    """`.specify/aspect-state.md` — the head, read as counts, never rewritten.

    The head is the authority on aspect state: this reads it, and never
    re-derives it from the events below (a head that contradicts its events is
    a defect to report, not to repair in passing).
    """
    out = {"exists": False, "band": "", "closed": "", "profile": "",
           "states": {}, "waivers": [], "reopens": [], "project": ""}
    path = root / ".specify" / "aspect-state.md"
    if not path.is_file():
        return out
    text = path.read_text(encoding="utf-8")
    out["exists"] = True

    m = re.search(r"^#\s*Aspect State\s*[—–-]\s*(?P<name>.+?)\s*$", text, re.M)
    if m and not m.group("name").strip().startswith("<"):
        out["project"] = m.group("name").strip()   # `<project>` is the unfilled
                                                   # template, never a name

    # Only the head is read. The events below carry aspect names in their own
    # tables — a delta evidence table's dependent reckoning names five of the
    # six — and reading the whole file would let an event overwrite the state
    # the head declares. The head is the authority (§2.4); the events are its
    # history, and this render never re-derives one from the other.
    block = re.search(r"^##\s*Current state\b(?P<body>.*?)(?=^##\s|\Z)",
                      text, re.M | re.S)
    head = block.group("body") if block else text

    m = re.search(r"^Band:\s*(?P<band>.+?)\s*$", head, re.M)
    if m:
        out["band"] = m.group("band").strip()
        closed = re.search(r"closed\s+(%s)" % DATE, out["band"])
        out["closed"] = closed.group(1) if closed else ""

    m = re.search(r"^Profile:\s*(?P<p>Discovery|Presale)\b", head, re.M | re.I)
    if m:
        out["profile"] = m.group("p").lower()

    for cells in table_rows(head):
        if len(cells) >= 2 and cells[0].strip() in ASPECTS:
            out["states"].setdefault(cells[0].strip(), cells[1].strip())

    for key, prefix in (("waivers", "Standing aspect waivers:"),
                        ("reopens", "Open reopens:")):
        m = re.search(r"^%s\s*(?P<v>.*?)\s*$" % re.escape(prefix), head, re.M)
        value = m.group("v").strip() if m else "none"
        out[key] = [] if value.lower() == "none" else [value]
    return out


def plans_sections(root: Path):
    """`.specify/aspect-plans.md` split at its `## ` headings (§6.4)."""
    path = root / ".specify" / "aspect-plans.md"
    if not path.is_file():
        return {}
    text = path.read_text(encoding="utf-8")
    out, name, buf = {}, None, []
    for line in text.splitlines():
        m = re.match(r"^##\s+(?P<name>.+?)\s*$", line)
        if m:
            if name is not None:
                out[name] = "\n".join(buf)
            name, buf = m.group("name").strip(), []
            continue
        if name is not None:
            buf.append(line)
    if name is not None:
        out[name] = "\n".join(buf)
    return out


RUN_LINE_RE = re.compile(r"^(?P<date>%s)\s+·\s+(?P<what>.+?)\s+·\s+contract:" % DATE)


def run_lines(section_text: str):
    """The §7.3 run-log lines of one plans-file section.

    The line shape is §6.4's: `<date> · <technique> · contract: …`. Comment
    blocks carry the shape as documentation, so they are skipped — a template
    line is not a run.
    """
    out, in_comment = [], False
    for line in section_text.splitlines():
        s = line.strip()
        if s.startswith("<!--"):
            in_comment = True
        if in_comment:
            if "-->" in s:
                in_comment = False
            continue
        m = RUN_LINE_RE.match(s)
        if m:
            out.append({"date": m.group("date"), "what": m.group("what").strip()})
    return out


def element_lines(section_text: str, pattern: str):
    """The run lines that name an element — an epic, or a feature.

    Every record names its element and its action (the document's third
    runtime rule). A line that names only its technique cannot be read against
    the estate, so it is not counted here — and its absence is exactly what
    the ledger-coverage line reports.
    """
    return [r for r in run_lines(section_text) if re.search(pattern, r["what"])]


def plan_rows(section_text: str):
    """The composed plan's rows — `| # | Code — technique | … | Status |`."""
    rows = []
    for cells in table_rows(section_text):
        if len(cells) < 5 or not re.fullmatch(r"\d+", cells[0].strip()):
            continue
        name = cells[1].strip()
        if name.startswith("<"):        # an unfilled template placeholder
            continue
        rows.append({"name": name, "status": cells[-1].strip()})
    return rows


def read_health(root: Path):
    """`.specify/gate-health.md` — the head's standing state and the runs."""
    out = {"exists": False, "verdict": "", "acceptances": 0, "full_runs": 0}
    path = root / ".specify" / "gate-health.md"
    if not path.is_file():
        return out
    text = path.read_text(encoding="utf-8")
    out["exists"] = True

    runs = list(re.finditer(
        r"^##\s*Health run\s+(?P<n>\d+)\s*[—–-]\s*(?P<date>%s)\s*[—–-]\s*(?P<scope>[^—–\n]+)"
        % DATE, text, re.M))
    out["full_runs"] = sum(1 for r in runs if r.group("scope").strip().lower() == "full")
    if runs:
        body = text[runs[-1].end():]
        m = re.search(r"^Verdict:\s*(?P<v>.+?)\s*$", body, re.M)
        out["verdict"] = m.group("v").strip() if m else ""

    m = re.search(r"^Health acceptances:\s*(?P<v>.*?)\s*$", text, re.M)
    value = m.group("v").strip() if m else "none"
    if value and value.lower() != "none":
        out["acceptances"] = len([p for p in value.split("·") if p.strip()])
    return out


# ── the estate on disk (coverage) ────────────────────────────────────────────


def read_briefs(root: Path):
    """`.specify/memory/scope/` — the briefs, their kits, their §6 questions.

    A brief is `<E-nn>.md`; its kit is `<E-nn>.kit.md`. `Status: Scoped` marks
    an ingested brief — the ingestion batch line 5's cadence counts against.
    """
    out = {"briefs": {}, "kits": [], "questions": [], "scoped": 0}
    scope = root / ".specify" / "memory" / "scope"
    if not scope.is_dir():
        return out
    for path in sorted(scope.glob("*.md")):
        if path.name.endswith(".kit.md"):
            out["kits"].append(path.stem.replace(".kit", ""))
            continue
        text = path.read_text(encoding="utf-8")
        eid = path.stem
        status = ""
        m = re.search(r"^Status:\s*(?P<s>.+?)\s*$", text, re.M)
        if m:
            status = m.group("s").strip()
        if status.lower().startswith("scoped"):
            out["scoped"] += 1
        out["briefs"][eid] = {
            "name": brief_epic_name(text, eid),
            "status": status,
        }
        out["questions"].extend(brief_questions(eid, text))
    return out


def brief_questions(eid: str, text: str):
    """The brief's §6 Open Questions table — one dict per row.

    The Status column is the elicitation vocabulary: `Open` · `Answered — …` ·
    `Overtaken — …`. Anything else is counted as none of the three and named
    in neither bucket; this render never re-classifies a BA's own wording.

    A row that reaches the section's own shape — its full cell count — and
    whose first cell is not an `OQ-<n>` ID (D12) is a **near-miss**, not a
    non-row: it is carried out with `state` `off-shape` so line 4 can count and
    name it (D-O58). Silently skipping it renders a question the dashboard
    swore was not open.
    """
    block = re.search(r"^##\s*6\.\s*Open Questions\b(?P<body>.*?)(?=^##\s|\Z)",
                      text, re.M | re.S)
    if not block:
        return []
    out = []
    for cells in table_rows(block.group("body")):
        if len(cells) < 4:
            continue
        if not re.fullmatch(r"OQ-\d+", cells[0].strip()):
            out.append({
                "epic": eid,
                "id": cells[0].strip(),
                "question": cells[1].strip(),
                "status": cells[3].strip(),
                "state": "off-shape",
            })
            continue
        status = cells[3].strip()
        out.append({
            "epic": eid,
            "id": cells[0].strip(),
            "question": cells[1].strip(),
            "status": status,
            "state": ("open" if status.lower().startswith("open")
                      else "answered" if status.lower().startswith("answered")
                      else "overtaken" if status.lower().startswith("overtaken")
                      else ""),
        })
    return out


def read_features(root: Path):
    """Every `specs/NNN-*/` — entered, drafted, gated, certified, markers.

    The certified check and the epic hop are §10.5's own, imported: this
    render must never disagree with the export about what certified means.
    """
    out = []
    for nnn, folder in feature_folders(root):
        spec = parse_spec(folder / "spec.md")
        report = read_gate_report(folder / "gate-report.md")
        # An unreadable spec is a fact about this reader, not about the
        # project (orchestrator §10.4, D-O50). It is excluded from `drafted`
        # AND from its denominator, and named — never rendered as `drafted 0`,
        # which asserts something about the spec that was never established.
        readable = spec.readable
        out.append({
            "folder": folder.name,
            "nnn": nnn,
            "epic": spec_epic_id(spec),
            "readable": readable,
            "parse_failure": "" if readable else parse_failure(folder, spec),
            "drafted": bool(spec.stories) and readable,
            "gated": report["disposition"] != "no gate run",
            "verdict": report["disposition"],
            "certified": report["certified"],
            "run_date": report["run_date"],
            "waivers": report["waivers"],
            "markers": len(MARKER_RE.findall(spec.text)) if readable else 0,
        })
    return out


def parse_failure(folder, spec) -> str:
    """`<spec path> — heading found "<as authored>", expected "<standard §2>"`.

    §10.4's named failure: the found-vs-expected pair, because *section absent*
    sends the BA to write a section that already exists.
    """
    path = "%s/spec.md" % folder.name
    if not spec.sections:
        return "%s — no `##` heading found; expected the ten of standard §2" % path
    first = spec.sections[0]
    return ('%s — heading found "%s", expected one of the ten standard §2 '
            "headings (e.g. \"%s\")" % (path, first.raw_name, SPEC_HEADINGS[0]))


def roadmap_log_offenders(root: Path):
    """Allocation-log lines that reach the log's own ground and miss its shape.

    A near-miss, not an absence (D-O58): the file is there, `## Allocation log`
    is there, `###` lines are there, and the heading grammar does not hold.
    Returns (count, first offender as authored) so the render can name what it
    met — never `roadmap missing`, which asserts nothing was ever written and
    sends the fix to T-17 instead of to the line.
    """
    path = root / ".specify" / "memory" / "roadmap.md"
    if not path.is_file():
        return 0, ""
    body = _section(path.read_text(encoding="utf-8"),
                    lambda h: h.lower().startswith("allocation log"))
    if not body:
        return 0, ""
    off = [ln.strip() for ln in body.splitlines()
           if ln.strip().startswith("###") and not ALLOC_HEAD_RE.match(ln.strip())]
    return len(off), (off[0] if off else "")


ALLOC_SHAPE_EXPECTED = "### Allocation <n> — <date> · trigger: <…> · BA: <name>"


def roadmap_state(d) -> str:
    """Lines 2 and 8 render the roadmap from one computation, never two.

    `log unreadable` outranks `missing`: where the log holds `###` lines and
    none of them parsed, the roadmap was written and its log cannot be read —
    a fact about this reader's grammar, not about the project (D-O58).
    """
    if d["roadmap_date"]:
        return "current %s" % d["roadmap_date"]
    if d["log_off"]:
        return "log unreadable: %d" % d["log_off"]
    return "missing"


def read_roadmap_date(root: Path) -> str:
    """The roadmap's own currency marker — its latest allocation entry (C1)."""
    path = root / ".specify" / "memory" / "roadmap.md"
    if not path.is_file():
        return ""
    entries = allocation_entries(path.read_text(encoding="utf-8"))
    if not entries:
        return ""
    dates = re.findall(DATE, entries[-1]["head"])
    return dates[0] if dates else ""


# ── the nine lines, assembled ────────────────────────────────────────────────


def assemble(root: Path, profile: str, today: str):
    """Every count the render needs, each carrying the source that produced it."""
    head = read_head(root)
    plans = plans_sections(root)
    health = read_health(root)
    briefs = read_briefs(root)
    features = read_features(root)
    order, names, phases = read_roadmap(root)
    roadmap_date = read_roadmap_date(root)
    log_off_n, log_off_first = roadmap_log_offenders(root)

    d = {"project": head["project"] or root.name, "date": today,
         "profile": profile, "band": head["band"] or "—",
         "head": head, "features": features}

    # 1 · Band 1 — Foundations
    states = [head["states"].get(a, "") for a in ASPECTS]
    d["cleared"] = sum(1 for s in states if s == "first-pass-cleared")
    d["waived"] = sum(1 for s in states if s == "waived")
    d["settled"] = d["cleared"] + d["waived"]
    d["b1_ratio"] = ratio_of(d["settled"], 6)
    d["closed"] = head["closed"]

    # 2 · Band 2 — Scoping
    d["epics"] = len(order)
    d["briefs"] = len(briefs["briefs"])
    d["kits"] = len(briefs["kits"])
    d["roadmap_date"] = roadmap_date
    d["log_off"] = log_off_n
    d["log_off_first"] = log_off_first
    d["b2_ratio"] = ratio_of(d["briefs"], d["epics"])

    # 3 · Band 3 — Delivery
    d["entered"] = len(features)
    d["breadth"] = len({f["epic"] for f in features if f["epic"]})
    d["drafted"] = sum(1 for f in features if f["drafted"])
    # r = readable entered specs — the drafted denominator (§10.4, D-O50).
    # Where every entered spec is unreadable r is 0, and `count_over` renders
    # `—`, never `0/0` and never 0% (§10.4-F).
    d["readable"] = sum(1 for f in features if f["readable"])
    d["unreadable"] = [f["parse_failure"] for f in features if not f["readable"]]
    d["gated"] = sum(1 for f in features if f["gated"])
    d["certified"] = sum(1 for f in features if f["certified"])
    d["verdicts"] = [(f["folder"], f["verdict"]) for f in features if f["gated"]]
    d["b3_ratio"] = ratio_of(
        d["drafted"] if profile == "presale" else d["certified"],
        d["readable"] if profile == "presale" else d["entered"])

    # the workflow line — §10.4-F, over the ratios that exist
    present = [r for r in (d["b1_ratio"], d["b2_ratio"], d["b3_ratio"])
               if r is not None]
    d["workflow"] = (sum(present) / len(present)) if present else None

    # 4 · Questions
    qs = briefs["questions"]
    d["q_open"] = sum(1 for q in qs if q["state"] == "open")
    d["q_answered"] = sum(1 for q in qs if q["state"] == "answered")
    d["q_overtaken"] = sum(1 for q in qs if q["state"] == "overtaken")
    d["q_oldest"] = next((q for q in qs if q["state"] == "open"), None)
    d["q_off"] = sum(1 for q in qs if q["state"] == "off-shape")
    d["q_off_first"] = next((q for q in qs if q["state"] == "off-shape"), None)

    # 5 · Health
    d["health"] = health
    d["h_expected"] = briefs["scoped"] + (1 if head["closed"] else 0)
    d["h_overdue"] = max(0, d["h_expected"] - health["full_runs"])

    # 6 · Ledger coverage — disk against the §7.3 run log
    #
    # Only the lines that name an element are counted, because only those can
    # be read against the estate: a Band-2 section also holds the T-17 and
    # T-18 lines, which are project-wide and produce no per-epic artifact. An
    # epic-scoped Tier-1 line stands against its brief or its kit one to one;
    # a feature-scoped Band-3 line stands against its entered feature.
    band2_logged = len(element_lines(plans.get("Band 2", ""), r"\bE-\d+\b"))
    band3_logged = len(element_lines(plans.get("Band 3", ""), r"\b\d{3}-"))
    d["coverage"] = []
    disk2 = d["briefs"] + d["kits"]
    if disk2 > band2_logged:
        d["coverage"].append(("Band 2", disk2, band2_logged,
                              "briefs + kits on disk vs epic-named `## Band 2` "
                              "run lines"))
    if d["entered"] > band3_logged:
        d["coverage"].append(("Band 3", d["entered"], band3_logged,
                              "features entered vs `## Band 3` run lines"))

    # 7 · Techniques
    all_rows, all_runs = [], []
    for name, body in plans.items():
        all_rows.extend(plan_rows(body))
        all_runs.extend(run_lines(body))
    d["runs"] = len(all_runs)
    d["planned"] = sum(1 for r in all_rows if not r["status"].startswith("dropped"))
    d["next_planned"] = next(
        (r["name"] for r in all_rows if r["status"].strip() == "planned"), "")

    # 8 · the profile-switched line
    d["markers"] = sum(f["markers"] for f in features if f["drafted"])
    if not d["drafted"] and d["unreadable"]:
        # Never "no spec carries a User Story yet" when the real blocker is a
        # parse miss: that reason is false and misdirects the fix from the
        # heading to the author (§10.4, D-O50).
        d["wbs"] = ("blocked: %d spec(s) unreadable — heading shapes do not "
                    "match standard §2; nothing was read from them"
                    % len(d["unreadable"]))
    elif not d["drafted"]:
        d["wbs"] = "blocked: no spec carries a User Story yet"
    elif not roadmap_date:
        d["wbs"] = "blocked: no roadmap on record"
    else:
        d["wbs"] = "ready"

    # 9 · Next
    d["next_act"] = next_act(d, head, briefs)
    return d


def next_act(d, head, briefs) -> str:
    """The one act the state points to.

    Only acts the documents already fix are named here. The DAG (§5) says
    which aspect is openable; §8.2 says when closure is due; the plans file
    says which technique is next planned. Past Band 1 the documents fix no
    ordering, so the plans file's own next-planned row speaks, and where
    nothing determines an act this renders `—` rather than inventing a ladder.
    """
    prereqs = {
        "Stakeholders": [],
        "Context": ["Stakeholders"], "Value": ["Stakeholders"],
        "Vision": ["Context", "Value"],
        "Solution": ["Vision"], "Requirements": ["Solution"],
    }
    states = head["states"]
    if head["exists"] and not head["closed"]:
        opened = [a for a in ASPECTS if states.get(a) in ("open", "reopened")]
        if opened and d["next_planned"]:
            return d["next_planned"]
        if not opened:
            if d["settled"] == 6:
                return "P-O7 — Band-1 closure · `/ba-close-band1`"
            for a in ASPECTS:
                if states.get(a) == "untouched" and all(
                        states.get(p) in SETTLED for p in prereqs[a]):
                    return "P-O1 — aspect opening · `/ba-aspect %s`" % a.lower()
        if opened:
            return "P-O2 — plan composition · `/ba-aspect %s`" % opened[0].lower()
    if d["next_planned"]:
        return d["next_planned"]
    return "—"


# ── the chat render (the primary; §10.4's pinned shape) ──────────────────────


def render(d) -> str:
    """The nine lines, in the pinned shape. The shape governs (§10.3 rule 8)."""
    presale = d["profile"] == "presale"
    out = []
    out.append("Project status — %s — %s · profile: %s · Band: %s"
               % (d["project"], d["date"], d["profile"].capitalize() or "—",
                  d["band"]))
    out.append("Workflow %s %s — §10.4-F" % (bar(d["workflow"]), pct(d["workflow"])))

    out.append("1 · Band 1 — Foundations %s %d/6 settled (%d cleared · %d waived%s) · %s"
               % (bar(d["b1_ratio"]), d["settled"], d["cleared"], d["waived"],
                  " — debt on record" if d["waived"] else "",
                  ("closed %s" % d["closed"]) if d["closed"] else "open"))

    out.append("2 · Band 2 — Scoping     %s briefs %s · kits %s · roadmap %s"
               % (bar(d["b2_ratio"]),
                  count_over(d["briefs"], d["epics"], "epics"),
                  count_over(d["kits"], d["epics"], ""),
                  roadmap_state(d)))
    if d["log_off"]:
        out.append('      allocation log unreadable: %d entr%s — first "%s", '
                   'expected %s'
                   % (d["log_off"], "y" if d["log_off"] == 1 else "ies",
                      d["log_off_first"], ALLOC_SHAPE_EXPECTED))

    verdicts = " · ".join("%s %s" % (f, v) for f, v in d["verdicts"]) or "—"
    out.append("3 · Band 3 — Delivery    %s entered %d across %s epics · "
               "drafted %s · gated %d (latest: %s) · certified %d · handed off —"
               % (bar(d["b3_ratio"]), d["entered"],
                  count_over(d["breadth"], d["epics"], ""),
                  count_over(d["drafted"], d["readable"], ""),
                  d["gated"], verdicts, d["certified"]))
    for i, failure in enumerate(d["unreadable"]):
        lead = ("unreadable %d: " % len(d["unreadable"])) if i == 0 else " " * 14
        out.append("      %s%s" % (lead, failure))
    if presale:
        out.append("      Presale note: certification & handoff out of profile — "
                   "destination: draft specs + the Q&A agenda (§6.5)")

    oldest = d["q_oldest"]
    out.append("4 · Questions: %d open · %d answered · %d overtaken · oldest: %s"
               % (d["q_open"], d["q_answered"], d["q_overtaken"],
                  ("%s — %s (standing in %s §6)"
                   % (oldest["id"], oldest["question"], oldest["epic"]))
                  if oldest else "none open"))
    if d["q_off"]:
        first = d["q_off_first"]
        out.append('      off-shape %d: first "%s" (%s) — expected OQ-<n>'
                   % (d["q_off"], first["id"], first["epic"]))

    out.append("5 · Health: Scope H %s · refresh %s · acceptances: %d"
               % (health_state(d), refresh_state(d), d["health"]["acceptances"]))

    out.append("6 · Ledger coverage: %s" % coverage_line(d))

    out.append("7 · Techniques: %d run / %d planned · next planned: %s"
               % (d["runs"], d["planned"], d["next_planned"] or "—"))

    if presale:
        out.append("8 · Presale  → Exit readiness: roadmap %s · drafted %s · "
                   "open markers %d · `/ba-wbs` %s"
                   % (roadmap_state(d),
                      count_over(d["drafted"], d["readable"], ""),
                      d["markers"], d["wbs"]))
    else:
        out.append("8 · Discovery → Handoff risk per certified feature:")
        out.extend(risk_table(d))
        out.append("       Rule: low = all zero · elevated = any one non-zero · "
                   "high = an Override, or ≥ 3 combined")

    out.append("9 · Next: %s" % d["next_act"])
    return "\n".join(out)


def count_over(num, den, unit) -> str:
    """`<n>/<d>` — or `—` where the denominator is zero (§10.4-F)."""
    if not den:
        return "—"
    return "%d/%d%s" % (num, den, (" %s" % unit) if unit else "")


def health_state(d) -> str:
    h = d["health"]
    if not h["exists"]:
        return "disarmed (pre-closure)"
    verdict = h["verdict"] or "—"
    return "armed — %s" % verdict


def refresh_state(d) -> str:
    """Recorded full runs against the cadence — display only (§10.4).

    The refresh act stays `/ba-gate-health`'s: this line reports, and names no
    act of its own.
    """
    if not d["health"]["exists"]:
        return "—"
    if d["h_overdue"] <= 0:
        return "current"
    return ("overdue: %d run%s vs cadence (%d recorded of %d — one full run per "
            "scope-brief ingestion batch, plus the arming run)"
            % (d["h_overdue"], "" if d["h_overdue"] == 1 else "s",
               d["health"]["full_runs"], d["h_expected"]))


def coverage_line(d) -> str:
    """Disk against the §7.3 run log — the instrument names its blind spots."""
    if not d["coverage"]:
        return "clean"
    parts = ["run log under-records %s: %d on disk vs %d logged (%s)"
             % (band, disk, logged, where)
             for band, disk, logged, where in d["coverage"]]
    return " · ".join(parts)


def risk_table(d):
    """Line 8's Discovery variant — the risk rule over four countable facts.

    The rule is the whole of the verdict, stated in the line below the table
    and tunable only by version bump. Nothing is averaged into a score.
    """
    rows = ["       | Feature | W | O | surviving markers | HAs in deps | Risk |",
            "       |---|---|---|---|---|---|"]
    certified = [f for f in d["features"] if f["certified"]]
    if not certified:
        rows.append("       | — no certified feature | — | — | — | — | — |")
        return rows
    for f in sorted(certified, key=lambda x: x["nnn"]):
        w = len(f["waivers"])
        o = 0                      # O-records live in the run's own ruling set
        has = d["health"]["acceptances"]
        rows.append("       | %s | %d | %d | %d | %d | %s |"
                    % (f["folder"], w, o, f["markers"], has,
                       risk_verdict(w, o, f["markers"], has)))
    return rows


def risk_verdict(w, o, markers, has) -> str:
    """low = all zero · elevated = any one non-zero · high = an Override, or ≥ 3
    combined. §10.4's own rule, unsoftened, no fifth factor, never averaged."""
    total = w + o + markers + has
    if o or total >= 3:
        return "high"
    if total:
        return "elevated"
    return "low"


# ── the HTML render (D-O29) — derived, never hand-edited ─────────────────────

CSS = (
    "font:14px/1.55 ui-monospace,SFMono-Regular,Menlo,monospace;"
    "background:#11131a;color:#dfe3ec;margin:0;padding:28px 30px"
)


def render_html(d, chat: str) -> str:
    """One self-contained file: inline styles, zero external resources.

    Presentation, never new data (§10.4): the same counts and the same formula
    the chat render prints. The chat render stays primary; this is written
    beside the ledgers and regenerated on every invocation, so a hand edit
    dies at the next run — the gate-§8 derived-file precedent.
    """
    def esc(text):
        return html.escape(text, quote=True)

    def barhtml(ratio, label):
        filled = 0 if ratio is None else max(0, min(CELLS, int(ratio * CELLS + 0.5)))
        cells = "".join(
            '<i style="display:inline-block;width:14px;height:14px;margin-right:3px;'
            'border-radius:2px;background:%s"></i>'
            % ("#4f8ef7" if i < filled else "#262a36") for i in range(CELLS))
        return ('<div style="margin:2px 0 10px"><span style="display:inline-block;'
                'min-width:210px">%s</span>%s<span style="margin-left:10px;'
                'color:#9aa4bd">%s</span></div>' % (esc(label), cells, pct(ratio)))

    rows = "".join(
        '<tr><td style="padding:3px 14px 3px 0;color:#9aa4bd;white-space:nowrap">'
        '%s</td><td style="padding:3px 0">%s</td></tr>' % (esc(k), esc(v))
        for k, v in html_facts(d))

    return (
        '<!doctype html><html lang="en"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>Project status — %s</title></head>'
        '<body style="%s">'
        '<h1 style="font:600 17px/1.4 inherit;margin:0 0 4px">%s</h1>'
        '<p style="margin:0 0 20px;color:#9aa4bd">%s · profile: %s · Band: %s</p>'
        '%s%s%s%s'
        '<table style="border-collapse:collapse;margin:18px 0 22px">%s</table>'
        '<pre style="background:#181b24;border:1px solid #262a36;border-radius:6px;'
        'padding:14px 16px;overflow-x:auto;white-space:pre;margin:0">%s</pre>'
        '<p style="margin:16px 0 0;color:#6d7690">Derived render — regenerated by '
        '<code>/ba-status --html</code> on every invocation, never hand-edited. '
        'The chat render stays primary. Formula §10.4-F.</p>'
        '</body></html>'
        % (esc(d["project"]), CSS, esc("Project status — %s" % d["project"]),
           esc(d["date"]), esc(d["profile"].capitalize() or "—"), esc(d["band"]),
           barhtml(d["workflow"], "Workflow — §10.4-F"),
           barhtml(d["b1_ratio"], "Band 1 — Foundations  %d/6 settled" % d["settled"]),
           barhtml(d["b2_ratio"], "Band 2 — Scoping  briefs %s"
                   % count_over(d["briefs"], d["epics"], "epics")),
           barhtml(d["b3_ratio"], "Band 3 — Delivery  entered %d" % d["entered"]),
           rows, esc(chat)))


def html_facts(d):
    """The same counts the chat render carries — presentation, never new data."""
    return [
        ("Aspects settled", "%d/6 (%d cleared · %d waived)"
         % (d["settled"], d["cleared"], d["waived"])),
        ("Briefs / kits", "%s · %s" % (count_over(d["briefs"], d["epics"], "epics"),
                                       count_over(d["kits"], d["epics"], ""))),
        ("Features entered", "%d across %s epics"
         % (d["entered"], count_over(d["breadth"], d["epics"], ""))),
        ("Drafted / certified", "%s · %d"
         % (count_over(d["drafted"], d["readable"], ""), d["certified"])),
        ("Questions", "%d open · %d answered · %d overtaken%s"
         % (d["q_open"], d["q_answered"], d["q_overtaken"],
            (" · %d off-shape" % d["q_off"]) if d["q_off"] else "")),
        ("Roadmap", roadmap_state(d)),
        ("Health", "%s · refresh %s" % (health_state(d), refresh_state(d))),
        ("Ledger coverage", coverage_line(d)),
        ("Techniques", "%d run / %d planned" % (d["runs"], d["planned"])),
        ("Next", d["next_act"]),
    ]


# ── CLI ──────────────────────────────────────────────────────────────────────


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="Project dashboard — orchestrator rules §10.4 (D-O26–D-O29)")
    p.add_argument("--root", default=".", help="project root")
    p.add_argument("--profile", choices=("discovery", "presale"),
                   help="override the ledger head's flow profile (§6.5)")
    p.add_argument("--date", default="", metavar="YYYY-MM-DD",
                   help="the render's date line (default: today)")
    p.add_argument("--html", action="store_true",
                   help="additionally write the derived HTML render (D-O29)")
    p.add_argument("--out", default="", metavar="PATH",
                   help="the HTML destination (default: .specify/%s)" % HTML_NAME)
    args = p.parse_args(argv)

    root = Path(args.root).resolve()
    profile = args.profile or read_profile(root) or "discovery"
    today = args.date or __import__("datetime").date.today().isoformat()

    d = assemble(root, profile, today)
    chat = render(d)
    print(chat)

    if args.html:
        out = Path(args.out) if args.out else root / ".specify" / HTML_NAME
        if not out.is_absolute():
            out = root / out
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(render_html(d, chat), encoding="utf-8")
        try:
            shown = out.relative_to(root)
        except ValueError:
            shown = out
        print("\nHTML render → %s — derived, regenerated per invocation, "
              "never hand-edited." % shown)
    return 0


if __name__ == "__main__":
    sys.exit(main())
