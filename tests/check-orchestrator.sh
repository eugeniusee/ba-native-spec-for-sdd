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
#   5.        26 seeded defects across the 19 rules — the suite is not vacuous
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

# ── 4b. L3 — the five §2.4 head-line event forms (D132, ruled) ───────────────
#
# Each form is already ruled and pinned — profile (D-O14), scope-frame (D-O43),
# auto on|off and ratification (D-O36–D-O38), source (D-O48) — and until this
# pass the validator recognized none of them: a legal ledger carrying one failed
# L3. The ruling conforms the validator to standing law. `auto` is one form in
# two shapes, so six rows probe five forms. Every row runs BOTH ways: the pinned
# grammar must validate, and a malformed variant of the same form must trip L3.

printf '\n▸ L3 — the five §2.4 head-line event forms, each proven both ways (D-O48 · D132)\n'

EV_ANCHOR="2026-07-09 · T1 · Value · untouched → open · Y.K. — prerequisites: Stakeholders first-pass-cleared"

while IFS='|' read -r label legal broken; do
  [ -z "$label" ] && continue
  mutate "$B" "$M/ev-ok.md"  "$EV_ANCHOR" "$EV_ANCHOR

$legal"
  if python3 "$HERE/check-ledger.py" "$M/ev-ok.md" > "$TMP/ev.out" 2>&1; then
    ok "L3  $label — the §2.4 form validates on a live ledger"
  else
    bad "L3  $label — the pinned form does not validate:"
    sed 's/^/      /' "$TMP/ev.out"
  fi
  mutate "$B" "$M/ev-bad.md" "$EV_ANCHOR" "$EV_ANCHOR

$broken"
  neg "L3  $label — a malformed variant" "$M/ev-bad.md" L3
done <<'FORMS'
profile|2026-07-09 · profile · Presale → Discovery · Y.K. — client signed the discovery SOW|2026-07-09 · profile · Presale to Discovery · Y.K. — client signed the discovery SOW
scope-frame|2026-07-09 · scope-frame · MVP → MVP + Phase 2 · Y.K. — client added reporting|2026-07-09 · scope-frame · MVP + Phase 2 · Y.K. — client added reporting
source|2026-07-09 · source · Slack #proj-cardio · captured · Y.K. — named at Frame, integration read|2026-07-09 · source · Slack #proj-cardio · read it · Y.K. — named at Frame, integration read
source (pending)|2026-07-09 · source · drive/Handover · named — pending · Y.K. — BA has not supplied an export|2026-07-09 · source · drive/Handover · pending · Y.K. — BA has not supplied an export
auto on|2026-07-09 · auto on  · AG-1 · scope full workflow · Y.K. — profile Presale (stated)|2026-07-09 · auto on  · AG-one · scope full workflow · Y.K. — profile Presale (stated)
auto off · ratification|2026-07-09 · auto off · AG-1 · Y.K. — 4 AUTO acts, awaiting ratification|2026-07-09 · ratification · Y.K. — accepted all
FORMS

# the closed vocabulary is the source form's own grammar, not a separate rule
mutate "$B" "$M/ev-skip.md" "$EV_ANCHOR" "$EV_ANCHOR

2026-07-09 · source · email/RFP thread · skipped — client declined to share · Y.K. — BA ruling at Frame"
if python3 "$HERE/check-ledger.py" "$M/ev-skip.md" > "$TMP/ev.out" 2>&1; then
  ok "L3  source — \`skipped — <reason>\` validates: the reason rides the state (D-O48)"
else
  bad "L3  source — the skipped disposition does not validate:"
  sed 's/^/      /' "$TMP/ev.out"
fi

# and nothing beyond the five was let in: the free-text control still trips
mutate "$B" "$M/ev-free.md" "$EV_ANCHOR" "$EV_ANCHOR

2026-07-09 · sources · Slack · captured · Y.K. — a form no ruling pins"
neg "L3  a sixth form nobody ruled is still rejected" "$M/ev-free.md" L3

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
has "$SKILLS/ba-enter-feature/SKILL.md" "assumptions fill unknowns *inside* the essential scope and never widen it" \
    "ba-enter-feature's assumption posture carries the anti-completion corollary"
has "$SKILLS/ba-enter-feature/SKILL.md" "The directory only — zero content stubs." \
    "no content stubs at Band-3 entry (D-P2-6)"
has "$SKILLS/ba-enter-feature/SKILL.md" "In delivery" \
    "the locked roadmap status vocabulary (D-B6-3)"
has "$SKILLS/ba-enter-feature/SKILL.md" "visibility, never a block" \
    "the reopened/deferred advisories never block an entry (§8.4)"

# ── 5b. the source inventory — the Frame render's first block ────────────────
#
# D-O45–D-O49 compiled. The document pins a shape, a disposition set, a capture
# home and a stop that re-takes an existing prompt point rather than inventing
# one; each of those is a sentence a future edit would soften rather than
# delete. The head line (D-O48) is asserted in all three carriers plus its
# position — between `Profile:` and `Boundary:`, where D-O38's `Auto:`-after-
# `Profile:` ordering still holds.

printf '\n▸ The source inventory — the Frame render'"'"'s first block (§8.1 · §2.4; D-O45–D-O49)\n'

FRAME="$SKILLS/ba-frame/SKILL.md"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md"
RULES_SRC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"

# the pinned block, byte for byte against §8.1 — the shape, not a paraphrase
python3 - "$RULES_SRC" "$FRAME" <<'PY' && ok "the pinned inventory block is byte-identical to §8.1's" \
  || bad "ba-frame's inventory block is not §8.1's, byte for byte"
import pathlib, re, sys
def block(p):
    t = pathlib.Path(p).read_text(encoding="utf-8")
    b = [f for f in re.findall(r"^```\n(.*?)^```\n", t, re.S | re.M)
         if f.startswith("Sources on hand:")]
    return b[0] if len(b) == 1 else None
a, b = block(sys.argv[1]), block(sys.argv[2])
sys.exit(0 if a is not None and a == b else 1)
PY

has "$FRAME" "ahead of the picker and the frame" \
    "the inventory renders first — ahead of P-O0 and P-O0b (D-O45)"
has "$FRAME" "the BA answers all three in one reply" \
    "one render, one reply extends from two blocks to three (D-O42, extended by D-O45)"
has "$FRAME" "Frame-act ground, never a technique's" \
    "the inventory is the Frame act's, never a technique's (D-B1-6)"
has "$FRAME" "Extraction is capture, never interpretation" \
    "a reachable source is captured verbatim, not read for meaning (D-O46)"
has "$FRAME" "the artifact is the citation ground, and a mined line cites the artifact, never the live channel" \
    "…and the artifact, not the channel, is what a mined line cites (D-O46)"
for d in "skipped — <reason>" "named — pending"; do
  has "$FRAME" "$d" "the disposition \`$d\` is offered (D-O46)"
done
has "$FRAME" "the BA rules; silence never resolves it" \
    "the dispositions are BA rulings and silence resolves none of them (D-O46)"
has "$FRAME" "one artifact per capture, named for its origin" \
    "\`sources/\` at repo root, one artifact per capture (D-O47)"
has "$FRAME" "no assertion reads \`sources/\`, and it enters no estate glob" \
    "…placement only: no assertion reads it, no estate glob takes it (D-O47)"
has "$FRAME" "It is **not a new prompt point**" \
    "the correction stop invents no prompt point (D-O49)"
has "$FRAME" "P-O0b — scope-frame selection, re-taken" \
    "…it is P-O0b re-taken, the frame's own switch act (D-O49)"
has "$FRAME" "Captures consistent with the frame produce no stop" \
    "…and a consistent capture stops nothing (D-O49)"
has "$FRAME" "A late source brings zero new machinery." \
    "late sources add no mechanism (D-O49)"

# the head line, in the document exhibit and in all three compiled carriers
HEADLINE='Sources: <kind — state, per named source>  (captured <date> | named — pending | skipped — <reason> | excluded — <reason> | none)'
has "$RULES_SRC" "$HEADLINE" "the §2.4 head exhibit carries the Sources line"
for c in "$FRAME" "$SKILLS/ba-status/SKILL.md" "$TPL"; do
  has "$c" "$HEADLINE" "…and so does $(basename "$(dirname "$c")")/$(basename "$c")"
done

# position: between Profile: and Boundary:, in every carrier that renders a head
for c in "$RULES_SRC" "$FRAME" "$SKILLS/ba-status/SKILL.md" "$TPL"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  python3 - "$c" <<'PY' && ok "Sources: sits between Profile: and Boundary: — $lbl" \
    || bad "the Sources line is not between Profile: and Boundary: — $lbl"
import sys
prof = src = bnd = None
for i, l in enumerate(open(sys.argv[1], encoding="utf-8").read().splitlines()):
    if prof is None and l.startswith("Profile: <Discovery | Presale>"):
        prof = i
    elif prof is not None and src is None and l.startswith("Sources: <kind"):
        src = i
    elif src is not None and bnd is None and l.startswith("Boundary: <ladder"):
        bnd = i
sys.exit(0 if None not in (prof, src, bnd) and prof < src < bnd else 1)
PY
done

# the Events grammar, at source grain (D-O48)
SRC_EVENT='· source · <name> · <state> ·'
has "$RULES_SRC" "$SRC_EVENT" "§2.4 pins the source event grammar"
has "$FRAME" "$SRC_EVENT" "…ba-frame carries it"
has "$TPL" "$SRC_EVENT" "…and the shipped template carries it"

# `sources/` is runtime-born: the layout manifest asserts it absent on a fresh
# install, exactly as `canvas.md` is (D-P2-6 · D-O47's placement-only clause)
grep -q '^RT|absent|sources|' "$HERE/layout.expected" \
  && ok "layout.expected classes sources/ runtime-born — absent on a fresh install" \
  || bad "layout.expected has no runtime-born row for sources/"
grep -qE '^(S[0-9]|SK)\|(file|dir)\|sources' "$HERE/layout.expected" \
  && bad "sources/ is installed by a build session — it is runtime-born, placement only" \
  || ok "…and no session installs it: a capture creates it, or nothing does"

# ── 5c. the Slack candidate scan — the framework proposes, the BA disposes ───
#
# D-O53. The scan rides *inside* D-O45's pinned block, so 5b's byte-identity
# check already proves the two candidate lines are the document's own and that
# doc and skill cannot drift apart on them. What is asserted here is the law the
# two lines cannot carry themselves: one candidate and never two (R3-c), the key
# set (R2-c), the no-opt-in trigger with its zero-delta case (R1-a), and the
# ledger consequence of a decline (R4-b). Each is a sentence a future edit would
# soften rather than delete — the 5b pattern.

printf '\n▸ The Slack candidate scan — one candidate, the BA disposes (§8.1; D-O53)\n'

# R3-c — exactly one candidate renders. Counting `#<channel>` inside the pinned
# block is the mechanical form of "never lists 2+": a second channel token in
# the block is the render defect itself, not a paraphrase of it.
python3 - "$RULES_SRC" "$FRAME" <<'PY' && ok "the pinned block offers exactly one candidate channel — never a list (R3-c)" \
  || bad "the pinned block does not carry exactly one candidate channel token (R3-c)"
import pathlib, re, sys
def block(p):
    t = pathlib.Path(p).read_text(encoding="utf-8")
    b = [f for f in re.findall(r"^```\n(.*?)^```\n", t, re.S | re.M)
         if f.startswith("Sources on hand:")]
    return b[0] if len(b) == 1 else None
