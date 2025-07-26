//
//  VybeMatchOverlay.swift
//  VybeMVP
//
//  🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
//
//  === SCREEN POSITIONING (iPhone 14 Pro Max: 430×932 points) ===
//  • Main bubble center: x=215pts (50% width), y=419pts (45% height)
//  • Bubble dimensions: 380×520 points (expanded height for proper pulsing content containment)
//  • Particles orbit radius: 145pts from bubble center
//  • Close button: top-right corner, 50pts from top, 20pts from right
//
//  === INTERNAL BUBBLE LAYOUT (380×520pt container) ===
//  • Top spacer: 40pts (increased padding to contain pulsing VYBE text)
//  • VYBE text: 64pt font, centered horizontally
//  • VYBE + subtitle spacing: 12pts vertical gap
//  • Subtitle text: 18pt font, medium weight
//  • Sacred number display: 80pt font, centered
//  • Action buttons: 85×55pt each, 3 rows, proportional to expanded bubble size
//  • Bottom spacer: 40pts (increased padding to contain pulsing action buttons)
//
//  === ANIMATION SPECIFICATIONS ===
//  • Entrance scale: 0.3 → 1.0 (smooth growth effect, no overshoot)
//  • Floating motion: ±1.5% scale variation (0.985x to 1.015x) - very subtle
//  • Glow breathing: 82% to 94% opacity variation - gentle pulse
//  • Animation timing: 1.5π frequency (slower, ethereal feel)
//  • Particle rotation: 360° over 20 seconds, linear
//  • Sacred number pulse: Synchronized with haptic feedback
//
//  === GLASS-MORPHISM STYLING ===
//  • Background: 15% to 5% white gradient (top-left to bottom-right)
//  • Border: 30% to 10% white gradient stroke, 1.5pt width
//  • Corner radius: 25pts for modern rounded appearance
//  • Shadow: black 30% opacity, 20pt radius, 10pt Y offset
//
//  === TYPOGRAPHY HIERARCHY ===
//  • VYBE text: 64pt, black weight, rounded design, rainbow gradient
//  • Subtitle: 18pt, medium weight, rounded design, 90% white opacity
//  • Sacred number: 80pt, black weight, rounded design, chakra colors
//  • All scale with main animation (85% for subtitle, 90% for number)
//
//  === INTERACTION ZONES ===
//  • Background tap: Full screen area (dismisses overlay)
//  • Content tap: 380×520pt bubble area (prevents background dismiss)
//  • Close button: ~44×44pt touch target (top-right corner)
//
//  === PHASE 2.2 ENHANCEMENTS ===
//  • Action buttons: View Insight, Start Meditation, Journal Entry, Log Sighting, Close
//  • Delayed reveal: 1.5s after entrance animation for better UX flow
//  • Haptic feedback: Light feedback on button press, medium on action selection
//  • Current status: Production ready with gentle animations and proper proportions
//
//  === PHASE 2.4 TODO: SACRED FREQUENCY AUDIO IMPLEMENTATION ===
//  • Sacred frequency tones are currently only logged, not actually played
//  • Need to implement actual audio playback for frequencies (396Hz, 528Hz, etc.)
//  • Audio should be synchronized with haptic feedback and particle effects
//  • Consider using AVFoundation for precise frequency generation
//
//  Created for cosmic match celebration when Focus Number == Realm Number
//  This overlay appears with mystical animations synchronized to user's heart rate
//  Enhanced with multi-modal celebrations (haptics, audio, particles)
//

@preconcurrency import SwiftUI
import Combine

/**
 * VybeMatchOverlay: A mystical overlay that appears when cosmic alignment occurs
 * 
 * Purpose:
 * - Displays when Focus Number matches Realm Number (e.g., 4 == 4)
 * - Creates immersive cosmic celebration with pulsing "Vybe" symbol
 * - Synchronizes animations with user's heart rate for personalized experience
 * - Uses TimelineView to prevent interruption during scrolling
 * - Enhanced with sacred number display and multi-modal celebrations
 * - Phase 2.2: Interactive action buttons for spiritual engagement
 * 
 * Design Philosophy:
 * - Celebrates the sacred moment of numerical alignment
 * - Enhances the mystical experience without being intrusive
 * - Provides visual feedback for the core app mechanic
 * - Creates deep emotional connection through multi-sensory experience
 */
