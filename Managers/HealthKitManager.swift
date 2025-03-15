/**
 * Filename: HealthKitManager.swift
 * 
 * Purpose: Manages all interactions with HealthKit to retrieve health data,
 * particularly heart rate information for use in the app's calculations.
 *
 * Key responsibilities:
 * - Request authorization for HealthKit data access
 * - Monitor and retrieve heart rate data
 * - Manage background delivery of health data updates
 * - Track authorization status and handle permission changes
 * - Provide heart rate information to other components
 * 
 * This manager is central to the app's health data integration, providing
 * the real-time heart rate values needed for realm number calculations.
 */

import Foundation
import HealthKit
import Combine
import os
import UIKit
import os.log
import SwiftUI
import BackgroundTasks

// MARK: - HealthKitManager Implementation
/**
 * Core manager class for HealthKit operations and heart rate monitoring.
 *
 * This class is responsible for:
 * - Managing HealthKit authorization status
 * - Retrieving and monitoring heart rate data
 * - Setting up background delivery of health updates
 * - Publishing heart rate values to subscribers
 *
 * Design pattern: Singleton with protocol conformance for testing
 * Threading: Uses main thread for UI updates and background threads for HealthKit queries
 * Permissions: Requires explicit user authorization to access heart rate data
 */
@objc open class HealthKitManager: NSObject, ObservableObject, HealthKitManaging, @unchecked Sendable {
    // MARK: - Shared Instance
    /// Singleton instance for app-wide access to HealthKit functionality
    @objc public static let shared = HealthKitManager()
    
    // MARK: - Published Properties
    /// The current heart rate reading in beats per minute (BPM)
    @Published public private(set) var currentHeartRate: Int = 0
    
    /// The most recent valid heart rate reading (non-zero) in BPM
    @Published public private(set) var lastValidBPM: Int = 0
    
    /// Current authorization status for heart rate data access
    @Published public private(set) var authorizationStatus: HKAuthorizationStatus = .notDetermined
    
    /// Indicates whether the user needs to manually enable HealthKit in Settings
    @Published public private(set) var needsSettingsAccess: Bool = false
    
    /// Detailed authorization statuses for each health data type
    @Published private(set) var authorizationStatuses: [String: HKAuthorizationStatus] = [:]
    
    // MARK: - Notification Names
    /// Notification sent when heart rate data is updated
    public static let heartRateUpdated = Notification.Name("heartRateUpdated")
    
    // MARK: - Private Properties
    /// Core HealthKit store for accessing health data
    private let healthStore = HKHealthStore()
    
    /// Logger for HealthKit-related operations
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.infinitiesinn.vybe.VybeMVP", category: "HealthKit")
    
    /// Active query for heart rate monitoring
    private var heartRateQuery: HKQuery?
    
    /// Observer query for background updates
    private var observerQuery: HKObserverQuery?
    
    /// Timer for periodic heart rate updates
    private var updateTimer: Timer?
    
    /// Timestamp of the last heart rate update
    private var lastUpdateTime: Date?
    
    // MARK: - Initialization
    /**
     * Initializes the HealthKit manager and checks data availability.
     *
     * This initializer:
     * 1. Verifies that HealthKit is available on the device
     * 2. Checks the current authorization status
     * 3. Sets up the manager's initial state
     *
     * The initialization triggers an asynchronous check of permissions
     * but does not request authorization (that requires explicit user action).
     */
    public override init() {
        super.init()
        print("HealthKitManager initialized")
        
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available on this device")
            return
        }
        
