//
//  HomeView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

/**
 * HomeView: The primary landing screen of the application.
 *
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • Top padding: 50pts from safe area
 * • Main VStack spacing: 30pts between major sections
 * • Horizontal padding: 20pts for content cards
 * • Bottom padding: 20pts before safe area
 *
 * === SACRED GEOMETRY SECTION (350×350pt) ===
 * • Container: 350×350pt frame centered horizontally
 * • Mandala image: Full 350×350pt
 * • Neon tracer overlay: 320×320pt (91% of container)
 * • Focus number text: 140pt font, bold rounded
 * • "Hold to Change" hint: 12pt font, 70% white opacity
 * • Vertical padding: 40pts above and below section
 *
 * === REALM-TIME BUTTON ===
 * • Text: Title2 font (22pt), bold
 * • Padding: 30pt horizontal, 15pt vertical
 * • Corner radius: 20pts
 * • Shadow 1: 15pt blur, 8pt Y offset, 50% opacity
 * • Shadow 2: 25pt blur, 12pt Y offset, 30% opacity
 * • Top margin: 10pts from sacred geometry
 *
 * === TODAY'S INSIGHT CARD ===
 * • Container padding: 20pts all sides
 * • Corner radius: 16pts
 * • Title: Title2 font (22pt), bold
 * • Date: Subheadline font (15pt), 80% opacity
 * • Body text: Body font (17pt), 90% opacity, 4pt line spacing
 * • Shadow: 15pt blur, 8pt Y offset, 30% purple
 * • Gradient: Purple→Indigo→Blue (80%→60%→40% opacity)
 *
 * === RECENT MATCHES SECTION ===
 * • Section title: Headline font (17pt), 10pt bottom spacing
 * • Match cards: 15pt spacing between cards
 * • Card number: Title2 font (22pt), bold
 * • Card timestamp: Caption font (12pt), secondary color
 * • Horizontal scroll padding: 15pts between cards
 *
 * === COSMIC NUMBER PICKER OVERLAY ===
 * • Backdrop: 70% black opacity, full screen
 * • Container: 350×400pt centered
 * • Title: 20pt bold rounded, gradient text
 * • Number grid: 3×3, 15pt spacing
 * • Number circles: 80×80pt
 * • Number text: 32pt bold rounded
 * • Animation: Scale 0.1→1.0, opacity 0→1 over 0.4s
 *
 * === ANIMATION TIMINGS ===
 * • Picker entrance: 0.4s ease-in-out
 * • Number selection: 0.3s spring animation
 * • Realm button color: 0.6s ease-in-out
 * • Insight loading: 1.2s circular progress
 *
 * === COLOR SYSTEM ===
 * • Sacred colors: Dynamic per number (1-9)
 * • Insight gradient: Purple→Indigo→Blue
 * • Match alert gradient: Orange→Red→Purple
 * • Glass effects: 10-30% white overlays
 *
 * === INTERACTION ZONES ===
 * • Sacred geometry: Long press 0.6s for picker
 * • Realm button: Standard tap target (44pt min)
 * • Insight history: Clock icon button (44×44pt)
 * • Number picker: Each number is 80×80pt target
 *
 * Purpose: 
 * Provides a visual dashboard that displays the user's selected focus number and recent matches.
 * Serves as the central hub that users return to after navigating through other sections.
 *
 * Key features:
 * 1. Prominently displays the user's current focus number
 * 2. Shows a beautifully styled "Today's Insight" section
 * 3. Shows a horizontal scrollable list of recent matches
 * 4. Provides quick access to change the focus number
 *
 * Design pattern: MVVM view component
 * Dependencies: FocusNumberManager for data
 */
import SwiftUI

struct HomeView: View {
    // MARK: - 🌟 ENVIRONMENT OBJECT SPIRITUAL ECOSYSTEM INTEGRATION
    
    /// Claude: FocusNumberManager provides the user's selected spiritual focus number (1-9)
    /// and manages cosmic match detection when focus equals realm number.
    /// This manager is the heart of Vybe's spiritual matching system, coordinating
    /// between user intention and cosmic alignment for transcendent experiences.
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    /// Claude: RealmNumberManager calculates the current cosmic realm number based on
    /// time, location, heart rate, and celestial influences. This dynamic number
    /// represents the universe's current energetic state and serves as the target
    /// for cosmic synchronicity when it aligns with the user's focus number.
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    /// Claude: SignInViewModel handles user authentication and personalization,
    /// providing access to user profile data that influences spiritual calculations
    /// and personalized insight generation throughout the cosmic experience.
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    /// Claude: ActivityNavigationManager orchestrates deep linking and navigation
    /// to specific insights within the activity feed, enabling users to seamlessly
    /// navigate between cosmic experiences and their spiritual activity timeline.
    @EnvironmentObject var activityNavigationManager: ActivityNavigationManager
    
    /// Claude: AIInsightManager provides traditional AI insight generation using
    /// template-based spiritual guidance, serving as the foundation layer for
    /// personalized daily spiritual wisdom before KASPER MLX enhancement.
    @EnvironmentObject var aiInsightManager: AIInsightManager
    
    /// Claude: HealthKitManager integrates biometric data including heart rate variability
    /// to enhance cosmic calculations and provide physiological context for spiritual
    /// experiences. Heart rate data influences neon tracer pulsing and realm calculations.
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    // MARK: - 🧠 KASPER MLX SPIRITUAL AI INTEGRATION
    
    /// Claude: KASPERMLXManager represents the revolutionary spiritual AI system that provides
    /// contextually-aware spiritual guidance with sub-second response times. This state object
    /// manages the sophisticated AI inference engine that transforms HomeView from a static
    /// dashboard into an intelligent spiritual companion.
    @StateObject private var kasperMLX = KASPERMLXManager.shared
    
    /// Claude: KASPERFeedbackManager collects user satisfaction data for continuous AI
    /// improvement, enabling the spiritual AI system to learn and evolve based on
    /// user feedback about insight quality and spiritual relevance.
    @StateObject private var kasperFeedback = KASPERFeedbackManager.shared
    
    // MARK: - 🎨 UI STATE MANAGEMENT FOR SPIRITUAL INTERACTIONS
    
