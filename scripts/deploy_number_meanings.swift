#!/usr/bin/env swift

/**
 * =================================================================
 * 🚀 NUMBERMEANINGS MULTIPLICATION DEPLOYMENT SCRIPT
 * =================================================================
 *
 * Command-line script to deploy all NumberMeanings multiplication agents
 * and generate 75+ insights per number for immediate testing.
 *
 * Usage: swift scripts/deploy_number_meanings.swift
 *
 * Output: Creates *_rich_multiplied.json files in KASPERMLXRuntimeBundle
 */

import Foundation

// MARK: - Main Deployment Function

func deployMultiplicationAgents() async throws {
    print("🚀 DEPLOYING NumberMeanings Multiplication Agents...")
    print("📊 Target: 75+ insights per number across 13 numbers")
    print("")

    let startTime = CFAbsoluteTimeGetCurrent()
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

    var totalInsights = 0
    var successCount = 0

    for (index, number) in numbers.enumerated() {
        print("🔢 Processing Number \(number) (\(index + 1)/\(numbers.count))...")

        do {
            let insights = try await generateMultipliedInsights(for: number)
            try await saveMultipliedFile(for: number, insights: insights)

            totalInsights += insights.count
            successCount += 1

            print("✅ Generated \(insights.count) insights for Number \(number)")
        } catch {
            print("❌ Failed to process Number \(number): \(error)")
        }
    }

    let totalTime = CFAbsoluteTimeGetCurrent() - startTime

    print("")
    print("🎉 DEPLOYMENT COMPLETE!")
    print("📊 Results:")
    print("   • Numbers processed: \(successCount)/\(numbers.count)")
    print("   • Total insights: \(totalInsights)")
    print("   • Average per number: \(totalInsights / successCount)")
    print("   • Total time: \(String(format: "%.2f", totalTime))s")
    print("   • Insights/sec: \(String(format: "%.1f", Double(totalInsights) / totalTime))")
}

// MARK: - Insight Generation

func generateMultipliedInsights(for number: Int) async throws -> [MultipliedInsight] {
    // Load base insights
    let baseInsights = try loadBaseInsights(for: number)
    let archetype = getArchetype(for: number)

    var insights: [MultipliedInsight] = []

    // Strategy 1: Aspect Variations (20 insights)
    insights.append(contentsOf: generateAspectVariations(base: baseInsights, archetype: archetype, number: number))

    // Strategy 2: Contextual Shifts (20 insights)
    insights.append(contentsOf: generateContextualShifts(base: baseInsights, archetype: archetype, number: number))

    // Strategy 3: Intensity Gradients (15 insights)
    insights.append(contentsOf: generateIntensityGradients(base: baseInsights, archetype: archetype, number: number))

    // Strategy 4: Persona Variations (15 insights)
    insights.append(contentsOf: generatePersonaVariations(base: baseInsights, archetype: archetype, number: number))

    // Strategy 5: Situational Applications (10 insights)
    insights.append(contentsOf: generateSituationalApplications(base: baseInsights, archetype: archetype, number: number))

    // Filter by quality and return top 75
    return Array(insights.filter { $0.qualityScore >= 0.75 }.prefix(75))
}

// MARK: - Strategy 1: Aspect Variations

func generateAspectVariations(base: [BaseInsight], archetype: NumberArchetype, number: Int) -> [MultipliedInsight] {
    let aspects = [
        "love_relationships", "career_professional", "health_wellness", "spiritual_growth",
        "family_dynamics", "financial_abundance", "creative_expression", "personal_power",
        "life_transitions", "daily_practice", "communication_style", "leadership_approach",
        "decision_making", "conflict_resolution", "goal_achievement", "emotional_intelligence",
        "social_dynamics", "learning_style", "service_contribution", "manifestation_ability"
    ]

    var insights: [MultipliedInsight] = []

    for aspect in aspects.prefix(20) {
        let baseInsight = base.randomElement() ?? base[0]
        let insight = transformForAspect(base: baseInsight, aspect: aspect, archetype: archetype, number: number)
        insights.append(insight)
    }

    return insights
}

// MARK: - Strategy 2: Contextual Shifts

func generateContextualShifts(base: [BaseInsight], archetype: NumberArchetype, number: Int) -> [MultipliedInsight] {
    let contexts = [
        "morning_reflection", "evening_integration", "crisis_navigation", "celebration_moments",
        "growth_periods", "transition_phases", "manifestation_cycles", "healing_journeys",
        "decision_crossroads", "breakthrough_experiences", "relationship_dynamics", "workplace_situations",
        "family_gatherings", "creative_projects", "spiritual_practice", "physical_wellness",
        "financial_planning", "educational_pursuits", "travel_experiences", "community_service"
    ]

    var insights: [MultipliedInsight] = []

    for context in contexts.prefix(20) {
        let baseInsight = base.randomElement() ?? base[0]
        let insight = transformForContext(base: baseInsight, context: context, archetype: archetype, number: number)
        insights.append(insight)
    }

    return insights
}

