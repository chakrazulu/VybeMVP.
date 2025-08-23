import SwiftUI

/**
 * VFI Model Card View - Transparency & Education
 * ==============================================
 *
 * User-facing explanation of the Vybe Frequency Index system.
 * Provides scientific context, transparency about symbolic vs literal
 * measurements, and educational content about consciousness mapping.
 *
 * Key Goals:
 * - Explain VFI is an index, not literal hertz
 * - Show how numerology + biometrics combine
 * - Build trust through transparency
 * - Educate about HRV and consciousness
 *
 * Created: August 2025
 * Version: 1.0.0
 */

struct VFIModelCard: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    heroSection

                    // Tab Selection
                    Picker("Section", selection: $selectedTab) {
                        Text("Overview").tag(0)
                        Text("Science").tag(1)
                        Text("Privacy").tag(2)
                        Text("FAQ").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Content based on tab
                    Group {
                        switch selectedTab {
                        case 0:
                            overviewContent
                        case 1:
                            scienceContent
                        case 2:
                            privacyContent
                        case 3:
                            faqContent
                        default:
                            overviewContent
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut, value: selectedTab)
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("About VFI")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Animated VFI Display
            HStack(spacing: 8) {
                Image(systemName: "waveform.path.ecg")
                    .font(.largeTitle)
                    .foregroundStyle(.linearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))

                Text("VFI")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.linearGradient(
                        colors: [.purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            }

            Text("Vybe Frequency Index")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Your Consciousness, Measured & Understood")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(0.8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
    }

    // MARK: - Overview Content

    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoCard(
                icon: "sparkles",
                title: "What is VFI?",
                content: """
                The Vybe Frequency Index (VFI) is a consciousness measurement system that combines:

                • Your numerological profile (sacred numbers 1-9)
                • Real-time biometric data (heart coherence)
                • Cosmic influences (planetary positions)
                • Sacred patterns (Fibonacci, Tesla 3-6-9)

                VFI creates a personalized "consciousness frequency" ranging from 20-1000+ VHz (Vybe Hertz).
                """
            )

            importantNote

            infoCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "How It Works",
                content: """
                1. **Baseline**: Your numerological number provides a spiritual foundation

                2. **Real-time**: Apple Watch tracks your HRV (heart rate variability)

                3. **Fusion**: Algorithm combines all inputs with personalized weights

                4. **Result**: Your current consciousness frequency in VHz

                The system learns your patterns over 14 days for personalized accuracy.
                """
            )

            consciousnessZonesCard
        }
    }

    // MARK: - Science Content

    private var scienceContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoCard(
                icon: "heart.text.square",
                title: "HRV & Emotional States",
                content: """
                Scientific research from HeartMath Institute shows:

                • **Positive emotions** (love, gratitude) create smooth, coherent heart rhythm patterns

                • **Negative emotions** (stress, anger) create erratic, jagged patterns

                • **Coherence peak** at ~0.1 Hz indicates optimal psychophysiological state

                VFI translates these patterns into consciousness frequencies.
                """
            )

            infoCard(
                icon: "brain.head.profile",
                title: "Consciousness Mapping",
                content: """
                Based on research correlating emotional states with "vibrational" levels:

                • **20-200 VHz**: Survival states (fear, anger)
                • **200-400 VHz**: Growth states (courage, willingness)
                • **400-600 VHz**: Love states (acceptance, reason)
                • **600-800 VHz**: Joy states (peace, bliss)
                • **800+ VHz**: Unity consciousness

                These are symbolic frequencies representing consciousness states, not physical measurements.
                """
            )

            infoCard(
                icon: "figure.mind.and.body",
                title: "Biometric Integration",
                content: """
                Apple Watch provides:

                • **HRV data**: Beat-to-beat heart intervals
                • **Coherence scoring**: Spectral analysis of heart patterns
                • **Breathing rate**: Respiratory sinus arrhythmia
                • **Activity context**: Movement and exercise state

                All processed on-device using Apple's Accelerate framework for privacy.
                """
            )
        }
    }

    // MARK: - Privacy Content

    private var privacyContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoCard(
                icon: "lock.shield",
                title: "Your Data Stays Private",
                content: """
                **100% On-Device Processing**

                • All VFI calculations happen on your iPhone
                • No biometric data is sent to servers
                • No third-party access to health data
                • You control all permissions

                We use Apple's HealthKit with strict privacy standards.
                """
            )

            infoCard(
                icon: "person.badge.shield.checkmark",
                title: "Data You Control",
                content: """
                **You decide what to share:**

                • Heart rate data (optional)
                • HRV measurements (optional)
                • Mindfulness minutes (optional)
                • Location for cosmic calculations (optional)

                VFI works without biometrics using numerology alone.
                """
            )

            infoCard(
                icon: "chart.bar.xaxis",
                title: "14-Day Calibration",
                content: """
                **Personalization Without Tracking**

                • Calibration data stays on device
                • No profile building on servers
                • Delete anytime in Settings
                • Export your data anytime

                Your consciousness patterns are yours alone.
                """
            )
        }
    }

    // MARK: - FAQ Content

    private var faqContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            faqItem(
                question: "Is VFI measuring real frequencies?",
                answer: "No. VFI uses 'VHz' as a symbolic scale for consciousness states, similar to how the pH scale measures acidity. It's an index combining multiple factors, not a literal frequency measurement."
            )

            faqItem(
                question: "Do I need an Apple Watch?",
                answer: "No. VFI works with numerology and cosmic data alone. Apple Watch adds biometric precision but isn't required."
            )

            faqItem(
                question: "How accurate is the consciousness detection?",
                answer: "VFI correlates HRV patterns with emotional states based on published research. The 14-day calibration personalizes accuracy to your unique patterns."
            )

            faqItem(
                question: "Can VFI diagnose medical conditions?",
                answer: "No. VFI is for spiritual wellness and self-awareness only. It is not a medical device and cannot diagnose, treat, or cure any condition."
            )

            faqItem(
                question: "Why combine science with numerology?",
                answer: "We bridge ancient wisdom with modern biometrics to create a holistic view of consciousness. The science grounds the spiritual, while numerology adds archetypal depth."
            )

            faqItem(
                question: "How does calibration work?",
                answer: "Over 14 days, VFI learns your personal patterns - how your biometrics correlate with different states. This creates personalized weights for the fusion algorithm."
            )
        }
    }

    // MARK: - Components

    private func infoCard(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.linearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()
            }

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
    }

    private var importantNote: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("Important")
                    .font(.headline)
                    .foregroundColor(.orange)

                Text("VFI is an index, not literal hertz. 'VHz' represents consciousness states symbolically, like how pH measures acidity on a scale.")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var consciousnessZonesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundStyle(.linearGradient(
                        colors: [.red, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))

                Text("Consciousness Zones")
                    .font(.headline)

                Spacer()
            }

            VStack(spacing: 8) {
                zoneRow(color: .red, range: "20-200", label: "Survival")
                zoneRow(color: .orange, range: "200-400", label: "Courage")
                zoneRow(color: .green, range: "400-600", label: "Love")
                zoneRow(color: .blue, range: "600-800", label: "Joy")
                zoneRow(color: .purple, range: "800+", label: "Unity")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
    }

    private func zoneRow(color: Color, range: String, label: String) -> some View {
        HStack {
            Circle()
                .fill(color.gradient)
                .frame(width: 12, height: 12)

            Text(range)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)

            Text(label)
                .font(.caption)
                .foregroundColor(.primary)

            Spacer()
        }
    }

    private func faqItem(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.blue)

                Text(question)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 28)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    VFIModelCard()
}
