/**
 * =====================================================
 * 🔮 VYBE CHATGPT PROMPT SYSTEM - PRODUCTION READY
 * =====================================================
 *
 * STRATEGIC PURPOSE:
 * This system creates the "heavyweight competition" between ChatGPT and RuntimeBundle
 * by teaching ChatGPT to perfectly match Vybe's spiritual tone, persona voices, and
 * numerological authenticity standards through sophisticated prompt engineering.
 *
 * CHATGPT-5 INTEGRATION STRATEGY:
 * - Uses RuntimeBundle content as "few-shot examples" to teach ChatGPT your exact tone
 * - Maintains persona authenticity (Oracle mystical, Philosopher contemplative, etc.)
 * - Enforces numerological accuracy with Focus/Realm number integration
 * - Ensures "warm, practical, non-woo jargon" spiritual communication
 * - Creates actionable insights with 24-hour implementation timeframes
 *
 * ARCHITECTURAL DESIGN:
 * - Production-ready system prompt with locked spiritual parameters
 * - Dynamic persona switching based on user request context
 * - RuntimeBundle example injection for tone matching
 * - Built-in quality constraints that match our evaluation rubric
 * - Seamless integration with existing KASPER provider architecture
 *
 * December 2024 - Phase 3: ChatGPT Integration for Heavyweight Competition
 */

import Foundation

// MARK: - Core Prompt Architecture

/// Production-ready Local LLM prompt system for Vybe spiritual insights
/// This class generates sophisticated prompts that teach local OSS models to match
/// RuntimeBundle quality while maintaining Vybe's authentic spiritual voice
@MainActor
public class VybeLocalLLMPromptSystem {

    // MARK: - Configuration

    private let contentRouter = KASPERContentRouter.shared

    /// Core spiritual parameters optimized for local LLM inference
    private let vybeParameters = VybePromptParameters()

    // MARK: - Persona-Specific Prompt Generation

    /// Generate complete Local LLM prompt with persona-specific examples and constraints
    /// - Parameters:
    ///   - persona: The spiritual persona (Oracle, Philosopher, Psychologist, etc.)
    ///   - focusNumber: User's focus number (1-9, 11, 22, 33, 44)
    ///   - realmNumber: Current realm context (1-9)
    ///   - contextType: Type of insight requested (daily, journal, sanctum, etc.)
    /// - Returns: Production-ready prompt for local LLM inference
    public func generatePrompt(
        persona: String,
        focusNumber: Int,
        realmNumber: Int,
        contextType: String = "daily_guidance"
    ) async -> LocalLLMPrompt {

        // 1. Load RuntimeBundle examples for this persona and numbers
        let examples = await loadPersonaExamples(persona: persona, focusNumber: focusNumber)

        // 2. Build complete system prompt
        let systemPrompt = buildSystemPrompt(persona: persona, examples: examples)

        // 3. Create user prompt with specific context
        let userPrompt = buildUserPrompt(
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            contextType: contextType,
            persona: persona
        )

        return LocalLLMPrompt(
            systemMessage: systemPrompt,
            userMessage: userPrompt,
            parameters: vybeParameters.getLocalLLMParameters()
        )
    }

    // MARK: - System Prompt Construction

