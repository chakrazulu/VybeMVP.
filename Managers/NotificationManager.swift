/**
 * Filename: NotificationManager.swift
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
        
        // Set messaging delegate
        Messaging.messaging().delegate = self
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
        print("🔥🔥🔥 FIREBASE FCM TOKEN RECEIVED 🔥🔥🔥")
        if let token = fcmToken {
            print("📱 FCM Token: \(token)")
            setFCMToken(token)
        } else {
            print("⚠️ FCM Token is nil")
        }
    }
} 
