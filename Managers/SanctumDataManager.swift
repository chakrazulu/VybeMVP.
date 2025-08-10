/*
 * ========================================
 * 🔮 SANCTUM DATA MANAGER
 * ========================================
 *
 * SPIRITUAL PURPOSE:
 * Centralized service for all spiritual data access within the Sanctum.
 * Provides MegaCorpus integration, numerological calculations, and
 * astrological insights while maintaining the sacred integrity of the data.
 *
 * SOLVES SCOPE ISSUES:
 * - Global access to spiritual data without scope conflicts
 * - Centralized MegaCorpus loading and caching
 * - Consistent data access patterns across all Sanctum components
 * - Thread-safe spiritual data operations
 *
 * ARCHITECTURE BENEFITS:
 * - Single source of truth for spiritual data
 * - Eliminates duplicate MegaCorpus loading logic
 * - Provides consistent fallback mechanisms
 * - Enables easier testing and maintenance
 */

import Foundation
import SwiftUI
import Combine

/// Claude: Centralized manager for all Sanctum spiritual data access
@MainActor
final class SanctumDataManager: ObservableObject {

    // MARK: - Singleton
    static let shared = SanctumDataManager()

    // MARK: - Published Properties
    @Published private(set) var megaCorpusData: [String: Any] = [:]
    @Published private(set) var isDataLoaded: Bool = false
    @Published private(set) var lastLoadError: String?

    // MARK: - Private Properties
    private var dataLoadingTask: Task<Void, Never>?
    private let dataQueue = DispatchQueue(label: "com.vybe.sanctum.data", qos: .userInitiated)

    // MARK: - Initialization
    private init() {
        loadMegaCorpusData()
    }

    // MARK: - 📚 MegaCorpus Data Loading

    /// Claude: Load all MegaCorpus spiritual data files
    /// Provides centralized loading with caching and error handling
    func loadMegaCorpusData() {
        guard !isDataLoaded else { return }

        dataLoadingTask = Task { @MainActor in
            let fileNames = [
                "Signs", "Planets", "Houses", "Aspects", "Elements",
                "Modes", "MoonPhases", "ApparentMotion", "Numerology"
            ]

            var loadedData: [String: Any] = [:]
            var hasErrors = false

            for fileName in fileNames {
                do {
                    let data = try await loadSingleMegaCorpusFile(fileName)
                    loadedData[fileName.lowercased()] = data
                } catch {
                    print("⚠️ SanctumDataManager: Failed to load \(fileName).json - \(error)")
                    hasErrors = true
                }
            }

            self.megaCorpusData = loadedData
            self.isDataLoaded = !loadedData.isEmpty
            self.lastLoadError = hasErrors ? "Some MegaCorpus files failed to load" : nil

            print("🔮 SanctumDataManager: Loaded \(loadedData.count)/\(fileNames.count) MegaCorpus files")
        }
    }

    /// Claude: Load a single MegaCorpus JSON file with multiple path fallbacks
    private func loadSingleMegaCorpusFile(_ fileName: String) async throws -> [String: Any] {
        let possiblePaths = [
            Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "NumerologyData/MegaCorpus"),
            Bundle.main.path(forResource: fileName, ofType: "json"),
            Bundle.main.path(forResource: "MegaCorpus/\(fileName)", ofType: "json"),
            "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/NumerologyData/MegaCorpus/\(fileName).json"
        ]

