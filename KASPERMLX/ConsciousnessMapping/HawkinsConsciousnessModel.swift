import Foundation
import SwiftUI

/**
 * Hawkins Consciousness Model - Numerology & Biometric Fusion
 * ===========================================================
 *
 * Implements the Hawkins Map of Consciousness (20-700+ Hz) integrated with
 * numerological archetypes and real-time biometric data from Apple Watch.
 *
 * ## Scientific Foundation
 *
 * Based on research showing HRV patterns correlate with emotional states:
 * - High HRV coherence (sine-wave pattern) = positive emotions (love, gratitude)
 * - Low HRV coherence (erratic pattern) = stress, frustration
 * - Studies validate Apple Watch HRV accuracy for emotional state inference
 *
 * ## Consciousness Zones
 *
 * Maps emotional harmonics (not literal Hz) to human states:
 * - 20-100: Survival/fear states (shame, guilt, apathy)
 * - 200-400: Courage → Love transition
 * - 500-700+: Joy → Unity consciousness
 *
 * ## Numerological Integration
 *
 * Sacred numbers (1-9) and master numbers (11, 22, 33, etc.) map to specific
 * zones with unique modifiers and archetypal qualities. This creates a
 * personalized consciousness frequency based on:
 * - User's numerological profile (focus, realm, ruler numbers)
 * - Real-time biometric state (HRV coherence, heart rate, breathing)
 * - Cosmic influences (already calculated in VFI system)
 *
 * ## Biometric Fusion Algorithm
 *
 * frequency = baseline + (hrv_coherence * 200) + (breathing_coherence * 50)
 *            + numerology_modifier + mindfulness_bonus + activity_adjustment
 *
 * Created: August 2025
 * Version: 1.0.0 - Initial Hawkins-Numerology fusion
 */

// MARK: - Consciousness Zone Model

/// Represents a consciousness zone in the Hawkins scale
struct HawkinsConsciousnessZone: Codable {
    let range: [Double]
    let description: String
    let color: String
    let gradient: [String]
    let chakra: String
    let emotions: [String]
    let hrvPattern: String
    let biometricMarkers: BiometricMarkers

    enum CodingKeys: String, CodingKey {
        case range, description, color, gradient, chakra, emotions
        case hrvPattern = "hrv_pattern"
        case biometricMarkers = "biometric_markers"
    }

    /// Convert hex color string to SwiftUI Color
    var swiftUIColor: Color {
        Color(hex: color) ?? .gray
    }

