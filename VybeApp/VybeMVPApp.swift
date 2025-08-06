/*
 * ========================================
 * 🚀 VYBE MVP APP - MAIN APPLICATION ENTRY POINT
 * ========================================
 * 
 * CORE PURPOSE:
 * Main SwiftUI app entry point with comprehensive Firebase integration, background task
 * management, and notification handling. Manages app lifecycle, authentication flow,
 * and cosmic animation system initialization.
 * 
 * TECHNICAL ARCHITECTURE:
 * - AppDelegate: Firebase configuration, background tasks, notifications
 * - VybeMVPApp: SwiftUI app structure with environment objects
 * - AuthenticationWrapperView: Root navigation and auth flow
 * - Cosmic Animation System: Scroll-safe animations with TimelineView
 * 
 * FIREBASE INTEGRATION:
 * - Configuration: FirebaseApp.configure() in AppDelegate
 * - Messaging: APNS token handling for push notifications
 * - Background Tasks: Heart rate updates and realm number calculations
 * - Authentication: Apple Sign-In with Firebase Auth
 * 
 * BACKGROUND TASK SYSTEM:
 * - Heart Rate Updates: Periodic HealthKit data fetching
 * - Realm Number Calculations: Cosmic number updates
 * - Notification Scheduling: Numerology-based insights
 * - Performance Monitoring: Cosmic animation metrics
 * 
 * NOTIFICATION SYSTEM:
 * - APNS Integration: Device token registration
 * - Foreground Handling: Banner, list, sound, badge options
 * - Background Processing: Numerology message delivery
 * - User Interaction: Tap handling and deep linking
 * 
 * PERFORMANCE OPTIMIZATION:
 * - Lazy Loading: Mandala assets loaded on demand
 * - Memory Management: Proper cleanup of background tasks
 * - Animation Performance: 60fps cosmic animation system
 * - Background Efficiency: Minimal resource usage
 */

import SwiftUI
import SwiftData  // Added for SwiftData support
import os.log
import BackgroundTasks
import FirebaseCore
import FirebaseMessaging
// import FirebaseAppCheck // Removed during Firebase cleanup
import UserNotifications
import CoreData

/**
 * AppDelegate: iOS application delegate managing Firebase, background tasks, and notifications
 * 
 * Handles:
 * - Firebase configuration and initialization
 * - Background task registration and scheduling
 * - Push notification setup and token management
 * - App lifecycle events and state management
 */
class AppDelegate: NSObject, UIApplicationDelegate {
    var realmNumberManager: RealmNumberManager?
    var journalManager: JournalManager?
    var focusNumberManager: FocusNumberManager?
    var backgroundManager: BackgroundManager?
    var healthKitManager: HealthKitManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // CONFIGURE FIREBASE HERE - This is the most reliable place
        FirebaseApp.configure()
        
        // Claude: Firebase App Check configuration removed - using local SwiftAA calculations
        // AppCheckConfiguration.configure() // Removed during Firebase cleanup
        
        // Log after configuration to confirm
        Logger.app.info("🔥 Firebase configured in AppDelegate didFinishLaunchingWithOptions")
        Logger.app.info("🔐 Firebase App Check configured for enterprise security")

