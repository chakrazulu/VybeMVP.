// Features/Onboarding/OnboardingView.swift
//
// 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
//
// === ONBOARDING FLOW STRUCTURE ===
// • Total steps: 9 (8 data collection + 1 completion)
// • Navigation: Back/Next buttons, 20pt bottom padding
// • Background: Full screen CosmicBackgroundView
// • Progress indicator: "Step X of 8" caption font
//
// === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
// • NavigationView: Hidden navigation bar
// • Main VStack: Full height with progress, content, navigation
// • Content padding: 20pt horizontal
// • Bottom navigation: HStack with Back/Next/Finish buttons
//
// === NAVIGATION BUTTONS ===
// • Back button: Purple color, standard padding
// • Next/Finish button: Purple color, semibold weight
// • Button padding: System default (~16pt)
// • Bottom margin: 20pts from safe area
//
// === INITIAL INFO VIEW (Step 0) ===
// • Header icon: 120×120pt circle with gradient
// • Icon animation: Scale 1.0→1.1, 2s duration, repeat
// • Title: Large Title font (~34pt), gradient text
// • Subtitle: Title3 font (~20pt), 80% white opacity
// • Section spacing: 30pts between major sections
//
// === INPUT FIELDS SECTION ===
// • Container: RoundedRectangle, 20pt corner radius
// • Background: Black 30% opacity
// • Border: Purple→Blue gradient, 1pt width
// • Shadow: Purple 30%, 15pt blur, 8pt Y offset
// • Field spacing: 25pts between sections, 12pts between fields
// • Text fields: CosmicTextFieldStyle (see SharedUIComponents)
//
// === NAME INPUT FIELDS ===
// • Section icon: person.circle.fill, Title2 size
// • Label font: Caption, uppercase, 0.5 tracking
// • Label color: White 70% opacity
// • Field height: ~44pts (standard iOS)
// • Autocapitalization: Words
//
// === DATE PICKER ===
// • Style: Compact
// • Background: Black 30% opacity, 12pt radius
// • Border: Blue 40% opacity, 1pt width
// • Date range: 1900-01-01 to current date
// • Time picker: Optional, shows when toggle enabled
//
// === EXPLANATION SECTION ===
// • Container: 16pt corner radius
// • Background: Blue 20% opacity
// • Border: Blue 40% opacity, 1pt width
// • Icon size: Title3 font (~20pt)
// • Row spacing: 12pts between elements
// • Text hierarchy: Subheadline title, Caption description
//
// === ANIMATION TIMINGS ===
// • Header pulse: 2.0s ease-in-out, repeat forever
// • Icon rotation: 8.0s linear, 360°, repeat forever
// • Field animations: None (static for input stability)
//
// === STATE MANAGEMENT ===
// • currentStep: Tracks active onboarding step
// • Individual name fields: firstName, middleName, lastName
// • birthTime: Optional Date for time selection
// • includeBirthTime: Toggle state
// • isCalculating: Animation trigger
//
import SwiftUI

/**
 * MinimalCosmicBackground: Subtle cosmic background for onboarding focus
 *
 * Provides a gentle cosmic aesthetic without the intense star field of the main
 * CosmicBackgroundView, allowing users to focus on onboarding content.
 */
struct MinimalCosmicBackground: View {
    @State private var sparkles: [SparklePoint] = []
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.15),
                    Color.indigo.opacity(0.1),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Minimal sparkle field (only 8 gentle sparkles)
            ForEach(sparkles, id: \.id) { sparkle in
                Circle()
                    .fill(sparkle.color.opacity(sparkle.opacity))
                    .frame(width: sparkle.size, height: sparkle.size)
                    .position(x: sparkle.x, y: sparkle.y)
                    .shadow(color: sparkle.color.opacity(0.3), radius: sparkle.size * 0.5)
            }
        }
        .onAppear {
            initializeSparkles()
            startGentleAnimation()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func initializeSparkles() {
        sparkles = (0..<8).map { _ in
            SparklePoint(
                x: Double.random(in: 50...350),
                y: Double.random(in: 100...700),
                size: Double.random(in: 1.0...2.5),
                opacity: Double.random(in: 0.2...0.5),
                color: [Color.white, Color.cyan, Color.purple].randomElement() ?? Color.white
            )
        }
    }

    private func startGentleAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: VybeConstants.onboardingSparkleInterval, repeats: true) { _ in
            for i in sparkles.indices {
                // Gentle twinkle effect
                sparkles[i].opacity += sparkles[i].twinkleDirection * 0.01

                if sparkles[i].opacity <= 0.1 || sparkles[i].opacity >= 0.6 {
                    sparkles[i].twinkleDirection *= -1
                }
            }
        }
    }
}

