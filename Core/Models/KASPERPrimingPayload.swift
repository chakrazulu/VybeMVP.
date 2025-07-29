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
    
    // MARK: - Natal Chart Data (CRITICAL INTEGRATION)
    
    /// Complete natal chart data for personalized interpretations
    /// This is the KEY to making KASPER truly personalized rather than template-based
    /// Source: UserProfile natal chart calculations from Swiss Ephemeris
    let natalChart: NatalChartData?
    
    /// Current planetary transits and positions
    /// Source: CosmicDataRepository real-time calculations
    let currentTransits: TransitData?
    
    /// Environmental and timing context
    /// Source: Multiple managers for holistic context
    let environmentalContext: EnvironmentalContext?
    
    /// MegaCorpus spiritual wisdom and interpretations
    /// Source: SanctumDataManager for rich spiritual content
    let megaCorpusData: MegaCorpusExtract?
    
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
        proximityMatchScore: Double,
        natalChart: NatalChartData? = nil,
        currentTransits: TransitData? = nil,
        environmentalContext: EnvironmentalContext? = nil,
        megaCorpusData: MegaCorpusExtract? = nil
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
        self.natalChart = natalChart
        self.currentTransits = currentTransits
        self.environmentalContext = environmentalContext
        self.megaCorpusData = megaCorpusData
    }
}

// MARK: - Supporting Data Structures for Enhanced KASPER Integration

/**
 * NatalChartData: Complete birth chart information for personalized interpretations
 * 
 * This structure contains all the natal chart data needed for KASPER to provide
 * truly personalized spiritual insights rather than generic template responses.
 */
struct NatalChartData: Codable {
    // MARK: - Core Natal Positions
    
    /// Sun sign at birth (core identity, ego, life purpose)
    let sunSign: String?
    
    /// Moon sign at birth (emotions, subconscious, inner needs)
    let moonSign: String?
    
    /// Rising sign/Ascendant (outer personality, how others see you)
    let risingSign: String?
    
    /// Midheaven sign (career, reputation, life direction)
    let midheavenSign: String?
    
    // MARK: - Personal Planets
    
    /// Mercury sign (communication, thinking, learning style)
    let mercurySign: String?
    
    /// Venus sign (love, relationships, aesthetic preferences)
    let venusSign: String?
    
    /// Mars sign (action, energy, anger expression)
    let marsSign: String?
    
    // MARK: - Social Planets
    
    /// Jupiter sign (expansion, luck, growth areas)
    let jupiterSign: String?
    
    /// Saturn sign (discipline, challenges, life lessons)
    let saturnSign: String?
    
    // MARK: - Outer Planets (Optional - for advanced interpretations)
    
    /// Uranus sign (innovation, rebellion, sudden changes)
    let uranusSign: String?
    
    /// Neptune sign (dreams, spirituality, illusion)
    let neptuneSign: String?
    
    /// Pluto sign (transformation, power, deep change)
    let plutoSign: String?
    
    // MARK: - Karmic Points
    
    /// North Node sign (life purpose, spiritual growth direction)
    let northNodeSign: String?
    
    /// South Node sign (past life talents, what to release)
    let southNodeSign: String?
    
    // MARK: - Chart Analysis
    
    /// Dominant element in chart (Fire/Earth/Air/Water)
    let dominantElement: String?
    
    /// Dominant modality (Cardinal/Fixed/Mutable)
    let dominantModality: String?
    
    /// Whether birth time is known (affects house accuracy)
    let hasBirthTime: Bool
    
    /// Birth location for context
    let birthLocation: String?
    
    /// When this chart was calculated
    let calculatedAt: Date?
    
