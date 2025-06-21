//
//  AuthenticationWrapperView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import SwiftUI
import AuthenticationServices

/**
 * Authentication wrapper view that controls app navigation based on user authentication state.
 *
 * This view serves as the root content view and determines what the user sees:
 * - Loading screen while checking authentication status
 * - Sign-in screen if user is not authenticated
 * - Onboarding flow if user is authenticated but hasn't completed onboarding
 * - Main app content if user is authenticated and has completed onboarding
 *
 * The view observes the global AuthenticationManager to react to authentication changes.
 */
struct AuthenticationWrapperView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var signInViewModel = SignInViewModel()
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if authManager.isCheckingAuthStatus {
                // Show loading screen while checking authentication status
                LoadingView()
            } else if authManager.isSignedIn {
                // User is authenticated - check if they've completed onboarding
                if hasCompletedOnboarding {
                    // User has completed onboarding - show main app content
                    ContentView()
                        .environmentObject(signInViewModel)
                } else {
                    // User needs to complete onboarding - show full onboarding flow
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .environmentObject(signInViewModel)
                }
            } else {
                // User is not authenticated - show sign-in screen
                SignInWrapperView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isSignedIn)
        .animation(.easeInOut(duration: 0.3), value: authManager.isCheckingAuthStatus)
        .animation(.easeInOut(duration: 0.3), value: hasCompletedOnboarding)
        .onAppear {
            checkOnboardingStatus()
            // Set the userID in signInViewModel when auth manager has it
            if let userID = authManager.userID {
                signInViewModel.userID = userID
            }
        }
        .onChange(of: authManager.isSignedIn) { _, newValue in
            if newValue {
                // When user signs in, check their onboarding status and set userID
                if let userID = authManager.userID {
                    signInViewModel.userID = userID
                }
                checkOnboardingStatus()
            } else {
                // When user signs out, reset onboarding status
                hasCompletedOnboarding = false
                signInViewModel.userID = nil
            }
        }
        .onChange(of: authManager.userID) { _, newUserID in
            // Update signInViewModel when userID changes
            signInViewModel.userID = newUserID
        }
    }
    
    private func checkOnboardingStatus() {
        guard let userID = authManager.userID else {
            hasCompletedOnboarding = false
            print("🔍 No userID available, onboarding incomplete")
            return
        }
        
        // Check if user has a complete UserProfile (indicating full onboarding completion)
        if let userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID) {
            hasCompletedOnboarding = true
            print("🔍 Found complete UserProfile for user \(userID), onboarding completed")
            
            // Save profile to Firestore if not already saved
            UserProfileService.shared.saveUserProfile(userProfile, for: userID) { error in
                if let error = error {
                    print("❌ Failed to save profile to Firestore: \(error.localizedDescription)")
                } else {
                    print("✅ Profile successfully saved to Firestore for user \(userID)")
                }
            }
            
            // Configure AI insights with the existing profile
            AIInsightManager.shared.configureAndRefreshInsight(for: userProfile)
        } else {
            hasCompletedOnboarding = false
            print("🔍 No complete UserProfile found for user \(userID), onboarding needed")
        }
    }
}

/**
 * Loading view displayed while checking authentication status.
 */
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // App logo or icon
                Image(systemName: "sparkles")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.purple)
                
                Text("Vybe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                ProgressView()
                    .scaleEffect(1.2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                
                Text("Checking authentication...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/**
 * Sign-in wrapper view that handles the sign-in flow.
 */
struct SignInWrapperView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.1),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 20) {
                    // App icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(.purple)
                    
                    Text("Welcome to Vybe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Discover your spiritual resonance through numerology, astrology, and the wisdom of numbers.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Sign-in section
                VStack(spacing: 20) {
                    SignInWithAppleView()
                    
                    Text("Sign in to sync your spiritual journey across devices")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Privacy note
                Text("Your privacy is protected. We only store your authentication data securely.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

/**
 * Sign in with Apple button component.
 */
struct SignInWithAppleView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        SignInWithAppleButton(.signIn, onRequest: { request in
            // Generate nonce for Firebase Auth integration
            let nonce = authManager.generateNonce()
            request.nonce = nonce
            request.requestedScopes = [.fullName, .email]
        }, onCompletion: { result in
            authManager.handleSignIn(result: result)
        })
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .padding(.horizontal, 20)
        .cornerRadius(8)
    }
}

#Preview {
    AuthenticationWrapperView()
} 
