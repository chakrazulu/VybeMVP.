import Foundation

// MARK: - KASPER Integration JSON Template
/// Claude: Perfect JSON template for KASPER AI integration
/// This ensures we have the exact data structure ready for AI enhancement

struct KASPERCosmicDataPayload: Codable {
    // MARK: - Core Numerology Data
    let numerology: KASPERNumerology
    
    // MARK: - Live Astrological Data  
    let astrology: KASPERAstrology
    
    // MARK: - User Context
    let user: KASPERUserContext
    
    // MARK: - Temporal Context
    let temporal: KASPERTemporalContext
    
    // MARK: - Request Metadata
    let metadata: KASPERRequestMetadata
}

// MARK: - Numerology Section
struct KASPERNumerology: Codable {
    let rulerNumber: Int                    // Live from focusNumberManager.selectedFocusNumber
    let rulerMeaning: String               // "Leadership breakthrough", "Deep wisdom", etc.
    let rulerColor: String                 // "purple", "red", "gold" - hex codes
    let rulerElement: String               // Traditional numerology element
    
    let realmNumber: Int                   // Live from realmNumberManager.currentRealmNumber
    let realmMeaning: String              // Realm-specific guidance
    let realmInfluence: String            // How realm affects ruler
    
    let lifePath: Int?                    // If we have birth date
    let expression: Int?                  // If we have full name
    let soulUrge: Int?                    // If we have vowels from name
    
    let numerologyHarmony: Double         // How well ruler & realm work together
    let currentCycle: String              // Personal year/month cycle
}

// MARK: - Astrology Section  
struct KASPERAstrology: Codable {
    let dominantAspect: KASPERAspectDetail
    let allActiveAspects: [KASPERAspectDetail]  // Top 5 aspects by orb strength
    
    let planetaryWeather: KASPERPlanetaryWeather
    let moonPhase: KASPERMoonPhase
    let retrogradeStatus: [KASPERRetrograde]
    
    let personalTransits: [KASPERTransit]     // If we have birth data
    let cosmicTiming: KASPERCosmicTiming      // Best times for actions
}

struct KASPERAspectDetail: Codable {
    let planet1: String                   // "Mercury", "Venus", etc.
    let planet1Energy: String            // "mental clarity", "love values"
    let planet1House: Int?               // If we have birth time
    
    let planet2: String                   // "Jupiter", "Mars", etc.  
    let planet2Energy: String            // "growth wisdom", "action drive"
    let planet2House: Int?               // If we have birth time
    
    let aspectType: String                // "trine", "square", "conjunction"
    let aspectSymbol: String             // "△", "□", "☌"
    let aspectMeaning: String            // "harmonizes", "challenges", "merges"
    
    let orb: Double                       // Exactness (closer = stronger)
    let strength: String                  // "very strong", "moderate", "weak"
    let isApplying: Bool                 // Increasing or separating
    let peakDate: Date?                  // When aspect is exact
    
    let lifeArea: String                 // "communication", "relationships", "career"
    let guidance: String                 // Specific advice for this aspect
    let opportunity: String              // What this aspect offers
    let challenge: String                // What to watch out for
}

struct KASPERPlanetaryWeather: Codable {
    let overall: String                   // "harmonious", "challenging", "mixed"
    let dominant: String                 // Which planet has most influence today
    let recommendation: String           // Best activities for current energy
    let avoidance: String               // What to avoid today
}

struct KASPERMoonPhase: Codable {
    let phase: String                    // "waxing crescent", "full moon", etc.
    let percentage: Double               // 0.0 to 1.0
    let nextPhase: String               // What's coming
    let influence: String               // How it affects emotions/intuition
    let bestFor: [String]               // ["manifesting", "releasing", "planning"]
}

struct KASPERRetrograde: Codable {
    let planet: String                   // "Mercury", "Venus", etc.
    let startDate: Date
    let endDate: Date
    let effect: String                  // What areas are affected
    let advice: String                  // How to navigate it
}

