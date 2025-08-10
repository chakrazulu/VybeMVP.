/*
 * ========================================
 * ✦ ARCHETYPE CODEX SECTION COMPONENT ✦
 * ========================================
 *
 * COSMIC PURPOSE:
 * Complete spiritual archetype display showcasing the four cardinal elements
 * of a soul's cosmic blueprint: Zodiac Sign, Sacred Element, Ruling Planet,
 * and Shadow Planet for deep astrological understanding.
 *
 * COMPONENT FEATURES:
 * - Zodiac Sign card with detailed astrological interpretation
 * - Sacred Element card with elemental correspondences
 * - Ruling Planet card showing primary cosmic influence
 * - Shadow Planet card revealing subconscious depths
 * - Interactive tappable cards with cosmic animations
 *
 * VISUAL DESIGN:
 * - Purple-blue gradient header with mystical symbolism
 * - Individual cards with unique cosmic color schemes
 * - Animated border glow effects responding to archetype energy
 * - Professional card layout with icon-content-chevron structure
 *
 * MODULAR BENEFITS:
 * - Extracted from monolithic SanctumTabView
 * - Clean separation of astrological display logic
 * - Service-based architecture for consistent data access
 * - Reusable across different cosmic contexts
 */

import SwiftUI

/// Claude: Archetype Codex component for displaying complete spiritual archetype
struct ArchetypeCodexSection: View {

    // MARK: - Properties
    let archetype: UserArchetype
    @Binding var selectedArchetypeDetail: ArchetypeDetailType?
    @Binding var archetypeGlow: Bool

