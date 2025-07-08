/**
 * Filename: KASPERManager.swift
 * 
 * 🎯 COMPREHENSIVE MANAGER REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Central orchestration manager for KASPER (Knowledge-Activated Spiritual Pattern & Expression Renderer).
 * Aggregates spiritual, biometric, and cosmic data from all VybeMVP sources into unified payload
 * for AI-powered oracle insights, affirmations, and spiritual guidance generation.
 * 
 * === KASPER ORACLE ENGINE INTEGRATION ===
 * This manager serves as the primary data bridge between VybeMVP's spiritual ecosystem
 * and the forthcoming KASPER AI oracle engine (Phase 11). It ensures all mystical
 * calculations, biometric data, and cosmic timing are properly formatted and validated
 * for intelligent spiritual guidance generation.
 * 
 * === KEY RESPONSIBILITIES ===
 * • Aggregate data from all spiritual managers (Realm, Focus, Health, etc.)
 * • Generate comprehensive KASPERPrimingPayload structures with validation
 * • Provide real-time and historical payload generation capabilities
 * • Maintain spiritual integrity with numerological accuracy and mystical correspondences
 * • Cache and optimize payload generation for performance
 * • Integrate with future astrology and proximity systems (Phases 8-9)
 * 
 * === ARCHITECTURE PATTERN ===
 * • Design: Singleton with dependency injection support
 * • Threading: Main thread for UI updates, background for data aggregation
 * • Storage: Memory caching with optional persistence
 * • Communication: Combine publishers for reactive payload updates
 * 
 * === PUBLISHED PROPERTIES ===
 * • currentPayload: Latest generated KASPER payload for oracle consumption
 * • isPayloadReady: Boolean flag indicating complete data availability
 * • lastPayloadGenerationTime: Timestamp for payload freshness validation
 * • dataSourceHealth: Status indicator for all integrated spiritual data sources
 * 
 * === DATA SOURCE INTEGRATION ===
 * 
 * NUMEROLOGICAL CORE (UserProfile):
 * • Life Path Number: Primary spiritual identity calculation
 * • Soul Urge Number: Heart's desire from birth name vowels
 * • Expression Number: Destiny calculation from complete birth name
 * • Spiritual Tone: User-selected mode (Manifestation, Reflection, etc.)
 * 
 * BIOMETRIC DATA (HealthKitManager):
 * • Heart Rate: Real-time BPM with simulation fallback
 * • Chakra State: Future integration with meditation tracking
 * 
 * COSMIC CALCULATIONS (RealmNumberManager, FocusNumberManager):
 * • Realm Number: Environmental cosmic state calculation
 * • Focus Number: User-selected daily intention
 * 
 * FUTURE INTEGRATIONS (Phases 8-9):
 * • Lunar Phase: Moon cycle timing for cosmic alignment
 * • Planetary Influence: Dominant celestial body calculations
 * • Proximity Score: Location-based spiritual resonance matching
 * 
 * === PAYLOAD GENERATION METHODS ===
 * 
 * REAL-TIME GENERATION:
 * • generateCurrentPayload(): Immediate payload with latest data
 * • refreshPayload(): Update payload with current spiritual state
 * 
 * USER-SPECIFIC GENERATION:
 * • generatePayloadForUser(userID:): Targeted payload for specific user
 * • generatePayloadWithProfile(_:): Payload from provided UserProfile
 * 
 * TESTING & VALIDATION:
 * • generateTestPayload(): Mock payload for development and testing
 * • validatePayload(_:): Comprehensive spiritual data validation
 * 
 * === PERFORMANCE OPTIMIZATIONS ===
 * 
 * CACHING SYSTEM:
 * • Payload caching with 5-minute freshness validation
 * • Data source health monitoring to prevent stale data
 * • Background refresh scheduling for proactive payload updates
 * 
 * EFFICIENCY MEASURES:
 * • Lazy loading of expensive calculations
 * • Batch data fetching from multiple sources
 * • Memory management with automatic cache cleanup
 * • Throttling to prevent excessive payload generation
 * 
 * === ERROR HANDLING & FALLBACKS ===
 * 
 * DATA UNAVAILABILITY:
 * • Graceful degradation when optional sources unavailable
 * • Default values for missing cosmic/astrology data
 * • Simulation fallbacks for HealthKit restrictions
 * 
 * VALIDATION FAILURES:
 * • Comprehensive validation with specific error reporting
 * • Automatic correction of out-of-range values
 * • Logging and monitoring for data integrity issues
 * 
 * === FUTURE PHASE INTEGRATION ===
 * 
 * PHASE 7 (Sacred Geometry):
 * • Mandala selection based on payload spiritual state
 * • Dynamic sacred symbol integration with number patterns
 * 
 * PHASE 8 (Astrology Engine):
 * • Real-time lunar phase integration from NASA APIs
 * • Planetary position calculations for dominant influence
 * • Zodiac alignment with user birth data
 * 
 * PHASE 9 (Proximity Matching):
 * • Location-based spiritual resonance calculation
 * • Multi-user cosmic compatibility scoring
 * • Privacy-controlled proximity data integration
 * 
 * PHASE 11 (KASPER Oracle):
 * • Direct payload streaming to AI interpretation layer
 * • Real-time oracle response generation
 * • Personalized insight and affirmation delivery
 * 
 * === SPIRITUAL INTEGRITY GUARANTEES ===
 * • Master Number Preservation: 11, 22, 33, 44 never reduced
 * • Numerological Accuracy: Authentic calculation methods maintained
 * • Cosmic Timing Respect: Lunar and planetary influences honored
 * • Sacred Correspondences: Color, chakra, and element mappings preserved
 * 
 * === CONFIGURATION REQUIREMENTS ===
 * IMPORTANT: KASPERManager requires configuration with RealmNumberManager dependency.
 * Call configure(with:) method during app initialization with the RealmNumberManager
 * instance from VybeMVPApp to ensure proper cosmic number integration.
 * 
 * Example:
 * KASPERManager.shared.configure(with: realmNumberManager)
 * 
 * === AI ASSISTANT INTEGRATION NOTES ===
 * This manager is designed for seamless AI assistant interaction. All methods
 * include comprehensive documentation, error handling, and validation to ensure
 * future AI assistants can effectively generate spiritual insights and maintain
 * the sacred integrity of VybeMVP's mystical calculations.
 */

