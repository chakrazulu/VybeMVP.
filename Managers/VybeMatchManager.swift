//
//  VybeMatchManager.swift
//  VybeMVP
//
//  Created to manage cosmic match detection and state management
//  Monitors when Focus Number == Realm Number and triggers visual effects
//

import SwiftUI
import Combine
import Foundation
import AudioToolbox

/**
 * VybeMatchManager: Detects and manages cosmic alignment events
 * 
 * 🎯 COMPREHENSIVE MANAGER REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Monitors cosmic alignment (Focus Number == Realm Number) and triggers celebrations.
 * This is the visual effects coordinator for the mystical matching system.
 * 
 * === KEY RESPONSIBILITIES ===
 * • Real-time match detection via NotificationCenter
 * • Trigger VybeMatchOverlay visual celebration
 * • Prevent duplicate celebrations (5-minute cooldown)
 * • Track match history (last 10 matches)
 * • Sync heart rate for animation timing
 * • Auto-dismiss overlays after 6 seconds
 * • Multi-modal celebrations (haptics, audio, particles)
 * 
 * === PUBLISHED PROPERTIES ===
 * • isMatchActive: Boolean - Is overlay currently showing?
 * • currentMatchedNumber: Int - The matched number (1-9)
 * • currentHeartRate: Double - BPM for animation sync
 * • recentMatches: [VybeMatch] - Match history array
 * 
 * === MATCH DETECTION FLOW ===
 * 1. Receives notifications from Focus/Realm managers
 * 2. updateFocusNumber() or updateRealmNumber() called
 * 3. checkForCosmicMatch() compares values
 * 4. If match && not recent: triggerCosmicMatch()
 * 5. VybeMatchOverlay appears via isMatchActive
 * 6. Multi-modal celebrations triggered (haptics, audio, particles)
 * 7. Auto-dismiss after 6 seconds or manual tap
 * 
 * === NOTIFICATION INTEGRATION ===
 * Listens for:
 * • NSNotification.Name.focusNumberChanged
 * • NSNotification.Name.realmNumberChanged
 * • HealthKitManager.heartRateUpdated
 * 
 * === COOLDOWN SYSTEM ===
 * • Duration: 300 seconds (5 minutes)
 * • Per-number tracking in recentMatches array
 * • Prevents celebration spam
 * • isRecentDuplicate() checks history
 * 
 * === TIMING SPECIFICATIONS ===
 * • Display duration: 6.0 seconds
 * • Auto-dismiss timer: Cancellable
 * • History limit: 10 matches
 * • Cooldown: 5 minutes per number
 * 
 * === HEART RATE SYNC ===
 * • Updates from HealthKitManager notifications
 * • Used for particle animation speed
 * • Default: 72 BPM if unavailable
 * • Logging threshold: 5 BPM change
 * 
 * === MULTI-MODAL CELEBRATIONS ===
 * • Haptic feedback patterns for each sacred number (1-9)
 * • Sacred frequency audio enhancement (396Hz, 528Hz, etc.)
 * • Particle effects with number-specific sacred geometry
 * • Duration scaling for rarer number matches
 * 
 * === INITIALIZATION SEQUENCE ===
 * 1. Init with current heart rate
 * 2. Setup notification subscriptions
 * 3. Wait for syncCurrentState() call
 * 4. Check for immediate match
 * 
 * === PUBLIC METHODS ===
 * • syncCurrentState(): Initial state setup
 * • simulateMatch(): Testing trigger
 * • dismissMatch(): Manual dismissal
 * • clearMatchHistory(): Reset tracking
 * 
 * === CRITICAL NOTES ===
 * • @MainActor ensures UI thread safety
 * • Weak self in closures prevents cycles
 * • Timer cleanup on deinit
 * • Valid number range: 1-9
 * 
 * Purpose:
 * - Monitors Focus Number and Realm Number for matches
 * - Triggers VybeMatchOverlay when cosmic alignment occurs
 * - Manages match history and prevents duplicate celebrations
 * - Provides debug logging for match detection events
 * - Delivers multi-modal celebrations (haptics, audio, particles)
 * 
 * Integration:
 * - Observes FocusNumberManager and RealmNumberManager
 * - Publishes match state to UI components
 * - Coordinates with HealthKitManager for heart rate data
 * - Triggers haptic feedback and audio for immersive experience
 */
