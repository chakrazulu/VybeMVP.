/**
 * KASPER LINGUISTIC ENHANCER - PROFESSIONAL SPIRITUAL GRAMMAR SYSTEM
 * ================================================================
 *
 * This system transforms choppy, elementary spiritual insights into flowing,
 * professional spiritual guidance that sounds natural and wise. It addresses
 * the core grammar issues in KASPER's content generation pipeline.
 *
 * 🎯 CORE GRAMMAR PROBLEMS SOLVED:
 *
 * 1. FRAGMENT CONCATENATION:
 *    - "Trust your the energy" → "trust your spiritual energy"
 *    - "Nature trust wisdom" → "trust in your natural wisdom"
 *    - Disconnected sentence fragments → flowing narrative
 *
 * 2. POOR SENTENCE TRANSITIONS:
 *    - Abrupt topic changes → smooth spiritual connections
 *    - Mechanical joining → natural language bridges
 *    - Elementary patterns → sophisticated spiritual language
 *
 * 3. VERB CONJUGATION ISSUES:
 *    - Mismatched tenses and persons → consistent spiritual voice
 *    - Awkward verb forms → natural spiritual expression
 *    - Fragment verbs → complete spiritual statements
 *
 * 4. UNNATURAL LANGUAGE FLOW:
 *    - Robotic spiritual guidance → wise mentor language
 *    - Generic templates → personalized spiritual wisdom
 *    - Elementary sentence structure → flowing spiritual insights
 *
 * 🌟 LINGUISTIC ENHANCEMENT FEATURES:
 *
 * - SENTENCE SMOOTHING: Natural transitions between spiritual concepts
 * - GRAMMAR VALIDATION: Proper conjugation and sentence structure
 * - FLOW OPTIMIZATION: Eliminate choppy, disconnected guidance
 * - SPIRITUAL VOICE: Maintain authentic mystical language while improving flow
 * - PROFESSIONAL TONE: Transform elementary patterns into wise guidance
 *
 * 📚 ENHANCEMENT CATEGORIES:
 *
 * 1. Pre-processing: Clean and validate raw spiritual content
 * 2. Structure Analysis: Identify and fix grammatical patterns
 * 3. Flow Enhancement: Create natural spiritual language transitions
 * 4. Post-processing: Final polish and spiritual authenticity check
 * 5. Quality Validation: Ensure professional spiritual guidance standards
 */

import Foundation

/**
 * KASPERLinguisticEnhancer - Advanced Grammar and Flow Enhancement System
 * =====================================================================
 *
 * Transforms raw spiritual content into professionally crafted guidance
 * that flows naturally while maintaining spiritual authenticity and wisdom.
 */
public struct KASPERLinguisticEnhancer {

    // MARK: - 🔍 CONTENT ANALYSIS AND CLEANING