    /// Convert gradient hex strings to SwiftUI gradient
    var swiftUIGradient: LinearGradient {
        let colors = gradient.compactMap { Color(hex: $0) }
        return LinearGradient(
            colors: colors.isEmpty ? [.gray] : colors,
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

/// Biometric markers for consciousness zone detection
struct BiometricMarkers: Codable {
    let hrvCoherence: [Double]
    let heartRateElevation: [Double]
    let breathingRate: [Double]

    enum CodingKeys: String, CodingKey {
        case hrvCoherence = "hrv_coherence"
        case heartRateElevation = "heart_rate_elevation"
        case breathingRate = "breathing_rate"
    }

    /// Check if current biometrics match this zone
    func matches(coherence: Double, hrElevation: Double, breathing: Double) -> Bool {
        let coherenceMatch = coherence >= hrvCoherence[0] && coherence <= hrvCoherence[1]
        let hrMatch = hrElevation >= heartRateElevation[0] && hrElevation <= heartRateElevation[1]
        let breathingMatch = breathing >= breathingRate[0] && breathing <= breathingRate[1]
        return coherenceMatch && hrMatch && breathingMatch
    }
}

// MARK: - Numerology Mapping Model

/// Maps numerological numbers to consciousness zones and properties
struct NumerologyMapping: Codable {
    let zone: String
    let baselineFrequency: Double
    let description: String
    let zoneModifier: Double
    let color: String
    let chakra: String?
    let archetypalQualities: [String]?
    let hrvAmplifier: Double
    let specialProperties: [String]?
    let bridgeZones: [String]?

    enum CodingKeys: String, CodingKey {
        case zone, description, color, chakra
        case baselineFrequency = "baseline_frequency"
        case zoneModifier = "zone_modifier"
        case archetypalQualities = "archetypal_qualities"
        case hrvAmplifier = "hrv_amplifier"
        case specialProperties = "special_properties"
        case bridgeZones = "bridge_zones"
    }

    /// Check if this is a master number
    var isMasterNumber: Bool {
        specialProperties != nil && !specialProperties!.isEmpty
    }

    /// Get the primary archetype
    var primaryArchetype: String {
        archetypalQualities?.first ?? "Seeker"
    }
}

// MARK: - Coherence Pattern Model

/// Represents HRV coherence patterns and their effects
struct CoherencePattern: Codable {
    let description: String
    let frequencyModifier: Double
    let hrvSignature: String

    enum CodingKeys: String, CodingKey {
        case description
        case frequencyModifier = "frequency_modifier"
        case hrvSignature = "hrv_signature"
    }
}

// MARK: - Complete Hawkins Model

/// Complete Hawkins consciousness mapping with numerology and biometrics
struct HawkinsConsciousnessModel: Codable {
    let consciousnessZones: [String: HawkinsConsciousnessZone]
    let numerologyMapping: [String: NumerologyMapping]
    let biometricFusionAlgorithm: BiometricFusionAlgorithm
    let coherencePatterns: [String: CoherencePattern]
    let visualizationConfig: VisualizationConfig

    enum CodingKeys: String, CodingKey {
        case consciousnessZones = "consciousness_zones"
        case numerologyMapping = "numerology_mapping"
        case biometricFusionAlgorithm = "biometric_fusion_algorithm"
        case coherencePatterns = "coherence_patterns"
        case visualizationConfig = "visualization_config"
    }
}

/// Biometric fusion algorithm configuration
struct BiometricFusionAlgorithm: Codable {
    let baseCalculation: String
    let modifiers: Modifiers
    let personalization: Personalization

    enum CodingKeys: String, CodingKey {
        case baseCalculation = "base_calculation"
        case modifiers, personalization
    }

    struct Modifiers: Codable {
        let heartRateVariance: [String: Double]
        let mindfulnessMinutes: MindfulnessFormula
        let activityLevel: [String: Double]

        enum CodingKeys: String, CodingKey {
            case heartRateVariance = "heart_rate_variance"
            case mindfulnessMinutes = "mindfulness_minutes"
            case activityLevel = "activity_level"
        }
    }

    struct MindfulnessFormula: Codable {
        let formula: String
    }

    struct Personalization: Codable {
        let baselineCalibrationPeriodDays: Int
        let userSpecificWeights: UserWeights

        enum CodingKeys: String, CodingKey {
            case baselineCalibrationPeriodDays = "baseline_calibration_period_days"
            case userSpecificWeights = "user_specific_weights"
        }
    }

    struct UserWeights: Codable {
        let hrvWeight: Double
        let numerologyWeight: Double
        let cosmicWeight: Double
        let patternWeight: Double

        enum CodingKeys: String, CodingKey {
            case hrvWeight = "hrv_weight"
            case numerologyWeight = "numerology_weight"
            case cosmicWeight = "cosmic_weight"
            case patternWeight = "pattern_weight"
        }
    }
}

/// Visualization configuration for consciousness display
struct VisualizationConfig: Codable {
    let frequencyMeter: FrequencyMeterConfig
    let coherenceDisplay: CoherenceDisplayConfig
    let sacredGeometry: SacredGeometryConfig

    enum CodingKeys: String, CodingKey {
        case frequencyMeter = "frequency_meter"
        case coherenceDisplay = "coherence_display"
        case sacredGeometry = "sacred_geometry"
    }

    struct FrequencyMeterConfig: Codable {
        let min: Double
        let max: Double
        let logarithmicScale: Bool
        let colorGradient: String
        let animationSpeed: Double

        enum CodingKeys: String, CodingKey {
            case min, max
            case logarithmicScale = "logarithmic_scale"
            case colorGradient = "color_gradient"
            case animationSpeed = "animation_speed"
        }
    }

    struct CoherenceDisplayConfig: Codable {
        let waveformType: String
        let colorMapping: String
        let particleEffects: Bool

        enum CodingKeys: String, CodingKey {
            case waveformType = "waveform_type"
            case colorMapping = "color_mapping"
            case particleEffects = "particle_effects"
        }
    }

    struct SacredGeometryConfig: Codable {
        let patterns: [String]
        let rotationSpeed: String
        let opacity: String

        enum CodingKeys: String, CodingKey {
            case patterns
            case rotationSpeed = "rotation_speed"
            case opacity
        }
    }
}

// MARK: - Hawkins Manager

/// Manages Hawkins consciousness mapping and calculations
@MainActor
class HawkinsConsciousnessManager: ObservableObject {

    // MARK: - Published Properties

    @Published var currentZone: HawkinsConsciousnessZone?
    @Published var currentFrequency: Double = 200.0
    @Published var coherenceLevel: CoherencePattern?
    @Published var isCalibrating: Bool = false

    // MARK: - Private Properties

    private var model: HawkinsConsciousnessModel?
    private let jsonDecoder = JSONDecoder()

    // MARK: - Singleton

    static let shared = HawkinsConsciousnessManager()

    private init() {
        loadModel()
    }

    // MARK: - Model Loading

    /// Load the Hawkins consciousness model from JSON
    private func loadModel() {
        guard let url = Bundle.main.url(forResource: "HawkinsNumerologyMapping", withExtension: "json") else {
            print("❌ Hawkins: Could not find HawkinsNumerologyMapping.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            model = try jsonDecoder.decode(HawkinsConsciousnessModel.self, from: data)
            print("✅ Hawkins: Model loaded successfully")
        } catch {
            print("❌ Hawkins: Failed to decode model: \(error)")
        }
    }

    // MARK: - Consciousness Calculation

    /// Calculate consciousness frequency using numerology and biometrics
    func calculateConsciousness(
        numerologyNumber: Int,
        hrvCoherence: Double,
        heartRateElevation: Double,
        breathingRate: Double,
        mindfulnessMinutes: Int = 0,
        activityLevel: String = "sedentary"
    ) -> Double {

        guard let model = model else {
            print("⚠️ Hawkins: Model not loaded, returning default")
            return 200.0
        }

        // Get numerology mapping
        let numberKey = String(numerologyNumber)
        guard let numerologyMap = model.numerologyMapping[numberKey] else {
            print("⚠️ Hawkins: No mapping for number \(numerologyNumber)")
            return 200.0
        }

        // Start with baseline frequency
        var frequency = numerologyMap.baselineFrequency

        // Apply HRV coherence modifier (0-1 scale maps to 0-200 Hz boost)
        frequency += hrvCoherence * 200

        // Apply breathing coherence (slower breathing = higher consciousness)
        let breathingCoherence = max(0, (20 - breathingRate) / 20)
        frequency += breathingCoherence * 50

        // Apply numerology zone modifier
        frequency *= numerologyMap.zoneModifier

        // Apply HRV amplifier from numerology
        frequency *= numerologyMap.hrvAmplifier

        // Add mindfulness bonus (logarithmic scale)
        let mindfulnessBonus = log(Double(mindfulnessMinutes + 1)) * 20
        frequency += mindfulnessBonus

        // Apply activity level adjustment
        if let activityModifier = model.biometricFusionAlgorithm.modifiers.activityLevel[activityLevel] {
            frequency += activityModifier
        }

        // Apply heart rate variance penalty
        let hrVariance: String
        if heartRateElevation < 0 {
            hrVariance = "low"
        } else if heartRateElevation > 15 {
            hrVariance = "high"
        } else {
            hrVariance = "normal"
        }

        if let hrModifier = model.biometricFusionAlgorithm.modifiers.heartRateVariance[hrVariance] {
            frequency += hrModifier
        }

        // Clamp to valid range
        frequency = max(20, min(1000, frequency))

        // Update current zone
        updateCurrentZone(for: frequency)

        // Update coherence pattern
        updateCoherencePattern(hrvCoherence: hrvCoherence)

        self.currentFrequency = frequency

        print("🎯 Hawkins: Calculated frequency = \(Int(frequency)) Hz")
        print("   Number: \(numerologyNumber) → Base: \(numerologyMap.baselineFrequency)")
        print("   HRV Coherence: \(String(format: "%.2f", hrvCoherence)) → +\(Int(hrvCoherence * 200))")
        print("   Breathing: \(Int(breathingRate)) bpm → +\(Int(breathingCoherence * 50))")
        print("   Zone: \(currentZone?.description ?? "Unknown")")

        return frequency
    }

    // MARK: - Zone Detection

    /// Update current consciousness zone based on frequency
    private func updateCurrentZone(for frequency: Double) {
        guard let model = model else { return }

        for (_, zone) in model.consciousnessZones {
            if frequency >= zone.range[0] && frequency < zone.range[1] {
                currentZone = zone
                break
            }
        }
    }

    /// Update coherence pattern based on HRV coherence score
    private func updateCoherencePattern(hrvCoherence: Double) {
        guard let model = model else { return }

        let pattern: String
        switch hrvCoherence {
        case 0..<0.3:
            pattern = "incoherent"
        case 0.3..<0.6:
            pattern = "transitional"
        case 0.6..<0.85:
            pattern = "coherent"
        default:
            pattern = "super_coherent"
        }

        coherenceLevel = model.coherencePatterns[pattern]
    }

    // MARK: - Zone Information

    /// Get consciousness zone for a specific frequency
    func getZone(for frequency: Double) -> HawkinsConsciousnessZone? {
        guard let model = model else { return nil }

        for (_, zone) in model.consciousnessZones {
            if frequency >= zone.range[0] && frequency < zone.range[1] {
                return zone
            }
        }
        return nil
    }

    /// Get numerology mapping for a specific number
    func getNumerologyMapping(for number: Int) -> NumerologyMapping? {
        guard let model = model else { return nil }
        return model.numerologyMapping[String(number)]
    }

    /// Get color for consciousness frequency
    func getFrequencyColor(_ frequency: Double) -> Color {
        let zone = getZone(for: frequency)
        return zone?.swiftUIColor ?? .gray
    }

    /// Get gradient for consciousness frequency
    func getFrequencyGradient(_ frequency: Double) -> LinearGradient {
        let zone = getZone(for: frequency)
        return zone?.swiftUIGradient ?? LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize Color from hex string
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        if length == 6 {
            let r = Double((rgb & 0xFF0000) >> 16) / 255.0
            let g = Double((rgb & 0x00FF00) >> 8) / 255.0
            let b = Double(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b)
        } else if length == 8 {
            let r = Double((rgb & 0xFF000000) >> 24) / 255.0
            let g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            let b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            let a = Double(rgb & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, opacity: a)
        } else {
            return nil
        }
    }
}
