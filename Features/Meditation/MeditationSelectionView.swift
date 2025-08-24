import SwiftUI

/**
 * Meditation Selection View - Choose Your Spiritual Practice
 * =========================================================
 *
 * Beautiful interface for selecting meditation types with:
 * - KASPER MLX persona-aware recommendations
 * - Visual cards showing each meditation style
 * - Integration with user's numerology data for suggestions
 * - Seamless connection to full-screen meditation sessions
 *
 * ## 🎭 Persona Integration
 *
 * Each meditation type connects to appropriate KASPER personas:
 * - Affirmation → MindfulnessCoach (empowering guidance)
 * - Reflective → AlanWatts (philosophical depth)
 * - Trauma Healing → CarlJung (psychological insight)
 * - Gratitude → Oracle (spiritual wisdom)
 * - Chakra Balancing → NumerologyScholar (energy expertise)
 *
 * ## 🌊 User Experience Flow
 *
 * 1. User sees personalized recommendations based on realm/focus numbers
 * 2. Selects meditation type with visual preview
 * 3. Configures session (duration, biofeedback, guidance level)
 * 4. Launches dedicated full-screen meditation experience
 * 5. Returns to selection view with session history/progress
 *
 * Created: August 2025
 * Version: 1.0.0 - Meditation type selection interface
 */

struct MeditationSelectionView: View {

    // MARK: - Environment & Navigation

    /// Navigation back to main app
    @Environment(\.presentationMode) var presentationMode

    /// Focus number manager for accessing user's numerology data and personalized recommendations
    @StateObject private var focusNumberManager = FocusNumberManager.shared

    // MARK: - Selection State

    /// Sheet presentation state
    @State private var activeSheet: ActiveSheet? = nil

    /// Currently selected meditation type
    @State private var selectedMeditationType: MeditationType?

    /// Selected session configuration
    @State private var sessionConfig: MeditationSessionConfig?

    enum ActiveSheet: Identifiable {
        case configuration(MeditationType)
        case meditation(MeditationType, MeditationSessionConfig)
        case history

