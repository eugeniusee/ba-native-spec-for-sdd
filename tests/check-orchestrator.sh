#!/usr/bin/env bash
#
# BA-Native Spec — the orchestrator suite (build plan §4, S4 exit test).
#
# Build plan §4, S4 row: *orchestrator §12's three exhibits replayed on an empty
# fixture project: ledger heads/events land in §2.4 shape; P-O checkpoints
# render; the §8.2 reopen executes end to end.*
#
#   1. §12.1  the BA-planning loop — suggestion snapshot, composition with both
#             Q2+ contract paths, run log, and the routed finding landing in
#             Context's home while Context is still `untouched`
#   2. §12.2  the threshold cleared (T2) and Band-1 closure — the arming act
#   3. §12.3  RO-1 end to end — receive · rule Real · T5 · blast radius with no
#             cascade · resolution on the emitting batch · event-shaped deferral
#             · delta re-clear (T6) with AT-ST-1 carried
#   4.        the whole replay is grammar-legal under tests/check-ledger.py
#   5.        14 seeded defects, one per rule — the suite is not vacuous
#   6.        the nine P-O checkpoints render, with their refusals and locked
#             vocabularies, in the skills that own them
#
# What is real here and what is recorded: the **ledger validator runs live**
# against fixture ledgers compiled from §12. The ledgers themselves are
# recorded, because writing them is an agent act and cannot be re-derived in a
# regression suite — the same split S3 made for the gate's A pass. What the
# suite proves is that the machinery these prompts compile from accepts the
# corpus's own exhibits and rejects fourteen distinct violations of it.
#
#   check-orchestrator.sh        run the suite
#   check-orchestrator.sh -v     print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking/band1"
SKILLS="$PKG_ROOT/payload/claude/skills"
AGENTS="$PKG_ROOT/payload/claude/agents"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

# Compiled prompts are wrapped prose: an assertion string routinely spans a line
# break, so both helpers compare on whitespace-flattened text.
flat_has() {
  python3 - "$1" "$2" <<'PY'
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}
has()   { flat_has "$1" "$2" && ok "$3" || bad "$3 — not found: $2"; }
hasnt() { flat_has "$1" "$2" && bad "$3 — present but must not be: $2" || ok "$3"; }

STATE="$FX/aspect-state.md"
PLANS="$FX/aspect-plans.md"

# mutate <base> <out> <old> <new> [<old> <new> …]
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

# neg <label> <ledger> <expected rule ids>
neg() {
  if python3 "$HERE/check-ledger.py" "$2" --expect "$3" > "$TMP/neg.out" 2>&1; then
    ok "$1 → $3"
  else
    bad "$1 — expected $3"
    sed 's/^/      /' "$TMP/neg.out"
  fi
}

# ── 0. the fixture ledgers are grammar-legal ─────────────────────────────────

printf '\n▸ The §12 replay is grammar-legal (orchestrator §2.2/§2.3/§3.1/§4.1/§5.3/§8.2)\n'

if python3 "$HERE/check-ledger.py" "$STATE" > "$TMP/state.out" 2>&1; then
  ok "$(cat "$TMP/state.out")"
else
  bad "the §12 replay ledger does not validate:"; sed 's/^/      /' "$TMP/state.out"
fi
if python3 "$HERE/check-ledger.py" "$FX/negatives/base.md" > "$TMP/base.out" 2>&1; then
  ok "the negatives base is legal — every mutation below measures one defect"
else
  bad "the negatives base is already illegal:"; sed 's/^/      /' "$TMP/base.out"
fi

# ── 1. §12.1 — one aspect through the BA-planning loop ───────────────────────

printf '\n▸ Exhibit 1 — the BA-planning loop (§12.1, §6.1–§6.4)\n'

has "$PLANS" "Suggestion — Stakeholders — 2026-07-07" \
    "the suggestion snapshot is kept verbatim, in the §6.1 shape"
has "$PLANS" "AT-ST-2 — no register exists" \
    "every suggestion line names its hole — AT-ID + what is missing (§6.1)"
has "$PLANS" "AT-ST-1/-3 — sponsor authority unstated; populations unconfirmed" \
    "the second line names its holes too"
