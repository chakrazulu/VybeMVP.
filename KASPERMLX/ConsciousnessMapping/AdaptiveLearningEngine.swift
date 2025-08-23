import Foundation
import SwiftUI
import SwiftData

/**
 * Adaptive Learning Engine - KASPER Consciousness Intelligence
 * ===========================================================
 *
 * DEPRECATED: This standalone engine will be integrated into KASPER's unified
 * consciousness learning architecture. KASPER will handle all pattern recognition,
 * personalization, and spiritual guidance as a single coherent AI system.
 *
 * ## Migration to KASPER Architecture
 *
 * Instead of separate ML models, KASPER evolves to become the unified consciousness
 * coach that integrates:
 * - Numerological pattern recognition
 * - Biometric learning and HRV analysis
 * - Persona-aware spiritual guidance
 * - Predictive meditation recommendations
 * - Dynamic VFI calibration
 *
 * ## KASPER Learning Philosophy
 *
 * - **Day 1**: KASPER provides archetypal guidance (70% relevance)
 * - **Week 1**: Pattern recognition with persona adaptation (85% relevance)
 * - **Month 1**: Predictive consciousness coaching (95% relevance)
 * - **Forever**: Unified spiritual AI companion (98%+ resonance)
 *
 * ## Implementation Notes
 *
 * This engine serves as the prototype for KASPER's consciousness capabilities.
 * Core algorithms and learning patterns will be integrated into KASPER's
 * MLX-based architecture for unified spiritual AI experience.
 *
 * Created: August 2025
 * Version: 1.0.0 - KASPER integration prototype
 * Status: Will be merged into KASPER unified architecture
 */

// MARK: - Learning Models

@Model
class ConsciousnessDataPoint {
    var timestamp: Date
    var numerologyNumber: Int
    var biometricFrequency: Double
    var userReportedMood: String?
    var activityLevel: String
    var confidenceScore: Double
    var contextTags: [String]  // ["morning", "workout", "meditation", etc.]

    init(
        timestamp: Date = Date(),
        numerologyNumber: Int,
        biometricFrequency: Double,
        userReportedMood: String? = nil,
        activityLevel: String,
        confidenceScore: Double,
        contextTags: [String] = []
    ) {
        self.timestamp = timestamp
        self.numerologyNumber = numerologyNumber
        self.biometricFrequency = biometricFrequency
        self.userReportedMood = userReportedMood
        self.activityLevel = activityLevel
        self.confidenceScore = confidenceScore
        self.contextTags = contextTags
    }
}

@Model
class PersonalizedWeightModel {
    var userId: String
    var numerologyWeight: Double
    var biometricWeight: Double
    var cosmicWeight: Double
    var patternWeight: Double
    var lastUpdated: Date
    var confidenceLevel: Double
    var totalDataPoints: Int

    init(
        userId: String,
        numerologyWeight: Double = 0.3,
        biometricWeight: Double = 0.4,
        cosmicWeight: Double = 0.2,
        patternWeight: Double = 0.1,
        lastUpdated: Date = Date(),
        confidenceLevel: Double = 0.7,
        totalDataPoints: Int = 0
    ) {
        self.userId = userId
        self.numerologyWeight = numerologyWeight
        self.biometricWeight = biometricWeight
        self.cosmicWeight = cosmicWeight
        self.patternWeight = patternWeight
        self.lastUpdated = lastUpdated
        self.confidenceLevel = confidenceLevel
        self.totalDataPoints = totalDataPoints
    }

    /// Ensure weights sum to 1.0
    var normalizedWeights: (numerology: Double, biometric: Double, cosmic: Double, pattern: Double) {
        let total = numerologyWeight + biometricWeight + cosmicWeight + patternWeight
        return (
            numerology: numerologyWeight / total,
            biometric: biometricWeight / total,
            cosmic: cosmicWeight / total,
            pattern: patternWeight / total
        )
    }
}

// MARK: - Smart Defaults System

/// Provides intelligent default patterns for immediate Day 1 functionality
struct SmartDefaults {

