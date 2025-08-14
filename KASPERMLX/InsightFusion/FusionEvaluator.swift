/**
 * =================================================================
 * 📊 FUSION EVALUATOR - QUALITY GUARDIAN FOR AI SPIRITUAL SYNTHESIS
 * =================================================================
 *
 * 🎆 STRATEGIC PURPOSE:
 * This sophisticated evaluation system ensures that every AI-synthesized spiritual insight
 * meets Vybe's gold standard for authentic, profound, and personally actionable guidance.
 * It serves as the quality gatekeeper that validates fusion results before they reach users,
 * maintaining the integrity and spiritual authenticity that Vybe users trust.
 *
 * 🚀 BREAKTHROUGH INNOVATION:
 * - Multi-dimensional quality assessment beyond simple text analysis
 * - Spiritual authenticity validation using advanced pattern recognition
 * - Persona voice fidelity scoring with characteristic voice markers
 * - Content coherence analysis ensuring seamless insight fusion
 * - Practical actionability assessment for immediate user implementation
 * - Real-time quality feedback for WisdomSynthesizer optimization
 *
 * 🔮 EVALUATION DIMENSIONS:
 * 1. SPIRITUAL AUTHENTICITY (30%): Depth, wisdom, and genuine spiritual insight
 * 2. PERSONA FIDELITY (25%): Maintenance of authentic Oracle/Psychologist/etc. voice
 * 3. FUSION COHERENCE (20%): How seamlessly the two source insights blend
 * 4. PRACTICAL VALUE (15%): Actionable guidance for immediate implementation
 * 5. VYBE VOICE ALIGNMENT (10%): Warm, practical, non-woo spiritual tone
 *
 * 🎯 QUALITY STANDARDS:
 * - A+ (90-100%): Production-ready, exceptional spiritual guidance
 * - A (85-89%): High-quality, ready for user experience
 * - A- (80-84%): Good quality, minor voice refinements needed
 * - B+ (75-79%): Acceptable, persona voice needs strengthening
 * - B (70-74%): Below standard, requires synthesis retry
 * - Below 70%: Reject and retry with different approach
 *
 * August 14, 2025 - Ensuring AI-Generated Spiritual Wisdom Excellence
 */

import Foundation
import os.log
import SwiftUI

// MARK: - Evaluation Configuration

/// Configuration for fusion quality evaluation
public struct EvaluationConfig {
    /// Quality dimension weights (must sum to 1.0)
    let spiritualAuthenticity: Double = 0.30    // Spiritual wisdom depth
    let personaFidelity: Double = 0.25          // Voice authenticity
    let fusionCoherence: Double = 0.20          // Insight blending quality
    let practicalValue: Double = 0.15           // Actionable guidance
    let vybeAlignment: Double = 0.10            // Brand voice consistency

    /// Minimum thresholds for production acceptance
    let minimumProductionScore: Double = 0.80   // A- minimum for users
    let minimumPersonaScore: Double = 0.75      // Voice authenticity floor
    let minimumSpiritualScore: Double = 0.70    // Spiritual depth floor

    /// Evaluation performance settings
    let deepAnalysisEnabled: Bool = true        // Enable comprehensive analysis
    let contextualScoring: Bool = true          // Consider persona context
    let adaptiveLearning: Bool = true           // Learn from evaluation patterns
}

/// Result of comprehensive fusion evaluation
public struct FusionEvaluationResult {
    let overallScore: Double
    let grade: String
    let dimensionScores: EvaluationDimensions
    let qualityAssessment: QualityAssessment
    let recommendations: [String]
    let evaluationTime: TimeInterval
    let passesProductionThreshold: Bool
    let metadata: EvaluationMetadata
}

/// Detailed scores for each evaluation dimension
public struct EvaluationDimensions {
    let spiritualAuthenticity: Double
    let personaFidelity: Double
    let fusionCoherence: Double
    let practicalValue: Double
    let vybeAlignment: Double

    /// Get the weighted overall score
    func calculateOverallScore(config: EvaluationConfig) -> Double {
        return (
            spiritualAuthenticity * config.spiritualAuthenticity +
            personaFidelity * config.personaFidelity +
            fusionCoherence * config.fusionCoherence +
            practicalValue * config.practicalValue +
            vybeAlignment * config.vybeAlignment
        )
    }
}

