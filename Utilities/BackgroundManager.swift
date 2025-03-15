class BackgroundManager: NSObject, ObservableObject {
    // ... existing code ...
    
    func startMonitoring() {
        Task {
            await registerForNotifications()
        }
        startActiveUpdates()
    }
    
    func startActiveUpdates() {
        stopActiveUpdates()
        performUpdate()
        
        // Schedule timer for periodic updates
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.performUpdate()
        }
    }
    
    func stopActiveUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    func performUpdate() {
        realmManager.startUpdates()
        realmManager.calculateRealmNumber()
        checkForMatches()
    }
    
    private func checkForMatches() {
        guard let realmNumber = realmManager.currentRealmNumber else { return }
        focusNumberManager.verifyAndSaveMatch(realmNumber: realmNumber) { success in
            if success {
                print("🎯 Match found!")
            }
        }
    }
    
    private func registerForNotifications() async {
        let granted = await requestNotificationPermissions()
        if granted {
            print("✅ Notification permissions granted")
        } else {
            print("❌ Notification permissions denied")
        }
    }
    
    private func requestNotificationPermissions() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            guard settings.authorizationStatus != .authorized else {
                return true
            }
            
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("❌ Error requesting notification permissions: \(error)")
            return false
        }
    }
} 