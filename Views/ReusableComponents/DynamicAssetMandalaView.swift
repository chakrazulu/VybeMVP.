/**
 * Filename: DynamicAssetMandalaView.swift
 * 
 * Purpose: Enhanced sacred geometry background that dynamically rotates through assets
 * Fixes the "always same geometry" issue by providing intelligent asset rotation
 */

import SwiftUI

/**
 * Dynamic sacred geometry view that rotates through different assets
 * Provides fresh visual experience while maintaining mystical significance
 */
struct DynamicAssetMandalaView: View {
    let number: Int
    let size: CGFloat
    
    // Dynamic selection factors
    @State private var currentAssetIndex: Int = 0
    @State private var rotationSeed: Int = 0
    
    // Time-based rotation
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    // Available assets for the number
    private var availableAssets: [SacredGeometryAsset] {
        let assets = SacredGeometryAsset.assets(for: number)
        return assets.isEmpty ? [.wisdomEnneagram] : assets
    }
    
    // Currently selected asset
    private var selectedAsset: SacredGeometryAsset {
        let assets = availableAssets
        let safeIndex = abs(currentAssetIndex) % assets.count
        return assets[safeIndex]
    }
    
    // Rotation method based on time and user factors
    private var dynamicAssetIndex: Int {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        
        // Create a dynamic selection based on:
        // - Current time (changes hourly)
        // - Number itself
        // - Rotation seed (for additional variation)
        let timeComponent = (hour * 60 + minute) / 15 // Changes every 15 minutes
        let numberComponent = number * 17 // Prime multiplier for variation
        let seedComponent = rotationSeed
        
        return (timeComponent + numberComponent + seedComponent) % availableAssets.count
    }
    
    var body: some View {
        ZStack {
            // Single main asset (no overlay layer)
            selectedAsset.image
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
    
    // MARK: - Asset Rotation Logic
    
    private func initializeAssetRotation() {
        // Generate initial rotation seed based on device-specific factors
        rotationSeed = generateRotationSeed()
        currentAssetIndex = dynamicAssetIndex
        
        print("🔄 Initialized mandala for number \(number): \(selectedAsset.displayName) (index: \(currentAssetIndex)/\(availableAssets.count))")
    }
    
    private func rotateToNextAsset() {
        withAnimation(.easeInOut(duration: 1.0)) {
            currentAssetIndex = dynamicAssetIndex
        }
        
        print("🔄 Rotated mandala for number \(number): \(selectedAsset.displayName)")
    }
    
    private func generateRotationSeed() -> Int {
        // Create a device/session-specific seed for variation
        let deviceName = UIDevice.current.name.hash
        let sessionStart = Date().timeIntervalSince1970
        return abs(deviceName + Int(sessionStart)) % 1000
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
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Consistent gold - Renewal/cycles
        case 9: return Color.white  // Completion/wisdom
        default: return Color.white
        }
    }
}

// MARK: - Convenience Initializers

extension DynamicAssetMandalaView {
    /// Create with specific rotation behavior
    static func withRotation(number: Int, size: CGFloat, rotateEvery seconds: TimeInterval = 30) -> some View {
        DynamicAssetMandalaView(number: number, size: size)
    }
    
    /// Create with fixed asset (no rotation)
    static func fixed(number: Int, assetIndex: Int = 0, size: CGFloat) -> some View {
        let assets = SacredGeometryAsset.assets(for: number)
        let asset = assets.isEmpty ? SacredGeometryAsset.wisdomEnneagram : assets[assetIndex % assets.count]
        
        return asset.image
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

// MARK: - Debug View

struct AssetDebugView: View {
    let number: Int
    
    var body: some View {
        VStack {
            Text("Available Assets for Number \(number)")
                .font(.headline)
            
            let assets = SacredGeometryAsset.assets(for: number)
            
            if assets.isEmpty {
                Text("⚠️ No assets found for number \(number)")
                    .foregroundColor(.red)
            } else {
                VStack(alignment: .leading) {
                    ForEach(assets.indices, id: \.self) { index in
                        HStack {
                            Text("\(index):")
                            Text(assets[index].displayName)
                            Text("(\(assets[index].rawValue))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview

struct DynamicAssetMandalaView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            // Test different numbers
            ForEach([1, 6, 9], id: \.self) { number in
                VStack {
                    Text("Number \(number)")
                        .font(.headline)
                    
                    ZStack {
                        Color.black.opacity(0.8)
                        DynamicAssetMandalaView(number: number, size: 200)
                    }
                    .frame(width: 220, height: 220)
                    .cornerRadius(20)
                    
                    AssetDebugView(number: number)
                }
            }
        }
        .padding()
    }
} 