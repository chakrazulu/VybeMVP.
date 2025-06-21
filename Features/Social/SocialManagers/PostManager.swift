//
//  PostManager.swift
//  VybeMVP
//
//  Manager for handling posts and reactions in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore
import Combine
import UIKit

/**
 * PostManager handles all Firebase operations for the social timeline
 */
class PostManager: ObservableObject {
    static let shared = PostManager()
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var postsListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupRealtimeListener()
    }
    
    deinit {
        postsListener?.remove()
    }
    
    // MARK: - Real-time Listener
    
    /**
     * Sets up real-time listener for posts collection
     */
    private func setupRealtimeListener() {
        postsListener = db.collection("posts")
            .order(by: "timestamp", descending: true)
            .limit(to: 50) // Load latest 50 posts
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load posts: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        self.posts = []
                        self.isLoading = false
                    }
                    return
                }
                
                let loadedPosts = documents.compactMap { document -> Post? in
                    do {
                        var post = try document.data(as: Post.self)
                        post.id = document.documentID
                        return post
                    } catch {
                        print("Error decoding post: \(error)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    self.posts = loadedPosts
                    self.isLoading = false
                    self.errorMessage = nil
                }
            }
    }
    
    // MARK: - Post Operations
    
    /**
     * Creates a new post in Firebase
     */
    func createPost(
        authorId: String,
        authorName: String,
        content: String,
        type: PostType,
        tags: [String] = [],
        imageURL: String? = nil,
        sightingNumber: Int? = nil,
        chakraType: String? = nil,
        journalExcerpt: String? = nil,
        cosmicSignature: CosmicSignature? = nil
    ) {
        let post = Post(
            authorId: authorId,
            authorName: authorName,
            content: content,
            type: type,
            tags: tags,
            imageURL: imageURL,
            sightingNumber: sightingNumber,
            chakraType: chakraType,
            journalExcerpt: journalExcerpt,
            cosmicSignature: cosmicSignature
        )
        
        do {
            _ = try db.collection("posts").addDocument(from: post) { [weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to create post: \(error.localizedDescription)"
                    }
                } else {
                    print("Post created successfully!")
                    // Haptic feedback for successful post
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to encode post: \(error.localizedDescription)"
            }
        }
    }
    
    /**
     * Deletes a post (only if user is the author)
     */
    func deletePost(_ post: Post, currentUserId: String) {
        guard post.authorId == currentUserId else {
            errorMessage = "You can only delete your own posts"
            return
        }
        
        guard let postId = post.id else {
            errorMessage = "Invalid post ID"
            return
        }
        
        db.collection("posts").document(postId).delete { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to delete post: \(error.localizedDescription)"
                }
            } else {
                print("Post deleted successfully!")
            }
        }
    }
    
    // MARK: - Reaction Operations
    
    /**
     * Adds a reaction to a post
     */
    func addReaction(
        to post: Post,
        reactionType: ReactionType,
        userId: String,
        userDisplayName: String,
        cosmicSignature: CosmicSignature
    ) {
        guard let postId = post.id else {
            errorMessage = "Invalid post ID"
            print("❌ Cannot add reaction: Post ID is nil")
            return
        }
        
        print("🔄 Adding reaction \(reactionType.rawValue) to post \(postId) by user \(userDisplayName)")
        
        // Create reaction document
        let reaction = Reaction(
            postId: postId,
            userId: userId,
            userDisplayName: userDisplayName,
            reactionType: reactionType,
            cosmicSignature: cosmicSignature
        )
        
        // Add reaction to reactions collection
        do {
            let reactionRef = try db.collection("reactions").addDocument(from: reaction) { [weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to add reaction: \(error.localizedDescription)"
                    }
                    print("❌ Failed to save reaction to Firebase: \(error.localizedDescription)")
                } else {
                    print("✅ Reaction saved successfully to reactions collection")
                    // Update post's reaction count
                    self?.updatePostReactionCount(postId: postId, reactionType: reactionType, increment: true)
                    
                    // Haptic feedback for reaction
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
            print("📄 Created reaction document with ID: \(reactionRef.documentID)")
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to encode reaction: \(error.localizedDescription)"
            }
            print("❌ Failed to encode reaction: \(error.localizedDescription)")
        }
    }
    
    /**
     * Removes a reaction from a post
     */
    func removeReaction(
        from post: Post,
        reactionType: ReactionType,
        userId: String
    ) {
        guard let postId = post.id else {
            errorMessage = "Invalid post ID"
            return
        }
        
        // Find and delete the user's reaction
        db.collection("reactions")
            .whereField("postId", isEqualTo: postId)
            .whereField("userId", isEqualTo: userId)
            .whereField("reactionType", isEqualTo: reactionType.rawValue)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to find reaction: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    return
                }
                
                // Delete the reaction document
                let reactionDoc = documents.first!
                reactionDoc.reference.delete { [weak self] error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.errorMessage = "Failed to remove reaction: \(error.localizedDescription)"
                        }
                    } else {
                        // Update post's reaction count
                        self?.updatePostReactionCount(postId: postId, reactionType: reactionType, increment: false)
                    }
                }
            }
    }
    
    /**
     * Updates the reaction count on a post document
     */
    private func updatePostReactionCount(postId: String, reactionType: ReactionType, increment: Bool) {
        let postRef = db.collection("posts").document(postId)
        
        // First, check if the reactions field exists, and create it if not
        postRef.getDocument { document, error in
            if let error = error {
                print("Failed to fetch post for reaction update: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Post document does not exist")
                return
            }
            
            let data = document.data() ?? [:]
            let currentReactions = data["reactions"] as? [String: Int] ?? [:]
            let currentCount = currentReactions[reactionType.rawValue] ?? 0
            let newCount = increment ? currentCount + 1 : max(0, currentCount - 1)
            
            // Update the specific reaction count
            var updatedReactions = currentReactions
            if newCount > 0 {
                updatedReactions[reactionType.rawValue] = newCount
            } else {
                updatedReactions.removeValue(forKey: reactionType.rawValue)
            }
            
            postRef.updateData([
                "reactions": updatedReactions
            ]) { error in
                if let error = error {
                    print("Failed to update reaction count: \(error.localizedDescription)")
                } else {
                    print("Successfully updated reaction count for \(reactionType.rawValue): \(increment ? "+" : "-")1")
                }
            }
        }
    }
    
    // MARK: - Filtering and Search
    
    /**
     * Filters posts by spiritual tags
     */
    func filterPosts(by tags: [String]) -> [Post] {
        guard !tags.isEmpty else { return posts }
        
        return posts.filter { post in
            !Set(post.tags).isDisjoint(with: Set(tags))
        }
    }
    
    /**
     * Filters posts by post type
     */
    func filterPosts(by type: PostType) -> [Post] {
        return posts.filter { $0.type == type }
    }
    
    /**
     * Filters posts by cosmic signature elements
     */
    func filterPosts(by focusNumber: Int) -> [Post] {
        return posts.filter { post in
            post.cosmicSignature?.focusNumber == focusNumber ||
            post.sightingNumber == focusNumber
        }
    }
    
    /**
     * Gets posts from users with similar numerological profiles
     */
    func getResonantPosts(for userProfile: SocialUser) -> [Post] {
        return posts.filter { post in
            guard let signature = post.cosmicSignature else { return false }
            
            // Check for numerological resonance
            return signature.lifePathNumber == userProfile.lifePathNumber ||
                   signature.focusNumber == userProfile.currentFocusNumber ||
                   signature.realmNumber == userProfile.expressionNumber
        }
    }
    
    // MARK: - Analytics
    
    /**
     * Gets reaction statistics for a post
     */
    func getReactionStats(for post: Post) -> [ReactionType: Int] {
        return post.reactions.compactMapValues { count in
            count > 0 ? count : nil
        }.reduce(into: [ReactionType: Int]()) { result, pair in
            if let reactionType = ReactionType(rawValue: pair.key) {
                result[reactionType] = pair.value
            }
        }
    }
} 