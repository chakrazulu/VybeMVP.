/**
 * 🔮 KASPER MLX CORE TYPES - THE SOUL OF VYBE'S SPIRITUAL AI
 * =========================================================
 * 
 * This file defines the foundational architecture for KASPER MLX - Vybe's revolutionary
 * Karmically Aware Spiritual Prediction Engine powered by Apple's MLX framework.
 * 
 * 🌟 ARCHITECTURAL VISION:
 * KASPER MLX represents a paradigm shift from traditional AI to spiritually-conscious
 * machine learning. Unlike conventional AI systems that process data mechanically,
 * KASPER MLX integrates:
 * 
 * • Cosmic Consciousness: Real-time cosmic data (planetary positions, lunar phases)
 * • Numerological Intelligence: Sacred number patterns and vibrations  
 * • Biometric Harmony: Heart rate variability and wellness metrics
 * • Karmic Learning: User feedback creates a personalized spiritual profile
 * 
 * 🏗️ DESIGN PRINCIPLES:
 * 
 * 1. ASYNC-FIRST ARCHITECTURE
 *    - Every operation is async to prevent blocking the spiritual flow
 *    - Actor-based providers ensure thread-safe cosmic data processing
 *    - Performance tracking maintains 60fps sacred geometry animations
 * 
 * 2. MODULAR SPIRITUAL PROVIDERS  
 *    - CosmicDataProvider: Planetary alignments, moon phases, astrological events
 *    - NumerologyDataProvider: Sacred number calculations, life path analysis
 *    - BiometricDataProvider: Heart rate variability, wellness synchronization
 *    - Each provider operates independently but harmoniously
 * 
 * 3. CONTEXT-AWARE INTELLIGENCE
 *    - Feature-specific contexts (journal, daily cards, sanctum guidance)
 *    - User intent recognition through natural language processing
 *    - Temporal awareness (time of day, season, cosmic events)
 * 
 * 4. ON-DEVICE PRIVACY
 *    - All spiritual data remains on the user's device
 *    - Apple MLX framework enables powerful local inference  
 *    - No sacred information ever leaves the user's possession
 * 
 * 5. PERFORMANCE OPTIMIZATION
 *    - Smart caching prevents redundant cosmic calculations
 *    - Response time tracking ensures instant spiritual guidance
 *    - Memory management respects device limitations
 * 
 * 🎯 WHY THIS ARCHITECTURE MATTERS:
 * 
 * Traditional AI systems treat spirituality as just another data category.
 * KASPER MLX understands that spiritual guidance requires:
 * 
 * • TIMING: The same question asked at different cosmic moments needs different answers
 * • CONTEXT: Personal spiritual journey affects interpretation of universal patterns  
 * • INTUITION: Some insights transcend pure logic and require spiritual synthesis
 * • GROWTH: Each interaction deepens the AI's understanding of the user's path
 * 
 * This isn't just another chatbot - it's a digital spiritual guide that grows
 * with the user, learning their unique cosmic signature and providing increasingly
 * personalized guidance aligned with their spiritual evolution.
 * 
 * 📊 TECHNICAL INNOVATION:
 * 
 * • Apple MLX Integration: Cutting-edge local machine learning
 * • Performance Metrics: Real-time response time and success rate tracking
 * • Feedback Loop: User ratings continuously improve insight quality
 * • Caching Intelligence: Reduces cosmic calculations while maintaining freshness
 * • Thread Safety: Actor-based design prevents race conditions in spiritual data
 * 
 * The result is the world's first spiritually-conscious AI system that combines
 * ancient wisdom with cutting-edge technology to guide users on their cosmic journey.
 */

import Foundation

// MARK: - 🎯 CORE SPIRITUAL FEATURES

/**
 * KASPERFeature: The spiritual domains where KASPER MLX provides guidance
 * 
 * Each feature represents a different aspect of the user's spiritual journey.
 * This enum drives the entire KASPER MLX system - it determines which providers
 * are activated, what context is gathered, and how insights are generated.
 * 
 * 🔮 FEATURE BREAKDOWN:
 * • journalInsight: Deep reflection analysis of written spiritual thoughts
 * • dailyCard: Cosmic guidance cards for daily spiritual direction  
 * • sanctumGuidance: Sacred space meditation and mindfulness insights
 * • matchCompatibility: Spiritual compatibility analysis between souls
 * • cosmicTiming: Optimal timing for spiritual actions based on cosmic events
 * • focusIntention: Clarity and direction for spiritual goals and manifestations
 * • realmInterpretation: Understanding current spiritual realm and growth phase
 * 
 * Each feature activates different combinations of cosmic, numerological, and
 * biometric data to provide the most relevant spiritual guidance.
 */