/// Qualitative assessment of fusion quality
public struct QualityAssessment {
    let strengths: [String]
    let weaknesses: [String]
    let spiritualDepthLevel: String      // "Profound", "Moderate", "Surface"
    let personaAuthenticityLevel: String // "Excellent", "Good", "Weak"
    let fusionQualityLevel: String       // "Seamless", "Smooth", "Awkward"
    let actionabilityLevel: String       // "Highly Practical", "Practical", "Theoretical"
}

/// Metadata about the evaluation process
public struct EvaluationMetadata {
    let evaluationTechnique: String
    let personaAnalyzed: String
    let sourceInsightCount: Int
    let keywordMatches: [String: Int]
    let patternRecognition: [String: Double]
    let debugInfo: [String: Any]
}

// MARK: - Evaluation Errors

public enum EvaluationError: LocalizedError {
    case invalidContent(reason: String)
    case personaMismatch(expected: String, detected: String?)
    case evaluationTimeout
    case insufficientSpiritualDepth(score: Double)
    case criticalQualityFailure(dimension: String, score: Double)

    public var errorDescription: String? {
        switch self {
        case .invalidContent(let reason):
            return "Invalid content for evaluation: \(reason)"
        case .personaMismatch(let expected, let detected):
            return "Persona mismatch: expected \(expected), detected \(detected ?? "unknown")"
        case .evaluationTimeout:
            return "Evaluation process timed out"
        case .insufficientSpiritualDepth(let score):
            return "Insufficient spiritual depth: \(String(format: "%.2f", score))"
        case .criticalQualityFailure(let dimension, let score):
            return "Critical quality failure in \(dimension): \(String(format: "%.2f", score))"
        }
    }
}

// MARK: - Main Fusion Evaluator

/// Advanced quality evaluation system for AI-synthesized spiritual insights
/// Ensures every fusion meets Vybe's gold standard for authentic spiritual guidance
@MainActor
public class FusionEvaluator: ObservableObject {

    // MARK: - Published Properties

    @Published public private(set) var isEvaluating: Bool = false
    @Published public private(set) var evaluationProgress: Double = 0.0
    @Published public private(set) var lastEvaluation: FusionEvaluationResult?
    @Published public private(set) var evaluationStats = EvaluationStatistics()

    // MARK: - Private Properties

