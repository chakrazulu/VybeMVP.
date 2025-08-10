import Foundation
import CoreData

extension JournalEntry {
    var mood: JournalMood? {
        get { moodEmoji.flatMap { JournalMood(rawValue: $0) } }
        set { moodEmoji = newValue?.rawValue }
    }
}
