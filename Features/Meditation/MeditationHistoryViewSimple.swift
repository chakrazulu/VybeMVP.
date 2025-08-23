import SwiftUI

// TODO: Import MeditationSession and related types when Xcode recognizes the files

// MARK: - Numerology Color System

extension Color {
    /// Gets the numerology color for a given number (including master numbers)
    static func numerologyColor(for number: Int) -> Color {
        switch number {
        case 1: return Color(red: 0.9, green: 0.2, blue: 0.2)      // Vibrant red - Leadership
        case 2: return Color(red: 1.0, green: 0.6, blue: 0.2)      // Warm orange - Cooperation
        case 3: return Color(red: 1.0, green: 0.8, blue: 0.2)      // Bright yellow - Creativity
        case 4: return Color(red: 0.2, green: 0.7, blue: 0.3)      // Forest green - Stability
        case 5: return Color(red: 0.2, green: 0.5, blue: 0.9)      // Ocean blue - Freedom
        case 6: return Color(red: 0.4, green: 0.2, blue: 0.8)      // Deep indigo - Nurturing
        case 7: return Color(red: 0.6, green: 0.2, blue: 0.8)      // Royal purple - Spirituality
        case 8: return Color(red: 0.6, green: 0.4, blue: 0.2)      // Rich brown - Material success
        case 9: return Color(red: 0.9, green: 0.4, blue: 0.7)      // Rose pink - Universal love
        case 11: return Color(red: 0.2, green: 0.8, blue: 0.8)     // Cyan - Master intuition
        case 22: return Color(red: 0.4, green: 0.9, blue: 0.6)     // Mint - Master builder
        case 33: return Color(red: 0.3, green: 0.7, blue: 0.7)     // Teal - Master teacher
        case 44: return Color(red: 0.8, green: 0.3, blue: 0.9)     // Violet - Master healer/manifestor
        default: return Color.gray                                   // Fallback
        }
    }

    /// Reduces a number to single digit unless it's a master number (11, 22, 33, 44)
    static func getNumerologyNumber(_ number: Int) -> Int {
        // Check for master numbers first
        if number == 11 || number == 22 || number == 33 || number == 44 {
            return number
        }

        // Reduce to single digit
        var result = number
        while result > 9 {
            let digits = String(result).compactMap { $0.wholeNumberValue }
            result = digits.reduce(0, +)

            // Check if reduced number is a master number
            if result == 11 || result == 22 || result == 33 || result == 44 {
                break
            }
        }

        return result
    }
}

