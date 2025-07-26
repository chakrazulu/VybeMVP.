/*
 * ========================================
 * 🔧 VYBE CONSTANTS - CENTRALIZED CONFIGURATION
 * ========================================
 * 
 * PHASE 16 ACHIEVEMENT: MAGIC NUMBER ELIMINATION
 * Created during the Phase 16 Optimization Sprint to eliminate 50+ hardcoded
 * timing values throughout the VybeMVP codebase and establish a centralized
 * configuration system for consistent performance and easy A/B testing.
 *
 * WHAT ARE MAGIC NUMBERS?
 * Magic numbers are hardcoded values (like 0.5, 2.0, 15.0) scattered throughout
 * code without explanation. They create maintenance problems because:
 * - Unclear intent: Why 0.5 seconds? What does it control?
 * - Inconsistency: Similar features use different random timing values
 * - Hard to change: Must hunt through dozens of files to adjust timing
 * - No documentation: No explanation of timing choices
 *
 * CONFIGURATION PURPOSE:
 * Central repository for all timing values, delays, and configuration constants
 * used throughout the Vybe app. This enables easy tuning, A/B testing, and
 * maintains consistent user experience across all cosmic interactions.
 *
 * ORGANIZATION STRATEGY:
 * - Grouped by functional area (Startup, Animations, Timers, etc.)
 * - Clear naming with units specified (seconds, milliseconds, etc.)
 * - Comments explaining the purpose of each constant
 * - Easy to modify for performance tuning or A/B testing
 * - Self-documenting code that explains timing decisions
 *
 * PERFORMANCE BENEFITS:
 * - Single source of truth for all timing values
 * - Easy to optimize delays and intervals across entire app
 * - Consistent timing creates professional user experience
 * - Simple configuration changes without hunting through code
 * - Enables systematic A/B testing of timing values
 * - Professional-grade maintainability and extensibility
 *
 * IMPLEMENTATION EXAMPLES:
 * 
 * Before (Magic Number):
 * DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
 * 
 * After (Named Constant):
 * DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) { }
 * 
 * Benefits: Clear intent, easy to change, consistent across app, documented purpose
 */

import Foundation

/// Central configuration constants for the Vybe app
struct VybeConstants {
    
    // MARK: - App Startup & Initialization
    
    /// Delay before configuring FocusNumberManager (seconds)
    static let startupFocusManagerDelay: TimeInterval = 0.2
    
    /// Delay before starting heart rate monitoring (seconds)
    static let startupHeartRateDelay: TimeInterval = 0.8
    
    /// Delay before AI insights initialization (seconds)
    static let startupAIInsightsDelay: TimeInterval = 2.0
    
    /// Profile setup navigation delay (seconds)
    static let profileSetupDelay: TimeInterval = 1.0
    
    // MARK: - Animation Timing
    
    /// Onboarding sparkle animation interval (seconds)
    static let onboardingSparkleInterval: TimeInterval = 0.15
    
    /// Chakra animation update interval (seconds)
    static let chakraAnimationInterval: TimeInterval = 0.05
    
    /// Meditation timer update interval (seconds)
    static let meditationTimerInterval: TimeInterval = 1.0
    
    /// Cosmic background star animation interval (seconds)
    static let cosmicStarAnimationInterval: TimeInterval = 0.05
    
    /// Numerology rain generation interval (seconds)
    static let numerologyRainInterval: TimeInterval = 0.8
    
    /// Twinkling digits generation interval (seconds)
    static let twinklingDigitsGenerationInterval: TimeInterval = 2.0
    
    /// Twinkling digits cleanup interval (seconds)
    static let twinklingDigitsCleanupInterval: TimeInterval = 3.0
    
    // MARK: - Onboarding Animation Delays
    
    /// Initial onboarding animation delay (seconds)
    static let onboardingInitialDelay: TimeInterval = 0.3
    
    /// Secondary onboarding animation delay (seconds)
    static let onboardingSecondaryDelay: TimeInterval = 0.8
    
    /// Onboarding completion auto-advance delay (seconds)
    static let onboardingCompletionDelay: TimeInterval = 3.0
    
