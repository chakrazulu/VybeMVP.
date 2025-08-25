//
//  PromptTemplates.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Structured prompt engineering for Phase 2C on-device LLM
//
//  PROMPT ARCHITECTURE:
//  - System: Strict guardrails and grounding instructions
//  - Facts: Verifiable spiritual data (numbers, planets, etc.)
//  - Style: Persona voice and tone modulation
//  - Safety: Stop sequences and content filtering
//

import Foundation

/// Structured prompt template builder for consistent LLM guidance
/// Implements the three-layer architecture: Facts → Synthesis → Style
public struct PromptTemplate {

    // MARK: - Types

    /// Spiritual facts provided to the model as ground truth
    public struct SpiritualFacts {
        let focusNumber: Int
        let realmNumber: Int
        let lifePathNumber: Int?
        let soulUrgeNumber: Int?
        let currentPlanet: String?
        let moonPhase: String?
        let dominantElement: String?
        let vfiLevel: Int?

        /// Convert facts to structured text for prompt injection
        var factStatement: String {
            var facts: [String] = []

            // Core numerology (always present)
            facts.append("Focus Number: \(focusNumber)")
            facts.append("Realm Number: \(realmNumber)")

            // Optional spiritual data
            if let lifePath = lifePathNumber {
                facts.append("Life Path: \(lifePath)")
            }
            if let soulUrge = soulUrgeNumber {
                facts.append("Soul Urge: \(soulUrge)")
            }
            if let planet = currentPlanet {
                facts.append("Planetary Influence: \(planet)")
            }
            if let moon = moonPhase {
                facts.append("Moon Phase: \(moon)")
            }
            if let element = dominantElement {
                facts.append("Element: \(element)")
            }
            if let vfi = vfiLevel {
                facts.append("Consciousness Level: \(vfi) VHz")
            }

            return facts.joined(separator: "\n")
        }
    }

    /// Style configuration for persona and tone
    public struct StyleGuide {
        let persona: String
        let tone: String
        let maxSentences: Int

        /// Default safe and encouraging style
        public static let `default` = StyleGuide(
            persona: "spiritual guide",
            tone: "warm, encouraging, grounded",
            maxSentences: 2
        )

        /// Convert style to instruction text
        var styleInstruction: String {
            """
            Respond as a \(persona) with a \(tone) voice.
            Limit response to \(maxSentences) sentences maximum.
            Be specific and actionable, not vague or generic.
            """
        }
    }

    /// Curated wisdom snippets from RuntimeBundle
    public struct WisdomContext {
        let primaryInsight: String?
        let supportingTheme: String?
        let planetaryGuidance: String?

        /// Format wisdom as context for synthesis
        var contextStatement: String {
            var context: [String] = []

            if let primary = primaryInsight {
                context.append("Core Wisdom: \(primary)")
            }
            if let theme = supportingTheme {
                context.append("Theme: \(theme)")
            }
            if let planetary = planetaryGuidance {
                context.append("Planetary Guidance: \(planetary)")
            }

            return context.isEmpty ? "" : "\n\n" + context.joined(separator: "\n")
        }
    }

    // MARK: - Properties

    private let facts: SpiritualFacts
    private let style: StyleGuide
    private let wisdom: WisdomContext?
    private let query: String

    // MARK: - Initialization

    public init(
        facts: SpiritualFacts,
        style: StyleGuide = .default,
        wisdom: WisdomContext? = nil,
        query: String
    ) {
        self.facts = facts
        self.style = style
        self.wisdom = wisdom
        self.query = query
    }

    // MARK: - Prompt Building

    /// Build complete prompt with all layers
    public func buildPrompt() -> String {
        """
        ### System Instructions ###
        You are a spiritual insight generator for the Vybe app. Follow these rules strictly:
        1. Use ONLY the provided facts as absolute truth. Never invent numbers or planetary positions.
        2. If information is not provided, offer gentle guidance but mark it as "spiritual guidance" not fact.
        3. Stay grounded in the user's current spiritual state as defined by their numbers.
        4. Never mention technical terms like "algorithm", "AI", or "generated".
        5. Keep responses concise, warm, and actionable.
        6. If you don't know something, gracefully acknowledge the mystery rather than guessing.

        ### Spiritual Facts (Ground Truth) ###
        \(facts.factStatement)

        ### Style Guide ###
        \(style.styleInstruction)
        \(wisdom?.contextStatement ?? "")

        ### User Query ###
        \(query)

        ### Response ###
        """
    }

