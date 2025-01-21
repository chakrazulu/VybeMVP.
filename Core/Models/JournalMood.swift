import Foundation

public enum JournalMood: String, CaseIterable {
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
