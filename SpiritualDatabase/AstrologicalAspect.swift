import Foundation
import SwiftData

/**
 * AstrologicalAspect - SwiftData Model for KASPER MLX Astrological Training
 *
 * Represents astrological aspects from Aspects.json MegaCorpus data
 * Used by KASPER MLX to provide planetary aspect insights for cosmic snapshots
 *
 * Includes comprehensive aspect data:
 * - Conjunction, Opposition, Trine, Square, Sextile, etc.
 * - Angular relationships between planets
 * - Spiritual interpretations and ritual prompts
 * - Archetypal meanings and life themes
 */
@Model
final class AstrologicalAspect {
    // Primary identifier
    @Attribute(.unique) var aspectName: String

    // Aspect geometry
    var glyph: String                    // Astrological symbol (☌, ☍, △, etc.)
    var symbol: String                   // Descriptive symbol name
    var angle: Int                       // Degrees (0, 60, 90, 120, 180, etc.)
    var orb: Int                        // Allowed degrees of variance
    var aspectType: String              // Unifying, Dynamic, Harmonious, Challenging

    // Spiritual content
    var aspectDescription: String        // Comprehensive archetypal description
    var keyTraits: [String]             // Core characteristics and energies
    var ritualPrompt: String?           // Suggested spiritual practice

    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this aspect
    var planetaryCombinations: [String] = [] // Common planet pairs for this aspect

    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false

    // Timestamps
    var createdAt: Date
    var updatedAt: Date

    init(
        aspectName: String,
        glyph: String,
        symbol: String,
        angle: Int,
        orb: Int,
        aspectType: String,
        aspectDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        insightExamples: [String] = [],
        planetaryCombinations: [String] = []
    ) {
        self.aspectName = aspectName
        self.glyph = glyph
        self.symbol = symbol
        self.angle = angle
        self.orb = orb
        self.aspectType = aspectType
        self.aspectDescription = aspectDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.insightExamples = insightExamples
        self.planetaryCombinations = planetaryCombinations
        self.mlxTrainingReady = !aspectDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension AstrologicalAspect {
    /// Returns the aspect type classification
    var isHarmonious: Bool {
        aspectType.lowercased().contains("harmonious") || aspectType.lowercased().contains("unifying")
    }

    var isChallenging: Bool {
        aspectType.lowercased().contains("challenging") || aspectType.lowercased().contains("dynamic")
    }

    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }

    /// Checks if a given angle matches this aspect (within orb)
    func matchesAngle(_ testAngle: Double) -> Bool {
        let difference = abs(testAngle - Double(angle))
        return difference <= Double(orb)
    }

    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }

    /// Updates KASPER MLX training data
    func updateTrainingData(insights: [String], combinations: [String]) {
        self.insightExamples = insights
        self.planetaryCombinations = combinations
        self.mlxTrainingReady = !aspectDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Aspect Types

/// Classification of astrological aspects
enum AspectType: String, CaseIterable, Codable {
    case unifying = "Unifying"
    case harmonious = "Harmonious"
    case dynamic = "Dynamic"
    case challenging = "Challenging"
    case flowing = "Flowing"
    case creative = "Creative"

    var description: String {
        switch self {
        case .unifying:
            return "Merges and intensifies planetary energies"
        case .harmonious:
            return "Creates ease and natural flow between planets"
        case .dynamic:
            return "Generates tension that catalyzes growth"
        case .challenging:
            return "Presents obstacles that build strength"
        case .flowing:
            return "Facilitates smooth energy exchange"
        case .creative:
            return "Stimulates innovation and new possibilities"
        }
    }
}
