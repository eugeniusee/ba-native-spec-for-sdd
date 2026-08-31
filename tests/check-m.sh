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
#     It is also the D139 case: the spec is READABLE and only its §3 is not,
#     so CC-FR-02/05 render SKIPPED rather than a vacuous 0/0 PASS.
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

# ── CC-H-08 — the EC-22 world, both boundaries (contract v0.5 §6) ────────────
#
# Fixture A is `tests/fixtures/qr-boundary/` as it stands: `Boundary: MVP +
# Phase 2`, 14 roadmap epics, E-10 and E-11 inside the boundary and unbriefed.
# Fixture B is the SAME estate with the head's `Boundary:` line reading `MVP`
# alone — built here by copy, so "same estate" is literally true.

QRA="$HERE/fixtures/qr-boundary"
QRB="$TMP/qr-boundary-mvp"
mkdir -p "$QRB"
cp -R "$QRA/." "$QRB/"
python3 - "$QRB/.specify/aspect-state.md" <<'PYX'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); t = p.read_text(encoding="utf-8")
old = "Boundary: MVP + Phase 2 — set 2026-08-28 (P-O0b)"
assert t.count(old) == 1, t.count(old)
p.write_text(t.replace(old, "Boundary: MVP — set 2026-08-28 (P-O0b)", 1),
             encoding="utf-8")
PYX

: > "$TMP/case.txt"
verdicts health-boundary sk_health --root "$QRA"
finish_case health-boundary

: > "$TMP/case.txt"
verdicts health-boundary-mvp sk_health --root "$QRB"
finish_case health-boundary-mvp

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

# ── the near-miss and its supersession key (gate §10.4 · build-log D181) ─────
#
# Field defect, 16 Aug 2026: a T-18 run under a standing AG wrote its allocation
# heading in ledger stamp grammar. Orchestrator D-O58 made the dashboard's
# readers name it; the H layer had no class for it at all. Option (c), ruled
# 17 Aug 2026: the class is keyed on SUPERSESSION, in log order.

printf '\n▸ The near-miss — live while unsuperseded, settled once an entry follows (gate §10.4)\n'

NMR="$TMP/nm-roadmap"
mkdir -p "$NMR/.specify/memory"
cp -R "$FX/project/.specify/memory/." "$NMR/.specify/memory/"
ROADMAP="$NMR/.specify/memory/roadmap.md"

# The last well-formed entry, rewritten into the grammar the field produced.
# Nothing well-formed follows it, so it is LIVE.
python3 - "$ROADMAP" <<'PYX'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); t = p.read_text(encoding="utf-8")
old = "### Allocation 2 — 2026-07-15 · trigger: post-ingestion E-03 · BA: Y.K."
assert t.count(old) == 1, t.count(old)
p.write_text(t.replace(old, "### 2026-07-15 · AUTO (AG-1) · scope allocation · post-ingestion E-03"),
             encoding="utf-8")
PYX

python3 "$SK/sk_health.py" --root "$NMR" > "$TMP/nm-live.txt" 2>&1
NM_LIVE_RC=$?

grep -q 'CC-H-02 FAIL .*does not parse as an allocation entry' "$TMP/nm-live.txt" \
  && ok "a live near-miss is a full CC-H-02 finding — it counts in the gaps" \
  || bad "a live near-miss did not render as a CC-H-02 gap: $(grep CC-H-02 "$TMP/nm-live.txt" | head -1)"
grep -q 'supersede it with a correctly-shaped entry' "$TMP/nm-live.txt" \
  && ok "…and its fix is the log's own law — supersede" \
  || bad "the live finding does not prescribe supersession"
grep -q 'the log is append-only and is never edited' "$TMP/nm-live.txt" \
  && ok "…never edit: the append-only law is stated in the fix itself" \
  || bad "the live finding does not forbid editing the entry"
[ "$NM_LIVE_RC" -ne 0 ] \
  && ok "…and it blocks — a live near-miss is an unresolved H gap" \
  || bad "a live near-miss did not block: rc=$NM_LIVE_RC"
grep -q 'no allocation entries' "$TMP/nm-live.txt" \
  && bad "'no allocation entries' fired beside a near-miss — the fix aims at T-18, not at the line" \
  || ok "…and 'no allocation entries' does NOT fire: the near-miss is the true report"

# The corrective append the log's own law prescribes. The SAME near-miss now
# has a well-formed entry after it, so it flips to SETTLED.
cat >> "$ROADMAP" <<'EOF'

### Allocation 3 — 2026-08-17 · trigger: BA-directed · BA: Y.K.

| Epic | Phase | Reason |
|---|---|---|
| E-07 Online Payment | Phase 2 → Later | value vs. effort: the corrective append |

Held: seven rows · Basis: the append the log's own law prescribes.
EOF

