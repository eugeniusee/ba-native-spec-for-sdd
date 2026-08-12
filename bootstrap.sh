#!/usr/bin/env bash
#
# BA-Native Spec — bootstrap.
#
# Level 1 of the install UX: one line, no clone, no GitHub auth.
#
#   curl -fsSL https://raw.githubusercontent.com/eugeniusee/ba-native-spec-for-sdd/main/bootstrap.sh | bash
#
# It fetches the package tarball into a temp workdir, `git init`s the current
# directory if it is not a repository yet, and hands over to the package's own
# install.sh with `--target "$PWD"`. Remaining arguments pass through to the
# installer untouched, its output is surfaced verbatim, and this script exits
# with its exit code.
#
#   curl -fsSL <url> | bash                     install into $PWD
#   curl -fsSL <url> | bash -s -- --offline     …passing installer options
#   BNS_SOURCE=/path/to/checkout bash bootstrap.sh
#                                               …from a local checkout (test hook)
#   BNS_UV_INSTALLER=/path/to/script bash bootstrap.sh
#                                               …substituting the uv installer (test hook)
#
# The only thing this script installs itself is `uv`, and only on a machine that
# has none: it is a prerequisite of install.sh on every path (D88), and this is
# the one layer that can close that gap honestly — the package was just
# downloaded over the network, so the network is a fact of this path rather than
# an assumption about the machine. Nothing else here is bootstrap's: everything
# the target ends up with is install.sh's work, and the rest of what bootstrap
# owns is making install.sh reachable without a clone, and making $PWD a
# repository so the installer's own git guard — which stays exactly as strict as
# it was — is satisfied honestly.

set -euo pipefail

# ---------------------------------------------------------------- constants --

REPO_SLUG="eugeniusee/ba-native-spec-for-sdd"
REPO_BRANCH="main"
TARBALL_URL="https://github.com/$REPO_SLUG/archive/refs/heads/$REPO_BRANCH.tar.gz"

TARGET="$PWD"

# ------------------------------------------------------------------ helpers --

say()  { printf '  %s\n' "$*"; }
step() { printf '\n\033[1m▸ %s\033[0m\n' "$*"; }
warn() { printf '  \033[33m! %s\033[0m\n' "$*" >&2; }
die()  { printf '\n\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

usage() {
  cat <<EOF
BA-Native Spec — bootstrap: install into the current directory, no clone needed.

  curl -fsSL https://raw.githubusercontent.com/$REPO_SLUG/$REPO_BRANCH/bootstrap.sh | bash

  bootstrap.sh [installer options]

It downloads the package, initializes a git repository here if there is not one
already, installs uv if the machine has none, and runs the package installer
against this directory. Every option is passed straight through to install.sh —
run it with --help once installed, or see the repo, for the full list (--offline
· --dry-run · --force-speckit · --skip-speckit).

Environment:
  BNS_SOURCE         use this local checkout instead of downloading (test hook)
  BNS_UV_INSTALLER   run this script instead of astral.sh's uv installer
                     (test hook; same contract — it must leave a working uv)

To pass installer options through the one-liner, use bash -s:

  curl -fsSL <url> | bash -s -- --offline
EOF
}

# --help is answered here rather than passed through: the installer's own usage
# is one download and one `git init` away, and neither is a side effect anybody
# asked for by typing --help.
for a in "$@"; do
  case "$a" in -h|--help) usage; exit 0 ;; esac
done

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

printf '\n\033[1mBA-Native Spec — bootstrap\033[0m\n'
say "target: $TARGET"

# ---------------------------------------------------------------- self-guard --

# The package repo builds the payload; it is not a place to install the payload
# into. The triple is the detection: VERSION + payload/ + install.sh together
# are this repo and nothing else.
if [ -f "$TARGET/VERSION" ] && [ -d "$TARGET/payload" ] && [ -f "$TARGET/install.sh" ]; then
  die "this is the BA-Native Spec package repo itself — bootstrap installs INTO a project.
    Detected here: VERSION + payload/ + install.sh
    cd to the project you want the framework in, then run bootstrap there.
    (To install from this checkout: ./install.sh --target /path/to/project)"
fi

# ----------------------------------------------------------------- the source --

step "Source"

if [ -n "${BNS_SOURCE:-}" ]; then
  [ -d "$BNS_SOURCE" ] || die "BNS_SOURCE is not a directory: $BNS_SOURCE"
  SRC="$(cd "$BNS_SOURCE" && pwd)"
  say "local checkout: $SRC (BNS_SOURCE)"
