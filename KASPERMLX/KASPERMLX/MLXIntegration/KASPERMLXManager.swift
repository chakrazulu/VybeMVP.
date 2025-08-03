/**
 * KASPER MLX Manager
 * 
 * Main integration point between the app and KASPER MLX engine.
 * Replaces the old monolithic KASPERManager with a modern,
 * async-first architecture optimized for MLX inference.
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
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Journal insight generated")
        return insight
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
        
        let insight = try await engine.generateInsight(for: request)
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Daily card insight generated")
        return insight
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
        logger.info("🔮 KASPER MLX: Generating quick insight for \\(feature)")
        
        isGeneratingInsight = true
        defer { isGeneratingInsight = false }
        
        let insight = try await engine.generateQuickInsight(
            for: feature,
            query: query
        )
        
        lastInsight = insight
        
        logger.info("🔮 KASPER MLX: Quick insight generated")
        return insight
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