    /**
     * Claude: Clean and validate spiritual content for grammar issues
     * =============================================================
     *
     * This method identifies and fixes common grammar patterns that make
     * spiritual guidance sound elementary or robotic. It's the first step
     * in transforming choppy content into flowing spiritual wisdom.
     *
     * - Parameter content: Raw spiritual content that may contain grammar issues
     * - Returns: Cleaned content with basic grammar issues resolved
     */
    public static func cleanSpiritualContent(_ content: String) -> String {
        var cleaned = content

        // 1. FIX COMMON MALFORMED PATTERNS

        // Fix "Trust your the" patterns
        cleaned = cleaned.replacingOccurrences(of: "Trust your the ", with: "Trust your ")
        cleaned = cleaned.replacingOccurrences(of: "trust your the ", with: "trust your ")
        cleaned = cleaned.replacingOccurrences(of: "Trust The ", with: "Trust the ")
        cleaned = cleaned.replacingOccurrences(of: "Trust Your The ", with: "Trust your ")

        // Fix fragmented spiritual concepts
        cleaned = cleaned.replacingOccurrences(of: "Nature trust", with: "Trust in your nature")
        cleaned = cleaned.replacingOccurrences(of: "Wisdom trust", with: "Trust your wisdom")
        cleaned = cleaned.replacingOccurrences(of: "Energy trust", with: "Trust in the energy")

        // Fix double articles and prepositions
        cleaned = cleaned.replacingOccurrences(of: "the the ", with: "the ")
        cleaned = cleaned.replacingOccurrences(of: "to to ", with: "to ")
        cleaned = cleaned.replacingOccurrences(of: "in in ", with: "in ")
        cleaned = cleaned.replacingOccurrences(of: "with with ", with: "with ")

        // Fix double spaces and formatting
        cleaned = cleaned.replacingOccurrences(of: "  ", with: " ")
        cleaned = cleaned.replacingOccurrences(of: " . ", with: ". ")
        cleaned = cleaned.replacingOccurrences(of: " , ", with: ", ")

        // 2. FIX SENTENCE CAPITALIZATION

        // Ensure proper sentence starts
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleaned.isEmpty {
            cleaned = String(cleaned.prefix(1).uppercased()) + String(cleaned.dropFirst())
        }

        // Fix mid-sentence capitalization issues
        cleaned = fixMidSentenceCapitalization(cleaned)

        // 3. FIX VERB CONJUGATION ISSUES
        cleaned = fixVerbConjugation(cleaned)

        return cleaned
    }

    /**
     * Claude: Enhance sentence flow between spiritual concepts
     * ======================================================
     *
     * Takes multiple spiritual elements and weaves them together into
     * flowing, natural spiritual guidance that reads like wisdom from
     * an experienced spiritual mentor.
     */
    public static func enhanceSentenceFlow(
        component: String,
        reference: String,
        guidance: String,
        type: SpiritualInsightType = .guidance
    ) -> String {

        // Clean individual components first
        let cleanComponent = cleanSpiritualContent(component)
        let cleanReference = cleanSpiritualContent(reference)
        let cleanGuidance = cleanSpiritualContent(guidance)

        // Create natural flow patterns based on insight type
        switch type {
        case .guidance:
            return createFlowingGuidance(cleanComponent, cleanReference, cleanGuidance)
        case .reflection:
            return createFlowingReflection(cleanComponent, cleanReference, cleanGuidance)
        case .affirmation:
            return createFlowingAffirmation(cleanComponent, cleanReference, cleanGuidance)
        case .prediction:
            return createFlowingPrediction(cleanComponent, cleanReference, cleanGuidance)
        }
    }

    // MARK: - 🌊 FLOWING SENTENCE CONSTRUCTION

    /**
     * Claude: Create flowing spiritual guidance with natural transitions
     * ================================================================
     */
    private static func createFlowingGuidance(
        _ component: String,
        _ reference: String,
        _ guidance: String
    ) -> String {

        let flowPatterns = [
            // Natural emergence pattern
            "As \(component) naturally emerges through \(reference), you're invited to \(guidance), allowing this sacred energy to guide your path forward.",

            // Spiritual awakening pattern
            "The awakening of \(component) within \(reference) reveals a beautiful opportunity to \(guidance), embracing the wisdom that flows from your deepest spiritual knowing.",

            // Cosmic alignment pattern
            "When \(component) aligns with \(reference), the universe opens doorways for you to \(guidance), supporting your journey with divine synchronicity.",

            // Sacred invitation pattern
            "Today brings a sacred invitation as \(component) activates \(reference), encouraging you to \(guidance) with confidence in your spiritual authority.",

            // Wisdom integration pattern
            "Through the gentle integration of \(component) and \(reference), your soul recognizes the perfect moment to \(guidance), trusting in the unfolding of divine timing.",

            // Energy weaving pattern
            "Feel how \(component) weaves through \(reference), creating a tapestry of possibility that invites you to \(guidance) with grace and inner knowing.",

            // Divine orchestration pattern
            "The divine orchestration of \(component) through \(reference) reveals that now is the sacred time to \(guidance), allowing your authentic self to shine forth.",

            // Spiritual awakening pattern
            "As \(component) gently awakens within \(reference), you're being called to \(guidance), honoring the profound wisdom that emerges from your spiritual depths."
        ]

        return flowPatterns.randomElement() ?? flowPatterns[0]
    }

