import SwiftUI

struct ContentView: View {
    @StateObject private var focusNumberManager = FocusNumberManager.shared
    @EnvironmentObject var realmNumberManager: RealmNumberManager
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
                
                RealmNumberView()
                    .tabItem {
                        Image(systemName: "sparkles.circle")
                        Text("Realm")
                    }
                    .tag(2)
                
                MatchAnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Analytics")
                    }
                    .tag(3)
                
                NavigationView {
                    NumberMeaningView()
                }
                .tabItem {
                    Image(systemName: "number.circle.fill")
                    Text("Meanings")
                }
                .tag(4)
                
                NavigationView {
                    SettingsView()
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
                
                AboutView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("About")
                    }
                    .tag(6)
            }
        }
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            print("🔍 ContentView appeared")
            print("📊 Current Realm Number: \(realmNumberManager.currentRealmNumber)")
        }
        .onChange(of: realmNumberManager.currentRealmNumber) { oldValue, newValue in
            focusNumberManager.updateRealmNumber(newValue)
            print("🔄 Updated FocusNumberManager with realm number: \(oldValue) → \(newValue)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RealmNumberManager())
        .environmentObject(JournalManager())
}
