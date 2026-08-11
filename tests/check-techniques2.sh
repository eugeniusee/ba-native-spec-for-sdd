#!/usr/bin/env bash
#
# BA-Native Spec — the technique suite, batch II (build plan §4, S6 exit test).
#
# Build plan §4, S6 row: *Context + Value + Vision + Solution clear on the toy:
# constraints/context/competitive land; canvas §§2–12 filled per AT-VA/VI/SO;
# TC-1…TC-3 surface present on any elected persona charter.*
#
#   1.  the four aspects' plans carry the seven techniques with pinned contracts
#   2.  T-05/T-06/T-07 land context, constraints and competitive analysis in
#       the shapes their sheets pin
#   3.  the Assumed → Confirmed round trip: one row, flipped in place
#   4.  canvas §§2–12 at ASPECT grade — AT-VA-1/-2 · AT-VI-1/-2 · AT-SO-1/-2/-3
#   5.  the elected charter, TC-1…TC-3 checked mechanically
#   6.  the four §12 evidence tables, EVIDENCED — every row's claim re-derived
#   7.  23 seeded defects, one per rule — the suite is not vacuous
#   8.  /ba-run dispatch: the interface the seven skills implement, both ends
#   9.  the compiled skills' locked content — depth boundaries, contracts,
#       signals, refusals
#   10. layering — no methodology-layer content in the S6 payload
#
# Same split as S5: the **validator runs live** (tests/check-band1-artifacts.py);
# the artifacts are recorded, because producing one is an agent act.
#
#   check-techniques2.sh        run the suite
#   check-techniques2.sh -v     print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
FP="$FX/band1/first-pass"
EL="$FX/band1/elected"
PROJ="$FX/project"
MEM="$PROJ/.specify/memory"
SKILLS="$PKG_ROOT/payload/claude/skills"
AGENTS="$PKG_ROOT/payload/claude/agents"
VALIDATE="$HERE/check-band1-artifacts.py"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASSED=0; FAILED=0
ok()  { PASSED=$((PASSED+1)); [ "$VERBOSE" -eq 1 ] && printf '  ✓ %s\n' "$1"; return 0; }
bad() { FAILED=$((FAILED+1)); printf '  ✗ %s\n' "$1"; }

flat_has() {
  python3 - "$1" "$2" <<'PY'
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}
has()   { flat_has "$1" "$2" && ok "$3" || bad "$3 — not found: $2"; }
hasnt() { flat_has "$1" "$2" && bad "$3 — present but must not be: $2" || ok "$3"; }

mutate() {
  python3 - "$@" <<'PY'
import sys, pathlib
base, out = sys.argv[1], sys.argv[2]
t = pathlib.Path(base).read_text(encoding="utf-8")
args = sys.argv[3:]
for old, new in zip(args[0::2], args[1::2]):
    if old not in t:
        sys.exit(f"mutation source not present in {base}: {old!r}")
    t = t.replace(old, new, 1)
pathlib.Path(out).parent.mkdir(parents=True, exist_ok=True)
pathlib.Path(out).write_text(t, encoding="utf-8")
PY
}

neg() {
  local label="$1" expect="$2"; shift 2
  if python3 "$VALIDATE" "$@" --expect "$expect" > "$TMP/neg.out" 2>&1; then
    ok "$label → $expect"
  else
    bad "$label — expected $expect"
    sed 's/^/      /' "$TMP/neg.out"
  fi
}

M="$TMP/mut"; mkdir -p "$M"
STATE="$FX/band1/aspect-state.md"
PLANS="$FX/band1/aspect-plans.md"

# ── 1. the plans that hold the seven techniques ──────────────────────────────

printf '\n▸ The four aspects plan the seven techniques (orchestrator §6.2/§6.3)\n'

