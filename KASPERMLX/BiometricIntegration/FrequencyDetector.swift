import Foundation
import HealthKit
import Accelerate

/**
 * Frequency Detector - Real-time Biometric Consciousness Analysis
 * ===============================================================
 *
 * Processes Apple Watch biometric data to detect consciousness frequency
 * using HRV coherence analysis, breathing patterns, and emotional state inference.
 *
 * ## Scientific Foundation
 *
 * Based on HeartMath Institute research showing:
 * - Positive emotions (love, gratitude) → smooth, sine-wave HRV patterns
 * - Negative emotions (anger, frustration) → erratic, jagged HRV patterns
 * - Coherence peak at ~0.1 Hz indicates optimal psychophysiological state
 *
 * ## Technical Implementation
 *
 * 1. **HRV Data Collection**: Fetches HKHeartbeatSeries for beat-to-beat intervals
 * 2. **Spectral Analysis**: FFT to compute power spectrum of IBI time series
 * 3. **Coherence Scoring**: Ratio of peak power to total power in 0.04-0.26 Hz band
 * 4. **Pattern Recognition**: Identifies coherent vs incoherent heart rhythms
 * 5. **Frequency Mapping**: Converts biometric patterns to consciousness frequency
 *
 * ## Privacy & Performance
 *
 * - All processing on-device using Accelerate framework
 * - No data leaves device (HealthKit privacy preserved)
 * - <100ms processing time for real-time feedback
 * - Battery efficient (<3% drain target)
 *
 * Created: August 2025
 * Version: 1.0.0 - Initial biometric integration
 */

// MARK: - Biometric Data Models

/// Represents a single heartbeat interval measurement
struct HeartbeatInterval {
    let timestamp: Date
    let interval: TimeInterval  // Time since previous beat in seconds
    let confidence: Double      // 0-1 confidence score from sensor
}

/// HRV coherence analysis result
struct CoherenceAnalysis {
    let coherenceScore: Double        // 0-1 coherence level
    let dominantFrequency: Double     // Peak frequency in Hz
    let powerRatio: Double            // Peak power / total power
    let pattern: HRVPattern
    let timestamp: Date

    enum HRVPattern {
        case incoherent     // Erratic, stress pattern
        case transitional   // Moving toward coherence
        case coherent       // Smooth sine-wave pattern
        case superCoherent  // Perfect resonance state

        var description: String {
            switch self {
            case .incoherent: return "Stress/Frustration Pattern"
            case .transitional: return "Transitioning to Balance"
            case .coherent: return "Positive Emotional State"
            case .superCoherent: return "Peak Performance State"
            }
        }

        var frequencyModifier: Double {
            switch self {
            case .incoherent: return -100
            case .transitional: return 0
            case .coherent: return 100
            case .superCoherent: return 200
            }
        }
    }
}

/// Breathing pattern analysis
struct BreathingAnalysis {
    let rate: Double           // Breaths per minute
    let depth: Double          // Relative breathing depth 0-1
    let coherence: Double      // Breathing regularity 0-1
    let pattern: BreathingPattern

    enum BreathingPattern {
        case shallow        // Stress breathing
        case normal         // Regular breathing
        case deep           // Relaxed breathing
        case resonant       // Coherent breathing (4-7 bpm)

        var frequencyBoost: Double {
            switch self {
            case .shallow: return -20
            case .normal: return 0
            case .deep: return 30
            case .resonant: return 50
            }
        }
    }
}

// MARK: - Frequency Detector

/// Detects consciousness frequency from biometric data
@MainActor
class FrequencyDetector: ObservableObject {

    // MARK: - Published Properties

    @Published var currentCoherence: CoherenceAnalysis?
    @Published var currentBreathing: BreathingAnalysis?
    @Published var detectedFrequency: Double = 200.0
    @Published var isMonitoring: Bool = false
    @Published var lastUpdate: Date = Date()

    // MARK: - Private Properties

    private let healthStore = HKHealthStore()
    private var heartbeatBuffer: [HeartbeatInterval] = []
    private let bufferSize = 60  // 60 seconds of data
    private var updateTimer: Timer?

