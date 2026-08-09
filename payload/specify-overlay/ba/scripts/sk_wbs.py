#!/usr/bin/env python3
"""sk_wbs — the WBS export generator (orchestrator rules §10.5, D-O20–D-O25).

BA-Native Spec · the render behind `/ba-wbs`.
Anchors: orchestrator §10.5 (the whole of it — read set, selection, the pinned
columns, Deferred rows, the register, formats and paths, the boundaries) ·
§10.3 (the BA-facing register the generation summary follows) · §6.5 (the flow
profiles whose defaults select rows) · gate §11.1 (the certification manifest)
· gate §7.1 (the waiver record) · gate §9.1 (void detection stays lazy — this
command never re-runs it).

**Read-only, always.** The four sources below are opened for reading and never
written. The only files this script creates are the two exports.

  Read set (D-O25), all read-only:
    specs/NNN-*/spec.md          §2 stories + acceptance · §3 FRs and their
                                 (US<n>) links · §4 flows (role names) ·
                                 §6 Business Rules · §8 Integration table ·
                                 §10 References (the parent brief, the roles)
    specs/NNN-*/gate-report.md   the latest run entry: verdict · waivers in
                                 force · the certification manifest line
    .specify/memory/scope/<E-nn>.md   the epic name (header) · §3 Deferred items
    .specify/memory/roadmap.md   Phase · epic row order

  Written: exports/wbs.xlsx (primary, D-O23 — written first) · exports/wbs.csv

Two derivations this script fixes, both inside what §10.5 states:

  · **Disposition ladder.** §10.5 names four dispositions and the facts each
    reads from; the ladder is most-specific-first — no gate-report.md or no run
    entry → `no gate run`; the latest entry carries a certification manifest →
    `certified — <run date>`; its verdict is FAIL → `FAIL(n)`; anything else is
    a run on record that is not an effective PASS → `draft` (§6.5: a draft spec
    is an ordinary spec.md that stops before its effective PASS).
  · **Marker attribution.** The summary carries "per-feature and per-row
    open-marker counts", so markers attribute to rows: a marker inside a row's
    own source text (its story, its acceptance, its linked FRs, a folded rule)
    belongs to that row. A marker anywhere else in the spec is feature-level
    and renders on every row of that feature — §10.5 requires that every
    deferred question stand as its marker in the column.

Python 3, standard library only (D-P2-7).
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

sys.dont_write_bytecode = True

sys.path.insert(0, str(Path(__file__).resolve().parent))

import sk_xlsx  # noqa: E402
from sk_structure import parse_spec, table_rows  # noqa: E402

# ── the pinned column set (§10.5) ─────────────────────────────────────────────
#
# Eight generated columns, then the manual estimate pair. The estimate headers
# are the placeholder pair §16 carries open until they finalize against the
# company sample WBS; their cells are empty by law (T-18's never-numeric rule).

COLUMNS = [
    "Epic",
    "Topic",
    "User Story",
    "Acceptance Criteria",
    "Integrations",
    "Comments / Questions",
    "Role",
    "Phase",
    "Estimate — min",
    "Estimate — max",
]
WIDTHS = [22, 26, 46, 60, 26, 44, 20, 12, 14, 14]

# ── the register (§10.5 Register) ─────────────────────────────────────────────

MARKER_RE = re.compile(r"\[NEEDS CLARIFICATION:?\s*(?P<text>[^\]]*)\]")
CC_ID_RE = re.compile(r"\bCC-[A-Z]{1,3}-\d{2}\b")
WAIVER_TAG_RE = re.compile(r"\bW-\d{3}-\d{2}\b")

# The EARS vocabulary, as the writing standard fixes it. "Restated as plain
# sentences" is a case transformation and nothing more: the words stay, the
# shouting goes. Conjugating "SHALL create" into "creates" would be authoring,
# and this command never authors.
EARS_PHRASES = [
    ("THEN THE SYSTEM SHALL", "then the system shall"),
    ("THEN THE SYSTEM MUST", "then the system must"),
    ("THE SYSTEM SHALL", "the system shall"),
    ("THE SYSTEM MUST", "the system must"),
    ("THE SYSTEM", "the system"),
]
EARS_WORDS = ["WHEN", "WHILE", "WHERE", "IF", "THEN", "SHALL", "MUST"]

# A cell is stakeholder-facing: no EARS keywords in caps, no CC-IDs, no marker
# brackets. Two exceptions, both deliberate — the waiver tag as provenance in
# Comments / Questions, and quoted status values inside acceptance text.
QUOTED_RE = re.compile(r"\"[^\"]*\"")


def flat(text: str) -> str:
    """One render line: a soft wrap in the source is invisible in a cell."""
    return re.sub(r"\s+", " ", text or "").strip()


def _restate(text: str) -> str:
    """An EARS requirement as a plain sentence — the caps come down, nothing else."""
    out = text
    for caps, plain in EARS_PHRASES:
        out = out.replace(caps, plain)
    for word in EARS_WORDS:
        out = re.sub(r"\b%s\b" % word, word.lower(), out)
    # the sentence still opens like a sentence
    out = out.strip()
    if out[:1].islower():
        out = out[0].upper() + out[1:]
    return out


def _protect_quoted(text: str):
    """Set the quoted status values aside so a register sweep cannot reach them."""
    kept = []

    def stash(m):
        kept.append(m.group(0))
        return "\x00%d\x00" % (len(kept) - 1)

    return QUOTED_RE.sub(stash, text), kept


def _restore_quoted(text: str, kept) -> str:
    for i, q in enumerate(kept):
        text = text.replace("\x00%d\x00" % i, q)
    return text


def plain(text: str, markers: str = "drop", allow_waiver_tag: bool = False) -> str:
    """The register, applied to one cell: plain sentences, nothing shouted.

    Quoted status values are set aside first — "Booked" is the spec's own datum
    and one of the two exceptions §10.5 names.

    `markers="text"` keeps the marker's question, brackets stripped — the one
    column that carries it. Everywhere else the marker is dropped whole: its
    text renders in Comments / Questions on the same row, and D-O22's own
    reasoning is that a second copy is duplication.
    """
    if not text:
        return ""
    body, kept = _protect_quoted(text)
    if markers == "text":
        body = MARKER_RE.sub(lambda m: m.group("text").strip(), body)
    else:
        body = MARKER_RE.sub("", body)
    body = CC_ID_RE.sub("", body)
    if not allow_waiver_tag:
        body = WAIVER_TAG_RE.sub("", body)
    for caps, plain_form in EARS_PHRASES:
        body = body.replace(caps, plain_form)
    for word in EARS_WORDS:
        body = re.sub(r"\b%s\b" % word, word.lower(), body)
    body = _restore_quoted(body, kept)
    body = re.sub(r"[ \t]{2,}", " ", body)
    return body.strip()


# ── record types ──────────────────────────────────────────────────────────────


@dataclass
class Row:
    """One output row — one User Story, or one Deferred item (D-O21)."""

    epic: str = ""
    topic: str = ""
    user_story: str = ""
    acceptance: str = ""
    integrations: str = ""
    comments: str = ""
    role: str = ""
    phase: str = ""
    # provenance, for the generation summary only — never rendered to a cell
    feature: str = ""
    label: str = ""
    markers: int = 0

    def cells(self):
        return [
            self.epic, self.topic, self.user_story, self.acceptance,
            self.integrations, self.comments, self.role, self.phase,
            "", "",          # the manual estimate pair — always empty
        ]


@dataclass
class Feature:
    """One specs/NNN-* folder, read."""

    folder: str
    nnn: str
    spec_path: Path
    epic_id: str = ""
    disposition: str = "no gate run"
    certified: bool = False
    run_date: str = ""
    waivers: list = field(default_factory=list)
    rows: list = field(default_factory=list)
    markers: int = 0
    included: bool = False
    reason: str = ""


# ── the read set ──────────────────────────────────────────────────────────────


def read_roadmap(root: Path):
    """`.specify/memory/roadmap.md` → epic row order, name and Phase."""
    path = root / ".specify" / "memory" / "roadmap.md"
    order, names, phases = [], {}, {}
    if not path.is_file():
        return order, names, phases
    head = []
    for line in path.read_text(encoding="utf-8").splitlines():
        s = line.strip()
        if s.startswith("|") and not head:
            cells = [c.strip() for c in s.strip("|").split("|")]
            if any(c.lower() == "epic" for c in cells):
                head = [c.lower() for c in cells]
    if not head:
        return order, names, phases
    i_id = head.index("id") if "id" in head else 0
    i_name = head.index("epic")
    i_phase = head.index("phase") if "phase" in head else None
    for cells in table_rows(path.read_text(encoding="utf-8")):
        if len(cells) <= i_name:
            continue
        eid = cells[i_id].strip()
        if not re.fullmatch(r"E-\d+", eid):
            continue
        if eid in names:      # the allocation log repeats the ids; the first
            continue          # table is the roster
        order.append(eid)
        names[eid] = cells[i_name].strip()
        phases[eid] = cells[i_phase].strip() if i_phase is not None else ""
    return order, names, phases


def brief_epic_name(text: str, fallback: str) -> str:
    """`# Scope Brief — <Epic name> (<E-nn>)` — the name only, never the code."""
    m = re.search(r"^#\s*Scope Brief\s*[—–-]\s*(?P<name>.+?)\s*\((?P<eid>E-\d+)\)",
                  text, re.M)
    return m.group("name").strip() if m else fallback


def brief_deferred(text: str, phase_vocab):
    """The brief's §3 `Deferred — this epic, later` items (D-O21).

    Template shape (elicitation §4): `<item — target phase, and what substitutes
    at launch>`. The phase is matched against the roadmap's own phase
    vocabulary, so an item that does not carry one renders an empty Phase cell
    rather than a guessed value.
    """
    block = re.search(
        r"^###\s*Deferred\b[^\n]*\n(?P<body>.*?)(?=^#{2,3}\s|\Z)",
        text, re.M | re.S)
    if not block:
        return []
    items, buf = [], []
    for line in block.group("body").splitlines():
        if re.match(r"^\s*[-*]\s+", line):
            if buf:
                items.append(" ".join(buf))
            buf = [re.sub(r"^\s*[-*]\s+", "", line).strip()]
        elif line.strip() and buf:
            buf.append(line.strip())
        elif not line.strip() and buf:
            items.append(" ".join(buf))
            buf = []
    if buf:
        items.append(" ".join(buf))

    out = []
    for raw in items:
        raw = re.sub(r"\s+", " ", raw).strip()
        if not raw or raw.startswith("<"):     # an unfilled template placeholder
            continue
        item, _, rest = raw.partition(" — ")
        if not rest:
            item, _, rest = raw.partition(" - ")
        phase, note = "", rest.strip()
        for cand in sorted(phase_vocab, key=len, reverse=True):
            if cand and note.lower().startswith(cand.lower()):
                phase = cand
                note = note[len(cand):].lstrip(" ;,—–-").strip()
                break
        out.append((item.strip(), phase, note))
    return out


def latest_run(report_text: str):
    """The last `## Gate run <n> — <date>` block of a gate report."""
    blocks = list(re.finditer(r"^##\s*Gate run\s+(?P<n>\d+)\s*[—–-]\s*(?P<date>\S+)",
                              report_text, re.M))
    if not blocks:
        return None
    last = blocks[-1]
    body = report_text[last.end():]
    return {"n": last.group("n"), "date": last.group("date"), "body": body}


def read_gate_report(path: Path):
    """Disposition, run date and the waivers in force — from the latest entry.

    Void detection is not re-run here: gate §9.1 owns it and keeps it lazy.
    "Certified" means the report's last entry says so.
    """
    out = {"disposition": "no gate run", "certified": False,
           "run_date": "", "waivers": []}
    if not path.is_file():
        return out
    entry = latest_run(path.read_text(encoding="utf-8"))
    if entry is None:
        return out
    body = entry["body"]
    out["run_date"] = entry["date"]

    cert = re.search(r"^Certification:\s*run\s+\d+\s*·\s*effective PASS\s*·\s*(?P<date>\S+)",
                     body, re.M)
    if cert:
        out["certified"] = True
        out["run_date"] = cert.group("date")
        out["disposition"] = "certified — %s" % out["run_date"]
    else:
        verdict = re.search(r"^Verdict:\s*(?P<v>.+?)\s*$", body, re.M)
        v = verdict.group("v") if verdict else ""
        gaps = re.search(r"FAIL\s*\((?P<n>\d+)", v)
        if gaps:
            out["disposition"] = "FAIL(%s)" % gaps.group("n")
        elif v.upper().startswith("FAIL"):
            out["disposition"] = "FAIL"
        else:
            out["disposition"] = "draft"

    wblock = re.search(r"^Waivers in force:\s*$(?P<body>.*?)(?=^\S[^\n]*:\s*$|\Z)",
                       body, re.M | re.S)
    if wblock:
        for line in wblock.group("body").splitlines():
            s = line.strip()
            tag = WAIVER_TAG_RE.match(s)
            if not tag:
                continue
            reason = re.search(r"reason:\s*(?P<r>[^·]+)", s)
            out["waivers"].append({
                "tag": tag.group(0),
                "reason": reason.group("r").strip() if reason else "",
            })
    return out


# ── the spec, read into rows ─────────────────────────────────────────────────


def section_body(spec, name: str) -> str:
    sec = next((s for s in spec.sections if s.name == name), None)
    return sec.body if sec else ""


def reference_line(spec, label: str) -> str:
    for line in section_body(spec, "References").splitlines():
        if re.match(r"^\s*[-*]\s*%s\s*:" % re.escape(label), line, re.I):
            return line
    return ""


def spec_epic_id(spec) -> str:
    """The parent epic, from the spec's own §10 References line."""
    ref = reference_line(spec, "Parent epic scope brief")
    m = re.search(r"scope/(E-\d+)\.md", ref) or re.search(r"\b(E-\d+)\b", ref)
    return m.group(1) if m else ""


