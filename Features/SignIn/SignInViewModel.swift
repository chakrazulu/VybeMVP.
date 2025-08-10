//
//  SignInViewModel.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import Foundation
import AuthenticationServices
import Combine

// Claude: SWIFT 6 COMPLIANCE - Added @MainActor for UI state management
@MainActor
class SignInViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var userID: String? = nil

    func handleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName?.givenName

                KeychainHelper.shared.save(userIdentifier, for: "userID")
                KeychainHelper.shared.save(email ?? "", for: "email")
                KeychainHelper.shared.save(fullName ?? "", for: "fullName")

                DispatchQueue.main.async {
                    self.userID = userIdentifier
                    self.isSignedIn = true
                    print("✅ SignInViewModel: User signed in. UserID: \(userIdentifier)")
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.userID = nil
                self.isSignedIn = false
            }
        }
    }

    func checkSignInStatus() {
        if let userIdentifier = KeychainHelper.shared.get(for: "userID") {
            DispatchQueue.main.async {
                self.userID = userIdentifier
                self.isSignedIn = true
                print("🔑 SignInViewModel: User status checked. Signed In. UserID: \(userIdentifier)")
            }
        } else {
            DispatchQueue.main.async {
                self.userID = nil
                self.isSignedIn = false
                print("🔑 SignInViewModel: User status checked. Not Signed In.")
            }
        }
    }

    func handleLogout() {
        DispatchQueue.main.async {
            self.userID = nil
            self.isSignedIn = false
            print("🚪 SignInViewModel: User logged out.")
        }
    }

    func signOut() {
        // Clear all user data from keychain
        KeychainHelper.shared.delete(for: "userID")
        KeychainHelper.shared.delete(for: "email")
        KeychainHelper.shared.delete(for: "fullName")

        // Clear any other user-specific data
        UserDefaults.standard.removeObject(forKey: "user_archetype")
        UserDefaults.standard.removeObject(forKey: "resonance_matches")
        UserDefaults.standard.removeObject(forKey: "resonance_streak")

        DispatchQueue.main.async {
            self.isSignedIn = false
        }

        print("User signed out successfully")
    }
}
