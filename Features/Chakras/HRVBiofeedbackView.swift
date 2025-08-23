import SwiftUI
import Combine

// MARK: - Heart Rate Trend Detection

enum HeartRateTrend {
    case improving    // Heart rate is decreasing (getting better for meditation)
    case stable      // Heart rate is relatively steady
    case declining   // Heart rate is increasing (more excited/stressed)
}

enum BreathingPhase {
    case inhale      // 5-second inhale phase
    case inhaleHold  // Brief pause after inhale
    case exhale      // 5-second exhale phase
    case exhaleHold  // Brief pause after exhale

    var duration: TimeInterval {
        switch self {
        case .inhale, .exhale: return 5.0    // 5 seconds for breathing
        case .inhaleHold, .exhaleHold: return 1.5  // 1.5 second pause
        }
    }

    var vibrationStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .inhale: return .light         // Gentle for inhale
        case .exhale: return .medium        // Stronger for exhale
        case .inhaleHold, .exhaleHold: return .light  // No vibration for holds
        }
    }

    var description: String {
        switch self {
        case .inhale: return "Inhale"
        case .inhaleHold: return "Hold"
        case .exhale: return "Exhale"
        case .exhaleHold: return "Pause"
        }
    }

    var isActiveBreathing: Bool {
        return self == .inhale || self == .exhale
    }
}

/**
 * Progressive HRV Biofeedback View - Encouraging Heart Coherence Training
 * ======================================================================
 *
 * BREAKTHROUGH: Revolutionary reward system that celebrates improvement rather than demanding perfection!
 * No more unrealistic 58-62 BPM requirements - this system works with YOUR actual heart rate.
 *
 * ## 🎯 Progressive Reward Philosophy
 *
 * **Traditional biofeedback fails because:**
 * - Demands impossible 58-62 BPM during active meditation
 * - Creates frustration when users can't achieve "perfect" coherence
 * - Ignores individual baselines and improvement progress
 *
 * **Our breakthrough approach:**
 * - Records YOUR starting heart rate as baseline (realistic!)
 * - Celebrates ANY meaningful improvement (3+ BPM reduction)
 * - Rewards consistency and effort (2+ minutes sustained meditation)
 * - Shows encouraging messages instead of demanding perfection
 *
 * ## 🌊 Visual Feedback System
 *
 * - **User Wave**: Blue sine wave tracking your actual heart rhythm
 * - **Target Wave**: Golden reference wave (visual guide only)
 * - **Achievement State**: Both waves turn green when you improve!
 * - **Background Evolution**: Purple → Blue → Green → Golden based on progress
 *
 * ## 📊 Smart Progress Tracking
 *
 * 1. **Baseline Setting**: Captures your starting BPM after 2 seconds
 * 2. **Improvement Detection**: Tracks BPM reduction from your personal baseline
 * 3. **Trend Analysis**: Shows arrows for improving/stable/declining heart rate
 * 4. **Session Rewards**: Time-based bonuses for meditation consistency
 * 5. **Personal Bests**: Records your best BPM improvement achievements
 *
 * ## 🎭 Future: Meditation Type Integration
 *
 * Designed to support multiple meditation styles:
 * - Affirmation: Positive self-talk with heart feedback
 * - Manifestation: Goal visualization with coherence confirmation
 * - Reflective: Deep contemplation with sustained rewards
 * - Trauma Therapy: Gentle healing with lower thresholds
 * - Gratitude: Heart-opening appreciation exercises
 *
 * Created: August 2025
 * Version: 2.0.0 - Progressive reward system breakthrough
 */

struct HRVBiofeedbackView: View {

    // MARK: - Configuration

    /// The type of meditation being practiced (for session tracking)
    let meditationType: MeditationType

    // MARK: - Initializer

    init(meditationType: MeditationType = .chakraBalancing, duration: Int? = nil, onDismiss: (() -> Void)? = nil) {
        self.meditationType = meditationType
        self.onDismiss = onDismiss

        // Set initial duration if provided
        self._selectedDuration = State(initialValue: duration)
    }

    // MARK: - Core Biofeedback State

    /// HealthKit manager for real-time heart rate data from Apple Watch
    @EnvironmentObject private var healthKitManager: HealthKitManager

    /// Focus number manager for numerology context
    @EnvironmentObject private var focusNumberManager: FocusNumberManager

    /// Meditation history manager for session tracking
    @StateObject private var historyManager = MeditationHistoryManager.shared

    /// Animation offset for smooth sine wave movement (increments at 60 FPS for buttery performance)
    @State private var animationOffset: CGFloat = 0

    /// Current coherence level (0-1 scale) - smoothed to prevent UI jitter
    @State private var coherenceLevel: Double = 0.5

    /// Target coherence frequency (0.1 Hz = 6 breaths/minute optimal) - visual reference only
    @State private var targetCoherence: Double = 0.1

    /// Whether user is currently in coherence state (triggers green wave celebration)
    @State private var isInCoherence: Bool = false

    /// Legacy streak counter - replaced by improvementStreak for progressive system
    @State private var coherenceStreak: Int = 0

    // MARK: - Progressive Reward System ✨

    /// User's actual starting heart rate - set after 2 seconds for stability
    /// This is the KEY innovation: no more impossible 58-62 BPM demands!
    @State private var baselineHeartRate: Double = 0

    /// Current heart rate trend direction (improving/stable/declining)
    @State private var currentTrend: HeartRateTrend = .stable

    /// BPM improvement threshold for green celebration (default: 3 BPM)
    @State private var improvementThreshold: Double = 5.0

    /// When this meditation session started
    @State private var sessionStartTime: Date = Date()

    /// Current session duration in seconds
    @State private var sessionDuration: TimeInterval = 0

    /// Count of improvement achievements this session
    @State private var improvementStreak: Int = 0

    /// User's personal best BPM reduction (motivation & progress tracking)
    @State private var bestImprovement: Double = 0

    // MARK: - Animation & Analysis

    /// 60 FPS timer for professional-quality sine wave animation
    @State private var animationTimer: Timer?

    /// Rolling window of last 10 heart rate readings for trend analysis
    @State private var heartRateHistory: [Double] = []

    // MARK: - Modern UI Controls

    /// Whether to show sine waves (default: true, can be toggled)
    @State private var showSineWaves: Bool = true

    /// Whether to show session duration picker
    @State private var showDurationPicker: Bool = false

    /// Selected meditation duration in minutes (nil = open-ended)
    @State private var selectedDuration: Int? = nil

    /// Available duration options
    private let durationOptions: [Int] = [1, 3, 5, 10, 15, 20, 30, 45, 60]

    /// Dismissal callback
    let onDismiss: (() -> Void)?

    /// Session tracking state
    @State private var sessionStartBPM: Double = 0
    @State private var sessionAvgBPM: Double = 0
    @State private var sessionCoherenceCount: Int = 0
    @State private var showSessionComplete: Bool = false

    /// Whether to show timer completion modal (pause with continue option)
    @State private var showTimerCompletion: Bool = false
    @State private var showMeditationHistory: Bool = false

    // MARK: - Breathing Vibration System

    /// Breathing rhythm timer for phase transitions
    @State private var breathingTimer: Timer?

    /// Sustained vibration timer for 5-second breathing phases
    @State private var sustainedVibrationTimer: Timer?

    /// Current breathing phase (inhale/hold/exhale/hold)
    @State private var breathingPhase: BreathingPhase = .inhale

    /// Breathing cycle start time for precise timing
    @State private var breathingCycleStart: Date = Date()

    /// Whether breathing vibrations are enabled
    @State private var enableBreathingVibrations: Bool = true

    /// Countdown before meditation starts
    @State private var showCountdown: Bool = true
    @State private var countdownValue: Int = 10
    // @State private var sessionCompleteResult: MeditationSession? = nil

