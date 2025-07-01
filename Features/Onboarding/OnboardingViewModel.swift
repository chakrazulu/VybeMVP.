// Features/Onboarding/OnboardingViewModel.swift
import Foundation
import Combine

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
        let lifePathResult = numerologyService.calculateLifePathNumber(from: birthDate)
        // Soul Urge and Expression are calculated based on birthNameForProfile if provided
        let soulUrgeResult = birthNameForProfile != nil ? numerologyService.calculateSoulUrgeNumber(from: birthNameForProfile!) : nil
        let expressionResult = birthNameForProfile != nil ? numerologyService.calculateExpressionNumber(from: birthNameForProfile!) : nil

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
            lifePathNumber: lifePathResult.number,
            isMasterNumber: lifePathResult.isMaster,
            spiritualMode: selectedSpiritualModes.joined(separator: ", "),
            insightTone: selectedInsightTones.joined(separator: ", "), // Join multiple tones
            focusTags: selectedFocusTags,
            cosmicPreference: cosmicPreferenceSelection,
            cosmicRhythms: selectedCosmicRhythms,
            preferredHour: selectedPreferredHour,
            wantsWhispers: doesWantWhispers,
            birthName: birthNameForProfile, // Use the potentially nil birthName
            soulUrgeNumber: soulUrgeResult?.number,
            expressionNumber: expressionResult?.number,
            wantsReflectionMode: doesWantReflectionMode
        )
        
        self.userProfile = profile
        print("👤 Onboarding ViewModel: UserProfile Prepared for Saving:")
        print("   User ID: \(profile.id)")
        print("   Birth Date: \(profile.birthdate.description)")
        print("   Life Path: \(profile.lifePathNumber) \(profile.isMasterNumber ? "(Master)" : "")")
        print("   Spiritual Mode: \(profile.spiritualMode)")
        print("   Insight Tone: \(profile.insightTone)")
        print("   Focus Tags: \(profile.focusTags.joined(separator: ", "))")
        print("   Cosmic Preference: \(profile.cosmicPreference)")
        print("   Cosmic Rhythms: \(profile.cosmicRhythms.joined(separator: ", "))")
        print("   Preferred Hour: \(profile.preferredHour)")
        print("   Wants Whispers: \(profile.wantsWhispers)")
        print("   Birth Name (Optional): \(profile.birthName ?? "N/A")")
        print("   Soul Urge (Optional): \(profile.soulUrgeNumber != nil ? String(describing: profile.soulUrgeNumber!) : "N/A") \(soulUrgeResult?.isMaster == true ? "(Master)" : "")")
        print("   Expression (Optional): \(profile.expressionNumber != nil ? String(describing: profile.expressionNumber!) : "N/A") \(expressionResult?.isMaster == true ? "(Master)" : "")")
        print("   Wants Reflection Mode: \(profile.wantsReflectionMode)")

        saveUserProfileToStorage(profile)
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
                    AIInsightManager.shared.configureAndRefreshInsight(for: profile)
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