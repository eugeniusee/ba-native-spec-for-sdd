#!/usr/bin/env bash
#
# BA-Native Spec — the BA-facing communication register (orchestrator rules §10.3).
#
# Register rule 5: a technique, stage or assertion code never renders bare to the
# BA — it carries its name, in canonical form. Rule 5's own examples fix the
# format and the sources: *"T-05 — Context & landscape mapping," "P-O4 — clearing
# confirmation."* A lowercase or hyphenless variant is the same defect said
# differently (pilot R0, D1) and the sweep catches both.
#
# BA-facing = the skill / agent / mirror layer, EXCEPT fenced blocks, which are
# the pinned record shapes (ledger events, evidence tables, run-log lines,
# snapshot shapes, gate JSON). Register rule 8: on conflict the shape governs —
# and section 6 holds one of those shapes to the document byte for byte.
#
#   1.  the name sources — T-01…T-18 from the catalogue index, P-O0…P-O9 from
#       orchestrator §10.1's Moment column; names verified against them, never
#       hardcoded here and never taken on adjacency alone
#   2.  the corpus — derived from the payload globs, all four render classes
#   3.  the sweep — zero bare and zero non-canonical codes in a BA-facing string
#   4.  the self-test — four seeded defects, one per render class plus the field
#       defect, the argument-form probe and the fenced-block probe
#   5.  the session boundary — orchestrator §10.2 (D-O11) compiled into every
#       skill, persona and mirror, byte-identical, with its own seeded control
#   6.  the pinned suggestion snapshot — orchestrator §6.1's block byte-identical
#       in the planning skill, with three seeded shape defects of its own
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
    -h|--help) sed -n '2,38p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
"""Rule-5 scan — no bare, and no non-canonical, code in a BA-facing string.

Names are not hardcoded: T-01…T-18 come from the catalogue index's rows and
P-O0…P-O9 from orchestrator §10.1's Moment column, so a document rename breaks
this scan instead of drifting silently past it. Adjacency alone would accept
any word sitting after the code; the name has to be the source's name.

Two defect classes, one sweep — rule 5's sentence has two halves:

  bare      a known code rendered without its name  ("P-O3" alone)
  noncanon  a code rendered in a non-canonical form ("t04", "t-04", "T04")

The canonical render is `T-nn` — capital T, hyphen, two digits. The lowercase
form is the command's argument and nothing else, so it is legal only inside a
`/ba-run tnn` span or the bare `tnn` cell that names that argument. Field origin:
pilot R0's out-of-profile line rendered `t04` (defect D1).
"""
import argparse
import re
import sys
from pathlib import Path

CODE = re.compile(r"\b(T-\d{2}|P-O\d)\b")
# the separators rule 5's examples use, plus the table-cell boundary
SEP = r"\**\s*[—–\-:(,|]?\s*\**"
# the three non-canonical forms; the lookarounds keep `ba-t03` and `part03` out
NONCANON = re.compile(r"(?<![A-Za-z0-9_-])(t-\d{2}|t\d{2}|T\d{2})(?![A-Za-z0-9_-])")
# the argument's two legal spellings — everything else lowercase is a render
ARGSPAN = re.compile(r"`(?:/ba-run\s+)?t\d{2}`")


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
                yield n, code, "bare", para
        spans = [s.span() for s in ARGSPAN.finditer(para)]
        for m in NONCANON.finditer(para):
            if any(a <= m.start() and m.end() <= b for a, b in spans):
                continue  # the command's argument, not a render
            yield n, m.group(1), "noncanon", para


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
        for n, code, rule, para in scan(p, table):
            total += 1
            print(f"{p.relative_to(a.root)}:{n}\t{code}\t{rule}\t{para[:150]}")
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

printf '\n▸ The sweep — zero bare and zero non-canonical codes in a BA-facing string (rule 5)\n'

scan_root "$PKG_ROOT" > "$TMP/sweep.out" 2>&1
SW=$?
H="$(hits_of "$TMP/sweep.out")"; F="$(files_of "$TMP/sweep.out")"
if [ "$SW" -eq 0 ] && [ "${H:-x}" = "0" ]; then
  ok "$F files scanned, 0 hits — every T-nn / P-On carries its name"
else
  bad "${H:-?} defect(s) in BA-facing strings across ${F:-?} files"
  grep -v '^files=' "$TMP/sweep.out" | sed 's/^/      /'
fi

