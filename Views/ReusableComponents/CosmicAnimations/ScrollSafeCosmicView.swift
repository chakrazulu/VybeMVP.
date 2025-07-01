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
    
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var date = Date()
    
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
                        // Twinkling numbers with sacred numerology colors
                        ForEach(numbers, id: \.id) { number in
                            let position = number.currentPosition(at: timeline.date, sacredCenter: sacredGeometryCenter)
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .medium, design: .rounded))
                                .foregroundColor(colorForNumber(number.digit))
                                .opacity(number.currentOpacity(at: timeline.date))
                                .position(x: position.x, y: position.y)
                                .animation(.easeOut(duration: 0.5), value: position.x)
                                .animation(.easeOut(duration: 0.5), value: position.y)
                        }
                    }
                    .onAppear {
                        // Update sacred geometry center for iPhone 14 Pro Max
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
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
        // Generate more initial numbers (25 instead of 15) for better visibility on iPhone 14 Pro Max
        for i in 0..<25 {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date.addingTimeInterval(-Double(i) * 0.3), // Closer stagger for more density
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        print("🌟 Generated \(numbers.count) initial twinkling numbers")
    }
    
    private func updateNumbers() {
        // Remove expired numbers (older than 10 seconds)
        numbers.removeAll { number in
            date.timeIntervalSince(number.birthTime) > 10.0
        }
        
        // More consistent number generation - add a new number every 1.5 seconds
        let currentTime = date.timeIntervalSince1970
        let timeSinceLastGeneration = currentTime - (numbers.last?.birthTime.timeIntervalSince1970 ?? 0)
        
        // Always maintain at least 20 numbers, add new ones every 1.5 seconds
        if numbers.count < 20 || timeSinceLastGeneration > 1.5 {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date,
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        
        // Limit to 80 active numbers for better performance and spacing
        if numbers.count > 80 {
            let numbersToRemove = numbers.count - 80
            numbers.removeFirst(numbersToRemove)
        }
        
        // Debug: Print number count to console
        if numbers.count > 0 {
            print("🌟 Active twinkling numbers: \(numbers.count)")
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

// MARK: - Cosmic Background Layer Component (TWINKLING NUMBERS VERSION)
struct CosmicBackgroundLayer: View {
    let date: Date
    let intensity: Double
    let isEnabled: Bool
    
    // MARK: - Twinkling Numbers State
    @State private var numbers: [ScrollSafeTwinklingNumber] = []
    @State private var sacredGeometryCenter: CGPoint = CGPoint(x: 215, y: 466) // iPhone 14 Pro Max center
    
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
                        // Twinkling numbers with sacred numerology colors
                        ForEach(numbers, id: \.id) { number in
                            let position = number.currentPosition(at: date, sacredCenter: sacredGeometryCenter)
                            Text("\(number.digit)")
                                .font(.system(size: number.size, weight: .medium, design: .rounded))
                                .foregroundColor(colorForNumber(number.digit))
                                .opacity(number.currentOpacity(at: date))
                                .position(x: position.x, y: position.y)
                                .animation(.easeOut(duration: 0.5), value: position.x)
                                .animation(.easeOut(duration: 0.5), value: position.y)
                        }
                    }
                    .onAppear {
                        // Update sacred geometry center
                        sacredGeometryCenter = CGPoint(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
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
        // Generate more initial numbers (30 instead of 20) for better visibility
        for i in 0..<30 {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date.addingTimeInterval(-Double(i) * 0.3), // Closer stagger for more density
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        print("🌟 CosmicBackgroundLayer: Generated \(numbers.count) initial twinkling numbers")
    }
    
    private func updateNumbers() {
        // Remove expired numbers (older than 12 seconds for longer life)
        numbers.removeAll { number in
            date.timeIntervalSince(number.birthTime) > 12.0
        }
        
        // Add new number every 1.5 seconds (faster emission)
        let timeSinceStart = date.timeIntervalSince1970
        let expectedNumbers = Int(timeSinceStart * 0.67) // Every 1.5 seconds
        
        if expectedNumbers > (numbers.count / 2) {
            let number = ScrollSafeTwinklingNumber(
                sacredCenter: sacredGeometryCenter,
                birthTime: date,
                bloomingFromCenter: true
            )
            numbers.append(number)
        }
        
        // Limit to 150 active numbers for better performance and spacing
        if numbers.count > 150 {
            let numbersToRemove = numbers.count - 150
            numbers.removeFirst(numbersToRemove)
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
    

    
    init(sacredCenter: CGPoint, birthTime: Date, bloomingFromCenter: Bool) {
        self.digit = Int.random(in: 1...9)
        self.birthTime = birthTime
        
        let centerX = sacredCenter.x
        let centerY = sacredCenter.y
        let exclusionRadius: CGFloat = 200 // Sacred geometry radius
        
        if bloomingFromCenter {
            // BLOOMING EFFECT: Spawn from edge of sacred center and move outward
            let angle = Double.random(in: 0...(2 * .pi))
            let startRadius = exclusionRadius + 20 // Start a bit further from sacred geometry
            let endRadius = min(centerX, centerY) * 1.2 // Move further toward screen edges
            
            // Start position (edge of sacred center)
            let startX = centerX + cos(angle) * startRadius
            let startY = centerY + sin(angle) * startRadius
            
            // End position (further out)
            let endX = centerX + cos(angle) * endRadius
            let endY = centerY + sin(angle) * endRadius
            
            // Store positions for animation
            self.startX = startX
            self.startY = startY
            self.endX = endX
            self.endY = endY
            self.x = startX
            self.y = startY
            self.animationDuration = Double.random(in: 8...12) // Slower bloom for better visibility
            
            // Much larger size and higher opacity for iPhone 14 Pro Max visibility
            self.size = CGFloat.random(in: 28...40) // Much larger for better visibility
            self.maxOpacity = Double.random(in: 0.7...0.95) // Much higher opacity for visibility
        } else {
            // Original random positioning (fallback)
            let screenBounds = UIScreen.main.bounds
            var validPosition = false
            var attemptX: CGFloat = 0
            var attemptY: CGFloat = 0
            
            while !validPosition {
                attemptX = CGFloat.random(in: 50...(screenBounds.width - 50))
                attemptY = CGFloat.random(in: 100...(screenBounds.height - 100))
                
                let distance = hypot(attemptX - centerX, attemptY - centerY)
                if distance > exclusionRadius {
                    validPosition = true
                }
            }
            
            self.x = attemptX
            self.y = attemptY
            self.startX = attemptX
            self.startY = attemptY
            self.endX = attemptX
            self.endY = attemptY
            self.animationDuration = 0 // No movement for fallback
            self.size = CGFloat.random(in: 28...40) // Match the blooming size
            self.maxOpacity = Double.random(in: 0.7...0.95) // Match the blooming opacity
        }
    }
    
    var color: Color {
        switch digit {
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
    
    // MARK: - Time-Based Animation
    func opacity(at currentTime: Date) -> Double {
        let age = currentTime.timeIntervalSince(birthTime)
        
        // Fade in over first 1 second
        if age < 1.0 {
            return maxOpacity * age
        }
        
        // Stay at max opacity for 8 seconds
        if age < 9.0 {
            return maxOpacity
        }
        
        // Fade out over last 1 second
        let fadeOut = (10.0 - age) / 1.0
        return maxOpacity * max(0, fadeOut)
    }
    
    func scale(at currentTime: Date) -> CGFloat {
        let age = currentTime.timeIntervalSince(birthTime)
        
        // Scale up from 0.5 to 1.0 over first 1 second
        if age < 1.0 {
            return 0.5 + 0.5 * CGFloat(age)
        }
        
        return 1.0
    }
    
    // Calculate current position based on time elapsed
    func currentPosition(at currentTime: Date, sacredCenter: CGPoint) -> (x: CGFloat, y: CGFloat) {
        guard animationDuration > 0 else {
            return (x: x, y: y) // No animation
        }
        
        let elapsed = currentTime.timeIntervalSince(birthTime)
        let progress = min(elapsed / animationDuration, 1.0)
        
        // Smooth easing function (ease-out)
        let easedProgress = 1 - pow(1 - progress, 3)
        
        let currentX = startX + (endX - startX) * easedProgress
        let currentY = startY + (endY - startY) * easedProgress
        
        // Adjust position based on sacred geometry center
        let adjustedX = currentX + (currentX - sacredCenter.x) * 0.01
        let adjustedY = currentY + (currentY - sacredCenter.y) * 0.01
        
        return (x: adjustedX, y: adjustedY)
    }
    
    // Calculate current opacity based on time elapsed (pulsing effect)
    func currentOpacity(at currentTime: Date) -> Double {
        let elapsed = currentTime.timeIntervalSince(birthTime)
        let lifetime: Double = 12.0 // Match the removal time
        
        // Fade in quickly, then pulse, then fade out
        let fadeInDuration: Double = 1.0
        let fadeOutStart: Double = lifetime - 2.0
        
        var baseOpacity: Double
        if elapsed < fadeInDuration {
            // Fade in
            baseOpacity = maxOpacity * (elapsed / fadeInDuration)
        } else if elapsed > fadeOutStart {
            // Fade out
            let fadeOutProgress = (elapsed - fadeOutStart) / (lifetime - fadeOutStart)
            baseOpacity = maxOpacity * (1.0 - fadeOutProgress)
        } else {
            // Full opacity
            baseOpacity = maxOpacity
        }
        
        // Add pulsing effect
        let pulseSpeed = 2.0 + Double(digit) * 0.3 // Different pulse rates per number
        let pulse = 1.0 + 0.3 * sin(elapsed * pulseSpeed)
        
        return max(0, baseOpacity * pulse)
    }
}

// MARK: - Sacred Color Mapping
private func colorForNumber(_ number: Int) -> Color {
    switch number {
    case 1: return Color(red: 1.0, green: 0.2, blue: 0.2) // Red - Leadership, independence
    case 2: return Color(red: 1.0, green: 0.6, blue: 0.0) // Orange - Cooperation, harmony
    case 3: return Color(red: 1.0, green: 1.0, blue: 0.0) // Yellow - Creativity, expression
    case 4: return Color(red: 0.0, green: 0.8, blue: 0.0) // Green - Stability, hard work
    case 5: return Color(red: 0.0, green: 0.6, blue: 1.0) // Blue - Freedom, adventure
    case 6: return Color(red: 0.4, green: 0.0, blue: 0.8) // Indigo - Nurturing, responsibility
    case 7: return Color(red: 0.8, green: 0.0, blue: 1.0) // Violet - Spirituality, introspection
    case 8: return Color(red: 1.0, green: 0.0, blue: 0.5) // Magenta - Material mastery, power
    case 9: return Color(red: 0.9, green: 0.9, blue: 0.9) // White - Universal love, completion
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
