import UIKit
import BackgroundTasks
import UserNotifications
import FirebaseCore
import FirebaseMessaging
// Firebase imports will be added once the SDK is installed

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    private let backgroundManager = BackgroundManager.shared
    private let realmNumberManager = RealmNumberManager()
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
            Task {
                await self.backgroundManager.handleBackgroundTask(task as! BGAppRefreshTask)
            }
        }
        
        // Initialize managers
        Task {
            // Set up managers
            backgroundManager.setManagers(realm: realmNumberManager, focus: focusNumberManager)
            
            // Start updates
            realmNumberManager.startUpdates()
            focusNumberManager.startUpdates()
            backgroundManager.startActiveUpdates()
            
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
        
        // Check if this is a silent background update notification
        if let isSilent = userInfo["silent_update"] as? Bool, isSilent {
            handleSilentUpdateNotification(userInfo: userInfo)
            completionHandler(.newData)
            return
        }
        
        // Handle the notification
        notificationManager.handlePushNotification(userInfo: userInfo)
        
        // Notify system of completion
        completionHandler(.newData)
    }
    
    /// Handle silent background update notifications
    private func handleSilentUpdateNotification(userInfo: [AnyHashable: Any]) {
        print("🔄 Received silent background update notification")
        
        // Start the realm and focus managers if needed
        if realmNumberManager.currentState == .stopped {
            realmNumberManager.startUpdates()
        }
        
        // Force an immediate realm number calculation
        realmNumberManager.calculateRealmNumber()
        
        // Check for matches
        if let realmNumber = realmNumberManager.currentRealmNumber {
            focusNumberManager.updateRealmNumber(realmNumber)
            print("🔍 Performing background match check for realm number: \(realmNumber)")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\n📱 Application became active")
        Task {
            // Ensure updates are running
            backgroundManager.startActiveUpdates()
            realmNumberManager.startUpdates()
            focusNumberManager.startUpdates()
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
        // Schedule background task
        backgroundManager.scheduleBackgroundTask()
        
        // Don't stop the realm manager when going to background
        // This allows it to continue running during background execution
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("\n📱 Application will terminate")
        // Perform cleanup if needed
    }
} 