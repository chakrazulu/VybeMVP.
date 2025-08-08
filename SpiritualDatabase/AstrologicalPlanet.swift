import Foundation
import SwiftData

/**
 * AstrologicalPlanet - SwiftData Model for KASPER MLX Planetary Training
 * 
 * Represents planetary bodies from Planets.json MegaCorpus data
 * Used by KASPER MLX to provide planetary insights for cosmic snapshots
 * 
 * Includes all celestial bodies used in astrology:
 * - Classical planets (Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn)
 * - Modern planets (Uranus, Neptune, Pluto)
 * - Lunar nodes and other significant points
 */
@Model
final class AstrologicalPlanet {
    // Primary identifier
    @Attribute(.unique) var planetName: String
    
    // Planetary identity
    var glyph: String                   // Astrological symbol (☉, ☽, ☿, etc.)
    var symbol: String                  // Descriptive symbol name
    var archetype: String               // The Hero, The Nurturer, The Messenger, etc.
    var keyword: String                 // Core theme (Shine, Feel, Think, etc.)
    
    // Astrological properties
    var numerology: Int                 // Numerological vibration (1-9)
    var resonantNumbers: [Int]          // Additional numerological correspondences
    var element: String                 // Fire, Earth, Air, Water
    var mode: String                    // Cardinal, Fixed, Mutable
    var associatedHouse: String         // Natural house rulership
    
    // Rulership data
    var rulerOf: String?                // Sign this planet rules
    var exaltedIn: String?              // Sign of exaltation
    var detrimentIn: String?            // Sign of detriment
    var fallIn: String?                 // Sign of fall
    
    // Spiritual content
    var planetDescription: String       // Comprehensive archetypal description
    var keyTraits: [String]            // Core planetary qualities
    var ritualPrompt: String?          // Suggested spiritual practice
    
    // KASPER MLX training data
    var insightExamples: [String] = []  // Example insights for this planet
    var signInterpretations: [String: String] = [:] // How this planet manifests in each sign
    var houseInterpretations: [String: String] = [:] // How this planet manifests in each house
    var aspectInterpretations: [String: String] = [:] // How this planet forms aspects
    
    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        planetName: String,
        glyph: String,
        symbol: String,
        archetype: String,
        keyword: String,
        numerology: Int,
        resonantNumbers: [Int] = [],
        element: String,
        mode: String,
        associatedHouse: String,
        rulerOf: String? = nil,
        exaltedIn: String? = nil,
        detrimentIn: String? = nil,
        fallIn: String? = nil,
        planetDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        insightExamples: [String] = []
    ) {
        self.planetName = planetName
        self.glyph = glyph
        self.symbol = symbol
        self.archetype = archetype
        self.keyword = keyword
        self.numerology = numerology
        self.resonantNumbers = resonantNumbers
        self.element = element
        self.mode = mode
        self.associatedHouse = associatedHouse
        self.rulerOf = rulerOf
        self.exaltedIn = exaltedIn
        self.detrimentIn = detrimentIn
        self.fallIn = fallIn
        self.planetDescription = planetDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.insightExamples = insightExamples
        self.mlxTrainingReady = !planetDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension AstrologicalPlanet {
    /// Returns the planet classification
    var planetType: PlanetType {
        switch planetName.lowercased() {
        case "sun", "moon":
            return .luminary
        case "mercury", "venus", "mars":
            return .personal
        case "jupiter", "saturn":
            return .social
        case "uranus", "neptune", "pluto":
            return .generational
        default:
            return .other
        }
    }
    
    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }
    
    /// Returns resonant numbers as a comma-separated string
    var resonantNumberString: String {
        resonantNumbers.map(String.init).joined(separator: ", ")
    }
    
    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }
    
    /// Gets interpretation for this planet in a specific sign
    func getSignInterpretation(for sign: String) -> String? {
        signInterpretations[sign.lowercased()]
    }
    
    /// Gets interpretation for this planet in a specific house
    func getHouseInterpretation(for house: String) -> String? {
        houseInterpretations[house.lowercased()]
    }
    
    /// Gets interpretation for this planet forming a specific aspect
    func getAspectInterpretation(for aspect: String) -> String? {
        aspectInterpretations[aspect.lowercased()]
    }
    
    /// Updates KASPER MLX training data
    func updateTrainingData(
        insights: [String],
        signInterpretations: [String: String] = [:],
        houseInterpretations: [String: String] = [:],
        aspectInterpretations: [String: String] = [:]
    ) {
        self.insightExamples = insights
        self.signInterpretations = signInterpretations
        self.houseInterpretations = houseInterpretations
        self.aspectInterpretations = aspectInterpretations
        self.mlxTrainingReady = !planetDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
    
    /// Checks if this planet has dignity in the given sign
    func hasDignity(in sign: String) -> PlanetaryDignity? {
        let signLower = sign.lowercased()
        
        if rulerOf?.lowercased() == signLower {
            return .ruler
        } else if exaltedIn?.lowercased() == signLower {
            return .exaltation
        } else if detrimentIn?.lowercased() == signLower {
            return .detriment
        } else if fallIn?.lowercased() == signLower {
            return .fall
        }
        
        return nil
    }
}

// MARK: - Planet Classifications

/// Classification of planetary bodies
enum PlanetType: String, CaseIterable, Codable {
    case luminary = "Luminary"
    case personal = "Personal"
    case social = "Social"
    case generational = "Generational"
    case other = "Other"
    
    var description: String {
        switch self {
        case .luminary:
            return "Sun and Moon - core identity and emotional nature"
        case .personal:
            return "Mercury, Venus, Mars - personal expression and drives"
        case .social:
            return "Jupiter, Saturn - social roles and responsibilities"
        case .generational:
            return "Uranus, Neptune, Pluto - collective and transformational themes"
        case .other:
            return "Lunar nodes, asteroids, and other celestial points"
        }
    }
}

/// Planetary dignity classifications
enum PlanetaryDignity: String, CaseIterable, Codable {
    case ruler = "Ruler"
    case exaltation = "Exaltation"
    case detriment = "Detriment"
    case fall = "Fall"
    
    var description: String {
        switch self {
        case .ruler:
            return "Planet operates with full strength and natural expression"
        case .exaltation:
            return "Planet operates with enhanced and elevated expression"
        case .detriment:
            return "Planet operates with challenge and restriction"
        case .fall:
            return "Planet operates with weakening and difficulty"
        }
    }
    
    var strength: Double {
        switch self {
        case .ruler:
            return 1.0
        case .exaltation:
            return 0.9
        case .detriment:
            return 0.3
        case .fall:
            return 0.1
        }
    }
}