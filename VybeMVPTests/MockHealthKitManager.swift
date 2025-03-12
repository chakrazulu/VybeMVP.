import Foundation
import HealthKit
import Combine
import VybeMVP

/// A mock implementation of HealthKitManager for testing
class MockHealthKitManager: HealthKitManager {
    // Override the shared instance
    static let mockShared = MockHealthKitManager()
    
    // Mock values
    private var mockHeartRates: [Double] = [65.0, 72.0, 85.0, 95.0, 110.0, 120.0]
    private var currentMockIndex = 0
    
    // Mock status
    private var mockAuthorizationStatus: HKAuthorizationStatus = .sharingAuthorized
    
    // Reset when tests need it
    func reset() {
        currentMockIndex = 0
        _currentHeartRate = Published<Double?>(initialValue: nil)
        _lastValidBPM = Published<Int>(initialValue: 0)
        _authorizationStatus = Published<HKAuthorizationStatus>(initialValue: .notDetermined)
        _needsSettingsAccess = Published<Bool>(initialValue: false)
    }
    
    // Override authorization status
    func setAuthorizationStatus(_ status: HKAuthorizationStatus) {
        mockAuthorizationStatus = status
        _authorizationStatus.wrappedValue = status
    }
    
    // The next heart rate in the sequence
    private var nextHeartRate: Double {
        let rate = mockHeartRates[currentMockIndex]
        currentMockIndex = (currentMockIndex + 1) % mockHeartRates.count
        return rate
    }
    
    // Override the init to make it public
    override init() {
        super.init()
        // Initialize with test values
        _authorizationStatus = Published<HKAuthorizationStatus>(initialValue: mockAuthorizationStatus)
        _currentHeartRate = Published<Double?>(initialValue: mockHeartRates.first)
        _lastValidBPM = Published<Int>(initialValue: Int(mockHeartRates.first ?? 0))
    }
    
    // Override authorization request to immediately succeed
    override func requestAuthorization() async throws {
        // Simulate successful authorization
        _authorizationStatus.wrappedValue = .sharingAuthorized
        _needsSettingsAccess.wrappedValue = false
        
        // Post a notification that we have heart rate data
        updateHeartRate(nextHeartRate)
    }
    
    // Override heart rate monitoring to provide mock data
    override func startHeartRateMonitoring() {
        // Simulate starting monitoring
        updateHeartRate(nextHeartRate)
    }
    
    // Override heart rate update to provide mock data
    override func forceHeartRateUpdate() async {
        // Simulate a heart rate update
        updateHeartRate(nextHeartRate)
    }
    
    // Override heart rate fetch to provide mock data
    override func fetchInitialHeartRate() async {
        // Simulate fetching heart rate
        updateHeartRate(nextHeartRate)
    }
    
    // Helper to update the heart rate and post notifications
    private func updateHeartRate(_ bpm: Double) {
        _currentHeartRate.wrappedValue = bpm
        _lastValidBPM.wrappedValue = Int(bpm)
        
        // Post notification
        NotificationCenter.default.post(
            name: HealthKitManager.heartRateUpdated,
            object: bpm
        )
    }
    
    // Stop monitoring (no-op in mock)
    override func stopHeartRateMonitoring() {
        // No implementation needed
    }
}

// Extension to replace the shared instance for testing
extension HealthKitManager {
    static func setUpForTesting() {
        // Swizzle the shared instance
        // Note: This is a hack and should only be used in tests!
        let originalSelector = #selector(getter: HealthKitManager.shared)
        let swizzledSelector = #selector(getter: MockHealthKitManager.mockShared)
        
        guard let originalMethod = class_getClassMethod(HealthKitManager.self, originalSelector),
              let swizzledMethod = class_getClassMethod(MockHealthKitManager.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    static func tearDownAfterTesting() {
        // Reset the swizzling
        let originalSelector = #selector(getter: HealthKitManager.shared)
        let swizzledSelector = #selector(getter: MockHealthKitManager.mockShared)
        
        guard let originalMethod = class_getClassMethod(HealthKitManager.self, originalSelector),
              let swizzledMethod = class_getClassMethod(MockHealthKitManager.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(swizzledMethod, originalMethod)
    }
} 