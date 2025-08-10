import Foundation
import SwiftData

/**
 * NumberMeaning - Enhanced SwiftData Model for KASPER MLX Training
 *
 * Represents comprehensive spiritual meanings for numbers (0-9, 11, 22, 33, 44)
 * Stores rich insight data from NumberMessages_Complete_X.json files
 * Used for KASPER MLX training, Focus Numbers, Realm Numbers, and cosmic insights
 *
 * This model now accommodates 10,000+ insights across multiple categories:
 * - insight: General spiritual guidance (33+ entries per number)
 * - reflection: Soul-searching questions (25+ per number)
 * - contemplation: Deep philosophical insights (25+ per number)
 * - manifestation: Affirmation statements (30+ per number)
 * - challenge: Direct spiritual challenges (25+ per number)
 * - physical_practice: Embodied spiritual practices (25+ per number)
 * - shadow: Shadow work insights (25+ per number)
 * - archetype: Mythological and archetypal wisdom (25+ per number)
 * - energy_check: Real-time energetic guidance (25+ per number)
 * - numerical_context: Numerological context and relationships (25+ per number)
 * - astrological: Planetary and astrological correspondences (25+ per number)
 */
@Model
final class NumberMeaning {
    // Primary identifier
    @Attribute(.unique) var number: Int

    // Rich insight categories (from NumberMessages_Complete JSON files)
    var insights: [String] = []              // General spiritual guidance
    var reflections: [String] = []           // Soul-searching questions
    var contemplations: [String] = []        // Deep philosophical insights
    var manifestations: [String] = []        // Affirmation statements
    var challenges: [String] = []            // Direct spiritual challenges
    var physicalPractices: [String] = []     // Embodied spiritual practices
    var shadowInsights: [String] = []        // Shadow work guidance
    var archetypeInsights: [String] = []     // Mythological wisdom
    var energyChecks: [String] = []          // Real-time energetic guidance
    var numericalContexts: [String] = []     // Numerological relationships
    var astrologicalInsights: [String] = []  // Planetary correspondences

    // Core spiritual data (legacy compatibility)
    var archetype: String
    var title: String
    var element: String
    var keywords: [String]
    var strengths: [String]
    var legacyChallenges: [String]           // Renamed to avoid confusion with rich challenges
    var spiritualDescription: String

    // Astrological correspondences
    var planetaryCorrespondence: String?
    var signCorrespondence: String?
    var color: String?

    // KASPER MLX training metadata
    var insightCount: Int = 0                // Total number of insights for this number
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false       // Flag for KASPER MLX training readiness

    // Timestamps
    var createdAt: Date
    var updatedAt: Date

    init(
        number: Int,
        archetype: String,
        title: String,
        element: String,
        keywords: [String] = [],
        strengths: [String] = [],
        legacyChallenges: [String] = [],
        spiritualDescription: String,
        planetaryCorrespondence: String? = nil,
        signCorrespondence: String? = nil,
        color: String? = nil,
        // Rich insight data
        insights: [String] = [],
        reflections: [String] = [],
        contemplations: [String] = [],
        manifestations: [String] = [],
        challenges: [String] = [],
        physicalPractices: [String] = [],
        shadowInsights: [String] = [],
        archetypeInsights: [String] = [],
        energyChecks: [String] = [],
        numericalContexts: [String] = [],
        astrologicalInsights: [String] = []
    ) {
        self.number = number
        self.archetype = archetype
        self.title = title
        self.element = element
        self.keywords = keywords
        self.strengths = strengths
        self.legacyChallenges = legacyChallenges
        self.spiritualDescription = spiritualDescription
        self.planetaryCorrespondence = planetaryCorrespondence
        self.signCorrespondence = signCorrespondence
        self.color = color

        // Rich insight data
        self.insights = insights
        self.reflections = reflections
        self.contemplations = contemplations
        self.manifestations = manifestations
        self.challenges = challenges
        self.physicalPractices = physicalPractices
        self.shadowInsights = shadowInsights
        self.archetypeInsights = archetypeInsights
        self.energyChecks = energyChecks
        self.numericalContexts = numericalContexts
        self.astrologicalInsights = astrologicalInsights

        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()

        // Calculate total insight count after all stored properties are initialized
        self.insightCount = insights.count + reflections.count + contemplations.count +
                           manifestations.count + challenges.count + physicalPractices.count +
                           shadowInsights.count + archetypeInsights.count + energyChecks.count +
                           numericalContexts.count + astrologicalInsights.count

        self.mlxTrainingReady = self.insightCount > 0
    }
}

