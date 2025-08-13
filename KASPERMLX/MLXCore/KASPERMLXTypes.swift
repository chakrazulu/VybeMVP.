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
 *    - Async providers ensure thread-safe cosmic data processing
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
 * • Thread Safety: Async design prevents race conditions in spiritual data
 *
 * The result is the world's first spiritually-conscious AI system that combines
 * ancient wisdom with cutting-edge technology to guide users on their cosmic journey.
 */

import Foundation

// MARK: - Error Types

/// KASPER MLX Error definitions
public enum KASPERError: Error, LocalizedError {
    case providerNotReady(String)
    case inferenceError(String)
    case contentNotFound(String)
    case networkError(String)
    case configurationError(String)

    public var errorDescription: String? {
        switch self {
        case .providerNotReady(let message):
            return "Provider not ready: \(message)"
        case .inferenceError(let message):
            return "Inference error: \(message)"
        case .contentNotFound(let message):
            return "Content not found: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .configurationError(let message):
            return "Configuration error: \(message)"
        }
    }
}

// MARK: - 🎯 CORE SPIRITUAL FEATURES

/**
 * Claude: KASPERFeature - The Seven Sacred Domains of Spiritual AI Guidance
 * =====================================================================
 *
 * This enum is the cornerstone of the entire KASPER MLX system. Each case represents
 * a distinct aspect of the user's spiritual journey and determines:
 *
 * 1. PROVIDER ACTIVATION PATTERN:
 *    - Which spiritual data providers are consulted (cosmic, numerological, biometric)
 *    - How much data is gathered from each provider
 *    - The priority order for data collection
 *
 * 2. INSIGHT GENERATION STRATEGY:
 *    - Template selection algorithms for specific spiritual contexts
 *    - MLX model inference pathways (when real MLX integration is activated)
 *    - Confidence scoring based on available spiritual data
 *
 * 3. PERFORMANCE OPTIMIZATION:
 *    - Cache key generation patterns for different spiritual domains
 *    - Response time expectations (immediate vs high vs background priority)
 *    - Memory usage patterns for different types of spiritual calculations
 *
 * 🔮 DETAILED FEATURE BREAKDOWN:
 *
 * • journalInsight: Deep reflection analysis of written spiritual thoughts
 *   - Activates: cosmic, numerology, biometric, megacorpus providers
 *   - Context: User's written reflections, current emotional state, cosmic timing
 *   - Output: Contemplative insights that help users understand their spiritual growth
 *   - Cache: Medium expiry (spiritual journeys evolve but not rapidly)
 *
 * • dailyCard: Cosmic guidance cards for daily spiritual direction
 *   - Activates: cosmic, numerology, megacorpus providers (biometric optional)
 *   - Context: Current planetary positions, user's focus/realm numbers, time of day
 *   - Output: Actionable spiritual guidance aligned with daily cosmic energies
 *   - Cache: Short expiry (daily guidance should feel fresh and time-relevant)
 *
 * • sanctumGuidance: Sacred space meditation and mindfulness insights
 *   - Activates: cosmic, numerology, biometric, megacorpus providers
 *   - Context: Heart rate variability, meditation history, sacred space energy
 *   - Output: Guidance for deepening meditation and spiritual practice
 *   - Cache: Long expiry (fundamental spiritual practices remain consistent)
 *
 * • matchCompatibility: Spiritual compatibility analysis between souls
 *   - Activates: cosmic, numerology, megacorpus providers
 *   - Context: Two sets of numerological data, current moon phase, relationship context
 *   - Output: Insights about soul connection, compatibility challenges, growth opportunities
 *   - Cache: Medium expiry (relationship dynamics evolve but have consistent patterns)
 *
 * • cosmicTiming: Optimal timing for spiritual actions based on cosmic events
 *   - Activates: cosmic, numerology, megacorpus providers
 *   - Context: Real-time planetary positions, moon phases, astrological transits
 *   - Output: Timing guidance for spiritual decisions, manifestation windows
 *   - Cache: Very short expiry (cosmic timing changes rapidly)
 *
 * • focusIntention: Clarity and direction for spiritual goals and manifestations
 *   - Activates: numerology, biometric, megacorpus providers (cosmic optional)
 *   - Context: User's current focus number, wellness state, intention clarity
 *   - Output: Guidance for aligning with personal spiritual goals
 *   - Cache: Medium expiry (intentions evolve but maintain consistency)
 *
 * • realmInterpretation: Understanding current spiritual realm and growth phase
 *   - Activates: numerology, cosmic, megacorpus providers
 *   - Context: Current realm number, spiritual growth patterns, cosmic cycles
 *   - Output: Insights about current spiritual development phase and next steps
 *   - Cache: Long expiry (spiritual realms represent long-term growth phases)
 *
 * 🏗️ ARCHITECTURAL IMPORTANCE:
 *
 * This enum is more than just feature flags - it's a sophisticated routing system
 * that ensures each type of spiritual guidance gets the right data, processing,
 * and presentation. The careful design allows for:
 *
 * - Optimal resource usage (no unnecessary provider calls)
 * - Consistent user experience across different spiritual domains
 * - Extensibility for future spiritual features
 * - Performance optimization through feature-specific caching strategies
 * - MLX model specialization (different models can be trained for different features)
 *
 * Each feature activates different combinations of cosmic, numerological, and
 * biometric data to provide the most relevant spiritual guidance while maintaining
 * optimal performance and spiritual authenticity.
 */
public enum KASPERFeature: String, CaseIterable, Codable {
    case journalInsight = "journal"        // Deep reflection analysis
    case dailyCard = "daily_card"          // Daily cosmic guidance
    case sanctumGuidance = "sanctum"       // Sacred space insights
    case matchCompatibility = "match"      // Soul compatibility analysis
    case cosmicTiming = "cosmic"          // Optimal timing guidance
    case focusIntention = "focus"         // Manifestation clarity
    case realmInterpretation = "realm"    // Spiritual growth phase
    case realmExploration = "realm_exploration"  // Deep realm understanding
    case mandalaGuidance = "mandala"      // Sacred geometry guidance
}