# the two halves reported apart, so a regression names which rule broke
NB="$(awk -F'\t' '$3=="bare"' "$TMP/sweep.out" | wc -l | tr -d ' ')"
NN="$(awk -F'\t' '$3=="noncanon"' "$TMP/sweep.out" | wc -l | tr -d ' ')"
[ "$NB" = "0" ] \
  && ok "no bare code — every rendered T-nn / P-On carries its name" \
  || bad "$NB bare code(s): a code rendered without its name"
[ "$NN" = "0" ] \
  && ok "no non-canonical code — no lowercase, hyphenless or bare-digit form renders" \
  || bad "$NN non-canonical code form(s): the render is T-nn, capital T and hyphen"

fi  # end of the non-self-test sections

# ── 4. the self-test — the seeded defects ────────────────────────────────────

printf '\n▸ Self-test — 4 seeded defects, one per render class + the field defect: the suite is not vacuous\n'

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
D_NONCAN="$CORPUS/payload/claude/skills/ba-aspect/SKILL.md"

for f in "$D_HEAD" "$D_PROSE" "$D_TABLE" "$D_NONCAN"; do
  [ -f "$f" ] || bad "injection target missing from the copy: ${f#$CORPUS/}"
done

# one defect per render class, as the Lane B negative control ran them, plus the
# non-canonical form pilot R0 actually rendered (D1) — the out-of-profile line
printf '\n## P-O3 — the act\n' >> "$D_HEAD"
printf '\nThe orchestrator opens the run (that is P-O2) and records the result.\n' >> "$D_PROSE"
printf '\n| P-O7 | closure act |\n' >> "$D_TABLE"
printf '\nOutside this profile (electable by code): t04 — say "show all" for full rows.\n' >> "$D_NONCAN"

scan_root "$CORPUS" > "$TMP/seeded.out" 2>&1
SEED=$?
SH="$(hits_of "$TMP/seeded.out")"
[ "$SEED" -eq 1 ] \
  && ok "the scan exits non-zero on a dirty corpus" \
  || bad "the scan exited $SEED with defects present — it does not fail"
[ "${SH:-x}" = "4" ] \
  && ok "exactly 4 hits — no more, no fewer" \
  || bad "expected exactly 4 hits, got ${SH:-?}"

for site in \
  "ba-run/SKILL.md|P-O3|bare|the prose heading" \
  "ba-orchestrator.md|P-O2|bare|the mid-sentence prose mention" \
  "AGENTS.md|P-O7|bare|the table cell" \
  "ba-aspect/SKILL.md|t04|noncanon|the out-of-profile line's non-canonical code (D1)"
do
  where="${site%%|*}"; rest="${site#*|}"
  code="${rest%%|*}"; rest="${rest#*|}"
  rule="${rest%%|*}"; label="${rest#*|}"
  grep -qE "^[^ ]*$where:[0-9]+	$code	$rule	" "$TMP/seeded.out" \
    && ok "$label is named, with its file and line" \
    || bad "$label was not reported at $where"
done

# the lowercase form stays legal where it is the command's argument, and nowhere
# else — the rule has to admit `/ba-run t03` or the payload could not name a run
printf '\nInvoke it with `/ba-run t04`, and the dispatch table lists it as `t04`.\n' >> "$D_NONCAN"
scan_root "$CORPUS" > "$TMP/argform.out" 2>&1
[ "$(hits_of "$TMP/argform.out")" = "4" ] \
  && ok "the argument spellings draw no hit — /ba-run tnn and the bare tnn cell stay legal" \
  || bad "the argument form was flagged: the scan cannot tell an argument from a render"

# restore: the pristine files back over the injected ones
for rel in payload/claude/skills/ba-run/SKILL.md \
           payload/claude/agents/ba-orchestrator.md \
           payload/mirror/AGENTS.md \
           payload/claude/skills/ba-aspect/SKILL.md; do
  cp "$PKG_ROOT/$rel" "$CORPUS/$rel"
done

scan_root "$CORPUS" > "$TMP/restored.out" 2>&1
REST=$?
[ "$REST" -eq 0 ] && [ "$(hits_of "$TMP/restored.out")" = "0" ] \
  && ok "restored: back to 0 — the 4 hits were the injections and nothing else" \
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

