//
//  FriendManager.swift
//  VybeMVP
//
//  Phase 12A.1 - Friend System Service Layer
//  Claude: Firestore CRUD operations for cosmic social connections
//
//  **🚀 PHASE 12A.1 IMPLEMENTATION SUMMARY**
//  Created: July 19, 2025
//  Purpose: Complete friend system infrastructure for cosmic social networking
//
//  **🎯 WHAT THIS FILE DOES:**
//  - Manages all friend-related operations (send/accept/decline requests)
//  - Provides real-time updates using Firestore listeners and Combine
//  - Handles bidirectional friendship data synchronization
//  - Integrates cosmic compatibility scoring for Phase 12B.1
//  - Offers comprehensive error handling and user feedback
//
//  **🔥 FIRESTORE ARCHITECTURE:**
//  friends/{userId}/requests/{requestId} → FriendRequest documents
//  friends/{userId}/friendships/{friendshipId} → Friendship documents
//  - Bidirectional: Each request/friendship exists in both users' collections
//  - Real-time: Uses Firestore listeners for instant UI updates
//  - Secure: Privacy-aware friend discovery and relationship management
//
//  **⚡ KEY FEATURES:**
//  - @MainActor for thread-safe UI updates
//  - @Published properties for SwiftUI state management
//  - Batch operations for consistent Firestore writes
//  - Sample data support for testing and development
//  - Compatibility with existing authentication system
//
//  **🧪 TESTING NOTES:**
//  - Initialize with configure(for: userId) in PostComposerView.onAppear
//  - Sample data available via loadSampleData() for UI testing
//  - Monitor console for real-time listener updates and error messages
//  - Friend count and pending request count computed properties for UI
//
//  **🚀 NEXT PHASE INTEGRATION:**
//  - Phase 12B.1: Weighted compatibility scoring using cosmic data
//  - Phase 12X.0: AI-powered friend recommendations and insights
//  - Real user integration: Connect to actual Firebase user accounts
//

import Foundation
import FirebaseFirestore
import Combine

/// Claude: Phase 12A.1 - Friend system manager for cosmic social network
///
/// **🤝 Friend System Architecture:**
/// 
/// This manager handles all friend-related operations including sending requests,
/// accepting/declining requests, and managing friendships in the cosmic social network.
/// Integrates seamlessly with Firestore for real-time social features.
///
/// **🔥 Firestore Collection Structure:**
/// ```
/// friends/
/// ├── {userId}/
/// │   ├── requests/
/// │   │   └── {requestId} → FriendRequest
/// │   └── friendships/
/// │       └── {friendshipId} → Friendship
/// ```
///
/// **⚡ Key Features:**
/// - Real-time friend request monitoring using Combine
/// - Bidirectional friendship management
/// - Cosmic compatibility integration ready
/// - Privacy-aware friend discovery
/// - Efficient batch operations for social graph updates
@MainActor
class FriendManager: ObservableObject {
    static let shared = FriendManager()
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published Properties
    
    /// Current user's pending friend requests (received)
    @Published var incomingRequests: [FriendRequest] = []
    
    /// Current user's sent friend requests (pending responses)
    @Published var outgoingRequests: [FriendRequest] = []
    
    /// Current user's established friendships
    @Published var friendships: [Friendship] = []
    
    /// Loading states for UI feedback
    @Published var isLoadingRequests = false
    @Published var isLoadingFriendships = false
    
    /// Error handling
    @Published var lastError: Error?
    
    // MARK: - Private Properties
    
    private var currentUserId: String?
    private var requestsListener: ListenerRegistration?
    private var friendshipsListener: ListenerRegistration?
    
    private init() {}
    
    // MARK: - Setup & Configuration
    
    /// Configure friend manager for specific user
    func configure(for userId: String) {
        currentUserId = userId
        startListeners()
    }
    
    /// Clean up listeners when user signs out
    func cleanup() {
        stopListeners()
        currentUserId = nil
        incomingRequests.removeAll()
        outgoingRequests.removeAll()
        friendships.removeAll()
    }
    
    // MARK: - Real-time Listeners
    
    private func startListeners() {
        guard let userId = currentUserId else { return }
        
        startRequestsListener(for: userId)
        startFriendshipsListener(for: userId)
    }
    
    private func stopListeners() {
        requestsListener?.remove()
        friendshipsListener?.remove()
        requestsListener = nil
        friendshipsListener = nil
    }
    
