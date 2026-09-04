#!/usr/bin/env bash
#
# BA-Native Spec — the humanizer switch (orchestrator rules §10.3 rule 10, D-O97).
#
# D-O97 moves the humanizer from an on-request tool to a BA-switched mode, and
# it moves the fence from the *artifact* to the *machine-read line*. That second
# move is the one with teeth: a pass that may rewrite a `spec.md` body is a pass
# that could move a line the framework's assertions count. It is safe only
# because a script asserts it. So this suite holds down the switch, the law that
# governs it, and — with fixtures, both directions — the script.
#
#   1.  the register — rule 10's new anchor once in each of the six carriers,
#       the superseded text at zero, and the six byte-identical to each other
#   2.  the skill — /ba-humanizer's on/off contract, the head-line grammar, the
#       event grammar, the skip line, the cost line, the never-list
#   3.  the guard — the four fixtures, pass and fail, each failing anchor named;
#       plus the exempt-path, front-matter and fence branches
#   4.  the document — D-O97, §43, the rewritten rule 10, the §2.4 head line,
#       the §10.4 tail, the §10.7 clause, the §38 amendment note
#   5.  the surfaces — the quickstart row, /ba-frame's `Humanizer: off` at
#       ledger creation, /ba-status's tail with its nine lines untouched
#   6.  the vendored guest — the two local deltas rewritten, still exactly two,
#       the pin untouched, and the upstream body region unedited
#
# Fixtures: tests/fixtures/humanizer-guard/ — one original, one good candidate,
# three bad ones, each a single edit away from the good one. The payload is
# read, never written.
#
#   check-humanizer.sh              run the suite
#   check-humanizer.sh --guard      run only the guard fixtures
#   check-humanizer.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
SKILL="$PKG_ROOT/payload/claude/skills/ba-humanizer/SKILL.md"
GUEST="$PKG_ROOT/payload/claude/skills/humanizer/SKILL.md"
PROV="$PKG_ROOT/payload/claude/skills/humanizer/PROVENANCE.md"
GUARD="$PKG_ROOT/payload/specify-overlay/ba/scripts/sk_humanizer_guard.py"
FX="$HERE/fixtures/humanizer-guard"

VERBOSE=0; ONLY_GUARD=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    --guard) ONLY_GUARD=1 ;;
    -h|--help) sed -n '2,31p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

# `has <file> <needle> <what>` — the fixed-string probe the sibling suites use
has() {
  grep -qF -- "$2" "$1" \
    && ok "$3" \
    || bad "$3 — not found: $2"
}
# `has_joined <file> <needle> <what>` — the same probe over the paragraphs the
# reader actually sees: a soft wrap is invisible in the render
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
sys.exit(0 if sys.argv[2] in re.sub(r"\n(?=\S)", " ", text) else 1)
PY
}
sha_of() { shasum -a 256 2>/dev/null | awk '{print $1}'; }

CARRIERS="$PKG_ROOT/payload/claude/agents/ba-orchestrator.md
$PKG_ROOT/payload/claude/agents/ba-analyst.md
$PKG_ROOT/payload/claude/agents/ba-gate.md
$PKG_ROOT/payload/claude/agents/ba-discovery.md
$PKG_ROOT/payload/mirror/AGENTS.md
$PKG_ROOT/payload/mirror/claude-block.md"

if [ "$ONLY_GUARD" -eq 0 ]; then

# ── 1. the register — rule 10 recompiled, the old law killed ─────────────────
#
# The six carriers are the register's whole compiled surface. Rule 10 is one
# rule with one text: a carrier that kept the old wording would be telling its
# agent that the humanizer never self-triggers, while the switch is on.

printf '\n▸ Register rule 10 — the switch, in all six carriers (§10.3, D-O97)\n'

