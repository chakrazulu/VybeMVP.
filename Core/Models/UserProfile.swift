// Core/Models/UserProfile.swift
import Foundation

/**
 * UserProfile: Represents the user's comprehensive numerological and preference data.
 *
 * This model stores information gathered during onboarding and subsequent interactions,
 * forming the basis for personalized insights and AI interactions.
 */
struct UserProfile: Codable, Identifiable {
    /// Unique identifier for the user, typically matching the `userID` from authentication.
    var id: String

    // MARK: - Core Numerology Inputs
    /// The user's full name as given at birth. Used for Soul Urge and Expression calculations.
    var fullNameAtBirth: String?

    /// The user's date of birth. Essential for Life Path calculation.
    var birthDate: Date?

    /// The user's time of birth. Optional, for potential future astrological/advanced numerology features.
    var birthTime: Date?

    /// The user's place of birth (e.g., "City, Country" or coordinates). Optional, for potential future astrological/advanced numerology features.
    var birthLocation: String?

    // MARK: - Calculated Numerology Numbers
    /// The user's Life Path number, derived from their birthDate.
    var lifePathNumber: Int?

    /// Flag indicating if the `lifePathNumber` is a Master Number (11, 22, 33).
    var isMasterLifePath: Bool = false

    /// The user's Soul Urge (Heart's Desire) number, derived from the vowels in `fullNameAtBirth`.
    var soulUrgeNumber: Int?

    /// Flag indicating if the `soulUrgeNumber` is a Master Number (if applicable to Soul Urge).
    var isMasterSoulUrge: Bool = false

    /// The user's Expression (Personality/Destiny) number, derived from all letters in `fullNameAtBirth`.
    var expressionNumber: Int?

    /// Flag indicating if the `expressionNumber` is a Master Number (if applicable to Expression).
    var isMasterExpression: Bool = false

    // MARK: - User Preferences & Personalization
    /// User-selected spiritual mode or archetype (e.g., "Seeker", "Healer", "Creator").
    var spiritualMode: String?

    /// User-preferred tone for app interactions and insights (e.g., "Gentle", "Direct", "Mystical").
    var tonePreference: String?

    /// User-defined tags or themes of interest for personalized content.
    var focusTags: [String]?

    /// User's openness to receiving cosmic guidance or insights.
    var openToCosmicGuidance: Bool = true

    /// User's preferred cosmic rhythms or systems to follow (e.g., "Lunar Cycles", "Planetary Transits").
    var preferredCosmicRhythms: [String]?

    /// User's preferred style for app communication (e.g., "Concise", "Detailed", "Poetic").
    var appCommunicationStyle: String?

    /// Flag indicating if the user consents to daily emotional check-ins.
    var allowDailyEmotionalCheckIn: Bool = false

    // MARK: - Initializers
    init(
        id: String,
        fullNameAtBirth: String? = nil,
        birthDate: Date? = nil,
        birthTime: Date? = nil,
        birthLocation: String? = nil,
        lifePathNumber: Int? = nil,
        isMasterLifePath: Bool = false,
        soulUrgeNumber: Int? = nil,
        isMasterSoulUrge: Bool = false,
        expressionNumber: Int? = nil,
        isMasterExpression: Bool = false,
        spiritualMode: String? = nil,
        tonePreference: String? = nil,
        focusTags: [String]? = nil,
        openToCosmicGuidance: Bool = true,
        preferredCosmicRhythms: [String]? = nil,
        appCommunicationStyle: String? = nil,
        allowDailyEmotionalCheckIn: Bool = false
    ) {
        self.id = id
        self.fullNameAtBirth = fullNameAtBirth
        self.birthDate = birthDate
        self.birthTime = birthTime
        self.birthLocation = birthLocation
        self.lifePathNumber = lifePathNumber
        self.isMasterLifePath = isMasterLifePath
        self.soulUrgeNumber = soulUrgeNumber
        self.isMasterSoulUrge = isMasterSoulUrge
        self.expressionNumber = expressionNumber
        self.isMasterExpression = isMasterExpression
        self.spiritualMode = spiritualMode
        self.tonePreference = tonePreference
        self.focusTags = focusTags
        self.openToCosmicGuidance = openToCosmicGuidance
        self.preferredCosmicRhythms = preferredCosmicRhythms
        self.appCommunicationStyle = appCommunicationStyle
        self.allowDailyEmotionalCheckIn = allowDailyEmotionalCheckIn
    }
} 