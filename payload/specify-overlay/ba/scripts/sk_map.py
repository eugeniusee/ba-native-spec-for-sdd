#!/usr/bin/env python3
"""sk_map — the project map (map definition v0.1, D-M1–D-M7).

BA-Native Spec · the render behind `/ba-map`.
Anchors: map definition §1 (one project, read-only — the orchestrator §10.4
discipline unchanged; sources = §10.4's two classes + the install manifest +
the gate reports' own entry bodies) · §2 (the pinned chat render, primary) ·
§3 (Spec-Kit compliance per feature over the gate's 24-assertion M set, and
the risk-if-handed-now rule — §10.4 line 8 extended, D-M2 · D-M3) · §4 (the
20-technique roster and its four states, D-M4) · §5 (the command evidence
table, D-M5) · §6 (the wellbeing verdict rule, D-M6) · §7 (the HTML render —
self-contained, no script, CSS-only disclosure, single-series charts, D-M7) ·
§8 (D-O58 applies whole) · orchestrator §10.4 (the read discipline and
§10.4-F) · §10.5 (the imported readers — one fact, one reader).

**Read-only, always.** Every source is opened for reading and never written.
The only file this script can create is the `--html` derived render,
`.specify/map.html` (map definition §7).

Every shared count is computed by sk_status's own assemble(), imported and
never restated — a second copy of a reader is a second thing to drift (the
§10.5 precedent, as sk_status itself applies it).

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import html as _html
import re
import sys
from collections import Counter
from pathlib import Path

sys.dont_write_bytecode = True

sys.path.insert(0, str(Path(__file__).resolve().parent))

import sk_status as st  # noqa: E402

# The M set's own size — build plan §2.4; check-m exercises all 24 (D-M2).
M_TOTAL = 24
# "A lot of questions" — the D-M6 threshold. Pinned here and in the map
# definition §6; tunable by version bump, never silently.
HEAVY_AT = 10

HTML_NAME = "map.html"

VERDICTS = ("question-heavy", "questions standing", "in motion", "dev-ready")

# The roster — 18 catalogue techniques (catalogue index, T-01…T-18) + 2 spine
# (elicitation §3.1 · §5.1). Compiled at build time under the layering rule
# (map definition §4, D-M4): operative text + IDs only, no runtime doc read.
TECHNIQUES = [
    ("T-01", "discovery canvas framing", "Band 1"),
    ("T-02", "glossary discipline", "Band 1"),
    ("T-03", "stakeholder register", "Band 1"),
    ("T-04", "persona charters", "Band 1"),
    ("T-05", "context & landscape mapping", "Band 1"),
    ("T-06", "constraints elicitation", "Band 1"),
    ("T-07", "competitive analysis", "Band 1"),
    ("T-08", "value definition", "Band 1"),
    ("T-09", "vision & differentiation", "Band 1"),
    ("T-10", "solution surface review", "Band 1"),
    ("T-11", "domain (conceptual) modeling", "Band 1"),
    ("T-12", "roles & permissions", "Band 1"),
    ("T-13", "core process mapping", "Band 1"),
    ("T-14", "design & UX standards", "Band 1"),
    ("T-15", "constitution", "Band 1"),
    ("T-16", "global out-of-scope", "Band 1"),
    ("T-17", "epics decomposition", "Band 2"),
    ("T-18", "scope allocation (repeatable)", "Band 2"),
    ("Tier 1", "epic scoping interview", "Spine"),
    ("Tier 2", "spec-depth gap-filling", "Spine"),
]
CODE_RE = re.compile(r"\b[Tt]-?(\d{2})\b")
TIER_RE = re.compile(r"\btier\s*-?\s*([12])\b", re.I)
DATE_RE = re.compile(r"\d{4}-\d{2}-\d{2}")


# ── the reads (§1) ───────────────────────────────────────────────────────────


def manifest_facts(root: Path):
    """The install manifest — the package edition and install date (§8).

    The map and the manifest install together, so the edition names the
    instrument as well as the estate. Absence renders `—`, never a guess.
    """
    mf = root / ".specify" / "ba" / "manifest.md"
    out = {"version": "", "installed": ""}
    if mf.is_file():
        text = mf.read_text(encoding="utf-8")
        for key, field in (("version", "Package version"),
                           ("installed", "Installed")):
            m = re.search(r"\|\s*%s\s*\|\s*([^|]+?)\s*\|" % field, text)
            if m:
                out[key] = m.group(1).strip()
    return out


def read_project(root: Path, today: str):
    """assemble() plus the map's own layers — handoff, coverage, activity."""
    profile = st.read_profile(root) or "discovery"
    d = st.assemble(root, profile, today)
    d["root"] = root
    d.update(manifest_facts(root))
    d["qm"] = d["q_open"] + d["markers"]
    d["near"] = len(d["unreadable"]) + d["q_off"] + d["log_off"]
    d["fails"] = sum(1 for _, v in d["verdicts"] if v.startswith("FAIL"))
    d["overdue"] = d["h_overdue"] if d["health"]["exists"] else 0
    d["under"] = len(d["coverage"])
    d["verdict_map"] = verdict(d)
    d["handoff"] = [feature_handoff(f) for f in d["features"]]
    d["techniques"], d["custom_runs"] = technique_coverage(root)
    d["commands"] = command_coverage(root, d)
    d["activity"] = activity(root)
    return d


