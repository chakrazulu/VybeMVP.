//
//  SocialUser.swift
//  VybeMVP
//
//  Model for user profiles in the Global Resonance Timeline
//

import Foundation
import SwiftUI

/**
 * SocialUser represents a user's profile in the social timeline
 * Contains numerological and spiritual information for cosmic matching
 */
struct SocialUser: Identifiable, Codable {
    let id: String
    let userId: String
    let displayName: String
    
    // Core numerological profile
    let lifePathNumber: Int
    let soulUrgeNumber: Int
    let expressionNumber: Int
    let currentFocusNumber: Int
    
    // Optional spiritual preferences
    let preferredChakras: [String]?
    let spiritualInterests: [String]?
    let cosmicPreferences: [String]?
    
    // Profile metadata
    let joinDate: Date
    let isPublic: Bool
    
    init(
        userId: String,
        displayName: String,
        lifePathNumber: Int,
        soulUrgeNumber: Int,
        expressionNumber: Int,
        currentFocusNumber: Int = 1,
        preferredChakras: [String]? = nil,
        spiritualInterests: [String]? = nil,
        cosmicPreferences: [String]? = nil,
        isPublic: Bool = true
    ) {
        self.id = userId // Use userId as the id for consistency
        self.userId = userId
        self.displayName = displayName
        self.lifePathNumber = lifePathNumber
        self.soulUrgeNumber = soulUrgeNumber
        self.expressionNumber = expressionNumber
        self.currentFocusNumber = currentFocusNumber
        self.preferredChakras = preferredChakras
        self.spiritualInterests = spiritualInterests
        self.cosmicPreferences = cosmicPreferences
        self.joinDate = Date()
        self.isPublic = isPublic
    }
}

// MARK: - Extensions

extension SocialUser {
    /**
     * Returns the user's current cosmic signature for posting
     */
    var currentCosmicSignature: CosmicSignature {
        return CosmicSignature(
            focusNumber: currentFocusNumber,
            currentChakra: getCurrentChakra(),
            lifePathNumber: lifePathNumber,
            realmNumber: getCurrentRealmNumber()
        )
    }
    
    /**
     * Returns the user's primary sacred color based on life path number
     */
    var primarySacredColor: Color {
        return getSacredColor(for: lifePathNumber)
    }
    
    /**
     * Returns the user's focus color based on current focus number
     */
    var focusColor: Color {
        return getSacredColor(for: currentFocusNumber)
    }
    
    /**
     * Returns a formatted display of the user's numerological profile
     */
    var numerologicalProfile: String {
        return "Life Path \(lifePathNumber) • Soul Urge \(soulUrgeNumber) • Expression \(expressionNumber)"
    }
    
    /**
     * Returns a short display of key numbers
     */
    var shortProfile: String {
        return "LP\(lifePathNumber) • Focus\(currentFocusNumber)"
    }
    
    // MARK: - Private Helper Methods
    
    /**
     * Gets the user's current active chakra (simplified logic)
     */
    private func getCurrentChakra() -> String {
        // Simple mapping based on current focus number
        // In a real app, this might be more sophisticated
        let chakras = ["root", "sacral", "solar", "heart", "throat", "third-eye", "crown"]
        let index = min(max(currentFocusNumber - 1, 0), chakras.count - 1)
        return chakras[index]
    }
    
    /**
     * Gets the current realm number (would integrate with RealmNumberManager)
     */
    private func getCurrentRealmNumber() -> Int {
        // Placeholder - in real app, this would come from RealmNumberManager
        return Int.random(in: 1...9)
    }
}

/**
 * Helper function to get sacred colors for numbers
 */
private func getSacredColor(for number: Int) -> Color {
    switch number {
    case 1: return .red          // Creation/Fire 🔥
    case 2: return .orange       // Partnership/Balance ⚖️
    case 3: return .yellow       // Expression/Joy ☀️
    case 4: return .green        // Foundation/Earth 🌍
    case 5: return .blue         // Freedom/Sky 🌌
    case 6: return .indigo       // Harmony/Love 💜
    case 7: return .purple       // Spirituality/Wisdom 🔮
    case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold - Abundance/Prosperity 💰
    case 9: return .white        // Completion/Universal ⚪
    default: return .gray
    }
}

// MARK: - Sample Data

extension SocialUser {
    /**
     * Creates a sample user for previews and testing
     */
    static var sampleUser: SocialUser {
        return SocialUser(
            userId: "sample-user-123",
            displayName: "Cosmic Wanderer",
            lifePathNumber: 7,
            soulUrgeNumber: 3,
            expressionNumber: 5,
            currentFocusNumber: 7,
            preferredChakras: ["crown", "third-eye", "heart"],
            spiritualInterests: ["meditation", "numerology", "astrology"],
            cosmicPreferences: ["moon-phases", "planetary-alignments"]
        )
    }
    
    /**
     * Creates the current user profile (mock data)
     */
    static var currentUser: SocialUser {
        return SocialUser(
            userId: "000536.fe41c9f51a0543059da7d6fe0dc44b7f.1946",
            displayName: "Corey Jermaine Davis",
            lifePathNumber: 3,
            soulUrgeNumber: 5,
            expressionNumber: 7,
            currentFocusNumber: 3,
            preferredChakras: ["heart", "throat", "solar"],
            spiritualInterests: ["manifestation", "creativity", "expression"],
            cosmicPreferences: ["numerology", "synchronicity"]
        )
    }
} 