// MARK: - Convenience Methods

extension NumberMeaning {
    /// Returns formatted archetype string (e.g., "The Pioneer")
    var formattedArchetype: String {
        archetype.hasPrefix("The ") ? archetype : "The \(archetype)"
    }

    /// Returns keywords as a comma-separated string
    var keywordString: String {
        keywords.joined(separator: ", ")
    }

    /// Checks if this is a master number (11, 22, 33, 44)
    var isMasterNumber: Bool {
        [11, 22, 33, 44].contains(number)
    }

    /// Updates insight count after data modification
    func updateInsightCount() {
        insightCount = insights.count + reflections.count + contemplations.count +
                      manifestations.count + challenges.count + physicalPractices.count +
                      shadowInsights.count + archetypeInsights.count + energyChecks.count +
                      numericalContexts.count + astrologicalInsights.count
        mlxTrainingReady = insightCount > 0
        updatedAt = Date()
        lastKASPERUpdate = Date()
    }

    /// Gets a random insight from the specified category for KASPER MLX
    func getRandomInsight(from category: InsightCategory) -> String? {
        let categoryInsights: [String]

        switch category {
        case .insight:
            categoryInsights = insights
        case .reflection:
            categoryInsights = reflections
        case .contemplation:
            categoryInsights = contemplations
        case .manifestation:
            categoryInsights = manifestations
        case .challenge:
            categoryInsights = challenges
        case .physicalPractice:
            categoryInsights = physicalPractices
        case .shadow:
            categoryInsights = shadowInsights
        case .archetype:
            categoryInsights = archetypeInsights
        case .energyCheck:
            categoryInsights = energyChecks
        case .numericalContext:
            categoryInsights = numericalContexts
        case .astrological:
            categoryInsights = astrologicalInsights
        }

        return categoryInsights.randomElement()
    }

    /// Gets all insights as a flat array for KASPER MLX training
    var allInsights: [String] {
        return insights + reflections + contemplations + manifestations + challenges +
               physicalPractices + shadowInsights + archetypeInsights + energyChecks +
               numericalContexts + astrologicalInsights
    }

    /// Gets insights with category labels for KASPER MLX context
    var categorizedInsights: [(category: InsightCategory, insight: String)] {
        var result: [(InsightCategory, String)] = []

        insights.forEach { result.append((.insight, $0)) }
        reflections.forEach { result.append((.reflection, $0)) }
        contemplations.forEach { result.append((.contemplation, $0)) }
        manifestations.forEach { result.append((.manifestation, $0)) }
        challenges.forEach { result.append((.challenge, $0)) }
        physicalPractices.forEach { result.append((.physicalPractice, $0)) }
        shadowInsights.forEach { result.append((.shadow, $0)) }
        archetypeInsights.forEach { result.append((.archetype, $0)) }
        energyChecks.forEach { result.append((.energyCheck, $0)) }
        numericalContexts.forEach { result.append((.numericalContext, $0)) }
        astrologicalInsights.forEach { result.append((.astrological, $0)) }

        return result
    }
}

// MARK: - Insight Categories

/// Categories of insights available for each number
enum InsightCategory: String, CaseIterable, Codable {
    case insight = "insight"
    case reflection = "reflection"
    case contemplation = "contemplation"
    case manifestation = "manifestation"
    case challenge = "challenge"
    case physicalPractice = "physical_practice"
    case shadow = "shadow"
    case archetype = "archetype"
    case energyCheck = "energy_check"
    case numericalContext = "numerical_context"
    case astrological = "astrological"

    var displayName: String {
        switch self {
        case .insight: return "Spiritual Insights"
        case .reflection: return "Soul Reflections"
        case .contemplation: return "Deep Contemplation"
        case .manifestation: return "Manifestation Affirmations"
        case .challenge: return "Spiritual Challenges"
        case .physicalPractice: return "Embodied Practices"
        case .shadow: return "Shadow Work"
        case .archetype: return "Archetypal Wisdom"
        case .energyCheck: return "Energy Guidance"
        case .numericalContext: return "Numerological Context"
        case .astrological: return "Astrological Insights"
        }
    }
}
