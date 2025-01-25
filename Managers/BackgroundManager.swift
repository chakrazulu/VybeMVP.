import Foundation
import BackgroundTasks
import UserNotifications

class BackgroundManager: ObservableObject {
    static let shared = BackgroundManager()
    private let backgroundTaskIdentifier = "com.infinitiesinn.vybe.backgroundUpdate"
    
    // Reference to other managers
    private var realmNumberManager: RealmNumberManager?
    private var focusNumberManager: FocusNumberManager?
    private var activeTimer: Timer?
    
    // Update intervals
    private let activeUpdateInterval: TimeInterval = 60 // 1 minute for active app
    private let backgroundUpdateInterval: TimeInterval = 15 * 60 // 15 minutes for background
    
    private init() {
        print("🔄 Initializing BackgroundManager...")
        registerForNotifications()
    }
    
    func setManagers(realm: RealmNumberManager, focus: FocusNumberManager) {
        self.realmNumberManager = realm
        self.focusNumberManager = focus
        print("✅ Managers set successfully")
        
        // Start active updates immediately
        startActiveUpdates()
    }
    
    // Start frequent updates when app is active
    func startActiveUpdates() {
        print("⚡️ Starting active updates (every \(activeUpdateInterval) seconds)")
        stopActiveUpdates() // Clear any existing timer
        
        // Perform initial update
        performUpdate()
        
        // Set up timer for frequent updates
        activeTimer = Timer.scheduledTimer(withTimeInterval: activeUpdateInterval, repeats: true) { [weak self] _ in
            self?.performUpdate()
        }
    }
    
    // Stop frequent updates
    func stopActiveUpdates() {
        print("🛑 Stopping active updates")
        activeTimer?.invalidate()
        activeTimer = nil
    }
    
    // Common update logic
    private func performUpdate() {
        print("🔄 Performing update...")
        realmNumberManager?.calculateRealmNumber()
        focusNumberManager?.calculateFocusNumber()
        checkForMatches()
    }
    
    func handleBackgroundTask(_ task: BGAppRefreshTask) {
        print("🔄 Handling background task...")
        
        // Schedule the next background task first
        scheduleBackgroundTask()
        
        task.expirationHandler = { [weak self] in
            print("⚠️ Background task expired")
            task.setTaskCompleted(success: false)
            self?.scheduleBackgroundTask()
        }
        
        performUpdate()
        
        print("✅ Background task completed successfully")
        task.setTaskCompleted(success: true)
    }
    
    func scheduleBackgroundTask() {
        print("📅 Scheduling next background task...")
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: backgroundUpdateInterval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background task scheduled successfully")
        } catch {
            print("❌ Could not schedule background task: \(error)")
        }
    }
    
    private func registerForNotifications() {
        print("🔔 Requesting notification permissions...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Notification permission error: \(error)")
            }
        }
    }
    
    private func checkForMatches() {
        guard let focusNumber = focusNumberManager?.currentFocusNumber,
              let realmNumber = realmNumberManager?.currentRealmNumber,
              focusNumber == realmNumber else {
            return
        }
        
        print("🎯 Match found! Creating notification...")
        
        // Create and schedule notification for match
        let content = UNMutableNotificationContent()
        content.title = "Number Match! 🎯"
        content.body = "Your Focus Number (\(focusNumber)) matches your Realm Number!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                          content: content,
                                          trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Match notification scheduled successfully")
            }
        }
    }
} 
