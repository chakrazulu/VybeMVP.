//
//  AuthenticationManager.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation
import AuthenticationServices
import Combine

/**
 * Global authentication manager for the VybeMVP app.
 *
 * This manager serves as the single source of truth for user authentication state
 * across the entire application. It handles sign-in with Apple, keychain storage,
 * logout functionality, and authentication state persistence.
 *
 * Key features:
 * - Singleton pattern for app-wide access
 * - Automatic authentication state checking on app launch
 * - Secure keychain storage for user credentials
 * - Clean logout with data clearing
 * - Published properties for SwiftUI integration
 */
class AuthenticationManager: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = AuthenticationManager()
    
    // MARK: - Published Properties
    @Published var isSignedIn = false
    @Published var isCheckingAuthStatus = true
    @Published var userID: String?
    @Published var userEmail: String?
    @Published var userFullName: String?
    
    // MARK: - Private Properties
    private let keychainHelper = KeychainHelper.shared
    
    // MARK: - Initialization
    private init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    
    /**
     * Checks if the user is currently authenticated by looking for stored credentials.
     * This method is called automatically when the manager is initialized.
     */
    func checkAuthenticationStatus() {
        DispatchQueue.main.async { [weak self] in
            self?.isCheckingAuthStatus = true
        }
        
        // Check for existing credentials in keychain
        let userID = keychainHelper.get(for: "userID")
        let email = keychainHelper.get(for: "email")
        let fullName = keychainHelper.get(for: "fullName")
        
        DispatchQueue.main.async { [weak self] in
            self?.userID = userID
            self?.userEmail = email
            self?.userFullName = fullName
            self?.isSignedIn = userID != nil
            self?.isCheckingAuthStatus = false
            
            if userID != nil {
                print("✅ User is authenticated: \(userID ?? "Unknown")")
            } else {
                print("❌ User is not authenticated")
            }
        }
    }
    
    // MARK: - Sign In
    
    /**
     * Handles the result of Sign in with Apple authentication.
     *
     * - Parameter result: The result from the Apple ID authorization
     */
    func handleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Extract user information
                let userID = appleIDCredential.user
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName?.givenName
                
                // Save to keychain
                keychainHelper.save(userID, for: "userID")
                keychainHelper.save(email ?? "", for: "email")
                keychainHelper.save(fullName ?? "", for: "fullName")
                
                // Update state on main thread
                DispatchQueue.main.async { [weak self] in
                    self?.userID = userID
                    self?.userEmail = email
                    self?.userFullName = fullName
                    self?.isSignedIn = true
                }
                
                print("✅ Sign in successful: \(userID)")
            }
        case .failure(let error):
            print("❌ Sign in failed: \(error.localizedDescription)")
            
            DispatchQueue.main.async { [weak self] in
                self?.isSignedIn = false
            }
        }
    }
    
    // MARK: - Sign Out
    
    /**
     * Signs out the current user and clears all stored data.
     * This includes keychain data, UserDefaults, and any other user-specific information.
     */
    func signOut() {
        // Clear keychain data
        keychainHelper.delete(for: "userID")
        keychainHelper.delete(for: "email")
        keychainHelper.delete(for: "fullName")
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "user_archetype")
        UserDefaults.standard.removeObject(forKey: "resonance_matches")
        UserDefaults.standard.removeObject(forKey: "resonance_streak")
        
        // Clear any other app-specific data
        UserArchetypeManager.shared.clearArchetype()
        ResonanceEngine.shared.clearAllMatches()
        
        // Update state on main thread
        DispatchQueue.main.async { [weak self] in
            self?.userID = nil
            self?.userEmail = nil
            self?.userFullName = nil
            self?.isSignedIn = false
        }
        
        print("✅ User signed out successfully")
    }
    
    // MARK: - Utility Methods
    
    /**
     * Returns the display name for the current user.
     * Falls back to email or user ID if full name is not available.
     */
    var displayName: String {
        if let fullName = userFullName, !fullName.isEmpty {
            return fullName
        } else if let email = userEmail, !email.isEmpty {
            return email
        } else if let userID = userID {
            return userID
        } else {
            return "User"
        }
    }
    
    /**
     * Checks if the user has completed onboarding.
     * This can be expanded to include additional onboarding checks.
     */
    var hasCompletedOnboarding: Bool {
        // Check if user has calculated their archetype
        return UserArchetypeManager.shared.hasStoredArchetype()
    }
} 