python3 "$SK/sk_health.py" --root "$NMR" > "$TMP/nm-settled.txt" 2>&1
NM_SETTLED_RC=$?

grep -q 'CC-H-02 PASS' "$TMP/nm-settled.txt" \
  && ok "the appended entry clears the gap — the repair is always legal" \
  || bad "the corrective append did not clear CC-H-02: $(grep CC-H-02 "$TMP/nm-settled.txt" | head -1)"
[ "$NM_SETTLED_RC" -eq 0 ] \
  && ok "…the settled near-miss blocks nothing — it left the gap count" \
  || bad "a settled near-miss still blocks: rc=$NM_SETTLED_RC"
grep -q 'CC-H-02 NOTE .*superseded-by Allocation 3' "$TMP/nm-settled.txt" \
  && ok "…and it is still NAMED, with its superseded-by — settled history is never silenced" \
  || bad "the settled near-miss was silenced: no note names it"
grep -q 'CC-H-02 NOTE .*heading "### 2026-07-15 · AUTO (AG-1)' "$TMP/nm-settled.txt" \
  && ok "…quoting the line as authored" \
  || bad "the settled note does not quote the offending line as authored"
grep -q 'CC-H-02 FAIL' "$TMP/nm-settled.txt" \
  && bad "a settled near-miss is still counted as a gap" \
  || ok "…and no gap remains: named is not counted"

# The reason the note is a channel of its own and not an `evidence` string:
# a second, unsuperseded near-miss makes the assertion FAIL, and the settled
# one must survive that render. Evidence never prints on FAIL.
cat >> "$ROADMAP" <<'EOF'

### 2026-08-17 · AUTO (AG-2) · scope allocation · scope-frame
no change — the frame is unchanged.
EOF
python3 "$SK/sk_health.py" --root "$NMR" > "$TMP/nm-both.txt" 2>&1

grep -q 'CC-H-02 FAIL .*AUTO (AG-2)' "$TMP/nm-both.txt" \
  && ok "a later unsuperseded near-miss is live — supersession is keyed in log order" \
  || bad "the trailing near-miss did not render live"
grep -q 'CC-H-02 NOTE .*superseded-by Allocation 3' "$TMP/nm-both.txt" \
  && ok "…and the settled note survives the FAIL — the invisible-record defect, closed" \
  || bad "the settled note vanished under a FAIL: notes must render on both verdicts"

# ── 7 · the same law one grain down: the section (D139 · gate §5.1) ──────────
#
# neg-shapes is READABLE — only its §3 is not. `blocked_on_unreadable` cannot
# fire, and the assertions that merely count parsed FRs used to render two
# greens beside CC-FR-01's red about the same section.

grep -q '^CC-FR-02 SKIPPED' "$TMP/ears.txt" && grep -q '^CC-FR-05 SKIPPED' "$TMP/ears.txt" \
  && ok "CC-FR-02/05 SKIP on a readable spec whose §3 did not parse — no vacuous 0/0 PASS" \
  || bad "a 0/0 PASS survives on a table-form §3: $(grep -c PASS "$TMP/ears.txt") PASS line(s)"
grep -q 'CC-FR-02 SKIPPED — blocked by CC-FR-01 — §3 Functional Requirements: section present, no parseable FR lines' "$TMP/ears.txt" \
  && ok "…and the skip names its blocker: CC-FR-01 + the found-vs-expected shape line" \
  || bad "a section-grain skip must name the parse gap that blocks it (gate §5.1)"
grep -qE '^CC-FR-0[25] PASS' "$TMP/ears.txt" \
  && bad "CC-FR-02/05 must never PASS counting FRs the reader could not read" \
  || ok "…and neither renders a count it did not measure"

# the generated artifact carries the same verdict, so it takes the same law
python3 "$SK/sk_idgraph.py" --root "$FX/project" --feature 004-appointment-booking \
  --spec "$FX/negatives/neg-alien.md" --print-candidate > "$TMP/cand.txt" 2>&1
grep -q 'Orphan check: none (CC-TR-01 PASS' "$TMP/cand.txt" \
  && bad "traceability.md writes 'CC-TR-01 PASS' out of a zero the reader produced" \
  || ok "the generated traceability.md never records a PASS the verdict set skipped"

# the two boundaries of the rule, at the parse layer where the signal lives
python3 - "$SK" "$TMP" <<'PYX' > "$TMP/grain.txt"
import sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
tmp = Path(sys.argv[2])
from sk_structure import parse_spec, unparsed_blocker

empty = tmp / "empty-br.md"
empty.write_text("## Business Rules\n\nNone for this feature.\n", encoding="utf-8")
print("empty=[%s]" % unparsed_blocker(parse_spec(empty), "Business Rules"))

rows = tmp / "rows-br.md"
rows.write_text("## Business Rules\n\n| ID | Rule |\n|---|---|\n"
                "| BR-001 | A Client may hold at most 3 Appointments. |\n",
                encoding="utf-8")
