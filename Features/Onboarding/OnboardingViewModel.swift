// Features/Onboarding/OnboardingViewModel.swift
import Foundation
import Combine

// Claude: SWIFT 6 COMPLIANCE - Added @MainActor for UI state management
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Step 1: Core Identity (Numerology Base)
    @Published var fullNameAtBirth: String = "" // User provides this for optional Soul Urge/Expression
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date() // Default to 25 years ago

    // MARK: - Step 2 & 3: Reflection Type & AI Modulation
    @Published var selectedSpiritualModes: [String] = ["Reflection"] // Changed to support multiple selections
    @Published var selectedInsightTones: [String] = ["Gentle"] // Changed to support multiple selections (max 3)

    // MARK: - Step 4: Insight Filtering
    @Published var selectedFocusTags: [String] = []

    // MARK: - Step 5 & 6: Cosmic Alignment
    @Published var cosmicPreferenceSelection: String = "Numerology Only"
    @Published var selectedCosmicRhythms: [String] = []

    // MARK: - Step 7: Notification System
    @Published var selectedPreferredHour: Int = 7 // Default to 7 AM
    @Published var doesWantWhispers: Bool = true

    // MARK: - Step 9: UX Personalization (Step 8 is optional birthName, covered by fullNameAtBirth)
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