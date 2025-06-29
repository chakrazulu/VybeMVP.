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
 * 6. Auto-dismiss after 6 seconds or manual tap
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
 * 
 * Integration:
 * - Observes FocusNumberManager and RealmNumberManager
 * - Publishes match state to UI components
 * - Coordinates with HealthKitManager for heart rate data
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
    
    /// How long to display each match (in seconds)
    private let matchDisplayDuration: TimeInterval = 6.0
    
    /// Minimum time between duplicate match celebrations (in seconds)
    private let duplicateMatchCooldown: TimeInterval = 300.0 // 5 minutes
    
    // MARK: - Initialization
    
    init() {
        print("🌟 VybeMatchManager: Initializing cosmic match detection system")
        
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
        if abs(heartRate - currentHeartRate) > 5.0 {
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
        
        print("🌟 VybeMatchManager: Checking match - Focus: \(currentFocusNumber), Realm: \(currentRealmNumber)")
        
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
                
                // Trigger the cosmic celebration
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
     * Triggers the cosmic match celebration
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
        
        // Set timer to auto-dismiss after display duration
        matchDismissTimer = Timer.scheduledTimer(withTimeInterval: matchDisplayDuration, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.dismissCurrentMatch()
            }
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