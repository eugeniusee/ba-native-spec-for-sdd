#!/usr/bin/env bash
#
# BA-Native Spec — the source audit's own suite (source-audit definition §10
# item 7). Its first subject is D-S6, the coverage report: Stage 5b renders two
# files, and everything the ruling fixes about them is checkable — the four
# pinned sheets, the derived counts, the coverage formula, the sampled corpus,
# the two refusals.
#
# The audit's other four rulings are judgements a run makes, not shapes a file
# holds, so this suite reaches them where they became mechanical: D-S2's
# derivation is what the render performs, and D-S3's corpus declaration is what
# the render must carry through to the workbook. D-S1, D-S4 and D-S5 stay in
# the document half below.
#
#   1.  the document — v0.5, D-S6–D-S11, §6b, §7's required set, §10, §11, §13,
#       §14, the
#       footer; the entry template's Coverage report field; the mirror's row
#   2.  the skill — Stage 5b compiled: the argument line, the workspace, the
#       four sheets, the title block, the conventions, --report, the nevers
#   3.  the render — the golden csv, the four sheets read back, the title
#       block, the derived counts and the three-surface reconciliation, the
#       coverage formula's three cases, the clean run, and --latest picking the
#       latest CLOSED run — stepping past a Stage-0 refusal and saying so
#   4.  the refusals — no entry on the ledger, a missing required file, no
#       workspace; each naming what is missing
#   5.  the writer — sk_xlsx keeps its single-sheet contract, and the sheet-name
#       rules are enforced rather than written
#   6.  read-only — the fixture hashes identical across a run
#
# The fixture is read, never written: every run writes into the suite's temp
# dir, and section 6 proves it.
#
#   check-audit.sh              run the suite
#   check-audit.sh -v           print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
SK="$PKG_ROOT/payload/specify-overlay/ba/scripts"
DOC="$PKG_ROOT/docs/methodology/ba-native-spec-source-audit-definition.md"
SKILL="$PKG_ROOT/payload/claude/skills/ba-audit/SKILL.md"
TMPL="$PKG_ROOT/payload/specify-overlay/ba/templates/source-audit-report-entry.md"
BLOCK="$PKG_ROOT/payload/mirror/claude-block.md"
FX="$HERE/fixtures/nutrivity-audit/closed-run"
EXPECT="$HERE/fixtures/nutrivity-audit/expected"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,31p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

# `has <file> <literal> <label>` — a fixed-string pin, the estate's own idiom
has() {
  if grep -qF -- "$2" "$1"; then ok "$3"; else bad "$3 — not found: $2"; fi
}
report() { python3 "$SK/sk_audit_report.py" "$@"; }

# ── the sheet reader: every cell of an xlsx, `<sheet>\t<row>\t<col>\t<text>` ──

READER="$TMP/sheets.py"
cat > "$READER" <<'PY'
"""Print every cell of a workbook as `<sheet>\t<row>\t<col>\t<text>`.

Rows and columns are 1-based and count the title block, exactly as a reader
opening the file sees them.
"""
import sys
import xml.etree.ElementTree as ET
import zipfile

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
z = zipfile.ZipFile(sys.argv[1])
wb = ET.fromstring(z.read("xl/workbook.xml"))
names = [s.get("name") for s in wb.iter(NS + "sheet")]
print("sheets\t0\t0\t%s" % " | ".join(names))
for i, name in enumerate(names, start=1):
    sheet = ET.fromstring(z.read("xl/worksheets/sheet%d.xml" % i))
    n_rows = 0
    for r, row in enumerate(sheet.iter(NS + "row"), start=1):
        n_rows = r
        for c, cell in enumerate(row.iter(NS + "c"), start=1):
            text = "".join(t.text or "" for t in cell.iter(NS + "t"))
            print("%s\t%d\t%d\t%s" % (name, r, c, text))
    print("rows\t0\t0\t%s=%d" % (name, n_rows))
PY

cellof() { awk -F'\t' -v s="$2" -v r="$3" -v c="$4" \
             '$1==s && $2==r && $3==c {print $4}' "$1"; }
rowof()  { awk -F'\t' -v s="$2" -v r="$3" \
             '$1==s && $2==r {printf "%s%s", sep, $4; sep=" | "} END {print ""}' "$1"; }
nrows()  { awk -F'\t' -v k="$2" '$1=="rows" && $4 ~ "^"k"=" {sub(/^.*=/,"",$4); print $4}' "$1"; }

# ── 1. the document ──────────────────────────────────────────────────────────

printf '\n▸ The document — v0.5, D-S6–D-S11 and §6b (source-audit definition)\n'

has "$DOC" '**Status:** ruled · 30 August 2026 — v0.5' \
    "the header stands at v0.5"
has "$DOC" '**v0.3 change record:** one ruling — the coverage report' \
    "the v0.3 change record opens the header"
has "$DOC" '## 6b. Stage 5b — the coverage report' \
    "§6b is the coverage report's section"
has "$DOC" '## 13. Amendment record — the coverage report (v0.2 → v0.3)' \
    "§13 is the amendment record"
has "$DOC" 'decisions D-S1–D-S11 locked' \
    "the footer locks D-S1–D-S11"
has "$DOC" 'v0.2→v0.3 in §13' \
    "the footer names the v0.2→v0.3 record"

# the ruling's own load-bearing sentences
has "$DOC" '**The run is not closed until it renders.**' \
    "the teeth: a run is not closed until it renders"
has "$DOC" 'exports/audit-report.xlsx   the primary render — four pinned sheets' \
    "§6b names the xlsx and what it holds"
has "$DOC" 'exports/audit-report.csv    the canonical render — the Coverage Matrix alone' \
    "§6b names the csv and what it carries"
has "$DOC" 'render does not complete the entry does not append**' \
    "the render precedes the append, at D-S4's force"
has "$DOC" 'the D-S4 defect one artifact along' \
    "§6b states why the order is the point"
has "$DOC" 'never the P-A1' \
    "the state rendered is post-repair, never P-A1's"

# the four sheets, their names and their columns
for s in 'Coverage Matrix' 'Per-Source Summary' 'Findings & Rulings' 'SA Register'; do
  has "$DOC" "$s" "§6b pins the sheet \`$s\`"
done
has "$DOC" '| OB | Source | Section | Quote | Modality | Phase claim | Carrier | Status | Finding # |' \
    "the Coverage Matrix's nine columns are pinned"
has "$DOC" '| Source | Sections walked | Sections total | Obligations | Carried | Partial | Accepted | Gaps | Coverage % | Note |' \
    "the Per-Source Summary's ten columns are pinned"
has "$DOC" '| # | CC-S | Evidence — source · section · "quote" | Band check | Proposal → target | Default | Ruling | Outcome |' \
    "the Findings & Rulings columns are pinned"
has "$DOC" '| SA | OB | Source | Quote | Decision | Reason | Approver | Date | Revisit |' \
    "the SA Register's columns are pinned"
