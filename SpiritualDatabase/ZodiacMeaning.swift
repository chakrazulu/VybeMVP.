import Foundation
import SwiftData

/**
 * ZodiacMeaning - SwiftData Model
 * 
 * Represents zodiac sign data from MegaCorpus Signs.json
 * Maps directly to your existing JSON structure for seamless migration
 */
@Model
final class ZodiacMeaning {
    // Primary identifier
    @Attribute(.unique) var name: String
    
    // Basic sign data (from your Signs.json)
    var glyph: String
    var dateRange: String
    var symbol: String
    var ruler: String
    var house: String
    var element: String
    var mode: String
    var keyword: String
    var signDescription: String
    
    // Numerology data (nested object in your JSON)
    var signOrderNumber: Int
    var rulerVibration: Int
    var elementNumber: Int
    var modeNumber: Int
    var resonantNumbers: [Int]
    
    // Key traits and spiritual guidance
    var keyTraits: [String]
    var spiritualGuidance: String?
    var challenges: [String]
    var strengths: [String]
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        name: String,
        glyph: String,
        dateRange: String,
        symbol: String,
        ruler: String,
        house: String,
        element: String,
        mode: String,
        keyword: String,
        signDescription: String,
        signOrderNumber: Int,
        rulerVibration: Int,
        elementNumber: Int,
        modeNumber: Int,
        resonantNumbers: [Int] = [],
        keyTraits: [String] = [],
        spiritualGuidance: String? = nil,
        challenges: [String] = [],
        strengths: [String] = []
    ) {
        self.name = name
        self.glyph = glyph
        self.dateRange = dateRange
        self.symbol = symbol
        self.ruler = ruler
        self.house = house
        self.element = element
        self.mode = mode
        self.keyword = keyword
        self.signDescription = signDescription
        self.signOrderNumber = signOrderNumber
        self.rulerVibration = rulerVibration
        self.elementNumber = elementNumber
        self.modeNumber = modeNumber
        self.resonantNumbers = resonantNumbers
        self.keyTraits = keyTraits
        self.spiritualGuidance = spiritualGuidance
        self.challenges = challenges
        self.strengths = strengths
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Convenience Methods

extension ZodiacMeaning {
    /// Returns the sign name capitalized (e.g., "Aries")
    var capitalizedName: String {
        name.capitalized
    }
    
    /// Returns key traits as a formatted string
    var keyTraitsString: String {
        keyTraits.joined(separator: " • ")
    }
    
    /// Checks if this sign is a Fire sign
    var isFireSign: Bool {
        element.lowercased() == "fire"
    }
    
    /// Checks if this sign is a Cardinal sign
    var isCardinalSign: Bool {
        mode.lowercased() == "cardinal"
    }
}