/**
 * Filename: RealmNumberView.swift
 *
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • Background: Purple gradient cosmic background (matches HomeView)
 * • ScrollSafeCosmicView: Twinkling numbers blooming from sacred geometry center
 * • ScrollView: Full width, vertical scrolling with 60fps cosmic animations
 * • Content VStack: 40pt spacing between sections
 * • Horizontal padding: 20pts on all content
 * • Top padding: 50pts from safe area
 * • Bottom spacer: 100pts minimum
 *
 * === MYSTICAL TITLE ===
 * • Text: "✦ THE REALM NUMBER ✦"
 * • Font: 28pt bold rounded
 * • Gradient: White→Purple(80%)→Blue(60%)
 * • Shadow: White 30% opacity, 5pt blur, 2pt Y offset
 *
 * === REALM NUMBER DISPLAY (350×350pt) ===
 * • Container: NavigationLink wrapper
 * • Sacred geometry: DynamicAssetMandalaView with 60-second clockwise rotation
 * • Neon tracer: Heart rate-synced glow around sacred geometry (320×320pt)
 * • Realm number: 140pt bold rounded (matches HomeView)
 * • Shadow layers: 5 total (20pt, 15pt, 10pt, 5pt, 8pt)
 * • Tap hint: 12pt medium rounded, 70% white opacity
 * • Hint position: 200pt from top of container
 *
 * === REALM DESCRIPTION CARD ===
 * • Container padding: 24pts all sides
 * • Corner radius: 20pts
 * • Title font: 24pt semibold rounded
 * • Description font: 16pt medium rounded, 80% opacity
 * • Line spacing: 4pts
 * • Background gradient: Color(20%)→Black(40%)
 * • Border: 1pt stroke, Color 40% opacity
 * • Shadow: 15pt blur, 8pt Y offset, 30% opacity
 *
 * === RULING NUMBER CHART ===
 * • See RulingNumberChartView.swift for specifications
 * • Full width component
 * • Dynamic height based on content
 *
 * === COLOR SYSTEM (1-9) ===
 * 1. Red (#FF0000)
 * 2. Orange (#FFA500)
 * 3. Yellow (#FFFF00)
 * 4. Green (#00FF00)
 * 5. Blue (#0000FF)
 * 6. Indigo (#4B0082)
 * 7. Purple (#800080)
 * 8. Gold (#FFD700)
 * 9. White (#FFFFFF)
 *
 * === ANIMATIONS ===
 * • Sacred geometry: 60-second clockwise rotation (mystical, meditative cycle)
 * • Cosmic numbers: ScrollSafeCosmicView twinkling bloom-and-fade from geometry center
 * • Neon tracer: Heart rate-synced BPM pulsing around sacred geometry paths
 * • All effects: 60fps performance optimized, scroll-safe continuous animations
 *
 * === INTERACTION ZONES ===
 * • Realm number display: Full 350×350pt tappable
 * • Navigation: Opens NumberMeaningView
 * • Ruling chart: Interactive components within
 *
 * Purpose: Displays the current realm number in a mystical, transcendent cosmic experience.
 * Features complete cosmic animation system with rotating sacred geometry, heart rate-synced
 * neon tracers, and twinkling numbers. The realm number is a cosmic/universal numerical value
 * that changes based on time, date, location, and heart rate factors.
 *
 * Design pattern: Declarative SwiftUI view with full cosmic animation integration
 * Dependencies: RealmNumberManager, HealthKitManager, ScrollSafeCosmicView, NeonTracerView, DynamicAssetMandalaView
 */

import SwiftUI