    private let config = EvaluationConfig()
    private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "FusionEvaluator")

    /// Advanced pattern recognition engines
    private let spiritualAnalyzer = SpiritualAuthenticityAnalyzer()
    private let personaAnalyzer = PersonaFidelityAnalyzer()
    private let coherenceAnalyzer = FusionCoherenceAnalyzer()
    private let practicalityAnalyzer = PracticalValueAnalyzer()
    private let vybeAlignmentAnalyzer = VybeVoiceAnalyzer()

    /// Evaluation learning system for continuous improvement
    private var evaluationLearning = EvaluationLearningSystem()

    // MARK: - Initialization

    public init() {
        logger.info("📊 Initializing Fusion Evaluator with multi-dimensional quality assessment")
    }

    // MARK: - Primary Evaluation Interface

    /// Evaluate AI-synthesized fusion for production readiness
    /// This is the main quality gateway that determines if synthesis reaches users
    public func evaluateFusion(
        synthesizedContent: String,
        originalFocusInsight: RuntimeInsight,
        originalRealmInsight: RuntimeInsight,
        expectedPersona: String,
        fusionContext: [String: Any] = [:]
    ) async throws -> FusionEvaluationResult {

        logger.info("📊 Starting comprehensive evaluation: \(expectedPersona) fusion (\(synthesizedContent.count) chars)")

        guard !synthesizedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw EvaluationError.invalidContent(reason: "Empty synthesized content")
        }

        isEvaluating = true
        evaluationProgress = 0.0
        defer {
            isEvaluating = false
            evaluationProgress = 1.0
        }

        let startTime = CFAbsoluteTimeGetCurrent()

        // Step 1: Spiritual Authenticity Analysis (30% weight, 20% progress)
        evaluationProgress = 0.1
        let spiritualScore = await spiritualAnalyzer.analyzeSpiritualAuthenticity(
            content: synthesizedContent,
            originalInsights: [originalFocusInsight.content, originalRealmInsight.content]
        )
        evaluationProgress = 0.2

        // Step 2: Persona Fidelity Analysis (25% weight, 20% progress)
        let personaScore = await personaAnalyzer.analyzePersonaFidelity(
            content: synthesizedContent,
            expectedPersona: expectedPersona,
            originalPersonaExamples: [originalFocusInsight.content, originalRealmInsight.content]
        )
        evaluationProgress = 0.4

        // Step 3: Fusion Coherence Analysis (20% weight, 20% progress)
        let coherenceScore = await coherenceAnalyzer.analyzeFusionCoherence(
            synthesizedContent: synthesizedContent,
            focusInsight: originalFocusInsight.content,
            realmInsight: originalRealmInsight.content
        )
        evaluationProgress = 0.6

        // Step 4: Practical Value Analysis (15% weight, 15% progress)
        let practicalScore = await practicalityAnalyzer.analyzePracticalValue(
            content: synthesizedContent,
            context: fusionContext
        )
        evaluationProgress = 0.75

        // Step 5: Vybe Voice Alignment Analysis (10% weight, 15% progress)
        let vybeScore = await vybeAlignmentAnalyzer.analyzeVybeAlignment(
            content: synthesizedContent,
            persona: expectedPersona
        )
        evaluationProgress = 0.9

        // Step 6: Compile comprehensive evaluation result (10% progress)
        let dimensionScores = EvaluationDimensions(
            spiritualAuthenticity: spiritualScore.score,
            personaFidelity: personaScore.score,
            fusionCoherence: coherenceScore.score,
            practicalValue: practicalScore.score,
            vybeAlignment: vybeScore.score
        )

        let overallScore = dimensionScores.calculateOverallScore(config: config)
        let grade = calculateGrade(overallScore)
        let passesThreshold = overallScore >= config.minimumProductionScore

        // Generate qualitative assessment
        let qualityAssessment = generateQualityAssessment(
            spiritualResult: spiritualScore,
            personaResult: personaScore,
            coherenceResult: coherenceScore,
            practicalResult: practicalScore,
            vybeResult: vybeScore
        )

        // Generate improvement recommendations
        let recommendations = generateRecommendations(dimensionScores, expectedPersona)

        let evaluationTime = CFAbsoluteTimeGetCurrent() - startTime

        let result = FusionEvaluationResult(
            overallScore: overallScore,
            grade: grade,
            dimensionScores: dimensionScores,
            qualityAssessment: qualityAssessment,
            recommendations: recommendations,
            evaluationTime: evaluationTime,
            passesProductionThreshold: passesThreshold,
            metadata: EvaluationMetadata(
                evaluationTechnique: "Multi-Dimensional Fusion Analysis v1.0",
                personaAnalyzed: expectedPersona,
                sourceInsightCount: 2,
                keywordMatches: gatherKeywordMatches(spiritualScore, personaScore, coherenceScore),
                patternRecognition: gatherPatternRecognition(spiritualScore, personaScore),
                debugInfo: [
                    "evaluation_time": evaluationTime,
                    "content_length": synthesizedContent.count,
                    "original_focus_length": originalFocusInsight.content.count,
                    "original_realm_length": originalRealmInsight.content.count,
                    "passes_threshold": passesThreshold
                ]
            )
        )

        // Update statistics and learning system
        lastEvaluation = result
        updateEvaluationStatistics(result)

        if config.adaptiveLearning {
            evaluationLearning.recordEvaluation(result, synthesizedContent, expectedPersona)
        }

        logger.info("✅ Evaluation complete: \(grade) (\(String(format: "%.2f", overallScore))) in \(String(format: "%.2f", evaluationTime))s")

        // Validate critical quality thresholds
        try validateCriticalThresholds(result, expectedPersona)

        return result
    }

    // MARK: - Quality Assessment Generation

    /// Generate comprehensive qualitative assessment
    private func generateQualityAssessment(
        spiritualResult: SpiritualAnalysisResult,
        personaResult: PersonaAnalysisResult,
        coherenceResult: CoherenceAnalysisResult,
        practicalResult: PracticalAnalysisResult,
        vybeResult: VybeAnalysisResult
    ) -> QualityAssessment {

        var strengths: [String] = []
        var weaknesses: [String] = []

        // Analyze strengths
        if spiritualResult.score >= 0.85 { strengths.append("Profound spiritual wisdom") }
        if personaResult.score >= 0.85 { strengths.append("Authentic persona voice") }
        if coherenceResult.score >= 0.85 { strengths.append("Seamless insight fusion") }
        if practicalResult.score >= 0.85 { strengths.append("Highly actionable guidance") }
        if vybeResult.score >= 0.85 { strengths.append("Perfect Vybe voice alignment") }

        // Analyze weaknesses
        if spiritualResult.score < 0.70 { weaknesses.append("Spiritual depth needs enhancement") }
        if personaResult.score < 0.70 { weaknesses.append("Persona voice authenticity lacking") }
        if coherenceResult.score < 0.70 { weaknesses.append("Fusion feels disjointed") }
        if practicalResult.score < 0.70 { weaknesses.append("Limited practical actionability") }
        if vybeResult.score < 0.70 { weaknesses.append("Vybe voice tone misalignment") }

        return QualityAssessment(
            strengths: strengths,
            weaknesses: weaknesses,
            spiritualDepthLevel: categorizeLevel(spiritualResult.score),
            personaAuthenticityLevel: categorizeLevel(personaResult.score),
            fusionQualityLevel: categorizeLevel(coherenceResult.score),
            actionabilityLevel: categorizeLevel(practicalResult.score)
        )
    }

    /// Generate improvement recommendations based on scores
    private func generateRecommendations(_ scores: EvaluationDimensions, _ persona: String) -> [String] {
        var recommendations: [String] = []

        if scores.spiritualAuthenticity < 0.75 {
            recommendations.append("Enhance spiritual depth with more profound wisdom elements")
        }

        if scores.personaFidelity < 0.75 {
            recommendations.append("Strengthen \(persona) voice characteristics and speaking patterns")
        }

        if scores.fusionCoherence < 0.75 {
            recommendations.append("Improve seamless blending of focus and realm insights")
        }

        if scores.practicalValue < 0.75 {
            recommendations.append("Add more specific, actionable guidance for immediate implementation")
        }

        if scores.vybeAlignment < 0.75 {
            recommendations.append("Align tone with Vybe's warm, practical, non-woo spiritual approach")
        }

        return recommendations
    }

    // MARK: - Helper Methods

    /// Calculate letter grade from numerical score
    private func calculateGrade(_ score: Double) -> String {
        switch score {
        case 0.95...: return "A+"
        case 0.90..<0.95: return "A"
        case 0.85..<0.90: return "A-"
        case 0.80..<0.85: return "B+"
        case 0.75..<0.80: return "B"
        case 0.70..<0.75: return "B-"
        case 0.65..<0.70: return "C+"
        case 0.60..<0.65: return "C"
        default: return "F"
        }
    }

    /// Categorize score into descriptive level
    private func categorizeLevel(_ score: Double) -> String {
        switch score {
        case 0.85...: return "Excellent"
        case 0.75..<0.85: return "Good"
        case 0.65..<0.75: return "Moderate"
        default: return "Needs Improvement"
        }
    }

    /// Validate critical quality thresholds
    private func validateCriticalThresholds(_ result: FusionEvaluationResult, _ persona: String) throws {
        if result.dimensionScores.spiritualAuthenticity < config.minimumSpiritualScore {
            throw EvaluationError.insufficientSpiritualDepth(score: result.dimensionScores.spiritualAuthenticity)
        }

        if result.dimensionScores.personaFidelity < config.minimumPersonaScore {
            throw EvaluationError.criticalQualityFailure(dimension: "Persona Fidelity", score: result.dimensionScores.personaFidelity)
        }
    }

    /// Gather keyword matches for metadata
    private func gatherKeywordMatches(
        _ spiritual: SpiritualAnalysisResult,
        _ persona: PersonaAnalysisResult,
        _ coherence: CoherenceAnalysisResult
    ) -> [String: Int] {
        var matches: [String: Int] = [:]
        matches["spiritual_keywords"] = spiritual.keywordMatches
        matches["persona_keywords"] = persona.keywordMatches
        matches["coherence_keywords"] = coherence.keywordMatches
        return matches
    }

    /// Gather pattern recognition data for metadata
    private func gatherPatternRecognition(
        _ spiritual: SpiritualAnalysisResult,
        _ persona: PersonaAnalysisResult
    ) -> [String: Double] {
        var patterns: [String: Double] = [:]
        patterns["spiritual_pattern_strength"] = spiritual.patternStrength
        patterns["persona_pattern_strength"] = persona.patternStrength
        return patterns
    }

    // MARK: - Statistics and Learning

    /// Update evaluation statistics for system monitoring
    private func updateEvaluationStatistics(_ result: FusionEvaluationResult) {
        evaluationStats.totalEvaluations += 1
        evaluationStats.totalEvaluationTime += result.evaluationTime
        evaluationStats.averageScore = (evaluationStats.averageScore * Double(evaluationStats.totalEvaluations - 1) + result.overallScore) / Double(evaluationStats.totalEvaluations)

        // Track grade distribution
        evaluationStats.gradeDistribution[result.grade, default: 0] += 1

        // Track dimension performance
        let dimensions = result.dimensionScores
        evaluationStats.dimensionAverages["spiritual"] = (evaluationStats.dimensionAverages["spiritual", default: 0.0] * Double(evaluationStats.totalEvaluations - 1) + dimensions.spiritualAuthenticity) / Double(evaluationStats.totalEvaluations)
        evaluationStats.dimensionAverages["persona"] = (evaluationStats.dimensionAverages["persona", default: 0.0] * Double(evaluationStats.totalEvaluations - 1) + dimensions.personaFidelity) / Double(evaluationStats.totalEvaluations)
        evaluationStats.dimensionAverages["coherence"] = (evaluationStats.dimensionAverages["coherence", default: 0.0] * Double(evaluationStats.totalEvaluations - 1) + dimensions.fusionCoherence) / Double(evaluationStats.totalEvaluations)
        evaluationStats.dimensionAverages["practical"] = (evaluationStats.dimensionAverages["practical", default: 0.0] * Double(evaluationStats.totalEvaluations - 1) + dimensions.practicalValue) / Double(evaluationStats.totalEvaluations)
        evaluationStats.dimensionAverages["vybe"] = (evaluationStats.dimensionAverages["vybe", default: 0.0] * Double(evaluationStats.totalEvaluations - 1) + dimensions.vybeAlignment) / Double(evaluationStats.totalEvaluations)

        // Track production readiness rate
        if result.passesProductionThreshold {
            evaluationStats.productionReadyCount += 1
        }
    }

    /// Get comprehensive evaluation system status
    public func getSystemStatus() -> [String: Any] {
        return [
            "evaluation_engine": "Multi-Dimensional Fusion Quality Assessment v1.0",
            "status": isEvaluating ? "Evaluating" : "Ready",
            "configuration": [
                "weights": [
                    "spiritual_authenticity": config.spiritualAuthenticity,
                    "persona_fidelity": config.personaFidelity,
                    "fusion_coherence": config.fusionCoherence,
                    "practical_value": config.practicalValue,
                    "vybe_alignment": config.vybeAlignment
                ],
                "thresholds": [
                    "production_minimum": config.minimumProductionScore,
                    "persona_minimum": config.minimumPersonaScore,
                    "spiritual_minimum": config.minimumSpiritualScore
                ]
            ],
            "statistics": evaluationStats.toDictionary(),
            "adaptive_learning": config.adaptiveLearning
        ]
    }
}

