/**
 * KASPER MLX Feedback Manager
 * 
 * Manages user feedback collection for KASPER MLX insights.
 * Stores feedback data for future AI model training and improvement.
 * Provides analytics for insight quality and user satisfaction.
 */

import Foundation
import SwiftUI
import Combine

/// User feedback for a specific insight
struct KASPERFeedback: Codable, Identifiable {
    let id: UUID
    let insightId: UUID
    let feature: KASPERFeature
    let rating: FeedbackRating
    let timestamp: Date
    let insightContent: String
    let contextData: [String: String] // User's context when feedback was given
    
    init(
        insightId: UUID,
        feature: KASPERFeature,
        rating: FeedbackRating,
        insightContent: String,
        contextData: [String: String] = [:]
    ) {
        self.id = UUID()
        self.insightId = insightId
        self.feature = feature
        self.rating = rating
        self.timestamp = Date()
        self.insightContent = insightContent
        self.contextData = contextData
    }
}

/// Feedback rating options
enum FeedbackRating: String, Codable, CaseIterable {
    case positive = "positive"
    case negative = "negative"
    
    var emoji: String {
        switch self {
        case .positive: return "👍"
        case .negative: return "👎"
        }
    }
    
    var score: Double {
        switch self {
        case .positive: return 1.0
        case .negative: return 0.0
        }
    }
}

/// Aggregated feedback statistics
struct FeedbackStats {
    let totalFeedback: Int
    let positiveCount: Int
    let negativeCount: Int
    let averageRating: Double
    let featureBreakdown: [KASPERFeature: (positive: Int, negative: Int)]
    
    var positivePercentage: Double {
        guard totalFeedback > 0 else { return 0.0 }
        return Double(positiveCount) / Double(totalFeedback) * 100.0
    }
    
    var negativePercentage: Double {
        guard totalFeedback > 0 else { return 0.0 }
        return Double(negativeCount) / Double(totalFeedback) * 100.0
    }
}

