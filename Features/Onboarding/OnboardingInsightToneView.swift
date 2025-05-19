import SwiftUI

struct OnboardingInsightToneView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tone of Insights")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("How would you like Vybe to communicate its insights to you? Your choice here shapes the voice of your experience.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker("Select Insight Tone", selection: $viewModel.insightToneSelection) {
                ForEach(viewModel.insightToneOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle()) // Or .wheel, .menu depending on desired UI
            .padding(.vertical)
            
            Text("This selection will tailor the language style of daily affirmations, journal prompts, and AI-driven reflections to resonate best with you.")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
    }
}

struct OnboardingInsightToneView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Simulate being on this step by directly passing the viewModel
        OnboardingInsightToneView(viewModel: viewModel)
            .padding()
    }
} 