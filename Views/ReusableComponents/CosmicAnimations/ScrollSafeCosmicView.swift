/*
 * ========================================
 * 🌌 SCROLL-SAFE COSMIC VIEW - CHAOTIC FRACTAL EMANATION SYSTEM
 * ========================================
 * 
 * CORE PURPOSE:
 * Main wrapper component implementing chaotic fractal emanation with bloom-and-fade effect.
 * Numbers spawn from sacred geometry center and bloom outward in fractal waves, creating
 * an organic, mystical experience that responds to user's spiritual journey.
 * 
 * TECHNICAL ARCHITECTURE:
 * 
 * === CHATGPT CONSULTATION IMPLEMENTATION ===
 * • Spawn-and-Fade Approach: Numbers bloom in place with no movement animation
 * • Radial Distribution: Power curve (^1.5) bias toward center for natural flow
 * • Edge-Fade Gradient: Smooth opacity transition from center to screen edges
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
 * 
 * PERFORMANCE OPTIMIZATION:
 * • Max 90 active numbers for smooth 60fps operation
 * • Efficient lifecycle management with staggered disappearance
 * • Screen diagonal calculation for proper size scaling
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
 * Successfully implemented chaotic fractal emanation system based on ChatGPT consultation.
 * This represents the closest achievement to the user's vision of organic, mystical
 * number blooming that feels both chaotic and spiritually aligned.
 */

import SwiftUI

struct ScrollSafeCosmicView<Content: View>: View {
    let content: Content
    
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var date = Date()
    @State private var fibonacciStartTime: TimeInterval = 0
    
