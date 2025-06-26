import SwiftUI

/**
 * TwinklingDigitsBackground: Ultra-maximum cosmic background with extreme density
 * 
 * Features:
 * 1. 8x number density for ultra-maximum cosmic atmosphere (320 active numbers)
 * 2. Typewriter font for authentic mystical feeling
 * 3. Ultra-dense emanation pattern from center outward in 10 tight concentric rings
 * 4. Enhanced protection of focus areas (200px radius)
 * 5. Subtle glittering animation for mystical effect
 * 6. Ultra-light transparency for perfect background blending
 * 7. Lightning-fast performance with 0.8s generation cycles
 * 8. Ultra-close positioning (45px minimum distance)
 */
struct TwinklingDigitsBackground: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @EnvironmentObject var activityNavigationManager: ActivityNavigationManager
    
    // Procedural generation state
    @State private var activeNumbers: [TwinklingNumber] = []
    @State private var generationTimer: Timer?
    @State private var cleanupTimer: Timer?
    @State private var emanationPhase: Double = 0
    
    // Screen dimensions for procedural generation
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            // iOS-native cosmic gradient
            cosmicGradient
            
            // Enhanced emanating particles
            enhancedEmanatingParticles
        }
        .onAppear {
            // Delay start to prevent initial state modification warnings
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startProceduralGeneration()
            }
        }
        .onDisappear {
            stopProceduralGeneration()
        }
    }
    
    // MARK: - iOS-Native Cosmic Gradient
    
    private var cosmicGradient: some View {
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
    }
    
    // MARK: - Enhanced Emanating Particles
    
    private var enhancedEmanatingParticles: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            let focusAreaRadius: CGFloat = 200 // Increased protected center area
            
            // Update screen dimensions when geometry changes
            let _ = updateScreenDimensions(geometry.size)
            
            ZStack {
                ForEach(activeNumbers, id: \.id) { number in
                    let distanceFromCenter = sqrt(pow(number.x - centerX, 2) + pow(number.y - centerY, 2))
                    let proximityFactor = min(distanceFromCenter / focusAreaRadius, 1.0)
                    let adjustedOpacity = number.currentOpacity * Double(proximityFactor) * 0.9
                    
                    Text("\(number.digit)")
                        .font(.system(size: number.size, weight: .medium, design: .monospaced)) // Typewriter font
                        .foregroundColor(number.color)
                        // Lighter multi-layer glow effects for better blending
                        .shadow(color: number.color.opacity(0.6), radius: number.glowRadius * 1.5, x: 0, y: 0)
                        .shadow(color: number.color.opacity(0.4), radius: number.glowRadius, x: 0, y: 0)
                        .shadow(color: number.color.opacity(0.2), radius: number.glowRadius * 0.5, x: 0, y: 0)
                        .shadow(color: .white.opacity(0.2), radius: 2, x: 0, y: 0)
                        // Lighter transparency with proximity adjustment and glittering
                        .opacity(adjustedOpacity * number.glitterMultiplier)
                        .scaleEffect(number.currentScale)
                        .position(x: number.x, y: number.y)
                        // Enhanced lifecycle animation with glittering
                        .onAppear {
                            // Async to prevent state modification during view update
                            DispatchQueue.main.async {
                                animateNumberLifecycle(number)
                                startGlitterAnimation(number)
                            }
                        }
                }
            }
        }
    }
    
    // MARK: - Enhanced Generation System
    
    private func startProceduralGeneration() {
        // Faster generation for double the density
        startNumberGeneration()
        
        // Enhanced cleanup system
        startNumberCleanup()
        
        // Start emanation phase animation
        startEmanationPhase()
        
        print("🌟 Started enhanced emanating cosmic generation")
    }
    
    private func stopProceduralGeneration() {
        generationTimer?.invalidate()
        cleanupTimer?.invalidate()
        generationTimer = nil
        cleanupTimer = nil
        
        print("🛑 Stopped procedural generation")
    }
    
    private func startNumberGeneration() {
        // Ultra-lightning-fast generation for extreme cosmic density (0.8s for 320 numbers)
        generationTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            // Async to prevent state modification warnings
            DispatchQueue.main.async {
                generateRandomNumbers()
            }
        }
    }
    
    private func startEmanationPhase() {
        // Continuous emanation phase for outward flow
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.1)) {
                    emanationPhase += 0.05
                    if emanationPhase > 2 * Double.pi {
                        emanationPhase = 0
                    }
                }
            }
        }
    }
    
    private func generateRandomNumbers() {
        // Ultra-maximum cosmic density - extreme number generation (16-32 numbers)
        let numbersToGenerate = Int.random(in: 16...32)
        
        for i in 0..<numbersToGenerate {
            // Randomized spawning to prevent synchronized appearance
            let baseDelay = Double(i) * 0.08
            let randomVariation = Double.random(in: 0.0...0.12) // Add random variation
            let spawnDelay = baseDelay + randomVariation
            
            DispatchQueue.main.asyncAfter(deadline: .now() + spawnDelay) {
                self.spawnEmanatingNumber()
            }
        }
        
        // Ultra-massive active number limit for extreme atmosphere (320 instead of 240)
        if activeNumbers.count > 320 {
            DispatchQueue.main.async {
                removeOldestNumbers()
            }
        }
    }
    
    private func spawnEmanatingNumber() {
        // Enhanced emanation pattern with better spacing
        var attempts = 0
        var validPosition = false
        var newNumber: TwinklingNumber
        
        repeat {
            newNumber = TwinklingNumber(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                isMatchMode: false,
                matchDigit: 1,
                isProcedural: true,
                emanationPhase: emanationPhase,
                subtleTransparency: true,
                gentle: true,
                enhanced: true
            )
            
            // Check if this position is valid
            validPosition = isValidEmanationPosition(newNumber)
            attempts += 1
            
        } while !validPosition && attempts < 20 // More attempts for better positioning
        
        // Only add if we found a valid position
        if validPosition {
            // Enhanced state update with better animation
            DispatchQueue.main.async {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.activeNumbers.append(newNumber)
                }
            }
        }
    }
    
    private func startNumberCleanup() {
        // Frequent cleanup for 2-second lifespans (1.0 second intervals)
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                cleanupExpiredNumbers()
            }
        }
    }
    
    private func cleanupExpiredNumbers() {
        let currentTime = Date()
        let expiredNumbers = activeNumbers.filter { number in
            currentTime.timeIntervalSince(number.birthTime) > number.lifespan
        }
        
        for expiredNumber in expiredNumbers {
            removeNumberWithFadeOut(expiredNumber)
        }
    }
    
    private func removeNumberWithFadeOut(_ number: TwinklingNumber) {
        // Find the number and fade it out gracefully
        if let index = activeNumbers.firstIndex(where: { $0.id == number.id }) {
            withAnimation(.easeOut(duration: 0.8)) { // Slower fade-out for smoother transition
                activeNumbers[index].currentOpacity = 0.0
                activeNumbers[index].currentScale = 0.3
            }
            
            // Remove after fade animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                activeNumbers.removeAll { $0.id == number.id }
            }
        }
    }
    
    private func animateNumberLifecycle(_ number: TwinklingNumber) {
        // Staggered lifecycle animation to prevent synchronized blinking
        // Phase 1: Randomized fade-in timing to prevent synchronization
        let fadeInDelay = Double.random(in: 0.0...0.4) // Random delay before fade-in
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeInDelay) {
            if let currentIndex = activeNumbers.firstIndex(where: { $0.id == number.id }) {
                withAnimation(.spring(response: Double.random(in: 0.4...0.8), dampingFraction: 0.8, blendDuration: 0)) {
                    activeNumbers[currentIndex].currentOpacity = activeNumbers[currentIndex].maxOpacity
                    activeNumbers[currentIndex].currentScale = 1.0
                }
            }
        }
        
        // Phase 2: Randomized transparency easing for organic flow
        let transparencyDelay = Double.random(in: 0.8...1.6) // More random timing
        DispatchQueue.main.asyncAfter(deadline: .now() + transparencyDelay) {
            if let currentIndex = activeNumbers.firstIndex(where: { $0.id == number.id }) {
                withAnimation(.easeInOut(duration: Double.random(in: 0.8...1.8))) {
                    activeNumbers[currentIndex].currentOpacity = activeNumbers[currentIndex].maxOpacity * Double.random(in: 0.3...0.5) // Varied final opacity
                }
            }
        }
    }
    
    private func startGlitterAnimation(_ number: TwinklingNumber) {
        // Subtle glittering effect for mystical atmosphere
        if activeNumbers.contains(where: { $0.id == number.id }) {
            let glitterDelay = Double.random(in: 0.5...2.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + glitterDelay) {
                self.performGlitterCycle(number)
            }
        }
    }
    
    private func performGlitterCycle(_ number: TwinklingNumber) {
        if let index = activeNumbers.firstIndex(where: { $0.id == number.id }) {
            // Subtle glitter pulse
            withAnimation(.easeInOut(duration: Double.random(in: 0.6...1.2))) {
                activeNumbers[index].glitterMultiplier = Double.random(in: 1.2...1.8)
            }
            
            // Return to normal
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.8...1.5)) {
                if let currentIndex = activeNumbers.firstIndex(where: { $0.id == number.id }) {
                    withAnimation(.easeInOut(duration: Double.random(in: 0.8...1.4))) {
                        activeNumbers[currentIndex].glitterMultiplier = 1.0
                    }
                    
                    // Schedule next glitter cycle
                    let nextGlitterDelay = Double.random(in: 2.0...5.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + nextGlitterDelay) {
                        self.performGlitterCycle(number)
                    }
                }
            }
        }
    }
    
    private func updateScreenDimensions(_ size: CGSize) {
        // Async update to prevent state modification warnings
        DispatchQueue.main.async {
            screenWidth = size.width
            screenHeight = size.height
        }
    }
    
    // MARK: - Enhanced Spacing Logic
    
    private func isValidEmanationPosition(_ newNumber: TwinklingNumber) -> Bool {
        let minimumDistance: CGFloat = 45 // Ultra-close together for extreme dense expansion
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        let distanceFromCenter = sqrt(pow(newNumber.x - centerX, 2) + pow(newNumber.y - centerY, 2))
        
        // Ensure minimum distance from center (protection zone)
        if distanceFromCenter < 200 {
            return false
        }
        
        // Check spacing from other numbers - allow ultra-close positioning
        for existingNumber in activeNumbers {
            let distance = sqrt(pow(newNumber.x - existingNumber.x, 2) + pow(newNumber.y - existingNumber.y, 2))
            if distance < minimumDistance {
                return false
            }
        }
        
        return true
    }
    
    private func removeOldestNumbers() {
        // Ultra-maximum density management for 320 active numbers
        activeNumbers.sort { $0.birthTime < $1.birthTime }
        let toRemove = Array(activeNumbers.prefix(16)) // Remove even more at once for 320-number flow
        
        for (index, number) in toRemove.enumerated() {
            // Randomized removal timing to prevent synchronized disappearance
            let baseDelay = Double(index) * 0.12
            let randomVariation = Double.random(in: 0.0...0.2) // Add random variation
            let removeDelay = baseDelay + randomVariation
            
            DispatchQueue.main.asyncAfter(deadline: .now() + removeDelay) {
                self.removeNumberWithFadeOut(number)
            }
        }
    }
}