@MainActor
class VybeMatchManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Whether a cosmic match is currently active
    @Published var isMatchActive: Bool = false
    
    /// The current matched number (when Focus == Realm)
    @Published var currentMatchedNumber: Int = 0
    
    /// User's current heart rate for animation synchronization
    @Published var currentHeartRate: Double = 72.0
    
    /// History of recent matches to prevent duplicate celebrations
    @Published var recentMatches: [VybeMatch] = []
    
    // MARK: - Private Properties
    
    /// Subscription to focus number changes
    private var focusNumberCancellable: AnyCancellable?
    
    /// Subscription to realm number changes
    private var realmNumberCancellable: AnyCancellable?
    
    /// Subscription to heart rate changes
    private var heartRateCancellable: AnyCancellable?
    
    /// Current focus number from FocusNumberManager
    private var currentFocusNumber: Int = 0
    
    /// Current realm number from RealmNumberManager
    private var currentRealmNumber: Int = 0
    
    /// Timer to auto-dismiss matches after display duration
    private var matchDismissTimer: Timer?
    
    /// How long the overlay stays visible (in seconds) - disabled for manual dismiss only
    private let matchDisplayDuration: TimeInterval = .infinity // Never auto-dismiss
    
    /// Minimum time between duplicate match celebrations (in seconds)
    private let duplicateMatchCooldown: TimeInterval = 300.0 // 5 minutes
    
    // MARK: - Haptic Feedback System
    
    /// Haptic feedback engine for cosmic celebrations
    private let hapticEngine = UIImpactFeedbackGenerator(style: .heavy)
    
    /// Sacred number haptic patterns (each number has unique vibrational signature)
    private let sacredHapticPatterns: [Int: SacredHapticPattern] = [
        1: SacredHapticPattern(name: "Leadership", pattern: [0.0, 0.3, 0.6, 0.9], intensity: 0.9),
        2: SacredHapticPattern(name: "Harmony", pattern: [0.0, 0.2, 0.4, 0.6, 0.8], intensity: 0.7),
        3: SacredHapticPattern(name: "Creativity", pattern: [0.0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9], intensity: 0.8),
        4: SacredHapticPattern(name: "Stability", pattern: [0.0, 0.25, 0.5, 0.75], intensity: 0.6),
        5: SacredHapticPattern(name: "Freedom", pattern: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9], intensity: 0.5),
        6: SacredHapticPattern(name: "Nurturing", pattern: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0], intensity: 0.8),
        7: SacredHapticPattern(name: "Spirituality", pattern: [0.0, 0.33, 0.66, 0.99], intensity: 1.0),
        8: SacredHapticPattern(name: "Power", pattern: [0.0, 0.5, 1.0], intensity: 0.9),
        9: SacredHapticPattern(name: "Completion", pattern: [0.0, 0.25, 0.5, 0.75, 1.0], intensity: 0.7)
    ]
    
    // MARK: - Initialization
    
    init() {
        print("🌟 VybeMatchManager: Initializing cosmic match detection system with multi-modal celebrations")
        
        // Prepare haptic engine
        hapticEngine.prepare()
        
        // Initialize with current values from existing managers
        initializeCurrentValues()
        
        setupMatchDetection()
    }
    
    /**
     * Initializes the manager with current values from existing managers
     * This ensures we don't miss matches due to initialization timing
     */
    private func initializeCurrentValues() {
        // Get current heart rate from HealthKitManager if available
        currentHeartRate = Double(HealthKitManager.shared.currentHeartRate)
        if currentHeartRate > 0 {
            print("🌟 VybeMatchManager: Initialized with current heart rate: \(Int(currentHeartRate)) BPM")
        }
        
        // Note: RealmNumberManager and FocusNumberManager values will be received via notifications
        // We'll add a method to sync current state after ContentView is fully loaded
    }
    
    /**
     * Syncs the current state with the provided managers
     * This should be called after all managers are initialized
     */
    func syncCurrentState(focusNumber: Int, realmNumber: Int) {
        print("🌟 VybeMatchManager: Syncing current state - Focus: \(focusNumber), Realm: \(realmNumber)")
        currentFocusNumber = focusNumber
        currentRealmNumber = realmNumber
        
        // Check for immediate match after syncing
        checkForCosmicMatch()
    }
    
    deinit {
        print("🌟 VybeMatchManager: Cleanup - cancelling subscriptions")
        // Clean up immediately without capturing self
        focusNumberCancellable?.cancel()
        realmNumberCancellable?.cancel()
        heartRateCancellable?.cancel()
        matchDismissTimer?.invalidate()
    }
    
    // MARK: - Setup Methods
    
    /**
     * Sets up the match detection system by subscribing to relevant managers
     * 
     * Monitors:
     * - FocusNumberManager for user's chosen spiritual number
     * - RealmNumberManager for dynamically calculated realm number
     * - HealthKitManager for real-time heart rate data
     */
    private func setupMatchDetection() {
        print("🌟 VybeMatchManager: Setting up cosmic match detection...")
        
        // Subscribe to focus number changes
        focusNumberCancellable = NotificationCenter.default
            .publisher(for: NSNotification.Name.focusNumberChanged)
            .compactMap { notification in
                notification.userInfo?["focusNumber"] as? Int
            }
            .sink { [weak self] focusNumber in
                self?.updateFocusNumber(focusNumber)
            }
        
        // Subscribe to realm number changes
        realmNumberCancellable = NotificationCenter.default
            .publisher(for: NSNotification.Name.realmNumberChanged)
            .compactMap { notification in
                notification.userInfo?["realmNumber"] as? Int
            }
            .sink { [weak self] realmNumber in
                self?.updateRealmNumber(realmNumber)
            }
        
        // Subscribe to heart rate changes
        heartRateCancellable = NotificationCenter.default
            .publisher(for: HealthKitManager.heartRateUpdated)
            .compactMap { notification in
                notification.userInfo?["heartRate"] as? Double
            }
            .sink { [weak self] heartRate in
                self?.updateHeartRate(heartRate)
            }
        
        print("🌟 VybeMatchManager: Subscriptions established")
    }
    
    // MARK: - Update Methods
    
    /**
     * Updates the current focus number and checks for matches
     * 
     * - Parameter focusNumber: The new focus number from FocusNumberManager
     */
    private func updateFocusNumber(_ focusNumber: Int) {
        print("🌟 VybeMatchManager: Focus Number updated to \(focusNumber)")
        currentFocusNumber = focusNumber
        checkForCosmicMatch()
    }
    
    /**
     * Updates the current realm number and checks for matches
     * 
     * - Parameter realmNumber: The new realm number from RealmNumberManager
     */
    private func updateRealmNumber(_ realmNumber: Int) {
        print("🌟 VybeMatchManager: Realm Number updated to \(realmNumber)")
        currentRealmNumber = realmNumber
        checkForCosmicMatch()
    }
    
    /**
     * Updates the current heart rate for animation synchronization
     * 
     * - Parameter heartRate: The new heart rate from HealthKitManager
     */
    private func updateHeartRate(_ heartRate: Double) {
        // Only log significant heart rate changes to avoid console spam
        if abs(heartRate - currentHeartRate) > 10.0 {
            print("🌟 VybeMatchManager: Heart Rate updated to \(Int(heartRate)) BPM")
        }
        currentHeartRate = heartRate
    }
    
    // MARK: - Match Detection Logic
    
    /**
     * Core match detection logic - checks if Focus Number == Realm Number
     * 
     * Triggers cosmic celebration when:
     * - Focus Number equals Realm Number
     * - Match hasn't been celebrated recently (cooldown period)
     * - Both numbers are valid (1-9)
     */
    private func checkForCosmicMatch() {
        // Validate numbers are in expected range
        guard currentFocusNumber >= 1 && currentFocusNumber <= 9,
              currentRealmNumber >= 1 && currentRealmNumber <= 9 else {
            print("🌟 VybeMatchManager: Invalid numbers - Focus: \(currentFocusNumber), Realm: \(currentRealmNumber)")
            return
        }
        
        // Reduced logging: only log when there's actually a match or mismatch change
        // print("🌟 VybeMatchManager: Checking match - Focus: \(currentFocusNumber), Realm: \(currentRealmNumber)")
        
        // Check for cosmic alignment
        if currentFocusNumber == currentRealmNumber {
            let matchedNumber = currentFocusNumber
            
            // Check if this match was recently celebrated
            if !isRecentDuplicate(matchedNumber) {
                print("🌟 ===== COSMIC MATCH DETECTED =====")
                print("🌟 Focus Number: \(currentFocusNumber)")
                print("🌟 Realm Number: \(currentRealmNumber)")
                print("🌟 Matched Number: \(matchedNumber)")
                print("🌟 Heart Rate: \(Int(currentHeartRate)) BPM")
                
                // Trigger the cosmic celebration with multi-modal effects
                triggerCosmicMatch(matchedNumber)
                
            } else {
                print("🌟 Cosmic match detected but recently celebrated - skipping duplicate")
            }
            
        } else {
            // Numbers don't match - ensure overlay is hidden
            if isMatchActive {
                print("🌟 Numbers no longer match - dismissing overlay")
                dismissCurrentMatch()
            }
        }
    }
    
    /**
     * Triggers the cosmic match celebration with multi-modal effects
     * 
     * - Parameter matchedNumber: The number that achieved cosmic alignment
     */
    private func triggerCosmicMatch(_ matchedNumber: Int) {
        // Cancel any existing dismiss timer
        matchDismissTimer?.invalidate()
        
        // Create match record
        let newMatch = VybeMatch(
            number: matchedNumber,
            timestamp: Date(),
            heartRate: currentHeartRate
        )
        
        // Add to recent matches history
        recentMatches.append(newMatch)
        
        // Clean up old matches (keep only last 10)
        if recentMatches.count > 10 {
            recentMatches.removeFirst(recentMatches.count - 10)
        }
        
        // Activate the match overlay
        currentMatchedNumber = matchedNumber
        isMatchActive = true
        
        print("🌟 Cosmic match celebration activated!")
        
        // Trigger multi-modal celebrations
        triggerMultiModalCelebrations(for: matchedNumber)
        
        // Auto-dismiss timer disabled - user must manually close overlay
        // (matchDisplayDuration is set to .infinity for manual dismiss only)
    }
    
    /**
     * Triggers multi-modal celebrations for the matched number
     * 
     * - Parameter number: The sacred number that achieved cosmic alignment
     */
    private func triggerMultiModalCelebrations(for number: Int) {
        print("🌟 Triggering multi-modal celebrations for sacred number \(number)")
        
        // Trigger haptic feedback pattern
        triggerSacredHapticPattern(for: number)
        
        // Trigger sacred frequency audio (placeholder for future implementation)
        triggerSacredFrequencyAudio(for: number)
        
        // Trigger enhanced particle effects (placeholder for future implementation)
        triggerEnhancedParticleEffects(for: number)
    }
    
    /**
     * Triggers the sacred haptic pattern for the given number
     * 
     * - Parameter number: The sacred number (1-9)
     */
    private func triggerSacredHapticPattern(for number: Int) {
        guard let pattern = sacredHapticPatterns[number] else {
            print("🌟 No haptic pattern found for number \(number)")
            return
        }
        
        print("🌟 Triggering \(pattern.name) haptic pattern for number \(number)")
        
        // Execute the haptic pattern
        let totalDuration: TimeInterval = 2.0 // 2-second celebration
        let patternDuration = totalDuration / Double(pattern.pattern.count)
        
        for (index, intensity) in pattern.pattern.enumerated() {
            let delay = TimeInterval(index) * patternDuration
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // Scale intensity by the pattern's base intensity
                let finalIntensity = intensity * pattern.intensity
                
                // Trigger haptic feedback with appropriate intensity
                if finalIntensity > 0.7 {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: CGFloat(finalIntensity))
                } else if finalIntensity > 0.4 {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: CGFloat(finalIntensity))
                } else {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: CGFloat(finalIntensity))
                }
                
                // Reduced haptic logging to avoid spam
                // print("🌟 Haptic pulse \(index + 1): \(String(format: "%.2f", finalIntensity)) intensity")
            }
        }
    }
    
    /**
     * Triggers sacred frequency audio for the given number
     * 
     * - Parameter number: The sacred number (1-9)
     * 
     * Note: This is a placeholder for future audio implementation
     */
    private func triggerSacredFrequencyAudio(for number: Int) {
        // Sacred frequencies for each number (in Hz)
        let sacredFrequencies: [Int: Double] = [
            1: 396.0, // Root chakra - Liberation from fear
            2: 417.0, // Sacral chakra - Facilitating change
            3: 528.0, // Solar plexus - Transformation and miracles
            4: 639.0, // Heart chakra - Connecting relationships
            5: 741.0, // Throat chakra - Awakening intuition
            6: 852.0, // Third eye - Returning to spiritual order
            7: 963.0, // Crown chakra - Connection to source
            8: 432.0, // Universal harmony
            9: 999.0  // Completion and fulfillment
        ]
        
        if let frequency = sacredFrequencies[number] {
            print("🌟 Sacred frequency \(frequency)Hz triggered for number \(number)")
            // TODO: Implement audio playback with sacred frequencies
            // This will be implemented in a future update with AVFoundation
        }
    }
    
    /**
     * Triggers enhanced particle effects for the given number
     * 
     * - Parameter number: The sacred number (1-9)
     * 
     * Note: This is a placeholder for future particle system implementation
     */
    private func triggerEnhancedParticleEffects(for number: Int) {
        // Sacred geometry patterns for each number
        let sacredGeometry: [Int: String] = [
            1: "Point",      // Unity and leadership
            2: "Line",       // Duality and harmony
            3: "Triangle",   // Creativity and expression
            4: "Square",     // Stability and foundation
            5: "Pentagon",   // Freedom and adventure
            6: "Hexagon",    // Nurturing and balance
            7: "Heptagon",   // Spirituality and wisdom
            8: "Octagon",    // Power and abundance
            9: "Circle"      // Completion and wholeness
        ]
        
        if let geometry = sacredGeometry[number] {
            print("🌟 Sacred geometry '\(geometry)' particle effect triggered for number \(number)")
            // TODO: Implement particle system with sacred geometry patterns
            // This will be implemented in a future update with SpriteKit or Metal
        }
    }
    
    /**
     * Dismisses the current match celebration
     */
    private func dismissCurrentMatch() {
        print("🌟 Dismissing cosmic match celebration")
        
        isMatchActive = false
        currentMatchedNumber = 0
        
        // Cancel dismiss timer
        matchDismissTimer?.invalidate()
        matchDismissTimer = nil
    }
    
    /**
     * Checks if a match for the given number was recently celebrated
     * 
     * - Parameter number: The matched number to check
     * - Returns: True if this match was celebrated within the cooldown period
     */
    private func isRecentDuplicate(_ number: Int) -> Bool {
        let now = Date()
        let cutoffTime = now.addingTimeInterval(-duplicateMatchCooldown)
        
        return recentMatches.contains { match in
            match.number == number && match.timestamp > cutoffTime
        }
    }
    
    // MARK: - Public Methods
    
    /**
     * Manually triggers a match for testing purposes
     * 
     * - Parameter number: The number to simulate a match for
     */
    func simulateMatch(for number: Int) {
        print("🌟 VybeMatchManager: Simulating cosmic match for number \(number)")
        triggerCosmicMatch(number)
    }
    
    /**
     * Manually dismisses the current match
     */
    func dismissMatch() {
        dismissCurrentMatch()
    }
    
    /**
     * Clears the recent matches history
     */
    func clearMatchHistory() {
        print("🌟 VybeMatchManager: Clearing match history")
        recentMatches.removeAll()
    }
    
    // MARK: - Cleanup
    
    /**
     * Cancels all subscriptions and timers
     */
    private func cleanupSubscriptions() {
        focusNumberCancellable?.cancel()
        realmNumberCancellable?.cancel()
        heartRateCancellable?.cancel()
        matchDismissTimer?.invalidate()
    }
}

// MARK: - Sacred Haptic Pattern Model

/**
 * Represents a sacred haptic pattern for cosmic celebrations
 */
struct SacredHapticPattern {
    let name: String
    let pattern: [Double] // Array of intensity values (0.0 to 1.0) over time
    let intensity: Double // Base intensity multiplier (0.0 to 1.0)
    
    /**
     * Creates a sacred haptic pattern
     * 
     * - Parameter name: The spiritual meaning of the pattern
     * - Parameter pattern: Array of intensity values over time
     * - Parameter intensity: Base intensity multiplier
     */
    init(name: String, pattern: [Double], intensity: Double) {
        self.name = name
        self.pattern = pattern
        self.intensity = max(0.0, min(1.0, intensity)) // Clamp to valid range
    }
}

// MARK: - VybeMatch Model

/**
 * Represents a cosmic match event for history tracking
 */
struct VybeMatch: Identifiable, Codable {
    var id = UUID()
    let number: Int
    let timestamp: Date
    let heartRate: Double
    
    /// Human-readable description of the match
    var description: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "Number \(number) at \(formatter.string(from: timestamp)) (\(Int(heartRate)) BPM)"
    }
}

// MARK: - Notification Extensions
// Note: Notification names are already declared in NotificationNames.swift 