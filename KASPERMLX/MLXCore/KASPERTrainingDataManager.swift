/*
 * ========================================
 * 🔮 KASPER MLX TRAINING DATA MANAGER
 * ========================================
 * 
 * REVOLUTIONARY PURPOSE:
 * Ingests and processes thousands of spiritual insights from Grok 4
 * to transform KASPER MLX from template-driven to true learning AI.
 * This is the bridge between massive spiritual corpus and Apple MLX.
 * 
 * TRAINING SCALE:
 * • 9 Core Numbers (1-9) × 110 insights each = 1,000+ base insights
 * • Master Numbers (11, 22, 33, 44) with specialized content
 * • Contextual variations for mood, time, and situation
 * • Target: 10,000+ insights for world-class spiritual AI
 * 
 * DATA PIPELINE:
 * Grok 4 Generation → JSON Validation → Quality Scoring → Apple MLX Training
 * 
 * INTEGRATION POINTS:
 * • KASPERMLXEngine: Seamless replacement of template system
 * • Feedback Loop: Continuous learning from user interactions
 * • Performance: Maintains <100ms insight generation speed
 */

import Foundation
import SwiftUI

/**
 * Claude: Core data structures for spiritual insight training
 * These match the JSON schema exactly for seamless data flow
 */

/// Individual spiritual insight with complete metadata for training
struct TrainingSpiritualInsight: Codable, Identifiable {
    let id: String
    let number: Int
    let category: TrainingInsightCategory
    let content: String
    let confidence: Double
    let themes: [String]
    let astrologicalContext: AstrologicalContext
    let metadata: TrainingInsightMetadata
}

/// Training batch containing multiple insights for a number
struct TrainingBatch: Codable {
    let batchId: String
    let number: Int
    let totalInsights: Int
    let categories: CategoryCounts
    let archetype: String
    let coreThemes: [String]
    let planetaryRuler: String
    let astrologicalSign: String
    let element: String
    let insights: [TrainingSpiritualInsight]
}

/// Category breakdown for training batch
struct CategoryCounts: Codable {
    let insights: Int
    let reflections: Int
    let contemplations: Int
    let manifestations: Int
}

/// Astrological context for spiritual authenticity
struct AstrologicalContext: Codable {
    let planet: String
    let sign: String
    let element: String
    let modality: String?
}

/// Comprehensive metadata for quality assurance
struct TrainingInsightMetadata: Codable {
    let created: Date
    let source: TrainingInsightSource
    let validated: Bool
    let qualityScore: Double
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case created, source, validated, qualityScore, tags
    }
}

/// Source tracking for training pipeline
enum TrainingInsightSource: String, Codable, CaseIterable {
    case grok4Generation = "grok_4_generation"
    case humanCurated = "human_curated"
    case claudeGenerated = "claude_generated"
    case hybridCreation = "hybrid_creation"
}

/// Enhanced insight categories for comprehensive training
enum TrainingInsightCategory: String, Codable, CaseIterable {
    case insight = "insight"           // Intuitive messages and universal truths
    case reflection = "reflection"     // Self-inquiry questions 
    case contemplation = "contemplation" // Meditative thoughts and philosophy
    case manifestation = "manifestation" // Affirmations and empowerment
    
    var displayName: String {
        switch self {
        case .insight: return "Spiritual Insight"
        case .reflection: return "Self-Inquiry" 
        case .contemplation: return "Deep Contemplation"
        case .manifestation: return "Manifestation"
        }
    }
}

/// Context enhancement for personalized AI responses
struct ContextEnhancement: Codable {
    let userState: UserState?
    let timeContext: TimeContext?
    let situation: SituationContext?
    let personalization: PersonalizationData?
}

enum UserState: String, Codable, CaseIterable {
    case anxious, excited, reflective, motivated, confused, peaceful, restless, grateful
}

enum TimeContext: String, Codable, CaseIterable {
    case morning, afternoon, evening, lateNight = "late_night"
}

enum SituationContext: String, Codable, CaseIterable {
    case journalEntry = "journal_entry"
    case dailyCard = "daily_card"
    case crisisGuidance = "crisis_guidance"
    case celebration = "celebration"
    case meditation = "meditation"
    case decisionMaking = "decision_making"
}

struct PersonalizationData: Codable {
    let userFocusNumber: Int?
    let userRealmNumber: Int?
    let recentInteractions: [UserInteraction]?
}

enum UserInteraction: String, Codable, CaseIterable {
    case positiveFeedback = "positive_feedback"
    case negativeFeedback = "negative_feedback" 
    case requestedDeeperInsight = "requested_deeper_insight"
    case requestedPracticalGuidance = "requested_practical_guidance"
}

