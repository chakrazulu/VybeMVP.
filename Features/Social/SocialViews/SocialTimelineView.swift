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
            userId: currentUser.userId,
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