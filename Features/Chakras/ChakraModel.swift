//
//  ChakraModel.swift
//  VybeMVP
//
//  Phantom of the Chakras - Core Data Model
//

import SwiftUI
import AVFoundation

/// Represents the seven chakras in the spiritual energy system
enum ChakraType: Int, CaseIterable {
    case root = 1
    case sacral = 2
    case solarPlexus = 3
    case heart = 4
    case throat = 5
    case thirdEye = 6
    case crown = 7
    
    /// Sanskrit name of the chakra
    var sanskritName: String {
        switch self {
        case .root: return "Muladhara"
        case .sacral: return "Svadhisthana"
        case .solarPlexus: return "Manipura"
        case .heart: return "Anahata"
        case .throat: return "Vishuddha"
        case .thirdEye: return "Ajna"
        case .crown: return "Sahasrara"
        }
    }
    
    /// English name of the chakra
    var name: String {
        switch self {
        case .root: return "Root"
        case .sacral: return "Sacral"
        case .solarPlexus: return "Solar Plexus"
        case .heart: return "Heart"
        case .throat: return "Throat"
        case .thirdEye: return "Third Eye"
        case .crown: return "Crown"
        }
    }
    
    /// Primary color associated with the chakra
    var color: Color {
        switch self {
        case .root: return Color(red: 228/255, green: 3/255, blue: 3/255) // Red
        case .sacral: return Color(red: 255/255, green: 117/255, blue: 26/255) // Orange
        case .solarPlexus: return Color(red: 255/255, green: 205/255, blue: 0/255) // Yellow
        case .heart: return Color(red: 30/255, green: 190/255, blue: 75/255) // Green
        case .throat: return Color(red: 0/255, green: 145/255, blue: 234/255) // Blue
        case .thirdEye: return Color(red: 75/255, green: 0/255, blue: 130/255) // Indigo
        case .crown: return Color(red: 145/255, green: 44/255, blue: 238/255) // Violet
        }
    }
    
    /// Healing frequency in Hz (Solfeggio frequencies)
    var frequency: Double {
        switch self {
        case .root:       return 261.63  // C4 - fundamental
        case .sacral:     return 293.66  // D4 - major second
        case .solarPlexus: return 329.63  // E4 - major third
        case .heart:      return 392.00  // G4 - perfect fifth
        case .throat:     return 440.00  // A4 - major sixth
        case .thirdEye:   return 523.25  // C5 - octave
        case .crown:      return 659.25  // E5 - major tenth (octave + third)
        }
    }
    
    /// Element associated with the chakra
    var element: String {
        switch self {
        case .root: return "Earth"
        case .sacral: return "Water"
        case .solarPlexus: return "Fire"
        case .heart: return "Air"
        case .throat: return "Ether"
        case .thirdEye: return "Light"
        case .crown: return "Thought"
        }
    }
    
    /// Body location of the chakra
    var location: String {
        switch self {
        case .root: return "Base of spine"
        case .sacral: return "Lower abdomen"
        case .solarPlexus: return "Upper abdomen"
        case .heart: return "Center of chest"
        case .throat: return "Throat"
        case .thirdEye: return "Between eyebrows"
        case .crown: return "Top of head"
        }
    }
    
    /// Primary mantra/vowel sound
    var mantra: String {
        switch self {
        case .root: return "LAM"
        case .sacral: return "VAM"
        case .solarPlexus: return "RAM"
        case .heart: return "YAM"
        case .throat: return "HAM"
        case .thirdEye: return "OM"
        case .crown: return "AH"
        }
    }
    
    /// Associated emotions and qualities
    var qualities: [String] {
        switch self {
        case .root: return ["Security", "Grounding", "Stability", "Trust"]
        case .sacral: return ["Creativity", "Sexuality", "Emotion", "Pleasure"]
        case .solarPlexus: return ["Power", "Will", "Confidence", "Transformation"]
        case .heart: return ["Love", "Compassion", "Balance", "Connection"]
        case .throat: return ["Communication", "Truth", "Expression", "Authenticity"]
        case .thirdEye: return ["Intuition", "Wisdom", "Insight", "Vision"]
        case .crown: return ["Unity", "Enlightenment", "Consciousness", "Bliss"]
        }
    }
    
    /// Numerological associations (based on chakra number and resonance)
    var numerologicalResonance: [Int] {
        switch self {
        case .root: return [1, 4, 8] // Foundation numbers
        case .sacral: return [2, 6] // Partnership and harmony
        case .solarPlexus: return [3, 9] // Expression and completion
        case .heart: return [4, 6] // Balance and love
        case .throat: return [5] // Communication
        case .thirdEye: return [7, 11] // Spiritual insight
        case .crown: return [8, 9, 22] // Mastery and transcendence
        }
    }
    
    /// Affirmation for the chakra
    var affirmation: String {
        switch self {
        case .root: return "I am safe, grounded, and secure"
        case .sacral: return "I embrace pleasure and creative flow"
        case .solarPlexus: return "I am powerful and confident"
        case .heart: return "I give and receive love freely"
        case .throat: return "I speak my truth with clarity"
        case .thirdEye: return "I trust my intuition and inner wisdom"
        case .crown: return "I am connected to the divine consciousness"
        }
    }
    
    /// Symbol representation for the chakra
    var symbolName: String {
        switch self {
        case .root: return "circle.grid.cross.fill"
        case .sacral: return "moon.circle.fill"
        case .solarPlexus: return "sun.max.fill"
        case .heart: return "heart.fill"
        case .throat: return "waveform.circle.fill"
        case .thirdEye: return "eye.fill"
        case .crown: return "sparkles"
        }
    }
}

/// Model representing a chakra's current state
struct ChakraState: Identifiable {
    let id = UUID()
    let type: ChakraType
    var isActive: Bool = false
    var isHarmonizing: Bool = false
    var glowIntensity: Double = 0.3
    var pulseRate: Double = 1.0 // Multiplier for animation speed
    var volume: Float = 0.7 // Individual volume level (0.0 - 1.0)
    
    /// Check if this chakra resonates with a given number
    func resonatesWith(number: Int) -> Bool {
        return type.numerologicalResonance.contains(number)
    }
}

/// Configuration for chakra interactions
struct ChakraConfiguration {
    var enableSound: Bool = true
    var enableHaptics: Bool = true
    var enableVisualEffects: Bool = true
    var enableAffirmations: Bool = true
    var volumeLevel: Float = 0.7
    var meditationDuration: TimeInterval = 300 // 5 minutes default
    var speechRate: Float = 0.5 // Slow and meditative
    var speechVolume: Float = 0.8
} 