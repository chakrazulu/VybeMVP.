import Foundation
import SwiftData

/**
 * AstrologicalMode - SwiftData Model for KASPER MLX Modal Training
 * 
 * Represents the three astrological modes from Modes.json MegaCorpus data
 * Used by KASPER MLX to provide modal insights for cosmic snapshots
 * 
 * The three modes describe how energy moves through the zodiac:
 * - Cardinal: Initiation, leadership, starting new cycles
 * - Fixed: Stability, persistence, maintaining and building
 * - Mutable: Adaptation, flexibility, transitioning and changing
 */
@Model
final class AstrologicalMode {
    // Primary identifier
    @Attribute(.unique) var modeName: String
    
    // Modal identity
    var glyph: String                   // Mode symbol
    var archetype: String               // The Initiator, The Stabilizer, The Adapter
    var keyword: String                 // Core theme (Begin, Sustain, Adapt)
    var polarity: String               // How this mode expresses energy
    
    // Astrological correspondences
    var signOrderNumbers: [Int]         // Sign positions (1,4,7,10 for Cardinal, etc.)
    var resonantFocusNumbers: [Int]     // Numerological correspondences
    var seasonalTiming: String          // Beginning, Middle, End of seasons
    
    // Signs of this mode
    var associatedSigns: [String]       // Zodiac signs of this mode
    var elementDistribution: [String: String] // How mode manifests through each element
    
    // Spiritual content
    var modeDescription: String         // Comprehensive description of modal energy
    var keyTraits: [String]            // Core modal characteristics
    var ritualPrompt: String?          // Suggested spiritual practice
    
    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this mode
    var seasonalMeanings: [String: String] = [:] // How mode manifests seasonally
    var planetaryMeanings: [String: String] = [:] // How mode affects different planets
    var houseCorrespondences: [String: String] = [:] // How mode manifests in houses
    
    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        modeName: String,
        glyph: String,
        archetype: String,
        keyword: String,
        polarity: String,
        signOrderNumbers: [Int] = [],
        resonantFocusNumbers: [Int] = [],
        seasonalTiming: String,
        associatedSigns: [String] = [],
        elementDistribution: [String: String] = [:],
        modeDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        insightExamples: [String] = []
    ) {
        self.modeName = modeName
        self.glyph = glyph
        self.archetype = archetype
        self.keyword = keyword
        self.polarity = polarity
        self.signOrderNumbers = signOrderNumbers
        self.resonantFocusNumbers = resonantFocusNumbers
        self.seasonalTiming = seasonalTiming
        self.associatedSigns = associatedSigns
        self.elementDistribution = elementDistribution
        self.modeDescription = modeDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.insightExamples = insightExamples
        self.mlxTrainingReady = !modeDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension AstrologicalMode {
    /// Returns the mode's energy type
    var modalType: ModalType {
        switch modeName.lowercased() {
        case "cardinal":
            return .cardinal
        case "fixed":
            return .fixed
        case "mutable":
            return .mutable
        default:
            return .mutable
        }
    }
    
    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }
    
    /// Returns associated signs as a comma-separated string
    var signString: String {
        associatedSigns.joined(separator: ", ")
    }
    
    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }
    
    /// Gets seasonal meaning for this mode
    func getSeasonalMeaning(for season: String) -> String? {
        seasonalMeanings[season.lowercased()]
    }
    
    /// Gets planetary meaning for this mode with a specific planet
    func getPlanetaryMeaning(for planet: String) -> String? {
        planetaryMeanings[planet.lowercased()]
    }
    
    /// Gets how this mode manifests through a specific element
    func getElementalManifestation(for element: String) -> String? {
        elementDistribution[element.lowercased()]
    }
    
    /// Gets house correspondence for this mode
    func getHouseCorrespondence(for house: String) -> String? {
        houseCorrespondences[house.lowercased()]
    }
    
    /// Updates KASPER MLX training data
    func updateTrainingData(
        insights: [String],
        seasonalMeanings: [String: String] = [:],
        planetaryMeanings: [String: String] = [:],
        houseCorrespondences: [String: String] = [:]
    ) {
        self.insightExamples = insights
        self.seasonalMeanings = seasonalMeanings
        self.planetaryMeanings = planetaryMeanings
        self.houseCorrespondences = houseCorrespondences
        self.mlxTrainingReady = !modeDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
    
    /// Checks if this mode is compatible with another mode
    func isCompatible(with otherMode: String) -> ModeCompatibility {
        let other = otherMode.lowercased()
        let current = modeName.lowercased()
        
        // Same mode - natural understanding
        if current == other {
            return .natural
        }
        
        // Cardinal and Mutable work well together - initiation and adaptation
        // Fixed and Cardinal can create productive tension
        if (current == "cardinal" && other == "mutable") ||
           (current == "mutable" && other == "cardinal") {
            return .supportive
        }
        
        // Fixed and Mutable can create growth through contrast
        if (current == "fixed" && other == "mutable") ||
           (current == "mutable" && other == "fixed") {
            return .dynamic
        }
        
        // Cardinal and Fixed - leadership meets stability
        return .complementary
    }
}

// MARK: - Mode Classifications

/// Astrological mode types
enum ModalType: String, CaseIterable, Codable {
    case cardinal = "Cardinal"
    case fixed = "Fixed"
    case mutable = "Mutable"
    
    var description: String {
        switch self {
        case .cardinal:
            return "Initiating energy - starts new cycles and leads change"
        case .fixed:
            return "Stabilizing energy - maintains, builds, and perseveres"
        case .mutable:
            return "Adapting energy - flows, changes, and transitions"
        }
    }
    
    var signs: [String] {
        switch self {
        case .cardinal:
            return ["Aries", "Cancer", "Libra", "Capricorn"]
        case .fixed:
            return ["Taurus", "Leo", "Scorpio", "Aquarius"]
        case .mutable:
            return ["Gemini", "Virgo", "Sagittarius", "Pisces"]
        }
    }
    
    var seasonalTiming: String {
        switch self {
        case .cardinal:
            return "Beginning of seasons - equinoxes and solstices"
        case .fixed:
            return "Middle of seasons - peak seasonal energy"
        case .mutable:
            return "End of seasons - transitional periods"
        }
    }
}

/// Mode compatibility levels
enum ModeCompatibility: String, CaseIterable, Codable {
    case natural = "Natural"
    case supportive = "Supportive"
    case complementary = "Complementary"
    case dynamic = "Dynamic"
    
    var description: String {
        switch self {
        case .natural:
            return "Same mode - natural understanding and flow"
        case .supportive:
            return "Modes that enhance each other's effectiveness"
        case .complementary:
            return "Different approaches that complete each other"
        case .dynamic:
            return "Contrasting modes that create productive tension"
        }
    }
    
    var strengthModifier: Double {
        switch self {
        case .natural:
            return 1.0
        case .supportive:
            return 0.85
        case .complementary:
            return 0.7
        case .dynamic:
            return 0.6
        }
    }
}