for row in \
  "t05 context & landscape mapping|{context & landscape — existing systems + organizational landscape, or the sourced greenfield line · Context · \`.specify/memory/context.md\`}" \
  "t06 constraints elicitation|{constraints & limitations — three class sections, each a Confirmed row or none identified — <basis> · Context · \`.specify/memory/constraints.md\`}" \
  "t07 competitive analysis|{competitive analysis — one entry per named alternative, the status quo screened · Context · \`.specify/memory/competitive-analysis.md\`}" \
  "t08 value definition|{problems + objectives at aspect grade — who-hurts resolving, every objective linked · Context · \`canvas.md\` — Problems · Objectives}" \
  "t09 vision & differentiation|{product statement + differentiation against a named Unlike entry, the constraint scan run · Context · \`canvas.md\` — Product.The/Is/That · Competition.Our Solution}" \
  "t10 solution surface review|{solution surface, each element linked or ruled · Context · \`canvas.md\` — Forms · Core Functions · Third-Party Connections · Localization}"
do
  name="${row%%|*}"; triple="${row#*|}"
  short="${name%% *}"
  has "$PLANS" "$triple" "the composed plan pins $short's output contract"
  # the same triple the skill self-checks against, backticks stripped
  plain="$(printf '%s' "$triple" | tr -d '`')"
  has "$SKILLS/ba-$short/SKILL.md" "$plain" "…and ba-$short carries it, character for character"
done

# T-04 is deliberately on NO plan — enrichment the BA never elected here
grep -q 't04' "$PLANS" \
  && bad "a composed plan elects t04; the canonical timeline runs charter-free" \
  || ok "no plan elects t04 — charter absence is the world's own legal end state"
[ -f "$MEM/personas.md" ] \
  && bad "personas.md is in the estate; the Requirements evidence table says it is not" \
  || ok "no personas.md in the estate — AT-RQ-2's persona clause stays dormant, as the table records"

# ── 2. context · constraints · competitive land ──────────────────────────────

printf '\n▸ T-05/T-06/T-07 land their artifacts (b2 T-05/T-06/T-07 §3/§5)\n'

if python3 "$VALIDATE" --context "$MEM/context.md" --constraints "$MEM/constraints.md" \
     --competitive "$MEM/competitive-analysis.md" > "$TMP/ctx.out" 2>&1; then
  ok "$(cat "$TMP/ctx.out")"
else
  bad "the Context estate does not validate:"; sed 's/^/      /' "$TMP/ctx.out"
fi

if python3 "$VALIDATE" --constraints "$FP/constraints.md" > "$TMP/fpc.out" 2>&1; then
  ok "the first-pass constraints file validates too"
else
  bad "the first-pass constraints file does not validate:"; sed 's/^/      /' "$TMP/fpc.out"
fi

# the D-W2 split, asserted rather than assumed: the bind is in one file only
hasnt "$MEM/context.md" "not replaced; the product does not replace them" \
    "the landscape carries no binding statement"
has "$MEM/constraints.md" "Specialists' existing calendars are retained, not replaced" \
    "…and the constraints file carries the bind, with its own status and source"
has "$MEM/context.md" "retained, not replaced" \
    "…while the landscape keeps the descriptive side of the same fact"

# T-07 supplies targets and deltas; it never writes the statement
hasnt "$MEM/competitive-analysis.md" "Differentiation (canvas" \
    "the competitive analysis authors no differentiation statement (T-09's ground)"
has "$MEM/competitive-analysis.md" "(status quo)" \
    "the status quo is screened, and labelled as such"

# ── 3. the Assumed → Confirmed round trip ────────────────────────────────────

printf '\n▸ The Status flip: one row, edited in place (D-B2-4 · the 07-14 batch)\n'

if python3 "$VALIDATE" --flip-early "$FP/constraints.md" --flip-later "$MEM/constraints.md" \
     > "$TMP/flip.out" 2>&1; then
  ok "every first-pass row survives the flip with its class, wording and position"
else
  bad "the flip broke a row:"; sed 's/^/      /' "$TMP/flip.out"
fi