print("rows=[%s]" % unparsed_blocker(parse_spec(rows), "Business Rules"))
PYX

grep -q '^empty=\[\]$' "$TMP/grain.txt" \
  && ok "a present, read and genuinely empty section keeps its zero — that one is a measurement" \
  || bad "an empty section must not be downgraded: $(grep '^empty=' "$TMP/grain.txt")"
grep -q '^rows=\[§6 Business Rules: section present, no parseable BR lines' "$TMP/grain.txt" \
  && ok "…and where the M set carries no assertion that fails on the shape, the gap line is the blocker" \
  || bad "the §6 blocker must be the gap line itself: $(grep '^rows=' "$TMP/grain.txt")"

# ── CC-H-08 — boundary coverage (contract v0.5 §6 · gate v0.14 §10.4) ───────
#
# EC-22, 31 Aug 2026: under `Boundary: MVP + Phase 2` the Tier-1 election
# briefed the first phase only, and NO assertion anywhere compared the
# roadmap's in-boundary rows to the brief set. Two epics — both billable, both
# billable line items — went unbriefed for three days behind a green
# health run and a WBS reporting `Included 41 · excluded none`.
#
# `$QRA` / `$QRB` are Fixture A and Fixture B, built above.

printf '\n▸ CC-H-08 — the boundary set, both boundaries (EC-22)\n'

python3 "$SK/sk_health.py" --root "$QRA" > "$TMP/h08-a.txt" 2>&1
H08A_RC=$?

for want in \
  'CC-H-08 FAIL — E-10 Public API & Bulk Generation — Phase 2 · Billable Yes: no scope brief' \
  'CC-H-08 FAIL — E-11 Premium Redirect Features — Phase 2 · Billable Yes: no scope brief'
do
  grep -Fq "$want" "$TMP/h08-a.txt" \
    && ok "named with its phase and its Billable value: ${want:18:44}…" \
    || bad "the gap line is not the pinned one — wanted: $want"
done

N08=$(grep -c '^CC-H-08 FAIL' "$TMP/h08-a.txt")
[ "$N08" = "2" ] \
  && ok "…and exactly 2 — element grain is the epic, one line each" \
  || bad "expected 2 CC-H-08 gap lines, got $N08"

grep -Fq 'run Tier 1 — epic scoping in ingest mode' "$TMP/h08-a.txt" \
  && ok "…each naming its fix action — a fix-less line is invalid gate output (contract §7)" \
  || bad "the CC-H-08 gap line names no fix action"

# counts in `n gaps`, blocks nothing: the OTHER three assertions still PASS on
# the same run. A CC-H-08 gap is a health finding about the roadmap ⇄ brief-set
# join, and that join sits in no feature's deps(F) — it never gates admission.
for a in CC-H-02 CC-H-03 CC-H-06; do
  grep -q "^$a PASS" "$TMP/h08-a.txt" \
    && ok "…$a still PASSes beside it — the gap is counted, never contagious" \
    || bad "$a did not pass on the boundary fixture: $(grep "^$a" "$TMP/h08-a.txt" | head -1)"
done
[ "$H08A_RC" -ne 0 ] \
  && ok "…and the run is not clean: a live CC-H-08 gap counts in \`n gaps\`" \
  || bad "a live CC-H-08 gap left the run clean: rc=$H08A_RC"

# Fixture B — the same estate under a single-phase boundary. The regression the
# field note demands: the election's set is byte-identical to the pre-fix one.
python3 "$SK/sk_health.py" --root "$QRB" > "$TMP/h08-b.txt" 2>&1
H08B_RC=$?
grep -q '^CC-H-08 PASS — 12 in-boundary epic(s), each with a scope brief' "$TMP/h08-b.txt" \
  && ok "Boundary: MVP — 12 in-boundary epics, each briefed" \
  || bad "the single-phase boundary did not pass: $(grep CC-H-08 "$TMP/h08-b.txt" | head -1)"
[ "$H08B_RC" -eq 0 ] && ok "…and the run is clean" \
                     || bad "the MVP-only estate did not run clean: rc=$H08B_RC"

# the byte-identity itself, at the set the election iterates
python3 - "$SK" "$QRB" <<'PYX' > "$TMP/h08-set.txt" 2>&1
import sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
from sk_health import boundary_coverage
from sk_wbs import read_roadmap_at
root = Path(sys.argv[2])
rm = root / ".specify" / "memory" / "roadmap.md"
in_boundary, _ = boundary_coverage(rm, root / ".specify" / "memory" / "scope", root)
order, _names, phases = read_roadmap_at(rm)
first = [e for e in order if phases.get(e) == phases.get(order[0])]
print("boundary=%s" % " ".join(e for e, _n, _p in in_boundary))
print("firstphase=%s" % " ".join(first))
print("identical=%s" % ([e for e, _n, _p in in_boundary] == first))
PYX
grep -q '^identical=True$' "$TMP/h08-set.txt" \
  && ok "…and under a single-phase boundary the set IS the first-phase set — byte-identical" \
  || { bad "the single-phase election is not byte-identical to the pre-fix one"; \
       sed 's/^/      /' "$TMP/h08-set.txt"; }

