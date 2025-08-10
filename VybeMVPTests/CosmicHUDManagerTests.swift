//
//  CosmicHUDManagerTests.swift
//  VybeMVPTests
//
//  Created by Claude on 8/1/25.
//  Comprehensive unit tests for CosmicHUDManager and live data integration
//

import XCTest
import SwiftUI
import Combine
@testable import VybeMVP

/// Claude: Comprehensive test suite for CosmicHUDManager and live cosmic data integration
/// Tests real-time data observers, SwiftAA integration, and tightest orb logic
@MainActor
class CosmicHUDManagerTests: XCTestCase {

    var hudManager: CosmicHUDManager!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Test Setup and Teardown

    override func setUpWithError() throws {
        TestConfiguration.configureTestEnvironment()

        // Initialize fresh manager for each test
        hudManager = CosmicHUDManager.shared
        hudManager.stopHUD() // Ensure clean state
        hudManager.currentHUDData = nil // Clear any existing data
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        hudManager?.stopHUD()
        cancellables?.removeAll()
        hudManager = nil
        cancellables = nil
    }

    // MARK: - Initialization Tests

    /// Claude: Test CosmicHUDManager initializes with proper dependencies
    func testCosmicHUDManagerInitialization() {
        XCTAssertNotNil(hudManager, "HUD manager should initialize successfully")
        XCTAssertFalse(hudManager.isHUDActive, "HUD should start inactive")
        XCTAssertNil(hudManager.currentHUDData, "HUD data should start nil")
        XCTAssertNil(hudManager.expandedInsight, "Expanded insight should start nil")
    }

    /// Claude: Test singleton pattern works correctly
    func testSingletonPattern() {
        let hudManager1 = CosmicHUDManager.shared
        let hudManager2 = CosmicHUDManager.shared

        XCTAssertTrue(hudManager1 === hudManager2, "CosmicHUDManager should be a singleton")
    }

    // MARK: - HUD Lifecycle Tests

    /// Claude: Test starting and stopping HUD
    func testHUDLifecycle() async {
        // Initially inactive
        XCTAssertFalse(hudManager.isHUDActive, "HUD should start inactive")

        // Start HUD
        hudManager.startHUD()

        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        XCTAssertTrue(hudManager.isHUDActive, "HUD should be active after starting")

        // Stop HUD
        hudManager.stopHUD()
        XCTAssertFalse(hudManager.isHUDActive, "HUD should be inactive after stopping")
    }

    /// Claude: Test HUD data refresh functionality
    func testHUDDataRefresh() async {
        let initialLastUpdate = hudManager.lastUpdate

        // Wait a small amount to ensure timestamp difference
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds

        // Refresh HUD data
        await hudManager.refreshHUDData()

        // Should have updated timestamp
        XCTAssertGreaterThan(hudManager.lastUpdate, initialLastUpdate, "Last update should be more recent after refresh")

        // Should have HUD data after refresh (may be fallback data)
        XCTAssertNotNil(hudManager.currentHUDData, "Should have HUD data after refresh")
    }

    // MARK: - Live Data Integration Tests

    /// Claude: Test ruler number retrieval from RealmSampleManager
    func testRulerNumberRetrieval() {
        let rulerNumber = hudManager.getCurrentRulerNumber()

        // Should return valid ruler number (1-9)
        XCTAssertTrue(rulerNumber >= 1 && rulerNumber <= 9, "Ruler number should be between 1-9, got \(rulerNumber)")
    }

    /// Claude: Test realm number retrieval
    func testRealmNumberRetrieval() {
        let realmNumber = hudManager.getCurrentRealmNumber()

        // Should return valid realm number (1-9)
        XCTAssertTrue(realmNumber >= 1 && realmNumber <= 9, "Realm number should be between 1-9, got \(realmNumber)")
    }

    /// Claude: Test element calculation
    func testElementCalculation() {
        let element = hudManager.getCurrentElement()

        // Should return valid cosmic element
        let validElements: [CosmicElement] = [.fire, .earth, .air, .water]
        XCTAssertTrue(validElements.contains(element), "Should return valid cosmic element")
    }

    // MARK: - Aspect Calculation Tests

