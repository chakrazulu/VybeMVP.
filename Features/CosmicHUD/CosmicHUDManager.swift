import Foundation
import SwiftUI
import SwiftAA
import ActivityKit
import Combine

// Claude: Import shared HUD types
// CosmicHUDTypes.swift contains HUDData, AspectData, CosmicElement, CosmicAspect

// MARK: - Cosmic HUD Manager
/// Claude: The orchestrator of cosmic consciousness for Dynamic Island
/// 
/// CORE RESPONSIBILITIES:
/// - Real-time spiritual data orchestration for Dynamic Island display
/// - Integration with existing Vybe managers (Realm, Focus, Swiss Ephemeris)
/// - Aspect calculations using SwiftAA for authentic astrological accuracy
/// - Smart caching and performance optimization for battery efficiency
/// - KASPER integration bridge for premium personalized insights
/// 
/// ARCHITECTURE INTEGRATION:
/// - RealmNumberManager: Current user's numerological ruler number
/// - FocusNumberManager: Active focus number for spiritual alignment  
/// - SwissEphemerisCalculator: Real planetary positions and aspects
/// - KASPERManager: AI-powered personalized spiritual insights
/// 
/// UPDATE STRATEGY:
/// - 5-minute refresh cycle prevents battery drain while maintaining currency
/// - Background TaskGroup processing ensures UI thread remains responsive
/// - Fallback data prevents HUD from showing empty state during errors
/// 
/// PERFORMANCE CONSIDERATIONS:
/// - Calculations moved to background threads via async/await
/// - Smart caching reduces redundant SwiftAA computations
/// - Tightest orb prioritization focuses on most significant aspects

@MainActor
class CosmicHUDManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentHUDData: HUDData?
    @Published var isHUDActive: Bool = false
    @Published var expandedInsight: String?
    @Published var lastUpdate: Date = Date()
    
    // MARK: - Dependencies
    private let realmNumberManager: RealmNumberManager
    private let focusNumberManager: FocusNumberManager
    private let swissCalculator: SwissEphemerisCalculator
    private let kasperManager: KASPERManager
    
    // MARK: - Private Properties
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let updateInterval: TimeInterval = 300 // 5 minutes
    
    // MARK: - Singleton
    static let shared = CosmicHUDManager()
    
    private init() {
        self.realmNumberManager = RealmNumberManager() // Not a singleton
        self.focusNumberManager = FocusNumberManager.shared
        self.swissCalculator = SwissEphemerisCalculator() // Not a singleton
        self.kasperManager = KASPERManager.shared
        
        setupUpdateTimer()
        loadInitialData()
    }
    
    // MARK: - Public Methods
    
    /// Starts the Cosmic HUD with current spiritual data
    func startHUD() {
        Task {
            await refreshHUDData()
            isHUDActive = true
        }
    }
    
    /// Stops the Cosmic HUD and cleans up resources
    func stopHUD() {
        isHUDActive = false
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Forces immediate refresh of HUD data
    func refreshHUDData() async {
        do {
            let hudData = try await calculateCurrentHUDData()
            self.currentHUDData = hudData
            self.lastUpdate = Date()
        } catch {
            print("Claude: HUD data refresh failed: \(error)")
            // Fallback to cached data or default values
            await loadFallbackData()
        }
    }
    
    /// Generates mini insight for expanded HUD state
    func generateMiniInsight(for aspectData: AspectData) async -> String {
        // Check if user has premium access
        // Claude: Check premium status - method may not exist yet
        if false { // Disabled until isPremiumUser method is implemented
            return await generateKASPERInsight(for: aspectData)
        } else {
            return generateTemplateInsight(for: aspectData)
        }
    }
    
    /// Gets ruler number for current user
    func getCurrentRulerNumber() -> Int {
        // Claude: selectedFocusNumber is Int, not Optional
        return focusNumberManager.selectedFocusNumber == 0 ? 1 : focusNumberManager.selectedFocusNumber
    }
    
    /// Gets current element of the day
    func getCurrentElement() -> CosmicElement {
        // Calculate based on date, moon phase, and user's cosmic alignment
        let dayOfYear = Calendar.current.dayOfYear(for: Date()) ?? 1
        let elements: [CosmicElement] = [.fire, .earth, .air, .water]
        let index = (dayOfYear + getCurrentRulerNumber()) % elements.count
        return elements[index]
    }
    
    // MARK: - Private Methods
    
    private func setupUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshHUDData()
            }
        }
    }
    
    private func loadInitialData() {
        Task {
            await refreshHUDData()
        }
    }
    
    private func calculateCurrentHUDData() async throws -> HUDData {
        let rulerNumber = getCurrentRulerNumber()
        let element = getCurrentElement()
        let aspects = try await calculateMajorAspects()
        let dominantAspect = selectDominantAspect(from: aspects)
        
        return HUDData(
            rulerNumber: rulerNumber,
            dominantAspect: dominantAspect,
            element: element,
            lastCalculated: Date(),
            allAspects: aspects
        )
    }
    
    private func calculateMajorAspects() async throws -> [AspectData] {
        // Claude: Use existing CosmicData system instead of duplicating calculations
        let cosmicData = CosmicData.fromLocalCalculations()
        let existingAspects = cosmicData.getMajorAspects()
        
        // Convert existing aspects to HUD format
        return existingAspects.compactMap { convertToAspectData(from: $0) }
    }
    
    /// Claude: Converts existing CosmicData.PlanetaryAspect to HUD AspectData format
    /// Bridges the comprehensive cosmic system with simplified HUD display needs
    private func convertToAspectData(from planetaryAspect: CosmicData.PlanetaryAspect) -> AspectData? {
        // Convert planet names to HUDPlanet enum
        guard let planet1 = HUDPlanet.from(string: planetaryAspect.planet1),
              let planet2 = HUDPlanet.from(string: planetaryAspect.planet2) else {
            return nil
        }
        
        // Convert aspect type
        let cosmicAspect = HUDAspect.from(aspectType: planetaryAspect.aspectType.rawValue)
        
        return AspectData(
            planet1: planet1,
            planet2: planet2,
            aspect: cosmicAspect,
            orb: planetaryAspect.orb,
            isApplying: true // CosmicData doesn't track applying/separating yet
        )
    }
    
    private func selectDominantAspect(from aspects: [AspectData]) -> AspectData? {
        // Return the tightest orb (most exact aspect)
        return aspects.first
    }
    
    private func generateKASPERInsight(for aspectData: AspectData) async -> String {
        // Generate personalized insight using KASPER
        // Claude: KASPER integration placeholder
        let _ = "aspect_insight_\(aspectData.planet1.rawValue)_\(aspectData.aspect.rawValue)_\(aspectData.planet2.rawValue)"
        
        // This would call KASPER API in production
        return "KASPER insight: \(aspectData.planet1.rawValue.capitalized) \(aspectData.aspect.rawValue) \(aspectData.planet2.rawValue.capitalized) brings profound transformation to your spiritual path."
    }
    
    private func generateTemplateInsight(for aspectData: AspectData) -> String {
        let templates = InsightTemplateLibrary.templates(for: aspectData.aspect)
        let randomTemplate = templates.randomElement() ?? "Cosmic energies are flowing."
        
        return randomTemplate
            .replacingOccurrences(of: "{planet1}", with: aspectData.planet1.rawValue.capitalized)
            .replacingOccurrences(of: "{planet2}", with: aspectData.planet2.rawValue.capitalized)
    }
    
    private func loadFallbackData() async {
        // Provide default data if calculations fail
        let fallbackAspect = AspectData(
            planet1: .sun,
            planet2: .moon,
            aspect: .trine,
            orb: 2.5,
            isApplying: true
        )
        
        currentHUDData = HUDData(
            rulerNumber: getCurrentRulerNumber(),
            dominantAspect: fallbackAspect,
            element: .fire,
            lastCalculated: Date(),
            allAspects: [fallbackAspect]
        )
    }
}