    // MARK: - Service Dependencies
    private let sanctumData = SanctumDataManager.shared

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            // Section Header
            VStack(spacing: 12) {
                Text("✦ Your Spiritual Archetype ✦")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue, .indigo]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 5)

                Text("The cosmic blueprint of your soul's essence")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()
            }

            VStack(spacing: 16) {
                // Zodiac Sign Card - Full Width
                Button(action: {
                    selectedArchetypeDetail = .zodiacSign(archetype.zodiacSign)
                    provideFeedback()
                }) {
                    spiritualArchetypeCard(
                        icon: zodiacIcon(for: archetype.zodiacSign),
                        title: archetype.zodiacSign.rawValue.capitalized,
                        subtitle: "Zodiac Sign",
                        description: detailedZodiacDescription(for: archetype.zodiacSign),
                        color: .blue,
                        accentColor: .cyan
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Element Card - Full Width
                Button(action: {
                    selectedArchetypeDetail = .element(archetype.element)
                    provideFeedback()
                }) {
                    spiritualArchetypeCard(
                        icon: elementIcon(for: archetype.element),
                        title: archetype.element.rawValue.capitalized,
                        subtitle: "Sacred Element",
                        description: detailedElementDescription(for: archetype.element),
                        color: elementColor(for: archetype.element),
                        accentColor: elementColor(for: archetype.element).opacity(0.7)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Primary Planet Card - Full Width
                Button(action: {
                    selectedArchetypeDetail = .primaryPlanet(archetype.primaryPlanet)
                    provideFeedback()
                }) {
                    spiritualArchetypeCard(
                        icon: planetIcon(for: archetype.primaryPlanet),
                        title: archetype.primaryPlanet.rawValue.capitalized,
                        subtitle: "Ruling Planet",
                        description: detailedPlanetDescription(for: archetype.primaryPlanet),
                        color: .orange,
                        accentColor: .yellow
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Shadow Planet Card - Full Width
                Button(action: {
                    selectedArchetypeDetail = .shadowPlanet(archetype.subconsciousPlanet)
                    provideFeedback()
                }) {
                    spiritualArchetypeCard(
                        icon: planetIcon(for: archetype.subconsciousPlanet),
                        title: archetype.subconsciousPlanet.rawValue.capitalized,
                        subtitle: "Shadow Planet",
                        description: detailedShadowPlanetDescription(for: archetype.subconsciousPlanet),
                        color: .indigo,
                        accentColor: .purple
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(archetypeCodexBackground)
        .shadow(
            color: .purple.opacity(archetypeGlow ? 0.5 : 0.3),
            radius: archetypeGlow ? 20 : 15,
            x: 0,
            y: 8
        )
    }

    // MARK: - Background Style
    private var archetypeCodexBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.4))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .purple.opacity(archetypeGlow ? 0.8 : 0.6),
                                .blue.opacity(archetypeGlow ? 0.6 : 0.4),
                                .indigo.opacity(archetypeGlow ? 0.5 : 0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }

    // MARK: - Spiritual Archetype Card
    private func spiritualArchetypeCard(
        icon: String,
        title: String,
        subtitle: String,
        description: String,
        color: Color,
        accentColor: Color
    ) -> some View {
        HStack(spacing: 16) {
            // Icon Section (Left)
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 40))
                    .shadow(color: color.opacity(0.6), radius: 5)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(accentColor)
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .tracking(0.5)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)

            // Content Section (Center)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Tap Indicator (Right)
            VStack {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(color.opacity(0.7))
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.25),
                            color.opacity(0.15),
                            Color.black.opacity(0.4)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.6),
                                    color.opacity(0.3)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: color.opacity(0.3), radius: 8)
    }

    // MARK: - Helper Functions

    /// Claude: Provide haptic feedback for card interactions
    private func provideFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    // MARK: - Zodiac Icon Mapping
    private func zodiacIcon(for sign: ZodiacSign) -> String {
        switch sign {
        case .aries: return "♈"
        case .taurus: return "♉"
        case .gemini: return "♊"
        case .cancer: return "♋"
        case .leo: return "♌"
        case .virgo: return "♍"
        case .libra: return "♎"
        case .scorpio: return "♏"
        case .sagittarius: return "♐"
        case .capricorn: return "♑"
        case .aquarius: return "♒"
        case .pisces: return "♓"
        }
    }

    // MARK: - Element Icon Mapping
    private func elementIcon(for element: Element) -> String {
        switch element {
        case .fire: return "🔥"
        case .earth: return "🌍"
        case .air: return "💨"
        case .water: return "💧"
        }
    }

    // MARK: - Element Color Mapping
    private func elementColor(for element: Element) -> Color {
        switch element {
        case .fire: return .red
        case .earth: return .brown
        case .air: return .yellow
        case .water: return .blue
        }
    }

    // MARK: - Planet Icon Mapping
    private func planetIcon(for planet: Planet) -> String {
        switch planet {
        case .sun: return "☉"
        case .moon: return "☽"
        case .mercury: return "☿"
        case .venus: return "♀"
        case .mars: return "♂"
        case .jupiter: return "♃"
        case .saturn: return "♄"
        case .uranus: return "♅"
        case .neptune: return "♆"
        case .pluto: return "♇"
        case .earth: return "🌍"
        }
    }

    // MARK: - Description Functions

    /// Claude: Detailed zodiac description using SanctumDataManager
    private func detailedZodiacDescription(for sign: ZodiacSign) -> String {
        return sanctumData.getZodiacSignDescription(for: sign.rawValue)
    }

    /// Claude: Detailed element description using SanctumDataManager
    private func detailedElementDescription(for element: Element) -> String {
        return sanctumData.getElementDescription(for: element.rawValue)
    }

    /// Claude: Detailed planet description using SanctumDataManager
    private func detailedPlanetDescription(for planet: Planet) -> String {
        let description = sanctumData.getPlanetaryDescription(for: planet.rawValue)
        return "Cosmic Ruler • \(description)"
    }

    /// Claude: Detailed shadow planet description using SanctumDataManager
    private func detailedShadowPlanetDescription(for planet: Planet) -> String {
        let description = sanctumData.getPlanetaryDescription(for: planet.rawValue)
        return "Shadow \(description) • Hidden depths"
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Cosmic background for proper preview context
        Color.black.ignoresSafeArea()

        ArchetypeCodexSection(
            archetype: UserArchetype(
                lifePath: 1,
                zodiacSign: .leo,
                element: .fire,
                primaryPlanet: .sun,
                subconsciousPlanet: .neptune,
                calculatedDate: Date()
            ),
            selectedArchetypeDetail: .constant(nil),
            archetypeGlow: .constant(true)
        )
        .padding()
    }
}