# ── the wellbeing verdict (§6, D-M6) ─────────────────────────────────────────


def verdict(d) -> str:
    """First match wins. The rule is the whole of the verdict (§6)."""
    if d["qm"] >= HEAVY_AT or d["fails"] or d["near"] or d["overdue"] >= 2:
        return "question-heavy"
    if d["qm"] or d["overdue"] == 1 or d["under"]:
        return "questions standing"
    if d["profile"] == "presale":
        if d["wbs"] == "ready":
            return "dev-ready"
    elif d["entered"] and d["certified"] == d["entered"]:
        return "dev-ready"
    return "in motion"


# ── dev handoff (§3, D-M2 · D-M3) ────────────────────────────────────────────


def feature_handoff(f):
    """Compliance and risk, from the feature's latest gate-report entry.

    The reader quotes the report — the standing gap count as the verdict
    states it, the waivers in force — and never re-runs an assertion (§3).
    `—` where no run exists: unmeasured is not zero (§10.4-F).
    """
    out = {"feature": f["folder"], "markers": f["markers"],
           "certified": f["certified"], "verdict": f["verdict"],
           "run_date": f["run_date"], "waivers": len(f["waivers"]),
           "gaps": 0, "compliance": None, "risk": "", "handoff": ""}
    m = re.match(r"FAIL\((\d+)\)", f["verdict"])
    if m:
        out["gaps"] = int(m.group(1))
    if f["certified"]:
        out["compliance"] = (M_TOTAL - out["waivers"]) / M_TOTAL
        out["risk"] = st.risk_verdict(out["waivers"], 0, f["markers"], 0)
        out["handoff"] = "yes — effective PASS %s" % f["run_date"]
    elif m:
        out["compliance"] = (M_TOTAL - out["gaps"] - out["waivers"]) / M_TOTAL
        out["risk"] = "high"
        out["handoff"] = "no — gate FAIL standing (%d open)" % out["gaps"]
    elif f["verdict"] == "no gate run":
        out["risk"] = "unassessed"
        out["handoff"] = "no — ungated (the gate is the only exit)"
    else:
        out["risk"] = "unassessed"
        out["handoff"] = "no — latest entry carries no verdict"
    return out


# ── technique coverage (§4, D-M4) ────────────────────────────────────────────


def norm_codes(text: str):
    codes = {"T-%s" % m.group(1) for m in CODE_RE.finditer(text)}
    codes |= {"Tier %s" % m.group(1) for m in TIER_RE.finditer(text)}
    return codes


def technique_coverage(root: Path):
    """The 20 against the plans file — run · dropped · planned · no record.

    A custom technique (the Q2+ path) never matches a code and is counted
    beside the roster, never folded into it (§4).
    """
    plans = st.plans_sections(root)
    rows, runs = [], []
    for body in plans.values():
        rows.extend(st.plan_rows(body))
        runs.extend(st.run_lines(body))
    run_dates = {}
    for r in runs:
        for c in norm_codes(r["what"]):
            run_dates.setdefault(c, r["date"])
    planned, dropped = {}, {}
    for row in rows:
        codes = norm_codes(row["name"])
        if not codes:
            continue
        for c in codes:
            if row["status"].startswith("dropped"):
                dropped.setdefault(c, row["status"])
            elif row["status"].startswith("run"):
                m = DATE_RE.search(row["status"])
                run_dates.setdefault(c, m.group(0) if m else "")
            else:
                planned.setdefault(c, row["status"])
    out = []
    for code, name, group in TECHNIQUES:
        if code in run_dates:
            state, note = "run", run_dates[code]
        elif code in dropped:
            state, note = "dropped", (dropped[code].partition("—")[2].strip()
                                      or dropped[code])
        elif code in planned:
            state, note = "planned", planned[code]
        else:
            state, note = "none", "no record in the plans file"
        out.append({"code": code, "name": name, "group": group,
                    "state": state, "note": note})
    custom_runs = [r for r in runs if not norm_codes(r["what"])]
    return out, custom_runs


# ── command coverage (§5, D-M5) ──────────────────────────────────────────────


