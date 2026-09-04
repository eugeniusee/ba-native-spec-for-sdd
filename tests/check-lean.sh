#!/usr/bin/env bash
#
# BA-Native Spec — the first phase is lean by law (orchestrator rules §8.1 ·
# §2.4 · §48; D-O104–D-O106 · catalogue-b6 D-B6-18–D-B6-20 · elicitation D15).
#
# EC-24: the Nutrivity run's first phase came out wider than the BA's cut with
# every row legitimate — principle 4's second test seated any epic a [stated]
# citation covered — and the QR estate's envelope moved an epic on ground the
# corpus could not reconcile. The rulings retire the money from the frame, make
# necessity the whole seat test, and leave the boundary as the only switch.
# This suite is the regression floor the field note's §5 names, compiled on the
# check-change precedent: the document checked first by its own words so the
# carrier sweep can never go vacuous, then the carriers.
#
#   0.  the document — the lean law, the default sentence, the retirement,
#       each in the three documents' own words
#   1.  the frame — ba-frame's P-O0b block byte-equal to §8.1's, extracted
#       from the document at run time and never restated here; five numbered
#       lines, no Parameters render
#   2.  the money is gone — no Budget: / Parameters: / Capacity: head line in
#       the shipped template, any fixture ledger, or the ba-frame/ba-status
#       renders
#   3.  the advisory — one seat test (the request test retired), the (request)
#       flag present, the capacity forms dead
#   4.  the boundary is the switch — billed rows are the only difference, held
#       by check-wbs.sh's own pinned Billable test, cited not duplicated
#   5.  the default proved as a default — the step-3 default sentence stands,
#       and no carrier names a lean/full mode, parameter or flag
#
#   check-lean.sh              run the suite
#   check-lean.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
B6="$PKG_ROOT/docs/methodology/ba-native-spec-catalogue-b6.md"
ELI="$PKG_ROOT/docs/methodology/ba-native-spec-elicitation-techniques.md"
SKILLS="$PKG_ROOT/payload/claude/skills"
FRAME="$SKILLS/ba-frame/SKILL.md"
T18="$SKILLS/ba-t18/SKILL.md"
STATUS="$SKILLS/ba-status/SKILL.md"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,32p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

has() {
  grep -qF -- "$2" "$1" && ok "$3" || bad "$3 — not found: $2"
}
lacks() {
  grep -qF -- "$2" "$1" && bad "$3 — found what must be absent: $2" || ok "$3"
}
# whitespace-collapsed containment — wrapped prose matches (the check-spine idiom)
flat_has() {
  python3 - "$1" "$2" <<'PY'
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}
fhas()   { flat_has "$1" "$2" && ok "$3" || bad "$3 — not found: $2"; }
flacks() { flat_has "$1" "$2" && bad "$3 — found what must be absent: $2" || ok "$3"; }

# ── 0. the document — the law in its own words, so nothing below is vacuous ──

printf '\n▸ The document — lean by law, the default, the retirement (D-O104–D-O106)\n'

fhas "$DOC" "The first phase is lean by law, and the switch is the boundary (D-O104 · D-O106, §48" \
    "§8.1 carries the lean-law paragraph at the boundary"
fhas "$DOC" "Lean is the default and needs no act (D-O106):" \
    "…with the default sentence — nothing chosen, nothing typed"
fhas "$DOC" "Capacity arithmetic — retired (D-O105, §48" \
    "…and the capacity module retired at its live site"
fhas "$DOC" "an epic earns a first-phase seat on **one ground only**" \
    "…a seat earned on one ground only — the flow cannot complete without it"
fhas "$DOC" "recorded ground and a named candidate, never a seat" \
    "…and a hard request recorded and named, never a seat"

fhas "$B6" "The first phase composes on necessity alone (D-B6-18; orchestrator D-O104), the walking skeleton now the whole of the seat test:" \
    "catalogue-b6 step 3 carries the first-phase law"
fhas "$B6" "Lean needs no act (orchestrator D-O106):" \
    "…with its own default sentence"
fhas "$B6" "tagged \`(request)\` beside its \`ADV-<n>\` id" \
    "…and the (request) flag ruled beside the ADV-<n> id"

fhas "$ELI" "passes the **necessity test**: the stated business goal cannot be reached without it (goal-blocking)" \
    "elicitation principle 4 carries one test — necessity (D15)"
fhas "$ELI" "A hard request the goal does not need is **recorded ground and a named candidate, never a seat**" \
    "…and the request survives as recorded ground, never a seat"

# ── 1. the frame — five lines, byte-equal, extracted at run time ─────────────

printf '\n▸ The frame — ba-frame'"'"'s P-O0b block byte-equal to §8.1'"'"'s five lines\n'

python3 - "$DOC" "$FRAME" "$TMP" <<'PY'
import pathlib, re, sys
doc, frame, tmp = sys.argv[1], sys.argv[2], sys.argv[3]
pat = re.compile(
    r"```\n(Scope frame — before any aspect opens \(P-O0b — scope-frame selection\):\n"
    r".*?Waiting for your confirmation\. Switchable later; the switch is logged\.)\n```",
    re.S)
m = pat.search(pathlib.Path(doc).read_text(encoding="utf-8"))
if not m:
    sys.exit(1)