has "$DOC" "quote is verbatim** — the register's quote, unshortened and unrewritten" \
    "the matrix quote is verbatim"
has "$DOC" 'is **empty** where it produced none — never a dash,' \
    "an absent finding number is an empty cell"

# the render conventions, and the register that is not carried
has "$DOC" '**§10.5'"'"'s stakeholder register is expressly not carried.**' \
    "the WBS's stakeholder register is expressly not carried"
has "$DOC" 'is BA-facing operational state** — the report ledger'"'"'s own class' \
    "the export is operational state"
has "$DOC" 'no cell merges' "no cell merges, the /ba-wbs convention"
has "$DOC" 'diff-friendly render and carries the Coverage Matrix alone, with no title' \
    "the csv is canonical and title-block-free"

# the derivation and the arithmetic
has "$DOC" '### Every number is derived (D-S2, extended)' \
    "D-S2 extends from the head to the workbook"
has "$DOC" '**Three surfaces, one number.**' \
    "the three-surface reconciliation is stated"
has "$DOC" '**Coverage % is `(carried + accepted) ÷ obligations`, whole percent.**' \
    "the coverage formula is pinned"
has "$DOC" 'take **no half credit**' "partial takes no half credit"
has "$DOC" '0 ÷ 0 is not 100%, and it is not 0% either' \
    "a zero-obligation source renders an empty percentage"
has "$DOC" '**A sampled corpus renders twice.**' \
    "a sampled corpus renders twice"
has "$DOC" 'sample — <walked>/<total> sections walked' \
    "the per-source sample note is pinned"

# --report
has "$DOC" '### `--report` — the re-render' "§6b rules --report"
has "$DOC" 'does nothing else: **no walk, no dispatch, no ruling, no' \
    "--report does nothing but render"
has "$DOC" '**exclusive with `--full`**' "--report is exclusive with --full"
has "$DOC" '**refuses and names `/ba-audit`**' \
    "no entry on the ledger: refuse and name the act"
has "$DOC" '**refuses and names the file**' \
    "a missing required file: refuse and name it"
has "$DOC" '**A refused admission is stepped past; a holed workspace is not.**' \
    "§6b rules the step past a Stage-0 refusal"
has "$DOC" 'never stepping back another run' \
    "§6b forbids stepping back over a holed workspace"

# §7 and §10 and §11 moved in step
has "$DOC" 'exports/audit-report.xlsx  the coverage report — four pinned sheets (§6b)' \
    "§7 lists the xlsx in the artifact block"
has "$DOC" '**The required set is the append condition (D-S4 · D-S6).**' \
    "§7's required set names D-S6"
has "$DOC" 'sk_audit_report.py` — the Stage-5b' \
    "§10 lists the renderer as a compilation unit"
has "$DOC" 'sk_xlsx.py` — **the multi-sheet' "§10 lists the sk_xlsx extension"
has "$DOC" 'never renders a coverage report over anything but the closed run'"'"'s' \
    "§11 refuses a report over any other state"
has "$DOC" 'repairs or rules under `--report` (D-S6)' \
    "§11 fences --report"
has "$TMPL" 'Coverage report: exports/audit-report.xlsx · exports/audit-report.csv' \
    "the entry template carries the Coverage report field"
has "$BLOCK" '`/ba-audit [--full \| --report]`' \
    "the mirror's command table carries --report"
has "$BLOCK" 'a run is not closed until it renders' \
    "the mirror's command table carries the not-closed-until rule"

# the CC-S card is untouched by this amendment — the ruling says so
has "$DOC" 'recompiled:** D-S6 adds a render and no assertion' \
    "the ruling states the card stands byte-unchanged"

# ── 2. the skill ─────────────────────────────────────────────────────────────

printf '\n▸ The skill — Stage 5b compiled into /ba-audit\n'

has "$SKILL" '# `/ba-audit [--full | --report]` — the Scope-S run' \
    "the argument line carries --report"
has "$SKILL" 'It is **exclusive with `--full`**.' \
    "the skill states the exclusivity"
has "$SKILL" '## Stage 5b — the coverage report' "Stage 5b is a stage"
has "$SKILL" '**The run is not closed until it renders**' \
    "the skill carries the teeth"
has "$SKILL" 'exports/audit-report.xlsx   the coverage report — six pinned sheets' \
    "the workspace block lists the xlsx as REQUIRED"
has "$SKILL" 'exports/audit-report.csv    the same run'"'"'s Coverage Matrix, canonical' \
    "the workspace block lists the csv as REQUIRED"
has "$SKILL" '**Stage 5 checks all six before the entry appends**' \
    "Stage 5 checks all six required files"
has "$SKILL" 'appends last** to `.specify/source-audit.md` per the pinned template' \
    "Stage 5 states the close's order"
has "$SKILL" 'sk_audit_report.py --root . --run <n>' \
    "the skill names the renderer's Stage-5b invocation"
has "$SKILL" 'sk_audit_report.py --root . --latest' \
    "the skill names the --report invocation"
for s in 'Coverage Matrix' 'Per-Source Summary' 'Findings & Rulings' 'SA Register'; do
  has "$SKILL" "$s" "the skill pins the sheet \`$s\`"
done
has "$SKILL" '`(carried + accepted) ÷ obligations`, whole percent**' \
    "the skill carries the coverage formula"
has "$SKILL" '**A sampled corpus renders twice.**' \
    "the skill carries the sampled-corpus rule"
has "$SKILL" '**Three surfaces, one number:**' \
    "the skill carries the reconciliation"
has "$SKILL" '**Under `--report`.**' "the skill rules the --report act"
has "$SKILL" '**refuse and name `/ba-audit`**' \
    "the skill carries the no-entry refusal"
has "$SKILL" 'missing a required file, **refuse and name' \
    "the skill carries the missing-file refusal"
has "$SKILL" '**A refused admission is stepped past; a holed workspace is not.**' \
    "the skill carries the step-past rule"
has "$SKILL" 'that opened a' \
    "the skill's --report reads the latest entry that opened a workspace"
has "$SKILL" 'stakeholder register is not its rule · never appends, repairs or rules under' \
    "the skill's never-list fences --report"
has "$SKILL" '**keyed by the decision-list row' "Stage 4 pins repairs.json's row key"

# the three standing blocks are untouched by this pass (register suite owns
# their text; this is the presence pin the audit's own suite keeps)
has "$SKILL" '**Mode read (framework-wide):**' "the mode-read block stands"
has "$SKILL" '**Register self-check (§10.3), before any BA-facing render:**' \
    "the register self-check block stands"
has "$SKILL" '**The session boundary (framework-wide).**' \
    "the session-boundary block stands"

