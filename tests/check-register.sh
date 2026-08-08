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
#   5.  the session boundary — orchestrator §10.2 (D-O11) compiled into every
#       skill, persona and mirror, byte-identical, with its own seeded control
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

# ── 5. the session boundary — §10.2's block in every unit ────────────────────
#
# D-O11's rule ends: *"Compiled verbatim into both mirrors and into every skill's
# and persona's never-list."* Sections 1–4 hold rule 5 down; this one holds that
# sentence down. Two forms, one rule:
#
#   · skills and personas carry the **compiled block** — §10.2's boundary said in
#     the unit's own voice, naming the two commands that lift it. Pinned here
#     verbatim; every unit must match it byte for byte.
#   · the two mirrors carry §10.2's **own paragraph**, derived from source: the
#     document's line with the decision id and the trailing compile note dropped,
#     which is the whole of the compile.
#
# The unit set comes from the same globs as the corpus, never a list: a skill
# that ships without the block goes red by existing.

if [ "$ONLY_SELFTEST" -eq 0 ]; then

printf '\n▸ The session boundary — §10.2 (D-O11) in every skill, persona and mirror\n'

sha_of() { if command -v shasum >/dev/null 2>&1; then shasum -a 256; else sha256sum; fi | cut -d' ' -f1; }

BOUNDARY_HEAD='**The session boundary (framework-wide).**'
cat > "$TMP/block.txt" <<'BLOCK'
**The session boundary (framework-wide).** This is an **analysis session**. It
produces analysis artifacts only. It never produces an implementation plan, a
task list, a prototype, or code — not as a proposal, not as a "next step," not as
initiative. The boundary lifts **per feature**, and only by the pair: an
effective PASS at `/ba-gate <feature>` and a completed `/ba-handoff <feature>`.
Wanting to implement is never evidence of readiness: the only exit is the gate.
BLOCK
BLOCK_N="$(wc -l < "$TMP/block.txt" | tr -d ' ')"
BLOCK_SHA="$(sha_of < "$TMP/block.txt")"

# the pin is grounded, not free-standing: §10.2's own paragraph must exist, and
# the block's load-bearing sentences must be the document's words, not this
# file's. The compiled wording is the sha's business; the rule is the document's.
RULES="$DOCS/ba-native-spec-orchestrator-rules.md"
grep -n '^\*\*Session mode — the analysis boundary' "$RULES" | head -1 \
  | cut -d: -f1 > "$TMP/b-src-line" 2>/dev/null
B_SRC_LINE="$(cat "$TMP/b-src-line" 2>/dev/null)"
if [ -n "$B_SRC_LINE" ]; then
  sed -n "${B_SRC_LINE}p" "$RULES" > "$TMP/b-src.txt"
  ok "orchestrator §10.2 states the boundary — the block's source, line $B_SRC_LINE"
else
  : > "$TMP/b-src.txt"
  bad "orchestrator §10.2 has no 'Session mode — the analysis boundary' paragraph"
fi

# both sides are unwrapped first: a soft wrap is invisible in the render, and the
# block wraps where the document does not — section 3's reasoning, reused
flatten() { tr '\n' ' ' < "$1" | sed 's/  */ /g; s/^ //; s/ $//'; }
flatten "$TMP/b-src.txt" > "$TMP/b-src-flat.txt"
flatten "$TMP/block.txt" > "$TMP/block-flat.txt"

while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  in_src=1; in_blk=1
  grep -qF -- "$phrase" "$TMP/b-src-flat.txt" || in_src=0
  grep -qF -- "$phrase" "$TMP/block-flat.txt" || in_blk=0
  if [ "$in_src" -eq 1 ] && [ "$in_blk" -eq 1 ]; then
    ok "$label — the document's words, in the block"
  elif [ "$in_src" -eq 0 ]; then
    bad "§10.2 no longer states $label — the document moved; re-pin the block"
  else
    bad "the pinned block dropped $label — it no longer compiles §10.2"
  fi
done <<'PHRASES'
the session is an analysis session|an **analysis session**
what it never produces|It never produces an implementation plan, a task list, a prototype, or code — not as a proposal, not as a "next step," not as initiative.
the boundary lifts per feature, by the pair|The boundary lifts **per feature**, and only by the pair:
wanting is not readiness|Wanting to implement is never evidence of readiness: the only exit is the gate.
PHRASES

