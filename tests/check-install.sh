#!/usr/bin/env bash
#
# BA-Native Spec — the install-UX suite.
#
# The install path a first-time user actually walks, held down end to end:
#
#   1  (a) bootstrap into a fresh, empty, non-git directory — the one-liner's
#          own path, driven from a local checkout via BNS_SOURCE
#   2  (c) bootstrap's self-guard — the package repo builds the payload and is
#          not a place to install it into
#   3  (b) install.sh with uv shadowed off PATH — the uv-free case
#   4  (d)(e) bootstrap with uv shadowed off PATH — the gap closed, and the
#          refusal when closing it fails
#
# **Section 3 is pinned at install.sh's behavior, which the D88 resolution did
# not change.** The install-UX ruling asked for "uv missing + vendor zip present
# → take the existing --offline path". Read against the installer, that path is
# not uv-free: `--offline` changes only where the Spec Kit *source* comes from,
# and both paths then run `uvx --from <source> specify init`. The vendored
# archive is upstream's source tree, its CLI needs nine third-party packages, and
# none of them are vendored — so no uv-free route to a pinned Spec Kit exists.
# Taking the offline path on a uv-less machine would only move the death later
# and give it a wrong reason. Section 3 therefore pins the current, accurate
# refusal *and its cause*, so the day the cause is fixed this suite says so.
#
# **Section 4 is where D88 was resolved — one layer up, not in the installer.**
# Bootstrap's network is not an assumption: it has just downloaded the package
# over it. So bootstrap installs uv itself when the machine has none, and the
# uv-less machine arriving at install.sh through the one-liner stops being a case
# that can happen. install.sh is untouched, and section 3 still holds it down.
#
#   check-install.sh              run it
#   check-install.sh --online     let the installs fetch Spec Kit (default: --offline)
#   check-install.sh --keep       keep the installed projects and print their paths
#   check-install.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
SPECKIT_PIN="v0.12.5"
VENDOR_ZIP="$PKG_ROOT/vendor/spec-kit-$SPECKIT_PIN.zip"

OFFLINE="--offline"
KEEP=0
VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --online)     OFFLINE=""; shift ;;
    --offline)    OFFLINE="--offline"; shift ;;
    --keep)       KEEP=1; shift ;;
    -v|--verbose) VERBOSE=1; shift ;;
    -h|--help)    sed -n '2,35p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
cleanup() { [ "$KEEP" -eq 1 ] || rm -rf "$TMP"; }
trap cleanup EXIT