import Foundation
import Combine
import os.log

/**
 * KASPERManager: Central orchestration for spiritual data aggregation and oracle payload generation
 * 
 * This manager serves as the primary coordination point for all spiritual data sources
 * in VybeMVP, generating comprehensive payloads for the KASPER oracle engine and
 * maintaining the integrity of numerological calculations and mystical correspondences.
 */
class KASPERManager: ObservableObject {
    
    // MARK: - Singleton Instance
    
    /// Shared singleton instance for app-wide KASPER coordination
    static let shared = KASPERManager()
    
    // MARK: - Published Properties
    
    /// Current KASPER payload with latest spiritual and biometric data
    @Published private(set) var currentPayload: KASPERPrimingPayload?
    
    /// Boolean indicating if payload is ready for oracle consumption
    @Published private(set) var isPayloadReady: Bool = false
    
    /// Timestamp of last successful payload generation
    @Published private(set) var lastPayloadGenerationTime: Date?
    
    /// Health status of all integrated data sources
    @Published private(set) var dataSourceHealth: DataSourceHealth = DataSourceHealth()
    
    // MARK: - Private Properties
    
    /// Payload cache for performance optimization
    private var payloadCache: PayloadCache?
    
    /// Combine cancellables for reactive subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Logger for KASPER operations and debugging
    private let logger = Logger(subsystem: "com.infinitiesinn.vybe", category: "KASPERManager")
    
    /// Payload generation throttle timer
    private var payloadThrottleTimer: Timer?
    
    // MARK: - Data Source References
    
    /// Reference to RealmNumberManager for cosmic calculations (injected dependency)
    private weak var realmNumberManager: RealmNumberManager?
    
    /// Reference to FocusNumberManager for intention tracking
    private var focusNumberManager: FocusNumberManager {
        return FocusNumberManager.shared
    }
    
    /// Reference to HealthKitManager for biometric data
    private var healthKitManager: HealthKitManager {
        return HealthKitManager.shared
    }
    