// MARK: - Strategy 3: Intensity Gradients

func generateIntensityGradients(base: [BaseInsight], archetype: NumberArchetype, number: Int) -> [MultipliedInsight] {
    let intensities: [Double] = [0.62, 0.67, 0.72, 0.77, 0.82, 0.87, 0.92, 0.97, 0.65, 0.75, 0.85, 0.95, 0.70, 0.80, 0.90]

    var insights: [MultipliedInsight] = []

    for intensity in intensities {
        let baseInsight = base.randomElement() ?? base[0]
        let insight = transformForIntensity(base: baseInsight, intensity: intensity, archetype: archetype, number: number)
        insights.append(insight)
    }

    return insights
}

// MARK: - Strategy 4: Persona Variations

func generatePersonaVariations(base: [BaseInsight], archetype: NumberArchetype, number: Int) -> [MultipliedInsight] {
    let personas = ["Oracle", "Psychologist", "MindfulnessCoach", "NumerologyScholar", "Philosopher"]
    let variations = ["mystical", "analytical", "compassionate", "wise", "contemplative", "intuitive", "scientific", "healing", "teaching", "guiding", "inspiring", "transforming", "enlightening", "nurturing", "empowering"]

    var insights: [MultipliedInsight] = []

    for variation in variations {
        let baseInsight = base.randomElement() ?? base[0]
        let persona = personas.randomElement() ?? "Oracle"
        let insight = transformForPersona(base: baseInsight, persona: persona, variation: variation, archetype: archetype, number: number)
        insights.append(insight)
    }

    return insights
}

// MARK: - Strategy 5: Situational Applications

func generateSituationalApplications(base: [BaseInsight], archetype: NumberArchetype, number: Int) -> [MultipliedInsight] {
    let situations = [
        "new_job_starting", "relationship_beginning", "home_moving", "creative_project_launch",
        "health_challenge_facing", "financial_goal_setting", "spiritual_awakening", "family_expansion",
        "career_transition", "educational_pursuit"
    ]

    var insights: [MultipliedInsight] = []

    for situation in situations {
        let baseInsight = base.randomElement() ?? base[0]
        let insight = transformForSituation(base: baseInsight, situation: situation, archetype: archetype, number: number)
        insights.append(insight)
    }

    return insights
}

// MARK: - Transformation Functions

func transformForAspect(base: BaseInsight, aspect: String, archetype: NumberArchetype, number: Int) -> MultipliedInsight {
    let template = getAspectTemplate(aspect, number: number)
    let core = extractCore(from: base.insight)
    let strength = archetype.opportunities.randomElement() ?? "growth"
    let challenge = archetype.challenges.randomElement() ?? "balance"

    let transformedInsight = template
        .replacingOccurrences(of: "{core}", with: core)
        .replacingOccurrences(of: "{strength}", with: strength)
        .replacingOccurrences(of: "{challenge}", with: challenge)

    let adjustedIntensity = max(0.6, min(1.0, base.intensity + Double.random(in: -0.05...0.05)))

    return MultipliedInsight(
        category: "\(aspect)_\(base.category)",
        insight: transformedInsight,
        intensity: adjustedIntensity.isNaN ? 0.75 : adjustedIntensity,
        triggers: base.triggers,
        supports: base.supports,
        challenges: base.challenges,
        qualityScore: calculateQuality(transformedInsight, number: number, archetype: archetype)
    )
}

func transformForContext(base: BaseInsight, context: String, archetype: NumberArchetype, number: Int) -> MultipliedInsight {
    let template = getContextTemplate(context, number: number)
    let core = extractCore(from: base.insight)

    let transformedInsight = template.replacingOccurrences(of: "{core}", with: core)

    let safeIntensity = base.intensity.isNaN ? 0.75 : max(0.6, min(1.0, base.intensity))

    return MultipliedInsight(
        category: "\(context)_\(base.category)",
        insight: transformedInsight,
        intensity: safeIntensity,
        triggers: base.triggers,
        supports: base.supports,
        challenges: base.challenges,
        qualityScore: calculateQuality(transformedInsight, number: number, archetype: archetype)
    )
}