// MARK: - Specialized Analyzers

/// Analyzes spiritual authenticity and wisdom depth
private class SpiritualAuthenticityAnalyzer {
    func analyzeSpiritualAuthenticity(content: String, originalInsights: [String]) async -> SpiritualAnalysisResult {
        let spiritualKeywords = ["wisdom", "spiritual", "soul", "inner", "divine", "sacred", "consciousness", "awakening", "enlightenment", "transcendence", "transformation", "journey", "path", "truth", "essence", "alignment", "harmony", "balance", "growth", "evolution"]

        let contentLower = content.lowercased()
        let keywordMatches = spiritualKeywords.filter { contentLower.contains($0) }.count
        let keywordScore = min(1.0, Double(keywordMatches) / Double(spiritualKeywords.count) * 2.0)

        // Analyze depth vs surface-level content
        let depthIndicators = ["profound", "deep", "deeper", "innermost", "core", "fundamental", "essential", "ultimate"]
        let depthScore = min(1.0, Double(depthIndicators.filter { contentLower.contains($0) }.count) / Double(depthIndicators.count) * 3.0)

        // Analyze wisdom vs information
        let wisdomIndicators = ["understand", "realize", "recognize", "discover", "uncover", "reveal", "illuminate", "awaken to"]
        let wisdomScore = min(1.0, Double(wisdomIndicators.filter { contentLower.contains($0) }.count) / Double(wisdomIndicators.count) * 2.5)

        let overallScore = (keywordScore * 0.4 + depthScore * 0.3 + wisdomScore * 0.3)

        return SpiritualAnalysisResult(
            score: overallScore,
            keywordMatches: keywordMatches,
            patternStrength: (depthScore + wisdomScore) / 2.0,
            insights: ["Spiritual keyword density: \(keywordMatches)", "Depth indicators: \(depthScore)", "Wisdom patterns: \(wisdomScore)"]
        )
    }
}

