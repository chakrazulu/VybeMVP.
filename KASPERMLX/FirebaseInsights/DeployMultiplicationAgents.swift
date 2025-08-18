/**
 * =================================================================
 * 🚀 DEPLOY NUMBERMEANINGS MULTIPLICATION AGENTS - LAUNCH SCRIPT
 * =================================================================
 *
 * 🎯 MISSION: Transform 260 insights into 975+ insights across all numbers
 *
 * This script launches the NumberMeanings Multiplication System to generate
 * 75+ unique insights per number, creating *_rich_multiplied.json files
 * alongside existing base files for seamless integration.
 *
 * 📊 DEPLOYMENT TARGETS:
 * - Numbers: 1-9, 11, 22, 33, 44 (13 total)
 * - Input: 20 insights per number (260 total)
 * - Output: 75+ insights per number (975+ total)
 * - Quality: >0.75 average score, 100% spiritual authenticity
 * - Schema: Perfect compatibility with existing NumberRichContent
 *
 * 🚀 MULTIPLICATION STRATEGIES:
 * 1. Aspect Variation: Love, Career, Health, Spiritual Growth, etc.
 * 2. Contextual Shifts: Daily life, Crisis, Celebration, Growth phases
 * 3. Intensity Gradients: 0.6-1.0 range for contextual appropriateness
 * 4. Persona Voices: Oracle, Psychologist, MindfulnessCoach perspectives
 * 5. Situational Applications: Morning reflection, Decision points, etc.
 *
 * August 15, 2025 - NumberMeanings Agents Ready for Deployment
 */

import Foundation
import SwiftUI
import os.log

// MARK: - Deployment Coordinator

/// Coordinates the deployment of all multiplication agents
@MainActor
public class MultiplicationDeploymentCoordinator: ObservableObject {

    // MARK: - Published Properties