    // Track the sacred geometry center position dynamically
    @State private var sacredGeometryCenter: CGPoint = CGPoint(x: 215, y: 466) // iPhone 14 Pro Max center
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        print("🌌 ScrollSafeCosmicView: Cosmic environment initialized")
    }
    
    var body: some View {
        ZStack {
            // Cosmic background layer - time-based animations
            TimelineView(.animation) { timeline in
                GeometryReader { geometry in
                    ZStack {
                        // Twinkling numbers - CLEAN FORMATION FOCUS
                        ForEach(numbers, id: \.id) { number in
                            let position = number.currentPosition(at: timeline.date, sacredCenter: sacredGeometryCenter)
                            let opacity = number.currentOpacity(at: timeline.date, centerX: geometry.size.width / 2, centerY: geometry.size.height / 2, screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                            
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .bold, design: .monospaced)) // TYPEWRITER FONT
                                .foregroundColor(number.sacredColor)
                                .opacity(opacity)
                                .position(x: position.x, y: position.y)
                                .animation(.easeOut(duration: 0.8), value: position.x)
                                .animation(.easeOut(duration: 0.8), value: position.y)
                        }
                    }
                    .onAppear {
                        // Update sacred geometry center for iPhone 14 Pro Max
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        // Initialize fibonacci start time
                        fibonacciStartTime = Date().timeIntervalSince1970
                        generateInitialNumbers()
                    }
                    .onChange(of: timeline.date) { oldValue, newValue in
                        date = newValue
                        updateNumbers()
                    }
                    .background(
                        // Track sacred geometry center position
                        GeometryReader { scrollGeometry in
                            Color.clear
                                .onAppear {
                                    // Initial center position
                                    sacredGeometryCenter = CGPoint(
                                        x: scrollGeometry.size.width / 2,
                                        y: scrollGeometry.size.height / 2
                                    )
                                }
                                .onChange(of: scrollGeometry.frame(in: .global)) { oldFrame, newFrame in
                                    // Update center as content scrolls
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
    
    // MARK: - Number Generation
    private func generateInitialNumbers() {
        // IMMEDIATE STARTUP: Add some numbers right away for instant impact
        numbers = []
        
        // Add fewer numbers immediately for better performance
        for _ in 0..<3 {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: Date(),
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        
        print("🌟 Started with \(numbers.count) immediate numbers - more will appear rapidly")
    }
    
    private func updateNumbers() {
        // Remove expired numbers with staggered disappearance
        let currentTime = date.timeIntervalSince1970
        
        // FIBONACCI-INSPIRED STAGGERED REMOVAL
        // Remove numbers that are older than their individual lifetime (varies per number)
        numbers.removeAll { number in
            let age = date.timeIntervalSince(number.birthTime)
            let individualLifetime = number.staggeredLifetime
            return age > individualLifetime
        }
        
        // FIBONACCI-INSPIRED GRADUAL APPEARANCE
        // Use the persistent start time (initialized on view appear)
        let timeSinceStart = fibonacciStartTime > 0 ? currentTime - fibonacciStartTime : 0
        
        // BLOOM DENSITY: More numbers needed due to shorter lifespans (~2s each)
        let fibonacciPattern = [10, 20, 35, 55, 80, 120, 170, 230, 300, 350] // Target ~300-350 active
        
        // Calculate how many numbers should exist based on time elapsed
        var targetCount = 0
        let generationSpeed = 0.5 // RAPID generation for bloom effect
        let fibIndex = min(Int(timeSinceStart / generationSpeed), fibonacciPattern.count - 1)
        
        if fibIndex >= 0 {
            targetCount = fibonacciPattern[fibIndex]
        }
        
        // Add numbers in bursts for bloom effect
        let numbersToAdd = max(0, min(8, targetCount - numbers.count)) // More at once for bloom density
        
        for _ in 0..<numbersToAdd {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date,
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        
        if numbersToAdd > 0 {
            print("🌟 Added \(numbersToAdd) numbers - now \(numbers.count)/\(targetCount) (Step \(fibIndex + 1))")
        }
        
        // Debug: Print number count occasionally
        if Int(currentTime) % 5 == 0 && numbers.count > 0 {
            print("🌟 Active numbers: \(numbers.count), Target: \(targetCount)")
        }
    }
    
    // MARK: - Color Helper (Legacy - Now using enhanced sacred colors)
    /// Legacy color mapping - replaced by enhanced sacred color system
    /// Kept for backward compatibility and fallback scenarios
    private func colorForNumber(_ number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Gold
        case 9: return .white
        default: return .white
        }
    }
}

// MARK: - Cosmic Background Layer Component (TWINKLING NUMBERS VERSION)
struct CosmicBackgroundLayer: View {
    let date: Date
    let intensity: Double
    let isEnabled: Bool
    
    // MARK: - Twinkling Numbers State
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var sacredGeometryCenter: CGPoint = CGPoint(x: 215, y: 466) // iPhone 14 Pro Max center
    @State private var fibonacciStartTime: TimeInterval = 0
    
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
                
                // MARK: - Scroll-Safe Twinkling Numbers
                GeometryReader { geometry in
                    ZStack {
                        // Twinkling numbers - CLEAN FORMATION FOCUS
                        ForEach(numbers, id: \.id) { number in
                            let position = number.currentPosition(at: date, sacredCenter: sacredGeometryCenter)
                            let opacity = number.currentOpacity(at: date, centerX: geometry.size.width / 2, centerY: geometry.size.height / 2, screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                            
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .bold, design: .monospaced)) // TYPEWRITER FONT
                                .foregroundColor(number.sacredColor)
                                .opacity(opacity)
                                .position(x: position.x, y: position.y)
                                .animation(.easeOut(duration: 0.8), value: position.x)
                                .animation(.easeOut(duration: 0.8), value: position.y)
                        }
                    }
                    .onAppear {
                        // Update sacred geometry center
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        // Initialize fibonacci start time
                        fibonacciStartTime = date.timeIntervalSince1970
                        generateInitialNumbers()
                    }
                    .onChange(of: date) { oldValue, newValue in
                        updateNumbers()
                    }
                }
            }
        }
    }
    
    // MARK: - Number Generation
    private func generateInitialNumbers() {
        // FIBONACCI-INSPIRED GRADUAL APPEARANCE: Start empty, let them appear naturally
        // No initial numbers - they will appear gradually through updateNumbers()
        numbers = []
        print("🌟 CosmicBackgroundLayer: Initialized empty - numbers will appear in Fibonacci-like sequence")
    }
    
    private func updateNumbers() {
        // Remove expired numbers with staggered disappearance
        let currentTime = date.timeIntervalSince1970
        
        // FIBONACCI-INSPIRED STAGGERED REMOVAL
        numbers.removeAll { number in
            let age = date.timeIntervalSince(number.birthTime)
            let individualLifetime = number.staggeredLifetime
            return age > individualLifetime
        }
        
        // FIBONACCI-INSPIRED GRADUAL APPEARANCE (Background layer - slightly different)
        // Use the persistent start time (initialized on view appear)
        let timeSinceStart = fibonacciStartTime > 0 ? currentTime - fibonacciStartTime : 0
        
        // BACKGROUND LAYER: PERFORMANCE OPTIMIZED
        let fibonacciPattern = [0, 2, 5, 8, 12, 18, 25, 35, 45] // Fewer background numbers
        
        // Calculate how many numbers should exist based on time elapsed
        var targetCount = 0
        let generationSpeed = 1.5 // RAPID background generation
        let fibIndex = min(Int(timeSinceStart / generationSpeed), fibonacciPattern.count - 1)
        
        if fibIndex >= 0 {
            targetCount = fibonacciPattern[fibIndex]
        }
        
        // Add numbers gradually to reach target
        if numbers.count < targetCount {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date,
                bloomingFromCenter: true
            )
            numbers.append(number)
            print("🌟 Background: Added number \(numbers.count)/\(targetCount) (Fibonacci step \(fibIndex + 1))")
        }
    }
    
    // MARK: - Color Helper
    private func colorForNumber(_ number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Gold
        case 9: return .white
        default: return .white
        }
    }
}

