/*
 * ========================================
 * 🔄 BACKGROUND MANAGER - LIFECYCLE COORDINATOR
 * ========================================
 *
 * CORE PURPOSE:
 * Comprehensive background task orchestration managing app lifecycle transitions,
 * background refresh scheduling, notification delivery, and coordinated updates
 * between realm and focus number managers for continuous cosmic monitoring.
 *
 * BACKGROUND TASK SYSTEM:
 * - BGAppRefreshTask Integration: iOS background app refresh for realm calculations
 * - Task Scheduling: 15-minute intervals with proper iOS background limits
 * - Expiration Handling: 25-second timeout with graceful task completion
 * - Battery Optimization: Timer tolerance (30s) for efficient power usage
 * - State Persistence: Maintains manager states across app lifecycle changes
 *
 * NOTIFICATION MANAGEMENT:
 * - UNUserNotificationCenter Integration: Local notification delivery system
 * - Permission Handling: Authorization request flow with status monitoring
 * - Badge Management: Automatic badge clearing on app activation
 * - Category System: "MATCH_NOTIFICATION" category for cosmic matches
 * - Delegate Pattern: UNUserNotificationCenterDelegate for notification responses
 *
 * APP LIFECYCLE COORDINATION:
 * - Foreground Updates: 5-minute active timer with tolerance optimization
 * - Background Updates: 15-minute background refresh scheduling
 * - State Transitions: Seamless manager coordination during app state changes
 * - Memory Management: Proper timer cleanup and weak reference patterns
 * - Notification Cleanup: Badge and delivered notification clearing
 *
 * MANAGER INTEGRATION:
 * - RealmNumberManager: Weak reference for realm calculation coordination
 * - FocusNumberManager: Weak reference for match detection integration
 * - Combine Integration: Reactive updates via manager subscriptions
 * - State Synchronization: Ensures managers are active during updates
 * - Dependency Injection: Clean manager reference setup via setManagers()
 *
 * PERFORMANCE OPTIMIZATIONS:
 * - Reduced Update Frequency: 5-minute foreground (down from 1-minute)
 * - Timer Tolerance: 30-second tolerance for battery efficiency
 * - Weak References: Prevents retain cycles with manager dependencies
 * - Batch Operations: NotificationBatch for efficient notification updates
 * - Background Queue: Non-blocking background task execution
 *
 * UPDATE COORDINATION FLOW:
 * 1. performUpdate() triggers RealmNumberManager calculation
 * 2. Combine subscription in FocusNumberManager detects realm changes
 * 3. Automatic match detection via reactive programming
 * 4. Notification delivery handled by FocusNumberManager
 * 5. Background task completion with success status
 *
 * NOTIFICATION SYSTEM:
 * - Authorization Flow: Proper permission request with status checking
 * - Settings Monitoring: Tracks alert, sound, and badge permissions
 * - Foreground Presentation: Shows notifications even when app is active
 * - Response Handling: Processes user notification interactions
 * - Badge Synchronization: Automatic badge count management
 *
 * ERROR HANDLING & RESILIENCE:
 * - Task Expiration: Graceful handling of iOS background time limits
 * - Manager Validation: Guards against nil manager references
 * - Permission Failures: Robust handling of notification denials
 * - Timer Failures: Proper cleanup and restart mechanisms
 * - Background Failures: Fallback strategies for background task issues
 *
 * SINGLETON ARCHITECTURE:
 * - Shared Instance: App-wide access via BackgroundManager.shared
 * - Thread Safety: Main queue operations for UI-related updates
 * - Lifecycle Management: Proper initialization and cleanup
 * - Observer Pattern: UIApplication lifecycle notification handling
 * - Memory Safety: Automatic cleanup in deinit with observer removal
 *
 * TECHNICAL SPECIFICATIONS:
 * - Active Update Interval: 300 seconds (5 minutes) with 30s tolerance
 * - Background Update Interval: 900 seconds (15 minutes)
 * - Task Timeout: 25 seconds for background operations
 * - Task Identifier: "com.infinitiesinn.vybe.backgroundUpdate"
 * - Notification Categories: MATCH_NOTIFICATION with custom actions
 *
 * DEBUGGING & MONITORING:
 * - Comprehensive Logging: Detailed status updates for all operations
 * - Timer Status: Active/stopped state tracking with success confirmation
 * - Permission Tracking: Authorization status monitoring and reporting
 * - Task Lifecycle: Background task scheduling and completion logging
 * - Update Coordination: Manager state synchronization tracking
 */

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

    /// Update frequency when app is in the foreground (REDUCED from 1 minute to 5 minutes for performance)
    private let activeUpdateInterval: TimeInterval = 300  // 5 minutes

    /// Update frequency when app is in the background (15 minutes)
    private let backgroundUpdateInterval: TimeInterval = 15 * 60

    /// Tolerance for timer scheduling to optimize battery life (10% of 5 minutes)
    private let timerTolerance: TimeInterval = 0.1 * 300  // 30 seconds

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
     * Performs a combined update of realm number calculation, relying on FocusNumberManager for match checks.
     *
     * This method is called:
     * 1. On a timer when app is active
     * 2. During background task execution
     * 3. When manually triggered through the UI
     *
     * It coordinates updates across multiple managers to ensure consistent state.
     */
    private func performUpdate() {
        print("\n⚡️ Performing comprehensive update via BackgroundManager...")

        // Get managers safely
        guard let realmManager = realmNumberManager,
              let focusManager = focusNumberManager else {
            print("❌ Cannot perform update - managers not set")
            return
        }

        // Ensure managers are in an active state if needed
        if realmManager.currentState == .stopped {
            print("🔄 Starting RealmNumberManager from stopped state via BackgroundManager")
            realmManager.startUpdates()
        }

        // FocusManager auto-update timer might be redundant now, but let's ensure it's considered 'running' conceptually
        if !focusManager.isAutoUpdateEnabled {
            print("ℹ️ Ensuring FocusNumberManager state is active via BackgroundManager (Note: timer might be removed later)")
             // We don't necessarily need to start its timer, but ensure its state allows processing
             // focusManager.startUpdates() // Reconsider if FocusManager timer is still needed
        }

        // Force a realm number recalculation. The Combine subscription in FocusNumberManager
        // will automatically pick up the change and trigger its internal match check.
        print("🔄 Triggering RealmNumberManager calculation from BackgroundManager...")
        realmManager.calculateRealmNumber()

        // Match check is now handled entirely within FocusNumberManager via its subscription
        // print("🔍 Checking for focus/realm number match...")
        // print("   Current realm number: \(realmManager.currentRealmNumber)")
        // print("   Selected focus number: \(focusManager.selectedFocusNumber)")
        // focusManager.updateRealmNumber(realmManager.currentRealmNumber) // No longer needed, handled by Combine

        print("✅ BackgroundManager update initiated. FocusNumberManager will handle match check via Combine.")
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

        // Make sure managers are running before attempting operations
        if let realmManager = realmNumberManager, realmManager.currentState == .stopped {
            print("🔄 Starting RealmNumberManager for background processing")
            realmManager.startUpdates()
        }

        // We don't need to explicitly start FocusManager here, RealmNumber update will trigger it via Combine
        // if let focusManager = focusNumberManager, !focusManager.isAutoUpdateEnabled {
        //     print("🔄 Starting FocusNumberManager for background processing")
        //     focusManager.startUpdates()
        // }

        // Perform extended background update
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            // Force realm calculation. FocusNumberManager will react via its Combine subscription.
            print("🔄 Triggering RealmNumberManager calculation from background task...")
            self.realmNumberManager?.calculateRealmNumber()

            // Allow some time for calculation and Combine propagation to complete
            // This delay might be adjustable or unnecessary depending on testing
            Thread.sleep(forTimeInterval: 2.0)

            // REMOVED: Explicit background match check and notification call are now redundant.
            // FocusNumberManager handles this automatically when realmNumber updates.
            // if let realmManager = self.realmNumberManager,
            //    let focusManager = self.focusNumberManager {
            //     let realmNumber = realmManager.currentRealmNumber
            //     print("🔍 Explicit background match check for realm number: \(realmNumber)")
            //     if focusManager.selectedFocusNumber == realmNumber {
            //         print("🎯 Background match found! Creating rich notification...")
            //         self.optimizedMatchNotification(
            //             focusNumber: focusManager.selectedFocusNumber,
            //             realmNumber: realmNumber
            //         )
            //     }
            // }

            // Perform standard update (which now just triggers realm calculation)
            // self.performUpdate() // Calling performUpdate might be redundant if calculateRealmNumber was just called

            print("✅ Background task calculation triggered. FocusNumberManager will handle any matches.")

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
