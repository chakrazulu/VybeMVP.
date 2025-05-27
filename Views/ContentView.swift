/**
 * Filename: ContentView.swift
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
    
    // NEW State for handling notification taps
    @State private var showNotificationSheet = false
    @State private var notificationData: (number: Int, category: String, message: String)? = nil
    
    /// Tracks the currently selected tab
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                JournalView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Journal")
                    }
                    .tag(1)
                
                UserProfileTabView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("My Sanctum")
                    }
                    .tag(2)
                
                RealmNumberView()
                    .tabItem {
                        Image(systemName: "sparkles")
                        Text("Realm")
                    }
                    .tag(3)
                
                MatchAnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Analytics")
                    }
                    .tag(4)
                
                NavigationView {
                    NumberMeaningView()
                }
                .tabItem {
                    Image(systemName: "number.circle.fill")
                    Text("Meanings")
                }
                .tag(5)
                
                NavigationView {
                    SettingsView()
                        .environmentObject(realmNumberManager)
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(6)
                
                AboutView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("About")
                    }
                    .tag(7)
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
        .onAppear {
            // --- Configuration moved here to avoid StateObject init warning ---
            // Ensure configuration happens only once.
            // We can check if the cancellables set is empty, implying the subscription
            // hasn't been set up yet by the FocusNumberManager.shared singleton.
            // NOTE: This relies on FocusNumberManager not setting up subscriptions elsewhere.
            // A more robust method might involve a dedicated flag in FocusNumberManager.
            // if FocusNumberManager.shared.cancellables.isEmpty { // <-- Potential check, but relies on implementation detail
            // Alternative: Use a static flag or check a specific known cancellable if possible.
            // For simplicity now, let's assume onAppear might run multiple times but configure is idempotent 
            // or handles multiple calls safely (which our current configure does).
            FocusNumberManager.shared.configure(realmManager: realmNumberManager) 
            // --- End Configuration ---
            
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            print("🔍 ContentView appeared")
            print("📊 Current Realm Number: \(realmNumberManager.currentRealmNumber)")
            
            // Start heart rate monitoring when the main view appears
            HealthKitManager.shared.startHeartRateMonitoring()
        }
        .onReceive(realmNumberManager.$currentRealmNumber) { newValue in
            let oldValue = focusNumberManager.realmNumber
            if oldValue != newValue {
                // REMOVE: This is now handled automatically by the Combine subscription inside FocusNumberManager
                // focusNumberManager.realmNumber = newValue 
                // print("🔄 Updated FocusNumberManager with realm number: \(oldValue) → \(newValue)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RealmNumberManager())
        .environmentObject(JournalManager())
}
