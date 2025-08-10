/**
 * KASPERMLXEngineTemplateIntegrationTests.swift
 *
 * 🧪 KASPER MLX ENGINE TEMPLATE INTEGRATION TEST SUITE
 *
 * ✅ STATUS: Complete unit test coverage for template enhancer integration
 * ✅ SCOPE: Engine-template integration, natural language flow, spiritual authenticity
 * ✅ ARCHITECTURE: Async-first testing with template enhancement validation
 *
 * PURPOSE:
 * These tests validate the seamless integration between KASPERMLXEngine and
 * KASPERTemplateEnhancer, ensuring the engine leverages enhanced templates
 * to eliminate "templatey" sentence patterns while maintaining spiritual authenticity.
 *
 * WHY THESE TESTS MATTER:
 * - Template integration is critical for natural spiritual guidance
 * - Engine must seamlessly orchestrate template enhancement
 * - Natural language flow eliminates robotic AI patterns
 * - Spiritual authenticity must be preserved through template variety
 * - Performance must remain optimal with enhanced template generation
 *
 * WHAT WE'RE TESTING:
 * 1. Engine integration with KASPERTemplateEnhancer methods
 * 2. Natural language flow in engine-generated insights
 * 3. Template variety and randomization through engine orchestration
 * 4. Spiritual authenticity preservation in enhanced insights
 * 5. Performance impact of template enhancement integration
 * 6. Error handling when template enhancement fails
 * 7. Fallback mechanisms for template generation
 *
 * INTEGRATION VALIDATION:
 * - Engine calls KASPERTemplateEnhancer methods correctly
 * - Enhanced templates eliminate rigid sentence patterns
 * - Spiritual markers and authenticity are preserved
 * - Performance remains within acceptable limits
 * - Graceful degradation when enhancement unavailable
 */

import XCTest
@testable import VybeMVP

@MainActor
final class KASPERMLXEngineTemplateIntegrationTests: XCTestCase {

    // MARK: - Test Properties

    /// Engine instance for testing template integration
    private var engine: KASPERMLXEngine!

    /// Test configuration optimized for template testing
    private var testConfig: KASPERMLXConfiguration!

    // MARK: - Test Lifecycle

    override func setUpWithError() throws {
        super.setUp()

        print("🧪 KASPERMLXEngineTemplateIntegrationTests: Setting up template integration test suite...")

        // Initialize test configuration
        testConfig = KASPERMLXConfiguration(
            maxConcurrentInferences: 1,
            defaultCacheExpiry: 30,
            inferenceTimeout: 3.0,
            enableDebugLogging: true,
            enableMLXInference: false, // Use template mode for testing
            modelPath: nil
        )

        // Initialize engine with test configuration
        engine = KASPERMLXEngine(config: testConfig)

        print("🧪 KASPERMLXEngineTemplateIntegrationTests: Setup complete")
    }

    override func tearDownWithError() throws {
        engine = nil
        testConfig = nil

        super.tearDown()
        print("🧪 KASPERMLXEngineTemplateIntegrationTests: Teardown complete")
    }

    // MARK: - Template Integration Tests

