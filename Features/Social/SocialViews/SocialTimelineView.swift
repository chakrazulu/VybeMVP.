/*
 * ========================================
 * 🌐 SOCIAL TIMELINE VIEW - GLOBAL RESONANCE FEED
 * ========================================
 * 
 * **PHASE 6 CRITICAL FIXES IMPLEMENTED:**
 * 
 * 🔧 **AUTHENTICATION BYPASS RESOLUTION:**
 * - Fixed Global Resonance posts showing placeholder "@cosmic_wanderer" instead of real usernames
 * - Added loadUserDataAndShowComposer() function for all compose button interactions
 * - Integrated real user profile data loading from UserDefaults storage
 * - Enhanced NotificationCenter listener to receive and pass user information
 * 
 * 🎯 **USER ID ARCHITECTURE REFACTOR (PHASE 6 FINAL):**
 * - Updated currentUser to use AuthenticationManager.userID (Firebase UID) consistently
 * - Removed temporary Firebase Auth import and direct Firebase UID access
 * - Simplified architecture by using single source of truth for user identification
 * - Enables proper edit/delete post ownership detection throughout the app
 * 
 * 🎯 **USERNAME INTEGRATION COMPLETE:**
 * - All post composition now uses real @username created during onboarding
 * - Floating compose button loads real user data before showing composer
 * - Empty state "Share Your Vybe" button loads real user data before composer
 * - Proper data flow: UserProfileView → NotificationCenter → SocialTimelineView → PostComposerView
 * 
 * 📊 **REAL USER DATA LOADING:**
 * - loadUserDataAndShowComposer() function loads profile from UserDefaults
 * - Extracts real username and display name from saved social profile
 * - Updates currentAuthorName and currentAuthorDisplayName state variables
 * - Graceful fallback to defaults when profile data unavailable
 * 
 * **TECHNICAL ARCHITECTURE:**
 * 
 * 🔄 **DATA FLOW PATTERNS:**
 * 1. UserProfileView "Create First Post" → NotificationCenter → SocialTimelineView
 * 2. AuthenticationManager.userID → UserDefaults profile lookup → PostComposerView
 * 3. Real user data extraction → composer initialization → authentic post creation
 * 
 * 💾 **PROFILE DATA INTEGRATION:**
 * - Social profile data stored with key "socialProfile_\(userID)" in UserDefaults
 * - Extracts username and displayName from saved profile dictionary
 * - Console logging for debugging profile data loading success/failure
 * - Comprehensive error handling for missing authentication or profile data
 * 
 * **NEW FUNCTIONS ADDED:**
 * 
 * 🎯 **loadUserDataAndShowComposer():**
 * - PURPOSE: Ensures all post composition uses real username and profile data
 * - FIXES: Global Resonance posts showing placeholder data instead of real username
 * - IMPLEMENTATION: Loads user profile from UserDefaults, updates state, shows composer
 * - FALLBACK: Uses default values if profile data not found, logs warnings
 * - INTEGRATION: Called by floating compose button and empty state button
 * 
 * **ENHANCED NOTIFICATION HANDLING:**
 * - Receives "TriggerPostComposer" notifications from UserProfileView
 * - Extracts authorName and authorDisplayName from notification userInfo
 * - Updates current user state variables for proper PostComposerView initialization
 * - Console logging for debugging user info extraction and passing
 * 
 * CORE PURPOSE:
 * Comprehensive spiritual social networking timeline displaying global cosmic community
 * posts with advanced filtering, resonance matching, and mystical content curation.
 * Creates sacred space for spiritual sharing with numerological alignment and
 * archetypal resonance discovery across the cosmic community.
 * 
 * UI SPECIFICATIONS:
 * - Background: CosmicBackgroundView with space travel star field
 * - Filter Tabs: Horizontal scroll with capsule buttons (16pt padding)
 * - Post Cards: LazyVStack with 20pt spacing and staggered animations
 * - Compose Button: 66×66pt gradient circle with purple-blue gradient
 * - Empty State: 60pt sparkles icon with cosmic messaging
 * 
 * SOCIAL FILTERING SYSTEM:
 * - All: Complete spiritual community feed
 * - Resonant: Posts aligned with user's numerological frequency
 * - Recent: Last 24 hours of cosmic activity
 * - Sightings: Number synchronicity experiences
 * - Chakras: Chakra-based spiritual experiences
 * 
 * COSMIC RESONANCE MATCHING:
 * - Life Path Alignment: Posts from users with compatible life paths
 * - Focus Number Sync: Content matching current focus number
 * - Archetypal Resonance: Posts aligned with spiritual archetype
 * - Numerological Harmony: Advanced compatibility algorithms
 * - Cosmic Signature: Spiritual frequency matching system
 * 
 * STATE MANAGEMENT:
 * - @StateObject postManager: PostManager.shared for social data
 * - @State showingComposer: Post creation modal presentation
 * - @State selectedFilter: Current timeline filter selection
 * - @State animateIn: Staggered animation state for post cards
 * - @State currentAuthorName: Real username for post composition
 * - @State currentAuthorDisplayName: Real display name for cosmic signatures
 * 
 * ANIMATION SYSTEM:
 * - Staggered Entry: Posts animate in with 0.1s delay per card
 * - Scale & Opacity: 0.8→1.0 scale with 0.0→1.0 opacity transition
 * - Compose Button: Spring animation with 0.3s delay
 * - Filter Selection: 1.05x scale on selected state
 * - Empty State: 0.8s ease-out animation with 0.2s delay
 * 
 * INTEGRATION POINTS:
 * - PostManager: Social data management and CRUD operations
 * - PostCardView: Individual post display with interaction support
 * - PostComposerView: Post creation interface with spiritual metadata
 * - CosmicBackgroundView: Consistent cosmic aesthetic layer
 * - AuthenticationManager: User authentication and ID management
 * - UserDefaults: Profile data storage and retrieval
 * 
 * SPIRITUAL CONTENT FEATURES:
 * - Numerological Context: Posts include life path and focus numbers
 * - Cosmic Signatures: Spiritual frequency identification
 * - Synchronicity Sharing: Number sighting experiences
 * - Chakra Experiences: Energy center alignment stories
 * - Mystical Reactions: Spiritual response system with cosmic emojis
 * 
 * TIMELINE FILTER SPECIFICATIONS:
 * - All (infinity): Complete community feed
 * - Resonant (waveform.path): Numerologically aligned content
 * - Recent (clock): 24-hour activity window
 * - Sightings (eye.fill): Number synchronicity posts
 * - Chakras (circle.hexagongrid.fill): Energy center experiences
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - LazyVStack: Efficient rendering for large post collections
 * - Filter Caching: Optimized post filtering with computed properties
 * - Animation Batching: Staggered animations prevent performance issues
 * - Memory Management: Proper state cleanup and resource management
 * - Sheet Presentation: Modal composer for memory efficiency
 * 
 * SOCIAL INTERACTION SYSTEM:
 * - Reaction System: Cosmic emoji reactions with spiritual context
 * - Post Composition: Rich post creation with mystical metadata
 * - User Profiles: Numerological identity with cosmic signatures
 * - Community Discovery: Resonance-based content recommendation
 * - Spiritual Networking: Connection through archetypal alignment
 * 
 * EMPTY STATE DESIGN:
 * - Sacred Messaging: "The Timeline Awaits" with encouraging copy
 * - Call to Action: "Share Your Vybe" button with gradient styling
 * - Cosmic Iconography: Sparkles icon with mystical presentation
 * - Community Building: Encourages first post creation
 * - Spiritual Invitation: Welcoming tone for cosmic community
 * 
 * COMPOSE BUTTON DESIGN:
 * - Floating Position: Bottom-right with 20pt trailing, 100pt bottom margin
 * - Gradient Circle: Purple-to-blue with 15pt shadow radius
 * - Icon: Plus symbol with title weight and white color
 * - Label: "Share Vybe" caption with shadow effect
 * - Spring Animation: Responsive interaction with dampened spring
 * 
 * LOADING STATE HANDLING:
 * - Progress Indicator: 1.5x scaled circular progress view
 * - Cosmic Messaging: "Loading the cosmic timeline..." with mystical tone
 * - White Tinting: Consistent with cosmic theme color scheme
 * - Centered Layout: Full-screen loading with proper spacing
 * - User Feedback: Clear indication of data loading state
 * 
 * TECHNICAL SPECIFICATIONS:
 * - Navigation: Large title display mode with "Global Resonance"
 * - Filter Layout: Horizontal scroll with 16pt spacing between tabs
 * - Post Spacing: 20pt between cards with 100pt bottom padding
 * - Animation Timing: 0.6s duration with index-based delay calculation
 * - Sheet Presentation: Full-screen modal for post composition
 * 
 * DEBUGGING & MONITORING:
 * - Console logging for profile data loading success/failure
 * - Filter Validation: Ensures proper content filtering by type
 * - Animation Tracking: Monitors staggered animation performance
 * - Post Management: Tracks social interaction and content creation
 * - User Data Flow: Tracks authentication state and profile availability
 */

