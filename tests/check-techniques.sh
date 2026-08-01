#!/usr/bin/env bash
#
# BA-Native Spec — the technique suite, batch I (build plan §4, S5 exit test).
#
# Build plan §4, S5 row: *from the fixture presale brief: Frame runs T-01 →
# `canvas.md` in framework shape; T-02/T-03 land glossary + register;
# Stakeholders reaches `first-pass-cleared` with a §3.4 evidence table.*
#
#   1.  the presale brief is raw material, and the drafted canvas is not
#   2.  T-01's output validates as framework shape, and converges on the
#       substrate the Band-1 ledger's Frame band event records
#   3.  T-02's glossary and T-03's register validate, and both survive
#       unchanged into the mature estate
#   4.  the §12.2 Stakeholders evidence table is EVIDENCED — every row's claim
#       re-derived from the artifacts, not taken on trust
#   5.  16 seeded defects, one per rule — the suite is not vacuous
#   6.  /ba-run dispatch: the interface the three skills implement, both ends
#   7.  the compiled skills' locked content — depth boundaries, contracts,
#       signals, refusals
#   8.  the ba-discovery agent's discipline
#   9.  layering — no methodology-layer content in the S5 payload
#
# What is real here and what is recorded: the **artifact validator runs live**
# (tests/check-band1-artifacts.py). The artifacts themselves are recorded,
# because producing one is an agent act — the same split S3 made for the gate's
# A pass and S4 for the ledgers. See fixtures/…/band1/first-pass/README.md.
#
#   check-techniques.sh        run the suite
#   check-techniques.sh -v     print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
FP="$FX/band1/first-pass"
PROJ="$FX/project"
SKILLS="$PKG_ROOT/payload/claude/skills"
AGENTS="$PKG_ROOT/payload/claude/agents"
TPL="$PKG_ROOT/payload/specify-overlay/ba/templates"
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

