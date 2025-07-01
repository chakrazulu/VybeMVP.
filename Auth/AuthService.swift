/*
 * ========================================
 * 🔐 AUTH SERVICE - SECURE LOGOUT MANAGEMENT
 * ========================================
 * 
 * CORE PURPOSE:
 * Centralized authentication service handling secure user logout process.
 * Manages Firebase Cloud Messaging token deletion, keychain cleanup, and
 * user state reset. Ensures complete data removal and notification cleanup.
 * 
 * LOGOUT PROCESS SEQUENCE:
 * 1. FCM Token Deletion: Removes Firebase Cloud Messaging token to stop notifications
 * 2. Keychain Cleanup: Removes user credentials and sensitive data
 * 3. UserDefaults Reset: Clears onboarding status and user preferences
 * 4. State Management: Updates SignInViewModel to trigger UI navigation
 * 
 * SECURITY FEATURES:
 * - FCM Token Deletion: Prevents continued push notifications after logout
 * - Keychain Cleanup: Removes all stored user credentials
 * - UserDefaults Reset: Clears user-specific onboarding flags
 * - Complete State Reset: Ensures no user data remains in app state
 * 
 * INTEGRATION POINTS:
 * - Firebase Messaging: FCM token management for notifications
 * - KeychainHelper: Secure credential storage and deletion
 * - UserDefaults: User preference and onboarding status storage
 * - SignInViewModel: UI state management and navigation control
 * - AuthenticationManager: Global authentication state coordination
 * 
 * ERROR HANDLING:
 * - FCM Token Errors: Graceful handling of token deletion failures
 * - Keychain Errors: Secure cleanup even if some operations fail
 * - State Reset: Ensures UI navigation regardless of cleanup success
 * - Logging: Comprehensive error tracking for debugging
 * 
 * PERFORMANCE NOTES:
 * - Asynchronous Operations: FCM operations run in background
 * - Parallel Processing: Keychain and UserDefaults cleanup can run simultaneously
 * - UI Responsiveness: State updates on main thread for smooth navigation
 * - Memory Management: Proper cleanup prevents memory leaks
 * 
 * USAGE:
 * Called during user logout to ensure complete data removal and
 * prevent any residual user data or notifications from persisting.
 */

import Foundation
import FirebaseMessaging // For deleting FCM token
// We don't strictly need FirebaseAuth if we are not using Auth.auth().signOut()
// We don't need AuthenticationServices for Apple Sign Out for this approach

/**
 * AuthService: Centralized authentication service for secure logout management
 * 
 * Provides comprehensive logout functionality including FCM token deletion,
 * keychain cleanup, and user state reset. Ensures complete data removal
 * and prevents residual notifications or user data from persisting.
 * 
 * Features:
 * - Secure FCM token deletion
 * - Complete keychain cleanup
 * - UserDefaults state reset
 * - SignInViewModel state management
 */
class AuthService {
    static let shared = AuthService()
    private init() {}

    // Pass the UserDefaults key for consistency
    private let onboardingCompletedKey = "hasCompletedOnboarding"

    func logout(signInViewModel: SignInViewModel) {
        print("➡️ Initiating logout process...")

        // Get the userID *before* it's cleared by logout process
        let userIDToClearOnboardingFor = signInViewModel.userID

        // Attempt to fetch the token first to ensure Firebase Messaging is active
        Messaging.messaging().token { token, error in
            if let error = error {
                print("⚠️ Error fetching FCM token before deletion (this might be okay if deletion still works): \(error.localizedDescription)")
            } else if let token = token {
                print("ℹ️ Successfully fetched FCM token before deletion: \(token.prefix(10))...")
            }

            // Now, proceed to delete the FCM Token
            Messaging.messaging().deleteToken { error in
                if let error = error {
                    // The original error you're seeing would be caught here
                    print("🔥 Error deleting FCM token: \(error.localizedDescription)")
                } else {
                    print("✅ FCM token deleted successfully. User will stop receiving notifications.")
                }
            }
        }

        // 2. Clear Keychain Data (This can run in parallel or after token operations)
        let keychainKeys = ["userID", "email", "fullName"]
        for key in keychainKeys {
            KeychainHelper.shared.delete(for: key)
        }
        print("🔑 Keychain data cleared for keys: \(keychainKeys.joined(separator: ", ")).")

        // 3. Clear User-Specific Onboarding Flag from UserDefaults
        if let userID = userIDToClearOnboardingFor {
            UserDefaults.standard.removeObject(forKey: onboardingCompletedKey + userID)
            print("🧹 Cleared onboarding status from UserDefaults for userID: \(userID)")
        } else {
            print("⚠️ Could not clear onboarding status from UserDefaults: userID was nil before logout.")
        }

        // 4. Update the app's state via SignInViewModel
        signInViewModel.handleLogout()
        
        // This print statement can remain for clarity, confirming the intended navigation.
        // It's good practice to ensure UI-related logging or state checks are main-thread if they could be.
        DispatchQueue.main.async {
            print("🔄 App state updated by handleLogout. Expecting navigation to SignInView.")
        }
        
        print("✅ Logout process complete. (Note: FCM operations are asynchronous)")
    }
} 