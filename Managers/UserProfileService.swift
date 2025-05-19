import Foundation
import FirebaseFirestore
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
        print("👤 UserProfileService initialized.")
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
        // Since FirebaseFirestoreSwift is not confirmed to be available,
        // we'll prepare for manual data conversion.
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
        usersCollection.document(userID).getDocument { documentSnapshot, error in
            if let error = error {
                print("❌ UserProfileService: Error fetching user profile: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let document = documentSnapshot, document.exists else {
                print("ℹ️ UserProfileService: No profile document found for userID: \(userID)")
                completion(nil, nil) 
                return
            }

            guard let data = document.data() else {
                print("⚠️ UserProfileService: Document data is nil for userID: \(userID)")
                completion(nil, nil) 
                return
            }

            // Align with UserProfile.swift properties and its initializer
            let id = data["id"] as? String ?? userID // Use userID as fallback for id
            
            // Step 1: Core Identity
            guard let birthdateTimestamp = data["birthdate"] as? Timestamp,
                  let lifePathNumber = data["lifePathNumber"] as? Int,
                  let isMasterNumber = data["isMasterNumber"] as? Bool else {
                print("⚠️ UserProfileService: Missing core identity fields (birthdate, lifePathNumber, isMasterNumber) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing core identity fields"]))
                return
            }
            let birthdate = birthdateTimestamp.dateValue()

            // Step 2 & 3: Reflection Type & AI Modulation
            guard let spiritualMode = data["spiritualMode"] as? String,
                  let insightTone = data["insightTone"] as? String else {
                print("⚠️ UserProfileService: Missing reflection/AI modulation fields (spiritualMode, insightTone) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Missing reflection/AI modulation fields"]))
                return
            }

            // Step 4: Insight Filtering
            guard let focusTags = data["focusTags"] as? [String] else {
                print("⚠️ UserProfileService: Missing insight filtering field (focusTags) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Missing insight filtering field"]))
                return
            }
            
            // Step 5 & 6: Cosmic Alignment
            guard let cosmicPreference = data["cosmicPreference"] as? String,
                  let cosmicRhythms = data["cosmicRhythms"] as? [String] else {
                print("⚠️ UserProfileService: Missing cosmic alignment fields (cosmicPreference, cosmicRhythms) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Missing cosmic alignment fields"]))
                return
            }

            // Step 7: Notification System
            guard let preferredHour = data["preferredHour"] as? Int,
                  let wantsWhispers = data["wantsWhispers"] as? Bool else {
                print("⚠️ UserProfileService: Missing notification system fields (preferredHour, wantsWhispers) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 5, userInfo: [NSLocalizedDescriptionKey: "Missing notification system fields"]))
                return
            }

            // Step 8: Soul Map (Optional Numerology Deep Dive)
            let birthName = data["birthName"] as? String // Optional
            let soulUrgeNumber = data["soulUrgeNumber"] as? Int // Optional
            let expressionNumber = data["expressionNumber"] as? Int // Optional
            
            // Step 9: UX Personalization
            guard let wantsReflectionMode = data["wantsReflectionMode"] as? Bool else {
                print("⚠️ UserProfileService: Missing UX personalization field (wantsReflectionMode) for userID: \(userID)")
                completion(nil, NSError(domain: "UserProfileService", code: 6, userInfo: [NSLocalizedDescriptionKey: "Missing UX personalization field"]))
                return
            }

            // Use the initializer from UserProfile.swift
            let profile = UserProfile(
                id: id,
                birthdate: birthdate,
                lifePathNumber: lifePathNumber,
                isMasterNumber: isMasterNumber,
                spiritualMode: spiritualMode,
                insightTone: insightTone,
                focusTags: focusTags,
                cosmicPreference: cosmicPreference,
                cosmicRhythms: cosmicRhythms,
                preferredHour: preferredHour,
                wantsWhispers: wantsWhispers,
                birthName: birthName,
                soulUrgeNumber: soulUrgeNumber,
                expressionNumber: expressionNumber,
                wantsReflectionMode: wantsReflectionMode
            )
            print("✅ UserProfileService: User profile fetched and parsed successfully for userID: \(userID)")
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
        usersCollection.document(userID).getDocument { documentSnapshot, error in
            if let error = error {
                print("❌ UserProfileService: Error checking profile existence: \(error.localizedDescription)")
                completion(false, error)
            } else {
                let exists = documentSnapshot?.exists ?? false
                print("ℹ️ UserProfileService: Profile exists for userID \(userID): \(exists)")
                completion(exists, nil)
            }
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