def spec_roles(spec):
    """The role vocabulary this spec declares in §10 — `(roles used: …)`."""
    ref = reference_line(spec, "Roles & permissions")
    m = re.search(r"roles used:\s*(?P<list>[^)]*)", ref, re.I)
    if not m:
        return []
    return [r.strip() for r in m.group("list").split(",") if r.strip()]


def integrations(spec):
    """§8 Integration Touchpoints — system names only, first column."""
    names = []
    for cells in table_rows(section_body(spec, "Integration Touchpoints")):
        name = plain(cells[0]).strip()
        if name and name not in names:
            names.append(name)
    return names


def story_blocks(spec):
    """Per story: the acceptance items, joined across soft wraps.

    sk_structure's own acceptance parse stops at the line; a WBS cell needs the
    whole assertion, so the block is re-walked here with wraps joined.
    """
    starts = [s.lineno for s in spec.stories]
    blocks = {}
    for i, story in enumerate(spec.stories):
        start = starts[i]
        end = starts[i + 1] if i + 1 < len(starts) else None
        items, buf = [], None
        for n, text in enumerate(spec.lines, start=1):
            if n <= start or (end is not None and n >= end):
                continue
            sm = re.match(r"^\s*Scenario:\s*(.+?)\s*$", text)
            if sm:
                if buf:
                    items.append(" ".join(buf))
                    buf = None
                items.append("Scenario: %s" % sm.group(1).strip())
                continue
            if spec.fenced[n - 1]:
                continue
            cm = re.match(r"^\s*[-*]\s*\[[ xX]\]\s*(.+?)\s*$", text)
            if cm:
                if buf:
                    items.append(" ".join(buf))
                buf = [cm.group(1).strip()]
                continue
            if buf is not None and text.strip() and not text.strip().startswith("#"):
                buf.append(text.strip())
                continue
            if buf:
                items.append(" ".join(buf))
                buf = None
        if buf:
            items.append(" ".join(buf))
        blocks[story.id] = [re.sub(r"\s+", " ", i).strip() for i in items]
    return blocks


