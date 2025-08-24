//
//  InsightEngine.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Unified insight generation engine with swappable backends
//  Part of Phase 2B Living Insight Engine
//

import Foundation
import SwiftUI
import os.log

// MARK: - Core Types

/// Method used to generate the insight
public enum InsightMethod: String, Codable {
    case localLLM = "local_llm"        // On-device AI model
    case template = "template"         // Template fusion fallback
    case runtimeOnly = "runtime_only"  // Pure RuntimeBundle selection
    case hybrid = "hybrid"             // Combined approach
    case cloud = "cloud"               // Future: Cloud LLM
}

/// Result of insight generation with metadata
public struct InsightResult: Sendable {
    public let text: String
    public let method: InsightMethod
    public let quality: Double        // 0.0 to 1.0
    public let latency: TimeInterval
    public let metadata: [String: Any]

    public init(text: String, method: InsightMethod, quality: Double, latency: TimeInterval, metadata: [String: Any] = [:]) {
        self.text = text
        self.method = method
        self.quality = quality
        self.latency = latency
        self.metadata = metadata
    }
}

/// Protocol for all insight generation engines
public protocol InsightEngine: Sendable {
    func generate(from context: InsightContext) async throws -> InsightResult
    func warmup() async // Preload models/caches
    func shutdown() async // Release resources
}

// MARK: - Hybrid Insight Engine

/// Main production engine combining all generation methods
@MainActor
public final class HybridInsightEngine: InsightEngine, ObservableObject {

    // MARK: - Properties

    @Published private(set) var isReady = false
    @Published private(set) var lastResult: InsightResult?
    @Published private(set) var generationCount = 0

    private let selector: RuntimeSelector
    private let composer: LocalComposer
    private let evaluator: InsightQualityGateManager
    private let mapper = PromptMapper()
    private let logger = Logger(subsystem: "com.vybe.insights", category: "HybridEngine")

    // Metrics tracking
    private var metrics = GenerationMetrics()

    // MARK: - Initialization

    public init() {
        self.selector = RuntimeSelector.shared
        self.composer = LocalComposer()
        self.evaluator = InsightQualityGateManager.shared
    }

    // MARK: - InsightEngine Protocol

    public func generate(from context: InsightContext) async throws -> InsightResult {
        let startTime = Date()
        generationCount += 1

        logger.info("🎯 Starting insight generation #\(self.generationCount)")

        // Convert context to prompt
        let prompt = mapper.makePrompt(from: context)

        // Step 1: Get sentences from RuntimeBundle (always fast)
        let sentences = await selectSentences(for: prompt)

        // Step 2: Try local LLM if available and loaded
        if composer.isLoaded && FeatureFlags.localLLMEnabled {
            do {
                let (text, compositionTime) = try await composer.compose(
                    persona: prompt.persona,
                    sentences: sentences,
                    maxSentences: prompt.maxSentences
                )

                // Evaluate quality
                let score = await evaluator.evaluateInsight(text, persona: prompt.persona)

                // Accept if quality is good enough
                if score >= 0.70 {
                    let result = InsightResult(
                        text: text,
                        method: .localLLM,
                        quality: score,
                        latency: Date().timeIntervalSince(startTime),
                        metadata: [
                            "compositionTime": compositionTime,
                            "sentenceCount": sentences.count
                        ]
                    )

                    lastResult = result
                    await recordMetrics(result)
                    logger.info("✅ Generated via LocalLLM, quality: \(score)")
                    return result
                } else {
                    logger.warning("LLM quality too low (\(score)), falling back")
                }

            } catch {
                logger.error("LLM composition failed: \(error.localizedDescription)")
            }
        }

        // Step 3: Fall back to template fusion (never fails)
        let fusedText = await generateTemplateFusion(sentences: sentences, persona: prompt.persona)

        let result = InsightResult(
            text: fusedText,
            method: .template,
            quality: 0.75, // Template fusion baseline quality
            latency: Date().timeIntervalSince(startTime),
            metadata: [
                "sentenceCount": sentences.count,
                "fallbackReason": composer.isLoaded ? "quality" : "not_loaded"
            ]
        )

        lastResult = result
        await recordMetrics(result)
        logger.info("✅ Generated via template fusion")

        return result
    }

    public func warmup() async {
        logger.info("🔥 Warming up insight engine")

        // Preload composer model
        await composer.loadIfNeeded()

        // Warm up selector cache
        await selector.warmupCache()

        isReady = true
        logger.info("✅ Insight engine ready")
    }

