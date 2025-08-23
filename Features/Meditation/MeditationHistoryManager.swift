import Foundation
import SwiftUI
import Combine

/**
 * Meditation History Manager - Session Data & Progress Tracking
 * =============================================================
 *
 * Comprehensive meditation session management with persistent storage,
 * achievement tracking, and analytics computation.
 *
 * ## Core Features
 *
 * **Session Management:**
 * - Save and retrieve meditation sessions
 * - Persistent storage using UserDefaults/CoreData
 * - Session validation and data integrity
 *
 * **Achievement System:**
 * - Track meditation streaks and milestones
 * - Award achievements for progress
 * - Personal best tracking
 *
 * **Analytics & Insights:**
 * - Weekly/monthly consistency metrics
 * - Heart rate improvement trends
 * - Session quality analysis
 * - Progress statistics
 *
 * Created: August 2025
 * Version: 1.0.0 - Core meditation history management
 */

class MeditationHistoryManager: ObservableObject {

    // MARK: - Singleton

    static let shared = MeditationHistoryManager()

    // MARK: - Published Properties

    @Published var sessions: [MeditationSession] = []
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var totalSessions: Int = 0
    @Published var totalTime: TimeInterval = 0
    @Published var achievements: Set<MeditationAchievement> = []

    // MARK: - Storage Keys

    private let sessionsKey = "meditation_sessions"
    private let achievementsKey = "meditation_achievements"
    private let statsKey = "meditation_stats"

    // MARK: - Initialization

    private init() {
        loadSessions()
        loadAchievements()
        updateStats()

        // Add sample session for testing if no sessions exist
        if sessions.isEmpty {
            addSampleSession()
        }
    }

    // MARK: - Session Management

    func saveSession(_ session: MeditationSession) {
        sessions.insert(session, at: 0) // Most recent first
        persistSessions()
        updateStats()
        checkAchievements(for: session)

        // Trigger UI updates
        objectWillChange.send()
    }

    func deleteSession(_ session: MeditationSession) {
        sessions.removeAll { $0.id == session.id }
        persistSessions()
        updateStats()
        objectWillChange.send()
    }

    // MARK: - Analytics

    var weeklyConsistency: Double {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentSessions = sessions.filter { $0.date >= oneWeekAgo }
        return Double(recentSessions.count)
    }

    var totalOptimalBPMAchievements: Int {
        return sessions.filter { $0.achievedOptimalBPM }.count
    }

    var personalBestImprovement: Double {
        return sessions.map { $0.heartRateImprovement }.max() ?? 0.0
    }

    var averageSessionLength: TimeInterval {
        guard !sessions.isEmpty else { return 0 }
        return totalTime / Double(sessions.count)
    }

    var favoriteType: MeditationType? {
        guard !sessions.isEmpty else { return nil }

        let typeData = Dictionary(grouping: sessions, by: { $0.type })
            .mapValues { sessions -> (count: Int, totalTime: TimeInterval, mostRecent: Date) in
                let count = sessions.count
                let totalTime = sessions.reduce(0) { $0 + $1.duration }
                let mostRecent = sessions.map(\.date).max() ?? Date.distantPast
                return (count, totalTime, mostRecent)
            }

        // Find the type with the most sessions, breaking ties with total time, then recency
        return typeData.max { (lhs, rhs) in
            if lhs.value.count != rhs.value.count {
                return lhs.value.count < rhs.value.count
            } else if lhs.value.totalTime != rhs.value.totalTime {
                return lhs.value.totalTime < rhs.value.totalTime
            } else {
                return lhs.value.mostRecent < rhs.value.mostRecent
            }
        }?.key
    }

    var totalMeditationTime: TimeInterval {
        return totalTime
    }

    // MARK: - Filtering

    func sessions(for timeframe: TimeFrame) -> [MeditationSession] {
        guard let days = timeframe.days else { return sessions }

        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return sessions.filter { $0.date >= cutoffDate }
    }

