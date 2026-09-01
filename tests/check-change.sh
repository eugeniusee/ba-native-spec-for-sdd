#!/usr/bin/env bash
#
# BA-Native Spec — the change route (orchestrator rules §7.7 · §2.4 · §9 ·
# §10.1 · §10.3 rule 8 · §10.4 · §10.7 · §11 · §46; D-O102).
#
# A stakeholder's change after the estate stands had six correct landing
# mechanics and no front door. `/ba-change` is the front door, and every unit
# of it derives from law that already stood: what this suite holds down is that
# the compiled surfaces say what the document says, byte for byte where the
# document pins a shape, and that the three additive tails are additive.
#
#   1.  the skill — the frontmatter, §7.7's own order, the never-list, and the
#       three standing blocks byte-identical to the corpus (check-register's
#       carrier law, asserted here for the new carrier)
#   2.  the impact render — the skill's pinned block byte-equal to §7.7's
#       instance, extracted from the document and never restated here
#   3.  the P-O10 row and the policy row — in the carriers that compile the
#       §10.1 table and the §10.7 policy table, each found by grep, not by a
#       list kept in this file
#   4.  the tail line on the three reports — every carrier of a pinned report
#       shape carries it, and every pinned report line stands byte-untouched
#   5.  the /ba-status changes tail — the line, the section, the nine numbered
#       lines still in place
#   6.  the ledger — the head line born at `none`, the register's grammar and
#       the three CR record forms legal, with six seeded negatives
#   7.  the guard — the impact render's fixed lines pinned, the ledgers still
#       exempt entire
#   8.  the document — D-O102, §7.7, §46, and the four sections the ruling
#       touches
#
#   check-change.sh              run the suite
#   check-change.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
QS="$PKG_ROOT/docs/quickstart.md"
SKILLS="$PKG_ROOT/payload/claude/skills"
SKILL="$SKILLS/ba-change/SKILL.md"
STATUS="$SKILLS/ba-status/SKILL.md"
ORC="$PKG_ROOT/payload/claude/agents/ba-orchestrator.md"
AUTO="$SKILLS/ba-auto/SKILL.md"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md"
GUARD="$PKG_ROOT/payload/specify-overlay/ba/scripts/sk_humanizer_guard.py"
FX="$HERE/fixtures/appointment-booking/band1"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,29p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
joined = re.sub(r"\n(?=\S)", " ", text)
sys.exit(0 if sys.argv[2] in joined else 1)
PY
}

# The tail line, and the three report shapes' own head lines — the grep keys
# this suite derives its carrier sets from. Nothing below keeps a file list.
TAILLINE='Changes awaiting your ruling: CR-<n> — <the change, one line> (<from>) · …'
BB_HEAD='Band boundary — <date> · AUTO (AG-<n>) · <P-O7 Band-1 closure | P-O8 Band-3 entry: <feature>>'
MG_HEAD='Auto paused — <date> · <safety floor: <act — code + name> | scope exhausted: <the AG'"'"'s scope edge, as AG-<n> states it>>'
RS_HEAD='Auto off — <date>'

carriers_of() {  # $1 = a pinned line; prints every payload file that carries it
  grep -rlF -- "$1" "$PKG_ROOT/payload" 2>/dev/null | sort
}

# ── 1. the skill ─────────────────────────────────────────────────────────────

printf '\n▸ The skill — /ba-change, §7.7'"'"'s order, and the three standing blocks\n'

[ -f "$SKILL" ] && ok "payload/claude/skills/ba-change/SKILL.md exists" \
                || { bad "the ba-change skill is not in the payload"; }

has "$SKILL" "name: ba-change" "the frontmatter names the skill"
has "$SKILL" "disable-model-invocation: true" \
    "…and ships disable-model-invocation: true — BA-invoked, never auto-fired"
has_joined "$SKILL" "A stakeholder's change after the estate stands had six correct landing mechanics and no front door" \
    "…and the description states D-O102's own sentence"

# §7.7's order, step by step — the section headings, in the document's order
for h in "## Invocation — two entry forms, and one re-entry" \
         "## Step 0 — receive, unconditionally" \
         "## Step 1 — locate: the targets, and the state of each" \
         "## Step 2 — the impact render" \
         "## Step 3 — the route, then the ruling" \
         "## Step 4 — landing" \
         "## Autonomy — never AUTO, and not on the floor" \
         "## What this skill never does"; do
  has "$SKILL" "$h" "the body carries: ${h#\#\# }"
