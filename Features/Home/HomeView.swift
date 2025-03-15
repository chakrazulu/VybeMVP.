var body: some View {
    TabView {
        HomeContentView()
            .tabItem { Label("Home", systemImage: "house") }
            .badge(NotificationManager.shared.unreadCount)
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
        NotificationManager.shared.clearBadgeCount()
    }
    .task {
        // Check notification status when view appears
        _ = try? await NotificationManager.shared.checkNotificationStatus()
    }
} 