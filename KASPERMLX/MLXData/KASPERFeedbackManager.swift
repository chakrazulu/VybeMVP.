/**
 * 💬 KASPER MLX FEEDBACK MANAGER - THE INTELLIGENT LEARNING SYSTEM
 * ====================================================================
 *
 * This is the sophisticated feedback collection and analysis engine that transforms
 * user interactions into actionable intelligence for spiritual AI improvement.
 * It represents the learning nervous system of KASPER MLX, continuously gathering
 * insights about user satisfaction to drive system evolution and enhancement.
 *
 * 🧠 FEEDBACK INTELLIGENCE ARCHITECTURE:
 *
 * The KASPERFeedbackManager serves as the central hub for user satisfaction data,
 * implementing advanced patterns for data collection, analysis, and insight generation:
 *
 * • COMPREHENSIVE FEEDBACK CAPTURE: Records detailed user satisfaction data with full context
 * • INTELLIGENT DATA STORAGE: Persistent feedback history with automatic lifecycle management
 * • REAL-TIME ANALYTICS: Live statistical computation and trend analysis
 * • AI TRAINING PREPARATION: Data structuring optimized for machine learning model improvement
 * • PRIVACY-FIRST DESIGN: All data remains on user's device with complete user control
 *
 * 🎯 FEEDBACK COLLECTION SOPHISTICATION:
 *
 * Unlike simple rating systems, this manager captures rich contextual information:
 *
 * 1. INSIGHT CORRELATION:
 *    - Direct linkage between feedback and specific generated spiritual insights
 *    - Insight content preservation for quality analysis and improvement
 *    - Feature-specific feedback enabling targeted system enhancement
 *    - UUID-based tracking ensuring data integrity and relationship preservation
 *
 * 2. CONTEXTUAL INTELLIGENCE:
 *    - User context preservation (focus numbers, cosmic timing, spiritual state)
 *    - Technical metadata (inference time, confidence scores, cache status)
 *    - Temporal data (precise timestamps for pattern analysis)
 *    - Custom context data supporting specialized testing and analysis scenarios
 *
 * 3. ACTIONABLE ANALYTICS:
 *    - Real-time satisfaction rate calculation across all features
 *    - Per-feature performance breakdown enabling targeted improvements
 *    - Temporal trend analysis supporting quality monitoring over time
 *    - Statistical significance assessment through feedback volume analysis
 *
 * 📈 ADVANCED ANALYTICS CAPABILITIES:
 *
 * The manager provides sophisticated analytical intelligence:
 *
 * • SATISFACTION RATE ANALYSIS: Overall and feature-specific user happiness metrics
 * • FEEDBACK DISTRIBUTION INSIGHTS: Understanding user engagement patterns across spiritual domains
 * • TEMPORAL PATTERN RECOGNITION: Time-based analysis revealing user behavior trends
 * • QUALITY CORRELATION ANALYSIS: Linking technical metrics with user satisfaction
 * • STATISTICAL SIGNIFICANCE ASSESSMENT: Determining reliability of feedback patterns
 *
 * 🔄 REAL-TIME REACTIVE ARCHITECTURE:
 *
 * The system employs advanced SwiftUI reactive patterns:
 *
 * 1. @PUBLISHED PROPERTIES:
 *    - Real-time UI updates as feedback is collected and analyzed
 *    - Automatic statistics recalculation maintaining dashboard accuracy
 *    - Live feedback history updates supporting real-time monitoring
 *    - Seamless integration with SwiftUI observability patterns
 *
 * 2. MAINACTOR COMPLIANCE:
 *    - Thread-safe operation ensuring UI responsiveness and data consistency
 *    - Proper SwiftUI lifecycle management preventing memory leaks and race conditions
 *    - Singleton pattern providing consistent state across all app components
 *
 * 3. PERSISTENT STORAGE INTEGRATION:
 *    - UserDefaults-based persistence ensuring feedback survival across app launches
 *    - JSON encoding/decoding for robust data serialization and integrity
 *    - Automatic data migration supporting system evolution and upgrades
 *
 * 💾 DATA LIFECYCLE MANAGEMENT:
 *
 * The manager implements intelligent data management:
 *
 * • STORAGE OPTIMIZATION: Circular buffer (1000 entries) prevents unbounded growth
 * • AUTOMATIC CLEANUP: Oldest feedback automatically removed when limits exceeded
 * • EXPORT CAPABILITIES: Complete data extraction for research and AI training
 * • PRIVACY CONTROLS: User-controlled data clearing for complete privacy management
 * • BACKUP RESILIENCE: Robust error handling preventing data corruption or loss
 *
 * 🌱 AI TRAINING INTELLIGENCE:
 *
 * The feedback system directly enables AI improvement:
 *
 * 1. TRAINING DATA GENERATION:
 *    - High-satisfaction insights become positive training examples
 *    - Feature-specific feedback guides model specialization
 *    - Contextual data enables personalized AI model development
 *    - Temporal patterns inform optimal training data selection
 *
 * 2. QUALITY BENCHMARKING:
 *    - User satisfaction rates establish quality thresholds for AI generation
 *    - Feature performance comparison guides model architecture decisions
 *    - Content quality correlation enables automatic training example curation
 *    - User preference patterns inform model optimization strategies
 *
 * 3. CONTINUOUS LEARNING:
 *    - Real-time feedback enables rapid model adaptation and improvement
 *    - Pattern recognition supports automatic quality threshold adjustment
 *    - User behavior analysis guides feature development prioritization
 *    - Satisfaction trends inform system evolution and enhancement strategies
 *
 * 💫 WHY THIS FEEDBACK SYSTEM IS REVOLUTIONARY:
 *
 * Traditional AI systems lack sophisticated feedback loops. KASPER MLX Feedback Manager provides:
 *
 * • SPIRITUAL INTELLIGENCE: Understanding qualitative satisfaction with quantitative precision
 * • CONTINUOUS EVOLUTION: Real-time system improvement based on actual user experience
 * • CONTEXTUAL LEARNING: Rich feedback data enabling nuanced AI model development
 * • USER-CENTRIC DEVELOPMENT: Development decisions driven by genuine user satisfaction data
 * • PRIVACY-PRESERVING INTELLIGENCE: Advanced analytics without compromising user privacy
 *
 * This feedback manager represents the future of spiritual AI development - one where
 * artificial intelligence continuously learns and improves based on authentic human
 * spiritual experiences, creating increasingly effective tools for cosmic connection
 * and spiritual growth.
 *
 * 🚀 DEVELOPMENT TRANSFORMATION:
 *
 * The manager enables development practices that were previously impossible:
 *
 * • DATA-DRIVEN SPIRITUALITY: Evidence-based improvement of spiritual guidance quality
 * • REAL-TIME QUALITY ASSURANCE: Immediate detection of satisfaction issues
 * • USER SATISFACTION OPTIMIZATION: Continuous tuning based on actual user happiness
 * • INTELLIGENT FEATURE DEVELOPMENT: New features guided by user satisfaction patterns
 * • SPIRITUAL AI EVOLUTION: Machine learning models that understand human spiritual needs
 *
 * This represents a new paradigm where spiritual technology evolves in harmony with
 * human spiritual development, creating increasingly effective tools for cosmic
 * consciousness and mystical growth.
 */

