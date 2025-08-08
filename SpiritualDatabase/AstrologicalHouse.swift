import Foundation
import SwiftData

/**
 * AstrologicalHouse - SwiftData Model for KASPER MLX House System Training
 * 
 * Represents the 12 astrological houses from Houses.json MegaCorpus data
 * Used by KASPER MLX to provide house-based insights for cosmic snapshots
 * 
 * Houses represent life areas and themes:
 * - 1st House: Self & Identity
 * - 2nd House: Resources & Values  
 * - 3rd House: Communication & Learning
 * - And so on through 12th House: Spirituality & Transcendence
 */
@Model
final class AstrologicalHouse {
    // Primary identifier
    @Attribute(.unique) var houseNumber: Int
    
    // House identity
    var houseName: String               // "First House", "Second House", etc.
    var glyph: String                   // House symbol or roman numeral
    var symbol: String                  // Descriptive symbol (Gateway, Foundation, etc.)
    var keyword: String                 // Core theme (Self, Resources, etc.)
    
    // Astrological correspondences
    var naturalSign: String             // Sign that naturally rules this house
    var element: String                 // Fire, Earth, Air, Water
    var mode: String                    // Cardinal, Fixed, Mutable
    
    // Spiritual content
    var houseDescription: String        // Comprehensive description of house themes
    var keyTraits: [String]            // Life areas governed by this house
    var ritualPrompt: String?          // Suggested spiritual practice
    
    // KASPER MLX training data
    var lifeThemes: [String] = []      // Specific life areas this house governs
    var planetaryMeanings: [String: String] = [:] // How different planets manifest in this house
    var insightExamples: [String] = [] // Example insights for this house
    
    // Usage metadata
    var lastKASPERUpdate: Date?
    var mlxTrainingReady: Bool = false
    
    // Timestamps
    var createdAt: Date
    var updatedAt: Date
    
    init(
        houseNumber: Int,
        houseName: String,
        glyph: String,
        symbol: String,
        keyword: String,
        naturalSign: String,
        element: String,
        mode: String,
        houseDescription: String,
        keyTraits: [String] = [],
        ritualPrompt: String? = nil,
        lifeThemes: [String] = [],
        insightExamples: [String] = []
    ) {
        self.houseNumber = houseNumber
        self.houseName = houseName
        self.glyph = glyph
        self.symbol = symbol
        self.keyword = keyword
        self.naturalSign = naturalSign
        self.element = element
        self.mode = mode
        self.houseDescription = houseDescription
        self.keyTraits = keyTraits
        self.ritualPrompt = ritualPrompt
        self.lifeThemes = lifeThemes
        self.insightExamples = insightExamples
        self.mlxTrainingReady = !houseDescription.isEmpty
        self.createdAt = Date()
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
}

// MARK: - Convenience Methods

extension AstrologicalHouse {
    /// Returns the house classification by number
    var houseType: HouseType {
        switch houseNumber {
        case 1, 4, 7, 10:
            return .angular
        case 2, 5, 8, 11:
            return .succedent
        case 3, 6, 9, 12:
            return .cadent
        default:
            return .cadent
        }
    }
    
    /// Returns key traits as a comma-separated string
    var keyTraitString: String {
        keyTraits.joined(separator: ", ")
    }
    
    /// Returns life themes as a comma-separated string
    var lifeThemeString: String {
        lifeThemes.joined(separator: ", ")
    }
    
    /// Gets a random insight example for KASPER MLX
    var randomInsightExample: String? {
        insightExamples.randomElement()
    }
    
    /// Gets planetary meaning for a specific planet in this house
    func getPlanetaryMeaning(for planet: String) -> String? {
        planetaryMeanings[planet.lowercased()]
    }
    
    /// Updates KASPER MLX training data
    func updateTrainingData(themes: [String], insights: [String], planetaryMeanings: [String: String] = [:]) {
        self.lifeThemes = themes
        self.insightExamples = insights
        self.planetaryMeanings = planetaryMeanings
        self.mlxTrainingReady = !houseDescription.isEmpty && !insights.isEmpty
        self.updatedAt = Date()
        self.lastKASPERUpdate = Date()
    }
    
    /// Checks if this house governs a specific life area
    func governs(lifeArea: String) -> Bool {
        let lowerArea = lifeArea.lowercased()
        return lifeThemes.contains { $0.lowercased().contains(lowerArea) } ||
               keyTraits.contains { $0.lowercased().contains(lowerArea) } ||
               keyword.lowercased().contains(lowerArea)
    }
}

// MARK: - House Classifications

/// Astrological house type classification
enum HouseType: String, CaseIterable, Codable {
    case angular = "Angular"
    case succedent = "Succedent"  
    case cadent = "Cadent"
    
    var description: String {
        switch self {
        case .angular:
            return "Houses of action and initiation (1st, 4th, 7th, 10th)"
        case .succedent:
            return "Houses of stability and resources (2nd, 5th, 8th, 11th)"
        case .cadent:
            return "Houses of learning and adaptation (3rd, 6th, 9th, 12th)"
        }
    }
    
    var houseNumbers: [Int] {
        switch self {
        case .angular:
            return [1, 4, 7, 10]
        case .succedent:
            return [2, 5, 8, 11]
        case .cadent:
            return [3, 6, 9, 12]
        }
    }
}