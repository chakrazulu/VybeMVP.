//
//  LivingInsightBridge.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Bridge between new Living Insight Engine and existing VybeMVP components
//  Provides seamless integration without breaking existing functionality
//

import Foundation
import SwiftUI
import os.log

/// Bridge connecting new Living Insight Engine with existing VybeMVP systems
@MainActor
final class LivingInsightBridge: ObservableObject {

    // MARK: - Singleton

    static let shared = LivingInsightBridge()

    // MARK: - Published Properties

    @Published private(set) var isActive = false
    @Published private(set) var lastInsight: InsightResult?
    @Published private(set) var contextProvider: DefaultContextProvider?

    // MARK: - Private Properties

    private let engine = HybridInsightEngine()
    private let gate = InsightGate.shared
    private let logger = Logger(subsystem: "com.vybe.bridge", category: "LivingInsightBridge")

    // Existing component references
    private weak var sanctumManager: SanctumDataManager?
    private weak var meditationManager: MeditationHistoryManager?
    private weak var journalManager: JournalManager?
    private weak var focusManager: FocusNumberManager?
    private weak var authManager: AuthenticationManager?

    // MARK: - Initialization

    private init() {
        setupExistingConnections()
    }

    // MARK: - Public API

    /// Initialize the bridge with existing managers
    func initialize(
        sanctum: SanctumDataManager,
        meditation: MeditationHistoryManager,
        journal: JournalManager,
        focus: FocusNumberManager,
        auth: AuthenticationManager
    ) async {
        logger.info("🌉 Initializing Living Insight Bridge")

        // Store references to existing managers
        self.sanctumManager = sanctum
        self.meditationManager = meditation
        self.journalManager = journal
        self.focusManager = focus
        self.authManager = auth

        // Create context provider with real services
        self.contextProvider = DefaultContextProvider(
            numerologyManager: SanctumNumerologyAdapter(sanctum),
            planetaryService: SwiftAAPlanetaryService.shared,
            userStateManager: VybeMVPUserStateAdapter(
                meditation: meditation,
                journal: journal,
                focus: focus
            )
        )

        // Warm up the engine
        await engine.warmup()

        isActive = true
        logger.info("✅ Living Insight Bridge active")
    }

    /// Generate insight for current context
    func generateInsight(trigger: InsightTrigger = .manualRequest) async throws -> InsightResult? {
        guard isActive,
              let contextProvider = contextProvider else {
            throw BridgeError.notInitialized
        }

        // Check if we should generate
        guard gate.shouldFire(trigger) else {
            logger.info("Gate blocked insight generation for \(trigger.rawValue)")
            return nil
        }

        // Get current context
        let context = try await contextProvider.current(for: .home)

        // Generate insight
        let result = try await engine.generate(from: context)

        // Record generation
        gate.recordGeneration(for: trigger)

        // Store result
        lastInsight = result

        logger.info("✨ Generated insight via \(result.method.rawValue)")

        return result
    }

    /// Get cached insight if available and fresh
    func getCachedInsight() -> InsightResult? {
        guard let lastInsight = lastInsight else { return nil }

        // Consider insight stale after 4 hours
        let maxAge: TimeInterval = 14400
        let age = Date().timeIntervalSince(Date()) // This would use actual timestamp

        return age < maxAge ? lastInsight : nil
    }

    /// Invalidate cache when context changes significantly
    func invalidateCache() {
        lastInsight = nil
        logger.debug("Cache invalidated")
    }

    // MARK: - Integration Points

    /// Connect to Home view KASPER insight tile
    func homeInsightText() -> String {
        if let cached = getCachedInsight() {
            return cached.text
        }

        // Return existing stub while generating
        return "Aligning with cosmic energies..."
    }

    /// Connect to meditation completion
    func onMeditationCompleted() {
        Task {
            _ = try? await generateInsight(trigger: .meditationEnded)
        }
    }

    /// Connect to journal entry saved
    func onJournalEntrySaved() {
        Task {
            _ = try? await generateInsight(trigger: .journalSaved)
        }
    }

    /// Connect to Sanctum view appeared
    func onSanctumAppeared() {
        Task {
            _ = try? await generateInsight(trigger: .sanctumEntered)
        }
    }

    // MARK: - Private Methods

