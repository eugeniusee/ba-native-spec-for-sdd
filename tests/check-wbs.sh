#!/usr/bin/env bash
#
# BA-Native Spec — the WBS export (orchestrator rules §10.5, D-O20–D-O25).
#
# `/ba-wbs` is a render: it reads four sources and writes two files. So the
# suite holds down exactly that — what comes out, what gets selected, what a
# client-facing cell may contain, and that nothing upstream moved.
#
#   1.  the golden csv — the whole row model, byte for byte, both profiles
#   2.  the xlsx — it unzips, every part parses, the header row and two known
#       cells are there (a multi-line acceptance cell and a Deferred row)
#   3.  selection (D-O20) — Discovery excludes the uncertified feature,
#       --include admits it, Presale admits every draft; the summary names
#       every folder's disposition
#   4.  the disposition ladder — certified · FAIL(n) · draft · no gate run,
#       the last two on a private copy of the fixture
#   5.  the register (§10.5) — no marker bracket, no CC-ID, no EARS keyword in
#       caps in any generated cell, with a seeded-defect negative control on
#       the check-register.sh pattern
#   6.  read-only (§10.5) — the source tree hashes identical across a run
#
# The fixture is read, never written: every run writes into the suite's temp
# dir, and section 6 proves it.
#
#   check-wbs.sh              run the suite
#   check-wbs.sh --self-test  run only the register negative control
#   check-wbs.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
SK="$PKG_ROOT/payload/specify-overlay/ba/scripts"
FX="$HERE/fixtures/appointment-booking"
PROJ="$FX/project"
EXPECT="$FX/expected"

VERBOSE=0; ONLY_SELFTEST=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    --self-test)  ONLY_SELFTEST=1 ;;
    -h|--help) sed -n '2,27p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

wbs() { python3 "$SK/sk_wbs.py" "$@"; }

# ── the cell reader: every generated cell of a csv, one per line ─────────────

CELLS="$TMP/cells.py"
cat > "$CELLS" <<'PY'
"""Print every cell of a WBS csv as `<row>\t<column>\t<text>` — header included."""
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
head = rows[0]
for r, row in enumerate(rows):
    for c, cell in enumerate(row):
        for line in cell.splitlines() or [""]:
            print("%d\t%s\t%s" % (r, head[c] if c < len(head) else "?", line))
PY

# ── the register sweep: §10.5's three exclusions, over every cell ────────────
#
# Two deliberate exceptions stay legal: the waiver tag in Comments / Questions,
# and quoted status values inside acceptance text. Everything else is a leak.

SWEEP="$TMP/sweep.py"
cat > "$SWEEP" <<'PY'
"""Register leak sweep over a generated WBS csv (orchestrator §10.5 Register).

Fails on a marker bracket, a CC-ID, or an EARS keyword in caps anywhere in a
client-facing cell. The waiver tag `W-<NNN>-<nn>` is legal in Comments /
Questions only; a quoted status value is legal anywhere.
"""
import csv
import re
import sys

MARKER = re.compile(r"\[NEEDS CLARIFICATION")
CC_ID = re.compile(r"\bCC-[A-Z]{1,3}-\d{2}\b")
EARS = re.compile(r"\bTHE SYSTEM\b|\bSHALL\b|\bWHEN\b|\bWHILE\b|\bWHERE\b"
                  r"|\bIF\b|\bTHEN\b")
WAIVER = re.compile(r"\bW-\d{3}-\d{2}\b")
QUOTED = re.compile(r"\"[^\"]*\"")

rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
head = rows[0]
hits = 0
for r, row in enumerate(rows[1:], start=2):
    for c, cell in enumerate(row):
        col = head[c] if c < len(head) else "?"
        body = QUOTED.sub("", cell)           # the quoted-status exception
        for label, rx in (("marker bracket", MARKER), ("CC-ID", CC_ID),
                          ("EARS caps", EARS)):
            m = rx.search(body)
            if m:
                hits += 1
                print("row %d\t%s\t%s\t%s" % (r, col, label, m.group(0)))
        m = WAIVER.search(body)
        if m and col != "Comments / Questions":
            hits += 1
            print("row %d\t%s\t%s\t%s" % (r, col, "waiver tag out of column",
                                          m.group(0)))
print("cells=%d leaks=%d" % (sum(len(x) for x in rows[1:]), hits))
sys.exit(1 if hits else 0)
PY

leaks_of() { sed -n 's/^cells=[0-9]* leaks=\([0-9]*\)$/\1/p' "$1"; }

# ── 1. the golden csv ────────────────────────────────────────────────────────

if [ "$ONLY_SELFTEST" -eq 0 ]; then

printf '\n▸ The row model — the golden csv, both profiles\n'

for prof in discovery presale; do
  out="$TMP/$prof"
  wbs --root "$PROJ" --profile "$prof" --out-dir "$out" > "$TMP/$prof.summary" 2>&1
  rc=$?
  [ "$rc" -eq 0 ] \
    && ok "the $prof run exits clean" \
    || { bad "the $prof run exited $rc"; sed 's/^/      /' "$TMP/$prof.summary"; }
  if [ -f "$out/wbs.csv" ]; then
    if diff -u "$EXPECT/wbs-$prof.csv" "$out/wbs.csv" > "$TMP/$prof.diff"; then
      ok "$prof: wbs.csv is byte-identical to the golden file"
    else
      bad "$prof: wbs.csv diverges from expected/wbs-$prof.csv"
      head -30 "$TMP/$prof.diff" | sed 's/^/      /'
    fi
  else
    bad "$prof: no wbs.csv was written"
  fi
  [ -f "$out/wbs.xlsx" ] \
    && ok "$prof: wbs.xlsx written beside it — one build, both renders (D-O23)" \
    || bad "$prof: no wbs.xlsx — the primary render is missing"
done

# the pinned column set, read off the file rather than asserted from memory
head -1 "$EXPECT/wbs-discovery.csv" > "$TMP/header.csv"
python3 - "$TMP/header.csv" > "$TMP/header.txt" <<'PY'
import csv, sys
print("|".join(next(csv.reader(open(sys.argv[1], encoding="utf-8")))))
PY
WANT='Epic|Topic|User Story|Acceptance Criteria|Integrations|Comments / Questions|Role|Phase|Billable'
WANT_CSV='Epic,Topic,User Story,Acceptance Criteria,Integrations,Comments / Questions,Role,Phase,Billable'
[ "$(cat "$TMP/header.txt")" = "$WANT" ] \
  && ok "the pinned column set, in order — the nine generated columns" \
  || bad "the header is [$(cat "$TMP/header.txt")], expected [$WANT]"

# no estimate column exists (§10.5 v0.24 — the never-numeric rule needs no carrier)
python3 - "$TMP/presale/wbs.csv" > "$TMP/est.txt" <<'PY'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
est = [h for h in rows[0] if "estimate" in h.lower()]
print(len(rows) - 1, len(est))
PY
read -r N_ROWS N_EST < "$TMP/est.txt"
[ "$N_EST" = "0" ] \
  && ok "no estimate column renders across $N_ROWS rows — removed at §10.5 v0.24" \
  || bad "$N_EST estimate header(s) survive in the export"

