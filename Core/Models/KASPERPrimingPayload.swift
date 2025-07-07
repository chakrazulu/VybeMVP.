/**
 * Filename: KASPERPrimingPayload.swift
 * 
 * 🎯 COMPREHENSIVE DATA STRUCTURE REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Central data structure for the Knowledge-Activated Spiritual Pattern & Expression Renderer (KASPER).
 * This payload aggregates all spiritual, biometric, and cosmic data needed for AI-powered oracle insights.
 * 
 * === KASPER ORACLE ENGINE ===
 * KASPER is VybeMVP's forthcoming AI framework that generates:
 * • Personalized daily spiritual insights
 * • Meditation suggestions based on BPM and chakra state
 * • Spiritual weather summaries with cosmic timing
 * • Affirmation generation aligned to chakra and number patterns
 * • Dream interpretation and karmic pattern analysis (future)
 * 
 * === DATA INGESTION PIPELINE ===
 * This payload structure captures data from:
 * • UserProfile: Core numerological identity (Life Path, Soul Urge, Expression)
 * • Spiritual Preferences: User-selected tone and mode (Manifestation, Reflection, etc.)
 * • Daily Calculations: Real-time Focus and Realm numbers from cosmic algorithms
 * • Biometric Data: Heart rate from HealthKit, chakra state from user interactions
 * • Cosmic Data: Lunar phases, planetary alignments from astrology APIs
 * • Social Data: Proximity matches and resonance scores from location services
 * 
 * === FIELD SPECIFICATIONS ===
 * 
 * NUMEROLOGICAL CORE:
 * • lifePathNumber: Primary spiritual identity number (1-9, including master 11,22,33,44)
 * • soulUrgeNumber: Heart's desire calculated from vowels in birth name
 * • expressionNumber: Destiny number from full birth name consonants + vowels
 * 
 * SPIRITUAL PREFERENCES:
 * • userTonePreference: Selected spiritual mode ("Manifestation", "Reflection", "Healing", etc.)
 * 
 * BIOMETRIC INTEGRATION:
 * • bpm: Current heart rate from HealthKit (real or simulated fallback)
 * • chakraState: Meditation/chakra interaction state (optional, future implementation)
 * 
 * COSMIC TIMING:
 * • lunarPhase: Current moon phase ("Full Moon", "Waxing Crescent", etc.)
 * • dominantPlanet: Primary planetary influence for the day ("Venus", "Mars", etc.)
 * 
 * DAILY SACRED NUMBERS:
 * • realmNumber: Cosmic state number calculated from time/date/location/BPM
 * • focusNumber: User-selected focus intention number (1-9)
 * 
 * SOCIAL RESONANCE:
 * • proximityMatchScore: Location-based spiritual compatibility score (0.0-1.0)
 * 
 * === INTEGRATION POINTS ===
 * 
 * DATA SOURCES:
 * • UserProfileService: Numerological core data from onboarding
 * • HealthKitManager: Real-time BPM data with simulation fallback
 * • RealmNumberManager: Dynamic cosmic state calculations
 * • FocusNumberManager: User intention and match detection
 * • AstrologyManager: Lunar and planetary data (Phase 8 implementation)
 * • ProximityManager: Location-based spiritual matching (Phase 9 implementation)
 * 
 * CONSUMERS:
 * • AIInsightManager: Enhanced with KASPER-powered insights
 * • KASPERManager: Central orchestration for payload generation
 * • Oracle Engine: AI interpretation and response generation (Phase 11)
 * 
 * === FUTURE ENHANCEMENT FIELDS ===
 * Additional fields planned for later phases:
 * • dreamJournalData: Sleep cycle and dream pattern analysis
 * • emotionalState: Sentiment analysis from journal entries
 * • meditationHistory: Accumulated mindfulness and chakra work data
 * • synchronicityEvents: Tracked meaningful coincidences and patterns
 * 
 * === TECHNICAL SPECIFICATIONS ===
 * 
 * SERIALIZATION:
 * • Codable: Full JSON serialization support for API integration
 * • Optional Fields: Graceful handling of unavailable data sources
 * • Type Safety: Strict typing for numerological and cosmic data integrity
 * 
 * VALIDATION:
 * • Number Ranges: Life Path (1-9, 11, 22, 33, 44), BPM (40-200), etc.
 * • String Formats: Standardized lunar phase and planet name conventions
 * • Score Ranges: Proximity matching (0.0-1.0) with precision validation
 * 
 * PERFORMANCE:
 * • Lightweight Structure: Minimal memory footprint for real-time generation
 * • Efficient Serialization: Optimized for rapid API communication
 * • Caching Support: Suitable for payload caching and batch processing
 * 
 * === AI ASSISTANT INTEGRATION ===
 * This structure serves as the primary interface between VybeMVP's spiritual data
 * ecosystem and AI-powered oracle insights. Future AI assistants can reference
 * this documentation to understand the complete data flow and spiritual significance
 * of each field in the KASPER system.
 * 
 * === SPIRITUAL INTEGRITY ===
 * All fields maintain numerological accuracy and mystical correspondences.
 * The payload preserves master numbers, lunar timing significance, and planetary
 * influences according to authentic spiritual traditions and astrological principles.
 */