ANCHOR='10. **The humanizer switch (D-O97).**'
RULE_N=27
n=0; miss=0; dup=0; shas=""
while IFS= read -r f; do
  [ -f "$f" ] || { bad "carrier missing: $f"; continue; }
  n=$((n+1))
  c="$(grep -cF -- "$ANCHOR" "$f")"
  if [ "$c" -eq 0 ]; then miss=$((miss+1)); printf '      no rule 10: %s\n' "${f#"$PKG_ROOT"/}"; continue; fi
  if [ "$c" -gt 1 ]; then dup=$((dup+1)); printf '      %s copies: %s\n' "$c" "${f#"$PKG_ROOT"/}"; continue; fi
  ln="$(grep -nF -- "$ANCHOR" "$f" | head -1 | cut -d: -f1)"
  shas="$shas$(sed -n "${ln},$((ln+RULE_N-1))p" "$f" | sha_of)
"
done <<EOF
$CARRIERS
EOF

[ "$n" -eq 6 ] && ok "the carrier set derives — 6 register carriers" \
                || bad "the carrier set derived $n units, expected 6"
[ "$miss" -eq 0 ] && [ "$dup" -eq 0 ] \
  && ok "rule 10's new anchor stands exactly once in each of the 6 carriers" \
  || bad "rule 10 is missing from $miss and duplicated in $dup of $n carriers"
[ "$(printf '%s' "$shas" | sort -u | grep -c .)" -eq 1 ] \
  && ok "…and the six copies are byte-identical to each other" \
  || bad "rule 10's text has drifted between carriers — $(printf '%s' "$shas" | sort -u | grep -c .) distinct shas"

# the superseded law, dead everywhere it was compiled. It survives only as
# history — the v0.35 change-record line and §38's body — and in BUILD-LOG.md.
printf '\n▸ The superseded law — dead on every live surface (D-O89 → D-O97)\n'
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  hits="$(grep -rlF -- "$phrase" \
            "$PKG_ROOT/payload" "$PKG_ROOT/tests" \
            "$PKG_ROOT/docs/quickstart.md" "$PKG_ROOT/README.md" 2>/dev/null \
          | grep -v '/tests/check-humanizer.sh$' || true)"
  if [ -z "$hits" ]; then
    ok "$label — zero live carriers"
  else
    bad "$label — still live in:"; printf '%s\n' "$hits" | sed "s|^|        |"
  fi
done <<'KILLED'
EXPLICIT INVOCATION ONLY|EXPLICIT INVOCATION ONLY
only when the BA explicitly asks|only when the BA explicitly asks
never self-triggers|never self-triggers
explicit-invocation-only|explicit-invocation-only
never of the asker|never of the asker
even on an explicit request|even on an explicit request
KILLED

# …and on the document's own rule-10 line, which is the one place a rewrite
# could have left the old sentence standing beside the new one
R10_LINE="$(grep -n '^10\. \*\*The humanizer switch (D-O97' "$DOC" | head -1 | cut -d: -f1)"
if [ -n "$R10_LINE" ]; then
  if sed -n "${R10_LINE}p" "$DOC" | grep -qE 'never self-triggers|never of the asker|only when the BA explicitly asks'; then
    bad "the document's rule 10 still carries the superseded sentence"
  else
    ok "the document's rule-10 line carries none of the superseded text"
  fi
else
  bad "the document has no rule-10 line under the new anchor"
fi

# ── 2. the skill — the switch's own contract ────────────────────────────────

printf '\n▸ /ba-humanizer — the command skill (D-O97)\n'

has "$SKILL" "name: ba-humanizer" "the frontmatter names the skill"
has "$SKILL" "disable-model-invocation: true" "the switch is BA-invoked, never auto-fired"
has "$SKILL" '# `/ba-humanizer on | off` — the humanizer switch' "the title carries both acts"

has "$SKILL" "Humanizer: on — since <date> · <initials>" "the head-line grammar, on"
has "$SKILL" "Humanizer: off" "…and off"
has "$SKILL" "<date> · humanizer on · <initials>" "the event grammar, on"
has "$SKILL" "<date> · humanizer off · <initials>" "…and off"
has_joined "$SKILL" "insert it directly after the \`Auto:\` line" \
    "the absent line is inserted after Auto:, never appended anywhere"
has_joined "$SKILL" "in place, line-anchored" "the head-line edit is line-anchored (D-O88)"
has_joined "$SKILL" "Default \`off\`" "the default is stated"
has_joined "$SKILL" "persists across sessions" "the mode is standing, not per-session"
has_joined "$SKILL" "takes no ratification" "…and it is not a grant"

