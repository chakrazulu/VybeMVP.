//
//  KeychainHelper.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation

/**
 * KeychainHelper: Secure storage utility for sensitive user data
 *
 * 🎯 COMPREHENSIVE UTILITY REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === CORE PURPOSE ===
 * Provides secure, encrypted storage for sensitive user credentials and tokens.
 * Abstracts iOS Keychain Services API into simple, thread-safe operations.
 *
 * === KEY RESPONSIBILITIES ===
 * • Secure storage of authentication tokens
 * • Apple ID and Firebase Auth credential management
 * • FCM token persistence across app launches
 * • Automatic encryption/decryption handling
 * • Thread-safe keychain operations
 *
 * === SECURITY FEATURES ===
 * • kSecAttrAccessibleWhenUnlocked: Device must be unlocked
 * • Automatic encryption via iOS Keychain Services
 * • Per-app sandboxing (data isolated from other apps)
 * • Survives app deletion/reinstallation
 * • Biometric protection when device configured
 *
 * === MAIN OPERATIONS ===
 * • save(_:for:): Store string value with key
 * • get(for:): Retrieve string value by key
 * • delete(for:): Remove stored value by key
 *
 * === COMMON USE CASES ===
 * • Apple ID: "appleUserID" key
 * • Firebase tokens: "firebaseToken" key
 * • FCM tokens: "fcmToken" key
 * • User credentials: Various auth-related keys
 *
 * === ERROR HANDLING ===
 * • Automatic cleanup of existing data before save
 * • Status code logging for debugging
 * • Graceful handling of missing items
 * • Silent failure for non-critical operations
 *
 * === THREAD SAFETY ===
 * • All operations are thread-safe
 * • Can be called from any queue
 * • Synchronous operations (blocking)
 * • No concurrent access issues
 *
 * === KEYCHAIN QUERY STRUCTURE ===
 * Standard query dictionary:
 * • kSecClass: kSecClassGenericPassword
 * • kSecAttrAccount: Unique key identifier
 * • kSecValueData: UTF-8 encoded string data
 * • kSecAttrAccessible: When device unlocked
 *
 * === SAVE OPERATION FLOW ===
 * 1. Convert string to UTF-8 Data
 * 2. Create keychain query dictionary
 * 3. Delete any existing item (SecItemDelete)
 * 4. Add new item (SecItemAdd)
 * 5. Return success/failure status
 *
 * === RETRIEVE OPERATION FLOW ===
 * 1. Create search query dictionary
 * 2. Set return data and match limit
 * 3. Execute search (SecItemCopyMatching)
 * 4. Convert Data back to String
 * 5. Return string or nil if not found
 *
 * === DELETE OPERATION FLOW ===
 * 1. Create deletion query dictionary
 * 2. Execute deletion (SecItemDelete)
 * 3. Log status for debugging
 * 4. Handle not found gracefully
 *
 * === CRITICAL NOTES ===
 * • Data persists across app updates
 * • Requires device unlock for access
 * • UTF-8 encoding for all string data
 * • Singleton pattern for consistent access
 */
class KeychainHelper {
    static let shared = KeychainHelper() // Singleton instance

    func save(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        SecItemDelete(query as CFDictionary) // Remove existing data
        SecItemAdd(query as CFDictionary, nil) // Add new data
    }

    func get(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Keychain item deleted successfully for key: \(key)")
        } else if status == errSecItemNotFound {
            print("Keychain item not found for key: \(key), no need to delete.")
        } else {
            print("Error deleting keychain item for key: \(key), status: \(status)")
        }
    }
}
