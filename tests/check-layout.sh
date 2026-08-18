#!/usr/bin/env bash
#
# BA-Native Spec — post-install layout assertion.
#
# Asserts the build plan §1.1 tree in an installed project, plus the three
# checks the S1 session exit test names beyond the tree: Spec Kit present, all
# 35 /ba-* skills registered, manifest vector correct.
#
# The expected tree lives in tests/layout.expected, one entry per line, each
# tagged with the build session that owns it. Two bars:
#
#   --session Sn   require SK + S1…Sn; report later sessions as PENDING.
#                  This is a session exit test.
#   (no --session) require the whole tree. This is the Phase-2 exit bar
#                  (build plan §5 step 2).
#
# Nothing is ever silently absent: every unmet later-session entry is printed
# with its owning session, so a partial build reads as partial, not as passing.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
EXPECTED="$HERE/layout.expected"

TARGET="$PWD"
SESSION=""
ALLOW_RUNTIME=0
VERBOSE=0

usage() {
  cat <<'EOF'
check-layout.sh — assert the installed BA-Native Spec tree.

  check-layout.sh [--target <dir>] [--session S1..S9] [--allow-runtime] [-v]

  --target <dir>    installed project to check (default: current directory)
  --session Sn      require only what sessions SK..Sn produce; later units are
                    reported PENDING rather than failed
  --allow-runtime   skip the "no runtime content yet" assertions (use once real
                    acts have run; they enforce D-P2-6 on a fresh install)
  -v                list every satisfied entry, not just the failures
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target)        TARGET="${2:?--target needs a directory}"; shift 2 ;;
    --session)       SESSION="${2:?--session needs S1..S9}"; shift 2 ;;
    --allow-runtime) ALLOW_RUNTIME=1; shift ;;
    -v|--verbose)    VERBOSE=1; shift ;;
    -h|--help)       usage; exit 0 ;;
    *) printf 'unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

[ -d "$TARGET" ] || { printf '✗ target is not a directory: %s\n' "$TARGET" >&2; exit 2; }
TARGET="$(cd "$TARGET" && pwd)"
[ -f "$EXPECTED" ] || { printf '✗ missing %s\n' "$EXPECTED" >&2; exit 2; }

# Session ordering. SK (Spec Kit) and RT (runtime) are handled specially.
session_rank() {
  case "$1" in
    SK) echo 0 ;; S1) echo 1 ;; S2) echo 2 ;; S3) echo 3 ;; S4) echo 4 ;;
    S5) echo 5 ;; S6) echo 6 ;; S7) echo 7 ;; S8) echo 8 ;; S9) echo 9 ;;
    *)  echo -1 ;;
  esac
}

BAR=9
BAR_LABEL="full tree (Phase-2 exit bar)"
if [ -n "$SESSION" ]; then
  BAR="$(session_rank "$SESSION")"
  [ "$BAR" -ge 1 ] || { printf '✗ --session must be S1..S9 (got %s)\n' "$SESSION" >&2; exit 2; }
  BAR_LABEL="sessions SK..$SESSION"
fi

pass=0; fail=0; pending=0
FAILURES=""
PENDING_LIST=""

ok()   { pass=$((pass+1)); [ "$VERBOSE" -eq 1 ] && printf '  \033[32m✓\033[0m %s\n' "$1"; return 0; }
note() { printf '  \033[32m✓\033[0m %s\n' "$1"; }
bad()  { fail=$((fail+1)); FAILURES="$FAILURES$1"$'\n'; printf '  \033[31m✗\033[0m %s\n' "$1"; }
pend() { pending=$((pending+1)); PENDING_LIST="$PENDING_LIST$1"$'\n'; }

printf '\n\033[1mBA-Native Spec — layout check\033[0m\n'
printf '  target: %s\n  bar:    %s\n\n' "$TARGET" "$BAR_LABEL"

# ───────────────────────────────────────────────────────────── tree assertions ─
printf '\033[1m▸ Tree (build plan §1.1)\033[0m\n'
n_present=0; n_absent_ok=0

while IFS='|' read -r sess kind path note; do
  case "$sess" in ''|'#'*) continue ;; esac
  [ -n "${path:-}" ] || continue

  if [ "$sess" = "RT" ]; then
    [ "$ALLOW_RUNTIME" -eq 1 ] && continue
    if [ -e "$TARGET/$path" ]; then
      bad "$path — exists, but is runtime-born (${note:-◇}); the installer must create no content stubs (D-P2-6)"
    else
      ok "$path absent ✓ (${note:-◇})"
      n_absent_ok=$((n_absent_ok+1))
    fi
    continue
  fi

  rank="$(session_rank "$sess")"
  if [ "$rank" -lt 0 ]; then
    bad "layout.expected: unknown session tag '$sess' for $path"
    continue
  fi

  present=1
  case "$kind" in
    file) [ -f "$TARGET/$path" ] || present=0 ;;
    dir)  [ -d "$TARGET/$path" ] || present=0 ;;
    *)    bad "layout.expected: unknown kind '$kind' for $path"; continue ;;
  esac

  if [ "$present" -eq 1 ]; then
    ok "$path"
    n_present=$((n_present+1))
  elif [ "$rank" -le "$BAR" ]; then
    bad "$path — missing ($kind, owned by $sess${note:+ — $note})"
  else
    pend "$sess  $path${note:+  — $note}"
  fi