has "$PLANS" "Sequence rationale: mine what presale already knows before spending a call." \
    "the sequence rationale, verbatim from §12.1"
has "$PLANS" "Composed plan — 2026-07-07 · Y.K." \
    "the composed plan is the BA's document, dated and initialled (§6.2)"
has "$PLANS" "{stakeholder inventory with decision rights · Context · \`stakeholders.md\`} — BA-supplied" \
    "Q2+ path A: the BA supplies the output contract"
has "$PLANS" "{confirmed stakeholder picture + open risks · Context · \`stakeholders.md\`} — LLM-proposed, BA-confirmed" \
    "Q2+ path B: the LLM proposes, the BA confirms — both paths exercised"
has "$PLANS" "contract: fulfilled" "the run log books contract fulfillment (§7.3)"
has "$PLANS" "routing batch 2026-07-08 approved" \
    "the cross-cutting finding routes as an approved batch, logged against the run"
has "$PLANS" "constraints.md is Context's home and Context is \`untouched\`" \
    "§12.1's point: arrival is never gated — the finding lands in an untouched aspect's home"
has "$PLANS" "No scoped-H fired: Band 1, Scope H disarmed." \
    "no scoped health run fires in Band 1 — in-band quality is the aspect gates' (§7.3)"
has "$PLANS" "## Frame" "the plans file carries the non-aspect \`## Frame\` section (D-B1-4)"
has "$PLANS" "## Band 2" "…and the non-aspect \`## Band 2\` section (D-B6-5)"
has "$PLANS" "trigger: post-decomposition" \
    "every Band-2 rerun names its trigger (D-B6-5 / §8.3 C1)"

# ── 2. §12.2 — one threshold cleared, then the arming act ────────────────────

printf '\n▸ Exhibit 2 — the threshold cleared, and Band-1 closure (§12.2, §3.4, §8.2)\n'

has "$STATE" "Aspect gate review — Stakeholders — 2026-07-08" \
    "the evidence table is appended as the transition's basis (§3.4 step 3)"
has "$STATE" '| AT-ST-1 | canvas Customers: sponsor "Olena (network COO)"; populations Clients, Specialists | ✓ |' \
    "AT-ST-1's evidence row, verbatim from §12.2"
has "$STATE" "| AT-ST-2 | stakeholders.md: 4 entries, rights/comms filled; sponsor authority explicit | ✓ |" \
    "AT-ST-2's evidence row, verbatim"
has "$STATE" "→ CLEARED · Y.K. · 2026-07-08" \
    "the BA's ruling closes the table — the framework proposes, it never confirms"
has "$STATE" "2026-07-08 · T2 · Stakeholders · open → first-pass-cleared · Y.K. — AT-ST-1..3" \
    "T2 in the §2.3 event grammar, basis naming its evidence"

has "$STATE" "2026-07-10 · Band 1 closed · Y.K." "the closure event (§8.2, P-O7)"
has "$STATE" "AWs carried: none" "standing AWs are accounted for at closure, even when there are none"
has "$STATE" "arming run: requested — /ba-gate-health full" \
    "the orchestrator REQUESTS the arming run; the gate runs it (§8.2 step 3)"
has "$STATE" "entry landed in .specify/gate-health.md: HEALTHY" \
    "the arming entry lands in the gate's ledger, not this one"
has "$STATE" "Scope H armed" "effect 1 — custodianship hands over to the contract"
has "$STATE" "Band 2 unlocked" "effect 2 — one door, one logged key"
has "$STATE" "Band: 1 (closed 2026-07-10) — Bands 2/3 capable" \
    "the head's band line takes the §2.4 closed shape"
has "$STATE" "| AT-RQ-1 | glossary.md" "AT-RQ is confirmed once, pre-arming (§3.3 handover rule)"
has "$STATE" "the D-B5-3 conditionality lifts design-standards.md into the demand" \
    "AT-RQ-1's locked design-standards conditionality is applied and recorded"
has "$STATE" "the two actors of ≥ 1 canvas Core Function line (D-B4-4)" \
    "AT-RQ-4's locked significance criterion is applied as a checkable fact"

