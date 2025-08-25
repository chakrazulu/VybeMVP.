//
//  LocalComposerBackend.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Phase 2C on-device LLM backend for insight generation
//
//  PHASE 2C INTEGRATION:
//  - Real LlamaRunner with Metal-accelerated llama.cpp
//  - Structured PromptTemplate system for consistent generation
//  - LLMFeatureFlags for rollout control and A/B testing
//  - Quality gate integration with fallback ladder
//  - Memory pressure handling with graceful degradation
//

import Foundation
import os.log

#if canImport(UIKit)
import UIKit
#endif

/// Local on-device LLM backend with memory pressure handling
@MainActor
public final class LocalComposerBackend: InsightEngineBackend {

    // MARK: - InsightEngineBackend Protocol

    public let id = "local_composer"
    public let priority = 100

    public var isReady: Bool {
        get async {
            // Phase 2C: Check feature flags and device capability
            guard featureFlags.shouldRunInference else {
                return false
            }

            guard featureFlags.isDeviceCapable && !isMemoryConstrained else {
                return false
            }

            return true
        }
    }

    // MARK: - Properties

    /// Phase 2C: Real LlamaRunner for on-device inference
    private let llamaRunner = LlamaRunner.shared

    /// Feature flags for rollout control
    private let featureFlags = LLMFeatureFlags.shared

    /// Runtime content selector
    private let selector: RuntimeSelector

    /// Legacy model store (kept for compatibility)
    private let store: ModelStore

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

        logger.info("🧠 Starting Phase 2C local composition #\(self.generationCount)")

        // Feature flag check for shadow mode
        if featureFlags.isInShadowMode {
            logger.info("🔬 Running in shadow mode - will generate but not surface")
        }

        // Phase 2C Safety Enhancement: Rule-first prefilter (if enabled)
        if featureFlags.safetyPrefilterV2 {
            // Create a synthetic query from the prompt context for safety analysis
            let queryForSafety = "spiritual guidance for \(prompt.persona) on \(prompt.focusArea?.rawValue ?? "general") matters"
            let safetyCategory = SafetyPrefilter.classify(queryForSafety)
            let safetyAnalysis = SafetyPrefilter.analyzeText(queryForSafety)

            // Log safety analysis for telemetry
            if featureFlags.collectTelemetry {
                logger.info("🛡️ Safety analysis: \(safetyAnalysis)")
            }

            // Block and reframe if safety concerns detected
            if safetyCategory.shouldBlock {
            logger.warning("🛡️ Safety prefilter blocked \(safetyCategory.rawValue) content")

            let safeReframe: String
            switch safetyCategory {
            case .medicalAdvice:
                safeReframe = SafetyPrefilter.medicalReframe(userText: queryForSafety)
            case .selfHarm:
                safeReframe = SafetyPrefilter.selfHarmReframe(userText: queryForSafety)
            case .illegal:
                safeReframe = SafetyPrefilter.illegalContentBlock(userText: queryForSafety)
            case .neutral:
                safeReframe = "Unable to provide guidance on this topic."
            }

                let currentGenerationTime = Date().timeIntervalSince(startTime)
                return InsightResult(
                    text: safeReframe,
                    method: .template,
                    quality: 0.82,
                    latency: currentGenerationTime,
                    metadata: [
                        "safety_prefilter": "true",
                        "safety_category": safetyCategory.rawValue,
                        "blocked_keywords": String(describing: safetyAnalysis["matched_medical_keywords"] as? [String] ?? []),
                        "generation_method": "safety_reframe"
                    ]
                )
            }
        }

        // Capability checks
        guard await isReady else {
            logger.warning("⚠️ LocalComposer not ready")
            throw LocalComposerError.notReady
        }

        // Load model on-demand (Phase 2C: lazy loading)
        if !llamaRunner.isModelLoaded && featureFlags.shouldRunInference {
            logger.info("📥 Loading LLM model on-demand")
            let loaded = try await llamaRunner.loadModel()
            guard loaded else {
                logger.error("❌ Failed to load LLM model")
                throw LocalComposerError.generationFailed("Model loading failed")
            }
        }