enum KASPERFeature: String, CaseIterable, Codable {
    case journalInsight = "journal"        // Deep reflection analysis
    case dailyCard = "daily_card"          // Daily cosmic guidance
    case sanctumGuidance = "sanctum"       // Sacred space insights
    case matchCompatibility = "match"      // Soul compatibility analysis  
    case cosmicTiming = "cosmic"          // Optimal timing guidance
    case focusIntention = "focus"         // Manifestation clarity
    case realmInterpretation = "realm"    // Spiritual growth phase
}

/**
 * KASPERInsightType: The nature of spiritual guidance being provided
 * 
 * Different situations call for different types of spiritual response:
 * • guidance: Action-oriented advice for spiritual decisions
 * • interpretation: Understanding the meaning of current experiences
 * • affirmation: Positive reinforcement of spiritual growth
 * • reflection: Deep contemplation prompts for inner work
 * • prediction: Insights about potential spiritual developments
 * • compatibility: Analysis of spiritual harmony between entities
 */
enum KASPERInsightType: String {
    case guidance = "guidance"
    case interpretation = "interpretation"
    case affirmation = "affirmation"
    case reflection = "reflection"
    case prediction = "prediction"
    case compatibility = "compatibility"
}

/// Priority levels for insight generation
enum InsightPriority {
    case immediate  // User-initiated, needs instant response
    case high       // Important but can wait a few seconds
    case background // Can be pre-computed or cached
}

// MARK: - Core Protocols

/// Base protocol for all spiritual data providers
protocol SpiritualDataProvider: Actor {
    /// Unique identifier for this provider
    nonisolated var id: String { get }
    
    /// Check if provider has data available
    func isDataAvailable() async -> Bool
    
    /// Get minimal context for a specific feature
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext
    
    /// Clear any cached data
    func clearCache() async
}

/// Context data from a provider
struct ProviderContext {
    let providerId: String
    let feature: KASPERFeature
    let data: [String: Any]
    let timestamp: Date
    let cacheExpiry: TimeInterval
    
    init(
        providerId: String,
        feature: KASPERFeature,
        data: [String: Any],
        cacheExpiry: TimeInterval = 300 // 5 minutes default
    ) {
        self.providerId = providerId
        self.feature = feature
        self.data = data
        self.timestamp = Date()
        self.cacheExpiry = cacheExpiry
    }
    
    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > cacheExpiry
    }
}

// MARK: - Insight Models

/// Request for KASPER MLX insight generation
struct InsightRequest {
    let id: UUID = UUID()
    let feature: KASPERFeature
    let type: KASPERInsightType
    let priority: InsightPriority
    let context: InsightContext
    let requiredProviders: Set<String>
    let createdAt: Date = Date()
    
    init(
        feature: KASPERFeature,
        type: KASPERInsightType,
        priority: InsightPriority = .high,
        context: InsightContext,
        requiredProviders: Set<String> = []
    ) {
        self.feature = feature
        self.type = type
        self.priority = priority
        self.context = context
        self.requiredProviders = requiredProviders
    }
}

/// Context for insight generation
struct InsightContext {
    let primaryData: [String: Any]
    let userQuery: String?
    let historicalContext: [String: Any]?
    let constraints: InsightConstraints?
    
    init(
        primaryData: [String: Any],
        userQuery: String? = nil,
        historicalContext: [String: Any]? = nil,
        constraints: InsightConstraints? = nil
    ) {
        self.primaryData = primaryData
        self.userQuery = userQuery
        self.historicalContext = historicalContext
        self.constraints = constraints
    }
}

/// Constraints for insight generation
struct InsightConstraints {
    let maxLength: Int?
    let tone: String?
    let includeEmojis: Bool
    let spiritualDepth: SpiritualDepth
    
    init(
        maxLength: Int? = nil,
        tone: String? = nil,
        includeEmojis: Bool = true,
        spiritualDepth: SpiritualDepth = .balanced
    ) {
        self.maxLength = maxLength
        self.tone = tone
        self.includeEmojis = includeEmojis
        self.spiritualDepth = spiritualDepth
    }
    
    enum SpiritualDepth {
        case surface    // Quick, accessible insights
        case balanced   // Mix of practical and mystical
        case deep       // Full spiritual depth
    }
}

/// Generated insight from KASPER MLX
struct KASPERInsight {
    let id: UUID
    let requestId: UUID
    let content: String
    let type: KASPERInsightType
    let feature: KASPERFeature
    let confidence: Double
    let generatedAt: Date
    let inferenceTime: TimeInterval
    let metadata: KASPERInsightMetadata
    