# …and the same absence one layer down, in the row model itself. The header
# check above reads a rendered file; this reads the generator, so a column
# added back to COLUMNS is caught at its source and not only where it lands.
python3 - "$SK" > "$TMP/cols.txt" 2>&1 <<'PY'
import sys
sys.path.insert(0, sys.argv[1])
import sk_wbs
est = [c for c in sk_wbs.COLUMNS if "estimate" in c.lower()]
print("%d\t%d\t%d\t%s" % (len(sk_wbs.COLUMNS), len(sk_wbs.WIDTHS), len(est),
                           sk_wbs.COLUMNS[-1]))
PY
IFS='	' read -r N_COLS N_WIDTHS N_COLEST N_TAIL < "$TMP/cols.txt"
{ [ "${N_COLEST:-1}" = "0" ] && [ "${N_COLS:-0}" = "9" ]; } \
  && ok "the generator's pinned set is nine columns and names no estimate" \
  || bad "sk_wbs.COLUMNS: $N_COLS column(s), ${N_COLEST:-?} of them estimate columns"
[ "${N_TAIL:-x}" = "Billable" ] \
  && ok "…and the set's tail is Billable — the §10.5 move off Phase (D-O67)" \
  || bad "the column set ends at [${N_TAIL:-?}], expected Billable"
[ "${N_WIDTHS:-x}" = "${N_COLS:-y}" ] \
  && ok "…and the width vector was cut with it — $N_WIDTHS widths, $N_COLS columns" \
  || bad "$N_WIDTHS widths against $N_COLS columns — the xlsx writer would refuse"

# ── 2. the xlsx ──────────────────────────────────────────────────────────────

printf '\n▸ The xlsx — the primary render, opened and read back\n'

python3 - "$TMP/presale/wbs.xlsx" > "$TMP/xlsx.txt" 2>"$TMP/xlsx.err" <<'PY'
import sys, zipfile
import xml.etree.ElementTree as ET

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
assert z.testzip() is None, "zip integrity"
for name in z.namelist():
    ET.fromstring(z.read(name))            # every part is well-formed XML
sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
rows = sheet.find(NS + "sheetData").findall(NS + "row")


def cells(row):
    out = []
    for c in row.findall(NS + "c"):
        t = c.find(NS + "is/" + NS + "t")
        out.append(t.text if t is not None else "")
    return out


# The title block occupies the first three rows; the bold header row follows
# it (D-O67's two, D-O75's third). Everything below indexes off `body`, so the
# assertions read the same whether or not a title block is present.
TITLE = 3
title = [cells(r) for r in rows[:TITLE]]
body = rows[TITLE:]

print("parts\t%d" % len(z.namelist()))
print("rows\t%d" % len(body))
print("titlerows\t%d" % len(title))
print("title1\t%s" % (title[0][0] if title and title[0] else ""))
print("title2\t%s" % (title[1][0] if len(title) > 1 and title[1] else ""))
print("title3\t%s" % (title[2][0] if len(title) > 2 and title[2] else ""))
print("titlewidth\t%d" % max((len(t) for t in title), default=0))
print("header\t%s" % "|".join(cells(body[0])))
print("styles\t%s" % ("bold" if b"<b/>" in z.read("xl/styles.xml") else "none"))
print("wrap\t%s" % ("yes" if b'wrapText="1"' in z.read("xl/styles.xml") else "no"))
print("cols\t%s" % ("yes" if b"<cols>" in z.read("xl/worksheets/sheet1.xml")
                    else "no"))
print("merges\t%s" % ("yes" if b"mergeCell" in z.read("xl/worksheets/sheet1.xml")
                      else "no"))
multi = [r for r in body[1:] if any("\n" in c for c in cells(r))]
print("multiline\t%d" % len(multi))
if multi:
    first = [c for c in cells(multi[0]) if "\n" in c][0]
    print("firstitem\t%s" % first.splitlines()[0])
deferred = [cells(r) for r in body[1:] if cells(r)[2] == "" and cells(r)[1]]
print("deferred\t%s" % (deferred[0][1] if deferred else ""))
print("deferredphase\t%s" % (deferred[0][7] if deferred else ""))
PY
if [ ! -s "$TMP/xlsx.txt" ]; then
  bad "the xlsx did not read back"; sed 's/^/      /' "$TMP/xlsx.err"
else
  field() { awk -F'\t' -v k="$1" '$1==k {print $2}' "$TMP/xlsx.txt"; }
  ok "the xlsx unzips and every part parses as XML — $(field parts) parts"
  [ "$(field rows)" = "$((N_ROWS + 1))" ] \
    && ok "$(field rows) sheet rows — the header plus every csv row" \
    || bad "the sheet has $(field rows) rows, the csv has $N_ROWS + header"
  [ "$(field header)" = "$WANT" ] \
    && ok "the sheet's header row is the pinned column set" \
    || bad "the sheet header is [$(field header)]"
  [ "$(field styles)" = "bold" ] && ok "the header row is bold" \
                                 || bad "no bold font in the styles part"
  [ "$(field wrap)" = "yes" ] && ok "cells wrap" || bad "no wrapped text"
  [ "$(field cols)" = "yes" ] && ok "column widths are set" \
                              || bad "no column widths"
  [ "$(field merges)" = "no" ] \
    && ok "no cell merges — the Epic value repeats per row" \
    || bad "the sheet carries merged cells"
  [ "$(field multiline)" -gt 0 ] \
    && ok "$(field multiline) multi-line acceptance cell(s) survive the write" \
    || bad "no multi-line cell in the sheet — the acceptance list did not land"
  case "$(field firstitem)" in
    "1. "*) ok "a known acceptance cell opens its numbered list: $(field firstitem | cut -c1-46)…" ;;
    *) bad "the first acceptance item does not open a numbered list: $(field firstitem)" ;;
  esac
  [ "$(field deferred)" = "Reschedule-in-place" ] \
    && ok "the Deferred row is in the sheet — Topic \"Reschedule-in-place\"" \
    || bad "no Deferred row in the sheet (got '$(field deferred)')"
  [ "$(field deferredphase)" = "Phase 2" ] \
    && ok "…carrying its own target phase, not the epic's — Phase 2" \
    || bad "the Deferred row's Phase is '$(field deferredphase)', expected Phase 2"
fi

# ── 2b. the title block and Billable, against a seeded frame (D-O67) ─────────
#
# The shared fixture carries no ledger head, so the golden run above exercises
# the absent-frame case: every Billable cell blank, the title block naming the
# project alone — never a guess. This section seeds a frame into a copy and
# exercises the derivation itself.

printf '\n▸ The title block and Billable — a seeded frame (D-O67)\n'

