//
//  PostComposerView.swift
//  VybeMVP
//
//  Cosmic-themed post composer for the Global Resonance Timeline
//

import SwiftUI

struct PostComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var postManager = PostManager.shared
    @State private var content = ""
    @State private var selectedType: PostType = .text
    @State private var selectedTags: [String] = []
    @State private var isPosting = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    // Mock user data - in real app, this would come from user session
    private let currentUser = SocialUser(
        userId: "000536.fe41c9f51a0543059da7d6fe0dc44b7f.1946",
        displayName: "Corey Jermaine Davis",
        lifePathNumber: 3,
        soulUrgeNumber: 5,
        expressionNumber: 7,
        currentFocusNumber: 3
    )
    
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
            Text("Share your spiritual insight")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
            }
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
        
        // Create the post
        postManager.createPost(
            authorName: currentUser.displayName,
            content: content,
            type: selectedType,
            tags: selectedTags,
            cosmicSignature: cosmicSignature
        )
        
        // Success feedback and dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
            dismiss()
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

#Preview {
    PostComposerView()
} 