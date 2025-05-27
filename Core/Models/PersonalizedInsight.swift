import Foundation

/**
 * PersonalizedInsight - Represents a personalized spiritual insight for the user
 * 
 * This model encapsulates all the information needed to display and manage
 * a user's spiritual insight, including metadata and archetypal context.
 */
struct PersonalizedInsight {
    let id = UUID()
    let title: String
    let content: String
    let preview: String
    let timestamp: Date
    let tags: [String]
    let focusNumber: Int?
    let archetypeContext: SimpleArchetypeContext?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: timestamp)
    }
}

/**
 * SimpleArchetypeContext - Lightweight spiritual archetype information for insights
 * 
 * Provides basic archetypal framework for insight context.
 * Uses string representations for simplicity in insight display.
 */
struct SimpleArchetypeContext {
    let zodiacSign: String
    let element: String
    let primaryPlanet: String
    let lifePathNumber: Int
} 