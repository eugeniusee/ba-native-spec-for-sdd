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
#
# This script installs nothing of its own. Everything the target ends up with is
# install.sh's work; the only thing bootstrap owns is making install.sh reachable
# without a clone, and making $PWD a repository so the installer's own git guard
# — which stays exactly as strict as it was — is satisfied honestly.

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
already, and runs the package installer against this directory. Every option is
passed straight through to install.sh — run it with --help once installed, or
see the repo, for the full list (--offline · --dry-run · --force-speckit ·
--skip-speckit).

Environment:
  BNS_SOURCE   use this local checkout instead of downloading (test hook)

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