done
python3 - "$SKILL" <<'PY' && ok "…and the four steps stand in §7.7's order, 0 → 1 → 2 → 3 → 4" \
  || bad "the steps are out of §7.7's order"
import re, sys
t = open(sys.argv[1], encoding="utf-8").read()
at = [t.index("## Step %d" % n) for n in range(5)]
sys.exit(0 if at == sorted(at) else 1)
PY

# the receive-before-classification guard: the record exists before anything
# below it runs, and the skill says so in the words the law uses
has_joined "$SKILL" "appends to Events in full, status \`received\`" \
    "Step 0 logs CR-<n> · received before any classification"
has_joined "$SKILL" "**The record comes before the classification, always.**" \
    "…and states the guard as a rule, not only as an order of steps"
has_joined "$SKILL" "**Logging is unconditional**" \
    "…unconditionally — a declined change is an audit record, never a silent drop"
has "$SKILL" "sources/change-<n>-<date>.md" "…into the source law's own destination"
has_joined "$SKILL" "\`/ba-frame\` owns those mechanics; this skill cites them and re-implements none of them" \
    "…citing /ba-frame's capture mechanics, never re-implementing them"

# Step 1 — the reads behind the two states no report carries
has "$SKILL" "as \`sk_handoff.py\` reads them for its own take-up check: the \`NNN-*\` feature" \
    "Step 1 reads taken-by-implementation off the gate §11.2 plumbing leaves"
has "$SKILL" "branch, and the \`.specify/feature.json\` pointer." \
    "…both plumbing leaves, the pointer named"
has "$SKILL" "- **\`delivered\`** — the roadmap row reading \`Delivered\`, or the feature's" \
    "…and delivered off the roadmap or the cycle-close band event"
has_joined "$SKILL" "**Where no reliable read exists for a state, say so and stop guessing.**" \
    "…and a state it cannot establish is named, never guessed (D-O58)"
has_joined "$SKILL" "a change located by guess is a change applied to the wrong file" \
    "…the names-nothing-findable stop asks, and the CR stays received"

# Step 2 — the WBS count law
has "$SKILL" "WBS: count not established — <why>" "Step 2 pins the un-establishable WBS count line"
has_joined "$SKILL" "— **never zero.**" "…never zero (D-O58)"
has "$SKILL" "sk_wbs.py --root . --summary-only" \
    "…and reads the counts through the export's own summary mode, writing no sheet"

# Step 3 — the ask, the marker rule, the three rulings
has "$SKILL" "   a. take — run the route above (recommended)" "P-O10's ask carries take (recommended)"
has "$SKILL" "   b. decline — nothing moves; your reason goes on the record" "…decline, unmarked"
has "$SKILL" "   c. hold — until an event you name; it comes back when that moment renders" "…and hold"
has_joined "$SKILL" "\`decline\` **never** carries it" \
    "the marker rule: decline is never recommended by the framework"
has_joined "$SKILL" "\`hold\` carries it **instead** where the render names a **standing \`AS-<n>\`" \
    "…and hold takes the marker at a named standing AS-<n> contradiction"
has_joined "$SKILL" "the rows in order, no per-row acknowledgement" \
    "a take executes the route as /ba-run executes a composed route"
has_joined "$SKILL" "**Never a date, never a schedule**" "a hold is event-shaped, never a date"

# the hold's lazy-read touchpoints, each wired by name
for tp in '`/ba-enter-feature` — Band-3 entry' '`/ba-t18` — Scope allocation' \
          'the cycle-close prompt (§8.5)'; do
  has "$SKILL" "$tp" "the hold's lazy read names its touchpoint: $tp"
done

# Step 4 and the never-list
has "$SKILL" "CR-<n> · landed · <date> — <refs>" "Step 4 pins the landed record's grammar"
has_joined "$SKILL" "**The CR duplicates none of these records**" \
    "…and the CR binds the refs its route wrote, duplicating none"
for n in "never authors a spec, brief, roadmap or governance line" \
         "never voids, preserves or comments on a certification's validity" \
         "never freezes work in flight" \
         "never converts a hold into a schedule" \
         "never touches the client-facing xlsx"; do
  has_joined "$SKILL" "$n" "the never-list carries: $n"
done
has_joined "$SKILL" "A change arrives **from outside the workflow any grant runs**" \
    "autonomy: the change arrives from outside the workflow any grant runs"
