import SwiftUI
import os.log
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
        
        return true
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
            await HealthKitManager.shared.fetchInitialHeartRate()
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

@main
struct VybeMVPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    @StateObject private var journalManager = JournalManager()
    @StateObject private var realmNumberManager = RealmNumberManager()
    @StateObject private var backgroundManager = BackgroundManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    init() {
        print("🚀 App starting initialization...")
        
        // Configure logging for development
        #if DEBUG
        // Reduce system noise
        UserDefaults.standard.set(false, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        UserDefaults.standard.setValue(false, forKey: "UIViewLayoutConstraintEnableLog")
        
        // Set up custom logging categories
        configureLogging()
        #endif
        
        configureAppearance()
        print("🚀 App initialized with RealmNumberManager...")
    }
    
    private func configureLogging() {
        // Only log important subsystems
        setenv("OS_ACTIVITY_MODE", "disable", 1)
        
        // Keep your emoji-tagged logs which are much more useful
        Logger.debug("📱 App initialized", category: Logger.lifecycle)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(realmNumberManager)
                .environmentObject(journalManager)
                .environmentObject(focusNumberManager)
                .environmentObject(backgroundManager)
                .environmentObject(healthKitManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Set up manager references
                    backgroundManager.setManagers(realm: realmNumberManager, focus: focusNumberManager)
                    // Schedule initial background task when app launches
                    backgroundManager.scheduleBackgroundTask()
                    
                    // Start HealthKit monitoring if authorized
                    if healthKitManager.authorizationStatus == .sharingAuthorized {
                        healthKitManager.startHeartRateMonitoring()
                    }
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    switch newPhase {
                    case .active:
                        // App became active - start frequent updates
                        print("📱 App became active")
                        backgroundManager.startActiveUpdates()
                    case .inactive:
                        // App became inactive - stop frequent updates
                        print("📱 App became inactive")
                        backgroundManager.stopActiveUpdates()
                        persistenceController.save()
                    case .background:
                        // App moved to background - stop frequent updates and schedule background task
                        print("📱 App moved to background")
                        backgroundManager.stopActiveUpdates()
                        persistenceController.save()
                        backgroundManager.scheduleBackgroundTask()
                    @unknown default:
                        break
                    }
                }
        }
    }
    
    private func configureAppearance() {
        // Configure global appearance
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        // Set the tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
} 
