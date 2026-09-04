#!/usr/bin/env bash
# BA-Native Spec — the profile says what it forecloses, and a refusal names what
# exists and the act (orchestrator rules §6.5 · §8.1 · §10.3 rule 12, D-O107–
# D-O108 · gate §4.1 · §10.4, D-G10 · catalogue-b1 D-B1-9; EC-25).
#
# The 3 Sep 2026 field defect: under Presale three static-core members were
# absent as the profile's own expected debt, the snapshot refused every feature
# at admission, nothing had said so at the point of choice, the refusal named
# only what was missing — and *no feature can be gated* reached the BA Lead as
# *the specs were not generated*. The regression floor (field note §5 items
# 2–4 + §49 "Open"):
#
#   0.  the documents — the law in their own words, so no sweep below is vacuous
#   1.  the picker — ba-frame's block byte-equal to §8.1's at run time, its
#       three new lines present, the collapsed pre-D-O107 shape absent
#   2.  the gate — step 3's three-part refusal in order with code-plus-name,
#       step 5's HA boundary, the run-number sentence, the snapshot refusal
#       byte-identical (field note §5 item 1 stays true)
#   3.  ba-gate-health — which Stage-0 step an HA lifts, "not a missing
#       artifact"
#   4.  register rule 12 — the framework block, AGENTS.md and every persona by
#       glob, one anchor each, byte-identical across carriers
#   5.  the trued sentences — ba-change's locate row without `Budget:`,
#       ba-frame's budget-is-a-recorded-constraint sentence
#   6.  the b1 mirror — the budget envelope out of all four D-7 sites, a
#       stated budget a business one-liner
#   7.  the banned-render sweep — "cannot be gated" nowhere without "exists"
#       in the same paragraph, whitespace-collapsed, non-vacuous by count
#
# The trailer's locked range and both edition headers are check-humanizer.sh's
# and check-gate.sh/check-auto.sh's pins — cited here, never duplicated (the
# check-lean boundary precedent).
#
#   check-refusal.sh           run the suite
#   check-refusal.sh -v        print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-orchestrator-rules.md"
GATE_DOC="$PKG_ROOT/docs/methodology/ba-native-spec-gate-definition.md"
B1="$PKG_ROOT/docs/methodology/ba-native-spec-catalogue-b1.md"
SKILLS="$PKG_ROOT/payload/claude/skills"
AGENTS_DIR="$PKG_ROOT/payload/claude/agents"
FRAME="$SKILLS/ba-frame/SKILL.md"
BGATE="$SKILLS/ba-gate/SKILL.md"
HEALTH="$SKILLS/ba-gate-health/SKILL.md"
CHANGE="$SKILLS/ba-change/SKILL.md"
T01="$SKILLS/ba-t01/SKILL.md"
T01EX="$SKILLS/ba-t01/references/example.md"
CANVAS_TPL="$PKG_ROOT/payload/specify-overlay/ba/templates/canvas-template.md"
SNAPSHOT="$PKG_ROOT/payload/specify-overlay/ba/scripts/sk_snapshot.py"
BLOCK="$PKG_ROOT/payload/mirror/claude-block.md"
AGENTS_MD="$PKG_ROOT/payload/mirror/AGENTS.md"

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
  grep -qF -- "$2" "$1" && ok "$3" || bad "$3 — not found: $2"
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

# ── 0. the documents — the law in their own words ────────────────────────────

printf '\n▸ The documents — D-O107 · D-O108 · D-G10 · D-B1-9, in their own words\n'

fhas "$DOC" "The reason is mechanical and is stated here once (D-O107, §49):" \
    "§6.5 states the foreclosure mechanism once"
fhas "$DOC" "are **static-core members of every feature's \`deps(F)\`** (gate §3), so under Presale the gate **refuses admission at Stage 0 for every feature until they exist**" \
    "…three out-of-profile artifacts are static-core members, refusing admission"
fhas "$DOC" "a runtime condition no instrument lifts (gate §4.1 · §10.4, D-G10): not a waiver, not an \`HA-<nn>\`, not the switch alone" \
    "…a runtime condition no instrument lifts"
fhas "$DOC" "**The consequence is said twice and nowhere else:**" \
    "…said at the choice and at the bite, nowhere else"
