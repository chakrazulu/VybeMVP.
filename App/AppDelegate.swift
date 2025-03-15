import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    private let backgroundManager = BackgroundManager.shared
    private let realmNumberManager = RealmNumberManager()
    private let focusNumberManager = FocusNumberManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("\n🚀 Application launching...")
        
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
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\n📱 Application became active")
        Task {
            // Ensure updates are running
            backgroundManager.startActiveUpdates()
            realmNumberManager.startUpdates()
            focusNumberManager.startUpdates()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("\n📱 Application will resign active")
        // Keep updates running in background
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("\n📱 Application entered background")
        // Schedule background task
        backgroundManager.scheduleBackgroundTask()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("\n📱 Application will terminate")
        // Perform cleanup if needed
    }
} 