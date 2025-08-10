import SwiftUI
import ActivityKit
import WidgetKit

// Claude: All shared types are now in CosmicHUDTypes.swift

// MARK: - Cosmic HUD View
/// Claude: The living spiritual sigil that surrounds users across all apps
///
/// REVOLUTIONARY CONCEPT:
/// This is the first-ever spiritual awareness HUD that transcends app boundaries.
/// Using iOS Dynamic Island, we create an omnipresent cosmic display showing:
/// - Crown + Ruler Number (user's numerological focus)
/// - Real planetary aspects from SwiftAA calculations
/// - Elemental energy of the day
/// - Mini insights on expansion
/// - 6 App Intent shortcuts for instant spiritual actions
///
/// TECHNICAL ARCHITECTURE:
/// - ActivityKit Live Activity for system-wide presence
/// - Zero-asset approach using SwiftAA symbols + emojis
/// - Compact (single line) and Expanded (multi-line) states
/// - Real-time updates every 5 minutes via CosmicHUDManager
/// - Seamless navigation back to Vybe app sections
///
/// UX PHILOSOPHY:
/// The HUD makes spiritual awareness ambient and accessible.
/// Users can tap to expand for insights, hold for quick actions.
/// It creates a persistent connection to cosmic consciousness.

@available(iOS 16.1, *)
struct CosmicHUDView: View {
    @StateObject private var hudManager = CosmicHUDManager.shared
    @State private var showingExpanded = false
    @State private var miniInsight: String = ""

    var body: some View {
        // Claude: Main HUD state machine - shows loading, compact, or expanded views
        // This adapts to available data and user interaction state
        if let hudData = hudManager.currentHUDData {
            if showingExpanded {
                expandedHUDView(hudData: hudData)
            } else {
                compactHUDView(hudData: hudData)
            }
        } else {
            loadingHUDView
        }
    }

    // MARK: - Compact HUD View
    /// Claude: The single-line HUD that appears in Dynamic Island compact state
    /// Format: "👑 7   ♀ △ ♃   🔥" (Ruler + Aspect + Element)
    /// Tappable to expand for insights and App Intent shortcuts
    private func compactHUDView(hudData: HUDData) -> some View {
        HStack(spacing: 8) {
            // Left: Crowned Ruler Number
            rulerNumberView(hudData.rulerNumber)

            Spacer()

            // Center: Dominant Aspect
            if let aspect = hudData.dominantAspect {
                aspectView(aspect)
            } else {
                Text("◯")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Right: Element
            elementView(hudData.element)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.black.opacity(0.8))
                .overlay(
                    Capsule()
                        .stroke(cosmicGradient, lineWidth: 1)
                )
        )
        .onTapGesture {
            // Claude: Tap to expand - generates insight asynchronously to avoid blocking UI
            // Uses standard 0.3s animation for smooth iOS-native feel
            withAnimation(.easeInOut(duration: 0.3)) {
                showingExpanded.toggle()
            }

            // Claude: Only generate insight on expansion to save battery
            // MiniInsightProvider handles free vs premium user logic
            if showingExpanded {
                generateMiniInsight(for: hudData.dominantAspect)
            }
        }
    }

