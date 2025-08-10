/**
 * Filename: MandalaBackgroundView.swift
 *
 * Purpose: Displays dynamic sacred geometry backgrounds using the new SacredGeometryAsset system
 * with aesthetic-first design and mystical significance hidden beneath beautiful visuals.
 *
 * Design pattern: SwiftUI view component with sacred geometry integration
 * Dependencies: SwiftUI, SacredGeometryAssets
 * EDIT TEST: Tool is working! ✅
 */

import SwiftUI

/**
 * Enhanced view that displays dynamic sacred geometry mandalas based on focus and realm numbers.
 * Implements ChatGPT's aesthetic-first vision with layered compositions and subtle animations.
 */
struct MandalaBackgroundView: View {
    let number: Int
    let size: CGFloat

    // Realm number for advanced calculations (optional)
    var realmNumber: Int = 0

    // Animation and variation state
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: Double = 1.0
    @State private var sessionSeed: Int = Int.random(in: 1...1000)

    // Sacred geometry selection
    private var selectedAsset: SacredGeometryAsset {
        if realmNumber > 0 {
            // Use advanced calculation when realm number available
            return SacredGeometryAsset.advancedAssetSelection(
                focusNumber: number,
                realmNumber: realmNumber,
                userIntention: getCurrentIntention()
            )
        } else {
            // Simple focus number selection
            let assets = SacredGeometryAsset.assets(for: number)
            guard !assets.isEmpty else { return .wisdomEnneagram }

            // Session-based variation (same mandala for the session)
            let index = (sessionSeed + number) % assets.count
            return assets[index]
        }
    }

    // Complementary asset for layering
    private var layerAsset: SacredGeometryAsset? {
        let assets = SacredGeometryAsset.assets(for: number)
        guard assets.count > 1 else { return nil }

        // Select different asset from same number group for layering
        let index = (sessionSeed + number + 1) % assets.count
        return assets[index]
    }

    var body: some View {
        // Simple single sacred geometry image
        selectedAsset.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(getSacredColor(for: selectedAsset.numerologicalValue))
            .opacity(0.3)
            .frame(width: size, height: size)
            .onAppear {
                // No need to call startSubtleAnimations() as per the new code
            }
            .onChange(of: number) { oldValue, newValue in
                // Regenerate session seed for new number
                sessionSeed = Int.random(in: 1...1000)
            }
    }

    // MARK: - Animation and Effects

    private func startSubtleAnimations() {
        // Gentle rotation based on sacred timing
        let timing = selectedAsset.sacredTiming
        let rotationSpeed = timing.bestHours.first ?? 12

        withAnimation(.linear(duration: Double(rotationSpeed * 10)).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }

        // Subtle breathing pulse
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.05
        }
    }

    // MARK: - Sacred Color System

    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 0: return Color.purple // Void/infinite potential
        case 1: return Color.red    // Unity/divine spark
        case 2: return Color.orange // Duality/polarity
        case 3: return Color.yellow // Trinity/creativity
        case 4: return Color.green  // Foundation/manifestation
        case 5: return Color.blue   // Will/quintessence
        case 6: return Color.indigo // Harmony/love
        case 7: return Color.purple // Mystery/mastery
        case 8: return Color.pink   // Renewal/cycles
        case 9: return Color.white  // Completion/wisdom
        default: return Color.white
        }
    }

    // MARK: - Contextual Helpers

    private func getCurrentIntention() -> SacredGeometryAsset.SacredIntention {
        // Could be enhanced to read user's current intention from UserDefaults or state
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5...8: return .manifestation    // Morning - creative energy
        case 9...11: return .wisdom          // Late morning - learning
        case 12...14: return .balance        // Midday - equilibrium
        case 15...17: return .love           // Afternoon - connection
        case 18...20: return .healing        // Evening - restoration
        case 21...23: return .transformation // Night - inner work
        default: return .protection          // Deep night - protection
        }
    }
}

// MARK: - Enhanced Layer View

/**
 * Individual sacred geometry layer with advanced styling.
 */
struct SacredGeometryLayerView: View {
    let asset: SacredGeometryAsset
    let color: Color
    let opacity: Double
    let size: CGFloat
    let blendMode: BlendMode

    var body: some View {
        asset.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(color)
            .opacity(opacity)
            .frame(width: size, height: size)
            .blendMode(blendMode)
    }
}

// MARK: - Convenience Initializers

extension MandalaBackgroundView {
    /// Initialize with focus and realm numbers for advanced calculation
    init(focusNumber: Int, realmNumber: Int, size: CGFloat) {
        self.number = focusNumber
        self.realmNumber = realmNumber
        self.size = size
    }

    /// Initialize with just focus number for simple calculation
    init(number: Int, size: CGFloat) {
        self.number = number
        self.realmNumber = 0
        self.size = size
    }
}

// MARK: - Preview

struct MandalaBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            VStack(spacing: 30) {
                // Simple focus number
                MandalaBackgroundView(number: 6, size: 300)

                // Advanced with focus + realm
                MandalaBackgroundView(focusNumber: 3, realmNumber: 7, size: 200)
            }
        }
    }
}
