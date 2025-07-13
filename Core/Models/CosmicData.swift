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
    
    /// Initialize from local calculations (fallback mode)
    static func fromLocalCalculations(for date: Date = Date()) -> CosmicData {
        let moonInfo = MoonPhaseCalculator.moonInfo(for: date)
        let zodiacInfo = ZodiacSignCalculator.zodiacInfo(for: date)
        
        return CosmicData(
            planetaryPositions: [:], // No planetary data in local mode
            moonAge: moonInfo.age,
            moonPhase: moonInfo.phase.rawValue,
            sunSign: zodiacInfo.sign.rawValue,
            moonIllumination: moonInfo.illumination,
            nextFullMoon: nil, // TODO: Calculate from moon age
            nextNewMoon: nil,  // TODO: Calculate from moon age
            createdAt: date
        )
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