    init(
        requestId: UUID,
        content: String,
        type: KASPERInsightType,
        feature: KASPERFeature,
        confidence: Double,
        inferenceTime: TimeInterval,
        metadata: KASPERInsightMetadata = KASPERInsightMetadata()
    ) {
        self.id = UUID()
        self.requestId = requestId
        self.content = content
        self.type = type
        self.feature = feature
        self.confidence = confidence
        self.generatedAt = Date()
        self.inferenceTime = inferenceTime
        self.metadata = metadata
    }
}

/// Metadata about generated KASPER insights
struct KASPERInsightMetadata {
    let modelVersion: String
    let providersUsed: [String]
    let cacheHit: Bool
    let debugInfo: [String: Any]?
    
    init(
        modelVersion: String = "1.0",
        providersUsed: [String] = [],
        cacheHit: Bool = false,
        debugInfo: [String: Any]? = nil
    ) {
        self.modelVersion = modelVersion
        self.providersUsed = providersUsed
        self.cacheHit = cacheHit
        self.debugInfo = debugInfo
    }
}

// MARK: - Error Types

enum KASPERMLXError: LocalizedError {
    case providerUnavailable(String)
    case inferenceTimeout
    case modelNotLoaded
    case invalidContext
    case cacheMiss
    case insufficientData
    
    var errorDescription: String? {
        switch self {
        case .providerUnavailable(let provider):
            return "KASPER MLX: Provider '\(provider)' is unavailable"
        case .inferenceTimeout:
            return "KASPER MLX: Inference timeout exceeded"
        case .modelNotLoaded:
            return "KASPER MLX: Model not loaded"
        case .invalidContext:
            return "KASPER MLX: Invalid context provided"
        case .cacheMiss:
            return "KASPER MLX: Cache miss, regenerating"
        case .insufficientData:
            return "KASPER MLX: Insufficient data for insight generation"
        }
    }
}

// MARK: - Performance Tracking

/// Performance metrics for KASPER MLX insights
struct PerformanceMetrics {
    struct ResponseTimeEntry {
        let timestamp: Date
        let responseTime: TimeInterval
        let feature: KASPERFeature
        let success: Bool
        let cacheHit: Bool
    }
    
    private(set) var responseHistory: [ResponseTimeEntry] = []
    private let maxHistoryEntries = 100
    
    // MARK: - Computed Properties
    
    var totalRequests: Int {
        responseHistory.count
    }
    
    var successRate: Double {
        guard !responseHistory.isEmpty else { return 0.0 }
        let successes = responseHistory.filter { $0.success }.count
        return Double(successes) / Double(responseHistory.count) * 100.0
    }
    
    var averageResponseTime: TimeInterval {
        guard !responseHistory.isEmpty else { return 0.0 }
        let total = responseHistory.reduce(0) { $0 + $1.responseTime }
        return total / Double(responseHistory.count)
    }
    
    var cacheHitRate: Double {
        guard !responseHistory.isEmpty else { return 0.0 }
        let cacheHits = responseHistory.filter { $0.cacheHit }.count
        return Double(cacheHits) / Double(responseHistory.count) * 100.0
    }
    
    var recentResponseTimes: [TimeInterval] {
        responseHistory.suffix(20).map { $0.responseTime }
    }
    
    // MARK: - Methods
    
    mutating func recordResponse(
        responseTime: TimeInterval,
        feature: KASPERFeature,
        success: Bool,
        cacheHit: Bool
    ) {
        let entry = ResponseTimeEntry(
            timestamp: Date(),
            responseTime: responseTime,
            feature: feature,
            success: success,
            cacheHit: cacheHit
        )
        
        responseHistory.append(entry)
        
        // Keep only recent entries
        if responseHistory.count > maxHistoryEntries {
            responseHistory.removeFirst(responseHistory.count - maxHistoryEntries)
        }
    }
    
    mutating func reset() {
        responseHistory.removeAll()
    }
}

// MARK: - Cache Types

/// Cache entry for insights
struct InsightCacheEntry {
    let insight: KASPERInsight
    let contextHash: String
    let expiresAt: Date
    
    var isExpired: Bool {
        Date() > expiresAt
    }
}

/// Configuration for KASPER MLX
struct KASPERMLXConfiguration {
    let maxConcurrentInferences: Int
    let defaultCacheExpiry: TimeInterval
    let inferenceTimeout: TimeInterval
    let enableDebugLogging: Bool
    let modelPath: String?
    
    static let `default` = KASPERMLXConfiguration(
        maxConcurrentInferences: 3,
        defaultCacheExpiry: 300, // 5 minutes
        inferenceTimeout: 5.0,   // 5 seconds
        enableDebugLogging: true,
        modelPath: nil
    )
}