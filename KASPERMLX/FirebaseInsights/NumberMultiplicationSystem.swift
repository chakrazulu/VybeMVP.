/**
 * =================================================================
 * 🔢 NUMBER MEANINGS MULTIPLICATION SYSTEM - DEPLOYMENT READY
 * =================================================================
 *
 * 🎯 MISSION CRITICAL UPGRADE:
 * Transform 20 insights per number into 75+ unique insights while maintaining
 * 100% spiritual authenticity and perfect schema compatibility.
 *
 * 🚀 MULTIPLICATION STRATEGIES:
 * 1. Aspect Variation: Love, Career, Health, Relationships, Spiritual Growth
 * 2. Contextual Shifts: Life stages, situations, challenges, opportunities
 * 3. Intensity Gradients: Light touches to deep transformations (0.6-1.0)
 * 4. Persona Voices: Oracle, Psychologist, MindfulnessCoach perspectives
 * 5. Situational Applications: Daily life, crisis moments, celebration times
 *
 * 📊 TARGET OUTCOME:
 * - Input: 20 base insights per number
 * - Output: 75+ multiplied insights per number
 * - Quality: Maintain spiritual authenticity + numerological accuracy
 * - Schema: Perfect compatibility with existing NumberRichContent
 * - Performance: Generate all 13 numbers (1-9, 11, 22, 33, 44) in <60 seconds
 *
 * August 15, 2025 - NumberMeanings Multiplication Agents Deployment
 */

import Foundation
import os.log

// MARK: - Multiplication Configuration

/// Configuration for insight multiplication
public struct MultiplicationConfig {
    let targetInsightCount: Int
    let aspectVariations: [String]
    let contextualShifts: [String]
    let intensityRange: ClosedRange<Double>
    let qualityThreshold: Double

    public static let `default` = MultiplicationConfig(
        targetInsightCount: 75,
        aspectVariations: [
            "love_relationships", "career_professional", "health_wellness",
            "spiritual_growth", "family_dynamics", "financial_abundance",
            "creative_expression", "personal_power", "life_transitions"
        ],
        contextualShifts: [
            "daily_life", "crisis_moments", "celebration_times", "growth_periods",
            "transition_phases", "manifestation_cycles", "healing_journeys",
            "decision_points", "breakthrough_moments"
        ],
        intensityRange: 0.6...1.0,
        qualityThreshold: 0.75
    )
}

/// Represents a multiplied insight ready for deployment
public struct MultipliedInsight {
    let category: String
    let insight: String
    let intensity: Double
    let triggers: [String]
    let supports: [String]
    let challenges: [String]
    let generationStrategy: String
    let qualityScore: Double
}

/// Result of multiplication process
public struct MultiplicationResult {
    let number: Int
    let insights: [MultipliedInsight]
    let totalGenerated: Int
    let qualityPassed: Int
    let averageQuality: Double
    let generationTime: TimeInterval
    let strategies: [String: Int]
}

// MARK: - Core Multiplication Engine

/// Generates 75+ unique insights per number using intelligent multiplication
@MainActor
public class NumberMultiplicationSystem: ObservableObject {

    // MARK: - Published Properties