grep -q '| Specialists.* retained, not replaced | Assumed |' "$FP/constraints.md" \
  && ok "at Band 1 the calendar row stands Assumed — the material implies it, nobody confirmed it" \
  || bad "the first-pass calendar row is not Assumed; then there is no flip to make"
grep -q '| Specialists.* retained, not replaced | Confirmed |' "$MEM/constraints.md" \
  && ok "…and the 07-14 batch flipped it to Confirmed, the row keeping its place" \
  || bad "the mature calendar row is not Confirmed; the ingestion batch's flip is missing"
has "$MEM/constraints.md" "call 2026-07-14 (assumption A1 confirmed)" \
    "the confirming source is recorded on the row it confirmed"

# ── 4. canvas §§2–12 at aspect grade ─────────────────────────────────────────

printf '\n▸ canvas §§2–12 filled per AT-VA/VI/SO (b3 T-08/T-09/T-10)\n'

if python3 "$VALIDATE" --canvas "$PROJ/canvas.md" --register "$MEM/stakeholders.md" \
     --aspect-grade > "$TMP/ag.out" 2>&1; then
  ok "$(cat "$TMP/ag.out")"
else
  bad "the mature canvas is not at aspect grade:"; sed 's/^/      /' "$TMP/ag.out"
fi

# and the framed canvas is NOT — which is what makes the aspects' work visible
if python3 "$VALIDATE" --canvas "$FP/canvas.md" --register "$FP/stakeholders.md" \
     --aspect-grade > "$TMP/fg.out" 2>&1; then
  bad "the FRAMED canvas passes aspect grade — then the aspects had nothing to do"
else
  ok "the framed canvas fails aspect grade — the holes the aspects filled were real"
fi
grep -q 'B35\|B36' "$TMP/fg.out" \
  && ok "…and it fails on the differentiation and the surface, exactly where framing stopped" \
  || bad "the framed canvas fails aspect grade for the wrong reasons: $(cat "$TMP/fg.out")"

n_fn=$(python3 - "$PROJ/canvas.md" <<'PY'
import pathlib, re, sys
for ln in pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").splitlines():
    if re.match(r"^\|\s*7\s*\|", ln):
        print(len([s for s in re.split(r"\s+·\s+", ln.split("|")[3]) if s.strip()]))
        break
PY
)
[ "$n_fn" = "5" ] && ok "5 capability lines against the ten-line ceiling" \
                  || bad "canvas §7 has $n_fn capability lines; the evidence table says 5"

has "$PROJ/canvas.md" "currencies: \`N/A — no payment surface in MVP scope\`" \
    "§9's currencies facet is an explicit ruling, not a silence"
has "$PROJ/canvas.md" "direction — outbound" \
    "§8 states its direction, and the row carries its role before it"

# ── 5. the elected charter ───────────────────────────────────────────────────

printf '\n▸ TC-1…TC-3 on the elected charter (b2 T-04 §5, D-B2-2)\n'

if python3 "$VALIDATE" --register "$FP/stakeholders.md" --personas "$EL/personas.md" \
     > "$TMP/pers.out" 2>&1; then
  ok "$(cat "$TMP/pers.out")"
else
  bad "the elected charter does not validate:"; sed 's/^/      /' "$TMP/pers.out"
fi

has "$EL/personas.md" "TC-1 — Details: exactly one register population per charter" "TC-1 ships in the file"
has "$EL/personas.md" "TC-2 — System-facing activities: capability-level lines (verb + object)" "TC-2 ships in the file"
has "$EL/personas.md" "TC-3 — Namespace: persona names are charter-local human forenames" "TC-3 ships in the file"

# TC-3 has teeth downstream, or it is decoration: the screened name appears in no spec
if grep -rq 'Marta' "$PROJ/specs" "$MEM" 2>/dev/null; then
  bad "the persona name 'Marta' appears in the estate or a spec — CC-XA-02's non-waivable ground"
else
  ok "the persona name appears in no spec and in no estate file — the screen has something to screen"
fi

