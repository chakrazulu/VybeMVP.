import SwiftUI

struct OnboardingCosmicPreferenceView: View {
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
                            gradient: Gradient(colors: [Color.indigo.opacity(0.3), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.indigo)
            }
            
            VStack(spacing: 12) {
                Text("Cosmic Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.indigo, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("How open are you to exploring influences beyond foundational numerology? This helps us scale your experience.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
        .padding(.top, 20)
    }
    
    private var selectionSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.cosmicPreferenceOptions, id: \.self) { option in
                CosmicPreferenceCard(
                    title: option,
                    isSelected: viewModel.cosmicPreferenceSelection == option,
                    action: {
                        viewModel.cosmicPreferenceSelection = option
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                )
            }
        }
    }
    
    private var descriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("How this shapes your journey:")
                    .font(.headline)
                Spacer()
            }
            
            Text("Your choice here prepares Vybe for potential future integrations, such as astrology, lunar cycles, or other cosmic data streams, aligning the app more deeply with universal rhythms if you choose.")
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

struct CosmicPreferenceCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private var preferenceDescription: String {
        switch title {
        case "Numerology Only":
            return "Focus purely on numerological insights and patterns"
        case "Numerology + Moon Phases":
            return "Blend numerology with lunar cycle wisdom"
        case "Full Cosmic Integration":
            return "Embrace the complete cosmic tapestry of influences"
        default:
            return "Explore your cosmic preferences"
        }
    }
    
    private var preferenceIcon: String {
        switch title {
        case "Numerology Only":
            return "number.circle.fill"
        case "Numerology + Moon Phases":
            return "moon.circle.fill"
        case "Full Cosmic Integration":
            return "sparkles.rectangle.stack.fill"
        default:
            return "circle.fill"
        }
    }
    
    private var preferenceColor: Color {
        switch title {
        case "Numerology Only":
            return .green
        case "Numerology + Moon Phases":
            return .blue
        case "Full Cosmic Integration":
            return .purple
        default:
            return .indigo
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: preferenceIcon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : preferenceColor)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(preferenceDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected 
                        ? LinearGradient(
                            gradient: Gradient(colors: [preferenceColor, preferenceColor.opacity(0.8)]),
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
                                isSelected ? Color.clear : preferenceColor.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: isSelected ? preferenceColor.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingCosmicPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Example selection for preview
        viewModel.cosmicPreferenceSelection = "Numerology + Moon Phases"
        return OnboardingCosmicPreferenceView(viewModel: viewModel)
            .padding()
    }
} 