import SwiftUI

struct OnboardingInsightToneView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header Section
                headerSection
                
                // Selection Cards
                selectionSection
                
                // Description Section
                descriptionSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.05),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                Text("Tone of Insights")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("How would you like Vybe to communicate its insights to you? Your choice here shapes the voice of your experience.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                // Add clear instruction for multiple selection
                Text("✨ Select up to 3 that resonate")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.top, 20)
    }
    
    private var selectionSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.insightToneOptions, id: \.self) { option in
                InsightToneCard(
                    title: option,
                    isSelected: viewModel.selectedInsightTones.contains(option),
                    isDisabled: !viewModel.selectedInsightTones.contains(option) && viewModel.selectedInsightTones.count >= 3,
                    action: {
                        toggleInsightToneSelection(option)
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                )
            }
        }
    }
    
    private func toggleInsightToneSelection(_ option: String) {
        if let index = viewModel.selectedInsightTones.firstIndex(of: option) {
            viewModel.selectedInsightTones.remove(at: index)
        } else if viewModel.selectedInsightTones.count < 3 {
            viewModel.selectedInsightTones.append(option)
        }
    }
    
    private var descriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .foregroundColor(.blue)
                Text("How this affects your experience:")
                    .font(.headline)
                Spacer()
            }
            
            Text("This selection will tailor the language style of daily affirmations, journal prompts, and AI-driven reflections to resonate best with you.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InsightToneCard: View {
    let title: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    private var toneDescription: String {
        switch title {
        case "Poetic":
            return "Lyrical, metaphorical, and beautifully expressive"
        case "Direct":
            return "Clear, straightforward, and action-oriented"
        case "Gentle":
            return "Soft, nurturing, and compassionate"
        case "Motivational":
            return "Energizing, empowering, and inspiring"
        case "Philosophical":
            return "Deep, thoughtful, and contemplative"
        default:
            return "Personalized communication style"
        }
    }
    
    private var toneIcon: String {
        switch title {
        case "Poetic":
            return "quote.bubble.fill"
        case "Direct":
            return "arrow.right.circle.fill"
        case "Gentle":
            return "heart.circle.fill"
        case "Motivational":
            return "flame.circle.fill"
        case "Philosophical":
            return "brain.head.profile.fill"
        default:
            return "message.circle.fill"
        }
    }
    
    private var toneColor: Color {
        switch title {
        case "Poetic":
            return .purple
        case "Direct":
            return .orange
        case "Gentle":
            return .pink
        case "Motivational":
            return .red
        case "Philosophical":
            return .indigo
        default:
            return .blue
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: toneIcon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : (isDisabled ? toneColor.opacity(0.4) : toneColor))
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : (isDisabled ? .secondary : .primary))
                    
                    Text(toneDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : (isDisabled ? .secondary.opacity(0.6) : .secondary))
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : (isDisabled ? .gray.opacity(0.4) : .gray))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected 
                        ? LinearGradient(
                            gradient: Gradient(colors: [toneColor, toneColor.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground), Color(UIColor.secondarySystemBackground)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.clear : (isDisabled ? toneColor.opacity(0.2) : toneColor.opacity(0.3)),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: isSelected ? toneColor.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

struct OnboardingInsightToneView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        OnboardingInsightToneView(viewModel: viewModel)
            .padding()
    }
} 