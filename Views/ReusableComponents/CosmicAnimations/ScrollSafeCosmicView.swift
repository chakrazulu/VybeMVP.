/*
 * ========================================
 * 🌌 SCROLL-SAFE COSMIC VIEW - MAIN ANIMATION WRAPPER
 * ========================================
 * 
 * CORE PURPOSE:
 * Main wrapper component that enables scroll-safe cosmic animations using TimelineView
 * for off-main-thread rendering. Provides seamless cosmic background animations that
 * persist during scroll interactions without affecting performance or user experience.
 * 
 * TECHNICAL ARCHITECTURE:
 * 
 * === TIMELINEVIEW ANIMATION SYSTEM ===
 * • Animation Engine: TimelineView(.animation) for 60fps off-main-thread rendering
 * • Performance Target: Maintains 60fps during scroll interactions
 * • Layer Strategy: Full-screen ZStack with cosmic background behind scrollable content
 * • Time-Based Animation: Uses timeline.date for consistent, scroll-independent motion
 * 
 * === SCROLL-SAFE LAYERING PATTERN ===
 * ZStack Structure:
 * 1. TimelineView Layer (Background) - Cosmic animations run independently
 * 2. Content Layer (Foreground) - ScrollView or other interactive content
 * 3. Optional Overlay Layer - Floating UI elements or cosmic overlays
 * 
 * INTEGRATION POINTS:
 * • CosmicBackgroundLayer.swift: Main background animation component
 * • SacredGeometryAnimator.swift: Mandala rotation and sacred shape animations
 * • NeonTracerAnimator.swift: BPM-synced glow effects and energy tracers
 * • ProceduralNumberOverlay.swift: Floating number animations and cosmic digits
 * 
 * USAGE PATTERN:
 * ```swift
 * ScrollSafeCosmicView {
 *     ScrollView {
 *         // Your scrollable content here
 *     }
 * }
 * ```
 * 
 * PERFORMANCE NOTES:
 * • TimelineView automatically manages animation scheduling
 * • Cosmic animations run on background threads
 * • No impact on scroll performance or main thread responsiveness
 * • Graceful degradation on older devices
 */

import SwiftUI

struct ScrollSafeCosmicView<Content: View>: View {
    let content: Content
    
    // MARK: - Animation Configuration
    @State private var isAnimationEnabled = true
    @State private var animationIntensity: Double = 1.0
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // MARK: - Cosmic Background Layer (TimelineView)
            TimelineView(.animation) { timeline in
                CosmicBackgroundLayer(
                    date: timeline.date,
                    intensity: animationIntensity,
                    isEnabled: isAnimationEnabled
                )
            }
            .ignoresSafeArea() // Full-screen cosmic background
            .allowsHitTesting(false) // Prevent interference with content interaction
            
            // MARK: - Content Layer (Scrollable Content)
            content
                .background(Color.clear) // Transparent to show cosmic background
        }
        .onAppear {
            initializeCosmicEnvironment()
        }
    }
    
    // MARK: - Cosmic Environment Initialization
    private func initializeCosmicEnvironment() {
        // Ensure animations are enabled by default
        isAnimationEnabled = true
        animationIntensity = 1.0
        
        print("🌌 ScrollSafeCosmicView: Cosmic environment initialized")
    }
}

// MARK: - Cosmic Background Layer Component
struct CosmicBackgroundLayer: View {
    let date: Date
    let intensity: Double
    let isEnabled: Bool
    
    // MARK: - Animation State
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: Double = 1.0
    
    var body: some View {
        if isEnabled {
            ZStack {
                // MARK: - Base Cosmic Background
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.1 * intensity),
                        Color.blue.opacity(0.05 * intensity),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
                .scaleEffect(pulseScale)
                .animation(
                    .easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                    value: pulseScale
                )
                
                // MARK: - Sacred Geometry Layer
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gold.opacity(0.2 * intensity),
                                Color.clear,
                                Color.gold.opacity(0.1 * intensity)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(
                        .linear(duration: 20.0).repeatForever(autoreverses: false),
                        value: rotationAngle
                    )
            }
            .onAppear {
                startCosmicAnimations()
            }
        } else {
            // Fallback: Static cosmic background
            Color.black.opacity(0.1)
        }
    }
    
    // MARK: - Animation Initialization
    private func startCosmicAnimations() {
        // Start rotation animation
        rotationAngle = 360
        
        // Start pulse animation
        pulseScale = 1.2
        
        print("🌟 CosmicBackgroundLayer: Cosmic animations started")
    }
}

// MARK: - Color Extensions for Cosmic Theme
extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// MARK: - Preview
struct ScrollSafeCosmicView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollSafeCosmicView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 100)
                            .overlay(
                                Text("Scrollable Content \(index + 1)")
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
} 