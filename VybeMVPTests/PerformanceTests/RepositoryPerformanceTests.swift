//
//  RepositoryPerformanceTests.swift
//  VybeMVPTests
//
//  Test Refactoring: Dedicated Performance Tests
//  Properly handles async operations without XCTest measure block conflicts
//
//  Created: July 27, 2025
//  Purpose: Clean separation of performance testing from functional testing
//

import XCTest
import CoreData
import Foundation
@testable import VybeMVP

/**
 * Claude: Dedicated Performance Test Suite
 * 
 * PURPOSE:
 * Focused performance testing that avoids async/measure conflicts by:
 * - Using manual timing instead of XCTest measure blocks
 * - Testing realistic scenarios rather than micro-benchmarks
 * - Focusing on behavior that matters to users
 * 
 * CLEAN TESTING PRINCIPLES:
 * - Test behavior, not implementation
 * - Use realistic data volumes
 * - Measure what users actually experience
 * - Avoid complex async operations in performance tests
 */
@MainActor
class RepositoryPerformanceTests: XCTestCase {
    
    var testPersistenceController: PersistenceController!
    
    override func setUp() {
        super.setUp()
        testPersistenceController = PersistenceController.makeTestController()
    }
    
    override func tearDown() {
        testPersistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Repository Initialization Performance
    
    /**
     * Tests repository initialization time with realistic expectations
     */
    func testRepositoryInitializationTime() async {
        let iterations = 5
        var totalTime: TimeInterval = 0
        
        for _ in 0..<iterations {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            // Create repository (this is what happens in production)
            let repository = TestableHybridPostRepository(
                persistenceController: testPersistenceController
            )
            
            // Ensure it's fully initialized
            XCTAssertNotNil(repository)
            
            let endTime = CFAbsoluteTimeGetCurrent()
            totalTime += (endTime - startTime)
        }
        
        let averageTime = totalTime / Double(iterations)
        let averageTimeMs = averageTime * 1000
        
        // Performance target: Repository should initialize in under 50ms
        XCTAssertLessThan(averageTimeMs, 50.0, 
                         "Repository initialization should be under 50ms, got \(String(format: "%.2f", averageTimeMs))ms")
        
        print("✅ Repository Initialization: \(String(format: "%.2f", averageTimeMs))ms average")
    }
    
    // MARK: - Data Loading Performance
    
    /**
     * Tests Core Data loading performance with realistic data volumes
     */
    func testCoreDataLoadingPerformance() async {
        let repository = TestableHybridPostRepository(
            persistenceController: testPersistenceController
        )
        
        // Create realistic test data (50 posts)
        for i in 0..<50 {
            let post = createTestPost(id: "perf-test-\(i)")
            try? await repository.createPost(post)
        }
        
        // Measure loading time
        let startTime = CFAbsoluteTimeGetCurrent()
        await repository.loadPosts()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        let loadTime = (endTime - startTime) * 1000 // Convert to ms
        
        // Performance target: Loading 50 posts should be under 100ms
        XCTAssertLessThan(loadTime, 100.0,
                         "Loading 50 posts should be under 100ms, got \(String(format: "%.2f", loadTime))ms")
        
        // Verify data was loaded correctly
        XCTAssertEqual(repository.posts.count, 50)
        
        print("✅ Core Data Loading: \(String(format: "%.2f", loadTime))ms for 50 posts")
    }
    
    // MARK: - CRUD Operation Performance
    
    /**
     * Tests post creation performance in batch
     */
    func testBatchPostCreationPerformance() async {
        let repository = TestableHybridPostRepository(
            persistenceController: testPersistenceController
        )
        
        let batchSize = 20
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Create posts in batch
        for i in 0..<batchSize {
            let post = createTestPost(id: "batch-\(i)")
            try? await repository.createPost(post)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = (endTime - startTime) * 1000 // Convert to ms
        let averagePerPost = totalTime / Double(batchSize)
        
        // Performance target: Each post creation should average under 10ms
        XCTAssertLessThan(averagePerPost, 10.0,
                         "Post creation should average under 10ms, got \(String(format: "%.2f", averagePerPost))ms")
        
        // Verify all posts were created
        XCTAssertEqual(repository.posts.count, batchSize)
        
        print("✅ Batch Creation: \(String(format: "%.2f", averagePerPost))ms per post")
    }
    
    /**
     * Tests post update performance
     */
    func testPostUpdatePerformance() async {
        let repository = TestableHybridPostRepository(
            persistenceController: testPersistenceController
        )
        
        // Create initial post
        let post = createTestPost(id: "update-perf-test")
        try? await repository.createPost(post)
        
        guard let createdPost = repository.posts.first else {
            XCTFail("Failed to create initial post")
            return
        }
        
        // Measure update time
        let startTime = CFAbsoluteTimeGetCurrent()
        try? await repository.updatePost(createdPost, newContent: "Updated content")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        let updateTime = (endTime - startTime) * 1000 // Convert to ms
        
        // Performance target: Post update should be under 20ms
        XCTAssertLessThan(updateTime, 20.0,
                         "Post update should be under 20ms, got \(String(format: "%.2f", updateTime))ms")
        
        print("✅ Post Update: \(String(format: "%.2f", updateTime))ms")
    }
    
    // MARK: - Memory Usage Tests
    
    /**
     * Tests memory efficiency with large datasets
     */
    func testMemoryEfficiencyWithLargeDataset() async {
        let repository = TestableHybridPostRepository(
            persistenceController: testPersistenceController
        )
        
        // Create larger dataset (100 posts)
        for i in 0..<100 {
            let post = createTestPost(id: "memory-test-\(i)")
            try? await repository.createPost(post)
        }
        
        // Load all posts
        await repository.loadPosts()
        
        // Verify reasonable memory usage (this is more of a smoke test)
        XCTAssertEqual(repository.posts.count, 100)
        XCTAssertTrue(repository.posts.allSatisfy { !$0.content.isEmpty })
        
        // Clear and verify cleanup
        await repository.clearCache()
        XCTAssertEqual(repository.posts.count, 0)
        
        print("✅ Memory Test: Successfully handled 100 posts and cleanup")
    }
    
    // MARK: - Filtering Performance
    
    /**
     * Tests filtering performance with realistic datasets
     */
    func testFilteringPerformance() async {
        let repository = TestableHybridPostRepository(
            persistenceController: testPersistenceController
        )
        
        // Create mixed dataset
        for i in 0..<50 {
            let post = createTestPost(
                id: "filter-test-\(i)",
                type: i % 2 == 0 ? .text : .journal
            )
            try? await repository.createPost(post)
        }
        
        await repository.loadPosts()
        
        // Measure filtering time
        let startTime = CFAbsoluteTimeGetCurrent()
        let textPosts = await repository.getFilteredPosts(by: .text)
        let journalPosts = await repository.getFilteredPosts(by: .journal)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        let filterTime = (endTime - startTime) * 1000 // Convert to ms
        
        // Performance target: Filtering should be under 10ms
        XCTAssertLessThan(filterTime, 10.0,
                         "Filtering 50 posts should be under 10ms, got \(String(format: "%.2f", filterTime))ms")
        
        // Verify filtering correctness
        XCTAssertEqual(textPosts.count, 25)
        XCTAssertEqual(journalPosts.count, 25)
        XCTAssertTrue(textPosts.allSatisfy { $0.type == .text })
        XCTAssertTrue(journalPosts.allSatisfy { $0.type == .journal })
        
        print("✅ Filtering: \(String(format: "%.2f", filterTime))ms for 50 posts")
    }
    
    // MARK: - Helper Methods
    
    /**
     * Creates a test post with specified parameters
     */
    private func createTestPost(id: String = UUID().uuidString, type: PostType = .text) -> Post {
        var post = Post(
            authorId: "perf-test-author",
            authorName: "Performance Test Author",
            content: "Performance test content for post \(id)",
            type: type,
            isPublic: true,
            tags: ["performance", "test"],
            imageURL: nil,
            sightingNumber: nil,
            chakraType: nil,
            journalExcerpt: nil,
            cosmicSignature: nil
        )
        post.id = id
        return post
    }
}