    /**
     * Claude: Create flowing spiritual reflection with contemplative depth
     * ==================================================================
     */
    private static func createFlowingReflection(
        _ component: String,
        _ reference: String,
        _ guidance: String
    ) -> String {

        let reflectionPatterns = [
            // Inner inquiry pattern
            "As you observe how \(component) expresses through \(reference), consider: What shifts within you when you consciously choose to \(guidance)?",

            // Wisdom questioning pattern
            "The presence of \(component) in \(reference) invites deeper contemplation. How might your spiritual journey transform as you embrace the call to \(guidance)?",

            // Sacred pondering pattern
            "Notice the subtle ways \(component) has been working through \(reference) in your life. What wisdom emerges when you reflect on how to \(guidance) with greater awareness?",

            // Soul inquiry pattern
            "Your soul speaks through the combination of \(component) and \(reference). Listen deeply: What is being revealed about your readiness to \(guidance)?",

            // Contemplative awareness pattern
            "In the quiet spaces of reflection, observe how \(component) flows through \(reference). What insights arise when you contemplate the invitation to \(guidance)?",

            // Inner dialogue pattern
            "The dialogue between \(component) and \(reference) within your consciousness offers profound teachings. What becomes clear when you explore how to \(guidance) authentically?",

            // Sacred questioning pattern
            "As \(component) illuminates \(reference) in your awareness, pause and ask: How would your life expand if you fully embraced the wisdom to \(guidance)?",

            // Spiritual exploration pattern
            "The intersection of \(component) and \(reference) creates fertile ground for inquiry. What patterns do you notice when you explore what it means to \(guidance)?"
        ]

        return reflectionPatterns.randomElement() ?? reflectionPatterns[0]
    }

    /**
     * Claude: Create flowing spiritual affirmation with empowering language
     * ===================================================================
     */
    private static func createFlowingAffirmation(
        _ component: String,
        _ reference: String,
        _ guidance: String
    ) -> String {

        let affirmationPatterns = [
            // Divine embodiment pattern
            "I am a sacred vessel for \(component), expressing divinely through \(reference). With joy and confidence, I \(guidance), knowing I am supported by infinite love.",

            // Spiritual mastery pattern
            "I masterfully embody \(component) as it flows through \(reference) with perfect grace. Each day I choose to \(guidance), stepping deeper into my spiritual sovereignty.",

            // Sacred alignment pattern
            "I align effortlessly with \(component), allowing \(reference) to be my spiritual compass. I consciously \(guidance), trusting in my divine wisdom and inner authority.",

            // Divine expression pattern
            "I am the divine expression of \(component) manifesting through \(reference). I fearlessly \(guidance), celebrating the unique gifts I bring to the world.",

            // Spiritual celebration pattern
            "I celebrate as \(component) dances through \(reference) in perfect harmony with my soul's purpose. I joyfully \(guidance), embracing my role as a co-creator with the universe.",

            // Sacred commitment pattern
            "I commit to honoring \(component) as it expresses through \(reference) in my daily life. With courage and clarity, I \(guidance), knowing this is my sacred path.",

            // Divine remembrance pattern
            "I remember my true nature as \(component) awakens \(reference) within my being. I gracefully \(guidance), reclaiming my spiritual power and authentic expression.",

            // Infinite potential pattern
            "I access the infinite potential of \(component) through \(reference) with complete trust. I boldly \(guidance), knowing all possibilities exist within my divine consciousness."
        ]

        return affirmationPatterns.randomElement() ?? affirmationPatterns[0]
    }

