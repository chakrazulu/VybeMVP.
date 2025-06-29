import SwiftUI

/**
 * TwinklingDigitsBackground: Simple cosmic background with twinkling numbers
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
        
        // REVERT TO STEP 4: Generate 30 initial numbers (was 35) 
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
        
        // Simple random positioning
        self.x = CGFloat.random(in: 50...(screenWidth - 50))
        self.y = CGFloat.random(in: 100...(screenHeight - 100))
        
        self.size = CGFloat.random(in: 20...30)
        self.maxOpacity = Double.random(in: 0.3...0.6)
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
