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

# §10 References is read with the gate's own readers, imported rather than
# restated. The gate is the authority on what a valid References section looks
# like (CC-TR-02 finds a required reference by its **path**, the label being
# decorative; CC-TR-03 finds the declaration by `roles used:`, bulleted or
# not) — and this render must never be stricter than the check that certified
# the spec it is rendering. A second copy of these patterns is a second thing
# to drift.
from sk_idgraph import PATH_RE, ROLES_DECL_RE  # noqa: E402
# The brief's §8 body, read by the checker that owns it (CC-XA-05 · CC-H-03).
# The roadmap dimension below needs to know whether a slicing is *confirmed*;
# a second parse of the same section is a second thing to drift.
from sk_brief import slicing_section  # noqa: E402

# ── the pinned column set (§10.5) ─────────────────────────────────────────────
#
# Nine columns, ending at Billable (D-O60 · D-O67; D-O60's *eight, ending at
# Phase* amended on the record). There is no estimate column: estimating is
# the client's act and stands outside the export (D-O60, closing §16's carry
# item by removal). The never-numeric rule (T-18) is held here by structure
# rather than by an always-empty cell — there is no cell to fill. Billable is
# a derived Yes/No and never a number, so the guarantee is untouched.

COLUMNS = [
    "Epic",
    "Topic",
    "User Story",
    "Acceptance Criteria",
    "Integrations",
    "Comments / Questions",
    "Role",
    "Phase",
    "Billable",
]
WIDTHS = [22, 26, 46, 60, 26, 44, 20, 12, 10]

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
    billable: str = ""
    # provenance, for the generation summary only — never rendered to a cell
    feature: str = ""
    label: str = ""
    markers: int = 0

    def cells(self):
        return [
            self.epic, self.topic, self.user_story, self.acceptance,
            self.integrations, self.comments, self.role, self.phase,
            self.billable,
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
    return read_roadmap_at(root / ".specify" / "memory" / "roadmap.md")


def read_roadmap_at(path: Path):
    """The same read, taking the file — the path-taking core.

    `sk_health`'s CC-H-08 honours a `--roadmap` override and must read the
    roster exactly as the export reads it, header-resolved columns and all:
    a second copy of this parse is a second thing to drift (D-O100's one
    computation, four display sites).
    """
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


def reference_lines(spec):
    """§10 References, the lines the gate reads — fenced and comment lines out.

    The same line set `sk_idgraph.declared_paths` walks for CC-TR-02. The
    template's labelled bullets are one legal shape, not the only one: a bare
    path bullet with a standalone `Roles used:` line passes both checks, and a
    spec written that way certifies. This render reads whatever the gate reads.
    """
    sec = spec.section("References")
    if sec is None:
        return []
    return [(n, t) for n, t in sec.lines
            if not spec.fenced[n - 1] and not t.strip().startswith("<!--")]


def spec_epic_id(spec) -> str:
    """The parent epic, from §10 References — found by path, as the gate finds it.

    CC-TR-02's own needle for the parent brief is `scope/`; the epic id is that
    path's stem. A bare `E-nn` mention anywhere in the section is the fallback.
    """
    for _, text in reference_lines(spec):
        for m in PATH_RE.finditer(text):
            if "scope/" in m.group(1):
                stem = re.search(r"(E-\d+)", Path(m.group(1)).stem)
                if stem:
                    return stem.group(1)
    for _, text in reference_lines(spec):
        m = re.search(r"\b(E-\d+)\b", text)
        if m:
            return m.group(1)
    return ""


def spec_roles(spec):
    """The role vocabulary this spec declares — CC-TR-03's own declaration read.

    `roles used: …`, bulleted or not, parenthesised or not; the list splits on
    the two separators the gate splits on.
    """
    for _, text in reference_lines(spec):
        m = ROLES_DECL_RE.search(text)
        if m:
            return [r.strip() for r in re.split(r"[,·]", m.group("list"))
                    if r.strip()]
    return []


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


# ── the frame fields the export reads (§2.4 · D-O67 · D-O75) ─────────────────
#
# The read set gains the ledger head's `Client label:` and `Boundary:` fields
# beside the profile — D-O25's *profile field only* clause amended on the
# record — and, with D-O75, the `Cross-cutting:` register line: the third
# title-block line's and the generation summary's naming ground. Read-only,
# like everything else here: this command never writes a ledger. Absence is
# never an error and never a guess (§10.5, "never invents") — a missing label
# renders the project name alone, a missing boundary leaves every Billable cell
# empty (D-O71) and renders `none stated` on the title block (D-O77), and a
# missing register line renders `none stated` too.

# One `XO-<n>` entry: `XO-<n> — <class>: <value> (<citation>) — <state>`
# (§2.4, D-O72). The state token is what closes the entry, and it is matched at
# a ` — ` boundary from the RIGHT: `carried — <unit>` carries a separator of its
# own, so the LAST state token on the entry is the entry's state.
XO_CLASSES = ("language", "device", "accessibility", "branding", "compliance")
XO_STATES = ("captured", "carried", "accepted", "default")
RE_XO_ENTRY = re.compile(
    r"^XO-(?P<n>\d+)\s+—\s+(?P<cls>[^:]+):\s*(?P<rest>.*)$")
RE_XO_STATE = re.compile(
    r"\s+—\s+(?P<state>%s)\b" % "|".join(XO_STATES))


def parse_cross_cutting(line: str):
    """The `Cross-cutting:` head line → a list of `(n, cls, value, state)`.

    Entries are ` · `-separated; the value is what stands ahead of the entry's
    citation parenthetical. An entry that does not parse is skipped rather than
    guessed — the export never invents (§10.5).
    """
    out = []
    for chunk in line.split(" · "):
        chunk = chunk.strip()
        m = RE_XO_ENTRY.match(chunk)
        if not m:
            continue
        cls = m.group("cls").strip().lower()
        rest = m.group("rest").strip()
        state, last = "", None
        for sm in RE_XO_STATE.finditer(rest):
            last = sm
        if last:
            state = last.group("state")
            rest = rest[:last.start()].strip()
        # `<value, one line> (<citation>)` — drop the trailing citation
        value = re.sub(r"\s*\([^()]*\)\s*$", "", rest).strip()
        out.append((int(m.group("n")), cls, value, state))
    return out


def read_frame(root: Path):
    """The ledger head's `Client label:`, `Boundary:` and `Cross-cutting:`
    (§2.4 — D-O67 · D-O75).

    Returns `(label, boundary, cross)` — the label verbatim as the client wrote
    it or "" where it stands open, the boundary as the ladder values it names,
    and the register as parsed `(n, cls, value, state)` entries.
    """
    head = root / ".specify" / "aspect-state.md"
    if not head.is_file():
        return "", [], []
    text = head.read_text(encoding="utf-8")

    label = ""
    m = re.search(r"^Client label:[ \t]*(?P<v>.*)$", text, re.M)
    if m:
        # `<free text>  (<citation | BA-supplied | open — no source material>)`
        # — the value is what stands ahead of the citation parenthetical.
        v = re.sub(r"\s{2,}\(.*\)\s*$", "", m.group("v")).strip()
        if v and not v.startswith("<") and not v.startswith("open —"):
            label = v

    boundary = []
    m = re.search(r"^Boundary:[ \t]*(?P<v>.*)$", text, re.M)
    if m:
        # `<ladder value(s)> — set <date> (P-O0b); …` — the values are what
        # stands ahead of the ` — set ` tail; the ladder joins them with `+`.
        v = m.group("v").split(" — ")[0].strip()
        if v and not v.startswith("<"):
            boundary = [part.strip() for part in v.split("+") if part.strip()]

    cross = []
    m = re.search(r"^Cross-cutting:[ \t]*(?P<v>.*)$", text, re.M)
    if m:
        cross = parse_cross_cutting(m.group("v").strip())
    return label, boundary, cross


def billable_cell(phase: str, boundary) -> str:
    """`Yes` inside the boundary · `No` outside · blank on a blank Phase, and
    blank where no boundary stands in the frame.

    Derived, never a guess and never a number (D-O67): an absent Phase renders
    an empty cell, and so does an absent boundary — there is no ground to test
    against, and the export never invents one. The absent-boundary half was the
    exporter's reading of §10.5's never-invents clause from the start; **D-O71
    rules it**, so the behaviour below is now the law rather than a reading:
    never a default `Yes` or `No`.
    """
    phase = (phase or "").strip()
    if not phase or not boundary:
        return ""
    return "Yes" if phase in boundary else "No"


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
        # A spec this reader cannot read produces no rows — and the summary
        # must say *that*, never let the folder pass as one that legitimately
        # carried nothing (§10.5's nothing-silently-dropped rule, and §10.4's
        # D-O50 for the reason it is named rather than counted).
        if not spec.readable:
            f.disposition = "unreadable — headings do not match standard §2"
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

    # A selected feature whose §10 References names no parent brief has no epic
    # to group under. It is rendered anyway, at the tail, with Epic and Phase
    # empty — an absent source renders an empty cell, never a guess — because
    # §10.5's rule is that nothing is silently dropped. The summary names it.
    unlinked = [f for f in features if f.included and not f.epic_id]
    for f in sorted(unlinked, key=lambda x: x.nnn):
        rows.extend(f.rows)
    if unlinked:
        epic_rowcount["— no parent epic linked"] = (
            sum(len(f.rows) for f in unlinked), 0)
    return features, rows, epic_rowcount


# ── the writers (D-O23 — xlsx first, then csv) ───────────────────────────────


def title_block(project: str, label: str, boundary, date: str, cross=()):
    """The three title-block lines — the xlsx render only (D-O67 · D-O75 ·
    D-O77).

    The label is verbatim, the client's own word; where it stands open the
    first line renders the project name alone — the export never invents.
    Budget never enters the header: the deferral named the label and the
    marking, and this is exactly that.

    Where no delivery boundary stands in the frame the second line renders
    `Delivery boundary: none stated · generated <date>` — never an empty value
    (D-O77), the never-invents clause stated at the line it governs.

    The third line renders every non-`default` register entry (D-O75), and
    `none stated` where only the English engagement default stands. The default
    itself never renders: it is framework law, not a client fact, and the
    export states client ground only — the label's own `open` logic, applied.
    """
    first = "%s — %s" % (label, project) if label else project
    if boundary:
        second = "Delivery boundary: %s — billable phases: %s · generated %s" % (
            " + ".join(boundary), ", ".join(boundary), date)
    else:
        second = "Delivery boundary: none stated · generated %s" % date
    stated = ["%s: %s (XO-%d)" % (cls, value, n)
              for n, cls, value, state in cross if state != "default"]
    third = "Cross-cutting: %s" % (" · ".join(stated) if stated else "none stated")
    return [first, second, third]


def write_xlsx(path: Path, rows, title=()):
    return sk_xlsx.write(path, COLUMNS, [r.cells() for r in rows], WIDTHS,
                         title=title)


def write_csv(path: Path, rows):
    # No title block: the csv is the canonical, diff-friendly render, and lines
    # above the column row break its shape (D-O67). The per-row fact both
    # renders share is the Billable column.
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh, quoting=csv.QUOTE_MINIMAL)
        w.writerow(COLUMNS)
        for r in rows:
            w.writerow(r.cells())
    return path