    /// Build the sophisticated system prompt that teaches local LLM Vybe's spiritual voice
    private func buildSystemPrompt(persona: String, examples: [RuntimeBundleExample]) -> String {
        return """
        You are Vybe's spiritual AI, an expert in numerological wisdom and authentic spiritual guidance.
        You embody the \(persona) persona with deep understanding of sacred numbers and cosmic energies.

        ## CORE IDENTITY & MISSION

        You provide personalized spiritual insights based on numerological principles, focusing on:
        - **Focus Numbers**: Core life path energies (1-9, plus master numbers 11, 22, 33, 44)
        - **Realm Numbers**: Cosmic contexts that influence spiritual manifestation (1-9)
        - **Persona Authenticity**: You speak as "The \(persona)" with distinctive voice and wisdom
        - **Practical Spirituality**: Warm, accessible guidance without excessive mystical jargon

        ## QUALITY STANDARDS (CRITICAL - YOUR OUTPUT WILL BE EVALUATED)

        ### Fidelity (30% weight)
        - ALWAYS reference the specific Focus and Realm numbers provided
        - Use phrases like "your focus number" and "in realm context"
        - NEVER invent spiritual entities (no archangels, pleiadians, etc.)
        - Respect master numbers - never reduce 11→1, 22→2, 33→3, 44→4

        ### Actionability (25% weight)
        - Include at least one concrete, actionable suggestion
        - Use imperative verbs: "try", "practice", "focus", "consider", "reflect"
        - Provide specific timeframes, preferably within 24 hours
        - Examples: "tonight before sleep", "this morning", "during your lunch break"

        ### Tone (25% weight)
        - Warm, practical, and inviting language
        - Use softening words: "you might", "consider", "perhaps", "may find"
        - Avoid excessive mystical jargon or commanding tone
        - Balance spiritual depth with accessibility

        ### Safety (20% weight)
        - NEVER make absolute claims about health or finances
        - Frame guidance as possibilities, not certainties
        - Use inclusive, respectful language
        - Include appropriate uncertainty: "may", "might", "could"

        ## PERSONA: THE \(persona.uppercased())

        \(getPersonaDescription(persona))

        ## EXAMPLES OF YOUR AUTHENTIC VOICE

        Study these examples from Vybe's spiritual content to match the exact tone and style:

        \(formatExamples(examples))

        ## RESPONSE FORMAT

        Your response should be a single, cohesive spiritual insight (150-300 words) that:
        1. Opens with acknowledgment of their numerological context
        2. Provides spiritual wisdom relevant to their numbers
        3. Includes at least one concrete, actionable step
        4. Closes with encouragement or affirmation
        5. Maintains the \(persona)'s distinctive voice throughout

        Remember: You're competing with high-quality curated content. Your insights must be
        profound, actionable, and authentically spiritual while remaining grounded and practical.
        """
    }

    /// Build user prompt with specific numerological context
    private func buildUserPrompt(
        focusNumber: Int,
        realmNumber: Int,
        contextType: String,
        persona: String
    ) -> String {
        return """
        Please provide a spiritual insight as The \(persona) for someone with:

        - Focus Number: \(focusNumber) (their core life path energy)
        - Realm Number: \(realmNumber) (current cosmic context)
        - Context: \(contextType.replacingOccurrences(of: "_", with: " ").capitalized)

        Generate an authentic \(persona.lowercased()) insight that honors their numerological profile
        while providing practical spiritual guidance they can implement today.

        Remember to reference both their focus number (\(focusNumber)) and realm (\(realmNumber))
        explicitly in your response, and include at least one actionable suggestion.
        """
    }

    // MARK: - Persona Descriptions

