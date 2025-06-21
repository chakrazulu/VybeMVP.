//
//  CommentsView.swift
//  VybeMVP
//
//  View for displaying and adding comments to posts
//

import SwiftUI

struct CommentsView: View {
    let post: Post
    let currentUser: SocialUser
    
    @StateObject private var commentManager = CommentManager.shared
    @State private var commentText = ""
    @State private var replyingTo: Comment? = nil
    @State private var showingKeyboard = false
    @FocusState private var isCommentFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Comments list
                    if commentThreads.isEmpty {
                        emptyStateView
                    } else {
                        commentsList
                    }
                    
                    // Comment input
                    commentInputSection
                }
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            commentManager.startListeningToComments(for: post.id ?? "")
        }
        .onDisappear {
            commentManager.stopListeningToComments(for: post.id ?? "")
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Computed Properties
    
    private var commentThreads: [CommentThread] {
        commentManager.getCommentThreads(for: post.id ?? "")
    }
    
    // MARK: - View Components
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No comments yet")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            
            Text("Be the first to share your cosmic wisdom")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var commentsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(commentThreads) { thread in
                    CommentThreadView(
                        thread: thread,
                        currentUser: currentUser,
                        onReply: { comment in
                            replyingTo = comment
                            isCommentFieldFocused = true
                        }
                    )
                }
            }
            .padding()
        }
    }
    
    private var commentInputSection: some View {
        VStack(spacing: 0) {
            // Reply indicator
            if let replyingTo = replyingTo {
                HStack {
                    Image(systemName: "arrow.turn.down.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Replying to \(replyingTo.authorName)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Button(action: {
                        self.replyingTo = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
            }
            
            // Comment input field
            HStack(spacing: 12) {
                // User's focus number
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                currentUser.focusColor.opacity(0.8),
                                currentUser.focusColor.opacity(0.4)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 15
                        )
                    )
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("\(currentUser.currentFocusNumber)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                // Text field
                TextField("Share your cosmic wisdom...", text: $commentText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .focused($isCommentFieldFocused)
                    .lineLimit(1...4)
                
                // Send button
                Button(action: sendComment) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(commentText.isEmpty ? .white.opacity(0.3) : .white)
                        .rotationEffect(.degrees(45))
                }
                .disabled(commentText.isEmpty)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding()
        }
        .background(Color.black.opacity(0.3))
    }
    
    // MARK: - Actions
    
    private func sendComment() {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let postId = post.id else { return }
        
        commentManager.addComment(
            to: postId,
            content: commentText,
            authorId: currentUser.userId,
            authorName: currentUser.displayName,
            cosmicSignature: currentUser.currentCosmicSignature,
            parentCommentId: replyingTo?.id
        )
        
        // Clear input
        commentText = ""
        replyingTo = nil
        isCommentFieldFocused = false
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Comment Thread View

struct CommentThreadView: View {
    let thread: CommentThread
    let currentUser: SocialUser
    let onReply: (Comment) -> Void
    
    @State private var showReplies = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Parent comment
            CommentCardView(
                comment: thread.parentComment,
                currentUser: currentUser,
                onReply: onReply,
                isReply: false
            )
            
            // Replies
            if thread.replies.count > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showReplies.toggle()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: showReplies ? "chevron.down" : "chevron.right")
                            .font(.caption)
                        
                        Text("\(thread.replies.count) \(thread.replies.count == 1 ? "reply" : "replies")")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                .padding(.leading, 48)
                
                if showReplies {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(thread.replies) { reply in
                            CommentCardView(
                                comment: reply,
                                currentUser: currentUser,
                                onReply: onReply,
                                isReply: true
                            )
                        }
                    }
                    .padding(.leading, 32)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}

#Preview {
    let samplePost = Post(
        authorId: "sample-user",
        authorName: "Cosmic Explorer",
        content: "Just had an amazing meditation session!",
        type: .reflection
    )
    
    let currentUser = SocialUser(
        userId: "current-user",
        displayName: "Test User",
        lifePathNumber: 5,
        soulUrgeNumber: 2,
        expressionNumber: 8
    )
    
    CommentsView(post: samplePost, currentUser: currentUser)
} 