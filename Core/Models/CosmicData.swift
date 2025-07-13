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

// MARK: - Supporting Structures

/// Claude: Planetary position data from Firebase Functions
struct PlanetaryPosition: Codable, Equatable {
    /// Ecliptic longitude in degrees
    let longitude: Double
    /// Zodiac sign name (e.g., "Cancer")
    let zodiacSign: String
    /// Degree within the zodiac sign (0-30)
    let zodiacDegree: Double
    /// Element (Fire, Earth, Air, Water)
    let element: String
    /// Quality (Cardinal, Fixed, Mutable)
    let quality: String?
    /// Zodiac emoji (e.g., "♋")
    let emoji: String
}

/// Claude: Enhanced moon phase information from Firebase Functions
struct MoonPhaseInfo: Codable, Equatable {
    /// Moon illumination percentage (0-100)
    let illumination: Double
    /// Phase angle in degrees
    let phaseAngle: Double
    /// Human-readable phase name (e.g., "Full Moon")
    let phaseName: String
    /// Phase emoji (e.g., "🌕")
    let emoji: String
    /// Moon's zodiac sign
    let zodiacSign: String
    /// Moon's degree within sign
    let zodiacDegree: Double?
    /// Moon's element
    let element: String?
    /// Spiritual meaning of the phase
    let spiritualMeaning: String
    /// Sacred number associated with phase
    let sacredNumber: Int
}

/// Claude: Sacred numbers from cosmic calculations
struct SacredNumbers: Codable, Equatable {
    /// Cosmic number based on date
    let cosmic: Int?
    /// Moon phase sacred number
    let moon: Int?
    /// Harmony number (cosmic + moon)
    let harmony: Int?
    /// Date breakdown for numerological analysis
    let date: DateNumbers?
}

/// Claude: Date number breakdown for numerology
struct DateNumbers: Codable, Equatable {
    let day: Int
    let month: Int
    let year: Int
}

/// Comprehensive cosmic data model for celestial information
struct CosmicData: Codable, Equatable {
    
    // MARK: - Core Properties
    
    /// Date string in YYYY-MM-DD format
    let date: String
    
    /// Full timestamp from Firebase Functions
    let timestamp: String
    
    /// Planetary positions with zodiac details
    let planets: [String: PlanetaryPosition]
    
    /// Enhanced moon phase information
    let moonPhase: MoonPhaseInfo
    
    /// Spiritual guidance message
    let spiritualGuidance: String
    
    /// Sacred numbers associated with cosmic data
    let sacredNumbers: SacredNumbers
    
    /// Creation timestamp from Firebase (when data was calculated)
    let calculatedAt: Date?
    
    /// Version of the cosmic data format
    let version: String?
    
    // MARK: - Computed Properties
    
    /// Claude: Check if data is from today
    var isToday: Bool {
        let today = DateFormatter.cosmicDateFormatter.string(from: Date())
        return date == today
    }
    
    /// Claude: Get moon phase emoji for UI display
    var moonPhaseEmoji: String {
        return moonPhase.emoji
    }
    
    /// Claude: Get sun sign emoji for UI display (Sun planet)
    var sunSignEmoji: String {
        return planets["Sun"]?.emoji ?? "⭐"
    }
    
    /// Claude: Get current sun sign name
    var sunSign: String {
        return planets["Sun"]?.zodiacSign ?? "Unknown"
    }
    
    /// Claude: Get moon illumination percentage
    var moonIllumination: Double? {
        return moonPhase.illumination
    }
    
    // MARK: - Planetary Position Helpers
    
    /// Claude: Get ecliptic longitude for a specific planet
    func position(for planet: String) -> Double? {
        return planets[planet]?.longitude
    }
    
    /// Claude: Get zodiac sign for a planet
    func zodiacSign(for planet: String) -> String? {
        return planets[planet]?.zodiacSign
    }
    
    /// Claude: Get planetary element for a planet
    func element(for planet: String) -> String? {
        return planets[planet]?.element
    }
    
    /// Claude: Check if any planet is in retrograde (future enhancement)
    func isRetrograde(_ planet: String) -> Bool {
        // Claude: TODO - Implement retrograde detection based on position changes
        // This requires historical data comparison or additional Firebase Functions data
        return false
    }
    
    // MARK: - Spiritual Insights
    
    /// Claude: Generate a brief cosmic summary for the day
    var dailyCosmicSummary: String {
        var summary = "\(moonPhaseEmoji) \(moonPhase.phaseName)"
        
        if let illumination = moonIllumination {
            summary += " (\(Int(illumination))% illuminated)"
        }
        
        summary += " • \(sunSignEmoji) Sun in \(sunSign)"
        
        // Claude: Add notable planetary positions
        if let mercurySign = zodiacSign(for: "Mercury") {
            summary += " • Mercury in \(mercurySign)"
        }
        
        return summary
    }
    
    /// Claude: Spiritual guidance comes directly from Firebase Functions
    var cosmicGuidance: String {
        return spiritualGuidance
    }
    
    // MARK: - Initialization
    
    /// Claude: Initialize from local calculations (fallback mode)
    static func fromLocalCalculations(for date: Date = Date()) -> CosmicData {
        let moonInfo = MoonPhaseCalculator.moonInfo(for: date)
        let zodiacInfo = ZodiacSignCalculator.zodiacInfo(for: date)
        
        // Claude: Create basic local data structure
        let formatter = DateFormatter.cosmicDateFormatter
        let dateString = formatter.string(from: date)
        
        // Claude: Create mock planetary positions with Sun only (local fallback)
        let sunPosition = PlanetaryPosition(
            longitude: 0.0, // Claude: Simplified - would need actual calculation
            zodiacSign: zodiacInfo.sign.rawValue,
            zodiacDegree: 0.0,
            element: zodiacInfo.element,
            quality: zodiacInfo.quality,
            emoji: zodiacInfo.sign.emoji
        )
        
        // Claude: Create moon phase info from local calculations
        let moonPhaseInfo = MoonPhaseInfo(
            illumination: moonInfo.illumination,
            phaseAngle: 0.0, // Claude: Not calculated locally
            phaseName: moonInfo.phase.rawValue,
            emoji: moonInfo.phase.emoji,
            zodiacSign: "Unknown", // Claude: Not calculated locally
            zodiacDegree: nil,
            element: nil,
            spiritualMeaning: moonInfo.phase.spiritualMeaning,
            sacredNumber: 1 // Claude: Simplified for local fallback
        )
        
        // Claude: Create basic sacred numbers
        let sacredNumbers = SacredNumbers(
            cosmic: nil,
            moon: nil,
            harmony: nil,
            date: nil
        )
        
        return CosmicData(
            date: dateString,
            timestamp: date.ISO8601Format(),
            planets: ["Sun": sunPosition],
            moonPhase: moonPhaseInfo,
            spiritualGuidance: "Local calculations available. Connect to internet for full cosmic data.",
            sacredNumbers: sacredNumbers,
            calculatedAt: date,
            version: "local-fallback"
        )
    }
}

// MARK: - DateFormatter Extension

extension DateFormatter {
    /// Claude: Shared date formatter for cosmic data consistency
    static let cosmicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()
}

// MARK: - Firestore Integration

extension CosmicData {
    /// Claude: CodingKeys match Firebase Functions output exactly
    enum CodingKeys: String, CodingKey {
        case date
        case timestamp  
        case planets
        case moonPhase
        case spiritualGuidance
        case sacredNumbers
        case calculatedAt
        case version
    }
}

// MARK: - Array Extension (using existing safe subscript from project) 