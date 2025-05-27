import Foundation
import Combine

class ActivityNavigationManager: ObservableObject {
    static let shared = ActivityNavigationManager()
    
    @Published var insightToView: MatchedInsightData? = nil
    @Published var navigateToActivityTab: Bool = false // To signal ContentView to switch tabs
    @Published var navigateToRealmTab: Bool = false // NEW: To signal ContentView to switch to Realm tab
    
    private init() {}
    
    func requestNavigation(to insight: MatchedInsightData) {
        self.insightToView = insight
        // It's better for ContentView to reset this after navigation to avoid race conditions.
        // For now, let ContentView handle this.
        self.navigateToActivityTab = true 
    }

    func requestRealmNavigation() {
        // It's better for ContentView to reset this after navigation.
        self.navigateToRealmTab = true
    }

    // Optional: Add a method to be called by ContentView after navigation has occurred
    func didNavigateToActivityTab() {
        self.navigateToActivityTab = false
        // Do not clear insightToView here, ActivityView needs it.
    }

    func didNavigateToRealmTab() {
        self.navigateToRealmTab = false
    }
} 