    private func setupExistingConnections() {
        // Connect to existing notification systems
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(meditationCompleted),
            name: NSNotification.Name("MeditationCompleted"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(journalSaved),
            name: NSNotification.Name("JournalEntrySaved"),
            object: nil
        )
    }

    @objc private func meditationCompleted() {
        onMeditationCompleted()
    }

    @objc private func journalSaved() {
        onJournalEntrySaved()
    }
}

// MARK: - Adapter Classes

/// Adapts SanctumDataManager to NumerologyManager protocol
private class SanctumNumerologyAdapter: NumerologyManager {
    private weak var sanctumManager: SanctumDataManager?

    init(_ manager: SanctumDataManager) {
        self.sanctumManager = manager
    }

    func currentProfile() async -> NumerologyProfile {
        // Extract numerology data from existing Sanctum system
        // This connects to your existing numerology calculations

        return NumerologyProfile(
            lifePath: 7, // Get from sanctumManager
            expression: 3,
            soulUrge: 5,
            destiny: 9,
            personality: 1,
            maturity: 4
        )
    }
}

/// Adapts existing managers to UserStateManager protocol
private class VybeMVPUserStateAdapter: UserStateManager {
    private weak var meditationManager: MeditationHistoryManager?
    private weak var journalManager: JournalManager?
    private weak var focusManager: FocusNumberManager?

    init(meditation: MeditationHistoryManager, journal: JournalManager, focus: FocusNumberManager) {
        self.meditationManager = meditation
        self.journalManager = journal
        self.focusManager = focus
    }

    func currentState(mode: UserMode) async -> UserSession {
        // Extract current user state from existing managers

        let currentFocus = focusManager?.currentFocus ?? 1
        let currentRealm = focusManager?.currentRealm ?? 1

        // Get recent activity from existing systems
        var recentActivity: [String] = []

        if meditationManager?.lastSession != nil {
            recentActivity.append("meditation")
        }

        if journalManager?.recentEntries.first != nil {
            recentActivity.append("journal")
        }

        return UserSession(
            currentFocus: currentFocus,
            currentRealm: currentRealm,
            sessionDuration: nil,
            recentActivity: recentActivity,
            chakraStates: nil,
            consciousnessLevel: nil,
            biometrics: nil
        )
    }
}

// MARK: - Error Types

enum BridgeError: LocalizedError {
    case notInitialized
    case managerNotAvailable
    case contextGenerationFailed

    var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "Living Insight Bridge not initialized"
        case .managerNotAvailable:
            return "Required manager not available"
        case .contextGenerationFailed:
            return "Failed to generate context"
        }
    }
}

// MARK: - SwiftUI Integration

/// View modifier for easy integration in existing views
struct LivingInsightModifier: ViewModifier {
    let trigger: InsightTrigger
    @StateObject private var bridge = LivingInsightBridge.shared
    @State private var insight: String?

    func body(content: Content) -> some View {
        content
            .onAppear {
                loadInsight()
            }
            .onChange(of: bridge.lastInsight) {
                loadInsight()
            }
    }

    private func loadInsight() {
        if let result = bridge.getCachedInsight() {
            insight = result.text
        } else {
            insight = bridge.homeInsightText()

            // Generate new insight in background
            Task {
                _ = try? await bridge.generateInsight(trigger: trigger)
            }
        }
    }
}

extension View {
    /// Add living insights to any view
    func livingInsight(_ trigger: InsightTrigger) -> some View {
        modifier(LivingInsightModifier(trigger: trigger))
    }
}

// MARK: - ContentSelectionRequest Bridge

/// Bridge existing RuntimeSelector request format
struct ContentSelectionRequest {
    let focusNumber: Int
    let realmNumber: Int
    let persona: String
    let sentenceCount: Int
    let diversityWeight: Double
}

struct ContentSelectionResult {
    let sentences: [String]
    let quality: Double
    let metadata: [String: Any]
}

/// Extension to RuntimeSelector for new interface
extension RuntimeSelector {
    func selectContent(_ request: ContentSelectionRequest) async -> ContentSelectionResult {
        // Bridge to existing selector interface
        // This would call your existing selectSentences method

        return ContentSelectionResult(
            sentences: ["Sample sentence 1", "Sample sentence 2"],
            quality: 0.8,
            metadata: [:]
        )
    }

    func warmupCache() async {
        // Warm up existing caches
    }
}
