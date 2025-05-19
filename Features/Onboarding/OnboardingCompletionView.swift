import SwiftUI
import SwiftUI

struct OnboardingCompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var hasCompletedOnboarding: Bool // To dismiss onboarding flow

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Welcome to Vybe!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text("Your spiritual journey begins now.")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let profile = viewModel.userProfile {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your Path is Illuminated:")
                        .font(.headline)
                        .padding(.bottom, 5)

                    ProfileSummaryRow(label: "Life Path Number", value: "\(profile.lifePathNumber) \(profile.isMasterNumber ? "(Master)" : "")")
                    ProfileSummaryRow(label: "Spiritual Mode", value: profile.spiritualMode)
                    ProfileSummaryRow(label: "Insight Tone", value: profile.insightTone)
                    if !profile.focusTags.isEmpty {
                        ProfileSummaryRow(label: "Focusing On", value: profile.focusTags.joined(separator: ", "))
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            } else {
                Text("Loading your profile insights...")
                    .foregroundColor(.secondary)
            }

            Spacer()
            Spacer()

            Button(action: {
                // This action will set the state that dismisses the onboarding flow
                // and shows the main app content.
                hasCompletedOnboarding = true
            }) {
                Text("Enter the Vybe Universe")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true) // Consistent with other onboarding views
    }
}

struct ProfileSummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}

// Preview
struct OnboardingCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = OnboardingViewModel()
        // Populate with some sample data for preview
        viewModel.userProfile = UserProfile(
            id: "previewUser",
            birthdate: Date(),
            lifePathNumber: 7,
            isMasterNumber: false,
            spiritualMode: "Reflection",
            insightTone: "Gentle",
            focusTags: ["Growth", "Purpose"],
            cosmicPreference: "Numerology + Moon Phases",
            cosmicRhythms: ["Moon Phases"],
            preferredHour: 8,
            wantsWhispers: true,
            wantsReflectionMode: true
        )
        
        return OnboardingCompletionView(viewModel: viewModel, hasCompletedOnboarding: .constant(false))
    }
} 