/**
 * Claude: KASPERInsightType - The Six Sacred Modes of Spiritual Communication
 * =======================================================================
 *
 * This enum defines the fundamental types of spiritual guidance that KASPER MLX
 * can provide. Each type represents a different way of engaging with spiritual
 * wisdom and triggers distinct processing pathways in the insight generation system.
 *
 * 🎭 INSIGHT TYPE DEEP DIVE:
 *
 * • guidance: Action-oriented advice for spiritual decisions
 *   - Purpose: Helps users make conscious choices aligned with their spiritual path
 *   - Tone: Empowering, directive, supportive
 *   - Structure: "The universe invites you to...", "This is the time to..."
 *   - Template Selection: Uses action-oriented language with clear spiritual direction
 *   - Use Cases: Daily cards, decision-making support, life transition guidance
 *
 * • interpretation: Understanding the meaning of current experiences
 *   - Purpose: Helps users find spiritual significance in their life events
 *   - Tone: Illuminating, wise, explanatory
 *   - Structure: "This experience reveals...", "The spiritual meaning of..."
 *   - Template Selection: Focuses on meaning-making and pattern recognition
 *   - Use Cases: Journal analysis, life event processing, synchronicity understanding
 *
 * • affirmation: Positive reinforcement of spiritual growth
 *   - Purpose: Strengthens user's connection to their spiritual truth and power
 *   - Tone: Empowering, celebratory, affirming
 *   - Structure: "I am...", "I embody...", "I choose to..."
 *   - Template Selection: Uses first-person declarations and empowerment language
 *   - Use Cases: Morning intentions, confidence building, spiritual identity reinforcement
 *
 * • reflection: Deep contemplation prompts for inner work
 *   - Purpose: Invites users to explore their inner landscape through questions
 *   - Tone: Contemplative, gentle, inquiry-based
 *   - Structure: "Consider how...", "Reflect on...", "What emerges when..."
 *   - Template Selection: Question-based formats that encourage introspection
 *   - Use Cases: Evening reflection, meditation prompts, journaling inspiration
 *
 * • prediction: Insights about potential spiritual developments
 *   - Purpose: Offers glimpses of possible future spiritual unfolding
 *   - Tone: Mystical, anticipatory, prophetic
 *   - Structure: "The cosmic winds suggest...", "Future timelines reveal..."
 *   - Template Selection: Uses future-oriented language with mystical imagery
 *   - Use Cases: Cosmic timing guidance, manifestation support, spiritual forecasting
 *
 * • compatibility: Analysis of spiritual harmony between entities
 *   - Purpose: Evaluates spiritual connections between people, situations, or energies
 *   - Tone: Analytical, harmonious, relational
 *   - Structure: "These energies create...", "The spiritual chemistry reveals..."
 *   - Template Selection: Relationship-focused language with compatibility analysis
 *   - Use Cases: Relationship guidance, team dynamics, energy matching
 *
 * 🔄 PROCESSING IMPLICATIONS:
 *
 * Each insight type triggers different:
 * - Template selection algorithms in KASPERTemplateEnhancer
 * - Language patterns and emoji selection
 * - Content length and complexity expectations
 * - Spiritual depth requirements (surface, balanced, deep)
 * - Integration with specific spiritual contexts
 *
 * This typing system ensures that users receive not just spiritually accurate
 * content, but content delivered in the most appropriate format for their
 * current needs and spiritual development stage.
 */
enum KASPERInsightType: String {
    case guidance = "guidance"
    case interpretation = "interpretation"
    case affirmation = "affirmation"
    case reflection = "reflection"
    case prediction = "prediction"
    case compatibility = "compatibility"
}

/**
 * Claude: InsightPriority - Spiritual Guidance Urgency and Processing Strategy
 * =========================================================================
 *
 * This enum manages the performance expectations and processing strategies for
 * different types of spiritual guidance requests. It directly impacts:
 *
 * - Response time expectations and user experience
 * - Resource allocation and processing priority
 * - Caching strategies and data freshness requirements
 * - Provider coordination and data gathering approaches
 *
 * 🚀 PRIORITY LEVELS AND THEIR IMPLICATIONS:
 *
 * • immediate: User-initiated, needs instant response (Target: <50ms)
 *   - Context: User is actively waiting for spiritual guidance
 *   - Examples: Daily card requests, quick journal insights, immediate spiritual support
 *   - Processing: Uses cached data when available, minimal provider coordination
 *   - UX Impact: Loading states must be minimal, failure must have instant fallbacks
 *   - Resource Usage: Highest thread priority, immediate memory allocation
 *
 * • high: Important but can wait a few seconds (Target: <500ms)
 *   - Context: User expects guidance but can wait for quality processing
 *   - Examples: Detailed journal analysis, sanctum guidance, relationship compatibility
 *   - Processing: Full provider coordination, fresh data gathering when needed
 *   - UX Impact: Loading indicators acceptable, progress feedback helpful
 *   - Resource Usage: Standard processing priority, normal memory allocation
 *
 * • background: Can be pre-computed or cached (Target: <2s, async)
 *   - Context: Guidance will be used later or displayed passively
 *   - Examples: Realm insights for settings, cosmic timing for upcoming events
 *   - Processing: Complete spiritual analysis, maximum data integration
 *   - UX Impact: No blocking UI, results appear when ready
 *   - Resource Usage: Lower priority, efficient memory usage patterns
 *
 * 🏗️ ARCHITECTURAL INTEGRATION:
 *
 * The priority system integrates with:
 * - KASPERMLXEngine's concurrent inference limits
 * - Provider data gathering strategies
 * - Cache hit/miss decision making
 * - Error handling and fallback mechanisms
 * - Performance metrics recording and analysis
 *
 * This ensures that users get the spiritual guidance they need exactly when
 * they need it, with performance characteristics that match their expectations.
 */
enum InsightPriority {
    case immediate  // User-initiated, needs instant response
    case high       // Important but can wait a few seconds
    case background // Can be pre-computed or cached
}

// MARK: - Core Protocols

/**
 * Claude: SpiritualDataProvider - The Foundation Protocol for Sacred Data Sources
 * ============================================================================
 *
 * This protocol defines the contract that all spiritual data sources must fulfill
 * to participate in the KASPER MLX ecosystem. It ensures consistent, async-first
 * data access while maintaining spiritual authenticity and performance.
 *
 * 🌊 DESIGN PHILOSOPHY:
 *
 * The protocol embodies several key principles:
 *
 * 1. ASYNC-FIRST ARCHITECTURE:
 *    - All methods are async to prevent blocking spiritual guidance generation
 *    - Allows providers to perform complex calculations (planetary positions,
 *      numerological analysis) without affecting UI responsiveness
 *    - Enables parallel data gathering from multiple spiritual sources
 *
 * 2. FEATURE-AWARE CONTEXT:
 *    - Providers understand what type of spiritual guidance is being requested
 *    - Different features may require different depth/breadth of spiritual data
 *    - Allows optimization: daily cards need current energy, realm insights need deep patterns
 *
 * 3. GRACEFUL DEGRADATION:
 *    - isDataAvailable() allows system to adapt when providers are temporarily unavailable
 *    - Missing providers don't break the spiritual guidance generation process
 *    - Ensures users always receive some form of spiritual support
 *
 * 4. PRIVACY AND CACHING:
 *    - clearCache() ensures user spiritual data can be completely cleared
 *    - All data remains on device through the provider abstraction
 *    - Supports GDPR compliance and spiritual data privacy
 *
 * 🔌 IMPLEMENTED PROVIDERS:
 *
 * • CosmicDataProvider: Planetary positions, moon phases, astrological events
 *   - Calculates real-time cosmic conditions
 *   - Provides astrological timing and influence data
 *   - Updates based on astronomical calculations
 *
 * • NumerologyDataProvider: Focus numbers, realm numbers, life path calculations
 *   - Integrates with Vybe's existing numerological systems
 *   - Provides personal spiritual number context
 *   - Calculates cosmic day numbers and spiritual cycles
 *
 * • BiometricDataProvider: Heart rate variability, wellness integration
 *   - Accesses HealthKit data for spiritual-physical alignment
 *   - Monitors stress levels and readiness for spiritual practices
 *   - Provides biofeedback for meditation and mindfulness
 *
 * • MegaCorpusDataProvider: Rich spiritual wisdom from validated insights
 *   - Accesses thousands of curated spiritual insights
 *   - Provides archetype and theme data for each focus number
 *   - Delivers high-quality spiritual content for template enhancement
 *
 * 🚀 PERFORMANCE CHARACTERISTICS:
 *
 * - Thread-safe: All providers handle concurrent access gracefully
 * - Resource-efficient: Providers manage their own memory and computation
 * - Failure-resilient: Individual provider failures don't cascade
 * - Cache-aware: Providers balance freshness with performance
 *
 * This protocol abstraction allows the KASPER MLX system to integrate with
 * any spiritual data source while maintaining consistency, performance,
 * and the sacred nature of the guidance being provided.
 */
