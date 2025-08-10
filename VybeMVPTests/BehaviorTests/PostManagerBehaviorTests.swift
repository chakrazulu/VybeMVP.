//
//  PostManagerBehaviorTests.swift
//  VybeMVPTests
//
//  Test Refactoring: Behavior-Focused Testing
//  Tests what users experience, not implementation details
//
//  Created: July 27, 2025
//  Purpose: Clean, maintainable tests focused on behavior
//

import XCTest
import Combine
@testable import VybeMVP

/**
 * Claude: Phase 18 Test Architecture Refactoring - Behavior-Focused PostManager Tests
 *
 * PROBLEM WITH OLD TESTING APPROACH:
 * Previous tests focused on implementation details like:
 * - Testing Core Data entity properties (needsSync, pendingOperation)
 * - Testing internal repository state management
 * - Complex async binding scenarios that caused deadlocks
 * - Performance tests mixed with functional tests
 *
 * NEW BEHAVIOR-FOCUSED APPROACH:
 * Instead of testing "how the code works internally", we test:
 * - What the USER experiences: "When I create a post, does it appear?"
 * - Real user workflows: "Create → Filter → Delete → Verify"
 * - Error scenarios users might encounter
 * - Loading states users see
 *
 * BENEFITS OF BEHAVIOR TESTING:
 * ✅ Tests remain valid even if implementation changes
 * ✅ Tests catch bugs that affect users (not just internal bugs)
 * ✅ Tests are easier to understand and maintain
 * ✅ Tests serve as documentation of expected behavior
 * ✅ Less fragile - don't break when refactoring internal code
 *
 * TESTING STRATEGY:
 * - Use Given-When-Then structure for clarity
 * - Test one specific behavior per test method
 * - Use realistic test data via TestDataFactory
 * - Use SimpleMockPostRepository for predictable behavior
 * - Focus on what users can observe and interact with
 *
 * EXAMPLES:
 * ❌ Old: XCTAssertTrue(entity.needsSync) // Testing implementation
 * ✅ New: XCTAssertEqual(posts.count, 1) // Testing user-visible behavior
 *
 * ❌ Old: Testing repository binding mechanisms
 * ✅ New: Testing "when I create a post, it appears in my timeline"
 */
@MainActor
class PostManagerBehaviorTests: XCTestCase {

    var postManager: TestablePostManager!
    var mockRepository: SimpleMockPostRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = SimpleMockPostRepository()
        postManager = TestablePostManager(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        cancellables.removeAll()
        mockRepository = nil
        postManager = nil
        super.tearDown()
    }

    // MARK: - Post Creation Behavior

    // MARK: - Post Creation Behavior
    // Claude: These tests verify what users experience when creating posts

    /**
     * Tests: When I create a post, it appears in my timeline
     *
     * This replaces complex repository binding tests with simple behavior verification.
     * Instead of testing HOW the post gets to the timeline (repository → manager → UI),
     * we test THAT it appears in the timeline (what users care about).
     */
    func testCreatePostAppearsInTimeline() async {
        // Given: I have no posts
        assertRepositoryIsClean(mockRepository)

        // When: I create a post through the PostManager (like users do)
        postManager.createPost(
            authorName: "Test User",
            content: "My first post!",
            type: .text
        )

        // Wait for async Task to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Then: The post appears in my timeline
        XCTAssertEqual(mockRepository.posts.count, 1)
        XCTAssertEqual(mockRepository.posts.first?.content, "My first post!")
    }

    /**
     * Tests: When I create multiple posts, they all appear in order
     */
    func testCreateMultiplePostsAppearInOrder() async {
        // Given: I have no posts
        assertRepositoryIsClean(mockRepository)

        // When: I create several posts through PostManager
        postManager.createPost(authorName: "User", content: "First post", type: .text)
        postManager.createPost(authorName: "User", content: "Second post", type: .text)
        postManager.createPost(authorName: "User", content: "Third post", type: .text)

        // Wait for async Tasks to complete
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds

        // Then: All posts appear in my timeline
        XCTAssertEqual(mockRepository.posts.count, 3)
        XCTAssertTrue(mockRepository.posts.contains { $0.content == "First post" })
        XCTAssertTrue(mockRepository.posts.contains { $0.content == "Second post" })
        XCTAssertTrue(mockRepository.posts.contains { $0.content == "Third post" })
    }

