# BA-Native Spec

**Spec-Driven Analysis** — the analysis layer that makes Spec-Driven Development
actually work. An installable Claude Code package that carries a project from
presale canvas to a gate-certified feature spec that `/speckit-plan` consumes
with zero manual rework.

This repository is the **package repo**: it builds the installable payload. It is
not itself the installed thing.

---

## Status

**Phase 2 complete — all nine build sessions, all 67 units.** The Phase-2 exit
test (`tests/check-exit.sh`) runs the ten-step script of build plan §5 end to
end against one real install and is green: install → gated discovery →
decomposition and Tier-1 brief → certified spec → named-gap FAIL → fix → PASS
WITH WAIVERS → refusal on divergence → handoff → `/speckit-plan` consuming it
with zero manual rework.

See [`BUILD-LOG.md`](BUILD-LOG.md) for the per-session record and
[`docs/methodology/ba-native-spec-phase2-build-plan.md`](docs/methodology/ba-native-spec-phase2-build-plan.md)
§4 for the session plan.

| Session | Units | State |
|---|---|---|
| S1 | Repo skeleton · `install.sh` · payload overlay · 13 templates · mirrors · manifest | ✅ built |
| S2 | 10 checker scripts · toy-world fixtures | ✅ built |
| S3 | Gate skills · gate agent · 3 compiled cards · report/certification writer | ✅ built |
| S4 | Orchestrator agent · 9 workflow skills | ✅ built |
| S5 | `ba-t01`…`ba-t03` · discovery agent · `/ba-run` dispatch proven | ✅ built |
| S6 | `ba-t04`…`ba-t10` · the Context estate in framework shape | ✅ built |
| S7 | `ba-t11`…`ba-t16` · Requirements cleared · Band 1 closed · Scope H armed | ✅ built |
| S8 | Band-2 pair · Tier-1/Tier-2 spine · analyst agent | ✅ built |
| S9 | `ba-handoff` · `sk_handoff.py` · Mode-B note · quickstart · exit test | ✅ built |

`tests/check-layout.sh` reports pending units by owning session — nothing is
silently missing. With no `--session` it requires the whole tree, which is the
Phase-2 exit bar; that bar passes as of S9.

**New here?** Start with [`docs/quickstart.md`](docs/quickstart.md) — the BA's
walkthrough of the whole loop, and the manual-mode bridge for projects where the
package is not installed.

---

## Install (into a target project)

```sh
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/eugeniusee/ba-native-spec-for-sdd/main/bootstrap.sh | bash
```

No clone, no GitHub account. `bootstrap.sh` downloads the package, runs
`git init` if the directory is not a repository yet, and hands over to
`install.sh --target "$PWD"` — whose output you see verbatim and whose exit code
you get. Installer options pass straight through:

```sh
curl -fsSL https://raw.githubusercontent.com/eugeniusee/ba-native-spec-for-sdd/main/bootstrap.sh | bash -s -- --offline
```

It refuses to run inside this package repo: the repo *builds* the payload, it is
not a place to install it into.

**The manual path** — a clone you can pin, and what the bootstrap does under the
hood:

```sh
cd /path/to/your/project      # a git repo
/path/to/ba-native-spec/install.sh
```

Either way, the installer runs pinned Spec Kit **v0.12.5** (D-P2-8), overlays
the framework payload, writes the `AGENTS.md` / `CLAUDE.md` mirrors, and
generates `.specify/ba/manifest.md`. It is idempotent: a re-run replaces
installer-laid files and the fenced mirror blocks only — never runtime content,
ledgers, or `specs/`.

```
install.sh [--offline] [--dry-run] [--force-speckit] [--skip-speckit] [--target <dir>]
```

Offline use needs `vendor/spec-kit-v0.12.5.zip` — see [`vendor/README.md`](vendor/README.md).
The archive is upstream's artifact and is not committed, so it is a
clone-and-populate step: a bootstrap install has no vendored Spec Kit to fall
back to, and `uv` is required on both paths (D88).

