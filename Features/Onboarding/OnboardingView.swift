// Features/Onboarding/OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var signInViewModel: SignInViewModel // To get user ID

    // This binding would be passed from the parent view that controls
    // whether to show ContentView or OnboardingView
    @Binding var hasCompletedOnboarding: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to VybeMVP")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Text("Let's personalize your experience. Please provide your birth information.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Form {
                    Section(header: Text("Your Information")) {
                        TextField("Full Name at Birth", text: $viewModel.fullNameAtBirth)
                            .autocapitalization(.words)
                        
                        DatePicker("Date of Birth",
                                   selection: $viewModel.birthDate,
                                   in: ...Date(), // Allow dates up to today
                                   displayedComponents: .date)
                    }
                }
                
                Button(action: {
                    viewModel.processOnboardingInfo()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .onAppear {
                // Set the user ID for the onboarding view model when the view appears
                // This assumes signInViewModel.userID contains the authenticated user's ID
                if let userID = signInViewModel.userID {
                    viewModel.setUserID(userID)
                } else {
                    // This case should ideally not happen if OnboardingView is shown after successful sign-in
                    print("⚠️ Warning: UserID not available in OnboardingView.onAppear. User might not be signed in.")
                    // Handle this scenario, e.g., by navigating back to sign-in or showing an error.
                }
            }
            .onChange(of: viewModel.onboardingComplete) { oldValue, newValue in
                if newValue {
                    self.hasCompletedOnboarding = true
                }
            }
        }
    }
}

// Preview needs a way to handle the binding.
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy SignInViewModel for the preview
        let dummySignInViewModel = SignInViewModel()
        // Simulate a logged-in user for the preview
        dummySignInViewModel.userID = "previewUserID" 
        
        return OnboardingView(hasCompletedOnboarding: .constant(false))
            .environmentObject(dummySignInViewModel)
    }
} 