for p in sys.argv[1:]:
    b = block(p)
    if b is None or b.count("#<channel>") != 1:
        sys.exit(1)
    if b.count("and <N> more matched — name them to see") != 1:
        sys.exit(1)
sys.exit(0)
PY

for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "and <N> more matched — name them to see" \
      "the count line is the ruled one, verbatim — $lbl (R3-c)"
  has "$c" "never a list" "…and a list of channels is named a render defect — $lbl (R3-c)"
  has "$c" "the BA is confirming a source, not running a search" \
      "…on the reason: the BA confirms a source, never runs a search — $lbl (R3-c)"
done

# R1-a — reachability alone is the trigger: no opt-in, no precondition on a
# Slack source having been named, and zero delta where Slack is unreachable
has "$RULES_SRC" "No opt-in, and no precondition:" "reachability alone triggers the scan (R1-a)"
has "$FRAME" "No opt-in, and no precondition." "…compiled into ba-frame (R1-a)"
for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "whether or not the BA has already named a Slack source" \
      "…and it does not wait on a named Slack source — $lbl (R1-a)"
  has "$c" "Slack unreachable is zero delta" \
      "…Slack unreachable renders the block as before, zero delta — $lbl (R1-a)"
done

# R2-c — the project name is the only key
has "$RULES_SRC" "The keys are the project name, and nothing else" "the key set is the project name only (R2-c)"
has "$FRAME" "The key is the project name, and nothing else" "…compiled into ba-frame (R2-c)"
for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "no key and no scan" "…no project name on hand means no key and no scan — $lbl (R2-c)"
  has "$c" "never content" "…the scan resolves channel names, never content — $lbl (R2-c)"
done

# R4-b — a declined candidate leaves no ledger entry, and the confirmed one
# inherits the existing machinery rather than a parallel copy of it
for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "BA-named and BA-confirmed sources only" \
      "the \`Sources:\` ledger takes BA-named and BA-confirmed sources only — $lbl (R4-b)"
  has "$c" "A candidate the reply does not answer is declined" \
      "…an unanswered candidate is declined, not pending — $lbl (R4-b)"
  has "$c" "sources/slack-<channel>-<date>.md" \
      "…a confirmed candidate captures to the D-O47 path, unchanged — $lbl (R4-b)"
  has "$c" "no second consumer of the slack" \
      "…and it fires D-O49's correction stop only — no second consumer of the slack — $lbl" \

done

# the decline must not have grown a fifth state on the head line: D-O48's
# vocabulary is closed, and a candidate that leaves no entry cannot need one
for c in "$RULES_SRC" "$FRAME" "$SKILLS/ba-status/SKILL.md" "$TPL"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  if grep -F -- "$HEADLINE" "$c" | grep -qiE 'candidate|declined|proposed'; then
    bad "the Sources: head line grew a candidate state — $lbl (D-O53 · D-O48's vocabulary is closed)"
  else
    ok "the Sources: line keeps its closed four-state vocabulary — $lbl (R4-b)"
  fi
done

# placement and budget: inside the existing block, no prompt point, no P-O
for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "no new prompt point" "the scan invents no prompt point — $lbl (D-O53)"
done
has "$RULES_SRC" "D-O33's ≤ 8 Presale budget and its one interaction of slack (7 + 1) are **arithmetically untouched**" \
    "…and the ≤ 8 Presale budget is arithmetically untouched (D-O33, D-O53)"

# the P-O table gained no row — the whole placement ruling, mechanically
python3 - "$RULES_SRC" <<'PY' && ok "§10.1's P-O table still holds its eleven rows — the scan added none" \
  || bad "§10.1's P-O row count moved: the scan was placed as a prompt point"
import re, sys
t = open(sys.argv[1], encoding="utf-8").read()
sec = t.split("### 10.1 P-O prompt points")[1].split("### 10.2 ")[0]
rows = re.findall(r"^\| P-O\d[ab]? \|", sec, re.M)
sys.exit(0 if len(rows) == 11 else 1)
PY

# ── 5d. the scan method — list-then-filter, and no other (D-O54) ─────────────
#
# The field post-mortem on the record at docs/field-notes/2026-08-16-slack-scan-miss.md:
# the first live Frame scan issued one name-keyed query, got zero against a
# reachable prefixed channel, and rendered "no candidate". D-O54 pins the
# method — enumerate the broad listing to completion, filter locally, never
# search by name — with the match rule, the deterministic ranking and the
# zero-is-inconclusive law. Each law is asserted in both carriers; then a
# residual read proves no search wording survives in the scan clause beyond
# the sentences that remove it, so a future "fall back to search" edit turns
# the suite red.

printf '\n▸ The scan method — list-then-filter (§8.1; D-O54)\n'

for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "paging the broad listing to completion" \
      "the scan pages the broad listing to completion — $lbl (D-O54 · R1-a)"
  has "$c" "locally** for the project name" \
      "…and filters locally for the project name — $lbl (D-O54 · R1-a)"
  has "$c" "removed from the scan entirely" \
      "name-keyed search is removed from the scan entirely — $lbl (D-O54 · R1-a)"
  has "$c" "not demoted to a fallback" \
      "…not demoted to a fallback — $lbl (D-O54 · R1-a)"
  has "$c" "A zero from a name-keyed search is inconclusive" \
      "a zero from a name-keyed search is inconclusive — $lbl (D-O54 · R1-a)"
  has "$c" "only after the local filter over the complete listing comes back empty" \
      "…and no-match renders only after the complete listing's filter is empty — $lbl (D-O54 · R1-a)"
  has "$c" 'Tokenize channel names on `_` and `-`, case-insensitive' \
      "the match rule tokenizes on _ and -, case-insensitive — $lbl (D-O54 · R2-a)"
  has "$c" "every token of the project name appears among the channel's tokens" \
      "…and a candidate carries every project-name token — $lbl (D-O54 · R2-a)"
  has "$c" "The best match is deterministic, from names alone" \
      "ranking is deterministic from names alone — $lbl (D-O54 · R3-a)"
  has "$c" "exact name equality first, then fewest extra tokens, alphabetical tie-break" \
      "…in the ruled order: exact equality, fewest extra tokens, alphabetical — $lbl (D-O54 · R3-a)"
  has "$c" "a fuzzy search could never certify the count" \
      "…and the complete listing is what makes <N> honest — $lbl (D-O54 · R3-a)"
  has "$c" "exact names and left-anchored prefixes only" \
      "the tool fact rides the clause — exact + left-anchored prefixes reliable, infix fuzzy — $lbl (fix 6)"
done

# the residual read: inside the scan clause, the only search wording left is
# the wording that removes it. Extract the clause, require each permitted
# sentence exactly once, strip them, and require the remainder search-free.
#
# D-O81 lands its law paragraph inside this clause — immediately after D-O80's,
# where the ruling put it — and that law names retrieval kinds generically
# ("a listing, a search set, a sweep, a glob") and routes P-A1's band-wide
# search set. Neither is scan-method wording, so both are permitted BY EXACT
# PHRASE at the document only; the skill carries no D-O81 text and its
# permitted set is unchanged. The check keeps its whole force: a future
# "fall back to search" edit still leaves wording no permitted phrase covers,
# and each removal sentence must still appear exactly once.
for spec in "doc|The Slack candidate scan (D-O53, locked).|The profile picker" \
            "skill|The Slack candidate scan — the framework proposes, you dispose.|Then the profile picker"; do
  kind="${spec%%|*}"; rest="${spec#*|}"; start="${rest%%|*}"; stop="${rest#*|}"
  if [ "$kind" = doc ]; then c="$RULES_SRC"; else c="$FRAME"; fi
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  if python3 - "$c" "$start" "$stop" "$kind" > "$TMP/residual.err" 2>&1 <<'PY'
import pathlib, re, sys
t = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
i = t.index(sys.argv[2]); j = t.index(sys.argv[3], i)
clause = t[i:j]
PERMITTED = [
    "Name-keyed search against the Slack search endpoint is",
    "the search tool's matching is reliable",
    "which is why the scan lists and filters rather than searches",
    "A zero from a name-keyed search is inconclusive",
    "a fuzzy search could never certify the count",
    "not running a search",
]
# document-only: D-O81's law names retrieval kinds generically and routes the
# P-A1 application. Neither is scan-method wording; both are exact phrases.
DOC_ONLY = [
    "a listing, a search set, a sweep, a glob",
    "band-wide-search-set application is routed, never legislated here",
]
if sys.argv[4] == "doc":
    PERMITTED = PERMITTED + DOC_ONLY
for ph in PERMITTED:
    if clause.count(ph) != 1:
        print("permitted sentence not exactly once (%d): %r" % (clause.count(ph), ph))
        sys.exit(1)
    clause = clause.replace(ph, " ")
m = re.search(r"\S*search\S*", clause, re.I)
if m:
    print("surviving search wording: %r" % m.group(0))
    sys.exit(1)
PY
  then
    ok "no name-keyed-search wording survives in the scan clause — $lbl (D-O54 residual)"
  else
    bad "search wording survives in the scan clause beyond the removal sentences — $lbl (D-O54 residual): $(cat "$TMP/residual.err")"
  fi
done


# ── 5d. the listing's corpus and the corpus-declaration rule (D-O80–D-O81) ───
#
# The second field post-mortem on the record, at
# docs/field-notes/2026-08-20-slack-scan-corpus-miss.md: the scan rendered
# "no match" over a listing it called complete. The listing covered 225 of 705
# channels — the target sat in the 480 it never enumerated — and every D-O53 /
# D-O54 rule was obeyed, because those rules govern the retrieval METHOD and
# never its CORPUS: "paging the broad listing to completion" is fully satisfied
# by paging a *filtered* listing to completion. D-O80 makes the corpus explicit
# and strips the terminator of its false authority; D-O81 states the class once
# as framework law. Each law is asserted in both carriers exactly as the D-O54
# laws above are — except D-O81 and the durable tool facts, which are
# **document-only by ruling**: §34 compiles `ba-frame` alone, and framework law
# is reached by reference, never recompiled into every carrier depending on it.
#
# The bound, written down beside D-O54's rather than left to inference: this
# section asserts the LAW's presence and the RENDER's shape — that both
# carriers state the corpus, refuse the terminator as proof, hold the
# known-channel falsification, and pin the same two render deltas
# byte-for-byte. It does NOT execute a scan; whether a live listing actually
# sets both axes is a runtime property no file-only suite can reach, which is
# exactly why the render line must carry `<n>` and its corpus — an auditable
# claim is the only thing a document can buy. The volatile mechanics of report
# §7 — cursor encoding, the silent limit clamp, parallel fan-out, reference
# corpus sizes — are asserted ABSENT from the law: they live in the field note
# by ruling, and law carrying a tool's implementation detail ages into a lie.

printf '\n▸ The listing declares its corpus (§8.1; D-O80–D-O81)\n'

NOMATCH_LINE='Slack — no channel matches the project name · listed <n> channels (public + private, archived included).   (renders only when Slack is reachable, the listing completed, and the scan found no match)'
# D-O85's render delta: the cut declares itself, and the two corpus-grounded
# lines say out loud that they need a completed listing.
CUT_LINE='Slack — listing interrupted at <act>: covered <n> of <m | unknown> pages — corpus not established; no negative rests on it.   (renders only when the listing was cut before completion; a matched candidate still renders on its own line)'
COUNT_LINE='and <N> more matched — name them to see                                             (renders only over a completed listing, when N ≥ 1)'
MATCH_LINE='Slack — closest match on the project name: #<channel> (archived) — include it, or ignore it.'

