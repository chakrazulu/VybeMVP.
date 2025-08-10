//
//  PostEntityTests.swift
//  VybeMVPTests
//
//  PHASE 18: Comprehensive Unit Testing for Enterprise Architecture
//  Tests the PostEntity Core Data model implementation
//
//  Created: July 27, 2025
//  Purpose: Validate Core Data model integrity and conversion methods
//

import XCTest
import CoreData
@testable import VybeMVP

/**
 * Claude: Phase 18 - PostEntity Core Data Model Test Suite
 *
 * PURPOSE:
 * Comprehensive testing of the PostEntity Core Data model to ensure:
 * - Model conversion methods work correctly
 * - JSON encoding/decoding preserves data integrity
 * - Core Data relationships and constraints function properly
 * - Sync tracking mechanisms operate as expected
 * - Performance meets enterprise standards
 *
 * TESTING STRATEGY:
 * - Data Conversion: Test Post ↔ PostEntity transformations
 * - JSON Serialization: Validate complex type encoding/decoding
 * - Core Data Operations: Test CRUD operations and fetch requests
 * - Sync Management: Validate sync flags and operations
 * - Performance: Ensure efficient data handling at scale
 */
class PostEntityTests: XCTestCase {

    var testContext: NSManagedObjectContext!
    var persistenceController: PersistenceController!

    override func setUp() {
        super.setUp()

        // Use fresh in-memory Core Data stack for testing
        persistenceController = PersistenceController.makeTestController()
        testContext = persistenceController.container.viewContext

        // Ensure clean state
        PersistenceController.clearAllData(in: testContext)
    }

    override func tearDown() {
        testContext = nil
        persistenceController = nil
        super.tearDown()
    }

    // MARK: - Model Creation Tests

    /**
     * Tests basic PostEntity creation from Post model
     */
    func testBasicEntityCreation() throws {
        let testPost = createTestPost()

        // Create entity from post
        let entity = PostEntity.create(from: testPost, in: testContext)

        // Verify basic properties
        XCTAssertEqual(entity.firebaseId, testPost.id)
        XCTAssertEqual(entity.authorId, testPost.authorId)
        XCTAssertEqual(entity.authorName, testPost.authorName)
        XCTAssertEqual(entity.content, testPost.content)
        XCTAssertEqual(entity.type, testPost.type.rawValue)
        XCTAssertEqual(entity.isPublic, testPost.isPublic)

        // Verify timestamps
        XCTAssertNotNil(entity.createdTimestamp)
        XCTAssertNotNil(entity.timestamp)

        // Verify sync properties
        XCTAssertFalse(entity.needsSync)
        XCTAssertNil(entity.pendingOperation)
    }

    /**
     * Tests PostEntity creation with complex data types
     */
    func testComplexEntityCreation() throws {
        let testPost = createTestPostWithComplexData()

        let entity = PostEntity.create(from: testPost, in: testContext)

        // Verify complex data serialization
        XCTAssertNotNil(entity.reactionsJSON)
        XCTAssertNotNil(entity.tagsString)
        XCTAssertNotNil(entity.cosmicSignatureJSON)

        // Verify data can be retrieved
        XCTAssertEqual(entity.reactionsDict["love"], 10)
        XCTAssertEqual(entity.reactionsDict["wisdom"], 5)
        XCTAssertTrue(entity.tagsArray.contains("conversion"))
        XCTAssertEqual(entity.cosmicSignature?.lifePathNumber, 11)
    }

    // MARK: - Model Conversion Tests

