#!/usr/bin/env bash
#
# BA-Native Spec — Band 2 + the spine (build plan §4, S8).
#
# Build plan §4, S8 row: *E-03 decomposed + allocated (diff + log entry);
# `ba-tier1 kit` emits ≤ 12 must-ask, every question destination-tagged, zero
# §3.3 depth violations; scripted ingestion → brief `Scoped` with slicing;
# `ba-tier2` drafts spec r5 with ≤ 7 GQs from the answer sheet, every drafted
# value cited-or-marked.*
#
#   1.  the ## Band 2 plan carries t17 · t18 · tier1 with pinned contracts
#   2.  T-17 + T-18 land roadmap.md in the shape the sheets pin
#   3.  Tier 1: the kit's caps and tags, and the brief the ingestion produced
#   4.  Tier 2: spec r5 against the answer sheet — cap, anchors, cite-or-mark
#   5.  34 seeded defects, one per rule — the suite is not vacuous
#   6.  /ba-run dispatch: the interface the four skills implement, both ends
#   7.  the compiled sheets' locked content — depth boundaries, refusals, splits
#   8.  the analyst agent, and the three personas' boundaries against each other
#   9.  layering — no methodology-layer content in the S8 payload
#
# Same split as S5/S6/S7: the **validator runs live** (tests/check-band2-artifacts.py);
# the artifacts are recorded, because producing one is an agent act.
#
#   check-spine.sh        run the suite
#   check-spine.sh -v     print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
PROJ="$FX/project"
MEM="$PROJ/.specify/memory"
SKILLS="$PKG_ROOT/payload/claude/skills"
AGENTS="$PKG_ROOT/payload/claude/agents"
VALIDATE="$HERE/check-band2-artifacts.py"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,26p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

flat_has() {
  python3 - "$1" "$2" <<'PY'
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}
has()   { flat_has "$1" "$2" && ok "$3" || bad "$3 — not found: $2"; }
hasnt() { flat_has "$1" "$2" && bad "$3 — present but must not be: $2" || ok "$3"; }

mutate() {
  python3 - "$@" <<'PY'
import sys, pathlib
base, out = sys.argv[1], sys.argv[2]
t = pathlib.Path(base).read_text(encoding="utf-8")
args = sys.argv[3:]
for old, new in zip(args[0::2], args[1::2]):
    if old not in t:
        sys.exit(f"mutation source not present in {base}: {old!r}")
    t = t.replace(old, new, 1)
pathlib.Path(out).parent.mkdir(parents=True, exist_ok=True)
pathlib.Path(out).write_text(t, encoding="utf-8")
PY
}

neg() {
  local label="$1" expect="$2"; shift 2
  if python3 "$VALIDATE" "$@" --expect "$expect" > "$TMP/neg.out" 2>&1; then
    ok "$label → $expect"
  else
    bad "$label — expected $expect"
    sed 's/^/      /' "$TMP/neg.out"
  fi
}

M="$TMP/mut"; mkdir -p "$M"
PLANS="$FX/band1/aspect-plans.md"
STATE="$FX/band1/aspect-state.md"

RM="$MEM/roadmap.md"
KIT="$MEM/scope/E-03.kit.md"
BRIEF="$MEM/scope/E-03.md"
CV="$PROJ/canvas.md"
R5="$FX/revisions/spec-r5.md"
ANS="$FX/tier2-answer-sheet.md"

T17="$SKILLS/ba-t17/SKILL.md"; T18="$SKILLS/ba-t18/SKILL.md"
TI1="$SKILLS/ba-tier1/SKILL.md"; TI2="$SKILLS/ba-tier2/SKILL.md"
RUN="$SKILLS/ba-run/SKILL.md"
ANALYST="$AGENTS/ba-analyst.md"

# ── 1. the Band-2 plan and its pinned contracts ──────────────────────────────

printf '\n▸ The ## Band 2 plan carries the Band-2 runs with pinned contracts (orchestrator §6.3/§6.4)\n'

has "$PLANS" "## Band 2" "the plans file carries a Band-2 section, not an aspect section"

for row in \
  "t17|{the roadmap's epic table — one row per epic: E-<nn> · Epic · Description · Phase (Unallocated at birth) · Status (Defined at birth) · Source; the set exclusively partitioned, coverage-complete, every row cited · Context · \`.specify/memory/roadmap.md\`}" \
  "t18|{the recommended allocation as a diff vs. current — changed rows from → to with a factor-tagged reason, held rows one line, the four-factor basis — and on approval the Phase cells plus one Allocation-log entry · Context · \`.specify/memory/roadmap.md\`}" \
  "tier1|{the epic's scope brief at the nine-section shape, the call kit beside it, and a routed-findings batch · Context · \`.specify/memory/scope/<epic>.md\`}"
do
  name="${row%%|*}"; triple="${row#*|}"
  has "$PLANS" "$triple" "the composed plan pins $name's output contract"
  plain="$(printf '%s' "$triple" | tr -d '`')"
  has "$SKILLS/ba-$name/SKILL.md" "$plain" "…and ba-$name carries it, character for character"
done

# Tier 2's contract is per feature and is NOT a plans-file row (the tracking split)
has "$TI2" "{a gate-ready spec.md in writing-standard shape, the brief §6 write-back, and routed-findings signals where cross-cutting content surfaced · Spec · specs/NNN-<feature>/spec.md}" \
    "ba-tier2 carries its own pinned contract"
grep -qE '^\| *[0-9]+ *\| *tier2' "$PLANS" \
  && bad "a tier2 row stands in the plans file — Band-3 state belongs to the ledger and the spec" \
  || ok "no tier2 row in the plans file: the tracking split holds at Band 3"
has "$STATE" "004-appointment-booking entered Band 3" \
    "…and the feature's record is the ledger's band event instead"

# every allocation entry has a run-log line naming its trigger
python3 - "$RM" "$PLANS" <<'PY' && ok "every allocation entry has a run-log line naming its trigger" \
                                  || bad "an allocation entry has no run-log line, or none naming a trigger"
import re, sys, pathlib
rm, plans = (pathlib.Path(p).read_text(encoding="utf-8") for p in sys.argv[1:3])
dates = re.findall(r"^###\s+Allocation\s+\d+\s+—\s+(\d{4}-\d{2}-\d{2})", rm, re.M)
log = re.findall(r"^(\d{4}-\d{2}-\d{2}) · t18 .*(?:\n\s+trigger: .*)?", plans, re.M)
runs = {m.group(1) for m in re.finditer(r"^(\d{4}-\d{2}-\d{2}) · t18 ", plans, re.M)}
trig = {m.group(1) for m in re.finditer(r"^(\d{4}-\d{2}-\d{2}) · t18 [^\n]*\n\s+trigger: \S", plans, re.M)}
sys.exit(0 if dates and set(dates) <= runs and set(dates) <= trig else 1)
PY

# ── 2. what T-17 and T-18 landed ─────────────────────────────────────────────

printf '\n▸ T-17 + T-18: the roadmap in the shape the sheets pin (validator, live)\n'

if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" > "$TMP/rm.out" 2>&1; then
  ok "roadmap.md — rows, ladder, statuses, log grammar, coverage: no violations"
else
  bad "roadmap.md fails the validator"; sed 's/^/      /' "$TMP/rm.out"
fi

has "$RM" "## Epics" "the epic table stands"
has "$RM" "## Allocation log" "the allocation log stands in the same file (one file, three writers)"
has "$RM" "### Allocation 1 — 2026-07-11 · trigger: post-decomposition" \
    "Allocation 1 names its trigger — the initial run after decomposition"
has "$RM" "### Allocation 2 — 2026-07-15 · trigger: post-ingestion E-03" \
    "Allocation 2 names the ingestion that triggered it"
has "$RM" "no change — the brief confirms the MVP composition" \
    "…and logs its no-change outcome with a reason: the review act is audit ground"
has "$RM" "| E-03 | Appointment Booking |" "E-03 is decomposed at the locked row shape"
has "$RM" "| E-03 Appointment Booking | Unallocated → MVP | walking skeleton:" \
    "…and allocated by the walking-skeleton factor, from → to, with its reason"
