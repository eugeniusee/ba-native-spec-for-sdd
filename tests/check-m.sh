#!/usr/bin/env bash
#
# BA-Native Spec — the M-machinery suite (build plan §4, S2 exit test).
#
# Runs the ten vendored checker scripts against the appointment-booking fixture
# world and asserts three things:
#
#   1. Every case's verdict set matches its recorded expected-verdict table
#      (tests/fixtures/appointment-booking/expected/<case>.expect).
#   2. Fixture r5 reproduces gate run-2's M-detectable gaps **verbatim** in the
#      contract's §7 named-gap grammar.
#   3. sk_idgraph emits a gate-§8-shaped traceability.md; sk_snapshot reproduces
#      gate §14.2's re-run composition and §14.3's anchor dispositions, and
#      refuses on a post-certification byte edit.
#
# Then it computes the coverage matrix the S2 exit test names: **every M
# assertion exercised with ≥ 1 seeded FAIL and ≥ 1 PASS**. A silent gap in that
# matrix fails the run — an unexercised checker is an unproven checker.
#
#   check-m.sh              run the suite
#   check-m.sh --record     rewrite the expected-verdict tables from this run
#                           (use only after reviewing the diff by eye)
#   check-m.sh -v           print every verdict, not just the failures

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
    -h|--help) sed -n '2,26p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ALL="$TMP/all-verdicts.txt"; : > "$ALL"