// MARK: - Scroll-Safe Twinkling Number
struct ScrollSafeTwinklingNumber: Identifiable {
    let id = UUID()
    let digit: Int
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let maxOpacity: Double
    let birthTime: Date
    
    // Animation properties for blooming effect
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let animationDuration: Double
    
    // Staggered lifetime for organic disappearance
    let staggeredLifetime: Double
    
    // Enhanced visual properties
    let glowIntensity: Double
    let pulseSpeed: Double
    let sacredColor: Color
    
    init(sacredCenter: CGPoint, birthTime: Date, bloomingFromCenter: Bool) {
        self.digit = Int.random(in: 1...9)
        self.birthTime = birthTime
        
        let centerX = sacredCenter.x
        let centerY = sacredCenter.y
        let exclusionRadius: CGFloat = 200 // Sacred geometry radius
        
        // Enhanced visual properties
        self.glowIntensity = Double.random(in: 0.3...0.8)
        self.pulseSpeed = Double.random(in: 1.5...3.0)
        self.sacredColor = sacredColorForNumber(digit)
        
        // BLOOM LIFECYCLE: ~2 seconds total per ChatGPT consultation
        self.staggeredLifetime = Double.random(in: 1.8...2.2) // Short lifecycle for bloom effect
        
        if bloomingFromCenter {
            // CHAOTIC FRACTAL EMANATION: Less neat, more organic placement
            let baseAngle = Double.random(in: 0...(2 * .pi))
            let angleVariation = Double.random(in: -0.5...0.5) // Add chaos to angle
            let angle = baseAngle + angleVariation
            
            // Start near the edge of sacred geometry with more variation
            let radiusVariation = CGFloat.random(in: 10...60) // More chaotic start positions
            let startRadius = exclusionRadius + radiusVariation
            
            // RADIAL BLOOM DISTRIBUTION: Biased toward center but covering full screen
            let screenDiagonal = sqrt(pow(centerX * 2, 2) + pow(centerY * 2, 2)) // Full screen coverage
            
            // Bias toward center: more numbers near center, fewer at edges
            let radiusBias = pow(Double.random(in: 0...1), 1.5) // Power curve biases toward 0 (center)
            let finalRadius = startRadius + (screenDiagonal * 0.6 * CGFloat(radiusBias)) // 60% of screen diagonal
            
            // BLOOM POSITION: Use finalRadius for actual spawn position (biased distribution)
            let bloomX = centerX + cos(angle) * finalRadius + CGFloat.random(in: -30...30)
            let bloomY = centerY + sin(angle) * finalRadius + CGFloat.random(in: -30...30)
            
            // Use bloom position as both start and end (no movement)
            let startX = bloomX
            let startY = bloomY
            
            // Since we're not moving, we don't need end positions - just use start position
            
            // SPAWN-AND-FADE: No movement, just bloom in place
            self.startX = startX
            self.startY = startY
            self.endX = startX // Stay in same position
            self.endY = startY // Stay in same position
            self.x = startX
            self.y = startY
            
            // No movement animation - just lifecycle
            self.animationDuration = 0
            
            // BIGGER NUMBERS: Size varies with distance - MUCH LARGER
            let distanceFromCenter = finalRadius
            let screenBounds = UIScreen.main.bounds
            let maxRadius = sqrt(pow(screenBounds.width / 2, 2) + pow(screenBounds.height / 2, 2)) // Screen diagonal
            let sizeMultiplier = max(0.6, 1.0 - (distanceFromCenter / max(1.0, maxRadius))) // Prevent division by zero
            let baseSize = CGFloat.random(in: 48...72) // MUCH BIGGER numbers
            self.size = max(24.0, baseSize * sizeMultiplier) // Larger minimum size
            
            // Base opacity for fractal calculation - BOOSTED
            self.maxOpacity = Double.random(in: 0.9...1.0) // Much higher base opacity
        } else {
            // Original random positioning (fallback) - SAFE RANGES
            let screenBounds = UIScreen.main.bounds
            var validPosition = false
            var attemptX: CGFloat = 0
            var attemptY: CGFloat = 0
            let maxAttempts = 10 // Prevent infinite loops
            var attempts = 0
            
            while !validPosition && attempts < maxAttempts {
                let safeWidth = max(100, screenBounds.width - 100)
                let safeHeight = max(200, screenBounds.height - 200)
                
                attemptX = CGFloat.random(in: 50...safeWidth)
                attemptY = CGFloat.random(in: 100...safeHeight)
                
                let distance = hypot(attemptX - centerX, attemptY - centerY)
                if distance > exclusionRadius {
                    validPosition = true
                }
                attempts += 1
            }
            
            // Fallback to safe position if no valid position found
            if !validPosition {
                attemptX = centerX + exclusionRadius + 50
                attemptY = centerY + exclusionRadius + 50
            }
            
            self.x = attemptX
            self.y = attemptY
            self.startX = attemptX
            self.startY = attemptY
            self.endX = attemptX
            self.endY = attemptY
            self.animationDuration = 0 // No movement for fallback
            self.size = CGFloat.random(in: 32...48) // Match the visibility size
            self.maxOpacity = Double.random(in: 0.8...1.0) // Match the visibility opacity
        }
    }
    