for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  # D-O80 — the corpus is named, and a default is presumed narrowing
  has "$c" "The corpus is every channel the workspace holds — both visibilities, every archive state" \
      "the listing names its corpus — every channel, both visibilities, every archive state — $lbl (D-O80)"
  has "$c" "presumed narrowing" \
      "…and a retrieval parameter left at its default is presumed narrowing — $lbl (D-O80)"
  has "$c" "visibility and archive state are set **explicitly**, never by omission" \
      "…the axes set explicitly, never by omission — $lbl (D-O80)"
  # D-O80 — the terminator certifies the query, never the workspace
  has "$c" "An end-of-results terminator certifies the query, never the workspace" \
      "the terminator certifies the query, never the workspace — $lbl (D-O80)"
  has "$c" "exhaustion of its own filtered result set" \
      "…the tool reporting exhaustion of its own filtered result set — $lbl (D-O80)"
  has "$c" "Completeness is a property the scan **establishes**, never a signal it **receives**" \
      "…completeness established by the scan, never received as a signal — $lbl (D-O80)"
  has "$c" "the listing is a sample, and a sample reports what it found, never what does not exist" \
      "…and until every axis is explicit the listing is a sample — $lbl (D-O80)"
  # D-O80 — the falsification half, in its operational form (report §6.3)
  has "$c" "A zero-channel listing is a tool fault, never a finding" \
      "a zero-channel listing is a tool fault, never a finding — $lbl (D-O80)"
  has "$c" "a listing that misses a known channel is void" \
      "…and a listing that misses a known Sources: channel is void — $lbl (D-O80)"
  has "$c" "and no render rests on it" \
      "…with no render resting on it — $lbl (D-O80)"
  # the two render deltas, pinned identically in both carriers
  has "$c" "$MATCH_LINE" \
      "the match line carries the (archived) marker — $lbl (D-O80 render delta 1)"
  has "$c" '"(archived)" only when the candidate is archived' \
      "…and the marker renders only when the candidate is archived — $lbl (D-O80)"
  has "$c" "$NOMATCH_LINE" \
      "the no-match line renders with <n> and its corpus — $lbl (D-O80 render delta 2)"
  # the improvised line the escape produced can never come back unmarked
  hasnt "$c" "Slack — closest match on the project name: #<channel> — include it" \
      "the unmarked match line is gone — the render delta landed, not duplicated — $lbl (D-O80)"
done

# D-O81 and the durable tool facts — document-only by ruling; the carrier
# reaches the law by reference and is asserted clean of it, so a future
# recompile that quietly mirrors framework law into a skill turns this red.
has "$RULES_SRC" "The corpus-declaration rule" \
    "the corpus-declaration rule is stated, once, at the document (D-O81)"
has "$RULES_SRC" "names the corpus that retrieval must cover" \
    "…a retrieval-dependent rule names the corpus that retrieval must cover (D-O81)"
has "$RULES_SRC" "the retrieval **states the corpus it covered**" \
    "…and the retrieval states the corpus it covered (D-O81)"
has "$RULES_SRC" "never inherited from the tool that terminated it" \
    "…a completeness claim never inherited from the tool that terminated it (D-O81)"
has "$RULES_SRC" "a sample never grounds a negative" \
    "…and where the corpus is not stated, a sample never grounds a negative (D-O81)"
has "$RULES_SRC" "at the escape site only" \
    "the rule is applied at the escape site only — the application stays narrow (D-O81)"
has "$RULES_SRC" "band-wide-search-set application is routed, never legislated here" \
    "…and P-A1's band-wide search set is routed, never legislated here (D-O81)"
has "$RULES_SRC" "the listing tool's visibility and archive parameters default narrow — public, non-archived" \
    "the durable tool fact rides the clause — the parameters default narrow (D-O80)"
has "$RULES_SRC" "the endpoint has no listing mode" \
    "…and the endpoint has no listing mode, the broad listing a match-all query (D-O80)"
has "$RULES_SRC" "docs/field-notes/2026-08-20-slack-scan-corpus-miss.md" \
    "…and the edition names the field note carrying the run as it happened"
hasnt "$FRAME" "The corpus-declaration rule" \
    "framework law is reached by reference, never recompiled into the carrier (D-O81)"

# the volatile mechanics stay in the field note — law that carries a tool's
# implementation detail ages into a lie (report §7, deliberately not encoded)
for phrase in "CURRENT_PAGE" "page_limit_exceeded" "clamp silently" "fanned out in parallel"; do
  hasnt "$RULES_SRC" "$phrase" \
      "volatile tool mechanics stay in the field note, never in the law — $phrase (D-O80)"
done

# the field note itself is on the record and carries the run's own evidence
FIELDNOTE="$PKG_ROOT/docs/field-notes/2026-08-20-slack-scan-corpus-miss.md"
if [ -f "$FIELDNOTE" ]; then
  ok "the field note is on the record at docs/field-notes/2026-08-20-slack-scan-corpus-miss.md"
else
  bad "the field note is missing: the ruling cites a record that does not exist"
fi
has "$FIELDNOTE" "225 of 705" "…and it carries the run's own evidence — 225 of 705 channels enumerated"
has "$FIELDNOTE" "second escape of one shape" "…and names the class: the second escape in four days"

# the pinned block is byte-identical across the two carriers — a divergence
# here IS the render defect the pinned shape exists to prevent
python3 - "$RULES_SRC" "$FRAME" <<'PYBLOCK' && ok "the pinned source-inventory block is byte-identical in both carriers (D-O45 · D-O53 · D-O70 · D-O80)" \
  || bad "the pinned source-inventory block diverges between the document and ba-frame — a render defect"
import pathlib, sys

def block(path):
    lines = pathlib.Path(path).read_text(encoding="utf-8").split("\n")
    i = next(n for n, l in enumerate(lines) if l.startswith("Sources on hand: <list of supplied material>."))
    j = next(n for n in range(i, len(lines)) if lines[n].strip() == "```")
    return lines[i:j]

a, b = block(sys.argv[1]), block(sys.argv[2])
if a != b:
    for x, y in zip(a, b):
        if x != y:
            print("doc:   %r" % x); print("skill: %r" % y); break
    print("doc lines %d, skill lines %d" % (len(a), len(b)))
    sys.exit(1)
# six lines before D-O80, seven after it, eight after D-O85: the no-match line
# and the interrupted line are the two deltas, and a count guard is what keeps a
# future line from arriving unruled.
if len(a) != 8:
    print("the pinned block is not eight lines: %d" % len(a)); sys.exit(1)
PYBLOCK

# ── 5d. the excluded source — the disposition the inventory had no word for ──
#
# D-O70. The state joins a vocabulary D-O48 closed at four, so the first thing
# asserted is that the fifth stands in every carrier (5b's HEADLINE sweep
# already does that) and the second is the law the state exists for: never
# captured, never mined, never followed — and never silent. The encounter line
# is the whole reason the law is safe to have, so it is asserted at the
# document, at the compiled carriers, and live against the ledger validator.

printf '\n▸ The excluded source — never captured, never followed, never silent (§8.1 · §2.4; D-O70)\n'

has "$RULES_SRC" "An excluded artifact is **never captured**." \
    "§8.1 states the law's first clause"
has "$RULES_SRC" "is **never followed**" \
    "…and its third — a reference inside any capture is never followed"
has "$RULES_SRC" "one Events line per distinct excluded artifact per capture" \
    "…with the encounter recorded, deduplicated per capture"
has "$RULES_SRC" "It is a state, not a triage outcome" \
    "…and it is a state, never a fourth triage outcome (D-O46 untouched)"
has "$RULES_SRC" "a container covering its contents" \
    "…at named-artifact grain, a container covering its contents"
has "$RULES_SRC" "An exclusion hides nothing" \
    "…and an exclusion hides nothing — only capture and following stop"
has "$RULES_SRC" "Late arrival is zero new machinery" \
    "…late arrival adding no mechanism (the D-O49 precedent)"

ENCOUNTER='<date> · source · <artifact> · encounter — not followed · <BA initials> — excluded <date>'
has "$RULES_SRC" "$ENCOUNTER" "§2.4 pins the encounter line on the source grammar"
has "$FRAME" "$ENCOUNTER" "…and ba-frame carries it"
has "$TPL" "<date> · source · <artifact> · encounter — not followed · <initials> — excluded <date>" \
    "…and the shipped template's event exhibit carries it"

for c in "$FRAME" "$SKILLS/ba-audit/SKILL.md"; do
  lbl="$(basename "$(dirname "$c")")"
  grep -qF -- 'never followed' "$c" \
    && ok "the never-follow clause is compiled into $lbl" \
    || bad "$lbl does not carry the never-follow clause (D-O70)"
done

# the scan filter and its named count line (D-O70; D-O45's block amended)
has "$RULES_SRC" "<k> channel(s) excluded by BA ruling" \
    "§8.1's pinned block carries the conditional exclusion line"
has "$FRAME" "filtered out of the candidate ranking and out of" \
    "…and ba-frame filters excluded channels out of the ranking and out of <N>"
hasnt "$FRAME" "Do not invent a fifth state." \
    "…and no carrier still forbids the fifth state D-O70 created"

# live: the state, the encounter form, and the law, against the validator
printf '\n  the ledger validator, live:\n'
EXCL_EVENT="2026-07-09 · source · drive/Handover · excluded — client legal hold · Y.K. — BA ruling at Frame"
mutate "$B" "$M/ev-excl.md" "$EV_ANCHOR" "$EV_ANCHOR

$EXCL_EVENT

2026-07-09 · source · drive/Handover · encounter — not followed · Y.K. — excluded 09.07"
if python3 "$HERE/check-ledger.py" "$M/ev-excl.md" > "$TMP/ev.out" 2>&1; then
  ok "L3  source — \`excluded — <reason>\` and its encounter line both validate (D-O70)"
else
  bad "L3  source — the fifth state or its encounter line does not validate:"
  sed 's/^/      /' "$TMP/ev.out"
fi

# seeded defect — an excluded artifact that got captured anyway
mutate "$B" "$M/ev-excl-cap.md" "$EV_ANCHOR" "$EV_ANCHOR

$EXCL_EVENT

2026-07-09 · source · drive/Handover · captured 09.07 · Y.K. — read it anyway"
neg "L15 an excluded artifact captured anyway" "$M/ev-excl-cap.md" L15

# seeded defect — a capture references an excluded artifact, no encounter line
mutate "$B" "$M/ev-excl-silent.md" "$EV_ANCHOR" "$EV_ANCHOR

$EXCL_EVENT"
mkdir -p "$TMP/captures"
printf 'the old scope lives in drive/Handover — see there\n' \
  > "$TMP/captures/slack-proj-2026-07-09.md"
if python3 "$HERE/check-ledger.py" "$M/ev-excl-silent.md" --captures "$TMP/captures" \
     --expect L16 > "$TMP/neg.out" 2>&1; then
  ok "L16 a capture referencing an excluded artifact with no encounter line → L16"
else
  bad "L16 the encounter guard did not fire — silence is what the law forbids"
  sed 's/^/      /' "$TMP/neg.out"
fi

# ── 5e. the standing-advisory register and its decision list ─────────────────
#
# D-O68–D-O69. The register is a head line; the list is a conditional tail on
# two pinned reports and, in manual mode, T-18's step-4 approval. What is
# asserted here is the document's law and the head line in every carrier; the
# compiled tail on the report surfaces is check-auto.sh's, and T-18's half is
# check-spine.sh's.

