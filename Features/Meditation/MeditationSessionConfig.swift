import Foundation

/**
 * Meditation Session Configuration - Customizable Session Settings
 * ==============================================================
 *
 * Defines all configurable aspects of a meditation session:
 * - Duration settings (timed vs open-ended)
 * - HRV biofeedback preferences
 * - Audio guidance levels
 * - Achievement thresholds
 * - Visual customization options
 *
 * ## 🎯 Type-Specific Defaults
 *
 * Each meditation type has optimized default settings:
 * - Trauma Therapy: Gentler thresholds, longer durations
 * - Breathwork: Focus on respiratory coherence
 * - Manifestation: Achievement-oriented with visual rewards
 * - Affirmation: Empowerment messaging and shorter sessions
 *
 * Created: August 2025
 * Version: 1.0.0 - Session configuration management
 */

struct MeditationSessionConfig {

    // MARK: - Session Duration

    /// Session duration in seconds (nil = open-ended)
    let duration: TimeInterval?

    /// Whether to show countdown timer for timed sessions
    let showCountdown: Bool

    /// Auto-end session when duration reached
    let autoEnd: Bool

    // MARK: - HRV Biofeedback Settings

    /// Whether to show HRV biofeedback during session
    let showHRVBiofeedback: Bool

    /// Whether to show sine waves by default
    let showSineWaves: Bool

    /// HRV improvement threshold for positive feedback
    let hrvImprovementThreshold: Double

    /// Whether to use progressive rewards (vs fixed targets)
    let useProgressiveRewards: Bool

    // MARK: - Audio & Guidance

    /// Audio guidance level (none, minimal, full)
    let audioGuidanceLevel: AudioGuidanceLevel

    /// Whether to play background meditation sounds
    let playBackgroundSounds: Bool

    /// Volume level for meditation sounds (0.0 - 1.0)
    let backgroundSoundVolume: Double

    // MARK: - Visual Customization

    /// Theme colors based on meditation type
    let primaryColor: String // Stored as hex string

    /// Whether to show achievement animations
    let showAchievementAnimations: Bool

    /// Whether to show chakra indicators
    let showChakraIndicators: Bool

    // MARK: - Achievement Settings

    /// Custom achievement thresholds for this session type
    let achievementThresholds: AchievementThresholds

    /// Whether to track this session for achievements
    let trackForAchievements: Bool

    // MARK: - Message Settings

    /// How often to rotate guidance messages (seconds)
    let messageRotationInterval: TimeInterval

    /// Whether to show type-specific affirmations
    let showTypeSpecificMessages: Bool

    // MARK: - Initialization

    init(
        duration: TimeInterval? = nil,
        showCountdown: Bool = true,
        autoEnd: Bool = true,
        showHRVBiofeedback: Bool = true,
        showSineWaves: Bool = true,
        hrvImprovementThreshold: Double = 3.0,
        useProgressiveRewards: Bool = true,
        audioGuidanceLevel: AudioGuidanceLevel = .minimal,
        playBackgroundSounds: Bool = false,
        backgroundSoundVolume: Double = 0.3,
        primaryColor: String = "#007AFF",
        showAchievementAnimations: Bool = true,
        showChakraIndicators: Bool = true,
        achievementThresholds: AchievementThresholds = .standard,
        trackForAchievements: Bool = true,
        messageRotationInterval: TimeInterval = 30.0,
        showTypeSpecificMessages: Bool = true
    ) {
        self.duration = duration
        self.showCountdown = showCountdown
        self.autoEnd = autoEnd
        self.showHRVBiofeedback = showHRVBiofeedback
        self.showSineWaves = showSineWaves
        self.hrvImprovementThreshold = hrvImprovementThreshold
        self.useProgressiveRewards = useProgressiveRewards
        self.audioGuidanceLevel = audioGuidanceLevel
        self.playBackgroundSounds = playBackgroundSounds
        self.backgroundSoundVolume = backgroundSoundVolume
        self.primaryColor = primaryColor
        self.showAchievementAnimations = showAchievementAnimations
        self.showChakraIndicators = showChakraIndicators
        self.achievementThresholds = achievementThresholds
        self.trackForAchievements = trackForAchievements
        self.messageRotationInterval = messageRotationInterval
        self.showTypeSpecificMessages = showTypeSpecificMessages
    }
}

// MARK: - Supporting Types

enum AudioGuidanceLevel: String, CaseIterable {
    case none = "None"
    case minimal = "Minimal"
    case full = "Full Guidance"

    var description: String {
        switch self {
        case .none: return "Silent meditation"
        case .minimal: return "Gentle prompts only"
        case .full: return "Comprehensive guidance"
        }
    }
}

struct AchievementThresholds {
    /// BPM improvement needed for "good" progress
    let goodImprovement: Double

    /// BPM improvement needed for "excellent" progress
    let excellentImprovement: Double

    /// Minimum session duration for completion (seconds)
    let minimumDuration: TimeInterval

    /// Duration for "long session" achievement (seconds)
    let longSessionDuration: TimeInterval

    /// How close to optimal BPM for "mastery" achievement
    let optimalBPMTolerance: Double

    // MARK: - Preset Configurations

    static let standard = AchievementThresholds(
        goodImprovement: 3.0,
        excellentImprovement: 6.0,
        minimumDuration: 60,
        longSessionDuration: 600, // 10 minutes
        optimalBPMTolerance: 2.0
    )

    static let gentle = AchievementThresholds(
        goodImprovement: 2.0,
        excellentImprovement: 4.0,
        minimumDuration: 30,
        longSessionDuration: 300, // 5 minutes
        optimalBPMTolerance: 3.0
    )

