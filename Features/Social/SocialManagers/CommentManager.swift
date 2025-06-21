//
//  CommentManager.swift
//  VybeMVP
//
//  Manager for handling comments in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore
import Combine

/**
 * CommentManager handles all Firebase operations for comments
 */
class CommentManager: ObservableObject {
    static let shared = CommentManager()
    
    @Published var commentsByPost: [String: [Comment]] = [:] // postId -> comments
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var commentListeners: [String: ListenerRegistration] = [:] // postId -> listener
    private var cancellables = Set<AnyCancellable>()
    
    // Track optimistic comment updates
    private var optimisticComments: [String: Comment] = [:] // tempId -> comment
    
    private init() {}
    
    deinit {
        commentListeners.values.forEach { $0.remove() }
    }
    
    // MARK: - Real-time Listeners
    
    /**
     * Sets up real-time listener for comments on a specific post
     */
    func startListeningToComments(for postId: String) {
        // Skip if already listening
        if commentListeners[postId] != nil { return }
        
        let listener = db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Failed to listen to comments for post \(postId): \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let comments = documents.compactMap { document -> Comment? in
                    do {
                        var comment = try document.data(as: Comment.self)
                        comment.id = document.documentID
                        return comment
                    } catch {
                        print("Error decoding comment: \(error)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    self.commentsByPost[postId] = comments
                    print("🔄 Loaded \(comments.count) comments for post \(postId)")
                }
            }
        
        commentListeners[postId] = listener
    }
    
    /**
     * Stops listening to comments for a specific post
     */
    func stopListeningToComments(for postId: String) {
        commentListeners[postId]?.remove()
        commentListeners.removeValue(forKey: postId)
        commentsByPost.removeValue(forKey: postId)
    }
    
    // MARK: - Comment Operations
    
    /**
     * Adds a new comment to a post with optimistic update
     */
    func addComment(
        to postId: String,
        content: String,
        authorId: String,
        authorName: String,
        cosmicSignature: CosmicSignature,
        parentCommentId: String? = nil
    ) {
        let tempId = UUID().uuidString
        
        // Create comment
        let comment = Comment(
            postId: postId,
            authorId: authorId,
            authorName: authorName,
            content: content,
            parentCommentId: parentCommentId,
            cosmicSignature: cosmicSignature
        )
        
        // Apply optimistic update
        var optimisticComment = comment
        optimisticComment.id = tempId
        
        DispatchQueue.main.async {
            if self.commentsByPost[postId] == nil {
                self.commentsByPost[postId] = []
            }
            self.commentsByPost[postId]?.append(optimisticComment)
            self.optimisticComments[tempId] = optimisticComment
            print("⚡ Optimistic comment added to post \(postId)")
        }
        
        // Save to Firebase
        do {
            _ = try db.collection("comments").addDocument(from: comment) { [weak self] error in
                if let error = error {
                    // Remove optimistic comment on failure
                    DispatchQueue.main.async {
                        self?.commentsByPost[postId]?.removeAll { $0.id == tempId }
                        self?.optimisticComments.removeValue(forKey: tempId)
                        self?.errorMessage = "Failed to add comment: \(error.localizedDescription)"
                    }
                    print("❌ Failed to save comment: \(error.localizedDescription)")
                } else {
                    print("✅ Comment saved successfully")
                    
                    // Update post comment count
                    self?.updatePostCommentCount(postId: postId, increment: true)
                    
                    // Update parent comment reply count if this is a reply
                    if let parentId = parentCommentId {
                        self?.updateCommentReplyCount(commentId: parentId, increment: true)
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.commentsByPost[postId]?.removeAll { $0.id == tempId }
                self.optimisticComments.removeValue(forKey: tempId)
                self.errorMessage = "Failed to encode comment: \(error.localizedDescription)"
            }
        }
    }
    
    /**
     * Deletes a comment (soft delete - marks as deleted)
     */
    func deleteComment(_ comment: Comment, userId: String) {
        guard comment.authorId == userId else {
            errorMessage = "You can only delete your own comments"
            return
        }
        
        guard let commentId = comment.id else { return }
        
        db.collection("comments").document(commentId).updateData([
            "isDeleted": true,
            "content": "[deleted]"
        ]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to delete comment: \(error.localizedDescription)"
                }
            } else {
                print("✅ Comment marked as deleted")
            }
        }
    }
    
    /**
     * Edits a comment
     */
    func editComment(_ comment: Comment, newContent: String, userId: String) {
        guard comment.authorId == userId else {
            errorMessage = "You can only edit your own comments"
            return
        }
        
        guard let commentId = comment.id else { return }
        
        db.collection("comments").document(commentId).updateData([
            "content": newContent,
            "isEdited": true,
            "editedAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to edit comment: \(error.localizedDescription)"
                }
            } else {
                print("✅ Comment edited successfully")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     * Updates the comment count on a post
     */
    private func updatePostCommentCount(postId: String, increment: Bool) {
        let postRef = db.collection("posts").document(postId)
        postRef.updateData([
            "commentCount": FieldValue.increment(Int64(increment ? 1 : -1))
        ]) { error in
            if let error = error {
                print("Failed to update post comment count: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     * Updates the reply count on a parent comment
     */
    private func updateCommentReplyCount(commentId: String, increment: Bool) {
        let commentRef = db.collection("comments").document(commentId)
        commentRef.updateData([
            "replyCount": FieldValue.increment(Int64(increment ? 1 : -1))
        ]) { error in
            if let error = error {
                print("Failed to update comment reply count: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     * Gets comment threads for a post (groups replies under parent comments)
     */
    func getCommentThreads(for postId: String) -> [CommentThread] {
        guard let comments = commentsByPost[postId] else { return [] }
        
        // Separate parent comments and replies
        let parentComments = comments.filter { $0.parentCommentId == nil }
        let replies = comments.filter { $0.parentCommentId != nil }
        
        // Group replies by parent
        var replyMap: [String: [Comment]] = [:]
        for reply in replies {
            if let parentId = reply.parentCommentId {
                replyMap[parentId, default: []].append(reply)
            }
        }
        
        // Create threads
        return parentComments.map { parent in
            CommentThread(
                parentComment: parent,
                replies: replyMap[parent.id ?? ""] ?? []
            )
        }
    }
} 