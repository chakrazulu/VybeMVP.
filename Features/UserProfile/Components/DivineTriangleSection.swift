/*
 * ========================================
 * 🔮 DIVINE TRIANGLE SECTION COMPONENT
 * ========================================
 *
 * SPIRITUAL PURPOSE:
 * Sacred numerological trinity displaying the core numbers that define
 * a soul's spiritual blueprint: Life Path, Soul Urge, and Expression.
 *
 * COMPONENT FEATURES:
 * - Life Path Number (primary card with enhanced styling)
 * - Soul Urge Number (heart's deepest desire)
 * - Expression Number (natural talents and gifts)
 * - Master Number badge for special spiritual significance
 * - Interactive tappable cards with haptic feedback
 *
 * VISUAL DESIGN:
 * - Gradient header with spiritual symbolism (✧ The Divine Triangle ✧)
 * - Individual cards with custom colors and glow effects
 * - Black container with golden gradient border
 * - Mystical shadow effects and spiritual typography
 *
 * MODULAR BENEFITS:
 * - Extracted from 4000+ line monolithic view
 * - Clean separation of numerology display logic
 * - Reusable across different spiritual contexts
 * - Service-based architecture eliminates scope issues
 */

import SwiftUI

/// Claude: Divine Triangle component for displaying sacred numerological trinity
struct DivineTriangleSection: View {

    // MARK: - Properties
    let profile: UserProfile
    @Binding var selectedArchetypeDetail: ArchetypeDetailType?

    // MARK: - Service Dependencies
    private let sanctumData = SanctumDataManager.shared
    private let numerologyService = NumerologyService.shared

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            // Section Header
            VStack(spacing: 8) {
                Text("✧ The Divine Triangle ✧")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange, .red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.5), radius: 5)

                Text("Your Sacred Numerological Trinity")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()

                Text("The complete blueprint of your soul's journey")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .italic()
            }

            VStack(spacing: 20) {
                // Life Path Number (Primary - Larger Display)
                Button(action: {
                    selectedArchetypeDetail = .lifePathNumber(profile.lifePathNumber)
                    provideFeedback()
                }) {
                    divineTriangleCard(
                        number: profile.lifePathNumber,
                        title: "Life Path Number",
                        subtitle: "Soul's Journey & Purpose",
                        description: sanctumData.getLifePathDescription(for: profile.lifePathNumber, isMaster: profile.isMasterNumber),
                        icon: "star.circle.fill",
                        color: .yellow,
                        glowColor: .orange,
                        isPrimary: true
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Soul Urge Number (Heart's Desire)
                if let soulUrge = profile.soulUrgeNumber {
                    Button(action: {
                        selectedArchetypeDetail = .soulUrgeNumber(soulUrge)
                        provideFeedback()
                    }) {
                        divineTriangleCard(
                            number: soulUrge,
                            title: "Soul Urge Number",
                            subtitle: "Heart's Deepest Desire",
                            description: soulUrgeDescription(for: soulUrge),
                            icon: "heart.fill",
                            color: .pink,
                            glowColor: .red,
                            isPrimary: false
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Expression Number (Life's Purpose)
                if let expression = profile.expressionNumber {
                    Button(action: {
                        selectedArchetypeDetail = .expressionNumber(expression)
                        provideFeedback()
                    }) {
                        divineTriangleCard(
                            number: expression,
                            title: "Expression Number",
                            subtitle: "Natural Talents & Gifts",
                            description: expressionDescription(for: expression),
                            icon: "star.fill",
                            color: .cyan,
                            glowColor: .blue,
                            isPrimary: false
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Master Number Badge (if applicable)
                if profile.isMasterNumber {
                    masterNumberBadge
                }
            }
        }
        .padding()
        .background(divineTriangleBackground)
        .shadow(color: .yellow.opacity(0.2), radius: 20, x: 0, y: 8)
    }

    // MARK: - Master Number Badge
    private var masterNumberBadge: some View {
        HStack {
            Image(systemName: "sparkles")
                .foregroundColor(.yellow)
            Text("✨ Master Number ✨")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.yellow)
            Image(systemName: "sparkles")
                .foregroundColor(.yellow)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.yellow.opacity(0.2))
                .overlay(
                    Capsule()
                        .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                )
        )
        .shadow(color: .yellow.opacity(0.3), radius: 5)
    }

    // MARK: - Background Style
    private var divineTriangleBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.4))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow.opacity(0.6), .orange.opacity(0.4), .red.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }

    // MARK: - Divine Triangle Card
    private func divineTriangleCard(
        number: Int,
        title: String,
        subtitle: String,
        description: String,
        icon: String,
        color: Color,
        glowColor: Color,
        isPrimary: Bool
    ) -> some View {
        VStack(spacing: 12) {
            // Card Header
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .shadow(color: glowColor.opacity(0.6), radius: 3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(isPrimary ? .title2 : .headline)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, glowColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                // Number Display
                Text("\(number)")
                    .font(isPrimary ? .largeTitle : .title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(isPrimary ? 16 : 12)
                    .background(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [color.opacity(0.3), color.opacity(0.1)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 30
                                )
                            )
                            .overlay(
                                Circle()
                                    .stroke(color.opacity(0.4), lineWidth: 1)
                            )
                    )
                    .shadow(color: glowColor.opacity(0.4), radius: 8)
            }

            // Description Text
            Text(description)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .padding(isPrimary ? 20 : 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.4),
                            color.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: glowColor.opacity(0.2), radius: 12)
    }

    // MARK: - Helper Functions

    /// Claude: Provide haptic feedback for card interactions
    private func provideFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    /// Claude: Soul urge description using SanctumDataManager service
    private func soulUrgeDescription(for number: Int) -> String {
        let description = sanctumData.getSoulUrgeDescription(for: number, isMaster: numerologyService.isMasterNumber(number))
        return "\(description) • Soul's deepest desire"
    }

    /// Claude: Expression description using SanctumDataManager service
    private func expressionDescription(for number: Int) -> String {
        let description = sanctumData.getExpressionDescription(for: number, isMaster: numerologyService.isMasterNumber(number))
        return "\(description) • Outward expression"
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Cosmic background for proper preview context
        Color.black.ignoresSafeArea()

        DivineTriangleSection(
            profile: UserProfile(
                id: "preview",
                birthdate: Date(),
                lifePathNumber: 11,
                isMasterNumber: true,
                spiritualMode: "Reflection",
                insightTone: "Gentle",
                focusTags: ["Purpose"],
                cosmicPreference: "Full Cosmic Integration",
                cosmicRhythms: ["Moon Phases"],
                preferredHour: 7,
                wantsWhispers: true,
                birthName: "Preview User",
                soulUrgeNumber: 7,
                expressionNumber: 22,
                wantsReflectionMode: true
            ),
            selectedArchetypeDetail: .constant(nil)
        )
        .padding()
    }
}