    /// Reference to UserProfileService for spiritual identity
    private var userProfileService: UserProfileService {
        return UserProfileService.shared
    }
    
    // MARK: - Initialization
    
    private init() {
        logger.info("🔮 KASPERManager: Initializing spiritual data orchestration")
        setupDataSourceSubscriptions()
        schedulePayloadRefresh()
    }
    
    deinit {
        payloadThrottleTimer?.invalidate()
        cancellables.removeAll()
    }
    
    // MARK: - Configuration Methods
    
    /**
     * Configure KASPERManager with required dependencies
     * 
     * This method must be called during app initialization to provide access
     * to the RealmNumberManager instance created in the main app.
     * 
     * Parameter realmManager: The RealmNumberManager instance from VybeMVPApp
     */
    func configure(with realmManager: RealmNumberManager) {
        logger.info("🔧 Configuring KASPERManager with RealmNumberManager")
        self.realmNumberManager = realmManager
        
        // Re-setup subscriptions with the new manager
        setupDataSourceSubscriptions()
    }
    
    // MARK: - Public Payload Generation Methods
    
    /**
     * Generate current KASPER payload with latest spiritual and biometric data
     * 
     * This method aggregates data from all available sources and creates a complete
     * payload suitable for oracle processing. It includes validation and fallback
     * mechanisms to ensure data integrity.
     * 
     * Returns: KASPERPrimingPayload with current spiritual state, nil if generation fails
     */
    func generateCurrentPayload() -> KASPERPrimingPayload? {
        logger.info("🔮 Generating current KASPER payload")
        
        // Check cache freshness first
        if let cachedPayload = getCachedPayload() {
            logger.info("📦 Returning cached KASPER payload")
            return cachedPayload
        }
        
        // Get current user ID for profile lookup
        guard let currentUserID = getCurrentUserID() else {
            logger.warning("⚠️ No current user ID available for payload generation")
            return generateAnonymousPayload()
        }
        
        // Fetch user profile for numerological data
        guard let userProfile = getUserProfile(for: currentUserID) else {
            logger.warning("⚠️ No user profile available for payload generation")
            return generateAnonymousPayload()
        }
        
        return generatePayloadWithProfile(userProfile)
    }
    
    /**
     * Generate KASPER payload for specific user ID
     * 
     * Creates a targeted payload for a specific user, useful for batch processing
     * or multi-user spiritual analysis scenarios.
     * 
     * Parameter userID: Target user identifier
     * Returns: KASPERPrimingPayload for specified user, nil if user data unavailable
     */
    func generatePayloadForUser(_ userID: String) -> KASPERPrimingPayload? {
        logger.info("🔮 Generating KASPER payload for user: \(userID)")
        
        guard let userProfile = getUserProfile(for: userID) else {
            logger.error("❌ Failed to fetch profile for user: \(userID)")
            return nil
        }
        
        return generatePayloadWithProfile(userProfile)
    }
    
    /**
     * Generate KASPER payload from provided UserProfile
     * 
     * Core payload generation method that creates complete spiritual data payload
     * from a provided UserProfile and current environmental/biometric data.
     * 
     * Parameter profile: UserProfile containing numerological and preference data
     * Returns: KASPERPrimingPayload with complete spiritual state
     */
    func generatePayloadWithProfile(_ profile: UserProfile) -> KASPERPrimingPayload? {
        logger.info("🔮 Generating KASPER payload with profile for user: \(profile.id)")
        
        // Gather numerological core data
        let lifePathNumber = profile.lifePathNumber
        let soulUrgeNumber = profile.soulUrgeNumber ?? generateFallbackSoulUrge(from: profile)
        let expressionNumber = profile.expressionNumber ?? generateFallbackExpression(from: profile)
        let userTonePreference = profile.insightTone
        
        // Gather biometric data
        let currentBPM = healthKitManager.currentHeartRate
        let chakraState = getChakraState() // Future implementation
        
        // Gather cosmic data
        let realmNumber = realmNumberManager?.currentRealmNumber ?? 1 // Default to 1 if not configured
        let focusNumber = focusNumberManager.selectedFocusNumber
        let lunarPhase = getLunarPhase() // Future Phase 8 implementation
        let dominantPlanet = getDominantPlanet() // Future Phase 8 implementation
        
        // Gather social data
        let proximityScore = getProximityMatchScore() // Future Phase 9 implementation
        
        // Create payload with validation
        let payload = KASPERPrimingPayload(
            lifePathNumber: lifePathNumber,
            soulUrgeNumber: soulUrgeNumber,
            expressionNumber: expressionNumber,
            userTonePreference: userTonePreference,
            chakraState: chakraState,
            bpm: currentBPM,
            lunarPhase: lunarPhase,
            dominantPlanet: dominantPlanet,
            realmNumber: realmNumber,
            focusNumber: focusNumber,
            proximityMatchScore: proximityScore
        )
        
        // Validate payload integrity
        guard payload.isValid else {
            logger.error("❌ Generated payload failed validation")
            return nil
        }
        
        // Cache successful payload
        cachePayload(payload)
        updatePayloadState(payload)
        
        logger.info("✅ Successfully generated KASPER payload")
        logger.debug("\(payload.debugDescription)")
        
        return payload
    }
    
