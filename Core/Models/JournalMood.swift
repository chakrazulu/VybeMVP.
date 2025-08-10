/**
 * Filename: JournalMood.swift
 *
 * Purpose: Defines the mood options available for journal entries within the app.
 *
 * This file contains the JournalMood enum which represents the different emotional
 * states that users can select when creating journal entries. Each mood is represented
 * by an emoji and has a corresponding text description.
 *
 * Design pattern: Swift enum with raw values and computed properties
 * Dependencies: Foundation
 */

import Foundation

/**
 * Represents the different mood options available for journal entries
 *
 * This enum provides a standardized set of moods that users can select when
 * creating journal entries. Each mood is represented by an emoji (raw value)
 * and has a corresponding text description.
 *
 * The enum conforms to:
 * - String: Raw values are emoji characters
 * - CaseIterable: Allows iteration over all mood options
 *
 * Usage:
 * ```
 * // Access a specific mood
 * let happyMood = JournalMood.happy
 *
 * // Get the emoji representation
 * let emoji = JournalMood.happy.rawValue  // Returns "😊"
 *
 * // Get the text description
 * let description = JournalMood.happy.description  // Returns "Happy"
 *
 * // Iterate through all moods
 * for mood in JournalMood.allCases {
 *     print("\(mood.rawValue) - \(mood.description)")
 * }
 * ```
 */
public enum JournalMood: String, CaseIterable {
    /// Happy mood represented by 😊
    case happy = "😊"
    /// Sad mood represented by 😢
    case sad = "😢"
    /// Angry mood represented by 😠
    case angry = "😠"
    /// Peaceful mood represented by 😌
    case peaceful = "😌"
    /// Anxious mood represented by 😰
    case anxious = "😰"
    /// Excited mood represented by 🤩
    case excited = "🤩"

    /**
     * The text description of the mood
     *
     * This computed property returns the human-readable name of the mood,
     * which can be used in UI elements and for accessibility purposes.
     */
    var description: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .angry: return "Angry"
        case .peaceful: return "Peaceful"
        case .anxious: return "Anxious"
        case .excited: return "Excited"
        }
    }
}
