/**
 * KASPER Training Data Exporter
 *
 * Exports user feedback and insights into structured training data
 * for MLX model fine-tuning and continuous improvement.
 * Supports multiple export formats for different ML frameworks.
 */

import Foundation
import OSLog

private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "TrainingExporter")

/// Training data export manager for KASPER MLX
@MainActor
class KASPERTrainingExporter: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var isExporting = false
    @Published private(set) var exportProgress: Double = 0.0
    @Published private(set) var lastExportDate: Date?
    @Published private(set) var lastExportCount: Int = 0

    // MARK: - Private Properties

    private let feedbackManager = KASPERFeedbackManager.shared
    private let fileManager = FileManager.default
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    // MARK: - Singleton

    static let shared = KASPERTrainingExporter()

    private init() {
        loadExportHistory()
    }

    // MARK: - Export Methods

    /// Export training data to JSON file for MLX training
    func exportToJSON() async throws -> URL {
        logger.info("🔮 KASPER Training Export: Starting JSON export...")

        await MainActor.run {
            isExporting = true
            exportProgress = 0.0
        }

        defer {
            Task { @MainActor in
                isExporting = false
            }
        }

        // Collect all feedback data
        let feedbackData = feedbackManager.feedbackHistory
        await updateProgress(0.2)

        // Convert to training examples
        let trainingExamples = await createTrainingExamples(from: feedbackData)
        await updateProgress(0.6)

        // Create JSON structure
        let exportData = createExportStructure(examples: trainingExamples)
        await updateProgress(0.8)

        // Save to file
        let fileURL = try await saveToFile(data: exportData)
        await updateProgress(1.0)

        // Update export history
        await MainActor.run {
            lastExportDate = Date()
            lastExportCount = trainingExamples.count
        }
        saveExportHistory()

        logger.info("🔮 KASPER Training Export: Exported \(trainingExamples.count) examples to \(fileURL.lastPathComponent)")
        return fileURL
    }

    /// Export training data in MLX-compatible format
    func exportForMLX() async throws -> Data {
        logger.info("🔮 KASPER Training Export: Creating MLX-compatible dataset...")

        let feedbackData = feedbackManager.feedbackHistory
        var mlxDataset: [[String: Any]] = []

        for feedback in feedbackData {
            // Only use positively rated feedback for training
            guard feedback.rating == .positive else { continue }

            // Create MLX training format
            let example: [String: Any] = [
                "instruction": createInstruction(for: feedback.feature),
                "input": createInput(from: feedback.contextData),
                "output": feedback.insightContent,
                "metadata": [
                    "feature": feedback.feature.rawValue,
                    "timestamp": dateFormatter.string(from: feedback.timestamp),
                    "rating": feedback.rating.score
                ]
            ]
            mlxDataset.append(example)
        }

        let jsonData = try JSONSerialization.data(withJSONObject: mlxDataset, options: .prettyPrinted)
        logger.info("🔮 KASPER Training Export: Created MLX dataset with \(mlxDataset.count) examples")
        return jsonData
    }

    /// Export augmented training data with negative examples
    func exportAugmentedDataset() async throws -> Data {
        logger.info("🔮 KASPER Training Export: Creating augmented dataset...")

        let feedbackData = feedbackManager.feedbackHistory
        var augmentedDataset: [[String: Any]] = []

        // Process all feedback
        for feedback in feedbackData {
            var example: [String: Any] = [
                "instruction": createInstruction(for: feedback.feature),
                "input": createInput(from: feedback.contextData),
                "output": feedback.insightContent,
                "label": feedback.rating == .positive ? 1.0 : 0.0,
                "metadata": [
                    "feature": feedback.feature.rawValue,
                    "timestamp": dateFormatter.string(from: feedback.timestamp),
                    "rating": feedback.rating.score
                ]
            ]

            // For negative feedback, add suggested improvement
            if feedback.rating == .negative {
                example["suggested_improvement"] = generateImprovement(for: feedback)
            }

            augmentedDataset.append(example)
        }

        // Add synthetic positive examples from enhanced templates
        let syntheticExamples = await generateSyntheticExamples()
        augmentedDataset.append(contentsOf: syntheticExamples)

        let jsonData = try JSONSerialization.data(withJSONObject: augmentedDataset, options: .prettyPrinted)
        logger.info("🔮 KASPER Training Export: Created augmented dataset with \(augmentedDataset.count) examples")
        return jsonData
    }

    // MARK: - Private Methods

    private func createTrainingExamples(from feedback: [KASPERFeedback]) async -> [TrainingExample] {
        var examples: [TrainingExample] = []

        for item in feedback {
            let example = TrainingExample(
                id: item.id,
                feature: item.feature,
                input: createInput(from: item.contextData),
                output: item.insightContent,
                rating: item.rating,
                timestamp: item.timestamp,
                contextData: item.contextData
            )
            examples.append(example)
        }

        return examples
    }

    private func createExportStructure(examples: [TrainingExample]) -> [String: Any] {
        let structure: [String: Any] = [
            "version": "1.0.0",
            "export_date": dateFormatter.string(from: Date()),
            "total_examples": examples.count,
            "statistics": createStatistics(from: examples),
            "training_data": examples.map { example in
                [
                    "id": example.id.uuidString,
                    "feature": example.feature.rawValue,
                    "input": example.input,
                    "output": example.output,
                    "rating": example.rating.rawValue,
                    "timestamp": dateFormatter.string(from: example.timestamp),
                    "context": example.contextData
                ]
            }
        ]

        return structure
    }

    private func createStatistics(from examples: [TrainingExample]) -> [String: Any] {
        let positiveCount = examples.filter { $0.rating == .positive }.count
        let negativeCount = examples.filter { $0.rating == .negative }.count

        var featureDistribution: [String: Int] = [:]
        for example in examples {
            featureDistribution[example.feature.rawValue, default: 0] += 1
        }

        return [
            "total_examples": examples.count,
            "positive_examples": positiveCount,
            "negative_examples": negativeCount,
            "positive_ratio": Double(positiveCount) / Double(max(1, examples.count)),
            "feature_distribution": featureDistribution
        ]
    }

    private func createInstruction(for feature: KASPERFeature) -> String {
        switch feature {
        case .journalInsight:
            return "Generate a spiritual insight based on the user's journal entry"
        case .dailyCard:
            return "Create a personalized daily spiritual guidance card"
        case .sanctumGuidance:
            return "Provide sacred space meditation guidance"
        case .focusIntention:
            return "Generate focus-based spiritual intention"
        case .cosmicTiming:
            return "Analyze cosmic timing for spiritual actions"
        case .matchCompatibility:
            return "Assess spiritual compatibility between two souls"
        case .realmInterpretation:
            return "Interpret the current spiritual realm energy"
        }
    }

    private func createInput(from contextData: [String: String]) -> String {
        var inputComponents: [String] = []

        if let focusNumber = contextData["focus_number"] {
            inputComponents.append("Focus Number: \(focusNumber)")
        }
        if let moonPhase = contextData["moon_phase"] {
            inputComponents.append("Moon Phase: \(moonPhase)")
        }
        if let query = contextData["user_query"] {
            inputComponents.append("Query: \(query)")
        }
        if let cosmicData = contextData["cosmic_data"] {
            inputComponents.append("Cosmic Context: \(cosmicData)")
        }

        return inputComponents.joined(separator: " | ")
    }

    private func generateImprovement(for feedback: KASPERFeedback) -> String {
        // Analyze why the insight might have been poorly received
        let content = feedback.insightContent.lowercased()

        if content.count < 50 {
            return "Provide more detailed and comprehensive spiritual guidance"
        } else if !content.contains("you") && !content.contains("your") {
            return "Make the insight more personal and directly relevant to the user"
        } else if content.contains(feedback.feature.rawValue.lowercased()) {
            return "Avoid being too literal about the feature type in the response"
        } else {
            return "Enhance spiritual depth and provide more actionable guidance"
        }
    }

    private func generateSyntheticExamples() async -> [[String: Any]] {
        var synthetic: [[String: Any]] = []

        // Generate high-quality examples using enhanced templates
        for feature in KASPERFeature.allCases {
            for focusNumber in 1...9 {
                let example: [String: Any] = [
                    "instruction": createInstruction(for: feature),
                    "input": "Focus Number: \(focusNumber) | Moon Phase: Full Moon",
                    "output": await generateHighQualityInsight(for: feature, focusNumber: focusNumber),
                    "label": 1.0,
                    "metadata": [
                        "type": "synthetic",
                        "feature": feature.rawValue,
                        "focus_number": focusNumber
                    ]
                ]
                synthetic.append(example)
            }
        }

        return synthetic
    }

    private func generateHighQualityInsight(for feature: KASPERFeature, focusNumber: Int) async -> String {
        // Generate high-quality synthetic examples
        let component = getComponentForFocus(focusNumber)
        let reference = getReferenceForFocus(focusNumber)
        let guidance = getGuidanceForFocus(focusNumber)

        switch feature {
        case .journalInsight:
            return "✨ Your journal reveals \(component) within your spiritual journey. \(reference.capitalizeFirstLetter()) guides you to \(guidance), allowing divine wisdom to illuminate your path forward."
        case .dailyCard:
            return "🌟 Today's spiritual landscape reveals \(component) radiating through \(reference). This cosmic alignment suggests that when you \(guidance), profound transformation naturally unfolds."
        case .sanctumGuidance:
            return "🌙 Within the sacred spaces of your soul, \(component) speaks through \(reference). Listen deeply as you \(guidance), allowing inner wisdom to surface naturally."
        case .focusIntention:
            return "💫 I embody \(component) as it flows through \(reference) with grace and purpose. Each day I \(guidance), stepping deeper into my divine truth."
        case .cosmicTiming:
            return "⏰ Divine timing orchestrates Mercury's influence combined with the Full Moon to support your soul's evolution. The celestial symphony plays your song - dance with it, and watch as synchronized events align to guide your path forward."
        case .matchCompatibility:
            let compatibility = calculateCompatibility(focusNumber, (focusNumber + 4) % 9 + 1)
            return "💞 These two souls create harmonious heart connection together. Number \(focusNumber) brings \(getNumberGift(focusNumber)), while number \((focusNumber + 4) % 9 + 1) offers \(getNumberGift((focusNumber + 4) % 9 + 1)). This combination suggests \(compatibility) that deepens through conscious spiritual practice."
        case .realmInterpretation:
            return "🔮 The cosmic winds carry \(component) through \(reference) toward a pivotal moment ahead. As you \(guidance), watch for synchronicities that confirm you're on the right path."
        }
    }

    private func calculateCompatibility(_ num1: Int, _ num2: Int) -> String {
        let sum = (num1 + num2) % 9
        switch sum {
        case 1, 5, 9: return "powerful spiritual resonance"
        case 2, 6: return "harmonious heart connection"
        case 3, 7: return "creative mystical synergy"
        case 4, 8: return "grounding manifestation power"
        default: return "unique transformative bond"
        }
    }

    private func getNumberGift(_ number: Int) -> String {
        switch number {
        case 1: return "pioneering leadership"
        case 2: return "harmonious collaboration"
        case 3: return "creative expression"
        case 4: return "stable foundations"
        case 5: return "adventurous transformation"
        case 6: return "nurturing wisdom"
        case 7: return "mystical insight"
        case 8: return "manifestation mastery"
        case 9: return "universal compassion"
        default: return "unique spiritual gifts"
        }
    }

    private func getComponentForFocus(_ number: Int) -> String {
        switch number {
        case 1: return "pioneering leadership energy"
        case 2: return "harmonizing cooperative energy"
        case 3: return "creative expression energy"
        case 4: return "grounding foundation energy"
        case 5: return "transformative freedom energy"
        case 6: return "nurturing service energy"
        case 7: return "mystical wisdom energy"
        case 8: return "material mastery energy"
        case 9: return "humanitarian completion energy"
        default: return "unique spiritual energy"
        }
    }

    private func getReferenceForFocus(_ number: Int) -> String {
        switch number {
        case 1: return "your natural leadership abilities"
        case 2: return "your gift for creating harmony"
        case 3: return "your vibrant creative gifts"
        case 4: return "your steadfast dedication"
        case 5: return "your adventurous spirit"
        case 6: return "your compassionate heart"
        case 7: return "your intuitive wisdom"
        case 8: return "your manifestation abilities"
        case 9: return "your universal compassion"
        default: return "your unique spiritual gifts"
        }
    }

    private func getGuidanceForFocus(_ number: Int) -> String {
        switch number {
        case 1: return "trust your instincts to initiate new ventures"
        case 2: return "seek collaboration and peaceful resolution"
        case 3: return "express your truth through creative communication"
        case 4: return "build lasting foundations through patient effort"
        case 5: return "embrace change as a pathway to growth"
        case 6: return "offer healing presence to those around you"
        case 7: return "trust your intuition and inner wisdom"
        case 8: return "balance ambition with spiritual integrity"
        case 9: return "serve the universal good through compassionate action"
        default: return "trust your unique spiritual path"
        }
    }

    private func saveToFile(data: [String: Any]) async throws -> URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exportFolder = documentsPath.appendingPathComponent("KASPERExports")

        // Create export folder if needed
        if !fileManager.fileExists(atPath: exportFolder.path) {
            try fileManager.createDirectory(at: exportFolder, withIntermediateDirectories: true)
        }

        // Create filename with timestamp
        let timestamp = Date().timeIntervalSince1970
        let filename = "kasper_training_\(Int(timestamp)).json"
        let fileURL = exportFolder.appendingPathComponent(filename)

        // Write JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        try jsonData.write(to: fileURL)

        return fileURL
    }

    private func updateProgress(_ progress: Double) async {
        await MainActor.run {
            exportProgress = progress
        }
    }

    private func loadExportHistory() {
        if let date = UserDefaults.standard.object(forKey: "kasper_last_export_date") as? Date {
            lastExportDate = date
        }
        lastExportCount = UserDefaults.standard.integer(forKey: "kasper_last_export_count")
    }

    private func saveExportHistory() {
        UserDefaults.standard.set(lastExportDate, forKey: "kasper_last_export_date")
        UserDefaults.standard.set(lastExportCount, forKey: "kasper_last_export_count")
    }
}

// MARK: - Supporting Types

private struct TrainingExample {
    let id: UUID
    let feature: KASPERFeature
    let input: String
    let output: String
    let rating: FeedbackRating
    let timestamp: Date
    let contextData: [String: String]
}

// MARK: - Helper Extensions

private extension String {
    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
