# Golden case — Nutrivity · expected Scope-S findings

Answer key for calibrating `/ba-audit` (source-audit definition §9). Pinned
from the human-scored evaluation of 2026-08-14: the generated Nutrivity band
(six epics: Demo Access & Roles · Patient Nutrition Profiles · AI Menu
Recommendation · Nutrition Safety & Conflict Detection · Menu Planning &
Approval · Operational Dashboard & Indicators) scored against the full client
corpus — the functional-prototype requirements (FR), the Blackthorn clinical
nutrition catalogue (CAT), the AI privacy & security concept (PRIV), the UI
inspiration document, and the `#est_nutrivity` capture (SLK). Evaluation IDs
(`S-nn`) refer to that evaluation's findings register; the 77-row matrix
workbook is the full key.

**Calibration bar:** every MF row raised (family match required, wording
free) · zero NC rows raised · every MF row's evidence carries file + place +
verbatim quote and a band-wide search set. A framework change that moves
either count is a regression until argued otherwise.

Quotes below are verbatim from the corpus and are the minimum evidence an
audit finding must reach; section anchors follow each document's own
numbering.

---

## Must-fire (MF)

MF-01 · CC-S-05 — FR §2: "the application should be implemented in **German
only**" · expected: no carrier in any epic; thirty comment-cell mentions are
not carriers · proposal targets the access/setup epic · (S-01)

MF-02 · CC-S-04 — CAT §9: "User can generate a 7-day menu for one patient and
for a station/patient group"; FR M4: "Create a 7-day menu plan for 80
patients…" · expected: no generation carrier — the week *view* rows do not
carry a generation obligation · (S-02)

MF-03 · CC-S-06 — CAT §4 (renal rows): "Calculate / approximate potassium per
meal and day… Show protein budget per day… Show carbohydrate estimate per
meal" vs the band's deferral "nutrient-level computation → Phase 2" and the
classification AC "without computing nutrient totals" · expected: deferral
contradicted, both texts rendered · (S-03)

MF-04 · CC-S-04 — CAT §9: "User can view and **edit** anonymized demo
profiles" vs the band's deferral "creating and editing patients → Phase 2 ·
read-only seeded" · (S-04)

MF-05 · CC-S-03 — union of FR M5's seven conflict types with CAT §4's
histamine row ("Hard block for elimination profile…") · expected: the band's
conflict-type set stands at base width; histamine uncarried · (S-05)

MF-06 · CC-S-01 — CAT §6 scenarios C ("Renal + diabetes combination") and D
("Histamine elimination"), CAT §11: "Prepare 10-15 realistic anonymized
patient profiles covering the mandatory scenarios" · expected: the dataset
carrier guarantees five FR profiles only · (S-06)

MF-07 · CC-S-08 — role "Hospital Administration" on dashboard rows vs the
band's own registry AC fixing exactly four roles (FR §3.1–§3.4) · (S-08)

MF-08 · CC-S-08 — "KISIM / KIS hospital information system" in Integrations
on prototype-phase rows vs FR §5 "full KISIM integration" out of scope and
CAT §8 "The Functional Prototype will not connect to KISIM/KIS" · (S-09)

MF-09 · CC-S-08 — "Weather forecast service" as an Integration vs the band's
own deferral "real weather-service integration → Phase 2; a fixed demo
forecast substitutes" · (S-10)

MF-10 · CC-S-02 — the band's basis claim "no source names the replacement —
the nutrition catalog gives the block, not the fix" vs CAT §4's replacement
column ("Show replacement suggestions such as rice, corn, potato, quinoa…")
and FR M5's worked example ("Replace wheat pasta with gluten-free rice
noodles.") · expected: contradiction, both texts · (S-15)

MF-11 · CC-S-05 — PRIV §6 "AI requests can be stored temporarily and
automatically deleted after a defined period" · expected: no carrier · (S-16)

MF-12 · CC-S-01 — CAT §3 meal-scope / preference data ("menu style
preferences"; disliked and liked ingredients per the catalogue's
preference tier) · expected: preference exists only as a severity class, no
data carrier · (S-17)

MF-13 · CC-S-01 — CAT §7: "Every ingredient/recipe/component must support
tags…" and "Menu inherits the combined restrictions of all components…" ·
expected: no tagging or inheritance carrier behind the rules store · (S-18)

MF-14 · CC-S-04 — CAT §9: "Approved menus can generate a tray/label preview
with patient ID, station/room, meal, diet form, allergens and safety notes";
FR M7 label content list · expected: zero label carrier in the band · (S-19)

MF-15 · CC-S-01 — FR M6: "list of available ingredients · quantity display ·
expiry date · … · low-stock warning · warning for ingredients close to
expiry" · expected: inventory stands only as a generation input · (S-20)

MF-16 · CC-S-05 — FR M12: "responsive for desktop and tablet" · expected: no
carrier · (S-22)

MF-17 · CC-S-08 — phase label "MVP" on Functional-Prototype-phase rows vs the
client's phase vocabulary (FR §8: Functional Prototype, then MVP) · (S-14)

MF-18 · CC-S-07 — FR §3.3 Nursing / Ward Staff ("view meal status per
patient · see assigned meals per patient / room · check special diet notes")
· expected: `partial` — the role exists in the registry, no story or
acceptance reaches §3.3's needs · (FR12-07)

## Must-not-fire (NC — negative controls)

NC-01 · CC-S-01 must not report the dashboard (FR M1) as a gap: the
Operational Dashboard & Indicators epic carries it. This control holds the
band-wide search rule — a per-spec read would raise it falsely.

NC-02 · CC-S-06 must not report the bulk-approval deferral: its basis ("FR M4
lists confirmation status without a bulk act") is contradicted by no source.
A legitimate, based deferral is the instrument working.

NC-03 · **no estimate column exists in the export; one appearing is a
regression.** Nothing may report the absence as a gap: the pair is removed at
§10.5 v0.24 — estimating is the client's act, outside the export, and the
framework never estimates numerically. Export law, not a source obligation.

NC-04 · CC-S-02 must not report the flagged performance inferences ("confirm
3 seconds — basis: no source states a target"): a marked assumption over
ground no source states is legal posture, not an ungrounded claim.

---

Escapes discovered against this key file to `.specify/gate-tuning.md` as
class `audit escape`, naming the CC-S family that ought to have caught them.
One golden case is calibration, not validation — add the next human-scored
band before tuning family texts to this one.
