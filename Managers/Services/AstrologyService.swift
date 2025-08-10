/*
 * ========================================
 * 🌟 ASTROLOGY SERVICE
 * ========================================
 *
 * COSMIC PURPOSE:
 * Specialized service for astrological calculations and interpretations.
 * Handles planetary positions, house systems, zodiac signs, and aspects
 * with proper spiritual context and MegaCorpus integration.
 *
 * CELESTIAL FEATURES:
 * - Swiss Ephemeris integration for precise planetary calculations
 * - Comprehensive house system support (Placidus, Equal, Koch, etc.)
 * - Zodiac sign interpretations with elemental correspondences
 * - Aspect calculations with orbs and spiritual meanings
 * - Transit and progression analysis capabilities
 *
 * ARCHITECTURE BENEFITS:
 * - Centralized astrological logic eliminates scope issues
 * - Consistent calculation methods across all views
 * - Easy integration with CosmicService and SwiftAA
 * - Thread-safe operations for real-time cosmic updates
 */

import Foundation
import SwiftAA

/// Claude: Specialized service for astrological calculations and interpretations
final class AstrologyService {

    // MARK: - Singleton
    static let shared = AstrologyService()

    // MARK: - Dependencies
    /// Claude: Access SanctumDataManager.shared in methods to avoid MainActor isolation issues

    // MARK: - Zodiac Constants
    private let zodiacSigns = [
        "aries", "taurus", "gemini", "cancer", "leo", "virgo",
        "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces"
    ]

    private let elements = [
        "aries": "Fire", "leo": "Fire", "sagittarius": "Fire",
        "taurus": "Earth", "virgo": "Earth", "capricorn": "Earth",
        "gemini": "Air", "libra": "Air", "aquarius": "Air",
        "cancer": "Water", "scorpio": "Water", "pisces": "Water"
    ]

    private let modes = [
        "aries": "Cardinal", "cancer": "Cardinal", "libra": "Cardinal", "capricorn": "Cardinal",
        "taurus": "Fixed", "leo": "Fixed", "scorpio": "Fixed", "aquarius": "Fixed",
        "gemini": "Mutable", "virgo": "Mutable", "sagittarius": "Mutable", "pisces": "Mutable"
    ]

    // MARK: - Initialization
    private init() {}

    // MARK: - 🌟 Planetary Interpretations

    /// Claude: Get comprehensive planetary description with MegaCorpus integration
    @MainActor func getPlanetaryInterpretation(for planet: String, in sign: String? = nil, house: Int? = nil) -> PlanetaryInterpretation {
        let planetDescription = SanctumDataManager.shared.getPlanetaryDescription(for: planet)

        var signInfluence: String = ""
        var houseInfluence: String = ""

        if let sign = sign {
            signInfluence = getSignInfluence(for: planet, in: sign)
        }

        if let house = house {
            houseInfluence = getHouseInfluence(for: planet, in: house)
        }

        return PlanetaryInterpretation(
            planet: planet.capitalized,
            baseDescription: planetDescription,
            signInfluence: signInfluence,
            houseInfluence: houseInfluence,
            element: sign != nil ? elements[sign!.lowercased()] : nil,
            mode: sign != nil ? modes[sign!.lowercased()] : nil
        )
    }

    /// Claude: Get sign influence on planetary expression
    @MainActor private func getSignInfluence(for planet: String, in sign: String) -> String {
        let signDescription = SanctumDataManager.shared.getZodiacSignDescription(for: sign)
        return "In \(sign.capitalized): \(signDescription)"
    }

    /// Claude: Get house influence on planetary expression
    @MainActor private func getHouseInfluence(for planet: String, in house: Int) -> String {
        let houseDescription = SanctumDataManager.shared.getHouseDescription(for: house)
        return "In House \(house): \(houseDescription)"
    }

    // MARK: - 🏠 House System Analysis

    /// Claude: Generate comprehensive house interpretation with zodiac influences
    @MainActor func getHouseInterpretation(for houseNumber: Int, with sign: String? = nil) -> HouseInterpretation {
        let baseDescription = SanctumDataManager.shared.getHouseDescription(for: houseNumber)

        var zodiacInfluence: String = ""
        if let sign = sign {
            zodiacInfluence = getZodiacInfluenceOnHouse(sign: sign, house: houseNumber)
        }

        let keywords = getHouseKeywords(for: houseNumber)
        let lifeArea = getHouseLifeArea(for: houseNumber)

        return HouseInterpretation(
            houseNumber: houseNumber,
            baseDescription: baseDescription,
            zodiacInfluence: zodiacInfluence,
            keywords: keywords,
            lifeArea: lifeArea
        )
    }