    /// Build a lightweight prompt for quick completions
    public func buildQuickPrompt() -> String {
        """
        You are a spiritual guide. Facts: \(facts.factStatement)

        Query: \(query)

        Respond in 1-2 sentences with \(style.tone) tone. Use only provided facts.

        Response:
        """
    }

    /// Build shadow mode prompt for A/B testing
    public func buildShadowPrompt() -> String {
        """
        [SHADOW MODE - Not User Facing]

        \(buildPrompt())

        [END SHADOW - Log quality score only]
        """
    }
}

// MARK: - Preset Templates

extension PromptTemplate {

    /// Template for daily spiritual guidance
    public static func dailyGuidance(
        facts: SpiritualFacts,
        wisdom: WisdomContext? = nil
    ) -> PromptTemplate {
        PromptTemplate(
            facts: facts,
            style: StyleGuide(
                persona: "daily spiritual advisor",
                tone: "uplifting, practical, grounded",
                maxSentences: 2
            ),
            wisdom: wisdom,
            query: "Provide spiritual guidance for today based on my current energies."
        )
    }

    /// Template for numerology interpretation
    public static func numerologyInsight(
        facts: SpiritualFacts,
        wisdom: WisdomContext? = nil
    ) -> PromptTemplate {
        PromptTemplate(
            facts: facts,
            style: StyleGuide(
                persona: "numerology expert",
                tone: "wise, analytical, encouraging",
                maxSentences: 2
            ),
            wisdom: wisdom,
            query: "Explain the spiritual significance of my current number combination."
        )
    }

    /// Template for meditation guidance
    public static func meditationFocus(
        facts: SpiritualFacts,
        wisdom: WisdomContext? = nil
    ) -> PromptTemplate {
        PromptTemplate(
            facts: facts,
            style: StyleGuide(
                persona: "meditation guide",
                tone: "calm, centering, gentle",
                maxSentences: 2
            ),
            wisdom: wisdom,
            query: "Suggest a meditation focus aligned with my current spiritual state."
        )
    }

    /// Template for consciousness elevation
    public static func consciousnessBoost(
        facts: SpiritualFacts,
        wisdom: WisdomContext? = nil
    ) -> PromptTemplate {
        PromptTemplate(
            facts: facts,
            style: StyleGuide(
                persona: "consciousness coach",
                tone: "empowering, clear, transformative",
                maxSentences: 2
            ),
            wisdom: wisdom,
            query: "How can I elevate my consciousness level today?"
        )
    }
}

// MARK: - Prompt Validation

extension PromptTemplate {

    /// Validate that prompt doesn't contain harmful content
    public func validateSafety() -> Bool {
        let blockedTerms = [
            "medical", "diagnosis", "cure", "treatment",
            "legal", "financial", "investment",
            "predict", "fortune", "guarantee"
        ]

        let promptText = buildPrompt().lowercased()
        return !blockedTerms.contains { promptText.contains($0) }
    }

    /// Estimate token count for budget planning
    public func estimateTokens() -> Int {
        // Rough estimate: 1 token ≈ 4 characters
        let prompt = buildPrompt()
        return prompt.count / 4
    }

    /// Check if prompt fits within token budget
    public func fitsWithinBudget(maxTokens: Int = 512) -> Bool {
        return estimateTokens() < maxTokens
    }
}

// MARK: - Stop Sequences

extension PromptTemplate {

    /// Standard stop sequences for all prompts
    public static let stopSequences = [
        "\n\n",        // Double newline
        "###",         // Section marker
        "END",         // Explicit end
        "[",           // Prevent JSON/code generation
        "```",         // Prevent code blocks
        "Note:",       // Prevent meta-commentary
        "Remember:"    // Prevent preachy additions
    ]

    /// Get stop sequences for specific persona
    public static func stopSequences(for persona: String) -> [String] {
        var sequences = stopSequences

        // Add persona-specific stops
        switch persona {
        case "meditation guide":
            sequences.append("Om")  // Natural meditation ending
        case "numerology expert":
            sequences.append("Calculate")  // Prevent math exposition
        default:
            break
        }

        return sequences
    }
}

// MARK: - Telemetry Support

extension PromptTemplate {

    /// Generate telemetry metadata for this prompt
    public func telemetryMetadata() -> [String: Any] {
        return [
            "template_type": "structured",
            "has_facts": true,
            "fact_count": Mirror(reflecting: facts).children.compactMap { $0.value }.count,
            "has_wisdom": wisdom != nil,
            "style_persona": style.persona,
            "style_tone": style.tone,
            "estimated_tokens": estimateTokens(),
            "safety_valid": validateSafety()
        ]
    }
}