struct VybeMatchOverlay: View {
    
    // MARK: - State Properties
    
    /// Whether the match overlay should be visible
    @Binding var isVisible: Bool
    
    /// The matched number (both Focus and Realm number)
    let matchedNumber: Int
    
    /// User's current heart rate for animation synchronization
    let heartRate: Double
    
    /// Duration the overlay has been visible (for auto-dismiss)
    @State private var visibilityDuration: TimeInterval = 0
    
    /// Animation phase for the pulsing effect
    @State private var pulsePhase: Double = 0
    
    /// Scale factor for the main "Vybe" symbol
    @State private var symbolScale: Double = 1.0
    
    /// Opacity for the cosmic background glow
    @State private var backgroundGlow: Double = 0.0
    
    /// Rotation angle for the cosmic elements
    @State private var cosmicRotation: Double = 0
    
    /// Scale factor for the sacred number display
    @State private var numberScale: Double = 1.0
    
    /// Opacity for the sacred number glow
    @State private var numberGlow: Double = 0.0
    
    /// Particle animation phase for enhanced effects
    @State private var particlePhase: Double = 0
    
    /// Whether action buttons should be visible (delayed appearance for better UX)
    @State private var showActionButtons: Bool = false
    
    /// Which action button is currently highlighted
    @State private var highlightedAction: ActionType? = nil
    
    // MARK: - Configuration
    
    /// How long the overlay stays visible (in seconds) - disabled for manual dismiss only
    private let displayDuration: TimeInterval = .infinity // Never auto-dismiss
    
    /// Base animation duration (modified by heart rate)
    private let baseAnimationDuration: Double = 1.0
    
    /// Minimum heart rate for animation timing
    private let minHeartRate: Double = 40.0
    
    /// Maximum heart rate for animation timing
    private let maxHeartRate: Double = 120.0
    
    // MARK: - Sacred Number Properties
    
    /// Sacred number meanings and colors for enhanced display
    private let sacredNumberData: [Int: SacredNumberInfo] = [
        1: SacredNumberInfo(name: "Leadership", color: .red, chakra: "Root"),
        2: SacredNumberInfo(name: "Harmony", color: .orange, chakra: "Sacral"),
        3: SacredNumberInfo(name: "Creativity", color: .yellow, chakra: "Solar Plexus"),
        4: SacredNumberInfo(name: "Stability", color: .green, chakra: "Heart"),
        5: SacredNumberInfo(name: "Freedom", color: .blue, chakra: "Throat"),
        6: SacredNumberInfo(name: "Nurturing", color: .indigo, chakra: "Third Eye"),
        7: SacredNumberInfo(name: "Spirituality", color: .purple, chakra: "Crown"),
        8: SacredNumberInfo(name: "Power", color: .pink, chakra: "Universal"),
        9: SacredNumberInfo(name: "Completion", color: .white, chakra: "Source")
    ]
    
    // MARK: - Computed Properties
    
    /// Animation duration based on heart rate (faster heart rate = faster animation)
    private var heartRateAnimationDuration: Double {
        guard heartRate > 0 else { return baseAnimationDuration }
        
        // Convert BPM to animation duration
        // Higher BPM = shorter duration (faster animation)
        let clampedBPM = max(minHeartRate, min(heartRate, maxHeartRate))
        let normalizedBPM = (clampedBPM - minHeartRate) / (maxHeartRate - minHeartRate)
        
        // Duration ranges from 1.5s (slow heart) to 0.6s (fast heart)
        return 1.5 - (normalizedBPM * 0.9)
    }
    
    /// Sacred number information for the matched number
    private var currentSacredNumber: SacredNumberInfo? {
        return sacredNumberData[matchedNumber]
    }
    
