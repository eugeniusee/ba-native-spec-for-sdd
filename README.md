# BA-Native Spec

**Spec-Driven Analysis** — the analysis layer that makes Spec-Driven Development
actually work. An installable Claude Code package that carries a project from
presale canvas to a gate-certified feature spec that `/speckit-plan` consumes
with zero manual rework.

This repository is the **package repo**: it builds the installable payload. It is
not itself the installed thing.

---

## Status

Phase 2 build, sessions **S1–S4 of S9** complete (foundation · M machinery ·
gate · orchestrator). See
[`BUILD-LOG.md`](BUILD-LOG.md) for the per-session record and
[`docs/methodology/ba-native-spec-phase2-build-plan.md`](docs/methodology/ba-native-spec-phase2-build-plan.md)
§4 for the session plan.

| Session | Units | State |
|---|---|---|
| S1 | Repo skeleton · `install.sh` · payload overlay · 13 templates · mirrors · manifest | ✅ built |
| S2 | 10 checker scripts · toy-world fixtures | ✅ built |
| S3 | Gate skills · gate agent · 3 compiled cards · report/certification writer | ✅ built |
| S4 | Orchestrator agent · 9 workflow skills | ✅ built |
| S5–S7 | 16 Band-1 technique skills · discovery agent | pending |
| S8 | Band-2 pair · Tier-1/Tier-2 spine · analyst agent | pending |
| S9 | Adapter · README · quickstart · Phase-2 exit test | pending |

`tests/check-layout.sh` reports pending units by owning session — nothing is
silently missing.

---

## Install (into a target project)

```sh
cd /path/to/your/project      # a git repo
/path/to/ba-native-spec/install.sh
```

The installer runs pinned Spec Kit **v0.12.5** (D-P2-8), overlays the framework
payload, writes the `AGENTS.md` / `CLAUDE.md` mirrors, and generates
`.specify/ba/manifest.md`. It is idempotent: a re-run replaces installer-laid
files and the fenced mirror blocks only — never runtime content, ledgers, or
`specs/`.

```
install.sh [--offline] [--dry-run] [--force-speckit] [--target <dir>]
```

Offline use needs `vendor/spec-kit-v0.12.5.zip` — see [`vendor/README.md`](vendor/README.md).

## Test

```sh
tests/check-layout.sh --target /path/to/project --session S4   # this session's bar
tests/check-layout.sh --target /path/to/project                # full Phase-2 bar
tests/check-m.sh                                               # the M-checker suite
tests/check-gate.sh                                            # the gate suite
tests/check-orchestrator.sh                                    # the orchestrator suite
```

`check-m.sh` runs the ten vendored checkers against the appointment-booking
fixture world, asserts each case against its recorded verdict table, reproduces
gate run 2's M-detectable gaps verbatim, and fails if any of the 24 M assertions
is not exercised with both a seeded FAIL and a PASS.

`check-orchestrator.sh` replays the orchestrator rules' §12 exhibits — the
BA-planning loop, a threshold cleared into Band-1 closure, and the RO-1 reopen
end to end — validates both ledgers against the state/transition/DAG/waiver/
reopen/closure grammar, and seeds fourteen distinct defects that must each trip
their own rule.

---

## Layout

```
ba-native-spec/
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
│  └─ quickstart.md        BA quickstart (S9)
└─ tests/
   ├─ check-layout.sh · layout.expected
   ├─ check-m.sh           the M-checker suite (S2)
   ├─ check-gate.sh        the gate suite — runs 2→3 replay (S3)
   ├─ check-cards.py       compiles + verifies the three cards (S3)
   ├─ check-orchestrator.sh  the orchestrator suite — §12 exhibits replayed (S4)
   ├─ check-ledger.py      aspect-ledger grammar validator (S4 harness; not installed)
   ├─ fixtures/            the toy world (S2) · band1/ the §12 ledgers (S4)
   └─ exit-test.md         the Phase-2 exit script (S9)
```

**The layering rule.** Nothing under `docs/methodology/` is ever installed and no
runtime path reads it. Compiled build artifacts carry operative text + IDs only;
the chain stays verifiable one way — build artifact → ID → document line → BABOK
anchor.

## Requirements

`git` · `python3` ≥ 3.11 · `uv` (for the pinned Spec Kit install) · `bash`.
No runtime dependency on anything upstream: checker content is vendored.