    /**
     * Tests converting PostEntity back to Post model
     */
    func testEntityToPostConversion() throws {
        let originalPost = createTestPost()

        // Create entity and convert back
        let entity = PostEntity.create(from: originalPost, in: testContext)
        let convertedPost = entity.toPost()

        // Verify all properties preserved
        XCTAssertEqual(convertedPost.id, originalPost.id)
        XCTAssertEqual(convertedPost.authorId, originalPost.authorId)
        XCTAssertEqual(convertedPost.authorName, originalPost.authorName)
        XCTAssertEqual(convertedPost.content, originalPost.content)
        XCTAssertEqual(convertedPost.type, originalPost.type)
        XCTAssertEqual(convertedPost.isPublic, originalPost.isPublic)
        XCTAssertEqual(convertedPost.tags, originalPost.tags)
        XCTAssertEqual(convertedPost.reactions, originalPost.reactions)
        XCTAssertEqual(convertedPost.commentCount, originalPost.commentCount)
    }

    /**
     * Tests round-trip conversion preserves data integrity
     */
    func testRoundTripConversion() throws {
        let originalPost = createTestPostWithComplexData()

        // Round trip: Post → Entity → Post
        let entity = PostEntity.create(from: originalPost, in: testContext)
        let convertedPost = entity.toPost()

        // Verify perfect data preservation
        XCTAssertEqual(convertedPost.reactions, originalPost.reactions)
        XCTAssertEqual(convertedPost.tags, originalPost.tags)
        XCTAssertEqual(convertedPost.cosmicSignature?.lifePathNumber, originalPost.cosmicSignature?.lifePathNumber)
        XCTAssertEqual(convertedPost.cosmicSignature?.focusNumber, originalPost.cosmicSignature?.focusNumber)
        XCTAssertEqual(convertedPost.cosmicSignature?.realmNumber, originalPost.cosmicSignature?.realmNumber)
        XCTAssertEqual(convertedPost.commentCount, originalPost.commentCount)
        XCTAssertEqual(convertedPost.sightingNumber, originalPost.sightingNumber)
    }

    // MARK: - JSON Serialization Tests

    /**
     * Tests reactions JSON encoding and decoding
     */
    func testReactionsJSONSerialization() throws {
        let reactions = ["love": 15, "wisdom": 8, "clarity": 3, "mystery": 1]

        let entity = PostEntity(context: testContext)

        // Test private encoding method by creating from Post
        let testPost = createTestPostWithReactions(reactions: reactions)
        entity.update(from: testPost)

        // Verify encoding worked
        XCTAssertNotNil(entity.reactionsJSON)

        // Verify decoding works
        let decodedReactions = entity.reactionsDict
        XCTAssertEqual(decodedReactions, reactions)
    }

    /**
     * Tests cosmic signature JSON encoding and decoding
     */
    func testCosmicSignatureJSONSerialization() throws {
        let cosmicSignature = CosmicSignature(
            focusNumber: 3,
            currentChakra: "Heart",
            lifePathNumber: 7,
            realmNumber: 1,
            mood: "Peaceful",
            intention: "Testing"
        )

        let entity = PostEntity(context: testContext)

        // Test encoding through Post update
        let testPost = createTestPostWithCosmicSignature(cosmicSignature: cosmicSignature)
        entity.update(from: testPost)

        // Verify encoding worked
        XCTAssertNotNil(entity.cosmicSignatureJSON)

        // Verify decoding works
        let decodedSignature = entity.cosmicSignature
        XCTAssertEqual(decodedSignature?.lifePathNumber, 7)
        XCTAssertEqual(decodedSignature?.focusNumber, 3)
        XCTAssertEqual(decodedSignature?.realmNumber, 1)
    }

    /**
     * Tests tags string serialization
     */
    func testTagsStringSerialization() throws {
        let tags = ["numerology", "spirituality", "cosmic", "wisdom", "clarity"]

        let entity = PostEntity(context: testContext)

        // Test encoding through Post update
        let testPost = createTestPostWithTags(tags: tags)
        entity.update(from: testPost)

        // Verify encoding worked
        XCTAssertNotNil(entity.tagsString)
        XCTAssertTrue(entity.tagsString?.contains("numerology") ?? false)

        // Verify decoding works
        let decodedTags = entity.tagsArray
        XCTAssertEqual(Set(decodedTags), Set(tags))
    }

    // MARK: - Core Data Operations Tests

