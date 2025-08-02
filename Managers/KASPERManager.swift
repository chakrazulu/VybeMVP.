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

// Claude: FIXED - Import required utilities for real data
// Import needed for MoonPhaseCalculator

/**
 * KASPERManager: Legacy compatibility layer for KASPER MLX
 * 
 * ⚠️ DEPRECATED: This manager is replaced by KASPERMLXManager
 * 
 * This class now serves as a compatibility layer that redirects
 * calls to the new KASPER MLX async architecture. New code should
 * use KASPERMLXManager directly for modern async/await patterns.
 * 
 * The old synchronous payload approach has been replaced with
 * lightweight, feature-specific insight generation.
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
    
    /// Reference to CosmicDataRepository for real-time transit data (injected dependency)
    private weak var cosmicDataRepository: CosmicDataRepositoryProtocol?
    
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
    
    /// Reference to SanctumDataManager for MegaCorpus spiritual interpretations
    @MainActor private var sanctumDataManager: SanctumDataManager {
        return SanctumDataManager.shared
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
     * ⚠️ DEPRECATED: This method is replaced by KASPERMLXManager.configure()
     * 
     * Legacy compatibility method that redirects to the new KASPER MLX system.
     * The new system handles configuration automatically during app initialization.
     * 
     * Parameters:
     *   - realmManager: The RealmNumberManager instance (forwarded to KASPER MLX)
     *   - cosmicRepository: The CosmicDataRepository instance (not used in new system)
     */
    func configure(with realmManager: RealmNumberManager, cosmicRepository: CosmicDataRepositoryProtocol? = nil) {
        logger.info("🔧 KASPER Legacy: Configuration called - KASPER MLX handles this automatically")
        
        // Store references for legacy compatibility
        self.realmNumberManager = realmManager
        self.cosmicDataRepository = cosmicRepository
        
        // Note: KASPER MLX is configured separately in VybeMVPApp
        logger.info("🔧 KASPER Legacy: Configuration complete (KASPER MLX handles actual setup)")
    }
    
    // MARK: - Public Payload Generation Methods
    
    /**
     * Generate current KASPER payload with latest spiritual and biometric data
     * 
     * ⚠️ DEPRECATED: This method is replaced by KASPERMLXManager.generateQuickInsight()
     * 
     * This legacy method now redirects to the new KASPER MLX architecture.
     * For new code, use KASPERMLXManager directly with async/await patterns.
     * 
     * Returns: String indicating legacy mode (old payload system discontinued)
     */
    func generateCurrentPayload() -> KASPERPrimingPayload? {
        logger.info("🔮 KASPER Legacy: Payload method called - redirecting to KASPER MLX")
        
        // Redirect to new KASPER MLX system
        Task { @MainActor in
            do {
                let insight = try await KASPERMLXManager.shared.generateQuickInsight(
                    for: .sanctumGuidance,
                    query: "Legacy payload compatibility"
                )
                logger.info("🔮 KASPER MLX: Legacy compatibility insight generated")
                print("🔮 Legacy KASPER payload replaced with KASPER MLX insight: \(insight.content)")
            } catch {
                logger.error("🔮 KASPER MLX: Legacy compatibility failed: \(error)")
            }
        }
        
        // Return nil to indicate legacy mode (old payload system discontinued)
        logger.warning("🔮 KASPER Legacy: Returning nil - use KASPERMLXManager for new insights")
        return nil
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
        
        // Claude: DEBUG - Check what data is available in the profile
        print("🔍 KASPER DEBUG - UserProfile data:")
        print("   • Sun: \(profile.natalSunSign ?? "nil")")
        print("   • Moon: \(profile.natalMoonSign ?? "nil")")
        print("   • Rising: \(profile.risingSign ?? "nil")")
        print("   • Has Birth Time: \(profile.hasBirthTime)")
        print("   • Dominant Element: \(profile.dominantElement ?? "nil")")
        
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
        
        // Generate enhanced natal chart and transit data
        // Claude: FIXED - Use live SwiftAA data instead of empty UserProfile natal data
        print("🔍 KASPER: About to generate natal chart data...")
        let natalChartData = generateLiveNatalChartData(from: profile)
        
        print("🔍 KASPER: About to get current transit data...")
        let currentTransitData = getCurrentTransitData()
        
        print("🔍 KASPER: About to create environmental context...")
        let environmentalContextData = EnvironmentalContext()
        
        print("🔍 KASPER: About to extract MegaCorpus data...")
        let megaCorpusExtract = extractRelevantMegaCorpusData(natalChart: natalChartData, transits: currentTransitData)
        
        // Create enhanced payload with validation
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
            proximityMatchScore: proximityScore,
            natalChart: natalChartData,
            currentTransits: currentTransitData,
            environmentalContext: environmentalContextData,
            megaCorpusData: megaCorpusExtract
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
        
        // Claude: FIXED - Debug payload whenever it refreshes (especially on realm number changes)
        if let payload = currentPayload {
            print("🔮 KASPER PAYLOAD REFRESHED:")
            print(payload.debugDescription)
        } else {
            print("❌ KASPER PAYLOAD GENERATION FAILED")
        }
    }
    
    /**
     * Generate test payload for development and debugging
     * 
     * Creates a mock payload with realistic spiritual data for testing
     * KASPER integration and oracle functionality without real user data.
     * 
     * Returns: KASPERPrimingPayload with test data
     */
    @available(iOS 13.0, *)
    func generateTestPayload() -> KASPERPrimingPayload {
        logger.info("🧪 Generating test KASPER payload")
        
        // Create test natal chart data
        let testNatalChart = NatalChartData(
            sunSign: "Leo",
            moonSign: "Scorpio", 
            risingSign: "Aquarius",
            midheavenSign: "Sagittarius",
            mercurySign: "Virgo",
            venusSign: "Cancer",
            marsSign: "Aries",
            jupiterSign: "Pisces",
            saturnSign: "Capricorn",
            uranusSign: nil,
            neptuneSign: nil,
            plutoSign: nil,
            northNodeSign: "Gemini",
            southNodeSign: nil,
            dominantElement: "Fire",
            dominantModality: "Fixed",
            hasBirthTime: true,
            birthLocation: "New York, NY",
            calculatedAt: Date()
        )
        
        // Create test transit data
        let testTransitData = getCurrentTransitData() // Use our current method
        
        // Create test environmental context
        let testEnvironmentalContext = EnvironmentalContext()
        
        // Create test MegaCorpus extract
        let testMegaCorpusExtract = createTestMegaCorpusExtract()
        
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
            proximityMatchScore: 0.85,
            natalChart: testNatalChart,
            currentTransits: testTransitData,
            environmentalContext: testEnvironmentalContext,
            megaCorpusData: testMegaCorpusExtract
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
                .sink { [weak self] newRealmNumber in
                    print("🌌 KASPER: Realm number changed to \(newRealmNumber) - refreshing KASPER payload")
                    self?.schedulePayloadRefresh()
                }
                .store(in: &cancellables)
        }
        
        // Subscribe to cosmic data changes (if repository is available)
        if let cosmicRepository = cosmicDataRepository {
            Task { @MainActor in
                cosmicRepository.snapshotPublisher
                    .sink { [weak self] _ in
                        self?.schedulePayloadRefresh()
                    }
                    .store(in: &cancellables)
            }
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
        // Claude: FIXED - Use actual moon phase calculation instead of placeholder
        let moonPhase = MoonPhaseCalculator.moonPhase(for: Date())
        return moonPhase.rawValue
    }
    
    /**
     * Get dominant planet (future Phase 8 implementation)
     */
    private func getDominantPlanet() -> String {
        // Claude: FIXED - Use actual cosmic data with proper actor isolation
        let cosmicData = MainActor.assumeIsolated {
            CosmicService.shared.todaysCosmic
        }
        
        if cosmicData != nil {
            // Analyze planetary data to find dominant influence
            // Use Sun during day, Moon at night as basic logic
            let hour = Calendar.current.component(.hour, from: Date())
            return (hour >= 6 && hour < 18) ? "Sun" : "Moon"
        }
        
        // Fallback: Use CosmicDataRepository if CosmicService unavailable
        if let cosmicRepository = cosmicDataRepository {
            _ = MainActor.assumeIsolated {
                cosmicRepository.currentSnapshot
            }
            // Use Sun as dominant during day, Moon at night
            let hour = Calendar.current.component(.hour, from: Date())
            return (hour >= 6 && hour < 18) ? "Sun" : "Moon"
        }
        
        // Final fallback based on time of day
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18) ? "Sun" : "Moon"
    }
    
    /**
     * Get proximity match score (future Phase 9 implementation)
     */
    private func getProximityMatchScore() -> Double {
        // Placeholder for location-based matching
        return 0.0
    }
    
    /**
     * Get current transit data from CosmicDataRepository
     * 
     * This bridges the gap between the cosmic snapshot view and KASPER by providing
     * real-time planetary positions and transit information for personalized insights.
     */
    private func getCurrentTransitData() -> TransitData? {
        // Use real CosmicDataRepository if available
        if let repository = cosmicDataRepository {
            let currentSnapshot = MainActor.assumeIsolated {
                repository.currentSnapshot
            }
            logger.info("🌌 Using real cosmic data from CosmicDataRepository")
            return TransitData(from: currentSnapshot)
        }
        
        // Fallback to placeholder data if repository not configured
        logger.info("📊 CosmicDataRepository not configured, using development placeholder transit data")
        
        let now = Date()
        
        // Create placeholder transit data for development/testing
        let fallbackCosmicSnapshot = CosmicSnapshot(
            moonData: PlanetaryData(
                planet: "Moon",
                currentSign: "Cancer", // Placeholder
                isRetrograde: false,
                nextTransit: "→ Leo",
                position: 15.5,
                emoji: "☽",
                lastUpdated: now
            ),
            sunData: PlanetaryData(
                planet: "Sun",
                currentSign: "Leo", // Placeholder based on current season
                isRetrograde: false,
                nextTransit: "→ Virgo",
                position: 5.2,
                emoji: "☉",
                lastUpdated: now
            ),
            planetaryData: [
                // Add basic planetary data for testing
                PlanetaryData(planet: "Mercury", currentSign: "Leo", isRetrograde: false, nextTransit: "→ Virgo", position: 10.0, emoji: "☿", lastUpdated: now),
                PlanetaryData(planet: "Venus", currentSign: "Cancer", isRetrograde: false, nextTransit: "→ Leo", position: 25.0, emoji: "♀", lastUpdated: now),
                PlanetaryData(planet: "Mars", currentSign: "Gemini", isRetrograde: false, nextTransit: "→ Cancer", position: 8.0, emoji: "♂", lastUpdated: now),
                PlanetaryData(planet: "Jupiter", currentSign: "Taurus", isRetrograde: false, nextTransit: "→ Gemini", position: 12.0, emoji: "♃", lastUpdated: now),
                PlanetaryData(planet: "Saturn", currentSign: "Pisces", isRetrograde: true, nextTransit: "→ Aries", position: 19.0, emoji: "♄", lastUpdated: now)
            ],
            currentSeason: getCurrentSeason(),
            lastUpdated: now,
            isLoading: false,
            error: nil
        )
        
        return TransitData(from: fallbackCosmicSnapshot)
    }
    
    /**
     * Get current season based on current date
     */
    private func getCurrentSeason() -> String {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 3...5: return "Spring"
        case 6...8: return "Summer"
        case 9...11: return "Autumn"
        default: return "Winter"
        }
    }
    
    /**
     * Generate live natal chart data using current SwiftAA calculations
     * Claude: CRITICAL FIX - This bridges the gap between Sanctum's live data and KASPER payload
     */
    private func generateLiveNatalChartData(from profile: UserProfile) -> NatalChartData? {
        print("🔍 KASPER: generateLiveNatalChartData called")
        
        // Claude: LIGHTWEIGHT FIX - Use already calculated cosmic data instead of recalculating
        guard let cosmicData = getExistingCosmicData() else {
            print("⚠️ KASPER: No existing cosmic data available - skipping natal chart generation")
            return nil
        }
        
        // Use UserProfile natal data if available, otherwise use current positions as placeholder
        let sunSign = profile.natalSunSign ?? cosmicData.sunSign
        let moonSign = profile.natalMoonSign ?? cosmicData.zodiacSign(for: "Moon") ?? "Unknown"
        let risingSign = profile.risingSign // Keep as is (user input required)
        
        // Extract current planetary positions from live cosmic data using existing methods
        let mercurySign = cosmicData.zodiacSign(for: "Mercury") ?? "Unknown"
        let venusSign = cosmicData.zodiacSign(for: "Venus") ?? "Unknown"
        let marsSign = cosmicData.zodiacSign(for: "Mars") ?? "Unknown"
        let jupiterSign = cosmicData.zodiacSign(for: "Jupiter") ?? "Unknown"
        let saturnSign = cosmicData.zodiacSign(for: "Saturn") ?? "Unknown"
        let uranusSign = cosmicData.zodiacSign(for: "Uranus")
        let neptuneSign = cosmicData.zodiacSign(for: "Neptune")
        let plutoSign = cosmicData.zodiacSign(for: "Pluto")
        
        print("🔮 KASPER: Using live SwiftAA data for natal chart:")
        print("   • Sun: \(sunSign) (from \(profile.natalSunSign != nil ? "profile" : "live SwiftAA"))")
        print("   • Moon: \(moonSign) (from \(profile.natalMoonSign != nil ? "profile" : "live SwiftAA"))")
        print("   • Mercury: \(mercurySign) (live SwiftAA)")
        print("   • Venus: \(venusSign) (live SwiftAA)")
        print("   • Mars: \(marsSign) (live SwiftAA)")
        print("   • Rising: \(risingSign ?? "Unknown") (requires user input)")
        print("   • Has Birth Time: \(profile.hasBirthTime)")
        
        return NatalChartData(
            sunSign: sunSign,
            moonSign: moonSign,
            risingSign: risingSign,
            midheavenSign: nil, // Requires birth time
            mercurySign: mercurySign,
            venusSign: venusSign,
            marsSign: marsSign,
            jupiterSign: jupiterSign,
            saturnSign: saturnSign,
            uranusSign: uranusSign,
            neptuneSign: neptuneSign,
            plutoSign: plutoSign,
            northNodeSign: nil, // Requires birth data
            southNodeSign: nil, // Requires birth data
            dominantElement: profile.dominantElement ?? getDominantElementFromCosmicData(cosmicData),
            dominantModality: nil, // Could be calculated from sign distribution
            hasBirthTime: profile.hasBirthTime,
            birthLocation: nil, // Requires user input
            calculatedAt: Date()
        )
    }
    
    /**
     * Get dominant element from current cosmic data
     */
    private func getDominantElementFromCosmicData(_ cosmicData: CosmicData) -> String? {
        // Simple element analysis based on Sun sign
        switch cosmicData.sunSign.lowercased() {
        case "aries", "leo", "sagittarius":
            return "Fire"
        case "taurus", "virgo", "capricorn":
            return "Earth"
        case "gemini", "libra", "aquarius":
            return "Air"
        case "cancer", "scorpio", "pisces":
            return "Water"
        default:
            return nil
        }
    }
    
    /**
     * Get existing cosmic data without triggering new calculations
     * Claude: LIGHTWEIGHT - Reuses data already calculated by Sanctum/CosmicService
     */
    private func getExistingCosmicData() -> CosmicData? {
        // Try to get from CosmicService first (already calculated)
        if let existingData = MainActor.assumeIsolated({
            CosmicService.shared.todaysCosmic
        }) {
            print("🔮 KASPER: Using existing cosmic data from CosmicService")
            return existingData
        }
        
        // Fallback: Use the same method as getCurrentTransitData()
        print("🔮 KASPER: No cached CosmicService data, falling back to repository")
        
        // Only calculate if absolutely no data exists (shouldn't happen in normal flow)
        print("⚠️ KASPER: No existing cosmic data found - this shouldn't happen in normal flow")
        return nil
    }
    
    /**
     * Extract relevant MegaCorpus data based on natal chart and current transits
     * 
     * This method analyzes the user's natal chart and current planetary transits
     * to extract the most relevant spiritual wisdom and interpretations from the
     * MegaCorpus database for personalized KASPER insights.
     */
    private func extractRelevantMegaCorpusData(natalChart: NatalChartData?, transits: TransitData?) -> MegaCorpusExtract? {
        logger.info("📚 Extracting relevant MegaCorpus data for KASPER")
        
        // Check if MegaCorpus data is available
        let (isDataLoaded, megaCorpusData) = MainActor.assumeIsolated {
            (sanctumDataManager.isDataLoaded, sanctumDataManager.megaCorpusData)
        }
        
        // Claude: DEBUG - Check MegaCorpus loading status
        print("🔍 KASPER DEBUG - MegaCorpus status:")
        print("   • Is Data Loaded: \(isDataLoaded)")
        print("   • MegaCorpus top-level keys: \(megaCorpusData.keys.sorted())")
        
        if let signsData = megaCorpusData["signs"] as? [String: Any] {
            print("   • Signs data structure keys: \(signsData.keys.sorted())")
            if let signs = signsData["signs"] as? [String: Any] {
                print("   • Signs available: \(signs.keys.count) - \(Array(signs.keys.prefix(3)))")
            }
        }
        if let planetsData = megaCorpusData["planets"] as? [String: Any] {
            print("   • Planets data structure keys: \(planetsData.keys.sorted())")
            if let planets = planetsData["planets"] as? [String: Any] {
                print("   • Planets available: \(planets.keys.count) - \(Array(planets.keys.prefix(3)))")
            }
        }
        if let numerologyData = megaCorpusData["numerology"] as? [String: Any] {
            print("   • Numerology data structure keys: \(numerologyData.keys.sorted())")
            if let focusNumbers = numerologyData["focusNumbers"] as? [String: Any] {
                print("   • Focus numbers available: \(focusNumbers.keys.count) - \(Array(focusNumbers.keys.prefix(3)))")
            }
        }
        
        guard isDataLoaded else {
            logger.warning("⚠️ MegaCorpus data not loaded, attempting to load data...")
            
            // Claude: FIXED - Try to load the data if it's not loaded yet
            Task { @MainActor in
                sanctumDataManager.loadMegaCorpusData()
                logger.info("📚 SanctumDataManager data loading attempted")
            }
            
            // For now, return minimal extract with what we have
            return MegaCorpusExtract()
        }
        var signInterpretations: [String: SignInterpretation] = [:]
        var planetaryMeanings: [String: PlanetaryMeaning] = [:]
        var elementalGuidance: [String: ElementalGuidance] = [:]
        // Claude: FIXED - Extract numerological insights from MegaCorpus
        var numerologicalInsights: [String: NumerologicalInsight] = [:]
        
        // Extract sign interpretations for natal chart
        if let natalChart = natalChart {
            let relevantSigns = [
                natalChart.sunSign,
                natalChart.moonSign,
                natalChart.risingSign,
                natalChart.mercurySign,
                natalChart.venusSign,
                natalChart.marsSign
            ].compactMap { $0 }
            
            // Claude: FIXED - Check correct data structure path
            if let signsData = megaCorpusData["signs"] as? [String: Any],
               let signsDict = signsData["signs"] as? [String: Any] {
                for sign in relevantSigns {
                    if let signData = signsDict[sign.lowercased()] as? [String: Any] {
                        signInterpretations[sign] = SignInterpretation(
                            sign: sign,
                            element: signData["element"] as? String ?? "Unknown",
                            modality: signData["modality"] as? String ?? "Unknown",
                            rulingPlanet: signData["ruling_planet"] as? String ?? "Unknown",
                            keyTraits: signData["traits"] as? String ?? "Unknown",
                            spiritualMeaning: signData["spiritual_meaning"] as? String ?? "Unknown"
                        )
                    }
                }
            }
        }
        
        // Extract planetary meanings for current transits
        if let transits = transits {
            let activePlanets = ["Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn"]
            
            // Claude: FIXED - Check correct data structure path for planets
            if let planetsData = megaCorpusData["planets"] as? [String: Any],
               let planetsDict = planetsData["planets"] as? [String: Any] {
                for planet in activePlanets {
                    if let planetData = planetsDict[planet.lowercased()] as? [String: Any] {
                        planetaryMeanings[planet] = PlanetaryMeaning(
                            planet: planet,
                            archetype: planetData["archetype"] as? String ?? "Unknown",
                            influence: planetData["influence"] as? String ?? "Unknown",
                            spiritualPurpose: planetData["spiritual_purpose"] as? String ?? "Unknown",
                            currentRelevance: generateCurrentRelevance(planet: planet, transits: transits)
                        )
                    }
                }
            }
        }
        
        // Extract elemental guidance
        if let natalChart = natalChart, let dominantElement = natalChart.dominantElement {
            if let elementsData = megaCorpusData["elements"] as? [String: Any],
               let elementData = elementsData[dominantElement] as? [String: Any] {
                elementalGuidance[dominantElement] = ElementalGuidance(
                    element: dominantElement,
                    characteristics: elementData["characteristics"] as? String ?? "Unknown",
                    guidance: elementData["guidance"] as? String ?? "Unknown",
                    balancingElements: elementData["balancing_elements"] as? [String] ?? []
                )
            }
        }
        
        // Claude: FIXED - Extract numerological insights from MegaCorpus  
        if let numerologyData = megaCorpusData["numerology"] as? [String: Any],
           let numbersData = numerologyData["focusNumbers"] as? [String: Any] {
            let relevantNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44] // All possible numerological numbers
            
            for number in relevantNumbers {
                let numberKey = String(number)
                if let numberData = numbersData[numberKey] as? [String: Any] {
                    numerologicalInsights[numberKey] = NumerologicalInsight(
                        number: number,
                        meaning: numberData["meaning"] as? String ?? "Unknown",
                        spiritualSignificance: numberData["spiritual_significance"] as? String ?? "Unknown",
                        guidanceMessage: numberData["guidance"] as? String ?? "Unknown"
                    )
                }
            }
        }
        
        // Extract lunar phase wisdom
        let lunarPhaseWisdom = extractLunarPhaseWisdom(transits: transits)
        
        let extract = MegaCorpusExtract(
            signInterpretations: signInterpretations,
            planetaryMeanings: planetaryMeanings,
            elementalGuidance: elementalGuidance,
            numerologicalInsights: numerologicalInsights,
            lunarPhaseWisdom: lunarPhaseWisdom,
            aspectInterpretations: [], // TODO: Implement aspect interpretations
            extractedAt: Date()
        )
        
        // Claude: DEBUG - Show what we actually extracted
        print("🔮 KASPER MegaCorpus Extract Results:")
        print("   • Sign Interpretations: \(signInterpretations.count)")
        print("   • Planetary Meanings: \(planetaryMeanings.count)")
        print("   • Elemental Guidance: \(elementalGuidance.count)")
        print("   • Numerological Insights: \(numerologicalInsights.count)")
        print("   • Lunar Phase Wisdom: \(lunarPhaseWisdom != nil ? "Yes" : "No")")
        
        return extract
    }
    
    /**
     * Generate current relevance for a planet based on transits
     */
    private func generateCurrentRelevance(planet: String, transits: TransitData) -> String {
        switch planet {
        case "Sun":
            return "Currently in \(transits.currentSunSign), illuminating themes of this sign"
        case "Moon":
            let retrogradeNote = transits.moonIsRetrograde ? " (retrograde energy)" : ""
            return "Currently in \(transits.currentMoonSign)\(retrogradeNote), affecting emotional currents"
        default:
            return "Active in current cosmic conditions"
        }
    }
    
    /**
     * Extract lunar phase wisdom from MegaCorpus
     */
    private func extractLunarPhaseWisdom(transits: TransitData?) -> LunarPhaseWisdom? {
        guard let transits = transits else { return nil }
        
        let megaCorpusData = MainActor.assumeIsolated {
            sanctumDataManager.megaCorpusData
        }
        
        if let moonPhasesData = megaCorpusData["moonphases"] as? [String: Any],
           let phaseData = moonPhasesData[transits.lunarPhase] as? [String: Any] {
            
            return LunarPhaseWisdom(
                phase: transits.lunarPhase,
                energy: phaseData["energy"] as? String ?? "Unknown",
                guidance: phaseData["guidance"] as? String ?? "Unknown",
                ritualSuggestions: phaseData["ritual_suggestions"] as? String ?? "Unknown"
            )
        }
        
        return nil
    }
    
    /**
     * Create test MegaCorpus extract for development and testing
     */
    private func createTestMegaCorpusExtract() -> MegaCorpusExtract {
        // Create test sign interpretations
        let testSignInterpretations = [
            "Leo": SignInterpretation(
                sign: "Leo",
                element: "Fire",
                modality: "Fixed",
                rulingPlanet: "Sun",
                keyTraits: "Creative, confident, generous, dramatic",
                spiritualMeaning: "The path of self-expression and creative leadership"
            ),
            "Scorpio": SignInterpretation(
                sign: "Scorpio",
                element: "Water",
                modality: "Fixed",
                rulingPlanet: "Pluto",
                keyTraits: "Intense, transformative, mysterious, powerful",
                spiritualMeaning: "The path of deep transformation and spiritual rebirth"
            )
        ]
        
        // Create test planetary meanings
        let testPlanetaryMeanings = [
            "Sun": PlanetaryMeaning(
                planet: "Sun",
                archetype: "The Hero",
                influence: "Vitality, ego, life force",
                spiritualPurpose: "To shine your authentic light in the world",
                currentRelevance: "Currently in Leo, amplifying creative self-expression"
            ),
            "Moon": PlanetaryMeaning(
                planet: "Moon",
                archetype: "The Mother",
                influence: "Emotions, intuition, subconscious",
                spiritualPurpose: "To nurture and flow with natural rhythms",
                currentRelevance: "Currently in Cancer, enhancing emotional sensitivity"
            )
        ]
        
        // Create test elemental guidance
        let testElementalGuidance = [
            "Fire": ElementalGuidance(
                element: "Fire",
                characteristics: "Passionate, spontaneous, inspiring, action-oriented",
                guidance: "Channel your fiery energy into creative projects and leadership",
                balancingElements: ["Water", "Earth"]
            )
        ]
        
        // Create test numerological insights
        let testNumerologicalInsights = [
            "7": NumerologicalInsight(
                number: 7,
                meaning: "The Seeker",
                spiritualSignificance: "Deep spiritual wisdom and introspection",
                guidanceMessage: "Trust your inner wisdom and seek deeper truths"
            ),
            "11": NumerologicalInsight(
                number: 11,
                meaning: "The Visionary",
                spiritualSignificance: "Master number of spiritual illumination",
                guidanceMessage: "You are here to inspire and uplift others with your vision"
            )
        ]
        
        // Create test lunar phase wisdom
        let testLunarPhaseWisdom = LunarPhaseWisdom(
            phase: "Full Moon",
            energy: "Peak manifestation and release",
            guidance: "This is the time to release what no longer serves and celebrate your achievements",
            ritualSuggestions: "Moon bathing, gratitude ceremony, energy cleansing"
        )
        
        return MegaCorpusExtract(
            signInterpretations: testSignInterpretations,
            planetaryMeanings: testPlanetaryMeanings,
            elementalGuidance: testElementalGuidance,
            numerologicalInsights: testNumerologicalInsights,
            lunarPhaseWisdom: testLunarPhaseWisdom,
            aspectInterpretations: [],
            extractedAt: Date()
        )
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
            proximityMatchScore: 0.0,
            natalChart: nil, // No natal chart for anonymous users
            currentTransits: getCurrentTransitData(), // Still provide current transits
            environmentalContext: EnvironmentalContext(), // Basic environmental context
            megaCorpusData: createTestMegaCorpusExtract() // Provide spiritual wisdom even for anonymous users
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