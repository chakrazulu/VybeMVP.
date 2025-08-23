import SwiftUI

/**
 * Meditation Configuration View - Session Setup Interface
 * ======================================================
 *
 * Simple configuration interface allowing users to customize their meditation session:
 * - Duration selection (1-30 minutes or open-ended)
 * - Quick start with recommended settings
 * - Type-specific guidance and expectations
 *
 * ## Integration
 *
 * - Connects MeditationSelectionView → HRVBiofeedbackView
 * - Passes selected duration to biofeedback session
 * - Uses type-specific recommendations from MeditationSessionConfig
 *
 * Created: August 2025
 * Version: 1.0.0 - Session configuration interface
 */

struct MeditationConfigurationView: View {

    // MARK: - Configuration

    let meditationType: MeditationType
    let onStartSession: (MeditationSessionConfig) -> Void
    let onCancel: () -> Void

    // MARK: - Selection State

    @State private var selectedDuration: Int? = nil
    @State private var useRecommended: Bool = true

    // Duration options in minutes
    private let durationOptions: [Int] = [1, 3, 5, 10, 15, 20, 30]

    // MARK: - Computed Properties

    private var recommendedConfig: MeditationSessionConfig {
        MeditationSessionConfig.recommended(for: meditationType)
    }

    private var recommendedDurationMinutes: Int? {
        guard let duration = recommendedConfig.duration else { return nil }
        return Int(duration / 60)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    headerSection

                    // MARK: - Duration Selection
                    durationSelectionSection

                    // MARK: - Session Preview
                    sessionPreviewSection

                    // MARK: - Start Button
                    startButtonSection

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Configure Session")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { onCancel() },
                trailing: EmptyView()
            )
        }
        .onAppear {
            // Set recommended duration by default
            selectedDuration = recommendedDurationMinutes
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {

            // Meditation type icon and name
            VStack(spacing: 12) {
                Image(systemName: meditationType.icon)
                    .font(.system(size: 50))
                    .foregroundColor(meditationType.primaryColor)

                Text(meditationType.displayName)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(meditationType.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }

    // MARK: - Duration Selection

    private var durationSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Session Duration")
                .font(.headline)
                .fontWeight(.semibold)

            // Recommended duration option
            if let recommended = recommendedDurationMinutes {
                Button(action: {
                    selectedDuration = recommended
                    useRecommended = true
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.orange)
                                Text("Recommended")
                                    .fontWeight(.semibold)
                            }

                            Text("\(recommended) minutes - Optimal for \(meditationType.displayName.lowercased())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: selectedDuration == recommended && useRecommended ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedDuration == recommended && useRecommended ? .orange : .secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedDuration == recommended && useRecommended ? Color.orange.opacity(0.1) : Color(.secondarySystemGroupedBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedDuration == recommended && useRecommended ? Color.orange : Color.clear, lineWidth: 2)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Open-ended option
            Button(action: {
                selectedDuration = nil
                useRecommended = false
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Open-Ended")
                            .fontWeight(.semibold)

                        Text("Meditate as long as you feel called to continue")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: selectedDuration == nil ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedDuration == nil ? .blue : .secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedDuration == nil ? Color.blue.opacity(0.1) : Color(.secondarySystemGroupedBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedDuration == nil ? Color.blue : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Custom duration options
            Text("Custom Duration")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.top, 8)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(durationOptions, id: \.self) { duration in
                    Button(action: {
                        selectedDuration = duration
                        useRecommended = false
                    }) {
                        Text("\(duration)m")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedDuration == duration && !useRecommended ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedDuration == duration && !useRecommended ? meditationType.primaryColor : Color(.secondarySystemGroupedBackground))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // MARK: - Session Preview

    private var sessionPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Session Preview")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 12) {

                PreviewRow(
                    icon: "clock.fill",
                    title: "Duration",
                    value: selectedDuration.map { "\($0) minutes" } ?? "Open-ended",
                    color: .blue
                )

                PreviewRow(
                    icon: "heart.fill",
                    title: "Biofeedback",
                    value: "Real-time HRV monitoring",
                    color: .red
                )

                PreviewRow(
                    icon: "brain.head.profile",
                    title: "Guidance",
                    value: meditationType.openingMessage.prefix(30) + "...",
                    color: .purple
                )

                PreviewRow(
                    icon: "sparkles",
                    title: "Completion",
                    value: "Spiritual insights + session analytics",
                    color: .orange
                )
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }

    // MARK: - Start Button

    private var startButtonSection: some View {
        VStack(spacing: 12) {

            Button(action: {
                let config = createConfiguration()
                onStartSession(config)
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start \(meditationType.displayName)")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(meditationType.primaryColor)
                .cornerRadius(12)
            }

            Text("Your session will begin with a 10-second preparation countdown")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Helper Methods

    private func createConfiguration() -> MeditationSessionConfig {
        let duration: TimeInterval? = selectedDuration.map { TimeInterval($0 * 60) }

        return MeditationSessionConfig(
            duration: duration,
            showCountdown: true,
            autoEnd: true,
            showHRVBiofeedback: true,
            showSineWaves: true,
            hrvImprovementThreshold: meditationType.improvementThreshold,
            useProgressiveRewards: true,
            audioGuidanceLevel: .minimal,
            playBackgroundSounds: false,
            backgroundSoundVolume: 0.3,
            primaryColor: "#007AFF", // Default blue - can be enhanced later with proper color conversion
            showAchievementAnimations: true,
            showChakraIndicators: true,
            achievementThresholds: .standard,
            trackForAchievements: true,
            messageRotationInterval: 30.0,
            showTypeSpecificMessages: true
        )
    }
}

// MARK: - Supporting Views

struct PreviewRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)

            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    MeditationConfigurationView(
        meditationType: .gratitude,
        onStartSession: { _ in },
        onCancel: { }
    )
}
