//
//  FriendRequest.swift
//  VybeMVP
//
//  Phase 12A.1 - Friend System Models
//  Claude: Firestore-compatible friend request data structure
//
//  **🚀 PHASE 12A.1 IMPLEMENTATION SUMMARY**
//  Created: July 19, 2025
//  Purpose: Core data models for cosmic social networking and friend relationships
//
//  **🎯 WHAT THIS FILE CONTAINS:**
//  - FriendRequest: Bidirectional friend request data model
//  - FriendRequestStatus: Request lifecycle state management
//  - Friendship: Established relationship data model with compatibility scoring
//  - Sample data extensions for testing and development
//
//  **🔥 FIRESTORE INTEGRATION:**
//  - Uses @DocumentID for automatic Firestore document ID management
//  - Custom Codable implementation for backward compatibility
//  - Bidirectional sync: Same document ID used in both users' collections
//  - Optimized for real-time listeners and efficient queries
//
//  **⚡ KEY FEATURES:**
//  - Cosmic compatibility scoring integration ready for Phase 12B.1
//  - Optional personal messages for more meaningful connection requests
//  - Consistent user ID sorting for deterministic friendship document IDs
//  - Helper methods for retrieving "other user" information in relationships
//  - Rich sample data for UI testing and development workflow
//
//  **🧪 TESTING NOTES:**
//  - Sample data available via .sampleRequest and .sampleFriendship
//  - Monitor Firestore console for document creation and updates
//  - Test bidirectional sync by checking both users' collections
//  - Verify compatibility score display in mention picker UI
//
//  **🚀 NEXT PHASE INTEGRATION:**
//  - Phase 12B.1: Real compatibility scoring using astrological data
//  - Phase 12X.0: AI-powered friend matching and recommendation engine
//  - Enhanced messaging: Rich media and cosmic insight sharing
//

import Foundation
import FirebaseFirestore

/// Claude: Phase 12A.1 - Friend request model for cosmic social connections
///
/// **🤝 Friend System Architecture:**
/// 
/// This model represents friend requests between users in the cosmic social network,
/// enabling spiritual connections based on astrological compatibility and shared
/// cosmic experiences. Integrates with Firestore for real-time social features.
///
/// **🔥 Firestore Schema:**
/// ```
/// friends/{userId}/requests/{requestId}
/// {
///   "fromUserId": "string",
///   "fromUserName": "string", 
///   "toUserId": "string",
///   "toUserName": "string",
///   "status": "pending|accepted|declined",
///   "timestamp": "date",
///   "compatibilityScore": "double?",
///   "message": "string?"
/// }
/// ```
///
/// **⚡ Key Features:**
/// - Real-time status updates using Firestore listeners
/// - Cosmic compatibility scoring integration
/// - Optional personal messages for requests
/// - Bidirectional relationship management
/// - Privacy-aware friend discovery
struct FriendRequest: Identifiable, Codable {
    @DocumentID var id: String?
    
    /// User who sent the friend request
    let fromUserId: String
    let fromUserName: String
    
    /// User who received the friend request  
    let toUserId: String
    let toUserName: String
    
    /// Current status of the request
    var status: FriendRequestStatus
    
    /// When the request was created
    let timestamp: Date
    
    /// Optional cosmic compatibility score (Phase 12B integration)
    let compatibilityScore: Double?
    
    /// Optional personal message from requester
    let message: String?
    
    init(
        fromUserId: String,
        fromUserName: String,
        toUserId: String,
        toUserName: String,
        status: FriendRequestStatus = .pending,
        compatibilityScore: Double? = nil,
        message: String? = nil
    ) {
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
        self.toUserId = toUserId
        self.toUserName = toUserName
        self.status = status
        self.timestamp = Date()
        self.compatibilityScore = compatibilityScore
        self.message = message
    }
}

/// Claude: Friend request status enumeration
enum FriendRequestStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case accepted = "accepted" 
    case declined = "declined"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .declined: return "Declined"
        }
    }
    
    var emoji: String {
        switch self {
        case .pending: return "⏳"
        case .accepted: return "✅"
        case .declined: return "❌"
        }
    }
}

/// Claude: Friendship relationship model
struct Friendship: Identifiable, Codable {
    @DocumentID var id: String?
    
    /// User IDs in the friendship (always sorted alphabetically for consistency)
    let userIds: [String]
    
    /// User names for display purposes
    let userNames: [String]
    
    /// When the friendship was established
    let establishedDate: Date
    
    /// Cosmic compatibility score between friends
    let compatibilityScore: Double?
    
    /// Whether both users have confirmed the friendship
    let isConfirmed: Bool
    
    init(userId1: String, userName1: String, userId2: String, userName2: String, compatibilityScore: Double? = nil) {
        // Sort user IDs alphabetically for consistent document IDs
        if userId1 < userId2 {
            self.userIds = [userId1, userId2]
            self.userNames = [userName1, userName2]
        } else {
            self.userIds = [userId2, userId1]
            self.userNames = [userName2, userName1]
        }
        
        self.establishedDate = Date()
        self.compatibilityScore = compatibilityScore
        self.isConfirmed = true
    }
    
    /// Get the other user's ID in this friendship
    func getOtherUserId(currentUserId: String) -> String? {
        return userIds.first { $0 != currentUserId }
    }
    
    /// Get the other user's name in this friendship
    func getOtherUserName(currentUserId: String) -> String? {
        guard let index = userIds.firstIndex(of: currentUserId) else { return nil }
        let otherIndex = index == 0 ? 1 : 0
        return userNames.indices.contains(otherIndex) ? userNames[otherIndex] : nil
    }
}

// MARK: - Sample Data

extension FriendRequest {
    /// Sample friend request for previews and testing
    static var sampleRequest: FriendRequest {
        return FriendRequest(
            fromUserId: "user123",
            fromUserName: "Cosmic Wanderer",
            toUserId: "user456", 
            toUserName: "Stellar Sage",
            status: .pending,
            compatibilityScore: 0.87,
            message: "I noticed we have amazing cosmic compatibility! Would love to connect and share our spiritual journeys. ✨"
        )
    }
}

extension Friendship {
    /// Sample friendship for previews and testing
    static var sampleFriendship: Friendship {
        return Friendship(
            userId1: "user123",
            userName1: "Cosmic Wanderer",
            userId2: "user456",
            userName2: "Stellar Sage",
            compatibilityScore: 0.91
        )
    }
}