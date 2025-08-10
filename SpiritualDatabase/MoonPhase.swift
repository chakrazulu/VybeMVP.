import Foundation
import SwiftData

/**
 * MoonPhase - SwiftData Model for KASPER MLX Lunar Training
 *
 * Represents lunar phases from MoonPhases.json MegaCorpus data
 * Used by KASPER MLX to provide lunar insights for cosmic snapshots
 *
 * The eight primary moon phases each carry distinct spiritual energies:
 * - New Moon: New beginnings, intention setting
 * - Waxing Crescent: Initial growth, taking action
 * - First Quarter: Challenges, decision making
 * - Waxing Gibbous: Refinement, persistence
 * - Full Moon: Culmination, manifestation, release
 * - Waning Gibbous: Gratitude, sharing wisdom
 * - Last Quarter: Forgiveness, letting go
 * - Waning Crescent: Rest, reflection, preparation
 */
@Model
final class MoonPhase {
    // Primary identifier
    @Attribute(.unique) var phaseName: String

    // Lunar identity
    var glyph: String                   // Moon phase symbol (🌑, 🌒, 🌓, etc.)
    var phaseNumber: Int                // Sequential order (1-8)
    var illuminationPercentage: Double  // Percentage of moon illuminated (0.0-1.0)
    var archetype: String               // The Seeder, The Builder, The Warrior, etc.
    var keyword: String                 // Core theme (Begin, Grow, Challenge, etc.)

    // Timing and duration
    var durationDays: Double            // Average length of this phase in days
    var optimalActions: [String]        // Best activities for this phase
    var energyDirection: String         // Increasing, Decreasing, Peak, Void

    // Spiritual content
    var phaseDescription: String        // Comprehensive description of lunar energy
    var keyTraits: [String]            // Core phase characteristics
    var ritualPrompt: String?          // Suggested spiritual practice
    var manifestationFocus: String?     // What to focus manifestation on

    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this phase
    var seasonalMeanings: [String: String] = [:] // How phase energy shifts by season
    var signMeanings: [String: String] = [:] // How phase manifests in different signs
    var practicalGuidance: [String] = [] // Actionable advice for this phase

    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false

    // Timestamps
    var createdAt: Date
    var updatedAt: Date

    init(
        phaseName: String,
        glyph: String,
        phaseNumber: Int,
        illuminationPercentage: Double,
        archetype: String,
        keyword: String,
        durationDays: Double,
        optimalActions: [String] = [],
        energyDirection: String,
        phaseDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        manifestationFocus: String? = nil,
        insightExamples: [String] = [],
        practicalGuidance: [String] = []
    ) {
        self.phaseName = phaseName
        self.glyph = glyph
        self.phaseNumber = phaseNumber
        self.illuminationPercentage = illuminationPercentage
        self.archetype = archetype
        self.keyword = keyword
        self.durationDays = durationDays
        self.optimalActions = optimalActions
        self.energyDirection = energyDirection
        self.phaseDescription = phaseDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.manifestationFocus = manifestationFocus
        self.insightExamples = insightExamples
        self.practicalGuidance = practicalGuidance
        self.mlxTrainingReady = !phaseDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension MoonPhase {
    /// Returns the phase type classification
    var phaseType: LunarPhaseType {
        switch phaseNumber {
        case 1:
            return .newMoon
        case 2:
            return .waxingCrescent
        case 3:
            return .firstQuarter
        case 4:
            return .waxingGibbous
        case 5:
            return .fullMoon
        case 6:
            return .waningGibbous
        case 7:
            return .lastQuarter
        case 8:
            return .waningCrescent
        default:
            return .newMoon
        }
    }

    /// Returns whether this is a waxing (growing) phase
    var isWaxing: Bool {
        phaseNumber >= 1 && phaseNumber <= 4
    }

    /// Returns whether this is a waning (diminishing) phase
    var isWaning: Bool {
        phaseNumber >= 6 && phaseNumber <= 8
    }

    /// Returns whether this is a peak energy phase (New or Full)
    var isPeakPhase: Bool {
        phaseNumber == 1 || phaseNumber == 5
    }

    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }

    /// Returns optimal actions as a comma-separated string
    var actionString: String {
        optimalActions.joined(separator: ", ")
    }

    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }

