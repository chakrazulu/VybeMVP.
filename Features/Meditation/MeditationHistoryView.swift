import SwiftUI
import Charts

/**
 * Meditation History View - Personal Progress & Session Analytics
 * =============================================================
 *
 * Comprehensive meditation history interface featuring:
 * - Session timeline with detailed metrics and achievements
 * - Progress analytics with heart rate improvement trends
 * - Achievement gallery with earned milestones
 * - Weekly/monthly progress charts and insights
 * - Personal best tracking and streak visualization
 *
 * ## 📊 Key Features
 *
 * **Session Timeline:**
 * - Chronological list of all meditation sessions
 * - Heart rate data, duration, and quality indicators
 * - Meditation type icons and achievement badges
 * - Tap to expand for detailed session insights
 *
 * **Progress Analytics:**
 * - Heart rate improvement trends over time
 * - Meditation consistency patterns (streaks, frequency)
 * - Personal best achievements and progress milestones
 * - Type-specific analytics (favorite practices, success rates)
 *
 * **Achievement System:**
 * - Visual achievement gallery with earned badges
 * - Progress towards next milestones
 * - Streak tracking and consistency rewards
 * - Optimal BPM mastery celebrations
 *
 * ## 🎯 Integration Points
 *
 * - MeditationHistoryManager: Session data and achievement tracking
 * - KASPER MLX: Personalized insights and recommendations
 * - HealthKit: Historical heart rate trends and biometric correlation
 * - Focus/Realm Numbers: Numerological progress patterns
 *
 * Created: August 2025
 * Version: 1.0.0 - Comprehensive meditation progress tracking
 */

struct MeditationHistoryView: View {

    // MARK: - Environment & Data

    @Environment(\.dismiss) private var dismiss
    // @StateObject private var historyManager = MeditationHistoryManager.shared // Temporarily disabled
    @StateObject private var focusNumberManager = FocusNumberManager.shared

    // MARK: - View State

    @State private var selectedTab: HistoryTab = .sessions
    @State private var selectedTimeframe: TimeFrame = .month
    @State private var expandedSession: UUID? = nil
    @State private var showingSessionDetail = false
    // @State private var detailSession: MeditationSession? = nil // Temporarily disabled

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

