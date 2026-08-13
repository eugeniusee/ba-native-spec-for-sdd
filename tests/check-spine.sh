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

printf '\n▸ 34 seeded defects — the suite is not vacuous\n'

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
done
has "$TI1" "/ba-tier1 <mode> <epic>" "ba-tier1 names its own invocation, modes included"
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

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S8 Band 2 + spine: T-17 · T-18 · Tier 1 · Tier 2 · ba-analyst · 34 seeded defects\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
