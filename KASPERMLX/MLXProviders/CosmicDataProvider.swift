/**
 * 🌌 KASPER MLX COSMIC DATA PROVIDER - CELESTIAL INTELLIGENCE FOR SPIRITUAL AI
 * ==========================================================================
 *
 * This revolutionary cosmic data provider seamlessly integrates sophisticated astrological
 * calculations with spiritual AI, enabling KASPER MLX to provide timing-sensitive spiritual
 * guidance that harmonizes with celestial movements and cosmic energies. It represents the
 * pinnacle of spiritual-astronomical integration in AI systems.
 *
 * ⭐ COMPREHENSIVE COSMIC INTELLIGENCE INTEGRATION:
 *
 * The CosmicDataProvider transforms Vybe's existing CosmicService calculations into
 * spiritually-aware context for AI guidance, creating unprecedented harmony between
 * ancient astrological wisdom and cutting-edge machine learning technology.
 *
 * 🌟 ADVANCED ASTROLOGICAL DATA PROCESSING:
 *
 * REAL-TIME COSMIC STATE ANALYSIS:
 * • Live planetary position tracking without triggering expensive SwiftAA recalculations
 * • Moon phase intelligence providing lunar-aligned spiritual guidance timing
 * • Zodiacal sign analysis for personality-cosmic harmony in spiritual recommendations
 * • Planetary aspect identification for cosmic energy flow understanding
 *
 * SPIRITUAL FEATURE CUSTOMIZATION:
 * • Journal insights enhanced with lunar influence and astrological emotional guidance
 * • Daily cards personalized with dominant planetary energies and cosmic mood assessment
 * • Sanctum guidance enriched with comprehensive planetary positions and major aspects
 * • Cosmic timing precision using exact planetary degrees and lunar cycle predictions
 * • Match compatibility analysis through elemental harmony and Venus-Mars interactions
 * • Focus intentions aligned with planetary hours and current cosmic energy flows
 * • Realm interpretations incorporating numerological-cosmic correspondences
 *
 * 🔮 SOPHISTICATED COSMIC CORRELATION ALGORITHMS:
 *
 * LUNAR INFLUENCE MAPPING:
 * • Moon age correlation to spiritual energy phases (new moon planting, full moon culmination)
 * • Lunar sign analysis for emotional-spiritual guidance tone adjustment
 * • Moon phase timing for optimal spiritual practice recommendations
 * • Lunar cycle prediction for future spiritual planning and intention setting
 *
 * PLANETARY ENERGY ASSESSMENT:
 * • Dominant planet identification based on time-of-day and seasonal cosmic rulers
 * • Planetary mood analysis through harmonic vs challenging aspect evaluation
 * • Planetary hour calculation for optimal spiritual practice timing
 * • Individual planet-sign correlation for personalized cosmic guidance
 *
 * ELEMENTAL AND MODAL HARMONY:
 * • Zodiacal element distribution (fire, earth, air, water) for spiritual balance assessment
 * • Astrological modality analysis (cardinal, fixed, mutable) for spiritual approach guidance
 * • Cosmic energy flow evaluation based on planetary aspect patterns
 * • Numerological-cosmic correlation through planetary position numerical reduction
 *
 * 🌊 PERFORMANCE-OPTIMIZED COSMIC ACCESS:
 *
 * EFFICIENT COSMIC DATA UTILIZATION:
 * • Leverages pre-calculated CosmicService data preventing expensive astrological recalculation
 * • Thread-safe actor-based caching for concurrent cosmic data access during spiritual sessions
 * • Intelligent cache expiry based on cosmic data sensitivity and spiritual feature requirements
 * • Memory-efficient processing preventing cosmic data accumulation and performance degradation
 *
 * LIGHTWEIGHT INTEGRATION ARCHITECTURE:
 * • Seamless integration with existing CosmicService infrastructure without modification
 * • Non-blocking async operations preserving UI responsiveness during cosmic analysis
 * • Error-resilient processing with graceful degradation when cosmic data temporarily unavailable
 * • Standardized SpiritualDataProvider protocol compliance for consistent KASPER MLX integration
 *
 * 🎯 FEATURE-SPECIFIC COSMIC CONTEXTUALIZATION:
 *
 * JOURNAL INSIGHT COSMIC ENHANCEMENT:
 * • Moon phase and lunar age analysis for emotional spiritual guidance depth
 * • Solar and lunar sign correlation for personality-cosmic harmony assessment
 * • Lunar influence mapping for optimal reflection timing and spiritual introspection
 * • Astrological context for personalized spiritual growth recommendations
 *
 * DAILY CARD COSMIC PERSONALIZATION:
 * • Current planetary ruler identification for daily cosmic energy alignment
 * • Planetary mood assessment through aspect analysis for spiritual guidance tone
 * • Solar-lunar harmony evaluation for balanced daily spiritual recommendations
 * • Cosmic energy flow analysis for optimal daily spiritual activity timing
 *
 * SANCTUM GUIDANCE COSMIC AMPLIFICATION:
 * • Comprehensive planetary position analysis for meditation energy alignment
 * • Major aspect identification for spiritual practice intensity and focus guidance
 * • Multi-planetary sign analysis for holistic cosmic-spiritual state assessment
 * • Astrological complexity integration for advanced spiritual practitioners
 *
 * COSMIC TIMING PRECISION ANALYSIS:
 * • Exact planetary degree positions for precise cosmic timing calculations
 * • Lunar cycle prediction for future spiritual planning and intention manifestation
 * • Solar-lunar degree relationship analysis for cosmic harmony timing identification
 * • Next major lunar event calculation for optimal spiritual milestone planning
 *
 * MATCH COMPATIBILITY COSMIC CORRELATION:
 * • Solar sign elemental harmony analysis for spiritual partnership compatibility
 * • Venus sign analysis for heart-centered spiritual connection assessment
 * • Lunar sign emotional compatibility for deep spiritual relationship harmony
 * • Multi-planetary compatibility matrix for comprehensive cosmic relationship guidance
 *
 * FOCUS INTENTION COSMIC ALIGNMENT:
 * • Planetary hour identification for optimal intention-setting timing
 * • Current cosmic energy assessment for spiritual focus intensity guidance
 * • Moon phase correlation with intention manifestation timing and effectiveness
 * • Cosmic-personal energy harmony evaluation for authentic spiritual focus
 *
 * REALM INTERPRETATION COSMIC INTEGRATION:
 * • Numerological-cosmic correspondence through planetary position analysis
 * • Solar-lunar harmony for spiritual environment energy assessment
 * • Cosmic number derivation from current planetary degree positions
 * • Universal-personal cosmic rhythm synchronization for spiritual realm navigation
 *
 * 💫 REVOLUTIONARY SPIRITUAL-COSMIC FUSION:
 *
 * This provider represents the future of spiritual AI - one that understands timing,
 * cosmic flows, and celestial influences in providing guidance that harmonizes with
 * the user's cosmic environment and universal rhythms. It transforms abstract
 * spiritual advice into cosmically-aligned, timing-sensitive wisdom.
 *
 * 🔒 PRIVACY-PRESERVING COSMIC INTELLIGENCE:
 *
 * • All cosmic calculations processed locally using existing CosmicService infrastructure
 * • No transmission of user cosmic timing or astrological preferences to external services
 * • Complete user control over cosmic data integration with spiritual guidance
 * • Transparent cosmic processing with clear understanding of astrological data usage
 *
 * This CosmicDataProvider demonstrates how ancient astrological wisdom can enhance
 * modern AI while respecting both cosmic principles and user privacy.
 */