fhas "$DOC" "once the static core is complete, on a draft spec its FAIL report is an informative named-gap list — the client Q&A agenda; before that it refuses at admission and the refusal names what exists, what is missing and the act (D-O107 · D-O108)" \
    "…and §6.5's FAIL-report sentence carries the before-that refusal"
has "$DOC" "12. **A refusal names what exists and the act (D-O108).**" \
    "§10.3 carries the twelfth rule"
fhas "$DOC" "*Cannot be gated* alone is a banned render" \
    "…and bans the bare render"

fhas "$GATE_DOC" "**Admission (D-G10):** \`spec.md\` present at its path **and the static core complete (§3)**" \
    "gate §4.1 opens Stage 0 with admission"
fhas "$GATE_DOC" "the run refuses before the snapshot binds, no report entry is written and no run number is consumed, **no instrument lifts it**" \
    "…refused before the snapshot binds — no entry, no number, no instrument"
fhas "$GATE_DOC" "the refusal renders **three parts in this order: what exists** (the spec, drafted, its marker count) **· what is missing** with its producing technique by code and name **· the one act that unblocks**" \
    "…and pins the three-part order"
fhas "$GATE_DOC" "**Admission only — and admission means pre-flight (D-G10).**" \
    "gate §10.4's bullet tells the two refusals apart"
fhas "$GATE_DOC" "**It never lifts the admission refusal of a missing static-core member**" \
    "…an HA never lifts the admission refusal"
fhas "$GATE_DOC" "step 3 of the compiled run against step 5" \
    "…and names the compiled run's own steps"

fhas "$B1" "the budget envelope left the frame, orchestrator D-O105" \
    "catalogue-b1 step 2 drops the budget envelope from the mirror (D-B1-9)"
fhas "$B1" "no budget line since orchestrator D-O105; a stated budget is a business one-liner" \
    "…and the §13 template row says a stated budget is a business one-liner"
has "$B1" "D-B1-9" "…on the record as D-B1-9"

# the trailer's locked range (D-O108) and both edition headers are pinned in
# check-humanizer.sh, check-gate.sh and check-auto.sh — cited, not duplicated.

# ── 1. the picker — byte-equal to §8.1, the three new lines present ──────────

printf '\n▸ The picker — ba-frame'"'"'s block byte-equal to §8.1'"'"'s nine lines\n'

python3 - "$DOC" "$FRAME" "$TMP" <<'PY'
import pathlib, re, sys
doc, frame, tmp = sys.argv[1], sys.argv[2], sys.argv[3]
pat = re.compile(
    r"```\n(Flow profile — pick one before any aspect opens \(P-O0 — flow-profile selection\):\n"
    r".*?Waiting for your pick\. Switchable later; the switch is logged\.)\n```",
    re.S)
m = pat.search(pathlib.Path(doc).read_text(encoding="utf-8"))
if not m:
    sys.exit(1)
block = m.group(1)
pathlib.Path(tmp, "picker.txt").write_text(block, encoding="utf-8")
sys.exit(0 if block in pathlib.Path(frame).read_text(encoding="utf-8") else 2)
PY
case $? in
  0) ok "ba-frame's picker is byte-equal to §8.1's, extracted from the document" ;;
  1) bad "the pinned picker block was not found in §8.1 — the extraction key moved" ;;
  *) bad "ba-frame's picker diverges from §8.1's — not byte-equal" ;;
esac

if [ -f "$TMP/picker.txt" ]; then
  n="$(wc -l < "$TMP/picker.txt")"
  # wc -l counts newlines; the block's last line has none, so 9 lines read as 8
  [ "$((n+1))" -eq 9 ] \
    && ok "the block stands at nine lines — line 2 grew by three (D-O107)" \
    || bad "the block does not stand at nine lines — counted $((n+1))"
  fhas "$TMP/picker.txt" "No feature reaches a gate run under this profile until T-11, T-12 and T-15" \
      "…naming the consequence at the point of choice"
  fhas "$TMP/picker.txt" "have run — their artifacts are part of every gate snapshot. To certify:" \
      "…grounded in the gate snapshot"
  fhas "$TMP/picker.txt" "elect those three, or switch to Discovery and run them." \
      "…and the two acts that lift it"
fi

# the pre-D-O107 collapse — option 2 ending at the waiver sentence — must be
# dead wherever the picker renders; whitespace-collapsed so any wrapping fires
flacks "$FRAME" "draft specs optional. Waivers expected. Waiting for your pick." \
    "option 2 never ends at the waiver sentence in ba-frame"
