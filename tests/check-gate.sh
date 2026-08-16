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