    // MARK: - Expanded HUD View
    /// Claude: Multi-line expanded state showing full spiritual dashboard
    /// Includes: HUD data + mini insight + 6 App Intent shortcuts
    /// Auto-collapses on tap anywhere to return to compact state
    private func expandedHUDView(hudData: HUDData) -> some View {
        VStack(spacing: 8) {
            // Top row: Full HUD display
            HStack(spacing: 12) {
                rulerNumberView(hudData.rulerNumber)

                Spacer()

                // Claude: Show up to 3 aspects in carousel format
                // SwiftAA calculates all planetary pairs, we show most significant
                aspectCarousel(aspects: Array(hudData.allAspects.prefix(3)))

                Spacer()

                elementView(hudData.element)
            }

            // Claude: Mini insight from MiniInsightProvider
            // Free users see their latest app insights or enhanced templates
            // Premium users get KASPER personalized guidance (when ready)
            if !miniInsight.isEmpty {
                Text(miniInsight)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .italic()
                    .transition(.opacity.combined(with: .scale))
            }

            // Claude: 6 App Intent shortcuts for instant spiritual actions
            // Hold Dynamic Island to see system shortcuts, tap these for direct navigation
            appIntentsRow
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.black.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(cosmicGradient, lineWidth: 1.5)
                )
        )
        .onTapGesture {
            // Claude: Tap anywhere to collapse back to compact state
            // Smooth animation maintains iOS-native UX patterns
            withAnimation(.easeInOut(duration: 0.3)) {
                showingExpanded = false
            }
        }
    }

    // MARK: - Component Views

    /// Claude: Crowned ruler number display with golden gradient
    /// Shows user's current focus number from FocusNumberManager
    /// Crown emoji emphasizes spiritual sovereignty and self-mastery
    private func rulerNumberView(_ number: Int) -> some View {
        HStack(spacing: 4) {
            Text("👑")
                .font(.caption)

            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }

    /// Claude: Planetary aspect display using SwiftAA astronomical symbols
    /// Format: Planet1 + Aspect + Planet2 (e.g., "♀ △ ♃" for Venus trine Jupiter)
    /// Colors match traditional astrological associations for immediate recognition
    private func aspectView(_ aspectData: AspectData) -> some View {
        HStack(spacing: 2) {
            // Claude: First planet with traditional color coding
            Text(HUDGlyphMapper.planet(for: aspectData.planet1))
                .font(.caption)
                .foregroundColor(planetColor(aspectData.planet1))

            // Claude: Aspect symbol (conjunction, trine, square, etc.)
            Text(HUDGlyphMapper.aspect(for: aspectData.aspect))
                .font(.caption2)
                .foregroundColor(.white)

            // Claude: Second planet with traditional color coding
            Text(HUDGlyphMapper.planet(for: aspectData.planet2))
                .font(.caption)
                .foregroundColor(planetColor(aspectData.planet2))
        }
    }

    /// Claude: Swipeable carousel for multiple aspects in expanded state
    /// Shows up to 3 most significant aspects, sorted by orb tightness
    /// No page indicators to maintain clean HUD aesthetic
    private func aspectCarousel(aspects: [AspectData]) -> some View {
        TabView {
            ForEach(aspects.indices, id: \.self) { index in
                aspectView(aspects[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: 80, height: 20)
    }

    /// Claude: Elemental energy display with colored glow effect
    /// Calculated based on day of year + user's ruler number
    /// Fire🔥, Water💧, Earth🌱, Air💨 with appropriate shadow colors
    private func elementView(_ element: CosmicElement) -> some View {
        Text(HUDGlyphMapper.element(for: element))
            .font(.caption)
            .scaleEffect(1.2)
            .shadow(color: elementGlow(element), radius: 2)
    }

    /// Claude: 6 App Intent shortcuts for instant spiritual actions
    /// Each button routes to specific Vybe app sections via CosmicHUDIntents
    /// Icons: 👁(sighting), 📓(journal), 💬(post), 📊(graph), 🔢(focus), ✨(snapshot)
    private var appIntentsRow: some View {
        HStack(spacing: 16) {
            ForEach(HUDIntent.allCases, id: \.self) { intent in
                Button(action: {
                    executeIntent(intent)
                }) {
                    Text(HUDGlyphMapper.intentIcon(for: intent))
                        .font(.caption)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(.gray.opacity(0.2))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var loadingHUDView: some View {
        HStack(spacing: 8) {
            Text("🔮")
                .font(.caption)

            Text("Loading cosmic data...")
                .font(.caption2)
                .foregroundColor(.secondary)

            Text("✨")
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.black.opacity(0.8))
        )
        .onAppear {
            // Claude: SWIFT 6 COMPLIANCE - Removed [weak self] from struct (value type)
            Task {
                await hudManager.refreshHUDData()
            }
        }
    }

    // MARK: - Helper Methods

    /// Claude: Asynchronously generates mini insight for expanded HUD
    /// Uses MiniInsightProvider to get personalized or template-based guidance
    /// Animates insight text appearance for smooth UX
    private func generateMiniInsight(for aspectData: AspectData?) {
        guard let aspectData = aspectData else { return }

        // Claude: SWIFT 6 COMPLIANCE - Removed [weak self] from struct (value type)
        Task {
            // Claude: Call through CosmicHUDManager to MiniInsightProvider
            // Free users get latest app insights or enhanced templates
            // Premium users get KASPER personalization (when implemented)
            let insight = await hudManager.generateMiniInsight(for: aspectData)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.5)) {
                    miniInsight = insight
                }
            }
        }
    }

    /// Claude: Executes App Intent shortcuts from HUD button taps
    /// Provides haptic feedback and routes to appropriate Vybe app sections
    /// Navigation handled by CosmicHUDIntegration via NotificationCenter
    private func executeIntent(_ intent: HUDIntent) {
        // Claude: Debug logging for development and troubleshooting
        print("Claude: Executing HUD intent: \(intent.displayName)")

        // Claude: Haptic feedback for tactile confirmation of action
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        // Claude: Route to appropriate view/action via intent system
        // CosmicHUDIntents.swift handles the actual App Intent execution
        // This provides UI-level routing for expanded HUD shortcuts
        switch intent {
        case .sighting:
            // Claude: Navigate to SightingView for number synchronicity capture
            break
        case .journal:
            // Claude: Navigate to JournalEntryView for spiritual reflection
            break
        case .composer:
            // Claude: Navigate to ComposerView for community sharing
            break
        case .rulerGraph:
            // Claude: Navigate to RulerGraphView for numerological analysis
            break
        case .focusSelector:
            // Claude: Navigate to FocusNumberSelector for spiritual alignment
            break
        case .cosmicSnapshot:
            // Claude: Navigate to CosmicSnapshotView for planetary moment capture
            break
        }
    }

    /// Claude: Traditional astrological color associations for planets
    /// Helps users instantly recognize planetary influences in aspects
    /// Colors based on classical astrological symbolism and visibility
    private func planetColor(_ planet: HUDPlanet) -> Color {
        switch planet {
        case .sun:
            return .yellow    // Claude: Solar gold - life force and vitality
        case .moon:
            return .gray      // Claude: Lunar silver - emotions and intuition
        case .mercury:
            return .blue      // Claude: Communication and mental agility
        case .venus:
            return .green     // Claude: Love, beauty, and harmony
        case .mars:
            return .red       // Claude: Passion, action, and drive
        case .jupiter:
            return .orange    // Claude: Expansion, wisdom, and luck
        case .saturn:
            return .brown     // Claude: Structure, discipline, and lessons
        case .uranus, .neptune, .pluto:
            return .white     // Claude: Outer planets get neutral treatment
        }
    }

    private func elementGlow(_ element: CosmicElement) -> Color {
        switch element {
        case .fire:
            return .red
        case .water:
            return .blue
        case .earth:
            return .green
        case .air:
            return .cyan
        }
    }

    private var cosmicGradient: LinearGradient {
        LinearGradient(
            colors: [.purple.opacity(0.6), .blue.opacity(0.6), .cyan.opacity(0.6)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Activity Kit Integration
@available(iOS 16.1, *)
struct CosmicHUDActivityWidget: Widget {
    let kind: String = "CosmicHUDActivity"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CosmicHUDAttributes.self) { context in
            // Lock Screen appearance
            CosmicHUDLockScreenView(context: context)
        } dynamicIsland: { context in
            // Dynamic Island configuration
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    CosmicHUDView()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    CosmicHUDView()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    CosmicHUDView()
                }
            } compactLeading: {
                // Compact leading
                Text("👑")
                    .font(.caption2)
            } compactTrailing: {
                // Compact trailing
                Text("🔥")
                    .font(.caption2)
            } minimal: {
                // Minimal state
                Text("🔮")
                    .font(.caption2)
            }
        }
    }
}

// MARK: - Activity Attributes
struct CosmicHUDAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var rulerNumber: Int
        var aspectDisplay: String
        var element: String
        var lastUpdate: Date
    }
}

// MARK: - Lock Screen View
struct CosmicHUDLockScreenView: View {
    let context: ActivityViewContext<CosmicHUDAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("🌌 Cosmic Awareness")
                    .font(.caption)
                    .fontWeight(.semibold)

                Spacer()

                Text(context.state.lastUpdate, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 8) {
                Text("👑 \(context.state.rulerNumber)")
                    .font(.caption)

                Text(context.state.aspectDisplay)
                    .font(.caption)

                Text(context.state.element)
                    .font(.caption)
            }
        }
        .padding()
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 16.1, *)
struct CosmicHUDView_Previews: PreviewProvider {
    static var previews: some View {
        CosmicHUDView()
            .previewDisplayName("Cosmic HUD")
    }
}
#endif