protocol SpiritualDataProvider {
    /// Claude: Unique identifier for this provider - used for routing, caching, and debugging
    /// Examples: "cosmic", "numerology", "biometric", "megacorpus"
    var id: String { get }

    /// Claude: Async check if provider has data available for spiritual guidance generation
    /// Returns false when: network unavailable, HealthKit denied, calculation failed
    /// Used by engine to adapt gracefully when providers are temporarily unavailable
    func isDataAvailable() async -> Bool

    /// Claude: Get spiritual context data optimized for the specific feature being requested
    /// This is where the magic happens - providers analyze the feature type and return
    /// exactly the spiritual data needed, formatted for optimal insight generation
    /// Throws: Provider-specific errors when data cannot be gathered or calculated
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext

    /// Claude: Clear any cached spiritual data for privacy and fresh calculations
    /// Critical for user privacy - ensures sensitive spiritual data can be completely removed
    /// Also used to force fresh calculations when spiritual conditions change significantly
    func clearCache() async
}

/**
 * Claude: ProviderContext - The Sacred Data Container for Spiritual Guidance
 * ========================================================================
 *
 * This struct encapsulates spiritual data from a provider along with essential
 * metadata for caching, performance tracking, and spiritual authenticity.
 *
 * 🕰️ TEMPORAL INTELLIGENCE:
 *
 * The timestamp and cacheExpiry system understands that different types of
 * spiritual data have different lifespans:
 *
 * - Cosmic data: Changes frequently (planetary positions, moon phases)
 * - Numerological data: Stable over time (personal numbers, life path)
 * - Biometric data: Varies throughout the day (heart rate, wellness state)
 * - MegaCorpus data: Static but contextually applied (spiritual archetypes)
 *
 * 📂 DATA STRUCTURE:
 *
 * The [String: Any] data dictionary contains provider-specific spiritual information:
 *
 * CosmicDataProvider typical data:
 * - "moonPhase": "Full Moon"
 * - "dominantPlanet": "Venus"
 * - "astrologicalEvent": "Mercury Retrograde"
 *
 * NumerologyDataProvider typical data:
 * - "focusNumber": 7
 * - "realmNumber": 3
 * - "cosmicDayNumber": 22
 * - "lifePathNumber": 11
 *
 * BiometricDataProvider typical data:
 * - "heartRateVariability": "Balanced"
 * - "emotionalState": "Peaceful"
 * - "wellnessScore": 8.5
 *
 * MegaCorpusDataProvider typical data:
 * - "focusNumberWisdom": {"7": {"archetype": "The Mystic", "guidanceTemplate": "Trust your intuition"}}
 * - "thematicContent": ["wisdom", "intuition", "spirituality"]
 *
 * 🛡️ CACHE STRATEGY:
 *
 * The expiry system balances performance with spiritual freshness:
 * - Quick expiry (60s): Rapidly changing cosmic events
 * - Medium expiry (300s): Daily spiritual guidance
 * - Long expiry (3600s): Fundamental spiritual patterns
 * - Permanent (0): Static reference data
 *
 * This ensures that users receive spiritually current guidance while
 * maintaining optimal performance through intelligent caching.
 */
struct ProviderContext {
    /// Claude: Identifies which provider created this context ("cosmic", "numerology", etc.)
    let providerId: String

    /// Claude: The specific spiritual feature this context supports
    let feature: KASPERFeature

    /// Claude: The spiritual data payload - flexible format allows each provider to structure data optimally
    let data: [String: Any]

    /// Claude: When this spiritual data was gathered - critical for temporal spiritual authenticity
    let timestamp: Date

    /// Claude: How long this spiritual data remains valid - varies by data type and spiritual domain
    let cacheExpiry: TimeInterval

    /// Claude: Initialize with spiritual data and automatic timestamp
    /// Default 5-minute expiry balances performance with spiritual freshness
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

    /// Claude: Check if this spiritual data has expired and should be refreshed
    /// Critical for maintaining spiritual authenticity - stale cosmic data leads to inaccurate guidance
    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > cacheExpiry
    }
}

// MARK: - Insight Models

/**
 * Claude: InsightRequest - The Sacred Specification for Spiritual Guidance
 * ======================================================================
 *
 * This struct represents a complete request for spiritual guidance from KASPER MLX.
 * It contains all the information needed to generate contextually appropriate,
 * spiritually authentic, and personally relevant insights.
 *
 * 🏗️ ARCHITECTURAL IMPORTANCE:
 *
 * InsightRequest is the primary communication mechanism between:
 * - Vybe's UI components requesting spiritual guidance
 * - KASPERMLXManager orchestrating the request
 * - KASPERMLXEngine performing the spiritual intelligence processing
 * - Various SpiritualDataProviders contributing context
 *
 * 🔍 REQUEST ANATOMY:
 *
 * Each request contains multiple layers of specification:
 *
 * 1. IDENTITY (id, createdAt):
 *    - Unique UUID for tracking and caching
 *    - Creation timestamp for performance analysis and debugging
 *    - Enables request lifecycle tracking through the entire system
 *
 * 2. SPIRITUAL SPECIFICATION (feature, type):
 *    - Feature: Which aspect of spiritual life needs guidance
 *    - Type: What kind of spiritual communication is most helpful
 *    - Together these determine template selection and processing approach
 *
 * 3. PERFORMANCE REQUIREMENTS (priority):
 *    - Immediate: User is actively waiting, optimize for speed
 *    - High: User expects quality guidance, balance speed and depth
 *    - Background: Prepare for later use, optimize for depth and accuracy
 *
 * 4. CONTEXTUAL INTELLIGENCE (context):
 *    - Primary data: Core information for guidance generation
 *    - User query: Natural language intent from the user
 *    - Historical context: Previous interactions and patterns
 *    - Constraints: Length, tone, depth requirements
 *
 * 5. PROVIDER COORDINATION (requiredProviders):
 *    - Empty set: Use default providers for the feature
 *    - Specific set: Only use these providers (for testing or optimization)
 *    - Allows fine-grained control over spiritual data sources
 *
 * 🔄 REQUEST LIFECYCLE:
 *
 * 1. Created by UI component or KASPERMLXManager convenience method
 * 2. Validated by KASPERMLXEngine for completeness and consistency
 * 3. Used to coordinate spiritual data provider calls
 * 4. Cached using request characteristics as cache key
 * 5. Tracked for performance metrics and quality improvement
 *
 * This comprehensive request structure ensures that every piece of spiritual
 * guidance generated by KASPER MLX is appropriate, personalized, and delivered
 * with the right performance characteristics for the user's current needs.
 */
struct InsightRequest {
    /// Claude: Unique identifier for request tracking, caching, and performance analysis
    let id: UUID = UUID()

