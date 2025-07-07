/**
 * Filename: ProfileSetupView.swift
 * 
 * 🎯 PROFILE SETUP VIEW FOR POST-ONBOARDING USER PROFILE CREATION 🎯
 *
 * === CORE PURPOSE ===
 * Dedicated profile setup screen that appears after onboarding completion
 * and before entering the main app. Allows users to set their social
 * profile information: username, display name, bio, and avatar.
 *
 * === INTEGRATION POINT ===
 * Called from OnboardingCompletionView after spiritual data is captured
 * but before transitioning to ContentView. Ensures users have complete
 * profiles before entering the social features of the app.
 *
 * === USER FLOW ===
 * 1. User completes spiritual onboarding (numerology, preferences, etc.)
 * 2. User sees their spiritual profile summary (OnboardingCompletionView)
 * 3. User taps "Begin Your Sacred Journey" → ProfileSetupView appears
 * 4. User fills out social profile (username, bio, etc.)
 * 5. User taps "Complete Profile" → Main app (ContentView) appears
 *
 * === FIELDS CAPTURED ===
 * • Display Name: Public name shown in posts and profile
 * • Username: Unique @handle for social features
 * • Bio: Optional description (160 character limit)
 * • Avatar: Optional profile picture selection
 *
 * === DESIGN PHILOSOPHY ===
 * • Clean, focused interface with cosmic theming
 * • Clear field validation and helpful guidance
 * • Optional fields allow quick completion
 * • Consistent with VybeMVP spiritual aesthetic
 */

import SwiftUI

struct ProfileSetupView: View {
    @Binding var isProfileSetupComplete: Bool
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // Profile data
    @State private var displayName: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var avatarImage: UIImage?
    
    // UI state
    @State private var showingImagePicker = false
    @State private var isCreatingProfile = false
    @State private var usernameValidationMessage = ""
    @State private var isUsernameValid = false
    
    var body: some View {
        ZStack {
            // Cosmic background
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
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header Section
                    headerSection
                    
                    // Profile Picture Section
                    profilePictureSection
                    
                    // Basic Information Section
                    basicInfoSection
                    
                    // Bio Section
                    bioSection
                    
                    // Complete Profile Button
                    completeProfileButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $avatarImage, sourceType: .photoLibrary)
        }
        .onChange(of: username) { _, newValue in
            validateUsername(newValue)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Cosmic icon
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
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Complete Your Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Set up your social profile to connect with the Vybe community")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Profile Picture Section
    
    private var profilePictureSection: some View {
        VStack(spacing: 15) {
            Text("Profile Picture (Optional)")
                .font(.headline)
                .foregroundColor(.white)
            
            Button(action: {
                showingImagePicker = true
            }) {
                ZStack {
                    Group {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.purple, .blue, .indigo]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    )
                    
                    // Camera overlay for existing image
                    if avatarImage != nil {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                    .background(Circle().fill(Color.white))
                                    .offset(x: -5, y: -5)
                            }
                        }
                        .frame(width: 100, height: 100)
                    }
                }
            }
            
            Text("Tap to add a photo")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    // MARK: - Basic Information Section
    
    private var basicInfoSection: some View {
        VStack(spacing: 20) {
            // Display Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Display Name")
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("How you'll appear to others", text: $displayName)
                    .textFieldStyle(CosmicTextFieldStyle())
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
            }
            
            // Username
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("@")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 12)
                    
                    TextField("yourhandle", text: $username)
                        .font(.body)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: username) { _, newValue in
                            // Clean input
                            let cleaned = newValue.lowercased().replacingOccurrences(of: "[^a-z0-9_]", with: "", options: .regularExpression)
                            if cleaned != newValue {
                                username = cleaned
                            }
                        }
                }
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isUsernameValid ? Color.green.opacity(0.5) : Color.purple.opacity(0.5), lineWidth: 1)
                        )
                )
                
                // Username validation message
                if !username.isEmpty {
                    HStack {
                        Image(systemName: isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isUsernameValid ? .green : .red)
                            .font(.caption)
                        
                        Text(usernameValidationMessage)
                            .font(.caption)
                            .foregroundColor(isUsernameValid ? .green : .red)
                        
                        Spacer()
                    }
                }
                
                Text("4-15 characters • letters, numbers, underscores only")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
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
    
    // MARK: - Bio Section
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Bio (Optional)")
                .font(.headline)
                .foregroundColor(.white)
            
            TextField("Tell the world about your spiritual journey...", text: $bio, axis: .vertical)
                .textFieldStyle(CosmicTextFieldStyle())
                .lineLimit(4...6)
            
            HStack {
                Spacer()
                Text("\(bio.count)/160")
                    .font(.caption)
                    .foregroundColor(bio.count > 160 ? .red : .white.opacity(0.6))
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
                                gradient: Gradient(colors: [.blue.opacity(0.5), .indigo.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Complete Profile Button
    
    private var completeProfileButton: some View {
        Button(action: {
            completeProfileSetup()
        }) {
            HStack(spacing: 8) {
                if isCreatingProfile {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                    
                    Text("Creating Profile...")
                        .fontWeight(.bold)
                        .font(.callout)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                    
                    Text("Complete Profile")
                        .fontWeight(.bold)
                        .font(.callout)
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.body)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .frame(height: 64)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue, .indigo, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 8)
        }
        .disabled(isCreatingProfile || !isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Helper Properties
    
    private var isFormValid: Bool {
        return !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !username.isEmpty &&
               isUsernameValid &&
               bio.count <= 160
    }
    
    // MARK: - Helper Methods
    
    private func validateUsername(_ username: String) {
        if username.isEmpty {
            usernameValidationMessage = ""
            isUsernameValid = false
            return
        }
        
        if username.count < 4 {
            usernameValidationMessage = "Username must be at least 4 characters"
            isUsernameValid = false
        } else if username.count > 15 {
            usernameValidationMessage = "Username must be 15 characters or less"
            isUsernameValid = false
        } else if !username.first!.isLetter {
            usernameValidationMessage = "Username must start with a letter"
            isUsernameValid = false
        } else if username.contains("__") {
            usernameValidationMessage = "No consecutive underscores allowed"
            isUsernameValid = false
        } else {
            // TODO: Check availability against Firebase/UserDefaults
            usernameValidationMessage = "Username available"
            isUsernameValid = true
        }
    }
    
    private func completeProfileSetup() {
        isCreatingProfile = true
        
        // Save profile data to UserDefaults for now
        // TODO: Integrate with UserProfileService for Firebase sync
        guard let userID = signInViewModel.userID else {
            print("❌ No user ID available for profile setup")
            isCreatingProfile = false
            return
        }
        
        // Save profile data
        let profileData = [
            "displayName": displayName.trimmingCharacters(in: .whitespacesAndNewlines),
            "username": "@\(username)",
            "bio": bio.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        UserDefaults.standard.set(profileData, forKey: "socialProfile_\(userID)")
        UserDefaults.standard.synchronize()
        
        // TODO: Save avatar image to Documents directory or Firebase Storage
        
        print("💾 Profile setup completed for user \(userID)")
        print("   Display Name: \(displayName)")
        print("   Username: @\(username)")
        print("   Bio: \(bio)")
        
        // Delay to show the loading state, then complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isProfileSetupComplete = true
        }
    }
}

// Preview
struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(isProfileSetupComplete: .constant(false))
            .environmentObject(SignInViewModel())
    }
}