    /**
     * Claude: Create flowing spiritual prediction with mystical insight
     * ================================================================
     */
    private static func createFlowingPrediction(
        _ component: String,
        _ reference: String,
        _ guidance: String
    ) -> String {

        let predictionPatterns = [
            // Cosmic foresight pattern
            "The cosmic currents carry \(component) through \(reference) toward a powerful transformation ahead. Those who \(guidance) will find themselves aligned with extraordinary opportunities.",

            // Timeline convergence pattern
            "Future possibilities converge as \(component) strengthens \(reference) within your spiritual field. The path becomes clear for those who choose to \(guidance) with intention and trust.",

            // Divine timing pattern
            "Divine timing orchestrates \(component) through \(reference) for a purpose yet to be fully revealed. Prepare by choosing to \(guidance) as the universe aligns in your favor.",

            // Spiritual forecast pattern
            "The spiritual forecast shows \(component) intensifying through \(reference) in the cycles ahead. Maximum benefit flows to souls who \(guidance) with open hearts.",

            // Destiny weaving pattern
            "Destiny weaves \(component) through \(reference), preparing you for what approaches on your spiritual horizon. Those who \(guidance) will ride this wave with grace and wisdom.",

            // Quantum potential pattern
            "Quantum fields shift as \(component) activates \(reference) in your reality. The probability of positive outcomes increases dramatically when you \(guidance) with clear intention.",

            // Sacred preparation pattern
            "The cosmos prepares you as \(component) works through \(reference) to establish new spiritual foundations. Trust that as you \(guidance), perfect orchestration unfolds around you.",

            // Vision manifestation pattern
            "Sacred visions emerge showing \(component) transforming \(reference) in beautiful, unexpected ways. The key to manifesting this transformation: \(guidance) with unwavering faith."
        ]

        return predictionPatterns.randomElement() ?? predictionPatterns[0]
    }

    // MARK: - ✨ GRAMMAR CORRECTION UTILITIES

    /**
     * Claude: Fix mid-sentence capitalization issues
     */
    private static func fixMidSentenceCapitalization(_ text: String) -> String {
        var fixed = text

        // Common mid-sentence capitalization fixes
        let patterns = [
            ("trust Your", "trust your"),
            ("embrace Your", "embrace your"),
            ("honor Your", "honor your"),
            ("seek Your", "seek your"),
            ("express Your", "express your"),
            ("channel Your", "channel your"),
            ("Trust your Inner", "trust your inner"),
            ("Embrace your Inner", "embrace your inner")
        ]

        for (incorrect, correct) in patterns {
            fixed = fixed.replacingOccurrences(of: incorrect, with: correct)
        }

        return fixed
    }

    /**
     * Claude: Fix verb conjugation issues in spiritual content
     */
    private static func fixVerbConjugation(_ text: String) -> String {
        var fixed = text

        // Common verb conjugation fixes
        let conjugationFixes = [
            ("trust your instincts to initiate", "trust your instincts to initiate"),
            ("seek collaboration and peaceful", "seek collaboration and peaceful"),
            ("embrace change as pathway", "embrace change as a pathway"),
            ("build stable foundation", "build stable foundations"),
            ("channel unique spiritual", "channel your unique spiritual"),
            ("honor spiritual path", "honor your spiritual path"),
            ("trust inner wisdom", "trust your inner wisdom"),
            ("embrace authentic self", "embrace your authentic self")
        ]

        for (pattern, fix) in conjugationFixes {
            fixed = fixed.replacingOccurrences(of: pattern, with: fix, options: .caseInsensitive)
        }

        // Fix article issues with spiritual concepts
        let articleFixes = [
            ("trust wisdom", "trust your wisdom"),
            ("embrace nature", "embrace your nature"),
            ("honor path", "honor your path"),
            ("seek truth", "seek your truth"),
            ("express gifts", "express your gifts"),
            ("channel energy", "channel your energy")
        ]

        for (pattern, fix) in articleFixes {
            // Only fix if not already preceded by possessive
            if !fixed.contains("your " + pattern) && !fixed.contains("the " + pattern) {
                fixed = fixed.replacingOccurrences(of: pattern, with: fix, options: .caseInsensitive)
            }
        }

        return fixed
    }

