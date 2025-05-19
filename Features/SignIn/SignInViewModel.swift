//
//  SignInViewModel.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import Foundation
import AuthenticationServices
import Combine

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
}
