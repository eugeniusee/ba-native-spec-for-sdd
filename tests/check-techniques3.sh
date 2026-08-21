#!/usr/bin/env bash
#
# BA-Native Spec — the technique suite, batch III + closure (build plan §4, S7).
#
# Build plan §4, S7 row: *Requirements clears; `/ba-close-band1` succeeds; the
# arming Scope-H run lands in `gate-health.md` — HEALTHY, or its named gaps
# fixed via routing in-session.*
#
#   1.  the Requirements plan carries the six techniques with pinned contracts
#   2.  T-11…T-16 land the six spec-anchored homes in the shapes their sheets pin
#   3.  the two late-entry mechanisms: a gate-added tuple · a graduated exclusion
#   4.  the AT-RQ-1…4 evidence table, EVIDENCED — every row re-derived live
#   5.  31 seeded defects, one per rule — the suite is not vacuous
#   6.  /ba-run dispatch: the interface the six skills implement, both ends
#   7.  the compiled sheets' locked content — depth boundaries, refusals, order
#   8.  closure: /ba-close-band1's preconditions, the act, and the arming run
#   9.  layering — no methodology-layer content in the S7 payload
#
# Same split as S5/S6: the **validator runs live** (tests/check-band1-artifacts.py);
# the artifacts are recorded, because producing one is an agent act.
#
#   check-techniques3.sh        run the suite
#   check-techniques3.sh -v     print every check, not just the failures

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$(cd "$HERE/.." && pwd)"
FX="$HERE/fixtures/appointment-booking"
FP="$FX/band1/first-pass"
EL="$FX/band1/elected"
PROJ="$FX/project"
MEM="$PROJ/.specify/memory"
SKILLS="$PKG_ROOT/payload/claude/skills"
VALIDATE="$HERE/check-band1-artifacts.py"

VERBOSE=0
for a in "$@"; do
  case "$a" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
HEALTH="$FX/band1/gate-health.md"

DM="$MEM/domain-model.md";  RP="$MEM/roles-permissions.md"
PR="$MEM/processes.md";     DS="$MEM/design-standards.md"
CO="$MEM/constitution.md";  OS="$MEM/out-of-scope.md"
CV="$PROJ/canvas.md";       REG="$MEM/stakeholders.md"

# ── 1. the plan that holds the six techniques ────────────────────────────────

printf '\n▸ The Requirements aspect plans the six techniques (orchestrator §6.2/§6.3)\n'

for row in \
  "t11 domain (conceptual) modeling|{domain model at seed grade — entities the core functions imply, relations at business level, boundary references disposed external · Context · \`.specify/memory/domain-model.md\`}" \
  "t12 roles & permissions|{roles + one explicit policy row per role × entity × action tuple, entities verbatim from the domain model, zero persona names · Governance · \`.specify/memory/roles-permissions.md\`}" \
  "t13 core process mapping|{the major journeys of each significant role — role verbatim, trigger → outcome, numbered helicopter steps · Context · \`.specify/memory/processes.md\`}" \
  "t14 design & UX standards|{design & UX standards at global grade — named budgets, product-wide conventions, each section real or ruled · Governance · \`.specify/memory/design-standards.md\`}" \
  "t15 constitution|{constitution at principle grade — named MUST-form principles incl. the two framework seeds, plus the Governance-class reference spine · Governance · \`.specify/memory/constitution.md\`}" \
  "t16 global out-of-scope|{the product-level fence — at least one exclusion, each naming where it lives instead and the expectation it fences · Context · \`.specify/memory/out-of-scope.md\`}"
do
  name="${row%%|*}"; triple="${row#*|}"
  short="${name%% *}"
  has "$PLANS" "$triple" "the composed plan pins $short's output contract"
  plain="$(printf '%s' "$triple" | tr -d '`')"
  has "$SKILLS/ba-$short/SKILL.md" "$plain" "…and ba-$short carries it, character for character"
done

# the chain's order is the plan's order, and the plan says why
has "$PLANS" "vocabulary before model before roles; the constitution last, so" \
    "the plan states the chain's ordering rationale"
python3 - "$PLANS" <<'PY' \
  && ok "…and the composed rows run in that order: t02 → t11 → t12 → t13 → t14 → t15 → t16" \
  || bad "the Requirements composed plan does not run the chain in dependency order"
import pathlib, re, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
block = txt.split("## Requirements", 1)[1].split("Composed plan", 1)[1].split("Run log:", 1)[0]
got = re.findall(r"^\|\s*\d+\s*\|\s*(t\d\d)", block, flags=re.M)
sys.exit(0 if got == ["t02", "t11", "t12", "t13", "t14", "t15", "t16"] else 1)
PY

# ── 2. the six homes land, in the shapes the sheets pin ──────────────────────