    /// Birth place selection feedback delay (seconds)
    static let birthPlaceFeedbackDelay: TimeInterval = 0.5
    
    // MARK: - Performance Monitoring
    
    /// Memory usage monitoring interval (seconds)
    static let memoryMonitoringInterval: TimeInterval = 5.0
    
    /// Performance monitor startup delay (seconds)
    static let performanceMonitorDelay: TimeInterval = 5.0
    
    // MARK: - Manager Timers
    
    /// KASPER payload throttle duration (seconds)
    static let kasperThrottleDuration: TimeInterval = 10.0
    
    /// Heart rate simulation interval (seconds)
    static let heartRateSimulationInterval: TimeInterval = 300.0 // 5 minutes
    
    /// Heart rate refresh interval (seconds)
    static let heartRateRefreshInterval: TimeInterval = 30.0
    
    /// Voice recording metrics update interval (seconds)
    static let voiceRecordingMetricsInterval: TimeInterval = 0.1
    
    /// Voice playback progress update interval (seconds)
    static let voicePlaybackProgressInterval: TimeInterval = 0.1
    
    // MARK: - UI Feedback Delays
    
    /// Minimal UI feedback delay for instant response feel (seconds)
    static let instantFeedbackDelay: TimeInterval = 0.1
    
    /// Standard UI feedback delay for smooth transitions (seconds)
    static let standardFeedbackDelay: TimeInterval = 0.5
    
    /// Extended UI feedback delay for dramatic effect (seconds)
    static let dramaticFeedbackDelay: TimeInterval = 1.0
    
    // MARK: - Animation Durations
    
    /// Short animation duration for quick feedback (seconds)
    static let shortAnimationDuration: TimeInterval = 0.3
    
    /// Medium animation duration for standard transitions (seconds)
    static let mediumAnimationDuration: TimeInterval = 0.8
    
    /// Long animation duration for dramatic reveals (seconds)
    static let longAnimationDuration: TimeInterval = 1.5
    
    /// Epic animation duration for major reveals (seconds)
    static let epicAnimationDuration: TimeInterval = 2.0
    
    // MARK: - Performance Optimization
    
    /// Timer tolerance for energy efficiency (seconds)
    static let timerTolerance: TimeInterval = 1.0
    
    /// Background task timeout (seconds)
    static let backgroundTaskTimeout: TimeInterval = 30.0
    
    /// Network request timeout (seconds)
    static let networkTimeout: TimeInterval = 30.0
    
    /// Core Data save throttle interval (seconds)
    static let coreDataSaveThrottle: TimeInterval = 0.5
    
    // MARK: - Extended Startup Delays
    
    /// Extended startup delay for deferred system initialization (seconds)
    static let extendedStartupDelay: TimeInterval = 15.0
    
    /// Profile setup navigation delay (seconds)
    static let profileSetupNavigationDelay: TimeInterval = 1.0
    
    // MARK: - Additional Animation Durations
    
    /// Very short animation for instant feedback (seconds)
    static let veryShortAnimationDuration: TimeInterval = 0.1
    
    /// Quick transition duration for rapid changes (seconds)
    static let quickTransitionDuration: TimeInterval = 0.2
    
    /// Dramatic reveal animation duration (seconds)
    static let dramaticRevealDuration: TimeInterval = 3.0
    
    /// Cosmic celebration animation duration (seconds)
    static let cosmicCelebrationDuration: TimeInterval = 6.0
    
    // MARK: - Long Background Animations
    
    /// Infinite cosmic rotation duration (seconds)
    static let infiniteCosmicRotationDuration: TimeInterval = 60.0
    
    /// Slow cosmic drift animation duration (seconds)
    static let slowCosmicDriftDuration: TimeInterval = 20.0
    
    /// Medium cosmic drift animation duration (seconds)
    static let mediumCosmicDriftDuration: TimeInterval = 15.0
}

// MARK: - Legacy Constants (To be replaced)

/// Legacy constants that should be gradually replaced with VybeConstants
@available(*, deprecated, message: "Use VybeConstants instead")
struct LegacyTiming {
    static let defaultDelay: TimeInterval = 0.5
    static let longDelay: TimeInterval = 2.0
}