        for path in possiblePaths.compactMap({ $0 }) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    return json
                }
            } catch {
                continue // Try next path
            }
        }

        throw SanctumDataError.fileNotFound(fileName)
    }

    // MARK: - 🔮 Numerology Services

    /// Claude: Generate life path description using MegaCorpus data or meaningful fallback
    func getLifePathDescription(for number: Int, isMaster: Bool) -> String {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any] else {
            return generateNumerologyFallback(for: number, isMaster: isMaster, type: "Life Path")
        }

        if isMaster {
            if let masterNumbers = numerology["masterNumbers"] as? [String: Any],
               let masterData = masterNumbers[String(number)] as? [String: Any],
               let name = masterData["name"] as? String,
               let description = masterData["description"] as? String {
                return "\(name): \(description)"
            }
        } else {
            if let focusNumbers = numerology["focusNumbers"] as? [String: Any],
               let numberData = focusNumbers[String(number)] as? [String: Any],
               let archetype = numberData["archetype"] as? String {
                return archetype
            }
        }

        return generateNumerologyFallback(for: number, isMaster: isMaster, type: "Life Path")
    }

    /// Claude: Generate soul urge description using MegaCorpus data or meaningful fallback
    func getSoulUrgeDescription(for number: Int, isMaster: Bool) -> String {
        // TODO: Implement when you're ready to add real soul urge content
        return generateNumerologyFallback(for: number, isMaster: isMaster, type: "Soul Urge")
    }

    /// Claude: Generate expression description using MegaCorpus data or meaningful fallback
    func getExpressionDescription(for number: Int, isMaster: Bool) -> String {
        // TODO: Implement when you're ready to add real expression content
        return generateNumerologyFallback(for: number, isMaster: isMaster, type: "Expression")
    }

    /// Claude: Generate meaningful fallback content for Divine Triangle
    private func generateNumerologyFallback(for number: Int, isMaster: Bool, type: String) -> String {
        if isMaster {
            switch number {
            case 11:
                return "Master \(type) 11: The Intuitive Illuminator - A soul here to inspire others through heightened intuition and spiritual insight."
            case 22:
                return "Master \(type) 22: The Master Builder - A soul here to manifest large-scale visions into practical reality."
            case 33:
                return "Master \(type) 33: The Master Teacher - A soul here to uplift humanity through compassionate service and wisdom."
            case 44:
                return "Master \(type) 44: The Master Healer - A soul here to bring healing and transformation to the world."
            default:
                return "Master \(type) \(number): A soul walking the path of spiritual mastery and service."
            }
        } else {
            let archetypes = [
                1: "The Pioneer - Independent, innovative, and naturally leading others forward.",
                2: "The Diplomat - Cooperative, sensitive, and gifted at bringing harmony to relationships.",
                3: "The Creative - Expressive, optimistic, and here to inspire joy through artistic gifts.",
                4: "The Builder - Practical, reliable, and dedicated to creating solid foundations.",
                5: "The Explorer - Adventurous, curious, and drawn to freedom and new experiences.",
                6: "The Nurturer - Caring, responsible, and devoted to family and community service.",
                7: "The Mystic - Analytical, spiritual, and seeking deeper truths beyond the material world.",
                8: "The Executive - Ambitious, authoritative, and here to achieve material success with integrity.",
                9: "The Humanitarian - Compassionate, generous, and dedicated to serving the greater good."
            ]

            if let archetype = archetypes[number] {
                return "\(type) \(archetype)"
            } else {
                return "\(type) Number \(number): A unique spiritual path with its own lessons and gifts to offer."
            }
        }
    }

    // MARK: - 🌟 Astrological Services

    /// Claude: Get planetary description using MegaCorpus data
    func getPlanetaryDescription(for planet: String) -> String {
        guard let planets = self.megaCorpusData["planets"] as? [String: Any],
              let planetsDict = planets["planets"] as? [String: Any],
              let planetData = planetsDict[planet.lowercased()] as? [String: Any] else {
            return "The \(planet.capitalized): A celestial body influencing your spiritual journey."
        }

        if let archetype = planetData["archetype"] as? String,
           let description = planetData["description"] as? String {
            return "\(archetype): \(description)"
        } else if let archetype = planetData["archetype"] as? String {
            return archetype
        }

        return "The \(planet.capitalized): A celestial guide in your cosmic journey."
    }

    /// Claude: Get astrological house description using MegaCorpus data
    func getHouseDescription(for houseNumber: Int) -> String {
        guard let houses = megaCorpusData["houses"] as? [String: Any],
              let housesDict = houses["houses"] as? [String: Any] else {
            return "House \(houseNumber): An area of life experience and growth."
        }

        let ordinalNames = ["first", "second", "third", "fourth", "fifth", "sixth",
                           "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]

        guard houseNumber >= 1 && houseNumber <= 12,
              let houseKey = ordinalNames[safe: houseNumber - 1],
              let houseData = housesDict[houseKey] as? [String: Any] else {
            return "House \(houseNumber): An area of life experience and growth."
        }

        if let name = houseData["name"] as? String,
           let description = houseData["description"] as? String {
            return "\(name): \(description)"
        } else if let name = houseData["name"] as? String,
                  let keyword = houseData["keyword"] as? String {
            return "\(name) - \(keyword)"
        }

        return "House \(houseNumber): An area of life experience and growth."
    }

    /// Claude: Get zodiac sign description using MegaCorpus data
    func getZodiacSignDescription(for sign: String) -> String {
        guard let signs = self.megaCorpusData["signs"] as? [String: Any],
              let signsDict = signs["signs"] as? [String: Any],
              let signData = signsDict[sign.lowercased()] as? [String: Any] else {
            return "\(sign.capitalized): A zodiac sign with unique qualities and characteristics."
        }

        if let name = signData["name"] as? String,
           let description = signData["description"] as? String {
            return "\(name): \(description)"
        } else if let keyword = signData["keyword"] as? String,
                  let element = signData["element"] as? String {
            return "\(sign.capitalized) - \(keyword) (\(element) Sign)"
        }

        return "\(sign.capitalized): A zodiac sign with unique qualities and characteristics."
    }

    // MARK: - 🔧 Utility Methods

    /// Claude: Force reload MegaCorpus data (useful for testing or data updates)
    func reloadData() {
        isDataLoaded = false
        megaCorpusData.removeAll()
        dataLoadingTask?.cancel()
        loadMegaCorpusData()
    }

    /// Claude: Check if specific MegaCorpus file is loaded
    func isFileLoaded(_ fileName: String) -> Bool {
        return megaCorpusData[fileName.lowercased()] != nil
    }

    /// Claude: Get raw MegaCorpus data for specific file (for advanced usage)
    func getRawData(for fileName: String) -> [String: Any]? {
        return megaCorpusData[fileName.lowercased()] as? [String: Any]
    }

    // MARK: - Additional Service Methods

    /// Claude: Get sign element for astrological calculations
    func getSignElement(for sign: String) -> String {
        guard let signs = megaCorpusData["signs"] as? [String: Any],
              let signData = signs[sign.lowercased()] as? [String: Any],
              let element = signData["element"] as? String else {
            return ""
        }
        return element
    }

    /// Claude: Get planetary archetype for mini descriptions
    func getPlanetaryArchetype(for planet: String) -> String {
        guard let planets = megaCorpusData["planets"] as? [String: Any],
              let planetData = planets[planet.lowercased()] as? [String: Any],
              let archetype = planetData["archetype"] as? String else {
            // Fallback archetypes
            switch planet.lowercased() {
            case "sun": return "The Luminary"
            case "moon": return "The Nurturer"
            case "mercury": return "The Messenger"
            case "venus": return "The Lover"
            case "mars": return "The Warrior"
            case "jupiter": return "The Sage"
            case "saturn": return "The Teacher"
            case "uranus": return "The Awakener"
            case "neptune": return "The Mystic"
            case "pluto": return "The Transformer"
            case "ascendant": return "The Rising Self"
            default: return "Celestial Body"
            }
        }
        return archetype
    }

    /// Claude: Get element description for spiritual insights
    func getElementDescription(for element: String) -> String {
        guard let elements = megaCorpusData["elements"] as? [String: Any],
              let elementData = elements[element.lowercased()] as? [String: Any],
              let description = elementData["description"] as? String else {
            // Fallback descriptions
            switch element.lowercased() {
            case "fire": return "Dynamic energy and creative force"
            case "earth": return "Practical wisdom and steadfast endurance"
            case "air": return "Intellectual clarity and social harmony"
            case "water": return "Emotional depth and psychic sensitivity"
            default: return "Elemental energy and spiritual power"
            }
        }
        return description
    }

}

// MARK: - 🚨 Error Types

enum SanctumDataError: LocalizedError {
    case fileNotFound(String)
    case invalidData(String)
    case loadingFailed(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "MegaCorpus file not found: \(fileName).json"
        case .invalidData(let fileName):
            return "Invalid JSON data in: \(fileName).json"
        case .loadingFailed(let reason):
            return "Failed to load spiritual data: \(reason)"
        }
    }
}