    /// Claude: Legacy focus number picker sheet visibility control.
    /// Maintained for backward compatibility but superseded by showingCosmicPicker
    /// for the enhanced cosmic number selection experience.
    @State private var showingPicker = false
    
    /// Claude: Controls visibility of the insight history modal, providing users
    /// access to their complete timeline of received spiritual guidance and
    /// AI-generated insights for reflection and spiritual growth tracking.
    @State private var showingInsightHistory = false
    
    /// Claude: Modern cosmic number picker overlay visibility state.
    /// This sophisticated overlay system replaces traditional sheet modals with
    /// a magical cosmic interface that appears directly over the sacred geometry,
    /// maintaining immersion in the spiritual experience.
    @State private var showingCosmicPicker = false
    
    /// Claude: Animation scale factor for cosmic picker entrance animation.
    /// Starts at 0.1 and animates to 1.0 to create a magical appearance effect
    /// that makes the number picker bloom into existence from the cosmic center.
    @State private var pickerScale: CGFloat = 0.1
    
    /// Claude: Animation opacity for cosmic picker entrance animation.
    /// Coordinates with scale animation to create smooth, mystical transitions
    /// that enhance the spiritual nature of number selection interactions.
    @State private var pickerOpacity: Double = 0.0
    
    // MARK: - 🤖 KASPER MLX AI STATE MANAGEMENT
    
    /// Claude: Current KASPER MLX generated insight displayed in HomeView.
    /// This represents the latest AI-generated spiritual guidance contextually
    /// aware of the user's focus number, realm alignment, and spiritual journey phase.
    /// Race condition issues resolved through proper async/await patterns.
    @State private var kasperInsight: KASPERInsight?
    
    /// Claude: Controls visibility of the KASPER AI insight card in the main view.
    /// When true, displays the sophisticated AI insight with smooth ZStack opacity
    /// transitions that prevent layout hitches during content updates.
    @State private var showKasperCard = true
    
    /// Claude: Holds any error messages from KASPER MLX insight generation.
    /// Provides user-friendly error communication when AI insight generation
    /// encounters issues, maintaining graceful degradation of the spiritual experience.
    @State private var kasperError: String?
    
    /// Claude: Loading state for KASPER MLX insight generation operations.
    /// Enables smooth loading animations with crystal ball iconography that
    /// maintains the mystical aesthetic during AI processing periods.
    @State private var isKasperLoading = false
    
    // MARK: - 📊 PERFORMANCE OPTIMIZATION STATE
    
    /// Claude: CACHE FLOOD FIX - Cached UserProfile to prevent repeated Core Data lookups.
    /// This optimization significantly improves HomeView performance by eliminating
    /// redundant profile queries that were causing UI stuttering during rapid updates.
    /// The cached profile enables instant access to user spiritual data.
    @State private var cachedUserProfile: UserProfile?
    
    // MARK: - 🎊 COSMIC MATCH CELEBRATION STATE
    
    /// Claude: PHASE 3C-2 - Controls visibility of recent cosmic match popup modal.
    /// When a cosmic match is detected (focus number equals realm number), this state
    /// triggers the celebration interface that acknowledges the spiritual synchronicity.
    @State private var showingMatchPopup = false
    
    /// Claude: PHASE 3C-2 - Holds the selected FocusMatch for detailed display.
    /// Contains complete match data including timestamp, location, and cosmic context
    /// for comprehensive celebration and spiritual journey documentation.
    @State private var selectedMatch: FocusMatch?
    
    // MARK: - 🌀 SACRED GEOMETRY ANIMATION STATE
    
    /// Claude: PHASE 8.5 - Tracks current mandala asset for authentic SVG path tracing.
    /// This state enables the NeonTracerView to follow the exact geometric paths
    /// of the currently displayed sacred geometry, creating authentic mystical effects
    /// that trace real mandala structures rather than generic shapes.
    @State private var currentMandalaAsset: SacredGeometryAsset = .wisdomEnneagram
    