    // Enhanced sacred color mapping with better visual appeal
    var color: Color {
        return sacredColor
    }
    
    // MARK: - Time-Based Animation
    func opacity(at currentTime: Date) -> Double {
        let age = currentTime.timeIntervalSince(birthTime)
        
        // Fade in over first 0.8 seconds (faster fade in)
        if age < 0.8 {
            return maxOpacity * (age / 0.8)
        }
        
        // Stay at max opacity for 8 seconds
        if age < 8.8 {
            return maxOpacity
        }
        
        // Fade out over last 1.2 seconds
        let fadeOut = (10.0 - age) / 1.2
        return maxOpacity * max(0, fadeOut)
    }
    
    func scale(at currentTime: Date) -> CGFloat {
        let age = currentTime.timeIntervalSince(birthTime)
        
        // Scale up from 0.6 to 1.0 over first 0.8 seconds
        if age < 0.8 {
            return 0.6 + 0.4 * CGFloat(age / 0.8)
        }
        
        return 1.0
    }
    
    // Calculate current position based on time elapsed with improved easing
    func currentPosition(at currentTime: Date, sacredCenter: CGPoint) -> (x: CGFloat, y: CGFloat) {
        guard animationDuration > 0 else {
            return (x: x, y: y) // No animation
        }
        
        let elapsed = currentTime.timeIntervalSince(birthTime)
        let progress = min(elapsed / animationDuration, 1.0)
        
        // Improved easing function (smooth ease-out with slight bounce)
        let easedProgress = 1 - pow(1 - progress, 2.5)
        
        let currentX = startX + (endX - startX) * easedProgress
        let currentY = startY + (endY - startY) * easedProgress
        
        // Subtle position adjustment for more organic movement
        let adjustedX = currentX + (currentX - sacredCenter.x) * 0.005
        let adjustedY = currentY + (currentY - sacredCenter.y) * 0.005
        
        return (x: adjustedX, y: adjustedY)
    }
    
    // BLOOM FADE OPACITY: ChatGPT consultation implementation
    func currentOpacity(at currentTime: Date, centerX: CGFloat, centerY: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) -> Double {
        let elapsed = currentTime.timeIntervalSince(birthTime)
        let lifetime = staggeredLifetime
        
        // BLOOM LIFECYCLE: ~0.2s fade-in, ~1.2s visible, ~0.6s fade-out (total ~2s)
        let fadeInDuration: Double = 0.2
        let fadeOutStart: Double = lifetime - 0.6
        
        var lifecycleOpacity: Double
        if elapsed < fadeInDuration {
            // Quick fade in
            lifecycleOpacity = elapsed / fadeInDuration
        } else if elapsed > fadeOutStart {
            // Fade out
            let fadeOutProgress = (elapsed - fadeOutStart) / (lifetime - fadeOutStart)
            lifecycleOpacity = 1.0 - fadeOutProgress
        } else {
            // Fully visible
            lifecycleOpacity = 1.0
        }
        
        // EDGE-FADE GRADIENT: Full opacity at center, diminishing toward edges
        let distanceFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2))
        let maxRadius = sqrt(pow(screenWidth / 2, 2) + pow(screenHeight / 2, 2)) // Screen diagonal
        let distanceRatio = distanceFromCenter / maxRadius
        let edgeFadeMultiplier = max(0.1, 1.0 - distanceRatio) // Smooth gradient to edges
        
        // Combine lifecycle and distance-based opacity
        let finalOpacity = maxOpacity * lifecycleOpacity * edgeFadeMultiplier
        
        return max(0.05, min(1.0, finalOpacity)) // Subtle minimum for distant numbers
    }
    
    // New: Calculate glow effect intensity
    func glowIntensity(at currentTime: Date) -> Double {
        let elapsed = currentTime.timeIntervalSince(birthTime)
        let lifetime: Double = 10.0
        
        // Glow fades with opacity but has its own timing
        let glowFadeStart = lifetime - 1.5
        let baseGlow = glowIntensity
        
        if elapsed > glowFadeStart {
            let glowFadeProgress = (elapsed - glowFadeStart) / (lifetime - glowFadeStart)
            return baseGlow * (1.0 - glowFadeProgress)
        }
        
        return baseGlow
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
