#!/usr/bin/env bash
#
# BA-Native Spec — installer.
#
# Build plan §2.7: preflight → pinned `specify init` → overlay
# payload/specify-overlay/ → copy payload/claude/ → set aside Spec Kit's default
# constitution → create memory/scope/ → write mirror files/blocks → generate
# ba/manifest.md → print the next step.
#
# Idempotent: a re-run replaces installer-laid (⬒) files and the fenced mirror
# blocks only. It never touches runtime-born (◇) content, the five ledgers, or
# specs/.
#
# D-P2-6: directories and templates only, ZERO content stubs — `absent` and
# `stubbed` are the same AT/CC-H hole, and a field of installer-made stubs would
# pollute the evidence triggers.

set -euo pipefail

# ---------------------------------------------------------------- constants --

SPECKIT_PIN="v0.12.5"                       # D-P2-8
SPECKIT_REPO="https://github.com/github/spec-kit.git"
SPECKIT_INTEGRATION="claude"                # D-P2-9
PYTHON_MIN="3.11"                           # Spec Kit's own floor (D-P2-7)

PKG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_VERSION="$(tr -d '[:space:]' < "$PKG_ROOT/VERSION")"

TARGET="$PWD"
OFFLINE=0
DRY_RUN=0
FORCE_SPECKIT=0
SKIP_SPECKIT=0

# ------------------------------------------------------------------ helpers --

say()  { printf '  %s\n' "$*"; }
step() { printf '\n\033[1m▸ %s\033[0m\n' "$*"; }
warn() { printf '  \033[33m! %s\033[0m\n' "$*" >&2; }
die()  { printf '\n\033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
BA-Native Spec — install into a project.

  install.sh [options]

Options:
  --target <dir>    Project to install into (default: current directory)
  --offline         Use vendor/spec-kit-<pin>.zip instead of the network
  --force-speckit   Re-run `specify init` even if Spec Kit is already present
  --skip-speckit    Overlay only; do not touch Spec Kit (for re-overlays)
  --dry-run         Report what would happen; write nothing
  -h, --help        This message

Requires: git · python3 >= 3.11 · uv (for the pinned Spec Kit install).
The target must already be a git repository.
EOF
}

run() { if [ "$DRY_RUN" -eq 1 ]; then say "[dry-run] $*"; else "$@"; fi; }

# --------------------------------------------------------------- arg parsing --

while [ $# -gt 0 ]; do
  case "$1" in
    --target)        TARGET="${2:?--target needs a directory}"; shift 2 ;;
    --offline)       OFFLINE=1; shift ;;
    --force-speckit) FORCE_SPECKIT=1; shift ;;
    --skip-speckit)  SKIP_SPECKIT=1; shift ;;
    --dry-run)       DRY_RUN=1; shift ;;
    -h|--help)       usage; exit 0 ;;
    *)               die "unknown option: $1  (try --help)" ;;
  esac
done

[ -d "$TARGET" ] || die "target is not a directory: $TARGET"
TARGET="$(cd "$TARGET" && pwd)"

printf '\n\033[1mBA-Native Spec %s\033[0m — installing into %s\n' "$PKG_VERSION" "$TARGET"

# ------------------------------------------------------------------ preflight --

step "Preflight"

command -v git >/dev/null 2>&1 || die "git not found — the framework's adapter needs plain git."
git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1 \
  || die "not a git repository: $TARGET
    The framework installs into a project under version control.
    Run:  git -C '$TARGET' init"
say "git repository ✓"

command -v python3 >/dev/null 2>&1 || die "python3 not found — required (>= $PYTHON_MIN)."
python3 - "$PYTHON_MIN" <<'PY' || die "python3 is older than the required minimum."
import sys
need = tuple(int(p) for p in sys.argv[1].split("."))
sys.exit(0 if sys.version_info[:len(need)] >= need else 1)
PY
say "python3 $(python3 -c 'import sys;print(".".join(map(str,sys.version_info[:3])))') ✓"