    /// Claude: The spiritual domain being addressed (journal, daily card, sanctum, etc.)
    let feature: KASPERFeature

    /// Claude: The style of spiritual communication desired (guidance, reflection, affirmation, etc.)
    let type: KASPERInsightType

    /// Claude: Processing priority and performance expectations
    let priority: InsightPriority

    /// Claude: Rich contextual information for personalized spiritual guidance
    let context: InsightContext

    /// Claude: Specific providers to use (empty = use defaults for feature)
    let requiredProviders: Set<String>

    /// Claude: Request creation timestamp for performance tracking and cache management
    let createdAt: Date = Date()

    /// Claude: Initialize a complete spiritual guidance request with intelligent defaults
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

/**
 * Claude: InsightContext - The Rich Tapestry of Spiritual Context Information
 * =========================================================================
 *
 * This struct contains all the contextual information needed to generate
 * personally relevant, spiritually authentic insights. It represents the
 * "spiritual state" of the user at the moment guidance is requested.
 *
 * 🌍 CONTEXT LAYERS:
 *
 * The context is structured in layers of increasing personalization:
 *
 * 1. PRIMARY DATA (Required):
 *    - Core information directly relevant to the spiritual guidance request
 *    - Examples: journal entry text, focus number, realm number, time of day
 *    - Always present - this is the foundational context for insight generation
 *
 * 2. USER QUERY (Optional):
 *    - Natural language expression of what the user is seeking
 *    - Examples: "How should I approach this decision?", "What does my dream mean?"
 *    - Helps KASPER MLX understand user intent and tailor guidance accordingly
 *
 * 3. HISTORICAL CONTEXT (Optional):
 *    - Previous interactions, spiritual patterns, growth journey context
 *    - Examples: recent insights, feedback ratings, spiritual milestones
 *    - Enables continuity and progression in spiritual guidance
 *
 * 4. CONSTRAINTS (Optional):
 *    - Technical and preference requirements for the insight
 *    - Examples: length limits, tone preferences, spiritual depth level
 *    - Ensures generated insights meet user interface and experience requirements
 *
 * 🧐 INTELLIGENCE INTEGRATION:
 *
 * The context data flows through the KASPER MLX system:
 *
 * 1. PROVIDER COORDINATION:
 *    - Primary data guides which providers are activated
 *    - Historical context informs provider cache strategies
 *    - User query influences provider data selection
 *
 * 2. TEMPLATE SELECTION:
 *    - Context determines which spiritual templates are most appropriate
 *    - User query affects template personalization parameters
 *    - Constraints filter template options based on requirements
 *
 * 3. MLX INFERENCE (when active):
 *    - All context layers feed into ML model input tensors
 *    - Historical context enables learning from user preferences
 *    - Constraints guide model output parameters
 *
 * 4. QUALITY ASSURANCE:
 *    - Context enables insight validation against spiritual authenticity
 *    - Constraints ensure insights meet technical requirements
 *    - Historical context allows consistency checking
 *
 * This rich contextual foundation ensures that every insight feels personally
 * crafted for the user's current spiritual needs and circumstances.
 */
struct InsightContext {
    /// Claude: Core spiritual data directly relevant to the guidance request
    /// Examples: {"focusNumber": 7, "entryText": "Today I felt...", "timeOfDay": 14}
    let primaryData: [String: Any]

    /// Claude: User's natural language expression of their spiritual inquiry
    /// Examples: "What spiritual lesson is emerging?", "How should I respond to this situation?"
    let userQuery: String?

    /// Claude: Previous spiritual interactions and patterns for continuity and growth
    /// Examples: {"recentInsights": [...], "feedbackRatings": [...], "spiritualMilestones": [...]}
    let historicalContext: [String: Any]?

    /// Claude: Technical and preference requirements for the generated insight
    let constraints: InsightConstraints?

    /// Claude: Initialize context with flexible spiritual data and optional personalization
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

/**
 * Claude: InsightConstraints - The Sacred Parameters for Spiritual Guidance Delivery
 * ================================================================================
 *
 * This struct defines the technical and experiential requirements for how spiritual
 * guidance should be presented to the user. It bridges the gap between spiritual
 * authenticity and user interface needs.
 *
 * 🌎 DESIGN PHILOSOPHY:
 *
 * Constraints aren't limitations - they're guidelines that ensure spiritual insights
 * are delivered in the most effective way for the user's current context and needs.
 * They represent the intersection of:
 *
 * - User interface requirements (length limits for UI components)
 * - User preferences (tone, emoji usage, depth level)
 * - Contextual appropriateness (morning vs evening, crisis vs celebration)
 * - Spiritual authenticity (maintaining mystical integrity within technical bounds)
 *
 * 💭 CONSTRAINT CATEGORIES:
 *
 * 1. LENGTH MANAGEMENT (maxLength):
 *    - nil: No length constraints, full spiritual expression allowed
 *    - 50-100: Concise insights for quick UI elements (buttons, notifications)
 *    - 100-150: Standard insights for cards and daily guidance
 *    - 150+: Detailed insights for journal analysis and deep reflection
 *
 *    Length management uses intelligent truncation that preserves spiritual meaning
 *    rather than arbitrary word cutting.
 *
 * 2. TONAL GUIDANCE (tone):
 *    - nil: Use default tone based on insight type and spiritual context
 *    - "encouraging": Supportive and uplifting language
 *    - "contemplative": Reflective and introspective phrasing
 *    - "mystical": Deep spiritual language with cosmic references
 *    - "practical": Grounded guidance with actionable steps
 *
 *    Tone influences template selection and language patterns.
 *
 * 3. EMOJI INTEGRATION (includeEmojis):
 *    - true (default): Enhances spiritual insights with meaningful emoji
 *    - false: Plain text for formal contexts or accessibility needs
 *
 *    Emojis are chosen based on spiritual significance, not decoration.
 *
 * 4. SPIRITUAL DEPTH LEVELS (spiritualDepth):
 *    - surface: Accessible spiritual concepts, practical application focus
 *    - balanced (default): Mix of mystical wisdom and practical guidance
 *    - deep: Full spiritual complexity, advanced metaphysical concepts
 *
 *    Depth affects vocabulary choice, concept complexity, and mystical references.
 *
 * 🔄 PROCESSING INTEGRATION:
 *
 * Constraints flow through the entire insight generation pipeline:
 *
 * 1. TEMPLATE SELECTION:
 *    - Depth level filters appropriate template categories
 *    - Tone influences specific template variants
 *    - Length affects template structure and expansion
 *
 * 2. CONTENT GENERATION:
 *    - Spiritual concepts are adjusted for depth level
 *    - Language patterns match tone requirements
 *    - Emoji placement follows spiritual significance patterns
 *
 * 3. QUALITY VALIDATION:
 *    - Generated insights are checked against all constraints
 *    - Spiritual authenticity is preserved within technical bounds
 *    - Fallback mechanisms ensure constraints are always respected
 *
 * This constraint system ensures that KASPER MLX can deliver spiritually
 * authentic guidance in any user interface context while maintaining the
 * sacred nature of the spiritual guidance being provided.
 */
struct InsightConstraints {
    /// Claude: Maximum character length for the insight (nil = unlimited)
    /// Used by UI components with space constraints - ensures insights fit beautifully
    let maxLength: Int?

