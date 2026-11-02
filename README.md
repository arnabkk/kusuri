# Kusuri 💊

> A medication reminder you can't ignore by accident.

**Status:** 🚧 Pre-development. The v1 spec is done and there's no code yet. I'm building this in public, a little every day.

Kusuri (薬, Japanese for "medicine") is a Chrome extension that puts a medication reminder on your screen and keeps it there until you answer it: **Taken**, **Snooze** or **Skip**. It also keeps an honest log of what was taken, snoozed, skipped or missed.

---

## Why

My grandmother had to manage 12 doses a day, all at different times. She doesn't use electronic devices, so Kusuri isn't for her. It's for people with schedules like hers.

- **The problem:** ordinary notifications are easy to swipe away without thinking, and then the dose is forgotten. Most existing apps assume one or two pills a day, not a dozen.
- **Who it's for:** someone taking several daily medications at different times who spends a lot of the day at a computer.

## Safety principles

Kusuri only reminds you of what *you* entered. It never tells you what to take.

- **No medical advice.** No dosing advice, no drug-interaction checks, no missed-dose guidance.
- **Never "take it now."** A late or missed reminder only asks for a status, and it always shows: *"If you're unsure what to do about a missed dose, check your medication's instructions or ask your pharmacist."*
- **User-entered instructions only.** Things like "with food" or "before food" are chosen or typed by you. Kusuri never generates them.
- **Honest log.** Skip is visually secondary, but Kusuri never guilt-trips you for it or blocks it. A false "Taken" is worse than an honest "Skipped."
- **No data sold or shared.** Ever.
- **Clear limits.** Kusuri is a reminder tool, not a medical device. It can't remind you while Chrome is closed or the computer is off.

## How v1 works

### The reminder card

Each dose time gets **one grouped card**, and it stays on screen until every medication on it has a status.

Each medication row shows:
- Name and dose
- Scheduled time
- A graphic picked from a set of shapes and colours (round white tablet, blue capsule, tube of cream). You pick one; you don't upload a photo.
- Instructions: with food, after food, before food, or your own text

| Action | Look | What happens |
| --- | --- | --- |
| **Taken** | Primary button | Logged as taken, with the time |
| **Snooze** | Secondary button | The card hides, then follows the same escalation as an unanswered reminder |
| **Skip** | Small, grey, never the default | Logged as skipped, with an optional "Why?" (side effects, doctor's advice, ran out, other) |

Time slots with several medications also get a **Mark all taken** button, and each row can still be answered on its own.

### Escalation when nothing is pressed

The card stays on screen the whole time. Each repeat brings it back to the front, flashes it and plays a sound.

| Time since due | Behaviour |
| --- | --- |
| 0 min | Card appears |
| 0–30 min | Repeats every 5 minutes |
| 30–60 min | Repeats every 10 minutes |
| 60 min | Automatically marked **Missed** and moved to the batch update |

Snoozing doesn't reset the clock, so a dose can't be snoozed forever.

### Scheduling and time zones

- **Schedule types:** fixed times each day (e.g. 8:00, 13:00, 21:00), or specific weekdays (e.g. Mon/Wed/Fri at 9:00).
- **Time zone stored by name** (`America/Toronto`), never as a UTC offset. It's pre-filled from your computer at setup and can be changed in Settings.
- **Zone changes:** Kusuri asks, e.g. *"You're now in Tokyo. Keep Toronto times or switch?"*
- **Daylight saving:** reminders follow wall-clock time, so 8:00 stays 8:00 all year. If a time doesn't exist (spring forward), it fires at the next valid time. If a time happens twice (fall back), it fires once.

### Late, missed and quiet behaviour

- **Computer asleep or Chrome closed:** when you come back, you get a late reminder for each dose that passed. If several are waiting, a single notice opens the **batch update**.
- **Batch update:** a list of unlogged and Missed doses, each with *Taken earlier / Skipped / Missed*. It only records a status and never suggests taking a dose now.
- **Screen locked:** detected with `chrome.idle`. Reminders are held and shown when you return.
- **Quiet behaviour:** Kusuri controls whether a sound plays and how loud it is (only system volume is out of its hands). There are do-not-disturb hours, and a smaller, quieter card while a page is in full screen.

## Data and privacy

All data stays on your computer in `chrome.storage.local`. There are **no accounts, no servers and no analytics** in v1.

- **First run:** a setup screen, not an account. It asks for your time zone, medications and schedules.
- **What's stored:** medications, schedules, dose events (taken, snoozed, skipped with reason, missed) and settings.
- **Permissions:** `alarms`, `storage`, `idle`, plus access to all sites so the card can appear on any page.
- **Chrome Web Store:** a privacy policy is published, and health information is declared in the Privacy tab. Both say the same thing: your data never leaves your device.

## Out of scope for v1

- Skincare reminders
- Every-N-hours schedules
- As-needed medications (left out on purpose, because Kusuri is about consistency)
- Refill tracking and low-supply warnings
- Accounts, cloud sync, or storing anyone else's data
- Caregiver alerts
- Mobile apps (iOS with AlarmKit and Android come later)

## Open questions

- [ ] How long is one snooze: 5, 10 or 15 minutes?
- [ ] If a later dose of the same medication comes due while an earlier one is unanswered, does the earlier one become Missed straight away?
- [ ] Stack: plain JavaScript, TypeScript, or a framework like [WXT](https://wxt.dev)?
- [ ] Should the optional floating dock (Document Picture-in-Picture) be in v1, or later?
- [ ] Deadline for an Unlisted release on the Chrome Web Store
- [ ] How to find the first 10–30 testers, and what to ask them after two weeks

## Roadmap

- [x] v1 spec
- [ ] Settle open questions and pick a stack
- [ ] Extension scaffold (Manifest V3)
- [ ] Setup screen and local storage
- [ ] Scheduling engine (time zones, DST, alarms)
- [ ] Reminder card and escalation
- [ ] Batch update and dose log
- [ ] Settings (quiet hours, sound, time zone)
- [ ] Unlisted release on the Chrome Web Store
- [ ] First testers

---

*Kusuri is a reminder tool, not a medical device. Always follow your doctor's or pharmacist's instructions.*