printf '\n▸ The standing-advisory register and its decision list (§2.4 · §10.7; D-O68–D-O69)\n'

ADVLINE='Scope advisories:         none | ADV-<n> · <epic> — standing | accepted <date> — revisit: <event>'
has "$RULES_SRC" "$ADVLINE" "the §2.4 head exhibit carries the Scope advisories line"
has "$SKILLS/ba-status/SKILL.md" "$ADVLINE" "…and so does ba-status's head render"
has "$TPL" "Scope advisories:         none" \
    "…and the shipped template is born with the register at none"
has "$RULES_SRC" "It is a register, not an instrument" \
    "…and the register never joins §4.3's instrument table (D-O68)"
has "$RULES_SRC" "the **verbatim finding and its citation stay in the plans-file run log**" \
    "…the head holding the summary, the finding staying where D-B6-8 put it"

has "$RULES_SRC" "Scope advisories — <n> standing · decide each (P-A1 row shape — source-audit definition §5)" \
    "§10.7 pins the decision-list tail in the cited P-A1 shape"
has "$RULES_SRC" "The row shape is P-A1's — cited, never restated here" \
    "…cited and never restated — one shape, in the source-audit definition"
has "$RULES_SRC" "\`hold as advisory — no move\` — the default" \
    "…disposition (a), the default that makes \`apply all\` safe"
has "$RULES_SRC" "never an inline phase edit" \
    "…disposition (b) riding T-18, never an inline phase edit"
has "$RULES_SRC" "on the **SA record pattern**" \
    "…disposition (c) on the SA record pattern, with its revisit trigger"
has "$RULES_SRC" "no disposition removes a finding without a reason" \
    "…and no disposition ends a finding without a reason"
has "$RULES_SRC" "the T-18 run-log entry in manual mode" \
    "…the ruling landing on the ratification event or T-18's run log — no new event kind"
has "$RULES_SRC" "The framework has no act named *the manual ratification batch*" \
    "…and no act named the manual ratification batch is created"
has "$RULES_SRC" "an AG never answers the list" \
    "…assembly may be AUTO, the ruling never is (the P-A1 floor)"


# ── 5f. Billable renders blank where no boundary stands (D-O71) ─────────────
#
# Codification: the exporter already behaved this way — D-O71 makes it law, at
# the rule it governs, so the sentence must stand in §10.5 and in the skill that
# renders the column. The behaviour itself is check-wbs.sh's, against a seeded
# frame that names no boundary.

printf '\n▸ Billable — blank where no boundary stands (§10.5; D-O71)\n'

has "$RULES_SRC" "blank where no boundary stands in the frame" \
    "§10.5's Billable rule carries the never-invents clause"
has "$RULES_SRC" "never a default \`Yes\` or \`No\`" \
    "…and refuses a default in the same breath"
has "$SKILLS/ba-wbs/SKILL.md" "blank where no boundary stands in the frame" \
    "…and ba-wbs carries the sentence at its own column rule"
has "$SKILLS/ba-wbs/SKILL.md" "never a default \`Yes\` or \`No\`" \
    "…and its refusal too"
has "$RULES_SRC" "the never-numeric guarantee (D-O44(b)) is untouched" \
    "…with D-O60's never-numeric guarantee untouched — nine columns, ending at Billable"


# ── 5g. the cross-cutting obligations register (D-O72–D-O74) ────────────────
#
# EC-01 + owner ruling Р8. The register is a head line with a closed class set
# and a closed state vocabulary; the capture is line 5 of the pinned P-O0b
# block; the language obligation materializes as a spec unit or it is not
# carried at all. The head-line grammar is check-ledger.py's L17 (live below);
# the epic half is check-band2-artifacts.py's B104, run from check-spine.sh.

printf '\n▸ The cross-cutting obligations register (§2.4 · §8.1; D-O72–D-O74)\n'

XOHEAD='Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default · XO-<n> — <class>: <value, one line> (<citation>) — <state> · …'
has "$RULES_SRC" "$XOHEAD" "the §2.4 head exhibit carries the Cross-cutting line"
has "$FRAME"     "$XOHEAD" "…and so does ba-frame's head-write block"
has "$SKILLS/ba-status/SKILL.md" "$XOHEAD" "…and ba-status's head render"
has "$TPL" "Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default" \
    "…and the shipped template is born carrying the English default"

has "$RULES_SRC" "closed at five: language · device · accessibility · branding · compliance" \
    "the class set is closed at five (D-O72)"
has "$FRAME" "closed at five: language · device · accessibility ·" \
    "…and ba-frame compiles the closed five"
has "$RULES_SRC" "a sixth class enters only by decision number on the record" \
    "…a sixth entering only by decision number, the D-O48 pattern"
has "$FRAME" "A sixth class enters only by decision number on the" \
    "…and ba-frame carries that refusal too"
has "$RULES_SRC" "this line is never \`none\`" \
    "…and the line is never \`none\` — the default always stands"
has "$FRAME" "this line is never \`none\`" "…in the carrier as well"
has "$RULES_SRC" "the audit's \`OB-<nnn>\` register is per-run and derived" \
    "…the runtime register deliberately disjoint from the audit's (D-O72)"
has "$FRAME" "the source audit's \`OB-<nnn>\` register is per-run and" \
    "…and ba-frame states the disjointness at its own site"

# the capture — line 5 of the pinned block, one render one reply
has "$RULES_SRC" "5. Cross-cutting: <XO-<n> — <class>: <value, one line> (<citation>), per harvested obligation> | XO-1 English default only" \
    "§8.1's pinned P-O0b block carries line 5 (D-O73)"
has "$FRAME" "5. Cross-cutting: <XO-<n> — <class>: <value, one line> (<citation>), per harvested obligation> | XO-1 English default only" \
    "…and ba-frame's block renders it verbatim"
has "$RULES_SRC" "XO-? — <candidate, one line> (<citation>) — keep or discard" \
    "…an ambiguous candidate asked inside the block, never guessed"
has "$FRAME" "XO-? — <candidate, one line> (<citation>) — keep or discard" \
    "…and the carrier asks it in the same single Frame reply"
has "$FRAME" "no new prompt point" "…with no new prompt point created (D-O73)"
has "$FRAME" "XO confirmation is BA-only under any grant" \
    "…and confirmation BA-only under any grant — P-O0b's safety-floor standing"
has "$FRAME" "in **any later capture or mining pass**" \
    "…mid-band recognition compiled: any later capture or mining pass (D-O73)"
has "$FRAME" "one **\`scope-frame\`** Events line — **no new event kind**" \
    "…appending one scope-frame Events line, no new event kind"

# the language unit — Р8
has "$RULES_SRC" "English is the engagement's ultra-default language" \
    "the language default is framework law, recorded (D-O74 — Р8)"
has "$FRAME" "English is the engagement's ultra-default language" \
    "…and ba-frame states it at its own site"
has "$RULES_SRC" "never a fabricated client citation" \
    "…recorded as its own ground, never a fabricated citation"
has "$RULES_SRC" "one dedicated localization epic" \
    "…a stated obligation materializing as one dedicated localization epic"
has "$SKILLS/ba-t17/SKILL.md" "one dedicated localization epic" \
    "…and T-17 — Epics decomposition compiles the unit form"
has "$SKILLS/ba-tier2/SKILL.md" "at least one story holding the entry's verbatim citation" \
    "…and Tier 2 — spec-depth gap-filling carries the story half"
has "$RULES_SRC" "a comment is not a carrier" \
    "…with the audit's own law promoted to runtime"
has "$SKILLS/ba-t17/SKILL.md" "a comment is not a carrier" "…in the epic carrier too"
has "$SKILLS/ba-t17/SKILL.md" "coverage-complete and the exclusive partition stand untouched" \
    "…and T-17's coverage-complete stands untouched by construction"
has "$RULES_SRC" "language-only by ruling" "…and the unit-form law is language-only"

# live: the register's grammar, against the validator
printf '\n  the ledger validator, live:\n'
XO_ANCHOR='Cross-cutting:            XO-1 — language: English (engagement default — framework law, D-O74) — default'
mutate "$B" "$M/xo-ok.md" "$XO_ANCHOR" \
  "$XO_ANCHOR · XO-2 — language: Ukrainian + English UI (brief.md §2) — carried — E-07 Localization · XO-3 — accessibility: WCAG 2.1 AA (rfp.md §6) — accepted — client defers to phase 2 — revisit: client sign-off"
if python3 "$HERE/check-ledger.py" "$M/xo-ok.md" > "$TMP/xo.out" 2>&1; then
  ok "L17 the register validates — the default, a carried entry, an accepted one (D-O72)"
else
  bad "L17 a legal register does not validate:"; sed 's/^/      /' "$TMP/xo.out"
fi

mutate "$B" "$M/xo-class.md" "$XO_ANCHOR" \
  "$XO_ANCHOR · XO-2 — performance: p95 under 200ms (rfp.md §7) — captured"
neg "L17 a sixth class, invented rather than ruled" "$M/xo-class.md" L17

mutate "$B" "$M/xo-state.md" "$XO_ANCHOR" \
  "$XO_ANCHOR · XO-2 — device: tablet-first (brief.md §3) — noted"
neg "L17 a state outside the closed four" "$M/xo-state.md" L17

mutate "$B" "$M/xo-none.md" "$XO_ANCHOR" "Cross-cutting:            none"
neg "L17 the line rendered \`none\` — the default always stands" "$M/xo-none.md" L17

# seeded defect — a capture states a cross-cutting fact, the register is silent
mkdir -p "$TMP/xo-captures"
printf 'Kickoff notes\n\nThe UI language must be Ukrainian, with English as a fallback.\n' \
  > "$TMP/xo-captures/slack-proj-2026-07-09.md"
if python3 "$HERE/check-ledger.py" "$B" --captures "$TMP/xo-captures" \
     --expect L18 > "$TMP/neg.out" 2>&1; then
  ok "L18 a cross-cutting fact captured with no XO entry → L18 (D-O73)"
else
  bad "L18 the harvest floor did not fire — a captured obligation left to silence"
  sed 's/^/      /' "$TMP/neg.out"
fi

# and the control: with the obligation registered, the same capture is clean
mutate "$B" "$M/xo-harvested.md" "$XO_ANCHOR" \
  "$XO_ANCHOR · XO-2 — language: Ukrainian UI, English fallback (slack-proj-2026-07-09.md) — carried — E-07 Localization"
if python3 "$HERE/check-ledger.py" "$M/xo-harvested.md" --captures "$TMP/xo-captures" \
     > "$TMP/xo2.out" 2>&1; then
  ok "…and the same capture is clean once the obligation stands on the line"
else
  bad "L18 fires on a registered obligation — the guard is not keyed to the register:"
  sed 's/^/      /' "$TMP/xo2.out"
fi


# ── 5i. the acceptance-shape register and the deferral cross-check ──────────
#
# EC-02. Deferring acts never consulted the acceptance/pass/success lists the
# sources state, so an item an acceptance list required could be postponed with
# a clean record and the conflict surfaced at delivery. D-O78 lands the register
# and its harvest at line 6 of P-O0b; D-O79 states the cross-check once, at the
# frame surface, every deferring act reaching it by reference. The head-line
# grammar is check-ledger.py's L19 (live below); the T-18 consumption is
# catalogue-b6's D-B6-16–D-B6-17, asserted from check-spine.sh; the standing
# backstop is CC-H-07, asserted from check-gate.sh.

