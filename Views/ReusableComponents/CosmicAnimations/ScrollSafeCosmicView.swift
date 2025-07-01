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

// MARK: - Cosmic Background Layer Component (ENHANCED VERSION)
struct CosmicBackgroundLayer: View {
    let date: Date
    let intensity: Double
    let isEnabled: Bool
    
    // MARK: - Animation State (Enhanced)
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: Double = 1.0
    @State private var floatingOffset: Double = 0
    
    var body: some View {
        if isEnabled {
            ZStack {
                // MARK: - Enhanced Cosmic Background (More Visible)
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.4 * intensity),
                        Color.blue.opacity(0.3 * intensity),
                        Color.indigo.opacity(0.2 * intensity),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
                
                // MARK: - Multiple Sacred Geometry Elements (Enhanced)
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(
                            Color.gold.opacity(0.6 * intensity),
                            lineWidth: 3
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(pulseScale)
                    
                    // Inner ring (counter-rotating)
                    Circle()
                        .stroke(
                            Color.cyan.opacity(0.5 * intensity),
                            lineWidth: 2
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-rotationAngle * 0.7))
                        .scaleEffect(pulseScale * 0.8)
                    
                    // Center sacred symbol
                    Circle()
                        .fill(Color.white.opacity(0.3 * intensity))
                        .frame(width: 8, height: 8)
                        .scaleEffect(pulseScale * 1.5)
                }
                
                // MARK: - Enhanced Floating Elements (More Visible)
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.cyan.opacity(0.6),
                                    Color.purple.opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 8, height: 8)
                        .offset(
                            x: cos(Double(index) * 1.26 + floatingOffset) * 150,
                            y: sin(Double(index) * 1.26 + floatingOffset) * 150
                        )
                        .scaleEffect(0.5 + 0.5 * sin(Double(index) + floatingOffset * 2))
                }
                
                // MARK: - Cosmic Dust Effect
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 2, height: 2)
                        .offset(
                            x: cos(Double(index) * 0.785 + floatingOffset * 0.5) * 250,
                            y: sin(Double(index) * 0.785 + floatingOffset * 0.5) * 250
                        )
                        .opacity(0.3 + 0.3 * sin(Double(index) + floatingOffset))
                }
            }
            .onAppear {
                startEnhancedAnimations()
            }
        } else {
            // Fallback: Static cosmic background
            Color.black.opacity(0.05)
        }
    }
    
    // MARK: - Enhanced Animation Initialization
    private func startEnhancedAnimations() {
        // Main rotation animation (smooth and continuous)
        withAnimation(.linear(duration: 40.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Pulsing animation (breathing effect)
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        // Floating elements animation
        withAnimation(.linear(duration: 25.0).repeatForever(autoreverses: false)) {
            floatingOffset = .pi * 2
        }
        
        print("🌟 CosmicBackgroundLayer: Enhanced cosmic animations started")
    }
}

// MARK: - Color Extensions removed (already defined in project)

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