struct KASPERTransit: Codable {
    let transitingPlanet: String        // What's moving
    let natalPlanet: String            // What it's affecting in birth chart
    let aspect: String                 // Type of transit
    let startDate: Date
    let exactDate: Date?               // When it's exact
    let endDate: Date
    let intensity: String              // "major", "moderate", "minor"
    let lifeArea: String              // What part of life is affected
    let opportunity: String           // What this transit offers
}

struct KASPERCosmicTiming: Codable {
    let bestTimeToday: String          // "morning", "afternoon", "evening"
    let bestDayThisWeek: String       // "Tuesday", "Friday", etc.
    let bestActions: [String]         // ["communicate", "create", "rest"]
    let avoidActions: [String]        // ["argue", "sign contracts", "start projects"]
    let luckyNumbers: [Int]           // Based on current aspects
    let powerHours: [String]          // Specific times for peak energy
}

// MARK: - User Context
struct KASPERUserContext: Codable {
    let spiritualLevel: String           // "beginner", "intermediate", "advanced"
    let primaryInterests: [String]       // ["numerology", "astrology", "tarot"]
    let communicationStyle: String       // "direct", "poetic", "scientific"
    let preferredInsightLength: String   // "brief", "moderate", "detailed"
    
    let personalChallenges: [String]     // Current life challenges
    let personalGoals: [String]          // What they're working toward
    let previousInsights: [String]       // Last few insights given
    let insightFeedback: [String]        // How they rated past insights
    
    let timezone: String                 // For accurate timing
    let location: KASPERLocation?        // For localized cosmic events
    let birthData: KASPERBirthData?     // If provided
}

struct KASPERLocation: Codable {
    let latitude: Double
    let longitude: Double
    let city: String
    let country: String
}

struct KASPERBirthData: Codable {
    let date: Date
    let time: Date?                     // If known
    let location: KASPERLocation?       // If known
    let isTimeAccurate: Bool           // User confidence in birth time
}

// MARK: - Temporal Context
struct KASPERTemporalContext: Codable {
    let currentDateTime: Date
    let dayOfWeek: String
    let moonPhasePercentage: Double
    let seasonalInfluence: String       // "spring awakening", "winter reflection"
    
    let personalYear: Int               // Numerological personal year
    let personalMonth: Int              // Numerological personal month
    let personalDay: Int                // Numerological personal day
    
    let cosmicEvents: [KASPERCosmicEvent]  // Eclipses, solstices, etc.
    let culturalContext: [String]       // Holidays, collective events
}

struct KASPERCosmicEvent: Codable {
    let name: String                    // "Solar Eclipse", "Mercury Retrograde"
    let date: Date
    let influence: String              // How it affects spirituality
    let preparation: String            // How to prepare
}

// MARK: - Request Metadata  
struct KASPERRequestMetadata: Codable {
    let requestType: String             // "dynamic_island", "lock_screen", "full_insight"
    let maxCharacters: Int             // Space constraints
    let targetAudience: String         // "general", "advanced", "beginner"
    let previousRequests: Int          // How many insights today
    let urgency: String               // "immediate", "routine", "deep_reflection"
    
    let deviceContext: String          // "iPhone", "iPad", "web"
    let batteryLevel: Double?          // To adjust computational complexity
    let networkQuality: String        // "excellent", "poor", "offline"
    
    let experimentalFeatures: [String] // Beta features to test
    let personalizationLevel: Double  // 0.0 (generic) to 1.0 (highly personal)
}

// MARK: - KASPER Response Template
struct KASPERInsightResponse: Codable {
    let insight: KASPERGeneratedInsight
    let confidence: Double              // AI confidence in accuracy (0.0-1.0)
    let sources: [String]              // What data influenced the insight
    let alternativeInsights: [String]  // Other possible interpretations
    let followUpQuestions: [String]    // To deepen understanding
    let recommendedActions: [String]   // Specific things to do
    let nextCheckIn: Date             // When to request another insight
    let learningData: KASPERLearning  // For AI improvement
}

struct KASPERGeneratedInsight: Codable {
    let primary: String                // Main insight text
    let secondary: String?             // Additional context if space allows
    let emotional: String              // Emotional/intuitive layer
    let practical: String              // Practical application
    let spiritual: String              // Deeper spiritual meaning
    
