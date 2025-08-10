/**
 * Filename: StaticAssetMandalaView.swift
 *
 * Purpose: Simple static sacred geometry background using assets with optional rotation
 * PHASE 7: Now uses weighted selection system for spiritual authenticity
 */

import SwiftUI

/**
 * Simple static view that displays sacred geometry assets with optional slow rotation
 * PHASE 7: Uses weighted spiritual preference system instead of rigid first-asset selection
 */
struct StaticAssetMandalaView: View {
    let number: Int
    let size: CGFloat
    let enableRotation: Bool

    // Animation state
    @State private var rotationAngle: Double = 0

    // PHASE 7: Weighted asset selection with session stability
    @State private var selectedAsset: SacredGeometryAsset = .wisdomEnneagram

    // Initialize asset on appear to maintain session stability while using weighted selection
    private func initializeAsset() {
        selectedAsset = SacredGeometryAsset.selectSmartAsset(for: number)
    }

    var body: some View {
        selectedAsset.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(getSacredColor(for: number))
            .opacity(0.3)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                // PHASE 7: Initialize with weighted selection
                initializeAsset()

                if enableRotation {
                    startSlowRotation()
                }

                print("🎯 PHASE 7: StaticAssetMandalaView initialized for number \(number): \(selectedAsset.displayName)")
                print("🔮 Resonance: \(selectedAsset.getResonanceReason(for: number))")
            }
    }

    // MARK: - Animation Methods

    private func startSlowRotation() {
        // Slow clockwise rotation - 60 seconds per full rotation for mystical effect
        withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
            rotationAngle = 360
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
}

// MARK: - Convenience Initializers

extension StaticAssetMandalaView {
    /// Initialize with rotation enabled by default
    init(number: Int, size: CGFloat) {
        self.number = number
        self.size = size
        self.enableRotation = true
    }
}

// MARK: - PHASE 7: Enhanced Preview with Weighted Selection

struct StaticAssetMandalaView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("PHASE 7: Static Mandala with Weighted Selection")
                .font(.headline)
                .foregroundColor(.white)

            ZStack {
                Color.black
                StaticAssetMandalaView(number: 6, size: 300)
            }
            .frame(width: 320, height: 320)
            .cornerRadius(20)

            Text("Now uses weighted spiritual preferences")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black)
    }
}
