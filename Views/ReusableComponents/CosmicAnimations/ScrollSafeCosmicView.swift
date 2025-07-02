/*
 * ========================================
 * 🌌 SCROLL-SAFE COSMIC VIEW - REFINED BLOOM-AND-FADE SYSTEM
 * ========================================
 * 
 * CORE PURPOSE:
 * Main wrapper component implementing refined bloom-and-fade effect.
 * Numbers spawn from sacred geometry center in radial distribution and fade in place,
 * creating an organic, mystical experience with edge-fade opacity gradient.
 * 
 * TECHNICAL ARCHITECTURE:
 * 
 * === REFINED BLOOM IMPLEMENTATION ===
 * • Spawn-and-Fade Only: Numbers bloom in place with NO movement animation
 * • Radial Bloom Distribution: Random angle + radius biased toward center
 * • Edge-Fade Opacity Gradient: Full opacity at core, diminishing toward edges
 * • Precise Lifecycle: 2-second total - 0.2s fade-in, 1.2s visible, 0.6s fade-out
 * • Target Density: 300-350 active numbers for rich visual impact
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
 * VISUAL DESIGN:
 * • Typewriter Font: Monospaced design for mystical aesthetic
 * • Size Range: 48-72pt for high visibility and impact
 * • Sacred Colors: Enhanced palette with spiritual correspondences
 * • Full Screen Coverage: Including top area for complete immersion
 * • Organic Feel: No hard circular mask, natural radial distribution
 * 
 * PERFORMANCE OPTIMIZATION:
 * • Max 320 active numbers for smooth 60fps operation (~300-350 target)
 * • Efficient lifecycle management with 2-second lifespans
 * • Screen diagonal calculation for proper edge-fade scaling
 * • Graceful degradation on older devices
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
 * MAJOR MILESTONE: December 30, 2024
 * Refined bloom-and-fade system with pure spawn-in-place approach,
 * radial distribution biased toward center, and smooth edge-fade gradient.
 */

import SwiftUI

struct ScrollSafeCosmicView<Content: View>: View {
    let content: Content
    
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var date = Date()
    @State private var lastSpawnTime: TimeInterval = 0
    
    // Track the sacred geometry center position dynamically
    @State private var sacredGeometryCenter: CGPoint = CGPoint(x: 215, y: 466) // iPhone 14 Pro Max center
    