printf '\n▸ T-11…T-16 land the Requirements estate (b4/b5 §3/§5)\n'

if python3 "$VALIDATE" --canvas "$CV" --domain "$DM" --roles "$RP" --processes "$PR" \
     --design "$DS" --constitution "$CO" --oos "$OS" --root "$PROJ" \
     > "$TMP/est.out" 2>&1; then
  ok "$(cat "$TMP/est.out")"
else
  bad "the Requirements estate does not validate:"; sed 's/^/      /' "$TMP/est.out"
fi

if python3 "$VALIDATE" --canvas "$CV" --roles "$FP/roles-permissions.md" \
     --oos "$FP/out-of-scope.md" > "$TMP/seed.out" 2>&1; then
  ok "the two seed snapshots validate at the same grade"
else
  bad "a seed snapshot does not validate:"; sed 's/^/      /' "$TMP/seed.out"
fi

# T-11's boundary: the calendar system is disposed external, never modelled
has "$DM" "Specialists' external calendars — external system" \
    "the connection system is a boundary reference, pointing at the files that own it"
hasnt "$DM" "| Specialists' external calendars |" \
    "…and it stands as no entity row"

# T-12 states no principle; T-15 states it and nothing else does
has "$RP" "Authorization principle: stated in constitution.md" \
    "the role model points at the constitution for the principle"
hasnt "$RP" "MUST derive from" "…and does not state it — this file is the enforcement surface"
has "$CO" "Permissions MUST derive from \`roles-permissions.md\` policy rows only" \
    "the constitution states the authorization principle, in MUST form"

# T-13's depth line, held inside one journey
has "$PR" "a Hold is placed on the Slot for that Client" \
    "the booking journey carries the hold step"
hasnt "$PR" "five minutes" "…and not the cutoff — that is spec ground"
has "$PR" "the Slot's rebooking disposition is deliberately unstated" \
    "the cancellation journey records the rule it declines to state"

# T-14's conditionality resolved the other way, and the reference proves it
has "$CO" "\`.specify/memory/design-standards.md\` | global budgets + UX conventions" \
    "the constitution references the design file — the clause that lifts it into the demand"
has "$DS" "Accessibility — Client-facing surfaces" \
    "…and the budget name a feature spec cites resolves to a named row"
has "$PROJ/specs/004-appointment-booking/spec.md" \
    "covered by the global Design & UX accessibility budget" \
    "the spec's category line points at that budget rather than restating it"

# T-15's spine is Governance-only
hasnt "$CO" "out-of-scope.md\` |" "the reference spine carries no Context-class file"

# T-16's grain, both sides in one world
has "$OS" "Payments taken inside the product" "the product fence excludes payments"
has "$PROJ/specs/004-appointment-booking/spec.md" "Notification preferences" \
    "…while the feature-grain fence lives in the spec"
hasnt "$OS" "Notification preferences" "…and never enters the global file"

# ── 3. the two late-entry mechanisms ─────────────────────────────────────────

printf '\n▸ Seed → mature: a gate-added tuple · a graduated exclusion\n'

if python3 "$VALIDATE" --seed-early "$FP/roles-permissions.md" --seed-later "$RP" \
     --seed-kind roles > "$TMP/le1.out" 2>&1; then
  ok "every seed policy row survives into the mature file, in place"
else
  bad "the seed policy rows did not survive:"; sed 's/^/      /' "$TMP/le1.out"
fi

python3 - "$FP/roles-permissions.md" "$RP" <<'PY' \
  && ok "…and the mature file grew by exactly one tuple: Specialist × Appointment × cancel" \
  || bad "the tuple the gate added is not the one difference between seed and mature"
import pathlib, re, sys
def rows(p):
    txt = pathlib.Path(p).read_text(encoding="utf-8")
    body = txt.split("## Policy", 1)[1]
    out = []
    for ln in body.splitlines():
        if ln.startswith("|") and "---" not in ln:
            c = [x.strip() for x in ln.strip("|").split("|")]
            if c[0] != "Role":
                out.append(tuple(c[:3]))
    return out
a, b = rows(sys.argv[1]), rows(sys.argv[2])
added = [r for r in b if r not in a]
sys.exit(0 if added == [("Specialist", "Appointment", "cancel")] else 1)
PY

has "$RP" "gate run 2 CC-XA-01 → governance change approved 2026-07-17" \
    "the added row carries the gate run that named it as its source"
has "$PR" "governance change approved 2026-07-17" \
    "…and the journey that followed it carries the same provenance"

if python3 "$VALIDATE" --seed-early "$FP/out-of-scope.md" --seed-later "$OS" \
     --seed-kind out-of-scope > "$TMP/le2.out" 2>&1; then
  ok "the graduated exclusion resolved in place — basis unmoved, disposition resolved"
