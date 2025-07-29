/**
 * Filename: FocusNumberManager.swift
 * 
 * 🎯 COMPREHENSIVE MANAGER REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Central manager for all focus number operations and cosmic match detection.
 * This is THE brain of the matching system - when Focus Number == Realm Number.
 * 
 * === KEY RESPONSIBILITIES ===
 * • Store user's selected focus number (1-9)
 * • Detect matches between focus and realm numbers
 * • Save match history to Core Data
 * • Trigger notifications and UI celebrations
 * • Manage match debouncing (prevent duplicates)
 * • Coordinate with VybeMatchManager for visual effects
 * 
 * === ARCHITECTURE PATTERN ===
 * • Design: Singleton with dependency injection support
 * • Threading: Main thread for Core Data operations
 * • Storage: Core Data (matches) + UserDefaults (preferences)
 * • Communication: Combine publishers for reactive updates
 * 
 * === PUBLISHED PROPERTIES ===
 * • selectedFocusNumber: Current focus number (1-9)
 * • matchLogs: Array of FocusMatch Core Data entities
 * • isAutoUpdateEnabled: Toggle for automatic updates
 * • realmNumber: Current realm number (synced from RealmNumberManager)
 * • latestMatchedInsight: Most recent match insight data
 * 
 * === MATCH DETECTION FLOW ===
 * 1. RealmNumberManager updates currentRealmNumber
 * 2. FocusNumberManager receives update via Combine
 * 3. checkForMatches() compares focus vs realm
 * 4. If match: verifyAndSaveMatch() checks debouncing
 * 5. If new: Save to Core Data + send notification
 * 6. VybeMatchManager triggers visual celebration
 * 
 * === DEBOUNCING SYSTEM ===
 * • Interval: 90 seconds between same-number matches
 * • Checks: In-memory cache + Core Data query
 * • Purpose: Prevent notification spam
 * • Cache: lastNotificationTimestamps dictionary
 * 
 * === STARTUP SEQUENCE ===
 * • 0.0s: Initialize with saved preferences
 * • 0.2s: Configure with RealmNumberManager
 * • 15.0s: Enable match detection (prevents app freeze)
 * • Deferred to prevent blocking UI during launch
 * 
 * === CORE DATA SCHEMA ===
 * Entity: FocusMatch
 * • timestamp: Date of match
 * • chosenNumber: Int16 (focus number)
 * • matchedNumber: Int16 (realm number)
 * • locationLatitude: Double
 * • locationLongitude: Double
 * 
 * === NOTIFICATION INTEGRATION ===
 * • Uses NotificationManager.shared
 * • Schedules numerology notifications
 * • 1 second delay for UI updates
 * • Category-based content selection
 * 
 * === TESTING SUPPORT ===
 * • createForTesting(): Isolated instance
 * • Custom persistence controller
 * • Mock-friendly dependency injection
 * 
 * === CRITICAL PERFORMANCE NOTES ===
 * • Match detection DISABLED for first 15 seconds
 * • Core Data saves on main thread only
 * • Combine subscriptions use receive(on: main)
 * • Prevents app freeze during launch
 * 
 * Purpose: Core manager that handles all focus number operations, matching logic,
 * and synchronization with the realm number system.
 *
 * Key responsibilities:
 * - Store and manage the user's selected focus number
 * - Track matches between focus numbers and realm numbers
 * - Persist match history and preferences
 * - Calculate transcendental numbers based on time, location, and focus inputs
 * - Notify the app when matches occur
 * 
 * This manager is a central component of the app's core functionality, managing
 * the relationship between user focus numbers and dynamically calculated realm numbers.
 */

import Foundation
import Combine
import CoreLocation
import CoreData
import os.log
import HealthKit
import UserNotifications
import UIKit

// Struct to hold matched insight data
struct MatchedInsightData: Identifiable {
    let id = UUID()
    let number: Int
    let category: String
    let text: String
    let timestamp: Date
}

/**
 * Core manager class for focus number operations and match detection.
 *
 * This class is responsible for:
 * - Managing the user's selected focus number (1-9)
 * - Detecting matches with realm numbers
 * - Storing match history in CoreData
 * - Providing analytics data about matches
 *
 * Design pattern: Singleton with dependency injection support for testing
 * Threading: Core Data operations run on the main thread
 * Persistence: Uses CoreData for storing matches and UserDefaults for preferences
 */
