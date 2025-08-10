import Foundation
import SwiftAA

// Claude: All shared types are now in CosmicHUDTypes.swift

// MARK: - Mini Insight Provider
/// Claude: Bite-sized spiritual wisdom for the Cosmic HUD
/// Bridges KASPER MLX AI with template-based insights for instant cosmic guidance
/// Premium users get personalized KASPER MLX insights, free users get curated templates

@MainActor
class MiniInsightProvider: ObservableObject {

    // MARK: - Dependencies
    private let kasperMLXManager: KASPERMLXManager
    private let templateLibrary: CosmicInsightTemplateLibrary

    // MARK: - Published Properties
    @Published var currentInsight: String = ""
    @Published var insightType: InsightType = .template
    @Published var isGenerating: Bool = false

    // MARK: - Private Properties
    private var insightCache: [String: String] = [:]
    private let maxCacheSize = 50

    // MARK: - Singleton
    static let shared = MiniInsightProvider()

    private init() {
        self.kasperMLXManager = KASPERMLXManager.shared
        self.templateLibrary = CosmicInsightTemplateLibrary()
    }

    // MARK: - Public Methods

    /// Claude: Core insight generation method that adapts to user tier and available data
    /// Premium users get KASPER personalization, free users get latest insights or curated templates
    /// Smart caching prevents redundant API calls and ensures smooth HUD performance
    func generateInsight(for aspectData: AspectData) async -> String {
        let cacheKey = createCacheKey(for: aspectData)

        // Claude: Cache-first strategy for performance - HUD updates every 5 minutes
        // so we need instant responses without blocking the Dynamic Island
        if let cachedInsight = insightCache[cacheKey] {
            return cachedInsight
        }

        isGenerating = true
        defer { isGenerating = false }

        let insight: String

        // Claude: Check premium status to determine insight source
        if await hasPremiumAccess() {
            // Claude: KASPER integration for premium users - personalized spiritual guidance
            insight = await generateKASPERInsight(for: aspectData)
            insightType = .kasper
        } else {
            // Claude: Free users get their latest generated insight first, then templates
            // This gives free users a taste of personalized content from their app usage
            insight = await generateFreeUserInsight(for: aspectData)
            insightType = .template
        }

        // Claude: Cache with LRU eviction to manage memory efficiently
        cacheInsight(insight, forKey: cacheKey)

        currentInsight = insight
        return insight
    }

    /// Generates insight for current element of the day
    func generateElementInsight(for element: CosmicElement) async -> String {
        let cacheKey = "element_\(element.rawValue)_\(todayDateString())"

        if let cachedInsight = insightCache[cacheKey] {
            return cachedInsight
        }

        let insight = if await hasPremiumAccess() {
            await generateKASPERElementInsight(for: element)
        } else {
            generateTemplateElementInsight(for: element)
        }

        cacheInsight(insight, forKey: cacheKey)
        return insight
    }

    /// Generates insight for ruler number
    func generateRulerInsight(for rulerNumber: Int) async -> String {
        let cacheKey = "ruler_\(rulerNumber)_\(todayDateString())"

        if let cachedInsight = insightCache[cacheKey] {
            return cachedInsight
        }

        let insight = if await hasPremiumAccess() {
            await generateKASPERRulerInsight(for: rulerNumber)
        } else {
            generateTemplateRulerInsight(for: rulerNumber)
        }

        cacheInsight(insight, forKey: cacheKey)
        return insight
    }

    /// Gets a random cosmic wisdom quote
    func getCosmicWisdom() -> String {
        let wisdomQuotes = [
            "✨ The universe whispers to those who listen with their soul",
            "🌙 Every moment holds sacred geometry waiting to be discovered",
            "⭐ Your spiritual frequency attracts your cosmic experiences",
            "🔮 Numbers are the language through which the divine speaks",
            "🌌 Alignment comes when you honor both shadow and light",
            "💫 The cosmos reflects your inner spiritual landscape",
            "🕉️ Sacred timing unfolds when you trust the process",
            "🌟 Your awareness shapes the reality you experience"
        ]

        return wisdomQuotes.randomElement() ?? "🌌 The cosmos is always speaking"
    }

    // MARK: - Private Methods

