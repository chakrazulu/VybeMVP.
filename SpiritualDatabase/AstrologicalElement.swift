import Foundation
import SwiftData

/**
 * AstrologicalElement - SwiftData Model for KASPER MLX Elemental Training
 *
 * Represents the four sacred elements from Elements.json MegaCorpus data
 * Used by KASPER MLX to provide elemental insights for cosmic snapshots
 *
 * The four elements form the foundation of astrological understanding:
 * - Fire: Initiative, passion, creativity (Aries, Leo, Sagittarius)
 * - Earth: Practicality, stability, manifestation (Taurus, Virgo, Capricorn)
 * - Air: Communication, intellect, connection (Gemini, Libra, Aquarius)
 * - Water: Emotion, intuition, healing (Cancer, Scorpio, Pisces)
 */
@Model
final class AstrologicalElement {
    // Primary identifier
    @Attribute(.unique) var elementName: String

    // Elemental identity
    var glyph: String                   // Element symbol (🔥, 🌍, 💨, 🌊)
    var polarity: String                // Masculine/Yang or Feminine/Yin
    var archetype: String               // The Pioneer's Spark, The Builder's Foundation, etc.
    var color: String                   // Associated color

    // Astrological correspondences
    var rulingPlanets: [String]         // Planets associated with this element
    var signOrderNumbers: [Int]         // Sign positions (1,5,9 for Fire, etc.)
    var resonantFocusNumbers: [Int]     // Numerological correspondences
    var jungianTypology: String         // Jung's psychological types

    // Signs of this element
    var associatedSigns: [String]       // Zodiac signs of this element

    // Spiritual content
    var elementDescription: String      // Comprehensive description of elemental energy
    var keyTraits: [String]            // Core elemental characteristics
    var ritualPrompt: String?          // Suggested spiritual practice

    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this element
    var seasonalMeanings: [String: String] = [:] // How element manifests in different seasons
    var planetaryMeanings: [String: String] = [:] // How element affects different planets

    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false

    // Timestamps
    var createdAt: Date
    var updatedAt: Date

    init(
        elementName: String,
        glyph: String,
        polarity: String,
        archetype: String,
        color: String,
        rulingPlanets: [String] = [],
        signOrderNumbers: [Int] = [],
        resonantFocusNumbers: [Int] = [],
        jungianTypology: String,
        associatedSigns: [String] = [],
        elementDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        insightExamples: [String] = []
    ) {
        self.elementName = elementName
        self.glyph = glyph
        self.polarity = polarity
        self.archetype = archetype
        self.color = color
        self.rulingPlanets = rulingPlanets
        self.signOrderNumbers = signOrderNumbers
        self.resonantFocusNumbers = resonantFocusNumbers
        self.jungianTypology = jungianTypology
        self.associatedSigns = associatedSigns
        self.elementDescription = elementDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.insightExamples = insightExamples
        self.mlxTrainingReady = !elementDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension AstrologicalElement {
    /// Returns the element's polarity type
    var isYang: Bool {
        polarity.lowercased().contains("yang") || polarity.lowercased().contains("masculine")
    }

    var isYin: Bool {
        !isYang
    }

    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }

    /// Returns associated signs as a comma-separated string
    var signString: String {
        associatedSigns.joined(separator: ", ")
    }

    /// Returns ruling planets as a comma-separated string
    var planetString: String {
        rulingPlanets.joined(separator: ", ")
    }

    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }

    /// Gets seasonal meaning for this element
    func getSeasonalMeaning(for season: String) -> String? {
        seasonalMeanings[season.lowercased()]
    }

    /// Gets planetary meaning for this element with a specific planet
    func getPlanetaryMeaning(for planet: String) -> String? {
        planetaryMeanings[planet.lowercased()]
    }

    /// Updates KASPER MLX training data
    func updateTrainingData(
        insights: [String],
        seasonalMeanings: [String: String] = [:],
        planetaryMeanings: [String: String] = [:]
    ) {
        self.insightExamples = insights
        self.seasonalMeanings = seasonalMeanings
        self.planetaryMeanings = planetaryMeanings
        self.mlxTrainingReady = !elementDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }

    /// Checks if this element is compatible with another element
    func isCompatible(with otherElement: String) -> ElementCompatibility {
        let other = otherElement.lowercased()
        let current = elementName.lowercased()

        // Same element - natural understanding
        if current == other {
            return .natural
        }

        // Fire and Air are compatible (Fire needs Air to burn)
        // Earth and Water are compatible (Earth needs Water to grow)
        if (current == "fire" && other == "air") ||
           (current == "air" && other == "fire") ||
           (current == "earth" && other == "water") ||
           (current == "water" && other == "earth") {
            return .supportive
        }

        // Fire and Water oppose each other
        // Earth and Air oppose each other
        if (current == "fire" && other == "water") ||
           (current == "water" && other == "fire") ||
           (current == "earth" && other == "air") ||
           (current == "air" && other == "earth") {
            return .challenging
        }

        // Fire and Earth, Air and Water - neutral/growth
        return .neutral
    }
}

// MARK: - Element Classifications

/// Element compatibility levels
enum ElementCompatibility: String, CaseIterable, Codable {
    case natural = "Natural"
    case supportive = "Supportive"
    case neutral = "Neutral"
    case challenging = "Challenging"

    var description: String {
        switch self {
        case .natural:
            return "Same element - natural understanding and harmony"
        case .supportive:
            return "Complementary elements that enhance each other"
        case .neutral:
            return "Different approaches that can learn from each other"
        case .challenging:
            return "Opposing elements that create dynamic tension"
        }
    }

    var strengthModifier: Double {
        switch self {
        case .natural:
            return 1.0
        case .supportive:
            return 0.8
        case .neutral:
            return 0.6
        case .challenging:
            return 0.4
        }
    }
}
