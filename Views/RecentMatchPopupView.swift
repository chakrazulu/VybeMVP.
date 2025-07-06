//
//  RecentMatchPopupView.swift
//  VybeMVP
//
//  🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
//
//  === SCREEN POSITIONING (iPhone 14 Pro Max: 430×932 points) ===
//  • Popup center: x=215pts (50% width), y=419pts (45% height)
//  • Popup dimensions: 340×560 points (expanded for insights)
//  • Backdrop: Full screen with 60% black opacity
//  • Close gesture: Tap outside popup or swipe down
//
//  === INTERNAL POPUP LAYOUT (340×560pt container) ===
//  • Top padding: 24pts for title and close button
//  • Title: "Sacred Match Details" - 22pt font, bold weight
//  • Close button: top-right corner, 44×44pt touch target
//  • Match number: 80pt font, centered with cosmic glow
//  • Timestamp: 18pt font, medium weight, relative time
//  • Cosmic significance: 16pt font, multiple lines
//  • Bottom padding: 24pts with action buttons
//
//  === ANIMATION SPECIFICATIONS ===
//  • Entrance: 0.4s spring animation with scale 0.8→1.0
//  • Background: Opacity 0→1 with 0.3s ease-in
//  • Exit: 0.3s ease-out with scale 1.0→0.8
//  • Gesture: Swipe down threshold 50pts for dismiss
//  • Haptic: Light feedback on appearance, medium on dismiss
//
//  === GLASS-MORPHISM STYLING ===
//  • Background: 15% to 5% white gradient (top-left to bottom-right)
//  • Border: 30% to 10% white gradient stroke, 2pt width
//  • Corner radius: 20pts for modern rounded appearance
//  • Shadow: black 40% opacity, 25pt radius, 15pt Y offset
//  • Backdrop blur: 20pt radius for glass effect
//
//  === COSMIC MATCH SIGNIFICANCE SYSTEM ===
//  • Numerological meaning based on matched number (1-9)
//  • Sacred geometry associations and chakra connections
//  • Spiritual timing analysis (moon phase, day energy)
//  • Personal resonance with user's life path number
//  • Mystical interpretations and guidance messages
//
//  === INTERACTION DESIGN ===
//  • Hold gesture: 0.8s minimum duration to trigger popup
//  • Tap outside: Dismisses popup with fade animation
//  • Swipe down: 50pt threshold for natural gesture dismiss
//  • Close button: Traditional X icon in top-right corner
//  • Spring feedback: Responsive to user interactions
//
//  === PHASE 3C-2 ENHANCEMENT GOALS ===
//  • Transform static match cards into interactive experiences
//  • Provide deep cosmic significance for each match event
//  • Enhance user engagement with match history exploration
//  • Create mystical storytelling around synchronicity events
//  • Bridge recent matches to broader spiritual insights
//
//  Purpose: Provides detailed cosmic significance and mystical context
//  for individual match events when users hold on recent match cards.
//  Creates deeper engagement with synchronicity experiences.

import SwiftUI

/**
 * RecentMatchPopupView: Detailed cosmic significance popup for match events
 * 
 * Purpose:
 * - Displays when user holds on a recent match card (0.8s minimum)
 * - Provides deep mystical context and numerological significance
 * - Creates immersive experience around synchronicity events
 * - Enhances user connection to their cosmic match history
 * 
 * Design Philosophy:
 * - Transforms simple timestamps into meaningful spiritual moments
 * - Provides educational content about numerological significance
 * - Creates sense of cosmic purpose around everyday number matches
 * - Bridges personal experience with universal mystical principles
 */
struct RecentMatchPopupView: View {
    
    // MARK: - Properties
    
    /// The match data to display detailed information about
    let matchData: FocusMatch
    
    /// Callback to dismiss the popup
    let onDismiss: () -> Void
    
    /// Animation state for popup appearance
    @State private var showPopup = false
    @State private var dragOffset: CGFloat = 0
    