def topic_of(story) -> str:
    """The "I want" capability clause, condensed to a short action phrase.

    Transformation of present text only (§10.5): the clause is the spec's own
    words with the leading article dropped and the trailing value clause gone —
    nothing added, nothing stored.
    """
    cap = story.capability or ""
    cap = re.split(r",\s*so that\b", cap, flags=re.I)[0].strip()
    cap = re.sub(r"^(to|the|a|an)\s+", "", cap, flags=re.I).strip()
    cap = cap.rstrip(" .;,")
    return plain(cap[:1].upper() + cap[1:] if cap else "")


def story_sentence(spec, story) -> str:
    """§2's full sentence, verbatim, with the `US<n> (P<n>)` prefix dropped.

    The sentence ends where the acceptance begins: sk_structure joins the whole
    story block up to the first blank line, and the acceptance items are their
    own column.
    """
    parts = []
    for n, text in enumerate(spec.lines, start=1):
        if n < story.lineno:
            continue
        s = text.strip()
        if n > story.lineno and (
            not s
            or re.match(r"^Acceptance\s*:", s)
            or re.match(r"^\s*[-*]\s*\[[ xX]\]", text)
            or s.startswith("```")
            or re.match(r"^\s*US\d+\b", text)
        ):
            break
        parts.append(s)
    raw = re.sub(r"\s+", " ", " ".join(parts)).strip()
    raw = re.sub(r"^\s*US\d+\s*(\(\s*P[123]\s*\))?\s*[—–-]\s*", "", raw)
    return plain(raw)


