import SwiftUI

struct OnboardingSpiritualModeView: View {
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
                            gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.purple)
            }

            VStack(spacing: 12) {
                Text("Spiritual Alignment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text("What spiritual mode or energy do you most seek to align with currently? This helps us tailor your Vybe experience.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)

                // Add clear instruction for multiple selection
                Text("✨ Select all that apply")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.purple)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.top, 20)
    }

    private var selectionSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.spiritualModeOptions, id: \.self) { option in
                SpiritualModeCard(
                    title: option,
                    isSelected: viewModel.selectedSpiritualModes.contains(option),
                    action: {
                        toggleSpiritualModeSelection(option)
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                )
            }
        }
    }

    private func toggleSpiritualModeSelection(_ option: String) {
        if let index = viewModel.selectedSpiritualModes.firstIndex(of: option) {
            viewModel.selectedSpiritualModes.remove(at: index)
        } else {
            viewModel.selectedSpiritualModes.append(option)
        }
    }

    private var descriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.circle.fill")
                    .foregroundColor(.blue)
                Text("How this shapes your journey:")
                    .font(.headline)
                Spacer()
            }

            Text("Your choice will influence the themes of your daily insights, journal prompts, and reflections. Each mode offers a unique lens through which to explore your spiritual growth.")
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

struct SpiritualModeCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    private var modeDescription: String {
        switch title {
        case "Manifestation":
            return "Focus on creating and attracting your desires"
        case "Reflection":
            return "Deep introspection and inner wisdom"
        case "Healing":
            return "Restoration and emotional balance"
        case "Growth":
            return "Expansion and personal development"
        case "Guidance":
            return "Seeking direction and clarity"
        default:
            return "Explore your spiritual path"
        }
    }

    private var modeIcon: String {
        switch title {
        case "Manifestation":
            return "star.circle.fill"
        case "Reflection":
            return "moon.circle.fill"
        case "Healing":
            return "heart.circle.fill"
        case "Growth":
            return "leaf.circle.fill"
        case "Guidance":
            return "location.circle.fill"
        default:
            return "circle.fill"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: modeIcon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .purple)
                    .frame(width: 30, height: 30)

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(modeDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 8)

                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                        ? LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
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
                                isSelected ? Color.clear : Color.purple.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: isSelected ? Color.purple.opacity(0.3) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingSpiritualModeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        OnboardingSpiritualModeView(viewModel: viewModel)
            .padding()
    }
}
