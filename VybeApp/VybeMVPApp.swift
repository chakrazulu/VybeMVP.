import SwiftUI
import os.log
import BackgroundTasks
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    var realmNumberManager: RealmNumberManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // CONFIGURE FIREBASE HERE - This is the most reliable place
        FirebaseApp.configure()
        // Log after configuration to confirm
        print("🔥 Firebase configured in AppDelegate didFinishLaunchingWithOptions")

        // Register background task handler early in app lifecycle
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.infinitiesinn.vybe.backgroundUpdate",
            using: nil) { task in
                BackgroundManager.shared.handleBackgroundTask(task as! BGAppRefreshTask)
            }
        
        // Register background tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.infinitiesinn.vybe.heartrate-update", using: nil) { task in
            self.handleHeartRateUpdate(task: task as! BGAppRefreshTask)
        }
        
        // Set delegate for notification handling
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("❌ Error requesting notification permissions: \(error.localizedDescription)")
                } else if granted {
                    print("✅ Notification permissions granted.")
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications() // Register for remote notifications
                    }
                } else {
                    print("🟠 Notification permissions denied.")
                }
            }
        )
        
        return true
    }
    
    // MARK: - APNS Token Handling
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let tokenString = tokenParts.joined()
        print("ℹ️ APNS device token received: \(tokenString)") // Log the token string
        Messaging.messaging().apnsToken = deviceToken // Pass token to Firebase
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    private func handleHeartRateUpdate(task: BGAppRefreshTask) {
        // Schedule the next background task
        scheduleNextUpdate()
        
        // Create a task to update heart rate
        task.expirationHandler = {
            // Handle task expiration
            print("⚠️ Background task expired")
        }
        
        // Perform heart rate update
        Task {
            _ = await HealthKitManager.shared.fetchInitialHeartRate()
            task.setTaskCompleted(success: true)
        }
    }
    
    private func scheduleNextUpdate() {
        let request = BGAppRefreshTaskRequest(identifier: "com.infinitiesinn.vybe.heartrate-update")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // Schedule next update in 1 minute
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("📅 Next background update scheduled")
        } catch {
            print("❌ Could not schedule next update: \(error)")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle incoming notification messages while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Customize this print statement for better debugging if needed
        print("🔔 Foreground Notification Received: \(userInfo)")
        
        // Let the system handle the notification (display alert, play sound, update badge)
        // You can customize this based on your app's needs, e.g., show only a badge or a custom in-app alert.
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge]) // Modern way
        } else {
            // Fallback on earlier versions
            completionHandler([.alert, .sound, .badge])
        }
    }

    // Handle user tapping on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 Notification Tapped: UserInfo - \(userInfo)")
        
        // Here you would typically process the notification payload.
        // For example, extract data from userInfo and navigate to a specific view
        // or trigger some action.
        // e.g., NotificationManager.shared.handleNotificationTap(userInfo: userInfo)

        completionHandler()
    }
}

