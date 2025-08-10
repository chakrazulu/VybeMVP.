/**
 * Filename: RulingNumberChartView.swift
 *
 * Purpose: Interactive bar chart showing which realm digits appeared most frequently today
 * Replaces the "Cosmic Alignment Factors" panel with gamified ruling number visualization
 */

import SwiftUI

/**
 * Interactive chart that displays today's realm number frequency distribution
 * Shows which number "ruled" the day and provides XP rewards for matches
 *
 * Claude: Enhanced with realm number color theming to match other cosmic views
 */
struct RulingNumberChartView: View {
    /// Claude: Current realm number for color theming consistency
    let realmNumber: Int

    @StateObject private var sampleManager = RealmSampleManager.shared
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager

    @State private var showingCelebration = false
    @State private var selectedBarNumber: Int? = nil
    @State private var barAnimations: [Bool] = Array(repeating: false, count: 9)
    @State private var rulingBarPulse = false
    @State private var isViewReady = false  // Add initialization state
    @State private var showingDetailView = false  // For full-screen detail view

    var body: some View {
        VStack(spacing: 20) {
            // Header
            headerSection

            // Histogram - only show when view is ready
            if isViewReady {
                histogramSection
            } else {
                // Placeholder while loading
                VStack(spacing: 12) {
                    Text("✦ Loading Cosmic Data ✦")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                .frame(height: 120)
            }

            // Footer
            footerSection
        }
        .padding(20)
        .background(cosmicBackground)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        .onAppear {
            // Initialize view state first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isViewReady = true
                startAnimations()
                recordCurrentRealmSample()
            }
        }
        .onReceive(realmNumberManager.$currentRealmNumber) { _ in
            // Record a new sample when realm number changes
            recordCurrentRealmSample()
        }
        .alert("🎉 Cosmic Alignment Achieved!", isPresented: $showingCelebration) {
            Button("Amazing!") { }
        } message: {
            Text("Your Focus Number (\(focusNumberManager.selectedFocusNumber)) ruled the day! You've earned 1 XP.")
        }
        .fullScreenCover(isPresented: $showingDetailView) {
            RulingNumberChartDetailView(isPresented: $showingDetailView)
                .environmentObject(focusNumberManager)
                .environmentObject(realmNumberManager)
        }
    }

    // MARK: - Header Section

