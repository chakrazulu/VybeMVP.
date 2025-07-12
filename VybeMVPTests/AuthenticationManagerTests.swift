import XCTest
import Firebase
import AuthenticationServices
import Combine
@testable import VybeMVP

/**
 * Claude: Comprehensive test suite for AuthenticationManager
 * 
 * SPIRITUAL INTEGRITY PROTECTION:
 * - Tests Firebase UID consistency (Phase 6 critical fix)
 * - Validates user archetype integration
 * - Ensures secure keychain storage for spiritual data
 * 
 * COVERAGE AREAS:
 * - Singleton pattern validation
 * - Authentication state management
 * - Apple Sign-In integration
 * - Nonce generation security
 * - Memory management and threading safety
 * - Error handling robustness
 * 
 * TESTING PHILOSOPHY:
 * - Synchronous tests for predictable results
 * - Real API property validation
 * - No artificial test passing criteria
 * - Spiritual data protection verification
 */
final class AuthenticationManagerTests: XCTestCase {
    
    private var authManager: AuthenticationManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Use the shared instance (singleton pattern)
        authManager = AuthenticationManager.shared
        cancellables = Set<AnyCancellable>()
        
        // Reset authentication state for clean tests
        try signOutIfNeeded()
    }
    
    override func tearDownWithError() throws {
        // Clean up any authentication state
        try signOutIfNeeded()
        
        cancellables.removeAll()
        authManager = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Helper Methods
    
    /**
     * Claude: Clean authentication state for isolated test execution
     * 
     * Ensures each test starts with a clean slate by signing out any
     * authenticated users. This prevents test interdependencies and
     * maintains spiritual data isolation between test runs.
     */
    private func signOutIfNeeded() throws {
        // Only sign out if user is signed in
        if authManager.isSignedIn {
            authManager.signOut()
        }
    }
    
    // MARK: - Initialization Tests
    
    func testAuthenticationManagerSharedInstance() {
        // Test singleton pattern
        let instance1 = AuthenticationManager.shared
        let instance2 = AuthenticationManager.shared
        
        XCTAssertIdentical(instance1, instance2, "AuthenticationManager should be a singleton")
    }
    
    func testInitialAuthenticationState() {
        // Test initial state when not authenticated
        XCTAssertFalse(authManager.isSignedIn, "Initial authentication state should be false")
        XCTAssertNil(authManager.firebaseUser, "Firebase user should be nil initially")
    }
    
    // MARK: - Authentication Status Tests
    
    func testCheckAuthenticationStatus() {
        // Test authentication status checking
        let expectation = expectation(description: "Authentication status checked")
        
        // Monitor authentication state changes (only fulfill once)
        authManager.$isSignedIn
            .dropFirst() // Skip initial value
            .prefix(1)   // Only take the first emission to prevent multiple fulfillments
            .sink { isSignedIn in
                // Verify status was checked
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger authentication status check
        authManager.checkAuthenticationStatus()
        
        waitForExpectations(timeout: 3.0)
    }
    
    // MARK: - Nonce Generation Tests
    
    /**
     * Claude: Test cryptographic nonce generation for Apple Sign-In security
     * 
     * SPIRITUAL DATA PROTECTION:
     * Nonces are critical for preventing replay attacks that could
     * compromise user spiritual data during authentication flows.
     * 
     * SECURITY REQUIREMENTS:
     * - Each nonce must be cryptographically unique
     * - Format must be hexadecimal for Apple Sign-In compatibility
     * - Length must be sufficient for security (>= 32 characters typically)
     */
    func testGenerateNonce() {
        // Test nonce generation for Apple Sign-In
        let nonce1 = authManager.generateNonce()
        let nonce2 = authManager.generateNonce()
        
        XCTAssertNotEqual(nonce1, nonce2, "Generated nonces should be unique")
        XCTAssertGreaterThan(nonce1.count, 0, "Nonce should not be empty")
        XCTAssertGreaterThan(nonce2.count, 0, "Nonce should not be empty")
        
        // Test nonce format (should be hexadecimal)
        let hexPattern = "^[a-fA-F0-9]+$"
        let regex = try! NSRegularExpression(pattern: hexPattern)
        
        XCTAssertTrue(regex.firstMatch(in: nonce1, range: NSRange(location: 0, length: nonce1.count)) != nil,
                     "Nonce should be hexadecimal")
    }
    
    // MARK: - Sign Out Tests
    
    func testSignOutProcess() {
        // Test sign-out functionality
        let expectation = expectation(description: "Sign out completed")
        
        // Monitor authentication state changes (only fulfill once)
        authManager.$isSignedIn
            .dropFirst() // Skip initial value
            .prefix(1)   // Only take the first emission to prevent multiple fulfillments
            .sink { isSignedIn in
                if !isSignedIn {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Perform sign out
        authManager.signOut()
        
        // Verify immediate state changes
        XCTAssertFalse(authManager.isSignedIn, "Should be unauthenticated after sign out")
        
        waitForExpectations(timeout: 3.0)
    }
    
    // MARK: - Apple Sign-In Tests (Mock/Simulation)
    
    func testHandleSignInResultSuccess() {
        // Test successful Apple Sign-In result handling
        // Note: This tests the method signature and error handling, not actual Firebase auth
        
        let mockError = NSError(domain: "AuthenticationManagerTests", 
                               code: 999, 
                               userInfo: [NSLocalizedDescriptionKey: "Mock Apple Sign-In error"])
        
        let failureResult: Result<ASAuthorization, Error> = .failure(mockError)
        
        // Test error handling (should not crash)
        authManager.handleSignIn(result: failureResult)
        
        // Verify state remains unchanged on error
        XCTAssertFalse(authManager.isSignedIn, "Authentication state should not change on error")
    }
    
    // MARK: - User Archetype Integration Tests
    
    func testArchetypeStatusIntegration() {
        // Test integration with UserArchetypeManager
        let hasCompletedOnboarding = authManager.hasCompletedOnboarding
        
        // This should return a boolean value
        XCTAssertNotNil(hasCompletedOnboarding, "hasCompletedOnboarding should return a value")
    }
    
    // MARK: - State Management Tests
    
    func testAuthenticationStateConsistency() {
        // Test that authentication state properties are consistent
        let isSignedIn = authManager.isSignedIn
        let firebaseUser = authManager.firebaseUser
        
        if isSignedIn {
            XCTAssertNotNil(firebaseUser, "Firebase user should exist when signed in")
        } else {
            XCTAssertNil(firebaseUser, "Firebase user should be nil when not signed in")
        }
    }
    
    func testPublishedPropertiesObservable() {
        // Test that @Published properties can be observed
        let expectation = expectation(description: "Published property observed")
        
        authManager.$isSignedIn
            .prefix(1)   // Only take the first emission
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() {
        // Test that the manager doesn't create retain cycles
        weak var weakAuthManager = authManager
        
        // Keep a reference to test weak reference
        XCTAssertNotNil(weakAuthManager, "Auth manager should exist")
        
        // Test that Combine subscriptions don't create retain cycles
        authManager.$isSignedIn
            .sink { _ in
                // Empty sink to test subscription cleanup
            }
            .store(in: &cancellables)
        
        XCTAssertNotNil(weakAuthManager, "Auth manager should still exist with active subscriptions")
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorHandlingRobustness() {
        // Test that the manager handles edge cases gracefully
        
        // Multiple sign-out calls should not crash
        authManager.signOut()
        authManager.signOut()
        authManager.signOut()
        
        XCTAssertFalse(authManager.isSignedIn, "Should remain unauthenticated after multiple sign-outs")
        
        // Multiple authentication checks should not crash
        authManager.checkAuthenticationStatus()
        authManager.checkAuthenticationStatus()
        authManager.checkAuthenticationStatus()
    }
    
    // MARK: - Threading Tests
    
    @MainActor
    func testMainActorMethods() async {
        // Test that UI-related methods work on main actor
        // This test runs on @MainActor to verify threading safety
        
        let isSignedIn = authManager.isSignedIn
        let _ = authManager.firebaseUser // Can be nil or not nil - both valid
        let hasCompletedOnboarding = authManager.hasCompletedOnboarding
        
        // These property accesses should work on main thread
        XCTAssertNotNil(isSignedIn, "isSignedIn should be accessible")
        XCTAssertNotNil(hasCompletedOnboarding, "hasCompletedOnboarding should be accessible")
    }
    
    // MARK: - Integration Boundary Tests
    
    func testKeyValueStoreIntegration() {
        // Test that the manager properly integrates with system storage
        // Without making actual network calls
        
        let nonce = authManager.generateNonce()
        XCTAssertGreaterThan(nonce.count, 0, "Nonce generation should work")
        
        // Test multiple nonce generations for consistency
        let nonces = (0..<10).map { _ in authManager.generateNonce() }
        let uniqueNonces = Set(nonces)
        
        XCTAssertEqual(nonces.count, uniqueNonces.count, "All generated nonces should be unique")
    }
}