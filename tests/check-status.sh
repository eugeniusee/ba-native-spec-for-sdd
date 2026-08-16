#!/usr/bin/env bash
#
# BA-Native Spec — the project dashboard (orchestrator rules §10.4, D-O26–D-O29).
#
# `/ba-status` is a render: it reads two source classes and writes nothing but
# the optional derived HTML. So the suite holds down exactly that — the shape,
# the counts, the formula, the two lines that report on the framework's own
# bookkeeping, and that nothing upstream moved.
#
#   1.  the pinned shape — the nine lines, in order, with their pinned prefixes
#   2.  the counts — every number against a fixture whose values are known
#   3.  formula §10.4-F — ten-cell bars, the mean of three, and the rule that
#       a zero denominator renders `—` and never 0%
#   4.  line 5 · the refresh state — `current` and `overdue`, both paths, with
#       the act left to /ba-gate-health
#   5.  line 6 · ledger coverage — the fixture's own Band-3 divergence, which
#       is the defect the line exists to surface
#   6.  line 8 · the profile switch — the Discovery risk table, the Presale
#       readiness line, and out-of-profile facts rendering as law
#   7.  the HTML render — self-contained, zero external resources, the same
#       counts, regenerated per invocation
#   8.  read-only — the source tree hashes identical across a run
#   9.  the skill — the pinned shape and the formula carried verbatim, the
#       never-list intact, the one sanctioned composite named as the one
#
# The fixture is the §12 estate: the band1/ ledgers over the project/ tree.
# It is read, never written: every run writes into the suite's temp dir, and
# section 8 proves it.
#
#   check-status.sh              run the suite
#   check-status.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
SK="$PKG_ROOT/payload/specify-overlay/ba/scripts"
FX="$HERE/fixtures/appointment-booking"
SKILL="$PKG_ROOT/payload/claude/skills/ba-status/SKILL.md"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"

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

# `has <file> <needle> <what>` — the fixed-string probe the other suites use
has() {
  grep -qF -- "$2" "$1" \
    && ok "$3" \
    || bad "$3 — not found: $2"
}
# `has_joined <file> <needle> <what>` — the same probe over the paragraphs the
# BA actually reads. A soft wrap is invisible in the render, so a sentence that
# wraps in the source is one string on screen (the check-register.sh rule).
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
joined = re.sub(r"\n(?=\S)", " ", text)
sys.exit(0 if sys.argv[2] in joined else 1)
PY
}
# `bar_cells <file>` — how many ten-cell bars the render carries
bar_cells() {
  python3 - "$1" <<'PY'
import re, sys
n = 0
for line in open(sys.argv[1], encoding="utf-8"):
    for m in re.finditer("▕([█░]*)▏", line):
        if len(m.group(1)) == 10:
            n += 1
print(n)
PY
}
# `line_has <render> <needle> <what>`
line_has() {
  grep -qF -- "$2" "$1" \
    && ok "$3" \
    || bad "$3 — not in the render: $2"
}
no_line() {
  grep -qF -- "$2" "$1" \
    && bad "$3 — present but must not be: $2" \
    || ok "$3"
}

status() { python3 "$SK/sk_status.py" "$@"; }

# ── the estate: band1/ ledgers over the project/ tree ────────────────────────
#
# The two halves of the §12 fixture are assembled into one root, read-only, in
# the suite's temp dir. The fixture itself is never written.

PROJ="$TMP/estate"
mkdir -p "$PROJ"
cp -R "$FX/project/." "$PROJ/"
cp "$FX/band1/aspect-state.md" "$FX/band1/aspect-plans.md" \
   "$FX/band1/gate-health.md" "$PROJ/.specify/"

D="$TMP/discovery.out"; P="$TMP/presale.out"
status --root "$PROJ" --date 2026-08-12 > "$D" 2>&1
status --root "$PROJ" --date 2026-08-12 --profile presale > "$P" 2>&1

# ── 1. the pinned shape ──────────────────────────────────────────────────────

printf '\n▸ The pinned shape — nine lines, in order, prefixes as §10.4 fixes them\n'

head -1 "$D" | grep -q "^Project status — Clinic Network Booking — 2026-08-12 · profile: Discovery · Band: " \
  && ok "the title line: project · date · profile · band" \
  || bad "the title line is not the pinned one: $(head -1 "$D")"

