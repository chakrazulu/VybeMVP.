import SwiftUI
import Combine

/**
 * Meditation Session View - Full-Screen Spiritual Experience
 * =========================================================
 *
 * Revolutionary meditation interface that combines:
 * - HRV biofeedback as the primary experience (not overlay!)
 * - Meditation type-specific messaging and guidance
 * - KASPER MLX persona integration for spiritual wisdom
 * - Progressive reward system that celebrates improvement
 *
 * ## 🎭 Meditation Type Integration
 *
 * Each meditation type provides unique:
 * - Visual themes and colors
 * - Achievement thresholds (trauma therapy = gentler)
 * - Messaging style (affirmation = empowering, healing = compassionate)
 * - Session duration recommendations
 * - KASPER persona preferences
 *
 * ## 🌊 Full-Screen HRV Experience
 *
 * Unlike traditional overlay approaches, this creates an immersive
 * biofeedback experience where:
 * - Sine waves are the main visual focus
 * - Progress tracking encourages continued practice
 * - Messaging adapts to meditation type and heart coherence
 * - Background evolves with user's spiritual state
 *
 * Created: August 2025
 * Version: 1.0.0 - Dedicated meditation session experience
 */

struct MeditationSessionView: View {

    // MARK: - Configuration

    /// The type of meditation being practiced
    let meditationType: MeditationType

    /// Session configuration with duration, biofeedback settings, etc.
    let sessionConfig: MeditationSessionConfig

    /// Callback when session ends
    let onSessionComplete: (MeditationSessionResult) -> Void

    // MARK: - Session State

    /// Whether the session is currently active
    @State private var isSessionActive: Bool = false

    /// Current session phase (preparation, active, completion)
    @State private var sessionPhase: SessionPhase = .preparation

    /// Session start time for duration tracking
    @State private var sessionStartTime: Date?

    /// Current session duration
    @State private var sessionDuration: TimeInterval = 0

    /// Timer for session updates
    @State private var sessionTimer: Timer?

    /// Current message being displayed to user
    @State private var currentMessage: String = ""

    /// Navigation state for HRV biofeedback view
    @State private var showHRVBiofeedback: Bool = false

    /// Index for rotating through type-specific messages
    @State private var messageIndex: Int = 0

    /// Whether to show session controls
    @State private var showControls: Bool = true

    /// Whether user wants to end the session
    @State private var showEndSessionDialog: Bool = false

    // MARK: - Environment

    /// HealthKit manager for heart rate data
    @EnvironmentObject private var healthKitManager: HealthKitManager

    /// Presentation mode for dismissing view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // MARK: - Background Theme
                meditationBackground

                // MARK: - Main Content
                VStack(spacing: 0) {

                    // Session Header
                    if showControls || sessionPhase == .preparation {
                        sessionHeader
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    Spacer()

                    // Main Content Area
                    if sessionPhase == .active {
                        // Show active session content or trigger navigation
                        Text("Session Active - Navigating to HRV...")
                            .font(.headline)
                            .foregroundColor(.white)
                            .onAppear {
                                showHRVBiofeedback = true
                            }
                    } else if sessionPhase == .preparation {
                        preparationContent
                    } else if sessionPhase == .completion {
                        completionContent
                    }

                    Spacer()

                    // Current Message Display
                    messageDisplay

                    // Session Controls
                    if showControls {
                        sessionControls
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding()

                // MARK: - Overlays

                // Controls toggle gesture area
                controlToggleArea

            }
        }
        .navigationBarHidden(true)
        .statusBarHidden()
        .onAppear {
            setupSession()
        }
        .onDisappear {
            endSession()
        }
        .alert("End Meditation Session?", isPresented: $showEndSessionDialog) {
            Button("Continue", role: .cancel) { }
            Button("End Session", role: .destructive) {
                completeSession()
            }
        } message: {
            Text("Your progress will be saved. You can always return to continue your practice.")
        }
        .navigationDestination(isPresented: $showHRVBiofeedback) {
            HRVBiofeedbackView(meditationType: meditationType) {
                showHRVBiofeedback = false
                completeSession()
            }
            .environmentObject(healthKitManager)
        }
    }

    // MARK: - Background Theme