# ── 2b. EC-20 — the repair route becomes executable (D-S7 · D-S8) ────────────
#
# Two defects from the field run of 2026-08-23, and they compound. Stage 4
# mandated a dispatch the dispatch target's own file forbade, so the only
# lawful path for a spec repair was blocked; and when the session — correctly —
# executed nothing it could not execute lawfully, nothing brought the 14 ruled
# rows back. This block holds down the exception (narrow, post-ruling, cited at
# the agent and ruled at the document) and the resumption (a read over two
# already-required files, no re-ruling, no new instrument).

printf '\n▸ EC-20 — the repair route becomes executable (D-S7 · D-S8)\n'

ANALYST="$PKG_ROOT/payload/claude/agents/ba-analyst.md"

# R1 · D-S7 — the named exception, and the fence that survives it
has "$DOC" '## 14. Amendment record — the repair route becomes executable (v0.3 → v0.4)' \
    "§14 is the amendment record"
has "$DOC" 'v0.3→v0.4 in §14' "…and the footer names the v0.3→v0.4 record"
has "$DOC" '**The named exception — why the audit may dispatch the author (D-S7).**' \
    "D-S7 lives in §6 — the route's own home, not the agent file"
has "$DOC" 'this is its one exception.**' \
    "…the fence is upheld and the exception is exactly one"
has "$DOC" 'an author working without a definition' \
    "…and the doc states WHY the fence exists before carving it"
has "$DOC" '**it arrives as the ruling**' \
    "…and why this route is lawful: the definition arrives as the P-A1 ruling"
has "$DOC" '**The bar this does not move.**' \
    "…the audit's authors-nothing bar is named as unmoved"
has "$DOC" 'remains a defined violation of §4**' \
    "…and the D-S1 substitution class is explicitly not reopened"
has "$DOC" 'its `why`, and **D-S8 brings it back**' \
    "…an undispatchable dispatch has a landing, not an improvisation"
has "$DOC" '**One act, two documents, and the split is by subject.**' \
    "…and the split against the framework ruling is stated here (D-O98)"
has "$DOC" '**This document owns the route:**' \
    "…this document claims the route and never the condition"
has "$DOC" 'by **its own law** establishing it as post-ruling and' \
    "…and it is the route's own law that qualifies it…"
has "$DOC" 'never by an enumeration kept at §11' \
    "…never a list kept at §11 — the census this ruling forbids"
has "$SKILL" '**orchestrator D-O98**' \
    "…and Stage 4 names it too, so the two documents agree on the page"

# the agent fence cites the exception and never restates the law
has "$ANALYST" 'the fence is a condition, not a census (D-O98)' \
    "the fence is conditional, not an exception bolted to a flat rule (D-O98)"
has "$ANALYST" 'dispatch is lawful only for a batch author executing an already-ruled route' \
    "…and the condition is stated where a dispatcher reads it"
has "$ANALYST" 'a route qualifies only where its own law establishes it as post-ruling and batch-shaped' \
    "…and a route qualifies by its own law, never by a list kept in the fence"
has "$ANALYST" 'Today exactly one route does: /ba-audit' \
    "…with this route an instance of the test, marked as today's and not the definition"
has "$ANALYST" "/ba-audit's post-ruling Stage-4 repair route" \
    "…naming whose route it is"
has "$ANALYST" 'D-S7' "…and citing the rule that owns it"
has "$ANALYST" 'cited here, never restated' \
    "…cite-never-restate, on the agent's own line"
has "$ANALYST" '**One other caller exists, and it brings its own definition (D-S7).**' \
    "…and the body tells the dispatched agent what governs it there"
has "$ANALYST" 'caller.** A dispatch that arrives with neither a skill definition nor a ruling' \
    "…and closes the set at two"
grep -c 'No skill dispatches it, and none should' "$ANALYST" | grep -q '^1$' \
  && ok "…and the fence sentence itself still stands, amended and not deleted" \
  || bad "the ba-analyst fence sentence was rewritten away rather than excepted"

# R2 · D-S8 — the resumption, drawn from the route's own grammar
has "$DOC" '**The standing ruling carries — ruled, unexecuted rows resume (D-S8).**' \
    "D-S8 lives in §6 beside the route it governs"
has "$DOC" 'the most recent run whose workspace holds a `repairs.json`' \
    "…and names the run it reads, not a scan of the band"
has "$DOC" '**No second ruling. P-A1 does not see it again**' \
    "…no re-ruling: a standing ruling is not a finding"
has "$DOC" '**Resumed rows run first.**' "…and they run ahead of this run's own"
has "$DOC" '`from-run` is **absent** on a row this run ruled' \
    "…the trail is one key, present only where it means something"
has "$DOC" '**No count of attempts closes a row**' \
    "…a re-refusal resumes again; nothing expires a ruling"
has "$DOC" '`superseded — <reason>`' \
    "…and closure without execution is named, never silent"
has "$DOC" '**What this adds: nothing.**' \
    "…and the ruling declares its own zero footprint"
has "$DOC" 'The resumption is a **read**.' \
    "…the mechanism is a read over files §7 already requires"
has "$DOC" '— and READ BY THE NEXT RUN: every row standing' \
    "§7's repairs.json line names its forward reader"

# the skill carries both, and the never-list fences them
has "$SKILL" '**Rows standing ruled and unexecuted come first** (**D-S8**).' \
    "Stage 4 runs resumed rows before its own"
has "$SKILL" '"from-run": 7' "…and pins the from-run key in the row shape"
has "$SKILL" 'one named exception to that agent'"'"'s own fence** (**D-S7**, definition §6)' \
    "…and Stage 4 names the exception it relies on, citing the definition"
has "$SKILL" '**never self-authored**' \
    "…and refuses self-authoring where the dispatch is refused"
has "$SKILL" 'never re-rules a row that stands ruled and' \
    "the never-list fences the second ruling (D-S8)"
has "$SKILL" 'never drops one without naming what closed it' \
    "…and fences the silent drop"
has "$SKILL" '**post-ruling** repair at a ruled target' \
    "…and fences the dispatch to post-ruling repairs only (D-S7)"

# the contradiction is gone: no surface forbids what Stage 4 mandates
if grep -q 'No skill dispatches it, and none should\.$' "$ANALYST"; then
  bad "the bare fence stands while Stage 4 mandates the dispatch — the EC-20 contradiction"
else
  ok "no surface forbids the dispatch Stage 4 mandates — the contradiction pair is gone"
fi

# ── 3. the render ────────────────────────────────────────────────────────────

printf '\n▸ The render — the closed run, read back\n'

# Run 2 is the golden case and stays byte-untouched under D-S11: the four
# pinned sheets, their columns and the csv are asserted against it by run
# number, never by --latest, so a later closed run cannot move the golden
# render out from under them (definition §10 unit 7, amended with v0.5).
report --root "$FX" --run 2 --out-dir "$TMP/latest" > "$TMP/latest.summary" 2>&1
rc=$?
[ "$rc" -eq 0 ] \
  && ok "the golden run renders clean — run 2, the state subject" \
  || { bad "the run-2 render exited $rc"; sed 's/^/      /' "$TMP/latest.summary"; }
