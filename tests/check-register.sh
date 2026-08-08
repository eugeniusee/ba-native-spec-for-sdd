#!/usr/bin/env bash
#
# BA-Native Spec — the BA-facing communication register (orchestrator rules §10.3).
#
# Register rule 5: a technique, stage or assertion code never renders bare to the
# BA — it carries its name. Rule 5's own examples fix the format and the sources:
# *"T-05 — Context & landscape mapping," "P-O4 — clearing confirmation."*
#
# BA-facing = the skill / agent / mirror layer, EXCEPT fenced blocks, which are
# the pinned record shapes (ledger events, evidence tables, run-log lines,
# snapshot shapes, gate JSON). Register rule 8: on conflict the shape governs.
#
#   1.  the name sources — T-01…T-18 from the catalogue index, P-O0…P-O9 from
#       orchestrator §10.1's Moment column; names verified against them, never
#       hardcoded here and never taken on adjacency alone
#   2.  the corpus — derived from the payload globs, all four render classes
#   3.  the sweep — zero bare codes in a BA-facing string
#   4.  the self-test — three seeded defects, one per render class, and the
#       fenced-block probe: the suite is not vacuous
#
# The scan joins soft-wrapped source lines into the paragraphs the BA actually
# sees (a soft wrap is invisible in the render, so adjacency is tested on the
# joined paragraph) and skips fenced blocks whole.
#
# Seeded defects are injected into a private copy of the corpus under the
# suite's temp dir. The payload is read, never written.
#
#   check-register.sh              run the suite
#   check-register.sh --self-test  run only the seeded-defect control
#   check-register.sh --list       print the derived name table and exit
#   check-register.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
DOCS="$PKG_ROOT/docs/methodology"

VERBOSE=0; ONLY_SELFTEST=0; LIST=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    --self-test) ONLY_SELFTEST=1 ;;
    --list) LIST=1 ;;
    -h|--help) sed -n '2,33p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

# ── the scanner ──────────────────────────────────────────────────────────────
#
# One helper, three modes: --list prints the derived name table, --files prints
# the corpus, and the default scans. Written out once so the suite can point it
# at the payload and then at the mutated copy.

SCAN="$TMP/register_scan.py"
cat > "$SCAN" <<'PY'
#!/usr/bin/env python3
"""Rule-5 scan — no bare technique/stage code in a BA-facing string.

Names are not hardcoded: T-01…T-18 come from the catalogue index's rows and
P-O0…P-O9 from orchestrator §10.1's Moment column, so a document rename breaks
this scan instead of drifting silently past it. Adjacency alone would accept
any word sitting after the code; the name has to be the source's name.
"""
import argparse
import re
import sys
from pathlib import Path

CODE = re.compile(r"\b(T-\d{2}|P-O\d)\b")
# the separators rule 5's examples use, plus the table-cell boundary
SEP = r"\**\s*[—–\-:(,|]?\s*\**"


def trim(name):
    """The rendered short form: the catalogue's ★ and trailing qualifier off.

    'Epics decomposition ★' → 'Epics decomposition'
    'Scope allocation (repeatable)' → 'Scope allocation'
    'Domain (conceptual) modeling' → unchanged; the parenthetical is the name.
    """
    n = re.sub(r"\s*★\s*$", "", name.strip())
    return re.sub(r"\s*\([^()]*\)\s*$", "", n).strip()


def names(docs):
    """code -> accepted name forms, verbatim from the two source documents."""
    out = {}
    idx = Path(docs, "ba-native-spec-catalogue-index.md")
    orc = Path(docs, "ba-native-spec-orchestrator-rules.md")
    for p in (idx, orc):
        if not p.is_file():
            sys.exit(f"name source missing: {p}")
    for m in re.finditer(r"^\|\s*(T-\d{2})\s*\|\s*([^|]+?)\s*\|",
                         idx.read_text(encoding="utf-8"), re.M):
        raw = re.sub(r"\s*★\s*$", "", m.group(2).strip())
        out[m.group(1)] = sorted({trim(raw), raw}, key=len)
    body = re.search(r"^### 10\.1\b.*?(?=^### 10\.2\b)",
                     orc.read_text(encoding="utf-8"), re.M | re.S)
    for m in re.finditer(r"^\|\s*(P-O\d)\s*\|\s*([^|]+?)\s*\|",
                         body.group(0) if body else "", re.M):
        out[m.group(1)] = [m.group(2).strip()]
    return out


