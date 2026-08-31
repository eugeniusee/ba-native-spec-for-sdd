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
#   6.  the closing ask — §10.3 rule 9 in the document, the six register
#       carriers and every stop-carrying skill, with a stripped control;
#       D-O90's outcome-shaped Slack item at the Frame ask — the three
#       variants, never folded into the sources-completeness question; and
#       D-O91's pinned ask tails on the two exempt auto reports
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
FRAME="$PKG_ROOT/payload/claude/skills/ba-frame/SKILL.md"
AUTO="$PKG_ROOT/payload/claude/skills/ba-auto/SKILL.md"
CB1="$PKG_ROOT/payload/claude/skills/ba-close-band1/SKILL.md"
ENTF="$PKG_ROOT/payload/claude/skills/ba-enter-feature/SKILL.md"
AGENTS="$PKG_ROOT/payload/mirror/AGENTS.md"
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

for f in "$DOC" "$RUN" "$ORC" "$BLOCK" "$FRAME" "$AUTO" "$CB1" "$ENTF" "$AGENTS" "$SCRIPT"; do
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

has_joined "$DOC" "Batch entry — \`/ba-run specs all | specs <epic-list>\` (D-O34)" \
    "§8.4 binds the batch entry form"
has_joined "$DOC" "each run owing its own \`## Band 3\` run-log line" \
    "…and keeps D86's per-run bookkeeping inside the batch"

# the confirmation table opens with the coverage line (§8.4 · D-O100) — the
# driver drives every SELECTED feature, so the line names the in-boundary
# epics that have no rows to select: the subset made visible above the table
# it cannot appear in.
has_joined "$DOC" "The confirmation table opens with the \`Scope coverage:\` line (D-O100)" \
    "§8.4 opens the batch table with the coverage line"
has_joined "$DOC" "the subset made visible above the table it cannot appear in" \
    "…and says why: the epics with no rows to select"
has_joined "$DOC" "Display only: the line strikes nothing, blocks nothing and adds no" \
    "…display only — it strikes nothing and adds no confirmation act"
has "$RUN" "Scope coverage: <in-boundary epics briefed <b>/<e> | uncovered inside boundary: E-nn <name> · … | — no roadmap or no boundary yet>" \
    "…and /ba-run carries the line verbatim, the report's own wording"
has_joined "$RUN" "the subset made visible above the table it cannot appear in" \
    "…with the reason compiled beside it"
has_joined "$ORC" "The table opens with the \`Scope coverage:\` line" \
    "…and the persona opens its batch table with it too"

has "$DOC" "Auto-repair (D-O32)" "§10.2 carries auto-repair"
has_joined "$DOC" "Handing the BA a list of commands to type is a banned render" \
    "…and bans the list-of-commands render"
for f in "$ORC" "$BLOCK"; do
  has "$f" "Auto-repair" "…compiled into $(basename "$f")"
done

# the two forms reach the BA-facing command index
has "$BLOCK" '| `/ba-run` |' "the CLAUDE.md block lists the route runner"
has "$BLOCK" '`/ba-run specs all`' "…and the batch driver"

# ── 6. the closing ask — §10.3 rule 9 (D-O82) ────────────────────────────────
#
# The field defect of 20 Aug 2026: a legitimate stop closed in framework jargon
# ("Reply with: sources · profile · frame confirmed, including the
# SD-?/XO-?/AS-? keep-or-discard calls") and the BA had to ask what was
# expected. Rule 9 is the render half's last mile — every render that ends the
# turn awaiting BA input closes with the plain-English `What I need from you:`
# block, lettered options, exactly one `(recommended)` marker per question,
# AskUserQuestion where the runtime has it, appended after the pinned render
# (the D-O56 tail); under a standing AG the two exempt reports carry it as
# pinned tails (D-O91). The document states the law; the six register carriers
# compile rule 9; every stop-carrying skill names the ask at its own stop.

printf '\n▸ The closing ask — §10.3 rule 9 (D-O82)\n'

has_joined "$DOC" 'The stop-point closing ask (D-O82).' \
    "§10.3 rule 9 states the closing-ask law"
has_joined "$DOC" 'ends with a final plain-English block titled `What I need from you:`' \
    "…the final plain-English block, titled"
has_joined "$DOC" 'exactly one option per question carries the marker `(recommended)`' \
    "…exactly one recommended marker per question"
has_joined "$DOC" 'it never pre-selects and never auto-applies' \
    "…the marker is a label, never a pre-selection"
has_joined "$DOC" 'appended after the pinned render' \
    "…additive on the D-O56 tail precedent"
has_joined "$DOC" 'amended on the record by D-O86 and D-O91, never rewritten' \
    "…the AUTO exemption amended on the record twice, never rewritten"