has "$RM" "graduated this run" "E-07 carries the graduation that produced it"
has "$MEM/out-of-scope.md" "E-07" "…and the fence resolves to the epic it became — the pair, both ends"

# the E-03 row the kit consumes is byte-identical to the roadmap's
python3 - "$RM" "$KIT" "$BRIEF" <<'PY' && ok "the E-03 row's description is what the kit and brief were built on" \
                                       || bad "the E-03 description drifted between roadmap, kit and brief"
import re, sys, pathlib
rm = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
row = next(l for l in rm.splitlines() if l.startswith("| E-03 |"))
desc = [c.strip() for c in row.strip("|").split("|")][2]
sys.exit(0 if desc.startswith("Clients book specialists' published slots online instead of calling.") else 1)
PY

# ── 3. Tier 1 — the kit's caps and tags, and the brief ───────────────────────

printf '\n▸ Tier 1: kit → call → brief (elicitation §3, the exit-test properties)\n'

if python3 "$VALIDATE" --kit "$KIT" --roadmap "$RM" > "$TMP/kit.out" 2>&1; then
  ok "E-03.kit.md — parts A–D, question grammar, destination tags, caps: no violations"
else
  bad "the kit fails the validator"; sed 's/^/      /' "$TMP/kit.out"
fi

# the three exit-test properties, asserted directly and not only via the validator
python3 - "$KIT" <<'PY' > "$TMP/kitfacts" 2>&1
import re, sys, pathlib
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
qs = re.findall(r"^Q(\d+)\s*\[destination:\s*([^\]]*)\]\s*\[(must-ask|if-time)\]", t, re.M)
must = [q for q in qs if q[2] == "must-ask"]
print(f"questions={len(qs)} must={len(must)} tagged={sum(1 for q in qs if q[1].strip())}")
PY
read -r KITFACTS < "$TMP/kitfacts"
case "$KITFACTS" in
  "questions=6 must=6 tagged=6") ok "the kit: 6 questions, 6 must-ask (≤ 12), every one destination-tagged" ;;
  *) bad "kit question facts unexpected: $KITFACTS" ;;
esac

has "$KIT" "[destination: Boundaries] [must-ask]" "the sibling-boundary question is destination-tagged to Boundaries"
has "$KIT" "The roadmap holds payments in \"Online Payment\" (E-07, Phase 2)" \
    "…and it leans on the sibling's phase — which is why allocation precedes the kit"
has "$KIT" "impact if wrong: integration scope and" "an assumption carries its impact-if-wrong"
has "$KIT" "Q7 dropped (answered by email" "the composed agenda records a dropped question as a false-ask"

if python3 "$VALIDATE" --brief "$BRIEF" > "$TMP/brief.out" 2>&1; then
  ok "scope/E-03.md — nine sections, D4 statuses, D5 slicing, capabilities-not-stories: no violations"
else
  bad "the brief fails the validator"; sed 's/^/      /' "$TMP/brief.out"
fi

has "$BRIEF" "Status: Scoped" "ingestion left the brief Scoped"
has "$BRIEF" "| F1 004-appointment-booking |" "…with its slicing table proposing the feature"
has "$BRIEF" "| OQ-2 | Which calendar providers must sync at launch? | F1 | Open |" \
    "an unanswered question stays visible with status, and does not block the brief"
has "$BRIEF" "reopen signal → Stakeholders aspect" \
    "the call's contradiction left as a reopen signal, not a silent reconciliation"
has "$BRIEF" "no concrete cutoff given" \
    "Captured Detail preserves the volunteered fact without inventing the number"

# ── 3b. brief §6's ID grammar, pinned as law (D12) ───────────────────────────
#
# The grammar every §6 reader matches was carried by the skeleton, the template
# and a worked example — in three places and as law in none. D-O58's line-4
# reader needs a law to match against; D12 states it once, in the document that
# owns the brief's section shapes, and the carriers cite it.

printf '\n▸ Brief §6 — the OQ-<n> grammar, stated once and cited (elicitation D12)\n'

ELIC="$PKG_ROOT/docs/methodology/ba-native-spec-elicitation-techniques.md"
BTPL="$PKG_ROOT/payload/specify-overlay/ba/templates/scope-brief-template.md"

has "$ELIC" "ID grammar (D12, locked): OQ-<n>" \
    "the brief skeleton pins the ID grammar where §6's shape is pinned"
has "$ELIC" "OQ-1, OQ-2, … numbered per brief." \
    "…numbered per brief — the sequence restarts and is never globally unique"
has "$ELIC" "Epic context rides BESIDE the ID in a render, never inside it" \
    "…epic context beside the ID, never inside it"
has "$BTPL" "ID grammar (D12, locked — elicitation engine §4)" \
    "the payload template carries the grammar and cites its home"
has "$BTPL" '(`E01-Q1` is not an ID)' \
    "…and names the off-shape form the reader counts"
has "$TI1" 'carrying an **`OQ-<n>` ID numbered per brief**' \
    "ba-tier1's assemble step names the grammar it must write"
has "$TI1" "elicitation engine §4 — the sequence restarts in every brief" \
    "…by reference to its one home, not by restating the law"

# The worked example was conformant before the rule existed — which is the
# evidence the grammar was real, and why no example was rewritten to fit it.
has "$SKILLS/ba-tier1/references/example.md" "| OQ-1 |" \
    "the worked example was already conformant — no example rewritten to fit the rule"

# ── 4. Tier 2 — the spec the answer sheet produces ───────────────────────────

printf '\n▸ Tier 2: spec r5 from the scripted answer sheet (elicitation §5)\n'

if python3 "$VALIDATE" --spec "$R5" --answers "$ANS" --brief "$BRIEF" > "$TMP/t2.out" 2>&1; then
  ok "spec r5 · answer sheet · brief — cap, anchors, cite-or-mark, write-back: no violations"
else
  bad "the tier-2 pass fails the validator"; sed 's/^/      /' "$TMP/t2.out"
fi

python3 - "$ANS" <<'PY' > "$TMP/gqfacts" 2>&1
import re, sys, pathlib
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
gq = re.findall(r"^GQ(\d+)\s+of\s+(\d+)\s*—", t, re.M)
print(f"asked={len(gq)} cap={gq[0][1] if gq else '?'}")
PY
read -r GQFACTS < "$TMP/gqfacts"
case "$GQFACTS" in
  "asked=4 cap=7") ok "4 questions asked against the default cap of 7 — no overflow" ;;
  *) bad "GQ facts unexpected: $GQFACTS" ;;
esac

has "$ANS" "no overflow, so no Tier-1 supplement signal" "the session records that it did not overflow"
has "$ANS" "Cited, not asked" "a citable value was cited, not asked — Guard 1 on the record"
has "$ANS" "**Stays a marker.**" "a blocked value stayed a marker rather than becoming a guess"
has "$R5" "[NEEDS CLARIFICATION: what becomes of a confirmed Appointment while calendar sync is unavailable? — brief E-03 OQ-2 / R1, provider contract unsigned]" \
    "…and the surviving marker names its location and what it waits on"
has "$BRIEF" "Answered — 2026-07-16 → spec 004 BR-001 (cap: 3)" \
    "the brief write-back landed in the D4 grammar"
has "$R5" "BR-002 — Free cancellation window: strictly more than 24 hours before" \
    "GQ1's answer landed in the business rule"
has "$R5" "Cancellation inside 24h of start_time keeps the Slot unavailable for rebooking (BR-002)" \
    "…and in the acceptance line, the same answer's second destination"

# ── 5. the seeded defects — one per rule ─────────────────────────────────────

printf '\n▸ 34 seeded defects — one per rule; the suite is not vacuous\n'

# roadmap · T-17 side
mutate "$RM" "$M/b71.md" "## Allocation log" "## Log"
neg "roadmap: the log section renamed"            B71 --roadmap "$M/b71.md"
mutate "$RM" "$M/b72.md" "| ID | Epic | Description | Phase | Status | Source |" \
                          "| ID | Epic | Description | Status | Phase | Source |"
