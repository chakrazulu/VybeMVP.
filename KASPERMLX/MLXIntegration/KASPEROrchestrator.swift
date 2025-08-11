//
//  KASPEROrchestrator.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Strategy orchestrator for KASPER inference providers.
//  Manages provider selection, fallback chains, and performance monitoring.
//  Enables seamless switching between AI backends without UI changes.
//
//  FEATURES:
//  - Hot-swappable provider strategies
//  - Automatic fallback on provider failure
//  - Performance tracking across providers
//  - Privacy-aware provider selection
//  - Debug mode for testing different providers
//

import Foundation
import os.log

/// Available inference strategies
public enum KASPERStrategy: String, CaseIterable, Sendable {
    case mlxStub = "MLX Stub"
    case template = "Template Only"
    case mlxLocal = "MLX Local (Future)"
    case gptHybrid = "GPT Hybrid (Future)"
    case automatic = "Automatic"

    public var displayName: String {
        switch self {
        case .mlxStub: return "Enhanced Stub (Current)"
        case .template: return "Basic Templates"
        case .mlxLocal: return "Local MLX Model"
        case .gptHybrid: return "Cloud-Enhanced AI"
        case .automatic: return "Auto-Select Best"
        }
    }

    public var description: String {
        switch self {
        case .mlxStub: return "RuntimeBundle content with randomization"
        case .template: return "Fast, deterministic templates"
        case .mlxLocal: return "On-device ML inference (coming soon)"
        case .gptHybrid: return "Cloud AI with privacy controls (coming soon)"
        case .automatic: return "Automatically selects the best available provider"
        }
    }
}

/// Main orchestrator for KASPER inference
@MainActor
public final class KASPEROrchestrator: ObservableObject {

    // MARK: - Published Properties

    @Published public private(set) var currentStrategy: KASPERStrategy = .automatic
    @Published public private(set) var activeProvider: String = "Unknown"
    @Published public private(set) var isProcessing = false
    @Published public private(set) var lastError: Error?

    // Performance metrics
    @Published public private(set) var providerMetrics: [String: ProviderMetrics] = [:]

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.kasper", category: "Orchestrator")
    private var providers: [KASPERStrategy: KASPERInferenceProvider] = [:]
    private let templateProvider = KASPERTemplateProvider()
    private let stubProvider = KASPERStubProvider()

    // Settings
    private var allowCloudProviders = false
    private var debugMode = false

    // MARK: - Singleton

    public static let shared = KASPEROrchestrator()

    private init() {
        Task {
            await initializeProviders()
        }
    }

    // MARK: - Public Methods

    /// Set the inference strategy
    public func setStrategy(_ strategy: KASPERStrategy) async {
        logger.info("🎯 Setting strategy to: \(strategy.displayName)")
        currentStrategy = strategy

        // Update active provider name
        if let provider = await getProvider(for: strategy) {
            activeProvider = await provider.name
        }
    }

