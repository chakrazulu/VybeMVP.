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
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with author info and cosmic signature
            headerSection
            
            // Post content
            contentSection
            
            // Tags (if any)
            if !post.tags.isEmpty {
                tagsSection
            }
            
            // Cosmic signature display
            if let signature = post.cosmicSignature {
                cosmicSignatureSection(signature)
            }
            
            // Reactions and interactions
            interactionsSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    post.sacredColor.opacity(0.3),
                                    post.sacredColor.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: post.sacredColor.opacity(0.2),
            radius: 10,
            x: 0,
            y: 5
        )
        .sheet(isPresented: $showingReactionPicker) {
            ReactionPickerView(
                post: post,
                currentUser: currentUser,
                onReaction: onReaction
            )
        }
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
            
            // Post type indicator
            VStack {
                Image(systemName: post.type.icon)
                    .font(.title3)
                    .foregroundColor(post.type.color)
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
                // React button
                Button(action: {
                    showingReactionPicker = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.circle")
                            .font(.title3)
                        Text("React")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Comment button (placeholder)
                Button(action: {
                    // TODO: Implement comments
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.title3)
                        Text("Comment")
                            .font(.subheadline)
                            .fontWeight(.medium)
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
                if let count = post.reactions[reactionType.rawValue], count > 0 {
                    HStack(spacing: 4) {
                        Text(reactionType.emoji)
                            .font(.caption)
                        Text("\(count)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(reactionType.color.opacity(0.3))
                    )
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