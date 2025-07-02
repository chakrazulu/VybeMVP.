/**
 * Filename: ContentView.swift
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === ROOT CONTAINER STRUCTURE ===
 * • ZStack: Full screen (430×932pt on iPhone 14 Pro Max)
 * • NavigationView: Contains TabView
 * • TabView: 12 tabs total, standard iOS tab bar (49pt height)
 * • VybeMatchOverlay: Floating above all content when active
 *
 * === TAB BAR SPECIFICATIONS ===
 * • Height: 49pt standard iOS tab bar
 * • Tab items: Icon (25×25pt) + Text (10pt font)
 * • Selected color: System accent color
 * • Unselected color: System gray
 * • Background: Opaque with scrollEdgeAppearance
 *
 * === TAB LAYOUT (12 tabs) ===
 * 0. Home - house.fill icon
 * 1. Journal - book.fill icon
 * 2. Timeline - globe.americas.fill icon
 * 3. My Sanctum - person.circle.fill icon
 * 4. Activity - list.star icon
 * 5. Sightings - sparkle.magnifyingglass icon
 * 6. Realm - sparkles icon
 * 7. Chakras - circle.grid.3x3.circle.fill icon
 * 8. Analytics - chart.bar.fill icon
 * 9. Meanings - number.circle.fill icon
 * 10. Settings - gear icon
 * 11. About - info.circle.fill icon
 * 12. Test - sparkle icon (temporary)
 *
 * === OVERLAY SYSTEM ===
 * • VybeMatchOverlay: Full screen overlay, see VybeMatchOverlay.swift
 * • Sheet presentations: Standard iOS modal (full screen)
 * • Notification sheet: NavigationView wrapped content
 *
 * === STARTUP SEQUENCE (Performance Optimized) ===
 * • 0.0s: Tab bar appearance configuration
 * • 0.2s: FocusNumberManager configuration
 * • 0.8s: Heart rate monitoring start
 * • 2.0s: AI insights refresh + VybeMatch sync
 * • 15.0s: Match detection system enabled
 *
 * === STATE MANAGEMENT ===
 * • @StateObject: 5 managers (Focus, Activity, AI, Health, SignIn, VybeMatch)
 * • @EnvironmentObject: RealmNumberManager (passed from app)
 * • @State: selectedTab (Int), sheet states
 *
 * === NAVIGATION FLOW ===
 * • Tab selection: Direct via selectedTab binding
 * • Activity navigation: Via ActivityNavigationManager
 * • Realm navigation: Via ActivityNavigationManager
 * • Sheet presentation: Via @State bindings
 *
 * Purpose: Main container view that manages navigation between the app's primary sections.
 * This serves as the app's root view, providing tab-based navigation to all major features.
 *
 * Design pattern: Tab-based UI with NavigationView integration
 * Dependencies: 
 * - FocusNumberManager
 * - RealmNumberManager
 */

import SwiftUI

/**
 * ContentView: The main container view for the VybeMVP application.
 *
 * This view provides:
 * 1. A tab-based navigation system to all major app sections
 * 2. Integration between realm number updates and focus number management
 * 3. A consistent navigation experience throughout the app
 *
 * The view observes changes to the realm number and updates the focus number 
 * manager accordingly to maintain consistency between these two related systems.
 */
struct ContentView: View {
    /// Manages focus numbers and match detection
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    
    /// Manages realm numbers (numerical representation of universal states)
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    /// Manages activity navigation
    @StateObject private var activityNavigationManager = ActivityNavigationManager.shared
    
    /// Manages AI insights
    @StateObject private var aiInsightManager = AIInsightManager.shared
    
    /// Manages health data including heart rate
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    /// Manages sign in state
    @StateObject private var signInViewModel = SignInViewModel()
    
    /// 🌟 Manages cosmic match detection and visual effects
    @StateObject private var vybeMatchManager = VybeMatchManager()
    
    // NEW State for handling notification taps
    @State private var showNotificationSheet = false
    @State private var notificationData: (number: Int, category: String, message: String)? = nil
    
    /// Tracks the currently selected tab
    @State private var selectedTab = 0
    
    /// 🧪 TEMPORARY: Test button state for Phase 2 testing
    @State private var currentTestNumber = 1
    @State private var showTestButton = true
    
