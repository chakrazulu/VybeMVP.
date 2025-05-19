import SwiftUI

struct OnboardingNotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    // Add explicit initializer
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    // Hours for the picker (0-23 for 24-hour format)
    private var hourOptions: [Int] = Array(0...23)

    // Formatter for displaying the hour in a user-friendly way (e.g., 7 AM, 1 PM)
    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // e.g., "7 AM", "1 PM"
        if let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) {
            return formatter.string(from: date)
        }
        return "\(hour):00"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notification Preferences")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Configure how and when you receive gentle reminders or insights from Vybe.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
            
            Form {
                Section(header: Text("Timed Whispers")) {
                    Toggle("Receive Timed Whispers?", isOn: $viewModel.doesWantWhispers)
                    
                    if viewModel.doesWantWhispers {
                        Picker("Preferred Hour for Whispers", selection: $viewModel.selectedPreferredHour) {
                            ForEach(hourOptions, id: \.self) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        // Consider .wheel or .menu if the list is long or for different aesthetics
                        // .pickerStyle(.wheel)
                    }
                }
                
                Section(header: Text("Why Notifications?"), footer: Text("Timed whispers are gentle, non-intrusive notifications designed to offer a moment of reflection or a timely insight based on your Vybe profile.")) {
                    Text("Vybe can send you personalized insights or prompts at your preferred time. These are designed to be supportive and enlightening, not distracting.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxHeight: 350) // Adjust height as needed

            Spacer()
        }
        .padding()
    }
}

struct OnboardingNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        viewModel.doesWantWhispers = true
        viewModel.selectedPreferredHour = 14 // 2 PM for preview
        return OnboardingNotificationsView(viewModel: viewModel)
            .padding()
    }
} 