neg "roadmap: header columns transposed"          B72 --roadmap "$M/b72.md"
mutate "$RM" "$M/b73.md" "| E-08 | Performance Reporting |" "| E-8 | Performance Reporting |" \
                          "| E-08 Performance Reporting |" "| E-8 Performance Reporting |"
neg "roadmap: an ID off the E-<nn> grammar"       B73 --roadmap "$M/b73.md"
mutate "$RM" "$M/b74.md" "| E-05 | Notification Delivery |" "| E-05 | Notifications |"
neg "roadmap: a one-word epic name"               B74 --roadmap "$M/b74.md"
mutate "$RM" "$M/b75.md" "\`[inferred]\` canvas: Objectives O-2 — measurement ground" "—"
neg "roadmap: a row that cites no ground"         B75 --roadmap "$M/b75.md"
mutate "$RM" "$M/b75b.md" "\`[inferred]\` canvas: Objectives O-2 — measurement ground" "\`[inferred]\`"
neg "roadmap: a Source cell of class tokens only" B75 --roadmap "$M/b75b.md"
mutate "$RM" "$M/b76.md" "| MVP | In delivery |" "| MVP → Phase 2 | In delivery |"
neg "roadmap: span notation in a Phase cell"      B76 --roadmap "$M/b76.md"
mutate "$RM" "$M/b77.md" "| Later | Defined | \`[inferred]\` canvas: Objectives O-2" "| Later | Planned | \`[inferred]\` canvas: Objectives O-2"
neg "roadmap: a status outside the vocabulary"    B77 --roadmap "$M/b77.md"
mutate "$CV" "$M/b78-canvas.md" "Notify the Specialist of bookings and cancellations" \
                                 "Export monthly ledgers to the finance office"
neg "roadmap: a canvas capability no epic covers" B78 --roadmap "$RM" --canvas "$M/b78-canvas.md"

# roadmap · T-18 side
mutate "$RM" "$M/b79.md" "### Allocation 2 — 2026-07-15" "### Allocation 3 — 2026-07-15"
neg "log: entry numbering not contiguous"         B79 --roadmap "$M/b79.md"
mutate "$RM" "$M/b80.md" "dependency order: measurement needs delivered booking volume first" \
                          "measurement needs delivered booking volume first"
neg "log: a reason with no factor tag"            B80 --roadmap "$M/b80.md"
mutate "$RM" "$M/b81.md" "Held: — (first run: all eight rows allocated) · Basis:" "Notes:"
neg "log: an entry with no Held and no Basis"     B81 --roadmap "$M/b81.md"
mutate "$RM" "$M/b82.md" "| E-08 Performance Reporting | Unallocated → Later" \
                          "| E-09 Loyalty Scheme | Unallocated → Later | risk: unproven demand |
| E-08 Performance Reporting | Unallocated → Later"
neg "log: allocation inventing an epic"           B82 --roadmap "$M/b82.md"
mutate "$RM" "$M/b83.md" "| E-08 | Performance Reporting | The network sees how booking is performing. Covers lost-booking, no-show, and utilisation views. | Later |" \
                          "| E-08 | Performance Reporting | The network sees how booking is performing. Covers lost-booking, no-show, and utilisation views. | MVP |"
neg "log: a Phase cell disagreeing with the log"  B83 --roadmap "$M/b83.md"

# the kit
mutate "$KIT" "$M/b84.md" "## C. Risks & assumptions to check" "## C. Risk register"
neg "kit: a part heading renamed"                 B84 --kit "$M/b84.md"
mutate "$KIT" "$M/b85.md" "   Why it matters: allocation and walking-skeleton sizing." ""
neg "kit: a question with no why-it-matters"      B85 --kit "$M/b85.md"
python3 - "$KIT" "$M/b86.md" <<'PY'
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
extra = "".join(
    f"\nQ{n} [destination: Essential Scope] [must-ask]\n"
    f"   A further scoping question {n}.\n"
    f"   Why it matters: it changes the launch capability list.\n"
    for n in range(7, 14))
t = t.replace("```\n\n## C. Risks", extra + "```\n\n## C. Risks", 1)
pathlib.Path(sys.argv[2]).write_text(t, encoding="utf-8")
PY
neg "kit: thirteen must-ask questions"            B86 --kit "$M/b86.md"
mutate "$KIT" "$M/b87.md" "Q5 [destination: Assumptions & Risks]" "Q5 [destination: NFR targets]"
neg "kit: a question at final-spec depth"         B87 --kit "$M/b87.md"
mutate "$KIT" "$M/b88.md" "                       [canvas: Customers]" ""
neg "kit: an uncited baseline line"               B88 --kit "$M/b88.md"
mutate "$KIT" "$M/b89.md" "   Walk me through how a booking happens today, end to end — where does" \
                           "   Walk me through the booking journey in processes.md — where does"
neg "kit: framework jargon in a question"         B89 --kit "$M/b89.md"

# the brief
mutate "$BRIEF" "$M/b90.md" "## 7. Captured Detail (for Tier 2)" "## 7. Captured Detail"
neg "brief: a section heading renamed"            B90 --brief "$M/b90.md"
mutate "$BRIEF" "$M/b91.md" "Status: Scoped" "Status: Final"
neg "brief: a status outside Draft|Scoped"        B91 --brief "$M/b91.md"
mutate "$BRIEF" "$M/b92.md" "### Deferred — this epic, later" "Deferred items:"
neg "brief: §3 missing a sub-heading"             B92 --brief "$M/b92.md"
mutate "$BRIEF" "$M/b93.md" "| canvas → confirmed on call |" "|  |"
neg "brief: an unsourced assumption row"          B93 --brief "$M/b93.md"
mutate "$BRIEF" "$M/b94.md" "| F1 | Open | blocked on R1 |" "| F1 | Pending | blocked on R1 |"
neg "brief: an open-question status off D4"       B94 --brief "$M/b94.md"
mutate "$BRIEF" "$M/b95.md" "| distinct primary role (Specialist); distinct journey | Proposed |" \
                             "| distinct primary role (Specialist); distinct journey | Draft |"
neg "brief: a slicing status off D5"              B95 --brief "$M/b95.md"
mutate "$BRIEF" "$M/b96.md" "| constraints.md | 2026-07-14 |" "| constraints.md |  |"
neg "brief: a routing row with no date"           B96 --brief "$M/b96.md"
mutate "$BRIEF" "$M/b97.md" "- Book an available slot" "- As a Client, I want to book an available slot"
neg "brief: a user story in Essential Scope"      B97 --brief "$M/b97.md"

# the tier-2 session
mutate "$ANS" "$M/b98.md" "GQ3 of 7 — [legality:" "GQ3 — [legality:"
neg "tier 2: a packet head off-grammar"           B98 --spec "$R5" --answers "$M/b98.md" --brief "$BRIEF"
python3 - "$ANS" "$M/b99.md" <<'PY'
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
extra = "".join(
    f"\n## GQ{n} — a further gap\n\n```\nGQ{n} of 7 — [legality: resolves marker M{n}]\n"
    f"           [destinations: BR-001]\n```\n\n**Answer — confirms.** A value.\n"
    for n in range(5, 9))
t = t.replace("\n---\n\n## Not asked", extra + "\n---\n\n## Not asked", 1)
pathlib.Path(sys.argv[2]).write_text(t, encoding="utf-8")
PY
neg "tier 2: asking past the cap"                 B99 --spec "$R5" --answers "$M/b99.md" --brief "$BRIEF"
mutate "$ANS" "$M/b100.md" \
  "GQ4 of 7 — [legality: resolves marker on the Hold duration; feeds CC-DA-02" \
  "GQ4 of 7 — [legality: the Hold duration needs pinning; feeds the fields table"
