/**
 * Biometric Data Provider for KASPER MLX
 * 
 * Provides async access to biometric data including heart rate, heart rate variability,
 * and derived spiritual metrics for KASPER MLX inference.
 */

import Foundation
import HealthKit

final class BiometricDataProvider: SpiritualDataProvider {
    
    // MARK: - Properties
    
    let id = "biometric"
    private var contextCache: [KASPERFeature: ProviderContext] = [:]
    
    // Reference to existing health manager
    private weak var healthKitManager: HealthKitManager?
    
    // MARK: - Initialization
    
    init(healthKitManager: HealthKitManager? = nil) {
        self.healthKitManager = healthKitManager
    }
    
    // MARK: - SpiritualDataProvider Implementation
    
    func isDataAvailable() async -> Bool {
        guard let healthManager = healthKitManager else { return false }
        
        return await MainActor.run {
            healthManager.authorizationStatus == .sharingAuthorized ||
            healthManager.currentHeartRate > 0
        }
    }
    
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Check cache first
        if let cached = contextCache[feature], !cached.isExpired {
            print("💓 KASPER MLX: Using cached biometric context for \(feature)")
            return cached
        }
        
        // Build context based on feature needs
        let context = try await buildContext(for: feature)
        
        // Cache the context
        contextCache[feature] = context
        
