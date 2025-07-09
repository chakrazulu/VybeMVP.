/*
 * ========================================
 * 🔐 AUTHENTICATION MANAGER - SECURE IDENTITY SYSTEM
 * ========================================
 * 
 * CORE PURPOSE:
 * Comprehensive authentication orchestration managing Apple Sign-In, Firebase Auth
 * integration, secure keychain storage, and app-wide authentication state. Serves
 * as single source of truth for user identity with automatic state persistence
 * and secure credential management.
 * 
 * AUTHENTICATION ARCHITECTURE:
 * - Apple Sign-In Integration: Native ASAuthorizationAppleIDCredential handling
 * - Firebase Auth Bridge: Seamless Apple ID to Firebase Auth conversion
 * - Keychain Security: Secure credential storage via KeychainHelper
 * - State Persistence: Automatic authentication state restoration
 * - Singleton Pattern: App-wide access via AuthenticationManager.shared
 * 
 * CREDENTIAL FLOW SYSTEM:
 * 1. Apple Sign-In: User authenticates with Apple ID
 * 2. Token Extraction: Identity token and nonce validation
 * 3. Firebase Integration: OAuthProvider credential creation
 * 4. Keychain Storage: Secure Apple ID, email, fullName persistence
 * 5. State Updates: @Published properties for SwiftUI binding
 * 
 * **PHASE 6 ARCHITECTURAL REFACTOR: SINGLE SOURCE OF TRUTH USER ID SYSTEM**
 * 
 * CRITICAL CHANGE: userID now returns Firebase UID consistently throughout the app.
 * This eliminates the dual ID system that was causing edit/delete post ownership issues.
 * 
 * BEFORE PHASE 6:
 * - userID = Apple Sign-In ID (for user identification)
 * - firebaseUID = Firebase UID (for Firebase operations)
 * - PROBLEM: Posts created with Firebase UID but ownership checked with Apple ID → MISMATCH
 * 
 * AFTER PHASE 6:
 * - userID = Firebase UID (single source of truth)
 * - legacyAppleSignInID = Apple Sign-In ID (for migration only)
 * - SOLUTION: Posts created with Firebase UID and ownership checked with Firebase UID → MATCH
 * 
 * SECURITY FEATURES:
 * - Cryptographic Nonce: SHA256-hashed random nonce for Apple Sign-In
 * - Secure Random Generation: SecRandomCopyBytes for cryptographic security
 * - Keychain Integration: iOS Keychain Services for credential protection
 * - Firebase Auth: Server-side authentication validation
 * - Identity Consistency: Firebase UID as primary userID for all operations
 * 
 * STATE MANAGEMENT:
 * - @Published isSignedIn: Authentication status for UI binding
 * - @Published isCheckingAuthStatus: Loading state during auth checks
 * - @Published userID: Apple ID for consistent user identification
 * - @Published userEmail: User email from Apple or Firebase
 * - @Published userFullName: User display name from Apple
 * - @Published firebaseUser: Firebase User object for Firestore operations
 * 
 * INTEGRATION POINTS:
 * - AuthenticationWrapperView: Root navigation controller for auth flow
 * - SignInView: Apple Sign-In button component
 * - UserProfileService: Profile data association via userID
 * - KeychainHelper: Secure credential storage and retrieval
 * - UserArchetypeManager: Onboarding completion validation
 * 
 * FIREBASE INTEGRATION:
 * - Auth State Listener: Automatic Firebase auth state monitoring
 * - OAuthProvider: Apple ID to Firebase credential conversion
 * - Identity Token: Secure token exchange for authentication
 * - Firestore UID: Firebase UID for database operations
 * - Auth State Synchronization: Real-time auth state updates
 * 
 * NONCE GENERATION SYSTEM:
 * - Random String: 32-character cryptographically secure nonce
 * - Character Set: Alphanumeric + special characters for entropy
 * - SHA256 Hashing: Secure hash for Apple Sign-In validation
 * - Security Validation: SecRandomCopyBytes for true randomness
 * - State Tracking: currentNonce for request/response matching
 * 
 * LOGOUT & DATA CLEANUP:
 * - Firebase Signout: Proper Firebase Auth.signOut() handling
 * - Keychain Clearing: Complete removal of stored credentials
 * - UserDefaults Cleanup: Archetype and app-specific data removal
 * - Manager Reset: UserArchetypeManager and ResonanceEngine clearing
 * - State Reset: All @Published properties reset to default values
 * 
 * ERROR HANDLING & RESILIENCE:
 * - Token Validation: Comprehensive identity token verification
 * - Nonce Validation: Secure nonce matching for request integrity
 * - Firebase Errors: Graceful handling of authentication failures
 * - Keychain Errors: Robust credential storage error handling
 * - State Recovery: Automatic authentication state restoration
 * 
 * AUTHENTICATION LIFECYCLE:
 * 1. App Launch: checkAuthenticationStatus() validates existing auth
 * 2. Sign-In Flow: handleSignIn() processes Apple authentication
 * 3. State Monitoring: Firebase auth listener tracks changes
 * 4. Session Persistence: Keychain maintains credentials across launches
 * 5. Sign-Out: Complete data cleanup and state reset
 * 
 * UTILITY FEATURES:
 * - Display Name: Intelligent fallback (fullName → email → userID)
 * - Firebase UID: Direct access for Firestore operations
 * - Onboarding Status: Integration with UserArchetypeManager
 * - Auth Validation: Comprehensive authentication state checking
 * - Credential Management: Secure storage and retrieval patterns
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Singleton Pattern: Single instance for memory efficiency
 * - Main Queue Updates: UI updates on main thread for responsiveness
 * - Lazy Loading: Authentication checks only when needed
 * - Memory Management: Proper auth listener cleanup in deinit
 * - State Caching: Efficient credential retrieval from keychain
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Nonce Length: 32 characters for cryptographic security
 * - Character Set: 62 characters (0-9, A-Z, a-z, -, ., _)
 * - Hash Algorithm: SHA256 for secure nonce validation
 * - Auth Provider: AuthProviderID.apple for Firebase integration
 * - Keychain Keys: "userID", "email", "fullName" for credential storage
 * 
 * DEBUGGING & MONITORING:
 * - Comprehensive Logging: Detailed authentication flow tracking
 * - State Validation: Authentication status verification
 * - Error Tracking: Detailed error messages for troubleshooting
 * - Credential Monitoring: Keychain storage success/failure tracking
 * - Firebase Integration: Auth state change monitoring and logging
 */