def build_feature_rows(feature: Feature, spec, epic_name: str, phase: str):
    """One row per User Story (§10.5 Selection), columns per the pinned table."""
    blocks = story_blocks(spec)
    ints = ", ".join(integrations(spec))
    vocab = spec_roles(spec)
    flows = section_body(spec, "Flows, States & Errors")
    rules = {r.id: r for r in spec.rules}
    waiver_note = " · ".join(
        "%s (%s) — %s" % (w["tag"], feature.run_date, w["reason"])
        for w in feature.waivers if w["reason"]
    )

    # Every marker in the spec, whitespace-collapsed: a marker that soft-wraps
    # in the source is one string in the render, and attribution compares the
    # strings the row actually carries.
    all_markers = [flat(m.group(0)) for m in MARKER_RE.finditer(spec.text)]
    claimed = set()
    rows = []

    for story in spec.stories:
        linked = [r for r in spec.requirements if story.id in r.us_refs]
        accept = blocks.get(story.id, [])

        # the rules those FRs or that acceptance reference, folded as own items
        refs = []
        for text in [r.text for r in linked] + accept:
            for rid in re.findall(r"\bBR-\d+\b", text):
                if rid in rules and rid not in refs:
                    refs.append(rid)

        items = [_restate(plain(r.text)) for r in linked]
        items += [plain(a) for a in accept]
        items += [plain(rules[rid].text) for rid in refs]
        items = [i for i in items if i]
        acceptance = "\n".join("%d. %s" % (n, t) for n, t in enumerate(items, 1))

        # roles: the actor first, then any declared role named in the row's
        # linked FRs, its flows, or a folded rule (D-O24)
        roles = []
        if story.actor:
            roles.append(story.actor.strip())
        fr_ids = {r.id for r in linked}
        flow_text = "\n".join(
            ln for ln in flows.splitlines()
            if any(fid in ln for fid in fr_ids)
        )
        scan = " ".join([r.text for r in linked] + accept
                        + [rules[rid].text for rid in refs] + [flow_text])
        for role in vocab:
            if role not in roles and re.search(r"\b%s\b" % re.escape(role), scan):
                roles.append(role)

        source = flat(" ".join([story.raw] + accept + [r.raw for r in linked]
                               + [rules[rid].text for rid in refs]))
        own = [m for m in all_markers if m in source]
        claimed.update(own)

        rows.append(Row(
            epic=epic_name,
            topic=topic_of(story),
            user_story=story_sentence(spec, story),
            acceptance=acceptance,
            integrations=ints,
            comments="",                    # filled once the feature markers are known
            role=", ".join(roles),
            phase=phase,
            feature=feature.folder,
            label=story.id,
        ))
        rows[-1]._own_markers = own          # noqa: SLF001 — local carry only

    # markers that belong to no row are feature-level: §10.5 requires every
    # deferred question to stand as its marker in the column, so they ride
    # every row of the feature, as the Integrations value does
    shared = [m for m in all_markers if m not in claimed]
    for row in rows:
        notes = [plain(m, markers="text")
                 for m in getattr(row, "_own_markers", [])]
        notes += [plain(m, markers="text") for m in shared]
        if waiver_note:
            notes.append(plain(waiver_note, allow_waiver_tag=True))
        row.comments = "\n".join(n for n in notes if n)
        row.markers = len(getattr(row, "_own_markers", [])) + len(shared)
    feature.markers = len(all_markers)
    return rows