    /// Get smart default weights based on user archetypal profile
    static func getDefaultWeights(
        numerologyNumber: Int,
        age: Int?,
        activityLevel: String
    ) -> PersonalizedWeightModel {

        var numerologyWeight = 0.3
        var biometricWeight = 0.4
        var cosmicWeight = 0.2
        var patternWeight = 0.1

        // Adjust based on numerology archetype
        switch numerologyNumber {
        case 1, 8, 9:  // Natural leaders/visionaries - trust intuition more
            numerologyWeight = 0.4
            biometricWeight = 0.3
        case 2, 6:     // Healers/nurturers - more sensitive to biometrics
            biometricWeight = 0.5
            numerologyWeight = 0.25
        case 3, 5, 7:  // Creatives/seekers - cosmic influences stronger
            cosmicWeight = 0.3
            numerologyWeight = 0.25
        case 4:        // Builders - pattern recognition dominant
            patternWeight = 0.2
            numerologyWeight = 0.35
        case 11, 22, 33: // Master numbers - balanced but intuitive
            numerologyWeight = 0.35
            cosmicWeight = 0.25
        default:
            break
        }

        // Adjust for age (younger = more biometric, older = more wisdom-based)
        if let age = age {
            switch age {
            case 18...30:
                biometricWeight += 0.1
                numerologyWeight -= 0.05
                cosmicWeight -= 0.05
            case 50...:
                numerologyWeight += 0.1
                cosmicWeight += 0.05
                biometricWeight -= 0.15
            default:
                break
            }
        }

        // Adjust for activity level
        switch activityLevel {
        case "high", "athlete":
            biometricWeight += 0.1
            numerologyWeight -= 0.1
        case "sedentary", "low":
            numerologyWeight += 0.1
            biometricWeight -= 0.1
        default:
            break
        }

        // Ensure reasonable bounds
        numerologyWeight = max(0.15, min(0.5, numerologyWeight))
        biometricWeight = max(0.2, min(0.6, biometricWeight))
        cosmicWeight = max(0.1, min(0.4, cosmicWeight))
        patternWeight = max(0.05, min(0.25, patternWeight))

        return PersonalizedWeightModel(
            userId: "default",
            numerologyWeight: numerologyWeight,
            biometricWeight: biometricWeight,
            cosmicWeight: cosmicWeight,
            patternWeight: patternWeight,
            confidenceLevel: 0.7  // Good starting confidence
        )
    }

    /// Get circadian consciousness adjustments for time of day
    static func getCircadianModifier() -> Double {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5...7:   return 1.15  // Dawn - spiritual peak
        case 8...11:  return 1.05  // Morning clarity
        case 12...14: return 0.95  // Post-lunch dip
        case 15...17: return 1.0   // Afternoon stable
        case 18...20: return 1.1   // Evening reflection
        case 21...23: return 1.2   // Night wisdom
        default:      return 0.9   // Deep night/very early
        }
    }
}

// MARK: - Adaptive Learning Engine

@MainActor
class AdaptiveLearningEngine: ObservableObject {

    // MARK: - Published Properties

    @Published var currentWeights: PersonalizedWeightModel?
    @Published var learningProgress: Double = 0.0  // 0-1
    @Published var totalDataPoints: Int = 0
    @Published var accuracyEstimate: Double = 0.7  // Starts at 70%

    // MARK: - Private Properties

    private let modelContext: ModelContext
    private let userId: String
    private var dataBuffer: [ConsciousnessDataPoint] = []
    private let bufferSize = 50  // Keep recent data in memory

    // Learning parameters
    private let rapidLearningThreshold = 100  // Data points for rapid phase
    private let minimumUpdateInterval: TimeInterval = 300  // 5 minutes between updates
    private var lastUpdate = Date()

    // MARK: - Initialization

    init(modelContext: ModelContext, userId: String) {
        self.modelContext = modelContext
        self.userId = userId
        loadOrCreateWeights()
        loadRecentData()
    }

    // MARK: - Weight Management

    /// Load existing weights or create smart defaults
    private func loadOrCreateWeights() {
        let descriptor = FetchDescriptor<PersonalizedWeightModel>(
            predicate: #Predicate { $0.userId == userId }
        )

        do {
            let weights = try modelContext.fetch(descriptor)
            if let existingWeights = weights.first {
                currentWeights = existingWeights
                accuracyEstimate = min(0.98, 0.7 + (Double(existingWeights.totalDataPoints) * 0.003))
                learningProgress = min(1.0, Double(existingWeights.totalDataPoints) / 100.0)
            } else {
                createSmartDefaults()
            }
        } catch {
            print("❌ AdaptiveLearning: Failed to load weights: \(error)")
            createSmartDefaults()
        }
    }