# one world, two doors: the negative fixture and the elected charter agree on names
python3 - "$EL/personas.md" "$FX/negatives/personas.md" <<'PY' \
  && ok "the elected charter and the screening fixture carry the same persona name set" \
  || bad "the two personas fixtures have drifted into two worlds"
import pathlib, re, sys
RE = re.compile(r"^\s*(?:#{1,6}\s+|\*\*)([A-Z][\w'’-]*)\s*[—–-]\s*details\s*:", re.IGNORECASE)
def names(p):
    out = []
    for ln in pathlib.Path(p).read_text(encoding="utf-8").splitlines():
        m = RE.match(ln.strip())
        if m and m.group(1).lower() not in ("tc", "field"):
            out.append(m.group(1))
    return sorted(set(out))
sys.exit(0 if names(sys.argv[1]) == names(sys.argv[2]) and names(sys.argv[1]) else 1)
PY

# ── 6. the four evidence tables, EVIDENCED ───────────────────────────────────

printf '\n▸ Context · Value · Vision · Solution evidence tables, re-derived\n'

for a in Context Value Vision Solution; do
  has "$STATE" "Aspect gate review — $a — 2026-07-" "$a's clearing carries an evidence table"
done

# AT-CX-1 — the two systems and the landscape the row claims
for s in "Specialists' external calendars" "Phone lines at the clinics"; do
  grep -q "$s" "$MEM/context.md" \
    && ok "AT-CX-1 evidenced — the landscape names $s" \
    || bad "AT-CX-1's row claims $s; context.md does not name it"
done
grep -q 'eight clinics' "$MEM/context.md" \
  && ok "AT-CX-1 evidenced — the organizational landscape carries the eight-clinic network" \
  || bad "AT-CX-1's row claims the eight-clinic landscape; the file does not carry it"

# AT-CX-2 — every class carries a Confirmed row, counted from the file
python3 - "$MEM/constraints.md" <<'PY' \
  && ok "AT-CX-2 evidenced — all three classes carry ≥ 1 Confirmed row, counted live" \
  || bad "AT-CX-2's row claims a Confirmed row per class; the file says otherwise"
import pathlib, re, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
blocks = re.split(r"^##\s+", txt, flags=re.M)[1:]
if len(blocks) != 3:
    sys.exit(1)
for b in blocks:
    rows = [ln for ln in b.splitlines() if ln.startswith("|") and "---" not in ln][1:]
    if not any(ln.split("|")[2].strip() == "Confirmed" for ln in rows):
        sys.exit(1)
sys.exit(0)
PY

# AT-CX-3 — the canvas Unlike names resolve to competitive-analysis entries
python3 - "$PROJ/canvas.md" "$MEM/competitive-analysis.md" <<'PY' \
  && ok "AT-CX-3 evidenced — every canvas Unlike name resolves to an analysis entry" \
  || bad "AT-CX-3's row claims the Unlike names are backed; at least one resolves to nothing"
import pathlib, re, sys
canvas = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
comp = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8").lower()
cell = ""
for ln in canvas.splitlines():
    if re.match(r"^\|\s*10\s*\|", ln):
        cell = ln.split("|")[3]
names = [re.sub(r"`[^`]*`", "", s).strip().lower() for s in re.split(r"\s+·\s+", cell)]
names = [n for n in names if n]
sys.exit(0 if names and all(n in comp for n in names) else 1)
PY

# AT-VA-2 — the baseline the row claims is on the line
has "$PROJ/canvas.md" "baseline: the ~30% unanswered-call rate" \
    "AT-VA-2 evidenced — O-2 carries the baseline the evidence row names"

# AT-VI-3 — the scan's row set IS the Confirmed set at scan time
has "$STATE" "§1 excluded: Status \`Assumed\` at scan time" \
    "AT-VI-3's row states why the technical class is out of the scan"
python3 - "$FP/constraints.md" <<'PY' \
  && ok "AT-VI-3 evidenced — at scan time exactly §2 and §3 were Confirmed, §1 Assumed" \
  || bad "AT-VI-3's row claims a Confirmed set the 07-09 file does not have"
