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
 * 3. Profile - person.circle.fill icon (NEW - clean social profile)
 * 4. Activity - list.star icon
 * 5. Sightings - sparkle.magnifyingglass icon
 * 6. Realm - sparkles icon
 * 7. Chakras - circle.grid.3x3.circle.fill icon
 * 8. Analytics - chart.bar.fill icon
 * 9. Meanings - number.circle.fill icon
 * 10. My Sanctum - star.circle.fill icon (MOVED - spiritual sanctuary)
 * 11. Settings - gear icon (comprehensive app settings)
 * 12. About - info.circle.fill icon
 * 13. Test - sparkle icon (temporary)
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
 * 🌟 CONTENTVIEW - MASTER NAVIGATION & SPIRITUAL ECOSYSTEM ORCHESTRATION 🌟
 * 
 * Claude: ContentView serves as the architectural foundation of VybeMVP, orchestrating
 * the entire spiritual ecosystem through sophisticated tab-based navigation and manager
 * coordination. This isn't simply a navigation container - it's the nerve center that
 * coordinates complex spiritual systems, biometric integration, and cosmic synchronicity
 * detection across the entire application.
 *
 * The view demonstrates advanced iOS architecture patterns, managing multiple concurrent
 * state objects while maintaining optimal performance and seamless user experience
 * transitions between spiritual features.
 *
 * SPIRITUAL ECOSYSTEM COORDINATION:
 * • 12-tab navigation providing comprehensive access to all spiritual features
 * • VybeMatchOverlay system for cosmic synchronicity celebrations
 * • Sophisticated startup sequence optimized for performance and user engagement
 * • Manager integration enabling seamless data flow between spiritual systems
 *
 * PERFORMANCE ARCHITECTURE:
 * • Strategic 15-second delayed match detection preventing app launch interference
 * • Optimized manager initialization sequence preventing UI blocking
 * • Memory-efficient state object management with proper lifecycle handling
 * • Background processing coordination for continuous cosmic calculations
 */
struct ContentView: View {
    // MARK: - 🎯 CORE SPIRITUAL SYSTEM MANAGERS
    
    /// Claude: FocusNumberManager orchestrates the user's selected spiritual focus number
    /// and manages the sophisticated cosmic match detection when focus equals realm number.
    /// This state object serves as the heart of Vybe's synchronicity system, coordinating
    /// between user intention and cosmic alignment for transcendent experiences.
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    
    /// Claude: RealmNumberManager calculates and manages the dynamic cosmic realm number
    /// based on time, location, celestial influences, and biometric data. This environment
    /// object represents the universe's current energetic state and serves as the target
    /// for cosmic synchronicity detection throughout the spiritual journey.
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    /// Claude: ActivityNavigationManager provides sophisticated deep linking and navigation
    /// coordination for the spiritual activity timeline. This state object enables seamless
    /// navigation between cosmic experiences, insight history, and spiritual journey milestones
    /// with proper state preservation and user context awareness.
    @StateObject private var activityNavigationManager = ActivityNavigationManager.shared
    
    /// Claude: AIInsightManager orchestrates traditional template-based spiritual guidance
    /// generation, serving as the foundation layer for personalized daily wisdom. This
    /// state object manages Core Data persistence, intelligent caching, and seamless
    /// insight delivery integrated with the broader spiritual AI ecosystem.
    @StateObject private var aiInsightManager = AIInsightManager.shared
    
    /// Claude: HealthKitManager provides sophisticated biometric data integration enabling
    /// heart rate variability to influence cosmic calculations and sacred geometry animations.
    /// This state object manages privacy-compliant HealthKit authorization, real-time
    /// heart rate monitoring, and physiological context for enhanced spiritual experiences.
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    /// Claude: SignInViewModel handles comprehensive user authentication, profile management,
    /// and personalization throughout the spiritual ecosystem. This state object provides
    /// secure identity management enabling personalized cosmic calculations and spiritual
    /// journey tracking across all app features.
    @StateObject private var signInViewModel = SignInViewModel()
    
    /// Claude: VybeMatchManager orchestrates the sophisticated cosmic match detection and
    /// celebration system. When focus equals realm number, this state object triggers
    /// magical visual effects, haptic feedback, and spiritual acknowledgment that transforms
    /// mathematical synchronicity into transcendent user experiences.
    @StateObject private var vybeMatchManager = VybeMatchManager()
    
    // MARK: - 📲 NOTIFICATION SYSTEM STATE MANAGEMENT
    
    /// Claude: Controls presentation of notification-triggered modal sheets.
    /// When users tap on numerology notifications, this state manages the display
    /// of detailed spiritual guidance content within the app interface.
    @State private var showNotificationSheet = false
    