mutate "$M/b100.md" "$M/b100.md" "            (fields table) and CC-FL-03 (E1 row)]" "            and the E1 row]"
neg "tier 2: a legality field with no anchor"     B100 --spec "$R5" --answers "$M/b100.md" --brief "$BRIEF"
mutate "$R5" "$M/b101.md" "FR-003 (US1)" "FR-013 (US1)"
neg "tier 2: an answer that landed nowhere"       B101 --spec "$M/b101.md" --answers "$ANS" --brief "$BRIEF"
mutate "$R5" "$M/b102.md" \
  "[NEEDS CLARIFICATION: what becomes of a confirmed Appointment while calendar sync is unavailable? — brief E-03 OQ-2 / R1, provider contract unsigned]" \
  "[NEEDS CLARIFICATION: the calendar-sync failure expectation]"
neg "tier 2: a marker naming no location"         B102 --spec "$M/b102.md" --answers "$ANS" --brief "$BRIEF"
mutate "$BRIEF" "$M/b103.md" "| Answered — 2026-07-16 → spec 004 BR-001 (cap: 3) | resolved at Tier 2 |" \
                              "| Open | resolved at Tier 2 |"
neg "tier 2: an answered question with no write-back" B103 --spec "$R5" --answers "$ANS" --brief "$M/b103.md"

# ── 6. /ba-run dispatch — the interface, both ends ───────────────────────────

printf '\n▸ /ba-run dispatch: the interface the four skills implement (P-O3)\n'

has "$RUN" "thin alias for" "ba-run forwards a catalogue technique to its own one-step command"
has "$RUN" "execute it as the procedure" "…by reading the technique's skill file, re-checking nothing"

# WS-2 (D-O31 · D-O34): the same file gained two forms above the alias — the
# route runner and the batch spec driver. Both run *these* skills, so the
# interface this section holds down is now what they dispatch into.
has "$RUN" "Route runner (no argument)" "ba-run runs the composed plan as a route (§7.5)"
has "$RUN" "Never stop between rows for acknowledgement" \
    "…without an acknowledgement between rows (§10.1 checkpoint law)"
has "$RUN" "Batch spec driver" "ba-run drives batch Band-3 entry (§8.4)"
has "$RUN" "each run writing its own \`## Band 3\` run-log line" \
    "…and the batch keeps Tier 2's per-feature run-log line intact"
has "$TI2" "\`/ba-run specs all\`" "Tier 2 names the batch path that drives it"
has "$TI2" "run-log line included" "…and says its own per-feature run is unchanged there"
has "$T17" "append under \`## Band 2\`" "T-17 books its own run under the ## Band 2 section"
has "$T18" "append under \`## Band 2\`" "T-18 books its own run there too, each rerun naming its trigger"
has "$TI1" "append under \`## Band 2\`" "Tier 1 books its own run under ## Band 2"
# Re-pinned at 0.1.9 (dashboard v2, S4 — run-log under-recording). Was:
#   TI1 "<date> · <CODE> · contract:"   — one line per technique
#   TI2 "no plans-file line"            — Band-3 runs booked nothing
# §7.3 owes a contract-fulfillment line for every run, and §10.4's
# ledger-coverage line reads the log epic by epic and feature by feature — a
# line that names no element cannot be read that way. Forward-only: no
# historical entry was reconstructed, and the fixture is untouched, which is
# why it still renders the divergence the line exists to show.
has "$TI1" "the line names its epic" "…one line per mode per epic, the element named"
has "$TI2" "append under \`## Band 3\`" "Tier 2 books its own run under ## Band 3"
has "$TI2" "the line names its feature" "…one line per feature, the element named"
has "$TI2" "Append forward only" "…and never reconstructs a run it did not log"
has "$TI2" "P-O9 — overflow ruling" "the Tier-2 run takes its own overflow ruling in the same sitting"

# WS-3: under a standing autonomy grant the same ruling has exactly one legal
# outcome. The two it must refuse are the two that would let a run rewrite its
# own terms — enlarge its budget, or take on debt the BA never saw.
has "$TI2" "takes **the supplement lane, and only that lane**" \
    "…and under a grant it takes the supplement lane, and only that lane (D-O39)"
has "$TI2" "Never cap adjust — a run must not enlarge its own budget." \
    "…never cap adjust: a run may not enlarge its own budget"
has "$TI2" "Never defer — deferring is debt the BA takes knowingly." \
    "…never defer: that debt is the BA's to take"
has "$TI2" '<date> · AUTO (AG-<n>) · <act> · <basis>' \
    "…and the supplement act carries the AUTO stamp"
for s in t17 t18 tier1 tier2; do
  has "$SKILLS/ba-$s/SKILL.md" "BA-invoked, never auto-fired" "ba-$s refuses to auto-fire"
  has "$SKILLS/ba-$s/SKILL.md" "is the one-step entry" "…and is entered in one step, by its own command"
  has "$SKILLS/ba-$s/SKILL.md" "## At run end — compiled bookkeeping" "…with its bookkeeping compiled in"
  grep -q '^disable-model-invocation: true$' "$SKILLS/ba-$s/SKILL.md" \
    && ok "…and enforces it in frontmatter" \
    || bad "ba-$s lacks disable-model-invocation: true"
  has "$SKILLS/ba-$s/SKILL.md" "Self-check, and stop if" "ba-$s runs the P-O3 self-check before anything else"
  # D82, ruled 15 Aug 2026: the pair sits in the replaced paragraph's own
  # position — before the skip-if, as t01–t16 carry it — and exactly once.
  python3 - "$SKILLS/ba-$s/SKILL.md" <<'PY' && ok "…and its pass/miss pair stands once, ahead of any skip-if (D82)" \
    || bad "ba-$s's pass/miss pair is doubled or trails its skip-if (D82)"
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
if t.count("**On a pass**") != 1 or t.count("**On a miss**") != 1:
    sys.exit(1)
sys.exit(0 if "**Skip-if" not in t
         or t.index("**On a pass**") < t.index("**Skip-if") else 1)
PY
done
has "$TI1" "/ba-tier1 <mode> <epic>" "ba-tier1 names its own invocation, modes included"
has "$T17" "unblocks — \`/ba-aspect band2\` to compose the Band-2 plan" \
    "ba-t17's on-miss act resolves — the seventh argument, not a bare command (D-O55)"
has "$T18" "unblocks — \`/ba-aspect band2\` to compose the Band-2 plan, or \`/ba-close-band1\` where Band 1 does not yet stand closed" \
    "ba-t18's on-miss act resolves, its closure tail kept (D-O55)"
has "$TI1" "unblocks — \`/ba-aspect band2\` to compose the Band-2 plan" \
    "ba-tier1's on-miss act resolves (D-O55)"
has "$TI2" "/ba-tier2 <feature>" "ba-tier2 names its own invocation"
has "$TI2" "name \`/ba-enter-feature <epic>/<feature>\`" "…and hands back to P-O8 when entry has not happened"
has "$TI2" "name \`/ba-gate <feature>\`" "…and hands to the gate at the end, without running it"

# ── 7. the compiled sheets' locked content ───────────────────────────────────

printf '\n▸ The compiled sheets: depth boundaries, refusals, the writer split\n'

# T-17: question-free, no phases, no slicing
has "$T17" "This run is question-free." "T-17 is question-free — the estate is the input"
has "$T17" "one epic = one scoping call and 1..N features" "…and carries the sizing test verbatim"
has "$T17" "A probe is a recall check against estate evidence, never a generator" \
    "…and states the probe posture in its operative step"
has "$T17" "letting a probe generate a row." \
    "…and again in prohibition form, on the depth boundary"
has "$T17" "Every Source citation carries its ground-class." \
    "T-17 writes the Source ground-class it owns"
has "$T17" "Both classes are legal rows." \
    "…with both classes legal — coverage-complete untouched by the class"
has "$T17" "A row is \`inferred\` only when every one of its citations is; a single \`[stated]\` citation makes the row \`stated\`." \
    "…and the row-level roll-up that makes the class mechanically readable"
has "$T17" "never writes the Phase column beyond the birth value" "…never writes T-18's column"
has "$T17" "Capability *placement* is epic grain here; capability *slicing* is the brief's." \
    "…and states the placement-vs-slicing line"