sed -n '2p' "$D" | grep -qE "^Workflow ▕[█░]+▏ [0-9]{1,3}% — §10\.4-F$" \
  && ok "the workflow line names its formula and carries a bar" \
  || bad "the workflow line is not the pinned one: $(sed -n '2p' "$D")"

for spec in \
  "1 · Band 1 — Foundations" \
  "2 · Band 2 — Scoping" \
  "3 · Band 3 — Delivery" \
  "4 · Questions:" \
  "5 · Health: Scope H" \
  "6 · Ledger coverage:" \
  "7 · Techniques:" \
  "8 · Discovery → Handoff risk per certified feature:" \
  "9 · Next:"
do
  line_has "$D" "$spec" "line present — ${spec}"
done

# the nine are in ascending order, each exactly once
ORDER="$(grep -o '^[1-9] · ' "$D" | tr -d ' ·')"
[ "$ORDER" = "$(printf '1\n2\n3\n4\n5\n6\n7\n8\n9')" ] \
  && ok "the nine lines render once each, in order" \
  || bad "the line order is not 1…9: $(echo "$ORDER" | tr '\n' ' ')"

# every band line carries a bar, and every bar is exactly ten cells
[ "$(bar_cells "$D")" -eq 4 ] \
  && ok "four ten-cell bars — the workflow line plus the three bands" \
  || bad "expected 4 ten-cell bars, found $(bar_cells "$D")"

# ── 2. the counts ────────────────────────────────────────────────────────────

printf '\n▸ The counts — the §12 estate, whose every value is known\n'

# six aspects first-pass-cleared in the head; Band 1 closed 2026-07-10
line_has "$D" "6/6 settled (6 cleared · 0 waived)" "settled reads the head's six states"
line_has "$D" "closed 2026-07-10" "…and the band line's own closure date"

# eight epic rows in the roadmap; one brief and one kit in scope/
line_has "$D" "briefs 1/8 epics · kits 1/8" "briefs and kits count against the roadmap's epic rows"
line_has "$D" "roadmap current 2026-07-15" "the roadmap's currency is its latest allocation entry"

# two specs/NNN-* folders, both with stories; 004 certified, 005 never gated
line_has "$D" "entered 2 across 1/8 epics" "entered features, and the epic breadth behind them"
line_has "$D" "drafted 2/2" "drafted = a spec.md carrying at least one User Story"
line_has "$D" "certified 1" "certified = the latest gate-report entry's own manifest"
line_has "$D" "gated 1 (latest: 004-appointment-booking certified — 2026-07-18)" \
  "gated names the latest verdict per gated feature"

# the E-03 brief's §6: OQ-1 answered, OQ-2 open
line_has "$D" "4 · Questions: 1 open · 1 answered · 0 overtaken" \
  "the questions come from the briefs' own §6 status column"
line_has "$D" "oldest: OQ-2" "…and the oldest open one is named, with where it stands"
line_has "$D" "(standing in E-03 §6)" "…including the brief it stands in"

# handed off: the package writes no per-feature handoff record
line_has "$D" "handed off —" "a count with no source renders — , never a guess"

# ── 3. formula §10.4-F ───────────────────────────────────────────────────────

printf '\n▸ Formula §10.4-F — the mean of three, at ten cells, — over a zero denominator\n'

# B1 = 6/6 = 1.0 · B2 = 1/8 = .125 · B3 (Discovery) = 1/2 = .5 → mean .541… → 54%
line_has "$D" "Workflow ▕█████░░░░░▏ 54%" "Discovery: mean of 6/6 · 1/8 · certified 1/2 = 54%"
# Presale swaps B3 to drafted/entered = 2/2 = 1.0 → mean .708… → 71%
line_has "$P" "Workflow ▕███████░░░▏ 71%" "Presale: B3 becomes drafted/entered, and the mean moves"
line_has "$D" "1 · Band 1 — Foundations ▕██████████▏" "a full ratio fills all ten cells"

# the zero-denominator rule, on a project that has only just been framed
BARE="$TMP/bare"
mkdir -p "$BARE/.specify"
cp "$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md" \
   "$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-plans.md" "$BARE/.specify/"
has "$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-plans.md" \
    'composed at `/ba-aspect band2` (P-O2 — plan composition, §8.3)' \
    "the template's Band-2 comment names the composition act (D-O55)"
B="$TMP/bare.out"
status --root "$BARE" --date 2026-08-12 > "$B" 2>&1

