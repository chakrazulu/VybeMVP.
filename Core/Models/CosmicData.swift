/*
 * ========================================
 * 🌌 COSMIC DATA MODEL - CELESTIAL INFORMATION STRUCTURE
 * ========================================
 * 
 * CORE PURPOSE:
 * Data model representing daily cosmic information including moon phases,
 * planetary positions, and astrological data. Serves as the central structure
 * for all celestial calculations and Firebase cosmic data synchronization.
 * 
 * PHASE 10 INTEGRATION:
 * - Primary Component: Phase 10C iOS App Integration
 * - Firebase Compatible: Codable for Firestore serialization
 * - SwiftUI Ready: Equatable for efficient view updates
 * - Performance: Lightweight structure for quick parsing
 * 
 * DATA SOURCES:
 * - Local Calculations: MoonPhaseCalculator, ZodiacSignCalculator
 * - Firebase Functions: Daily ephemeris data via Swiss Ephemeris
 * - Fallback Strategy: Local calculations when Firebase unavailable
 * 
 * INTEGRATION POINTS:
 * - CosmicService: Fetches and caches cosmic data
 * - RealmNumberView: Displays cosmic snapshot below ruling number
 * - KASPERManager: Includes in spiritual insight generation
 * - NotificationManager: Cosmic event alerts
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Codable: Firebase Firestore serialization support
 * - Equatable: SwiftUI view update optimization
 * - Optional Fields: Graceful handling of partial data
 * - Date Handling: Proper timezone considerations
 */

import Foundation
import FirebaseFirestore
import SwiftAA

/// Comprehensive cosmic data model for celestial information
struct CosmicData: Codable, Equatable {
    
    // MARK: - Core Properties
    
    /// Planetary positions in ecliptic longitude (degrees)
    let planetaryPositions: [String: Double]
    
    /// Current moon age in days (0-29.5)
    let moonAge: Double
    
    /// Human-readable moon phase name
    let moonPhase: String
    
    /// Current sun sign based on date
    let sunSign: String
    
    /// Moon illumination percentage (0-100)
    let moonIllumination: Double?
    
    /// Next full moon date
    let nextFullMoon: Date?
    
    /// Next new moon date
    let nextNewMoon: Date?
    
    /// Creation timestamp from Firebase
    let createdAt: Date?
    
    // MARK: - Computed Properties
    
    /// Check if data is from today
    var isToday: Bool {
        guard let created = createdAt else { return false }
        return Calendar.current.isDateInToday(created)
    }
    
    /// Get moon phase emoji for UI display
    var moonPhaseEmoji: String {
        switch moonPhase.lowercased() {
        case "new moon": return "🌑"
        case "waxing crescent": return "🌒"
        case "first quarter": return "🌓"
        case "waxing gibbous": return "🌔"
        case "full moon": return "🌕"
        case "waning gibbous": return "🌖"
        case "last quarter": return "🌗"
        case "waning crescent": return "🌘"
        default: return "🌙"
        }
    }
    
    /// Get sun sign emoji for UI display
    var sunSignEmoji: String {
        switch sunSign.lowercased() {
        case "aries": return "♈"
        case "taurus": return "♉"
        case "gemini": return "♊"
        case "cancer": return "♋"
        case "leo": return "♌"
        case "virgo": return "♍"
        case "libra": return "♎"
        case "scorpio": return "♏"
        case "sagittarius": return "♐"
        case "capricorn": return "♑"
        case "aquarius": return "♒"
        case "pisces": return "♓"
        default: return "⭐"
        }
    }
    
    // MARK: - Planetary Position Helpers
    
    /// Get position for a specific planet
    func position(for planet: String) -> Double? {
        return planetaryPositions[planet]
    }
    
    /// Get zodiac sign for a planet based on its position
    func zodiacSign(for planet: String) -> String? {
        guard let position = planetaryPositions[planet] else { return nil }
        
        // Each sign is 30 degrees
        let signIndex = Int(position / 30)
        let signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
                     "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        
        return signs[safe: signIndex % 12]
    }
    
    /// Check if any planet is in retrograde (simplified)
    func isRetrograde(_ planet: String) -> Bool {
        // TODO: Implement retrograde detection based on position changes
        // This requires historical data comparison
        return false
    }
    
    // MARK: - Spiritual Insights
    
    /// Generate a brief cosmic summary for the day
    var dailyCosmicSummary: String {
        var summary = "\(moonPhaseEmoji) \(moonPhase)"
        
        if let illumination = moonIllumination {
            summary += " (\(Int(illumination))% illuminated)"
        }
        
        summary += " • \(sunSignEmoji) Sun in \(sunSign)"
        
        // Add notable planetary positions
        if let mercurySign = zodiacSign(for: "Mercury") {
            summary += " • Mercury in \(mercurySign)"
        }
        
        return summary
    }
    
    /// Get zodiac sign for a specific planet
    func planetaryZodiacSign(for planet: String) -> String? {
        guard let longitude = planetaryPositions[planet] else { 
            print("🌌 DEBUG: No longitude found for planet \(planet)")
            return nil 
        }
        let sign = Self.getZodiacSign(from: Degree(longitude))
        print("🌌 DEBUG: \(planet) at \(longitude)° = \(sign)")
        return sign
    }
    