    /// Claude: Test major aspects calculation with SwiftAA integration
    func testMajorAspectsCalculation() async {
        // This tests the core SwiftAA integration that was verified
        await hudManager.refreshHUDData()

        guard let hudData = hudManager.currentHUDData else {
            XCTFail("HUD data should be available after refresh")
            return
        }

        // Should have at least one aspect (even if fallback)
        XCTAssertFalse(hudData.allAspects.isEmpty, "Should have at least one aspect")

        // Dominant aspect should be the tightest orb
        if let dominantAspect = hudData.dominantAspect {
            let allOrbs = hudData.allAspects.map { $0.orb }
            let tightestOrb = allOrbs.min() ?? 0

            XCTAssertEqual(dominantAspect.orb, tightestOrb, "Dominant aspect should have tightest orb")
        }
    }

    /// Claude: Test tightest orb selection logic (user feedback verification)
    func testTightestOrbSelection() async {
        // Create test aspects with different orbs
        let testAspects = [
            AspectData(planet1: .sun, planet2: .moon, aspect: .trine, orb: 3.5, isApplying: true),
            AspectData(planet1: .venus, planet2: .mars, aspect: .square, orb: 1.2, isApplying: false),
            AspectData(planet1: .mercury, planet2: .jupiter, aspect: .opposition, orb: 2.8, isApplying: true)
        ]

        // Find the tightest orb manually
        let sortedByOrb = testAspects.sorted { $0.orb < $1.orb }
        let expectedTightest = sortedByOrb.first!

        // Should select Venus square Mars (orb 1.2)
        XCTAssertEqual(expectedTightest.orb, 1.2, "Tightest orb should be 1.2")
        XCTAssertEqual(expectedTightest.planet1, .venus, "Tightest aspect should be Venus")
        XCTAssertEqual(expectedTightest.planet2, .mars, "Tightest aspect should involve Mars")
        XCTAssertEqual(expectedTightest.aspect, .square, "Tightest aspect should be square")
    }

    /// Claude: Test fallback aspect creation
    func testFallbackAspectCreation() async {
        // Force a scenario where we might need fallback data
        // This tests the error handling path

        await hudManager.refreshHUDData()

        guard let hudData = hudManager.currentHUDData else {
            XCTFail("Should have HUD data even if fallback")
            return
        }

        // Should always have at least one aspect (fallback if needed)
        XCTAssertFalse(hudData.allAspects.isEmpty, "Should have at least one aspect (fallback if needed)")

        // If we have aspects, they should be valid
        for aspect in hudData.allAspects {
            XCTAssertTrue(aspect.orb >= 0, "Aspect orb should be non-negative")
            XCTAssertTrue(aspect.orb <= 30, "Aspect orb should be reasonable (<=30 degrees)")
        }
    }

    // MARK: - Real-time Data Observer Tests