else
  bad "the graduation broke a row:"; sed 's/^/      /' "$TMP/le2.out"
fi

grep -q 'Payments taken inside the product | deferred — roadmap candidate, beyond MVP' \
     "$FP/out-of-scope.md" \
  && ok "at seed the payments row carries a phase hint — there was no epic to name" \
  || bad "the seed payments row is not a phase-hinted deferral"
grep -q 'Payments taken inside the product | deferred → E-07 Online Payment' "$OS" \
  && ok "…and after decomposition it resolves to the named epic" \
  || bad "the mature payments row did not graduate to an epic"
grep -q 'out-of-scope.md: payments deferred row — graduated this run' \
     "$MEM/roadmap.md" \
  && ok "…and the epic's own Source cites the row it graduated from — the loop closes" \
  || bad "the roadmap epic does not cite the exclusion it graduated from"

# ── 4. the AT-RQ evidence table, re-derived ──────────────────────────────────

printf '\n▸ AT-RQ-1…4, evidenced — every row re-derived from the files\n'

has "$STATE" "Aspect gate review — Requirements — 2026-07-10" \
    "Requirements clearing carries an evidence table"

# AT-RQ-1 — every home the criterion enumerates exists, seeded and stub-free
for f in glossary.md roles-permissions.md domain-model.md processes.md \
         out-of-scope.md constitution.md design-standards.md; do
  if [ -s "$MEM/$f" ] && [ "$(grep -cv '^\s*$' "$MEM/$f")" -ge 8 ]; then
    ok "AT-RQ-1 evidenced — $f exists with real content"
  else
    bad "AT-RQ-1's row claims $f is seeded; it is absent or a stub"
  fi
done
python3 - "$CO" "$PROJ" <<'PY' \
  && ok "AT-RQ-1 evidenced — every governance file the constitution references resolves, stub-free" \
  || bad "AT-RQ-1's row claims the reference spine resolves; at least one entry does not"
import pathlib, sys
root = pathlib.Path(sys.argv[2])
body = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").split("## Governance references", 1)[1]
refs = []
for ln in body.splitlines():
    if ln.startswith("|") and "---" not in ln:
        c = [x.strip() for x in ln.strip("|").split("|")]
        if c[0] and c[0] != "File":
            refs.append(c[0].strip("`"))
sys.exit(0 if refs and all((root / r).is_file()
                           and len((root / r).read_text(encoding="utf-8").split()) > 20
                           for r in refs) else 1)
PY
has "$STATE" "the D-B5-3 conditionality lifts design-standards.md into the demand" \
    "…and the row records why the conditional file is inside the demand here"

# AT-RQ-2 — every role a Band-1 artifact references is defined; persona clause dormant
python3 - "$RP" "$CV" <<'PY' \
  && ok "AT-RQ-2 evidenced — Client and Specialist are defined, and they are the roles the canvas names" \
  || bad "AT-RQ-2's row claims the referenced roles are defined; the files disagree"
import pathlib, re, sys
roles = []
body = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").split("## Roles", 1)[1].split("## Policy", 1)[0]
for ln in body.splitlines():
    if ln.startswith("|") and "---" not in ln:
        c = [x.strip() for x in ln.strip("|").split("|")]
        if c[0] and c[0] != "Role":
            roles.append(c[0])
canvas = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
sys.exit(0 if sorted(roles) == ["Client", "Specialist"]
         and all(re.search(rf"\b{r}s?\b", canvas) for r in roles) else 1)
PY
[ -f "$MEM/personas.md" ] \
  && bad "personas.md is in the estate; the AT-RQ-2 row says the persona clause is dormant" \
  || ok "AT-RQ-2 evidenced — no personas.md, so the persona clause reads dormant"
has "$CO" "never inferred from personas or narrative material" \
    "…and the principle stands anyway, seeded unconditionally"

# AT-RQ-3 — the glossary defines every entity the model leans on
python3 - "$DM" "$MEM/glossary.md" <<'PY' \
  && ok "AT-RQ-3 evidenced — every domain entity has a glossary entry" \
  || bad "AT-RQ-3's row claims the terms are defined; an entity resolves to no glossary term"
import pathlib, sys
def col0(p, section):
    txt = pathlib.Path(p).read_text(encoding="utf-8")
    if section:
        txt = txt.split(section, 1)[1]
    out = []
    for ln in txt.splitlines():
        if ln.startswith("|") and "---" not in ln:
            c = [x.strip() for x in ln.strip("|").split("|")]
            if c[0] and c[0] not in ("Entity", "Term", "From"):
                out.append(c[0])
        elif out and not ln.startswith("|"):
            break
    return out
entities = col0(sys.argv[1], "## Entities")
terms = col0(sys.argv[2], None)
sys.exit(0 if entities and all(e in terms for e in entities) else 1)
PY

