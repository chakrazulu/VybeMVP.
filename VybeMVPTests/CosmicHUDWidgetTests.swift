//
//  CosmicHUDWidgetTests.swift
//  VybeMVPTests
//
//  Created by Claude on 8/1/25.
//  Comprehensive unit tests for Cosmic HUD widget system
//  Note: Widget extension specific code is tested separately due to target limitations
//

import XCTest
import SwiftUI
@testable import VybeMVP

/// Claude: Comprehensive test suite for Cosmic HUD widget system
/// Tests core HUD data structures and types that are accessible from main app target
class CosmicHUDWidgetTests: XCTestCase {

    // MARK: - Test Configuration

    override func setUpWithError() throws {
        TestConfiguration.configureTestEnvironment()
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    // MARK: - HUD Data Structure Tests

    /// Claude: Test HUDData structure completeness
    func testHUDDataStructure() {
        let testAspect = AspectData(
            planet1: .sun,
            planet2: .mercury,
            aspect: .opposition,
            orb: 2.5,
            isApplying: true
        )

        let hudData = HUDData(
            rulerNumber: 7,
            dominantAspect: testAspect,
            element: .fire,
            lastCalculated: Date(),
            allAspects: [testAspect],
            vfi: 432.0
        )

        // Test all required properties are present
        XCTAssertEqual(hudData.rulerNumber, 7, "Ruler number should be stored correctly")
        XCTAssertNotNil(hudData.dominantAspect, "Dominant aspect should be present")
        XCTAssertEqual(hudData.element, .fire, "Element should be stored correctly")
        XCTAssertNotNil(hudData.lastCalculated, "Last calculated time should be present")
        XCTAssertEqual(hudData.allAspects.count, 1, "Should have correct number of aspects")

        // Test compact display generation
        let compactDisplay = hudData.compactDisplay
        XCTAssertFalse(compactDisplay.isEmpty, "Compact display should not be empty")
        XCTAssertTrue(compactDisplay.contains("👑7"), "Should contain ruler number with crown")
        XCTAssertTrue(compactDisplay.contains("☉"), "Should contain sun symbol")
        XCTAssertTrue(compactDisplay.contains("☿"), "Should contain mercury symbol")
        XCTAssertTrue(compactDisplay.contains("🔥"), "Should contain fire element")
    }

    /// Claude: Test AspectData structure validation
    func testAspectDataStructure() {
        let aspectData = AspectData(
            planet1: .venus,
            planet2: .mars,
            aspect: .square,
            orb: 1.8,
            isApplying: false
        )

        // Test AspectData properties
        XCTAssertEqual(aspectData.planet1, .venus, "Should store first planet correctly")
        XCTAssertEqual(aspectData.planet2, .mars, "Should store second planet correctly")
        XCTAssertEqual(aspectData.aspect, .square, "Should store aspect type correctly")
        XCTAssertEqual(aspectData.orb, 1.8, "Should store orb correctly")
        XCTAssertFalse(aspectData.isApplying, "Should store applying status correctly")

        // Test description generation
        let description = aspectData.description
        XCTAssertEqual(description, "Venus Square Mars", "Should generate correct description")

        // Test that planets are different
        XCTAssertNotEqual(aspectData.planet1, aspectData.planet2, "Aspect should involve different planets")

        // Test orb is valid
        XCTAssertTrue(aspectData.orb >= 0, "Orb should be non-negative")
    }

    // MARK: - HUD Planet Tests

    /// Claude: Test HUDPlanet enum completeness
    func testHUDPlanetEnum() {
        let allPlanets = HUDPlanet.allCases
        XCTAssertEqual(allPlanets.count, 10, "Should have all 10 major planets")

        // Test specific planets
        XCTAssertTrue(allPlanets.contains(.sun), "Should include Sun")
        XCTAssertTrue(allPlanets.contains(.moon), "Should include Moon")
        XCTAssertTrue(allPlanets.contains(.mercury), "Should include Mercury")
        XCTAssertTrue(allPlanets.contains(.venus), "Should include Venus")
        XCTAssertTrue(allPlanets.contains(.mars), "Should include Mars")
        XCTAssertTrue(allPlanets.contains(.jupiter), "Should include Jupiter")
        XCTAssertTrue(allPlanets.contains(.saturn), "Should include Saturn")
        XCTAssertTrue(allPlanets.contains(.uranus), "Should include Uranus")
        XCTAssertTrue(allPlanets.contains(.neptune), "Should include Neptune")
        XCTAssertTrue(allPlanets.contains(.pluto), "Should include Pluto")

        // Test planet properties
        XCTAssertEqual(HUDPlanet.sun.name, "Sun", "Sun name should be correct")
        XCTAssertEqual(HUDPlanet.sun.symbol, "☉", "Sun symbol should be correct")
        XCTAssertEqual(HUDPlanet.mercury.name, "Mercury", "Mercury name should be correct")
        XCTAssertEqual(HUDPlanet.mercury.symbol, "☿", "Mercury symbol should be correct")
    }

    /// Claude: Test planet symbol mapping
    func testPlanetSymbolMapping() {
        let expectedSymbols: [HUDPlanet: String] = [
            .sun: "☉",
            .moon: "☽",
            .mercury: "☿",
            .venus: "♀",
            .mars: "♂",
            .jupiter: "♃",
            .saturn: "♄",
            .uranus: "♅",
            .neptune: "♆",
            .pluto: "♇"
        ]

        for (planet, expectedSymbol) in expectedSymbols {
            XCTAssertEqual(planet.symbol, expectedSymbol, "Planet \(planet) should have correct symbol")
        }
    }

    /// Claude: Test planet string conversion
    func testPlanetStringConversion() {
        let testCases: [(String, HUDPlanet?)] = [
            ("sun", .sun),
            ("Sun", .sun),
            ("SUN", .sun),
            ("mercury", .mercury),
            ("Mercury", .mercury),
            ("venus", .venus),
            ("mars", .mars),
            ("jupiter", .jupiter),
            ("saturn", .saturn),
            ("uranus", .uranus),
            ("neptune", .neptune),
            ("pluto", .pluto),
            ("invalid", nil),
            ("", nil)
        ]

        for (input, expected) in testCases {
            let result = HUDPlanet.from(string: input)
            XCTAssertEqual(result, expected, "String '\(input)' should convert to \(expected?.name ?? "nil")")
        }
    }

    // MARK: - HUD Aspect Tests

    /// Claude: Test HUDAspect enum completeness
    func testHUDAspectEnum() {
        let allAspects = HUDAspect.allCases
        XCTAssertEqual(allAspects.count, 6, "Should have all 6 major aspects")

        // Test specific aspects
        XCTAssertTrue(allAspects.contains(.conjunction), "Should include conjunction")
        XCTAssertTrue(allAspects.contains(.opposition), "Should include opposition")
        XCTAssertTrue(allAspects.contains(.trine), "Should include trine")
        XCTAssertTrue(allAspects.contains(.square), "Should include square")
        XCTAssertTrue(allAspects.contains(.sextile), "Should include sextile")
        XCTAssertTrue(allAspects.contains(.quincunx), "Should include quincunx")

        // Test aspect properties
        XCTAssertEqual(HUDAspect.opposition.name, "Opposition", "Opposition name should be correct")
        XCTAssertEqual(HUDAspect.opposition.symbol, "☍", "Opposition symbol should be correct")
        XCTAssertEqual(HUDAspect.trine.name, "Trine", "Trine name should be correct")
        XCTAssertEqual(HUDAspect.trine.symbol, "△", "Trine symbol should be correct")
    }

    /// Claude: Test aspect symbol mapping
    func testAspectSymbolMapping() {
        let expectedSymbols: [HUDAspect: String] = [
            .conjunction: "☌",
            .opposition: "☍",
            .trine: "△",
            .square: "□",
            .sextile: "⚹",
            .quincunx: "⚻"
        ]

        for (aspect, expectedSymbol) in expectedSymbols {
            XCTAssertEqual(aspect.symbol, expectedSymbol, "Aspect \(aspect) should have correct symbol")
        }
    }

    /// Claude: Test aspect string conversion
    func testAspectStringConversion() {
        let testCases: [(String, HUDAspect)] = [
            ("conjunction", .conjunction),
            ("Conjunction", .conjunction),
            ("CONJUNCTION", .conjunction),
            ("opposition", .opposition),
            ("trine", .trine),
            ("square", .square),
            ("sextile", .sextile),
            ("quincunx", .quincunx),
            ("invalid", .conjunction) // fallback
        ]

        for (input, expected) in testCases {
            let result = HUDAspect.from(aspectType: input)
            XCTAssertEqual(result, expected, "String '\(input)' should convert to \(expected.name)")
        }
    }

    // MARK: - HUD Element Tests

    /// Claude: Test HUDElement enum completeness
    func testHUDElementEnum() {
        let allElements = HUDElement.allCases
        XCTAssertEqual(allElements.count, 4, "Should have all 4 elements")

        // Test specific elements
        XCTAssertTrue(allElements.contains(.fire), "Should include fire")
        XCTAssertTrue(allElements.contains(.earth), "Should include earth")
        XCTAssertTrue(allElements.contains(.air), "Should include air")
        XCTAssertTrue(allElements.contains(.water), "Should include water")

        // Test element properties
        XCTAssertEqual(HUDElement.fire.name, "Fire", "Fire name should be correct")
        XCTAssertEqual(HUDElement.fire.emoji, "🔥", "Fire emoji should be correct")
        XCTAssertEqual(HUDElement.earth.name, "Earth", "Earth name should be correct")
        XCTAssertEqual(HUDElement.earth.emoji, "🌱", "Earth emoji should be correct")
    }

    /// Claude: Test element emoji mapping
    func testElementEmojiMapping() {
        let expectedEmojis: [HUDElement: String] = [
            .fire: "🔥",
            .earth: "🌱",
            .air: "💨",
            .water: "💧"
        ]

        for (element, expectedEmoji) in expectedEmojis {
            XCTAssertEqual(element.emoji, expectedEmoji, "Element \(element) should have correct emoji")
        }
    }

    // MARK: - Live Activity Attributes Tests

    /// Claude: Test CosmicHUDWidgetAttributes structure
    func testCosmicHUDWidgetAttributes() {
        let attributes = CosmicHUDWidgetAttributes()

        // Should initialize without errors
        XCTAssertNotNil(attributes, "Widget attributes should initialize successfully")
    }

    /// Claude: Test widget content state with complete cosmic data
    func testWidgetContentState() {
        let contentState = CosmicHUDWidgetAttributes.ContentState(
            rulerNumber: 7,
            realmNumber: 3,
            aspectDisplay: "☉ ☍ ☿",
            element: "🔥",
            lastUpdate: Date()
        )

        XCTAssertEqual(contentState.rulerNumber, 7, "Ruler number should be stored correctly")
        XCTAssertEqual(contentState.realmNumber, 3, "Realm number should be stored correctly")
        XCTAssertEqual(contentState.aspectDisplay, "☉ ☍ ☿", "Aspect display should be stored correctly")
        XCTAssertEqual(contentState.element, "🔥", "Element should be stored correctly")
        XCTAssertNotNil(contentState.lastUpdate, "Last update should be present")
    }

    /// Claude: Test content state with various aspect displays
    func testContentStateAspectDisplays() {
        let testCases = [
            "☉ ☍ ☿",   // Sun opposite Mercury
            "♀ △ ♃",   // Venus trine Jupiter
            "♂ □ ♄",   // Mars square Saturn
            "☽ ☌ ♆",   // Moon conjunct Neptune
            "",         // Empty (error case)
            "invalid"   // Invalid (error case)
        ]

        for aspectDisplay in testCases {
            let contentState = CosmicHUDWidgetAttributes.ContentState(
                rulerNumber: 5,
                realmNumber: 2,
                aspectDisplay: aspectDisplay,
                element: "💨",
                lastUpdate: Date()
            )

            XCTAssertEqual(contentState.aspectDisplay, aspectDisplay,
                          "Should store aspect display as-is: '\(aspectDisplay)'")
        }
    }

    // MARK: - HUD Intent Tests

    /// Claude: Test HUDIntent enum completeness
    func testHUDIntentEnum() {
        let allIntents = HUDIntent.allCases
        XCTAssertEqual(allIntents.count, 6, "Should have all 6 HUD intents")

        // Test specific intents
        XCTAssertTrue(allIntents.contains(.sighting), "Should include sighting")
        XCTAssertTrue(allIntents.contains(.journal), "Should include journal")
        XCTAssertTrue(allIntents.contains(.composer), "Should include composer")
        XCTAssertTrue(allIntents.contains(.rulerGraph), "Should include rulerGraph")
        XCTAssertTrue(allIntents.contains(.focusSelector), "Should include focusSelector")
        XCTAssertTrue(allIntents.contains(.cosmicSnapshot), "Should include cosmicSnapshot")

        // Test intent properties
        XCTAssertEqual(HUDIntent.sighting.displayName, "Add Sighting", "Sighting display name should be correct")
        XCTAssertEqual(HUDIntent.sighting.icon, "👁", "Sighting icon should be correct")
        XCTAssertEqual(HUDIntent.journal.displayName, "Journal Entry", "Journal display name should be correct")
        XCTAssertEqual(HUDIntent.journal.icon, "📓", "Journal icon should be correct")
    }

    /// Claude: Test HUD intent backward compatibility
    func testHUDIntentBackwardCompatibility() {
        // Test alternative case names
        XCTAssertEqual(HUDIntent.addSighting, .sighting, "addSighting should map to sighting")
        XCTAssertEqual(HUDIntent.addJournalEntry, .journal, "addJournalEntry should map to journal")
        XCTAssertEqual(HUDIntent.postStatus, .composer, "postStatus should map to composer")
        XCTAssertEqual(HUDIntent.changeFocusNumber, .focusSelector, "changeFocusNumber should map to focusSelector")
    }

    // MARK: - HaloStyle Tests

    /// Claude: Test HaloStyle enum
    func testHaloStyleEnum() {
        let allStyles = HaloStyle.allCases
        XCTAssertEqual(allStyles.count, 3, "Should have all 3 halo styles")

        // Test specific styles
        XCTAssertTrue(allStyles.contains(.star), "Should include star")
        XCTAssertTrue(allStyles.contains(.crown), "Should include crown")
        XCTAssertTrue(allStyles.contains(.sparkles), "Should include sparkles")

        // Test style symbols
        XCTAssertEqual(HaloStyle.star.symbol, "⭐", "Star symbol should be correct")
        XCTAssertEqual(HaloStyle.crown.symbol, "👑", "Crown symbol should be correct")
        XCTAssertEqual(HaloStyle.sparkles.symbol, "✨", "Sparkles symbol should be correct")
    }

    // MARK: - InsightType Tests

    /// Claude: Test InsightType enum
    func testInsightTypeEnum() {
        let kasperType = InsightType.kasper
        let templateType = InsightType.template
        let wisdomType = InsightType.wisdom

        // Test display names
        XCTAssertEqual(kasperType.displayName, "KASPER AI Insight", "KASPER display name should be correct")
        XCTAssertEqual(templateType.displayName, "Cosmic Template", "Template display name should be correct")
        XCTAssertEqual(wisdomType.displayName, "Universal Wisdom", "Wisdom display name should be correct")

        // Test icons
        XCTAssertEqual(kasperType.icon, "✨", "KASPER icon should be correct")
        XCTAssertEqual(templateType.icon, "📜", "Template icon should be correct")
        XCTAssertEqual(wisdomType.icon, "🌌", "Wisdom icon should be correct")
    }

    // MARK: - Error Handling Tests

    /// Claude: Test HUD data handles invalid inputs gracefully
    func testHUDDataErrorHandling() {
        // Test with invalid ruler number
        let invalidHUDData = HUDData(
            rulerNumber: 0, // Invalid
            dominantAspect: nil,
            element: .fire,
            lastCalculated: Date(),
            allAspects: [],
            vfi: 0.0
        )

        // Should store values without crashing (validation happens elsewhere)
        XCTAssertEqual(invalidHUDData.rulerNumber, 0, "Should store invalid ruler number")
        XCTAssertNil(invalidHUDData.dominantAspect, "Should handle nil dominant aspect")
        XCTAssertEqual(invalidHUDData.allAspects.count, 0, "Should handle empty aspects array")

        // Test compact display with no aspect
        let compactDisplay = invalidHUDData.compactDisplay
        XCTAssertTrue(compactDisplay.contains("No aspects"), "Should handle missing aspect gracefully")
    }

    /// Claude: Test aspect data with extreme values
    func testAspectDataExtremeValues() {
        let extremeAspect = AspectData(
            planet1: .sun,
            planet2: .pluto,
            aspect: .quincunx,
            orb: 29.99, // Very wide orb
            isApplying: true
        )

        // Should handle extreme but valid values
        XCTAssertEqual(extremeAspect.orb, 29.99, "Should handle wide orb")
        XCTAssertEqual(extremeAspect.planet1, .sun, "Should handle sun")
        XCTAssertEqual(extremeAspect.planet2, .pluto, "Should handle pluto")
        XCTAssertEqual(extremeAspect.aspect, .quincunx, "Should handle quincunx")

        let description = extremeAspect.description
        XCTAssertEqual(description, "Sun Quincunx Pluto", "Should generate correct description")
    }

    // MARK: - Performance Tests

    /// Claude: Test HUD data structure creation performance
    func testHUDDataCreationPerformance() {
        let testAspect = AspectData(
            planet1: .mercury,
            planet2: .venus,
            aspect: .sextile,
            orb: 2.0,
            isApplying: false
        )

        measure {
            for i in 0..<1000 {
                _ = HUDData(
                    rulerNumber: (i % 9) + 1,
                    dominantAspect: testAspect,
                    element: HUDElement.allCases[i % 4],
                    lastCalculated: Date(),
                    allAspects: [testAspect],
                    vfi: Double(i) * 0.1
                )
            }
        }
    }

    /// Claude: Test aspect data creation performance
    func testAspectDataCreationPerformance() {
        let planets = HUDPlanet.allCases
        let aspects = HUDAspect.allCases

        measure {
            for i in 0..<1000 {
                _ = AspectData(
                    planet1: planets[i % planets.count],
                    planet2: planets[(i + 1) % planets.count],
                    aspect: aspects[i % aspects.count],
                    orb: Double(i % 30),
                    isApplying: i % 2 == 0
                )
            }
        }
    }

    /// Claude: Test content state creation performance
    func testContentStateCreationPerformance() {
        measure {
            for i in 0..<1000 {
                _ = CosmicHUDWidgetAttributes.ContentState(
                    rulerNumber: (i % 9) + 1,
                    realmNumber: (i % 9) + 1,
                    aspectDisplay: "☉ ☍ ☿",
                    element: "🔥",
                    lastUpdate: Date()
                )
            }
        }
    }
}
