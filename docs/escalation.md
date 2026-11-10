# Reminder Escalation

How Kusuri handles a dose that hasn't been answered yet. The rules live in `KusuriCore/Sources/KusuriCore/Escalation.swift`.

## The one-hour window

Every dose gets one hour, counted from its scheduled time. During that hour the reminder card keeps coming back until the user taps **Taken**, **Snooze** or **Skip**.

| Minutes after due time | What happens |
|---|---|
| 0 | Card appears |
| 5, 10, 15, 20, 25, 30 | Card re-raises every 5 minutes |
| 40, 50 | Card re-raises every 10 minutes |
| 60 | Dose is logged as **Missed** |

Each time the card re-raises, it comes to the front, flashes and plays a sound.

## Snoozing

Snooze hides the card until the next reminder time in the table. It never moves the 60-minute deadline.

- Snoozed at minute 7 → card returns at minute 10.
- Snoozed at minute 33 → card returns at minute 40.
- Snoozed at minute 52 → no reminders left; the dose becomes Missed at minute 60.

This means a dose can't be put off forever by snoozing.

## Missed doses

When the hour runs out, every dose still pending is marked **Missed**. Missed doses are gathered into the batch update screen, so the user can review them in one place.

Kusuri never suggests taking a missed dose late. It only records what happened. For what to do about a missed dose, users should check their medication's instructions or ask a pharmacist.

## Grouped cards

Medications due at the same time share one card. Each medication on the card follows its own window, so answering one doesn't affect the others.