    func recentSessions(days: Int) -> [MeditationSession] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return sessions.filter { $0.date >= cutoffDate }
    }

    func sessions(for type: MeditationType) -> [MeditationSession] {
        return sessions.filter { $0.type == type }
    }

    // MARK: - Streak Calculation

    private func calculateStreaks() {
        guard !sessions.isEmpty else {
            currentStreak = 0
            longestStreak = 0
            return
        }

        let calendar = Calendar.current
        let sortedSessions = sessions.sorted { $0.date > $1.date }

        // Calculate current streak
        currentStreak = 0
        longestStreak = 0
        var tempStreak = 0
        var lastDate: Date?

        for session in sortedSessions {
            let sessionDay = calendar.startOfDay(for: session.date)

            if let last = lastDate {
                let daysBetween = calendar.dateComponents([.day], from: sessionDay, to: last).day ?? 0

                if daysBetween <= 1 {
                    tempStreak += 1
                } else {
                    longestStreak = max(longestStreak, tempStreak)
                    tempStreak = 1
                }
            } else {
                tempStreak = 1
                // Check if today or yesterday for current streak
                let today = calendar.startOfDay(for: Date())
                let daysDiff = calendar.dateComponents([.day], from: sessionDay, to: today).day ?? 0
                if daysDiff <= 1 {
                    currentStreak = tempStreak
                }
            }

            lastDate = sessionDay
        }

        longestStreak = max(longestStreak, tempStreak)
    }

    // MARK: - Achievements

    private func checkAchievements(for session: MeditationSession) {
        var newAchievements: [MeditationAchievement] = []

        // First Session
        if totalSessions == 1 && !achievements.contains(.firstSession) {
            newAchievements.append(.firstSession)
        }

        // Heart Harmony (coherence achievement)
        if session.coherenceAchievements > 0 && !achievements.contains(.heartHarmony) {
            newAchievements.append(.heartHarmony)
        }

        // Optimal BPM
        if session.achievedOptimalBPM && !achievements.contains(.optimalBPM) {
            newAchievements.append(.optimalBPM)
        }

        // 7 Day Streak
        if currentStreak >= 7 && !achievements.contains(.sevenDayStreak) {
            newAchievements.append(.sevenDayStreak)
        }

        // 30 Day Streak
        if currentStreak >= 30 && !achievements.contains(.thirtyDayStreak) {
            newAchievements.append(.thirtyDayStreak)
        }

        // Meditation Master (100 sessions)
        if totalSessions >= 100 && !achievements.contains(.meditationMaster) {
            newAchievements.append(.meditationMaster)
        }

        // Major Improvement (10+ BPM)
        if session.heartRateImprovement >= 10.0 && !achievements.contains(.majorImprovement) {
            newAchievements.append(.majorImprovement)
        }

        // Add new achievements
        for achievement in newAchievements {
            achievements.insert(achievement)
        }

        if !newAchievements.isEmpty {
            persistAchievements()
        }
    }

    // MARK: - Statistics Update

    private func updateStats() {
        totalSessions = sessions.count
        totalTime = sessions.reduce(0) { $0 + $1.duration }
        calculateStreaks()
    }

    // MARK: - Persistence

    private func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let loadedSessions = try? JSONDecoder().decode([MeditationSession].self, from: data) else {
            sessions = []
            return
        }
        sessions = loadedSessions
    }

    private func persistSessions() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: sessionsKey)
    }

    private func loadAchievements() {
        guard let data = UserDefaults.standard.data(forKey: achievementsKey),
              let loadedAchievements = try? JSONDecoder().decode(Set<MeditationAchievement>.self, from: data) else {
            achievements = []
            return
        }
        achievements = loadedAchievements
    }

    private func persistAchievements() {
        guard let data = try? JSONEncoder().encode(achievements) else { return }
        UserDefaults.standard.set(data, forKey: achievementsKey)
    }

    // MARK: - Debug & Testing

    func clearAllData() {
        sessions.removeAll()
        achievements.removeAll()
        currentStreak = 0
        longestStreak = 0
        totalSessions = 0
        totalTime = 0

        UserDefaults.standard.removeObject(forKey: sessionsKey)
        UserDefaults.standard.removeObject(forKey: achievementsKey)
        UserDefaults.standard.removeObject(forKey: statsKey)

        objectWillChange.send()
    }

    func addSampleSession() {
        let sampleSession = MeditationSession(
            date: Date(),
            type: .gratitude,
            duration: 300, // 5 minutes
            startingHeartRate: 75.0,
            averageHeartRate: 68.0,
            lowestHeartRate: 62.0,
            heartRateImprovement: 7.0,
            coherenceAchievements: 3,
            maxCoherenceStreak: 45,
            coherencePercentage: 0.65,
            achievedOptimalBPM: false,
            sessionQuality: .good,
            focusNumber: 7,
            realmNumber: 3,
            spiritualInsight: "Deep spiritual wisdom has been awakened. Trust your inner knowing and continue seeking truth.",
            userNotes: nil,
            personalBest: false
        )

        saveSession(sampleSession)
    }
}

// MARK: - TimeFrame enum (if not already defined)

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