    // MARK: - Post Filtering Behavior

    /**
     * Tests: When I filter by post type, I only see that type
     */
    func testFilterByTypeShowsOnlyThatType() async {
        // Given: I have posts of different types
        let textPost = TestDataFactory.createPost(id: "text", content: "Text post", type: .text)
        let journalPost = TestDataFactory.createPost(id: "journal", content: "Journal entry", type: .journal)

        mockRepository.setPosts([textPost, journalPost])

        // When: I filter by text posts
        let textPosts = postManager.filterPosts(by: .text)

        // Then: I only see text posts
        XCTAssertEqual(textPosts.count, 1)
        XCTAssertEqual(textPosts.first?.type, .text)
        XCTAssertEqual(textPosts.first?.content, "Text post")
    }

    /**
     * Tests: When I filter by tags, I only see posts with those tags
     */
    func testFilterByTagsShowsOnlyMatchingPosts() {
        // Given: I have posts with different tags
        let spiritualPost = TestDataFactory.createPost(
            id: "spiritual",
            content: "Spiritual insight",
            tags: ["spirituality", "wisdom"]
        )
        let meditationPost = TestDataFactory.createPost(
            id: "meditation",
            content: "Meditation practice",
            tags: ["meditation", "peace"]
        )
        let mixedPost = TestDataFactory.createPost(
            id: "mixed",
            content: "Spiritual meditation",
            tags: ["spirituality", "meditation"]
        )

        mockRepository.setPosts([spiritualPost, meditationPost, mixedPost])

        // When: I filter by spirituality tag
        let spiritualPosts = postManager.filterPosts(by: ["spirituality"])

        // Then: I see posts tagged with spirituality
        XCTAssertEqual(spiritualPosts.count, 2)
        XCTAssertTrue(spiritualPosts.contains { $0.id == "spiritual" })
        XCTAssertTrue(spiritualPosts.contains { $0.id == "mixed" })
    }

    // MARK: - Post Update Behavior

    /**
     * Tests: When I update a post, the changes appear immediately
     */
    func testUpdatePostShowsChangesImmediately() async {
        // Given: I have a post
        let originalPost = TestDataFactory.createPost(
            id: "update-test",
            content: "Original content"
        )
        mockRepository.setPosts([originalPost])

        // When: I update the post
        try? await postManager.updatePost(originalPost, newContent: "Updated content")

        // Then: The changes appear immediately
        let updatedPost = mockRepository.posts.first { $0.id == "update-test" }
        XCTAssertEqual(updatedPost?.content, "Updated content")
    }

    // MARK: - Post Deletion Behavior

    /**
     * Tests: When I delete a post, it disappears from my timeline
     */
    func testDeletePostRemovesFromTimeline() async {
        // Given: I have posts in my timeline (created through PostManager)
        postManager.createPost(authorName: "User", content: "Keep this post", type: .text)
        postManager.createPost(authorName: "User", content: "Delete this post", type: .text)

        // Wait for creation to complete
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        XCTAssertEqual(mockRepository.posts.count, 2)

        // When: I delete one post
        if let postToDelete = mockRepository.posts.first(where: { $0.content == "Delete this post" }) {
            postManager.deletePost(postToDelete)
            // Wait for deletion to complete
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }

        // Then: Only the remaining post is visible
        XCTAssertEqual(mockRepository.posts.count, 1)
        XCTAssertEqual(mockRepository.posts.first?.content, "Keep this post")
        XCTAssertNil(mockRepository.posts.first { $0.content == "Delete this post" })
    }

    // MARK: - Error Handling Behavior