def corpus(root):
    """The BA-facing render surface: skills · their references · agents · mirrors.

    Derived, never counted out by hand — a new skill joins the sweep by existing.
    """
    root = Path(root)
    return sorted(
        list(root.glob("payload/claude/skills/*/SKILL.md"))
        + list(root.glob("payload/claude/skills/*/references/*.md"))
        + list(root.glob("payload/claude/agents/*.md"))
        + list(root.glob("payload/mirror/*.md"))
    )


def paired(head, tail, forms):
    """True when one of the source's names sits immediately after (or before)."""
    for f in forms:
        if re.match(SEP + re.escape(f), tail, re.I):
            return True
        # 'Epics decomposition (T-17)' — the name leads, the code trails
        if re.search(re.escape(f) + r"\W{0,4}$", head, re.I):
            return True
    return False


def paragraphs(path):
    """Join soft-wrapped source lines into the strings the BA actually sees.

    A soft wrap is invisible in the render, so adjacency is tested on the joined
    paragraph. Headings, table rows and quotes are hard lines — each stands on
    its own. Fenced blocks are skipped whole: they are the pinned record shapes,
    and register rule 8 gives the shape the last word.
    """
    buf, start, fenced = [], None, False
    for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if line.lstrip().startswith("```"):
            if buf:
                yield start, " ".join(buf)
                buf, start = [], None
            fenced = not fenced
            continue
        if fenced:
            continue
        hard = (not line.strip()) or line.lstrip().startswith(("#", "|", ">"))
        if hard:
            if buf:
                yield start, " ".join(buf)
                buf, start = [], None
            if line.strip():
                yield n, line.strip()
            continue
        if start is None:
            start = n
        buf.append(line.strip())
    if buf:
        yield start, " ".join(buf)


def scan(path, table):
    for n, para in paragraphs(path):
        for m in CODE.finditer(para):
            code = m.group(1)
            if code not in table:
                continue
            if not paired(para[: m.start()], para[m.end():], table[code]):
                yield n, code, para


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", required=True)
    ap.add_argument("--docs", required=True)
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--files", action="store_true")
    a = ap.parse_args()

    table = names(a.docs)
    if a.list:
        for code in sorted(table, key=lambda c: (c[0], c)):
            print(f"{code}\t{table[code][0]}")
        return 0

    targets = corpus(a.root)
    if a.files:
        for p in targets:
            print(p.relative_to(a.root))
        return 0

    total = 0
    for p in targets:
        for n, code, para in scan(p, table):
            total += 1
            print(f"{p.relative_to(a.root)}:{n}\t{code}\t{para[:150]}")
    print(f"files={len(targets)} hits={total}")
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
PY

scan_root() { python3 "$SCAN" --root "$1" --docs "$DOCS"; }
hits_of()   { sed -n 's/^files=[0-9]* hits=\([0-9]*\)$/\1/p' "$1"; }
files_of()  { sed -n 's/^files=\([0-9]*\) hits=[0-9]*$/\1/p' "$1"; }

if [ "$LIST" -eq 1 ]; then
  python3 "$SCAN" --root "$PKG_ROOT" --docs "$DOCS" --list
  exit $?
fi

# ── 1. the name sources ──────────────────────────────────────────────────────

if [ "$ONLY_SELFTEST" -eq 0 ]; then

printf '\n▸ The name sources — the catalogue index and orchestrator §10.1, not this file\n'

python3 "$SCAN" --root "$PKG_ROOT" --docs "$DOCS" --list > "$TMP/names.txt" 2>"$TMP/names.err"
if [ -s "$TMP/names.txt" ]; then
  ok "the two source documents parse into a name table"
