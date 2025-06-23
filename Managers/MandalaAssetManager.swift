/**
 * Filename: MandalaAssetManager.swift
 * 
 * Purpose: Manages SVG mandala assets and intelligently maps them to numbers 1-9
 * based on sacred geometry analysis, numerological correspondences, and esoteric frameworks.
 * 
 * Design pattern: Singleton manager with asset analysis and categorization
 * Dependencies: SwiftUI, Foundation
 */

import SwiftUI
import Foundation

/**
 * Manager responsible for analyzing and categorizing SVG mandala assets
 * into their appropriate numerological buckets (1-9).
 */
class MandalaAssetManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = MandalaAssetManager()
    
    // MARK: - Properties
    
    /// Buckets of mandala assets organized by their true number (1-9)
    @Published var mandalaBuckets: [Int: [MandalaAsset]] = [:]
    
    /// Currently loaded mandala configurations
    private var loadedMandalas: [MandalaAsset] = []
    
    // MARK: - Initialization
    
    private init() {
        // Initialize empty buckets for numbers 1-9
        for number in 1...9 {
            mandalaBuckets[number] = []
        }
    }
    
    // MARK: - Asset Loading and Analysis
    
    /**
     * Loads all SVG mandala assets from the bundle and categorizes them
     * based on their sacred geometry properties.
     */
    func loadAndCategorizeMandalaAssets() {
        print("🔮 MandalaAssetManager: Loading mandala assets...")
        
        // Get all SVG files from the bundle
        guard let bundle = Bundle.main.resourcePath else {
            print("❌ Could not access bundle resource path")
            return
        }
        
        do {
            let fileManager = FileManager.default
            let resourceContents = try fileManager.contentsOfDirectory(atPath: bundle)
            
            // Filter for SVG files
            let svgFiles = resourceContents.filter { $0.hasSuffix(".svg") }
            
            print("📁 Found \(svgFiles.count) SVG files")
            
            // For now, create test assets for each SVG and assign to ALL numbers for testing
            for svgFile in svgFiles {
                // Clean up the asset name: remove .svg and replace spaces with underscores for Asset Catalog
                let assetName = svgFile
                    .replacingOccurrences(of: ".svg", with: "")
                    .replacingOccurrences(of: " ", with: "_")
                
                // Assign to ALL numbers 1-9 for testing purposes
                for testNumber in 1...9 {
                    let mandala = MandalaAsset(
                        assetName: assetName,
                        trueNumber: testNumber,
                        geometryType: .complex,
                        thickness: .thick,
                        symmetryAxes: 8,
                        hasNestedPatterns: true
                    )
                    
                    // Add to appropriate bucket
                    mandalaBuckets[testNumber]?.append(mandala)
                }
                
                print("✨ Added \(assetName) as test mandala for ALL numbers 1-9")
            }
            
            // Log final distribution
            for number in 1...9 {
                let count = mandalaBuckets[number]?.count ?? 0
                print("🔢 Number \(number): \(count) mandalas")
            }
            
        } catch {
            print("❌ Error loading mandala assets: \(error)")
        }
    }
    
    /**
     * Analyzes a mandala's geometry and returns its true numerological value (1-9).
     * This is where the magic happens - interpreting sacred geometry.
     */
    private func analyzeMandalaGeometry(assetName: String) -> Int {
        // TODO: Implement sophisticated geometry analysis
        // For now, return a placeholder
        
        // Analysis will consider:
        // - Fold count and symmetry axes
        // - Inner patterns and nested structures
        // - Sacred geometry correlations (sphere=1, vesica piscis=2, etc.)
        // - Planetary/elemental correspondences
        // - Cymatics and resonant frequencies
        
        return 1 // Placeholder
    }
    
    /**
     * Returns a dynamic selection of mandalas for a given number.
     * Can return multiple layers (thick, thin, accent) for compositing.
     */
    func getMandalasForNumber(_ number: Int, count: Int = 3) -> [MandalaAsset] {
        guard let bucket = mandalaBuckets[number], !bucket.isEmpty else {
            // Return placeholder if no mandalas loaded yet
            return []
        }
        
        // Dynamic selection based on:
        // - Current time of day
        // - User's heart rate (BPM)
        // - Lunar phase
        // - Random variation for freshness
        
        let selectedMandalas = bucket.shuffled().prefix(count)
        return Array(selectedMandalas)
    }
    
    /**
     * Returns mandalas specifically selected for current conditions.
     */
    func getDynamicMandalasForNumber(_ number: Int, bpm: Double, timeOfDay: Date) -> MandalaComposition {
        print("🔍 getDynamicMandalasForNumber called for number \(number)")
        let mandalas = getMandalasForNumber(number)
        print("🔍 Found \(mandalas.count) mandalas for number \(number)")
        
        if let first = mandalas.first {
            print("🔍 First mandala: \(first.assetName)")
        }
        
        return MandalaComposition(
            baseLayer: mandalas.first,
            middleLayer: mandalas.count > 1 ? mandalas[1] : nil,
            accentLayer: mandalas.count > 2 ? mandalas[2] : nil,
            animationSpeed: calculateAnimationSpeed(bpm: bpm),
            blendMode: selectBlendMode(for: number, timeOfDay: timeOfDay)
        )
    }
    
    // MARK: - Helper Methods
    
    private func calculateAnimationSpeed(bpm: Double) -> Double {
        // Map BPM to animation speed
        // 60 BPM = 1.0 speed, scales proportionally
        return bpm / 60.0
    }
    
    private func selectBlendMode(for number: Int, timeOfDay: Date) -> BlendMode {
        // Select blend mode based on number and time
        let hour = Calendar.current.component(.hour, from: timeOfDay)
        
        if hour >= 6 && hour < 12 {
            // Morning - lighter blend modes
            return [.plusLighter, .screen, .lighten].randomElement()!
        } else if hour >= 12 && hour < 18 {
            // Afternoon - balanced blend modes
            return [.multiply, .overlay, .softLight].randomElement()!
        } else {
            // Evening/Night - deeper blend modes
            return [.plusDarker, .colorBurn, .multiply].randomElement()!
        }
    }
}