line_has "$B" "briefs — · kits —" "no epics: the Band-2 ratio renders — , never 0%"
line_has "$B" "drafted —" "no feature entered: the drafted ratio renders — too"
no_line   "$B" "briefs 0/0" "a zero denominator never renders as a fraction"
no_line   "$B" "0/0" "…nor anywhere else on the render"
line_has "$B" "0/6 settled" "a real zero over a real denominator still renders as a count"

# ── 4. line 5 · the refresh state ────────────────────────────────────────────

printf '\n▸ Line 5 — recorded full runs against the cadence, display only\n'

line_has "$D" "5 · Health: Scope H armed — HEALTHY · refresh current" \
  "the fixture is current: the arming run plus one per ingested brief"

# a second ingested brief with no matching full run puts the cadence behind
OVER="$TMP/overdue"
cp -R "$PROJ" "$OVER"
printf '# Scope Brief — Calendar Sync (E-04)\nStatus: Scoped\n' \
  > "$OVER/.specify/memory/scope/E-04.md"
O="$TMP/overdue.out"
status --root "$OVER" --date 2026-08-12 > "$O" 2>&1

line_has "$O" "refresh overdue: 1 run vs cadence" "a new ingestion batch makes the refresh overdue"
line_has "$O" "(2 recorded of 3" "…and the line shows both sides of the comparison"
line_has "$O" "one full run per scope-brief ingestion batch, plus the arming run" \
  "…naming the cadence it measures against"
no_line   "$O" "/ba-gate-health" "line 5 reports; it never proposes the refresh act as automatic"

# before the arming run there is no cadence to be behind
line_has "$B" "Scope H disarmed (pre-closure)" "pre-closure reads disarmed — a fact, not a gap"
line_has "$B" "refresh —" "…and a disarmed Scope H has no refresh state to report"

# ── 5. line 6 · ledger coverage ──────────────────────────────────────────────

printf '\n▸ Line 6 — disk against the §7.3 run log, the instrument on itself\n'

# the fixture has two features entered and no ## Band 3 run lines: forward-only
# means the history was never reconstructed, so the divergence is real and shown
line_has "$D" "6 · Ledger coverage: run log under-records Band 3: 2 on disk vs 0 logged" \
  "the fixture's own Band-3 under-recording is named, not papered over"
line_has "$D" "features entered vs \`## Band 3\` run lines" \
  "…with both sides of the comparison named"

# a plans file whose Band-2 section has fewer lines than the estate has artifacts
GAP="$TMP/gap"
cp -R "$PROJ" "$GAP"
python3 - "$GAP/.specify/aspect-plans.md" <<'PY'
import re, sys
p = sys.argv[1]
text = open(p, encoding="utf-8").read()
# drop the epic-named Tier-1 run lines from ## Band 2 — the estate keeps its
# brief and its kit, so the log now under-records what the disk carries
text = re.sub(r"^2026-07-\d\d · tier1 [^\n]*\n(?:  signals:[^\n]*\n(?:  {2,}[^\n]*\n)*)?",
              "", text, flags=re.M)
open(p, "w", encoding="utf-8").write(text)
PY
G="$TMP/gap.out"
status --root "$GAP" --date 2026-08-12 > "$G" 2>&1
line_has "$G" "under-records Band 2: 2 on disk vs 0 logged" "a Band-2 gap is caught the same way"
line_has "$G" "epic-named \`## Band 2\` run lines" "…against the epic-named lines, not the project-wide ones"

# and a log that covers the estate reports clean
line_has "$B" "6 · Ledger coverage: clean" "nothing on disk and nothing logged is clean, not a gap"

# ── 6. line 8 · the profile switch ───────────────────────────────────────────

printf '\n▸ Line 8 — one variant per profile; out-of-profile facts are law\n'

line_has "$D" "8 · Discovery → Handoff risk per certified feature:" "Discovery renders the risk table"
line_has "$D" "| Feature | W | O | surviving markers | HAs in deps | Risk |" \
  "…with the pinned column set"
line_has "$D" "Rule: low = all zero · elevated = any one non-zero · high = an Override, or ≥ 3 combined" \
  "…and the risk rule stated in full below it"
line_has "$D" "| 004-appointment-booking | 1 | 0 | 1 | 0 | elevated |" \
  "…and one waiver plus one marker rules the certified feature elevated"
