import SwiftUI
import SwiftAA

// MARK: - Cosmic HUD Test View
/// Claude: Test view to verify that the HUD is using real planetary data instead of fallback
/// This can be added to Settings temporarily to test the connection

struct CosmicHUDTestView: View {
    @StateObject private var hudManager = CosmicHUDManager.shared
    @State private var testResults: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🌌 Cosmic HUD Live Data Test")
                .font(.headline)
                .padding(.bottom)
            
            Button("Test Live Planetary Aspects") {
                testLivePlanetaryData()
            }
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("Testing cosmic calculations...")
                    .padding()
            }
            
            if !testResults.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🔍 Test Results:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(Array(testResults.enumerated()), id: \.offset) { _, result in
                        Text(result)
                            .font(.caption)
                            .foregroundColor(result.contains("✅") ? .green : 
                                           result.contains("⚠️") ? .orange : .primary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("HUD Test")
    }
    
    private func testLivePlanetaryData() {
        isLoading = true
        testResults = []
        
        Task {
            await performCosmicDataTest()
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func performCosmicDataTest() async {
        var results: [String] = []
        
        // Test 1: Check if CosmicData is calculating real positions
        results.append("🔄 Testing CosmicData.fromLocalCalculations()...")
        let cosmicData = CosmicData.fromLocalCalculations()
        
        if !cosmicData.planetaryPositions.isEmpty {
            results.append("✅ Got \(cosmicData.planetaryPositions.count) planetary positions")
            
            // Show actual planetary positions
            for (planet, position) in cosmicData.planetaryPositions.sorted(by: { $0.key < $1.key }) {
                let degrees = Int(position)
                let minutes = Int((position - Double(degrees)) * 60)
                results.append("   \(planet): \(degrees)° \(minutes)'")
            }
        } else {
            results.append("❌ No planetary positions calculated!")
        }
        
        // Test 2: Check if aspects are being calculated
        results.append("🔄 Testing planetary aspects...")
        let aspects = cosmicData.getMajorAspects()
        
        if !aspects.isEmpty {
            results.append("✅ Got \(aspects.count) major aspects")
            
            // Show actual aspects
            for aspect in aspects.prefix(3) {
                let orbStr = String(format: "%.1f", aspect.orb)
                results.append("   \(aspect.planet1) \(aspect.aspectType.emoji) \(aspect.planet2) (orb: \(orbStr)°)")
            }
        } else {
            results.append("⚠️ No aspects calculated - may be a quiet cosmic period")
        }
        
        // Test 3: Test HUD Manager integration
        results.append("🔄 Testing HUD Manager...")
        await hudManager.refreshHUDData()
        
        if let hudData = hudManager.currentHUDData {
            results.append("✅ HUD data generated successfully")
            results.append("   Ruler Number: \(hudData.rulerNumber)")
            results.append("   Element: \(hudData.element.name)")
            results.append("   Aspects: \(hudData.allAspects.count)")
            
            if let dominant = hudData.dominantAspect {
                let orbStr = String(format: "%.1f", dominant.orb)
                results.append("   Dominant: \(dominant.planet1.symbol) \(dominant.aspect.symbol) \(dominant.planet2.symbol) (\(orbStr)°)")
            }
        } else {
            results.append("❌ HUD Manager failed to generate data")
        }
        
        // Test 4: Check if data is live (different from yesterday)
        results.append("🔄 Testing live vs static data...")
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let yesterdayData = CosmicData.fromLocalCalculations(for: yesterday)
        
        let todaySunPos = cosmicData.planetaryPositions["Sun"] ?? 0
        let yesterdaySunPos = yesterdayData.planetaryPositions["Sun"] ?? 0
        let sunMovement = abs(todaySunPos - yesterdaySunPos)
        
        if sunMovement > 0.5 { // Sun moves ~1° per day
            results.append("✅ Data is LIVE - Sun moved \(String(format: "%.1f", sunMovement))° since yesterday")
        } else if sunMovement > 0.1 {
            results.append("✅ Data appears live - Sun moved \(String(format: "%.2f", sunMovement))° since yesterday")
        } else {
            results.append("⚠️ Data may be static - minimal Sun movement detected")
        }
        
        await MainActor.run {
            self.testResults = results
        }
    }
}

// MARK: - Preview
#if DEBUG
struct CosmicHUDTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CosmicHUDTestView()
        }
    }
}
#endif