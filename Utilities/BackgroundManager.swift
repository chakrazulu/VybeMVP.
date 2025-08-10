/*
 * ========================================
 * 🔄 BACKGROUND MANAGER - BACKGROUND TASK COORDINATION
 * ========================================
 *
 * CORE PURPOSE:
 * Manages background tasks, periodic updates, and system-level operations
 * for the Vybe app. Coordinates realm number calculations, match detection,
 * and notification permissions in the background.
 *
 * TECHNICAL ARCHITECTURE:
 * - NSObject subclass for system integration
 * - ObservableObject for SwiftUI state management
 * - Timer-based periodic updates
 * - Async/await for notification permissions
 * - Background task coordination
 *
 * BACKGROUND OPERATIONS:
 * 1. Realm Number Updates: Periodic calculation of user's realm number
 * 2. Match Detection: Continuous monitoring for cosmic matches
 * 3. Notification Management: Permission requests and setup
 * 4. System Integration: Background task lifecycle management
 *
 * INTEGRATION POINTS:
 * - RealmNumberManager: For realm number calculations
 * - FocusNumberManager: For match detection and verification
 * - NotificationManager: For permission and notification setup
 * - App lifecycle: Background task coordination
 *
 * TIMING & FREQUENCY:
 * - Update interval: Configurable timer-based updates
 * - Match checking: Integrated with realm number updates
 * - Notification setup: One-time permission request
 *
 * ERROR HANDLING:
 * - Graceful degradation for permission denials
 * - Timer invalidation and cleanup
 * - Comprehensive logging for debugging
 */

import Foundation
import UserNotifications

/**
 * BackgroundManager: Coordinates background operations and system-level tasks
 *
 * Manages periodic updates, match detection, and notification permissions
 * to ensure the app maintains spiritual awareness even when not actively used.
 */
class BackgroundManager: NSObject, ObservableObject {
    // ... existing code ...

    // MARK: - Public Methods

    /**
     * Starts background monitoring and updates
     *
     * Initiates the background task coordination including notification
     * permission requests and periodic updates for realm number calculations.
     */
    func startMonitoring() {
        Task {
            await registerForNotifications()
        }
        startActiveUpdates()
    }

    /**
     * Starts active periodic updates
     *
     * Initiates timer-based updates for realm number calculations and match detection.
     * Stops any existing updates before starting new ones to prevent conflicts.
     */
    func startActiveUpdates() {
        stopActiveUpdates()
        performUpdate()

        // Schedule timer for periodic updates
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.performUpdate()
        }
    }

    /**
     * Stops active periodic updates
     *
     * Invalidates the update timer and stops background calculations.
     * Called when the app becomes inactive or when updates are no longer needed.
     */
    func stopActiveUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    /**
     * Performs a single update cycle
     *
     * Executes realm number calculations and match detection.
     * Called periodically by the timer and can be called manually.
     */
    func performUpdate() {
        realmManager.startUpdates()
        realmManager.calculateRealmNumber()
        checkForMatches()
    }

    // MARK: - Private Methods

    /**
     * Checks for cosmic matches between realm and focus numbers
     *
     * Compares the current realm number with the user's focus number
     * and triggers match verification if a potential match is detected.
     */
    private func checkForMatches() {
        guard let realmNumber = realmManager.currentRealmNumber else { return }
        focusNumberManager.verifyAndSaveMatch(realmNumber: realmNumber) { success in
            if success {
                print("🎯 Match found!")
            }
        }
    }

    /**
     * Registers for notification permissions
     *
     * Requests notification permissions asynchronously and logs the result.
     * Called during app initialization to ensure notifications are available.
     */
    private func registerForNotifications() async {
        let granted = await requestNotificationPermissions()
        if granted {
            print("✅ Notification permissions granted")
        } else {
            print("❌ Notification permissions denied")
        }
    }

    /**
     * Requests notification permissions from the user
     *
     * Checks current notification settings and requests authorization
     * if not already granted. Returns true if permissions are available.
     *
     * @return True if notification permissions are granted, false otherwise
     */
    private func requestNotificationPermissions() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()

            guard settings.authorizationStatus != .authorized else {
                return true
            }

            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("❌ Error requesting notification permissions: \(error)")
            return false
        }
    }
}