func transformForIntensity(base: BaseInsight, intensity: Double, archetype: NumberArchetype, number: Int) -> MultipliedInsight {
    let modifier = intensity >= 0.9 ? "profound" : intensity >= 0.8 ? "significant" : "gentle"
    let core = extractCore(from: base.insight)

    let transformedInsight = "Through \(modifier) awareness, Number \(number) reveals \(core.lowercased()). This path offers opportunities for \(archetype.opportunities.randomElement() ?? "growth") while remaining mindful of \(archetype.challenges.randomElement() ?? "balance")."

    let safeIntensity = intensity.isNaN ? 0.75 : max(0.6, min(1.0, intensity))

    return MultipliedInsight(
        category: "intensity_\(Int(safeIntensity * 100))_\(base.category)",
        insight: transformedInsight,
        intensity: safeIntensity,
        triggers: base.triggers,
        supports: base.supports,
        challenges: base.challenges,
        qualityScore: calculateQuality(transformedInsight, number: number, archetype: archetype)
    )
}

func transformForPersona(base: BaseInsight, persona: String, variation: String, archetype: NumberArchetype, number: Int) -> MultipliedInsight {
    let template = getPersonaTemplate(persona, number: number)
    let core = extractCore(from: base.insight)

    let transformedInsight = template.replacingOccurrences(of: "{core}", with: core)

    let safeIntensity = base.intensity.isNaN ? 0.75 : max(0.6, min(1.0, base.intensity))

    return MultipliedInsight(
        category: "\(persona.lowercased())_\(variation)_\(base.category)",
        insight: transformedInsight,
        intensity: safeIntensity,
        triggers: base.triggers,
        supports: base.supports,
        challenges: base.challenges,
        qualityScore: calculateQuality(transformedInsight, number: number, archetype: archetype)
    )
}

func transformForSituation(base: BaseInsight, situation: String, archetype: NumberArchetype, number: Int) -> MultipliedInsight {
    let template = getSituationTemplate(situation, number: number)
    let core = extractCore(from: base.insight)

    let transformedInsight = template.replacingOccurrences(of: "{core}", with: core)

    let safeIntensity = base.intensity.isNaN ? 0.75 : max(0.6, min(1.0, base.intensity))

    return MultipliedInsight(
        category: "\(situation)_\(base.category)",
        insight: transformedInsight,
        intensity: safeIntensity,
        triggers: base.triggers,
        supports: base.supports,
        challenges: base.challenges,
        qualityScore: calculateQuality(transformedInsight, number: number, archetype: archetype)
    )
}

// MARK: - Template Functions

func getAspectTemplate(_ aspect: String, number: Int) -> String {
    let templates: [String: String] = [
        "love_relationships": "In matters of the heart, Number \(number) energy manifests as {core}. This creates opportunities for {strength} in romantic connections while awareness of {challenge} deepens authentic intimacy.",
        "career_professional": "Within professional environments, Number \(number) expresses {core}. This energy supports {strength} in career advancement while mindful attention to {challenge} ensures sustainable success.",
        "health_wellness": "In wellness and vitality, Number \(number) promotes {core}. This naturally enhances {strength} in physical well-being while conscious awareness of {challenge} maintains holistic health.",
        "spiritual_growth": "On the spiritual path, Number \(number) facilitates {core}. This opens doorways to {strength} in consciousness expansion while gentle attention to {challenge} deepens authentic awakening."
    ]

    return templates[aspect] ?? templates["spiritual_growth"]!
}

func getContextTemplate(_ context: String, number: Int) -> String {
    let templates: [String: String] = [
        "morning_reflection": "As dawn awakens consciousness, Number \(number) offers {core} for morning contemplation, setting the tone for aligned daily experience.",
        "evening_integration": "In the quiet space between day and night, Number \(number) facilitates {core} for integrating daily lessons and preparing for restorative rest.",
        "crisis_navigation": "During challenging times, Number \(number) reveals {core} as a source of strength, helping navigate difficulties with wisdom and resilience.",
        "celebration_moments": "In times of joy and achievement, Number \(number) expresses {core} with radiant authenticity, sharing light while maintaining groundedness."
    ]

    return templates[context] ?? templates["morning_reflection"]!
}

func getPersonaTemplate(_ persona: String, number: Int) -> String {
    let templates: [String: String] = [
        "Oracle": "The cosmic winds whisper ancient wisdom: Number \(number) carries {core}. Sacred knowledge flows through divine channels, revealing pathways to enlightenment.",
        "Psychologist": "Psychological research indicates that Number \(number) individuals demonstrate {core} as a core behavioral pattern, supporting optimal mental and emotional functioning.",
        "MindfulnessCoach": "In present-moment awareness, notice how Number \(number) energy manifests as {core} within your immediate experience, cultivating mindful attention.",
        "NumerologyScholar": "Vibrational analysis reveals that Number \(number) carries the mathematical frequency of {core}, resonating with universal numerical patterns.",
        "Philosopher": "In contemplating existence, Number \(number) presents the philosophical proposition that {core}, engaging with universal questions of meaning."
    ]

    return templates[persona] ?? templates["Oracle"]!
}

