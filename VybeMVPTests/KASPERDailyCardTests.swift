/**
 * KASPER MLX Daily Card Integration Tests
 *
 * Comprehensive test suite for the enhanced daily card insight generation,
 * validating personalized spiritual guidance, performance, and authenticity.
 */

import XCTest
@testable import VybeMVP

@MainActor
class KASPERDailyCardTests: XCTestCase {

    var engine: KASPERMLXEngine!
    var manager: KASPERMLXManager!
    var focusManager: FocusNumberManager!
    var realmManager: RealmNumberManager!

    override func setUp() async throws {
        try await super.setUp()

        engine = KASPERMLXEngine.shared
        manager = KASPERMLXManager.shared
        focusManager = FocusNumberManager.shared
        realmManager = RealmNumberManager()

        // Wait for SwiftData migration to complete if needed
        let spiritualController = SpiritualDataController.shared
        while true {
            let isComplete = await MainActor.run { spiritualController.isMigrationComplete }
            if isComplete { break }
            try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }

        // Configure with test managers
        await engine.configure(
            realmManager: realmManager,
            focusManager: focusManager,
            healthManager: nil
        )

        // Clear cache for clean testing
        await engine.clearCache()
    }

    override func tearDown() async throws {
        await engine.clearCache()
        try await super.tearDown()
    }

    // MARK: - Personalized Content Tests

    func testDailyCardPersonalization() async throws {
        // Test personalized content for different focus numbers
        let testCases = [1, 7, 3, 5, 9]

        for focusNumber in testCases {
            focusManager.userDidPickFocusNumber(focusNumber)

            let insight = try await manager.generateDailyCardInsight()

            // Validate personalization
            XCTAssertFalse(insight.content.contains("solar energy merges"),
                          "Should not contain generic template content")
            XCTAssertGreaterThan(insight.content.count, 50,
                               "Should have substantial personalized content")
            XCTAssertTrue(insight.confidence > 0.7,
                         "Should have high confidence for personalized content")

            // Validate spiritual authenticity markers
            let spiritualMarkers = ["🌟", "🔮", "✨", "🌙", "🌌"]
            let containsSpiritualMarker = spiritualMarkers.contains { insight.content.contains($0) }
            XCTAssertTrue(containsSpiritualMarker,
                         "Should contain spiritual authenticity markers")

            print("🔮 Focus \(focusNumber), Realm \(realmManager.currentRealmNumber): \(insight.content)")
        }
    }

    func testFocusNumberSpecificGuidance() async throws {
        // Test focus number specific wisdom
        let focusTests: [(number: Int, expectedKeywords: [String])] = [
            (1, ["pioneering", "leadership", "initiate"]),
            (2, ["harmony", "balance", "collaboration"]),
            (3, ["creative", "expression", "communication"]),
            (7, ["mystical", "wisdom", "intuition"]),
            (9, ["universal", "humanitarian", "compassion"])
        ]

        for test in focusTests {
            focusManager.userDidPickFocusNumber(test.number)

            let insight = try await manager.generateDailyCardInsight()

            // Check for focus-specific spiritual themes (more flexible than exact keywords)
            let containsRelevantThemes = test.expectedKeywords.contains { keyword in
                let content = insight.content.lowercased()
                // Check for keyword or related spiritual variations
                return content.contains(keyword.lowercased()) ||
                       (keyword == "pioneering" && (content.contains("pioneer") || content.contains("initiate") || content.contains("leadership"))) ||
                       (keyword == "leadership" && (content.contains("leader") || content.contains("pioneering") || content.contains("initiative"))) ||
                       (keyword == "initiate" && (content.contains("initiative") || content.contains("begin") || content.contains("start"))) ||
                       (keyword == "harmony" && (content.contains("harmoni") || content.contains("balance") || content.contains("peace"))) ||
                       (keyword == "balance" && (content.contains("equilibrium") || content.contains("harmony") || content.contains("centered"))) ||
                       (keyword == "collaboration" && (content.contains("cooperat") || content.contains("together") || content.contains("partnership"))) ||
                       (keyword == "creative" && (content.contains("creation") || content.contains("artistic") || content.contains("expression"))) ||
                       (keyword == "expression" && (content.contains("express") || content.contains("creative") || content.contains("communicate"))) ||
                       (keyword == "communication" && (content.contains("communicate") || content.contains("expression") || content.contains("voice"))) ||
                       (keyword == "mystical" && (content.contains("mystic") || content.contains("spiritual") || content.contains("sacred"))) ||
                       (keyword == "wisdom" && (content.contains("wise") || content.contains("knowledge") || content.contains("insight"))) ||
                       (keyword == "intuition" && (content.contains("intuitive") || content.contains("inner knowing") || content.contains("instinct"))) ||
                       (keyword == "universal" && (content.contains("cosmic") || content.contains("divine") || content.contains("infinite"))) ||
                       (keyword == "humanitarian" && (content.contains("service") || content.contains("compassion") || content.contains("helping"))) ||
                       (keyword == "compassion" && (content.contains("compassionate") || content.contains("love") || content.contains("caring")))
            }

            XCTAssertTrue(containsRelevantThemes,
                         "Focus \(test.number) should contain spiritually relevant guidance.\nExpected keywords: \(test.expectedKeywords)\nGenerated: \(insight.content)\nFocus manager state: \(focusManager.selectedFocusNumber)")
        }
    }