import pathlib, re, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
blocks = re.split(r"^##\s+", txt, flags=re.M)[1:]
got = []
for b in blocks:
    name = b.splitlines()[0].strip()
    rows = [ln for ln in b.splitlines() if ln.startswith("|") and "---" not in ln][1:]
    got.append((name, sorted({ln.split("|")[2].strip() for ln in rows})))
sys.exit(0 if got == [("1. Technical", ["Assumed"]),
                      ("2. Business", ["Confirmed"]),
                      ("3. Regulatory", ["Confirmed"])] else 1)
PY

# AT-SO-2 — the RO-1 delta reckoning only holds if the line carried a link
has "$STATE" "all five function lines carry \`→ O-2\`" \
    "AT-SO-2's row claims every function is linked"
has "$STATE" "the function's objective link is unchanged, only its actor list grew" \
    "…which is what the RO-1 dependent reckoning re-reads it against"

has "$STATE" "→ CLEARED · Y.K. · 2026-07-09" "the BA's ruling closes each table — no aspect self-clears"

# ── 7. seeded defects — one per new rule ─────────────────────────────────────

printf '\n▸ Seeded defects — 23 rules, 23 mutations (the suite is not vacuous)\n'

CTX="$MEM/context.md"; CON="$MEM/constraints.md"; COMP="$MEM/competitive-analysis.md"
PER="$EL/personas.md"; CV="$PROJ/canvas.md"; REG="$MEM/stakeholders.md"

mutate "$CTX" "$M/b17.md" "## Organizational landscape" "## Org landscape"
neg "B17 context — a section renamed" B17 --context "$M/b17.md"

mutate "$CTX" "$M/b18.md" \
  "| System | Role today | Disposition (where stated) | Source |" \
  "| System | Role today | Constraint | Source |"
neg "B18 context — the Disposition column becomes a Constraint column" B18 --context "$M/b18.md"

mutate "$CTX" "$M/b19.md" \
  "| canvas: Problems P-1 · kickoff notes · call 2026-07-14 |" "|  |"
neg "B19 context — a systems row with no source" B19 --context "$M/b19.md"

mutate "$CTX" "$M/b20.md" \
  "retained, not replaced — the network stated it plainly at presale" \
  "the product must not replace them"
neg "B20 context — a binding statement in the landscape" B20 --context "$M/b20.md"

mutate "$CON" "$M/b21.md" "## 2. Business" "## 2. Commercial"
neg "B21 constraints — a class renamed" B21 --constraints "$M/b21.md"

mutate "$CON" "$M/b22.md" \
  "| Constraint | Status | Source |
|---|---|---|
| Specialists" \
  "| ID | Constraint | Status | Source |
|---|---|---|---|
| C-T1 | Specialists"
neg "B22 constraints — an ID column the sheet does not pin" B22,B23 --constraints "$M/b22.md"

mutate "$CON" "$M/b23.md" "| Confirmed | presale brief" "| Confirmed — 2026-07-14 | presale brief"
neg "B23 constraints — a date inside the Status cell" B23 --constraints "$M/b23.md"

mutate "$CON" "$M/b24.md" \
  "| The product stores and processes no medical-record data; Client personal data stays inside the binding national personal-data regime | Confirmed | Olena, 2026-07-09 |
" ""
neg "B24 constraints — the regulatory class falls silent" B24 --constraints "$M/b24.md"

mutate "$COMP" "$M/b25.md" \
  "| Alternative | Category | Covers | Falls short | Source |" \
  "| Competitor | Category | Covers | Falls short | Source |"
neg "B25 competitive — a renamed column" B25 --competitive "$M/b25.md"

mutate "$COMP" "$M/b26.md" \
  "Phone-and-paper scheduling at the incumbent clinics (status quo) | current way of working" \
  "Phone-and-paper scheduling at the incumbent clinics | incumbent process"
neg "B26 competitive — the status quo goes unscreened" B26 --competitive "$M/b26.md"