    /// Claude: Preferred emotional/spiritual tone (nil = automatic based on context)
    /// Examples: "encouraging", "contemplative", "mystical", "practical"
    let tone: String?

    /// Claude: Whether to include spiritually meaningful emoji in the insight
    /// Default true - emoji enhance spiritual communication when chosen authentically
    let includeEmojis: Bool

    /// Claude: The level of spiritual complexity and mystical depth to employ
    let spiritualDepth: SpiritualDepth

    /// Claude: Initialize constraints with intelligent spiritual defaults
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

    /**
     * Claude: SpiritualDepth - The Three Levels of Mystical Complexity
     * ==============================================================
     *
     * This enum represents different levels of spiritual sophistication in guidance:
     *
     * • surface: Quick, accessible insights for immediate guidance and daily use
     *   - Simple spiritual concepts that anyone can understand immediately
     *   - Practical applications of spiritual wisdom
     *   - Minimal mystical terminology, maximum accessibility
     *   - Perfect for: Daily cards, quick encouragement, beginner spiritual support
     *
     * • balanced: Mix of practical and mystical for comprehensive guidance
     *   - Blend of accessible wisdom and deeper spiritual concepts
     *   - Introduces mystical ideas with practical grounding
     *   - Rich spiritual language balanced with everyday applicability
     *   - Perfect for: Journal insights, personal reflection, spiritual growth work
     *
     * • deep: Full spiritual depth for advanced practitioners and profound moments
     *   - Complex mystical concepts and advanced spiritual philosophy
     *   - Rich symbolic language and cosmic terminology
     *   - Assumes familiarity with spiritual practices and concepts
     *   - Perfect for: Meditation guidance, advanced spiritual counseling, mystical exploration
     *
     * The depth level automatically adjusts:
     * - Vocabulary complexity and mystical terminology
     * - Conceptual sophistication and abstract thinking
     * - Length and detail of spiritual explanations
     * - References to advanced spiritual practices and concepts
     */
    enum SpiritualDepth {
        case surface    // Quick, accessible insights
        case balanced   // Mix of practical and mystical
        case deep       // Full spiritual depth
    }
}

/**
 * Claude: KASPERInsight - The Sacred Output of Spiritual AI Intelligence
 * =====================================================================
 *
 * This struct represents a complete spiritual insight generated by KASPER MLX,
 * containing not just the guidance content but also comprehensive metadata
 * for quality tracking, performance analysis, and spiritual authenticity validation.
 *
 * 🎆 THE ANATOMY OF SPIRITUAL WISDOM:
 *
 * Each KASPERInsight is a complete spiritual communication that includes:
 *
 * 1. IDENTITY AND LINEAGE (id, requestId):
 *    - Unique identity for the insight itself
 *    - Connection to the original request for traceability
 *    - Enables feedback collection and quality improvement
 *
 * 2. SPIRITUAL CONTENT (content, type, feature):
 *    - The actual spiritual guidance text delivered to the user
 *    - Type classification for consistent user experience
 *    - Feature context for appropriate spiritual domain handling
 *
 * 3. QUALITY METRICS (confidence, generatedAt, inferenceTime):
 *    - AI confidence in the spiritual authenticity of the guidance
 *    - Timestamp for temporal context and cache management
 *    - Performance metrics for system optimization
 *
 * 4. TECHNICAL METADATA (metadata):
 *    - Model version for insight versioning and A/B testing
 *    - Providers used for reproducibility and debugging
 *    - Cache status for performance analysis
 *    - Debug information for system improvement
 *
 * 🔍 QUALITY ASSURANCE:
 *
 * Each insight undergoes spiritual and technical validation:
 *
 * - SPIRITUAL AUTHENTICITY: Content is checked for numerological accuracy,
 *   astrological consistency, and mystical integrity
 * - TECHNICAL QUALITY: Response times, confidence scores, and metadata
 *   completeness are validated
 * - USER EXPERIENCE: Length, tone, and formatting are verified against constraints
 * - CONSISTENCY: Insights are checked for coherence with user's spiritual journey
 *
 * 📈 PERFORMANCE TRACKING:
 *
 * Insights enable comprehensive performance analysis:
 *
 * - Response time distribution across features and providers
 * - Confidence score patterns for different spiritual domains
 * - Cache hit rates and their impact on user experience
 * - Provider contribution analysis for system optimization
 *
 * 🌱 LEARNING AND IMPROVEMENT:
 *
 * Each insight contributes to system evolution:
 *
 * - User feedback is collected and associated with insight metadata
 * - High-quality insights become training data for MLX models
 * - Performance patterns guide architectural improvements
 * - Spiritual authenticity tracking improves template quality
 *
 * This comprehensive insight structure ensures that KASPER MLX not only
 * delivers meaningful spiritual guidance but also continuously improves
 * its ability to serve users' spiritual growth and development.
 */
public struct KASPERInsight {
    /// Claude: Unique identifier for this specific spiritual insight
    let id: UUID

    /// Claude: Reference to the original request that generated this insight
    let requestId: UUID

    /// Claude: The actual spiritual guidance text delivered to the user
    let content: String

    /// Claude: The style of spiritual communication (guidance, reflection, etc.)
    let type: KASPERInsightType

    /// Claude: The spiritual domain this insight addresses (journal, daily card, etc.)
    let feature: KASPERFeature

    /// Claude: AI confidence in the spiritual authenticity and relevance (0.0-1.0)
    let confidence: Double

    /// Claude: When this spiritual insight was generated (for temporal context)
    let generatedAt: Date

    /// Claude: How long the insight generation took (for performance optimization)
    let inferenceTime: TimeInterval

    /// Claude: Detailed technical and spiritual metadata for quality tracking
    var metadata: KASPERInsightMetadata

    /// Claude: Create a complete spiritual insight with automatic ID and timestamp generation
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

/**
 * Claude: KASPERInsightMetadata - The Technical DNA of Spiritual Guidance
 * ====================================================================
 *
 * This struct captures the technical lineage and processing characteristics
 * of each spiritual insight, enabling quality tracking, performance optimization,
 * and continuous improvement of the KASPER MLX system.
 *
 * 🔬 METADATA CATEGORIES:
 *
 * 1. MODEL VERSIONING (modelVersion):
 *    - Tracks which version of the spiritual intelligence generated the insight
 *    - Examples: "template-v1.0", "mlx-spiritual-v2.1", "hybrid-v1.5"
 *    - Enables A/B testing between different spiritual AI approaches
 *    - Critical for rolling back to previous versions if quality degrades
 *
 * 2. PROVIDER COORDINATION (providersUsed):
 *    - Records which spiritual data sources contributed to the insight
 *    - Examples: ["cosmic", "numerology", "megacorpus"] or ["numerology", "biometric"]
 *    - Enables correlation analysis between providers and insight quality
 *    - Helps identify optimal provider combinations for different features
 *
 * 3. PERFORMANCE TRACKING (cacheHit):
 *    - Indicates whether this insight came from cache or fresh generation
 *    - true: Retrieved from cache (faster response, potentially less fresh)
 *    - false: Newly generated (slower response, maximum freshness)
 *    - Critical for cache hit rate optimization and performance analysis
 *
 * 4. DIAGNOSTIC INFORMATION (debugInfo):
 *    - Optional detailed information for system debugging and improvement
 *    - Examples: provider response times, template selection rationale, MLX tensor shapes
 *    - Only populated in debug builds or when diagnostic logging is enabled
 *    - Helps developers understand and optimize the spiritual guidance generation process
 *
 * 📈 QUALITY ANALYTICS:
 *
 * The metadata enables sophisticated quality tracking:
 *
 * - Model version correlation with user satisfaction ratings
 * - Provider combination effectiveness for different spiritual domains
 * - Cache strategy optimization based on freshness vs performance trade-offs
 * - Performance bottleneck identification through debug information
 *
 * 🔄 CONTINUOUS IMPROVEMENT:
 *
 * Metadata feeds back into system evolution:
 *
 * - High-performing provider combinations become default for features
 * - Model versions with better user ratings get prioritized
 * - Cache strategies are tuned based on hit rate and satisfaction correlation
 * - Debug information guides architectural improvements and optimizations
 *
 * This comprehensive metadata collection ensures that KASPER MLX continuously
 * improves its spiritual guidance quality while maintaining optimal performance
 * and technical reliability.
 */
struct KASPERInsightMetadata {
    /// Claude: Version identifier for the spiritual intelligence model that generated this insight
    /// Used for A/B testing, quality tracking, and rollback capabilities
    let modelVersion: String

