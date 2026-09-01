#!/usr/bin/env bash
#
# BA-Native Spec — the gate suite (build plan §4, S3 exit test).
#
# Replays gate definition §14's runs 2 → 3 end to end against the
# appointment-booking fixture world:
#
#   run 2  full Scope-F run on spec r5   → FAIL with 5 named gaps
#   fixes  applied from fixture r6 (gate §14.1's five dispositions)
#   run 3  incremental re-gate (carry set per §9.2, waiver/override lifecycle)
#          → PASS WITH WAIVERS → ⚑ ×2 → P4 approval → certification manifest,
#          whose hashes then verify against the live tree.
#
# The M pass runs **live** — the ten S2 checkers against a real snapshot
# workspace. The A pass is a **recorded** sheet (tests/fixtures/…/a-pass/),
# because Stage 3 is an agent act and cannot be re-derived in a regression
# suite; see that directory's README. Everything downstream of the A pass —
# disposition, verdict assembly (§6.1), the report entry (§6.2), the W/O/HA
# instruments, certification (§11.1) — runs for real.
#
# Also exercised: the P1 admission block and its health-acceptance lift, the
# hard refusal of a waiver against a non-waivable assertion (§7.1 step 3), the
# gate's refusal to self-certify without P3/P4, the three compiled cards
# (tests/check-cards.py), and **R4** — §5.1's SKIPPED-on-unsupported-parse rule
# reaching the A pass by reference, with the no-second-copy half read
# mechanically off §5.1's own text (section 7).
#
#   check-gate.sh              run the suite
#   check-gate.sh --record     rewrite the expected report entries from this run
#   check-gate.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
SK="$PKG_ROOT/payload/specify-overlay/ba/scripts"
EXP="$FX/expected"

RECORD=0
VERBOSE=0
for a in "$@"; do
  case "$a" in
    --record) RECORD=1 ;;
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

# has <file> <fixed-string> <label>
has() { grep -Fq "$2" "$1" && ok "$3" || bad "$3 — not found: $2"; }
hasx() { grep -Fqx "$2" "$1" && ok "$3" || bad "$3 — not found (whole line): $2"; }
hasnt() { grep -Fq "$2" "$1" && bad "$3 — present but must not be: $2" || ok "$3"; }

# fhas <file> <string> <label> — whitespace-flattened, so a sentence that wraps
# in the source is one string to the assertion (the check-techniques house form)
fhas() {
  python3 - "$1" "$2" <<'PY' && ok "$3" || bad "$3 — not found (flat): $2"
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}

# ── the two worlds: r5 (run 2) and r6 (run 3) ────────────────────────────────

R5="$TMP/w/r5"; R6="$TMP/w/r6"
mkdir -p "$TMP/w"
cp -R "$FX/project" "$R5"; cp -R "$FX/project" "$R6"
cp "$FX/revisions/spec-r5.md" "$R5/specs/004-appointment-booking/spec.md"
cp "$FX/revisions/roles-permissions-r5.md" "$R5/.specify/memory/roles-permissions.md"
S5="$R5/specs/004-appointment-booking/spec.md"
S6="$R6/specs/004-appointment-booking/spec.md"

# m_pass <root> <workspace-root> <out-dir> — the 21 Scope-F M assertions, live.
# Every checker reads the snapshot workspace, never the live files (gate §3).
m_pass() {
  local ws="$1" out="$2"
  mkdir -p "$out"
  python3 "$SK/sk_structure.py"  --format json --root "$ws" --feature 004-appointment-booking > "$out/structure.json"
  python3 "$SK/sk_scan.py"       --format json --root "$ws" --feature 004-appointment-booking \
                                 --personas "$FX/negatives/personas.md"    > "$out/scan.json"
  python3 "$SK/sk_stories.py"    --format json --root "$ws" --feature 004-appointment-booking > "$out/stories.json"
  python3 "$SK/sk_acceptance.py" --format json --root "$ws" --feature 004-appointment-booking > "$out/acceptance.json"
  python3 "$SK/sk_ears.py"       --format json --root "$ws" --feature 004-appointment-booking > "$out/ears.json"
  python3 "$SK/sk_sections.py"   --format json --root "$ws" --feature 004-appointment-booking > "$out/sections.json"
  python3 "$SK/sk_idgraph.py"    --format json --root "$ws" --feature 004-appointment-booking \
                                 --run "$3" --rev "$4" --date "$5" \
                                 --out "$ws/specs/004-appointment-booking/traceability.md" > "$out/idgraph.json"
  python3 "$SK/sk_brief.py"      --format json --root "$ws" --feature 004-appointment-booking \
                                 --epic E-03                               > "$out/brief.json"
}

# assemble <rulings.json> <checkers-dir> <a-pass.json> <manifest.json> <carried.json|-> <out>
assemble() {
  python3 - "$@" <<'PY'
import json, sys, pathlib
rulings, ckdir, apass, manifest, carried, out = sys.argv[1:7]
run = json.loads(pathlib.Path(rulings).read_text(encoding="utf-8"))
run["checkers"] = sorted(str(p) for p in pathlib.Path(ckdir).glob("*.json"))
run["a_pass"] = apass
run["manifest"] = manifest
if carried != "-":
    rs = json.loads(pathlib.Path(carried).read_text(encoding="utf-8"))
    run["carried"] = [{"assertion": a, "basis": rs["basis"][a]} for a in rs["carried"]]
run.setdefault("carried", [])
pathlib.Path(out).write_text(json.dumps(run, indent=2, ensure_ascii=False) + "\n",
                             encoding="utf-8")
PY
}

# compare <produced> <expected-name> <label>
compare() {
  local produced="$1" name="$2" label="$3"
  if [ "$RECORD" -eq 1 ]; then
    cp "$produced" "$EXP/$name"
    printf '  · recorded %s\n' "$name"
    return 0
  fi
  if [ ! -f "$EXP/$name" ]; then bad "$label: no expected entry at $EXP/$name"; return 1; fi
  if diff -u "$EXP/$name" "$produced" > "$TMP/diff.txt"; then
    ok "$label — byte-identical to the recorded entry"
  else
    bad "$label — the report entry diverges from the recorded one:"
    sed 's/^/      /' "$TMP/diff.txt" | head -40
  fi
}

# ── 1. the three compiled cards ──────────────────────────────────────────────

printf '\n▸ Compiled cards (build plan §2.5)\n'
if python3 "$HERE/check-cards.py" > "$TMP/cards.txt" 2>&1; then
  ok "assertions-f (34) · assertions-h (3) · at-thresholds (18) verbatim from the pinned docs"
  grep -E '^  [a-z]' "$TMP/cards.txt" | sed 's/^/    /'
else
  bad "check-cards.py failed:"; sed 's/^/      /' "$TMP/cards.txt"
fi

# ── 2. gate run 2 — FAIL with five named gaps ────────────────────────────────

printf '\n▸ Gate run 2 — full Scope-F run on r5 (gate §14, contract §7)\n'