# ── the sweep: every skill and persona, against the pinned sha ────────────────
#
# prints one line per offender, then a summary line the caller parses — the
# scanner's contract, in bash
boundary_sweep() {
  local root="$1" sk=0 ag=0 okc=0 miss=0 alt=0 f rel s
  for f in "$root"/payload/claude/skills/*/SKILL.md "$root"/payload/claude/agents/*.md; do
    [ -f "$f" ] || continue
    case "$f" in *"/skills/"*) sk=$((sk+1)) ;; *) ag=$((ag+1)) ;; esac
    rel="${f#"$root"/}"
    if ! grep -qF -- "$BOUNDARY_HEAD" "$f"; then
      miss=$((miss+1)); printf 'missing\t%s\n' "$rel"; continue
    fi
    s="$(awk -v n="$BLOCK_N" \
      'index($0, "**The session boundary (framework-wide).**")==1 && !seen {seen=1; c=n}
       c>0 {print; c--}' "$f" | sha_of)"
    if [ "$s" = "$BLOCK_SHA" ]; then okc=$((okc+1))
    else alt=$((alt+1)); printf 'altered\t%s\t%s\n' "$rel" "$(printf '%s' "$s" | cut -c1-12)"; fi
  done
  printf 'skills=%s personas=%s ok=%s missing=%s altered=%s\n' "$sk" "$ag" "$okc" "$miss" "$alt"
}
boundary_sweep "$PKG_ROOT" > "$TMP/bnd.out"
B_SUM="$(grep '^skills=' "$TMP/bnd.out")"
B_SK="$(printf '%s' "$B_SUM"  | sed -n 's/^skills=\([0-9]*\).*/\1/p')"
B_AG="$(printf '%s' "$B_SUM"  | sed -n 's/.*personas=\([0-9]*\).*/\1/p')"
B_OK="$(printf '%s' "$B_SUM"  | sed -n 's/.*[^a-z]ok=\([0-9]*\).*/\1/p')"
B_MISS="$(printf '%s' "$B_SUM" | sed -n 's/.*missing=\([0-9]*\).*/\1/p')"
B_ALT="$(printf '%s' "$B_SUM" | sed -n 's/.*altered=\([0-9]*\)$/\1/p')"
B_UNITS=$((B_SK + B_AG))

# vacuity first, on §2's reasoning: a stale glob that matches nothing would report
# zero missing and pass
[ "$B_SK" -gt 0 ] \
  && ok "the skills glob derives a non-empty set — $B_SK skills" \
  || bad "the skills glob matched nothing: the boundary check would pass vacuously"
[ "$B_AG" -gt 0 ] \
  && ok "the personas glob derives a non-empty set — $B_AG personas" \
  || bad "the personas glob matched nothing: the boundary check would pass vacuously"

if [ "$B_MISS" = "0" ]; then
  ok "every one of the $B_UNITS units carries the boundary block — none missing"
else
  bad "$B_MISS unit(s) ship without the session boundary (§10.2's rule names every one):"
  grep '^missing' "$TMP/bnd.out" | cut -f2 | sed 's/^/      /'
fi

if [ "$B_ALT" = "0" ]; then
  ok "all $B_OK blocks are byte-identical — sha $(printf '%s' "$BLOCK_SHA" | cut -c1-12)"
else
  bad "$B_ALT unit(s) carry an altered block — the text is compiled verbatim, not paraphrased:"
  grep '^altered' "$TMP/bnd.out" | awk -F'\t' '{printf "      %s  (%s…)\n", $2, $3}'
fi

# ── the mirrors: §10.2's paragraph, derived from the document ────────────────

python3 - "$RULES" > "$TMP/mirror-expect.txt" 2>"$TMP/mirror-expect.err" <<'PY'
import pathlib, re, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
src = [l for l in txt.splitlines()
       if l.startswith("**Session mode — the analysis boundary")]
if not src:
    sys.exit(1)
line = src[0]
# the two transformations the compile applies, and the only two
line = line.replace("(framework-wide; D-O11)", "(framework-wide)")
line = re.sub(r"\s*\*Compiled verbatim[^*]*\*\s*$", "", line)
print(re.sub(r"\s+", " ", line).strip())
PY
if [ -s "$TMP/mirror-expect.txt" ]; then
  ok "the mirrors' expected text derives from §10.2 — decision id and compile note dropped"
else
  bad "§10.2's paragraph does not derive: the mirrors cannot be checked from source"
  sed 's/^/      /' "$TMP/mirror-expect.err"
fi

for m in payload/mirror/AGENTS.md payload/mirror/claude-block.md; do
  awk '/^\*\*Session mode — the analysis boundary/ {f=1} f && /^$/ {exit} f {print}' \
    "$PKG_ROOT/$m" > "$TMP/mirror-raw.txt"
  flatten "$TMP/mirror-raw.txt" > "$TMP/mirror-got.txt"
  if [ ! -s "$TMP/mirror-got.txt" ]; then
    bad "$m carries no session-boundary paragraph — §10.2 names both mirrors"
  elif [ "$(cat "$TMP/mirror-expect.txt")" = "$(cat "$TMP/mirror-got.txt")" ]; then
    ok "$m carries §10.2's paragraph, word for word from the document"
  else
    bad "$m diverges from §10.2's paragraph:"
    diff "$TMP/mirror-expect.txt" "$TMP/mirror-got.txt" | sed 's/^/      /' | head -8
  fi
done

# ── the control: a unit without the block, and a unit that paraphrased it ─────
#
# same discipline as section 4 — the assertion above is worth nothing unless it
# is shown to fail. Injected into a private copy; the payload is read, never
# written.

BND="$TMP/bnd-corpus"
mkdir -p "$BND"
( cd "$PKG_ROOT" && tar cf - payload/claude/skills payload/claude/agents ) \
  | ( cd "$BND" && tar xf - )

boundary_sweep "$BND" > "$TMP/bnd-clean.out"
[ "$(sed -n 's/.*missing=\([0-9]*\).*/\1/p' "$TMP/bnd-clean.out")" = "0" ] \
  && [ "$(sed -n 's/.*altered=\([0-9]*\)$/\1/p' "$TMP/bnd-clean.out")" = "0" ] \
  && ok "the private copy starts clean — 0 missing, 0 altered" \
  || bad "the boundary corpus copy is not clean before injection"

D_MISS="$BND/payload/claude/skills/ba-t01/SKILL.md"
D_ALT="$BND/payload/claude/agents/ba-gate.md"
python3 -c 'import pathlib,sys
p=pathlib.Path(sys.argv[1]); ls=p.read_text(encoding="utf-8").splitlines()
i=[n for n,l in enumerate(ls) if l.startswith("**The session boundary")][0]
p.write_text("\n".join(ls[:i]).rstrip("\n")+"\n", encoding="utf-8")' "$D_MISS"
python3 -c 'import pathlib,sys
p=pathlib.Path(sys.argv[1])
t=p.read_text(encoding="utf-8").replace("the only exit is the gate.","the only way out is the gate.")
p.write_text(t, encoding="utf-8")' "$D_ALT"

boundary_sweep "$BND" > "$TMP/bnd-dirty.out"
[ "$(sed -n 's/.*missing=\([0-9]*\).*/\1/p' "$TMP/bnd-dirty.out")" = "1" ] \
  && ok "a skill shipped without the block is caught — exactly 1 missing" \
  || bad "removing the block from ba-t01 did not register as missing"
[ "$(sed -n 's/.*altered=\([0-9]*\)$/\1/p' "$TMP/bnd-dirty.out")" = "1" ] \
  && ok "a persona that paraphrased one clause is caught — exactly 1 altered" \
  || bad "rewording ba-gate's block did not register as altered"
grep -q '^missing	payload/claude/skills/ba-t01/SKILL.md$' "$TMP/bnd-dirty.out" \
  && ok "…and the missing one is named: payload/claude/skills/ba-t01/SKILL.md" \
  || bad "the missing unit is not named in the report"
grep -q '^altered	payload/claude/agents/ba-gate.md	' "$TMP/bnd-dirty.out" \
  && ok "…and the altered one is named: payload/claude/agents/ba-gate.md" \
  || bad "the altered unit is not named in the report"

fi  # end of section 5

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  if [ "$ONLY_SELFTEST" -eq 1 ]; then
    printf '✓ GREEN — the register self-test: 3 seeded defects, one per render class\n'
  else
    printf '✓ GREEN — the BA-facing register: rule 5 across %s files · %s names from source · §10.2 in %s units + 2 mirrors · 5 seeded defects\n' \
      "${F:-?}" "${NAMES_N:-?}" "${B_UNITS:-?}"
  fi
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