no_line   "$D" "Exit readiness" "the Presale variant stays out of a Discovery render"

line_has "$P" "8 · Presale  → Exit readiness:" "Presale renders exit readiness instead"
line_has "$P" "\`/ba-wbs\` ready" "…including whether the WBS export can run"
line_has "$P" "open markers 3" "…and the open markers standing across the drafted specs"
no_line   "$P" "Handoff risk per certified feature" "the Discovery table stays out of a Presale render"
line_has "$P" "Presale note: certification & handoff out of profile" \
  "out-of-profile facts render as law — the destination is named"
no_line   "$P" "certification & handoff missing" "…never as a failure or a gap"

# ── 6b. the unreadable spec (D-O50) ──────────────────────────────────────────

printf '\n▸ The unreadable spec — excluded from the counts, named, never `drafted 0`\n'

# One entered spec whose headings match none of the ten. Before D-O50 this
# rendered as `drafted 1/2` with the miss invisible; the field saw `drafted 0/6`.
U="$TMP/unreadable"
cp -R "$PROJ" "$U"
cp "$PKG_ROOT/tests/fixtures/appointment-booking/negatives/neg-alien.md" \
   "$U/specs/005-specialist-availability-publishing/spec.md"
status --root "$U" --date 2026-08-12 > "$TMP/u.txt" 2>&1
UD="$TMP/u.txt"

line_has "$UD" "unreadable 1: 005-specialist-availability-publishing/spec.md" \
  "the unreadable spec is named by path"
line_has "$UD" 'heading found "Background", expected one of the ten standard §2 headings' \
  "…with the heading it found and the heading expected (found vs expected)"
line_has "$UD" "drafted 1/1" \
  "…and it leaves the drafted denominator — r, the readable entered specs"
no_line   "$UD" "drafted 1/2" \
  "an unreadable spec never sits in the drafted denominator"

# Every entered spec unreadable: r falls to zero, and §10.4-F's rule governs.
UZ="$TMP/unreadable-all"
cp -R "$U" "$UZ"
cp "$PKG_ROOT/tests/fixtures/appointment-booking/negatives/neg-alien.md" \
   "$UZ/specs/004-appointment-booking/spec.md"
status --root "$UZ" --date 2026-08-12 > "$TMP/uz.txt" 2>&1
status --root "$UZ" --date 2026-08-12 --profile presale > "$TMP/uzp.txt" 2>&1

line_has "$TMP/uz.txt" "drafted —" \
  "with every spec unreadable, drafted renders — (a zero denominator, §10.4-F)"
no_line   "$TMP/uz.txt" "drafted 0/" \
  "…never 0/0, and never 0%"
line_has "$TMP/uz.txt" "unreadable 2:" "…and both failures are named"

# The blocked reason must be the TRUE one — the field's sharpest wrong sentence.
line_has "$TMP/uzp.txt" 'blocked: 2 spec(s) unreadable' \
  "/ba-wbs names the parse failure as the blocker"
no_line   "$TMP/uzp.txt" "no spec carries a User Story yet" \
  "…never 'no spec carries a User Story yet', which was never established"

# ── 7. the HTML render ───────────────────────────────────────────────────────

printf '\n▸ The HTML render — self-contained, same counts, derived per invocation\n'

H="$TMP/out/status.html"
status --root "$PROJ" --date 2026-08-12 --html --out "$H" > "$TMP/html.out" 2>&1
[ -f "$H" ] && ok "--html writes the file" || bad "--html wrote no file at $H"

for needle in 'src=' 'href=' '<script' '<link' '@import' 'url(' 'http://' 'https://'; do
  grep -qF -- "$needle" "$H" \
    && bad "the HTML reaches outside itself: $needle" \
    || ok "zero external resources — no $needle"
done

grep -q 'style="' "$H" \
  && ok "styling is inline, as the offline law requires" \
  || bad "the HTML carries no inline style — where did the styling go"

# presentation, never new data: the chat render is embedded verbatim
line_has "$H" "6/6 settled (6 cleared · 0 waived)" "the HTML carries the same settled count"
line_has "$H" "Workflow ▕█████░░░░░▏ 54%" "…the same workflow line and the same formula result"
line_has "$H" "run log under-records Band 3" "…and the same ledger-coverage divergence"
line_has "$H" "never hand-edited" "…and says of itself that it is derived"