python3 "$SK/sk_snapshot.py" build --root "$R5" --feature 004-appointment-booking \
  --epic E-03 --run 2 --date 2026-07-17 --out "$TMP/m5.json" \
  --workspace "$TMP/ws5" --require-complete > /dev/null \
  && ok "Stage 0 — snapshot assembled, static core complete (gate §3)" \
  || bad "Stage 0 — snapshot build reported a missing static-core member"

m_pass "$TMP/ws5" "$TMP/ck5" 2 r5 2026-07-17
assemble "$FX/gate-runs/run2-rulings.json" "$TMP/ck5" "$FX/a-pass/run2.json" \
         "$TMP/m5.json" - "$TMP/run2.json"

python3 "$SK/sk_snapshot.py" report "$TMP/run2.json" > "$TMP/run2.entry" 2> "$TMP/run2.err"
RC=$?
[ $RC -eq 1 ] && ok "run 2 exits 1 — a FAIL verdict is a non-zero run" \
              || bad "run 2 exit code $RC, expected 1 (FAIL)"

hasx "$TMP/run2.entry" "Verdict: FAIL (5 gaps)" "verdict: FAIL (5 gaps) — the corpus's run-2 count"

printf '\n  the five gaps, verbatim from contract §7:\n'
while IFS= read -r want; do
  hasx "$TMP/run2.entry" "$want" "verbatim: ${want:0:56}…"
done <<'GAPS'
CC-XA-01 FAIL [non-waivable] — (Specialist × Appointment × cancel): no policy row in roles-permissions.md, but US3/FR-009 exercise it → add the row (governance change) or remove Specialist-initiated cancellation from scope.
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target, or move the concern to an NFR with metric + condition.
CC-AC-04 FAIL — US1 / scenario "Successful booking": re-narrates FR-001, no new data or path → convert to a checklist line, or make it carry the race-for-last-slot path with concrete data.
CC-NF-02 FAIL — accessibility: no NFR and no N/A — <reason> → add one or declare N/A with a reason.
GAPS

# D11 — gate §6.2's rule ("non-waivable marked") governs contract §7's rendering:
# CC-TR-01 is in the locked non-waivable set and its line carries the marker here,
# where §7's example prints it bare. The rule governs the example (the D6 pattern).
hasx "$TMP/run2.entry" "CC-TR-01 FAIL [non-waivable] — US4: zero FRs reference it (story is unbuilt) → author its FRs or drop/demote the story." \
     "D11: CC-TR-01's line = contract §7's, plus the marker gate §6.2 requires"

# D7 — the marker is the report writer's act, not the checker's, and it lands on
# exactly the failing members of the locked six.
NW=$(grep -c '\[non-waivable\]' "$TMP/run2.entry")
[ "$NW" = "2" ] && ok "D7: the two failing non-waivable assertions carry the marker — CC-XA-01 · CC-TR-01" \
                || bad "D7: $NW lines carry [non-waivable], expected 2"