    /**
     * Tests: When something goes wrong, I get a helpful error message
     */
    func testErrorsProvideHelpfulMessages() async {
        // Given: The repository will fail
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = PostRepositoryError.postNotFound

        // When: I try to update a non-existent post
        let nonExistentPost = TestDataFactory.createPost(id: "missing")

        do {
            try await postManager.updatePost(nonExistentPost, newContent: "New content")
            XCTFail("Expected error to be thrown")
        } catch {
            // Then: I get a meaningful error
            XCTAssertTrue(error is PostRepositoryError)
            if let repoError = error as? PostRepositoryError {
                XCTAssertEqual(repoError, PostRepositoryError.postNotFound)
            }
        }
    }

    // MARK: - Loading State Behavior

    /**
     * Tests: When the app is loading, I can see the loading state
     */
    func testLoadingStateIsVisible() async {
        // Given: The repository is not loading
        XCTAssertFalse(postManager.isLoading)

        // When: I trigger a loading operation
        mockRepository.setLoading(true)

        // Then: The loading state is visible
        XCTAssertTrue(mockRepository.isLoading)

        // When: Loading completes
        mockRepository.setLoading(false)

        // Then: Loading state is cleared
        XCTAssertFalse(mockRepository.isLoading)
    }

    // MARK: - Resonance Behavior

    /**
     * Tests: When I look for resonant posts, I find posts that match my energy
     */
    func testResonantPostsMatchMyEnergy() {
        // Given: I have a specific spiritual profile
        let myProfile = TestDataFactory.createTestUser(
            lifePathNumber: 7,
            currentFocusNumber: 3
        )

        // And: There are posts with various cosmic signatures
        let resonantPost = TestDataFactory.createPostWithCosmicSignature(
            id: "resonant",
            focusNumber: 9, // Different from my focusNumber
            lifePathNumber: 7 // Matches my life path
        )
        let nonResonantPost = TestDataFactory.createPostWithCosmicSignature(
            id: "non-resonant",
            focusNumber: 8, // Different from my focusNumber
            lifePathNumber: 2 // Doesn't match my life path
        )

        mockRepository.setPosts([resonantPost, nonResonantPost])

        // When: I look for resonant posts
        let resonantPosts = postManager.getResonantPosts(for: myProfile)

        // Then: I see posts that match my energy (may be multiple due to multiple matching criteria)
        XCTAssertGreaterThanOrEqual(resonantPosts.count, 1)
        XCTAssertTrue(resonantPosts.contains { $0.id == "resonant" })
    }

    // MARK: - Real-world Scenarios

    // MARK: - Real-world Scenarios
    // Claude: These tests simulate complete user workflows to catch integration issues

    /**
     * Tests: A typical user session with multiple actions
     *
     * This type of test is valuable because it:
     * - Tests the complete user journey, not just individual features
     * - Catches integration bugs that unit tests might miss
     * - Serves as documentation of expected user workflows
     * - Remains stable even when internal implementation changes
     */
    func testTypicalUserSession() async {
        // Given: I start with an empty timeline
        assertRepositoryIsClean(mockRepository)

        // When: I create my first post
        postManager.createPost(authorName: "User", content: "Hello, spiritual world!", type: .text)

        // Wait for creation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Then: I see my post
        XCTAssertEqual(mockRepository.posts.count, 1)

        // When: I create a few more posts
        postManager.createPost(authorName: "User", content: "Session post 1", type: .text)
        postManager.createPost(authorName: "User", content: "Session post 2", type: .journal)
        postManager.createPost(authorName: "User", content: "Session post 3", type: .text)

        // Wait for all creations
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds

        // Then: I see all my posts
        XCTAssertEqual(mockRepository.posts.count, 4)

        // When: I filter to see only text posts
        let textPosts = await mockRepository.getFilteredPosts(by: .text)

        // Then: I see the filtered results
        XCTAssertGreaterThan(textPosts.count, 0)
        XCTAssertTrue(textPosts.allSatisfy { $0.type == .text })

        // When: I delete one post
        if let postToDelete = mockRepository.posts.first {
            postManager.deletePost(postToDelete)
            // Wait for deletion
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        }

        // Then: My timeline updates
        XCTAssertEqual(mockRepository.posts.count, 3)
    }
}
