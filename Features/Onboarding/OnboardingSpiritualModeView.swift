import SwiftUI

struct OnboardingSpiritualModeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Spiritual Alignment")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("What spiritual mode or energy do you most seek to align with currently? This helps us tailor your Vybe experience.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Select Spiritual Mode", selection: $viewModel.spiritualModeSelection) {
                ForEach(viewModel.spiritualModeOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Or .wheel, .menu depending on desired UI
            .padding(.vertical)
            
            // You could add more descriptive text about each option if desired, perhaps based on selection.
            Text("Your choice will influence the themes of your daily insights, journal prompts, and reflections.")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
    }
}

struct OnboardingSpiritualModeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Simulate being on this step by directly passing the viewModel
        // In a real multi-step flow, the parent OnboardingView would manage this.
        OnboardingSpiritualModeView(viewModel: viewModel)
            .padding()
    }
} 