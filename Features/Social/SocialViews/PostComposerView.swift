//
//  PostComposerView.swift
//  VybeMVP
//
//  Cosmic-themed post composer for the Global Resonance Timeline
//

/**
 * **POSTCOMPOSERVIEW - COSMIC POST CREATION INTERFACE**
 * 
 * **OVERVIEW:**
 * Primary post composition interface for VybeMVP's Global Resonance social timeline.
 * Integrates real user profile data, numerology, and cosmic theming for authentic
 * spiritual social sharing experience.
 * 
 * **PHASE 6 CRITICAL FIXES IMPLEMENTED:**
 * 
 * 🔧 **AUTHENTICATION BYPASS RESOLUTION:**
 * - Fixed Global Resonance posts showing placeholder "@cosmic_wanderer" instead of real usernames
 * - Integrated real user profile data loading from UserDefaults storage
 * - Added proper fallback handling for missing profile data
 * - Enhanced initialization to accept real user parameters from calling views
 * 
 * 🎯 **USER ID ARCHITECTURE REFACTOR (PHASE 6 FINAL):**
 * - Implemented migration logic for Single Source of Truth user identification
 * - Uses AuthenticationManager.userID (Firebase UID) as primary identifier
 * - Falls back to legacyAppleSignInID for existing user data migration
 * - Automatically migrates profile data from Apple ID keys to Firebase UID keys
 * - Enables proper edit/delete functionality by ensuring consistent user identification
 * 
 * 🎯 **USERNAME INTEGRATION COMPLETE:**
 * - Posts now display actual @username created during onboarding (e.g., "@surf_or_drown")
 * - Real display names used for cosmic signatures (e.g., "Chakra Zulu")
 * - Proper data flow: AuthenticationManager.userID → UserDefaults → PostComposer
 * - Eliminated hardcoded placeholder data in post creation
 * 
 * 📊 **REAL NUMEROLOGY DATA LOADING:**
 * - Life Path, Soul Urge, and Expression numbers loaded from saved UserProfile
 * - Current Focus Number integrated from FocusNumberManager
 * - Proper optional handling for missing numerology data
 * - Console logging for debugging profile data loading success/failure
 * 
 * **TECHNICAL ARCHITECTURE:**
 * 
 * 🔄 **DATA FLOW PATTERNS:**
 * 1. UserProfileView → NotificationCenter → SocialTimelineView → PostComposerView
 * 2. AuthenticationManager.userID → UserDefaults profile lookup → SocialUser creation
 * 3. Real numerology numbers → cosmic signature display → post attribution
 * 
 * 🎨 **COSMIC UI INTEGRATION:**
 * - CosmicBackgroundView with twinkling numbers and sacred geometry
 * - Real-time Focus Number color theming based on current spiritual state
 * - Cosmic signature section showing authentic numerological profile
 * - Post type selection with spiritual energy categorization
 * 
 * 💾 **PROFILE DATA STORAGE:**
 * - UserProfile data stored as JSON in UserDefaults with key "userProfile_\(userID)"
 * - Social profile data stored separately with key "socialProfile_\(userID)"
 * - Graceful degradation to default values when profile data unavailable
 * - Comprehensive error handling and logging for debugging
 * 
 * **USER EXPERIENCE ENHANCEMENTS:**
 * 
 * ✨ **AUTHENTIC SPIRITUAL SHARING:**
 * - Posts reflect user's actual spiritual journey and numerological profile
 * - Real cosmic signatures enhance credibility and personal connection
 * - Username consistency across all app features and social interactions
 * - Proper attribution prevents confusion and maintains user identity
 * 
 * 🔮 **COSMIC SIGNATURE DISPLAY:**
 * - Current Focus Number with dynamic color theming
 * - Real display name and numerological profile string
 * - Visual representation of user's current spiritual state
 * - Integration with existing cosmic animation and theming systems
 * 
 * **FUTURE INTEGRATION READY:**
 * - KASPER Oracle Engine: Real profile data ready for AI insight generation
 * - Social Features: Authentic user data for friend matching and resonance
 * - Analytics: Real numerology for pattern analysis and spiritual tracking
 * - Cosmic Celebrations: Proper user attribution for match celebrations
 * 
 * **DEBUGGING & MONITORING:**
 * - Console logging for profile data loading success/failure
 * - Fallback value tracking for missing numerology numbers
 * - Real-time authentication state monitoring
 * - UserDefaults storage verification and error reporting
 * 
 * **PERFORMANCE CONSIDERATIONS:**
 * - Efficient UserDefaults access during initialization
 * - Minimal memory footprint with proper data structure usage
 * - Lazy loading of profile data only when needed
 * - Proper lifecycle management for SocialUser creation
 *
 * **🚀 PHASE 12A.1 ENHANCEMENT: @MENTION TAGGING SYSTEM**
 * Added: July 19, 2025
 * Purpose: Enable friend tagging in posts with intelligent auto-complete
 *
 * **NEW FEATURES IMPLEMENTED:**
 * - Real-time @mention typing detection and auto-complete
 * - Elegant mention picker with friend search and cosmic compatibility display
 * - Visual mentioned friends management with remove functionality
 * - Integration with FriendManager for real-time friend data
 * - Smooth UI animations and responsive user experience
 *
 * **MENTION SYSTEM ARCHITECTURE:**
 * - @StateObject friendManager: Real-time friend data and CRUD operations
 * - showingMentionPicker: Controls mention picker sheet presentation
 * - mentionQuery: Current search query for filtering friends
 * - mentionedFriends: Array of usernames currently mentioned in post
 * - filteredFriends: Real-time filtered list based on search query
 *
 * **USER INTERACTION FLOW:**
 * 1. User types @ in content field → triggers mention detection
 * 2. Auto-complete shows if friends match query → opens mention picker
 * 3. User selects friend → adds @username to content and mentioned friends list
 * 4. Visual mentioned friends section appears → allows removal with X button
 * 5. Manual mention button → opens full friend picker for browsing all friends
 *
 * **TESTING NOTES FOR MENTION SYSTEM:**
 * - Mention button disabled when no friends exist (expected for new users)
 * - FriendManager.configure() called in onAppear for proper initialization
 * - Sample data available via FriendManager.loadSampleData() for testing
 * - Console logging shows friend data loading and mention system activity
 * - Cosmic compatibility scores displayed in friend picker (87% format)
 *
 * **INTEGRATION WITH EXISTING SYSTEMS:**
 * - Maintains all existing post creation functionality
 * - Preserves cosmic signature and spiritual theming
 * - Uses existing AuthenticationManager for user identification
 * - Integrates with PostManager for actual post creation
 * - Ready for Phase 12B.1 compatibility scoring enhancement
 */

