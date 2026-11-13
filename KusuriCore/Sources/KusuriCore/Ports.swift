import Foundation

// MARK: - Ports
//
// The protocols KusuriCore depends on for anything outside itself: time,
// storage and the screen. The concrete versions (file storage, SwiftUI
// windows) live in the app and are passed in, so the core never imports
// them. Dependencies point inward only.

// MARK: Time

/// The current time. Passed in so rules can be tested with fixed dates.
public protocol Clock {
    func now() -> Date
}

/// The real clock, used by the app.
public struct SystemClock: Clock {
    public init() {}
    public func now() -> Date { Date() }
}

// MARK: Storage

/// Saves and loads the user's medications.
public protocol MedicationRepository {
    func allMedications() throws -> [Medication]
    func save(_ medication: Medication) throws
    func deleteMedication(id: UUID) throws
}

/// Saves and loads dose events, the honest log.
/// Kept separate from medications so each caller depends only on what it uses.
public protocol DoseRepository {
    /// Events scheduled in `start..<end`.
    func events(from start: Date, to end: Date) throws -> [DoseEvent]
    /// Every event still waiting for an answer.
    func pendingEvents() throws -> [DoseEvent]
    func save(_ events: [DoseEvent]) throws
}

/// Saves and loads the user's settings.
public protocol SettingsStore {
    func loadSettings() throws -> Settings
    func save(_ settings: Settings) throws
}

// MARK: Screen

/// One row on a reminder card: the dose and the medication it belongs to.
public struct ReminderItem: Equatable {
    public let event: DoseEvent
    public let medication: Medication

    public init(event: DoseEvent, medication: Medication) {
        self.event = event
        self.medication = medication
    }
}

/// Shows and hides reminders. Implemented by the app's UI layer.
/// The core decides when and what to show; the UI decides how.
public protocol ReminderPresenter {
    /// Raise the grouped card for one time slot.
    func showReminder(_ items: [ReminderItem])
    /// Take down a card once every dose on it is answered or missed.
    func hideReminder(scheduledAt: Date)
    /// Show doses that need logging, e.g. after the Mac wakes.
    func showBatchUpdate(_ items: [ReminderItem])
}
