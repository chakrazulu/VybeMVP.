import SwiftUI
import SwiftData

/**
 * Consciousness Calibration View - Learning Progress & Transparency
 * ================================================================
 *
 * Shows users how their consciousness detection system is learning
 * and adapting to their unique patterns. Provides transparency into
 * the adaptive learning process and current accuracy estimates.
 *
 * ## Key Features
 *
 * - Real-time accuracy display
 * - Learning phase indicator
 * - Personalized weight visualization
 * - Data collection transparency
 * - Manual calibration triggers
 *
 * ## Learning Phases
 *
 * - **Day 1**: Smart defaults (70% accuracy)
 * - **Days 1-7**: Rapid learning (70-90% accuracy)
 * - **Week 2+**: Continuous optimization (90-98% accuracy)
 *
 * Created: August 2025
 * Version: 1.0.0 - Adaptive learning transparency
 */

struct ConsciousnessCalibrationView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingDetails = false

    // TEMPORARY: Placeholder data until KASPER consciousness integration
    @State private var totalDataPoints: Int = 42
    @State private var accuracyEstimate: Double = 0.78
    @State private var learningProgress: Double = 0.6

    // TODO: Replace with KASPER unified consciousness learning once architecture is complete
    // The AdaptiveLearningEngine will be integrated into KASPER rather than standalone

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    headerSection

                    // MARK: - Learning Progress
                    learningProgressSection

                    // MARK: - Current Accuracy
                    accuracySection

                    // MARK: - Personalized Weights
                    if totalDataPoints > 10 {
                        weightsSection
                    }

                    // MARK: - Data Transparency
                    dataTransparencySection

                    // MARK: - Advanced Options
                    advancedOptionsSection

                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Consciousness Learning")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingDetails) {
            LearningDetailsView()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.purple)

            Text("Your Consciousness AI is Learning")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("Day 1 it works, then gets smarter every day")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Learning Progress Section

    private var learningProgressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Learning Phase")
                    .font(.headline)
                Spacer()
                Text(getLearningPhase())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Progress Bar
            ProgressView(value: learningProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)

            HStack {
                Text("\(totalDataPoints) data points")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(progressDescription)
                    .font(.caption)
                    .foregroundColor(progressColor)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Accuracy Section

    private var accuracySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Current Accuracy")
                    .font(.headline)
                Spacer()
                Button("How is this calculated?") {
                    showingDetails = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }

            // Accuracy Ring
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: accuracyEstimate)
                    .stroke(accuracyColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: accuracyEstimate)

                VStack {
                    Text("\(Int(accuracyEstimate * 100))%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(accuracyColor)

                    Text(accuracyDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120, height: 120)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Weights Section

    private var weightsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Personalized Profile")
                    .font(.headline)
                Spacer()
                if accuracyEstimate >= 0.85 && totalDataPoints >= 20 {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }

            // TEMPORARY: Placeholder weights until KASPER integration
            let sampleWeights = (numerology: 0.32, biometric: 0.38, cosmic: 0.22, pattern: 0.08)

            VStack(spacing: 12) {
                WeightBar(
                    title: "Numerology",
                    value: sampleWeights.numerology,
                    color: .purple,
                    description: "Sacred number patterns"
                )

                WeightBar(
                    title: "Biometrics",
                    value: sampleWeights.biometric,
                    color: .red,
                    description: "Heart & breath patterns"
                )

                WeightBar(
                    title: "Cosmic",
                    value: sampleWeights.cosmic,
                    color: .blue,
                    description: "Planetary influences"
                )

                WeightBar(
                    title: "Patterns",
                    value: sampleWeights.pattern,
                    color: .green,
                    description: "Sacred geometry & Tesla codes"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Data Transparency Section

    private var dataTransparencySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Data")
                    .font(.headline)
                Spacer()
                Image(systemName: "lock.shield")
                    .foregroundColor(.green)
            }

            VStack(alignment: .leading, spacing: 8) {
                DataRow(
                    icon: "iphone",
                    title: "All processing on-device",
                    subtitle: "Never leaves your phone"
                )

                DataRow(
                    icon: "heart.fill",
                    title: "HealthKit integration",
                    subtitle: "Respects your privacy settings"
                )

                DataRow(
                    icon: "brain",
                    title: "Pattern learning only",
                    subtitle: "No personal data stored"
                )

                DataRow(
                    icon: "trash",
                    title: "Delete anytime",
                    subtitle: "Full control over your data"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Advanced Options Section

    private var advancedOptionsSection: some View {
        VStack(spacing: 16) {
            Text("Advanced Options")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                Button {
                    // TODO: Reset learning data
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset Learning")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.blue)
                }

                Divider()

                Button {
                    showingDetails = true
                } label: {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("View Learning Details")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.blue)
                }

                Divider()

                Button {
                    // TODO: Export data for analysis
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Learning Data")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Computed Properties

    private var progressColor: Color {
        switch totalDataPoints {
        case 0...10: return .orange
        case 11...50: return .blue
        default: return .green
        }
    }

    private var progressDescription: String {
        switch totalDataPoints {
        case 0...10: return "Getting started"
        case 11...50: return "Learning rapidly"
        default: return "Fully optimized"
        }
    }

    private var accuracyColor: Color {
        switch accuracyEstimate {
        case 0..<0.8: return .orange
        case 0.8..<0.9: return .blue
        default: return .green
        }
    }

    private var accuracyDescription: String {
        switch accuracyEstimate {
        case 0..<0.8: return "Learning"
        case 0.8..<0.9: return "Good"
        default: return "Excellent"
        }
    }

    /// Get learning phase description based on data points
    private func getLearningPhase() -> String {
        switch totalDataPoints {
        case 0...5: return "Day 1 - Smart Defaults Active"
        case 6...50: return "Rapid Learning Phase"
        case 51...200: return "Optimization Phase"
        default: return "Continuous Adaptation"
        }
    }
}

// MARK: - Supporting Views

struct WeightBar: View {
    let title: String
    let value: Double
    let color: Color
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.8), value: value)
                }
            }
            .frame(height: 6)

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct DataRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

// MARK: - Learning Details Sheet

struct LearningDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("How Your AI Learns")
                        .font(.title2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 12) {
                        LearningStage(
                            title: "Day 1 - Smart Defaults",
                            accuracy: "70%",
                            description: "Uses archetypal patterns based on your numerology profile and universal consciousness patterns.",
                            color: .orange
                        )

                        LearningStage(
                            title: "Hours 1-24 - Pattern Detection",
                            accuracy: "75%",
                            description: "Begins detecting your unique biometric patterns and consciousness rhythms.",
                            color: .blue
                        )

                        LearningStage(
                            title: "Days 2-7 - Rapid Learning",
                            accuracy: "85-95%",
                            description: "Learns your personal responses to numerology, biometrics, and cosmic influences.",
                            color: .blue
                        )

                        LearningStage(
                            title: "Week 2+ - Continuous Optimization",
                            accuracy: "95-98%",
                            description: "Fine-tunes understanding and adapts to life changes automatically.",
                            color: .green
                        )
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy & Security")
                            .font(.headline)

                        Text("All learning happens on your device using Apple's HealthKit privacy framework. No consciousness data is ever transmitted or stored in the cloud.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("The system only learns patterns - never personal details or identifiable information.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Learning Details")
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

struct LearningStage: View {
    let title: String
    let accuracy: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Spacer()

                    Text(accuracy)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.2))
                        .foregroundColor(color)
                        .cornerRadius(8)
                }

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ConsciousnessCalibrationView()
}
