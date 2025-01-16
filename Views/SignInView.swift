//
//  SignInView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @State private var navigateToMainView = false // Add state for navigation

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isSignedIn {
                    // Trigger navigation automatically
                    Text("You are signed in!")
                        .onAppear {
                            navigateToMainView = true
                        }
                    
                    // Navigation to MainView
                    NavigationLink(value: MainView()) {
                        EmptyView() // Invisible link
                    }
                    .hidden() // Hide the link visually
                } else {
                    // Sign-in button
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            viewModel.handleSignIn(result: result)
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
            }
            .onAppear {
                viewModel.checkSignInStatus()
            }
        }
    }
}

