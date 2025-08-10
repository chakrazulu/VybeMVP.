/*
 * ========================================
 * 🌌 SACRED NUMEROLOGY ENCYCLOPEDIA VIEW
 * ========================================
 *
 * CORE PURPOSE:
 * Interactive cosmic encyclopedia displaying deep meanings, symbolism, and spiritual applications
 * for numbers 0-9. Features dynamic sacred color theming, rotating cosmic animations, and
 * comprehensive mystical content presentation.
 *
 * UI SPECIFICATIONS:
 * - Screen: Full-screen cosmic experience with CosmicBackgroundView
 * - Number Selector: 5-column LazyVGrid, 40×40pt circles with sacred color theming
 * - Main Display: 120×120pt cosmic number circle with rotating outer ring (130×130pt)
 * - Content Cards: 20pt radius, sacred gradient backgrounds with 2-3pt borders
 * - Floating Symbols: 6 procedural cosmic symbols with randomized positions
 *
 * SACRED COLOR SYSTEM:
 * 0=White(Infinite Void), 1=Red(Prime Spark), 2=Orange(Sacred Union), 3=Yellow(Creative Trinity)
 * 4=Green(Foundation), 5=Blue(Freedom), 6=Indigo(Harmony), 7=Purple(Mystic Eye)
 * 8=Gold(Power Crown), 9=White(Universal Circle)
 *
 * ANIMATION TIMINGS:
 * - Title Pulse: 2.0s ease-in-out cycle
 * - Cosmic Rotation: 20.0s linear continuous
 * - Floating Effect: 3.0s ease-in-out ±8pt offset
 * - Sparkle Phase: 4.0s linear continuous
 * - Number Pulse: 1.5s ease-in-out ±3% scale
 * - Section Glow: 2.5s ease-in-out glow cycle
 *
 * CONTENT STRUCTURE:
 * 1. Enhanced Mystical Title (28pt bold, sacred gradient text)
 * 2. Cosmic Number Selector (0-9 grid with selection animations)
 * 3. Enhanced Number Display (large cosmic circle + metadata)
 * 4. Three Meaning Sections: Essence, Symbolism, Application
 * 5. Universal Integration Notes (expandable spiritual guidance)
 *
 * INTEGRATION POINTS:
 * - NumberMeaningManager: Content provider for all numerology data
 * - RealmNumberView: Navigation source with initialSelectedNumber parameter
 * - CosmicBackgroundView: Shared cosmic aesthetic layer
 * - Sacred color system: Unified throughout app
 *
 * PERFORMANCE NOTES:
 * - 6 floating symbols with staggered animation phases
 * - TimelineView recommended for scroll-safe cosmic animations
 * - Lazy loading of meaning content via NumberMeaningManager
 * - Optimized shadow rendering with multiple color layers
 *
 * MYSTICAL FEATURES:
 * - Dynamic sacred color theming based on selected number
 * - Procedural floating cosmic symbols with sine wave motion
 * - Multi-layer shadow effects for depth and cosmic glow
 * - Sacred gradient text with multiple color stops
 * - Rotating cosmic rings with angular gradients
 * - Responsive scaling effects on selection
 */

import SwiftUI

struct NumberMeaningView: View {
    @State private var selectedNumber: Int
    // Claude: Updated to use SwiftData SpiritualDataController instead of NumberMeaningManager
    @EnvironmentObject private var spiritualDataController: SpiritualDataController
    // Claude: KASPER v2.1.2 - RuntimeBundle integration for rich spiritual content
    @ObservedObject private var contentRouter = KASPERContentRouter.shared
    @State private var richContent: [String: Any]? = nil
    @State private var isLoadingContent = false

    // Animation states
    @State private var titlePulse: CGFloat = 1.0
    @State private var cosmicRotation: Double = 0
    @State private var floatingOffset: CGFloat = 0
    @State private var sparklePhase: Double = 0
    @State private var selectedNumberPulse: CGFloat = 1.0

    // Allow initialization with a specific number (for navigation from RealmNumberView)
    init(initialSelectedNumber: Int = 1) {
        _selectedNumber = State(initialValue: initialSelectedNumber)
    }