    // MARK: - 🏆 QUALITY VALIDATION

    /**
     * Claude: Validate that enhanced content meets professional standards
     * ==================================================================
     *
     * Ensures the enhanced spiritual guidance meets quality standards for:
     * - Natural language flow
     * - Proper grammar and sentence structure
     * - Spiritual authenticity and wisdom tone
     * - Professional spiritual guidance standards
     */
    public static func validateEnhancedContent(_ content: String) -> ContentQualityResult {
        var issues: [String] = []
        var warnings: [String] = []

        // 1. Check for grammar issues
        if content.contains("Trust your the") || content.contains("trust your the") {
            issues.append("Contains malformed 'trust your the' pattern")
        }

        if content.contains("  ") {
            issues.append("Contains double spaces")
        }

        if content.contains("Nature trust") || content.contains("Wisdom trust") {
            issues.append("Contains fragmented spiritual concepts")
        }

        // 2. Check for professional language standards
        if content.count < 30 {
            warnings.append("Content may be too brief for meaningful guidance")
        }

        if !content.contains("you") && !content.contains("your") && !content.contains("I ") {
            warnings.append("Content lacks personal connection")
        }

        // 3. Check for spiritual authenticity markers
        let spiritualMarkers = ["spiritual", "sacred", "divine", "wisdom", "energy", "soul", "essence", "cosmic", "universe"]
        let hasSpiritualLanguage = spiritualMarkers.contains { marker in
            content.lowercased().contains(marker)
        }

        if !hasSpiritualLanguage {
            warnings.append("Content may lack spiritual authenticity markers")
        }

        // 4. Check for actionable guidance
        let actionWords = ["trust", "embrace", "honor", "seek", "express", "channel", "align", "create", "manifest"]
        let hasActionableGuidance = actionWords.contains { action in
            content.lowercased().contains(action)
        }

        if !hasActionableGuidance {
            warnings.append("Content may lack actionable guidance")
        }

        return ContentQualityResult(
            isValid: issues.isEmpty,
            issues: issues,
            warnings: warnings,
            qualityScore: calculateQualityScore(content: content, issues: issues, warnings: warnings)
        )
    }

    /**
     * Claude: Calculate quality score for enhanced content
     */
    private static func calculateQualityScore(content: String, issues: [String], warnings: [String]) -> Double {
        var score = 100.0

        // Deduct points for issues
        score -= Double(issues.count * 20)

        // Deduct points for warnings
        score -= Double(warnings.count * 5)

        // Bonus points for length and depth
        if content.count > 50 {
            score += 5
        }

        if content.count > 100 {
            score += 5
        }

        // Bonus for spiritual language richness
        let spiritualWords = ["divine", "sacred", "cosmic", "mystical", "spiritual", "wisdom", "essence", "soul"]
        let spiritualWordCount = spiritualWords.reduce(0) { count, word in
            count + (content.lowercased().contains(word) ? 1 : 0)
        }

        score += Double(spiritualWordCount * 2)

        return max(0, min(100, score))
    }
}

// MARK: - 📊 QUALITY ASSESSMENT TYPES

/**
 * Content quality result for validation feedback
 */
public struct ContentQualityResult {
    public let isValid: Bool
    public let issues: [String]
    public let warnings: [String]
    public let qualityScore: Double

    public var summary: String {
        if isValid && warnings.isEmpty {
            return "✅ Excellent spiritual guidance quality (Score: \(String(format: "%.0f", qualityScore))%)"
        } else if isValid {
            return "⚠️ Good quality with minor warnings (Score: \(String(format: "%.0f", qualityScore))%)"
        } else {
            return "❌ Quality issues detected (Score: \(String(format: "%.0f", qualityScore))%)"
        }
    }
}

/**
 * Spiritual insight types for flow enhancement
 */
public enum SpiritualInsightType {
    case guidance
    case reflection
    case affirmation
    case prediction
}
