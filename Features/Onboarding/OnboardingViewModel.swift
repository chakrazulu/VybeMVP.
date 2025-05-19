// Features/Onboarding/OnboardingViewModel.swift
import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var fullNameAtBirth: String = ""
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date() // Default to 25 years ago
    @Published var onboardingComplete: Bool = false
    @Published var userProfile: UserProfile?

    // Assuming you have a way to get the current user's ID after sign-in
    // This should be set from your authentication flow.
    var currentUserID: String? // Example: "someUserID"

    private var cancellables = Set<AnyCancellable>()
    private let numerologyService = NumerologyService.shared

    func processOnboardingInfo() {
        guard let userID = currentUserID else {
            print("Error: User ID is not set. Cannot process onboarding.")
            // Handle this error appropriately, perhaps show an alert to the user.
            return
        }

        guard !fullNameAtBirth.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Error: Full name at birth is required.")
            // Handle this error, e.g., show an alert.
            return
        }

        // Calculate Numerology Data
        let lifePathResult = numerologyService.calculateLifePathNumber(from: birthDate)
        let soulUrgeResult = numerologyService.calculateSoulUrgeNumber(from: fullNameAtBirth)
        let expressionResult = numerologyService.calculateExpressionNumber(from: fullNameAtBirth)

        // Create UserProfile
        let profile = UserProfile(
            id: userID, // Use the actual authenticated user ID
            fullNameAtBirth: fullNameAtBirth,
            birthDate: birthDate,
            lifePathNumber: lifePathResult.number,
            isMasterLifePath: lifePathResult.isMaster,
            soulUrgeNumber: soulUrgeResult?.number,
            isMasterSoulUrge: soulUrgeResult?.isMaster ?? false,
            expressionNumber: expressionResult?.number,
            isMasterExpression: expressionResult?.isMaster ?? false
            // We can add other fields from UserProfile here if we collect them during this initial onboarding
        )
        
        self.userProfile = profile
        print("👤 Onboarding Complete. UserProfile Created:")
        print("   User ID: \(profile.id)")
        print("   Full Name: \(profile.fullNameAtBirth ?? "N/A")")
        print("   Birth Date: \(profile.birthDate?.description ?? "N/A")")
        print("   Life Path: \(profile.lifePathNumber ?? 0) \(profile.isMasterLifePath ? "(Master)" : "")")
        print("   Soul Urge: \(profile.soulUrgeNumber ?? 0) \(profile.isMasterSoulUrge ? "(Master)" : "")")
        print("   Expression: \(profile.expressionNumber ?? 0) \(profile.isMasterExpression ? "(Master)" : "")")

        // TODO: Save the userProfile to Firestore or CoreData
        // For now, we'll just mark onboarding as complete for UI transition
        saveUserProfileToStorage(profile) // Placeholder for actual saving
    }

    private func saveUserProfileToStorage(_ profile: UserProfile) {
        // This is where you would implement saving to Firestore or Core Data
        // For example, using a UserProfileService:
        UserProfileService.shared.saveUserProfile(profile, for: profile.id) { error in
            if let error = error {
                print("❌ OnboardingViewModel: Error saving user profile to Firestore: \(error.localizedDescription)")
                // Handle error (e.g., show alert to the user, allow retry)
                // For now, we are not setting onboardingComplete to true on error.
            } else {
                print("✅ OnboardingViewModel: UserProfile saved successfully to Firestore!")
                DispatchQueue.main.async {
                    self.onboardingComplete = true
                }
            }
        }
        
        // TEMPORARY: Simulate successful save for UI flow
        // print("🚧 (Temporary) Profile saving step. Marking onboarding as complete.")
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Simulate async save
        //     self.onboardingComplete = true
        // }
    }
    
    // Call this method from your sign-in flow to set the user ID
    func setUserID(_ id: String) {
        self.currentUserID = id
    }
} 