/// Gets a beautiful gradient for a session based on Focus + Realm numerology
func getSessionGradient(focusNumber: Int, realmNumber: Int) -> LinearGradient {
    let combinedNumber = focusNumber + realmNumber
    let numerologyNumber = Color.getNumerologyNumber(combinedNumber)

    let primaryColor = Color.numerologyColor(for: numerologyNumber)
    let secondaryColor = primaryColor.opacity(0.6)

    return LinearGradient(
        colors: [primaryColor, secondaryColor],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

/**
 * Simple Meditation History View - Progress Tracking Interface
 * ===========================================================
 *
 * Simplified meditation history interface that shows:
 * - Basic session statistics
 * - Progress milestones
 * - Achievement placeholders
 * - Future integration points for full history system
 *
 * This view provides the UI framework for meditation progress tracking
 * while the full MeditationHistoryManager system is being integrated.
 *
 * Created: August 2025
 * Version: 1.0.0 - Simplified progress interface
 */

struct MeditationHistoryViewSimple: View {

    // MARK: - Environment & Navigation

    @Environment(\.dismiss) private var dismiss

    // MARK: - Data Sources

    @StateObject private var historyManager = MeditationHistoryManager.shared

    // MARK: - View State

    @State private var selectedTab: HistoryTab = .sessions
    @State private var selectedTimeframe: TimeFrame = .month
    @State private var selectedSession: MeditationSession?

    // MARK: - View Tabs

    enum HistoryTab: String, CaseIterable {
        case sessions = "Sessions"
        case analytics = "Analytics"
        case achievements = "Achievements"

        var icon: String {
            switch self {
            case .sessions: return "list.bullet.circle.fill"
            case .analytics: return "chart.line.uptrend.xyaxis.circle.fill"
            case .achievements: return "trophy.circle.fill"
            }
        }
    }

    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // MARK: - Header Stats
                headerStatsSection

                // MARK: - Tab Navigation
                tabNavigationSection

                // MARK: - Main Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        switch selectedTab {
                        case .sessions:
                            sessionsContent
                        case .analytics:
                            analyticsContent
                        case .achievements:
                            achievementsContent
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Meditation History")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    timeFramePicker
                }
            }
            .onAppear {
                // Force refresh the history manager
                historyManager.objectWillChange.send()
            }
            .sheet(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
        }
    }

    // MARK: - Header Stats

    private var headerStatsSection: some View {
        VStack(spacing: 16) {

            // Key metrics row
            HStack(spacing: 20) {

                // Total sessions
                StatCardSimple(
                    icon: "figure.meditation",
                    value: "\(historyManager.totalSessions)",
                    label: "Sessions",
                    color: .blue
                )

                // Total time
                StatCardSimple(
                    icon: "clock.fill",
                    value: formatTotalTime(historyManager.totalMeditationTime),
                    label: "Total Time",
                    color: .green
                )

                // Current streak
                StatCardSimple(
                    icon: "flame.fill",
                    value: "\(historyManager.currentStreak)",
                    label: "Day Streak",
                    color: .orange
                )

                // Personal best
                StatCardSimple(
                    icon: "arrow.down.circle.fill",
                    value: "\(Int(historyManager.personalBestImprovement))",
                    label: "Best -BPM",
                    color: .purple
                )
            }

            // Progress message
            Text(getProgressMessage())
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }

    // MARK: - Tab Navigation

    private var tabNavigationSection: some View {
        HStack(spacing: 0) {
            ForEach(HistoryTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.title3)

                        Text(tab.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            // Selected tab indicator
            VStack {
                Spacer()
                HStack {
                    ForEach(HistoryTab.allCases, id: \.self) { tab in
                        Rectangle()
                            .fill(selectedTab == tab ? Color.blue : Color.clear)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        )
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }

    // MARK: - Time Frame Picker

    private var timeFramePicker: some View {
        Menu {
            ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                Button(action: {
                    selectedTimeframe = timeframe
                }) {
                    HStack {
                        Text(timeframe.rawValue)
                        if selectedTimeframe == timeframe {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedTimeframe.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .foregroundColor(.blue)
        }
    }

    // MARK: - Sessions Content

    private var sessionsContent: some View {
        VStack(spacing: 20) {

            if historyManager.sessions.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "figure.meditation")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary.opacity(0.5))

                    Text("No Sessions Yet")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    Text("Start your first meditation to begin tracking your progress and achievements.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Call to action
                    VStack(spacing: 12) {
                        Text("Ready to begin?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Button(action: { dismiss() }) {
                            Text("Start Your First Meditation")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 20)
                }
                .padding(.vertical, 40)
            } else {
                // Sessions list
                LazyVStack(spacing: 16) {
                    ForEach(getFilteredSessions()) { session in
                        SessionCard(session: session) {
                            selectedSession = session
                        }
                    }
                }
            }
        }
    }

    // MARK: - Analytics Content

    private var analyticsContent: some View {
        VStack(spacing: 24) {

            if historyManager.sessions.isEmpty {
                // Progress placeholder - only show when no sessions
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 50))
                        .foregroundColor(.green.opacity(0.6))

                    Text("Your Analytics Await")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("Complete meditation sessions to unlock:\n• Heart rate improvement trends\n• Consistency patterns\n• Personal achievement graphs")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 40)
            } else {
                // Show actual analytics
                LazyVStack(spacing: 20) {

                    // Personal Best Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Progress")
                            .font(.headline)
                            .fontWeight(.semibold)

                        HStack(spacing: 16) {
                            AnalyticCard(
                                icon: "arrow.down.circle.fill",
                                title: "Personal Best",
                                value: "\(Int(historyManager.personalBestImprovement)) BPM",
                                subtitle: "Improvement",
                                color: .purple
                            )

                            AnalyticCard(
                                icon: "clock.fill",
                                title: "Average Session",
                                value: formatTotalTime(historyManager.averageSessionLength),
                                subtitle: "Duration",
                                color: .blue
                            )
                        }

                        HStack(spacing: 16) {
                            AnalyticCard(
                                icon: "heart.fill",
                                title: "Optimal BPM",
                                value: "\(historyManager.totalOptimalBPMAchievements)",
                                subtitle: "Achieved",
                                color: .red
                            )

                            AnalyticCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Weekly Sessions",
                                value: "\(Int(historyManager.weeklyConsistency))",
                                subtitle: "This Week",
                                color: .green
                            )
                        }
                    }

                    // Most Practiced Type
                    if let favoriteType = historyManager.favoriteType {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorite Practice")
                                .font(.headline)
                                .fontWeight(.semibold)

                            HStack(spacing: 16) {
                                Image(systemName: favoriteType.icon)
                                    .font(.title2)
                                    .foregroundColor(favoriteType.primaryColor)
                                    .frame(width: 40, height: 40)
                                    .background(favoriteType.primaryColor.opacity(0.1))
                                    .cornerRadius(20)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(favoriteType.displayName)
                                        .font(.headline)
                                        .fontWeight(.semibold)

                                    Text("\(historyManager.sessions(for: favoriteType).count) sessions completed")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                    }
                }
            }

            // Future features preview
            VStack(alignment: .leading, spacing: 16) {
                Text("Coming Soon")
                    .font(.headline)
                    .fontWeight(.semibold)

                FeaturePreviewCard(
                    icon: "waveform.path.ecg",
                    title: "Heart Rate Trends",
                    description: "View your meditation progress over time"
                )

                FeaturePreviewCard(
                    icon: "brain.head.profile",
                    title: "Mindfulness Insights",
                    description: "AI-powered meditation recommendations"
                )
            }
        }
    }

    // MARK: - Achievements Content

    private var achievementsContent: some View {
        VStack(spacing: 24) {

            // Achievement gallery placeholder
            VStack(spacing: 16) {
                Image(systemName: "trophy")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow.opacity(0.8))

                Text("Your Trophy Case")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("Earn achievements through meditation practice:\n• First Session\n• Heart Harmony\n• Meditation Master\n• Consistency Streaks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.vertical, 40)

            // Achievement preview
            VStack(alignment: .leading, spacing: 16) {
                Text("Upcoming Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)

                // TODO: Uncomment when AchievementPreviewCard is available
                /*
                AchievementPreviewCard(
                    icon: "star.fill",
                    title: "First Steps",
                    description: "Complete your first meditation session",
                    color: Color.blue
                )
                */
            }
        }
    }

    // MARK: - Helper Methods

    private func formatTotalTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(Int(seconds))s"
        }
    }

    private func getProgressMessage() -> String {
        if historyManager.totalSessions == 0 {
            return "Start meditating to track your spiritual journey!"
        } else if historyManager.totalSessions == 1 {
            return "Great start! Keep building your practice."
        } else if historyManager.currentStreak > 0 {
            return "Amazing! You're on a \(historyManager.currentStreak) day streak."
        } else {
            return "You've completed \(historyManager.totalSessions) sessions. Keep growing!"
        }
    }

    private func getFilteredSessions() -> [MeditationSession] {
        switch selectedTimeframe {
        case .week:
            return historyManager.recentSessions(days: 7)
        case .month:
            return historyManager.recentSessions(days: 30)
        case .year:
            return historyManager.recentSessions(days: 365)
        case .all:
            return historyManager.sessions
        }
    }
}

// MARK: - Session Card Component

struct SessionCard: View {
    let session: MeditationSession
    let onTap: () -> Void

    private var sessionGradient: LinearGradient {
        getSessionGradient(focusNumber: session.focusNumber, realmNumber: session.realmNumber)
    }

    private var numerologyNumber: Int {
        Color.getNumerologyNumber(session.focusNumber + session.realmNumber)
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {

                // Header with meditation type and numerology indicator
                HStack {
                    // Meditation type icon and name
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: session.type.icon)
                                .foregroundColor(.white)
                                .font(.title3)

                            Text(session.type.displayName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }

                        Text(formatSessionDate(session.date))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    // Numerology number indicator
                    VStack(spacing: 4) {
                        Text("\(numerologyNumber)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Numerology")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                    )
                }

                // Session metrics
                HStack(spacing: 16) {
                    SessionMetricWhite(
                        icon: "clock.fill",
                        value: formatDuration(session.duration),
                        label: "Duration"
                    )

                    if session.heartRateImprovement > 0 {
                        SessionMetricWhite(
                            icon: "arrow.down.circle.fill",
                            value: "-\(Int(session.heartRateImprovement))",
                            label: "BPM"
                        )
                    }

                    if session.coherenceAchievements > 0 {
                        SessionMetricWhite(
                            icon: "heart.fill",
                            value: "\(session.coherenceAchievements)",
                            label: "Coherent"
                        )
                    }

                    Spacer()

                    // Quality badge
                    HStack(spacing: 4) {
                        Image(systemName: session.sessionQuality.icon)
                            .font(.caption)
                        Text(session.sessionQuality.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(sessionGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func formatSessionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60

        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", remainingSeconds))"
        } else {
            return "\(remainingSeconds)s"
        }
    }
}

struct SessionMetric: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primary)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct SessionMetricWhite: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)

            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Supporting Views

struct AnalyticCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct StatCardSimple: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value.isEmpty ? "0" : value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.8), color.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct FeaturePreviewCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "lock.fill")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AchievementPreviewCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color.opacity(0.6))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Text("Locked")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary.opacity(0.7))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Session Detail View