# ── 3. §12.3 — the reopen, end to end ────────────────────────────────────────

printf '\n▸ Exhibit 3 — RO-1, the §8.2 reopen, end to end (§12.3, §5.1–§5.4)\n'

has "$STATE" "RO-1 · received · 2026-07-14 · source: Tier-1 ingestion E-03" \
    "intake is unconditional and logged before any ruling (§5.1)"
has "$STATE" "ruled Real (P-O6) 2026-07-14" "the BA's P-O6 ruling is on the record"
has "$STATE" "2026-07-14 · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-1" \
    "T5 executes on Real, basis naming its RO"
has "$STATE" 'RO-1 · Stakeholders — canvas.md:Core Functions "Specialists self-publish' \
    "the RO record, verbatim from §12.3 — element, contradicted line, conflict, path"
has "$STATE" "flagged \`upstream reopened\` (no cascade)" \
    "dependents are FLAGGED, never auto-reopened (§5.3, D-O6)"
has "$STATE" "no certifications exist to void" \
    "in-flight work is listed as advisory visibility; certifications stay the gate's ground"
has "$STATE" "ruling: continue-with-visibility — Tier-2 for 004 proceeds" \
    "default continue-with-visibility; pause would be the chosen exception"
has "$STATE" "resolution: rides the approved 2026-07-14 ingestion batch" \
    "the fix rides the batch that emitted the signal — no second batch (§5.3 step 3)"
has "$STATE" "trigger: F2 (availability" \
    "the deferred consequence is event-shaped, never scheduled (§5.3 step 4)"
has "$STATE" "2026-07-15 · T6 · Stakeholders · reopened → first-pass-cleared" \
    "T6 re-clears on delta evidence"
has "$STATE" "| AT-ST-1 | carried — evidence untouched by RO-1 fix diff | ✓ |" \
    "the delta rule: untouched criteria carry, WITH the basis written down (§5.4 step 2)"
has "$STATE" "dependent reckoning, one line each:" \
    "each flagged dependent is diffed against the fix (§5.4 step 3)"
has "$STATE" "| Solution | canvas Core Functions line touched" \
    "Solution's table is diffed — the fix touched a Solution-owned canvas line"
has "$STATE" "not an authorization role; no feature exercises it; RO-1's deferral covers it" \
    "§12.3's Requirements reckoning, ruled as the corpus rules it"
has "$STATE" "RO-1 closure (resolved" "the RO closes with its resolution refs"
has "$STATE" "2026-07-15 · 004-appointment-booking entered Band 3" \
    "the Band-3 band event — and nothing else (§8.4 tracking split)"
has "$STATE" "roadmap prompt: E-03 Defined → In delivery" \
    "the roadmap flip is PROMPTED as a routed content edit (D-B6-3 vocabulary)"
hasnt "$STATE" "| E-03 |" \
    "the ledger keeps no copy of roadmap or brief state (§8.3 tracking split)"

# ── 4. seeded defects — one per rule ─────────────────────────────────────────

printf '\n▸ Seeded defects — 14 rules, 14 mutations (the suite is not vacuous)\n'

B="$FX/negatives/base.md"
M="$TMP/mut"; mkdir -p "$M"

# L1 — the head loses one of its four standing lines
mutate "$B" "$M/l1.md" \
  "Upstream flags:           none
" ""
neg "L1  head shape — a missing head line" "$M/l1.md" L1

# L2 — a state outside the five (recorded consistently would still be unknown)
mutate "$B" "$M/l2.md" \
  "| Stakeholders | first-pass-cleared | 2026-07-08 |" \
  "| Stakeholders | closed | 2026-07-08 |"
neg "L2  state vocabulary — \`closed\` is not one of the five" "$M/l2.md" L2,L7

# L3 — an event that is in no known form
mutate "$B" "$M/l3.md" \
  "2026-07-09 · T1 · Value · untouched → open" \
  "2026-07-09 — Stakeholders looks fine now, moving on
2026-07-09 · T1 · Value · untouched → open"
neg "L3  event grammar — a free-text event line" "$M/l3.md" L3

