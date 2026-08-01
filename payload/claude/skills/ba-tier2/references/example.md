# Tier 2 — a worked gap-question exchange

Feature `004-appointment-booking`, parent epic E-03. The context stack is loaded,
the skeleton is drafted, four markers stand.

## The marker, in the draft

```
BR-002 [NEEDS CLARIFICATION: confirm free-cancellation cutoff — captured
detail says late cancellations are costly, no concrete boundary given;
basis for recommendation: common practice 24h]
```

Note what the draft did **not** do: it did not write "24 hours" and move on, and
it did not leave the business rule out. **The value is drafted and the
uncertainty is marked** — which is what makes the next question legal.

## The packet

```
GQ1 of 7 — [legality: resolves marker BR-002; unresolved → CC-G-03 fail;
            the value feeds CC-BR-01 (threshold required)]
           [destinations: BR-002 · US2 acceptance · FR-cancellation reference]

Question: What is the free-cancellation boundary, and what happens to the
slot on a late cancellation?

Recommended answer: Free cancellation strictly more than 24 hours before
start_time. Inside 24 hours, cancellation is allowed but the slot is NOT
released for rebooking — this directly addresses the stated cost concern.
Basis: Captured Detail (specialist quote) + common practice for the cutoff;
the not-released clause is the mechanism that protects Specialist income.

BA: confirms.
```

## Where the answer lands — three places, one act

- **BR-002** — *Free cancellation window: strictly more than 24 hours before
  start_time. Inside 24h, cancellation is allowed but the Slot is NOT released
  for rebooking.*
- **a checklist line under US2** — *Cancellation inside 24h of start_time keeps
  the Slot unavailable for rebooking (BR-002).*
- **the cancellation requirement** gains its BR-002 reference.

The marker is gone. Question count: 1 of 7.

**And the queue re-evaluates: two queued data-table questions about slot release
die with this answer.** That is why questions go one at a time — asked as a batch
of three, two of them would have spent the BA's attention on facts the first
answer had already settled.

## What the packet is showing

- **The legality field names two anchors, not a topic.** A marker to resolve and
  the assertion the value feeds. Had neither existed, the question would have
  been illegal however sensible it sounded.
- **The destinations are named before the answer exists.** Three of them. The
  answer is written to all three at once — a rule without its acceptance line is
  a rule nobody tests.
- **The recommendation is a value, not a menu.** *Strictly more than 24 hours*,
  with the release behavior spelled out. "It depends on the clinic's policy"
  would have been the question asked a second time, and the BA would have had
  nothing to confirm or edit.
- **The basis separates what was said from what was inferred.** The cost concern
  is the specialist's own words; the 24 hours is common practice, and the packet
  says so. The BA is confirming an inference with its provenance visible, which
  is the only kind of confirmation that means anything.
- **The second clause was invented — and it is the one to watch.** *Not released
  for rebooking* is the mechanism that answers the stated concern; nobody
  requested it. That is legitimate drafting because it was recommended, basis
  stated, and confirmed. Written silently into the rule, it would have been the
  residual risk this framework names by name.

## The three questions that were not asked

| Drafted marker | Disposition |
|---|---|
| Slot duration | **Cited, not asked.** The glossary defines a Slot as the Specialist's service duration, and a one-step consequence of a stated fact is citable. Guard 1 forbids the question. |
| Which calendar providers sync at launch | **Stays a marker.** It is brief OQ-2, blocked on an unsigned provider contract. It rides into the spec as a named location and meets the gate as a waiver candidate. |
| Notification channel breadth | **Fenced, not asked.** It is another epic's ground; the spec's Out of Scope says so and names where it lives. |

Four questions asked, cap 7, no overflow, no Tier-1 supplement. The three above
are the shape of a well-run session: **the answerable was cited, the blocked was
marked, and the out-of-scope was fenced.**