/**
 * Mystical view that displays the current realm number in a transcendent cosmic experience.
 *
 * The realm number is a central concept in the application, representing a
 * universal numerical value that users can match with their focus number.
 * This enhanced view creates a mystical, Matrix-style visualization with sacred geometry.
 *
 * Key features:
 * 1. Purple gradient cosmic background (matches HomeView aesthetic)
 * 2. ScrollSafeCosmicView twinkling numbers blooming from sacred geometry center
 * 3. Rotating sacred geometry visualization with 60-second clockwise cycle
 * 4. Heart rate-synced neon tracer around the sacred geometry paths
 * 5. Mystical realm description with enhanced cosmic theming
 * 6. Interactive ruling number chart with comprehensive numerology data
 */
struct RealmNumberView: View {
    /// Access to the realm number manager for the current realm number value
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var cosmicService: CosmicService

    @State private var glowIntensity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var isRotationStarted: Bool = false

    // Claude: Phase 8 - Track current mandala asset for authentic SVG path tracing
    @State private var currentMandalaAsset: SacredGeometryAsset = .wisdomEnneagram

    // Timer to sync with mandala rotation (every 30 seconds to match DynamicAssetMandalaView)
    private let assetSyncTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // Purple gradient cosmic background (matches HomeView)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    Color.indigo.opacity(0.2),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Wrap the content with scroll-safe cosmic animations
            ScrollSafeCosmicView {
                // Main content
                ScrollView {
                VStack(spacing: 40) {
                    // Mystical title
                    Text("✦ THE REALM NUMBER ✦")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.white, .purple.opacity(0.8), .blue.opacity(0.6)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.top, 50)

                    // VFI Consciousness HUD Widget - Unified consciousness indicator
                    VFIWidget()
                        .environmentObject(CosmicHUDManager.shared)

                    // Enhanced glowing realm number display (FIXED - removed outer circle)
                    mysticalRealmNumberDisplay

                    // Sacred realm description
                    mysticalRealmDescription

                    // REPLACED: Ruling Number Chart (replaces cosmic factors)
                    RulingNumberChartView(realmNumber: realmNumberManager.currentRealmNumber)
                        .environmentObject(focusNumberManager)
                        .environmentObject(realmNumberManager)

                    // Claude: Phase 10B - Cosmic Snapshot Integration
                    CosmicSnapshotView(realmNumber: realmNumberManager.currentRealmNumber)

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        }
        .onAppear {
            startMysticalAnimations()
            startMandalaRotation()
            // Claude: Phase 8 - Initialize current mandala asset for SVG path tracing
            updateCurrentMandalaAsset()
        }
        .onChange(of: realmNumberManager.currentRealmNumber) { oldValue, newValue in
            // Claude: Phase 8 - Update mandala asset when realm number changes
            updateCurrentMandalaAsset()
        }
        .onReceive(assetSyncTimer) { _ in
            // Claude: Phase 8 - Sync neon tracer with mandala asset rotation every 30 seconds
            updateCurrentMandalaAsset()
        }
    }

    // MARK: - Mystical Realm Number Display (FIXED)