        var days: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .year: return 365
            case .all: return nil
            }
        }
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
                    LazyVStack(spacing: 0) {
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Done") { dismiss() },
                trailing: timeFramePicker
            )
        }
        // .sheet(item: $detailSession) { session in
        //     SessionDetailView(session: session)
        // } // Temporarily disabled
    }

    // MARK: - Header Stats

    private var headerStatsSection: some View {
        VStack(spacing: 16) {

            // Key metrics row
            HStack(spacing: 20) {

                // Total sessions
                VStack(spacing: 8) {
                    Image(systemName: "figure.meditation")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("0")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Sessions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(12)

                // Total time
                VStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                    Text("0m")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Total Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(12)

                // Current streak
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("0")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(12)

                // Personal best
                VStack(spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                    Text("0")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Best -BPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }

            // Progress towards next milestone
            nextMilestoneProgress
        }
        .padding()
        .background(Color(.systemGray6))
    }

    // MARK: - Next Milestone Progress

    private var nextMilestoneProgress: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progress to Next Milestone")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Spacer()

                Text(nextMilestoneText)
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(
                            width: geometry.size.width * nextMilestoneProgressValue,
                            height: 8
                        )
                        .animation(.easeInOut(duration: 0.5), value: nextMilestoneProgressValue)
                }
            }
            .frame(height: 8)
        }
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
                    if selectedTab == .sessions {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    }

                    if selectedTab == .analytics {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    }

                    if selectedTab == .achievements {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .frame(maxWidth: .infinity)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
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
        LazyVStack(spacing: 16) {

            // Recent sessions list (temporarily disabled)
            // ForEach(filteredSessions) { session in
            //     SessionCard(session: session, ...)
            // }

            // Empty state
            if filteredSessions.isEmpty {
                emptySessionsState
            }
        }
    }

    // MARK: - Analytics Content

    private var analyticsContent: some View {
        VStack(spacing: 24) {

            // Heart rate improvement chart
            heartRateImprovementChart

            // Meditation consistency chart
            consistencyChart

            // Type breakdown
            meditationTypeBreakdown

            // Weekly insights
            weeklyInsights
        }
    }

    // MARK: - Achievements Content

    private var achievementsContent: some View {
        VStack(spacing: 24) {

            // Achievement gallery
            achievementGallery

            // Progress towards achievements
            achievementProgress

            // Streak milestones
            streakMilestones
        }
    }

    // MARK: - Heart Rate Improvement Chart

    private var heartRateImprovementChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Heart Rate Improvement Trend")
                .font(.headline)
                .fontWeight(.semibold)

            // Chart placeholder (would use real Charts framework)
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 40))
                            .foregroundColor(.green)

                        Text("Improvement Over Time")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                )
        }
    }

    // MARK: - Consistency Chart

    private var consistencyChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meditation Consistency")
                .font(.headline)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                VStack {
                    Text("0.0")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Text("Sessions/Week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                VStack {
                    Text("0")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)

                    Text("Longest Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                VStack {
                    Text("0")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)

                    Text("Optimal BPMs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }

    // MARK: - Meditation Type Breakdown

    private var meditationTypeBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Practices")
                .font(.headline)
                .fontWeight(.semibold)

            // Favorite type display (temporarily disabled)
            Text("Complete more sessions to see your favorite meditation type!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }

    // MARK: - Weekly Insights

    private var weeklyInsights: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week's Insights")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                InsightCard(
                    icon: "brain.head.profile",
                    title: "Ready to Begin",
                    description: "Start your meditation practice to unlock weekly insights and progress tracking!"
                )
            }
        }
    }

    // MARK: - Achievement Gallery

    private var achievementGallery: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Earned Achievements")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                Image(systemName: "trophy")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary.opacity(0.5))

                Text("Start meditating to earn achievements!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        }
    }

    // MARK: - Achievement Progress

    private var achievementProgress: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Towards Next Goals")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                ProgressGoalCard(
                    title: "First Heart Coherence",
                    description: "Achieve your first coherence state",
                    progress: 0.0,
                    color: .green
                )

                ProgressGoalCard(
                    title: "7 Day Streak",
                    description: "Meditate consistently for 7 days",
                    progress: 0.0,
                    color: .orange
                )
            }
        }
    }

    // MARK: - Streak Milestones

    private var streakMilestones: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streak Milestones")
                .font(.headline)
                .fontWeight(.semibold)

            HStack(spacing: 20) {
                ForEach([7, 30, 100], id: \.self) { milestone in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)

                            Text("\(milestone)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }

                        Text("\(milestone) Days")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Empty Sessions State

    private var emptySessionsState: some View {
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
        }
        .padding(.vertical, 60)
    }

    // MARK: - Computed Properties

    private var filteredSessions: [String] {
        return [] // Empty for now
    }

    private var nextMilestoneText: String {
        return "Start meditating to track progress!"
    }

    private var nextMilestoneProgressValue: Double {
        return 0.0
    }

    // MARK: - Helper Methods

    private func formatTotalTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    private func getNextStreakTarget() -> Int {
        let current = 0 // historyManager.currentStreak
        let milestones = [7, 30, 100, 365]

        for milestone in milestones {
            if current < milestone {
                return milestone
            }
        }

        return current + 30 // Next 30-day increment
    }
}

// MARK: - Supporting Views
// StatCard is imported from SharedUIComponents

/* struct SessionCard: View {
    let session: MeditationSession
    let isExpanded: Bool
    let onTap: () -> Void
    let onDetailTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Main session info
            Button(action: onTap) {
                HStack(spacing: 16) {
                    // Meditation type icon
                    ZStack {
                        Circle()
                            .fill(session.type.primaryColor.opacity(0.2))
                            .frame(width: 50, height: 50)

                        Image(systemName: session.type.icon)
                            .font(.title3)
                            .foregroundColor(session.type.primaryColor)
                    }

                    // Session details
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(session.type.displayName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)

                            Spacer()

                            // Quality indicator
                            HStack(spacing: 4) {
                                Image(systemName: session.sessionQuality.icon)
                                    .font(.caption)
                                    .foregroundColor(session.sessionQuality.color)

                                Text(session.sessionQuality.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(session.sessionQuality.color)
                            }
                        }

                        Text(formatSessionDate(session.date))
                            .font(.caption)
                            .foregroundColor(.secondary)

                        // Key metrics row
                        HStack(spacing: 12) {
                            Label("\(formatDuration(session.duration))", systemImage: "clock")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if session.heartRateImprovement > 0 {
                                Label("-\(Int(session.heartRateImprovement))", systemImage: "arrow.down")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }

                            if session.achievedOptimalBPM {
                                Label("Optimal", systemImage: "crown.fill")
                                    .font(.caption)
                                    .foregroundColor(.gold)
                            }
                        }
                    }

                    // Expand indicator
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())

            // Expanded details
            if isExpanded {
                VStack(spacing: 12) {
                    Divider()

                    // Detailed metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        MetricItem(title: "Starting BPM", value: "\(Int(session.startingHeartRate))", color: .blue)
                        MetricItem(title: "Average BPM", value: "\(Int(session.averageHeartRate))", color: .green)
                        MetricItem(title: "Lowest BPM", value: "\(Int(session.lowestHeartRate))", color: .purple)
                        MetricItem(title: "Coherence", value: "\(session.coherenceAchievements)", color: .cyan)
                        MetricItem(title: "Max Streak", value: "\(session.maxCoherenceStreak)", color: .orange)
                        MetricItem(title: "Focus #", value: "\(session.focusNumber)", color: .indigo)
                    }

                    // Detail button
                    Button(action: onDetailTap) {
                        Text("View Full Details")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .animation(.spring(), value: isExpanded)
    }

    private func formatSessionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes)min"
    }
} */