# L4 — the transition the corpus explicitly does not have
mutate "$B" "$M/l4.md" \
  "| Stakeholders | first-pass-cleared | 2026-07-08 | evidence table, this file |" \
  "| Stakeholders | open | 2026-07-10 | re-opened for more work |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-10 · T1 · Stakeholders · first-pass-cleared → open · Y.K. — root; Band 1 entered 2026-07-07"
neg "L4  transition legality — first-pass-cleared → open" "$M/l4.md" L4

# L5 — Vision opened on one prerequisite
mutate "$B" "$M/l5.md" \
  "| Vision | untouched | — | — |" \
  "| Vision | open | 2026-07-10 | prerequisites: Context first-pass-cleared |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-10 · T1 · Vision · untouched → open · Y.K. — prerequisites: Context first-pass-cleared"
neg "L5  DAG — Vision opened while Value is still open" "$M/l5.md" L5

# L6 — a clearing that does not name its evidence
mutate "$B" "$M/l6.md" \
  "— AT-ST-1..3 evidence table (below)" "— cleared, looks good"
neg "L6  basis — a T2 naming no evidence" "$M/l6.md" L6

# L7 — the head contradicts its own events
mutate "$B" "$M/l7.md" \
  "| Context | first-pass-cleared | 2026-07-09 |" \
  "| Context | waived | 2026-07-09 |"
neg "L7  head ⇄ events — the head is not what the replay produces" "$M/l7.md" L7

# L8 — a waiver with a date wish and no risk line
mutate "$B" "$M/l8.md" \
  "Standing aspect waivers:  none" \
  "Standing aspect waivers:  AW-1 · Value · AT-VA-1 — revisit: 2026-09-01" \
  "| Value | open | 2026-07-09 | prerequisites: Stakeholders first-pass-cleared |" \
  "| Value | waived | 2026-07-10 | AW-1 |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-10 · T3 · Value · open → waived · Y.K. — AW-1

AW-1 · Value · unmet: AT-VA-1 — canvas Problems name no population
  reason: the sponsor is on leave
  approver: Y. Kliukin · 2026-07-10
  revisit trigger: 2026-09-01
  status: granted"
neg "L8  AW record — a date-wish trigger and a missing risk line" "$M/l8.md" L8

# L9 — an RO record that names no resolution path
mutate "$B" "$M/l9.md" \
  "Open reopens:             none" \
  "Open reopens:             RO-9 · Stakeholders — the register contradicts the canvas" \
  "| Stakeholders | first-pass-cleared | 2026-07-08 | evidence table, this file |" \
  "| Stakeholders | reopened | 2026-07-10 | RO-9 |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

RO-9 · received · 2026-07-10 · source: gate lane 3

2026-07-10 · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-9

RO-9 · Stakeholders — the register contradicts the canvas actor picture
  status: open"
neg "L9  RO record — no <artifact:line>: <conflict> → <resolution>" "$M/l9.md" L9

# L10 — one RO reopening two aspects
mutate "$B" "$M/l10.md" \
  "Open reopens:             none" \
  "Open reopens:             RO-9 · Stakeholders — the register contradicts the canvas actor picture" \
  "| Stakeholders | first-pass-cleared | 2026-07-08 | evidence table, this file |" \
  "| Stakeholders | reopened | 2026-07-10 | RO-9 |" \
  "| Context | first-pass-cleared | 2026-07-09 | evidence table, this file |" \
  "| Context | reopened | 2026-07-10 | RO-9 |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

RO-9 · received · 2026-07-10 · source: gate lane 3

2026-07-10 · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-9

2026-07-10 · T5 · Context · first-pass-cleared → reopened · Y.K. — RO-9

RO-9 · Stakeholders — stakeholders.md:12: the register contradicts the canvas actor picture → correct the register.
  blast radius: dependents cascaded ·
                ruling: continue-with-visibility
  status: open"
neg "L10 auto-cascade — one RO reopening two aspects" "$M/l10.md" L10

# L11 — closure with an aspect still open (the full replay, minus one clearing)
mutate "$STATE" "$M/l11.md" \
  "2026-07-10 · T2 · Requirements · open → first-pass-cleared · Y.K. — AT-RQ-1..4 evidence table (below)

" ""
neg "L11 closure — declared with Requirements still open" "$M/l11.md" L11,L7