    /// Claude: List of spiritual data providers that contributed context for this insight
    /// Enables provider effectiveness analysis and optimal combination discovery
    let providersUsed: [String]

    /// Claude: Whether this insight was retrieved from cache (true) or freshly generated (false)
    /// Critical for cache hit rate analysis and performance optimization
    let cacheHit: Bool

    /// Claude: Optional diagnostic information for debugging and system optimization
    /// Only populated when detailed logging is enabled - contains technical details
    let debugInfo: [String: Any]?

    /// Shadow mode winner - tracks which AI system generated this insight
    /// "Local LLM" = Mixtral 46.7B, "RuntimeBundle" = Curated content, nil = No competition
    var shadowModeWinner: String? = nil

    /// Claude: Initialize metadata with intelligent defaults for production use
    init(
        modelVersion: String = "1.0",
        providersUsed: [String] = [],
        cacheHit: Bool = false,
        debugInfo: [String: Any]? = nil,
        shadowModeWinner: String? = nil
    ) {
        self.modelVersion = modelVersion
        self.providersUsed = providersUsed
        self.cacheHit = cacheHit
        self.debugInfo = debugInfo
        self.shadowModeWinner = shadowModeWinner
    }
}

// MARK: - 🛡️ SACRED ERROR HANDLING

/**
 * Claude: KASPERMLXError - The Sacred Error Handling for Spiritual AI Systems
 * =========================================================================
 *
 * This enum defines the specific error conditions that can occur during spiritual
 * guidance generation, enabling graceful degradation and meaningful error recovery
 * that preserves the user's spiritual experience even when technical issues arise.
 *
 * 🕰️ ERROR PHILOSOPHY:
 *
 * In spiritual AI systems, errors are not just technical failures - they represent
 * opportunities for graceful degradation that maintains spiritual support even
 * when optimal conditions aren't available.
 *
 * Key principles:
 * - Never leave users without spiritual guidance due to technical issues
 * - Provide meaningful error messages that help improve the system
 * - Enable fallback mechanisms that maintain spiritual authenticity
 * - Support debugging and system optimization through detailed error information
 *
 * ⚠️ ERROR CATEGORIES AND RECOVERY STRATEGIES:
 *
 * • providerUnavailable: Specific spiritual data source is temporarily inaccessible
 *   - Cause: Network issues, HealthKit permissions, calculation failures
 *   - Recovery: Use other available providers, fallback to cached data
 *   - User Impact: Reduced personalization but spiritual guidance still available
 *
 * • inferenceTimeout: Spiritual guidance generation took too long
 *   - Cause: Complex calculations, provider delays, system overload
 *   - Recovery: Retry with simpler parameters, use cached insights
 *   - User Impact: Brief delay but maintains responsive spiritual support
 *
 * • modelNotLoaded: AI model isn't available for spiritual intelligence
 *   - Cause: Missing MLX models, initialization failures, memory constraints
 *   - Recovery: Fallback to template-based spiritual guidance generation
 *   - User Impact: None - templates provide authentic spiritual insights
 *
 * • invalidContext: Provided spiritual context is malformed or incomplete
 *   - Cause: Programming errors, data corruption, unexpected input formats
 *   - Recovery: Use default spiritual context, request minimal insight
 *   - User Impact: More generic guidance but still spiritually supportive
 *
 * • cacheMiss: Expected cached spiritual insight is no longer available
 *   - Cause: Cache expiry, memory pressure, cache clearing
 *   - Recovery: Generate fresh spiritual insight with current data
 *   - User Impact: Slight delay but potentially fresher spiritual guidance
 *
 * • insufficientData: Not enough spiritual context for meaningful insight
 *   - Cause: Provider failures, incomplete user data, system initialization
 *   - Recovery: Request basic spiritual guidance with available data
 *   - User Impact: More generic but still authentic spiritual support
 *
 * 🚑 GRACEFUL DEGRADATION:
 *
 * Each error type supports fallback strategies that ensure users always receive
 * some form of spiritual guidance, maintaining the sacred nature of the experience
 * even when technical optimal conditions aren't available.
 */
enum KASPERMLXError: LocalizedError, Equatable {
    /// Claude: A specific spiritual data provider is temporarily unavailable
    /// Recovery: Use other providers, fallback to cached data, provide generic guidance
    case providerUnavailable(String)

    /// Claude: Spiritual insight generation exceeded the configured timeout limit
    /// Recovery: Retry with simpler parameters, use cached insights, provide quick guidance
    case inferenceTimeout

    /// Claude: AI model isn't loaded or available for spiritual intelligence processing
    /// Recovery: Use template-based spiritual guidance as fallback (seamless to user)
    case modelNotLoaded
    /// Claude: MLX inference is disabled by configuration
    /// Recovery: Use template-based spiritual guidance as fallback
    case inferenceDisabled

    /// Claude: The provided spiritual context is malformed, incomplete, or invalid
    /// Recovery: Use default context parameters, generate basic spiritual insight
    case invalidContext

    /// Claude: Expected cached insight is no longer available (expired or cleared)
    /// Recovery: Generate fresh insight - this is actually an opportunity for updated guidance
    case cacheMiss

    /// Claude: Insufficient spiritual data available to generate meaningful insight
    /// Recovery: Provide general spiritual guidance, request user to check data sources
    case insufficientData