# AT-RQ-4 — the entity clause and the journeys clause, both re-derived
python3 - "$DM" <<'PY' \
  && ok "AT-RQ-4 evidenced — 6 entities, 6 relations; no entity stands relation-less" \
  || bad "AT-RQ-4's entity row claims relations on every entity; one stands alone"
import pathlib, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
def rows(section, stop):
    body = txt.split(section, 1)[1].split(stop, 1)[0]
    return [[x.strip() for x in ln.strip("|").split("|")]
            for ln in body.splitlines() if ln.startswith("|") and "---" not in ln][1:]
ents = [r[0] for r in rows("## Entities", "## Relations")]
rels = rows("## Relations", "## Boundary references")
touched = {r[0] for r in rels} | {r[2] for r in rels}
sys.exit(0 if len(ents) == 6 and len(rels) == 6 and set(ents) == touched else 1)
PY
has "$STATE" "the two actors of ≥ 1 canvas Core Function line" \
    "AT-RQ-4's journeys row states the significance criterion it applied"

has "$STATE" "→ CLEARED · Y.K. · 2026-07-10" "the BA's ruling closes the table — the aspect never self-clears"

# ── 5. seeded defects — one per new rule ─────────────────────────────────────

printf '\n▸ Seeded defects — 31 rules, 31 mutations (the suite is not vacuous)\n'

mutate "$DM" "$M/b40.md" "## Relations" "## Relationships"
neg "B40 domain — a section renamed" B40,B42 --domain "$M/b40.md"

mutate "$DM" "$M/b41.md" \
  "| Entity | What it is (one business line) | Source |" "| Entity | Meaning | Source |"
neg "B41 domain — the business-line column renamed" B41 --domain "$M/b41.md"

mutate "$DM" "$M/b42.md" "| Availability | consists of | Slot |" \
  "| Availability | consists of | TimeBlock |"
neg "B42 domain — a relation end resolving to no entity" B42 --domain "$M/b42.md"

mutate "$DM" "$M/b43.md" "One bookable unit of Availability" \
  "One bookable unit of Availability; start_at datetime, required"
neg "B43 domain — field-grade detail in a business line" B43 --domain "$M/b43.md"

mutate "$DM" "$M/b44.md" \
  "- Specialists' external calendars — external system" \
  "- The clinic phone lines — external channel"
neg "B44 domain — a connection system disposed by nothing" B44 --domain "$M/b44.md" --canvas "$CV"

mutate "$RP" "$M/b45.md" "stated in constitution.md (plan §4.14)" "stated in this file"
neg "B45 roles — the header stops pointing at the constitution" B45 --roles "$M/b45.md"

mutate "$RP" "$M/b46.md" "| Client | Books and cancels own Appointments |" "| Client |  |"
neg "B46 roles — a role with no mandate" B46 --roles "$M/b46.md"

mutate "$RP" "$M/b47.md" "| Specialist | Availability | publish |" \
  "| Receptionist | Availability | publish |"
neg "B47 roles — a policy row for an undefined role" B47 --roles "$M/b47.md"

mutate "$RP" "$M/b48.md" "| Client | Appointment | cancel | own only |" \
  "| Client | Appointment | * | own only |"
neg "B48 roles — a wildcard action cell" B48 --roles "$M/b48.md"

mutate "$RP" "$M/b49.md" "| Client | Slot | book |" "| Client | TimeSlot | book |"
neg "B49 roles — an entity cell the domain model does not define" B49 \
    --roles "$M/b49.md" --domain "$DM"

mutate "$RP" "$M/b50.md" "| Client | Books and cancels own Appointments |" \
  "| Client | Books and cancels own Appointments, like Marta |"
neg "B50 roles — a persona name in the role model" B50 \
    --roles "$M/b50.md" --personas "$EL/personas.md" --register "$REG"

mutate "$PR" "$M/b51.md" "## Cancel own appointment — role: Client" "## Cancel own appointment"
neg "B51 processes — a journey with no role clause" B51 --processes "$M/b51.md" --roles "$RP"

mutate "$PR" "$M/b52.md" \
  "Trigger: the Client's plans change → Outcome: Appointment cancelled; the Specialist knows." ""
neg "B52 processes — a journey with no trigger → outcome" B52 --processes "$M/b52.md" --roles "$RP"

mutate "$PR" "$M/b53.md" "3. Client confirms" "4. Client confirms"
neg "B53 processes — a step numbering gap" B53 --processes "$M/b53.md" --roles "$RP"

mutate "$PR" "$M/b54.md" "a Hold is placed on the Slot for that Client." \
  "a Hold is placed on the Slot for that Client for 5 minutes."
neg "B54 processes — a cutoff inside a journey step" B54 --processes "$M/b54.md" --roles "$RP"