# ── the roadmap dimension of the summary (§10.5 · D-O100) ────────────────────

CONFIRMED_RE = re.compile(r"^Confirmed\b", re.I)


def first_missing_link(root: Path, eid: str, features) -> str:
    """Where an in-boundary epic with zero rows stops — the read set's own answer.

    Four links, in order, and the **first** one that fails is the one named:
    `no brief` · `brief — no confirmed slicing` · `no spec folder` ·
    `spec — no stories`. Nothing new is opened: the brief folder, the brief's
    §8 and the `specs/NNN-*` folders are already D-O25's read set — the ladder
    only says which of them the epic has not reached.
    """
    brief = root / ".specify" / "memory" / "scope" / ("%s.md" % eid)
    if not brief.is_file():
        return "no brief"
    body = slicing_section(brief.read_text(encoding="utf-8"))
    rows = [c for c in table_rows(body) if any(x.strip() for x in c)]
    if not any(CONFIRMED_RE.match(c[-1].strip()) for c in rows):
        return "brief — no confirmed slicing"
    if not any(f.epic_id == eid for f in features):
        return "no spec folder"
    return "spec — no stories"


def roadmap_dimension(root: Path, features, in_boundary):
    """Every in-boundary roadmap epic that contributed zero rows (D-O100).

    *Nothing silently dropped*, applied to the quoted scope. The specs
    dimension already names every `specs/NNN-*` folder — and held that
    contract while two in-boundary epics had **no folder to name**. This is
    where the same contract runs on the roadmap.

    Returns `[]` where the coverage check is vacuous (no roadmap, no boundary)
    or where every in-boundary epic contributed a row. Counts render, the BA
    judges: no threshold, and the export never blocks.
    """
    if not in_boundary:
        return []
    covered = {f.epic_id for f in features if f.included and f.rows and f.epic_id}
    return [(eid, name, phase, first_missing_link(root, eid, features))
            for eid, name, phase in in_boundary if eid not in covered]


