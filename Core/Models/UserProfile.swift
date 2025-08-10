// Core/Models/UserProfile.swift
import Foundation

/**
 * UserProfile: Represents the user's comprehensive psychological, symbolic,
 * and preference data, forming the basis for Vybe's spiritual intelligence.
 *
 * This model stores information gathered during the sacred onboarding initiation
 * and subsequent interactions, enabling personalized insights, AI interactions,
 * and alignment with cosmic rhythms.
 */
struct UserProfile: Codable, Identifiable {
    /// Unique identifier for the user, typically matching the `userID` from authentication.
    var id: String

    // MARK: - Step 1: Core Identity (Numerology Base)
    /// The user's date of birth. Essential for Life Path calculation.
    let birthdate: Date
    /// The user's Life Path number, derived from their birthDate.
    let lifePathNumber: Int
    /// Flag indicating if the `lifePathNumber` is a Master Number (11, 22, 33).
    let isMasterNumber: Bool // Renamed from isMasterLifePath for clarity with Life Path

    // MARK: - Step 2 & 3: Reflection Type & AI Modulation
    /// User-selected spiritual mode or energy they seek to align with.
    /// Determines themes for journaling, insights, and meditations.
    /// E.g., "Manifestation", "Reflection", "Healing"
    let spiritualMode: String
    /// User-preferred tone for app interactions and insights from Vybe.
    /// Shapes the language of daily insights, affirmations, and AI communication.
    /// E.g., "Poetic", "Direct", "Gentle"
    let insightTone: String

    // MARK: - Step 4: Insight Filtering
    /// User-defined tags or themes of importance at their current stage in life.
    /// Used to select relevant themes from insight templates.
    /// E.g., ["Purpose", "Love", "Creativity"]
    let focusTags: [String]

    // MARK: - Step 5 & 6: Cosmic Alignment
    /// User's openness to cosmic influences beyond base numerology.
    /// Prepares for scaling into astrology/NASA APIs.
    /// E.g., "Numerology Only", "Numerology + Moon Phases", "Full Cosmic Integration"
    let cosmicPreference: String
    /// Specific cosmic rhythms the user feels attuned to.
    /// Modulates insight structure and timing (lunar vs. solar vs. number-based).
    /// E.g., ["Moon Phases", "Zodiac Signs", "Solar Events"]
    let cosmicRhythms: [String]

    // MARK: - Step 7: Notification System
    /// User's preferred hour of the day (0-23) to receive whispers or reflect.
    let preferredHour: Int
    /// Flag indicating if the user wants to receive timed "whispers" (notifications).
    let wantsWhispers: Bool

    // MARK: - Step 8: Soul Map (Optional Numerology Deep Dive)
    /// The user's full name as given at birth (optional and private).
    /// Enables full numerology calculation for Soul Urge & Expression numbers.
    let birthName: String?
    /// The user's Soul Urge (Heart's Desire) number, derived from vowels in `birthName`. Optional.
    let soulUrgeNumber: Int?
    /// The user's Expression (Personality/Destiny) number, derived from all letters in `birthName`. Optional.
    let expressionNumber: Int?
    // Master number flags for soulUrge & expression are not stored here;
    // they can be determined by NumerologyService if needed.

    // MARK: - Step 9: UX Personalization
    /// Flag indicating if the user would like to engage in daily mood check-ins or reflective prompts.
    /// Enables future mood-aware insights or journaling rhythms.
    let wantsReflectionMode: Bool

    // MARK: - Location & Timing Enhancement
    /// Birthplace coordinates for accurate natal chart calculations
    /// Stores latitude and longitude of birth location for precise astronomical calculations
    let birthplaceLatitude: Double?
    let birthplaceLongitude: Double?
    /// Human-readable birthplace name (e.g., "Charlotte, NC, USA")
    let birthplaceName: String?
    /// Timezone identifier at birth location (e.g., "America/New_York")
    let birthTimezone: String?

    // MARK: - Phase 11A: Birth Chart Foundation
    /// Claude: Essential natal chart data for personalized spiritual insights
    ///
    /// **🌌 Birth Chart Foundation - Phase 11A Enhancement**
    ///
    /// These properties store calculated astrological data from the user's birth moment,
    /// providing the foundation for personalized cosmic insights and spiritual guidance.
    /// All calculations use SwiftAA Swiss Ephemeris for professional-grade accuracy.
    ///
    /// **🏠 Astrological Houses (Life Areas):**
    /// The 12 houses represent different life areas and are calculated based on
    /// birth time, date, and location using the Placidus house system.
    ///
    /// **🌟 Planetary Positions (Natal Placements):**
    /// Exact zodiac positions of planets at birth moment, stored as ecliptic longitude
    /// degrees (0-360°) for precise astrological interpretation.
    ///
    /// **⚡ Integration Points:**
    /// - CosmicData.fromBirthChart(): Generate natal cosmic data
    /// - KASPER Oracle: Enhanced insights using birth chart context
    /// - Cosmic timing: Compare transits to natal positions
    /// - Spiritual guidance: Birth chart-based personality insights