// MARK: - Enhanced TwinklingNumber with Emanation

struct TwinklingNumber {
    let id = UUID()
    let digit: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let maxOpacity: Double
    let maxScale: CGFloat
    let glowRadius: CGFloat
    let animationDuration: Double
    let animationDelay: Double
    
    // Procedural generation properties
    let birthTime: Date
    let lifespan: TimeInterval
    
    // Current animated values
    var currentOpacity: Double
    var currentScale: CGFloat
    var glitterMultiplier: Double
    
    init(screenWidth: CGFloat, screenHeight: CGFloat, isMatchMode: Bool = false, matchDigit: Int = 1, isProcedural: Bool = false, emanationPhase: Double = 0, subtleTransparency: Bool = false, gentle: Bool = false, enhanced: Bool = false) {
        if isMatchMode {
            self.digit = matchDigit
        } else {
            self.digit = Int.random(in: 1...9)
        }
        
        // Enhanced emanation positioning from center outward
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        let calculatedPosition: (x: CGFloat, y: CGFloat)
        
        if enhanced {
            // Create ultra-dense emanation pattern with super-tight rings
            let ringIndex = Int.random(in: 0...9) // 10 different emanation rings for extreme density
            let baseRadius = 205 + (CGFloat(ringIndex) * 40) // Super-tight rings: 205, 245, 285, 325, 365, 405, 445, 485, 525, 565
            let angleVariation = emanationPhase + Double.random(in: 0...(2 * Double.pi)) // Use emanation phase
            
            // Minimal randomness for ultra-tight formation
            let radiusVariation = CGFloat.random(in: -15...15)
            let finalRadius = baseRadius + radiusVariation
            
            let rawX = centerX + cos(angleVariation) * finalRadius
            let rawY = centerY + sin(angleVariation) * finalRadius
            
            // Clamp to screen bounds with margins
            calculatedPosition = (
                x: min(max(rawX, 30), screenWidth - 30),
                y: min(max(rawY, 100), screenHeight - 100)
            )
        } else {
            // Fallback to edge positioning
            let positionChoice = Int.random(in: 0...3)
            switch positionChoice {
            case 0: // Top edge
                calculatedPosition = (
                    x: CGFloat.random(in: 40...(screenWidth - 40)),
                    y: CGFloat.random(in: 80...200)
                )
            case 1: // Left edge
                calculatedPosition = (
                    x: CGFloat.random(in: 40...120),
                    y: CGFloat.random(in: 100...(screenHeight - 150))
                )
            case 2: // Right edge
                calculatedPosition = (
                    x: CGFloat.random(in: (screenWidth - 120)...(screenWidth - 40)),
                    y: CGFloat.random(in: 100...(screenHeight - 150))
                )
            case 3: // Bottom edge
                calculatedPosition = (
                    x: CGFloat.random(in: 40...(screenWidth - 40)),
                    y: CGFloat.random(in: (screenHeight - 200)...(screenHeight - 100))
                )
            default:
                calculatedPosition = (
                    x: CGFloat.random(in: 40...(screenWidth - 40)),
                    y: CGFloat.random(in: 80...200)
                )
            }
        }
        
        // Assign the calculated position once
        self.x = calculatedPosition.x
        self.y = calculatedPosition.y
        
        // Enhanced sizing for better density
        if enhanced {
            self.size = CGFloat.random(in: 18...32) // Smaller for higher density
        } else if gentle {
            self.size = CGFloat.random(in: 22...38)
        } else {
            self.size = CGFloat.random(in: 26...42)
        }
        
        if subtleTransparency {
            if enhanced {
                // Much lighter transparency for perfect blending (reduced by ~50%)
                self.maxOpacity = Double.random(in: 0.15...0.35)
            } else if gentle {
                self.maxOpacity = Double.random(in: 0.2...0.4)
            } else {
                self.maxOpacity = Double.random(in: 0.25...0.45)
            }
        } else {
            self.maxOpacity = Double.random(in: 0.3...0.6)
        }
        
        if enhanced {
            self.maxScale = CGFloat.random(in: 0.85...1.2) // Subtle scaling for density
            self.glowRadius = CGFloat.random(in: 6...16) // Smaller glow for less overlap
        } else if gentle {
            self.maxScale = CGFloat.random(in: 0.9...1.3)
            self.glowRadius = CGFloat.random(in: 8...20)
        } else {
            self.maxScale = CGFloat.random(in: 0.95...1.5)
            self.glowRadius = CGFloat.random(in: 10...25)
        }
        
        // Enhanced animation durations
        if enhanced {
            self.animationDuration = Double.random(in: 0.6...1.2) // Faster for density
            self.animationDelay = Double.random(in: 0.0...0.3)
        } else if gentle {
            self.animationDuration = Double.random(in: 0.8...1.5)
            self.animationDelay = Double.random(in: 0.0...0.4)
        } else {
            self.animationDuration = Double.random(in: 0.5...1.0)
            self.animationDelay = Double.random(in: 0.0...0.2)
        }
        
        // Enhanced procedural generation properties with staggered timing
        self.birthTime = Date()
        if isProcedural {
            if enhanced {
                // Short lifespans with random variation to prevent synchronized blinking
                self.lifespan = TimeInterval.random(in: 1.5...2.5)
            } else if gentle {
                self.lifespan = TimeInterval.random(in: 2.0...3.0)
            } else {
                self.lifespan = TimeInterval.random(in: 1.8...2.8)
            }
        } else {
            self.lifespan = TimeInterval.random(in: 2.5...4.0)
        }
        
        // Start with minimal visibility
        self.currentOpacity = 0.0
        self.currentScale = 0.4
        self.glitterMultiplier = 1.0
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
}

// MARK: - Preview

#Preview {
    ZStack {
        TwinklingDigitsBackground()
            .environmentObject(FocusNumberManager.shared)
            .environmentObject(RealmNumberManager())
            .environmentObject(ActivityNavigationManager.shared)
    }
} 