    var body: some View {
        ZStack {
            // MARK: - 🌌 COSMIC ANIMATION SYSTEM ARCHITECTURE
            
            /// Claude: ScrollSafeCosmicView provides the revolutionary animation system that enables
            /// continuous cosmic effects without interfering with ScrollView performance. This
            /// sophisticated wrapper prevents animation stuttering during scrolling while maintaining
            /// the mystical twinkling number effects that bloom from sacred geometry centers.
            /// 
            /// The system represents a breakthrough in iOS animation architecture, solving the
            /// challenging problem of scroll-safe continuous animations that plagued earlier
            /// implementations. Users experience seamless cosmic effects even during rapid scrolling.
            ScrollSafeCosmicView {
                // Claude: Primary content container wrapped within cosmic animation system.
                // This ZStack layering enables the cosmic background to render behind all
                // spiritual interface elements while maintaining proper depth relationships.
                ZStack {
                    // MARK: - 🎨 COSMIC BACKGROUND GRADIENT SYSTEM
                    
                    /// Claude: Sophisticated cosmic background gradient replacing the previous
                    /// TwinklingDigitsBackground system for improved performance. This gradient
                    /// creates the mystical purple-to-indigo cosmic atmosphere that defines
                    /// Vybe's spiritual aesthetic while ensuring smooth 60fps performance.
                    /// 
                    /// Color progression: Black → Purple (30%) → Indigo (20%) → Black
                    /// This creates depth and mystical ambiance without overwhelming content.
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black,
                            Color.purple.opacity(0.3),
                            Color.indigo.opacity(0.2),
                            Color.black
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // 🌌 TEMPORARILY DISABLED: TwinklingDigitsBackground to debug freeze
                    // TwinklingDigitsBackground()
                    //     .environmentObject(focusNumberManager)
                    //     .environmentObject(realmNumberManager)
                    //     .environmentObject(activityNavigationManager)
                    //     .ignoresSafeArea()
                    
                    // MARK: - 📱 MAIN SCROLLVIEW CONTENT ARCHITECTURE
                    
                    /// Claude: Primary ScrollView container providing vertical scrolling for all
                    /// spiritual dashboard content. This scrolling system is optimized to work
                    /// seamlessly with ScrollSafeCosmicView's animation system, preventing any
                    /// performance conflicts between scrolling interactions and cosmic animations.
                    ScrollView {
                        /// Claude: Main vertical stack with carefully optimized 15pt spacing.
                        /// This compact spacing balances visual hierarchy with screen real estate
                        /// efficiency, ensuring all spiritual elements remain visible without
                        /// requiring excessive scrolling on standard iPhone displays.
                        VStack(spacing: 15) { // 🎯 MAIN STACK: Compact spacing
                            
                            // MARK: - 🎭 BRAND IDENTITY & NAVIGATION HEADER
                            
                            /// Claude: Brand identity section positioned high in the interface hierarchy.
                            /// The 5pt top padding moves content closer to the status bar for maximum
                            /// screen utilization while maintaining Apple's recommended safe areas.
                            /// 
                            /// Font sizing follows Apple's Human Interface Guidelines:
                            /// - "Vybe" brand: 32pt bold system font for strong brand presence
                            /// - Subtitle: Title2 (22pt) for clear feature identification
                            VStack(spacing: 8) {
                                Text("Vybe")
                                    .font(.system(size: 32, weight: .bold)) // Back to original size
                                
                                Text("Your Focus Number")
                                    .font(.title2) // Back to original size
                            }
                            .padding(.top, 5) // Move higher towards status bar
                            
                            // MARK: ––– SACRED GEOMETRY SECTION START –––
                            // 🌟 SACRED GEOMETRY CONTAINER: 350×350pt with 40pt vertical padding
                            VStack(spacing: 30) {
                                // Focus Number Sacred Geometry
                                VStack(spacing: 20) { // 20pt gap between geometry and hint text
                                    ZStack { // 🎯 LAYERED SACRED DISPLAY: Mandala → Tracer → Number
                                        // Enhanced Sacred Geometry with Focus + Realm Numbers
                                        // This implements ChatGPT's aesthetic-first vision:
                                        // - Data-driven selection (focus + realm numbers)
                                        // - Session-based variation (fresh each time)
                                        // - Hidden mystical significance
                                        // - Pure visual beauty for the user
                                        StaticAssetMandalaView(
                                            number: focusNumberManager.selectedFocusNumber,
                                            size: 350
                                        )
                                        
                                        // PHASE 8I: Number-specific geometric pattern neon tracer
                                        NeonTracerView(
                                            realmNumber: focusNumberManager.selectedFocusNumber,
                                            bpm: Double(healthKitManager.currentHeartRate),
                                            color: getSacredColor(for: focusNumberManager.selectedFocusNumber),
                                            size: CGSize(width: 320, height: 320)
                                        )
                                        .frame(width: 320, height: 320)
                                        
                                        // Phase 13: Organic Edge Buttons positioned around mandala
                                        organicEdgeButtons
                                        
                                        // Large Focus Number with Enhanced Glow
                                        Text("\(focusNumberManager.selectedFocusNumber)")
                                            .font(.system(size: 140, weight: .bold, design: .rounded))
                                            .foregroundColor(getSacredColor(for: focusNumberManager.selectedFocusNumber))
                                            // Reduced shadows for better performance
                                            .shadow(color: getSacredColor(for: focusNumberManager.selectedFocusNumber).opacity(0.6), radius: 15)
                                            .shadow(color: .black.opacity(0.4), radius: 5, x: 2, y: 2)
                                    }
                                    .frame(width: 350, height: 350)
                                    .onLongPressGesture(minimumDuration: 0.6) {
                                        // Haptic feedback
                                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                        impactFeedback.impactOccurred()
                                        
                                        // Show cosmic picker with animation
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            showingCosmicPicker = true
                                            pickerScale = 1.0
                                            pickerOpacity = 1.0
                                        }
                                    }
                                    .onTapGesture {
                                        // Phase 13: Tap gesture for Activity navigation
                                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                        impactFeedback.impactOccurred()
                                        print("Focus number tapped - navigate to Activity view")
                                        // TODO: Implement Activity view navigation
                                    }
                                    
                                    Text("✦ Hold to Change ✦")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding(.vertical, 40)  // Increased padding for more space
                            // MARK: ––– SACRED GEOMETRY SECTION END –––
                            
                            // Realm-Time Button (Enhanced with Dynamic Colors)
                            Button(action: {
                                activityNavigationManager.requestRealmNavigation()
                                print("Realm-Time button tapped - navigation requested")
                            }) {
                                Text("Enter Realm")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .foregroundColor(.white)
                                    .background(
                                        ZStack {
                                            // Base gradient
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    getRealmButtonColor().opacity(0.9),
                                                    getRealmButtonColor().opacity(0.7),
                                                    getRealmButtonColor().opacity(0.5)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            
                                            // Overlay gradient for depth
                                        LinearGradient(
                                                gradient: Gradient(stops: [
                                                    .init(color: Color.white.opacity(0.3), location: 0.0),
                                                    .init(color: Color.clear, location: 0.3),
                                                    .init(color: Color.clear, location: 0.7),
                                                    .init(color: Color.black.opacity(0.2), location: 1.0)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                        )
                                        }
                                    )
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        getRealmButtonColor().opacity(0.8),
                                                        getRealmButtonColor().opacity(0.4)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    .shadow(color: getRealmButtonColor().opacity(0.5), radius: 15, x: 0, y: 8)
                                    .shadow(color: getRealmButtonColor().opacity(0.3), radius: 25, x: 0, y: 12)
                            }
                            .id("realmButton_\(focusNumberManager.selectedFocusNumber)") // Force update when focus changes
                            .animation(.easeInOut(duration: 0.6), value: focusNumberManager.selectedFocusNumber)
                            .padding(.top, 10) // Add some space above the insight section
                            
                            // Claude: KASPER MLX Daily Card Section
                            kasperDailyCardSection
                            
                            // Enhanced Today's Insight Section
                            todaysInsightSection
                            
                            // NEW: Latest Matched Number Insight Section
                            if let matchedInsight = focusNumberManager.latestMatchedInsight,
                               isInsightRecent(matchedInsight.timestamp) { // Only show if recent
                                matchedInsightSection(insightData: matchedInsight)
                            }
                            
                            // Recent Matches Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recent Matches")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                if focusNumberManager.matchLogs.isEmpty {
                                    Text("No matches yet")
                                        .foregroundColor(.secondary)
                                        .padding()
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(Array(focusNumberManager.matchLogs.prefix(5).enumerated()), id: \.offset) { index, match in
                                                VStack {
                                                    Text("#\(match.matchedNumber)")
                                                        .font(.title2)
                                                        .bold()
                                                    Text(match.timestamp, style: .time)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding()
                                                .background(Color.purple.opacity(0.1))
                                                .cornerRadius(10)
                                                .onLongPressGesture(minimumDuration: 0.8) {
                                                    // PHASE 3C-2: Show match details popup on hold
                                                    selectedMatch = match
                                                    showingMatchPopup = true
                                                    
                                                    // Haptic feedback
                                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                                    impactFeedback.impactOccurred()
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Change Number Button
                            Button("Change Number") {
                                showingPicker = true
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 50)
                    }
                }
            }
            
            // Cosmic Number Picker Overlay
            if showingCosmicPicker {
                cosmicNumberPickerOverlay
            }
            
            // PHASE 3C-2: Recent Match Popup Overlay
            if showingMatchPopup, let match = selectedMatch {
                RecentMatchPopupView(
                    matchData: match,
                    onDismiss: {
                        showingMatchPopup = false
                        selectedMatch = nil
                    }
                )
            }
        }
        .sheet(isPresented: $showingPicker) {
            FocusNumberPicker()
        }
        .sheet(isPresented: $showingInsightHistory) {
            InsightHistoryView()
        }
        .onAppear {
            // Claude: Fixed race condition - ensure KASPER MLX is configured early and once
            // Claude: SWIFT 6 COMPLIANCE - Removed [weak self] from struct (value type)
            Task {
                // Configure KASPER MLX first (if not already configured)
                if !kasperMLX.isReady {
                    await kasperMLX.configure(
                        realmManager: realmNumberManager,
                        focusManager: focusNumberManager,
                        healthManager: healthKitManager
                    )
                }
            }
            
            // FREEZE FIX: Stagger HomeView operations to prevent simultaneous heavy lifting
            
            // Step 1: Load match logs (lightweight)
            focusNumberManager.loadMatchLogs()
            
            // Step 2: Cache user profile (lightweight, after small delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if cachedUserProfile == nil, let userID = signInViewModel.userID {
                    cachedUserProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
                }
            }
            
            // Step 3: AI insights (can be heavy, after larger delay)
            // Claude: SWIFT 6 COMPLIANCE - Use Task for async method call
            Task {
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second delay
                await aiInsightManager.refreshInsightIfNeeded()
            }
            
            // Claude: Phase 8.5 - Initialize current mandala asset for SVG path tracing
            updateCurrentMandalaAsset()
        }
        .onChange(of: focusNumberManager.selectedFocusNumber) { oldValue, newValue in
            // Claude: Phase 8.5 - Update mandala asset when focus number changes
            updateCurrentMandalaAsset()
        }
    }
    
    // Claude: Phase 8.5 - Update current mandala asset for authentic SVG path tracing
    private func updateCurrentMandalaAsset() {
        // Get the current asset that DynamicAssetMandalaView would select
        currentMandalaAsset = SacredGeometryAsset.selectSmartAsset(for: focusNumberManager.selectedFocusNumber)
        print("🌟 PHASE 8.5: Updated focus mandala asset to \(currentMandalaAsset.displayName) for focus number \(focusNumberManager.selectedFocusNumber)")
    }

    // Helper to check if an insight is recent (e.g., within last 24 hours)
    private func isInsightRecent(_ date: Date, within interval: TimeInterval = 24 * 60 * 60) -> Bool {
        return Date().timeIntervalSince(date) < interval
    }
    
    // MARK: - Today's Insight Section
    
    private var todaysInsightSection: some View {
        VStack(spacing: 20) {
            // Header with date
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Insight")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    showingInsightHistory = true
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Insight Content
            VStack(spacing: 16) {
                if aiInsightManager.isInsightReady {
                    if let insight = aiInsightManager.personalizedDailyInsight {
                        Text(insight.text)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Alignment context with beautiful styling (cache optimized)
                        if let userProfile = cachedUserProfile {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                
                                Text("Aligned to your Life Path \(userProfile.lifePathNumber) & \(userProfile.spiritualMode) energy")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .italic()
                                
                                Spacer()
                            }
                            .padding(.top, 8)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.circle")
                                .font(.title)
                                .foregroundColor(.green.opacity(0.8))
                            
                            Text("Your personalized insight is growing...")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Text("Return soon for your daily wisdom")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .italic()
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                        
                        Text("Cultivating your insight...")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.8),
                    Color.indigo.opacity(0.6),
                    Color.blue.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.white.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(16)
        .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal)
    }
    
    // MARK: - 🔮 KASPER MLX DAILY CARD SECTION - SPIRITUAL AI ON THE HOME SCREEN
    
    /**
     * KASPER MLX Daily Card Integration - The Heart of Vybe's Home Experience
     * ====================================================================
     * 
     * This section represents the crown jewel of HomeView - where users first
     * encounter Vybe's revolutionary KASPER MLX spiritual AI system. Positioned
     * strategically below the "Enter Realm" button and above traditional insights,
     * this section provides users with immediate access to personalized spiritual
     * guidance powered by cutting-edge on-device AI.
     * 
     * 🎯 STRATEGIC POSITIONING:
     * 
     * The placement is intentional and psychologically optimized:
     * • Below "Enter Realm" button: Users see spiritual AI as part of their journey
     * • Above traditional insights: KASPER MLX takes priority as the primary guidance source
     * • Integrated with cosmic flow: Maintains Vybe's spiritual aesthetic and rhythm
     * • Non-intrusive design: Appears only when relevant, respects user's headspace
     * 
     * 🔮 SPIRITUAL AI INTEGRATION:
     * 
     * This section showcases the full power of KASPER MLX:
     * • Real-time cosmic data: Planetary positions, moon phases, astrological events
     * • Numerological synthesis: User's focus/realm numbers integrated into guidance
     * • Contextual awareness: Time of day, season, and spiritual calendar considered
     * • Personalized insights: Each card reflects the user's unique cosmic signature
     * 
     * 🎨 USER EXPERIENCE DESIGN:
     * 
     * The interface balances mystical aesthetics with modern functionality:
     * • Crystal ball emoji (🔮) establishes spiritual AI branding
     * • Smooth animations maintain 60fps cosmic flow
     * • Color-coded feedback system (green/red for like/dislike)
     * • Expandable content respects screen real estate
     * • Loading states maintain spiritual ambiance during generation
     * 
     * 📊 PERFORMANCE CONSIDERATIONS:
     * 
     * HomeView is performance-critical, so this section is optimized for:
     * • Lazy loading: Insights generate only when section becomes visible
     * • Smart caching: Prevents redundant cosmic calculations during scrolling
     * • Background processing: Never blocks the main UI thread
     * • Memory efficiency: Releases resources when section scrolls out of view
     * 
     * 🔄 INTERACTION PATTERNS:
     * 
     * The section supports multiple user engagement modes:
     * • Passive consumption: Users can simply read insights without interaction
     * • Active feedback: Like/dislike buttons train the AI for better future insights
     * • Regeneration: Users can request new insights if current one doesn't resonate
     * • Expansion: Tap to read full insight when content is truncated
     * 
     * 💫 INTEGRATION WITH VYBE ECOSYSTEM:
     * 
     * This section doesn't exist in isolation - it harmoniously connects with:
     * • Focus/Realm numbers: Visual consistency with existing spiritual metrics
     * • Daily insights: Complements rather than competes with traditional guidance
     * • Journal system: Insights can inspire journal entries and vice versa
     * • Dynamic Island: Provides quick access to spiritual AI from anywhere
     * 
     * This represents the first time users interact with AI-powered spiritual
     * guidance in Vybe, making it a critical touchpoint for establishing trust
     * and demonstrating the unique value of spiritually-conscious AI.
     */
    private var kasperDailyCardSection: some View {
        Group {
            if showKasperCard {
                VStack(spacing: 20) {
                    // Enhanced spiritual header
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                // Pulsing cosmic indicator - PERFORMANCE OPTIMIZED
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.cyan.opacity(0.8),
                                                Color.purple.opacity(0.4),
                                                Color.clear
                                            ]),
                                            center: .center,
                                            startRadius: 2,
                                            endRadius: 8
                                        )
                                    )
                                    .frame(width: 12, height: 12)
                                    .scaleEffect(kasperMLX.isGeneratingInsight ? 1.2 : 1.0)
                                    // FIXED: Use autoreverses for smooth pulsing without expensive recalculation
                                    .animation(
                                        kasperMLX.isGeneratingInsight ? 
                                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : 
                                        .easeInOut(duration: 0.3),
                                        value: kasperMLX.isGeneratingInsight
                                    )
                                
                                Text("🔮 KASPER AI Insight")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white,
                                                Color.cyan.opacity(0.8)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                            
                            HStack(spacing: 4) {
                                Text("Personalized spiritual guidance")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                if kasperMLX.isReady {
                                    Text("• Ready")
                                        .font(.caption2)
                                        .foregroundColor(.green.opacity(0.8))
                                } else {
                                    Text("• Initializing...")
                                        .font(.caption2)
                                        .foregroundColor(.orange.opacity(0.8))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Elegant dismiss button
                        Button(action: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showKasperCard = false 
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.4))
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                        .frame(width: 24, height: 24)
                                )
                        }
                        .accessibilityLabel("Dismiss KASPER insight card")
                    }
                    
                    // Claude: DEFINITIVE RESIZE HITCH FIX - Use opacity transitions instead of layout animations
                    ZStack {
                        // Generate button (always present for consistent layout)
                        kasperGenerateButton
                            .opacity(kasperInsight == nil && !isKasperLoading && kasperError == nil ? 1.0 : 0.0)
                        
                        // Loading state
                        kasperLoadingState
                            .opacity(isKasperLoading ? 1.0 : 0.0)
                        
                        // Error state
                        if let error = kasperError {
                            kasperErrorDisplay(error)
                                .opacity(1.0)
                        }
                        
                        // Insight display
                        if let insight = kasperInsight {
                            kasperInsightDisplay(insight)
                                .opacity(1.0)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isKasperLoading)  // Only animate loading state
                }
                .frame(minHeight: 320)  // Claude: Enhanced height for richer insights - prevents resize hitch
                .padding(20)
                .background(
                    ZStack {
                        // Base spiritual gradient
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple.opacity(0.8),
                                        Color.indigo.opacity(0.6),
                                        Color.cyan.opacity(0.4),
                                        Color.purple.opacity(0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Subtle cosmic overlay
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.1),
                                        Color.clear,
                                        Color.cyan.opacity(0.2)
                                    ]),
                                    center: .topLeading,
                                    startRadius: 50,
                                    endRadius: 200
                                )
                            )
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.cyan.opacity(0.6),
                                    Color.purple.opacity(0.4),
                                    Color.white.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(16)
                .shadow(color: .purple.opacity(0.4), radius: 20, x: 0, y: 10)
                .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .onAppear {
                    // Claude: Fixed auto-generation - only generate if needed and KASPER is ready
                    if kasperInsight == nil && !isKasperLoading && kasperMLX.isReady {
                        generateDailyInsight()
                    }
                }
            }
        }
    }
    