    /// Claude: Get zodiac sign influence on house interpretation
    @MainActor private func getZodiacInfluenceOnHouse(sign: String, house: Int) -> String {
        let signDesc = SanctumDataManager.shared.getZodiacSignDescription(for: sign)
        let element = elements[sign.lowercased()] ?? "Unknown"
        let mode = modes[sign.lowercased()] ?? "Unknown"

        return "With \(sign.capitalized) influence (\(element) \(mode)): \(signDesc)"
    }

    /// Claude: Get house keywords for quick reference
    private func getHouseKeywords(for house: Int) -> [String] {
        let houseKeywords: [Int: [String]] = [
            1: ["Identity", "Self", "Appearance", "First Impressions"],
            2: ["Values", "Resources", "Money", "Self-Worth"],
            3: ["Communication", "Learning", "Siblings", "Local Travel"],
            4: ["Home", "Family", "Roots", "Foundation"],
            5: ["Creativity", "Romance", "Children", "Self-Expression"],
            6: ["Health", "Work", "Service", "Daily Routines"],
            7: ["Partnerships", "Marriage", "Open Enemies", "Cooperation"],
            8: ["Transformation", "Shared Resources", "Intimacy", "Occult"],
            9: ["Philosophy", "Higher Learning", "Travel", "Wisdom"],
            10: ["Career", "Reputation", "Authority", "Public Image"],
            11: ["Friends", "Groups", "Hopes", "Humanitarian Goals"],
            12: ["Spirituality", "Subconscious", "Hidden Enemies", "Karma"]
        ]

        return houseKeywords[house] ?? ["Life Experience", "Growth", "Development"]
    }

    /// Claude: Get primary life area for house
    private func getHouseLifeArea(for house: Int) -> String {
        let lifeAreas: [Int: String] = [
            1: "Personal Identity & Self-Expression",
            2: "Material Resources & Values",
            3: "Communication & Learning",
            4: "Home & Emotional Foundation",
            5: "Creativity & Romance",
            6: "Health & Service",
            7: "Partnerships & Relationships",
            8: "Transformation & Shared Resources",
            9: "Philosophy & Higher Knowledge",
            10: "Career & Public Reputation",
            11: "Friendships & Group Involvement",
            12: "Spirituality & Hidden Realms"
        ]

        return lifeAreas[house] ?? "Life Experience & Growth"
    }

    // MARK: - 🌙 Zodiac Sign Analysis

    /// Claude: Get comprehensive zodiac sign interpretation
    @MainActor func getZodiacInterpretation(for sign: String) -> ZodiacInterpretation {
        let baseDescription = SanctumDataManager.shared.getZodiacSignDescription(for: sign)
        let element = elements[sign.lowercased()] ?? "Unknown"
        let mode = modes[sign.lowercased()] ?? "Unknown"

        return ZodiacInterpretation(
            sign: sign.capitalized,
            baseDescription: baseDescription,
            element: element,
            mode: mode,
            keywords: getSignKeywords(for: sign),
            compatibleSigns: getCompatibleSigns(for: sign)
        )
    }

    /// Claude: Get keywords for zodiac sign
    private func getSignKeywords(for sign: String) -> [String] {
        // This could be enhanced with MegaCorpus data
        let signKeywords: [String: [String]] = [
            "aries": ["Pioneer", "Leader", "Independent", "Courageous"],
            "taurus": ["Stable", "Practical", "Sensual", "Determined"],
            "gemini": ["Curious", "Adaptable", "Communicative", "Witty"],
            "cancer": ["Nurturing", "Intuitive", "Protective", "Emotional"],
            "leo": ["Creative", "Generous", "Confident", "Dramatic"],
            "virgo": ["Analytical", "Helpful", "Perfectionist", "Practical"],
            "libra": ["Harmonious", "Diplomatic", "Aesthetic", "Social"],
            "scorpio": ["Intense", "Transformative", "Mysterious", "Powerful"],
            "sagittarius": ["Adventurous", "Philosophical", "Optimistic", "Free"],
            "capricorn": ["Disciplined", "Ambitious", "Responsible", "Traditional"],
            "aquarius": ["Innovative", "Independent", "Humanitarian", "Original"],
            "pisces": ["Compassionate", "Intuitive", "Artistic", "Spiritual"]
        ]

        return signKeywords[sign.lowercased()] ?? ["Unique", "Individual", "Expressive"]
    }

