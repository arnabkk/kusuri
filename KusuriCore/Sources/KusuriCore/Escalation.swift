import Foundation

/// The reminder timing rules for an unanswered dose.
///
/// - Minutes 0 to 30: the card re-raises every 5 minutes.
/// - Minutes 30 to 60: every 10 minutes.
/// - Minute 60: the dose becomes Missed.
///
/// The window is fixed from `scheduledAt`. Snoozing hides the card until the
/// next reminder but never moves the deadline, so a dose can't be snoozed forever.
public enum Escalation {
    /// How long a dose stays answerable on the card.
    public static let window: TimeInterval = 60 * 60

    /// Minutes after the due time at which the card is raised.
    /// [0, 5, 10, 15, 20, 25, 30, 40, 50]
    public static let reminderOffsets: [Int] =
        Array(stride(from: 0, to: 30, by: 5)) + Array(stride(from: 30, to: 60, by: 10))

    /// Every moment the card should be raised for a dose due at `scheduledAt`.
    public static func reminderTimes(for scheduledAt: Date) -> [Date] {
        reminderOffsets.map { scheduledAt.addingTimeInterval(TimeInterval($0 * 60)) }
    }

    /// When an unanswered dose becomes Missed.
    public static func missedAt(_ scheduledAt: Date) -> Date {
        scheduledAt.addingTimeInterval(window)
    }

    /// The next time the card should be raised after `now`, or `nil` if the window is over.
    /// Also used for snoozing: a snoozed card comes back at the next reminder time.
    public static func nextReminder(after now: Date, scheduledAt: Date) -> Date? {
        reminderTimes(for: scheduledAt).first { $0 > now }
    }

    /// Whether a pending dose has run out of time.
    public static func isMissed(_ event: DoseEvent, at now: Date) -> Bool {
        event.status == .pending && now >= missedAt(event.scheduledAt)
    }

    /// Marks every pending dose whose window has ended as Missed.
    /// Returns the events that changed, ready for the batch update.
    @discardableResult
    public static func markMissed(_ events: inout [DoseEvent], at now: Date) -> [DoseEvent] {
        var changed: [DoseEvent] = []
        for index in events.indices where isMissed(events[index], at: now) {
            events[index].status = .missed
            changed.append(events[index])
        }
        return changed
    }
}