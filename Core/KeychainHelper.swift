//
//  KeychainHelper.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import Foundation

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
