import SwiftUI

@main
struct VybeMVPApp: App {
    // Initialize our manager as a StateObject at the app level
    @StateObject private var focusNumberManager = FocusNumberManager()
    
    // Add persistence controller
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(focusNumberManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