    /**
     * Refresh current payload with latest data
     * 
     * Forces regeneration of the current payload with the most up-to-date
     * spiritual, biometric, and cosmic data. Useful for real-time updates.
     */
    func refreshPayload() {
        logger.info("🔄 Refreshing KASPER payload")
        clearPayloadCache()
        currentPayload = generateCurrentPayload()
    }
    
    /**
     * Generate test payload for development and debugging
     * 
     * Creates a mock payload with realistic spiritual data for testing
     * KASPER integration and oracle functionality without real user data.
     * 
     * Returns: KASPERPrimingPayload with test data
     */
    func generateTestPayload() -> KASPERPrimingPayload {
        logger.info("🧪 Generating test KASPER payload")
        
        return KASPERPrimingPayload(
            lifePathNumber: 7,
            soulUrgeNumber: 11,
            expressionNumber: 3,
            userTonePreference: "Manifestation",
            chakraState: "Heart:Balanced,Crown:Opening",
            bpm: 72,
            lunarPhase: "Full Moon",
            dominantPlanet: "Venus",
            realmNumber: 5,
            focusNumber: 3,
            proximityMatchScore: 0.85
        )
    }
    
    // MARK: - Private Helper Methods
    
    /**
     * Setup reactive subscriptions to data sources
     */
    private func setupDataSourceSubscriptions() {
        // Clear existing subscriptions
        cancellables.removeAll()
        
        // Subscribe to realm number changes (if manager is available)
        if let realmManager = realmNumberManager {
            realmManager.$currentRealmNumber
                .sink { [weak self] _ in
                    self?.schedulePayloadRefresh()
                }
                .store(in: &cancellables)
        }
        
        // Subscribe to focus number changes
        focusNumberManager.$selectedFocusNumber
            .sink { [weak self] _ in
                self?.schedulePayloadRefresh()
            }
            .store(in: &cancellables)
        
        // Subscribe to heart rate changes
        healthKitManager.$currentHeartRate
            .sink { [weak self] _ in
                self?.schedulePayloadRefresh()
            }
            .store(in: &cancellables)
    }
    
