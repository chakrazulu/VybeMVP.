import Foundation
import FirebaseFirestore
// TODO: Add FirebaseFirestore package to Xcode project, then uncomment this line
// import FirebaseFirestore
// If FirebaseFirestoreSwift was available, we'd import it here too.
// import FirebaseFirestoreSwift

/**
 * UserProfileService: Manages interactions with Firestore for user profile data.
 *
 * Responsibilities:
 * - Saving UserProfile objects to Firestore.
 * - Fetching UserProfile objects from Firestore.
 * - Checking if a user profile exists for a given userID.
 */
class UserProfileService {

    static let shared = UserProfileService()
    private let db = Firestore.firestore()

    private var usersCollection: CollectionReference {
        return db.collection("users")
    }

    // MARK: - Initialization
    private init() {
        // Private constructor to ensure singleton usage
        print("👤 UserProfileService initialized with Firestore.")
    }

    // MARK: - UserDefaults Cache Keys
    private func userProfileDefaultsKey(for userID: String) -> String {
        return "cachedUserProfile_\(userID)"
    }

    // MARK: - UserDefaults Caching
    /**
     * Caches the user's profile to UserDefaults.
     * Assumes UserProfile is Codable.
     *
     * - Parameter profile: The UserProfile object to cache.
     */
    func cacheUserProfileToUserDefaults(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userProfileDefaultsKey(for: profile.id))
            print("💾 UserProfileService: Profile for userID \(profile.id) cached to UserDefaults.")
        } else {
            print("⚠️ UserProfileService: Failed to encode profile for userID \(profile.id) for UserDefaults caching.")
        }
    }

    /**
     * Retrieves the cached user's profile from UserDefaults.
     * Assumes UserProfile is Codable.
     *
     * - Parameter userID: The unique ID of the user.
     * - Returns: An optional UserProfile object from the cache.
     */
    func getCurrentUserProfileFromUserDefaults(for userID: String) -> UserProfile? {
        guard let savedProfileData = UserDefaults.standard.data(forKey: userProfileDefaultsKey(for: userID)) else {
            print("ℹ️ UserProfileService: No cached profile found in UserDefaults for userID \(userID).")
            return nil
        }

        let decoder = JSONDecoder()
        if let loadedProfile = try? decoder.decode(UserProfile.self, from: savedProfileData) {
            print("✅ UserProfileService: Profile for userID \(userID) loaded from UserDefaults cache.")
            return loadedProfile
        } else {
            print("⚠️ UserProfileService: Failed to decode cached profile for userID \(userID) from UserDefaults.")
            return nil
        }
    }

    // MARK: - Public Methods

    /**
     * Saves a user's profile to Firestore.
     *
     * - Parameters:
     *   - profile: The UserProfile object to save.
     *   - userID: The unique ID of the user.
     *   - completion: A closure that is called with an optional error.
     */
    func saveUserProfile(_ profile: UserProfile, for userID: String, completion: @escaping (Error?) -> Void) {
        print("UserProfileService: Attempting to save profile for userID: \(userID)")

        // Align with UserProfile.swift properties
        var profileData: [String: Any] = [
            "id": profile.id, // This should match userID
            // Step 1: Core Identity
            "birthdate": Timestamp(date: profile.birthdate),
            "lifePathNumber": profile.lifePathNumber,
            "isMasterNumber": profile.isMasterNumber,

            // Step 2 & 3: Reflection Type & AI Modulation
            "spiritualMode": profile.spiritualMode,
            "insightTone": profile.insightTone,

            // Step 4: Insight Filtering
            "focusTags": profile.focusTags,

            // Step 5 & 6: Cosmic Alignment
            "cosmicPreference": profile.cosmicPreference,
            "cosmicRhythms": profile.cosmicRhythms,

            // Step 7: Notification System
            "preferredHour": profile.preferredHour,
            "wantsWhispers": profile.wantsWhispers,

            // Step 8: Soul Map (Optional Numerology Deep Dive)
            "birthName": profile.birthName ?? NSNull(),
            "soulUrgeNumber": profile.soulUrgeNumber ?? NSNull(),
            "expressionNumber": profile.expressionNumber ?? NSNull(),

            // Step 9: UX Personalization
            "wantsReflectionMode": profile.wantsReflectionMode
        ]
        
        // Remove NSNull fields if you prefer not to store them
        profileData = profileData.filter { !($0.value is NSNull) }

        usersCollection.document(userID).setData(profileData) { error in
            if let error = error {
                print("❌ UserProfileService: Error saving user profile: \(error.localizedDescription)")
            } else {
                print("✅ UserProfileService: User profile saved successfully for userID: \(userID)")
            }
            completion(error)
        }
    }

    /**
     * Fetches a user's profile from Firestore.
     *
     * - Parameters:
     *   - userID: The unique ID of the user.
     *   - completion: A closure that is called with an optional UserProfile and an optional error.
     */
    func fetchUserProfile(for userID: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        print("UserProfileService: Attempting to fetch profile for userID: \(userID)")

        usersCollection.document(userID).getDocument { document, error in
            if let error = error {
                print("❌ UserProfileService: Error fetching user profile: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                print("ℹ️ UserProfileService: No profile found for userID: \(userID)")
                completion(nil, nil)
                return
            }

            // Parse the Firestore data into a UserProfile object
            let profile = UserProfile(
                id: data["id"] as? String ?? userID,
                birthdate: (data["birthdate"] as? Timestamp)?.dateValue() ?? Date(),
                lifePathNumber: data["lifePathNumber"] as? Int ?? 1,
                isMasterNumber: data["isMasterNumber"] as? Bool ?? false,
                spiritualMode: data["spiritualMode"] as? String ?? "Balanced",
                insightTone: data["insightTone"] as? String ?? "Gentle",
                focusTags: data["focusTags"] as? [String] ?? [],
                cosmicPreference: data["cosmicPreference"] as? String ?? "Balanced",
                cosmicRhythms: data["cosmicRhythms"] as? [String] ?? [],
                preferredHour: data["preferredHour"] as? Int ?? 9,
                wantsWhispers: data["wantsWhispers"] as? Bool ?? true,
                birthName: data["birthName"] as? String,
                soulUrgeNumber: data["soulUrgeNumber"] as? Int,
                expressionNumber: data["expressionNumber"] as? Int,
                wantsReflectionMode: data["wantsReflectionMode"] as? Bool ?? false
            )

            print("✅ UserProfileService: Profile fetched successfully for userID: \(userID)")
            completion(profile, nil)
        }
    }

    /**
     * Checks if a user profile exists in Firestore.
     *
     * - Parameters:
     *   - userID: The unique ID of the user.
     *   - completion: A closure that is called with a boolean indicating existence and an optional error.
     */
    func profileExists(for userID: String, completion: @escaping (Bool, Error?) -> Void) {
        print("UserProfileService: Checking if profile exists for userID: \(userID)")

        usersCollection.document(userID).getDocument { document, error in
            if let error = error {
                print("❌ UserProfileService: Error checking profile existence: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            let exists = document?.exists ?? false
            print("ℹ️ UserProfileService: Profile exists for userID \(userID): \(exists)")
            completion(exists, nil)
        }
    }
}

// Note: You will need to ensure your UserProfile model (likely in Models/UserProfile.swift)
// is compatible with this service. Specifically:
// 1. It needs to have all the properties being saved/fetched.
// 2. It needs an initializer that matches the one used in `fetchUserProfile`
//    to reconstruct the UserProfile from the Firestore data.

/*
Example UserProfile (ensure yours in Models/UserProfile.swift matches or is adapted):
import Foundation

struct UserProfile: Identifiable { // Keep Codable, it doesn't hurt
    var id: String // Changed from UUID to String to match your model
    // var userID: String // Removed as 'id' will serve this purpose
    // var fullName: String // Changed to fullNameAtBirth
    // var dateOfBirth: Date // Changed to birthDate
    // var timeOfBirth: String // Changed to birthTime (Date?)
    // var gender: String // Not present in your UserProfile model, removed from service example

    // Fields from your UserProfile.swift
    var fullNameAtBirth: String?
    var birthDate: Date?
    var birthTime: Date?
    var birthLocation: String?

    var lifePathNumber: Int?
    var isMasterLifePath: Bool
    var soulUrgeNumber: Int?
    var isMasterSoulUrge: Bool
    var expressionNumber: Int?
    var isMasterExpression: Bool
    // personalityNumber and birthDayNumber were in the service placeholder, 
    // but not in your UserProfile.swift. Removed from service example for now.

    var spiritualMode: String?
    var tonePreference: String?
    var focusTags: [String]?
    var openToCosmicGuidance: Bool
    var preferredCosmicRhythms: [String]?
    var appCommunicationStyle: String?
    var allowDailyEmotionalCheckIn: Bool

    // var createdAt: Date? // Not in your UserProfile.swift, removed from service example for now.
                     // Consider adding it if you want to track creation time.

    // Your existing initializer from UserProfile.swift should work with these changes
    init(id: String,
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
         allowDailyEmotionalCheckIn: Bool = false) {
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
*/ 
