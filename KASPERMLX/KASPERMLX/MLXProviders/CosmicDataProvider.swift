/**
 * Cosmic Data Provider for KASPER MLX
 * 
 * Provides lightweight, async access to cosmic and astrological data
 * for KASPER MLX inference. Uses existing CosmicService calculations
 * without triggering new SwiftAA computations.
 */

import Foundation
import SwiftUI

actor CosmicDataProvider: SpiritualDataProvider {
    
    // MARK: - Properties
    
    let id = "cosmic"
    private var contextCache: [KASPERFeature: ProviderContext] = [:]
    
    // MARK: - SpiritualDataProvider Implementation
    
    func isDataAvailable() async -> Bool {
        // Check if CosmicService has data without triggering calculations
        return await MainActor.run {
            CosmicService.shared.todaysCosmic != nil
        }
    }
    
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Check cache first
        if let cached = contextCache[feature], !cached.isExpired {
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
        
        // Cache the context
        contextCache[feature] = context
        
        return context
    }
    
    func clearCache() async {
        contextCache.removeAll()
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