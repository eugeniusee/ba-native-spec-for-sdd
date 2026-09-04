#!/usr/bin/env bash
#
# BA-Native Spec — autonomous mode: the autonomy grant and the safety floor
# (orchestrator rules §1 · §2.4 · §4.4 · §6.2 · §8.2 · §10.7; D-O35–D-O41 ·
# D-O61–D-O64 · gate §7.1).
#
# An autonomy grant moves the *moment* the BA states a decision. The whole of
# its safety is that it never moves the *content* of one — so the assertions
# here are almost all boundary assertions: what an AG is, where it is recorded,
# which stops it may take, and the four acts it may never reach.
#
#   1.  the grant — the AG record and the `Auto:` head line in the §2.4
#       exhibits, the document and the shipped ledger template
#   2.  the policy table — §10.7's operative strings compiled into the skill,
#       the personas and the mirrors, each one named
#   3.  the safety floor — a proximity sweep across the whole render surface:
#       no compiled sentence AUTO-stamps a ⚑ sign-off, an effective PASS, a
#       handoff or the scope frame, with a seeded control proving the sweep
#       fires on each of the four
#   4.  the resumption report — §10.7's pinned shape, extracted from the
#       document and byte-compared against every file that renders it
#   5.  the mode-read line — byte-identical across check-register.sh's carrier
#       set, with a stripped unit and a paraphrased one as controls
#   6.  the ratification grammar — the events, the batch act, the exceptions
#   7.  the two locked amendments — D-O40 (consent in advance, not silence) and
#       D-O41 (a recorded, revocable grant is not a self-clear)
#   8.  the AUTO-mode fix set — the cost boundary the grant now runs on, the
#       arming run inside the grant, and the render rule that makes an
#       un-electable act a choice (D-O61–D-O64)
#
# The floor list and the negation list are both printed on every run: a sweep
# whose edges are invisible is a sweep nobody can extend. `--list` prints them
# alone.
#
#   check-auto.sh                run the suite
#   check-auto.sh -v             print every check, not just the failures
#   check-auto.sh --list         print the floor and negation lists and exit

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
GATE="$PKG_ROOT/docs/methodology/ba-native-spec-gate-definition.md"
AUTO="$PKG_ROOT/payload/claude/skills/ba-auto/SKILL.md"
ORC="$PKG_ROOT/payload/claude/agents/ba-orchestrator.md"
BLOCK="$PKG_ROOT/payload/mirror/claude-block.md"
AGENTS="$PKG_ROOT/payload/mirror/AGENTS.md"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/aspect-state.md"
CB1="$PKG_ROOT/payload/claude/skills/ba-close-band1/SKILL.md"
ENTF="$PKG_ROOT/payload/claude/skills/ba-enter-feature/SKILL.md"

# ── the safety floor — the three acts no grant reaches ───────────────────────
#
# Seeded from D-O37 (the ⚑ sign-offs, the effective PASS) and D-O42 (the scope
# frame, P-O0b). The handoff tokens left the list at D-O94: the certified-text
# check is a coding-side act run by implementation itself at take-up, not a
# floor act this document answers for — a token for an act the floor no longer
# lists would sweep for a law the corpus stopped having. A sentence that
# carries one of these AND an AUTO token is a candidate; it is a defect unless
# it also carries a negation.
#
# The scope-frame tokens went in with the rebuild, not with the documents pass:
# a token that can match nothing proves nothing, and until the payload carried
# compiled scope-frame text there was nothing for them to sweep.
FLOOR='⚑
sign-off
effective PASS
scope frame
P-O0b'

# The AUTO tokens are deliberately case-sensitive. `AUTO` is the stamp keyword
# (§10.7's grammar), and lowercase "auto" is the mode's ordinary English name —
# "under auto a feature ends at done, awaiting ratification" is a floor
# statement, not a floor breach.
AUTOTOK='AUTO
AUTO-stamp
auto-stamp'

# What makes a candidate sentence legitimate. Every one of these says the same
# thing in a different grammar: this is the boundary, not a licence.
NEGATION='never|outside|safety floor|BA-only|reserved|refuse|banned|not AUTO|awaiting ratification|stays? with the BA'

VERBOSE=0; LIST=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    --list) LIST=1 ;;
    -h|--help) sed -n '2,33p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

if [ "$LIST" -eq 1 ]; then
  printf 'the safety floor — acts no autonomy grant reaches:\n'
  printf '%s\n' "$FLOOR" | sed 's/^/  · /'
  printf '\nthe AUTO tokens (case-sensitive):\n'
  printf '%s\n' "$AUTOTOK" | sed 's/^/  · /'
  printf '\nthe negations that make a candidate legitimate:\n'
  printf '  · %s\n' "$NEGATION"
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

sha_of() { if command -v shasum >/dev/null 2>&1; then shasum -a 256; else sha256sum; fi | cut -d' ' -f1; }

# `has <file> <needle> <what>` — the fixed-string probe the other suites use
has() {
  grep -qF -- "$2" "$1" && ok "$3" || bad "$3 — not found: $2"
}
# `has_joined <file> <needle> <what>` — the same probe over the paragraphs the
# BA actually reads: a soft wrap is invisible in the render (check-register.sh's
# rule), so a sentence that wraps in the source is one string on screen.
has_joined() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (joined): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
sys.exit(0 if sys.argv[2] in re.sub(r"\n(?=\S)", " ", text) else 1)
PY
}
# `has_flow <file> <needle> <what>` — the same probe one step looser: block-quote
# markers are stripped and every run of whitespace collapses to one space, on
# both sides. `has_joined` reads a paragraph as the BA sees it; this reads a
# *sentence* as the BA sees it, wherever its carrier chose to wrap it and
# whether or not that carrier put it in a quote. A rule quoted as law in one
# unit and set as running text in another is one string here — which is what
# lets a single needle assert the same law across the document and four
# compiled surfaces.
has_flow() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (flow): $2"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
flat = re.sub(r"\s+", " ", re.sub(r"(?m)^\s*>\s?", "", text))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]).strip() in flat else 1)
PY
}
# `hasnt_flow` — the same reading, asserting absence. A killed clause has to
# be killed as the BA reads it, not as the source happened to wrap it.
hasnt_flow() {
  python3 - "$1" "$2" <<'PY' && bad "$3 — present but must not be: $2" || ok "$3"
import re, sys
text = open(sys.argv[1], encoding="utf-8").read()
flat = re.sub(r"\s+", " ", re.sub(r"(?m)^\s*>\s?", "", text))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]).strip() in flat else 1)
PY
}

for f in "$DOC" "$GATE" "$AUTO" "$ORC" "$BLOCK" "$AGENTS" "$TPL"; do
  [ -f "$f" ] || { printf '✗ missing source: %s\n' "$f" >&2; exit 2; }
done

# ── 1. the grant — AG and the Auto head line ─────────────────────────────────

printf '\n▸ The autonomy grant — the record and its ledger home (§4.4 · §2.4; D-O35 · D-O38)\n'

has_joined "$DOC" "**AG-\<n\> · scope: \<full workflow | until \<event\>\> · granted-by: \<initials\> · \<date\> · revoke: /ba-auto off, or \<condition\>.**" \
    "§4.4 states the AG record, field for field"
has_joined "$DOC" "an AG waives nothing and rules nothing — it moves the *moment* of consent, never the *content* of a ruling" \
    "…and the distinctness clause that keeps it out of §4.3's table"
has_joined "$DOC" "An AG never grants what the safety floor reserves (§10.7): the ⚑ sign-offs, the effective PASS and the scope frame (P-O0b) stay BA-only — three acts (D-O94)." \
    "…and names the floor inside the instrument itself"

# the head line, in the §2.4 exhibit and in the shipped template — one grammar
HEADLINE='Auto: off | on — AG-<n> · scope <full workflow | until <event>> · since <date>'
has "$DOC" "$HEADLINE" "the §2.4 head exhibit carries the Auto line"
has "$TPL" 'Auto: off' "the shipped ledger template is born with Auto off"
has "$TPL" 'Auto: on — AG-<n> · scope <full workflow | until <event>> · since <date>' \
    "…and carries the populated shape"
has "$TPL" 'AG-<n> · scope: <full workflow | until <event>> · granted-by: <initials> ·' \
    "…and the AG record grammar"
has "$TPL" '<date> · AUTO (AG-<n>) · <act> · <basis>' "…and the AUTO stamp grammar"

# the Auto line sits after Profile, where §10.7's mode read expects to find it.
# Ordering, not adjacency: D-O43 put the five scope-frame lines between them,
# and both rulings say only *after* — D-O38's own wording, D-O42's placement.
python3 - "$DOC" <<'PY' && ok "the Auto line follows the Profile line in the §2.4 head" \
  || bad "the §2.4 head does not carry Auto after Profile"
import sys
lines = open(sys.argv[1], encoding="utf-8").read().splitlines()
prof = auto = None
for i, l in enumerate(lines):
    if prof is None and l.startswith("Profile: <Discovery | Presale>"):
        prof = i
    elif prof is not None and auto is None and l.startswith("Auto: off | on"):
        auto = i