struct MetricItem: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)

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
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/* struct AchievementBadge: View {
    let achievement: MeditationAchievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(achievement.color), Color(achievement.color).opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)

                Image(systemName: achievement.icon)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Text(achievement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text(formatAchievementDate(achievement.dateEarned))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func formatAchievementDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
} */

struct ProgressGoalCard: View {
    let title: String
    let description: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(
                            width: geometry.size.width * progress,
                            height: 8
                        )
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Session Detail View

/* struct SessionDetailView: View {
    let session: MeditationSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Session header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(session.type.primaryColor.opacity(0.2))
                                .frame(width: 80, height: 80)

                            Image(systemName: session.type.icon)
                                .font(.system(size: 40))
                                .foregroundColor(session.type.primaryColor)
                        }

                        Text(session.type.displayName)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(formatDetailDate(session.date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Detailed metrics grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        DetailMetricCard(title: "Duration", value: formatDetailDuration(session.duration), icon: "clock.fill", color: .blue)
                        DetailMetricCard(title: "Quality", value: session.sessionQuality.displayName, icon: session.sessionQuality.icon, color: session.sessionQuality.color)
                        DetailMetricCard(title: "Starting BPM", value: "\(Int(session.startingHeartRate))", icon: "heart.fill", color: .red)
                        DetailMetricCard(title: "Average BPM", value: "\(Int(session.averageHeartRate))", icon: "heart.circle.fill", color: .green)
                        DetailMetricCard(title: "Lowest BPM", value: "\(Int(session.lowestHeartRate))", icon: "arrow.down.heart.fill", color: .purple)
                        DetailMetricCard(title: "Improvement", value: "\(Int(session.heartRateImprovement))", icon: "arrow.down.circle.fill", color: .mint)
                        DetailMetricCard(title: "Coherence", value: "\(session.coherenceAchievements)", icon: "waveform.path.ecg", color: .cyan)
                        DetailMetricCard(title: "Focus Number", value: "\(session.focusNumber)", icon: "target", color: .indigo)
                    }

                    // Achievement highlights
                    if session.achievedOptimalBPM || session.heartRateImprovement >= 5.0 {
                        achievementHighlights
                    }

                    // Session notes (if any)
                    if let notes = session.userNotes, !notes.isEmpty {
                        sessionNotes(notes)
                    }
                }
                .padding()
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }

    private var achievementHighlights: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 8) {
                if session.achievedOptimalBPM {
                    AchievementHighlight(
                        icon: "crown.fill",
                        title: "Optimal BPM Mastery",
                        description: "Achieved age-optimal heart rate",
                        color: .gold
                    )
                }

                if session.heartRateImprovement >= 10.0 {
                    AchievementHighlight(
                        icon: "bolt.fill",
                        title: "Major Transformation",
                        description: "\(Int(session.heartRateImprovement)) BPM improvement",
                        color: .orange
                    )
                } else if session.heartRateImprovement >= 5.0 {
                    AchievementHighlight(
                        icon: "star.fill",
                        title: "Great Progress",
                        description: "\(Int(session.heartRateImprovement)) BPM improvement",
                        color: .yellow
                    )
                }
            }
        }
    }

    private func sessionNotes(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Notes")
                .font(.headline)
                .fontWeight(.semibold)

            Text(notes)
                .font(.body)
                .foregroundColor(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }

    private func formatDetailDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatDetailDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
}

struct DetailMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
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
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct AchievementHighlight: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
} */

// MARK: - Color Extension
// Gold color is defined elsewhere

#Preview {
    MeditationHistoryView()
}