# ── 6. the pinned suggestion snapshot — §6.1's block, byte for byte ──────────
#
# Register rule 8: recurring renders keep their shapes, and on conflict the shape
# governs. §6.1's snapshot is the shape the BA-planning loop renders at P-O2 —
# and pilot R0 lost two of its lines to a paraphrase (D3, the State line's second
# sentence; D4, the closing Sequence rationale). Sections 1–4 hold rule 5 down
# and section 5 holds §10.2 down; this one holds rule 8 down for the one pinned
# shape the planning skill carries.
#
# Neither side is pinned in this file: the document's block is extracted from
# §6.1 and the unit's from the compiled skill, then the two are compared. A
# reworded document breaks the check instead of drifting past it. A unit that
# references the shape instead of embedding it is not exempt — the reference has
# to resolve to that same block, which is the same assertion one indirection out.

if [ "$ONLY_SELFTEST" -eq 0 ]; then

printf '\n▸ The pinned suggestion snapshot — §6.1 in the planning skill, byte for byte\n'

ORC="$DOCS/ba-native-spec-orchestrator-rules.md"
PLANNER="payload/claude/skills/ba-aspect/SKILL.md"

SNAP="$TMP/snapshot_shape.py"
cat > "$SNAP" <<'PY'
#!/usr/bin/env python3
"""§6.1's suggestion-snapshot block: from the document, and from a compiled unit.

--mode doc     the first fenced block inside orchestrator §6.1
--mode unit    the fenced block the unit carries, found by its own first line
               ('Suggestion — '). A unit that only *references* the shape prints
               'REFERENCE\t<section>' instead, so the caller can resolve it.
--mode mutate  rewrite the unit's block in place, one named defect at a time —
               the negative control; run against a private copy, never the payload.
"""
import argparse
import re
import sys
from pathlib import Path

HEAD = "Suggestion — "


def blocks(text):
    """(first_line, body) for every fenced block, in order."""
    out, buf, fenced = [], None, False
    for line in text.splitlines():
        if line.lstrip().startswith("```"):
            if fenced:
                out.append("\n".join(buf))
                buf = None
            else:
                buf = []
            fenced = not fenced
            continue
        if fenced:
            buf.append(line)
    return out


def doc_block(path):
    txt = Path(path).read_text(encoding="utf-8")
    sec = re.search(r"^### 6\.1\b.*?(?=^### 6\.2\b)", txt, re.M | re.S)
    if not sec:
        sys.exit("orchestrator §6.1 not found — the shape has no source")
    found = [b for b in blocks(sec.group(0)) if b.startswith(HEAD)]
    if not found:
        sys.exit("§6.1 carries no suggestion-snapshot block")
    return found[0]


def unit_block(path):
    txt = Path(path).read_text(encoding="utf-8")
    found = [b for b in blocks(txt) if b.startswith(HEAD)]
    if found:
        return found[0]
    ref = re.search(r"§\s*(6\.1)\b", txt)
    if ref:
        print(f"REFERENCE\t{ref.group(1)}")
        sys.exit(3)
    sys.exit("the unit neither embeds nor references the §6.1 shape")


MUTATIONS = {
    # D4 — the closing line the field render dropped
    "drop-rationale": lambda b: "\n".join(
        l for l in b.splitlines() if not l.startswith("Sequence rationale:")),
    # D3 — the State line cut to one sentence, its second moved out of the block
    "truncate-state": lambda b: re.sub(
        r"^State: (.*?) met\..*?\n\(P-O2 — plan composition\)\.$",
        r"State: \1 met.", b, flags=re.M | re.S),
    # D1's other half — the one-line out-of-profile sentence split in two
    "split-outside": lambda b: b.replace(
        '(electable by code): <codes> — say "show all" for full rows.',
        '(electable by code): <codes>. Say "show all" for full rows.'),
}