# vacuous, never a gap: no boundary in the frame, and no roadmap at all
VAC="$TMP/qr-no-boundary"
mkdir -p "$VAC"
cp -R "$QRA/." "$VAC/"
python3 - "$VAC/.specify/aspect-state.md" <<'PYX'
import pathlib, re, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text(encoding="utf-8")
p.write_text(re.sub(r"^Boundary:.*\n", "", t, count=1, flags=re.M), encoding="utf-8")
PYX
python3 "$SK/sk_health.py" --root "$VAC" > "$TMP/h08-vac.txt" 2>&1
grep -q '^CC-H-08 PASS — — no roadmap or no boundary in the frame' "$TMP/h08-vac.txt" \
  && ok "no boundary in the frame: the dash, never a gap — the absent-source law" \
  || bad "a boundary-less frame did not render vacuous: $(grep CC-H-08 "$TMP/h08-vac.txt" | head -1)"
grep -q '^CC-H-08 FAIL' "$TMP/h08-vac.txt" \
  && bad "a boundary-less frame produced a CC-H-08 gap — the check has no ground there" \
  || ok "…and no gap: an absent source is never a finding"

rm -f "$VAC/.specify/memory/roadmap.md"
python3 "$SK/sk_health.py" --root "$VAC" > "$TMP/h08-noroad.txt" 2>&1
grep -q '^CC-H-08 PASS' "$TMP/h08-noroad.txt" \
  && ok "pre-decomposition — no roadmap: vacuous by construction, as at the arming run" \
  || bad "the pre-decomposition state produced a CC-H-08 verdict other than PASS"

# a blank Phase sits outside the set exactly as its Billable cell sits blank
BLANK="$TMP/qr-blank-phase"
mkdir -p "$BLANK"
cp -R "$QRA/." "$BLANK/"
python3 - "$BLANK/.specify/memory/roadmap.md" <<'PYX'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); t = p.read_text(encoding="utf-8")
old = "| E-10 | Public API & Bulk Generation | The public api & bulk generation capability — a fixture row, invented for this estate. | Phase 2 |"
new = "| E-10 | Public API & Bulk Generation | The public api & bulk generation capability — a fixture row, invented for this estate. |  |"
assert t.count(old) == 1, t.count(old)
p.write_text(t.replace(old, new, 1), encoding="utf-8")
PYX
python3 "$SK/sk_health.py" --root "$BLANK" > "$TMP/h08-blank.txt" 2>&1
grep -q 'CC-H-08 FAIL — E-10' "$TMP/h08-blank.txt" \
  && bad "a blank-Phase row entered the set — an absent source is never a guess" \
  || ok "a blank Phase sits outside the set, as its Billable cell sits blank"
grep -q 'CC-H-08 FAIL — E-11' "$TMP/h08-blank.txt" \
  && ok "…and its billable sibling is still named: the row left, the rule did not" \
  || bad "E-11 vanished with E-10 — the blank-Phase rule took the whole set"

# the deleted-brief cause the scoped-run trigger exists for (gate §10.2)
DEL="$TMP/qr-deleted-brief"
mkdir -p "$DEL"
cp -R "$QRB/." "$DEL/"
rm -f "$DEL/.specify/memory/scope/E-01.md"
python3 "$SK/sk_health.py" --root "$DEL" > "$TMP/h08-del.txt" 2>&1
grep -Fq 'CC-H-08 FAIL — E-01 QR Code Generation — MVP · Billable Yes: no scope brief' "$TMP/h08-del.txt" \
  && ok "a deleted brief surfaces at boundary grain — the scoped run's own cause" \
  || bad "a deleted in-boundary brief did not surface: $(grep CC-H-08 "$TMP/h08-del.txt" | head -1)"

# CC-H-03 is subset-blind by construction and stands untouched: every roadmap
# row here is `Defined`, so no epic has entered Band 3 and CC-H-03 has nothing
# to say — which is exactly how the field defect stayed invisible to it.
grep -q '^CC-H-03 PASS — 0 Band-3 epic(s)' "$TMP/h08-a.txt" \
  && ok "CC-H-03 sees nothing here — subset-blind by construction, not broken" \
  || bad "CC-H-03's verdict on the boundary fixture is not the vacuous one"

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
     "CC-H-02", "CC-H-03", "CC-H-06", "CC-H-08"]

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
if [ "$COVERED" = "25" ]; then
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
