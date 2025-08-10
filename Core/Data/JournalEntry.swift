/**
 * Filename: JournalEntry.swift
 *
 * Purpose: Defines the Core Data model for journal entries in the application.
 *
 * This file contains the JournalEntry class which represents user journal entries
 * stored in Core Data. Each entry includes content, metadata (timestamp, location),
 * and associated focus number and mood information.
 *
 * Design pattern: Core Data NSManagedObject subclass with extensions
 * Dependencies: CoreData
 */

import CoreData

/**
 * Core Data entity representing a user's journal entry
 *
 * This class defines the structure and behavior of journal entries in the app.
 * Each entry contains the user's written content along with metadata such as
 * timestamp, location, focus number, and mood.
 *
 * The class is designed to work with Core Data for persistence and includes
 * convenience methods for working with the mood property.
 */
@objc(JournalEntry)
public class JournalEntry: NSManagedObject {
    /// Unique identifier for the journal entry
    @NSManaged public var id: UUID

    /// Optional title of the journal entry
    @NSManaged public var title: String?

    /// Main text content of the journal entry
    @NSManaged public var content: String?

    /// Date and time when the entry was created
    @NSManaged public var timestamp: Date

    /// The user's focus number (1-9) at the time of creating the entry
    @NSManaged public var focusNumber: Int16

    /// Geographical latitude where the entry was created
    @NSManaged public var latitude: Double

    /// Geographical longitude where the entry was created
    @NSManaged public var longitude: Double

    /// Emoji string representing the mood (stored as raw value)
    @NSManaged public var moodEmoji: String?
}

/**
 * Extension providing additional functionality for JournalEntry
 */
extension JournalEntry {
    /**
     * Enumeration of possible mood states for journal entries
     *
     * This enum has been deprecated in favor of the JournalMood enum
     * in Core/Models/JournalMood.swift but is maintained here for
     * backward compatibility with existing data.
     *
     * @deprecated Use JournalMood from Core/Models/JournalMood.swift instead
     */
    enum Mood: String, CaseIterable {
        case happy = "😊"
        case sad = "😢"
        case angry = "😠"
        case peaceful = "😌"
        case anxious = "😰"
        case excited = "🤩"

        /// Human-readable description of the mood
        var description: String {
            switch self {
            case .happy: return "Happy"
            case .sad: return "Sad"
            case .angry: return "Angry"
            case .peaceful: return "Peaceful"
            case .anxious: return "Anxious"
            case .excited: return "Excited"
            }
        }
    }

    /**
     * Computed property for accessing the mood as an enum value
     *
     * This property provides a type-safe way to get and set the mood
     * while the underlying storage uses the raw emoji string.
     */
    var mood: Mood? {
        get { Mood(rawValue: moodEmoji ?? "") }
        set { moodEmoji = newValue?.rawValue }
    }

    /**
     * Creates a fetch request for JournalEntry entities
     *
     * @return NSFetchRequest configured for JournalEntry
     */
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }
}
