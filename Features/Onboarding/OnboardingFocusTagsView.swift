import SwiftUI

struct OnboardingFocusTagsView: View {
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
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.3), Color.teal.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "tag.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 12) {
                Text("Focus Tags")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .teal]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Select tags that resonate with your current life focus. These help tailor insights and content to your journey.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                // Add clear instruction for multiple selection
                Text("✨ Select all that apply")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.top, 20)
    }
    
    private var selectionSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach(viewModel.focusTagOptions, id: \.self) { option in
                FocusTagCard(
                    title: option,
                    isSelected: viewModel.selectedFocusTags.contains(option),
                    action: {
                        if viewModel.selectedFocusTags.contains(option) {
                            viewModel.selectedFocusTags.removeAll { $0 == option }
                        } else {
                            viewModel.selectedFocusTags.append(option)
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
                Text("How this personalizes your experience:")
                    .font(.headline)
                Spacer()
            }
            
            Text("Choose as many as you like. These tags help us filter and suggest relevant themes for your daily insights and journal prompts.")
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

struct FocusTagCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private var tagDescription: String {
        switch title {
        case "Purpose":
            return "Discover your life's deeper meaning and direction"
        case "Love":
            return "Cultivate relationships and heart-centered connections"
        case "Creativity":
            return "Express your unique gifts and artistic vision"
        case "Well-being":
            return "Nurture your physical, mental, and emotional health"
        case "Career":
            return "Align your work with your soul's calling"
        case "Relationships":
            return "Deepen bonds and create meaningful connections"
        case "Spiritual Growth":
            return "Expand consciousness and inner wisdom"
        case "Abundance":
            return "Manifest prosperity in all areas of life"
        default:
            return "Focus on what matters most to you"
        }
    }
    
    private var tagIcon: String {
        switch title {
        case "Purpose":
            return "target"
        case "Love":
            return "heart.circle.fill"
        case "Creativity":
            return "paintbrush.pointed.fill"
        case "Well-being":
            return "leaf.circle.fill"
        case "Career":
            return "briefcase.circle.fill"
        case "Relationships":
            return "person.2.circle.fill"
        case "Spiritual Growth":
            return "sparkles"
        case "Abundance":
            return "infinity.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    private var tagColor: Color {
        switch title {
        case "Purpose":
            return .purple
        case "Love":
            return .pink
        case "Creativity":
            return .orange
        case "Well-being":
            return .green
        case "Career":
            return .blue
        case "Relationships":
            return .red
        case "Spiritual Growth":
            return .indigo
        case "Abundance":
            return .yellow
        default:
            return .teal
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                // Top row with icon and selection indicator
                HStack {
                    Image(systemName: tagIcon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : tagColor)
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? .white : .gray)
                }
                
                // Title and description with proper spacing
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Text(tagDescription)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected 
                        ? LinearGradient(
                            gradient: Gradient(colors: [tagColor, tagColor.opacity(0.8)]),
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
                                isSelected ? Color.clear : tagColor.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: isSelected ? tagColor.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingFocusTagsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Pre-select some tags for preview
        viewModel.selectedFocusTags = ["Purpose", "Well-being"]
        return OnboardingFocusTagsView(viewModel: viewModel)
            .padding()
    }
} 