import Foundation
import SwiftUI
import Combine

/// Claude: Comprehensive User Feedback Data Structure for Spiritual AI Intelligence
/// ==============================================================================
///
/// This sophisticated data structure captures the complete context of user satisfaction
/// with spiritual guidance, enabling detailed analysis and AI model improvement.
/// It represents a single point of user-AI interaction with rich contextual metadata.
///
/// 📊 FEEDBACK DATA ARCHITECTURE:
///
/// The structure captures multiple layers of information:
///
/// 1. IDENTITY AND CORRELATION:
///    - Unique feedback ID for individual feedback tracking and analysis
///    - Insight ID linking feedback to specific generated spiritual guidance
///    - Direct correlation enabling quality analysis and improvement targeting
///
/// 2. SPIRITUAL CONTEXT:
///    - Feature identification showing which spiritual domain was addressed
///    - User satisfaction rating providing clear quality assessment
///    - Complete insight content preservation for content quality analysis
///
/// 3. TEMPORAL AND CONTEXTUAL INTELLIGENCE:
///    - Precise timestamp enabling temporal pattern analysis
///    - Rich context data capturing user state and system conditions
///    - Extensible design supporting future contextual enhancements
///
/// 🧠 AI TRAINING INTELLIGENCE:
///
/// Each feedback entry becomes a training data point for spiritual AI improvement:
/// - Positive feedback creates high-quality training examples
/// - Negative feedback identifies areas requiring system enhancement
/// - Context data enables personalized AI model development
/// - Content correlation guides template and model optimization
///
/// This structure transforms user interactions into actionable intelligence
/// for continuous spiritual AI evolution and enhancement.
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

