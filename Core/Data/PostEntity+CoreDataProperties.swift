//
//  PostEntity+CoreDataProperties.swift
//  VybeMVP
//
//  PHASE 17E: Core Data Post Properties for Hybrid Storage
//

import Foundation
import CoreData

extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    // MARK: - Core Post Properties

    @NSManaged public var firebaseId: String?
    @NSManaged public var authorId: String?
    @NSManaged public var authorName: String?
    @NSManaged public var content: String?
    @NSManaged public var type: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isPublic: Bool

    // MARK: - Content & Metadata

    @NSManaged public var tagsString: String?
    @NSManaged public var reactionsJSON: String?
    @NSManaged public var commentCount: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var sightingNumber: Int32
    @NSManaged public var chakraType: String?
    @NSManaged public var journalExcerpt: String?
    @NSManaged public var cosmicSignatureJSON: String?

    // MARK: - Sync Management Properties

    @NSManaged public var needsSync: Bool
    @NSManaged public var pendingOperation: String?
    @NSManaged public var lastSyncTimestamp: Date?
    @NSManaged public var createdTimestamp: Date?
    @NSManaged public var lastModifiedTimestamp: Date?
    @NSManaged public var syncAttempts: Int32
    @NSManaged public var isLocalOnly: Bool
}

// MARK: - Identifiable Conformance

extension PostEntity: Identifiable {
    public var id: String {
        return firebaseId ?? UUID().uuidString
    }
}