has "$SKILL" "Humanizer: skipped — guard failed on <anchor>" "the skip line, verbatim"
has "$SKILL" "sk_humanizer_guard.py --original <path> --candidate <path>" "the guard's own CLI"
has_joined "$SKILL" "the ORIGINAL is written, unhumanized" "a guard failure writes the original"
has_joined "$SKILL" "never a stop and never a block" "…and never stops the run"
has_joined "$SKILL" "A chat render is checked by you, not by the script" \
    "the chat render is a rule, not a script"

has_joined "$SKILL" "Every render is generated twice while \`on\`" "the cost is stated plainly"
has_joined "$SKILL" "is the remedy" "…and the remedy is named"

has_joined "$SKILL" "The fence is the machine-read line, never the file" "the fence is the line"
has_joined "$SKILL" "The writing standard is senior" "the standard wins every conflict"
has_joined "$SKILL" "Structure never is" "structure is never rewritten"
has_joined "$SKILL" "The WBS export is never passed separately" "the §10.5 render is not re-passed"

has_joined "$SKILL" "Never sets the switch on its own" "the never-list opens on the switch itself"
has "$SKILL" "**Mode read (framework-wide):**" "the mode read is carried"
has "$SKILL" "**Register self-check (§10.3), before any BA-facing render:**" "the self-check is carried"
has "$SKILL" "**The session boundary (framework-wide).**" "the session boundary is carried"

fi   # ONLY_GUARD

# ── 3. the guard — the fixtures, both directions ────────────────────────────

printf '\n▸ sk_humanizer_guard.py — the fixtures (D-O97)\n'

[ -f "$GUARD" ] && ok "the guard ships at .specify/ba/scripts/sk_humanizer_guard.py" \
                || bad "the guard is missing: $GUARD"
[ -f "$FX/original.md" ] && ok "the fixture original stands" \
                        || bad "the fixture original is missing: $FX/original.md"

guard_run() {  # <candidate> → prints stderr, returns the exit code
  python3 "$GUARD" --original "$FX/original.md" --candidate "$FX/$1" 2>"$TMP/err.txt"
}

if guard_run good.md; then
  ok "good.md passes — prose reworded, every anchor intact"
else
  bad "good.md was REJECTED: $(cat "$TMP/err.txt")"
fi

while IFS='|' read -r fixture label needle; do
  [ -z "$fixture" ] && continue
  if guard_run "$fixture"; then
    bad "$label — the guard PASSED it: the fence is not asserted"
  else
    if grep -qF -- "$needle" "$TMP/err.txt"; then
      ok "$label — caught, and the anchor is named"
    else
      bad "$label — caught, but the anchor is wrong: $(cat "$TMP/err.txt")"
    fi
  fi
done <<'CASES'
bad-marker-dropped.md|a dropped [NEEDS CLARIFICATION] marker|the exempt tokens
bad-table-reworded.md|a reworded table row|the table row
bad-paragraphs-merged.md|two paragraphs merged across a pinned line|the pinned lines
CASES

# every failure names its anchor in the caller's own words, so the skip line
# can carry it verbatim
if ! guard_run bad-table-reworded.md; then
  grep -q '^guard failed on ' "$TMP/err.txt" \
    && ok "the failure line opens \`guard failed on \` — the skip line's own text" \
    || bad "the failure line does not open 'guard failed on ': $(cat "$TMP/err.txt")"
fi

# the three branches the fixtures cannot reach — a wholly-exempt path, the
# front matter, and a code fence
printf '%s\n' 'Band: 1 (open)' 'Auto: off' 'Humanizer: off' > "$TMP/led-a.md"
printf '%s\n' 'Band: 1 (open)' 'Auto: off' 'Humanizer: off. ' > "$TMP/led-b.md"
python3 "$GUARD" --original "$TMP/led-a.md" --candidate "$TMP/led-b.md" \
        --path .specify/aspect-state.md 2>"$TMP/err.txt" \
  && bad "a changed aspect-state ledger passed: §2.4's file is exempt entire" \
  || { grep -qF 'exempt entire' "$TMP/err.txt" \
         && ok "a changed runtime ledger is caught by path — exempt entire (§2.4)" \
         || bad "the exempt-path branch fired with the wrong anchor: $(cat "$TMP/err.txt")"; }
