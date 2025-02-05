//
//  HealthKitManager.swift
//  VybeMVP
//
//  Created by Corey Davis on 2/1/25.
//

import Foundation
import HealthKit
import Combine
import os
import UIKit
import os.log
import SwiftUI
import BackgroundTasks

class HealthKitManager: ObservableObject, @unchecked Sendable {
    // MARK: - Properties
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.infinitiesinn.vybe.VybeMVP", category: "HealthKit")
    
    @Published private(set) var currentHeartRate: Double?
    @Published private(set) var lastValidBPM: Int = 0
    @Published private(set) var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @Published private(set) var needsSettingsAccess: Bool = false
    @Published private(set) var authorizationStatuses: [String: HKAuthorizationStatus] = [:]
    
    private var heartRateQuery: HKQuery?
    private var updateTimer: Timer?
    private var lastUpdateTime: Date?
    
    // Add notification name for heart rate updates
    static let heartRateUpdated = Notification.Name("com.infinitiesinn.vybe.heartRateUpdated")
    
    // Helper to get health settings URL
    var healthSettingsURL: URL? {
        URL(string: "x-apple-health://")
    }
    
    // Helper to get app settings URL
    var appSettingsURL: URL? {
        URL(string: UIApplication.openSettingsURLString)
    }
    
    // MARK: - Initialization
    private init() {
        setupIfAvailable()
    }
    
    // MARK: - Setup
    private func setupIfAvailable() {
        guard HKHealthStore.isHealthDataAvailable() else {
            os_log("HealthKit is not available on this device", log: logger, type: .error)
            return
        }
        
        // Initialize status for heart rate only
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            let status = healthStore.authorizationStatus(for: heartRateType)
            authorizationStatuses[heartRateType.identifier] = status
            authorizationStatus = status
        }
        