/**
 * Claude: KASPER MLX Training Data Manager
 * Processes massive spiritual insight corpus for Apple MLX training
 */
@MainActor
class KASPERTrainingDataManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isProcessing = false
    @Published var processingProgress: Double = 0.0
    @Published var loadedBatches: [TrainingBatch] = []
    @Published var trainingStats = TrainingStatistics()
    
    // MARK: - Core Properties
    
    /// JSON decoder configured for spiritual insight data
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    /// JSON encoder for processed training data
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()
    
    // MARK: - Training Statistics
    
    struct TrainingStatistics {
        var totalInsights = 0
        var byCategory: [TrainingInsightCategory: Int] = [:]
        var byNumber: [Int: Int] = [:]
        var averageQualityScore = 0.0
        var validatedCount = 0
        var sourceBreakdown: [TrainingInsightSource: Int] = [:]
    }
    
    // MARK: - Core Training Methods
    
    /**
     * Claude: Ingest massive training corpus from Grok 4 generated JSON files
     * Validates spiritual authenticity and prepares for Apple MLX training
     */
    func ingestTrainingCorpus(from jsonFiles: [URL]) async throws -> [TrainingBatch] {
        print("🔮 KASPER MLX: Starting training corpus ingestion...")
        
        isProcessing = true
        processingProgress = 0.0
        loadedBatches.removeAll()
        
        var allBatches: [TrainingBatch] = []
        let totalFiles = jsonFiles.count
        
        for (index, fileURL) in jsonFiles.enumerated() {
            do {
                let batch = try await processSingleBatch(from: fileURL)
                allBatches.append(batch)
                loadedBatches.append(batch)
                
                // Update progress
                processingProgress = Double(index + 1) / Double(totalFiles)
                print("🔮 KASPER MLX: Processed batch \(batch.batchId) - \(batch.totalInsights) insights")
                
            } catch {
                print("🔮 KASPER MLX: Failed to process \(fileURL.lastPathComponent): \(error)")
                // Continue processing other files
            }
        }
        
        // Update statistics
        await updateTrainingStatistics(from: allBatches)
        
        isProcessing = false
        print("🔮 KASPER MLX: Training corpus ingestion complete - \(trainingStats.totalInsights) total insights")
        
        return allBatches
    }
    
    /**
     * Claude: Process individual training batch with full validation
     */
    private func processSingleBatch(from fileURL: URL) async throws -> TrainingBatch {
        let data = try Data(contentsOf: fileURL)
        var batch = try decoder.decode(TrainingBatch.self, from: data)
        
        // Validate spiritual authenticity
        let validatedInsights = try await validateInsights(batch.insights)
        
        // Create new batch with validated insights
        batch = TrainingBatch(
            batchId: batch.batchId,
            number: batch.number,
            totalInsights: validatedInsights.count,
            categories: countCategories(in: validatedInsights),
            archetype: batch.archetype,
            coreThemes: batch.coreThemes,
            planetaryRuler: batch.planetaryRuler,
            astrologicalSign: batch.astrologicalSign,
            element: batch.element,
            insights: validatedInsights
        )
        
        return batch
    }
    
    /**
     * Claude: Validate spiritual insights for authenticity and quality
     */
    private func validateInsights(_ insights: [TrainingSpiritualInsight]) async throws -> [TrainingSpiritualInsight] {
        return insights.compactMap { insight in
            let validation = validateInsightQuality(insight)
            return validation.isValid ? insight : nil
        }
    }
    
    /**
     * Claude: Comprehensive validation of spiritual insight quality
     */
    func validateInsightQuality(_ insight: TrainingSpiritualInsight) -> ValidationResult {
        var score = 0.0
        var issues: [String] = []
        
        // 1. Numerological Accuracy (25 points)
        if isNumerologicallyValid(insight) {
            score += 25.0
        } else {
            issues.append("Numerological correspondences invalid")
        }
        
        // 2. Astrological Integrity (20 points)
        if isAstrologicallyValid(insight) {
            score += 20.0
        } else {
            issues.append("Astrological context incorrect")
        }
        
        // 3. Spiritual Depth (25 points)
        let depthScore = assessSpiritualDepth(insight.content)
        score += depthScore * 25.0
        if depthScore < 0.7 {
            issues.append("Insufficient spiritual depth")
        }
        
        // 4. Universal Appeal (15 points)
        let universalScore = assessUniversalAppeal(insight.content)
        score += universalScore * 15.0
        
        // 5. Safety & Support (15 points)
        if isPsychologicallySafe(insight.content) {
            score += 15.0
        } else {
            issues.append("Potentially harmful content")
        }
        
        return ValidationResult(
            isValid: score >= 75.0 && issues.isEmpty,
            score: score,
            issues: issues,
            confidence: insight.confidence
        )
    }
    
    // MARK: - Validation Helpers
    
    private func isNumerologicallyValid(_ insight: TrainingSpiritualInsight) -> Bool {
        // Validate number is in valid range
        guard (1...9).contains(insight.number) || [11, 22, 33, 44].contains(insight.number) else {
            return false
        }
        
        // Check themes align with number's traditional meanings
        let validThemes = getNumerologicalThemes(for: insight.number)
        return insight.themes.contains { validThemes.contains($0.lowercased()) }
    }
    
    private func isAstrologicallyValid(_ insight: TrainingSpiritualInsight) -> Bool {
        let context = insight.astrologicalContext
        
        // Validate planet-sign-element correspondence
        let validCorrespondences = getAstrologicalCorrespondences()
        
        guard let planetSigns = validCorrespondences[context.planet],
              planetSigns.contains(context.sign) else {
            return false
        }
        
        // Validate element correspondence
        let signElements = getSignElements()
        return signElements[context.sign] == context.element
    }
    
    private func assessSpiritualDepth(_ content: String) -> Double {
        // Assess wisdom, universality, and transformative potential
        let depthKeywords = ["wisdom", "truth", "sacred", "divine", "soul", "spirit", "consciousness", "awakening"]
        let superficialWords = ["just", "simply", "easy", "quick", "instant"]
        
        let depthCount = depthKeywords.reduce(0) { count, keyword in
            count + content.lowercased().components(separatedBy: keyword).count - 1
        }
        
        let superficialCount = superficialWords.reduce(0) { count, word in
            count + content.lowercased().components(separatedBy: word).count - 1
        }
        
        let baseScore = min(Double(depthCount) / 3.0, 1.0)
        let penalty = min(Double(superficialCount) / 2.0, 0.3)
        
        return max(baseScore - penalty, 0.0)
    }
    
    private func assessUniversalAppeal(_ content: String) -> Double {
        // Check for inclusive language and broad applicability
        let inclusiveWords = ["you", "we", "everyone", "all", "each", "every"]
        let exclusiveWords = ["must", "should", "only", "never", "always"]
        
        let inclusiveCount = inclusiveWords.reduce(0) { count, word in
            count + content.lowercased().components(separatedBy: word).count - 1
        }
        
        let exclusiveCount = exclusiveWords.reduce(0) { count, word in
            count + content.lowercased().components(separatedBy: word).count - 1
        }
        
        let baseScore = min(Double(inclusiveCount) / 2.0, 1.0)
        let penalty = min(Double(exclusiveCount) / 3.0, 0.4)
        
        return max(baseScore - penalty, 0.2) // Minimum 0.2 for basic appeal
    }
    
    private func isPsychologicallySafe(_ content: String) -> Bool {
        let harmfulWords = ["failure", "worthless", "hopeless", "doomed", "cursed", "punishment"]
        return !harmfulWords.contains { content.lowercased().contains($0) }
    }
    
    // MARK: - Helper Methods
    
    private func countCategories(in insights: [TrainingSpiritualInsight]) -> CategoryCounts {
        let counts = insights.reduce(into: [TrainingInsightCategory: Int]()) { counts, insight in
            counts[insight.category, default: 0] += 1
        }
        
        return CategoryCounts(
            insights: counts[.insight] ?? 0,
            reflections: counts[.reflection] ?? 0,
            contemplations: counts[.contemplation] ?? 0,
            manifestations: counts[.manifestation] ?? 0
        )
    }
    
    private func updateTrainingStatistics(from batches: [TrainingBatch]) async {
        let allInsights = batches.flatMap { $0.insights }
        
        trainingStats.totalInsights = allInsights.count
        trainingStats.validatedCount = allInsights.filter { $0.metadata.validated }.count
        trainingStats.averageQualityScore = allInsights.map { $0.metadata.qualityScore }.reduce(0, +) / Double(allInsights.count)
        
        // Category breakdown
        trainingStats.byCategory = allInsights.reduce(into: [:]) { counts, insight in
            counts[insight.category, default: 0] += 1
        }
        
        // Number breakdown
        trainingStats.byNumber = allInsights.reduce(into: [:]) { counts, insight in
            counts[insight.number, default: 0] += 1
        }
        
        // Source breakdown
        trainingStats.sourceBreakdown = allInsights.reduce(into: [:]) { counts, insight in
            counts[insight.metadata.source, default: 0] += 1
        }
    }
    
    // MARK: - Reference Data
    
    private func getNumerologicalThemes(for number: Int) -> [String] {
        switch number {
        case 1: return ["leadership", "independence", "innovation", "pioneering", "individuality"]
        case 2: return ["harmony", "cooperation", "partnership", "balance", "diplomacy"]
        case 3: return ["creativity", "communication", "expression", "joy", "optimism"]
        case 4: return ["stability", "foundation", "discipline", "structure", "reliability"]
        case 5: return ["freedom", "adventure", "change", "curiosity", "versatility"]
        case 6: return ["nurturing", "responsibility", "healing", "service", "compassion"]
        case 7: return ["spirituality", "wisdom", "introspection", "mystery", "analysis"]
        case 8: return ["ambition", "material", "power", "achievement", "organization"]
        case 9: return ["completion", "wisdom", "humanitarian", "universal", "transformation"]
        case 11: return ["intuition", "inspiration", "enlightenment", "psychic", "idealism"]
        case 22: return ["mastery", "building", "vision", "practical", "achievement"]
        case 33: return ["healing", "teaching", "compassion", "service", "guidance"]
        case 44: return ["mastery", "foundation", "discipline", "achievement", "legacy"]
        default: return []
        }
    }
    
    private func getAstrologicalCorrespondences() -> [String: [String]] {
        return [
            "Sun": ["Leo"],
            "Moon": ["Cancer"],
            "Mercury": ["Gemini", "Virgo"],
            "Venus": ["Taurus", "Libra"],
            "Mars": ["Aries", "Scorpio"],
            "Jupiter": ["Sagittarius", "Pisces"],
            "Saturn": ["Capricorn", "Aquarius"],
            "Uranus": ["Aquarius"],
            "Neptune": ["Pisces"],
            "Pluto": ["Scorpio"]
        ]
    }
    
    private func getSignElements() -> [String: String] {
        return [
            "Aries": "Fire", "Leo": "Fire", "Sagittarius": "Fire",
            "Taurus": "Earth", "Virgo": "Earth", "Capricorn": "Earth",
            "Gemini": "Air", "Libra": "Air", "Aquarius": "Air",
            "Cancer": "Water", "Scorpio": "Water", "Pisces": "Water"
        ]
    }
}