done < "$EXPECTED"

note "$n_present expected path(s) in place"
[ "$ALLOW_RUNTIME" -eq 1 ] \
  && printf '  \033[33m○\033[0m runtime-absence assertions skipped (--allow-runtime)\n' \
  || note "$n_absent_ok runtime-born (◇) path(s) correctly absent — zero installer stubs (D-P2-6)"

# ────────────────────────────────────────────────────── Spec Kit presence check ─
printf '\n\033[1m▸ Spec Kit\033[0m\n'
sk_count=$(find "$TARGET/.claude/skills" -maxdepth 1 -mindepth 1 -type d -name 'speckit-*' 2>/dev/null | wc -l | tr -d ' ')
if [ "$sk_count" -gt 0 ]; then
  pass=$((pass+1))
  note "$sk_count speckit-* skills registered"
  printf '    %s\n' "$(find "$TARGET/.claude/skills" -maxdepth 1 -mindepth 1 -type d -name 'speckit-*' -exec basename {} \; 2>/dev/null | sort | tr '\n' ' ')"
else
  bad "no speckit-* skills found under .claude/skills/ — Spec Kit did not initialize"
fi

# ──────────────────────────────── the spec-template override is actually ours ──
# The one deliberate exception to "everything of ours lives under .specify/ba/".
# Presence is not enough: Spec Kit ships a spec-template.md of its own at the
# same path, and a `specify init --force` at a pin bump puts it back. This check
# is what catches a lost override.
printf '\n\033[1m▸ spec-template override (standard §2)\033[0m\n'
SPEC_TPL="$TARGET/.specify/templates/spec-template.md"
if [ ! -f "$SPEC_TPL" ]; then
  bad ".specify/templates/spec-template.md missing"
else
  missing_headings=""
  while IFS= read -r h; do
    grep -qxF "## $h" "$SPEC_TPL" || missing_headings="$missing_headings\n      - $h"
  done <<'HEADINGS'
Overview & Value
User Stories
Functional Requirements
Flows, States & Errors
Non-Functional Requirements
Business Rules
Data Requirements
Integration Touchpoints
Out of Scope
References
HEADINGS
  if [ -n "$missing_headings" ]; then
    bad ".specify/templates/spec-template.md is not our override — missing heading(s):$(printf "$missing_headings")"
  else
    # order matters as much as presence (CC-G-01: exact names, exact order)
    order_actual=$(grep -n '^## ' "$SPEC_TPL" | sed 's/^[0-9]*:## //')
    order_expected='Overview & Value
User Stories
Functional Requirements
Flows, States & Errors
Non-Functional Requirements
Business Rules
Data Requirements
Integration Touchpoints
Out of Scope
References'
    if [ "$order_actual" = "$order_expected" ]; then
      pass=$((pass+1))
      note "ten headings, exact names, exact order — the override is in place"
    else
      bad ".specify/templates/spec-template.md headings are out of order or extra (CC-G-01 parses this shape)"
    fi
  fi
fi

# ─────────────────────────────────────────────── the 35 /ba-* skills, by name ──
printf '\n\033[1m▸ /ba-* skill registry — 35 expected (build plan §2.9)\033[0m\n'
expected_skills=$(grep -c '^S[0-9]|file|\.claude/skills/ba-' "$EXPECTED" | tr -d ' ')
found_skills=$(find "$TARGET/.claude/skills" -maxdepth 1 -mindepth 1 -type d -name 'ba-*' 2>/dev/null | wc -l | tr -d ' ')

if [ "$expected_skills" -ne 35 ]; then
  bad "layout.expected registers $expected_skills /ba-* skills, not 35 — the manifest itself is wrong"
else
  pass=$((pass+1))
  note "layout.expected registers all 35 by name (15 workflow + 20 technique)"
fi

if [ "$found_skills" -eq 35 ]; then
  ok "35 of 35 /ba-* skills installed"
elif [ -n "$SESSION" ]; then
  printf '  \033[33m○\033[0m %s of 35 /ba-* skills installed — %s pending, itemized below\n' \
    "$found_skills" "$((35 - found_skills))"
else
  bad "$found_skills of 35 /ba-* skills installed — the full tree is the Phase-2 bar"