def deferred_rows(epic_name: str, items):
    """Brief §3 Deferred items as their own rows (D-O21).

    Epic, Topic, Phase and the launch-substitute note; the story columns stay
    empty — these rows carry no story, no acceptance, no integration, no role.
    """
    out = []
    for item, phase, note in items:
        out.append(Row(
            epic=epic_name,
            topic=plain(item),
            comments=plain(note, markers="text"),
            phase=phase,
            label="deferred",
        ))
    return out


# ── selection (D-O20) ────────────────────────────────────────────────────────


def read_profile(root: Path) -> str:
    """The flow profile, from the ledger head (§2.4) — read, never asked."""
    head = root / ".specify" / "aspect-state.md"
    if not head.is_file():
        return ""
    m = re.search(r"^Profile:\s*(?P<p>Discovery|Presale)\b",
                  head.read_text(encoding="utf-8"), re.M | re.I)
    return m.group("p").lower() if m else ""


def feature_folders(root: Path):
    specs = root / "specs"
    if not specs.is_dir():
        return []
    out = []
    for d in sorted(specs.iterdir()):
        m = re.match(r"^(\d{3})-", d.name)
        if d.is_dir() and m and (d / "spec.md").is_file():
            out.append((m.group(1), d))
    return out


def collect(root: Path, profile: str, include):
    """Read every specs/NNN-*, rule on its selection, and build its rows."""
    order, names, phases = read_roadmap(root)
    include = {i.lstrip("0").rjust(1) if i else i for i in (include or [])}

    features = []
    for nnn, folder in feature_folders(root):
        spec_path = folder / "spec.md"
        spec = parse_spec(spec_path)
        f = Feature(folder=folder.name, nnn=nnn, spec_path=spec_path)
        f.epic_id = spec_epic_id(spec)
        report = read_gate_report(folder / "gate-report.md")
        f.disposition = report["disposition"]
        f.certified = report["certified"]
        f.run_date = report["run_date"]
        f.waivers = report["waivers"]

        asked = nnn.lstrip("0") in include or nnn in include or f.folder in include
        if profile == "presale":
            f.included, f.reason = True, "Presale — every drafted feature"
        elif f.certified:
            f.included, f.reason = True, "certified"
        elif asked:
            f.included, f.reason = True, "admitted by name (--include %s)" % nnn
        else:
            f.included = False
            f.reason = ("no certification on record — admit with --include %s"
                        % nnn)

        brief_path = (root / ".specify" / "memory" / "scope"
                      / ("%s.md" % f.epic_id)) if f.epic_id else None
        brief_text = (brief_path.read_text(encoding="utf-8")
                      if brief_path and brief_path.is_file() else "")
        epic_name = brief_epic_name(brief_text, names.get(f.epic_id, ""))
        f.rows = build_feature_rows(f, spec, epic_name,
                                    phases.get(f.epic_id, ""))
        features.append(f)

    # rows grouped by epic in roadmap row order; inside an epic, features by
    # NNN, then the epic's Deferred rows — the later-phase tail of its scope
    seen_epics = [e for e in order]
    for f in features:
        if f.epic_id and f.epic_id not in seen_epics:
            seen_epics.append(f.epic_id)

    rows, epic_rowcount = [], {}
    for eid in seen_epics:
        mine = [f for f in features if f.epic_id == eid and f.included]
        if not mine:
            continue
        for f in sorted(mine, key=lambda x: x.nnn):
            rows.extend(f.rows)
        brief_path = root / ".specify" / "memory" / "scope" / ("%s.md" % eid)
        brief_text = (brief_path.read_text(encoding="utf-8")
                      if brief_path.is_file() else "")
        epic_name = brief_epic_name(brief_text, names.get(eid, ""))
        d_rows = deferred_rows(epic_name,
                               brief_deferred(brief_text, set(phases.values())))
        rows.extend(d_rows)
        epic_rowcount[epic_name or eid] = (
            sum(len(f.rows) for f in mine), len(d_rows))
    return features, rows, epic_rowcount