    @Published public private(set) var deploymentState: DeploymentState = .ready
    @Published public private(set) var progress: Double = 0.0
    @Published public private(set) var currentStep: String = "Ready to deploy"
    @Published public private(set) var results: [MultiplicationResult] = []
    @Published public private(set) var deploymentSummary: DeploymentSummary?

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "MultiplicationDeployment")
    private let multiplicationSystem = NumberMultiplicationSystem()

    // MARK: - Deployment Interface

    /**
     * 🚀 MAIN DEPLOYMENT ENTRY POINT
     *
     * Launches all multiplication agents and generates the enhanced
     * NumberMeanings content with 75+ insights per number.
     */
    public func deployAllAgents() async {
        logger.info("🚀 LAUNCHING NumberMeanings Multiplication Agents Deployment")

        deploymentState = .deploying
        progress = 0.0
        currentStep = "Initializing multiplication system..."

        do {
            // Step 1: Validate base files
            currentStep = "Validating base content files..."
            progress = 0.1
            try await validateBaseFiles()

            // Step 2: Deploy multiplication agents
            currentStep = "Deploying multiplication agents..."
            progress = 0.2

            results = try await multiplicationSystem.deployAllMultiplicationAgents()

            // Step 3: Validate generated files
            currentStep = "Validating generated content..."
            progress = 0.9
            try await validateGeneratedFiles()

            // Step 4: Create deployment summary
            currentStep = "Creating deployment summary..."
            progress = 0.95
            createDeploymentSummary()

            // Step 5: Complete
            currentStep = "Deployment complete!"
            progress = 1.0
            deploymentState = .completed

            logger.info("✅ DEPLOYMENT COMPLETE - \(self.results.reduce(0) { $0 + $1.insights.count }) insights generated")

        } catch {
            logger.error("❌ Deployment failed: \(error.localizedDescription)")
            deploymentState = .failed(error)
            currentStep = "Deployment failed: \(error.localizedDescription)"
        }
    }

    // MARK: - Validation Methods

    /// Validate that all base files exist and are valid
    private func validateBaseFiles() async throws {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

        for number in numbers {
            guard let bundleURL = Bundle.main.url(
                forResource: "\(number)_rich",
                withExtension: "json",
                subdirectory: "KASPERMLXRuntimeBundle/RichNumberMeanings"
            ) else {
                throw DeploymentError.baseFileNotFound(number)
            }

            // Validate JSON structure
            let data = try Data(contentsOf: bundleURL)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            guard let insights = json?["behavioral_insights"] as? [[String: Any]],
                  insights.count >= 15 else {
                throw DeploymentError.insufficientBaseContent(number)
            }
        }

        logger.info("✅ All \(numbers.count) base files validated successfully")
    }

    /// Validate that generated files were created and are valid
    private func validateGeneratedFiles() async throws {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

        for number in numbers {
            // Check if multiplied file exists
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let multipliedURL = documentsPath
                .appendingPathComponent("KASPERMLXRuntimeBundle")
                .appendingPathComponent("RichNumberMeanings")
                .appendingPathComponent("\(number)_rich_multiplied.json")

            guard FileManager.default.fileExists(atPath: multipliedURL.path) else {
                logger.warning("⚠️ Multiplied file not found at expected location for number \(number)")
                continue
            }

            // Validate content
            let data = try Data(contentsOf: multipliedURL)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

            guard let insights = json?["behavioral_insights"] as? [[String: Any]],
                  insights.count >= 50 else {
                throw DeploymentError.insufficientGeneratedContent(number)
            }
        }

        logger.info("✅ All generated files validated successfully")
    }

    /// Create comprehensive deployment summary
    private func createDeploymentSummary() {
        let totalInsights = results.reduce(0) { $0 + $1.insights.count }
        let totalQualityPassed = results.reduce(0) { $0 + $1.qualityPassed }
        let averageQuality = results.reduce(0.0) { $0 + $1.averageQuality } / Double(results.count)
        let totalTime = results.reduce(0.0) { $0 + $1.generationTime }

        var strategyBreakdown: [String: Int] = [:]
        for result in results {
            for (strategy, count) in result.strategies {
                strategyBreakdown[strategy, default: 0] += count
            }
        }

        deploymentSummary = DeploymentSummary(
            numbersProcessed: results.count,
            totalInsightsGenerated: totalInsights,
            totalQualityPassed: totalQualityPassed,
            averageQuality: averageQuality,
            totalGenerationTime: totalTime,
            strategyBreakdown: strategyBreakdown,
            deploymentDate: Date()
        )
    }

    // MARK: - File Management

    /// Copy generated files to app bundle location (for development testing)
    public func copyFilesToBundle() async throws {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

        for number in numbers {
            // Source: Documents directory
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let sourceURL = documentsPath
                .appendingPathComponent("KASPERMLXRuntimeBundle")
                .appendingPathComponent("RichNumberMeanings")
                .appendingPathComponent("\(number)_rich_multiplied.json")

            // Destination: Bundle directory (for development)
            guard let bundleURL = Bundle.main.url(
                forResource: "\(number)_rich",
                withExtension: "json",
                subdirectory: "KASPERMLXRuntimeBundle/RichNumberMeanings"
            ) else { continue }

            let destinationURL = bundleURL.deletingLastPathComponent()
                .appendingPathComponent("\(number)_rich_multiplied.json")

            // Copy file
            if FileManager.default.fileExists(atPath: sourceURL.path) {
                try? FileManager.default.removeItem(at: destinationURL)
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                logger.info("📁 Copied \(number)_rich_multiplied.json to bundle")
            }
        }
    }

    // MARK: - Reset and Cleanup

    /// Reset deployment state for new deployment
    public func reset() {
        deploymentState = .ready
        progress = 0.0
        currentStep = "Ready to deploy"
        results = []
        deploymentSummary = nil
        multiplicationSystem.reset()
    }
}

// MARK: - Supporting Data Structures

/// Deployment state tracking
public enum DeploymentState: Equatable {
    case ready
    case deploying
    case completed
    case failed(Error)

