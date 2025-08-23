import Foundation
import SwiftUI
import Combine

/**
 * Consciousness Mapper - Numerology & Biometric Fusion Engine
 * ===========================================================
 *
 * Bridges the gap between ancient numerological wisdom and modern biometric science,
 * creating a unified consciousness frequency that honors both spiritual archetypes
 * and physiological states.
 *
 * ## Fusion Algorithm
 *
 * The mapper combines multiple data streams:
 * 1. **Numerological Foundation**: Sacred numbers provide baseline frequencies
 * 2. **Biometric Modulation**: Real-time HRV/breathing adjusts the frequency
 * 3. **Cosmic Influences**: Planetary positions add harmonic resonance
 * 4. **Pattern Amplification**: Sacred patterns (Fibonacci, Tesla) boost signal
 *
 * ## Weighted Integration Formula
 *
 * frequency = (numerology_base * 0.3) + (biometric_freq * 0.4) +
 *            (cosmic_modifier * 0.2) + (pattern_bonus * 0.1)
 *
 * These weights are adjustable per user based on calibration period data.
 *
 * ## Personalization
 *
 * The system learns from each user over a 14-day baseline period:
 * - Tracks correlation between numerology and biometric states
 * - Adjusts weights based on user's responsiveness to different inputs
 * - Creates personalized frequency ranges for optimal guidance
 *
 * Created: August 2025
 * Version: 1.0.0 - Initial consciousness mapping system
 */

// MARK: - Consciousness State Model

/// Represents the complete consciousness state of a user
struct ConsciousnessState {
    // Core Components
    let numerologicalNumber: Int
    let biometricFrequency: Double
    let cosmicModifier: Double
    let patternBonus: Double

    // Calculated Values
    let fusedFrequency: Double
    let consciousnessZone: String
    let dominantArchetype: String
    let guidancePersona: String

    // Metadata
    let timestamp: Date
    let confidence: Double  // 0-1 confidence in the calculation

    /// Get color representation of consciousness state
    var color: Color {
        HawkinsConsciousnessManager.shared.getFrequencyColor(fusedFrequency)
    }

    /// Get gradient for visualization
    var gradient: LinearGradient {
        HawkinsConsciousnessManager.shared.getFrequencyGradient(fusedFrequency)
    }

    /// Human-readable description of state
    var description: String {
        "\(dominantArchetype) in \(consciousnessZone) zone at \(Int(fusedFrequency)) VHz"
    }
}

// MARK: - Calibration Data

/// Stores user calibration data for personalization
struct CalibrationData: Codable {
    let userId: String
    let startDate: Date
    var dataPoints: [CalibrationPoint]
    var completedDays: Int

    struct CalibrationPoint: Codable {
        let timestamp: Date
        let numerologyNumber: Int
        let biometricFrequency: Double
        let userMood: String?  // Optional user-reported state
        let activityLevel: String
    }

    /// Check if calibration period is complete
    var isComplete: Bool {
        completedDays >= 14
    }

    /// Calculate personalized weights from calibration data
    func calculateWeights() -> PersonalizedWeights {
        // Analyze correlation between inputs and user-reported states
        // This is simplified - in production would use ML model

        let hasStrongNumerology = dataPoints.filter { point in
            point.userMood == "positive" && point.numerologyNumber >= 6
        }.count > dataPoints.count / 2

        let hasStrongBiometric = dataPoints.filter { point in
            point.biometricFrequency > 400
        }.count > dataPoints.count / 2

        return PersonalizedWeights(
            numerologyWeight: hasStrongNumerology ? 0.35 : 0.25,
            biometricWeight: hasStrongBiometric ? 0.45 : 0.35,
            cosmicWeight: 0.2,
            patternWeight: 0.1
        )
    }
}

/// Personalized weights for consciousness calculation
struct PersonalizedWeights {
    let numerologyWeight: Double
    let biometricWeight: Double
    let cosmicWeight: Double
    let patternWeight: Double

    /// Ensure weights sum to 1.0
    var normalized: PersonalizedWeights {
        let sum = numerologyWeight + biometricWeight + cosmicWeight + patternWeight
        guard sum > 0 else { return self }

        return PersonalizedWeights(
            numerologyWeight: numerologyWeight / sum,
            biometricWeight: biometricWeight / sum,
            cosmicWeight: cosmicWeight / sum,
            patternWeight: patternWeight / sum
        )
    }
}

