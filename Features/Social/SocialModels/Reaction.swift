//
//  Reaction.swift
//  VybeMVP
//
//  Model for energy-based reactions in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore
import SwiftUI

/**
 * Reaction represents a spiritual response to a post with cosmic context
 */
struct Reaction: Identifiable, Codable {
    @DocumentID var id: String?

    // Core reaction data
    let postId: String
    let userId: String
    let userDisplayName: String
    let reactionType: ReactionType
    let timestamp: Date

    // Cosmic context of the user when they reacted
    let cosmicSignature: CosmicSignature

    init(
        postId: String,
        userId: String,
        userDisplayName: String,
        reactionType: ReactionType,
        cosmicSignature: CosmicSignature
    ) {
        self.postId = postId
        self.userId = userId
        self.userDisplayName = userDisplayName
        self.reactionType = reactionType
        self.timestamp = Date()
        self.cosmicSignature = cosmicSignature
    }
}

/**
 * ReactionType defines the energy-based reactions users can give
 */
enum ReactionType: String, Codable, CaseIterable {
    case resonance = "resonance"
    case gratitude = "gratitude"
    case love = "love"
    case wisdom = "wisdom"
    case healing = "healing"
    case manifestation = "manifestation"
    case protection = "protection"
    case clarity = "clarity"

    var displayName: String {
        switch self {
        case .resonance: return "Resonance"
        case .gratitude: return "Gratitude"
        case .love: return "Love"
        case .wisdom: return "Wisdom"
        case .healing: return "Healing"
        case .manifestation: return "Manifestation"
        case .protection: return "Protection"
        case .clarity: return "Clarity"
        }
    }

    var emoji: String {
        switch self {
        case .resonance: return "🌊"
        case .gratitude: return "🙏"
        case .love: return "💖"
        case .wisdom: return "🔮"
        case .healing: return "✨"
        case .manifestation: return "⭐"
        case .protection: return "🛡️"
        case .clarity: return "💎"
        }
    }

    var color: Color {
        switch self {
        case .resonance: return .blue
        case .gratitude: return .green
        case .love: return .pink
        case .wisdom: return .purple
        case .healing: return .cyan
        case .manifestation: return .yellow
        case .protection: return .orange
        case .clarity: return .white
        }
    }

    var description: String {
        switch self {
        case .resonance: return "This resonates with my energy"
        case .gratitude: return "I'm grateful for this sharing"
        case .love: return "Sending love and light"
        case .wisdom: return "This brings wisdom"
        case .healing: return "This supports healing"
        case .manifestation: return "This supports manifestation"
        case .protection: return "Sending protective energy"
        case .clarity: return "This brings clarity"
        }
    }
}

// MARK: - Extensions

extension Reaction {
    /**
     * Returns a formatted display of the reaction with cosmic context
     */
    var cosmicReactionDisplay: String {
        let signature = cosmicSignature
        return "\(userDisplayName) reacted with \(reactionType.emoji) \(reactionType.displayName) while channeling \(signature.currentChakra.capitalized) Chakra energy, Focus Number \(signature.focusNumber)"
    }

    /**
     * Returns a short cosmic signature for compact display
     */
    var shortCosmicDisplay: String {
        return "Focus \(cosmicSignature.focusNumber) • \(cosmicSignature.currentChakra.capitalized)"
    }

    /**
     * Returns the sacred color for this reaction's cosmic signature
     */
    var sacredColor: Color {
        return getSacredColor(for: cosmicSignature.focusNumber)
    }
}

/**
 * Helper function to get sacred colors for numbers (matches Post.swift)
 */
private func getSacredColor(for number: Int) -> Color {
    switch number {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return .green
    case 5: return .blue
    case 6: return .indigo
    case 7: return .purple
    case 8: return .brown
    case 9: return .white
    default: return .gray
    }
}