# L12 — the ledger inside memory/
mkdir -p "$M/proj/.specify/memory"
cp "$B" "$M/proj/.specify/memory/aspect-state.md"
neg "L12 ledger home — .specify/memory/aspect-state.md" "$M/proj/.specify/memory/aspect-state.md" L12

# L13 — an event out of chronological order
mutate "$B" "$M/l13.md" \
  "| Value | open | 2026-07-09 |" "| Value | open | 2026-07-06 |" \
  "2026-07-09 · T1 · Value ·" "2026-07-06 · T1 · Value ·"
neg "L13 chronology — an event dated before its predecessor" "$M/l13.md" L13

# L14 — a T5 citing an RO that was never received
mutate "$B" "$M/l14.md" \
  "Open reopens:             none" \
  "Open reopens:             RO-7 · Stakeholders — the register contradicts the canvas actor picture" \
  "| Stakeholders | first-pass-cleared | 2026-07-08 | evidence table, this file |" \
  "| Stakeholders | reopened | 2026-07-10 | RO-7 |" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared" \
  "2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared

2026-07-10 · T5 · Stakeholders · first-pass-cleared → reopened · Y.K. — RO-7

RO-7 · Stakeholders — stakeholders.md:12: the register contradicts the canvas actor picture → correct the register.
  status: open"
neg "L14 RO lifecycle — T5 on a signal that was never logged received" "$M/l14.md" L14

# ── 5. the P-O checkpoints render ────────────────────────────────────────────

printf '\n▸ The nine P-O checkpoints, in the skills that own them (§10.1)\n'

for s in ba-frame ba-status ba-aspect ba-run ba-clear ba-waive-aspect \
         ba-reopen ba-close-band1 ba-enter-feature; do
  f="$SKILLS/$s/SKILL.md"
  if [ ! -f "$f" ]; then bad "$s/SKILL.md missing"; continue; fi
  head -8 "$f" | grep -qx -- "name: $s" || bad "$s — frontmatter name does not match its directory"
  head -8 "$f" | grep -qx 'disable-model-invocation: true' \
    || bad "$s — missing disable-model-invocation: true (D-P2-2)"
  head -8 "$f" | grep -q '^description: .' || bad "$s — no description"
  grep -q 'never' "$f" || bad "$s — no refusal discipline stated"
done
ok "nine skills: frontmatter name · description · disable-model-invocation: true"

# P-O9 — overflow ruling is taken inside the Tier-2 run itself (one-step
# invocation: the run that raises the signal takes the BA's ruling), so
# ba-tier2 joins the sweep for the checkpoint set to be complete.
ALL="$TMP/all-skills.txt"; cat "$SKILLS"/ba-{frame,status,aspect,run,clear,waive-aspect,reopen,close-band1,enter-feature}/SKILL.md "$SKILLS/ba-tier2/SKILL.md" > "$ALL"
for p in P-O1 P-O2 P-O3 P-O4 P-O5 P-O6 P-O7 P-O8 P-O9; do
  has "$ALL" "$p" "$p renders in the skill set"
done

printf '\n  the checkpoints'"'"' locked content:\n'
has "$SKILLS/ba-frame/SKILL.md" "Refuse a second Frame" \
    "ba-frame refuses a re-entry — bands never regress (§8, D-O8)"
has "$SKILLS/ba-frame/SKILL.md" "outside \`.specify/memory/\`" \
    "ba-frame puts both ledgers outside memory/ (D-O3, D-G1/D-G8)"
has "$SKILLS/ba-frame/SKILL.md" "Scope H stays **disarmed**" \
    "ba-frame states that Band 1 runs with Scope H disarmed (§7.3, gate §10.1)"
has "$SKILLS/ba-status/SKILL.md" "Read-only" "ba-status renders; it never changes state"
has "$SKILLS/ba-status/SKILL.md" "no scheduler exists" \
    "ba-status is where revisit triggers are lazily read (§4.2)"
has "$SKILLS/ba-aspect/SKILL.md" "A suggestion that cannot name its hole must not be emitted" \
    "ba-aspect enforces evidence-grounded suggestions (§6.1)"
