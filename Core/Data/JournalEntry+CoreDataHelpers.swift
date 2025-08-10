import Foundation
import CoreData

extension JournalEntry {
    var wrappedTitle: String {
        title ?? "Untitled"
    }

    var wrappedContent: String {
        content ?? ""
    }

    var wrappedTimestamp: Date {
        timestamp ?? Date()
    }

    var wrappedMoodEmoji: String {
        moodEmoji ?? ""
    }

    static func create(in context: NSManagedObjectContext,
                      title: String,
                      content: String,
                      focusNumber: Int16,
                      moodEmoji: String? = nil) -> JournalEntry {
        let entry = JournalEntry(context: context)
        entry.id = UUID()
        entry.title = title
        entry.content = content
        entry.focusNumber = focusNumber
        entry.moodEmoji = moodEmoji
        entry.timestamp = Date()
        return entry
    }
}
