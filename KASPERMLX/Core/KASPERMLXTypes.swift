/**
 * KASPER MLX Core Types
 * 
 * Defines the foundational types and protocols for KASPER MLX - the next generation
 * of spiritual AI inference powered by Apple's MLX framework.
 * 
 * Architecture Philosophy:
 * - Lightweight, focused data structures
 * - Async-first design patterns
 * - Modular, composable providers
 * - Feature-specific contexts
 * - On-device inference optimization
 */

import Foundation

// MARK: - Core Enums

/// Features that can request KASPER MLX insights
enum KASPERFeature: String, CaseIterable {
    case journalInsight = "journal"
    case dailyCard = "daily_card"
    case sanctumGuidance = "sanctum"
    case matchCompatibility = "match"
    case cosmicTiming = "cosmic"
    case focusIntention = "focus"
    case realmInterpretation = "realm"
}

/// Types of insights KASPER MLX can generate
enum InsightType: String {
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
    var id: String { get }
    
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
    let type: InsightType
    let priority: InsightPriority
    let context: InsightContext
    let requiredProviders: Set<String>
    let createdAt: Date = Date()
    
    init(
        feature: KASPERFeature,
        type: InsightType,
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
    let type: InsightType
    let feature: KASPERFeature
    let confidence: Double
    let generatedAt: Date
    let inferenceTime: TimeInterval
    let metadata: InsightMetadata
    
    init(
        requestId: UUID,
        content: String,
        type: InsightType,
        feature: KASPERFeature,
        confidence: Double,
        inferenceTime: TimeInterval,
        metadata: InsightMetadata = InsightMetadata()
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

/// Metadata about generated insights
struct InsightMetadata {
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