    /// Gets a random practical guidance for KASPER MLX
    var randomPracticalGuidance: String? {
        practicalGuidance.randomElement()
    }

    /// Gets seasonal meaning for this phase
    func getSeasonalMeaning(for season: String) -> String? {
        seasonalMeanings[season.lowercased()]
    }

    /// Gets sign-specific meaning for this phase
    func getSignMeaning(for sign: String) -> String? {
        signMeanings[sign.lowercased()]
    }

    /// Updates KASPER MLX training data
    func updateTrainingData(
        insights: [String],
        practicalGuidance: [String] = [],
        seasonalMeanings: [String: String] = [:],
        signMeanings: [String: String] = [:]
    ) {
        self.insightExamples = insights
        self.practicalGuidance = practicalGuidance
        self.seasonalMeanings = seasonalMeanings
        self.signMeanings = signMeanings
        self.mlxTrainingReady = !phaseDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }

    /// Checks if this phase is optimal for a specific type of work
    func isOptimalFor(activity: String) -> Bool {
        let activityLower = activity.lowercased()
        return optimalActions.contains { $0.lowercased().contains(activityLower) } ||
               keyTraits.contains { $0.lowercased().contains(activityLower) } ||
               manifestationFocus?.lowercased().contains(activityLower) == true
    }

    /// Gets the next phase in the lunar cycle
    var nextPhase: Int {
        phaseNumber == 8 ? 1 : phaseNumber + 1
    }

    /// Gets the previous phase in the lunar cycle
    var previousPhase: Int {
        phaseNumber == 1 ? 8 : phaseNumber - 1
    }
}

// MARK: - Lunar Phase Classifications

/// The eight primary lunar phases
enum LunarPhaseType: String, CaseIterable, Codable {
    case newMoon = "New Moon"
    case waxingCrescent = "Waxing Crescent"
    case firstQuarter = "First Quarter"
    case waxingGibbous = "Waxing Gibbous"
    case fullMoon = "Full Moon"
    case waningGibbous = "Waning Gibbous"
    case lastQuarter = "Last Quarter"
    case waningCrescent = "Waning Crescent"

    var phaseNumber: Int {
        switch self {
        case .newMoon: return 1
        case .waxingCrescent: return 2
        case .firstQuarter: return 3
        case .waxingGibbous: return 4
        case .fullMoon: return 5
        case .waningGibbous: return 6
        case .lastQuarter: return 7
        case .waningCrescent: return 8
        }
    }

    var glyph: String {
        switch self {
        case .newMoon: return "🌑"
        case .waxingCrescent: return "🌒"
        case .firstQuarter: return "🌓"
        case .waxingGibbous: return "🌔"
        case .fullMoon: return "🌕"
        case .waningGibbous: return "🌖"
        case .lastQuarter: return "🌗"
        case .waningCrescent: return "🌘"
        }
    }

    var primaryEnergy: String {
        switch self {
        case .newMoon: return "Intention and new beginnings"
        case .waxingCrescent: return "Initial action and momentum"
        case .firstQuarter: return "Challenge and decision"
        case .waxingGibbous: return "Refinement and persistence"
        case .fullMoon: return "Culmination and manifestation"
        case .waningGibbous: return "Gratitude and sharing"
        case .lastQuarter: return "Release and forgiveness"
        case .waningCrescent: return "Rest and reflection"
        }
    }
}

/// Lunar energy directions
enum LunarEnergyDirection: String, CaseIterable, Codable {
    case increasing = "Increasing"
    case peak = "Peak"
    case decreasing = "Decreasing"
    case void = "Void"

    var description: String {
        switch self {
        case .increasing:
            return "Energy building and expanding"
        case .peak:
            return "Energy at maximum intensity"
        case .decreasing:
            return "Energy waning and releasing"
        case .void:
            return "Energy at minimum, preparing for renewal"
        }
    }
}