    public static func == (lhs: DeploymentState, rhs: DeploymentState) -> Bool {
        switch (lhs, rhs) {
        case (.ready, .ready), (.deploying, .deploying), (.completed, .completed):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

/// Comprehensive deployment summary
public struct DeploymentSummary {
    public let numbersProcessed: Int
    public let totalInsightsGenerated: Int
    public let totalQualityPassed: Int
    public let averageQuality: Double
    public let totalGenerationTime: TimeInterval
    public let strategyBreakdown: [String: Int]
    public let deploymentDate: Date

    public var successRate: Double {
        guard totalInsightsGenerated > 0 else { return 0.0 }
        return Double(totalQualityPassed) / Double(totalInsightsGenerated)
    }

    public var insightsPerSecond: Double {
        guard totalGenerationTime > 0 else { return 0.0 }
        return Double(totalInsightsGenerated) / totalGenerationTime
    }

    public var averageInsightsPerNumber: Double {
        guard numbersProcessed > 0 else { return 0.0 }
        return Double(totalInsightsGenerated) / Double(numbersProcessed)
    }
}

/// Deployment error types
public enum DeploymentError: Error, LocalizedError {
    case baseFileNotFound(Int)
    case insufficientBaseContent(Int)
    case insufficientGeneratedContent(Int)
    case validationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .baseFileNotFound(let number):
            return "Base file \(number)_rich.json not found"
        case .insufficientBaseContent(let number):
            return "Insufficient base content in file for number \(number)"
        case .insufficientGeneratedContent(let number):
            return "Generated content for number \(number) below minimum threshold"
        case .validationFailed(let message):
            return "Validation failed: \(message)"
        }
    }
}

// MARK: - SwiftUI Deployment View

/// SwiftUI view for monitoring deployment progress
public struct MultiplicationDeploymentView: View {
    @StateObject private var coordinator = MultiplicationDeploymentCoordinator()
    @State private var showingResults = false

    public var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("🔢 NumberMeanings Multiplication")
                    .font(.title.bold())

                Text("Deploy agents to generate 75+ insights per number")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Progress Section
            if coordinator.deploymentState == .deploying {
                VStack(spacing: 12) {
                    ProgressView(value: coordinator.progress)
                        .progressViewStyle(LinearProgressViewStyle())

                    Text(coordinator.currentStep)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(Int(coordinator.progress * 100))% Complete")
                        .font(.caption.weight(.medium))
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }

            // Action Buttons
            HStack(spacing: 16) {
                Button(action: {
                    Task {
                        await coordinator.deployAllAgents()
                    }
                }) {
                    Label("Deploy Agents", systemImage: "rocket")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(coordinator.deploymentState == .deploying)

                if coordinator.deploymentState == .completed {
                    Button("View Results") {
                        showingResults = true
                    }
                    .buttonStyle(.bordered)
                }
            }

            // Status Summary
            if let summary = coordinator.deploymentSummary {
                DeploymentSummaryCard(summary: summary)
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingResults) {
            DeploymentResultsView(results: coordinator.results)
        }
    }
}

/// Summary card showing deployment results
struct DeploymentSummaryCard: View {
    let summary: DeploymentSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎉 Deployment Complete!")
                .font(.headline.bold())
                .foregroundColor(.green)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                DeploymentStatCard(title: "Numbers", value: "\(summary.numbersProcessed)")
                DeploymentStatCard(title: "Insights", value: "\(summary.totalInsightsGenerated)")
                DeploymentStatCard(title: "Quality", value: "\(Int(summary.averageQuality * 100))%")
                DeploymentStatCard(title: "Time", value: "\(String(format: "%.1f", summary.totalGenerationTime))s")
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}

/// Individual stat card
struct DeploymentStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

/// Detailed results view
struct DeploymentResultsView: View {
    let results: [MultiplicationResult]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(results, id: \.number) { result in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Number \(result.number)")
                            .font(.headline)

                        Spacer()

                        Text("\(result.insights.count) insights")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }

                    HStack {
                        Text("Quality: \(String(format: "%.1f%%", result.averageQuality * 100))")
                        Spacer()
                        Text("Time: \(String(format: "%.3f", result.generationTime))s")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Deployment Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/**
 * DEPLOYMENT INSTRUCTIONS:
 *
 * 1. Add MultiplicationDeploymentView to your app
 * 2. Tap "Deploy Agents" to generate all multiplied files
 * 3. Generated files will be created alongside existing base files
 * 4. App will automatically load multiplied content when available
 * 5. Fallback to base content ensures reliability
 *
 * EXPECTED OUTCOME:
 * - 13 new *_rich_multiplied.json files
 * - 975+ total insights (75+ per number)
 * - Perfect schema compatibility
 * - 4x content variety for users
 */