// MARK: - Consciousness Mapper

/// Maps numerology and biometrics to unified consciousness state
@MainActor
class ConsciousnessMapper: ObservableObject {

    // MARK: - Published Properties

    @Published var currentState: ConsciousnessState?
    @Published var isCalibrating: Bool = false
    @Published var calibrationProgress: Double = 0.0  // 0-1
    @Published var personalizedWeights: PersonalizedWeights

    // MARK: - Dependencies

    private let hawkinsManager = HawkinsConsciousnessManager.shared
    private let frequencyDetector = FrequencyDetector.shared
    private let cosmicHUDManager = CosmicHUDManager.shared
    private let focusNumberManager = FocusNumberManager.shared

    // MARK: - Private Properties

    private var calibrationData: CalibrationData?
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    // Default weights (before calibration)
    private let defaultWeights = PersonalizedWeights(
        numerologyWeight: 0.3,
        biometricWeight: 0.4,
        cosmicWeight: 0.2,
        patternWeight: 0.1
    )

    // MARK: - Singleton

    static let shared = ConsciousnessMapper()

    private init() {
        self.personalizedWeights = defaultWeights
        loadCalibrationData()
        setupObservers()
    }

    // MARK: - Setup

    /// Set up observers for real-time updates
    private func setupObservers() {
        // Observe focus number changes
        focusNumberManager.$selectedFocusNumber
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.updateConsciousnessState()
                }
            }
            .store(in: &cancellables)

        // Observe HUD data changes (cosmic influences)
        cosmicHUDManager.$currentHUDData
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.updateConsciousnessState()
                }
            }
            .store(in: &cancellables)

        // Start periodic updates
        updateTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            Task { @MainActor in
                await self.updateConsciousnessState()
            }
        }
    }

    // MARK: - Consciousness Calculation

    /// Update the current consciousness state
    func updateConsciousnessState() async {
        // Get all input data
        let numerologyNumber = getNumerologyNumber()
        let biometricFreq = await getBiometricFrequency()
        let cosmicMod = getCosmicModifier()
        let patternBonus = calculatePatternBonus(number: numerologyNumber)

        // Apply weighted fusion
        let weights = personalizedWeights.normalized
        let fusedFrequency = (
            Double(numerologyNumber) * 100 * weights.numerologyWeight +
            biometricFreq * weights.biometricWeight +
            cosmicMod * weights.cosmicWeight +
            patternBonus * weights.patternWeight
        )

        // Get consciousness zone and archetype
        let zone = hawkinsManager.getZone(for: fusedFrequency)
        let mapping = hawkinsManager.getNumerologyMapping(for: numerologyNumber)

        // Determine guidance persona based on frequency and archetype
        let persona = selectGuidancePersona(
            frequency: fusedFrequency,
            archetype: mapping?.primaryArchetype ?? "Seeker"
        )

        // Calculate confidence based on data availability
        let confidence = calculateConfidence(
            hasBiometric: biometricFreq != 200.0,
            hasCosmic: cosmicMod != 0.0,
            hasCalibration: calibrationData?.isComplete ?? false
        )

        // Create new consciousness state
        currentState = ConsciousnessState(
            numerologicalNumber: numerologyNumber,
            biometricFrequency: biometricFreq,
            cosmicModifier: cosmicMod,
            patternBonus: patternBonus,
            fusedFrequency: fusedFrequency,
            consciousnessZone: zone?.description ?? "Unknown",
            dominantArchetype: mapping?.primaryArchetype ?? "Seeker",
            guidancePersona: persona,
            timestamp: Date(),
            confidence: confidence
        )

        // Add to calibration data if calibrating
        if isCalibrating {
            addCalibrationPoint(
                numerology: numerologyNumber,
                biometric: biometricFreq
            )
        }

        print("🧬 ConsciousnessMapper: State updated")
        print("   Numerology: \(numerologyNumber) → \(mapping?.description ?? "Unknown")")
        print("   Biometric: \(Int(biometricFreq)) Hz")
        print("   Cosmic: +\(Int(cosmicMod)) Hz")
        print("   Pattern: +\(Int(patternBonus)) Hz")
        print("   FUSED: \(Int(fusedFrequency)) VHz → \(zone?.description ?? "Unknown")")
        print("   Persona: \(persona)")
        print("   Confidence: \(String(format: "%.0f", confidence * 100))%")
    }

    // MARK: - Data Gathering

    /// Get current numerology number (combining focus, realm, ruler)
    private func getNumerologyNumber() -> Int {
        let focus = focusNumberManager.selectedFocusNumber
        let realm = cosmicHUDManager.getCurrentRealmNumber()
        let ruler = cosmicHUDManager.getCurrentRulerNumber()

        // Master synthesis: reduce to singularity
        let sum = focus + realm + ruler
        return reduceToSingularity(sum)
    }

    /// Get biometric frequency from FrequencyDetector
    private func getBiometricFrequency() async -> Double {
        // Start monitoring if not already
        if !frequencyDetector.isMonitoring {
            frequencyDetector.startMonitoring()

            // Wait for initial data
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 2 seconds
        }

        // Get current frequency from biometrics
        let coherence = frequencyDetector.getCoherenceScore()
        let heartRateElevation = await frequencyDetector.getHeartRateElevation()
        let breathingRate = frequencyDetector.getBreathingRate()

        // Use Hawkins model to calculate frequency
        return hawkinsManager.calculateConsciousness(
            numerologyNumber: getNumerologyNumber(),
            hrvCoherence: coherence,
            heartRateElevation: heartRateElevation,
            breathingRate: breathingRate,
            mindfulnessMinutes: getMindfulnessMinutes(),
            activityLevel: getActivityLevel()
        )
    }

    /// Get cosmic modifier from HUD manager
    private func getCosmicModifier() -> Double {
        // Get VFI from HUD (already includes cosmic calculations)
        guard let hudData = cosmicHUDManager.currentHUDData else { return 0.0 }

        // Extract cosmic component (VFI - base calculation)
        let baseVFI = Double(getNumerologyNumber() * 100)
        let cosmicComponent = hudData.vfi - baseVFI

        return max(0, cosmicComponent)  // Only positive modifiers
    }

    /// Calculate pattern bonus for sacred numbers
    private func calculatePatternBonus(number: Int) -> Double {
        var bonus = 0.0

        // Fibonacci numbers
        let fibonacci = [1, 2, 3, 5, 8]
        if fibonacci.contains(number) {
            bonus += 30
        }

        // Tesla 3-6-9
        let tesla = [3, 6, 9]
        if tesla.contains(number) {
            bonus += 40
        }

        // Prime numbers
        let primes = [2, 3, 5, 7]
        if primes.contains(number) {
            bonus += 20
        }

        // Master numbers get special bonus
        let masters = [11, 22, 33, 44, 55, 66, 77]
        if masters.contains(number) {
            bonus += 100
        }

        return bonus
    }

    // MARK: - Helper Methods

    /// Reduce number to singularity (1-9)
    private func reduceToSingularity(_ number: Int) -> Int {
        // Master numbers don't reduce
        let masters = [11, 22, 33, 44, 55, 66, 77]
        if masters.contains(number) {
            return number
        }

        var result = abs(number)
        while result > 9 {
            let digits = String(result).compactMap { Int(String($0)) }
            result = digits.reduce(0, +)
        }
        return max(result, 1)
    }

    /// Select guidance persona based on frequency and archetype
    private func selectGuidancePersona(frequency: Double, archetype: String) -> String {
        // Map frequency ranges to personas
        switch frequency {
        case 20..<200:
            return "Healer"  // Low frequency needs healing energy
        case 200..<400:
            return "Warrior"  // Building courage needs warrior energy
        case 400..<600:
            return "Sage"  // Love frequency benefits from wisdom
        case 600..<800:
            return "Mystic"  // Joy frequency ready for mystical insights
        case 800...:
            return "Oracle"  // Unity consciousness receives oracle wisdom
        default:
            return "Guide"  // Default spiritual guide
        }
    }

    /// Calculate confidence in the consciousness calculation
    private func calculateConfidence(hasBiometric: Bool, hasCosmic: Bool, hasCalibration: Bool) -> Double {
        var confidence = 0.5  // Base confidence

        if hasBiometric { confidence += 0.2 }
        if hasCosmic { confidence += 0.15 }
        if hasCalibration { confidence += 0.15 }

        return min(1.0, confidence)
    }

    /// Get mindfulness minutes for today
    private func getMindfulnessMinutes() -> Int {
        // Would query HealthKit for mindfulness sessions
        // Placeholder for now
        return 10
    }

    /// Get current activity level
    private func getActivityLevel() -> String {
        // Would query HealthKit/CoreMotion for activity
        // Placeholder for now
        return "light"
    }

    // MARK: - Calibration

    /// Start calibration period for personalization
    func startCalibration(userId: String) {
        calibrationData = CalibrationData(
            userId: userId,
            startDate: Date(),
            dataPoints: [],
            completedDays: 0
        )
        isCalibrating = true
        calibrationProgress = 0.0

        print("🎯 ConsciousnessMapper: Started 14-day calibration for user \(userId)")
    }

    /// Add calibration data point
    private func addCalibrationPoint(numerology: Int, biometric: Double) {
        guard var calibration = calibrationData else { return }

        let point = CalibrationData.CalibrationPoint(
            timestamp: Date(),
            numerologyNumber: numerology,
            biometricFrequency: biometric,
            userMood: nil,  // Would prompt user periodically
            activityLevel: getActivityLevel()
        )

        calibration.dataPoints.append(point)

        // Update progress
        let daysSinceStart = Calendar.current.dateComponents([.day], from: calibration.startDate, to: Date()).day ?? 0
        calibration.completedDays = daysSinceStart
        calibrationProgress = Double(daysSinceStart) / 14.0

        // Check if calibration complete
        if calibration.isComplete {
            completeCalibration(calibration)
        } else {
            calibrationData = calibration
            saveCalibrationData()
        }
    }

    /// Complete calibration and calculate personalized weights
    private func completeCalibration(_ calibration: CalibrationData) {
        personalizedWeights = calibration.calculateWeights()
        isCalibrating = false
        calibrationProgress = 1.0

        saveCalibrationData()

        print("✅ ConsciousnessMapper: Calibration complete!")
        print("   Personalized weights:")
        print("   - Numerology: \(String(format: "%.0f", personalizedWeights.numerologyWeight * 100))%")
        print("   - Biometric: \(String(format: "%.0f", personalizedWeights.biometricWeight * 100))%")
        print("   - Cosmic: \(String(format: "%.0f", personalizedWeights.cosmicWeight * 100))%")
        print("   - Pattern: \(String(format: "%.0f", personalizedWeights.patternWeight * 100))%")
    }

    // MARK: - Persistence

    /// Save calibration data to UserDefaults
    private func saveCalibrationData() {
        guard let calibration = calibrationData else { return }

        if let encoded = try? JSONEncoder().encode(calibration) {
            UserDefaults.standard.set(encoded, forKey: "ConsciousnessCalibration")
        }
    }

    /// Load calibration data from UserDefaults
    private func loadCalibrationData() {
        guard let data = UserDefaults.standard.data(forKey: "ConsciousnessCalibration"),
              let calibration = try? JSONDecoder().decode(CalibrationData.self, from: data) else {
            return
        }

        calibrationData = calibration

        if calibration.isComplete {
            personalizedWeights = calibration.calculateWeights()
            calibrationProgress = 1.0
        } else {
            calibrationProgress = Double(calibration.completedDays) / 14.0
            isCalibrating = true
        }
    }

    // MARK: - Public API

    /// Get current consciousness frequency
    func getCurrentFrequency() -> Double {
        return currentState?.fusedFrequency ?? 200.0
    }

    /// Get recommended persona for guidance
    func getGuidancePersona() -> String {
        return currentState?.guidancePersona ?? "Guide"
    }

    /// Get consciousness zone description
    func getConsciousnessZone() -> String {
        return currentState?.consciousnessZone ?? "Neutral"
    }

    /// Check if system is ready (has all data sources)
    func isReady() -> Bool {
        return currentState != nil && currentState!.confidence > 0.5
    }
}
