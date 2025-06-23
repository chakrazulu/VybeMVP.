import SwiftUI

/// Advanced Sacred Geometry Test - Shows all mystical features
struct TestAdvancedSacredGeometry: View {
    @State private var focusNumber: Int = 247
    @State private var realmNumber: Int = 139
    @State private var selectedIntention: SacredGeometryAsset.SacredIntention = .balance
    @State private var showMysticalProfile = false
    
    private var selectedAsset: SacredGeometryAsset {
        SacredGeometryAsset.advancedAssetSelection(
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            birthDate: Calendar.current.date(from: DateComponents(year: 1990, month: 5, day: 15)),
            userIntention: selectedIntention
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Text("🔮 Advanced Sacred Geometry")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Deep Mystical Correspondences")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Input Controls
                    VStack(spacing: 16) {
                        HStack {
                            Text("Focus Number:")
                                .fontWeight(.medium)
                            Spacer()
                            TextField("Focus", value: $focusNumber, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        
                        HStack {
                            Text("Realm Number:")
                                .fontWeight(.medium)
                            Spacer()
                            TextField("Realm", value: $realmNumber, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Sacred Intention:")
                                .fontWeight(.medium)
                            
                            Picker("Intention", selection: $selectedIntention) {
                                ForEach(SacredGeometryAsset.SacredIntention.allCases, id: \.self) { intention in
                                    Text(intention.rawValue).tag(intention)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Sacred Geometry Display
                    VStack(spacing: 16) {
                        selectedAsset.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .background(
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                                            center: .center,
                                            startRadius: 50,
                                            endRadius: 150
                                        )
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                            )
                        
                        Text(selectedAsset.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Mystical Correspondences
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        
                        CorrespondenceCard(
                            title: "Numerology",
                            value: "\(selectedAsset.numerologicalValue)",
                            subtitle: "Primary Number",
                            color: .blue
                        )
                        
                        CorrespondenceCard(
                            title: "Chakra",
                            value: selectedAsset.chakra,
                            subtitle: "Energy Center",
                            color: .purple
                        )
                        
                        CorrespondenceCard(
                            title: "Planet",
                            value: selectedAsset.planetaryCorrespondence.traditional,
                            subtitle: "Traditional",
                            color: .orange
                        )
                        
                        CorrespondenceCard(
                            title: "Element",
                            value: selectedAsset.elementalCorrespondence.components(separatedBy: " ").first ?? "",
                            subtitle: "Classical Element",
                            color: .green
                        )
                        
                        CorrespondenceCard(
                            title: "Tarot",
                            value: selectedAsset.tarotCorrespondence.components(separatedBy: " (").first ?? "",
                            subtitle: "Major Arcana",
                            color: .indigo
                        )
                        
                        CorrespondenceCard(
                            title: "Geometry",
                            value: "\(selectedAsset.geometricProperties.sides) sides",
                            subtitle: selectedAsset.geometricProperties.angles,
                            color: .teal
                        )
                    }
                    
                    // Sacred Timing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🕐 Sacred Timing")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Best Hours:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(selectedAsset.sacredTiming.bestHours.map { "\($0):00" }.joined(separator: ", "))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Best Days:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(selectedAsset.sacredTiming.bestDays.joined(separator: ", "))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Planetary Hour:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(selectedAsset.sacredTiming.planetaryHour)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Advanced Features Toggle
                    Button(action: {
                        showMysticalProfile.toggle()
                    }) {
                        HStack {
                            Image(systemName: showMysticalProfile ? "chevron.up" : "chevron.down")
                            Text("Complete Mystical Profile")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if showMysticalProfile {
                        ScrollView {
                            Text(selectedAsset.mysticalProfile)
                                .font(.system(.caption, design: .monospaced))
                                .padding()
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(8)
                        }
                        .frame(maxHeight: 300)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

/// Helper view for correspondence cards
struct CorrespondenceCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    TestAdvancedSacredGeometry()
} 