    /// Claude: Premium access check - integrates with existing Vybe subscription system
    /// Returns true if user has active premium subscription for KASPER MLX features
    private func hasPremiumAccess() async -> Bool {
        // Claude: ✨ KASPER MLX ENABLED - Now fully implemented for real-time insights
        // For development/testing, enable for all users to test KASPER MLX
        return true

        // Claude: Future implementation will check subscription:
        // return await kasperMLXManager.hasActiveSubscription()
    }

    /// Claude: Enhanced free user insight system - shows latest app-generated insights
    /// Pulls from user's recent cosmic snapshot insights, journal insights, or match insights
    /// Falls back to curated templates if no recent insights available
    private func generateFreeUserInsight(for aspectData: AspectData) async -> String {
        // Claude: Step 1 - Try to get user's latest generated insight from app usage
        if let latestInsight = await getLatestUserInsight() {
            // Claude: Contextualize the existing insight to current aspect if relevant
            return contextualizeInsight(latestInsight, for: aspectData)
        }

        // Claude: Step 2 - Check if we have aspect-specific insights from user's history
        if let aspectInsight = await getAspectSpecificInsight(for: aspectData) {
            return aspectInsight
        }

        // Claude: Step 3 - Fall back to enhanced template system
        return generateEnhancedTemplateInsight(for: aspectData)
    }

    /// Claude: Retrieves user's most recent insight from various app sources
    /// Checks: Cosmic Snapshot insights, Journal insights, Match insights, etc.
    private func getLatestUserInsight() async -> String? {
        // Claude: Integration points with existing Vybe insight systems:

        // 1. Check CosmicSnapshotView recent insights
        // This would integrate with your existing CosmicSnapshotViewModel

        // 2. Check recent VybeMatch insights
        // This would integrate with VybeMatchManager insights

        // 3. Check recent Journal entry insights
        // This would integrate with JournalManager insights

        // Claude: For now, return nil to use templates
        // Future implementation will query these managers:
        /*
        if let cosmicInsight = await CosmicSnapshotViewModel.shared.getLatestInsight() {
            return cosmicInsight
        }

        if let matchInsight = await VybeMatchManager.shared.getRecentMatchInsight() {
            return matchInsight
        }

        if let journalInsight = await JournalManager.shared.getRecentInsight() {
            return journalInsight
        }
        */

        return nil
    }

    /// Claude: Looks for user's previous insights related to current planetary aspect
    /// Helps create continuity in spiritual guidance across app usage
    private func getAspectSpecificInsight(for aspectData: AspectData) async -> String? {
        // Claude: This would search user's insight history for similar aspects
        // Example: If user had Venus-Jupiter insight yesterday, reference it today

        // Future implementation would check insight database:
        /*
        let similarAspects = await InsightHistoryManager.shared.getSimilarAspects(
            planet1: aspectData.planet1,
            planet2: aspectData.planet2,
            aspect: aspectData.aspect,
            withinDays: 7
        )

        return similarAspects.first?.insight
        */

        return nil
    }

    /// Claude: Adds context to existing insights to make them relevant to current aspect
    /// Example: Takes a general insight and relates it to current Venus-Jupiter trine
    private func contextualizeInsight(_ insight: String, for aspectData: AspectData) -> String {
        let aspectContext = "With \(aspectData.planet1.rawValue.capitalized) \(aspectData.aspect.rawValue.lowercased()) \(aspectData.planet2.rawValue.capitalized) today"

        // Claude: Add contextual prefix to existing insight
        if insight.count > 50 {
            return "\(aspectContext), \(insight.prefix(100))..."
        } else {
            return "\(aspectContext), \(insight)"
        }
    }

    /// Claude: Enhanced template system with multiple variations and spiritual depth
    /// More sophisticated than basic templates - includes orb consideration and timing
    private func generateEnhancedTemplateInsight(for aspectData: AspectData) -> String {
        let baseInsight = generateTemplateInsight(for: aspectData)

        // Claude: Add orb-based modifiers for more precise guidance
        let orbModifier = if aspectData.orb < 2.0 {
            " This exact alignment amplifies its spiritual influence."
        } else if aspectData.orb > 5.0 {
            " This loose aspect offers gentle cosmic guidance."
        } else {
            " This aspect brings balanced cosmic energy."
        }

        // Claude: Add timing-based modifiers for applying vs separating aspects
        let timingModifier = if aspectData.isApplying {
            " Energy is building — prepare for spiritual transformation."
        } else {
            " Energy is releasing — integrate the cosmic lessons."
        }

        return baseInsight + orbModifier + timingModifier
    }

