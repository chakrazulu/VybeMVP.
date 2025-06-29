import SwiftUI

/**
 * TwinklingDigitsBackground: Simple cosmic background with twinkling numbers
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === OVERALL STRUCTURE ===
 * • Full screen ZStack with gradient + animated numbers
 * • Numbers spawn randomly except in center exclusion zone
 * • Performance optimized: Max 200 active numbers
 * • Lifecycle: 10 seconds per number
 * 
 * === COSMIC GRADIENT BACKGROUND ===
 * • Type: LinearGradient, full screen
 * • Colors: Black → Purple(30%) → Indigo(20%) → Black
 * • Direction: Top-left to bottom-right diagonal
 * • Behavior: Static (no animation)
 * 
 * === TWINKLING NUMBER SPECS ===
 * • Font: System monospaced, medium weight
 * • Size range: 20-30pt (random per number)
 * • Opacity range: 0.3-0.6 (random per number)
 * • Initial state: 0 opacity, 0.5 scale
 * • Animation: Fade in to max opacity, scale to 1.0
 * • Animation duration: 1.0s ease-in-out
 * • Lifetime: 10 seconds from creation
 * 
 * === SPAWN POSITIONING ===
 * • X range: 50pt to (screenWidth - 50pt)
 * • Y range: 100pt to (screenHeight - 100pt)
 * • Center exclusion: 200pt radius from screen center
 * • Fade zone: 40pt gradient near exclusion boundary
 * • Numbers in fade zone: Reduced opacity and size
 * 
 * === COLOR SYSTEM (1-9) ===
 * 1. Red (#FF0000)
 * 2. Orange (#FFA500)
 * 3. Yellow (#FFFF00)
 * 4. Green (#00FF00)
 * 5. Blue (#0000FF)
 * 6. Indigo (#4B0082)
 * 7. Purple (#800080)
 * 8. Gold (#FFD700)
 * 9. White (#FFFFFF)
 * 
 * === GENERATION TIMING ===
 * • Initial spawn: 30 numbers immediately
 * • New number: Every 2.0 seconds
 * • Cleanup check: Every 3.0 seconds
 * • Max active: 200 numbers (older removed if exceeded)
 * 
 * === PERFORMANCE OPTIMIZATIONS ===
 * • GeometryReader: Single instance for all numbers
 * • Timer-based generation (not frame-based)
 * • Automatic cleanup of expired numbers
 * • Limited max count prevents memory issues
 * 
 * === CENTER EXCLUSION ALGORITHM ===
 * • Exclusion radius: 200pt from center
 * • Retry logic: Keep generating until valid position
 * • Fade calculation: Linear 0→1 over 40pt zone
 * • Size reduction: 70% at boundary, 100% outside
 * 
 * === STATE MANAGEMENT ===
 * • activeNumbers: Array of TwinklingNumber structs
 * • generationTimer: 2.0s interval timer
 * • cleanupTimer: 3.0s interval timer
 * • Cleanup on disappear: All timers invalidated
 */