    private var meditationBackground: some View {
        LinearGradient(
            colors: backgroundColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 3.0), value: sessionPhase)
    }

    private var backgroundColors: [Color] {
        let primaryColor = meditationType.primaryColor

        switch sessionPhase {
        case .preparation:
            return [primaryColor.opacity(0.1), primaryColor.opacity(0.05)]
        case .active:
            // Colors evolve based on session progress and coherence
            return [primaryColor.opacity(0.15), primaryColor.opacity(0.25), Color.black.opacity(0.1)]
        case .completion:
            return [Color.green.opacity(0.1), primaryColor.opacity(0.2), Color.gold.opacity(0.1)]
        }
    }

    // MARK: - Session Header

    private var sessionHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { showEndSessionDialog = true }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.primary.opacity(0.7))
                }

                Spacer()

                VStack {
                    Image(systemName: meditationType.icon)
                        .font(.title2)
                        .foregroundColor(meditationType.primaryColor)

                    Text(meditationType.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                }

                Spacer()

                // Session duration
                Text(formatDuration(sessionDuration))
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }

            if sessionPhase == .active {
                // Progress indicator for timed sessions
                if let targetDuration = sessionConfig.duration {
                    progressBar(current: sessionDuration, target: targetDuration)
                }
            }
        }
    }

    private func progressBar(current: TimeInterval, target: TimeInterval) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 6)

                RoundedRectangle(cornerRadius: 4)
                    .fill(meditationType.primaryColor)
                    .frame(
                        width: geometry.size.width * CGFloat(min(1.0, current / target)),
                        height: 6
                    )
                    .animation(.easeInOut(duration: 0.5), value: current)
            }
        }
        .frame(height: 6)
    }

    // MARK: - Preparation Content

    private var preparationContent: some View {
        VStack(spacing: 32) {

            // Meditation type icon
            Image(systemName: meditationType.icon)
                .font(.system(size: 80))
                .foregroundColor(meditationType.primaryColor)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isSessionActive)

            VStack(spacing: 16) {
                Text("Prepare for")
                    .font(.title3)
                    .foregroundColor(.secondary)

                Text(meditationType.displayName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(meditationType.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Start button
            Button(action: startSession) {
                Text("Begin Session")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(meditationType.primaryColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
    }

    // MARK: - Completion Content

    private var completionContent: some View {
        VStack(spacing: 32) {

            // Success animation
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isSessionActive ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isSessionActive)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
            }

            VStack(spacing: 16) {
                Text("Session Complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Beautiful work! Your \(meditationType.displayName.lowercased()) practice is complete.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Session stats would go here
                sessionStats
            }

            // Done button
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Complete")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
    }

    private var sessionStats: some View {
        HStack(spacing: 30) {
            VStack {
                Text(formatDuration(sessionDuration))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(meditationType.primaryColor)

                Text("Duration")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Add more stats here based on HRV data
            VStack {
                Text("✨")
                    .font(.title2)

                Text("Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Message Display

    private var messageDisplay: some View {
        VStack(spacing: 12) {
            if !currentMessage.isEmpty {
                Text(currentMessage)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(minHeight: 80)
    }

    // MARK: - Session Controls

    private var sessionControls: some View {
        HStack(spacing: 20) {

            // Pause/Resume button
            Button(action: toggleSessionPause) {
                Image(systemName: isSessionActive ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(meditationType.primaryColor)
            }

            // End session button
            Button(action: { showEndSessionDialog = true }) {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.red.opacity(0.8))
            }

        }
        .padding(.vertical, 20)
    }

    // MARK: - Control Toggle Area

    private var controlToggleArea: some View {
        VStack {
            Spacer()

            Rectangle()
                .fill(Color.clear)
                .frame(height: 100)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showControls.toggle()
                    }
                }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    // MARK: - Session Management

    private func setupSession() {
        currentMessage = meditationType.openingMessage
        isSessionActive = false
        sessionPhase = .preparation
    }

    private func startSession() {
        // For now, directly complete the session since we'll navigate to HRV view
        completeSession()
    }

    private func updateSessionProgress() {
        guard let startTime = sessionStartTime, isSessionActive else { return }

        sessionDuration = Date().timeIntervalSince(startTime)

        // Check if session should auto-complete
        if let targetDuration = sessionConfig.duration,
           sessionDuration >= targetDuration {
            completeSession()
        }
    }

    private func toggleSessionPause() {
        isSessionActive.toggle()

        if !isSessionActive {
            currentMessage = "Meditation paused. Take your time, then resume when ready."
        } else {
            rotateMessage()
        }
    }

    private func completeSession() {
        withAnimation(.easeInOut(duration: 0.5)) {
            sessionPhase = .completion
            isSessionActive = true // For completion animations
        }

        sessionTimer?.invalidate()
        sessionTimer = nil

        // Create session result
        let result = MeditationSessionResult(
            type: meditationType,
            duration: sessionDuration,
            heartRateImprovement: 0.0, // Placeholder - real data would come from HRV
            achievedOptimalBPM: false, // Placeholder - real data would come from HRV
            coherenceAchievements: 0,  // Placeholder - real data would come from HRV
            sessionQuality: SessionQuality.fair // Placeholder - would be calculated
        )

        onSessionComplete(result)
    }

    private func endSession() {
        sessionTimer?.invalidate()
        sessionTimer = nil
        isSessionActive = false
    }

    // MARK: - Message Management

    private func startMessageRotation() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            guard isSessionActive, sessionPhase == .active else { return }
            rotateMessage()
        }
    }

    private func rotateMessage() {
        let messages = meditationType.coherenceMessages + meditationType.encouragementMessages
        messageIndex = (messageIndex + 1) % messages.count

        withAnimation(.easeInOut(duration: 0.5)) {
            currentMessage = messages[messageIndex]
        }
    }

    // MARK: - Helpers

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60

        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", seconds))"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Supporting Types

enum SessionPhase {
    case preparation
    case active
    case completion
}

// MARK: - Preview

#Preview {
    MeditationSessionView(
        meditationType: MeditationType.affirmation,
        sessionConfig: MeditationSessionConfig.recommended(for: MeditationType.affirmation),
        onSessionComplete: { result in
            print("Session completed: \(result)")
        }
    )
}