func getSituationTemplate(_ situation: String, number: Int) -> String {
    let templates: [String: String] = [
        "new_job_starting": "As you begin new professional endeavors, Number \(number) provides {core} for navigating workplace dynamics with confidence and authenticity.",
        "relationship_beginning": "In the early stages of connection, Number \(number) offers {core} for building authentic intimacy and understanding with your partner.",
        "home_moving": "During transitions of place and space, Number \(number) facilitates {core} for creating sanctuary and belonging in your new environment.",
        "creative_project_launch": "As creative visions seek manifestation, Number \(number) channels {core} through artistic expression and innovative thinking."
    ]

    return templates[situation] ?? templates["new_job_starting"]!
}

// MARK: - Helper Functions

func loadBaseInsights(for number: Int) throws -> [BaseInsight] {
    let currentDir = FileManager.default.currentDirectoryPath
    let filePath = "\(currentDir)/KASPERMLXRuntimeBundle/RichNumberMeanings/\(number)_rich.json"

    guard let data = FileManager.default.contents(atPath: filePath) else {
        throw NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not find \(number)_rich.json"])
    }

    let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
    let behavioralInsights = json["behavioral_insights"] as! [[String: Any]]

    return behavioralInsights.map { dict in
        BaseInsight(
            category: dict["category"] as! String,
            insight: dict["insight"] as! String,
            intensity: dict["intensity"] as! Double,
            triggers: dict["triggers"] as! [String],
            supports: dict["supports"] as! [String],
            challenges: dict["challenges"] as! [String]
        )
    }
}

func getArchetype(for number: Int) -> NumberArchetype {
    let archetypes: [Int: NumberArchetype] = [
        1: NumberArchetype(essence: "Pure initiating force, independence, leadership", keywords: ["leadership", "independence", "pioneer"], challenges: ["impatience", "ego"], opportunities: ["innovation", "breakthrough"]),
        2: NumberArchetype(essence: "Cooperation, harmony, partnership", keywords: ["cooperation", "harmony", "partnership"], challenges: ["codependency", "indecision"], opportunities: ["collaboration", "peacemaking"]),
        3: NumberArchetype(essence: "Creative expression, communication, joy", keywords: ["creativity", "expression", "communication"], challenges: ["scattered energy", "superficiality"], opportunities: ["artistic creation", "inspiration"]),
        4: NumberArchetype(essence: "Foundation, stability, practical manifestation", keywords: ["stability", "foundation", "practical"], challenges: ["rigidity", "perfectionism"], opportunities: ["building systems", "mastery"]),
        5: NumberArchetype(essence: "Adventure, freedom, change, experience", keywords: ["adventure", "freedom", "change"], challenges: ["restlessness", "instability"], opportunities: ["exploration", "variety"]),
        6: NumberArchetype(essence: "Nurturing, responsibility, home, family", keywords: ["nurturing", "responsibility", "home"], challenges: ["codependency", "martyrdom"], opportunities: ["healing others", "service"]),
        7: NumberArchetype(essence: "Spiritual wisdom, introspection, analysis", keywords: ["spiritual", "wisdom", "introspection"], challenges: ["isolation", "skepticism"], opportunities: ["spiritual growth", "wisdom"]),
        8: NumberArchetype(essence: "Material mastery, power, achievement", keywords: ["power", "achievement", "material"], challenges: ["materialism", "power abuse"], opportunities: ["business success", "leadership"]),
        9: NumberArchetype(essence: "Universal compassion, completion, humanitarian", keywords: ["universal", "compassion", "completion"], challenges: ["martyrdom", "emotional intensity"], opportunities: ["humanitarian service", "wisdom"])
    ]

    let masterNumbers: [Int: NumberArchetype] = [
        11: NumberArchetype(essence: "Spiritual illumination, intuitive mastery", keywords: ["illumination", "intuition", "visionary"], challenges: ["nervous tension", "extremism"], opportunities: ["spiritual teaching", "inspiration"]),
        22: NumberArchetype(essence: "Master builder, practical visionary", keywords: ["master builder", "visionary", "manifestation"], challenges: ["overwhelming responsibility", "pressure"], opportunities: ["major achievements", "lasting impact"]),
        33: NumberArchetype(essence: "Master teacher, compassionate service", keywords: ["master teacher", "compassion", "healing"], challenges: ["emotional burden", "sacrifice"], opportunities: ["healing mastery", "wisdom sharing"]),
        44: NumberArchetype(essence: "Master healer, material-spiritual bridge", keywords: ["master healer", "bridge", "practical"], challenges: ["overwhelming responsibility", "burnout"], opportunities: ["healing mastery", "bridge building"])
    ]

    return masterNumbers[number] ?? archetypes[number] ?? archetypes[1]!
}