FRAMED="$TMP/framed-proj"
cp -R "$PROJ" "$FRAMED"
mkdir -p "$FRAMED/.specify"
cat > "$FRAMED/.specify/aspect-state.md" <<'HEAD'
# Aspect State — appointment booking
## Current state
Band: 1 (open)
Profile: Presale — picked 2026-08-13 (P-O0)
Boundary: MVP + Phase 2 — set 2026-08-13 (P-O0b); switches append to Events with a reason
Client label: PoC  (sources/brief.md §1)
Scope decisions: none found
Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default · XO-2 — language: Ukrainian + English UI (sources/brief.md §4) — carried — E-07 Localization · XO-3 — accessibility: WCAG 2.1 AA (sources/rfp.md §6) — captured
HEAD

wbs --root "$FRAMED" --profile presale --out-dir "$TMP/framed" \
    --date 2026-08-19 > "$TMP/framed.summary" 2>&1 \
  && ok "the framed run exits clean" \
  || { bad "the framed run failed"; sed 's/^/      /' "$TMP/framed.summary"; }

# Billable, per row, read off the rendered csv — Yes inside the boundary,
# No outside, blank where the Phase cell is blank.
python3 - "$TMP/framed/wbs.csv" > "$TMP/billable.txt" <<'PYX'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
head, body = rows[0], rows[1:]
ph, bi = head.index("Phase"), head.index("Billable")
pairs = sorted({(r[ph], r[bi]) for r in body})
print("pairs\t%s" % "; ".join("%s=>%s" % (a or "<blank>", b or "<blank>")
                              for a, b in pairs))
print("numeric\t%d" % sum(1 for r in body if r[bi].strip()
                          and r[bi].strip() not in ("Yes", "No")))
PYX
BPAIRS="$(awk -F'\t' '$1=="pairs" {print $2}' "$TMP/billable.txt")"
BNUM="$(awk -F'\t' '$1=="numeric" {print $2}' "$TMP/billable.txt")"

case "$BPAIRS" in
  *"MVP=>Yes"*) ok "a Phase inside the boundary derives Billable Yes" ;;
  *) bad "no MVP=>Yes pair in the render: [$BPAIRS]" ;;
esac
case "$BPAIRS" in
  *"Phase 2=>Yes"*) ok "…and the second boundary phase too — Phase 2 => Yes" ;;
  *) bad "no 'Phase 2=>Yes' pair in the render: [$BPAIRS]" ;;
esac
[ "${BNUM:-1}" = "0" ] \
  && ok "…and no Billable cell carries anything but Yes/No — never a number" \
  || bad "$BNUM Billable cell(s) hold a value that is neither Yes nor No"

# a Phase outside the boundary derives No — the same fixture, a narrower frame
NARROW="$TMP/narrow-proj"
cp -R "$PROJ" "$NARROW"
mkdir -p "$NARROW/.specify"
cat > "$NARROW/.specify/aspect-state.md" <<'HEAD'
Boundary: MVP — set 2026-08-13 (P-O0b); switches append to Events with a reason
Client label: PoC  (sources/brief.md §1)
Scope decisions: none found
HEAD
wbs --root "$NARROW" --profile presale --out-dir "$TMP/narrow" \
    --date 2026-08-19 > /dev/null 2>&1
python3 - "$TMP/narrow/wbs.csv" > "$TMP/narrow.txt" <<'PYX'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
head, body = rows[0], rows[1:]
ph, bi = head.index("Phase"), head.index("Billable")
pairs = sorted({(r[ph], r[bi]) for r in body})
print("; ".join("%s=>%s" % (a or "<blank>", b or "<blank>") for a, b in pairs))
PYX
NPAIRS="$(cat "$TMP/narrow.txt")"
case "$NPAIRS" in
  *"Phase 2=>No"*) ok "a Phase outside the boundary derives Billable No" ;;
  *) bad "no 'Phase 2=>No' pair under a boundary of MVP alone: [$NPAIRS]" ;;
esac
case "$NPAIRS" in
  *"MVP=>Yes"*) ok "…while the in-boundary phase still derives Yes" ;;
  *) bad "MVP lost its Yes under the narrow boundary: [$NPAIRS]" ;;
esac

# ── 2c. Billable renders blank where no boundary stands (D-O71) ──────────────
#
# The codification case, and the one the two frames above cannot reach: a frame
# that stands — a ledger head, a label, a scope-decisions line — and names no
# delivery boundary. The test has no ground, so the column has no value: every
# cell blank, and never a default `Yes` or `No`. The exporter has behaved this
# way since D-O67; D-O71 rules it, and this is the assertion that holds it.

printf '\n▸ Billable — blank where no boundary stands in the frame (D-O71)\n'

NOBND="$TMP/noboundary-proj"
cp -R "$PROJ" "$NOBND"
mkdir -p "$NOBND/.specify"
cat > "$NOBND/.specify/aspect-state.md" <<'HEAD'
# Aspect State — appointment booking
## Current state
Band: 1 (open)
Profile: Presale — picked 2026-08-13 (P-O0)
Client label: PoC  (sources/brief.md §1)
Scope decisions: none found
Cross-cutting: XO-1 — language: English (engagement default — framework law, D-O74) — default
HEAD

wbs --root "$NOBND" --profile presale --out-dir "$TMP/noboundary" \
    --date 2026-08-19 > "$TMP/noboundary.summary" 2>&1 \
  && ok "the no-boundary run exits clean — an absent boundary is never an error" \
  || { bad "the no-boundary run failed"; sed 's/^/      /' "$TMP/noboundary.summary"; }

python3 - "$TMP/noboundary/wbs.csv" > "$TMP/noboundary.txt" <<'PYX'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
head, body = rows[0], rows[1:]
ph, bi = head.index("Phase"), head.index("Billable")
print("filled\t%d" % sum(1 for r in body if r[bi].strip()))
print("phased\t%d" % sum(1 for r in body if r[ph].strip()))
print("values\t%s" % "; ".join(sorted({r[bi].strip() or "<blank>" for r in body})))
PYX
NB_FILLED="$(awk -F'\t' '$1=="filled" {print $2}' "$TMP/noboundary.txt")"
NB_PHASED="$(awk -F'\t' '$1=="phased" {print $2}' "$TMP/noboundary.txt")"
NB_VALUES="$(awk -F'\t' '$1=="values" {print $2}' "$TMP/noboundary.txt")"

[ "${NB_PHASED:-0}" -gt 0 ] \
  && ok "…the render still carries $NB_PHASED phased row(s) — the case is not vacuous" \
  || bad "no row carries a Phase: the no-boundary case proves nothing"
[ "${NB_FILLED:-1}" = "0" ] \
  && ok "…and every Billable cell renders blank: [$NB_VALUES]" \
  || bad "$NB_FILLED Billable cell(s) hold a value with no boundary to test against: [$NB_VALUES]"

