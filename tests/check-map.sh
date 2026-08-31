#!/usr/bin/env bash
#
# BA-Native Spec — the project map (map definition v0.1, D-M1–D-M7).
#
# `/ba-map` is a render: one installed project, read-only, the §10.4 read
# discipline unchanged. The suite holds down exactly what the definition
# pins — the shape, the two measures, the coverage panels, the verdict rule
# on both of its sides, the HTML law, and that nothing was written.
#
#   1.  the pinned shape — the chat render's lines, in order (§2)
#   2.  dev handoff — the golden counts: compliance (24−W)/24 on the
#       certified feature, `—` never 0% on the ungated one, the risk cells,
#       the handoff answers (§3, D-M2 · D-M3)
#   3.  technique coverage — 16/20 run against the fixture, the dropped row
#       with its recorded reason, the no-record set, custom counted beside
#       (§4, D-M4)
#   4.  command coverage — the evidenced set and the no-record set (§5, D-M5)
#   5.  the verdict rule, both sides — the fixture's own debt reads
#       `questions standing`; a seeded FAIL flips it to `question-heavy`
#       and the feature row to high with its gap count (§6, D-M6)
#   6.  the HTML render — written only on --html, self-contained, zero
#       `<script>`, zero external references, the chat render embedded,
#       regenerated per invocation (§7, D-M7)
#   7.  read-only — the world hashes identical across a chat run; an --html
#       run writes `.specify/map.html` and nothing else (§1, D-M1)
#   8.  the skill and the definition — the pinned shape, the formulas, the
#       never-list and the three standing blocks in the skill; D-M1–D-M7 in
#       the document
#
# The fixture is the §12 estate: the band1/ ledgers over the project/ tree,
# plus a synthetic install manifest (the map reads the edition from it).
# The fixture itself is never written; every run writes into the suite's
# temp dir.
#
#   check-map.sh              run the suite
#   check-map.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
SK="$PKG_ROOT/payload/specify-overlay/ba/scripts"
FX="$HERE/fixtures/appointment-booking"
SKILL="$PKG_ROOT/payload/claude/skills/ba-map/SKILL.md"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-map-definition.md"
PKG_VERSION="$(cat "$PKG_ROOT/VERSION")"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,36p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

has() {
  grep -qF -- "$2" "$1" \
    && ok "$3" \
    || bad "$3 — not found: $2"
}
lacks() {
  grep -qF -- "$2" "$1" \
    && bad "$3 — found what must be absent: $2" \
    || ok "$3"
}
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
joined = re.sub(r"\n(?=\S)", " ", text)
sys.exit(0 if sys.argv[2] in joined else 1)
PY
}

# ── the estate: band1/ ledgers over the project/ tree + a manifest ───────────

make_world() {  # $1 = destination root
  mkdir -p "$1/.specify/ba"
  cp -R "$FX/project/." "$1/"
  cp "$FX/band1/aspect-state.md" "$FX/band1/aspect-plans.md" \
     "$FX/band1/gate-health.md" "$1/.specify/"
  cat > "$1/.specify/ba/manifest.md" <<EOF
# BA-Native Spec — install manifest

| Field | Value |
|---|---|
| Package version | $PKG_VERSION |
| Installed | 2026-07-07 |
EOF
}

WORLD="$TMP/world"
make_world "$WORLD"
(cd "$FX" && find . -type f | sort | xargs shasum) > "$TMP/fx-before.txt"

run_map() {  # $1 = root, rest = extra args; output file on stdout
  local out="$TMP/out-$RANDOM.txt"
  python3 "$SK/sk_map.py" --root "$1" --date 2026-08-31 "${@:2}" \
    > "$out" 2> "$TMP/err.txt" || {
      bad "sk_map.py exited non-zero"; cat "$TMP/err.txt" | sed 's/^/      /'; }
  printf '%s' "$out"
}

printf '▸ 1 · the pinned shape (§2)\n'
D="$(run_map "$WORLD")"
has "$D" "Project map — Clinic Network Booking — 2026-08-31 · profile: Discovery · Band: 1 (closed 2026-07-10) — Bands 2/3 capable · verdict: " \
    "the head line — project · date · profile · band · verdict"
has "$D" "— §10.4-F · dev-ready (B3) " "line 2 carries both §10.4-F bars"
has "$D" "Dev handoff — Spec-Kit compliance per feature (the gate's 24-assertion M set):" \
    "the handoff head names the M set and its size"
has "$D" "Techniques: " "the techniques line"
has "$D" "Commands: " "the commands line"
has "$D" "Questions: " "the questions line"
has "$D" "Named (D-O58): " "the named line renders — the fixture carries a divergence"

printf '▸ 2 · dev handoff — the golden counts (§3)\n'
has "$D" "004-appointment-booking · 96% · gaps 0 · W 1 · ⚑ 1 · risk: elevated · handoff: yes — effective PASS 2026-07-18" \
    "the certified feature: (24−1)/24 = 96%, line-8 risk, the PASS date"
has "$D" "005-specialist-availability-publishing · — · gaps 0 · W 0 · ⚑ 2 · risk: unassessed · handoff: no — ungated (the gate is the only exit)" \
    "the ungated feature: — never 0%, unassessed, the boundary named"
has "$D" "dev-ready (B3) ▕█████░░░░░▏ 50%" "the project number is B3's own ratio — 1/2 certified"

printf '▸ 3 · technique coverage (§4)\n'
has "$D" "Techniques: 16/20 run · 1 dropped (reason on record) · 0 planned · 3 no record · custom runs 2" \
    "the roster totals against the fixture plans file"
