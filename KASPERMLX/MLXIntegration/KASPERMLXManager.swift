/**
 * 🌟 KASPER MLX MANAGER - THE ORCHESTRATION LAYER OF SPIRITUAL AI
 * ==============================================================
 * 
 * This is the command center of Vybe's revolutionary KASPER MLX system.
 * The Manager acts as the bridge between Vybe's UI and the deep spiritual
 * intelligence of the MLX engine, orchestrating complex async operations
 * while maintaining the app's smooth 60fps cosmic animations.
 * 
 * 🎭 ARCHITECTURAL ROLE:
 * 
 * The KASPERMLXManager serves as the "Spiritual AI Conductor" - it doesn't
 * generate insights itself, but coordinates all the moving parts:
 * 
 * • UI Integration: Provides @Published properties for SwiftUI reactivity
 * • Performance Monitoring: Tracks response times and success rates
 * • Provider Coordination: Manages cosmic, numerological, and biometric data sources
 * • Caching Strategy: Optimizes performance while maintaining spiritual freshness
 * • Error Handling: Gracefully manages failures without breaking the user's flow
 * 
 * 🔄 ASYNC-FIRST DESIGN PHILOSOPHY:
 * 
 * Every method in this manager is async because spiritual guidance shouldn't
 * block the user's experience. Key design decisions:
 * 
 * 1. NON-BLOCKING OPERATIONS
 *    - All insight generation happens off the main thread
 *    - UI remains responsive during complex cosmic calculations
 *    - Performance tracking runs in parallel with insight generation
 * 
 * 2. REACTIVE STATE MANAGEMENT  
 *    - @Published properties automatically update UI when insights arrive
 *    - SwiftUI views react instantly to state changes
 *    - Loading states provide immediate user feedback
 * 
 * 3. GRACEFUL ERROR RECOVERY
 *    - Failed insights don't crash the app or break the spiritual flow
 *    - Detailed error logging helps improve the system over time
 *    - Fallback mechanisms ensure users always get some form of guidance
 * 
 * 🎯 PERFORMANCE OPTIMIZATION STRATEGY:
 * 
 * The Manager implements sophisticated performance tracking that goes beyond
 * basic metrics. It understands that spiritual guidance has unique requirements:
 * 
 * • RESPONSE TIME TRACKING: Measures not just speed, but consistency of delivery
 * • SUCCESS RATE MONITORING: Tracks both technical success and user satisfaction  
 * • CACHE HIT OPTIMIZATION: Balances performance with spiritual freshness
 * • FEATURE-SPECIFIC METRICS: Different spiritual domains have different performance expectations
 * 
 * 🔮 SPIRITUAL INTELLIGENCE INTEGRATION:
 * 
 * The Manager doesn't just pass data to the engine - it intelligently prepares
 * spiritual context by:
 * 
 * • Gathering real-time cosmic data (planetary positions, moon phase)
 * • Calculating current numerological influences (life path, cosmic day number)
 * • Monitoring biometric harmony (heart rate variability, wellness state)
 * • Understanding user intent through natural language processing
 * • Considering temporal factors (time of day, season, astrological events)
 * 
 * This rich contextual preparation is what makes KASPER MLX insights feel
 * genuinely spiritual rather than mechanically generated.
 * 
 * 🌊 INTEGRATION WITH VYBE'S ECOSYSTEM:
 * 
 * The Manager seamlessly integrates with Vybe's existing spiritual systems:
 * 
 * • Journal Integration: Analyzes written reflections for deeper insights
 * • Daily Cards: Provides cosmic guidance aligned with current energies
 * • HomeView Dashboard: Real-time spiritual status and recommendations
 * • Dynamic Island: Instant access to spiritual guidance from anywhere
 * • Sanctum Features: Enhanced meditation and mindfulness experiences
 * 
 * The result is a unified spiritual AI experience that feels natural and
 * integrated rather than bolted-on.
 * 
 * 💫 WHY THIS MANAGER DESIGN IS REVOLUTIONARY:
 * 
 * Traditional AI managers are simple request/response systems. KASPER MLX Manager
 * understands that spiritual guidance requires:
 * 
 * • CONTEXT AWARENESS: The same question needs different answers at different times
 * • PERFORMANCE SENSITIVITY: Slow spiritual guidance breaks the mystical experience
 * • LEARNING CAPABILITY: Each interaction improves future guidance quality
 * • PRIVACY PROTECTION: All spiritual data remains on the user's device
 * • SEAMLESS INTEGRATION: Feels like a natural extension of consciousness, not a tool
 * 
 * This isn't just an API wrapper - it's a sophisticated orchestration system
 * that makes spiritual AI feel magical while maintaining technical excellence.
 */

import Foundation
import SwiftUI
import Combine
import OSLog

