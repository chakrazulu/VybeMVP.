import CoreData

@objc(JournalEntry)
public class JournalEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var timestamp: Date
    @NSManaged public var focusNumber: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var moodEmoji: String?  // Store the raw emoji
}

extension JournalEntry {
    enum Mood: String, CaseIterable {
        case happy = "😊"
        case sad = "😢"
        case angry = "😠"
        case peaceful = "😌"
        case anxious = "😰"
        case excited = "🤩"
        
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
    
    var mood: Mood? {
        get { Mood(rawValue: moodEmoji ?? "") }
        set { moodEmoji = newValue?.rawValue }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }
} 