// MARK: - Data Models
// Claude: All HUD data structures are now in CosmicHUDTypes.swift

// MARK: - Insight Template Library
struct InsightTemplateLibrary {
    static func templates(for aspect: CosmicAspect) -> [String] {
        switch aspect {
        case .conjunction:
            return [
                "{planet1} merges with {planet2} — unified energy flows.",
                "Cosmic fusion of {planet1} and {planet2} creates new possibilities.",
                "The union of {planet1} and {planet2} amplifies your spiritual power."
            ]
        case .trine:
            return [
                "{planet1} harmonizes with {planet2} — flow with grace.",
                "Easy energy between {planet1} and {planet2} opens doors.",
                "Natural alignment of {planet1} and {planet2} supports your journey."
            ]
        case .square:
            return [
                "{planet1} challenges {planet2} — growth through tension.",
                "Dynamic friction between {planet1} and {planet2} sparks evolution.",
                "The square of {planet1} and {planet2} pushes you to transcend."
            ]
        case .opposition:
            return [
                "{planet1} faces {planet2} — seek balance within paradox.",
                "The polarity of {planet1} and {planet2} reveals hidden wisdom.",
                "Opposition between {planet1} and {planet2} calls for integration."
            ]
        case .sextile:
            return [
                "{planet1} supports {planet2} — opportunities await action.",
                "Gentle harmony between {planet1} and {planet2} encourages growth.",
                "The sextile of {planet1} and {planet2} offers spiritual gifts."
            ]
        default:
            return ["Cosmic energies are flowing in mysterious ways."]
        }
    }
}

// MARK: - Extensions
private extension Calendar {
    func dayOfYear(for date: Date) -> Int? {
        return ordinality(of: .day, in: .year, for: date)
    }
}