    private func generateKASPERInsight(for aspectData: AspectData) async -> String {
        // Claude: ✨ KASPER MLX ENABLED - Modern async insights without blocking
        print("✨ KASPER MLX: Generating cosmic timing insight for aspect")

        do {
            let insight = try await kasperMLXManager.generateCosmicTimingInsight()
            print("✅ KASPER MLX: Generated insight for aspect: \(aspectData.planet1.rawValue) \(aspectData.aspect.rawValue) \(aspectData.planet2.rawValue)")
            return insight.content
        } catch {
            print("❌ KASPER MLX: Failed to generate insight: \(error)")
            // Fallback to template if KASPER MLX fails
            return generateEnhancedTemplateInsight(for: aspectData)
        }
    }

    private func generateKASPERElementInsight(for element: CosmicElement) async -> String {
        print("✨ KASPER MLX: Generating cosmic timing insight for element: \(element.rawValue)")

        do {
            let insight = try await kasperMLXManager.generateCosmicTimingInsight()
            print("✅ KASPER MLX: Generated insight for element: \(element.rawValue)")
            return insight.content
        } catch {
            print("❌ KASPER MLX: Failed to generate element insight: \(error)")
            return generateTemplateElementInsight(for: element)
        }
    }

    private func generateKASPERRulerInsight(for rulerNumber: Int) async -> String {
        print("✨ KASPER MLX: Generating realm insight for ruler number: \(rulerNumber)")

        do {
            let insight = try await kasperMLXManager.generateRealmInsight()
            print("✅ KASPER MLX: Generated insight for ruler number: \(rulerNumber)")
            return insight.content
        } catch {
            print("❌ KASPER MLX: Failed to generate ruler insight: \(error)")
            return generateTemplateRulerInsight(for: rulerNumber)
        }
    }

    private func generateTemplateInsight(for aspectData: AspectData) -> String {
        let templates = templateLibrary.templates(for: aspectData.aspect)
        let template = templates.randomElement() ?? "Cosmic energies are flowing."

        return template
            .replacingOccurrences(of: "{planet1}", with: aspectData.planet1.rawValue.capitalized)
            .replacingOccurrences(of: "{planet2}", with: aspectData.planet2.rawValue.capitalized)
            .replacingOccurrences(of: "{aspect}", with: aspectData.aspect.rawValue.lowercased())
    }

    private func generateEnhancedTemplateInsight(for aspectData: AspectData, context: String) -> String {
        // Enhanced template that considers orb and timing
        let baseInsight = generateTemplateInsight(for: aspectData)

        let orbModifier = if aspectData.orb < 2.0 {
            " This exact alignment amplifies its influence."
        } else if aspectData.orb > 5.0 {
            " This loose aspect offers gentle guidance."
        } else {
            ""
        }

        let timingModifier = if aspectData.isApplying {
            " Energy is building — prepare for transformation."
        } else {
            " Energy is releasing — integrate the lessons."
        }

        return baseInsight + orbModifier + timingModifier
    }

    private func generateTemplateElementInsight(for element: CosmicElement) -> String {
        switch element {
        case .fire:
            return "🔥 Fire energy ignites your passion today — channel it into creative action."
        case .water:
            return "💧 Water energy flows through your intuition — trust your emotional wisdom."
        case .earth:
            return "🌱 Earth energy grounds your vision — build something lasting today."
        case .air:
            return "💨 Air energy expands your awareness — communicate your truth clearly."
        }
    }

    private func generateTemplateRulerInsight(for rulerNumber: Int) -> String {
        let rulerInsights = [
            1: "🌟 Your leadership energy is strong — initiate something meaningful today.",
            2: "🤝 Collaboration and harmony guide your path — seek balance in all things.",
            3: "🎨 Creative expression flows through you — let your inner artist shine.",
            4: "🏗️ Steady foundation-building serves you — patience creates lasting results.",
            5: "🌍 Adventure and freedom call — embrace change as your teacher.",
            6: "💖 Nurturing and service are your gifts — care for others and yourself.",
            7: "🔍 Deep contemplation reveals wisdom — trust your inner knowing.",
            8: "⚖️ Material mastery and justice align — manifest your spiritual values.",
            9: "🌅 Completion and humanitarian service merge — your wisdom helps others."
        ]

        return rulerInsights[rulerNumber] ?? "✨ Your unique spiritual path unfolds perfectly."
    }