struct SessionDetailView: View {
    let session: MeditationSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: session.type.icon)
                            .font(.system(size: 60))
                            .foregroundColor(session.type.primaryColor)

                        Text(session.type.displayName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(formatDetailedDate(session.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Key Metrics
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            DetailMetricCard(
                                icon: "clock.fill",
                                title: "Duration",
                                value: session.formattedDuration,
                                color: .blue
                            )

                            DetailMetricCard(
                                icon: "arrow.down.circle.fill",
                                title: "Improvement",
                                value: "-\(Int(session.heartRateImprovement)) BPM",
                                color: .green
                            )
                        }

                        HStack(spacing: 20) {
                            DetailMetricCard(
                                icon: "heart.fill",
                                title: "Coherence",
                                value: "\(session.coherenceAchievements)",
                                color: .red
                            )

                            DetailMetricCard(
                                icon: "star.fill",
                                title: "Quality",
                                value: session.sessionQuality.displayName,
                                color: session.sessionQuality.color
                            )
                        }
                    }

                    // Heart Rate Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Heart Rate Analysis")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 12) {
                            HRDetailRow(label: "Starting BPM", value: "\(Int(session.startingHeartRate))")
                            HRDetailRow(label: "Average BPM", value: "\(Int(session.averageHeartRate))")
                            HRDetailRow(label: "Lowest BPM", value: "\(Int(session.lowestHeartRate))")
                            HRDetailRow(label: "Coherence %", value: "\(Int(session.coherencePercentage * 100))%")
                            HRDetailRow(label: "Max Streak", value: "\(session.maxCoherenceStreak)s")
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }

                    // Spiritual Insights
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.purple)
                            Text("Spiritual Insight")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                        VStack(spacing: 8) {
                            HStack {
                                Text("Focus \(session.focusNumber) + Realm \(session.realmNumber) = \(session.focusNumber + session.realmNumber)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }

                            Text(session.spiritualInsight)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                            )
                    )

                    if session.personalBest {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("Personal Best Achievement!")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func formatDetailedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct HRDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Color Extensions
// Gold color is defined elsewhere in the project

#Preview {
    MeditationHistoryViewSimple()
}