def command_coverage(root: Path, d):
    """Twelve standing surfaces, each with its named evidence read (§5).

    Render-only commands leave no record by law, so `no record` is never
    rendered as `never ran` — the render states the caveat once.
    """
    head_path = root / ".specify" / "aspect-state.md"
    head_text = head_path.read_text(encoding="utf-8") if head_path.is_file() else ""
    gate_entries = 0
    specs = root / "specs"
    if specs.is_dir():
        for rp in sorted(specs.glob("*/gate-report.md")):
            gate_entries += len(re.findall(r"^##\s*Gate run\s+\d+",
                                           rp.read_text(encoding="utf-8"), re.M))
    frame_m = re.search(r"^(\d{4}-\d{2}-\d{2})\s*·\s*Band 1 entered",
                        head_text, re.M)
    reopens = len(re.findall(r"\bRO-\d+\b", head_text))
    auto_line = re.search(r"^Auto:\s*(.+)$", head_text, re.M)
    hum_line = re.search(r"^Humanizer:\s*(.+)$", head_text, re.M)
    switch = re.search(r"·\s*profile\s*·\s*Presale\s*→\s*Discovery", head_text)

    def ev(cond, yes, no="no record"):
        return ("run", yes) if cond else ("none", no)

    cmds = [
        ("/ba-frame",) + ev(bool(head_text),
                            frame_m.group(1) if frame_m else "ledger present"),
        ("/ba-close-band1",) + ev(bool(d["closed"]), d["closed"] or ""),
        ("/ba-enter-feature",) + ev(d["entered"] > 0,
                                    "%d feature(s) entered" % d["entered"]),
        ("/ba-gate",) + ev(gate_entries > 0,
                           "%d run(s) on record" % gate_entries),
        ("/ba-gate-health",) + ev(d["health"]["full_runs"] > 0,
                                  "%d full run(s) · %s"
                                  % (d["health"]["full_runs"],
                                     d["health"]["verdict"] or "—")),
        ("/ba-reopen",) + ev(reopens > 0,
                             "RO record(s) on the ledger: %d ref(s)" % reopens),
        ("/ba-waive-aspect",) + ev(d["waived"] > 0, "%d waived" % d["waived"],
                                   "none — no AW standing"),
        ("/ba-wbs",) + ev((root / "exports").is_dir(), "exports/ present",
                          "no exports/ on disk · line 8: %s" % d["wbs"]),
        ("/ba-audit",) + ev((root / ".specify" / "source-audit.md").is_file(),
                            "source-audit.md present"),
        ("/ba-dev-ready",) + ev(bool(switch), "profile switch on the ledger"),
        ("/ba-auto",) + ev(bool(auto_line),
                           auto_line.group(1).strip() if auto_line else "",
                           "no AG on the ledger"),
        ("/ba-humanizer",) + (("run", hum_line.group(1).strip()) if hum_line
                              else ("none", "off — head line absent")),
    ]
    return [{"cmd": c, "state": s, "note": t} for c, s, t in cmds]


def activity(root: Path):
    """Every dated run on the record — plans run log + gate runs + health runs."""
    dates = []
    for body in st.plans_sections(root).values():
        dates.extend(r["date"] for r in st.run_lines(body))
    specs = root / "specs"
    if specs.is_dir():
        for rp in sorted(specs.glob("*/gate-report.md")):
            dates.extend(m.group(1) for m in re.finditer(
                r"^##\s*Gate run\s+\d+\s*[—–-]\s*(\d{4}-\d{2}-\d{2})",
                rp.read_text(encoding="utf-8"), re.M))
    gh = root / ".specify" / "gate-health.md"
    if gh.is_file():
        dates.extend(m.group(1) for m in re.finditer(
            r"^##\s*Health run\s+\d+\s*[—–-]\s*(\d{4}-\d{2}-\d{2})",
            gh.read_text(encoding="utf-8"), re.M))
    return sorted(Counter(dates).items())


def named_misses(d):
    """D-O58's set, plus nothing — named, never rendered as absence (§8)."""
    out = []
    for f in d["unreadable"]:
        out.append(("unreadable spec", f))
    if d["q_off"]:
        q = d["q_off_first"]
        out.append(("off-shape question row",
                    '%d row(s) — first "%s" (%s §6), expected OQ-<n>'
                    % (d["q_off"], q["id"], q["epic"])))
    if d["log_off"]:
        out.append(("allocation log",
                    '%d entr(y|ies) unparsed — first "%s", expected `%s`'
                    % (d["log_off"], d["log_off_first"],
                       st.ALLOC_SHAPE_EXPECTED)))
    for band, disk, logged, where in d["coverage"]:
        out.append(("run log under-records",
                    "%s: %d on disk vs %d logged (%s)"
                    % (band, disk, logged, where)))
    return out


# ── the chat render — primary (§2) ───────────────────────────────────────────


