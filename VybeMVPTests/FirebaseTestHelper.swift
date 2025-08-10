//
//  FirebaseTestHelper.swift
//  VybeMVPTests
//
//  Created to centralize Firebase configuration for tests
//  Prevents race conditions and duplicate configuration attempts
//

import Foundation
import FirebaseCore

/**
 * Claude: Firebase Test Helper
 *
 * PURPOSE:
 * Provides thread-safe Firebase configuration for unit tests
 * Ensures Firebase is only configured once across all test runs
 */
class FirebaseTestHelper {

    private static let configurationQueue = DispatchQueue(label: "com.vybemvp.firebase.test.config")
    private static var isConfigured = false

    /**
     * Configure Firebase for tests in a thread-safe manner
     * Safe to call from multiple test classes simultaneously
     */
    static func configureFirebaseForTests() {
        configurationQueue.sync {
            guard !isConfigured else { return }

            if FirebaseApp.app() == nil {
                // Configure Firebase
                FirebaseApp.configure()
                isConfigured = true
                print("✅ Firebase configured successfully for tests")
            } else {
                isConfigured = true
                print("✅ Firebase already configured")
            }
        }
    }
}