has_joined "$SKILL" "**a grant cannot self-elect a request nobody made.**" \
    "…so no AG's scope: field contains it — never AUTO"
has_joined "$SKILL" "**The safety floor keeps its three acts.**" \
    "…and D-O94's three-act floor is byte-untouched"

# the three standing blocks, byte-identical to the corpus (check-register's law)
python3 - "$SKILL" "$SKILLS/ba-reopen/SKILL.md" <<'PY' \
  && ok "the three standing blocks are byte-identical to the corpus's" \
  || bad "the standing blocks in ba-change diverge from the corpus's"
import sys
def tail(p):
    t = open(p, encoding="utf-8").read()
    return t[t.index("**Mode read (framework-wide):**"):]
sys.exit(0 if tail(sys.argv[1]) == tail(sys.argv[2]) else 1)
PY

# ── 2. the impact render — byte-equal to §7.7's instance ─────────────────────

printf '\n▸ The impact render — the skill'"'"'s block against §7.7'"'"'s pinned instance\n'

python3 - "$DOC" "$SKILL" "$TMP" <<'PY' \
  && ok "the skill's impact render is byte-equal to §7.7's pinned instance" \
  || bad "the skill's impact render diverges from §7.7's instance (diff in the temp dir)"
import re, sys
doc, skill, tmp = sys.argv[1], sys.argv[2], sys.argv[3]
def fenced(text, start, end):
    body = text[text.index(start):text.index(end)]
    blocks = re.findall(r"```\n(.*?)```", body, re.S)
    return blocks[0] if blocks else ""
d = open(doc, encoding="utf-8").read()
s = open(skill, encoding="utf-8").read()
a = fenced(d, "**Pinned instance of the impact render", "\n## 8. Band orchestration")
b = fenced(s, "## The pinned impact render", "## What this skill never does")
open(tmp + "/doc.txt", "w").write(a)
open(tmp + "/skill.txt", "w").write(b)
sys.exit(0 if a and a == b else 1)
PY

# the instance's own fixed lines, each pinned on its own so a silent trim shows
for l in 'Change — CR-3 ·' 'Targets: E-07 Online payment' \
         '| # | Touches | Consequence under standing law |' \
         'Boundary: the change moves E-07 out of the billable set' \
         'Route — CR-3 landed:' 'Stops en route: P-O0b — the scope-frame change' \
         'What I need from you:'; do
  has "$SKILL" "$l" "the instance carries its line: ${l:0:44}"
done

# ── 3. the P-O10 row and the policy row, in the carriers grep finds ──────────

printf '\n▸ P-O10 — change ruling: the §10.1 row and the §10.7 policy row\n'

has "$DOC" "| P-O10 | Change ruling |" "§10.1's table carries the P-O10 row"
has "$DOC" "| **P-O10 — change ruling** (§7.7) |" "§10.7's policy table carries its row"

n_p10=0
for f in $(grep -rlF "| P-O9 | " "$PKG_ROOT/payload" 2>/dev/null | sort); do
  grep -qF "| P-O10 | change ruling |" "$f" \
    && { n_p10=$((n_p10+1)); ok "the §10.1 table's P-O10 row stands in ${f#$PKG_ROOT/}"; } \
    || bad "${f#$PKG_ROOT/} compiles the §10.1 P-O table and carries no P-O10 row"
done
[ "$n_p10" -ge 1 ] && ok "…at every carrier that compiles the §10.1 table — $n_p10 found by grep" \
                   || bad "no carrier of the §10.1 P-O table was found: the sweep is vacuous"

n_pol=0
for f in $(grep -rlF "| P-O9 — overflow ruling |" "$PKG_ROOT/payload" 2>/dev/null | sort); do
  grep -qF "| **P-O10 — change ruling** (\`/ba-change\`) |" "$f" \
    && { n_pol=$((n_pol+1)); ok "the §10.7 policy row stands in ${f#$PKG_ROOT/}"; } \
    || bad "${f#$PKG_ROOT/} compiles the §10.7 policy table and carries no P-O10 row"
done
[ "$n_pol" -ge 1 ] && ok "…at every carrier that compiles the policy table — $n_pol found by grep" \
                   || bad "no carrier of the §10.7 policy table was found: the sweep is vacuous"

has_joined "$AUTO" "**Never AUTO — and not on the floor.**" \
    "the policy row rules never AUTO, and not on the floor"
has_joined "$AUTO" "a grant cannot self-elect a request nobody made" \
    "…on the reason the row gives: a grant cannot self-elect a request nobody made"