    var body: some View {
        ZStack {
            if isVisible {
                // Cosmic background with animated glow - tap to dismiss
                cosmicBackground
                    .onTapGesture {
                        print("🌟 User tapped background - dismissing overlay")
                        isVisible = false
                    }
                
                // 🎯 MAIN CONTENT CONTAINER: 380×520pt glass-morphism bubble
                // Positioned at screen center (50% width, 45% height)
                VStack(spacing: 0) { // No spacing - we'll control layout precisely
                    
                    // 🎯 TOP SPACER: 40pt from bubble top edge to contain pulsing VYBE text
                    Spacer()
                        .frame(height: 40)
                    
                    // 🌟 VYBE SYMBOL: Primary cosmic celebration text
                    vybeSymbol
                    
                    // 🎯 CONTENT SPACER: 15pt between VYBE and sacred number
                    Spacer()
                        .frame(height: 15)
                    
                    // 🌟 SACRED NUMBER DISPLAY: Enhanced number celebration
                    sacredNumberDisplay
                    
                    // 🎯 FLEXIBLE SPACER: Push action buttons to bottom with minimum space
                    Spacer(minLength: 20)
                    
                    // 🎯 PHASE 2.2: ACTION BUTTONS - Enhanced cosmic match interactions
                    // Positioned at bottom of bubble with precise spacing
                    if showActionButtons {
                        cosmicActionButtons
                    }
                    
                    // 🎯 BOTTOM SPACER: 40pt from bubble bottom edge to contain pulsing action buttons
                    Spacer()
                        .frame(height: 40)
                }
                .frame(width: 380, height: 520) // 🎯 CRITICAL: Expanded height to contain pulsing content within glass bounds
                .background(
                    // 🎨 ENHANCED GLASS-MORPHISM BUBBLE: Better contrast and readability
                    RoundedRectangle(cornerRadius: 25) // 25pt radius for modern rounded appearance
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.25), // Increased opacity for better contrast
                                    Color.white.opacity(0.15)  // Higher base opacity
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(.ultraThinMaterial) // iOS blur effect for better text readability
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.5), // Stronger border for definition
                                            Color.white.opacity(0.2)  // Enhanced border visibility
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2.0 // Slightly thicker border for better visibility
                                )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 25, x: 0, y: 15) // Stronger shadow for depth
                        .scaleEffect(symbolScale * 0.95) // Gentle floating: 95% of main scale animation
                )
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.45) // 🎯 ADJUSTED CENTER: 50% width, 45% height (lower for expanded bubble)
                .onTapGesture {
                    // Prevent background tap when tapping content
                }
                
                // Enhanced particle effects around the symbol
                enhancedCosmicParticles
                
                // Close button in top-right corner
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("🌟 User tapped close button - dismissing overlay")
                            isVisible = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                                .background(Circle().fill(Color.black.opacity(0.3)))
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.easeInOut(duration: VybeConstants.standardFeedbackDelay), value: isVisible)
        .onChange(of: isVisible) { _, newValue in
            handleVisibilityChange(newValue)
        }
        .onReceive(Timer.publish(every: VybeConstants.instantFeedbackDelay, on: .main, in: .common).autoconnect()) { _ in
            updateAnimations()
        }
    }
    
    // MARK: - View Components
    
    /// Cosmic background with animated glow effect and backdrop blur for visibility
    private var cosmicBackground: some View {
        ZStack {
            // 🎯 BACKDROP BLUR: Ensures overlay is visible from anywhere in the app
            Rectangle()
                .fill(Color.black.opacity(0.4)) // Semi-transparent backdrop
                .background(.ultraThinMaterial) // iOS blur effect
                .ignoresSafeArea()
            
            // Deep space background
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.4),
                            Color.indigo.opacity(0.3),
                            Color.black.opacity(0.6)
                        ]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 300
                    )
                )
                .opacity(backgroundGlow)
            
            // Animated cosmic rings
            ForEach(0..<3, id: \.self) { ringIndex in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.cyan.opacity(0.6),
                                Color.purple.opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100 + CGFloat(ringIndex * 50))
                    .rotationEffect(.degrees(cosmicRotation + Double(ringIndex * 120)))
                    .opacity(backgroundGlow * 0.8)
            }
        }
        .ignoresSafeArea()
    }
    
    /// 🌟 VYBE SYMBOL: Primary cosmic celebration text with rainbow gradient and ethereal shadows
    private var vybeSymbol: some View {
        VStack(spacing: 12) { // 12pt spacing between VYBE text and subtitle
            // 🎨 MYSTICAL VYBE TEXT: 64pt font optimized for 380pt bubble width
            Text("✨ VYBE ✨")
                .font(.system(size: 64, weight: .black, design: .rounded)) // 64pt: Perfect fit within 380pt bubble
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.cyan,    // Cosmic blue at top-left
                            Color.purple,  // Mystical purple in center
                            Color.pink     // Ethereal pink at bottom-right
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(symbolScale) // Responds to floating animation (0.97x to 1.03x)
                .shadow(color: .cyan, radius: 15)    // Inner glow: 15pt cyan
                .shadow(color: .purple, radius: 25)  // Mid glow: 25pt purple
                .shadow(color: .pink, radius: 35)    // Outer glow: 35pt pink
            
            // 📝 COSMIC SUBTITLE: 18pt medium weight, positioned 12pts below VYBE
            Text("Cosmic Alignment Achieved")
                .font(.system(size: 18, weight: .medium, design: .rounded)) // 18pt: Proportional to 64pt VYBE
                .foregroundColor(.white) // Full white for better readability
                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1) // Text shadow for readability
                .opacity(backgroundGlow) // Responds to breathing animation (75% to 95%)
                .scaleEffect(symbolScale * 0.85) // 85% of main scale for hierarchy
        }
    }
    
    /// 🌟 SACRED NUMBER DISPLAY: Enhanced number celebration with chakra colors and spiritual meaning
    private var sacredNumberDisplay: some View {
        VStack(spacing: 8) {
            if let sacredInfo = currentSacredNumber {
                // Sacred number with chakra color
                Text("\(matchedNumber)")
                    .font(.system(size: 80, weight: .black, design: .rounded)) // 80pt: Perfect for 380pt bubble
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                sacredInfo.color,
                                sacredInfo.color.opacity(0.7),
                                sacredInfo.color.opacity(0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(numberScale) // Responds to haptic feedback
                    .shadow(color: sacredInfo.color, radius: 20) // Inner glow
                    .shadow(color: sacredInfo.color.opacity(0.5), radius: 30) // Outer glow
                    .opacity(numberGlow) // Pulsing opacity synchronized with haptics
                
                // Sacred number meaning
                Text(sacredInfo.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 0, y: 1) // Text shadow for readability
                    .scaleEffect(numberScale * 0.9) // 90% of number scale
                
                // Chakra information
                Text(sacredInfo.chakra + " Chakra")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 0, y: 1) // Text shadow for readability
                    .scaleEffect(numberScale * 0.8) // 80% of number scale
            }
        }
        .opacity(backgroundGlow) // Sync with main breathing animation
    }
    
    /// 🎯 PHASE 2.2: COSMIC ACTION BUTTONS - Enhanced interaction options for spiritual engagement
    private var cosmicActionButtons: some View {
        VStack(spacing: 12) { // Increased spacing between rows for larger buttons
            // First row: Primary spiritual actions (3 buttons)
            HStack(spacing: 15) { // Increased spacing between larger buttons
                actionButton(for: .viewInsight)
                actionButton(for: .startMeditation)
                actionButton(for: .journalEntry)
            }
            
            // Second row: Social and logging actions (2 buttons, centered)
            HStack(spacing: 15) { // Consistent increased spacing
                Spacer() // Left spacer for centering
                actionButton(for: .logSighting)
                actionButton(for: .postStatus)
                Spacer() // Right spacer for centering
            }
            
            // Third row: Close action (1 button, centered)
            HStack {
                Spacer()
                actionButton(for: .close)
                Spacer()
            }
        }
        .frame(maxWidth: 340) // Expanded to accommodate larger 85pt buttons (20pt padding each side)
        .scaleEffect(symbolScale * 0.95) // 🌟 SYNC WITH BUBBLE: Pulse with main cosmic animation
        .opacity(showActionButtons ? (backgroundGlow * 0.9) : 0.0) // 🌟 BREATHE WITH BUBBLE: Sync opacity with cosmic breathing
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showActionButtons)
    }
    
    /// Individual action button with cosmic styling
    private func actionButton(for action: ActionType) -> some View {
        Button(action: {
            handleAction(action)
        }) {
            VStack(spacing: 4) { // Good spacing for readability
                // Icon
                Image(systemName: action.icon)
                    .font(.system(size: 20, weight: .semibold)) // Larger icon for bigger buttons
                    .foregroundColor(.white)
                
                // Label
                Text(action.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded)) // Larger text for better readability
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2) // Allow text wrapping for longer labels
            }
            .frame(width: 85, height: 55) // Larger size proportional to expanded 520pt bubble height
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                                action.color.opacity(0.3),
                                action.color.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(action.color.opacity(0.5), lineWidth: 1)
                    )
            )
            .scaleEffect(highlightedAction == action ? 1.1 : 1.0)
            .shadow(
                color: action.color.opacity(0.3),
                radius: highlightedAction == action ? 6 : 3
            )
            .shadow(
                color: action.color.opacity(backgroundGlow * 0.2), // 🌟 COSMIC GLOW: Sync with bubble breathing
                radius: 8
            )
        }
        .onLongPressGesture(minimumDuration: 0.1) {
            // Haptic feedback on press
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // Highlight effect
            withAnimation(.easeInOut(duration: VybeConstants.veryShortAnimationDuration)) {
                highlightedAction = action
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.quickTransitionDuration) {
                withAnimation(.easeInOut(duration: VybeConstants.veryShortAnimationDuration)) {
                    highlightedAction = nil
                }
            }
        }
    }
    
    /// ✨ ENHANCED COSMIC PARTICLES: Sacred geometry-inspired particles with number-specific patterns
    private var enhancedCosmicParticles: some View {
        ZStack {
            // Base particle ring (8 particles)
            ForEach(0..<8, id: \.self) { particleIndex in
                let angle = Double(particleIndex) * .pi / 4 + cosmicRotation * .pi / 180 // 45° spacing + rotation
                let radius: Double = 145 // 145pt orbit radius: Perfect for 380pt bubble
                
                Circle()
                    .fill(Color.white.opacity(0.9)) // 90% white opacity for cosmic shimmer
                    .frame(width: 6, height: 6) // 6×6pt particles: Visible but not distracting
                    .offset(
                        x: cos(angle) * radius, // X position on orbit
                        y: sin(angle) * radius  // Y position on orbit
                    )
                    .opacity(backgroundGlow * 0.9) // Sync with breathing animation
                    .scaleEffect(symbolScale * 0.6) // 60% of main scale for subtle size variation
            }
            
            // Sacred geometry particles (number-specific)
            if let sacredInfo = currentSacredNumber {
                ForEach(0..<getSacredGeometryCount(for: matchedNumber), id: \.self) { geometryIndex in
                    let angle = Double(geometryIndex) * (2 * .pi / Double(getSacredGeometryCount(for: matchedNumber))) + particlePhase
                    let radius: Double = 120 + Double(geometryIndex % 2) * 20 // Alternating radii for depth
                    
                    // Sacred geometry shape based on number
                    sacredGeometryShape(for: matchedNumber)
                        .fill(sacredInfo.color.opacity(0.8))
                        .frame(width: 8, height: 8)
                        .offset(
                            x: cos(angle) * radius,
                            y: sin(angle) * radius
                        )
                        .opacity(backgroundGlow * 0.7)
                        .scaleEffect(symbolScale * 0.5)
                        .rotationEffect(.degrees(particlePhase * 30)) // Individual rotation
                }
            }
        }
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.45) // 🎯 EXACT MATCH: Same center as bubble
    }
    
    // MARK: - Helper Methods
    
    /// Returns the number of sacred geometry particles for a given number
    private func getSacredGeometryCount(for number: Int) -> Int {
        switch number {
        case 1: return 1  // Unity - single point
        case 2: return 2  // Duality - two points
        case 3: return 3  // Trinity - three points
        case 4: return 4  // Foundation - four points
        case 5: return 5  // Freedom - five points
        case 6: return 6  // Nurturing - six points
        case 7: return 7  // Spirituality - seven points
        case 8: return 8  // Power - eight points
        case 9: return 9  // Completion - nine points
        default: return 8
        }
    }
    
    /// Returns the appropriate sacred geometry shape for a given number
    private func sacredGeometryShape(for number: Int) -> some Shape {
        switch number {
        case 1: return AnyShape(Circle()) // Point/Unity
        case 2: return AnyShape(Rectangle()) // Line/Duality
        case 3: return AnyShape(Triangle()) // Triangle/Trinity
        case 4: return AnyShape(Rectangle()) // Square/Foundation
        case 5: return AnyShape(Pentagon()) // Pentagon/Freedom
        case 6: return AnyShape(Hexagon()) // Hexagon/Nurturing
        case 7: return AnyShape(Heptagon()) // Heptagon/Spirituality
        case 8: return AnyShape(Octagon()) // Octagon/Power
        case 9: return AnyShape(Circle()) // Circle/Completion
        default: return AnyShape(Circle())
        }
    }
    
    // MARK: - Action Handling
    
    /// Handles action button taps with appropriate navigation and logging
    private func handleAction(_ action: ActionType) {
        print("🎯 Phase 2.2: User selected action: \(action.rawValue)")
        
        // Haptic feedback for action selection
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Dismiss overlay first for smooth transition
        isVisible = false
        
        // Delay navigation slightly for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.shortAnimationDuration) {
            switch action {
            case .viewInsight:
                print("🌟 Opening insight view for matched number \(matchedNumber)")
                navigateToInsightView()
                
            case .startMeditation:
                print("🧘 Starting meditation session for number \(matchedNumber)")
                navigateToMeditationView()
                
            case .journalEntry:
                print("📖 Opening journal entry for cosmic match")
                navigateToJournalEntry()
                
            case .logSighting:
                print("👁️ Logging cosmic match sighting")
                navigateToSightingLog()
                
            case .postStatus:
                print("📢 Posting cosmic match status to timeline")
                navigateToStatusPost()
                
            case .close:
                print("❌ User chose to close overlay")
                // Already dismissed above
            }
        }
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate to AI insight view for the matched number
    private func navigateToInsightView() {
        // Post notification to trigger insight view navigation
        NotificationCenter.default.post(
            name: Notification.Name("NavigateToInsight"),
            object: nil,
            userInfo: ["number": matchedNumber, "type": "cosmic_match"]
        )
    }
    
    /// Navigate to meditation/chakra view
    private func navigateToMeditationView() {
        // Post notification to navigate to chakra/meditation view
        NotificationCenter.default.post(
            name: Notification.Name("NavigateToMeditation"),
            object: nil,
            userInfo: ["number": matchedNumber, "chakra": currentSacredNumber?.chakra ?? "Universal"]
        )
    }
    
    /// Navigate to journal entry with pre-filled cosmic match data
    private func navigateToJournalEntry() {
        // Post notification to open journal with cosmic match context
        NotificationCenter.default.post(
            name: Notification.Name("NavigateToJournal"),
            object: nil,
            userInfo: [
                "cosmic_match": true,
                "focus_number": matchedNumber,
                "realm_number": matchedNumber,
                "title": "Cosmic Alignment - Number \(matchedNumber)"
            ]
        )
    }
    
    /// Navigate to sighting log with cosmic match data
    private func navigateToSightingLog() {
        // Post notification to open sighting view with cosmic match
        NotificationCenter.default.post(
            name: Notification.Name("NavigateToSighting"),
            object: nil,
            userInfo: [
                "number": matchedNumber,
                "title": "Cosmic Match - Number \(matchedNumber)",
                "significance": "Focus and Realm alignment detected"
            ]
        )
    }
    
    /// Navigate to status posting with cosmic match pre-filled
    private func navigateToStatusPost() {
        // Post notification to open status creation with cosmic match context
        NotificationCenter.default.post(
            name: Notification.Name("NavigateToStatusPost"),
            object: nil,
            userInfo: [
                "cosmic_match": true,
                "number": matchedNumber,
                "message": "✨ Just experienced a cosmic alignment with number \(matchedNumber)! The universe is speaking... 🌌 #CosmicMatch #Number\(matchedNumber) #SpiritualAlignment",
                "sacred_meaning": currentSacredNumber?.name ?? "Sacred Number \(matchedNumber)"
            ]
        )
    }
    
    // MARK: - Animation Logic
    
    /**
     * Handles visibility state changes with debug logging
     * 
     * When the overlay becomes visible:
     * - Resets animation timers
     * - Logs the match event
     * - Starts the cosmic animation sequence
     * 
     * When the overlay becomes hidden:
     * - Resets all animation states
     * - Logs the dismissal
     */
    private func handleVisibilityChange(_ newValue: Bool) {
        if newValue {
            print("🌟 ===== VYBE MATCH OVERLAY ACTIVATED =====")
            print("🌟 Matched Number: \(matchedNumber)")
            if let sacredInfo = currentSacredNumber {
                print("🌟 Sacred Number: \(sacredInfo.name) (\(sacredInfo.chakra) Chakra)")
            }
            print("🌟 Heart Rate: \(heartRate) BPM")
            print("🌟 Animation Duration: \(String(format: "%.2f", heartRateAnimationDuration))s")
            print("🌟 Display Duration: Manual dismiss only (tap background, close button, or action button)")
            
            // Reset animation state
            visibilityDuration = 0
            pulsePhase = 0
            particlePhase = 0
            showActionButtons = false
            highlightedAction = nil
            
            // Start entrance animations
            startEntranceAnimations()
            
        } else {
            print("🌟 Vybe Match Overlay dismissed")
            
            // Reset all animation states
            resetAnimationStates()
            showActionButtons = false
            highlightedAction = nil
        }
    }
    
    /**
     * Starts the smooth entrance animation sequence
     * Creates an elegant growing effect with gentle cosmic elements
     */
    private func startEntranceAnimations() {
        // Start with smaller scale for smooth growth effect
        symbolScale = 0.3
        numberScale = 0.3
        backgroundGlow = 0.0
        numberGlow = 0.0
        
        // Phase 1: Background fades in gently (0.4s)
        withAnimation(.easeOut(duration: 0.4)) {
            backgroundGlow = 0.6
        }
        
        // Phase 2: Smooth scale growth directly to final size (0.7s)
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.1)) {
            symbolScale = 1.0 // Direct to final size - no overshoot
            numberScale = 1.0 // Sacred number grows smoothly with VYBE
        }
        
        // Phase 3: Complete glow fade-in (0.5s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.standardFeedbackDelay) {
            withAnimation(.easeInOut(duration: VybeConstants.standardFeedbackDelay)) {
                self.backgroundGlow = 1.0 // Full cosmic glow
                self.numberGlow = 1.0 // Full number glow
            }
        }
        
        // Phase 4: Start continuous cosmic rotation (1.0s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.dramaticFeedbackDelay) {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                self.cosmicRotation = 360
            }
            withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                self.particlePhase = 360
            }
        }
        
        // 🎯 PHASE 2.2: Show action buttons immediately with bubble for unified cosmic experience
        DispatchQueue.main.asyncAfter(deadline: .now() + VybeConstants.instantFeedbackDelay) {
            if self.isVisible { // Only show if overlay is still visible
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    self.showActionButtons = true
                }
                print("🎯 Phase 2.2: Action buttons revealed")
            }
        }
    }
    
    /**
     * Updates continuous animations based on heart rate
     * Called every 0.1 seconds for smooth animation
     */
    private func updateAnimations() {
        guard isVisible else { return }
        
        // Update visibility duration
        visibilityDuration += 0.1
        
        // Auto-dismiss disabled - user must manually close overlay
        // (displayDuration is set to .infinity for manual dismiss only)
        
        // Update heart rate synchronized pulse
        pulsePhase += 0.1 / heartRateAnimationDuration
        
        // 🌊 GENTLE FLOATING EFFECT: Ethereal breathing animation
        let floatValue = sin(pulsePhase * 1.5 * .pi) // 1.5π frequency: Slower, more mystical than heartbeat
        symbolScale = 1.0 + (floatValue * 0.015) // ±1.5% scale variation: Very subtle (0.985x to 1.015x)
        
        // ✨ ETHEREAL GLOW BREATHING: Subtle opacity pulse synchronized with floating
        backgroundGlow = 0.88 + (floatValue * 0.06) // 6% variation: Gentle pulse (82% to 94% opacity)
        
        // 🌟 SACRED NUMBER PULSE: Synchronized with haptic feedback pattern
        let numberPulse = sin(pulsePhase * 2.0 * .pi) // 2π frequency: More pronounced for number
        numberScale = 1.0 + (numberPulse * 0.025) // ±2.5% scale variation for subtle number emphasis
        numberGlow = 0.92 + (numberPulse * 0.06) // 6% opacity variation for gentle number glow
    }
    
    /**
     * Resets all animation states to default values
     * Called when the overlay is dismissed
     */
    private func resetAnimationStates() {
        symbolScale = 1.0
        numberScale = 1.0
        backgroundGlow = 0.0
        numberGlow = 0.0
        cosmicRotation = 0
        particlePhase = 0
        pulsePhase = 0
        visibilityDuration = 0
        showActionButtons = false
        highlightedAction = nil
    }
}