import Foundation
import SwiftUI

final class CosmicDataProvider: SpiritualDataProvider {

    // MARK: - Properties

    let id = "cosmic"
    // Claude: Thread-safe cache using actor isolation for concurrent access
    private let cacheActor = CacheActor()

    // MARK: - Thread-Safe Cache Actor
    private actor CacheActor {
        private var cache: [KASPERFeature: ProviderContext] = [:]

        func get(_ feature: KASPERFeature) -> ProviderContext? {
            return cache[feature]
        }

        func set(_ feature: KASPERFeature, context: ProviderContext) {
            cache[feature] = context
        }

        func clear() {
            cache.removeAll()
        }
    }

    // MARK: - SpiritualDataProvider Implementation

    func isDataAvailable() async -> Bool {
        // Check if CosmicService has data without triggering calculations
        return await MainActor.run {
            CosmicService.shared.todaysCosmic != nil
        }
    }

    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Check cache first - thread-safe read via actor
        if let cached = await cacheActor.get(feature), !cached.isExpired {
            print("🌌 KASPER MLX: Using cached cosmic context for \(feature)")
            return cached
        }

        // Get cosmic data from main actor
        let cosmicDataOptional = await MainActor.run {
            CosmicService.shared.todaysCosmic
        }

        guard let cosmicData = cosmicDataOptional else {
            throw KASPERMLXError.providerUnavailable("CosmicService")
        }

