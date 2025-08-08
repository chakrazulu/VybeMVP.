import Foundation
import SwiftData

/**
 * PersonalizedInsightTemplate - SwiftData Model for KASPER MLX Template System
 * 
 * Represents personalized insight templates from personalized_insight_templates.json
 * Used by KASPER MLX to generate contextually appropriate spiritual guidance
 * based on user's Life Path, spiritual mode, and preferred tone
 * 
 * This enables KASPER MLX to provide tailored insights that match the user's:
 * - Life Path number (1-9, 11, 22, 33)
 * - Current spiritual mode (Manifestation, Growth, Connection, etc.)
 * - Preferred communication tone (Direct, Gentle, Poetic, etc.)
 * - Relevant spiritual themes
 */
@Model
final class PersonalizedInsightTemplate {
    // Primary identifier
    @Attribute(.unique) var templateId: String
    
    // Template categorization
    var lifePath: Int                    // Life Path number (1-9, 11, 22, 33)
    var spiritualMode: String            // Manifestation, Growth, Connection, Healing, etc.
    var tone: String                     // Direct, Gentle, Poetic, Empowering, etc.
    var themes: [String]                 // Action, Leadership, Harmony, Creativity, etc.
    
    // Template content
    var templateText: String             // The insight template with potential placeholders
    
    // KASPER MLX metadata
    var usageCount: Int = 0              // How often this template has been used
    var effectivenessScore: Double = 0.0 // User feedback-based effectiveness (0.0-1.0)
    var lastUsed: Date?                  // When this template was last selected
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        templateId: String,
        lifePath: Int,
        spiritualMode: String,
        tone: String,
        themes: [String],
        templateText: String
    ) {
        self.templateId = templateId
        self.lifePath = lifePath
        self.spiritualMode = spiritualMode
        self.tone = tone
        self.themes = themes
        self.templateText = templateText
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Convenience Methods

extension PersonalizedInsightTemplate {
    /// Checks if this is a master number Life Path (11, 22, 33)
    var isMasterNumberLifePath: Bool {
        [11, 22, 33].contains(lifePath)
    }
    
    /// Returns themes as a comma-separated string
    var themeString: String {
        themes.joined(separator: ", ")
    }
    
    /// Updates usage statistics when template is selected by KASPER MLX
    func recordUsage(withEffectivenessScore score: Double? = nil) {
        usageCount += 1
        lastUsed = Date()
        
        if let score = score {
            // Update effectiveness score using weighted average
            effectivenessScore = (effectivenessScore * Double(usageCount - 1) + score) / Double(usageCount)
        }
        
        updatedAt = Date()
    }
    
    /// Checks if template matches user's current spiritual context
    func matches(lifePath: Int, spiritualMode: String? = nil, tone: String? = nil, themes: [String]? = nil) -> Bool {
        // Life Path must match
        guard self.lifePath == lifePath else { return false }
        
        // Optional filters
        if let spiritualMode = spiritualMode, self.spiritualMode.lowercased() != spiritualMode.lowercased() {
            return false
        }
        
        if let tone = tone, self.tone.lowercased() != tone.lowercased() {
            return false
        }
        
        if let themes = themes {
            let hasMatchingTheme = themes.contains { theme in
                self.themes.contains { $0.lowercased() == theme.lowercased() }
            }
            if !hasMatchingTheme {
                return false
            }
        }
        
        return true
    }
}

// MARK: - Spiritual Modes

/// Available spiritual modes for personalized insights
enum SpiritualMode: String, CaseIterable, Codable {
    case manifestation = "Manifestation"
    case growth = "Growth"
    case connection = "Connection"
    case healing = "Healing"
    case reflection = "Reflection"
    case expression = "Expression"
    case intuition = "Intuition"
    
    var description: String {
        switch self {
        case .manifestation:
            return "Focused on bringing dreams into reality"
        case .growth:
            return "Expanding consciousness and capabilities"
        case .connection:
            return "Building relationships and community"
        case .healing:
            return "Restoration and wholeness"
        case .reflection:
            return "Inner contemplation and wisdom"
        case .expression:
            return "Creative and authentic self-expression"
        case .intuition:
            return "Accessing inner knowing and psychic abilities"
        }
    }
}

// MARK: - Communication Tones

/// Available communication tones for personalized insights
enum CommunicationTone: String, CaseIterable, Codable {
    case direct = "Direct"
    case gentle = "Gentle"
    case poetic = "Poetic"
    case empowering = "Empowering"
    case nurturing = "Nurturing"
    case mystical = "Mystical"
    case pragmatic = "Pragmatic"
    
    var description: String {
        switch self {
        case .direct:
            return "Clear, straightforward, actionable guidance"
        case .gentle:
            return "Soft, compassionate, supportive approach"
        case .poetic:
            return "Artistic, metaphorical, inspiring language"
        case .empowering:
            return "Confident, uplifting, strength-focused"
        case .nurturing:
            return "Caring, protective, healing-oriented"
        case .mystical:
            return "Sacred, otherworldly, transcendent"
        case .pragmatic:
            return "Practical, logical, results-oriented"
        }
    }
}