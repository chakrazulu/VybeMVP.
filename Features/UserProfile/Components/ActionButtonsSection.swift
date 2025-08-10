/*
 * ========================================
 * 🎯 ACTION BUTTONS SECTION COMPONENT
 * ========================================
 *
 * FUNCTIONAL PURPOSE:
 * Interactive action buttons for key user operations within the Sanctum view.
 * Provides quick access to viewing sigil graphics and sharing spiritual profile.
 *
 * COMPONENT FEATURES:
 * - View My Sigil button with purple-indigo gradient
 * - Share Card button with teal-blue gradient
 * - Haptic feedback for enhanced user experience
 * - Consistent button styling with shadow effects
 *
 * VISUAL DESIGN:
 * - Side-by-side button layout with equal width distribution
 * - Gradient backgrounds matching spiritual color palette
 * - SF Symbols icons for clear visual communication
 * - Subtle shadow effects for depth and premium feel
 *
 * MODULAR BENEFITS:
 * - Extracted from monolithic SanctumTabView
 * - Clean separation of action button logic
 * - Easily customizable and extendable for future actions
 * - Consistent styling across all action buttons
 */

import SwiftUI

/// Claude: Action Buttons Section component for profile interactions
struct ActionButtonsSection: View {

    // MARK: - Properties
    @Binding var showingSigilView: Bool
    @Binding var showingShareSheet: Bool

    // MARK: - Body
    var body: some View {
        HStack(spacing: 20) {
            // View Sigil Button
            Button(action: {
                showingSigilView = true
                provideFeedback()
            }) {
                actionButton(
                    icon: "hexagon.fill",
                    title: "View My Sigil",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [.purple, .indigo]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    shadowColor: .purple
                )
            }

            // Share Card Button
            Button(action: {
                showingShareSheet = true
                provideFeedback()
            }) {
                actionButton(
                    icon: "square.and.arrow.up",
                    title: "Share Card",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [.teal, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    shadowColor: .teal
                )
            }
        }
    }

    // MARK: - Action Button Style
    private func actionButton(
        icon: String,
        title: String,
        gradient: LinearGradient,
        shadowColor: Color
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(gradient)
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(color: shadowColor.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    // MARK: - Helper Functions

    /// Claude: Provide haptic feedback for button interactions
    private func provideFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Dark background for proper preview context
        Color.black.ignoresSafeArea()

        ActionButtonsSection(
            showingSigilView: .constant(false),
            showingShareSheet: .constant(false)
        )
        .padding()
    }
}
