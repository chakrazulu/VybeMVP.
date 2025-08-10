//
//  CommentCardView.swift
//  VybeMVP
//
//  Individual comment card display
//

import SwiftUI

struct CommentCardView: View {
    let comment: Comment
    let currentUser: SocialUser
    let onReply: (Comment) -> Void
    let isReply: Bool

    @State private var showingActions = false
    @State private var animateIn = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Author's focus number avatar
            avatarView

            VStack(alignment: .leading, spacing: 8) {
                // Header with author info
                headerSection

                // Comment content
                contentSection

                // Actions row
                actionsSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(isReply ? 12 : 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(isReply ? 0.03 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            comment.cosmicSignature.focusNumber == currentUser.currentFocusNumber ?
                            currentUser.focusColor.opacity(0.3) :
                            Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(animateIn ? 1.0 : 0.95)
        .opacity(animateIn ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                animateIn = true
            }
        }
    }

    // MARK: - View Components

    private var avatarView: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        getSacredColor(for: comment.cosmicSignature.focusNumber).opacity(0.8),
                        getSacredColor(for: comment.cosmicSignature.focusNumber).opacity(0.4)
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 20
                )
            )
            .frame(width: isReply ? 32 : 40, height: isReply ? 32 : 40)
            .overlay(
                Text("\(comment.cosmicSignature.focusNumber)")
                    .font(isReply ? .caption : .callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
            .shadow(
                color: getSacredColor(for: comment.cosmicSignature.focusNumber).opacity(0.3),
                radius: 4,
                x: 0,
                y: 2
            )
    }

    private var headerSection: some View {
        HStack(spacing: 8) {
            Text(comment.authorName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            // Cosmic context
            Text("• \(comment.cosmicContext)")
                .font(.caption)
                .foregroundColor(getSacredColor(for: comment.cosmicSignature.focusNumber).opacity(0.8))

            Spacer()

            // Time and edit indicator
            HStack(spacing: 4) {
                if comment.isEdited {
                    Text("edited")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }

                Text(comment.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }

    private var contentSection: some View {
        Text(comment.content)
            .font(.body)
            .foregroundColor(comment.isDeleted ? .white.opacity(0.5) : .white.opacity(0.9))
            .italic(comment.isDeleted)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
    }

    private var actionsSection: some View {
        HStack(spacing: 20) {
            // Reply button
            if !comment.isDeleted {
                Button(action: {
                    onReply(comment)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.turn.down.right")
                            .font(.caption)
                        Text("Reply")
                            .font(.caption)
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
            }

            // Reaction count (if any)
            if comment.totalReactions > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                    Text("\(comment.totalReactions)")
                        .font(.caption2)
                }
                .foregroundColor(.pink.opacity(0.8))
            }

            Spacer()

            // More actions (for comment author)
            if comment.authorId == currentUser.userId && !comment.isDeleted {
                Menu {
                    Button(action: {
                        // TODO: Implement edit
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive, action: {
                        // TODO: Implement delete
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(4)
                }
            }
        }
    }
}

// Helper function
private func getSacredColor(for number: Int) -> Color {
    switch number {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return .green
    case 5: return .blue
    case 6: return .indigo
    case 7: return .purple
    case 8: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
    case 9: return .white
    default: return .gray
    }
}

#Preview {
    let sampleComment = Comment(
        postId: "sample-post",
        authorId: "sample-user",
        authorName: "Cosmic Sage",
        content: "This resonates deeply with my spiritual journey. The synchronicities are becoming more frequent!",
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

    CommentCardView(
        comment: sampleComment,
        currentUser: currentUser,
        onReply: { _ in },
        isReply: false
    )
    .padding()
    .background(Color.black)
}