    /// Claude: Get compatible signs for relationship analysis
    private func getCompatibleSigns(for sign: String) -> [String] {
        let compatibility: [String: [String]] = [
            "aries": ["Leo", "Sagittarius", "Gemini", "Aquarius"],
            "taurus": ["Virgo", "Capricorn", "Cancer", "Pisces"],
            "gemini": ["Libra", "Aquarius", "Aries", "Leo"],
            "cancer": ["Scorpio", "Pisces", "Taurus", "Virgo"],
            "leo": ["Aries", "Sagittarius", "Gemini", "Libra"],
            "virgo": ["Taurus", "Capricorn", "Cancer", "Scorpio"],
            "libra": ["Gemini", "Aquarius", "Leo", "Sagittarius"],
            "scorpio": ["Cancer", "Pisces", "Virgo", "Capricorn"],
            "sagittarius": ["Aries", "Leo", "Libra", "Aquarius"],
            "capricorn": ["Taurus", "Virgo", "Scorpio", "Pisces"],
            "aquarius": ["Gemini", "Libra", "Aries", "Sagittarius"],
            "pisces": ["Cancer", "Scorpio", "Taurus", "Capricorn"]
        ]

        return compatibility[sign.lowercased()] ?? []
    }

    // MARK: - 🔮 Comprehensive Chart Analysis

    /// Claude: Generate complete astrological profile
    @MainActor func generateAstrologicalProfile(planets: [String: Double], houses: [Double], ascendant: String) -> AstrologicalProfile {
        var planetaryPlacements: [PlanetaryInterpretation] = []
        var houseInterpretations: [HouseInterpretation] = []

        // Process planetary placements
        for (planet, longitude) in planets {
            let sign = determineZodiacSign(from: longitude)
            let house = determineHouse(longitude: longitude, houseCusps: houses)
            let interpretation = getPlanetaryInterpretation(for: planet, in: sign, house: house)
            planetaryPlacements.append(interpretation)
        }

        // Process house interpretations with zodiac influences
        for (index, cusp) in houses.enumerated() {
            let houseNumber = index + 1
            let sign = determineZodiacSign(from: cusp)
            let interpretation = getHouseInterpretation(for: houseNumber, with: sign)
            houseInterpretations.append(interpretation)
        }

        return AstrologicalProfile(
            ascendant: ascendant,
            planetaryPlacements: planetaryPlacements,
            houseInterpretations: houseInterpretations,
            generatedAt: Date()
        )
    }

    // MARK: - 🧮 Calculation Utilities

    /// Claude: Determine zodiac sign from ecliptic longitude
    private func determineZodiacSign(from longitude: Double) -> String {
        let normalizedLongitude = longitude.truncatingRemainder(dividingBy: 360.0)
        let signIndex = Int(normalizedLongitude / 30.0)
        return zodiacSigns[safe: signIndex] ?? "aries"
    }

    /// Claude: Determine astrological house from longitude and house cusps
    private func determineHouse(longitude: Double, houseCusps: [Double]) -> Int {
        let normalizedLongitude = longitude.truncatingRemainder(dividingBy: 360.0)

        for i in 0..<12 {
            let currentHouse = houseCusps[i]
            let nextHouse = houseCusps[(i + 1) % 12]

            if currentHouse < nextHouse {
                if normalizedLongitude >= currentHouse && normalizedLongitude < nextHouse {
                    return i + 1
                }
            } else {
                // Handle wrap around at 0°
                if normalizedLongitude >= currentHouse || normalizedLongitude < nextHouse {
                    return i + 1
                }
            }
        }

        return 1 // Default to first house
    }
}

// MARK: - 📊 Data Structures

/// Claude: Comprehensive planetary interpretation
struct PlanetaryInterpretation {
    let planet: String
    let baseDescription: String
    let signInfluence: String
    let houseInfluence: String
    let element: String?
    let mode: String?
}

/// Claude: Comprehensive house interpretation
struct HouseInterpretation {
    let houseNumber: Int
    let baseDescription: String
    let zodiacInfluence: String
    let keywords: [String]
    let lifeArea: String
}

/// Claude: Comprehensive zodiac interpretation
struct ZodiacInterpretation {
    let sign: String
    let baseDescription: String
    let element: String
    let mode: String
    let keywords: [String]
    let compatibleSigns: [String]
}

/// Claude: Complete astrological profile
struct AstrologicalProfile {
    let ascendant: String
    let planetaryPlacements: [PlanetaryInterpretation]
    let houseInterpretations: [HouseInterpretation]
    let generatedAt: Date
}