# ── the writers (D-O23 — xlsx first, then csv) ───────────────────────────────


def write_xlsx(path: Path, rows):
    return sk_xlsx.write(path, COLUMNS, [r.cells() for r in rows], WIDTHS)


def write_csv(path: Path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh, quoting=csv.QUOTE_MINIMAL)
        w.writerow(COLUMNS)
        for r in rows:
            w.writerow(r.cells())
    return path


# ── the generation summary (§10.5; BA-facing register, §10.3) ────────────────


def summary(features, rows, epic_rowcount, profile, xlsx_path, csv_path):
    default = ("every drafted feature" if profile == "presale"
               else "certified features only")
    out = [
        "WBS export — %d rows → %s · %s" % (len(rows), xlsx_path, csv_path),
        "Profile: %s · selection default: %s" % (profile.capitalize(), default),
        "",
        "| Feature | Disposition | Rows | Open markers |",
        "|---|---|---|---|",
    ]
    for f in sorted(features, key=lambda x: x.nnn):
        out.append("| %s | %s | %s | %d |" % (
            f.folder, f.disposition,
            len(f.rows) if f.included else "excluded", f.markers))
    out.append("")

    for epic, (story_n, def_n) in epic_rowcount.items():
        out.append("Rows — %s: %d story · %d deferred" % (epic, story_n, def_n))

    marked = ["%s %s — %d" % (r.feature or "deferred", r.label, r.markers)
              for r in rows if r.markers]
    out.append("Open markers per row: %s"
               % (" · ".join(marked) if marked else "none on any rendered row"))

    included = [f.folder for f in features if f.included]
    excluded = ["%s — %s" % (f.folder, f.reason)
                for f in features if not f.included]
    out.append("Included: %s" % (", ".join(included) if included else "none"))
    out.append("Excluded: %s" % ("; ".join(excluded) if excluded else "none"))
    out.append("Next: open %s — the two estimate columns are the client's to fill"
               % xlsx_path)
    return "\n".join(out)