    // Spawn rate control for consistent density
    private let spawnInterval: TimeInterval = 0.05 // Even faster spawn rate
    private let maxActiveNumbers = 750 // Final high density for ultimate richness
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        print("🌌 ScrollSafeCosmicView: Refined bloom-and-fade system initialized")
    }
    
    var body: some View {
        ZStack {
            // Cosmic background layer - time-based animations
            TimelineView(.animation) { timeline in
                GeometryReader { geometry in
                    ZStack {
                        // Twinkling numbers - PURE SPAWN-AND-FADE
                        ForEach(numbers, id: \.id) { number in
                            let opacity = number.currentOpacity(at: timeline.date, 
                                                               centerX: geometry.size.width / 2, 
                                                               centerY: geometry.size.height / 2, 
                                                               screenWidth: geometry.size.width, 
                                                               screenHeight: geometry.size.height)
                            
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .bold, design: .monospaced)) // TYPEWRITER FONT
                                .foregroundColor(number.sacredColor)
                                .opacity(opacity)
                                .position(x: number.x, y: number.y) // FIXED POSITION - NO MOVEMENT
                        }
                    }
                    .onAppear {
                        // Update sacred geometry center for current screen size
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        lastSpawnTime = timeline.date.timeIntervalSince1970
                        print("🌟 Bloom system initialized at center: \(sacredGeometryCenter)")
                    }
                    .onChange(of: timeline.date) { oldValue, newValue in
                        date = newValue
                        updateNumbers(screenSize: geometry.size)
                    }
                    .background(
                        // Track sacred geometry center position during scroll
                        GeometryReader { scrollGeometry in
                            Color.clear
                                .onAppear {
                                    sacredGeometryCenter = CGPoint(
                                        x: scrollGeometry.size.width / 2,
                                        y: scrollGeometry.size.height / 2
                                    )
                                }
                                .onChange(of: scrollGeometry.frame(in: .global)) { oldFrame, newFrame in
                                    sacredGeometryCenter = CGPoint(
                                        x: newFrame.midX,
                                        y: newFrame.midY
                                    )
                                }
                        }
                    )
                }
            }
            .allowsHitTesting(false) // Don't interfere with content interaction
            
            // Main content on top
            content
        }
    }
    
    // MARK: - Number Generation and Lifecycle
    private func updateNumbers(screenSize: CGSize) {
        let currentTime = date.timeIntervalSince1970
        
        // Remove expired numbers (2-second lifecycle)
        numbers.removeAll { number in
            let age = date.timeIntervalSince(number.birthTime)
            return age > 2.0 // Fixed 2-second lifecycle
        }
        
        // Spawn new numbers at consistent intervals
        let timeSinceLastSpawn = currentTime - lastSpawnTime
        if timeSinceLastSpawn >= spawnInterval && numbers.count < maxActiveNumbers {
            // Spawn multiple numbers per interval for rich density
            let numbersToSpawn = min(3, maxActiveNumbers - numbers.count) // Spawn 3 at a time
            
                         for _ in 0..<numbersToSpawn {
                 let number = ScrollSafeTwinklingNumber(
                     sacredCenter: sacredGeometryCenter,
                     birthTime: date,
                     screenSize: screenSize,
                     existingNumbers: numbers
                 )
                 numbers.append(number)
             }
            
            lastSpawnTime = currentTime
            
            if numbersToSpawn > 0 {
                print("🌟 Spawned \(numbersToSpawn) numbers - Active: \(numbers.count)/\(maxActiveNumbers)")
            }
        }
    }
}

// MARK: - Cosmic Background Layer Component (REFINED VERSION)
struct CosmicBackgroundLayer: View {
    let date: Date
    let intensity: Double
    let isEnabled: Bool
    
    // MARK: - Refined Twinkling Numbers State
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var sacredGeometryCenter: CGPoint = CGPoint(x: 215, y: 466)
    @State private var lastSpawnTime: TimeInterval = 0
    
    // Spawn control for background layer
    private let spawnInterval: TimeInterval = 0.10 // Faster background spawn rate
    private let maxActiveNumbers = 400 // More background numbers for complete immersion
    
    var body: some View {
        if isEnabled {
            ZStack {
                // MARK: - Cosmic Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.purple.opacity(0.3 * intensity),
                        Color.indigo.opacity(0.2 * intensity),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // MARK: - Background Twinkling Numbers
                GeometryReader { geometry in
                    ZStack {
                        ForEach(numbers, id: \.id) { number in
                            let opacity = number.currentOpacity(at: date, 
                                                               centerX: geometry.size.width / 2, 
                                                               centerY: geometry.size.height / 2, 
                                                               screenWidth: geometry.size.width, 
                                                               screenHeight: geometry.size.height)
                            
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .bold, design: .monospaced))
                                .foregroundColor(number.sacredColor)
                                .opacity(opacity * 0.6) // Dimmer for background layer
                                .position(x: number.x, y: number.y) // FIXED POSITION
                        }
                    }
                    .onAppear {
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        lastSpawnTime = date.timeIntervalSince1970
                    }
                    .onChange(of: date) { oldValue, newValue in
                        updateNumbers(screenSize: geometry.size)
                    }
                }
            }
        }
    }
    
    // MARK: - Background Number Generation
    private func updateNumbers(screenSize: CGSize) {
        let currentTime = date.timeIntervalSince1970
        
        // Remove expired numbers
        numbers.removeAll { number in
            let age = date.timeIntervalSince(number.birthTime)
            return age > 2.0 // Same 2-second lifecycle
        }
        
        // Spawn background numbers at slower rate
        let timeSinceLastSpawn = currentTime - lastSpawnTime
        if timeSinceLastSpawn >= spawnInterval && numbers.count < maxActiveNumbers {
                         let number = ScrollSafeTwinklingNumber(
                 sacredCenter: sacredGeometryCenter,
                 birthTime: date,
                 screenSize: screenSize,
                 existingNumbers: numbers
             )
            numbers.append(number)
            lastSpawnTime = currentTime
        }
    }
}

