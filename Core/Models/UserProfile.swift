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
        wantsReflectionMode: Bool
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
    }
} 