printf '\n▸ The acceptance-shape register and the deferral cross-check (§2.4 · §8.1; D-O78–D-O79)\n'

ASHEAD='Acceptance shapes: AS-<n> — <acceptance item, one line> (<citation>) — <state> · … | none found'
has "$RULES_SRC" "$ASHEAD" "the §2.4 head exhibit carries the Acceptance shapes line"
has "$FRAME"     "$ASHEAD" "…and so does ba-frame's head-write block"
has "$SKILLS/ba-status/SKILL.md" "$ASHEAD" "…and ba-status's head render"
has "$TPL"       "$ASHEAD" "…and the shipped template is born carrying it"

has "$RULES_SRC" "closed at three: \`standing\`" \
    "the state vocabulary is closed at three (D-O78)"
has "$FRAME" "The state vocabulary is closed at three, and nothing else" \
    "…and ba-frame compiles the closed three"
has "$RULES_SRC" "per-feature acceptance criteria are spec ground" \
    "…the class narrow by ruling — per-feature ACs are spec ground, never harvested"
has "$FRAME" "never harvested here" "…and the carrier refuses them at its own site"
has "$RULES_SRC" "a three-item pass list is three entries" \
    "…item grain: a three-item pass list is three entries (D-O78)"
has "$FRAME" "is **three entries**, each" "…and ba-frame compiles the grain"
has "$RULES_SRC" "the audit's \`OB-<nnn>\` register is per-run and derived" \
    "…the runtime register deliberately disjoint from the audit's (D-O78)"

# the capture — line 6 of the pinned block, one render one reply
has "$RULES_SRC" "6. Acceptance shapes: <AS-<n> — <acceptance item, one line> (<citation>), per harvested item> | none found" \
    "§8.1's pinned P-O0b block carries line 6 (D-O78)"
has "$FRAME" "6. Acceptance shapes: <AS-<n> — <acceptance item, one line> (<citation>), per harvested item> | none found" \
    "…and ba-frame's block renders it verbatim"
has "$RULES_SRC" "AS-? — <candidate, one line> (<citation>) — keep or discard" \
    "…an ambiguous candidate asked inside the block, never guessed"
has "$FRAME" "AS-? — <candidate, one line> (<citation>) — keep or discard" \
    "…and the carrier asks it in the same single Frame reply"
has "$FRAME" "AS confirmation is BA-only under any grant" \
    "…confirmation BA-only under any grant — P-O0b's safety-floor standing"
has "$FRAME" "re-asserts any \`accepted\`" \
    "…mid-band: a newly standing entry re-asserts an accepted finding (D-O78)"

# the cross-check — stated once, at the frame surface; the four deferring acts
has "$RULES_SRC" "No act that postpones or excludes scope completes silently against a \`standing\`" \
    "the cross-check is stated once, at §8.1 (D-O79)"
has "$FRAME" "No act that postpones or excludes scope completes" \
    "…and ba-frame is its compiled home"
for CLAUSE in "allocated or held outside the delivery boundary" \
              "slide-down candidate" "SD-directed trim" "fence row"; do
  has "$FRAME" "$CLAUSE" "…the deferring acts named: $CLAUSE"
done
has "$FRAME" "never a block at the act, and never silence" \
    "…a match a named cited finding — never a block, never silence (D-O79)"
has "$FRAME" "renders in
**T-18 — Scope allocation**'s existing step-4 decision list" \
    "…rendering in T-18 — Scope allocation's existing step-4 decision list"
has "$FRAME" "never by editing
its sheet" "…a fence row reached by the principle, never by editing its sheet"
has "$FRAME" "records **\`superseded — SD-<n>\`**" \
    "…the supersession law: the SD is the later negotiated statement"
has "$FRAME" "no finding fires again for that item" \
    "…and no finding fires again once the conflict is ruled"
has "$FRAME" "**CC-H-07** holds every unruled
standing conflict as a **live H gap**" \
    "…the standing backstop is the gate's CC-H-07 (D-O79)"
has "$FRAME" "the record is the ruling itself" \
    "…and a ruled conflict is not a gap"
has "$FRAME" "no new stop, no new event kind, no threshold" \
    "…with no new prompt point, stop, event kind or threshold"

# live: the register's grammar, against the validator
printf '\n  the ledger validator, live:\n'
AS_ANCHOR='Acceptance shapes:        none found'
mutate "$B" "$M/as-ok.md" "$AS_ANCHOR" \
  "Acceptance shapes:        AS-1 — booking works end-to-end (rfp.md §9) — standing · AS-2 — reminders fire (rfp.md §9) — superseded — SD-2 · AS-3 — admin can export (rfp.md §9) — accepted — client defers reporting — revisit: phase-2 kickoff"
if python3 "$HERE/check-ledger.py" "$M/as-ok.md" > "$TMP/as.out" 2>&1; then
  ok "L19 the register validates — a standing item, a superseded one, an accepted one (D-O78)"
else
  bad "L19 a legal register does not validate:"; sed 's/^/      /' "$TMP/as.out"
fi

if python3 "$HERE/check-ledger.py" "$B" > "$TMP/as0.out" 2>&1; then
  ok "…and \`none found\` is a legal, recorded value — unlike the cross-cutting line"
else
  bad "L19 rejects \`none found\`, which the ruling makes legal:"; sed 's/^/      /' "$TMP/as0.out"
fi

mutate "$B" "$M/as-state.md" "$AS_ANCHOR" \
  "Acceptance shapes:        AS-1 — booking works end-to-end (rfp.md §9) — noted"
neg "L19 a state outside the closed three" "$M/as-state.md" L19

mutate "$B" "$M/as-cite.md" "$AS_ANCHOR" \
  "Acceptance shapes:        AS-1 — booking works end-to-end — standing"
neg "L19 a harvested item with no verbatim citation" "$M/as-cite.md" L19

mutate "$B" "$M/as-sd.md" "$AS_ANCHOR" \
  "Acceptance shapes:        AS-1 — reminders fire (rfp.md §9) — superseded"
neg "L19 \`superseded\` naming no SD — the supersession is never silent" "$M/as-sd.md" L19

mutate "$B" "$M/as-reason.md" "$AS_ANCHOR" \
  "Acceptance shapes:        AS-1 — admin can export (rfp.md §9) — accepted"
neg "L19 \`accepted\` carrying no reason — a decline is a record" "$M/as-reason.md" L19


# ── 5h. the export teeth, the design guide, and the none-stated boundary ────
#
# D-O75 · D-O76 · D-O77. The title block's third line and the generation
# summary's naming are §10.5's; `/ba-design` is §10.8's whole section; the
# none-stated boundary line is the D-O71 pattern at the title block. The
# rendering behaviour itself is check-wbs.sh's, against seeded frames.

printf '\n▸ The carry, the design guide and the none-stated boundary (§10.5 · §10.8; D-O75–D-O77)\n'

has "$RULES_SRC" 'Cross-cutting: <class>: <value> (XO-<n>) · … | none stated' \
    "§10.5's title block pins the third line (D-O75)"
has "$SKILLS/ba-wbs/SKILL.md" 'Cross-cutting: <class>: <value> (XO-<n>) · … | none stated' \
    "…and ba-wbs renders it"
has "$RULES_SRC" "the language default itself never renders here" \
    "…the engagement default never reaching the export — client ground only"
has "$SKILLS/ba-wbs/SKILL.md" "The language default itself never renders here" \
    "…and the carrier refuses it too"
has "$RULES_SRC" "names every register entry not in a terminal state" \
    "…the generation summary naming every non-terminal entry (D-O75)"
has "$SKILLS/ba-wbs/SKILL.md" "names every \`Cross-cutting:\` register entry not in a terminal state" \
    "…and ba-wbs carries the summary rule"
has "$RULES_SRC" "the export never blocks" "…and the export never blocks — read-only, any time"
has "$SKILLS/ba-wbs/SKILL.md" "the export never blocks" "…in the carrier as well"

has "$RULES_SRC" 'Delivery boundary: none stated · generated <date>' \
    "§10.5 pins the none-stated boundary line (D-O77)"
has "$SKILLS/ba-wbs/SKILL.md" 'Delivery boundary: none stated · generated <date>' \
    "…and ba-wbs renders it where no boundary stands"
has "$RULES_SRC" "never an empty value" "…never an empty value — the D-O71 pattern at the line it governs"

has "$RULES_SRC" "### 10.8 The design-guide export" "§10.8 exists — the design guide's own section (D-O76)"
DESIGN="$SKILLS/ba-design/SKILL.md"
if [ ! -f "$DESIGN" ]; then
  bad "the /ba-design skill is missing — §10.8 has no carrier"
else
  ok "/ba-design is registered — §10.8's carrier"
  head -6 "$DESIGN" | grep -qx 'name: ba-design' \
    && ok "…frontmatter name matches the directory" || bad "…frontmatter name does not match"
  head -6 "$DESIGN" | grep -qx 'disable-model-invocation: true' \
    && ok "…BA-invoked, never auto-fired (D-P2-2)" || bad "…missing disable-model-invocation"
  has "$DESIGN" "exports/design-guide.md" "…it emits exports/design-guide.md"
  has "$RULES_SRC" "\`exports/design-guide.md\`" "…and §10.8 names the same destination"
  has "$DESIGN" "Extraction only, never interpretation" "…extraction only, every entry cited"
  has "$DESIGN" "Client provided none — no palette, visual reference or brand constraint stands" \
      "…and the pinned none-record renders: silence impossible"
  has "$RULES_SRC" "Client provided none — no palette, visual reference or brand constraint stands" \
      "…the same record §10.8 pins"
  has "$DESIGN" "is out of scope by ruling" "…the consumption format out of scope by ruling"
  has "$PKG_ROOT/payload/mirror/claude-block.md" "\`/ba-design\`" \
      "…and the mirror's command surface names it"
fi


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
           "## 20. Review record" "## 21. Review record"; do
  grep -qF -- "$sec" "$RULES_DOC" \
    && ok "the document carries \`$sec\`" \
    || bad "the document is missing \`$sec\` — referenced but absent"
done

# §10.3's two amended rules, in the document that owns them
has "$RULES_DOC" "An acknowledgement-only stop is a banned render" \
    "§10.3 rule 7 carries the banned-render clause (D-O30)"
has "$RULES_DOC" "WBS export §10.5, route render §10.6," \
    "§10.3 rule 8's pinned-formats list names the WBS export and the route render"
has "$RULES_DOC" "band-boundary report §10.7, mid-grant stop report §10.7, resumption report §10.7" \
    "…and both §10.7 renders, the boundary report ahead of the resumption report (D-O52)"