# Compiled prompts are wrapped prose: an assertion string routinely spans a line
# break, so both helpers compare on whitespace-flattened text.
flat_has() {
  python3 - "$1" "$2" <<'PY'
import pathlib, re, sys
hay = re.sub(r"\s+", " ", pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
sys.exit(0 if re.sub(r"\s+", " ", sys.argv[2]) in hay else 1)
PY
}
has()   { flat_has "$1" "$2" && ok "$3" || bad "$3 — not found: $2"; }
hasnt() { flat_has "$1" "$2" && bad "$3 — present but must not be: $2" || ok "$3"; }

# mutate <base> <out> <old> <new> [<old> <new> …]
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

# neg <label> <expected rule ids> <validator args…>
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

# ── 0. the Frame input is raw material, and the output is not ────────────────

printf '\n▸ The Frame input (build plan §5 step 3 · T-01 evidence trigger)\n'

BRIEF="$FX/presale-brief.md"
if [ ! -f "$BRIEF" ]; then
  bad "fixtures/appointment-booking/presale-brief.md missing — Frame has no input"
else
  ok "presale-brief.md present — the material T-01 frames from"
  grep -q '^| # | Section |' "$BRIEF" \
    && bad "the presale brief is already in framework shape — then T-01 has nothing to do" \
    || ok "the brief is raw material: no thirteen-section table, no line-IDs, no citations"
  grep -q 'P-1\|O-1' "$BRIEF" \
    && bad "the presale brief carries line-IDs — those are T-01's to assign" \
    || ok "no P-n/O-n in the input — the line-IDs are the framing run's own work"
fi

# ── 1. T-01's output is framework shape ──────────────────────────────────────

printf '\n▸ Frame runs T-01 → canvas.md in framework shape (b1 T-01 §3/§5)\n'

if python3 "$VALIDATE" --canvas "$FP/canvas.md" > "$TMP/canvas.out" 2>&1; then
  ok "$(cat "$TMP/canvas.out")"
else
  bad "the framed canvas does not validate:"; sed 's/^/      /' "$TMP/canvas.out"
fi

STATE="$FX/band1/aspect-state.md"
PLANS="$FX/band1/aspect-plans.md"

# The two doors into the world converge on one substrate, or they are two worlds.
has "$STATE" "substrate: canvas.md — 13 sections, P-1/P-2, O-1/O-2" \
    "the ledger's Frame band event pins the substrate"
for id in P-1 P-2 O-1 O-2; do
  grep -q -- "$id" "$FP/canvas.md" \
    && ok "the framed canvas carries $id — it converges on the ledger's substrate" \
    || bad "the framed canvas has no $id, so it is not the ledger's substrate"
done
has "$PLANS" "{presale canvas incl. the Context/Constraints element · Context · \`canvas.md\`}" \
    "the ## Frame plan row carries T-01's pinned contract"

# framing grade is visible, not asserted: holes stay open, and none is a fake N/A
has "$FP/canvas.md" "| 11 | Competition.Our Solution | open — no source material |" \
    "§11 stays an open hole at framing grade — AT-VI-2's trigger, ready-made"
has "$FP/canvas.md" "Business — open — no source material · Regulatory — open — no source material" \
    "two §13 constraint classes stay open — AT-CX-2's triggers"
grep '^| ' "$FP/canvas.md" | grep -q 'N/A' \
  && bad "the framed canvas carries an N/A; N/A is a BA ruling and nothing here has been ruled" \
  || ok "no fake N/A in any canvas cell — the holes stay open, visibly"

# and the aspects filled every one of those holes, rather than the framing run
has "$PROJ/canvas.md" "Booking completes without a phone call" \
    "the mature canvas has §11 filled — by the Vision aspect, not by framing"
has "$PROJ/canvas.md" "[constraints.md §2]" "…and §13 Business, by the Context aspect"

# ── 2. T-02 and T-03 land glossary and register ──────────────────────────────

printf '\n▸ T-02 and T-03 land glossary + register (b1 T-02 §5 · T-03 §5)\n'

if python3 "$VALIDATE" --glossary "$FP/glossary.md" --register "$FP/stakeholders.md" \
     > "$TMP/gr.out" 2>&1; then
  ok "$(cat "$TMP/gr.out")"
else
  bad "glossary/register do not validate:"; sed 's/^/      /' "$TMP/gr.out"
fi

has "$FP/glossary.md" "booking (noun) — merged 2026-07-10, canvas usage" \
    "the merge is on record with its date — what makes later drift detectable"
has "$FP/glossary.md" "Authorization detail lives in roles-permissions.md" \
    "the glossary references the roles file rather than restating a role"

has "$PLANS" "t02 · contract: fulfilled — glossary.md, 6 terms" \
    "the run log books T-02's contract as fulfilled, with its count"
n_terms=$(( $(grep -c '^| [A-Z]' "$FP/glossary.md") - 1 ))   # less the header row
[ "$n_terms" -eq 6 ] && ok "the glossary has the 6 terms the run log and AT-RQ-3 name" \
                     || bad "the glossary has $n_terms terms; the run log says 6"

# both artifacts survive into the mature estate, unchanged
for kind in glossary register; do
  case "$kind" in
    glossary) e="$FP/glossary.md";      l="$PROJ/.specify/memory/glossary.md" ;;
    register) e="$FP/stakeholders.md";  l="$PROJ/.specify/memory/stakeholders.md" ;;
  esac
  if python3 "$VALIDATE" --early "$e" --later "$l" --kind "$kind" > "$TMP/cont.out" 2>&1; then
    ok "$kind continuity — every first-pass row survives into the mature estate"
  else
    bad "$kind continuity broken:"; sed 's/^/      /' "$TMP/cont.out"
  fi
done

# the register is pre-RO-1 by construction — that absence is the point
grep '^| ' "$FP/stakeholders.md" | grep -q 'Clinic administrators' \
  && bad "the first-pass register already has the Clinic Admin population — then RO-1 contradicts nothing" \
  || ok "the first-pass register has no Clinic Admin row — RO-1 contradicts this picture, it does not fill a gap in it"
has "$PROJ/.specify/memory/stakeholders.md" "Clinic administrators" \
    "…and the mature register has it, added by RO-1's resolution"

# ── 3. the §12.2 evidence table, EVIDENCED ───────────────────────────────────

printf '\n▸ Stakeholders reaches first-pass-cleared with a §3.4 evidence table\n'

has "$STATE" "Aspect gate review — Stakeholders — 2026-07-08" \
    "the evidence table is appended as the transition's basis"
