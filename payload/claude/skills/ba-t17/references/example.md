# T-17 — Epics decomposition · output template & worked example

## The template

```markdown
# Roadmap — <project>

## Epics

| ID | Epic | Description | Phase | Status | Source |
|---|---|---|---|---|---|

## Allocation log
(append-only — allocation ground)
```

Two sections, that order. The second is created empty by this run and written
only by `/ba-run t18`.

## Worked example — the decomposition run

Band-1 closure stands from the previous day. Three of the eight rows:

| ID | Epic | Description | Phase | Status | Source |
|---|---|---|---|---|---|
| E-01 | Accounts & Access | Clients and Specialists act under their own accounts. Covers registration, sign-in, and the role split the policy model defines. | Unallocated | Defined | `[inferred]` canvas: Core Functions "Cancel own appointment" (*own* ⇒ accounts) · `[inferred]` roles-permissions.md (Client · Specialist) |
| E-03 | Appointment Booking | Clients book specialists' published slots online instead of calling. Covers slot browsing, booking, cancellation, and specialist notifications. | Unallocated | Defined | `[stated]` canvas: Core Functions — browse · book · cancel · publish · notify (`→ O-2`) · `[stated]` processes.md: booking journey |
| E-07 | Online Payment | Clients pay for appointments in the product rather than at the clinic. Covers taking payment at booking; wider payment scope enters at this epic's scoping call. | Unallocated | Defined | `[stated]` out-of-scope.md: payments deferred row — graduated this run |

**Routed the same sitting** (batch approved): the `out-of-scope.md` payments row
resolves — `deferred — roadmap candidate, Phase 2 hint` becomes
`deferred → E-07 Online Payment`. The exclusion stands; it now points at its
epic.

## What the example is showing

- **Every description is the same two-part shape:** the goal in one sentence,
  then the key capabilities it covers. That shape is not house style — it is the
  input contract of every Tier-1 kit, which reads this row and nothing else about
  the epic.
- **E-01 was born from a probe that fired on evidence.** The access probe found
  `Cancel own appointment` — the word *own* presumes an account — and a role
  model with two roles. Had neither existed, the honest output would have been
  the declared absence, not an Authentication row written because the checklist
  named one.
- **E-01 is the ground-class's worked case.** Both its citations are
  `[inferred]` — the *own*-scoped capability and the role model imply accounts;
  no estate line states them — so the row is `inferred`. It is legal and
  visibly derived at once, and the allocation run reads the class one run later:
  first-named in the advisory, never disqualified by it.
- **E-03's Source is a capability list, not a citation of convenience.** Five
  canvas function lines resolve into this row and only this row. That is what the
  coverage-and-exclusivity pass produces: a Source cell that doubles as the
  partition's proof.
- **E-07 came from the fence, and the fence learned about it.** A graduation is a
  pair of edits or it is a silent divergence: the epic cites the row it graduated
  from; the row resolves to the epic it became.
- **All three phases read `Unallocated`.** They stay that way for the hours
  between this run and the initial allocation. Writing a plausible phase here
  would put a guess in a column this run does not own — and a guess that reads as
  a decision is worse than a blank.

## The publish capability, and the line this run does not cross

`publish` sits in E-03's Source. Someone reading the finished project later will
find *publish availability* delivered as its own feature, with a different
primary role.

That is not a contradiction and not a defect in this row. **Placement is epic
grain; slicing is the brief's.** The capability belongs to Appointment Booking;
whether it ships as one feature or two is a decision the epic's scoping call
informs, the brief proposes in its §8, and Band-3 entry confirms. A decomposition
run that pre-split it here would have decided a Tier-1 question with no call, no
stakeholder, and no brief to record the rationale in.

## The sizing test, applied out loud

| Candidate | Verdict | Why |
|---|---|---|
| "Show a Specialist's photo on the profile" | too small — folded | One user story covers it. It joins Specialist Profiles. |
| "Everything about specialists" | too vague — split | No call agenda could close it in an hour; it slices past three features. |
| Appointment Booking | kept | One 30–60-minute call with ≤ 12 must-asks closes its scope; it slices into two features. |

The rule of thumb behind all three: an epic is a **functional area** — never a
single story, never an everything-bucket.