has "$RULES_DOC" "v0.13" "the change-record stack keeps the edition WS-2 produced"
has "$RULES_DOC" "D-O30–D-O34" "…and the decisions it ruled"
has "$RULES_DOC" "v0.14" "…and the edition WS-3 produced"
has "$RULES_DOC" "D-O35–D-O39" "…and the WS-3 ruling block"
has "$RULES_DOC" "D-O40–D-O41" "…and the two locked amendments it carries"
has "$RULES_DOC" "v0.15" "…and the edition the scope frame produced"
has "$RULES_DOC" "D-O42–D-O44" "…and the scope-frame ruling block"
has "$RULES_DOC" "v0.16" "…and the edition the four-act floor row produced"
has "$RULES_DOC" "v0.24" "…and the edition the export-ends-at-Phase ruling produced"
has "$RULES_DOC" "v0.25" "…and the edition the readable-capture clause produced"
has "$RULES_DOC" "D-O61–D-O64" "…and the AUTO-mode fix set's ruling block"
has "$RULES_DOC" "v0.26" "…and the edition the AUTO-mode fix set produced"
has "$RULES_DOC" "D-O65–D-O67" "…and the scope-decision + §10.5 ruling block"
has "$RULES_DOC" "v0.27" "…and the edition the scope-decision harvest produced"
has "$RULES_DOC" "D-O68–D-O71" "…and the advisory-register + excluded-source ruling block"
has "$RULES_DOC" "v0.28" "…and the edition the standing-advisory register produced"
has "$RULES_DOC" "D-O72–D-O77" "…and the cross-cutting-register + language-unit ruling block"
has "$RULES_DOC" "v0.29" "…and the edition cross-cutting obligations first-class produced"
has "$RULES_DOC" "D-O78–D-O79" "…and the acceptance-register + cross-check ruling block"
has "$RULES_DOC" "## 33. Review record (v0.29 → v0.30)" \
    "…and §33, the review record that carries it"
has "$RULES_DOC" "v0.30" "…and the edition the acceptance-shape register produced"
has "$RULES_DOC" "D-O80–D-O81" "…and the listing-corpus + corpus-declaration ruling block"
has "$RULES_DOC" "## 34. Review record (v0.30 → v0.31)" \
    "…and §34, the review record that carries it"
has "$RULES_DOC" "v0.31" "…and the edition the corpus-declaration rule produced"
has "$RULES_DOC" "D-O82" "…and the stop-point closing-ask ruling"
has "$RULES_DOC" "## 35. Review record (v0.31 → v0.32)" \
    "…and §35, the review record that carries it"
has "$RULES_DOC" "v0.32" "…and the edition the stop-point closing ask produced"
has "$RULES_DOC" "D-O83–D-O84" "…and the profile-debt + precondition ruling block"
has "$RULES_DOC" "## 36. Review record (v0.32 → v0.33)" \
    "…and §36, the review record that carries it"
has "$RULES_DOC" "v0.33" "…and the edition expected profile debt produced"
has "$RULES_DOC" "D-O85–D-O88" "…and the undefined-cases ruling block"
has "$RULES_DOC" "## 37. Review record (v0.33 → v0.34)" \
    "…and §37, the review record that carries it"
has "$RULES_DOC" "D-O89" "…and the humanizer-vendoring ruling"
has "$RULES_DOC" "## 38. Review record (v0.34 → v0.35)" \
    "…and §38, the review record that carries it"
has "$RULES_DOC" "D-O90" "…and the Slack-item-never-folded ruling"
has "$RULES_DOC" "## 39. Review record (v0.35 → v0.36)" \
    "…and §39, the review record that carries it"
has "$RULES_DOC" "D-O91" "…and the pinned-tails ruling"
has "$RULES_DOC" "## 40. Review record (v0.36 → v0.37)" \
    "…and §40, the review record that carries it"
has "$RULES_DOC" "D-O92" "…and the edit-discipline-by-class ruling"
has "$RULES_DOC" "## 41. Review record (v0.37 → v0.38)" \
    "…and §41, the review record that carries it"
has "$RULES_DOC" "## 42. Review record (v0.38 → v0.39)" \
    "…and §42, the review record that carries it"
has "$RULES_DOC" "D-O93–D-O96" "…and the dev-ready ruling block"
has "$RULES_DOC" "## 43. Review record (v0.39 → v0.40)" \
    "…and §43, the review record that carries it"
has "$RULES_DOC" "D-O97" "…and the humanizer-switch ruling"
has "$RULES_DOC" "v0.40" "…and the edition the humanizer switch produced"
has "$RULES_DOC" "D-O98" "…and the fence-condition ruling"
has "$RULES_DOC" "## 44. Review record (v0.40 → v0.41)" \
    "…and §44, the review record that carries it"
has "$RULES_DOC" "D-O99–D-O101" "…and the boundary-coverage ruling block"
has "$RULES_DOC" "## 45. Review record (v0.41 → v0.42)" \
    "…and §45, the review record that carries it"
has "$RULES_DOC" "D-O102" "…and the change-route ruling"
has "$RULES_DOC" "## 46. Review record (v0.42 → v0.43)" \
    "…and §46, the review record that carries it"
has "$RULES_DOC" "D-O103" "…and the execution-mechanism ruling"
has "$RULES_DOC" "## 47. Review record (v0.43 → v0.44)" \
    "…and §47, the review record that carries it"
head -2 "$RULES_DOC" | grep -q 'v0\.44' \
  && ok "the header states the live edition — v0.44, the procedure is the skill" \
  || bad "the header does not name v0.44: the edition and the change record disagree"
has "$RULES_DOC" "D-O45–D-O49" "…and the source-inventory ruling block"
has "$RULES_DOC" "D-O50" "…and the change record names the unreadable-spec ruling"
has "$RULES_DOC" "D-O51–D-O52" "…and the continuity-under-a-grant ruling block"
has "$RULES_DOC" "v0.19" "…and the edition continuity under a grant produced"
has "$RULES_DOC" "D-O53" "…and the candidate-scan ruling"
has "$RULES_DOC" "v0.20" "…and the edition the candidate scan produced"
has "$RULES_DOC" "D-O54" "…and the scan-method ruling"

# the ruling block is contiguous from the live high-water mark: no gap, no reuse
python3 - "$RULES_DOC" <<'PYX' && ok "the D-O block runs 1…103 with no gap and no skipped number" \
  || bad "the D-O decision block is not contiguous — a number is missing or reused"
import re, sys
seen = {int(n) for n in re.findall(r"D-O(\d+)", open(sys.argv[1], encoding="utf-8").read())}
sys.exit(0 if seen == set(range(1, 104)) else 1)
PYX

# ── 6b. Band-2 plan composition — the record home has its producer (D-O55) ──
#
# The Blackthorn pilot's T-17 dead end: the ba-t17/ba-t18/ba-tier1 self-checks,
# /ba-run's route resolution and §6.4's "§8.1 and §8.3 define the acts" all
# presupposed a composed `## Band 2` plan while no act composed one. D-O55
# makes `/ba-aspect band2` the seventh, non-aspect argument — §6.1's snapshot
# with two substitutions, the stop at P-O2, the record under `## Band 2`.

printf '\n▸ Band-2 plan composition — /ba-aspect band2 (§8.3; D-O55)\n'

B2DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
has "$B2DOC" "Plan composition — P-O2, the seventh \`/ba-aspect\` argument (D-O55)" \
    "§8.3 opens on the composition bullet — the record home has its producer"
has "$B2DOC" "the \`Band 2\` header in place of the aspect" \
    "…§6.1's shape, substitution one — the header"
has "$B2DOC" "roadmap-state hole** in place of the AT-ID" \
    "…substitution two — the roadmap-state hole; no separate Band-2 shape"
has "$B2DOC" "its plan composable at \`/ba-aspect band2\`" \
    "§8.2's Effects line names the act at the door"
has "$B2DOC" "the section's plan is never the framework's to write" \
    "§6.2 reaches the non-aspect section"
has "$B2DOC" "an aspect's, or \`## Band 2\`'s (§8.3) — or the BA re-plans" \
    "§10.1's P-O2 trigger widened in its own cell, no row added"
has "$B2DOC" "the one plan line the framework composes without a BA act" \
    "§8.1 names the single exception — the canvas-absent Frame line, D-O40-qualified"
has "$SKILLS/ba-aspect/SKILL.md" "or \`band2\`, the seventh, non-aspect value" \
    "ba-aspect's argument line carries the seventh value"
has "$SKILLS/ba-aspect/SKILL.md" "Not closed → stop and name \`/ba-close-band1\`" \
    "…the fork's one precondition is the band's own door"
has "$SKILLS/ba-aspect/SKILL.md" "reaches the fork unchanged: you never compose" \
    "…and the never-list reaches the fork unchanged"
has "$SKILLS/ba-close-band1/SKILL.md" "The next act is \`/ba-aspect band2\` (P-O2 — plan composition)" \
    "ba-close-band1 points Band 2 unlocked at the checkpoint"
has "$SKILLS/ba-close-band1/SKILL.md" "never seeds the" \
    "…and never seeds the plan"
has "$AG" "(\`band2\` for the section)" \
    "the orchestrator agent's P-O2 row reaches the band2 case"

# ── 6c. the shape-guard set (D-O56–D-O59) ────────────────────────────────────
#
# Field defect, 16 Aug 2026: a T-18 run under a standing AG wrote its allocation
# heading in LEDGER stamp grammar instead of the artifact's own pinned shape.
# The entry was right in substance, landed at its destination, and recorded
# `fulfilled` — and was invisible to every reader of the log it joined. Nothing
# stopped the writer; nothing made a reader say so. These four rulings put a
# guard at each end of the pinned shape and one instrument at the boundary.

printf '\n▸ The shape-guard set — writers keep the shape, readers name the near-miss (D-O56–D-O59)\n'

SGDOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"

# D-O56 — the stamp is a tail on an artifact, never a replacement
has "$SGDOC" "the stamp is an additional tail — never a replacement (D-O56)" \
    "§10.7 states the artifact-side rule beside the ledger's own stamp grammar"
has "$SGDOC" "It replaces no pinned field, reorders none, and drops none" \
    "…the tail replaces, reorders and drops nothing"
has "$SGDOC" "**BA field carries the grantor**" \
    "…and the BA field carries the grantor, not the executor"
has "$SKILLS/ba-t18/SKILL.md" "trigger: <…> · BA: <name> · AUTO (AG-<k>)" \
    "T-18's Output pins the AG variant of the heading"
has "$SKILLS/ba-t18/SKILL.md" "Never the ledger's stamp grammar." \
    "…and names the wrong form it replaces"
has "$SKILLS/ba-t18/references/example.md" "· BA: Y.K. · AUTO (AG-1)" \
    "…and the reference example shows a run under a grant"

# D-O57 — fulfillment answers for the shape, stated once and reached by reference
has "$SGDOC" "the pinned shape, not the content alone (D-O57)" \
    "§6.3 states what fulfillment requires — the skill's own pinned output shape"
has "$SGDOC" "A shape divergence is a contract miss:" \
    "…a divergence is a miss: the run stops and reports"
has "$SGDOC" "never records \`fulfilled\`**, nor downgrades to \`partial\`" \
    "…never fulfilled, and never partial"
has "$SGDOC" "**The rule is stated here, once.**" \
    "…stated once, so the compiled checks can reach it by reference"
has "$SGDOC" "in the skill's pinned output shape** (§6.3 — D-O57" \
    "§7.3's fulfillment row cites the rule rather than restating it"
has "$SGDOC" "it fires at run end — not here (D-O57)" \
    "§7.1 carries the law by reference and keeps its invocation-only sentence"