func extractCore(from insight: String) -> String {
    if insight.contains("**") {
        let components = insight.components(separatedBy: "**")
        if components.count >= 2 {
            return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    let sentences = insight.components(separatedBy: ". ")
    return sentences.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "spiritual growth"
}

func calculateQuality(_ insight: String, number: Int, archetype: NumberArchetype) -> Double {
    var score = 0.5  // Base score to avoid 0
    let lowercased = insight.lowercased()

    // Length check
    let wordCount = insight.split(separator: " ").count
    if wordCount >= 20 && wordCount <= 100 {
        score += 0.2
    } else if wordCount >= 10 {
        score += 0.1
    }

    // Number reference
    if lowercased.contains("number \(number)") {
        score += 0.15
    }

    // Archetype keywords
    for keyword in archetype.keywords {
        if lowercased.contains(keyword) {
            score += 0.05
        }
    }

    // Spiritual language
    let spiritualWords = ["spiritual", "consciousness", "divine", "sacred", "wisdom", "energy"]
    for word in spiritualWords {
        if lowercased.contains(word) {
            score += 0.03
        }
    }

    // Ensure valid range
    let finalScore = max(0.5, min(score, 1.0))

    // Verify not NaN
    if finalScore.isNaN || finalScore.isInfinite {
        return 0.75  // Fallback
    }

    return finalScore
}

func saveMultipliedFile(for number: Int, insights: [MultipliedInsight]) async throws {
    let currentDir = FileManager.default.currentDirectoryPath
    let outputPath = "\(currentDir)/KASPERMLXRuntimeBundle/RichNumberMeanings/\(number)_rich_multiplied.json"

    // Create the multiplied content structure
    var multipliedDict: [String: Any] = [
        "number": number,
        "title": "Number \(number): Enhanced Insights (Multiplied)",
        "source": "multiplication_agents",
        "persona": "MultiPersona",
        "behavioral_category": "expanded_insights",
        "intensity_scoring": [
            "min_range": 0.6,
            "max_range": 1.0,
            "note": "Multiplied insights spanning full intensity spectrum"
        ]
    ]

    // Convert insights to JSON format
    let behavioralInsights = insights.map { insight in
        [
            "category": insight.category,
            "insight": insight.insight,
            "intensity": insight.intensity,
            "triggers": insight.triggers,
            "supports": insight.supports,
            "challenges": insight.challenges
        ] as [String: Any]
    }

    multipliedDict["behavioral_insights"] = behavioralInsights

    // Calculate safe average quality
    let totalQuality = insights.reduce(0.0) { $0 + $1.qualityScore }
    let averageQuality = insights.count > 0 ? totalQuality / Double(insights.count) : 0.75
    let safeAverageQuality = averageQuality.isNaN ? 0.75 : max(0.5, min(1.0, averageQuality))

    // Add metadata
    multipliedDict["meta"] = [
        "type": "multiplied",
        "generation_date": ISO8601DateFormatter().string(from: Date()),
        "total_insights": insights.count,
        "average_quality": safeAverageQuality
    ]

    // Write to file
    let jsonData = try JSONSerialization.data(withJSONObject: multipliedDict, options: [.prettyPrinted])
    FileManager.default.createFile(atPath: outputPath, contents: jsonData, attributes: nil)
}

// MARK: - Data Structures

struct BaseInsight {
    let category: String
    let insight: String
    let intensity: Double
    let triggers: [String]
    let supports: [String]
    let challenges: [String]
}

struct MultipliedInsight {
    let category: String
    let insight: String
    let intensity: Double
    let triggers: [String]
    let supports: [String]
    let challenges: [String]
    let qualityScore: Double
}

struct NumberArchetype {
    let essence: String
    let keywords: [String]
    let challenges: [String]
    let opportunities: [String]
}

// MARK: - Main Execution

Task {
    do {
        try await deployMultiplicationAgents()
        exit(0)
    } catch {
        print("❌ Deployment failed: \(error)")
        exit(1)
    }
}

// Keep script running until Task completes
RunLoop.main.run()