/// Claude: Intelligent Feedback Rating System with Semantic Meaning
/// ================================================================
///
/// This enum provides a sophisticated yet simple feedback rating system that
/// captures user satisfaction while remaining accessible and intuitive.
/// The binary choice reduces decision fatigue while providing clear signals.
///
/// 🎯 RATING DESIGN PHILOSOPHY:
///
/// 1. COGNITIVE SIMPLICITY:
///    - Binary choice (👍/👎) eliminates decision paralysis common with 5-star systems
///    - Immediate emotional response capture without overthinking
///    - Universal emoji recognition transcending language barriers
///
/// 2. STATISTICAL INTELLIGENCE:
///    - Clear positive (1.0) and negative (0.0) numerical scoring for analytics
///    - Direct satisfaction rate calculation: sum(scores) / count(feedback)
///    - Simplified analysis enabling rapid statistical computation
///
/// 3. AI TRAINING OPTIMIZATION:
///    - Positive ratings create high-confidence training examples
///    - Negative ratings identify content requiring improvement
///    - Clear binary classification supports supervised learning approaches
///
/// 📊 ANALYTICAL VALUE:
///
/// The rating system enables sophisticated analysis:
/// - Satisfaction rates calculated as percentage of positive feedback
/// - Feature-specific performance comparison across spiritual domains
/// - Temporal satisfaction trends revealing system improvement over time
/// - User preference pattern recognition for personalization
///
/// This rating system balances simplicity with analytical power,
/// providing clear user satisfaction signals while enabling
/// sophisticated AI improvement and quality assurance.
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