# ── 4. the tail line on the three reports ────────────────────────────────────

printf '\n▸ The three-report tail line — every carrier of a pinned report shape\n'

REPORT_CARRIERS="$( { carriers_of "$BB_HEAD"; carriers_of "$MG_HEAD"; carriers_of "$RS_HEAD"; } | sort -u )"
n_rep=0; miss=0
for f in $REPORT_CARRIERS; do
  n_rep=$((n_rep+1))
  grep -qF -- "$TAILLINE" "$f" \
    && ok "the tail line stands in ${f#$PKG_ROOT/}" \
    || { miss=$((miss+1)); bad "${f#$PKG_ROOT/} renders a pinned report and carries no tail line"; }
done
[ "$n_rep" -ge 6 ] && ok "…across every report carrier the payload holds — $n_rep found by grep" \
                   || bad "only $n_rep report carriers found; the sweep would pass vacuously"
[ "$miss" -eq 0 ] && ok "no report carrier is missing the line" \
                  || bad "$miss report carrier(s) render a report without the line"

# the tail is additive: every pinned report line still stands, byte for byte
for l in "$BB_HEAD" "Next act: <one line> — any reply continues · /ba-auto off renders the resumption report"; do
  has "$AUTO" "$l" "the band-boundary report's pinned line stands: ${l:0:44}"
done
for l in "$MG_HEAD" "Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>"; do
  has "$AUTO" "$l" "the mid-grant stop report's pinned line stands: ${l:0:44}"
done
for l in "Stopped at: <point> · mid-flight: <none | run aborted, artifact stays draft>" \
         "Ratify: accept all / list exceptions" "Next manual act: <one line>"; do
  has "$AUTO" "$l" "the resumption report's pinned line stands: ${l:0:44}"
done
has_joined "$AUTO" "**Visibility, and never an option in any closing ask.**" \
    "the line is visibility — no option joins any closing ask on its account"
has_joined "$AUTO" "**Unlike the decision list, this line reaches the mid-grant stop report too.**" \
    "…and it reaches the mid-grant stop report, unlike the advisory list"

# the closing asks are untouched: still three lettered options, still recommended
has "$AUTO" "   a. continue — <the report's Next act line, in plain words> (recommended)" \
    "the band-boundary ask's recommended option is still the continue"
has "$AUTO" "   a. ratify all (recommended)" "…and the resumption ask's is still ratify all"

# ── 5. the /ba-status changes tail ───────────────────────────────────────────

printf '\n▸ The dashboard'"'"'s changes tail (§10.4)\n'

has "$DOC" "Changes: <CR-<n> — <the change, one line> — <state> · …>       (renders only when the register is non-empty)" \
    "§10.4's pinned shape carries the tail line"
has "$STATUS" "Changes: <CR-<n> — <the change, one line> — <state> · …>       (renders only when the register is non-empty)" \
    "…and so does /ba-status's compiled shape"
has "$STATUS" "### The changes tail" "…with its own section"
has_joined "$STATUS" "**It renders only where the register holds at least one entry**" \
    "…rendering only where the register is non-empty"
has_joined "$STATUS" "This skill never writes the line —" \
    "…and rendering the register is not ruling on it"
python3 - "$STATUS" <<'PY' && ok "…after the humanizer tail, which still stands before it" \
  || bad "the changes tail does not follow the humanizer tail"
import sys
t = open(sys.argv[1], encoding="utf-8").read()
sys.exit(0 if t.index("### The humanizer tail") < t.index("### The changes tail") else 1)
PY
for i in 1 2 3 4 5 6 7 8 9; do
  grep -qF "$i · " "$STATUS" || bad "the dashboard's line $i left the pinned shape"
done
ok "the dashboard's nine numbered lines all still stand"
has_joined "$DOC" "no count enters §10.4-F" "…and no count entered §10.4-F"

# ── 6. the ledger — the head line, the register, the records ─────────────────

printf '\n▸ The ledger — the Changes: head line, its grammar and the CR records\n'

grep -qx 'Changes:                  none' "$TPL" \
  && ok "the shipped template is born with the register at none" \
  || bad "the aspect-state template carries no 'Changes:                  none' head line"
awk '/^Scope advisories:         none$/{a=NR} /^Changes:                  none$/{c=NR} END{exit !(a && c && c==a+1)}' "$TPL" \
  && ok "…directly after Scope advisories:, as §2.4 places it" \
  || bad "the Changes: line is not directly after Scope advisories: in the template"