    /// Generate insight using current strategy
    public func generateInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any] = [:]
    ) async throws -> String {

        isProcessing = true
        defer { isProcessing = false }

        let startTime = Date()
        lastError = nil

        do {
            // Get provider for current strategy
            guard let provider = await getProvider(for: currentStrategy) else {
                throw KASPERInferenceError.providerUnavailable
            }

            // Generate insight
            let insight = try await provider.generateInsight(
                context: context,
                focus: focus,
                realm: realm,
                extras: extras
            )

            // Record success metrics
            let duration = Date().timeIntervalSince(startTime)
            await recordMetrics(
                provider: provider.name,
                duration: duration,
                success: true
            )

            activeProvider = await provider.name
            logger.info("✅ Generated insight using \(await provider.name) in \(String(format: "%.3f", duration))s")

            return insight

        } catch {
            // Record failure metrics
            let duration = Date().timeIntervalSince(startTime)
            if let provider = await getProvider(for: currentStrategy) {
                await recordMetrics(
                    provider: provider.name,
                    duration: duration,
                    success: false
                )
            }

            lastError = error
            logger.error("❌ Primary provider failed: \(error.localizedDescription)")

            // Try fallback
            return try await fallbackGeneration(
                context: context,
                focus: focus,
                realm: realm,
                extras: extras
            )
        }
    }

    /// Generate structured insight with metadata
    public func generateStructuredInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any] = [:]
    ) async throws -> StructuredInsight {

        isProcessing = true
        defer { isProcessing = false }

        // Get provider for current strategy
        guard let provider = await getProvider(for: currentStrategy) else {
            throw KASPERInferenceError.providerUnavailable
        }

        return try await provider.generateStructuredInsight(
            context: context,
            focus: focus,
            realm: realm,
            extras: extras
        )
    }

    /// Get available strategies based on current configuration
    public func getAvailableStrategies() async -> [KASPERStrategy] {
        var available: [KASPERStrategy] = [.template, .mlxStub, .automatic]

        // Add future providers when implemented
        // if mlxModelExists { available.append(.mlxLocal) }
        // if allowCloudProviders { available.append(.gptHybrid) }

        return available
    }

    /// Enable debug mode for testing
    public func setDebugMode(_ enabled: Bool) {
        debugMode = enabled
        logger.info("🐛 Debug mode: \(enabled ? "ENABLED" : "DISABLED")")
    }

    /// Set cloud provider permission
    public func setCloudProvidersAllowed(_ allowed: Bool) {
        allowCloudProviders = allowed
        logger.info("☁️ Cloud providers: \(allowed ? "ALLOWED" : "BLOCKED")")
    }

    /// Get performance report
    public func getPerformanceReport() -> String {
        var report = "KASPER Provider Performance Report\n"
        report += "=====================================\n\n"

        for (provider, metrics) in providerMetrics.sorted(by: { $0.key < $1.key }) {
            report += "\(provider):\n"
            report += "  Total Requests: \(metrics.totalRequests)\n"
            report += "  Success Rate: \(String(format: "%.1f%%", metrics.successRate * 100))\n"
            report += "  Avg Response: \(String(format: "%.3fs", metrics.averageResponseTime))\n"
            report += "  Last Used: \(metrics.lastUsed.formatted())\n\n"
        }

        return report
    }

    // MARK: - Private Methods

    private func initializeProviders() async {
        logger.info("🚀 Initializing KASPER providers...")

        // Register available providers
        providers[.template] = templateProvider
        providers[.mlxStub] = stubProvider

        // Future providers will be added here
        // providers[.mlxLocal] = MLXProvider()
        // providers[.gptHybrid] = GPTProvider()

        // Set initial active provider
        if let stub = providers[.mlxStub] {
            activeProvider = await stub.name
        }

        logger.info("✅ Providers initialized: \(providers.keys.map { $0.rawValue }.joined(separator: ", "))")
    }

    private func getProvider(for strategy: KASPERStrategy) async -> KASPERInferenceProvider? {
        switch strategy {
        case .automatic:
            // Auto-select best available provider
            if let stub = providers[.mlxStub], await stub.isAvailable {
                return stub
            }
            return providers[.template]

        case .mlxStub:
            return providers[.mlxStub]

        case .template:
            return providers[.template]

        case .mlxLocal, .gptHybrid:
            // Future providers - fallback to stub for now
            logger.warning("⚠️ \(strategy.displayName) not yet implemented, using stub")
            return providers[.mlxStub]
        }
    }

    private func fallbackGeneration(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String {

        logger.info("🔄 Attempting fallback generation...")

        // Always fallback to template provider
        let fallback = templateProvider

        do {
            let insight = try await fallback.generateInsight(
                context: context,
                focus: focus,
                realm: realm,
                extras: extras
            )

            activeProvider = await fallback.name
            logger.info("✅ Fallback succeeded using \(await fallback.name)")

            return insight
        } catch {
            logger.error("❌ Fallback also failed: \(error.localizedDescription)")
            throw error
        }
    }

    private func recordMetrics(provider: String, duration: TimeInterval, success: Bool) async {
        if providerMetrics[provider] == nil {
            providerMetrics[provider] = ProviderMetrics()
        }

        providerMetrics[provider]?.recordRequest(duration: duration, success: success)
    }
}

// MARK: - Performance Metrics

public struct ProviderMetrics {
    public var totalRequests: Int = 0
    public var successfulRequests: Int = 0
    public var totalResponseTime: TimeInterval = 0
    public var lastUsed: Date = Date()

    public var successRate: Double {
        guard totalRequests > 0 else { return 0 }
        return Double(successfulRequests) / Double(totalRequests)
    }

    public var averageResponseTime: TimeInterval {
        guard totalRequests > 0 else { return 0 }
        return totalResponseTime / Double(totalRequests)
    }

    mutating func recordRequest(duration: TimeInterval, success: Bool) {
        totalRequests += 1
        totalResponseTime += duration
        if success {
            successfulRequests += 1
        }
        lastUsed = Date()
    }
}
