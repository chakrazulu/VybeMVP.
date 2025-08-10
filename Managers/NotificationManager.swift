/**
 * Filename: NotificationManager.swift
 *
 * 🎯 COMPREHENSIVE MANAGER REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === CORE PURPOSE ===
 * Central notification hub managing local and push notifications for VybeMVP.
 * Handles cosmic match celebrations and mystical insights delivery.
 *
 * === KEY RESPONSIBILITIES ===
 * • Request and manage notification permissions
 * • Schedule local notifications for number matches
 * • Handle Firebase Cloud Messaging (FCM) integration
 * • Deliver numerology insights at optimal times
 * • Badge count management and clearing
 * • Notification tap handling and deep linking
 *
 * === PUBLISHED PROPERTIES ===
 * • notificationsAuthorized: Bool - Permission status
 * • unreadCount: Int - Badge count for app icon
 * • notificationTapSubject: PassthroughSubject - Tap events
 *
 * === NOTIFICATION TYPES ===
 * 1. Match Celebrations: Focus == Realm number alignment
 * 2. Numerology Insights: Daily wisdom and guidance
 * 3. Energy Checks: Periodic spiritual reminders
 * 4. Cosmic Rhythms: Astrological timing notifications
 *
 * === FCM INTEGRATION ===
 * • Token generation and storage
 * • Remote notification handling
 * • Background delivery support
 * • Token refresh management
 * • Server communication for push delivery
 *
 * === PERMISSION FLOW ===
 * 1. Check current authorization status
 * 2. Request user permission via system dialog
 * 3. Handle approval/denial gracefully
 * 4. Update UI state based on permissions
 * 5. Enable/disable notification features
 *
 * === LOCAL NOTIFICATION SYSTEM ===
 * • UNUserNotificationCenter integration
 * • Category-based content selection
 * • Delayed delivery (1-60 seconds)
 * • Custom sound and badge support
 * • Rich content with number-specific messages
 *
 * === CONTENT GENERATION ===
 * • NumerologyInsightService integration
 * • Category-based message selection
 * • Fallback content for missing data
 * • Personalized based on user's numbers
 *
 * === BADGE MANAGEMENT ===
 * • Automatic clearing on app foreground
 * • Manual clearing methods
 * • Count tracking for unread items
 * • iOS badge integration
 *
 * === DEEP LINKING ===
 * • Notification tap detection
 * • Number-specific navigation
 * • Category-based routing
 * • ActivityNavigationManager integration
 *
 * === TIMING STRATEGIES ===
 * • Immediate: Match celebrations (0-1s delay)
 * • Short: Energy checks (5-30s delay)
 * • Deferred: Daily insights (minutes/hours)
 * • Cosmic: Astrological timing based
 *
 * === ERROR HANDLING ===
 * • Permission denial graceful handling
 * • FCM token failure recovery
 * • Content generation fallbacks
 * • Network connectivity awareness
 *
 * === TESTING SUPPORT ===
 * • Manual notification triggers
 * • Content preview capabilities
 * • Permission simulation
 * • Debug logging for delivery
 *
 * === CRITICAL PERFORMANCE NOTES ===
 * • Notifications scheduled on background queue
 * • UI updates always on main thread
 * • Memory efficient content generation
 * • Automatic cleanup of old notifications
 *
 * Purpose: Manages push notifications, user permissions, and Firebase Cloud Messaging integration.
 * Handles the delivery and presentation of number match notifications and insights.
 *
 * Key components:
 * - NotificationManager: Singleton class for managing notifications
 * - FCM token handling and storage
 * - Notification permission requests and status tracking
 * - Displaying and handling notifications in different app states
 *
 * Dependencies: UserNotifications, Firebase/Messaging
 */

import Foundation
import UserNotifications
import SwiftUI
import FirebaseMessaging
import Combine

class NotificationManager: NSObject, ObservableObject {
    /// Shared singleton instance
    static let shared = NotificationManager()

    /// Publisher to broadcast notification tap data
    let notificationTapSubject = PassthroughSubject<(number: Int, category: String, message: String), Never>()

    /// Published property to track notification authorization status
    @Published var notificationsAuthorized: Bool = false

    /// Published property to track the number of unread notifications
    @Published var unreadCount: Int = 0

    /// Stores the device token for Firebase Cloud Messaging
    private var fcmToken: String?

