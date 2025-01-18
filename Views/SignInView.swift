//
//  SignInView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Binding var isSignedIn: Bool
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                switch result {
                case .success:
                    isSignedIn = true
                case .failure(let error):
                    print("Sign in with Apple failed: \(error)")
                }
            })
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .padding()
        }
    }
}