# the sentence itself lives with the document's operative text — asserted at
# check-orchestrator.sh (§10.5 · the ba-wbs carrier); what is proven here is
# the behaviour it rules.

# ── 2c-ii. `Delivery boundary: none stated` on the title block (D-O77) ───────
#
# The other half of the same absent-boundary case, and Р7's codification: the
# line renders, and it renders `none stated` — never an empty value, and never
# a `not set` placeholder nobody ruled. The third line renders `none stated`
# too, because only the English default stands on this frame's register.

python3 - "$TMP/noboundary/wbs.xlsx" > "$TMP/nb-title.txt" 2>&1 <<'PYX'
import sys, zipfile
import xml.etree.ElementTree as ET
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
rows = sheet.find(NS + "sheetData").findall(NS + "row")
def first(row):
    c = row.find(NS + "c")
    tx = c.find(NS + "is/" + NS + "t") if c is not None else None
    return tx.text if tx is not None else ""
for i in (0, 1, 2):
    print("line%d\t%s" % (i + 1, first(rows[i])))
PYX
NB2="$(awk -F'\t' '$1=="line2" {print $2}' "$TMP/nb-title.txt")"
NB3="$(awk -F'\t' '$1=="line3" {print $2}' "$TMP/nb-title.txt")"

[ "$NB2" = "Delivery boundary: none stated · generated 2026-08-19" ] \
  && ok "the boundary line reads \`none stated\` where no boundary stands: $NB2" \
  || bad "the boundary line is [$NB2], expected 'Delivery boundary: none stated · generated 2026-08-19'"
case "$NB2" in
  *"not set"*|*"billable phases:"*)
     bad "the no-boundary line still carries a placeholder or the billable-phases tail: [$NB2]" ;;
  *) ok "…never an empty value, a \`not set\` placeholder or a phases tail (D-O77)" ;;
esac
[ "$NB3" = "Cross-cutting: none stated" ] \
  && ok "…and the cross-cutting line reads \`none stated\` where only the default stands" \
  || bad "the cross-cutting line is [$NB3], expected 'Cross-cutting: none stated'"

# ── 2c-iii. the generation summary names what is not carried (D-O75) ─────────
#
# The export's teeth, and its limit: an obligation that left Frame uncarried is
# NAMED on the summary, and the run still succeeds — counts render, the BA
# judges, and `/ba-wbs` never blocks.

grep -q 'Cross-cutting — entries not carried: XO-3 — accessibility: WCAG 2.1 AA' "$TMP/framed.summary" \
  && ok "the summary names the \`captured\` entry no unit carries — by id, class and value" \
  || { bad "the summary does not name the uncarried obligation"; \
       grep -i 'cross-cutting' "$TMP/framed.summary" | sed 's/^/      /'; }
grep -q 'Cross-cutting — entries not carried:.*XO-2' "$TMP/framed.summary" \
  && bad "the summary named a \`carried\` entry — carried is a terminal state" \
  || ok "…and a \`carried\` entry is terminal: it is not named"
grep -q 'Cross-cutting — entries not carried:.*XO-1' "$TMP/framed.summary" \
  && bad "the summary named the engagement default — \`default\` is terminal" \
  || ok "…and the \`default\` entry is terminal too"
grep -q 'Cross-cutting — entries not carried: none' "$TMP/noboundary.summary" \
  && ok "…and a register holding only the default reports none" \
  || { bad "the no-boundary summary does not report an empty non-terminal set"; \
       grep -i 'cross-cutting' "$TMP/noboundary.summary" | sed 's/^/      /'; }


# the xlsx title block — two lines above the bold header row, label verbatim
python3 - "$TMP/framed/wbs.xlsx" > "$TMP/title.txt" 2>&1 <<'PYX'
import sys, zipfile
import xml.etree.ElementTree as ET
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
rows = sheet.find(NS + "sheetData").findall(NS + "row")
def cells(row):
    out = []
    for c in row.findall(NS + "c"):
        t = c.find(NS + "is/" + NS + "t")
        out.append(t.text if t is not None else "")
    return out
print("line1\t%s" % cells(rows[0])[0])
print("line2\t%s" % cells(rows[1])[0])
print("line3\t%s" % cells(rows[2])[0])
print("header\t%s" % "|".join(cells(rows[3])))
PYX
T1="$(awk -F'\t' '$1=="line1" {print $2}' "$TMP/title.txt")"
T2="$(awk -F'\t' '$1=="line2" {print $2}' "$TMP/title.txt")"
TX="$(awk -F'\t' '$1=="line3" {print $2}' "$TMP/title.txt")"
T3="$(awk -F'\t' '$1=="header" {print $2}' "$TMP/title.txt")"

case "$T1" in
  "PoC — "*) ok "the xlsx title line 1 carries the client label verbatim: $T1" ;;
  *) bad "the xlsx title line 1 is [$T1], expected the label verbatim" ;;
esac
case "$T2" in
  "Delivery boundary: MVP + Phase 2 — billable phases: "*)
     ok "…and line 2 is the delivery-boundary line: $T2" ;;
  *) bad "the xlsx title line 2 is [$T2], expected the delivery-boundary line" ;;
esac

# line 3 — the cross-cutting carry (D-O75): non-`default` entries only, each
# with its `(XO-<n>)` provenance; the engagement default never reaches it.
case "$TX" in
  "Cross-cutting: "*) ok "…and line 3 is the cross-cutting line: $TX" ;;
  *) bad "the xlsx title line 3 is [$TX], expected the cross-cutting line (D-O75)" ;;
esac
case "$TX" in
  *"language: Ukrainian + English UI (XO-2)"*)
     ok "…carrying a stated obligation with its class, value and register id" ;;
  *) bad "line 3 does not carry the stated language obligation: [$TX]" ;;
esac
case "$TX" in
  *"accessibility: WCAG 2.1 AA (XO-3)"*)
     ok "…and a second class beside it — the line is not language-only" ;;
  *) bad "line 3 does not carry the accessibility obligation: [$TX]" ;;
esac
case "$TX" in
  *"English (engagement default"*|*"XO-1"*)
     bad "the engagement default reached the title block: [$TX] — framework law is not client ground" ;;
  *) ok "…and the English engagement default never renders there — client ground only" ;;
esac
case "$TX" in
  *"sources/brief.md"*|*"sources/rfp.md"*)
     bad "a citation leaked into the title block: [$TX] — the line carries class, value and id" ;;
  *) ok "…and the citation stays on the ledger head, not in the client render" ;;
esac
[ "$T3" = "$WANT" ] \
  && ok "…with the pinned column set on the row below the block" \
  || bad "the row below the title block is [$T3], expected the column set"
case "$T1$T2" in
  *50000*|*USD*|*[Bb]udget*)
     bad "the budget reached the title block — it never enters the header" ;;
  *) ok "the budget never appears in the title block" ;;
esac