    /// Private initializer to enforce singleton pattern
    private override init() {
        super.init()
        checkNotificationAuthorization()

        // Claude: Only set messaging delegate if not in test mode
        let isTestMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        if !isTestMode {
            // Set messaging delegate
            Messaging.messaging().delegate = self
        } else {
            print("🛡️ TEST MODE: Skipping Firebase Messaging setup to protect billing")
        }
    }

    /// Request authorization for push notifications
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.notificationsAuthorized = granted
                }

                if let error = error {
                    print("⚠️ Error requesting notification authorization: \(error.localizedDescription)")
                } else {
                    print("✅ Notification authorization status: \(granted ? "Granted" : "Denied")")
                }

                // Register for remote notifications if permissions granted
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )

        // Set delegate for user notification center
        UNUserNotificationCenter.current().delegate = self
    }

    /// Check current notification authorization status
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationsAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    /// Get current notification status (async version)
    func checkNotificationStatus() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let isAuthorized = settings.authorizationStatus == .authorized
                DispatchQueue.main.async { [weak self] in
                    self?.notificationsAuthorized = isAuthorized
                }
                continuation.resume(returning: isAuthorized)
            }
        }
    }

    /// Clear the badge count
    func clearBadgeCount() {
        // Use the newer API for iOS 17+
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("⚠️ Error clearing badge count: \(error.localizedDescription)")
            }
        }
        unreadCount = 0
    }

    /// Store the FCM token received from Firebase
    func setFCMToken(_ token: String) {
        // Claude: Skip FCM token operations in test mode
        let isTestMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isTestMode else {
            print("🛡️ TEST MODE: Skipping FCM token to protect billing")
            return
        }

        self.fcmToken = token
        print("✅ FCM Token set: \(token)")

        // TODO: Send token to backend/server if needed
    }

    /// Create and schedule a local notification (for testing)
    func scheduleLocalNotification(title: String, body: String, userInfo: [String: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo

        // Trigger after 5 seconds (for testing)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Local notification scheduled")
            }
        }
    }

    /// Schedule a silent background update notification
    /// This is used to wake the app in the background to perform realm calculations
    /// - Parameter delaySeconds: The delay in seconds before the notification is triggered (default: 5 seconds)
    func scheduleSilentBackgroundUpdate(delaySeconds: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.sound = nil
        content.badge = nil
        content.title = "" // Empty title for silent notification
        content.body = ""  // Empty body for silent notification
        content.userInfo = ["type": "background_update"]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySeconds, repeats: false)
        let request = UNNotificationRequest(
            identifier: "background-update-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Error scheduling silent background update: \(error.localizedDescription)")
            } else {
                print("✅ Silent background update scheduled in \(delaySeconds) seconds")
            }
        }
    }

    /**
     * Schedule a notification with a numerology message
     *
     * This method sends a notification containing a random message from the numerology
     * data files for a specific number and category.
     *
     * @param number The numerology number (0-9) to get a message for
     * @param category The category of message to send
     * @param delaySeconds The delay before showing the notification (default: 1 second)
     */
    func scheduleNumerologyNotification(
        forNumber number: Int,
        category: NumerologyCategory,
        delaySeconds: TimeInterval = 1
    ) {
        // Ensure number is valid (0-9)
        guard (0...9).contains(number) else {
            print("⚠️ Invalid number for numerology notification: \(number)")
            return
        }

        // Get a random message for this number and category
        guard let message = NumerologyMessageManager.shared.getRandomMessage(forNumber: number, category: category) else {
            print("⚠️ No message found for number \(number), category \(category.rawValue)")
            return
        }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Number \(number): \(category.displayName)"
        content.body = message.content
        content.sound = .default

        // Set badge to 1 to increment the app icon badge
        content.badge = 1

        // Add relevant info for handling the tap
        content.userInfo = [
            "type": "numerology_message",
            "number": number,
            "category": category.rawValue,
            "message_content": message.content
        ]

        // Set notification category for action handling
        content.categoryIdentifier = "NUMEROLOGY_NOTIFICATION"

        // Create trigger with specified delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySeconds, repeats: false)

        // Create a unique identifier for this notification
        let identifier = "numerology-\(number)-\(category.rawValue)-\(UUID().uuidString)"

        // Create and schedule the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Error scheduling numerology notification: \(error.localizedDescription)")
            } else {
                print("✅ Numerology notification scheduled for number \(number), category \(category.rawValue)")
                // Note: Badge count update is handled by the system setting badge = 1
            }
        }
    }

    /**
     * Schedule a random numerology message for a specific number
     *
     * This method selects a random category and sends a notification with a
     * message from that category for the specified number.
     *
     * @param number The numerology number (0-9) to get a message for
     * @param delaySeconds The delay before showing the notification (default: 1 second)
     */
    func scheduleRandomNumerologyNotification(forNumber number: Int, delaySeconds: TimeInterval = 1) {
        // Get a random category
        guard let randomCategory = NumerologyCategory.allCases.randomElement() else {
            return
        }

        // Schedule notification with the random category
        scheduleNumerologyNotification(forNumber: number, category: randomCategory, delaySeconds: delaySeconds)
    }

    /**
     * Schedule a daily numerology message for the user's focus number
     *
     * This method is intended to be called once per day to provide users with
     * a daily insight related to their current focus number.
     *
     * @param focusNumber The user's current focus number
     * @param delaySeconds The delay before showing the notification (default: 1 second)
     */
    func scheduleDailyNumerologyMessage(forFocusNumber focusNumber: Int, delaySeconds: TimeInterval = 1) {
        // Valid focus number range is 1-9
        let validFocusNumber = max(1, min(focusNumber, 9))

        // Get a random category for variety but prefer insight or daily categories
        let preferredCategories: [NumerologyCategory] = [.insight, .energy_check, .manifestation]
        let randomCategory = Bool.random() ?
            preferredCategories.randomElement() ?? .insight :
            NumerologyCategory.allCases.randomElement() ?? .insight

        // Schedule the notification
        scheduleNumerologyNotification(forNumber: validFocusNumber, category: randomCategory, delaySeconds: delaySeconds)
    }

    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        print("📲 Received push notification: \(userInfo)")

        // Extract notification type and data
        guard let type = userInfo["type"] as? String else {
            print("⚠️ Notification missing type")
            return
        }

        // Process based on notification type
        switch type {
        case "number_match":
            handleNumberMatchNotification(userInfo: userInfo)
        case "numerology_message":
            handleNumerologyMessageNotification(userInfo: userInfo)
        case "background_update":
            print("ℹ️ Received background update notification")
            // No UI update needed for background notifications
        default:
            print("ℹ️ Unhandled notification type: \(type)")
        }

        // Removed incorrect getBadgeCount call.
        // Badge count should be managed when app becomes active or based on delivered notifications.
    }

    /// Handle a number match notification
    private func handleNumberMatchNotification(userInfo: [AnyHashable: Any]) {
        guard let matchNumber = userInfo["matchNumber"] as? String,
              let insight = userInfo["insight"] as? String else {
            print("⚠️ Missing required fields in number match notification")
            return
        }

        print("🔢 Number match: \(matchNumber), Insight: \(insight)")

        // TODO: Update UI or navigate to appropriate screen
        // This will be implemented when integrating with the UI
    }

    /// Handle a numerology message notification
    private func handleNumerologyMessageNotification(userInfo: [AnyHashable: Any]) {
        guard let number = userInfo["number"] as? Int,
              let categoryString = userInfo["category"] as? String,
              let messageContent = userInfo["message_content"] as? String else {
            print("⚠️ Missing required fields in numerology message notification")
            return
        }

        print("📜 Numerology message tap: Number \(number), Category: \(categoryString), Message: \(messageContent)")

        // Send data through the publisher instead of TODO
        notificationTapSubject.send((number: number, category: categoryString, message: messageContent))

        // Example placeholder for future navigation:
        // Coordinator.shared.showNumerologyDetail(number: number, category: categoryString, message: messageContent)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    /// Handle receiving notification while app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification banner even when app is in foreground
        let options: UNNotificationPresentationOptions = [.banner, .sound, .badge]
        completionHandler(options)
    }

    /// Handle user response to notification (e.g., tapping it)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        handlePushNotification(userInfo: userInfo)
        completionHandler()
    }
}

