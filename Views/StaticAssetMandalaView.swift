/**
 * Filename: StaticAssetMandalaView.swift
 * 
 * Purpose: Simple static sacred geometry background using assets (no animations)
 * Solves the "unity_merkaba not found" error and provides stable backgrounds
 */

import SwiftUI

/**
 * Simple static view that displays sacred geometry assets without animations
 */
struct StaticAssetMandalaView: View {
    let number: Int
    let size: CGFloat
    
    // Stable asset selection (no randomization)
    private var selectedAsset: SacredGeometryAsset {
        let assets = SacredGeometryAsset.assets(for: number)
        guard !assets.isEmpty else { return .wisdomEnneagram }
        
        // Always use first asset for stability
        return assets[0]
    }
    
    var body: some View {
        selectedAsset.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(getSacredColor(for: number))
            .opacity(0.3)
            .frame(width: size, height: size)
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

// MARK: - Preview

struct StaticAssetMandalaView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            StaticAssetMandalaView(number: 6, size: 300)
        }
    }
} 