grep -h 'FAIL' "$TMP/ck5"/*.json > "$TMP/ck5-lines.txt"
hasnt "$TMP/ck5-lines.txt" "[non-waivable]" \
      "D7: no checker emits the marker — the writer renders it (BUILD-LOG S2, D7)"

# D8 — an M checker never applies a waiver; the runtime flips it at P2
hasnt "$TMP/run2.entry" "CC-G-03 FAIL" \
      "D8: the CC-G-03 marker gap is flipped to WAIVED under W-004-01, not printed as a failure"
has "$TMP/run2.entry" "W-004-01 · CC-IN-03 · calendar-sync failure expectation deferred" \
    "waiver in force, contract §8 record shape"
has "$TMP/run2.entry" "also covers CC-G-03 (§8 Integration Touchpoints)" \
    "the waived marker is named on the record it belongs to (contract §8)"
has "$TMP/run2.entry" "O-004-01 · CC-AC-04" "override this run, §8 record shape"

hasx "$TMP/run2.entry" "CC-XA-01 — (verdict FAIL)" "⚑ CC-XA-01 reads \"— (verdict FAIL)\" (gate §5.3)"
hasx "$TMP/run2.entry" "CC-XA-06 — (verdict FAIL)" "⚑ CC-XA-06 reads \"— (verdict FAIL)\" (gate §5.3)"
has "$TMP/run2.entry" "BA approval: — (verdict FAIL; resubmit after fixes)" \
    "no approval on a FAIL — it is final until fixed, overridden or waived"
has "$TMP/run2.entry" "Certification:        — (not an effective PASS)" \
    "no certification block on a FAIL (gate §4.1 Stage 5)"

hasx "$TMP/run2.entry" "Category summary: 55 in force · 55 evaluated · 0 carried · 48 passed · 5 failed · 1 waived · 1 overridden · 0 skipped" \
     "category summary reconciles with contract §7 (55 F + 6 pre-flight H = 61 checked; 48 + 6 = 54 passed)"

compare "$TMP/run2.entry" "gate-run2.entry" "run-2 report entry"

# ── 3. gate run 3 — incremental re-gate → PASS WITH WAIVERS ──────────────────

printf '\n▸ Gate run 3 — incremental re-gate on r6 (gate §9.2, §14.2–§14.3)\n'

python3 "$SK/sk_snapshot.py" build --root "$R6" --feature 004-appointment-booking \
  --epic E-03 --run 3 --date 2026-07-18 --out "$TMP/m6.json" \
  --workspace "$TMP/ws6" --require-complete > /dev/null \
  && ok "Stage 0 — r6 snapshot assembled" \
  || bad "Stage 0 — r6 snapshot build failed"

python3 "$SK/sk_snapshot.py" rerun-set --prev "$TMP/m5.json" --curr "$TMP/m6.json" \
  --prev-spec "$S5" --curr-spec "$S6" --format json \
  --non-clean "CC-G-03,CC-G-04,CC-NF-02,CC-TR-01,CC-XA-01,CC-AC-04,CC-IN-03" \
  > "$TMP/rerun.json"

CARRIED=$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))['carried']))" "$TMP/rerun.json")
[ "$CARRIED" = "12" ] && ok "carry set = 12 (gate §14.2's 13, minus CC-FL-02 — the D6 erratum)" \
                      || bad "carry set = $CARRIED, expected 12"

# the waiver survives, the override auto re-applies — both resolved before any
# checker is invoked (gate §7.2 / §7.3, inside the §9.2 re-run set)
python3 "$SK/sk_snapshot.py" anchor-diff --prev "$TMP/m5.json" --curr "$TMP/m6.json" \
  --prev-spec "$S5" --curr-spec "$S6" --assertion CC-IN-03 --element "calendar sync" \
  --kind waiver --format json > "$TMP/aw.json" 2>&1
grep -q '"clean": true' "$TMP/aw.json" \
  && ok "W-004-01 anchor clean → survives to P5 re-affirmation" \
  || bad "W-004-01 anchor should be clean across r5→r6"

python3 "$SK/sk_snapshot.py" anchor-diff --prev "$TMP/m5.json" --curr "$TMP/m6.json" \
  --prev-spec "$S5" --curr-spec "$S6" --assertion CC-AC-04 --element "US2 acceptance" \
  --kind override --format json > "$TMP/ao.json" 2>&1
grep -q '"clean": true' "$TMP/ao.json" \
  && ok "O-004-01 anchor clean → auto re-applies, checker not run (gate §7.3)" \
  || bad "O-004-01 should auto re-apply"

m_pass "$TMP/ws6" "$TMP/ck6" 3 r6 2026-07-18
assemble "$FX/gate-runs/run3-rulings.json" "$TMP/ck6" "$FX/a-pass/run3.json" \
         "$TMP/m6.json" "$TMP/rerun.json" "$TMP/run3.json"

# Stage 5, act 1 (gate §8 step 6 / §11.1): the candidate traceability.md is
# committed to the feature folder, and the certification then covers it.
TRACE="specs/004-appointment-booking/traceability.md"
cp "$TMP/ws6/$TRACE" "$R6/$TRACE"
python3 - "$TMP/run3.json" "$TRACE" <<'PRODUCED'
import json, sys, pathlib
p = pathlib.Path(sys.argv[1])
d = json.loads(p.read_text(encoding="utf-8"))
d["produced"] = [sys.argv[2]]
p.write_text(json.dumps(d, indent=2, ensure_ascii=False), encoding="utf-8")
PRODUCED

python3 "$SK/sk_snapshot.py" report "$TMP/run3.json" \
  --certification-out "$TMP/cert6.json" > "$TMP/run3.entry" 2> "$TMP/run3.err"
RC=$?
[ $RC -eq 0 ] && ok "run 3 exits 0 — a pass-bound verdict" \
              || { bad "run 3 exit code $RC, expected 0"; sed 's/^/      /' "$TMP/run3.err"; }

hasx "$TMP/run3.entry" "Verdict: PASS WITH WAIVERS" "verdict: PASS WITH WAIVERS (gate §14.3)"
hasx "$TMP/run3.entry" "none" "Failures: none"
has "$TMP/run3.entry" "re-affirmed run 3" "P5: the surviving waiver is re-affirmed, one line"
has "$TMP/run3.entry" "(§Integration Touchpoints and brief untouched since grant)" \
    "the re-affirmation carries its basis (gate §14.3)"
has "$TMP/run3.entry" "re-applied — evidence unchanged since run 2" \
    "O-004-01 re-applied, not re-ruled (gate §7.3 — no override ritual)"
has "$TMP/run3.entry" "CC-XA-01 — 7 exercised tuples extracted; 7 explicit policy rows matched" \
    "⚑ CC-XA-01 signed on its evidence bundle (P3)"
has "$TMP/run3.entry" "CC-XA-06 — no spec content in brief §3 Excluded/Deferred" \
    "⚑ CC-XA-06 signed on its evidence bundle (P3)"
has "$TMP/run3.entry" "BA approval: Y. Kliukin · 2026-07-18 — effective PASS" \
    "P4 approval makes the PASS effective (contract §2 — the gate never self-certifies)"
hasx "$TMP/run3.entry" "Category summary: 55 in force · 42 evaluated · 12 carried · 41 passed · 0 failed · 1 waived · 1 overridden · 0 skipped" \
     "category summary = gate §14.3's, with CC-FL-02 moved carried→evaluated (D6)"
has "$TMP/run3.entry" "Certification: run 3 · effective PASS · 2026-07-18" \
    "certification manifest written at Stage 5 (gate §11.1)"
has "$TMP/run3.entry" "Adapter precondition: every hash matches the live file at handoff" \
    "the manifest states the adapter precondition"

compare "$TMP/run3.entry" "gate-run3.entry" "run-3 report entry"

has "$TMP/run3.entry" "$TRACE" \
    "the certification covers what the run produced, not only what it read (gate §11.1)"

# the manifest's hashes verify against the live tree — the handoff precondition
python3 "$SK/sk_snapshot.py" verify "$TMP/cert6.json" --root "$R6" > "$TMP/verify.txt" 2>&1 \
  && ok "certification manifest hashes verify clean against the live files" \
  || { bad "certified hashes do not verify"; sed 's/^/      /' "$TMP/verify.txt"; }

printf 'x\n' >> "$R6/$TRACE"
python3 "$SK/sk_snapshot.py" verify "$TMP/cert6.json" --root "$R6" > "$TMP/verify2.txt" 2>&1
has "$TMP/verify2.txt" "traceability.md — content changed" \
    "a post-certification edit to the generated file is caught too (gate §11.1)"
cp "$TMP/ws6/$TRACE" "$R6/$TRACE"

# ── 3b. gate run 4 — a re-cut card is never carried (gate §9.2, EC-21 R5) ─────

printf '\n▸ Gate run 4 — the cards changed and nothing A is carried (gate §9.2)\n'

# Two worlds identical in every read artifact; they differ only in the compiled
# A cards the run gates under. The fixture project carries no installed cards,
# so this pair installs them — which is also the upgrade case: a prior manifest
# with no `cards` entry against a current one that has it.
R7="$TMP/w/r7"; R8="$TMP/w/r8"
cp -R "$R6" "$R7"
mkdir -p "$R7/.specify/ba/cards"
cp "$PKG_ROOT/payload/specify-overlay/ba/cards/assertions-f.md" "$R7/.specify/ba/cards/"
cp -R "$R7" "$R8"
printf '\n<!-- CC-FL-04 re-cut -->\n' >> "$R8/.specify/ba/cards/assertions-f.md"
S7="$R7/specs/004-appointment-booking/spec.md"

python3 "$SK/sk_snapshot.py" build --root "$R7" --feature 004-appointment-booking \
  --epic E-03 --run 4 --date 2026-08-25 --out "$TMP/m7.json" \
  --require-complete > /dev/null \
  && ok "Stage 0 — the cards join the manifest, never deps(F) (--require-complete clean)" \
  || bad "Stage 0 — the cards entry broke the static-core completeness check"
python3 "$SK/sk_snapshot.py" build --root "$R8" --feature 004-appointment-booking \
  --epic E-03 --run 5 --date 2026-08-25 --out "$TMP/m8.json" > /dev/null

python3 - "$TMP/m7.json" <<'PY' && ok "the manifest carries the cards' hash under the \`cards\` label (gate §9.2)" \
                                 || bad "the manifest carries no single \`cards\` entry"
import json, pathlib, sys
m = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
e = [x for x in m["files"] if "cards" in x["labels"]]
sys.exit(0 if len(e) == 1
         and e[0]["path"] == ".specify/ba/cards/assertions-f.md"
         and len(e[0]["sha256"]) == 64 else 1)
PY

# `cards` is not a read set: no READ_SCOPE row names it, and it is outside
# MEMORY_LABELS — the label reaches the re-run set and nothing else.
python3 - "$SK/sk_snapshot.py" <<'PY' && ok "no assertion's read set names \`cards\` — it is the assertions, not an input" \
                                     || bad "\`cards\` leaked into a read set or into MEMORY_LABELS"
import pathlib, re, sys
src = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
scope = re.search(r"READ_SCOPE = \{.*?\n\}", src, re.S).group(0)
mem = re.search(r"MEMORY_LABELS = \{.*?\}", src, re.S).group(0)
sys.exit(0 if '"cards"' not in scope and '"cards"' not in mem else 1)
PY

python3 "$SK/sk_snapshot.py" rerun-set --prev "$TMP/m7.json" --curr "$TMP/m8.json" \
  --prev-spec "$S7" --curr-spec "$S7" --format json > "$TMP/rerun-cards.json"

python3 - "$TMP/rerun-cards.json" > "$TMP/cards-verdict.txt" <<'PY'
import json, pathlib, sys
r = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
print("cards_changed=%s" % r["cards_changed"])
print("carried=%d" % len(r["carried"]))
print("a_cards_changed=%d"
      % len([a for a in r["rerun"] if r["basis"][a] == "cards changed"]))
PY
hasx "$TMP/cards-verdict.txt" "cards_changed=True" \
     "rerun-set sees the re-cut card (gate §9.2, the fourth re-run member)"
hasx "$TMP/cards-verdict.txt" "a_cards_changed=34" \
     "every A assertion joins the re-run set with basis \`cards changed\`"
hasx "$TMP/cards-verdict.txt" "carried=0" \
     "nothing A is carried — a changed card is never carried"

# the runtime record states the basis on its own pinned line — none added,
# none removed, none reordered
python3 - "$TMP/run2.json" "$TMP/run-cards.json" <<'PY'
import json, pathlib, sys
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["carried"], d["cards_changed"] = [], True
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False),
                                     encoding="utf-8")
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run-cards.json" > "$TMP/cards.entry" 2>&1
hasx "$TMP/cards.entry" "Carried from run 1:   none — cards changed" \
     "the entry's carried line carries the basis (gate §9.2)"
hasx "$TMP/run2.entry" "Carried from run 1:   none" \
     "…and a run whose cards did not change still reads a bare \`none\`"
[ "$(wc -l < "$TMP/cards.entry")" = "$(wc -l < "$TMP/run2.entry")" ] \
  && ok "…and the entry is the same shape — no report line added or removed" \
  || bad "the cards basis moved the entry's line count"

# an effective PASS records the cards hash it was gated under, and the adapter
# never guards it: guarding would void the PASS the moment a card is re-cut,
# and §9.2 is explicit that nothing voids retroactively.
python3 "$SK/sk_snapshot.py" certification "$TMP/m7.json" > "$TMP/cert-cards.txt" 2>&1
has "$TMP/cert-cards.txt" "[cards — gated under; recorded, not guarded (§9.2)]" \
    "the certification block names the cards hash as recorded, not guarded"

# mutation — strip the rule and the same pair carries A verdicts again
mkdir -p "$TMP/mutant"
cp "$SK"/sk_*.py "$TMP/mutant/"
python3 - "$SK/sk_snapshot.py" "$TMP/mutant/sk_snapshot.py" <<'PY'
import pathlib, sys
s = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
old = """        if cards_changed:
            # the A set re-runs whole — nothing A is carried
            rerun.append(aid)
            basis[aid] = "cards changed"
            continue
"""
assert s.count(old) == 1, "the mutation target moved — fix this check, not the rule"
pathlib.Path(sys.argv[2]).write_text(s.replace(old, ""), encoding="utf-8")
PY
python3 "$TMP/mutant/sk_snapshot.py" rerun-set --prev "$TMP/m7.json" \
  --curr "$TMP/m8.json" --prev-spec "$S7" --curr-spec "$S7" --format json \
  > "$TMP/rerun-mutant.json" 2>&1
MUT=$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))['carried']))" \
      "$TMP/rerun-mutant.json" 2>/dev/null || echo 0)
[ "$MUT" -gt 0 ] \
  && ok "mutation: without the rule the same pair carries $MUT A verdicts — not vacuous" \
  || bad "mutation: the rule was removed and the carry set did not move"

# ── 4. the gate never self-certifies ─────────────────────────────────────────

printf '\n▸ The gate never self-certifies (contract §2 · gate §6.1)\n'

python3 - "$TMP/run3.json" "$TMP/run3-noapproval.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["approval"] = None
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run3-noapproval.json" > "$TMP/na.entry" 2>&1
has "$TMP/na.entry" "(provisional — awaiting BA approval)" \
    "a pass-bound run without P4 stays provisional"
has "$TMP/na.entry" "Certification:        — (not an effective PASS)" \
    "no certification without the BA's approval"

python3 - "$TMP/run3.json" "$TMP/run3-nosign.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["signoffs"] = {}
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run3-nosign.json" > "$TMP/ns.entry" 2>&1
has "$TMP/ns.entry" "CC-XA-01 — NOT SIGNED (required for an effective PASS)" \
    "an unsigned ⚑ line blocks the effective PASS (P3, contract §2)"
has "$TMP/ns.entry" "Certification:        — (not an effective PASS)" \
    "no certification without both ⚑ sign-offs"

# ── 5. the non-waivable refusal (gate §7.1 step 3) ───────────────────────────

printf '\n▸ Waiver instrument — hard refusals (gate §7.1 · contract §8)\n'

python3 - "$TMP/run2.json" "$TMP/run2-badwaiver.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["waivers"].append({"id": "W-004-02", "assertion": "CC-TR-01", "element": "US4",
                     "reason": "the story ships next cycle", "risk": "an unbuilt story",
                     "approver": "Y.K.", "date": "2026-07-17",
                     "revisit": "when US4's FRs are authored"})
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run2-badwaiver.json" > "$TMP/bw.out" 2> "$TMP/bw.err"
RC=$?
[ $RC -eq 2 ] && ok "a waiver against a non-waivable assertion exits 2 — refused, not recorded" \
              || bad "expected exit 2 on a non-waivable waiver request, got $RC"
has "$TMP/bw.err" "REFUSED — CC-TR-01 is non-waivable: A broken story⇄FR graph breaks" \
    "the refusal prints the contract §8 rationale line for that ID"
[ -s "$TMP/bw.out" ] && bad "a refused run must not produce a report entry" \
                     || ok "no report entry is written on a refusal"

python3 - "$TMP/run2.json" "$TMP/run2-thinwaiver.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["waivers"].append({"id": "W-004-03", "assertion": "CC-NF-02", "element": "accessibility",
                     "reason": "later", "approver": "Y.K."})
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run2-thinwaiver.json" > /dev/null 2> "$TMP/tw.err"
has "$TMP/tw.err" "waiver record incomplete, missing risk, revisit" \
    "an incomplete waiver record is refused, naming the missing contract §8 fields"

# ── 6. P1 — admission block and the health acceptance (gate §4.1 · §10.4) ────

printf '\n▸ P1 — pre-flight block and the health acceptance (gate §10.4)\n'

python3 "$SK/sk_health.py" --format json --root "$FX/negatives/health" \
  > "$TMP/health.json" 2>/dev/null
python3 - "$TMP/health.json" "$FX/gate-runs/run2-rulings.json" "$TMP/blocked.json" <<'PY'
import json, sys, pathlib
health = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d = json.loads(pathlib.Path(sys.argv[2]).read_text(encoding="utf-8"))
gaps = [{"assertion": a["assertion"], **f}
        for a in health["assertions"] for f in a["findings"]][:2]
d["run"] = 4
d["date"] = "2026-07-19"
d["preflight"] = {"status": "gaps", "gaps": gaps}
pathlib.Path(sys.argv[3]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/blocked.json" > "$TMP/blocked.entry" 2>&1
RC=$?
[ $RC -eq 1 ] && ok "a blocked admission is a non-zero run" \
              || bad "expected exit 1 on a blocked admission, got $RC"
has "$TMP/blocked.entry" "## Gate run 4 — 2026-07-19 — blocked at pre-flight" \
    "the blocked admission takes a run number — the ledger stays gapless (gate §6.2)"
has "$TMP/blocked.entry" "Verdict: BLOCKED AT PRE-FLIGHT (2 H gaps)" "verdict names the H gap count"
has "$TMP/blocked.entry" "CC-H-02 FAIL — " "the H gaps are named in named-gap grammar"
hasnt "$TMP/blocked.entry" "Category summary" \
      "nothing else is evaluated — Stage 0 halts the run (gate §4.1)"

python3 - "$TMP/blocked.json" "$TMP/ha.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
for g in d["preflight"]["gaps"]:
    g["ha"] = "HA-01"
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/ha.json" > "$TMP/ha.entry" 2>&1
has "$TMP/ha.entry" "Pre-flight:           2 gap(s) lifted by HA-01" \
    "an HA lifts the admission block and the run cites it (gate §10.4)"
has "$TMP/ha.entry" "Category summary" "the run proceeds past Stage 0 once admitted"

# ── 6b. the near-miss's supersession key (gate §10.4 · build-log D181) ───────
#
# The H layer's half of the shape-guard set. Option (c), ruled 17 Aug 2026:
# neither a report-only class nor a new HA power — the class is keyed on
# supersession, because a corrective append to an append-only log is always
# legal and so a live finding can clear by the log's own mechanism.

printf '\n▸ The near-miss — live vs settled, keyed on supersession (gate §10.4)\n'

GATE_DOC="$PKG_ROOT/docs/methodology/ba-native-spec-gate-definition.md"
has "$GATE_DOC" "The near-miss and its supersession key — live vs settled" \
    "§10.4 states the classing rule"
has "$GATE_DOC" "while **no well-formed entry follows it** in the log" \
    "…LIVE is keyed on supersession, in log order"
has "$GATE_DOC" 'supersede it with a correctly-shaped entry; never edit it' \
    "…and a live near-miss's fix is the log's own law"
has "$GATE_DOC" '**"No well-formed entries at all" is the live case.**' \
    "…an empty log's near-misses are live, not settled by default"
has "$GATE_DOC" "superseded-by <Allocation n>" \
    "SETTLED is still named, with what superseded it"
has "$GATE_DOC" "rendered **outside the gap count**: it blocks nothing and **requires no acceptance**" \
    "…outside the gap count, blocking nothing, taking no acceptance"
has "$GATE_DOC" "The repair here is **always legal**" \
    "…the rationale is on the record: the repair is always legal"
has "$GATE_DOC" "**\`HA-<nn>\` and D-G9 are untouched by this rule**" \
    "…and the acceptance instrument is explicitly left untouched"
has "$GATE_DOC" "named, never silenced" \
    "…the blind-spots law holds: settled history is named"

# The contract's own CC-H-02 row is NOT edited — the contract states the
# assertion; how a finding under it is classed is this document's ground.
CONTRACT_DOC="$PKG_ROOT/docs/methodology/ba-native-spec-completeness-contract.md"
has "$CONTRACT_DOC" "| CC-H-02 | Roadmap discipline: every epic carries a status; every re-allocation entry logs a diff and a reason. | roadmap | 10.2" \
    "the contract's CC-H-02 row stands unedited — the assertion did not move"

# ── 6c. CC-H-07 — the acceptance cross-check at the H layer (contract v0.3 §6 ·
#       gate v0.11 §10.2 · §10.4) ─────────────────────────────────────────────
#
# EC-02. Deferrals were never cross-checked against the acceptance/pass/success
# lists the sources state, so a conflict surfaced at delivery rather than at the
# decision. T-18's step-4 list is the runtime surface; this is the STANDING
# BACKSTOP — an unruled conflict is a live H gap and blocks like any other, with
# `HA-<nn>` the conscious valve. The contract states the assertion; classing,
# counting and run points are the gate's — the CC-H-02 division of labor.

printf '\n▸ CC-H-07 — the acceptance cross-check at the H layer (contract §6 · gate §10.2 · §10.4)\n'

CARDS_H="$PKG_ROOT/payload/specify-overlay/ba/cards/assertions-h.md"
SKILLS_D="$PKG_ROOT/payload/claude/skills"

has "$CONTRACT_DOC" "| CC-H-07 | No standing acceptance-shape conflict is unresolved" \
    "the contract carries the CC-H-07 row (§6)"
has "$CONTRACT_DOC" "| roadmap+oos+ledger head | 10.1 · 7.2 consistent | A |" \
    "…with its Checks set and its class — A, judged, never mechanical"
has "$CONTRACT_DOC" "The assertion count moves **61 → 62** (24 M · 38 A)" \
    "…and the count moves 61 → 62, the M third untouched"
has "$CONTRACT_DOC" "assertion count: 62 (6 global · 49 across C1–C12 · 7 project-health)" \
    "…the v0.3 record keeping its own seven-row count, on the record"
has "$CARDS_H" "### CC-H-07 · Checks: roadmap+oos+ledger head" \
    "the compiled A card carries CC-H-07 — check-cards.py holds it byte-identical"

has "$GATE_DOC" "The acceptance cross-check (CC-H-07) — classing, ground and run points" \
    "§10.4 owns the runtime — the contract states the assertion"
has "$GATE_DOC" "**Element grain is the conflicting pair**" \
    "…element grain is the conflicting pair: one deferred item × one standing entry"
has "$GATE_DOC" 'CC-H-07 FAIL — E-05 (Phase 2) × AS-2 "reminders fire" — no recorded ruling' \
    "…rendered in named-gap grammar"
has "$GATE_DOC" "\`hold as advisory\` included: the BA saw it and chose visibility, which is a ruling" \
    "…RESOLVED by any recorded ADV disposition, \`hold as advisory\` among them"
has "$GATE_DOC" "the AS entry itself standing \`superseded — SD-<n>\` or \`accepted — <reason>\`" \
    "…or by the entry itself, superseded or accepted"
has "$GATE_DOC" "a ruled conflict is not a finding — the record is the ruling itself" \
    "…and a ruled conflict is not re-named"
has "$GATE_DOC" "it counts in \`n gaps\` and **blocks under this section's rule**" \
    "…UNRESOLVED is a live gap that counts and blocks"
has "$GATE_DOC" "\`HA-<nn>\` applies exactly as to any H gap" \
    "…with HA the conscious valve, D-G9's mechanics untouched"
has "$GATE_DOC" "**Run points:** full Scope-H runs · Stage-0 pre-flight where \`roadmap\` or \`out-of-scope.md\` ∈ \`deps(F)\` · scoped runs on \`roadmap\` and \`out-of-scope.md\` edits" \
    "…the three run points, named"
has "$GATE_DOC" "The head is ground, never a trigger and never audited" \
    "…and the first ledger-head read is the named boundary change — read-only"
has "$GATE_DOC" "CC-H-02 · CC-H-03 · CC-H-07 (the roadmap half" \
    "§10.2's scoped map gives roadmap the roadmap half"
has "$GATE_DOC" "CC-H-07 — \`out-of-scope.md\` only (the fence half" \
    "…and out-of-scope.md the fence half, that artifact alone"

# the compiled surfaces
has "$SKILLS_D/ba-gate/SKILL.md" "CC-H-05 · CC-H-07" \
    "the compiled gate dispatches CC-H-07 with the A third"
has "$SKILLS_D/ba-gate/SKILL.md" "read-only, never a trigger" \
    "…naming the boundary at the surface that reads it"
has "$SKILLS_D/ba-gate-health/SKILL.md" "CC-H-01 · CC-H-04 · CC-H-05 · CC-H-07" \
    "…and /ba-gate-health carries it in the A third too"
has "$SKILLS_D/ba-gate-health/SKILL.md" "Element grain is the conflicting pair" \
    "…with the element grain compiled at its own site"
has "$SKILLS_D/ba-gate-health/SKILL.md" "the record is the ruling itself" \
    "…and a ruled conflict named as not a finding"

# live: an unresolved pair blocks admission exactly as any H gap does
printf '\n  the pre-flight block, live:\n'
python3 - "$TMP/blocked.json" "$TMP/h07.json" <<'PYH7'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
d["run"], d["date"] = 5, "2026-07-20"
d["preflight"] = {"status": "gaps", "gaps": [{
    "assertion": "CC-H-07",
    "element": 'E-05 (Phase 2) x AS-2 "reminders fire"',
    "problem": "no recorded ruling",
    "fix": "rule it at T-18's step-4 decision list, or record the entry "
           "`superseded - SD-<n>` / `accepted - <reason>`",
    "evidence": "", "location": ".specify/memory/roadmap.md",
    "gap_line": 'CC-H-07 FAIL — E-05 (Phase 2) × AS-2 "reminders fire" — no recorded ruling',
    "ha": None}]}
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PYH7
python3 "$SK/sk_snapshot.py" report "$TMP/h07.json" > "$TMP/h07.entry" 2>&1
RC=$?
[ $RC -eq 1 ] && ok "an unresolved conflicting pair is a non-zero run — it blocks like any H gap" \
              || bad "expected exit 1 on an unresolved CC-H-07 pair, got $RC — the backstop does not block"
has "$TMP/h07.entry" "Verdict: BLOCKED AT PRE-FLIGHT (1 H gap)" \
    "…counted in \`n gaps\` and named in the verdict"
has "$TMP/h07.entry" 'CC-H-07 FAIL — E-05 (Phase 2) × AS-2 "reminders fire" — no recorded ruling' \
    "…the pair rendered as the element, in named-gap grammar"
hasnt "$TMP/h07.entry" "Category summary" \
      "…and nothing else is evaluated — Stage 0 halts the run"

# the control — HA lifts it exactly as it lifts any other H gap (D-G9 untouched)
python3 - "$TMP/h07.json" "$TMP/h07-ha.json" <<'PYH7B'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
for g in d["preflight"]["gaps"]:
    g["ha"] = "HA-02"
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PYH7B
python3 "$SK/sk_snapshot.py" report "$TMP/h07-ha.json" > "$TMP/h07-ha.entry" 2>&1
has "$TMP/h07-ha.entry" "Pre-flight:           1 gap(s) lifted by HA-02" \
    "…and an HA lifts it, the conscious valve working on CC-H-07 as on any H gap"
has "$TMP/h07-ha.entry" "Category summary" "…the run proceeding past Stage 0 once accepted"


# ── 6d. CC-H-08 — boundary coverage at the H layer (contract v0.5 §6 ·
#       gate v0.14 §10.1 · §10.2 · §10.4) ────────────────────────────────────
#
# EC-22. Nothing anywhere compared the roadmap's in-boundary rows to the brief
# set, so two billable epics with no folder were invisible to every surface —
# each of which was correct on its own terms. CC-H-03 is subset-blind by
# construction (it conditions on ENTERING Band 3) and stands untouched; this
# row owns the coverage question. It counts and it never blocks: the join sits
# in no feature's deps(F).

printf '\n▸ CC-H-08 — boundary coverage at the H layer (contract §6 · gate §10.1 · §10.2 · §10.4)\n'

has "$CONTRACT_DOC" "| CC-H-08 | Boundary coverage: every roadmap epic allocated to a phase inside the ledger head" \
    "the contract carries the CC-H-08 row (§6)"
has "$CONTRACT_DOC" "| brief+roadmap+ledger head | 10.41 · 7.2 complete | M |" \
    "…with its Checks set and its class — M, a file-existence join, CC-H-03's own class"
has "$CONTRACT_DOC" "**Assertion count 62 → 63: 25 M · 38 A (2 ⚑).**" \
    "…and the count moves 62 → 63, the M third 24 → 25"
has "$CONTRACT_DOC" "assertion count: 63 (6 global · 49 across C1–C12 · 8 project-health; 25 M · 38 A, 2 ⚑)" \
    "…the live footer counting eight project-health rows"
has "$CONTRACT_DOC" "**CC-H-03 is untouched**" \
    "…and CC-H-03 is untouched: two questions, two rows"

hasnt "$CARDS_H" "CC-H-08" \
    "the A card does NOT carry it — assertions-h.md is the A pass, and CC-H-08 is M"

has "$GATE_DOC" "The boundary-coverage check (CC-H-08) — classing, ground and run points" \
    "§10.4 owns the runtime — the contract states the assertion"
has "$GATE_DOC" "**Element grain is the epic**" \
    "…element grain is the epic, one line per uncovered row"
has "$GATE_DOC" "CC-H-08 FAIL — E-10 Public API & Bulk Generation — Phase 2 · Billable Yes — no scope brief" \
    "…rendered in named-gap grammar, phase and Billable on the line"
has "$GATE_DOC" "existence, not content: the slicing's presence stays CC-H-03's question" \
    "…reading brief EXISTENCE, the slicing staying CC-H-03's"
has "$GATE_DOC" "**Vacuous, never a gap,**" \
    "…vacuous where no roadmap or no boundary stands — the absent-source law"
has "$GATE_DOC" "counts in \`n gaps\` and blocks nothing" \
    "…a live gap counts and blocks NOTHING — no deps(F) contains the join"
has "$GATE_DOC" "**never Stage-0 pre-flight**" \
    "…and it is never in the Stage-0 pre-flight set"
has "$GATE_DOC" "CC-H-08 (the in-boundary rows against the brief set)" \
    "§10.2's scoped map widens the roadmap cell in place"
has "$GATE_DOC" "CC-H-08 (existence at boundary grain — a deleted brief surfaces)" \
    "…and the scope-brief cell, for the deleted-brief cause"
has "$GATE_DOC" "Every CC-H assertion over all spec-anchored artifacts" \
    "§10.1's full-run cell goes count-free — a count that goes stale silently is worse than none"
NSIX=$(grep -o "all six CC-H" "$GATE_DOC" | wc -l | tr -d ' ')
[ "$NSIX" = "1" ] \
  && ok "…and the stale six-CC-H count survives only where v0.14 quotes what it retired" \
  || bad "the gate document carries $NSIX \"all six CC-H\", expected 1 (the change record's quotation)"

# The gate's edition pin — minted here, 1 Sep 2026 (EC-22 closure). Through
# v0.14 no check pinned this document's edition string: check-gate pinned its
# law instead, and a header bump was invisible to the whole suite. v0.15's own
# change record asserts the pin exists and reads this header, so the estate
# takes it — the document wins. The second copy lives in check-auto.sh, which
# reads this document too: the 0.1.47 two-site lesson, applied before it can
# be relearned. head -2 reads the edition line alone — the change record on
# line 3 names the same edition and must not be what satisfies the pin.
head -2 "$GATE_DOC" | grep -q 'v0\.15' \
  && ok "the header states the live edition — v0.15, the CC-H-08 line meets §7's grammar" \
  || bad "the header does not name v0.15: the edition and the change record disagree"

# the compiled surfaces carry the same law, count-free
has "$SKILLS_D/ba-gate-health/SKILL.md" "CC-H-02 · CC-H-03 · CC-H-06 · CC-H-08" \
    "/ba-gate-health runs CC-H-08 with the M third"
has "$SKILLS_D/ba-gate-health/SKILL.md" "every CC-H assertion over every spec-anchored artifact" \
    "…its full-run row count-free"
has "$SKILLS_D/ba-gate-health/SKILL.md" "CC-H-08 — the boundary-coverage check" \
    "…with the check's own paragraph compiled at its site"
has "$SKILLS_D/ba-gate-health/SKILL.md" "CC-H-08 FAIL — E-10 Public API & Bulk Generation — Phase 2 · Billable Yes — no scope brief" \
    "…and its named-gap grammar"
has "$SKILLS_D/ba-gate/SKILL.md" "**CC-H-08 is never in this set:**" \
    "the compiled gate keeps CC-H-08 out of pre-flight, and says why"
hasnt "$SKILLS_D/ba-gate/SKILL.md" "the seven CC-H assertions restricted to" \
    "…its pre-flight line count-free too"

# the runtime table the snapshot compiles from the contract
python3 - "$PKG_ROOT/payload/specify-overlay/ba/scripts/sk_snapshot.py" <<'PYH8' \
  && ok "sk_snapshot's SCOPE_H carries CC-H-08 as M — the H set is eight rows" \
  || bad "sk_snapshot's SCOPE_H does not carry CC-H-08 as an M row"
import sys
from pathlib import Path
sys.path.insert(0, str(Path(sys.argv[1]).parent))
from sk_snapshot import SCOPE_H
sys.exit(0 if ("CC-H-08", "H", "M") in SCOPE_H and len(SCOPE_H) == 8 else 1)
PYH8

# ── 7. R4 — the A pass takes §5.1 by reference, and carries no copy ──────────
#
# BA Lead ruling R4 = (a), 14 August 2026: §5.1's SKIPPED-on-unsupported-parse
# rule extends to the A pass **by reference to §5.1, never by restatement**.
# The agent surface cites the rule; it does not carry a second copy of it.
#
# Prose intent proves nothing, so this reads the shape twice:
#   (a) the citation is present in both layers — the document's §5.2 and the
#       compiled A-pass surface, payload/claude/agents/ba-gate.md;
#   (b) neither carries §5.1's text — no six-word run of §5.1's own rule
#       paragraph appears in either. That read is derived from §5.1 live, not
#       from a hand-listed phrase set, so it still holds if §5.1 is re-worded.
# Then the mutation, per the house rule: a pasted §5.1 sentence must make (b)
# fire, or (b) is worth nothing.

printf '\n▸ R4 — the A pass takes §5.1 by reference (gate §5.2 · ba-gate.md)\n'

GATE_DOC="$PKG_ROOT/docs/methodology/ba-native-spec-gate-definition.md"
GATE_AGENT="$PKG_ROOT/payload/claude/agents/ba-gate.md"

fhas "$GATE_DOC" "**Unsupported parse — §5.1's rule, taken by reference.**" \
     "gate §5.2 carries the by-reference bullet"
fhas "$GATE_DOC" "only a checker that read parsable evidence" \
     "…and the doubt rule's boundary is ruled — parse gaps are §5.1's case alone (D161 = (a))"
fhas "$GATE_DOC" "this section cites it and **carries no second copy of it**" \
     "…and the document layer states the no-copy discipline"
fhas "$GATE_AGENT" "**§5.1 SKIPPED-on-unsupported-parse rule**, the same one the M pass runs on, reaching this pass **by reference**" \
     "the A-pass surface cites §5.1 by name and by section"
fhas "$GATE_AGENT" "it is stated once, at §5.1, and this surface cites it and carries no second copy of it" \
     "…and the surface states the no-copy discipline in its own words"

NODUP="$TMP/nodup.py"
cat > "$NODUP" <<'PY'
"""No second copy — no six-word run of gate §5.1's rule paragraph may appear in
the surface handed in. Derived from §5.1's live text, never a phrase list."""
import pathlib, re, sys

N = 6

def words(s):
    return re.findall(r"[a-z0-9§.-]+", re.sub(r"[`*_]", "", s.lower()))

def para(text, lead):
    i = text.index(lead)
    return text[i:text.index("\n\n", i)]

gate = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
rule = words(para(gate, "**A zero the reader produced is not a count"))
target = words(pathlib.Path(sys.argv[2]).read_text(encoding="utf-8"))

shingles = {" ".join(target[i:i + N]) for i in range(len(target) - N + 1)}
hits = sorted({" ".join(rule[i:i + N]) for i in range(len(rule) - N + 1)} & shingles)
for h in hits:
    print("copied run: %r" % h, file=sys.stderr)
sys.exit(1 if hits else 0)
PY

python3 "$NODUP" "$GATE_DOC" "$GATE_AGENT" 2> "$TMP/nodup-agent.err" \
  && ok "the A-pass surface carries no six-word run of §5.1 — a citation, not a copy" \
  || bad "the A-pass surface restates §5.1 — $(tr '\n' ' ' < "$TMP/nodup-agent.err")"

python3 - "$GATE_DOC" "$TMP/bullet.md" <<'PY'
import pathlib, sys
t = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
i = t.index("- **Unsupported parse — §5.1's rule")
pathlib.Path(sys.argv[2]).write_text(t[i:t.index("\n\n", i)], encoding="utf-8")
PY
python3 "$NODUP" "$GATE_DOC" "$TMP/bullet.md" 2> "$TMP/nodup-bullet.err" \
  && ok "…and §5.2's own bullet restates none of it either" \
  || bad "§5.2's bullet restates §5.1 — $(tr '\n' ' ' < "$TMP/nodup-bullet.err")"

python3 - "$GATE_DOC" "$GATE_AGENT" "$TMP/agent-pasted.md" <<'PY'
import pathlib, sys
gate = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
i = gate.index("**Spec grain:**")
pasted = gate[i:gate.index("**Section grain:**", i)]
agent = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
pathlib.Path(sys.argv[3]).write_text(agent + "\n" + pasted + "\n", encoding="utf-8")
PY
python3 "$NODUP" "$GATE_DOC" "$TMP/agent-pasted.md" 2> /dev/null \
  && bad "a pasted §5.1 sentence slipped past the no-copy read — it is vacuous" \
  || ok "…and a pasted §5.1 sentence is caught: the no-copy read is not vacuous"

# ── 7b. EC-21 — evidence and decision come apart (gate §4.1 · §5.2 · §5.3) ────
#
# Two runtime rules, compiled onto the two gate surfaces and nowhere else:
#   R1  compute always, sign separately — ⚑ governs the signature, never the
#       evaluation, so a skip names a CC-<ID> or a parse gap and nothing else;
#   R2  a marker is evidence, never coverage — an A assertion reads the cell's
#       stated content and gives a marker no weight.
# Each is read in both layers: the document that rules it and the surface that
# compiles it. The surfaces legislate nothing of their own (D-O64), so each
# reads back to a cited section.

printf '\n▸ EC-21 — evidence vs decision on the two gate surfaces (gate §4.1 · §5.2 · §5.3)\n'

GATE_SKILL="$PKG_ROOT/payload/claude/skills/ba-gate/SKILL.md"

fhas "$GATE_DOC" "**A marker is evidence, never coverage.**" \
     "gate §5.2 rules the marker bullet"
fhas "$GATE_DOC" "**Compute always; sign separately.**" \
     "gate §5.3 rules compute-always"
fhas "$GATE_DOC" "A blocker is always a \`CC-<ID>\` or §5.1's parse gap — never a mode, a grant or a flag" \
     "gate §4.1 rules what a blocker is"
fhas "$GATE_DOC" "**The floor is the signature, never the evaluation:**" \
     "gate §7.1 carries the floor sentence"

fhas "$GATE_AGENT" "**A marker is evidence, never coverage.**" \
     "the A-pass surface carries the marker rule"
fhas "$GATE_AGENT" "a cell whose only content is a marker is **unspecified**" \
     "…and reads a marker-only cell as unspecified, the obligation's FAIL standing"
fhas "$GATE_AGENT" "(gate §5.2)" \
     "…citing §5.2, which rules it — the surface legislates nothing of its own"
fhas "$GATE_AGENT" "You compute both bundles in full on **every** run you are asked to evaluate" \
     "…and computes both ⚑ bundles on every run, under any grant (§5.3)"
fhas "$GATE_AGENT" "the floor is the signature, never your evaluation: \`⚑\`, \`safety floor\` and \`no grant reaches it\` are never a reason to skip" \
     "…and never treats the floor as a reason to skip"
fhas "$GATE_AGENT" "a skip names a \`CC-<ID>\` or a parse gap and nothing else" \
     "…a skip naming a CC-ID or a parse gap and nothing else (§4.1)"

fhas "$GATE_SKILL" "the two ⚑ assertions among them, on every run and under any standing grant" \
     "the gate skill dispatches the ⚑ pair on every run"
fhas "$GATE_SKILL" "A blocker is always a \`CC-<ID>\` or §5.1's parse gap — never a mode, a grant or a flag (§5.3)." \
     "…and states the blocker sentence beside the Stage-3 dispatch"
fhas "$GATE_SKILL" "**The floor is the signature, never the evaluation:** the two ⚑ assertions are computed at Stage 3 on every run and under any grant (§5.3); what waits for the BA is the P3 signature on the computed bundle, and nothing else." \
     "…and the floor paragraph carries §7.1's sentence verbatim"
fhas "$GATE_SKILL" "every A assertion whose compiled card differs from the prior run's — a changed card is never carried" \
     "…and the incremental section carries §9.2's fourth re-run member"

# the compiled cards restate neither runtime rule: §5.2 is stated once, at the
# document, and inherited by every A assertion (gate §5.2's own words)
CARDS_F="$PKG_ROOT/payload/specify-overlay/ba/cards/assertions-f.md"
hasnt "$CARDS_F" "a marker is evidence, never coverage" \
      "no card restates the marker rule — it is the runtime's, stated once"
hasnt "$CARDS_F" "Compute always" \
      "no card restates compute-always either"

# mutation: the marker rule is load-bearing on the surface, not decoration
python3 - "$GATE_AGENT" "$TMP/gate-agent-mutant.md" <<'PY'
import pathlib, re, sys
s = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
i = s.index("**A marker is evidence, never coverage.**")
j = s.index("\n\n", i)
assert "(gate §5.2)" in s[i:j], "the marker paragraph lost its citation"
pathlib.Path(sys.argv[2]).write_text(s[:i] + s[j + 2:], encoding="utf-8")
PY
grep -Fq "A marker is evidence, never coverage" "$TMP/gate-agent-mutant.md" \
  && bad "mutation: the marker rule survived its own removal — the read is vacuous" \
  || ok "mutation: removing the paragraph removes the rule — the read is not vacuous"

# ── 8. the suite is not vacuous ──────────────────────────────────────────────

printf '\n▸ Mutation checks — the suite is not vacuous\n'

python3 - "$FX/a-pass/run2.json" "$TMP/a-mutant.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
for a in d["assertions"]:
    if a["assertion"] == "CC-XA-01":
        a["verdict"], a["findings"] = "PASS", []
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
assemble "$FX/gate-runs/run2-rulings.json" "$TMP/ck5" "$TMP/a-mutant.json" \
         "$TMP/m5.json" - "$TMP/run2-mutant.json"
python3 "$SK/sk_snapshot.py" report "$TMP/run2-mutant.json" > "$TMP/mut.entry" 2>&1
has "$TMP/mut.entry" "Verdict: FAIL (4 gaps)" \
    "dropping the CC-XA-01 verdict moves the count to 4 — the gap list is real"

python3 - "$TMP/run2.json" "$TMP/run2-badgrammar.json" <<'PY'
import json, sys, pathlib
d = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
ck = pathlib.Path(d["checkers"][0]).parent / "scan.json"
s = json.loads(ck.read_text(encoding="utf-8"))
for a in s["assertions"]:
    for f in a["findings"]:
        f["fix"] = "do something about it"      # line no longer round-trips
mutant = ck.parent / "scan-mutant.json"
mutant.write_text(json.dumps(s, indent=2, ensure_ascii=False))
d["checkers"] = [c for c in d["checkers"] if not c.endswith("scan.json")] + [str(mutant)]
pathlib.Path(sys.argv[2]).write_text(json.dumps(d, indent=2, ensure_ascii=False))
PY
python3 "$SK/sk_snapshot.py" report "$TMP/run2-badgrammar.json" > /dev/null 2> "$TMP/bg.err"
RC=$?
[ $RC -eq 2 ] && ok "a finding whose line does not round-trip the named-gap grammar is a runtime defect" \
              || bad "expected exit 2 on a non-round-tripping gap line, got $RC"
has "$TMP/bg.err" "does not round-trip the named-gap grammar" \
    "the writer names the mismatch (gate §1 rule 2 — the gate meets its own bar)"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S3 gate: cards · Scope-F stages 0–5 · W/O/HA · P1–P8 · certification\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