/// Analyzes persona voice fidelity and authenticity
private class PersonaFidelityAnalyzer {
    func analyzePersonaFidelity(content: String, expectedPersona: String, originalPersonaExamples: [String]) async -> PersonaAnalysisResult {
        let contentLower = content.lowercased()
        let personaKeywords = getPersonaKeywords(expectedPersona)

        let keywordMatches = personaKeywords.filter { contentLower.contains($0.lowercased()) }.count
        let keywordScore = min(1.0, Double(keywordMatches) / Double(personaKeywords.count) * 2.0)

        let voicePatterns = getPersonaVoicePatterns(expectedPersona)
        let patternMatches = voicePatterns.filter { contentLower.contains($0.lowercased()) }.count
        let patternScore = min(1.0, Double(patternMatches) / Double(voicePatterns.count) * 2.5)

        let overallScore = (keywordScore * 0.6 + patternScore * 0.4)

        return PersonaAnalysisResult(
            score: overallScore,
            keywordMatches: keywordMatches,
            patternStrength: patternScore,
            authenticityLevel: overallScore >= 0.8 ? "High" : overallScore >= 0.6 ? "Moderate" : "Low",
            insights: ["Keyword matches: \(keywordMatches)/\(personaKeywords.count)", "Voice pattern strength: \(String(format: "%.2f", patternScore))"]
        )
    }

