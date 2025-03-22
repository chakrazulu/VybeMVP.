/**
 * Filename: FocusNumberManager.swift
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
    @Published var realmNumber: Int = 0 {
        didSet {
            // Check for matches whenever the realm number changes
            checkForMatches()
        }
    }
    
    /// Timer for automatic checking of matches
    private var timer: Timer?
    
    /// Cached location coordinates for calculations
    private var _currentLocation: CLLocationCoordinate2D?
    
    /// Core Data managed object context for persistence
    private let viewContext: NSManagedObjectContext
    
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
    
    /// Access to insights manager for notification content
    private let insightManager = NumberMatchInsightManager.shared
    
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
     */
    private init(persistenceController: PersistenceController = .shared) {
        self.viewContext = persistenceController.container.viewContext
        super.init()
        
        loadPreferences()
        loadMatchLogs()
        Logger.debug("📱 FocusNumberManager initialized with number: \(selectedFocusNumber)", category: Logger.focus)
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
    
    // MARK: - Timer Management
    
    /**
     * Starts periodic updates to check for matches between focus and realm numbers.
     *
     * This method:
     * 1. Stops any existing timers
     * 2. Creates a new timer that fires every 60 seconds
     * 3. Updates preferences to reflect auto-update is enabled
     */
    func startUpdates() {
        stopUpdates() // Clear any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.checkForMatches()
        }
        
        isAutoUpdateEnabled = true
        saveAutoUpdatePreference(true)
        Logger.debug("▶️ Started focus number updates", category: Logger.focus)
    }
    
    /**
     * Stops periodic update checks for matches.
     *
     * This method:
     * 1. Invalidates and removes any existing timer
     * 2. Updates preferences to reflect auto-update is disabled
     */
    func stopUpdates() {
        timer?.invalidate()
        timer = nil
        isAutoUpdateEnabled = false
        saveAutoUpdatePreference(false)
        Logger.debug("⏹ Stopped focus number updates", category: Logger.focus)
    }
    
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
        Logger.debug("Loaded preferences - Number: \(selectedFocusNumber), Auto Update: \(isAutoUpdateEnabled)", category: Logger.focus)
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
        print("\n🔍 Verifying potential match...")
        
        // Pre-load insight manager for background operations
        let insightManager = NumberMatchInsightManager.shared
        let _ = insightManager.getAllInsights()
        
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
        if isRecentMatch(realmNumber: matchedRealmNumber) {
            print("ℹ️ Match already recorded recently - skipping")
            completion(false)
            return
        }
        
        print("✨ New match confirmed! Recording match between Focus Number \(selectedFocusNumber) and Realm Number \(matchedRealmNumber)")
        
        // Continue with the rest of the existing method
        saveMatch(matchedRealmNumber: matchedRealmNumber)
        completion(true)
    }
    
    /**
     * Checks if there's a recently recorded match to prevent duplicates.
     *
     * - Returns: Boolean indicating if a recent match exists (true) or not (false)
     *
     * Prevents duplicate match records by checking if any matches have been
     * recorded in the last 60 seconds.
     */
    private func checkForRecentMatch() -> Bool {
        // Get current time
        let now = Date()
        
        // Check if there's a match in the last minute
        return matchLogs.contains { match in
            let timeDifference = now.timeIntervalSince(match.timestamp)
            return timeDifference < 60 // Less than 1 minute
        }
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
        
        // Create a new match entity
        let newMatch = FocusMatch(context: viewContext)
        // No UUID/id property in the FocusMatch entity
        newMatch.timestamp = Date()
        newMatch.chosenNumber = Int16(selectedFocusNumber)
        newMatch.matchedNumber = Int16(matchedRealmNumber)
        
        // Add location if available
        if let location = _currentLocation {
            newMatch.locationLatitude = location.latitude
            newMatch.locationLongitude = location.longitude
        } else {
            // Default to 0,0 if no location
            newMatch.locationLatitude = 0
            newMatch.locationLongitude = 0
        }
        
        // Save to Core Data
        do {
            // Ensure changes are saved synchronously in test context
            viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            try viewContext.save()
            print("   ✅ Match saved successfully")
            
            // Force immediate reload of matches
            loadMatchLogs() 
            print("   📱 New Match Count: \(matchLogs.count)")
            
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
        } catch {
            print("❌ Failed to save match: \(error)")
            print("   Error Description: \(error.localizedDescription)")
        }
        print("🌟 ================================\n")
    }
    
    /**
     * Sends a local notification for a number match
     *
     * - Parameter number: The number that matched
     *
     * Creates and schedules a local notification using the NotificationManager.
     * The notification includes detailed information about the match significance.
     */
    private func sendMatchNotification(for number: Int) {
        // Create a background task identifier to ensure completion in background
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // End the task if we run out of time
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
                print("⚠️ Background task for notification in FocusNumberManager timed out")
            }
        }
        
        // Ensure insight manager is loaded early for background operation
        let insightManager = NumberMatchInsightManager.shared
        let insights = insightManager.getAllInsights()
        print("📲 Preparing to send match notification (loaded \(insights.count) insights)")
        
        // Get insight for this number match - always returns a valid insight
        let insight = insightManager.getInsight(for: number)
        print("📲 Sending match notification for number \(number) with insight: \(insight.title)")
        print("📲 Insight summary: \(insight.summary)")
        print("📲 Insight detailed: \(insight.detailedInsight.prefix(50))...")
        
        // Create our own notification content directly instead of using NotificationManager
        // This ensures consistent behavior in all app states
        let content = UNMutableNotificationContent()
        content.title = insight.title
        content.body = insight.summary
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "MATCH_NOTIFICATION"
        
        // Include additional information for when notification is tapped
        content.userInfo = [
            "type": "number_match",
            "matchNumber": "\(number)",
            "insight": insight.detailedInsight,
            "sent_from": "focus_manager",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        // Use time interval trigger for more reliable delivery
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "match_notification_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification from FocusNumberManager: \(error.localizedDescription)")
            } else {
                print("✅ Rich notification with insight scheduled successfully from FocusNumberManager")
                print("📱 Notification will appear with title: \(content.title)")
                print("📱 And body: \(content.body)")
            }
            
            // Complete the background task if we're done
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
                print("✅ Background task for notification in FocusNumberManager completed")
            }
        }
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
    private func checkForMatches() {
        // Only create a match if the numbers are equal and valid
        if selectedFocusNumber == realmNumber && Self.validFocusNumbers.contains(selectedFocusNumber) {
            print("🔍 Match found! Focus number \(selectedFocusNumber) matches realm number \(realmNumber)")
            // Using DispatchQueue.main to ensure Core Data operations run on the main thread
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.verifyAndSaveMatch(realmNumber: self.realmNumber) { success in
                    if success {
                        print("✅ Match successfully saved")
                    } else {
                        print("⚠️ Match verification failed")
                    }
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
        if realmNumber != newValue {
            print("\n🔄 Realm number changed: \(realmNumber) → \(newValue)")
            realmNumber = newValue
            checkForMatches()
        }
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
        // Check for immediate match with current realm number
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
     * Check if a match with the given realm number was recorded recently
     * to prevent duplicate notifications
     *
     * - Parameter realmNumber: The realm number to check
     * - Returns: true if a recent match exists, false otherwise
     */
    private func isRecentMatch(realmNumber: Int) -> Bool {
        // Ensure we check on the main thread for Core Data access
        if Thread.isMainThread {
            return checkForRecentMatch()
        } else {
            // If called from background thread, dispatch to main thread and wait
            var result = false
            let semaphore = DispatchSemaphore(value: 0)
            
            DispatchQueue.main.async {
                result = self.checkForRecentMatch()
                semaphore.signal()
            }
            
            // Wait for main thread execution to complete (with timeout)
            _ = semaphore.wait(timeout: .now() + 3.0)
            return result
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     * Retrieves the current heart rate from HealthKit if available
     *
     * - Returns: The current heart rate or 0 if not available
     */
    private func getCurrentHeartRate() -> Double {
        return HealthKitManager.shared.getCurrentHeartRate()
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
        Logger.debug("📍 Location updated: \(location.latitude), \(location.longitude)", category: Logger.location)
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
                Logger.error("❌ Location access denied", category: Logger.location)
            case .locationUnknown:
                Logger.debug("⚠️ Location temporarily unavailable", category: Logger.location)
            default:
                Logger.error("❌ Location error: \(error.localizedDescription)", category: Logger.location)
            }
        }
    }
}