hasnt "$T17" "draft the user stories" "T-17 does not descend to story drafting"

# T-18: the four factors, the no-change log, Later is a phase
has "$T18" "MVP composes the thinnest end-to-end slice of the core value journey" \
    "T-18 carries the walking-skeleton rule verbatim"
has "$T18" "Every approved run logs, including no-change" "…and logs a no-change rerun"
has "$T18" "\`Later\` is a phase, not an exit" "…and refuses to phase an epic out of existence"
has "$T18" "Never numeric estimation" "…and keeps effort comparative"
has "$T18" "recommends the call — never the answer" "…and refers an open scope question to Tier 1"
has "$T18" "\`[inferred]\` rows inside the boundary are the advisory's first-named candidates — first-named, never disqualified:" \
    "T-18's advisory reads the class — first-named, and never disqualified by it"
has "$T18" "the composition half of **principle 4**" \
    "…citing the anchor rather than restating it"

# T-18: the SD consumption (D-B6-12 · D-B6-13), and the ledger read it rides
has "$T18" "\`Scope decisions:\`" "T-18 reads the scope-decision head line"
has "$T18" "ground the four locked factors read, **never a fifth factor**" \
    "…as ground the four locked factors read, never a fifth factor"
has "$T18" "BA-directed (SD-<n>)" "…and the diff carries the SD-sourced tag"
has "$T18" "They pin only on the step-4 approval" \
    "…pinning only on the BA's approval — the framework proposes, the BA disposes"
has "$T18" "not phase-shaped routes as bucket 2" \
    "…a non-phase-shaped SD routes to bucket 2"
has "$T18" "off-vocabulary phase is **bucket 3**" \
    "…an unknown epic or off-vocabulary phase to bucket 3, named and never skipped"
has "$T18" "no new trigger token exists" "…riding the existing scope-frame trigger"
has "$T18" "no longer satisfies the second test" \
    "T-18's advisory applies the SD reading rule — the earlier citation stops sufficing"
has "$T18" "first-named advisory candidate" "…the trimmed epic first-named…"
has "$T18" "never disqualified" "…and never disqualified by it"
has "$T18" "elicitation principle 4" "…citing the controlling-statement law, never restating it"

# the precedence principle is stated once, at the orchestrator — cited here
has "$T18" "D-O66" "T-18 cites the precedence principle rather than restating it"
hasnt "$T18" "governs **allocation**, never discovery" \
    "…and does not restate it — one statement, at its own site"

# T-18: the advisory becomes a decision (D-B6-14 · D-B6-15)
has "$T18" "The advisory is a decision list, not prose" \
    "T-18's advisory renders as a decision list, never as prose"
has "$T18" "\`ADV-<n>\`" "…each finding taking its id from the orchestrator's register"
has "$T18" "P-A1 row shape" "…in the P-A1 row shape, cited and never restated"
hasnt "$T18" "Rulings: apply all · apply all except" \
    "…and the shape is not restated — one shape, at the source-audit definition"
has "$T18" "hold as advisory — no move" \
    "…disposition (a), the default that makes \`apply all\` safe"
has "$T18" "never an inline phase edit" \
    "…disposition (b) pinned in the diff, never an inline phase edit"
has "$T18" "SA record pattern" \
    "…disposition (c) on the SA record pattern, with its revisit trigger"
has "$T18" "no disposition ends a finding without a reason" \
    "…and no disposition ends a finding without a reason"
has "$T18" "The step-4 approval carries the scope-advisory decision list" \
    "…ruled at the step-4 approval, the run's existing BA act"
has "$T18" "No second stop exists" "…with no second stop and no new prompt point"
has "$T18" "assembling it may be AUTO, ruling it never is" "…assembly may be AUTO, the ruling never"
has "$T18" "BA-directed (ADV-<n>)" "…and the §5 Reason tag set gains its third value"
has "$SKILLS/ba-t18/references/example.md" "BA-directed (ADV-<n>)" \
    "…carried into the worked example's row grammar"

# T-18: the acceptance cross-check (D-B6-16 · D-B6-17) — the advisory's third
# reading rule.  D-B6-16 puts the `Acceptance shapes:` line in the step-2
# evidence read as GROUND, never a fifth factor — the D-B6-12 pattern exactly;
# D-B6-17 makes the deferral answer to it, findings entering the list D-B6-14
# already built.  The record half is check-band2-artifacts.py's B105, live below.
has "$T18" "\`Acceptance shapes:\`" "T-18 reads the acceptance-shape head line (D-B6-16)"
has "$T18" "the same class of ground" \
    "…as the same class of ground the SD line is — read by the factors, never added to them"
has "$T18" "never added to them" "…an AS-<n> never becoming a fifth factor"
has "$T18" "The acceptance cross-check" \
    "T-18's advisory carries the cross-check as its third reading rule (D-B6-17)"
for CLAUSE in "allocated or held outside the" "slide-down candidate" \
              "standing \`out-of-scope.md\` fence row"; do
  has "$T18" "$CLAUSE" "…checking every deferring row: $CLAUSE"
done
has "$T18" "\`BA-directed (SD-<n>)\`** trim" \
    "…checking every deferring row: every BA-directed (SD-<n>) trim"
has "$T18" "against the head's" "…against the head's standing AS entries"
has "$T18" "cites **both sides verbatim**" \
    "…the finding citing both sides verbatim — the item and the deferring record"
has "$T18" "tagged **\`(AS-<n>)\`** beside its \`ADV-<n>\` id" \
    "…tagged (AS-<n>) beside its ADV-<n> id"
has "$T18" "dispositions are the
     existing three" "…ruled with the existing three dispositions, no new one"
has "$T18" "fires nothing" \
    "…a superseded or accepted entry firing nothing — surfaced once and ruled"
has "$T18" "the standing backstop is the
     gate's **CC-H-07**" "…with the gate's CC-H-07 the standing backstop"
hasnt "$T18" "No act that postpones or excludes scope completes" \
    "…and the principle is not restated — one statement, at the frame surface"


# ── T-18 · the SD run, seeded both ways ──────────────────────────────────────
#
# The sheet is prose, so the seeded fixtures are allocation logs: the shape a
# compliant SD-driven run writes, and the `none found` run that must behave
# exactly as it did before the ruling (the regression guard).

printf '\n▸ T-18 · the SD run — seeded fixtures, both directions\n'

seed_roadmap() {   # $1 destination · $2 epic id · $3 new phase · $4 log entry
  mkdir -p "$(dirname "$1")"
  python3 - "$RM" "$1" "$2" "$3" "$4" <<'PYSEED'
import sys, pathlib
src, dst, eid, phase, entry = sys.argv[1:6]
lines = pathlib.Path(src).read_text(encoding="utf-8").splitlines()
out = []
for line in lines:
    # the epic table's Phase column follows the log (B83); an unknown epic is
    # left alone on purpose, so the invented-epic defect still reaches B82.
    if line.startswith("| %s |" % eid):
        cells = line.split("|")
        cells[4] = " %s " % phase
        line = "|".join(cells)
    out.append(line)
out.append("")
out.append(entry)
pathlib.Path(dst).write_text("\n".join(out) + "\n", encoding="utf-8")
PYSEED
}

# (i) the clean SD run — a confirmed SD-sourced candidate, tagged in the diff
seed_roadmap "$TMP/sd/roadmap.md" E-07 Later '### Allocation 3 — 2026-08-19 · trigger: scope-frame · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | Phase 2 → Later | BA-directed (SD-1): the agreed scope list drops online payment from the paid engagement (sources/brief.md §4) |

Held: the remaining rows stand · Basis: the SD bounds allocation, not discovery — E-07 stays a cited epic row.'
if python3 "$VALIDATE" --roadmap "$TMP/sd/roadmap.md" --canvas "$CV" \
     > "$TMP/sd.out" 2>&1; then
  ok "seeded clean: a \`BA-directed (SD-1)\` diff row passes the log grammar"