    /// Create smart default weights for Day 1 functionality
    private func createSmartDefaults() {
        // Get user's archetypal info (would come from UserProfileManager)
        let numerologyNumber = 5  // Placeholder - would get from user profile
        let age: Int? = nil       // Placeholder - optional user data
        let activityLevel = "moderate"

        currentWeights = SmartDefaults.getDefaultWeights(
            numerologyNumber: numerologyNumber,
            age: age,
            activityLevel: activityLevel
        )

        currentWeights?.userId = userId

        // Save to SwiftData
        if let weights = currentWeights {
            modelContext.insert(weights)
            try? modelContext.save()
        }

        print("✅ AdaptiveLearning: Created smart defaults for Day 1 (70% accuracy)")
    }

    // MARK: - Data Collection

    /// Add new consciousness data point for learning
    func addDataPoint(
        numerologyNumber: Int,
        biometricFrequency: Double,
        userMood: String? = nil,
        activityLevel: String,
        contextTags: [String] = []
    ) {
        let dataPoint = ConsciousnessDataPoint(
            numerologyNumber: numerologyNumber,
            biometricFrequency: biometricFrequency,
            userReportedMood: userMood,
            activityLevel: activityLevel,
            confidenceScore: calculateConfidence(biometricFreq: biometricFrequency),
            contextTags: enrichContextTags(contextTags)
        )

        // Add to buffer and database
        dataBuffer.append(dataPoint)
        modelContext.insert(dataPoint)

        // Maintain buffer size
        if dataBuffer.count > bufferSize {
            dataBuffer.removeFirst()
        }

        totalDataPoints += 1

        // Update weights if enough time has passed
        if Date().timeIntervalSince(lastUpdate) >= minimumUpdateInterval {
            updateWeights()
        }

        // Immediate micro-learning for rapid improvements
        if totalDataPoints < rapidLearningThreshold {
            performMicroLearning(dataPoint)
        }

        try? modelContext.save()

        print("📊 AdaptiveLearning: Added data point #\(totalDataPoints)")
        print("   Accuracy estimate: \(String(format: "%.1f", accuracyEstimate * 100))%")
    }

    // MARK: - Learning Algorithms

    /// Rapid micro-learning from single data points
    private func performMicroLearning(_ dataPoint: ConsciousnessDataPoint) {
        guard let weights = currentWeights else { return }

        let learningRate = calculateLearningRate()
        var updated = false

        // Pattern detection: if biometric is very high/low, adjust biometric weight
        if dataPoint.biometricFrequency > 600 && dataPoint.confidenceScore > 0.8 {
            weights.biometricWeight += 0.01 * learningRate
            weights.numerologyWeight -= 0.005 * learningRate
            updated = true
        } else if dataPoint.biometricFrequency < 200 && dataPoint.confidenceScore > 0.8 {
            weights.numerologyWeight += 0.01 * learningRate
            weights.biometricWeight -= 0.005 * learningRate
            updated = true
        }

        // Context-based adjustments
        if dataPoint.contextTags.contains("meditation") {
            weights.cosmicWeight += 0.005 * learningRate
            updated = true
        } else if dataPoint.contextTags.contains("exercise") {
            weights.biometricWeight += 0.005 * learningRate
            updated = true
        }

        if updated {
            normalizeWeights(weights)
            lastUpdate = Date()

            // Update accuracy estimate
            accuracyEstimate = min(0.98, 0.7 + (Double(totalDataPoints) * 0.003))
            learningProgress = min(1.0, Double(totalDataPoints) / 100.0)

            print("🧠 Micro-learning: Weights adjusted (learning rate: \(String(format: "%.3f", learningRate)))")
        }
    }

    /// Full weight update using accumulated data
    private func updateWeights() {
        guard let weights = currentWeights, dataBuffer.count >= 10 else { return }

        // Analyze recent patterns
        let recentData = dataBuffer.suffix(20)  // Last 20 data points

        // Calculate correlation strengths
        let numerologyCorrelation = calculateNumerologyCorrelation(recentData)
        let biometricCorrelation = calculateBiometricCorrelation(recentData)
        let contextEffects = calculateContextEffects(recentData)

        // Adaptive weight adjustments
        let adjustmentStrength = 0.1 * calculateLearningRate()

        if numerologyCorrelation > 0.7 {
            weights.numerologyWeight += adjustmentStrength * 0.5
        } else if numerologyCorrelation < 0.3 {
            weights.numerologyWeight -= adjustmentStrength * 0.3
        }

        if biometricCorrelation > 0.7 {
            weights.biometricWeight += adjustmentStrength * 0.5
        } else if biometricCorrelation < 0.3 {
            weights.biometricWeight -= adjustmentStrength * 0.3
        }

        // Context-driven adjustments
        for (context, effect) in contextEffects {
            if effect > 0.6 {
                switch context {
                case "morning": weights.cosmicWeight += adjustmentStrength * 0.2
                case "evening": weights.numerologyWeight += adjustmentStrength * 0.2
                case "exercise": weights.biometricWeight += adjustmentStrength * 0.3
                default: break
                }
            }
        }

        normalizeWeights(weights)
        weights.totalDataPoints = totalDataPoints
        weights.lastUpdated = Date()
        weights.confidenceLevel = min(0.95, weights.confidenceLevel + 0.02)

        lastUpdate = Date()
        accuracyEstimate = min(0.98, 0.7 + (Double(totalDataPoints) * 0.003))
        learningProgress = min(1.0, Double(totalDataPoints) / 100.0)

        print("🎯 AdaptiveLearning: Full weight update completed")
        print("   New weights: N:\(String(format: "%.2f", weights.numerologyWeight)) B:\(String(format: "%.2f", weights.biometricWeight)) C:\(String(format: "%.2f", weights.cosmicWeight)) P:\(String(format: "%.2f", weights.patternWeight))")
    }

