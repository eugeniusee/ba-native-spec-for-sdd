<!--
  BA-Native Spec — Scope-S assertion cards (source audit). COMPILED from
  docs/methodology/ba-native-spec-source-audit-definition.md §4; regeneration
  joins `tests/check-cards.py --record` when the audit suite lands.

  Same card shape and same layering rule as assertions-f.md / assertions-h.md.
  Scope S is band-level: no feature, no contract waiver. The instrument for a
  consciously declined obligation is the band-level source acceptance
  `SA-<nn>` (source-audit definition §5), which covers its OB row and nothing
  else.

  Who reads this: the `ba-gate` subagent on the A pass of a Scope-S run
  (`/ba-audit`, Stage 2), against the run workspace — the obligations
  register, the traces, and the band read set. The subagent evaluates and
  returns verdicts with evidence; it edits nothing and proposes nothing.
-->

# Scope-S assertion cards — the A pass

The pass condition is the card's text. A verdict is per assertion, with
evidence; a coverage verdict names its carrier or its search set.

**Checks shorthand** (what a card's Checks set names) —
`reg` = the obligations register (`obligations.md`) · `band` = every
`specs/NNN-*/spec.md` §2/§3/acceptance/§6/§8 · `briefs` =
`.specify/memory/scope/*.md` · `map` = roadmap + out-of-scope + deferral rows ·
`sa` = standing `SA-<nn>` records in `.specify/source-audit.md` · `src` =
the captured sources under `sources/` and recorded attachments · `wbs` =
`exports/wbs.csv` when present.

## Source fidelity (CC-S)

### CC-S-01 · Checks: reg+band+briefs+map+sa
Forward coverage. Every `shall` obligation is carried, partial (with the
missing part named), or accepted. A gap verdict is valid only with the full
search set named — specs, briefs, roadmap, out-of-scope, SA records. A
`should` obligation may stand gap only en route to the decision list.

### CC-S-02 · Checks: band+reg+src
Backward grounding. Every scope-bearing claim — story, integration row, role,
phase label, stated basis — is grounded in a source, or marked as an
assumption. An ungrounded claim, or a claim a source contradicts, is this
family's finding; a contradiction verdict quotes both texts.

### CC-S-03 · Checks: reg+src+band
List union. Where two sources define one list, set or scope, the register row
stands at union width and its carrier holds union width. A carrier holding
the base document's set while an addendum's extension stands uncarried is a
named gap — the extension items listed, the addendum cited.

### CC-S-04 · Checks: src+reg+band+briefs
Client acceptance tables. Every row of a client-authored acceptance or
success-criteria table maps to at least one carrier. Each unmapped row is its
own finding, quoting the row.

### CC-S-05 · Checks: reg+band
Unconditional NFRs. Language, locale and formats, currency, authentication
and access, responsiveness, data retention and performance envelopes stated
without condition are carried as stories or acceptance. An unconditional
obligation standing only as a question, marker or comment is this family's
named gap — the carrier rule of the definition §2 governs.

### CC-S-06 · Checks: map+briefs+reg+src
Deferral legitimacy. Every deferral row and out-of-scope entry touching a
registered obligation carries a basis, and no source contradicts the basis. A
deferral whose basis a source contradicts renders both texts. A deferral with
no basis is a finding even where the deferral is plausible.

### CC-S-07 · Checks: reg+band+sa
Persona coverage. Every user group a source names holds at least one carrier
in the band or one SA record. A group carried only as a name in a role list,
with no story or acceptance reaching it, is `partial`.

### CC-S-08 · Checks: band+briefs+map+src
Cross-band consistency. Integration names, role names and phase labels used
anywhere in the band exist in the sources or the band's own registries and
contradict neither; an integration listed on rows whose phase a source
excludes it from, a role outside the registry's set, a phase word not in the
client's phase vocabulary — each is a named finding. Duplicate carriers of
one obligation with diverging acceptance are this family's divergence
finding, both carriers cited.