    /**
     * Tests Core Data fetch operations
     */
    func testCorDataFetchOperations() throws {
        // Create multiple test entities
        let post1 = createTestPost(id: "fetch-test-1")
        let post2 = createTestPost(id: "fetch-test-2")
        let post3 = createTestPost(id: "fetch-test-3")

        let _ = PostEntity.create(from: post1, in: testContext)
        let _ = PostEntity.create(from: post2, in: testContext)
        let _ = PostEntity.create(from: post3, in: testContext)

        // Save context
        try testContext.save()

        // Test fetchAllPosts
        let allPosts = PostEntity.fetchAllPosts(in: testContext)
        XCTAssertEqual(allPosts.count, 3)

        // Test findPost by Firebase ID
        let foundEntity = PostEntity.findPost(withFirebaseId: "fetch-test-2", in: testContext)
        XCTAssertNotNil(foundEntity)
        XCTAssertEqual(foundEntity?.firebaseId, "fetch-test-2")

        // Test finding non-existent post
        let notFound = PostEntity.findPost(withFirebaseId: "non-existent", in: testContext)
        XCTAssertNil(notFound)
    }

    /**
     * Tests sync-related fetch operations
     */
    func testSyncFetchOperations() throws {
        // Create entities with different sync states
        let post1 = createTestPost(id: "sync-test-1")
        let post2 = createTestPost(id: "sync-test-2")
        let post3 = createTestPost(id: "sync-test-3")

        let entity1 = PostEntity.create(from: post1, in: testContext)
        let entity2 = PostEntity.create(from: post2, in: testContext)
        let _ = PostEntity.create(from: post3, in: testContext)

        // Mark some for sync
        entity1.markForSync(operation: "create")
        entity2.markForSync(operation: "update")
        // entity3 remains unsynced

        try testContext.save()

        // Test fetchPostsNeedingSync
        let needingSync = PostEntity.fetchPostsNeedingSync(in: testContext)
        XCTAssertEqual(needingSync.count, 2)

        let syncOperations = needingSync.compactMap { $0.pendingOperation }
        XCTAssertTrue(syncOperations.contains("create"))
        XCTAssertTrue(syncOperations.contains("update"))
    }

    /**
     * Tests entity deletion operations
     */
    func testEntityDeletion() throws {
        let testPost = createTestPost(id: "delete-test")
        let _ = PostEntity.create(from: testPost, in: testContext)

        try testContext.save()

        // Verify entity exists
        XCTAssertNotNil(PostEntity.findPost(withFirebaseId: "delete-test", in: testContext))

        // Delete entity
        PostEntity.deletePost(withFirebaseId: "delete-test", in: testContext)
        try testContext.save()

        // Verify entity deleted
        XCTAssertNil(PostEntity.findPost(withFirebaseId: "delete-test", in: testContext))
    }

    // MARK: - Sync Management Tests

    /**
     * Tests sync marking functionality
     */
    func testSyncMarking() throws {
        let testPost = createTestPost()
        let entity = PostEntity.create(from: testPost, in: testContext)

        // Initially not marked for sync
        XCTAssertFalse(entity.needsSync)
        XCTAssertNil(entity.pendingOperation)
        XCTAssertNil(entity.lastModifiedTimestamp)

        // Mark for sync
        entity.markForSync(operation: "update")

        // Verify sync marking
        XCTAssertTrue(entity.needsSync)
        XCTAssertEqual(entity.pendingOperation, "update")
        XCTAssertNotNil(entity.lastModifiedTimestamp)

        // Test default operation
        entity.markForSync() // Should default to "update"
        XCTAssertEqual(entity.pendingOperation, "update")
    }

    /**
     * Tests sync state management during updates
     */
    func testSyncStateManagement() throws {
        var testPost = createTestPost()
        let entity = PostEntity.create(from: testPost, in: testContext)

        // Update post and entity
        testPost.content = "Updated content"
        entity.update(from: testPost)

        // Should clear sync flags when updated from external source
        XCTAssertFalse(entity.needsSync)
        XCTAssertNotNil(entity.lastSyncTimestamp)

        // Manually mark for sync again
        entity.markForSync(operation: "create")
        XCTAssertTrue(entity.needsSync)
        XCTAssertEqual(entity.pendingOperation, "create")
    }