    // FFT Configuration
    private let fftSetup: FFTSetup
    private let log2n = vDSP_Length(10)  // 1024 points
    private let n = 1024

    // Coherence bands (HeartMath standard)
    private let vlfBand = (0.003, 0.04)   // Very Low Frequency
    private let lfBand = (0.04, 0.15)     // Low Frequency
    private let hfBand = (0.15, 0.4)      // High Frequency
    private let coherenceBand = (0.04, 0.26)  // Coherence calculation band

    // MARK: - Singleton

    static let shared = FrequencyDetector()

    private init() {
        // Initialize FFT
        fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))!
        requestHealthKitAuthorization()
    }

    deinit {
        vDSP_destroy_fftsetup(fftSetup)
    }

    // MARK: - HealthKit Authorization

    /// Request permission to access heart rate and HRV data
    private func requestHealthKitAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKSeriesType.heartbeat(),
            HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("✅ FrequencyDetector: HealthKit authorized")
            } else {
                print("❌ FrequencyDetector: HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown")")
            }
        }
    }

    // MARK: - Monitoring Control

    /// Start real-time biometric monitoring
    func startMonitoring() {
        isMonitoring = true

        // Start heartbeat series query for real-time HRV
        startHeartbeatSeriesQuery()

        // Start update timer for periodic analysis
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                await self.analyzeCurrentState()
            }
        }

        print("🎯 FrequencyDetector: Monitoring started")
    }

    /// Stop biometric monitoring
    func stopMonitoring() {
        isMonitoring = false
        updateTimer?.invalidate()
        updateTimer = nil
        heartbeatBuffer.removeAll()

        print("🛑 FrequencyDetector: Monitoring stopped")
    }

    // MARK: - Heartbeat Data Collection

    /// Start querying for heartbeat series data
    private func startHeartbeatSeriesQuery() {
        let heartbeatType = HKSeriesType.heartbeat()

        // Query for recent heartbeat data
        let query = HKSampleQuery(
            sampleType: heartbeatType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        ) { _, samples, error in
            guard let heartbeatSeries = samples?.first as? HKHeartbeatSeriesSample else {
                print("⚠️ FrequencyDetector: No heartbeat data available")
                return
            }

            self.processHeartbeatSeries(heartbeatSeries)
        }

        healthStore.execute(query)
    }

    /// Process heartbeat series to extract intervals
    private func processHeartbeatSeries(_ series: HKHeartbeatSeriesSample) {
        let query = HKHeartbeatSeriesQuery(heartbeatSeries: series) { _, timeSinceStart, precededByGap, done, error in

            if let error = error {
                print("❌ FrequencyDetector: Heartbeat query error: \(error)")
                return
            }

            // Add to buffer if not preceded by gap (continuous data)
            if !precededByGap {
                let interval = HeartbeatInterval(
                    timestamp: series.startDate.addingTimeInterval(timeSinceStart),
                    interval: timeSinceStart,
                    confidence: 1.0
                )

                Task { @MainActor in
                    self.addHeartbeatInterval(interval)
                }
            }

            if done {
                Task { @MainActor in
                    await self.analyzeHeartbeatBuffer()
                }
            }
        }

        healthStore.execute(query)
    }

    /// Add heartbeat interval to buffer
    private func addHeartbeatInterval(_ interval: HeartbeatInterval) {
        heartbeatBuffer.append(interval)

        // Maintain buffer size
        if heartbeatBuffer.count > bufferSize {
            heartbeatBuffer.removeFirst()
        }
    }

    // MARK: - HRV Coherence Analysis

    /// Analyze heartbeat buffer for HRV coherence
    private func analyzeHeartbeatBuffer() async {
        guard heartbeatBuffer.count >= 30 else {
            print("⚠️ FrequencyDetector: Insufficient heartbeat data")
            return
        }

        // Extract inter-beat intervals (IBI)
        let ibis = heartbeatBuffer.map { $0.interval * 1000 }  // Convert to milliseconds

        // Compute HRV coherence using spectral analysis
        let coherence = computeCoherence(ibis: ibis)

        // Determine HRV pattern
        let pattern = determineHRVPattern(coherence: coherence.score)

        // Create analysis result
        currentCoherence = CoherenceAnalysis(
            coherenceScore: coherence.score,
            dominantFrequency: coherence.peakFrequency,
            powerRatio: coherence.powerRatio,
            pattern: pattern,
            timestamp: Date()
        )

        print("📊 FrequencyDetector: HRV Coherence = \(String(format: "%.2f", coherence.score))")
        print("   Pattern: \(pattern.description)")
        print("   Peak: \(String(format: "%.3f", coherence.peakFrequency)) Hz")
    }

    /// Compute coherence score from IBI data
    private func computeCoherence(ibis: [Double]) -> (score: Double, peakFrequency: Double, powerRatio: Double) {
        // Prepare data for FFT
        var realPart = ibis
        var imagPart = [Double](repeating: 0.0, count: ibis.count)

        // Pad to power of 2 if needed
        let paddedCount = 1 << Int(ceil(log2(Double(ibis.count))))
        if realPart.count < paddedCount {
            realPart.append(contentsOf: [Double](repeating: 0.0, count: paddedCount - realPart.count))
            imagPart.append(contentsOf: [Double](repeating: 0.0, count: paddedCount - imagPart.count))
        }

        // Perform FFT
        var splitComplex = DSPDoubleSplitComplex(
            realp: UnsafeMutablePointer(mutating: realPart),
            imagp: UnsafeMutablePointer(mutating: imagPart)
        )

        let log2n = vDSP_Length(log2(Double(paddedCount)))
        vDSP_fft_zripD(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

        // Calculate power spectrum
        var powerSpectrum = [Double](repeating: 0.0, count: paddedCount/2)
        vDSP_zvmagsD(&splitComplex, 1, &powerSpectrum, 1, vDSP_Length(paddedCount/2))

        // Find peak in coherence band (0.04-0.26 Hz)
        let samplingRate = 1.0 / (ibis.reduce(0, +) / Double(ibis.count) / 1000.0)  // Hz
        let freqResolution = samplingRate / Double(paddedCount)

        let coherenceStartBin = Int(coherenceBand.0 / freqResolution)
        let coherenceEndBin = Int(coherenceBand.1 / freqResolution)

        // Find peak power in coherence band
        let coherencePower = Array(powerSpectrum[coherenceStartBin...min(coherenceEndBin, powerSpectrum.count-1)])
        let peakPower = coherencePower.max() ?? 0
        let peakIndex = coherencePower.firstIndex(of: peakPower) ?? 0
        let peakFrequency = (Double(coherenceStartBin + peakIndex) * freqResolution)

        // Calculate total power
        let totalPower = powerSpectrum.reduce(0, +)

        // Coherence score (HeartMath formula)
        let powerRatio = totalPower > 0 ? peakPower / totalPower : 0
        let coherenceScore = min(1.0, powerRatio * 10)  // Scale to 0-1

        return (coherenceScore, peakFrequency, powerRatio)
    }

    /// Determine HRV pattern from coherence score
    private func determineHRVPattern(coherence: Double) -> CoherenceAnalysis.HRVPattern {
        switch coherence {
        case 0..<0.3:
            return .incoherent
        case 0.3..<0.6:
            return .transitional
        case 0.6..<0.85:
            return .coherent
        default:
            return .superCoherent
        }
    }

    // MARK: - Breathing Analysis

    /// Analyze breathing patterns from heart rate variations
    private func analyzeBreathing() async -> BreathingAnalysis {
        // Respiratory sinus arrhythmia (RSA) analysis
        // Heart rate increases on inhale, decreases on exhale

        guard !heartbeatBuffer.isEmpty else {
            return BreathingAnalysis(
                rate: 12,
                depth: 0.5,
                coherence: 0.5,
                pattern: .normal
            )
        }

        // Estimate breathing rate from HRV high-frequency band (0.15-0.4 Hz)
        // This corresponds to 9-24 breaths per minute
        let breathingRate = estimateBreathingRate()

        // Determine breathing pattern
        let pattern: BreathingAnalysis.BreathingPattern
        switch breathingRate {
        case 4..<8:
            pattern = .resonant  // Optimal coherent breathing
        case 8..<12:
            pattern = .deep      // Relaxed breathing
        case 12..<18:
            pattern = .normal    // Normal breathing
        default:
            pattern = .shallow   // Stress breathing
        }

        // Calculate breathing coherence (regularity)
        let coherence = calculateBreathingCoherence(rate: breathingRate)

        return BreathingAnalysis(
            rate: breathingRate,
            depth: 0.7,  // Placeholder - would need respiratory sensor
            coherence: coherence,
            pattern: pattern
        )
    }

    /// Estimate breathing rate from HRV data
    private func estimateBreathingRate() -> Double {
        // Simplified estimation: breathing typically causes HRV in 0.15-0.4 Hz band
        // Peak in this band corresponds to breathing rate

        guard let coherence = currentCoherence else { return 12.0 }

        // If dominant frequency is in HF band, it's likely breathing
        if coherence.dominantFrequency >= 0.15 && coherence.dominantFrequency <= 0.4 {
            return coherence.dominantFrequency * 60  // Convert Hz to breaths per minute
        }

        // Default to normal breathing rate
        return 12.0
    }

    /// Calculate breathing coherence/regularity
    private func calculateBreathingCoherence(rate: Double) -> Double {
        // Resonant breathing (4-7 bpm) has highest coherence
        if rate >= 4 && rate <= 7 {
            return 0.9
        } else if rate >= 8 && rate <= 12 {
            return 0.7
        } else if rate >= 12 && rate <= 16 {
            return 0.5
        } else {
            return 0.3
        }
    }

    // MARK: - Frequency Detection

    /// Analyze current biometric state and detect frequency
    private func analyzeCurrentState() async {
        // Analyze HRV if buffer has data
        if !heartbeatBuffer.isEmpty {
            await analyzeHeartbeatBuffer()
        }

        // Analyze breathing patterns
        currentBreathing = await analyzeBreathing()

        // Calculate consciousness frequency
        detectedFrequency = calculateFrequency()

        // Update timestamp
        lastUpdate = Date()

        print("🎯 FrequencyDetector: Updated frequency = \(Int(detectedFrequency)) Hz")
    }

    /// Calculate consciousness frequency from biometric data
    private func calculateFrequency() -> Double {
        var frequency = 200.0  // Default baseline

        // Apply HRV coherence modifier
        if let coherence = currentCoherence {
            frequency += coherence.coherenceScore * 200  // 0-200 Hz boost
            frequency += coherence.pattern.frequencyModifier
        }

        // Apply breathing pattern modifier
        if let breathing = currentBreathing {
            frequency += breathing.pattern.frequencyBoost
            frequency += breathing.coherence * 50  // Breathing regularity bonus
        }

        // Clamp to valid range
        frequency = max(20, min(1000, frequency))

        return frequency
    }

    // MARK: - Public API

    /// Get current biometric-based frequency
    func getCurrentFrequency() -> Double {
        return detectedFrequency
    }

    /// Get current HRV coherence score (0-1)
    func getCoherenceScore() -> Double {
        return currentCoherence?.coherenceScore ?? 0.5
    }

    /// Get heart rate elevation from baseline
    func getHeartRateElevation() async -> Double {
        // Query recent heart rate data
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: heartRateType,
                quantitySamplePredicate: nil,
                options: [.discreteAverage]
            ) { _, statistics, _ in
                let avgHeartRate = statistics?.averageQuantity()?.doubleValue(for: .count().unitDivided(by: .minute())) ?? 70
                let baseline = 70.0  // Typical resting heart rate
                let elevation = avgHeartRate - baseline
                continuation.resume(returning: elevation)
            }

            healthStore.execute(query)
        }
    }

    /// Get current breathing rate
    func getBreathingRate() -> Double {
        return currentBreathing?.rate ?? 12.0
    }
}
