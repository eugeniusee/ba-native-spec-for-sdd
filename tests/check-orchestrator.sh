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
for spec in "doc|The Slack candidate scan (D-O53, locked).|The profile picker" \
            "skill|The Slack candidate scan — the framework proposes, you dispose.|Then the profile picker"; do
  kind="${spec%%|*}"; rest="${spec#*|}"; start="${rest%%|*}"; stop="${rest#*|}"
  if [ "$kind" = doc ]; then c="$RULES_SRC"; else c="$FRAME"; fi
  lbl="$(basename "$(dirname "$c")")/$(basename "$c")"
  if python3 - "$c" "$start" "$stop" > "$TMP/residual.err" 2>&1 <<'PY'
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
has "$RULES_DOC" "band-boundary report §10.7, resumption report §10.7" \
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
has "$RULES_DOC" "## 31. Review record (v0.27 → v0.28)" \
    "…and §31, the review record that carries it"
head -2 "$RULES_DOC" | grep -q 'v0\.28' \
  && ok "the header states the live edition — v0.28, the standing advisory and the excluded source" \
  || bad "the header does not name v0.28: the edition and the change record disagree"
has "$RULES_DOC" "D-O45–D-O49" "…and the source-inventory ruling block"
has "$RULES_DOC" "D-O50" "…and the change record names the unreadable-spec ruling"
has "$RULES_DOC" "D-O51–D-O52" "…and the continuity-under-a-grant ruling block"
has "$RULES_DOC" "v0.19" "…and the edition continuity under a grant produced"
has "$RULES_DOC" "D-O53" "…and the candidate-scan ruling"
has "$RULES_DOC" "v0.20" "…and the edition the candidate scan produced"
has "$RULES_DOC" "D-O54" "…and the scan-method ruling"

# the ruling block is contiguous from the live high-water mark: no gap, no reuse
python3 - "$RULES_DOC" <<'PYX' && ok "the D-O block runs 1…71 with no gap and no skipped number" \
  || bad "the D-O decision block is not contiguous — a number is missing or reused"
import re, sys
seen = {int(n) for n in re.findall(r"D-O(\d+)", open(sys.argv[1], encoding="utf-8").read())}
sys.exit(0 if seen == set(range(1, 72)) else 1)
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

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S4 orchestrator: §12 exhibits ×3 · ledger grammar · 14 seeded defects · P-O1–P-O9\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