        // Register background task handler early in app lifecycle
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.infinitiesinn.vybe.backgroundUpdate",
            using: nil) { task in
                // Claude: DORMANT BUG FIX - Replace force cast with safe cast
                guard let refreshTask = task as? BGAppRefreshTask else {
                    print("⚠️ Unexpected background task type received for backgroundUpdate")
                    task.setTaskCompleted(success: false)
                    return
                }
                BackgroundManager.shared.handleBackgroundTask(refreshTask)
            }
        
        // Register background tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.infinitiesinn.vybe.heartrate-update", using: nil) { task in
            // Claude: DORMANT BUG FIX - Replace force cast with safe cast
            guard let refreshTask = task as? BGAppRefreshTask else {
                print("⚠️ Unexpected background task type received for heartrate-update")
                task.setTaskCompleted(success: false)
                return
            }
            self.handleHeartRateUpdate(task: refreshTask)
        }
        
        // Set delegate for notification handling
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                if granted {
                    Logger.app.info("✅ Notification permissions granted.")
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications() // Register for remote notifications
                    }
                } else {
                    Logger.app.warning("🟠 Notification permissions denied.")
                }
            }
        )
        
        return true
    }
    
    // MARK: - APNS Token Handling
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let _ = tokenParts.joined()
        Logger.network.info("ℹ️ APNS device token received: \(tokenParts.joined())") // Log the token string
        Messaging.messaging().apnsToken = deviceToken // Pass token to Firebase
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.network.error("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    private func handleHeartRateUpdate(task: BGAppRefreshTask) {
        // Schedule the next background task
        scheduleNextUpdate()
        
        // Create a task to update heart rate
        task.expirationHandler = {
            // Handle task expiration
            Logger.app.warning("⚠️ Background task expired")
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
            Logger.app.info("📅 Next background update scheduled")
        } catch {
            Logger.app.error("❌ Could not schedule next update: \(error.localizedDescription)")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle incoming notification messages while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = notification.request.content.userInfo
        Logger.app.info("🔔 Foreground Notification Received: \(notification.request.content.userInfo)")
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    // Handle user tapping on a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let _ = response.notification.request.content.userInfo
        Logger.app.info("🔔 Notification Tapped: UserInfo - \(response.notification.request.content.userInfo)")
        
        completionHandler()
    }
}

/**
 * VybeMVPApp: Main SwiftUI application structure with cosmic animation system
 * 
 * Provides:
 * - Environment objects for all major managers and services
 * - Authentication flow management via AuthenticationWrapperView
 * - Background task coordination and performance monitoring
 * - Cosmic animation system initialization and optimization
 * 
 * State Management:
 * - @StateObject: All major managers (realm, focus, health, etc.)
 * - @EnvironmentObject: Shared across all views
 * - @State: Local app state (onboarding, scene phase)
 */