    var body: some View {
        ZStack {
            // Cosmic background with space travel effect
            CosmicBackgroundView()
                .ignoresSafeArea()

            // Floating cosmic symbols
            floatingCosmicSymbols

        ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    // Enhanced mystical title
                    enhancedMysticalTitle

                    // Enhanced cosmic number selector
                    enhancedCosmicNumberSelector

                // Claude: Loading rich content from RuntimeBundle
                VStack(spacing: 20) {
                    if isLoadingContent {
                        ProgressView("Loading spiritual knowledge...")
                            .foregroundColor(.white)
                            .padding()
                    } else if let content = richContent {
                        // Display rich content from RuntimeBundle
                        richContentDisplay(content)
                    } else {
                        // Fallback display
                        Text("Number \(selectedNumber)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        sacredColor(for: selectedNumber),
                                        sacredColor(for: selectedNumber).opacity(0.7)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Tap to load spiritual insights...")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .italic()
                    }
                }
                .task(id: selectedNumber) {
                    await loadRichContent()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(sacredColor(for: selectedNumber).opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(sacredColor(for: selectedNumber).opacity(0.5), lineWidth: 2)
                        )
                )

                    Spacer(minLength: 80)
            }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Sacred Numbers")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // TODO: Implement SwiftData NumberMeaning loading
            // manager.setupInitialMeanings()
            startMysticalAnimations()
        }
    }

    // MARK: - Enhanced Mystical Title

