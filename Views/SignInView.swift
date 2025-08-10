/*
 * ========================================
 * 🔐 SIGN IN VIEW - APPLE AUTHENTICATION
 * ========================================
 *
 * CORE PURPOSE:
 * Simple Apple Sign-In component providing secure authentication entry point.
 * Integrates with SignInViewModel for credential handling and state management.
 * Used within AuthenticationWrapperView's sign-in flow.
 *
 * UI SPECIFICATIONS:
 * - Button: 350pt max width, 50pt height, black Apple style
 * - Layout: Centered vertically with Spacer elements
 * - Padding: 20pt horizontal margin
 * - Style: Native Apple Sign-In button with system styling
 *
 * AUTHENTICATION FLOW:
 * - onRequest: Configures Apple Sign-In with .fullName and .email scopes
 * - onCompletion: Delegates result handling to SignInViewModel
 * - Integration: Works with AuthenticationManager for Firebase Auth
 * - State Binding: isSignedIn binding for navigation control
 *
 * INTEGRATION POINTS:
 * - SignInViewModel: Handles Apple Sign-In result processing
 * - AuthenticationWrapperView: Parent container managing auth flow
 * - AuthenticationManager: Backend authentication state management
 * - Firebase Auth: Secure credential conversion and storage
 *
 * SECURITY FEATURES:
 * - Apple Sign-In: Secure authentication with Apple ID
 * - Scoped Access: Requests only essential fullName and email
 * - Privacy Protection: Apple's privacy-first authentication approach
 * - Secure Token Handling: Managed by SignInViewModel and AuthenticationManager
 *
 * PERFORMANCE NOTES:
 * - Lightweight component with minimal state
 * - Native Apple button for optimal performance
 * - Efficient delegation pattern for result handling
 * - Clean separation of concerns with ViewModel pattern
 */

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
    @EnvironmentObject var signInViewModel: SignInViewModel

    var body: some View {
        VStack {
            Spacer()

            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                signInViewModel.handleSignIn(result: result)
            })
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: 350)
            .frame(height: 50)
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