has "$STATE" "2026-07-08 · T2 · Stakeholders · open → first-pass-cleared" \
    "T2 executes on the BA's CLEARED ruling"

# every row's claim is re-derived from the artifacts, not taken on trust
grep -q 'Sponsor: Olena — clinic network COO' "$FP/canvas.md" \
  && ok "AT-ST-1 evidenced — canvas Customers names Olena, clinic network COO, as sponsor" \
  || bad "AT-ST-1's row claims a sponsor the canvas does not name"
for pop in Clients Specialists; do
  grep -q "$pop —" "$FP/canvas.md" \
    && ok "AT-ST-1 evidenced — canvas Customers names the $pop population" \
    || bad "AT-ST-1's row claims the $pop population; the canvas does not name it"
done

n_entries=$(( $(grep -c '^| [A-Z]' "$FP/stakeholders.md") - 1 ))   # less the header row
[ "$n_entries" -eq 4 ] \
  && ok "AT-ST-2 evidenced — the register has the 4 entries the table claims" \
  || bad "AT-ST-2's row claims 4 entries; the register has $n_entries"
grep -q 'Final call on scope, phases and budget' "$FP/stakeholders.md" \
  && ok "AT-ST-2 evidenced — the sponsor's authority is explicit, not implied by the title" \
  || bad "AT-ST-2's row claims explicit sponsor authority; the register does not state it"

if python3 "$VALIDATE" --canvas "$FP/canvas.md" --register "$FP/stakeholders.md" \
     > "$TMP/coh.out" 2>&1; then
  ok "AT-ST-3 evidenced — canvas ⇄ register coherence recomputed live, no contradiction"
else
  bad "AT-ST-3's row claims coherence; the diff says otherwise:"
  sed 's/^/      /' "$TMP/coh.out"
fi

has "$STATE" "→ CLEARED · Y.K. · 2026-07-08" \
    "the BA's ruling closes the table — an aspect gate never self-clears"

# ── 4. seeded defects — one per rule ─────────────────────────────────────────

printf '\n▸ Seeded defects — 16 rules, 16 mutations (the suite is not vacuous)\n'

C="$FP/canvas.md"; G="$FP/glossary.md"; R="$FP/stakeholders.md"

mutate "$C" "$M/b1.md" \
  "| 9 | Localization | Single locale at launch \`[presale brief]\` |
" ""
neg "B1  thirteen sections — one section deleted" B1 --canvas "$M/b1.md"

mutate "$C" "$M/b2.md" "Responsive web \`[presale brief]\`" "Responsive web"
neg "B2  cite-or-mark — an unmarked assertion" B2 --canvas "$M/b2.md"

mutate "$C" "$M/b3.md" \
  "| 11 | Competition.Our Solution | open — no source material |" \
  "| 11 | Competition.Our Solution | N/A |"
neg "B3  a bare N/A with no reason (and so uncited too)" B2,B3 --canvas "$M/b3.md"

mutate "$C" "$M/b4.md" "P-2 — Specialists" "P-3 — Specialists"
neg "B4  line-IDs — P-1, P-3: not contiguous" B4 --canvas "$M/b4.md"

mutate "$C" "$M/b5.md" \
  "Browse a Specialist's published availability \`→ O-2\`" \
  "Browse a Specialist's published availability \`→ O-9\`"
neg "B5  a link resolving to no defined line-ID" B5 --canvas "$M/b5.md"

mutate "$C" "$M/b6.md" \
  "Notify the Specialist of bookings and cancellations \`[kickoff notes]\`" \
  "Notify the Specialist of bookings and cancellations · Reschedule an appointment · Rate a Specialist · Export a calendar file · Search by specialism · Waitlist a full Slot · Message a Specialist \`[kickoff notes]\`"
neg "B6  Core Functions — 11 capability lines, cap is 10" B6 --canvas "$M/b6.md"

mutate "$C" "$M/b7.md" "Sponsor: Olena — clinic network COO" "Sponsor: TBD"
neg "B7  Customers — a placeholder where a real name is the requirement" B7 --canvas "$M/b7.md"

mutate "$C" "$M/b15.md" \
  "Populations: Clients — book and cancel appointments" \
  "Populations: Front-desk staff — take calls today \`[kickoff notes]\` · Clients — book and cancel appointments"