sys.exit(0 if prof is not None and auto is not None and auto > prof else 1)
PY

# the three ledger events — the grant's whole lifecycle, on the record
for pair in \
  "· auto on  · AG-<n> · scope <…> ·|the on event" \
  "· auto off · AG-<n> ·|the off event" \
  "· ratification · AG-<n> ·|the ratification event"
do
  needle="${pair%%|*}"; label="${pair##*|}"
  n=0
  for f in "$DOC" "$TPL"; do grep -qF -- "$needle" "$f" && n=$((n+1)); done
  [ "$n" -eq 2 ] \
    && ok "$label is in both the §2.4 exhibit and the template" \
    || bad "$label is in $n/2 of the document exhibit and the template: $needle"
done

has "$DOC" "AUTO stamp grammar" "§10.7 pins the AUTO stamp grammar"
has "$DOC" '<date> · AUTO (AG-<n>) · <act> · <basis>' "…in the shape every act carries"

# ── 2. the policy table ──────────────────────────────────────────────────────
#
# One probe per ruled row. The strings are the ruling's own load-bearing
# clauses — the ones a future edit would soften rather than delete.

printf '\n▸ The policy table — §10.7 compiled into the skill, the persona and the mirrors (D-O36 · D-O39)\n'

has "$DOC" "### 10.7 Autonomous mode" "the document carries §10.7"
has_joined "$DOC" "The profile never switches mid-auto:" "§10.7 forbids the mid-auto profile switch"
has_joined "$DOC" "\`canvas.md\` present → Presale, absent → Discovery" "…and states the inference rule"
has_joined "$DOC" "The ambiguity law is unchanged: unclear → Open Question, never an invention." \
    "…and holds the ambiguity law unchanged"
has_joined "$DOC" "revisit trigger \`BA ratification sweep (auto off)\`" "…and names the auto-AW's revisit trigger"
has_joined "$DOC" "**no cascades are executed**" "…and executes no reopen cascade"
has_joined "$DOC" "**Overrides NEVER**" "…and refuses the AUTO override"
has_joined "$DOC" "The **supplement lane** (D-O39)" "…and takes P-O9's supplement lane"

# the four surfaces that must carry the policy, each named in the failure
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  n=0; miss=""
  for f in "$AUTO" "$ORC" "$BLOCK" "$AGENTS"; do
    if python3 - "$f" "$phrase" <<'PY'
import re, sys
sys.exit(0 if sys.argv[2].lower() in re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read()).lower() else 1)
PY
    then n=$((n+1)); else miss="$miss $(basename "$f")"; fi
  done
  [ "$n" -eq 4 ] \
    && ok "$label — compiled into the skill, the persona and both mirrors" \
    || bad "$label — missing from$miss"
done <<'POLICY'
the grant is the route go|the grant
unclear stays an Open Question|Open Question
the auto-AW revisit trigger|BA ratification sweep (auto off)
overrides are never AUTO|override
the non-waivable set is fixed and re-gated|non-waivable
the supplement lane|supplement lane
the profile never switches mid-auto|mid-auto
POLICY

# the gate's own half of the ruling
has_joined "$GATE" "P2 waivers on real gaps may be taken AUTO — stamped \`AUTO (AG-<n>)\` in the report entry" \
    "gate §7.1 opens the AUTO waiver lane"
has_joined "$GATE" "Overrides are never AUTO." "…and closes the override lane"
has_joined "$GATE" "The non-waivable set is untouchable under any mode: the auto path fixes and re-gates." \
    "…and keeps the non-waivable set untouchable"
has_joined "$GATE" "P3 ⚑ and P4 approval sit outside every AG — the safety floor, three acts with the scope frame (orchestrator §10.7, D-O94); the adapter's check (§11.2) is implementation's own act, on no floor and under no grant." \
    "…and states the floor in the gate's own words"

# The gate's edition pin — the second of the two copies (check-gate.sh carries
# the first, where it was minted). This check reads the gate document, so it
# pins the edition it read: the 0.1.47 lesson is that one site is never all of
# them, and the 0.1.49 sweep found the orchestrator's pin duplicated exactly
# this way.
head -2 "$GATE" | grep -q 'v0\.16' \
  && ok "the header states the live edition — v0.16, the two Stage-0 refusals told apart" \
  || bad "the header does not name v0.16: the edition and the change record disagree"

# ── 3. the safety floor — the sweep ──────────────────────────────────────────

printf '\n▸ The safety floor — no compiled sentence AUTO-stamps a ⚑ sign-off, an effective PASS or the scope frame (D-O37 · D-O42 · D-O94)\n'
printf '%s\n' "$FLOOR" | sed 's/^/    floor: /'
printf '    negations: %s\n' "$NEGATION"

SWEEP="$TMP/floor_sweep.py"
cat > "$SWEEP" <<'PY'
#!/usr/bin/env python3
"""The floor sweep — an AUTO token and a floor act in one sentence, unnegated.

The render surface is joined into the paragraphs the BA actually sees, then cut
into sentences. A sentence carrying both an AUTO token and a floor act is a
candidate. It is a defect unless it also carries a negation — because the only
legitimate reason to say "AUTO" and "effective PASS" in one breath is to say that the
one never touches the other.

Prints one line per offender, then `files=<n> hits=<m>`: the scanner's contract.
"""
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
FLOOR = [f for f in sys.argv[2].splitlines() if f.strip()]
AUTOTOK = [a for a in sys.argv[3].splitlines() if a.strip()]
NEG = re.compile(sys.argv[4], re.I)

targets = sorted(
    list(root.glob("payload/claude/skills/*/SKILL.md"))
    + list(root.glob("payload/claude/skills/*/references/*.md"))
    + list(root.glob("payload/claude/agents/*.md"))
    + list(root.glob("payload/mirror/*.md"))
    + list(root.glob("payload/specify-overlay/ba/templates/*.md"))
    + list(root.glob("payload/specify-overlay/ba/cards/*.md"))
)

total = 0
for p in targets:
    text = p.read_text(encoding="utf-8")
    joined = re.sub(r"\n(?=\S)", " ", text)
    for n, para in enumerate(joined.splitlines(), 1):
        # sentence granularity: the unit a reader takes as one claim
        for sent in re.split(r"(?<=[.!?])\s+", para):
            if not any(a in sent for a in AUTOTOK):
                continue
            if not any(f in sent for f in FLOOR):
                continue
            if NEG.search(sent):
                continue
            total += 1
            print("%s:%d\t%s" % (p.relative_to(root), n, sent.strip()[:160]))
print("files=%d hits=%d" % (len(targets), total))
PY

sweep() { python3 "$SWEEP" "$1" "$FLOOR" "$AUTOTOK" "$NEGATION"; }

sweep "$PKG_ROOT" > "$TMP/floor.out" 2>&1
F_FILES="$(sed -n 's/^files=\([0-9]*\) hits=[0-9]*$/\1/p' "$TMP/floor.out")"
F_HITS="$(sed -n 's/^files=[0-9]* hits=\([0-9]*\)$/\1/p' "$TMP/floor.out")"

[ "${F_FILES:-0}" -gt 0 ] 2>/dev/null \
  && ok "the render surface derives — $F_FILES files swept" \
  || bad "the sweep globs matched nothing: section 3 would pass vacuously"

if [ "${F_HITS:-x}" = "0" ]; then
  ok "zero unnegated AUTO-stamps of a floor act across $F_FILES files"
else
  bad "${F_HITS:-?} sentence(s) AUTO-stamp a safety-floor act:"
  grep -v '^files=' "$TMP/floor.out" | sed 's/^/      /' | head -12
fi

# the control: three seeds, one per floor act — the sweep is worth nothing
# until each of the three is shown to trip it
CTL="$TMP/ctl"
mkdir -p "$CTL"
( cd "$PKG_ROOT" && tar cf - payload ) | ( cd "$CTL" && tar xf - )

sweep "$CTL" > "$TMP/ctl-clean.out" 2>&1
[ "$(sed -n 's/^files=[0-9]* hits=\([0-9]*\)$/\1/p' "$TMP/ctl-clean.out")" = "0" ] \
  && ok "the private copy sweeps clean before injection — the control starts at 0" \
  || bad "the copied surface is not clean at 0; the control cannot be read"

SEED="$CTL/payload/claude/skills/ba-auto/SKILL.md"
{
  printf '\nUnder a standing grant the ⚑ sign-offs are taken AUTO (AG-1).\n'
  printf '\nThe effective PASS is stamped AUTO (AG-1) once the run is clean.\n'
  printf '\nThe scope frame is set AUTO (AG-1) from the pre-filled block.\n'
} >> "$SEED"

sweep "$CTL" > "$TMP/ctl-dirty.out" 2>&1
C_HITS="$(sed -n 's/^files=[0-9]* hits=\([0-9]*\)$/\1/p' "$TMP/ctl-dirty.out")"
[ "${C_HITS:-0}" = "3" ] \
  && ok "the control fires on all three floor acts — ⚑ sign-off, effective PASS, scope frame" \
  || bad "the three seeded floor breaches produced ${C_HITS:-?} hits, expected 3"