if [ "$SKIP_SPECKIT" -eq 0 ]; then
  command -v uvx >/dev/null 2>&1 \
    || die "uv/uvx not found — needed for the pinned Spec Kit install.
    Install uv (https://docs.astral.sh/uv/) or re-run with --skip-speckit."
  say "uv $(uv --version 2>/dev/null | awk '{print $2}') ✓"
fi

for d in payload/claude payload/specify-overlay payload/mirror; do
  [ -d "$PKG_ROOT/$d" ] || die "package is incomplete — missing $d"
done
say "package payload ✓"

# ------------------------------------------------------------------ Spec Kit --

step "Spec Kit $SPECKIT_PIN"

speckit_present() { [ -f "$TARGET/.specify/templates/plan-template.md" ]; }

CONSTITUTION="$TARGET/.specify/memory/constitution.md"
DEFAULT_CONSTITUTION="$TARGET/.specify/ba/speckit-defaults/constitution.md"
CONST_STASH=""
SPECKIT_RAN=0

if [ "$SKIP_SPECKIT" -eq 1 ]; then
  say "skipped (--skip-speckit)"
elif speckit_present && [ "$FORCE_SPECKIT" -eq 0 ]; then
  say "already initialized — left untouched (use --force-speckit to re-run init)"
else
  # `specify init --force` overwrites .specify/templates/ and .specify/scripts/
  # — and would take constitution.md with them. T-15's constitution is authored
  # content, not ours to lose: stash it across the init and decide afterwards.
  if [ -f "$CONSTITUTION" ] && [ "$DRY_RUN" -eq 0 ]; then
    CONST_STASH="$(mktemp)"
    cp "$CONSTITUTION" "$CONST_STASH"
  fi
  if [ "$OFFLINE" -eq 1 ]; then
    ZIP="$PKG_ROOT/vendor/spec-kit-$SPECKIT_PIN.zip"
    [ -f "$ZIP" ] || die "offline install needs $ZIP — see vendor/README.md"
    command -v unzip >/dev/null 2>&1 || die "unzip not found (needed for --offline)"
    UNPACK="$(mktemp -d)"
    trap 'rm -rf "$UNPACK"' EXIT
    run unzip -q "$ZIP" -d "$UNPACK"
    SRC="$(find "$UNPACK" -maxdepth 1 -mindepth 1 -type d | head -1)"
    say "source: $ZIP (offline fallback)"
    SPECKIT_FROM="$SRC"
  else
    say "source: git+$SPECKIT_REPO@$SPECKIT_PIN"
    SPECKIT_FROM="git+$SPECKIT_REPO@$SPECKIT_PIN"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    say "[dry-run] uvx --from $SPECKIT_FROM specify init --here --force \\"
    say "[dry-run]   --integration $SPECKIT_INTEGRATION --script sh --ignore-agent-tools"
  else
    ( cd "$TARGET" && uvx --from "$SPECKIT_FROM" specify init \
        --here --force \
        --integration "$SPECKIT_INTEGRATION" \
        --script sh \
        --ignore-agent-tools ) \
      || die "specify init failed. Re-run with --offline once vendor/spec-kit-$SPECKIT_PIN.zip is in place."
    say "initialized ✓"
    SPECKIT_RAN=1
  fi
fi

# ------------------------------------------ set aside Spec Kit's constitution --

# D-P2-6: `constitution.md` is born by T-15 from real Band-1 evidence. Spec Kit's
# default would be an installer-made stub sitting exactly where AT-RQ-1 and
# CC-H-01 look — so it is moved out of the way, once, and kept for reference.
step "Spec Kit defaults"

DEFAULTS_DIR="$TARGET/.specify/ba/speckit-defaults"
run mkdir -p "$DEFAULTS_DIR"

# Is a given file Spec Kit's untouched default rather than authored content?
# At the pinned v0.12.5 the default `memory/constitution.md` is byte-identical to
# Spec Kit's own `templates/constitution-template.md` — verified, not assumed.
# A copy we already set aside counts too, so a re-lay is recognized.
# Anything else is content: T-15's constitution, or the project's own.
is_speckit_default() {
  [ -f "$1" ] || return 1
  cmp -s "$1" "$TARGET/.specify/templates/constitution-template.md" && return 0
  [ -f "$DEFAULTS_DIR/constitution.md" ] && cmp -s "$1" "$DEFAULTS_DIR/constitution.md" && return 0
  return 1
}

if [ "$DRY_RUN" -eq 1 ]; then
  say "[dry-run] set aside Spec Kit's default constitution.md"
else
  # 1. Authored content never loses to an init. If a real constitution was in
  #    place before init and init replaced or removed it, put it back.
  if [ -n "$CONST_STASH" ]; then
    if ! is_speckit_default "$CONST_STASH"; then
      if [ ! -f "$CONSTITUTION" ] || ! cmp -s "$CONST_STASH" "$CONSTITUTION"; then
        cp "$CONST_STASH" "$CONSTITUTION"
        say "authored constitution.md restored after specify init ✓"
      fi
    fi
    rm -f "$CONST_STASH"
  fi

  # 2. Rule on whatever now sits at the path.
  if [ ! -f "$CONSTITUTION" ]; then
    if [ -f "$DEFAULTS_DIR/constitution.md" ]; then
      say "memory/constitution.md correctly absent — default already set aside"
    else
      say "no default constitution to set aside"
    fi
  elif is_speckit_default "$CONSTITUTION"; then
    # An installer-made stub at exactly the path AT-RQ-1 and CC-H-01 read is the
    # hole D-P2-6 forbids: `absent` and `stubbed` are the same hole, and a stub
    # here would pollute the evidence trigger. T-15 births the real file.
    if [ -f "$DEFAULTS_DIR/constitution.md" ] && cmp -s "$CONSTITUTION" "$DEFAULTS_DIR/constitution.md"; then
      rm -f "$CONSTITUTION"
      say "default constitution.md removed — copy already in .specify/ba/speckit-defaults/"
    else
      mv "$CONSTITUTION" "$DEFAULTS_DIR/constitution.md"
      say "default constitution.md set aside → .specify/ba/speckit-defaults/ (born by /ba-run t15)"
    fi
  else
    say "authored constitution.md left untouched ✓"
  fi
fi

# -------------------------------------------------------------------- overlay --

step "Overlay"

# .specify/ delta: the spec-template override + the whole ba/ namespaced home.
# Spec Kit upgrades never touch .specify/ba/; the spec-template override is the
# one deliberate exception and is re-overlaid at any pin bump.
run mkdir -p "$TARGET/.specify"
if [ "$DRY_RUN" -eq 1 ]; then
  say "[dry-run] copy payload/specify-overlay/ → .specify/"
else
  ( cd "$PKG_ROOT/payload/specify-overlay" \
      && find . -type f ! -name '.gitkeep' -print0 \
      | while IFS= read -r -d '' f; do
          mkdir -p "$TARGET/.specify/$(dirname "$f")"
          cp "$f" "$TARGET/.specify/$f"
        done )
  # directories carry over even when empty (D-P2-6: dirs, not stubs)
  ( cd "$PKG_ROOT/payload/specify-overlay" && find . -type d -print0 \
      | while IFS= read -r -d '' d; do mkdir -p "$TARGET/.specify/$d"; done )
fi
say "spec-template override + .specify/ba/ ✓"

# .claude/ : agents + skills. Our units are removed first so a re-install is a
# true ⬒-replacement — a unit deleted from the package does not linger.
run mkdir -p "$TARGET/.claude/agents" "$TARGET/.claude/skills"
if [ "$DRY_RUN" -eq 1 ]; then
  say "[dry-run] replace .claude/agents/ba-*.md and .claude/skills/ba-*/"
else
  find "$TARGET/.claude/agents" -maxdepth 1 -name 'ba-*.md' -exec rm -f {} + 2>/dev/null || true
  find "$TARGET/.claude/skills" -maxdepth 1 -type d -name 'ba-*' -exec rm -rf {} + 2>/dev/null || true
  ( cd "$PKG_ROOT/payload/claude" \
      && find . -type f ! -name '.gitkeep' -print0 \
      | while IFS= read -r -d '' f; do
          mkdir -p "$TARGET/.claude/$(dirname "$f")"
          cp "$f" "$TARGET/.claude/$f"
        done )
fi
N_AGENTS=$(find "$PKG_ROOT/payload/claude/agents" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
N_SKILLS=$(find "$PKG_ROOT/payload/claude/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
say "agents: $N_AGENTS · skills: $N_SKILLS ✓"

# Runtime homes: directories only. The scope/ dir exists so Tier-1 has a
# destination; its contents are born by /ba-run tier1.
run mkdir -p "$TARGET/.specify/memory/scope"
run mkdir -p "$TARGET/specs"
say "memory/scope/ · specs/ ✓"

# --------------------------------------------------------------------- mirror --

step "Portability mirror"

if [ "$DRY_RUN" -eq 1 ]; then
  say "[dry-run] AGENTS.md + CLAUDE.md fenced block"
else
  python3 - "$TARGET" "$PKG_ROOT/payload/mirror/AGENTS.md" "$PKG_ROOT/payload/mirror/claude-block.md" <<'PY'
import pathlib, sys

target, agents_src, claude_src = (pathlib.Path(a) for a in sys.argv[1:4])
BEGIN, END = "<!-- ba-native-spec:begin -->", "<!-- ba-native-spec:end -->"


def merge(dest: pathlib.Path, block: str) -> str:
    """Create the file, or replace only our fenced block inside it.

    Existing project content is never overwritten: the block is append-only on
    first contact and replace-in-place afterwards.
    """
    block = block.strip("\n")
    if not dest.exists():
        dest.write_text(block + "\n", encoding="utf-8")
        return "created"
    text = dest.read_text(encoding="utf-8")
    if BEGIN in text and END in text:
        head, rest = text.split(BEGIN, 1)
        _, tail = rest.split(END, 1)
        dest.write_text(head + block + tail, encoding="utf-8")
        return "block replaced"
    sep = "" if text.endswith("\n\n") else ("\n" if text.endswith("\n") else "\n\n")
    dest.write_text(text + sep + "\n" + block + "\n", encoding="utf-8")
    return "block appended"


for dest, src in ((target / "AGENTS.md", agents_src), (target / "CLAUDE.md", claude_src)):
    print(f"  {dest.name}: {merge(dest, src.read_text(encoding='utf-8'))} ✓")
PY
fi

# ------------------------------------------------------------------- manifest --

step "Manifest"

if [ "$DRY_RUN" -eq 1 ]; then
  say "[dry-run] generate .specify/ba/manifest.md"
else
  python3 - "$TARGET" "$PKG_ROOT" "$PKG_VERSION" "$SPECKIT_PIN" "$SPECKIT_REPO" "$SPECKIT_INTEGRATION" <<'PY'
import hashlib, pathlib, re, sys
from datetime import date

target, pkg_root = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
pkg_version, speckit_pin, speckit_repo, integration = sys.argv[3:7]

# --- source-doc version vector -------------------------------------------------
# Read from the vendored docs themselves, so the vector can never drift from
# what the payload was actually compiled against.
DOCS = [
    ("definition & plan",        "ba-native-spec-definition-and-plan-v2.md"),
    ("writing standard",         "ba-native-spec-writing-standard.md"),
    ("completeness contract",    "ba-native-spec-completeness-contract.md"),
    ("elicitation techniques",   "ba-native-spec-elicitation-techniques.md"),
    ("gate definition",          "ba-native-spec-gate-definition.md"),
    ("orchestrator rules",       "ba-native-spec-orchestrator-rules.md"),
    ("Wave-2 sequencing plan",   "ba-native-spec-wave2-sequencing-plan.md"),
    ("catalogue index",          "ba-native-spec-catalogue-index.md"),
    ("catalogue b1",             "ba-native-spec-catalogue-b1.md"),
    ("catalogue b2",             "ba-native-spec-catalogue-b2.md"),
    ("catalogue b3",             "ba-native-spec-catalogue-b3.md"),
    ("catalogue b4",             "ba-native-spec-catalogue-b4.md"),
    ("catalogue b5",             "ba-native-spec-catalogue-b5.md"),
    ("catalogue b6",             "ba-native-spec-catalogue-b6.md"),
    ("Phase-2 build plan",       "ba-native-spec-phase2-build-plan.md"),
]
VERSION_RE = re.compile(r"\bv(\d+\.\d+)\b")


def doc_version(path: pathlib.Path) -> str:
    if not path.exists():
        return "MISSING"
    head = path.read_text(encoding="utf-8").splitlines()[:4]
    for line in head:
        m = VERSION_RE.search(line)
        if m:
            return "v" + m.group(1)
    return "unversioned"


vector = [(label, doc_version(pkg_root / "docs" / "methodology" / fn)) for label, fn in DOCS]

# --- installed-file hash list --------------------------------------------------
# The ⬒ set only: what the installer laid down. Runtime-born (◇) content, the
# ledgers, and specs/ are deliberately absent — hashing them here would make the
# manifest rot on the first real act.
installed = []
for root, pattern in (
    (target / ".claude" / "agents", "ba-*.md"),
    (target / ".claude" / "skills", "ba-*/**/*"),
    (target / ".specify" / "ba", "**/*"),
    (target / ".specify" / "templates", "spec-template.md"),
):
    if root.exists():
        for p in sorted(root.glob(pattern)):
            if p.is_file() and p.name != ".gitkeep":
                installed.append(p)
for name in ("AGENTS.md", "CLAUDE.md"):
    p = target / name
    if p.exists():
        installed.append(p)

manifest_path = target / ".specify" / "ba" / "manifest.md"
installed = [p for p in installed if p != manifest_path]

rows = []
for p in installed:
    h = hashlib.sha256(p.read_bytes()).hexdigest()
    rows.append((str(p.relative_to(target)), h))
rows.sort()

# --- write ---------------------------------------------------------------------
w = max((len(r[0]) for r in rows), default=40)
out = [
    "# BA-Native Spec — install manifest",
    "",
    "GENERATED by install.sh — do not edit. Regenerated at every install.",
    "",
    "| Field | Value |",
    "|---|---|",
    f"| Package version | {pkg_version} |",
    f"| Installed | {date.today().isoformat()} |",
    f"| Spec Kit pin | {speckit_pin} ({speckit_repo}) |",
    f"| Spec Kit integration | {integration} |",
    f"| Installed files | {len(rows)} |",
    "",
    "## Source-doc version vector",
    "",
    "The methodology versions this payload was compiled from. A doc bump",
    "recompiles exactly the units anchored to it (build plan §3.5) and lands",
    "here as a new vector.",
    "",
    "| Document | Version |",
    "|---|---|",
]
out += [f"| {label} | {ver} |" for label, ver in vector]
out += [
    "",
    "## Installed files — sha256",
    "",
    "The ⬒ set: everything install.sh laid down. Runtime-born (◇) content, the",
    "five ledgers, and specs/ are deliberately not listed — they are authored,",
    "not installed.",
    "",
    "```",
]
out += [f"{path.ljust(w)}  {h}" for path, h in rows]
out += ["```", ""]

manifest_path.parent.mkdir(parents=True, exist_ok=True)
manifest_path.write_text("\n".join(out), encoding="utf-8")
print(f"  .specify/ba/manifest.md — {len(rows)} files hashed, "
      f"{len(vector)}-doc vector ✓")
PY
fi

# ----------------------------------------------------------------- next steps --

cat <<EOF

$(printf '\033[1m✓ BA-Native Spec %s installed\033[0m' "$PKG_VERSION")

  Next: open Claude Code in this project and run

      /ba-frame

  — Band-1 entry: it initializes the two aspect ledgers and confirms the
  discovery canvas. Everything else follows from the ledger head (/ba-status).

  Nothing under .specify/memory/ or canvas.md exists yet, by design: those
  artifacts are born by the acts that produce them, never by the installer.

EOF