struct TwinklingDigitsBackground: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    @EnvironmentObject var activityNavigationManager: ActivityNavigationManager
    
    @State private var activeNumbers: [TwinklingNumber] = []
    @State private var generationTimer: Timer?
    @State private var cleanupTimer: Timer?
    
    var body: some View {
        ZStack {
            // Simple cosmic gradient
            cosmicGradient
            
            // Twinkling numbers
            twinklingNumbers
        }
        .onAppear {
            startSimpleGeneration()
        }
        .onDisappear {
            cleanupTimers()
        }
    }
    
    // MARK: - Simple Cosmic Gradient
    
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
    
    // MARK: - Twinkling Numbers
    
    private var twinklingNumbers: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(activeNumbers, id: \.id) { number in
                    Text("\(number.digit)")
                        .font(.system(size: number.size, weight: .medium, design: .monospaced))
                        .foregroundColor(number.color)
                        .opacity(number.currentOpacity)
                        .scaleEffect(number.currentScale)
                        .position(x: number.x, y: number.y)
                        .onAppear {
                            animateNumber(number)
                        }
                }
            }
        }
    }
    
    // MARK: - Simple Generation
    
    private func startSimpleGeneration() {
        // Generate initial numbers immediately
        generateInitialNumbers()
        
        // Start generation timer
        generationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            generateNewNumber()
            }
        
        // Start cleanup timer
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            cleanupOldNumbers()
        }
    }
    
    private func generateInitialNumbers() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 🎯 INITIAL SPAWN: 30 numbers for immediate visual impact
        for _ in 0..<30 {
            let number = TwinklingNumber(
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
            activeNumbers.append(number)
        }
    }
    
    private func generateNewNumber() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let number = TwinklingNumber(
            screenWidth: screenWidth,
            screenHeight: screenHeight
        )
        
        withAnimation(.easeInOut(duration: 0.8)) {
            activeNumbers.append(number)
        }
        
        // REVERT TO STEP 4: Limit to 200 active numbers (was 240)
        if activeNumbers.count > 200 {
            // Remove oldest numbers to maintain performance
            let numbersToRemove = activeNumbers.count - 200
            activeNumbers.removeFirst(numbersToRemove)
        }
    }
    
    private func animateNumber(_ number: TwinklingNumber) {
        if let index = activeNumbers.firstIndex(where: { $0.id == number.id }) {
            withAnimation(.easeInOut(duration: 1.0)) {
                activeNumbers[index].currentOpacity = activeNumbers[index].maxOpacity
                activeNumbers[index].currentScale = 1.0
            }
        }
    }
    
    private func cleanupOldNumbers() {
        let currentTime = Date()
        activeNumbers.removeAll { number in
            currentTime.timeIntervalSince(number.birthTime) > 10.0
        }
    }
    
    private func cleanupTimers() {
        generationTimer?.invalidate()
        generationTimer = nil
        cleanupTimer?.invalidate()
        cleanupTimer = nil
        activeNumbers.removeAll()
    }
}

// MARK: - Simple TwinklingNumber

struct TwinklingNumber {
    let id = UUID()
    let digit: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let maxOpacity: Double
    let birthTime: Date
    
    var currentOpacity: Double
    var currentScale: CGFloat
    
    init(screenWidth: CGFloat, screenHeight: CGFloat) {
            self.digit = Int.random(in: 1...9)
        
        // Center exclusion zone - keep center clear for sacred geometry
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        let exclusionRadius: CGFloat = 200 // Radius of the sacred center area
        
        // Generate position with center exclusion
        var validPosition = false
        var attemptX: CGFloat = 0
        var attemptY: CGFloat = 0
        
        while !validPosition {
            attemptX = CGFloat.random(in: 50...(screenWidth - 50))
            attemptY = CGFloat.random(in: 100...(screenHeight - 100))
            
            // Check distance from center
            let distance = hypot(attemptX - centerX, attemptY - centerY)
            if distance > exclusionRadius {
                validPosition = true
            }
        }
        
        self.x = attemptX
        self.y = attemptY
        
        // Subtle fade effect for numbers near the exclusion boundary
        let distance = hypot(attemptX - centerX, attemptY - centerY)
        let fadeZone: CGFloat = 40 // Fade zone width
        let fadeStart = exclusionRadius
        let fadeEnd = exclusionRadius + fadeZone
        
        if distance < fadeEnd {
            let fadeProgress = (distance - fadeStart) / fadeZone
            self.maxOpacity = Double.random(in: 0.3...0.6) * Double(fadeProgress)
            self.size = CGFloat.random(in: 20...30) * (0.7 + 0.3 * fadeProgress)
        } else {
            self.size = CGFloat.random(in: 20...30)
            self.maxOpacity = Double.random(in: 0.3...0.6)
        }
        
        self.birthTime = Date()
        
        // Start invisible
        self.currentOpacity = 0.0
        self.currentScale = 0.5
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
