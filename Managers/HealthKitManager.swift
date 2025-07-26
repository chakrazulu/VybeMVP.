/**
 * Filename: HealthKitManager.swift
 * 
 * 🎯 COMPREHENSIVE MANAGER REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Central hub for all HealthKit interactions, primarily heart rate monitoring.
 * This manager bridges Apple HealthKit with VybeMVP's mystical calculations.
 * 
 * === KEY RESPONSIBILITIES ===
 * • Request and manage HealthKit authorization
 * • Monitor real-time heart rate data from Apple Watch/iPhone
 * • Provide fallback simulation when HealthKit unavailable
 * • Background delivery of health updates
 * • Thread-safe publishing of heart rate values
 * • Integration with RealmNumberManager calculations
 * 
 * === PUBLISHED PROPERTIES ===
 * • currentHeartRate: Int - Current BPM (real or simulated)
 * • lastValidBPM: Int - Most recent non-zero reading
 * • authorizationStatus: HKAuthorizationStatus - Permission state
 * • needsSettingsAccess: Bool - User needs manual Settings enable
 * • isHeartRateSimulated: Bool - Data source indicator
 * 
 * === HEART RATE PRIORITY SYSTEM ===
 * 1. Real HealthKit data (Apple Watch/iPhone sensors)
 * 2. Cached real data (when temporarily unavailable)
 * 3. Simulated data (testing/fallback mode)
 * 4. Default: 72 BPM (average resting rate)
 * 
 * === AUTHORIZATION FLOW ===
 * 1. Check if HealthKit available on device
 * 2. Verify app entitlements and permissions
 * 3. Request user authorization via system dialog
 * 4. Handle approval/denial gracefully
 * 5. Enable background delivery if authorized
 * 6. Start observer queries for live updates
 * 
 * === BACKGROUND MONITORING ===
 * • HKObserverQuery: Detects new heart rate samples
 * • Background delivery: Updates even when app closed
 * • Immediate frequency: Real-time responsiveness
 * • Automatic fallback: Simulation if unavailable
 * 
 * === SIMULATION SYSTEM ===
 * • Enabled when: No HealthKit, no authorization, testing
 * • Range: 60-120 BPM realistic variations
 * • Timer: Updates every 10-30 seconds
 * • UserDefaults: Remembers simulation preference
 * 
 * === THREAD SAFETY ===
 * • All published property updates on main thread
 * • HealthKit queries on background threads
 * • @unchecked Sendable for cross-thread safety
 * • DispatchQueue.main.async for UI updates
 * 
 * === NOTIFICATION INTEGRATION ===
 * • Sends: HealthKitManager.heartRateUpdated
 * • UserInfo: ["heartRate": Int] for subscribers
 * • Used by: RealmNumberManager, VybeMatchManager
 * 
 * === ERROR HANDLING ===
 * • HealthKitError enum for specific failures
 * • Graceful fallback to simulation
 * • Detailed logging for debugging
 * • User-friendly error messages
 * 
 * === TESTING SUPPORT ===
 * • HealthKitManaging protocol for mocking
 * • Simulation mode toggle
 * • Force update methods
 * • Isolated test instances
 * 
 * === CRITICAL PERFORMANCE NOTES ===
 * • Background delivery requires proper entitlements
 * • Observer queries auto-resume on app activation
 * • Simulation timer invalidated on real data
 * • Memory efficient with weak self references
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
    
    /// Flag to indicate whether the heart rate is from a real device or simulated
    @Published public private(set) var isHeartRateSimulated: Bool = true
    
    /// The last real (non-simulated) heart rate reading from HealthKit
    private var lastRealHeartRate: Int = 0
    
    /// Flag to control whether simulation is allowed
    private var simulationEnabled: Bool = true
    
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
    
    /// Timer for simulating heart rate data
    private var simulationTimer: Timer?
    
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
        
        // Load simulation preference from UserDefaults
        let simulationPreference = UserDefaults.standard.bool(forKey: "HeartRateSimulationEnabled")
        simulationEnabled = simulationPreference
        isHeartRateSimulated = simulationPreference
        
        if simulationPreference {
            print("🔄 Heart rate simulation ENABLED from saved preferences")
        }
        
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available on this device")
            // Only start simulation if HealthKit is not available
            enableSimulationMode(true)
            simulateHeartRateForTesting()
            return
        }
        
        // Access HealthKit data types we need
        Task {
            do {
                try await checkAuthorizationStatus()
                
                // If we have authorization, immediately start monitoring and force an update
                if authorizationStatus == .sharingAuthorized {
                    // startHeartRateMonitoring() // REMOVED: Call moved to AppDelegate Task
                    let success = await forceHeartRateUpdate()
                    
                    // Only enable simulation if we couldn't get real data and simulation is enabled in preferences
                    if !success && simulationEnabled {
                        print("⚠️ Could not get real heart rate data, enabling simulation mode")
                        enableSimulationMode(true)
                        simulateHeartRateForTesting()
                    } else if success {
                        enableSimulationMode(false)
                    }
                } else if simulationEnabled {
                    // No HealthKit authorization but simulation is enabled
                    print("⚠️ No HealthKit authorization, enabling simulation mode")
                    enableSimulationMode(true)
                    simulateHeartRateForTesting()
                }
            } catch {
                print("Error checking authorization: \(error)")
                // Enable simulation on error if preferences allow
                if simulationEnabled {
                    enableSimulationMode(true)
                    simulateHeartRateForTesting()
                }
            }
        }
    }
    
    // MARK: - Update Methods for Published Properties
    /**
     * Updates the current heart rate value.
     *
     * - Parameter value: The heart rate value in beats per minute, or nil if unavailable
     * - Parameter fromSimulation: Boolean indicating if the value is from a simulated source
     *
     * This method ensures updates occur on the main thread for thread safety
     * with SwiftUI's published properties.
     */
    internal func updateCurrentHeartRate(_ value: Double?, fromSimulation: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let previousValue = self.currentHeartRate
            let newValue = Int(value ?? 0.0)
            
            if !fromSimulation {
                // This is a real heart rate from HealthKit
                if newValue > 0 {
                    self.lastRealHeartRate = newValue
                    self.isHeartRateSimulated = false
                    print("❤️ Real heart rate updated: \(newValue) BPM")
                }
            }
            
            // Always update the current value
            self.currentHeartRate = newValue
            
            // Log change if there was one
            if previousValue != newValue {
                print("\(fromSimulation ? "🔄 Simulated" : "❤️ Real") heart rate: \(newValue) BPM")
            }
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
        DispatchQueue.main.async { [weak self] in
            self?.lastValidBPM = value
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
        // print("➡️ HealthKitManager: Entering startHeartRateMonitoring()") // REMOVED Debug log
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Only proceed with real HealthKit queries if available and authorized
        guard HKHealthStore.isHealthDataAvailable(),
              healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized else {
            // print("❌ HealthKitManager: Exiting startHeartRateMonitoring early. Reason: Health data available=\(HKHealthStore.isHealthDataAvailable()), Authorized=\(healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized)") // REMOVED Debug log
            print("Using simulated heart rate data instead")
            enableSimulationMode(true)
            simulateHeartRateForTesting()
            return
        }
        
        // Try to start real monitoring
        setupHeartRateObserver()
        setupBackgroundDelivery()
        
        // Prioritize real data - keep simulation disabled by default
        enableSimulationMode(false)
        
        // Force an update to get real data, but don't automatically enable simulation
        // if we don't find data immediately
        Task {
            print("❤️ Attempting to get initial real heart rate data...")
            let success = await forceHeartRateUpdate()
            
            if success {
                print("✅ Successfully retrieved initial real heart rate data")
            } else {
                print("⚠️ Initial attempt to get real heart rate data unsuccessful. Will rely on observer query.")
            }
        }
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
                    if let self = self {
                        _ = try await self.fetchLatestHeartRate()
                    }
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
     * 
     * Returns: A Boolean indicating whether the heart rate update was successful
     */
    public func forceHeartRateUpdate() async -> Bool {
        print("Forcing heart rate update")
        
        // First try to directly access the most recent samples (last minute)
        do {
            let success = try await fetchMostRecentHeartRate(timeWindowSeconds: 60)
            if success {
                print("✅ Retrieved very recent heart rate data")
                return true
            }
            
            // If no recent data found, try a longer time window
            print("⚠️ No heart rate data in the last minute, trying last 5 minutes...")
            let fallbackSuccess = try await fetchMostRecentHeartRate(timeWindowSeconds: 300)
            if fallbackSuccess {
                print("✅ Retrieved heart rate data from last 5 minutes")
                return true
            }
            
            // If still no data, fall back to the regular method with 1-hour window
            print("⚠️ No heart rate data in the last 5 minutes, trying standard method...")
            return try await fetchLatestHeartRate()
        } catch {
            print("Error forcing heart rate update: \(error)")
            
            // Try the older method as a fallback
            do {
                return try await fetchLatestHeartRate()
            } catch {
                print("Error in fallback heart rate update: \(error)")
                return false
            }
        }
    }
    
    /**
     * Attempts to fetch very recent heart rate data within a specified time window
     * This method provides more aggressive, real-time heart rate fetching for 
     * immediate updates rather than historical analysis
     */
    private func fetchMostRecentHeartRate(timeWindowSeconds: Double) async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable(),
              healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!) == .sharingAuthorized else {
            print("Cannot fetch heart rate: Health data not available or not authorized")
            return false
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Create a much shorter time window for more recent data
        let recentTimeWindow = Date().addingTimeInterval(-timeWindowSeconds)
        
        print("❤️ Aggressively fetching heart rate data from the last \(Int(timeWindowSeconds)) seconds...")
        
        // Get the most recent heart rate reading with a tighter time window
        let predicate = HKQuery.predicateForSamples(
            withStart: recentTimeWindow,
            end: Date(),
            options: .strictEndDate
        )
        
        // Create a task and continuation to handle the async query
        return try await withCheckedThrowingContinuation { continuation in
            // Sort by date to get the most recent
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: 5, // Just need a few samples from this short window
                sortDescriptors: [sortDescriptor]
            ) { [weak self] (query, samples, error) in
                guard let self = self else {
                    print("❌ Self reference lost during heart rate query")
                    continuation.resume(returning: false)
                    return
                }
                
                if let error = error {
                    print("❌ Error querying recent heart rate: \(error)")
                    continuation.resume(returning: false)
                    return
                }
                
                guard let samples = samples, !samples.isEmpty else {
                    print("❌ No heart rate samples found in the last \(Int(timeWindowSeconds)) seconds")
                    continuation.resume(returning: false)
                    return
                }
                
                print("✅ Found \(samples.count) very recent heart rate samples")
                
                // Get the most recent sample
                guard let sample = samples.first as? HKQuantitySample else {
                    print("❌ Cannot convert heart rate sample to HKQuantitySample")
                    continuation.resume(returning: false)
                    return
                }
                
                // Get heart rate in beats per minute
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                
                // Calculate how old the sample is - should be very recent now
                let sampleAge = Date().timeIntervalSince(sample.endDate)
                let ageMinutes = Int(sampleAge / 60)
                let ageSeconds = Int(sampleAge) % 60
                
                print("❤️ Latest REAL heart rate: \(heartRate) BPM (from \(ageMinutes)m \(ageSeconds)s ago)")
                
                // Update state on main thread (marking as not from simulation)
                DispatchQueue.main.async {
                    self.updateCurrentHeartRate(heartRate, fromSimulation: false)
                    
                    if heartRate > 0 {
                        self.updateLastValidBPM(Int(heartRate))
                        self.lastRealHeartRate = Int(heartRate)
                        self.isHeartRateSimulated = false
                    }
                    
                    // Post notification of heart rate update for observers
                    NotificationCenter.default.post(
                        name: Self.heartRateUpdated,
                        object: self,
                        userInfo: ["heartRate": Int(heartRate), "isSimulated": false]
                    )
                }
                
                continuation.resume(returning: true)
            }
            
            healthStore.execute(query)
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
    @discardableResult
    public func fetchLatestHeartRate() async throws -> Bool {
        // Check if we've recently fetched heart rate data (within the last 30 seconds)
        // to avoid too frequent queries to HealthKit which drain battery
        if let lastUpdate = lastUpdateTime, Date().timeIntervalSince(lastUpdate) < 30 {
            print("⏱ Skipping heart rate fetch - performed too recently")
            return true // Return success without fetching to avoid redundant queries
        }
        
        // Update the time of the last fetch attempt *after* the throttle check
        lastUpdateTime = Date()
        
        guard HKHealthStore.isHealthDataAvailable(),
              healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!) == .sharingAuthorized else {
            print("Cannot fetch heart rate: Health data not available or not authorized")
            return false
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Get heart rate readings from the past hour instead of just the latest
        let oneHourAgo = Date().addingTimeInterval(-3600)
        
        print("❤️ Fetching heart rate data from the past hour...")
        
        // Get the most recent heart rate reading
        let predicate = HKQuery.predicateForSamples(
            withStart: oneHourAgo,
            end: Date(),
            options: .strictEndDate
        )
        
        // Create a task and continuation to handle the async query
        return try await withCheckedThrowingContinuation { continuation in
            // Sort by date to get the most recent
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: 10, // Get up to 10 recent readings instead of just 1
                sortDescriptors: [sortDescriptor]
            ) { [weak self] (query, samples, error) in
                guard let self = self else {
                    print("❌ Self reference lost during heart rate query")
                    continuation.resume(returning: false)
                    return
                }
                
                if let error = error {
                    print("❌ Error querying heart rate: \(error)")
                    continuation.resume(returning: false)
                    return
                }
                
                guard let samples = samples, !samples.isEmpty else {
                    print("❌ No heart rate samples available from HealthKit in the past hour")
                    continuation.resume(returning: false)
                    return
                }
                
                // Don't log every time if we get expected results
                print("✅ Found \(samples.count) heart rate samples from HealthKit")
                
                // Get the most recent sample
                guard let sample = samples.first as? HKQuantitySample else {
                    print("❌ Cannot convert heart rate sample to HKQuantitySample")
                    continuation.resume(returning: false)
                    return
                }
                
                // Get heart rate in beats per minute
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                
                // Calculate how old the sample is
                let sampleAge = Date().timeIntervalSince(sample.endDate)
                let ageMinutes = Int(sampleAge / 60)
                let ageSeconds = Int(sampleAge) % 60
                
                // Only log detailed info if the heart rate has changed significantly
                let hasSignificantChange = abs(Double(self.currentHeartRate) - heartRate) >= 5.0
                
                if hasSignificantChange {
                    print("❤️ Latest REAL heart rate from HealthKit: \(heartRate) BPM (from \(ageMinutes)m \(ageSeconds)s ago)")
                }
                
                // Check if the sample is very recent (less than 5 minutes old)
                let isRecent = sampleAge < 300 // 5 minutes
                
                if !isRecent && hasSignificantChange {
                    print("⚠️ Heart rate data is \(ageMinutes) minutes old - may not be current")
                }
                
                // Update state on main thread (marking as not from simulation)
                DispatchQueue.main.async {
                    self.updateCurrentHeartRate(heartRate, fromSimulation: false)
                    
                    if heartRate > 0 {
                        self.updateLastValidBPM(Int(heartRate))
                        self.lastRealHeartRate = Int(heartRate)
                        self.isHeartRateSimulated = false
                        
                        // Only post notification if the heart rate has changed significantly
                        if hasSignificantChange {
                            // Post notification of heart rate update for observers
                            NotificationCenter.default.post(
                                name: Self.heartRateUpdated,
                                object: self,
                                userInfo: ["heartRate": Int(heartRate), "isSimulated": false]
                            )
                        }
                    }
                }
                
                continuation.resume(returning: true)
            }
            
            healthStore.execute(query)
        }
    }
    
    /**
     * Retrieves the initial heart rate reading when the app starts.
     *
     * This method is called during app initialization to get the
     * first heart rate reading. It handles errors internally and logs
     * any issues that occur during the initial fetch.
     *
     * This is typically called after authorization is confirmed
     * and before regular monitoring begins.
     * 
     * Returns: A Boolean indicating whether the initial heart rate retrieval was successful
     */
    public func fetchInitialHeartRate() async -> Bool {
        print("Fetching initial heart rate")
        
        do {
            return try await fetchLatestHeartRate()
        } catch {
            print("Error fetching initial heart rate: \(error)")
            return false
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
        // Ensure all @Published properties are updated on main thread
        DispatchQueue.main.async {
            self.currentHeartRate = Int(bpm)
            self.lastValidBPM = Int(bpm)
        }
        
        updateHeartRateTrend(bpm)  // Add trend analysis
        
        // Post notification for other components
        NotificationCenter.default.post(
            name: Self.heartRateUpdated,
            object: bpm
        )
    }
    
    // MARK: - Testing Support
    
    /**
     * Provides simulated heart rate data for testing when no actual data is available.
     * 
     * This is useful for:
     * - Devices without a paired Apple Watch
     * - Simulator testing
     * - Development when health data is not available
     * 
     * Generates a reasonable heart rate value (60-100 BPM) and broadcasts it
     * through the same channels as a real reading.
     */
    private func simulateHeartRateForTesting() {
        // Only simulate if simulation is enabled
        guard simulationEnabled else {
            print("🔄 Heart rate simulation requested but simulation mode is disabled")
            return
        }
        
        // Stop any existing timer to prevent multiple timers running simultaneously
        if let existingTimer = simulationTimer {
            existingTimer.invalidate()
            simulationTimer = nil
        }
        
        // If we have a valid real heart rate, prefer that as our base
        let baseHeartRate = lastRealHeartRate > 0 ? lastRealHeartRate : Int.random(in: 55...95)
        let simulatedHeartRate = Double(baseHeartRate)
        
        print("🔄 Simulating heart rate: \(simulatedHeartRate) BPM (based on " + 
              (lastRealHeartRate > 0 ? "last real reading" : "random value") + ")")
        
        // Ensure all updates happen on main thread
        DispatchQueue.main.async {
            // Directly set the published properties for immediate access
            self.updateCurrentHeartRate(simulatedHeartRate, fromSimulation: true)
            self.lastValidBPM = Int(simulatedHeartRate)
            self.isHeartRateSimulated = true
            
            // Post notification as if it came from HealthKit
            NotificationCenter.default.post(
                name: Self.heartRateUpdated,
                object: self,
                userInfo: ["heartRate": Int(simulatedHeartRate), "isSimulated": true]
            )
        }
        
        // FREEZE FIX: DISABLED recurring timer to prevent frequent realm calculations
        // This was causing performance issues and freezes
        
        print("✅ Static heart rate simulation set - NO RECURRING TIMER for performance")
        
        // DISABLED: This timer was causing frequent updates that led to freezes
        /*
        // Set up a timer to periodically update the simulated heart rate (every 5 minutes for performance)
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            guard let self = self, self.simulationEnabled else { return }
            
            // Use last real heart rate as base if available
            let baseRate = self.lastRealHeartRate > 0 ? self.lastRealHeartRate : baseHeartRate
            
            // Increase the variation range for more diverse readings
            // Ensure the range doesn't go below 50 or above 100
            let minRate = max(50, baseRate-20)
            let maxRate = min(100, baseRate+20)
            let newRate = Double(Int.random(in: minRate...maxRate))
            
            print("🔄 Updating simulated heart rate: \(newRate) BPM")
            
            // Ensure all updates happen on main thread
            DispatchQueue.main.async {
                // Directly update the published properties
                self.updateCurrentHeartRate(newRate, fromSimulation: true)
                self.lastValidBPM = Int(newRate)
                self.isHeartRateSimulated = true
                
                // Post notification with the object as self for proper receipt
                NotificationCenter.default.post(
                    name: Self.heartRateUpdated,
                    object: self,
                    userInfo: ["heartRate": Int(newRate), "isSimulated": true]
                )
            }
        }
        */
    }
    
    /**
     * Manually simulate a heart rate reading for development.
     *
     * This public method allows other components to trigger heart rate
     * simulation on demand, especially useful during development without
     * a paired Apple Watch or in testing environments.
     *
     * - Parameter rate: Optional specific heart rate value to use (if nil, a random value is generated)
     */
    public func simulateHeartRateForDevelopment(rate: Int? = nil) {
        // Check if simulation is disabled, but we have a valid heart rate to use
        if !simulationEnabled && lastRealHeartRate > 0 {
            print("❤️ Using last real heart rate instead of simulation: \(lastRealHeartRate) BPM")
            
            // Post notification to trigger realm calculations with the real heart rate
            NotificationCenter.default.post(
                name: Self.heartRateUpdated,
                object: self,
                userInfo: ["heartRate": lastRealHeartRate, "isSimulated": false]
            )
            return
        }
        
        // Either simulation is enabled or we don't have a real heart rate
        // Generate a more varied heart rate if none provided
        let heartRate = rate ?? (lastRealHeartRate > 0 ? 
                                lastRealHeartRate + Int.random(in: -10...10) : 
                                Int.random(in: 55...110))
        
        print("📢 Manual heart rate simulation triggered: \(heartRate) BPM" +
              (lastRealHeartRate > 0 ? " (based on last real reading of \(lastRealHeartRate) BPM)" : ""))
        
        // Ensure all updates happen on main thread
        DispatchQueue.main.async {
            // Set the values directly
            self.updateCurrentHeartRate(Double(heartRate), fromSimulation: true)
            self.lastValidBPM = heartRate
            self.isHeartRateSimulated = true
            
            // Post notification to trigger realm calculations
            NotificationCenter.default.post(
                name: Self.heartRateUpdated,
                object: self,
                userInfo: ["heartRate": heartRate, "isSimulated": true]
            )
        }
    }
    
    // Add this method to control simulation mode
    private func enableSimulationMode(_ enabled: Bool) {
        simulationEnabled = enabled
        
        // Ensure @Published property is updated on main thread
        DispatchQueue.main.async {
            self.isHeartRateSimulated = enabled
        }
        
        if enabled {
            print("🔄 Heart rate simulation mode ENABLED")
        } else {
            print("🔄 Heart rate simulation mode DISABLED - using real data")
            
            // Stop any existing timer when disabling simulation
            if let existingTimer = simulationTimer {
                existingTimer.invalidate()
                simulationTimer = nil
            }
        }
    }
    
    /// Utility method to manually control simulation mode for testing purposes
    public func setSimulationMode(enabled: Bool) {
        enableSimulationMode(enabled)
        
        // Save the preference to UserDefaults
        UserDefaults.standard.set(enabled, forKey: "HeartRateSimulationEnabled")
        print("🔄 Heart rate simulation preference \(enabled ? "ENABLED" : "DISABLED") and saved to UserDefaults")
        
        if enabled {
            // Start simulation if enabling
            simulateHeartRateForTesting()
        } else {
            // Try to get real data if disabling
            Task {
                await forceHeartRateUpdate()
            }
        }
    }
    
    deinit {
        // Clean up the simulation timer when the manager is deallocated
        if let timer = simulationTimer {
            timer.invalidate()
            simulationTimer = nil
        }
        print("HealthKitManager deallocated")
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