# the csv carries no title block: line 1 is the column row itself
CSV1="$(head -1 "$TMP/framed/wbs.csv" | tr -d '\r')"
[ "$CSV1" = "$WANT_CSV" ] \
  && ok "the csv opens on the column row — no title block (D-O67)" \
  || bad "the csv's first line is [$CSV1], expected the bare column row"
grep -q 'Delivery boundary:' "$TMP/framed/wbs.csv" \
  && bad "the delivery-boundary line leaked into the csv" \
  || ok "…and the delivery-boundary line is absent from it"
grep -q '^Cross-cutting:' "$TMP/framed/wbs.csv" \
  && bad "the cross-cutting line leaked into the csv — it is pure rows (D-O75)" \
  || ok "…and the cross-cutting line is absent from it too"

# an open label renders the project name alone — the export never invents
FRAMED2="$TMP/openlabel-proj"
cp -R "$PROJ" "$FRAMED2"
mkdir -p "$FRAMED2/.specify"
cat > "$FRAMED2/.specify/aspect-state.md" <<'HEAD'
Boundary: MVP — set 2026-08-13 (P-O0b); switches append to Events with a reason
Client label: open — no source material  (open — no source material)
Scope decisions: none found
HEAD
wbs --root "$FRAMED2" --profile presale --out-dir "$TMP/openlabel" \
    --date 2026-08-19 > /dev/null 2>&1
python3 - "$TMP/openlabel/wbs.xlsx" > "$TMP/openlabel.txt" 2>&1 <<'PYX'
import sys, zipfile
import xml.etree.ElementTree as ET
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
rows = sheet.find(NS + "sheetData").findall(NS + "row")
c = rows[0].find(NS + "c")
t = c.find(NS + "is/" + NS + "t") if c is not None else None
print(t.text if t is not None else "")
PYX
case "$(cat "$TMP/openlabel.txt")" in
  *"open — no source material"*|*"—"*)
     bad "an open label reached the title block: [$(cat "$TMP/openlabel.txt")]" ;;
  *) ok "an open label renders the project name alone — never invented" ;;
esac

# ── 2c. seeded-defect controls for the pair (D-O67) ──────────────────────────
#
# An assertion never shown to fail is worth nothing. Two defects, one per half
# of the ruling, seeded into copies of the clean renders.

printf '\n  seeded-defect control — one per half of the pair:\n'

# (a) the column set loses its tail — the render ends at Phase again
python3 - "$TMP/framed/wbs.csv" "$TMP/seed-tail.csv" <<'PYX'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
rows = [r[:-1] for r in rows]            # the Billable column, removed
with open(sys.argv[2], "w", encoding="utf-8", newline="") as fh:
    csv.writer(fh).writerows(rows)
PYX
SEED_HEAD="$(head -1 "$TMP/seed-tail.csv" | tr -d '\r')"
[ "$SEED_HEAD" = "$WANT" ] \
  && bad "the seeded tail-loss was not caught — the header still reads as pinned" \
  || ok "seeded: the column set ending at Phase is caught — [$(echo "$SEED_HEAD" | rev | cut -d, -f1 | rev)] is not Billable"

# (b) the csv grows a title block
{ printf 'PoC — appointment booking\n'; cat "$TMP/framed/wbs.csv"; } \
  > "$TMP/seed-title.csv"
SEEDED_CSV1="$(head -1 "$TMP/seed-title.csv" | tr -d '\r')"
[ "$SEEDED_CSV1" = "$WANT_CSV" ] \
  && bad "the seeded csv title block was not caught" \
  || ok "seeded: a title block in the csv is caught — line 1 reads [$SEEDED_CSV1]"

# (c) the title block loses its third line — the carry silently disappears
python3 - "$TMP/framed/wbs.xlsx" > "$TMP/seed-third.txt" <<'PYX'
import sys, zipfile
import xml.etree.ElementTree as ET
NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
rows = sheet.find(NS + "sheetData").findall(NS + "row")
def first(row):
    c = row.find(NS + "c")
    tx = c.find(NS + "is/" + NS + "t") if c is not None else None
    return tx.text if tx is not None else ""
# the seed: the block as it would stand with D-O75 never compiled
seeded = [first(rows[0]), first(rows[1])]
print("third\t%s" % (seeded[2] if len(seeded) > 2 else ""))
PYX
SEED_THIRD="$(awk -F'\t' '$1=="third" {print $2}' "$TMP/seed-third.txt")"
case "$SEED_THIRD" in
  "Cross-cutting: "*) bad "the seeded two-line block was not caught — it still reads as carrying the line" ;;
  *) ok "seeded: a title block that lost its third line is caught — line 3 reads [${SEED_THIRD:-<absent>}]" ;;
esac

# (d) the engagement default renders into the client's copy — the generator's
#     own title_block, run with D-O75's filter defeated, against the guard that
#     rejects it above
python3 - "$SK" > "$TMP/seed-default.txt" <<'PYX'
import sys, importlib.util, pathlib
spec = importlib.util.spec_from_file_location(
    "sk_wbs", str(pathlib.Path(sys.argv[1]) / "sk_wbs.py"))
m = importlib.util.module_from_spec(spec)
sys.modules["sk_wbs"] = m            # @dataclass resolves its own module
spec.loader.exec_module(m)
cross = [(1, "language", "English (engagement default — framework law, D-O74)", "default"),
         (2, "language", "Ukrainian + English UI", "carried")]
clean = m.title_block("proj", "PoC", ["MVP"], "2026-08-19", cross)[2]
# the seed: `default` treated as an ordinary entry, the filter defeated
seeded = "Cross-cutting: %s" % " · ".join(
    "%s: %s (XO-%d)" % (c, v, n) for n, c, v, _ in cross)
print("clean\t%s" % clean)
print("seeded\t%s" % seeded)
PYX
SD_CLEAN="$(awk -F'\t' '$1=="clean" {print $2}' "$TMP/seed-default.txt")"
SD_SEED="$(awk -F'\t' '$1=="seeded" {print $2}' "$TMP/seed-default.txt")"
case "$SD_CLEAN" in
  *"engagement default"*) bad "the generator renders the engagement default: [$SD_CLEAN]" ;;
  *) ok "the generator's own third line drops the \`default\` entry: [$SD_CLEAN]" ;;
esac
case "$SD_SEED" in
  *"engagement default"*)
     ok "seeded: with the filter defeated the default leaks, and the guard above rejects it" ;;
  *) bad "the seeded default-leak control does not carry the default: the probe is blind" ;;
esac

# ── 3. selection (D-O20) ─────────────────────────────────────────────────────

printf '\n▸ Selection — the profile defaults, and --include\n'

grep -q '^Included: 004-appointment-booking$' "$TMP/discovery.summary" \
  && ok "Discovery admits the certified feature" \
  || bad "Discovery did not admit 004-appointment-booking alone"
grep -q '^Excluded: 005-specialist-availability-publishing — no certification' \
     "$TMP/discovery.summary" \
  && ok "Discovery excludes the uncertified feature, and says why" \
  || bad "Discovery did not exclude 005 with a stated reason"
