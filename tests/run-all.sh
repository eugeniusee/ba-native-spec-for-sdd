#!/usr/bin/env bash
#
# BA-Native Spec — the regression runner. One command, sixteen checks.
#
# Every BUILD-LOG entry since S2 has closed with the same roll-up table, and
# every one of them was assembled by hand from separate invocations —
# two of which need a real install first. That is D54. This script is the table.
#
# The sixteen, in the order the entries print them:
#
#   twelve file-only checks — read the payload, the docs and the fixtures
#     1  check-m.sh              the ten vendored M checkers
#     2  check-gate.sh           the gate: cards · Scope F · W/O/HA · P1–P8
#     3  check-orchestrator.sh   the §12 exhibits · ledger grammar
#     4  check-techniques.sh     T-01…T-03
#     5  check-techniques2.sh    T-04…T-10
#     6  check-techniques3.sh    T-11…T-16 · Band-1 closure
#     7  check-spine.sh          Band 2 · Tier 1 · Tier 2
#     8  check-register.sh       the BA-facing register · the session boundary
#     9  check-wbs.sh            the WBS export — rows · selection · register
#    10  check-status.sh         the dashboard — shape · counts · §10.4-F · HTML
#    11  check-ledger.py         the aspect ledger against its grammar
#    12  check-cards.py          the three compiled cards vs. their sources
#
#   three install-based runs — each installs into a throwaway git repo
#    13  check-layout.sh         the full Phase-2 tree bar on a fresh install
#    14  check-exit.sh --offline the Phase-2 §5 exit test, all ten steps
#    15  check-install.sh        the install UX — bootstrap · self-guard · uv-free
#
#   one whole-surface check — file-only, but last: it reads the render surface
#   entire, so it runs after everything that could have changed it
#    16  check-budget.sh         manual-mode UX — the ≤ 8 interaction budget ·
#                                the route render §10.6 · the checkpoint law ·
#                                zero acknowledgement-only stops
#
# `check-cards.py` and `check-ledger.py` also run inside `check-gate.sh` and
# `check-orchestrator.sh`. They keep their own rows because the entries give
# them their own rows: a card divergence should name itself, not arrive as a
# gate-suite failure.
#
# The runner asserts nothing of its own. Every verdict is the check's own exit
# code; every count is parsed from the check's own roll-up line. A check that
# prints no count reports its summary sentence instead — never an invented one.
#
#   run-all.sh                run all sixteen
#   run-all.sh --file-only    the thirteen checks that need no install and no
#                             network — the twelve, plus check-budget.sh
#   run-all.sh --online       let the install-based runs fetch Spec Kit
#                             (default: --offline, from vendor/)
#   run-all.sh --keep         keep the installed projects and print their paths
#   run-all.sh --list         print the sixteen rows and exit
#   run-all.sh -v             stream each check's full output as it runs

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"

FILE_ONLY=0; KEEP=0; VERBOSE=0; LIST=0; OFFLINE="--offline"
for a in "$@"; do
  case "$a" in
    --file-only) FILE_ONLY=1 ;;
    --online)    OFFLINE="" ;;
    --keep)      KEEP=1 ;;
    --list)      LIST=1 ;;
    -v|--verbose) VERBOSE=1 ;;
    -h|--help)   sed -n '2,45p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
KEPT=""
cleanup() { [ "$KEEP" -eq 1 ] || rm -rf "$TMP"; }
trap cleanup EXIT

# ── the roll-up, accumulated a row at a time ─────────────────────────────────

ROWS="$TMP/rows.tsv"; : > "$ROWS"
RAN=0; RED=0; SKIPPED=0

row()  { printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$ROWS"; }   # name, cell, state

# `passed: N   failed: M` — every shell suite's roll-up line, one format
counts_of() { sed -n 's/.*passed: *\([0-9][0-9]*\).*failed: *\([0-9][0-9]*\).*/\1 \2/p' "$1" | tail -1; }
pending_of() { sed -n 's/.*pending: *\([0-9][0-9]*\).*/\1/p' "$1" | tail -1; }

say()  { printf '%s\n' "$1"; }

# run one check: label, result-shape, then the command
#   shape=suite   → "N / M" from the roll-up line
#   shape=layout  → "N / M / P"
#   shape=line    → the check's own summary sentence
run_check() {
  local name="$1" shape="$2"; shift 2
  local out="$TMP/${name//[^A-Za-z0-9]/_}.out" rc cell p f pend
  RAN=$((RAN+1))
  printf '  · %-28s ' "$name"
  if [ "$VERBOSE" -eq 1 ]; then
    printf '\n'
    "$@" 2>&1 | tee "$out"; rc=${PIPESTATUS[0]}
    printf '  · %-28s ' "$name"
  else
    "$@" > "$out" 2>&1; rc=$?
  fi

  case "$shape" in
    suite|layout)
      read -r p f <<<"$(counts_of "$out")"
      if [ -z "${p:-}" ]; then cell="no roll-up line"
      elif [ "$shape" = "layout" ]; then
        pend="$(pending_of "$out")"; cell="$p / $f / ${pend:-?}"
      else cell="$p / $f"; fi
      ;;
    line)
      cell="$(grep -m1 '✓' "$out" | sed 's/^[[:space:]]*✓[[:space:]]*//; s/^[^:]*: *//')"
      [ -n "$cell" ] || cell="$(tail -1 "$out" | sed 's/^[[:space:]]*//')"
      ;;
  esac

  if [ "$rc" -eq 0 ]; then
    row "$name" "$cell" green
    printf '✓ %s\n' "$cell"
  else
    RED=$((RED+1))
    row "$name" "$cell ✗" red
    printf '✗ %s   (exit %s)\n' "$cell" "$rc"
  fi
  return 0
}

