/**
 * Filename: BackgroundManager.swift
 * 
 * Purpose: Manages background tasks, notifications, and scheduled updates 
 * for the app, ensuring proper functioning when the app is in both foreground 
 * and background states.
 *
 * Key responsibilities:
 * - Schedule and manage background app refresh tasks
 * - Handle local notification permissions and delivery
 * - Coordinate updates between various managers when in background
 * - Manage app lifecycle transitions (active/background)
 * - Clear notification badges when app becomes active
 * 
 * This manager is critical for ensuring the app continues to function
 * properly when not in active use, maintaining the realm number updates
 * and detecting matches even when the app is not in the foreground.
 */

import Foundation
import BackgroundTasks
import UserNotifications
import UIKit
import CoreData  // For CoreData operations if needed

/**
 * Manager responsible for background operations and notifications.
 *
 * This class handles:
 * - Background task scheduling and execution
 * - Local notification presentation and management
 * - Coordinating updates between realm and focus number managers
 * - Responding to app lifecycle events
 * - Badge count maintenance
 *
 * Design pattern: Singleton
 * Threading: Main thread for UI updates, background threads for tasks
 * Dependencies: RealmNumberManager, FocusNumberManager
 */
class BackgroundManager: NSObject, ObservableObject {
    /// Shared singleton instance for app-wide access
    static let shared = BackgroundManager()
    
    /// Identifier for the background refresh task registration
    private let backgroundTaskIdentifier = "com.infinitiesinn.vybe.backgroundUpdate"
    
    /// Reference to the realm number manager (weak to avoid retain cycles)
    private weak var realmNumberManager: RealmNumberManager?
    
    /// Reference to the focus number manager (weak to avoid retain cycles)
    private weak var focusNumberManager: FocusNumberManager?
    
    /// Timer for scheduling updates when app is active
    private var activeTimer: Timer?
    
    /// Update frequency when app is in the foreground (1 minute)
    private let activeUpdateInterval: TimeInterval = 60
    
    /// Update frequency when app is in the background (15 minutes)
    private let backgroundUpdateInterval: TimeInterval = 15 * 60
    
    /// Tolerance for timer scheduling to optimize battery life (10% of a minute)
    private let timerTolerance: TimeInterval = 0.1 * 60
    
    /// Currently executing background task
    private var backgroundTask: BGAppRefreshTask?
    