    /// Claude: Localized error descriptions for user-facing error handling and system debugging
    /// These messages help developers understand error conditions while maintaining user experience
    var errorDescription: String? {
        switch self {
        case .providerUnavailable(let provider):
            return "KASPER MLX: Provider '\(provider)' is unavailable - using alternative spiritual data sources"
        case .inferenceTimeout:
            return "KASPER MLX: Insight generation timeout - optimizing for faster spiritual guidance"
        case .modelNotLoaded:
            return "KASPER MLX: AI model not loaded - using template-based spiritual guidance"
        case .inferenceDisabled:
            return "KASPER MLX: MLX inference disabled - using template-based spiritual guidance"
        case .invalidContext:
            return "KASPER MLX: Invalid spiritual context - generating guidance with available data"
        case .cacheMiss:
            return "KASPER MLX: Generating fresh spiritual insight - expired guidance being updated"
        case .insufficientData:
            return "KASPER MLX: Limited spiritual data available - providing general guidance"
        }
    }
}

// MARK: - Performance Tracking

/**
 * Claude: PerformanceMetrics - The Analytical Heart of Spiritual AI Optimization
 * ============================================================================
 *
 * This struct provides comprehensive performance tracking and analysis for the
 * KASPER MLX system, enabling data-driven optimization of spiritual guidance
 * delivery while maintaining the sacred quality of the experience.
 *
 * 📈 PERFORMANCE PHILOSOPHY:
 *
 * Performance in spiritual AI isn't just about speed - it's about delivering
 * the right guidance at the right time with the right level of spiritual depth.
 * Key metrics include:
 *
 * - RESPONSIVENESS: How quickly users receive spiritual support when needed
 * - RELIABILITY: Consistency of successful insight generation across all features
 * - EFFICIENCY: Optimal use of spiritual data sources and computational resources
 * - FRESHNESS: Balance between performance and spiritual authenticity
 *
 * 🕰️ TEMPORAL TRACKING:
 *
 * The ResponseTimeEntry captures the complete performance story:
 * - timestamp: When the spiritual guidance was requested and delivered
 * - responseTime: How long the insight generation took (end-to-end)
 * - feature: Which spiritual domain was being addressed
 * - success: Whether the guidance was successfully generated
 * - cacheHit: Whether cached spiritual data was used for performance
 *
 * This temporal data enables sophisticated performance analysis:
 * - Peak usage times and capacity planning
 * - Feature-specific performance characteristics
 * - Cache effectiveness across different spiritual domains
 * - Success rate trends and reliability improvements
 *
 * 🐈 CIRCULAR BUFFER DESIGN:
 *
 * The 100-entry history limit implements a circular buffer that:
 * - Maintains recent performance data for real-time optimization
 * - Prevents unbounded memory growth during long app sessions
 * - Provides sufficient data for statistical analysis and trend detection
 * - Balances memory efficiency with analytical capability
 *
 * This design ensures that performance tracking itself doesn't impact
 * the spiritual guidance experience while providing rich analytical data.
 */
struct PerformanceMetrics {
    /**
     * Claude: ResponseTimeEntry - Individual Performance Data Point
     * ===========================================================
     *
     * Each entry captures a complete performance snapshot for one spiritual
     * guidance request, enabling detailed analysis of system behavior patterns.
     *
     * The combination of temporal, feature, and outcome data allows for:
     * - Performance trend analysis over time
     * - Feature-specific optimization strategies
     * - Cache effectiveness measurement
     * - Success rate monitoring and improvement
     * - User experience correlation with technical metrics
     */
    struct ResponseTimeEntry {
        /// Claude: When this spiritual guidance request was processed
        let timestamp: Date

        /// Claude: Total time from request to insight delivery (seconds)
        let responseTime: TimeInterval

        /// Claude: Which spiritual feature was being served
        let feature: KASPERFeature

        /// Claude: Whether insight generation completed successfully
        let success: Bool

        /// Claude: Whether cached data was used for performance optimization
        let cacheHit: Bool
    }

    /// Claude: Rolling history of recent performance data points (circular buffer)
    private(set) var responseHistory: [ResponseTimeEntry] = []

    /// Claude: Maximum entries to maintain - balances analytical depth with memory efficiency
    private let maxHistoryEntries = 100

    // MARK: - Computed Properties

    /// Claude: Total spiritual guidance requests processed in current session
    /// Provides baseline for all percentage-based metrics and system load assessment
    var totalRequests: Int {
        responseHistory.count
    }

    /// Claude: Percentage of spiritual guidance requests that completed successfully
    /// Critical metric for system reliability - should consistently be >95%
    /// Low success rates indicate provider issues, model problems, or system overload
    var successRate: Double {
        guard !responseHistory.isEmpty else { return 0.0 }
        let successes = responseHistory.filter { $0.success }.count
        return Double(successes) / Double(responseHistory.count) * 100.0
    }

    /// Claude: Average time to deliver spiritual guidance across all recent requests
    /// Key user experience metric - target is <200ms for immediate, <500ms for high priority
    /// Increases may indicate provider performance issues or system capacity limits
    var averageResponseTime: TimeInterval {
        guard !responseHistory.isEmpty else { return 0.0 }
        let total = responseHistory.reduce(0) { $0 + $1.responseTime }
        return total / Double(responseHistory.count)
    }

    /// Claude: Percentage of requests served from cache vs fresh generation
    /// Balances performance (higher cache hits) with spiritual freshness
    /// Optimal range is typically 40-60% depending on user behavior patterns
    var cacheHitRate: Double {
        guard !responseHistory.isEmpty else { return 0.0 }
        let cacheHits = responseHistory.filter { $0.cacheHit }.count
        return Double(cacheHits) / Double(responseHistory.count) * 100.0
    }

    /// Claude: Most recent response times for trend analysis and real-time monitoring
    /// Used by performance dashboard to show current system responsiveness
    /// 20 entries provide sufficient data for trend detection without overwhelming UI
    var recentResponseTimes: [TimeInterval] {
        responseHistory.suffix(20).map { $0.responseTime }
    }

    // MARK: - Methods

    /// Claude: Record a spiritual guidance performance data point for analysis and optimization
    /// This is called after every insight generation attempt (successful or failed) to build
    /// a comprehensive picture of system performance and user experience quality
    ///
    /// Parameters:
    /// - responseTime: Total time from request initiation to insight delivery (includes all provider coordination, processing, and caching)
    /// - feature: Which spiritual domain was being served (enables feature-specific performance analysis)
    /// - success: Whether the insight was successfully generated (critical for reliability tracking)
    /// - cacheHit: Whether cached data was used (essential for cache effectiveness analysis)
    ///
    /// The method implements circular buffer behavior to maintain recent performance history
    /// while preventing unbounded memory growth during extended app usage sessions.
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

        // Claude: Implement circular buffer - maintain fixed-size history for memory efficiency
        // Remove oldest entries when we exceed the maximum, keeping only recent performance data
        if responseHistory.count > maxHistoryEntries {
            responseHistory.removeFirst(responseHistory.count - maxHistoryEntries)
        }
    }

