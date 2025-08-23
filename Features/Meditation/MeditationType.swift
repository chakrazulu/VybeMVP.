import SwiftUI
import Foundation

/**
 * Meditation Type System - Adaptive Spiritual Experiences
 * =======================================================
 *
 * Revolutionary meditation categorization that adapts HRV biofeedback, messaging,
 * and guidance based on the user's spiritual intention and healing needs.
 *
 * ## 🎭 Design Philosophy
 *
 * Each meditation type provides:
 * - **Specific messaging** tailored to the practice goal
 * - **Adaptive thresholds** for different spiritual states
 * - **Custom visual themes** that support the intention
 * - **Persona-aware guidance** from KASPER MLX consciousness engine
 *
 * ## 🌊 HRV Biofeedback Adaptation
 *
 * Different practices require different coherence approaches:
 * - **High-Energy**: Manifestation may allow higher baseline BPM
 * - **Gentle**: Trauma therapy uses lower improvement thresholds
 * - **Sustained**: Reflective practices reward longer sessions
 * - **Heart-Opening**: Gratitude focuses on heart coherence patterns
 *
 * Created: August 2025
 * Version: 1.0.0 - Foundational meditation type system
 */

// MARK: - Meditation Type Definitions

/// Defines different types of meditation experiences with tailored guidance and thresholds
enum MeditationType: String, CaseIterable, Identifiable, Codable {
    case affirmation = "affirmation"
    case manifestation = "manifestation"
    case reflective = "reflective"
    case traumaTherapy = "traumaTherapy"
    case gratitude = "gratitude"
    case chakraBalancing = "chakraBalancing"
    case breathwork = "breathwork"
    case lovingKindness = "lovingKindness"

    var id: String { rawValue }

    // MARK: - Display Properties

    /// Human-readable name for UI display
    var displayName: String {
        switch self {
        case .affirmation:
            return "Affirmation Meditation"
        case .manifestation:
            return "Manifestation Session"
        case .reflective:
            return "Reflective Practice"
        case .traumaTherapy:
            return "Trauma Healing"
        case .gratitude:
            return "Gratitude Practice"
        case .chakraBalancing:
            return "Chakra Balancing"
        case .breathwork:
            return "Breathwork Session"
        case .lovingKindness:
            return "Loving-Kindness"
        }
    }

    /// Short description of the meditation type
    var description: String {
        switch self {
        case .affirmation:
            return "Positive self-talk with heart coherence feedback"
        case .manifestation:
            return "Goal visualization with biometric alignment confirmation"
        case .reflective:
            return "Deep contemplation with sustained coherence rewards"
        case .traumaTherapy:
            return "Gentle healing-focused sessions with compassionate guidance"
        case .gratitude:
            return "Heart-opening appreciation exercises"
        case .chakraBalancing:
            return "Energy center alignment with spiritual insight"
        case .breathwork:
            return "Conscious breathing with rhythm synchronization"
        case .lovingKindness:
            return "Compassion cultivation for self and others"
        }
    }

    /// SF Symbol icon representing the meditation type
    var icon: String {
        switch self {
        case .affirmation:
            return "speaker.wave.3.fill"
        case .manifestation:
            return "target"
        case .reflective:
            return "brain.head.profile"
        case .traumaTherapy:
            return "heart.fill"
        case .gratitude:
            return "hands.sparkles.fill"
        case .chakraBalancing:
            return "circle.grid.3x3.fill"
        case .breathwork:
            return "lungs.fill"
        case .lovingKindness:
            return "heart.circle.fill"
        }
    }

    /// Primary color theme for the meditation type
    var primaryColor: Color {
        switch self {
        case .affirmation:
            return .blue
        case .manifestation:
            return .purple
        case .reflective:
            return .indigo
        case .traumaTherapy:
            return .green
        case .gratitude:
            return .orange
        case .chakraBalancing:
            return .red
        case .breathwork:
            return .cyan
        case .lovingKindness:
            return .pink
        }
    }

    // MARK: - HRV Biofeedback Adaptation

    /// BPM improvement threshold required for coherence achievement
    /// Lower values make it easier to achieve green celebration states
    var improvementThreshold: Double {
        switch self {
        case .traumaTherapy:
            return 2.0  // Gentler threshold for healing work
        case .gratitude, .lovingKindness:
            return 2.5  // Heart-opening practices are naturally calming
        case .breathwork:
            return 3.0  // Standard threshold for rhythm practices
        case .affirmation, .reflective:
            return 3.5  // Slightly higher for mental focus practices
        case .manifestation:
            return 4.0  // Goal visualization requires more coherence
        case .chakraBalancing:
            return 3.0  // Balanced threshold for energy work
        }
    }

    /// Minimum session duration for consistency rewards (in seconds)
    var consistencyDuration: TimeInterval {
        switch self {
        case .traumaTherapy:
            return 90   // Shorter sessions for gentle healing
        case .breathwork:
            return 120  // 2 minutes for breathing rhythm establishment
        case .affirmation, .gratitude, .lovingKindness:
            return 180  // 3 minutes for positive practice integration
        case .reflective:
            return 300  // 5 minutes for deep contemplation
        case .manifestation:
            return 240  // 4 minutes for goal visualization
        case .chakraBalancing:
            return 420  // 7 minutes (one per chakra)
        }
    }

    /// Session duration bonus multiplier for extended practice
    var durationBonusMultiplier: Double {
        switch self {
        case .reflective:
            return 1.5  // Rewards longer contemplation
        case .chakraBalancing, .manifestation:
            return 1.3  // Moderate bonus for focused practices
        case .traumaTherapy:
            return 1.1  // Gentle bonus to avoid pressure
        default:
            return 1.2  // Standard bonus for sustained practice
        }
    }

