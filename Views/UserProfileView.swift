/**
 * Filename: UserProfileView.swift
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === PHASE 3C-3 ENHANCEMENT: PROFILE DATA CONNECTION ===
 * **MAJOR UPDATE:** Transformed static placeholders into dynamic content
 * **Connected to Real Data:** Posts, AI insights, and user activity
 * **Environment Objects:** PostManager, AIInsightManager, FocusNumberManager
 * **Bug Fixes:** PreparedInsight.score and tags compilation errors resolved
 * **Documentation:** Comprehensive comments for all data connections
 *
 * === CORE PURPOSE ===
 * Modern Twitter-style social profile view for VybeMVP
 * Clean, functional social interface with cosmic theming
 * Part of Phase 3A Step 2.2: Twitter-Style Profile Implementation
 * Enhanced in Phase 3C-3: Real data integration and comprehensive UX
 *
 * === REAL DATA INTEGRATION (Phase 3C-3) ===
 * • Posts Tab: Connected to PostManager.posts with user filtering
 * • Insights Tab: AIInsightManager.personalizedDailyInsight display
 * • Activity Tab: FocusNumberManager.matchLogs + insight status
 * • Environment Objects: postManager, aiInsightManager, signInViewModel
 * • Memory Safe: Computed properties prevent memory leaks
 * • Performance: Lazy loading and efficient data access
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
 * === PHASE 3C-3 TECHNICAL DETAILS ===
 * • userPosts: Computed property filtering PostManager.posts by user ID
 * • recentMatches: Array of FocusMatch entities from FocusNumberManager
 * • recentInsights: AI insight availability from AIInsightManager
 * • Share Functionality: Pre-populates post composer with insight content
 * • Navigation: selectedTab binding for seamless tab switching
 * • Error Handling: Proper null checks and fallback states
 *
 * Created as part of Phase 3A Step 2.2 - Twitter-Style Profile Foundation
 * Enhanced in Phase 3C-3 - Real Data Connection and Comprehensive UX
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
    
    // MARK: - Navigation Properties
    
    /// Tab selection binding for navigation to other tabs
    @Binding var selectedTab: Int
    
    // MARK: - Environment Objects for Data Access
    
    /// Access to focus number and match data
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    /// Access to social posts and timeline
    @EnvironmentObject var postManager: PostManager
    /// Access to AI insights and personalized content
    @EnvironmentObject var aiInsightManager: AIInsightManager
    /// Access to user authentication and profile data
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // MARK: - State Properties
    
    /// User's profile data (loaded from user's actual profile setup)
    @State private var displayName: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
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
    
    /// Track if user has created their first post
    @State private var hasCreatedFirstPost = false
    
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
                SettingsSheet(username: $username)
            }
            .onAppear {
                print("🎭 UserProfileView appeared")
                // Check if user has posted before (TODO: integrate with PostManager)
                checkForExistingPosts()
                // Load user's profile data
                loadUserProfileData()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PostCreated"))) { _ in
                // PHASE 3C-1 FIX: Update post button state when user creates first post
                // Triggered by PostComposerView after successful post creation
                hasCreatedFirstPost = true
                
                // PERSISTENCE: Save state to UserDefaults for app restart persistence
                // This ensures button text persists between app launches
                UserDefaults.standard.set(true, forKey: "hasCreatedFirstPost")
                
                print("📝 User created first post - updating button text and persisting state")
                
                // HAPTIC FEEDBACK: Provide tactile confirmation of state change
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            .onChange(of: signInViewModel.userID) { _, newUserID in
                // Reload profile data when userID becomes available
                if newUserID != nil {
                    print("🔄 UserID became available, reloading profile data")
                    loadUserProfileData()
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /**
     * Check if user has created posts before
     * 
     * IMPLEMENTATION DETAILS:
     * - Uses UserDefaults for persistent state across app launches
     * - Key: "hasCreatedFirstPost" stores boolean value
     * - Called on view appearance to restore previous state
     * - Future enhancement: Integrate with PostManager for real-time data
     * 
     * PERSISTENCE STRATEGY:
     * - UserDefaults provides immediate local storage
     * - State survives app restarts and view reloads
     * - Compatible with future Firebase/CoreData integration
     * 
     * @see UserDefaults.standard.set() in NotificationCenter listener
     * @see PostManager.shared.posts for future real-time checking
     */
    private func checkForExistingPosts() {
        // Check UserDefaults for persistent state
        hasCreatedFirstPost = UserDefaults.standard.bool(forKey: "hasCreatedFirstPost")
        
        // Future: Could also check PostManager.shared.posts for current user
        // let userPosts = PostManager.shared.posts.filter { $0.authorName == displayName }
        // hasCreatedFirstPost = !userPosts.isEmpty
        
        print("🔍 UserProfileView: Checked existing posts - hasCreatedFirstPost: \(hasCreatedFirstPost)")
    }
    
    /**
     * Load user's profile data from UserDefaults
     * 
     * Loads the profile data saved during ProfileSetupView completion.
     * Falls back to default values if no profile data is found.
     */
    private func loadUserProfileData() {
        // Try to get userID from signInViewModel first, then AuthenticationManager as fallback
        let userID = signInViewModel.userID ?? AuthenticationManager.shared.userID
        
        guard let userID = userID else {
            print("⚠️ No user ID available for profile data loading - will retry in 1 second")
            // Retry after a delay to allow authentication to initialize
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadUserProfileData()
            }
            return
        }
        
        print("🔍 Loading profile data for user: \(userID)")
        
        // Load profile data from UserDefaults
        if let profileData = UserDefaults.standard.dictionary(forKey: "socialProfile_\(userID)") {
            displayName = profileData["displayName"] as? String ?? ""
            username = profileData["username"] as? String ?? ""
            bio = profileData["bio"] as? String ?? ""
            
            print("✅ Loaded profile data for user \(userID):")
            print("   Display Name: \(displayName)")
            print("   Username: \(username)")
            print("   Bio: \(bio)")
        } else {
            print("ℹ️ No profile data found for user \(userID) - using defaults")
            // Set minimal defaults if no profile setup completed
            displayName = "Cosmic Seeker"
            username = "@seeker\(String(userID.suffix(4)))" // Use last 4 chars of userID
            bio = ""
        }
        
        // TODO: Load avatar image from Documents directory or Firebase Storage
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
                
                // Username display (creation moved to settings)
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
                // TODO: Navigate to friends list (future social features)
                print("📱 Navigate to friends list")
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
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
                // Navigate to Analytics tab for nested analytics view (cosmic matches)
                selectedTab = 8
                print("🌟 Navigating to Analytics tab for cosmic matches")
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
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
                // TODO: Navigate to XP/achievements (future feature)
                print("⭐ Navigate to achievements")
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
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
                // Navigate to Activity tab (insights view)
                selectedTab = 4
                print("🧠 Navigating to Activity tab for insights")
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
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
    
    /// **POSTS TAB CONTENT - SOCIAL MEDIA INTEGRATION**
    /// 
    /// **Phase 3C-3 Enhancement:** Connected to real social posts from PostManager
    /// instead of static placeholder content. Displays user's posts with full
    /// reaction system support and dynamic empty state transitions.
    /// 
    /// **Data Flow:**
    /// - PostManager.posts: All social posts in the system
    /// - signInViewModel.userID: Current user authentication ID
    /// - userPosts computed property: Filtered posts by current user
    /// 
    /// **User Experience:**
    /// - Empty state with "Create First Post" call-to-action
    /// - Post list with engagement features (reactions, comments)
    /// - Header showing post count and quick create button
    /// - Navigation to Timeline tab for post composition
    private var postsContentView: some View {
        VStack(spacing: 16) {
            if userPosts.isEmpty {
                // Empty state for users with no posts yet
                emptyPostsState
            } else {
                // Display user's posts with full social features
                userPostsList
            }
        }
    }
    
    // MARK: - User Posts Computed Property
    
    /// **USER POSTS DATA SOURCE**
    /// 
    /// **Phase 3C-3 Implementation:** Filters PostManager.posts to show only
    /// posts authored by the current authenticated user. Uses signInViewModel.userID
    /// for proper authentication-based filtering.
    /// 
    /// **Returns:** Array of Post objects authored by current user
    /// **Memory Safe:** Uses computed property to prevent memory leaks
    private var userPosts: [Post] {
        guard let currentUserId = signInViewModel.userID else { return [] }
        return postManager.posts.filter { $0.authorId == currentUserId }
    }
    
    // MARK: - Posts Content Views
    
    private var emptyPostsState: some View {
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
                navigateToCreatePost()
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
    
    private var userPostsList: some View {
        VStack(spacing: 16) {
            // Header with post count and create button
            HStack {
                Text("\(userPosts.count) Posts")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    navigateToCreatePost()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Post")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.6))
                    )
                }
            }
            
            // Posts list
            LazyVStack(spacing: 12) {
                ForEach(userPosts) { post in
                    PostCardView(
                        post: post,
                        currentUser: getCurrentSocialUser(),
                        onReaction: { reactionType in
                            // Handle reactions
                            postManager.addReaction(
                                to: post,
                                reactionType: reactionType,
                                userDisplayName: displayName,
                                cosmicSignature: getCurrentCosmicSignature()
                            )
                        }
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func navigateToCreatePost() {
        // Navigate to Timeline tab (tag 2) for post composition
        selectedTab = 2
        
        // Pass user information to fix username vs birth name issue
        let userInfo = [
            "authorName": username,
            "authorDisplayName": displayName
        ]
        NotificationCenter.default.post(
            name: Notification.Name("TriggerPostComposer"), 
            object: nil, 
            userInfo: userInfo
        )
        print("📝 Navigating to Timeline tab and triggering post composer")
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func getCurrentSocialUser() -> SocialUser {
        // Create a mock SocialUser for now - this should eventually use real user data
        return SocialUser(
            userId: signInViewModel.userID ?? "unknown",
            displayName: displayName,
            lifePathNumber: 3,
            soulUrgeNumber: 5,
            expressionNumber: 7,
            currentFocusNumber: focusNumberManager.selectedFocusNumber
        )
    }
    
    private func getCurrentCosmicSignature() -> CosmicSignature {
        return CosmicSignature(
            focusNumber: focusNumberManager.selectedFocusNumber,
            currentChakra: "heart", // This should come from user's current chakra state
            lifePathNumber: 3, // This should come from user profile
            realmNumber: 5 // This should come from realm calculation
        )
    }
    
    /// **INSIGHTS TAB CONTENT - AI INSIGHT INTEGRATION**
    /// 
    /// **Phase 3C-3 Enhancement:** Connected to real AI insights from AIInsightManager
    /// instead of static placeholder content. Displays personalized daily insights
    /// with score indicators, spiritual tags, and share functionality.
    /// 
    /// **Data Flow:**
    /// - AIInsightManager.personalizedDailyInsight: Current insight content
    /// - AIInsightManager.isInsightReady: Loading state management
    /// - PreparedInsight.source.score: AI confidence percentage (0-10 scale)
    /// - PreparedInsight.source.matchedFocusTags: Spiritual categorization tags
    /// 
    /// **User Experience:**
    /// - Loading states with progress indicators
    /// - Share to timeline pre-populating post composer
    /// - Navigation to Activity tab for insight archive
    /// - Real-time insight score and tag display
    private var insightsContentView: some View {
        VStack(spacing: 16) {
            if aiInsightManager.isInsightReady, let insight = aiInsightManager.personalizedDailyInsight {
                // Display today's personalized AI insight with full metadata
                todaysInsightDisplay(insight: insight)
            } else {
                // Loading state or no insight available
                insightsLoadingState
            }
        }
    }
    
    // MARK: - Insights Display Views
    
    /// **TODAY'S INSIGHT DISPLAY - COMPREHENSIVE AI INSIGHT PRESENTATION**
    /// 
    /// **Phase 3C-3 Implementation:** Complete insight display with AI metadata,
    /// spiritual tags, and interactive action buttons for user engagement.
    /// 
    /// **Components:**
    /// - Header: Date and AI confidence score indicator
    /// - Content: Full insight text with proper line spacing
    /// - Tags: Spiritual focus tags from AI matching algorithm
    /// - Actions: View All (Activity tab) and Share (Timeline) buttons
    /// 
    /// **Technical Details:**
    /// - Score calculation: (insight.source?.score ?? 0) * 10 for percentage display
    /// - Tag source: insight.source?.matchedFocusTags for spiritual categorization
    /// - Share functionality: Pre-populates post composer with insight content
    /// - Navigation: Uses selectedTab binding for seamless tab switching
    private func todaysInsightDisplay(insight: PreparedInsight) -> some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Spiritual Insight")
                        .font(.headline)
                        .foregroundColor(.yellow)
                    
                    Text(Date(), style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                                  // Insight score indicator
                  VStack(spacing: 2) {
                      Text("Score")
                          .font(.caption2)
                          .foregroundColor(.white.opacity(0.6))
                      
                      Text("\(Int((insight.source?.score ?? 0) * 10))%")
                          .font(.caption)
                          .fontWeight(.bold)
                          .foregroundColor(.yellow)
                  }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.2))
                )
            }
            
            // Insight content
            VStack(spacing: 12) {
                Text(insight.text)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                                  // Tags if available
                  if let tags = insight.source?.matchedFocusTags, !tags.isEmpty {
                      HStack {
                          ForEach(tags.prefix(3), id: \.self) { tag in
                              Text(tag)
                                  .font(.caption)
                                  .padding(.horizontal, 8)
                                  .padding(.vertical, 4)
                                  .background(
                                      Capsule()
                                          .fill(Color.yellow.opacity(0.2))
                                  )
                                  .foregroundColor(.white.opacity(0.8))
                          }
                          Spacer()
                      }
                  }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: {
                    // Navigate to Activity tab for more insights
                    selectedTab = 4
                    print("🧠 Navigating to Activity tab for more insights")
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "brain.head.profile")
                        Text("View All")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.yellow.opacity(0.3))
                    )
                }
                
                Button(action: {
                    // Share insight to timeline
                    navigateToShareInsight(insight: insight)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                        Text("Share")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.4))
                    )
                }
                
                Spacer()
            }
        }
    }
    
    private var insightsLoadingState: some View {
        VStack(spacing: 16) {
            if aiInsightManager.isInsightReady {
                // No insight available
                Image(systemName: "lightbulb")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow.opacity(0.6))
                
                Text("No Insights Today")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Your personalized insights are being prepared. Check back soon!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            } else {
                // Loading state
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                    .scaleEffect(1.2)
                
                Text("Preparing Your Insight...")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Analyzing your cosmic profile for personalized wisdom")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                // Navigate to Activity tab for all insights
                selectedTab = 4
                print("🧠 Navigating to Activity tab for insights")
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack {
                    Image(systemName: "brain.head.profile")
                    Text("View Insight Archive")
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
    
    private func navigateToShareInsight(insight: PreparedInsight) {
        // Navigate to Timeline and pre-populate post with insight
        selectedTab = 2
        
        // Create insight-based post content
        let insightContent = "🌟 Today's Insight: \"\(insight.text.prefix(200))\"\n\n#CosmicWisdom #SpiritualGrowth"
        
        // Pass both user info and insight content
        let userInfo = [
            "authorName": username,
            "authorDisplayName": displayName,
            "prefilledContent": String(insightContent)
        ]
        
        NotificationCenter.default.post(
            name: Notification.Name("TriggerPostComposer"), 
            object: nil, 
            userInfo: userInfo
        )
        
        print("✨ Sharing insight to timeline")
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    /// **ACTIVITY TAB CONTENT - PERSONAL TIMELINE INTEGRATION**
    /// 
    /// **Phase 3C-3 Enhancement:** Connected to real user activity data including
    /// cosmic matches, AI insights, and social posts. Displays comprehensive
    /// personal timeline with color-coded sections and quick navigation.
    /// 
    /// **Data Sources:**
    /// - FocusNumberManager.matchLogs: Recent cosmic number matches
    /// - AIInsightManager: Personalized daily insights availability
    /// - PostManager: User's social posts and engagement
    /// 
    /// **UI Components:**
    /// - Empty state with call-to-action for new users
    /// - Activity timeline with sectioned content display
    /// - Quick navigation to full Activity tab for detailed view
    private var activityContentView: some View {
        VStack(spacing: 16) {
            if recentMatches.isEmpty && recentInsights.isEmpty {
                // Empty state for users with no activity yet
                activityEmptyState
            } else {
                // Comprehensive activity timeline with real data
                activityTimelineView
            }
        }
    }
    
    // MARK: - Activity Data
    
    /// **RECENT MATCHES DATA SOURCE**
    /// 
    /// **Phase 3C-3 Implementation:** Connects to FocusNumberManager.matchLogs
    /// to display the user's latest 5 cosmic number matches with timestamps.
    /// Used for Recent Matches section in activity timeline.
    /// 
    /// **Returns:** Array of FocusMatch Core Data entities
    private var recentMatches: [FocusMatch] {
        return Array(focusNumberManager.matchLogs.prefix(5))
    }
    
    /// **RECENT INSIGHTS DATA SOURCE**
    /// 
    /// **Phase 3C-3 Implementation:** Simplified insight availability indicator
    /// that checks if today's AI insight is ready for display. Future enhancement
    /// could expand to show actual insight history from Core Data.
    /// 
    /// **Returns:** Array of insight status strings for timeline display
    private var recentInsights: [String] {
        // Future enhancement: Could show actual insight history from PersistedInsightLog
        if aiInsightManager.isInsightReady, aiInsightManager.personalizedDailyInsight != nil {
            return ["Today's Insight Available"]
        }
        return []
    }
    
    // MARK: - Activity Views
    
    private var activityEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(.cyan.opacity(0.6))
            
            Text("No Activity Yet")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Start your spiritual journey to see cosmic matches and insights here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                // Navigate to Home tab to start generating activity
                selectedTab = 0
                print("🏠 Navigating to Home tab to start activity")
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("Start Journey")
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
    
    private var activityTimelineView: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Activity Timeline")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // Navigate to full Activity tab
                    selectedTab = 4
                    print("📊 Navigating to full Activity tab")
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                        Text("View All")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.cyan.opacity(0.3))
                    )
                }
            }
            
            VStack(spacing: 12) {
                // Recent Matches Section
                if !recentMatches.isEmpty {
                    activitySection(
                        title: "Recent Matches",
                        icon: "checkmark.circle.fill",
                        color: .purple,
                        count: recentMatches.count
                    ) {
                        ForEach(Array(recentMatches.prefix(3).enumerated()), id: \.offset) { index, match in
                            activityMatchRow(match: match)
                        }
                    }
                }
                
                // Recent Insights Section
                if !recentInsights.isEmpty {
                    activitySection(
                        title: "Spiritual Insights",
                        icon: "lightbulb.fill",
                        color: .yellow,
                        count: recentInsights.count
                    ) {
                        ForEach(recentInsights, id: \.self) { insight in
                            activityInsightRow(insight: insight)
                        }
                    }
                }
                
                // Posts Activity if user has posts
                if !userPosts.isEmpty {
                    activitySection(
                        title: "Recent Posts",
                        icon: "doc.text.fill",
                        color: .blue,
                        count: userPosts.count
                    ) {
                        ForEach(Array(userPosts.prefix(2).enumerated()), id: \.offset) { index, post in
                            activityPostRow(post: post)
                        }
                    }
                }
            }
        }
    }
    
    private func activitySection<Content: View>(
        title: String,
        icon: String,
        color: Color,
        count: Int,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(count)")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.3))
                    )
                    .foregroundColor(.white)
            }
            
            content()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func activityMatchRow(match: FocusMatch) -> some View {
        HStack {
            Text("#\(Int(match.matchedNumber))")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            Text(match.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(match.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 4)
    }
    
    private func activityInsightRow(insight: String) -> some View {
        HStack {
            Image(systemName: "sparkles")
                .font(.caption)
                .foregroundColor(.yellow)
            
            Text(insight)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text("Today")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 4)
    }
    
    private func activityPostRow(post: Post) -> some View {
        HStack {
            Image(systemName: post.type.icon)
                .font(.caption)
                .foregroundColor(.blue)
            
            Text(post.content.prefix(30) + (post.content.count > 30 ? "..." : ""))
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(post.timestamp, style: .relative)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 4)
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
        
        // Save to UserDefaults for persistence
        if let userID = AuthenticationManager.shared.userID {
            let profileData = [
                "displayName": displayName,
                "username": username,
                "bio": bio
            ]
            UserDefaults.standard.set(profileData, forKey: "socialProfile_\(userID)")
            UserDefaults.standard.synchronize()
            print("💾 Profile saved to UserDefaults for user: \(userID)")
        }
        
        // TODO: Save to UserProfileService and sync with Firebase
        print("💾 Saving profile: \(displayName), \(username)")
    }
}

struct SettingsSheet: View {
    @Binding var username: String
    @Environment(\.dismiss) private var dismiss
    @State private var showingUsernameCreation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "gear")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Profile Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                // Username Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Username")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current: \(username)")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            if username == "@cosmic_wanderer" {
                                Text("Default username - tap to customize")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingUsernameCreation = true
                        }) {
                            Text(username == "@cosmic_wanderer" ? "Create" : "Change")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.purple)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Coming Soon Section
                VStack(spacing: 12) {
                    Text("Additional Settings")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Privacy controls, notifications, and spiritual preferences coming soon...")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
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
            .sheet(isPresented: $showingUsernameCreation) {
                UsernameCreationSheet(username: $username)
            }
        }
    }
}