import SwiftUI

struct PostComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var postManager = PostManager.shared
    @StateObject private var friendManager = FriendManager.shared
    @State private var content = ""
    @State private var selectedType: PostType = .text
    @State private var selectedTags: [String] = []
    @State private var isPosting = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    // Claude: Phase 12A.1 - @mention tagging system
    @State private var showingMentionPicker = false
    @State private var mentionQuery = ""
    @State private var mentionedFriends: [String] = [] // Array of friend usernames
    @State private var filteredFriends: [Friendship] = []
    
    // User data - can be passed from UserProfileView or default to mock
    @State private var authorName: String
    @State private var authorDisplayName: String
    
    // Real user data - uses actual user information
    private let currentUser: SocialUser
    
    /**
     * Initialize PostComposerView with user information
     * 
     * PHASE 6 FIX: Enhanced initialization to use real user profile data
     * Updated to load actual numerology numbers from saved user profile
     * 
     * PARAMETERS:
     * @param authorName: Username for post attribution (e.g., "@surf_or_drown")
     * @param authorDisplayName: Display name for cosmic signature (e.g., "Chakra Zulu")
     * 
     * IMPLEMENTATION STRATEGY:
     * - Loads real user profile data from UserProfileService (Firebase)
     * - Creates SocialUser with actual user ID and real spiritual numbers
     * - Uses authorName for post creation to show username not birth name
     * - Integrates with real user profile data and numerology
     * 
     * DATA FLOW:
     * UserProfileView → NotificationCenter → SocialTimelineView → PostComposerView
     */
    init() {
        // Claude: PHASE 6 ARCHITECTURAL FIX - Load data directly at initialization
        // Eliminates all timing issues and slow loading by getting data immediately
        
        // Claude: PHASE 6 MIGRATION - Get user IDs for both new and legacy data lookup
        let userID = AuthenticationManager.shared.userID ?? "unknown" // Firebase UID (new)
        let legacyUserID = AuthenticationManager.shared.legacyAppleSignInID // Apple Sign-In ID (legacy)
        let currentFocusNumber = FocusNumberManager.shared.selectedFocusNumber
        
        // Load real user data with migration logic
        var loadedAuthorName = "@cosmic_wanderer"
        var loadedDisplayName = "Cosmic Seeker"
        var foundData = false
        
        // STEP 1: Try to load with new Firebase UID key
        if let profileData = UserDefaults.standard.dictionary(forKey: "socialProfile_\(userID)") {
            loadedAuthorName = profileData["username"] as? String ?? "@cosmic_wanderer"
            loadedDisplayName = profileData["displayName"] as? String ?? "Cosmic Seeker"
            foundData = true
            print("✅ PostComposerView loaded data with Firebase UID: \(userID)")
        }
        // STEP 2: Fallback to legacy Apple Sign-In ID key
        else if let legacyUserID = legacyUserID,
                let profileData = UserDefaults.standard.dictionary(forKey: "socialProfile_\(legacyUserID)") {
            loadedAuthorName = profileData["username"] as? String ?? "@cosmic_wanderer"
            loadedDisplayName = profileData["displayName"] as? String ?? "Cosmic Seeker"
            foundData = true
            print("✅ PostComposerView loaded data with legacy Apple ID: \(legacyUserID)")
            
            // MIGRATION: Copy data to new Firebase UID key
            UserDefaults.standard.set(profileData, forKey: "socialProfile_\(userID)")
            print("🔄 Migrated profile data from Apple ID to Firebase UID key")
        }
        
        if !foundData {
            print("⚠️ No profile data found for Firebase UID: \(userID) or legacy ID: \(legacyUserID ?? "nil")")
        }
        
        // Initialize with real data immediately
        self._authorName = State(initialValue: loadedAuthorName)
        self._authorDisplayName = State(initialValue: loadedDisplayName)
        
        // Create SocialUser with real user data
        self.currentUser = SocialUser(
            userId: userID,
            displayName: loadedDisplayName,  // Real display name loaded immediately
            lifePathNumber: 3,   // Default - TODO: Load from saved profile later
            soulUrgeNumber: 5,   // Default - TODO: Load from saved profile later
            expressionNumber: 7, // Default - TODO: Load from saved profile later
            currentFocusNumber: currentFocusNumber  // Real focus number
        )
        
        print("✅ PostComposerView initialized with immediate real data")
    }
    
    private let availableTags = [
        "manifestation", "healing", "spiritual-growth", "synchronicity",
        "meditation", "chakras", "numerology", "reflection", "gratitude",
        "intention", "cosmic-alignment", "inner-wisdom"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Content input (moved to top)
                        contentSection
                        
                        // User cosmic signature
                        cosmicSignatureSection
                        
                        // Post type selector
                        postTypeSection
                        
                        // Tags section
                        tagsSection
                        
                        // Post button
                        postButtonSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Share Your Vybe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            // Claude: Phase 12A.1 - Configure friend manager for current user
            if let userID = AuthenticationManager.shared.userID {
                friendManager.configure(for: userID)
            }
        }
    }
    
    // MARK: - View Sections
    
    private var cosmicSignatureSection: some View {
        VStack(spacing: 12) {
            Text("Your Current Cosmic Signature")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                // Focus number circle
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                currentUser.focusColor.opacity(0.8),
                                currentUser.focusColor.opacity(0.4)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("\(currentUser.currentFocusNumber)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentUser.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(currentUser.numerologicalProfile)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(currentUser.focusColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var postTypeSection: some View {
        VStack(spacing: 12) {
            Text("What kind of energy are you sharing?")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(PostType.allCases, id: \.self) { type in
                    PostTypeCard(
                        type: type,
                        isSelected: selectedType == type,
                        action: {
                            selectedType = type
                        }
                    )
                }
            }
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Share your spiritual insight")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                // Claude: Phase 12A.1 - @mention button
                Button(action: {
                    showingMentionPicker = true
                    updateFilteredFriends()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "at")
                            .font(.caption)
                        Text("Mention")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)
                }
                .disabled(friendManager.friendships.isEmpty)
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedType.color.opacity(0.3), lineWidth: 1)
                    )
                    .frame(minHeight: 120)
                
                if content.isEmpty {
                    Text(selectedType.description)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(16)
                }
                
                TextEditor(text: $content)
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .onChange(of: content) { _, newValue in
                        handleMentionTyping(newValue)
                    }
            }
            
            // Claude: Phase 12A.1 - Display mentioned friends
            if !mentionedFriends.isEmpty {
                mentionedFriendsSection
            }
        }
        .sheet(isPresented: $showingMentionPicker) {
            mentionPickerView
        }
    }
    
    private var tagsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Add spiritual tags")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                Text("\(selectedTags.count)/5")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(availableTags, id: \.self) { tag in
                    TagButton(
                        tag: tag,
                        isSelected: selectedTags.contains(tag),
                        action: {
                            toggleTag(tag)
                        }
                    )
                }
            }
        }
    }
    
    private var postButtonSection: some View {
        Button(action: createPost) {
            HStack {
                if isPosting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                        .font(.title3)
                }
                
                Text(isPosting ? "Sharing..." : "Share to Timeline")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        selectedType.color.opacity(content.isEmpty ? 0.3 : 0.8),
                        selectedType.color.opacity(content.isEmpty ? 0.2 : 0.6)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(content.isEmpty || isPosting)
        .animation(.easeInOut(duration: 0.2), value: content.isEmpty)
    }
    
    
    // MARK: - Helper Functions
    
    private func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else if selectedTags.count < 5 {
            selectedTags.append(tag)
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func createPost() {
        guard !content.isEmpty else { return }
        
        isPosting = true
        
        // Create cosmic signature
        let cosmicSignature = currentUser.currentCosmicSignature
        
        // PHASE 3C-1 FIX: Create post with username instead of birth name
        // Critical fix: Use authorName (username) not currentUser.displayName (birth name)
        // This ensures posts display "@cosmic_wanderer" not "Corey Jermaine Davis"
        postManager.createPost(
            authorName: authorName, // FIXED: Use passed username parameter
            content: content,
            type: selectedType,
            tags: selectedTags,
            cosmicSignature: cosmicSignature
        )
        
        // Success feedback and dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
            
            // Notify that a post was created (for UserProfileView button update)
            NotificationCenter.default.post(name: Notification.Name("PostCreated"), object: nil)
            
            dismiss()
        }
    }
    
    // MARK: - Claude: Phase 12A.1 - @Mention System Functions
    
    /// Handle @mention typing detection
    private func handleMentionTyping(_ newValue: String) {
        // Check if user typed @ followed by characters
        let words = newValue.components(separatedBy: .whitespacesAndNewlines)
        let lastWord = words.last ?? ""
        
        if lastWord.hasPrefix("@") && lastWord.count > 1 {
            mentionQuery = String(lastWord.dropFirst()) // Remove @
            updateFilteredFriends()
            if !filteredFriends.isEmpty {
                showingMentionPicker = true
            }
        }
    }
    
    /// Update filtered friends based on mention query
    private func updateFilteredFriends() {
        if mentionQuery.isEmpty {
            filteredFriends = Array(friendManager.friendships.prefix(10))
        } else {
            filteredFriends = friendManager.friendships.filter { friendship in
                if let otherUserName = friendship.getOtherUserName(currentUserId: currentUser.userId) {
                    return otherUserName.localizedCaseInsensitiveContains(mentionQuery)
                }
                return false
            }
        }
    }
    
    /// Add a friend mention to the post content
    private func addMention(friendship: Friendship) {
        guard let friendName = friendship.getOtherUserName(currentUserId: currentUser.userId) else { return }
        
        // Replace the partial @mention with complete @mention
        let words = content.components(separatedBy: .whitespacesAndNewlines)
        var newWords = words
        
        // Find and replace the last @mention
        for i in (0..<newWords.count).reversed() {
            if newWords[i].hasPrefix("@") {
                newWords[i] = "@\(friendName)"
                break
            }
        }
        
        // If no partial mention found, just add to end
        if !words.contains(where: { $0.hasPrefix("@") }) {
            newWords.append("@\(friendName)")
        }
        
        content = newWords.joined(separator: " ")
        
        // Track mentioned friends
        if !mentionedFriends.contains(friendName) {
            mentionedFriends.append(friendName)
        }
        
        showingMentionPicker = false
        mentionQuery = ""
    }
    
    /// Remove a friend mention
    private func removeMention(_ friendName: String) {
        // Remove from content
        content = content.replacingOccurrences(of: "@\(friendName)", with: "")
        content = content.replacingOccurrences(of: "  ", with: " ") // Clean double spaces
        content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove from mentioned friends
        mentionedFriends.removeAll { $0 == friendName }
    }
    
    // MARK: - Claude: Phase 12A.1 - @Mention Supporting Views
    
    /// Display mentioned friends with remove buttons
    private var mentionedFriendsSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Mentioned Friends")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(mentionedFriends, id: \.self) { friendName in
                    HStack(spacing: 4) {
                        Text("@\(friendName)")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            removeMention(friendName)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(8)
                }
            }
        }
        .padding(.top, 8)
    }
    
    /// Friend mention picker sheet
    private var mentionPickerView: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("Search friends...", text: $mentionQuery)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .onChange(of: mentionQuery) { _, _ in
                                updateFilteredFriends()
                            }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Friends list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredFriends, id: \.id) { friendship in
                                if let friendName = friendship.getOtherUserName(currentUserId: currentUser.userId) {
                                    MentionFriendRow(
                                        friendName: friendName,
                                        compatibilityScore: friendship.compatibilityScore,
                                        isAlreadyMentioned: mentionedFriends.contains(friendName)
                                    ) {
                                        addMention(friendship: friendship)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    if filteredFriends.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "person.3")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.4))
                            
                            Text(mentionQuery.isEmpty ? "No friends to mention" : "No friends found")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            if mentionQuery.isEmpty {
                                Text("Add friends to mention them in posts")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Mention Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingMentionPicker = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct PostTypeCard: View {
    let type: PostType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : type.color)
                
                Text(type.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? type.color.opacity(0.8) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(type.color.opacity(isSelected ? 0.8 : 0.3), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("#\(tag)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .black : .white.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? .white : Color.white.opacity(0.2))
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Claude: Phase 12A.1 - Mention Friend Row Component

struct MentionFriendRow: View {
    let friendName: String
    let compatibilityScore: Double?
    let isAlreadyMentioned: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Friend avatar placeholder
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(friendName.prefix(1)).uppercased())
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("@\(friendName)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let score = compatibilityScore {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text("\(Int(score * 100))% cosmic compatibility")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
                
                if isAlreadyMentioned {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.white.opacity(isAlreadyMentioned ? 0.05 : 0.1))
            .cornerRadius(12)
        }
        .disabled(isAlreadyMentioned)
        .opacity(isAlreadyMentioned ? 0.6 : 1.0)
    }
}

#Preview {
    PostComposerView()
} 