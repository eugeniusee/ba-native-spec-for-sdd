# T-13 — output template & worked example

## The template

```markdown
# Core Processes — <project>

## <Journey name> — role: <role, verbatim from roles-permissions.md>
Trigger: <what starts it> → Outcome: <what stands changed>
1. <actor> <action> → <observable result>   (entities by domain-model name)
Source: <citations>
```

One section per journey. The role in the heading is quoted, not paraphrased.

## Worked example — the Requirements seed

**Book an appointment — role: Client**
Trigger: a Client needs a Specialist appointment without phoning (→ P-1) → Outcome: Appointment booked; the Specialist knows.
1. Client browses a Specialist's published Availability → open Slots shown. `[canvas §7 Browse line]`
2. Client books an available Slot → Appointment created; confirmation shown to the Client; the Specialist is notified. `[canvas §7 Book · Notify lines]`
Source: canvas §7 · kickoff notes · serves O-2

**Cancel own appointment — role: Client**
Trigger: the Client's plans change → Outcome: Appointment cancelled; the Specialist knows.
1. Client cancels own Appointment → Appointment cancelled; the Specialist is notified. `[canvas §7 Cancel · Notify lines]`
Source: canvas §7 · serves O-2 (the Slot's rebooking disposition is deliberately unstated — spec ground)

**Publish availability — role: Specialist**
Trigger: the Specialist's schedule for the period ahead is set → Outcome: Availability stands published; Slots browsable by Clients.
1. Specialist publishes own Availability → Slots become browsable by Clients. `[canvas §7 publish line]`
Source: canvas §7 · serves O-2

## What the example is showing

- **Three journeys, two roles, and the significance set is evidenced.** Client
  and Specialist are the actors of canvas function lines, so both carry journeys.
  Nobody else does — and nobody else has a function line.
- **Every journey serves an objective, and says which.** A journey that moves no
  objective is a description of activity, not a core process. The `serves O-2`
  on each Source line is that claim, made checkable.
- **Steps are actor → action → observable result.** *Client books an available
  Slot → Appointment created; confirmation shown; the Specialist is notified.*
  Three observable results, one step. A step whose result is not observable is a
  step nobody can later locate a feature inside.
- **The roles are quoted.** "Client" and "Specialist" are the role model's own
  strings. When the story-level check later asks whether a story's actor matches
  a defined role, this file has already been holding that line for weeks.
- **The rebooking disposition is deliberately unstated, and the note says so.**
  What happens to a Slot when its Appointment is cancelled is a business rule.
  Writing *"the Slot returns to Availability immediately"* here would put a rule
  in a journey and give the spec a fact to contradict.

## The hold step, and the cutoff that is not there

A later revision of the booking journey grows a middle step — *Client selects an
available Slot → a Hold is placed on the Slot for that Client* — once a Hold
stands in the domain model and something states it.

What it still does **not** carry: the five minutes. Nor the expiry. Nor what
happens when two Clients reach the same Slot at once. Those are the feature's
flows and its rule ground, and helicopter grade carries none of them. The line
between the step and the cutoff is the whole depth boundary, and it is visible
inside one sentence.

## What the scoping kit may and may not ask, because of this file

Once these journeys stand, they become an **answered source**: a call that asks
*"what does a Client do to book an appointment?"* is asking what this file
already states, and that question is illegal.

But the as-is walk stays legal. *"How does a booking happen today — who picks up
the phone, what do they write down?"* is not answered here: this file records the
to-be journeys, and today's mechanics are context and competitive ground. The
boundary is not the topic, it is the tense.

## When a role's actor list grows

If a later correction widens a canvas function line's actor list — *availability
published by Specialists or their clinic administrators* — the publish journey's
**role and outcome are unchanged**. The journey belongs to the Specialist; who
else may perform the act is a policy question, and it is answered in the role
model.

That asymmetry is why journeys are written per role rather than per capability.
The capability moved; the journey did not.
