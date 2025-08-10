import SwiftUI

/**
 * NumerologyRainView: Creates mystical randomly appearing numerology numbers
 *
 * Cosmic energy manifestation - numbers appear and fade in random locations
 * Like numerological consciousness flickering across dimensional space
 */
struct NumerologyRainView: View {
    @State private var cosmicNumbers: [CosmicNumber] = []
    @State private var sparklePhase: Double = 0
    @State private var manifestationTimer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(cosmicNumbers, id: \.id) { cosmicNumber in
                    Text("\(cosmicNumber.number)")
                        .font(.system(size: cosmicNumber.size, weight: .bold, design: .monospaced))
                        .foregroundColor(cosmicNumber.color)
                        .shadow(color: cosmicNumber.color, radius: cosmicNumber.glowRadius, x: 0, y: 0)
                        .opacity(cosmicNumber.opacity * sparklePhase)
                        .scaleEffect(cosmicNumber.scale * sparklePhase)
                        .position(x: cosmicNumber.x, y: cosmicNumber.y)
                        .animation(.easeInOut(duration: cosmicNumber.animationDuration), value: sparklePhase)
                }
            }
        }
        .onAppear {
            startCosmicManifestation()
        }
        .onDisappear {
            // Claude: Phase 16 critical memory leak prevention
            // Previous implementation: Timer continued running after view dismissal causing memory accumulation
            // Current implementation: Proper timer invalidation prevents memory leaks
            // Impact: Eliminates guaranteed timer leak in numerology rain animation
            manifestationTimer?.invalidate()
            manifestationTimer = nil
        }
    }

    private func startCosmicManifestation() {
        // Create initial cosmic numbers
        generateCosmicNumbers()

        // Claude: Phase 16 magic number elimination
        // Before: withAnimation(.easeInOut(duration: 2.0) - hardcoded 2-second duration
        // After: VybeConstants.epicAnimationDuration for consistent cosmic animations
        withAnimation(.easeInOut(duration: VybeConstants.epicAnimationDuration).repeatForever(autoreverses: true)) {
            sparklePhase = 1.0
        }

        // Claude: Phase 16 magic number elimination and memory safety
        // Before: Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) - hardcoded timing
        // After: Uses VybeConstants.numerologyRainInterval for centralized configuration
        // Benefits: Consistent timing across app, easy A/B testing, memory-safe implementation
        manifestationTimer = Timer.scheduledTimer(withTimeInterval: VybeConstants.numerologyRainInterval, repeats: true) { _ in
            generateCosmicNumbers()
        }
    }

    private func generateCosmicNumbers() {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = screen.windows.first else { return }

        let screenWidth = window.frame.width
        let screenHeight = window.frame.height

        // Create 15-25 random cosmic numbers
        let newNumbers = (0..<Int.random(in: 15...25)).map { _ in
            CosmicNumber(
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
        }

        withAnimation(.easeInOut(duration: VybeConstants.longAnimationDuration)) {
            cosmicNumbers = newNumbers
        }
    }
}

struct CosmicNumber {
    let id = UUID()
    let number: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
    let scale: CGFloat
    let glowRadius: CGFloat
    let animationDuration: Double

    init(screenWidth: CGFloat, screenHeight: CGFloat) {
        self.number = Int.random(in: 1...9)
        self.x = CGFloat.random(in: 40...(screenWidth - 40)) // Avoid edges
        self.y = CGFloat.random(in: 100...(screenHeight - 100)) // Avoid top/bottom
        self.size = CGFloat.random(in: 18...32)
        self.opacity = Double.random(in: 0.4...0.8)
        self.scale = CGFloat.random(in: 0.8...1.3)
        self.glowRadius = CGFloat.random(in: 5...15)
        self.animationDuration = Double.random(in: 1.0...3.0)
    }

    var color: Color {
        switch number {
        case 1: return .red          // Creation/Fire 🔥
        case 2: return .orange       // Partnership/Balance ⚖️
        case 3: return .yellow       // Expression/Joy ☀️
        case 4: return .green        // Foundation/Earth 🌍
        case 5: return .blue         // Freedom/Sky 🌌
        case 6: return .indigo       // Harmony/Love 💜
        case 7: return .purple       // Spirituality/Wisdom 🔮
        case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold - Abundance/Prosperity 💰
        case 9: return .white        // Completion/Universal ⚪
        default: return .white
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NumerologyRainView()
    }
}