import Foundation

/**
 * KASPERPrimingPayload: Complete spiritual data aggregation for oracle engine
 * 
 * This structure encapsulates all spiritual, biometric, and cosmic data needed
 * for KASPER (Knowledge-Activated Spiritual Pattern & Expression Renderer) to
 * generate personalized insights, affirmations, and spiritual guidance.
 * 
 * The payload is designed to be lightweight, serializable, and comprehensive,
 * serving as the bridge between VybeMVP's data ecosystem and AI-powered oracle
 * capabilities planned for Phase 11 implementation.
 */
struct KASPERPrimingPayload: Codable {
    // MARK: - Numerological Core Identity
    
    /// Primary spiritual life path number derived from birth date
    /// Range: 1-9, including master numbers 11, 22, 33, 44
    /// Source: UserProfile.lifePathNumber via NumerologyService
    let lifePathNumber: Int
    
    /// Soul's desire number calculated from vowels in birth name
    /// Range: 1-9, including master numbers when applicable
    /// Source: UserProfile.soulUrgeNumber (optional field)
    let soulUrgeNumber: Int
    
    /// Expression/Destiny number from complete birth name
    /// Range: 1-9, including master numbers when applicable
    /// Source: UserProfile.expressionNumber (optional field)
    let expressionNumber: Int
    
    // MARK: - Spiritual Preferences & Tone
    
    /// User's selected spiritual mode for AI interactions and insights
    /// Values: "Manifestation", "Reflection", "Healing", "Growth", "Guidance"
    /// Source: UserProfile.insightTone via onboarding spiritual mode selection
    let userTonePreference: String
    
    // MARK: - Biometric & Consciousness Data
    
    /// Current chakra interaction state from meditation and chakra work
    /// Format: "Root:Active,Heart:Balanced,Crown:Opening" (comma-separated states)
    /// Source: ChakraManager chakra interaction tracking (Phase 7 implementation)
    /// Note: Optional field, nil when chakra tracking not available
    let chakraState: String?
    
    /// Current heart rate in beats per minute from HealthKit
    /// Range: 40-200 BPM (physiologically valid range)
    /// Source: HealthKitManager.currentHeartRate with simulation fallback
    let bpm: Int
    
    // MARK: - Cosmic Timing & Astrology
    
    /// Current lunar phase description for cosmic timing alignment
    /// Values: "New Moon", "Waxing Crescent", "First Quarter", "Waxing Gibbous",
    ///         "Full Moon", "Waning Gibbous", "Last Quarter", "Waning Crescent"
    /// Source: AstrologyManager lunar phase API integration (Phase 8 implementation)
    let lunarPhase: String
    
    /// Primary planetary influence for current day/time
    /// Values: "Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn"
    /// Source: AstrologyManager planetary position calculations (Phase 8 implementation)
    let dominantPlanet: String
    
    // MARK: - Daily Sacred Numbers
    
    /// Current cosmic realm number calculated from environmental factors
    /// Range: 1-9 (reduced from time + date + location + BPM + dynamic factors)
    /// Source: RealmNumberManager.currentRealmNumber
    let realmNumber: Int
    