        return context
    }
    
    func clearCache() async {
        contextCache.removeAll()
        print("💓 KASPER MLX: Biometric provider cache cleared")
    }
    
    // MARK: - Private Methods
    
    private func buildContext(for feature: KASPERFeature) async throws -> ProviderContext {
        var data: [String: Any] = [:]
        
        // Get current heart rate data
        let currentBPM: Int
        if let healthManager = healthKitManager {
            currentBPM = await MainActor.run {
                healthManager.currentHeartRate
            }
        } else {
            currentBPM = 0
        }
        
        // Get heart rate history if available
        let heartRateHistory = await getHeartRateHistory()
        
        switch feature {
        case .journalInsight:
            // Journal needs emotional state indicators
            data["currentBPM"] = currentBPM
            data["emotionalState"] = getEmotionalState(bpm: currentBPM)
            data["stressLevel"] = getStressLevel(bpm: currentBPM, history: heartRateHistory)
            data["energyLevel"] = getEnergyLevel(bpm: currentBPM)
            
        case .dailyCard:
            // Daily card needs vitality assessment
            data["currentBPM"] = currentBPM
            data["vitalityScore"] = getVitalityScore(bpm: currentBPM, history: heartRateHistory)
            data["cardiacRhythm"] = getCardiacRhythm(bpm: currentBPM)
            data["physicalReadiness"] = getPhysicalReadiness(bpm: currentBPM)
            
        case .sanctumGuidance:
            // Sanctum needs comprehensive biometric profile
            data["currentBPM"] = currentBPM
            data["restingBPM"] = getRestingBPM(history: heartRateHistory)
            data["heartRateVariability"] = getHeartRateVariability(history: heartRateHistory)
            data["autonomicBalance"] = getAutonomicBalance(bpm: currentBPM, history: heartRateHistory)
            data["chakraAlignment"] = getChakraAlignment(bpm: currentBPM)
            
        case .focusIntention:
            // Focus needs concentration indicators
            data["currentBPM"] = currentBPM
            data["focusState"] = getFocusState(bpm: currentBPM)
            data["meditativeReadiness"] = getMeditativeReadiness(bpm: currentBPM)
            data["breathingPattern"] = getBreathingPattern(bpm: currentBPM)
            
        case .cosmicTiming:
            // Cosmic timing needs circadian alignment
            data["currentBPM"] = currentBPM
            data["circadianPhase"] = getCircadianPhase(bpm: currentBPM)
            data["biologicalTime"] = getBiologicalTime(bpm: currentBPM)
            data["cosmicAlignment"] = getCosmicAlignment(bpm: currentBPM)
            
        case .matchCompatibility:
            // Match needs compatibility biometrics
            data["currentBPM"] = currentBPM
            data["emotionalAvailability"] = getEmotionalAvailability(bpm: currentBPM)
            data["connectionReadiness"] = getConnectionReadiness(bpm: currentBPM)
            data["empathicState"] = getEmpathicState(bpm: currentBPM)
            
        case .realmInterpretation:
            // Realm needs environmental adaptation
            data["currentBPM"] = currentBPM
            data["adaptationState"] = getAdaptationState(bpm: currentBPM)
            data["environmentalSync"] = getEnvironmentalSync(bpm: currentBPM)
            data["realmResonance"] = getRealmResonance(bpm: currentBPM)
        }
        
        // Add common biometric metadata
        data["timestamp"] = Date().timeIntervalSince1970
        data["dataSource"] = "HealthKit"
        data["authorizationStatus"] = await getAuthorizationStatus()
        data["isSimulated"] = await isSimulatedData()
        
        return ProviderContext(
            providerId: id,
            feature: feature,
            data: data,
            cacheExpiry: getCacheExpiry(for: feature)
        )
    }
    
    // MARK: - Helper Methods
    
    private func getHeartRateHistory() async -> [Double] {
        // Get recent heart rate samples for analysis
        await MainActor.run {
            // This would integrate with HealthKitManager's history
            // For now, return empty array as placeholder
            return []
        }
    }
    
    private func getEmotionalState(bpm: Int) -> String {
        switch bpm {
        case 0...60: return "calm"
        case 61...80: return "balanced"
        case 81...100: return "energized"
        case 101...120: return "excited"
        default: return "intense"
        }
    }
    
    private func getStressLevel(bpm: Int, history: [Double]) -> String {
        // Simple stress assessment based on BPM
        if bpm > 100 {
            return "elevated"
        } else if bpm < 60 {
            return "relaxed"
        } else {
            return "normal"
        }
    }
    
    private func getEnergyLevel(bpm: Int) -> String {
        switch bpm {
        case 0...60: return "low"
        case 61...80: return "moderate"
        case 81...100: return "high"
        default: return "very_high"
        }
    }
    
    private func getVitalityScore(bpm: Int, history: [Double]) -> Double {
        // Normalized vitality score based on heart rate
        let normalizedBPM = min(max(Double(bpm), 40), 120)
        return (normalizedBPM - 40) / 80.0 // Scale 0-1
    }
    
    private func getCardiacRhythm(bpm: Int) -> String {
        switch bpm {
        case 60...100: return "normal_sinus"
        case 40...59: return "bradycardia"
        case 101...150: return "tachycardia"
        default: return "irregular"
        }
    }
    
    private func getPhysicalReadiness(bpm: Int) -> String {
        switch bpm {
        case 70...90: return "optimal"
        case 60...69, 91...110: return "good"
        case 50...59, 111...130: return "moderate"
        default: return "low"
        }
    }
    
    private func getRestingBPM(history: [Double]) -> Double {
        // Calculate resting heart rate from history
        guard !history.isEmpty else { return 70.0 } // Default
        return history.min() ?? 70.0
    }
    
    private func getHeartRateVariability(history: [Double]) -> Double {
        // Calculate HRV from history
        guard history.count > 1 else { return 0.0 }
        let variance = history.reduce(0) { sum, value in
            let diff = value - history.first!
            return sum + (diff * diff)
        } / Double(history.count - 1)
        return sqrt(variance)
    }
    
    private func getAutonomicBalance(bpm: Int, history: [Double]) -> String {
        let hrv = getHeartRateVariability(history: history)
        if hrv > 20 {
            return "parasympathetic_dominant"
        } else if hrv < 10 {
            return "sympathetic_dominant"
        } else {
            return "balanced"
        }
    }
    
    private func getChakraAlignment(bpm: Int) -> [String: Any] {
        // Map heart rate to chakra activation
        return [
            "heart": bpm >= 60 && bpm <= 80 ? "aligned" : "imbalanced",
            "solar_plexus": bpm >= 70 && bpm <= 90 ? "active" : "dormant",
            "throat": bpm >= 65 && bpm <= 85 ? "open" : "blocked"
        ]
    }
    
    private func getFocusState(bpm: Int) -> String {
        switch bpm {
        case 60...75: return "concentrated"
        case 76...90: return "alert"
        case 91...105: return "agitated"
        default: return "distracted"
        }
    }
    
    private func getMeditativeReadiness(bpm: Int) -> String {
        switch bpm {
        case 50...70: return "highly_ready"
        case 71...85: return "moderately_ready"
        case 86...100: return "needs_preparation"
        default: return "not_ready"
        }
    }
    
    private func getBreathingPattern(bpm: Int) -> String {
        // Estimate breathing from heart rate
        let breathsPerMinute = Int(Double(bpm) / 4.5) // Rough approximation
        switch breathsPerMinute {
        case 8...12: return "slow_deep"
        case 13...20: return "normal"
        case 21...30: return "rapid"
        default: return "irregular"
        }
    }
    
    private func getCircadianPhase(bpm: Int) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6...11: return "morning_rise"
        case 12...17: return "afternoon_peak"
        case 18...22: return "evening_decline"
        default: return "night_rest"
        }
    }
    
    private func getBiologicalTime(bpm: Int) -> String {
        // Estimate biological time based on heart rate and clock time
        let hour = Calendar.current.component(.hour, from: Date())
        if bpm > 80 && hour < 6 {
            return "premature_activation"
        } else if bpm < 60 && hour > 12 && hour < 20 {
            return "early_decline"
        } else {
            return "synchronized"
        }
    }
    
    private func getCosmicAlignment(bpm: Int) -> String {
        // Mystical interpretation of heart rate alignment
        let remainder = bpm % 7 // Seven chakras
        let alignments = ["root", "sacral", "solar", "heart", "throat", "third_eye", "crown"]
        return alignments[remainder]
    }
    
    private func getEmotionalAvailability(bpm: Int) -> String {
        switch bpm {
        case 65...85: return "open"
        case 55...64, 86...95: return "guarded"
        default: return "closed"
        }
    }
    
    private func getConnectionReadiness(bpm: Int) -> String {
        switch bpm {
        case 70...90: return "ready"
        case 60...69, 91...110: return "partially_ready"
        default: return "not_ready"
        }
    }
    
    private func getEmpathicState(bpm: Int) -> String {
        switch bpm {
        case 65...80: return "receptive"
        case 81...95: return "projective"
        default: return "neutral"
        }
    }
    
    private func getAdaptationState(bpm: Int) -> String {
        switch bpm {
        case 60...80: return "well_adapted"
        case 81...100: return "adapting"
        default: return "stressed"
        }
    }
    
    private func getEnvironmentalSync(bpm: Int) -> String {
        // Check if heart rate aligns with expected patterns
        let hour = Calendar.current.component(.hour, from: Date())
        let expectedRange = getExpectedBPMRange(for: hour)
        
        if bpm >= expectedRange.lowerBound && bpm <= expectedRange.upperBound {
            return "synchronized"
        } else {
            return "desynchronized"
        }
    }
    
    private func getRealmResonance(bpm: Int) -> String {
        // Numerological resonance with current realm
        let digit = bpm % 9 + 1
        return "resonance_\(digit)"
    }
    
    private func getExpectedBPMRange(for hour: Int) -> ClosedRange<Int> {
        switch hour {
        case 6...11: return 70...90  // Morning
        case 12...17: return 75...95 // Afternoon
        case 18...22: return 65...85 // Evening
        default: return 55...75      // Night
        }
    }
    
    private func getAuthorizationStatus() async -> String {
        guard let healthManager = healthKitManager else { return "not_determined" }
        
        return await MainActor.run {
            switch healthManager.authorizationStatus {
            case .sharingAuthorized: return "authorized"
            case .sharingDenied: return "denied"
            default: return "not_determined"
            }
        }
    }
    
    private func isSimulatedData() async -> Bool {
        guard let healthManager = healthKitManager else { return false }
        
        return await MainActor.run {
            healthManager.isHeartRateSimulated
        }
    }
    
    private func getCacheExpiry(for feature: KASPERFeature) -> TimeInterval {
        switch feature {
        case .focusIntention, .cosmicTiming:
            return 60   // 1 minute for real-time features
        case .journalInsight, .dailyCard:
            return 300  // 5 minutes for interactive features
        default:
            return 600  // 10 minutes for less time-sensitive features
        }
    }
}