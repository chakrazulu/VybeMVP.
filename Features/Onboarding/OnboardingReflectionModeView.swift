import SwiftUI

struct OnboardingReflectionModeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reflection Mode")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Would you like to engage with daily mood check-ins or reflective prompts? This helps Vybe understand your emotional landscape over time.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            
            Form {
                Section(header: Text("Daily Reflections")) {
                    Toggle("Enable Reflection Mode?", isOn: $viewModel.doesWantReflectionMode)
                }
                
                Section(footer: Text("Enabling this allows Vybe to offer more personalized support and track emotional patterns, enhancing the depth of your spiritual journey with the app.")) {
                    Text("Reflection Mode can include brief daily mood logs or short guided reflections to help you connect with your inner state.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxHeight: 250) // Adjust height as needed

            Spacer()
        }
        .padding()
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