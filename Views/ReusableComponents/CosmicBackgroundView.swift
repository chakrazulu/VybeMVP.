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
    
    // Claude: PERFORMANCE OPTIMIZATION - Replace Timer with TimelineView for better performance
    // Previous: Timer-based animation causing inconsistent frame rates
    // Optimized: TimelineView provides smooth 60fps off-main-thread animation
    
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

            // Optimized star animation using TimelineView
            TimelineView(.animation) { timeline in
                ForEach(stars, id: \.id) { star in
                    Circle()
                        .fill(star.color)
                        .frame(width: star.currentSize(at: timeline.date), height: star.currentSize(at: timeline.date))
                        .position(x: star.currentX(at: timeline.date), y: star.currentY(at: timeline.date))
                        .opacity(star.currentOpacity(at: timeline.date))
                        .shadow(
                            color: star.color.opacity(0.3), 
                            radius: star.currentSize(at: timeline.date) * 0.3, 
                            x: 0, y: 0
                        )
                }
                .onAppear {
                    if stars.isEmpty {
                        generateOptimizedStars()
                    }
                }
                .onChange(of: timeline.date) { oldValue, newValue in
                    updateStarsOptimized(at: newValue)
                }
            }
        }
    }
    
    // Claude: PERFORMANCE OPTIMIZATION - TimelineView-based star generation
    private func generateOptimizedStars() {
        stars = []
        let currentTime = Date()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // Generate fewer stars (25 instead of 35) for better 60fps performance
        for _ in 0..<25 {
            // Generate star in center area
            let initialX = CGFloat.random(in: centerX - 80...centerX + 80)
            let initialY = CGFloat.random(in: centerY - 80...centerY + 80)
            
            // Calculate direction from center
            let deltaX = initialX - centerX
            let deltaY = initialY - centerY
            let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
            
            // Normalize direction (avoid division by zero)
            let normalizedDirection = distance > 0 ? 
                CGPoint(x: deltaX / distance, y: deltaY / distance) :
                CGPoint(x: 0, y: 1) // Default upward direction
            
            let star = Star(
                initialX: initialX,
                initialY: initialY,
                initialSize: CGFloat.random(in: 0.5...2.0), // Reduced max size
                speed: CGFloat.random(in: 1...3), // Reduced max speed
                color: randomStarColor(),
                initialOpacity: Double.random(in: 0.3...0.7), // Reduced initial opacity
                depth: CGFloat.random(in: 0.1...1.0),
                birthTime: currentTime,
                direction: normalizedDirection
            )
            stars.append(star)
        }
        print("🌟 Generated \(stars.count) optimized stars for 60fps performance")
    }
    
    // Claude: PERFORMANCE OPTIMIZATION - Efficient star lifecycle management
    private func updateStarsOptimized(at currentTime: Date) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // Remove expired stars (performance optimized)
        stars.removeAll { star in
            star.shouldRemove(at: currentTime, screenWidth: screenWidth, screenHeight: screenHeight)
        }
        
        // Add new stars to maintain count (max 2 per frame for smooth performance)
        let starsToAdd = min(2, 25 - stars.count)
        for _ in 0..<starsToAdd {
            // Generate new star in center area
            let initialX = CGFloat.random(in: centerX - 80...centerX + 80)
            let initialY = CGFloat.random(in: centerY - 80...centerY + 80)
            
            // Calculate direction from center
            let deltaX = initialX - centerX
            let deltaY = initialY - centerY
            let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
            
            let normalizedDirection = distance > 0 ? 
                CGPoint(x: deltaX / distance, y: deltaY / distance) :
                CGPoint(x: 0, y: 1)
            
            let newStar = Star(
                initialX: initialX,
                initialY: initialY,
                initialSize: CGFloat.random(in: 0.3...1.0),
                speed: CGFloat.random(in: 1...2.5),
                color: randomStarColor(),
                initialOpacity: Double.random(in: 0.2...0.5),
                depth: CGFloat.random(in: 0.1...1.0),
                birthTime: currentTime,
                direction: normalizedDirection
            )
            stars.append(newStar)
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

// Claude: PERFORMANCE OPTIMIZATION - Enhanced Star struct for TimelineView animation
struct Star: Identifiable {
    let id = UUID()
    let initialX: CGFloat
    let initialY: CGFloat
    let initialSize: CGFloat
    let speed: CGFloat
    let color: Color
    let initialOpacity: Double
    let depth: CGFloat
    let birthTime: Date
    let direction: CGPoint // Normalized direction vector
    
    // Claude: Performance-optimized property calculations with enhanced movement
    func currentX(at time: Date) -> CGFloat {
        let elapsed = time.timeIntervalSince(birthTime)
        // Enhanced movement: multiply by 30 for more visible star travel
        return initialX + direction.x * speed * CGFloat(elapsed) * depth * 30
    }
    
    func currentY(at time: Date) -> CGFloat {
        let elapsed = time.timeIntervalSince(birthTime)
        // Enhanced movement: multiply by 30 for more visible star travel
        return initialY + direction.y * speed * CGFloat(elapsed) * depth * 30
    }
    
    func currentSize(at time: Date) -> CGFloat {
        let elapsed = time.timeIntervalSince(birthTime)
        return min(15.0, initialSize + CGFloat(elapsed) * 0.1 * speed * depth)
    }
    
    func currentOpacity(at time: Date) -> Double {
        let elapsed = time.timeIntervalSince(birthTime)
        return min(1.0, initialOpacity + elapsed * 0.01 * Double(depth))
    }
    
    // Check if star should be removed (off-screen or too large)
    func shouldRemove(at time: Date, screenWidth: CGFloat, screenHeight: CGFloat) -> Bool {
        let x = currentX(at: time)
        let y = currentY(at: time)
        let size = currentSize(at: time)
        
        return size > 15.0 || 
               x < -50 || x > screenWidth + 50 ||
               y < -50 || y > screenHeight + 50
    }
}

struct CosmicBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CosmicBackgroundView()
    }
} 