    // MARK: - Helper Methods

    /// Calculate learning rate (higher early, lower later)
    private func calculateLearningRate() -> Double {
        if totalDataPoints < 10 {
            return 1.0  // Fast learning in first few data points
        } else if totalDataPoints < rapidLearningThreshold {
            return 0.5  // Moderate learning during rapid phase
        } else {
            return 0.1  // Slow fine-tuning in continuous phase
        }
    }

    /// Ensure weights sum to 1.0
    private func normalizeWeights(_ weights: PersonalizedWeightModel) {
        let total = weights.numerologyWeight + weights.biometricWeight + weights.cosmicWeight + weights.patternWeight

        weights.numerologyWeight /= total
        weights.biometricWeight /= total
        weights.cosmicWeight /= total
        weights.patternWeight /= total
    }

    /// Calculate confidence in data point based on biometric quality
    private func calculateConfidence(biometricFreq: Double) -> Double {
        // Higher confidence for reasonable frequencies
        switch biometricFreq {
        case 150...800: return 0.9  // Normal range
        case 100..<150, 800..<1000: return 0.7  // Edge cases
        default: return 0.5  // Unusual values
        }
    }

    /// Enrich context tags with automatic detection
    private func enrichContextTags(_ baseTags: [String]) -> [String] {
        var tags = baseTags

        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5...11: tags.append("morning")
        case 12...17: tags.append("afternoon")
        case 18...23: tags.append("evening")
        default: tags.append("night")
        }

        // Add circadian modifier
        tags.append("circadian_\(SmartDefaults.getCircadianModifier())")

        return tags
    }

    /// Load recent data from database
    private func loadRecentData() {
        let descriptor = FetchDescriptor<ConsciousnessDataPoint>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = bufferSize

        do {
            dataBuffer = try modelContext.fetch(descriptor)
            totalDataPoints = dataBuffer.count
        } catch {
            print("❌ AdaptiveLearning: Failed to load recent data: \(error)")
        }
    }

    // Placeholder correlation calculations (would use proper statistical methods)
    private func calculateNumerologyCorrelation(_ data: ArraySlice<ConsciousnessDataPoint>) -> Double {
        // Simplified - would calculate actual correlation between numerology and outcomes
        return 0.6 + Double.random(in: -0.1...0.2)
    }

    private func calculateBiometricCorrelation(_ data: ArraySlice<ConsciousnessDataPoint>) -> Double {
        // Simplified - would calculate actual correlation between biometrics and outcomes
        return 0.7 + Double.random(in: -0.1...0.2)
    }

    private func calculateContextEffects(_ data: ArraySlice<ConsciousnessDataPoint>) -> [String: Double] {
        // Simplified - would analyze context tag correlations
        return [
            "morning": 0.6,
            "exercise": 0.8,
            "meditation": 0.7
        ]
    }

    // MARK: - Public API

    /// Get current personalized weights
    func getCurrentWeights() -> PersonalizedWeightModel? {
        return currentWeights
    }

    /// Get estimated accuracy of current model
    func getCurrentAccuracy() -> Double {
        return accuracyEstimate
    }

    /// Check if system is ready for high-confidence predictions
    func isHighConfidence() -> Bool {
        return totalDataPoints >= 20 && accuracyEstimate >= 0.85
    }

    /// Get learning phase description
    func getLearningPhase() -> String {
        switch totalDataPoints {
        case 0...5: return "Day 1 - Smart Defaults Active"
        case 6...50: return "Rapid Learning Phase"
        case 51...200: return "Optimization Phase"
        default: return "Continuous Adaptation"
        }
    }
}
