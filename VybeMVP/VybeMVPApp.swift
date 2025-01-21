import SwiftUI
import os.log

@main
struct VybeMVPApp: App {
    @StateObject private var focusNumberManager = FocusNumberManager()
    @StateObject private var journalManager = JournalManager()
    @StateObject private var realmNumberManager = RealmNumberManager()
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
                .environmentObject(focusNumberManager)
                .environmentObject(journalManager)
                .environmentObject(realmNumberManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // Save context when app moves to background
                    persistenceController.save()
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