# The compiled carriers: the rule reaches every skill that books fulfillment,
# and reaches it as a citation. A restatement would be a second law.
sg_n=0; sg_bad=""
for f in "$SKILLS"/*/SKILL.md; do
  grep -qF "contract: fulfilled" "$f" || grep -qF "Book contract fulfillment" "$f" || continue
  if grep -qF "orchestrator §6.3" "$f"; then sg_n=$((sg_n + 1)); else sg_bad="$sg_bad $(basename "$(dirname "$f")")"; fi
done
[ -z "$sg_bad" ] \
  && ok "every skill that books fulfillment cites §6.3 — $sg_n carriers, all by reference" \
  || bad "skills book fulfillment without reaching the shape rule:$sg_bad"

# D-O58 — the reader names the near-miss
has "$SGDOC" "A reader that meets a near-miss names it — it never renders absence (D-O58)" \
    "§10.4 states the near-miss law as the general rule"
has "$SGDOC" "the **path**, the **line as authored**, and the **shape expected**" \
    "…naming path, the line as authored, and the shape expected"
has "$SGDOC" "Never \`roadmap missing\`" \
    "…application one: the allocation log, never rendered as an absent roadmap"
has "$SGDOC" "counted off-shape and named" \
    "…application two: brief §6 rows counted off-shape, never silently skipped"
has "$SGDOC" "**The reader reports; it never repairs.**" \
    "…and naming is a render — no reader edits the line it names"
has "$SGDOC" "allocation log unreadable: <a> entr" \
    "§10.4's pinned render carries the near-miss continuation on line 2"
has "$SGDOC" "off-shape <f>: first" \
    "…and on line 4"

# D-O59 — the fifth line, and D-O52 amended on the record rather than rewritten
has "$SGDOC" "Health refresh: <current | overdue: <r> runs vs cadence>" \
    "§10.7's band-boundary report carries the health line"
has "$SGDOC" "five lines, not four" \
    "…and says so: the report is five lines"
has "$SGDOC" "computed exactly as §10.4 line 5 computes it" \
    "…computed from line 5's own computation, so the two cannot disagree"
has "$SGDOC" "The refresh **act** stays \`/ba-gate-health\`'s" \
    "…display only: the refresh act is not the grant's"
grep -qF 'Four lines: the boundary with its AUTO stamp' "$SGDOC" \
  && ok "D-O52's locked row is untouched — amended on the record, never rewritten" \
  || bad "D-O52's row was edited: a locked row is amended by a later row, not in place"

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

# ── EC-18 · expected profile debt (D-O83) and declared preconditions (D-O84) ──
#
# B5: a compliant Presale run always waives Requirements, because AT-RQ-1's
# artifacts are T-11/T-12/T-13/T-15 output and all four are out of profile. The
# waiver is the profile's arithmetic, and the run used to re-argue it at every
# surface. B7: electing T-12 silently pulled in two artifacts nobody declared.
# What must stay true: the class exists and the rendering changes; the *arming*
# does not; the threshold does not bend; the election renders, and never blocks.

printf '\n▸ EC-18 — expected profile debt and declared preconditions (D-O83 · D-O84)\n'

has "$RULES_DOC" "### 4.5 Expected profile debt" \
    "§4.5 exists — the class lives with the instrument it classifies"
has "$RULES_DOC" "resolves to an artifact whose producing technique is **out of profile**" \
    "…and the test is mechanical: every named miss, out-of-profile producer"
has "$RULES_DOC" "One miss resolving to an in-profile technique's artifact takes the whole waiver out of the class" \
    "…and one in-profile miss takes the waiver out of the class"
has "$RULES_DOC" "**The record is the AW, unchanged.**" \
    "…and the record stays the AW — no fourth instrument"
has "$RULES_DOC" "re-litigated at no surface it touches" \
    "…and the class is argued at no surface"
has "$RULES_DOC" "**The arming stands (§8.2).**" \
    "…and the arming stands — expected is not absent"
has "$RULES_DOC" "arm over the gap and keep policing it" \
    "…CC-H-01 and CC-H-05 keep policing what the waiver names"
has "$RULES_DOC" "**Expected profile debt (D-O83, §4.5).**" \
    "§3.3 cites the class rather than carrying a third locked note"
has "$RULES_DOC" "**The criterion itself does not bend:** thresholds are profile-blind" \
    "…and the threshold stays profile-blind — the waiver bends, never AT-RQ-1"
has "$RULES_DOC" "**Where every named miss on an aspect resolves to an out-of-profile technique's artifact, that waiver is expected profile debt (§4.5, D-O83)**" \
    "§6.5's Presale paragraph names the class beside its own 'not an anomaly'"
has "$RULES_DOC" "**Declared preconditions render at the election (D-O84).**" \
    "§6.1 carries the precondition rule"
has "$RULES_DOC" "Preconditions open: <technique — artifact (producer), hard|soft: what it grounds>" \
    "…and the snapshot block gains exactly one pinned line"
has "$RULES_DOC" "**Never a block.** A missing precondition does not refuse the run" \
    "…visibility, never a block"
has "$RULES_DOC" "**Never a silent pull-in.** Electing a technique elects **that** technique." \
    "…and electing a technique never elects its producer"

# the compiled card is the load-bearing consequence of homing D-O83 in §4.5:
# a §3.3 note would have travelled into it and check-cards.py would have to grow
python3 "$HERE/check-cards.py" >/dev/null 2>&1 \
  && ok "the compiled at-thresholds card is untouched by this edition" \
  || bad "the at-thresholds card diverged — a §3.3 note travelled into it"

# the killed behaviour, stated as a refusal the document must not contain
hasnt "$RULES_DOC" "AT-RQ-1 is relaxed under Presale" \
    "no surface relaxes AT-RQ-1 under a profile"

# ── EC-19 · the undefined cases get law (D-O85 · D-O86 · D-O87 · D-O88) ─────
#
# Three places the law stopped short and a live run finished the sentence for
# it, plus one discipline stated in template commentary and nowhere in law.
# B9-residual: a listing cut at page three had to decide for itself what a
# partial corpus may ground. B10: a run halted at a safety floor, and again at
# its own scope edge, and improvised a render twice in one session. B12: the
# report demanded the full trail from a BA who had already ratified. B8's
# routed half: the ledger edit discipline had no rule to cite.
#
# What must stay true: a positive survives a cut and a negative never does;
# both untethered stops have one render and it carries the closing ask; the
# trail's conditional is the shape's own, and rule 8's precedence is untouched;
# the ledger rule is law and its enforcing check is named, not claimed built.

printf '\n▸ EC-19 — the interrupted listing, the two untethered stops, the trail (D-O85–D-O88)\n'

# R1 · D-O85 — the interrupted listing, and its asymmetry
has "$RULES_DOC" "**The interrupted listing (D-O85" \
    "D-O85 exists — the case D-O80 left open is ruled"
has "$RULES_DOC" "yields a **partial corpus**, and the partial corpus is a **sample** in D-O81" \
    "…and a cut listing is a sample in D-O81's own sense"
has "$RULES_DOC" "**A positive finding stands.** A hit is a hit" \
    "…a positive survives the cut — the field improvisation, now the rule"
has "$RULES_DOC" "**never renders over a cut listing**" \
    "…and the no-match line never renders over one"
has "$RULES_DOC" "**The count line withholds with it.**" \
    "…and the count line withholds with it (D-O54 applied, not new law)"
has "$RULES_DOC" 'renders unchanged**: it states what the scan itself removed' \
    "…while the excluded-count line renders — it states the scan's own act"
has "$RULES_DOC" "**The cut renders — it is never silent.**" \
    "…and the cut is declared, never passed over"
has "$RULES_DOC" "**Retry before you render (D-O85).**" \
    "…a retryable cut is retried before anything renders"
has "$RULES_DOC" "**This is the declaration grammar, not an extension of it.**" \
    "…and the ruling instances D-O81's grammar rather than extending it"
# the killed states, as refusals the document must not contain
hasnt "$RULES_DOC" "a partial listing may render the coverage line" \
    "no path lets a partial listing fill the coverage line"
for c in "$RULES_SRC" "$FRAME"; do
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  has "$c" "$CUT_LINE" "the interrupted line is pinned identically — $lbl (D-O85 render delta)"
  has "$c" "$COUNT_LINE" "…and the count line renders only over a completed listing — $lbl (D-O85)"
done
has "$FRAME" "**A listing cut before completion yields a partial corpus.**" \
    "ba-frame carries the interrupted branch operationally (D-O85)"
has "$FRAME" "**Never convert a cut into a negative.**" \
    "…and never converts a cut into a negative"

# R2 · D-O86 — one render for the two untethered stops
has "$RULES_DOC" "**The mid-grant stop report — a pinned shape (D-O86" \
    "D-O86 exists — the two untethered hold conditions have a render"
has "$RULES_DOC" "Auto paused — <date> · <safety floor: <act — code + name> | scope exhausted:" \
    "…and the shape names its event on the first line"
has "$RULES_DOC" "Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>" \
    "…and its last line carries the resumption act and the grant's standing"
has "$RULES_DOC" "**Four lines, and the D-O82 closing ask follows as the tail that rule already defines**" \
    "…the closing ask follows the four pinned lines, appended not merged"
has "$RULES_DOC" "**§10.3 rule 9's AUTO exemption is amended on the record, never rewritten:**" \
    "…and rule 9's exemption is amended on the record"
has "$RULES_DOC" "**It does not reach the mid-grant stop report (§10.7):**" \
    "…narrowed to the two renders it names"
has "$RULES_DOC" "**§10.7's pinned-shape count moves two → three**" \
    "…and the shape count moves by exactly one"
has "$RULES_DOC" "**at scope exhaustion it reaches no further**" \
    "…scope exhaustion states what it does to the grant"
has "$RULES_DOC" "**D-O69's decision-list tail is not extended to this report.**" \
    "…and the advisory tail is not extended — routed, never inferred"
has "$RULES_DOC" "band-boundary report §10.7, mid-grant stop report §10.7, resumption report §10.7" \
    "…register rule 8's pinned-format list carries all three shapes"
# the killed state: a hold condition with no render
python3 - "$RULES_DOC" <<'PYX' && ok "every D-O51 hold condition names a render — none is left untethered" \
  || bad "a hold condition still has no defined render (D-O86)"
import re, sys
t = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
i = t.index("The run proceeds continuously until exactly one of four events")
holds = t[i:t.index("Why this is a rule and not a preference", i)]
need = ["band-boundary report", "mid-grant stop report", "the same report", "off"]
sys.exit(0 if all(s in holds for s in need) else 1)
PYX

# R3 · D-O87 — the trail after ratification
has "$RULES_DOC" "**The trail after ratification (D-O87" \
    "D-O87 exists — the trail has a conditional"
has "$RULES_DOC" "Auto-trail: <n> acts — ratified in this reply · full trail: .specify/aspect-state.md Events" \
    "…and the collapsed line is its count plus the ledger pointer"
has "$RULES_DOC" "**A ratification that names exceptions renders the full trail.**" \
    "…an exception renders the acts it might except"
has "$RULES_DOC" "**§10.3 rule 8 stands untouched: on conflict between the register and a pinned shape, the shape governs**" \
    "…and the governing rule is stated, never left to inference"
has "$RULES_DOC" "**dissolves it inside the shape**" \
    "…the conflict dissolved inside the shape, not resolved against rule 7"
has "$RULES_DOC" "**The report's line count does not move**" \
    "…and the six-line count does not move"

# R4 · D-O88 — the ledger edit discipline
has "$RULES_DOC" "**The ledger edit discipline (D-O88).**" \
    "D-O88 exists at §2.4 — the ledger grammar's own home"
has "$RULES_DOC" "**Head lines and section headings are edited line-anchored — a full-line match at line start — never by substring search.**" \
    "…and the rule is line-anchored, full-line, never substring"
has "$RULES_DOC" "a live-ledger edit that lands in commentary is **silent**" \
    "…the hazard is named: a silent edit into commentary"
has "$RULES_DOC" "**Routed to the regression-floor pass, not built by this ruling**" \
    "…and the enforcing check is named unbuilt, never claimed built"
for tpl in aspect-state aspect-plans; do
  TP="$PKG_ROOT/payload/specify-overlay/ba/templates/$tpl.md"
  has "$TP" "D-O88" "$tpl.md cites the rule instead of standing alone (D-O88)"
  has "$TP" "line-anchored" "…and still states the discipline it teaches — $tpl.md"
done

# ── EC-20 · the edit discipline binds by class (D-O92) ───────────────────────
#
# D-O88 ruled the right rule and named two files. Four days later the same act
# — an in-place, substring-anchored edit — took a third file the rule did not
# name: a run's own header note carried the literal heading string its own edit
# then matched, and the rendered table went with it. This block holds the
# widening down at its three load-bearing points: the rule binds by CLASS, the
# ruled instance is named without an enumerated list, and D-O88's own text is
# not rewritten to get there.

printf '\n▸ EC-20 — the edit discipline binds by class (D-O92)\n'

has "$RULES_DOC" "**The rule therefore binds by class: every file a skill rewrites in place that carries section headings or its own commentary.**" \
    "D-O92 binds by class — the act, not a filename"
has "$RULES_DOC" "**\`decision-list.md\` is the ruled instance**" \
    "…and names one ruled instance"
has "$RULES_DOC" "deliberately not enumerated" \
    "…and refuses an enumerated list, on the record"
has "$RULES_DOC" "**What the class excludes is D-O88's own boundary, unchanged:**" \
    "…and keeps D-O88's exclusion: an append has no anchor to get wrong"
has "$RULES_DOC" "**The comment treatment travels with the rule.**" \
    "…and the B8 comment treatment travels with it"
has "$RULES_DOC" "names its sections without reproducing the literal heading strings" \
    "…a note names its sections, never quotes their heading strings"
has "$RULES_DOC" "**D-O92 enlarges that check's subject and does not build it either**" \
    "…and the enforcing check stays named-and-unbuilt, never claimed built"
has "$RULES_DOC" "amended on the record, never rewritten" \
    "…and D-O88's reach is amended on the record"

# the ruled instance's own author carries the discipline, cited not restated
AUDIT_SKILL="$PKG_ROOT/payload/claude/skills/ba-audit/SKILL.md"
has "$AUDIT_SKILL" "**The write-back is line-anchored**" \
    "the decision-list author edits line-anchored (D-O92)"
has "$AUDIT_SKILL" "**D-O88 · D-O92**" \
    "…citing the rule at §2.4 rather than restating it"
has "$AUDIT_SKILL" "**And any note this file carries names its sections without reproducing their" \
    "…and its own note never quotes its section headings"
grep -q '^## As ruled' "$AUDIT_SKILL" \
  && bad "the decision-list author re-embeds a literal heading string — the B8 hazard, authored" \
  || ok "…and no authored heading string stands at line start in the skill that writes the file"


# ── EC-20 · the fence names its condition (D-O98) ────────────────────────────
#
# The other half of the same field run, landing as the parked EC-20 rebase under
# its next-free numbers (0.1.42 reserved D-O93 · §42; v0.39 re-routed that and
# 0.1.43/0.1.44 took D-O93–D-O97 · §42–§43). Stage 4 routes spec edits to a
# `ba-analyst` dispatch; the persona's own file forbade every dispatch, and
# fourteen ruled rows closed `unexecuted`. D-S7 gave the ROUTE its law. This
# block holds the FRAMEWORK half, which D-S space cannot own: D-O16's
# reservation stated as a condition rather than a census, the qualifying test
# answered by the route's own law, the count kept at persona grain, the two
# undispatchable personas fenced by construction, and the split against D-S7.

printf '\n▸ EC-20 — the fence names its condition (D-O98)\n'

ANALYST_AG="$PKG_ROOT/payload/claude/agents/ba-analyst.md"
DISCOVERY_AG="$PKG_ROOT/payload/claude/agents/ba-discovery.md"
AUDIT_DEF="$PKG_ROOT/docs/methodology/ba-native-spec-source-audit-definition.md"
AUDIT_SK="$PKG_ROOT/payload/claude/skills/ba-audit/SKILL.md"

# the ruling, at its home — §11, amending the reservation clause on the record
has "$RULES_DOC" "**The reservation is a condition, not a census (D-O98).**" \
    "D-O98 lives at §11 — the clause it amends, not a new section"
has "$RULES_DOC" "dispatchable **only as a batch author executing an already-ruled route**" \
    "…and states the condition, not a list of permitted callers"
has "$RULES_DOC" "never for any act that would stop and take a BA decision" \
    "…with the half that keeps D-O16's reason intact"
has "$RULES_DOC" "**Interactive composition stays a compile source**" \
    "…and interactive composition is untouched"
has "$RULES_DOC" "nothing about how a persona writes changes under dispatch" \
    "…and the dispatch changes the caller, never the author"
has "$RULES_DOC" "the count is at persona grain, never at caller grain" \
    "…the count is declared at persona grain — \`ba-gate\` has three callers"
has "$RULES_DOC" "**\`ba-orchestrator\` and \`ba-discovery\` stay undispatchable**" \
    "…and the two that stay fenced are named"
has "$RULES_DOC" "not by exemption: each conducts or executes work that **contains** a ruling" \
    "…fenced by construction, never by exemption"
has "$RULES_DOC" "**D-O16's ruling text is byte-untouched**" \
    "…and D-O16 is amended on the record, never rewritten"

# the enumeration must never BE the definition — the defect D-O98 itself names.
# A route qualifies by ITS OWN law; §11 keeps no list of permitted callers, so a
# second post-ruling batch route is lawful the day its document says so.
has "$RULES_DOC" "**A route qualifies where its own law establishes it as post-ruling and batch-shaped**" \
    "the qualifying test is the route's own law, not a list at §11"
has "$RULES_DOC" "never by an enumeration kept at §11" \
    "…and §11 says so of itself — a second route needs no amendment here"
has "$AUDIT_DEF" "**That is how a route qualifies at all**" \
    "…and the route's own document says it is the thing that qualifies it"
for f in "$ANALYST_AG" "$AG"; do
  grep -q "A route qualifies where its own law establishes it as" "$f" \
    || bad "${f##*/} states the route as a definition, not as an instance of the test"