def chat_render(d, today: str) -> str:
    """The pinned shape. The shape governs (§10.3 rule 8)."""
    out = ["Project map — %s — %s · profile: %s · Band: %s · verdict: %s"
           % (d["project"], today, d["profile"].capitalize(), d["band"],
              d["verdict_map"])]
    out.append("Workflow %s %s — §10.4-F · dev-ready (B3) %s %s"
               % (st.bar(d["workflow"]), st.pct(d["workflow"]),
                  st.bar(d["b3_ratio"]), st.pct(d["b3_ratio"])))
    out.append("Dev handoff — Spec-Kit compliance per feature (the gate's "
               "%d-assertion M set):" % M_TOTAL)
    for h in d["handoff"]:
        out.append("  %s · %s · gaps %d · W %d · ⚑ %d · risk: %s · handoff: %s"
                   % (h["feature"], st.pct(h["compliance"]), h["gaps"],
                      h["waivers"], h["markers"], h["risk"], h["handoff"]))
    counts = Counter(t["state"] for t in d["techniques"])
    out.append("Techniques: %d/20 run · %d dropped (reason on record) · %d "
               "planned · %d no record · custom runs %d"
               % (counts.get("run", 0), counts.get("dropped", 0),
                  counts.get("planned", 0), counts.get("none", 0),
                  len(d["custom_runs"])))
    unrun = [t["code"] for t in d["techniques"] if t["state"] == "none"]
    if unrun:
        out.append("  no record: %s" % " · ".join(unrun))
    c_run = [c for c in d["commands"] if c["state"] == "run"]
    c_none = [c for c in d["commands"] if c["state"] == "none"]
    out.append("Commands: %d evidenced (%s) · %d without record (%s)"
               % (len(c_run), " · ".join(c["cmd"] for c in c_run),
                  len(c_none), " · ".join(c["cmd"] for c in c_none)))
    out.append("Questions: %d open · %d answered · markers %d"
               % (d["q_open"], d["q_answered"], d["markers"]))
    misses = named_misses(d)
    if misses:
        out.append("Named (D-O58): " + " · ".join("%s: %s" % (k, v)
                                                  for k, v in misses))
    return "\n".join(out)


# ── the HTML render (§7, D-M7) — derived, no script, single-series charts ────

C = {"bg": "#11131a", "panel": "#181b24", "line": "#262a36", "tip": "#20242f",
     "ink": "#dfe3ec", "mut": "#9aa4bd", "dim": "#6d7690", "acc": "#4f8ef7",
     "ready": "#3fb47f", "motion": "#4f8ef7", "standing": "#d9a13f",
     "heavy": "#e2604f"}
VCOLOR = {"dev-ready": C["ready"], "in motion": C["motion"],
          "questions standing": C["standing"], "question-heavy": C["heavy"]}
SCOL = {"run": C["ready"], "planned": C["acc"], "dropped": C["standing"],
        "none": C["dim"]}
MONO = "ui-monospace,SFMono-Regular,Menlo,Consolas,monospace"

CSS = """
body{background:%(bg)s;margin:0}
.wrap{min-height:100vh;background:%(bg)s;color:%(ink)s;font:13px/1.5 %(mono)s;
  padding:30px 34px;box-sizing:border-box}
.page{max-width:960px;margin:0 auto}
.panel{background:%(panel)s;border:1px solid %(line)s;border-radius:8px;
  padding:14px 18px}
h2{font-size:10.5px;font-weight:600;letter-spacing:1.2px;text-transform:uppercase;
  color:%(dim)s;margin:26px 0 8px;display:flex;align-items:center;gap:7px}
.tt{position:relative}
.tt>.tip{position:absolute;bottom:calc(100%% + 7px);left:0;background:%(tip)s;
  border:1px solid #2c3140;border-radius:6px;padding:7px 10px;font-size:11px;
  line-height:1.5;color:%(ink)s;opacity:0;pointer-events:none;z-index:9;
  min-width:210px;max-width:330px;box-shadow:0 6px 18px rgba(0,0,0,.45);
  transition:opacity .12s;text-transform:none;letter-spacing:0;font-weight:400;
  white-space:normal}
.tt:hover>.tip,.tt:focus>.tip,.tt:focus-within>.tip{opacity:1}
.tt:focus{outline:1px solid %(acc)s;outline-offset:2px}
.tip b{color:%(ink)s}.tip i{color:%(mut)s;font-style:normal}
.info{display:inline-flex;align-items:center;justify-content:center;width:15px;
  height:15px;border:1px solid %(dim)s;border-radius:50%%;color:%(dim)s;
  font-size:9.5px;cursor:default;flex:none}
.chip{display:inline-block;padding:2px 9px;border:1px solid;border-radius:999px;
  font-size:10.5px;letter-spacing:.4px;text-transform:uppercase;white-space:nowrap}
.dot{display:inline-block;width:8px;height:8px;border-radius:50%%;flex:none}
.tile{display:inline-flex;align-items:center;gap:6px;padding:3px 9px;
  border:1px solid %(line)s;border-radius:6px;font-size:11.5px;cursor:default}
.num{font-variant-numeric:tabular-nums}
details{margin-top:26px}
summary{font-size:10.5px;font-weight:600;letter-spacing:1.2px;color:%(dim)s;
  text-transform:uppercase;cursor:pointer;user-select:none}
summary:hover{color:%(mut)s}
pre{background:%(panel)s;border:1px solid %(line)s;border-radius:8px;
  padding:13px 16px;overflow-x:auto;font-size:11px;color:%(mut)s;margin:10px 0 0}
@media (prefers-reduced-motion:reduce){.tt>.tip{transition:none}}
""" % {"bg": C["bg"], "panel": C["panel"], "line": C["line"], "tip": C["tip"],
       "ink": C["ink"], "mut": C["mut"], "dim": C["dim"], "acc": C["acc"],
       "mono": MONO}


