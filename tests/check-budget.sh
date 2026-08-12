#!/usr/bin/env bash
#
# BA-Native Spec — manual-mode UX: the interaction budget and the checkpoint law
# (orchestrator rules §6.5 · §7.5 · §10.1 · §10.6; D-O30–D-O34).
#
# The budget is a number the framework must hold, so it is counted, not asserted
# in prose: `tests/presale-path.md` is the script, and section 1 counts it. The
# rest holds down the machinery the budget depends on — the route render must be
# a pinned shape wherever a route is rendered, and no skill may author a stop
# that buys no decision.
#
#   1.  the budget — the script's BA interactions, counted, against §6.5's ≤ 8
#   2.  the route render §10.6 — the pinned shape, line for line, in the
#       document and in every file that renders a route
#   3.  the checkpoint law — §10.1's text, §10.3 rule 7's render half, and both
#       compiled into the personas and the mirrors
#   4.  the banned sweep — zero acknowledgement-only prompts across the whole
#       skill/persona/mirror surface, with a seeded control
#   5.  plan-as-route and the two /ba-run forms — the runner's own operative
#       text, and the invariant it must not quietly drop
#
# The banned list is seeded from the ruling (WS-2) and extended by judgment;
# every phrasing it carries is logged in section 4's output, so a future reader
# sees the list, not just its verdict. Extending it is a one-line edit here.
#
#   check-budget.sh              run the suite
#   check-budget.sh -v           print every check, not just the failures
#   check-budget.sh --list       print the banned list and exit

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
RUN="$PKG_ROOT/payload/claude/skills/ba-run/SKILL.md"
ORC="$PKG_ROOT/payload/claude/agents/ba-orchestrator.md"
BLOCK="$PKG_ROOT/payload/mirror/claude-block.md"
SCRIPT="$HERE/presale-path.md"

BUDGET=8

# ── the banned list — acknowledgement-only stops ─────────────────────────────
#
# Seeded from the ruling's three, extended by judgment with the phrasings that
# say the same thing. Each buys no decision: the BA's only possible answer is
# "yes". Case-insensitive; matched against the render surface, fences included —
# a banned prompt inside a pinned shape is still a banned prompt.
BANNED='confirm to continue
type ok
acknowledge to proceed
press enter to continue
reply ok to proceed
confirm to proceed
say yes to continue
acknowledge before
confirm you have read
let me know when you are ready to continue'

VERBOSE=0; LIST=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    --list) LIST=1 ;;
    -h|--help) sed -n '2,27p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

if [ "$LIST" -eq 1 ]; then
  printf 'the banned list — acknowledgement-only stops:\n'
  printf '%s\n' "$BANNED" | sed 's/^/  · /'
  exit 0
fi

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
# BA actually reads: a soft wrap is invisible in the render (check-register.sh's
# rule), so a sentence that wraps in the source is one string on screen.
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
joined = re.sub(r"\n(?=\S)", " ", text)
sys.exit(0 if sys.argv[2] in joined else 1)
PY
}

for f in "$DOC" "$RUN" "$ORC" "$BLOCK" "$SCRIPT"; do
  [ -f "$f" ] || { printf '✗ missing source: %s\n' "$f" >&2; exit 2; }
done

# ── 1. the budget ────────────────────────────────────────────────────────────
#
# The script names one heading per BA interaction. Counting headings, not
# prompts, is deliberate: the heading is the unit the BA experiences, and it is
# the unit §6.5 budgets.

printf '\n▸ The interaction budget — §6.5 (D-O33)\n'

grep -cE '^## Interaction [0-9]+ ' "$SCRIPT" > "$TMP/n" 2>/dev/null || true
N="$(cat "$TMP/n")"

if [ "$N" -gt 0 ] 2>/dev/null; then
  ok "the script declares its interactions — $N found"
else
  bad "presale-path.md declares no '## Interaction <n>' headings: nothing to count"
fi

if [ "$N" -le "$BUDGET" ] 2>/dev/null && [ "$N" -gt 0 ]; then
  ok "the Presale path fits the budget — $N ≤ $BUDGET"
else
  bad "the Presale path is over budget — $N interactions, budget $BUDGET (§6.5, D-O33)"
  grep -nE '^## Interaction [0-9]+ ' "$SCRIPT" | sed 's/^/      /'