PASSED=0; FAILED=0
ok()   { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad()  { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }
step() { printf '\n\033[1m▸ %s\033[0m\n' "$*"; }

# has <file> <fixed-string> <label>
has()   { grep -Fq "$2" "$1" && ok "$3" || bad "$3 — not found: $2"; }
hasnt() { grep -Fq "$2" "$1" && bad "$3 — present but must not be: $2" || ok "$3"; }
isfile() { [ -f "$1" ] && ok "$2" || bad "$2 — no such file: $1"; }
absent() { [ -e "$1" ] && bad "$2 — exists: $1" || ok "$2"; }

printf '\n\033[1mBA-Native Spec — install-UX suite\033[0m\n'
printf '  package: %s\n  spec kit: %s\n' "$PKG_ROOT" "${OFFLINE:-network}"

isfile "$PKG_ROOT/bootstrap.sh" "bootstrap.sh ships at the package root"
[ -x "$PKG_ROOT/bootstrap.sh" ] && ok "bootstrap.sh is executable" \
                               || bad "bootstrap.sh is not executable"
bash -n "$PKG_ROOT/bootstrap.sh" 2>/dev/null && ok "bootstrap.sh parses" \
                                             || bad "bootstrap.sh does not parse"

# ── 1 · (a) bootstrap into a fresh, empty, non-git directory ─────────────────
#
# The one-liner's own path, minus the download: BNS_SOURCE points bootstrap at
# this checkout, which is the hook the download branch exists to produce. Every
# later step — the git init, the handover, the installer's whole run — is the
# path a real `curl … | bash` walks.

step "1 · (a) bootstrap → a fresh non-git directory"

FRESH="$TMP/fresh-project"
mkdir -p "$FRESH"
absent "$FRESH/.git" "the directory starts as a plain, empty, non-git directory"

BOOT_OUT="$TMP/bootstrap-a.out"
( cd "$FRESH" && BNS_SOURCE="$PKG_ROOT" bash "$PKG_ROOT/bootstrap.sh" $OFFLINE ) \
  > "$BOOT_OUT" 2>&1
BOOT_RC=$?

if [ "$BOOT_RC" -eq 0 ]; then
  ok "(a) bootstrap exits 0"
else
  bad "(a) bootstrap exited $BOOT_RC, expected 0"
  sed 's/^/      /' "$BOOT_OUT" | tail -25
fi

[ -d "$FRESH/.git" ] && ok "(a) the target is a git repository — bootstrap ran git init" \
                     || bad "(a) no .git/ — bootstrap did not initialize the repository"
has "$BOOT_OUT" "not a git repository yet — running: git init" \
    "(a) and it said so out loud, before doing it"

# The uv ensure step is unconditional, so it runs here too — on whichever branch
# this machine is on. Section 4 drives both branches deliberately.
has "$BOOT_OUT" "▸ uv" "(a) the uv ensure step runs on the bootstrap path"
if command -v uv >/dev/null 2>&1; then
  has "$BOOT_OUT" "already installed ✓" \
      "(a) …uv was already on this machine, so it passed straight through"
else
  has "$BOOT_OUT" "uv not found — installing" \
      "(a) …uv was missing on this machine, so it was installed"
fi

isfile "$FRESH/.claude/skills/ba-frame/SKILL.md" \
       "(a) /ba-frame is laid down — the Band-1 entry command exists"
isfile "$FRESH/.specify/ba/manifest.md" \
       "(a) .specify/ba/manifest.md is present"
has "$FRESH/.specify/ba/manifest.md" "$(tr -d '[:space:]' < "$PKG_ROOT/VERSION")" \
    "(a) the manifest records this package version"

# the installer's own voice reaches the user unfiltered
has "$BOOT_OUT" "▸ Preflight"          "(a) the installer's output is surfaced verbatim — preflight"
has "$BOOT_OUT" "BA-Native Spec"       "(a) …its banner"
has "$BOOT_OUT" "/ba-frame"            "(a) …and its next-step block"
has "$BOOT_OUT" "installing into $FRESH" \
    "(a) the installer was pointed at \$PWD, not at the package"

# every remaining argument reaches install.sh untouched
if [ -n "$OFFLINE" ]; then
  has "$BOOT_OUT" "(offline fallback)" \
      "(a) --offline passed through to the installer — arguments are forwarded"
else
  has "$BOOT_OUT" "git+https://github.com/github/spec-kit.git@$SPECKIT_PIN" \
      "(a) the network Spec Kit source was used — no argument invented"
fi

# 37 /ba-* skills is the layout bar's own number; a bootstrap install is a full
# install or it is not an install.
N_BA=$(find "$FRESH/.claude/skills" -maxdepth 1 -mindepth 1 -type d -name 'ba-*' 2>/dev/null | wc -l | tr -d ' ')
[ "$N_BA" -eq 37 ] && ok "(a) all 37 /ba-* skills installed — a bootstrap install is a full install" \
                   || bad "(a) $N_BA of 37 /ba-* skills installed after bootstrap"

# --help answers without side effects: no download, no git init, nothing written
HELP_DIR="$TMP/help-dir"
mkdir -p "$HELP_DIR"
( cd "$HELP_DIR" && bash "$PKG_ROOT/bootstrap.sh" --help ) > "$TMP/help.out" 2>&1
HELP_RC=$?
[ "$HELP_RC" -eq 0 ] && ok "(a) bootstrap --help exits 0" \
                     || bad "(a) bootstrap --help exited $HELP_RC"
has "$TMP/help.out" "curl -fsSL" "(a) --help prints the one-liner it exists for"
absent "$HELP_DIR/.git" "(a) --help initializes no repository — help has no side effects"

# ── 2 · (c) the self-guard ───────────────────────────────────────────────────
#
# Detection is the triple: VERSION + payload/ + install.sh. The primary run is
# against a decoy carrying exactly that triple, so a regressed guard cannot
# install into this working tree mid-suite. The real repo is then checked twice:
# that it carries the triple the decoy imitates, and that bootstrap refuses
# inside it — that second run passes --dry-run, which install.sh honours by
# writing nothing at all, so even a regressed guard leaves the tree clean.

step "2 · (c) the self-guard — the package repo is not an install target"

DECOY="$TMP/decoy-package"
mkdir -p "$DECOY/payload"
: > "$DECOY/VERSION"
: > "$DECOY/install.sh"

( cd "$DECOY" && BNS_SOURCE="$PKG_ROOT" bash "$PKG_ROOT/bootstrap.sh" $OFFLINE ) \
  > "$TMP/guard-decoy.out" 2>&1
GUARD_RC=$?

[ "$GUARD_RC" -ne 0 ] && ok "(c) bootstrap refuses inside a package repo — exit $GUARD_RC" \
                      || bad "(c) bootstrap exited 0 inside a package repo — the guard did not fire"
has "$TMP/guard-decoy.out" "this is the BA-Native Spec package repo itself" \
    "(c) the refusal says what it refused"
has "$TMP/guard-decoy.out" "VERSION + payload/ + install.sh" \
    "(c) …and names the triple it detected"
absent "$DECOY/.git"     "(c) the refused target got no git init"
absent "$DECOY/.specify" "(c) …no .specify/"
absent "$DECOY/.claude"  "(c) …no .claude/ — a refusal writes nothing"

for p in VERSION payload install.sh; do
  [ -e "$PKG_ROOT/$p" ] && ok "(c) the real package repo carries $p — the decoy is representative" \
                        || bad "(c) the real package repo has no $p — the guard's triple is wrong"
done

REAL_BEFORE="$(git -C "$PKG_ROOT" status --porcelain 2>/dev/null | sort)"
( cd "$PKG_ROOT" && bash "$PKG_ROOT/bootstrap.sh" --dry-run ) > "$TMP/guard-real.out" 2>&1
REAL_RC=$?
[ "$REAL_RC" -ne 0 ] && ok "(c) bootstrap refuses inside THIS repo — exit $REAL_RC" \
                     || bad "(c) bootstrap exited 0 inside this repo — the guard did not fire"
has "$TMP/guard-real.out" "this is the BA-Native Spec package repo itself" \
    "(c) …with the same refusal"
[ "$(git -C "$PKG_ROOT" status --porcelain 2>/dev/null | sort)" = "$REAL_BEFORE" ] \
  && ok "(c) the working tree is byte-for-byte as it was — the refusal touched nothing" \
  || bad "(c) the refusal changed the working tree"

# ── 3 · (b) the uv-free case — pinned at today's behavior (D88) ──────────────
#
# The workstream's target is "uv missing + vendor zip present → offline path,
# install succeeds". It cannot be reached from here: the offline path runs
# `uvx --from <unpacked zip> specify init`, so it needs uv exactly as the network
# path does. Until that is resolved this section pins what the installer really
# does, and — the assertion that matters — pins the *cause*, so the fix cannot
# land without this suite noticing.

step "3 · (b) uv shadowed off PATH — the uv-free case (pinned; see D88)"

isfile "$VENDOR_ZIP" "(b) the vendored Spec Kit $SPECKIT_PIN archive is in place — this is the L2 case"

# A PATH with every directory that holds uv/uvx removed, and a shim carrying the
# tools the installer and bootstrap need, in case one of them shared a directory
# with uv. Section 4 reuses this PATH — the same shadowing, one layer up.
UV_DIRS=""
for c in uv uvx; do
  p="$(command -v "$c" 2>/dev/null)" && UV_DIRS="$UV_DIRS $(dirname "$p")"
done
UVLESS_PATH=""
IFS=':' read -ra _pdirs <<< "$PATH"
for d in "${_pdirs[@]}"; do
  skip=0
  for u in $UV_DIRS; do [ "$d" = "$u" ] && skip=1; done
  [ "$skip" -eq 1 ] && continue
  UVLESS_PATH="${UVLESS_PATH:+$UVLESS_PATH:}$d"
done
SHIM="$TMP/shim"; mkdir -p "$SHIM"
for t in python3 git unzip bash; do
  real="$(command -v "$t" 2>/dev/null)" || continue
  PATH="$UVLESS_PATH" command -v "$t" >/dev/null 2>&1 || ln -sf "$real" "$SHIM/$t"
done
UVLESS_PATH="$SHIM:$UVLESS_PATH"

env PATH="$UVLESS_PATH" command -v uvx >/dev/null 2>&1 \
  && bad "(b) uvx is still reachable on the shadowed PATH — the case is not set up" \
  || ok "(b) uvx is unreachable on the shadowed PATH"
env PATH="$UVLESS_PATH" command -v python3 >/dev/null 2>&1 \
  && ok "(b) python3 survives the shadowing — only uv was removed" \
  || bad "(b) python3 was removed along with uv — the case cannot be exercised"

UVLESS="$TMP/uvless-project"
mkdir -p "$UVLESS"
git -C "$UVLESS" init -q .
git -C "$UVLESS" config user.email "install-ux@ba-native-spec.local"
git -C "$UVLESS" config user.name  "BA-Native Spec install-UX suite"

env PATH="$UVLESS_PATH" "$PKG_ROOT/install.sh" --target "$UVLESS" --offline \
  > "$TMP/uvless.out" 2>&1
UVLESS_RC=$?

# ── the pin, and why it is where it is ──
# Target behavior (install-UX L2): rc 0, with the warn line
#   "uv not found — using vendored Spec Kit v0.12.5 (offline)".
# Actual behavior, and the reason it is not the target: D88. When D88 is
# resolved, this block is the thing to re-pin — the three assertions below
# become rc 0 + the warn line + a Spec Kit on disk.
[ "$UVLESS_RC" -ne 0 ] \
  && ok "(b) install.sh refuses without uv — exit $UVLESS_RC (pinned; the L2 target is exit 0 — D88)" \
  || bad "(b) install.sh exited 0 without uv — if L2 landed, re-pin this section (D88)"
has "$TMP/uvless.out" "uv/uvx not found" \
    "(b) the refusal names uv — the accurate reason, at preflight, before any write"
absent "$UVLESS/.specify" "(b) a refused install writes nothing — no .specify/"
absent "$UVLESS/.claude"  "(b) …and no .claude/"

# The cause, held down in the installer's own text: --offline selects the Spec
# Kit *source*, and the run itself is uvx either way. This is the assertion that
# goes red the day L2 becomes reachable.
if grep -q 'uvx --from "\$SPECKIT_FROM" specify init' "$PKG_ROOT/install.sh"; then
  ok "(b) cause pinned: the --offline path still runs \`uvx --from <source> specify init\` (D88)"
else
  bad "(b) install.sh no longer runs uvx on the offline path — L2 may be reachable now; re-pin section 3 (D88)"
fi

# What a uv-less machine *can* do today, stated rather than implied: the whole BA
# payload installs, with no Spec Kit under it. A partial install, named as one.
SKIPPED_PROJ="$TMP/skip-speckit-project"
mkdir -p "$SKIPPED_PROJ"
git -C "$SKIPPED_PROJ" init -q .
env PATH="$UVLESS_PATH" "$PKG_ROOT/install.sh" --target "$SKIPPED_PROJ" --skip-speckit \
  > "$TMP/skip.out" 2>&1
SKIP_RC=$?
[ "$SKIP_RC" -eq 0 ] && ok "(b) --skip-speckit completes without uv — today's uv-free route" \
                     || bad "(b) --skip-speckit failed without uv (exit $SKIP_RC)"
isfile "$SKIPPED_PROJ/.claude/skills/ba-frame/SKILL.md" \
       "(b) …the BA payload is fully laid down by it"
isfile "$SKIPPED_PROJ/.specify/ba/manifest.md" \
       "(b) …and the manifest is generated"
SK_COUNT=$(find "$SKIPPED_PROJ/.claude/skills" -maxdepth 1 -mindepth 1 -type d -name 'speckit-*' 2>/dev/null | wc -l | tr -d ' ')
[ "$SK_COUNT" -eq 0 ] && ok "(b) …with no Spec Kit under it — what the uv-free route costs, named" \
                      || bad "(b) --skip-speckit produced $SK_COUNT speckit-* skills — it should produce none"

# ── 4 · (d)(e) bootstrap on a uv-less machine — D88, resolved one layer up ───
#
# Section 3's PATH, and bootstrap on top of it. The uv installer is substituted
# through BNS_UV_INSTALLER — the hook exists so this suite never curls astral.sh
# and never writes to the developer's real ~/.local/bin. Its contract is the real
# installer's: leave a working `uv` somewhere bootstrap will find it.
#
#   (d) the hook leaves a uv  → bootstrap finds it and hands over: exit 0
#   (e) the hook leaves none  → bootstrap dies, saying so: no handover, no writes
#
# Both runs pass --skip-speckit, so what they prove is bootstrap's own step: the
# ensure runs regardless of the flags (it is unconditional by design), and (d)'s
# install then completes on the uv-free route section 3 established, rather than
# on a fake uv that could not run Spec Kit anyway.

step "4 · (d)(e) uv missing — bootstrap installs it (D88 → Option B)"

env PATH="$UVLESS_PATH" command -v uv >/dev/null 2>&1 \
  && bad "(d) uv is still reachable on the shadowed PATH — the case is not set up" \
  || ok "(d) uv is unreachable on the shadowed PATH — the machine has none"

# The stub that behaves: uv lands in $HOME/.local/bin, where astral.sh's own
# installer puts it and where bootstrap adds to PATH by hand.
STUB_OK="$TMP/uv-installer-ok.sh"
cat > "$STUB_OK" <<'STUB'
#!/usr/bin/env bash
set -eu
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/uv" <<'FAKEUV'
#!/usr/bin/env bash
printf 'uv 0.0.0-fake\n'
FAKEUV
chmod +x "$HOME/.local/bin/uv"
printf 'stub installer: wrote %s\n' "$HOME/.local/bin/uv"
STUB
chmod +x "$STUB_OK"

# The stub that does not: it runs, it exits 0, it installs nothing.
STUB_NOOP="$TMP/uv-installer-noop.sh"
cat > "$STUB_NOOP" <<'STUB'
#!/usr/bin/env bash
printf 'stub installer: installing nothing\n'
STUB
chmod +x "$STUB_NOOP"

# ── (d) the gap is closed and the install proceeds ──
UVGAP="$TMP/uvgap-project"
FAKE_HOME="$TMP/uvgap-home"
mkdir -p "$UVGAP" "$FAKE_HOME"
absent "$UVGAP/.git" "(d) the target starts as a plain, empty, non-git directory"
absent "$FAKE_HOME/.local/bin/uv" "(d) …and the fake HOME starts with no uv in it"

UVGAP_OUT="$TMP/uvgap.out"
( cd "$UVGAP" && env HOME="$FAKE_HOME" PATH="$UVLESS_PATH" \
      BNS_SOURCE="$PKG_ROOT" BNS_UV_INSTALLER="$STUB_OK" \
      bash "$PKG_ROOT/bootstrap.sh" --skip-speckit ) > "$UVGAP_OUT" 2>&1
UVGAP_RC=$?

if [ "$UVGAP_RC" -eq 0 ]; then
  ok "(d) bootstrap exits 0 on a machine with no uv"
else
  bad "(d) bootstrap exited $UVGAP_RC on a machine with no uv, expected 0"
  sed 's/^/      /' "$UVGAP_OUT" | tail -25
fi

has "$UVGAP_OUT" "uv not found — installing" \
    "(d) the gap was detected and announced before anything was installed"
isfile "$FAKE_HOME/.local/bin/uv" "(d) the installer hook ran — a uv exists where it puts one"
has "$UVGAP_OUT" "installed: $FAKE_HOME/.local/bin/uv" \
    "(d) …and bootstrap found that uv — the PATH export reaches this process"
[ -d "$UVGAP/.git" ] && ok "(d) the target is a git repository — the ensure step sits after git init" \
                     || bad "(d) no .git/ — the ensure step ran before git init, or git init did not"
has "$UVGAP_OUT" "▸ Preflight" "(d) …and install.sh ran after it — the handover happened"
isfile "$UVGAP/.claude/skills/ba-frame/SKILL.md" \
       "(d) …laying the payload down: a uv-less machine now installs"

# ── (e) the gap is not closed, and bootstrap says so ──
UVDEAD="$TMP/uvdead-project"
DEAD_HOME="$TMP/uvdead-home"
mkdir -p "$UVDEAD" "$DEAD_HOME"
absent "$UVDEAD/.git" "(e) the target starts as a plain, empty, non-git directory"

UVDEAD_OUT="$TMP/uvdead.out"
( cd "$UVDEAD" && env HOME="$DEAD_HOME" PATH="$UVLESS_PATH" \
      BNS_SOURCE="$PKG_ROOT" BNS_UV_INSTALLER="$STUB_NOOP" \
      bash "$PKG_ROOT/bootstrap.sh" --skip-speckit ) > "$UVDEAD_OUT" 2>&1
UVDEAD_RC=$?

[ "$UVDEAD_RC" -ne 0 ] && ok "(e) bootstrap refuses when the installer leaves no uv — exit $UVDEAD_RC" \
                       || bad "(e) bootstrap exited 0 with no uv installed — the re-check did not fire"
has "$UVDEAD_OUT" "uv is still not on PATH after the installer ran" \
    "(e) the refusal names what failed"
has "$UVDEAD_OUT" "$STUB_NOOP" "(e) …and which installer it ran"
has "$UVDEAD_OUT" "curl -LsSf https://astral.sh/uv/install.sh | sh" \
    "(e) …and prints the manual install command"
hasnt "$UVDEAD_OUT" "▸ Preflight" "(e) the handover never happened — install.sh was not run"
[ -d "$UVDEAD/.git" ] && ok "(e) git init had already run — that is the whole of what the target got" \
                      || bad "(e) no .git/ — the git init step did not run before the refusal"
absent "$UVDEAD/.specify" "(e) …nothing beyond it: no .specify/"
absent "$UVDEAD/.claude"  "(e) …and no .claude/"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
[ "$KEEP" -eq 1 ] && printf '  kept:\n    %s\n    %s\n    %s\n    %s\n    %s\n' \
  "$FRESH" "$UVLESS" "$SKIPPED_PROJ" "$UVGAP" "$UVDEAD"

if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the install UX: bootstrap into a fresh directory · the self-guard · install.sh without uv · bootstrap installing uv\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