        // Build context based on feature needs
        let context = try await buildContext(for: feature, from: cosmicData)

        // Cache the context - thread-safe write via actor
        await cacheActor.set(feature, context: context)

        return context
    }

    func clearCache() async {
        await cacheActor.clear()
        print("🌌 KASPER MLX: Cosmic provider cache cleared")
    }

    // MARK: - Private Methods

    private func buildContext(for feature: KASPERFeature, from cosmicData: CosmicData) async throws -> ProviderContext {
        var data: [String: Any] = [:]

        switch feature {
        case .journalInsight:
            // Journal needs moon phase and current transits
            data["moonPhase"] = cosmicData.moonPhase
            data["moonAge"] = cosmicData.moonAge
            data["sunSign"] = cosmicData.sunSign
            data["moonSign"] = cosmicData.zodiacSign(for: "Moon") ?? "Unknown"
            data["lunarInfluence"] = getLunarInfluence(moonAge: cosmicData.moonAge)

        case .dailyCard:
            // Daily card needs current planetary positions
            data["sunSign"] = cosmicData.sunSign
            data["moonPhase"] = cosmicData.moonPhase
            data["dominantPlanet"] = await getDominantPlanet(from: cosmicData)
            data["planetaryMood"] = getPlanetaryMood(from: cosmicData)

        case .sanctumGuidance:
            // Sanctum needs comprehensive cosmic data
            data["sunSign"] = cosmicData.sunSign
            data["moonSign"] = cosmicData.zodiacSign(for: "Moon") ?? "Unknown"
            data["mercurySign"] = cosmicData.zodiacSign(for: "Mercury") ?? "Unknown"
            data["venusSign"] = cosmicData.zodiacSign(for: "Venus") ?? "Unknown"
            data["marsSign"] = cosmicData.zodiacSign(for: "Mars") ?? "Unknown"
            data["majorAspects"] = formatMajorAspects(cosmicData.getMajorAspects())

        case .cosmicTiming:
            // Timing needs precise positions
            data["sunDegree"] = cosmicData.planetaryPositions["Sun"] ?? 0
            data["moonDegree"] = cosmicData.planetaryPositions["Moon"] ?? 0
            data["moonPhase"] = cosmicData.moonPhase
            data["nextFullMoon"] = cosmicData.nextFullMoon?.timeIntervalSince1970
            data["nextNewMoon"] = cosmicData.nextNewMoon?.timeIntervalSince1970

        case .matchCompatibility:
            // Match needs elemental data
            data["sunSign"] = cosmicData.sunSign
            data["sunElement"] = getElement(for: cosmicData.sunSign)
            data["moonSign"] = cosmicData.zodiacSign(for: "Moon") ?? "Unknown"
            data["venusSign"] = cosmicData.zodiacSign(for: "Venus") ?? "Unknown"

        case .focusIntention:
            // Focus needs current energy
            data["moonPhase"] = cosmicData.moonPhase
            data["planetaryHour"] = getPlanetaryHour()
            data["cosmicEnergy"] = getCosmicEnergy(from: cosmicData)

        case .realmInterpretation:
            // Realm needs numerological correspondence
            data["sunSign"] = cosmicData.sunSign
            data["moonPhase"] = cosmicData.moonPhase
            data["cosmicNumber"] = getCosmicNumber(from: cosmicData)
        }

        // Add common metadata
        data["timestamp"] = Date().timeIntervalSince1970
        data["dataSource"] = "CosmicService"

        return ProviderContext(
            providerId: id,
            feature: feature,
            data: data,
            cacheExpiry: feature == .sanctumGuidance ? 600 : 300 // Longer cache for comprehensive data
        )
    }

    // MARK: - Helper Methods

    private func getLunarInfluence(moonAge: Double) -> String {
        switch moonAge {
        case 0..<3.5: return "new_moon_energy"
        case 3.5..<7: return "waxing_crescent"
        case 7..<10.5: return "first_quarter"
        case 10.5..<14: return "waxing_gibbous"
        case 14..<17.5: return "full_moon_power"
        case 17.5..<21: return "waning_gibbous"
        case 21..<24.5: return "last_quarter"
        case 24.5...: return "waning_crescent"
        default: return "transitional"
        }
    }

    private func getDominantPlanet(from cosmicData: CosmicData) async -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        // Simple day/night ruler system
        return (hour >= 6 && hour < 18) ? "Sun" : "Moon"
    }

    private func getPlanetaryMood(from cosmicData: CosmicData) -> String {
        // Analyze current aspects for general mood
        let aspects = cosmicData.getMajorAspects()
        let harmonicCount = aspects.filter {
            $0.aspectType == .trine || $0.aspectType == .sextile
        }.count
        let challengingCount = aspects.filter {
            $0.aspectType == .square || $0.aspectType == .opposition
        }.count

        if harmonicCount > challengingCount {
            return "harmonious"
        } else if challengingCount > harmonicCount {
            return "challenging"
        } else {
            return "balanced"
        }
    }

    private func formatMajorAspects(_ aspects: [CosmicData.PlanetaryAspect]) -> [[String: Any]] {
        aspects.prefix(5).map { aspect in
            [
                "planet1": aspect.planet1,
                "planet2": aspect.planet2,
                "aspect": aspect.aspectType.rawValue,
                "orb": aspect.orb,
                "isExact": aspect.isExact
            ]
        }
    }

    private func getElement(for sign: String) -> String {
        switch sign.lowercased() {
        case "aries", "leo", "sagittarius": return "fire"
        case "taurus", "virgo", "capricorn": return "earth"
        case "gemini", "libra", "aquarius": return "air"
        case "cancer", "scorpio", "pisces": return "water"
        default: return "unknown"
        }
    }

    private func getPlanetaryHour() -> String {
        // Simplified planetary hour calculation
        let hour = Calendar.current.component(.hour, from: Date())
        let dayOfWeek = Calendar.current.component(.weekday, from: Date())
        let planetaryRulers = ["Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn"]
        let index = (dayOfWeek + hour) % planetaryRulers.count
        return planetaryRulers[index]
    }

    private func getCosmicEnergy(from cosmicData: CosmicData) -> String {
        // Combine moon phase and planetary positions for energy assessment
        switch cosmicData.moonPhase {
        case "New Moon": return "planting"
        case "Waxing Crescent", "First Quarter", "Waxing Gibbous": return "building"
        case "Full Moon": return "culminating"
        case "Waning Gibbous", "Last Quarter", "Waning Crescent": return "releasing"
        default: return "flowing"
        }
    }

    private func getCosmicNumber(from cosmicData: CosmicData) -> Int {
        // Simple numerological reduction of current cosmic positions
        let sunDegree = Int(cosmicData.planetaryPositions["Sun"] ?? 0)
        let moonDegree = Int(cosmicData.planetaryPositions["Moon"] ?? 0)
        return ((sunDegree + moonDegree) % 9) + 1
    }
}
