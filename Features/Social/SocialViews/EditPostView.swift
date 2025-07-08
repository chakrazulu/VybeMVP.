/**
 * **EDITPOSTVIEW - POST EDITING INTERFACE**
 * 
 * **PHASE 6 ENHANCEMENT - POST OWNERSHIP CONTROLS**
 * 
 * **OVERVIEW:**
 * Allows users to edit their own posts on the Global Resonance Timeline.
 * Maintains the same cosmic styling and spiritual theming as PostComposerView
 * while providing secure post editing functionality.
 * 
 * **SECURITY:**
 * - Only accessible for posts where authorId matches current user
 * - Validates user ownership before allowing edits
 * - Preserves original post metadata (timestamp, reactions, etc.)
 * 
 * **FEATURES:**
 * - Real-time character count with cosmic styling
 * - Maintains original post's cosmic signature and numerology
 * - Smooth animations and haptic feedback
 * - Error handling with user-friendly messages
 */

import SwiftUI

struct EditPostView: View {
    let post: Post
    let currentUser: SocialUser
    
    @State private var editedContent: String = ""
    @State private var isUpdating = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    private let maxCharacters = 280
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Edit Your Cosmic Message")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Share your updated spiritual insight with the universe")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Content editor
                    VStack(alignment: .leading, spacing: 16) {
                        // Text editor
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            
                            TextEditor(text: $editedContent)
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(16)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                        }
                        .frame(minHeight: 120)
                        
                        // Character count
                        HStack {
                            Spacer()
                            Text("\(editedContent.count)/\(maxCharacters)")
                                .font(.caption)
                                .foregroundColor(editedContent.count > maxCharacters ? .red : .white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(25)
                        
                        Button("Update Post") {
                            updatePost()
                        }
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.pink]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .disabled(isUpdating || editedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || editedContent.count > maxCharacters)
                        .opacity(isUpdating || editedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || editedContent.count > maxCharacters ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                editedContent = post.content
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Update Function
    
    /**
     * Updates the post content via PostManager
     * 
     * SECURITY: Validates user ownership before allowing updates
     * FEATURES: Haptic feedback, error handling, loading states
     */
    private func updatePost() {
        // Verify user ownership
        guard post.authorId == currentUser.userId else {
            errorMessage = "You can only edit your own posts."
            showingError = true
            return
        }
        
        // Validate content
        let trimmedContent = editedContent.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty, trimmedContent.count <= maxCharacters else {
            errorMessage = "Post content must be between 1 and \(maxCharacters) characters."
            showingError = true
            return
        }
        
        // Provide haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        isUpdating = true
        
        Task {
            do {
                try await PostManager.shared.updatePost(post, newContent: trimmedContent)
                print("✅ Successfully updated post: \(post.id ?? "unknown")")
                
                // Success haptic feedback
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)
                
                await MainActor.run {
                    dismiss()
                }
            } catch {
                print("❌ Failed to update post: \(error.localizedDescription)")
                
                await MainActor.run {
                    errorMessage = "Failed to update post. Please try again."
                    showingError = true
                    isUpdating = false
                }
                
                // Error haptic feedback
                let errorFeedback = UINotificationFeedbackGenerator()
                errorFeedback.notificationOccurred(.error)
            }
        }
    }
} 