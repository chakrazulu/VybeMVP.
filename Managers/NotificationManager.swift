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

class NotificationManager: NSObject, ObservableObject {
    /// Shared singleton instance
    static let shared = NotificationManager()
    
    /// Published property to track notification authorization status
    @Published var notificationsAuthorized: Bool = false
    
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
    
    /// Handle a received push notification
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
        default:
            print("ℹ️ Unhandled notification type: \(type)")
        }
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
        completionHandler([.banner, .sound, .badge])
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
