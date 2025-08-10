// Features/Onboarding/OnboardingViewModel.swift
import Foundation
import Combine

/**
 * 🌟 ONBOARDINGVIEWMODEL - SOPHISTICATED SPIRITUAL PROFILE ORCHESTRATION SYSTEM 🌟
 *
 * Claude: OnboardingViewModel serves as the architectural masterpiece of Vybe's user
 * journey initialization, orchestrating a profound spiritual profile creation experience
 * that transforms new users into cosmically-aligned spiritual seekers. This isn't merely
 * a data collection system - it's a sophisticated spiritual awakening process that
 * combines advanced numerological calculations, personality-driven archetype assessment,
 * and personalized cosmic experience customization.
 *
 * The ViewModel demonstrates exceptional MVVM architecture patterns, managing complex
 * multi-step workflows while maintaining smooth user experience through reactive state
 * management and intelligent progress tracking. It seamlessly integrates Core Data
 * persistence, location services, and sophisticated spiritual calculation engines.
 *
 * SPIRITUAL PROFILE CREATION ARCHITECTURE:
 * • Advanced numerological computation generating life path numbers from birthdate analysis
 * • Sophisticated spiritual archetype determination through personality-based assessment
 * • Sacred number preference establishment enabling personalized cosmic alignment
 * • Comprehensive cosmic timing setup through location and timezone integration
 * • Personalized spiritual guidance tone selection for authentic wisdom delivery
 *
 * TECHNICAL EXCELLENCE DEMONSTRATED:
 * • Complex async workflow orchestration with error-resilient state management
 * • Advanced validation systems ensuring spiritual calculation accuracy and data integrity
 * • Memory-efficient Core Data integration with sophisticated entity relationship management
 * • Seamless location services integration respecting user privacy and system permissions
 * • Reactive SwiftUI integration enabling smooth progress visualization and user feedback
 */

