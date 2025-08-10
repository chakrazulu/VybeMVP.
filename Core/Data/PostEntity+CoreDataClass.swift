//
//  PostEntity+CoreDataClass.swift
//  VybeMVP
//
//  PHASE 17E: Core Data Post Entity for Hybrid Storage
//  Enables complete offline functionality with Firebase sync
//
//  IMPLEMENTATION COMPLETE: July 27, 2025
//  PURPOSE: Local storage backbone for enterprise-grade offline social networking
//  FEATURES: Sync queue management, conflict resolution, zero data loss
//

import Foundation
import CoreData
import SwiftUI

/**
 * Claude: Phase 17E - Core Data Post Entity
 *
 * PURPOSE:
 * Core Data managed object for storing posts locally, enabling:
 * - Complete offline functionality
 * - Instant loading from local storage
 * - Persistent data across app restarts
 * - Sync queue for pending operations
 *
 * HYBRID STORAGE STRATEGY:
 * - Local First: All posts stored in Core Data for instant access
 * - Firebase Sync: Real-time updates sync with Firestore when online
 * - Conflict Resolution: Last-write-wins with timestamp comparison
 * - Offline Operations: Queued and synced when connection returns
 */
@objc(PostEntity)
public class PostEntity: NSManagedObject {

    /**
     * Converts Core Data entity to Post model for UI consumption
     */
    func toPost() -> Post {
        // Create a new Post instance with all the properties from Core Data
        var post = Post(
            authorId: self.authorId ?? "",
            authorName: self.authorName ?? "Unknown User",
            content: self.content ?? "",
            type: PostType(rawValue: self.type ?? "text") ?? .text,
            isPublic: self.isPublic,
            tags: self.tagsArray,
            imageURL: self.imageURL,
            sightingNumber: self.sightingNumber > 0 ? Int(self.sightingNumber) : nil,
            chakraType: self.chakraType,
            journalExcerpt: self.journalExcerpt,
            cosmicSignature: self.cosmicSignature
        )

        // Set the mutable properties from Core Data
        post.id = self.firebaseId
        post.reactions = self.reactionsDict
        post.commentCount = Int(self.commentCount)

        return post
    }

    /**
     * Updates Core Data entity from Post model
     */
    func update(from post: Post) {
        self.firebaseId = post.id
        self.authorId = post.authorId
        self.authorName = post.authorName
        self.content = post.content
        self.type = post.type.rawValue
        self.timestamp = post.timestamp
        self.isPublic = post.isPublic
        self.tagsString = post.tags.joined(separator: ",")
        self.reactionsJSON = encodeReactions(post.reactions)
        self.commentCount = Int32(post.commentCount)
        self.imageURL = post.imageURL
        self.sightingNumber = Int32(post.sightingNumber ?? 0)
        self.chakraType = post.chakraType
        self.journalExcerpt = post.journalExcerpt
        self.cosmicSignatureJSON = encodeCosmicSignature(post.cosmicSignature)
        self.lastSyncTimestamp = Date()
        self.needsSync = false
    }

    /**
     * Creates Core Data entity from Post model
     */
    static func create(from post: Post, in context: NSManagedObjectContext) -> PostEntity {
        let entity = PostEntity(context: context)
        entity.update(from: post)
        entity.createdTimestamp = Date()
        entity.pendingOperation = nil
        return entity
    }

    /**
     * Marks entity for sync with specific operation
     */
    func markForSync(operation: String = "update") {
        self.needsSync = true
        self.pendingOperation = operation
        self.lastModifiedTimestamp = Date()
    }

    // MARK: - Helper Properties

    /**
     * Computed property for tags array
     */
    var tagsArray: [String] {
        guard let tagsString = self.tagsString, !tagsString.isEmpty else { return [] }
        return tagsString.components(separatedBy: ",").filter { !$0.isEmpty }
    }

    /**
     * Computed property for reactions dictionary
     */
    var reactionsDict: [String: Int] {
        guard let json = self.reactionsJSON else { return [:] }
        return decodeReactions(json) ?? [:]
    }

    /**
     * Computed property for cosmic signature
     */
    var cosmicSignature: CosmicSignature? {
        guard let json = self.cosmicSignatureJSON else { return nil }
        return decodeCosmicSignature(json)
    }

    // MARK: - JSON Encoding/Decoding Helpers

    private func encodeReactions(_ reactions: [String: Int]) -> String? {
        guard let data = try? JSONEncoder().encode(reactions) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func decodeReactions(_ json: String) -> [String: Int]? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([String: Int].self, from: data)
    }

    private func encodeCosmicSignature(_ signature: CosmicSignature?) -> String? {
        guard let signature = signature,
              let data = try? JSONEncoder().encode(signature) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func decodeCosmicSignature(_ json: String) -> CosmicSignature? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(CosmicSignature.self, from: data)
    }
}

// MARK: - Core Data Fetch Helpers

extension PostEntity {

    /**
     * Fetches all posts from Core Data ordered by timestamp
     */
    static func fetchAllPosts(in context: NSManagedObjectContext) -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PostEntity.timestamp, ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Core Data fetch error: \(error)")
            return []
        }
    }

    /**
     * Fetches posts that need sync with Firebase
     */
    static func fetchPostsNeedingSync(in context: NSManagedObjectContext) -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "needsSync == YES")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PostEntity.lastModifiedTimestamp, ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Core Data sync fetch error: \(error)")
            return []
        }
    }

    /**
     * Finds post by Firebase ID
     */
    static func findPost(withFirebaseId id: String, in context: NSManagedObjectContext) -> PostEntity? {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "firebaseId == %@", id)
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Core Data find error: \(error)")
            return nil
        }
    }

    /**
     * Deletes post by Firebase ID
     */
    static func deletePost(withFirebaseId id: String, in context: NSManagedObjectContext) {
        if let entity = findPost(withFirebaseId: id, in: context) {
            context.delete(entity)
        }
    }
}