// MARK: - Sacred Number Information Model

/**
 * Represents sacred number information for enhanced display
 */
struct SacredNumberInfo {
    let name: String
    let color: Color
    let chakra: String
}

// MARK: - Sacred Geometry Shapes

/// Triangle shape for sacred geometry particles
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// Pentagon shape for sacred geometry particles
struct Pentagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<5 {
            let angle = Double(i) * 2 * .pi / 5 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * Foundation.cos(angle),
                y: center.y + radius * Foundation.sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

/// Hexagon shape for sacred geometry particles
struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * 2 * .pi / 6
            let point = CGPoint(
                x: center.x + radius * Foundation.cos(angle),
                y: center.y + radius * Foundation.sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

/// Heptagon shape for sacred geometry particles
struct Heptagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<7 {
            let angle = Double(i) * 2 * .pi / 7 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * Foundation.cos(angle),
                y: center.y + radius * Foundation.sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

/// Octagon shape for sacred geometry particles
struct Octagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<8 {
            let angle = Double(i) * 2 * .pi / 8
            let point = CGPoint(
                x: center.x + radius * Foundation.cos(angle),
                y: center.y + radius * Foundation.sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// Note: AnyShape is defined in SacredGeometryView.swift to avoid duplication

// MARK: - Preview

struct VybeMatchOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black // Dark background for preview
            
            VybeMatchOverlay(
                isVisible: .constant(true),
                matchedNumber: 7,
                heartRate: 72
            )
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 400, height: 600)
    }
}

// MARK: - Supporting Types

/// Action types available in the enhanced cosmic match overlay
enum ActionType: String, CaseIterable {
    case viewInsight = "View Insight"
    case startMeditation = "Start Meditation"
    case journalEntry = "Journal Entry"
    case logSighting = "Log Sighting"
    case postStatus = "Post Status"
    case close = "Close"
    
    /// Icon for each action type
    var icon: String {
        switch self {
        case .viewInsight: return "sparkles"
        case .startMeditation: return "leaf"
        case .journalEntry: return "book"
        case .logSighting: return "eye"
        case .postStatus: return "megaphone"
        case .close: return "xmark"
        }
    }
    
    /// Color theme for each action type
    var color: Color {
        switch self {
        case .viewInsight: return .cyan
        case .startMeditation: return .green
        case .journalEntry: return .orange
        case .logSighting: return .purple
        case .postStatus: return .pink
        case .close: return .red
        }
    }
} 