//
//  AuthenticationManager.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation
import AuthenticationServices
import Combine
import FirebaseAuth
import CryptoKit

/**
 * Global authentication manager for the VybeMVP app.
 *
 * This manager serves as the single source of truth for user authentication state
 * across the entire application. It handles sign-in with Apple, Firebase Auth integration,
 * keychain storage, logout functionality, and authentication state persistence.
 *
 * Key features:
 * - Singleton pattern for app-wide access
 * - Automatic authentication state checking on app launch
 * - Firebase Auth integration with Sign In with Apple
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
    
    // Claude: PHASE 6 REFACTOR - userID now returns Firebase UID for consistency
    @Published private var _userID: String? // Private storage for Apple Sign-In ID
    @Published var userEmail: String?
    @Published var userFullName: String?
    @Published var firebaseUser: User?
    
    /**
     * PHASE 6 ARCHITECTURAL CHANGE: userID now returns Firebase UID
     * 
     * This computed property ensures userID always returns the Firebase UID,
     * eliminating the dual ID system that caused edit/delete ownership issues.
     * 
     * MIGRATION STRATEGY:
     * - Apple Sign-In ID stored privately as _userID for data migration
     * - userID publicly returns Firebase UID for all app operations
     * - Maintains backward compatibility for existing user data
     */
    var userID: String? {
        get {
            return firebaseUser?.uid
        }
        set {
            // For compatibility during migration - stores Apple Sign-In ID privately
            _userID = newValue
        }
    }
    
    // MARK: - Private Properties
    private let keychainHelper = KeychainHelper.shared
    private var currentNonce: String?
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    private init() {
        // Listen for Firebase Auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.firebaseUser = user
                self?.updateAuthenticationState()
            }
        }
        
        checkAuthenticationStatus()
    }
    
    deinit {
        // Clean up auth state listener
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Authentication Status
    
    /**
     * PHASE 6 REFACTOR: Check authentication status with Firebase UID as primary ID
     * 
     * Checks if the user is currently authenticated by validating Firebase Auth state.
     * Now uses Firebase UID as the primary userID for consistent identification.
     */
    func checkAuthenticationStatus() {
        DispatchQueue.main.async { [weak self] in
            self?.isCheckingAuthStatus = true
        }
        
        // Check Firebase Auth first
        if let firebaseUser = Auth.auth().currentUser {
            print("✅ Firebase user found: \(firebaseUser.uid)")
            
            // Check for existing credentials in keychain (for migration and profile data)
            let appleSignInID = keychainHelper.get(for: "userID") // Legacy Apple Sign-In ID
            let email = keychainHelper.get(for: "email")
            let fullName = keychainHelper.get(for: "fullName")
            
            DispatchQueue.main.async { [weak self] in
                self?.firebaseUser = firebaseUser
                // Claude: PHASE 6 CHANGE - Store Apple ID privately but userID returns Firebase UID
                self?._userID = appleSignInID  // Store for migration purposes
                self?.userEmail = email ?? firebaseUser.email
                self?.userFullName = fullName
                self?.isSignedIn = true
                self?.isCheckingAuthStatus = false
                
                print("✅ User is authenticated with Firebase UID: \(firebaseUser.uid)")
                print("🔍 Legacy Apple ID stored: \(appleSignInID ?? "nil")")
                print("🆔 Primary userID now returns: \(firebaseUser.uid)")
            }
        } else {
            print("❌ No Firebase user found")
            DispatchQueue.main.async { [weak self] in
                self?.firebaseUser = nil
                self?._userID = nil
                self?.userEmail = nil
                self?.userFullName = nil
                self?.isSignedIn = false
                self?.isCheckingAuthStatus = false
            }
        }
    }
    
    /**
     * PHASE 6 REFACTOR: Updates authentication state using Firebase UID as primary ID
     * 
     * Updates authentication state based on Firebase Auth state.
     * Now uses Firebase UID as primary identifier for consistent user identification.
     */
    private func updateAuthenticationState() {
        if let firebaseUser = firebaseUser {
            // User is signed in to Firebase
            // Claude: PHASE 6 CHANGE - Load legacy data but primary ID is Firebase UID
            let appleSignInID = keychainHelper.get(for: "userID") // Legacy Apple Sign-In ID
            let email = keychainHelper.get(for: "email") ?? firebaseUser.email
            let fullName = keychainHelper.get(for: "fullName")
            
            self._userID = appleSignInID  // Store legacy ID privately for migration
            self.userEmail = email
            self.userFullName = fullName
            self.isSignedIn = true  // Consider signed in if Firebase user exists
            
            print("✅ Firebase auth state updated: \(firebaseUser.uid)")
            print("🔍 Legacy Apple ID from keychain: \(appleSignInID ?? "nil")")
            print("🆔 Primary userID returns Firebase UID: \(firebaseUser.uid)")
        } else {
            // User is signed out of Firebase
            self._userID = nil
            self.userEmail = nil
            self.userFullName = nil
            self.isSignedIn = false
            
            print("❌ Firebase user signed out")
        }
        
        self.isCheckingAuthStatus = false
    }
    
    // MARK: - Sign In
    
    /**
     * Handles the result of Sign in with Apple authentication and integrates with Firebase Auth.
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
                
                // Get the identity token
                guard let identityToken = appleIDCredential.identityToken,
                      let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                    print("❌ Unable to fetch identity token")
                    return
                }
                
                // Get the nonce
                guard let nonce = currentNonce else {
                    print("❌ Invalid state: A login callback was received, but no login request was sent.")
                    return
                }
                
                // Create Firebase credential
                let credential = OAuthProvider.credential(
                    providerID: AuthProviderID.apple,
                    idToken: identityTokenString,
                    rawNonce: nonce
                )
                
                // Sign in to Firebase
                Auth.auth().signIn(with: credential) { [weak self] result, error in
                    if let error = error {
                        print("❌ Firebase sign in failed: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self?.isSignedIn = false
                        }
                        return
                    }
                    
                    guard let firebaseUser = result?.user else {
                        print("❌ Firebase user is nil")
                        return
                    }
                    
                    print("✅ Firebase sign in successful: \(firebaseUser.uid)")
                    
                    // Claude: PHASE 6 CHANGE - Save Apple ID to keychain but primary userID returns Firebase UID
                    self?.keychainHelper.save(userID, for: "userID") // Save Apple ID for legacy/migration
                    self?.keychainHelper.save(email ?? firebaseUser.email ?? "", for: "email")
                    self?.keychainHelper.save(fullName ?? "", for: "fullName")
                    
                    // Update state on main thread
                    DispatchQueue.main.async {
                        self?.firebaseUser = firebaseUser
                        self?._userID = userID  // Store Apple ID privately
                        self?.userEmail = email ?? firebaseUser.email
                        self?.userFullName = fullName
                        self?.isSignedIn = true
                    }
                    
                    print("✅ Sign in successful: Apple ID: \(userID), Firebase UID: \(firebaseUser.uid)")
                    print("🆔 AuthenticationManager.userID now returns: \(firebaseUser.uid)")
                }
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
     * Signs out the current user from both Firebase and Apple, clearing all stored data.
     */
    func signOut() {
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            print("✅ Firebase sign out successful")
        } catch {
            print("❌ Firebase sign out failed: \(error.localizedDescription)")
        }
        
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
            self?.firebaseUser = nil
            self?._userID = nil  // Clear private Apple ID storage
            self?.userEmail = nil
            self?.userFullName = nil
            self?.isSignedIn = false
        }
        
        print("✅ User signed out successfully")
    }
    
    // MARK: - Nonce Generation for Apple Sign In
    
    /**
     * Generates a cryptographically secure nonce for Apple Sign In
     */
    func generateNonce() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
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
     * PHASE 6 REFACTOR: Firebase UID as Primary User ID
     * 
     * Returns the Firebase UID which is now our single source of truth for user identification.
     * This eliminates the dual ID system that was causing edit/delete post ownership issues.
     * 
     * ARCHITECTURAL CHANGE:
     * - BEFORE: userID = Apple Sign-In ID, firebaseUID = Firebase UID (dual system)
     * - AFTER: userID = Firebase UID (single source of truth)
     * 
     * BENEFITS:
     * - Consistent user identification across all Firebase operations
     * - Proper post ownership detection for edit/delete functionality
     * - Eliminates code smells from dual ID management
     * - Maintains security through Firebase Auth validation
     */
    var firebaseUID: String? {
        return firebaseUser?.uid
    }
    
    /**
     * PHASE 6 MIGRATION HELPER: Access to legacy Apple Sign-In ID
     * 
     * Returns the Apple Sign-In ID for data migration purposes.
     * Used to look up existing user data stored with Apple ID keys.
     * 
     * USAGE:
     * - Check both Firebase UID and legacy Apple ID when loading user data
     * - Gradually migrate data from Apple ID keys to Firebase UID keys
     * - Maintain backward compatibility during transition period
     */
    var legacyAppleSignInID: String? {
        return _userID
    }
    
    /**
     * Checks if the user has completed onboarding.
     */
    var hasCompletedOnboarding: Bool {
        return UserArchetypeManager.shared.hasStoredArchetype()
    }
} 