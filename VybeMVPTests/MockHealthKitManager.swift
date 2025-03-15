import Foundation
import HealthKit
import Combine
import SwiftUI
@testable import VybeMVP

/// A mock implementation of HealthKitManaging for testing
@objc class MockHealthKitManager: NSObject, HealthKitManaging, ObservableObject {
    // Static mock instance for convenience
    @objc static var mockShared = MockHealthKitManager()
    
    // Static notification name to mirror HealthKitManager's constant
    static let heartRateUpdated = Notification.Name("heartRateUpdated")
    
    // MARK: - Published Properties
    @Published public private(set) var currentHeartRate: Int = 0
    @Published public private(set) var lastValidBPM: Int = 0
    @Published public private(set) var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @Published public private(set) var needsSettingsAccess: Bool = false
    
    // MARK: - Mock Control Properties
    var shouldSucceed = true
    var shouldThrowError = false
    var mockError: Error?
    private let mockHeartRates = [65, 70, 75, 80, 85, 90]
    private var currentMockIndex = 0
    
    override init() {
        super.init()
        print("MockHealthKitManager initialized")
        reset()
    }
    
    // MARK: - Reset Method for Tests
    func reset() {
        updateCurrentHeartRate(0)
        updateLastValidBPM(0)
        updateAuthorizationStatus(.notDetermined)
        updateNeedsSettingsAccess(false)
        shouldSucceed = true
        shouldThrowError = false
        mockError = nil
        currentMockIndex = 0
    }
    
    // MARK: - Internal Update Methods
    internal func updateCurrentHeartRate(_ value: Int) {
        currentHeartRate = value
    }
    
    internal func updateLastValidBPM(_ value: Int) {
        lastValidBPM = value
    }
    
    internal func updateAuthorizationStatus(_ status: HKAuthorizationStatus) {
        authorizationStatus = status
    }
    
    internal func updateNeedsSettingsAccess(_ value: Bool) {
        needsSettingsAccess = value
    }
    
    // MARK: - Test Support Methods
    
    // Method for tests to update heart rate directly
    func updateHeartRateForTesting(_ value: Int) {
        updateCurrentHeartRate(value)
        updateLastValidBPM(value)
        
        // Post notification for observers - using the same format as the real HealthKitManager
        let heartRateDouble = Double(value)
        NotificationCenter.default.post(
            name: MockHealthKitManager.heartRateUpdated, // Use our own constant instead
            object: heartRateDouble,
            userInfo: ["heartRate": heartRateDouble]
        )
    }
    
    // MARK: - Mock Setting Methods
    func setAuthorizationStatus(_ status: HKAuthorizationStatus) {
        updateAuthorizationStatus(status)
    }
    
    // MARK: - Protocol Implementation
    func requestAuthorization() async throws {
        if shouldThrowError {
            if let error = mockError {
                throw error
            } else {
                throw NSError(domain: "MockHealthKitManager", code: 100, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            }
        }
        
        if shouldSucceed {
            updateAuthorizationStatus(.sharingAuthorized)
            updateNeedsSettingsAccess(false)
        } else {
            updateAuthorizationStatus(.sharingDenied)
            updateNeedsSettingsAccess(true)
        }
    }
    
    func startHeartRateMonitoring() {
        if shouldSucceed {
            // Simulate getting a heart rate immediately
            updateHeartRate()
        }
    }
    
    func forceHeartRateUpdate() async {
        if shouldSucceed {
            updateHeartRate()
        }
    }
    
    func fetchInitialHeartRate() async {
        if shouldSucceed {
            updateHeartRate()
        }
    }
    
    func stopHeartRateMonitoring() {
        // No need to do anything in mock
    }
    
    // MARK: - Private Helper Methods
    private func updateHeartRate() {
        let heartRate = mockHeartRates[currentMockIndex]
        
        // Update the published properties
        currentHeartRate = heartRate
        lastValidBPM = heartRate
        
        // Cycle through mock values
        currentMockIndex = (currentMockIndex + 1) % mockHeartRates.count
        
        // Post notification for observers - using the same format as the real HealthKitManager
        // Convert Int to Double to match the real implementation
        let heartRateDouble = Double(heartRate)
        NotificationCenter.default.post(
            name: MockHealthKitManager.heartRateUpdated, // Use our own constant
            object: heartRateDouble,
            userInfo: ["heartRate": heartRateDouble]
        )
    }
}

// MARK: - Minimal HealthKitManager Extension for Testing
extension VybeMVP.HealthKitManager {
    static func setUpForTesting() {
        print("HealthKitManager testing mode enabled - tests will use MockHealthKitManager directly")
    }
    
    static func tearDownAfterTesting() {
        print("HealthKitManager testing mode disabled")
    }
} 