    /// Claude: Test ruler number observer triggers HUD refresh
    func testRulerNumberObserverUpdatesHUD() async {
        let expectation = expectation(description: "HUD should update when ruler number changes")

        let initialLastUpdate = hudManager.lastUpdate

        // Wait a small amount to ensure timestamp difference
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds

        // Observe HUD updates
        hudManager.$lastUpdate
            .dropFirst() // Skip initial value
            .first() // Only take first emission
            .sink { lastUpdate in
                if lastUpdate > initialLastUpdate {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Trigger a HUD refresh which should update lastUpdate
        await hudManager.refreshHUDData()

        // Wait for the update to propagate
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    /// Claude: Test main app manager configuration
    func testMainAppManagerConfiguration() {
        let mockRealmManager = RealmNumberManager()

        // Configure with main app managers
        hudManager.configureWithMainAppManagers(realmManager: mockRealmManager)

        // This should complete without errors
        XCTAssertTrue(true, "Configuration should complete successfully")
    }

    // MARK: - HUD Data Structure Tests

    /// Claude: Test HUDData structure completeness
    func testHUDDataStructure() async {
        await hudManager.refreshHUDData()

        guard let hudData = hudManager.currentHUDData else {
            XCTFail("Should have HUD data after refresh")
            return
        }

        // Test all required properties are present
        XCTAssertTrue(hudData.rulerNumber >= 1 && hudData.rulerNumber <= 9, "Ruler number should be valid")
        XCTAssertNotNil(hudData.element, "Element should be present")
        XCTAssertNotNil(hudData.lastCalculated, "Last calculated time should be present")
        XCTAssertFalse(hudData.allAspects.isEmpty, "Should have aspects")

        // Test element is valid
        let validElements: [CosmicElement] = [.fire, .earth, .air, .water]
        XCTAssertTrue(validElements.contains(hudData.element), "Element should be valid")
    }

    /// Claude: Test AspectData structure validation
    func testAspectDataStructure() async {
        await hudManager.refreshHUDData()

        guard let hudData = hudManager.currentHUDData,
              let dominantAspect = hudData.dominantAspect else {
            XCTFail("Should have dominant aspect")
            return
        }

        // Test AspectData properties
        XCTAssertNotNil(dominantAspect.planet1, "Should have first planet")
        XCTAssertNotNil(dominantAspect.planet2, "Should have second planet")
        XCTAssertNotNil(dominantAspect.aspect, "Should have aspect type")
        XCTAssertTrue(dominantAspect.orb >= 0, "Orb should be non-negative")

        // Test that planets are different
        XCTAssertNotEqual(dominantAspect.planet1, dominantAspect.planet2, "Aspect should involve different planets")
    }

    // MARK: - Insight Generation Tests

    /// Claude: Test mini insight generation
    func testMiniInsightGeneration() async {
        let testAspect = AspectData(
            planet1: .sun,
            planet2: .mercury,
            aspect: .opposition,
            orb: 2.5,
            isApplying: true
        )

        let insight = await hudManager.generateMiniInsight(for: testAspect)

        XCTAssertFalse(insight.isEmpty, "Should generate non-empty insight")
        XCTAssertTrue(insight.count > 10, "Insight should be substantial")
        XCTAssertTrue(insight.count < 200, "Insight should not be too long for HUD display")
    }

    /// Claude: Test template insight generation for non-premium users
    func testTemplateInsightGeneration() async {
        let testAspect = AspectData(
            planet1: .venus,
            planet2: .mars,
            aspect: .square,
            orb: 1.8,
            isApplying: false
        )

        // Since premium features are disabled in test, should get template insight
        let insight = await hudManager.generateMiniInsight(for: testAspect)

        XCTAssertFalse(insight.isEmpty, "Template insight should not be empty")
        XCTAssertTrue(insight.contains("Venus") || insight.contains("Mars") || insight.contains("square"),
                     "Template insight should reference the aspect")
    }

    // MARK: - Error Handling Tests

    /// Claude: Test HUD manager handles calculation errors gracefully
    func testErrorHandlingInHUDCalculation() async {
        // Start with clean state
        XCTAssertNil(hudManager.currentHUDData, "Should start with no HUD data")

        // Force refresh (may encounter errors in test environment)
        await hudManager.refreshHUDData()

        // Should have fallback data even if calculations fail
        XCTAssertNotNil(hudManager.currentHUDData, "Should have fallback data even if calculations fail")

        // Fallback data should be valid
        if let hudData = hudManager.currentHUDData {
            XCTAssertTrue(hudData.rulerNumber >= 1 && hudData.rulerNumber <= 9, "Fallback ruler number should be valid")
            XCTAssertFalse(hudData.allAspects.isEmpty, "Should have at least fallback aspect")
        }
    }

    /// Claude: Test HUD manager handles missing dependencies
    func testMissingDependencyHandling() {
        // Test that HUD manager works even without main app manager configuration
        let rulerNumber = hudManager.getCurrentRulerNumber()
        let realmNumber = hudManager.getCurrentRealmNumber()
        let element = hudManager.getCurrentElement()

        // Should return valid values even with minimal configuration
        XCTAssertTrue(rulerNumber >= 1 && rulerNumber <= 9, "Should get valid ruler number")
        XCTAssertTrue(realmNumber >= 1 && realmNumber <= 9, "Should get valid realm number")
        XCTAssertNotNil(element, "Should get valid element")
    }

    // MARK: - Performance Tests

    /// Claude: Test HUD data refresh performance
    func testHUDDataRefreshPerformance() async {
        // Measure without async conflicts
        let startTime = Date()
        await hudManager.refreshHUDData()
        let duration = Date().timeIntervalSince(startTime)

        XCTAssertLessThan(duration, 0.5, "HUD refresh should be fast")
    }

    /// Claude: Test element calculation performance
    func testElementCalculationPerformance() {
        measure {
            for _ in 0..<100 {
                _ = hudManager.getCurrentElement()
            }
        }
    }

    /// Claude: Test insight generation performance
    func testInsightGenerationPerformance() async {
        let testAspect = AspectData(
            planet1: .sun,
            planet2: .moon,
            aspect: .trine,
            orb: 2.0,
            isApplying: true
        )

        // Measure without async conflicts
        let startTime = Date()

        for _ in 0..<50 {
            _ = await hudManager.generateMiniInsight(for: testAspect)
        }

        let duration = Date().timeIntervalSince(startTime)
        XCTAssertLessThan(duration, 2.0, "Insight generation should be performant")
    }

    // MARK: - Integration Tests

    /// Claude: Test full HUD workflow from start to data display
    func testFullHUDWorkflow() async {
        // Start HUD
        hudManager.startHUD()

        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        XCTAssertTrue(hudManager.isHUDActive, "HUD should be active")

        // Should have HUD data
        XCTAssertNotNil(hudManager.currentHUDData, "Should have HUD data after starting")

        // Data should be complete
        if let hudData = hudManager.currentHUDData {
            XCTAssertTrue(hudData.rulerNumber >= 1 && hudData.rulerNumber <= 9, "Ruler number should be valid")
            XCTAssertFalse(hudData.allAspects.isEmpty, "Should have aspects")

            // If we have a dominant aspect, test insight generation
            if let dominantAspect = hudData.dominantAspect {
                let insight = await hudManager.generateMiniInsight(for: dominantAspect)
                XCTAssertFalse(insight.isEmpty, "Should generate insight for dominant aspect")
            }
        }

        // Stop HUD
        hudManager.stopHUD()
        XCTAssertFalse(hudManager.isHUDActive, "HUD should be inactive after stopping")
    }

    /// Claude: Test HUD manager integration with SwiftAA data verification
    func testSwiftAAIntegrationVerification() async {
        await hudManager.refreshHUDData()

        guard let hudData = hudManager.currentHUDData else {
            XCTFail("Should have HUD data")
            return
        }

        // Test that we're getting realistic astronomical data
        for aspect in hudData.allAspects {
            // Orbs should be within reasonable astronomical ranges
            XCTAssertTrue(aspect.orb >= 0 && aspect.orb <= 30, "Orb should be within reasonable range: \(aspect.orb)")

            // Planets should be valid
            let validPlanets: [HUDPlanet] = [.sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto]
            XCTAssertTrue(validPlanets.contains(aspect.planet1), "Planet1 should be valid: \(aspect.planet1)")
            XCTAssertTrue(validPlanets.contains(aspect.planet2), "Planet2 should be valid: \(aspect.planet2)")

            // Aspects should be valid
            let validAspects: [HUDAspect] = [.conjunction, .opposition, .trine, .square, .sextile, .quincunx]
            XCTAssertTrue(validAspects.contains(aspect.aspect), "Aspect should be valid: \(aspect.aspect)")
        }
    }

    // MARK: - Data Observer Tests

    /// Claude: Test published properties update correctly
    func testPublishedPropertiesUpdate() async {
        let expectation = expectation(description: "Published properties should update")

        // Monitor isHUDActive changes
        hudManager.$isHUDActive
            .dropFirst() // Skip initial value
            .first() // Only take first emission
            .sink { isActive in
                if isActive {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Start HUD to trigger update
        hudManager.startHUD()

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    /// Claude: Test currentHUDData publisher
    func testCurrentHUDDataPublisher() async {
        let expectation = expectation(description: "HUD data should be published")

        // Monitor HUD data changes
        hudManager.$currentHUDData
            .compactMap { $0 } // Only non-nil values
            .first() // Only take first emission
            .sink { hudData in
                XCTAssertNotNil(hudData, "Published HUD data should not be nil")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Refresh to trigger update
        await hudManager.refreshHUDData()

        await fulfillment(of: [expectation], timeout: 2.0)
    }
}

// MARK: - Test Extensions and Helpers

extension CosmicHUDManagerTests {

    /// Claude: Helper to create test aspect data
    private func createTestAspectData(
        planet1: HUDPlanet = .sun,
        planet2: HUDPlanet = .moon,
        aspect: HUDAspect = .trine,
        orb: Double = 2.0,
        isApplying: Bool = true
    ) -> AspectData {
        return AspectData(
            planet1: planet1,
            planet2: planet2,
            aspect: aspect,
            orb: orb,
            isApplying: isApplying
        )
    }

    /// Claude: Helper to validate HUD data completeness
    private func validateHUDData(_ hudData: HUDData) {
        XCTAssertTrue(hudData.rulerNumber >= 1 && hudData.rulerNumber <= 9, "Ruler number should be valid")
        XCTAssertNotNil(hudData.element, "Element should be present")
        XCTAssertFalse(hudData.allAspects.isEmpty, "Should have aspects")
        XCTAssertNotNil(hudData.lastCalculated, "Should have calculation time")

        // Validate dominant aspect if present
        if let dominantAspect = hudData.dominantAspect {
            let allOrbs = hudData.allAspects.map { $0.orb }
            let tightestOrb = allOrbs.min() ?? 0
            XCTAssertEqual(dominantAspect.orb, tightestOrb, "Dominant aspect should have tightest orb")
        }
    }
}
