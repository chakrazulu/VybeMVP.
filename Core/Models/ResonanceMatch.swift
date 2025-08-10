//
//  ResonanceMatch.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation
import SwiftAA  // For Planet type

/**
 * Model representing internal spiritual resonance patterns.
 *
 * This model tracks when the user experiences various types of internal
 * spiritual alignment and synchronicity within their own number patterns,
 * archetypal energies, and daily spiritual practice.
 *
 * Used for local resonance detection before implementing social matching.
 */
struct ResonanceMatch: Identifiable, Codable {
    /// Unique identifier for this resonance match
    let id: UUID

    /// Type of resonance detected
    let type: ResonanceType

    /// Descriptive details about the match
    let matchDetails: String

    /// When this resonance was detected
    let timestamp: Date

    /// Strength of the resonance (0.0 to 1.0)
    let intensity: Double

    /// Current numbers involved in the resonance
    let involvedNumbers: [Int]

    /// User's archetype at time of match (if relevant)
    let archetypeContext: ArchetypeContext?
}

/**
 * Types of internal resonance that can be detected.
 */
enum ResonanceType: String, CaseIterable, Codable {
    /// User's focus number matches their realm number
    case focusRealmAlignment = "focus_realm_alignment"

    /// Multiple numbers in the user's experience align
    case numericalHarmony = "numerical_harmony"

    /// User's archetype aligns with current cosmic timing
    case archetypeActivation = "archetype_activation"

    /// User is experiencing elemental balance
    case elementalSync = "elemental_sync"

    /// Planetary influences align with user's archetype
    case planetaryResonance = "planetary_resonance"

    /// User maintains consistent spiritual practice
    case practiceFlow = "practice_flow"

    /// Sequential numbers or meaningful patterns
    case sequentialMagic = "sequential_magic"

    /// User's insight streaks and spiritual momentum
    case spiritualMomentum = "spiritual_momentum"

    /// Human-readable description
    var description: String {
        switch self {
        case .focusRealmAlignment:
            return "Focus & Realm Alignment"
        case .numericalHarmony:
            return "Numerical Harmony"
        case .archetypeActivation:
            return "Archetype Activation"
        case .elementalSync:
            return "Elemental Synchronization"
        case .planetaryResonance:
            return "Planetary Resonance"
        case .practiceFlow:
            return "Practice Flow"
        case .sequentialMagic:
            return "Sequential Magic"
        case .spiritualMomentum:
            return "Spiritual Momentum"
        }
    }

    /// Emoji representation for UI
    var emoji: String {
        switch self {
        case .focusRealmAlignment:
            return "🎯"
        case .numericalHarmony:
            return "🔢"
        case .archetypeActivation:
            return "⭐"
        case .elementalSync:
            return "🌊"
        case .planetaryResonance:
            return "🪐"
        case .practiceFlow:
            return "🧘"
        case .sequentialMagic:
            return "✨"
        case .spiritualMomentum:
            return "🚀"
        }
    }

    /// Color theme for UI display
    var color: String {
        switch self {
        case .focusRealmAlignment:
            return "purple"
        case .numericalHarmony:
            return "blue"
        case .archetypeActivation:
            return "gold"
        case .elementalSync:
            return "cyan"
        case .planetaryResonance:
            return "indigo"
        case .practiceFlow:
            return "green"
        case .sequentialMagic:
            return "pink"
        case .spiritualMomentum:
            return "orange"
        }
    }
}

/**
 * Archetype context for resonance matches.
 */
struct ArchetypeContext: Codable, Equatable {
    /// User's life path number
    let lifePath: Int

    /// Current elemental influence
    let element: Element

    /// Primary planetary archetype
    let primaryPlanet: Planet

    /// Whether this is a master number
    let isMasterNumber: Bool

    /// Current zodiac season relevance
    let zodiacRelevance: String?
}

// MARK: - Resonance Match Extensions

extension ResonanceMatch {
    /// Creates a focus-realm alignment match
    static func focusRealmAlignment(focusNumber: Int, realmNumber: Int, intensity: Double = 1.0) -> ResonanceMatch {
        ResonanceMatch(
            id: UUID(),
            type: .focusRealmAlignment,
            matchDetails: "Your focus number \(focusNumber) perfectly aligns with your realm number \(realmNumber). This is a moment of divine synchronicity.",
            timestamp: Date(),
            intensity: intensity,
            involvedNumbers: [focusNumber, realmNumber],
            archetypeContext: nil
        )
    }