done
ok "…and both dispatch-bearing personas carry the test, not a named route alone"
CENSUS=0
for f in "$ANALYST_AG" "$AG" "$DISCOVERY_AG" "$RULES_DOC" "$AUDIT_DEF" "$AUDIT_SK"; do
  grep -q "the one route that qualifies is" "$f" && { CENSUS=$((CENSUS + 1)); printf '      census: %s\n' "${f##*/}"; }
done
[ "$CENSUS" -eq 0 ] \
  && ok "…and no carrier defines the permission by naming its one current route" \
  || bad "$CENSUS carrier(s) define the condition as a census — the defect D-O98 diagnoses"

# the reconciliation against D-S7 — one act, two documents, no second copy
has "$RULES_DOC" "**The condition is this document's; a route's own law is its own document's.**" \
    "the split against D-S space is stated at this end"
has "$RULES_DOC" "cited here and **never restated**" \
    "…and this document carries no copy of the route's law"
has "$AUDIT_DEF" "**One act, two documents, and the split is by subject.**" \
    "…and the split is stated at the other end too"
has "$AUDIT_DEF" "**orchestrator §11 (D-O98)**" \
    "…the audit definition names the permission it relies on"
has "$AUDIT_DEF" "**This document owns the route:**" \
    "…and claims only the route, never the condition"
grep -q 'v0\.4 · the repair route becomes executable' "$AUDIT_DEF" \
  && ok "…and the audit definition stands at v0.4 — a citation is not a rule" \
  || bad "the audit definition bumped for a citation: D-S7 was reopened to carry a reference"

# the compiled personas — one rule, three fences, two dispositions
has "$ANALYST_AG" "**The fence is a condition, not a census (D-O98).**" \
    "the analyst carries the condition in its body"
has "$ANALYST_AG" "the fence is a condition, not a census (D-O98)" \
    "…and in the frontmatter a dispatcher actually reads"
has "$ANALYST_AG" 'a route qualifies only where its own law establishes it as post-ruling and batch-shaped' \
    "…and a route qualifies by its own law, never by a list kept in the fence"
has "$ANALYST_AG" 'Today exactly one route does: /ba-audit' \
    "…with this route an instance of the test, marked as today's and not the definition"
has "$ANALYST_AG" '**compiled into** `ba-tier2`' \
    "…and no longer claims \`ba-tier2\` dispatches it"
has "$ANALYST_AG" "The \`ba-gate\` agent is this same condition on the" \
    "…and the analyst names the gate as its model"
has "$AG" "**The reservation is a condition, not a census (D-O98).**" \
    "the orchestrator persona compiles §11's amended clause"
has "$AG" "two personas** meet it" \
    "…and carries the persona-grain count, not the old one-instance line"
has "$AG" "unconditionally, and not by exemption" \
    "…and its own fence says why it stays unconditional"
has "$DISCOVERY_AG" "unconditionally, and not by exemption" \
    "…and the discovery fence says the same, in its own words"
has "$DISCOVERY_AG" "D-O98's batch-author condition" \
    "…citing the rule rather than restating it"

# the three fences state one rule, are NOT byte-identical by ruling, none bare
FENCE_N=0
for f in "$ANALYST_AG" "$AG" "$DISCOVERY_AG"; do
  grep -q 'No skill dispatches it, and none should' "$f" && FENCE_N=$((FENCE_N + 1))
done
[ "$FENCE_N" -eq 3 ] \
  && ok "all three persona fences still carry the sentence — narrowed, never deleted" \
  || bad "$((3 - FENCE_N)) persona fence(s) lost the sentence: rewritten away rather than narrowed"
for f in "$ANALYST_AG" "$AG" "$DISCOVERY_AG"; do
  grep -q 'D-O98' "$f" \
    || bad "${f##*/} states no condition: its fence is still a census"
done
ok "…and every one of the three cites D-O98 — one rule, three fences"
BARE_N=0
for f in "$ANALYST_AG" "$AG" "$DISCOVERY_AG"; do
  grep -q 'none should\.$' "$f" && { BARE_N=$((BARE_N + 1)); printf '      bare: %s\n' "${f##*/}"; }
done
[ "$BARE_N" -eq 0 ] \
  && ok "…and none of the three ends its fence bare — every one states its disposition" \
  || bad "$BARE_N persona fence(s) still terminate bare: the census survives where a reader looks first"

# the caller side: the skill that relies on the permission names it
has "$AUDIT_SK" "**orchestrator D-O98**" \
    "Stage 4 names the framework permission, not only its own exception"
has "$AUDIT_SK" "never stops inside Stage 4 to take a ruling" \
    "…and the never-list fences the act the condition forbids"

# no mirror carries the fence, so no mirror moved — asserted, not assumed
MIRROR_HITS=0
for m in "$PKG_ROOT/payload/mirror/claude-block.md" "$PKG_ROOT/payload/mirror/AGENTS.md"; do
  grep -q 'none should' "$m" && MIRROR_HITS=$((MIRROR_HITS + 1))
done
[ "$MIRROR_HITS" -eq 0 ] \
  && ok "no mirror carries the fence sentence — the carry set is the three personas exactly" \
  || bad "$MIRROR_HITS mirror(s) carry a fence sentence that this ruling did not move"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S4 orchestrator: §12 exhibits ×3 · ledger grammar · 26 seeded defects · P-O1–P-O9\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
