import UIKit
import BackgroundTasks
import UserNotifications
import FirebaseCore
import FirebaseMessaging
// Firebase imports will be added once the SDK is installed

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    private let backgroundManager = BackgroundManager.shared
    // private let realmNumberManager = RealmNumberManager() // REMOVED: Instance created in VybeMVPApp
    var realmNumberManager: RealmNumberManager! // ADDED: Property to hold shared instance
    private let focusNumberManager = FocusNumberManager.shared
    private let notificationManager = NotificationManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("\n🚀 Application launching...")

        // Firebase is now initialized in VybeMVPApp.swift at file scope
        // No need to initialize here

        // Set up Firebase Messaging
        Messaging.messaging().delegate = self

        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self

        // Register for remote notifications
        application.registerForRemoteNotifications()

        // Enable Firebase for background updates
        Messaging.messaging().isAutoInitEnabled = true

        // Print FCM token to console for testing
        Messaging.messaging().token { token, error in
            if let token = token {
                print("🔥 FCM Registration Token: \(token)")
                // Save token for later use if needed
                UserDefaults.standard.set(token, forKey: "FCMToken")
            } else if let error = error {
                print("🔥 Error fetching FCM token: \(error)")
            }
        }

        // Register background task
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.infinitiesinn.vybe.backgroundUpdate",
            using: nil
        ) { task in
            // Claude: DORMANT BUG FIX - Replace force cast with safe cast
            Task {
                guard let refreshTask = task as? BGAppRefreshTask else {
                    print("⚠️ Unexpected background task type received")
                    task.setTaskCompleted(success: false)
                    return
                }
                await self.backgroundManager.handleBackgroundTask(refreshTask)
            }
        }

        // Initialize managers
        Task {
            // Set up managers
            // backgroundManager.setManagers(realm: realmNumberManager, focus: focusNumberManager) // MOVED to ContentView.onAppear

            // Start updates
            // realmNumberManager.startUpdates() // REMOVED: Started in VybeMVPApp.init

            // Explicitly start heart rate monitoring
            // HealthKitManager.shared.startHeartRateMonitoring() // MOVED to ContentView.onAppear

            // Always start with a simulated heart rate for development -- REMOVED: Let's rely on real data or lack thereof

            // Start background updates
            backgroundManager.startMonitoring()

            print("✅ All managers initialized and started")
        }

        // Request notification permissions
        notificationManager.requestNotificationAuthorization()

        return true
    }

    // MARK: - Firebase Messaging Delegate

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase registration token refreshed: \(fcmToken ?? "nil")")

        // Store this token for sending notifications to this specific device
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")

            // You can also send this token to your server if needed
            // let dataDict: [String: String] = ["token": token]
            // NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }

    // MARK: - UNUserNotificationCenter Delegate

    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("📲 Received notification in foreground: \(userInfo)")

        // Show the notification in foreground with alert, badge, and sound
        completionHandler([.banner, .badge, .sound])
    }

    // Handle notification response when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("📲 User responded to notification: \(userInfo)")

        // Process the notification action
        notificationManager.handleNotificationResponse(response)

        completionHandler()
    }

    // MARK: - Remote Notifications

    /// Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 Device Token: \(token)")

        // Set APNs token on Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    /// Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("⚠️ Failed to register for remote notifications: \(error.localizedDescription)")
    }

    /// Called when a remote notification is received
    /// This handles both foreground and background notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("📲 Received remote notification: \(userInfo)")

        // Create a background task identifier to ensure completion
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // End the task if we run out of time
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
                completionHandler(.failed)
                print("⚠️ Background task for remote notification timed out")
            }
        }

        // Ensure insight manager is loaded early for background operation (preload for any notification path)
        let _ = NumberMatchInsightManager.shared.getAllInsights()

        // Check if this is a silent background update notification
        if let isSilent = userInfo["silent_update"] as? Bool, isSilent {
            print("🔄 Processing silent background update...")
            handleSilentUpdateNotification(userInfo: userInfo)

            // Complete background task
            if backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
            }

            completionHandler(.newData)
            return
        }

        // Handle match notifications directly (prioritize rich notifications)
        if let type = userInfo["type"] as? String, type == "number_match" {
            print("🎯 Processing match notification directly in AppDelegate...")

            if let matchNumberStr = userInfo["matchNumber"] as? String,
               let matchNumber = Int(matchNumberStr) {
                // Get the number insight
                let insightManager = NumberMatchInsightManager.shared
                let insight = insightManager.getInsight(for: matchNumber)

                // Create a rich notification
                let content = UNMutableNotificationContent()
                content.title = insight.title
                content.body = insight.summary
                content.sound = .default
                content.badge = 1
                content.categoryIdentifier = "MATCH_NOTIFICATION"

                // Include all the rich data
                content.userInfo = [
                    "type": "number_match",
                    "matchNumber": "\(matchNumber)",
                    "insight": insight.detailedInsight,
                    "sent_from": "app_delegate",
                    "timestamp": Date().timeIntervalSince1970
                ]

                // Schedule immediately
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: "match_notification_\(Date().timeIntervalSince1970)",
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule rich notification from AppDelegate: \(error.localizedDescription)")
                    } else {
                        print("✅ Rich notification scheduled successfully from AppDelegate")
                        print("📱 Title: \(content.title)")
                        print("📱 Body: \(content.body)")
                    }

                    // Complete background task
                    if backgroundTaskID != .invalid {
                        UIApplication.shared.endBackgroundTask(backgroundTaskID)
                        backgroundTaskID = .invalid
                    }

                    completionHandler(.newData)
                }
                return
            }
        }

        // Fall back to normal notification handling
        notificationManager.handlePushNotification(userInfo: userInfo)

        // Complete background task
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }

        // Notify system of completion
        completionHandler(.newData)
    }

    /// Handle silent background update notifications
    private func handleSilentUpdateNotification(userInfo: [AnyHashable: Any]) {
        print("🔄 Received silent background update notification")

        // Ensure the shared instance is available
        guard let realmManager = realmNumberManager else {
            print("❌ RealmNumberManager instance not available in AppDelegate for silent update")
            return
        }

        // Start the realm manager if needed (Use shared instance)
        if realmManager.currentState == .stopped {
            realmManager.startUpdates()
        }

        // Force an immediate realm number calculation (Use shared instance)
        realmManager.calculateRealmNumber()

        // Check for matches (Use shared instance)
        if let realmNumber = realmManager.currentRealmNumber {
            focusNumberManager.updateRealmNumber(realmNumber)
            print("🔍 Performing background match check for realm number: \(realmNumber)")
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\n📱 Application became active")
        Task {
            // Ensure updates are running
            backgroundManager.startActiveUpdates()
        }

        // Clear app badge when app becomes active
        UNUserNotificationCenter.current().setBadgeCount(0)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("\n📱 Application will resign active")
        // Keep updates running in background
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("\n📱 Application entered background")

        // Ensure the shared instance is available
        guard let realmManager = realmNumberManager else {
            print("❌ RealmNumberManager instance not available in AppDelegate for background entry")
            return
        }

        // Force re-initialization of insights to ensure they're fresh and available in background
        print("🧠 Force re-initializing insights for background notifications...")
        let insightManager = NumberMatchInsightManager.shared
        insightManager.reinitializeInsights()
        let insights = insightManager.getAllInsights()
        print("✅ Loaded \(insights.count) fresh insights for background use")

        // Register notification categories to support rich notifications
        let matchCategory = UNNotificationCategory(
            identifier: "MATCH_NOTIFICATION",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        UNUserNotificationCenter.current().setNotificationCategories([matchCategory])

        // Check for notification authorization
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 Notification settings when entering background:")
            print("   Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("   Alert Setting: \(settings.alertSetting.rawValue)")
            print("   Sound Setting: \(settings.soundSetting.rawValue)")
            print("   Badge Setting: \(settings.badgeSetting.rawValue)")
        }

        // Force a final realm calculation before going to background (Use shared instance)
        realmManager.calculateRealmNumber()

        // Schedule background task for periodic updates
        backgroundManager.scheduleBackgroundTask()

        // Schedule a silent notification for 15 minutes later to wake the app if needed
        notificationManager.scheduleSilentBackgroundUpdate(delaySeconds: 15 * 60)

        print("✅ Background tasks and silent notifications scheduled")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("\n📱 Application will terminate")
        // Perform cleanup if needed
    }
}