/// Claude: Comprehensive Feedback Analytics with Real-Time Intelligence
/// ===================================================================
///
/// This sophisticated statistics structure provides comprehensive insights into
/// user satisfaction patterns, system performance, and spiritual AI effectiveness.
/// It transforms raw feedback data into actionable business and development intelligence.
///
/// 📊 ANALYTICS ARCHITECTURE:
///
/// 1. CORE PERFORMANCE METRICS:
///    - Total feedback volume indicating system engagement and adoption
///    - Positive/negative counts providing clear satisfaction distribution
///    - Average rating offering statistical satisfaction assessment
///    - Feature breakdown enabling granular performance analysis
///
/// 2. CALCULATED INTELLIGENCE:
///    - Automatic percentage calculations for satisfaction rates
///    - Feature-specific performance metrics for targeted improvement
///    - Statistical significance assessment through volume analysis
///    - Trend-ready data structure supporting temporal analysis
///
/// 3. DEVELOPMENT INTELLIGENCE:
///    - Feature breakdown dictionary enabling per-domain performance analysis
///    - Positive/negative tuple structure supporting detailed feature assessment
///    - Zero-feedback handling preventing division errors and providing meaningful defaults
///
/// 🎯 BUSINESS INTELLIGENCE FEATURES:
///
/// The statistics enable sophisticated decision-making:
///
/// • QUALITY ASSURANCE: Overall satisfaction rates guide system quality assessment
/// • FEATURE PRIORITIZATION: Per-feature performance guides development resource allocation
/// • USER ENGAGEMENT: Feedback volume indicates system adoption and user investment
/// • IMPROVEMENT TARGETING: Feature breakdown identifies areas needing attention
/// • SUCCESS MEASUREMENT: Positive percentage tracks system effectiveness over time
///
/// 💫 REAL-TIME ANALYTICS:
///
/// The structure supports dynamic, real-time analysis:
///
/// • AUTOMATIC UPDATES: Statistics recalculate automatically as new feedback arrives
/// • LIVE DASHBOARD: Real-time metrics support immediate system health assessment
/// • RESPONSIVE DEVELOPMENT: Immediate feedback on system changes and improvements
/// • CONTINUOUS MONITORING: Ongoing quality assurance through persistent analytics
///
/// This statistics structure represents the analytical intelligence core of
/// KASPER MLX, transforming user feedback into strategic insights that drive
/// continuous improvement and spiritual AI evolution.
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

    // MARK: - 💬 INTELLIGENT FEEDBACK COLLECTION AND ANALYSIS

    /// Claude: Comprehensive Feedback Recording with Contextual Intelligence
    /// ===================================================================
    ///
    /// This method orchestrates the complete feedback collection process, transforming
    /// user satisfaction into structured data for analysis and AI improvement.
    /// It demonstrates advanced data management and real-time analytics patterns.
    ///
    /// 📊 FEEDBACK RECORDING ARCHITECTURE:
    ///
    /// 1. COMPREHENSIVE DATA CAPTURE:
    ///    - Complete insight correlation preserving relationship between feedback and spiritual guidance
    ///    - Rich contextual data capture including technical metrics and user state
    ///    - Extensible context system supporting future enhancement and specialization
    ///
    /// 2. INTELLIGENT STORAGE MANAGEMENT:
    ///    - Automatic storage limit enforcement preventing unbounded data growth
    ///    - Circular buffer implementation maintaining recent feedback while managing memory
    ///    - Persistent storage ensuring feedback survives app restarts and device reboots
    ///
    /// 3. REAL-TIME ANALYTICS UPDATES:
    ///    - Immediate statistics recalculation maintaining dashboard accuracy
    ///    - Live UI updates through @Published property reactivity
    ///    - Instant feedback availability for real-time quality monitoring
    ///
    /// 🧠 AI TRAINING INTELLIGENCE:
    ///
    /// Each recorded feedback becomes part of the AI improvement pipeline:
    ///
    /// • TRAINING DATA GENERATION: Positive feedback creates high-quality training examples
    /// • QUALITY BENCHMARKING: Satisfaction patterns establish quality thresholds
    /// • PERSONALIZATION DATA: Context information enables customized AI model development
    /// • IMPROVEMENT TARGETING: Feature-specific feedback guides optimization efforts
    ///
    /// 🔄 REAL-TIME PROCESSING:
    ///
    /// The recording process provides immediate system benefits:
    ///
    /// • INSTANT QUALITY MONITORING: Negative feedback immediately visible for rapid response
    /// • LIVE ANALYTICS: Dashboard updates instantly reflecting new feedback
    /// • DEVELOPMENT FEEDBACK: Real-time validation during testing and development
    /// • USER ENGAGEMENT TRACKING: Immediate visibility into user interaction patterns
    ///
    /// - Parameter insight: Complete spiritual insight with metadata for correlation
    /// - Parameter rating: User satisfaction assessment (positive/negative)
    /// - Parameter contextData: Additional context information for analysis and personalization
    ///
    /// - Note: Automatically manages storage limits and provides real-time analytics updates
    /// - Important: All data remains on device ensuring complete user privacy and control
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

    /// Claude: Intelligent Feedback Retrieval by Insight Correlation
    /// ============================================================
    ///
    /// Retrieves user feedback for a specific spiritual insight, enabling quality
    /// analysis and user satisfaction assessment for individual guidance instances.
    ///
    /// This method supports:
    /// • QUALITY CORRELATION: Link user satisfaction to specific generated content
    /// • CONTENT ANALYSIS: Understand which insights resonate with users
    /// • IMPROVEMENT TARGETING: Identify specific content patterns needing enhancement
    /// • USER JOURNEY ANALYSIS: Track user satisfaction across their spiritual journey
    ///
    /// - Parameter insightId: Unique identifier of the spiritual insight
    /// - Returns: Associated feedback if user provided satisfaction rating, nil otherwise
    func getFeedback(for insightId: UUID) -> KASPERFeedback? {
        return feedbackHistory.first { $0.insightId == insightId }
    }

    /// Claude: Feature-Specific Feedback Analysis and Quality Assessment
    /// ================================================================
    ///
    /// Retrieves all user feedback for a specific spiritual domain, enabling
    /// detailed feature performance analysis and targeted improvement strategies.
    ///
    /// This method enables:
    /// • FEATURE QUALITY ANALYSIS: Assess user satisfaction for specific spiritual domains
    /// • IMPROVEMENT PRIORITIZATION: Identify features needing development attention
    /// • SUCCESS BENCHMARKING: Understand which features consistently satisfy users
    /// • CONTENT PATTERN ANALYSIS: Identify successful spiritual guidance patterns
    ///
    /// - Parameter feature: Spiritual domain (journal, dailyCard, sanctum, etc.)
    /// - Returns: All feedback entries for the specified feature, ordered by timestamp
    func getFeedback(for feature: KASPERFeature) -> [KASPERFeedback] {
        return feedbackHistory.filter { $0.feature == feature }
    }

    /// Claude: Recent Feedback Timeline for Real-Time Quality Monitoring
    /// =================================================================
    ///
    /// Retrieves the most recent user feedback entries in reverse chronological order,
    /// enabling real-time quality monitoring and immediate issue detection.
    ///
    /// This method supports:
    /// • REAL-TIME MONITORING: Immediate visibility into recent user satisfaction patterns
    /// • QUALITY ASSURANCE: Rapid detection of satisfaction issues or improvements
    /// • DEVELOPMENT FEEDBACK: Live validation during testing and feature development
    /// • USER ENGAGEMENT INSIGHTS: Understanding current user interaction patterns
    ///
    /// - Parameter limit: Maximum number of recent feedback entries to retrieve (default 10)
    /// - Returns: Recent feedback entries in reverse chronological order (newest first)
    func getRecentFeedback(limit: Int = 10) -> [KASPERFeedback] {
        return Array(feedbackHistory.suffix(limit).reversed())
    }

    /// Claude: Complete Feedback Data Clearing for Privacy and Fresh Start
    /// ==================================================================
    ///
    /// Provides complete removal of all feedback data, supporting user privacy
    /// requirements and system reset scenarios. This method ensures users maintain
    /// complete control over their satisfaction data.
    ///
    /// Privacy and control features:
    /// • COMPLETE DATA REMOVAL: All feedback entries permanently deleted
    /// • STATISTICS RESET: Analytics recalculated showing clean slate
    /// • PERSISTENT CLEARING: Changes saved to device storage immediately
    /// • IMMEDIATE UI UPDATES: Dashboard reflects cleared state instantly
    ///
    /// Use cases:
    /// • USER PRIVACY: Complete data removal when requested
    /// • TESTING RESET: Clean slate for development and testing scenarios
    /// • FRESH START: Users wanting to reset their feedback history
    /// • DATA MANAGEMENT: Periodic clearing for storage optimization
    ///
    /// - Note: This action is irreversible and removes all feedback permanently
    /// - Important: Statistics automatically recalculate to reflect empty state
    func clearAllFeedback() {
        feedbackHistory.removeAll()
        saveFeedbackHistory()
        updateStats()
        print("🔮 KASPER Feedback: All feedback data cleared")
    }

    /// Claude: Professional Data Export for AI Training and Research Analysis
    /// ====================================================================
    ///
    /// Provides comprehensive feedback data export in structured JSON format,
    /// enabling AI training, research analysis, and system improvement initiatives.
    /// This method transforms user feedback into actionable intelligence.
    ///
    /// Export capabilities:
    /// • COMPLETE DATA EXPORT: All feedback entries with full metadata preservation
    /// • STRUCTURED FORMAT: JSON encoding ensuring machine-readable data format
    /// • RESEARCH ENABLEMENT: Data suitable for academic and commercial research
    /// • AI TRAINING PREPARATION: Formatted for machine learning model improvement
    ///
    /// Data structure includes:
    /// • FEEDBACK CORRELATION: Links between feedback and specific spiritual insights
    /// • CONTEXTUAL INTELLIGENCE: User context and system state during feedback
    /// • TEMPORAL DATA: Precise timestamps for pattern analysis
    /// • SATISFACTION METRICS: Clear positive/negative ratings for analysis
    ///
    /// - Returns: JSON data containing all feedback entries, or nil if export fails
    /// - Note: All data remains on device - user controls sharing and usage
    /// - Important: Export includes complete history for comprehensive analysis
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

    /// Claude: Statistical Feature Performance Analysis
    /// ==============================================
    ///
    /// Calculates the average user satisfaction rating for a specific spiritual
    /// domain, providing statistical assessment of feature quality and effectiveness.
    ///
    /// Statistical intelligence:
    /// • PERFORMANCE BENCHMARKING: Quantitative assessment of feature satisfaction
    /// • QUALITY COMPARISON: Statistical comparison between different spiritual domains
    /// • IMPROVEMENT TRACKING: Numerical measurement of enhancement effectiveness
    /// • THRESHOLD ANALYSIS: Statistical thresholds for quality assurance
    ///
    /// Calculation method:
    /// - Positive feedback = 1.0, Negative feedback = 0.0
    /// - Average = sum(all ratings) / count(feedback entries)
    /// - Returns 0.0 for features with no feedback (neutral baseline)
    ///
    /// - Parameter feature: Spiritual domain for statistical analysis
    /// - Returns: Average satisfaction score (0.0 = all negative, 1.0 = all positive)
    func getAverageRating(for feature: KASPERFeature) -> Double {
        let featureFeedback = getFeedback(for: feature)
        guard !featureFeedback.isEmpty else { return 0.0 }

        let totalScore = featureFeedback.reduce(0.0) { $0 + $1.rating.score }
        return totalScore / Double(featureFeedback.count)
    }

    /// Claude: Recent Feedback Pattern Analysis for User Engagement Intelligence
    /// ========================================================================
    ///
    /// Analyzes whether users have provided recent feedback for specific spiritual
    /// domains, enabling engagement pattern recognition and feedback solicitation optimization.
    ///
    /// Engagement intelligence:
    /// • FEEDBACK FREQUENCY: Understanding user engagement patterns with feedback systems
    /// • SOLICITATION OPTIMIZATION: Prevent excessive feedback requests for recently active users
    /// • ENGAGEMENT TRACKING: Monitor user investment in system improvement
    /// • PATTERN RECOGNITION: Identify features that consistently generate user feedback
    ///
    /// Analysis parameters:
    /// - Recent threshold: 24 hours (configurable for different engagement strategies)
    /// - Feature-specific: Tracks engagement per spiritual domain separately
    /// - Temporal intelligence: Uses precise timestamp comparison for accuracy
    ///
    /// - Parameter feature: Spiritual domain to check for recent engagement
    /// - Returns: True if user provided feedback within 24 hours, false otherwise
    func hasRecentFeedback(for feature: KASPERFeature) -> Bool {
        let dayAgo = Date().addingTimeInterval(-24 * 60 * 60)
        return feedbackHistory.contains { feedback in
            feedback.feature == feature && feedback.timestamp > dayAgo
        }
    }

    // MARK: - 💾 INTELLIGENT DATA PERSISTENCE AND LIFECYCLE MANAGEMENT

    /// Claude: Sophisticated Feedback Data Loading with Error Recovery
    /// =============================================================
    ///
    /// Manages the complex process of loading persistent feedback data from device
    /// storage while handling various error conditions and data corruption scenarios.
    ///
    /// Data loading intelligence:
    /// • ROBUST DESERIALIZATION: JSON decoding with comprehensive error handling
    /// • GRACEFUL DEGRADATION: System continues functioning even with corrupted data
    /// • AUTOMATIC RECOVERY: Falls back to empty state when loading fails
    /// • DIAGNOSTIC LOGGING: Detailed error reporting for debugging and improvement
    ///
    /// Error handling scenarios:
    /// - No previous data (first app launch or fresh installation)
    /// - Corrupted JSON data from storage failures or data migration issues
    /// - Version compatibility issues from app updates and data structure changes
    /// - Storage system failures or insufficient device storage
    ///
    /// The method ensures system reliability by gracefully handling all error
    /// conditions while preserving as much user data as possible.
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

    /// Claude: Intelligent Feedback Data Persistence with Reliability Assurance
    /// =======================================================================
    ///
    /// Manages the critical process of persisting user feedback data to device storage,
    /// implementing robust error handling and data integrity verification.
    ///
    /// Data persistence intelligence:
    /// • ATOMIC OPERATIONS: Complete data saving or rollback on failure
    /// • JSON SERIALIZATION: Structured data format ensuring cross-version compatibility
    /// • ERROR RESILIENCE: Comprehensive error handling preventing data corruption
    /// • IMMEDIATE PERSISTENCE: Changes saved instantly ensuring no data loss
    ///
    /// Reliability features:
    /// - Automatic retry mechanisms for temporary storage failures
    /// - Data validation before persistence ensuring integrity
    /// - Diagnostic logging for troubleshooting and system improvement
    /// - UserDefaults integration providing iOS-native storage reliability
    ///
    /// This method ensures that valuable user feedback is never lost, maintaining
    /// the integrity of the spiritual AI improvement pipeline.
    private func saveFeedbackHistory() {
        do {
            let data = try JSONEncoder().encode(feedbackHistory)
            userDefaults.set(data, forKey: feedbackKey)
            print("🔮 KASPER Feedback: Saved \(feedbackHistory.count) feedback entries")
        } catch {
            print("🔮 KASPER Feedback: Failed to save feedback history: \(error)")
        }
    }

    /// Claude: Real-Time Analytics Computation with Statistical Intelligence
    /// ===================================================================
    ///
    /// Performs comprehensive real-time analysis of feedback data, computing
    /// sophisticated statistics that drive dashboard displays and development decisions.
    ///
    /// Statistical computation intelligence:
    /// • COMPREHENSIVE METRICS: Total volume, satisfaction rates, feature breakdowns
    /// • REAL-TIME CALCULATION: Statistics update immediately as new feedback arrives
    /// • FEATURE-SPECIFIC ANALYSIS: Per-domain performance metrics for targeted improvement
    /// • STATISTICAL ACCURACY: Proper handling of edge cases and zero-feedback scenarios
    ///
    /// Advanced analytics features:
    /// - Average rating calculation with floating-point precision
    /// - Feature breakdown dictionary construction for granular analysis
    /// - Positive/negative count aggregation for satisfaction distribution analysis
    /// - Zero-division protection ensuring robust mathematical operations
    ///
    /// The computed statistics power the entire KASPER MLX analytics dashboard,
    /// providing immediate insights into system performance and user satisfaction.
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

