//
//  PostRepository.swift
//  VybeMVP
//
//  Phase 17B: Repository Pattern Implementation for Cache-First Data Access
//  Created to optimize Firebase costs and improve testability
//

import Foundation
import Combine

/**
 * Claude: Phase 17B - PostRepository Protocol
 * 
 * PURPOSE:
 * Defines the interface for post data access operations with cache-first strategy.
 * Abstracts Firebase operations behind a clean interface for better testing and cost optimization.
 * 
 * BENEFITS:
 * - Cache-First Strategy: Reduces Firebase read costs by serving cached data when possible
 * - Testability: Clean interface allows easy mocking for unit tests
 * - Offline Support: Local cache provides data when network unavailable
 * - Cost Optimization: Intelligent caching reduces Firebase API calls significantly
 * - Separation of Concerns: Business logic separated from data access implementation
 * 
 * CACHE STRATEGY:
 * - Memory Cache: Recent posts kept in memory for instant access
 * - Disk Cache: Posts persisted locally for offline access
 * - Cache Invalidation: Smart refresh logic based on age and user actions
 * - Network Fallback: Firebase queries only when cache misses or explicit refresh
 */
protocol PostRepository {
    
    // MARK: - Published Properties for UI Binding
    
    /// Current posts array for UI binding
    @MainActor var posts: [Post] { get }
    
    /// Loading state for UI feedback
    @MainActor var isLoading: Bool { get }
    
    /// Error messages for user feedback
    @MainActor var errorMessage: String? { get }
    
    /// Publisher for posts changes
    @MainActor var postsPublisher: AnyPublisher<[Post], Never> { get }
    
    /// Publisher for loading state changes
    @MainActor var loadingPublisher: AnyPublisher<Bool, Never> { get }
    
    /// Publisher for error changes
    @MainActor var errorPublisher: AnyPublisher<String?, Never> { get }
    
    // MARK: - Post Operations
    
    /**
     * Loads posts with cache-first strategy
     * - Parameter forceRefresh: If true, bypasses cache and fetches from Firebase
     * - Returns: Async operation that completes when posts are loaded
     */
    func loadPosts(forceRefresh: Bool) async
    
    /**
     * Creates a new post
     * - Parameter post: The post to create
     * - Returns: Async operation that completes when post is created
     */
    func createPost(_ post: Post) async throws
    
    /**
     * Updates an existing post
     * - Parameters:
     *   - post: The post to update
     *   - newContent: The new content for the post
     * - Returns: Async operation that completes when post is updated
     */
    func updatePost(_ post: Post, newContent: String) async throws
    
    /**
     * Deletes a post
     * - Parameter post: The post to delete
     * - Returns: Async operation that completes when post is deleted
     */
    func deletePost(_ post: Post) async throws
    
    // MARK: - Filtering & Querying
    
    /**
     * Gets posts filtered by type with cache-first approach
     * - Parameter type: The post type to filter by
     * - Returns: Array of filtered posts from cache or Firebase
     */
    func getFilteredPosts(by type: PostType) async -> [Post]
    
    /**
     * Gets resonant posts for a specific user
     * - Parameter user: The user to find resonant posts for
     * - Returns: Array of posts that resonate with the user's cosmic profile
     */
    func getResonantPosts(for user: SocialUser) async -> [Post]
    
    /**
     * Gets recent posts within specified time window
     * - Parameter timeInterval: How far back to look (in seconds)
     * - Returns: Array of recent posts from cache or Firebase
     */
    func getRecentPosts(within timeInterval: TimeInterval) async -> [Post]
    
    // MARK: - Reaction Operations
    
    /**
     * Adds a reaction to a post with optimistic updates
     * - Parameters:
     *   - post: The post to react to
     *   - reactionType: The type of reaction
     *   - userDisplayName: Display name of the reacting user
     *   - cosmicSignature: User's cosmic signature
     * - Returns: Async operation that completes when reaction is added
     */
    func addReaction(
        to post: Post,
        reactionType: ReactionType,
        userDisplayName: String,
        cosmicSignature: CosmicSignature
    ) async throws
    
    // MARK: - Cache Management
    
    /**
     * Clears all cached data and forces fresh fetch
     */
    func clearCache() async
    
    /**
     * Gets cache statistics for debugging and optimization
     * - Returns: Dictionary with cache hit rates, sizes, and performance metrics
     */
    @MainActor
    func getCacheStats() -> [String: Any]
    
    // MARK: - Real-time Updates
    
    /**
     * Starts real-time listener for post updates
     * Combines with cache strategy for optimal performance
     */
    @MainActor
    func startRealtimeUpdates()
    
    /**
     * Stops real-time listener
     */
    @MainActor
    func stopRealtimeUpdates()
}

/**
 * Claude: Phase 17B - PostRepositoryError
 * 
 * Standardized error types for repository operations
 */
enum PostRepositoryError: LocalizedError {
    case cacheFailure
    case networkFailure
    case authenticationRequired
    case postNotFound
    case permissionDenied
    case rateLimitExceeded
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .cacheFailure:
            return "Failed to access local cache"
        case .networkFailure:
            return "Network connection failed"
        case .authenticationRequired:
            return "User authentication required"
        case .postNotFound:
            return "Post not found"
        case .permissionDenied:
            return "Permission denied"
        case .rateLimitExceeded:
            return "Too many requests, please try again later"
        case .invalidData:
            return "Invalid data format"
        }
    }
}