// MARK: - Data Models

/**
 * Represents a single mandala asset with its metadata.
 */
struct MandalaAsset: Identifiable {
    let id = UUID()
    let assetName: String
    let trueNumber: Int
    let geometryType: GeometryType
    let thickness: Thickness
    let symmetryAxes: Int
    let hasNestedPatterns: Bool
    
    enum GeometryType {
        case circle, vesicaPiscis, triangle, square, pentagon
        case hexagon, heptagon, octagon, enneagram
        case complex, hybrid
    }
    
    enum Thickness {
        case thin, medium, thick
    }
}

/**
 * Represents a composed mandala configuration for display.
 */
struct MandalaComposition {
    let baseLayer: MandalaAsset?
    let middleLayer: MandalaAsset?
    let accentLayer: MandalaAsset?
    let animationSpeed: Double
    let blendMode: BlendMode
}

/**
 * Sacred geometry mapping reference for analysis.
 */
struct SacredGeometryReference {
    static let numberToGeometry: [Int: String] = [
        1: "Unity Circle/Sphere - The Monad",
        2: "Vesica Piscis - Sacred Duality",
        3: "Triangle/Tetrahedron - Trinity",
        4: "Square/Cube - Foundation",
        5: "Pentagon/Pentagram - Human Microcosm",
        6: "Hexagram/Merkaba - As Above So Below",
        7: "Seed of Life - Mystery & Spirit",
        8: "Octagon/Infinity - Renewal & Bridge",
        9: "Enneagram - Completion & Universal Wisdom"
    ]
    
    static let planetaryCorrespondences: [Int: String] = [
        1: "Sun - Solar consciousness",
        2: "Moon - Lunar duality",
        3: "Jupiter - Expansion",
        4: "Earth/Saturn - Structure",
        5: "Mercury - Communication",
        6: "Venus - Love & harmony",
        7: "Neptune - Mysticism",
        8: "Saturn/Uranus - Transformation",
        9: "Mars/Pluto - Completion"
    ]
} 