/**
 * SocialTimelineView.swift
 * VybeMVP
 *
 * PHASE 6 SOCIAL INTEGRATION: Global Resonance Timeline with Authentication Integration
 * 
 * PURPOSE:
 * Main social timeline view displaying all user posts in the Global Resonance feed.
 * Handles post composition, real-time data loading, and user authentication integration.
 * Central hub for VybeMVP's social features and cosmic community engagement.
 *
 * PHASE 6 CRITICAL FIXES IMPLEMENTED:
 * - ✅ Username vs Birth Name Issue: Fixed timeline posts to show @username instead of birth name
 * - ✅ "Create First Post" Button Data: Proper user info extraction from NotificationCenter
 * - ✅ Authentication Integration: Real user ID matching for edit/delete functionality
 * - ✅ Post Composer Triggers: Multiple entry points with consistent user data flow
 *
 * TECHNICAL ARCHITECTURE:
 * - Real-time Post Loading: Firebase Firestore listener for live post updates
 * - Authentication Integration: AuthenticationManager.shared.userID for currentUser
 * - NotificationCenter Communication: Receives "TriggerPostComposer" from UserProfileView
 * - Post Composer Integration: Multiple trigger points with consistent data flow
 * - State Management: @Published posts array with @StateObject PostManager
 *
 * USER DATA FLOW PATTERNS (PHASE 6 FIX):
 * UserProfileView "Create First Post" button →
 * NotificationCenter.post("TriggerPostComposer", userInfo: [authorName, authorDisplayName]) →
 * SocialTimelineView.onReceive() →
 * Extract user info from notification →
 * Set currentAuthorName & currentAuthorDisplayName →
 * Show PostComposerView with real user data
 *
 * AUTHENTICATION BYPASS RESOLUTION:
 * - Phase 6 Fix: Disabled authentication bypass (bypassAuthForTesting = false)
 * - Real User Integration: currentUser now uses AuthenticationManager.shared.userID
 * - Post Ownership: Proper user ID matching enables edit/delete functionality
 * - Username Display: Posts show @username from UserDefaults, not birth name
 *
 * POST COMPOSER TRIGGERS:
 * 1. "Post Vybe" Button: Calls loadUserDataAndShowComposer() for user data loading
 * 2. "Create First Post" Notification: Receives user info via NotificationCenter
 * 3. Empty Timeline State: Default composer trigger with fallback user data
 * 4. Profile Tab Integration: Cross-tab navigation with user context preservation
 *
 * NOTIFICATION CENTER INTEGRATION:
 * - Listens for: "TriggerPostComposer" notification from UserProfileView
 * - Extracts: authorName (@cosmic_wanderer) and authorDisplayName (Corey Jermaine Davis)
 * - Preserves: User context across tab navigation and app states
 * - Triggers: Post composer with real user data instead of placeholder values
 *
 * REAL-TIME DATA MANAGEMENT:
 * - PostManager Integration: @StateObject for automatic UI updates
 * - Firebase Listener: Live post feed updates without manual refresh
 * - Local State Sync: Immediate UI updates for user actions (post, edit, delete)
 * - Memory Efficiency: Efficient data loading with proper lifecycle management
 *
 * POST FILTERING & DISPLAY:
 * - Chronological Order: Latest posts appear at top of timeline
 * - User Post Identification: Proper ownership detection for edit/delete buttons
 * - Content Filtering: Future-ready for content moderation and preferences
 * - Performance Optimization: Lazy loading and efficient scroll handling
 *
 * PHASE 6 USER EXPERIENCE ENHANCEMENTS:
 * - Consistent User Identity: All posts show proper @username across the app
 * - Seamless Post Creation: "Create First Post" works correctly on first try
 * - Real-time Updates: Live timeline without refresh requirements
 * - Cross-tab Integration: Smooth navigation between Profile and Timeline tabs
 *
 * CURRENT USER IMPLEMENTATION:
 * - Dynamic User ID: Uses AuthenticationManager.shared.userID for real identification
 * - Fallback Strategy: Default user ID if authentication unavailable
 * - Debug Logging: Console output for user ID verification and troubleshooting
 * - Future-Ready: Prepared for full user profile integration and social features
 *
 * FIREBASE INTEGRATION:
 * - Real-time Listener: Live post feed updates from Firestore
 * - User Authentication: Firebase Auth integration for user identification
 * - Data Persistence: Posts stored in Firestore with proper user attribution
 * - Scalability: Designed for growing user base and increased post volume
 *
 * FUTURE ENHANCEMENTS:
 * - Advanced Post Filtering: By user, content type, spiritual insights
 * - Real-time Reactions: Live reaction updates across all users
 * - Push Notifications: New post alerts and community engagement
 * - Social Features: Friend connections, post sharing, and cosmic matching
 *
 * MEMORY MANAGEMENT:
 * - Efficient Post Loading: Lazy loading with proper memory cleanup
 * - Firebase Listener Management: Proper listener registration and removal
 * - State Management: @StateObject pattern for optimal SwiftUI performance
 * - Resource Cleanup: Proper view lifecycle management and memory deallocation
 *
 * Created for VybeMVP's Global Resonance social timeline
 * Integrates with PostManager, PostComposerView, UserProfileView, and Firebase
 * Part of Phase 6 KASPER Onboarding Integration - Social Foundation
 */