neg "B15 coherence — a canvas population resolving to no register entry" B15 \
    --canvas "$M/b15.md" --register "$R"

mutate "$G" "$M/b8.md" \
  "| Term | Definition | Merged synonyms | Source |" "| Term | Definition | Source |"
neg "B8  glossary header — the Merged-synonyms column dropped" B8 --glossary "$M/b8.md"

mutate "$G" "$M/b9.md" \
  "| Availability | The set of Slots a Specialist has published as open for booking. |" \
  "| Availability |  |"
neg "B9  a stub entry — a term with no definition" B9 --glossary "$M/b9.md"

mutate "$G" "$M/b10.md" \
  "booking (noun) — merged 2026-07-10, canvas usage" "booking (noun) — merged, canvas usage"
neg "B10 an undated merge — drift becomes re-litigable" B10 --glossary "$M/b10.md"

mutate "$R" "$M/b11.md" \
  "| Stakeholder | Kind | Role in project | Decision rights | Comms line | Source |" \
  "| Stakeholder | Kind | Role in project | Decision rights | Comms | Source |"
neg "B11 register header — a renamed column" B11 --register "$M/b11.md"

mutate "$R" "$M/b12.md" "| Clients | population |" "| Clients | group |"
neg "B12 Kind outside the two-value vocabulary" B12 --register "$M/b12.md"

mutate "$R" "$M/b13.md" \
  "| — | no direct access at discovery — via Olena |" "| — | — |"
neg "B13 an entry with neither decision rights nor a comms line" B13 --register "$M/b13.md"

mutate "$R" "$M/b14.md" \
  "Final call on scope, phases and budget; nothing escalates past her" "—"
neg "B14 the sponsor decides nothing on the record" B14 --register "$M/b14.md"

mutate "$PROJ/.specify/memory/glossary.md" "$M/b16.md" \
  "| Hold | A short exclusive reservation of a Slot for one Client while they confirm. | — | processes.md: booking journey |
" ""
neg "B16 continuity — a first-pass term gone from the mature estate" B16 \
    --early "$G" --later "$M/b16.md" --kind glossary

# ── 5. /ba-run dispatch, both ends of the interface ──────────────────────────

printf '\n▸ /ba-run dispatch proven (orchestrator §6.3/§7.1, build plan §4 S5)\n'

RUN="$SKILLS/ba-run/SKILL.md"
has "$RUN" "the technique is **on the composed plan** with a **pinned output contract**" \
    "/ba-run checks exactly one thing at invocation"
has "$RUN" "dispatch the technique's skill (\`/ba-t03\`, \`/ba-tier1\`, …)" \
    "/ba-run dispatches by skill name — the technique skills are its callees"
has "$RUN" "**T-01** against \`## Frame\`" \
    "/ba-run knows T-01 checks against the plans file's ## Frame section"
has "$SKILLS/ba-frame/SKILL.md" "Dispatch **T-01** (\`/ba-run t01\`)" \
    "/ba-frame dispatches T-01 through /ba-run, never directly"

for t in t01 t02 t03; do
  f="$SKILLS/ba-$t/SKILL.md"
  if [ ! -f "$f" ]; then bad "ba-$t/SKILL.md missing"; continue; fi
  head -8 "$f" | grep -qx -- "name: ba-$t" || bad "ba-$t — frontmatter name does not match its directory"
  head -8 "$f" | grep -qx 'disable-model-invocation: true' \
    || bad "ba-$t — missing disable-model-invocation: true (D-P2-2)"
  head -8 "$f" | grep -q '^description: .' || bad "ba-$t — no description"
  [ -f "$SKILLS/ba-$t/references/example.md" ] \
    || bad "ba-$t — no references/example.md (D-P2-10: the micro-example ships as a few-shot)"
  flat_has "$f" "BA-invoked, never auto-fired" \
    || bad "ba-$t — does not inherit the invocation discipline"
  flat_has "$f" "This skill starts only from \`/ba-run $t\`" \
    || bad "ba-$t — does not name /ba-run as its only entry"
  flat_has "$f" "Self-check, and stop if either half fails" \
    || bad "ba-$t — no P-O3 self-check at the top"
  flat_has "$f" "Skip-if" || bad "ba-$t — no skip-if condition"
  flat_has "$f" "Depth boundary" || bad "ba-$t — no depth boundary"
  flat_has "$f" "What this skill never does" || bad "ba-$t — no refusal discipline stated"