class FocusNumberManager: NSObject, ObservableObject {
    // MARK: - Properties
    
    /// Singleton instance for app-wide access
    static let shared = FocusNumberManager()
    
    /// The user's currently selected focus number (1-9)
    @Published var selectedFocusNumber: Int = 0
    
    /// History of all matches between focus and realm numbers
    @Published var matchLogs: [FocusMatch] = []
    
    /// Whether automatic focus number updates are enabled
    @Published var isAutoUpdateEnabled: Bool = false
    
    /// The current realm number value, tracked for match detection
    @Published var realmNumber: Int = 0
    
    /// Publishes the latest insight when a new match occurs
    @Published var latestMatchedInsight: MatchedInsightData? = nil
    
    /// Cached location coordinates for calculations
    private var _currentLocation: CLLocationCoordinate2D?
    
    /// Core Data managed object context for persistence
    private let viewContext: NSManagedObjectContext
    
    /// Claude: PERFORMANCE OPTIMIZATION - Persistence controller for background operations
    private let persistenceController: PersistenceController
    
    /// Current device location, used in transcendental calculations
    var currentLocation: CLLocation? {
        didSet {
            _currentLocation = currentLocation?.coordinate
        }
    }
    
    /// Valid range for focus numbers (1-9)
    static let validFocusNumbers = 1...9
    
    /// Default focus number for new users (1)
    static let defaultFocusNumber = 1
    
    /// Access to notification manager for sending notifications
    private let notificationManager = NotificationManager.shared
    
    /// Combine cancellables storage
    private var cancellables = Set<AnyCancellable>()
    
    /// Cache to track the last notification time for each number to prevent rapid duplicates
    private var lastNotificationTimestamps: [Int: Date] = [:]
    private let notificationDebounceInterval: TimeInterval = 90 // 90 seconds
    
    /// Flag to ensure configuration and subscription happens only once
    private var isConfigured = false
    
    /// Flag to disable match detection during startup to prevent freeze
    var isMatchDetectionEnabled = false
    
    // MARK: - Initialization
    
    /**
     * Creates a testing instance of FocusNumberManager with a custom persistence controller.
     *
     * - Parameter persistenceController: Custom CoreData persistence controller for tests
     * - Returns: A configured FocusNumberManager for testing
     *
     * Used in unit tests to create an isolated manager instance that doesn't
     * affect the main app's data store.
     */
    static func createForTesting(with persistenceController: PersistenceController) -> FocusNumberManager {
        return FocusNumberManager(persistenceController: persistenceController)
    }
    
    /**
     * Private initializer enforcing the singleton pattern.
     * 
     * - Parameter persistenceController: The CoreData controller to use for data persistence
     *
     * Sets up the manager with saved preferences and loads match history from CoreData.
     * Subscribes to RealmNumberManager updates.
     */
    private init(persistenceController: PersistenceController = .shared) {
        self.viewContext = persistenceController.container.viewContext
        self.persistenceController = persistenceController  // Claude: Store reference for background operations
        super.init()
        
        loadPreferences()
        loadMatchLogs()
        Logger.focus.debug("📱 FocusNumberManager initialized with number: \(self.selectedFocusNumber)")
    }
    
    /// Configures the manager with necessary dependencies after initialization.
    /// This should be called once, typically after the RealmNumberManager instance is available.
    func configure(realmManager: RealmNumberManager) {
        // Ensure configuration happens only once
        guard !isConfigured else {
            // print("ℹ️ FocusNumberManager already configured. Skipping.") // Optional log
            return
        }
        print("🔧 Configuring FocusNumberManager with RealmNumberManager...")
        setupRealmNumberSubscription(realmManager: realmManager)
        isConfigured = true // Mark as configured
    }