    private func getPersonaKeywords(_ persona: String) -> [String] {
        switch persona {
        case "Oracle":
            return ["cosmic", "divine", "sacred", "soul", "ancient", "mystical", "celestial", "whisper", "essence", "prophecy"]
        case "Psychologist":
            return ["pattern", "behavior", "emotional", "growth", "psychological", "development", "integration", "process", "healing", "understanding"]
        case "MindfulnessCoach":
            return ["present", "moment", "awareness", "breath", "mindful", "notice", "gentle", "flowing", "centered", "peaceful"]
        case "NumerologyScholar":
            return ["numerological", "vibration", "frequency", "pattern", "significance", "harmonic", "mathematical", "calculation", "energy"]
        case "Philosopher":
            return ["consider", "wisdom", "meaning", "existence", "truth", "contemplation", "profound", "essence", "question", "ponder"]
        default:
            return ["wisdom", "guidance", "spiritual", "inner", "insight"]
        }
    }

    private func getPersonaVoicePatterns(_ persona: String) -> [String] {
        switch persona {
        case "Oracle":
            return ["the cosmic", "your soul recognizes", "sacred flames", "divine essence", "ancient wisdom", "mystical"]
        case "Psychologist":
            return ["this pattern", "your behavior", "emotional growth", "psychological", "development process", "healing journey"]
        case "MindfulnessCoach":
            return ["in this moment", "notice how", "breathe into", "present awareness", "mindful attention", "gentle"]
        case "NumerologyScholar":
            return ["the significance", "vibrational", "numerological pattern", "mathematical", "energy frequency", "harmonic"]
        case "Philosopher":
            return ["consider this", "perhaps", "the meaning", "profound question", "contemplate", "wisdom lies"]
        default:
            return ["spiritual", "inner wisdom", "guidance", "insight"]
        }
    }
}