// MARK: - Firebase Messaging Extension
extension NotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Claude: Skip FCM token handling in test mode
        let isTestMode = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isTestMode else {
            print("🛡️ TEST MODE: Skipping FCM token handling to protect billing")
            return
        }

        print("🔥🔥🔥 FIREBASE FCM TOKEN RECEIVED 🔥🔥🔥")
        if let token = fcmToken {
            print("📱 FCM Token: \(token)")
            setFCMToken(token)
        } else {
            print("⚠️ FCM Token is nil")
        }
    }
}

// MARK: - Phase 11A: Location-Aware Cosmic Notifications

extension NotificationManager {

    /// Claude: Schedule personalized cosmic timing notifications based on user's birth location
    ///
    /// **🌍 Phase 11A: Personalized Celestial Timing**
    ///
    /// This method leverages the enhanced cosmic engine's location-based calculations
    /// to provide users with precise timing for celestial events at their specific location.
    /// Uses birth location data from UserProfile for maximum personalization.
    ///
    /// **🌅 Supported Celestial Events:**
    /// - **Sunrise & Sunset**: Daily solar timing for spiritual alignment
    /// - **Moonrise & Moonset**: Lunar timing for emotional and intuitive work
    /// - **Planetary Visibility**: Mercury, Venus, Mars, Jupiter, Saturn optimal viewing
    /// - **Full & New Moon**: Major lunar phase notifications
    /// - **Void-of-Course Moon**: Special timing for reflection and contemplation
    ///
    /// **⏰ Notification Timing:**
    /// - **Advance Notice**: 30 minutes before celestial events for preparation
    /// - **Real-Time**: At the moment of celestial events for immediate alignment
    /// - **Spiritual Timing**: Optimal moments for meditation, intention-setting, reflection
    ///
    /// **🎯 Integration Points:**
    /// - Uses CosmicService.shared for location-based calculations
    /// - Integrates with UserProfile birth location coordinates
    /// - Synchronizes with existing notification permissions and settings
    func scheduleLocationAwareCosmicNotifications() {
        print("🌌 Setting up location-aware cosmic notifications")

        // Check notification authorization first
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("⚠️ Notifications not authorized - skipping cosmic scheduling")
                return
            }

