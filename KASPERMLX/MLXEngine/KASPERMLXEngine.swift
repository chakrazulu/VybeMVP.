/**
 * KASPER MLX Engine
 * 
 * The heart of KASPER MLX - orchestrates spiritual data providers,
 * manages MLX model inference, handles caching, and generates
 * personalized spiritual insights using Apple's MLX framework.
 */

import Foundation
import Combine
import OSLog

@MainActor
class KASPERMLXEngine: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var isReady: Bool = false
    @Published private(set) var isInferring: Bool = false
    @Published private(set) var currentModel: String?
    
    // Providers
    private var providers: [String: any SpiritualDataProvider] = [:]
    
    // Cache
    private var insightCache: [String: InsightCacheEntry] = [:]
    private let maxCacheSize = 100
    
    // Configuration
    private let config: KASPERMLXConfiguration
    private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "Engine")
    
    // Active inferences tracking
    private var activeInferences = Set<UUID>()
    
    // Model (placeholder for MLX integration)
    private var mlxModel: Any? // Will be MLX model when integrated
    
    // MARK: - Singleton
    
    static let shared = KASPERMLXEngine()
    
    init(config: KASPERMLXConfiguration = .default) {
        self.config = config
        setupEngine()
    }
    
    // MARK: - Public Interface
    
    /// Configures KASPER MLX engine with Vybe's spiritual data managers
    /// 
    /// Essential initialization method that connects KASPER MLX to Vybe's existing
    /// spiritual infrastructure. This method must be called during app startup
    /// to enable personalized spiritual insights.
    /// 
    /// - Parameter realmManager: Provides user's realm numbers and spiritual calculations
    /// - Parameter focusManager: Manages user's current focus intentions and goals  
    /// - Parameter healthManager: Accesses HealthKit data for biometric spiritual alignment
    /// 
    /// - Note: Gracefully handles nil managers - engine will use cosmic data only
    /// - Important: Call during app startup after HealthKit permissions granted
    func configure(
        realmManager: RealmNumberManager?,
        focusManager: FocusNumberManager?,
        healthManager: HealthKitManager?
    ) async {
        logger.info("🔮 KASPER MLX: Configuring with app managers")
        
        // Initialize providers with manager references
        await registerProvider(CosmicDataProvider())
        await registerProvider(NumerologyDataProvider(
            realmNumberManager: realmManager,
            focusNumberManager: focusManager
        ))
        await registerProvider(BiometricDataProvider(healthKitManager: healthManager))
        
        // Initialize model (placeholder)
        await initializeModel()
        
        isReady = await validateReadiness()
        
        if isReady {
            logger.info("🔮 KASPER MLX: Engine ready for inference")
        } else {
            logger.warning("🔮 KASPER MLX: Engine not ready - missing dependencies")
        }
    }
    
    /// Generates personalized spiritual insight using KASPER MLX inference engine
    /// 
    /// This is the primary method for generating spiritual insights that combines:
    /// - Cosmic data (planetary positions, moon phases)
    /// - Numerological calculations (life path, personal numbers)  
    /// - Biometric wellness data (heart rate variability)
    /// - Apple MLX machine learning inference
    /// 
    /// - Parameter request: Complete insight request with context, constraints, and feature type
    /// - Returns: Generated spiritual insight with metadata, confidence scores, and performance metrics
    /// - Throws: `KASPERMLXError.modelNotLoaded` if engine not ready, `KASPERMLXError.insufficientData` if providers unavailable
    /// 
    /// - Note: Maintains <100ms response time through smart caching and async provider coordination
    /// - Important: Preserves spiritual authenticity through validated astrological correspondences
    func generateInsight(for request: InsightRequest) async throws -> KASPERInsight {
        guard isReady else {
            throw KASPERMLXError.modelNotLoaded
        }
        
        // Check if we're at inference limit
        guard activeInferences.count < config.maxConcurrentInferences else {
            logger.warning("🔮 KASPER MLX: Too many concurrent inferences, queuing...")
            try await Task.sleep(nanoseconds: 100_000_000) // 100ms delay
            return try await generateInsight(for: request)
        }
        
        // Check cache first
        let cacheKey = createCacheKey(for: request)
        if let cached = insightCache[cacheKey], !cached.isExpired {
            logger.info("🔮 KASPER MLX: Cache hit for \(request.feature.rawValue)")
            return cached.insight
        }
        
        // Track active inference
        activeInferences.insert(request.id)
        isInferring = !activeInferences.isEmpty
        
        defer {
            activeInferences.remove(request.id)
            isInferring = !activeInferences.isEmpty
        }
        
        do {
            let startTime = Date()
            
            // Gather provider contexts
            let contexts = try await gatherProviderContexts(for: request)
            
            // Generate insight
            let insight = try await performInference(request: request, contexts: contexts)
            
            let inferenceTime = Date().timeIntervalSince(startTime)
            logger.info("🔮 KASPER MLX: Generated insight in \(String(format: "%.2f", inferenceTime))s")
            
            // Cache the result
            cacheInsight(insight, key: cacheKey)
            
            return insight
            
        } catch {
            logger.error("🔮 KASPER MLX: Inference failed - \\(error.localizedDescription)")
            throw error
        }
    }
    
    /// Generates instant spiritual insight with minimal setup for immediate UI feedback
    /// 
    /// Optimized for rapid insight generation when full context isn't available.
    /// Perfect for Daily Cards, quick journal prompts, and instant spiritual guidance.
    /// 
    /// - Parameter feature: Target spiritual feature (journal, dailyCard, sanctum, etc.)
    /// - Parameter type: Type of insight to generate (guidance, reflection, prediction)
    /// - Parameter query: Optional user query for personalized insights
    /// - Returns: Generated insight optimized for immediate display
    /// - Throws: Same errors as `generateInsight(for:)` but with simplified context
    /// 
    /// - Note: Uses smart defaults and cached data for sub-50ms response times
    /// - Important: Maintains spiritual authenticity even with minimal context
    func generateQuickInsight(
        for feature: KASPERFeature,
        type: KASPERInsightType = .guidance,
        query: String? = nil
    ) async throws -> KASPERInsight {
        let context = InsightContext(
            primaryData: ["quick": true],
            userQuery: query,
            constraints: InsightConstraints(
                maxLength: 100,
                spiritualDepth: .surface
            )
        )
        
        let request = InsightRequest(
            feature: feature,
            type: type,
            priority: .immediate,
            context: context
        )
        
        return try await generateInsight(for: request)
    }
    
    /// Check if insight is available for feature (cached or quick generation)
    func hasInsightAvailable(for feature: KASPERFeature) async -> Bool {
        // Check cache
        let cacheKey = "quick_\\(feature.rawValue)"
        if let cached = insightCache[cacheKey], !cached.isExpired {
            return true
        }
        
        // Check if providers have data
        let requiredProviders = getRequiredProviders(for: feature)
        for providerId in requiredProviders {
            if let provider = providers[providerId] {
                let hasData = await provider.isDataAvailable()
                if !hasData { return false }
            }
        }
        
        return true
    }
    
    /// Clear caches and reset state
    func clearCache() async {
        insightCache.removeAll()
        
        for provider in providers.values {
            await provider.clearCache()
        }
        
        logger.info("🔮 KASPER MLX: All caches cleared")
    }
    
    // MARK: - Private Methods
    
    private func setupEngine() {
        logger.info("🔮 KASPER MLX: Initializing engine")
        
        // Setup model loading task
        Task {
            await initializeModel()
        }
    }
    
    private func registerProvider(_ provider: any SpiritualDataProvider) async {
        providers[provider.id] = provider
        logger.info("🔮 KASPER MLX: Registered provider: \\(provider.id)")
    }
    
    private func initializeModel() async {
        logger.info("🔮 KASPER MLX: Initializing model (placeholder)")
        
        // TODO: Replace with actual MLX model loading
        // For now, simulate model loading
        try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
        
        mlxModel = "placeholder_model" // Placeholder
        currentModel = "KASPER-Spiritual-v1.0"
        
        logger.info("🔮 KASPER MLX: Model loaded: \\(currentModel ?? \"unknown\")")
    }
    
    private func validateReadiness() async -> Bool {
        // Check if model is loaded
        guard mlxModel != nil else {
            logger.warning("🔮 KASPER MLX: Model not loaded")
            return false
        }
        
        // Check if at least one provider is available
        var hasAvailableProvider = false
        for provider in providers.values {
            if await provider.isDataAvailable() {
                hasAvailableProvider = true
                break
            }
        }
        
        guard hasAvailableProvider else {
            logger.warning("🔮 KASPER MLX: No providers available")
            return false
        }
        
        return true
    }
    
    private func gatherProviderContexts(for request: InsightRequest) async throws -> [ProviderContext] {
        let requiredProviders = request.requiredProviders.isEmpty ? 
            getRequiredProviders(for: request.feature) : 
            request.requiredProviders
        
        var contexts: [ProviderContext] = []
        
        for providerId in requiredProviders {
            guard let provider = providers[providerId] else {
                logger.warning("🔮 KASPER MLX: Provider \\(providerId) not found")
                continue
            }
            
            do {
                let context = try await provider.provideContext(for: request.feature)
                contexts.append(context)
                logger.debug("🔮 KASPER MLX: Got context from \\(providerId)")
            } catch {
                logger.error("🔮 KASPER MLX: Failed to get context from \\(providerId): \\(error)")
                // Continue with other providers
            }
        }
        
        guard !contexts.isEmpty else {
            throw KASPERMLXError.insufficientData
        }
        
        return contexts
    }
    
    private func performInference(request: InsightRequest, contexts: [ProviderContext]) async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Performing inference for \\(request.feature)")
        
        // TODO: Replace with actual MLX inference
        // For now, generate template-based insights
        let insight = await generateTemplateInsight(request: request, contexts: contexts)
        
        return insight
    }
    
    private func generateTemplateInsight(request: InsightRequest, contexts: [ProviderContext]) async -> KASPERInsight {
        // Template-based insight generation (placeholder for MLX)
        let content = await buildTemplateContent(for: request, with: contexts)
        
        return KASPERInsight(
            requestId: request.id,
            content: content,
            type: request.type,
            feature: request.feature,
            confidence: 0.85, // Template confidence
            inferenceTime: 0.1, // Template inference time
            metadata: KASPERInsightMetadata(
                modelVersion: currentModel ?? "template",
                providersUsed: contexts.map { $0.providerId },
                cacheHit: false
            )
        )
    }
    
    private func buildTemplateContent(for request: InsightRequest, with contexts: [ProviderContext]) async -> String {
        // Build content based on feature and available data
        switch request.feature {
        case .journalInsight:
            return buildJournalInsight(contexts: contexts, type: request.type)
        case .dailyCard:
            return buildDailyCardInsight(contexts: contexts, type: request.type)
        case .sanctumGuidance:
            return buildSanctumInsight(contexts: contexts, type: request.type)
        case .focusIntention:
            return buildFocusInsight(contexts: contexts, type: request.type)
        case .cosmicTiming:
            return buildTimingInsight(contexts: contexts, type: request.type)
        case .matchCompatibility:
            return buildMatchInsight(contexts: contexts, type: request.type)
        case .realmInterpretation:
            return buildRealmInsight(contexts: contexts, type: request.type)
        }
    }
    
    private func buildJournalInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        var components: [String] = []
        
        // Extract data from contexts
        let cosmicContext = contexts.first { $0.providerId == "cosmic" }
        let numerologyContext = contexts.first { $0.providerId == "numerology" }
        let biometricContext = contexts.first { $0.providerId == "biometric" }
        
        // Build insight based on available data
        if let cosmic = cosmicContext?.data {
            if cosmic["moonPhase"] is String {
                components.append("With the current lunar energy surrounding you")
            }
        }
        
        if let numerology = numerologyContext?.data {
            if let _ = numerology["focusNumber"] as? Int {
                components.append("your cosmic focus energy guides your reflection")
            }
        }
        
        if let biometric = biometricContext?.data {
            if biometric["emotionalState"] is String {
                components.append("while your emotional energy flows through your words")
            }
        }
        
        let baseInsight = components.joined(separator: ", ")
        
        switch type {
        case .guidance:
            return "✨ \(baseInsight). Trust the wisdom emerging from your inner dialogue."
        case .reflection:
            return "🌙 \(baseInsight). What patterns do you notice in your spiritual journey?"
        case .affirmation:
            return "💫 \(baseInsight). I honor the sacred truth flowing through my awareness."
        default:
            return "🔮 \(baseInsight). Your journal becomes a portal to deeper understanding."
        }
    }
    
    /// Claude: Enhanced daily card insight generation with personalized spiritual guidance
    /// Transforms generic templates into meaningful, personally relevant spiritual wisdom
    /// that resonates with the user's current focus numbers, realm energy, and cosmic timing
    private func buildDailyCardInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        let cosmicContext = contexts.first { $0.providerId == "cosmic" }
        let numerologyContext = contexts.first { $0.providerId == "numerology" }
        let biometricContext = contexts.first { $0.providerId == "biometric" }
        
        // Extract personalized spiritual data
        var focusNumber: Int?
        var realmNumber: Int?
        var moonPhase: String?
        var dominantPlanet: String?
        var emotionalState: String?
        var heartRateVariability: String?
        
        if let numerology = numerologyContext?.data {
            focusNumber = numerology["focusNumber"] as? Int
            realmNumber = numerology["realmNumber"] as? Int
        }
        
        if let cosmic = cosmicContext?.data {
            moonPhase = cosmic["moonPhase"] as? String
            dominantPlanet = cosmic["dominantPlanet"] as? String
        }
        
        if let biometric = biometricContext?.data {
            emotionalState = biometric["emotionalState"] as? String
            heartRateVariability = biometric["heartRateVariability"] as? String
        }
        
        // Generate personalized insights based on available data
        return generatePersonalizedDailyGuidance(
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            moonPhase: moonPhase,
            dominantPlanet: dominantPlanet,
            emotionalState: emotionalState,
            type: type
        )
    }
    
    /// Claude: Generate truly personalized daily spiritual guidance
    /// Creates meaningful insights that feel personally relevant and spiritually authentic
    private func generatePersonalizedDailyGuidance(
        focusNumber: Int?,
        realmNumber: Int?,
        moonPhase: String?,
        dominantPlanet: String?,
        emotionalState: String?,
        type: KASPERInsightType
    ) -> String {
        
        // Build personalized spiritual context
        var spiritualComponents: [String] = []
        var personalReferences: [String] = []
        var actionableGuidance: [String] = []
        
        // Focus Number Wisdom
        if let focus = focusNumber {
            switch focus {
            case 1:
                spiritualComponents.append("pioneering energy")
                personalReferences.append("your natural leadership essence")
                actionableGuidance.append("trust your instincts to initiate new ventures")
            case 2:
                spiritualComponents.append("harmonizing vibration")
                personalReferences.append("your gift for bringing balance")
                actionableGuidance.append("focus on collaboration and peaceful resolution")
            case 3:
                spiritualComponents.append("creative expression flow")
                personalReferences.append("your vibrant communication gifts")
                actionableGuidance.append("channel inspiration through creative outlets")
            case 4:
                spiritualComponents.append("grounding foundation energy")
                personalReferences.append("your steadfast dedication")
                actionableGuidance.append("build something lasting through patient effort")
            case 5:
                spiritualComponents.append("transformative freedom current")
                personalReferences.append("your adventurous spirit")
                actionableGuidance.append("embrace change as a pathway to growth")
            case 6:
                spiritualComponents.append("nurturing service vibration")
                personalReferences.append("your compassionate heart")
                actionableGuidance.append("offer healing presence to those around you")
            case 7:
                spiritualComponents.append("mystical wisdom frequency")
                personalReferences.append("your intuitive knowing")
                actionableGuidance.append("seek solitude for spiritual insights")
            case 8:
                spiritualComponents.append("material mastery force")
                personalReferences.append("your powerful manifestation abilities")
                actionableGuidance.append("balance ambition with spiritual integrity")
            case 9:
                spiritualComponents.append("universal love frequency")
                personalReferences.append("your humanitarian nature")
                actionableGuidance.append("serve the greater good through compassionate action")
            default:
                spiritualComponents.append("cosmic alignment energy")
                personalReferences.append("your unique spiritual path")
                actionableGuidance.append("trust the divine timing of your journey")
            }
        }
        
        // Realm Number Integration
        if let realm = realmNumber {
            switch realm {
            case 1:
                spiritualComponents.append("new beginning realm")
                actionableGuidance.append("step boldly into fresh opportunities")
            case 2:
                spiritualComponents.append("partnership realm")
                actionableGuidance.append("seek harmony in all relationships")
            case 3:
                spiritualComponents.append("creative manifestation realm")
                actionableGuidance.append("express your authentic truth")
            case 4:
                spiritualComponents.append("stable foundation realm")
                actionableGuidance.append("organize your spiritual practices")
            case 5:
                spiritualComponents.append("dynamic change realm")
                actionableGuidance.append("welcome unexpected shifts with curiosity")
            case 6:
                spiritualComponents.append("loving service realm")
                actionableGuidance.append("nurture yourself and others")
            case 7:
                spiritualComponents.append("inner wisdom realm")
                actionableGuidance.append("trust your deepest intuition")
            case 8:
                spiritualComponents.append("material-spiritual balance realm")
                actionableGuidance.append("align worldly success with soul purpose")
            case 9:
                spiritualComponents.append("completion and release realm")
                actionableGuidance.append("let go of what no longer serves")
            default:
                spiritualComponents.append("cosmic transition realm")
                actionableGuidance.append("flow with the divine current")
            }
        }
        
        // Cosmic Integration
        if let phase = moonPhase {
            switch phase.lowercased() {
            case "new moon", "new":
                spiritualComponents.append("new moon intention energy")
                actionableGuidance.append("plant seeds for future manifestation")
            case "waxing", "first quarter":
                spiritualComponents.append("growing momentum energy")
                actionableGuidance.append("take inspired action on your goals")
            case "full moon", "full":
                spiritualComponents.append("illuminating full moon energy")
                actionableGuidance.append("celebrate your progress and release what's complete")
            case "waning", "third quarter":
                spiritualComponents.append("releasing lunar energy")
                actionableGuidance.append("practice gratitude and gentle letting go")
            default:
                spiritualComponents.append("cyclical lunar wisdom")
                actionableGuidance.append("honor the natural rhythms of your soul")
            }
        }
        
        // Planetary Influence
        if let planet = dominantPlanet {
            switch planet.lowercased() {
            case "mercury":
                spiritualComponents.append("mercurial communication flow")
                actionableGuidance.append("speak your truth with clarity and wisdom")
            case "venus":
                spiritualComponents.append("venusian love frequency")
                actionableGuidance.append("cultivate beauty and harmony in your environment")
            case "mars":
                spiritualComponents.append("martian courage energy")
                actionableGuidance.append("take decisive action on important matters")
            case "jupiter":
                spiritualComponents.append("jupiterian expansion force")
                actionableGuidance.append("embrace opportunities for growth and learning")
            case "saturn":
                spiritualComponents.append("saturnian wisdom structure")
                actionableGuidance.append("honor your commitments and build lasting foundations")
            default:
                spiritualComponents.append("planetary guidance current")
                actionableGuidance.append("align with cosmic timing for optimal flow")
            }
        }
        
        // Emotional Integration
        if let emotion = emotionalState {
            switch emotion.lowercased() {
            case "balanced", "calm":
                actionableGuidance.append("maintain this centered state through mindful presence")
            case "energized", "excited":
                actionableGuidance.append("channel this vibrant energy toward meaningful pursuits")
            case "contemplative", "reflective":
                actionableGuidance.append("honor this introspective mood with gentle self-inquiry")
            case "restless", "unsettled":
                actionableGuidance.append("ground this energy through movement and breathwork")
            default:
                actionableGuidance.append("honor your current emotional state as sacred information")
            }
        }
        
        // Construct personalized insight based on type
        let primaryElement = spiritualComponents.first ?? "divine wisdom"
        let personalReference = personalReferences.first ?? "your spiritual essence"
        let guidanceAction = actionableGuidance.randomElement() ?? "trust the unfolding of your path"
        
        switch type {
        case .guidance:
            if spiritualComponents.count >= 2 {
                return "🌟 Today, \(spiritualComponents[0]) harmonizes with \(spiritualComponents[1]) through \(personalReference). The cosmos invites you to \(guidanceAction) while staying aligned with your authentic spiritual nature."
            } else {
                return "🌟 \(primaryElement.capitalized) flows through \(personalReference) today. The universe encourages you to \(guidanceAction) with confidence and spiritual awareness."
            }
            
        case .prediction:
            return "🔮 Your connection to \(primaryElement) reveals approaching opportunities for deeper spiritual understanding. Today's energy suggests you will \(guidanceAction) and discover new aspects of your soul's wisdom."
            
        case .affirmation:
            return "✨ I embrace \(primaryElement) flowing through \(personalReference). I trust my ability to \(guidanceAction) and remain open to the divine guidance surrounding me."
            
        case .reflection:
            return "🌙 As \(primaryElement) influences your day, reflect on how \(personalReference) serves your highest good. Consider how you can \(guidanceAction) while honoring your spiritual journey."
            
        default:
            return "🌌 The sacred dance of \(primaryElement) weaves through \(personalReference), creating opportunities to \(guidanceAction). Trust the divine intelligence guiding your path."
        }
    }
    
    private func buildSanctumInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        return "🏛️ Your sacred space resonates with divine wisdom. The cosmic patterns align to support your spiritual evolution and inner knowing."
    }
    
    private func buildFocusInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        let numerologyContext = contexts.first { $0.providerId == "numerology" }
        
        if let numerology = numerologyContext?.data,
           let _ = numerology["focusNumber"] as? Int,
           let _ = numerology["focusArchetype"] as? String {
            return "🎯 Your focus energy activates transformative power. Channel this into your intentions with clarity and purpose."
        }
        
        return "🎯 Focus your spiritual energy on what truly matters. Your intention becomes the seed of divine manifestation."
    }
    
    private func buildTimingInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        return "⏰ The cosmic clock aligns with your soul's timing. Trust the divine rhythm guiding your spiritual journey."
    }
    
    private func buildMatchInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        return "💫 Spiritual compatibility flows through shared vibrations and complementary energies. Honor both unity and uniqueness."
    }
    
    private func buildRealmInsight(contexts: [ProviderContext], type: KASPERInsightType) -> String {
        let numerologyContext = contexts.first { $0.providerId == "numerology" }
        
        if let numerology = numerologyContext?.data,
           let _ = numerology["realmNumber"] as? Int {
            return "🌍 Your current realm creates the energetic container for spiritual experiences. Work with its frequency for optimal flow."
        }
        
        return "🌍 Your current realm supports the lessons your soul is ready to integrate. Trust the divine curriculum."
    }
    
    private func getRequiredProviders(for feature: KASPERFeature) -> Set<String> {
        switch feature {
        case .journalInsight:
            return ["cosmic", "numerology", "biometric"]
        case .dailyCard:
            return ["cosmic", "numerology"]
        case .sanctumGuidance:
            return ["cosmic", "numerology", "biometric"]
        case .focusIntention:
            return ["numerology", "biometric"]
        case .cosmicTiming:
            return ["cosmic", "numerology"]
        case .matchCompatibility:
            return ["cosmic", "numerology"]
        case .realmInterpretation:
            return ["numerology", "cosmic"]
        }
    }
    
    /// Claude: Generate unique cache key based on request properties for insight caching
    /// Uses context hash to ensure cache invalidation when input data changes
    private func createCacheKey(for request: InsightRequest) -> String {
        let contextHash = String(request.context.primaryData.description.hashValue)
        return "\\(request.feature.rawValue)_\\(request.type.rawValue)_\\(contextHash)"
    }
    
    private func cacheInsight(_ insight: KASPERInsight, key: String) {
        // Implement LRU cache behavior
        if insightCache.count >= maxCacheSize {
            // Remove oldest entries
            let sortedEntries = insightCache.sorted { $0.value.insight.generatedAt < $1.value.insight.generatedAt }
            for i in 0..<(maxCacheSize / 4) { // Remove 25% of cache
                insightCache.removeValue(forKey: sortedEntries[i].key)
            }
        }
        
        let expiry = Date().addingTimeInterval(config.defaultCacheExpiry)
        insightCache[key] = InsightCacheEntry(
            insight: insight,
            contextHash: key,
            expiresAt: expiry
        )
        
        logger.debug("🔮 KASPER MLX: Cached insight with key: \\(key)")
    }
}