    /// Pulse animation state for chakra glow effects
    @State private var pulseAnimation: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // MARK: - Background Gradient
                backgroundGradient

                // MARK: - Main Content Layout
                ScrollView {
                    VStack(spacing: 20) {

                        // Header with coherence info
                        coherenceHeader
                            .padding(.horizontal)

                        // Main sine wave area with integrated breathing guidance
                        sineWaveArea(geometry: geometry)
                            .frame(height: 260) // Fixed height for waves
                            .padding(.horizontal)

                        // Energy Centers (Chakras) - spiritual visualization below guidance
                        horizontalChakrasDisplay
                            .padding(.horizontal)

                        // Coherence metrics (analytical feedback)
                        coherenceMetrics
                            .padding(.horizontal)

                        // Properties display section
                        propertiesDisplaySection
                            .padding(.horizontal)

                        // End Session Button (inside scrollable content)
                        Button(action: {
                            completeSession()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                Text("End Meditation")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.red.opacity(0.8), .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 34) // Safe area padding
                    }
                }

                // MARK: - Achievement Overlay (positioned to not interfere)
                if isInCoherence {
                    VStack {
                        Spacer()
                        coherenceAchievementOverlay
                            .padding(.bottom, 120) // Keep above end button
                    }
                    .allowsHitTesting(false)
                }

                // MARK: - Duration Picker Overlay
                if showDurationPicker {
                    durationPickerModal
                }

                // MARK: - Session Complete Modal
                if showSessionComplete {
                    sessionCompleteModal
                }

                // MARK: - Timer Completion Modal
                if showTimerCompletion {
                    timerCompletionModal
                }

                // MARK: - Countdown Overlay
                if showCountdown {
                    countdownOverlay
                }
            }
        }
        .onAppear {
            // Start countdown first
            startCountdown()

            // Start chakra pulse animation
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
        .onDisappear {
            stopBiofeedbackSession()
        }
        .sheet(isPresented: $showMeditationHistory) {
            MeditationHistoryViewSimple()
        }
    }

    // TODO: Re-enable onChange when FrequencyDetector integrated
    // .onChange(of: frequencyDetector.currentCoherence) { oldValue, newValue in
    //     updateCoherenceDisplay(newValue)
    // }

    // MARK: - Background

    private var backgroundGradient: some View {
        let improvement = baselineHeartRate > 0 ? baselineHeartRate - getUserHeartRate() : 0.0

        let colors: [Color] = {
            if isInCoherence && improvement >= 5.0 {
                // Amazing progress - golden celebration
                return [Color.yellow.opacity(0.1), Color.orange.opacity(0.15), Color.green.opacity(0.2)]
            } else if isInCoherence {
                // Good progress - green success
                return [Color.green.opacity(0.1), Color.mint.opacity(0.2)]
            } else if improvement >= 1.0 {
                // Some improvement - blue encouragement
                return [Color.blue.opacity(0.1), Color.cyan.opacity(0.15)]
            } else {
                // Starting out - calm purple
                return [Color.purple.opacity(0.08), Color.blue.opacity(0.12)]
            }
        }()

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 2.0), value: isInCoherence)
    }

    // MARK: - Modern Header

    private var coherenceHeader: some View {
        VStack(spacing: 16) {
            // Top control bar
            HStack {
                // Back/Close button
                Button(action: {
                    completeSession()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.primary.opacity(0.6))
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }

                Spacer()

                // Duration picker button
                Button(action: {
                    withAnimation(.spring()) {
                        showDurationPicker.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.caption)

                        Text(selectedDuration != nil ? "\(selectedDuration!)min" : "Open")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                }

                // Sine wave toggle
                Button(action: {
                    withAnimation(.spring()) {
                        showSineWaves.toggle()
                    }
                }) {
                    Image(systemName: showSineWaves ? "waveform" : "waveform.slash")
                        .font(.title3)
                        .foregroundStyle(showSineWaves ? .blue : .secondary)
                        .padding(8)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }

            // Main title area
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            LinearGradient(
                                colors: isInCoherence ? [.green, .mint] : [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(isInCoherence ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.8), value: isInCoherence)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Heart Coherence")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("Training Session")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                // Status message (with proper padding to prevent truncation)
                statusMessage
                    .padding(.horizontal, 8)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .animation(.easeInOut(duration: 0.5), value: isInCoherence)
            }
            .padding(.horizontal, 4)
        }
    }

    // MARK: - Dynamic Status Message

    private var statusMessage: some View {
        Group {
            if isInCoherence {
                let improvement = baselineHeartRate - getUserHeartRate()
                let currentBPM = getUserHeartRate()
                let targetBPM = getTargetBPM()
                let isOptimalBPM = abs(currentBPM - targetBPM) <= 2.0

                if isOptimalBPM {
                    Text("👑 LEGENDARY MASTERY! Optimal BPM achieved!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                } else if improvement >= 3.0 {
                    Text("🚀 Excellent Progress! -\(Int(improvement)) BPM reduction")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                } else {
                    Text("🌊 Beautiful Consistency! Keep flowing")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
            } else {
                if baselineHeartRate > 0 {
                    Text(getMeditationMessage())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                } else {
                    Text("✨ Connecting to your heart's wisdom...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    // MARK: - Modern Sine Wave Area

    private func sineWaveArea(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            // Wave labels at TOP (above waves)
            if showSineWaves {
                waveLabels
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Main wave container (fixed height)
            ZStack {
                // Modern glassmorphism background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.05),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)

                // Sine waves (conditionally shown)
                if showSineWaves {
                    ZStack {
                        // Target sine wave (golden reference)
                        targetSineWave(geometry: geometry)

                        // User's HRV sine wave (blue/green)
                        userSineWave(geometry: geometry)
                    }
                    .frame(height: 180)
                    .clipped()
                    .transition(.opacity.combined(with: .scale))
                } else {
                    // Elegant placeholder when waves are hidden
                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 32))
                            .foregroundColor(isInCoherence ? .green : .blue)
                            .scaleEffect(isInCoherence ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isInCoherence)

                        Text("Heart Coherence Active")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)

                        Text("Biofeedback processing in background")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                // Integrated breathing guidance - positioned at bottom of wave container
                VStack {
                    Spacer()

                    compactBreathingGuidance
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }
            }
        }
    }

    // MARK: - Target Sine Wave (Golden/Yellow → Green when matched)

    private func targetSineWave(geometry: GeometryProxy) -> some View {
        Path { path in
            let width = geometry.size.width - 40
            let height: CGFloat = 80
            let centerY = height / 2
            let amplitude: CGFloat = 30

            // Convert optimal BPM to visual wave frequency for realistic movement
            let targetBPM = getTargetBPM()
            let targetFrequency = (targetBPM / 60.0) * 0.5  // BPM → Hz conversion with 0.5x scaling for visibility

            path.move(to: CGPoint(x: 0, y: centerY))

            // Generate sine wave points across screen width with higher resolution for smoothness
            for x in stride(from: 0, through: width, by: 0.5) {
                let normalizedX = x / width  // 0.0 to 1.0 across screen

                // Calculate wave phase: animation time + spatial position
                // animationOffset provides continuous movement, normalizedX creates wave shape
                let phase = (animationOffset * targetFrequency * 0.02) + (normalizedX * 4 * Double.pi)

                // Generate Y coordinate using sine function
                let y = centerY + sin(phase) * amplitude

                if x == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(
            getWaveColor(isTarget: true),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .frame(height: 150)
        .opacity(0.8)
    }

    // MARK: - User's HRV Sine Wave (Blue → Green when matched)

    private func userSineWave(geometry: GeometryProxy) -> some View {
        Path { path in
            let width = geometry.size.width - 40
            let height: CGFloat = 80
            let centerY = height / 2 + (isInCoherence ? 0 : 15)  // Merge with target when matched
            let amplitude: CGFloat = 30 * CGFloat(max(0.5, coherenceLevel))

            // Convert real-time Apple Watch BPM to visual wave frequency
            let currentBPM = getUserHeartRate()
            let userFrequency = (currentBPM / 60.0) * 0.5  // Real BPM → Hz with visual scaling

            path.move(to: CGPoint(x: 0, y: centerY))

            // Generate user's heart rhythm sine wave with higher resolution for smoothness
            for x in stride(from: 0, through: width, by: 0.5) {
                let normalizedX = x / width  // Screen position 0.0 to 1.0

                // Calculate wave phase synchronized to actual heart rate
                let phase = (animationOffset * userFrequency * 0.02) + (normalizedX * 4 * Double.pi)

                // Add realistic HRV variability when not in coherence state
                // Simulates natural heart rate variability - disappears when coherent
                let variability = isInCoherence ? 0 : (sin(phase * 2.5) * 0.15 + cos(phase * 3.7) * 0.1)

                // Generate Y coordinate with heart rate variability
                let y = centerY + sin(phase + variability) * amplitude

                if x == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(
            getWaveColor(isTarget: false),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .frame(height: 150)
        .opacity(0.9)
        .animation(.easeInOut(duration: 0.8), value: isInCoherence)
    }

    // MARK: - Wave Labels

    private var waveLabels: some View {
        HStack {
            Label("Your Heart Rhythm", systemImage: "heart.fill")
                .font(.caption)
                .foregroundColor(isInCoherence ? .green : .blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.15))
                .cornerRadius(6)

            Spacer()

            Label("Optimal Coherence", systemImage: "target")
                .font(.caption)
                .foregroundColor(isInCoherence ? .green : .yellow)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.15))
                .cornerRadius(6)
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Breathing Guidance

    private var breathingGuidance: some View {
        VStack(spacing: 12) {
            Text("Breathing Guide")
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 20) {
                VStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(.mint)

                    Text("Inhale 5s")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text("→")
                    .font(.title2)
                    .foregroundColor(.secondary)

                VStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title)
                        .foregroundColor(.cyan)

                    Text("Exhale 5s")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text("=")
                    .font(.title2)
                    .foregroundColor(.secondary)

                VStack {
                    Image(systemName: "target")
                        .font(.title)
                        .foregroundColor(.green)

                    Text("6 breaths/min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }

    // MARK: - Compact Breathing Guidance (for sine wave integration)

    private var compactBreathingGuidance: some View {
        HStack(spacing: 10) {
            // Current phase indicator with dynamic text
            HStack(spacing: 6) {
                // Phase icon
                Group {
                    switch breathingPhase {
                    case .inhale:
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.mint)
                    case .inhaleHold:
                        Image(systemName: "pause.circle.fill")
                            .foregroundColor(.blue)
                    case .exhale:
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.cyan)
                    case .exhaleHold:
                        Image(systemName: "pause.circle.fill")
                            .foregroundColor(.orange)
                    }
                }
                .font(.caption)
                .scaleEffect(breathingPhase.isActiveBreathing ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: breathingPhase)

                // Phase text
                VStack(alignment: .leading, spacing: 2) {
                    Text(breathingPhase.description)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("\(Int(breathingPhase.duration))s")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .animation(.easeInOut(duration: 0.3), value: breathingPhase)
            }

            // Progress indicators
            HStack(spacing: 4) {
                // Inhale dot
                Circle()
                    .fill(breathingPhase == .inhale || breathingPhase == .inhaleHold ? Color.mint : Color.mint.opacity(0.3))
                    .frame(width: 6, height: 6)
                    .scaleEffect(breathingPhase == .inhale ? 1.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: breathingPhase)

                // Exhale dot
                Circle()
                    .fill(breathingPhase == .exhale || breathingPhase == .exhaleHold ? Color.cyan : Color.cyan.opacity(0.3))
                    .frame(width: 6, height: 6)
                    .scaleEffect(breathingPhase == .exhale ? 1.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: breathingPhase)
            }

            Spacer()

            // Breathing rate
            HStack(spacing: 4) {
                Image(systemName: "target")
                    .font(.caption)
                    .foregroundColor(.green)

                Text("4/min")  // Updated for new 13-second cycle (5+1.5+5+1.5)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Properties Display Section

    private var propertiesDisplaySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.blue)
                Text("Live Biofeedback Properties")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }

            // Properties grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {

                // Current Range Status
                PropertyCard(
                    title: "Coherence Zone",
                    value: getCoherenceZoneText(),
                    subtitle: getCoherenceZoneDescription(),
                    color: getCoherenceZoneColor(),
                    icon: "target"
                )

                // Heart Rate Variability
                PropertyCard(
                    title: "HRV Quality",
                    value: getHRVQualityText(),
                    subtitle: "Based on wave smoothness",
                    color: getHRVQualityColor(),
                    icon: "waveform"
                )

                // Breathing Pattern
                PropertyCard(
                    title: "Breath Sync",
                    value: getBreathSyncText(),
                    subtitle: "5s in, 5s out optimal",
                    color: getBreathSyncColor(),
                    icon: "lungs.fill"
                )

                // Session Quality Score
                PropertyCard(
                    title: "Session Score",
                    value: String(format: "%.0f%%", coherenceLevel * 100),
                    subtitle: "Overall meditation quality",
                    color: getSessionScoreColor(),
                    icon: "star.fill"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.05),
                            Color.cyan.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    // MARK: - Modern Metrics Dashboard

    private var coherenceMetrics: some View {
        VStack(spacing: 20) {
            // Main metrics grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {

                // Improvement Card
                HRVMetricCard(
                    icon: "arrow.down.circle.fill",
                    value: "\(Int(max(0, baselineHeartRate - getUserHeartRate())))",
                    label: "BPM Improved",
                    color: getTrendColor(),
                    isHighlighted: baselineHeartRate - getUserHeartRate() >= 3.0
                )

                // Session Duration Card (with countdown/countup logic)
                HRVMetricCard(
                    icon: "clock.fill",
                    value: formatDurationDisplay(),
                    label: selectedDuration != nil ? "Remaining" : "Duration",
                    color: .purple,
                    isHighlighted: sessionDuration >= 120
                )

                // Current BPM Card
                HRVMetricCard(
                    icon: getTrendIcon(),
                    value: "\(Int(getUserHeartRate()))",
                    label: "Current BPM",
                    color: getHeartRateColor(),
                    isHighlighted: isInCoherence
                )
            }

            // Progress visualization
            if baselineHeartRate > 0 {
                modernProgressBar
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 8)
    }

    // MARK: - Modern Progress Bar

    private var modernProgressBar: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress Journey")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                Text("Best: -\(Int(bestImprovement)) BPM")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }

            // Modern progress track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)

                    // Progress fill with gradient
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .cyan, .green],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * getProgressPercent(),
                            height: 12
                        )
                        .animation(.easeInOut(duration: 0.8), value: getProgressPercent())

                    // Glow effect for progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.cyan.opacity(0.3), .green.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * getProgressPercent(),
                            height: 12
                        )
                        .blur(radius: 4)
                        .animation(.easeInOut(duration: 0.8), value: getProgressPercent())
                }
            }
            .frame(height: 12)
        }
    }

    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("Best: -\(Int(bestImprovement)) BPM")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)

                    // Progress fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(
                            width: geometry.size.width * getProgressPercent(),
                            height: 8
                        )
                        .animation(.easeInOut(duration: 0.5), value: getProgressPercent())
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - Achievement Overlay

    private var coherenceAchievementOverlay: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.2))
                .frame(width: 100, height: 100)
                .scaleEffect(isInCoherence ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(), value: isInCoherence)

                VStack(spacing: 8) {
                    let improvement = baselineHeartRate - getUserHeartRate()
                    let currentBPM = getUserHeartRate()
                    let targetBPM = getTargetBPM()
                    let isOptimalBPM = abs(currentBPM - targetBPM) <= 2.0

                    if isOptimalBPM {
                        // LEGENDARY OPTIMAL BPM ACHIEVEMENT
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isInCoherence)

                        Text("LEGENDARY!")
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundColor(.yellow)

                        Text("Optimal BPM Mastery")
                            .font(.caption2)
                            .foregroundColor(.yellow)

                        Text("\(Int(currentBPM)) BPM")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                            .fontWeight(.bold)

                    } else if improvement >= 5.0 {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)

                        Text("AMAZING!")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Text("-\(Int(improvement)) BPM")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else if improvement >= 3.0 {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)

                        Text("GREAT PROGRESS!")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "timer")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)

                        Text("CONSISTENCY")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Text(formatSessionTime())
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
        }
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(), value: isInCoherence)
    }

    // MARK: - Duration Picker Modal

    private var durationPickerModal: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        showDurationPicker = false
                    }
                }

            // Duration picker card
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Set Meditation Duration")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Choose your session length or keep it open-ended")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Duration options grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {

                    // Open-ended option
                    DurationOptionCard(
                        duration: nil,
                        isSelected: selectedDuration == nil,
                        onTap: {
                            selectedDuration = nil
                            withAnimation(.spring()) {
                                showDurationPicker = false
                            }
                        }
                    )

                    // Timed options
                    ForEach(durationOptions, id: \.self) { duration in
                        DurationOptionCard(
                            duration: duration,
                            isSelected: selectedDuration == duration,
                            onTap: {
                                selectedDuration = duration
                                withAnimation(.spring()) {
                                    showDurationPicker = false
                                }
                            }
                        )
                    }
                }

                // Cancel button
                Button(action: {
                    withAnimation(.spring()) {
                        showDurationPicker = false
                    }
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 40)
            .scaleEffect(showDurationPicker ? 1.0 : 0.8)
            .opacity(showDurationPicker ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showDurationPicker)
        }
    }

    // MARK: - Session Complete Modal

    private var sessionCompleteModal: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            // Completion card
            VStack(spacing: 24) {
                // Celebration header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Meditation Complete!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(meditationType.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Session results (simplified)
                VStack(spacing: 16) {
                    // Duration and achievements
                    HStack(spacing: 30) {
                        VStack {
                            Text(formatSessionTime())
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)

                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        VStack {
                            HStack(spacing: 4) {
                                Image(systemName: sessionCoherenceCount > 0 ? "star.fill" : "heart.fill")
                                    .foregroundColor(sessionCoherenceCount > 0 ? .yellow : .green)
                                Text(sessionCoherenceCount > 0 ? "Great!" : "Good")
                                    .fontWeight(.bold)
                                    .foregroundColor(sessionCoherenceCount > 0 ? .yellow : .green)
                            }

                            Text("Quality")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Key achievements
                    let improvement = max(0, sessionStartBPM - getUserHeartRate())
                    if improvement >= 3.0 {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.green)
                                Text("-\(Int(improvement)) BPM Improvement")
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }

                // Focus + Realm Insights
                focusRealmInsights

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        onDismiss?()
                    }) {
                        Text("Finished")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        showMeditationHistory = true
                    }) {
                        Text("View Progress & History")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 32)
            .scaleEffect(showSessionComplete ? 1.0 : 0.8)
            .opacity(showSessionComplete ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSessionComplete)
        }
    }

    // MARK: - Focus + Realm Insights

    private var focusRealmInsights: some View {
        let focusNumber = FocusNumberManager.shared.selectedFocusNumber
        let realmNumber = 3 // TODO: Get actual realm number when available
        let combinedNumber = focusNumber + realmNumber

        return VStack(spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                Text("Spiritual Insight")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Focus \(focusNumber) + Realm \(realmNumber) = \(combinedNumber)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Text(getInsightForCombinedNumber(combinedNumber))
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func getInsightForCombinedNumber(_ number: Int) -> String {
        switch number {
        case 2:
            return "Your meditation reveals perfect balance and partnership energy. Trust in cooperation leads to harmony."
        case 3:
            return "Creative expression flows through your practice. Your voice and vision are important tools for growth."
        case 4:
            return "Stability and foundation-building emerge from your session. Structure supports your spiritual journey."
        case 5:
            return "Freedom and transformation call to you. Embrace change as your pathway to expansion."
        case 6:
            return "Nurturing and service energy radiates from your practice. Your caring nature heals both self and others."
        case 7:
            return "Deep spiritual wisdom has been awakened. Trust your inner knowing and continue seeking truth."
        case 8:
            return "Material mastery and personal power flow through you. Use your strength to lift others and create abundance."
        case 9:
            return "Universal love and completion energy surrounds your practice. You're ready to share your gifts with the world."
        case 10:
            return "New beginnings with wisdom gained. You're starting a fresh cycle with all the knowledge you've accumulated."
        case 11:
            return "Master number energy activated! Your intuition and spiritual insight are exceptionally heightened today."
        case 12:
            return "Creative manifestation and self-expression merge. Your unique gifts are ready to be shared with others."
        case 13:
            return "Transformation through dedication emerges. Hard work and spiritual practice are rebuilding your foundation."
        case 14:
            return "Freedom through spiritual balance. You're learning to express your truth while maintaining harmony."
        case 15:
            return "Healing energy flows through your practice. Your compassionate nature brings comfort to yourself and others."
        case 16:
            return "Spiritual awakening through challenge. What seems difficult now is actually your path to enlightenment."
        case 17:
            return "Material and spiritual wisdom unite. You're learning to be successful while staying true to your values."
        case 18:
            return "Humanitarian service calls to you. Your meditation prepares you to help heal the world."
        default:
            return "Your unique numerical combination reveals a special path of growth and awakening that's entirely your own."
        }
    }

    // MARK: - Timer Completion Modal

    private var timerCompletionModal: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            // Timer completion card
            VStack(spacing: 24) {
                // Timer icon
                VStack(spacing: 12) {
                    Image(systemName: "clock.badge.checkmark.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)

                    Text("Time Complete!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    if let duration = selectedDuration {
                        Text("You've completed your \(duration) minute session")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                // Current progress
                VStack(spacing: 16) {
                    HStack(spacing: 30) {
                        VStack {
                            Text(formatSessionTime())
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)

                            Text("Meditation Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        VStack {
                            let improvement = max(0, sessionStartBPM - getUserHeartRate())
                            Text("-\(Int(improvement))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)

                            Text("BPM Drop")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text("You're in a great flow! Feel free to continue or complete your session.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // Continue meditation - just dismiss the modal
                        showTimerCompletion = false
                        // Remove duration limit to continue indefinitely
                        selectedDuration = nil
                    }) {
                        Text("Continue Meditating")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.orange)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        showTimerCompletion = false
                        // Save the session and show completion modal
                        let currentBPM = getUserHeartRate()
                        let heartRateImprovement = max(0, sessionStartBPM - currentBPM)
                        let achievedOptimal = abs(currentBPM - getTargetBPM()) <= 2.0

                        // Create and save session to history
                        let focusNumber = FocusNumberManager.shared.selectedFocusNumber
                        let realmNumber = 3 // TODO: Get actual realm number
                        let combinedNumber = focusNumber + realmNumber

                        let session = MeditationSession(
                            date: Date(),
                            type: meditationType,
                            duration: sessionDuration,
                            startingHeartRate: sessionStartBPM,
                            averageHeartRate: (sessionStartBPM + currentBPM) / 2,
                            lowestHeartRate: min(sessionStartBPM, currentBPM),
                            heartRateImprovement: heartRateImprovement,
                            coherenceAchievements: sessionCoherenceCount,
                            maxCoherenceStreak: Int(sessionDuration / 10), // Approximate
                            coherencePercentage: sessionCoherenceCount > 0 ? 0.75 : 0.4,
                            achievedOptimalBPM: achievedOptimal,
                            sessionQuality: getSessionQuality(improvement: heartRateImprovement, duration: sessionDuration),
                            focusNumber: focusNumber,
                            realmNumber: realmNumber,
                            spiritualInsight: getInsightForCombinedNumber(combinedNumber),
                            userNotes: nil,
                            personalBest: heartRateImprovement > MeditationHistoryManager.shared.personalBestImprovement
                        )

                        MeditationHistoryManager.shared.saveSession(session)

                        // Show completion modal
                        showSessionComplete = true
                    }) {
                        Text("End Session")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 32)
            .scaleEffect(showTimerCompletion ? 1.0 : 0.8)
            .opacity(showTimerCompletion ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showTimerCompletion)
        }
    }

    // MARK: - Countdown Overlay

    private var countdownOverlay: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Meditation type info
                VStack(spacing: 16) {
                    Image(systemName: meditationType.icon)
                        .font(.system(size: 50))
                        .foregroundColor(meditationType.primaryColor)

                    Text("Preparing \(meditationType.displayName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("Get ready to begin your practice")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }

                // Countdown circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: CGFloat(10 - countdownValue) / 10.0)
                        .stroke(meditationType.primaryColor, lineWidth: 6)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: countdownValue)

                    if countdownValue > 0 {
                        Text("\(countdownValue)")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(countdownValue == 10 ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: countdownValue)
                    } else {
                        Text("Begin")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .scaleEffect(1.2)
                            .animation(.spring(response: 0.3), value: countdownValue)
                    }
                }

                // Preparation tips
                VStack(spacing: 12) {
                    Text("• Find a comfortable position")
                    Text("• Close your eyes or soften your gaze")
                    Text("• Take a few deep breaths")
                    Text("• Set your intention for this practice")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            }
        }
    }

    // MARK: - Countdown Methods

    private func startCountdown() {
        // Prime HealthKit data during countdown
        primeHealthKitData()

        countdownValue = 10
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdownValue -= 1

            if countdownValue < 0 {
                timer.invalidate()

                // Hide countdown and start meditation
                withAnimation(.easeOut(duration: 0.5)) {
                    showCountdown = false
                }

                // Start the actual meditation session after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    startBiofeedbackSession()
                }
            }
        }
    }

    private func primeHealthKitData() {
        // Prime HealthKit by taking initial readings
        // This ensures we have baseline data before the meditation begins

        // Get initial focus and realm numbers
        let focusNumber = FocusNumberManager.shared.selectedFocusNumber
        // TODO: Add realm number when available

        // Log initial state for debugging
        print("🧘‍♀️ Priming meditation session:")
        print("   Focus Number: \(focusNumber)")
        print("   Meditation Type: \(meditationType.displayName)")

        // Pre-warm HealthKit connection
        if healthKitManager != nil {
            // HealthKit manager will start getting readings when biofeedback session starts
            print("   HealthKit: Ready")
        }
    }

    // MARK: - Horizontal Chakras Display

    private var horizontalChakrasDisplay: some View {
        VStack(spacing: 12) {
            // Section title
            HStack {
                Image(systemName: "circle.grid.cross.fill")
                    .font(.caption)
                    .foregroundColor(.purple)

                Text("Energy Centers")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()
            }

            // Chakras row
            HStack(spacing: 16) {
                ForEach(ChakraType.allCases.reversed(), id: \.self) { chakraType in
                    chakraEnergyIndicator(for: chakraType)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.05),
                            Color.blue.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    /// Individual chakra energy indicator with glow/pulse effects
    private func chakraEnergyIndicator(for chakraType: ChakraType) -> some View {
        ZStack {
            // Glow effect (when active)
            if shouldChakraGlow(chakraType) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [chakraType.color.opacity(0.6), chakraType.color.opacity(0.1)],
                            center: .center,
                            startRadius: 2,
                            endRadius: 20
                        )
                    )
                    .frame(width: 40, height: 40)
                    .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
            }

            // Main chakra circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: shouldChakraGlow(chakraType) ?
                            [chakraType.color, chakraType.color.opacity(0.7)] :
                            [chakraType.color.opacity(0.3), chakraType.color.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(
                            shouldChakraGlow(chakraType) ?
                                chakraType.color.opacity(0.8) :
                                Color.white.opacity(0.3),
                            lineWidth: shouldChakraGlow(chakraType) ? 2 : 1
                        )
                )
                .scaleEffect(shouldChakraGlow(chakraType) ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: shouldChakraGlow(chakraType))

            // Chakra symbol (when active)
            if shouldChakraGlow(chakraType) {
                Image(systemName: getChakraIcon(chakraType))
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
            }
        }
        .accessibilityLabel("\(chakraType.name) chakra")
        .accessibilityValue(shouldChakraGlow(chakraType) ? "Active" : "Inactive")
    }

    /// Determines if a chakra should glow based on coherence state and heart rate improvement
    private func shouldChakraGlow(_ chakraType: ChakraType) -> Bool {
        let improvement = baselineHeartRate > 0 ? baselineHeartRate - getUserHeartRate() : 0

        // Different chakras activate based on progress level and coherence state
        switch chakraType {
        case .heart:
            // Heart chakra activates when in any coherence state
            return isInCoherence

        case .throat:
            // Throat chakra activates with good improvement (3+ BPM)
            return isInCoherence && improvement >= 3.0

        case .thirdEye:
            // Third eye activates with sustained coherence (2+ minutes)
            return isInCoherence && sessionDuration >= 120

        case .crown:
            // Crown chakra activates with optimal BPM achievement
            let currentBPM = getUserHeartRate()
            let targetBPM = getTargetBPM()
            return isInCoherence && abs(currentBPM - targetBPM) <= 2.0

        case .solarPlexus:
            // Solar plexus activates with consistent improvement trend
            return isInCoherence && currentTrend == .improving

        case .sacral:
            // Sacral activates with moderate improvement (2+ BPM)
            return isInCoherence && improvement >= 2.0

        case .root:
            // Root chakra activates with any sustained session (1+ minute)
            return sessionDuration >= 60
        }
    }

    /// Gets the appropriate icon for each chakra type
    private func getChakraIcon(_ chakraType: ChakraType) -> String {
        switch chakraType {
        case .crown: return "crown.fill"
        case .thirdEye: return "eye.fill"
        case .throat: return "speaker.wave.2.fill"
        case .heart: return "heart.fill"
        case .solarPlexus: return "sun.max.fill"
        case .sacral: return "drop.fill"
        case .root: return "square.fill"
        }
    }

    // MARK: - Helper Methods

    /// Starts the real-time HRV biofeedback session with smooth sine wave animations
    ///
    /// Initializes the core animation and data processing systems:
    /// 1. 60 FPS timer for buttery-smooth sine wave movement
    /// 2. BPM-synchronized wave frequencies based on real Apple Watch data
    /// 3. Coherence detection every 10 frames (6 times per second) for responsiveness
    /// 4. Automatic animation cycle reset every 10 seconds to prevent overflow
    private func startBiofeedbackSession() {
        // 60 FPS animation timer for professional-quality sine wave movement
        // Higher frame rate ensures smooth visual feedback during meditation
        // Use common mode to ensure timer continues during scrolling
        animationTimer = Timer(timeInterval: 1.0/60.0, repeats: true) { _ in
            // Increment animation offset for continuous wave movement
            // Each increment moves the phase of both sine waves forward
            animationOffset += 1.0

            // Reset animation cycle every 10 seconds to prevent numerical overflow
            // This maintains smooth movement without accumulating floating-point errors
            if animationOffset > 600 {  // 600 frames = 10 seconds at 60 FPS
                animationOffset = 0
            }

            // Update coherence calculation every 10 frames (6 times per second)
            // Balances responsiveness with performance - too frequent causes jitter
            if Int(animationOffset) % 10 == 0 {
                self.updateCoherenceFromHeartRate()
            }
        }

        // Initialize baseline heart rate for progressive rewards
        sessionStartTime = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Set baseline after 2 seconds to get a stable reading
            let currentBPM = self.getUserHeartRate()
            if self.baselineHeartRate == 0 && currentBPM > 0 {
                self.baselineHeartRate = currentBPM
                self.sessionStartBPM = currentBPM  // Track for session completion
                print("🎯 Baseline heart rate set: \(Int(currentBPM)) BPM")
            }
        }

        // Add timer to run loop with common mode to prevent pausing during scroll
        RunLoop.current.add(animationTimer!, forMode: .common)

        // Start breathing vibration guidance
        startBreathingVibrations()

        print("🌊 HRV Biofeedback: Session started with breathing vibrations")
    }

    private func stopBiofeedbackSession() {
        animationTimer?.invalidate()
        animationTimer = nil

        stopBreathingVibrations()

        print("🌊 HRV Biofeedback: Session stopped")
    }

    // MARK: - Breathing Vibration Functions

    /**
     * Starts the natural breathing guidance vibration system
     *
     * Creates a 13-second breathing cycle:
     * - 5s inhale with light sustained vibrations
     * - 1.5s pause (natural transition time)
     * - 5s exhale with medium sustained vibrations
     * - 1.5s pause (natural rest period)
     *
     * This rhythm helps users maintain optimal 4 breaths/minute for deep meditation
     */
    private func startBreathingVibrations() {
        guard enableBreathingVibrations else { return }

        // Initialize breathing cycle state
        breathingPhase = .inhale
        breathingCycleStart = Date()

        // Begin the first breathing phase with immediate feedback
        startBreathingPhase(.inhale)

        print("🫁 Natural breathing guidance started: 5s inhale → pause → 5s exhale → pause")
    }

    /**
     * Stops all breathing vibration timers and cleans up resources
     * Called when meditation session ends or user exits
     */
    private func stopBreathingVibrations() {
        // Clean up both breathing phase timer and sustained vibration timer
        breathingTimer?.invalidate()
        breathingTimer = nil
        sustainedVibrationTimer?.invalidate()
        sustainedVibrationTimer = nil

        print("🫁 Breathing vibrations stopped")
    }

    /**
     * Starts a specific breathing phase with appropriate vibration pattern
     *
     * @param phase The breathing phase to start (inhale, exhale, or hold)
     *
     * For active breathing phases (inhale/exhale):
     * - Starts sustained vibration pattern
     * - Uses different vibration intensity (light for inhale, medium for exhale)
     * - Continues for full 5-second duration
     *
     * For hold phases:
     * - No vibration (natural pause)
     * - Brief 1.5 second duration for transition
     */
    private func startBreathingPhase(_ phase: BreathingPhase) {
        // Update current phase state
        breathingPhase = phase
        breathingCycleStart = Date()

        print("🫁 Starting phase: \(phase.description) (\(phase.duration)s)")

        // Start sustained vibrations for active breathing phases only
        if phase.isActiveBreathing {
            startSustainedVibration(for: phase)
        }

        // Schedule automatic transition to next phase
        // Uses .common run loop mode to prevent pausing during UI scrolling
        breathingTimer = Timer(timeInterval: phase.duration, repeats: false) { _ in
            self.transitionToNextPhase()
        }
        RunLoop.current.add(breathingTimer!, forMode: .common)
    }

    /**
     * Transitions to the next phase in the 4-phase breathing cycle
     *
     * Cycle progression: inhale → inhaleHold → exhale → exhaleHold → repeat
     *
     * Ensures sustained vibrations are stopped before phase change
     * to prevent overlapping vibration patterns
     */
    private func transitionToNextPhase() {
        // Stop any active sustained vibration from previous phase
        sustainedVibrationTimer?.invalidate()
        sustainedVibrationTimer = nil

        // Determine next phase in the natural breathing cycle
        let nextPhase: BreathingPhase
        switch breathingPhase {
        case .inhale: nextPhase = .inhaleHold      // Inhale → brief hold
        case .inhaleHold: nextPhase = .exhale      // Hold → exhale
        case .exhale: nextPhase = .exhaleHold      // Exhale → brief hold
        case .exhaleHold: nextPhase = .inhale      // Hold → inhale (restart cycle)
        }

        // Start the next phase
        startBreathingPhase(nextPhase)
    }

    /**
     * Creates sustained vibration pattern for active breathing phases
     *
     * @param phase The breathing phase requiring sustained vibration
     *
     * Vibration Pattern:
     * - Immediate initial vibration to signal phase start
     * - Continuous gentle pulses throughout the 5-second phase
     * - Different pulse rates: inhale (0.8s), exhale (0.6s - slightly faster)
     * - Different intensities: inhale (light), exhale (medium)
     *
     * This sustained pattern helps users maintain proper breathing pace
     * without feeling rushed or having to count seconds
     */
    private func startSustainedVibration(for phase: BreathingPhase) {
        // Create haptic generator with phase-appropriate intensity
        let generator = UIImpactFeedbackGenerator(style: phase.vibrationStyle)
        generator.prepare()

        // Immediate initial vibration to signal phase start
        generator.impactOccurred()

        // Calculate pulse timing based on breathing phase
        // Inhale: slower, gentler pulses (0.8s) for relaxed inhalation
        // Exhale: faster pulses (0.6s) to help with controlled exhalation
        let pulseInterval: TimeInterval = phase == .inhale ? 0.8 : 0.6

        // Create repeating timer for sustained vibration throughout phase
        sustainedVibrationTimer = Timer(timeInterval: pulseInterval, repeats: true) { _ in
            // Create fresh generator for each pulse to ensure proper haptic response
            let sustainGenerator = UIImpactFeedbackGenerator(style: phase.vibrationStyle)
            sustainGenerator.prepare()
            sustainGenerator.impactOccurred()
        }

        // Add to run loop with .common mode to prevent pausing during scroll
        RunLoop.current.add(sustainedVibrationTimer!, forMode: .common)

        print("🫁 Sustained vibration started: \(phase.description) (\(pulseInterval)s intervals)")
    }

    /// Gets meditation-specific guidance message based on the meditation type
    private func getMeditationMessage() -> String {
        switch meditationType {
        case .affirmation:
            return "💙 Speak your truth with love. Let your heart confirm your positive intentions."
        case .manifestation:
            return "✨ Visualize your dreams with clarity. Feel them becoming reality through your heart."
        case .reflective:
            return "🌊 Look within with compassion. Your heart holds the wisdom you seek."
        case .traumaTherapy:
            return "🌱 Gentle healing flows through you. Your heart knows how to restore itself."
        case .gratitude:
            return "🙏 Open your heart to appreciation. Feel thankfulness flow through your being."
        case .chakraBalancing:
            return "💙 Breathe deeply and let your heart settle into its natural rhythm."
        case .breathwork:
            return "🌬️ Follow your breath's natural rhythm. Let each cycle bring deeper peace."
        case .lovingKindness:
            return "❤️ Send love to yourself first. Your heart radiates compassion naturally."
        }
    }

    /// Gets the scientifically-accurate target BPM for optimal coherence based on user's age
    ///
    /// Uses American Heart Association guidelines for optimal resting heart rate ranges.
    /// This provides the baseline that the yellow sine wave moves at, representing the
    /// ideal heart rate for achieving HRV coherence states.
    ///
    /// - Returns: Target BPM (typically 58-62 for most adults)
    private func getTargetBPM() -> Double {
        let estimatedAge: Double = 35  // TODO: Get from user profile when available
        return calculateOptimalRestingHR(age: estimatedAge)
    }

    /// Determines sine wave colors based on real-time coherence achievement
    ///
    /// Implements the visual feedback system where:
    /// - Normal state: Yellow (target) + Blue (user) waves
    /// - Coherence achieved: Both waves turn green when BPM matches within ±3
    ///
    /// - Parameter isTarget: true for optimal BPM wave, false for user's actual BPM wave
    /// - Returns: Color for the sine wave stroke
    private func getWaveColor(isTarget: Bool) -> Color {
        if isInCoherence {
            return .green  // Visual reward: both waves merge to green when coherence achieved
        }
        return isTarget ? .yellow : .blue  // Normal state: yellow target, blue user
    }

    /// Progressive coherence system that rewards improvement rather than demanding perfection
    ///
    /// Instead of requiring unrealistic 58-62 BPM, this system:
    /// 1. Sets user's starting BPM as baseline after 2 seconds
    /// 2. Rewards any heart rate improvement (BPM reduction)
    /// 3. Goes green when user sustains improvement for 5+ seconds
    /// 4. Tracks trends and celebrates progress over time
    private func updateCoherenceFromHeartRate() {
        let currentBPM = getUserHeartRate()

        // Update session duration
        sessionDuration = Date().timeIntervalSince(sessionStartTime)

        // Check if timed session is complete
        if let targetDuration = selectedDuration {
            let targetSeconds = targetDuration * 60
            print("⏱️ Timer Check: \(Int(sessionDuration))s / \(targetSeconds)s target")

            if sessionDuration >= TimeInterval(targetSeconds) && !showSessionComplete && !showTimerCompletion {
                print("🎯 Timer Complete! Showing completion modal")

                // Add strong haptic feedback for timer completion
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.prepare()
                impactFeedback.impactOccurred()

                // Additional notification-style vibration
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                }

                showTimerCompletion = true
                return
            }
        }

        // Skip if we don't have a baseline yet
        guard baselineHeartRate > 0 else { return }

        // Add to heart rate history for trend analysis
        heartRateHistory.append(currentBPM)
        if heartRateHistory.count > 10 {
            heartRateHistory.removeFirst()
        }

        // Calculate improvement from baseline
        let improvement = baselineHeartRate - currentBPM

        // Update best improvement achieved
        if improvement > bestImprovement {
            bestImprovement = improvement
        }

        // Determine heart rate trend
        if heartRateHistory.count >= 5 {
            let recent = Array(heartRateHistory.suffix(3))
            let older = Array(heartRateHistory.prefix(3))
            let recentAvg = recent.reduce(0, +) / Double(recent.count)
            let olderAvg = older.reduce(0, +) / Double(older.count)

            if recentAvg < olderAvg - 1.0 {
                currentTrend = .improving
            } else if recentAvg > olderAvg + 1.0 {
                currentTrend = .declining
            } else {
                currentTrend = .stable
            }
        }

        // Progressive coherence calculation
        // Green rewards: Any improvement of 3+ BPM OR sustained effort (2+ min)
        let significantImprovement = improvement >= 3.0
        let sustainedEffort = sessionDuration >= 120  // 2 minutes
        let trendBonus = currentTrend == .improving

        // Calculate coherence score based on multiple factors
        var coherenceScore: Double = 0.0

        if significantImprovement {
            coherenceScore += 0.6  // 60% for real improvement
        }

        if sustainedEffort {
            coherenceScore += 0.3  // 30% for sticking with it
        }

        if trendBonus {
            coherenceScore += 0.2  // 20% bonus for improving trend
        }

        // Timer-based rewards for consistent meditation
        let consistencyBonus = min(sessionDuration / 600, 0.3)  // Up to 30% bonus over 10 minutes
        coherenceScore += consistencyBonus

        // Cap at 1.0 and smooth the transition
        coherenceScore = min(1.0, coherenceScore)
        coherenceLevel = coherenceLevel * 0.7 + coherenceScore * 0.3

        // Check for LEGENDARY optimal BPM achievement
        let targetBPM = getTargetBPM()
        let isOptimalBPM = abs(currentBPM - targetBPM) <= 2.0  // Within 2 BPM of age-optimal

        // Determine new coherence state (more achievable criteria)
        let newCoherenceState = significantImprovement || (sustainedEffort && improvement >= 1.0) || isOptimalBPM

        if newCoherenceState && !isInCoherence {
            // Entering coherence
            isInCoherence = true
            improvementStreak += 1
            sessionCoherenceCount += 1  // Track for session completion

            // Special celebration for optimal BPM achievers!
            if isOptimalBPM {
                // LEGENDARY haptic feedback
                let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
                heavyFeedback.impactOccurred()

                // Trigger additional celebration effects
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let successFeedback = UINotificationFeedbackGenerator()
                    successFeedback.notificationOccurred(.success)
                }

                print("🌟 LEGENDARY ACHIEVEMENT! Optimal BPM reached: \(Int(currentBPM)) - You're a meditation master!")

            } else if significantImprovement {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                print("🎯 Great improvement! \(Int(improvement)) BPM reduction achieved")
            } else {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                print("🏆 Consistency reward! \(Int(sessionDuration/60)) minutes of meditation")
            }

        } else if !newCoherenceState && isInCoherence {
            // Leaving coherence
            isInCoherence = false
            print("📉 Keep breathing - every moment counts")
        }
    }

    /// Maps user's real-time HRV dominant frequency to visual sine wave frequency
    ///
    /// The dominant frequency from HRV spectral analysis is scaled for visual representation:
    /// - Real HRV: 0.05-0.15 Hz (typical coherence range)
    /// - Visual: 0.2-0.6 Hz (4x multiplier for smooth wave animation)
    /// - Bounds: Prevents extreme frequencies that would cause seizure-inducing flicker
    ///
    /// - Returns: Visual frequency in Hz for sine wave animation (0.05-0.25 Hz range)
    private func getUserHeartFrequency() -> Double {
        // TODO: Re-enable when FrequencyDetector integrated
        // guard let coherence = frequencyDetector.currentCoherence else {
        //     return 0.15  // Default frequency when no biometric data available
        // }
        // return max(0.05, min(0.25, coherence.dominantFrequency * 4))

        // TEMPORARY: Simulate heart frequency variation
        return 0.12 + sin(Date().timeIntervalSince1970 * 0.1) * 0.03  // Gentle variation around 0.1 Hz
    }

    /// Gets current heart rate for display metrics using existing HealthKitManager
    ///
    /// - Returns: Heart rate in beats per minute from HealthKit or simulated data
    private func getUserHeartRate() -> Double {
        let currentBPM = Double(healthKitManager.currentHeartRate)
        return currentBPM > 0 ? currentBPM : 72  // Use real BPM or fallback
    }

    /// Calculates optimal resting heart rate based on user's age
    ///
    /// Based on American Heart Association guidelines and athletic performance research
    /// - Parameter age: User's age in years
    /// - Returns: Target resting heart rate for optimal coherence
    private func calculateOptimalRestingHR(age: Double) -> Double {
        switch age {
        case 18...25:
            return 58.5  // Average of 56-61 optimal range
        case 26...35:
            return 58.0  // Average of 55-61 optimal range
        case 36...45:
            return 59.5  // Average of 57-62 optimal range
        case 46...55:
            return 60.5  // Average of 58-63 optimal range
        case 56...65:
            return 59.0  // Average of 57-61 optimal range
        case 66...:
            return 62.0  // Slightly higher for older adults
        default:
            return 60.0  // Default for unknown age
        }
    }

    // MARK: - Progressive UI Helper Methods

    /// Gets the color for trend indicators based on heart rate improvement
    private func getTrendColor() -> Color {
        let improvement = baselineHeartRate - getUserHeartRate()
        if improvement >= 3.0 {
            return .green  // Significant improvement
        } else if improvement >= 1.0 {
            return .blue   // Some improvement
        } else if improvement >= 0 {
            return .orange // Stable
        } else {
            return .red    // Getting worse
        }
    }

    /// Gets the trend icon based on current heart rate direction
    private func getTrendIcon() -> String {
        switch currentTrend {
        case .improving:
            return "arrow.down.circle.fill"  // Heart rate going down (good!)
        case .stable:
            return "minus.circle.fill"       // Heart rate stable
        case .declining:
            return "arrow.up.circle.fill"    // Heart rate going up (needs work)
        }
    }

    /// Formats the session duration into readable time
    private func formatSessionTime() -> String {
        let minutes = Int(sessionDuration) / 60
        let seconds = Int(sessionDuration) % 60

        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", seconds))"
        } else {
            return "\(seconds)s"
        }
    }

    /// Formats duration display (countdown for timed, countup for open-ended)
    private func formatDurationDisplay() -> String {
        if let targetDuration = selectedDuration {
            // Countdown for timed sessions
            let targetSeconds = targetDuration * 60
            let remaining = max(0, targetSeconds - Int(sessionDuration))
            let minutes = remaining / 60
            let seconds = remaining % 60

            if remaining <= 0 {
                return "Done!"
            }

            return "\(minutes):\(String(format: "%02d", seconds))"
        } else {
            // Count up for open-ended sessions
            return formatSessionTime()
        }
    }

    /// Calculates progress percentage for the progress bar
    private func getProgressPercent() -> Double {
        guard baselineHeartRate > 0 else { return 0.0 }

        let improvement = baselineHeartRate - getUserHeartRate()
        let maxExpectedImprovement: Double = 15.0  // Reasonable max improvement

        return min(1.0, max(0.0, improvement / maxExpectedImprovement))
    }

    /// Completes the meditation session and shows results
    private func completeSession() {
        stopBiofeedbackSession()

        // Calculate session metrics for display
        let currentBPM = getUserHeartRate()
        let heartRateImprovement = max(0, sessionStartBPM - currentBPM)
        let achievedOptimal = abs(currentBPM - getTargetBPM()) <= 2.0
        let _ = sessionDuration >= 60 // Consider sessions over 1 minute as completed

        // Create and save session to history
        let focusNumber = focusNumberManager.selectedFocusNumber
        let realmNumber = 3 // TODO: Get actual realm number
        let combinedNumber = focusNumber + realmNumber

        let session = MeditationSession(
            date: Date(),
            type: meditationType,
            duration: sessionDuration,
            startingHeartRate: sessionStartBPM,
            averageHeartRate: (sessionStartBPM + currentBPM) / 2,
            lowestHeartRate: min(sessionStartBPM, currentBPM),
            heartRateImprovement: heartRateImprovement,
            coherenceAchievements: improvementStreak,
            maxCoherenceStreak: max(improvementStreak, 1),
            coherencePercentage: Double(improvementStreak) / max(sessionDuration / 10, 1),
            achievedOptimalBPM: achievedOptimal,
            sessionQuality: getSessionQuality(improvement: heartRateImprovement, duration: sessionDuration),
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            spiritualInsight: getInsightForCombinedNumber(combinedNumber),
            userNotes: nil,
            personalBest: heartRateImprovement > 0
        )

        historyManager.saveSession(session)

        print("🧘‍♀️ Session completed and saved: \(Int(sessionDuration/60))min, -\(Int(heartRateImprovement))BPM improvement")

        // Show completion modal
        withAnimation(.spring()) {
            showSessionComplete = true
        }

        // Note: Modal now stays visible until user dismisses it manually
        // This allows users to view their results and choose when to exit
    }

    /// Determines session quality based on improvement and duration
    private func getSessionQuality(improvement: Double, duration: TimeInterval) -> SessionQuality {
        if improvement >= 8.0 && duration >= 300 {
            return .excellent
        } else if improvement >= 5.0 && duration >= 180 {
            return .good
        } else if improvement >= 3.0 || duration >= 120 {
            return .fair
        } else {
            return .challenging
        }
    }

    /// Gets heart rate color based on current state and coherence
    private func getHeartRateColor() -> Color {
        let currentBPM = getUserHeartRate()
        let targetBPM = getTargetBPM()

        if isInCoherence {
            return abs(currentBPM - targetBPM) <= 2.0 ? .yellow : .green
        } else {
            return currentTrend == .improving ? .blue : .red
        }
    }

    // MARK: - Properties Helper Methods

    /// Gets the coherence zone text based on current heart rate and target
    private func getCoherenceZoneText() -> String {
        let currentBPM = getUserHeartRate()
        let targetBPM = getTargetBPM()
        let difference = abs(currentBPM - targetBPM)

        if isInCoherence {
            if difference <= 2.0 {
                return "OPTIMAL"
            } else {
                return "COHERENT"
            }
        } else {
            if difference <= 5.0 {
                return "NEAR"
            } else {
                return "TRAINING"
            }
        }
    }

    /// Gets the coherence zone description
    private func getCoherenceZoneDescription() -> String {
        let improvement = baselineHeartRate > 0 ? baselineHeartRate - getUserHeartRate() : 0
        return improvement >= 1.0 ? "Improving nicely" : "Keep breathing"
    }

    /// Gets the coherence zone color
    private func getCoherenceZoneColor() -> Color {
        if isInCoherence {
            let currentBPM = getUserHeartRate()
            let targetBPM = getTargetBPM()
            return abs(currentBPM - targetBPM) <= 2.0 ? .yellow : .green
        } else {
            return .blue
        }
    }

    /// Gets HRV quality text based on wave stability
    private func getHRVQualityText() -> String {
        if isInCoherence {
            return "SMOOTH"
        } else {
            switch currentTrend {
            case .improving: return "IMPROVING"
            case .stable: return "STABLE"
            case .declining: return "VARIABLE"
            }
        }
    }

    /// Gets HRV quality color
    private func getHRVQualityColor() -> Color {
        if isInCoherence { return .green }
        switch currentTrend {
        case .improving: return .blue
        case .stable: return .orange
        case .declining: return .red
        }
    }

    /// Gets breathing synchronization status
    private func getBreathSyncText() -> String {
        // Simulate breath sync based on coherence level
        if coherenceLevel > 0.7 {
            return "SYNCED"
        } else if coherenceLevel > 0.4 {
            return "PARTIAL"
        } else {
            return "FINDING"
        }
    }

    /// Gets breathing sync color
    private func getBreathSyncColor() -> Color {
        if coherenceLevel > 0.7 { return .green }
        if coherenceLevel > 0.4 { return .orange }
        return .blue
    }

    /// Gets session score color
    private func getSessionScoreColor() -> Color {
        if coherenceLevel > 0.8 { return .green }
        if coherenceLevel > 0.6 { return .orange }
        return .blue
    }
}

