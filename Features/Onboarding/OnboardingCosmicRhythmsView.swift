import SwiftUI

struct OnboardingCosmicRhythmsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Adjust for more/less columns, 2 might be good for these options

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cosmic Rhythms")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Which specific cosmic rhythms do you feel most attuned to or wish to explore? This can modulate insight timing and themes.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.cosmicRhythmOptions, id: \.self) { rhythm in
                        Button(action: {
                            toggleRhythmSelection(rhythm)
                        }) {
                            Text(rhythm)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, minHeight: 50) // Ensure buttons have some height
                                .background(viewModel.selectedCosmicRhythms.contains(rhythm) ? Color.accentColor : Color.secondary.opacity(0.2))
                                .foregroundColor(viewModel.selectedCosmicRhythms.contains(rhythm) ? .white : .primary)
                                .cornerRadius(8)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Text("Your selections can influence the structure and timing of your insights, aligning them with lunar phases, solar events, or other selected rhythms.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
    }

    private func toggleRhythmSelection(_ rhythm: String) {
        if let index = viewModel.selectedCosmicRhythms.firstIndex(of: rhythm) {
            viewModel.selectedCosmicRhythms.remove(at: index)
        } else {
            viewModel.selectedCosmicRhythms.append(rhythm)
        }
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