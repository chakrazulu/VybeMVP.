//
//  UserArchetype.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation

/**
 * Core spiritual identity model representing a user's complete archetypal profile.
 *
 * This model combines multiple spiritual systems to create a comprehensive
 * identity framework including numerology, astrology, elemental alignment,
 * and planetary archetypes for both conscious and subconscious influence.
 *
 * The archetype is calculated once during onboarding from the user's birthdate
 * and remains constant throughout their experience in the app.
 */
struct UserArchetype: Codable, Equatable {
    /// Life Path number (1-9, 11, 22, 33) - primary numerological identity
    let lifePath: Int

    /// Zodiac sign based on birth date
    let zodiacSign: ZodiacSign

    /// Elemental alignment derived from zodiac sign
    let element: Element

    /// Primary planetary archetype based on life path number
    let primaryPlanet: Planet

    /// Subconscious planetary influence based on life path number
    let subconsciousPlanet: Planet

    /// Date when this archetype was calculated
    let calculatedDate: Date

    /// Computed property for UI display of planetary influences
    var planetaryDescription: String {
        if lifePath == 11 || lifePath == 22 || lifePath == 33 {
            return "\(primaryPlanet.rawValue.capitalized) / \(subconsciousPlanet.rawValue.capitalized) (Master)"
        } else {
            return "\(primaryPlanet.rawValue.capitalized) (Primary) • \(subconsciousPlanet.rawValue.capitalized) (Shadow)"
        }
    }

    /// Computed property for element description
    var elementDescription: String {
        return "\(element.rawValue.capitalized) • \(element.qualities)"
    }

    /// Computed property for zodiac description
    var zodiacDescription: String {
        return "\(zodiacSign.rawValue) • \(zodiacSign.dateRange)"
    }
}

/**
 * Elemental archetypes derived from zodiac signs
 */
enum Element: String, CaseIterable, Codable {
    case fire = "fire"
    case earth = "earth"
    case air = "air"
    case water = "water"

    /// Qualities and characteristics of each element
    var qualities: String {
        switch self {
        case .fire:
            return "Passion • Initiation • Creative Force"
        case .earth:
            return "Grounding • Manifestation • Stability"
        case .air:
            return "Communication • Ideas • Mental Clarity"
        case .water:
            return "Emotion • Intuition • Flowing Wisdom"
        }
    }

    /// Compatible elements for resonance matching
    var compatibleElements: [Element] {
        switch self {
        case .fire:
            return [.fire, .air] // Fire feeds on air
        case .earth:
            return [.earth, .water] // Earth holds water
        case .air:
            return [.air, .fire] // Air feeds fire
        case .water:
            return [.water, .earth] // Water nourishes earth
        }
    }
}

/**
 * Planetary archetypes for conscious and subconscious influence
 */
enum Planet: String, CaseIterable, Codable {
    case sun = "sun"
    case moon = "moon"
    case mercury = "mercury"
    case venus = "venus"
    case mars = "mars"
    case jupiter = "jupiter"
    case saturn = "saturn"
    case uranus = "uranus"
    case neptune = "neptune"
    case pluto = "pluto"
    case earth = "earth"

    /// Archetypal qualities of each planet
    var archetype: String {
        switch self {
        case .sun:
            return "The Sovereign • Leadership • Divine Will"
        case .moon:
            return "The Mystic • Intuition • Emotional Wisdom"
        case .mercury:
            return "The Messenger • Communication • Quick Mind"
        case .venus:
            return "The Lover • Beauty • Harmony"
        case .mars:
            return "The Warrior • Action • Initiative"
        case .jupiter:
            return "The Sage • Expansion • Divine Teaching"
        case .saturn:
            return "The Master • Structure • Sacred Discipline"
        case .uranus:
            return "The Rebel • Innovation • Lightning Awakening"
        case .neptune:
            return "The Dreamer • Transcendence • Divine Union"
        case .pluto:
            return "The Transformer • Death/Rebirth • Deep Power"
        case .earth:
            return "The Builder • Manifestation • Sacred Form"
        }
    }
}

/**
 * Zodiac signs with date ranges for calculation
 */
enum ZodiacSign: String, CaseIterable, Codable {
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"

    /// Date range for each zodiac sign
    var dateRange: String {
        switch self {
        case .aries:
            return "Mar 21 - Apr 19"
        case .taurus:
            return "Apr 20 - May 20"
        case .gemini:
            return "May 21 - Jun 20"
        case .cancer:
            return "Jun 21 - Jul 22"
        case .leo:
            return "Jul 23 - Aug 22"
        case .virgo:
            return "Aug 23 - Sep 22"
        case .libra:
            return "Sep 23 - Oct 22"
        case .scorpio:
            return "Oct 23 - Nov 21"
        case .sagittarius:
            return "Nov 22 - Dec 21"
        case .capricorn:
            return "Dec 22 - Jan 19"
        case .aquarius:
            return "Jan 20 - Feb 18"
        case .pisces:
            return "Feb 19 - Mar 20"
        }
    }

    /// Element associated with this zodiac sign
    var element: Element {
        switch self {
        case .aries, .leo, .sagittarius:
            return .fire
        case .taurus, .virgo, .capricorn:
            return .earth
        case .gemini, .libra, .aquarius:
            return .air
        case .cancer, .scorpio, .pisces:
            return .water
        }
    }
}