// MARK: - Refined Scroll-Safe Twinkling Number
struct ScrollSafeTwinklingNumber: Identifiable {
    let id = UUID()
    let digit: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let maxOpacity: Double
    let birthTime: Date
    let sacredColor: Color
    
         init(sacredCenter: CGPoint, birthTime: Date, screenSize: CGSize, existingNumbers: [ScrollSafeTwinklingNumber] = []) {
        self.digit = Int.random(in: 1...9)
        self.birthTime = birthTime
        
                 // RADIAL BLOOM DISTRIBUTION: Generate initial angle (will be regenerated if collision)
         func generateRandomAngle() -> Double {
             // 60% chance to bias toward top/bottom, 40% chance for full circle (more around mandala)
             if Double.random(in: 0...1) < 0.6 {
                 // Bias toward top/bottom but with wider ranges
                 let topBottomRandom = Double.random(in: 0...1)
                 if topBottomRandom < 0.5 {
                     // Top area (wider range for more coverage)
                     return Double.random(in: -(.pi/2.5)...(.pi/2.5)) + (topBottomRandom < 0.25 ? 0 : 2 * .pi)
                 } else {
                     // Bottom area (wider range for more below-mandala coverage)
                     return Double.random(in: (.pi/2)...(3 * .pi/2))
                 }
             } else {
                 // Full circle distribution for complete around-mandala population
                 return Double.random(in: 0...(2 * .pi))
             }
         }
        
        // Calculate screen diagonal for edge-fade scaling
        let maxRadius = sqrt(pow(screenSize.width / 2, 2) + pow(screenSize.height / 2, 2))
        
                 // Sacred geometry exclusion - ELLIPTICAL to protect mandala core
         let exclusionRadiusX: CGFloat = 180 // Slightly smaller horizontal exclusion
         let exclusionRadiusY: CGFloat = 250 // Reduced vertical exclusion for more around-mandala population
         
                  // Calculate position with elliptical exclusion and collision detection
         var finalX: CGFloat = 0
         var finalY: CGFloat = 0
         var finalRadius: CGFloat = 0
         var attempts = 0
         let maxAttempts = 20
         let minDistance: CGFloat = 60 // Minimum distance between numbers
         
         repeat {
             // Generate fresh random values for each attempt
             let angle = generateRandomAngle()
             let radiusBias = pow(Double.random(in: 0...1), 1.0) // Linear distribution for more even spread
             
             // Calculate radius based on angle to create elliptical exclusion
             let exclusionRadius = sqrt(
                 pow(exclusionRadiusX * sin(CGFloat(angle)), 2) + 
                 pow(exclusionRadiusY * cos(CGFloat(angle)), 2)
             )
             
             let radius = exclusionRadius + (maxRadius * 0.7 * CGFloat(radiusBias))
             
             finalX = sacredCenter.x + cos(CGFloat(angle)) * radius
             finalY = sacredCenter.y + sin(CGFloat(angle)) * radius
             
             // Add small random variation for organic feel
             finalX += CGFloat.random(in: -20...20)
             finalY += CGFloat.random(in: -20...20)
             
             // Check collision with existing numbers
             var hasCollision = false
             
             for existingNumber in existingNumbers {
                 let distance = sqrt(pow(finalX - existingNumber.x, 2) + pow(finalY - existingNumber.y, 2))
                 if distance < minDistance {
                     hasCollision = true
                     break
                 }
             }
             
             if !hasCollision {
                 finalRadius = radius // Store the successful radius
                 break // Found a good position
             }
             
             attempts += 1
             
         } while attempts < maxAttempts
         
         self.x = finalX
         self.y = finalY
        
        // Size varies with distance from center (larger at center, smaller at edges)
        let distanceFromCenter = finalRadius
        let sizeMultiplier = max(0.4, 1.0 - (distanceFromCenter / maxRadius))
        let baseSize = CGFloat.random(in: 48...72) // Large base size
        self.size = max(24.0, baseSize * sizeMultiplier)
        
        // Base opacity for edge-fade calculation
        self.maxOpacity = Double.random(in: 0.8...1.0)
        
        // Enhanced sacred color
        self.sacredColor = sacredColorForNumber(digit)
    }
    