@MainActor
class KASPERFeedbackManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var feedbackHistory: [KASPERFeedback] = []
    @Published private(set) var stats: FeedbackStats = FeedbackStats(
        totalFeedback: 0,
        positiveCount: 0,
        negativeCount: 0,
        averageRating: 0.0,
        featureBreakdown: [:]
    )
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let feedbackKey = "kasper_mlx_feedback_history"
    private let maxFeedbackEntries = 1000 // Limit storage
    
    // MARK: - Singleton
    
    static let shared = KASPERFeedbackManager()
    
    private init() {
        loadFeedbackHistory()
        updateStats()
    }
    
    // MARK: - Public Methods
    
    /// Record user feedback for an insight
    func recordFeedback(
        for insight: KASPERInsight,
        rating: FeedbackRating,
        contextData: [String: String] = [:]
    ) {
        let feedback = KASPERFeedback(
            insightId: insight.id,
            feature: insight.feature,
            rating: rating,
            insightContent: insight.content,
            contextData: contextData
        )
        
        feedbackHistory.append(feedback)
        
        // Maintain storage limit
        if feedbackHistory.count > maxFeedbackEntries {
            feedbackHistory.removeFirst(feedbackHistory.count - maxFeedbackEntries)
        }
        
        saveFeedbackHistory()
        updateStats()
        
        print("🔮 KASPER Feedback: Recorded \(rating.emoji) for \(insight.feature.rawValue)")
        print("🔮 KASPER Feedback: Total feedback entries: \(feedbackHistory.count)")
    }
    
    /// Get feedback for a specific insight
    func getFeedback(for insightId: UUID) -> KASPERFeedback? {
        return feedbackHistory.first { $0.insightId == insightId }
    }
    
    /// Get feedback for a specific feature
    func getFeedback(for feature: KASPERFeature) -> [KASPERFeedback] {
        return feedbackHistory.filter { $0.feature == feature }
    }
    
    /// Get recent feedback (last N entries)
    func getRecentFeedback(limit: Int = 10) -> [KASPERFeedback] {
        return Array(feedbackHistory.suffix(limit).reversed())
    }
    
    /// Clear all feedback data
    func clearAllFeedback() {
        feedbackHistory.removeAll()
        saveFeedbackHistory()
        updateStats()
        print("🔮 KASPER Feedback: All feedback data cleared")
    }
    
    /// Export feedback data for analysis
    func exportFeedbackData() -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(feedbackHistory)
            print("🔮 KASPER Feedback: Exported \(feedbackHistory.count) feedback entries")
            return jsonData
        } catch {
            print("🔮 KASPER Feedback: Failed to export data: \(error)")
            return nil
        }
    }
    
    /// Get average rating for a specific feature
    func getAverageRating(for feature: KASPERFeature) -> Double {
        let featureFeedback = getFeedback(for: feature)
        guard !featureFeedback.isEmpty else { return 0.0 }
        
        let totalScore = featureFeedback.reduce(0.0) { $0 + $1.rating.score }
        return totalScore / Double(featureFeedback.count)
    }
    
    /// Check if user has provided feedback recently (within 24 hours)
    func hasRecentFeedback(for feature: KASPERFeature) -> Bool {
        let dayAgo = Date().addingTimeInterval(-24 * 60 * 60)
        return feedbackHistory.contains { feedback in
            feedback.feature == feature && feedback.timestamp > dayAgo
        }
    }
    
    // MARK: - Private Methods
    
    private func loadFeedbackHistory() {
        guard let data = userDefaults.data(forKey: feedbackKey) else {
            print("🔮 KASPER Feedback: No previous feedback data found")
            return
        }
        
        do {
            feedbackHistory = try JSONDecoder().decode([KASPERFeedback].self, from: data)
            print("🔮 KASPER Feedback: Loaded \(feedbackHistory.count) feedback entries")
        } catch {
            print("🔮 KASPER Feedback: Failed to load feedback history: \(error)")
            feedbackHistory = []
        }
    }
    
    private func saveFeedbackHistory() {
        do {
            let data = try JSONEncoder().encode(feedbackHistory)
            userDefaults.set(data, forKey: feedbackKey)
            print("🔮 KASPER Feedback: Saved \(feedbackHistory.count) feedback entries")
        } catch {
            print("🔮 KASPER Feedback: Failed to save feedback history: \(error)")
        }
    }
    
    private func updateStats() {
        let totalFeedback = feedbackHistory.count
        let positiveCount = feedbackHistory.filter { $0.rating == .positive }.count
        let negativeCount = feedbackHistory.filter { $0.rating == .negative }.count
        
        let averageRating = totalFeedback > 0 ? 
            feedbackHistory.reduce(0.0) { $0 + $1.rating.score } / Double(totalFeedback) : 0.0
        
        // Feature breakdown
        var featureBreakdown: [KASPERFeature: (positive: Int, negative: Int)] = [:]
        for feature in KASPERFeature.allCases {
            let featureFeedback = getFeedback(for: feature)
            let positive = featureFeedback.filter { $0.rating == .positive }.count
            let negative = featureFeedback.filter { $0.rating == .negative }.count
            featureBreakdown[feature] = (positive: positive, negative: negative)
        }
        
        stats = FeedbackStats(
            totalFeedback: totalFeedback,
            positiveCount: positiveCount,
            negativeCount: negativeCount,
            averageRating: averageRating,
            featureBreakdown: featureBreakdown
        )
    }
}

// MARK: - SwiftUI Integration

extension KASPERFeedbackManager {
    
    /// SwiftUI view modifier for feedback collection
    func feedbackModifier(for insight: KASPERInsight) -> some ViewModifier {
        KASPERFeedbackModifier(manager: self, insight: insight)
    }
}

struct KASPERFeedbackModifier: ViewModifier {
    let manager: KASPERFeedbackManager
    let insight: KASPERInsight
    
    @State private var hasProvidedFeedback = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                hasProvidedFeedback = manager.getFeedback(for: insight.id) != nil
            }
    }
}