    // MARK: - Performance Tests

    /**
     * Tests entity creation performance
     */
    func testEntityCreationPerformance() {
        let posts = (0..<1000).map { createTestPost(id: "perf-\($0)") }

        measure {
            for post in posts {
                let _ = PostEntity.create(from: post, in: testContext)
            }
        }
    }

    /**
     * Tests entity conversion performance
     */
    func testEntityConversionPerformance() throws {
        // Create entities first
        let entities = (0..<1000).map { i in
            let post = createTestPost(id: "conv-\(i)")
            return PostEntity.create(from: post, in: testContext)
        }

        measure {
            for entity in entities {
                let _ = entity.toPost()
            }
        }
    }

    /**
     * Tests batch fetch performance
     */
    func testBatchFetchPerformance() throws {
        // Create many entities
        for i in 0..<1000 {
            let post = createTestPost(id: "batch-\(i)")
            let _ = PostEntity.create(from: post, in: testContext)
        }

        try testContext.save()

        measure {
            let _ = PostEntity.fetchAllPosts(in: testContext)
        }
    }

    // MARK: - Edge Cases Tests

    /**
     * Tests handling of nil and empty values
     */
    func testNilAndEmptyValues() throws {
        let testPost = createTestPostWithNilValues()

        let entity = PostEntity.create(from: testPost, in: testContext)
        let convertedPost = entity.toPost()

        // Verify nil values handled correctly
        XCTAssertNil(convertedPost.imageURL)
        XCTAssertNil(convertedPost.sightingNumber)
        XCTAssertNil(convertedPost.chakraType)
        XCTAssertNil(convertedPost.journalExcerpt)
        XCTAssertNil(convertedPost.cosmicSignature)
        XCTAssertTrue(convertedPost.tags.isEmpty)
        XCTAssertTrue(convertedPost.reactions.isEmpty)
    }

    /**
     * Tests handling of very large data
     */
    func testLargeDataHandling() throws {
        let testPost = createTestPostWithLargeData()

        let entity = PostEntity.create(from: testPost, in: testContext)
        let convertedPost = entity.toPost()

        // Verify large data preserved
        XCTAssertEqual(convertedPost.content.count, testPost.content.count)
        XCTAssertEqual(convertedPost.tags.count, 100)
        XCTAssertEqual(convertedPost.reactions.count, 50)
    }

    /**
     * Tests handling of special characters and unicode
     */
    func testSpecialCharacterHandling() throws {
        let testPost = createTestPostWithSpecialCharacters()

        let entity = PostEntity.create(from: testPost, in: testContext)
        let convertedPost = entity.toPost()

        // Verify special characters preserved
        XCTAssertEqual(convertedPost.content, testPost.content)
        XCTAssertEqual(convertedPost.authorName, testPost.authorName)
        XCTAssertEqual(Set(convertedPost.tags), Set(testPost.tags))
    }

    // MARK: - Data Integrity Tests

    /**
     * Tests that Core Data constraints are enforced
     */
    func testDataIntegrityConstraints() throws {
        let testPost = createTestPost()
        let _ = PostEntity.create(from: testPost, in: testContext)

        // Test saving valid entity
        XCTAssertNoThrow(try testContext.save())

        // Test that entity can be found after save
        try testContext.save()
        let foundEntity = PostEntity.findPost(withFirebaseId: testPost.id!, in: testContext)
        XCTAssertNotNil(foundEntity)
    }