def esc(t):
    return _html.escape(str(t), quote=True)


def tip(html_inner, tip_html, extra_style=""):
    """CSS-only disclosure on hover/focus — never a script (§7)."""
    return ('<span class="tt" tabindex="0" style="%s">%s'
            '<span class="tip">%s</span></span>'
            % (extra_style, html_inner, tip_html))


def info(tip_html):
    return tip('<span class="info">i</span>', tip_html)


def chip(text, col):
    return '<span class="chip" style="border-color:%s;color:%s">%s</span>' % (
        col, col, esc(text))


def donut(ratio, label, sublabel, color):
    """One SVG donut gauge — one series, part of one whole (§7)."""
    r, cx = 26, 33
    circ = 2 * 3.14159 * r
    val = 0 if ratio is None else max(0.0, min(1.0, ratio))
    return (
        '<div style="text-align:center">'
        '<svg width="66" height="66" viewBox="0 0 66 66" role="img" '
        'aria-label="%s %s">'
        '<circle cx="%d" cy="%d" r="%d" fill="none" stroke="%s" stroke-width="7"/>'
        '<circle cx="%d" cy="%d" r="%d" fill="none" stroke="%s" stroke-width="7" '
        'stroke-linecap="round" stroke-dasharray="%.1f %.1f" '
        'transform="rotate(-90 %d %d)"/>'
        '<text x="%d" y="37" text-anchor="middle" fill="%s" '
        'style="font:600 13px %s">%s</text></svg>'
        '<div style="font-size:10px;color:%s;margin-top:2px">%s</div>'
        '<div style="font-size:10px;color:%s">%s</div></div>'
        % (esc(label), st.pct(ratio), cx, cx, r, C["line"],
           cx, cx, r, color, val * circ, circ, cx, cx,
           cx, C["ink"], MONO, st.pct(ratio), C["mut"], esc(label),
           C["dim"], esc(sublabel)))


def hbar(ratio, color, width=170):
    """One thin horizontal bar on a track — one measure, one hue (§7)."""
    pctw = 0 if ratio is None else int(round(ratio * 100))
    return ('<span style="display:inline-block;width:%dpx;height:8px;'
            'background:%s;border-radius:4px;overflow:hidden;'
            'vertical-align:middle">'
            '<span style="display:block;width:%d%%;height:100%%;background:%s;'
            'border-radius:4px"></span></span>'
            % (width, C["line"], pctw,
               color if ratio is not None else C["line"]))


def overview_block(d):
    v = d["verdict_map"]
    dev_sub = ("certified %d/%d" % (d["certified"], d["entered"])
               if d["profile"] != "presale"
               else "drafted %s" % st.count_over(d["drafted"], d["readable"], ""))
    bands = ""
    for label, ratio, tip_html in (
        ("B1", d["b1_ratio"],
         "<b>Band 1 — Foundations</b><br>%d/6 settled (%d cleared · %d waived)%s"
         % (d["settled"], d["cleared"], d["waived"],
            "<br>closed %s" % d["closed"] if d["closed"] else "<br>open")),
        ("B2", d["b2_ratio"],
         "<b>Band 2 — Scoping</b><br>briefs %s · kits %s<br>roadmap %s"
         % (st.count_over(d["briefs"], d["epics"], "epics"),
            st.count_over(d["kits"], d["epics"], ""), st.roadmap_state(d))),
        ("B3", d["b3_ratio"],
         "<b>Band 3 — Delivery</b><br>entered %d · drafted %s · gated %d · "
         "certified %d" % (d["entered"],
                           st.count_over(d["drafted"], d["readable"], ""),
                           d["gated"], d["certified"]))):
        bands += tip(
            '<span style="display:flex;align-items:center;gap:8px;margin:4px 0">'
            '<span style="color:%s;font-size:11px;width:20px">%s</span>%s'
            '<span class="num" style="color:%s;font-size:11px">%s</span></span>'
            % (C["dim"], label, hbar(ratio, C["acc"]), C["dim"], st.pct(ratio)),
            tip_html, "display:block")

    acol = {"first-pass-cleared": C["ready"], "waived": C["standing"],
            "open": C["acc"], "reopened": C["heavy"], "untouched": C["line"]}
    aspects = "".join(
        tip('<span style="display:inline-block;width:26px;height:8px;'
            'border-radius:2px;background:%s"></span>'
            % acol.get(d["head"]["states"].get(a, "untouched"), C["line"]),
            "<b>%s</b><br>%s" % (esc(a),
                                 esc(d["head"]["states"].get(a, "untouched"))))
        for a in st.ASPECTS)

    facts = []
    if d["q_open"]:
        o = d["q_oldest"]
        facts.append(tip(
            '<span class="tile"><span class="dot" style="background:%s"></span>'
            '%d open q</span>' % (C["standing"], d["q_open"]),
            "<b>Questions</b><br>%d open · %d answered · %d overtaken<br>"
            "<i>oldest: %s — %s (%s §6)</i>"
            % (d["q_open"], d["q_answered"], d["q_overtaken"],
               esc(o["id"]), esc(o["question"]), esc(o["epic"])) if o else ""))
    if d["markers"]:
        facts.append(tip(
            '<span class="tile"><span class="dot" style="background:%s"></span>'
            '%d ⚑</span>' % (C["standing"], d["markers"]),
            "<b>Surviving markers</b><br>%d [NEEDS CLARIFICATION] across "
            "drafted specs" % d["markers"]))
    h_ok = d["health"]["exists"] and not d["overdue"]
    facts.append(tip(
        '<span class="tile"><span class="dot" style="background:%s"></span>'
        'health</span>' % (C["ready"] if h_ok else
                           C["dim"] if not d["health"]["exists"]
                           else C["standing"]),
        "<b>Scope H</b><br>%s<br>refresh %s · acceptances %d"
        % (esc(st.health_state(d)), esc(st.refresh_state(d)),
           d["health"]["acceptances"])))
    facts.append(tip(
        '<span class="tile"><span class="dot" style="background:%s"></span>'
        'ledger</span>' % (C["ready"] if not d["under"] else C["standing"]),
        "<b>Ledger coverage</b><br>%s" % esc(st.coverage_line(d))))

    return (
        '<div class="panel" style="display:flex;gap:26px;align-items:center;'
        'flex-wrap:wrap;margin-top:14px">'
        '<div style="display:flex;gap:18px">%s%s</div>'
        '<div style="flex:1;min-width:230px">%s</div>'
        '<div style="min-width:190px">'
        '<div style="display:flex;gap:5px;margin-bottom:9px">%s</div>'
        '<div style="display:flex;gap:6px;flex-wrap:wrap">%s</div></div></div>'
        % (donut(d["workflow"], "Workflow", "§10.4-F", VCOLOR[v]),
           donut(d["b3_ratio"], "Dev-ready", dev_sub,
                 C["ready"] if d["b3_ratio"] else C["line"]),
           bands, aspects, "".join(facts)))