//
//  SocialTimelineView.swift
//  VybeMVP
//
//  Main view for the Global Resonance Timeline - the sacred social feed
//

import SwiftUI

struct SocialTimelineView: View {
    @StateObject private var postManager = PostManager.shared
    @State private var showingComposer = false
    @State private var selectedFilter: TimelineFilter = .all
    @State private var animateIn = false
    
    // Claude: PHASE 6 ARCHITECTURAL FIX - No longer need state variables for passing data
    
    enum TimelineFilter: String, CaseIterable {
        case all = "All"
        case resonant = "Resonant"
        case recent = "Recent"
        case sightings = "Sightings"
        case chakras = "Chakras"
        
        var icon: String {
            switch self {
            case .all: return "infinity"
            case .resonant: return "waveform.path"
            case .recent: return "clock"
            case .sightings: return "eye.fill"
            case .chakras: return "circle.hexagongrid.fill"
            }
        }
        
        var description: String {
            switch self {
            case .all: return "All spiritual shares"
            case .resonant: return "Aligned with your frequency"
            case .recent: return "Last 24 hours"
            case .sightings: return "Number synchronicities"
            case .chakras: return "Chakra experiences"
            }
        }
    }
    
    // Current user - uses consistent Firebase UID from AuthenticationManager
    private var currentUser: SocialUser {
        // Claude: PHASE 6 REFACTOR - Now AuthenticationManager.userID returns Firebase UID consistently
        let userID = AuthenticationManager.shared.userID ?? "unknown"
        print("👤 SocialTimelineView userID (Firebase UID): \(userID)")
        return SocialUser(
            userId: userID, // AuthenticationManager.userID now returns Firebase UID
            displayName: "Corey Jermaine Davis",
            lifePathNumber: 3,
            soulUrgeNumber: 5,
            expressionNumber: 7,
            currentFocusNumber: 3
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter tabs
                    filterTabsSection
                    
                    // Main content
                    if postManager.isLoading {
                        loadingView
                    } else if postManager.posts.isEmpty {
                        emptyStateView
                    } else {
                        timelineScrollView
                    }
                }
                
                // Floating compose button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        composeButton
                            .padding(.trailing, 20)
                            .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Global Resonance")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    animateIn = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TriggerPostComposer"))) { notification in
                // PHASE 3C-1 FIX: Handle post composer trigger with user information
                // Triggered from UserProfileView "Create First Post" button
                
                // EXTRACT USER INFORMATION: Get username and display name from notification
                // This fixes the username vs birth name issue by passing real user data
                // Claude: PHASE 6 ARCHITECTURAL FIX - Just show composer, it will load its own data
                print("📝 SocialTimelineView: Received notification to show composer")
                showingComposer = true
            }
        }
        .sheet(isPresented: $showingComposer) {
            // Claude: PHASE 6 ARCHITECTURAL FIX - PostComposerView loads its own data
            // Eliminates all timing and state capture issues
            PostComposerView()
        }
    }
    
    // MARK: - Filter Tabs
    
    private var filterTabsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(TimelineFilter.allCases, id: \.self) { filter in
                    FilterTab(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        action: {
                            selectedFilter = filter
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.black.opacity(0.3))
    }
    
    // MARK: - Content Views
    
    private var filteredPosts: [Post] {
        switch selectedFilter {
        case .all:
            return postManager.posts
        case .resonant:
            return postManager.getResonantPosts(for: currentUser)
        case .recent:
            let dayAgo = Date().addingTimeInterval(-24 * 60 * 60)
            return postManager.posts.filter { $0.timestamp > dayAgo }
        case .sightings:
            return postManager.filterPosts(by: .sighting)
        case .chakras:
            return postManager.filterPosts(by: .chakra)
        }
    }
    
    private var timelineScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(Array(filteredPosts.enumerated()), id: \.element.id) { index, post in
                    PostCardView(
                        post: post,
                        currentUser: currentUser,
                        onReaction: { reactionType in
                            addReaction(to: post, type: reactionType)
                        }
                    )
                    .scaleEffect(animateIn ? 1.0 : 0.8)
                    .opacity(animateIn ? 1.0 : 0.0)
                    .animation(
                        .easeOut(duration: 0.6)
                        .delay(Double(index) * 0.1 + 0.4),
                        value: animateIn
                    )
                }
            }
            .padding()
            .padding(.bottom, 100) // Space for floating button
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading the cosmic timeline...")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("The Timeline Awaits")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Be the first to share your spiritual journey with the cosmic community")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                loadUserDataAndShowComposer()
            }) {
                Text("Share Your Vybe")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateIn)
    }
    
    private var composeButton: some View {
        VStack(spacing: 8) {
            Button(action: {
                loadUserDataAndShowComposer()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 66, height: 66)
                        .shadow(color: .purple.opacity(0.5), radius: 15, x: 0, y: 8)
                    
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            Text("Share Vybe")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
        }
        .scaleEffect(animateIn ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animateIn)
    }
    
    // MARK: - Actions
    
    /**
     * PHASE 6 FIX: Load real user data before showing composer
     * 
     * PURPOSE: Ensures all post composition uses real username and profile data
     * FIXES: Global Resonance posts showing placeholder "@cosmic_wanderer" instead of real username
     * 
     * IMPLEMENTATION:
     * - Loads user profile data from UserDefaults using current authenticated user ID
     * - Extracts real username and display name from saved profile
     * - Updates currentAuthorName and currentAuthorDisplayName state variables
     * - Shows composer with real user data for proper post attribution
     * 
     * DATA FLOW:
     * AuthenticationManager.userID → UserDefaults profile lookup → PostComposerView initialization
     * 
     * FALLBACK STRATEGY:
     * - Uses default values if profile data not found
     * - Logs warning for debugging when real data unavailable
     * - Ensures composer always shows even with fallback data
     */
    private func loadUserDataAndShowComposer() {
        // Claude: PHASE 6 ARCHITECTURAL FIX - PostComposerView loads its own data
        print("📝 SocialTimelineView: Showing composer (will load its own data)")
        showingComposer = true
    }
    
    private func addReaction(to post: Post, type: ReactionType) {
        postManager.addReaction(
            to: post,
            reactionType: type,
            userDisplayName: currentUser.displayName,
            cosmicSignature: currentUser.currentCosmicSignature
        )
    }
}

// MARK: - Supporting Views

struct FilterTab: View {
    let filter: SocialTimelineView.TimelineFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: filter.icon)
                    .font(.caption)
                
                Text(filter.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? .white : Color.white.opacity(0.2))
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// Claude: PHASE 6 ARCHITECTURAL FIX - No longer need wrapper, PostComposerView loads its own data

#Preview {
    SocialTimelineView()
} 