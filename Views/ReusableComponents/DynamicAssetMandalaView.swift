/**
 * Filename: DynamicAssetMandalaView.swift
 *
 * Purpose: Enhanced sacred geometry background that dynamically rotates through assets
 * PHASE 7: Now uses weighted selection system for spiritual authenticity
 */

import SwiftUI

/**
 * Dynamic sacred geometry view that rotates through different assets
 * PHASE 7: Uses weighted spiritual preference system instead of rigid restrictions
 * Provides fresh visual experience while maintaining mystical significance
 */
struct DynamicAssetMandalaView: View {
    let number: Int
    let size: CGFloat

    // PHASE 7: Enhanced dynamic selection with weighted preferences
    @State private var currentAsset: SacredGeometryAsset = .wisdomEnneagram
    @State private var recentAssets: [SacredGeometryAsset] = []
    @State private var rotationSeed: Int = 0

    // Time-based rotation (keeping user's preferred 30-second timing)
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    // PHASE 7: Weighted assets with spiritual preferences
    private var weightedAssets: [SacredGeometryAsset] {
        return SacredGeometryAsset.weightedAssets(for: number)
    }

    var body: some View {
        ZStack {
            // PHASE 7: Single main asset with weighted spiritual selection
            currentAsset.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(getSacredColor(for: number))
                .opacity(0.35)
                .frame(width: size, height: size)
        }
        .onAppear {
            initializeAssetRotation()
        }
        .onReceive(timer) { _ in
            rotateToNextAsset()
        }
        .onChange(of: number) { oldValue, newValue in
            // Reset when number changes
            initializeAssetRotation()
        }
    }

    // MARK: - PHASE 7: Enhanced Asset Rotation Logic with Weighted Selection

    private func initializeAssetRotation() {
        // Initialize with smart weighted selection
        currentAsset = SacredGeometryAsset.selectSmartAsset(for: number)
        recentAssets = [currentAsset]

        print("🔄 PHASE 7: Initialized mandala for number \(number): \(currentAsset.displayName)")
        print("🔮 Resonance: \(currentAsset.getResonanceReason(for: number))")
    }

    private func rotateToNextAsset() {
        // Claude: PHASE 7C PERFORMANCE - Measure selection time for optimization monitoring
        let startTime = CFAbsoluteTimeGetCurrent()

        withAnimation(.easeInOut(duration: 1.0)) {
            // PHASE 7: Select new asset avoiding recent ones for variety
            currentAsset = SacredGeometryAsset.selectSmartAsset(for: number, excludeRecent: recentAssets)

            // Track recent assets (keep last 5 to avoid immediate repeats)
            recentAssets.append(currentAsset)
            if recentAssets.count > 5 {
                recentAssets.removeFirst()
            }
        }

        let selectionTime = (CFAbsoluteTimeGetCurrent() - startTime) * 1000 // Convert to milliseconds

        print("🔄 PHASE 7: Rotated mandala for number \(number): \(currentAsset.displayName)")
        print("🔮 Resonance: \(currentAsset.getResonanceReason(for: number))")
        print("⚡ PHASE 7C: Asset selection took \(String(format: "%.2f", selectionTime))ms")
    }

    // PHASE 7: Removed old rotation seed logic - now using weighted selection

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
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Consistent gold - Renewal/cycles
        case 9: return Color.white  // Completion/wisdom
        default: return Color.white
        }
    }
}

// MARK: - PHASE 7: Enhanced Convenience Initializers with Weighted Selection

extension DynamicAssetMandalaView {
    /// Create with weighted rotation behavior (PHASE 7 enhanced)
    static func withRotation(number: Int, size: CGFloat, rotateEvery seconds: TimeInterval = 30) -> some View {
        DynamicAssetMandalaView(number: number, size: size)
    }

    /// Create with fixed weighted asset selection (no rotation)
    static func fixed(number: Int, size: CGFloat) -> some View {
        // PHASE 7: Use weighted selection even for "fixed" mode
        let selectedAsset = SacredGeometryAsset.selectSmartAsset(for: number)

        return selectedAsset.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(getSacredColorStatic(for: number))
            .opacity(0.35)
            .frame(width: size, height: size)
    }

    private static func getSacredColorStatic(for number: Int) -> Color {
        switch number {
        case 0: return Color.purple
        case 1: return Color.red
        case 2: return Color.orange
        case 3: return Color.yellow
        case 4: return Color.green
        case 5: return Color.blue
        case 6: return Color.indigo
        case 7: return Color.purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Consistent gold
        case 9: return Color.white
        default: return Color.white
        }
    }
}

// MARK: - PHASE 7: Enhanced Debug View with Weighted System Info

struct AssetDebugView: View {
    let number: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PHASE 7: Weighted Assets for Number \(number)")
                .font(.headline)

            let weightedAssets = SacredGeometryAsset.weightedAssets(for: number)
            let uniqueAssets = Array(Set(weightedAssets)).sorted { $0.displayName < $1.displayName }

            Text("Total Accessible Assets: \(uniqueAssets.count)")
                .font(.subheadline)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(uniqueAssets.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("• \(uniqueAssets[index].displayName)")
                                .font(.caption)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        Text(uniqueAssets[index].getResonanceReason(for: number))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                    }
                }
            }

            // Sample current selection
            Button("Test Selection") {
                let selected = SacredGeometryAsset.selectSmartAsset(for: number)
                print("🔮 Selected: \(selected.displayName) - \(selected.getResonanceReason(for: number))")
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

// MARK: - PHASE 7: Enhanced Preview with Weighted System Demo

struct DynamicAssetMandalaView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            Text("PHASE 7: Weighted Mandala Selection")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            // Test different numbers with new weighted system
            ForEach([3, 6, 9], id: \.self) { number in
                VStack {
                    Text("Number \(number) - Enhanced Access")
                        .font(.headline)

                    ZStack {
                        Color.black.opacity(0.8)
                        DynamicAssetMandalaView(number: number, size: 200)
                    }
                    .frame(width: 220, height: 220)
                    .cornerRadius(20)

                    AssetDebugView(number: number)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}