else
  command -v curl >/dev/null 2>&1 || die "curl not found — needed to fetch the package."
  command -v tar  >/dev/null 2>&1 || die "tar not found — needed to unpack the package."
  say "fetching $TARBALL_URL"
  curl -fsSL "$TARBALL_URL" -o "$WORKDIR/package.tar.gz" \
    || die "download failed: $TARBALL_URL
    Check the network, or clone the repo and run install.sh directly."
  mkdir -p "$WORKDIR/unpack"
  tar -xzf "$WORKDIR/package.tar.gz" -C "$WORKDIR/unpack" \
    || die "could not unpack the downloaded archive."
  SRC="$(find "$WORKDIR/unpack" -maxdepth 1 -mindepth 1 -type d | head -1)"
  [ -n "$SRC" ] || die "the archive unpacked to nothing — no package directory inside."
  say "downloaded: $REPO_SLUG@$REPO_BRANCH"
fi

[ -f "$SRC/install.sh" ] || die "no install.sh in the package source: $SRC"
[ -f "$SRC/VERSION" ]    || die "no VERSION in the package source: $SRC — is that a BA-Native Spec checkout?"
say "package $(tr -d '[:space:]' < "$SRC/VERSION") ✓"

# ------------------------------------------------------------------ the repo --

# install.sh requires a git repository and that requirement is not relaxed:
# bootstrap satisfies it here instead, out loud.
step "Repository"

command -v git >/dev/null 2>&1 || die "git not found — the framework's adapter needs plain git."

if git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  say "already a git repository ✓"
else
  say "not a git repository yet — running: git init"
  git -C "$TARGET" init -q || die "git init failed in $TARGET"
  say "initialized ✓"
fi

# --------------------------------------------------------------------- uv --

# install.sh's preflight requires uv, and requires it on both the network and the
# --offline path — `--offline` selects where the Spec Kit *source* comes from,
# and the run itself is `uvx --from <source> specify init` either way (D88). That
# requirement is not relaxed here either: the gap is closed by installing uv,
# with the machine's own package manager left alone and astral.sh's own installer
# doing the work.
#
# The step is unconditional. uv is a documented prerequisite of the package, and
# reading the pass-through flags to guess whether this particular run will reach
# uvx would be a second, drifting copy of the installer's preflight.
step "uv"

if command -v uv >/dev/null 2>&1; then
  say "already installed ✓"
else
  if [ -n "${BNS_UV_INSTALLER:-}" ]; then
    UV_INSTALLER="$BNS_UV_INSTALLER (BNS_UV_INSTALLER)"
    say "uv not found — installing, one-time (BNS_UV_INSTALLER)"
    set +e
    sh "$BNS_UV_INSTALLER" < /dev/null
    uv_rc=$?
    set -e
  else
    UV_INSTALLER="https://astral.sh/uv/install.sh"
    say "uv not found — installing via astral.sh, one-time"
    set +e
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv_rc=$?
    set -e
  fi

  # The installer puts uv in ~/.local/bin and edits shell rc files so later
  # shells find it. This process will never re-source them, so that directory is
  # put on PATH here, by hand, for this run and the installer it hands over to.
  export PATH="$HOME/.local/bin:$PATH"

  # One installer, one re-check, and a refusal that names what happened. No
  # retry: a second identical run is not new information.
  command -v uv >/dev/null 2>&1 \
    || die "uv is still not on PATH after the installer ran — bootstrap stops here.
    installer: $UV_INSTALLER (exit $uv_rc)
    looked on PATH, \$HOME/.local/bin included
    Install uv by hand, then run this again:
      curl -LsSf https://astral.sh/uv/install.sh | sh"
  say "installed: $(command -v uv) ✓"
fi

# --------------------------------------------------------------- the handover --

# From here the installer speaks for itself: its output is not captured, not
# filtered and not summarized, and its exit code is the one we leave with.
#
# The handover is a child process, not `exec`: the unpacked package it is reading
# from lives in $WORKDIR, and only a returning child lets the cleanup trap fire.
# The contract the caller sees is unchanged — verbatim output, installer's code.
#
# stdin is closed for the child because the flagship invocation is `curl | bash`,
# where the script itself is on stdin; nothing downstream may read from it.
set +e
bash "$SRC/install.sh" --target "$TARGET" "$@" < /dev/null
rc=$?
set -e

exit "$rc"