has_joined "$DOC" "each carries this rule's closing ask as an **additive tail in its own pinned shape**" \
    "…and it grants the two exempt reports shape, not silence (D-O91)"
has_joined "$DOC" 'one stop stays one interaction' \
    "…with the ≤ 8 budget arithmetically untouched"

# rule 9 compiled into the register's six carriers — section 3's loop, one rule up
R9='ends with a final plain-English block titled `What I need from you:`'
r9=0; r9n=0
for f in "$PKG_ROOT"/payload/claude/agents/*.md "$PKG_ROOT"/payload/mirror/*.md; do
  r9n=$((r9n+1))
  python3 - "$f" "$R9" <<'PY' && r9=$((r9+1))
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
sys.exit(0 if sys.argv[2] in re.sub(r"\n\s*(?=\S)", " ", text) else 1)
PY
done
[ "$r9n" -gt 0 ] \
  && ok "the register carriers derive — $r9n personas and mirrors" \
  || bad "the persona/mirror glob matched nothing: section 6 would pass vacuously"
[ "$r9" -eq "$r9n" ] \
  && ok "rule 9's closing-ask clause is compiled into all $r9n register carriers" \
  || bad "rule 9's closing-ask clause is missing from $((r9n-r9)) of $r9n carriers"

# every stop-carrying skill names the ask at its own stop. The set is named,
# not globbed: a skill with no BA-input stop (a read-only render, a report act)
# legitimately carries none, and a glob would ban that.
ASK_SKILLS='ba-frame ba-aspect ba-run ba-clear ba-waive-aspect ba-reopen
ba-close-band1 ba-enter-feature ba-gate ba-audit ba-tier1 ba-tier2
ba-t01 ba-t17 ba-t18'
askmiss=0; askn=0
for s in $ASK_SKILLS; do
  askn=$((askn+1))
  grep -qF 'What I need from you:' "$PKG_ROOT/payload/claude/skills/$s/SKILL.md" \
    || { askmiss=$((askmiss+1)); printf '      no closing ask: %s\n' "$s"; }
done
[ "$askmiss" -eq 0 ] \
  && ok "the closing ask is named at every stop-carrying skill — $askn of $askn" \
  || bad "$askmiss of $askn stop-carrying skill(s) never name the closing ask"

# both miss stops — the invocation miss and the §6.3 contract miss — carry the
# uniform sentence in every technique-class skill
missmiss=0; missn=0
for f in "$PKG_ROOT"/payload/claude/skills/ba-t[0-9][0-9]/SKILL.md \
         "$PKG_ROOT"/payload/claude/skills/ba-tier1/SKILL.md \
         "$PKG_ROOT"/payload/claude/skills/ba-tier2/SKILL.md; do
  [ -f "$f" ] || continue
  missn=$((missn+1))
  n="$(grep -c '§10.3 rule 9' "$f")"
  [ "$n" -ge 2 ] || { missmiss=$((missmiss+1)); printf '      %s carries %s of 2\n' "${f#"$PKG_ROOT"/}" "$n"; }
done
[ "$missn" -eq 20 ] \
  && ok "the technique-class glob derives 20 units" \
  || bad "the technique-class glob derived $missn units, expected 20"
[ "$missmiss" -eq 0 ] \
  && ok "both miss stops carry the closing-ask sentence in all $missn technique-class skills" \
  || bad "$missmiss technique-class skill(s) miss the closing-ask sentence at a miss stop"

# the control: a skill stripped of the ask must be caught by the same probe
CA="$TMP/ca"
mkdir -p "$CA"
cp "$PKG_ROOT/payload/claude/skills/ba-frame/SKILL.md" "$CA/stripped.md"
python3 - "$CA/stripped.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
p.write_text(p.read_text(encoding="utf-8").replace("What I need from you:", ""), encoding="utf-8")
PY
grep -qF 'What I need from you:' "$CA/stripped.md" \
  && bad "the control is blind: the stripped copy still matches" \
  || ok "the control fires — a skill stripped of the ask is caught"

# the Slack item is never folded (D-O90) — the field defect of 22 Aug 2026:
# with the no-match or interrupted line rendered there was no #<channel> to
# fill, the match-shaped question silently dropped, and the Slack outcome
# dissolved into the generic sources-completeness item. Whenever any of the
# three pinned Slack lines rendered, the Frame ask carries one dedicated Slack
# question — immediately after the sources item — shaped by the line that
# rendered; where no Slack line rendered, no item is invented.

printf '\n▸ The Slack item is never folded — §8.1 (D-O90)\n'

has_joined "$DOC" 'The Slack item is never folded (D-O90).' \
    "§8.1 states the never-folded law"
has_joined "$DOC" 'one dedicated Slack question' \
    "…one dedicated Slack question, shaped by the line that rendered"
has_joined "$DOC" 'The Slack outcome never rides inside the sources-completeness question.' \
    "…and the outcome never rides inside the sources item"
has_joined "$DOC" 'the existing reachability dispositions govern and no item is invented' \
    "…and no item is invented where no Slack line rendered"

has_joined "$FRAME" 'The Slack item is never folded (D-O90).' \
    "ba-frame carries the law at its own stop"
has "$FRAME" 'The Slack channel #<channel> — read it as a source?' \
    "…the match variant, its text as shipped"
has "$FRAME" 'none matches the project name. Is there a channel I should read anyway?' \
    "…the no-match variant states its corpus and asks anyway"
has "$FRAME" 'a. none — proceed without Slack (recommended)' \
    "…with proceed-without-Slack the recommended no-match disposition"
has "$FRAME" 'I could not establish the full channel list' \
    "…the interrupted variant names the cut in plain words"
has "$FRAME" 'a. re-run the listing to completion (recommended — a negative never rests on a sample)' \
    "…with the re-run recommended — a negative never rests on a sample"
has "$FRAME" 'c. proceed without Slack' \
    "…and the interrupted variant keeps the proceed-without-Slack escape"

# the two exempt reports gain pinned ask tails (D-O91) — the field defect of
# 22 Aug 2026: at P-O7, P-O8 and at the resumption report the run ended the
# turn bare ("any reply continues") and the BA invented a reply without ever
# seeing the choices. Both reports keep their pinned shapes byte-untouched;
# each now ends with a pinned closing-ask tail — continue recommended at the
# boundary, ratify-all recommended at off — never composed at the stop.

printf '\n▸ The pinned ask tails on the two exempt reports — §10.7 (D-O91)\n'

has_joined "$DOC" "The closing ask — the report's tail (D-O91" \
    "§10.7 pins the band-boundary tail paragraph"
has_joined "$DOC" 'pinned here, never composed at the stop' \
    "…pinned at the mode's corpus home, never composed at the stop"
BQ='1. Band <n> is closed under the grant. How do we proceed?'
RQ='1. <n> AUTO acts stand for ratification. Your call?'
has "$DOC" "$BQ" "…the band question, its text pinned"
has "$DOC" "a. continue — <the report's Next act line, in plain words> (recommended)" \
    "…continue recommended, the Next act line in plain words"
has "$DOC" 'b. pause and ratify — /ba-auto off; the resumption report renders' \
    "…pause-and-ratify routing to the existing off act"
has "$DOC" 'c. correct something first — name it' \
    "…and correct-something-first the escape"
has_joined "$DOC" 'run /ba-gate-health full first — it is overdue; no grant reaches it, this stays your act' \
    "…the conditional health option, joining only where overdue renders"
has_joined "$DOC" '**Recommended stays on continue:**' \
    "…with recommended staying on continue (D-O59 display-only)"
has_joined "$DOC" 'join the ask as questions' \
    "…and the decision-list items join the ask as questions (T-18 step-4 shape)"

# ── the third conditional join (D-O101 — EC-22) ─────────────────────────────
#
# D-O91 ruled two joins; the coverage line brings a third. It is worded
# DIFFERENTLY from the health option on purpose: the refresh act stays outside
# every grant, while briefing an uncovered epic sits inside the cost boundary.
has_joined "$DOC" '**Three conditional joins, and no other (D-O101' \
    "§10.7 counts three conditional joins, D-O91's two amended on the record"
has_joined "$DOC" 'brief the uncovered in-boundary epics first' \
    "…the coverage option, joining only where uncovered epics render"
has_joined "$DOC" 'Tier 1 in ingest mode is inside the grant, the run resumes toward Band 3 after' \
    "…and its reason: the act the run may perform on the BA's letter"
has_joined "$DOC" 'after the health option where both render, the letters shifting in order' \
    "…placed after the health option where both render, the letters shifting"
has_joined "$DOC" 'while this act sits **inside the cost boundary**' \
    "…and the wording differs deliberately: this act is inside the boundary"
has_joined "$DOC" 'still no AG expands, no new stop and no new prompt point exists (D-O101)' \
    "…with no AG expansion, no new stop and no new prompt point"

joinmiss=0
for pair in "$AUTO|ba-auto" "$CB1|ba-close-band1" "$ENTF|ba-enter-feature" \
            "$BLOCK|claude-block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"
  python3 - "$f" <<'PYX' > /dev/null || { joinmiss=$((joinmiss+1)); printf '      no third join: %s\n' "${pair##*|}"; }
import re, sys
flat = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
sys.exit(0 if "brief the uncovered in-boundary epics first" in flat else 1)
PYX
done
[ "$joinmiss" -eq 0 ] \
  && ok "…and all five band-boundary carriers carry the third join" \
  || bad "$joinmiss carrier(s) miss D-O101's third conditional join"

# the COUNT is stated wherever the joins are counted at all — the document and
# the three skills. The two mirrors state the joins and have never counted
# them, and this ruling adds no count where none stood (D-O56's tail rule read
# the other way: nothing is added to a surface that never carried it).
countmiss=0
for pair in "$AUTO|ba-auto" "$CB1|ba-close-band1" "$ENTF|ba-enter-feature"; do
  f="${pair%%|*}"
  python3 - "$f" <<'PYX' > /dev/null || { countmiss=$((countmiss+1)); printf '      still counts two: %s\n' "${pair##*|}"; }
import re, sys
flat = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
sys.exit(0 if (re.search(r"[Tt]hree\s+conditional\s+joins", flat)
               and not re.search(r"[Tt]wo\s+conditional\s+joins", flat)) else 1)
PYX
done
[ "$countmiss" -eq 0 ] \
  && ok "…and every compiled surface that counts them counts three, none still two" \
  || bad "$countmiss surface(s) still count two conditional joins"

# The document keeps its `two` — three times, all historical: the v0.42 change
# record, D-O101's own row naming what it amends, and §45's byte-untouched
# note. A ruling is amended ON the record, never rewritten out of it, and a
# corpus that scrubbed the old count would lose the amendment it is evidence of.
has_joined "$DOC" "s *two* amended on the record, its row byte-untouched" \
    "…and §10.7 amends the count on the record rather than rewriting D-O91"
NTWO=$(grep -o 'two conditional joins' "$DOC" | wc -l | tr -d ' ')
[ "$NTWO" = "3" ] \
  && ok "…the document keeping its 3 historical \"two conditional joins\" — the amendment's own evidence" \
  || bad "the document carries $NTWO historical \"two conditional joins\", expected 3"
has_joined "$DOC" 'The ask asks for **no ruling on the trail**' \
    "…the boundary stays a render, not a ratification point (D-O52)"
has "$DOC" "$RQ" "…the resumption question, its text pinned"
has "$DOC" 'a. ratify all (recommended)' \
    "…ratify-all recommended"
has "$DOC" 'b. ratify all except — name the acts' \
    "…ratify-all-except naming the acts"
has "$DOC" 'c. discuss first — ask me anything about the trail' \
    "…and discuss-first the escape"
has_joined "$DOC" 'the typed grammar and the ask can never disagree' \
    "…the typed grammar and the ask never disagreeing (the apply-all precedent)"

# the compiled carriers: the band tail on every band-boundary renderer, the
# resumption tail on every resumption renderer — the D-O69 tail's own set
bandmiss=0
for pair in "$AUTO|ba-auto" "$CB1|ba-close-band1" "$ENTF|ba-enter-feature" \
            "$BLOCK|claude-block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"
  grep -qF -- "$BQ" "$f" && grep -qF -- 'Reply with a letter, or in your own words — any reply continues.' "$f" \
    || { bandmiss=$((bandmiss+1)); printf '      no band tail: %s\n' "${pair##*|}"; }
done
[ "$bandmiss" -eq 0 ] \
  && ok "the band-boundary tail is compiled into all 5 renderers" \
  || bad "$bandmiss band-boundary renderer(s) carry no pinned ask tail (D-O91)"
resmiss=0
for pair in "$AUTO|ba-auto" "$BLOCK|claude-block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"
  grep -qF -- "$RQ" "$f" && grep -qF -- "Reply with a letter, or type the Ratify line's own grammar: accept all / list exceptions." "$f" \
    || { resmiss=$((resmiss+1)); printf '      no resumption tail: %s\n' "${pair##*|}"; }
done
[ "$resmiss" -eq 0 ] \
  && ok "the resumption tail is compiled into all 3 renderers" \
  || bad "$resmiss resumption renderer(s) carry no pinned ask tail (D-O91)"

# ba-auto — the mode's compiled carrier states the amendment and both glosses
has_joined "$AUTO" 'shape, not silence' \
    "ba-auto's exemption paragraph carries the amendment — shape, not silence"
has_joined "$AUTO" 'Band 1 at P-O7 — Band-1 closure, Band 2 at P-O8 — Band-3 entry' \
    "…and the <n> slot gloss — the band the boundary leaves behind"
has_joined "$AUTO" 'any reply continues — the recommended option is the continue' \
    "…any reply continues, the recommended option being the continue"
has_joined "$AUTO" 'taking every recommended option is `apply all` exactly' \
    "…and all-recommended is apply-all exactly, the T-18 step-4 precedent"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — manual-mode UX: the budget (%s ≤ %s) · the route render §10.6 · the checkpoint law · zero acknowledgement-only stops · plan-as-route + the two run forms · the closing ask §10.3 rule 9 · the Slack item never folded (D-O90) · the pinned ask tails on the two exempt reports (D-O91)\n' \
    "$N" "$BUDGET"
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