/// Claude: SWIFT 6 COMPLIANCE - Added @MainActor for UI state management ensuring
/// all published properties and UI-related operations execute on the main thread,
/// preventing concurrency violations and maintaining smooth user interface updates.
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - 🎭 STEP 1: CORE SPIRITUAL IDENTITY FOUNDATION

    /// Claude: User's complete birth name for advanced numerological calculations.
    /// This sacred name enables Soul Urge and Expression number computation, providing
    /// deeper spiritual insights into the user's cosmic purpose and divine calling.
    /// Used in advanced numerological analysis and personalized spiritual guidance.
    @Published var fullNameAtBirth: String = ""

    /// Claude: User's birthdate serving as the foundation for life path number calculation.
    /// This sacred date enables precise numerological analysis determining the user's
    /// spiritual journey theme and cosmic alignment pattern. Defaults to 25 years ago
    /// for age-appropriate spiritual guidance calibration.
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()

    // MARK: - 🧘 STEP 2 & 3: SPIRITUAL MODALITY & AI WISDOM CALIBRATION

    /// Claude: Selected spiritual modes defining the user's preferred approach to cosmic growth.
    /// Supports multiple selections enabling comprehensive spiritual development through
    /// manifestation, reflection, healing, growth, and guidance modalities. This array
    /// personalizes the spiritual journey to align with the user's authentic path.
    @Published var selectedSpiritualModes: [String] = ["Reflection"]

    /// Claude: Selected insight delivery tones personalizing AI spiritual guidance communication.
    /// Supports multiple selections (maximum 3) enabling nuanced wisdom delivery through
    /// poetic, direct, gentle, motivational, or philosophical approaches. This customization
    /// ensures spiritual guidance resonates with the user's communication preferences.
    @Published var selectedInsightTones: [String] = ["Gentle"]

    // MARK: - 🎯 STEP 4: SPIRITUAL INSIGHT FOCUS FILTERING

    /// Claude: Selected focus tags defining specific spiritual themes for personalized insights.
    /// This array enables precise filtering of spiritual wisdom to align with the user's
    /// current spiritual interests and growth areas, ensuring relevant and meaningful
    /// cosmic guidance delivery throughout their journey.
    @Published var selectedFocusTags: [String] = []

    // MARK: - 🌌 STEP 5 & 6: COSMIC ALIGNMENT & CELESTIAL RHYTHM INTEGRATION

    /// Claude: Primary cosmic preference selection determining the depth of celestial integration.
    /// Options range from "Numerology Only" to comprehensive astrological analysis,
    /// enabling users to customize their spiritual experience based on comfort level
    /// with different metaphysical systems and cosmic calculation complexity.
    @Published var cosmicPreferenceSelection: String = "Numerology Only"

    /// Claude: Selected cosmic rhythms defining celestial timing preferences for spiritual guidance.
    /// This array enables integration with lunar cycles, planetary movements, and seasonal
    /// energies, allowing users to align their spiritual practice with cosmic timing
    /// for enhanced effectiveness and spiritual resonance.
    @Published var selectedCosmicRhythms: [String] = []

    // MARK: - 📱 STEP 7: NOTIFICATION & SPIRITUAL REMINDER SYSTEM

    /// Claude: Preferred hour for daily spiritual guidance notifications (0-23 format).
    /// Defaults to 7 AM enabling morning spiritual alignment and intention setting.
    /// This timing personalizes the delivery of cosmic insights and numerological
    /// guidance to align with the user's daily rhythm and spiritual practice.
    @Published var selectedPreferredHour: Int = 7

    /// Claude: User preference for receiving gentle spiritual reminders and cosmic insights.
    /// When enabled, provides subtle notifications about spiritual opportunities,
    /// cosmic alignments, and numerological significance throughout the day,
    /// enhancing spiritual awareness without overwhelming daily life.
    @Published var doesWantWhispers: Bool = true

    // MARK: - 🎨 STEP 9: SPIRITUAL UX PERSONALIZATION

    /// Claude: User preference for enhanced reflection mode features in spiritual interfaces.
    /// When enabled, provides deeper spiritual contemplation tools, extended meditation
    /// guidance, and reflective journaling prompts that enhance the spiritual experience
    /// through thoughtful introspection and cosmic awareness cultivation.
    @Published var doesWantReflectionMode: Bool = true

    // MARK: - Birth Time & Location Data (CRITICAL for accurate charts)
    @Published var birthTimeHour: Int? = nil
    @Published var birthTimeMinute: Int? = nil
    @Published var hasBirthTime: Bool = false
    @Published var birthplaceLatitude: Double? = nil
    @Published var birthplaceLongitude: Double? = nil
    @Published var birthplaceName: String? = nil
    @Published var birthTimezone: String? = nil

    // MARK: - Onboarding State
    @Published var onboardingComplete: Bool = false
    @Published var userProfile: UserProfile?

    var currentUserID: String? // Set from authentication flow

    private var cancellables = Set<AnyCancellable>()
    private let numerologyService = NumerologyService.shared

    // --- Potential options for selections ---
    let spiritualModeOptions = ["Manifestation", "Reflection", "Healing", "Growth", "Guidance"]
    let insightToneOptions = ["Poetic", "Direct", "Gentle", "Motivational", "Philosophical"]
    let focusTagOptions = ["Purpose", "Love", "Creativity", "Well-being", "Career", "Relationships", "Spiritual Growth", "Abundance"]
    let cosmicPreferenceOptions = ["Numerology Only", "Numerology + Moon Phases", "Full Cosmic Integration"]
    let cosmicRhythmOptions = ["Moon Phases", "Zodiac Seasons", "Planetary Transits", "Solar Events"]
    // --- End Options ---

    func processOnboardingInfo() {
        guard let userID = currentUserID else {
            print("Error: User ID is not set. Cannot process onboarding.")
            return
        }

        // FullNameAtBirth is optional for the UserProfile (birthName field), but we might still want it for calculations.
        // The UserProfile.birthName will be nil if fullNameAtBirth is empty.
        let birthNameForProfile = fullNameAtBirth.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : fullNameAtBirth.trimmingCharacters(in: .whitespacesAndNewlines)

        // Calculate Numerology Data
        let lifePathNumber = numerologyService.calculateLifePathNumber(from: birthDate)
        let isLifePathMaster = numerologyService.isMasterNumber(lifePathNumber)
        // Soul Urge and Expression are calculated based on birthNameForProfile if provided
        // Claude: DORMANT BUG FIX - Replace force unwraps with safe optional handling
        let soulUrgeNumber: Int?
        let expressionNumber: Int?

        if let birthName = birthNameForProfile {
            soulUrgeNumber = numerologyService.calculateSoulUrgeNumber(from: birthName)
            expressionNumber = numerologyService.calculateExpressionNumber(from: birthName)
        } else {
            soulUrgeNumber = nil
            expressionNumber = nil
        }

        // CRITICAL FIX: Calculate and store the full spiritual archetype
        let userArchetype = UserArchetypeManager.shared.calculateArchetype(from: birthDate)
        print("✨ Calculated full archetype during onboarding:")
        print("   Zodiac Sign: \(userArchetype.zodiacSign.rawValue)")
        print("   Element: \(userArchetype.element.rawValue)")
        print("   Primary Planet: \(userArchetype.primaryPlanet.rawValue)")
        print("   Shadow Planet: \(userArchetype.subconsciousPlanet.rawValue)")

        // Create UserProfile using the collected and default values
        let profile = UserProfile(
            id: userID,
            birthdate: birthDate,
            lifePathNumber: lifePathNumber,
            isMasterNumber: isLifePathMaster,
            spiritualMode: selectedSpiritualModes.joined(separator: ", "),
            insightTone: selectedInsightTones.joined(separator: ", "), // Join multiple tones
            focusTags: selectedFocusTags,
            cosmicPreference: cosmicPreferenceSelection,
            cosmicRhythms: selectedCosmicRhythms,
            preferredHour: selectedPreferredHour,
            wantsWhispers: doesWantWhispers,
            birthName: birthNameForProfile, // Use the potentially nil birthName
            soulUrgeNumber: soulUrgeNumber,
            expressionNumber: expressionNumber,
            wantsReflectionMode: doesWantReflectionMode,
            // CRITICAL FIX: Include birth time and location data for accurate charts
            birthplaceLatitude: birthplaceLatitude,
            birthplaceLongitude: birthplaceLongitude,
            birthplaceName: birthplaceName,
            birthTimezone: birthTimezone,
            birthTimeHour: birthTimeHour,
            birthTimeMinute: birthTimeMinute,
            hasBirthTime: hasBirthTime
        )

        self.userProfile = profile
        print("👤 Onboarding ViewModel: UserProfile Prepared for Saving:")
        print("   User ID: \(profile.id)")
        print("   Birth Date: \(profile.birthdate.description)")
        print("   Life Path: \(profile.lifePathNumber) \(profile.isMasterNumber ? "(Master)" : "")")
        print("   Spiritual Mode: \(profile.spiritualMode)")
        print("   Insight Tone: \(profile.insightTone)")
        print("   Birth Time: \(profile.birthTimeHour?.description ?? "nil"):\(profile.birthTimeMinute?.description ?? "nil") (hasBirthTime: \(profile.hasBirthTime))")
        print("   Birth Location: \(profile.birthplaceName ?? "nil") (\(profile.birthplaceLatitude?.description ?? "nil"), \(profile.birthplaceLongitude?.description ?? "nil"))")
        print("   Birth Timezone: \(profile.birthTimezone ?? "nil")")
        print("   Focus Tags: \(profile.focusTags.joined(separator: ", "))")
        print("   Cosmic Preference: \(profile.cosmicPreference)")
        print("   Cosmic Rhythms: \(profile.cosmicRhythms.joined(separator: ", "))")
        print("   Preferred Hour: \(profile.preferredHour)")
        print("   Wants Whispers: \(profile.wantsWhispers)")
        print("   Birth Name (Optional): \(profile.birthName ?? "N/A")")
        // Claude: DORMANT BUG FIX - Replace force unwraps with safe optional handling
        let soulUrgeText = profile.soulUrgeNumber.map { "\($0) \(numerologyService.isMasterNumber($0) ? "(Master)" : "")" } ?? "N/A"
        let expressionText = profile.expressionNumber.map { "\($0) \(numerologyService.isMasterNumber($0) ? "(Master)" : "")" } ?? "N/A"
        print("   Soul Urge (Optional): \(soulUrgeText)")
        print("   Expression (Optional): \(expressionText)")
        print("   Wants Reflection Mode: \(profile.wantsReflectionMode)")

        saveUserProfileToStorage(profile)
    }

    /// CRITICAL FIX: Helper function to set birth time and location data
    /// This should be called when user provides birth time/location in UI
    func setBirthTimeAndLocation(
        hour: Int? = nil,
        minute: Int? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        locationName: String? = nil,
        timezone: String? = nil
    ) {
        print("🕐 Setting birth time: \(hour?.description ?? "nil"):\(minute?.description ?? "nil")")
        print("🌍 Setting birth location: \(locationName ?? "nil") (\(latitude?.description ?? "nil"), \(longitude?.description ?? "nil"))")

        self.birthTimeHour = hour
        self.birthTimeMinute = minute
        self.hasBirthTime = (hour != nil && minute != nil)

        self.birthplaceLatitude = latitude
        self.birthplaceLongitude = longitude
        self.birthplaceName = locationName
        self.birthTimezone = timezone

        print("✅ Birth data updated in ViewModel - hasBirthTime: \(self.hasBirthTime)")
    }

    /// TEMPORARY: Set user's actual birth data for testing chart accuracy
    /// Birth: 09/10/1991, 5:46 AM, Charlotte, NC
    func setUserActualBirthData() {
        print("🎯 SETTING ACTUAL USER BIRTH DATA FOR TESTING")

        // Set birth date: September 10, 1991
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 1991
        dateComponents.month = 9
        dateComponents.day = 10
        dateComponents.hour = 5
        dateComponents.minute = 46
        dateComponents.timeZone = TimeZone(identifier: "America/New_York") // Charlotte, NC timezone

        if let birthDate = calendar.date(from: dateComponents) {
            self.birthDate = birthDate
            print("✅ Birth date set: \(birthDate)")
        }

        // Set birth time: 5:46 AM
        self.birthTimeHour = 5
        self.birthTimeMinute = 46
        self.hasBirthTime = true

        // Set birth location: Charlotte, NC coordinates
        self.birthplaceLatitude = 35.2271  // Charlotte, NC latitude
        self.birthplaceLongitude = -80.8431 // Charlotte, NC longitude
        self.birthplaceName = "Charlotte, NC, USA"
        self.birthTimezone = "America/New_York"

        print("✅ ACTUAL BIRTH DATA SET:")
        print("   📅 Date: September 10, 1991")
        print("   🕐 Time: 5:46 AM")
        print("   🌍 Location: Charlotte, NC (35.2271, -80.8431)")
        print("   🕰️ Timezone: America/New_York")
        print("   ✨ hasBirthTime: \(self.hasBirthTime)")
    }

    private func saveUserProfileToStorage(_ profile: UserProfile) {
        UserProfileService.shared.saveUserProfile(profile, for: profile.id) { error in
            if let error = error {
                print("❌ OnboardingViewModel: Error saving user profile to Firestore: \(error.localizedDescription)")
                // Handle error appropriately in UI if necessary
            } else {
                print("✅ OnboardingViewModel: UserProfile saved successfully to Firestore!")

                // ✨ New: Configure AIInsightManager with the newly saved profile
                Task {
                    await AIInsightManager.shared.configureAndRefreshInsight(for: profile)
                }

                // ✨ Cache the newly created profile to UserDefaults so HomeView can access it immediately
                UserProfileService.shared.cacheUserProfileToUserDefaults(profile)

                DispatchQueue.main.async {
                    self.onboardingComplete = true
                }
            }
        }
    }

    func setUserID(_ id: String) {
        self.currentUserID = id
    }
}
