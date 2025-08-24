//
//  LocalComposerBackend.swift
//  VybeMVP
//
//  On-device LLM backend for insight generation
//  Stub implementation ready for MLC/llama.cpp integration
//

import Foundation
import os.log

/// Local on-device LLM backend with memory pressure handling
@MainActor
public final class LocalComposerBackend: InsightEngineBackend {

    // MARK: - InsightEngineBackend Protocol

    public let id = "local_composer"
    public let priority = 100

    public var isReady: Bool {
        get async {
            return store.isLocalLLMReady && !isMemoryConstrained
        }
    }

    // MARK: - Properties

    private let store: ModelStore
    private let selector: RuntimeSelector
    private let logger = Logger(subsystem: "com.vybe.llm", category: "LocalComposerBackend")

    // State tracking
    private var isMemoryConstrained = false
    private var generationCount = 0
    private var lastGenerationTime: Date?

    // MARK: - Initialization

    public init(store: ModelStore, selector: RuntimeSelector) {
        self.store = store
        self.selector = selector

        setupMemoryPressureObservers()
    }

    // MARK: - InsightEngineBackend Implementation

    public func generate(_ prompt: InsightPrompt) async throws -> InsightResult {
        let startTime = Date()
        generationCount += 1

        logger.info("🧠 Starting local composition #\(self.generationCount)")

        // Capability checks
        guard await isReady else {
            throw LocalComposerError.notReady
        }

        // Load model if needed
        try await store.loadModelIfNeeded()

        // Get curated sentences from RuntimeSelector
        let sentences = await selectSentences(for: prompt)

        // Generate insight using stub LLM (replace with real implementation)
        let (composedText, metadata) = try await composeInsight(
            persona: prompt.persona,
            sentences: sentences,
            constraints: GenerationConstraints(
                maxSentences: prompt.maxSentences,
                temperature: prompt.temperature,
                maxTokens: LLMFeatureFlags.maxContextTokens
            )
        )

        let generationTime = Date().timeIntervalSince(startTime)

        // Quality evaluation (uses existing evaluator)
        let quality = await evaluateQuality(composedText, sentences: sentences, persona: prompt.persona)

        lastGenerationTime = Date()

        let result = InsightResult.localLLM(
            text: composedText,
            quality: quality,
            latency: generationTime,
            metadata: metadata.merging([
                "generation_count": String(generationCount),
                "device_capability": store.deviceCapability.maxModelSize,
                "memory_pressure": String(isMemoryConstrained)
            ]) { _, new in new }
        )

        logger.info("✅ Local composition complete - quality: \(String(format: "%.2f", quality)), latency: \(String(format: "%.3f", generationTime))s")

        return result
    }

    public func warmup() async throws {
        logger.info("🔥 Warming up local composer")

        // Preload model if enabled
        if store.isLocalLLMReady {
            try await store.loadModelIfNeeded()
        }

        // Warm up selector cache for common personas
        let commonPersonas = ["Oracle", "Coach", "Psychologist", "Philosopher", "Poet"]
        for persona in commonPersonas {
            _ = await selector.selectSentences(focus: 1, realm: 1, persona: persona)
        }

        logger.info("✅ Local composer warmed up")
    }

    public func shutdown() async {
        logger.info("🛑 Shutting down local composer")

        await store.unloadModel()
        generationCount = 0
        isMemoryConstrained = false

        NotificationCenter.default.removeObserver(self)

        logger.info("✅ Local composer shutdown complete")
    }

    // MARK: - Private Methods

    private func selectSentences(for prompt: InsightPrompt) async -> [String] {
        let result = await selector.selectSentences(
            focus: prompt.focusNumber,
            realm: prompt.realmNumber,
            persona: prompt.persona
        )

        // Limit sentences for context management
        return Array(result.sentences.prefix(6))
    }

    private func composeInsight(
        persona: String,
        sentences: [String],
        constraints: GenerationConstraints
    ) async throws -> (String, [String: String]) {

        // STUB IMPLEMENTATION - Replace with real LLM inference

        guard !sentences.isEmpty else {
            throw LocalComposerError.noContentAvailable
        }

        // Simulate generation with persona-appropriate style
        let composed = await generatePersonaStyledInsight(
            persona: persona,
            sentences: sentences,
            maxSentences: constraints.maxSentences
        )

        // Simulate LLM processing time (0.2-0.8 seconds)
        let processingTime = 0.2 + Double.random(in: 0...0.6)
        try await Task.sleep(nanoseconds: UInt64(processingTime * 1_000_000_000))

        let metadata: [String: String] = [
            "source_sentences": String(sentences.count),
            "processing_time": String(processingTime),
            "persona": persona,
            "stub_implementation": "true"
        ]

        return (composed, metadata)
    }