# and the negation must still work: the same three sentences, negated, are legal
cp "$PKG_ROOT/payload/claude/skills/ba-auto/SKILL.md" "$SEED"
{
  printf '\nUnder a standing grant the ⚑ sign-offs are never taken AUTO (AG-1).\n'
  printf '\nThe effective PASS is never stamped AUTO (AG-1), in any mode.\n'
} >> "$SEED"
sweep "$CTL" > "$TMP/ctl-neg.out" 2>&1
[ "$(sed -n 's/^files=[0-9]* hits=\([0-9]*\)$/\1/p' "$TMP/ctl-neg.out")" = "0" ] \
  && ok "…and the negated forms stay legal — the sweep reads the prohibition" \
  || bad "a negated floor sentence was flagged: the sweep cannot read a prohibition"

# the floor said in full, in the document and on the surfaces that execute it
has_joined "$DOC" "the **⚑ sign-offs** (CC-XA-01 authorization, CC-XA-06 the scope boundary — gate P3), the **effective PASS** (gate P3 + P4), and **the scope frame** (P-O0b, §8.1)" \
    "§10.7 names the three floor acts"
has_joined "$DOC" "auto therefore terminates at **\"done, awaiting ratification\"**" \
    "…and where auto terminates per feature"

# and the compiled surfaces that state the floor in full state three acts, not
# four: a payload that named four would be describing a floor the document
# stopped having at D-O94.
for pair in "$AUTO|the skill" "$ORC|the orchestrator persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  python3 - "$f" <<'PY' && ok "$label states the floor's fourth act — the scope frame" \
    || bad "$label states the floor without the scope frame (P-O0b)"
import re, sys
t = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
sys.exit(0 if "scope frame" in t and "P-O0b" in t else 1)
PY
done
has_joined "$AUTO" "**P-O0b — scope-frame selection** | **Never AUTO — the safety floor.**" \
    "…and the skill's policy table carries the never-AUTO row"
for pair in "$AUTO|the skill" "$PKG_ROOT/payload/claude/skills/ba-dev-ready/SKILL.md|ba-dev-ready" \
            "$PKG_ROOT/payload/claude/skills/ba-gate/SKILL.md|the gate skill" \
            "$PKG_ROOT/payload/claude/agents/ba-gate.md|the gate persona"; do
  f="${pair%%|*}"; label="${pair##*|}"
  python3 - "$f" <<'PY' && ok "$label carries the floor" || bad "$label carries no safety-floor line"
import re, sys
t = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read()).lower()
sys.exit(0 if ("safety floor" in t or "never under an" in t or "outside every" in t
               or "outside every grant" in t) else 1)
PY
done

has_joined "$AUTO" "**never grants itself an AG**" "the skill refuses to grant itself a grant"

# the dev-ready route (D-O93) — the skill renders §7.6's pinned instance and
# names the human tail; it carries the floor by naming what it never takes
DEVR="$PKG_ROOT/payload/claude/skills/ba-dev-ready/SKILL.md"
has_joined "$DEVR" "Route — dev-ready:" \
    "ba-dev-ready renders the §7.6 route instance"
has_joined "$DEVR" "Resume from: /ba-auto off → ratify the batch" \
    "…and its stop report names the human tail in plain words"

# rule 11 — named by outcome (D-O96): the six register carriers, once each
printf '\n▸ Register rule 11 — named by outcome (D-O96), in the six carriers\n'
for f in "$BLOCK" "$AGENTS" \
         "$PKG_ROOT/payload/claude/agents/ba-analyst.md" \
         "$PKG_ROOT/payload/claude/agents/ba-discovery.md" \
         "$PKG_ROOT/payload/claude/agents/ba-gate.md" \
         "$PKG_ROOT/payload/claude/agents/ba-orchestrator.md"; do
  n="$(grep -cF '11. **Named by outcome (D-O96).**' "$f")"
  [ "$n" = "1" ] \
    && ok "$(basename "$f") carries rule 11 exactly once" \
    || bad "$(basename "$f") carries rule 11 $n times, expected exactly 1"
done

# ── 4. the resumption report — the pinned shape ──────────────────────────────

printf '\n▸ The resumption report — §10.7'"'"'s pinned shape, byte for byte (D-O36)\n'

SHAPE="$TMP/shape.py"
cat > "$SHAPE" <<'PY'
#!/usr/bin/env python3
"""A pinned §10.7 block: from the document, and from a compiled unit.

argv: <doc|unit> <path> [<block head>] — the head defaults to the resumption
report; the band-boundary report (D-O52) passes its own.

Neither side is pinned in the suite — the document's block is extracted and the
unit's is found by its own first line, then the two are compared. A reworded
document breaks the check instead of drifting past it (check-register.sh §6's
discipline, one shape over).
"""
import re
import sys
from pathlib import Path

HEAD = sys.argv[3] if len(sys.argv) > 3 else "Auto off — "


def blocks(text):
    out, buf, fenced = [], None, False
    for line in text.splitlines():
        if line.lstrip().startswith("```"):
            if fenced:
                out.append("\n".join(buf))
                buf = None
            else:
                buf = []
            fenced = not fenced
            continue
        if fenced:
            buf.append(line)
    return out


path = Path(sys.argv[2])
text = path.read_text(encoding="utf-8")
if sys.argv[1] == "doc":
    sec = re.search(r"^### 10\.7\b.*?(?=^---\s*$)", text, re.M | re.S)
    if not sec:
        sys.exit("orchestrator §10.7 not found — the shape has no source")
    text = sec.group(0)
found = [b for b in blocks(text) if b.startswith(HEAD)]
if not found:
    sys.exit("no %r block in %s" % (HEAD, path.name))
print(found[0])
PY

python3 "$SHAPE" doc "$DOC" > "$TMP/shape-doc.txt" 2>"$TMP/shape-doc.err"
if [ -s "$TMP/shape-doc.txt" ]; then
  ok "§10.7 yields the resumption report — $(wc -l < "$TMP/shape-doc.txt" | tr -d ' ') lines"
else
  bad "§10.7's fenced block does not extract: the shape cannot be checked from source"
  sed 's/^/      /' "$TMP/shape-doc.err"
fi

# vacuity: an emptied or reshaped block that still extracts would let a
# byte-match pass while asserting nothing
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  grep -qF -- "$phrase" "$TMP/shape-doc.txt" \
    && ok "the source block still carries $label" \
    || bad "§10.7's block no longer carries $label — re-read the document first"
done <<'LINES'
the stop point and the mid-flight state|Stopped at: <point> · mid-flight:
the draft rule for an aborted run|run aborted, artifact stays draft
the trail, one line per act|Auto-trail: <n> acts — one line each:
the assumption and question counts|Assumptions: <n> · Open questions: <n>
the ratification line|Ratify: accept all / list exceptions
the next manual act|Next manual act: <one line>
LINES

for pair in "$AUTO|the ba-auto skill" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  python3 "$SHAPE" unit "$f" > "$TMP/shape-unit.txt" 2>"$TMP/shape-unit.err"
  if [ ! -s "$TMP/shape-unit.txt" ]; then
    bad "$label carries no resumption-report block"
    sed 's/^/      /' "$TMP/shape-unit.err"
  elif diff -u "$TMP/shape-doc.txt" "$TMP/shape-unit.txt" > "$TMP/shape.diff" 2>&1; then
    ok "$label is byte-identical to §10.7 — the shape is compiled, not rewritten"
  else
    bad "$label diverges from §10.7's pinned shape:"
    sed 's/^/      /' "$TMP/shape.diff" | head -14
  fi
done

# the control: one dropped line in a private copy must go red
SHC="$TMP/shape-corpus"
mkdir -p "$SHC"
cp "$AUTO" "$SHC/SKILL.md"
python3 - "$SHC/SKILL.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text(encoding="utf-8")
p.write_text(t.replace("Ratify: accept all / list exceptions\n", ""), encoding="utf-8")
PY
python3 "$SHAPE" unit "$SHC/SKILL.md" > "$TMP/shape-dirty.txt" 2>&1
diff -q "$TMP/shape-doc.txt" "$TMP/shape-dirty.txt" >/dev/null 2>&1 \
  && bad "a dropped Ratify line slips through — the byte-match does not hold" \
  || ok "the control fires — a dropped report line goes red"

# the shape is a pinned format, so it joins register rule 8's list
has "$DOC" "resumption report §10.7" "§10.3 rule 8's list carries the resumption report"
for f in "$ORC" "$BLOCK" "$AGENTS"; do
  has "$f" "resumption report §10.7" "…compiled into $(basename "$f")"
done

# ── 4b. continuity under a grant, and the band-boundary report ───────────────
#
# D-O51 · D-O52. The field defect this closes: a run under a standing AG took
# every act correctly and then narrated each aspect to the BA — and a
# conversational render ends the turn, so the grant that was written to remove
# stops was delivering one per aspect. Two assertions follow from that: the
# continuity rule is compiled wherever a run could render mid-band, and the one
# render that *is* legal at a band boundary is pinned like every other shape.

