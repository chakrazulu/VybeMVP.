//
//  ContentView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn, onRequest: { request in
                // Configure the request here
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                // Handle the result here
                switch result {
                case .success(let authorization):
                    handleAuthorization(authorization)
                case .failure(let error):
                    print("Sign in with Apple failed: \(error)")
                }
            })
            .signInWithAppleButtonStyle(.black) // Customize button style
            .frame(height: 50)
            .padding()
        }
    }
}

func handleAuthorization(_ authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        // Extract user details
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email

        print("User ID: \(userIdentifier)")
        print("Full Name: \(String(describing: fullName))")
        print("Email: \(String(describing: email))")
    }
}
