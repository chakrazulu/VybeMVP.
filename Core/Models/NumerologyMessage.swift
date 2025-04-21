/**
 * Filename: NumerologyMessage.swift
 * 
 * Purpose: Defines the model for loading and accessing numerology message content
 * from JSON files in the NumerologyData directory. The content is organized by
 * number (0-9) and category (insight, reflection, manifestation, etc.).
 *
 * Key components:
 * - NumerologyMessage: Represents a single message for a specific number and category
 * - NumerologyCategory: Enum of available message categories
 * - NumerologyMessageManager: Manages loading and accessing all numerology messages
 *
 * Dependencies: Foundation
 */

import Foundation
import os

/// Represents a single numerology message with its associated number and category
struct NumerologyMessage: Identifiable {
    /// Unique identifier for the message
    var id = UUID()
    
    /// The number (0-9) associated with this message
    let number: Int
    
    /// The category this message belongs to
    let category: NumerologyCategory
    
    /// The message text content
    let content: String
}

/// Available categories for numerology messages
enum NumerologyCategory: String, CaseIterable {
    case insight
    case reflection
    case contemplation
    case manifestation
    case challenge
    case physical_practice
    case shadow
    case archetype
    case energy_check
    case numerical_context
    case astrological
    
    /// Display-friendly name for the category
    var displayName: String {
        switch self {
        case .insight:
            return "Insight"
        case .reflection:
            return "Reflection"
        case .contemplation:
            return "Contemplation"
        case .manifestation:
            return "Manifestation"
        case .challenge:
            return "Challenge"
        case .physical_practice:
            return "Physical Practice"
        case .shadow:
            return "Shadow"
        case .archetype:
            return "Archetype"
        case .energy_check:
            return "Energy Check"
        case .numerical_context:
            return "Numerical Context"
        case .astrological:
            return "Astrological"
        }
    }
}

/**
 * Manages the loading and access to numerology messages from JSON files
 *
 * This singleton class loads message content from JSON files in the NumerologyData
 * directory and provides methods to access messages by number, category, or randomly.
 */
class NumerologyMessageManager {
    /// Shared singleton instance for app-wide access
    static let shared = NumerologyMessageManager()
    
    /// Dictionary storing all loaded messages, organized by number and category
    private var messagesByNumberAndCategory: [Int: [NumerologyCategory: [NumerologyMessage]]] = [:]
    
    /// Logger for debugging and tracking
    private let logger = os.Logger(subsystem: "com.vybemvp", category: "NumerologyMessageManager")
    
    /// Private initializer to enforce singleton pattern
    private init() {
        // Don't load automatically here anymore
        // loadAllMessages()
    }

    /**
     * Explicitly loads or reloads all messages.
     * Ensures messages are loaded synchronously when called.
     */
    func preloadMessages() {
        // Clear existing messages if reloading
        if !messagesByNumberAndCategory.isEmpty {
            messagesByNumberAndCategory.removeAll()
            print("🧹 Cleared existing messages before reloading.")
        }
        loadAllMessages()
    }
    
    /**
     * Loads all numerology messages from JSON files in the NumerologyData directory
     *
     * This method:
     * 1. Locates the JSON files in the NumerologyData directory
     * 2. Parses each file into an in-memory dictionary
     * 3. Organizes messages by number and category for quick access
     */
    private func loadAllMessages() {
        // REMOVE Bundle Path and Contents Diagnostics
        // if let resourcePath = Bundle.main.resourcePath { ... }
        
        // Keep this info log
        logger.info("Loading numerology messages from JSON files")
        
        // Initialize storage for all numbers (0-9)
        for number in 0...9 {
            messagesByNumberAndCategory[number] = [:]
            
            // Initialize each category for this number
            for category in NumerologyCategory.allCases {
                messagesByNumberAndCategory[number]?[category] = []
            }
        }
        
        // Loop through numbers 0-9 to load each JSON file
        for number in 0...9 {
            loadMessagesForNumber(number)
        }
        
        // Log summary of loaded messages
        var totalMessages = 0
        for (number, categories) in messagesByNumberAndCategory {
            for (category, messages) in categories {
                totalMessages += messages.count
                print("Loaded \(messages.count) messages for number \(number), category \(category.rawValue)")
            }
        }
        
        print("✅ Loaded a total of \(totalMessages) numerology messages")
    }
    
