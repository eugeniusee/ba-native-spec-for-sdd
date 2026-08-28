# Mode B — the documented fallback

**BA-Native Spec · handoff note · compiled from plan Q5 · gate definition §11 ·
build plan §4 (S9)**

Mode A is the framework's handoff and this note is not an alternative to it. It
is the answer to one question — *what do you do when Mode A's precondition does
not hold?* — written down so that the answer is a procedure with a known cost,
rather than an improvisation with an unknown one.

---

## 1. The two modes, and why one is primary

| | **Mode A — primary** | **Mode B — fallback** |
|---|---|---|
| How the spec reaches Spec Kit | It is already there. The compiler wrote the certified artifacts directly into `specs/NNN-feature/` and `.specify/memory/` | It is imported — `/speckit-specify` reads our spec and writes Spec Kit's |
| What sits between gate and plan | A hash check | **An LLM** |
| The guarantee | *The certified text is the read text* | The read text is a re-rendering of the certified text |
| The adapter's act | Verify · branch · plumb · report — automatic when implementation takes the feature (gate §11.2) | None — this is not the adapter's path |

Plan Q5 fixes Mode A as primary for one reason, and it is the reason the whole
gate exists: **no LLM between gate and plan.** Every assertion the contract
checks, every waiver the BA granted, every marker deliberately left in the text
— all of it is verified against bytes. Put a generative step after
certification and the thing that was certified is no longer the thing that gets
built. The certification does not become false; it becomes *irrelevant*, which
is worse, because it still reads as a guarantee.

So Mode B's cost is not "slightly lossier". It is: **the certification stops
covering the artifact the coding agent reads.**

---

## 2. When Mode B applies

Three cases, and no others:

1. **The project was not installed by our installer.** An existing Spec Kit
   project with its own history, where `.specify/` predates us and the layout is
   not ours to place files into.
2. **The Spec Kit layout moved under a version we do not pin.** Our build pin is
   **v0.12.5** (D-P2-8). A project on a materially different release whose
   `specs/NNN-feature/` convention or template contract has changed is a project
   where writing directly is guessing.
3. **A tooling constraint forbids the direct write** — a repository policy, a
   CI-owned `specs/` tree, a platform that generates the feature folder itself.

Everything else is Mode A. In particular, these are **not** Mode B triggers:
a failing hash guard (that is a re-gate — the guard is working) · an
inconvenient branch state · a spec someone wants to "tidy first" · impatience
with a FAIL.

---

## 3. The procedure

1. **Certify first, always.** Mode B changes where the spec goes; it changes
   nothing about how it is produced. Run the full delivery loop — Tier 2 →
   `/ba-gate <feature>` → effective PASS. An uncertified spec imported through
   Spec Kit is not Mode B, it is no method at all.
2. **Run the guard by hand, before the import:**
   ```bash
   python3 .specify/ba/scripts/sk_handoff.py <NNN-feature> --root . --verify-only
   ```
   Clean means the certified text is what you are about to import. Not clean
   means re-gate first — same rule as Mode A, same reason.
3. **Import.** Run Spec Kit's own `/speckit-specify` against the certified
   `spec.md`, instructing it to **carry the text through, not to re-elicit**:
   the ten headings, the story IDs, the FR IDs, the acceptance blocks, and —
   this is the one that gets lost — **every `[NEEDS CLARIFICATION]` marker
   exactly where it stands.** Each marker is a waived gap with a record behind
   it; an import that "helpfully" resolves one is silently spending a decision
   the BA made consciously.
4. **Diff the import against the certified text.** By hand, or with any diff
   tool. You are looking for three things: content that changed meaning,
   requirements that vanished, and markers that were resolved. This step is not
   optional — it is the manual substitution for the hash guard, and it is the
   only thing standing where Mode A has a cryptographic check.
5. **Record the divergence.** Append to the feature's `gate-report.md`, under
   the certified run:
   ```
   Mode B import — <date>: spec imported via /speckit-specify. The certification
   covers specs/<NNN-feature>/spec.md as certified; the imported artifact at
   <path> is a derived copy and is NOT covered. Diff reviewed by <BA>, <date>.
   ```
   The gate never writes this and neither does the adapter: it is a BA record of
   a BA decision. What it exists to prevent is a later reader treating the
   certification manifest as though it covered the imported file.
6. **Re-gate the import if it diverged in substance.** If step 4 found anything
   beyond formatting, the honest move is to make the imported artifact the spec
   and gate *that* — one delivery cycle, one certified text. Two texts, one
   certified and one built from, is the state this whole framework exists to
   make impossible.

---

## 4. What Mode B does not change

- **The contract.** Same 61 assertions, same non-waivable six, same ⚑ pair.
- **The band structure.** Discovery, decomposition, and the Tier-1/Tier-2 loop
  are upstream of the handoff and untouched by which mode ends it.
- **The fix discipline.** Spec errors are fixed in the spec and re-run
  downstream — never hand-patched in code, and never patched in the import.
- **Escape logging (gate §12).** A downstream catch is still filed in
  `.specify/gate-tuning.md` against the CC-ID that ought to have caught it.
  Under Mode B, add the import step to the escape record's `defect` line when
  the defect could have entered there — an escape that the import introduced is
  a Mode-B cost being measured, which is exactly what you want on the record
  when someone next proposes it.

---

## 5. The standing recommendation

Use Mode A. If you find yourself in Mode B for reason 1 or 2 above, the
durable fix is to bring the project onto the installed layout at the pinned
release — then the handoff is a hash check again, and the guarantee comes back.

*Compiled at S9 from: plan v2.13 Q5 · gate definition v0.3 §11–§12 · build plan
v0.2 §4. Repo-side documentation — never installed, no runtime path reads it.*