else
  bad "the SD-tagged allocation row was rejected by the validator"
  sed 's/^/      /' "$TMP/sd.out"
fi

# (ii) the regression guard — `Scope decisions: none found` changes nothing.
#      The pre-ruling log entry must validate exactly as it did before.
seed_roadmap "$TMP/none/roadmap.md" E-07 Later '### Allocation 3 — 2026-08-19 · trigger: priority shift · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | Phase 2 → Later | value vs. effort: no payment surface is needed for O-2 at launch |

Held: the remaining rows stand · Basis: the picture holds across the four factors.'
if python3 "$VALIDATE" --roadmap "$TMP/none/roadmap.md" --canvas "$CV" \
     > "$TMP/none.out" 2>&1; then
  ok "seeded clean: the factor-tagged run is untouched by the ruling — the regression guard holds"
else
  bad "the pre-ruling allocation row stopped validating — the ruling was not additive"
  sed 's/^/      /' "$TMP/none.out"
fi

# (iii) the seeded defect — an untagged reason, neither factor nor BA-directed
printf '\n  seeded-defect control:\n'
seed_roadmap "$TMP/bad/roadmap.md" E-07 Later '### Allocation 3 — 2026-08-19 · trigger: scope-frame · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | Phase 2 → Later | the client asked for it |

Held: the remaining rows stand · Basis: none stated.'
if python3 "$VALIDATE" --roadmap "$TMP/bad/roadmap.md" --canvas "$CV" \
     > "$TMP/bad.out" 2>&1; then
  bad "an untagged allocation reason passed the validator — B80 does not bite"
else
  grep -q "B80" "$TMP/bad.out" \
    && ok "seeded defect caught by name: B80 — an untagged allocation reason" \
    || { bad "the untagged reason failed, but not as B80"; sed 's/^/      /' "$TMP/bad.out"; }
fi

# (iv) the seeded defect — an SD tag on a row whose epic is not on the roadmap
seed_roadmap "$TMP/bad2/roadmap.md" E-99 MVP '### Allocation 3 — 2026-08-19 · trigger: scope-frame · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-99 Loyalty Programme | Unallocated → MVP | BA-directed (SD-2): the agreed module list names it (sources/brief.md §4) |

Held: the remaining rows stand · Basis: the SD bounds allocation, not discovery.'
if python3 "$VALIDATE" --roadmap "$TMP/bad2/roadmap.md" --canvas "$CV" \
     > "$TMP/bad2.out" 2>&1; then
  bad "an SD-tagged row invented an epic and passed — allocation never creates an epic"
else
  grep -q "B82" "$TMP/bad2.out" \
    && ok "seeded defect caught by name: B82 — an SD tag does not license a new epic" \
    || { bad "the invented epic failed, but not as B82"; sed 's/^/      /' "$TMP/bad2.out"; }
fi

# ── T-18 · the ADV run, seeded both ways ─────────────────────────────────────
#
# D-B6-15's tag is the only thing joining a moved row back to the finding that
# moved it, so it is proven the same way the SD tag was: the compliant row must
# validate, and an advisory-driven move that dropped the tag must fail by name.

printf '\n▸ T-18 · the ADV run — the tag survives into the log (D-B6-15)\n'

# (v) the clean ADV run — a `direct a move` disposition, tagged in the diff
seed_roadmap "$TMP/adv/roadmap.md" E-07 "Phase 2" '### Allocation 3 — 2026-08-19 · trigger: scope-frame · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | MVP → Phase 2 | BA-directed (ADV-1): no legitimacy trace inside the boundary; the BA directed the move at the step-4 approval |

Held: the remaining rows stand · Basis: the advisory named it, the BA ruled it — visibility, never a block.'
if python3 "$VALIDATE" --roadmap "$TMP/adv/roadmap.md" --canvas "$CV" \
     > "$TMP/adv.out" 2>&1; then
  ok "seeded clean: a \`BA-directed (ADV-1)\` diff row passes the log grammar"
else
  bad "the ADV-tagged allocation row was rejected by the validator"
  sed 's/^/      /' "$TMP/adv.out"
fi

# (vi) the seeded defect — an advisory-driven move that carries no tag at all
printf '\n  seeded-defect control:\n'
seed_roadmap "$TMP/advbad/roadmap.md" E-07 "Phase 2" '### Allocation 3 — 2026-08-19 · trigger: scope-frame · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | MVP → Phase 2 | ADV-1: the advisory named it and the BA moved it |

Held: the remaining rows stand · Basis: none stated.'
if python3 "$VALIDATE" --roadmap "$TMP/advbad/roadmap.md" --canvas "$CV" \
     > "$TMP/advbad.out" 2>&1; then
  bad "an untagged ADV move passed the validator — the tag is what joins the row to the finding"
else
  grep -q "B80" "$TMP/advbad.out" \
    && ok "seeded defect caught by name: B80 — an untagged ADV move" \
    || { bad "the untagged ADV move failed, but not as B80"; sed 's/^/      /' "$TMP/advbad.out"; }
fi

# ── T-17 · the language obligation's unit (D-O74 — owner ruling Р8) ──────────
#
# EC-01's field case, at the surface that either carries it or loses it: a
# stated non-English or multi-language obligation MUST materialize as one
# dedicated localization epic. The register names what fired; the roadmap is
# where the unit stands or does not. B104 judges the epic half — the story half
# is Tier 2's, and the bound is stated in the validator's own docstring.

printf '\n▸ T-17 · the language obligation carries as its own epic (D-O74)\n'

# the sheet's own text — the compiled rule the run follows
has "$T17" "one dedicated localization epic" \
    "T-17 compiles the unit form: one dedicated localization epic"
has "$T17" "Never only a register line, a mark, an open question or a comment" \
    "…never only a register line, a mark, a question or a comment"
has "$T17" "carried — <the epic>" "…and records the register state the epic satisfies"
has "$T17" "coverage-complete and the exclusive partition stand untouched" \
    "…with coverage-complete untouched by construction — carry, not breadth"
has "$T17" "Language-only by ruling" "…and the law bounded to the language class"
has "$T17" "read-only" "…the register joining T-17's inputs read-only, never edited here"

FR="$TMP/frames"; mkdir -p "$FR"
XO_DEF='Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default'

# (vii) the clean run — the obligation fired and an epic on the roadmap carries it
printf '%s · XO-2 — language: Ukrainian + English UI (sources/brief.md §4) — carried — E-07 Online Payment\n' \
  "$XO_DEF" > "$FR/carried.md"
if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" --frame "$FR/carried.md" \
     > "$TMP/xo-carried.out" 2>&1; then
  ok "seeded clean: a fired obligation whose \`carried — <unit>\` resolves to a row passes"
else
  bad "a carried language obligation was rejected"; sed 's/^/      /' "$TMP/xo-carried.out"
fi

# (viii) the recorded decline — `accepted — <reason>` is a record, never a defect
printf '%s · XO-2 — language: Ukrainian UI (sources/brief.md §4) — accepted — client defers localization to phase 2 — revisit: phase-2 sign-off\n' \
  "$XO_DEF" > "$FR/accepted.md"
if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" --frame "$FR/accepted.md" \
     > "$TMP/xo-acc.out" 2>&1; then
  ok "…and a BA who declines the unit records \`accepted — <reason>\`, which is legal"
else
  bad "an accepted decline was treated as a defect"; sed 's/^/      /' "$TMP/xo-acc.out"
fi

# (ix) the regression guard — the English default alone changes nothing
printf '%s\n' "$XO_DEF" > "$FR/default.md"
if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" --frame "$FR/default.md" \
     > "$TMP/xo-def.out" 2>&1; then
  ok "…and a register holding only the English default asks the roadmap for nothing"
else
  bad "the English default demanded an epic — the ruling is not additive"
  sed 's/^/      /' "$TMP/xo-def.out"
fi

printf '\n  seeded-defect control:\n'

# (x) the seeded defect — a stated non-English language that produced no unit
printf '%s · XO-2 — language: Ukrainian + English UI (sources/brief.md §4) — captured\n' \
  "$XO_DEF" > "$FR/uncarried.md"