    /// Rising sign (Ascendant) - how others see you, your outer personality
    let risingSign: String?

    /// Midheaven sign - career, reputation, life direction
    let midheavenSign: String?

    /// Sun sign (already captured in birthdate, but stored for quick access)
    let natalSunSign: String?

    /// Moon sign - emotions, inner world, subconscious needs
    let natalMoonSign: String?

    /// Mercury sign - communication style, thinking patterns
    let natalMercurySign: String?

    /// Venus sign - love style, aesthetic preferences, values
    let natalVenusSign: String?

    /// Mars sign - action style, anger expression, drive
    let natalMarsSign: String?

    /// Jupiter sign - growth areas, luck, expansion
    let natalJupiterSign: String?

    /// Saturn sign - life lessons, discipline, challenges
    let natalSaturnSign: String?

    /// Exact birth time for precise house calculations (if known)
    /// Stored as hour (0-23) and minute (0-59) components
    let birthTimeHour: Int?
    let birthTimeMinute: Int?

    /// Whether birth time is known (affects house accuracy)
    let hasBirthTime: Bool

    /// Dominant element in birth chart (Fire, Earth, Air, Water)
    let dominantElement: String?

    /// Dominant modality in birth chart (Cardinal, Fixed, Mutable)
    let dominantModality: String?

    /// North Node sign - life purpose, spiritual direction
    let northNodeSign: String?

    /// Birth chart calculation timestamp
    let birthChartCalculatedAt: Date?

    // MARK: - Initializer
    init(
        id: String,
        birthdate: Date,
        lifePathNumber: Int,
        isMasterNumber: Bool,
        spiritualMode: String,
        insightTone: String,
        focusTags: [String],
        cosmicPreference: String,
        cosmicRhythms: [String],
        preferredHour: Int,
        wantsWhispers: Bool,
        birthName: String? = nil,
        soulUrgeNumber: Int? = nil,
        expressionNumber: Int? = nil,
        wantsReflectionMode: Bool,
        birthplaceLatitude: Double? = nil,
        birthplaceLongitude: Double? = nil,
        birthplaceName: String? = nil,
        birthTimezone: String? = nil,
        // Phase 11A: Birth Chart Foundation Parameters
        risingSign: String? = nil,
        midheavenSign: String? = nil,
        natalSunSign: String? = nil,
        natalMoonSign: String? = nil,
        natalMercurySign: String? = nil,
        natalVenusSign: String? = nil,
        natalMarsSign: String? = nil,
        natalJupiterSign: String? = nil,
        natalSaturnSign: String? = nil,
        birthTimeHour: Int? = nil,
        birthTimeMinute: Int? = nil,
        hasBirthTime: Bool = false,
        dominantElement: String? = nil,
        dominantModality: String? = nil,
        northNodeSign: String? = nil,
        birthChartCalculatedAt: Date? = nil
    ) {
        self.id = id
        self.birthdate = birthdate
        self.lifePathNumber = lifePathNumber
        self.isMasterNumber = isMasterNumber
        self.spiritualMode = spiritualMode
        self.insightTone = insightTone
        self.focusTags = focusTags
        self.cosmicPreference = cosmicPreference
        self.cosmicRhythms = cosmicRhythms
        self.preferredHour = preferredHour
        self.wantsWhispers = wantsWhispers
        self.birthName = birthName
        self.soulUrgeNumber = soulUrgeNumber
        self.expressionNumber = expressionNumber
        self.wantsReflectionMode = wantsReflectionMode
        self.birthplaceLatitude = birthplaceLatitude
        self.birthplaceLongitude = birthplaceLongitude
        self.birthplaceName = birthplaceName
        self.birthTimezone = birthTimezone

        // Claude: Phase 11A birth chart foundation assignments
        self.risingSign = risingSign
        self.midheavenSign = midheavenSign
        self.natalSunSign = natalSunSign
        self.natalMoonSign = natalMoonSign
        self.natalMercurySign = natalMercurySign
        self.natalVenusSign = natalVenusSign
        self.natalMarsSign = natalMarsSign
        self.natalJupiterSign = natalJupiterSign
        self.natalSaturnSign = natalSaturnSign
        self.birthTimeHour = birthTimeHour
        self.birthTimeMinute = birthTimeMinute
        self.hasBirthTime = hasBirthTime
        self.dominantElement = dominantElement
        self.dominantModality = dominantModality
        self.northNodeSign = northNodeSign
        self.birthChartCalculatedAt = birthChartCalculatedAt
    }
}
