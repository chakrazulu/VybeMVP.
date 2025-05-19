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
            // Core Numerology Inputs
            "fullNameAtBirth": profile.fullNameAtBirth ?? NSNull(), // Handle optionals with NSNull or omit if nil
            "birthDate": profile.birthDate != nil ? Timestamp(date: profile.birthDate!) : NSNull(),
            "birthTime": profile.birthTime != nil ? Timestamp(date: profile.birthTime!) : NSNull(), // Assuming birthTime is Date
            "birthLocation": profile.birthLocation ?? NSNull(),
            
            // Calculated Numerology Numbers
            "lifePathNumber": profile.lifePathNumber ?? NSNull(),
            "isMasterLifePath": profile.isMasterLifePath,
            "soulUrgeNumber": profile.soulUrgeNumber ?? NSNull(),
            "isMasterSoulUrge": profile.isMasterSoulUrge,
            "expressionNumber": profile.expressionNumber ?? NSNull(),
            "isMasterExpression": profile.isMasterExpression,

            // User Preferences & Personalization
            "spiritualMode": profile.spiritualMode ?? NSNull(),
            "tonePreference": profile.tonePreference ?? NSNull(),
            "focusTags": profile.focusTags ?? [], // Save empty array if nil
            "openToCosmicGuidance": profile.openToCosmicGuidance,
            "preferredCosmicRhythms": profile.preferredCosmicRhythms ?? [], // Save empty array if nil
            "appCommunicationStyle": profile.appCommunicationStyle ?? NSNull(),
            "allowDailyEmotionalCheckIn": profile.allowDailyEmotionalCheckIn
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
            
            // Core Numerology Inputs
            let fullNameAtBirth = data["fullNameAtBirth"] as? String
            let birthDateTimestamp = data["birthDate"] as? Timestamp
            let birthDate = birthDateTimestamp?.dateValue()
            let birthTimeTimestamp = data["birthTime"] as? Timestamp // Assuming birthTime is stored as Timestamp
            let birthTime = birthTimeTimestamp?.dateValue()
            let birthLocation = data["birthLocation"] as? String
            
            // Calculated Numerology Numbers
            let lifePathNumber = data["lifePathNumber"] as? Int
            let isMasterLifePath = data["isMasterLifePath"] as? Bool ?? false
            let soulUrgeNumber = data["soulUrgeNumber"] as? Int
            let isMasterSoulUrge = data["isMasterSoulUrge"] as? Bool ?? false
            let expressionNumber = data["expressionNumber"] as? Int
            let isMasterExpression = data["isMasterExpression"] as? Bool ?? false
            
            // User Preferences & Personalization
            let spiritualMode = data["spiritualMode"] as? String
            let tonePreference = data["tonePreference"] as? String
            let focusTags = data["focusTags"] as? [String]
            let openToCosmicGuidance = data["openToCosmicGuidance"] as? Bool ?? true // Default from your model
            let preferredCosmicRhythms = data["preferredCosmicRhythms"] as? [String]
            let appCommunicationStyle = data["appCommunicationStyle"] as? String
            let allowDailyEmotionalCheckIn = data["allowDailyEmotionalCheckIn"] as? Bool ?? false // Default from your model

            // Use the initializer from UserProfile.swift
            let profile = UserProfile(
                id: id,
                fullNameAtBirth: fullNameAtBirth,
                birthDate: birthDate,
                birthTime: birthTime,
                birthLocation: birthLocation,
                lifePathNumber: lifePathNumber,
                isMasterLifePath: isMasterLifePath,
                soulUrgeNumber: soulUrgeNumber,
                isMasterSoulUrge: isMasterSoulUrge,
                expressionNumber: expressionNumber,
                isMasterExpression: isMasterExpression,
                spiritualMode: spiritualMode,
                tonePreference: tonePreference,
                focusTags: focusTags,
                openToCosmicGuidance: openToCosmicGuidance,
                preferredCosmicRhythms: preferredCosmicRhythms,
                appCommunicationStyle: appCommunicationStyle,
                allowDailyEmotionalCheckIn: allowDailyEmotionalCheckIn
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