has "$TPL" "  Changes:                  CR-<n> — <the change, one line> (<from>) — <state>" \
    "…and the head-shape exhibit carries the populated form"
has "$TPL" "states:  received | held — trigger: <event> | routed — <acts> |" \
    "…with the state vocabulary, closed at five"
has "$TPL" "CR-<n> · received · <date> · from:" "the Events comment carries the received record"
has "$TPL" "CR-<n> · ruled · <date> · <initials> —" "…the ruled record"
has "$TPL" "CR-<n> · landed · <date> — <refs>" "…and the landed record"
has_joined "$PKG_ROOT/payload/claude/skills/ba-frame/SKILL.md" \
    "\`Changes:\` (the change register, D-O102 — an absent line reads \`none\`" \
    "/ba-frame writes Changes: none at ledger creation"

# a ledger WITHOUT the line is legal — §2.4's own rule, and the reason the line
# is not in check-ledger's required head set
python3 "$HERE/check-ledger.py" "$FX/aspect-state.md" > "$TMP/legacy.out" 2>&1 \
  && ok "a ledger written before this ruling is still grammar-legal — an absent line reads none" \
  || { bad "a pre-D-O102 ledger went illegal: the absent line was made required"
       sed 's/^/      /' "$TMP/legacy.out"; }

# the positive: the register and all three records
mk() {  # $1 = out path; $2 = head entry; $3.. = event lines
  local out="$1" entry="$2"; shift 2
  python3 - "$FX/aspect-state.md" "$out" "$entry" "$@" <<'PY'
import sys, pathlib
src, out, entry, *events = sys.argv[1:]
t = pathlib.Path(src).read_text(encoding="utf-8")
t = t.replace("Scope advisories:         none\n",
              "Scope advisories:         none\nChanges:                  %s\n" % entry)
if events:
    t = t.rstrip("\n") + "\n" + "\n".join(events) + "\n"
pathlib.Path(out).write_text(t, encoding="utf-8")
PY
}

RECV='CR-1 · received · 2026-09-01 · from: client — M. Petrenko, Slack #proj-cardio · sources/change-1-2026-09-01.md — remove online payment from the booking flow'
RULED='CR-1 · ruled · 2026-09-01 · Y.K. — take · targets: E-07 Online payment (Phase 2 · Defined) · 004-appointment-booking (certified, not taken)'
LANDED='CR-1 · landed · 2026-09-02 — Allocation 4 (E-07 Phase 2 → Later) · 004 spec r7 · WBS: 3 rows drop'

mk "$TMP/cr-recv.md" 'CR-1 — remove online payment (client — M. Petrenko) — received' "$RECV"
python3 "$HERE/check-ledger.py" "$TMP/cr-recv.md" > "$TMP/o" 2>&1 \
  && ok "a received CR — head entry and record — is grammar-legal" \
  || { bad "the received CR was rejected"; sed 's/^/      /' "$TMP/o"; }

mk "$TMP/cr-landed.md" 'CR-1 — remove online payment (client — M. Petrenko) — landed — Allocation 4 · 004 spec r7' \
   "$RECV" "$RULED" "$LANDED"
python3 "$HERE/check-ledger.py" "$TMP/cr-landed.md" > "$TMP/o" 2>&1 \
  && ok "…and so is the full received → ruled → landed run, refs carrying their own ·" \
  || { bad "the landed CR run was rejected"; sed 's/^/      /' "$TMP/o"; }

# the negatives — one per clause the register and the records rule
neg() {  # $1 = label; $2 = expected rule; $3 = ledger path
  if python3 "$HERE/check-ledger.py" "$3" --expect "$2" > "$TMP/n.out" 2>&1; then
    ok "$1 → $2"
  else
    bad "$1 — the guard did not fire"; sed 's/^/      /' "$TMP/n.out"
  fi
}
mk "$TMP/n-state.md"  'CR-1 — remove online payment (client) — acknowledged' "$RECV"
neg "a sixth state on the register line" L20 "$TMP/n-state.md"
mk "$TMP/n-from.md"   'CR-1 — remove online payment — received' "$RECV"
neg "an entry naming nobody who brought it" L20 "$TMP/n-from.md"
mk "$TMP/n-wish.md"   'CR-1 — remove online payment (client) — held — trigger: next quarter' "$RECV"
neg "a hold parked on a date wish, not an event" L20 "$TMP/n-wish.md"
mk "$TMP/n-reason.md" 'CR-1 — remove online payment (client) — declined' "$RECV"
neg "a decline with no reason on the record" L20 "$TMP/n-reason.md"
mk "$TMP/n-orphan.md" 'CR-2 — simplify the confirmation screen (designer) — landed — Allocation 5' \
   'CR-2 · landed · 2026-09-02 — Allocation 5'
