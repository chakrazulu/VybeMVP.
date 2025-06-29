//
//  VybeMatchOverlay.swift
//  VybeMVP
//
//  🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
//
//  === SCREEN POSITIONING (iPhone 14 Pro Max: 430×932 points) ===
//  • Main bubble center: x=215pts (50% width), y=391pts (42% height)
//  • Bubble dimensions: 380×300 points (optimal for content + future actions)
//  • Particles orbit radius: 145pts from bubble center
//  • Close button: top-right corner, 50pts from top, 20pts from right
//
//  === INTERNAL BUBBLE LAYOUT (380×300pt container) ===
//  • Top spacer: 25pts (pushes content down from bubble top)
//  • VYBE text: 64pt font, centered horizontally
//  • VYBE + subtitle spacing: 12pts vertical gap
//  • Subtitle text: 18pt font, medium weight
//  • Bottom spacer: 40pts (RESERVED for future action buttons)
//
//  === ANIMATION SPECIFICATIONS ===
//  • Entrance scale: 0.1 → 1.2 → 1.0 (dramatic growth effect)
//  • Floating motion: ±3% scale variation (0.97x to 1.03x)
//  • Glow breathing: 75% to 95% opacity variation
//  • Animation timing: 1.5π frequency (slower, ethereal feel)
//  • Particle rotation: 360° over 20 seconds, linear
//
//  === GLASS-MORPHISM STYLING ===
//  • Background: 15% to 5% white gradient (top-left to bottom-right)
//  • Border: 30% to 10% white gradient stroke, 1.5pt width
//  • Corner radius: 25pts for modern rounded appearance
//  • Shadow: black 30% opacity, 20pt radius, 10pt Y offset
//
//  === TYPOGRAPHY HIERARCHY ===
//  • VYBE text: 64pt, black weight, rounded design, rainbow gradient
//  • Subtitle: 18pt, medium weight, rounded design, 90% white opacity
//  • Both scale with main animation (85% for subtitle)
//
//  === INTERACTION ZONES ===
//  • Background tap: Full screen area (dismisses overlay)
//  • Content tap: 380×300pt bubble area (prevents background dismiss)
//  • Close button: ~44×44pt touch target (top-right corner)
//
//  === FUTURE EXPANSION AREAS ===
//  • Bottom 40pts reserved for action buttons (share, save, etc.)
//  • Bubble can expand vertically to 350pts if needed
//  • Particle system can accommodate 8-12 objects without performance impact
//
//  Created for cosmic match celebration when Focus Number == Realm Number
//  This overlay appears with mystical animations synchronized to user's heart rate
//

@preconcurrency import SwiftUI
import Combine

/**
 * VybeMatchOverlay: A mystical overlay that appears when cosmic alignment occurs
 * 
 * Purpose:
 * - Displays when Focus Number matches Realm Number (e.g., 4 == 4)
 * - Creates immersive cosmic celebration with pulsing "Vybe" symbol
 * - Synchronizes animations with user's heart rate for personalized experience
 * - Uses TimelineView to prevent interruption during scrolling
 * 
 * Design Philosophy:
 * - Celebrates the sacred moment of numerical alignment
 * - Enhances the mystical experience without being intrusive
 * - Provides visual feedback for the core app mechanic
 */
struct VybeMatchOverlay: View {
    
    // MARK: - State Properties
    
    /// Whether the match overlay should be visible
    @Binding var isVisible: Bool
    
    /// The matched number (both Focus and Realm number)
    let matchedNumber: Int
    
    /// User's current heart rate for animation synchronization
    let heartRate: Double
    
    /// Duration the overlay has been visible (for auto-dismiss)
    @State private var visibilityDuration: TimeInterval = 0
    
    /// Animation phase for the pulsing effect
    @State private var pulsePhase: Double = 0
    
    /// Scale factor for the main "Vybe" symbol
    @State private var symbolScale: Double = 1.0
    
    /// Opacity for the cosmic background glow
    @State private var backgroundGlow: Double = 0.0
    
    /// Rotation angle for the cosmic elements
    @State private var cosmicRotation: Double = 0
    
    // MARK: - Configuration
    
    /// How long the overlay stays visible (in seconds) - extended for better experience
    private let displayDuration: TimeInterval = 6.0
    
    /// Base animation duration (modified by heart rate)
    private let baseAnimationDuration: Double = 1.0
    
    /// Minimum heart rate for animation timing
    private let minHeartRate: Double = 40.0
    
    /// Maximum heart rate for animation timing
    private let maxHeartRate: Double = 120.0
    
    // MARK: - Computed Properties
    
    /// Animation duration based on heart rate (faster heart rate = faster animation)
    private var heartRateAnimationDuration: Double {
        guard heartRate > 0 else { return baseAnimationDuration }
        
        // Convert BPM to animation duration
        // Higher BPM = shorter duration (faster animation)
        let clampedBPM = max(minHeartRate, min(heartRate, maxHeartRate))
        let normalizedBPM = (clampedBPM - minHeartRate) / (maxHeartRate - minHeartRate)
        
        // Duration ranges from 1.5s (slow heart) to 0.6s (fast heart)
        return 1.5 - (normalizedBPM * 0.9)
    }
    