    init(from userProfile: UserProfile) {
        self.sunSign = userProfile.natalSunSign
        self.moonSign = userProfile.natalMoonSign
        self.risingSign = userProfile.risingSign
        self.midheavenSign = userProfile.midheavenSign
        self.mercurySign = userProfile.natalMercurySign
        self.venusSign = userProfile.natalVenusSign
        self.marsSign = userProfile.natalMarsSign
        self.jupiterSign = userProfile.natalJupiterSign
        self.saturnSign = userProfile.natalSaturnSign
        
        // TODO: Add outer planets when available in UserProfile
        self.uranusSign = nil
        self.neptuneSign = nil
        self.plutoSign = nil
        
        self.northNodeSign = userProfile.northNodeSign
        self.southNodeSign = nil // TODO: Calculate from North Node
        
        self.dominantElement = userProfile.dominantElement
        self.dominantModality = userProfile.dominantModality
        self.hasBirthTime = userProfile.hasBirthTime
        self.birthLocation = userProfile.birthplaceName
        self.calculatedAt = userProfile.birthChartCalculatedAt
    }
    
    // Manual initializer for testing and direct creation
    init(
        sunSign: String? = nil,
        moonSign: String? = nil,
        risingSign: String? = nil,
        midheavenSign: String? = nil,
        mercurySign: String? = nil,
        venusSign: String? = nil,
        marsSign: String? = nil,
        jupiterSign: String? = nil,
        saturnSign: String? = nil,
        uranusSign: String? = nil,
        neptuneSign: String? = nil,
        plutoSign: String? = nil,
        northNodeSign: String? = nil,
        southNodeSign: String? = nil,
        dominantElement: String? = nil,
        dominantModality: String? = nil,
        hasBirthTime: Bool = false,
        birthLocation: String? = nil,
        calculatedAt: Date? = nil
    ) {
        self.sunSign = sunSign
        self.moonSign = moonSign
        self.risingSign = risingSign
        self.midheavenSign = midheavenSign
        self.mercurySign = mercurySign
        self.venusSign = venusSign
        self.marsSign = marsSign
        self.jupiterSign = jupiterSign
        self.saturnSign = saturnSign
        self.uranusSign = uranusSign
        self.neptuneSign = neptuneSign
        self.plutoSign = plutoSign
        self.northNodeSign = northNodeSign
        self.southNodeSign = southNodeSign
        self.dominantElement = dominantElement
        self.dominantModality = dominantModality
        self.hasBirthTime = hasBirthTime
        self.birthLocation = birthLocation
        self.calculatedAt = calculatedAt
    }
}

/**
 * TransitData: Current planetary positions and how they interact with natal chart
 * 
 * This provides the dynamic cosmic conditions that change daily and interact
 * with the user's static natal chart to create personalized timing insights.
 */
struct TransitData: Codable {
    // MARK: - Current Planetary Positions
    
    /// Current Moon sign and status
    let currentMoonSign: String
    let moonIsRetrograde: Bool
    let moonNextTransit: String?
    
    /// Current Sun sign
    let currentSunSign: String
    
    /// Current planetary positions for personal planets
    let currentMercury: PlanetaryTransit?
    let currentVenus: PlanetaryTransit?
    let currentMars: PlanetaryTransit?
    
    /// Current outer planet positions
    let currentJupiter: PlanetaryTransit?
    let currentSaturn: PlanetaryTransit?
    let currentUranus: PlanetaryTransit?
    let currentNeptune: PlanetaryTransit?
    let currentPluto: PlanetaryTransit?
    
    // MARK: - Timing Context
    
    /// Current season based on Sun position
    let currentSeason: String
    
    /// Current lunar phase
    let lunarPhase: String
    
    /// When this transit data was calculated
    let calculatedAt: Date
    
    /// Time until next significant transit
    let nextMajorTransit: String?
    