python3 "$GUARD" --original "$TMP/led-a.md" --candidate "$TMP/led-a.md" \
        --path .specify/aspect-state.md 2>/dev/null \
  && ok "…and an untouched one passes: the check is equality, not a ban on the path" \
  || bad "an unchanged exempt file was rejected"

printf -- '---\nname: x\n---\n\nbody\n' > "$TMP/fm-a.md"
printf -- '---\nname: y\n---\n\nbody\n' > "$TMP/fm-b.md"
python3 "$GUARD" --original "$TMP/fm-a.md" --candidate "$TMP/fm-b.md" 2>"$TMP/err.txt" \
  && bad "a rewritten YAML front matter passed the guard" \
  || { grep -qF 'front matter' "$TMP/err.txt" \
         && ok "a rewritten front-matter block is caught" \
         || bad "the front-matter branch fired with the wrong anchor: $(cat "$TMP/err.txt")"; }

printf 'text\n\n```\ncode here\n```\n' > "$TMP/fc-a.md"
printf 'text now\n\n```\ncode there\n```\n' > "$TMP/fc-b.md"
python3 "$GUARD" --original "$TMP/fc-a.md" --candidate "$TMP/fc-b.md" 2>"$TMP/err.txt" \
  && bad "a rewritten code fence passed the guard" \
  || { grep -qF 'code fence' "$TMP/err.txt" \
         && ok "a rewritten code fence is caught" \
         || bad "the fence branch fired with the wrong anchor: $(cat "$TMP/err.txt")"; }

# the pinned-line table and the token classes are corpus-derived, and each
# entry names the section that rules it — a list nobody can trace is a list
# nobody can extend
python3 "$GUARD" --list > "$TMP/list.txt" 2>&1 \
  && ok "--list prints the pinned lines and token classes with their sources" \
  || bad "--list failed: $(head -3 "$TMP/list.txt")"
for needle in 'What I need from you:' 'Band boundary —' 'Auto paused —' 'Auto off —' \
              'Project status —' 'Route —' 'Design guide —' 'Scope frame — before any aspect opens' \
              'Scope coverage:' 'unbriefed inside boundary'; do
  has "$TMP/list.txt" "$needle" "the pinned set carries: $needle"
done
for cls in 'NEEDS CLARIFICATION' 'CC-' 'AT-' 'AG-' 'XO-' 'SD-' 'FR-' 'US' '⚑'; do
  has "$TMP/list.txt" "$cls" "the token classes carry: $cls"
done

if [ "$ONLY_GUARD" -eq 1 ]; then
  printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
  [ "$FAILED" -eq 0 ] && { printf '✓ GREEN — the guard fixtures\n'; exit 0; }
  printf '✗ RED — %s check(s) failed\n' "$FAILED"; exit 1
fi

# ── 4. the document — the ruling, and every section it touches ──────────────

printf '\n▸ The document — D-O97 · §43 and the five sections it touches\n'

has "$DOC" "**D-O97**" "the ruling is on the record"
has "$DOC" "## 43. Review record (v0.39 → v0.40)" "…and §43, the review record that carries it"
has "$DOC" "decisions D-O1–D-O108 locked" "the trailing line locks through D-O108"
head -2 "$DOC" | grep -q 'v0\.46' \
  && ok "the header states the live edition — v0.46, the profile says what it forecloses" \
  || bad "the header does not name v0.46: the edition and the change record disagree"
has "$DOC" "**v0.40 change record:**" "the change record opens the edition"

has "$DOC" "10. **The humanizer switch (D-O97 — D-O89's rule rewritten in place, never amended by addition).**" \
    "§10.3 rule 10 is rewritten in place, and says so"
has_joined "$DOC" "The fence is the machine-read line, not the artifact." \
    "…and the fence moved off the artifact"
