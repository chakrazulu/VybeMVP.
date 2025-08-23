import Foundation
import SwiftUI

/**
 * Meditation Session Data Model
 * ============================
 *
 * Represents a completed meditation session with comprehensive biometric
 * and achievement data for progress tracking and analytics.
 *
 * ## Key Features
 *
 * **Session Metadata:**
 * - Type, duration, start/end timestamps
 * - Configuration settings and user preferences
 *
 * **Biometric Data:**
 * - Heart rate metrics (starting, average, lowest, improvement)
 * - HRV coherence achievements and quality assessments
 * - Optimal BPM achievement tracking
 *
 * **Progress Tracking:**
 * - Session quality scoring and achievements
 * - Streak and consistency data
 * - Personal best tracking
 *
 * Created: August 2025
 * Version: 1.0.0 - Core meditation session tracking
 */

// MARK: - Meditation Session Model

struct MeditationSession: Identifiable, Codable {

    // MARK: - Core Properties

    let id: UUID
    let date: Date
    let type: MeditationType
    let duration: TimeInterval

    // MARK: - Biometric Data

    let startingHeartRate: Double
    let averageHeartRate: Double
    let lowestHeartRate: Double
    let heartRateImprovement: Double

    // MARK: - Coherence Metrics

    let coherenceAchievements: Int
    let maxCoherenceStreak: Int
    let coherencePercentage: Double

    // MARK: - Achievement Data

    let achievedOptimalBPM: Bool
    let sessionQuality: SessionQuality
    let focusNumber: Int

    // MARK: - Spiritual Insights

    let realmNumber: Int
    let spiritualInsight: String

    // MARK: - Optional Data

    let userNotes: String?
    let personalBest: Bool

    // MARK: - Initializer

    init(date: Date, type: MeditationType, duration: TimeInterval, startingHeartRate: Double, averageHeartRate: Double, lowestHeartRate: Double, heartRateImprovement: Double, coherenceAchievements: Int, maxCoherenceStreak: Int, coherencePercentage: Double, achievedOptimalBPM: Bool, sessionQuality: SessionQuality, focusNumber: Int, realmNumber: Int, spiritualInsight: String, userNotes: String? = nil, personalBest: Bool = false) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.duration = duration
        self.startingHeartRate = startingHeartRate
        self.averageHeartRate = averageHeartRate
        self.lowestHeartRate = lowestHeartRate
        self.heartRateImprovement = heartRateImprovement
        self.coherenceAchievements = coherenceAchievements
        self.maxCoherenceStreak = maxCoherenceStreak
        self.coherencePercentage = coherencePercentage
        self.achievedOptimalBPM = achievedOptimalBPM
        self.sessionQuality = sessionQuality
        self.focusNumber = focusNumber
        self.realmNumber = realmNumber
        self.spiritualInsight = spiritualInsight
        self.userNotes = userNotes
        self.personalBest = personalBest
    }

    // MARK: - Computed Properties

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60

        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", seconds))"
        } else {
            return "\(seconds)s"
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var improvementText: String {
        if heartRateImprovement > 0 {
            return "-\(Int(heartRateImprovement)) BPM"
        } else {
            return "No change"
        }
    }
}

// MARK: - Session Quality Enum

enum SessionQuality: String, Codable, CaseIterable {
    case excellent = "excellent"
    case good = "good"
    case fair = "fair"
    case challenging = "challenging"

    var displayName: String {
        switch self {
        case .excellent:
            return "Excellent"
        case .good:
            return "Good"
        case .fair:
            return "Fair"
        case .challenging:
            return "Challenging"
        }
    }

    var icon: String {
        switch self {
        case .excellent:
            return "star.fill"
        case .good:
            return "heart.fill"
        case .fair:
            return "circle.fill"
        case .challenging:
            return "triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .excellent:
            return .yellow
        case .good:
            return .green
        case .fair:
            return .blue
        case .challenging:
            return .orange
        }
    }

    static func from(coherencePercentage: Double, achievedOptimalBPM: Bool, heartRateImprovement: Double) -> SessionQuality {
        if achievedOptimalBPM && coherencePercentage >= 0.8 {
            return .excellent
        } else if coherencePercentage >= 0.6 || heartRateImprovement >= 5.0 {
            return .good
        } else if coherencePercentage >= 0.3 || heartRateImprovement >= 2.0 {
            return .fair
        } else {
            return .challenging
        }
    }
}

// MARK: - Session Result for Completion Callback

struct MeditationSessionResult {
    let type: MeditationType
    let duration: TimeInterval
    let heartRateImprovement: Double
    let achievedOptimalBPM: Bool
    let coherenceAchievements: Int
    let sessionQuality: SessionQuality
}

// MARK: - Achievement Types

enum MeditationAchievement: String, CaseIterable, Codable {
    case firstSession = "first_session"
    case heartHarmony = "heart_harmony"
    case optimalBPM = "optimal_bpm"
    case sevenDayStreak = "seven_day_streak"
    case thirtyDayStreak = "thirty_day_streak"
    case meditationMaster = "meditation_master"
    case majorImprovement = "major_improvement"

    var title: String {
        switch self {
        case .firstSession:
            return "First Steps"
        case .heartHarmony:
            return "Heart Harmony"
        case .optimalBPM:
            return "Optimal Zone"
        case .sevenDayStreak:
            return "7 Day Streak"
        case .thirtyDayStreak:
            return "30 Day Streak"
        case .meditationMaster:
            return "Meditation Master"
        case .majorImprovement:
            return "Major Breakthrough"
        }
    }

    var description: String {
        switch self {
        case .firstSession:
            return "Completed your first meditation session"
        case .heartHarmony:
            return "Achieved heart coherence state"
        case .optimalBPM:
            return "Reached age-optimal heart rate"
        case .sevenDayStreak:
            return "Meditated for 7 consecutive days"
        case .thirtyDayStreak:
            return "Meditated for 30 consecutive days"
        case .meditationMaster:
            return "Completed 100 meditation sessions"
        case .majorImprovement:
            return "Achieved 10+ BPM improvement"
        }
    }

    var icon: String {
        switch self {
        case .firstSession:
            return "star.fill"
        case .heartHarmony:
            return "heart.fill"
        case .optimalBPM:
            return "target"
        case .sevenDayStreak:
            return "flame.fill"
        case .thirtyDayStreak:
            return "crown.fill"
        case .meditationMaster:
            return "trophy.fill"
        case .majorImprovement:
            return "bolt.fill"
        }
    }

    var color: Color {
        switch self {
        case .firstSession:
            return .blue
        case .heartHarmony:
            return .green
        case .optimalBPM:
            return .yellow
        case .sevenDayStreak:
            return .orange
        case .thirtyDayStreak:
            return .purple
        case .meditationMaster:
            return .yellow
        case .majorImprovement:
            return .red
        }
    }
}