mutate "$COMP" "$M/b27.md" \
  "no cancellation notice back to the Specialist → P-2" \
  "no cancellation notice back to the Specialist"
mutate "$M/b27.md" "$M/b27.md" \
  "a Client cannot browse the network's Specialists in one place → O-2" \
  "a Client cannot browse the network's Specialists in one place"
neg "B27 competitive — an unkeyed delta is decoration" B27 --competitive "$M/b27.md"

mutate "$PER" "$M/b28.md" "TC-3 — Namespace: persona names are charter-local human forenames," "TC-3 —"
neg "B28 personas — a transformation clause dropped" B28 --personas "$M/b28.md" --register "$REG"

mutate "$PER" "$M/b29.md" \
  "| Frustrations | Calls to the clinic go unanswered → P-1 \`[canvas: Problems P-1]\` |" \
  "| Frustrations |  |"
neg "B29 personas — an empty charter field" B29 --personas "$M/b29.md" --register "$REG"

mutate "$PER" "$M/b30.md" "## Marta — details: Clients" "## Marta — details: Receptionists"
neg "B30 personas — TC-1: a population resolving to no register entry" B30 \
    --personas "$M/b30.md" --register "$REG"

mutate "$PER" "$M/b31.md" "## Marta — details: Clients" "## Clients — details: Clients"
neg "B31 personas — TC-3: a persona name colliding with a register population" B31 \
    --personas "$M/b31.md" --register "$REG"

mutate "$CV" "$M/b32.md" "P-2 — Specialists lose income" "P-2 — Practitioners lose income"
neg "B32 canvas — a who-hurts resolving to no register population" B32 \
    --canvas "$M/b32.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b33.md" \
  "O-2 — reduce lost bookings; baseline: the ~30% unanswered-call rate \`[kickoff notes]\` \`→ P-1\`" \
  "O-2 — reduce lost bookings; baseline: the ~30% unanswered-call rate \`[kickoff notes]\`"
neg "B33 canvas — an objective with no arrow-link to its problem" B33 --canvas "$M/b33.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b34.md" \
  "A self-service booking surface for a clinic network \`[presale brief]\`" \
  "open — no source material"
neg "B34 canvas — a Product slot still open at clearing" B34 --canvas "$M/b34.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b35.md" "unanswered line \`→ P-1\` \`→ O-2\`" "unanswered line"
neg "B35 canvas — a differentiation that keys nothing" B35 --canvas "$M/b35.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b36.md" "Responsive web \`[kickoff notes]\`" "open — no source material"
neg "B36 canvas — a surface section still open at clearing" B36 --canvas "$M/b36.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b37.md" "Cancel own Appointment \`→ O-2\`" "Cancel own Appointment"
neg "B37 canvas — a function serving nothing" B37 --canvas "$M/b37.md" --register "$REG" --aspect-grade

mutate "$CV" "$M/b38.md" \
  "; direction — outbound: appointment events mirrored to the calendar the Specialist already keeps" \
  "; appointment events mirrored to the calendar the Specialist already keeps"
neg "B38 canvas — a connection row with no direction, stated or open" B38 \
    --canvas "$M/b38.md" --register "$REG" --aspect-grade

mutate "$CON" "$M/b39.md" \
  "Specialists' existing calendars are retained, not replaced" \
  "Specialists' existing calendars are kept"
neg "B39 flip — the row was rewritten instead of edited" B39 \
    --flip-early "$FP/constraints.md" --flip-later "$M/b39.md"

# ── 8. /ba-run dispatch, both ends ───────────────────────────────────────────

printf '\n▸ /ba-run dispatch for the batch (orchestrator §6.3/§7.1)\n'