if grep -q '^Coverage report — run 2 ' "$TMP/latest.summary"; then
  ok "…and it is run 2 the golden assertions read"
else
  bad "the golden render is not run 2"; sed 's/^/      /' "$TMP/latest.summary"
fi

# --latest is the latest CLOSED run. Run 5 closed in v0.5 grammar, run 4 is a
# Stage-0 refusal with no workspace, and run 3's directory is not on the
# ledger: the answer is 5, and a directory scan would get it wrong.
report --root "$FX" --latest --out-dir "$TMP/newest" > "$TMP/newest.summary" 2>&1
rc=$?
[ "$rc" -eq 0 ] \
  && ok "the --latest run exits clean" \
  || { bad "the --latest run exited $rc"; sed 's/^/      /' "$TMP/newest.summary"; }
if grep -q '^Coverage report — run 5 ' "$TMP/newest.summary"; then
  ok "--latest renders run 5 — the latest closed run, not the latest directory"
else
  bad "--latest did not render run 5"; sed 's/^/      /' "$TMP/newest.summary"
fi
# Run 5 is itself the latest entry with a workspace, so --latest steps past
# nothing on the way to it. Run 4's refusal is stepped past by the *previous
# closed run* selection instead, and the Before & After `Run` row names it —
# asserted in the D-S9–D-S11 block below.
if grep -q '^Stepped past: ' "$TMP/newest.summary"; then
  bad "--latest claims to have stepped past an entry on the way to run 5"
  sed 's/^/      /' "$TMP/newest.summary"
else
  ok "--latest steps past nothing — run 5 is the latest entry with a workspace"
fi

if [ -f "$TMP/latest/audit-report.csv" ]; then
  if diff -u "$EXPECT/audit-report.csv" "$TMP/latest/audit-report.csv" > "$TMP/csv.diff"; then
    ok "audit-report.csv is byte-identical to the golden file"
  else
    bad "audit-report.csv diverges from expected/audit-report.csv"
    head -30 "$TMP/csv.diff" | sed 's/^/      /'
  fi
else
  bad "no audit-report.csv was written"
fi

[ -f "$TMP/latest/audit-report.xlsx" ] \
  && ok "audit-report.xlsx is written beside it — one build, both renders" \
  || bad "no audit-report.xlsx — the primary render is missing"

# the csv carries the Coverage Matrix alone: its header row is the matrix's,
# and it carries no title block
if [ -f "$TMP/latest/audit-report.csv" ]; then
  head -1 "$TMP/latest/audit-report.csv" > "$TMP/csv.head"
  if grep -qF 'OB,Source,Section,Quote,Modality,Phase claim,Carrier,Status,Finding #' "$TMP/csv.head"; then
    ok "the csv's first line is the Coverage Matrix header — no title block above it"
  else
    bad "the csv's first line is not the Coverage Matrix header: $(cat "$TMP/csv.head")"
  fi
  grep -qF 'Source audit run' "$TMP/latest/audit-report.csv" \
    && bad "the csv carries a title block — it is the canonical render" \
    || ok "the csv carries no title block anywhere"
fi

python3 "$READER" "$TMP/latest/audit-report.xlsx" > "$TMP/cells.tsv" 2>"$TMP/cells.err"
if [ ! -s "$TMP/cells.tsv" ]; then
  bad "the xlsx did not read back"; sed 's/^/      /' "$TMP/cells.err"