else
  bad "no names derived from docs/methodology/"; sed 's/^/      /' "$TMP/names.err"
fi

# the code sets, exactly — a reshaped table that yields fewer names would make
# the sweep quietly vacuous, because an unknown code is skipped
got_t="$(awk -F'\t' '$1 ~ /^T-/ {print $1}' "$TMP/names.txt" | sort | tr '\n' ' ')"
want_t="$(for i in $(seq -w 1 18); do printf 'T-%s ' "$i"; done)"
[ "$got_t" = "$want_t" ] \
  && ok "T-01…T-18 all named by the catalogue index — 18 rows, no gaps" \
  || bad "the catalogue index yields [$got_t], expected [$want_t]"

got_p="$(awk -F'\t' '$1 ~ /^P-O/ {print $1}' "$TMP/names.txt" | sort | tr '\n' ' ')"
want_p="$(for i in $(seq 0 9); do printf 'P-O%s ' "$i"; done)"
[ "$got_p" = "$want_p" ] \
  && ok "P-O0…P-O9 all named by orchestrator §10.1's Moment column — 10 rows, no gaps" \
  || bad "orchestrator §10.1 yields [$got_p], expected [$want_p]"

# rule 5's own two examples, resolved against the sources rather than asserted
named() { awk -F'\t' -v c="$2" -v n="$3" \
  'tolower($1)==tolower(c) && tolower($2)==tolower(n) {f=1} END{exit f?0:1}' "$1"; }
named "$TMP/names.txt" T-05 "Context & landscape mapping" \
  && ok "rule 5's first example resolves: T-05 — Context & landscape mapping" \
  || bad "T-05's name is not the catalogue index's"
named "$TMP/names.txt" P-O4 "clearing confirmation" \
  && ok "rule 5's second example resolves: P-O4 — clearing confirmation" \
  || bad "P-O4's name is not §10.1's Moment"

NAMES_N="$(wc -l < "$TMP/names.txt" | tr -d ' ')"

# ── 2. the corpus ────────────────────────────────────────────────────────────

printf '\n▸ The corpus — derived from the payload, every render class present\n'

python3 "$SCAN" --root "$PKG_ROOT" --docs "$DOCS" --files > "$TMP/files.txt"
COUNT="$(wc -l < "$TMP/files.txt" | tr -d ' ')"
[ "$COUNT" -gt 0 ] \
  && ok "the file set derives from the globs: $COUNT files" \
  || bad "the corpus globs matched nothing — the sweep would pass vacuously"

for class in \
  "payload/claude/skills/.*/SKILL.md|workflow and technique skills" \
  "payload/claude/skills/.*/references/.*.md|technique reference examples" \
  "payload/claude/agents/.*.md|the four personas" \
  "payload/mirror/.*.md|the mirrors"
do
  pat="${class%%|*}"; label="${class#*|}"
  n="$(grep -cE "^$pat$" "$TMP/files.txt")"
  [ "$n" -gt 0 ] \
    && ok "$label in the sweep — $n files" \
    || bad "$label contribute no files: the glob has gone stale"
done

# ── 3. the sweep ─────────────────────────────────────────────────────────────

printf '\n▸ The sweep — zero bare codes in a BA-facing string (rule 5)\n'

scan_root "$PKG_ROOT" > "$TMP/sweep.out" 2>&1
SW=$?
H="$(hits_of "$TMP/sweep.out")"; F="$(files_of "$TMP/sweep.out")"
if [ "$SW" -eq 0 ] && [ "${H:-x}" = "0" ]; then
  ok "$F files scanned, 0 bare codes — every T-nn / P-On carries its name"
else
  bad "${H:-?} bare code(s) in BA-facing strings across ${F:-?} files"
  grep -v '^files=' "$TMP/sweep.out" | sed 's/^/      /'
fi

fi  # end of the non-self-test sections

# ── 4. the self-test — the seeded defects ────────────────────────────────────