    private func generatePersonaStyledInsight(
        persona: String,
        sentences: [String],
        maxSentences: Int
    ) async -> String {

        let primarySentence = sentences.first ?? "Trust your inner guidance"
        let supportingSentences = Array(sentences.dropFirst().prefix(2))

        // Persona-specific composition patterns
        let composed = switch persona.lowercased() {
        case "oracle":
            await composeOracleStyle(primary: primarySentence, supporting: supportingSentences)
        case "coach":
            await composeCoachStyle(primary: primarySentence, supporting: supportingSentences)
        case "psychologist":
            await composePsychologistStyle(primary: primarySentence, supporting: supportingSentences)
        case "philosopher":
            await composePhilosopherStyle(primary: primarySentence, supporting: supportingSentences)
        case "poet":
            await composePoetStyle(primary: primarySentence, supporting: supportingSentences)
        default:
            await composeGenericStyle(primary: primarySentence, supporting: supportingSentences)
        }

        return composed
    }

    // Persona-specific composition methods
    private func composeOracleStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "The cosmic energies align in your favor" : supporting.joined(separator: ". ")
        return "The universe whispers: \(primary). As the stars align, \(support). Trust this divine guidance on your sacred path."
    }

    private func composeCoachStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "you have the strength to move forward" : supporting.joined(separator: ". ")
        return "I see your potential: \(primary). Building on this foundation, \(support). Take one concrete step toward this vision today."
    }

    private func composePsychologistStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "deeper patterns are emerging" : supporting.joined(separator: ". ")
        return "Your unconscious is processing: \(primary). The deeper truth reveals that \(support). Consider how this insight integrates with your conscious understanding."
    }

    private func composePhilosopherStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "wisdom emerges through contemplation" : supporting.joined(separator: ". ")
        return "Contemplation reveals: \(primary). The deeper understanding shows us that \(support). Allow this wisdom to illuminate your path forward."
    }

    private func composePoetStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "beauty dances through existence" : supporting.joined(separator: ". ")
        return "In the poetry of life: \(primary). Through the rhythm of being, \(support). Let this inspiration flow through your creative expression."
    }

    private func composeGenericStyle(primary: String, supporting: [String]) async -> String {
        let support = supporting.isEmpty ? "trust the process" : supporting.joined(separator: ". ")
        return "\(primary). \(support). Allow this wisdom to guide your next steps with clarity and purpose."
    }

    private func evaluateQuality(_ text: String, sentences: [String], persona: String) async -> Double {
        // Simple quality heuristics (connect to existing InsightQualityGateManager later)
        var score = 0.70 // Base score

        // Length check (ideal 50-120 words)
        let wordCount = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
        if (50...120).contains(wordCount) {
            score += 0.10
        }

        // Content coherence - contains elements from source
        let lowercaseText = text.lowercased()
        let hasSourceContent = sentences.contains { sentence in
            let words = sentence.lowercased().components(separatedBy: .whitespacesAndNewlines)
            return words.contains { word in
                word.count > 4 && lowercaseText.contains(word)
            }
        }
        if hasSourceContent {
            score += 0.10
        }

        // Persona consistency
        let personaWords = getPersonaKeywords(persona)
        let hasPersonaConsistency = personaWords.contains { keyword in
            lowercaseText.contains(keyword.lowercased())
        }
        if hasPersonaConsistency {
            score += 0.10
        }

        return min(1.0, score)
    }

    private func getPersonaKeywords(_ persona: String) -> [String] {
        switch persona.lowercased() {
        case "oracle": return ["cosmic", "divine", "universe", "sacred", "guidance"]
        case "coach": return ["potential", "strength", "step", "vision", "foundation"]
        case "psychologist": return ["unconscious", "pattern", "integrate", "understanding", "process"]
        case "philosopher": return ["wisdom", "contemplation", "truth", "illuminate", "understanding"]
        case "poet": return ["poetry", "beauty", "rhythm", "inspiration", "creative"]
        default: return ["wisdom", "clarity", "guidance", "understanding", "path"]
        }
    }

    private func setupMemoryPressureObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: .memoryPressureWarning,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCriticalMemory),
            name: .memoryPressureCritical,
            object: nil
        )
    }

    @objc private func handleMemoryWarning() {
        logger.warning("⚠️ Memory pressure - constraining local generation")
        isMemoryConstrained = true

        Task {
            await store.unloadModel()
        }
    }

    @objc private func handleCriticalMemory() {
        logger.error("🚨 Critical memory - force constraining local generation")
        isMemoryConstrained = true

        Task {
            await store.forceUnloadModel()
        }
    }
}

// MARK: - Supporting Types

private struct GenerationConstraints {
    let maxSentences: Int
    let temperature: Double
    let maxTokens: Int
}

public enum LocalComposerError: LocalizedError {
    case notReady
    case noContentAvailable
    case generationFailed(String)
    case memoryConstrained
    case qualityThresholdNotMet

    public var errorDescription: String? {
        switch self {
        case .notReady:
            return "Local composer not ready (model unavailable or memory constrained)"
        case .noContentAvailable:
            return "No content available for generation"
        case .generationFailed(let reason):
            return "Generation failed: \(reason)"
        case .memoryConstrained:
            return "Memory constraints prevent local generation"
        case .qualityThresholdNotMet:
            return "Generated content did not meet quality threshold"
        }
    }
}
