import SwiftUI

struct OnboardingReflectionModeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header Section
                headerSection

                // Reflection Settings
                settingsSection

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
                            gradient: Gradient(colors: [Color.teal.opacity(0.3), Color.blue.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.teal)
            }

            VStack(spacing: 12) {
                Text("Reflection Mode")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.teal, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text("Would you like to engage with daily mood check-ins or reflective prompts? This helps Vybe understand your emotional landscape over time.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
        .padding(.top, 20)
    }

    private var settingsSection: some View {
        VStack(spacing: 20) {
            // Reflection Mode Card
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "heart.circle.fill")
                        .font(.title2)
                        .foregroundColor(.teal)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Reflections")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("Enable mood check-ins and reflective prompts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Toggle("", isOn: $viewModel.doesWantReflectionMode)
                        .toggleStyle(SwitchToggleStyle(tint: .teal))
                }

                if viewModel.doesWantReflectionMode {
                    Divider()
                        .background(Color.teal.opacity(0.3))

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.teal)
                            Text("What this includes:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.teal)
                                Text("Brief daily mood logs")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.teal)
                                Text("Short guided reflections")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.teal)
                                Text("Emotional pattern insights")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                        .padding(.leading, 8)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.teal.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: Color.teal.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }

    private var descriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("How this enhances your journey:")
                    .font(.headline)
                Spacer()
            }

            Text("Enabling this allows Vybe to offer more personalized support and track emotional patterns, enhancing the depth of your spiritual journey with the app.")
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

struct OnboardingReflectionModeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        viewModel.doesWantReflectionMode = true // Default to true for preview
        return OnboardingReflectionModeView(viewModel: viewModel)
            .padding()
    }
}
