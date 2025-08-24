//
//  InsightEngineBackend.swift
//  VybeMVP
//
//  Backend protocol for hybrid insight generation system
//  Enables pluggable generation methods: LocalLLM, Template, Cloud
//

import Foundation

// Note: InsightResult is defined in InsightEngine.swift to avoid duplication

/// Backend protocol for insight generation
@MainActor
public protocol InsightEngineBackend {
    /// Unique identifier for this backend
    var id: String { get }

    /// Backend priority (higher = tried first)
    var priority: Int { get }

    /// Whether this backend is ready to generate insights
    var isReady: Bool { get async }

    /// Generate insight from the given prompt
    func generate(_ prompt: InsightPrompt) async throws -> InsightResult

    /// Warm up the backend (preload models, cache, etc.)
    func warmup() async throws

    /// Release resources and prepare for shutdown
    func shutdown() async
}

/// Extension for common functionality
public extension InsightEngineBackend {
    /// Default priority ordering
    var priority: Int {
        switch id {
        case "local_composer": return 100    // Try local first
        case "template_fusion": return 50    // Template fallback
        case "cloud_llm": return 25         // Cloud backup
        default: return 10
        }
    }
}

/// Convenience methods for result creation
public extension InsightResult {
    /// Create a template-based result (fallback safety net)
    static func templateFallback(text: String, latency: TimeInterval = 0.01) -> InsightResult {
        return InsightResult(
            text: text,
            method: .template,
            quality: 0.75, // Baseline template quality
            latency: latency,
            metadata: ["fallback": "true"]
        )
    }

    /// Create a local LLM result
    static func localLLM(text: String, quality: Double, latency: TimeInterval, metadata: [String: String] = [:]) -> InsightResult {
        return InsightResult(
            text: text,
            method: .localLLM,
            quality: quality,
            latency: latency,
            metadata: metadata
        )
    }

    /// Human-readable method description for UI
    var methodDescription: String {
        switch method {
        case .localLLM: return "On-device AI"
        case .template: return "Template"
        case .runtimeOnly: return "Runtime Bundle"
        case .cloud: return "Cloud AI"
        case .hybrid: return "Hybrid"
        }
    }

    /// Quality gate checking
    func meetsQualityThreshold(_ threshold: Double = 0.70) -> Bool {
        return quality >= threshold
    }

    /// Performance gate checking
    func meetsLatencyThreshold(_ threshold: TimeInterval = 2.0) -> Bool {
        return latency <= threshold
    }

    /// Combined gate check
    func passesGates(qualityThreshold: Double = 0.70, latencyThreshold: TimeInterval = 2.0) -> Bool {
        return meetsQualityThreshold(qualityThreshold) && meetsLatencyThreshold(latencyThreshold)
    }
}