    // MARK: - Refined Opacity Calculation
    func currentOpacity(at currentTime: Date, centerX: CGFloat, centerY: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) -> Double {
        let elapsed = currentTime.timeIntervalSince(birthTime)
        
        // PRECISE LIFECYCLE: 0.2s fade-in, 1.2s visible, 0.6s fade-out (total 2.0s)
        let fadeInDuration: Double = 0.2
        let visibleDuration: Double = 1.2
        let fadeOutStart: Double = fadeInDuration + visibleDuration // 1.4s
        let totalLifetime: Double = 2.0
        
        var lifecycleOpacity: Double
        if elapsed < fadeInDuration {
            // Quick fade in
            lifecycleOpacity = elapsed / fadeInDuration
        } else if elapsed < fadeOutStart {
            // Fully visible period
            lifecycleOpacity = 1.0
        } else if elapsed < totalLifetime {
            // Fade out
            let fadeOutProgress = (elapsed - fadeOutStart) / (totalLifetime - fadeOutStart)
            lifecycleOpacity = 1.0 - fadeOutProgress
        } else {
            // Expired
            lifecycleOpacity = 0.0
        }
        
        // EDGE-FADE GRADIENT: Full opacity at center, diminishing toward edges
        let distanceFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2))
        let maxRadius = sqrt(pow(screenWidth / 2, 2) + pow(screenHeight / 2, 2))
        let distanceRatio = min(1.0, distanceFromCenter / maxRadius)
        
        // Smooth gradient with gentle falloff
        let edgeFadeMultiplier = max(0.1, 1.0 - pow(distanceRatio, 0.8)) // Gentler falloff
        
        // Combine lifecycle and distance-based opacity
        let finalOpacity = maxOpacity * lifecycleOpacity * edgeFadeMultiplier
        
        return max(0.0, min(1.0, finalOpacity))
    }
}

// MARK: - Enhanced Sacred Color Mapping
private func sacredColorForNumber(_ number: Int) -> Color {
    switch number {
    case 1: return Color(red: 1.0, green: 0.3, blue: 0.3) // Vibrant red - Leadership
    case 2: return Color(red: 1.0, green: 0.7, blue: 0.2) // Warm orange - Harmony
    case 3: return Color(red: 1.0, green: 1.0, blue: 0.4) // Bright yellow - Creativity
    case 4: return Color(red: 0.2, green: 0.9, blue: 0.4) // Fresh green - Stability
    case 5: return Color(red: 0.3, green: 0.7, blue: 1.0) // Sky blue - Freedom
    case 6: return Color(red: 0.6, green: 0.3, blue: 1.0) // Rich indigo - Nurturing
    case 7: return Color(red: 0.9, green: 0.3, blue: 1.0) // Deep violet - Spirituality
    case 8: return Color(red: 1.0, green: 0.8, blue: 0.2) // Golden - Power
    case 9: return Color(red: 0.95, green: 0.95, blue: 1.0) // Pure white - Completion
    default: return Color.white
    }
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