def handoff_block(d):
    ready = [h for h in d["handoff"] if h["certified"]]
    n, m = len(ready), len(d["handoff"])
    if d["profile"] == "presale":
        answer, a_col = ("Presale — certification out of profile; destination: "
                         "draft specs + WBS (§6.5)."), C["mut"]
    elif m == 0:
        answer, a_col = "No feature entered yet.", C["mut"]
    elif n == m:
        answer, a_col = ("YES — all %d feature(s) carry an effective PASS."
                         % m), C["ready"]
    else:
        nay = [h["feature"].split("-")[0] for h in d["handoff"]
               if not h["certified"]]
        answer = ("NOT YET — %d of %d certified · blocked: %s"
                  % (n, m, ", ".join(nay)))
        a_col = C["standing"] if n else C["heavy"]

    rows = []
    for h in d["handoff"]:
        col = (C["ready"] if h["certified"] else
               C["heavy"] if h["gaps"] else C["dim"])
        rcol = {"low": C["ready"], "elevated": C["standing"],
                "high": C["heavy"]}.get(h["risk"], C["dim"])
        met = (("%d/%d assertions met" % (round(h["compliance"] * M_TOTAL),
                                          M_TOTAL))
               if h["compliance"] is not None else "not yet measured")
        tip_html = ("<b>%s</b><br>%s<br>gaps %d · waivers %d · ⚑ %d%s"
                    % (esc(h["feature"]), met, h["gaps"], h["waivers"],
                       h["markers"],
                       "<br><i>run %s</i>" % esc(h["run_date"])
                       if h["run_date"] else ""))
        rows.append(
            '<div style="display:flex;align-items:center;gap:12px;'
            'flex-wrap:wrap;margin:7px 0">'
            '<span style="min-width:225px;font-size:12px;color:%s">%s</span>'
            '%s'
            '<span class="num" style="width:38px;font-size:12px;color:%s">%s'
            '</span>%s%s'
            '<span style="font-size:11px;color:%s">%s</span></div>'
            % (C["ink"], esc(h["feature"]),
               tip(hbar(h["compliance"], col, 150), tip_html),
               C["mut"], st.pct(h["compliance"]),
               chip("⚑ %d" % h["markers"],
                    C["standing"] if h["markers"] else C["dim"]),
               chip(h["risk"], rcol),
               C["dim"], esc(h["handoff"])))

    formula = ("<b>Spec-Kit compliance</b> = assertions met / %d (the gate's M "
               "set, latest run)<br>certified (24−W)/24 · FAIL (24−gaps−W)/24 "
               "· ungated — (never 0%%)<br><br><b>Risk</b> — the §10.4 line-8 "
               "rule: low = all zero · elevated = any one non-zero · high = an "
               "Override, or ≥ 3 combined (W · O · ⚑ · HAs); FAIL → high · "
               "ungated → unassessed.<br><br>Project dev-ready %% = Band 3's "
               "own §10.4-F ratio. No new composite." % M_TOTAL)
    return ('<h2>Dev handoff — ready to pass the specs to engineering? %s</h2>'
            '<div class="panel"><p style="font-size:12.5px;color:%s;'
            'margin:0 0 4px">%s</p>%s</div>'
            % (info(formula), a_col, esc(answer), "".join(rows)))


