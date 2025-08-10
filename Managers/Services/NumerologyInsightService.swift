/*
 * ========================================
 * 🔮 NUMEROLOGY INSIGHT SERVICE - SPIRITUAL CONTENT LOADER
 * ========================================
 *
 * CORE PURPOSE:
 * Service layer for loading and accessing numerology insights from JSON files.
 * Provides structured access to spiritual content organized by number (0-9) and category.
 * Handles file loading, JSON parsing, and content retrieval for the numerology system.
 *
 * TECHNICAL ARCHITECTURE:
 * - Singleton pattern for app-wide access
 * - JSON file loading from NumerologyData directory
 * - Fallback loading from bundle root
 * - Structured content organization by number and category
 *
 * CONTENT ORGANIZATION:
 * - Numbers: 0-9 (each with dedicated JSON file)
 * - Categories: insight, reflection, contemplation, manifestation, etc.
 * - File naming: NumberMessages_Complete_{number}.json
 * - Directory structure: NumerologyData/ subdirectory preferred
 *
 * LOADING STRATEGY:
 * 1. Primary: Load from NumerologyData/ subdirectory
 * 2. Fallback: Load from app bundle root
 * 3. Error handling: Comprehensive logging and nil returns
 *
 * INTEGRATION POINTS:
 * - AIInsightManager: Primary consumer of insight content
 * - NumerologyMessageManager: Alternative content loading system
 * - NotificationManager: Uses insights for push notifications
 * - Various views: Display spiritual content to users
 *
 * PERFORMANCE CONSIDERATIONS:
 * - File loading on-demand (not preloaded)
 * - JSON parsing per request
 * - Random message selection for variety
 * - Comprehensive error logging for debugging
 */

import Foundation

// Claude: Removed duplicate InsightCategory struct - now using SwiftData enum from NumberMeaning.swift

/**
 * NumerologyInsightService: Core service for loading numerology insights from JSON files
 *
 * Provides methods to fetch individual insights or all messages for a given number
 * and category. Handles file loading, JSON parsing, and content retrieval with
 * comprehensive error handling and logging.
 */
struct NumerologyInsightService {
    /// Shared singleton instance for app-wide access
    static let shared = NumerologyInsightService()

    /// Private initializer to enforce singleton pattern
    private init() {}

    // MARK: - Public Methods

    /**
     * Fetches a random insight for a specific number and category
     *
     * Loads the JSON file for the given number and returns a random message
     * from the specified category. Handles file loading with fallback strategies.
     *
     * @param number The numerology number (0-9) to fetch insights for
     * @param category The category of insight to fetch (defaults to "insight")
     * @return A random insight message or nil if loading fails
     */
    func fetchInsight(forNumber number: Int, category: String = InsightCategory.insight.rawValue) -> String? {
        guard (0...9).contains(number) else {
            print("Error: Invalid number provided to fetchInsight: \(number)")
            return nil
        }

        let filename = "NumberMessages_Complete_\(number).json"

        // Try to load from "NumerologyData" subdirectory first
        if let url = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: "NumerologyData") {
            print("Found \(filename) in NumerologyData subdirectory.")
            return loadInsightFromUrl(url: url, number: number, category: category, filename: filename)
        } else {
            print("Warning: Could not find \(filename) in NumerologyData subdirectory. Attempting bundle root...")
            // Fallback: Attempt to load from the root of the app bundle
            if let fallbackUrl = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: nil) {
                 print("Found \(filename) in app bundle root.")
                 return loadInsightFromUrl(url: fallbackUrl, number: number, category: category, filename: filename)
            } else {
                print("Error: Could not find \(filename) in NumerologyData subdirectory OR in the app bundle root.")
                return nil
            }
        }
    }

    // MARK: - Private Helper Methods

    /**
     * Loads and parses a single insight from a JSON file URL
     *
     * Handles the actual JSON parsing and message extraction for a specific
     * number and category. Returns a random message for variety.
     *
     * @param url The URL of the JSON file to load
     * @param number The numerology number being processed
     * @param category The category of message to extract
     * @param filename The filename for error logging
     * @return A random insight message or nil if parsing fails
     */
    private func loadInsightFromUrl(url: URL, number: Int, category: String, filename: String) -> String? {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            guard let rootDictionary = json as? [String: Any],
                  let numberMessages = rootDictionary[String(number)] as? [String: [String]],
                  let messages = numberMessages[category],
                  !messages.isEmpty else {
                print("Error: Could not parse messages for number \(number), category '\(category)' from \(filename). JSON structure might be incorrect or category/messages missing.")
                return nil
            }

            // Return a random message from the array for variety
            return messages.randomElement()

        } catch {
            print("Error loading or parsing \(filename) for number \(number), category '\(category)': \(error)")
            return nil
        }
    }

    /**
     * Fetches all messages for a specific number and category
     *
     * Loads the JSON file for the given number and returns all messages
     * from the specified category. Useful for displaying multiple options
     * or for content management.
     *
     * @param number The numerology number (0-9) to fetch messages for
     * @param category The category of messages to fetch
     * @return Array of all messages for the category or nil if loading fails
     */
    func fetchAllMessages(forNumber number: Int, category: String) -> [String]? {
        guard (0...9).contains(number) else {
            print("Error: Invalid number provided to fetchAllMessages: \(number)")
            return nil
        }

        let filename = "NumberMessages_Complete_\(number).json"

        // Try to load from "NumerologyData" subdirectory first
        if let url = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: "NumerologyData") {
            print("Found \(filename) in NumerologyData subdirectory for fetchAllMessages.")
            return loadAllMessagesFromUrl(url: url, number: number, category: category, filename: filename)
        } else {
            print("Warning: Could not find \(filename) in NumerologyData subdirectory for fetchAllMessages. Attempting bundle root...")
            // Fallback: Attempt to load from the root of the app bundle
            if let fallbackUrl = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: nil) {
                print("Found \(filename) in app bundle root for fetchAllMessages.")
                return loadAllMessagesFromUrl(url: fallbackUrl, number: number, category: category, filename: filename)
            } else {
                print("Error: Could not find \(filename) in NumerologyData subdirectory OR in the app bundle root for fetchAllMessages.")
                return nil
            }
        }
    }

    /**
     * Loads and parses all messages from a JSON file URL
     *
     * Handles the actual JSON parsing and message extraction for all messages
     * in a specific category. Returns the complete array of messages.
     *
     * @param url The URL of the JSON file to load
     * @param number The numerology number being processed
     * @param category The category of messages to extract
     * @param filename The filename for error logging
     * @return Array of all messages for the category or nil if parsing fails
     */
    private func loadAllMessagesFromUrl(url: URL, number: Int, category: String, filename: String) -> [String]? {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            guard let rootDictionary = json as? [String: Any],
                  let numberMessages = rootDictionary[String(number)] as? [String: [String]],
                  let messages = numberMessages[category] else {
                print("Error: Could not parse messages for number \(number), category '\(category)' from \(filename). JSON structure might be incorrect or category/messages missing.")
                return nil
            }
            return messages
        } catch {
            print("Error loading or parsing \(filename) for number \(number), category '\(category)': \(error)")
            return nil
        }
    }
}
