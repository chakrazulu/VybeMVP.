//
//  HeartRateIntegrationTests.swift
//  VybeMVP
//
//  Created by Corey Davis on 2/2/25.
//


import XCTest
@testable import VybeMVP
import HealthKit
import Combine

final class HeartRateIntegrationTests: XCTestCase {
    var healthKitManager: HealthKitManager!
    var realmNumberManager: RealmNumberManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        healthKitManager = HealthKitManager.shared
        realmNumberManager = RealmNumberManager()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        realmNumberManager = nil
        super.tearDown()
    }
    
    // MARK: - Authorization Tests
    
    func testHealthKitAvailability() {
        XCTAssertTrue(HKHealthStore.isHealthDataAvailable(), "HealthKit should be available on the simulator/device")
    }
    
    func testAuthorizationStatus() {
        let expectation = XCTestExpectation(description: "Authorization status check")
        
        // Monitor authorization status changes
        healthKitManager.$authorizationStatus
            .dropFirst()
            .sink { status in
                XCTAssertNotEqual(status, .notDetermined, "Authorization status should be determined")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Heart Rate Update Tests
    
    func testHeartRateUpdates() {
        let expectation = XCTestExpectation(description: "Heart rate update received")
        
        // Monitor heart rate updates
        NotificationCenter.default.publisher(for: HealthKitManager.heartRateUpdated)
            .sink { notification in
                if let bpm = notification.object as? Double {
                    XCTAssertTrue(bpm >= 62 && bpm <= 135, "Heart rate should be within valid range")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLastValidBPMPersistence() {
        let expectation = XCTestExpectation(description: "Last valid BPM persistence")
        
        // Monitor realm number updates that should be triggered by BPM changes
        realmNumberManager.$currentRealmNumber
            .dropFirst()
            .sink { _ in
                // Verify that lastValidBPM is maintained
                XCTAssertNotEqual(self.realmNumberManager.currentMockBPM, 0, "Should have a valid last BPM")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Error Recovery Tests
    
    func testHeartRateUpdateRecovery() {
        let expectation = XCTestExpectation(description: "Heart rate recovery")
        expectation.expectedFulfillmentCount = 2
        
        var updateCount = 0
        
        // Monitor heart rate updates to verify recovery
        NotificationCenter.default.publisher(for: HealthKitManager.heartRateUpdated)
            .sink { _ in
                updateCount += 1
                if updateCount >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 65.0) // Allow time for recovery cycle
    }
    
    // MARK: - Background Mode Tests
    
    func testBackgroundDelivery() {
        let expectation = XCTestExpectation(description: "Background delivery setup")
        
        Task {
            do {
                try await healthKitManager.requestAuthorization()
                expectation.fulfill()
            } catch {
                XCTFail("Background delivery setup failed: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}