        // Access HealthKit data types we need
        Task {
            do {
                try await checkAuthorizationStatus()
            } catch {
                print("Error checking authorization: \(error)")
            }
        }
    }
    
    // MARK: - Update Methods for Published Properties
    /**
     * Updates the current heart rate value.
     *
     * - Parameter value: The heart rate value in beats per minute, or nil if unavailable
     *
     * This method ensures updates occur on the main thread for thread safety
     * with SwiftUI's published properties.
     */
    internal func updateCurrentHeartRate(_ value: Double?) {
        DispatchQueue.main.async {
            self.currentHeartRate = Int(value ?? 0.0)
        }
    }
    
    /**
     * Updates the last valid BPM value.
     *
     * - Parameter value: The heart rate value in beats per minute
     *
     * This method updates the lastValidBPM property, which tracks
     * the most recent non-zero heart rate reading.
     */
    internal func updateLastValidBPM(_ value: Int) {
        DispatchQueue.main.async {
            self.lastValidBPM = value
        }
    }
    
    /**
     * Updates the authorization status for HealthKit access.
     *
     * - Parameter status: The current HealthKit authorization status
     *
     * This method ensures UI updates occur on the main thread.
     */
    internal func updateAuthorizationStatus(_ status: HKAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
    }
    
    /**
     * Updates whether Settings access is needed for permission changes.
     *
     * - Parameter value: Boolean indicating if Settings access is required
     *
     * This is set to true when permissions have been denied and the user
     * needs to manually enable them in the Settings app.
     */
    internal func updateNeedsSettingsAccess(_ value: Bool) {
        DispatchQueue.main.async {
            self.needsSettingsAccess = value
        }
    }
    
    // MARK: - Authorization and Status Methods
    /**
     * Checks the current authorization status for heart rate data.
     *
     * This asynchronous method:
     * 1. Retrieves the current authorization status from HealthKit
     * 2. Updates the published status property
     * 3. Sets the needsSettingsAccess flag if permissions were denied
     *
     * Throws an error if the HealthKit status check fails.
     */
    private func checkAuthorizationStatus() async throws {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let status = healthStore.authorizationStatus(for: heartRateType)
        
        updateAuthorizationStatus(status)
        
        print("Health data authorization status: \(status.rawValue)")
        
        if status == .sharingDenied {
            updateNeedsSettingsAccess(true)
        }
    }
    
    /**
     * Requests authorization to access heart rate data from HealthKit.
     *
     * This method:
     * 1. Defines the health data types needed (heart rate)
     * 2. Requests user permission via system dialog
     * 3. Updates the authorization status based on user's choice
     * 4. Sets up heart rate monitoring if authorized
     *
     * Throws an error if the authorization request fails.
     */
    public func requestAuthorization() async throws {
        print("\n=== HealthKitManager: Starting Authorization Process ===")
        
        // Verify bundle identifier
        print("📦 Bundle Identifier: \(Bundle.main.bundleIdentifier ?? "Unknown")")
        
        // First check if HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            print("❌ HealthKit is not available on this device")
            throw HealthKitError.notAvailable
        }
        
        // Verify entitlements
        if let entitlements = Bundle.main.object(forInfoDictionaryKey: "com.apple.developer.healthkit") as? Bool {
            print("✅ HealthKit entitlement found: \(entitlements)")
        } else {
            print("⚠️ HealthKit entitlement not found in Info.plist")
        }
        
        // Define heart rate type
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("❌ Heart rate type is not available")
            throw HealthKitError.heartRateNotAvailable
        }
        
        // Create sets for read and share permissions - focusing only on heart rate
        let typesToRead: Set<HKSampleType> = [heartRateType]
        let typesToShare: Set<HKSampleType> = [heartRateType]
        
        print("\n📊 Verifying current permissions...")
        let status = healthStore.authorizationStatus(for: heartRateType)
        print("- Heart Rate: \(describeAuthorizationStatus(status))")
        
        if status == .sharingAuthorized {
            print("  ✅ Already authorized")
            // If already authorized, start monitoring and return
            try await enableBackgroundDelivery()
            startHeartRateMonitoring()
            return
        }
        
        do {
            print("\n🔐 Requesting HealthKit Authorization...")
            
            // Request authorization with explicit error handling
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
                    if let error = error {
                        print("❌ Authorization error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if !success {
                        print("⚠️ Authorization request completed but returned false")
                        continuation.resume(throwing: HealthKitError.authorizationFailed(nil))
                        return
                    }
                    
                    print("✅ Authorization request completed with success")
                    continuation.resume()
                }
            }
            
            // Wait for system to process
            print("\n⏳ Waiting for system to process authorization...")
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            
            // Final status check
            let finalStatus = healthStore.authorizationStatus(for: heartRateType)
            print("\n📊 Final Authorization Status:")
            print("- Heart Rate: \(describeAuthorizationStatus(finalStatus))")
            
            // Update UI state
            await MainActor.run {
                authorizationStatuses = [heartRateType.identifier: finalStatus]
                authorizationStatus = finalStatus
                needsSettingsAccess = finalStatus != .sharingAuthorized
            }
            
            if finalStatus != .sharingAuthorized {
                print("\n❌ Heart rate access was not authorized")
                throw HealthKitError.authorizationFailed(nil)
            }
            
            print("\n✅ Heart rate authorization successful")
            try await enableBackgroundDelivery()
            startHeartRateMonitoring()
            
        } catch {
            print("\n❌ Authorization failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func describeAuthorizationStatus(_ status: HKAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Not Determined"
        case .sharingDenied:
            return "Sharing Denied"
        case .sharingAuthorized:
            return "Sharing Authorized"
        @unknown default:
            return "Unknown"
        }
    }
    
    // MARK: - Heart Rate Monitoring
    /**
     * Begins monitoring heart rate data from HealthKit.
     *
     * This method:
     * 1. Verifies that HealthKit is available and authorized
     * 2. Sets up an observer for heart rate changes
     * 3. Configures background delivery for continuous updates
     *
     * This is typically called after successful authorization
     * or when the app becomes active again after being in the background.
     */
    public func startHeartRateMonitoring() {
        guard HKHealthStore.isHealthDataAvailable(),
              authorizationStatus == .sharingAuthorized else {
            print("Cannot start monitoring: Health data not available or not authorized")
            return
        }
        
        print("Starting heart rate monitoring")
        
        setupHeartRateObserver()
        setupBackgroundDelivery()
    }
    
    /**
     * Configures an observer query to monitor heart rate changes.
     *
     * This method:
     * 1. Creates an HKObserverQuery for heart rate samples
     * 2. Sets up a callback to fetch the latest heart rate when changes occur
     * 3. Executes the query against the HealthKit store
     *
     * The observer triggers background fetches when new heart rate 
     * data becomes available, even when the app is not active.
     */
    private func setupHeartRateObserver() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Create observer query for background updates
        observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] (query, completionHandler, error) in
            if let error = error {
                print("Heart rate observer error: \(error)")
                completionHandler()
                return
            }
            
            Task {
                do {
                    try await self?.fetchLatestHeartRate()
                } catch {
                    print("Error fetching heart rate in observer: \(error)")
                }
                completionHandler()
            }
        }
        
        // Execute the query
        if let observerQuery = observerQuery {
            healthStore.execute(observerQuery)
            print("Heart rate observer query started")
        }
    }
    
    /**
     * Configures background delivery for heart rate updates.
     *
     * This method enables the app to receive heart rate data updates
     * even when the app is in the background or not actively running.
     * It uses HealthKit's background delivery feature with immediate
     * frequency to ensure timely updates.
     *
     * Requires proper background modes to be configured in the app's
     * capabilities and Info.plist file.
     */
    private func setupBackgroundDelivery() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Enable background delivery for heart rate
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
            if success {
                print("Background delivery enabled for heart rate")
            } else if let error = error {
                print("Failed to enable background delivery: \(error)")
            }
        }
    }
    
    /**
     * Stops monitoring heart rate data from HealthKit.
     *
     * This method:
     * 1. Stops any active observer queries
     * 2. Disables background delivery for heart rate data
     * 3. Cleans up internal query references
     *
     * Typically called when the app is being terminated or
     * when heart rate monitoring is no longer needed.
     */
    public func stopHeartRateMonitoring() {
        print("Stopping heart rate monitoring")
        
        // Stop observer query
        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
            self.observerQuery = nil
            print("Heart rate observer stopped")
        }
        
        // Disable background delivery
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.disableBackgroundDelivery(for: heartRateType) { (success, error) in
            if success {
                print("Background delivery disabled for heart rate")
            } else if let error = error {
                print("Failed to disable background delivery: \(error)")
            }
        }
    }
    
    // MARK: - Heart Rate Data Fetching
    /**
     * Explicitly requests an immediate heart rate update.
     *
     * This public method triggers a manual fetch of the latest heart rate
     * data from HealthKit. It can be called when the app needs the most
     * current heart rate reading outside of the regular background updates.
     *
     * Typically used when the app becomes active or when a specific feature
     * requires the most up-to-date heart rate value.
     */
    public func forceHeartRateUpdate() async {
        print("Forcing heart rate update")
        
        do {
            try await fetchLatestHeartRate()
        } catch {
            print("Error forcing heart rate update: \(error)")
        }
    }
    
    /**
     * Retrieves the most recent heart rate reading from HealthKit.
     *
     * This method:
     * 1. Verifies HealthKit is available and authorized
     * 2. Creates a query for the most recent heart rate sample
     * 3. Executes the query against the HealthKit store
     * 4. Processes the result and updates the published heart rate value
     * 5. Notifies observers via a notification
     *
     * The method uses a limit of 1 and sorts by end date to ensure
     * only the most recent reading is retrieved.
     *
     * Throws an error if the health data is not available or authorized.
     */
    private func fetchLatestHeartRate() async throws {
        guard HKHealthStore.isHealthDataAvailable(),
              authorizationStatus == .sharingAuthorized else {
            print("Cannot fetch heart rate: Health data not available or not authorized")
            return
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Get the most recent heart rate reading
        let predicate = HKQuery.predicateForSamples(
            withStart: Date.distantPast,
            end: Date(),
            options: .strictEndDate
        )
        
        // Sort by date to get the most recent
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sortDescriptor]
        ) { [weak self] (query, samples, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error querying heart rate: \(error)")
                return
            }
            
            guard let samples = samples, let sample = samples.first as? HKQuantitySample else {
                print("No heart rate samples available")
                return
            }
            
            // Get heart rate in beats per minute
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            
            print("Latest heart rate: \(heartRate) BPM")
            
            // Update state on main thread
            DispatchQueue.main.async {
                self.updateCurrentHeartRate(heartRate)
                
                if heartRate > 0 {
                    self.updateLastValidBPM(Int(heartRate))
                }
                
                // Post notification of heart rate update for observers
                NotificationCenter.default.post(
                    name: Self.heartRateUpdated,
                    object: heartRate,
                    userInfo: ["heartRate": heartRate]
                )
            }
        }
        
        healthStore.execute(query)
    }
    
    public func fetchInitialHeartRate() async {
        print("Fetching initial heart rate")
        
        do {
            try await fetchLatestHeartRate()
        } catch {
            print("Error fetching initial heart rate: \(error)")
        }
    }
    
    /**
     * Enables background delivery for heart rate data updates.
     *
     * This asynchronous method:
     * 1. Configures HealthKit to deliver heart rate updates in the background
     * 2. Sets the frequency to immediate for real-time monitoring
     * 3. Returns a continuation when the setup is complete or throws an error
     *
     * Background delivery is essential for maintaining continuous heart rate
     * monitoring even when the app is not in the foreground.
     *
     * Throws an error if heart rate type is not available or if background
     * delivery cannot be enabled.
     */
    private func enableBackgroundDelivery() async throws {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.heartRateNotAvailable
        }
        
        print("\n🔄 Setting up background delivery...")
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if !success {
                    continuation.resume(throwing: HealthKitError.requiresBackgroundAccess)
                } else {
                    print("✅ Background delivery enabled successfully")
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Settings Access
    /**
     * Opens the Health app settings to allow the user to modify permissions.
     *
     * This method uses a deep link to the Health app, enabling users to
     * directly access their health data sharing settings when permissions
     * need to be granted or modified.
     */
    func openHealthAppSettings() {
        if let url = URL(string: "x-apple-health://") {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     * Opens the app's settings page in the iOS Settings app.
     *
     * This method directs users to the app's settings page where they can
     * modify permissions, notifications, and other app-specific settings.
     * Useful when the app needs system-level permission changes.
     */
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     * Checks if heart rate permission has been granted.
     *
     * This helper method quickly determines if the app has the necessary
     * authorization to access heart rate data without going through the
     * full authorization process.
     *
     * Returns true if heart rate access is authorized, false otherwise.
     */
    func checkHeartRatePermission() -> Bool {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return false }
        return healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized
    }
    
    /**
     * Returns the current heart rate value.
     *
     * This convenience method provides the current heart rate as a Double,
     * allowing for easier use in calculations where Double precision is needed.
     *
     * Returns the current heart rate in beats per minute.
     */
    func getCurrentHeartRate() -> Double {
        return Double(currentHeartRate)
    }
    
    // MARK: - Heart Rate Analytics
    /**
     * Represents a point in the heart rate trend analysis.
     *
     * This structure pairs a heart rate reading with its timestamp
     * to enable time-based trend analysis.
     */
    private struct HeartRateTrend {
        let timestamp: Date
        let bpm: Double
    }
    
    /// Collection of recent heart rate readings for trend analysis
    private var recentHeartRates: [HeartRateTrend] = []
    
    /// Maximum number of data points to retain for trend analysis
    private let maxTrendDataPoints = 10
    
    /**
     * Updates the heart rate trend analysis with a new reading.
     *
     * This method:
     * 1. Adds the new heart rate reading to the trend collection
     * 2. Maintains a maximum number of data points by removing older readings
     * 3. Triggers analysis of the trend to detect significant changes
     *
     * - Parameter bpm: The heart rate in beats per minute to add to the trend
     */
    private func updateHeartRateTrend(_ bpm: Double) {
        let trend = HeartRateTrend(timestamp: Date(), bpm: bpm)
        recentHeartRates.append(trend)
        
        // Keep only the most recent data points
        if recentHeartRates.count > maxTrendDataPoints {
            recentHeartRates.removeFirst()
        }
        
        analyzeTrend()
    }
    
    /**
     * Analyzes recent heart rate readings to detect significant changes.
     *
     * This method:
     * 1. Requires at least 3 data points for meaningful analysis
     * 2. Calculates the rate of change in BPM over time
     * 3. Identifies significant changes (more than 5 BPM per minute)
     * 4. Logs important trends for debugging and analysis
     *
     * The analysis helps in identifying potential health events or
     * exercise intensity changes that may be relevant for the app's
     * functionality.
     */
    private func analyzeTrend() {
        guard recentHeartRates.count >= 3 else { return }
        
        // Calculate rate of change
        let latestPoints = Array(recentHeartRates.suffix(3))
        let timeDeltas = zip(latestPoints, latestPoints.dropFirst()).map { $0.1.timestamp.timeIntervalSince($0.0.timestamp) }
        let bpmDeltas = zip(latestPoints, latestPoints.dropFirst()).map { $0.1.bpm - $0.0.bpm }
        
        // Calculate average rate of change (bpm per minute)
        let rateOfChange = zip(bpmDeltas, timeDeltas).map { $0.0 / $0.1 * 60.0 }.reduce(0.0, +) / Double(bpmDeltas.count)
        
        // Log significant changes
        if abs(rateOfChange) > 5.0 {  // More than 5 bpm per minute
            os_log("Significant heart rate change detected: %.1f bpm/min", log: logger, type: .info, rateOfChange)
        }
    }
    
    /**
     * Updates the current heart rate value and triggers analytics.
     *
     * This comprehensive method:
     * 1. Updates the current heart rate property
     * 2. Updates the last valid reading (if non-zero)
     * 3. Adds the new reading to trend analysis
     * 4. Posts a notification for observers
     *
     * - Parameter bpm: The new heart rate value in beats per minute
     */
    private func updateHeartRate(_ bpm: Double) {
        currentHeartRate = Int(bpm)
        lastValidBPM = Int(bpm)
        updateHeartRateTrend(bpm)  // Add trend analysis
        
        // Post notification for other components
        NotificationCenter.default.post(
            name: Self.heartRateUpdated,
            object: bpm
        )
    }
}

// MARK: - Error Types
/**
 * Custom error types for HealthKit operations.
 *
 * This enum provides specific error cases for HealthKit interactions,
 * offering detailed explanations and recovery suggestions for each error.
 * It conforms to LocalizedError to provide user-friendly error messages.
 *
 * These errors help in diagnosing issues with HealthKit access, permissions,
 * and configuration throughout the app.
 */
enum HealthKitError: LocalizedError {
    /// HealthKit framework is not available on the current device
    case notAvailable
    
    /// Heart rate data specifically is not available
    case heartRateNotAvailable
    
    /// Authorization request failed with an optional underlying error
    case authorizationFailed(Error?)
    
    /// HealthKit capability is not properly configured in the app
    case capabilityMissing
    
    /// User has not yet made a decision about HealthKit access
    case notDetermined
    
    /// User has explicitly denied access to health data
    case denied
    
    /// App lacks the necessary background modes for continuous monitoring
    case requiresBackgroundAccess
    
    /// All requested HealthKit access has been denied
    case allAccessDenied
    
    /// User-friendly error description for display in the app
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .heartRateNotAvailable:
            return "Heart rate monitoring is not available"
        case .authorizationFailed(let error):
            return "HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")"
        case .capabilityMissing:
            return "HealthKit capability is not enabled in Xcode"
        case .notDetermined:
            return "HealthKit authorization status is not determined"
        case .denied:
            return """
            Heart rate access was denied. To enable:
            1. Open the Health app
            2. Tap 'Browse' at the bottom
            3. Search for 'Heart Rate'
            4. Scroll down to 'Data Sources & Access'
            5. Find and tap VybeMVP
            6. Enable heart rate permissions
            
            Or tap 'Open Settings' below to go directly to the Health app.
            """
        case .requiresBackgroundAccess:
            return "Background access is required for heart rate monitoring"
        case .allAccessDenied:
            return "Heart rate permission was denied"
        }
    }
}
