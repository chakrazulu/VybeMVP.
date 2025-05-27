import SwiftUI

struct OnboardingCosmicRhythmsView: View {
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
                            gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.blue.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.cyan)
            }
            
            VStack(spacing: 12) {
                Text("Cosmic Rhythms")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Which specific cosmic rhythms do you feel most attuned to or wish to explore? This can modulate insight timing and themes.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                // Add clear instruction for multiple selection
                Text("✨ Select all that apply")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.cyan)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.cyan.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.top, 20)
    }
    
    private var selectionSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.cosmicRhythmOptions, id: \.self) { option in
                CosmicRhythmCard(
                    title: option,
                    isSelected: viewModel.selectedCosmicRhythms.contains(option),
                    action: {
                        if viewModel.selectedCosmicRhythms.contains(option) {
                            viewModel.selectedCosmicRhythms.removeAll { $0 == option }
                        } else {
                            viewModel.selectedCosmicRhythms.append(option)
                        }
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
                Text("How this influences your experience:")
                    .font(.headline)
                Spacer()
            }
            
            Text("Your selections can influence the structure and timing of your insights, aligning them with lunar phases, solar events, or other selected rhythms.")
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

struct CosmicRhythmCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private var rhythmDescription: String {
        switch title {
        case "Moon Phases":
            return "Align with lunar cycles and their transformative energy"
        case "Zodiac Seasons":
            return "Flow with the astrological seasons and their themes"
        case "Planetary Transits":
            return "Attune to planetary movements and their influences"
        case "Solar Events":
            return "Connect with solstices, equinoxes, and solar energy"
        default:
            return "Explore cosmic rhythms and their wisdom"
        }
    }
    
    private var rhythmIcon: String {
        switch title {
        case "Moon Phases":
            return "moon.circle.fill"
        case "Zodiac Seasons":
            return "sparkles.rectangle.stack.fill"
        case "Planetary Transits":
            return "globe.americas.fill"
        case "Solar Events":
            return "sun.max.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    private var rhythmColor: Color {
        switch title {
        case "Moon Phases":
            return .indigo
        case "Zodiac Seasons":
            return .purple
        case "Planetary Transits":
            return .blue
        case "Solar Events":
            return .orange
        default:
            return .cyan
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: rhythmIcon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : rhythmColor)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(rhythmDescription)
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
                            gradient: Gradient(colors: [rhythmColor, rhythmColor.opacity(0.8)]),
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
                                isSelected ? Color.clear : rhythmColor.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: isSelected ? rhythmColor.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingCosmicRhythmsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Pre-select some rhythms for preview
        viewModel.selectedCosmicRhythms = ["Moon Phases", "Solar Events"]
        return OnboardingCosmicRhythmsView(viewModel: viewModel)
            .padding()
    }
} 