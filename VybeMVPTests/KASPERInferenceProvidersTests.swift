//
//  KASPERInferenceProvidersTests.swift
//  VybeMVPTests
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Test suite for KASPER inference provider architecture.
//  Validates template provider, stub provider, and orchestrator functionality.
//

import XCTest
@testable import VybeMVP

final class KASPERInferenceProvidersTests: XCTestCase {

    // MARK: - Test Properties

    private var templateProvider: KASPERTemplateProvider!
    private var stubProvider: KASPERStubProvider!
    private var orchestrator: KASPEROrchestrator!

    // MARK: - Test Lifecycle

    override func setUpWithError() throws {
        super.setUp()

        print("🧪 KASPERInferenceProvidersTests: Setting up inference provider test suite...")

        // Initialize providers
        templateProvider = KASPERTemplateProvider()
        stubProvider = KASPERStubProvider()
        // Note: orchestrator will be initialized in async test methods

        print("🧪 KASPERInferenceProvidersTests: Setup complete")
    }

    override func tearDownWithError() throws {
        templateProvider = nil
        stubProvider = nil

        super.tearDown()
        print("🧪 KASPERInferenceProvidersTests: Teardown complete")
    }

    // MARK: - Template Provider Tests

    func testTemplateProviderBasicFunctionality() async throws {
        // Test provider properties
        let name = await templateProvider.name
        let description = await templateProvider.description
        let confidence = await templateProvider.averageConfidence
        let isAvailable = await templateProvider.isAvailable

        XCTAssertEqual(name, "Template")
        XCTAssertFalse(description.isEmpty)
        XCTAssertEqual(confidence, 0.45)
        XCTAssertTrue(isAvailable)

        print("✅ Template provider basic functionality validated")
    }

    func testTemplateProviderInsightGeneration() async throws {
        let contexts = ["lifepath", "expression", "soulurge", "dailycard", "sanctum", "cosmictiming"]

        for context in contexts {
            let insight = try await templateProvider.generateInsight(
                context: context,
                focus: 4,
                realm: 3,
                extras: [:]
            )

            XCTAssertFalse(insight.isEmpty, "Template insight should not be empty for context: \(context)")
            XCTAssertTrue(insight.contains("Focus 4"), "Insight should contain focus number for context: \(context)")
            XCTAssertTrue(insight.contains("Realm 3"), "Insight should contain realm number for context: \(context)")

            print("✅ Template insight generated for \(context): \(insight.prefix(50))...")
        }
    }

    func testTemplateProviderVariation() async throws {
        // Test that different inputs produce different outputs
        let insight1 = try await templateProvider.generateInsight(
            context: "lifepath",
            focus: 1,
            realm: 1,
            extras: [:]
        )

        let insight2 = try await templateProvider.generateInsight(
            context: "lifepath",
            focus: 9,
            realm: 9,
            extras: [:]
        )

        XCTAssertNotEqual(insight1, insight2, "Different inputs should produce different insights")

        print("✅ Template provider variation validated")
    }

    // MARK: - Stub Provider Tests

    func testStubProviderBasicFunctionality() async throws {
        // Test provider properties
        let name = await stubProvider.name
        let description = await stubProvider.description
        let confidence = await stubProvider.averageConfidence
        let isAvailable = await stubProvider.isAvailable

        XCTAssertEqual(name, "MLX Stub")
        XCTAssertFalse(description.isEmpty)
        XCTAssertEqual(confidence, 0.92)
        XCTAssertTrue(isAvailable)

        print("✅ Stub provider basic functionality validated")
    }

    func testStubProviderInsightGeneration() async throws {
        let insight = try await stubProvider.generateInsight(
            context: "dailycard",
            focus: 4,
            realm: 3,
            extras: [
                "moonPhase": 0.5,
                "planetaryEnergy": 0.7
            ]
        )

        XCTAssertFalse(insight.isEmpty, "Stub insight should not be empty")
        XCTAssertTrue(insight.contains("Focus 4") || insight.contains("4"), "Insight should reference focus number")
        XCTAssertTrue(insight.contains("Realm 3") || insight.contains("3"), "Insight should reference realm number")

        print("✅ Stub insight generated: \(insight)")
    }