## Test

```sh
tests/run-all.sh                                               # the regression — all fifteen checks, one table
tests/run-all.sh --file-only                                   # the twelve file-only checks; no install, no network
tests/check-exit.sh                                            # the Phase-2 exit test — all ten steps
tests/check-install.sh                                         # the install UX — bootstrap · self-guard · uv-free
tests/check-layout.sh --target /path/to/project                # full Phase-2 bar
tests/check-layout.sh --target /path/to/project --session S8   # a single session's bar
tests/check-m.sh                                               # the M-checker suite
tests/check-gate.sh                                            # the gate suite
tests/check-orchestrator.sh                                    # the orchestrator suite
tests/check-techniques.sh                                      # the technique suite, batch I
tests/check-techniques2.sh                                     # the technique suite, batch II
tests/check-techniques3.sh                                     # batch III + Band-1 closure
tests/check-spine.sh                                           # Band 2 + the Tier-1/Tier-2 spine
tests/check-register.sh                                        # the BA-facing communication register
```

`run-all.sh` runs the whole regression and prints the roll-up table this
package's BUILD-LOG entries carry: the twelve file-only checks, then the three
that install first — the full layout bar on a fresh offline install, the Phase-2
exit test, and the install-UX suite. It asserts nothing of its own. Every verdict is the check's own exit
code and every count is parsed from the check's own roll-up line, so a suite
that stops printing counts reports that, not a passing row. `--file-only` runs
the twelve that need no install and no network; `--keep` keeps the installed
projects; `-v` streams each check's output as it runs.

`check-exit.sh` is the integration suite: it installs into a fresh git repo and
runs build plan §5's ten steps against that one project — the full layout bar,
the Band-1/Band-2 estate validated live, gate run 2 FAIL → fixes → run 3
incremental PASS WITH WAIVERS with certification, the one-byte refusal, the
handoff, and the four sub-clauses of "zero manual rework". Mechanical acts run
live; agent acts are staged from recorded fixtures and validated in place. Add
`--keep -v` to inspect the resulting project.

`check-m.sh` runs the ten vendored checkers against the appointment-booking
fixture world, asserts each case against its recorded verdict table, reproduces
gate run 2's M-detectable gaps verbatim, and fails if any of the 24 M assertions
is not exercised with both a seeded FAIL and a PASS.

`check-techniques2.sh` validates the Context estate, the Assumed → Confirmed
round trip and the canvas at aspect grade, re-derives every row of the Context,
Value, Vision and Solution evidence tables from the artifacts themselves, and
seeds twenty-three distinct defects that must each trip their own rule.

`check-register.sh` enforces orchestrator §10.3's register rule 5 across the
skill / agent / mirror layer: it derives the file set from the payload, joins
soft-wrapped lines into the paragraphs the BA actually sees, skips fenced blocks
(rule 8 — the pinned shape governs), and requires every `T-nn` / `P-On` to carry
its name. The names are read from the catalogue index and orchestrator §10.1's
Moment column, not hardcoded, so a rename in either document breaks the scan
instead of drifting past it. Its fifth section holds down the other rule that
compiles into every unit — orchestrator §10.2's session boundary: byte-identical
in all 33 skills and 4 personas, and §10.2's own paragraph in both mirrors,
derived from the document rather than pinned here. A new skill that ships
without the block goes red by existing. `--self-test` runs the seeded-defect
control alone; `--list` prints the derived name table.

`check-orchestrator.sh` replays the orchestrator rules' §12 exhibits — the
BA-planning loop, a threshold cleared into Band-1 closure, and the RO-1 reopen
end to end — validates both ledgers against the state/transition/DAG/waiver/
reopen/closure grammar, and seeds fourteen distinct defects that must each trip
their own rule.

---

## Layout