def technique_block(d):
    counts = Counter(t["state"] for t in d["techniques"])
    run_n = counts.get("run", 0)
    strip = tip(hbar(run_n / len(TECHNIQUES), C["ready"], 220) +
                '<span class="num" style="font-size:12px;color:%s;'
                'margin-left:10px">%d/20 run</span>' % (C["ink"], run_n),
                "<b>Ground walked</b><br>%d run · %d dropped (reason on "
                "record) · %d planned · %d no record"
                % (run_n, counts.get("dropped", 0), counts.get("planned", 0),
                   counts.get("none", 0)))
    tiles = "".join(
        tip('<span class="tile" style="border-color:%s;color:%s">%s</span>'
            % (SCOL[t["state"]],
               C["ink"] if t["state"] == "run" else C["mut"], esc(t["code"])),
            "<b>%s — %s</b><br>%s%s"
            % (esc(t["code"]), esc(t["name"]), esc(t["state"]),
               " · <i>%s</i>" % esc(t["note"]) if t["note"] else ""))
        for t in d["techniques"])
    if d["custom_runs"]:
        tiles += tip(
            '<span class="tile" style="border-style:dashed;color:%s">'
            '+%d custom</span>' % (C["mut"], len(d["custom_runs"])),
            "<b>Custom techniques (the Q2+ path)</b><br>%s"
            % "<br>".join("%s · <i>%s</i>" % (esc(r["what"]), esc(r["date"]))
                          for r in d["custom_runs"][:6]))
    legend = "".join(
        '<span style="display:inline-flex;align-items:center;gap:5px;'
        'font-size:10.5px;color:%s"><span class="dot" style="background:%s">'
        '</span>%s</span>' % (C["dim"], SCOL[s], lbl)
        for s, lbl in (("run", "run"), ("planned", "planned"),
                       ("dropped", "dropped"), ("none", "no record")))
    note = ("<b>The roster</b> — 20 framework techniques: 18 catalogue "
            "(T-01…T-18) + 2 spine (Tier 1 · Tier 2), read against the plans "
            "file's composed plans and run logs.<br><br>An unapplied "
            "technique is not a defect — election is the BA's. This shows "
            "the ground actually walked.")
    return ('<h2>Techniques — 20 applicable %s</h2>'
            '<div class="panel"><div style="margin:0 0 10px">%s</div>'
            '<div style="display:flex;gap:6px;flex-wrap:wrap">%s</div>'
            '<div style="display:flex;gap:14px;margin-top:10px">%s</div></div>'
            % (info(note), strip, tiles, legend))


def command_block(d):
    pills = "".join(
        tip('<span class="tile" style="border-color:%s;color:%s">'
            '<span class="dot" style="background:%s"></span>%s</span>'
            % (C["line"], C["ink"] if c["state"] == "run" else C["dim"],
               SCOL["run" if c["state"] == "run" else "none"], esc(c["cmd"])),
            "<b>%s</b><br>%s" % (esc(c["cmd"]), esc(c["note"])))
        for c in d["commands"])
    note = ("<b>Evidence-based</b> — each command read from the estate "
            "(ledgers, reports, exports), never from memory. Render-only "
            "commands (/ba-status, this map) leave no record by law — a "
            "command without record may still have run.")
    return ('<h2>Commands — the standing surfaces %s</h2>'
            '<div class="panel" style="display:flex;gap:6px;flex-wrap:wrap">'
            '%s</div>' % (info(note), pills))


def activity_block(d):
    if not d["activity"]:
        return ""
    peak = max(n for _, n in d["activity"])
    cols = "".join(
        tip('<span style="display:inline-flex;flex-direction:column;'
            'justify-content:flex-end;width:16px;height:44px">'
            '<span style="display:block;height:%dpx;background:%s;'
            'border-radius:3px 3px 0 0"></span></span>'
            % (max(3, round(n / peak * 40)), C["acc"]),
            "<b>%s</b><br>%d run(s)" % (esc(day), n))
        for day, n in d["activity"])
    first, last = d["activity"][0][0], d["activity"][-1][0]
    total = sum(n for _, n in d["activity"])
    note = ("<b>Activity</b> — every dated run on the record: plans-file run "
            "log + gate runs + health runs. One column per active day.")
    return ('<h2>Activity — %d runs · %s → %s %s</h2>'
            '<div class="panel"><div style="display:flex;align-items:flex-end;'
            'gap:3px;border-bottom:1px solid %s;padding-bottom:1px;'
            'width:fit-content">%s</div></div>'
            % (total, esc(first), esc(last), info(note), C["line"], cols))