    /// Sets up the Combine subscription to the provided RealmNumberManager's realm number.
    private func setupRealmNumberSubscription(realmManager: RealmNumberManager) { // Accept instance
        // print("➡️ [Combine Trace] Setting up realm number subscription...") // REMOVED TRACE LOG
        realmManager.$currentRealmNumber // Use the passed instance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newRealmNumber in
                // Log *every* value received by the sink
                // print("➡️ [Combine Trace] Sink received newRealmNumber: \(newRealmNumber)") // REMOVED TRACE LOG 
                self?.updateRealmNumber(newRealmNumber)
            }
            .store(in: &cancellables)
        print("🔗 FocusNumberManager subscribed to RealmNumberManager updates.")
    }
    
    // MARK: - Number Processing Methods
    
    /**
     * Reduces any number to a single digit (1-9) using numerological principles.
     *
     * - Parameter number: Any integer value
     * - Returns: A single digit (1-9)
     *
     * Algorithm:
     * 1. Sum all digits in the number
     * 2. If result > 9, repeat the process until a single digit is reached
     * 3. Return the final single digit
     *
     * Examples:
     * - 15 -> 1+5 = 6
     * - 123 -> 1+2+3 = 6
     * - 999 -> 9+9+9 = 27 -> 2+7 = 9
     */
    func reduceToSingleDigit(_ number: Int) -> Int {
        var sum = 0
        var num = abs(number)
        
        // First sum all digits
        while num > 0 {
            sum += num % 10
            num /= 10
        }
        
        // If sum is still greater than 9, reduce again
        while sum > 9 {
            var tempSum = 0
            while sum > 0 {
                tempSum += sum % 10
                sum /= 10
            }
            sum = tempSum
        }
        
        return sum
    }
    
    /**
     * Returns the effective focus number, ensuring it's within valid range (1-9).
     * Used for journal entries and other contexts where the number must be valid.
     */
    var effectiveFocusNumber: Int {
        max(1, min(selectedFocusNumber, 9))  // Ensure valid range
    }
    
    // MARK: - Match Detection and Saving
    
    /**
     * Verifies if the given realm number matches the current focus number and saves the match if needed.
     *
     * This method:
     * 1. Checks if the realm number matches the current focus number
     * 2. Validates that this match hasn't been recorded recently
     * 3. Saves a new match record to Core Data if conditions are met
     * 4. Sends a notification about the match
     *
     * - Parameters:
     *   - realmNumber: The current realm number to check against
     *   - completion: Closure called with whether a match was verified and saved
     */
    func verifyAndSaveMatch(realmNumber: Int?, completion: @escaping (Bool) -> Void = { _ in }) {
        // print("➡️ [Match Trace] verifyAndSaveMatch called with realmNumber: \(realmNumber ?? -1)") // REMOVED TRACE LOG
        print("\n🔍 Verifying potential match...")
        
        // Must have a valid realm number
        guard let matchedRealmNumber = realmNumber else {
            print("❌ Cannot verify match - no realm number provided")
            completion(false)
            return
        }
        
        // Must match the current focus number
        guard matchedRealmNumber == selectedFocusNumber else {
            print("ℹ️ No match: realm number \(matchedRealmNumber) ≠ focus number \(selectedFocusNumber)")
            completion(false)
            return
        }
        
        // Check if we already recorded this match recently
        print("🔍 Match found! Checking if it's a new match...")
        if checkForRecentMatchOrNotification(for: matchedRealmNumber) {
            print("ℹ️ Match already recorded recently - skipping")
            completion(false)
            return
        }
        
        print("✨ New match confirmed! Recording match between Focus Number \(selectedFocusNumber) and Realm Number \(matchedRealmNumber)")
        
        // Fetch and store the insight for this new match
        if let insightText = NumerologyInsightService.shared.fetchInsight(forNumber: matchedRealmNumber, category: InsightCategory.insight) {
            self.latestMatchedInsight = MatchedInsightData(
                number: matchedRealmNumber,
                category: InsightCategory.insight, // Or dynamically determine if needed
                text: insightText,
                timestamp: Date() // Record when this insight was fetched/matched
            )
            print("💡 Fetched insight for matched number \(matchedRealmNumber): \(insightText.prefix(50))...")

            // NEW: Save this insight to PersistedInsightLog
            savePersistedInsight(
                number: matchedRealmNumber,
                category: InsightCategory.insight, // Or determine dynamically if needed
                text: insightText,
                tags: "FocusMatch, RealmTouch" // Example tags
            )

        } else {
            print("⚠️ Could not fetch insight for matched number \(matchedRealmNumber).")
        }
        
        // Continue with the rest of the existing method
        saveMatch(matchedRealmNumber: matchedRealmNumber)
        completion(true)
    }
    
    /**
     * Checks if there's a recently recorded match *for the specific number* to prevent duplicates.
     * Also checks the timestamp cache for recently *sent notifications*.
     *
     * - Parameter realmNumber: The specific realm number to check for recent matches/notifications.
     * - Returns: Boolean indicating if a recent match exists or notification was sent recently (true) or not (false).
     *
     * Prevents duplicate match records and notifications by checking:
     * 1. If a FocusMatch for this number exists in CoreData within the last `notificationDebounceInterval`.
     * 2. If a notification for this number was sent recently (tracked in `lastNotificationTimestamps`).
     */
    private func checkForRecentMatchOrNotification(for realmNumber: Int) -> Bool {
        let now = Date()
        // print("➡️ [Debounce Check] Checking for recent match/notification for number: \(realmNumber) at time: \(now.timeIntervalSince1970)") // REMOVED TRACE LOG

        // 1. Check timestamp cache first (faster)
        if let lastSent = lastNotificationTimestamps[realmNumber] {
            let interval = now.timeIntervalSince(lastSent)
            // print("  [Debounce Check] Found cached timestamp: \(lastSent.timeIntervalSince1970) (Interval: \(interval)s)") // REMOVED TRACE LOG
            if interval < notificationDebounceInterval {
                // print("  [Debounce Check] Result: TRUE (Cached timestamp within \(notificationDebounceInterval)s interval)") // REMOVED TRACE LOG
                print("ℹ️ Notification for \(realmNumber) already sent recently (cached) - skipping")
                return true
            }
             // print("  [Debounce Check] Cached timestamp is older than interval.") // REMOVED TRACE LOG
        } else {
            // print("  [Debounce Check] No cached timestamp found for \(realmNumber).") // REMOVED TRACE LOG
        }

        // 2. Check Core Data for recent *saved* matches for this specific number
        // Create fetch request within this function scope
        let request = NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
        request.predicate = NSPredicate(format: "matchedNumber == %d", realmNumber)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusMatch.timestamp, ascending: false)]
        request.fetchLimit = 1 // Only need the most recent one

        do {
            let recentMatches = try viewContext.fetch(request)
            if let mostRecentMatch = recentMatches.first {
                let interval = now.timeIntervalSince(mostRecentMatch.timestamp)
                // print("  [Debounce Check] Found most recent saved match timestamp: \(mostRecentMatch.timestamp.timeIntervalSince1970) (Interval: \(interval)s)") // REMOVED TRACE LOG
                 if interval < notificationDebounceInterval {
                    // print("  [Debounce Check] Result: TRUE (Saved match timestamp within \(notificationDebounceInterval)s interval)") // REMOVED TRACE LOG
                    print("ℹ️ Match for \(realmNumber) already recorded recently in CoreData - skipping")
                    return true
                }
                 // print("  [Debounce Check] Saved match timestamp is older than interval.") // REMOVED TRACE LOG
            } else {
                 // print("  [Debounce Check] No saved matches found in Core Data for \(realmNumber).") // REMOVED TRACE LOG
            }
        } catch {
             // print("  [Debounce Check] Error fetching recent matches: \(error)") // REMOVED TRACE LOG
        }
        
        // print("⬅️ [Debounce Check] Result: FALSE (No recent match/notification found)") // REMOVED TRACE LOG
        return false
    }
    
    /**
     * Saves a match to Core Data and sends a notification
     *
     * - Parameter matchedRealmNumber: The realm number that matched
     */
    private func saveMatch(matchedRealmNumber: Int) {
        print("\n🌟 Saving new match...")
        print("   Focus Number: \(selectedFocusNumber)")
        print("   Realm Number: \(matchedRealmNumber)")
        print("   Timestamp: \(Date())")
        
        // Ensure we save on the main thread for Core Data
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.saveMatch(matchedRealmNumber: matchedRealmNumber)
            }
            return
        }
        
        // Claude: PERFORMANCE OPTIMIZATION - Move entire match creation to background context
        // This prevents blocking the main thread during Core Data operations
        
        // Capture values for background context
        let currentSelectedNumber = selectedFocusNumber
        let currentLocation = _currentLocation
        
        // Perform Core Data operations on background thread
        persistenceController.performBackgroundTask { backgroundContext in
            // Create a new match entity in background context
            let newMatch = FocusMatch(context: backgroundContext)
            newMatch.timestamp = Date()
            newMatch.chosenNumber = Int16(currentSelectedNumber)
            newMatch.matchedNumber = Int16(matchedRealmNumber)
            
            // Add location if available
            if let location = currentLocation {
                newMatch.locationLatitude = location.latitude
                newMatch.locationLongitude = location.longitude
            } else {
                // Default to 0,0 if no location
                newMatch.locationLatitude = 0
                newMatch.locationLongitude = 0
            }
            
            // Background context automatically saves when operation completes
            print("   🚀 Match creation scheduled for background save")
            
        } completion: { result in
            // Handle completion on main thread
            switch result {
            case .success:
                print("   ✅ Match saved successfully (background context)")
                // Reload matches on main thread
                self.loadMatchLogs()
                print("   📱 Updated Match Count: \(self.matchLogs.count)")
                
            case .failure(let error):
                print("   ❌ Error saving match: \(error.localizedDescription)")
            }
        }
        
        // Additional check for tests to verify the save was successful
        if matchLogs.isEmpty {
            print("   ⚠️ Warning: Match saved but matchLogs is still empty")
            // For test environments, try to verify the save another way
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
            do {
                let count = try viewContext.count(for: fetchRequest)
                print("   📊 Direct fetch match count: \(count)")
            } catch {
                print("   ❌ Error counting matches: \(error)")
            }
        }
        
        // Send local notification for the match
        sendMatchNotification(for: matchedRealmNumber)
        print("🌟 ================================\n")
    }
    
    /**
     * Sends a local notification for a number match *after checking debounce cache*.
     *
     * - Parameter number: The number that matched
     *
     * Creates and schedules a local notification using UNUserNotificationCenter.
     * Updates the `lastNotificationTimestamps` cache.
     */
    private func sendMatchNotification(for number: Int) {
        print("➡️ [Notification Debug] Scheduling NEW numerology notification for focus number: \(number)")

        // Directly schedule the new numerology notification
        // Use a short delay (e.g., 1 second) to allow the UI to potentially update first if needed
        NotificationManager.shared.scheduleRandomNumerologyNotification(forNumber: number, delaySeconds: 1)
    }
    
    /**
     * Enables match detection after startup stabilization period.
     * This prevents heavy match detection operations from running during app launch.
     */
    func enableMatchDetection() {
        isMatchDetectionEnabled = true
        print("🎯 Match detection enabled - will now check for matches")
        
        // Perform an immediate check now that detection is enabled
        checkForMatches()
    }
    
    /**
     * Checks if the current focus number matches the realm number and handles match creation.
     *
     * This method is called:
     * 1. When the realm number changes
     * 2. On a timer if auto-updates are enabled
     * 3. When the user selects a new focus number
     *
     * It performs the core matching logic of the app, determining when to create
     * new match records based on the current state of the focus and realm numbers.
     */
    func checkForMatches() {
        // CRITICAL: Skip match detection during startup to prevent freeze
        guard isMatchDetectionEnabled else {
            print("⏸️ Match detection disabled during startup - skipping check")
            return
        }
        // print("➡️ [Match Trace] checkForMatches called. Current selectedFocusNumber: \(selectedFocusNumber), realmNumber: \(realmNumber)") // REMOVED TRACE LOG
        // Only create a match if the numbers are equal and valid
        if selectedFocusNumber == realmNumber && Self.validFocusNumbers.contains(selectedFocusNumber) {
            print("🔍 Match found! Focus number \(selectedFocusNumber) matches realm number \(realmNumber)")
            // Using DispatchQueue.main to ensure Core Data operations run on the main thread
            DispatchQueue.main.async { [weak self] in
                // print("➡️ [Match Trace] DispatchQueue.main.async block in checkForMatches entered.") // REMOVED TRACE LOG
                guard let self = self else { 
                    // print("⚠️ [Match Trace] self is nil in checkForMatches async block.") // REMOVED TRACE LOG
                    return
                 }
                self.verifyAndSaveMatch(realmNumber: self.realmNumber) { success in
                    if success {
                        print("✅ Match successfully saved")
                    } else {
                        print("⚠️ Match verification failed or skipped") // Updated log message
                    }
                    // print("⬅️ [Match Trace] verifyAndSaveMatch completion block finished.") // REMOVED TRACE LOG
                }
            }
        } else {
            // Print debug info for non-matching cases
            if selectedFocusNumber != realmNumber {
                print("🔍 No match: Focus number \(selectedFocusNumber) doesn't match realm number \(realmNumber)")
            } else if !Self.validFocusNumbers.contains(selectedFocusNumber) {
                print("🔍 No match: Focus number \(selectedFocusNumber) is not valid")
            }
        }
        // print("⬅️ [Match Trace] checkForMatches finished.") // REMOVED TRACE LOG
    }
    
    /**
     * Updates the manager's internal realm number and checks for matches.
     *
     * - Parameter newValue: The new realm number value (1-9)
     *
     * This method is typically called from an observer of the RealmNumberManager to
     * keep this manager's realm number in sync with the current calculated value.
     * Each time the realm number changes, the manager automatically checks if it
     * matches the current focus number.
     */
    func updateRealmNumber(_ newValue: Int) {
        // print("➡️ [Match Trace] updateRealmNumber called with newValue: \(newValue). Current realmNumber: \(realmNumber)") // REMOVED TRACE LOG
        if realmNumber != newValue {
            print("\n🔄 FocusNumberManager received realm number update: \(realmNumber) → \(newValue)")
            realmNumber = newValue
            checkForMatches() // Call match checking
        } else {
             print("\nℹ️ FocusNumberManager received realm number update: \(newValue) (unchanged)")
        }
        // print("⬅️ [Match Trace] updateRealmNumber finished for newValue: \(newValue)") // REMOVED TRACE LOG
    }
    
    /**
     * Sets the user's focus number and saves it to preferences.
     *
     * - Parameter number: The focus number chosen by the user (will be constrained to 1-9)
     *
     * This method:
     * 1. Validates the input to ensure it's in the valid range (1-9)
     * 2. Updates the published selectedFocusNumber property
     * 3. Persists the selection to Core Data
     * 4. Checks if the new focus number matches the current realm number
     *
     * Called when the user explicitly selects a new focus number in the UI.
     */
    func userDidPickFocusNumber(_ number: Int) {
        let validNumber = max(1, min(number, 9))
        selectedFocusNumber = validNumber
        
        // Save to Core Data
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(validNumber),
            isAutoUpdateEnabled: isAutoUpdateEnabled
        )
        
        print("\n📝 Focus Number set to: \(validNumber)")
        
        // 🌟 ALWAYS publish focus number change for VybeMatchManager (UI updates should be immediate)
        NotificationCenter.default.post(
            name: NSNotification.Name.focusNumberChanged,
            object: nil,
            userInfo: ["focusNumber": validNumber]
        )
        
        // 🔧 FIX: Always notify UI of change immediately, regardless of match detection status
        // This ensures UI components update instantly when user picks a new focus number
        DispatchQueue.main.async {
            // Force an immediate UI update notification
            NotificationCenter.default.post(
                name: NSNotification.Name("FocusNumberUIUpdateRequired"),
                object: nil,
                userInfo: ["focusNumber": validNumber]
            )
        }
        
        // Check for immediate match with current realm number (only if match detection is enabled)
        checkForMatches()
    }
    
    // MARK: - Transcendental Calculations
    
    /**
     * Calculates a transcendental number based on multiple factors.
     *
     * - Returns: A single digit (1-9) representing the transcendental number
     *
     * This method combines:
     * 1. Time-based factors (hour, minute)
     * 2. Location-based factors (coordinates)
     * 3. The user's focus number
     *
     * The result is reduced to a single digit (1-9) using numerological principles.
     * Used for advanced metaphysical calculations beyond basic realm number matching.
     */
    func calculateTranscendentalNumber() -> Int {
        let timeFactor = calculateTimeFactor()
        let locationFactor = calculateLocationFactor()
        let focusFactor = selectedFocusNumber
        
        // Calculate the transcendental number by combining all factors
        let sum = timeFactor + locationFactor + focusFactor
        return reduceToSingleDigit(sum)
    }
    
    /**
     * Calculates a numeric factor based on current time.
     *
     * - Returns: A single digit (1-9) derived from the current time
     *
     * Uses the current hour and minute to create a time-based factor
     * for transcendental calculations.
     */
    func calculateTimeFactor() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        guard let hour = components.hour,
              let minute = components.minute else {
            return 1 // Default to 1 if we can't get time components
        }
        
        // Combine hour and minute into a single number and reduce
        return reduceToSingleDigit(hour + minute)
    }
    
    /**
     * Calculates a numeric factor based on current location.
     *
     * - Returns: A single digit (1-9) derived from the device's coordinates
     *
     * Uses latitude and longitude coordinates to create a location-based
     * factor for transcendental calculations. Returns 1 if no location is available.
     */
    func calculateLocationFactor() -> Int {
        guard let location = _currentLocation else {
            return 1 // Default to 1 if no location available
        }
        
        // Convert coordinates to positive integers by removing decimal point
        let latString = String(format: "%.6f", abs(location.latitude))
            .replacingOccurrences(of: ".", with: "")
        let longString = String(format: "%.6f", abs(location.longitude))
            .replacingOccurrences(of: ".", with: "")
        
        // Convert strings to integers and reduce to single digits
        let latSum = reduceToSingleDigit(Int(latString) ?? 0)
        let longSum = reduceToSingleDigit(Int(longString) ?? 0)
        
        // Combine latitude and longitude factors
        return reduceToSingleDigit(latSum + longSum)
    }
    
    /**
     * Retrieves the current heart rate from HealthKit if available
     *
     * - Returns: The current heart rate or 0 if not available
     */
    private func getCurrentHeartRate() -> Double {
        return HealthKitManager.shared.getCurrentHeartRate()
    }
    
    // Claude: PERFORMANCE OPTIMIZATION - Enhanced background context insight saving
    private func savePersistedInsight(number: Int, category: String, text: String, tags: String?) {
        // Claude: Move to background context for better performance - no main thread requirement
        persistenceController.performBackgroundTask { backgroundContext in
            // Create insight log in background context
            let newPersistedInsight = PersistedInsightLog(context: backgroundContext)
            newPersistedInsight.id = UUID()
            newPersistedInsight.timestamp = Date()
            newPersistedInsight.number = Int16(number)
            newPersistedInsight.category = category
            newPersistedInsight.text = text
            newPersistedInsight.tags = tags // e.g., "FocusMatch, RealmTouch"
            
            print("🚀 PersistedInsightLog creation scheduled for background save")
            
        } completion: { result in
            // Handle completion on main thread
            switch result {
            case .success:
                print("💾 Successfully saved PersistedInsightLog for number \(number), category \(category) (background context).")
                
            case .failure(let error):
                print("❌ Error saving PersistedInsightLog: \(error.localizedDescription)")
            }
        }
    }

    // Restore the methods accidentally removed
    /**
     * Loads user preferences from Core Data.
     *
     * This method:
     * 1. Fetches the user's last selected focus number
     * 2. Loads the auto-update preference
     * 3. Sets a default number (1) if no previous preference exists
     */
    private func loadPreferences() {
        let preferences = UserPreferences.fetch(in: viewContext)
        selectedFocusNumber = Int(preferences.lastSelectedNumber)
        
        // Ensure we never have 0 as a focus number
        if selectedFocusNumber == 0 {
            selectedFocusNumber = Self.defaultFocusNumber
            UserPreferences.save(
                in: viewContext,
                lastSelectedNumber: Int16(Self.defaultFocusNumber),
                isAutoUpdateEnabled: false
            )
        }
        
        isAutoUpdateEnabled = preferences.isAutoUpdateEnabled
        Logger.focus.debug("Loaded preferences - Number: \(self.selectedFocusNumber), Auto Update: \(self.isAutoUpdateEnabled)")
    }
    
    /**
     * Saves the auto-update preference to Core Data.
     * 
     * - Parameter enabled: Whether auto-update should be enabled
     *
     * This method persists both the current focus number and auto-update preference
     * to ensure they remain in sync.
     */
    private func saveAutoUpdatePreference(_ enabled: Bool) {
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(selectedFocusNumber),
            isAutoUpdateEnabled: enabled
        )
    }
    
    /**
     * Loads the history of matches from Core Data.
     *
     * This method:
     * 1. Creates a fetch request for FocusMatch entities
     * 2. Sorts matches by timestamp (most recent first)
     * 3. Updates the matchLogs published property with results
     *
     * Called during initialization and after creating new matches.
     */
    func loadMatchLogs() {
        // Create a fetch request for FocusMatch entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusMatch.timestamp, ascending: false)]
        
        do {
            // Execute the fetch request and safely cast the results
            let results = try viewContext.fetch(request)
            
            // Cast the results to FocusMatch objects
            matchLogs = results.compactMap { $0 as? FocusMatch }
            print("📱 Loaded \(matchLogs.count) matches from storage")
        } catch {
            print("❌ Failed to fetch matches: \(error)")
        }
    }
    
    /**
     * Schedules a daily numerology notification for the user's current focus number
     *
     * This method sends a notification with a random message from the numerology
     * data for the current focus number, providing daily guidance to the user.
     */
    func scheduleDailyNumerologyMessage() {
        // Get the current focus number
        let focusNumber = selectedFocusNumber
        
        // Schedule the notification
        NotificationManager.shared.scheduleDailyNumerologyMessage(forFocusNumber: focusNumber)
        
        print("📆 Scheduled daily numerology message for focus number \(focusNumber)")
    }
    
    /**
     * Updates the selected focus number and saves the change to persistent storage.
     *
     * This method:
     * 1. Validates the new focus number is within range
     * 2. Updates the published property for SwiftUI binding
     * 3. Saves the change to Core Data for persistence
     * 4. Optionally sends a notification with numerology insight for the new number
     *
     * - Parameter number: The new focus number to set (validated to be within 1-9)
     * - Parameter sendNotification: Whether to send a notification about the new focus number
     */
    func setFocusNumber(_ number: Int, sendNotification: Bool = false) {
        // Validate the number is within range
        let validNumber = max(1, min(number, 9))
        print("🔄 Setting focus number to \(validNumber)")
        
        // Update the stored value and notify observers
        let previousNumber = selectedFocusNumber
        selectedFocusNumber = validNumber
        
        // Save to UserDefaults for persistence
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(validNumber),
            isAutoUpdateEnabled: isAutoUpdateEnabled
        )
        
        print("✅ Focus number updated to \(validNumber)")
        
        // Optionally send a notification with numerology insight
        if sendNotification && validNumber != previousNumber {
            // Send an immediate notification with a relevant insight
            NotificationManager.shared.scheduleNumerologyNotification(
                forNumber: validNumber,
                category: .insight,
                delaySeconds: 1
            )
        }
    }

    private func handleLocationUpdate(_ location: CLLocation) {
        Logger.location.debug("📍 Location update received: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        currentLocation = location
        // ... rest of the method ...
    }

    private func handleLocationError(_ error: Error) {
        Logger.location.error("❌ Location error: \(error.localizedDescription)")
        // ... rest of the method ...
    }

    private func handleLocationAuthorizationChange(_ status: CLAuthorizationStatus) {
        Logger.location.debug("🔐 Location authorization changed to: \(status.rawValue)")
        // ... rest of the method ...
    }

    private func handleLocationAuthorizationError(_ error: Error) {
        Logger.location.error("❌ Location authorization error: \(error.localizedDescription)")
        // ... rest of the method ...
    }
}

// MARK: - CLLocationManagerDelegate
/**
 * Location manager delegate implementation.
 *
 * Handles location updates and error conditions for the Core Location framework.
 * These methods support the transcendental calculations that incorporate
 * location data into realm number generation.
 */
extension FocusNumberManager: CLLocationManagerDelegate {
    /**
     * Called when new location data is available.
     *
     * - Parameters:
     *   - manager: The location manager providing the update
     *   - locations: Array of new location objects, typically with the most recent one last
     *
     * Updates the internal location cache used for transcendental calculations.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        _currentLocation = location
        Logger.location.debug("📍 Location updated: \(location.latitude), \(location.longitude)")
    }
    
    /**
     * Called when location services encounters an error.
     *
     * - Parameters:
     *   - manager: The location manager providing the update
     *   - error: The error that occurred
     *
     * Handles different error cases with appropriate logging:
     * - Denied: User has denied location permissions
     * - LocationUnknown: Temporary inability to determine location
     * - Other errors: Logged with full description
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .denied:
                Logger.location.error("❌ Location access denied")
            case .locationUnknown:
                Logger.location.debug("⚠️ Location temporarily unavailable")
            default:
                Logger.location.error("❌ Location error: \(error.localizedDescription)")
            }
        }
    }
}