fi

# the headings are numbered 1..N with no gaps and no repeats — a script that
# skips a number has lost an interaction, and the count would lie
grep -oE '^## Interaction [0-9]+' "$SCRIPT" | grep -oE '[0-9]+' > "$TMP/nums"
seq 1 "$N" > "$TMP/want" 2>/dev/null || : > "$TMP/want"
if cmp -s "$TMP/nums" "$TMP/want"; then
  ok "the interactions run 1…$N — no gap, no repeat"
else
  bad "the interaction numbering is not 1…$N:"
  diff "$TMP/want" "$TMP/nums" | sed 's/^/      /' | head -8
fi

# the budget in the document is the budget this file enforces — never two numbers
has_joined "$DOC" "fits in ≤ 8 BA interactions on the default route" \
    "§6.5 states the budget the suite enforces"
has "$DOC" "Exceeding it is a defect, not a style preference; the harness counts it." \
    "…and names the harness as its enforcer"

# ── 2. the route render — §10.6 ──────────────────────────────────────────────

printf '\n▸ The route render — the pinned shape (§10.6, D-O31)\n'

SHAPE_1='Route — <destination, one line> · profile: <profile>'
SHAPE_2='| # | Code — technique | Yields |'
SHAPE_3='| 1 | T-08 — Value definition | canvas Problems + Objectives |'
SHAPE_4='Next: step 1 — go?'

for pair in "$DOC|the document" "$RUN|the route runner" "$ORC|the orchestrator persona" "$BLOCK|the CLAUDE.md block"; do
  f="${pair%%|*}"; label="${pair##*|}"
  n=0
  for line in "$SHAPE_1" "$SHAPE_2" "$SHAPE_3" "$SHAPE_4"; do
    grep -qF -- "$line" "$f" && n=$((n+1))
  done
  if [ "$n" -eq 4 ]; then
    ok "$label carries the §10.6 shape — all four pinned lines"
  else
    bad "$label carries $n/4 of the §10.6 shape's pinned lines"
  fi
done

has "$DOC" "Stops en route:" "the shape names its stops line"
has "$DOC" "route render §10.6" "§10.3 rule 8's list carries the route render"
for f in "$ORC" "$BLOCK"; do
  has "$f" "route render §10.6" "…compiled into $(basename "$(dirname "$f")")/$(basename "$f")"
done

# ── 3. the checkpoint law ────────────────────────────────────────────────────

printf '\n▸ The checkpoint law — §10.1 · §10.3 rule 7 (D-O30)\n'

LAW='A stop that only collects an acknowledgement'
RULE7='An acknowledgement-only stop is a banned render: if no BA decision exists, do not stop.'

has_joined "$DOC" "$LAW" "§10.1 bans the acknowledgement-only stop"
has_joined "$DOC" "The table below lists decision moments, not step boundaries." \
    "…and says what the table is"
has_joined "$DOC" "$RULE7" "§10.3 rule 7 carries the render half"