else
  ok "the xlsx unzips and every part parses as XML"

  SHEETS="$(cellof "$TMP/cells.tsv" sheets 0 0)"
  # The four that render the state keep their names and their order; the two
  # that render the movement are appended after them (D-S11).
  [ "$SHEETS" = "Coverage Matrix | Per-Source Summary | Findings & Rulings | SA Register | Before & After | Fix Log" ] \
    && ok "six sheets, in the pinned order: $SHEETS" \
    || bad "the sheets are [$SHEETS], expected the six pinned names in order"

  # every sheet carries the four-line title block above its bold header row
  for s in 'Coverage Matrix' 'Per-Source Summary' 'Findings & Rulings' 'SA Register'; do
    T1="$(cellof "$TMP/cells.tsv" "$s" 1 1)"
    T2="$(cellof "$TMP/cells.tsv" "$s" 2 1)"
    T4="$(cellof "$TMP/cells.tsv" "$s" 4 1)"
    case "$T1" in
      "Source audit run 2 — 2026-08-23 · profile: Presale")
        ok "$s: title line 1 names the run, the date and the profile" ;;
      *) bad "$s: title line 1 is [$T1]" ;;
    esac
    [ "$T2" = "Status: complete" ] \
      && ok "$s: title line 2 carries the run's recorded status" \
      || bad "$s: title line 2 is [$T2], expected the ledger's status"
    case "$T4" in
      "Corpus covered: sample — "*)
        ok "$s: title line 4 carries the sampled corpus verbatim" ;;
      *) bad "$s: title line 4 is [$T4], expected the Corpus covered line" ;;
    esac
  done

  # the header rows, at row 5 of every sheet
  H="$(rowof "$TMP/cells.tsv" 'Coverage Matrix' 5)"
  [ "$H" = "OB | Source | Section | Quote | Modality | Phase claim | Carrier | Status | Finding #" ] \
    && ok "Coverage Matrix: the nine pinned columns, in order" \
    || bad "Coverage Matrix header is [$H]"
  H="$(rowof "$TMP/cells.tsv" 'Per-Source Summary' 5)"
  [ "$H" = "Source | Sections walked | Sections total | Obligations | Carried | Partial | Accepted | Gaps | Coverage % | Note" ] \
    && ok "Per-Source Summary: the ten pinned columns, in order" \
    || bad "Per-Source Summary header is [$H]"
  H="$(rowof "$TMP/cells.tsv" 'Findings & Rulings' 5)"
  [ "$H" = "# | CC-S | Evidence — source · section · \"quote\" | Band check | Proposal → target | Default | Ruling | Outcome" ] \
    && ok "Findings & Rulings: the eight pinned columns, in order" \
    || bad "Findings & Rulings header is [$H]"
  H="$(rowof "$TMP/cells.tsv" 'SA Register' 5)"
  [ "$H" = "SA | OB | Source | Quote | Decision | Reason | Approver | Date | Revisit" ] \
    && ok "SA Register: the nine pinned columns, in order" \
    || bad "SA Register header is [$H]"

  # a verbatim quote survives a middot of its own — the client's sentence is
  # not re-split at the register grammar's separator
  Q="$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 8 4)"
  [ "$Q" = "Create a 7-day menu plan for 80 patients — per station · per patient group" ] \
    && ok "a quote carrying its own middot renders whole and verbatim" \
    || bad "the quote cell is [$Q]"

  # the finding number rides the OB the list row named, and an OB no row named
  # renders empty — never a dash, never a zero
  [ "$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 9 9)" = "1" ] \
    && ok "OB-004 carries finding 1 — the list row named it" \
    || bad "OB-004's Finding # is [$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 9 9)]"
  [ "$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 8 9)" = "3" ] \
    && ok "OB-003 carries finding 3 — an enumerated amend absorbing two rows" \
    || bad "OB-003's Finding # is wrong"
  [ "$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 14 9)" = "3" ] \
    && ok "OB-009 carries finding 3 too — both members of the amend named" \
    || bad "OB-009's Finding # is wrong"
  [ -z "$(cellof "$TMP/cells.tsv" 'Coverage Matrix' 6 9)" ] \
    && ok "an OB no list row named carries an empty Finding # cell" \
    || bad "OB-001's Finding # is not empty"

  # the derived counts, and the coverage formula's three cases
  R="$(rowof "$TMP/cells.tsv" 'Per-Source Summary' 6)"
  [ "$R" = "FR.md | 8 | 8 | 6 | 3 | 1 | 1 | 1 | 67% | " ] \
    && ok "FR.md: 6 obligations, 3+1 covered → 67% — counted, not asserted" \
    || bad "the FR.md summary row is [$R]"
  R="$(rowof "$TMP/cells.tsv" 'Per-Source Summary' 7)"
  [ "$R" = "CAT.md | 5 | 9 | 4 | 2 | 1 | 0 | 1 | 50% | sample — 5/9 sections walked" ] \
    && ok "CAT.md: the per-source sample note renders beside its 50%" \
    || bad "the CAT.md summary row is [$R]"
  R="$(rowof "$TMP/cells.tsv" 'Per-Source Summary' 9)"
  case "$R" in
    "UI-inspiration.md | 2 | 2 | 0 | 0 | 0 | 0 | 0 |  | zero rows — "*)
      ok "a zero-obligation source renders an empty Coverage % — not 100%, not 0%" ;;
    *) bad "the zero-row source's row is [$R]" ;;
  esac
  R="$(rowof "$TMP/cells.tsv" 'Per-Source Summary' 10)"
  [ "$R" = "TOTAL | 18 | 22 | 12 | 6 | 2 | 2 | 2 | 67% | " ] \
    && ok "the TOTAL row sums the sources and re-derives the percentage" \
    || bad "the TOTAL row is [$R]"

  # three surfaces, one number: the matrix's row count, the TOTAL row's
  # Obligations cell and the ledger entry's Register: line
  N_MATRIX=$(( $(nrows "$TMP/cells.tsv" 'Coverage Matrix') - 5 ))
  N_TOTAL="$(cellof "$TMP/cells.tsv" 'Per-Source Summary' 10 4)"
  N_ENTRY="$(awk '/^## Source audit run 2 /{f=1} f && /^Register: /{
                    sub(/^Register: /,""); sub(/ obligations.*/,""); print; exit}' \
              "$FX/.specify/source-audit.md")"
  if [ "$N_MATRIX" = "$N_TOTAL" ] && [ "$N_TOTAL" = "$N_ENTRY" ]; then
    ok "three surfaces, one number — matrix $N_MATRIX = TOTAL $N_TOTAL = entry $N_ENTRY"
  else
    bad "the three surfaces disagree — matrix $N_MATRIX, TOTAL $N_TOTAL, entry $N_ENTRY"
  fi

  # the ruling and the outcome, joined from two files
  R="$(rowof "$TMP/cells.tsv" 'Findings & Rulings' 6)"
  case "$R" in
    *"| apply | apply | landed") ok "row 1: default apply · ruled apply (apply all) · landed" ;;
    *) bad "the row-1 ruling/outcome pair is wrong: $R" ;;
  esac
  R="$(rowof "$TMP/cells.tsv" 'Findings & Rulings' 7)"
  case "$R" in
    *"| SA | SA the client withdrew"*"| SA-03")
      ok "row 2: excepted from apply all, ruled SA, outcome SA-03" ;;
    *) bad "the row-2 ruling/outcome pair is wrong: $R" ;;
  esac
  R="$(rowof "$TMP/cells.tsv" 'Findings & Rulings' 8)"
  case "$R" in
    *"| amend | amend extend 004 US-1 only"*"| unexecuted — the epic owner is Band 2"*)
      ok "row 3: the amend as ruled, and repairs.json's unexecuted with its why" ;;
    *) bad "the row-3 ruling/outcome pair is wrong: $R" ;;
  esac

  # §10.5's stakeholder register is expressly not carried: a CC-S code renders
  # as itself, where the WBS's own register would have banned it outright
  [ "$(cellof "$TMP/cells.tsv" 'Findings & Rulings' 6 2)" = "CC-S-01" ] \
    && ok "a CC-S code renders as itself — the stakeholder register is not this export's rule" \
    || bad "the Findings sheet's CC-S cell is [$(cellof "$TMP/cells.tsv" 'Findings & Rulings' 6 2)]"

  # the SA Register is the STANDING set, deduplicated against the entry's own
  # repeat of this run's record
  # Standing records are band-global and survive runs, so run 5's SA-04 joins
  # every run's sheet — run 2's included. The golden **csv** is the Coverage
  # Matrix alone and is untouched by it, which is what D-S11 protects.
  N_SA=$(( $(nrows "$TMP/cells.tsv" 'SA Register') - 5 ))
  [ "$N_SA" = "4" ] \
    && ok "the SA Register carries the four standing records, SA-03 once" \
    || bad "the SA Register carries $N_SA rows, expected 4"
  R="$(rowof "$TMP/cells.tsv" 'SA Register' 6)"
  case "$R" in
    "SA-01 | OB-006 | FR.md#§3.3 | view meal status per patient | not carried this band | "*"| EK | 2026-08-21 | "*)
      ok "an SA row carries its quote, its reason, its approver, its date and its trigger" ;;
    *) bad "the SA-01 row is [$R]" ;;
  esac
fi

# the clean run — a run that has not appended, rendering from the P-A1 head
printf '\n▸ The clean run — zero findings, and the render before the append\n'

report --root "$FX" --run 3 --out-dir "$TMP/clean" > "$TMP/clean.summary" 2>&1
rc=$?
[ "$rc" -eq 0 ] \
  && ok "a clean run renders too" \
  || { bad "the clean run exited $rc"; sed 's/^/      /' "$TMP/clean.summary"; }

