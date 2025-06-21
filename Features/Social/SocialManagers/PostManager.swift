//
//  PostManager.swift
//  VybeMVP
//
//  Manager for handling posts and reactions in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
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
    private var reactionListeners: [String: ListenerRegistration] = [:] // postId -> listener
    private var cancellables = Set<AnyCancellable>()
    
    // Track optimistic reaction updates
    private var optimisticReactions: [String: [String: Int]] = [:] // postId -> [reactionType: count]
    
    private init() {
        setupRealtimeListener()
    }
    
    deinit {
        postsListener?.remove()
        reactionListeners.values.forEach { $0.remove() }
    }
    
    // MARK: - Authentication Helper
    
    /**
     * Gets the current Firebase UID for authenticated operations
     */
    private var currentFirebaseUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /**
     * Validates that the user is authenticated before performing operations
     */
    private func validateAuthentication() -> String? {
        guard let uid = currentFirebaseUID else {
            errorMessage = "You must be signed in to perform this action"
            return nil
        }
        return uid
    }
    
    // MARK: - Real-time Listeners
    
    /**
     * Sets up real-time listener for posts collection
     */
    private func setupRealtimeListener() {
        isLoading = true
        
        postsListener = db.collection("posts")
            .order(by: "timestamp", descending: true)
            .limit(to: 50) // Load latest 50 posts
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Failed to load posts: \(error.localizedDescription)")
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
                        
                        // Apply optimistic reaction updates if they exist
                        if let optimistic = self.optimisticReactions[document.documentID] {
                            var updatedReactions = post.reactions
                            for (reactionType, count) in optimistic {
                                updatedReactions[reactionType] = count
                            }
                            post.reactions = updatedReactions
                        }
                        
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
                    
                    // Set up reaction listeners for new posts
                    self.setupReactionListeners(for: loadedPosts)
                }
                
                print("✅ Loaded \(loadedPosts.count) posts from Firebase")
            }
    }
    
    /**
     * Sets up real-time listeners for post reactions
     */
    private func setupReactionListeners(for posts: [Post]) {
        for post in posts {
            guard let postId = post.id else { continue }
            
            // Skip if we already have a listener for this post
            if reactionListeners[postId] != nil { continue }
            
            let listener = db.collection("reactions")
                .whereField("postId", isEqualTo: postId)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("❌ Failed to listen to reactions for post \(postId): \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    // Count reactions by type
                    var reactionCounts: [String: Int] = [:]
                    for document in documents {
                        if let reactionType = document.data()["reactionType"] as? String {
                            reactionCounts[reactionType, default: 0] += 1
                        }
                    }
                    
                    // Update the post's reaction counts in real-time
                    DispatchQueue.main.async {
                        if let postIndex = self.posts.firstIndex(where: { $0.id == postId }) {
                            self.posts[postIndex].reactions = reactionCounts
                            print("🔄 Real-time reaction update for post \(postId): \(reactionCounts)")
                        }
                        
                        // Clear optimistic updates since we have real data
                        self.optimisticReactions.removeValue(forKey: postId)
                    }
                }
            
            reactionListeners[postId] = listener
        }
    }
    
    /**
     * Applies optimistic reaction update for immediate UI feedback
     */
    private func applyOptimisticReaction(postId: String, reactionType: ReactionType, increment: Bool) {
        DispatchQueue.main.async {
            // Find the post and update it optimistically
            if let postIndex = self.posts.firstIndex(where: { $0.id == postId }) {
                var updatedPost = self.posts[postIndex]
                let currentCount = updatedPost.reactions[reactionType.rawValue] ?? 0
                let newCount = increment ? currentCount + 1 : max(0, currentCount - 1)
                
                if newCount > 0 {
                    updatedPost.reactions[reactionType.rawValue] = newCount
                } else {
                    updatedPost.reactions.removeValue(forKey: reactionType.rawValue)
                }
                
                self.posts[postIndex] = updatedPost
                
                // Store optimistic update
                if self.optimisticReactions[postId] == nil {
                    self.optimisticReactions[postId] = [:]
                }
                self.optimisticReactions[postId]?[reactionType.rawValue] = newCount > 0 ? newCount : 0
                
                print("⚡ Optimistic reaction update: \(reactionType.rawValue) \(increment ? "+" : "-")1 for post \(postId)")
            }
        }
    }
    
    // MARK: - Post Operations
    
    /**
     * Creates a new post in Firebase
     */
    func createPost(
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
        // Validate authentication first
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        let post = Post(
            authorId: firebaseUID, // Use Firebase UID for security
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
    func deletePost(_ post: Post) {
        // Validate authentication
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        guard post.authorId == firebaseUID else {
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
        userDisplayName: String,
        cosmicSignature: CosmicSignature
    ) {
        // Validate authentication
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        guard let postId = post.id else {
            errorMessage = "Invalid post ID"
            print("❌ Cannot add reaction: Post ID is nil")
            return
        }
        
        print("🔄 Adding reaction \(reactionType.rawValue) to post \(postId) by user \(userDisplayName)")
        
        // STEP 1: Apply optimistic update for immediate UI feedback
        applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: true)
        
        // STEP 2: Create reaction document in Firebase
        let reaction = Reaction(
            postId: postId,
            userId: firebaseUID, // Use Firebase UID for security
            userDisplayName: userDisplayName,
            reactionType: reactionType,
            cosmicSignature: cosmicSignature
        )
        
        // Add reaction to reactions collection
        do {
            let reactionRef = try db.collection("reactions").addDocument(from: reaction) { [weak self] error in
                if let error = error {
                    // Revert optimistic update on failure
                    self?.applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: false)
                    
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to add reaction: \(error.localizedDescription)"
                    }
                    print("❌ Failed to save reaction to Firebase: \(error.localizedDescription)")
                } else {
                    print("✅ Reaction saved successfully to reactions collection")
                    
                    // Haptic feedback for successful reaction
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    // Note: We don't need to manually update post reaction count here
                    // because the real-time listener will handle it automatically
                }
            }
            print("📄 Created reaction document with ID: \(reactionRef.documentID)")
        } catch {
            // Revert optimistic update on encoding failure
            applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: false)
            
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
        reactionType: ReactionType
    ) {
        // Validate authentication
        guard let firebaseUID = validateAuthentication() else {
            return
        }
        
        guard let postId = post.id else {
            errorMessage = "Invalid post ID"
            return
        }
        
        print("🔄 Removing reaction \(reactionType.rawValue) from post \(postId) by user \(firebaseUID)")
        
        // STEP 1: Apply optimistic update for immediate UI feedback
        applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: false)
        
        // STEP 2: Find and delete the user's reaction from Firebase
        db.collection("reactions")
            .whereField("postId", isEqualTo: postId)
            .whereField("userId", isEqualTo: firebaseUID) // Use Firebase UID for security
            .whereField("reactionType", isEqualTo: reactionType.rawValue)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    // Revert optimistic update on failure
                    self?.applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: true)
                    
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to find reaction: \(error.localizedDescription)"
                    }
                    print("❌ Failed to find reaction to remove: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    // Revert optimistic update if reaction doesn't exist
                    self?.applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: true)
                    print("⚠️ No reaction found to remove")
                    return
                }
                
                // Delete the reaction document
                let reactionDoc = documents.first!
                reactionDoc.reference.delete { [weak self] error in
                    if let error = error {
                        // Revert optimistic update on failure
                        self?.applyOptimisticReaction(postId: postId, reactionType: reactionType, increment: true)
                        
                        DispatchQueue.main.async {
                            self?.errorMessage = "Failed to remove reaction: \(error.localizedDescription)"
                        }
                        print("❌ Failed to delete reaction: \(error.localizedDescription)")
                    } else {
                        print("✅ Reaction removed successfully")
                        
                        // Haptic feedback for removal
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        // Note: Real-time listener will handle the actual count update
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
    
    // MARK: - Reaction Queries
    
    /**
     * Checks if a user has already reacted to a post with a specific reaction type
     */
    func hasUserReacted(to post: Post, with reactionType: ReactionType, userId: String, completion: @escaping (Bool) -> Void) {
        guard let postId = post.id else {
            completion(false)
            return
        }
        
        db.collection("reactions")
            .whereField("postId", isEqualTo: postId)
            .whereField("userId", isEqualTo: userId)
            .whereField("reactionType", isEqualTo: reactionType.rawValue)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to check user reaction: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                let hasReacted = !(snapshot?.documents.isEmpty ?? true)
                completion(hasReacted)
            }
    }
    
    /**
     * Gets all reaction types a user has used on a specific post
     */
    func getUserReactions(for post: Post, userId: String, completion: @escaping ([ReactionType]) -> Void) {
        guard let postId = post.id else {
            completion([])
            return
        }
        
        db.collection("reactions")
            .whereField("postId", isEqualTo: postId)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to get user reactions: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let reactionTypes = documents.compactMap { document -> ReactionType? in
                    guard let reactionTypeString = document.data()["reactionType"] as? String else { return nil }
                    return ReactionType(rawValue: reactionTypeString)
                }
                
                completion(reactionTypes)
            }
    }
} 