    /// User's selected daily focus intention number
    /// Range: 1-9 (user-selected spiritual focus area)
    /// Source: FocusNumberManager.selectedFocusNumber
    let focusNumber: Int
    
    // MARK: - Social & Proximity Resonance
    
    /// Proximity-based spiritual compatibility score with nearby users
    /// Range: 0.0-1.0 (0.0 = no resonance, 1.0 = perfect spiritual alignment)
    /// Source: ProximityManager match scoring algorithm (Phase 9 implementation)
    let proximityMatchScore: Double
    
    // MARK: - Initialization
    
    /**
     * Initialize KASPER payload with all spiritual and biometric data
     * 
     * This initializer ensures all required fields are provided while gracefully
     * handling optional fields (chakraState) that may not be available in all
     * phases of VybeMVP development.
     * 
     * Parameter validation is performed by the calling KASPERManager to ensure
     * numerological accuracy and data integrity before payload creation.
     */
    init(
        lifePathNumber: Int,
        soulUrgeNumber: Int,
        expressionNumber: Int,
        userTonePreference: String,
        chakraState: String? = nil,
        bpm: Int,
        lunarPhase: String,
        dominantPlanet: String,
        realmNumber: Int,
        focusNumber: Int,
        proximityMatchScore: Double
    ) {
        self.lifePathNumber = lifePathNumber
        self.soulUrgeNumber = soulUrgeNumber
        self.expressionNumber = expressionNumber
        self.userTonePreference = userTonePreference
        self.chakraState = chakraState
        self.bpm = bpm
        self.lunarPhase = lunarPhase
        self.dominantPlanet = dominantPlanet
        self.realmNumber = realmNumber
        self.focusNumber = focusNumber
        self.proximityMatchScore = proximityMatchScore
    }
}

// MARK: - Debug & Development Extensions

extension KASPERPrimingPayload {
    /**
     * Debug description for development and testing
     * 
     * Provides comprehensive payload information for debugging KASPER integration
     * and validating data flow from all VybeMVP spiritual data sources.
     */
    var debugDescription: String {
        return """
        🔮 KASPER Priming Payload Debug Information:
        
        📊 Numerological Core:
           • Life Path: \(lifePathNumber)
           • Soul Urge: \(soulUrgeNumber)
           • Expression: \(expressionNumber)
        
        🎭 Spiritual Preferences:
           • Tone: \(userTonePreference)
        
        💓 Biometric Data:
           • Heart Rate: \(bpm) BPM
           • Chakra State: \(chakraState ?? "Not Available")
        
        🌙 Cosmic Timing:
           • Lunar Phase: \(lunarPhase)
           • Dominant Planet: \(dominantPlanet)
        
        🔢 Sacred Numbers:
           • Realm Number: \(realmNumber)
           • Focus Number: \(focusNumber)
        
        🤝 Social Resonance:
           • Proximity Match Score: \(String(format: "%.2f", proximityMatchScore))
        """
    }
    
    /**
     * Validation for KASPER payload data integrity
     * 
     * Ensures all numerical values are within expected ranges and required
     * string fields contain valid spiritual data before oracle processing.
     */
    var isValid: Bool {
        // Validate numerological numbers (1-9, including masters 11,22,33,44)
        let validNumbers = [1,2,3,4,5,6,7,8,9,11,22,33,44]
        guard validNumbers.contains(lifePathNumber),
              validNumbers.contains(soulUrgeNumber),
              validNumbers.contains(expressionNumber) else {
            return false
        }
        
        // Validate sacred numbers (1-9 only)
        guard (1...9).contains(realmNumber),
              (1...9).contains(focusNumber) else {
            return false
        }
        
        // Validate BPM range (physiologically reasonable)
        guard (40...200).contains(bpm) else {
            return false
        }
        
        // Validate proximity score range
        guard (0.0...1.0).contains(proximityMatchScore) else {
            return false
        }
        
        // Validate required string fields are not empty
        guard !userTonePreference.isEmpty,
              !lunarPhase.isEmpty,
              !dominantPlanet.isEmpty else {
            return false
        }
        
        return true
    }
}