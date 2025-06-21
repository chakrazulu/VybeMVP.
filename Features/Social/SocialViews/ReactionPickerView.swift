//
//  ReactionPickerView.swift
//  VybeMVP
//
//  Energy-based reaction picker for the Global Resonance Timeline
//

import SwiftUI

struct ReactionPickerView: View {
    let post: Post
    let currentUser: SocialUser
    let onReaction: (ReactionType) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReaction: ReactionType?
    @State private var animateIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        headerSection
                        
                        // Reaction options
                        reactionGrid
                        
                        // Current cosmic signature
                        cosmicSignatureSection
                        
                        // Add some bottom padding for better scrolling
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationTitle("React with Energy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let selectedReaction = selectedReaction {
                        Button(action: {
                            sendReaction(selectedReaction)
                        }) {
                            HStack(spacing: 6) {
                                Text(selectedReaction.emoji)
                                    .font(.title3)
                                Text("Send")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selectedReaction.color.opacity(0.8))
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            Text("How does this post resonate with your energy?")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Post preview
            VStack(spacing: 12) {
                HStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(post.sacredColor).opacity(0.8),
                                    Color(post.sacredColor).opacity(0.4)
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 15
                            )
                        )
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text("\(post.cosmicSignature?.focusNumber ?? 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text(post.authorName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(post.sacredColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6), value: animateIn)
    }
    
    private var reactionGrid: some View {
        VStack(spacing: 20) {
            Text("Choose your energetic response")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(Array(ReactionType.allCases.enumerated()), id: \.element) { index, reactionType in
                    ReactionButton(
                        reactionType: reactionType,
                        isSelected: selectedReaction == reactionType,
                        action: {
                            selectedReaction = reactionType
                        }
                    )
                    .scaleEffect(animateIn ? 1.0 : 0.6)
                    .opacity(animateIn ? 1.0 : 0.0)
                    .animation(
                        .easeOut(duration: 0.5)
                        .delay(Double(index) * 0.1 + 0.3),
                        value: animateIn
                    )
                }
            }
        }
    }
    
    private var cosmicSignatureSection: some View {
        VStack(spacing: 12) {
            Text("Your Current Cosmic State")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            HStack(spacing: 16) {
                // Focus number
                VStack(spacing: 4) {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    currentUser.focusColor.opacity(0.8),
                                    currentUser.focusColor.opacity(0.4)
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(currentUser.currentFocusNumber)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text("Focus")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Chakra
                VStack(spacing: 4) {
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
                    
                    Text("Heart")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Life Path
                VStack(spacing: 4) {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    currentUser.primarySacredColor.opacity(0.8),
                                    currentUser.primarySacredColor.opacity(0.4)
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(currentUser.lifePathNumber)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    Text("Life Path")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(currentUser.focusColor.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(animateIn ? 1.0 : 0.8)
        .opacity(animateIn ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateIn)
    }
    
    // MARK: - Actions
    
    private func sendReaction(_ reaction: ReactionType) {
        print("🎯 Sending reaction: \(reaction.rawValue)")
        
        onReaction(reaction)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Dismiss the sheet
        dismiss()
    }
}

// MARK: - Supporting Views

struct ReactionButton: View {
    let reactionType: ReactionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Emoji circle
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                reactionType.color.opacity(isSelected ? 0.8 : 0.4),
                                reactionType.color.opacity(isSelected ? 0.6 : 0.2)
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(reactionType.emoji)
                            .font(.system(size: 32))
                    )
                    .shadow(
                        color: isSelected ? reactionType.color.opacity(0.4) : .clear,
                        radius: isSelected ? 10 : 0,
                        x: 0,
                        y: isSelected ? 5 : 0
                    )
                
                VStack(spacing: 4) {
                    Text(reactionType.displayName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(reactionType.description)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .shadow(
            color: isSelected ? reactionType.color.opacity(0.4) : .clear,
            radius: isSelected ? 10 : 0,
            x: 0,
            y: isSelected ? 5 : 0
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    let samplePost = Post(
        authorId: "sample-user",
        authorName: "Corey Jermaine Davis",
        content: "Just had the most incredible meditation session. The universe is speaking through the silence! 🧘‍♂️✨",
        type: .reflection,
        tags: ["meditation", "inner-wisdom"],
        cosmicSignature: CosmicSignature(
            focusNumber: 7,
            currentChakra: "crown",
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
    
    ReactionPickerView(
        post: samplePost,
        currentUser: currentUser,
        onReaction: { _ in }
    )
} 