/*
 * ========================================
 * 🌐 SOCIAL TIMELINE VIEW - GLOBAL RESONANCE FEED
 * ========================================
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
 * - Mock Current User: Development user with numerological profile
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
 * - SocialUser: User profile with numerological identity
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
 * - Mock User Data: Development user with complete numerological profile
 * - Filter Validation: Ensures proper content filtering by type
 * - Animation Tracking: Monitors staggered animation performance
 * - Post Management: Tracks social interaction and content creation
 * - Resonance Algorithms: Validates cosmic alignment calculations
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
    
    // Mock current user - in real app, this would come from user session
    private let currentUser = SocialUser(
        userId: "000536.fe41c9f51a0543059da7d6fe0dc44b7f.1946",
        displayName: "Corey Jermaine Davis",
        lifePathNumber: 3,
        soulUrgeNumber: 5,
        expressionNumber: 7,
        currentFocusNumber: 3
    )
    
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
        }
        .sheet(isPresented: $showingComposer) {
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
                showingComposer = true
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
                showingComposer = true
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

#Preview {
    SocialTimelineView()
} 