# ── CLI ──────────────────────────────────────────────────────────────────────


def main(argv=None) -> int:
    p = argparse.ArgumentParser(
        description="WBS export — orchestrator rules §10.5 (D-O20–D-O25)")
    p.add_argument("--root", default=".", help="project root")
    p.add_argument("--include", action="append", default=[], metavar="NNN",
                   help="admit an uncertified feature by number (repeatable)")
    p.add_argument("--profile", choices=("discovery", "presale"),
                   help="override the ledger head's flow profile (§6.5)")
    p.add_argument("--out-dir", default="exports",
                   help="destination for wbs.xlsx and wbs.csv")
    p.add_argument("--summary-only", action="store_true",
                   help="print the generation summary; write no files")
    args = p.parse_args(argv)

    root = Path(args.root).resolve()
    profile = args.profile or read_profile(root) or "discovery"

    features, rows, epic_rowcount = collect(root, profile, args.include)

    out_dir = Path(args.out_dir)
    if not out_dir.is_absolute():
        out_dir = root / out_dir
    xlsx_path, csv_path = out_dir / "wbs.xlsx", out_dir / "wbs.csv"

    if not args.summary_only:
        write_xlsx(xlsx_path, rows)      # primary, written first (D-O23)
        write_csv(csv_path, rows)

    def shown(path):
        try:
            return str(path.relative_to(root))
        except ValueError:
            return str(path)

    print(summary(features, rows, epic_rowcount, profile,
                  shown(xlsx_path), shown(csv_path)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