    /**
     * Loads messages for a specific number from its JSON file
     *
     * @param number The number (0-9) to load messages for
     */
    private func loadMessagesForNumber(_ number: Int) {
        guard number >= 0 && number <= 9 else {
            logger.error("Invalid number: \(number), must be between 0-9")
            return
        }
        
        // Construct the file path for the number's JSON file
        guard let fileURL = Bundle.main.url(forResource: "NumberMessages_Complete_\(number)", 
                                           withExtension: "json") else {
            print("⚠️ Could not find JSON file for number \(number) in bundle root.")
            return
        }
        
        do {
            // Read and parse the JSON data
            let jsonData = try Data(contentsOf: fileURL)
            guard let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let numberDict = json["\(number)"] as? [String: Any] else {
                print("⚠️ Invalid JSON structure for number \(number)")
                return
            }
            
            // Process each category in the JSON
            for category in NumerologyCategory.allCases {
                guard let messages = numberDict[category.rawValue] as? [String] else {
                    print("⚠️ No messages found for number \(number), category \(category.rawValue)")
                    continue
                }
                
                // Create NumerologyMessage objects for each message in this category
                let numerologyMessages = messages.map { content in
                    NumerologyMessage(number: number, category: category, content: content)
                }
                
                // Store the messages
                messagesByNumberAndCategory[number]?[category] = numerologyMessages
            }
            
            print("✅ Successfully loaded messages for number \(number)")
        } catch {
            print("❌ Error loading messages for number \(number): \(error.localizedDescription)")
        }
    }
    
    /**
     * Gets all messages for a specific number and category
     *
     * @param number The number (0-9) to get messages for
     * @param category The category to get messages for
     * @return Array of NumerologyMessage objects
     */
    func getMessages(forNumber number: Int, category: NumerologyCategory) -> [NumerologyMessage] {
        guard number >= 0 && number <= 9 else { return [] }
        return messagesByNumberAndCategory[number]?[category] ?? []
    }
    
    /**
     * Gets a random message for a specific number and category
     *
     * @param number The number (0-9) to get a message for
     * @param category The category to get a message for
     * @return Optional NumerologyMessage (nil if no messages found)
     */
    func getRandomMessage(forNumber number: Int, category: NumerologyCategory) -> NumerologyMessage? {
        let messages = getMessages(forNumber: number, category: category)
        return messages.randomElement()
    }
    
    /**
     * Gets a random message for a specific number from any category
     *
     * @param number The number (0-9) to get a message for
     * @return Optional NumerologyMessage (nil if no messages found)
     */
    func getRandomMessage(forNumber number: Int) -> NumerologyMessage? {
        // Get a random category that has messages for this number
        guard let categories = messagesByNumberAndCategory[number]?.keys.filter({ 
            !(messagesByNumberAndCategory[number]?[$0]?.isEmpty ?? true)
        }), 
        !categories.isEmpty,
        let randomCategory = categories.randomElement() else {
            return nil
        }
        
        return getRandomMessage(forNumber: number, category: randomCategory)
    }
    
    /**
     * Gets a set of random messages for a specific number, one from each category
     *
     * @param number The number (0-9) to get messages for
     * @return Dictionary mapping categories to random messages
     */
    func getRandomMessagesForAllCategories(forNumber number: Int) -> [NumerologyCategory: NumerologyMessage] {
        var result: [NumerologyCategory: NumerologyMessage] = [:]
        
        for category in NumerologyCategory.allCases {
            if let message = getRandomMessage(forNumber: number, category: category) {
                result[category] = message
            }
        }
        
        return result
    }
    
    /**
     * Refreshes all messages by reloading them from JSON files
     * Useful for debugging or after content updates
     */
    func refreshAllMessages() {
        messagesByNumberAndCategory.removeAll()
        loadAllMessages()
    }
} 