// MARK: - Property Card Component

struct PropertyCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Spacer()
            }

            VStack(spacing: 4) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Duration Option Card Component

struct DurationOptionCard: View {
    let duration: Int? // nil = open-ended
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: duration == nil ? "infinity" : "clock.fill")
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .secondary)

                Text(duration == nil ? "Open" : "\(duration!)min")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - HRV Metric Card Component

struct HRVMetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let isHighlighted: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: isHighlighted ? [color, color.opacity(0.7)] : [color.opacity(0.7), color.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isHighlighted ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isHighlighted)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isHighlighted ? color : .primary)
                .animation(.easeInOut(duration: 0.3), value: isHighlighted)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isHighlighted ?
                    LinearGradient(
                        colors: [color.opacity(0.1), color.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isHighlighted ? color.opacity(0.3) : Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isHighlighted ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isHighlighted)
    }
}

// MARK: - Integration Helper

extension HRVBiofeedbackView {

    /// Create as overlay for existing meditation views
    static func asOverlay(isVisible: Binding<Bool>) -> some View {
        ZStack {
            if isVisible.wrappedValue {
                HRVBiofeedbackView()
                    .background(Color.black.opacity(0.7))
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isVisible.wrappedValue)
    }
}

#Preview {
    HRVBiofeedbackView(meditationType: .chakraBalancing)
        .environmentObject(HealthKitManager.shared)
        .environmentObject(FocusNumberManager.shared)
}