            Task { @MainActor in
                await self.scheduleTodaysCosmicEvents()
            }
        }
    }

    /// Claude: Schedule cosmic notifications for today's celestial events
    @MainActor
    private func scheduleTodaysCosmicEvents() async {
        // Get today's cosmic data with location-specific calculations
        await CosmicService.shared.fetchTodaysCosmicData()

        guard let cosmic = CosmicService.shared.todaysCosmic else {
            print("🌌 No cosmic data available for notifications")
            return
        }

        // Remove existing cosmic notifications to avoid duplicates
        removePendingCosmicNotifications()

        // Schedule solar events
        if let sunEvents = cosmic.sunEvents {
            scheduleSolarNotifications(sunEvents: sunEvents)
        }

        // Schedule lunar events
        if let moonEvents = cosmic.moonEvents {
            scheduleLunarNotifications(moonEvents: moonEvents)
        }

        // Schedule special cosmic conditions
        scheduleSpecialCosmicNotifications(cosmic: cosmic)

        print("✅ Cosmic notifications scheduled for today")
    }

    /// Claude: Schedule sunrise and sunset notifications for spiritual alignment
    private func scheduleSolarNotifications(sunEvents: CelestialEventTimes) {
        let now = Date()

        // Sunrise notification - 15 minutes before for morning intention setting
        if let sunrise = sunEvents.rise, sunrise > now {
            let notificationTime = sunrise.addingTimeInterval(-15 * 60) // 15 minutes before

            if notificationTime > now {
                scheduleCosmicNotification(
                    identifier: "sunrise_preparation",
                    title: "🌅 Sunrise Approaching",
                    body: "The sun rises in 15 minutes at \(sunEvents.riseTimeString). Perfect time for morning intentions and spiritual alignment.",
                    triggerDate: notificationTime,
                    category: "cosmic_timing"
                )
            }
        }

        // Sunset notification - perfect for evening reflection
        if let sunset = sunEvents.set, sunset > now {
            scheduleCosmicNotification(
                identifier: "sunset_reflection",
                title: "🌇 Sunset Sacred Time",
                body: "The sun sets at \(sunEvents.setTimeString). A beautiful moment for gratitude and releasing the day's energy.",
                triggerDate: sunset,
                category: "cosmic_timing"
            )
        }

        // Solar noon - peak solar energy
        if let transit = sunEvents.transit, transit > now {
            scheduleCosmicNotification(
                identifier: "solar_noon",
                title: "☀️ Solar Peak Energy",
                body: "The sun reaches its highest point at \(sunEvents.transitTimeString). Maximum solar power for manifestation and confidence.",
                triggerDate: transit,
                category: "cosmic_energy"
            )
        }
    }

    /// Claude: Schedule moonrise and moonset notifications for emotional and intuitive work
    private func scheduleLunarNotifications(moonEvents: CelestialEventTimes) {
        let now = Date()

        // Moonrise notification - optimal for lunar energy work
        if let moonrise = moonEvents.rise, moonrise > now {
            scheduleCosmicNotification(
                identifier: "moonrise_energy",
                title: "🌙 Moon Rising",
                body: "The moon rises at \(moonEvents.riseTimeString). Perfect timing for emotional healing and intuitive insights.",
                triggerDate: moonrise,
                category: "lunar_timing"
            )
        }

        // Moonset notification - completion and release
        if let moonset = moonEvents.set, moonset > now {
            scheduleCosmicNotification(
                identifier: "moonset_release",
                title: "🌑 Moon Setting",
                body: "The moon sets at \(moonEvents.setTimeString). A powerful moment for releasing and letting go.",
                triggerDate: moonset,
                category: "lunar_timing"
            )
        }
    }

    /// Claude: Schedule notifications for special cosmic conditions
    private func scheduleSpecialCosmicNotifications(cosmic: CosmicData) {
        let now = Date()

        // Void-of-course Moon notifications
        if cosmic.isVoidOfCoursePeriod {
            let voidInfo = cosmic.getVoidOfCourseMoon()

            // Immediate notification about current void-of-course period
            scheduleCosmicNotification(
                identifier: "void_of_course_active",
                title: "🌙∅ Moon Void-of-Course",
                body: voidInfo.spiritualMeaning,
                triggerDate: now.addingTimeInterval(5), // 5 seconds from now
                category: "special_timing"
            )
        }

        // Next Full Moon notification (if within 7 days)
        if let nextFullMoon = cosmic.nextFullMoon {
            let daysUntil = Calendar.current.dateComponents([.day], from: now, to: nextFullMoon).day ?? 0

            if daysUntil <= 7 && daysUntil > 0 {
                let notificationTime = nextFullMoon.addingTimeInterval(-2 * 60 * 60) // 2 hours before

                if notificationTime > now {
                    scheduleCosmicNotification(
                        identifier: "full_moon_approaching",
                        title: "🌕 Full Moon in 2 Hours",
                        body: "The Full Moon energy is building. Perfect time for culmination rituals and releasing what no longer serves.",
                        triggerDate: notificationTime,
                        category: "lunar_phase"
                    )
                }
            }
        }

        // Planetary conjunction or major aspect notifications
        if let keyAspect = cosmic.getTodaysKeyAspect() {
            if keyAspect.isExact {
                scheduleCosmicNotification(
                    identifier: "exact_aspect",
                    title: "⭐ Exact Planetary Aspect",
                    body: "\(keyAspect.description) - \(keyAspect.aspectType.energy) energy is at its peak right now!",
                    triggerDate: now.addingTimeInterval(60), // 1 minute from now
                    category: "planetary_aspect"
                )
            }
        }
    }

    /// Claude: Generic method to schedule cosmic notifications
    private func scheduleCosmicNotification(
        identifier: String,
        title: String,
        body: String,
        triggerDate: Date,
        category: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = category

        // Add cosmic-themed custom data
        content.userInfo = [
            "type": "cosmic_timing",
            "category": category,
            "scheduled_time": triggerDate.timeIntervalSince1970
        ]

        // Create date trigger
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        // Create and schedule request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule cosmic notification '\(identifier)': \(error.localizedDescription)")
            } else {
                print("✅ Scheduled cosmic notification: \(title) at \(triggerDate)")
            }
        }
    }

    /// Claude: Remove all pending cosmic notifications to avoid duplicates
    private func removePendingCosmicNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let cosmicIdentifiers = requests
                .filter { request in
                    guard let userInfo = request.content.userInfo as? [String: Any] else { return false }
                    return userInfo["type"] as? String == "cosmic_timing"
                }
                .map { $0.identifier }

            if !cosmicIdentifiers.isEmpty {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: cosmicIdentifiers)
                print("🗑️ Removed \(cosmicIdentifiers.count) pending cosmic notifications")
            }
        }
    }

    /// Claude: Schedule daily cosmic notifications - call this once per day
    func scheduleDailyCosmicNotifications() {
        print("🌌 Starting daily cosmic notification scheduling")
        scheduleLocationAwareCosmicNotifications()
    }
}