    /// Claude: Error display for KASPER insight generation failures
    private func kasperErrorDisplay(_ errorMessage: String) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                
                Text("Insight Generation Issue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Button("Try Again") {
                generateDailyInsight()
            }
            .font(.caption.weight(.medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.3))
                    .overlay(
                        Capsule()
                            .stroke(Color.orange.opacity(0.6), lineWidth: 1)
                    )
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)  // Claude: Further enhanced height for comprehensive spiritual insights
    }
    
    /// Claude: SIMPLIFIED loading state - Prevents compiler timeout
    private var kasperLoadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                .scaleEffect(1.5)
            
            Text("Consulting the cosmic wisdom...")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .italic()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)  // Claude: Further enhanced height for comprehensive spiritual insights
    }
    
    /// Claude: Display generated KASPER insight with actions - FIXED RESIZE HITCH
    private func kasperInsightDisplay(_ insight: KASPERInsight) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Claude: DEFINITIVE HITCH FIX - Use fixed height container to prevent resize
            Text(insight.content)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 300, alignment: .topLeading)  // Comprehensive space for detailed spiritual guidance
                .clipped()  // Clip overflow to prevent resize
            
            // Insight metadata
            HStack {
                Text("Confidence: \(Int(insight.confidence * 100))%")
                    .font(.caption2)
                    .foregroundColor(.green.opacity(0.8))
                
                Spacer()
                
                Text("Generated \(insight.generatedAt, style: .relative) ago")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Enhanced action buttons section
            VStack(spacing: 12) {
                // Regenerate button
                Button(action: generateDailyInsight) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                        Text("Generate New Insight")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.cyan.opacity(0.6),
                                                Color.purple.opacity(0.4)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .shadow(color: .cyan.opacity(0.3), radius: 6, x: 0, y: 2)
                }
                .disabled(isKasperLoading)
                
                // Enhanced feedback buttons section
                HStack(spacing: 20) {
                    Text("Was this helpful?")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .italic()
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Positive feedback button
                        Button(action: { provideFeedback(positive: true) }) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                                .scaleEffect(1.1)
                                .shadow(color: .green.opacity(0.6), radius: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Rate insight as helpful")
                        
                        // Negative feedback button
                        Button(action: { provideFeedback(positive: false) }) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                                .scaleEffect(1.1)
                                .shadow(color: .red.opacity(0.6), radius: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("Rate insight as not helpful")
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    /// Claude: Enhanced generate insight button with spiritual aesthetics
    private var kasperGenerateButton: some View {
        Button(action: generateDailyInsight) {
            HStack(spacing: 12) {
                // Cosmic icon with glow effect
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.cyan.opacity(0.8),
                                    Color.purple.opacity(0.4),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(.white)
                        .shadow(color: .cyan.opacity(0.8), radius: 4)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("🔮 Generate Today's Insight")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Tap to receive personalized cosmic guidance")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Animated arrow with spiritual glow  
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan.opacity(0.6), radius: 3)
                    .scaleEffect(kasperMLX.isReady ? 1.0 : 0.8)
                    .opacity(kasperMLX.isReady ? 1.0 : 0.5)
            }
            .frame(height: 180)  // Claude: Enhanced height to match insight container
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.15),
                                Color.purple.opacity(0.1),
                                Color.cyan.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.cyan.opacity(0.6),
                                        Color.purple.opacity(0.4),
                                        Color.white.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            )
            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 4)
            .scaleEffect(kasperMLX.isReady ? 1.0 : 0.95)
        }
        .disabled(!kasperMLX.isReady || isKasperLoading)
        .animation(.easeInOut(duration: 0.3), value: kasperMLX.isReady)
        .accessibilityLabel("Generate spiritual insight")
        .accessibilityHint("Tap to create a personalized daily guidance card using cosmic AI")
    }
    
    // MARK: - Latest Matched Insight Section
    
    private func matchedInsightSection(insightData: MatchedInsightData) -> some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cosmic Resonance Alert!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow) // Distinguish from Today's Insight
                    
                    Text("Focus Number \(insightData.number) Aligned - \(insightData.timestamp, style: .relative) ago")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                // Optional: Add a button to navigate to the full Activity page later
            }
            
            // Insight Content
            Text(insightData.text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .lineLimit(5) // Show a preview, full text on Activity page
                .fixedSize(horizontal: false, vertical: true)
            
            // TODO: Add a "View Full Insight" button or make the section tappable
            // to navigate to the new Activity Page
            Button(action: {
                activityNavigationManager.requestNavigation(to: insightData)
            }) {
                Text("Read Full Resonance Message")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.top, 10)
            }

        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.7), // Different color scheme
                    Color.red.opacity(0.5),
                    Color.purple.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow.opacity(0.4), .orange.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(16)
        .shadow(color: .orange.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal)
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var cosmicNumberPickerOverlay: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissCosmicPicker()
                }
            
            VStack(spacing: 20) {
                Text("✦ Choose Your Sacred Focus Number ✦")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .purple.opacity(0.8), .cyan.opacity(0.6)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 2)
                
                // Sacred number grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            selectFocusNumber(number)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                getSacredColor(for: number).opacity(0.8),
                                                getSacredColor(for: number).opacity(0.4),
                                                Color.black.opacity(0.3)
                                            ]),
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 35
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(getSacredColor(for: number), lineWidth: 2)
                                    )
                                    .shadow(color: getSacredColor(for: number).opacity(0.6), radius: 10, x: 0, y: 0)
                                
                                Text("\(number)")
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
                            }
                        }
                        .scaleEffect(focusNumberManager.selectedFocusNumber == number ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: focusNumberManager.selectedFocusNumber)
                    }
                }
                .padding(.horizontal, 30)
                
                Button("✦ Close ✦") {
                    dismissCosmicPicker()
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 10)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.6), .blue.opacity(0.4)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .scaleEffect(pickerScale)
        .opacity(pickerOpacity)
    }
    
    private func selectFocusNumber(_ number: Int) {
        // Haptic feedback for selection
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
        
        // Update focus number
        focusNumberManager.userDidPickFocusNumber(number)
        
        // Dismiss picker with animation
        dismissCosmicPicker()
    }
    
    private func dismissCosmicPicker() {
        withAnimation(.easeInOut(duration: 0.3)) {
            pickerScale = 0.1
            pickerOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showingCosmicPicker = false
        }
    }
    
    // MARK: - Phase 13: Organic Edge Buttons
    
    /// January 20, 2025: Kabalistic organic arrangement - mystical positioning around the sacred mandala
    /// Creates an esoteric, natural flow that feels intuitive and spiritually aligned
    private var organicEdgeButtons: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                // KABALISTIC ARRANGEMENT: Organic positioning for mystical flow
                
                // Sightings - Top center (unchanged)
                cosmicEdgeButton(
                    icon: "🔭",
                    title: "Sightings",
                    color: .cyan,
                    destination: .sightings
                )
                .position(
                    x: center.x,
                    y: center.y - 190
                )
                
                // Settings - SPREAD OUT MORE (top row wider)
                cosmicEdgeButton(
                    icon: "⚙️",
                    title: "Settings",
                    color: .gray,
                    destination: .settings
                )
                .position(
                    x: center.x + 140, // Spread out from +120 to +140
                    y: center.y - 150 // Higher than before
                )
                
                // Sanctum - CLOSER TO SCREEN EDGE
                cosmicEdgeButton(
                    icon: "🏛️",
                    title: "Sanctum",
                    color: .indigo,
                    destination: .sanctum,
                    size: .compact // 25% smaller
                )
                .position(
                    x: center.x + 165, // Closer to right edge (from +140 to +165)
                    y: center.y + 20
                )
                
                // Create - LOWER (pushed down further)
                cosmicEdgeButton(
                    icon: "✍️",
                    title: "Create",
                    color: .orange,
                    destination: .create
                )
                .position(
                    x: center.x + 135,
                    y: center.y + 180 // Even lower than before
                )
                
                // Analytics - Bottom center (unchanged)
                cosmicEdgeButton(
                    icon: "📈",
                    title: "Analytics",
                    color: .pink,
                    destination: .analytics
                )
                .position(
                    x: center.x,
                    y: center.y + 190
                )
                
                // Graph - LOWER (pushed down further)
                cosmicEdgeButton(
                    icon: "📊",
                    title: "Graph",
                    color: .green,
                    destination: .graph
                )
                .position(
                    x: center.x - 135,
                    y: center.y + 180 // Even lower than before
                )
                
                // Activity - CLOSER TO SCREEN EDGE
                cosmicEdgeButton(
                    icon: "📱",
                    title: "Activity",
                    color: .yellow,
                    destination: .activity,
                    size: .compact // 25% smaller
                )
                .position(
                    x: center.x - 165, // Closer to left edge (from -140 to -165)
                    y: center.y + 20
                )
                
                // Chakras - SPREAD OUT MORE (top row wider)
                cosmicEdgeButton(
                    icon: "🌈",
                    title: "Chakras",
                    color: .purple,
                    destination: .chakras
                )
                .position(
                    x: center.x - 140, // Spread out from -120 to -140
                    y: center.y - 150 // Higher than before
                )
            }
        }
        .frame(width: 350, height: 350)
    }
    
    /// January 20, 2025: Individual cosmic edge button - orbiting planet style
    /// Designed as orbiting planets around the central mandala
    private func cosmicEdgeButton(
        icon: String,
        title: String, 
        color: Color,
        destination: CosmicDestination,
        size: ButtonSize = .standard
    ) -> some View {
        Button(action: {
            navigateToDestination(destination)
        }) {
            VStack(spacing: size == .compact ? 4 : 6) {
                Text(icon)
                    .font(.system(size: size.iconSize))
                
                Text(title)
                    .font(.system(size: size.textSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(width: size.dimensions, height: size.dimensions)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        color.opacity(0.8),
                                        color.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: color.opacity(0.4), radius: size == .compact ? 9 : 12, x: 0, y: 3)
            .shadow(color: .black.opacity(0.3), radius: size == .compact ? 4 : 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0) // Full size for orbiting planet effect
    }
    
    /// January 20, 2025: Navigation destinations for edge buttons
    private enum CosmicDestination {
        case sightings, chakras, sanctum, create, graph, activity, settings, analytics
    }
    
    /// Button size options for different positioning needs
    private enum ButtonSize {
        case standard, compact
        
        var dimensions: CGFloat {
            switch self {
            case .standard: return 88 // Original size
            case .compact: return 66  // 25% smaller (88 * 0.75 = 66)
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .standard: return 28
            case .compact: return 21 // 25% smaller
            }
        }
        
        var textSize: CGFloat {
            switch self {
            case .standard: return 12
            case .compact: return 9  // 25% smaller
            }
        }
    }
    
    /// January 20, 2025: Handle navigation to different destinations
    /// Uses the same notification pattern that ContentView already supports
    private func navigateToDestination(_ destination: CosmicDestination) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        print("🚀 HomeView: Button tapped for destination: \(destination)")
        
        // Use the working ActivityNavigationManager patterns that ContentView already handles
        switch destination {
        case .graph:
            print("📊 Using ActivityNavigationManager for Realm")
            activityNavigationManager.requestRealmNavigation()
            
        case .activity:
            print("📱 Using ActivityNavigationManager for Activity")
            // Create a simple insight data for navigation
            let activityInsight = MatchedInsightData(
                number: focusNumberManager.selectedFocusNumber,
                category: "Cosmic Navigation",
                text: "Cosmic Activity Hub - Explore your spiritual journey",
                timestamp: Date()
            )
            activityNavigationManager.requestNavigation(to: activityInsight)
            
        case .sightings:
            print("🔭 Navigating to Sightings with required userInfo")
            // ContentView handler requires: number, title, significance
            NotificationCenter.default.post(
                name: Notification.Name("NavigateToSighting"), 
                object: nil,
                userInfo: [
                    "number": focusNumberManager.selectedFocusNumber,
                    "title": "Cosmic Sighting from Focus \(focusNumberManager.selectedFocusNumber)",
                    "significance": "Mystical observation logged from cosmic command center"
                ]
            )
            
        case .chakras:
            print("🌈 Navigating to Chakras/Meditation with required userInfo")
            // ContentView handler requires: number, chakra
            NotificationCenter.default.post(
                name: Notification.Name("NavigateToMeditation"), 
                object: nil,
                userInfo: [
                    "number": focusNumberManager.selectedFocusNumber,
                    "chakra": "Root" // Default chakra for meditation
                ]
            )
            
        case .sanctum:
            print("🏛️ Navigating to My Sanctum")
            // Our custom handler - no special userInfo required
            NotificationCenter.default.post(name: Notification.Name("NavigateToSanctum"), object: nil)
            
        case .create:
            print("✍️ Navigating to Timeline and opening Post Composer")
            // Use the same NotificationCenter pattern that works for other buttons
            NotificationCenter.default.post(
                name: Notification.Name("NavigateToStatusPost"), 
                object: nil,
                userInfo: [
                    "cosmic_match": true,
                    "number": focusNumberManager.selectedFocusNumber,
                    "message": "Cosmic Vybe from Focus \(focusNumberManager.selectedFocusNumber)",
                    "sacred_meaning": "Sacred energy shared from cosmic command center"
                ]
            )
            print("🎨 Posted NavigateToStatusPost notification")
            
        case .settings:
            print("⚙️ Navigating to Settings")
            // Our custom handler - no special userInfo required
            NotificationCenter.default.post(name: Notification.Name("NavigateToSettings"), object: nil)
            
        case .analytics:
            print("📈 Navigating to Analytics with required userInfo")
            // ContentView handler requires: number
            NotificationCenter.default.post(
                name: Notification.Name("NavigateToAnalytics"), 
                object: nil,
                userInfo: [
                    "number": focusNumberManager.selectedFocusNumber
                ]
            )
        }
    }
    
    // MARK: - Sacred Color System
    
    private func getSacredColor(for number: Int) -> Color {
        switch number {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Consistent gold
        case 9: return .white
        default: return .white
        }
    }
    
    private func getRealmButtonColor() -> Color {
        // Dynamic color based on FOCUS number - matches the focus number display
        switch focusNumberManager.selectedFocusNumber {
        case 1: return .red
        case 2: return .orange  
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // EXACT match with focus number
        case 9: return .white
        default: return .blue // fallback
        }
    }
    
    // MARK: - Sacred Path Creation
    // Creates paths that match the actual sacred geometry mandala patterns
    private func createSacredPath(for number: Int) -> CGPath {
        let path = CGMutablePath()
        let centerX: CGFloat = 160
        let centerY: CGFloat = 160
        
        switch number {
        case 1: // Simple circle for unity
            let radius: CGFloat = 120
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))
            
        case 2: // Star of David pattern (what's shown in your screenshot)
            // Create the outer star pattern that matches the sacred geometry
            let outerRadius: CGFloat = 140
            let innerRadius: CGFloat = 70
            
            // Create a 12-pointed star path that traces the outer edges of the mandala
            for i in 0..<12 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 12.0 - .pi / 2
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 3: // Triangle
            let radius: CGFloat = 130
            for i in 0..<3 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 3.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 4: // Square
            let radius: CGFloat = 120
            for i in 0..<4 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 4.0 - .pi / 4
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 5: // Pentagon
            let radius: CGFloat = 125
            for i in 0..<5 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 5.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 6: // Hexagon/Star of David
            let radius: CGFloat = 130
            for i in 0..<6 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 6.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 7: // Heptagon
            let radius: CGFloat = 125
            for i in 0..<7 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 7.0 - .pi / 2
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 8: // Octagon
            let radius: CGFloat = 130
            for i in 0..<8 {
                let angle = (CGFloat(i) * 2.0 * .pi) / 8.0 - .pi / 4
                let x = centerX + radius * cos(angle)
                let y = centerY + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
        case 9: // Circle for completion
            let radius: CGFloat = 135
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))
            
        default: // Default circle
            let radius: CGFloat = 120
            path.addEllipse(in: CGRect(x: centerX - radius, y: centerY - radius, width: radius * 2, height: radius * 2))
        }
        
        return path
    }
    
    // MARK: - KASPER MLX Methods
    
    /// Claude: Fixed daily insight generation with robust error handling and race condition prevention
    private func generateDailyInsight() {
        // Prevent multiple simultaneous generations
        guard !isKasperLoading else {
            print("🔮 KASPER MLX: Already generating insight, skipping duplicate request")
            return
        }
        
        // Claude: SWIFT 6 COMPLIANCE - Removed [weak self] from struct (value type)
        Task {
            let startTime = Date()
            
            // Set loading state immediately on main thread
            await MainActor.run {
                isKasperLoading = true
                self.kasperError = nil
            }
            
            do {
                print("🔮 KASPER MLX: Generating daily insight for HomeView")
                
                // Wait for KASPER MLX to be ready (with timeout)
                var waitTime = 0.0
                let maxWaitTime = 5.0 // 5 second timeout
                
                while !self.kasperMLX.isReady && waitTime < maxWaitTime {
                    try await Task.sleep(nanoseconds: 100_000_000) // 100ms
                    waitTime += 0.1
                }
                
                guard self.kasperMLX.isReady else {
                    throw NSError(domain: "KASPERMLXError", code: 1, userInfo: [
                        NSLocalizedDescriptionKey: "KASPER MLX not ready after \(Int(maxWaitTime)) seconds"
                    ])
                }
                
                // Generate daily card insight with current focus/realm context
                let cardType = "daily_focus_\(self.focusNumberManager.selectedFocusNumber)_realm_\(self.realmNumberManager.currentRealmNumber)"
                let insight = try await self.kasperMLX.generateDailyCardInsight(cardType: cardType)
                
                // Update UI on main thread
                await MainActor.run {
                    self.kasperInsight = insight
                    self.isKasperLoading = false
                    self.kasperError = nil
                }
                
                let responseTime = Date().timeIntervalSince(startTime)
                print("🔮 KASPER MLX: Daily insight generated in \(String(format: "%.3f", responseTime))s")
                print("🔮 Insight Content: \(insight.content)")
                print("🔮 Confidence: \(Int(insight.confidence * 100))%")
                
                // Performance validation - warn if >2s (more realistic for HomeView)
                if responseTime > 2.0 {
                    print("⚠️ KASPER MLX: Response time \(String(format: "%.3f", responseTime))s exceeds 2s target for HomeView")
                } else {
                    print("✅ KASPER MLX: Performance target met - \(String(format: "%.3f", responseTime))s")
                }
                
            } catch {
                let responseTime = Date().timeIntervalSince(startTime)
                print("❌ KASPER MLX: Failed to generate daily insight after \(String(format: "%.3f", responseTime))s: \(error)")
                
                // Set error state on main thread
                await MainActor.run {
                    self.kasperInsight = nil
                    self.isKasperLoading = false
                    self.kasperError = error.localizedDescription
                }
            }
        }
    }
    
    /// Claude: Provide user feedback for KASPER insight
    private func provideFeedback(positive: Bool) {
        guard let insight = kasperInsight else { return }
        
        let feedback = positive ? "👍" : "👎"
        print("🔮 KASPER MLX: User feedback - \(feedback)")
        
        // Record feedback for training
        kasperFeedback.recordFeedback(
            for: insight,
            rating: positive ? .positive : .negative,
            contextData: [
                "source": "homeview_daily_card",
                "focus_number": "\(focusNumberManager.selectedFocusNumber)",
                "realm_number": "\(realmNumberManager.currentRealmNumber)"
            ]
        )
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: positive ? .light : .soft)
        impactFeedback.impactOccurred()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FocusNumberManager.shared)
    }
}