grep -q 'admit with --include 005' "$TMP/discovery.summary" \
  && ok "…and names the act that admits it" \
  || bad "the exclusion line does not name --include"

wbs --root "$PROJ" --profile discovery --include 005 --out-dir "$TMP/inc" \
    > "$TMP/inc.summary" 2>&1
grep -q '005-specialist-availability-publishing' <(grep '^Included:' "$TMP/inc.summary") \
  && ok "--include 005 admits the uncertified feature under Discovery" \
  || bad "--include 005 did not admit the feature"
grep -q '^Excluded: none$' "$TMP/inc.summary" \
  && ok "…and nothing is left excluded" || bad "something stayed excluded"
diff -q "$TMP/inc/wbs.csv" "$TMP/presale/wbs.csv" > /dev/null \
  && ok "the admitted set renders the same rows Presale renders — one generator" \
  || bad "--include and Presale disagree on the rows for the same feature set"

grep -q '^Excluded: none$' "$TMP/presale.summary" \
  && ok "Presale admits every drafted feature" \
  || bad "Presale excluded something"

# nothing silently dropped: every specs/NNN-* folder is named in the summary
for f in "$PROJ"/specs/*/; do
  n="$(basename "$f")"
  grep -q "| $n |" "$TMP/discovery.summary" \
    && ok "$n is named in the summary with its disposition" \
    || bad "$n does not appear in the generation summary"
done

grep -q '| 004-appointment-booking | certified — 2026-07-18 |' "$TMP/discovery.summary" \
  && ok "004's disposition reads certified, with the run date" \
  || bad "004's disposition line is not 'certified — 2026-07-18'"
grep -q '| 005-specialist-availability-publishing | no gate run |' "$TMP/discovery.summary" \
  && ok "005's disposition reads no gate run" \
  || bad "005's disposition is not 'no gate run'"
grep -q '^Open markers per row:' "$TMP/presale.summary" \
  && ok "the summary carries per-row open-marker counts" \
  || bad "no per-row marker counts in the summary"
grep -qE '\| 005-specialist-availability-publishing \| no gate run \| 2 \| 2 \|' \
     "$TMP/presale.summary" \
  && ok "…and the per-feature count beside them — 005 carries 2 markers" \
  || bad "005's per-feature marker count is not 2"

# ── 3b. §10 References, read as the gate reads it ────────────────────────────
#
# The template's labelled bullets are one legal shape, not the only one. A spec
# whose References carries bare-path bullets and a standalone `Roles used:`
# line passes CC-TR-02 and CC-TR-03 — so it certifies, and this render has to
# read it. Field defect, package 0.1.6: it did not, and the whole export came
# out empty with a summary that still reported rows per feature.

printf '\n▸ §10 References — whatever shape the gate certifies, this render reads\n'

SHAPE="$TMP/shape"
mkdir -p "$SHAPE"
( cd "$PROJ" && tar cf - . ) | ( cd "$SHAPE" && tar xf - )
python3 - "$SHAPE" <<'PY'
"""Rewrite both specs' §10 into the bare-path shape the field authors."""
import pathlib, sys
root = pathlib.Path(sys.argv[1])
bare = """
- .specify/memory/roles-permissions.md
- .specify/memory/glossary.md
- .specify/memory/domain-model.md
- .specify/memory/scope/E-03.md
Roles used: Client, Specialist
"""
for spec in sorted(root.glob("specs/*/spec.md")):
    head, sep, _ = spec.read_text(encoding="utf-8").partition("## References\n")
    spec.write_text(head + sep + bare, encoding="utf-8")
PY

# the premise, proved rather than asserted: the gate passes this shape
python3 "$SK/sk_idgraph.py" --root "$SHAPE" --feature 004-appointment-booking \
        --brief "$SHAPE/.specify/memory/scope/E-03.md" > "$TMP/idgraph.out" 2>&1
grep -q '^CC-TR-02 PASS' "$TMP/idgraph.out" \
  && ok "the gate's CC-TR-02 passes the bare-path References shape" \
  || bad "CC-TR-02 does not pass the shape this section is built on"
grep -q '^CC-TR-03 PASS' "$TMP/idgraph.out" \
  && ok "…and CC-TR-03 reads its roles declaration off a bulletless line" \
  || bad "CC-TR-03 does not read the standalone roles declaration"

wbs --root "$SHAPE" --profile presale --out-dir "$TMP/shape-out" \
    > "$TMP/shape.summary" 2>&1
diff -q "$TMP/shape-out/wbs.csv" "$EXPECT/wbs-presale.csv" > /dev/null \
  && ok "the export is byte-identical across both References shapes" \
  || { bad "the render disagrees with itself across References shapes"
       diff -u "$EXPECT/wbs-presale.csv" "$TMP/shape-out/wbs.csv" \
         | head -20 | sed 's/^/      /'; }

# the epic linkage, and the roles it feeds — named, so a regression says which
grep -q '^Rows — Appointment Booking:' "$TMP/shape.summary" \
  && ok "the parent epic resolves from a bare path — rows group under it" \
  || bad "the epic did not resolve from a bare-path References line"
awk -F, 'NR>1 && $0 ~ /Specialist/ {n++} END {exit n?0:1}' "$TMP/shape-out/wbs.csv" \
  && ok "the roles declaration resolves — Role cells are populated" \
  || bad "no Role cell carries a declared role"

# the silent drop this defect hid behind: no epic at all
NOEPIC="$TMP/noepic"
mkdir -p "$NOEPIC"
( cd "$PROJ" && tar cf - . ) | ( cd "$NOEPIC" && tar xf - )
python3 - "$NOEPIC" <<'PY'
"""Strip the parent-brief reference from one spec — the unlinkable case."""
import pathlib, sys
p = pathlib.Path(sys.argv[1], "specs/004-appointment-booking/spec.md")
lines = [l for l in p.read_text(encoding="utf-8").splitlines()
         if "scope/E-03.md" not in l]
p.write_text("\n".join(lines) + "\n", encoding="utf-8")
PY
wbs --root "$NOEPIC" --profile presale --out-dir "$TMP/noepic-out" \
    > "$TMP/noepic.summary" 2>&1
grep -q '^Unlinked: 004-appointment-booking' "$TMP/noepic.summary" \
  && ok "a feature with no resolvable epic is named, not silently dropped" \
  || bad "the unlinkable feature vanished without a word in the summary"
python3 - "$TMP/noepic-out/wbs.csv" > "$TMP/noepic.txt" <<'PY'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))[1:]
blank = [r for r in rows if not r[0] and r[2]]
print("%d\t%d\t%s" % (len(rows), len(blank), blank[0][6] if blank else ""))
PY
read -r NE_ALL NE_BLANK NE_ROLE < "$TMP/noepic.txt"
[ "${NE_ALL:-0}" -gt 0 ] \
  && ok "…and its rows still render — $NE_ALL row(s) in the file" \
  || bad "the unlinkable feature's rows were dropped from the export"