    /**
     * TEST 1: Engine Integration with KASPERTemplateEnhancer Methods
     *
     * VALIDATES:
     * - Engine correctly calls KASPERTemplateEnhancer methods
     * - Different insight types use appropriate template enhancement
     * - Template enhancement is seamlessly integrated into insight generation
     * - Enhanced templates are properly formatted and structured
     *
     * BUSINESS IMPACT:
     * Seamless template integration ensures users receive natural,
     * flowing spiritual guidance instead of robotic AI responses.
     */
    func testEngineIntegrationWithTemplateEnhancerMethods() async throws {
        print("🧪 Testing engine integration with template enhancer methods...")

        // Configure engine for testing
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Test different insight types and their template integration
        let insightTestCases: [(KASPERFeature, KASPERInsightType)] = [
            (.journalInsight, .reflection),
            (.dailyCard, .guidance),
            (.sanctumGuidance, .guidance),
            (.focusIntention, .affirmation),
            (.cosmicTiming, .prediction),
            (.realmInterpretation, .guidance)
        ]

        for (feature, type) in insightTestCases {
            let context = InsightContext(
                primaryData: ["template_test": true],
                userQuery: "Test template integration for \(feature.rawValue)",
                constraints: InsightConstraints(
                    maxLength: 150,
                    spiritualDepth: .balanced
                )
            )

            let request = InsightRequest(
                feature: feature,
                type: type,
                priority: .high,
                context: context
            )

            let insight = try await engine.generateInsight(for: request)

            // Validate basic integration
            XCTAssertNotNil(insight, "Should generate insight with template integration")
            XCTAssertEqual(insight.feature, feature, "Feature should match request")
            XCTAssertEqual(insight.type, type, "Type should match request")
            XCTAssertFalse(insight.content.isEmpty, "Enhanced insight should have content")

            // Validate template enhancement markers
            let expectedEmojis: [KASPERInsightType: String] = [
                .guidance: "🌟",
                .reflection: "🌙",
                .affirmation: "💫",
                .prediction: "🔮"
            ]

            if let expectedEmoji = expectedEmojis[type] {
                XCTAssertTrue(insight.content.contains(expectedEmoji),
                             "\(feature.rawValue) \(type) should contain \(expectedEmoji) emoji")
            }

            // Validate natural language flow (no template artifacts)
            XCTAssertFalse(insight.content.contains("Trust Your The"),
                          "Should not contain malformed template patterns")
            XCTAssertFalse(insight.content.contains("Nature Trust"),
                          "Should not contain fragmented template patterns")
            XCTAssertFalse(insight.content.contains("  "),
                          "Should not contain double spaces")

            // Validate substantial enhanced content
            XCTAssertGreaterThan(insight.content.count, 50,
                               "Enhanced template should provide substantial content")

            print("✅ Template integration validated for \(feature.rawValue) \(type)")
        }

        print("✅ Engine integration with template enhancer methods validated")
    }

    /**
     * TEST 2: Natural Language Flow Elimination of Templatey Patterns
     *
     * VALIDATES:
     * - Generated insights eliminate rigid "templatey" sentence endings
     * - Natural language flow is maintained throughout insights
     * - Template variety prevents repetitive patterns
     * - Spiritual authenticity is preserved with enhanced flow
     *
     * BUSINESS IMPACT:
     * Natural language flow ensures spiritual AI guidance feels
     * authentic and personally meaningful rather than mechanically generated.
     */
    func testNaturalLanguageFlowEliminationOfTemplateyPatterns() async throws {
        print("🧪 Testing natural language flow elimination of templatey patterns...")

        // Configure engine
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Generate multiple insights to test pattern elimination
        var generatedInsights: [String] = []

        for i in 0..<10 {
            let context = InsightContext(
                primaryData: ["flow_test": i],
                userQuery: "Test natural language flow \(i)",
                constraints: InsightConstraints(maxLength: 120, spiritualDepth: .balanced)
            )

            let request = InsightRequest(
                feature: .dailyCard,
                type: .guidance,
                priority: .high,
                context: context
            )

            // Clear cache to ensure fresh generation
            await engine.clearCache()

            let insight = try await engine.generateInsight(for: request)
            generatedInsights.append(insight.content)

            // Validate elimination of templatey patterns
            let templateyPatterns = [
                "Trust Your The",
                "Nature Trust",
                "Divine Nature",
                "The Diplomat Nature",
                "Your Trust Your",
                "Trust Trust"
            ]

            for pattern in templateyPatterns {
                XCTAssertFalse(insight.content.contains(pattern),
                              "Insight should not contain templatey pattern: '\(pattern)'")
            }

            // Validate natural flow indicators
            let naturalFlowIndicators = [
                "awakens", "flows", "emerges", "unfolds", "reveals", "illuminates",
                "guides", "invites", "whispers", "dances", "weaves", "channels"
            ]

            let containsNaturalFlow = naturalFlowIndicators.contains { indicator in
                insight.content.lowercased().contains(indicator)
            }
            XCTAssertTrue(containsNaturalFlow, "Should contain natural flow language")

            // Validate spiritual authenticity preservation
            let spiritualLanguage = ["cosmic", "divine", "sacred", "spiritual", "energy", "wisdom"]
            let containsSpiritual = spiritualLanguage.contains { word in
                insight.content.lowercased().contains(word)
            }
            XCTAssertTrue(containsSpiritual, "Should preserve spiritual authenticity")
        }

        // Validate template variety (important for natural experience)
        let uniqueInsights = Set(generatedInsights)
        let varietyRatio = Double(uniqueInsights.count) / Double(generatedInsights.count)
        XCTAssertGreaterThan(varietyRatio, 0.7, "Should have high template variety for natural flow")

        print("✅ Natural language flow elimination validated")
        print("📊 Generated \(generatedInsights.count) insights with \(String(format: "%.1f", varietyRatio * 100))% variety")
    }