    /// Claude: Header displaying today's ruling number with realm-themed styling
    ///
    /// Shows the most frequently occurring realm number today with:
    /// - Prominent ruling number badge with realm color theming
    /// - Crown icon indicating dominance
    /// - Descriptive text explaining the ruling energy
    /// - Quick stats and navigation to detailed analysis
    ///
    /// **Interactive Elements:**
    /// - Tap chart icon to expand to detailed view
    /// - Visual feedback with pulsing animations
    /// - Sacred pattern indicators when applicable
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                // Ruling number badge
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    getSacredColor(for: sampleManager.rulingNumber).opacity(0.8),
                                    getSacredColor(for: sampleManager.rulingNumber).opacity(0.3)
                                ],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(rulingBarPulse ? 1.1 : 1.0)
                        .shadow(color: getSacredColor(for: sampleManager.rulingNumber).opacity(0.6), radius: 10)

                    Text("\(sampleManager.rulingNumber)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("✧ TODAY'S RULING NUMBER ✧")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))

                        Spacer()

                        // Expand button
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            showingDetailView = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.3), .blue.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 36, height: 28)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )

                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        .scaleEffect(rulingBarPulse ? 1.05 : 1.0)
                        .shadow(color: .purple.opacity(0.3), radius: 4)
                    }

                    Text(getRulingDescription())
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }

                // Trophy if it's the ruling number
                if sampleManager.getCount(for: sampleManager.rulingNumber) > 0 {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.6), radius: 5)
                        .scaleEffect(rulingBarPulse ? 1.1 : 1.0)
                }
            }

            // Quick stats row
            HStack(spacing: 16) {
                // Sample count
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.blue.opacity(0.8))
                    Text("\(sampleManager.todaySamples.count) samples")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                // Sacred pattern indicator
                if sampleManager.getSevenDayPattern() > 0.5 {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(.purple.opacity(0.8))
                        Text("Sacred pattern")
                            .font(.caption)
                            .foregroundColor(.purple.opacity(0.8))
                    }
                }

                // Expand hint
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                    Text("Tap chart for details")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
        }
    }

    // MARK: - Histogram Section

    /// Claude: Interactive horizontal bar chart showing realm number frequency
    ///
    /// Displays a beautiful horizontal histogram with:
    /// - Color-coded bars using sacred number colors
    /// - Animated bar growth on view appearance
    /// - Special highlighting for the ruling number
    /// - Crown icons and golden accents for dominance
    /// - Tap interaction for number exploration
    ///
    /// **Visual Features:**
    /// - Consistent 28pt circles for number labels
    /// - Normalized bar widths with minimum visibility
    /// - Golden highlights and pulsing for ruling number
    /// - Smooth animations with staggered timing
    private var histogramSection: some View {
        VStack(spacing: 12) {
            // Horizontal bars layout
            VStack(spacing: 6) {
                ForEach(1...9, id: \.self) { number in
                    let count = sampleManager.getCount(for: number)
                    let maxCount = max(sampleManager.histogram.max() ?? 1, 1) // Ensure minimum 1
                    let normalizedCount = max(count, 0) // Ensure non-negative
                    let barWidth = max(
                        CGFloat(normalizedCount) / CGFloat(maxCount) * 180 + 20, // Min width of 20
                        20 // Absolute minimum width
                    )
                    let isRuling = number == sampleManager.rulingNumber && count > 0

                    // Debug: Ensure all values are valid
                    let safeBarWidth = min(max(barWidth.isFinite && barWidth > 0 ? barWidth : 20, 20), 200)
                    let safeHeight: CGFloat = 12  // Fixed safe height
                    let safeCircleSize: CGFloat = 28  // Fixed safe circle size

                    HStack(spacing: 8) {
                        // Number label
                        ZStack {
                            Circle()
                                .fill(getSacredColor(for: number).opacity(0.7))
                                .frame(width: safeCircleSize, height: safeCircleSize)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            isRuling ? Color.yellow.opacity(0.8) : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: getSacredColor(for: number).opacity(0.4), radius: 4)

                            Text("\(number)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .scaleEffect(isRuling && rulingBarPulse ? 1.1 : 1.0)

                        // Horizontal bar
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 180, height: safeHeight)

                            // Progress bar
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: isRuling ? [
                                            getSacredColor(for: number).opacity(0.9),
                                            getSacredColor(for: number).opacity(0.6),
                                            .yellow.opacity(0.3)
                                        ] : [
                                            getSacredColor(for: number).opacity(0.7),
                                            getSacredColor(for: number).opacity(0.4)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: barAnimations.indices.contains(number - 1) && barAnimations[number - 1] ? safeBarWidth : 20,
                                    height: safeHeight
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(
                                            isRuling ? Color.yellow.opacity(0.8) : Color.clear,
                                            lineWidth: isRuling ? 1 : 0
                                        )
                                )
                                .shadow(
                                    color: isRuling ? .yellow.opacity(0.4) : getSacredColor(for: number).opacity(0.3),
                                    radius: isRuling ? 6 : 3
                                )
                                .scaleEffect(
                                    isRuling && rulingBarPulse ? 1.02 : 1.0
                                )
                        }
                        .onTapGesture {
                            selectedBarNumber = number
                            handleBarTap(number: number)
                        }

                        // Count label
                        Text("\(count)")
                            .font(.caption)
                            .fontWeight(isRuling ? .bold : .medium)
                            .foregroundColor(isRuling ? .yellow : .white.opacity(0.6))
                            .frame(minWidth: 20)

                        // Crown for ruling number
                        if isRuling && count > 0 {
                            Image(systemName: "crown.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.6), radius: 3)
                        }

                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        VStack(spacing: 12) {
            // Exploration prompt
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue.opacity(0.8))
                Text("🔍 Tap a bar to explore that number's meaning")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
            }

            // XP reward section
            HStack {
                Image(systemName: "ticket")
                    .foregroundColor(.green.opacity(0.8))

                if canEarnXPReward() {
                    Button(action: claimXPReward) {
                        Text("🎟️ Earn 1 XP - Your Focus number ruled today!")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.green)
                    }
                } else if focusNumberManager.selectedFocusNumber == sampleManager.rulingNumber {
                    Text("🎟️ XP already earned today for this alignment")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    Text("🎟️ Match your Focus (\(focusNumberManager.selectedFocusNumber)) with the Ruling number to earn XP")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            // Enhanced footer with detail view hint
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Based on \(sampleManager.todaySamples.count) cosmic observations today")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))

                    HStack(spacing: 4) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.caption)
                            .foregroundColor(.purple.opacity(0.6))
                        Text("View 30-day trends and sacred patterns")
                            .font(.caption)
                            .foregroundColor(.purple.opacity(0.6))
                    }
                }

                Spacer()

                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingDetailView = true
                }) {
                    HStack(spacing: 6) {
                        Text("Analyze")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)

                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.4), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 5)
                }
                .scaleEffect(rulingBarPulse ? 1.02 : 1.0)
            }
        }
    }

    // MARK: - Helper Methods

    private func startAnimations() {
        // Ensure barAnimations array is properly sized
        if barAnimations.count != 9 {
            barAnimations = Array(repeating: false, count: 9)
        }

        // Reset all animations first
        barAnimations = Array(repeating: false, count: 9)

        // Animate bars growing with a small delay to ensure proper initialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            for i in 0..<9 {
                withAnimation(.easeOut(duration: 0.5).delay(Double(i) * 0.1)) {
                    if i < self.barAnimations.count {
                        self.barAnimations[i] = true
                    }
                }
            }
        }

        // Pulse ruling bar with additional delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                self.rulingBarPulse = true
            }
        }
    }

    private func recordCurrentRealmSample() {
        sampleManager.recordSample(
            realmDigit: realmNumberManager.currentRealmNumber,
            source: .viewAppear
        )
    }

    private func handleBarTap(number: Int) {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        // Navigate to number meaning (you can implement navigation here)
        print("🔍 User tapped bar for number \(number)")

        // For now, open the detail view
        showingDetailView = true
    }

    private func canEarnXPReward() -> Bool {
        return focusNumberManager.selectedFocusNumber == sampleManager.rulingNumber &&
               sampleManager.getCount(for: sampleManager.rulingNumber) > 0 &&
               !hasEarnedXPToday()
    }

    private func hasEarnedXPToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let key = "lastXPAward_\(today.timeIntervalSince1970)"
        return UserDefaults.standard.bool(forKey: key)
    }

    private func claimXPReward() {
        if sampleManager.checkForXPReward(focusNumber: focusNumberManager.selectedFocusNumber) {
            // Trigger celebration
            showingCelebration = true

            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()

            // You can also add XP to a user points system here
            print("🎉 User earned 1 XP for cosmic alignment!")
        }
    }

    private func getRulingDescription() -> String {
        let descriptions = [
            "Genesis energy dominates",
            "Duality and balance prevail",
            "Creative expression flows",
            "Foundation energy anchors",
            "Freedom and change surge",
            "Harmony and love resonate",
            "Mystery and wisdom emerge",
            "Abundance and cycles renew",
            "Completion and unity reign"
        ]

        let index = max(0, min(sampleManager.rulingNumber - 1, descriptions.count - 1))
        return descriptions[index]
    }

    // MARK: - Cosmic Background Style

    /// Claude: Cosmic background matching CosmicSnapshotView style with realm number color tint
    private var cosmicBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.6),
                                getRealmColor(for: realmNumber).opacity(0.2),
                                Color.black.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.3),
                                getRealmColor(for: realmNumber).opacity(0.4),
                                .white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }

    /// Claude: Get realm color matching the app's sacred color system
    private func getRealmColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // gold
        case 9: return .white
        default: return .white
        }
    }

    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // gold
        case 9: return .white
        default: return .white
        }
    }
}

// MARK: - Preview

struct RulingNumberChartView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            RulingNumberChartView(realmNumber: 5)
                .environmentObject(FocusNumberManager.shared)
                .environmentObject(RealmNumberManager())
        }
    }
}
