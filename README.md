# Kusuri

**A medication reminder you can't ignore by accident.**

Kusuri is a macOS menu-bar app. At each dose time it shows a small card that floats above every app and stays on screen until you tap **Taken**, **Snooze** or **Skip**.

> **Status:** Early development

---

## Why it exists

My grandmother had to manage 12 doses a day at different times. She doesn't use electronic devices, so Kusuri isn't for her, but it's built for people with schedules like hers.

**Problem.** Ordinary notifications are easy to swipe away without thinking, so the dose gets forgotten. Existing apps assume one or two pills a day, not a dozen.

**Target user.** Someone on several daily medications at different times who spends much of the day at a Mac.

**v1 in one sentence.** A reminder you can't ignore by accident, with an honest log of what was taken, snoozed, skipped or missed.

---

## Safety principles

Kusuri only reminds people of what they entered. It never tells them what to take.

- **No medical advice.** No dosing advice, no drug-interaction checks, and no missed-dose guidance.
- **Never "take it now."** A late or missed reminder only asks for a status. It always shows: *"If you're unsure what to do about a missed dose, check your medication's instructions or ask your pharmacist."*
- **User-entered instructions only.** "With food", "before food" and similar are chosen or typed by the user, never generated.
- **Honest log.** Skip is visually secondary but never guilt-tripped or blocked. A false "Taken" is worse than an honest "Skipped."
- **No data sold or shared.** Ever.
- **Clear limits.** At setup and in Settings: Kusuri is a reminder tool, not a medical device, and it can't remind you while your Mac is asleep or off, or if Kusuri has been quit.

---

## The reminder card

Each dose time gets one grouped card that floats above all apps (including full-screen ones) and stays on screen until every medication on it has a status.

**Each medication row shows**

- Name and dose
- Scheduled time
- A graphic picked from a set of shapes and colours (round white tablet, blue capsule, tube for cream), not an uploaded photo
- Instructions: with food, after food, before food, or the user's own text

**Actions per medication**

| Action | Look | What happens |
|---|---|---|
| Taken | Primary button | Logged as taken with the time |
| Snooze | Secondary button | Card hides, then follows the same escalation as an unanswered reminder |
| Skip | Small, grey, never the default | Logged as skipped, then an optional "Why?" |

"Mark all taken" sits at the bottom of the card for time slots with several medications. Each row can still be answered on its own.

**Skip reasons (optional):** side effects, doctor's advice, ran out, other (free text).

**Escalation when nothing is pressed.** The card stays on screen the whole time. Each repeat re-raises it, flashes it and plays a sound.

1. Due time: card appears.
2. Minutes 0 to 30: repeat every 5 minutes.
3. Minutes 30 to 60: repeat every 10 minutes.
4. Minute 60: the dose is marked **Missed** automatically and moves to the batch update.

Snooze follows the same hour: snoozing doesn't reset the clock, so a dose can't be snoozed forever.

---

## Scheduling and time zones

v1 supports fixed times and specific weekdays, tied to a named time zone.

**Schedule types**

- Fixed times each day (e.g. 8:00, 13:00, 21:00)
- Specific weekdays (e.g. Mon, Wed, Fri at 9:00)

Not in v1: every N hours, and as-needed. As-needed is left out on purpose, because Kusuri is about consistency.

**Time zones**

- The zone is stored by name (`America/Toronto`), never as a UTC offset.
- At setup, the zone is pre-filled from the Mac's settings. The user can change it in Settings.
- When the Mac's zone changes, Kusuri asks: "You're now in Tokyo. Keep Toronto times or switch?"

**Daylight saving time.** Reminders follow wall-clock time in the stored zone, so 8:00 stays 8:00 all year.

- Spring forward: a time that doesn't exist (e.g. 2:30) fires at 3:00.
- Fall back: a time that happens twice (e.g. 1:30) fires once.

---

## Late, missed and quiet behaviour

Doses that weren't answered in time are collected into one batch update, where the user logs what happened.

**Mac asleep or Kusuri not running.** When the user comes back (e.g. two hours late), Kusuri shows a late reminder for each dose that passed. If several are waiting, one notice says so and opens the batch update.

**Batch update.** A list of unlogged and Missed doses, each with Taken earlier / Skipped / Missed. It only records a status. It never suggests taking a dose now, and it always shows the pharmacist line from the safety principles.

**Screen locked or user away.** While the screen is locked, reminders are held and shown on unlock, then follow the late flow above.

**Quiet behaviour**

- Kusuri controls whether a sound plays and how loud it is. The system volume is the only part it can't control.
- Do-not-disturb hours in Settings.
- When an app is in full screen (a presentation or video), show a smaller, quieter version of the card.

---

## Data and privacy

All data stays on the user's Mac. There are no accounts, servers or analytics in v1.

- **Setup screen, not an account.** First run asks for time zone, medications and schedules.
- **What's stored:** medications, schedules, dose events (taken, snoozed, skipped with reason, missed) and settings.
- **Launch at login:** on by default, so reminders work without the user remembering to open Kusuri. Can be turned off in Settings.

---

## Platform and distribution

- **Platform:** macOS, as a menu-bar app (no Dock icon).
- **Planned stack:** Swift + SwiftUI, with AppKit for the floating always-on-top card.
- **Distribution:** a free `.app` download from this repo's Releases page. The app isn't signed with a paid Apple Developer ID yet, so macOS asks you to approve it once.

### Installing (once releases are available)

1. Download `Kusuri.zip` from Releases and unzip it.
2. Drag **Kusuri.app** into your **Applications** folder.
3. Open it. macOS will say it can't be opened. Click **Done**.
4. Go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** next to Kusuri.
5. Confirm with your password. You only need to do this once.

---

## Out of scope for v1

- Skincare reminders
- Every-N-hours schedules
- As-needed medications (left out on purpose)
- Refill tracking and low-supply warnings
- Accounts, cloud sync, or storing anyone else's data
- Caregiver alerts
- Windows and Linux
- Mobile apps (iOS with AlarmKit and Android come later)

---

## Open questions

- [ ] How long is one snooze (5, 10 or 15 minutes)?
- [ ] If a later dose of the same medication comes due while an earlier one is unanswered, does the earlier one become Missed straight away?
- [ ] Minimum supported macOS version
- [ ] Target date for the first tester release on GitHub
- [ ] How to find the first 10 to 30 testers, and what to ask them after two weeks