has "$SKILLS/ba-aspect/SKILL.md" "select · drop · reorder · add custom" \
    "ba-aspect carries Q2's composition verbs verbatim"
has "$SKILLS/ba-aspect/SKILL.md" "An unconfirmed contract makes the run illegal" \
    "ba-aspect pins output contracts before any run (Q2+, §6.3)"
has "$SKILLS/ba-aspect/SKILL.md" "there is no \`first-pass-cleared → open\` transition" \
    "ba-aspect refuses to re-open a cleared aspect (§2.3)"
has "$SKILLS/ba-run/SKILL.md" "thin alias for" "ba-run aliases the technique's own one-step command (§7.1)"
has "$SKILLS/ba-run/SKILL.md" "check P-O3 (technique invocation) here" \
    "ba-run keeps the contract check on the custom-technique path (§7.1)"
has "$SKILLS/ba-run/SKILL.md" "each row under its own compiled P-O3" \
    "…and a route's rows each keep that same check (§7.5)"
has "$SKILLS/ba-t03/SKILL.md" "BA-invoked, never auto-fired" \
    "the invocation discipline is compiled into each technique skill (§7.1)"
has "$AGENTS/ba-orchestrator.md" "No mid-run drip" \
    "the orchestrator does not steer a run in progress (§7.2)"
has "$AGENTS/ba-discovery.md" "Arrival is never gated:" \
    "findings land in any aspect's artifact home (§2.2)"
has "$SKILLS/ba-t03/SKILL.md" "Scope H is disarmed and nothing fires" \
    "the Band-1 silence rule rides in every run-end block (§7.3)"
has "$SKILLS/ba-clear/SKILL.md" "An aspect gate never self-clears." \
    "ba-clear proposes and never confirms (§3.4)"
has "$SKILLS/ba-clear/SKILL.md" "Silence fails." "ba-clear carries threshold design rule 3 (§3.2)"
has "$SKILLS/ba-clear/SKILL.md" "carried — evidence untouched by RO-<n> fix diff" \
    "ba-clear's delta rule writes the carry basis down (§5.4)"
has "$SKILLS/ba-clear/SKILL.md" "AT-RQ is never re-run on armed ground" \
    "ba-clear carries the handover rule (§3.3)"
has "$SKILLS/ba-clear/SKILL.md" "actor of ≥ 1 canvas Core Function line" \
    "ba-clear carries AT-RQ-4's locked significance criterion (D-B4-4)"
has "$SKILLS/ba-waive-aspect/SKILL.md" "Lapse is not reopen" \
    "ba-waive-aspect keeps lapse and reopen distinct (§4.2, D-O5)"
has "$SKILLS/ba-waive-aspect/SKILL.md" "never a date wish" \
    "ba-waive-aspect demands an event-shaped revisit trigger (§4.1)"
has "$SKILLS/ba-waive-aspect/SKILL.md" "No pre-emptive waivers" \
    "a waiver attaches to a named miss a review produced"
has "$SKILLS/ba-waive-aspect/SKILL.md" "HA-\\<nn\\>" \
    "the three-instrument distinctness table ships with the waiver skill (§4.3)"
has "$SKILLS/ba-reopen/SKILL.md" "unconditional" "ba-reopen logs before ruling (§5.1)"
has "$SKILLS/ba-reopen/SKILL.md" "listed, NOT auto-reopened" \
    "ba-reopen flags dependents instead of cascading (§5.3, D-O6)"
has "$SKILLS/ba-reopen/SKILL.md" "Nothing here voids or preserves a PASS" \
    "ba-reopen leaves certifications to the gate (§5.3)"
has "$SKILLS/ba-reopen/SKILL.md" "Default: continue-with-visibility. No freeze." \
    "pause is the chosen exception, never the default"
has "$SKILLS/ba-reopen/SKILL.md" "never just noise" \
    "a declined signal is flagged to the emitter's tuning loop (§5.2)"
has "$SKILLS/ba-close-band1/SKILL.md" "zero \`reopened\`" \
    "ba-close-band1 refuses closure over a live conflict (§8.2)"