    private var mysticalRealmNumberDisplay: some View {
        NavigationLink(destination: RealmNumberDetailView(initialSelectedNumber: realmNumberManager.currentRealmNumber)) {
            ZStack {
                // REMOVED: Outer cosmic ring that conflicted with sacred geometry
                // Using only the sacred geometry background now

                // Enhanced Dynamic Sacred Geometry Background with Rotation
                DynamicAssetMandalaView(
                    number: realmNumberManager.currentRealmNumber,
                    size: 350
                )
                .rotationEffect(.degrees(rotationAngle))

                // PHASE 8I REVOLUTIONARY: Number-specific geometric pattern neon tracer
                NeonTracerView(
                    realmNumber: realmNumberManager.currentRealmNumber,
                    bpm: Double(healthKitManager.currentHeartRate),
                    color: getRealmNumberColor(),
                    size: CGSize(width: 320, height: 320)
                )
                .frame(width: 320, height: 320)

                // Large Realm Number - FONT SIZE MATCHED TO HOME TAB
                Text("\(realmNumberManager.currentRealmNumber)")
                    .font(.system(size: 140, weight: .bold, design: .rounded)) // Matches HomeView exactly
                    .foregroundColor(getRealmNumberColor())
                    // Multiple glow layers for rich effect (matches HomeView)
                    .shadow(color: getRealmNumberColor().opacity(0.8), radius: 20)
                    .shadow(color: getRealmNumberColor().opacity(0.6), radius: 15)
                    .shadow(color: getRealmNumberColor().opacity(0.4), radius: 10)
                    .shadow(color: .white.opacity(0.3), radius: 5)
                    .shadow(color: .black.opacity(0.8), radius: 8, x: 3, y: 3)

                // Subtle indication that this is tappable
                VStack {
                    Spacer()
                    Text("✦ Tap to Explore Sacred Meanings ✦")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .shadow(color: getRealmNumberColor().opacity(0.5), radius: 3)
                        .padding(.top, 200)
                }
            }
            .frame(width: 350, height: 350) // Consistent with HomeView
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }

    // MARK: - Sacred Realm Description

    private var mysticalRealmDescription: some View {
        VStack(spacing: 16) {
            Text(getRealmDescription())
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, getRealmNumberColor().opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
                .shadow(color: getRealmNumberColor().opacity(0.4), radius: 8, x: 0, y: 2)

            Text(getRealmMysticDescription())
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            // Cosmic exploration invitation
            Text("✦ Tap the Realm Number above to explore its sacred meanings ✦")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(getRealmNumberColor().opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .shadow(color: getRealmNumberColor().opacity(0.3), radius: 3)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.6),
                                    getRealmNumberColor().opacity(0.2),
                                    Color.black.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getRealmNumberColor().opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: getRealmNumberColor().opacity(0.3), radius: 15, x: 0, y: 8)
    }

    // MARK: - Helper Methods

    private func startMysticalAnimations() {
        // Set static glow intensity
        glowIntensity = 0.8
    }

    private func startMandalaRotation() {
        // Prevent multiple rotation animations from starting
        guard !isRotationStarted else { return }
        isRotationStarted = true

        print("🔄 Starting mandala rotation (60-second cycle)")

        // Reset to 0 and start continuous rotation
        rotationAngle = 0

        // Start continuous rotation after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                self.rotationAngle = 360
            }
        }
    }

    // Claude: Phase 8 - Update current mandala asset for authentic SVG path tracing
    private func updateCurrentMandalaAsset() {
        // Get the current asset that DynamicAssetMandalaView would select
        currentMandalaAsset = SacredGeometryAsset.selectSmartAsset(for: realmNumberManager.currentRealmNumber)
        print("🌟 PHASE 8: Updated mandala asset to \(currentMandalaAsset.displayName) for realm number \(realmNumberManager.currentRealmNumber)")
    }

    private func getRealmNumberColor() -> Color {
        switch realmNumberManager.currentRealmNumber {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return .gold
        case 9: return .white
        default: return .white
        }
    }

    /**
     * Returns a descriptive name for the current realm number.
     */
    private func getRealmDescription() -> String {
        let descriptions = [
            "Realm of Creation",
            "Realm of Partnership",
            "Realm of Expression",
            "Realm of Foundation",
            "Realm of Freedom",
            "Realm of Harmony",
            "Realm of Spirituality",
            "Realm of Abundance",
            "Realm of Completion"
        ]

        let index = max(0, min(realmNumberManager.currentRealmNumber - 1, descriptions.count - 1))
        return descriptions[index]
    }

    /**
     * Returns mystical description for each realm number.
     */
    private func getRealmMysticDescription() -> String {
        let descriptions = [
            "The genesis energy flows through all things, sparking new beginnings and infinite possibilities.",
            "Divine duality creates balance, where souls unite and cosmic forces harmonize in perfect equilibrium.",
            "Creative expression illuminates the universe, where joy and inspiration manifest through sacred communication.",
            "The foundation of reality anchors all existence, providing stability and structure for cosmic manifestation.",
            "Liberation energy courses through dimensions, breaking barriers and expanding consciousness beyond limits.",
            "Love's resonance creates perfect harmony, nurturing souls and healing the cosmic fabric of existence.",
            "Mystical wisdom opens the gateway to higher realms, where spiritual truth and cosmic knowledge converge.",
            "Infinite abundance flows from the cosmic source, manifesting prosperity and material-spiritual alignment.",
            "Universal completion encompasses all cycles, where wisdom culminates and new cosmic chapters begin."
        ]

        let index = max(0, min(realmNumberManager.currentRealmNumber - 1, descriptions.count - 1))
        return descriptions[index]
    }

    // MARK: - Sacred Path Creation for NeonTracerView

    private func createSacredPath(for number: Int) -> CGPath {
        let path = CGMutablePath()
        let centerX: CGFloat = 160
        let centerY: CGFloat = 160

        switch number {
        case 1: // Simple circle for unity
            let radius: CGFloat = 120
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))

        case 2: // Star of David pattern
            let outerRadius: CGFloat = 140
            let innerRadius: CGFloat = 70

            // Create a 12-pointed star path that traces the outer edges of the mandala
            for i in 0..<12 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 12.0 - .pi / 2
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 3: // Triangle
            let radius: CGFloat = 130
            for i in 0..<3 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 3.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 4: // Square
            let radius: CGFloat = 120
            for i in 0..<4 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 4.0 - .pi / 4
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 5: // Pentagon
            let radius: CGFloat = 125
            for i in 0..<5 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 5.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 6: // Hexagon/Star of David
            let radius: CGFloat = 130
            for i in 0..<6 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 6.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 7: // Heptagon
            let radius: CGFloat = 125
            for i in 0..<7 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 7.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 8: // Octagon
            let radius: CGFloat = 130
            for i in 0..<8 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 8.0 - .pi / 4
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()

        case 9: // Circle for completion
            let radius: CGFloat = 135
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))

        default: // Default circle
            let radius: CGFloat = 120
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))
        }

        return path
    }
}