/// Validation result for insight quality assessment
struct ValidationResult {
    let isValid: Bool
    let score: Double
    let issues: [String]
    let confidence: Double
}

/**
 * Claude: Extension for Apple MLX Integration
 * Prepares validated insights for machine learning training
 */
extension KASPERTrainingDataManager {
    
    /**
     * Claude: Export training data in Apple MLX compatible format
     */
    func exportForMLXTraining(_ batches: [TrainingBatch]) async throws -> Data {
        let mlxFormat = try createMLXTrainingFormat(from: batches)
        return try encoder.encode(mlxFormat)
    }
    
    private func createMLXTrainingFormat(from batches: [TrainingBatch]) throws -> MLXTrainingData {
        let allInsights = batches.flatMap { $0.insights }
        
        let trainingExamples = allInsights.map { insight in
            MLXTrainingExample(
                input: createMLXInput(from: insight),
                output: insight.content,
                metadata: MLXMetadata(
                    category: insight.category.rawValue,
                    confidence: insight.confidence,
                    qualityScore: insight.metadata.qualityScore
                )
            )
        }
        
        return MLXTrainingData(
            version: "1.0.0",
            totalExamples: trainingExamples.count,
            categories: TrainingInsightCategory.allCases.map { $0.rawValue },
            examples: trainingExamples
        )
    }
    
    private func createMLXInput(from insight: TrainingSpiritualInsight) -> String {
        // Create structured input for MLX training
        let context = """
        Number: \(insight.number)
        Category: \(insight.category.rawValue)
        Themes: \(insight.themes.joined(separator: ", "))
        Planet: \(insight.astrologicalContext.planet)
        Sign: \(insight.astrologicalContext.sign)
        Element: \(insight.astrologicalContext.element)
        """
        return context
    }
}

/// Apple MLX training data format
struct MLXTrainingData: Codable {
    let version: String
    let totalExamples: Int
    let categories: [String]
    let examples: [MLXTrainingExample]
}

struct MLXTrainingExample: Codable {
    let input: String
    let output: String
    let metadata: MLXMetadata
}

struct MLXMetadata: Codable {
    let category: String
    let confidence: Double
    let qualityScore: Double
}