for t in t04 t05 t06 t07 t08 t09 t10; do
  f="$SKILLS/ba-$t/SKILL.md"
  if [ ! -f "$f" ]; then bad "ba-$t/SKILL.md missing"; continue; fi
  head -8 "$f" | grep -qx -- "name: ba-$t" || bad "ba-$t — frontmatter name does not match its directory"
  head -8 "$f" | grep -qx 'disable-model-invocation: true' \
    || bad "ba-$t — missing disable-model-invocation: true (D-P2-2)"
  head -8 "$f" | grep -q '^description: .' || bad "ba-$t — no description"
  [ -f "$SKILLS/ba-$t/references/example.md" ] \
    || bad "ba-$t — no references/example.md (D-P2-10)"
  flat_has "$f" "BA-invoked, never auto-fired" || bad "ba-$t — does not inherit the invocation discipline"
  flat_has "$f" "is the one-step entry" || bad "ba-$t — does not carry the one-step entry sentence"
  flat_has "$f" "P-O3 (technique invocation), compiled in" || bad "ba-$t — the contract check is not compiled into its heading"
  flat_has "$f" "## At run end — compiled bookkeeping" || bad "ba-$t — no compiled run-end bookkeeping block"
  flat_has "$f" "Self-check, and stop if either half fails" || bad "ba-$t — no P-O3 self-check at the top"
  flat_has "$f" "Skip-if" || bad "ba-$t — no skip-if condition"
  flat_has "$f" "Depth boundary" || bad "ba-$t — no depth boundary"
  flat_has "$f" "What this skill never does" || bad "ba-$t — no refusal discipline stated"
  flat_has "$f" "never confirms an AT criterion or clears an aspect" \
    || bad "ba-$t — does not refuse to clear its own aspect"
done
ok "seven technique skills: frontmatter · references/example.md · self-check · skip-if · depth · refusals"

# each aspect-serving skill reports and leaves the refresh to /ba-run
for t in t05 t06 t07 t08 t09 t10; do
  has "$SKILLS/ba-$t/SKILL.md" "belong to this skill's run-end block" \
      "ba-$t reports its criteria and leaves the refresh to its own run-end block (§7.4)"
done
# T-04 is the exception, and says why in as many words
has "$SKILLS/ba-t04/SKILL.md" "Enrichment feeds no evidence-table row" \
    "ba-t04 states that enrichment moves no table — the refresh changes nothing"

# ── 9. the compiled sheets' locked content ───────────────────────────────────

printf '\n▸ The seven sheets, compiled (b2/b3 §2 depth · §4 procedure · signals)\n'

T4="$SKILLS/ba-t04/SKILL.md"
has "$T4" "This technique is never suggested." "ba-t04 carries the no-hole trigger semantics (D-B2-1)"
has "$T4" "a suggestion that cannot name its hole must not be emitted" "…with the rule it rests on"
has "$T4" "always skippable" "charter absence is a legal end state"
has "$T4" "A persona is never authorization." "ba-t04 refuses governance ground"
has "$T4" "a routed **governance finding** — proposed to" "…and routes the finding instead"
has "$T4" "TC-3 is not advice." "the namespace clause is checked at write time, not hoped for"

T5="$SKILLS/ba-t05/SKILL.md"
has "$T5" "This sheet describes what exists. What *binds* is the constraints technique's ground." \
    "ba-t05 carries the D-W2 split as its first rule"
has "$T5" "An absence is sourced, never assumed" "the greenfield ruling needs a basis"
has "$T5" "never asks for an integration direction, payload or failure expectation" \
    "ba-t05 refuses integration specifics"
has "$T5" "Arrival is never gated" "a routed arrival already in the file is input, not noise"

T6="$SKILLS/ba-t06/SKILL.md"
has "$T6" "A constraint is imposed, and its imposer is its source." "ba-t06's test for what belongs here"
has "$T6" "Status\` is a two-value vocabulary: \`Confirmed\` or \`Assumed\`" "D-B2-4, compiled"
has "$T6" "This is a disposition, not a limbo" "an Assumed row is durable context, not a marker"
has "$T6" "Silence fails: an empty class with no basis is a hole, not an answer." "the silence-fails discipline"
has "$T6" "A probe an existing row already answers is illegal" "Guard-1 logic at Band 1"
has "$T6" 'never says *"sync completes within N seconds"*' "the NFR-budget edge, testable"