neg "a CR landing with no received record before it" L20 "$TMP/n-orphan.md"
mk "$TMP/n-targets.md" 'CR-1 — remove online payment (client) — routed — T-18 rerun' \
   "$RECV" 'CR-1 · ruled · 2026-09-01 · Y.K. — take'
neg "a ruling that names no targets" L20 "$TMP/n-targets.md"

# ── 7. the guard ─────────────────────────────────────────────────────────────

printf '\n▸ The humanizer guard — the impact render'"'"'s fixed lines\n'

python3 "$GUARD" --list > "$TMP/pins.txt" 2>&1 \
  && ok "the guard's pinned set prints" \
  || bad "sk_humanizer_guard.py --list failed"
for needle in 'Change —' 'Targets:' 'Changes awaiting your ruling:' \
              'Route —' 'Stops en route:' 'What I need from you:'; do
  has "$TMP/pins.txt" "$needle" "the pinned set carries: $needle"
done
has "$TMP/pins.txt" "§7.7 — the impact render (D-O102)" \
    "…and the two new pins name §7.7 as the section that rules them"
has "$GUARD" '(".specify/aspect-state.md",   "§2.4 — the aspect-state ledger")' \
    "the two runtime ledgers stay exempt entire — the CR records are never rewritten"

# the guard fires on a rewritten impact-render line
printf 'Change — CR-3 · remove online payment · 2026-09-01\n\ntext\n' > "$TMP/g-a.md"
printf 'Change — CR-3 · drop online payment · 2026-09-01\n\ntext\n' > "$TMP/g-b.md"
python3 "$GUARD" --original "$TMP/g-a.md" --candidate "$TMP/g-b.md" 2>"$TMP/g.err" \
  && bad "a rewritten impact-render head line passed the guard" \
  || ok "a rewritten impact-render head line is caught: $(tr -d '\n' < "$TMP/g.err")"

# ── 8. the document ──────────────────────────────────────────────────────────

printf '\n▸ The document — D-O102 · §7.7 · §46, and the sections the ruling touches\n'

has "$DOC" "### 7.7 The change route — \`/ba-change\` (D-O102)" "§7.7 exists, named by D-O102"
has "$DOC" "## 46. Review record (v0.42 → v0.43)" "…and §46, the review record that carries it"
has "$DOC" "**D-O102**" "…and the ruling is on the record"
has "$DOC" "Changes:                  none | CR-<n> — <the change, one line> (<from>) — received" \
    "§2.4's head exhibit carries the Changes: line"
has_joined "$DOC" "**The \`Changes:\` line (D-O102).**" "…with its own paragraph"
has_joined "$DOC" "**An absent line reads \`none\`**" "…and an absent line reads none"
has_joined "$DOC" "It is a record, not an instrument" "…and it never joins §4.3's table"
has "$DOC" "CR records (§7.7)" "§2.4's Events exhibit names the CR records"
has_joined "$DOC" "**An external change is not a signal (D-O102).**" \
    "§9 carries the boundary note — no signal class was added"
has_joined "$DOC" "**The changes tail (D-O102).**" "§10.4 carries the dashboard tail"
has_joined "$DOC" "**A received change — one conditional line on the three reports (D-O102).**" \
    "§10.7 carries the three-report line"
has "$DOC" "| Change route | \`/ba-change <the change …>\`" "§11's binding table carries the Change route row"
has "$QS" "## When a change arrives" "the quickstart carries the companion section"
has "$QS" "| \`/ba-change <the change …>\` |" "…and the command-index row"

# the ruling's own boundary claims, each asserted where it is made
has_joined "$DOC" "**No threshold, no assertion, no gate verdict rule, no session boundary (§10.2), no AG expansion, no new event kind, no new instrument and no new roadmap status:**" \
    "§2.4's change record states the boundary: nothing else moved"
has_joined "$DOC" "D-O94's three-act floor byte-untouched" "…and the safety floor stays three acts"
has_joined "$DOC" "**the route never authoring content**" "…and the route never authors content"

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the change route: the skill · the impact render · P-O10 · the three tails · the ledger · the guard · the document\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