ok()   { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad()  { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

# verdicts <case> <script.py> [args…] — append "script|CC-ID|VERDICT" lines
verdicts() {
  local case_name="$1"; shift
  local script="$1"; shift
  python3 "$SK/$script.py" --format json "$@" > "$TMP/out.json" 2> "$TMP/err.txt"
  local rc=$?
  if [ $rc -eq 2 ]; then
    printf '  ✗ %s: %s exited 2 (runtime defect)\n' "$case_name" "$script"
    cat "$TMP/err.txt" >&2
    FAILED=$((FAILED+1))
    return 1
  fi
  python3 - "$TMP/out.json" <<'PY' >> "$TMP/case.txt"
import json, sys
d = json.load(open(sys.argv[1]))
for a in d["assertions"]:
    print("%s|%s|%s" % (d["script"], a["assertion"], a["verdict"]))
PY
}

finish_case() {
  local case_name="$1"
  sort "$TMP/case.txt" > "$TMP/observed.txt"
  cut -d'|' -f2,3 "$TMP/observed.txt" >> "$ALL"
  local expected="$EXP/$case_name.expect"
  if [ "$RECORD" -eq 1 ]; then
    cp "$TMP/observed.txt" "$expected"
    printf '  · recorded %s (%s verdicts)\n' "$case_name.expect" "$(wc -l < "$expected" | tr -d ' ')"
    return 0
  fi
  if [ ! -f "$expected" ]; then
    bad "$case_name: no expected-verdict table at $expected"
    return 1
  fi
  if diff -u "$expected" "$TMP/observed.txt" > "$TMP/diff.txt"; then
    ok "$case_name — $(wc -l < "$TMP/observed.txt" | tr -d ' ') verdicts as recorded"
  else
    bad "$case_name — verdicts diverge from the recorded table:"
    sed 's/^/      /' "$TMP/diff.txt"
  fi
}

# spec_case <case> <spec> [extra args to every script]
spec_case() {
  local name="$1" spec="$2"; shift 2
  : > "$TMP/case.txt"
  verdicts "$name" sk_structure  --root "$FX/project" --spec "$spec" "$@"
  verdicts "$name" sk_scan       --root "$FX/project" --spec "$spec" \
                                 --personas "$FX/negatives/personas.md" "$@"
  verdicts "$name" sk_stories    --root "$FX/project" --spec "$spec" "$@"
  verdicts "$name" sk_acceptance --root "$FX/project" --spec "$spec" "$@"
  verdicts "$name" sk_ears       --root "$FX/project" --spec "$spec" "$@"
  verdicts "$name" sk_sections   --root "$FX/project" --spec "$spec" "$@"
  verdicts "$name" sk_idgraph    --root "$FX/project" --spec "$spec" \
                                 --feature 004-appointment-booking "$@"
  finish_case "$name"
}

printf '\n▸ Scope-F spec cases (contract §4–§5, M rows)\n'

spec_case r5 "$FX/revisions/spec-r5.md"
spec_case r6 "$FX/revisions/spec-r6.md"
spec_case neg-structure  "$FX/negatives/neg-structure.md"
spec_case neg-scan       "$FX/negatives/neg-scan.md"
spec_case neg-stories    "$FX/negatives/neg-stories.md"
spec_case neg-acceptance "$FX/negatives/neg-acceptance.md"
spec_case neg-ears       "$FX/negatives/neg-ears.md"
spec_case neg-sections   "$FX/negatives/neg-sections.md"
spec_case neg-idgraph    "$FX/negatives/neg-idgraph.md"
# the shape cases (S10 — the silent-zero parser, field report 14 Aug 2026):
#   neg-shapes — the two tolerated habits (numbered headings, bolded US IDs)
#     read THROUGH, so the content is found; CC-G-01 still FAILs the form,
#     and the table-form FRs report loudly instead of as a silent zero.
#   neg-alien  — headings no tolerance reaches: every assertion either FAILs
#     with found-vs-expected or is SKIPPED. Nothing PASSes vacuously.
spec_case neg-shapes     "$FX/negatives/neg-shapes.md"
spec_case neg-alien      "$FX/negatives/neg-alien.md"

printf '\n▸ CC-XA-05 — brief + slicing row (contract C12)\n'

: > "$TMP/case.txt"
verdicts brief-confirmed sk_brief --root "$FX/project" \
  --feature 004-appointment-booking --epic E-03
finish_case brief-confirmed

: > "$TMP/case.txt"
verdicts brief-proposed sk_brief --root "$FX/project" \
  --feature 005-specialist-availability-publishing --epic E-03
finish_case brief-proposed

: > "$TMP/case.txt"
verdicts brief-absent sk_brief --root "$FX/project" \
  --feature 004-appointment-booking --epic E-99
finish_case brief-absent

printf '\n▸ Scope H (contract §6, M rows)\n'

: > "$TMP/case.txt"
verdicts health-clean sk_health --root "$FX/project"
finish_case health-clean

: > "$TMP/case.txt"
verdicts health-gaps sk_health --root "$FX/negatives/health"
finish_case health-gaps

# ── 2. r5 reproduces gate run-2's M gaps verbatim ─────────────────────────────

printf '\n▸ Gate run-2 reproduction (contract §7 worked example, M-detectable set)\n'

r5_gaps() {
  python3 "$SK/sk_scan.py"     --root "$FX/project" --spec "$FX/revisions/spec-r5.md"
  python3 "$SK/sk_sections.py" --root "$FX/project" --spec "$FX/revisions/spec-r5.md"
  python3 "$SK/sk_idgraph.py"  --root "$FX/project" --spec "$FX/revisions/spec-r5.md" \
      --feature 004-appointment-booking
}
r5_gaps > "$TMP/r5.txt" 2>/dev/null

while IFS= read -r want; do
  if grep -Fqx "$want" "$TMP/r5.txt"; then
    ok "verbatim: ${want:0:58}…"
  else
    bad "r5 does not reproduce the corpus line verbatim:"
    printf '      want: %s\n' "$want"
  fi
done <<'GAPS'
CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target, or move the concern to an NFR with metric + condition.
CC-NF-02 FAIL — accessibility: no NFR and no N/A — <reason> → add one or declare N/A with a reason.
CC-TR-01 FAIL — US4: zero FRs reference it (story is unbuilt) → author its FRs or drop/demote the story.
GAPS

# every failure line meets the gate's own bar (gate §1 rule 2)
BADGRAM=$(grep -c 'FAIL' "$TMP/r5.txt" 2>/dev/null || true)
GOODGRAM=$(grep -cE '^CC-[A-Z]+-[0-9]+ FAIL — .+: .+ → .+$' "$TMP/r5.txt" 2>/dev/null || true)
if [ "$BADGRAM" = "$GOODGRAM" ]; then
  ok "all $GOODGRAM failure line(s) carry element + fix action"
else
  bad "some failure lines miss an element or a fix action ($GOODGRAM/$BADGRAM well-formed)"
fi

# ── 3. traceability generation (gate §8) ──────────────────────────────────────

printf '\n▸ traceability.md generation (gate §8)\n'

python3 "$SK/sk_idgraph.py" --root "$FX/project" --feature 004-appointment-booking \
  --run 3 --rev r6 --date 2026-07-18 --out "$TMP/traceability.md" >/dev/null 2>&1

check_line() {
  if grep -Eq "$1" "$TMP/traceability.md"; then ok "$2"; else bad "$2 — not found"; fi
}
check_line '^# Traceability — 004-appointment-booking$'                 "banner: feature"
check_line '^GENERATED at gate run 3 · spec r6 · 2026-07-18 · do not edit$' "banner: run · revision · date · do-not-edit"
check_line '^Provenance: .+ · delivery cycle 2026-07$'                  "banner: provenance + delivery cycle"
check_line '^\| FR \| Story \| Acceptance \| BR refs \| Brief link \|$' "table header (gate §8 shape)"
check_line '^\| FR-001 \| US1 \| US1/AC-1 .*US1/S-".+" \| — \| E-03 §8 / F1 \|$' "row: handles US<n>/AC-<i> and US<n>/S-\"…\", brief link"
check_line '^Reverse index: US1 → FR-001.* · US2 → .* · US3 → FR-009$'  "reverse index"
check_line '^Orphan check: none \(CC-TR-01 PASS, run 3\)$'              "orphan check"

# ── 4. snapshot machinery (gate §3 · §7.2 · §7.3 · §9.2 · §11.1) ─────────────

printf '\n▸ snapshot · re-run set · anchors (gate §3, §9.2, §7.2/§7.3, §11.1)\n'

R5="$TMP/w/r5"; R6="$TMP/w/r6"
mkdir -p "$TMP/w"
cp -R "$FX/project" "$R5"; cp -R "$FX/project" "$R6"
cp "$FX/revisions/spec-r5.md" "$R5/specs/004-appointment-booking/spec.md"
cp "$FX/revisions/roles-permissions-r5.md" "$R5/.specify/memory/roles-permissions.md"
S5="$R5/specs/004-appointment-booking/spec.md"
S6="$R6/specs/004-appointment-booking/spec.md"

python3 "$SK/sk_snapshot.py" build --root "$R5" --feature 004-appointment-booking \
  --epic E-03 --run 2 --date 2026-07-17 --out "$TMP/m5.json" --require-complete >/dev/null \
  && ok "snapshot build r5 — static core complete (gate §3)" \
  || bad "snapshot build r5 reported a missing static-core member"

python3 "$SK/sk_snapshot.py" build --root "$R6" --feature 004-appointment-booking \
  --epic E-03 --run 3 --date 2026-07-18 --out "$TMP/m6.json" --workspace "$TMP/ws6" \
  --require-complete >/dev/null \
  && ok "snapshot build r6 — static core complete, workspace copied" \
  || bad "snapshot build r6 reported a missing static-core member"

[ -f "$TMP/ws6/specs/004-appointment-booking/spec.md" ] \
  && ok "run workspace holds the snapshot the checkers read (gate §3)" \
  || bad "run workspace was not populated"

python3 "$SK/sk_snapshot.py" verify "$TMP/m6.json" --root "$R6" >/dev/null \
  && ok "verify: clean against the live files" \
  || bad "verify reported divergence on an unedited tree"

python3 "$SK/sk_snapshot.py" rerun-set --prev "$TMP/m5.json" --curr "$TMP/m6.json" \
  --prev-spec "$S5" --curr-spec "$S6" --format json \
  --non-clean "CC-XA-01,CC-G-04,CC-AC-04,CC-NF-02,CC-TR-01,CC-IN-03" > "$TMP/rerun.json"

python3 - "$TMP/rerun.json" <<'PY' > "$TMP/rerun.check"
import json, sys
d = json.load(open(sys.argv[1]))
# gate §14.2: the r5→r6 diff touches skeleton §§2, 3, 5, 9 + roles-permissions.md
print("sections", "ok" if d["changed_spec_sections"] == [2, 3, 5, 9] else
      "BAD %s" % d["changed_spec_sections"])
print("diff", "ok" if any("roles-permissions" in p for p in d["diff"])
      and any("spec.md" in p for p in d["diff"]) else "BAD %s" % d["diff"])
# gate §14.2's carried list, minus CC-FL-02 — which that paragraph's own
# "all 21 M" rule re-runs (flagged in BUILD-LOG S2 as a corpus erratum candidate)
want = ["CC-OV-01", "CC-OV-02", "CC-FL-01", "CC-FL-03", "CC-FL-04", "CC-FL-05",
        "CC-DA-01", "CC-DA-02", "CC-DA-03", "CC-DA-04", "CC-IN-01", "CC-IN-02"]
print("carried", "ok" if d["carried"] == want else "BAD %s" % d["carried"])
# all 21 Scope-F M assertions are always in the re-run set
ms = [a for a in d["rerun"] if a in {
    "CC-G-01","CC-G-03","CC-G-04","CC-US-01","CC-US-02","CC-US-03","CC-US-04",
    "CC-AC-01","CC-FR-01","CC-FR-02","CC-FR-05","CC-FL-02","CC-NF-02",
    "CC-BR-02","CC-OS-01","CC-TR-01","CC-TR-02","CC-TR-03","CC-TR-04",
    "CC-XA-02","CC-XA-05"}]
print("all-M", "ok" if len(ms) == 21 else "BAD %d of 21" % len(ms))
PY

while read -r label result; do
  [ "$result" = "ok" ] && ok "rerun-set: $label matches gate §14.2" \
                       || bad "rerun-set: $label — $result"
done < "$TMP/rerun.check"

# anchor-diff and verify exit non-zero *by design* when they find divergence,
# so their output is captured to a file before it is inspected — piping under
# `pipefail` would read the deliberate exit code as a harness failure.
anchor() {
  python3 "$SK/sk_snapshot.py" anchor-diff --prev "$TMP/m5.json" --curr "$TMP/m6.json" \
    --prev-spec "$S5" --curr-spec "$S6" --assertion "$1" --element "$2" --kind "$3" \
    --format json > "$TMP/anchor.json" 2>&1 || true
}
anchor CC-IN-03 "calendar sync" waiver
grep -q '"clean": true' "$TMP/anchor.json" \
  && ok "W-004-01 (CC-IN-03) anchor clean — survives to P5 re-affirmation (gate §14.3)" \
  || bad "W-004-01 anchor should be clean across r5→r6"

anchor CC-AC-04 "US2 acceptance" override
grep -q '"clean": true' "$TMP/anchor.json" \
  && ok "O-004-01 (CC-AC-04) auto re-applies — US2 acceptance byte-identical (gate §14.2)" \
  || bad "O-004-01 should auto re-apply: US2's acceptance block is unchanged"

anchor CC-AC-04 "US1 acceptance" override
grep -q '"clean": false' "$TMP/anchor.json" \
  && ok "an anchor over changed evidence (US1 acceptance) re-arms the checker" \
  || bad "a changed acceptance block must re-arm the checker"

grep -q '"granularity": "element"' "$TMP/anchor.json" \
  && ok "anchor diffing runs at element granularity (gate §7.3)" \
  || bad "anchor diffing fell back to section granularity"

printf 'x\n' >> "$S6"
python3 "$SK/sk_snapshot.py" verify "$TMP/m6.json" --root "$R6" > "$TMP/verify.txt" 2>&1 || true
grep -q 'REFUSED' "$TMP/verify.txt" \
  && ok "post-certification byte edit → verify REFUSES, naming the diverged path" \
  || bad "a post-certification edit must make verify refuse"
grep -q 'specs/004-appointment-booking/spec.md — content changed' "$TMP/verify.txt" \
  && ok "the refusal names the diverged path (gate §11.1 adapter precondition)" \
  || bad "the refusal must print the diverged path"

# ── 5. the coverage matrix — the S2 exit bar ─────────────────────────────────


# ── the silent-zero parser (S10 · field report 14 Aug 2026) ──────────────────
#
# The verdict tables above pin *which* verdicts fire. This section pins what the
# renders SAY, because the defect was never a wrong verdict — it was a true-
# sounding sentence about the project ("drafted 0/6", "section absent") standing
# in for a fact about the reader.

printf '\n▸ The silent-zero parser — tolerance, and the blind spot named (S10)\n'

# 1 · the two tolerated habits are read THROUGH
python3 - "$SK" "$FX/negatives/neg-shapes.md" <<'PYX' > "$TMP/shapes.txt"
import sys
sys.path.insert(0, sys.argv[1])
from pathlib import Path
from sk_structure import parse_spec, unparsed_report
s = parse_spec(Path(sys.argv[2]))
print("stories=%d wf=%d nfrs=%d rules=%d readable=%s"
      % (len(s.stories), sum(1 for x in s.stories if x.well_formed),
         len(s.nfrs), len(s.rules), s.readable))
print("frs=%d" % len(s.requirements))
print("report=%s" % unparsed_report(s, "Functional Requirements", "FR", s.requirements))
PYX

grep -q 'stories=3 wf=3 nfrs=2 rules=2 readable=True' "$TMP/shapes.txt" \
  && ok "numbered headings + bolded US IDs read through — content found, not zeroed" \
  || bad "the two standard-§2 tolerances do not read through: $(head -1 "$TMP/shapes.txt")"

# 2 · FR_RE is NOT widened — table FRs stay unparsed, by ruling
grep -q '^frs=0$' "$TMP/shapes.txt" \
  && ok "table-form FRs stay unparsed — FR_RE unwidened (standard §4 · golden rule 4)" \
  || bad "FR_RE appears widened: table rows must not parse as FRs"

# 3 · …but the zero is LOUD, never silent
grep -q 'report=section present, no parseable FR lines — 5 table row(s)' "$TMP/shapes.txt" \
  && ok "…and the zero is loud: 'present, no parseable FR lines, N table rows'" \
  || bad "a table-form §3 must report present-but-unparseable, never a bare 0"

python3 "$SK/sk_ears.py" --spec "$FX/negatives/neg-shapes.md" > "$TMP/ears.txt" 2>&1
grep -q 'no parseable FR lines' "$TMP/ears.txt" \
  && ok "CC-FR-01 renders the shape failure, not 'zero functional requirements'" \
  || bad "CC-FR-01 still renders a bare zero on a table-form §3"

# 4 · CC-G-01 still FAILs a numbered heading — tolerance is not a second form
python3 "$SK/sk_structure.py" --spec "$FX/negatives/neg-shapes.md" > "$TMP/g01.txt" 2>&1
grep -q "heading carries the §2 skeleton's ordinal" "$TMP/g01.txt" \
  && ok "CC-G-01 still fails a numbered heading — tolerance is a courtesy, not a legal form" \
  || bad "a numbered heading must still fail CC-G-01 (standard §2 reader-tolerance record)"
grep -q 'required heading absent' "$TMP/g01.txt" \
  && bad "a normalised heading must never also report as absent — that is the field's own bug" \
  || ok "…and never reports the same heading as absent as well"

# 5 · alien headings — found vs expected, never 'section absent'
python3 "$SK/sk_sections.py" --spec "$FX/negatives/neg-alien.md" > "$TMP/alien.txt" 2>&1
grep -q 'section not found under its standard heading' "$TMP/alien.txt" \
  && ok "sk_sections prints found-vs-expected for an unrecognised heading" \
  || bad "sk_sections must not treat an unrecognised heading as an absent section"
grep -q 'section absent' "$TMP/alien.txt" \
  && bad "'section absent' printed for a spec that plainly carries the section" \
  || ok "…and never prints 'section absent' when headings went unrecognised"
grep -q '"Background" (line 14)' "$TMP/alien.txt" \
  && ok "…naming the heading it actually found" \
  || bad "the found-vs-expected line must quote the heading as authored"

# 6 · no vacuous PASS anywhere on an unreadable spec
if grep -q 'PASS' "$TMP/alien.txt"; then
  bad "a PASS on an unreadable spec is a claim the reader cannot support"
else
  ok "no assertion PASSes on an unreadable spec — SKIPPED, blocked by CC-G-01"
fi
python3 "$SK/sk_scan.py" --spec "$FX/negatives/neg-alien.md" \
  --personas "$FX/negatives/personas.md" --root "$FX/project" > "$TMP/scan.txt" 2>&1
grep -q '0 banned words in 0 scanned lines' "$TMP/scan.txt" \
  && bad "CC-G-04 still passes having scanned nothing — the silent zero in green" \
  || ok "CC-G-04 does not pass on zero scanned lines"

printf '\n▸ Coverage — every M assertion, ≥ 1 seeded FAIL and ≥ 1 PASS\n'

python3 - "$ALL" <<'PY' > "$TMP/coverage.txt"
import sys
from collections import defaultdict

M = ["CC-G-01", "CC-G-03", "CC-G-04",
     "CC-US-01", "CC-US-02", "CC-US-03", "CC-US-04",
     "CC-AC-01", "CC-FR-01", "CC-FR-02", "CC-FR-05",
     "CC-FL-02", "CC-NF-02", "CC-BR-02", "CC-OS-01",
     "CC-TR-01", "CC-TR-02", "CC-TR-03", "CC-TR-04",
     "CC-XA-02", "CC-XA-05",
     "CC-H-02", "CC-H-03", "CC-H-06"]

seen = defaultdict(set)
for line in open(sys.argv[1]):
    line = line.strip()
    if not line:
        continue
    aid, verdict = line.split("|")
    seen[aid].add(verdict)

gaps = 0
for aid in M:
    v = seen.get(aid, set())
    marks = ("PASS" in v, "FAIL" in v)
    if all(marks):
        print("ok      %s  PASS ✓  FAIL ✓" % aid)
    else:
        gaps += 1
        print("GAP     %s  PASS %s  FAIL %s" % (
            aid, "✓" if marks[0] else "—", "✓" if marks[1] else "—"))
print("TOTAL %d of %d M assertions exercised both ways" % (len(M) - gaps, len(M)))
unknown = sorted(set(seen) - set(M))
if unknown:
    print("NOTE  verdicts also observed for non-M assertions: %s" % ", ".join(unknown))
PY

while read -r st aid rest; do
  if [ "$st" = "GAP" ]; then
    printf '  ✗ %s %s\n' "$aid" "$rest"
  elif [ "$VERBOSE" -eq 1 ]; then
    printf '  ✓ %s %s\n' "$aid" "$rest"
  fi
done < <(grep -E '^(ok|GAP)' "$TMP/coverage.txt")
COVERLINE=$(grep '^TOTAL' "$TMP/coverage.txt")
COVERED=$(printf '%s' "$COVERLINE" | awk '{print $2}')
if [ "$COVERED" = "24" ]; then
  PASSED=$((PASSED+1)); printf '  ✓ %s\n' "$COVERLINE"
else
  FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$COVERLINE"
fi

printf '\n  passed: %d   failed: %d\n' "$PASSED" "$FAILED"
if [ "$RECORD" -eq 1 ]; then
  printf '  (record mode — expected-verdict tables rewritten)\n\n'
  exit 0
fi
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S2 M machinery + fixtures\n\n'; exit 0
fi
printf '✗ RED — %d check(s) failed\n\n' "$FAILED"; exit 1
