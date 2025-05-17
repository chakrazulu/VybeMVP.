import Foundation
import FirebaseMessaging // For deleting FCM token
// We don't strictly need FirebaseAuth if we are not using Auth.auth().signOut()
// We don't need AuthenticationServices for Apple Sign Out for this approach

class AuthService {
    static let shared = AuthService()
    private init() {}

    func logout(signInViewModel: SignInViewModel) {
        print("➡️ Initiating logout process...")

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

        // 3. Update the app's state via SignInViewModel
        DispatchQueue.main.async {
            signInViewModel.isSignedIn = false
            print("🔄 App state updated: isSignedIn is now false. Navigating to SignInView.")
        }
        
        print("✅ Logout process complete. (Note: FCM operations are asynchronous)")
    }
} 