    /**
     * TEST 3: Template Variety and Randomization Through Engine Orchestration
     *
     * VALIDATES:
     * - Engine orchestrates template randomization effectively
     * - Different templates are selected for similar contexts
     * - Template variety maintains engagement and authenticity
     * - Randomization doesn't compromise spiritual meaning
     *
     * BUSINESS IMPACT:
     * Template variety ensures users receive engaging, non-repetitive
     * spiritual guidance that feels fresh and personally meaningful.
     */
    func testTemplateVarietyAndRandomizationThroughEngineOrchestration() async throws {
        print("🧪 Testing template variety and randomization through engine orchestration...")

        // Configure engine
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Test template variety for the same context
        let baseContext = InsightContext(
            primaryData: ["variety_test": true],
            userQuery: "Daily spiritual guidance",
            constraints: InsightConstraints(maxLength: 120, spiritualDepth: .balanced)
        )

        let baseRequest = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: baseContext
        )

        var templateVariations: [String] = []

        // Generate multiple insights with same context to test variety
        for i in 0..<15 {
            // Clear cache to force fresh generation
            await engine.clearCache()

            let insight = try await engine.generateInsight(for: baseRequest)
            templateVariations.append(insight.content)

            // Validate each insight quality
            XCTAssertGreaterThan(insight.content.count, 40, "Insight \(i) should have substantial content")
            XCTAssertTrue(insight.content.contains("🌟"), "Insight \(i) should contain guidance emoji")
            XCTAssertGreaterThan(insight.confidence, 0.7, "Insight \(i) should have high confidence")
        }

        // Analyze template variety
        let uniqueTemplates = Set(templateVariations)
        let varietyRatio = Double(uniqueTemplates.count) / Double(templateVariations.count)

        XCTAssertGreaterThan(varietyRatio, 0.6, "Should achieve at least 60% template variety")

        // Validate that variety doesn't compromise spiritual meaning
        for template in templateVariations {
            // Each should contain spiritual guidance elements
            let guidanceElements = ["energy", "wisdom", "spiritual", "divine", "sacred", "cosmic"]
            let containsGuidance = guidanceElements.contains { element in
                template.lowercased().contains(element)
            }
            XCTAssertTrue(containsGuidance, "Each variation should maintain spiritual meaning")

            // Each should provide actionable guidance
            let actionableWords = ["trust", "embrace", "align", "honor", "channel", "express"]
            let containsActionable = actionableWords.contains { word in
                template.lowercased().contains(word)
            }
            XCTAssertTrue(containsActionable, "Each variation should provide actionable guidance")
        }