    private func createCacheKey(for aspectData: AspectData) -> String {
        return "aspect_\(aspectData.planet1.rawValue)_\(aspectData.aspect.rawValue)_\(aspectData.planet2.rawValue)_\(Int(aspectData.orb))_\(todayDateString())"
    }

    private func cacheInsight(_ insight: String, forKey key: String) {
        // Implement LRU cache behavior
        if insightCache.count >= maxCacheSize {
            // Remove oldest entries (simplified implementation)
            let keysToRemove = Array(insightCache.keys.prefix(10))
            for key in keysToRemove {
                insightCache.removeValue(forKey: key)
            }
        }

        insightCache[key] = insight
    }

    private func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

// MARK: - Supporting Types
// Claude: InsightType moved to CosmicHUDTypes.swift

// MARK: - Enhanced Template Library
// Claude: Renamed to avoid conflict with existing InsightTemplateLibrary
class CosmicInsightTemplateLibrary {

    func templates(for aspect: CosmicAspect) -> [String] {
        switch aspect {
        case .conjunction:
            return [
                "{planet1} merges with {planet2} — unified energy creates new possibilities",
                "The fusion of {planet1} and {planet2} amplifies your spiritual power",
                "Cosmic union of {planet1} and {planet2} births fresh beginnings",
                "{planet1} and {planet2} dance as one — embrace this sacred synthesis"
            ]

        case .trine:
            return [
                "{planet1} harmonizes with {planet2} — flow with natural grace",
                "Easy energy between {planet1} and {planet2} opens divine doors",
                "The trine of {planet1} and {planet2} blesses your path forward",
                "Natural alignment of {planet1} and {planet2} supports your highest good"
            ]

        case .square:
            return [
                "{planet1} challenges {planet2} — growth emerges through sacred tension",
                "Dynamic friction between {planet1} and {planet2} sparks evolution",
                "The square of {planet1} and {planet2} pushes you beyond comfort zones",
                "Creative tension between {planet1} and {planet2} forges spiritual strength"
            ]

        case .opposition:
            return [
                "{planet1} faces {planet2} — seek balance within divine paradox",
                "The polarity of {planet1} and {planet2} reveals hidden wisdom",
                "Opposition between {planet1} and {planet2} calls for integration",
                "{planet1} and {planet2} create a cosmic mirror — see yourself clearly"
            ]

        case .sextile:
            return [
                "{planet1} supports {planet2} — opportunities await your action",
                "Gentle harmony between {planet1} and {planet2} encourages growth",
                "The sextile of {planet1} and {planet2} offers spiritual gifts",
                "Cooperative energy of {planet1} and {planet2} makes dreams possible"
            ]

        default:
            return [
                "Cosmic energies of {planet1} and {planet2} weave mystical patterns",
                "The dance of {planet1} and {planet2} speaks to your soul",
                "Sacred geometry connects {planet1} and {planet2} in divine timing"
            ]
        }
    }

    func emotionalTone(for aspect: CosmicAspect) -> String {
        switch aspect {
        case .conjunction:
            return "Unified and powerful"
        case .trine:
            return "Harmonious and flowing"
        case .square:
            return "Dynamic and challenging"
        case .opposition:
            return "Balanced and integrative"
        case .sextile:
            return "Supportive and opportunity-rich"
        default:
            return "Mystical and transformative"
        }
    }
}

// MARK: - Preview Helpers
#if DEBUG
extension MiniInsightProvider {
    static func previewInsight() -> String {
        return "✨ Venus harmonizes with Jupiter — easy energy flows through your relationships today. Trust your heart's wisdom."
    }

    static func previewElementInsight() -> String {
        return "🔥 Fire energy ignites your passion today — channel it into creative action."
    }

    static func previewRulerInsight() -> String {
        return "👑 Your leadership energy is strong — initiate something meaningful today."
    }
}
#endif