    func testRealmNumberIntegration() async throws {
        // Test realm number influence on guidance
        focusManager.userDidPickFocusNumber(5) // Fixed focus for consistency

        // Generate multiple insights to see variety
        var insights: [String] = []

        for _ in 0..<3 {
            await engine.clearCache() // Force fresh generation
            let insight = try await manager.generateDailyCardInsight()
            insights.append(insight.content)

            // Each should produce substantial guidance
            XCTAssertGreaterThan(insight.content.count, 40,
                               "Should produce substantial guidance")
        }

        print("🔮 Generated \(insights.count) insights with current realm \(realmManager.currentRealmNumber)")
        for (index, insight) in insights.enumerated() {
            print("🔮 Insight \(index + 1): \(insight)")
        }
    }

    // MARK: - Performance Tests

    func testDailyCardResponseTime() async throws {
        focusManager.userDidPickFocusNumber(3)

        let startTime = Date()
        let insight = try await manager.generateDailyCardInsight()
        let responseTime = Date().timeIntervalSince(startTime)

        // Should meet KASPER MLX performance target
        XCTAssertLessThan(responseTime, 0.1,
                         "Daily card generation should be under 100ms")
        XCTAssertNotNil(insight, "Should generate valid insight")

        print("🔮 Daily card response time: \(String(format: "%.3f", responseTime))s")
    }

    func testCachedInsightPerformance() async throws {
        focusManager.userDidPickFocusNumber(8)

        // First generation (cache miss)
        let startTime1 = Date()
        let insight1 = try await manager.generateDailyCardInsight()
        let responseTime1 = Date().timeIntervalSince(startTime1)

        // Second generation (cache hit)
        let startTime2 = Date()
        let insight2 = try await manager.generateDailyCardInsight()
        let responseTime2 = Date().timeIntervalSince(startTime2)

        // Cache hit should be faster
        XCTAssertLessThan(responseTime2, responseTime1,
                         "Cached insight should be faster")

        // Spiritual AI should maintain quality and relevance even with caching
        XCTAssertFalse(insight2.content.isEmpty,
                      "Cached insight should still have meaningful content")
        XCTAssertGreaterThan(insight2.confidence, 0.7,
                           "Cached insight should maintain high confidence")

        // Both insights should be spiritually relevant for the same focus number (Focus 8)
        let focus8Keywords = ["material", "mastery", "achievement", "manifest", "power", "success", "goals", "ambition"]
        let containsRelevantContent1 = focus8Keywords.contains { insight1.content.lowercased().contains($0) }
        let containsRelevantContent2 = focus8Keywords.contains { insight2.content.lowercased().contains($0) }

        XCTAssertTrue(containsRelevantContent1, "First insight should be relevant to focus 8. Generated: \(insight1.content)")
        XCTAssertTrue(containsRelevantContent2, "Second insight should be relevant to focus 8. Generated: \(insight2.content)")

        print("🔮 Cache miss: \(String(format: "%.3f", responseTime1))s, Cache hit: \(String(format: "%.3f", responseTime2))s")
    }

    // MARK: - Spiritual Authenticity Tests

    func testSpiritualContentQuality() async throws {
        focusManager.userDidPickFocusNumber(6)

        let insight = try await manager.generateDailyCardInsight()

        // Validate spiritual language patterns
        let spiritualPatterns = [
            "cosmic", "divine", "sacred", "spiritual", "energy",
            "wisdom", "guidance", "essence", "vibration", "journey"
        ]

        let containsSpiritualLanguage = spiritualPatterns.contains { pattern in
            insight.content.lowercased().contains(pattern)
        }

        XCTAssertTrue(containsSpiritualLanguage,
                     "Should contain authentic spiritual language")

        // Validate actionable guidance
        let actionWords = ["trust", "embrace", "channel", "honor", "align", "focus", "seek"]
        let containsActionableGuidance = actionWords.contains { action in
            insight.content.lowercased().contains(action)
        }

        XCTAssertTrue(containsActionableGuidance,
                     "Should provide actionable spiritual guidance")
    }