    let powerWords: [String]           // Key concepts to highlight
    let affirmation: String           // Personal affirmation
    let meditation: String?           // Brief meditation prompt
    let visualization: String?       // Quick visualization exercise
}

struct KASPERLearning: Codable {
    let userEngagement: String         // How user typically responds
    let accuracyMarkers: [String]     // Signs insight was accurate
    let improvementAreas: [String]    // Where AI can get better
    let personalityInsights: [String] // What we learned about user
}

// MARK: - Example Usage Template
/*
let cosmicPayload = KASPERCosmicDataPayload(
    numerology: KASPERNumerology(
        rulerNumber: 7,                    // LIVE from focusNumberManager
        rulerMeaning: "Deep wisdom emerges",
        rulerColor: "#800080",             // Purple for 7
        rulerElement: "water",
        
        realmNumber: 5,                    // LIVE from realmNumberManager
        realmMeaning: "Freedom calls for change",
        realmInfluence: "Enhances wisdom through experience",
        
        lifePath: nil,                     // Future enhancement
        expression: nil,
        soulUrge: nil,
        
        numerologyHarmony: 0.73,           // 7-5 compatibility
        currentCycle: "Personal Year 3"
    ),
    
    astrology: KASPERAstrology(
        dominantAspect: KASPERAspectDetail(
            planet1: "Mercury",             // LIVE from SwiftAA calculations
            planet1Energy: "mental clarity",
            planet1House: nil,
            
            planet2: "Jupiter",             // LIVE from SwiftAA calculations  
            planet2Energy: "growth wisdom",
            planet2House: nil,
            
            aspectType: "quincunx",         // LIVE from aspect calculation
            aspectSymbol: "⚻",
            aspectMeaning: "adjusts",
            
            orb: 2.3,                      // LIVE orb calculation
            strength: "moderate",
            isApplying: true,              // LIVE from SwiftAA
            peakDate: Date().addingTimeInterval(86400 * 2),
            
            lifeArea: "communication and learning",
            guidance: "Trust wisdom gained through diverse experiences",
            opportunity: "Mental flexibility leads to breakthrough insights",
            challenge: "Avoid overthinking what requires intuitive knowing"
        ),
        
        allActiveAspects: [],              // Top 5 current aspects
        planetaryWeather: KASPERPlanetaryWeather(
            overall: "introspective",
            dominant: "Mercury",
            recommendation: "Deep thinking and learning",
            avoidance: "Rushing important decisions"
        ),
        
        moonPhase: KASPERMoonPhase(
            phase: "waxing crescent",
            percentage: 0.23,
            nextPhase: "first quarter",
            influence: "Building emotional momentum",
            bestFor: ["planning", "learning", "connecting"]
        ),
        
        retrogradeStatus: [],
        personalTransits: [],
        cosmicTiming: KASPERCosmicTiming(
            bestTimeToday: "evening",
            bestDayThisWeek: "Wednesday",
            bestActions: ["study", "write", "reflect"],
            avoidActions: ["argue", "rush decisions"],
            luckyNumbers: [7, 5, 12],
            powerHours: ["6:00 PM", "9:30 PM"]
        )
    ),
    
    user: KASPERUserContext(
        spiritualLevel: "intermediate",
        primaryInterests: ["numerology", "astrology"],
        communicationStyle: "direct",
        preferredInsightLength: "brief",
        personalChallenges: [],
        personalGoals: [],
        previousInsights: [],
        insightFeedback: [],
        timezone: "America/New_York",
        location: nil,
        birthData: nil
    ),
    
    temporal: KASPERTemporalContext(
        currentDateTime: Date(),
        dayOfWeek: "Wednesday",
        moonPhasePercentage: 0.23,
        seasonalInfluence: "summer expansion",
        personalYear: 3,
        personalMonth: 8,
        personalDay: 15,
        cosmicEvents: [],
        culturalContext: []
    ),
    
    metadata: KASPERRequestMetadata(
        requestType: "dynamic_island",
        maxCharacters: 50,
        targetAudience: "general",
        previousRequests: 1,
        urgency: "routine",
        deviceContext: "iPhone",
        batteryLevel: 0.85,
        networkQuality: "excellent",
        experimentalFeatures: [],
        personalizationLevel: 0.7
    )
)
*/