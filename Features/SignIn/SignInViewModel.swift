//
//  SignInViewModel.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import Foundation
import AuthenticationServices

class SignInViewModel: ObservableObject {
    @Published var isSignedIn = false

    func handleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Save to Keychain
                let userID = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName?.givenName
                
                KeychainHelper.shared.save(userID, for: "userID")
                KeychainHelper.shared.save(email ?? "", for: "email")
                KeychainHelper.shared.save(fullName ?? "", for: "fullName")

                DispatchQueue.main.async {
                    self.isSignedIn = true
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }

    func checkSignInStatus() {
        let userID = KeychainHelper.shared.get(for: "userID")
        DispatchQueue.main.async {
            self.isSignedIn = (userID != nil)
        }
    }
}
