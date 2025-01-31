import Foundation
import BackgroundTasks
import UserNotifications
import UIKit

class BackgroundManager: NSObject, ObservableObject {
    static let shared = BackgroundManager()
    private let backgroundTaskIdentifier = "com.infinitiesinn.vybe.backgroundUpdate"
    
    // Reference to other managers - using weak to avoid retain cycles
    private weak var realmNumberManager: RealmNumberManager?
    private weak var focusNumberManager: FocusNumberManager?
    private var activeTimer: Timer?
    
    // Update intervals with tolerance for better battery life
    private let activeUpdateInterval: TimeInterval = 60 // 1 minute for active app
    private let backgroundUpdateInterval: TimeInterval = 15 * 60 // 15 minutes for background
    private let timerTolerance: TimeInterval = 0.1 * 60 // 10% of a minute
    
    // Track background task for proper cleanup
    private var backgroundTask: BGAppRefreshTask?
    
    private override init() {
        super.init()
        print("🔄 Initializing BackgroundManager...")
        setupNotifications()
        
        // Clear badge count when app starts
        clearBadgeCount()
        
        // Register for app lifecycle notifications using weak self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        stopActiveUpdates()
        NotificationCenter.default.removeObserver(self)
        backgroundTask?.setTaskCompleted(success: true)
        backgroundTask = nil
    }
    