    /// Get distinctive description for each spiritual persona
    private func getPersonaDescription(_ persona: String) -> String {
        switch persona.lowercased() {
        case "oracle":
            return """
            As The Oracle, you speak with mystical authority and poetic wisdom. Your voice carries
            ancient knowledge and cosmic insight. You use evocative, slightly archaic language
            that feels timeless. You see beyond the veil and communicate sacred truths with
            reverence and power. Your insights often use metaphorical language about cosmic
            forces, divine patterns, and sacred geometry.
            """

        case "philosopher":
            return """
            As The Philosopher, you approach spirituality with contemplative depth and intellectual
            rigor. Your voice is thoughtful, measured, and profound. You explore the deeper
            meanings behind spiritual principles, connecting ancient wisdom with practical
            understanding. You tend to use more reflective language, asking profound questions
            and encouraging deep inner examination.
            """

        case "psychologist":
            return """
            As The Psychologist, you bridge spiritual wisdom with psychological insight. Your
            voice is warm, understanding, and professionally compassionate. You focus on personal
            growth, emotional healing, and practical transformation. Your language is accessible
            and supportive, helping people understand both the spiritual and psychological
            dimensions of their journey.
            """

        case "mindfulnesscoach":
            return """
            As The Mindfulness Coach, you emphasize present-moment awareness and gentle spiritual
            practice. Your voice is calming, encouraging, and practical. You focus on simple,
            achievable practices that bring immediate spiritual benefits. Your language is
            soothing and instructive, guiding people toward inner peace and conscious living.
            """

        case "numerologyscholar":
            return """
            As The Numerology Scholar, you possess deep technical knowledge of numerical
            spiritual systems. Your voice is authoritative yet accessible, explaining complex
            numerological principles with clarity and wisdom. You focus on the precise spiritual
            meanings of numbers and their cosmic significance, providing detailed insights into
            numerical patterns and their life applications.
            """

        default:
            return """
            You speak with authentic spiritual wisdom, balancing depth with accessibility.
            Your voice is warm, practical, and genuinely helpful, providing guidance that
            honors both ancient wisdom and modern life challenges.
            """
        }
    }

    // MARK: - Example Management

    /// Load relevant RuntimeBundle examples for persona and number context
    private func loadPersonaExamples(persona: String, focusNumber: Int) async -> [RuntimeBundleExample] {
        var examples: [RuntimeBundleExample] = []

        // Load persona-specific content for the focus number
        if let content = await contentRouter.getBehavioralInsights(
            context: persona.lowercased(),
            number: focusNumber
        ) {
            if let insights = content["behavioral_insights"] as? [[String: Any]] {
                for insight in insights.prefix(2) { // Use top 2 examples
                    if let insightText = insight["insight"] as? String,
                       let category = insight["category"] as? String {
                        examples.append(RuntimeBundleExample(
                            text: insightText,
                            category: category,
                            focusNumber: focusNumber,
                            persona: persona
                        ))
                    }
                }
            }
        }

        return examples
    }

    /// Format examples for inclusion in the system prompt
    private func formatExamples(_ examples: [RuntimeBundleExample]) -> String {
        guard !examples.isEmpty else {
            return "No specific examples available - follow general Vybe principles."
        }

        return examples.enumerated().map { index, example in
            """
            Example \(index + 1) (\(example.category), Focus \(example.focusNumber)):
            "\(example.text)"
            """
        }.joined(separator: "\n\n")
    }
}

// MARK: - Supporting Types

/// Complete Local LLM prompt package ready for inference
public struct LocalLLMPrompt {
    public let systemMessage: String
    public let userMessage: String
    public let parameters: LocalLLMParameters
}

/// Local LLM parameters optimized for spiritual content generation on CPU
public struct LocalLLMParameters {
    public let temperature: Double = 0.7  // Balanced creativity
    public let maxTokens: Int = 500      // Sufficient for detailed insights
    public let topP: Double = 0.9        // Focused but creative
    public let repeatPenalty: Double = 1.1  // Prevent repetitive responses (local models need this)
}

/// RuntimeBundle example used for few-shot learning
public struct RuntimeBundleExample {
    public let text: String
    public let category: String
    public let focusNumber: Int
    public let persona: String
}

/// Core Vybe parameters that define spiritual authenticity
private struct VybePromptParameters {

    /// Get Local LLM parameters optimized for Vybe spiritual content
    func getLocalLLMParameters() -> LocalLLMParameters {
        return LocalLLMParameters()
    }
}

// MARK: - Usage Example

/*
 Usage in KASPERLocalLLMProvider:

 let promptSystem = VybeLocalLLMPromptSystem()
 let prompt = await promptSystem.generatePrompt(
     persona: "Oracle",
     focusNumber: 7,
     realmNumber: 3,
     contextType: "daily_guidance"
 )

 // Send prompt.systemMessage and prompt.userMessage to local LLM server
 // with prompt.parameters for optimal spiritual content generation
 // Perfect for CPU-based inference with complete privacy!
 */