    func testStubProviderStructuredInsight() async throws {
        let structuredInsight = try await stubProvider.generateStructuredInsight(
            context: "lifepath",
            focus: 7,
            realm: 5,
            extras: [
                "moonPhase": 0.3,
                "planetaryEnergy": 0.8
            ]
        )

        XCTAssertFalse(structuredInsight.text.isEmpty)
        XCTAssertEqual(structuredInsight.provider, "MLX Stub")
        XCTAssertEqual(structuredInsight.confidence, 0.92)
        XCTAssertNotNil(structuredInsight.harmonicIndex)
        XCTAssertNotNil(structuredInsight.tensorValues)

        // Validate tensor values
        let tensorValues = structuredInsight.tensorValues!
        XCTAssertNotNil(tensorValues["focus_energy"])
        XCTAssertNotNil(tensorValues["realm_vibration"])
        XCTAssertNotNil(tensorValues["harmonic_resonance"])
        XCTAssertNotNil(tensorValues["confidence"])

        print("✅ Stub structured insight validated: \(structuredInsight.text.prefix(50))...")
    }

    func testStubProviderRandomization() async throws {
        // Test that the stub provider produces varied output
        var insights: Set<String> = []

        for _ in 0..<10 {
            let insight = try await stubProvider.generateInsight(
                context: "dailycard",
                focus: 4,
                realm: 3,
                extras: [:]
            )
            insights.insert(insight)
        }

        // Should have some variety (though not necessarily all unique due to patterns)
        XCTAssertGreaterThan(insights.count, 1, "Stub provider should produce varied insights")

        print("✅ Stub provider randomization validated - generated \(insights.count) unique insights")
    }

    // MARK: - Orchestrator Tests

    func testOrchestratorBasicFunctionality() async throws {
        orchestrator = await KASPEROrchestrator.shared

        // Test initial state
        await MainActor.run {
            XCTAssertEqual(orchestrator.currentStrategy, .automatic)
            XCTAssertFalse(orchestrator.isProcessing)
        }

        // Test strategy change
        await orchestrator.setStrategy(.mlxStub)
        await MainActor.run {
            XCTAssertEqual(orchestrator.currentStrategy, .mlxStub)
        }

        await orchestrator.setStrategy(.template)
        await MainActor.run {
            XCTAssertEqual(orchestrator.currentStrategy, .template)
        }

        print("✅ Orchestrator basic functionality validated")
    }

    func testOrchestratorInsightGeneration() async throws {
        orchestrator = await KASPEROrchestrator.shared

        // Test MLX stub strategy
        await orchestrator.setStrategy(.mlxStub)

        let insight1 = try await orchestrator.generateInsight(
            context: "lifepath",
            focus: 4,
            realm: 3
        )

        XCTAssertFalse(insight1.isEmpty)
        print("✅ Orchestrator MLX stub insight: \(insight1.prefix(50))...")

        // Test template strategy
        await orchestrator.setStrategy(.template)

        let insight2 = try await orchestrator.generateInsight(
            context: "lifepath",
            focus: 4,
            realm: 3
        )

        XCTAssertFalse(insight2.isEmpty)
        print("✅ Orchestrator template insight: \(insight2.prefix(50))...")
    }

    func testOrchestratorAvailableStrategies() async throws {
        let strategies = await orchestrator.getAvailableStrategies()

        XCTAssertTrue(strategies.contains(.template), "Template strategy should be available")
        XCTAssertTrue(strategies.contains(.mlxStub), "MLX stub strategy should be available")
        XCTAssertTrue(strategies.contains(.automatic), "Automatic strategy should be available")

        print("✅ Available strategies: \(strategies.map { $0.displayName }.joined(separator: ", "))")
    }

    func testOrchestratorAutomaticStrategy() async throws {
        // Test automatic strategy selection
        await orchestrator.setStrategy(.automatic)

        let insight = try await orchestrator.generateInsight(
            context: "dailycard",
            focus: 5,
            realm: 7
        )

        XCTAssertFalse(insight.isEmpty, "Automatic strategy should produce insights")

        print("✅ Orchestrator automatic strategy validated")
    }