mutate "$PR" "$M/b55.md" \
  "## Publish availability — role: Specialist" "## Publish availability — role: Client" \
  "## Withdraw an appointment — role: Specialist" "## Withdraw an appointment — role: Client"
neg "B55 processes — a significant role with no journey" B55 \
    --processes "$M/b55.md" --roles "$RP" --canvas "$CV"

mutate "$DS" "$M/b56.md" "## Visual identity & references" "## Visual identity"
neg "B56 design — a section renamed" B56 --design "$M/b56.md"

mutate "$DS" "$M/b57.md" \
  "WCAG 2.2 AA conformance · every Client-facing surface · at launch, with keyboard-only completion of every primary journey" \
  "WCAG 2.2 AA conformance"
neg "B57 design — a budget that is not metric · target · condition" B57 --design "$M/b57.md"

mutate "$DS" "$M/b58.md" \
  "| Time rendering | Times are rendered in the Specialist's published timezone, with the timezone named | call 2026-07-14 |" \
  "| Time rendering | Times are rendered in the Specialist's published timezone, with the timezone named |  |"
neg "B58 design — a convention with no source" B58 --design "$M/b58.md"

mutate "$DS" "$M/b59.md" "## Visual identity & references
\`open — no source material\`" "## Visual identity & references
"
neg "B59 design — a section left blank instead of ruled open" B59 --design "$M/b59.md"

mutate "$DS" "$M/b60.md" "| Accessibility — Client-facing surfaces |" \
  "| GB-1 Accessibility — Client-facing surfaces |"
neg "B60 design — a budget ID family nothing reads" B60 --design "$M/b60.md"

mutate "$CO" "$M/b61.md" "## Governance references" "## References"
neg "B61 constitution — the spine section renamed" B61,B64 --constitution "$M/b61.md"

mutate "$CO" "$M/b62.md" "Requirements defects MUST be fixed in the spec" \
  "Requirements defects should be fixed in the spec"
neg "B62 constitution — a principle that is not in MUST form" B62 --constitution "$M/b62.md"

mutate "$CO" "$M/b63.md" \
  "| Authorization | Permissions MUST derive from \`roles-permissions.md\` policy rows only; they are never inferred from personas or narrative material | \`roles-permissions.md\` · CC-XA-01/-02 at every gate | framework seed (D-B5-4) |
" ""
neg "B63 constitution — the Authorization principle unseeded" B63 --constitution "$M/b63.md"

mutate "$CO" "$M/b64.md" "| \`.specify/memory/design-standards.md\` |" \
  "| \`.specify/memory/out-of-scope.md\` |"
neg "B64 constitution — a Context-class file in the Governance-only spine" B64 \
    --constitution "$M/b64.md" --root "$PROJ"

mutate "$CO" "$M/b65.md" "| File | Carries |
|---|---|" "| Role | Entity | Action | Rule / scope | Source |
|---|---|---|---|---|"
neg "B65 constitution — a policy table where a principle belongs" B64,B65 --constitution "$M/b65.md"

mutate "$OS" "$M/b66.md" "| Exclusion | Where it lives instead | Basis · source |" \
  "| Exclusion | Disposition | Basis · source |"
neg "B66 out-of-scope — the lives-instead column renamed" B66 --oos "$M/b66.md"

mutate "$OS" "$M/b67.md" "| Video consultation | not planned |" \
  "| Video consultation | we will not do this |"
neg "B67 out-of-scope — a disposition outside the vocabulary" B67 --oos "$M/b67.md"

mutate "$OS" "$M/b68.md" \
  "a product that books clinician time plausibly also hosts it; declined at kickoff \`[Olena, kickoff]\`" \
  "a product that books clinician time plausibly also hosts it; declined at kickoff"
neg "B68 out-of-scope — a fence with no cited expectation" B68 --oos "$M/b68.md"

mutate "$RP" "$M/b69.md" "| Client | Appointment | cancel | own only |" \
  "| Client | Appointment | cancel | own only, before the appointment starts |"
neg "B69 late entry — a seed row rewritten instead of carried" B69 \
    --seed-early "$FP/roles-permissions.md" --seed-later "$M/b69.md" --seed-kind roles

mutate "$OS" "$M/b70.md" \
  "a booking product for paid care plausibly takes payment at booking; the MVP surface rules it out" \
  "the network asked for payments and we said no"
neg "B70 graduation — the basis rewritten under the resolved disposition" B70 \
    --seed-early "$FP/out-of-scope.md" --seed-later "$M/b70.md" --seed-kind out-of-scope

# ── 6. /ba-run dispatch, both ends ───────────────────────────────────────────

printf '\n▸ /ba-run dispatch for the batch (orchestrator §6.3/§7.1)\n'

for t in t11 t12 t13 t14 t15 t16; do
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
  flat_has "$f" "belong to this skill's run-end block" \
    || bad "ba-$t — does not leave the evidence-table refresh to its own run-end block (§7.4)"
done
ok "six technique skills: frontmatter · references/example.md · self-check · skip-if · depth · refusals · touchpoint"

# the chain's ordering, stated inside the skills that depend on it
has "$SKILLS/ba-t12/SKILL.md" "**Run after the domain model**" "ba-t12 names its predecessor"
has "$SKILLS/ba-t13/SKILL.md" "**Run after the roles model**" "ba-t13 names its predecessor"
has "$SKILLS/ba-t14/SKILL.md" "**Run before the constitution**" "ba-t14 names its successor"
has "$SKILLS/ba-t15/SKILL.md" "**Run after the roles model**" "ba-t15 names both its predecessors"

# ── 7. the compiled sheets' locked content ───────────────────────────────────

printf '\n▸ The six sheets, compiled (b4/b5 §2 depth · §4 procedure · refusals)\n'

T11="$SKILLS/ba-t11/SKILL.md"
has "$T11" "**The canonical form is tabular.**" "ba-t11 carries the tabular-canonical ruling"
has "$T11" "A diagram is a **derived view**" "…and names the diagram as derived, never source"
has "$T11" "each **connection system** becomes a **boundary-reference candidate, never
  an entity**" "the EG-1 sweep's two halves, compiled"
has "$T11" "**Multiplicity is written only where a source states it**" "the multiplicity discipline"
has "$T11" "a candidate whose term is not yet in the glossary → **glossary proposal
     first**" "the glossary-first routing rule"
has "$T11" "**per-feature fields, types or validations.**" "ba-t11 refuses spec Data ground"

T12="$SKILLS/ba-t12/SKILL.md"
has "$T12" "**This file is the authorization principle's enforcement surface, never its
statement.**" "ba-t12's boundary against the constitution"
has "$T12" "the **system-facing activity lines are the only charter input**" \
    "the transformation's sole input, compiled"
has "$T12" "It runs **iff \`personas.md\` exists**" "the conditional transformation"
has "$T12" "The transformation being dormant
   is a legal state, not a gap." "…and dormancy stated as legal"
has "$T12" "**One explicit row per tuple. No wildcard cells, no role inheritance.**" \
    "the row-grain ruling"
has "$T12" "The row grain equals the check grain" "…and the reason it is not negotiable"
has "$T12" "**A population or individual referenced as no actor derives no role**" \
    "roles are exercised ground, not register ground"
has "$T12" "The seed covers Band-1-evident tuples. Later tuples enter by the gate and
  reopen paths, and that is the design." "the seed's deliberate silence"

T13="$SKILLS/ba-t13/SKILL.md"
has "$T13" "**Significance is a checkable fact, not an adjective.**" "the significance ruling"
has "$T13" "**iff it stands as the actor of ≥ 1 canvas Core Function line**" "…with its test"
has "$T13" "**business-rule thresholds and timing values. A journey never states a
  cutoff.**" "the cutoff refusal"
has "$T13" "**Step numbering is journey-local.**" "no cross-file step-ID family"
has "$T13" "Who does a step today, and whether that changes, is legal scoping-interview
  ground." "ba-t13 refuses the scoping settlement"
has "$T13" "**A miss is a proposed edit on that file's ground, routed by batch — never a
  local definition.**" "the coherence pass routes, never defines"

T14="$SKILLS/ba-t14/SKILL.md"
has "$T14" "**This run is evidence-conditional, and the conditionality check comes
first.**" "ba-t14 carries the conditionality as its first rule"
has "$T14" "A file of empty headings is the one outcome this run must not produce." \
    "…and names the outcome it refuses"
has "$T14" "**restating a constraint as a budget.**" "the boundary against constraints"
has "$T14" "A budget derived from
  one **references** it." "…with the legal form of the derivation"
has "$T14" "**Budgets are named rows, and the name is the citation target.**" \
    "no ID family, and the reason"
has "$T14" "It is never silently seeded because
  it sounded professional." "ba-t14 refuses the industry default"

T15="$SKILLS/ba-t15/SKILL.md"
has "$T15" "**MUST-form statements a check can gate a plan against**, never aspiration" \
    "ba-t15 writes for the plan check's surface"
has "$T15" "**this file is its statement**, and nowhere else states it" \
    "the principle's home, stated once"
has "$T15" "Seeded whether
     or not charters exist" "the unconditional Authorization seed"
has "$T15" "**restating writing-standard or gate machinery as principles.**" \
    "the house-methodology fence"
has "$T15" "Restating them here re-enforces spec rules on the wrong artifact." \
    "…and why it is a fence and not a preference"
has "$T15" "**Context-class files are never referenced here**" "the spine's class boundary"
has "$T15" "a reference that would dangle is a planning
   defect surfaced now" "the dangling reference is caught before arming"

T16="$SKILLS/ba-t16/SKILL.md"
has "$T16" "**It runs last in the aspect, deliberately.**" "ba-t16's place in the order"
has "$T16" "against a visible estate, not a guess" "…and the reason for it"
has "$T16" "a fence no one would test is noise, and it is dropped with the sweep note" \
    "the plausibility test"
has "$T16" "the instrument is **the aspect
   waiver on Requirements, never an invented row.**" "the empty-boundary valve"
has "$T16" "A fence written to satisfy a count is ritual compliance" "…and the reason"
has "$T16" "The boundary question stays at
  **whether the product ever**, never **which phase**." "the allocation refusal"
has "$T16" "**by a routed edit
  the decomposition run proposes**" "graduation by machinery, not re-invocation"

# ── 8. closure and the arming run ────────────────────────────────────────────

printf '\n▸ /ba-close-band1 and the arming Scope-H run (orchestrator §8.2, gate §10)\n'

CB="$SKILLS/ba-close-band1/SKILL.md"

# precondition 1, re-derived from the closure event's own state list
python3 - "$STATE" <<'PY' \
  && ok "precondition 1 held at closure — six aspects cleared, zero reopened" \
  || bad "the closure event's state list does not satisfy precondition 1"
import pathlib, re, sys
txt = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
m = re.search(r"Band 1 closed.*?\n(.*?)\n\n", txt, re.S)
block = m.group(1) if m else ""
states = re.findall(r"(Stakeholders|Context|Value|Vision|Solution|Requirements) "
                    r"(first-pass-cleared|waived|reopened|open|untouched)", block)
d = dict(states)
sys.exit(0 if len(d) == 6 and set(d.values()) <= {"first-pass-cleared", "waived"} else 1)
PY
has "$STATE" "AWs carried: none" "precondition 2 held — no standing waiver to re-affirm"
has "$CB" "carried past closure — debt visible to CC-H where it touches spec-anchored ground" \
    "…and the skill carries the re-affirmation's exact wording for when there is one"
has "$CB" "The next act is \`/ba-aspect band2\` (P-O2 — plan composition)" \
    "Band 2 unlocked names its composition act ahead of the technique commands (D-O55)"

# the act
has "$STATE" "2026-07-10 · Band 1 closed · Y.K." "the closure event is recorded (P-O7)"
has "$STATE" "Band: 1 (closed 2026-07-10) — Bands 2/3 capable" "the head reads closed"
has "$CB" "**Not repeatable.**" "the skill refuses a second closure"
has "$CB" "Bands are cumulative capabilities, not a pointer" "…and says why"

# the arming run — requested here, run there, landed in its own ledger
has "$STATE" "arming run: requested — /ba-gate-health full, trigger \"Band-1 closure — the arming run\"" \
    "the closure requests the full Scope-H run"
has "$CB" "**The orchestrator requests the full Scope-H run; the gate runs it.**" \
    "…and the skill never runs it itself"
has "$CB" "Never runs a Scope-H check itself" "the refusal is explicit"
has "$HEALTH" "## Health run 1 — 2026-07-10 — full — Band-1 closure — the arming run" \
    "the arming entry landed in gate-health.md"
has "$HEALTH" "Verdict: HEALTHY" "…HEALTHY"
has "$STATE" "entry landed in .specify/gate-health.md: HEALTHY" \
    "…and the ledger and the health file agree on the verdict"
has "$HEALTH" "Coverage: all spec-anchored artifacts" "the arming run is full by definition"
has "$HEALTH" "Scope rationale:" "…and states its scope rationale before running"

python3 - "$STATE" "$HEALTH" <<'PY' \
  && ok "the closure event and the arming entry agree on the date" \
  || bad "the closure event and the arming entry disagree on the date"
import pathlib, re, sys
state = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
health = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
d1 = re.search(r"(\d{4}-\d{2}-\d{2}) · Band 1 closed", state).group(1)
d2 = re.search(r"## Health run 1 — (\d{4}-\d{2}-\d{2})", health).group(1)
sys.exit(0 if d1 == d2 else 1)
PY

# closure completes on the entry existing, whatever the verdict
has "$CB" "**Closure completes when the arming entry exists — regardless of its verdict.**" \
    "the verdict never blocks closure"
has "$CB" "a heavy-gap arming run signals an aspect-gate escape, not closure
prematurity" "a gappy arming run is a threshold finding, not a closure defect"
has "$CB" "Threshold-gap candidate — 2026-07-10 · should have been caught by AT-RQ-1" \
    "…and the skill carries the candidate's record shape"
grep -q 'Threshold-gap candidate' "$STATE" \
  && bad "a threshold-gap candidate is logged against a HEALTHY arming run" \
  || ok "no threshold-gap candidate logged — the run was HEALTHY, so there was nothing to log"

# the handover the closure performs
has "$CB" "AT-RQ is never re-run on armed ground" "the handover rule, compiled"
has "$STATE" "effects: Scope H armed — custodianship of the spec-anchored estate hands over" \
    "…and the ledger records the handover as the closure's effect"
has "$CB" "never converts an arming-run gap into an aspect waiver" \
    "post-closure debt takes an HA, never an AW"

# the ledger is not under memory/ — the runtime-ledger rule, checked on the fixture
grep -q 'deliberately OUTSIDE' "$PKG_ROOT/payload/specify-overlay/ba/templates/gate-health.md" \
  && ok "the shipped template states the runtime-ledger rule" \
  || bad "the gate-health template does not state why it lives outside memory/"
[ -f "$MEM/gate-health.md" ] \
  && bad "gate-health.md is inside memory/ — inside CC-H-01's glob, which is the one place it must not be" \
  || ok "gate-health.md is outside memory/ — out of the glob, out of the write trigger"

# ── 9. layering ──────────────────────────────────────────────────────────────

printf '\n▸ Layering — no methodology-layer content in the S7 payload (§0, §3.3)\n'

LEAK=0
for f in "$SKILLS"/ba-t1{1,2,3,4,5,6}/SKILL.md "$SKILLS"/ba-t1{1,2,3,4,5,6}/references/example.md; do
  [ -f "$f" ] || continue
  if grep -nE 'BABOK|mining note|Reference design|Review record \(|docs/methodology/[a-z]|D-B[0-9]-[0-9]|D-W[0-9]' "$f" \
       > "$TMP/leak.txt" 2>/dev/null; then
    if [ -s "$TMP/leak.txt" ]; then
      bad "methodology-layer content in ${f#$PKG_ROOT/}:"
      sed 's/^/      /' "$TMP/leak.txt"; LEAK=1
    fi
  fi
done
[ "$LEAK" -eq 0 ] && ok "zero BABOK anchors, mining notes, review records or decision IDs in the 12 S7 payload files"

# ── EC-18 · B7 — the reported case and its chain ────────────────────────────
#
# B7, verbatim: electing T-12 alone silently pulled in domain-model.md (T-11
# output) and constitution.md (T-15 output), and the dependency was declared
# nowhere. Both are now on the sheet, graded, and neither blocks the run.

printf '\n▸ EC-18 — declared preconditions (T-11…T-16, the reported chain)\n'

for t in t11 t12 t13 t15 t16; do
  f="$SKILLS/ba-$t/SKILL.md"
  flat_has "$f" "**Preconditions — declared, rendered, never a block.**" \
    || bad "ba-$t — no precondition declaration"
  flat_has "$f" "never refuses this run and never pulls its producer in" \
    || bad "ba-$t — the declaration does not state visibility-never-a-block"
done
ok "five sheets declare their preconditions and refuse to block on them"

has "$SKILLS/ba-t12/SKILL.md" "\`.specify/memory/domain-model.md\` (**T-11 — Domain (conceptual) modeling**) — **hard**" \
    "ba-t12 declares the domain model hard — the reported half of B7"
has "$SKILLS/ba-t12/SKILL.md" "\`.specify/memory/constitution.md\` (**T-15 — Constitution**) — **soft**" \
    "…and the constitution soft — the principle is named here, authored there"
has "$SKILLS/ba-t13/SKILL.md" "(**T-12 — Roles & permissions**) — **hard**" \
    "ba-t13 declares the roles model hard — journey role cells are verbatim"
has "$SKILLS/ba-t15/SKILL.md" "(**T-12 — Roles & permissions**) — **hard**" \
    "ba-t15 declares the roles model hard — the reference spine must resolve"
has "$SKILLS/ba-t16/SKILL.md" "(**T-07 — Competitive analysis**) — **soft**" \
    "ba-t16 declares the competitive file soft — one of four sweep patterns"

# the killed behaviour: no sheet turns a precondition into a refusal
for t in t11 t12 t13 t15 t16; do
  flat_has "$SKILLS/ba-$t/SKILL.md" "refuse the run until" \
    && bad "ba-$t — a precondition became a hard block"
done
ok "no sheet converts a declared precondition into a refusal"

# ── roll-up ──────────────────────────────────────────────────────────────────

printf '\n  passed: %s   failed: %s\n' "$PASSED" "$FAILED"
if [ "$FAILED" -eq 0 ]; then
  printf '✓ GREEN — S7 techniques III + closure: T-11…T-16 · 31 seeded defects · Requirements cleared · Band 1 closed · armed HEALTHY\n'
  exit 0
fi
printf '✗ RED — %s check(s) failed\n' "$FAILED"
exit 1