printf '\n▸ Continuity under a grant · the band-boundary report (D-O51 · D-O52)\n'

# the rule itself — joined, because every carrier soft-wraps it differently
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  for f in "$DOC" "$AUTO" "$BLOCK" "$AGENTS"; do
    has_joined "$f" "$phrase" "$(basename "$f") — $label"
  done
done <<'LINES'
the no-render rule|no conversational render occurs between acts
the turn rule|never ends its turn between acts inside a band
the ledger destination|ledger and the auto-trail only
the boundary stop|band boundary
the floor stop|safety-floor stop
LINES

# the four stop events, named in the owner and the document
for f in "$DOC" "$AUTO"; do
  has_joined "$f" "exactly one of four" "$(basename "$f") — the run ends on exactly four events"
done

# the grant survives the boundary: the report is a render, not a ratification
has_joined "$AUTO" "render, not a ratification point" \
  "ba-auto — the boundary report takes no BA ruling"
has_joined "$DOC" "render, not a ratification point" \
  "§10.7 — the boundary report takes no BA ruling"

# the never-does list gains the turn rule
has_joined "$AUTO" "never ends the" \
  "ba-auto — 'what this skill never does' carries the turn rule"

# the pinned shape, byte for byte, from §10.7 into all five renderers
BHEAD='Band boundary — '
python3 "$SHAPE" doc "$DOC" "$BHEAD" > "$TMP/bshape-doc.txt" 2>"$TMP/bshape-doc.err"
if [ -s "$TMP/bshape-doc.txt" ]; then
  ok "§10.7 yields the band-boundary report — $(wc -l < "$TMP/bshape-doc.txt" | tr -d ' ') lines"
else
  bad "§10.7's band-boundary block does not extract: the shape cannot be checked from source"
  sed 's/^/      /' "$TMP/bshape-doc.err"
fi

# vacuity: a block that extracts but says nothing would pass a byte-match
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  grep -qF -- "$phrase" "$TMP/bshape-doc.txt" \
    && ok "the source block still carries $label" \
    || bad "§10.7's band-boundary block no longer carries $label"
done <<'LINES'
the AUTO stamp and which boundary|· AUTO (AG-<n>) ·
both boundary acts|P-O7 Band-1 closure | P-O8 Band-3 entry
the trail since the last boundary|Auto-trail since <start | last boundary>
the assumption and question counts|Assumptions: <n> · Open questions: <n>
the health-refresh state (D-O59)|Health refresh: <current | overdue: <r> runs vs cadence>
the boundary-coverage state (D-O100)|Scope coverage: <in-boundary epics briefed <b>/<e>
the coverage line's absent-source alternate|— no roadmap or no boundary yet>
the continuation — any reply resumes|any reply continues
the off route to the resumption report|/ba-auto off renders the resumption report
LINES

for pair in "$AUTO|the ba-auto skill" "$CB1|ba-close-band1 (P-O7)" \
            "$ENTF|ba-enter-feature (P-O8)" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  python3 "$SHAPE" unit "$f" "$BHEAD" > "$TMP/bshape-unit.txt" 2>"$TMP/bshape-unit.err"
  if [ ! -s "$TMP/bshape-unit.txt" ]; then
    bad "$label carries no band-boundary block"
    sed 's/^/      /' "$TMP/bshape-unit.err"
  elif diff -u "$TMP/bshape-doc.txt" "$TMP/bshape-unit.txt" > "$TMP/bshape.diff" 2>&1; then
    ok "$label is byte-identical to §10.7 — the shape is compiled, not rewritten"
  else
    bad "$label diverges from §10.7's pinned band-boundary shape:"
    sed 's/^/      /' "$TMP/bshape.diff" | head -14
  fi
done

# the control: a reworded line in a private copy must go red
BSHC="$TMP/bshape-corpus"
mkdir -p "$BSHC"
cp "$AUTO" "$BSHC/SKILL.md"
python3 - "$BSHC/SKILL.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text(encoding="utf-8")
p.write_text(t.replace("any reply continues", "press enter to continue"), encoding="utf-8")
PY
python3 "$SHAPE" unit "$BSHC/SKILL.md" "$BHEAD" > "$TMP/bshape-dirty.txt" 2>&1
diff -q "$TMP/bshape-doc.txt" "$TMP/bshape-dirty.txt" >/dev/null 2>&1 \
  && bad "a reworded continuation line slips through — the byte-match does not hold" \
  || ok "the control fires — a reworded boundary line goes red"

# ── the scope-advisory decision list — the conditional tail on both reports ──
#
# D-O69. The tail is an addition to two shapes the suite already byte-matches,
# so what is asserted here is what the byte-match cannot see: that the tail
# exists on every surface that renders either report, in the document's own
# words, with its three dispositions, its safe default, its ruling home, its
# manual carrier and the autonomy clause. The pinned shapes are proven untouched
# above — the tail is its own fenced block and never edits theirs.

printf '\n▸ The scope-advisory decision list — the tail on both reports (§10.7; D-O68–D-O69)\n'

ADVHEAD='Scope advisories — <n> standing · decide each (P-A1 row shape — source-audit definition §5)'
ADVRULE='Rulings: apply all · apply all except <#…> · <#>: <letter> <argument>'

has "$DOC" "$ADVHEAD" "§10.7 pins the decision-list tail's first line"
has "$DOC" "$ADVRULE" "…and its rulings line"

# every surface that renders either report carries the tail
for pair in "$AUTO|the ba-auto skill" "$CB1|ba-close-band1 (P-O7)" \
            "$ENTF|ba-enter-feature (P-O8)" "$BLOCK|the CLAUDE.md block" \
            "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  if grep -qF -- "$ADVHEAD" "$f" && grep -qF -- "$ADVRULE" "$f"; then
    ok "$label renders a report and carries the decision-list tail"
  else
    bad "$label renders a report but carries no decision-list tail (D-O69)"
  fi
done

# the tail is conditional, and it is an addition — never a replacement
for pair in "$DOC|§10.7" "$AUTO|ba-auto" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  grep -qF -- "never a replacement" "$f" \
    && ok "the tail is an addition, never a replacement — $label" \
    || bad "$label does not say the tail never replaces the pinned shape"
done

# the law the tail carries: the shape, the dispositions, the default, the home
for pair in "$AUTO|ba-auto" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  while IFS='|' read -r what phrase; do
    [ -z "$what" ] && continue
    grep -qF -- "$phrase" "$f" \
      && ok "$label carries $what" \
      || bad "$label is missing $what (D-O69)"
  done <<'ADVLAW'
the P-A1 row shape, cited never restated|P-A1 row shape
disposition (a), the default|hold as advisory — no move
disposition (b), never an inline edit|never an inline phase edit
the ADV tag a directed move carries|BA-directed (ADV-<n>)
disposition (c) on the SA record pattern|SA record
the safe default|apply all
the reason rule — no silent end to a finding|without a reason
the manual carrier — T-18's step-4 approval|step-4 approval
the autonomy clause — an AG never answers it|never answers it
ADVLAW
done

# the register the tail reads is the ledger head's, and the ruling lands on an
# event that already exists — no new event kind
has "$AUTO" "Scope advisories:" "ba-auto reads the register from the ledger head"
has "$AUTO" "no new event kind exists" "…and the ruling lands with no new event kind"
has "$AUTO" "the manual ratification batch" \
    "…and the act that does not exist is named as not existing"

# seeded defect — a standing advisory that reaches no report tail
ADVC="$TMP/adv-corpus"
mkdir -p "$ADVC"
cp "$AUTO" "$ADVC/SKILL.md"
python3 - "$ADVC/SKILL.md" "$ADVHEAD" <<'PYSTRIP'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text(encoding="utf-8")
p.write_text(t.replace(sys.argv[2] + "\n", ""), encoding="utf-8")
PYSTRIP
if grep -qF -- "$ADVHEAD" "$ADVC/SKILL.md"; then
  bad "the seeded strip did not land — the control proves nothing"
elif grep -qF -- "$ADVHEAD" "$AUTO"; then
  ok "the control fires — a standing advisory reaching no report tail goes red"
else
  bad "ba-auto lost its decision-list tail: a standing advisory would reach no report"
fi


# the shape is a pinned format, so it joins register rule 8's list
has "$DOC" "band-boundary report §10.7" "§10.3 rule 8's list carries the band-boundary report"
for f in "$ORC" "$BLOCK" "$AGENTS"; do
  has "$f" "band-boundary report §10.7" "…compiled into $(basename "$f")"
done

# the register clause: under a grant, renders address the ledger
for pair in "$DOC|§10.3 rule 8" "$ORC|ba-orchestrator" "$AUTO|ba-auto" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md" \
            "$CB1|ba-close-band1" "$ENTF|ba-enter-feature"; do
  has_joined "${pair%%|*}" "address the ledger, not the conversation" \
    "${pair##*|} — the under-AG register clause"