flacks "$DOC" "draft specs optional. Waivers expected. Waiting for your pick." \
    "…nor in §8.1 itself"

# the picker renders in exactly one payload carrier; a second carrier must
# extend this check consciously, never ride in unswept
pc="$(grep -rlF 'Flow profile — pick one before any aspect opens' "$PKG_ROOT/payload" --include='*.md' | wc -l | tr -d ' ')"
[ "$pc" -eq 1 ] \
  && ok "the picker block renders in exactly one payload carrier — ba-frame" \
  || bad "the picker block renders in $pc payload carriers — the census moved"

fhas "$FRAME" "once the static core is complete, on a draft spec its FAIL report is an informative named-gap list — the client Q&A agenda; before that it refuses at admission and the refusal names what exists, what is missing and the act (D-O107 · D-O108)" \
    "ba-frame carries §6.5's amended FAIL-report sentence"
fhas "$SKILLS/ba-enter-feature/SKILL.md" "once the static core is complete, on a draft spec its FAIL report is an informative named-gap list — the client Q&A agenda; before that it refuses at admission and the refusal names what exists, what is missing and the act (D-O107 · D-O108)" \
    "…and so does ba-enter-feature, the census's extra carrier"

# ── 2. the gate — the two Stage-0 refusals told apart at the executor ────────

printf '\n▸ The gate — step 3'"'"'s three-part refusal, step 5'"'"'s HA boundary\n'

fhas "$BGATE" "**the run refuses at admission, before the snapshot binds** — no report entry is written, no run number is consumed" \
    "step 3 refuses before the snapshot binds — no entry, no number"
fhas "$BGATE" "not a waiver, not an \`HA-<nn>\` (an HA lifts step 5's pre-flight gaps, never this refusal), not a profile switch alone" \
    "…and no instrument lifts it"
fhas "$BGATE" "**The refusal renders three parts, in this order:**" \
    "…the three-part order is pinned"

python3 - "$BGATE" <<'PY'
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
a = t.find("**what exists**")
b = t.find("**what is missing**")
c = t.find("**the one act that unblocks**")
sys.exit(0 if 0 <= a < b < c else 1)
PY
[ $? -eq 0 ] \
  && ok "the three parts stand in order — exists · missing · act" \
  || bad "the three parts are absent or out of order in ba-gate"

fhas "$BGATE" "\`domain-model.md\` (T-11 — Domain (conceptual) modeling)" \
    "…what is missing carries T-11 by code and name"
fhas "$BGATE" "\`roles-permissions.md\` (T-12 — Roles & permissions)" \
    "…and T-12 by code and name"
fhas "$BGATE" "\`constitution.md\` (T-15 — Constitution)" \
    "…and T-15 by code and name"
fhas "$BGATE" "elect the producing technique(s) at a P-O2 — plan composition, or switch to Discovery and run them" \
    "…and the one act that unblocks names the election and the switch"
fhas "$BGATE" "An \`HA-<nn>\` lifts exactly these pre-flight gaps — **this step, never step 3's admission refusal**: a missing static-core member is not an H gap" \
    "step 5 — an HA lifts these gaps and never step 3's refusal"
fhas "$BGATE" "include pre-flight blocks" \
    "the run-number sentence counts pre-flight blocks…"
fhas "$BGATE" "while an admission refusal writes no entry and consumes none (step 3)" \
    "…and an admission refusal consumes none"
ba="$(grep -rlF 'include blocked admissions' "$PKG_ROOT/payload" | wc -l | tr -d ' ')"
[ "$ba" -eq 0 ] \
  && ok "the pre-D-G10 run-number sentence is dead across the payload" \
  || bad "the pre-D-G10 run-number sentence survives in $ba payload file(s)"
fhas "$PKG_ROOT/payload/specify-overlay/ba/templates/gate-report-entry.md" \
    "an admission refusal writes no entry and consumes no number" \
    "the gate-report template counts pre-flight blocks and not admission refusals"

# field note §5 item 1 stays true: the snapshot's own refusal is byte-identical
python3 - "$SNAPSHOT" <<'PY'
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
block = (
    "    if missing and args.require_complete:\n"
    "        for labels, rel in missing:\n"
    "            print(\"snapshot: missing %s — %s\" % (\"/\".join(labels), rel),\n"
    "                  file=sys.stderr)\n"
    "        return 1\n"
)
sys.exit(0 if block in t else 1)
PY
[ $? -eq 0 ] \
  && ok "sk_snapshot.py's --require-complete refusal is byte-identical — the diagnosis stays true" \
  || bad "sk_snapshot.py's refusal lines moved — field note §5 item 1 no longer replays"

