/*
 * ========================================
 * 👤 PROFILE SUMMARY SECTION COMPONENT
 * ========================================
 *
 * INFORMATIONAL PURPOSE:
 * User preference display showing spiritual modes, insight tones, focus areas,
 * and cosmic preferences in a clean, organized format for profile overview.
 *
 * COMPONENT FEATURES:
 * - Spiritual Modes row with purple heart icon
 * - Insight Tone row with blue message icon
 * - Focus Areas row with green tag icon (comma-separated list)
 * - Cosmic Preference row with cyan moon-stars icon
 * - Consistent row styling with colored SF Symbol icons
 *
 * VISUAL DESIGN:
 * - Clean white-text header with left alignment
 * - Individual preference rows with icon-title-value layout
 * - Subtle black container with white border opacity
 * - Minimalist design focusing on content readability
 *
 * MODULAR BENEFITS:
 * - Extracted from monolithic SanctumTabView
 * - Clean separation of profile display logic
 * - Easy to modify preference categories
 * - Consistent styling for profile information
 */

import SwiftUI

/// Claude: Profile Summary Section component for displaying user preferences
struct ProfileSummarySection: View {

    // MARK: - Properties
    let profile: UserProfile

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Text("Spiritual Preferences")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                ProfileSummaryRow(
                    icon: "heart.circle.fill",
                    title: "Spiritual Modes",
                    value: profile.spiritualMode,
                    color: .purple
                )

                ProfileSummaryRow(
                    icon: "message.circle.fill",
                    title: "Insight Tone",
                    value: profile.insightTone,
                    color: .blue
                )

                ProfileSummaryRow(
                    icon: "tag.circle.fill",
                    title: "Focus Areas",
                    value: profile.focusTags.joined(separator: ", "),
                    color: .green
                )

                ProfileSummaryRow(
                    icon: "moon.stars.fill",
                    title: "Cosmic Preference",
                    value: profile.cosmicPreference,
                    color: .cyan
                )
            }
        }
        .padding()
        .background(profileSummaryBackground)
    }

    // MARK: - Background Style
    private var profileSummaryBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

/// Claude: Individual row component for profile summary items
struct ProfileSummaryRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                Text(value)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Dark background for proper preview context
        Color.black.ignoresSafeArea()

        ProfileSummarySection(
            profile: UserProfile(
                id: "preview",
                birthdate: Date(),
                lifePathNumber: 7,
                isMasterNumber: false,
                spiritualMode: "Reflection, Growth",
                insightTone: "Gentle, Philosophical",
                focusTags: ["Purpose", "Spiritual Growth", "Well-being"],
                cosmicPreference: "Full Cosmic Integration",
                cosmicRhythms: ["Moon Phases", "Zodiac Seasons"],
                preferredHour: 7,
                wantsWhispers: true,
                birthName: "Preview User",
                soulUrgeNumber: 3,
                expressionNumber: 8,
                wantsReflectionMode: true
            )
        )
        .padding()
    }
}
