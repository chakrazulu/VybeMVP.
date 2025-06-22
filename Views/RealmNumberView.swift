/**
 * Filename: RealmNumberView.swift
 * 
 * Purpose: Displays the current realm number in a mystical, transcendent experience.
 * Features cosmic background with numerology rain, enhanced glowing effects, and sacred geometry.
 * The realm number is a cosmic/universal numerical value that changes based on time, date,
 * location, and heart rate factors.
 *
 * Design pattern: Declarative SwiftUI view with mystical enhancements
 * Dependencies: RealmNumberManager for data access, CosmicBackgroundView, NumerologyRainView, SacredGeometryView
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
 * 1. Cosmic starfield background
 * 2. Cascading numerology rain effect
 * 3. Sacred geometry visualization of the realm number
 * 4. Mystical realm description
 * 5. Sacred calculation factors display
 */
struct RealmNumberView: View {
    /// Access to the realm number manager for the current realm number value
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Cosmic background with stars
            CosmicBackgroundView()
                .ignoresSafeArea()
            
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
                    
                    // Enhanced glowing realm number display
                    mysticalRealmNumberDisplay
                    
                    // Sacred realm description
                    mysticalRealmDescription
                    
                    // Cosmic calculation factors
                    cosmicFactorsDisplay
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            startMysticalAnimations()
        }
    }
    
    // MARK: - Mystical Realm Number Display
    
    private var mysticalRealmNumberDisplay: some View {
        NavigationLink(destination: NumberMeaningView(initialSelectedNumber: realmNumberManager.currentRealmNumber)) {
            ZStack {
                // Outer cosmic ring with enhanced glow
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                getRealmNumberColor().opacity(0.8),
                                getRealmNumberColor().opacity(0.4),
                                .white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 280, height: 280)
                    .opacity(glowIntensity)
                    .shadow(color: getRealmNumberColor().opacity(0.6), radius: 20)
                
                // Sacred Geometry Background Glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                getRealmNumberColor().opacity(0.3),
                                getRealmNumberColor().opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 260, height: 260)
                
                // Large Realm Number behind the sacred geometry
                Text("\(realmNumberManager.currentRealmNumber)")
                    .font(.system(size: 140, weight: .bold, design: .rounded))
                    .foregroundColor(getRealmNumberColor())
                    .shadow(color: getRealmNumberColor().opacity(0.8), radius: 20)
                    .shadow(color: .black.opacity(0.8), radius: 10, x: 4, y: 4)
                
                // Static Sacred Geometry Pattern overlay (NO ANIMATIONS)
                StaticSacredGeometryView(
                    number: realmNumberManager.currentRealmNumber
                )
                .frame(width: 450, height: 450)
                .shadow(color: getRealmNumberColor().opacity(0.8), radius: 15)
                .shadow(color: getRealmNumberColor().opacity(0.4), radius: 30)
                
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
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            getRealmNumberColor().opacity(0.2),
                            Color.black.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getRealmNumberColor().opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: getRealmNumberColor().opacity(0.3), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Cosmic Factors Display
    
    private var cosmicFactorsDisplay: some View {
        VStack(spacing: 20) {
            Text("✧ COSMIC ALIGNMENT FACTORS ✧")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .white.opacity(0.3), radius: 3)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                CosmicFactorCard(
                    icon: "clock.circle.fill",
                    title: "Temporal\nResonance",
                    color: .blue
                )
                
                CosmicFactorCard(
                    icon: "calendar.circle.fill",
                    title: "Celestial\nAlignment",
                    color: .purple
                )
                
                CosmicFactorCard(
                    icon: "location.circle.fill",
                    title: "Earthly\nCoordinates",
                    color: .green
                )
                
                CosmicFactorCard(
                    icon: "heart.circle.fill",
                    title: "Life Force\nRhythm",
                    color: .red
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.2), .purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Methods
    
    private func startMysticalAnimations() {
        // NO ANIMATIONS - keep the view completely stable
        // Only set static glow intensity without animation
        glowIntensity = 0.8
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
}

// MARK: - Cosmic Factor Card Component

struct CosmicFactorCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.6), radius: 5)
            
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Static Sacred Geometry View (NO ANIMATIONS)

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
}