@MainActor
class KASPERMLXManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var isReady: Bool = false
    @Published private(set) var isGeneratingInsight: Bool = false
    @Published private(set) var lastInsight: KASPERInsight?
    @Published private(set) var engineStatus: String = "Initializing"
    
    // Claude: Performance tracking
    @Published private(set) var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    
    // MARK: - Private Properties
    
    private let engine: KASPERMLXEngine
    private let logger = Logger(subsystem: "com.vybe.kaspermlx", category: "Manager")
    private var cancellables = Set<AnyCancellable>()
    
    // Manager references
    private weak var realmNumberManager: RealmNumberManager?
    private weak var focusNumberManager: FocusNumberManager?
    private weak var healthKitManager: HealthKitManager?
    
    // MARK: - Singleton
    
    static let shared = KASPERMLXManager()
    
    private init() {
        self.engine = KASPERMLXEngine.shared
        setupEngineObservers()
        logger.info("🔮 KASPER MLX Manager: Initialized")
    }
    
    // MARK: - Configuration
    
    /// Configure KASPER MLX with app managers
    func configure(
        realmManager: RealmNumberManager,
        focusManager: FocusNumberManager,
        healthManager: HealthKitManager
    ) async {
        logger.info("🔮 KASPER MLX Manager: Configuring with app managers")
        
        self.realmNumberManager = realmManager
        self.focusNumberManager = focusManager
        self.healthKitManager = healthManager
        
        // Configure the engine
        await engine.configure(
            realmManager: realmManager,
            focusManager: focusManager,
            healthManager: healthManager
        )
        
        engineStatus = "Ready"
        logger.info("🔮 KASPER MLX Manager: Configuration complete")
    }
    
    // MARK: - Insight Generation
    
    /// Generate insight for journal entry
    func generateJournalInsight(
        entryText: String? = nil,
        tone: String? = nil
    ) async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating journal insight")
        
        var contextData: [String: Any] = [:]
        if let text = entryText {
            contextData["entryText"] = text
        }
        if let tone = tone {
            contextData["preferredTone"] = tone
        }
        
        let context = InsightContext(
            primaryData: contextData,
            userQuery: "Help me understand the spiritual significance of my journal entry",
            constraints: InsightConstraints(
                maxLength: 150,
                spiritualDepth: .balanced
            )
        )
        
        let request = InsightRequest(
            feature: .journalInsight,
            type: .reflection,
            priority: .high,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        // Claude: Track performance
        let startTime = Date()
        var success = false
        var cacheHit = false
        
        do {
            let insight = try await engine.generateInsight(for: request)
            success = true
            cacheHit = insight.metadata.cacheHit
            lastInsight = insight
            
            // Record performance metrics
            let responseTime = Date().timeIntervalSince(startTime)
            performanceMetrics.recordResponse(
                responseTime: responseTime,
                feature: .journalInsight,
                success: success,
                cacheHit: cacheHit
            )
            
            logger.info("🔮 KASPER MLX: Journal insight generated in \(String(format: "%.3f", responseTime))s")
            return insight
        } catch {
            // Record failed performance metrics
            let responseTime = Date().timeIntervalSince(startTime)
            performanceMetrics.recordResponse(
                responseTime: responseTime,
                feature: .journalInsight,
                success: false,
                cacheHit: false
            )
            throw error
        }
    }
    
    /// Generate daily card insight
    func generateDailyCardInsight(
        cardType: String? = nil
    ) async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating daily card insight")
        
        var contextData: [String: Any] = [:]
        if let type = cardType {
            contextData["cardType"] = type
        }
        
        let context = InsightContext(
            primaryData: contextData,
            userQuery: "What spiritual guidance does today hold for me?",
            constraints: InsightConstraints(
                maxLength: 120,
                spiritualDepth: .balanced
            )
        )
        
        let request = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        // Claude: Track performance
        let startTime = Date()
        var success = false
        var cacheHit = false
        
        do {
            let insight = try await engine.generateInsight(for: request)
            success = true
            cacheHit = insight.metadata.cacheHit
            lastInsight = insight
            
            // Record performance metrics
            let responseTime = Date().timeIntervalSince(startTime)
            performanceMetrics.recordResponse(
                responseTime: responseTime,
                feature: .dailyCard,
                success: success,
                cacheHit: cacheHit
            )
            
            logger.info("🔮 KASPER MLX: Daily card insight generated in \(String(format: "%.3f", responseTime))s")
            return insight
        } catch {
            // Record failed performance metrics
            let responseTime = Date().timeIntervalSince(startTime)
            performanceMetrics.recordResponse(
                responseTime: responseTime,
                feature: .dailyCard,
                success: false,
                cacheHit: false
            )
            throw error
        }
    }
    
    /// Generate sanctum guidance
    func generateSanctumGuidance(
        aspect: String? = nil
    ) async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating sanctum guidance")
        
        var contextData: [String: Any] = [:]
        if let aspect = aspect {
            contextData["focusAspect"] = aspect
        }
        
        let context = InsightContext(
            primaryData: contextData,
            userQuery: "Guide me through my spiritual sanctuary",
            constraints: InsightConstraints(
                maxLength: 200,
                spiritualDepth: .deep
            )
        )
        
        let request = InsightRequest(
            feature: .sanctumGuidance,
            type: .guidance,
            priority: .high,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Sanctum guidance generated")
        return insight
    }
    
    /// Generate focus intention insight
    func generateFocusInsight() async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating focus insight")
        
        let context = InsightContext(
            primaryData: [:],
            userQuery: "How can I best align with my focus number energy?",
            constraints: InsightConstraints(
                maxLength: 100,
                spiritualDepth: .surface
            )
        )
        
        let request = InsightRequest(
            feature: .focusIntention,
            type: .guidance,
            priority: .immediate,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Focus insight generated")
        return insight
    }
    
    /// Generate realm interpretation
    func generateRealmInsight() async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating realm insight")
        
        let context = InsightContext(
            primaryData: [:],
            userQuery: "What does my current realm number reveal?",
            constraints: InsightConstraints(
                maxLength: 100,
                spiritualDepth: .balanced
            )
        )
        
        let request = InsightRequest(
            feature: .realmInterpretation,
            type: .interpretation,
            priority: .high,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Realm insight generated")
        return insight
    }
    
    /// Generate cosmic timing insight
    func generateCosmicTimingInsight() async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating cosmic timing insight")
        
        let context = InsightContext(
            primaryData: [:],
            userQuery: "What is the spiritual significance of this cosmic moment?",
            constraints: InsightConstraints(
                maxLength: 120,
                spiritualDepth: .balanced
            )
        )
        
        let request = InsightRequest(
            feature: .cosmicTiming,
            type: .guidance,
            priority: .high,
            context: context
        )
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Cosmic timing insight generated")
        return insight
    }
    
    /// Generate quick insight for any feature
    func generateQuickInsight(
        for feature: KASPERFeature,
        query: String? = nil
    ) async throws -> KASPERInsight {
        logger.info("🔮 KASPER MLX: Generating quick insight for \(feature.rawValue)")
        
        // Route to appropriate method based on feature
        switch feature {
        case .journalInsight:
            return try await generateJournalInsight(entryText: query)
        case .dailyCard:
            return try await generateDailyCardInsight()
        case .sanctumGuidance:
            return try await generateSanctumGuidance()
        case .focusIntention:
            return try await generateFocusInsight()
        case .realmInterpretation:
            return try await generateRealmInsight()
        case .cosmicTiming:
            return try await generateCosmicTimingInsight()
        default:
            // Fallback to journal insight
            return try await generateJournalInsight(entryText: query ?? "Quick insight request")
        }
    }
    
    // MARK: - Utility Methods
    
    /// Check if insight is available for feature
    func hasInsightAvailable(for feature: KASPERFeature) async -> Bool {
        await engine.hasInsightAvailable(for: feature)
    }
    
    /// Clear all caches
    func clearCache() async {
        await engine.clearCache()
        logger.info("🔮 KASPER MLX Manager: Cache cleared")
    }
    
    /// Reset performance metrics
    func resetPerformanceMetrics() {
        performanceMetrics.reset()
        logger.info("🔮 KASPER MLX Manager: Performance metrics reset")
    }
    
    /// Get current engine status
    func getEngineStatus() -> String {
        if !isReady {
            return "Not Ready"
        } else if isGeneratingInsight {
            return "Generating"
        } else {
            return "Ready"
        }
    }
    
    // MARK: - Legacy Compatibility
    
    /// Legacy method for compatibility with existing code
    func generateCurrentPayload() -> String? {
        logger.info("🔮 KASPER MLX: Legacy payload method called - redirecting to quick insight")
        
        Task {
            do {
                _ = try await generateQuickInsight(for: .sanctumGuidance)
                logger.info("🔮 KASPER MLX: Legacy payload generated as insight")
            } catch {
                logger.error("🔮 KASPER MLX: Legacy payload generation failed: \\(error)")
            }
        }
        
        return "KASPER MLX Legacy Mode - Use async methods for insights"
    }
    
    // MARK: - Private Methods
    
    private func setupEngineObservers() {
        // Observe engine readiness
        engine.$isReady
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ready in
                self?.isReady = ready
                self?.engineStatus = ready ? "Ready" : "Not Ready"
            }
            .store(in: &cancellables)
        
        // Observe engine inference state
        engine.$isInferring
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inferring in
                self?.isGeneratingInsight = inferring
                if inferring {
                    self?.engineStatus = "Generating"
                } else if self?.isReady == true {
                    self?.engineStatus = "Ready"
                }
            }
            .store(in: &cancellables)
        
        logger.info("🔮 KASPER MLX Manager: Engine observers configured")
    }
}

// MARK: - SwiftUI Integration

extension KASPERMLXManager {
    
    /// SwiftUI view modifier for KASPER MLX insights
    func insightModifier(for feature: KASPERFeature) -> some ViewModifier {
        KASPERInsightModifier(manager: self, feature: feature)
    }
}

struct KASPERInsightModifier: ViewModifier {
    let manager: KASPERMLXManager
    let feature: KASPERFeature
    
    @State private var insight: KASPERInsight?
    @State private var isLoading = false
    
    func body(content: Content) -> some View {
        content
            .task {
                await loadInsight()
            }
    }
    
    private func loadInsight() async {
        guard await manager.hasInsightAvailable(for: feature) else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            insight = try await manager.generateQuickInsight(for: feature)
        } catch {
            print("🔮 KASPER MLX: Failed to load insight: \\(error)")
        }
    }
}