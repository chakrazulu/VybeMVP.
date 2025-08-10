//
//  Post.swift
//  VybeMVP
//
//  Core model for social posts in the Global Resonance Timeline
//

import Foundation
import FirebaseFirestore
import SwiftUI

/**
 * Post represents a spiritual sharing in the Global Resonance Timeline.
 * Users can share text reflections, number sightings, chakra sessions, and more.
 */
struct Post: Identifiable, Codable {
    @DocumentID var id: String?

    // Author information
    let authorId: String
    let authorName: String

    // Content
    var content: String
    let type: PostType

    // Metadata
    let timestamp: Date
    let isPublic: Bool

    // Spiritual context
    let tags: [String]

    // Social interactions
    var reactions: [String: Int] // reactionType -> count
    var commentCount: Int

    // Optional attachments
    let imageURL: String?
    let sightingNumber: Int?
    let chakraType: String?
    let journalExcerpt: String?

    // Cosmic signature of the author at time of posting
    let cosmicSignature: CosmicSignature?

    // Custom decoding to handle legacy posts
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.authorId = try container.decode(String.self, forKey: .authorId)
        // Handle legacy posts that might not have authorName
        self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName) ?? "Anonymous User"
        self.content = try container.decode(String.self, forKey: .content)
        self.type = try container.decode(PostType.self, forKey: .type)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.isPublic = try container.decodeIfPresent(Bool.self, forKey: .isPublic) ?? true
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        self.reactions = try container.decodeIfPresent([String: Int].self, forKey: .reactions) ?? [:]
        self.commentCount = try container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.sightingNumber = try container.decodeIfPresent(Int.self, forKey: .sightingNumber)
        self.chakraType = try container.decodeIfPresent(String.self, forKey: .chakraType)
        self.journalExcerpt = try container.decodeIfPresent(String.self, forKey: .journalExcerpt)
        self.cosmicSignature = try container.decodeIfPresent(CosmicSignature.self, forKey: .cosmicSignature)
    }

    // Coding keys for decoding
    private enum CodingKeys: String, CodingKey {
        case authorId, authorName, content, type, timestamp, isPublic, tags, reactions, commentCount
        case imageURL, sightingNumber, chakraType, journalExcerpt, cosmicSignature
    }

    init(
        authorId: String,
        authorName: String,
        content: String,
        type: PostType,
        isPublic: Bool = true,
        tags: [String] = [],
        imageURL: String? = nil,
        sightingNumber: Int? = nil,
        chakraType: String? = nil,
        journalExcerpt: String? = nil,
        cosmicSignature: CosmicSignature? = nil
    ) {
        self.authorId = authorId
        self.authorName = authorName
        self.content = content
        self.type = type
        self.timestamp = Date()
        self.isPublic = isPublic
        self.tags = tags
        self.reactions = [:]
        self.commentCount = 0
        self.imageURL = imageURL
        self.sightingNumber = sightingNumber
        self.chakraType = chakraType
        self.journalExcerpt = journalExcerpt
        self.cosmicSignature = cosmicSignature
    }
}

/**
 * PostType defines the different kinds of spiritual content users can share
 */
enum PostType: String, Codable, CaseIterable {
    case text = "text"
    case sighting = "sighting"
    case chakra = "chakra"
    case journal = "journal"
    case reflection = "reflection"
    case manifestation = "manifestation"
    case gratitude = "gratitude"

    var displayName: String {
        switch self {
        case .text: return "Text Share"
        case .sighting: return "Number Sighting"
        case .chakra: return "Chakra Experience"
        case .journal: return "Journal Excerpt"
        case .reflection: return "Spiritual Reflection"
        case .manifestation: return "Manifestation"
        case .gratitude: return "Gratitude"
        }
    }

    var icon: String {
        switch self {
        case .text: return "text.bubble"
        case .sighting: return "eye.fill"
        case .chakra: return "circle.hexagongrid.fill"
        case .journal: return "book.fill"
        case .reflection: return "sparkles"
        case .manifestation: return "star.fill"
        case .gratitude: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .text: return .blue
        case .sighting: return .purple
        case .chakra: return .green
        case .journal: return .orange
        case .reflection: return .indigo
        case .manifestation: return .yellow
        case .gratitude: return .pink
        }
    }

    var description: String {
        switch self {
        case .text: return "Share your thoughts and insights"
        case .sighting: return "Document synchronistic number appearances"
        case .chakra: return "Share chakra work and energy experiences"
        case .journal: return "Share meaningful journal excerpts"
        case .reflection: return "Deep spiritual contemplations"
        case .manifestation: return "Manifestation practices and results"
        case .gratitude: return "Express gratitude and appreciation"
        }
    }
}

/**
 * CosmicSignature captures the spiritual state of a user at the time of posting
 */
struct CosmicSignature: Codable {
    let focusNumber: Int
    let currentChakra: String
    let lifePathNumber: Int
    let realmNumber: Int
    let mood: String?
    let intention: String?

    init(
        focusNumber: Int,
        currentChakra: String,
        lifePathNumber: Int,
        realmNumber: Int,
        mood: String? = nil,
        intention: String? = nil
    ) {
        self.focusNumber = focusNumber
        self.currentChakra = currentChakra
        self.lifePathNumber = lifePathNumber
        self.realmNumber = realmNumber
        self.mood = mood
        self.intention = intention
    }
}

// MARK: - Extensions

extension Post {
    /**
     * Returns the sacred color associated with this post's primary spiritual element
     */
    var sacredColor: Color {
        if let sightingNumber = sightingNumber {
            return getSacredColor(for: sightingNumber)
        } else if let cosmicSignature = cosmicSignature {
            return getSacredColor(for: cosmicSignature.focusNumber)
        } else {
            return type.color
        }
    }

    /**
     * Returns a formatted display of the cosmic signature for UI
     */
    var cosmicSignatureDisplay: String {
        guard let signature = cosmicSignature else { return "" }
        return "Focus \(signature.focusNumber) • \(signature.currentChakra.capitalized) Chakra • Life Path \(signature.lifePathNumber)"
    }

    /**
     * Returns the total reaction count across all reaction types
     */
    var totalReactions: Int {
        return reactions.values.reduce(0, +)
    }
}

/**
 * Helper function to get sacred colors for numbers
 */
private func getSacredColor(for number: Int) -> Color {
    switch number {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return .green
    case 5: return .blue
    case 6: return .indigo
    case 7: return .purple
    case 8: return .brown
    case 9: return .white
    default: return .gray
    }
}