T7="$SKILLS/ba-t07/SKILL.md"
has "$T7" "This run supplies targets and deltas. It never writes the differentiation statement." \
    "ba-t07's boundary against T-09"
has "$T7" "The status quo is always screened as an alternative" "the screen nobody asks for unprompted"
has "$T7" "A delta that names no problem or objective is decoration" "the keying rule"
has "$T7" "the criterion itself is not met until the statement exists" \
    "ba-t07 refuses to claim AT-VI-2 met"
has "$T7" "both entries are legal" "the dual-aspect entry, stated"

T8="$SKILLS/ba-t08/SKILL.md"
has "$T8" "A value claim that cannot be pointed at here cannot anchor a feature later." \
    "ba-t08 carries the chain it anchors"
has "$T8" "A retired line's ID is never reused" "continuation IDs (D-B3-1)"
has "$T8" "An unresolved who-hurts is a **proposed register edit**" "ba-t08 never edits the cast inline"
has "$T8" "really a **capability** is proposed to the canvas Core Functions" "…and routes capabilities to Solution's ground"

T9="$SKILLS/ba-t09/SKILL.md"
has "$T9" "Assumed\` rows are excluded" "the scan reads Confirmed rows only (D-B2-4's mechanical read)"
has "$T9" "[CONFLICT: vision claims <X> · constraints.md §<n> \"<row>\" binds <Y>]" \
    "the D-B3-2 marker form, verbatim"
has "$T9" "Clearing over a named conflict is legal" "the criterion's own text, compiled"
has "$T9" "A scan that reports only its hits is indistinguishable from a scan that did not run" \
    "the scan is reported in full, hits or none"
has "$T9" "A missing target is never authored here." "ba-t09 refuses T-07's ground"
has "$T9" "Vision is the only two-edge aspect" "the DAG's one two-edge gate"

T10="$SKILLS/ba-t10/SKILL.md"
has "$T10" "An explicitly-open direction **satisfies first-pass grade**" "D-B3-4, compiled"
has "$T10" "The framework never solicits its settlement" "the open slot stays open — Tier-1's ground"
has "$T10" "it is the ready-made hole a Tier-1 kit converts into a must-ask" "…and why that matters"
has "$T10" "The completed surface is entity ground." "the EG-1 hand-off toward the domain model"
has "$T10" "function objects as entity candidates, connection systems as boundary references" \
    "…stated in the terms its reader opens on"
has "$T10" "An addition to cleared value ground **routes; it does not reopen**." "the addition/contradiction split"
has "$T10" "every upstream aspect is cleared, so the correction branch has gone quiet" \
    "the asymmetry, at the end of the DAG"

# ── 10. layering ─────────────────────────────────────────────────────────────

printf '\n▸ Layering — no methodology-layer content in the S6 payload (§0, §3.3)\n'

LEAK=0
for f in "$SKILLS"/ba-t0{4,5,6,7,8,9}/SKILL.md "$SKILLS"/ba-t10/SKILL.md \
         "$SKILLS"/ba-t0{4,5,6,7,8,9}/references/example.md "$SKILLS"/ba-t10/references/example.md; do
  [ -f "$f" ] || continue
  if grep -nE 'BABOK|mining note|Reference design|Review record \(|docs/methodology/[a-z]|D-B[0-9]-[0-9]|D-W[0-9]' "$f" \
       > "$TMP/leak.txt" 2>/dev/null; then
    if [ -s "$TMP/leak.txt" ]; then
      bad "methodology-layer content in ${f#$PKG_ROOT/}:"
      sed 's/^/      /' "$TMP/leak.txt"; LEAK=1
    fi
  fi
done
[ "$LEAK" -eq 0 ] && ok "zero BABOK anchors, mining notes, review records or decision IDs in the 14 S6 payload files"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S6 techniques II: T-04…T-10 · 23 seeded defects · Context/Value/Vision/Solution evidenced\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
