import SwiftUI

struct OnboardingCosmicPreferenceView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cosmic Preferences")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("How open are you to exploring influences beyond foundational numerology? This helps us scale your experience.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Select Cosmic Preference", selection: $viewModel.cosmicPreferenceSelection) {
                ForEach(viewModel.cosmicPreferenceOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            // Consider .menu for longer option lists or if segmented feels too wide.
            .pickerStyle(SegmentedPickerStyle()) 
            .padding(.vertical)
            
            Text("Your choice here prepares Vybe for potential future integrations, such as astrology, lunar cycles, or other cosmic data streams, aligning the app more deeply with universal rhythms if you choose.")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
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