    /// Creates a numerical harmony match
    static func numericalHarmony(numbers: [Int], pattern: String, intensity: Double = 0.8) -> ResonanceMatch {
        ResonanceMatch(
            id: UUID(),
            type: .numericalHarmony,
            matchDetails: "Sacred numerical pattern detected: \(pattern). Numbers \(numbers.map(String.init).joined(separator: ", ")) are creating harmony in your experience.",
            timestamp: Date(),
            intensity: intensity,
            involvedNumbers: numbers,
            archetypeContext: nil
        )
    }

    /// Creates an archetype activation match
    static func archetypeActivation(archetype: UserArchetype, description: String, intensity: Double = 0.9) -> ResonanceMatch {
        let context = ArchetypeContext(
            lifePath: archetype.lifePath,
            element: archetype.element,
            primaryPlanet: archetype.primaryPlanet,
            isMasterNumber: [11, 22, 33].contains(archetype.lifePath),
            zodiacRelevance: archetype.zodiacSign.rawValue
        )

        return ResonanceMatch(
            id: UUID(),
            type: .archetypeActivation,
            matchDetails: description,
            timestamp: Date(),
            intensity: intensity,
            involvedNumbers: [archetype.lifePath],
            archetypeContext: context
        )
    }

    /// Creates a sequential magic match for meaningful number sequences
    static func sequentialMagic(sequence: [Int], meaning: String, intensity: Double = 0.7) -> ResonanceMatch {
        ResonanceMatch(
            id: UUID(),
            type: .sequentialMagic,
            matchDetails: "Meaningful sequence detected: \(sequence.map(String.init).joined(separator: "→")). \(meaning)",
            timestamp: Date(),
            intensity: intensity,
            involvedNumbers: sequence,
            archetypeContext: nil
        )
    }

    /// Creates a spiritual momentum match for streaks and consistency
    static func spiritualMomentum(streakDays: Int, practiceType: String, intensity: Double = 0.6) -> ResonanceMatch {
        ResonanceMatch(
            id: UUID(),
            type: .spiritualMomentum,
            matchDetails: "Spiritual momentum building: \(streakDays) consecutive days of \(practiceType). Your dedication is creating sacred rhythm.",
            timestamp: Date(),
            intensity: intensity,
            involvedNumbers: [streakDays],
            archetypeContext: nil
        )
    }
}

// MARK: - Display Extensions

extension ResonanceMatch {
    /// User-friendly title for the match
    var title: String {
        switch type {
        case .focusRealmAlignment:
            return "Perfect Alignment"
        case .numericalHarmony:
            return "Sacred Pattern"
        case .archetypeActivation:
            return "Archetype Activated"
        case .elementalSync:
            return "Elemental Balance"
        case .planetaryResonance:
            return "Cosmic Alignment"
        case .practiceFlow:
            return "Sacred Practice"
        case .sequentialMagic:
            return "Divine Sequence"
        case .spiritualMomentum:
            return "Spiritual Flow"
        }
    }

    /// Short subtitle for the match
    var subtitle: String {
        switch type {
        case .focusRealmAlignment:
            return "Focus ↔ Realm"
        case .numericalHarmony:
            return involvedNumbers.map(String.init).joined(separator: " • ")
        case .archetypeActivation:
            return archetypeContext?.element.rawValue.capitalized ?? "Active"
        case .elementalSync:
            return "Balanced"
        case .planetaryResonance:
            return archetypeContext?.primaryPlanet.rawValue.capitalized ?? "Aligned"
        case .practiceFlow:
            return "Consistent"
        case .sequentialMagic:
            return involvedNumbers.map(String.init).joined(separator: "→")
        case .spiritualMomentum:
            return "\(involvedNumbers.first ?? 0) days"
        }
    }

    /// Intensity as a percentage string
    var intensityPercentage: String {
        return "\(Int(intensity * 100))%"
    }

    /// Formatted timestamp
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    /// Formatted date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
}
