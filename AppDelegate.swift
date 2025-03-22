import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Check if Firebase is already initialized in VybeMVPApp.swift
        if FirebaseApp.app() == nil {
            print("Initializing Firebase from AppDelegate...")
            FirebaseApp.configure()
        } else {
            print("Firebase already initialized in VybeMVPApp.swift")
        }
        
        // Setup health monitoring and realm number generation
        setupHealthMonitoring()
        
        // Register for silent background notifications
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        // Set up Firebase Messaging
        Messaging.messaging().delegate = self
        
        return true
    }

    private func setupHealthMonitoring() {
        // Always disable simulation mode by default - we want real data
        print("❤️ Explicitly disabling heart rate simulation to prioritize real data")
        HealthKitManager.shared.setSimulationMode(enabled: false)
        
        // Start heart rate monitoring with reduced polling frequency
        HealthKitManager.shared.startHeartRateMonitoring()
        
        // Make a single attempt to get initial heart rate data - don't make multiple aggressive attempts
        // as this can drain battery quickly
        Task {
            print("❤️ Attempting to get real heart rate data...")
            
            let success = await HealthKitManager.shared.forceHeartRateUpdate()
            
            if success {
                print("✅ Successfully retrieved initial heart rate data")
            } else {
                print("⚠️ Could not retrieve initial heart rate data - will try again during normal monitoring")
                
                // Check if the user has explicitly enabled simulation in preferences
                let userWantsSimulation = UserDefaults.standard.bool(forKey: "HeartRateSimulationEnabled")
                
                if userWantsSimulation {
                    print("🔄 User has previously enabled simulation - respecting preference")
                    HealthKitManager.shared.setSimulationMode(enabled: true)
                } else {
                    print("❤️ Continuing with real heart rate monitoring despite no initial data")
                    // Keep simulation off - we'll keep trying for real data
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AppDelegate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification banner even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        NotificationManager.shared.handlePushNotification(userInfo: userInfo)
        completionHandler()
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // Save token for sending to server
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "FCMToken")
            print("✅ FCM Token saved: \(token)")
        }
    }
} 