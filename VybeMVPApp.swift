import SwiftUI

@main
struct VybeMVPApp: App {
    // Register app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Add managers to environment
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var realmNumberManager = RealmNumberManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(realmNumberManager)
                // ... other environment objects
        }
    }
} 