if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" --frame "$FR/uncarried.md" \
     > "$TMP/xo-bad.out" 2>&1; then
  bad "a stated language obligation reached export with no spec unit and passed — EC-01's own loss"
else
  grep -q "B104" "$TMP/xo-bad.out" \
    && ok "seeded defect caught by name: B104 — a stated non-English language that produced no spec unit" \
    || { bad "the uncarried obligation failed, but not as B104"; sed 's/^/      /' "$TMP/xo-bad.out"; }
fi

# (xi) the seeded defect — a carrier the roadmap does not hold
printf '%s · XO-2 — language: Ukrainian UI (sources/brief.md §4) — carried — E-42 Localization\n' \
  "$XO_DEF" > "$FR/ghost.md"
if python3 "$VALIDATE" --roadmap "$RM" --canvas "$CV" --frame "$FR/ghost.md" \
     > "$TMP/xo-ghost.out" 2>&1; then
  bad "the register named a unit no epic row holds and it passed — \`carried\` would mean nothing"
else
  grep -q "B104" "$TMP/xo-ghost.out" \
    && ok "seeded defect caught by name: B104 — \`carried\` naming a unit the roadmap does not hold" \
    || { bad "the ghost carrier failed, but not as B104"; sed 's/^/      /' "$TMP/xo-ghost.out"; }
fi


# ── T-18 · the acceptance cross-check's record, live (D-O79 · D-B6-17) ──────
#
# B105's two halves against the fixture roadmap. The frame supplies the
# `Boundary:` line and the `Acceptance shapes:` register; the roadmap supplies
# the deferrals and the log. E-07 Online Payment sits at Phase 2 — outside an
# MVP boundary — which is the pair the seeded defects turn on.

printf '\n▸ T-18 · the deferral answers to the acceptance shape (D-O79 · D-B6-17)\n'

AS_FR="$TMP/asframes"; mkdir -p "$AS_FR"
as_frame() {   # $1 → file, $2 → the Acceptance shapes: line value
  printf 'Boundary: MVP — set 2026-07-07 (P-O0b)\n%s\nAcceptance shapes: %s\n' \
    "$XO_DEF" "$2" > "$1"
}
as_frame "$AS_FR/standing.md" 'AS-1 — payment taken at booking (rfp.md §9) — standing'
as_frame "$AS_FR/superseded.md" 'AS-1 — payment taken at booking (rfp.md §9) — superseded — SD-2'
as_frame "$AS_FR/unrelated.md" 'AS-1 — booking works end-to-end (rfp.md §9) — standing'

AS_RM="$TMP/asroadmaps"; mkdir -p "$AS_RM"
python3 - "$RM" "$AS_RM" <<'PYX'
import pathlib, sys
src, out = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
t = src.read_text(encoding="utf-8")
row = ("| E-07 Online Payment | Unallocated → Phase 2 | value vs. effort: no payment "
       "surface needed for O-2 at launch; integration-heavy; phase hint carried from "
       "the graduated out-of-scope row |")
assert row in t, "the E-07 log row moved — the B105 fixtures need re-aiming"
ruled = ('| E-07 Online Payment | Unallocated → Phase 2 | BA-directed (ADV-1) (AS-1): the '
         'acceptance list requires "payment taken at booking" (rfp.md §9) against the '
         'deferral "payments deferred — graduated this run" (out-of-scope.md); held as '
         'advisory — no move |')
half = ('| E-07 Online Payment | Unallocated → Phase 2 | BA-directed (ADV-1) (AS-1): the '
        'acceptance list requires payment at booking; held as advisory — no move |')
ghost = ('| E-07 Online Payment | Unallocated → Phase 2 | BA-directed (ADV-1) (AS-9): the '
         'acceptance list requires "payment taken at booking" (rfp.md §9) against the '
         'deferral "payments deferred" (out-of-scope.md); held as advisory — no move |')
for name, r in (("ruled", ruled), ("half", half), ("ghost", ghost)):
    (out / ("%s.md" % name)).write_text(t.replace(row, r), encoding="utf-8")
PYX

# (xii) the clean run — the conflict surfaced, cited both sides, and ruled
if python3 "$VALIDATE" --roadmap "$AS_RM/ruled.md" --frame "$AS_FR/standing.md" \
     > "$TMP/as-ruled.out" 2>&1; then
  ok "seeded clean: a deferral over a standing entry, named and cited on both sides, passes"
else
  bad "a ruled conflict was rejected"; sed 's/^/      /' "$TMP/as-ruled.out"
fi

# (xiii) the supersession law — surfaced once and ruled, so nothing fires again
if python3 "$VALIDATE" --roadmap "$RM" --frame "$AS_FR/superseded.md" \
     > "$TMP/as-sup.out" 2>&1; then
  ok "…and an entry standing \`superseded — SD-<n>\` fires nothing, the log silent"
else
  bad "a superseded entry still demanded a finding — the supersession law is not applied"
  sed 's/^/      /' "$TMP/as-sup.out"
fi

# (xiv) the regression guard — a standing entry no deferral touches asks nothing
if python3 "$VALIDATE" --roadmap "$RM" --frame "$AS_FR/unrelated.md" \
     > "$TMP/as-un.out" 2>&1; then
  ok "…and a standing entry no deferred row answers to leaves the roadmap alone"
else
  bad "the cross-check fired on a pair that does not meet"; sed 's/^/      /' "$TMP/as-un.out"
fi

printf '\n  seeded-defect control:\n'

# (xv) the seeded defect — the deferral completes silently against a standing entry
if python3 "$VALIDATE" --roadmap "$RM" --frame "$AS_FR/standing.md" \
     > "$TMP/as-silent.out" 2>&1; then
  bad "a row deferred over a standing acceptance entry passed with the log silent — EC-02's own loss"
else
  grep -q "B105" "$TMP/as-silent.out" \
    && ok "seeded defect caught by name: B105 — a deferral conflicting a standing entry, no named finding" \
    || { bad "the silent deferral failed, but not as B105"; sed 's/^/      /' "$TMP/as-silent.out"; }
fi

# (xvi) the seeded defect — an AS-tagged finding citing only one side
if python3 "$VALIDATE" --roadmap "$AS_RM/half.md" --frame "$AS_FR/standing.md" \
     > "$TMP/as-half.out" 2>&1; then
  bad "a finding citing one side passed — \`cites both sides verbatim\` would mean nothing"
else
  grep -q "B105" "$TMP/as-half.out" \
    && ok "seeded defect caught by name: B105 — an AS-tagged finding missing its verbatim citation pair" \
    || { bad "the half-cited finding failed, but not as B105"; sed 's/^/      /' "$TMP/as-half.out"; }
fi

# (xvii) the seeded defect — a tag naming an entry the head does not hold standing
if python3 "$VALIDATE" --roadmap "$AS_RM/ghost.md" --frame "$AS_FR/standing.md" \
     > "$TMP/as-ghost.out" 2>&1; then
  bad "a finding tagged with an entry the head never held passed — the tag joins nothing"
else
  grep -q "B105" "$TMP/as-ghost.out" \
    && ok "seeded defect caught by name: B105 — a tag naming no standing entry" \
    || { bad "the ghost tag failed, but not as B105"; sed 's/^/      /' "$TMP/as-ghost.out"; }
fi


# the writer split, stated on both sides
has "$T17" "one file, three writers" "T-17 states the shared-file write discipline"
has "$T18" "one file, three writers" "…and so does T-18, from its own side"
has "$T18" "proposes that run or a routed edit — never an inline fix" "…with the no-inline-fix rule"
has "$T17" "The ground-class travels there too: you write it, and T-18 — Scope allocation only reads it." \
    "…and the class falls on T-17's side of the split, read-only on T-18's"

# Tier 1: the two guards, verbatim, and the caps
has "$TI1" "If you can cite a source line, the question is illegal — cite the line in the
> draft instead." "Tier 1 carries the Citation Test verbatim"
has "$TI1" "answer's primary destination is a **scope-brief decision section**" \
    "…and the Destination Test verbatim"