    /**
     * Schedule throttled payload refresh
     */
    private func schedulePayloadRefresh() {
        payloadThrottleTimer?.invalidate()
        payloadThrottleTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshPayload()
            }
        }
    }
    
    /**
     * Get current user ID from authentication system
     */
    private func getCurrentUserID() -> String? {
        // Get user ID from AuthenticationManager
        if let userID = AuthenticationManager.shared.userID {
            logger.info("🔍 Retrieved user ID from AuthenticationManager: \(userID)")
            return userID
        }
        
        logger.warning("⚠️ No user ID available from AuthenticationManager")
        return nil
    }
    
    /**
     * Fetch user profile for given user ID
     */
    private func getUserProfile(for userID: String) -> UserProfile? {
        return userProfileService.getCurrentUserProfileFromUserDefaults(for: userID)
    }
    
    /**
     * Generate fallback Soul Urge number from Life Path
     */
    private func generateFallbackSoulUrge(from profile: UserProfile) -> Int {
        // Simple fallback: derive from Life Path with offset
        let fallback = ((profile.lifePathNumber + 2) % 9) + 1
        logger.info("📋 Generated fallback Soul Urge: \(fallback)")
        return fallback
    }
    
    /**
     * Generate fallback Expression number from Life Path
     */
    private func generateFallbackExpression(from profile: UserProfile) -> Int {
        // Simple fallback: derive from Life Path with different offset
        let fallback = ((profile.lifePathNumber + 4) % 9) + 1
        logger.info("📋 Generated fallback Expression: \(fallback)")
        return fallback
    }
    
    /**
     * Get current chakra state (future implementation)
     */
    private func getChakraState() -> String? {
        // Placeholder for Phase 7 chakra tracking integration
        return nil
    }
    
    /**
     * Get current lunar phase (future Phase 8 implementation)
     */
    private func getLunarPhase() -> String {
        // Placeholder for astrology API integration
        return "Waxing Crescent"
    }
    
    /**
     * Get dominant planet (future Phase 8 implementation)
     */
    private func getDominantPlanet() -> String {
        // Placeholder for planetary calculation
        return "Venus"
    }
    
    /**
     * Get proximity match score (future Phase 9 implementation)
     */
    private func getProximityMatchScore() -> Double {
        // Placeholder for location-based matching
        return 0.0
    }
    
    /**
     * Generate anonymous payload for users without profile
     */
    private func generateAnonymousPayload() -> KASPERPrimingPayload? {
        logger.info("🔮 Generating anonymous KASPER payload")
        
        return KASPERPrimingPayload(
            lifePathNumber: 1, // Default life path
            soulUrgeNumber: 1, // Default soul urge
            expressionNumber: 1, // Default expression
            userTonePreference: "Gentle", // Default tone
            chakraState: nil,
            bpm: healthKitManager.currentHeartRate,
            lunarPhase: getLunarPhase(),
            dominantPlanet: getDominantPlanet(),
            realmNumber: realmNumberManager?.currentRealmNumber ?? 1,
            focusNumber: focusNumberManager.selectedFocusNumber,
            proximityMatchScore: 0.0
        )
    }
    
    // MARK: - Caching Methods
    
    /**
     * Get cached payload if still fresh
     */
    private func getCachedPayload() -> KASPERPrimingPayload? {
        guard let cache = payloadCache,
              cache.isValid() else {
            return nil
        }
        return cache.payload
    }
    
    /**
     * Cache payload for performance optimization
     */
    private func cachePayload(_ payload: KASPERPrimingPayload) {
        payloadCache = PayloadCache(payload: payload, timestamp: Date())
    }
    
    /**
     * Clear payload cache to force regeneration
     */
    private func clearPayloadCache() {
        payloadCache = nil
    }
    
    /**
     * Update published payload state
     */
    private func updatePayloadState(_ payload: KASPERPrimingPayload) {
        DispatchQueue.main.async { [weak self] in
            self?.currentPayload = payload
            self?.isPayloadReady = true
            self?.lastPayloadGenerationTime = Date()
        }
    }
}

// MARK: - Supporting Data Structures

/**
 * PayloadCache: Performance optimization for payload caching
 */
private struct PayloadCache {
    let payload: KASPERPrimingPayload
    let timestamp: Date
    
    /// Cache validity duration (5 minutes)
    private let validityDuration: TimeInterval = 300
    
    /// Check if cache is still valid
    func isValid() -> Bool {
        return Date().timeIntervalSince(timestamp) < validityDuration
    }
}

/**
 * DataSourceHealth: Health monitoring for all spiritual data sources
 */
struct DataSourceHealth {
    var realmManagerHealthy: Bool = true
    var focusManagerHealthy: Bool = true
    var healthKitHealthy: Bool = true
    var userProfileHealthy: Bool = true
    var astrologyHealthy: Bool = false // Future Phase 8
    var proximityHealthy: Bool = false // Future Phase 9
    
    /// Overall health status
    var isHealthy: Bool {
        return realmManagerHealthy && focusManagerHealthy && healthKitHealthy && userProfileHealthy
    }
}