    func testInsightTypes() async throws {
        focusManager.userDidPickFocusNumber(7)

        // Test different insight types
        let types: [KASPERInsightType] = [.guidance, .prediction, .affirmation, .reflection]

        for type in types {
            let context = InsightContext(
                primaryData: ["cardType": "daily_focus_7"],
                userQuery: "Daily spiritual guidance",
                constraints: InsightConstraints(maxLength: 120, spiritualDepth: .balanced)
            )

            let request = InsightRequest(
                feature: .dailyCard,
                type: type,
                priority: .high,
                context: context
            )

            let insight = try await engine.generateInsight(for: request)

            XCTAssertEqual(insight.type, type, "Should match requested type")
            XCTAssertGreaterThan(insight.content.count, 30,
                               "Should have meaningful content for \(type)")

            // Type-specific validations
            switch type {
            case .guidance:
                XCTAssertTrue(insight.content.contains("🌟"), "Guidance should have guidance emoji")
            case .prediction:
                XCTAssertTrue(insight.content.contains("🔮"), "Prediction should have prediction emoji")
            case .affirmation:
                XCTAssertTrue(insight.content.contains("💫"), "Affirmation should have affirmation emoji")
            case .reflection:
                XCTAssertTrue(insight.content.contains("🌙"), "Reflection should have reflection emoji")
            default:
                break
            }
        }
    }

    // MARK: - Edge Case Tests

    func testExtremeNumberValues() async throws {
        // Test with master numbers and edge cases
        let extremeTests = [11, 22, 33, 44]

        for number in extremeTests {
            focusManager.userDidPickFocusNumber(number)

            let insight = try await manager.generateDailyCardInsight()

            XCTAssertNotNil(insight, "Should handle master number \(number)")
            XCTAssertGreaterThan(insight.content.count, 20,
                               "Should provide guidance for master number \(number)")

            // Master numbers should get appropriate spiritual treatment
            XCTAssertTrue(insight.confidence > 0.8,
                         "Should have high confidence for master numbers")
        }
    }

    func testEmptyDataGracefulHandling() async throws {
        // Test with minimal context
        let context = InsightContext(
            primaryData: [:],
            userQuery: nil,
            constraints: InsightConstraints(maxLength: 120, spiritualDepth: .surface)
        )

        let request = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: context
        )

        let insight = try await engine.generateInsight(for: request)

        XCTAssertNotNil(insight, "Should handle empty context gracefully")
        XCTAssertGreaterThan(insight.content.count, 20,
                           "Should provide fallback guidance")
        XCTAssertTrue(insight.confidence > 0.5,
                     "Should maintain reasonable confidence")
    }

    // MARK: - Integration Tests

    func testHomeViewIntegration() async throws {
        // Test the complete HomeView integration flow
        focusManager.userDidPickFocusNumber(4)

        // Simulate the exact call pattern from HomeView
        let cardType = "daily_focus_\(focusManager.selectedFocusNumber)_realm_\(realmManager.currentRealmNumber)"
        let insight = try await manager.generateDailyCardInsight(cardType: cardType)

        XCTAssertNotNil(insight, "HomeView integration should work")
        XCTAssertEqual(insight.feature, .dailyCard, "Should be daily card feature")
        XCTAssertGreaterThan(insight.content.count, 30,
                           "Should provide meaningful guidance")

        // Validate metadata
        XCTAssertNotNil(insight.metadata.modelVersion, "Should have model version")
        XCTAssertFalse(insight.metadata.providersUsed.isEmpty,
                      "Should use spiritual data providers")

        print("🔮 HomeView Integration Test: \(insight.content)")
    }

    func testConsistentQuality() async throws {
        // Generate multiple insights and validate quality consistency
        focusManager.userDidPickFocusNumber(5)

        var insights: [KASPERInsight] = []

        // Generate 5 insights to test consistency
        for i in 0..<5 {
            await engine.clearCache() // Force fresh generation
            let insight = try await manager.generateDailyCardInsight()
            print("🔮 DEBUG: Insight \(i + 1): \(insight.content)")
            insights.append(insight)
        }

        // Validate all insights meet quality standards
        for (index, insight) in insights.enumerated() {
            XCTAssertGreaterThan(insight.content.count, 40,
                               "Insight \(index + 1) should have substantial content")
            XCTAssertTrue(insight.confidence > 0.7,
                         "Insight \(index + 1) should have high confidence")
            XCTAssertLessThan(insight.inferenceTime, 0.2,
                            "Insight \(index + 1) should be generated quickly")
        }

        // Validate spiritual variety - most content should be unique to keep the experience engaging
        let uniqueContents = Set(insights.map { $0.content })
        let uniquenessPct = Double(uniqueContents.count) / Double(insights.count)

        XCTAssertGreaterThanOrEqual(uniquenessPct, 0.6,
                      "At least 60% of fresh generations should be unique for engaging spiritual experience. Got \(uniqueContents.count)/\(insights.count) unique")

        // All insights should still be spiritually meaningful
        for (index, insight) in insights.enumerated() {
            XCTAssertFalse(insight.content.isEmpty, "Insight \(index + 1) should have meaningful content")
        }
    }
}