    /// Claude: Holds notification data for display in the notification modal.
    /// This tuple contains the spiritual number, category, and message content
    /// that was delivered via the iOS notification system for in-app presentation.
    @State private var notificationData: (number: Int, category: String, message: String)? = nil
    
    // MARK: - 🧭 NAVIGATION STATE MANAGEMENT
    
    /// Claude: Controls the currently active tab in the 12-tab navigation system.
    /// This zero-based index enables programmatic navigation between spiritual features
    /// and maintains tab state across app lifecycle and configuration changes.
    @State private var selectedTab = 0
    
    // MARK: - 🧪 TEMPORARY TESTING STATE
    
    /// Claude: TEMPORARY - Current test number for Phase 2 cosmic match testing.
    /// This state enables developers to cycle through different numbers during
    /// match detection validation and VybeMatchOverlay celebration testing.
    @State private var currentTestNumber = 1
    
    /// Claude: TEMPORARY - Controls visibility of the test button during development.
    /// This state allows developers to show/hide testing functionality during
    /// cosmic match system validation and user experience refinement.
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
                    
                    // 🎭 PHASE 3A: Twitter-Style Social Profile - Complete implementation with navigation
                    UserProfileView(selectedTab: $selectedTab)
                        .environmentObject(focusNumberManager)
                        .environmentObject(PostManager.shared)
                        .environmentObject(aiInsightManager)
                        .environmentObject(signInViewModel)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
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
                    
                    SanctumTabView()
                        .environmentObject(focusNumberManager)
                        .tabItem {
                            Image(systemName: "star.circle.fill")
                            Text("My Sanctum")
                        }
                        .tag(10) // MOVED - Spiritual sanctuary preserved
                    