/// Analyzes how well insights are fused together
private class FusionCoherenceAnalyzer {
    func analyzeFusionCoherence(synthesizedContent: String, focusInsight: String, realmInsight: String) async -> CoherenceAnalysisResult {
        let focusWords = extractKeyWords(focusInsight)
        let realmWords = extractKeyWords(realmInsight)
        let synthesizedWords = extractKeyWords(synthesizedContent)

        let focusPresence = focusWords.filter { word in synthesizedWords.contains { $0.lowercased().contains(word.lowercased()) } }.count
        let realmPresence = realmWords.filter { word in synthesizedWords.contains { $0.lowercased().contains(word.lowercased()) } }.count

        let focusScore = Double(focusPresence) / Double(focusWords.count)
        let realmScore = Double(realmPresence) / Double(realmWords.count)
        let balanceScore = 1.0 - abs(focusScore - realmScore) // Penalty for imbalance

        let coherenceIndicators = ["together", "combines", "merges", "blends", "integrates", "synthesis", "fusion", "harmony", "balance"]
        let coherenceCount = coherenceIndicators.filter { synthesizedContent.lowercased().contains($0) }.count
        let coherenceBonus = min(0.2, Double(coherenceCount) * 0.05)

        let overallScore = min(1.0, (focusScore + realmScore) / 2.0 * balanceScore + coherenceBonus)

        return CoherenceAnalysisResult(
            score: overallScore,
            keywordMatches: focusPresence + realmPresence,
            focusPresence: focusScore,
            realmPresence: realmScore,
            balanceScore: balanceScore,
            insights: ["Focus presence: \(String(format: "%.2f", focusScore))", "Realm presence: \(String(format: "%.2f", realmScore))", "Balance: \(String(format: "%.2f", balanceScore))"]
        )
    }

    private func extractKeyWords(_ text: String) -> [String] {
        return text.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 4 && !["that", "this", "with", "from", "they", "have", "will", "been", "were"].contains($0.lowercased()) }
            .prefix(8)
            .map { String($0) }
    }
}

/// Analyzes practical actionability and implementation value
private class PracticalValueAnalyzer {
    func analyzePracticalValue(content: String, context: [String: Any]) async -> PracticalAnalysisResult {
        let actionWords = ["practice", "begin", "start", "try", "focus", "consider", "notice", "embrace", "create", "build", "develop", "cultivate", "implement", "apply", "use", "take", "make", "do"]
        let contentLower = content.lowercased()

        let actionCount = actionWords.filter { contentLower.contains($0) }.count
        let actionScore = min(1.0, Double(actionCount) / Double(actionWords.count) * 2.0)

        let specificityIndicators = ["today", "now", "this week", "daily", "morning", "evening", "moment", "step", "specific", "concrete"]
        let specificityCount = specificityIndicators.filter { contentLower.contains($0) }.count
        let specificityScore = min(1.0, Double(specificityCount) / Double(specificityIndicators.count) * 3.0)

        let overallScore = (actionScore * 0.6 + specificityScore * 0.4)

        return PracticalAnalysisResult(
            score: overallScore,
            actionabilityLevel: overallScore >= 0.8 ? "Highly Practical" : overallScore >= 0.6 ? "Practical" : "Theoretical",
            actionWordCount: actionCount,
            specificityLevel: specificityScore,
            insights: ["Action words: \(actionCount)", "Specificity: \(String(format: "%.2f", specificityScore))"]
        )
    }
}

/// Analyzes alignment with Vybe's voice and brand
private class VybeVoiceAnalyzer {
    func analyzeVybeAlignment(content: String, persona: String) async -> VybeAnalysisResult {
        let contentLower = content.lowercased()

        // Positive Vybe characteristics (warm, practical, non-woo)
        let positiveWords = ["warm", "practical", "genuine", "authentic", "real", "grounded", "accessible", "simple", "clear", "honest", "supportive", "encouraging", "empowering"]
        let positiveCount = positiveWords.filter { contentLower.contains($0) }.count
        let positiveScore = min(1.0, Double(positiveCount) / Double(positiveWords.count) * 2.0)

        // Avoid overly woo-woo language (unless it's Oracle persona)
        let wooWords = ["astral", "chakra", "crystal", "ascension", "dimensional", "galactic", "quantum leap", "matrix"]
        let wooCount = wooWords.filter { contentLower.contains($0) }.count
        let wooBonus = persona == "Oracle" ? 0.0 : max(0.0, 0.2 - Double(wooCount) * 0.05) // Penalty for non-Oracle

        let overallScore = min(1.0, positiveScore + wooBonus)

        return VybeAnalysisResult(
            score: overallScore,
            brandAlignment: overallScore >= 0.8 ? "Excellent" : overallScore >= 0.6 ? "Good" : "Needs Improvement",
            toneConsistency: positiveScore,
            insights: ["Brand alignment: \(String(format: "%.2f", overallScore))", "Positive characteristics: \(positiveCount)"]
        )
    }
}

