import SwiftUI

struct ContentView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @State private var selectedTab = 0
    
    var body: some View {
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
                    Image(systemName: "sparkles.circle.fill")
                    Text("Realm")
                }
                .tag(2)
            
            MatchAnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(3)
            
            NumberMeaningView()
                .tabItem {
                    Image(systemName: "number.circle.fill")
                    Text("Meanings")
                }
                .tag(4)
            
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("About")
                }
                .tag(5)
        }
        .onAppear {
            // Set the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            print("🔍 ContentView appeared")
            print("📊 Current Realm Number: \(realmNumberManager.currentRealmNumber)")
        }
        .onChange(of: realmNumberManager.currentRealmNumber) { _, newValue in
            focusNumberManager.updateRealmNumber(newValue)
            print("🔄 Updated FocusNumberManager with new realm number: \(newValue)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FocusNumberManager())
        .environmentObject(RealmNumberManager())
        .environmentObject(JournalManager())
}
