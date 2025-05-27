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
        ScrollView {
            VStack(spacing: 30) {
                // Header Section
                headerSection
                
                // Notification Settings
                settingsSection
                
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
                            gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.cyan.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "bell.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.mint)
            }
            
            VStack(spacing: 12) {
                Text("Notification Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.mint, .cyan]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Configure how and when you receive gentle reminders or insights from Vybe.")
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
            // Timed Whispers Card
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "clock.circle.fill")
                        .font(.title2)
                        .foregroundColor(.mint)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Timed Whispers")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Receive gentle insights at your preferred time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.doesWantWhispers)
                        .toggleStyle(SwitchToggleStyle(tint: .mint))
                }
                
                if viewModel.doesWantWhispers {
                    Divider()
                        .background(Color.mint.opacity(0.3))
                    
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "sun.and.horizon.circle.fill")
                                .foregroundColor(.orange)
                            Text("Preferred Time")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        
                        Picker("Preferred Hour for Whispers", selection: $viewModel.selectedPreferredHour) {
                            ForEach(hourOptions, id: \.self) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.mint.opacity(0.1))
                        )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.mint.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: Color.mint.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var descriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("About Timed Whispers:")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.mint)
                    Text("Gentle, non-intrusive notifications")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "heart.circle")
                        .foregroundColor(.pink)
                    Text("Personalized insights based on your Vybe profile")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "moon.circle")
                        .foregroundColor(.indigo)
                    Text("Designed to support and enlighten, not distract")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
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

struct OnboardingNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        viewModel.doesWantWhispers = true
        viewModel.selectedPreferredHour = 14 // 2 PM for preview
        return OnboardingNotificationsView(viewModel: viewModel)
            .padding()
    }
} 