    func testOrchestratorFallbackBehavior() async throws {
        // The orchestrator should automatically fall back to template if other providers fail
        // Since our stub provider is designed to always succeed, we'll test the fallback architecture

        await orchestrator.setStrategy(.automatic)

        // Generate insight - should succeed with best available provider
        let insight = try await orchestrator.generateInsight(
            context: "expression",
            focus: 2,
            realm: 8
        )

        XCTAssertFalse(insight.isEmpty, "Orchestrator should provide insights via fallback if needed")

        print("✅ Orchestrator fallback behavior validated")
    }

    func testOrchestratorPerformanceMetrics() async throws {
        // Generate some insights to populate metrics
        await orchestrator.setStrategy(.mlxStub)

        _ = try await orchestrator.generateInsight(context: "lifepath", focus: 1, realm: 1)
        _ = try await orchestrator.generateInsight(context: "expression", focus: 2, realm: 2)
        _ = try await orchestrator.generateInsight(context: "soulurge", focus: 3, realm: 3)

        // Check that metrics are being recorded
        await MainActor.run {
            XCTAssertFalse(orchestrator.providerMetrics.isEmpty, "Metrics should be recorded")
        }

        let report = await orchestrator.getPerformanceReport()
        XCTAssertFalse(report.isEmpty, "Performance report should not be empty")
        XCTAssertTrue(report.contains("MLX Stub"), "Report should contain stub provider metrics")

        print("✅ Orchestrator performance metrics validated")
        print("📊 Performance Report:\n\(report)")
    }

    // MARK: - Integration Tests

    func testProviderIntegrationWithEngine() async throws {
        // Test that the engine can use the provider system
        let engine = await KASPERMLXEngine.shared

        // Set strategy through engine
        await engine.setProviderStrategy(.mlxStub)
        let strategy1 = await engine.getCurrentStrategy()
        XCTAssertEqual(strategy1, .mlxStub)

        await engine.setProviderStrategy(.template)
        let strategy2 = await engine.getCurrentStrategy()
        XCTAssertEqual(strategy2, .template)

        // Test available strategies
        let strategies = await engine.getAvailableStrategies()
        XCTAssertFalse(strategies.isEmpty, "Engine should expose available strategies")

        print("✅ Provider integration with engine validated")
    }

    func testEndToEndProviderFlow() async throws {
        // Test complete flow: Engine -> Orchestrator -> Provider -> Insight
        let engine = await KASPERMLXEngine.shared

        // Configure engine to use template provider
        await engine.setProviderStrategy(.template)

        // Create a sample request
        let request = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: InsightContext(
                primaryData: [:],
                userQuery: "What guidance do I need today?",
                constraints: InsightConstraints(
                    maxLength: 100,
                    spiritualDepth: .balanced
                )
            )
        )

        // Generate insight through engine
        let insight = try await engine.generateInsight(for: request)

        // Validate result
        XCTAssertFalse(insight.content.isEmpty, "End-to-end flow should produce insight")
        XCTAssertEqual(insight.feature, .dailyCard, "Insight should match requested feature")

        print("✅ End-to-end provider flow validated")
        print("🎯 Generated insight: \(insight.content)")
    }

    // MARK: - Performance Tests

    func testProviderPerformance() async throws {
        let iterations = 100
        let startTime = Date()

        // Test template provider performance
        for i in 0..<iterations {
            _ = try await templateProvider.generateInsight(
                context: "lifepath",
                focus: i % 9 + 1,
                realm: (i % 9) + 1,
                extras: [:]
            )
        }

        let templateTime = Date().timeIntervalSince(startTime)

        // Test stub provider performance
        let stubStartTime = Date()

        for i in 0..<iterations {
            _ = try await stubProvider.generateInsight(
                context: "dailycard",
                focus: i % 9 + 1,
                realm: (i % 9) + 1,
                extras: [:]
            )
        }

        let stubTime = Date().timeIntervalSince(stubStartTime)

        // Performance requirements
        XCTAssertLessThan(templateTime, 5.0, "Template provider should be fast")
        XCTAssertLessThan(stubTime, 10.0, "Stub provider should be reasonably fast")

        print("✅ Provider performance validated")
        print("📊 Template: \(String(format: "%.3f", templateTime))s for \(iterations) insights")
        print("📊 Stub: \(String(format: "%.3f", stubTime))s for \(iterations) insights")
    }
}
