import Foundation

/// Struct for piping onboarding, biometric, and cosmic data into KASPER oracle engine
struct KASPERPrimingPayload: Codable {
    let lifePathNumber: Int
    let soulUrgeNumber: Int
    let expressionNumber: Int
    let userTonePreference: String
    /// Chakra state (optional, to be implemented when available)
    let chakraState: String?
    /// Heartbeats per minute from HealthKit
    let bpm: Int
    /// Current lunar phase descriptor (e.g., "Full Moon", "Waxing Crescent")
    let lunarPhase: String
    /// Dominant planet influencing today's alignment
    let dominantPlanet: String
    /// Daily realm number from sacred numerology
    let realmNumber: Int
    /// Daily focus number from sacred numerology
    let focusNumber: Int
    /// Proximity-based resonance match score
    let proximityMatchScore: Double
}
