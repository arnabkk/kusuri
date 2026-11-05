# Data Model

The core types Kusuri v1 stores. Everything lives on the user's Mac. Nothing is sent anywhere.

There are four types:

| Type | What it represents |
|---|---|
| `Medication` | Something the user takes, and when |
| `Schedule` | The times and days a medication is due |
| `DoseEvent` | One scheduled dose and what happened to it |
| `Settings` | App-wide preferences |

---

## Medication

```swift
struct Medication: Identifiable, Codable {
    let id: UUID
    var name: String               // "Metformin"
    var dose: String               // "500 mg", "1 tablet", "2 puffs" (free text, user-entered)
    var appearance: Appearance     // graphic shown on the card
    var instruction: Instruction   // food instruction shown on the card
    var schedule: Schedule
    var isActive: Bool             // paused medications keep their history
    let createdAt: Date
}

struct Appearance: Codable {
    var shape: PillShape
    var color: PillColor
}

enum PillShape: String, Codable, CaseIterable {
    case roundTablet, ovalTablet, capsule, liquid, cream, inhaler, drops, other
}

enum PillColor: String, Codable, CaseIterable {
    case white, yellow, orange, red, pink, purple, blue, green, brown, black
}

enum Instruction: Codable {
    case none
    case withFood
    case beforeFood
    case afterFood
    case custom(String)            // user's own text, never generated
}
```

---

## Schedule

Times are **wall-clock times** in the user's stored time zone, so 8:00 stays 8:00 all year.

```swift
struct Schedule: Codable {
    var times: [TimeOfDay]         // e.g. 8:00, 13:00, 21:00
    var days: DayRule
}

struct TimeOfDay: Codable, Hashable, Comparable {
    var hour: Int                  // 0–23
    var minute: Int                // 0–59
}

enum DayRule: Codable {
    case everyDay
    case weekdays(Set<Weekday>)    // e.g. [.monday, .wednesday, .friday]
}

enum Weekday: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}
```

Not supported in v1: every-N-hours and as-needed schedules.

---

## DoseEvent

One record per medication per scheduled time. This is the honest log.

```swift
struct DoseEvent: Identifiable, Codable {
    let id: UUID
    let medicationID: UUID
    let scheduledAt: Date          // the exact moment it was due
    var status: DoseStatus
    var answeredAt: Date?          // when the user tapped a button
    var snoozeCount: Int           // for the log only; snoozing never extends the window
    var skipReason: SkipReason?    // only when status == .skipped
    var loggedLate: Bool           // true if answered later from the batch update
}

enum DoseStatus: String, Codable {
    case pending                   // card is showing or waiting to show
    case taken
    case skipped
    case missed                    // no answer within 60 minutes
}

enum SkipReason: Codable {
    case sideEffects
    case doctorsAdvice
    case ranOut
    case other(String)
}
```

---

## Settings

```swift
struct Settings: Codable {
    var timeZoneID: String         // stored by name, e.g. "America/Toronto", never as an offset
    var soundEnabled: Bool
    var soundVolume: Double        // 0.0–1.0, Kusuri's own volume
    var quietHours: QuietHours?    // do-not-disturb window
    var launchAtLogin: Bool        // on by default
    var snoozeMinutes: Int         // open question: 5, 10 or 15
}

struct QuietHours: Codable {
    var start: TimeOfDay
    var end: TimeOfDay
}
```

---

## Rules the model enforces

- **One card per time slot.** All `DoseEvent`s with the same `scheduledAt` are shown together on one card.
- **The 60-minute window is fixed.** It runs from `scheduledAt`. Snoozing hides the card but doesn't move the deadline. At 60 minutes, any `pending` event becomes `missed`.
- **Daylight saving.** A time that doesn't exist (spring forward) fires at the next valid minute. A time that happens twice (fall back) fires once.
- **Time zone changes.** If the Mac's zone differs from `timeZoneID`, Kusuri asks before changing anything.
- **History is kept.** Deleting or pausing a medication never deletes its past `DoseEvent`s.
- **No advice fields.** The model has no place for dosing guidance, interactions or recommendations, by design.