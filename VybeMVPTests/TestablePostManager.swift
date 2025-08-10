//
//  TestablePostManager.swift
//  VybeMVPTests
//
//  PHASE 18: Test-Optimized PostManager Implementation
//  Provides predictable testing environment for PostManager tests
//
//  Created: July 27, 2025
//  Purpose: Enable reliable PostManager testing with mock repository integration
//

import Foundation
import Combine
@testable import VybeMVP

/**
 * Claude: Phase 18 - TestablePostManager
 *
 * PURPOSE:
 * Test-optimized version of PostManager that works seamlessly with MockPostRepository
 * and provides predictable behavior for unit testing.
 *
 * KEY FEATURES:
 * - Direct mock repository integration
 * - Simplified binding setup to avoid async deadlocks
 * - Manual control over initialization sequence
 * - Zero production code impact
 */
@MainActor
class TestablePostManager: ObservableObject {

    // Repository reference
    private let repository: PostRepository
    private var cancellables = Set<AnyCancellable>()

    // Published properties for UI updates (delegated to repository)
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isPaginating = false
    @Published var hasMorePosts = true

    // MARK: - Initialization

    init(repository: PostRepository) {
        self.repository = repository
        setupRepositoryBindings()

        print("🧪 TestablePostManager: Initialized with mock repository")
    }

    deinit {
        cancellables.removeAll()
    }

    // MARK: - Repository Binding Setup

    private func setupRepositoryBindings() {
        // Bind posts from repository
        repository.postsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.posts, on: self)
            .store(in: &cancellables)

        // Bind loading state from repository
        repository.loadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        // Bind error messages from repository
        repository.errorPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)

        // Bind pagination properties
        repository.isPaginatingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isPaginating, on: self)
            .store(in: &cancellables)

        repository.hasMorePostsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.hasMorePosts, on: self)
            .store(in: &cancellables)

        print("🧪 TestablePostManager: Repository bindings established")
    }

    // MARK: - Authentication Helper

    private var currentFirebaseUID: String? {
        return "test-user-id" // Fixed test user ID
    }

    private func validateAuthentication() -> String? {
        return currentFirebaseUID
    }

    // MARK: - Post Operations

    func refreshPosts() async {
        print("🧪 TestablePostManager: Refreshing posts via repository")
        await repository.loadPosts(forceRefresh: true)
    }

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
        guard let firebaseUID = validateAuthentication() else {
            return
        }

        var post = Post(
            authorId: firebaseUID,
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
        // Ensure post has an ID for testing
        if post.id == nil {
            post.id = UUID().uuidString
        }

        Task {
            do {
                try await repository.createPost(post)
                print("✅ TestablePostManager: Post created successfully")
            } catch {
                print("❌ TestablePostManager: Failed to create post: \(error.localizedDescription)")
            }
        }
    }

    func deletePost(_ post: Post) {
        print("🧪 TestablePostManager: Attempting to delete post ID: \(post.id ?? "nil"), content: \"\(post.content)\"")
        Task {
            do {
                try await repository.deletePost(post)
                print("✅ TestablePostManager: Post deleted successfully")
            } catch {
                print("❌ TestablePostManager: Failed to delete post: \(error.localizedDescription)")
            }
        }
    }

    func updatePost(_ post: Post, newContent: String) async throws {
        try await repository.updatePost(post, newContent: newContent)
        print("✅ TestablePostManager: Post updated successfully")
    }

    func addReaction(
        to post: Post,
        reactionType: ReactionType,
        userDisplayName: String,
        cosmicSignature: CosmicSignature
    ) {
        Task {
            do {
                try await repository.addReaction(
                    to: post,
                    reactionType: reactionType,
                    userDisplayName: userDisplayName,
                    cosmicSignature: cosmicSignature
                )
                print("✅ TestablePostManager: Reaction added successfully")
            } catch {
                print("❌ TestablePostManager: Failed to add reaction: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Filtering and Search

    func filterPosts(by tags: [String]) -> [Post] {
        guard !tags.isEmpty else { return repository.posts }
        return repository.posts.filter { post in
            !Set(post.tags).isDisjoint(with: Set(tags))
        }
    }

    func filterPosts(by type: PostType) -> [Post] {
        return repository.posts.filter { $0.type == type }
    }

    func filterPosts(by focusNumber: Int) -> [Post] {
        return repository.posts.filter { post in
            post.cosmicSignature?.focusNumber == focusNumber ||
            post.sightingNumber == focusNumber
        }
    }

    func getResonantPosts(for userProfile: SocialUser) -> [Post] {
        return repository.posts.filter { post in
            guard let signature = post.cosmicSignature else { return false }

            return signature.lifePathNumber == userProfile.lifePathNumber ||
                   signature.focusNumber == userProfile.currentFocusNumber ||
                   signature.realmNumber == userProfile.expressionNumber
        }
    }

    func getResonantPostsAsync(for userProfile: SocialUser) async -> [Post] {
        return await repository.getResonantPosts(for: userProfile)
    }

    // MARK: - Analytics

    func getReactionStats(for post: Post) -> [ReactionType: Int] {
        return post.reactions.compactMapValues { count in
            count > 0 ? count : nil
        }.reduce(into: [ReactionType: Int]()) { result, pair in
            if let reactionType = ReactionType(rawValue: pair.key) {
                result[reactionType] = pair.value
            }
        }
    }

    // MARK: - Pagination Methods

    func loadNextPage() async {
        await repository.loadNextPage()
    }

    func recordScrollBehavior(speed: Double) async {
        await repository.recordScrollBehavior(speed: speed)
    }

    func resetPagination() async {
        await repository.resetPagination()
    }
}