    /**
     * Private initializer to enforce singleton pattern.
     *
     * This initializer:
     * 1. Sets up notification handling
     * 2. Clears any existing badge count
     * 3. Registers for app lifecycle notifications
     */
    private override init() {
        super.init()
        print("🔄 Initializing BackgroundManager...")
        setupNotifications()
        
        // Clear badge count when app starts
        clearBadgeCount()
        
        // Register for app lifecycle notifications using weak self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    /**
     * Cleanup when the manager is deallocated.
     *
     * This method:
     * 1. Stops any active update timers
     * 2. Removes notification observers
     * 3. Completes any pending background tasks
     */
    deinit {
        stopActiveUpdates()
        NotificationCenter.default.removeObserver(self)
        backgroundTask?.setTaskCompleted(success: true)
        backgroundTask = nil
    }
    
    /**
     * Handles app becoming active in the foreground.
     *
     * This method clears notification badges and delivered notifications
     * when the user returns to the app.
     */
    @objc private func appDidBecomeActive() {
        // Clear badge count when app becomes active
        clearBadgeCount()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /**
     * Resets the app's badge count to zero.
     *
     * This method communicates with the notification center to
     * clear any numerical badges on the app icon.
     */
    private func clearBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("❌ Failed to clear badge count: \(error.localizedDescription)")
            } else {
                print("✅ Badge count cleared successfully")
            }
        }
    }
    
    /**
     * Sets up notification categories and delegates.
     *
     * This method:
     * 1. Configures the notification center delegate
     * 2. Defines notification categories (like match notifications)
     * 3. Registers for user notifications
     */
    private func setupNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        // Define notification categories and actions
        let matchCategory = UNNotificationCategory(
            identifier: "MATCH_NOTIFICATION",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        notificationCenter.setNotificationCategories([matchCategory])
        registerForNotifications()
    }
    
    /**
     * Sets the manager references for coordinated updates.
     *
     * This method:
     * 1. Stores references to the realm and focus number managers
     * 2. Starts active updates immediately after managers are set
     *
     * - Parameters:
     *   - realm: The RealmNumberManager instance
     *   - focus: The FocusNumberManager instance
     */
    func setManagers(realm: RealmNumberManager?, focus: FocusNumberManager?) {
        self.realmNumberManager = realm
        self.focusNumberManager = focus
        print("✅ Managers set successfully")
        
        // Start active updates immediately
        startActiveUpdates()
    }
    
    /**
     * Comprehensive method to start all monitoring systems in the app.
     *
     * This method:
     * 1. Ensures notification permissions are properly requested
     * 2. Starts active background updates
     * 3. Schedules background tasks
     * 4. Ensures all managers are in an active state
     *
     * This is the main entry point for initializing the app's
     * background monitoring capabilities.
     */
    func startMonitoring() {
        print("\n🔄 Starting comprehensive monitoring...")
        
        // Request notification permissions if needed
        registerForNotifications()
        
        // Start active updates
        startActiveUpdates()
        
        // Schedule background task
        scheduleBackgroundTask()
        
        // Ensure realm and focus managers are active
        if let realmManager = realmNumberManager, realmManager.currentState == .stopped {
            realmManager.startUpdates()
        }
        
        if let focusManager = focusNumberManager {
            focusManager.startUpdates()
        }
        
        print("✅ Comprehensive monitoring started successfully")
    }
    
    /**
     * Begins frequent updates when the app is in the foreground.
     *
     * This method:
     * 1. Performs an immediate update
     * 2. Schedules a timer for future updates at the active interval
     * 3. Configures the timer with appropriate tolerance for battery optimization
     */
    func startActiveUpdates() {
        print("\n⚡️ Starting active updates...")
        print("   Update interval: \(activeUpdateInterval) seconds")
        print("   Timer tolerance: \(timerTolerance) seconds")
        
        stopActiveUpdates() // Clear any existing timer
        
        // Perform initial update
        performUpdate()
        
        // Set up timer for frequent updates with tolerance
        activeTimer = Timer.scheduledTimer(withTimeInterval: activeUpdateInterval, repeats: true) { [weak self] _ in
            self?.performUpdate()
        }
        activeTimer?.tolerance = timerTolerance
        
        if activeTimer != nil {
            print("✅ Active timer started successfully")
        } else {
            print("❌ Failed to start active timer")
        }
    }
    
    // Stop frequent updates with proper cleanup
    func stopActiveUpdates() {
        print("\n🛑 Stopping active updates")
        if activeTimer != nil {
            activeTimer?.invalidate()
            activeTimer = nil
            print("✅ Active timer stopped successfully")
        }
    }
    
    /**
     * Performs a combined update of realm number and checks for matches.
     *
     * This method is called:
     * 1. On a timer when app is active
     * 2. During background task execution
     * 3. When manually triggered through the UI
     *
     * It coordinates updates across multiple managers to ensure consistent state.
     */
    private func performUpdate() {
        print("\n⚡️ Performing comprehensive update...")
        
        // Ensure the insight manager is loaded for background notifications
        let _ = NumberMatchInsightManager.shared.getAllInsights()
        
        // Get managers safely
        guard let realmManager = realmNumberManager,
              let focusManager = focusNumberManager else {
            print("❌ Cannot perform update - managers not set")
            return
        }
        
        // Check manager states
        if realmManager.currentState == .stopped {
            print("🔄 Starting RealmNumberManager from stopped state")
            realmManager.startUpdates()
        }
        
        if !focusManager.isAutoUpdateEnabled {
            print("🔄 Starting FocusNumberManager updates")
            focusManager.startUpdates()
        }
        
        // Force a realm number recalculation for consistency
        realmManager.calculateRealmNumber()
        
        // Check for matches
        print("🔍 Checking for focus/realm number match...")
        print("   Current realm number: \(realmManager.currentRealmNumber)")
        print("   Selected focus number: \(focusManager.selectedFocusNumber)")
        
        // Use realmNumber directly since it's a non-optional Int
        let realmNumber = realmManager.currentRealmNumber
        // Update realm number in focus manager (which will check for match)
        focusManager.verifyAndSaveMatch(realmNumber: realmNumber) { matchVerified in
            if matchVerified {
                print("🎯 Match verified! Creating notification...")
                
                // Check notification settings before creating
                UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                    guard settings.authorizationStatus == .authorized else {
                        print("❌ Cannot send notification - not authorized")
                        return
                    }
                    
                    // Create and schedule notification for match with detailed context info
                    self?.optimizedMatchNotification(
                        focusNumber: focusManager.selectedFocusNumber,
                        realmNumber: realmNumber
                    )
                }
            } else {
                print("❌ Match verification failed or no match found")
            }
        }
    }
    
    func handleBackgroundTask(_ task: BGAppRefreshTask) {
        print("\n🔄 Handling background task...")
        backgroundTask = task
        
        // Set up task expiration
        task.expirationHandler = { [weak self] in
            print("⚠️ Background task expired")
            self?.stopActiveUpdates()
            task.setTaskCompleted(success: false)
        }
        
        // Perform update with timeout
        let taskTimeout = DispatchTime.now() + .seconds(25) // 25 second timeout
        DispatchQueue.global().asyncAfter(deadline: taskTimeout) { [weak self] in
            if self?.backgroundTask === task {
                print("⚠️ Background task timed out")
                self?.stopActiveUpdates()
                task.setTaskCompleted(success: false)
            }
        }
        
        // Pre-initialize important managers for background operation
        // This ensures all required data is loaded before checking matches
        let _ = NumberMatchInsightManager.shared.getAllInsights()
        
        // Make sure managers are running before attempting operations
        if let realmManager = realmNumberManager, realmManager.currentState == .stopped {
            print("🔄 Starting RealmNumberManager for background processing")
            realmManager.startUpdates()
        }
        
        if let focusManager = focusNumberManager, !focusManager.isAutoUpdateEnabled {
            print("🔄 Starting FocusNumberManager for background processing")
            focusManager.startUpdates()
        }
        
        // Perform extended background update
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            // Force realm calculation to check for matches
            self.realmNumberManager?.calculateRealmNumber()
            
            // Allow some time for calculation to complete
            Thread.sleep(forTimeInterval: 2.0)
            
            // Explicitly check for matches with enhanced notification support
            if let realmManager = self.realmNumberManager, 
               let focusManager = self.focusNumberManager {
                
                let realmNumber = realmManager.currentRealmNumber
                print("🔍 Explicit background match check for realm number: \(realmNumber)")
                
                // Check if current focus number matches realm number
                if focusManager.selectedFocusNumber == realmNumber {
                    print("🎯 Background match found! Creating rich notification...")
                    self.optimizedMatchNotification(
                        focusNumber: focusManager.selectedFocusNumber,
                        realmNumber: realmNumber
                    )
                }
            }
            
            // Perform standard update
            self.performUpdate()
            
            // Schedule next background refresh
            self.scheduleBackgroundTask()
            
            // Mark task as completed
            task.setTaskCompleted(success: true)
            self.backgroundTask = nil
            print("✅ Background task completed successfully")
        }
    }
    
    func scheduleBackgroundTask() {
        print("📅 Scheduling next background task...")
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: backgroundUpdateInterval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background task scheduled successfully")
        } catch {
            print("❌ Could not schedule background task: \(error)")
        }
    }
    
    private func registerForNotifications() {
        print("\n🔔 Requesting notification permissions...")
        
        // First check current authorization status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 Current notification settings:")
            print("   Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("   Alert Setting: \(settings.alertSetting.rawValue)")
            print("   Sound Setting: \(settings.soundSetting.rawValue)")
            print("   Badge Setting: \(settings.badgeSetting.rawValue)")
            
            // If not determined, request authorization
            if settings.authorizationStatus == .notDetermined {
                self.requestNotificationPermissions()
            } else if settings.authorizationStatus == .denied {
                print("❌ Notifications are disabled in system settings")
            } else {
                print("✅ Notifications are already authorized")
            }
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted by user")
            } else {
                print("❌ Notification permission denied by user")
                if let error = error {
                    print("   Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func checkForMatches() {
        guard let focusManager = focusNumberManager,
              let realmManager = realmNumberManager else {
            print("❌ Managers not initialized")
            return
        }
        
        print("\n🔍 Checking for matches...")
        print("   Focus Number: \(focusManager.selectedFocusNumber)")
        print("   Realm Number: \(realmManager.currentRealmNumber)")
        print("   Realm Manager State: \(realmManager.currentState.rawValue)")
        
        // Additional validation checks
        let realmNumber = realmManager.currentRealmNumber
        if focusManager.isAutoUpdateEnabled &&
           realmManager.currentState == .active &&
           focusManager.selectedFocusNumber > 0 &&
           realmNumber > 0 &&
           focusManager.selectedFocusNumber == realmNumber {
            
            // Verify the match with FocusNumberManager
            focusManager.verifyAndSaveMatch(realmNumber: realmNumber) { matchVerified in
                if matchVerified {
                    print("🎯 Match verified! Creating notification...")
                    
                    // Check notification settings before creating
                    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                        guard settings.authorizationStatus == .authorized else {
                            print("❌ Cannot send notification - not authorized")
                            return
                        }
                        
                        // Create and schedule notification for match
                        self?.optimizedMatchNotification(
                            focusNumber: focusManager.selectedFocusNumber,
                            realmNumber: realmNumber
                        )
                    }
                } else {
                    print("❌ Match verification failed")
                }
            }
        } else {
            if !focusManager.isAutoUpdateEnabled {
                print("   ⚠️ No match - Focus Manager not active")
            }
            if focusManager.selectedFocusNumber == 0 {
                print("   ⚠️ No match - Invalid Focus Number (0)")
            }
            if realmManager.currentState != .active {
                print("   ⚠️ No match - Realm Manager not active")
            }
            
            if realmNumber == 0 {
                print("   ⚠️ No match - Invalid Realm Number (0)")
            }
            if focusManager.selectedFocusNumber != realmNumber {
                print("   ⚠️ No match - Numbers don't match")
            }
        }
    }
    
    private func optimizedMatchNotification(focusNumber: Int, realmNumber: Int) {
        // Use a batch update to handle notification operations
        batchNotificationUpdates { batch in
            // Clear existing notifications
            batch.add { [weak self] in
                self?.clearNotifications()
            }
            
            // Prepare new notification
            batch.add { [weak self] in
                self?.prepareMatchNotification(focusNumber: focusNumber, realmNumber: realmNumber)
            }
            
            batch.setCompletion {
                print("✅ Notification batch completed successfully")
            }
        }
    }
    
    private func prepareMatchNotification(focusNumber: Int, realmNumber: Int) {
        // Create a strong reference to the insight manager to ensure it's loaded in background context
        let insightManager = NumberMatchInsightManager.shared
        
        // Force initialization of all insights early to prevent potential background loading issues
        let insights = insightManager.getAllInsights()
        print("🌟 Preparing match notification for number \(realmNumber) in background (loaded \(insights.count) insights)")
        
        // Get insight for this match number - the enhanced manager guarantees an insight will be returned
        let insight = insightManager.getInsight(for: realmNumber)
        print("📲 Preparing match notification with insight: \(insight.title)")
        print("📲 Insight summary: \(insight.summary)")
        print("📲 Insight detailed: \(insight.detailedInsight.prefix(50))...")
        
        // Create a background task identifier to ensure completion
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // End the task if we run out of time
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
                print("⚠️ Background task for notification timed out")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = insight.title
        content.body = insight.summary
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "MATCH_NOTIFICATION"
        
        // Include additional information for when notification is tapped
        content.userInfo = [
            "type": "number_match",
            "matchNumber": "\(realmNumber)",
            "insight": insight.detailedInsight,
            "sent_from": "background_manager",
            "timestamp": Date().timeIntervalSince1970
        ]
        
        // Use time interval trigger for more reliable background delivery
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "match_notification_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Rich notification with insight scheduled successfully")
                print("📱 Notification will appear with title: \(content.title)")
                print("📱 And body: \(content.body)")
            }
            
            // Complete the background task if we're done
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
                print("✅ Background task for notification completed")
            }
        }
    }
    
    private func clearNotifications() {
        clearBadgeCount()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Notification Management
    private final class NotificationBatch {
        private var operations: [() -> Void] = []
        private var completion: (() -> Void)?
        
        init(capacity: Int = 2) {
            operations.reserveCapacity(capacity)
        }
        
        func add(_ operation: @escaping () -> Void) {
            operations.append(operation)
        }
        
        func setCompletion(_ completion: (() -> Void)?) {
            self.completion = completion
        }
        
        func execute() {
            guard !operations.isEmpty else { return }
            
            DispatchQueue.main.async { [operations, completion] in
                operations.forEach { $0() }
                completion?()
            }
        }
    }
    
    private func batchNotificationUpdates(_ updates: (NotificationBatch) -> Void) {
        let batch = NotificationBatch()
        updates(batch)
        batch.execute()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension BackgroundManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification response
        completionHandler()
    }
} 