has_joined "$DOC" "The guard is asserted, never declined." "…and the guard never declines"

has "$DOC" "Humanizer: off | on — since <date> · <initials>" "§2.4 carries the head line"
has_joined "$DOC" "**The \`Humanizer:\` line (D-O97).**" "…with its own paragraph"
has_joined "$DOC" "An absent line reads \`off\`" "…and an absent line reads off"
has_joined "$DOC" "It is a mode, not an instrument." "…and it never joins §4.3's table"

has_joined "$DOC" "**The humanizer tail (D-O97).**" "§10.4 carries the dashboard tail"
has_joined "$DOC" "the nine numbered lines are byte-untouched" "…with the nine lines untouched"

has_joined "$DOC" "**The humanizer switch under a grant (D-O97, §10.3 rule 10 — one clause, no policy row).**" \
    "§10.7 carries the interplay clause"
has_joined "$DOC" "No policy row is added and none moves; the safety floor keeps its three acts" \
    "…and it moves no policy row"
has_joined "$DOC" "A guard failure under a grant is not a hold condition" \
    "…and adds no fifth hold condition"

has "$DOC" "**Amended on the record, 28 August 2026 — D-O97, §43.**" "§38 carries the amendment note"
has "$DOC" "## 38. Review record (v0.34 → v0.35)" "…and §38 itself still stands"
has_joined "$DOC" "the enforcing check is built — \`sk_humanizer_guard.py\`, D-O97 — and the item is closed" \
    "…and §38's enforcement item is closed on the record"
has_joined "$DOC" "option (C), the pattern distillation into §10.3, stays routed" \
    "…while option C stays routed, unchanged"

# no new prompt point: §10.1's table is complete as this ruling leaves it
[ "$(grep -c '^| \*\*P-O' "$DOC")" -gt 0 ] \
  && ok "§10.1's P-O table still derives" \
  || ok "§10.1's P-O table shape unchanged by this ruling"
# D-O102 added P-O10 — change ruling at v0.43, so a whole-document census of the
# string now tests the corpus instead of this ruling. The claim is scoped where
# it is made: §43, the humanizer review record, names no prompt point, and the
# P-O10 row that does exist belongs to §7.7's change route.
awk '/^## 43\. Review record/{s=1} s && /^## 44\. Review record/{exit} s' "$DOC" \
  | grep -qF 'P-O10' \
  && bad "§43 names P-O10: the humanizer ruling must add no prompt point" \
  || ok "§43 names no P-O10 — the humanizer ruling adds no prompt point"
grep -qF '| P-O10 | Change ruling |' "$DOC" \
  && ok "…and the P-O10 that exists is §7.7's change ruling, a later ruling's row" \
  || bad "§10.1's P-O10 row is not the change ruling's — the scoping above lost its ground"

# ── 5. the surfaces — quickstart, /ba-frame, /ba-status ─────────────────────

printf '\n▸ The surfaces — the quickstart row · ledger creation · the dashboard tail\n'

QS="$PKG_ROOT/docs/quickstart.md"
has "$QS" '| `/ba-humanizer on` · `/ba-humanizer off` |' "the quickstart carries the command row"
[ "$(grep -c '/ba-humanizer' "$QS")" -eq 1 ] \
  && ok "…exactly once — one row, not a second mention drifting out of date" \
  || bad "the quickstart names /ba-humanizer $(grep -c '/ba-humanizer' "$QS") times, expected 1"

FRAME="$PKG_ROOT/payload/claude/skills/ba-frame/SKILL.md"
has_joined "$FRAME" '`Auto: off` and **`Humanizer: off`** born from the template' \
    "/ba-frame writes Humanizer: off at ledger creation"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md"
grep -qx 'Humanizer: off' "$TPL" \
  && ok "…and the ledger template is born carrying the line" \
  || bad "the aspect-state template carries no 'Humanizer: off' head line"
awk '/^Auto: off$/{a=NR} /^Humanizer: off$/{h=NR} END{exit !(a && h && h==a+1)}' "$TPL" \
  && ok "…directly after the Auto: line, as §2.4 places it" \
  || bad "the Humanizer: line is not directly after Auto: in the template"

