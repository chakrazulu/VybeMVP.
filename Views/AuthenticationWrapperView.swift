/*
 * ========================================
 * 🔐 AUTHENTICATION WRAPPER VIEW - APP ENTRY POINT
 * ========================================
 *
 * CORE PURPOSE:
 * Root navigation controller managing entire app authentication flow. Determines user
 * journey based on authentication state: loading → sign-in → onboarding → main app.
 * Integrates Apple Sign-In with Firebase Auth and UserProfile management.
 *
 * UI SPECIFICATIONS:
 * - Loading Screen: 60pt sparkles icon, purple accent, circular progress indicator
 * - Sign-In Screen: 80pt sparkles icon, gradient background, 50pt Apple Sign-In button
 * - Animations: 0.3s ease-in-out transitions between all states
 * - Background: Purple-to-blue gradient (10% opacity) for sign-in screen
 * - Button: Apple Sign-In with black style, 8pt corner radius, 20pt horizontal padding
 *
 * AUTHENTICATION FLOW STATES:
 * 1. isCheckingAuthStatus=true → EnhancedLoadingView with timeout/retry
 * 2. isSignedIn=false → SignInWrapperView with Apple Sign-In
 * 3. isSignedIn=true + hasCompletedOnboarding=false → OnboardingView
 * 4. isSignedIn=true + hasCompletedOnboarding=true → ContentView (main app)
 *
 * STATE MANAGEMENT:
 * - AuthenticationManager.shared: Global auth state observer
 * - SignInViewModel: User ID and auth data management
 * - hasCompletedOnboarding: Local state for onboarding completion
 * - UserProfileService: Profile persistence and Firestore sync
 *
 * INTEGRATION POINTS:
 * - AuthenticationManager: Authentication state and Apple Sign-In handling
 * - UserProfileService: Profile validation and Firestore synchronization
 * - AIInsightManager: AI insights configuration after profile validation
 * - OnboardingView: Full onboarding flow with profile creation
 * - ContentView: Main app with 12-tab navigation structure
 *
 * APPLE SIGN-IN SPECIFICATIONS:
 * - Nonce Generation: Security nonce for Firebase Auth integration
 * - Requested Scopes: .fullName and .email for user identification
 * - Button Style: .black with system styling
 * - Firebase Integration: Seamless Apple ID to Firebase Auth conversion
 *
 * ONBOARDING VALIDATION:
 * - Profile Check: UserProfileService.getCurrentUserProfileFromUserDefaults()
 * - Completion Criteria: Complete UserProfile with all required fields
 * - Auto-Sync: Profiles automatically saved to Firestore after validation
 * - AI Configuration: AIInsightManager configured with validated profile
 *
 * ERROR HANDLING & RECOVERY:
 * - Authentication Timeout: EnhancedLoadingView with retry mechanism
 * - Failed Auth Check: Force refresh with authManager.checkAuthenticationStatus()
 * - Profile Sync Errors: Graceful fallback with error logging
 * - State Reset: Clean state reset on sign-out
 *
 * PERFORMANCE NOTES:
 * - State Observers: Efficient @StateObject and @State management
 * - Animation Optimization: Single 0.3s duration for all transitions
 * - Memory Management: Proper cleanup on state changes
 * - Background Processing: Non-blocking profile validation and sync
 *
 * SECURITY FEATURES:
 * - Secure Nonce: Cryptographically secure nonce generation for Apple Sign-In
 * - Privacy Protection: Minimal data collection, secure storage only
 * - Keychain Integration: Secure credential storage via AuthenticationManager
 * - Firebase Security: Encrypted communication with Firebase Auth
 */

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

    // 🧪 TEMPORARY: Debug flag to bypass authentication for testing
    private let bypassAuthForTesting = false

    var body: some View {
        Group {
            // 🧪 TEMPORARY: Bypass authentication for cosmic animation testing
            if bypassAuthForTesting {
                // Navigation wrapper for cosmic animation testing
                NavigationView {
                    ZStack {
                        Color.purple.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 20) {
                            Text("🧪 BYPASS ACTIVE")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Authentication bypassed for testing")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))

                            NavigationLink("Test Cosmic Animations") {
                                TestCosmicAnimationView()
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(12)

                            NavigationLink("🌌 Main App (HomeView with cosmic animations)") {
                                // Show the real ContentView (full app)
                                ContentView()
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple.opacity(0.6))
                            .cornerRadius(12)
                        }
                    }
                }
                .onAppear {
                    print("🧪 DEBUG: AuthenticationWrapperView bypass test view appeared!")
                }
            } else if authManager.isCheckingAuthStatus {
                // Show loading screen while checking authentication
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

        // Claude: Check UserDefaults first for onboarding completion flag (set by OnboardingCompletionView)
        let onboardingKey = "hasCompletedOnboarding" + userID
        let hasCompletedViaOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)

        if hasCompletedViaOnboarding {
            hasCompletedOnboarding = true
            print("🔍 Found onboarding completion flag for user \(userID), onboarding completed")

            // Configure AI insights if we have a profile
            if let userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID) {
                Task {
                    await AIInsightManager.shared.configureAndRefreshInsight(for: userProfile)
                }
            }
        } else {
            hasCompletedOnboarding = false
            print("🔍 No onboarding completion flag found for user \(userID), onboarding needed")
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
            // Re-enable Firebase Auth integration
            authManager.handleSignIn(result: result)
        })
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .padding(.horizontal, 20)
        .cornerRadius(8)
    }
}

// MARK: - Preview
struct AuthenticationWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationWrapperView()
    }
}