    /**
     * Tests concurrent access to entities
     */
    func testConcurrentAccess() throws {
        let testPost = createTestPost()
        let _ = PostEntity.create(from: testPost, in: testContext)
        try testContext.save()

        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10

        // Simulate concurrent reads
        for _ in 0..<10 {
            DispatchQueue.global().async {
                let privateContext = self.persistenceController.container.newBackgroundContext()
                let foundEntity = PostEntity.findPost(withFirebaseId: testPost.id!, in: privateContext)
                XCTAssertNotNil(foundEntity)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // MARK: - Helper Methods

    /**
     * Creates a test post for use in tests
     */
    private func createTestPost(id: String = UUID().uuidString, type: PostType = .text) -> Post {
        var post = Post(
            authorId: "test-author-\(UUID().uuidString)",
            authorName: "Test Author",
            content: "Test content for PostEntity testing",
            type: type,
            isPublic: true,
            tags: ["test", "entity"],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = id
        return post
    }

    /**
     * Creates a test post with complex data for comprehensive testing
     */
    private func createTestPostWithComplexData() -> Post {
        var post = Post(
            authorId: "test-author-complex",
            authorName: "Complex Test Author",
            content: "Complex test content with full data",
            type: .text,
            isPublic: true,
            tags: ["test", "conversion", "data"],
            imageURL: nil,
            sightingNumber: 777,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: CosmicSignature(
                focusNumber: 22,
                currentChakra: "Crown",
                lifePathNumber: 11,
                realmNumber: 33,
                mood: "Transcendent",
                intention: "Testing complex data"
            )
        )
        post.id = "complex-test-id"
        post.reactions = ["love": 10, "wisdom": 5]
        post.commentCount = 15
        return post
    }

    /**
     * Creates a test post with specific reactions
     */
    private func createTestPostWithReactions(reactions: [String: Int]) -> Post {
        var post = Post(
            authorId: "test-author-reactions",
            authorName: "Reactions Test Author",
            content: "Test content with reactions",
            type: .text,
            isPublic: true,
            tags: ["test", "reactions"],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = "reactions-test-id"
        post.reactions = reactions
        return post
    }

    /**
     * Creates a test post with cosmic signature
     */
    private func createTestPostWithCosmicSignature(cosmicSignature: CosmicSignature) -> Post {
        var post = Post(
            authorId: "test-author-cosmic",
            authorName: "Cosmic Test Author",
            content: "Test content with cosmic signature",
            type: .text,
            isPublic: true,
            tags: ["test", "cosmic"],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: cosmicSignature
        )
        post.id = "cosmic-test-id"
        return post
    }

    /**
     * Creates a test post with specific tags
     */
    private func createTestPostWithTags(tags: [String]) -> Post {
        var post = Post(
            authorId: "test-author-tags",
            authorName: "Tags Test Author",
            content: "Test content with tags",
            type: .text,
            isPublic: true,
            tags: tags,
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = "tags-test-id"
        return post
    }

    /**
     * Creates a test post with nil values for testing edge cases
     */
    private func createTestPostWithNilValues() -> Post {
        var post = Post(
            authorId: "test-author-nil",
            authorName: "Nil Test Author",
            content: "Test content with nil values",
            type: .text,
            isPublic: true,
            tags: [],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = "nil-test-id"
        post.reactions = [:]
        return post
    }

    /**
     * Creates a test post with large data for performance testing
     */
    private func createTestPostWithLargeData() -> Post {
        var post = Post(
            authorId: "test-author-large",
            authorName: "Large Data Test Author",
            content: String(repeating: "This is a very long post content. ", count: 1000),
            type: .text,
            isPublic: true,
            tags: (0..<100).map { "tag\($0)" },
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = "large-test-id"
        post.reactions = (0..<50).reduce(into: [:]) { result, i in
            result["reaction\(String(i))"] = i
        }
        return post
    }

    /**
     * Creates a test post with special characters and unicode
     */
    private func createTestPostWithSpecialCharacters() -> Post {
        var post = Post(
            authorId: "test-author-special",
            authorName: "Test User 測試用戶",
            content: "Special chars: 🌟✨🔮 Unicode: αβγ Emojis: 😊🧘‍♀️🕉️",
            type: .text,
            isPublic: true,
            tags: ["🏷️tag", "αβγ", "测试"],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = "special-test-id"
        return post
    }
}
