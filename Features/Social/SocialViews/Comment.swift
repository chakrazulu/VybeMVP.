//
//  Comment.swift
//  VybeMVP
//
//  Model for comments on posts in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore

/**
 * Comment represents a user's response to a post or another comment
 * Includes spiritual context and supports threading
 */
struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    
    // Core properties
    let postId: String
    let authorId: String
    let authorName: String
    let content: String
    let timestamp: Date
    
    // Threading support
    let parentCommentId: String? // nil for top-level comments
    var replyCount: Int
    
    // Spiritual context
    let cosmicSignature: CosmicSignature
    
    // Social interactions
    var reactions: [String: Int] // reactionType -> count
    var isEdited: Bool
    var editedAt: Date?
    
    // Moderation
    let isDeleted: Bool
    
    init(
        postId: String,
        authorId: String,
        authorName: String,
        content: String,
        parentCommentId: String? = nil,
        cosmicSignature: CosmicSignature
    ) {
        self.postId = postId
        self.authorId = authorId
        self.authorName = authorName
        self.content = content
        self.timestamp = Date()
        self.parentCommentId = parentCommentId
        self.replyCount = 0
        self.cosmicSignature = cosmicSignature
        self.reactions = [:]
        self.isEdited = false
        self.editedAt = nil
        self.isDeleted = false
    }
}

// MARK: - Extensions

extension Comment {
    /**
     * Returns true if this is a reply to another comment
     */
    var isReply: Bool {
        parentCommentId != nil
    }
    
    /**
     * Returns the total reaction count
     */
    var totalReactions: Int {
        reactions.values.reduce(0, +)
    }
    
    /**
     * Returns a display string for the comment's cosmic context
     */
    var cosmicContext: String {
        "Focus \(cosmicSignature.focusNumber) • \(cosmicSignature.currentChakra.capitalized)"
    }
    
    /**
     * Returns relative time display
     */
    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        
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

// MARK: - Comment Thread Structure

/**
 * CommentThread groups a parent comment with its replies
 */
struct CommentThread: Identifiable {
    let id: String
    let parentComment: Comment
    var replies: [Comment]
    
    init(parentComment: Comment, replies: [Comment] = []) {
        self.id = parentComment.id ?? UUID().uuidString
        self.parentComment = parentComment
        self.replies = replies
    }
    
    /**
     * Total comment count including parent and all replies
     */
    var totalCount: Int {
        1 + replies.count
    }
} 