// MARK: - Static Sacred Geometry View (NO ANIMATIONS) - DEPRECATED
// This is kept for compatibility but should be replaced with DynamicAssetMandalaView

struct StaticSacredGeometryView: View {
    let number: Int

    var body: some View {
        ZStack {
            // Background energy field (static)
            RadialGradient(
                gradient: Gradient(colors: [
                    getSacredColor(for: number).opacity(0.4),
                    getSacredColor(for: number).opacity(0.2),
                    Color.clear
                ]),
                center: .center,
                startRadius: 30,
                endRadius: 200
            )

            // Static Sacred Geometry Pattern (NO ROTATION)
            getSacredGeometryShape(for: number)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            getSacredColor(for: number),
                            getSacredColor(for: number).opacity(0.8),
                            Color.white.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: getSacredColor(for: number).opacity(0.8), radius: 15)
                .shadow(color: getSacredColor(for: number).opacity(0.4), radius: 30)
                // NO ROTATION ANIMATION - completely static
        }
    }

    // MARK: - Sacred Geometry Shapes (Static)

    private func getSacredGeometryShape(for number: Int) -> some Shape {
        switch number {
        case 1:
            return AnyShape(UnityCircleShape())
        case 2:
            return AnyShape(VesicaPiscisShape())
        case 3:
            return AnyShape(TriangleShape())
        case 4:
            return AnyShape(SquareShape())
        case 5:
            return AnyShape(PentagramShape())
        case 6:
            return AnyShape(MerkabaShape())
        case 7:
            return AnyShape(SeedOfLifeShape())
        case 8:
            return AnyShape(OctagonShape())
        case 9:
            return AnyShape(EnneagramShape())
        default:
            return AnyShape(UnityCircleShape())
        }
    }

    // MARK: - Sacred Color System

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

#Preview {
    RealmNumberView()
        .environmentObject(RealmNumberManager())
        .environmentObject(FocusNumberManager.shared)
}
