/**
 * TestConfiguration.swift
 * 💰 FIREBASE COST PROTECTION
 *
 * Claude: This file ensures tests don't trigger expensive Firebase operations
 * Protects your billing by disabling cloud services during testing
 */

import Foundation

/// Claude: Test environment configuration to prevent costly Firebase operations
class TestConfiguration {

    /// Global flag to disable Firebase during tests
    static var isTestMode: Bool = {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }()

    /// Prevent Firebase initialization during tests
    static func configureTestEnvironment() {
        if isTestMode {
            // Set environment flags to disable Firebase services
            setenv("DISABLE_FIREBASE", "1", 1)
            setenv("FIREBASE_OFFLINE_MODE", "1", 1)

            print("🛡️ TEST MODE ACTIVATED")
            print("💰 Firebase services disabled to protect billing")
            print("🌌 Cosmic calculations will run offline only")
        }
    }

    /// Check if we should skip Firebase-dependent operations
    static var shouldSkipFirebaseOperations: Bool {
        return isTestMode ||
               ProcessInfo.processInfo.environment["DISABLE_FIREBASE"] == "1"
    }

    /// Mock Firebase responses for testing
    static func mockFirebaseResponse<T>(defaultValue: T) -> T {
        if isTestMode {
            print("🔄 Mocking Firebase response to prevent billing charges")
        }
        return defaultValue
    }
}

/**
 * 💡 USAGE IN YOUR APP:
 *
 * Before any Firebase operation, check:
 *
 * if TestConfiguration.shouldSkipFirebaseOperations {
 *     // Use offline/mock data instead
 *     return mockData
 * }
 *
 * // Normal Firebase operation
 * firestore.collection("data").getDocuments { ... }
 */