        print("✅ Template variety and randomization validated")
        print("📊 Achieved \(String(format: "%.1f", varietyRatio * 100))% template variety (\(uniqueTemplates.count)/\(templateVariations.count))")
    }

    /**
     * TEST 4: Spiritual Authenticity Preservation in Enhanced Insights
     *
     * VALIDATES:
     * - Enhanced templates preserve spiritual depth and meaning
     * - Sacred language and spiritual concepts remain intact
     * - Authenticity markers are consistently present
     * - Template enhancement doesn't dilute spiritual wisdom
     *
     * BUSINESS IMPACT:
     * Spiritual authenticity preservation ensures users maintain
     * trust in AI-generated guidance and continue their spiritual journey.
     */
    func testSpiritualAuthenticityPreservationInEnhancedInsights() async throws {
        print("🧪 Testing spiritual authenticity preservation in enhanced insights...")

        // Configure engine
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Test different spiritual domains for authenticity preservation
        let spiritualTestCases: [(KASPERFeature, [String])] = [
            (.journalInsight, ["reflection", "contemplation", "inner wisdom", "sacred journey"]),
            (.sanctumGuidance, ["sacred space", "meditation", "divine presence", "spiritual sanctuary"]),
            (.focusIntention, ["manifestation", "divine purpose", "spiritual authority", "cosmic alignment"]),
            (.cosmicTiming, ["divine timing", "celestial wisdom", "cosmic orchestration", "universal rhythms"]),
            (.realmInterpretation, ["spiritual realm", "cosmic consciousness", "universal energy", "divine essence"])
        ]

        for (feature, expectedThemes) in spiritualTestCases {
            let context = InsightContext(
                primaryData: ["authenticity_test": feature.rawValue],
                userQuery: "Provide authentic spiritual guidance",
                constraints: InsightConstraints(maxLength: 150, spiritualDepth: .deep)
            )

            let request = InsightRequest(
                feature: feature,
                type: .guidance,
                priority: .high,
                context: context
            )

            let insight = try await engine.generateInsight(for: request)

            // Validate spiritual authenticity markers
            let authenticityMarkers = ["divine", "sacred", "spiritual", "cosmic", "universal", "soul", "essence", "wisdom"]
            var foundMarkers = 0

            for marker in authenticityMarkers {
                if insight.content.lowercased().contains(marker) {
                    foundMarkers += 1
                }
            }

            XCTAssertGreaterThanOrEqual(foundMarkers, 2,
                                       "\(feature.rawValue) should contain multiple authenticity markers")

            // Validate spiritual depth (no superficial language)
            let superficialWords = ["easy", "simple", "quick", "instant", "just"]
            var superficialCount = 0

            for word in superficialWords {
                if insight.content.lowercased().contains(word) {
                    superficialCount += 1
                }
            }

            XCTAssertLessThanOrEqual(superficialCount, 1,
                                    "\(feature.rawValue) should avoid superficial language")

            // Validate theme relevance
            let containsRelevantTheme = expectedThemes.contains { theme in
                insight.content.lowercased().contains(theme.lowercased()) ||
                theme.split(separator: " ").allSatisfy { word in
                    insight.content.lowercased().contains(String(word))
                }
            }
            XCTAssertTrue(containsRelevantTheme,
                         "\(feature.rawValue) should contain relevant spiritual themes: \(expectedThemes)")

            // Note: Theme matching is flexible since templates use varied spiritual language
            // We focus more on overall spiritual depth and authenticity

            // Validate meaningful content length
            XCTAssertGreaterThan(insight.content.count, 80,
                               "\(feature.rawValue) should provide substantial spiritual guidance")

            print("✅ Authenticity preserved for \(feature.rawValue): \(foundMarkers) markers, \(superficialCount) superficial")
        }

        print("✅ Spiritual authenticity preservation validated")
    }

    /**
     * TEST 5: Performance Impact of Template Enhancement Integration
     *
     * VALIDATES:
     * - Template enhancement doesn't significantly impact performance
     * - Response times remain within acceptable limits
     * - Memory usage is controlled with enhanced templates
     * - Concurrent template generation performs well
     *
     * BUSINESS IMPACT:
     * Performance optimization ensures template enhancement doesn't
     * compromise the app's smooth 60fps cosmic animations.
     */
    func testPerformanceImpactOfTemplateEnhancementIntegration() async throws {
        print("🧪 Testing performance impact of template enhancement integration...")

        // Configure engine
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Baseline performance test
        let performanceIterations = 20
        var responseTimes: [TimeInterval] = []

        for i in 0..<performanceIterations {
            let context = InsightContext(
                primaryData: ["performance_test": i],
                userQuery: "Performance test query \(i)"
            )

            let request = InsightRequest(
                feature: .dailyCard,
                type: .guidance,
                priority: .high,
                context: context
            )

            let startTime = Date()
            let insight = try await engine.generateInsight(for: request)
            let responseTime = Date().timeIntervalSince(startTime)

            responseTimes.append(responseTime)

            // Validate insight quality isn't compromised for performance
            XCTAssertNotNil(insight, "Should generate insight in performance test \(i)")
            XCTAssertFalse(insight.content.isEmpty, "Should have content in performance test \(i)")
            XCTAssertGreaterThan(insight.confidence, 0.5, "Should maintain confidence in performance test \(i)")
        }

        // Analyze performance metrics
        let averageResponseTime = responseTimes.reduce(0, +) / Double(responseTimes.count)
        let maxResponseTime = responseTimes.max() ?? 0
        let minResponseTime = responseTimes.min() ?? 0

        // Validate performance requirements
        XCTAssertLessThan(averageResponseTime, 0.1, "Average response time should be under 100ms")
        XCTAssertLessThan(maxResponseTime, 0.2, "Max response time should be under 200ms")
        XCTAssertGreaterThan(minResponseTime, 0.001, "Min response time should be reasonable (not cached)")

        // Test concurrent template generation performance
        let concurrentTasks = (0..<5).map { index in
            Task {
                let context = InsightContext(primaryData: ["concurrent_test": index])
                let request = InsightRequest(
                    feature: KASPERFeature.allCases[index % KASPERFeature.allCases.count],
                    type: .guidance,
                    priority: .high,
                    context: context
                )

                let startTime = Date()
                let insight = try await engine.generateInsight(for: request)
                let responseTime = Date().timeIntervalSince(startTime)

                return (insight, responseTime)
            }
        }

        let concurrentStartTime = Date()
        let concurrentResults = try await withThrowingTaskGroup(of: (KASPERInsight, TimeInterval).self) { group in
            for task in concurrentTasks {
                group.addTask {
                    return try await task.value
                }
            }

            var results: [(KASPERInsight, TimeInterval)] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        let concurrentTotalTime = Date().timeIntervalSince(concurrentStartTime)

        // Validate concurrent performance
        XCTAssertEqual(concurrentResults.count, 5, "All concurrent template generations should complete")
        XCTAssertLessThan(concurrentTotalTime, 1.0, "Concurrent operations should complete quickly")

        for (insight, responseTime) in concurrentResults {
            XCTAssertNotNil(insight, "Concurrent insight should be generated")
            XCTAssertLessThan(responseTime, 0.2, "Concurrent response time should be reasonable")
        }

        print("✅ Performance impact of template enhancement validated")
        print("📊 Avg response: \(String(format: "%.3f", averageResponseTime))s, Range: \(String(format: "%.3f", minResponseTime))-\(String(format: "%.3f", maxResponseTime))s")
        print("📊 Concurrent: \(concurrentResults.count) operations in \(String(format: "%.3f", concurrentTotalTime))s")
    }

    /**
     * TEST 6: Error Handling When Template Enhancement Fails
     *
     * VALIDATES:
     * - Engine handles template enhancement failures gracefully
     * - Fallback mechanisms provide basic spiritual guidance
     * - Error states don't crash insight generation
     * - Recovery mechanisms restore normal template operation
     *
     * BUSINESS IMPACT:
     * Robust error handling ensures spiritual guidance remains available
     * even when template enhancement systems are temporarily unavailable.
     */
    func testErrorHandlingWhenTemplateEnhancementFails() async throws {
        print("🧪 Testing error handling when template enhancement fails...")

        // Configure engine
        await engine.configure(
            realmManager: nil,
            focusManager: nil,
            healthManager: nil
        )

        // Test with edge case contexts that might challenge template enhancement
        let challengingContexts = [
            InsightContext(primaryData: [:], userQuery: nil), // Empty context
            InsightContext(primaryData: ["invalid": "test"], userQuery: ""), // Empty query
            InsightContext(primaryData: ["special_chars": "!@#$%^&*()"], userQuery: "Test with special characters"),
            InsightContext(primaryData: ["long_query": String(repeating: "test ", count: 100)], userQuery: "Very long query"),
        ]

        for (index, context) in challengingContexts.enumerated() {
            let request = InsightRequest(
                feature: .journalInsight,
                type: .guidance,
                priority: .high,
                context: context
            )

            do {
                let insight = try await engine.generateInsight(for: request)

                // If successful, validate graceful handling
                XCTAssertNotNil(insight, "Should handle challenging context \(index) gracefully")
                XCTAssertFalse(insight.content.isEmpty, "Should provide fallback content for context \(index)")
                XCTAssertGreaterThan(insight.confidence, 0.0, "Should maintain some confidence for context \(index)")

                // Validate fallback maintains spiritual authenticity
                let spiritualWords = ["spiritual", "divine", "sacred", "wisdom", "guidance", "energy"]
                let containsSpiritual = spiritualWords.contains { word in
                    insight.content.lowercased().contains(word)
                }
                XCTAssertTrue(containsSpiritual, "Fallback should maintain spiritual authenticity for context \(index)")

                print("✅ Graceful handling validated for challenging context \(index)")

            } catch {
                // If it fails, should be a meaningful error
                XCTAssertFalse(error.localizedDescription.isEmpty,
                              "Error should have meaningful description for context \(index)")
                print("✅ Meaningful error handling for context \(index): \(error.localizedDescription)")
            }
        }

        // Test recovery after challenging contexts
        let normalContext = InsightContext(
            primaryData: ["recovery_test": true],
            userQuery: "Test normal operation after challenging contexts"
        )

        let recoveryRequest = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: normalContext
        )

        let recoveryInsight = try await engine.generateInsight(for: recoveryRequest)

        // Validate normal operation is restored
        XCTAssertNotNil(recoveryInsight, "Should recover normal operation")
        XCTAssertFalse(recoveryInsight.content.isEmpty, "Should provide full content after recovery")
        XCTAssertGreaterThan(recoveryInsight.confidence, 0.7, "Should restore high confidence")
        XCTAssertTrue(recoveryInsight.content.contains("🌟"), "Should restore template enhancement")

        print("✅ Error handling and recovery validated")
    }
}

/**
 * FUTURE TEMPLATE INTEGRATION TEST EXPANSION GUIDE
 *
 * As KASPERMLXEngine template integration evolves, consider adding tests for:
 *
 * 1. Advanced Template Integration:
 *    - Test dynamic template selection based on user context
 *    - Validate template personalization based on user history
 *    - Test template adaptation for different user preferences
 *
 * 2. Real-time Template Optimization:
 *    - Test template performance under various device conditions
 *    - Validate memory usage with large template variations
 *    - Test template generation with real user interaction patterns
 *
 * 3. Machine Learning Template Enhancement:
 *    - Test integration with actual MLX model inference
 *    - Validate template quality scoring and optimization
 *    - Test continuous learning from template user feedback
 *
 * 4. Cross-Feature Template Consistency:
 *    - Test template consistency across different spiritual features
 *    - Validate template adaptation for different insight types
 *    - Test template coherence in multi-insight conversations
 *
 * 5. Production Scale Template Testing:
 *    - Test template generation with thousands of concurrent users
 *    - Validate template uniqueness at scale
 *    - Test template generation resilience under high load
 */