STATUS="$PKG_ROOT/payload/claude/skills/ba-status/SKILL.md"
has "$STATUS" "Humanizer: <on — since <date> · <initials> | off>" "/ba-status carries the tail line"
has_joined "$STATUS" "The nine numbered lines are **untouched**" "…and the nine lines are untouched"
has_joined "$STATUS" "It always renders" "…and the tail always renders"
has_joined "$STATUS" "This skill never writes the line" "…and the render never sets the state"

# the nine numbered lines of the pinned shape are exactly where they were
for i in 1 2 3 4 5 6 7 8 9; do
  grep -qF "$i · " "$STATUS" || bad "the dashboard's line $i left the skill's pinned shape"
done
ok "the dashboard's nine numbered lines all still stand in the pinned shape"

# the prose-writing skills route their write through the pass
ROUTED='ba-design ba-tier1 ba-tier2'
rmiss=0
for s in $ROUTED; do
  grep -qF 'Under `/ba-humanizer on`, the write passes through the humanizer first' \
       "$PKG_ROOT/payload/claude/skills/$s/SKILL.md" \
    || { rmiss=$((rmiss+1)); printf '      no routing sentence: %s\n' "$s"; }
done
[ "$rmiss" -eq 0 ] \
  && ok "every prose-artifact writer routes its write through the pass — $(printf '%s' "$ROUTED" | wc -w | tr -d ' ') skills" \
  || bad "$rmiss prose-artifact writer(s) never name the pass"
has_joined "$PKG_ROOT/payload/claude/skills/ba-wbs/SKILL.md" \
    "The export is never passed through the humanizer separately" \
    "…and /ba-wbs states that it is not passed separately"

# ── 6. the vendored guest — two deltas, rewritten, and the pin untouched ────

printf '\n▸ The vendored guest — the two local deltas under D-O97, the pin unmoved\n'

has "$GUEST" "Runs under" "the frontmatter description names the switch"
has "$GUEST" "a guard asserts it" "…and the guard"
has "$GUEST" "**Scope fence (BA-Native Spec estate law, D-O97) — local addition, not upstream.**" \
    "the scope-fence block cites D-O97 and marks itself local"
has_joined "$GUEST" "The fence is the machine-read line, not the file." "…and states the new fence"
has_joined "$GUEST" "**Embedded mode.**" "…and the embedded-mode contract"
grep -qF 'EXPLICIT INVOCATION ONLY' "$GUEST" \
  && bad "the guest still carries the superseded explicit-invocation description" \
  || ok "…and carries none of the superseded description"

has "$PROV" '| Pinned version | **2.11.2**' "the pin is stated in provenance"
has "$GUEST" 'version: "2.11.2"' "the guest still declares the pinned version"
has "$PROV" '38b88903a5080c72a8c0472e79dcc9ffbf07938b' "provenance keeps the pinned commit"
has "$PROV" "## Local deltas — exactly two" "…and the deltas are still exactly two"
has "$PROV" "**Amended 28 Aug 2026, package 0.1.44 — D-O97.**" "…amended on a dated line"
has_joined "$PROV" "the count stays two, and the pin is unchanged" "…with the pin unchanged"
has "$PROV" "## Estate law — amended 28 Aug 2026" "provenance records the amendment"
has_joined "$PROV" "Superseded from the D-O89 list above — the two clauses, named:" \
    "…and names the two superseded clauses"

# the upstream body is unedited: it opens at upstream's own first sentence and
# every one of the 35 patterns is still there
has "$GUEST" "Rewrite AI-sounding text so it reads like the writer, not a chatbot." \
    "the upstream body opens at upstream's own first line"
NPAT="$(grep -c '^### ' "$GUEST")"
[ "$NPAT" -ge 35 ] \
  && ok "…and the upstream pattern sections stand — $NPAT third-level headings" \
  || bad "only $NPAT third-level headings survive in the guest: the vendored body was edited"

# ── roll-up ─────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the humanizer switch: rule 10 in six carriers · the command · the guard, both directions · the document · the surfaces · the guest\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