# ── the generation summary (§10.5; BA-facing register, §10.3) ────────────────


def summary(features, rows, epic_rowcount, profile, xlsx_path, csv_path,
            cross=(), uncovered_epics=()):
    default = ("every drafted feature" if profile == "presale"
               else "certified features only")
    # Counted off the rows that were actually emitted, never off what was
    # built: a table that can disagree with the file it describes is worse
    # than no table.
    emitted = {}
    for r in rows:
        if r.feature:
            emitted[r.feature] = emitted.get(r.feature, 0) + 1

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
            emitted.get(f.folder, 0) if f.included else "excluded", f.markers))
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

    unlinked = [f.folder for f in features if f.included and not f.epic_id]
    if unlinked:
        out.append("Unlinked: %s — §10 References names no parent epic scope "
                   "brief; the rows render with Epic and Phase empty"
                   % ", ".join(unlinked))
    empty = [f.folder for f in features
             if f.included and not emitted.get(f.folder)]
    if empty:
        out.append("No rows: %s — selected, but §2 yielded no User Story"
                   % ", ".join(empty))
    # The roadmap dimension (D-O100). The specs dimension above names every
    # folder; this one names every in-boundary epic that has no folder to be
    # named in — each with its phase, its Billable value and the first link
    # it is missing. Counts render, the BA judges; the export never blocks.
    if uncovered_epics:
        out.append("In-boundary epics with no rows: %d" % len(uncovered_epics))
        for eid, name, phase, link in uncovered_epics:
            out.append("  %s %s — %s · Billable Yes — %s"
                       % (eid, name, phase, link))
        out.append("The WBS understates the quoted scope until they are "
                   "briefed and specced.")
    # The register's teeth (D-O75): `carried`, `accepted` and `default` are
    # terminal states; anything else — a `captured` entry above all — is an
    # obligation that left Frame with no carrier, and it is NAMED, never
    # blocked. Counts render, the BA judges, and the export stays invocable.
    open_xo = ["XO-%d — %s: %s" % (n, cls, value)
               for n, cls, value, state in cross
               if state not in ("carried", "accepted", "default")]
    out.append("Cross-cutting — entries not carried: %s"
               % (" · ".join(open_xo) if open_xo else "none"))
    out.append("Next: open %s — the render ends at Billable; estimating is the "
               "client's act on their own copy" % xlsx_path)
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
    p.add_argument("--date", default=None, metavar="YYYY-MM-DD",
                   help="stamp the xlsx title block with this date "
                        "(default: today)")
    args = p.parse_args(argv)

    root = Path(args.root).resolve()
    profile = args.profile or read_profile(root) or "discovery"
    label, boundary, cross = read_frame(root)

    features, rows, epic_rowcount = collect(root, profile, args.include)

    # The roadmap dimension's ground is the gate's own computation — the
    # CC-H-08 set, imported rather than recomputed (D-O100: one computation,
    # four display sites). This render adds only the downstream links a
    # briefed-but-unrendered epic fails at.
    #
    # Imported HERE and not at module level, deliberately: `sk_health` imports
    # this module for the three grounds CC-H-08 reads, so a module-level import
    # back would close the cycle. The dependency runs one way — the gate
    # computes and rules, the renders read — and this local import is what
    # keeps it that way.
    from sk_health import boundary_coverage  # noqa: E402
    in_boundary, _uncovered = boundary_coverage(
        root / ".specify" / "memory" / "roadmap.md",
        root / ".specify" / "memory" / "scope", root)
    uncovered_epics = roadmap_dimension(root, features, in_boundary)

    # Billable is derived per row, after collection: the Phase cell is already
    # on the row (a deferred row carries its item's target phase), and the
    # boundary is the ledger head's (D-O67).
    for r in rows:
        r.billable = billable_cell(r.phase, boundary)

    out_dir = Path(args.out_dir)
    if not out_dir.is_absolute():
        out_dir = root / out_dir
    xlsx_path, csv_path = out_dir / "wbs.xlsx", out_dir / "wbs.csv"

    if not args.summary_only:
        stamp = args.date or __import__("datetime").date.today().isoformat()
        title = title_block(root.name, label, boundary, stamp, cross)
        write_xlsx(xlsx_path, rows, title)   # primary, written first (D-O23)
        write_csv(csv_path, rows)            # no title block (D-O67)

    def shown(path):
        try:
            return str(path.relative_to(root))
        except ValueError:
            return str(path)

    print(summary(features, rows, epic_rowcount, profile,
                  shown(xlsx_path), shown(csv_path), cross, uncovered_epics))
    return 0


if __name__ == "__main__":
    sys.exit(main())