    @objc private func appDidBecomeActive() {
        // Clear badge count when app becomes active
        clearBadgeCount()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func clearBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("❌ Failed to clear badge count: \(error.localizedDescription)")
            } else {
                print("✅ Badge count cleared successfully")
            }
        }
    }
    
    private func setupNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        // Define notification categories and actions
        let matchCategory = UNNotificationCategory(
            identifier: "MATCH_NOTIFICATION",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        notificationCenter.setNotificationCategories([matchCategory])
        registerForNotifications()
    }
    
    func setManagers(realm: RealmNumberManager?, focus: FocusNumberManager?) {
        self.realmNumberManager = realm
        self.focusNumberManager = focus
        print("✅ Managers set successfully")
        
        // Start active updates immediately
        startActiveUpdates()
    }
    
    // Start frequent updates when app is active
    func startActiveUpdates() {
        print("\n⚡️ Starting active updates...")
        print("   Update interval: \(activeUpdateInterval) seconds")
        print("   Timer tolerance: \(timerTolerance) seconds")
        
        stopActiveUpdates() // Clear any existing timer
        
        // Perform initial update
        performUpdate()
        
        // Set up timer for frequent updates with tolerance
        activeTimer = Timer.scheduledTimer(withTimeInterval: activeUpdateInterval, repeats: true) { [weak self] _ in
            self?.performUpdate()
        }
        activeTimer?.tolerance = timerTolerance
        
        if activeTimer != nil {
            print("✅ Active timer started successfully")
        } else {
            print("❌ Failed to start active timer")
        }
    }
    
    // Stop frequent updates with proper cleanup
    func stopActiveUpdates() {
        print("\n🛑 Stopping active updates")
        if activeTimer != nil {
            activeTimer?.invalidate()
            activeTimer = nil
            print("✅ Active timer stopped successfully")
        }
    }
    
    // Common update logic with proper error handling
    private func performUpdate() {
        print("\n🔄 Performing update...")
        
        guard let realmManager = realmNumberManager else {
            print("⚠️ RealmNumberManager not available")
            return
        }
        
        if realmManager.currentState == .stopped {
            print("⚠️ RealmManager is stopped - restarting...")
            realmManager.startUpdates()
        }
        
        realmManager.calculateRealmNumber()
        checkForMatches()
        
        print("✅ Update completed successfully")
    }
    
    func handleBackgroundTask(_ task: BGAppRefreshTask) {
        print("\n🔄 Handling background task...")
        backgroundTask = task
        
        // Set up task expiration
        task.expirationHandler = { [weak self] in
            print("⚠️ Background task expired")
            self?.stopActiveUpdates()
            task.setTaskCompleted(success: false)
        }
        
        // Perform update with timeout
        let taskTimeout = DispatchTime.now() + .seconds(25) // 25 second timeout
        DispatchQueue.global().asyncAfter(deadline: taskTimeout) { [weak self] in
            if self?.backgroundTask === task {
                print("⚠️ Background task timed out")
                self?.stopActiveUpdates()
                task.setTaskCompleted(success: false)
            }
        }
        
        // Perform update
        performUpdate()
        
        // Schedule next background refresh
        scheduleBackgroundTask()
        
        // Mark task as completed
        task.setTaskCompleted(success: true)
        backgroundTask = nil
        print("✅ Background task completed successfully")
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
        print("\n🔔 Requesting notification permissions...")
        
        // First check current authorization status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("📱 Current notification settings:")
            print("   Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("   Alert Setting: \(settings.alertSetting.rawValue)")
            print("   Sound Setting: \(settings.soundSetting.rawValue)")
            print("   Badge Setting: \(settings.badgeSetting.rawValue)")
            
            // If not determined, request authorization
            if settings.authorizationStatus == .notDetermined {
                self.requestNotificationPermissions()
            } else if settings.authorizationStatus == .denied {
                print("❌ Notifications are disabled in system settings")
            } else {
                print("✅ Notifications are already authorized")
            }
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted by user")
            } else {
                print("❌ Notification permission denied by user")
                if let error = error {
                    print("   Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func checkForMatches() {
        guard let focusManager = focusNumberManager,
              let realmManager = realmNumberManager else {
            print("❌ Managers not initialized")
            return
        }
        
        print("\n🔍 Checking for matches...")
        print("   Focus Number: \(focusManager.selectedFocusNumber)")
        print("   Realm Number: \(realmManager.currentRealmNumber)")
        print("   Realm Manager State: \(realmManager.currentState.rawValue)")
        
        // Additional validation checks
        guard realmManager.currentState == .active,
              focusManager.selectedFocusNumber > 0,
              realmManager.currentRealmNumber > 0,
              focusManager.selectedFocusNumber == realmManager.currentRealmNumber else {
            if realmManager.currentState != .active {
                print("   ⚠️ No match - Realm Manager not active")
            }
            if focusManager.selectedFocusNumber == 0 {
                print("   ⚠️ No match - Invalid Focus Number (0)")
            }
            if realmManager.currentRealmNumber == 0 {
                print("   ⚠️ No match - Invalid Realm Number (0)")
            }
            if focusManager.selectedFocusNumber != realmManager.currentRealmNumber {
                print("   ⚠️ No match - Numbers don't match")
            }
            return
        }
        
        // Verify the match with FocusNumberManager
        focusManager.verifyAndSaveMatch(realmNumber: realmManager.currentRealmNumber) { matchVerified in
            if matchVerified {
                print("🎯 Match verified! Creating notification...")
                
                // Check notification settings before creating
                UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                    guard settings.authorizationStatus == .authorized else {
                        print("❌ Cannot send notification - not authorized")
                        return
                    }
                    
                    // Create and schedule notification for match
                    self?.optimizedMatchNotification(
                        focusNumber: focusManager.selectedFocusNumber,
                        realmNumber: realmManager.currentRealmNumber
                    )
                }
            } else {
                print("❌ Match verification failed")
            }
        }
    }
    
    private func optimizedMatchNotification(focusNumber: Int, realmNumber: Int) {
        batchNotificationUpdates { batch in
            // Clear existing notifications
            batch.add { [weak self] in
                self?.clearNotifications()
            }
            
            // Prepare new notification
            batch.add { [weak self] in
                self?.prepareMatchNotification(focusNumber: focusNumber, realmNumber: realmNumber)
            }
            
            batch.setCompletion {
                print("✅ Notification batch completed successfully")
            }
        }
    }
    
    private func prepareMatchNotification(focusNumber: Int, realmNumber: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Number Match! 🎯"
        content.body = "Your Focus Number (\(focusNumber)) matches the Realm Number!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "MATCH_NOTIFICATION"
        
        // Use calendar-based trigger for better system optimization
        var components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        components.second = 0 // Align to minute boundary
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "match_notification_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled successfully")
            }
        }
    }
    
    private func clearNotifications() {
        clearBadgeCount()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Notification Management
    private final class NotificationBatch {
        private var operations: [() -> Void] = []
        private var completion: (() -> Void)?
        
        init(capacity: Int = 2) {
            operations.reserveCapacity(capacity)
        }
        
        func add(_ operation: @escaping () -> Void) {
            operations.append(operation)
        }
        
        func setCompletion(_ completion: (() -> Void)?) {
            self.completion = completion
        }
        
        func execute() {
            guard !operations.isEmpty else { return }
            
            DispatchQueue.main.async { [operations, completion] in
                operations.forEach { $0() }
                completion?()
            }
        }
    }
    
    private func batchNotificationUpdates(_ updates: (NotificationBatch) -> Void) {
        let batch = NotificationBatch()
        updates(batch)
        batch.execute()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension BackgroundManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification response
        completionHandler()
    }
} 
