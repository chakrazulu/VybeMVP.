/**
 * Shimmer Loading View - Spiritual AI Loading Animation
 * 
 * A mystical shimmer effect designed specifically for KASPER MLX insight generation.
 * Creates an ethereal, flowing animation that communicates spiritual AI processing
 * while maintaining Vybe's sacred aesthetic standards.
 * 
 * Key Features:
 * • Smooth gradient-based shimmer animation
 * • Spiritual color palette (purple, gold, cyan)
 * • Customizable content shape and speed
 * • Performance optimized for 60fps
 * • Accessibility support with reduced motion
 * 
 * Usage:
 * ```swift
 * ShimmerLoadingView(
 *     text: "Consulting the cosmic wisdom...",
 *     width: 300,
 *     height: 100
 * )
 * ```
 */

import SwiftUI

/// Claude: Spiritual shimmer loading animation for KASPER MLX
struct ShimmerLoadingView: View {
    let text: String
    let width: CGFloat
    let height: CGFloat
    let animationSpeed: Double
    
    @State private var shimmerOffset: CGFloat = -1.0
    @AccessibilityFocusState private var isAccessibilityFocused: Bool
    
    init(
        text: String = "Consulting the cosmic wisdom...",
        width: CGFloat = 280,
        height: CGFloat = 60,
        animationSpeed: Double = 2.0
    ) {
        self.text = text
        self.width = width
        self.height = height
        self.animationSpeed = animationSpeed
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Shimmer content area
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width, height: height)
                .overlay(
                    // Shimmer overlay effect
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.clear, location: 0.0),
                                    .init(color: Color.white.opacity(0.6), location: 0.3),
                                    .init(color: Color.cyan.opacity(0.4), location: 0.5),
                                    .init(color: Color.white.opacity(0.6), location: 0.7),
                                    .init(color: Color.clear, location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(15))
                        .scaleEffect(x: 3, y: 1)
                        .offset(x: shimmerOffset * (width + 100))
                        .mask(
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: width, height: height)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.3),
                                    Color.cyan.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            // Loading text with subtle pulse
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .italic()
                .opacity(0.7 + 0.3 * sin(Date().timeIntervalSince1970 * 2))
        }
        .onAppear {
            startShimmerAnimation()
        }
        .accessibilityFocused($isAccessibilityFocused)
        .accessibilityLabel("Loading spiritual insight")
        .accessibilityHint(text)
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    /// Claude: Start the shimmer animation with reduced motion support
    private func startShimmerAnimation() {
        // Check if user prefers reduced motion
        let reduceMotion = UIAccessibility.isReduceMotionEnabled
        
        if reduceMotion {
            // Simple fade animation for accessibility
            withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                shimmerOffset = 0.5
            }
        } else {
            // Full shimmer animation
            withAnimation(.linear(duration: animationSpeed).repeatForever(autoreverses: false)) {
                shimmerOffset = 1.0
            }
        }
    }
}

/// Claude: Preview for shimmer loading view
struct ShimmerLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                ShimmerLoadingView(
                    text: "Consulting the cosmic wisdom...",
                    width: 300,
                    height: 80
                )
                
                ShimmerLoadingView(
                    text: "Generating spiritual insight...",
                    width: 250,
                    height: 60,
                    animationSpeed: 1.5
                )
                
                ShimmerLoadingView(
                    text: "Aligning with universal energies...",
                    width: 320,
                    height: 100,
                    animationSpeed: 2.5
                )
            }
        }
    }
}