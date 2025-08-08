import Foundation
import SwiftData

/**
 * ApparentMotion - SwiftData Model for KASPER MLX Planetary Motion Training
 * 
 * Represents apparent planetary motion from ApparentMotion.json MegaCorpus data
 * Used by KASPER MLX to provide planetary motion insights for cosmic snapshots
 * 
 * Apparent motion describes how planets appear to move from Earth's perspective:
 * - Direct Motion: Normal forward movement through the zodiac
 * - Retrograde Motion: Apparent backward movement (powerful for inner work)
 * - Stationary: Planet appears motionless before changing direction
 * - Cazimi: Planet extremely close to the Sun (within 17 arc minutes)
 * - Combust: Planet too close to the Sun to be visible
 */
@Model
final class ApparentMotion {
    // Primary identifier
    @Attribute(.unique) var motionType: String
    
    // Motion identity
    var glyph: String                   // Motion symbol or abbreviation
    var keyword: String                 // Core theme (Direct, Retrograde, etc.)
    var archetype: String               // The Accelerator, The Reflector, etc.
    
    // Motion characteristics
    var motionDescription: String       // Comprehensive description of motion type
    var spiritualMeaning: String        // What this motion represents spiritually
    var keyTraits: [String]            // Core motion characteristics
    var duration: String?              // Typical duration when this motion occurs
    
    // Planetary applicability
    var affectedPlanets: [String]       // Which planets can have this motion
    var mostSignificantFor: [String]    // Planets where this motion is most impactful
    
    // Spiritual guidance
    var ritualPrompt: String?          // Suggested spiritual practice
    var optimalActivities: [String]     // Best activities during this motion
    var activitiesToAvoid: [String]     // Activities to avoid during this motion
    
    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this motion type
    var planetaryMeanings: [String: String] = [:] // How motion affects each planet
    var signMeanings: [String: String] = [:] // How motion manifests in different signs
    var practicalGuidance: [String] = [] // Actionable advice for this motion
    
    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        motionType: String,
        glyph: String,
        keyword: String,
        archetype: String,
        motionDescription: String,
        spiritualMeaning: String,
        keyTraits: [String] = [],
        duration: String? = nil,
        affectedPlanets: [String] = [],
        mostSignificantFor: [String] = [],
        ritualPrompt: String? = nil,
        optimalActivities: [String] = [],
        activitiesToAvoid: [String] = [],
        insightExamples: [String] = [],
        practicalGuidance: [String] = []
    ) {
        self.motionType = motionType
        self.glyph = glyph
        self.keyword = keyword
        self.archetype = archetype
        self.motionDescription = motionDescription
        self.spiritualMeaning = spiritualMeaning
        self.keyTraits = keyTraits
        self.duration = duration
        self.affectedPlanets = affectedPlanets
        self.mostSignificantFor = mostSignificantFor
        self.ritualPrompt = ritualPrompt
        self.optimalActivities = optimalActivities
        self.activitiesToAvoid = activitiesToAvoid
        self.insightExamples = insightExamples
        self.practicalGuidance = practicalGuidance
        self.mlxTrainingReady = !motionDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension ApparentMotion {
    /// Returns the motion classification
    var motionClassification: MotionClassification {
        switch motionType.lowercased() {
        case "direct", "prograde":
            return .direct
        case "retrograde":
            return .retrograde
        case "stationary", "station":
            return .stationary
        case "cazimi":
            return .cazimi
        case "combust", "combustion":
            return .combust
        default:
            return .direct
        }
    }
    
    /// Returns whether this motion is considered challenging
    var isChallenging: Bool {
        motionType.lowercased().contains("retrograde") || 
        motionType.lowercased().contains("combust")
    }
    
    /// Returns whether this motion is considered beneficial
    var isBeneficial: Bool {
        motionType.lowercased().contains("direct") || 
        motionType.lowercased().contains("cazimi")
    }
    
    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }
    
    /// Returns affected planets as a comma-separated string
    var planetString: String {
        affectedPlanets.joined(separator: ", ")
    }
    
    /// Returns optimal activities as a comma-separated string
    var activityString: String {
        optimalActivities.joined(separator: ", ")
    }
    
    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }
    
    /// Gets a random practical guidance for KASPER MLX
    var randomPracticalGuidance: String? {
        practicalGuidance.randomElement()
    }
    
    /// Gets planetary-specific meaning for this motion
    func getPlanetaryMeaning(for planet: String) -> String? {
        planetaryMeanings[planet.lowercased()]
    }
    
    /// Gets sign-specific meaning for this motion
    func getSignMeaning(for sign: String) -> String? {
        signMeanings[sign.lowercased()]
    }
    
    /// Checks if this motion significantly affects a specific planet
    func significantlyAffects(planet: String) -> Bool {
        let planetLower = planet.lowercased()
        return mostSignificantFor.contains { $0.lowercased() == planetLower } ||
               affectedPlanets.contains { $0.lowercased() == planetLower }
    }
    
    /// Checks if an activity is optimal during this motion
    func isOptimalFor(activity: String) -> Bool {
        let activityLower = activity.lowercased()
        return optimalActivities.contains { $0.lowercased().contains(activityLower) }
    }
    
    /// Checks if an activity should be avoided during this motion
    func shouldAvoid(activity: String) -> Bool {
        let activityLower = activity.lowercased()
        return activitiesToAvoid.contains { $0.lowercased().contains(activityLower) }
    }
    
    /// Updates KASPER MLX training data
    func updateTrainingData(
        insights: [String],
        practicalGuidance: [String] = [],
        planetaryMeanings: [String: String] = [:],
        signMeanings: [String: String] = [:]
    ) {
        self.insightExamples = insights
        self.practicalGuidance = practicalGuidance
        self.planetaryMeanings = planetaryMeanings
        self.signMeanings = signMeanings
        self.mlxTrainingReady = !motionDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Motion Classifications

/// Types of apparent planetary motion
enum MotionClassification: String, CaseIterable, Codable {
    case direct = "Direct"
    case retrograde = "Retrograde"
    case stationary = "Stationary"
    case cazimi = "Cazimi"
    case combust = "Combust"
    
    var description: String {
        switch self {
        case .direct:
            return "Normal forward movement through the zodiac"
        case .retrograde:
            return "Apparent backward movement - time for inner work and revision"
        case .stationary:
            return "Planet appears motionless - concentrated energy at a specific degree"
        case .cazimi:
            return "Planet in the heart of the Sun - purification and empowerment"
        case .combust:
            return "Planet too close to the Sun - weakened expression, hidden influence"
        }
    }
    
    var spiritualTheme: String {
        switch self {
        case .direct:
            return "Progress, manifestation, external focus"
        case .retrograde:
            return "Reflection, revision, internal processing"
        case .stationary:
            return "Concentration, turning point, decisive moment"
        case .cazimi:
            return "Purification, divine blessing, clarity"
        case .combust:
            return "Hidden influence, unconscious patterns, testing"
        }
    }
    
    var energyIntensity: Double {
        switch self {
        case .direct:
            return 1.0
        case .retrograde:
            return 0.7
        case .stationary:
            return 1.5
        case .cazimi:
            return 2.0
        case .combust:
            return 0.3
        }
    }
}