    var body: some View {
        ZStack { // 🎯 ROOT CONTAINER: Full screen ZStack for layered content
            NavigationView { // 📱 NAVIGATION WRAPPER: Required for tab-based navigation
                TabView(selection: $selectedTab) { // 🎨 TAB BAR: 12 tabs, 49pt height
                    // 🏠 HOME TAB (Tag 0) - Primary landing screen
                    HomeView()
                        .environmentObject(focusNumberManager)
                        .environmentObject(activityNavigationManager) 
                        .environmentObject(aiInsightManager)
                        .environmentObject(healthKitManager)
                        .environmentObject(signInViewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    // DIRECT LOADING - Back to original approach for fast user experience
                    JournalView()
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "book.fill")
                            Text("Journal")
                        }
                        .tag(1)
                    
                    SocialTimelineView() // Global Resonance Timeline
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "globe.americas.fill")
                            Text("Timeline")
                        }
                        .tag(2)
                    
                    UserProfileTabView()
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("My Sanctum")
                        }
                        .tag(3)
                    
                    ActivityView() // New Activity Tab
                        .environmentObject(focusNumberManager)
                        .environmentObject(activityNavigationManager)
                        .environmentObject(aiInsightManager)
                        .tabItem {
                            Image(systemName: "list.star") // Suggesting an icon
                            Text("Activity")
                        }
                        .tag(4)
                    