has "$SKILLS/ba-close-band1/SKILL.md" "/ba-gate-health full" \
    "ba-close-band1 requests the arming run from the gate (§8.2 step 3)"
has "$SKILLS/ba-close-band1/SKILL.md" "regardless of its verdict" \
    "closure completes when the arming entry exists (D-O7)"
has "$SKILLS/ba-close-band1/SKILL.md" "Threshold-gap candidate" \
    "a heavy-gap arming run feeds threshold tuning, not a re-clear (§8.5, D-O9)"
has "$SKILLS/ba-close-band1/SKILL.md" "There is no partial-band entry." \
    "one door, one logged key (§8.3, D-O7)"
has "$SKILLS/ba-enter-feature/SKILL.md" "Confirmed — <date>" \
    "ba-enter-feature renders the slicing row D5 confirms (§8.4)"
has "$SKILLS/ba-enter-feature/SKILL.md" "next free \`NNN\`" \
    "ba-enter-feature assigns the feature number (build plan §1.1)"
has "$SKILLS/ba-enter-feature/SKILL.md" "The directory only — zero content stubs." \
    "no content stubs at Band-3 entry (D-P2-6)"
has "$SKILLS/ba-enter-feature/SKILL.md" "In delivery" \
    "the locked roadmap status vocabulary (D-B6-3)"
has "$SKILLS/ba-enter-feature/SKILL.md" "visibility, never a block" \
    "the reopened/deferred advisories never block an entry (§8.4)"

# ── 6. the agent's discipline ────────────────────────────────────────────────

printf '\n▸ The orchestrator agent (§10.2, build plan §2.3)\n'

AG="$AGENTS/ba-orchestrator.md"
if [ ! -f "$AG" ]; then
  bad "agents/ba-orchestrator.md missing"
else
  head -8 "$AG" | grep -qx 'name: ba-orchestrator' \
    && ok "frontmatter name matches the file" || bad "frontmatter name does not match the file"
  if head -8 "$AG" | grep -qE '^tools: *Read, *Write, *Edit, *Grep, *Glob *$'; then
    ok "tools: Read, Write, Edit, Grep, Glob — no Bash, so it cannot run a checker (§10.2)"
  else
    bad "ba-orchestrator must declare exactly 'tools: Read, Write, Edit, Grep, Glob'"
  fi
  head -8 "$AG" | grep -q 'Bash' && bad "ba-orchestrator declares Bash — it never runs a check (§10.2)" \
                                 || ok "no Bash in the tool policy — 'requests the arming run; runs nothing'"
  has "$AG" "confined to two files" "the two-ledger confinement is stated (§10.2)"
  has "$AG" "no daemons" "the standing idiom ships with the persona (§0)"
  has "$AG" "never decide alone" "runtime rule 2 — every transition is a BA act"
  has "$AG" "there is no \`first-pass-cleared → open\`" "the transition table is complete and closed"
  has "$AG" "never auto-cascade" "D-O6 is in the persona, not only in the skill"
  has "$AG" '**"The gate", unqualified, means the contract runtime**' \
      "the vocabulary rule — 'aspect gate' is never abbreviated"
  # WS-2 (D-O30 · D-O31 · D-O32): the persona is a compile source, so the
  # checkpoint law and plan-as-route have to be *in* it, not only in §10.1.
  has "$AG" "The checkpoint law." "the checkpoint law compiles into the persona (§10.1, D-O30)"
  has "$AG" "This table lists decision moments, not step boundaries." \
      "…and says what its own checkpoint table is"
  has "$AG" "The composed plan is a route." "plan-as-route compiles in too (§7.5, D-O31)"
  has "$AG" "Silence is never consent" "…with D-O13 restated inside it, not relaxed"
  has "$AG" "Auto-repair." "auto-repair compiles in (§10.2, D-O32)"
  # WS-3: the grant, the floor, and the amendment the grant depends on
  has "$AG" "## Autonomous mode — the autonomy grant" \
      "the autonomy grant compiles into the persona (§4.4, D-O35)"
  has "$AG" "The AG is the fourth instrument, and it belongs in none of the three tables" \
      "…kept out of the three-instrument table it must not join"
  has "$AG" "A transition under a recorded, revocable grant is not a self-clear." \
      "…with the self-clear amendment in the persona's own voice (D-O41)"
  has "$AG" "A standing grant is explicit consent recorded in advance — **not silence.**" \
      "…and D-O13's amendment beside it (D-O40)"
  has "$AG" "The safety floor — outside every grant, in every profile." \
      "…and the safety floor it may never cross (D-O37)"
  has "$AG" "You never grant yourself an AG." \
      "…and the refusal that keeps the grant the BA's act"
