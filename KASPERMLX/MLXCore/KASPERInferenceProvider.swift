//
//  KASPERInferenceProvider.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Protocol abstraction for spiritual AI inference providers.
//  Enables hot-swapping between different AI backends (MLX, GPT, Template)
//  without changing UI or business logic.
//
//  ARCHITECTURE:
//  - Protocol defines common interface for all providers
//  - Each provider implements its own inference strategy
//  - Orchestrator manages provider selection and fallback
//  - Zero UI changes when switching providers
//
//  PROVIDERS:
//  - TemplateProvider: Deterministic template-based fallback
//  - StubProvider: Current MLX stub with randomization
//  - MLXProvider: Future on-device MLX model (planned)
//  - GPTProvider: Cloud-enhanced AI (planned)
//

import Foundation

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

/// Common protocol for all KASPER inference providers
public protocol KASPERInferenceProvider: Sendable {

    /// Provider name for debugging and UI display
    var name: String { get }

    /// Provider description for settings UI
    var description: String { get }

    /// Whether this provider is currently available
    var isAvailable: Bool { get async }

    /// Average confidence level for this provider (0.0-1.0)
    var averageConfidence: Double { get }

    /// Generate spiritual insight using this provider's strategy
    /// - Parameters:
    ///   - context: Type of insight (lifePath, expression, soulUrge, etc.)
    ///   - focus: User's focus number (1-9, 11, 22, 33, 44)
    ///   - realm: Current realm number (1-9)
    ///   - extras: Additional context data (moon phase, planetary energy, etc.)
    /// - Returns: Generated spiritual insight text
    /// - Throws: Provider-specific errors
    func generateInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> String

    /// Generate structured insight with metadata
    /// - Parameters:
    ///   - context: Type of insight
    ///   - focus: User's focus number
    ///   - realm: Current realm number
    ///   - extras: Additional context data
    /// - Returns: Structured insight with confidence and metadata
    func generateStructuredInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> StructuredInsight
}

/// Structured insight with metadata
public struct StructuredInsight: Sendable {
    /// The generated insight text
    public let text: String

    /// Confidence level (0.0-1.0)
    public let confidence: Double

    /// Provider that generated this insight
    public let provider: String

    /// Generation timestamp
    public let timestamp: Date

    /// Optional harmonic index for content variation
    public let harmonicIndex: Int?

    /// Optional tensor values used for generation
    public let tensorValues: [String: Double]?

    public init(
        text: String,
        confidence: Double,
        provider: String,
        timestamp: Date = Date(),
        harmonicIndex: Int? = nil,
        tensorValues: [String: Double]? = nil
    ) {
        self.text = text
        self.confidence = confidence
        self.provider = provider
        self.timestamp = timestamp
        self.harmonicIndex = harmonicIndex
        self.tensorValues = tensorValues
    }
}

/// Default implementation for structured insight
public extension KASPERInferenceProvider {
    func generateStructuredInsight(
        context: String,
        focus: Int,
        realm: Int,
        extras: [String: Any]
    ) async throws -> StructuredInsight {
        let text = try await generateInsight(
            context: context,
            focus: focus,
            realm: realm,
            extras: extras
        )

        return StructuredInsight(
            text: text,
            confidence: averageConfidence,
            provider: name,
            timestamp: Date()
        )
    }
}

/// Errors that can occur during inference
public enum KASPERInferenceError: LocalizedError {
    case providerUnavailable
    case modelNotLoaded
    case inferenceTimeout
    case invalidContext(String)
    case networkError(Error)
    case quotaExceeded
    case privacyRestriction

    public var errorDescription: String? {
        switch self {
        case .providerUnavailable:
            return "The selected AI provider is not available"
        case .modelNotLoaded:
            return "The AI model is not loaded"
        case .inferenceTimeout:
            return "Inference took too long and was cancelled"
        case .invalidContext(let context):
            return "Invalid context: \(context)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .quotaExceeded:
            return "API quota exceeded"
        case .privacyRestriction:
            return "Privacy settings prevent cloud AI usage"
        }
    }
}