python3 "$READER" "$TMP/clean/audit-report.xlsx" > "$TMP/clean.tsv" 2>&1
if [ -s "$TMP/clean.tsv" ]; then
  [ "$(nrows "$TMP/clean.tsv" 'Findings & Rulings')" = "5" ] \
    && ok "a clean run renders Findings & Rulings with its header row and no rows" \
    || bad "the clean run's Findings sheet has $(nrows "$TMP/clean.tsv" 'Findings & Rulings') rows, expected 5 (4 title + header)"
  T2="$(cellof "$TMP/clean.tsv" 'Coverage Matrix' 2 1)"
  [ "$T2" = "Status: INCOMPLETE — self-evaluated, no independent A pass" ] \
    && ok "before the append, the title block takes the P-A1 head's conditional Status" \
    || bad "the clean run's status line is [$T2]"
  [ "$(cellof "$TMP/clean.tsv" 'Per-Source Summary' 8 9)" = "100%" ] \
    && ok "a fully carried register renders 100%" \
    || bad "the clean run's TOTAL coverage is [$(cellof "$TMP/clean.tsv" 'Per-Source Summary' 8 9)]"
else
  bad "the clean run's xlsx did not read back"
fi

# ── 4. the refusals ──────────────────────────────────────────────────────────

printf '\n▸ The refusals — each names what is missing\n'

mkdir -p "$TMP/empty/.specify"
: > "$TMP/empty/.specify/source-audit.md"
report --root "$TMP/empty" --latest --out-dir "$TMP/empty/exports" \
       > "$TMP/refuse1.out" 2>&1
rc=$?
[ "$rc" -ne 0 ] \
  && ok "--latest over a ledger with no entry refuses (exit $rc)" \
  || bad "--latest over an empty ledger did not refuse"
grep -qF '/ba-audit' "$TMP/refuse1.out" \
  && ok "the refusal names /ba-audit as the act" \
  || { bad "the refusal does not name the act"; sed 's/^/      /' "$TMP/refuse1.out"; }
[ -e "$TMP/empty/exports" ] \
  && bad "the refused run wrote an exports directory anyway" \
  || ok "a refused run writes nothing"

# a workspace missing a required file — the re-render refuses and names it
cp -R "$FX" "$TMP/holed"
rm -f "$TMP/holed/.specify/ba/runs/band-audit/run-5/trace.json"
report --root "$TMP/holed" --latest --out-dir "$TMP/holed/exports" \
       > "$TMP/refuse2.out" 2>&1
rc=$?
[ "$rc" -ne 0 ] \
  && ok "a workspace missing a required file refuses (exit $rc)" \
  || bad "a holed workspace rendered anyway"
grep -qF 'trace.json' "$TMP/refuse2.out" \
  && ok "the refusal names the missing file" \
  || { bad "the refusal does not name the file"; sed 's/^/      /' "$TMP/refuse2.out"; }
grep -qF 'a re-render is not a repair' "$TMP/refuse2.out" \
  && ok "the refusal says why a re-render cannot fill the hole" \
  || bad "the refusal does not say why"
grep -q '^Coverage report' "$TMP/refuse2.out" \
  && bad "a holed workspace was stepped past and an older run rendered instead" \
  || ok "a holed workspace is refused, never stepped past — the run closed once"

report --root "$FX" --run 99 --out-dir "$TMP/nowhere" > "$TMP/refuse3.out" 2>&1
rc=$?
[ "$rc" -ne 0 ] \
  && ok "a run with no workspace refuses (exit $rc)" \
  || bad "a run with no workspace rendered anyway"
grep -qF 'run-99' "$TMP/refuse3.out" \
  && ok "the refusal names the workspace it looked for" \
  || bad "the refusal does not name the workspace"

# --run and --latest are mutually exclusive, and one is required
report --root "$FX" --run 2 --latest > "$TMP/refuse4.out" 2>&1 \
  && bad "--run and --latest ran together" \
  || ok "--run and --latest are mutually exclusive"
report --root "$FX" > "$TMP/refuse5.out" 2>&1 \
  && bad "the renderer ran with neither --run nor --latest" \
  || ok "the renderer requires one of --run / --latest"

# ── 5. the writer ────────────────────────────────────────────────────────────

printf '\n▸ The writer — sk_xlsx keeps its single-sheet contract\n'

python3 - "$SK" > "$TMP/writer.out" 2>&1 <<'PY'
import sys, tempfile, zipfile
from pathlib import Path
sys.path.insert(0, sys.argv[1])
import sk_xlsx

tmp = Path(tempfile.mkdtemp())
one = sk_xlsx.write(tmp / "one.xlsx", ["A", "B"], [["1", "2"]], [10, 10],
                    title=("t1", "t2"))
z = zipfile.ZipFile(one)
print("parts\t%d" % len(z.namelist()))
print("sheet2\t%s" % ("yes" if "xl/worksheets/sheet2.xml" in z.namelist() else "no"))
print("rels\t%s" % z.read("xl/_rels/workbook.xml.rels").decode())
print("types\t%s" % z.read("[Content_Types].xml").decode())

four = sk_xlsx.write_book(tmp / "four.xlsx", [
    ("One", ["A"], [["x"]], [9], ("t",)),
    ("Two", ["B"], [["y"]], None, ()),
    ("Three", ["C"], [], [9], ()),
    ("Four", ["D"], [["z"]], [9], ()),
])
z = zipfile.ZipFile(four)
print("book_parts\t%d" % len(z.namelist()))
print("book_rels\t%s" % z.read("xl/_rels/workbook.xml.rels").decode())

for name, why in (("a:b", "a colon"), ("x" * 32, "32 characters"),
                  ("[q]", "brackets")):
    try:
        sk_xlsx.write_book(tmp / "bad.xlsx", [(name, ["A"], [["x"]], [9], ())])
        print("refused\tno\t%s" % why)
    except ValueError:
        print("refused\tyes\t%s" % why)
try:
    sk_xlsx.write_book(tmp / "dup.xlsx", [("S", ["A"], [], [9], ()),
                                          ("S", ["B"], [], [9], ())])
    print("dupe\tno")
except ValueError:
    print("dupe\tyes")
PY

w() { awk -F'\t' -v k="$1" '$1==k {print $2}' "$TMP/writer.out"; }
[ "$(w parts)" = "6" ] \
  && ok "write() still emits exactly six parts" \
  || { bad "write() emits $(w parts) parts, expected 6"; sed 's/^/      /' "$TMP/writer.out"; }
[ "$(w sheet2)" = "no" ] \
  && ok "write() emits no second worksheet" \
  || bad "write() emitted a second worksheet"
grep -qF 'Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"' "$TMP/writer.out" \
  && ok "write(): rId1 is the sheet, as it always was" \
  || bad "write()'s worksheet relationship moved"
grep -qF 'Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"' "$TMP/writer.out" \
  && ok "write(): rId2 is the stylesheet, as it always was" \
  || bad "write()'s styles relationship moved"
[ "$(w book_parts)" = "9" ] \
  && ok "write_book() of four sheets emits nine parts" \
  || bad "write_book() emits $(w book_parts) parts, expected 9"
grep -qF 'Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"' "$TMP/writer.out" \
  && ok "write_book(): the stylesheet follows the four worksheets at rId5" \
  || bad "write_book()'s styles relationship is misplaced"