fi

# ── 6b. the document's own section inventory ─────────────────────────────────
#
# WS-2 added two sections and one review record; WS-3 added two more and its
# own. A section that is referenced but absent is the failure mode this guards:
# §10.3 rule 8 names §10.6 and §10.7, §7.5 names both §10.6 and §10.7, §4.4 and
# §6.2 point at §10.7, and the runner names them all.

printf '\n▸ The section inventory — every section the corpus references exists\n'

RULES_DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
for sec in "### 7.5 Plan-as-route" "### 10.6 The route render" "## 18. Review record" \
           "### 4.4 The autonomy grant" "### 10.7 Autonomous mode" "## 19. Review record" \
           "## 20. Review record"; do
  grep -qF -- "$sec" "$RULES_DOC" \
    && ok "the document carries \`$sec\`" \
    || bad "the document is missing \`$sec\` — referenced but absent"
done

# §10.3's two amended rules, in the document that owns them
has "$RULES_DOC" "An acknowledgement-only stop is a banned render" \
    "§10.3 rule 7 carries the banned-render clause (D-O30)"
has "$RULES_DOC" "WBS export §10.5, route render §10.6, resumption report §10.7" \
    "§10.3 rule 8's pinned-formats list names all three renders"
has "$RULES_DOC" "v0.13" "the change-record stack keeps the edition WS-2 produced"
has "$RULES_DOC" "D-O30–D-O34" "…and the decisions it ruled"
has "$RULES_DOC" "v0.14" "…and the edition WS-3 produced"
has "$RULES_DOC" "D-O35–D-O39" "…and the WS-3 ruling block"
has "$RULES_DOC" "D-O40–D-O41" "…and the two locked amendments it carries"
has "$RULES_DOC" "v0.15" "…and the edition the scope frame produced"
head -2 "$RULES_DOC" | grep -q 'v0\.16' \
  && ok "the header states the live edition — v0.16, the four-act floor row" \
  || bad "the header does not name v0.16: the edition and the change record disagree"
has "$RULES_DOC" "D-O42–D-O44" "…and the change record names the scope-frame ruling block"

# the ruling block is contiguous from the live high-water mark: no gap, no reuse
python3 - "$RULES_DOC" <<'PYX' && ok "the D-O block runs 1…44 with no gap and no skipped number" \
  || bad "the D-O decision block is not contiguous — a number is missing or reused"
import re, sys
seen = {int(n) for n in re.findall(r"D-O(\d+)", open(sys.argv[1], encoding="utf-8").read())}
sys.exit(0 if seen == set(range(1, 45)) else 1)
PYX

# ── 7. layering — no methodology leaks into the payload ──────────────────────

printf '\n▸ Layering (build plan §0, §3.3) — operative text + IDs only\n'

LEAK=0
for f in "$AG" "$SKILLS"/ba-{frame,status,aspect,run,clear,waive-aspect,reopen,close-band1,enter-feature}/SKILL.md; do
  if grep -nE 'BABOK|mining note|Review record \(|docs/methodology/[a-z]' "$f" \
       | grep -v 'never read a methodology document' \
       | grep -v 'docs/methodology/. is not installed' > "$TMP/leak.txt" 2>/dev/null; then
    if [ -s "$TMP/leak.txt" ]; then
      bad "methodology-layer content in $(basename "$(dirname "$f")")/$(basename "$f"):"
      sed 's/^/      /' "$TMP/leak.txt"; LEAK=1
    fi
  fi
done
[ "$LEAK" -eq 0 ] && ok "zero BABOK anchors, mining notes or review records in the 10 payload files"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S4 orchestrator: §12 exhibits ×3 · ledger grammar · 14 seeded defects · P-O1–P-O9\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