    init(from cosmicSnapshot: CosmicSnapshot) {
        self.currentMoonSign = cosmicSnapshot.moonData.currentSign
        self.moonIsRetrograde = cosmicSnapshot.moonData.isRetrograde
        self.moonNextTransit = cosmicSnapshot.moonData.nextTransit
        
        self.currentSunSign = cosmicSnapshot.sunData.currentSign
        
        // Extract individual planetary data
        self.currentMercury = cosmicSnapshot.planetaryData.first { $0.planet == "Mercury" }.map { PlanetaryTransit(from: $0) }
        self.currentVenus = cosmicSnapshot.planetaryData.first { $0.planet == "Venus" }.map { PlanetaryTransit(from: $0) }
        self.currentMars = cosmicSnapshot.planetaryData.first { $0.planet == "Mars" }.map { PlanetaryTransit(from: $0) }
        self.currentJupiter = cosmicSnapshot.planetaryData.first { $0.planet == "Jupiter" }.map { PlanetaryTransit(from: $0) }
        self.currentSaturn = cosmicSnapshot.planetaryData.first { $0.planet == "Saturn" }.map { PlanetaryTransit(from: $0) }
        self.currentUranus = cosmicSnapshot.planetaryData.first { $0.planet == "Uranus" }.map { PlanetaryTransit(from: $0) }
        self.currentNeptune = cosmicSnapshot.planetaryData.first { $0.planet == "Neptune" }.map { PlanetaryTransit(from: $0) }
        self.currentPluto = cosmicSnapshot.planetaryData.first { $0.planet == "Pluto" }.map { PlanetaryTransit(from: $0) }
        
        self.currentSeason = cosmicSnapshot.currentSeason
        self.lunarPhase = "Current Phase" // TODO: Calculate real lunar phase
        self.calculatedAt = cosmicSnapshot.lastUpdated
        self.nextMajorTransit = nil // TODO: Calculate next major transit
    }
}

/**
 * PlanetaryTransit: Individual planet's current position and movement
 */
struct PlanetaryTransit: Codable {
    let planet: String
    let currentSign: String
    let isRetrograde: Bool
    let nextTransit: String?
    let position: Double? // Exact degree position
    
    init(from planetaryData: PlanetaryData) {
        self.planet = planetaryData.planet
        self.currentSign = planetaryData.currentSign
        self.isRetrograde = planetaryData.isRetrograde
        self.nextTransit = planetaryData.nextTransit
        self.position = planetaryData.position
    }
}

/**
 * EnvironmentalContext: External factors that influence spiritual state
 * 
 * This captures the user's current environment and context to provide
 * grounded, practical spiritual guidance that fits their actual situation.
 */
struct EnvironmentalContext: Codable {
    // MARK: - Location & Weather
    
    /// Current weather conditions
    let weatherConditions: String?
    
    /// Current temperature
    let temperature: String?
    
    /// Current location (city/region for privacy)
    let location: String?
    
    /// Time zone for timing calculations
    let timeZone: String?
    
    // MARK: - Temporal Context
    
    /// Current time of day category
    let timeOfDay: TimeOfDay
    
    /// Day of the week
    let dayOfWeek: String
    
    /// Current date for temporal patterns
    let currentDate: Date
    
    // MARK: - Personal Context
    
    /// User's current energy level (from biometrics or self-report)
    let energyLevel: EnergyLevel?
    
    /// Recent app interaction patterns
    let recentFocus: String?
    
    /// Time since last spiritual practice
    let timeSinceLastPractice: TimeInterval?
    
    init() {
        // Initialize with current environmental data
        self.weatherConditions = nil // TODO: Integrate weather API
        self.temperature = nil
        self.location = nil // TODO: Get user's general location
        self.timeZone = TimeZone.current.identifier
        
        let hour = Calendar.current.component(.hour, from: Date())
        self.timeOfDay = TimeOfDay.from(hour: hour)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        self.dayOfWeek = formatter.string(from: Date())
        
        self.currentDate = Date()
        self.energyLevel = nil // TODO: Derive from biometrics
        self.recentFocus = nil
        self.timeSinceLastPractice = nil
    }
}

// MARK: - Supporting Enums

enum TimeOfDay: String, Codable, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
    
    static func from(hour: Int) -> TimeOfDay {
        switch hour {
        case 5..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<21: return .evening
        default: return .night
        }
    }
}

enum EnergyLevel: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case unknown = "Unknown"
}

/**
 * MegaCorpusExtract: Relevant spiritual wisdom and interpretations from MegaCorpus
 * 
 * This structure contains the most relevant spiritual interpretations and wisdom
 * from the MegaCorpus database that apply to the user's current spiritual state.
 */
struct MegaCorpusExtract: Codable {
    // MARK: - Sign Interpretations
    
