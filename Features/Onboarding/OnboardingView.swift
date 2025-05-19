// Features/Onboarding/OnboardingView.swift
import SwiftUI

enum OnboardingStep: Int, CaseIterable {
    case initialInfo = 0
    case spiritualMode
    case insightTone
    case focusTags
    // Add other steps here as we build them
    case cosmicPreference
    case cosmicRhythms
    case notifications
    case reflectionMode
    case complete // A final summary or completion step if needed
}

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var signInViewModel: SignInViewModel // To get user ID
    @Binding var hasCompletedOnboarding: Bool

    @State private var currentStep: OnboardingStep = .initialInfo

    var body: some View {
        NavigationView {
            VStack {
                // Progress Indicator
                Text("Step \(currentStep.rawValue + 1) of \(OnboardingStep.allCases.count - 1)") // -1 if .complete is not a user-facing step number
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)

                // Page Content based on currentStep
                switch currentStep {
                case .initialInfo:
                    OnboardingInitialInfoView(viewModel: viewModel)
                case .spiritualMode:
                    OnboardingSpiritualModeView(viewModel: viewModel) // We will create this view next
                case .insightTone:
                    OnboardingInsightToneView(viewModel: viewModel)
                case .focusTags:
                    OnboardingFocusTagsView(viewModel: viewModel)
                case .cosmicPreference:
                    OnboardingCosmicPreferenceView(viewModel: viewModel)
                case .cosmicRhythms:
                    OnboardingCosmicRhythmsView(viewModel: viewModel)
                case .notifications:
                    OnboardingNotificationsView(viewModel: viewModel)
                case .reflectionMode:
                    OnboardingReflectionModeView(viewModel: viewModel)
                // Add case for .complete
                case .complete:
                    OnboardingCompletionView(viewModel: viewModel, hasCompletedOnboarding: $hasCompletedOnboarding)
                }

                Spacer() // Pushes navigation to bottom

                // Navigation Buttons
                HStack {
                    if currentStep.rawValue > 0 {
                        Button("Back") {
                            if let previousStep = OnboardingStep(rawValue: currentStep.rawValue - 1) {
                                currentStep = previousStep
                            }
                        }
                        .padding()
                    }

                    Spacer()

                    if currentStep.rawValue < OnboardingStep.allCases.count - 2 { // -2 to not show Next on the second to last if last is .complete
                        Button("Next") {
                            if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                                currentStep = nextStep
                            }
                        }
                        .padding()
                    } else if currentStep == .reflectionMode { // Assuming reflectionMode is the last data collection step
                        Button("Finish") {
                            viewModel.processOnboardingInfo()
                            // Navigate to the completion view after processing
                            currentStep = .complete
                        }
                        .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true) // Keep it clean, rely on custom progress/nav
            .onAppear {
                if let userID = signInViewModel.userID {
                    viewModel.setUserID(userID)
                } else {
                    print("⚠️ Warning: UserID not available in OnboardingView.onAppear. User might not be signed in.")
                }
            }
        }
    }
}

// This view will contain the original Form for Name and Birthdate
struct OnboardingInitialInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Vybe") // Changed from VybeMVP to Vybe
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Text("Let's start by gathering your core information to begin illuminating your path.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Form {
                Section(header: Text("Your Foundational Details")) {
                    TextField("Full Name (as given at birth - optional)", text: $viewModel.fullNameAtBirth)
                        .autocapitalization(.words)
                    
                    DatePicker("Date of Birth",
                               selection: $viewModel.birthDate,
                               in: ...Date(), 
                               displayedComponents: .date)
                }
            }
            .frame(maxHeight: 250) // Constrain form height
        }
    }
}

// Preview needs a way to handle the binding.
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dummySignInViewModel = SignInViewModel()
        dummySignInViewModel.userID = "previewUserID" 
        
        return OnboardingView(hasCompletedOnboarding: .constant(false))
            .environmentObject(dummySignInViewModel)
    }
} 