done
ok "three technique skills: frontmatter · references/example.md · self-check · skip-if · depth · refusals"

# the pinned contract triple, per sheet §3 — expected · class · destination
CONTRACT_T01='{presale canvas incl. the Context/Constraints element · Context · `canvas.md`}'
has "$SKILLS/ba-t01/SKILL.md" "{presale canvas incl. the Context/Constraints element · Context · canvas.md}" \
    "ba-t01 carries its pinned contract triple"
has "$SKILLS/ba-frame/SKILL.md" "{presale canvas incl. the Context/Constraints element · Context · canvas.md}" \
    "…the same triple /ba-frame pins, character for character"
has "$PLANS" "$CONTRACT_T01" "…and the same triple the fixture's ## Frame plan row records"
has "$SKILLS/ba-t01/SKILL.md" "**Destination:** \`canvas.md\`, repo root" \
    "…destination canvas.md at the repo root, outside .specify/memory/"
has "$SKILLS/ba-t02/SKILL.md" ".specify/memory/glossary.md}" "ba-t02 carries its pinned contract triple"
has "$SKILLS/ba-t03/SKILL.md" ".specify/memory/stakeholders.md}" "ba-t03 carries its pinned contract triple"

# each skill reports; none of them confirms
for t in t02 t03; do
  has "$SKILLS/ba-$t/SKILL.md" "belong to \`/ba-run\`'s post-run touchpoint" \
      "ba-$t reports its criteria and leaves the refresh to /ba-run (§7.4)"
done

# ── 6. the compiled skills' locked content ───────────────────────────────────

printf '\n▸ The three sheets, compiled (b1 §2 depth · §4 procedure · signals)\n'

T1="$SKILLS/ba-t01/SKILL.md"
has "$T1" "A framed canvas is never re-framed." "ba-t01 refuses a re-frame — the trigger cannot recur"
has "$T1" "T-01 runs no question loop at all." "ba-t01 asks nothing — the holes are the suggestion engine's input"
has "$T1" "open — no source material" "ba-t01 carries the open-hole marker"
has "$T1" "\`N/A — <reason>\` is a BA ruling" "…and keeps it distinct from the BA's ruling"
has "$T1" "[CONFLICT: <A> says … · <B> says …]" "ba-t01 carries both readings under the conflict marker"
has "$T1" "never inferred silently" "linkage is written only where the material states it"
has "$T1" "Real names are the requirement, never masked." "the presale-chat masking is inverted for a repo artifact"
has "$T1" "No next-act postamble" "the technique stops at its output; next acts are the orchestrator's"
has "$T1" "Never re-frames a canvas already in framework shape" "ba-t01's refusal list leads with its skip-if"

T2="$SKILLS/ba-t02/SKILL.md"
has "$T2" "is **not a technique run**" "ba-t02 separates the standing discipline from the consolidation run (D-B1-3)"
has "$T2" "What is **not** legal is the framework proposing this technique outside Requirements" \
    "…and keeps BA election legal while framework initiative stays evidence-grounded"
has "$T2" "role definitions — T-12's ground" "ba-t02 refuses to define a role (standard rule 5)"
has "$T2" "a definition that enumerates fields or transitions has crossed the line" \
    "ba-t02 carries the testable depth edge"
has "$T2" "never silently averaged" "a meaning conflict is ruled, never averaged"
has "$T2" "proposed-edit batch" "drift repair rides a BA-approved batch"

T3="$SKILLS/ba-t03/SKILL.md"
has "$T3" "A question that serves neither is illegal and must not be emitted." \
    "ba-t03 carries the destination rule (principle 2)"
has "$T3" "no numeric cap here and none is needed" \
    "threshold grade bounds the question set structurally"
has "$T3" "A register population is never a role." "ba-t03 refuses governance ground (T-12)"
has "$T3" "sponsor's decision authority is stated explicitly" "AT-ST-2's named condition"
has "$T3" "no reopen exists to signal" "first pass: a conflict is ordinary correction"
has "$T3" "reopen signal**, not a correction" "post-clearing: the same contradiction is a signal"