    public func shutdown() async {
        logger.info("🛑 Shutting down insight engine")

        await composer.unload()
        isReady = false
    }

    // MARK: - Private Methods

    private func selectSentences(for prompt: InsightPrompt) async -> [String] {
        // Use existing RuntimeSelector
        let request = ContentSelectionRequest(
            focusNumber: prompt.focusNumber,
            realmNumber: prompt.realmNumber,
            persona: prompt.persona,
            sentenceCount: 6, // Get more than needed for variety
            diversityWeight: 0.3
        )

        let result = await selector.selectContent(request)
        return result.sentences
    }

    private func generateTemplateFusion(sentences: [String], persona: String) async -> String {
        // Use existing template fusion system
        let fusionManager = InsightFusionManager.shared

        let insight = await fusionManager.generateInsight(
            focus: sentences.first ?? "",
            realm: sentences.last ?? "",
            persona: persona
        )

        return insight.text
    }

    private func recordMetrics(_ result: InsightResult) async {
        metrics.record(result)

        // Log if we're hitting performance targets
        if metrics.averageLatency > 2.0 {
            logger.warning("⚠️ Average latency exceeds 2s target: \(metrics.averageLatency)s")
        }

        // Shadow mode logging for comparison
        if FeatureFlags.shadowModeEnabled {
            await logShadowComparison(result)
        }
    }

    private func logShadowComparison(_ result: InsightResult) async {
        // Compare with template baseline in background
        Task.detached(priority: .background) {
            // Log for analysis without affecting user experience
            await ShadowModeLogger.log(result)
        }
    }
}

// MARK: - Local Composer (Stub for now)

/// Local on-device LLM composer - stub implementation
actor LocalComposer {

    private(set) var isLoaded = false
    private let logger = Logger(subsystem: "com.vybe.llm", category: "LocalComposer")

    func loadIfNeeded() async {
        guard !isLoaded else { return }

        logger.info("Loading local LLM model...")

        // Stub: In production, load MLC-LLM or llama.cpp model here
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulate 0.5s load time

        isLoaded = true
        logger.info("✅ Local LLM loaded")
    }

    func compose(persona: String, sentences: [String], maxSentences: Int) async throws -> (String, TimeInterval) {
        let startTime = Date()

        // Stub implementation - just reorganizes sentences
        // Replace with actual LLM inference when ready

        let trimmed = sentences.prefix(maxSentences)
        let composed = """
        As your \(persona), I sense that \(trimmed.joined(separator: " "))
        Trust in this cosmic alignment as you navigate your path today.
        """

        let elapsed = Date().timeIntervalSince(startTime)

        return (composed, elapsed)
    }

    func unload() async {
        isLoaded = false
        // Release model from memory
    }
}

// MARK: - Metrics Tracking

private struct GenerationMetrics {
    private var latencies: [TimeInterval] = []
    private var qualityScores: [Double] = []
    private var methodCounts: [InsightMethod: Int] = [:]

    var averageLatency: TimeInterval {
        guard !latencies.isEmpty else { return 0 }
        return latencies.reduce(0, +) / Double(latencies.count)
    }

    var averageQuality: Double {
        guard !qualityScores.isEmpty else { return 0 }
        return qualityScores.reduce(0, +) / Double(qualityScores.count)
    }

    mutating func record(_ result: InsightResult) {
        latencies.append(result.latency)
        qualityScores.append(result.quality)
        methodCounts[result.method, default: 0] += 1

        // Keep only last 100 for memory efficiency
        if latencies.count > 100 {
            latencies.removeFirst()
            qualityScores.removeFirst()
        }
    }
}

// MARK: - Feature Flags

struct FeatureFlags {
    @AppStorage("insights_live") static var insightsLive = false
    @AppStorage("local_llm_enabled") static var localLLMEnabled = false
    @AppStorage("shadow_mode_enabled") static var shadowModeEnabled = true
    @AppStorage("cloud_fallback_enabled") static var cloudFallbackEnabled = false
}

// MARK: - Shadow Mode Logger

enum ShadowModeLogger {
    static func log(_ result: InsightResult) async {
        // Log to analytics for A/B comparison
        // This helps determine when to graduate from stub to production

        let event = AnalyticsEvent(
            name: "insight_generated",
            parameters: [
                "method": result.method.rawValue,
                "quality": result.quality,
                "latency": result.latency,
                "text_length": result.text.count
            ]
        )

        // Send to your analytics service
        // await Analytics.log(event)
    }
}

// MARK: - Analytics Event (Placeholder)

struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]
}
