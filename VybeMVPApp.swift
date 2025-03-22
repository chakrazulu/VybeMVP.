import SwiftUI
import FirebaseCore

// Initialize Firebase at the earliest possible moment
// This will run before any other code in the app
FirebaseApp.configure()

@main
struct VybeMVPApp: App {
    // Register app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Add managers to environment
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var realmNumberManager = RealmNumberManager()
    
    init() {
        // Firebase is now initialized at file scope above
        print("🚀 App starting initialization...")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(realmNumberManager)
                // ... other environment objects
        }
    }
} 