        // Get curated sentences from RuntimeSelector
        let sentences = await selectSentences(for: prompt)

        // Build wisdom context from selected sentences
        let wisdom = PromptTemplate.WisdomContext(
            primaryInsight: sentences.first,
            supportingTheme: sentences.dropFirst().first,
            planetaryGuidance: sentences.dropFirst(2).first
        )

        // Phase 2C: Real LLM generation with structured prompts
        let (composedText, metadata) = try await composeWithLLM(
            prompt: prompt,
            sentences: sentences,
            wisdom: wisdom
        )

        let generationTime = Date().timeIntervalSince(startTime)

        // Quality evaluation with existing quality gate
        let quality = await evaluateQuality(composedText, sentences: sentences, persona: prompt.persona)

        // Check quality threshold from feature flags
        if quality < Double(featureFlags.qualityThreshold) {
            logger.warning("⚠️ Generation quality \(String(format: "%.2f", quality)) below threshold \(String(format: "%.2f", self.featureFlags.qualityThreshold))")

            // Fallback to template if quality too low
            throw LocalComposerError.qualityThresholdNotMet
        }

        lastGenerationTime = Date()

        // Add Phase 2C telemetry
        var telemetryMetadata = metadata
        if let llmMetrics = llamaRunner.lastMetrics {
            telemetryMetadata["llm_load_ms"] = String(llmMetrics.loadTimeMs)
            telemetryMetadata["llm_gen_ms"] = String(llmMetrics.generationMs)
            telemetryMetadata["llm_tokens_per_sec"] = String(format: "%.1f", llmMetrics.tokensPerSecond)
            telemetryMetadata["llm_memory_mb"] = String(llmMetrics.memoryUsedMB)
            telemetryMetadata["device_class"] = llmMetrics.deviceClass
        }

        telemetryMetadata["feature_flags_stage"] = featureFlags.rolloutStage.rawValue
        telemetryMetadata["runtime"] = featureFlags.runtime.rawValue
        telemetryMetadata["shadow_mode"] = String(featureFlags.isInShadowMode)

        let result = InsightResult.localLLM(
            text: composedText,
            quality: quality,
            latency: generationTime,
            metadata: telemetryMetadata.merging([
                "generation_count": String(generationCount),
                "memory_pressure": String(isMemoryConstrained),
                "phase": "2C"
            ]) { _, new in new }
        )

        if featureFlags.collectTelemetry {
            logger.info("📊 Phase 2C metrics: quality=\(String(format: "%.2f", quality)), latency=\(String(format: "%.3f", generationTime))s")
        }