struct SparklePoint {
    let id = UUID()
    var x: Double
    var y: Double
    var size: Double
    var opacity: Double
    var twinkleDirection: Double = 1.0
    let color: Color
}

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
            ZStack { // Add ZStack to layer the background
                MinimalCosmicBackground() // Minimal cosmic background for onboarding focus

                VStack {
                    // Progress Indicator - Only show for non-completion steps
                    if currentStep != .complete {
                        Text("Step \(currentStep.rawValue + 1) of \(OnboardingStep.allCases.count - 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }

                    // Page Content based on currentStep
                    switch currentStep {
                    case .initialInfo:
                        OnboardingInitialInfoView(viewModel: viewModel)
                    case .spiritualMode:
                        OnboardingSpiritualModeView(viewModel: viewModel)
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
                            .foregroundColor(.purple)
                        }

                        Spacer()

                        if currentStep.rawValue < OnboardingStep.allCases.count - 2 { // -2 to not show Next on the second to last if last is .complete
                            Button("Next") {
                                if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                                    currentStep = nextStep
                                }
                            }
                            .padding()
                            .foregroundColor(.purple)
                            .fontWeight(.semibold)
                        } else if currentStep == .reflectionMode { // Assuming reflectionMode is the last data collection step
                            Button("Finish") {
                                viewModel.processOnboardingInfo()
                                // Navigate to the completion view after processing
                                currentStep = .complete
                            }
                            .padding()
                            .foregroundColor(.purple)
                            .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
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

// MARK: - Enhanced Onboarding Initial Info View

struct OnboardingInitialInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    // Individual name components for better numerology calculations
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var birthLocation: String = ""
    @State private var birthTime: Date = Date()
    @State private var includeBirthTime: Bool = false
    @State private var isCalculating: Bool = false

    // Date range constraints
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
        let endDate = Date()
        return startDate...endDate
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Cosmic Header
                headerSection

                // Input Fields Section
                inputFieldsSection

                // Sacred Context Section
                explanationSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .onAppear {
            // Sync any existing data
            if !viewModel.fullNameAtBirth.isEmpty {
                parseExistingName()
            }
            // Start cosmic animation
            isCalculating = true
        }
        .onChange(of: firstName) { oldValue, newValue in updateFullName() }
        .onChange(of: middleName) { oldValue, newValue in updateFullName() }
        .onChange(of: lastName) { oldValue, newValue in updateFullName() }
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(spacing: 20) {
            // Cosmic icon with animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.4),
                                Color.blue.opacity(0.3),
                                Color.indigo.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(isCalculating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isCalculating)

                Image(systemName: "sparkles")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isCalculating ? 360 : 0))
                    .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: isCalculating)
            }

            VStack(spacing: 12) {
                Text("Your Spiritual Blueprint")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text("Enter your sacred details to unlock your cosmic identity")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }

    private var inputFieldsSection: some View {
        VStack(spacing: 25) {
            // Name Input Section
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.purple)
                        .font(.title2)
                    Text("Your Sacred Name")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                VStack(spacing: 12) {
                    // First Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("First Name")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .textCase(.uppercase)
                            .tracking(0.5)

                        TextField("Given name", text: $firstName)
                            .textFieldStyle(CosmicTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }

                    // Middle Name (Optional)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Middle Name (Optional)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .textCase(.uppercase)
                            .tracking(0.5)

                        TextField("Middle name", text: $middleName)
                            .textFieldStyle(CosmicTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }

                    // Last Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Last Name")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .textCase(.uppercase)
                            .tracking(0.5)

                        TextField("Family name", text: $lastName)
                            .textFieldStyle(CosmicTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                }
            }

            // Birthdate Input Section
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    Text("Your Cosmic Birthday")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                VStack(spacing: 12) {
                    DatePicker(
                        "Birth Date",
                        selection: $viewModel.birthDate,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                            )
                    )

                    // Optional Birth Time Section
                    VStack(spacing: 8) {
                        HStack {
                            Toggle("Include birth time (optional)", isOn: $includeBirthTime)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }

                        if includeBirthTime {
                            DatePicker(
                                "Birth Time",
                                selection: $birthTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.indigo.opacity(0.4), lineWidth: 1)
                                    )
                            )

                            Text("Birth time enables deeper astrological insights")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                                .italic()
                        }
                    }
                }
            }

            // Claude: Phase 11A - Birthplace Input Section
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    Text("Your Sacred Birthplace")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Birth Location")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .textCase(.uppercase)
                            .tracking(0.5)

                        TextField("City, State/Province, Country", text: $birthLocation)
                            .textFieldStyle(CosmicTextFieldStyle())
                            .autocapitalization(.words)
                            .disableAutocorrection(false)
                    }

                    Text("Your birthplace enables precise astronomical calculations for personalized cosmic insights")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                        .italic()
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple.opacity(0.5), .blue.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
    }

    private var explanationSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Your Cosmic Blueprint Includes:")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
                numerologyElement("📊", "Life Path Number", "Your core spiritual identity and life purpose")
                numerologyElement("♈", "Zodiac Archetype", "Your astrological personality and cosmic role")
                numerologyElement("🔥", "Elemental Nature", "Your fundamental energy signature")
                numerologyElement("🎵", "Soul Urge Number", "Your heart's deepest desires (from name)")
                numerologyElement("✨", "Expression Number", "Your natural talents and abilities (from name)")
                if includeBirthTime {
                    numerologyElement("🌙", "Birth Time", "Enables precise astrological house placements")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                )
        )
    }

    private func numerologyElement(_ icon: String, _ title: String, _ description: String) -> some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
        }
    }

    // MARK: - Helper Properties & Methods

    private var fullName: String {
        let components = [firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                         middleName.trimmingCharacters(in: .whitespacesAndNewlines),
                         lastName.trimmingCharacters(in: .whitespacesAndNewlines)]
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    private func updateFullName() {
        // Update the view model's fullNameAtBirth
        viewModel.fullNameAtBirth = fullName
    }

    private func parseExistingName() {
        let components = viewModel.fullNameAtBirth.components(separatedBy: " ")
        if components.count >= 2 {
            firstName = components[0]
            if components.count == 2 {
                lastName = components[1]
            } else if components.count >= 3 {
                lastName = components.last ?? ""
                middleName = components[1..<components.count-1].joined(separator: " ")
            }
        }
    }
}

// MARK: - Enhanced Cosmic Text Field Style

// Preview needs a way to handle the binding.
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dummySignInViewModel = SignInViewModel()
        dummySignInViewModel.userID = "previewUserID"

        return OnboardingView(hasCompletedOnboarding: .constant(false))
            .environmentObject(dummySignInViewModel)
    }
}