printf '\n▸ Self-test — 3 seeded defects, one per render class: the suite is not vacuous\n'

CORPUS="$TMP/corpus"
mkdir -p "$CORPUS"
( cd "$PKG_ROOT" && tar cf - payload/claude/skills payload/claude/agents payload/mirror ) \
  | ( cd "$CORPUS" && tar xf - )

scan_root "$CORPUS" > "$TMP/base.out" 2>&1
[ "$(hits_of "$TMP/base.out")" = "0" ] \
  && ok "the private copy scans clean before injection — the control starts at 0" \
  || bad "the copied corpus is not clean at 0; the control cannot be read"

D_HEAD="$CORPUS/payload/claude/skills/ba-run/SKILL.md"
D_PROSE="$CORPUS/payload/claude/agents/ba-orchestrator.md"
D_TABLE="$CORPUS/payload/mirror/AGENTS.md"

for f in "$D_HEAD" "$D_PROSE" "$D_TABLE"; do
  [ -f "$f" ] || bad "injection target missing from the copy: ${f#$CORPUS/}"
done

# one defect per render class, as the Lane B negative control ran them
printf '\n## P-O3 — the act\n' >> "$D_HEAD"
printf '\nThe orchestrator opens the run (that is P-O2) and records the result.\n' >> "$D_PROSE"
printf '\n| P-O7 | closure act |\n' >> "$D_TABLE"

scan_root "$CORPUS" > "$TMP/seeded.out" 2>&1
SEED=$?
SH="$(hits_of "$TMP/seeded.out")"
[ "$SEED" -eq 1 ] \
  && ok "the scan exits non-zero on a dirty corpus" \
  || bad "the scan exited $SEED with defects present — it does not fail"
[ "${SH:-x}" = "3" ] \
  && ok "exactly 3 hits — no more, no fewer" \
  || bad "expected exactly 3 hits, got ${SH:-?}"

for site in \
  "ba-run/SKILL.md|P-O3|the prose heading" \
  "ba-orchestrator.md|P-O2|the mid-sentence prose mention" \
  "AGENTS.md|P-O7|the table cell"
do
  where="${site%%|*}"; rest="${site#*|}"; code="${rest%%|*}"; label="${rest#*|}"
  grep -qE "^[^ ]*$where:[0-9]+	$code	" "$TMP/seeded.out" \
    && ok "$label is named, with its file and line" \
    || bad "$label was not reported at $where"
done

# restore: the pristine files back over the injected ones
for rel in payload/claude/skills/ba-run/SKILL.md \
           payload/claude/agents/ba-orchestrator.md \
           payload/mirror/AGENTS.md; do
  cp "$PKG_ROOT/$rel" "$CORPUS/$rel"
done

scan_root "$CORPUS" > "$TMP/restored.out" 2>&1
REST=$?
[ "$REST" -eq 0 ] && [ "$(hits_of "$TMP/restored.out")" = "0" ] \
  && ok "restored: back to 0 — the 3 hits were the injections and nothing else" \
  || bad "the restored corpus does not return to 0 hits"

# rule 8's boundary, probed rather than asserted: the same defect inside a fence
# is a pinned record shape, and the sweep must leave it alone
printf '\n```\n%s\n```\n' "P-O3 · P-O7 · T-05 · aspect opened" >> "$D_HEAD"
scan_root "$CORPUS" > "$TMP/fenced.out" 2>&1
[ "$(hits_of "$TMP/fenced.out")" = "0" ] \
  && ok "the same codes inside a fenced block draw no hit — rule 8: the shape governs" \
  || bad "the sweep reached into a fenced block; the pinned record shapes are not exempt"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  if [ "$ONLY_SELFTEST" -eq 1 ]; then
    printf '✓ GREEN — the register self-test: 3 seeded defects, one per render class\n'
  else
    printf '✓ GREEN — the BA-facing register: rule 5 across %s files · %s names from source · 3 seeded defects\n' \
      "${F:-?}" "${NAMES_N:-?}"
  fi
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