    /// Spiritual meaning based on current cosmic configuration
    var spiritualGuidance: String {
        // Combine moon phase and sun sign for guidance
        switch (moonPhase.lowercased(), sunSign.lowercased()) {
        case (let phase, _) where phase.contains("new"):
            return "Time for new beginnings. Set intentions aligned with \(sunSign) energy."
        case (let phase, _) where phase.contains("full"):
            return "Culmination period. Release what no longer serves your \(sunSign) nature."
        case (let phase, _) where phase.contains("waxing"):
            return "Growth phase. Build momentum with \(sunSign) determination."
        case (let phase, _) where phase.contains("waning"):
            return "Reflection time. Integrate lessons through \(sunSign) wisdom."
        default:
            return "Align with cosmic rhythms. Let \(sunSign) guide your spiritual journey."
        }
    }
    
    // MARK: - Initialization
    
    /// Initialize from SwiftAA calculations (enhanced local mode)
    static func fromLocalCalculations(for date: Date = Date()) -> CosmicData {
        return fromSwiftAACalculations(for: date)
    }
    
    /// Initialize using SwiftAA for accurate astronomical calculations
    static func fromSwiftAACalculations(for date: Date = Date()) -> CosmicData {
        // TEMPORARY: Fall back to old calculations until SwiftAA is debugged
        print("🌌 DEBUG: Using fallback calculations instead of SwiftAA")
        return fromConwayCalculations(for: date)
    }
    
    /// Fallback to Conway's algorithm while debugging SwiftAA
    private static func fromConwayCalculations(for date: Date = Date()) -> CosmicData {
        let moonInfo = MoonPhaseCalculator.moonInfo(for: date)
        
        // Simple zodiac calculation based on day of year
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let zodiacSigns = ["Capricorn", "Aquarius", "Pisces", "Aries", "Taurus", "Gemini", 
                          "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius"]
        let signIndex = ((dayOfYear - 1) / 30) % 12
        let sunSign = zodiacSigns[signIndex]
        
        // Mock planetary positions for now
        let planetaryPositions: [String: Double] = [
            "Sun": Double(signIndex * 30 + 15), // Mid-sign position
            "Moon": moonInfo.age * 12.0, // Approximate moon position
            "Mercury": Double((dayOfYear + 10) % 360),
            "Venus": Double((dayOfYear + 20) % 360),
            "Mars": Double((dayOfYear + 30) % 360)
        ]
        
        return CosmicData(
            planetaryPositions: planetaryPositions,
            moonAge: moonInfo.age,
            moonPhase: moonInfo.phase.rawValue,
            sunSign: sunSign,
            moonIllumination: moonInfo.illumination,
            nextFullMoon: nil,
            nextNewMoon: nil,
            createdAt: date
        )
    }
    
    // MARK: - SwiftAA Helper Methods
    
    /// Convert moon phase angle to descriptive name
    private static func getMoonPhaseName(from phase: Degree) -> String {
        let phaseAngle = phase.value
        
        switch phaseAngle {
        case 0..<45:
            return "New Moon"
        case 45..<90:
            return "Waxing Crescent"
        case 90..<135:
            return "First Quarter"
        case 135..<180:
            return "Waxing Gibbous"
        case 180..<225:
            return "Full Moon"
        case 225..<270:
            return "Waning Gibbous"
        case 270..<315:
            return "Last Quarter"
        case 315..<360:
            return "Waning Crescent"
        default:
            return "New Moon"
        }
    }
    
    /// Convert ecliptic longitude to zodiac sign
    private static func getZodiacSign(from longitude: Degree) -> String {
        let degrees = longitude.value.truncatingRemainder(dividingBy: 360)
        
        switch degrees {
        case 0..<30:
            return "Aries"
        case 30..<60:
            return "Taurus"
        case 60..<90:
            return "Gemini"
        case 90..<120:
            return "Cancer"
        case 120..<150:
            return "Leo"
        case 150..<180:
            return "Virgo"
        case 180..<210:
            return "Libra"
        case 210..<240:
            return "Scorpio"
        case 240..<270:
            return "Sagittarius"
        case 270..<300:
            return "Capricorn"
        case 300..<330:
            return "Aquarius"
        case 330..<360:
            return "Pisces"
        default:
            return "Aries"
        }
    }
    
    /// Calculate moon age in days from phase angle
    private static func calculateMoonAge(moonPhase: Degree) -> Double {
        // Moon cycle is approximately 29.53 days
        let synodicMonth = 29.530588853
        let phaseAngle = moonPhase.value
        
        // Convert phase angle (0-360°) to days (0-29.53)
        return (phaseAngle / 360.0) * synodicMonth
    }
}

// MARK: - Firestore Integration

extension CosmicData {
    /// Custom keys for Firestore to match Firebase Function output
    enum CodingKeys: String, CodingKey {
        case planetaryPositions = "positions"
        case moonAge
        case moonPhase
        case sunSign
        case moonIllumination
        case nextFullMoon
        case nextNewMoon
        case createdAt
    }
}

// MARK: - Array Extension (using existing safe subscript from project) 