        os_log("HealthKit setup completed successfully", log: logger, type: .default)
    }
    
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
    
    // MARK: - Authorization
    func requestAuthorization() async throws {
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
    func startHeartRateMonitoring() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            os_log("Heart rate type is not available", log: logger, type: .error)
            return
        }
        
        // Check authorization status
        let status = healthStore.authorizationStatus(for: heartRateType)
        guard status == .sharingAuthorized else {
            os_log("HealthKit authorization not granted", log: logger, type: .error)
            return
        }
        
        print("\n🫀 Starting heart rate monitoring...")
        
        // Create a predicate for recent samples (last 30 seconds)
        let now = Date()
        let past = Calendar.current.date(byAdding: .second, value: -30, to: now) ?? now
        let predicate = HKQuery.predicateForSamples(withStart: past, end: nil, options: .strictEndDate)
        
        // Stop any existing query
        stopHeartRateMonitoring()
        
        // Create the heart rate query for historical data
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] (query: HKAnchoredObjectQuery, samples: [HKSample]?, deletedObjects: [HKDeletedObject]?, anchor: HKQueryAnchor?, error: Error?) in
            if let error = error {
                print("❌ Heart rate query error: \(error.localizedDescription)")
                return
            }
            
            Task { @MainActor in
                self?.processHeartRateSamples(samples)
            }
        }
        
        // Set up update handler for real-time updates
        query.updateHandler = { [weak self] (query: HKAnchoredObjectQuery, samples: [HKSample]?, deletedObjects: [HKDeletedObject]?, anchor: HKQueryAnchor?, error: Error?) in
            if let error = error {
                print("❌ Heart rate update error: \(error.localizedDescription)")
                return
            }
            
            Task { @MainActor in
                self?.processHeartRateSamples(samples)
            }
        }
        
        // Execute the query
        healthStore.execute(query)
        heartRateQuery = query
        
        // Enable background delivery
        Task {
            do {
                try await enableBackgroundDelivery()
            } catch {
                print("❌ Error enabling background delivery: \(error.localizedDescription)")
            }
        }
        
        // Set up a periodic query every 15 seconds
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.forceHeartRateUpdate()
            }
        }
        
        print("✅ Heart rate monitoring started with 15-second updates")
    }
    
    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.infinitiesinn.vybe.heartrate-update")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // Schedule for 1 minute from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background task scheduled successfully")
        } catch {
            print("❌ Could not schedule background task: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            print("⚠️ No heart rate samples to process")
            return
        }
        
        // Get the most recent heart rate
        if let mostRecentSample = samples.last {
            let heartRate = mostRecentSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            let timestamp = mostRecentSample.startDate
            let age = Date().timeIntervalSince(timestamp)
            
            print("💓 Processing heart rate: \(Int(heartRate)) BPM at \(timestamp) (age: \(Int(age)) seconds)")
            
            // Only update if the reading is fresh (less than 60 seconds old)
            if age <= 60 {
                // Update both current and last valid BPM
                self.currentHeartRate = heartRate
                self.lastValidBPM = Int(heartRate)
                self.lastUpdateTime = Date()
                
                // Post notification with the new heart rate
                NotificationCenter.default.post(
                    name: Self.heartRateUpdated,
                    object: heartRate,
                    userInfo: ["heartRate": heartRate, "timestamp": timestamp]
                )
                
                print("✅ Updated heart rate to \(Int(heartRate)) BPM")
                
                // Update trend analysis
                updateHeartRateTrend(heartRate)
            } else {
                print("⚠️ Heart rate reading too old (\(Int(age)) seconds), requesting fresh data")
                // Request a fresh reading
                Task {
                    await forceHeartRateUpdate()
                }
            }
        } else {
            print("⚠️ No recent heart rate sample found, requesting fresh data")
            // Request a fresh reading
            Task {
                await forceHeartRateUpdate()
            }
        }
    }
    
    func stopHeartRateMonitoring() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
            updateTimer?.invalidate()
            updateTimer = nil
            print("⏹ Heart rate monitoring stopped")
        }
    }
    
    // MARK: - Private Methods
    // Helper method to check if all required permissions are granted
    func checkAllPermissions() -> Bool {
        let types: [HKQuantityTypeIdentifier] = [
            .heartRate,
            .heartRateVariabilitySDNN,
            .restingHeartRate,
            .walkingHeartRateAverage
        ]
        
        return types.allSatisfy { identifier in
            guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return false }
            return healthStore.authorizationStatus(for: type) == .sharingAuthorized
        }
    }
    
    // MARK: - Settings Access
    func openHealthAppSettings() {
        if let url = URL(string: "x-apple-health://") {
            UIApplication.shared.open(url)
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    // Helper method to check if heart rate permission is granted
    func checkHeartRatePermission() -> Bool {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return false }
        return healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized
    }
    
    // Add method to get current heart rate
    func getCurrentHeartRate() -> Double {
        return currentHeartRate ?? 0.0
    }
    
    // MARK: - Heart Rate Analytics
    private struct HeartRateTrend {
        let timestamp: Date
        let bpm: Double
    }
    
    private var recentHeartRates: [HeartRateTrend] = []
    private let maxTrendDataPoints = 10
    
    private func updateHeartRateTrend(_ bpm: Double) {
        let trend = HeartRateTrend(timestamp: Date(), bpm: bpm)
        recentHeartRates.append(trend)
        
        // Keep only the most recent data points
        if recentHeartRates.count > maxTrendDataPoints {
            recentHeartRates.removeFirst()
        }
        
        analyzeTrend()
    }
    
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
    
    // Add to existing updateHeartRate method
    private func updateHeartRate(_ bpm: Double) {
        currentHeartRate = bpm
        lastValidBPM = Int(bpm)
        updateHeartRateTrend(bpm)  // Add trend analysis
        
        // Post notification for other components
        NotificationCenter.default.post(
            name: Self.heartRateUpdated,
            object: bpm
        )
    }
    
    // Add method to force immediate reading
    func forceHeartRateUpdate() async {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        print("\n🔄 Forcing immediate heart rate update...")
        
        // Check authorization and request if needed
        let status = healthStore.authorizationStatus(for: heartRateType)
        if status != .sharingAuthorized {
            print("⚠️ Authorization needed, requesting...")
            do {
                try await requestAuthorization()
            } catch {
                print("❌ Authorization failed: \(error.localizedDescription)")
                return
            }
        }
        
        // Query for the most recent heart rate in the last 30 seconds
        let now = Date()
        let past = Calendar.current.date(byAdding: .second, value: -30, to: now) ?? now
        let predicate = HKQuery.predicateForSamples(withStart: past, end: nil, options: .strictEndDate)
        
        print("📊 Querying heart rate data from \(past) to \(now)")
        
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        ) { [weak self] (_, samples, error) in
            if let error = error {
                print("❌ Force update error: \(error.localizedDescription)")
                return
            }
            
            if let samples = samples as? [HKQuantitySample], let latest = samples.last {
                print("✅ Found heart rate sample: \(latest)")
            } else {
                print("⚠️ No recent heart rate samples found")
            }
            
            Task { @MainActor in
                self?.processHeartRateSamples(samples)
            }
        }
        
        healthStore.execute(query)
        
        // Also start continuous monitoring if not already started
        if heartRateQuery == nil {
            startHeartRateMonitoring()
        }
    }
    
    // Add method for initial heart rate fetch
    func fetchInitialHeartRate() async {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        print("\n📊 Fetching initial heart rate...")
        
        // Look back just 30 seconds for the most recent reading
        let now = Date()
        let past = Calendar.current.date(byAdding: .second, value: -30, to: now) ?? now
        let predicate = HKQuery.predicateForSamples(withStart: past, end: nil, options: .strictEndDate)
        
        // Start monitoring immediately regardless of fetch result
        if heartRateQuery == nil {
            startHeartRateMonitoring()
        }
        
        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
                let query = HKSampleQuery(
                    sampleType: heartRateType,
                    predicate: predicate,
                    limit: 1,
                    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: samples ?? [])
                }
                healthStore.execute(query)
            }
            
            if let quantitySamples = samples as? [HKQuantitySample], let latest = quantitySamples.last {
                let heartRate = latest.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                let timestamp = latest.startDate
                let age = now.timeIntervalSince(timestamp)
                
                print("📊 Found heart rate: \(Int(heartRate)) BPM from \(Int(age)) seconds ago")
                
                // Use any reading less than 60 seconds old
                if age <= 60 {
                    await MainActor.run {
                        processHeartRateSamples(samples)
                    }
                } else {
                    print("⚠️ Heart rate reading too old (\(Int(age)) seconds), waiting for fresh data")
                }
            } else {
                print("⚠️ No recent heart rate samples found, waiting for fresh data")
            }
        } catch {
            print("❌ Initial heart rate fetch failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Error Types
enum HealthKitError: LocalizedError {
    case notAvailable
    case heartRateNotAvailable
    case authorizationFailed(Error?)
    case capabilityMissing
    case notDetermined
    case denied
    case requiresBackgroundAccess
    case allAccessDenied
    
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
