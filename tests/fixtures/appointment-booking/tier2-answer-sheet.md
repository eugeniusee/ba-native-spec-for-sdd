# Scripted Tier-2 answer sheet — feature 004-appointment-booking · 2026-07-16

The BA's side of the Tier-2 gap-filling session, pre-recorded. This file is the
**machine input** to `/ba-run tier2 004-appointment-booking`: every GQ the
framework may legally ask about this feature has its answer here, so the run is
reproducible without improvisation. `revisions/spec-r5.md` is the expected
output of consuming it.

Cap: 7 (D7, default). Four questions were asked; three of the drafted markers
resolved without one. Ordering is impact-first (elicitation §5.4).

---

## GQ1 — the free-cancellation boundary

```
GQ1 of 7 — [legality: resolves marker BR-002; unresolved → CC-G-03 fail;
            the value feeds CC-BR-01 (threshold required)]
           [destinations: BR-002 · US2 acceptance · FR-cancellation reference]
```

**Answer — confirms the recommendation.** Free cancellation strictly more than
24 hours before `start_time`. Inside 24 hours, cancellation is allowed but the
Slot is NOT released for rebooking.

*Lands:* BR-002 · the US2 acceptance line `Cancellation inside 24h of start_time
keeps the Slot unavailable for rebooking (BR-002)` · FR-006 and FR-008 gain
their BR-002 reference. Two queued data-table questions about Slot release die
with this answer.

## GQ2 — the Specialist-cancel permission

```
GQ2 of 7 — [legality: CC-XA-01 would fail — (Specialist × Appointment × cancel)
            has no policy row] [destinations: roles-permissions.md (governance
            routing) · US3 · FR-009]
```

**Answer — approves the governance edit.** A Specialist may cancel an
Appointment on their own Availability; the Client is notified. Routed as a
proposed edit to `roles-permissions.md`, not written by the spec.

*Note:* in the corpus timeline this routing lands **after** gate run 2 names the
gap (2026-07-17), which is why `revisions/roles-permissions-r5.md` still lacks
the row. Kept here because the answer is the BA's, and the fixture records the
answer where it was given.

## GQ3 — the simultaneous-booking cap (brief OQ-1)

```
GQ3 of 7 — [legality: resolves brief §6 OQ-1; CC-XA-06 ⚑ requires it resolved
            or waived] [destinations: BR-001 · FR-005 · E-03 §6 write-back]
```

**Answer — confirms the recommendation.** A Client may hold at most **3**
Appointments in status "Booked" at the same time.

*Lands:* BR-001 · FR-005 · brief §6 OQ-1 → `Answered — 2026-07-16 → spec 004
BR-001 (cap: 3)`.

## GQ4 — the Hold window

```
GQ4 of 7 — [legality: resolves marker on the Hold duration; feeds CC-DA-02
            (fields table) and CC-FL-03 (E1 row)]
           [destinations: FR-003 · FR-004 · §4 E1 · §7 Hold.expires_at]
```

**Answer — confirms the recommendation.** Five minutes from selection.

*Lands:* FR-003 · FR-004 · the E1 error row · `Hold.expires_at`.

---

## Not asked, and why

| Drafted marker | Disposition |
|---|---|
| Slot duration | Cited, not asked — glossary defines Slot as the Specialist's service duration; a one-step consequence is citable (Guard 1). Drafted as BR-003. |
| Which calendar providers sync at launch | **Stays a marker.** Brief OQ-2, blocked on R1 (provider contract unsigned). Carried into the spec as the named location the gate later waives as W-004-01. |
| Notification channel breadth | Out of this epic — roadmap E-05 Notification Delivery. Fenced in §9 Out of Scope rather than asked. |

Question count: **4 of 7** — no overflow, so no Tier-1 supplement signal.