# ── 7. the discovery agent ───────────────────────────────────────────────────

printf '\n▸ The ba-discovery agent (build plan §2.3 · doc-3 principles · standard §1)\n'

AG="$AGENTS/ba-discovery.md"
if [ ! -f "$AG" ]; then
  bad "agents/ba-discovery.md missing"
else
  head -8 "$AG" | grep -qx 'name: ba-discovery' \
    && ok "frontmatter name matches the file" || bad "frontmatter name does not match the file"
  if head -8 "$AG" | grep -qE '^tools: *Read, *Write, *Edit, *Grep, *Glob *$'; then
    ok "tools: Read, Write, Edit, Grep, Glob — authors artifacts, runs no checker"
  else
    bad "ba-discovery must declare exactly 'tools: Read, Write, Edit, Grep, Glob'"
  fi
  head -8 "$AG" | grep -q 'Bash' \
    && bad "ba-discovery declares Bash — the technique layer runs no check" \
    || ok "no Bash in the tool policy — checks are the gate's, and only the gate's"
  has "$AG" "Draft first, ask second." "operating principle 1"
  has "$AG" "No question without a destination." "operating principle 2"
  has "$AG" "Cited, marked, or asked — never guessed." "operating principle 3"
  has "$AG" "The holes in the draft *are* the questions." "principle 1's mechanism, not just its name"
  has "$AG" "You never author a \`spec.md\`" "the boundary against the analyst persona"
  has "$AG" "never write to \`.specify/aspect-state.md\`" "the boundary against the orchestrator's ledgers"
  has "$AG" "Arrival is never gated" "a finding lands in its home whatever that aspect's state"
  has "$AG" "before an aspect is cleared there is no reopen to signal" \
      "the first-pass/post-clearing distinction ships with the persona"
  has "$AG" "Zero banned words" "the writing-standard discipline travels with the executor"
  has "$AG" "Reference, never restate." "…including the double-definition ban"
  has "$AG" "A hole reported is a hole the next threshold review names." \
      "partial and failed are recorded, never papered over"
  has "$AG" "never read a methodology document" "the runtime never loads the corpus"
fi

# ── 8. template ⇄ example, and layering ──────────────────────────────────────

printf '\n▸ Compiled-artifact consistency and layering (build plan §0, §3.3)\n'

python3 - "$TPL/canvas-template.md" "$SKILLS/ba-t01/references/example.md" <<'PY' \
  && ok "ba-t01's example repeats the installed canvas template's thirteen sections, in order" \
  || bad "ba-t01/references/example.md has drifted from ba/templates/canvas-template.md"
import pathlib, re, sys
def sections(p):
    out = []
    for ln in pathlib.Path(p).read_text(encoding="utf-8").splitlines():
        m = re.match(r"^\|\s*(\d{1,2})\s*\|\s*([^|]+?)\s*\|", ln)
        if m:
            out.append((int(m.group(1)), m.group(2)))
    seen, uniq = set(), []
    for n, name in out:
        if n not in seen:
            seen.add(n); uniq.append((n, name))
    return uniq
a, b = sections(sys.argv[1]), sections(sys.argv[2])
sys.exit(0 if a and a == b[:len(a)] else 1)
PY

LEAK=0
for f in "$AG" "$SKILLS"/ba-t0{1,2,3}/SKILL.md "$SKILLS"/ba-t0{1,2,3}/references/example.md; do
  [ -f "$f" ] || continue
  if grep -nE 'BABOK|mining note|Reference design|Review record \(|docs/methodology/[a-z]' "$f" \
       | grep -v 'never read a methodology document' > "$TMP/leak.txt" 2>/dev/null; then
    if [ -s "$TMP/leak.txt" ]; then
      bad "methodology-layer content in ${f#$PKG_ROOT/}:"
      sed 's/^/      /' "$TMP/leak.txt"; LEAK=1
    fi
  fi
done
[ "$LEAK" -eq 0 ] && ok "zero BABOK anchors, mining notes or review records in the 7 S5 payload files"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S5 techniques I: T-01/T-02/T-03 · 16 seeded defects · /ba-run dispatch · ba-discovery\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