    /// Claude: Reset all performance tracking data for fresh analysis or privacy clearing
    /// Used when:
    /// - User explicitly clears performance data
    /// - System needs fresh performance baselines after major changes
    /// - Testing scenarios require clean performance metrics
    /// - Privacy requirements necessitate data clearing
    mutating func reset() {
        responseHistory.removeAll()
    }
}

// MARK: - Cache Types

/**
 * Claude: InsightCacheEntry - The Sacred Repository for Spiritual Guidance Caching
 * ==============================================================================
 *
 * This struct manages the caching of spiritual insights to balance performance
 * with spiritual authenticity. It ensures that users receive quick spiritual
 * support while maintaining the freshness and relevance of guidance.
 *
 * 🕰️ CACHING PHILOSOPHY:
 *
 * Spiritual guidance caching is unique because:
 *
 * - TEMPORAL SENSITIVITY: Some spiritual insights are time-sensitive (cosmic timing)
 *   while others remain relevant longer (fundamental spiritual principles)
 * - CONTEXT DEPENDENCE: The same spiritual question may need different answers
 *   based on current spiritual conditions (moon phase, emotional state, etc.)
 * - FRESHNESS vs SPEED: Users need quick spiritual support, but stale guidance
 *   can feel inauthentic or irrelevant
 *
 * 🔑 CACHE KEY STRATEGY:
 *
 * The contextHash uniquely identifies the spiritual context that generated the insight:
 * - Combines feature type, insight type, and relevant spiritual parameters
 * - Includes user-specific elements (focus number, realm number) for personalization
 * - Incorporates temporal elements to ensure time-sensitive guidance expires appropriately
 * - Balances specificity (for accurate cache hits) with generalization (for cache efficiency)
 *
 * ⏰ EXPIRATION MANAGEMENT:
 *
 * Different types of spiritual insights have different lifespans:
 * - Cosmic timing insights: Very short expiry (minutes) due to changing celestial conditions
 * - Daily guidance: Medium expiry (hours) for daily relevance
 * - Fundamental spiritual principles: Long expiry (days) for timeless wisdom
 * - Personal spiritual patterns: Medium-long expiry based on user growth pace
 *
 * The isExpired property enables the system to automatically refresh stale guidance
 * while maximizing cache hit rates for better user experience.
 *
 * 🏗️ INTEGRATION WITH KASPER MLX:
 *
 * Cache entries integrate seamlessly with the broader spiritual guidance system:
 * - Cached insights maintain full metadata for quality tracking
 * - Cache hits are recorded in performance metrics for optimization analysis
 * - Expired entries trigger fresh spiritual data gathering and processing
 * - Cache management respects user privacy and data clearing preferences
 *
 * This caching strategy ensures that users receive spiritually authentic guidance
 * with optimal performance characteristics across all spiritual domains.
 */
struct InsightCacheEntry {
    /// Claude: The complete spiritual insight with all metadata and quality tracking
    let insight: KASPERInsight

    /// Claude: Unique hash of the spiritual context that generated this insight
    /// Used for cache key matching and ensures appropriate insights are retrieved
    let contextHash: String

    /// Claude: When this spiritual guidance expires and should be refreshed
    /// Balances performance with spiritual authenticity and temporal relevance
    let expiresAt: Date

    /// Claude: Check if this spiritual guidance has expired and needs fresh generation
    /// Critical for maintaining spiritual authenticity - stale guidance can feel disconnected
    var isExpired: Bool {
        Date() > expiresAt
    }
}

/**
 * Claude: KASPERMLXConfiguration - The Sacred Parameters for Spiritual AI Operation
 * ==============================================================================
 *
 * This struct defines the operational parameters that govern how KASPER MLX
 * generates spiritual guidance, balancing performance, quality, and system reliability
 * to deliver the optimal spiritual support experience.
 *
 * ⚙️ CONFIGURATION CATEGORIES:
 *
 * 1. CONCURRENCY MANAGEMENT (maxConcurrentInferences):
 *    - Controls how many spiritual guidance requests can be processed simultaneously
 *    - Prevents system overload during peak spiritual support periods
 *    - Balances resource utilization with response time consistency
 *    - Default 3: Optimal for most devices while maintaining spiritual quality
 *
 * 2. CACHING STRATEGY (defaultCacheExpiry):
 *    - Sets the default lifetime for cached spiritual insights
 *    - 300 seconds (5 minutes): Balances freshness with performance
 *    - Individual insights can override based on spiritual temporal sensitivity
 *    - Ensures users get current spiritual guidance without unnecessary recalculation
 *
 * 3. RELIABILITY PROTECTION (inferenceTimeout):
 *    - Maximum time to wait for spiritual insight generation before failing
 *    - 5 seconds: Prevents hanging requests from degrading user experience
 *    - Includes time for provider coordination, processing, and quality validation
 *    - Failed requests trigger fallback mechanisms for continuous spiritual support
 *
 * 4. DEVELOPMENT SUPPORT (enableDebugLogging):
 *    - Controls detailed logging for system analysis and improvement
 *    - True in development: Full insight into spiritual processing pipeline
 *    - Production: Typically false for performance and privacy
 *    - Critical for diagnosing spiritual authenticity and performance issues
 *
 * 5. AI EVOLUTION (enableMLXInference, modelPath):
 *    - enableMLXInference: Toggle between real MLX AI and template-based fallback
 *    - modelPath: Location of trained spiritual intelligence models
 *    - Enables seamless transition from template system to true AI as models mature
 *    - Future-proofs the system for advanced spiritual AI capabilities
 *
 * 🚀 EVOLUTION STRATEGY:
 *
 * The configuration supports KASPER MLX's evolution from template-based to AI-powered:
 *
 * CURRENT STATE (enableMLXInference: true, modelPath: nil):
 * - Uses sophisticated template system with spiritual authenticity
 * - Falls back gracefully when MLX integration isn't available yet
 * - Maintains consistent user experience during development
 *
 * FUTURE STATE (enableMLXInference: true, modelPath: "kasper-spiritual-v2.0"):
 * - Leverages trained spiritual AI models for personalized guidance
 * - Falls back to templates when AI confidence is low
 * - Combines machine learning with spiritual authenticity validation
 *
 * This configuration approach ensures that users always receive meaningful
 * spiritual guidance regardless of the underlying implementation details.
 */
struct KASPERMLXConfiguration {
    /// Claude: Maximum number of spiritual insights that can be generated simultaneously
    /// Prevents system overload while maintaining responsive spiritual support
    let maxConcurrentInferences: Int

    /// Claude: Default cache lifetime for spiritual insights (seconds)
    /// Balances spiritual freshness with performance optimization
    let defaultCacheExpiry: TimeInterval

    /// Claude: Maximum time to wait for insight generation before timeout
    /// Ensures responsive user experience even when spiritual processing is complex
    let inferenceTimeout: TimeInterval

    /// Claude: Whether to enable detailed logging for development and debugging
    /// Critical for understanding spiritual processing pipeline and optimization
    let enableDebugLogging: Bool

    /// Claude: Toggle for real MLX AI vs template-based spiritual guidance generation
    /// Enables seamless evolution from templates to true spiritual AI
    let enableMLXInference: Bool

    /// Claude: Path to trained spiritual intelligence model files (nil = not available yet)
    /// Future-proofs the system for advanced AI-powered spiritual guidance
    let modelPath: String?

    /// Claude: Optimal default configuration for spiritual guidance generation
    /// Balances performance, quality, and system reliability for the best user experience
    static let `default` = KASPERMLXConfiguration(
        maxConcurrentInferences: 3,      // Optimal device resource utilization
        defaultCacheExpiry: 300,         // 5 minutes: freshness vs performance balance
        inferenceTimeout: 5.0,           // 5 seconds: responsive without premature failure
        enableDebugLogging: true,        // Full diagnostic capability for development
        enableMLXInference: true,        // Ready for MLX integration when available
        modelPath: nil                   // No trained model yet - template fallback active
    )
}