    // MARK: - Messaging & Guidance

    /// Opening message when starting this meditation type
    var openingMessage: String {
        switch self {
        case .affirmation:
            return "Speak your truth with love. Let your heart confirm your positive intentions."
        case .manifestation:
            return "Visualize your desires with clarity. Feel your heart align with your dreams."
        case .reflective:
            return "Turn inward with gentle curiosity. Let your wisdom emerge through stillness."
        case .traumaTherapy:
            return "You are safe in this moment. Breathe with compassion for your healing journey."
        case .gratitude:
            return "Open your heart to appreciation. Feel thankfulness flow through your being."
        case .chakraBalancing:
            return "Connect with your energy centers. Let each breath balance and align your spirit."
        case .breathwork:
            return "Conscious breathing is your anchor. Let each breath guide you to presence."
        case .lovingKindness:
            return "May you be happy, healthy, and at peace. Extend this love to all beings."
        }
    }

    /// Encouraging messages during coherence achievement
    var coherenceMessages: [String] {
        switch self {
        case .affirmation:
            return [
                "Your affirmations are resonating deeply! ✨",
                "Your heart believes these positive truths! 💙",
                "Beautiful alignment with your highest self! 🌟"
            ]
        case .manifestation:
            return [
                "Your heart is in perfect alignment with your vision! 🎯",
                "This is the frequency of manifestation! ⚡",
                "Feel your dreams coming into reality! 🚀"
            ]
        case .reflective:
            return [
                "Deep wisdom is emerging from stillness! 🧠",
                "Your contemplation is bearing fruit! 🌱",
                "Perfect state for inner knowing! 💎"
            ]
        case .traumaTherapy:
            return [
                "You are creating safety in your nervous system! 🌸",
                "Gentle healing is happening now! 💚",
                "Your courage in healing is beautiful! 🕊️"
            ]
        case .gratitude:
            return [
                "Your heart is overflowing with appreciation! 🧡",
                "Gratitude is expanding your vibration! ✨",
                "This thankful heart is your superpower! 🙏"
            ]
        case .chakraBalancing:
            return [
                "Your energy centers are harmonizing! ⚡",
                "Beautiful chakra alignment achieved! 🌈",
                "Feel the flow of balanced energy! 💫"
            ]
        case .breathwork:
            return [
                "Perfect rhythm established! 🌊",
                "Your breath is your medicine! 💨",
                "Breathing with deep awareness! 🫁"
            ]
        case .lovingKindness:
            return [
                "Love is radiating from your heart! 💖",
                "Compassion is your natural state! 🌸",
                "This loving energy heals the world! 🌍"
            ]
        }
    }

    /// Gentle encouragement during challenging moments
    var encouragementMessages: [String] {
        switch self {
        case .affirmation:
            return [
                "Every positive word counts, breathe gently",
                "Your heart knows these truths, keep going",
                "Speak with kindness to yourself"
            ]
        case .manifestation:
            return [
                "Hold your vision with gentle focus",
                "Feel into the joy of your dreams",
                "Trust the process of creation"
            ]
        case .reflective:
            return [
                "Let thoughts come and go like clouds",
                "Wisdom emerges in its own time",
                "Be patient with your inner process"
            ]
        case .traumaTherapy:
            return [
                "You are safe, breathe as slowly as you need",
                "Healing happens one breath at a time",
                "Honor whatever comes up with gentleness"
            ]
        case .gratitude:
            return [
                "Start with gratitude for this breath",
                "Even small appreciations count",
                "Your grateful heart is already perfect"
            ]
        case .chakraBalancing:
            return [
                "Energy flows where attention goes",
                "Each breath balances your centers",
                "Trust your body's natural wisdom"
            ]
        case .breathwork:
            return [
                "Return to your natural rhythm",
                "Each breath is a new beginning",
                "Your breath is always available"
            ]
        case .lovingKindness:
            return [
                "Love starts with loving yourself",
                "Compassion grows with practice",
                "Your loving heart blesses all"
            ]
        }
    }
}

// MARK: - Meditation Session Configuration
// Configuration moved to separate MeditationSessionConfig.swift file

// MARK: - Extensions

extension MeditationType {
    /// Recommended background music for this meditation type
    var recommendedMusic: String? {
        switch self {
        case .affirmation:
            return "gentle_piano"
        case .manifestation:
            return "ambient_expansion"
        case .reflective:
            return "deep_silence"
        case .traumaTherapy:
            return "healing_frequencies"
        case .gratitude:
            return "warm_strings"
        case .chakraBalancing:
            return "tibetan_bowls"
        case .breathwork:
            return "rhythmic_ambience"
        case .lovingKindness:
            return "heart_frequencies"
        }
    }

    /// Whether this meditation type benefits from extended sessions
    var encouragesLongerSessions: Bool {
        switch self {
        case .reflective, .chakraBalancing, .manifestation:
            return true
        case .traumaTherapy:
            return false // Keep healing sessions gentle
        default:
            return true
        }
    }

    /// Persona preference for KASPER MLX guidance
    var preferredPersona: String? {
        switch self {
        case .affirmation, .manifestation:
            return "MindfulnessCoach"
        case .reflective:
            return "AlanWatts"
        case .traumaTherapy, .lovingKindness:
            return "CarlJung"
        case .gratitude:
            return "Oracle"
        case .chakraBalancing:
            return "NumerologyScholar"
        case .breathwork:
            return "Psychologist"
        }
    }
}
