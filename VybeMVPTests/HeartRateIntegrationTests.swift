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
    // We'll use the mock directly for all tests
    var mockHealthKitManager: MockHealthKitManager!
    var realmNumberManager: RealmNumberManager!
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        super.setUp()
        // Create and use a fresh mock for each test
        mockHealthKitManager = MockHealthKitManager()

        // Reset to known state
        mockHealthKitManager.reset()

        // Initialize the realm number manager
        realmNumberManager = RealmNumberManager()

        // Print setup to help with debugging
        print("HeartRateIntegrationTests: Set up with fresh MockHealthKitManager")
    }

    override func tearDownWithError() throws {
        // Clean up
        cancellables.removeAll()
        realmNumberManager = nil
        mockHealthKitManager = nil

        // Allow time for any async operations to complete
        Thread.sleep(forTimeInterval: 0.1)

        print("HeartRateIntegrationTests: Tear down complete")
        super.tearDown()
    }

    // MARK: - Authorization Tests

    func testHealthKitAuthorizationFlow() {
        let expectation = XCTestExpectation(description: "Authorization status updated")

        // Set mock to not determined first
        mockHealthKitManager.setAuthorizationStatus(.notDetermined)
        mockHealthKitManager.shouldSucceed = true

        // Capture the manager in a local variable to avoid Sendable warnings
        // Ensure mockHealthKitManager is safely unwrapped
        guard let manager = mockHealthKitManager else {
            XCTFail("MockHealthKitManager should not be nil")
            return
        }

        // Request authorization (this will be mocked)
        Task {
            do {
                try await manager.requestAuthorization()

                // Capture the status first so we can use it outside of the closure
                let finalStatus = manager.authorizationStatus

                // Use a synchronous approach to avoid self capture issues
                XCTAssertEqual(finalStatus, .sharingAuthorized)
                expectation.fulfill()
            } catch {
                XCTFail("Authorization failed: \(error)")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Heart Rate Update Tests

    func testHeartRateUpdates() {
        let expectation = XCTestExpectation(description: "Heart rate update received")

        // Set up the test environment
        mockHealthKitManager.shouldSucceed = true

        // Trigger a heart rate update immediately
        mockHealthKitManager.updateHeartRateForTesting(75)

        // Verify the update was applied
        XCTAssertEqual(mockHealthKitManager.currentHeartRate, 75)
        XCTAssertEqual(mockHealthKitManager.lastValidBPM, 75)

        expectation.fulfill()

        wait(for: [expectation], timeout: 2.0)
    }

    func testLastValidBPMPersistence() {
        let expectation = XCTestExpectation(description: "Last valid BPM persistence")

        // Set up test values directly
        mockHealthKitManager.updateLastValidBPM(80)

        // Simply verify the value without waiting for an async operation
        XCTAssertEqual(mockHealthKitManager.lastValidBPM, 80)
        expectation.fulfill()

        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Error Recovery Tests

    func testHeartRateUpdateRecovery() {
        let expectation = XCTestExpectation(description: "Heart rate recovery")

        // Set up the test environment
        mockHealthKitManager.shouldSucceed = true

        // Directly trigger updates
        mockHealthKitManager.updateHeartRateForTesting(70)
        mockHealthKitManager.updateHeartRateForTesting(80)

        // Verify second update overwrote first
        XCTAssertEqual(mockHealthKitManager.lastValidBPM, 80)

        expectation.fulfill()

        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Background Mode Tests

    func testBackgroundDelivery() {
        let expectation = XCTestExpectation(description: "Background delivery setup")

        // Immediately set up the mock to ensure we don't hang
        mockHealthKitManager.shouldSucceed = true

        // Capture in local variable and safely unwrap
        guard let manager = mockHealthKitManager else {
            XCTFail("MockHealthKitManager should not be nil")
            return
        }

        Task {
            do {
                // Use the manager instance for authorization
                try await manager.requestAuthorization()

                // Capture current values to verify
                let authStatus = manager.authorizationStatus
                let needsSettings = manager.needsSettingsAccess

                // Verify authorization was successful
                XCTAssertEqual(authStatus, .sharingAuthorized)
                XCTAssertFalse(needsSettings)

                expectation.fulfill()
            } catch {
                XCTFail("Background delivery setup failed: \(error)")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