                    SightingsView() // Sightings Portal Tab
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "sparkle.magnifyingglass")
                            Text("Sightings")
                        }
                        .tag(5)
                    
                    RealmNumberView()
                        .environmentObject(focusNumberManager)
                        .environmentObject(activityNavigationManager)
                        .environmentObject(aiInsightManager)
                        .tabItem {
                            Image(systemName: "sparkles")
                            Text("Realm")
                        }
                        .tag(6) // Adjusted tag
                    
                    PhantomChakrasView()
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "circle.grid.3x3.circle.fill")
                            Text("Chakras")
                        }
                        .tag(7) // Adjusted tag
                    
                    MatchAnalyticsView()
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Analytics")
                        }
                        .tag(8) // Adjusted tag
                    
                    NavigationView {
                        NumberMeaningView()
                    }
                    .tabItem {
                        Image(systemName: "number.circle.fill")
                        Text("Meanings")
                    }
                    .tag(9) // Adjusted tag
                    
                    NavigationView {
                        SettingsView()
                            .environmentObject(realmNumberManager)
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(10) // Adjusted tag
                    
                    AboutView()
                        .tabItem {
                            Image(systemName: "info.circle.fill")
                            Text("About")
                        }
                        .tag(11) // Adjusted tag
                    
                    // TEMPORARY: Cosmic Animation Test Tab  
                    TestCosmicAnimationView()
                        .tabItem {
                            Image(systemName: "sparkle")
                            Text("🌌 Test")
                        }
                        .tag(12)
                }
            }
            
            // 🌟 COSMIC MATCH OVERLAY: Floating celebration layer (380×300pt bubble)
            // Appears above all content when Focus Number == Realm Number
            // See VybeMatchOverlay.swift for detailed pixel specifications
            VybeMatchOverlay(
                isVisible: $vybeMatchManager.isMatchActive,
                matchedNumber: vybeMatchManager.currentMatchedNumber,
                heartRate: vybeMatchManager.currentHeartRate
            )
            
            // 🧪 TEMPORARY: Phase 2 Test Button (REMOVE AFTER TESTING)
            if showTestButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            // Test all numbers button
                            Button(action: {
                                testAllNumbers()
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                    Text("Test All")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 70, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.purple.opacity(0.8))
                                        .shadow(radius: 4)
                                )
                            }
                            
                            // Single number test button
                            Button(action: {
                                testSingleNumber()
                            }) {
                                VStack(spacing: 4) {
                                    Text("\(currentTestNumber)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Test")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 70, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.8))
                                        .shadow(radius: 4)
                                )
                            }
                            
                            // Hide button
                            Button(action: {
                                showTestButton = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.bottom, 40) // Closer to tab bar, below cosmic match overlay
                }
                .zIndex(1000) // Ensure test buttons stay above cosmic overlay
            }
        }
        .sheet(isPresented: $showNotificationSheet) {
            // Present the NumberMatchNotificationView when showNotificationSheet is true
            if let data = notificationData {
                // Embed in NavigationView for title and close button
                NavigationView {
                    NumberMatchNotificationView(
                        matchNumber: data.number, 
                        categoryName: data.category, 
                        messageContent: data.message,
                        onDismiss: { showNotificationSheet = false } // Add dismiss callback
                    )
                }
            }
        }
        .onReceive(NotificationManager.shared.notificationTapSubject) { data in
            // When a notification tap is published, store the data and trigger the sheet
            self.notificationData = data
            self.showNotificationSheet = true
        }
        .onReceive(activityNavigationManager.$navigateToActivityTab) { shouldNavigate in
            if shouldNavigate {
                selectedTab = 4 // Assuming Activity tab is tag 4
                activityNavigationManager.didNavigateToActivityTab() // Reset the flag
            }
        }
        .onReceive(activityNavigationManager.$navigateToRealmTab) { shouldNavigate in // NEW
            if shouldNavigate {
                selectedTab = 6 // Realm tab is now tag 6
                activityNavigationManager.didNavigateToRealmTab() // Reset the flag
            }
        }
        .onAppear {
            print("🔍 ContentView appeared")
            print("📊 Current Realm Number: \(realmNumberManager.currentRealmNumber)")
            
            // Set the tab bar appearance immediately (lightweight)
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // ULTRA-LIGHT startup - minimal operations only
            
            // Step 1: Configure FocusNumberManager (0.2s delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                FocusNumberManager.shared.configure(realmManager: realmNumberManager)
                print("🔧 Configured FocusNumberManager with RealmNumberManager...")
            }
            
            // Step 2: Start heart rate monitoring (0.8s delay) 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                HealthKitManager.shared.startHeartRateMonitoring()
                print("💓 Started heart rate monitoring...")
            }
            
            // Step 3: Defer AI insights to prevent UserProfile flood (2.0s delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                aiInsightManager.refreshInsightIfNeeded()
                print("🧠 AI insights refresh initiated...")
                
                // 🌟 Sync VybeMatchManager with current manager states
                vybeMatchManager.syncCurrentState(
                    focusNumber: focusNumberManager.selectedFocusNumber,
                    realmNumber: realmNumberManager.currentRealmNumber
                )
            }
            
            // Step 4: CRITICAL - Defer match detection system to prevent freeze (15.0s delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                FocusNumberManager.shared.enableMatchDetection()
                print("🎯 Match detection system enabled after startup stabilization")
            }
            
            // Step 5: Cosmic background starts immediately (no performance issues detected)
            print("🌟 ContentView fully loaded - cosmic background active, match detection deferred")
        }
        .onReceive(realmNumberManager.$currentRealmNumber) { newValue in
            let oldValue = focusNumberManager.realmNumber
            if oldValue != newValue {
                // REMOVE: This is now handled automatically by the Combine subscription inside FocusNumberManager
                // focusNumberManager.realmNumber = newValue 
                // print("🔄 Updated FocusNumberManager with realm number: \(oldValue) → \(newValue)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Refresh insights when app comes to foreground
            aiInsightManager.refreshInsightIfNeeded()
        }
    }
    
    // 🧪 TEMPORARY: Phase 2 Testing Functions (REMOVE AFTER TESTING)
    
    /// Tests all 9 sacred numbers with 3-second delays
    private func testAllNumbers() {
        print("🧪 Testing all 9 sacred numbers...")
        for i in 1...9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 3.0) {
                vybeMatchManager.simulateMatch(for: i)
            }
        }
    }
    
    /// Tests a single number and cycles to the next
    private func testSingleNumber() {
        print("🧪 Testing sacred number \(currentTestNumber)...")
        vybeMatchManager.simulateMatch(for: currentTestNumber)
        
        // Cycle to next number (1-9)
        currentTestNumber = currentTestNumber == 9 ? 1 : currentTestNumber + 1
    }
}

#Preview {
    ContentView()
        .environmentObject(RealmNumberManager())
        .environmentObject(JournalManager())
}
