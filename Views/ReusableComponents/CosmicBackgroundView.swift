/*
 * ========================================
 * 🌌 COSMIC BACKGROUND VIEW - SPACE TRAVEL EFFECT
 * ========================================
 * 
 * CORE PURPOSE:
 * Foundational animated background creating immersive space travel experience with stars
 * accelerating toward viewer. Used throughout app for consistent cosmic aesthetic.
 * Provides parallax depth effect and dynamic star field generation.
 * 
 * UI SPECIFICATIONS:
 * - Screen: Full-screen ignoresSafeArea() coverage
 * - Base Gradient: Black → Purple(30%) → Indigo(20%) → Black
 * - Star Field: 35 active stars (performance optimized from higher counts)
 * - Star Sizes: 0.5-3.0pt initial, growing to 15pt maximum
 * - Star Colors: White, Cyan, Purple, Indigo, Blue with opacity variations
 * 
 * ANIMATION SYSTEM:
 * - Timer Interval: 0.05s (20fps) for smooth motion without performance hit
 * - Star Speed: 1-4pt/frame initial, accelerating with depth factor
 * - Parallax Effect: Stars move outward from screen center (centerX, centerY)
 * - Depth Factor: 0.1-1.0 controls acceleration and movement speed
 * - Size Growth: 0.1 * speed * depth per frame
 * - Opacity Fade: Increases as stars approach (0.01 * depth per frame)
 * 
 * STAR LIFECYCLE:
 * 1. Birth: Generated in center area (centerX±100, centerY±100)
 * 2. Travel: Accelerate outward with increasing size and opacity
 * 3. Death: Removed when size>15pt or position off-screen (±50pt buffer)
 * 4. Rebirth: Immediately replaced with new star in center area
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Limited to 35 stars (down from higher counts for smooth performance)
 * - Timer-based animation instead of SwiftUI animation for better control
 * - Efficient star recycling system prevents memory growth
 * - Shadow rendering optimized with size-based radius calculation
 * - Color array for efficient random selection
 * 
 * INTEGRATION POINTS:
 * - HomeView: Primary cosmic background layer
 * - NumberMeaningView: Full-screen cosmic experience
 * - RealmNumberView: Mystical number display backdrop
 * - All major views requiring cosmic aesthetic
 * 
 * VISUAL EFFECTS:
 * - Parallax depth illusion with multiple speed layers
 * - Dynamic star generation creates infinite travel effect
 * - Gradient shadows provide cosmic glow around each star
 * - Multi-color star field with weighted white stars for realism
 * - Smooth acceleration curve simulates approaching light speed
 * 
 * TECHNICAL NOTES:
 * - Uses UIScreen.main.bounds for screen dimension calculations
 * - Timer invalidation on view disappear prevents memory leaks
 * - Star struct with Identifiable for efficient SwiftUI updates
 * - Depth-based calculations create realistic 3D motion illusion
 */

import SwiftUI

struct CosmicBackgroundView: View {
    @State private var stars: [Star] = []
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    Color.indigo.opacity(0.2),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Traveling stars
            ForEach(stars) { star in
                Circle()
                    .fill(star.color)
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x, y: star.y)
                    .opacity(star.opacity)
                    .shadow(color: star.color.opacity(0.3), radius: star.size * 0.3, x: 0, y: 0)
            }
        }
        .onAppear {
            generateInitialStars()
            startStarAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }
    
    private func generateInitialStars() {
        stars = []
        
        // Generate initial stars at various distances - reduced for better performance
        for _ in 0..<35 {
            let star = Star(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 0.5...3.0),
                speed: CGFloat.random(in: 1...4),
                color: randomStarColor(),
                opacity: Double.random(in: 0.3...1.0),
                depth: CGFloat.random(in: 0.1...1.0)
            )
            stars.append(star)
        }
    }
    
    private func startStarAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateStars()
        }
    }
    
    private func updateStars() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<stars.count {
            // Move stars toward camera (increasing size and speed)
            stars[i].size += stars[i].speed * 0.1 * stars[i].depth
            stars[i].speed += 0.05 * stars[i].depth
            
            // Move stars outward from center creating parallax effect
            let centerX = screenWidth / 2
            let centerY = screenHeight / 2
            
            let deltaX = stars[i].x - centerX
            let deltaY = stars[i].y - centerY
            
            stars[i].x += deltaX * stars[i].speed * 0.02 * stars[i].depth
            stars[i].y += deltaY * stars[i].speed * 0.02 * stars[i].depth
            
            // Increase opacity as stars get closer
            stars[i].opacity = min(1.0, stars[i].opacity + 0.01 * stars[i].depth)
            
            // Remove stars that are too big or off screen
            if stars[i].size > 15 || 
               stars[i].x < -50 || stars[i].x > screenWidth + 50 ||
               stars[i].y < -50 || stars[i].y > screenHeight + 50 {
                
                // Replace with new star starting from center area
                stars[i] = Star(
                    x: CGFloat.random(in: centerX - 100...centerX + 100),
                    y: CGFloat.random(in: centerY - 100...centerY + 100),
                    size: CGFloat.random(in: 0.3...1.0),
                    speed: CGFloat.random(in: 1...3),
                    color: randomStarColor(),
                    opacity: Double.random(in: 0.2...0.5),
                    depth: CGFloat.random(in: 0.1...1.0)
                )
            }
        }
    }
    
    private func randomStarColor() -> Color {
        let colors: [Color] = [
            .white,
            .white.opacity(0.9),
            .cyan.opacity(0.7),
            .purple.opacity(0.6),
            .indigo.opacity(0.5),
            .blue.opacity(0.4)
        ]
        return colors.randomElement() ?? .white
    }
}

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var color: Color
    var opacity: Double
    var depth: CGFloat // Controls how fast the star approaches
}

struct CosmicBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CosmicBackgroundView()
    }
} 