# regenerated per invocation: a hand edit dies at the next run
printf 'HAND EDIT\n' >> "$H"
status --root "$PROJ" --date 2026-08-12 --html --out "$H" > /dev/null 2>&1
grep -qF 'HAND EDIT' "$H" \
  && bad "a hand edit survived the next run — the file is not regenerated" \
  || ok "a hand edit dies at the next invocation"

# the default destination sits beside the runtime ledgers
grep -q 'default: .specify/status.html' "$TMP/html.out" \
  || status --root "$PROJ" --help 2>&1 | grep -q '.specify/status.html' \
  && ok "the default destination is beside the runtime ledgers" \
  || bad "the default HTML destination is not .specify/status.html"

# ── 8. read-only ─────────────────────────────────────────────────────────────

printf '\n▸ Read-only — the estate is untouched by a run\n'

tree_hash() {
  find "$1" -type f ! -name '.DS_Store' -print0 \
    | LC_ALL=C sort -z \
    | xargs -0 shasum -a 256 2>/dev/null \
    | shasum -a 256 | cut -d' ' -f1
}
BEFORE="$(tree_hash "$PROJ")"
status --root "$PROJ" --date 2026-08-12 > /dev/null 2>&1
status --root "$PROJ" --date 2026-08-12 --profile presale > /dev/null 2>&1
AFTER="$(tree_hash "$PROJ")"
[ -n "$BEFORE" ] && [ "$BEFORE" = "$AFTER" ] \
  && ok "the estate hashes identical before and after — ${BEFORE:0:12}…" \
  || bad "the source tree changed across a run: $BEFORE → $AFTER"

[ -e "$PROJ/.specify/status.html" ] \
  && bad "a run without --html wrote the derived render anyway" \
  || ok "without --html the command writes nothing at all"

# the fixture itself, the one both halves came from
FXB="$(tree_hash "$FX")"
status --root "$PROJ" --date 2026-08-12 > /dev/null 2>&1
[ "$FXB" = "$(tree_hash "$FX")" ] \
  && ok "the fixture is read, never written" \
  || bad "the fixture changed across a run"

# ── 9. the skill ─────────────────────────────────────────────────────────────

printf '\n▸ The skill — the shape and the formula carried, the never-list intact\n'

has "$SKILL" "disable-model-invocation: true" "the render is BA-invoked, never auto-fired"
has "$SKILL" "Read-only" "ba-status renders; it never changes state"
has "$SKILL" "no scheduler exists" \
    "ba-status is where revisit triggers are lazily read (§4.2)"

# the nine-line shape, carried into the skill as the document pins it
for spec in \
  "Workflow ▕██████░░░░▏ <p>% — §10.4-F" \
  "1 · Band 1 — Foundations" \
  "5 · Health: Scope H <armed — HEALTHY | n gaps | disarmed (pre-closure)>" \
  "6 · Ledger coverage:" \
  "9 · Next: <the one act the state points to — code + name>"
do
  has "$SKILL" "$spec" "the pinned shape carries: ${spec:0:46}"
done

# formula §10.4-F, verbatim from the document — the render's one tunable rule
FORMULA="B1 = settled/6 · B2 = briefs/epics · B3 = drafted/entered under"
has_joined "$SKILL" "$FORMULA" "the formula is carried into the skill"
has "$DOC" "$FORMULA" "…and it is the document's own text"
has_joined "$SKILL" "A zero denominator renders \`—\`, never 0%." "the zero-denominator rule, verbatim"
has "$DOC" "A zero denominator renders \`—\`, never 0%." "…also the document's own"

has "$SKILL" "the one sanctioned composite" "the workflow line is named as the only composite"
has "$SKILL" "Every other composite" "…and every other one is still banned"
has "$SKILL" "The refresh belongs to" "line 5 leaves the act to /ba-gate-health"
has_joined "$SKILL" "never writes a run-log line to repair the divergence line 6 reports" \
    "…and line 6 reports the gap without repairing it"
has "$SKILL" "zero external resources" "the HTML render carries the offline law"
has_joined "$SKILL" "never invents a composite beyond the one workflow line" \
    "the never-list is amended, not dropped"
has "$SKILL" "The session boundary (framework-wide)." "the session boundary is carried"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the dashboard: the nine-line shape · the counts · formula §10.4-F · the refresh state · ledger coverage · the profile switch · the HTML render · read-only\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