    var body: some View {
        ZStack {
            if isVisible {
                // Cosmic background with animated glow - tap to dismiss
                cosmicBackground
                    .onTapGesture {
                        print("🌟 User tapped background - dismissing overlay")
                        isVisible = false
                    }
                
                // 🎯 MAIN CONTENT CONTAINER: 380×300pt glass-morphism bubble
                // Positioned at screen center (50% width, 42% height)
                VStack(spacing: 15) { // 15pt spacing between elements for optimal flow
                    Spacer(minLength: 25) // 25pt top spacer: pushes VYBE text down from bubble edge
                    
                    // 🌟 VYBE SYMBOL: Primary cosmic celebration text
                    vybeSymbol
                    
                    Spacer(minLength: 40) // 40pt bottom spacer: RESERVED for future action buttons
                }
                .frame(width: 380, height: 300) // 🎯 CRITICAL: Bubble dimensions optimized for iPhone 14 Pro Max
                .background(
                    // 🎨 GLASS-MORPHISM BUBBLE: Modern iOS design with ethereal transparency
                    RoundedRectangle(cornerRadius: 25) // 25pt radius for modern rounded appearance
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.15), // 15% white at top-left
                                    Color.white.opacity(0.05)  // 5% white at bottom-right
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.3), // 30% white border at top-left
                                            Color.white.opacity(0.1)  // 10% white border at bottom-right
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5 // 1.5pt stroke width for subtle definition
                                )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10) // Depth shadow: 20pt blur, 10pt Y offset
                        .scaleEffect(symbolScale * 0.95) // Gentle floating: 95% of main scale animation
                )
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.42) // 🎯 EXACT CENTER: 50% width, 42% height
                .onTapGesture {
                    // Prevent background tap when tapping content
                }
                
                // Particle effects around the symbol
                cosmicParticles
                
                // Close button in top-right corner
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("🌟 User tapped close button - dismissing overlay")
                            isVisible = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                                .background(Circle().fill(Color.black.opacity(0.3)))
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.5), value: isVisible)
        .onChange(of: isVisible) { _, newValue in
            handleVisibilityChange(newValue)
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateAnimations()
        }
    }
    
    // MARK: - View Components
    
    /// Cosmic background with animated glow effect
    private var cosmicBackground: some View {
        ZStack {
            // Deep space background
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.3),
                            Color.indigo.opacity(0.2),
                            Color.black.opacity(0.7)
                        ]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 300
                    )
                )
                .opacity(backgroundGlow)
            
            // Animated cosmic rings
            ForEach(0..<3, id: \.self) { ringIndex in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.cyan.opacity(0.6),
                                Color.purple.opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100 + CGFloat(ringIndex * 50))
                    .rotationEffect(.degrees(cosmicRotation + Double(ringIndex * 120)))
                    .opacity(backgroundGlow * 0.8)
            }
        }
        .ignoresSafeArea()
    }
    
    /// 🌟 VYBE SYMBOL: Primary cosmic celebration text with rainbow gradient and ethereal shadows
    private var vybeSymbol: some View {
        VStack(spacing: 12) { // 12pt spacing between VYBE text and subtitle
            // 🎨 MYSTICAL VYBE TEXT: 64pt font optimized for 380pt bubble width
            Text("✨ VYBE ✨")
                .font(.system(size: 64, weight: .black, design: .rounded)) // 64pt: Perfect fit within 380pt bubble
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.cyan,    // Cosmic blue at top-left
                            Color.purple,  // Mystical purple in center
                            Color.pink     // Ethereal pink at bottom-right
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(symbolScale) // Responds to floating animation (0.97x to 1.03x)
                .shadow(color: .cyan, radius: 15)    // Inner glow: 15pt cyan
                .shadow(color: .purple, radius: 25)  // Mid glow: 25pt purple
                .shadow(color: .pink, radius: 35)    // Outer glow: 35pt pink
            
            // 📝 COSMIC SUBTITLE: 18pt medium weight, positioned 12pts below VYBE
            Text("Cosmic Alignment Achieved")
                .font(.system(size: 18, weight: .medium, design: .rounded)) // 18pt: Proportional to 64pt VYBE
                .foregroundColor(.white.opacity(0.9)) // 90% white opacity for subtle elegance
                .opacity(backgroundGlow) // Responds to breathing animation (75% to 95%)
                .scaleEffect(symbolScale * 0.85) // 85% of main scale for hierarchy
        }
    }
    
    /// Display of the matched number with enhanced cosmic styling
    private var matchedNumberDisplay: some View {
        VStack(spacing: 12) {
            Text("Sacred Number")
                .font(.system(size: 18, weight: .semibold)) // Increased from 14 to 18
                .foregroundColor(.white.opacity(0.9))
            
            Text("\(matchedNumber)")
                .font(.system(size: 80, weight: .black, design: .rounded)) // Reduced from 96 to 80 for better fit
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.yellow,
                            Color.orange,
                            Color.red
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .yellow, radius: 20)
                .shadow(color: .orange, radius: 30)
                .scaleEffect(symbolScale * 0.85)
        }
        .opacity(backgroundGlow)
    }
    
    /// ✨ COSMIC PARTICLES: 8 orbiting white dots around the bubble (145pt radius)
    private var cosmicParticles: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { particleIndex in
                let angle = Double(particleIndex) * .pi / 4 + cosmicRotation * .pi / 180 // 45° spacing + rotation
                let radius: Double = 145 // 145pt orbit radius: Perfect for 380pt bubble (38% larger than bubble)
                
                Circle()
                    .fill(Color.white.opacity(0.9)) // 90% white opacity for cosmic shimmer
                    .frame(width: 6, height: 6) // 6×6pt particles: Visible but not distracting
                    .offset(
                        x: cos(angle) * radius, // X position on orbit
                        y: sin(angle) * radius  // Y position on orbit
                    )
                    .opacity(backgroundGlow * 0.9) // Sync with breathing animation (67% to 85% final opacity)
                    .scaleEffect(symbolScale * 0.6) // 60% of main scale for subtle size variation
            }
        }
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.42) // 🎯 EXACT MATCH: Same center as bubble
    }
    
    // MARK: - Animation Logic
    
    /**
     * Handles visibility state changes with debug logging
     * 
     * When the overlay becomes visible:
     * - Resets animation timers
     * - Logs the match event
     * - Starts the cosmic animation sequence
     * 
     * When the overlay becomes hidden:
     * - Resets all animation states
     * - Logs the dismissal
     */
    private func handleVisibilityChange(_ newValue: Bool) {
        if newValue {
            print("🌟 ===== VYBE MATCH OVERLAY ACTIVATED =====")
            print("🌟 Matched Number: \(matchedNumber)")
            print("🌟 Heart Rate: \(heartRate) BPM")
            print("🌟 Animation Duration: \(String(format: "%.2f", heartRateAnimationDuration))s")
            print("🌟 Display Duration: \(displayDuration)s (tap to dismiss early)")
            
            // Reset animation state
            visibilityDuration = 0
            pulsePhase = 0
            
            // Start entrance animations
            startEntranceAnimations()
            
        } else {
            print("🌟 Vybe Match Overlay dismissed")
            
            // Reset all animation states
            resetAnimationStates()
        }
    }
    
    /**
     * Starts the dramatic entrance animation sequence
     * Creates a growing effect from tiny to massive with cosmic elements
     */
    private func startEntranceAnimations() {
        // Start with tiny scale for dramatic growth effect
        symbolScale = 0.1
        backgroundGlow = 0.0
        
        // Phase 1: Background fades in quickly (0.3s)
        withAnimation(.easeOut(duration: 0.3)) {
            backgroundGlow = 0.4
        }
        
        // Phase 2: Dramatic scale growth with powerful spring effect (0.8s)
        withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.2)) {
            symbolScale = 1.2 // Slightly larger than final for dramatic effect
        }
        
        // Phase 3: Settle to final size and full glow (0.4s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self.symbolScale = 1.0 // Final size
            }
            withAnimation(.easeInOut(duration: 0.6)) {
                self.backgroundGlow = 1.0 // Full cosmic glow
            }
        }
        
        // Phase 4: Start continuous cosmic rotation (1.0s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                self.cosmicRotation = 360
            }
        }
    }
    
    /**
     * Updates continuous animations based on heart rate
     * Called every 0.1 seconds for smooth animation
     */
    private func updateAnimations() {
        guard isVisible else { return }
        
        // Update visibility duration
        visibilityDuration += 0.1
        
        // Auto-dismiss after display duration
        if visibilityDuration >= displayDuration {
            print("🌟 Auto-dismissing Vybe Match Overlay after \(displayDuration)s")
            isVisible = false
            return
        }
        
        // Update heart rate synchronized pulse
        pulsePhase += 0.1 / heartRateAnimationDuration
        
        // 🌊 GENTLE FLOATING EFFECT: Ethereal breathing animation
        let floatValue = sin(pulsePhase * 1.5 * .pi) // 1.5π frequency: Slower, more mystical than heartbeat
        symbolScale = 1.0 + (floatValue * 0.03) // ±3% scale variation: Barely perceptible (0.97x to 1.03x)
        
        // ✨ ETHEREAL GLOW BREATHING: Subtle opacity pulse synchronized with floating
        backgroundGlow = 0.85 + (floatValue * 0.1) // 10% variation: Gentle pulse (75% to 95% opacity)
    }
    
    /**
     * Resets all animation states to default values
     * Called when the overlay is dismissed
     */
    private func resetAnimationStates() {
        symbolScale = 1.0
        backgroundGlow = 0.0
        cosmicRotation = 0
        pulsePhase = 0
        visibilityDuration = 0
    }
}

// MARK: - Preview

struct VybeMatchOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black // Dark background for preview
            
            VybeMatchOverlay(
                isVisible: .constant(true),
                matchedNumber: 7,
                heartRate: 72
            )
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 400, height: 600)
    }
} 