def misses_block(d):
    misses = named_misses(d)
    if not misses:
        return ('<h2>Named by the instrument (D-O58)</h2>'
                '<p style="color:%s;font-size:12px;margin:0">nothing — every '
                'shape read clean</p>' % C["dim"])
    items = "".join(
        '<div style="display:flex;gap:12px;margin:4px 0;font-size:11.5px">'
        '<span style="color:%s;min-width:170px;flex:none">%s</span>'
        '<span style="color:%s">%s</span></div>'
        % (C["standing"], esc(k), C["mut"], esc(v)) for k, v in misses)
    note = ("<b>D-O58</b> — a reader that meets a near-miss names it: the "
            "path, the line as authored, the shape expected. Nothing renders "
            "as absence, and the reader never repairs what it names.")
    return ('<h2>Named by the instrument %s</h2><div class="panel">%s</div>'
            % (info(note), items))


RULE_TEXT = """Spec-Kit compliance (feature)   met / 24 — the gate's own M set, latest run: certified (24−W)/24 · FAIL (24−gaps−W)/24 · ungated `—`
Risk if handed now (feature)    certified: low = all zero · elevated = any one non-zero · high = an Override, or ≥ 3 combined (W · O · ⚑ · HAs — §10.4 line 8)
                                FAIL(n): high — n assertions open · ungated: unassessed — the boundary lifts per feature by the effective PASS alone
Dev-ready % (project)           Band 3's §10.4-F ratio — certified/entered (Discovery) · drafted/readable (Presale). No new composite exists.
Wellbeing verdict (project)     question-heavy: q+⚑ ≥ 10, or a FAIL standing, or a named near-miss, or health overdue ≥ 2
                                questions standing: q+⚑ ≥ 1, or overdue 1, or the run log under-records · dev-ready: destination reached at zero debt · in motion: else
Every threshold is the map definition's text — tunable by version bump, never silently."""


def html_render(d, chat, today):
    v = d["verdict_map"]
    return (
        '<!doctype html><html lang="en"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>Project map — %s</title><style>%s</style></head><body>'
        '<div class="wrap"><div class="page">'
        '<p style="font-size:10px;letter-spacing:1.6px;text-transform:'
        'uppercase;color:%s;margin:0 0 6px">BA-Native Spec · project map</p>'
        '<div style="display:flex;align-items:baseline;gap:14px;'
        'flex-wrap:wrap">'
        '<h1 style="font-size:19px;font-weight:600;margin:0">%s</h1>%s'
        '<span style="font-size:11px;color:%s;margin-left:auto">%s · %s · '
        'Band %s · %s</span></div>'
        '%s%s%s%s%s%s'
        '<details><summary>The rules, printed</summary><pre>%s</pre></details>'
        '<details><summary>The chat render — primary; this page derives from '
        'it</summary><pre>%s</pre></details>'
        '<p style="margin:22px 0 0;color:%s;font-size:10.5px">Derived render '
        '(map definition §7, the D-O29 pattern) — self-contained, no script, '
        'regenerated by <code>/ba-map --html</code> on every invocation, '
        'never hand-edited. Read-only: no ledger was written. The chat '
        'render stays primary.</p>'
        '</div></div></body></html>'
        % (esc(d["project"]), CSS, C["dim"], esc(d["project"]),
           chip(v, VCOLOR[v]), C["dim"], esc(today),
           esc(d["profile"].capitalize()), esc(d["band"].split(" ")[0]),
           esc(d["version"] or "—"),
           overview_block(d), handoff_block(d), technique_block(d),
           command_block(d), activity_block(d), misses_block(d),
           esc(RULE_TEXT), esc(chat), C["dim"]))


# ── CLI ──────────────────────────────────────────────────────────────────────


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="Project map — map definition v0.1 (D-M1–D-M7)")
    p.add_argument("--root", default=".", help="project root")
    p.add_argument("--date", default="", metavar="YYYY-MM-DD",
                   help="the render's date line (default: today)")
    p.add_argument("--html", action="store_true",
                   help="additionally write the derived HTML render (§7)")
    p.add_argument("--out", default="", metavar="PATH",
                   help="the HTML destination (default: .specify/%s)"
                        % HTML_NAME)
    args = p.parse_args(argv)

    root = Path(args.root).resolve()
    today = args.date or __import__("datetime").date.today().isoformat()

    d = read_project(root, today)
    chat = chat_render(d, today)
    print(chat)

    if args.html:
        out = Path(args.out) if args.out else root / ".specify" / HTML_NAME
        if not out.is_absolute():
            out = root / out
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(html_render(d, chat, today), encoding="utf-8")
        try:
            shown = out.relative_to(root)
        except ValueError:
            shown = out
        print("\nHTML render → %s — derived, regenerated per invocation, "
              "never hand-edited." % shown)
    return 0


if __name__ == "__main__":
    sys.exit(main())
