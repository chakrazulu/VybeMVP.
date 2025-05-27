import SwiftUI

struct CosmicBackgroundView: View {
    @State private var sparkleAnimationPhase: CGFloat = 0

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

            // Animated sparkles
            ForEach(0..<30, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height * 2) // Spread sparkles over a larger vertical area
                    )
                    .opacity(sin(Double(sparkleAnimationPhase) + Double(i)) * 0.5 + 0.5) // Ensure Double for sin
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                sparkleAnimationPhase = .pi * 2
            }
        }
    }
}

struct CosmicBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CosmicBackgroundView()
    }
} 