```
ba-native-spec/
├─ bootstrap.sh            the one-liner: fetch + git init + hand over to install.sh
├─ install.sh              pinned init + overlay + mirror + manifest
├─ VERSION                 package semver
├─ payload/                byte-exact copy source for everything installed
│  ├─ claude/              agents/ · skills/
│  ├─ specify-overlay/     templates/spec-template.md · ba/…
│  └─ mirror/              AGENTS.md · claude-block.md
├─ vendor/                 offline Spec Kit fallback (not committed)
├─ docs/
│  ├─ methodology/         the 13 pinned Phase-1 documents — the grounding every
│  │                       build session reads; never installed
│  ├─ quickstart.md        BA quickstart — the loop, and manual mode (S9)
│  └─ mode-b-fallback.md   the documented handoff fallback, and its cost (S9)
└─ tests/
   ├─ run-all.sh           the regression runner — all fifteen checks, one table
   │                       (Lane D; closes the hand-assembled roll-up)
   ├─ check-layout.sh · layout.expected
   ├─ check-m.sh           the M-checker suite (S2)
   ├─ check-gate.sh        the gate suite — runs 2→3 replay (S3)
   ├─ check-cards.py       compiles + verifies the three cards (S3)
   ├─ check-orchestrator.sh  the orchestrator suite — §12 exhibits replayed (S4)
   ├─ check-ledger.py      aspect-ledger grammar validator (S4 harness; not installed)
   ├─ check-techniques.sh  the technique suite, batch I — T-01/T-02/T-03 (S5)
   ├─ check-techniques2.sh the technique suite, batch II — T-04…T-10 (S6)
   ├─ check-techniques3.sh the technique suite, batch III + closure — T-11…T-16,
   │                       /ba-close-band1 and the arming Scope-H run (S7)
   ├─ check-spine.sh       Band 2 + the spine — T-17/T-18, Tier 1, Tier 2 (S8)
   ├─ check-band1-artifacts.py  the Band-1 artifact validator — canvas (framing and
   │                       aspect grade) · glossary · register · context · constraints ·
   │                       competitive · personas · domain model · roles & permissions ·
   │                       processes · design standards · constitution · out-of-scope
   │                       (S5/S6/S7 harness; not installed —
   │                       the technique layer ships no checker)
   ├─ check-band2-artifacts.py  the Band-2 & spine validator — roadmap rows and
   │                       allocation log · the call kit · the scope brief · the
   │                       Tier-2 session (S8 harness; not installed either)
   ├─ check-exit.sh        the Phase-2 exit test — §5's ten steps, one install (S9)
   ├─ check-install.sh     the install UX — the bootstrap one-liner, the package-repo
   │                       self-guard, the uv-free case (Lane A)
   ├─ check-register.sh    the BA-facing communication register — §10.3 rule 5
   │                       across the skill/agent/mirror layer, names read from
   │                       the catalogue index and §10.1 (Lane A)
   ├─ fixtures/            the toy world (S2) · band1/ the §12 ledgers (S4) ·
   │                       presale-brief.md + band1/first-pass/ (S5) ·
   │                       band1/elected/ the BA-elected charter (S6) ·
   │                       band1/gate-health.md the arming Scope-H entry (S7) ·
   │                       tier2-answer-sheet.md the scripted Tier-2 session (S8) ·
   │                       speckit-plan/ the recorded /speckit-plan outputs (S9)
   └─ exit-test.md         the Phase-2 exit script, agent-runnable (S9)
```

**The layering rule.** Nothing under `docs/methodology/` is ever installed and no
runtime path reads it. Compiled build artifacts carry operative text + IDs only;
the chain stays verifiable one way — build artifact → ID → document line → BABOK
anchor.

## Requirements

`git` · `python3` ≥ 3.11 · `uv` (for the pinned Spec Kit install) · `bash`.
No runtime dependency on anything upstream: checker content is vendored.
