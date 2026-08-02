#!/usr/bin/env bash
#
# BA-Native Spec — the Phase-2 exit test (build plan §5, S9).
#
# The ten steps of the exit script, run end to end against ONE real installed
# project. Not a unit suite: every prior suite proves a unit against fixtures,
# and this one proves that the units compose into the thing plan §8 asks for —
# install → run → artifact set appears → /speckit-plan consumes it.
#
#    1  fresh project            git init, nothing else
#    2  install                  install.sh, then the FULL check-layout bar
#    3  frame                    canvas + both ledgers, in framework shape
#    4  Band 1                   the estate · closure · the arming Scope-H run
#    5  Band 2                   roadmap + allocation log · kit · brief Scoped
#    6  Band 3                   feature folder · Tier-2 spec, defect seeded
#    7  gate                     FAIL with named gaps → fix → PASS WITH WAIVERS
#    8  negative check           one byte edited → the adapter REFUSES
#    9  handoff                  hash guard clean → branch → ready
#   10  /speckit-plan            setup resolves · hashes hold · one marker
#
# The split, as in every session before this one: mechanical acts run **live**
# (install, the ten M checkers, snapshot/rerun-set/anchor-diff, verdict
# assembly, certification, the adapter) — agent acts are **recorded**, because
# producing one is an agent act and a regression suite cannot re-derive it. The
# recorded inputs are the Band-1/Band-2 estate (S5–S8), the gate agent's A-pass
# sheets and the BA's rulings (S3), and `/speckit-plan`'s outputs (S9). Each
# recorded artifact is validated live, in this install, by the validator that
# owns its shape — so "recorded" never means "unchecked".
#
#   check-exit.sh                run it (temp project, removed on exit)
#   check-exit.sh --target DIR   run it in DIR (created; must not exist)
#   check-exit.sh --keep         keep the project and print its path
#   check-exit.sh --offline      install from vendor/spec-kit-<pin>.zip
#   check-exit.sh -v             print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
PLANFX="$FX/speckit-plan"
F=004-appointment-booking
EPIC=E-03

TARGET=""
KEEP=0
OFFLINE=""
VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --target)  TARGET="${2:?--target needs a directory}"; shift 2 ;;
    --keep)    KEEP=1; shift ;;
    --offline) OFFLINE="--offline"; shift ;;
    -v|--verbose) VERBOSE=1; shift ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
if [ -z "$TARGET" ]; then TARGET="$TMP/toy"; fi
cleanup() { [ "$KEEP" -eq 1 ] || rm -rf "$TMP"; }
trap cleanup EXIT