    static let challenging = AchievementThresholds(
        goodImprovement: 5.0,
        excellentImprovement: 10.0,
        minimumDuration: 120,
        longSessionDuration: 1200, // 20 minutes
        optimalBPMTolerance: 1.5
    )
}

// MARK: - Type-Specific Configurations

extension MeditationSessionConfig {

    /// Gets recommended configuration for a specific meditation type
    static func recommended(for type: MeditationType) -> MeditationSessionConfig {
        switch type {

        case .affirmation:
            return MeditationSessionConfig(
                duration: 300, // 5 minutes - shorter for affirmation work
                hrvImprovementThreshold: 2.5,
                audioGuidanceLevel: .minimal,
                primaryColor: "#007AFF",
                achievementThresholds: .standard,
                messageRotationInterval: 20.0
            )

        case .manifestation:
            return MeditationSessionConfig(
                duration: 600, // 10 minutes - longer for manifestation
                hrvImprovementThreshold: 4.0,
                audioGuidanceLevel: .minimal,
                primaryColor: "#6B46C1",
                showAchievementAnimations: true,
                achievementThresholds: .standard
            )

        case .reflective:
            return MeditationSessionConfig(
                duration: nil, // Open-ended for deep reflection
                hrvImprovementThreshold: 3.0,
                audioGuidanceLevel: .none,
                primaryColor: "#0891B2",
                achievementThresholds: .standard,
                messageRotationInterval: 45.0
            )

        case .traumaTherapy:
            return MeditationSessionConfig(
                duration: nil, // Open-ended for healing work
                hrvImprovementThreshold: 1.5, // Gentler threshold
                audioGuidanceLevel: .full,
                primaryColor: "#059669",
                achievementThresholds: .gentle,
                messageRotationInterval: 60.0 // Slower rotation
            )

        case .gratitude:
            return MeditationSessionConfig(
                duration: 480, // 8 minutes - good for gratitude practice
                hrvImprovementThreshold: 3.0,
                audioGuidanceLevel: .minimal,
                primaryColor: "#DC2626",
                achievementThresholds: .standard
            )

        case .chakraBalancing:
            return MeditationSessionConfig(
                duration: 900, // 15 minutes - longer for energy work
                hrvImprovementThreshold: 3.5,
                audioGuidanceLevel: .minimal,
                primaryColor: "#7C3AED",
                showChakraIndicators: true,
                achievementThresholds: .standard
            )

        case .breathwork:
            return MeditationSessionConfig(
                duration: 720, // 12 minutes - structured breathwork
                hrvImprovementThreshold: 4.0,
                audioGuidanceLevel: .full,
                primaryColor: "#0D9488",
                achievementThresholds: .standard
            )

        case .lovingKindness:
            return MeditationSessionConfig(
                duration: 540, // 9 minutes - heart-opening practice
                hrvImprovementThreshold: 2.5,
                audioGuidanceLevel: .minimal,
                primaryColor: "#EC4899",
                achievementThresholds: .gentle,
                messageRotationInterval: 25.0
            )
        }
    }

    /// Gets a quick 3-minute version for any meditation type
    static func quick(for type: MeditationType) -> MeditationSessionConfig {
        var config = recommended(for: type)
        config = MeditationSessionConfig(
            duration: 180, // 3 minutes
            showCountdown: config.showCountdown,
            autoEnd: config.autoEnd,
            showHRVBiofeedback: config.showHRVBiofeedback,
            showSineWaves: config.showSineWaves,
            hrvImprovementThreshold: config.hrvImprovementThreshold * 0.8, // Easier for short sessions
            useProgressiveRewards: config.useProgressiveRewards,
            audioGuidanceLevel: config.audioGuidanceLevel,
            playBackgroundSounds: config.playBackgroundSounds,
            backgroundSoundVolume: config.backgroundSoundVolume,
            primaryColor: config.primaryColor,
            showAchievementAnimations: config.showAchievementAnimations,
            showChakraIndicators: config.showChakraIndicators,
            achievementThresholds: .gentle,
            trackForAchievements: config.trackForAchievements,
            messageRotationInterval: 15.0, // Faster rotation for short session
            showTypeSpecificMessages: config.showTypeSpecificMessages
        )
        return config
    }

    /// Gets an extended version for deep practice
    static func extended(for type: MeditationType) -> MeditationSessionConfig {
        var config = recommended(for: type)
        let extendedDuration: TimeInterval? = config.duration.map { $0 * 2 }

        config = MeditationSessionConfig(
            duration: extendedDuration,
            showCountdown: config.showCountdown,
            autoEnd: config.autoEnd,
            showHRVBiofeedback: config.showHRVBiofeedback,
            showSineWaves: config.showSineWaves,
            hrvImprovementThreshold: config.hrvImprovementThreshold,
            useProgressiveRewards: config.useProgressiveRewards,
            audioGuidanceLevel: config.audioGuidanceLevel,
            playBackgroundSounds: config.playBackgroundSounds,
            backgroundSoundVolume: config.backgroundSoundVolume,
            primaryColor: config.primaryColor,
            showAchievementAnimations: config.showAchievementAnimations,
            showChakraIndicators: config.showChakraIndicators,
            achievementThresholds: .challenging,
            trackForAchievements: config.trackForAchievements,
            messageRotationInterval: config.messageRotationInterval * 1.5, // Slower rotation
            showTypeSpecificMessages: config.showTypeSpecificMessages
        )
        return config
    }
}
