/**
 * Filename: UserProfileView.swift
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === CORE PURPOSE ===
 * Modern Twitter-style social profile view for VybeMVP
 * Clean, functional social interface with cosmic theming
 * Part of Phase 3A Step 2.2: Twitter-Style Profile Implementation
 *
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • NavigationView: Large title "Profile"
 * • ScrollView: Vertical content with Twitter-style layout
 * • Avatar Section: 120×120pt circle with cosmic glow
 * • User Identity: Display name, @username, bio (160 chars)
 * • Stats Row: Friends, Matches, XP, Insights (horizontal)
 * • Action Buttons: Edit Profile, Settings (Twitter-style)
 * • Content Tabs: Posts, Insights, Activity (segmented control)
 *
 * === TWITTER-STYLE DESIGN SPECS ===
 * • Header Layout: Avatar + Identity vertical stack
 * • Stats Row: Horizontal with dividers, tap actions
 * • Action Buttons: Rounded, modern button styling
 * • Content Tabs: iOS segmented control appearance
 * • Colors: Cosmic purple/blue theme on clean layout
 * • Typography: SF Pro with proper hierarchy
 *
 * === COSMIC INTEGRATION ===
 * • Background: ScrollSafeCosmicView for twinkling numbers
 * • Avatar Glow: Purple/blue radial gradient effect
 * • Color Scheme: Consistent with VybeMVP cosmic aesthetic
 * • Performance: 60fps smooth scrolling and animations
 *
 * Created as part of Phase 3A Step 2.2 - Twitter-Style Profile Foundation
 * Replaces PlaceholderProfileView with functional social profile interface
 */

import SwiftUI

/**
 * UserProfileView: Modern Twitter-style social profile interface
 * 
 * Purpose:
 * - Display user's social profile with clean Twitter-style layout
 * - Provide access to social features and profile editing
 * - Show user stats and content in organized tabs
 * - Foundation for future social features (friends, posts, etc.)
 * 
 * Design Philosophy:
 * - Twitter-inspired layout with cosmic theming
 * - Clean, modern interface focused on usability
 * - Easy access to editing and settings
 * - Extensible foundation for social feature expansion
 */
struct UserProfileView: View {
    
    // MARK: - State Properties
    
    /// User's profile data (future integration with UserProfileService)
    @State private var displayName: String = "Cosmic Seeker"
    @State private var username: String = "@cosmic_wanderer"
    @State private var bio: String = "Exploring the sacred mysteries of numbers and cosmic alignment ✨ Living in sync with the universe's rhythm 🌌"
    @State private var avatarImage: UIImage?
    
    /// Social stats (future integration with social managers)
    @State private var friendsCount: Int = 42
    @State private var matchesCount: Int = 108
    @State private var xpLevel: Int = 7
    @State private var insightsCount: Int = 23
    
    /// UI state
    @State private var selectedContentTab: ContentTab = .posts
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    // MARK: - Content Tab Types
    
    enum ContentTab: String, CaseIterable {
        case posts = "Posts"
        case insights = "Insights"
        case activity = "Activity"
        
        var icon: String {
            switch self {
            case .posts: return "doc.text"
            case .insights: return "lightbulb"
            case .activity: return "chart.bar"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic Background
                ScrollSafeCosmicView {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Profile Header Section
                            profileHeaderSection
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            // Action Buttons Section
                            actionButtonsSection
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            // Stats Row Section
                            statsRowSection
                                .padding(.horizontal, 16)
                                .padding(.top, 20)
                            
                            // Content Tabs Section
                            contentTabsSection
                                .padding(.top, 24)
                            
                            // Content Display Section
                            contentDisplaySection
                                .padding(.horizontal, 16)
                                .padding(.bottom, 32)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileSheet(
                    displayName: $displayName,
                    username: $username,
                    bio: $bio,
                    avatarImage: $avatarImage
                )
            }
            .sheet(isPresented: $showingSettings) {
                SettingsSheet()
            }
        }
    }
    