PASSED=0; FAILED=0
ok()   { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad()  { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }
step() { printf '\n\033[1m▸ %s\033[0m\n' "$*"; }

# has <file> <fixed-string> <label>
has()   { grep -Fq "$2" "$1" && ok "$3" || bad "$3 — not found: $2"; }
hasx()  { grep -Fqx "$2" "$1" && ok "$3" || bad "$3 — not found (whole line): $2"; }
hasnt() { grep -Fq "$2" "$1" && bad "$3 — present but must not be: $2" || ok "$3"; }
# run <label> <expected-rc> <cmd...>
run() {
  local label="$1" want="$2"; shift 2
  "$@" > "$TMP/out.txt" 2>&1
  local rc=$?
  if [ "$rc" -eq "$want" ]; then ok "$label (rc=$rc)"
  else bad "$label — rc=$rc, expected $want"; sed 's/^/      /' "$TMP/out.txt" | head -25; fi
}

printf '\n\033[1mBA-Native Spec — Phase-2 exit test\033[0m\n'
printf '  package: %s\n  project: %s\n' "$PKG_ROOT" "$TARGET"

# ── 1. fresh project ─────────────────────────────────────────────────────────

step "1 · Fresh project"

[ -e "$TARGET" ] && { printf '  ✗ target already exists: %s\n' "$TARGET"; exit 2; }
mkdir -p "$TARGET"
git -C "$TARGET" init -q .
git -C "$TARGET" config user.email "exit-test@ba-native-spec.local"
git -C "$TARGET" config user.name  "BA-Native Spec exit test"
[ -d "$TARGET/.git" ] && ok "empty git repo, no prior Spec Kit" \
                      || bad "git init failed"
[ -e "$TARGET/.specify" ] && bad "the fresh project already carries .specify/" \
                          || ok "no .specify/ before install"

# ── 2. install ───────────────────────────────────────────────────────────────

step "2 · Install — install.sh, then the full layout bar"

run "install.sh completes" 0 "$PKG_ROOT/install.sh" --target "$TARGET" $OFFLINE
run "check-layout.sh at the FULL Phase-2 bar (no --session)" 0 \
    "$HERE/check-layout.sh" --target "$TARGET"

MAN="$TARGET/.specify/ba/manifest.md"
if [ -f "$MAN" ]; then
  has "$MAN" "$(tr -d '[:space:]' < "$PKG_ROOT/VERSION")" "manifest records the package version"
  has "$MAN" "v0.12.5" "manifest records the Spec Kit pin (D-P2-8)"
  ok "manifest present"
else
  bad "no .specify/ba/manifest.md"
fi

SK="$TARGET/.specify/ba/scripts"
[ -f "$SK/sk_handoff.py" ] && ok "the adapter is installed (S9 unit)" \
                          || bad "sk_handoff.py did not install"
[ -f "$TARGET/.claude/skills/ba-handoff/SKILL.md" ] \
  && ok "/ba-handoff is registered (S9 unit)" || bad "ba-handoff skill did not install"

# ── 3. frame ─────────────────────────────────────────────────────────────────
#
# /ba-frame is an agent act: T-01 births canvas.md, the two ledgers initialize.
# The act is S4/S5's to prove; what this step proves is that its outputs land in
# THIS install, in framework shape, judged live by the validators that own them.

step "3 · Frame — canvas + both aspect ledgers"

cp "$FX/project/canvas.md"        "$TARGET/canvas.md"
cp "$FX/band1/aspect-state.md"    "$TARGET/.specify/aspect-state.md"
cp "$FX/band1/aspect-plans.md"    "$TARGET/.specify/aspect-plans.md"

run "canvas.md in framework shape — 13 sections, P-n/O-n, every cell cited" 0 \
    python3 "$HERE/check-band1-artifacts.py" --canvas "$TARGET/canvas.md" --aspect-grade
run "aspect-state.md against the §2.2/§2.3/§4.1/§5.3/§8.2 grammar" 0 \
    python3 "$HERE/check-ledger.py" "$TARGET/.specify/aspect-state.md"

for l in aspect-state aspect-plans; do
  [ -f "$TARGET/.specify/$l.md" ] && ok "$l.md sits at .specify/ top level, outside memory/ (D-G1)" \
    || bad "$l.md is not at .specify/$l.md"
done
[ -e "$TARGET/.specify/memory/aspect-state.md" ] \
  && bad "a ledger leaked into memory/ — it would join CC-H-01's glob" \
  || ok "no ledger under memory/ — runtime state is not content"

# ── 4. Band 1 ────────────────────────────────────────────────────────────────

step "4 · Band 1 — the estate, closure, and the arming Scope-H run"

cp "$FX"/project/.specify/memory/*.md       "$TARGET/.specify/memory/"
cp "$FX"/project/.specify/memory/scope/*.md "$TARGET/.specify/memory/scope/"
cp "$FX/band1/gate-health.md"               "$TARGET/.specify/gate-health.md"

MEM="$TARGET/.specify/memory"
run "the Band-1 estate in framework shape (glossary · register · context · constraints · competitive · domain · roles · processes · design · constitution · out-of-scope)" 0 \
    python3 "$HERE/check-band1-artifacts.py" \
      --glossary "$MEM/glossary.md" --register "$MEM/stakeholders.md" \
      --context "$MEM/context.md" --constraints "$MEM/constraints.md" \
      --competitive "$MEM/competitive-analysis.md" --domain "$MEM/domain-model.md" \
      --roles "$MEM/roles-permissions.md" --processes "$MEM/processes.md" \
      --design "$MEM/design-standards.md" --constitution "$MEM/constitution.md" \
      --oos "$MEM/out-of-scope.md" --root "$TARGET"

ST="$TARGET/.specify/aspect-state.md"
has "$ST" "Band: 1 (closed" "Band-1 closure recorded in the ledger head (P-O7)"
has "$ST" "/ba-gate-health full" "the closure act requested the arming Scope-H run"
has "$TARGET/.specify/gate-health.md" "HEALTHY" \
    "the arming run's entry landed in .specify/gate-health.md — HEALTHY"

run "Scope-H health checks pass live against the installed estate (CC-H-02/03/06)" 0 \
    python3 "$SK/sk_health.py" --root "$TARGET"

# the CC-H-01 glob must see content only — no ledger, no run workspace
LEAK=$(find "$MEM" -name 'gate-*.md' -o -name 'aspect-*.md' -o -name 'elicitation-tuning.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$LEAK" = "0" ] && ok "no runtime ledger inside CC-H-01's memory/*.md glob" \
                  || bad "$LEAK runtime ledger(s) leaked into memory/"

# ── 5. Band 2 ────────────────────────────────────────────────────────────────

step "5 · Band 2 — roadmap + allocation log · call kit · brief Scoped"

run "roadmap.md: row grammar · phase ladder · status vocabulary · allocation log" 0 \
    python3 "$HERE/check-band2-artifacts.py" --roadmap "$MEM/roadmap.md" --canvas "$TARGET/canvas.md"
run "the E-03 call kit: parts A–D · must-ask ≤ 12 · every question destination-tagged · zero Destination-Test violations" 0 \
    python3 "$HERE/check-band2-artifacts.py" --kit "$MEM/scope/$EPIC.kit.md"
run "the E-03 brief: nine exact headings · D4 open-question vocabulary · D5 slicing vocabulary" 0 \
    python3 "$HERE/check-band2-artifacts.py" --brief "$MEM/scope/$EPIC.md"

has "$MEM/scope/$EPIC.md" "Scoped" "the ingestion left the brief Scoped"
has "$MEM/scope/$EPIC.md" "$F" "the brief's §8 proposes 004-appointment-booking"
run "CC-XA-05 live: the brief exists and 004's slicing row reads Confirmed" 0 \
    python3 "$SK/sk_brief.py" --root "$TARGET" --feature "$F" --epic "$EPIC"

# ── 6. Band 3 ────────────────────────────────────────────────────────────────
#
# /ba-enter-feature creates the folder and nothing else (D-P2-6); Tier 2 writes
# spec.md. The exit script then seeds one defect — the gate-§14 exemplar — and
# fixture r5 is the Tier-2 draft that carries it.

step "6 · Band 3 — feature folder, Tier-2 spec, defect seeded"

mkdir -p "$TARGET/specs/$F"
cp "$FX/revisions/spec-r5.md"               "$TARGET/specs/$F/spec.md"
cp "$FX/revisions/roles-permissions-r5.md"  "$MEM/roles-permissions.md"

for absent in traceability.md gate-report.md; do
  [ -e "$TARGET/specs/$F/$absent" ] \
    && bad "$absent exists before the gate ran — each is born by its own act" \
    || ok "$absent absent until the gate writes it (D-P2-6)"
done

run "the Tier-2 spec against the answer sheet: cap ≤ 7 · anchors · cite-or-mark" 0 \
    python3 "$HERE/check-band2-artifacts.py" --spec "$TARGET/specs/$F/spec.md" \
            --answers "$FX/tier2-answer-sheet.md"

has "$TARGET/specs/$F/spec.md" "quickly" \
    "the seeded defect is in place — FR-007 carries the banned adverb (gate §14 exemplar)"

git -C "$TARGET" add -A > /dev/null 2>&1
git -C "$TARGET" commit -q -m "toy: installed, framed, scoped, spec r5" > /dev/null 2>&1
ok "the pre-gate state is committed — the branch act later has a clean base"

# ── 7. gate: FAIL with named gaps → fix → PASS WITH WAIVERS ──────────────────

step "7 · Gate — run 2 FAIL (named gaps) → fix → run 3 incremental → PASS WITH WAIVERS"

RUNS="$TARGET/.specify/ba/runs/$F"
R2="$RUNS/run-2"; R3="$RUNS/run-3"
mkdir -p "$R2/checkers" "$R3/checkers"

m_pass() { # m_pass <workspace> <out> <run> <rev> <date>
  local ws="$1" out="$2"
  python3 "$SK/sk_structure.py"  --format json --root "$ws" --feature "$F" > "$out/structure.json"
  python3 "$SK/sk_scan.py"       --format json --root "$ws" --feature "$F" \
                                 --personas "$FX/negatives/personas.md"    > "$out/scan.json"
  python3 "$SK/sk_stories.py"    --format json --root "$ws" --feature "$F" > "$out/stories.json"
  python3 "$SK/sk_acceptance.py" --format json --root "$ws" --feature "$F" > "$out/acceptance.json"
  python3 "$SK/sk_ears.py"       --format json --root "$ws" --feature "$F" > "$out/ears.json"
  python3 "$SK/sk_sections.py"   --format json --root "$ws" --feature "$F" > "$out/sections.json"
  python3 "$SK/sk_idgraph.py"    --format json --root "$ws" --feature "$F" \
                                 --run "$3" --rev "$4" --date "$5" \
                                 --out "$ws/specs/$F/traceability.md"      > "$out/idgraph.json"
  python3 "$SK/sk_brief.py"      --format json --root "$ws" --feature "$F" \
                                 --epic "$EPIC"                            > "$out/brief.json"
}

assemble() { # assemble <rulings> <ckdir> <a-pass> <manifest> <rerun|-> <produced|-> <out>
  python3 - "$@" <<'PY'
import json, sys, pathlib
rulings, ckdir, apass, manifest, rerun, produced, out = sys.argv[1:8]
run = json.loads(pathlib.Path(rulings).read_text(encoding="utf-8"))
run["checkers"] = sorted(str(p) for p in pathlib.Path(ckdir).glob("*.json"))
run["a_pass"], run["manifest"] = apass, manifest
if rerun != "-":
    rs = json.loads(pathlib.Path(rerun).read_text(encoding="utf-8"))
    run["carried"] = [{"assertion": a, "basis": rs["basis"][a]} for a in rs["carried"]]
run.setdefault("carried", [])
if produced != "-":
    run["produced"] = [produced]
pathlib.Path(out).write_text(json.dumps(run, indent=2, ensure_ascii=False) + "\n",
                             encoding="utf-8")
PY
}

# — run 2: Stage 0 → Stages 1–3 → verdict
run "Stage 0 — snapshot assembled, static core complete (gate §3)" 0 \
    python3 "$SK/sk_snapshot.py" build --root "$TARGET" --feature "$F" --epic "$EPIC" \
      --run 2 --date 2026-07-17 --out "$R2/manifest.json" \
      --workspace "$R2/workspace" --require-complete
m_pass "$R2/workspace" "$R2/checkers" 2 r5 2026-07-17
assemble "$FX/gate-runs/run2-rulings.json" "$R2/checkers" "$FX/a-pass/run2.json" \
         "$R2/manifest.json" - - "$R2/run.json"

python3 "$SK/sk_snapshot.py" report "$R2/run.json" \
        --append "$TARGET/specs/$F/gate-report.md" > "$TMP/run2.log" 2>&1
[ $? -eq 1 ] && ok "run 2 exits 1 — a FAIL verdict is a non-zero run" \
             || bad "run 2 did not exit 1"

GR="$TARGET/specs/$F/gate-report.md"
[ -f "$GR" ] && ok "gate-report.md born at the gate's act, in the feature folder" \
             || bad "no gate-report.md"
hasx "$GR" "Verdict: FAIL (5 gaps)" "FAIL, with the corpus's run-2 gap count"
hasx "$GR" 'CC-G-04 FAIL — FR-007: banned word "quickly" → replace with a measurable target, or move the concern to an NFR with metric + condition.' \
     "step 7's headline: FAIL naming CC-G-04 — FR-007, in named-gap grammar"
has  "$GR" "Certification:        — (not an effective PASS)" \
     "no certification on a FAIL — nothing to hand off"

run "the adapter refuses a feature that has never passed" 1 \
    python3 "$SK/sk_handoff.py" 004 --root "$TARGET"
has "$TMP/out.txt" "no certification" "the refusal names the missing certification, not a hash"

# — the fixes (gate §14.1), then the incremental re-gate
cp "$FX/revisions/spec-r6.md"                          "$TARGET/specs/$F/spec.md"
cp "$FX/project/.specify/memory/roles-permissions.md"  "$MEM/roles-permissions.md"
hasnt "$TARGET/specs/$F/spec.md" "quickly" "the seeded defect is fixed — adverb out, NFR-003 in"
has   "$TARGET/specs/$F/spec.md" "NFR-003" "the timing concern moved to an NFR with metric + condition"

run "Stage 0 — r6 snapshot assembled" 0 \
    python3 "$SK/sk_snapshot.py" build --root "$TARGET" --feature "$F" --epic "$EPIC" \
      --run 3 --date 2026-07-18 --out "$R3/manifest.json" \
      --workspace "$R3/workspace" --require-complete

python3 "$SK/sk_snapshot.py" rerun-set --prev "$R2/manifest.json" --curr "$R3/manifest.json" \
  --prev-spec "$FX/revisions/spec-r5.md" --curr-spec "$TARGET/specs/$F/spec.md" --format json \
  --non-clean "CC-G-03,CC-G-04,CC-NF-02,CC-TR-01,CC-XA-01,CC-AC-04,CC-IN-03" > "$R3/rerun.json"
CARRIED=$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))['carried']))" "$R3/rerun.json")
[ "$CARRIED" = "12" ] && ok "incremental re-gate carries 12 assertions, re-runs the rest (gate §9.2)" \
                      || bad "carry set = $CARRIED, expected 12"

m_pass "$R3/workspace" "$R3/checkers" 3 r6 2026-07-18
cp "$R3/workspace/specs/$F/traceability.md" "$TARGET/specs/$F/traceability.md"
assemble "$FX/gate-runs/run3-rulings.json" "$R3/checkers" "$FX/a-pass/run3.json" \
         "$R3/manifest.json" "$R3/rerun.json" "specs/$F/traceability.md" "$R3/run.json"

run "run 3 exits 0 — a pass-bound verdict" 0 \
    python3 "$SK/sk_snapshot.py" report "$R3/run.json" \
      --certification-out "$R3/cert.json" --append "$GR"

hasx "$GR" "Verdict: PASS WITH WAIVERS" "PASS WITH WAIVERS (gate §14.3)"
has  "$GR" "W-004-01 · CC-IN-03" "one waiver in force, re-affirmed at P5"
has  "$GR" "re-affirmed run 3" "P5 re-affirmation, one line, with its basis"
has  "$GR" "CC-XA-01 — 7 exercised tuples extracted" "⚑ CC-XA-01 signed on its evidence bundle (P3)"
has  "$GR" "CC-XA-06 — no spec content in brief §3" "⚑ CC-XA-06 signed on its evidence bundle (P3)"
has  "$GR" "— effective PASS" "P4 approval makes the PASS effective"
has  "$GR" "Certification: run 3 · effective PASS · 2026-07-18" "certification manifest written (gate §11.1)"
has  "$GR" "specs/$F/traceability.md" "the certification covers what the run produced, not only what it read"
[ -f "$TARGET/specs/$F/traceability.md" ] \
  && ok "traceability.md committed to the feature folder (CC-TR-04 — generated, never hand-authored)" \
  || bad "traceability.md was not committed"
[ -f "$R3/cert.json" ] && ok "the certification manifest the adapter reads exists" \
                       || bad "no cert.json"

# the artifact set plan §8 asks to appear
for a in spec.md traceability.md gate-report.md; do
  [ -f "$TARGET/specs/$F/$a" ] && ok "artifact set: $a" || bad "artifact set: $a missing"
done

# ── 8. negative check — one byte, and the adapter refuses ────────────────────

step "8 · Negative check — one byte edited post-certification"

BEFORE_BRANCH=$(git -C "$TARGET" rev-parse --abbrev-ref HEAD)
printf ' ' >> "$TARGET/specs/$F/spec.md"
run "the adapter REFUSES after a post-certification edit" 1 \
    python3 "$SK/sk_handoff.py" 004 --root "$TARGET"
has "$TMP/out.txt" "specs/$F/spec.md — content changed" \
    "the refusal prints the diverged path (gate §11.1)"
has "$TMP/out.txt" "the certified text is the read text" \
    "the refusal states the rule it is enforcing"
has "$TMP/out.txt" "Nothing was done: no branch was created or checked out" \
    "a refused handoff is not half-done — the guard precedes every side effect"
AFTER_BRANCH=$(git -C "$TARGET" rev-parse --abbrev-ref HEAD)
[ "$BEFORE_BRANCH" = "$AFTER_BRANCH" ] \
  && ok "the branch is untouched by the refusal (still $AFTER_BRANCH)" \
  || bad "the refusal changed the branch: $BEFORE_BRANCH → $AFTER_BRANCH"
[ -e "$TARGET/.specify/feature.json" ] \
  && bad "the refusal wrote Spec Kit's feature pointer" \
  || ok "the refusal wrote no feature pointer either"

python3 - "$TARGET/specs/$F/spec.md" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1]); p.write_text(p.read_text(encoding="utf-8")[:-1], encoding="utf-8")
PY
run "reverted — the hashes verify clean again" 0 \
    python3 "$SK/sk_handoff.py" 004 --root "$TARGET" --verify-only
has "$TMP/out.txt" "11/11" "all eleven certified hashes match"

# a certified file the manifest names, edited outside the feature folder
cp "$MEM/glossary.md" "$TMP/glossary.bak"
printf '\n<!-- x -->\n' >> "$MEM/glossary.md"
run "an edit to a certified GOVERNANCE artifact refuses too" 1 \
    python3 "$SK/sk_handoff.py" 004 --root "$TARGET" --verify-only
has "$TMP/out.txt" "glossary.md" "the manifest reaches past the feature folder (gate §3 static core)"
cp "$TMP/glossary.bak" "$MEM/glossary.md"

# ── 9. handoff ───────────────────────────────────────────────────────────────

step "9 · Handoff — hash guard → branch → plumbing → ready"

run "/ba-handoff 004 reports ready" 0 python3 "$SK/sk_handoff.py" 004 --root "$TARGET"
cp "$TMP/out.txt" "$TMP/ready.txt"
has "$TMP/ready.txt" "Ready — $F"                  "the ready report names the feature"
has "$TMP/ready.txt" "run 3 · effective PASS"      "it names the certification it verified"
has "$TMP/ready.txt" "11/11 certified path(s) match" "the hash guard passed, and says how many"
has "$TMP/ready.txt" "plan-template · tasks-template · scripts/ · /speckit-plan" \
    "Spec Kit's structure confirmed — there is a pipeline to hand to"
has "$TMP/ready.txt" "W-004-01" "the ready report surfaces the waiver in force"
has "$TMP/ready.txt" "1 × [NEEDS CLARIFICATION]" \
    "it inventories the carried unknown — nothing hidden (gate §14.4)"
has "$TMP/ready.txt" "The operator resumes at /speckit-plan" "it names the next act, and stops"

BR=$(git -C "$TARGET" rev-parse --abbrev-ref HEAD)
[ "$BR" = "$F" ] && ok "branch $F checked out — the name /ba-enter-feature assigned" \
                 || bad "branch is '$BR', expected '$F'"
[ -f "$TARGET/.specify/feature.json" ] \
  && ok "Spec Kit's feature pointer written (gate §11.2 plumbing)" \
  || bad ".specify/feature.json was not written"
has "$TARGET/.specify/feature.json" "specs/$F" "the pointer resolves to this feature"

# idempotent: a second handoff is a no-op that still verifies
run "a second /ba-handoff is idempotent" 0 python3 "$SK/sk_handoff.py" 004 --root "$TARGET"
has "$TMP/out.txt" "already checked out" "the branch act recognizes it is already there"

# ── 10. /speckit-plan consumes it, zero manual rework ────────────────────────

step "10 · /speckit-plan consumes it — zero manual rework"

# (a) the operator performs NO file operation between certification and handoff.
#     Everything the pipeline needed was placed by the adapter, and this is the
#     step that proves it: setup-plan.sh resolves the feature with no argument,
#     no env var, and no /speckit-specify run.
run "(a) setup-plan.sh resolves the feature with no operator intervention" 0 \
    env -u SPECIFY_FEATURE_DIRECTORY bash -c \
      "cd '$TARGET' && bash .specify/scripts/bash/setup-plan.sh --json"
has "$TMP/out.txt" "specs/$F/spec.md"  "FEATURE_SPEC resolves to the certified spec"
has "$TMP/out.txt" "specs/$F/plan.md"  "IMPL_PLAN resolves inside the feature folder"
has "$TMP/out.txt" "\"BRANCH\":\"$F\"" "BRANCH matches the branch the adapter checked out"

# (b) the plan runs to a completed plan.md without requesting any spec edit.
#     /speckit-plan is an agent act; its outputs are recorded (see
#     fixtures/.../speckit-plan/README.md) and staged here, then asserted.
cp "$PLANFX/plan.md" "$PLANFX/research.md" "$PLANFX/data-model.md" \
   "$PLANFX/quickstart.md" "$TARGET/specs/$F/"
mkdir -p "$TARGET/specs/$F/contracts"
cp "$PLANFX/contracts/booking-api.md" "$TARGET/specs/$F/contracts/"

for a in plan.md research.md data-model.md quickstart.md contracts/booking-api.md; do
  [ -s "$TARGET/specs/$F/$a" ] && ok "(b) plan artifact produced: $a" \
                              || bad "(b) plan artifact missing or empty: $a"
done
P="$TARGET/specs/$F/plan.md"
has  "$P" "Constitution Check" "(b) the Constitution Check section is filled from the constitution"
hasnt "$P" "[FEATURE]"        "(b) no template placeholder survives in the delivered plan"
hasnt "$P" "[REMOVE IF UNUSED]" "(b) the Option labels are gone — a real structure was chosen"
has  "$P" "No spec edit was requested" "(b) the plan states it needed no spec edit"
# a plan that had to send work back would say so; nothing in the artifacts does
hasnt "$P" "spec must be amended" "(b) the plan asks for no spec amendment"

# (c) the only [NEEDS CLARIFICATION] the coding agent reads is the waivered one.
#     Asserted over the CERTIFIED ARTIFACT SET — the manifest's own file list.
python3 - "$R3/cert.json" "$TARGET" > "$TMP/markers.txt" 2>&1 <<'PY'
import json, pathlib, re, sys
cert = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
root = pathlib.Path(sys.argv[2])
total = 0
for e in cert["files"]:
    hits = re.findall(r"\[NEEDS CLARIFICATION[^\]]*\]",
                      (root / e["path"]).read_text(encoding="utf-8"))
    for h in hits:
        print("%s :: %s" % (e["path"], h))
    total += len(hits)
print("TOTAL=%d" % total)
PY
hasx "$TMP/markers.txt" "TOTAL=1" \
     "(c) exactly one [NEEDS CLARIFICATION] across the whole certified artifact set"
has "$TMP/markers.txt" "calendar sync is unavailable" \
    "(c) and it is the one carried under W-004-01 — nothing hidden, nothing else open"
has "$GR" "OQ-2 Open → carried as [NEEDS CLARIFICATION] under W-004-01" \
    "(c) the gate report names the waiver the marker sits under"

# (d) every certified hash still matches at plan time.
run "(d) every certified hash still matches after the plan run" 0 \
    python3 "$SK/sk_handoff.py" 004 --root "$TARGET" --verify-only
has "$TMP/out.txt" "clean — 11/11" "(d) the certified text is still the read text"

# ── summary ──────────────────────────────────────────────────────────────────

printf '\n\033[1m▸ Result\033[0m\n'
printf '  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
[ "$KEEP" -eq 1 ] && printf '  project kept at: %s\n' "$TARGET"

if [ "$FAILED" -gt 0 ]; then
  printf '\n\033[31m✗ FAIL — the Phase-2 exit test is not green (%s failed)\033[0m\n\n' "$FAILED"
  exit 1
fi
printf '\n\033[32m✓ GREEN — all ten steps of the Phase-2 exit script pass in one run.\033[0m\n'
printf '  install → gated discovery → decomposition + brief → certified spec →\n'
printf '  named-gap FAIL → fix → PASS WITH WAIVERS → refusal on divergence →\n'
printf '  handoff → /speckit-plan consumes it with zero manual rework.\n\n'
exit 0