        var id: String {
            switch self {
            case .configuration(let type): return "config-\(type.rawValue)"
            case .meditation(let type, _): return "meditation-\(type.rawValue)"
            case .history: return "history"
            }
        }
    }



    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {

                // MARK: - Header
                headerSection

                // MARK: - Personalized Recommendations
                recommendedSection

                // MARK: - All Meditation Types
                allMeditationTypesSection

            }
            .padding()
        }
        .navigationTitle("Choose Your Practice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    activeSheet = .history
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .configuration(let meditationType):
                MeditationConfigurationView(
                    meditationType: meditationType,
                    onStartSession: { config in
                        // Start the meditation with the selected configuration
                        sessionConfig = config
                        activeSheet = .meditation(meditationType, config)
                    },
                    onCancel: {
                        activeSheet = nil
                    }
                )
            case .meditation(let meditationType, let config):
                HRVBiofeedbackView(
                    meditationType: meditationType,
                    duration: getDurationInMinutes(from: config)
                ) {
                    // Safely dismiss only if sheet is still active
                    // This prevents duplicate dismissal attempts
                    if activeSheet != nil {
                        activeSheet = nil
                    }
                }
                .environmentObject(FocusNumberManager.shared)
            case .history:
                MeditationHistoryViewSimple()
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {

            // Spiritual greeting based on time of day
            Text(spiritualGreeting)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Text("What does your soul need today?")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical)
    }

    // MARK: - Personalized Recommendations

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)

                Text("Recommended for You")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(personalizedRecommendations) { meditationType in
                        RecommendedMeditationCard(
                            meditationType: meditationType,
                            reason: getRecommendationReason(for: meditationType)
                        ) {
                            activeSheet = .configuration(meditationType)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - All Meditation Types

    private var allMeditationTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("All Practices")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(MeditationType.allCases) { meditationType in
                    MeditationTypeCard(meditationType: meditationType) {
                        activeSheet = .configuration(meditationType)
                    }
                }
            }
        }
    }

    // MARK: - Computed Properties

    /// Personalized meditation recommendations based on user's numerology
    private var personalizedRecommendations: [MeditationType] {
        var recommendations: [MeditationType] = []

        // Get user's current focus number for personalized recommendations
        let focusNumber = focusNumberManager.selectedFocusNumber

        // Numerology-based meditation recommendations
        switch focusNumber {
        case 1:
            recommendations = [.affirmation, .manifestation, .breathwork]  // Leadership energy
        case 2:
            recommendations = [.lovingKindness, .gratitude, .reflective]   // Harmony and cooperation
        case 3:
            recommendations = [.affirmation, .gratitude, .chakraBalancing] // Creative expression
        case 4:
            recommendations = [.breathwork, .reflective, .traumaTherapy]   // Stability and healing
        case 5:
            recommendations = [.manifestation, .breathwork, .affirmation]  // Freedom and change
        case 6:
            recommendations = [.lovingKindness, .traumaTherapy, .gratitude] // Nurturing and service
        case 7:
            recommendations = [.reflective, .chakraBalancing, .breathwork]  // Spiritual seeking
        case 8:
            recommendations = [.manifestation, .affirmation, .reflective]  // Material mastery
        case 9:
            recommendations = [.lovingKindness, .gratitude, .traumaTherapy] // Universal love
        default:
            // Default varied recommendations for undefined numbers
            recommendations = [.gratitude, .affirmation, .reflective]
        }

        return Array(recommendations.prefix(3)) // Limit to 3 recommendations
    }

    /// Time-based spiritual greeting
    private var spiritualGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good morning, beautiful soul ☀️"
        case 12..<17:
            return "Welcome back, radiant being ✨"
        case 17..<21:
            return "Evening blessings, peaceful heart 🌅"
        default:
            return "Night time wisdom, gentle spirit 🌙"
        }
    }

    // MARK: - Helper Methods

    /// Converts session configuration duration to minutes for HRVBiofeedbackView
    private func getDurationInMinutes(from config: MeditationSessionConfig) -> Int? {
        guard let duration = config.duration else { return nil }
        return Int(duration / 60)
    }

    /// Gets the numerology-based reason why a meditation type is recommended for this user
    private func getRecommendationReason(for type: MeditationType) -> String {
        let focusNumber = focusNumberManager.selectedFocusNumber

        // Provide numerology-specific reasons based on focus number and meditation type
        switch (focusNumber, type) {
        case (1, .affirmation):
            return "Perfect for your leadership energy - affirm your power!"
        case (1, .manifestation):
            return "Channel your pioneering spirit into creation"
        case (2, .lovingKindness):
            return "Harmonizes with your cooperative, loving nature"
        case (3, .gratitude):
            return "Amplifies your natural joy and creative expression"
        case (4, .breathwork):
            return "Provides the stability and grounding you seek"
        case (5, .manifestation):
            return "Perfect for your transformative, freedom-seeking energy"
        case (6, .traumaTherapy):
            return "Nurtures your healing gifts and service to others"
        case (7, .reflective):
            return "Matches your deep spiritual seeking nature"
        case (8, .manifestation):
            return "Harness your material mastery for higher goals"
        case (9, .lovingKindness):
            return "Expresses your universal love and compassion"
        default:
            // Fallback to general reasons
            switch type {
            case .gratitude:
                return "Opens your heart to universal appreciation"
            case .affirmation:
                return "Aligns with your personal empowerment"
            case .reflective:
                return "Deepens your spiritual wisdom"
            case .traumaTherapy:
                return "Gentle healing for your sacred journey"
            case .manifestation:
                return "Amplifies your creative visualization powers"
            case .chakraBalancing:
                return "Harmonizes your spiritual energy centers"
            case .breathwork:
                return "Grounds your energy through sacred breath"
            case .lovingKindness:
                return "Expands your compassionate heart energy"
            }
        }
    }

    /// Handles completion of a meditation session
    private func handleSessionComplete(_ result: MeditationSessionResult) {
        // Here you would save session data, update progress, etc.
        print("🧘‍♀️ Session completed: \(result.type.displayName) for \(result.duration) seconds")

        // Could integrate with KASPER MLX to learn user preferences
        // Could update user's spiritual progress tracking
        // Could trigger achievements or insights
    }
}

// MARK: - Meditation Type Card

struct MeditationTypeCard: View {
    let meditationType: MeditationType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {

                // Icon
                Image(systemName: meditationType.icon)
                    .font(.system(size: 32))
                    .foregroundColor(meditationType.primaryColor)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(meditationType.primaryColor.opacity(0.1))
                    )

                // Name
                Text(meditationType.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.8)

                // Description
                Text(meditationType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.8)

            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: meditationType.primaryColor.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Recommended Meditation Card

struct RecommendedMeditationCard: View {
    let meditationType: MeditationType
    let reason: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Image(systemName: meditationType.icon)
                        .font(.title2)
                        .foregroundColor(meditationType.primaryColor)

                    Spacer()

                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                Text(meditationType.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)

                Text(reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)

                Spacer()

                HStack {
                    Text("Start Session")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(meditationType.primaryColor)

                    Spacer()

                    Image(systemName: "arrow.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(meditationType.primaryColor)
                }
            }
            .frame(width: 360, height: 180)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                meditationType.primaryColor.opacity(0.05),
                                meditationType.primaryColor.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(meditationType.primaryColor.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    MeditationSelectionView()
}