skip_check() {
  SKIPPED=$((SKIPPED+1))
  row "$1" "$2" skipped
  printf '  · %-28s — %s\n' "$1" "$2"
}

if [ "$LIST" -eq 1 ]; then
  sed -n '/^#   twelve file-only checks/,/^#                                zero acknowledgement-only stops/p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
fi

# ── the twelve file-only checks ──────────────────────────────────────────────

printf '\n▸ The file-only checks — payload, docs and fixtures, no install\n'

run_check "check-m.sh"            suite "$HERE/check-m.sh"
run_check "check-gate.sh"         suite "$HERE/check-gate.sh"
run_check "check-orchestrator.sh" suite "$HERE/check-orchestrator.sh"
run_check "check-techniques.sh"   suite "$HERE/check-techniques.sh"
run_check "check-techniques2.sh"  suite "$HERE/check-techniques2.sh"
run_check "check-techniques3.sh"  suite "$HERE/check-techniques3.sh"
run_check "check-spine.sh"        suite "$HERE/check-spine.sh"
run_check "check-register.sh"     suite "$HERE/check-register.sh"
run_check "check-wbs.sh"          suite "$HERE/check-wbs.sh"
run_check "check-status.sh"       suite "$HERE/check-status.sh"
run_check "check-ledger.py"       line  python3 "$HERE/check-ledger.py" \
          "$HERE/fixtures/appointment-booking/band1/aspect-state.md"
run_check "check-cards.py"        line  python3 "$HERE/check-cards.py"

# ── the three install-based runs ─────────────────────────────────────────────

if [ "$FILE_ONLY" -eq 1 ]; then
  printf '\n▸ The install-based runs — skipped (--file-only)\n'
  skip_check "check-layout.sh"      "skipped — --file-only"
  skip_check "check-exit.sh"        "skipped — --file-only"
  skip_check "check-install.sh"     "skipped — --file-only"
else
  printf '\n▸ The install-based runs — a throwaway git repo each%s\n' \
    "$([ -n "$OFFLINE" ] && printf ', Spec Kit from vendor/')"

  LAYOUT_PROJ="$TMP/layout-project"
  mkdir -p "$LAYOUT_PROJ"
  git -C "$LAYOUT_PROJ" init -q .
  git -C "$LAYOUT_PROJ" config user.email "run-all@ba-native-spec.local"
  git -C "$LAYOUT_PROJ" config user.name  "BA-Native Spec regression runner"

  if "$PKG_ROOT/install.sh" --target "$LAYOUT_PROJ" $OFFLINE > "$TMP/install.out" 2>&1; then
    run_check "check-layout.sh" layout "$HERE/check-layout.sh" --target "$LAYOUT_PROJ"
    KEPT="$KEPT$LAYOUT_PROJ
"
  else
    RED=$((RED+1))
    row "check-layout.sh" "install failed ✗" red
    printf '  · %-28s ✗ install.sh did not complete — the layout bar never ran\n' "check-layout.sh"
    tail -12 "$TMP/install.out" | sed 's/^/      /'
  fi

  EXIT_PROJ="$TMP/exit-project"
  run_check "check-exit.sh $OFFLINE" suite \
            "$HERE/check-exit.sh" --target "$EXIT_PROJ" --keep $OFFLINE
  KEPT="$KEPT$EXIT_PROJ
"

  # The install UX owns its own targets — a bootstrap run must start from a
  # directory that is not yet a repository, which no runner-made repo can be.
  run_check "check-install.sh" suite "$HERE/check-install.sh" $OFFLINE
fi

# ── the whole-surface check ──────────────────────────────────────────────────
#
# File-only, and last on purpose: check-budget.sh sweeps the entire skill,
# persona and mirror surface for acknowledgement-only stops and holds the
# pinned route render down in every file that renders one. Running it after
# everything else means it reads the surface as the rest of the suite left it.

printf '\n▸ The whole-surface check — the render surface as the suite leaves it\n'

run_check "check-budget.sh"       suite "$HERE/check-budget.sh"

# ── the table ────────────────────────────────────────────────────────────────

printf '\n| Check | Result |\n|---|---|\n'
while IFS=$'\t' read -r name cell state; do
  printf '| `%s` | %s |\n' "$name" "$cell"
done < "$ROWS"

if [ "$RED" -gt 0 ]; then
  printf '\n▸ The failures, in full\n'
  while IFS=$'\t' read -r name cell state; do
    [ "$state" = "red" ] || continue
    printf '\n── %s ──\n' "$name"
    sed -n '/✗/p' "$TMP/${name//[^A-Za-z0-9]/_}.out" 2>/dev/null | head -20 | sed 's/^/  /'
  done < "$ROWS"
fi

printf '\n  ran: %s   red: %s   skipped: %s\n' "$RAN" "$RED" "$SKIPPED"
if [ "$KEEP" -eq 1 ] && [ -n "$KEPT" ]; then
  printf '  kept:\n'; printf '%s' "$KEPT" | sed 's/^/    /'
fi

if [ "$RED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  printf '✓ GREEN — all %s checks pass, the three install-based runs included\n' "$RAN"
  exit 0
elif [ "$RED" -eq 0 ]; then
  printf '✓ GREEN — %s checks pass; %s not run (see the table)\n' "$RAN" "$SKIPPED"
  exit 0
fi
printf '✗ RED — %s of %s checks failed\n' "$RED" "$RAN"
exit 1