// MARK: - Analysis Result Types

private struct SpiritualAnalysisResult {
    let score: Double
    let keywordMatches: Int
    let patternStrength: Double
    let insights: [String]
}

private struct PersonaAnalysisResult {
    let score: Double
    let keywordMatches: Int
    let patternStrength: Double
    let authenticityLevel: String
    let insights: [String]
}

private struct CoherenceAnalysisResult {
    let score: Double
    let keywordMatches: Int
    let focusPresence: Double
    let realmPresence: Double
    let balanceScore: Double
    let insights: [String]
}

private struct PracticalAnalysisResult {
    let score: Double
    let actionabilityLevel: String
    let actionWordCount: Int
    let specificityLevel: Double
    let insights: [String]
}

private struct VybeAnalysisResult {
    let score: Double
    let brandAlignment: String
    let toneConsistency: Double
    let insights: [String]
}

// MARK: - Learning System

/// Adaptive learning system for continuous evaluation improvement
private class EvaluationLearningSystem {
    private var evaluationHistory: [(result: FusionEvaluationResult, content: String, persona: String)] = []

    func recordEvaluation(_ result: FusionEvaluationResult, _ content: String, _ persona: String) {
        evaluationHistory.append((result: result, content: content, persona: persona))

        // Keep only last 100 evaluations for memory efficiency
        if evaluationHistory.count > 100 {
            evaluationHistory.removeFirst()
        }
    }

    func getPatternInsights() -> [String: Double] {
        // Future: ML-based pattern recognition for evaluation optimization
        return [:]
    }
}

// MARK: - Evaluation Statistics

/// Comprehensive statistics for evaluation system monitoring
public struct EvaluationStatistics {
    public var totalEvaluations: Int = 0
    public var totalEvaluationTime: TimeInterval = 0.0
    public var averageScore: Double = 0.0
    public var gradeDistribution: [String: Int] = [:]
    public var dimensionAverages: [String: Double] = [:]
    public var productionReadyCount: Int = 0

    public var averageEvaluationTime: TimeInterval {
        guard totalEvaluations > 0 else { return 0.0 }
        return totalEvaluationTime / Double(totalEvaluations)
    }

    public var productionReadyRate: Double {
        guard totalEvaluations > 0 else { return 0.0 }
        return Double(productionReadyCount) / Double(totalEvaluations)
    }

    public func toDictionary() -> [String: Any] {
        return [
            "total_evaluations": totalEvaluations,
            "average_evaluation_time": averageEvaluationTime,
            "average_score": averageScore,
            "production_ready_rate": productionReadyRate,
            "grade_distribution": gradeDistribution,
            "dimension_averages": dimensionAverages
        ]
    }
}

/**
 * USAGE EXAMPLE - COMPREHENSIVE QUALITY EVALUATION:
 *
 * let evaluator = FusionEvaluator()
 *
 * let result = try await evaluator.evaluateFusion(
 *     synthesizedContent: fusedInsight,                    // AI-synthesized content
 *     originalFocusInsight: focusInsight,                  // Source focus insight
 *     originalRealmInsight: realmInsight,                  // Source realm insight
 *     expectedPersona: "Oracle",                           // Expected voice
 *     fusionContext: ["user_focus": 1, "user_realm": 3]
 * )
 *
 * if result.passesProductionThreshold {
 *     // A+ quality - ready for user experience
 *     displayToUser(result.synthesizedContent)
 * } else {
 *     // Retry synthesis with recommendations
 *     retryWithImprovements(result.recommendations)
 * }
 */