    // MARK: - Profile Header Section
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Avatar with Cosmic Glow
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.4),
                                Color.blue.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 60,
                            endRadius: 100
                        )
                    )
                    .frame(width: 140, height: 140)
                
                // Avatar Circle
                Group {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        // Default cosmic avatar
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.purple, .blue, .indigo]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                )
                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            // User Identity
            VStack(spacing: 8) {
                // Display Name
                Text(displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Username
                Text(username)
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
                
                // Bio
                if !bio.isEmpty {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .padding(.horizontal, 8)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Action Buttons Section
    
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // Edit Profile Button
            Button(action: {
                showingEditProfile = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.headline)
                    Text("Edit Profile")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.1))
                        )
                )
                .foregroundColor(.white)
            }
            
            // Settings Button
            Button(action: {
                showingSettings = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }) {
                Image(systemName: "gear")
                    .font(.headline)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color.white.opacity(0.1))
                            )
                    )
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Stats Row Section
    
    private var statsRowSection: some View {
        HStack(spacing: 0) {
            // Friends Stat
            Button(action: {
                // TODO: Navigate to friends list
                print("📱 Navigate to friends list")
            }) {
                statCard(
                    number: friendsCount,
                    label: "Friends",
                    color: .purple
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.white.opacity(0.2))
                .frame(height: 40)
            
            // Matches Stat
            Button(action: {
                // TODO: Navigate to matches view
                print("🌟 Navigate to cosmic matches")
            }) {
                statCard(
                    number: matchesCount,
                    label: "Matches",
                    color: .yellow
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.white.opacity(0.2))
                .frame(height: 40)
            
            // XP Level Stat
            Button(action: {
                // TODO: Navigate to XP/achievements
                print("⭐ Navigate to achievements")
            }) {
                statCard(
                    number: xpLevel,
                    label: "Level",
                    color: .orange
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .background(Color.white.opacity(0.2))
                .frame(height: 40)
            
            // Insights Stat
            Button(action: {
                // TODO: Navigate to insights view
                print("🧠 Navigate to insights")
            }) {
                statCard(
                    number: insightsCount,
                    label: "Insights",
                    color: .cyan
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func statCard(number: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(number)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    // MARK: - Content Tabs Section
    
    private var contentTabsSection: some View {
        VStack(spacing: 16) {
            // Tab Selector
            HStack(spacing: 0) {
                ForEach(ContentTab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedContentTab = tab
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.subheadline)
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(selectedContentTab == tab ? .purple : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(selectedContentTab == tab ? Color.purple.opacity(0.2) : Color.clear)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Content Display Section
    
    private var contentDisplaySection: some View {
        VStack(spacing: 20) {
            switch selectedContentTab {
            case .posts:
                postsContentView
            case .insights:
                insightsContentView
            case .activity:
                activityContentView
            }
        }
        .frame(minHeight: 200)
        .padding(.top, 16)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Content Views
    
    private var postsContentView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(.purple.opacity(0.6))
            
            Text("No Posts Yet")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Share your spiritual journey with the Vybe community")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                // TODO: Navigate to create post
                print("📝 Navigate to create post")
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create First Post")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.purple.opacity(0.6))
                )
            }
        }
    }
    
    private var insightsContentView: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb")
                .font(.system(size: 40))
                .foregroundColor(.yellow.opacity(0.6))
            
            Text("Spiritual Insights")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Your AI-generated insights and cosmic wisdom will appear here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                // TODO: Navigate to insights
                print("🧠 Navigate to AI insights")
            }) {
                HStack {
                    Image(systemName: "brain.head.profile")
                    Text("View All Insights")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.6))
                )
            }
        }
    }
    
    private var activityContentView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(.cyan.opacity(0.6))
            
            Text("Activity Timeline")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Your cosmic matches, insights, and spiritual journey milestones")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                // TODO: Navigate to activity view
                print("📊 Navigate to activity timeline")
            }) {
                HStack {
                    Image(systemName: "list.star")
                    Text("View Activity")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.cyan.opacity(0.6))
                )
            }
        }
    }
}

// MARK: - Supporting Sheet Views

struct EditProfileSheet: View {
    @Binding var displayName: String
    @Binding var username: String
    @Binding var bio: String
    @Binding var avatarImage: UIImage?
    
    @Environment(\.dismiss) private var dismiss
    @State private var editingDisplayName: String = ""
    @State private var editingUsername: String = ""
    @State private var editingBio: String = ""
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Picture") {
                    HStack {
                        Spacer()
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
                                                        gradient: Gradient(colors: [.purple, .blue]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                            
                                            Image(systemName: "person.circle.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                
                                // Camera overlay
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
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Basic Information") {
                    TextField("Display Name", text: $editingDisplayName)
                    
                    HStack {
                        Text("@")
                            .foregroundColor(.secondary)
                        TextField("username", text: $editingUsername)
                    }
                }
                
                Section("Bio") {
                    TextField("Tell the world about your spiritual journey...", text: $editingBio, axis: .vertical)
                        .lineLimit(5)
                    
                    HStack {
                        Spacer()
                        Text("\(editingBio.count)/160")
                            .font(.caption)
                            .foregroundColor(editingBio.count > 160 ? .red : .secondary)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(editingDisplayName.isEmpty || editingUsername.isEmpty)
                }
            }
            .onAppear {
                editingDisplayName = displayName
                editingUsername = username.replacingOccurrences(of: "@", with: "")
                editingBio = bio
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $avatarImage, sourceType: .photoLibrary)
        }
    }
    
    private func saveProfile() {
        displayName = editingDisplayName
        username = "@\(editingUsername)"
        bio = editingBio
        
        // TODO: Save to UserProfileService and sync with Firebase
        print("💾 Saving profile: \(displayName), \(username)")
    }
}

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                VStack(spacing: 16) {
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Coming Soon")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Comprehensive settings will be available here including privacy controls, notifications, and spiritual preferences.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Image Picker
// Note: Uses shared ImagePicker from NewSightingView.swift

// MARK: - Preview

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .preferredColorScheme(.dark)
    }
}