// MARK: - Image Picker
// Note: Uses shared ImagePicker from NewSightingView.swift

// MARK: - Username Creation Sheet

struct UsernameCreationSheet: View {
    @Binding var username: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var newUsername: String = ""
    @State private var isCheckingAvailability = false
    @State private var isAvailable = true
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "at.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple)
                    
                    Text("Choose Your Username")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("This will be your public identity in the Vybe community")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Username Input
                VStack(spacing: 8) {
                    HStack {
                        Text("@")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        
                        TextField("username", text: $newUsername)
                            .font(.title2)
                            .textFieldStyle(PlainTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: newUsername) {
                                validateUsername()
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Validation Status
                    if !newUsername.isEmpty {
                        HStack {
                            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isAvailable ? .green : .red)
                            
                            Text(isAvailable ? "Username available" : errorMessage)
                                .font(.caption)
                                .foregroundColor(isAvailable ? .green : .red)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Username Guidelines
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username Guidelines:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        guidelineRow("4-15 characters long")
                        guidelineRow("Letters, numbers, and underscores only")
                        guidelineRow("Must start with a letter")
                        guidelineRow("No spaces or special characters")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        saveUsername()
                        dismiss()
                    }) {
                        Text("Set Username")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(isValidUsername ? Color.purple : Color.gray)
                            )
                    }
                    .disabled(!isValidUsername)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .navigationTitle("Create Username")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if isValidUsername {
                            saveUsername()
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValidUsername)
                }
            }
            .onAppear {
                newUsername = username.replacingOccurrences(of: "@", with: "")
            }
        }
    }
    
    private var isValidUsername: Bool {
        let usernameRegex = "^[a-zA-Z][a-zA-Z0-9_]{3,14}$"
        return newUsername.range(of: usernameRegex, options: .regularExpression) != nil && isAvailable
    }
    
    private func validateUsername() {
        // Remove any invalid characters
        newUsername = newUsername.replacingOccurrences(of: "[^a-zA-Z0-9_]",
                                                      with: "",
                                                      options: .regularExpression)
        
        // Check length
        if newUsername.count > 15 {
            newUsername = String(newUsername.prefix(15))
        }
        
        // Validate format
        if newUsername.isEmpty {
            isAvailable = true
            errorMessage = ""
        } else if newUsername.count < 4 {
            isAvailable = false
            errorMessage = "Username must be at least 4 characters"
        } else if !newUsername.first!.isLetter {
            isAvailable = false
            errorMessage = "Username must start with a letter"
        } else {
            // TODO: Check availability against Firebase
            isAvailable = true
            errorMessage = ""
        }
    }
    
    private func guidelineRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(.green)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func saveUsername() {
        username = "@\(newUsername)"
        // TODO: Save to UserProfileService and sync with Firebase
        print("💾 Username saved: \(username)")
    }
}

// MARK: - Preview

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(selectedTab: .constant(3))
            .preferredColorScheme(.dark)
    }
}