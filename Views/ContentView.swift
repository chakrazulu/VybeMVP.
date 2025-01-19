import SwiftUI

struct ContentView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FocusNumberView()
                .tabItem {
                    Label("Focus", systemImage: "number.circle")
                }
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}
