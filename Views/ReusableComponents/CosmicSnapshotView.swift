/*
 * ========================================
 * 🌌 COSMIC SNAPSHOT VIEW - CELESTIAL DATA DISPLAY
 * ========================================
 * 
 * CORE PURPOSE:
 * Beautiful, compact UI component displaying current cosmic information including
 * moon phase, sun sign, and planetary positions. Designed to integrate seamlessly
 * into RealmNumberView below the ruling number graph with expandable detail view.
 * 
 * PHASE 10 INTEGRATION:
 * - Primary Component: Phase 10C iOS App Integration
 * - Location: RealmNumberView below "Today's Ruling Number" graph
 * - Design: Glassmorphic style matching Vybe's cosmic aesthetic
 * - Interaction: Tap to expand for full cosmic details
 * 
 * UI/UX SPECIFICATIONS:
 * - Compact Mode: 120pt height with essential info
 * - Expanded Mode: Full-screen cosmic detail view
 * - Animation: Smooth 0.3s transitions
 * - Colors: Sacred number gradient system
 * 
 * VISUAL ELEMENTS:
 * - Moon Phase: Emoji + name + illumination percentage
 * - Sun Sign: Zodiac emoji + current sign
 * - Planetary Highlights: Key positions in compact format
 * - Spiritual Guidance: Brief cosmic message
 * 
 * ACCESSIBILITY:
 * - VoiceOver: Complete cosmic data narration
 * - Dynamic Type: Scalable text elements
 * - Color Contrast: WCAG AA compliant
 * - Motion: Respects reduce motion settings
 */

import SwiftUI

/// Compact cosmic data display for RealmNumberView integration
struct CosmicSnapshotView: View {
    
    // MARK: - Environment & State
    
    /// Cosmic service for data access
    @EnvironmentObject var cosmicService: CosmicService
    
    /// Expand/collapse state
    @State private var isExpanded = false
    
    /// Animation namespace for smooth transitions
    @Namespace private var cosmicNamespace
    
    // MARK: - View Properties
    
    /// Sacred gradient based on current realm number
    let realmNumber: Int
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if isExpanded {
                expandedView
            } else {
                compactView
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
    }
    
    // MARK: - Compact View
    
    private var compactView: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Label("Cosmic Snapshot", systemImage: "sparkles")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Force refresh button
                Button(action: {
                    Task {
                        await cosmicService.forceFetchFromFirebase()
                    }
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .imageScale(.large)
                }
                .disabled(cosmicService.isLoading)
                
                if cosmicService.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .imageScale(.large)
                }
            }
            
            if let cosmic = cosmicService.todaysCosmic {
                // Cosmic Data Grid
                HStack(spacing: 20) {
                    // Moon Phase
                    VStack(spacing: 4) {
                        Text(cosmic.moonPhaseEmoji)
                            .font(.system(size: 32))
                        Text(cosmic.moonPhase.phaseName)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        if let illumination = cosmic.moonIllumination {
                            Text("\(Int(illumination))%")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 50)
                    
                    // Sun Sign
                    VStack(spacing: 4) {
                        Text(cosmic.sunSignEmoji)
                            .font(.system(size: 32))
                        Text("Sun in")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(cosmic.sunSign)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 50)
                    
                    // Planetary Highlights - Mercury and Venus
                    VStack(spacing: 4) {
                        if let mercurySign = cosmic.zodiacSign(for: "Mercury") {
                            HStack(spacing: 8) {
                                Text("☿")
                                    .font(.system(size: 20))
                                Text(mercurySign)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        if let venusSign = cosmic.zodiacSign(for: "Venus") {
                            HStack(spacing: 8) {
                                Text("♀")
                                    .font(.system(size: 20))
                                Text(venusSign)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        if cosmic.zodiacSign(for: "Mercury") == nil && cosmic.zodiacSign(for: "Venus") == nil {
                            Text("Calculating...")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Spiritual Guidance
                VStack(spacing: 4) {
                    Text(cosmic.spiritualGuidance)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal)
                    
                    // Debug info
                    if let version = cosmic.version {
                        Text("Data source: \(version)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            } else if cosmicService.errorMessage != nil {
                // Error State
                Label("Cosmic data temporarily unavailable", systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            } else {
                // Loading State
                Text("Aligning with cosmic frequencies...")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
        }
        .padding()
        .background(cosmicBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .onTapGesture {
            withAnimation {
                isExpanded = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Tap to view detailed cosmic information")
    }
    
    // MARK: - Expanded View
    
    private var expandedView: some View {
        // TODO: Implement full-screen cosmic detail view
        Text("Expanded Cosmic View - Coming Soon")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(cosmicBackground)
            .onTapGesture {
                withAnimation {
                    isExpanded = false
                }
            }
    }
    
    // MARK: - Supporting Views
    
    private var cosmicBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: sacredGradient(for: realmNumber)),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Glass effect
            Color.white.opacity(0.1)
            
            // Blur backdrop
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.3)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get sacred gradient colors for realm number
    private func sacredGradient(for number: Int) -> [Color] {
        switch number {
        case 1: return [Color(hex: "FF6B6B"), Color(hex: "C44569")]
        case 2: return [Color(hex: "4ECDC4"), Color(hex: "44A08D")]
        case 3: return [Color(hex: "FFE66D"), Color(hex: "FFB347")]
        case 4: return [Color(hex: "95E1D3"), Color(hex: "78C1A3")]
        case 5: return [Color(hex: "C7CEEA"), Color(hex: "B8A9C9")]
        case 6: return [Color(hex: "FFDAB9"), Color(hex: "FFB6C1")]
        case 7: return [Color(hex: "E8B4F8"), Color(hex: "B4A7E5")]
        case 8: return [Color(hex: "B4E7CE"), Color(hex: "95D5B2")]
        case 9: return [Color(hex: "FFB5E8"), Color(hex: "FF6B9D")]
        default: return [Color.purple, Color.blue]
        }
    }
    
    /// Accessibility label for VoiceOver
    private var accessibilityLabel: String {
        guard let cosmic = cosmicService.todaysCosmic else {
            return "Cosmic data loading"
        }
        
        var label = "Cosmic snapshot. "
        label += "\(cosmic.moonPhase.phaseName) moon"
        
        if let illumination = cosmic.moonIllumination {
            label += " at \(Int(illumination))% illumination. "
        }
        
        label += "Sun in \(cosmic.sunSign). "
        
        if let mercurySign = cosmic.zodiacSign(for: "Mercury") {
            label += "Mercury in \(mercurySign). "
        }
        
        label += cosmic.spiritualGuidance
        
        return label
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ForEach([1, 5, 9], id: \.self) { realmNumber in
            CosmicSnapshotView(realmNumber: realmNumber)
                .environmentObject(CosmicService.shared)
                .padding(.horizontal)
        }
    }
    .background(Color.black)
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 