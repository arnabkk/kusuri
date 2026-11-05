import Foundation

// MARK: - Medication

/// Something the user takes, and when.
public struct Medication: Identifiable, Codable, Equatable {
    public let id: UUID
    public var name: String
    /// Free text entered by the user, e.g. "500 mg · 1 tablet".
    public var dose: String
    public var appearance: Appearance
    public var instruction: Instruction
    public var schedule: Schedule
    /// Paused medications keep their history.
    public var isActive: Bool
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        dose: String,
        appearance: Appearance,
        instruction: Instruction = .none,
        schedule: Schedule,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.dose = dose
        self.appearance = appearance
        self.instruction = instruction
        self.schedule = schedule
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

public struct Appearance: Codable, Equatable {
    public var shape: PillShape
    public var color: PillColor

    public init(shape: PillShape, color: PillColor) {
        self.shape = shape
        self.color = color
    }
}

public enum PillShape: String, Codable, CaseIterable {
    case roundTablet, ovalTablet, capsule, liquid, cream, inhaler, drops, other
}

public enum PillColor: String, Codable, CaseIterable {
    case white, yellow, orange, red, pink, purple, blue, green, brown, black
}

/// Food instruction shown on the card. Always chosen or typed by the user, never generated.
public enum Instruction: Codable, Equatable {
    case none
    case withFood
    case beforeFood
    case afterFood
    case custom(String)
}

// MARK: - Schedule

/// When a medication is due. Times are wall-clock times in the user's stored time zone.
public struct Schedule: Codable, Equatable {
    public var times: [TimeOfDay]
    public var days: DayRule

    public init(times: [TimeOfDay], days: DayRule = .everyDay) {
        self.times = times.sorted()
        self.days = days
    }
}

public struct TimeOfDay: Codable, Hashable, Comparable {
    public var hour: Int    // 0–23
    public var minute: Int  // 0–59

    public init(hour: Int, minute: Int = 0) {
        precondition((0...23).contains(hour) && (0...59).contains(minute), "Invalid time of day")
        self.hour = hour
        self.minute = minute
    }

    public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        (lhs.hour, lhs.minute) < (rhs.hour, rhs.minute)
    }
}

public enum DayRule: Codable, Equatable {
    case everyDay
    case weekdays(Set<Weekday>)
}

/// Raw values match Calendar's weekday numbering (Sunday = 1).
public enum Weekday: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

// MARK: - Dose events

/// One medication at one scheduled time, and what happened to it. This is the honest log.
public struct DoseEvent: Identifiable, Codable, Equatable {
    public let id: UUID
    public let medicationID: UUID
    /// The exact moment the dose was due.
    public let scheduledAt: Date
    public var status: DoseStatus
    /// When the user answered.
    public var answeredAt: Date?
    /// Recorded for the log only. Snoozing never extends the reminder window.
    public var snoozeCount: Int
    /// Only set when `status == .skipped`.
    public var skipReason: SkipReason?
    /// True if answered later from the batch update.
    public var loggedLate: Bool

    public init(
        id: UUID = UUID(),
        medicationID: UUID,
        scheduledAt: Date,
        status: DoseStatus = .pending,
        answeredAt: Date? = nil,
        snoozeCount: Int = 0,
        skipReason: SkipReason? = nil,
        loggedLate: Bool = false
    ) {
        self.id = id
        self.medicationID = medicationID
        self.scheduledAt = scheduledAt
        self.status = status
        self.answeredAt = answeredAt
        self.snoozeCount = snoozeCount
        self.skipReason = skipReason
        self.loggedLate = loggedLate
    }
}

public enum DoseStatus: String, Codable {
    case pending
    case taken
    case skipped
    case missed
}

public enum SkipReason: Codable, Equatable {
    case sideEffects
    case doctorsAdvice
    case ranOut
    case other(String)
}

// MARK: - Settings

public struct Settings: Codable, Equatable {
    /// Stored by name, e.g. "America/Toronto", never as a UTC offset.
    public var timeZoneID: String
    public var soundEnabled: Bool
    /// Kusuri's own volume, 0.0–1.0.
    public var soundVolume: Double
    public var quietHours: QuietHours?
    public var launchAtLogin: Bool
    public var snoozeMinutes: Int

    public init(
        timeZoneID: String = TimeZone.current.identifier,
        soundEnabled: Bool = true,
        soundVolume: Double = 0.7,
        quietHours: QuietHours? = nil,
        launchAtLogin: Bool = true,
        snoozeMinutes: Int = 5
    ) {
        self.timeZoneID = timeZoneID
        self.soundEnabled = soundEnabled
        self.soundVolume = soundVolume
        self.quietHours = quietHours
        self.launchAtLogin = launchAtLogin
        self.snoozeMinutes = snoozeMinutes
    }
}

public struct QuietHours: Codable, Equatable {
    public var start: TimeOfDay
    public var end: TimeOfDay

    public init(start: TimeOfDay, end: TimeOfDay) {
        self.start = start
        self.end = end
    }
}