        return result
    }

    public func warmup() async throws {
        logger.info("🔥 Warming up Phase 2C local composer")

        // Phase 2C: Preload model only if feature flags allow
        if featureFlags.shouldAutoPreload {
            logger.info("📥 Auto-preloading LLM model")
            let loaded = try await llamaRunner.loadModel()
            if !loaded {
                logger.warning("⚠️ Failed to preload model during warmup")
            }
        } else {
            logger.info("🎛 Preload disabled by feature flags")
        }

        // Warm up selector cache for common personas
        let commonPersonas = ["Oracle", "MindfulnessCoach", "Psychologist", "Philosopher", "NumerologyScholar"]
        for persona in commonPersonas {
            _ = await selector.selectSentences(focus: 1, realm: 1, persona: persona)
        }

        logger.info("✅ Phase 2C local composer warmed up")
    }

    public func shutdown() async {
        logger.info("🛑 Shutting down Phase 2C local composer")

        // Phase 2C: Unload LlamaRunner model
        llamaRunner.unloadModel()

        generationCount = 0
        isMemoryConstrained = false

        NotificationCenter.default.removeObserver(self)

        logger.info("✅ Phase 2C local composer shutdown complete")
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

    /// Phase 2C: Real LLM composition with structured prompts
    private func composeWithLLM(
        prompt: InsightPrompt,
        sentences: [String],
        wisdom: PromptTemplate.WisdomContext
    ) async throws -> (String, [String: String]) {

        guard !sentences.isEmpty else {
            throw LocalComposerError.noContentAvailable
        }

        // Build spiritual facts from prompt
        let facts = PromptTemplate.SpiritualFacts(
            focusNumber: prompt.focusNumber,
            realmNumber: prompt.realmNumber,
            lifePathNumber: nil, // TODO: Get from user profile
            soulUrgeNumber: nil,  // TODO: Get from user profile
            currentPlanet: nil,   // TODO: Get from cosmic data
            moonPhase: nil,       // TODO: Get from cosmic data
            dominantElement: nil, // TODO: Get from elements
            vfiLevel: nil         // TODO: Get from VFI calculation
        )

        // Create appropriate style for persona
        let style = PromptTemplate.StyleGuide(
            persona: mapPersonaToStyle(prompt.persona),
            tone: getPersonaTone(prompt.persona),
            maxSentences: prompt.maxSentences
        )

        // Build structured prompt template
        let template = PromptTemplate(
            facts: facts,
            style: style,
            wisdom: wisdom,
            query: getPersonaQuery(prompt.persona)
        )

        // Get LLM configuration from feature flags
        let config = featureFlags.getLLMConfig()

        // Phase 2C: Real LLM inference with 2.0s budget
        let generatedText = await llamaRunner.generate(
            prompt: template.buildPrompt(),
            config: config
        )

        guard let text = generatedText, !text.isEmpty else {
            logger.error("❌ LLM generation returned empty result")
            throw LocalComposerError.generationFailed("Empty generation result")
        }

        // Build telemetry metadata
        let metadata: [String: String] = [
            "source_sentences": String(sentences.count),
            "persona": prompt.persona,
            "llm_implementation": "llamacpp",
            "prompt_tokens": String(template.estimateTokens()),
            "quality_threshold": String(format: "%.2f", featureFlags.qualityThreshold),
            "temperature": String(format: "%.1f", config.temperature),
            "max_tokens": String(config.maxTokens)
        ]

        return (text, metadata)
    }

    // MARK: - Persona Mapping Helpers

    /// Map internal persona names to user-friendly styles
    private func mapPersonaToStyle(_ persona: String) -> String {
        switch persona.lowercased() {
        case "oracle": return "mystical oracle"
        case "coach", "mindfulnesscoach": return "spiritual coach"
        case "psychologist": return "depth psychologist"
        case "philosopher": return "wisdom philosopher"
        case "poet": return "spiritual poet"
        case "numerologyscholar": return "numerology expert"
        default: return "spiritual guide"
        }
    }

    /// Get tone for each persona
    private func getPersonaTone(_ persona: String) -> String {
        switch persona.lowercased() {
        case "oracle": return "mystical, prophetic, cosmic"
        case "coach", "mindfulnesscoach": return "encouraging, practical, supportive"
        case "psychologist": return "insightful, analytical, integrative"
        case "philosopher": return "wise, contemplative, profound"
        case "poet": return "lyrical, inspiring, beautiful"
        case "numerologyscholar": return "knowledgeable, precise, educational"
        default: return "warm, grounded, encouraging"
        }
    }

    /// Generate appropriate query for persona
    private func getPersonaQuery(_ persona: String) -> String {
        switch persona.lowercased() {
        case "oracle":
            return "What spiritual guidance does the universe offer based on these energies?"
        case "coach", "mindfulnesscoach":
            return "How can I use this spiritual insight for practical growth today?"
        case "psychologist":
            return "What psychological patterns and spiritual integration opportunities are present?"
        case "philosopher":
            return "What deeper meaning and wisdom can be drawn from this spiritual state?"
        case "poet":
            return "How can this spiritual energy be expressed through creative inspiration?"
        case "numerologyscholar":
            return "What does the numerological significance reveal about my spiritual path?"
        default:
            return "How can this spiritual insight guide my next steps with clarity?"
        }
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
        // Use standard iOS memory warning notification
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
        #endif
    }

    @objc private func handleMemoryWarning() {
        logger.warning("⚠️ Memory pressure - constraining local generation")
        isMemoryConstrained = true

        Task {
            // Phase 2C: Use LlamaRunner memory pressure handling
            llamaRunner.handleMemoryPressure(level: .warning)
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