has "$D" "  no record: T-03 · T-04 · Tier 2" \
    "the no-record set named — two never elected, one run but never logged"

printf '▸ 4 · command coverage (§5)\n'
has "$D" "Commands: 6 evidenced (/ba-frame · /ba-close-band1 · /ba-enter-feature · /ba-gate · /ba-gate-health · /ba-reopen)" \
    "the evidenced set, each read from the estate"
has "$D" "6 without record (/ba-waive-aspect · /ba-wbs · /ba-audit · /ba-dev-ready · /ba-auto · /ba-humanizer)" \
    "the no-record set — never rendered as never-ran"

printf '▸ 5 · the verdict rule, both sides (§6)\n'
has "$D" "· verdict: questions standing" \
    "the fixture's open question + markers read questions standing"
HEAVY="$TMP/heavy"
make_world "$HEAVY"
cat > "$HEAVY/specs/005-specialist-availability-publishing/gate-report.md" <<'EOF'
# Gate Report — 005-specialist-availability-publishing

## Gate run 1 — 2026-08-30

Verdict: FAIL (3 gaps)

Gaps:
  CC-ST-2 — US2 acceptance criteria absent
  CC-TR-02 — a References path does not resolve
  CC-EA-1 — an NFR threshold unsourced

Waivers in force:
  none

Certification:        — (not an effective PASS)
EOF
DH="$(run_map "$HEAVY")"
has "$DH" "· verdict: question-heavy" "a standing FAIL flips the verdict to question-heavy"
has "$DH" "005-specialist-availability-publishing · 88% · gaps 3 · W 0 · ⚑ 2 · risk: high · handoff: no — gate FAIL standing (3 open)" \
    "the FAIL feature: (24−3)/24 = 88%, high with the gap count named"

printf '▸ 6 · the HTML render (§7)\n'
[ ! -f "$WORLD/.specify/map.html" ] \
  && ok "no HTML without --html" \
  || bad "map.html exists before any --html run"
run_map "$WORLD" --html > /dev/null
H="$WORLD/.specify/map.html"
[ -f "$H" ] && ok "--html writes .specify/map.html" || bad "--html wrote nothing at $H"
lacks "$H" "<script" "zero script — CSS-only disclosure"
if grep -qE 'https?://' "$H"; then
  bad "the offline law — an external reference stands in the render"
else
  ok "the offline law — zero external references"
fi
has "$H" 'role="img"' "the SVG gauges carry their accessible role"
has "$H" "Project map — Clinic Network Booking — 2026-08-31" \
    "the chat render is embedded verbatim — presentation, never new data"
has "$H" "The rules, printed" "the rules fold is present"
has "$H" "never hand-edited" "the derived-render footer carries the D-O29 law"
has "$H" "· $PKG_VERSION" "the edition renders from the project's own manifest"
python3 "$SK/sk_map.py" --root "$WORLD" --date 2026-09-01 --html > /dev/null 2>&1
has "$H" "2026-09-01" "regenerated per invocation — the second run's date stands"

printf '▸ 7 · read-only (§1, D-M1)\n'
FRESH="$TMP/fresh"
make_world "$FRESH"
hash_world() { (cd "$1" && find . -type f | sort | xargs shasum) ; }
hash_world "$FRESH" > "$TMP/before.txt"
run_map "$FRESH" > /dev/null
hash_world "$FRESH" > "$TMP/after.txt"
diff -q "$TMP/before.txt" "$TMP/after.txt" > /dev/null \
  && ok "a chat run writes nothing — the world hashes identical" \
  || bad "a chat run changed the world"
run_map "$FRESH" --html > /dev/null
hash_world "$FRESH" | grep -v './.specify/map.html' > "$TMP/after2.txt"
diff -q "$TMP/before.txt" "$TMP/after2.txt" > /dev/null \
  && ok "an --html run writes map.html and nothing else" \
  || bad "an --html run changed more than map.html"

printf '▸ 8 · the skill and the definition\n'
has "$SKILL" "Project map — <project> — <date> · profile: <…> · Band: <…> · verdict: <wellbeing verdict>" \
    "the skill carries the pinned shape"
has "$SKILL" "certified" "the compliance formula's certified case is stated"
has "$SKILL" "(24 − W)/24" "…with the waiver-visible form"
has "$SKILL" "never 0%" "…and the unmeasured-is-not-zero rule"
has_joined "$SKILL" "An unapplied technique is not a defect" \
    "the coverage panel's stance — election is the BA's"
has_joined "$SKILL" "never writes, never transitions, never proposes content" \
    "the never-list carries the read discipline"
has "$SKILL" "Mode read (framework-wide):" "standing block 1 — the mode read"
has "$SKILL" "Register self-check (§10.3), before any BA-facing render:" \
    "standing block 2 — the register self-check"
has "$SKILL" "The session boundary (framework-wide)." \
    "standing block 3 — the session boundary"
has "$DOC" "D-M1" "the definition rules D-M1"
has "$DOC" "D-M7" "…through D-M7"
has "$DOC" "q + ⚑ ≥ 10" "the verdict threshold is the document's own text"
has_joined "$DOC" "No new composite enters this document" \
    "the D-O27 composite ban is honored on the record"

# the fixture itself, the one both halves came from
(cd "$FX" && find . -type f | sort | xargs shasum) > "$TMP/fx-after.txt"
diff -q "$TMP/fx-before.txt" "$TMP/fx-after.txt" > /dev/null \
  && ok "the fixture is read, never written" \
  || bad "the fixture changed across a run"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the project map: the shape · the two measures · the coverage panels · the verdict rule · the HTML law · read-only\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