@main
struct VybeMVPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var realmNumberManager = RealmNumberManager()
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    @StateObject private var journalManager = JournalManager()
    @StateObject private var backgroundManager = BackgroundManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    @StateObject private var signInViewModel = SignInViewModel()
    
    @State private var hasCompletedOnboarding: Bool = false
    private let onboardingCompletedKey = "hasCompletedOnboarding"

    private static let appLoggerObject = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "VybeMVPAppLogic")
    
    init() {
        os_log(.info, log: VybeMVPApp.appLoggerObject, "🚀 VybeMVPApp: INIT CALLED - VERSION_WITH_OS_LOGS_NOV_19_D")
        // Firebase is now configured in AppDelegate
        // print("🔥 Firebase configured") // This print might now be misleading here, better in AppDelegate
        let messageManager = NumerologyMessageManager.shared
        messageManager.preloadMessages()
        #if DEBUG
        UserDefaults.standard.set(false, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        #endif
        configureAppearance()
        os_log(.info, log: VybeMVPApp.appLoggerObject, "🚀 VybeMVPApp: INIT COMPLETED - VERSION_WITH_OS_LOGS_NOV_19_D")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if signInViewModel.isSignedIn {
                    if hasCompletedOnboarding {
                        ContentView()
                            .environmentObject(realmNumberManager)
                            .environmentObject(journalManager)
                            .environmentObject(focusNumberManager)
                            .environmentObject(backgroundManager)
                            .environmentObject(healthKitManager)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(signInViewModel)
                            .environmentObject(notificationManager)
                            .onAppear {
                                os_log(.debug, log: VybeMVPApp.appLoggerObject, "CONTENT_VIEW: .onAppear - VERSION_WITH_OS_LOGS_NOV_19_D")
                                if appDelegate.realmNumberManager == nil {
                                    appDelegate.realmNumberManager = self.realmNumberManager
                                    os_log(.info, log: VybeMVPApp.appLoggerObject, "🔗 AppDelegate linked to RealmNumberManager.")
                                    os_log(.info, log: VybeMVPApp.appLoggerObject, "▶️ Starting RealmNumberManager...")
                                    realmNumberManager.startUpdates()
                                }
                                backgroundManager.setManagers(realm: realmNumberManager, focus: focusNumberManager)
                                backgroundManager.scheduleBackgroundTask()
                                if healthKitManager.authorizationStatus == .sharingAuthorized {
                                    healthKitManager.startHeartRateMonitoring()
                                }
                            }
                    } else {
                        OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                            .environmentObject(signInViewModel)
                            .environmentObject(journalManager)
                            .environmentObject(focusNumberManager)
                    }
                } else {
                    SignInView(isSignedIn: $signInViewModel.isSignedIn)
                        .environmentObject(signInViewModel)
                }
            }
            .onAppear { 
                os_log(.debug, log: VybeMVPApp.appLoggerObject, "ROOT_GROUP: .onAppear CALLED - VERSION_WITH_OS_LOGS_NOV_19_D")
                signInViewModel.checkSignInStatus()
                
                if signInViewModel.isSignedIn, let userID = signInViewModel.userID {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "ROOT_GROUP.onAppear: User WAS ALREADY SIGNED IN (userID: \(userID)), Onboarding: \(self.hasCompletedOnboarding). Kicking off Firestore check.")
                    checkOnboardingStatusInFirestore(for: userID, source: "onAppear_V.OSL_NOV_19_D")
                } else {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "ROOT_GROUP.onAppear: User was NOT signed in. Onboarding false.")
                    if self.hasCompletedOnboarding != false {
                         self.hasCompletedOnboarding = false
                    }
                }
            }
            .onChange(of: signInViewModel.isSignedIn) { oldValue, newValue in
                os_log(.debug, log: VybeMVPApp.appLoggerObject, "SIGN_IN_STATUS_CHANGED: Old=\(oldValue), New=\(newValue) - V.OSL_NOV_19_D")
                if newValue {
                    if let userID = signInViewModel.userID {
                        os_log(.info, log: VybeMVPApp.appLoggerObject, "SIGN_IN_STATUS_CHANGED: User JUST signed IN (userID: \(userID)), Onboarding: \(self.hasCompletedOnboarding). Kicking off Firestore check.")
                        checkOnboardingStatusInFirestore(for: userID, source: "onChangeSignIn_V.OSL_NOV_19_D")
                    } else {
                        os_log(.error, log: VybeMVPApp.appLoggerObject, "SIGN_IN_STATUS_CHANGED: User signed in, but userID nil! Onboarding false.")
                        if self.hasCompletedOnboarding != false {
                             self.hasCompletedOnboarding = false
                        }
                    }
                } else {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "SIGN_IN_STATUS_CHANGED: User JUST signed OUT. Resetting UI onboarding state false.")
                    if self.hasCompletedOnboarding != false {
                        self.hasCompletedOnboarding = false
                    }
                }
            }
            .onChange(of: hasCompletedOnboarding) { oldValue, newValue in 
                os_log(.debug, log: VybeMVPApp.appLoggerObject, "ONBOARDING_STATE_CHANGED: Old=\(oldValue), New=\(newValue) - V.OSL_NOV_19_D")
                if signInViewModel.isSignedIn, let userID = signInViewModel.userID {
                    let key = onboardingCompletedKey + userID
                    UserDefaults.standard.set(newValue, forKey: key)
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "ONBOARDING_STATE_CHANGED: Cached to UserDefaults for user \(userID): \(newValue)")
                } else {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "ONBOARDING_STATE_CHANGED: User not signed in or userID nil. Not caching. (isSignedIn: \(self.signInViewModel.isSignedIn))")
                }
            }
        }
    }
    
    private func checkOnboardingStatusInFirestore(for userID: String, source: String) {
        os_log(.debug, log: VybeMVPApp.appLoggerObject, "FIRESTORE_CHECK (Called by \(source)): Checking profile for userID: \(userID) - V.OSL_NOV_19_D")
        UserProfileService.shared.profileExists(for: userID) { [self] existsInFirestore, error in
            DispatchQueue.main.async {
                if let error = error {
                    os_log(.error, log: VybeMVPApp.appLoggerObject, "FIRESTORE_CHECK (Callback for \(userID)): Firestore .profileExists FAILED! Error: \(error.localizedDescription). Fallback to UserDefaults.")
                    let key = self.onboardingCompletedKey + userID
                    let fallbackStatus = UserDefaults.standard.bool(forKey: key)
                    os_log(.default, log: VybeMVPApp.appLoggerObject, "FIRESTORE_CHECK (Callback for \(userID)): Using UserDefaults fallback status: \(fallbackStatus)")
                    if self.hasCompletedOnboarding != fallbackStatus {
                        self.hasCompletedOnboarding = fallbackStatus
                    }
                    // If fallback says onboarding is complete, attempt to load profile for AIInsightManager
                    if fallbackStatus {
                        fetchProfileAndConfigureInsightManager(for: userID, source: "fallback_UserDefaults")
                    }
                    return
                }

                if existsInFirestore {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "FIRESTORE_CHECK (Callback for \(userID)): Profile DOES EXIST in Firestore. Onboarding TRUE.")
                    if self.hasCompletedOnboarding != true {
                        self.hasCompletedOnboarding = true
                    }
                    // ✨ New: Fetch the full profile and configure AIInsightManager
                    fetchProfileAndConfigureInsightManager(for: userID, source: "firestore_profileExists")
                } else {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "FIRESTORE_CHECK (Callback for \(userID)): Profile DOES NOT EXIST in Firestore. Onboarding FALSE.")
                    if self.hasCompletedOnboarding != false {
                        self.hasCompletedOnboarding = false
                    }
                    // Ensure insight is cleared if onboarding is false
                    AIInsightManager.shared.clearInsight()
                }
            }
        }
    }

    // ✨ New helper function to fetch profile and configure AIInsightManager
    private func fetchProfileAndConfigureInsightManager(for userID: String, source: String) {
        os_log(.debug, log: VybeMVPApp.appLoggerObject, "FETCH_PROFILE_FOR_AI (Called by \(source)): Fetching profile for userID: \(userID) to configure AIInsightManager.")
        UserProfileService.shared.fetchUserProfile(for: userID) { profile, fetchError in 
            DispatchQueue.main.async {
                if let fetchError = fetchError {
                    os_log(.error, log: VybeMVPApp.appLoggerObject, "FETCH_PROFILE_FOR_AI (Callback for \(userID)): Failed to fetch UserProfile: \(fetchError.localizedDescription). AIInsightManager will not be configured with fresh data.")
                    // Optionally, clear insight if profile fetch fails critically
                    // AIInsightManager.shared.clearInsight()
                    return
                }
                
                if let fetchedProfile = profile {
                    os_log(.info, log: VybeMVPApp.appLoggerObject, "FETCH_PROFILE_FOR_AI (Callback for \(userID)): UserProfile fetched successfully. Configuring AIInsightManager.")
                    AIInsightManager.shared.configureAndRefreshInsight(for: fetchedProfile)
                    // ✨ New: Cache the fetched profile to UserDefaults
                    UserProfileService.shared.cacheUserProfileToUserDefaults(fetchedProfile)
                } else {
                    os_log(.error, log: VybeMVPApp.appLoggerObject, "FETCH_PROFILE_FOR_AI (Callback for \(userID)): UserProfile fetch returned nil but no error. AIInsightManager will not be configured.")
                    // Optionally, clear insight
                    // AIInsightManager.shared.clearInsight()
                }
            }
        }
    }

    private func configureAppearance() {
        os_log(.info, log: VybeMVPApp.appLoggerObject, "🎨 VybeMVPApp: configureAppearance called - V.OSL_NOV_19_D")
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
} 