    private var enhancedMysticalTitle: some View {
        VStack(spacing: 15) {
            // Cosmic decorative elements
            HStack(spacing: 20) {
                ForEach(0..<3, id: \.self) { _ in
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(sacredColor(for: selectedNumber).opacity(0.8))
                        .rotationEffect(.degrees(cosmicRotation))
                        .scaleEffect(titlePulse)
                }
            }

            Text("✦ SACRED NUMEROLOGY ✦")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white,
                            sacredColor(for: selectedNumber).opacity(0.9),
                            .cyan.opacity(0.6),
                            sacredColor(for: selectedNumber).opacity(0.7)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: sacredColor(for: selectedNumber).opacity(0.6), radius: 8, x: 0, y: 4)
                .shadow(color: .white.opacity(0.4), radius: 15, x: 0, y: 0)
                .scaleEffect(titlePulse)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            // Mystical subtitle
            Text("✧ Unlock the Cosmic Mysteries ✧")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .italic()
                .offset(y: floatingOffset)
        }
        .padding(.top, 30)
    }

    // MARK: - Enhanced Cosmic Number Selector

    private var enhancedCosmicNumberSelector: some View {
        VStack(spacing: 20) {
            Text("Choose Your Sacred Number")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, sacredColor(for: selectedNumber).opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: sacredColor(for: selectedNumber).opacity(0.4), radius: 5)

            // Custom cosmic number picker with enhanced effects
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                ForEach(0...9, id: \.self) { number in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            selectedNumber = number
                        }
                    }) {
                        ZStack {
                            // Outer cosmic ring for selected number
                            if selectedNumber == number {
                                Circle()
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [
                                                sacredColor(for: number),
                                                sacredColor(for: number).opacity(0.3),
                                                sacredColor(for: number),
                                                sacredColor(for: number).opacity(0.3)
                                            ]),
                                            center: .center
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(.degrees(cosmicRotation))
                            }

                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            sacredColor(for: number).opacity(selectedNumber == number ? 0.9 : 0.6),
                                            sacredColor(for: number).opacity(selectedNumber == number ? 0.5 : 0.3),
                                            Color.black.opacity(0.3)
                                        ]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 20
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(sacredColor(for: number).opacity(0.8), lineWidth: 1)
                                )
                                .shadow(
                                    color: sacredColor(for: number).opacity(selectedNumber == number ? 0.8 : 0.4),
                                    radius: selectedNumber == number ? 12 : 6,
                                    x: 0,
                                    y: 0
                                )

                            Text("\(number)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 2)
                        }
                        .scaleEffect(selectedNumber == number ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: selectedNumber)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            sacredColor(for: selectedNumber).opacity(0.15),
                            Color.black.opacity(0.4),
                            sacredColor(for: selectedNumber).opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    sacredColor(for: selectedNumber).opacity(0.6),
                                    sacredColor(for: selectedNumber).opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: sacredColor(for: selectedNumber).opacity(0.3), radius: 20, x: 0, y: 10)
    }

    // MARK: - Enhanced Cosmic Number Display (Disabled for SwiftData Migration)

    /*
    private func enhancedCosmicNumberDisplay(meaning: NumberMeaning) -> some View {
        HStack(spacing: 25) {
            // Enhanced large cosmic number
            ZStack {
                // Outer rotating cosmic ring
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                sacredColor(for: selectedNumber).opacity(0.8),
                                sacredColor(for: selectedNumber).opacity(0.3),
                                sacredColor(for: selectedNumber),
                                sacredColor(for: selectedNumber).opacity(0.1)
                            ]),
                            center: .center
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 130, height: 130)
                    .rotationEffect(.degrees(cosmicRotation))

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                sacredColor(for: selectedNumber).opacity(0.9),
                                sacredColor(for: selectedNumber).opacity(0.5),
                                sacredColor(for: selectedNumber).opacity(0.2),
                                Color.black.opacity(0.3)
                            ]),
                            center: .center,
                            startRadius: 15,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: sacredColor(for: selectedNumber).opacity(0.8), radius: 25, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.4), radius: 15, x: 0, y: 0)
                    .scaleEffect(selectedNumberPulse)

                Text("\(selectedNumber)")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, sacredColor(for: selectedNumber).opacity(0.9)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.8), radius: 3, x: 2, y: 2)
                    .shadow(color: sacredColor(for: selectedNumber), radius: 20, x: 0, y: 0)
                    .scaleEffect(selectedNumberPulse)
            }

            // Enhanced title and description
            VStack(alignment: .leading, spacing: 12) {
                Text(meaning.title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                sacredColor(for: selectedNumber),
                                sacredColor(for: selectedNumber).opacity(0.7)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: sacredColor(for: selectedNumber).opacity(0.5), radius: 8, x: 0, y: 2)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                Text("Sacred Number \(selectedNumber)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        sacredColor(for: selectedNumber).opacity(0.3),
                                        sacredColor(for: selectedNumber).opacity(0.1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(sacredColor(for: selectedNumber).opacity(0.6), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: sacredColor(for: selectedNumber).opacity(0.3), radius: 8)

                // Mystical essence preview
                Text("✧ \(getMysticalEssence(for: selectedNumber)) ✧")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(sacredColor(for: selectedNumber).opacity(0.9))
                    .italic()
                    .offset(y: floatingOffset * 0.5)
            }

            Spacer()
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            sacredColor(for: selectedNumber).opacity(0.2),
                            Color.black.opacity(0.5),
                            sacredColor(for: selectedNumber).opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    sacredColor(for: selectedNumber).opacity(0.8),
                                    sacredColor(for: selectedNumber).opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
        )
        .shadow(color: sacredColor(for: selectedNumber).opacity(0.4), radius: 25, x: 0, y: 15)
    }
    */

    // MARK: - Enhanced Universal Integration Section (Disabled for SwiftData Migration)

    /*
    private func enhancedUniversalIntegrationSection(meaning: NumberMeaning) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "infinity.circle.fill")
                    .font(.title2)
                    .foregroundColor(sacredColor(for: selectedNumber))
                    .shadow(color: sacredColor(for: selectedNumber).opacity(0.6), radius: 8)

                Text("✧ ✦ UNIVERSAL INTEGRATION ✦ ✧")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                sacredColor(for: selectedNumber),
                                sacredColor(for: selectedNumber).opacity(0.7)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: sacredColor(for: selectedNumber).opacity(0.4), radius: 5)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                Spacer()
            }

            ForEach(Array(meaning.notes.enumerated()), id: \.offset) { index, note in
                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "star.circle.fill")
                        .font(.title3)
                        .foregroundColor(sacredColor(for: selectedNumber).opacity(0.8))
                        .shadow(color: sacredColor(for: selectedNumber).opacity(0.4), radius: 5)
                        .offset(y: floatingOffset * 0.3)

                    Text(note)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                        .lineSpacing(6)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    sacredColor(for: selectedNumber).opacity(0.2),
                                    Color.black.opacity(0.5),
                                    sacredColor(for: selectedNumber).opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(sacredColor(for: selectedNumber).opacity(0.5), lineWidth: 1.5)
                        )
                )
                .shadow(color: sacredColor(for: selectedNumber).opacity(0.2), radius: 12, x: 0, y: 6)
            }
        }
        .padding(.top, 15)
    }
    */

    // MARK: - Floating Cosmic Symbols

    private var floatingCosmicSymbols: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Image(systemName: ["sparkles", "star.fill", "moon.stars.fill", "sun.max.fill", "infinity", "eye.fill"].randomElement() ?? "sparkles")
                    .font(.system(size: CGFloat.random(in: 12...20)))
                    .foregroundColor(sacredColor(for: selectedNumber).opacity(Double.random(in: 0.2...0.6)))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    )
                    .offset(y: sin(sparklePhase + Double(index)) * 20)
                    .animation(.easeInOut(duration: Double.random(in: 3...6)).repeatForever(), value: sparklePhase)
            }
        }
    }

    // MARK: - Helper Functions

    private func startMysticalAnimations() {
        // Title pulsing
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            titlePulse = 1.05
        }

        // Cosmic rotation
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            cosmicRotation = 360
        }

        // Floating effect
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            floatingOffset = 8
        }

        // Sparkle phase
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            sparklePhase = .pi * 2
        }

        // Selected number pulse
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            selectedNumberPulse = 1.03
        }
    }

    private func getMysticalEssence(for number: Int) -> String {
        let essences = [
            "The Infinite Void", "The Prime Spark", "The Sacred Union",
            "The Creative Trinity", "The Foundation Stone", "The Freedom Flow",
            "The Harmony Heart", "The Mystic Eye", "The Power Crown", "The Universal Circle"
        ]
        return essences[number]
    }

    // MARK: - Content Loading Methods

    // Claude: Load rich content from RuntimeBundle
    private func loadRichContent() async {
        isLoadingContent = true
        defer { isLoadingContent = false }

        // Load rich content from RuntimeBundle
        if let content = await contentRouter.getRichContent(for: selectedNumber) {
            await MainActor.run {
                richContent = content
                print("✅ Loaded rich content for number \(selectedNumber)")
            }
        } else {
            // Try fallback to behavioral content
            if let behavioral = await contentRouter.getBehavioralInsights(
                context: "lifePath",
                number: selectedNumber
            ) {
                await MainActor.run {
                    richContent = behavioral
                    print("⚠️ Using behavioral content as fallback for number \(selectedNumber)")
                }
            } else {
                await MainActor.run {
                    richContent = nil
                    print("❌ No content found for number \(selectedNumber)")
                }
            }
        }
    }

    // Claude: Display rich content from RuntimeBundle
    @ViewBuilder
    private func richContentDisplay(_ content: [String: Any]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Display primary meaning
            if let meanings = content["meanings"] as? [String: Any],
               let primary = meanings["primary"] as? String {
                Text("Primary Meaning")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(primary)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(sacredColor(for: selectedNumber).opacity(0.2))
                    )
            }

            // Display symbolism
            if let symbolism = content["symbolism"] as? [String] {
                Text("Symbolism")
                    .font(.headline)
                    .foregroundColor(.white)
                ForEach(symbolism, id: \.self) { symbol in
                    HStack {
                        Image(systemName: "sparkle")
                            .foregroundColor(sacredColor(for: selectedNumber))
                        Text(symbol)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }

            // Display applications
            if let applications = content["applications"] as? [String] {
                Text("Applications")
                    .font(.headline)
                    .foregroundColor(.white)
                ForEach(applications, id: \.self) { app in
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(sacredColor(for: selectedNumber))
                        Text(app)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
    }

    // MARK: - Sacred Color System

    private func sacredColor(for number: Int) -> Color {
        switch number {
        case 0: return .white
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

struct EnhancedCosmicMeaningSection: View {
    let title: String
    let content: String
    let accentColor: Color
    let icon: String

    @State private var sectionGlow: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Enhanced title with icon
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(accentColor)
                    .shadow(color: accentColor.opacity(0.6), radius: 10, x: 0, y: 0)
                    .scaleEffect(sectionGlow)

            Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                accentColor,
                                accentColor.opacity(0.8),
                                .white.opacity(0.9)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: accentColor.opacity(0.5), radius: 8, x: 0, y: 2)
                    .shadow(color: .white.opacity(0.3), radius: 12, x: 0, y: 0)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Mystical decoration
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(accentColor.opacity(0.7))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
            }

            // Enhanced content with better styling
            Text(content)
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(8)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    accentColor.opacity(0.18),
                                    Color.black.opacity(0.6),
                                    accentColor.opacity(0.08)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            accentColor.opacity(0.6),
                                            accentColor.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .overlay(
                            // Inner cosmic glow effect
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(accentColor.opacity(sectionGlow * 0.4), lineWidth: 1)
                                .padding(2)
                        )
                )
                .shadow(color: accentColor.opacity(0.3), radius: 15, x: 0, y: 8)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
        }
        .onAppear {
            startSectionAnimation()
        }
    }

    private func startSectionAnimation() {
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            sectionGlow = 1.0
        }
    }
}

#Preview {
    NavigationStack {
        NumberMeaningView()
    }
}
