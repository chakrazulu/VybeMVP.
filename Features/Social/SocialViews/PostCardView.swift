//
//  PostCardView.swift
//  VybeMVP
//
//  Individual post card for the Global Resonance Timeline
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    let currentUser: SocialUser
    let onReaction: (ReactionType) -> Void
    
    @State private var showingReactionPicker = false
    @State private var showingCosmicDetails = false
    @State private var showingComments = false
    @State private var showingReportSheet = false
    @State private var animateIn = false
    @State private var reactionCounts: [String: Int] = [:]
    @State private var lastReactionUpdate = Date()
    
    var body: some View {
        mainContent
            .padding(20)
            .background(cardBackground)
            .scaleEffect(animateIn ? 1.0 : 0.95)
            .opacity(animateIn ? 1.0 : 0.0)
            .sheet(isPresented: $showingReactionPicker) {
                ReactionPickerView(
                    post: post,
                    currentUser: currentUser,
                    onReaction: onReaction
                )
            }
            .sheet(isPresented: $showingComments) {
                CommentsView(
                    post: post,
                    currentUser: currentUser
                )
            }
            .sheet(isPresented: $showingReportSheet) {
                ReportContentView(
                    contentId: post.id ?? "",
                    contentType: .post,
                    reportedUserId: post.authorId,
                    reportedUserName: post.authorName,
                    reporterName: currentUser.displayName
                )
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateIn = true
                }
                // Initialize reaction counts and set a proper baseline timestamp
                reactionCounts = post.reactions
                lastReactionUpdate = Date().addingTimeInterval(-10) // Set to 10 seconds ago to avoid false triggers
            }
            .onChange(of: post.reactions) { oldValue, newValue in
                // Animate reaction count changes
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    reactionCounts = newValue
                    lastReactionUpdate = Date()
                }
            }
    }
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with author info
            headerSection
            
            // Main content
            contentSection
            
            // Sighting or Chakra specific displays
            if let sightingNumber = post.sightingNumber {
                sightingNumberDisplay(sightingNumber)
            }
            
            if let chakraType = post.chakraType {
                chakraTypeDisplay(chakraType)
            }
            
            // Cosmic signature (if available)
            if let signature = post.cosmicSignature {
                cosmicSignatureSection(signature)
            }
            
            // Interactions (reactions, comments, share)
            interactionsSection
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(post.sacredColor.opacity(0.3), lineWidth: 1)
            )
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        HStack(spacing: 12) {
            // Author's focus number circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            (post.cosmicSignature?.focusNumber != nil ? 
                                  getSacredColor(for: post.cosmicSignature!.focusNumber) : getSacredColor(for: post.sightingNumber ?? 1)).opacity(0.8),
                            (post.cosmicSignature?.focusNumber != nil ? 
                                  getSacredColor(for: post.cosmicSignature!.focusNumber) : getSacredColor(for: post.sightingNumber ?? 1)).opacity(0.4)
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Text("\(post.cosmicSignature?.focusNumber ?? post.sightingNumber ?? 1)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.authorName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Image(systemName: post.type.icon)
                        .font(.caption)
                        .foregroundColor(post.type.color)
                    
                    Text(post.type.displayName)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(timeAgoDisplay(from: post.timestamp))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // More options menu
            Menu {
                if post.authorId != currentUser.userId {
                    Button(action: {
                        showingReportSheet = true
                    }) {
                        Label("Report Post", systemImage: "exclamationmark.shield")
                    }
                }
                
                Button(action: {
                    // TODO: Implement sharing
                }) {
                    Label("Share Post", systemImage: "square.and.arrow.up")
                }
                
                if post.authorId == currentUser.userId {
                    Divider()
                    
                    Button(role: .destructive, action: {
                        // TODO: Implement delete
                    }) {
                        Label("Delete Post", systemImage: "trash")
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(8)
            }
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(post.content)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            // Special content based on post type
            if let sightingNumber = post.sightingNumber {
                sightingNumberDisplay(sightingNumber)
            }
            
            if let chakraType = post.chakraType {
                chakraTypeDisplay(chakraType)
            }
        }
    }
    
    private var tagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(post.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(post.sacredColor.opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, 1)
        }
    }
    
    private func cosmicSignatureSection(_ signature: CosmicSignature) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingCosmicDetails.toggle()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "waveform.path")
                        .font(.caption)
                        .foregroundColor(getSacredColor(for: signature.focusNumber))
                    
                    Text("Focus \(signature.focusNumber) • \(signature.currentChakra.capitalized) Chakra • Life Path \(signature.lifePathNumber)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: showingCosmicDetails ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(getSacredColor(for: signature.focusNumber).opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if showingCosmicDetails {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cosmic Alignment at Time of Posting")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        cosmicDetailItem("Focus", "\(signature.focusNumber)", getSacredColor(for: signature.focusNumber))
                        cosmicDetailItem("Chakra", signature.currentChakra.capitalized, .green)
                        cosmicDetailItem("Life Path", "\(signature.lifePathNumber)", getSacredColor(for: signature.lifePathNumber))
                        cosmicDetailItem("Realm", "\(signature.realmNumber)", getSacredColor(for: signature.realmNumber))
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                )
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: showingCosmicDetails)
            }
        }
    }
    
    private var interactionsSection: some View {
        VStack(spacing: 12) {
            // Reaction summary
            if post.totalReactions > 0 {
                reactionSummary
            }
            
            // Action buttons
            HStack(spacing: 20) {
                // React button with pulse animation
                Button(action: {
                    showingReactionPicker = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.circle")
                            .font(.title3)
                            .scaleEffect(hasRecentReactionUpdate ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasRecentReactionUpdate)
                        Text("React")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(hasRecentReactionUpdate ? .pink : .white.opacity(0.8))
                    .animation(.easeInOut(duration: 0.3), value: hasRecentReactionUpdate)
                }
                
                Spacer()
                
                // Comment button
                Button(action: {
                    showingComments = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.title3)
                        
                        if post.commentCount > 0 {
                            Text("\(post.commentCount)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .contentTransition(.numericText())
                        } else {
                            Text("Comment")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Share button (placeholder)
                Button(action: {
                    // TODO: Implement sharing
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                        Text("Share")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    private var reactionSummary: some View {
        HStack(spacing: 8) {
            ForEach(ReactionType.allCases, id: \.self) { reactionType in
                if let count = reactionCounts[reactionType.rawValue], count > 0 {
                    HStack(spacing: 4) {
                        Text(reactionType.emoji)
                            .font(.caption)
                            .scaleEffect(hasRecentUpdate(for: reactionType) ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasRecentUpdate(for: reactionType))
                        
                        Text("\(count)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .contentTransition(.numericText())
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                hasRecentUpdate(for: reactionType) ? 
                                reactionType.color.opacity(0.6) : 
                                reactionType.color.opacity(0.3)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(reactionType.color.opacity(0.8), lineWidth: hasRecentUpdate(for: reactionType) ? 1 : 0)
                            )
                    )
                    .scaleEffect(hasRecentUpdate(for: reactionType) ? 1.05 : 1.0)
                    .shadow(
                        color: hasRecentUpdate(for: reactionType) ? reactionType.color.opacity(0.4) : .clear,
                        radius: hasRecentUpdate(for: reactionType) ? 4 : 0,
                        x: 0,
                        y: hasRecentUpdate(for: reactionType) ? 2 : 0
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: hasRecentUpdate(for: reactionType))
                }
            }
            
            Spacer()
            
            if post.commentCount > 0 {
                Text("\(post.commentCount) comments")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sightingNumberDisplay(_ number: Int) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            getSacredColor(for: number).opacity(0.8),
                            getSacredColor(for: number).opacity(0.4)
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 20
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(number)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Number Sighting")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Synchronicity detected")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(getSacredColor(for: number).opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(getSacredColor(for: number).opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    private func chakraTypeDisplay(_ chakra: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .green.opacity(0.8),
                            .green.opacity(0.4)
                        ]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 20
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(chakra.capitalized) Chakra")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Energy work session")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.4), lineWidth: 1)
                )
        )
    }
    
    private func cosmicDetailItem(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Functions
    
    private func timeAgoDisplay(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d"
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     * Checks if a reaction type has been recently updated (within last 2 seconds)
     */
    private func hasRecentUpdate(for reactionType: ReactionType) -> Bool {
        let timeSinceUpdate = Date().timeIntervalSince(lastReactionUpdate)
        let currentCount = reactionCounts[reactionType.rawValue] ?? 0
        let originalCount = post.reactions[reactionType.rawValue] ?? 0
        
        // Only show glow if:
        // 1. Recent update (within 2 seconds) AND
        // 2. This reaction type actually has a count > 0 AND
        // 3. The count has actually changed from the original
        let hasCountChanged = currentCount != originalCount
        let hasValidCount = currentCount > 0
        let isRecent = timeSinceUpdate < 2.0
        
        return isRecent && hasValidCount && hasCountChanged
    }
    
    /**
     * Checks if there has been a recent reaction update
     */
    private var hasRecentReactionUpdate: Bool {
        let timeSinceUpdate = Date().timeIntervalSince(lastReactionUpdate)
        let hasAnyReactions = !reactionCounts.isEmpty && reactionCounts.values.contains(where: { $0 > 0 })
        
        // Only show recent update if:
        // 1. Less than 3 seconds since last update AND
        // 2. There are actual reactions AND  
        // 3. This isn't the initial load (lastReactionUpdate is not the same as creation)
        let isInitialLoad = abs(lastReactionUpdate.timeIntervalSince(Date())) < 1.0
        
        return timeSinceUpdate < 3.0 && hasAnyReactions && !isInitialLoad
    }
}

/**
 * Helper function to get sacred colors for numbers
 */
private func getSacredColor(for number: Int) -> Color {
    switch number {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return .green
    case 5: return .blue
    case 6: return .indigo
    case 7: return .purple
    case 8: return .brown
    case 9: return .white
    default: return .gray
    }
}

#Preview {
    let samplePost = Post(
        authorId: "sample-user",
        authorName: "Corey Jermaine Davis",
        content: "Just spotted 11:11 on my phone right as I was thinking about my spiritual journey. The universe is always speaking to us! ✨",
        type: .sighting,
        tags: ["synchronicity", "manifestation"],
        sightingNumber: 11,
        cosmicSignature: CosmicSignature(
            focusNumber: 3,
            currentChakra: "heart",
            lifePathNumber: 3,
            realmNumber: 7
        )
    )
    
    let currentUser = SocialUser(
        userId: "current-user",
        displayName: "Test User",
        lifePathNumber: 5,
        soulUrgeNumber: 2,
        expressionNumber: 8
    )
    
    PostCardView(
        post: samplePost,
        currentUser: currentUser,
        onReaction: { _ in }
    )
    .padding()
    .background(Color.black)
} 