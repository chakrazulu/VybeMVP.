/**
 * Spiritual Feedback View - User Rating Collection for KASPER MLX Insights
 * 
 * A beautifully designed feedback interface that allows users to rate KASPER MLX
 * insights while maintaining Vybe's spiritual aesthetic. Features intuitive
 * thumbs up/down ratings with haptic feedback and spiritual animations.
 * 
 * Key Features:
 * • Intuitive thumbs up/down interface
 * • Spiritual hover effects and animations
 * • Haptic feedback for interaction confirmation
 * • Accessibility support with VoiceOver
 * • Performance tracking integration
 * • Non-intrusive design that complements spiritual content
 * 
 * Usage:
 * ```swift
 * SpiritualFeedbackView(insight: kasperInsight) { positive in
 *     // Handle user feedback
 *     recordFeedback(positive: positive)
 * }
 * ```
 */

import SwiftUI

/// Claude: Spiritual feedback interface for KASPER MLX insights
struct SpiritualFeedbackView: View {
    let insight: KASPERInsight
    let onFeedback: (Bool) -> Void
    
    @State private var hasGivenFeedback = false
    @State private var feedbackAnimation = false
    @State private var selectedFeedback: Bool?
    
    var body: some View {
        HStack(spacing: 20) {
            Text("Was this helpful?")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
            
            Spacer()
            
            HStack(spacing: 16) {
                // Positive feedback button
                feedbackButton(
                    isPositive: true,
                    icon: "hand.thumbsup.fill",
                    color: .green,
                    isSelected: selectedFeedback == true
                ) {
                    provideFeedback(positive: true)
                }
                
                // Negative feedback button  
                feedbackButton(
                    isPositive: false,
                    icon: "hand.thumbsdown.fill",
                    color: .red,
                    isSelected: selectedFeedback == false
                ) {
                    provideFeedback(positive: false)
                }
            }
        }
        .padding(.top, 8)
        .opacity(hasGivenFeedback ? 0.6 : 1.0)
        .scaleEffect(feedbackAnimation ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: feedbackAnimation)
    }
    
    /// Claude: Individual feedback button with spiritual styling
    private func feedbackButton(
        isPositive: Bool,
        icon: String,
        color: Color,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(isSelected ? color : color.opacity(0.7))
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .shadow(
                    color: isSelected ? color.opacity(0.6) : Color.clear,
                    radius: isSelected ? 4 : 0
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(hasGivenFeedback)
        .accessibilityLabel(isPositive ? "Rate insight as helpful" : "Rate insight as not helpful")
        .accessibilityHint("Provides feedback to improve future spiritual guidance")
    }
    
    /// Claude: Handle user feedback with animation and haptics
    private func provideFeedback(positive: Bool) {
        guard !hasGivenFeedback else { return }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: positive ? .light : .medium)
        impactFeedback.impactOccurred()
        
        // Visual feedback
        selectedFeedback = positive
        feedbackAnimation = true
        hasGivenFeedback = true
        
        // Reset animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            feedbackAnimation = false
        }
        
        // Call the feedback handler
        onFeedback(positive)
        
        // Show confirmation with subtle animation
        withAnimation(.easeInOut(duration: 0.3)) {
            // Additional visual confirmation could be added here
        }
        
        print("🔮 Spiritual Feedback: User rated insight as \(positive ? "helpful" : "not helpful")")
    }
}

/// Claude: Feedback thank you message component
struct FeedbackThankYouView: View {
    let isPositive: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isPositive ? "heart.fill" : "leaf.fill")
                .font(.caption2)
                .foregroundColor(isPositive ? .pink : .green)
            
            Text(isPositive ? "Thank you for the positive energy" : "Thank you for helping us grow")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
                .italic()
        }
        .padding(.top, 4)
        .transition(.opacity.combined(with: .scale))
    }
}

/// Claude: Preview for spiritual feedback view
struct SpiritualFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Sample insight for preview
                let sampleInsight = KASPERInsight(
                    requestId: UUID(),
                    content: "Your cosmic energy aligns with transformative possibilities today.",
                    type: .guidance,
                    feature: .dailyCard,
                    confidence: 0.85,
                    inferenceTime: 0.1
                )
                
                VStack(spacing: 16) {
                    Text("Sample Daily Card Insight")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(sampleInsight.content)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple.opacity(0.2))
                        )
                    
                    SpiritualFeedbackView(insight: sampleInsight) { positive in
                        print("Preview feedback: \(positive)")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.purple.opacity(0.3))
                )
            }
            .padding()
        }
    }
}