# Decision Log

The key product and technical decisions behind Kusuri, logged by day.

---

## 2026-11-02

**Defined the v1 scope.** Kusuri v1 covers medication reminders only. Skincare, refill tracking, as-needed doses and every-N-hours schedules are deliberately left out so v1 does one job well.

**Set the safety principles.** Kusuri only reminds people of what they entered. It never gives medical advice, never checks drug interactions, never says "take it now" after a missed dose, and never sells or shares data.

**Designed the reminder behaviour.** One grouped card per dose time, with Taken / Snooze / Skip per medication. An unanswered card escalates for an hour, then the dose is logged as Missed. Snoozing doesn't reset that hour, so a dose can't be postponed forever.

**Chose local-only data.** No accounts, servers or analytics in v1. All data stays on the user's device.

**Launched the repo.** Published the v1 spec as the README.

---

## 2026-11-03

**Moved the platform from a Chrome extension to a native macOS app.** The core promise is a reminder you can't miss by accident. A browser extension only works while Chrome is open, and only on web pages. A menu-bar app launches at login and floats above every app, including full-screen ones.

**Chose direct distribution through GitHub Releases.** Early builds are shared as a free `.app` download for the first group of testers. Apple Developer ID signing will be added ahead of a public launch. Until then, users approve the app once in System Settings → Privacy & Security, and the README walks them through it.

**Updated the repo to match.** Rewrote the README for macOS, updated the repo description and topics, and added a `.gitignore`.

---

## 2026-11-04

**Chose Swift and SwiftUI for the app.** ...

**Defined the core data model.** ...

**Designed the core screens.** Reminder card, batch update and compact full-screen view. The batch update opens automatically when the Mac wakes. See `docs/design/`.

---

## 2026-11-09

**Added the reminder escalation rules.** An unanswered card re-raises every 5 minutes for the first 30 minutes, then every 10 minutes, and the dose is logged as Missed at 60 minutes. Snoozing jumps to the next reminder time without moving that deadline. The rules live in `KusuriCore` with no UI code, so they can be tested on their own.

---

## 2026-11-10

**Documented the escalation rules.** Added `docs/escalation.md`, which explains the reminder timeline, how snoozing works and how missed doses are handled, so the behaviour is clear without reading the code.