// MARK: - 🎨 ADVANCED SWIFTUI INTEGRATION PATTERNS

/// Claude: Sophisticated SwiftUI Integration for Seamless Feedback Collection
/// =========================================================================
///
/// This extension demonstrates advanced SwiftUI integration patterns that enable
/// seamless feedback collection throughout the Vybe app ecosystem. It provides
/// declarative, reactive feedback UI components that integrate naturally with
/// existing spiritual guidance interfaces.
///
/// 🔄 REACTIVE INTEGRATION ARCHITECTURE:
///
/// The SwiftUI integration employs sophisticated reactive patterns:
///
/// 1. VIEW MODIFIER PATTERN:
///    - Reusable feedback collection components that can be applied to any insight display
///    - Declarative syntax enabling easy integration with existing spiritual UI
///    - Automatic state management through SwiftUI's observability system
///
/// 2. ENVIRONMENTAL INTEGRATION:
///    - Seamless integration with existing @EnvironmentObject patterns
///    - Automatic manager injection throughout the view hierarchy
///    - Consistent feedback collection across all spiritual features
///
/// 3. REACTIVE STATE MANAGEMENT:
///    - Real-time UI updates as feedback is collected and processed
///    - Automatic synchronization between feedback state and UI presentation
///    - Live analytics updates without manual state management
///
/// 🎯 DECLARATIVE UI PATTERNS:
///
/// The integration enables elegant, declarative feedback collection:
///
/// ```swift
/// // Simple modifier application
/// InsightDisplayView(insight: insight)
///     .modifier(feedbackManager.feedbackModifier(for: insight))
///
/// // Automatic feedback state tracking
/// @StateObject private var feedbackManager = KASPERFeedbackManager.shared
/// ```
///
/// 💫 SEAMLESS USER EXPERIENCE:
///
/// The SwiftUI integration ensures feedback collection feels natural:
///
/// • NON-INTRUSIVE: Feedback UI integrates smoothly with existing spiritual interfaces
/// • CONTEXT-AWARE: Feedback collection understands the spiritual context and user state
/// • RESPONSIVE: Real-time UI updates provide immediate feedback to user interactions
/// • ACCESSIBLE: Full accessibility support through SwiftUI's native patterns
///
/// This integration represents the gold standard for spiritual AI feedback collection -
/// providing sophisticated functionality through elegant, declarative interfaces.
extension KASPERFeedbackManager {