# ── 3. ba-gate-health — which step an HA lifts ───────────────────────────────

printf '\n▸ ba-gate-health — the step an HA lifts, and what it never lifts\n'

fhas "$HEALTH" "**Admission only — and admission means pre-flight.**" \
    "the bullet tells the two refusals apart"
fhas "$HEALTH" "H gaps over \`deps(F)\`, \`/ba-gate\`'s Stage 0 **step 5**" \
    "…naming the step an HA lifts"
fhas "$HEALTH" "**It never lifts the admission refusal of a missing static-core member** (step 3, the step before pre-flight)" \
    "…and the step it never lifts"
fhas "$HEALTH" "what an HA lifts is an H gap, **not a missing artifact**" \
    "…an H gap, not a missing artifact"
flacks "$HEALTH" "**Admission only.** An HA lifts a Stage-0 block and nothing else." \
    "the pre-D-G10 bullet is dead"
fhas "$PKG_ROOT/payload/specify-overlay/ba/templates/gate-health.md" \
    "an HA lifts Stage-0 pre-flight blocks and NOTHING else — never the admission refusal of a missing static-core member" \
    "the gate-health template's HA mechanics say pre-flight too"
hb="$(grep -rlF 'lifts Stage-0 admission blocks' "$PKG_ROOT/payload" | wc -l | tr -d ' ')"
[ "$hb" -eq 0 ] \
  && ok "the undivided admission-blocks phrase is dead across the payload" \
  || bad "the undivided admission-blocks phrase survives in $hb payload file(s)"

# ── 4. register rule 12 — six carriers, one text ─────────────────────────────

printf '\n▸ Register rule 12 — the framework block, AGENTS.md and every persona\n'

ANCHOR='12. **A refusal names what exists and the act (D-O108).**'