                    NavigationView {
                        SettingsView()
                            .environmentObject(realmNumberManager)
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(11) // Shifted down
                    
                    AboutView()
                        .tabItem {
                            Image(systemName: "info.circle.fill")
                            Text("About")
                        }
                        .tag(12) // Shifted down
                    
                    // TEMPORARY: Cosmic Animation Test Tab  
                    TestCosmicAnimationView()
                        .tabItem {
                            Image(systemName: "sparkle")
                            Text("🌌 Test")
                        }
                        .tag(13) // Shifted down
                }
            }
            
            /// Claude: Cosmic Match Overlay - Sacred Number Celebration System
            /// 
            /// This floating overlay appears when Focus Number matches Realm Number,
            /// creating a cosmic celebration experience for users. The overlay uses
            /// the enhanced cosmic engine data for accurate spiritual correspondences.
            /// 
            /// Technical Integration:
            /// - Uses VybeMatchManager for match detection and state management
            /// - Integrates with enhanced cosmic engine for accurate planetary data
            /// - Displays real-time heart rate from HealthKit integration
            /// - Provides action buttons for navigation to related app sections
            /// 
            /// Cosmic Engine Integration:
            /// - Match detection uses realm numbers calculated from enhanced algorithms
            /// - Planetary correspondences use professional-grade astronomical data
            /// - Sacred geometry and numerological meanings preserved with accuracy
            /// - Celebration timing synchronized with actual cosmic conditions
            /// 
            /// Overlay Specifications:
            /// - Size: 380×300pt celebration bubble
            /// - Position: Floating above all tab content with proper z-indexing
            /// - Animation: Sacred geometry patterns with cosmic timing
            /// - Duration: Configurable celebration length based on match significance
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
            
            // Step 1: Configure FocusNumberManager
            DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.startupFocusManagerDelay) {
                FocusNumberManager.shared.configure(realmManager: realmNumberManager)
                print("🔧 Configured FocusNumberManager with RealmNumberManager...")
            }
            
            // Step 2: Start heart rate monitoring
            DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.startupHeartRateDelay) {
                HealthKitManager.shared.startHeartRateMonitoring()
                print("💓 Started heart rate monitoring...")
            }
            
            // Step 3: Defer AI insights to prevent UserProfile flood
            // Claude: SWIFT 6 COMPLIANCE - Use Task for async method call
            Task {
                try await Task.sleep(nanoseconds: UInt64(VybeConstants.startupAIInsightsDelay * 1_000_000_000))
                await aiInsightManager.refreshInsightIfNeeded()
                print("🧠 AI insights refresh initiated...")
                
                // 🌟 Sync VybeMatchManager with current manager states
                vybeMatchManager.syncCurrentState(
                    focusNumber: focusNumberManager.selectedFocusNumber,
                    realmNumber: realmNumberManager.currentRealmNumber
                )
            }
            
            // Step 4: CRITICAL - Defer match detection system to prevent freeze
            DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.extendedStartupDelay) {
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
            // Claude: SWIFT 6 COMPLIANCE - Use Task for async method call
            Task {
                await aiInsightManager.refreshInsightIfNeeded()
            }
        }
        // 🌟 VybeMatch Navigation Handlers - Handle action button navigation from cosmic match overlay
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToInsight"))) { notification in
            handleInsightNavigation(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToMeditation"))) { notification in
            handleMeditationNavigation(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToJournal"))) { notification in
            handleJournalNavigation(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToSighting"))) { notification in
            handleSightingNavigation(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToStatusPost"))) { notification in
            handleStatusPostNavigation(notification)
        }
        /// **ANALYTICS NAVIGATION RECEIVER - RECENT MATCH POPUP INTEGRATION**
        /// 
        /// **Purpose:** Listen for analytics navigation requests from RecentMatchPopupView
        /// **Integration:** Part of comprehensive action button navigation system
        /// **Added:** Phase 3C-3 Action Button Navigation Implementation
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToAnalytics"))) { notification in
            handleAnalyticsNavigation(notification)
        }
        /// **SETTINGS NAVIGATION RECEIVER - COSMIC EDGE BUTTON INTEGRATION**
        /// 
        /// **Purpose:** Listen for settings navigation requests from HomeView cosmic edge buttons
        /// **Integration:** Part of Phase 13 cosmic command center navigation system
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToSettings"))) { notification in
            handleSettingsNavigation(notification)
        }
        /// **SANCTUM NAVIGATION RECEIVER - COSMIC EDGE BUTTON INTEGRATION**
        /// 
        /// **Purpose:** Listen for sanctum navigation requests from HomeView cosmic edge buttons
        /// **Integration:** Part of Phase 13 cosmic command center navigation system
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NavigateToSanctum"))) { notification in
            handleSanctumNavigation(notification)
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
    
    // MARK: - VybeMatch Navigation Handlers
    
    /// Handle navigation to insight view from cosmic match overlay
    private func handleInsightNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let number = userInfo["number"] as? Int else { return }
        
        print("🌟 Navigating to Activity view to show cosmic match insight for number \(number)")
        
        // Navigate to Activity tab (which shows insights and cosmic matches in timeline)
        selectedTab = 4
        
        // Generate insight for the specific matched number and filter to show it
        // Claude: SWIFT 6 COMPLIANCE - Use Task for async method call
        Task {
            try await Task.sleep(nanoseconds: UInt64(VybeConstants.standardFeedbackDelay * 1_000_000_000))
            await aiInsightManager.refreshInsightIfNeeded()
            // TODO: Add filtering in ActivityView to highlight insights for number \(number)
            print("🎯 Activity view should focus on insights for cosmic match number \(number)")
        }
    }
    
    /// Handle navigation to meditation/chakra view from cosmic match overlay
    private func handleMeditationNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let number = userInfo["number"] as? Int,
              let chakra = userInfo["chakra"] as? String else { return }
        
        print("🧘 Starting \(chakra) chakra meditation for cosmic match number \(number)")
        
        // Navigate to Chakras tab and start specific meditation
        selectedTab = 7
        
        // TODO: Trigger specific chakra meditation for the matched number
        // This would require updating PhantomChakrasView to accept a specific chakra focus
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 PhantomChakrasView should focus on \(chakra) chakra meditation")
        }
    }
    
    /// Handle navigation to journal entry from cosmic match overlay
    private func handleJournalNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let _ = userInfo["cosmic_match"] as? Bool,
              let focusNumber = userInfo["focus_number"] as? Int,
              let realmNumber = userInfo["realm_number"] as? Int,
              let title = userInfo["title"] as? String else { return }
        
        print("📖 Creating Sacred Reflection for cosmic match: \(title)")
        
        // Navigate to Journal tab
        selectedTab = 1
        
        // TODO: Trigger immediate Sacred Reflection creation with pre-filled cosmic match data
        // This would require updating JournalView to open NewJournalEntryView with:
        // - Pre-filled title: "Sacred Reflection - Cosmic Alignment"
        // - Pre-set focus and realm numbers
        // - Cosmic match context in description
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 Journal should open Sacred Reflection with Focus \(focusNumber), Realm \(realmNumber)")
            print("📝 Pre-filled title: '\(title)'")
        }
    }
    
    /// Handle navigation to sighting log from cosmic match overlay
    private func handleSightingNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let number = userInfo["number"] as? Int,
              let title = userInfo["title"] as? String,
              let significance = userInfo["significance"] as? String else { return }
        
        print("👁️ Creating cosmic sighting log for number \(number): \(title)")
        
        // Navigate to Sightings tab
        selectedTab = 5
        
        // TODO: Trigger immediate sighting creation with cosmic match pre-filled
        // This would require updating SightingsView to open sighting creation with:
        // - Pre-filled number: \(number)
        // - Pre-filled title: "\(title)"
        // - Pre-filled significance: "\(significance)"
        // - Auto-set location and timestamp
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 Sightings should open creation form with cosmic match data")
            print("📍 Pre-filled: Number \(number), Title: '\(title)', Significance: '\(significance)'")
        }
    }
    
    /// Handle navigation to status posting from cosmic match overlay
    private func handleStatusPostNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let _ = userInfo["cosmic_match"] as? Bool,
              let number = userInfo["number"] as? Int,
              let message = userInfo["message"] as? String,
              let sacredMeaning = userInfo["sacred_meaning"] as? String else { return }
        
        print("📢 Creating cosmic status post for number \(number): \(sacredMeaning)")
        
        // Navigate to Social Timeline tab (tag 2)
        selectedTab = 2
        
        // TODO: Trigger immediate status creation with cosmic match pre-filled
        // This would require updating SocialView to open status composer with:
        // - Pre-filled message: "\(message)"
        // - Cosmic match context and number
        // - Sacred meaning and spiritual significance
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 Social timeline should open status composer with cosmic match")
            print("📱 Pre-filled message: '\(message)'")
            print("🔮 Sacred meaning: '\(sacredMeaning)'")
        }
    }
    
    /// **ANALYTICS NAVIGATION HANDLER - RECENT MATCH POPUP INTEGRATION**
    /// 
    /// **Purpose:** Handle navigation to Analytics tab from RecentMatchPopupView action buttons
    /// **Trigger:** "NavigateToAnalytics" NotificationCenter notification from popup
    /// **Target:** Analytics tab (tag 8) - MatchAnalyticsView
    /// 
    /// **Data Flow:**
    /// 1. RecentMatchPopupView posts notification with match number and focus area
    /// 2. ContentView receives notification and extracts userInfo data
    /// 3. Tab switches to Analytics with 0.5s delay for smooth transition
    /// 4. Future enhancement: Analytics view could highlight specific number patterns
    /// 
    /// **Navigation Pattern:**
    /// Follows same structure as other VybeMatch navigation handlers:
    /// - Guard userInfo extraction with early return
    /// - Immediate tab switch for responsive UX
    /// - Delayed processing for target view context
    /// - Console logging for development debugging
    /// 
    /// **Future Enhancement Opportunity:**
    /// MatchAnalyticsView could be enhanced to accept navigation context and
    /// automatically filter or highlight patterns for the specific matched number.
    private func handleAnalyticsNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let number = userInfo["number"] as? Int else { return }
        
        print("📊 Navigating to Analytics view for match number \(number)")
        
        // Navigate to Analytics tab (tag 8)
        selectedTab = 8
        
        // TODO: Analytics view could be enhanced to highlight patterns for specific numbers
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 Analytics view should focus on patterns for number \(number)")
            if let focus = userInfo["focus"] as? String {
                print("📈 Focus area: \(focus)")
            }
        }
    }
    
    /// **SETTINGS NAVIGATION HANDLER - COSMIC EDGE BUTTON INTEGRATION**
    ///
    /// **Purpose:** Handle navigation to Settings tab from HomeView cosmic edge buttons
    /// **Trigger:** "NavigateToSettings" NotificationCenter notification from HomeView
    /// **Target:** Settings tab (tag 11) - SettingsView
    ///
    /// **Navigation Pattern:**
    /// Follows same structure as other navigation handlers:
    /// - Immediate tab switch for responsive UX
    /// - Console logging for development debugging
    private func handleSettingsNavigation(_ notification: Notification) {
        print("⚙️ Navigating to Settings view from cosmic edge button")
        
        // Navigate to Settings tab (tag 11)
        selectedTab = 11
        
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 Settings view opened successfully")
        }
    }
    
    /// **SANCTUM NAVIGATION HANDLER - COSMIC EDGE BUTTON INTEGRATION**
    ///
    /// **Purpose:** Handle navigation to My Sanctum tab from HomeView cosmic edge buttons
    /// **Trigger:** "NavigateToSanctum" NotificationCenter notification from HomeView
    /// **Target:** My Sanctum tab (tag 10) - SanctumTabView (Spiritual sanctuary)
    ///
    /// **Navigation Pattern:**
    /// Follows same structure as other navigation handlers:
    /// - Immediate tab switch for responsive UX
    /// - Console logging for development debugging
    private func handleSanctumNavigation(_ notification: Notification) {
        print("🏛️ Navigating to My Sanctum view from cosmic edge button")
        
        // Navigate to My Sanctum tab (tag 10)
        selectedTab = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            print("🎯 My Sanctum view opened successfully")
        }
    }
}

// MARK: - Phase 3A: Twitter-Style Profile Complete

// PlaceholderProfileView has been replaced with comprehensive UserProfileView
// See Views/UserProfileView.swift for full Twitter-style social profile implementation

#Preview {
    ContentView()
        .environmentObject(RealmNumberManager())
        .environmentObject(JournalManager())
}