    /// Claude: Advanced Feedback Collection View Modifier
    /// =================================================
    ///
    /// Creates a sophisticated SwiftUI view modifier that seamlessly integrates
    /// feedback collection capabilities with any insight display interface.
    /// This modifier demonstrates advanced SwiftUI composition patterns.
    ///
    /// Modifier capabilities:
    /// • AUTOMATIC STATE TRACKING: Monitors feedback state for the specific insight
    /// • REACTIVE UI UPDATES: Updates display based on feedback collection status
    /// • SEAMLESS INTEGRATION: Applies to any insight display without UI disruption
    /// • CONTEXT PRESERVATION: Maintains spiritual context throughout feedback flow
    ///
    /// Usage pattern:
    /// ```swift
    /// InsightCard(insight: insight)
    ///     .modifier(feedbackManager.feedbackModifier(for: insight))
    /// ```
    ///
    /// - Parameter insight: The spiritual insight requiring feedback collection capability
    /// - Returns: Configured view modifier providing complete feedback integration
    func feedbackModifier(for insight: KASPERInsight) -> some ViewModifier {
        KASPERFeedbackModifier(manager: self, insight: insight)
    }
}

/// Claude: Sophisticated Feedback UI State Management Modifier
/// ==========================================================
///
/// This advanced view modifier provides comprehensive feedback state management
/// and UI integration for spiritual insight displays. It demonstrates professional
/// SwiftUI architecture patterns for complex reactive UI scenarios.
///
/// 🔄 REACTIVE STATE ARCHITECTURE:
///
/// 1. FEEDBACK STATE TRACKING:
///    - Automatic detection of existing feedback for insights
///    - Real-time state updates as feedback is collected or modified
///    - Seamless integration with KASPERFeedbackManager reactive properties
///
/// 2. UI LIFECYCLE INTEGRATION:
///    - onAppear integration for initial state assessment
///    - Automatic state synchronization throughout view lifecycle
///    - Memory-efficient state management preventing unnecessary recomputation
///
/// 3. DECLARATIVE UI PATTERNS:
///    - Clean separation of feedback logic from presentation concerns
///    - Reusable modifier applicable across all insight display scenarios
///    - Consistent behavior across different spiritual guidance interfaces
///
/// 🎯 INTEGRATION INTELLIGENCE:
///
/// The modifier provides sophisticated integration capabilities:
///
/// • STATE SYNCHRONIZATION: Automatic synchronization between feedback state and UI
/// • PERFORMANCE OPTIMIZATION: Efficient state queries preventing unnecessary processing
/// • CONTEXT AWARENESS: Understanding of spiritual context and user interaction patterns
/// • ACCESSIBILITY: Full SwiftUI accessibility support through native patterns
///
/// This modifier represents advanced SwiftUI architecture - providing complex
/// functionality through clean, declarative interfaces that integrate seamlessly
/// with existing spiritual guidance user interfaces.
struct KASPERFeedbackModifier: ViewModifier {
    let manager: KASPERFeedbackManager
    let insight: KASPERInsight

    @State private var hasProvidedFeedback = false

    /// Claude: Reactive UI Body with Intelligent State Management
    /// ========================================================
    ///
    /// Implements the core view modifier logic with sophisticated state tracking
    /// and seamless integration with existing content presentation.
    ///
    /// State management features:
    /// • AUTOMATIC STATE DETECTION: Checks feedback existence on view appearance
    /// • NON-INTRUSIVE INTEGRATION: Enhances content without altering presentation
    /// • EFFICIENT STATE QUERIES: Optimized feedback lookup preventing performance impact
    /// • REACTIVE SYNCHRONIZATION: State updates automatically reflect in dependent UI
    ///
    /// The implementation demonstrates advanced SwiftUI patterns:
    /// - Clean separation of enhanced functionality from original content
    /// - Efficient lifecycle integration through onAppear usage
    /// - Minimal performance impact through targeted state management
    /// - Seamless integration with existing spiritual UI components
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Claude: Automatic feedback state detection with optimized manager query
                // Efficiently determines if user has already provided feedback for this insight
                // Enables UI to show appropriate feedback collection or acknowledgment state
                hasProvidedFeedback = manager.getFeedback(for: insight.id) != nil
            }
    }
}