# the persona list is derived by glob, so the sweep cannot go vacuous
PERSONAS=("$AGENTS_DIR"/*.md)
[ "${#PERSONAS[@]}" -ge 4 ] \
  && ok "the persona glob resolves ${#PERSONAS[@]} agents — the sweep has ground" \
  || bad "the persona glob resolves ${#PERSONAS[@]} agents — fewer than the four the build plan pins"

miss=0; dup=0; shas=""
for f in "$BLOCK" "$AGENTS_MD" "${PERSONAS[@]}"; do
  c="$(grep -cF "$ANCHOR" "$f")"
  if [ "$c" -eq 0 ]; then miss=$((miss+1)); printf '      no rule 12: %s\n' "${f#"$PKG_ROOT"/}"; continue; fi
  [ "$c" -gt 1 ] && dup=$((dup+1))
  s="$(awk '/^12\. \*\*A refusal names what exists and the act \(D-O108\)\.\*\*/{f=1} f{print} f&&/time it crossed one desk \(EC-25\)\./{exit}' "$f" | shasum | cut -d" " -f1)"
  shas="$shas$s\n"
done
[ "$miss" -eq 0 ] && [ "$dup" -eq 0 ] \
  && ok "rule 12's anchor stands exactly once in each of $((2+${#PERSONAS[@]})) carriers" \
  || bad "rule 12 is missing from $miss and duplicated in $dup carriers"
[ "$(printf "%b" "$shas" | sort -u | grep -c .)" -eq 1 ] \
  && ok "rule 12 is byte-identical across the carriers — one sha" \
  || bad "rule 12's text has drifted between carriers — $(printf "%b" "$shas" | sort -u | grep -c .) distinct shas"

# ── 5. the trued sentences at their carriers ─────────────────────────────────

printf '\n▸ The trued sentences — ba-change'"'"'s locate row, ba-frame'"'"'s budget clause\n'

fhas "$CHANGE" "| The scope frame | the head's \`Boundary:\` · \`Scope decisions:\` · \`Acceptance shapes:\` lines (§2.4) — \`standing\`, or \`none found\` |" \
    "ba-change's locate row reads the three head lines, \`none found\`"
b="$(grep -cF 'Budget:' "$CHANGE")"
[ "$b" -eq 0 ] \
  && ok "\`Budget:\` is dead in ba-change — the retired head line is unnamed" \
  || bad "\`Budget:\` still stands in ba-change at $b site(s)"

fhas "$FRAME" "a budget is a recorded constraint, never a frame line since D-O105; timeline is neither" \
    "ba-frame carries the trued D-O65 sentence — a budget is a recorded constraint"
flacks "$FRAME" "the budget has its own line" \
    "…and the pre-D-O105 clause is dead"

# ── 6. the b1 mirror — the envelope out of all four sites ────────────────────

printf '\n▸ The b1 mirror — no budget envelope at any of the four D-7 sites\n'

for f in "$T01" "$T01EX" "$CANVAS_TPL"; do
  [ -f "$f" ] || { bad "mirror site missing from the payload: ${f#"$PKG_ROOT"/}"; continue; }
  c="$(grep -icF 'budget envelope' "$f")"
  [ "$c" -eq 0 ] \
    && ok "no budget envelope in ${f#"$PKG_ROOT"/}" \
    || bad "budget envelope still stands in ${f#"$PKG_ROOT"/} at $c site(s)"
done
b="$(grep -cF 'Budget:' "$T01")"
[ "$b" -eq 0 ] \
  && ok "ba-t01's inputs no longer name the retired \`Budget:\` head line" \
  || bad "\`Budget:\` still stands in ba-t01 at $b site(s)"
fhas "$T01" "no budget line lands from the frame — the frame carries none since orchestrator D-O105; a stated budget is a business-constraint one-liner this section holds from the material" \
    "ba-t01's mirror says where a stated budget lives instead"
fhas "$T01EX" "each cited (no budget line since orchestrator D-O105; a stated budget is a business one-liner)" \
    "…the example's §13 row says the same"
fhas "$CANVAS_TPL" "no budget line since orchestrator D-O105 — a stated budget is a business one-liner" \
    "…and so does the canvas template's §13 row"
env_all="$(grep -rF 'budget envelope' "$PKG_ROOT/payload" "$HERE" --include='*.md' --include='*.sh' --include='*.py' -l 2>/dev/null | grep -v "check-refusal.sh" | wc -l | tr -d ' ')"
[ "$env_all" -eq 0 ] \
  && ok "budget envelope stands nowhere else in payload or tests" \
  || bad "budget envelope survives in $env_all other file(s)"

# ── 7. the banned-render sweep — rule 12 over the whole payload ──────────────

printf '\n▸ The sweep — "cannot be gated" never stands without "exists" beside it\n'

python3 - "$PKG_ROOT/payload" <<'PY' > "$TMP/sweep.out" 2>&1
import pathlib, re, sys
root = pathlib.Path(sys.argv[1])
seen, bare = 0, []
for p in sorted(root.rglob("*.md")):
    text = p.read_text(encoding="utf-8", errors="replace")
    for para in re.split(r"\n\s*\n", text):
        flat = re.sub(r"\s+", " ", para)
        if "cannot be gated" in flat:
            seen += 1
            if "exists" not in flat:
                bare.append(str(p.relative_to(root)))
print(f"seen={seen}")
for b in bare:
    print(f"bare={b}")
sys.exit(0 if seen >= 6 and not bare else 1)
PY
if [ $? -eq 0 ]; then
  ok "every payload paragraph saying \"cannot be gated\" also says what exists ($(grep -c 'seen=' "$TMP/sweep.out" >/dev/null; sed -n 's/^seen=//p' "$TMP/sweep.out") sighted — the sweep is not vacuous)"
else
  if grep -q '^bare=' "$TMP/sweep.out"; then
    bad "a payload paragraph says \"cannot be gated\" without naming what exists:"
    sed -n 's/^bare=/      /p' "$TMP/sweep.out"
  else
    bad "the sweep went vacuous — fewer than six \"cannot be gated\" paragraphs sighted ($(sed -n 's/^seen=//p' "$TMP/sweep.out"))"
  fi
fi

# ── summary ──────────────────────────────────────────────────────────────────

printf '\n  passed: %d   failed: %d\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the profile says what it forecloses: the documents · the picker · the gate'"'"'s two refusals · rule 12 in six carriers · the trued sentences · the b1 mirror · the sweep\n'
  exit 0
else
  printf '✗ RED — %d check(s) failed\n' "$FAILED"
  exit 1
fi