    /// Interpretation data for relevant zodiac signs
    let signInterpretations: [String: SignInterpretation]
    
    /// Planetary meaning and influences
    let planetaryMeanings: [String: PlanetaryMeaning]
    
    /// Elemental guidance and characteristics
    let elementalGuidance: [String: ElementalGuidance]
    
    /// Numerological insights and patterns
    let numerologicalInsights: [String: NumerologicalInsight]
    
    /// Current lunar phase wisdom
    let lunarPhaseWisdom: LunarPhaseWisdom?
    
    /// Aspect interpretations (if available)
    let aspectInterpretations: [AspectInterpretation]
    
    /// When this extract was generated
    let extractedAt: Date
    
    init(
        signInterpretations: [String: SignInterpretation] = [:],
        planetaryMeanings: [String: PlanetaryMeaning] = [:],
        elementalGuidance: [String: ElementalGuidance] = [:],
        numerologicalInsights: [String: NumerologicalInsight] = [:],
        lunarPhaseWisdom: LunarPhaseWisdom? = nil,
        aspectInterpretations: [AspectInterpretation] = [],
        extractedAt: Date = Date()
    ) {
        self.signInterpretations = signInterpretations
        self.planetaryMeanings = planetaryMeanings
        self.elementalGuidance = elementalGuidance
        self.numerologicalInsights = numerologicalInsights
        self.lunarPhaseWisdom = lunarPhaseWisdom
        self.aspectInterpretations = aspectInterpretations
        self.extractedAt = extractedAt
    }
}

// MARK: - MegaCorpus Component Structures

struct SignInterpretation: Codable {
    let sign: String
    let element: String
    let modality: String
    let rulingPlanet: String
    let keyTraits: String
    let spiritualMeaning: String
}

struct PlanetaryMeaning: Codable {
    let planet: String
    let archetype: String
    let influence: String
    let spiritualPurpose: String
    let currentRelevance: String
}

struct ElementalGuidance: Codable {
    let element: String
    let characteristics: String
    let guidance: String
    let balancingElements: [String]
}

struct NumerologicalInsight: Codable {
    let number: Int
    let meaning: String
    let spiritualSignificance: String
    let guidanceMessage: String
}

struct LunarPhaseWisdom: Codable {
    let phase: String
    let energy: String
    let guidance: String
    let ritualSuggestions: String
}

struct AspectInterpretation: Codable {
    let aspectType: String
    let planets: [String]
    let meaning: String
    let influence: String
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
        
        🌟 Natal Chart Data:
           • Sun: \(natalChart?.sunSign ?? "Unknown")
           • Moon: \(natalChart?.moonSign ?? "Unknown")
           • Rising: \(natalChart?.risingSign ?? "Unknown")
           • Dominant Element: \(natalChart?.dominantElement ?? "Unknown")
           • Has Birth Time: \(natalChart?.hasBirthTime ?? false)
        
        ⚡ Current Transits:
           • Current Sun: \(currentTransits?.currentSunSign ?? "Unknown")
           • Current Moon: \(currentTransits?.currentMoonSign ?? "Unknown")
           • Moon Retrograde: \(currentTransits?.moonIsRetrograde ?? false)
           • Season: \(currentTransits?.currentSeason ?? "Unknown")
        
        🌍 Environmental Context:
           • Time of Day: \(environmentalContext?.timeOfDay.rawValue ?? "Unknown")
           • Day: \(environmentalContext?.dayOfWeek ?? "Unknown")
           • Energy Level: \(environmentalContext?.energyLevel?.rawValue ?? "Unknown")
        
        📚 MegaCorpus Wisdom:
           • Sign Interpretations: \(megaCorpusData?.signInterpretations.count ?? 0) available
           • Planetary Meanings: \(megaCorpusData?.planetaryMeanings.count ?? 0) available
           • Elemental Guidance: \(megaCorpusData?.elementalGuidance.count ?? 0) available
           • Numerology Insights: \(megaCorpusData?.numerologicalInsights.count ?? 0) available
           • Lunar Phase Wisdom: \(megaCorpusData?.lunarPhaseWisdom?.phase ?? "Not Available")
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