[ "${NE_BLANK:-0}" -gt 0 ] \
  && ok "…with the Epic cell empty, never a guessed epic name" \
  || bad "an unlinked row carries an Epic value from nowhere"
[ -n "${NE_ROLE:-}" ] \
  && ok "…and its Role cell still reads — the roles line is read independently" \
  || bad "losing the epic reference also lost the roles declaration"

# the summary must never disagree with the file it describes
printf '\n▸ The summary counts the rows that were written, not the rows that were built\n'
for case in presale:"$TMP/presale" noepic:"$TMP/noepic-out"; do
  label="${case%%:*}"; dir="${case#*:}"
  sums="$TMP/$label.summary"
  [ "$label" = "noepic" ] && sums="$TMP/noepic.summary"
  python3 - "$dir/wbs.csv" "$sums" > "$TMP/$label.count" 2>&1 <<'PY'
import csv, re, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))[1:]
# the file's own per-feature counts are not in the csv, so compare the total
total = len(rows)
text = open(sys.argv[2], encoding="utf-8").read()
claimed = int(re.search(r"WBS export — (\d+) rows", text).group(1))
per = [int(m) for m in re.findall(r"^\| \d{3}-\S+ \| [^|]+ \| (\d+) \|",
                                  text, re.M)]
print("%d\t%d\t%d" % (total, claimed, sum(per)))
PY
  read -r T C P < "$TMP/$label.count"
  [ "$T" = "$C" ] \
    && ok "$label: the headline row count equals the file's rows — $T" \
    || bad "$label: the summary claims $C rows, the file has $T"
  [ "$P" -le "$T" ] \
    && ok "$label: no feature is credited rows the file does not carry" \
    || bad "$label: the per-feature rows sum to $P, the file has $T"
done

# ── 4. the disposition ladder ────────────────────────────────────────────────
#
# certified and no-gate-run are the fixture's own two. The other two rungs are
# produced on a private copy, so the fixture keeps its canonical timeline.

printf '\n▸ The disposition ladder — the four values §10.5 names\n'

COPY="$TMP/ladder"
mkdir -p "$COPY"
( cd "$PROJ" && tar cf - . ) | ( cd "$COPY" && tar xf - )
GR="$COPY/specs/005-specialist-availability-publishing/gate-report.md"

cat > "$GR" <<'ENTRY'
## Gate run 1 — 2026-08-02
Feature: 005-specialist-availability-publishing · Spec revision: d1 · Scopes: F (+H pre-flight)
Verdict: FAIL (2 gaps)

Failures:
CC-G-03 FAIL — §2 US1: publication horizon carried as a marker → answer at the client call, or waive.
CC-G-03 FAIL — §8 Integration Touchpoints: inbound calendar read undecided → answer at the client call, or waive.

Waivers in force:
none
ENTRY
wbs --root "$COPY" --profile presale --out-dir "$TMP/ladder-out" \
    > "$TMP/ladder-fail.summary" 2>&1
grep -q '| 005-specialist-availability-publishing | FAIL(2) |' "$TMP/ladder-fail.summary" \
  && ok "a latest entry with verdict FAIL renders FAIL(2)" \
  || bad "the FAIL verdict did not render as FAIL(n)"
grep -q 'CC-G-03' "$TMP/ladder-out/wbs.csv" \
  && bad "the FAIL report's named-gap lines reached a client cell (D-O22 bars them)" \
  || ok "the FAIL report stays out of Comments / Questions — it is the Q&A agenda (D-O22)"

python3 - "$GR" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
p.write_text(p.read_text(encoding="utf-8")
             .replace("Verdict: FAIL (2 gaps)", "Verdict: PASS")
             .replace("CC-G-03 FAIL", "# resolved: CC-G-03"), encoding="utf-8")
PY
wbs --root "$COPY" --profile presale --out-dir "$TMP/ladder-out2" \
    > "$TMP/ladder-draft.summary" 2>&1
grep -q '| 005-specialist-availability-publishing | draft |' "$TMP/ladder-draft.summary" \
  && ok "a run on record that is not an effective PASS renders draft" \
  || bad "an uncertified, non-FAIL run did not render as draft"

# the certified rung, read from the fixture's own report rather than restated
grep -q '^Certification: run 3 · effective PASS · 2026-07-18$' \
     "$PROJ/specs/004-appointment-booking/gate-report.md" \
  && ok "the certified rung reads the report's own manifest line, run date shown" \
  || bad "the fixture's gate report carries no certification manifest line"

fi  # end of the non-self-test sections

# ── 5. the register, and its negative control ────────────────────────────────

printf '\n▸ The register — every generated cell, plus a seeded-defect control\n'

if [ "$ONLY_SELFTEST" -eq 1 ]; then
  wbs --root "$PROJ" --profile presale --out-dir "$TMP/presale" > /dev/null 2>&1
fi

for prof in discovery presale; do
  [ -f "$TMP/$prof/wbs.csv" ] || continue
  python3 "$SWEEP" "$TMP/$prof/wbs.csv" > "$TMP/$prof.sweep" 2>&1
  rc=$?
  L="$(leaks_of "$TMP/$prof.sweep")"
  if [ "$rc" -eq 0 ] && [ "${L:-x}" = "0" ]; then
    ok "$prof: 0 register leaks across every cell"
  else
    bad "$prof: ${L:-?} register leak(s)"
    grep -v '^cells=' "$TMP/$prof.sweep" | sed 's/^/      /' | head -12
  fi
done

# the waiver tag, in its one legal column — the exception is exercised, not
# merely tolerated
python3 "$CELLS" "$TMP/presale/wbs.csv" > "$TMP/cells.txt"
awk -F'\t' '$2=="Comments / Questions" && $3 ~ /W-004-01/' "$TMP/cells.txt" \
  | grep -q . \
  && ok "the waiver tag renders in Comments / Questions — the named exception" \
  || bad "no waiver tag anywhere; the exception is untested"
awk -F'\t' '$2=="Acceptance Criteria" && $3 ~ /"Booked"/' "$TMP/cells.txt" \
  | grep -q . \
  && ok "quoted status values survive in acceptance text — the second exception" \
  || bad "no quoted status value in any acceptance cell"

# the negative control: three defects, one per exclusion, seeded into a copy of
# a clean csv. An assertion that is never shown to fail is worth nothing.
printf '\n  seeded-defect control — one per exclusion:\n'
CTRL="$TMP/control.csv"
python3 - "$TMP/presale/wbs.csv" "$CTRL" <<'PY'
import csv, sys
rows = list(csv.reader(open(sys.argv[1], encoding="utf-8")))
rows[1][3] += "\nWHEN a Client confirms, THE SYSTEM SHALL book the Slot."
rows[1][5] += "\n[NEEDS CLARIFICATION: seeded]"
rows[2][6] += " CC-IN-03"
with open(sys.argv[2], "w", encoding="utf-8", newline="") as fh:
    csv.writer(fh).writerows(rows)