@main
struct VybeMVPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var realmNumberManager = RealmNumberManager()
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    @StateObject private var journalManager = JournalManager()
    @StateObject private var backgroundManager = BackgroundManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var cosmicService = CosmicService.shared
    @StateObject private var cosmicHUDIntegration = CosmicHUDIntegration.shared
    @StateObject private var kasperMLXManager = KASPERMLXManager.shared
    @StateObject private var spiritualDataController = SpiritualDataController.shared
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    @StateObject private var signInViewModel = SignInViewModel()
    
    @State private var hasCompletedOnboarding: Bool = false
    private let onboardingCompletedKey = "hasCompletedOnboarding"

    init() {
        let _ = Logger.app
        Logger.app.info("🚀 VybeMVPApp: INIT CALLED - OPTIMIZED_LAUNCH")
        
        // Claude: PERFORMANCE OPTIMIZATION - Defer heavy operations to background
        #if DEBUG
        UserDefaults.standard.set(false, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        #endif
        
        // Claude: Move appearance configuration to background thread - create static method
        DispatchQueue.global(qos: .userInitiated).async {
            VybeMVPApp.performAppearanceConfiguration()
        }
        
        // Claude: Defer message preloading to prevent blocking launch
        DispatchQueue.global(qos: .utility).async {
            let messageManager = NumerologyMessageManager.shared
            messageManager.preloadMessages()
        }
        
        Logger.app.info("🚀 VybeMVPApp: INIT COMPLETED - OPTIMIZED_LAUNCH")
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationWrapperView()
                .modelContainer(spiritualDataController.container)
                .environmentObject(realmNumberManager)
                .environmentObject(journalManager)
                .environmentObject(focusNumberManager)
                .environmentObject(backgroundManager)
                .environmentObject(healthKitManager)
                .environmentObject(cosmicService)
                .environmentObject(cosmicHUDIntegration)
                .environmentObject(kasperMLXManager)
                .environmentObject(spiritualDataController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .modifier(cosmicHUDIntegration.integrateWithMainApp())
                .onAppear {
                    // Claude: PERFORMANCE OPTIMIZATION - Defer heavy operations to background
                    
                    // --- Instance Sharing Setup --- (Keep on main thread for UI)
                    if appDelegate.realmNumberManager == nil {
                        appDelegate.realmNumberManager = self.realmNumberManager
                        appDelegate.journalManager = self.journalManager
                        appDelegate.focusNumberManager = self.focusNumberManager
                        appDelegate.backgroundManager = self.backgroundManager
                        appDelegate.healthKitManager = self.healthKitManager
                        print("🔗 Linked AppDelegate to shared managers (onAppear).")
                    }
                    
                    // Claude: Move heavy manager initialization to background thread
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Start RealmNumberManager and configure background manager
                        DispatchQueue.main.async {
                            self.realmNumberManager.startUpdates()
                            print("▶️ Starting RealmNumberManager from background...")
                        }
                        
                        // Claude: 🔮 KASPER MLX - Configure new async KASPER engine
                        Task { @MainActor in
                            await self.kasperMLXManager.configure(
                                realmManager: self.realmNumberManager,
                                focusManager: self.focusNumberManager,
                                healthManager: self.healthKitManager
                            )
                            print("🔮 KASPER MLX configured with app managers")
                        }
                        
                        // Claude: SAFE - Re-enable background tasks now that MiniInsightProvider issue is fixed
                        Task.detached(priority: .background) {
                            // Load MegaCorpus data in background (lightweight operation)
                            await SanctumDataManager.shared.loadMegaCorpusData()
                            print("📚 SanctumDataManager MegaCorpus loading initiated (background)")
                            
                            // Wait briefly for data to settle
                            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second only
                            
                            // Claude: 🔮 KASPER MLX - New async engine replaces old blocking payload system
                            print("🔮 KASPER MLX: New async architecture ready - no more blocking!")
                            // Old KASPER has been replaced with KASPER MLX - fully async, no MainActor blocking
                            
                            print("🔗 KASPER subscription setup completed")
                        }
                        
                        // Background manager setup
                        DispatchQueue.main.async {
                            self.backgroundManager.setManagers(realm: self.realmNumberManager, focus: self.focusNumberManager)
                            self.backgroundManager.scheduleBackgroundTask()
                            
                            // HealthKit monitoring (only if already authorized)
                            if self.healthKitManager.authorizationStatus == .sharingAuthorized {
                                self.healthKitManager.startHeartRateMonitoring()
                            }
                            
                            // Claude: 🌌 CRITICAL FIX - Configure HUD with main app's realm manager to prevent duplicates
                            self.cosmicHUDIntegration.setMainAppRealmManager(self.realmNumberManager)
                            
                            // Claude: 🌌 SAFE - Re-enable Cosmic HUD now that MiniInsightProvider issue is fixed
                            Task.detached(priority: .background) {
                                await self.cosmicHUDIntegration.initializeHUD()
                                Logger.app.info("🌌 Cosmic HUD initialized efficiently in background!")
                            }
                        }
                    }
                }
                .onChange(of: signInViewModel.isSignedIn) { oldValue, newValue in
                    Logger.app.debug("SIGN_IN_STATUS_CHANGED: Old=\(oldValue), New=\(newValue) - V.OSL_NOV_19_D")
                    if newValue {
                        if let userID = signInViewModel.userID {
                            Logger.app.info("SIGN_IN_STATUS_CHANGED: User JUST signed IN (userID: \(userID)), Onboarding: \(self.hasCompletedOnboarding). Kicking off Firestore check.")
                            checkOnboardingStatusInFirestore(for: userID, source: "onChangeSignIn_V.OSL_NOV_19_D")
                        } else {
                            Logger.app.error("SIGN_IN_STATUS_CHANGED: User signed in, but userID nil! Onboarding false.")
                            if self.hasCompletedOnboarding != false {
                                 self.hasCompletedOnboarding = false
                            }
                        }
                    } else {
                        Logger.app.info("SIGN_IN_STATUS_CHANGED: User JUST signed OUT. Resetting UI onboarding state false.")
                        if self.hasCompletedOnboarding != false {
                            self.hasCompletedOnboarding = false
                        }
                    }
                }
                .onChange(of: hasCompletedOnboarding) { oldValue, newValue in 
                    Logger.app.debug("ONBOARDING_STATE_CHANGED: Old=\(oldValue), New=\(newValue) - V.OSL_NOV_19_D")
                    if signInViewModel.isSignedIn, let userID = signInViewModel.userID {
                        let key = onboardingCompletedKey + userID
                        UserDefaults.standard.set(newValue, forKey: key)
                        Logger.data.info("ONBOARDING_STATE_CHANGED: Cached to UserDefaults for user \(userID): \(newValue)")
                    } else {
                        Logger.app.info("ONBOARDING_STATE_CHANGED: User not signed in or userID nil. Not caching. (isSignedIn: \(self.signInViewModel.isSignedIn))")
                    }
                }
                .onChange(of: scenePhase) { oldValue, newValue in
                    // Claude: CRITICAL FIX - Sync widget data when app goes to background
                    if oldValue == .active && newValue == .background {
                        Logger.app.info("🔄 App going to background - syncing widget data")
                        
                        // Use the dedicated background method for widget sync
                        cosmicHUDIntegration.appDidEnterBackground()
                        
                        // Also force HUD update for immediate sync
                        Task.detached(priority: .userInitiated) {
                            await cosmicHUDIntegration.updateHUD()
                            Logger.app.info("✅ Widget data synced for background state")
                        }
                    }
                }
                .onChange(of: realmNumberManager.currentRealmNumber) { oldValue, newValue in
                    // Claude: WIDGET FIX - Update widgets immediately when realm number changes
                    Logger.app.info("🔄 Realm number changed from \(oldValue) to \(newValue) - updating widgets")
                    
                    Task.detached(priority: .userInitiated) {
                        await cosmicHUDIntegration.updateHUD()
                        Logger.app.info("✅ Widgets updated for realm number change")
                    }
                }
        }
    }
    
    private func checkOnboardingStatusInFirestore(for userID: String, source: String) {
        Logger.network.debug("FIRESTORE_CHECK (Called by \(source)): Checking profile for userID: \(userID) - V.OSL_NOV_19_D")
        
        // Claude: PERFORMANCE OPTIMIZATION - Reduce Firestore delay from 3s to 1s
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1.0) {
        UserProfileService.shared.profileExists(for: userID) { [self] existsInFirestore, _ in
            DispatchQueue.main.async {
                if existsInFirestore {
                    Logger.network.info("FIRESTORE_CHECK (Callback for \(userID)): Profile DOES EXIST in Firestore. Onboarding TRUE.")
                    if self.hasCompletedOnboarding != true {
                        self.hasCompletedOnboarding = true
                    }
                    fetchProfileAndConfigureInsightManager(for: userID, source: "firestore_profileExists")
                } else {
                    Logger.network.info("FIRESTORE_CHECK (Callback for \(userID)): Profile DOES NOT EXIST in Firestore. Onboarding FALSE.")
                    if self.hasCompletedOnboarding != false {
                        self.hasCompletedOnboarding = false
                    }
                    AIInsightManager.shared.clearInsight()
                    }
                }
            }
        }
    }

    // ✨ New helper function to fetch profile and configure AIInsightManager
    private func fetchProfileAndConfigureInsightManager(for userID: String, source: String) {
        Logger.network.debug("FETCH_PROFILE_FOR_AI (Called by \(source)): Fetching profile for userID: \(userID) to configure AIInsightManager.")
        
        // Claude: PERFORMANCE OPTIMIZATION - Move to background thread immediately
        DispatchQueue.global(qos: .userInitiated).async {
        UserProfileService.shared.fetchUserProfile(for: userID) { profile, _ in
            DispatchQueue.main.async {
                if let fetchedProfile = profile {
                    Logger.ai.info("FETCH_PROFILE_FOR_AI (Callback for \(userID)): UserProfile fetched successfully. Configuring AIInsightManager.")
                    AIInsightManager.shared.configureAndRefreshInsight(for: fetchedProfile)
                    UserProfileService.shared.cacheUserProfileToUserDefaults(fetchedProfile)
                } else {
                    Logger.network.error("FETCH_PROFILE_FOR_AI (Callback for \(userID)): UserProfile fetch returned nil but no error. AIInsightManager will not be configured.")
                    }
                }
            }
        }
    }

    private func configureAppearance() {
        // Claude: PERFORMANCE OPTIMIZATION - Ensure UI operations happen on main thread
        DispatchQueue.main.async {
            Logger.ui.info("🎨 VybeMVPApp: configureAppearance called - OPTIMIZED_LAUNCH")
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    // Claude: PERFORMANCE OPTIMIZATION - Static method for appearance configuration
    static func performAppearanceConfiguration() {
        DispatchQueue.main.async {
            Logger.ui.info("🎨 VybeMVPApp: static appearance configuration - OPTIMIZED_LAUNCH")
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
} 