fi

# ───────────────────────────────── D-P2-2: frontmatter is the enforcement ──────
# Every /ba-* skill ships `disable-model-invocation: true` — the corpus's
# BA-invoked-never-auto-fired discipline (gate §2.2, orchestrator §7.1) enforced
# by frontmatter, not by convention. Checked on whatever is installed, so each
# session's units are covered the moment they land.
printf '\n\033[1m▸ Skill & agent frontmatter (D-P2-2, D-P2-3)\033[0m\n'
fm_bad=0; fm_seen=0
for f in "$TARGET"/.claude/skills/ba-*/SKILL.md; do
  [ -f "$f" ] || continue
  fm_seen=$((fm_seen+1))
  dir=$(basename "$(dirname "$f")")
  head -12 "$f" | grep -qx -- "name: $dir" \
    || { bad "$dir/SKILL.md — frontmatter name does not match its directory"; fm_bad=1; }
  head -12 "$f" | grep -q '^description: .' \
    || { bad "$dir/SKILL.md — no description in frontmatter"; fm_bad=1; }
  head -12 "$f" | grep -qx 'disable-model-invocation: true' \
    || { bad "$dir/SKILL.md — missing disable-model-invocation: true (D-P2-2)"; fm_bad=1; }
done
if [ "$fm_seen" -eq 0 ]; then
  printf '  \033[33m○\033[0m no /ba-* skills installed yet — nothing to check\n'
elif [ "$fm_bad" -eq 0 ]; then
  pass=$((pass+1)); note "$fm_seen installed skill(s): name matches directory · description present · disable-model-invocation: true"
fi

ag_bad=0; ag_seen=0
for f in "$TARGET"/.claude/agents/ba-*.md; do
  [ -f "$f" ] || continue
  ag_seen=$((ag_seen+1))
  n=$(basename "$f" .md)
  head -8 "$f" | grep -qx -- "name: $n" \
    || { bad "agents/$n.md — frontmatter name does not match the file"; ag_bad=1; }
  head -8 "$f" | grep -q '^description: .' \
    || { bad "agents/$n.md — no description in frontmatter"; ag_bad=1; }
done
# the gate evaluator's read-only tool policy is gate §11.3 made mechanical
if [ -f "$TARGET/.claude/agents/ba-gate.md" ]; then
  if head -8 "$TARGET/.claude/agents/ba-gate.md" | grep -qE '^tools: *Read, *Grep, *Glob *$'; then
    pass=$((pass+1)); note "ba-gate agent is read-only by tool policy (gate §11.3 — it never edits)"
  else
    bad "ba-gate agent must declare exactly 'tools: Read, Grep, Glob' — the A evaluator never edits"
  fi
fi
if [ "$ag_seen" -gt 0 ] && [ "$ag_bad" -eq 0 ]; then
  pass=$((pass+1)); note "$ag_seen installed agent(s): name matches file · description present"
fi

# ────────────────────────────────────────────────────────── manifest assertions ─
printf '\n\033[1m▸ Manifest\033[0m\n'
MANIFEST="$TARGET/.specify/ba/manifest.md"
if [ ! -f "$MANIFEST" ]; then
  bad ".specify/ba/manifest.md missing — install.sh did not generate it"
else
  MANIFEST_OUT="$(python3 "$HERE/verify-manifest.py" "$TARGET" "$PKG_ROOT" 2>&1)"
  MANIFEST_RC=$?
  printf '%s\n' "$MANIFEST_OUT" | sed 's/^/  /'
  if [ "$MANIFEST_RC" -eq 0 ]; then
    pass=$((pass+1))
  else
    fail=$((fail+1))
    FAILURES="${FAILURES}manifest verification failed"$'\n'
  fi
fi

printf '\n'

# ───────────────────────────────────────────────────────────────────── summary ─
if [ "$pending" -gt 0 ]; then
  printf '\033[1m▸ Pending — owned by later build sessions\033[0m\n'
  printf '%s' "$PENDING_LIST" | sort | sed 's/^/  ○ /'
  printf '\n'
fi

printf '\033[1m▸ Result\033[0m\n'
printf '  passed: %s   failed: %s   pending: %s\n\n' "$pass" "$fail" "$pending"

if [ "$fail" -gt 0 ]; then
  printf '\033[31m✗ FAIL — %s assertion(s) unmet at the %s bar\033[0m\n\n' "$fail" "$BAR_LABEL"
  exit 1
fi

if [ "$pending" -gt 0 ]; then
  printf '\033[32m✓ GREEN at the %s bar\033[0m — %s unit(s) still owned by later sessions.\n\n' \
    "$BAR_LABEL" "$pending"
else
  printf '\033[32m✓ GREEN — the full §1.1 tree is in place.\033[0m\n\n'
fi
exit 0