block = m.group(1)
pathlib.Path(tmp, "block.txt").write_text(block, encoding="utf-8")
sys.exit(0 if block in pathlib.Path(frame).read_text(encoding="utf-8") else 2)
PY
case $? in
  0) ok "ba-frame's block is byte-equal to §8.1's, extracted from the document" ;;
  1) bad "the pinned P-O0b block was not found in §8.1 — the extraction key moved" ;;
  *) bad "ba-frame's P-O0b block diverges from §8.1's — not byte-equal" ;;
esac

if [ -f "$TMP/block.txt" ]; then
  N_NUM=$(grep -cE '^[0-9]+\. ' "$TMP/block.txt")
  [ "$N_NUM" = "5" ] \
    && ok "…and the block carries exactly five numbered lines (found $N_NUM)" \
    || bad "the block carries $N_NUM numbered lines, expected 5"
  grep -q "Parameters" "$TMP/block.txt" \
    && bad "the block still carries a Parameters render" \
    || ok "…with no Parameters render inside it"
  grep -q "Budget" "$TMP/block.txt" \
    && bad "the block still carries a Budget line" \
    || ok "…and no Budget line inside it"
fi

# ── 2. the money is gone — no retired head line anywhere a ledger is shaped ──

printf '\n▸ The head — no Budget: / Parameters: / Capacity: line in any ledger shape\n'

no_money_lines() {  # $1 = file, $2 = label
  if grep -qE '^(Budget|Parameters|Capacity):' "$1"; then
    bad "$2 still carries a retired head line:"
    grep -nE '^(Budget|Parameters|Capacity):' "$1" | sed 's/^/      /'
  else
    ok "$2 carries no Budget: / Parameters: / Capacity: line"
  fi
}

no_money_lines "$TPL"    "the shipped aspect-state template"
no_money_lines "$FRAME"  "ba-frame's head-write render"
no_money_lines "$STATUS" "ba-status's head render"

FX_FOUND=0
while IFS= read -r fx; do
  FX_FOUND=$((FX_FOUND+1))
  no_money_lines "$fx" "fixture ledger ${fx#$PKG_ROOT/}"
done < <(find "$HERE/fixtures" -name 'aspect-state.md' -not -path '*/node_modules/*' | sort)
[ "$FX_FOUND" -ge 1 ] \
  && ok "the fixture-ledger sweep found $FX_FOUND ledger(s) — not vacuous" \
  || bad "the fixture-ledger sweep found no aspect-state.md — vacuous"

# ── 3. the advisory — one seat test, the request a flag, the capacity dead ───

printf '\n▸ The advisory — one seat test, the (request) flag, no capacity form\n'

flacks "$T18" "or (ii)" \
    "ba-t18 carries no lettered second seat test"
flacks "$T18" "hard-requested it in the docs" \
    "…and the request-in-the-docs seat test is gone"
has "$T18" "(request)" \
    "…the (request) flag stands beside the ADV-<n> id"
lacks "$T18" "Capacity check" \
    "…no Capacity check survives in the run"
lacks "$T18" "reason: envelope" \
    "…and no reason: envelope tag has a live site"
fhas "$T18" "without a trace to the **necessity test**" \
    "…the seat test is the necessity test, named at the advisory"
fhas "$T18" "name every hard-requested epic the first phase leaves out in the same list" \
    "…and every left-out request is named in the same list"

# ── 4. the boundary is the switch — billed rows the only difference ──────────

printf '\n▸ The boundary — billed rows the only difference (check-wbs'"'"'s own pin, cited)\n'

# The Billable derivation is already pinned where the export is tested —
# check-wbs.sh section 2b (D-O67 · D-O71): a seeded frame with Boundary:
# MVP + Phase 2, Billable derived Yes inside the boundary and No outside,
# and no Billable cell ever a number. Cited here, not duplicated — this
# assertion fails loudly if that pin is ever dropped.
has "$HERE/check-wbs.sh" "a Phase inside the boundary derives Billable Yes" \
    "check-wbs.sh still pins the Billable derivation (D-O67) — the cited half"
has "$HERE/check-wbs.sh" "no Billable cell carries anything but Yes/No — never a number" \
    "…and still pins that no Billable cell is a number"

# ── 5. the default proved as a default — no mode, no parameter, no flag ──────

printf '\n▸ The default — lean is what happens when the BA does nothing\n'

fhas "$T18" "Lean needs no act (orchestrator D-O106):" \
    "ba-t18 step 3 carries the default sentence"
fhas "$T18" "a run with no directive, no standing SD and the boundary at its default composes exactly this and the proposal bills it" \
    "…nothing chosen, nothing typed — composed and billed"
fhas "$FRAME" "Lean is the default and needs no act (D-O106):" \
    "ba-frame states the default at the boundary's own site"

MODE_HITS="$TMP/mode-hits.txt"
grep -rniE 'lean mode|full mode' "$PKG_ROOT/payload" > "$MODE_HITS" 2>/dev/null
if [ -s "$MODE_HITS" ]; then
  bad "a payload carrier names a lean/full mode:"
  sed 's/^/      /' "$MODE_HITS"
else
  ok "no payload carrier names a lean mode or a full mode — the boundary is the switch"
fi

# ── summary ──────────────────────────────────────────────────────────────────

printf '\n  passed: %d   failed: %d\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the first phase is lean by law: the document, the frame, the advisory, the boundary, the default\n'
  exit 0
else
  printf '✗ RED — %d check(s) failed\n' "$FAILED"
  exit 1
fi
