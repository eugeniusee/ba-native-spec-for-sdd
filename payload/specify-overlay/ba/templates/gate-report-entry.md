<!--
  BA-Native Spec — gate report entry (artifact #18). Compiled from the
  completeness contract §7 (core fields) + the gate definition §6.2 (runtime
  record block). Destination: specs/NNN-<feature>/gate-report.md — APPEND-ONLY,
  one block per run.

  Run numbers are monotonic per feature and include blocked admissions
  ("Gate run n — blocked at pre-flight"), so the ledger is gapless.

  Named-gap grammar — every failure line:
      CC-<ID> FAIL — <element>: <what is wrong> → <fix action>
  A failure that does not name its element and its action is itself invalid gate
  output. Non-waivable failures are marked [non-waivable]:
  CC-G-01 · CC-G-02 · CC-FR-01 · CC-TR-01 · CC-XA-01 · CC-XA-02.
-->

## Gate run <n> — <date>
Feature: <NNN-feature> · Spec revision: <hash-short> · Scopes: F (+H pre-flight)
Verdict: PASS | PASS WITH WAIVERS | FAIL (<n> gaps)

Failures:
<!-- each in named-gap grammar; non-waivable marked; "none" if clean -->

Waivers in force:
<!-- W-<NNN>-<nn> · CC-<ID> · <element> · reason: <why accepted now> ·
     risk: <one line> · approver: <name> · revisit: <event-shaped trigger> ·
     [fresh | re-affirmed run <n>] -->

Overrides this run:
<!-- O-<NNN>-<nn> · CC-<ID> · <element> · <why the verdict was a false positive>
     · approver: <name> · [fresh | re-applied — evidence unchanged since run <n>] -->

⚑ sign-offs:
<!-- CC-XA-01 — <extraction summary: n exercised tuples, n policy rows matched>
       · evidence reviewed · <initials>
     CC-XA-06 — <brief §3 conflict check; every §6 Open row touching this
       feature × its resolution> · evidence reviewed · <initials>
     On a FAIL verdict both lines read "— (verdict FAIL)". -->

Category summary:
<!-- totals: in force · evaluated · carried · passed · failed · waived ·
     overridden · skipped; per-category breakdown on FAIL -->

BA approval:
<!-- <name>, <date> — required for any effective PASS. On FAIL: "— (verdict FAIL;
     resubmit after fixes)". -->

Runtime record (gate definition §6.2):
Snapshot:             <k> files hashed — manifest at end of entry
Pre-flight:           clean | <n> gap(s) lifted by HA-<nn>, …
Carried from run <n−1>: <CC-IDs + basis | none>
Skipped:              <CC-ID · element ← blocker | none>
Certification:        <manifest below | — (not an effective PASS)>

<!-- Certification block — written only on an effective PASS (gate §11.1):

Certification: run <n> · effective PASS · <date>
  specs/<NNN-feature>/spec.md                     <hash>
  specs/<NNN-feature>/traceability.md             <hash>   (generated run <n>)
  .specify/memory/roles-permissions.md            <hash>
  .specify/memory/glossary.md                     <hash>
  .specify/memory/domain-model.md                 <hash>
  .specify/memory/scope/<epic>.md                 <hash>
  canvas.md · constitution.md · out-of-scope.md · roadmap (<epic> rows) · [hist <rev>]
Adapter precondition: every hash matches the live file at handoff — any
mismatch → refuse handoff, print the diverged paths, demand re-gate.
-->
