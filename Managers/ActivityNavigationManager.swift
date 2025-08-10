/*
 * ========================================
 * 🧭 ACTIVITY NAVIGATION MANAGER - DEEP LINKING SYSTEM
 * ========================================
 *
 * CORE PURPOSE:
 * Manages deep linking and navigation between different app sections, particularly
 * for directing users to specific insights in the Activity tab or Realm tab.
 * Provides centralized navigation state management for cross-tab communication.
 *
 * TECHNICAL ARCHITECTURE:
 * - Singleton pattern for app-wide access
 * - ObservableObject for SwiftUI state management
 * - Published properties for reactive navigation triggers
 * - Cross-tab communication via shared state
 *
 * NAVIGATION FLOWS:
 * 1. Insight Deep Linking: Navigate to specific insight in Activity tab
 * 2. Realm Tab Navigation: Switch to Realm tab for number analysis
 * 3. State Reset: Clean up navigation state after successful navigation
 *
 * INTEGRATION POINTS:
 * - ContentView: Main tab controller that responds to navigation requests
 * - ActivityView: Displays specific insights when navigated to
 * - RealmNumberView: Target for realm-specific navigation
 * - AIInsightManager: Triggers insight navigation requests
 *
 * STATE MANAGEMENT:
 * - insightToView: Specific insight to display in Activity tab
 * - navigateToActivityTab: Boolean trigger for tab switching
 * - navigateToRealmTab: Boolean trigger for realm tab navigation
 *
 * USAGE PATTERNS:
 * - Called by AIInsightManager when new insights are generated
 * - ContentView observes navigation triggers and switches tabs
 * - ActivityView reads insightToView to highlight specific content
 * - State is reset after successful navigation to prevent race conditions
 */

import Foundation
import Combine

/**
 * ActivityNavigationManager: Centralized navigation state management for deep linking
 *
 * Provides reactive navigation triggers and insight-specific deep linking
 * capabilities across the Vybe app's tab-based architecture.
 */
class ActivityNavigationManager: ObservableObject {
    static let shared = ActivityNavigationManager()

    // MARK: - Published Properties

    /// Specific insight to display when navigating to Activity tab
    @Published var insightToView: MatchedInsightData? = nil

    /// Boolean trigger to signal ContentView to switch to Activity tab
    @Published var navigateToActivityTab: Bool = false

    /// Boolean trigger to signal ContentView to switch to Realm tab
    @Published var navigateToRealmTab: Bool = false

    // MARK: - Initialization

    /// Private initializer to enforce singleton pattern
    private init() {}

    // MARK: - Navigation Methods

    /**
     * Requests navigation to a specific insight in the Activity tab
     *
     * Sets the insight to view and triggers the Activity tab navigation.
     * ContentView will observe this and switch tabs accordingly.
     *
     * @param insight The specific insight data to display
     */
    func requestNavigation(to insight: MatchedInsightData) {
        self.insightToView = insight
        // It's better for ContentView to reset this after navigation to avoid race conditions.
        // For now, let ContentView handle this.
        self.navigateToActivityTab = true
    }

    /**
     * Requests navigation to the Realm tab
     *
     * Triggers the Realm tab navigation. ContentView will observe this
     * and switch to the Realm tab for number analysis.
     */
    func requestRealmNavigation() {
        // It's better for ContentView to reset this after navigation.
        self.navigateToRealmTab = true
    }

    // MARK: - State Reset Methods

    /**
     * Called by ContentView after successful navigation to Activity tab
     *
     * Resets the navigation trigger but preserves insightToView since
     * ActivityView needs it to display the specific insight.
     */
    func didNavigateToActivityTab() {
        self.navigateToActivityTab = false
        // Do not clear insightToView here, ActivityView needs it.
    }

    /**
     * Called by ContentView after successful navigation to Realm tab
     *
     * Resets the navigation trigger for Realm tab navigation.
     */
    func didNavigateToRealmTab() {
        self.navigateToRealmTab = false
    }
}
