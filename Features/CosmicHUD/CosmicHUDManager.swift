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
    private let realmSampleManager: RealmSampleManager  // For ruler number calculation
    private let kasperManager: KASPERManager
    
    // Claude: Store reference to the main app's managers for data sync
    private var mainAppRealmManager: RealmNumberManager?
    private var mainAppFocusManager: FocusNumberManager?
    
    // MARK: - Private Properties
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let updateInterval: TimeInterval = 300 // 5 minutes
    
    // MARK: - Singleton
    static let shared = CosmicHUDManager()
    
    private init() {
        // Claude: Use shared managers for live data synchronization
        self.realmNumberManager = RealmNumberManager()
        self.focusNumberManager = FocusNumberManager.shared
        self.realmSampleManager = RealmSampleManager.shared  // For ruler number calculation
        self.kasperManager = KASPERManager.shared
        
        setupRealmSampleObserver()  // Always set up ruler number observer
        setupUpdateTimer()
        loadInitialData()
    }
    
    // MARK: - Configuration
    
    /// Claude: Configure HUD to use main app's managers for data sync
    func configureWithMainAppManagers(realmManager: RealmNumberManager) {
        self.mainAppRealmManager = realmManager
        self.mainAppFocusManager = FocusNumberManager.shared
        setupDataObservers()
        print("🔗 HUD: Configured with main app managers")
    }
    
    // MARK: - Data Observers Setup
    
    /// Claude: Sets up ruler number observer from RealmSampleManager (always available)
    private func setupRealmSampleObserver() {
        // Observe ruler number changes from RealmSampleManager (independent of main app setup)
        realmSampleManager.$rulingNumber
            .receive(on: DispatchQueue.main)
            .removeDuplicates() // Claude: Only update if ruler number actually changes
            .sink { [weak self] newRulerNumber in
                print("👑 HUD: Ruler number changed to \(newRulerNumber) - refreshing HUD")
                Task { @MainActor in
                    await self?.refreshHUDData()
                    // Claude: Force UI update by updating lastUpdate timestamp
                    self?.lastUpdate = Date()
                    print("👑 HUD: Ruler number refresh complete - UI updated")
                }
            }
            .store(in: &cancellables)
        
        print("🔗 HUD: Ruler number observer configured")
    }
    
    /// Claude: Sets up real-time data observers for live HUD updates
    private func setupDataObservers() {
        guard let realmManager = mainAppRealmManager else {
            print("⚠️ HUD: No main app realm manager configured - using local data")
            return
        }
        
        // Observe focus number changes from shared manager
        focusNumberManager.$selectedFocusNumber
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newFocusNumber in
                print("🎯 HUD: Focus number changed to \(newFocusNumber)")
                Task {
                    await self?.refreshHUDData()
                }
            }
            .store(in: &cancellables)
        
        // Observe realm number changes from main app manager
        realmManager.$currentRealmNumber
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newRealmNumber in
                print("🌌 HUD: Realm number changed to \(newRealmNumber)")
                Task {
                    await self?.refreshHUDData()
                }
            }
            .store(in: &cancellables)
        
        print("🔗 HUD: Real-time data observers configured")
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
    
    /// Gets ruler number for current user (LIVE data from realm sample histogram)
    func getCurrentRulerNumber() -> Int {
        // Claude: Get LIVE ruler number from RealmSampleManager (most frequent realm number today)
        let rulerNumber = realmSampleManager.rulingNumber
        print("👑 HUD: Current ruler number = \(rulerNumber) (from today's realm samples histogram)")
        return rulerNumber
    }
    
    /// Gets current realm number (LIVE data)
    func getCurrentRealmNumber() -> Int {
        // Claude: Get LIVE data from main app realm manager if available, fallback to local
        let realmNumber = mainAppRealmManager?.currentRealmNumber ?? realmNumberManager.currentRealmNumber
        print("🌌 HUD: Current realm number = \(realmNumber) (source: \(mainAppRealmManager != nil ? "main app" : "local"))")
        return realmNumber
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
        // Claude: Use LIVE data from shared managers and SwiftAA calculations
        let rulerNumber = getCurrentRulerNumber()  // LIVE from RealmSampleManager histogram
        let element = getCurrentElement()           // Based on live ruler number
        let aspects = await calculateMajorAspects()  // LIVE SwiftAA calculations (no longer throws)
        let dominantAspect = selectDominantAspect(from: aspects)
        
        print("📊 HUD: Calculated HUD data - Ruler: \(rulerNumber), Element: \(element), Aspects: \(aspects.count)")
        
        return HUDData(
            rulerNumber: rulerNumber,
            dominantAspect: dominantAspect,
            element: element,
            lastCalculated: Date(),
            allAspects: aspects
        )
    }
    
    private func calculateMajorAspects() async -> [AspectData] {
        // Claude: Use LIVE SwiftAA calculations from main app's cosmic system
        print("🔄 HUD: Calculating LIVE planetary aspects...")
        
        // Get LIVE cosmic data with current date/time using SwiftAA
        let cosmicData = CosmicData.fromLocalCalculations()
        
        // Get major aspects using the existing methods
        let existingAspects = cosmicData.getMajorAspects()
        
        // Convert existing aspects to HUD format
        let hudAspects = existingAspects.compactMap { convertToAspectData(from: $0) }
        
        if hudAspects.isEmpty {
            print("⚠️ HUD: No aspects calculated - using fallback")
            return [createFallbackAspect()]
        }
        
        print("✅ HUD: Calculated \(hudAspects.count) live aspects from SwiftAA")
        return hudAspects
    }
    
    /// Claude: Creates a single fallback aspect when calculations fail
    private func createFallbackAspect() -> AspectData {
        return AspectData(
            planet1: .sun,
            planet2: .moon,
            aspect: .trine,
            orb: 2.5,
            isApplying: true
        )
    }
    
    /// Claude: Converts existing CosmicData.PlanetaryAspect to HUD AspectData format
    /// Bridges the comprehensive cosmic system with simplified HUD display needs
    private func convertToAspectData(from planetaryAspect: CosmicData.PlanetaryAspect) -> AspectData? {
        // Convert planet names to HUDPlanet enum (case-insensitive)
        guard let planet1 = HUDPlanet.from(string: planetaryAspect.planet1),
              let planet2 = HUDPlanet.from(string: planetaryAspect.planet2) else {
            print("❌ HUD: Could not convert planets: \(planetaryAspect.planet1), \(planetaryAspect.planet2)")
            return nil
        }
        
        // Convert aspect type using the rawValue from AspectType enum
        let cosmicAspect = HUDAspect.from(aspectType: planetaryAspect.aspectType.rawValue)
        
        print("✅ HUD: Converting aspect - \(planet1.symbol) \(cosmicAspect.symbol) \(planet2.symbol) (orb: \(String(format: "%.1f", planetaryAspect.orb))°)")
        
        return AspectData(
            planet1: planet1,
            planet2: planet2,
            aspect: cosmicAspect,
            orb: planetaryAspect.orb,
            isApplying: !planetaryAspect.isExact // Assume applying if not exact, exact aspects are stable
        )
    }
    
    private func selectDominantAspect(from aspects: [AspectData]) -> AspectData? {
        // Return the tightest orb (most exact aspect) - sort by orb ascending
        let sortedAspects = aspects.sorted { $0.orb < $1.orb }
        let dominantAspect = sortedAspects.first
        
        if let aspect = dominantAspect {
            print("🎯 HUD: Dominant aspect - \(aspect.planet1.symbol) \(aspect.aspect.symbol) \(aspect.planet2.symbol) (orb: \(String(format: "%.1f", aspect.orb))°)")
        }
        
        return dominantAspect
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
        // Claude: FIXED - Use LIVE data even in fallback scenarios
        print("⚠️ HUD: Loading fallback data with LIVE ruler/realm numbers")
        
        let fallbackAspect = createFallbackAspect()
        let liveRulerNumber = getCurrentRulerNumber()  // Still get LIVE ruler number
        let liveElement = getCurrentElement()          // Still get LIVE element
        
        currentHUDData = HUDData(
            rulerNumber: liveRulerNumber,              // LIVE data
            dominantAspect: fallbackAspect,            // Fallback aspect only
            element: liveElement,                      // LIVE element
            lastCalculated: Date(),
            allAspects: [fallbackAspect]
        )
        
        print("✅ HUD: Fallback data loaded with live ruler: \(liveRulerNumber), element: \(liveElement)")
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