PY
python3 "$SWEEP" "$CTRL" > "$TMP/control.sweep" 2>&1
CRC=$?
CL="$(leaks_of "$TMP/control.sweep")"
[ "$CRC" -eq 1 ] && ok "the sweep exits non-zero on a dirty file" \
                 || bad "the sweep exited $CRC with defects present"
[ "${CL:-x}" -ge 3 ] 2>/dev/null \
  && ok "the three seeded defects are all caught — $CL hit(s)" \
  || bad "expected at least 3 hits, got ${CL:-?}"
for want in "EARS caps" "marker bracket" "CC-ID"; do
  grep -q "	$want	" "$TMP/control.sweep" \
    && ok "…$want named, with its row and column" \
    || bad "the seeded $want was not reported"
done
grep -q '	Acceptance Criteria	EARS caps' "$TMP/control.sweep" \
  && ok "…and the EARS leak is located in Acceptance Criteria" \
  || bad "the EARS leak was not located in its column"

# ── 6. read-only (§10.5) ─────────────────────────────────────────────────────

if [ "$ONLY_SELFTEST" -eq 0 ]; then

printf '\n▸ Read-only — the source tree is untouched by a run\n'

tree_hash() {
  find "$1" -type f ! -name '.DS_Store' -print0 \
    | LC_ALL=C sort -z \
    | xargs -0 shasum -a 256 2>/dev/null \
    | shasum -a 256 | cut -d' ' -f1
}
BEFORE="$(tree_hash "$PROJ")"
wbs --root "$PROJ" --profile presale --out-dir "$TMP/ro" > /dev/null 2>&1
AFTER="$(tree_hash "$PROJ")"
[ -n "$BEFORE" ] && [ "$BEFORE" = "$AFTER" ] \
  && ok "the fixture project hashes identical before and after — ${BEFORE:0:12}…" \
  || bad "the source tree changed across a run: $BEFORE → $AFTER"

[ -e "$PROJ/exports" ] \
  && bad "a run created exports/ inside the source tree despite --out-dir" \
  || ok "the run wrote only where it was told — no stray exports/ in the source"

# --summary-only writes nothing at all
wbs --root "$PROJ" --profile presale --out-dir "$TMP/none" --summary-only \
    > /dev/null 2>&1
[ -e "$TMP/none" ] \
  && bad "--summary-only created $TMP/none" \
  || ok "--summary-only writes no file at all"

fi  # end of section 6

# ── 7. the roadmap dimension of the summary (§10.5 · D-O100 · EC-22) ─────────
#
# `Included 41 · excluded none` was TRUE of the folders the export read and
# FALSE of the engagement: two in-boundary epics had no folder to be named in.
# The specs dimension holds `nothing silently dropped` over what exists; this
# one holds it over the quoted scope.

printf '\n▸ The roadmap dimension — every in-boundary epic with no rows (D-O100)\n'

QRA="$HERE/fixtures/qr-boundary"
QSUM="$TMP/qr.summary"
wbs --root "$QRA" --summary-only > "$QSUM" 2>&1
QRC=$?

[ "$QRC" -eq 0 ] \
  && ok "the export runs clean over an under-covered roadmap — counts render, no block" \
  || { bad "the export exited $QRC over an under-covered roadmap"; \
       sed 's/^/      /' "$QSUM" | tail -6; }

grep -q '^In-boundary epics with no rows: 13$' "$QSUM" \
  && ok "…and names how many: 13 of the 14 in-boundary epics contributed no row" \
  || bad "the roadmap dimension's count line is missing: $(grep -i 'in-boundary' "$QSUM" | head -1)"

# the ladder — the first missing link the read set already sees, all four states
while IFS='|' read -r want label; do
  [ -z "$want" ] && continue
  grep -Fq "$want" "$QSUM" \
    && ok "…$label" \
    || bad "the ladder does not name $label — wanted: $want"
done <<'LADDER'
  E-10 Public API & Bulk Generation — Phase 2 · Billable Yes — no brief|no brief (E-10, the field case)
  E-11 Premium Redirect Features — Phase 2 · Billable Yes — no brief|no brief (E-11)
  E-12 Campaign Folders — MVP · Billable Yes — brief — no confirmed slicing|brief — no confirmed slicing
  E-13 Bulk CSV Import — MVP · Billable Yes — no spec folder|no spec folder
  E-14 White-label Domains — MVP · Billable Yes — spec — no stories|spec — no stories
LADDER

grep -Fq 'The WBS understates the quoted scope until they are briefed and specced.' "$QSUM" \
  && ok "…and the closing sentence says what the number means" \
  || bad "the closing understatement sentence is missing"

grep -q '^  E-01 ' "$QSUM" \
  && bad "an epic that DID contribute rows was named — the dimension is zero-rows only" \
  || ok "…the one epic that contributed a row is not named"

# vacuous where the check is vacuous: no boundary, no dimension
NOB="$TMP/qr-noboundary"
mkdir -p "$NOB"
cp -R "$QRA/." "$NOB/"
python3 - "$NOB/.specify/aspect-state.md" <<'PYX'
import pathlib, re, sys
p = pathlib.Path(sys.argv[1])
p.write_text(re.sub(r"^Boundary:.*\n", "", p.read_text(encoding="utf-8"),
                    count=1, flags=re.M), encoding="utf-8")
PYX
wbs --root "$NOB" --summary-only > "$TMP/qr-nob.summary" 2>&1
grep -q 'In-boundary epics with no rows' "$TMP/qr-nob.summary" \
  && bad "a boundary-less frame produced a roadmap dimension — it has no ground" \
  || ok "no boundary in the frame: the dimension does not render — the absent-source law"
grep -q '^Included: ' "$TMP/qr-nob.summary" \
  && ok "…and the specs dimension is untouched: one dimension went quiet, not the summary" \
  || bad "the boundary-less summary lost the specs dimension too"

# read-only: the dimension opens no new source and writes nothing
QBEFORE=$(find "$QRA" -type f -exec shasum {} + | shasum | cut -d' ' -f1)
wbs --root "$QRA" --summary-only > /dev/null 2>&1
QAFTER=$(find "$QRA" -type f -exec shasum {} + | shasum | cut -d' ' -f1)
[ "$QBEFORE" = "$QAFTER" ] \
  && ok "…and the estate is byte-identical after the run: the read set is unchanged" \
  || bad "the roadmap dimension wrote to the estate it read"


# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  if [ "$ONLY_SELFTEST" -eq 1 ]; then
    printf '✓ GREEN — the register control: 3 seeded defects, one per exclusion\n'
  else
    printf '✓ GREEN — the WBS export: golden csv (2 profiles) · the xlsx read back · selection · the four dispositions · the register with its control · read-only\n'
  fi
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