# the register compiles: rule 7's clause in every persona and mirror
r7=0; r7n=0
for f in "$PKG_ROOT"/payload/claude/agents/*.md "$PKG_ROOT"/payload/mirror/*.md; do
  r7n=$((r7n+1))
  python3 - "$f" "$RULE7" <<'PY' && r7=$((r7+1))
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
sys.exit(0 if sys.argv[2] in re.sub(r"\n\s*(?=\S)", " ", text) else 1)
PY
done
[ "$r7n" -gt 0 ] \
  && ok "the register carriers derive — $r7n personas and mirrors" \
  || bad "the persona/mirror glob matched nothing: section 3 would pass vacuously"
[ "$r7" -eq "$r7n" ] \
  && ok "rule 7's banned-render clause is compiled into all $r7n" \
  || bad "rule 7's banned-render clause is missing from $((r7n-r7)) of $r7n carriers"

# ── 4. the banned sweep ──────────────────────────────────────────────────────

printf '\n▸ Acknowledgement-only stops — the sweep\n'
printf '%s\n' "$BANNED" | sed 's/^/    banned: /'

sweep() {
  # <root> → one line per offender, then `hits=<n>`; the scanner's contract
  local root="$1" hits=0
  while IFS= read -r phrase; do
    [ -z "$phrase" ] && continue
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      if grep -qiF -- "$phrase" "$f"; then
        # the script and this suite name the banned phrasings in order to ban
        # them; the register's own never-lists do the same. Only a *rendered*
        # prompt is a defect, so a line that carries the phrase inside a
        # prohibition is not one.
        grep -inF -- "$phrase" "$f" \
          | grep -viE 'never|banned|not a|no acknowledgement|forbidden' \
          | sed "s|^|${f#"$root"/}:|" >> "$sw_out" && hits=$((hits+1))
      fi
    done <<EOF
$(find "$root/payload/claude/skills" "$root/payload/claude/agents" "$root/payload/mirror" -name '*.md' 2>/dev/null)
EOF
  done <<EOF
$BANNED
EOF
  printf 'hits=%s\n' "$(wc -l < "$sw_out" | tr -d ' ')"
}

sw_out="$TMP/sweep.txt"; : > "$sw_out"
SW="$(sweep "$PKG_ROOT")"
SW_N="${SW#hits=}"

if [ "$SW_N" = "0" ]; then
  ok "zero acknowledgement-only prompts across skills, personas and mirrors"
else
  bad "$SW_N acknowledgement-only prompt(s) authored into the render surface:"
  sed 's/^/      /' "$sw_out" | head -12
fi

# the control: the sweep is worth nothing unless it is shown to fire
CTL="$TMP/ctl"
mkdir -p "$CTL"
( cd "$PKG_ROOT" && tar cf - payload/claude/skills payload/claude/agents payload/mirror ) \
  | ( cd "$CTL" && tar xf - )
printf '\nRender the table, then confirm to continue.\n' \
  >> "$CTL/payload/claude/skills/ba-run/SKILL.md"

sw_out="$TMP/sweep-ctl.txt"; : > "$sw_out"
SW_C="$(sweep "$CTL")"
[ "${SW_C#hits=}" != "0" ] \
  && ok "the control fires — a seeded 'confirm to continue' is caught" \
  || bad "the seeded acknowledgement-only stop was NOT caught: the sweep is blind"

# ── 5. plan-as-route and the two /ba-run forms ───────────────────────────────

printf '\n▸ Plan-as-route and the run forms — §7.5 · §8.4 (D-O31 · D-O34)\n'

has_joined "$DOC" "The composed plan is a route." "§7.5 states plan-as-route"
has_joined "$DOC" "no state change without a BA act — the \`go\` is that act" \
    "…and the invariant survives it"
has_joined "$DOC" "Silence is never consent: a route executes only on a stated \`go\`" \
    "…with D-O13 restated, not relaxed"

has_joined "$RUN" "Render the §10.6 route shape once:" \
    "the runner renders the route shape first"
has_joined "$RUN" "Take the BA's \`go\`, then run each row in order" \
    "…then takes the go and runs the rows"
has_joined "$RUN" "Never stop between rows for acknowledgement" \
    "…and never stops between rows"
has_joined "$RUN" "a contract miss (name the single unblocking act)" \
    "…but does stop on a contract miss"
has "$RUN" '`specs all`' "the batch spec driver is bound"
has_joined "$RUN" "stop once at the consolidated defer-confirm." \
    "…and stops once, at the consolidated defer-confirm"

has_joined "$DOC" "Batch entry — \`/ba.run specs all | specs <epic-list>\` (D-O34)" \
    "§8.4 binds the batch entry form"
has_joined "$DOC" "each run owing its own \`## Band 3\` run-log line" \
    "…and keeps D86's per-run bookkeeping inside the batch"

has "$DOC" "Auto-repair (D-O32)" "§10.2 carries auto-repair"
has_joined "$DOC" "Handing the BA a list of commands to type is a banned render" \
    "…and bans the list-of-commands render"
for f in "$ORC" "$BLOCK"; do
  has "$f" "Auto-repair" "…compiled into $(basename "$f")"
done

# the two forms reach the BA-facing command index
has "$BLOCK" '| `/ba-run` |' "the CLAUDE.md block lists the route runner"
has "$BLOCK" '`/ba-run specs all`' "…and the batch driver"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — manual-mode UX: the budget (%s ≤ %s) · the route render §10.6 · the checkpoint law · zero acknowledgement-only stops · plan-as-route + the two run forms\n' \
    "$N" "$BUDGET"
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