has "$TI1" "must-ask ≤ 12" "…and D1's cap"
has "$TI1" "Volunteered ≠ solicited." "…and the volunteered-versus-solicited rule"
has "$TI1" "\`Overtaken — <reason>\`" "…and D4's third status, reason mandatory"
has "$SKILLS/ba-tier1/references/destination-test.md" \
    "What is the exact cutoff for free cancellation" "the five depth pairs ship as a reference"
has "$SKILLS/ba-tier1/references/routing.md" "governance change: proposed, never silently written" \
    "the routing table ships, with the governance rule on it"

# Tier 2: the legality rule, the cap, the confidence rule
has "$TI2" "closes a named would-be
> contract failure" "Tier 2 carries D6's legality rule"
has "$TI2" "7 per feature by default, BA-adjustable per feature" "…and D7's cap"
has "$TI2" "is drafted **and marked**" "…and the confidence rule"
has "$TI2" "It is a thin brief." "…and diagnoses overflow as a thin brief, not a long interrogation"
has "$TI2" "governance wins always" "…and holds the definitions precedence"
has "$TI2" "Composed against the brief and nothing beyond it (principle 4)" \
    "…and composes the story set against the brief's essential scope, and stops"
has "$TI2" "routes to the brief's **Deferred** section" \
    "…routing an adjacent capability to Deferred, never into a story"
has "$TI2" "assumptions fill unknowns *inside* the essential scope; they never widen it" \
    "…and carries the Presale anti-completion corollary"
has "$SKILLS/ba-tier2/references/story-drafting.md" "goes to the brief's **Deferred** section" \
    "the story module names the same destination at the moment adjacency appears"
has "$SKILLS/ba-tier2/references/story-drafting.md" "the role is verbatim from the governance file" \
    "the story module hardens the role rule"
has "$SKILLS/ba-tier2/references/story-drafting.md" "never silent scope" \
    "…and excludes the ungrounded-enhancement behavior"

# the tier boundary, from both sides
has "$TI2" "Tier 2 fills gaps; it does not re-run discovery" "Tier 2 states the tier boundary"
has "$TI1" "Tier 2 fills gaps; it does not re-run discovery" "…and Tier 1 states it identically"

# ── 8. the analyst agent, and the persona boundaries ─────────────────────────

printf '\n▸ ba-analyst — the Tier-2 authoring persona, bounded against the other three\n'

grep -q '^name: ba-analyst$' "$ANALYST" && ok "the agent declares its name" || bad "ba-analyst frontmatter name"
grep -q '^tools: Read, Write, Edit, Grep, Glob$' "$ANALYST" \
  && ok "…and an authoring tool policy (no Bash: it runs no checker)" \
  || bad "ba-analyst tool policy is not the authoring set"
has "$ANALYST" "never author a discovery artifact" "the analyst never authors discovery ground"
has "$ANALYST" "You never evaluate your own spec" "…and never judges its own output"
has "$ANALYST" "Unmarked inference is the one failure no rule downstream catches" \
    "…and names the residual risk it owns"
has "$ANALYST" "The four operating principles, at spec depth" \
    "…heads its principle list at four, as the preamble now does"
has "$ANALYST" "Recorded breadth is welcome; composed breadth is debt." \
    "…and carries the anchor's pinned text at spec grain"
has "$ANALYST" "the §6 status write-back is your one permitted brief edit" \
    "…and its single permitted edit outside the spec"
has "$AGENTS/ba-discovery.md" "You never author a
\`spec.md\`" "the discovery BA still refuses to author a spec — the two personas do not overlap"
grep -q '^tools: Read, Grep, Glob$' "$AGENTS/ba-gate.md" \
  && ok "…and the gate agent stays read-only, so author and judge cannot be one actor" \
  || bad "the gate agent's read-only policy changed"

# ── 9. layering ──────────────────────────────────────────────────────────────

printf '\n▸ Layering — no methodology-layer content in the S8 payload (§0, §3.3)\n'

LEAK=0
for f in "$T17" "$T18" "$TI1" "$TI2" "$ANALYST" \
         "$SKILLS"/ba-t1{7,8}/references/example.md \
         "$SKILLS"/ba-tier1/references/*.md "$SKILLS"/ba-tier2/references/*.md; do
  [ -f "$f" ] || continue
  if grep -nE 'BABOK|mining note|Reference design|Review record \(|docs/methodology/[a-z]|D-B[0-9]-[0-9]|D-W[0-9]|D-P2-[0-9]' "$f" \
       > "$TMP/leak.txt" 2>/dev/null; then
    if [ -s "$TMP/leak.txt" ]; then
      bad "methodology-layer content in ${f#$PKG_ROOT/}:"
      sed 's/^/      /' "$TMP/leak.txt"; LEAK=1
    fi
  fi
done
[ "$LEAK" -eq 0 ] && ok "zero BABOK anchors, mining notes, review records or decision IDs in the S8 payload files"

# the validator is a harness, not a shipped checker
[ -f "$PKG_ROOT/payload/specify-overlay/ba/scripts/check-band2-artifacts.py" ] \
  && bad "the Band-2 validator leaked into the installed scripts" \
  || ok "the Band-2 validator stays repo-side: no runtime checker judges technique output"

# ── EC-18 · B6 — the role rule's two branches, cited not restated ───────────
#
# B6, verbatim: 16 draft specs were written with every role marked
# [NEEDS CLARIFICATION] at first use — 37 markers that vanished the moment T-12
# ran. Standard §3's rule and the module's hardening could not both govern a
# Presale draft. The standard is now the one home; both carriers cite it, and
# the drafting path that required a nonexistent roles-permissions.md is gone.

printf '\n▸ EC-18 — the role rule under a profile without the governance file (B6)\n'

SD="$SKILLS/ba-tier2/references/story-drafting.md"
TI2S="$SKILLS/ba-tier2/SKILL.md"

has "$SD" "**The role rule has two branches, and the standard's §3 is its one home**" \
    "story-drafting names the standard as the home and itself as the reader"
has "$SD" "the role is verbatim from the canvas Core Functions actors" \
    "…and the second branch takes the actor from the canvas"
has "$SD" "marked at its first use in the spec" \
    "…marked at first use, per rule 7"
has "$SD" "the marker is carried **once**, not re-stamped per" \
    "…and carried once, not re-stamped per story"
has "$SD" "and refusing to draft" \
    "…with refusing-to-draft named illegal beside inventing and softening"
has "$SD" "**This branch lifts nothing at the gate.**" \
    "…and the branch lifts nothing at the gate"
has "$SD" "Never delete a marker to make the assertion pass." \
    "…and a marker is never deleted to buy a pass"

has "$TI2S" "**Roles follow standard §3's two branches, and the module carries them.**" \
    "the Tier-2 skill cites the standard rather than restating the rule"
has "$TI2S" "**A missing governance file never stops the draft**" \
    "…and a missing governance file never stops the draft"

# the killed behaviour: neither carrier may state the absolute form alone
flat_has "$SD" "the role is verbatim from the governance file, or the story does not get written" \
  && bad "story-drafting still carries the absolute rule that made B6's 16 drafts illegal" \
  || ok "the absolute 'or the story does not get written' rule is gone"

# ── EC-18 · B7 — the Band-2 pair's declared preconditions ───────────────────

printf '\n▸ EC-18 — declared preconditions (T-17)\n'

has "$SKILLS/ba-t17/SKILL.md" "**Preconditions — declared, rendered, never a block.**" \
    "ba-t17 declares its preconditions"
has "$SKILLS/ba-t17/SKILL.md" "(**T-13 — Core process mapping**)" \
    "…naming the journeys' producer with its code and name"
has "$SKILLS/ba-t17/SKILL.md" "coverage-completeness and exclusive partition are properties of the Core Functions set and stand unchanged" \
    "…and the four soft absences cost candidates, never the coverage property"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S8 Band 2 + spine: T-17 · T-18 · Tier 1 · Tier 2 · ba-analyst · 42 seeded defects\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