n_refused=$(awk -F'\t' '$1=="refused" && $2=="yes"' "$TMP/writer.out" | wc -l | tr -d ' ')
[ "$n_refused" = "3" ] \
  && ok "an illegal sheet name is refused, not written — all three cases" \
  || bad "$n_refused of 3 illegal sheet names refused"
[ "$(awk -F'\t' '$1=="dupe" {print $2}' "$TMP/writer.out")" = "yes" ] \
  && ok "two sheets may not share a name" \
  || bad "duplicate sheet names were accepted"

# ── 6. read-only ─────────────────────────────────────────────────────────────

printf '\n▸ Read-only — the fixture is read, never written\n'

hash_tree() { find "$1" -type f -print0 | LC_ALL=C sort -z \
                | xargs -0 shasum -a 256 2>/dev/null | shasum -a 256; }
BEFORE="$(hash_tree "$FX")"
report --root "$FX" --latest --out-dir "$TMP/ro" > /dev/null 2>&1
report --root "$FX" --run 3 --out-dir "$TMP/ro3" > /dev/null 2>&1
AFTER="$(hash_tree "$FX")"
[ "$BEFORE" = "$AFTER" ] \
  && ok "the fixture tree hashes identical across two renders" \
  || bad "a render wrote into the fixture tree"
[ -e "$FX/exports" ] \
  && bad "a render created exports/ inside the fixture despite --out-dir" \
  || ok "the render wrote only where it was told"

report --root "$FX" --latest --out-dir "$TMP/none" --summary-only > /dev/null 2>&1
[ -e "$TMP/none" ] \
  && bad "--summary-only created $TMP/none" \
  || ok "--summary-only writes no file at all"

# ── 3c. D-S9–D-S11 — the report shows the movement ───────────────────────────
#
# The second subject of this suite (§10 unit 7, amended with v0.5). Run 5 is a
# closed run in v0.5 grammar: movement in its `re_audit` block, a row resumed
# from run 2, and run 4's refusal standing between it and the previous closed
# run. Run 2 is byte-untouched above, so the golden csv still holds.

printf '\n▸ D-S9–D-S11 — the movement: two sheets, two ratios, the html, the tail\n'

python3 "$READER" "$TMP/newest/audit-report.xlsx" > "$TMP/n.tsv" 2>"$TMP/n.err"
if [ ! -s "$TMP/n.tsv" ]; then
  bad "run 5's xlsx did not read back"; sed 's/^/      /' "$TMP/n.err"
else

  # ── the three export files are the required set (D-S11) ──────────────────
  for f in audit-report.xlsx audit-report.csv audit-stats.html; do
    [ -s "$TMP/newest/$f" ] \
      && ok "the required set carries $f" \
      || bad "$f did not render — the three-file required set is short"
  done

  # ── sheet 5 · Before & After: the pinned columns and rows ────────────────
  R="$(rowof "$TMP/n.tsv" 'Before & After' 5)"
  [ "$R" = "Measure | Previous closed run | At P-A1 | After repairs | Δ since previous | Δ by this ruling | Note" ] \
    && ok "Before & After: the seven pinned columns, in order" \
    || bad "Before & After's header row is [$R]"
  N_BA=$(( $(nrows "$TMP/n.tsv" 'Before & After') - 5 ))
  [ "$N_BA" = "33" ] \
    && ok "…and the 33 pinned measure rows, one per measure the ruling lists" \
    || bad "Before & After carries $N_BA measure rows, expected 33"

  # the previous-closed-run selection: run 4's refusal is stepped past and the
  # `Run` row NAMES it — the column is never a silent zero
  R="$(rowof "$TMP/n.tsv" 'Before & After' 6)"
  case "$R" in
    "Run | 2 | 5 | 5 | "*"stepped past run 4"*)
      ok "the Run row: previous 2, this 5, and run 4's refusal named as stepped past" ;;
    *) bad "the Run row is [$R]" ;;
  esac

  # ── both deltas, and the two ratios (D-S10) ──────────────────────────────
  R="$(rowof "$TMP/n.tsv" 'Before & After' 13)"
  case "$R" in
    "Coverage % (carried + accepted ÷ obligations) | 67% | 60% | 80% | +13 pts | +20 pts | sample"*)
      ok "Coverage %: three grounds, both deltas in points, and the sample note" ;;
    *) bad "the Coverage % row is [$R]" ;;
  esac
  R="$(rowof "$TMP/n.tsv" 'Before & After' 21)"
  case "$R" in
    "Defect density (defects per 100 acceptance items) |  | 35.7 | 21.4 |  | -14.3 pts"*)
      ok "Defect density: a figure at P-A1 and after, one decimal, the delta in points" ;;
    *) bad "the Defect density row is [$R]" ;;
  esac
  # the empty side is the ruling's own rule: empty where either side is empty
  case "$(rowof "$TMP/n.tsv" 'Before & After' 21)" in
    "Defect density"*" |  | 35.7 |"*)
      ok "…and the previous column is empty — run 2 carries no band block" ;;
    *) bad "the density's previous cell is not empty over a run with no band" ;;
  esac

  # ── sheet 6 · Fix Log: the columns and the cross-run join ────────────────
  R="$(rowof "$TMP/n.tsv" 'Fix Log' 5)"
  [ "$R" = "Run | # | From run | OB | CC-S | Proposal → target | Ruling | Target file | Outcome | Why" ] \
    && ok "Fix Log: the ten pinned columns, in order" \
    || bad "Fix Log's header row is [$R]"
  # every run's repairs.json, newest first: run 5's three rows, then run 2's
  N_FL=$(( $(nrows "$TMP/n.tsv" 'Fix Log') - 5 ))
  [ "$N_FL" = "6" ] \
    && ok "…and it sweeps every run — 3 rows from run 5, 3 from run 2" \
    || bad "the Fix Log carries $N_FL rows, expected 6"
  # the resumed row is joined to the run that RULED it, and From run says which
  R="$(rowof "$TMP/n.tsv" 'Fix Log' 8)"
  case "$R" in
    "5 | 3 | 2 | "*) ok "the resumed row carries From run 2 — the run that ruled it" ;;
    *) bad "run 5's resumed row is [$R]" ;;
  esac
  # two rows share a `#`: run 5's own #3 and run 2's #3. `From run` tells them
  # apart, and neither is dropped.
  SHARED="$(awk -F'\t' '$1=="Fix Log" && $3==2 {print $4}' "$TMP/n.tsv" \
            | grep -c '^3$')"
  [ "$SHARED" = "2" ] \
    && ok "two rows share a # across runs — From run tells them apart" \
    || bad "the # column carries $SHARED rows numbered 3, expected 2"

  # ── the four-surface reconciliation (D-S2, extended) ─────────────────────
  N_M=$(( $(nrows "$TMP/n.tsv" 'Coverage Matrix') - 5 ))
  N_T="$(cellof "$TMP/n.tsv" 'Per-Source Summary' 9 4)"
  N_BAO="$(cellof "$TMP/n.tsv" 'Before & After' 8 4)"
  N_E="$(awk '/^## Source audit run 5 /{f=1} f && /^Register: /{
                sub(/^Register: /,""); sub(/ obligations.*/,""); print; exit}' \
          "$FX/.specify/source-audit.md")"
  if [ "$N_M" = "$N_T" ] && [ "$N_T" = "$N_BAO" ] && [ "$N_BAO" = "$N_E" ]; then
    ok "four surfaces, one number — matrix $N_M = TOTAL $N_T = Before & After $N_BAO = entry $N_E"
  else
    bad "the four surfaces disagree — matrix $N_M, TOTAL $N_T, B&A $N_BAO, entry $N_E"
  fi