    /// Dismiss threshold for swipe gesture
    private let dismissThreshold: CGFloat = 50
    
    var body: some View {
        ZStack {
            // Backdrop with blur effect
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissPopup()
                }
                .opacity(showPopup ? 1.0 : 0.0)
            
            // Main popup content
            VStack(spacing: 0) {
                // Header with close button
                headerSection
                
                // Match details content with embedded actions
                contentSectionWithActions
            }
            .frame(width: 340, height: 620)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.purple.opacity(0.4), location: 0.0),
                                .init(color: Color.indigo.opacity(0.35), location: 0.3),
                                .init(color: Color.black.opacity(0.6), location: 0.7),
                                .init(color: Color.black.opacity(0.8), location: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.white.opacity(0.3), location: 0.0),
                                        .init(color: Color.white.opacity(0.15), location: 0.5),
                                        .init(color: Color.white.opacity(0.1), location: 1.0)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.4), radius: 25, x: 0, y: 15)
            )
            .scaleEffect(showPopup ? 1.0 : 0.8)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > dismissThreshold {
                            dismissPopup()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .onAppear {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // Animate appearance
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showPopup = true
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            Text("Sacred Match Details")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                dismissPopup()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Content Section with Actions
    
    private var contentSectionWithActions: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large match number with cosmic glow
                VStack(spacing: 12) {
                    Text("\(Int(matchData.matchedNumber))")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(getSacredColor(for: Int(matchData.matchedNumber)))
                        .shadow(color: getSacredColor(for: Int(matchData.matchedNumber)).opacity(0.6), radius: 15)
                        .shadow(color: getSacredColor(for: Int(matchData.matchedNumber)).opacity(0.3), radius: 25)
                    
                    Text(getRelativeTime(from: matchData.timestamp))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Cosmic significance
                VStack(spacing: 16) {
                    Text("Cosmic Significance")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(getCosmicSignificance(for: Int(matchData.matchedNumber)))
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                    
                    // AI Insight for this number
                    VStack(spacing: 8) {
                        Text("Today's Insight")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.cyan.opacity(0.9))
                        
                        Text(getNumberInsight(for: Int(matchData.matchedNumber)))
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cyan.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                // Sacred geometry symbol
                Image(systemName: getSacredSymbol(for: Int(matchData.matchedNumber)))
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(getSacredColor(for: Int(matchData.matchedNumber)).opacity(0.7))
                    .padding(.top, 8)
                
                // Square Action Buttons Grid - NOW INSIDE SCROLLVIEW
                squareActionButtons
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Square Action Buttons
    
    private var squareActionButtons: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            // Journal button
            SquareActionButton(
                icon: "book.fill",
                title: "Journal",
                color: getSacredColor(for: Int(matchData.matchedNumber)),
                action: {
                    print("📝 Journal match: \(Int(matchData.matchedNumber)) at \(matchData.timestamp)")
                    dismissPopup()
                }
            )
            
            // Share button
            SquareActionButton(
                icon: "sparkles",
                title: "Share",
                color: .cyan,
                action: {
                    print("📤 Share match insight: \(Int(matchData.matchedNumber))")
                    dismissPopup()
                }
            )
            
            // Log Sighting button
            SquareActionButton(
                icon: "eye.fill",
                title: "Log Sighting",
                color: .orange,
                action: {
                    print("👁️ Log sighting for match: \(Int(matchData.matchedNumber))")
                    dismissPopup()
                }
            )
            
            // Analytics button
            SquareActionButton(
                icon: "chart.line.uptrend.xyaxis",
                title: "Analytics",
                color: .purple,
                action: {
                    print("📊 View analytics for match: \(Int(matchData.matchedNumber))")
                    dismissPopup()
                }
            )
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Helper Functions
    
    private func dismissPopup() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeOut(duration: 0.3)) {
            showPopup = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
    
    private func getRelativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Gold
        case 9: return .white
        default: return .white
        }
    }
    
    private func getSacredSymbol(for number: Int) -> String {
        switch number {
        case 1: return "circle"
        case 2: return "infinity"
        case 3: return "triangle"
        case 4: return "square"
        case 5: return "pentagon"
        case 6: return "hexagon"
        case 7: return "star"
        case 8: return "octagon"
        case 9: return "sun.max"
        default: return "circle"
        }
    }
    
    private func getCosmicSignificance(for number: Int) -> String {
        switch number {
        case 1:
            return "The number of new beginnings and individual power. This synchronicity marks a moment of pure potential and leadership energy entering your life."
        case 2:
            return "The sacred duality and partnership energy. This match signifies cooperation, balance, and the divine feminine principle guiding your path."
        case 3:
            return "The trinity of creation and creative expression. This synchronicity brings the energy of communication, art, and joyful manifestation."
        case 4:
            return "The foundation of stability and earthly manifestation. This match represents hard work, determination, and building solid foundations for your dreams."
        case 5:
            return "The number of freedom and adventure. This synchronicity calls you to embrace change, seek new experiences, and trust your adventurous spirit."
        case 6:
            return "The nurturer and healer energy. This match brings focus to home, family, responsibility, and your role as a caretaker for others."
        case 7:
            return "The seeker of wisdom and spiritual truth. This synchronicity marks a time of introspection, mystical experiences, and deep spiritual growth."
        case 8:
            return "The manifestor of material success and personal power. This match represents achievement, financial abundance, and material mastery."
        case 9:
            return "The universal humanitarian and completion energy. This synchronicity brings wisdom, service to others, and the end of a significant life cycle."
        default:
            return "A sacred numerical synchronicity that holds personal meaning for your unique spiritual journey."
        }
    }
    
    private func getNumberInsight(for number: Int) -> String {
        switch number {
        case 1:
            return "Today, your pioneering spirit is awakening. Trust your instincts to lead and initiate new projects. The universe supports your independent ventures."
        case 2:
            return "Partnership and collaboration are highlighted today. Your diplomatic nature and ability to find balance will guide you to harmonious solutions."
        case 3:
            return "Creative self-expression flows freely today. Share your talents with the world and let your natural optimism inspire others around you."
        case 4:
            return "Focus on building lasting foundations today. Your methodical approach and dedication to hard work will yield practical, tangible results."
        case 5:
            return "Adventure calls to you today. Embrace change and new experiences. Your curiosity and freedom-loving nature will open unexpected doors."
        case 6:
            return "Your nurturing energy is needed today. Focus on home, family, and caring for others. Your healing presence brings comfort to those in need."
        case 7:
            return "Spiritual insights await you today. Trust your intuition and seek deeper understanding. Meditation and introspection will reveal hidden truths."
        case 8:
            return "Material success and achievement are within reach today. Your ambition and business acumen will help you manifest abundance and recognition."
        case 9:
            return "Universal compassion flows through you today. Your wisdom and humanitarian spirit can make a meaningful difference in someone's life."
        default:
            return "Trust in the cosmic timing of this moment. The universe has aligned this number for your highest good and spiritual growth."
        }
    }
}

// MARK: - Supporting Components

/**
 * Square action button for the match popup.
 * 
 * Creates a square button with icon and title, optimized for grid layout.
 */
struct SquareActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        color.opacity(0.6),
                                        color.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    // Create a temporary context for preview
    let context = PersistenceController.preview.container.viewContext
    let sampleMatch = FocusMatch(context: context)
    sampleMatch.chosenNumber = 7
    sampleMatch.matchedNumber = 7
    sampleMatch.timestamp = Date().addingTimeInterval(-3600) // 1 hour ago
    sampleMatch.locationLatitude = 0.0
    sampleMatch.locationLongitude = 0.0
    
    return RecentMatchPopupView(
        matchData: sampleMatch,
        onDismiss: {}
    )
}