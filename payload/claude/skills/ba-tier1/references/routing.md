# The routing table — where a cross-cutting finding goes

The seven destinations. Used by **Tier-1 ingestion** and, unchanged, by
**Tier-2 gap answers** whose content is cross-cutting. One table, two readers —
so there is one place to correct if a destination ever moves.

| Finding class | Destination |
|---|---|
| New stakeholder / changed decision rights | `.specify/memory/stakeholders.md` |
| New role, or a permission implication | `.specify/memory/roles-permissions.md` — **governance change: proposed, never silently written** |
| New domain term, synonym conflict | `.specify/memory/glossary.md` |
| New entity or relationship | `.specify/memory/domain-model.md` |
| New constraint — technical / business / regulatory | `.specify/memory/constraints.md` |
| New external system of project-wide relevance | `.specify/memory/context.md` **+** the brief's External Systems |
| Product-level exclusion | `.specify/memory/out-of-scope.md` |

## The discipline around the table

**Assemble as a batch.** Each entry is `finding · destination · edit text` — the
edit text written out, not described. A batch the BA has to author is not a
proposal.

**The BA approves the batch.** Then the framework writes. There is no
finding-by-finding drip and no silent write, and the approval covers the batch as
approved — an edit the BA amended is written as amended.

**On approval the armed scoped health check fires silently.** It is the gate's
cadence, on the gate's schedule; nothing here runs it.

**Arrival is never gated.** A finding routes to its destination artifact whatever
state that artifact's aspect is in. A booking call that surfaces a business
constraint writes `constraints.md` even if Context has not been looked at since
closure.

## The two findings that are not routings

**A contradiction is not a routing.** If the finding *contradicts* existing
content rather than adding to it, it is a conflict: the proposed edit plus a
**reopen signal** when the contradicted artifact belongs to a gated aspect. It
goes to `/ba-reopen`, and the ruling is the BA's.

**A permission is never self-granted.** A spec or a brief that needs a
permission tuple which does not exist proposes the governance edit and waits. The
sequence is: governance first, then the artifact that references it. Reversing
the order is how a role quietly acquires a right nobody ruled on.

## What is written into the brief itself

Every routed finding leaves a row in the brief's **§9 Routing Log** —
`Finding · Destination artifact · Date`. That log is the brief's honesty device:
it says what deliberately lives elsewhere, so nobody re-discovers a routed
finding six weeks later and files it as a gap.