fi

# ── the dashboard: one self-contained file, six pinned sections ─────────────
H="$TMP/newest/audit-stats.html"
if [ ! -s "$H" ]; then
  bad "audit-stats.html did not render"
else
  # self-contained: the ruling's own words — inline CSS, inline SVG, no script,
  # no external asset. A dashboard that fetches is not one file.
  if grep -qE 'https?://|<script|src=|@import|<link' "$H"; then
    bad "the html reaches outside itself — it must be one self-contained file"
  else
    ok "the html is self-contained — no script, no link, no external asset"
  fi
  grep -q '<svg' "$H" \
    && ok "…and the movement renders as inline SVG" \
    || bad "the html carries no inline SVG: the movement has no picture"
  for s in "Headline" "The movement" "What moved" "Findings by family" "The fix log"; do
    grep -qF "$s" "$H" \
      && ok "…section present: $s" \
      || bad "the html is missing its pinned section: $s"
  done
  # every figure is the sheet's own figure (D-S2's bar)
  grep -qF '60% → 80%' "$H" \
    && ok "…and the headline carries the sheet's own coverage figures" \
    || bad "the html's coverage headline does not match the Before & After sheet"
  # a code never renders bare
  grep -qiE 'forward coverage <span class="q">[(]CC-S-01[)]' "$H" \
    && ok "…and a CC-S code renders beside its gloss, never bare" \
    || bad "the html renders a family without its plain-language gloss"
fi

# ── the five-line closing tail — the renderer's, not the session's ──────────
T5="$TMP/newest.summary"
grep -q '^Coverage 60% → 80% by this ruling · 67% → 80% since the previous report (run 2)\.$' "$T5" \
  && ok "tail line 1 — coverage, by this ruling and since the previous report" \
  || bad "tail line 1 is [$(grep -m1 '^Coverage ' "$T5")]"
grep -q '^Defects per 100 acceptance items 35\.7 → 21\.4 · no acceptance count on run 2\.$' "$T5" \
  && ok "tail line 2 — density, and the previous run carrying no band count says so" \
  || bad "tail line 2 is [$(grep -m1 '^Defects per ' "$T5")]"
grep -q '^Fixes: 2 landed · 0 unexecuted — resume next run · 1 declined (SA) · 1 resumed from earlier runs\.$' "$T5" \
  && ok "tail line 3 — the four fix counts" \
  || bad "tail line 3 is [$(grep -m1 '^Fixes: ' "$T5")]"
grep -q '^Findings this run: 3 — .*forward coverage (CC-S-01).*$' "$T5" \
  && ok "tail line 4 — findings, each family beside its gloss" \
  || bad "tail line 4 is [$(grep -m1 '^Findings this run' "$T5")]"
grep -q '^Report: exports/audit-stats\.html — the picture · audit-report\.xlsx · audit-report\.csv\.$' "$T5" \
  && ok "tail line 5 — the three files, the picture named first" \
  || bad "tail line 5 is [$(grep -m1 '^Report: ' "$T5")]"
# the tail asks nothing: §8's budget is untouched
grep -qE '^(What I need from you|\?)' "$T5" \
  && bad "the tail asks something — §8's budget is not the renderer's to spend" \
  || ok "…and the tail asks nothing"

# the first-run case: no previous closed run, and both `since` halves say so
report --root "$TMP/holed2" --run 1 --out-dir "$TMP/first" > "$TMP/first.out" 2>&1 || true
cp -R "$FX" "$TMP/firstrun" 2>/dev/null
python3 - "$TMP/firstrun" <<'PY'
import pathlib, sys, re
# a band whose only entry is run 1: the previous-closed-run column has nothing
led = pathlib.Path(sys.argv[1]) / ".specify" / "source-audit.md"
t = led.read_text(encoding="utf-8")
head, _sep, _rest = t.partition("## Source audit run 2 ")
led.write_text(head + "## Standing SA records\n", encoding="utf-8")
PY
mkdir -p "$TMP/firstrun/.specify/ba/runs/band-audit/run-1"
cp "$FX/.specify/ba/runs/band-audit/run-5/"*.md \
   "$FX/.specify/ba/runs/band-audit/run-5/trace.json" \
   "$TMP/firstrun/.specify/ba/runs/band-audit/run-1/" 2>/dev/null
report --root "$TMP/firstrun" --run 1 --out-dir "$TMP/firstrun/exports" \
       > "$TMP/firstrun.out" 2>&1
grep -q 'first closed run — no previous report' "$TMP/firstrun.out" \
  && ok "the first closed run says so — no previous report, never a zero" \
  || { bad "the first-run case does not name itself"; sed 's/^/      /' "$TMP/firstrun.out"; }

# ── --band: the count is mechanical, and it is pasted rather than typed ─────
report --band --root "$PKG_ROOT/tests/fixtures/appointment-booking/project" \
       > "$TMP/band.out" 2>&1
rc=$?
[ "$rc" -eq 0 ] \
  && ok "--band exits clean over a fixture band" \
  || { bad "--band exited $rc"; sed 's/^/      /' "$TMP/band.out"; }
python3 - "$TMP/band.out" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))["band"]
need = {"specs", "stories", "acceptance_items", "unreadable"}
assert need <= set(d), sorted(need - set(d))
assert d["specs"] == 2 and d["stories"] == 5 and d["acceptance_items"] == 14, d
assert d["unreadable"] == [], d
PY
[ $? -eq 0 ] \
  && ok "…and prints the four pinned keys, counted by the gate's own parser" \
  || bad "--band's block is not the four pinned keys over the fixture band"
has "$SKILL" 'sk_audit_report.py --band --root .' \
    "the skill names the counter, so the figure is pasted and never typed"
has "$DOC" 'pastes it verbatim' \
    "…and the document says the session pastes it (D-S10)"


# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — the source audit: D-S6 in the document and the skill · the four pinned sheets read back · the golden csv · the derived counts and the three surfaces · the clean run · the four refusals · sk_xlsx single-sheet contract · read-only\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