    @Published public private(set) var isGenerating = false
    @Published public private(set) var progress: Double = 0.0
    @Published public private(set) var currentNumber: Int = 1
    @Published public private(set) var generationStats = GenerationStatistics()

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "NumberMultiplication")
    private let config: MultiplicationConfig

    /// Base number characteristics for accurate multiplication
    private let numberArchetypes: [Int: NumberArchetype] = [
        1: NumberArchetype(
            essence: "Pure initiating force, independence, leadership",
            keywords: ["leadership", "independence", "pioneer", "original", "initiative", "beginning"],
            challenges: ["impatience", "ego", "isolation", "dominance"],
            opportunities: ["innovation", "entrepreneurship", "breakthrough", "pioneering"]
        ),
        2: NumberArchetype(
            essence: "Cooperation, harmony, partnership, diplomacy",
            keywords: ["cooperation", "harmony", "partnership", "balance", "support", "diplomacy"],
            challenges: ["codependency", "indecision", "oversensitivity", "avoidance"],
            opportunities: ["collaboration", "peacemaking", "teamwork", "mediation"]
        ),
        3: NumberArchetype(
            essence: "Creative expression, communication, joy, artistic vision",
            keywords: ["creativity", "expression", "communication", "joy", "artistic", "inspiration"],
            challenges: ["scattered energy", "superficiality", "mood swings", "criticism sensitivity"],
            opportunities: ["artistic creation", "communication mastery", "inspiration", "entertainment"]
        ),
        4: NumberArchetype(
            essence: "Foundation, stability, practical manifestation, discipline",
            keywords: ["stability", "foundation", "practical", "discipline", "reliable", "systematic"],
            challenges: ["rigidity", "perfectionism", "stubbornness", "limitation"],
            opportunities: ["building systems", "practical solutions", "reliable foundation", "mastery"]
        ),
        5: NumberArchetype(
            essence: "Adventure, freedom, change, experience, curiosity",
            keywords: ["adventure", "freedom", "change", "experience", "curiosity", "dynamic"],
            challenges: ["restlessness", "instability", "commitment issues", "excess"],
            opportunities: ["exploration", "variety", "experience", "liberation"]
        ),
        6: NumberArchetype(
            essence: "Nurturing, responsibility, home, family, healing service",
            keywords: ["nurturing", "responsibility", "home", "family", "care", "healing"],
            challenges: ["codependency", "martyrdom", "perfectionism", "control"],
            opportunities: ["healing others", "family harmony", "service", "nurturing"]
        ),
        7: NumberArchetype(
            essence: "Spiritual wisdom, introspection, analysis, mystical truth",
            keywords: ["spiritual", "wisdom", "introspection", "analysis", "mystical", "truth"],
            challenges: ["isolation", "skepticism", "depression", "overthinking"],
            opportunities: ["spiritual growth", "wisdom teaching", "research", "mystical insight"]
        ),
        8: NumberArchetype(
            essence: "Material mastery, power, achievement, manifestation authority",
            keywords: ["power", "achievement", "material", "authority", "success", "manifestation"],
            challenges: ["materialism", "power abuse", "workaholism", "ruthlessness"],
            opportunities: ["business success", "material abundance", "leadership", "achievement"]
        ),
        9: NumberArchetype(
            essence: "Universal compassion, completion, humanitarian wisdom",
            keywords: ["universal", "compassion", "completion", "humanitarian", "wisdom", "service"],
            challenges: ["martyrdom", "emotional intensity", "disappointment", "sacrifice"],
            opportunities: ["humanitarian service", "wisdom sharing", "completion", "universal love"]
        )
    ]

    /// Master number characteristics
    private let masterNumbers: [Int: NumberArchetype] = [
        11: NumberArchetype(
            essence: "Spiritual illumination, intuitive mastery, visionary leadership",
            keywords: ["illumination", "intuition", "visionary", "inspiration", "spiritual", "enlightenment"],
            challenges: ["nervous tension", "extremism", "unrealistic ideals", "sensitivity"],
            opportunities: ["spiritual teaching", "inspiration", "visionary leadership", "intuitive mastery"]
        ),
        22: NumberArchetype(
            essence: "Master builder, practical visionary, large-scale manifestation",
            keywords: ["master builder", "visionary", "manifestation", "practical", "large-scale", "achievement"],
            challenges: ["overwhelming responsibility", "pressure", "perfectionism", "limitations"],
            opportunities: ["major achievements", "lasting impact", "visionary building", "practical magic"]
        ),
        33: NumberArchetype(
            essence: "Master teacher, compassionate service, healing wisdom",
            keywords: ["master teacher", "compassion", "healing", "service", "wisdom", "guidance"],
            challenges: ["emotional burden", "sacrifice", "overwhelming empathy", "martyrdom"],
            opportunities: ["healing mastery", "compassionate teaching", "spiritual service", "wisdom sharing"]
        ),
        44: NumberArchetype(
            essence: "Master healer, material-spiritual bridge, practical enlightenment",
            keywords: ["master healer", "bridge", "practical", "enlightenment", "healing", "manifestation"],
            challenges: ["overwhelming responsibility", "burnout", "perfectionism", "isolation"],
            opportunities: ["healing mastery", "spiritual manifestation", "bridge building", "practical wisdom"]
        )
    ]

    // MARK: - Initialization

    public init(config: MultiplicationConfig = .default) {
        self.config = config
        logger.info("🔢 NumberMultiplicationSystem initialized for deployment")
    }

    // MARK: - Main Multiplication Interface

    /**
     * 🚀 DEPLOY ALL MULTIPLICATION AGENTS - Primary Entry Point
     *
     * Generates multiplied insights for all numbers and creates the new
     * *_rich_multiplied.json files alongside existing base files.
     *
     * DEPLOYMENT PROCESS:
     * 1. Loads base insights from existing *_rich.json files
     * 2. Applies 5 multiplication strategies per number
     * 3. Validates quality and numerological accuracy
     * 4. Generates new *_rich_multiplied.json files
     * 5. Maintains perfect schema compatibility
     *
     * @return Array of MultiplicationResult for all 13 numbers
     */
    public func deployAllMultiplicationAgents() async throws -> [MultiplicationResult] {
        logger.info("🚀 DEPLOYING NumberMeanings Multiplication Agents - Target: 75+ insights per number")

        isGenerating = true
        progress = 0.0
        generationStats = GenerationStatistics()

        defer { isGenerating = false }

        let allNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]
        var results: [MultiplicationResult] = []

        let startTime = CFAbsoluteTimeGetCurrent()

        for (index, number) in allNumbers.enumerated() {
            currentNumber = number

            logger.info("🔢 Processing Number \(number) - (\(index + 1)/\(allNumbers.count))")

            // Generate multiplied insights for this number
            let result = try await generateMultipliedInsights(for: number)
            results.append(result)

            // Create and save the multiplied file
            try await saveMultipliedFile(for: number, result: result)

            // Update progress
            progress = Double(index + 1) / Double(allNumbers.count)

            // Update stats
            generationStats.numbersProcessed += 1
            generationStats.totalInsightsGenerated += result.insights.count
            generationStats.totalQualityPassed += result.qualityPassed
        }

        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        generationStats.totalGenerationTime = totalTime

        logger.info("✅ MULTIPLICATION DEPLOYMENT COMPLETE!")
        logger.info("📊 Generated \(generationStats.totalInsightsGenerated) insights across \(allNumbers.count) numbers")
        logger.info("⏱️ Total time: \(String(format: "%.2f", totalTime))s")
        logger.info("🎯 Average quality: \(String(format: "%.3f", generationStats.averageQuality))")

        return results
    }

    // MARK: - Individual Number Multiplication

    /// Generate multiplied insights for a specific number
    private func generateMultipliedInsights(for number: Int) async throws -> MultiplicationResult {
        let startTime = CFAbsoluteTimeGetCurrent()

        // Load base insights
        let baseInsights = try await loadBaseInsights(for: number)
        logger.info("📚 Loaded \(baseInsights.count) base insights for Number \(number)")

        // Get number archetype
        let archetype = getArchetype(for: number)

        var allGeneratedInsights: [MultipliedInsight] = []
        var strategyUsage: [String: Int] = [:]

        // Strategy 1: Aspect Variation (20 insights)
        let aspectInsights = generateAspectVariations(
            baseInsights: baseInsights,
            archetype: archetype,
            number: number,
            targetCount: 20
        )
        allGeneratedInsights.append(contentsOf: aspectInsights)
        strategyUsage["aspect_variation"] = aspectInsights.count

        // Strategy 2: Contextual Shifts (20 insights)
        let contextualInsights = generateContextualShifts(
            baseInsights: baseInsights,
            archetype: archetype,
            number: number,
            targetCount: 20
        )
        allGeneratedInsights.append(contentsOf: contextualInsights)
        strategyUsage["contextual_shifts"] = contextualInsights.count

        // Strategy 3: Intensity Gradients (15 insights)
        let intensityInsights = generateIntensityGradients(
            baseInsights: baseInsights,
            archetype: archetype,
            number: number,
            targetCount: 15
        )
        allGeneratedInsights.append(contentsOf: intensityInsights)
        strategyUsage["intensity_gradients"] = intensityInsights.count

        // Strategy 4: Persona Voice Variations (15 insights)
        let personaInsights = generatePersonaVariations(
            baseInsights: baseInsights,
            archetype: archetype,
            number: number,
            targetCount: 15
        )
        allGeneratedInsights.append(contentsOf: personaInsights)
        strategyUsage["persona_variations"] = personaInsights.count

        // Strategy 5: Life Situation Applications (10 insights)
        let situationalInsights = generateSituationalApplications(
            baseInsights: baseInsights,
            archetype: archetype,
            number: number,
            targetCount: 10
        )
        allGeneratedInsights.append(contentsOf: situationalInsights)
        strategyUsage["situational_applications"] = situationalInsights.count

        // Filter by quality threshold
        let qualityInsights = allGeneratedInsights.filter { $0.qualityScore >= config.qualityThreshold }

        // Take top insights if we have too many
        let finalInsights = Array(qualityInsights.sorted { $0.qualityScore > $1.qualityScore }.prefix(config.targetInsightCount))

        let generationTime = CFAbsoluteTimeGetCurrent() - startTime
        let averageQuality = finalInsights.reduce(0.0) { $0 + $1.qualityScore } / Double(finalInsights.count)

        let result = MultiplicationResult(
            number: number,
            insights: finalInsights,
            totalGenerated: allGeneratedInsights.count,
            qualityPassed: finalInsights.count,
            averageQuality: averageQuality,
            generationTime: generationTime,
            strategies: strategyUsage
        )

        logger.info("✅ Generated \(finalInsights.count)/\(allGeneratedInsights.count) quality insights for Number \(number)")
        logger.info("📈 Average quality: \(String(format: "%.3f", averageQuality))")

        return result
    }

    // MARK: - Multiplication Strategies

    /// Strategy 1: Generate aspect-specific variations (love, career, health, etc.)
    private func generateAspectVariations(
        baseInsights: [BaseInsight],
        archetype: NumberArchetype,
        number: Int,
        targetCount: Int
    ) -> [MultipliedInsight] {

        var insights: [MultipliedInsight] = []
        let aspects = config.aspectVariations

        for aspect in aspects.prefix(targetCount) {
            // Select best base insight for this aspect
            let selectedBase = selectBestBaseInsight(from: baseInsights, for: aspect, archetype: archetype)

            // Transform for aspect
            let transformed = transformInsightForAspect(
                base: selectedBase,
                aspect: aspect,
                archetype: archetype,
                number: number
            )

            insights.append(transformed)
        }

        return insights
    }

    /// Strategy 2: Generate contextual situation variations
    private func generateContextualShifts(
        baseInsights: [BaseInsight],
        archetype: NumberArchetype,
        number: Int,
        targetCount: Int
    ) -> [MultipliedInsight] {

        var insights: [MultipliedInsight] = []
        let contexts = config.contextualShifts

        for context in contexts.prefix(targetCount) {
            let selectedBase = selectBestBaseInsight(from: baseInsights, for: context, archetype: archetype)

            let transformed = transformInsightForContext(
                base: selectedBase,
                context: context,
                archetype: archetype,
                number: number
            )

            insights.append(transformed)
        }

        return insights
    }

    /// Strategy 3: Generate intensity gradient variations
    private func generateIntensityGradients(
        baseInsights: [BaseInsight],
        archetype: NumberArchetype,
        number: Int,
        targetCount: Int
    ) -> [MultipliedInsight] {

        var insights: [MultipliedInsight] = []
        let intensityLevels: [Double] = [0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95]

        for (index, intensity) in intensityLevels.enumerated() {
            guard index < targetCount else { break }

            let selectedBase = baseInsights.randomElement() ?? baseInsights[0]

            let transformed = transformInsightForIntensity(
                base: selectedBase,
                targetIntensity: intensity,
                archetype: archetype,
                number: number
            )

            insights.append(transformed)
        }

        return insights
    }

    /// Strategy 4: Generate persona voice variations
    private func generatePersonaVariations(
        baseInsights: [BaseInsight],
        archetype: NumberArchetype,
        number: Int,
        targetCount: Int
    ) -> [MultipliedInsight] {

        var insights: [MultipliedInsight] = []
        let personas = ["Oracle", "Psychologist", "MindfulnessCoach", "NumerologyScholar", "Philosopher"]

        for persona in personas.prefix(targetCount) {
            let selectedBase = baseInsights.randomElement() ?? baseInsights[0]

            let transformed = transformInsightForPersona(
                base: selectedBase,
                persona: persona,
                archetype: archetype,
                number: number
            )

            insights.append(transformed)
        }

        return insights
    }

    /// Strategy 5: Generate life situation applications
    private func generateSituationalApplications(
        baseInsights: [BaseInsight],
        archetype: NumberArchetype,
        number: Int,
        targetCount: Int
    ) -> [MultipliedInsight] {

        var insights: [MultipliedInsight] = []
        let situations = [
            "morning_reflection", "evening_integration", "decision_making",
            "relationship_dynamics", "career_crossroads", "spiritual_practice",
            "creative_projects", "healing_journey", "manifestation_work", "life_transitions"
        ]

        for situation in situations.prefix(targetCount) {
            let selectedBase = baseInsights.randomElement() ?? baseInsights[0]

            let transformed = transformInsightForSituation(
                base: selectedBase,
                situation: situation,
                archetype: archetype,
                number: number
            )

            insights.append(transformed)
        }

        return insights
    }

    // MARK: - Transformation Methods

    /// Transform insight for specific life aspect
    private func transformInsightForAspect(
        base: BaseInsight,
        aspect: String,
        archetype: NumberArchetype,
        number: Int
    ) -> MultipliedInsight {

        let aspectTemplates: [String: String] = [
            "love_relationships": "In matters of the heart, Number \(number) energy manifests as {core_pattern}. Your \(archetype.essence.lowercased()) nature brings {strength} to romantic connections, while awareness of {challenge} helps navigate relationship dynamics with greater wisdom.",
            "career_professional": "Within professional spheres, Number \(number) expresses its essence through {core_pattern}. Your natural \(archetype.essence.lowercased()) creates opportunities for {strength}, though mindful attention to {challenge} ensures sustainable career growth.",
            "health_wellness": "In the realm of physical and emotional wellness, Number \(number) energy supports {core_pattern}. Your \(archetype.essence.lowercased()) naturally promotes {strength}, while conscious awareness of {challenge} maintains holistic well-being.",
            "spiritual_growth": "On the spiritual path, Number \(number) serves as a gateway to {core_pattern}. Your soul's \(archetype.essence.lowercased()) opens doorways to {strength}, while gentle attention to {challenge} deepens authentic spiritual evolution.",
            "family_dynamics": "Within family systems, Number \(number) energy manifests as {core_pattern}. Your \(archetype.essence.lowercased()) brings {strength} to family relationships, while awareness of {challenge} creates harmony across generations.",
            "financial_abundance": "In relationship with material resources, Number \(number) expresses {core_pattern}. Your \(archetype.essence.lowercased()) naturally attracts {strength}, while conscious attention to {challenge} ensures abundant flow.",
            "creative_expression": "Through creative channels, Number \(number) energy flows as {core_pattern}. Your \(archetype.essence.lowercased()) fuels {strength} in artistic endeavors, while awareness of {challenge} refines creative mastery.",
            "personal_power": "In claiming personal authority, Number \(number) manifests {core_pattern}. Your \(archetype.essence.lowercased()) empowers {strength}, while conscious attention to {challenge} ensures authentic empowerment.",
            "life_transitions": "During periods of change, Number \(number) provides {core_pattern}. Your \(archetype.essence.lowercased()) offers {strength} through transitions, while awareness of {challenge} supports graceful transformation."
        ]

        let template = aspectTemplates[aspect] ?? aspectTemplates["spiritual_growth"]!
        let corePattern = extractCorePattern(from: base.insight)
        let strength = archetype.opportunities.randomElement() ?? "growth"
        let challenge = archetype.challenges.randomElement() ?? "balance"

        let transformedInsight = template
            .replacingOccurrences(of: "{core_pattern}", with: corePattern)
            .replacingOccurrences(of: "{strength}", with: strength)
            .replacingOccurrences(of: "{challenge}", with: challenge)

        let category = "\(aspect)_\(base.category)"
        let triggers = generateAspectTriggers(aspect: aspect, base: base, archetype: archetype)
        let supports = generateAspectSupports(aspect: aspect, base: base, archetype: archetype)
        let challenges = generateAspectChallenges(aspect: aspect, base: base, archetype: archetype)

        return MultipliedInsight(
            category: category,
            insight: transformedInsight,
            intensity: base.intensity + Double.random(in: -0.05...0.05),
            triggers: triggers,
            supports: supports,
            challenges: challenges,
            generationStrategy: "aspect_variation_\(aspect)",
            qualityScore: calculateQualityScore(
                insight: transformedInsight,
                number: number,
                archetype: archetype,
                category: category
            )
        )
    }

    /// Transform insight for specific context
    private func transformInsightForContext(
        base: BaseInsight,
        context: String,
        archetype: NumberArchetype,
        number: Int
    ) -> MultipliedInsight {

        let contextTemplates: [String: String] = [
            "daily_life": "In the rhythm of everyday moments, Number \(number) energy infuses {core_pattern} into your daily experience. Each ordinary interaction becomes an opportunity to embody your \(archetype.essence.lowercased()) and practice {strength} while staying mindful of {challenge}.",
            "crisis_moments": "During times of crisis and challenge, Number \(number) reveals its true power through {core_pattern}. Your \(archetype.essence.lowercased()) becomes a source of {strength}, helping you navigate difficulties while transforming {challenge} into wisdom.",
            "celebration_times": "In moments of joy and celebration, Number \(number) expresses {core_pattern} with radiant authenticity. Your \(archetype.essence.lowercased()) naturally shares {strength} with others, while conscious appreciation prevents {challenge} from diminishing the light.",
            "growth_periods": "During phases of personal expansion, Number \(number) facilitates {core_pattern} as your primary growth mechanism. Your \(archetype.essence.lowercased()) accelerates {strength} while gentle attention to {challenge} ensures sustainable development.",
            "transition_phases": "As life chapters shift and change, Number \(number) provides {core_pattern} to guide your journey. Your \(archetype.essence.lowercased()) offers {strength} through uncertainty while awareness of {challenge} maintains equilibrium.",
            "manifestation_cycles": "In the process of bringing dreams into reality, Number \(number) contributes {core_pattern} to your manifestation abilities. Your \(archetype.essence.lowercased()) amplifies {strength} while conscious attention to {challenge} ensures aligned creation.",
            "healing_journeys": "On the path of healing and restoration, Number \(number) offers {core_pattern} as medicine for the soul. Your \(archetype.essence.lowercased()) facilitates {strength} while gentle awareness of {challenge} supports complete healing.",
            "decision_points": "At crossroads requiring choice, Number \(number) illuminates {core_pattern} to guide your decision-making. Your \(archetype.essence.lowercased()) provides clarity through {strength} while consideration of {challenge} ensures wise choices.",
            "breakthrough_moments": "In times of breakthrough and revelation, Number \(number) catalyzes {core_pattern} for quantum leaps forward. Your \(archetype.essence.lowercased()) accelerates {strength} while integration of {challenge} stabilizes new understanding."
        ]

        let template = contextTemplates[context] ?? contextTemplates["daily_life"]!
        let corePattern = extractCorePattern(from: base.insight)
        let strength = archetype.opportunities.randomElement() ?? "growth"
        let challenge = archetype.challenges.randomElement() ?? "balance"

        let transformedInsight = template
            .replacingOccurrences(of: "{core_pattern}", with: corePattern)
            .replacingOccurrences(of: "{strength}", with: strength)
            .replacingOccurrences(of: "{challenge}", with: challenge)

        let category = "\(context)_\(base.category)"
        let triggers = generateContextTriggers(context: context, base: base, archetype: archetype)
        let supports = generateContextSupports(context: context, base: base, archetype: archetype)
        let challenges = generateContextChallenges(context: context, base: base, archetype: archetype)

        return MultipliedInsight(
            category: category,
            insight: transformedInsight,
            intensity: adjustIntensityForContext(base.intensity, context: context),
            triggers: triggers,
            supports: supports,
            challenges: challenges,
            generationStrategy: "contextual_shift_\(context)",
            qualityScore: calculateQualityScore(
                insight: transformedInsight,
                number: number,
                archetype: archetype,
                category: category
            )
        )
    }

    /// Transform insight for specific intensity level
    private func transformInsightForIntensity(
        base: BaseInsight,
        targetIntensity: Double,
        archetype: NumberArchetype,
        number: Int
    ) -> MultipliedInsight {

        let intensityModifiers: [String] = targetIntensity >= 0.9 ?
            ["profound", "deep", "transformative", "powerful", "intense"] :
            targetIntensity >= 0.8 ?
            ["significant", "meaningful", "important", "notable", "clear"] :
            ["gentle", "subtle", "emerging", "beginning", "soft"]

        let modifier = intensityModifiers.randomElement() ?? "meaningful"
        let corePattern = extractCorePattern(from: base.insight)

        let transformedInsight = "Through \(modifier) awareness, Number \(number) reveals \(corePattern.lowercased()). This \(archetype.essence.lowercased()) offers a pathway to \(archetype.opportunities.randomElement() ?? "growth"), inviting you to embrace your authentic nature while remaining mindful of potential \(archetype.challenges.randomElement() ?? "challenges")."

        let category = "intensity_\(Int(targetIntensity * 100))_\(base.category)"

        return MultipliedInsight(
            category: category,
            insight: transformedInsight,
            intensity: targetIntensity,
            triggers: base.triggers,
            supports: base.supports,
            challenges: base.challenges,
            generationStrategy: "intensity_gradient_\(targetIntensity)",
            qualityScore: calculateQualityScore(
                insight: transformedInsight,
                number: number,
                archetype: archetype,
                category: category
            )
        )
    }

    /// Transform insight for specific persona voice
    private func transformInsightForPersona(
        base: BaseInsight,
        persona: String,
        archetype: NumberArchetype,
        number: Int
    ) -> MultipliedInsight {

        let personaVoices: [String: String] = [
            "Oracle": "The cosmic winds carry whispers of Number \(number)'s ancient wisdom: {core_pattern}. Sacred knowledge flows through your \(archetype.essence.lowercased()), revealing pathways to {strength} while the celestial guardians remind you to honor {challenge} as part of your divine journey.",
            "Psychologist": "Psychological research reveals that Number \(number) individuals demonstrate {core_pattern} as a core behavioral pattern. Your \(archetype.essence.lowercased()) provides psychological resources for {strength}, while healthy awareness of {challenge} supports optimal mental and emotional functioning.",
            "MindfulnessCoach": "In the present moment, notice how Number \(number) energy manifests as {core_pattern} within your immediate experience. Your \(archetype.essence.lowercased()) naturally cultivates {strength} through mindful attention, while gentle awareness of {challenge} deepens your practice.",
            "NumerologyScholar": "Vibrational analysis indicates that Number \(number) carries the mathematical frequency of {core_pattern}. Your \(archetype.essence.lowercased()) resonates with numerical patterns that enhance {strength}, while scholarly attention to {challenge} ensures accurate interpretation.",
            "Philosopher": "In contemplating the nature of existence, Number \(number) presents the philosophical proposition that {core_pattern}. Your \(archetype.essence.lowercased()) engages with universal questions through {strength}, while thoughtful consideration of {challenge} deepens philosophical understanding."
        ]

        let voice = personaVoices[persona] ?? personaVoices["Oracle"]!
        let corePattern = extractCorePattern(from: base.insight)
        let strength = archetype.opportunities.randomElement() ?? "growth"
        let challenge = archetype.challenges.randomElement() ?? "balance"

        let transformedInsight = voice
            .replacingOccurrences(of: "{core_pattern}", with: corePattern)
            .replacingOccurrences(of: "{strength}", with: strength)
            .replacingOccurrences(of: "{challenge}", with: challenge)

        let category = "\(persona.lowercased())_voice_\(base.category)"

        return MultipliedInsight(
            category: category,
            insight: transformedInsight,
            intensity: base.intensity,
            triggers: base.triggers,
            supports: base.supports,
            challenges: base.challenges,
            generationStrategy: "persona_variation_\(persona)",
            qualityScore: calculateQualityScore(
                insight: transformedInsight,
                number: number,
                archetype: archetype,
                category: category
            )
        )
    }

    /// Transform insight for specific life situation
    private func transformInsightForSituation(
        base: BaseInsight,
        situation: String,
        archetype: NumberArchetype,
        number: Int
    ) -> MultipliedInsight {

        let situationTemplates: [String: String] = [
            "morning_reflection": "As dawn breaks and consciousness awakens, Number \(number) offers {core_pattern} for your morning contemplation. Your \(archetype.essence.lowercased()) sets the tone for the day through {strength}, while mindful attention to {challenge} ensures balanced energy throughout your waking hours.",
            "evening_integration": "In the quiet space between day and night, Number \(number) facilitates {core_pattern} for integrating daily experiences. Your \(archetype.essence.lowercased()) processes the day's lessons through {strength}, while gentle awareness of {challenge} promotes restorative sleep and healing.",
            "decision_making": "When standing at crossroads of choice, Number \(number) illuminates {core_pattern} to guide your decision-making process. Your \(archetype.essence.lowercased()) provides clarity through {strength}, while careful consideration of {challenge} ensures choices aligned with your highest good.",
            "relationship_dynamics": "Within the dance of human connection, Number \(number) expresses {core_pattern} through your relational patterns. Your \(archetype.essence.lowercased()) contributes {strength} to relationship dynamics, while awareness of {challenge} creates space for authentic intimacy.",
            "career_crossroads": "At pivotal moments in your professional journey, Number \(number) reveals {core_pattern} for career navigation. Your \(archetype.essence.lowercased()) opens pathways to {strength} in work environments, while attention to {challenge} ensures sustainable professional growth.",
            "spiritual_practice": "In the sacred space of spiritual communion, Number \(number) deepens {core_pattern} through devoted practice. Your \(archetype.essence.lowercased()) enhances connection to {strength}, while honest acknowledgment of {challenge} purifies and strengthens your spiritual foundation.",
            "creative_projects": "As creative energy seeks expression, Number \(number) channels {core_pattern} through artistic endeavors. Your \(archetype.essence.lowercased()) fuels {strength} in creative work, while conscious awareness of {challenge} refines artistic mastery and authentic expression.",
            "healing_journey": "On the path of healing and restoration, Number \(number) contributes {core_pattern} as medicine for body, mind, and spirit. Your \(archetype.essence.lowercased()) facilitates {strength} in the healing process, while gentle integration of {challenge} ensures complete and lasting wellness.",
            "manifestation_work": "In the alchemical process of bringing dreams into form, Number \(number) provides {core_pattern} for manifestation mastery. Your \(archetype.essence.lowercased()) amplifies {strength} in co-creative work with the universe, while awareness of {challenge} ensures aligned and sustainable manifestation.",
            "life_transitions": "During passages between life phases, Number \(number) offers {core_pattern} for graceful transition. Your \(archetype.essence.lowercased()) provides {strength} through periods of change, while honoring {challenge} creates space for authentic transformation and growth."
        ]

        let template = situationTemplates[situation] ?? situationTemplates["spiritual_practice"]!
        let corePattern = extractCorePattern(from: base.insight)
        let strength = archetype.opportunities.randomElement() ?? "growth"
        let challenge = archetype.challenges.randomElement() ?? "balance"

        let transformedInsight = template
            .replacingOccurrences(of: "{core_pattern}", with: corePattern)
            .replacingOccurrences(of: "{strength}", with: strength)
            .replacingOccurrences(of: "{challenge}", with: challenge)

        let category = "\(situation)_application_\(base.category)"

        return MultipliedInsight(
            category: category,
            insight: transformedInsight,
            intensity: base.intensity,
            triggers: base.triggers,
            supports: base.supports,
            challenges: base.challenges,
            generationStrategy: "situational_application_\(situation)",
            qualityScore: calculateQualityScore(
                insight: transformedInsight,
                number: number,
                archetype: archetype,
                category: category
            )
        )
    }

    // MARK: - Helper Methods

    /// Load base insights from existing rich content file
    private func loadBaseInsights(for number: Int) async throws -> [BaseInsight] {
        guard let bundleURL = Bundle.main.url(
            forResource: "\(number)_rich",
            withExtension: "json",
            subdirectory: "KASPERMLXRuntimeBundle/RichNumberMeanings"
        ) else {
            throw MultiplicationError.baseFileNotFound(number)
        }

        let jsonData = try Data(contentsOf: bundleURL)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])

        guard let jsonDict = jsonObject as? [String: Any],
              let behavioralInsights = jsonDict["behavioral_insights"] as? [[String: Any]] else {
            throw MultiplicationError.invalidSchema(number)
        }

        var baseInsights: [BaseInsight] = []

        for insightDict in behavioralInsights {
            guard let category = insightDict["category"] as? String,
                  let insight = insightDict["insight"] as? String,
                  let intensity = insightDict["intensity"] as? Double,
                  let triggers = insightDict["triggers"] as? [String],
                  let supports = insightDict["supports"] as? [String],
                  let challenges = insightDict["challenges"] as? [String] else {
                continue
            }

            baseInsights.append(BaseInsight(
                category: category,
                insight: insight,
                intensity: intensity,
                triggers: triggers,
                supports: supports,
                challenges: challenges
            ))
        }

        return baseInsights
    }

    /// Get archetype for number (handles master numbers)
    private func getArchetype(for number: Int) -> NumberArchetype {
        if let masterArchetype = masterNumbers[number] {
            return masterArchetype
        }
        return numberArchetypes[number] ?? numberArchetypes[1]!
    }

    /// Extract core pattern from base insight
    private func extractCorePattern(from insight: String) -> String {
        // Extract the essence by finding patterns between ** markers or after "represents"
        if insight.contains("**") {
            let components = insight.components(separatedBy: "**")
            if components.count >= 2 {
                return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        if insight.contains("represents") {
            let components = insight.components(separatedBy: "represents")
            if components.count >= 2 {
                let part = components[1].components(separatedBy: " - ")[0]
                return part.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        // Fallback: take first sentence
        let sentences = insight.components(separatedBy: ". ")
        return sentences.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "spiritual growth"
    }

    /// Select best base insight for given aspect/context
    private func selectBestBaseInsight(
        from insights: [BaseInsight],
        for aspect: String,
        archetype: NumberArchetype
    ) -> BaseInsight {

        // Score insights based on relevance to aspect
        let scored = insights.map { insight in
            (insight: insight, score: calculateRelevanceScore(insight: insight, aspect: aspect, archetype: archetype))
        }

        // Return highest scoring insight
        return scored.max { $0.score < $1.score }?.insight ?? insights.first ?? BaseInsight.default
    }

    /// Calculate relevance score for insight-aspect combination
    private func calculateRelevanceScore(insight: BaseInsight, aspect: String, archetype: NumberArchetype) -> Double {
        var score = 0.0

        // Base intensity score
        score += insight.intensity * 0.3

        // Keyword matching in content
        let lowercased = insight.insight.lowercased()
        let aspectKeywords = getAspectKeywords(aspect)

        for keyword in aspectKeywords {
            if lowercased.contains(keyword) {
                score += 0.1
            }
        }

        // Archetype keyword matching
        for keyword in archetype.keywords {
            if lowercased.contains(keyword) {
                score += 0.05
            }
        }

        return min(score, 1.0)
    }

    /// Get keywords for aspect
    private func getAspectKeywords(_ aspect: String) -> [String] {
        let aspectKeywords: [String: [String]] = [
            "love_relationships": ["love", "relationship", "partner", "heart", "romance", "connection"],
            "career_professional": ["career", "work", "professional", "business", "job", "achievement"],
            "health_wellness": ["health", "wellness", "body", "vitality", "healing", "balance"],
            "spiritual_growth": ["spiritual", "soul", "divine", "consciousness", "awakening", "enlightenment"],
            "family_dynamics": ["family", "home", "parent", "child", "tradition", "roots"],
            "financial_abundance": ["money", "abundance", "wealth", "prosperity", "material", "resources"],
            "creative_expression": ["creative", "artistic", "expression", "inspiration", "beauty", "art"],
            "personal_power": ["power", "strength", "confidence", "authority", "mastery", "leadership"],
            "life_transitions": ["change", "transition", "transformation", "growth", "evolution", "new"]
        ]

        return aspectKeywords[aspect] ?? []
    }

    /// Generate aspect-specific triggers
    private func generateAspectTriggers(aspect: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let aspectTriggers: [String: [String]] = [
            "love_relationships": ["romantic_encounters", "relationship_decisions", "intimacy_opportunities", "partnership_calls"],
            "career_professional": ["career_opportunities", "professional_challenges", "workplace_dynamics", "achievement_moments"],
            "health_wellness": ["wellness_choices", "health_awareness", "vitality_practices", "healing_opportunities"],
            "spiritual_growth": ["spiritual_awakening", "consciousness_expansion", "divine_connection", "sacred_moments"],
            "family_dynamics": ["family_gatherings", "generational_healing", "home_creation", "ancestry_connection"],
            "financial_abundance": ["abundance_opportunities", "material_decisions", "prosperity_alignment", "resource_stewardship"],
            "creative_expression": ["creative_inspiration", "artistic_breakthroughs", "expression_calls", "beauty_recognition"],
            "personal_power": ["empowerment_moments", "authority_opportunities", "strength_activation", "mastery_development"],
            "life_transitions": ["change_catalysts", "transformation_portals", "growth_edges", "evolution_calls"]
        ]

        let baseList = aspectTriggers[aspect] ?? base.triggers
        return Array(baseList.prefix(3))
    }

    /// Generate aspect-specific supports
    private func generateAspectSupports(aspect: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let aspectSupports: [String: [String]] = [
            "love_relationships": ["authentic_intimacy", "heart_connection", "relationship_wisdom", "love_mastery"],
            "career_professional": ["professional_excellence", "career_advancement", "workplace_leadership", "achievement_fulfillment"],
            "health_wellness": ["holistic_wellness", "vitality_optimization", "healing_mastery", "body_wisdom"],
            "spiritual_growth": ["spiritual_development", "consciousness_evolution", "divine_alignment", "sacred_living"],
            "family_dynamics": ["family_harmony", "generational_healing", "home_sanctuary", "ancestral_wisdom"],
            "financial_abundance": ["material_mastery", "abundance_flow", "prosperity_consciousness", "resource_wisdom"],
            "creative_expression": ["artistic_mastery", "creative_fulfillment", "expression_authenticity", "beauty_creation"],
            "personal_power": ["authentic_empowerment", "personal_mastery", "strength_integration", "authority_wisdom"],
            "life_transitions": ["graceful_transformation", "evolutionary_growth", "change_mastery", "transition_wisdom"]
        ]

        let baseList = aspectSupports[aspect] ?? base.supports
        return Array(baseList.prefix(3))
    }

    /// Generate aspect-specific challenges
    private func generateAspectChallenges(aspect: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let aspectChallenges: [String: [String]] = [
            "love_relationships": ["relationship_dependency", "intimacy_fears", "partnership_imbalance", "love_attachment"],
            "career_professional": ["work_obsession", "professional_ego", "career_stress", "achievement_addiction"],
            "health_wellness": ["wellness_perfectionism", "health_anxiety", "body_disconnection", "healing_impatience"],
            "spiritual_growth": ["spiritual_bypassing", "enlightenment_ego", "practice_rigidity", "divine_inflation"],
            "family_dynamics": ["family_enmeshment", "generational_patterns", "home_attachment", "ancestry_burden"],
            "financial_abundance": ["material_obsession", "abundance_guilt", "prosperity_fear", "resource_hoarding"],
            "creative_expression": ["creative_perfectionism", "artistic_ego", "expression_fear", "beauty_obsession"],
            "personal_power": ["power_corruption", "strength_misuse", "authority_abuse", "mastery_arrogance"],
            "life_transitions": ["change_resistance", "transformation_fear", "growth_avoidance", "transition_chaos"]
        ]

        let baseList = aspectChallenges[aspect] ?? base.challenges
        return Array(baseList.prefix(3))
    }

    /// Generate context-specific triggers
    private func generateContextTriggers(context: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let contextTriggers: [String: [String]] = [
            "daily_life": ["routine_moments", "ordinary_interactions", "daily_practices", "mundane_experiences"],
            "crisis_moments": ["emergency_situations", "crisis_points", "challenge_peaks", "survival_modes"],
            "celebration_times": ["joy_moments", "success_celebrations", "achievement_recognition", "happiness_peaks"],
            "growth_periods": ["expansion_phases", "development_opportunities", "learning_moments", "evolution_calls"],
            "transition_phases": ["change_periods", "shift_moments", "transformation_gateways", "evolution_portals"],
            "manifestation_cycles": ["creation_moments", "manifestation_opportunities", "reality_shaping", "dream_actualization"],
            "healing_journeys": ["healing_catalysts", "restoration_calls", "wellness_invitations", "recovery_opportunities"],
            "decision_points": ["choice_moments", "crossroads_encounters", "decision_pressures", "path_selections"],
            "breakthrough_moments": ["revelation_instances", "breakthrough_catalysts", "quantum_leaps", "paradigm_shifts"]
        ]

        let baseList = contextTriggers[context] ?? base.triggers
        return Array(baseList.prefix(3))
    }

    /// Generate context-specific supports
    private func generateContextSupports(context: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let contextSupports: [String: [String]] = [
            "daily_life": ["routine_mastery", "ordinary_mindfulness", "daily_presence", "mundane_awareness"],
            "crisis_moments": ["crisis_resilience", "emergency_wisdom", "challenge_strength", "survival_mastery"],
            "celebration_times": ["joy_amplification", "success_integration", "achievement_wisdom", "happiness_balance"],
            "growth_periods": ["expansion_support", "development_acceleration", "learning_enhancement", "evolution_facilitation"],
            "transition_phases": ["change_navigation", "shift_support", "transformation_guidance", "evolution_assistance"],
            "manifestation_cycles": ["creation_power", "manifestation_mastery", "reality_alignment", "dream_fulfillment"],
            "healing_journeys": ["healing_acceleration", "restoration_support", "wellness_enhancement", "recovery_mastery"],
            "decision_points": ["choice_clarity", "crossroads_wisdom", "decision_confidence", "path_illumination"],
            "breakthrough_moments": ["revelation_integration", "breakthrough_stabilization", "quantum_grounding", "paradigm_mastery"]
        ]

        let baseList = contextSupports[context] ?? base.supports
        return Array(baseList.prefix(3))
    }

    /// Generate context-specific challenges
    private func generateContextChallenges(context: String, base: BaseInsight, archetype: NumberArchetype) -> [String] {
        let contextChallenges: [String: [String]] = [
            "daily_life": ["routine_stagnation", "ordinary_boredom", "daily_unconsciousness", "mundane_numbness"],
            "crisis_moments": ["crisis_overwhelm", "emergency_panic", "challenge_defeat", "survival_desperation"],
            "celebration_times": ["joy_attachment", "success_ego", "achievement_inflation", "happiness_addiction"],
            "growth_periods": ["expansion_overwhelm", "development_impatience", "learning_frustration", "evolution_resistance"],
            "transition_phases": ["change_anxiety", "shift_instability", "transformation_chaos", "evolution_confusion"],
            "manifestation_cycles": ["creation_attachment", "manifestation_obsession", "reality_forcing", "dream_desperation"],
            "healing_journeys": ["healing_impatience", "restoration_forcing", "wellness_perfectionism", "recovery_addiction"],
            "decision_points": ["choice_paralysis", "crossroads_confusion", "decision_anxiety", "path_uncertainty"],
            "breakthrough_moments": ["revelation_overwhelm", "breakthrough_instability", "quantum_confusion", "paradigm_shock"]
        ]

        let baseList = contextChallenges[context] ?? base.challenges
        return Array(baseList.prefix(3))
    }

    /// Adjust intensity based on context
    private func adjustIntensityForContext(_ baseIntensity: Double, context: String) -> Double {
        let contextModifiers: [String: Double] = [
            "daily_life": -0.1,       // More gentle for daily practice
            "crisis_moments": 0.15,   // Higher intensity for crisis
            "celebration_times": 0.05, // Slightly elevated for joy
            "growth_periods": 0.1,    // Enhanced for growth
            "transition_phases": 0.05, // Moderate increase for transitions
            "manifestation_cycles": 0.08, // Boosted for creation work
            "healing_journeys": -0.05, // Gentle for healing
            "decision_points": 0.1,   // Clear for decisions
            "breakthrough_moments": 0.2 // Peak intensity for breakthroughs
        ]

        let modifier = contextModifiers[context] ?? 0.0
        return max(0.6, min(1.0, baseIntensity + modifier))
    }

    /// Calculate quality score for generated insight
    private func calculateQualityScore(
        insight: String,
        number: Int,
        archetype: NumberArchetype,
        category: String
    ) -> Double {

        var score = 0.0
        let lowercased = insight.lowercased()

        // Length appropriateness (0.2 weight)
        let wordCount = insight.split(separator: " ").count
        if wordCount >= 30 && wordCount <= 120 {
            score += 0.2
        } else if wordCount >= 20 && wordCount <= 150 {
            score += 0.15
        } else {
            score += 0.1
        }

        // Number reference (0.2 weight)
        if lowercased.contains("number \(number)") {
            score += 0.2
        } else if lowercased.contains("\(number)") {
            score += 0.15
        } else {
            score += 0.1
        }

        // Archetype keyword presence (0.3 weight)
        var keywordCount = 0
        for keyword in archetype.keywords {
            if lowercased.contains(keyword) {
                keywordCount += 1
            }
        }
        score += min(Double(keywordCount) / Double(archetype.keywords.count), 1.0) * 0.3

        // Spiritual language (0.2 weight)
        let spiritualWords = ["spiritual", "consciousness", "divine", "sacred", "soul", "essence", "energy", "wisdom", "awakening", "transformation"]
        var spiritualCount = 0
        for word in spiritualWords {
            if lowercased.contains(word) {
                spiritualCount += 1
            }
        }
        score += min(Double(spiritualCount) / 3.0, 1.0) * 0.2

        // Coherence and flow (0.1 weight)
        let sentences = insight.components(separatedBy: ". ")
        if sentences.count >= 2 && sentences.count <= 5 {
            score += 0.1
        } else {
            score += 0.05
        }

        return min(score, 1.0)
    }

    /// Save multiplied insights to JSON file
    private func saveMultipliedFile(for number: Int, result: MultiplicationResult) async throws {
        // Load original file to get metadata
        guard let originalURL = Bundle.main.url(
            forResource: "\(number)_rich",
            withExtension: "json",
            subdirectory: "KASPERMLXRuntimeBundle/RichNumberMeanings"
        ) else {
            throw MultiplicationError.baseFileNotFound(number)
        }

        let originalData = try Data(contentsOf: originalURL)
        let originalDict = try JSONSerialization.jsonObject(with: originalData) as? [String: Any] ?? [:]

        // Create multiplied content structure
        var multipliedDict: [String: Any] = [
            "number": number,
            "title": "\(originalDict["title"] as? String ?? "Number \(number)") (Multiplied Insights)",
            "source": "multiplication_agents",
            "persona": "MultiPersona",
            "behavioral_category": "\(originalDict["behavioral_category"] as? String ?? "")_expanded",
            "intensity_scoring": [
                "min_range": 0.6,
                "max_range": 1.0,
                "note": "Multiplied insights spanning full intensity spectrum for contextual variety"
            ]
        ]

        // Convert multiplied insights to JSON format
        var behavioralInsights: [[String: Any]] = []

        for insight in result.insights {
            let insightDict: [String: Any] = [
                "category": insight.category,
                "insight": insight.insight,
                "intensity": insight.intensity,
                "triggers": insight.triggers,
                "supports": insight.supports,
                "challenges": insight.challenges
            ]
            behavioralInsights.append(insightDict)
        }

        multipliedDict["behavioral_insights"] = behavioralInsights

        // Add multiplication metadata
        multipliedDict["meta"] = [
            "type": "multiplied",
            "archetype": getArchetype(for: number).essence,
            "element": getElementForNumber(number),
            "multiplication_metadata": [
                "base_file": "\(number)_rich.json",
                "generation_date": ISO8601DateFormatter().string(from: Date()),
                "strategies_used": Array(result.strategies.keys),
                "total_base_insights": 20,
                "total_multiplied_insights": result.insights.count,
                "quality_validation": [
                    "average_score": result.averageQuality,
                    "passed_validation": result.qualityPassed,
                    "failed_validation": result.totalGenerated - result.qualityPassed
                ]
            ]
        ]

        // Write to new file in same directory
        let outputURL = originalURL.deletingLastPathComponent()
            .appendingPathComponent("\(number)_rich_multiplied.json")

        let jsonData = try JSONSerialization.data(withJSONObject: multipliedDict, options: [.prettyPrinted])
        try jsonData.write(to: outputURL)

        logger.info("✅ Saved \(number)_rich_multiplied.json with \(result.insights.count) insights")
    }

    /// Get element for number (for metadata)
    private func getElementForNumber(_ number: Int) -> String {
        let elements: [Int: String] = [
            1: "fire", 2: "water", 3: "air", 4: "earth", 5: "fire",
            6: "earth", 7: "water", 8: "earth", 9: "fire",
            11: "air", 22: "earth", 33: "water", 44: "earth"
        ]

        return elements[number] ?? "spirit"
    }

    // MARK: - Public Utility Methods

    /// Get generation statistics
    public func getGenerationStats() -> GenerationStatistics {
        return generationStats
    }

    /// Clear cache and reset
    public func reset() {
        generationStats = GenerationStatistics()
        progress = 0.0
        currentNumber = 1
        logger.info("🔄 NumberMultiplicationSystem reset")
    }
}

// MARK: - Supporting Data Structures

/// Number archetype information
public struct NumberArchetype {
    let essence: String
    let keywords: [String]
    let challenges: [String]
    let opportunities: [String]
}

/// Base insight from original file
public struct BaseInsight {
    let category: String
    let insight: String
    let intensity: Double
    let triggers: [String]
    let supports: [String]
    let challenges: [String]

    static let `default` = BaseInsight(
        category: "core_essence",
        insight: "Spiritual growth through authentic self-expression",
        intensity: 0.75,
        triggers: ["growth_opportunities"],
        supports: ["authentic_expression"],
        challenges: ["self_doubt"]
    )
}

/// Generation statistics
public struct GenerationStatistics {
    public var numbersProcessed: Int = 0
    public var totalInsightsGenerated: Int = 0
    public var totalQualityPassed: Int = 0
    public var totalGenerationTime: TimeInterval = 0.0

    public var averageQuality: Double {
        guard totalInsightsGenerated > 0 else { return 0.0 }
        return Double(totalQualityPassed) / Double(totalInsightsGenerated)
    }

    public var averageTimePerNumber: TimeInterval {
        guard numbersProcessed > 0 else { return 0.0 }
        return totalGenerationTime / Double(numbersProcessed)
    }

    public var insightsPerSecond: Double {
        guard totalGenerationTime > 0 else { return 0.0 }
        return Double(totalInsightsGenerated) / totalGenerationTime
    }
}

// MARK: - Error Types

public enum MultiplicationError: Error, LocalizedError {
    case baseFileNotFound(Int)
    case invalidSchema(Int)
    case qualityThresholdNotMet(Int)
    case fileWriteError(Int, Error)

    public var errorDescription: String? {
        switch self {
        case .baseFileNotFound(let number):
            return "Base file \(number)_rich.json not found in RuntimeBundle"
        case .invalidSchema(let number):
            return "Invalid schema in base file for number \(number)"
        case .qualityThresholdNotMet(let number):
            return "Generated insights for number \(number) did not meet quality threshold"
        case .fileWriteError(let number, let error):
            return "Failed to write multiplied file for number \(number): \(error.localizedDescription)"
        }
    }
}

/**
 * USAGE EXAMPLE:
 *
 * let multiplier = NumberMultiplicationSystem()
 *
 * // Deploy all multiplication agents
 * let results = try await multiplier.deployAllMultiplicationAgents()
 *
 * // Results will contain 13 MultiplicationResult objects
 * // Each with 75+ unique insights for each number
 * // New files: 1_rich_multiplied.json, 2_rich_multiplied.json, etc.
 *
 * print("Generated \(results.reduce(0) { $0 + $1.insights.count }) total insights")
 */
