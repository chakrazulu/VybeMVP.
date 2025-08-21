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
    private let numerologyDataProvider = NumerologyDataTemplateProvider()
    private let hybridProvider = KASPERHybridProvider()  // 🔀 NEW: Blends templates + real insights
    private let firebaseProvider = KASPERFirebaseProvider()  // 🔥 NEW: Live Firebase insights
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
            activeProvider = provider.name
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

            activeProvider = provider.name
            logger.info("✅ Generated insight using \(provider.name) in \(String(format: "%.3f", duration))s")

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
        let available: [KASPERStrategy] = [.firebase, .template, .mlxStub, .automatic]

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
        // 🔥 FIREBASE KASPER INTEGRATION (August 19, 2025):
        // Combines 9,900+ Firebase insights with KASPER orchestration
        // Provides authentic spiritual content with planetary aspects integration
        providers[.firebase] = firebaseProvider   // 🔥 PRIMARY: Live Firebase insights with cosmic context
        providers[.template] = hybridProvider     // 🔀 SECONDARY: Blended authentic + template
        providers[.mlxStub] = stubProvider        // Basic fallback

        // Future providers will be added here
        // providers[.mlxLocal] = MLXProvider()
        // providers[.gptHybrid] = GPTProvider()

        // Set initial active provider to Firebase (live insights with cosmic context)
        if let firebase = providers[.firebase] {
            activeProvider = firebase.name  // "FirebaseKASPER" - live spiritual insights
        } else if let hybrid = providers[.template] {
            activeProvider = hybrid.name  // "HybridKASPER" - blended fallback
        } else if let stub = providers[.mlxStub] {
            activeProvider = stub.name
        }

        logger.info("✅ Providers initialized: \(self.providers.keys.map { $0.rawValue }.joined(separator: ", "))")
    }

    private func getProvider(for strategy: KASPERStrategy) async -> KASPERInferenceProvider? {
        switch strategy {
        case .automatic:
            // 🔥 FIREBASE FIRST APPROACH: Live insights with cosmic context
            // Prioritize Firebase provider for 9,900+ A+ quality insights
            if let firebase = providers[.firebase], await firebase.isAvailable {
                return firebase  // KASPERFirebaseProvider - live spiritual insights
            }
            // Fallback to hybrid provider that blends authentic insights with templates
            if let hybrid = providers[.template], await hybrid.isAvailable {
                return hybrid  // KASPERHybridProvider - 70% real insights + 30% enhanced templates
            }
            // Final fallback to stub only if others unavailable
            return providers[.mlxStub]

        case .mlxStub:
            return providers[.mlxStub]

        case .template:
            return providers[.template]

        case .firebase:
            return providers[.firebase]

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

            activeProvider = fallback.name
            logger.info("✅ Fallback succeeded using \(fallback.name)")

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