    private func startRequestsListener(for userId: String) {
        isLoadingRequests = true
        
        requestsListener = db.collection("friends")
            .document(userId)
            .collection("requests")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.isLoadingRequests = false
                    
                    if let error = error {
                        self?.lastError = error
                        print("❌ Friend requests listener error: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    let requests = documents.compactMap { doc -> FriendRequest? in
                        try? doc.data(as: FriendRequest.self)
                    }
                    
                    // Claude: Phase 16 optional unwrapping safety improvement
                    // Previous: Direct assignment could crash if self was deallocated
                    // Current: Safe optional chaining prevents crashes
                    self?.incomingRequests = requests.filter { $0.toUserId == userId }
                    self?.outgoingRequests = requests.filter { $0.fromUserId == userId }
                    
                    print("🔄 Friend requests updated: \(self?.incomingRequests.count ?? 0) incoming, \(self?.outgoingRequests.count ?? 0) outgoing")
                }
            }
    }
    
    private func startFriendshipsListener(for userId: String) {
        isLoadingFriendships = true
        
        friendshipsListener = db.collection("friends")
            .document(userId)
            .collection("friendships")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.isLoadingFriendships = false
                    
                    if let error = error {
                        // Claude: Phase 16 optional unwrapping safety improvement
                        // Previous: self.lastError = error (force unwrapping could crash)
                        // Current: self?.lastError = error (safe optional chaining)
                        self?.lastError = error
                        print("❌ Friendships listener error: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.friendships = documents.compactMap { doc -> Friendship? in
                        try? doc.data(as: Friendship.self)
                    }
                    
                    print("🔄 Friendships updated: \(self?.friendships.count ?? 0) active friendships")
                }
            }
    }
    
    // MARK: - Friend Request Operations
    
    /// Send a friend request to another user
    func sendFriendRequest(
        to userId: String,
        userName: String,
        from currentUserName: String,
        message: String? = nil,
        compatibilityScore: Double? = nil
    ) async throws {
        guard let currentUserId = currentUserId else {
            throw FriendError.notAuthenticated
        }
        
        // Check if friendship already exists
        if isFriend(userId: userId) {
            throw FriendError.alreadyFriends
        }
        
        // Check if request already sent
        if hasOutgoingRequest(to: userId) {
            throw FriendError.requestAlreadySent
        }
        
        let request = FriendRequest(
            fromUserId: currentUserId,
            fromUserName: currentUserName,
            toUserId: userId,
            toUserName: userName,
            compatibilityScore: compatibilityScore,
            message: message
        )
        
        // Add to both users' request collections
        let batch = db.batch()
        
        // Add to sender's outgoing requests
        let senderRef = db.collection("friends")
            .document(currentUserId)
            .collection("requests")
            .document()
        
        // Add to recipient's incoming requests
        let recipientRef = db.collection("friends")
            .document(userId)
            .collection("requests")
            .document(senderRef.documentID) // Use same ID for consistency
        
        do {
            try batch.setData(from: request, forDocument: senderRef)
            try batch.setData(from: request, forDocument: recipientRef)
            
            try await batch.commit()
            print("✅ Friend request sent to \(userName)")
        } catch {
            print("❌ Failed to send friend request: \(error)")
            throw error
        }
    }
    
    /// Accept an incoming friend request
    func acceptFriendRequest(_ request: FriendRequest) async throws {
        guard let currentUserId = currentUserId else {
            throw FriendError.notAuthenticated
        }
        
        guard request.toUserId == currentUserId else {
            throw FriendError.invalidRequest
        }
        
        // Create friendship
        let friendship = Friendship(
            userId1: request.fromUserId,
            userName1: request.fromUserName,
            userId2: request.toUserId,
            userName2: request.toUserName,
            compatibilityScore: request.compatibilityScore
        )
        
        let batch = db.batch()
        
        // Add friendship to both users
        let friendshipId = "\(min(request.fromUserId, request.toUserId))_\(max(request.fromUserId, request.toUserId))"
        
        let friendship1Ref = db.collection("friends")
            .document(request.fromUserId)
            .collection("friendships")
            .document(friendshipId)
        
        let friendship2Ref = db.collection("friends")
            .document(request.toUserId)
            .collection("friendships")
            .document(friendshipId)
        
        // Remove requests from both users
        let request1Ref = db.collection("friends")
            .document(request.fromUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        let request2Ref = db.collection("friends")
            .document(request.toUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        do {
            try batch.setData(from: friendship, forDocument: friendship1Ref)
            try batch.setData(from: friendship, forDocument: friendship2Ref)
            batch.deleteDocument(request1Ref)
            batch.deleteDocument(request2Ref)
            
            try await batch.commit()
            print("✅ Friend request accepted from \(request.fromUserName)")
        } catch {
            print("❌ Failed to accept friend request: \(error)")
            throw error
        }
    }
    
    /// Decline an incoming friend request
    func declineFriendRequest(_ request: FriendRequest) async throws {
        guard let currentUserId = currentUserId else {
            throw FriendError.notAuthenticated
        }
        
        guard request.toUserId == currentUserId else {
            throw FriendError.invalidRequest
        }
        
        let batch = db.batch()
        
        // Remove request from both users
        let request1Ref = db.collection("friends")
            .document(request.fromUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        let request2Ref = db.collection("friends")
            .document(request.toUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        batch.deleteDocument(request1Ref)
        batch.deleteDocument(request2Ref)
        
        do {
            try await batch.commit()
            print("✅ Friend request declined from \(request.fromUserName)")
        } catch {
            print("❌ Failed to decline friend request: \(error)")
            throw error
        }
    }
    
    /// Cancel an outgoing friend request
    func cancelFriendRequest(_ request: FriendRequest) async throws {
        guard let currentUserId = currentUserId else {
            throw FriendError.notAuthenticated
        }
        
        guard request.fromUserId == currentUserId else {
            throw FriendError.invalidRequest
        }
        
        let batch = db.batch()
        
        // Remove request from both users
        let request1Ref = db.collection("friends")
            .document(request.fromUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        let request2Ref = db.collection("friends")
            .document(request.toUserId)
            .collection("requests")
            .document(request.id ?? "")
        
        batch.deleteDocument(request1Ref)
        batch.deleteDocument(request2Ref)
        
        do {
            try await batch.commit()
            print("✅ Friend request cancelled to \(request.toUserName)")
        } catch {
            print("❌ Failed to cancel friend request: \(error)")
            throw error
        }
    }
    
    // MARK: - Friendship Management
    
    /// Remove a friendship (unfriend)
    func removeFriendship(_ friendship: Friendship) async throws {
        guard let currentUserId = currentUserId else {
            throw FriendError.notAuthenticated
        }
        
        guard friendship.userIds.contains(currentUserId) else {
            throw FriendError.invalidRequest
        }
        
        let friendshipId = friendship.id ?? ""
        let batch = db.batch()
        
        // Remove friendship from both users
        for userId in friendship.userIds {
            let friendshipRef = db.collection("friends")
                .document(userId)
                .collection("friendships")
                .document(friendshipId)
            
            batch.deleteDocument(friendshipRef)
        }
        
        do {
            try await batch.commit()
            print("✅ Friendship removed")
        } catch {
            print("❌ Failed to remove friendship: \(error)")
            throw error
        }
    }
    
    // MARK: - Helper Methods
    
    /// Check if user is already a friend
    func isFriend(userId: String) -> Bool {
        return friendships.contains { $0.userIds.contains(userId) }
    }
    
    /// Check if outgoing request already sent to user
    func hasOutgoingRequest(to userId: String) -> Bool {
        return outgoingRequests.contains { $0.toUserId == userId }
    }
    
    /// Check if incoming request exists from user
    func hasIncomingRequest(from userId: String) -> Bool {
        return incomingRequests.contains { $0.fromUserId == userId }
    }
    
    /// Get friendship with specific user
    func getFriendship(with userId: String) -> Friendship? {
        return friendships.first { $0.userIds.contains(userId) }
    }
    
    /// Get friend count
    var friendCount: Int {
        return friendships.count
    }
    
    /// Get pending request count (both incoming and outgoing)
    var pendingRequestCount: Int {
        return incomingRequests.count + outgoingRequests.count
    }
}

// MARK: - Error Handling

/// Claude: Friend system error types
enum FriendError: LocalizedError {
    case notAuthenticated
    case alreadyFriends
    case requestAlreadySent
    case invalidRequest
    case userNotFound
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User not authenticated"
        case .alreadyFriends:
            return "Users are already friends"
        case .requestAlreadySent:
            return "Friend request already sent"
        case .invalidRequest:
            return "Invalid friend request"
        case .userNotFound:
            return "User not found"
        case .networkError:
            return "Network connection error"
        }
    }
}

// MARK: - Sample Data Extension

extension FriendManager {
    /// Sample friend data for previews and testing
    func loadSampleData() {
        incomingRequests = [
            FriendRequest.sampleRequest,
            FriendRequest(
                fromUserId: "user789",
                fromUserName: "Mystic Oracle",
                toUserId: "currentUser",
                toUserName: "Test User",
                status: .pending,
                compatibilityScore: 0.74,
                message: "I see we share similar cosmic vibrations! Let's connect on this spiritual journey. 🔮"
            )
        ]
        
        friendships = [
            Friendship.sampleFriendship,
            Friendship(
                userId1: "currentUser",
                userName1: "Test User",
                userId2: "user101",
                userName2: "Star Weaver",
                compatibilityScore: 0.85
            )
        ]
    }
}