def mutate(path, name):
    p = Path(path)
    txt = p.read_text(encoding="utf-8")
    block = unit_block(path)
    changed = MUTATIONS[name](block)
    if changed == block:
        sys.exit(f"mutation {name} changed nothing — the control would be vacuous")
    p.write_text(txt.replace(block, changed, 1), encoding="utf-8")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", required=True, choices=("doc", "unit", "mutate"))
    ap.add_argument("--path", required=True)
    ap.add_argument("--defect", choices=sorted(MUTATIONS))
    a = ap.parse_args()
    if a.mode == "mutate":
        mutate(a.path, a.defect)
        return 0
    print(doc_block(a.path) if a.mode == "doc" else unit_block(a.path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
PY

python3 "$SNAP" --mode doc --path "$ORC" > "$TMP/snap-doc.txt" 2>"$TMP/snap-doc.err"
if [ -s "$TMP/snap-doc.txt" ]; then
  ok "§6.1 yields the snapshot block — the shape's source, $(wc -l < "$TMP/snap-doc.txt" | tr -d ' ') lines"
else
  bad "§6.1's fenced block does not extract: the shape cannot be checked from source"
  sed 's/^/      /' "$TMP/snap-doc.err"
fi

# vacuity, on section 2's reasoning: an emptied or reshaped block that still
# extracts would let a byte-match pass while asserting nothing
while IFS='|' read -r label phrase; do
  [ -z "$label" ] && continue
  grep -qF -- "$phrase" "$TMP/snap-doc.txt" \
    && ok "the source block still carries $label" \
    || bad "§6.1's block no longer carries $label — re-read the document before trusting this section"
done <<'LINES'
the profile header|Suggestion — <aspect> — <date> · profile:
the State line's second sentence|Nothing runs until you compose the plan
the out-of-profile line, one sentence with the dash|Outside this profile (electable by code): <codes> — say "show all" for full rows.
the closing sequence rationale|Sequence rationale: <one line>
LINES

python3 "$SNAP" --mode unit --path "$PKG_ROOT/$PLANNER" > "$TMP/snap-skill.txt" 2>"$TMP/snap-skill.err"
SNAP_RC=$?
if [ "$SNAP_RC" -eq 0 ] && [ -s "$TMP/snap-skill.txt" ]; then
  ok "$PLANNER embeds the shape — the block is carried, not paraphrased"
elif [ "$SNAP_RC" -eq 3 ]; then
  # the reference branch: it resolves iff the named section is the one above
  grep -q '^REFERENCE	6.1$' "$TMP/snap-skill.txt" \
    && ok "$PLANNER references §6.1, and the reference resolves to the extracted block" \
    || bad "$PLANNER references a section that is not §6.1"
else
  bad "$PLANNER carries neither the §6.1 block nor a reference to it"
  sed 's/^/      /' "$TMP/snap-skill.err"
fi

if diff -u "$TMP/snap-doc.txt" "$TMP/snap-skill.txt" > "$TMP/snap.diff" 2>&1; then
  ok "byte-identical to §6.1 — the compiled skill carries the document's shape"
else
  bad "the compiled block diverges from §6.1 — the pinned shape is compiled, not rewritten:"
  sed 's/^/      /' "$TMP/snap.diff" | head -20
fi

# ── the control: three shape defects, the ones pilot R0 rendered ─────────────
#
# same discipline as sections 4 and 5 — a byte-match assertion is worth nothing
# until it is shown to fail. Injected into a private copy; the payload is read,
# never written.

SNAPC="$TMP/snap-corpus"
mkdir -p "$SNAPC/$(dirname "$PLANNER")"

for defect in drop-rationale truncate-state split-outside; do
  cp "$PKG_ROOT/$PLANNER" "$SNAPC/$PLANNER"
  python3 "$SNAP" --mode mutate --path "$SNAPC/$PLANNER" --defect "$defect" \
    2>"$TMP/snap-mut.err"
  if [ $? -ne 0 ]; then
    bad "the $defect injection failed: $(cat "$TMP/snap-mut.err")"
    continue
  fi
  python3 "$SNAP" --mode unit --path "$SNAPC/$PLANNER" > "$TMP/snap-dirty.txt" 2>&1
  if diff -q "$TMP/snap-doc.txt" "$TMP/snap-dirty.txt" >/dev/null 2>&1; then
    bad "the $defect defect slips through — the byte-match does not hold"
  else
    ok "$defect is caught — the seeded shape defect goes red"
  fi
done

cp "$PKG_ROOT/$PLANNER" "$SNAPC/$PLANNER"
python3 "$SNAP" --mode unit --path "$SNAPC/$PLANNER" > "$TMP/snap-restored.txt" 2>&1
diff -q "$TMP/snap-doc.txt" "$TMP/snap-restored.txt" >/dev/null 2>&1 \
  && ok "restored: back to byte-identical — the three reds were the injections" \
  || bad "the restored copy does not match §6.1"

fi  # end of section 6

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  if [ "$ONLY_SELFTEST" -eq 1 ]; then
    printf '✓ GREEN — the register self-test: 4 seeded defects, one per render class + the field defect\n'
  else
    printf '✓ GREEN — the BA-facing register: rule 5 across %s files · %s names from source · §10.2 in %s units + 2 mirrors · §6.1 byte-identical in the planner · 9 seeded defects\n' \
      "${F:-?}" "${NAMES_N:-?}" "${B_UNITS:-?}"
  fi
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