done

# ── 5. the mode-read line, across the carrier set ────────────────────────────
#
# check-register.sh's carrier set, to the byte: every skill, every persona, both
# mirrors. A new skill joins by existing — the glob is the list.

printf '\n▸ The mode read — byte-identical across the carrier set (§2.4 · §10.7)\n'

cat > "$TMP/moderead.txt" <<'MR'
**Mode read (framework-wide):** before the first act of any session, read the
aspect-state head — the Profile and Auto lines govern.
MR
MR_SHA="$(sha_of < "$TMP/moderead.txt")"
MR_N="$(wc -l < "$TMP/moderead.txt" | tr -d ' ')"

moderead_sweep() {
  local root="$1" n=0 okc=0 miss=0 alt=0 ln
  # D-O89 — framework units only. The vendored `humanizer` skill carries no
  # 'ba-' prefix and no framework standing blocks by design: it is a pinned
  # third-party file, and requiring our instructions in it would be a delta.
  for f in "$root"/payload/claude/skills/ba-*/SKILL.md \
           "$root"/payload/claude/agents/*.md \
           "$root"/payload/mirror/*.md; do
    [ -f "$f" ] || continue
    n=$((n+1))
    ln="$(grep -n '^\*\*Mode read (framework-wide):\*\*' "$f" | head -1 | cut -d: -f1)"
    if [ -z "$ln" ]; then
      miss=$((miss+1)); printf '  missing: %s\n' "${f#"$root"/}"; continue
    fi
    if [ "$(sed -n "${ln},$((ln+MR_N-1))p" "$f" | sha_of)" = "$MR_SHA" ]; then
      okc=$((okc+1))
    else
      alt=$((alt+1)); printf '  altered: %s\n' "${f#"$root"/}"
    fi
  done
  printf 'units=%s ok=%s missing=%s altered=%s\n' "$n" "$okc" "$miss" "$alt"
}

moderead_sweep "$PKG_ROOT" > "$TMP/mr-clean.out"
MR_SUM="$(tail -1 "$TMP/mr-clean.out")"
MR_UNITS="$(printf '%s' "$MR_SUM" | sed -n 's/^units=\([0-9]*\).*/\1/p')"
MR_MISS="$(printf '%s' "$MR_SUM"  | sed -n 's/.*missing=\([0-9]*\).*/\1/p')"
MR_ALT="$(printf '%s' "$MR_SUM"   | sed -n 's/.*altered=\([0-9]*\)$/\1/p')"

[ "${MR_UNITS:-0}" -gt 0 ] \
  && ok "the carrier glob derives a non-empty set — $MR_UNITS units" \
  || bad "the carrier glob matched nothing: section 5 would pass vacuously"

if [ "$MR_MISS" = "0" ] && [ "$MR_ALT" = "0" ]; then
  ok "the mode read is byte-identical in all $MR_UNITS skills, personas and mirrors"
else
  bad "the mode read is missing from $MR_MISS and altered in $MR_ALT of $MR_UNITS units:"
  grep -E '^  (missing|altered):' "$TMP/mr-clean.out" | sed 's/^/    /' | head -10
fi

# ba-auto is in the carrier set by existing, and it is the command the line
# points at — a set that lost it would be reporting on a mode nobody can enter
grep -q '^  missing: payload/claude/skills/ba-auto/SKILL.md$' "$TMP/mr-clean.out" \
  && bad "the ba-auto skill itself carries no mode read" \
  || ok "…the ba-auto skill included — the glob is the list, not a hand-kept set"

# the control: one stripped, one paraphrased
MRC="$TMP/mr-corpus"
mkdir -p "$MRC"
( cd "$PKG_ROOT" && tar cf - payload/claude/skills payload/claude/agents payload/mirror ) \
  | ( cd "$MRC" && tar xf - )

python3 - "$MRC/payload/claude/skills/ba-status/SKILL.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); lines = p.read_text(encoding="utf-8").splitlines(keepends=True)
i = next(i for i, l in enumerate(lines) if l.startswith("**Mode read (framework-wide):**"))
del lines[i:i + 3]
p.write_text("".join(lines), encoding="utf-8")
PY
python3 - "$MRC/payload/claude/agents/ba-discovery.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); t = p.read_text(encoding="utf-8")
p.write_text(t.replace("the Profile and Auto lines govern.", "the profile and auto lines apply."), encoding="utf-8")
PY

moderead_sweep "$MRC" > "$TMP/mr-dirty.out"
MR_DSUM="$(tail -1 "$TMP/mr-dirty.out")"
[ "$(printf '%s' "$MR_DSUM" | sed -n 's/.*missing=\([0-9]*\).*/\1/p')" = "1" ] \
  && ok "the control fires — the stripped unit is caught as missing" \
  || bad "a unit with no mode read passed the sweep: it is blind"
[ "$(printf '%s' "$MR_DSUM" | sed -n 's/.*altered=\([0-9]*\)$/\1/p')" = "1" ] \
  && ok "…and the paraphrased unit is caught as altered" \
  || bad "a paraphrased mode read passed the sweep: the byte-match does not hold"

# ── 6. the ratification grammar ──────────────────────────────────────────────

printf '\n▸ Ratification — one batch act, exceptions reopen manually (D-O36)\n'

has_joined "$DOC" "**Ratification is one batch act;** exceptions reopen their items manually" \
    "§10.7 makes ratification one batch act"
has_joined "$DOC" "The ratification appends its event (§2.4) and closes the AG." \
    "…and closes the grant with an event"
has_joined "$DOC" "A run interrupted mid-flight leaves its artifact a **draft**" \
    "…and leaves an interrupted run's artifact a draft"

for pair in "$AUTO|the skill" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  has_joined "$f" "Ratification is one batch act" "$label carries the batch-ratification rule"
done
has "$AUTO" '<date> · ratification · AG-<n> · <initials> — accepted all | exceptions: <list>' \
    "the skill carries the ratification event grammar"

# the auto-trail section on the dashboard — the trail the ratification reads
has "$DOC" 'trail <n> AUTO acts · unratified <u>' "§10.4's auto-trail section renders the counts"
has "$PKG_ROOT/payload/claude/skills/ba-status/SKILL.md" 'trail <n> AUTO acts · unratified <u>' \
    "…compiled into the dashboard skill"
has_joined "$DOC" "renders **only once an AG record exists in the ledger**" \
    "…and renders only once a grant exists"
has_joined "$PKG_ROOT/payload/claude/skills/ba-status/SKILL.md" \
    "Rendering the trail is not ratifying it." "…and rendering is not ratifying"

# ── 7. the two locked amendments ─────────────────────────────────────────────

printf '\n▸ The locked amendments — D-O40 (consent in advance) · D-O41 (not a self-clear)\n'

has_joined "$DOC" "**A standing autonomy grant (AG, §4.4) is explicit consent recorded in advance — not silence (D-O40, locked).**" \
    "§6.2 amends D-O13: a grant is consent in advance, not silence"
has_joined "$DOC" "the grant is the BA's stated act for every act inside its scope, each stamped AUTO and standing for ratification at \`off\`" \
    "…and says what the grant stands for"
has_joined "$DOC" "**A transition under a recorded, revocable autonomy grant is not a self-clear (D-O41, locked):**" \
    "§1 principle 2 amends the self-clear rule"
has_joined "$DOC" "the framework still never clears on its own account, and every AUTO transition stands for ratification at \`off\`" \
    "…without weakening what it amends"

# D-O13's own case survives its amendment — the sentence a future edit would drop
has_joined "$DOC" "**Silence is never consent; a rendered suggestion is never a plan.**" \
    "D-O13's own case stands unchanged in §6.2"
has_joined "$DOC" "Silence is never consent: a route executes only on a stated \`go\` (D-O13 unchanged)." \
    "…and in §7.5, where the route takes its go"

# the self-clear echoes carry the cross-reference where the act is the clearing
has "$DOC" "An aspect gate never self-clears (AG transitions: §10.7 — BA-granted, ratifiable)." \
    "§3.4's echo carries the cross-reference"
has "$ORC" "(AG transitions: \`/ba-auto\` — BA-granted, ratifiable)" \
    "the orchestrator persona's rule 2 carries it"
has "$TPL" "(AG transitions: /ba-auto — BA-granted, ratifiable)" \
    "the ledger template carries it"
has_joined "$PKG_ROOT/payload/claude/skills/ba-clear/SKILL.md" \
    "a recorded, revocable grant is not a self-clear" \
    "the clearing skill carries the amendment where the act happens"

# the review record, and the block it allocates
has "$DOC" "## 19. Review record (v0.13 → v0.14)" "§19 records the ruling set"
for d in 35 36 37 38 39 40 41; do
  grep -qF -- "**D-O$d**" "$DOC" || bad "D-O$d is not ruled in the document"
done
n=0; for d in 35 36 37 38 39 40 41; do grep -qF -- "**D-O$d**" "$DOC" && n=$((n+1)); done
[ "$n" -eq 7 ] && ok "the D-O35–D-O41 block is contiguous and complete — 7 rulings"

# ── 8. the cost boundary · the arming run · the render rule ─────────────────
#
# D-O61–D-O64, the AUTO-mode fix set. The field defect this closes: a Presale
# auto run took Band 1 and Band 2 correctly and then held for good, because the
# grant reached *recommended* acts only and Tier 1 — epic scoping is always
# `optional` under Presale (no AT criterion demands a brief: briefs are Band-2
# ground and Band 2 is aspect-less, D-O1). The one act that produces briefs was
# permanently out of reach of the one mode meant to run without the BA — on
# every project. Three assertions follow: the boundary is *cost* and says so in
# the document and on all four surfaces; the arming request is inside the grant
# wherever closure is performed; and an un-electable act renders as a choice.

printf '\n▸ The cost boundary · the arming run · the render rule (D-O61–D-O64)\n'

CB1S="$PKG_ROOT/payload/claude/skills/ba-close-band1/SKILL.md"
GH="$PKG_ROOT/payload/claude/skills/ba-gate-health/SKILL.md"
T1="$PKG_ROOT/payload/claude/skills/ba-tier1/SKILL.md"
QS="$PKG_ROOT/docs/quickstart.md"

# the boundary itself — one sentence, five carriers, however each one wraps it
for pair in "$DOC|§10.7" "$AUTO|the skill" "$ORC|the orchestrator persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  has_flow "$f" "self-elect any act that spends no client access and makes no external commitment" \
      "$label states the cost boundary"
  has_flow "$f" "self-election lands in the ratification batch" \
      "…and $label sends every self-election to the batch"
done

# the boundary's own edges, in the document that owns them
has_flow "$DOC" "the framework schedules nobody's time" \
    "§10.7 refuses to spend client time"
has_flow "$DOC" "The safety floor is not this boundary" \
    "…and keeps the floor outside the cost test"
has_flow "$DOC" "D-O12 is preserved, not weakened" \
    "…and preserves election-remains-the-BA's-act"
has_flow "$DOC" "recommended\` was a proxy for" \
    "…and names the replaced boundary as the proxy it was"

# the pinned Presale instance — the dead end the run hit, closed by name
for pair in "$DOC|§10.7" "$AUTO|the skill"; do
  f="${pair%%|*}"; label="${pair##*|}"
  has_flow "$f" "still gets its brief" "$label briefs the open-question-blocked epic anyway"
done

# ── EC-22 · D-O99 — the election takes the boundary, in every carrier ────────
#
# The clause the field run executed read "every epic allocated to the FIRST
# PHASE" while the scope frame quoted two, so 2 of 14 roadmap epics — both
# billable — were never briefed. The set is now the frame's own `Boundary:`.

CLAUSE="every epic allocated to a phase inside the scope frame's \`Boundary:\` set"
for pair in "$DOC|§10.7 + §6.5" "$AUTO|the ba-auto skill" "$T1|ba-tier1" \
            "$ORC|the persona" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  has_flow "$f" "$CLAUSE" "$label takes the boundary, not the first phase (D-O99)"
done

# the clause stands exactly once per compiled carrier — one rule, one statement
for pair in "$AUTO|the ba-auto skill" "$T1|ba-tier1" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  N=$(python3 - "$f" "$CLAUSE" <<'PYX'
import re, sys
hay = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
print(hay.count(re.sub(r"\s+", " ", sys.argv[2])))
PYX
)
  [ "$N" = "1" ] && ok "…and $label states it exactly once" \
                 || bad "$label states the boundary clause $N time(s), expected 1"
done

# the killed strings, and the ba-orchestrator drift variant beside them
for pair in "$AUTO|the ba-auto skill" "$T1|ba-tier1" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md" "$QS|the quickstart"; do
  f="${pair%%|*}"; label="${pair##*|}"
  for dead in "every epic allocated to the first phase" "every epic in the first phase"; do
    hasnt_flow "$f" "$dead" "$label carries no \"$dead\""
  done
done

# the quickstart says it in the BA's own words — the sixth carrier, Lane B's
has_flow "$QS" "it scopes every epic inside your delivery boundary" \
    "the quickstart states the boundary in plain words"
has_flow "$QS" "If a billable epic is ever left unbriefed" \
    "…and names the surfaces that would say so"

# the two historical occurrences in the document are byte-deliberate: D-O61's
# own register row, and the v0.42 change record quoting the clause it replaced.
# A ruling is amended on the record, never rewritten out of it.
NDEAD=$(python3 - "$DOC" <<'PYX'
import re, sys
hay = re.sub(r"\s+", " ", open(sys.argv[1], encoding="utf-8").read())
print(hay.count("every epic allocated to the first phase"))
PYX
)
[ "$NDEAD" = "2" ] \
  && ok "…and the document keeps exactly 2 — D-O61's row and v0.42's quotation, amended never rewritten" \
  || bad "the document carries $NDEAD occurrences of the replaced clause, expected 2"
has_flow "$DOC" "ingest mode over captured client material" "§10.7 names the input path"
has_flow "$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md" \
    "Under a standing AG the captured-material path is self-elected" \
    "…and §6.5 carries it where the profile is defined"

# the call is client access — it stays the BA's, in the skill that would run it
has_flow "$T1" "never books, schedules or commits a client call" \
    "ba-tier1 never books a call"
has_flow "$T1" "grant reaches every act that" \
    "…and states which of its modes the grant reaches"
for pair in "$DOC|§10.7" "$AUTO|the skill" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  has_flow "${pair%%|*}" "call stays BA-elected" "${pair##*|} — the client call stays BA-elected"
done

# the arming run — inside the grant wherever closure is performed (D-O62)
for pair in "$DOC|§10.7 + §8.2" "$AUTO|the skill" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md" \
            "$CB1S|ba-close-band1" "$GH|ba-gate-health"; do
  has_flow "${pair%%|*}" "closed but unarmed" "${pair##*|} — no run stands closed but unarmed"
done
has_flow "$DOC" "the closing step of P-O7" "§10.7's row makes it P-O7's closing step"
has_flow "$DOC" "Under a standing AG, step 3 is inside the grant" \
    "…and §8.2 says so where the act happens"
for pair in "$DOC|§10.7" "$AUTO|the skill" "$CB1S|ba-close-band1" "$GH|ba-gate-health"; do
  has_flow "${pair%%|*}" "rides the ratification batch" "${pair##*|} — gate P8 rides the batch"
done
# the division of labour survives the ruling: the orchestrator still runs nothing
has_flow "$DOC" "The **gate still runs it** — the orchestrator requests and runs nothing" \
    "§10.7 keeps the request/run split"
has_flow "$CB1S" "you request, the gate runs" "…and ba-close-band1 keeps it too"

# the render rule (D-O63) — the pinned choice line, and the banned words
for pair in "$DOC|§10.7" "$AUTO|the skill" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md" \
            "$ENTF|ba-enter-feature"; do
  has_flow "${pair%%|*}" \
      "Destination reached — <what stands> · extension available by election: " \
      "${pair##*|} — the choice line, pinned"
done
for pair in "$DOC|§10.7" "$AUTO|the skill" "$ORC|the persona" \
            "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  has_flow "${pair%%|*}" "describe a defect" "${pair##*|} — blocked/locked name a defect, not a choice"
done
has_flow "$DOC" "No pinned shape changes" "§10.7 changes no pinned shape"
has_flow "$AUTO" "never renders an un-electable act as \`blocked\` or \`locked\`" \
    "…and the skill's never-list carries the render rule"
has_flow "$ORC" "never render an un-electable act as \`blocked\` or \`locked\`" \
    "…and the persona's never-list carries it"
has_flow "$AUTO" "never books a client call, a workshop or an interview slot" \
    "…and the skill's never-list carries the cost boundary"

# the pinned shapes are untouched by D-O63 — the byte-compares above already
# proved it; this asserts the *claim*, so a future edit cannot quietly widen it
grep -qF -- 'Next manual act: <one line>' "$TMP/shape-doc.txt" \
  && ok "the resumption report's slot is unchanged — the rule fills it, never replaces it" \
  || bad "the resumption report lost its Next manual act line"
grep -qF -- 'Next act: <one line>' "$TMP/bshape-doc.txt" \
  && ok "…and the band-boundary report's slot is unchanged" \
  || bad "the band-boundary report lost its Next act line"

# the corpus home (D-O64), and the four rulings on the record
has_flow "$DOC" "This section **is** autonomous mode's definition, and the whole of it" \
    "§10.7 is ruled the mode's corpus home"
has_flow "$DOC" "legislates nothing of its own" \
    "…and every compiled surface legislates nothing of its own"
has_flow "$DOC" "the hold conditions, and the whole of them" \
    "…and the four stop events are named the hold conditions"
has "$DOC" "## 29. Review record (v0.25 → v0.26)" "§29 records the ruling set"
n=0; for d in 61 62 63 64; do
  grep -qF -- "**D-O$d**" "$DOC" && n=$((n+1)) || bad "D-O$d is not ruled in the document"
done
[ "$n" -eq 4 ] && ok "the D-O61–D-O64 block is contiguous and complete — 4 rulings"

# and the framework-only scope of the ruling is on the record
has_flow "$DOC" "a defective run is superseded by a fresh run of the fixed framework, never patched" \
    "§29 states the framework-only scope"

# ── EC-19 · the two untethered stops, and the trail after ratification ───────
#
# B10: D-O51 names four hold conditions and only two had a render. A live run
# hit the other two — the safety floor, then the grant's own scope edge — and
# improvised twice in one session. D-O86 gives both one pinned shape. B12: the
# resumption report demanded the full trail from a BA who had already ratified;
# D-O87 gives the trail line one conditional and leaves rule 8's precedence
# alone. What must stay true: the third shape is compiled, never rewritten; the
# closing ask reaches it; the trail's short form points at the ledger.

printf '\n▸ EC-19 — the mid-grant stop report and the trail conditional (D-O86 · D-O87)\n'

PHEAD='Auto paused — '
python3 "$SHAPE" doc "$DOC" "$PHEAD" > "$TMP/pshape-doc.txt" 2>"$TMP/pshape-doc.err"
if [ -s "$TMP/pshape-doc.txt" ]; then
  ok "§10.7 yields the mid-grant stop report — $(wc -l < "$TMP/pshape-doc.txt" | tr -d ' ') lines"
else
  bad "§10.7 has no mid-grant stop report block: D-O86's shape cannot be checked from source"
  sed 's/^/      /' "$TMP/pshape-doc.err"
fi

# vacuity: an emptied block that still extracts would assert nothing
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  grep -qF -- "$phrase" "$TMP/pshape-doc.txt" \
    && ok "the source block still carries $label" \
    || bad "D-O86's block no longer carries $label — re-read the document first"
done <<'LINES'
the safety-floor branch of line 1|safety floor: <act — code + name>
the scope-exhaustion branch of line 1|scope exhausted: <the AG's scope edge
what stands, and the mid-flight state|Stands: <what the run completed, one line> · mid-flight:
the trail and assumption counts|Auto-trail since <start | last boundary>: <n> acts · Assumptions:
the resumption act and the grant's standing|Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>
LINES

# four lines, and the count is guarded: a fifth arriving unruled goes red
[ "$(wc -l < "$TMP/pshape-doc.txt" | tr -d ' ')" = "4" ] \
  && ok "the mid-grant stop report is four lines — the closing ask is a tail, not a line" \
  || bad "the mid-grant stop report is not four lines: a line arrived unruled (D-O86)"

for pair in "$AUTO|the ba-auto skill" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  python3 "$SHAPE" unit "$f" "$PHEAD" > "$TMP/pshape-unit.txt" 2>"$TMP/pshape-unit.err"
  if [ ! -s "$TMP/pshape-unit.txt" ]; then
    bad "$label carries no mid-grant stop report block (D-O86)"
    sed 's/^/      /' "$TMP/pshape-unit.err"
  elif diff -u "$TMP/pshape-doc.txt" "$TMP/pshape-unit.txt" > "$TMP/pshape.diff" 2>&1; then
    ok "$label is byte-identical to §10.7 — the third shape is compiled, not rewritten"
  else
    bad "$label diverges from §10.7's mid-grant stop report:"
    sed 's/^/      /' "$TMP/pshape.diff" | head -14
  fi
done

# the control: a dropped line in a private copy must go red
PSHC="$TMP/pshape-corpus"
mkdir -p "$PSHC"
cp "$AUTO" "$PSHC/SKILL.md"
python3 - "$PSHC/SKILL.md" <<'PYDROP'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text(encoding="utf-8")
p.write_text(t.replace("Resume from: <the act the BA takes — one line> · AG-<n>: <stands | reaches no further>\n", ""), encoding="utf-8")
PYDROP
python3 "$SHAPE" unit "$PSHC/SKILL.md" "$PHEAD" > "$TMP/pshape-dirty.txt" 2>&1
diff -q "$TMP/pshape-doc.txt" "$TMP/pshape-dirty.txt" >/dev/null 2>&1 \
  && bad "a dropped Resume-from line slips through — the byte-match does not hold" \
  || ok "the control fires — a dropped stop-report line goes red"

# every hold condition has a render, on every surface that lists them
for pair in "$DOC|§10.7" "$AUTO|the skill" "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  has_flow "${pair%%|*}" "mid-grant stop report" \
      "${pair##*|} — the two untethered stops name their render (D-O86)"
done
has_flow "$DOC" "**§10.7's pinned-shape count moves two → three**" \
    "§10.7 states the shape count it moved"
has_flow "$DOC" "**It does not reach the mid-grant stop report (§10.7):**" \
    "…and rule 9's AUTO exemption is narrowed to the two renders it names"
has_flow "$AUTO" "**The AUTO exemption does not reach this render:**" \
    "…the skill carries the closing-ask reach"
has_flow "$DOC" "**D-O69's decision-list tail is not extended to this report.**" \
    "…and the advisory tail is not extended to the new shape"
has_flow "$AUTO" "the decision-list tail does not follow this report" \
    "…the skill says so too"
# the killed state: a halt that quietly closes a grant
has_flow "$DOC" "the grant **not closed** and no ratification asked" \
    "the mid-grant stop closes no grant and asks no ratification"
has_flow "$DOC" "**at scope exhaustion it reaches no further**" \
    "…and each event states what it does to the grant"

# D-O87 — the trail conditional, in the shape and in its rule
grep -qF -- 'Auto-trail: <n> acts — ratified in this reply · full trail: .specify/aspect-state.md Events' \
    "$TMP/shape-doc.txt" \
  && ok "the resumption report carries the collapsed trail line (D-O87)" \
  || bad "the resumption report has no collapsed trail line — D-O87 did not land in the shape"
grep -qF -- 'Auto-trail: <n> acts — one line each:' "$TMP/shape-doc.txt" \
  && ok "…and the full one-line-per-act trail is still the pinned default" \
  || bad "the full trail was replaced rather than conditioned (D-O87)"
has_flow "$DOC" "**A ratification that names exceptions renders the full trail.**" \
    "an exception renders the acts it might except"
has_flow "$DOC" "**§10.3 rule 8 stands untouched" \
    "…and rule 8's precedence is stated, not moved"
has_flow "$AUTO" "**The trail line has one conditional, and one only.**" \
    "the skill carries the conditional, and says it is the only one"
has_flow "$AUTO" "**The report is still six lines.**" \
    "…and the report's line count is unmoved"

# ── 9. the execution mechanism — the procedure is the skill (D-O103) ─────────
#
# EC-23, field defect report #5: under a full-workflow grant the run halted at
# every command boundary and handed the BA a command list — the D-O32 banned
# render, and the session's only observed behaviour. The cause was not a missing
# rule about *who may* start an act: D-O61's cost boundary had ruled that. It was
# that nothing said *how* one starts. The mechanism existed as one skill's
# compiled clause (`ba-run`) and as legislated law in none, so no session that
# had not read that one file had a reason to generalize it.
#
# v0.44 legislates it at §7.5 and cites it at §10.7. This section holds every
# **executor carrier** to it — the two mirrors, `ba-auto`, and the two named
# routes — plus the instance clause standing in `ba-run`, plus the flag census
# the ruling explicitly preserved. Two seeded controls prove the sweep fires.
#
# What is asserted here is the **carriers**, not a live run: the acceptance test
# the field note §5 states (one BA act carrying T-17 → T-18 → Tier 1 → P-O8 →
# Tier 2 → /ba-wbs) is a multi-step run against a real estate, which no offline
# check can execute. Items 1 and 4 stay the field acceptance, on the reporting
# estate, after release and owner update.

printf '\n▸ EC-23 — the execution mechanism: the procedure is the skill (D-O103 · §7.5 · §10.7)\n'

DEVREADY="$PKG_ROOT/payload/claude/skills/ba-dev-ready/SKILL.md"
CHANGE="$PKG_ROOT/payload/claude/skills/ba-change/SKILL.md"
RUN="$PKG_ROOT/payload/claude/skills/ba-run/SKILL.md"
for f in "$DEVREADY" "$CHANGE" "$RUN"; do
  [ -f "$f" ] || { printf '✗ missing source: %s\n' "$f" >&2; exit 2; }
done

# 9a — the ground. A carrier sweep whose law left the document asserts a
# compile against nothing; §7.5 and §10.7 are checked first, and by their own
# words.
has_flow "$DOC" "**The execution mechanism — the procedure is the skill (D-O103).**" \
    "§7.5 legislates the mechanism"
has_flow "$DOC" "the conducting session **reads the skill file and executes it as the procedure**" \
    "…and says what the session does"
has_flow "$DOC" "an **already-stated BA act covers the run**" \
    "…and names the one condition that licenses it"
has_flow "$DOC" "**Absent a covering act, the session stops in ≤ 2 lines and names the one BA act that unblocks**" \
    "…and the refusal absent one"
has_flow "$DOC" "\`/ba-run\`'s compiled row-execution clause is this law's named instance." \
    "…and names /ba-run as the instance"
has_flow "$DOC" "**How a self-elected act starts (D-O103).**" \
    "§10.7 cites the mechanism at the self-election"
has_flow "$DOC" "the flag hides the button, never the file" \
    "…and keeps the flag standing while it does"

# 9b — the mechanism clause, in every executor carrier that legislates it whole.
# The two mirrors carry the same paragraph; the needles are the three things it
# has to say — how, when, and what happens absent a covering act.
for pair in "$BLOCK|the CLAUDE.md block" "$AGENTS|AGENTS.md"; do
  f="${pair%%|*}"; label="${pair##*|}"
  has_flow "$f" "**The execution mechanism — the procedure is the skill (D-O103).**" \
      "$label carries the mechanism"
  has_flow "$f" "read the covered skill's file at \`.claude/skills/ba-<id>/SKILL.md\` and **execute it as the procedure**" \
      "…$label — how an act starts"
  has_flow "$f" "When, and only when, an **already-stated BA act covers the run**" \
      "…$label — when, and only when"
  has_flow "$f" "**Absent a covering act, stop in ≤ 2 lines and name the one BA act that unblocks**" \
      "…$label — the ≤ 2-line refusal"
  has_flow "$f" "\`disable-model-invocation: true\` keeps it off the model's own surface" \
      "…$label — the flag stays, and says what it is for"
done

# the mirrors are one paragraph compiled twice, not two paragraphs that agree
python3 - "$BLOCK" "$AGENTS" <<'PYM' && ok "the two mirrors carry the same paragraph, byte for byte" \
  || bad "the mirrors' mechanism paragraphs diverge — one text, two carriers"
import sys
H = "**The execution mechanism — the procedure is the skill (D-O103).**"
out = []
for p in sys.argv[1:3]:
    t = open(p, encoding="utf-8").read()
    if H not in t:
        sys.exit(1)
    i = t.index(H)
    out.append(t[i:t.index("\n\n", i)])
sys.exit(0 if out[0] == out[1] else 1)
PYM

# ba-auto carries §10.7's start paragraph, not the mirrors' — the grant is the
# covering act, and the stamp and the trail are already law
has_flow "$AUTO" "**How a self-elected act starts (D-O103).** The grant **is** the covering act." \
    "the ba-auto skill carries the start paragraph"
has_flow "$AUTO" "read the elected skill's file at \`.claude/skills/ba-<id>/SKILL.md\` and execute it as the procedure" \
    "…and says how a self-election starts"
has_flow "$AUTO" "Ask for no keystroke and wait for none; the flag hides the button, never the file." \
    "…and asks for no keystroke"
has_flow "$AUTO" "Outside a covering act, stop in ≤ 2 lines and name the one BA act that unblocks." \
    "…and the ≤ 2-line refusal outside one"

# the two named routes cite the law and restate none of it — one sentence, one
# needle, both carriers
MECH_CITE="Each row runs by reading its skill file at \`.claude/skills/ba-<id>/SKILL.md\` and executing it as the procedure — the execution mechanism (§7.5, D-O103), whose named instance is \`/ba-run\`'s row-execution clause."
has_flow "$DEVREADY" "$MECH_CITE" "/ba-dev-ready's \`go\` executes on the mechanism"
has_flow "$CHANGE"   "$MECH_CITE" "/ba-change's \`take\` executes on the mechanism"

# 9c — the instance. Its two sentences are the law's named instance and are held
# byte for byte: the ruling tagged them, it did not reword them.
has_joined "$RUN" "Take the BA's \`go\`, then run each row in order by reading its technique's skill file (\`.claude/skills/ba-<id>/SKILL.md\`) and executing it as the procedure" \
    "ba-run's route-runner sentence stands byte-kept"
has_joined "$RUN" "Read the technique's skill file at \`.claude/skills/ba-<id>/SKILL.md\` and execute it as the procedure, exactly as if the BA had typed \`/ba-<id>\`." \
    "…and its alias sentence stands byte-kept"
has_flow "$RUN" "**The execution mechanism's named instance (D-O103).**" \
    "…and both are tagged as the named instance"

# 9d — the flag census. D-P2-2 is upheld by this ruling, not moved: every ba-*
# skill keeps `disable-model-invocation: true`, and the report's F1 — dropping
# it — is parked with an event trigger. A future flag drop fails here, loudly,
# until its own ruling lands.
SKDIR="$PKG_ROOT/payload/claude/skills"
FLAG_N=0; FLAG_OK=0; FLAG_BAD=""
for d in "$SKDIR"/ba-*/; do
  [ -f "$d/SKILL.md" ] || continue
  FLAG_N=$((FLAG_N+1))
  if head -12 "$d/SKILL.md" | grep -qx 'disable-model-invocation: true'; then
    FLAG_OK=$((FLAG_OK+1))
  else
    FLAG_BAD="$FLAG_BAD $(basename "$d")"
  fi
done
[ "$FLAG_N" -eq 39 ] \
  && ok "the ba-* skill set is 39 — the census has something to count" \
  || bad "the ba-* skill set is $FLAG_N, not 39: the census expectation moved without a ruling"
if [ "$FLAG_OK" -eq "$FLAG_N" ] && [ "$FLAG_N" -gt 0 ]; then
  ok "all $FLAG_OK of $FLAG_N ba-* skills carry disable-model-invocation: true (D-P2-2 upheld; F1 parked)"
else
  bad "flags missing on:$FLAG_BAD — D-P2-2 stands until F1's own ruling lands (D-O103)"
fi
# the guest is exempt by D-O97's vendoring pin, and its exemption is the reason
# the census reads 39 and not 40
grep -q 'disable-model-invocation' "$SKDIR/humanizer/SKILL.md" \
  && bad "the vendored humanizer carries a framework flag — D-O97 pins it byte-untouched" \
  || ok "the vendored humanizer guest carries none — D-O97's pin, and why the census is 39 of 39"

# 9e — the seeded controls. A sweep that cannot fail is not a sweep.
MC="$TMP/mech-corpus"
mkdir -p "$MC"
cp "$AGENTS" "$MC/AGENTS.md"
python3 - "$MC/AGENTS.md" <<'PYK'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); t = p.read_text(encoding="utf-8")
H = "**The execution mechanism — the procedure is the skill (D-O103).**"
i = t.index(H); j = t.index("\n\n", i)
p.write_text(t[:i] + t[j+2:], encoding="utf-8")
PYK
python3 - "$MC/AGENTS.md" <<'PYC' && bad "a carrier stripped of the mechanism still passes — the sweep asserts nothing" \
  || ok "the control fires — a carrier without the mechanism clause goes red"
import re, sys
flat = re.sub(r"\s+", " ", re.sub(r"(?m)^\s*>\s?", "", open(sys.argv[1], encoding="utf-8").read()))
sys.exit(0 if "The execution mechanism — the procedure is the skill" in flat else 1)
PYC

cp "$AUTO" "$MC/SKILL.md"
python3 - "$MC/SKILL.md" <<'PYF'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
p.write_text(p.read_text(encoding="utf-8").replace("disable-model-invocation: true\n", "", 1), encoding="utf-8")
PYF
head -12 "$MC/SKILL.md" | grep -qx 'disable-model-invocation: true' \
  && bad "a skill stripped of its flag still counts as flagged — the census asserts nothing" \
  || ok "the control fires — a dropped disable-model-invocation goes red"

# 9f — the acceptance shape, as far as an offline check reaches. Every start
# path the field note's test walks has a compiled mechanism at its carrier; the
# floor keeps its three acts, so the refusal under both settings is the floor
# sweep above, unchanged by this ruling.
MECH_CARRIERS=0
for f in "$BLOCK" "$AGENTS" "$AUTO" "$DEVREADY" "$CHANGE"; do
  grep -qF -- 'D-O103' "$f" && MECH_CARRIERS=$((MECH_CARRIERS+1))
done
[ "$MECH_CARRIERS" -eq 5 ] \
  && ok "all 5 executor carriers name D-O103 — no start path inherits the silence" \
  || bad "$MECH_CARRIERS of 5 executor carriers name D-O103: a start path still inherits the silence"
has_flow "$DOC" "The floor keeps its three acts (D-O94)." \
    "the floor still keeps three acts — the mechanism reaches none of them"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — autonomous mode: the AG record and the Auto head line · the §10.7 policy table on four surfaces · the four-act safety floor swept across %s files with 4 seeded breaches · the resumption report byte-identical in 3 units · the mode read in %s carriers · the two locked amendments · the cost boundary on five carriers, the arming run inside the grant on seven, the choice line on six · the execution mechanism on %s executor carriers with the flag census at %s of %s and 2 seeded controls\n' \
    "${F_FILES:-?}" "${MR_UNITS:-?}" "${MECH_CARRIERS:-?}" "${FLAG_OK:-?}" "${FLAG_N:-?}"
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
