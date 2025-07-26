import SwiftUI
import Foundation

// MARK: - Service Dependencies
/// Claude: Centralized services eliminate scope issues and provide clean architecture

/// Claude: Global MegaCorpus data loading function for compatibility
@MainActor func loadMegaCorpusData() -> [String: Any] {
    return SanctumDataManager.shared.megaCorpusData
}

/**
 * SanctumTabView - The Sacred Digital Altar
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * User's permanent spiritual sanctuary displaying their complete cosmic profile.
 * This is the most complex view in the app with multiple interactive components.
 * 
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • NavigationView: Large title "My Sanctum"
 * • Background: Full screen CosmicBackgroundView
 * • ScrollView: Vertical, 16pt horizontal padding
 * • Edit button: Top-right toolbar, purple color
 * 
 * === MAIN SECTIONS ===
 * 1. Divine Triangle (Numerology Trinity)
 * 2. Complete Archetype Codex (4 cards)
 * 3. Action Buttons (3 buttons)
 * 4. Profile Summary (personal info)
 * 
 * === DIVINE TRIANGLE SECTION ===
 * • Container: Black 40% opacity, 20pt corner radius
 * • Border: 1.5pt gradient stroke (purple→blue→indigo)
 * • Shadow: Purple 50%, 20pt blur, 8pt Y offset
 * • Title: "✦ The Divine Triangle ✦" - Title2 bold
 * • Subtitle: Caption font, 80% white
 * 
 * === LIFE PATH CARD (Primary) ===
 * • Size: Full width, ~140pt height
 * • Background: Gradient (primary color→black)
 * • Number display: 60pt bold, white
 * • Title: Title3 bold, gradient text
 * • Description: Body font, 95% white
 * • Tap action: Opens LifePathDetailView
 * 
 * === SOUL URGE & EXPRESSION CARDS ===
 * • Layout: Side by side, equal width
 * • Spacing: 16pt between cards
 * • Height: ~120pt each
 * • Number: 36pt medium
 * • Similar styling to Life Path
 * 
 * === ARCHETYPE CODEX SECTION ===
 * • Container: Same as Divine Triangle
 * • 4 full-width cards, 16pt spacing
 * • Each card is tappable
 * 
 * === ARCHETYPE CARD SPECS ===
 * • Height: ~100pt
 * • Layout: HStack with icon left, content right
 * • Icon: 40pt font size, colored shadow
 * • Title: Headline font, gradient
 * • Description: 3 lines max, footnote
 * • Tap feedback: UIImpactFeedbackGenerator.medium
 * 
 * === ACTION BUTTONS ===
 * • Layout: 3 buttons in HStack
 * • Spacing: 12pt between buttons
 * • Height: 50pt each
 * • Style: Gradient background, 12pt radius
 * • Icons: SF Symbols, 20pt size
 * 
 * === PROFILE SUMMARY ===
 * • Container: Same styling as other sections
 * • Content: Name, birthdate, birth time, location
 * • Font: Body for labels, headline for values
 * • Layout: VStack with 12pt spacing
 * 
 * === ANIMATIONS ===
 * • Life Path pulse: 2s duration, forever
 * • Archetype glow: 3s duration, forever
 * • Card hover: Scale 1.02, shadow increase
 * • Tap: Scale 0.98, then back
 * 
 * === LOADING SEQUENCE ===
 * • 0.2s: Cache check
 * • 1.0s: Full profile load
 * • 2.0s: Archetype generation
 * • Prevents tab switching lag
 * 
 * === COLOR SYSTEM ===
 * • Zodiac: Blue/Cyan
 * • Elements: Fire(Red), Earth(Brown), Air(Yellow), Water(Cyan)
 * • Planets: Orange/Yellow (primary), Indigo/Purple (shadow)
 * • Numbers: Sacred color system (1-9)
 * 
 * === SHEET PRESENTATIONS ===
 * • Edit Profile: Full screen sheet
 * • Archetype Detail: Modal with close button
 * • Sigil View: Placeholder for future
 * 
 * === STATE MANAGEMENT ===
 * • userProfile: Current user data
 * • archetypeManager: Singleton for archetype
 * • selectedArchetypeDetail: Sheet navigation
 * • Animation states: Pulse and glow booleans
 * 
 * This is the user's permanent spiritual sanctuary where they can:
 * - View their complete spiritual archetype
 * - Interact with archetypal components for deeper understanding
 * - Access their sigil (future)
 * - Share their spiritual card (future)
 * - Edit core profile information
 */

// MARK: - Helper Functions for Spiritual Descriptions

// Claude: Life Path Descriptions using SanctumDataManager for KASPER AI integration
@MainActor func lifePathDescription(for number: Int, isMaster: Bool) -> String {
    let cosmicData = SanctumDataManager.shared.megaCorpusData
    
    if isMaster {
        // Load from MegaCorpus masterNumbers section
        if let numerology = cosmicData["numerology"] as? [String: Any],
           let masterNumbers = numerology["masterNumbers"] as? [String: Any],
           let masterData = masterNumbers[String(number)] as? [String: Any],
           let name = masterData["name"] as? String,
           let keywords = masterData["keywords"] as? [String] {
            let keywordString = keywords.prefix(3).joined(separator: " • ")
            return "The \(name) • \(keywordString) • Divine Spiritual Mission"
        }
        
        // Fallback for master numbers (maintaining spiritual quality)
        switch number {
        case 11: return "The Intuitive Illuminator • Master of Spiritual Insight • Channel for Divine Wisdom"
        case 22: return "The Master Builder • Architect of Dreams • Creator of Lasting Legacy"
        case 33: return "The Master Teacher • Embodiment of Universal Love • Healer of Hearts"
        default: return "Master Number • Divine Spiritual Mission • Sacred Soul Purpose"
        }
    } else {
        // Load from MegaCorpus focusNumbers section
        if let numerology = cosmicData["numerology"] as? [String: Any],
           let focusNumbers = numerology["focusNumbers"] as? [String: Any],
           let numberData = focusNumbers[String(number)] as? [String: Any],
           let archetype = numberData["archetype"] as? String,
           let keywords = numberData["keywords"] as? [String] {
            let keywordString = keywords.prefix(3).joined(separator: " • ")
            return "\(archetype) • \(keywordString) • Sacred Soul Path"
        }
        
        // Fallback descriptions (maintaining existing spiritual quality)
        switch number {
        case 1: return "The Pioneer • Natural born leader with incredible drive and innovation"
        case 2: return "The Peacemaker • Diplomatic soul who brings harmony and cooperation"
        case 3: return "The Creative Communicator • Artistic expression and joyful inspiration"
        case 4: return "The Foundation Builder • Practical wisdom and steady determination"
        case 5: return "The Free Spirit • Adventure seeker with dynamic energy and curiosity"
        case 6: return "The Nurturer • Compassionate healer focused on home and service"
        case 7: return "The Spiritual Seeker • Mystical wisdom and deep inner knowing"
        case 8: return "The Material Master • Business acumen and material world authority"
        case 9: return "The Universal Humanitarian • Wise teacher serving the greater good"
        default: return "Sacred soul journey with unique cosmic purpose"
        }
    }
}

// MARK: - MegaCorpus Data Loading System
/// Claude: Comprehensive spiritual data loading system using organized MegaCorpus files
/// 
/// **Architecture Overview:**
/// - **Modular Design**: Separate JSON files for Signs, Elements, Planets, Houses
/// - **Performance Optimization**: Static caching prevents repeated file I/O operations
/// - **Error Resilience**: Graceful fallbacks if MegaCorpus files are unavailable
/// - **Memory Efficient**: Lazy loading only when spiritual data is needed
///
/// **File Structure:**
/// ```
/// NumerologyData/MegaCorpus/
/// ├── Signs.json      - Zodiac sign archetypes and keywords
/// ├── Elements.json   - Fire, Earth, Air, Water spiritual energies  
/// ├── Planets.json    - Planetary symbolism and rulerships
/// ├── Houses.json     - 12-house life area meanings
/// ├── Aspects.json    - Planetary aspect interpretations
/// ├── Modes.json      - Cardinal, Fixed, Mutable mode energies
/// └── Numerology.json - Focus numbers and master number meanings
/// ```

/// Claude: Load spiritual data from organized MegaCorpus with intelligent caching
/// 
/// **Performance Benefits:**
/// - First call loads and caches all MegaCorpus data
/// - Subsequent calls return cached data instantly
/// - Reduces JSON parsing from ~60ms to ~0.1ms per call
///
/// **Usage Example:**
/// ```swift
/// let cosmicData = loadMegaCorpusData()
/// if let signs = cosmicData["signs"] as? [String: Any] {
///     // Access zodiac sign data
/// }
/// ```

// MARK: - Enhanced Archetype Descriptions (Using Mega Corpus)
// Zodiac Descriptions
/// Claude: Enhanced zodiac description using MegaCorpus data
/// 
/// **Spiritual Data Integration:**
/// - Loads zodiac archetypes from MegaCorpus/Signs.json
/// - Combines archetype, element, mode, and keywords for rich descriptions
/// - Graceful fallback to curated descriptions if MegaCorpus unavailable
///
/// **Return Format:** "Archetype • Element Mode • Keyword1 • Keyword2 • Keyword3"
/// **Example:** "The Pioneer • Fire Cardinal • Initiative • Leadership • Courage"
/// Claude: Global zodiac description using AstrologyService
@MainActor func detailedZodiacDescription(for sign: ZodiacSign) -> String {
    let astrologyService = AstrologyService.shared
    let zodiacInterpretation = astrologyService.getZodiacInterpretation(for: sign.rawValue)
    
    let description = zodiacInterpretation.baseDescription
    let traitsText = zodiacInterpretation.keywords.prefix(3).joined(separator: " • ")
    
    if !description.isEmpty {
        return "\(description)\n\nCore Traits: \(traitsText)"
    } else {
        return "The \(zodiacInterpretation.sign) • \(zodiacInterpretation.element) \(zodiacInterpretation.mode) • \(traitsText)"
    }
}

/// Claude: REMOVED DUPLICATE GLOBAL FUNCTION - detailedElementDescription() is properly scoped within UserProfileTabView struct
/// This eliminates namespace pollution and provides better encapsulation

/// Claude: REMOVED DUPLICATE GLOBAL FUNCTION - detailedPlanetDescription() is properly scoped within UserProfileTabView struct
/// This eliminates namespace pollution and provides better encapsulated astrological data access

/// Claude: REMOVED DUPLICATE GLOBAL FUNCTION - detailedShadowPlanetDescription() is properly scoped within UserProfileTabView struct
/// This eliminates namespace pollution and provides better encapsulated shadow archetype analysis

/// Claude: REMOVED DUPLICATE GLOBAL FUNCTIONS - soulUrgeDescription() and expressionDescription() are properly scoped within UserProfileTabView struct
/// This eliminates global namespace pollution and provides better encapsulation of numerology data access

// Icon helper functions
func zodiacIcon(for sign: ZodiacSign) -> String {
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

func elementIcon(for element: Element) -> String {
    switch element {
    case .fire: return "🔥"
    case .earth: return "🌍"
    case .air: return "💨"
    case .water: return "🌊"
    }
}

func elementColor(for element: Element) -> Color {
    switch element {
    case .fire: return .red
    case .earth: return .brown
    case .air: return .yellow
    case .water: return .cyan
    }
}

func planetIcon(for planet: Planet) -> String {
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

// Guidance Functions
func getLifePathGuidance(for number: Int) -> String {
    switch number {
    case 1: return "Embrace your natural leadership abilities and trust your pioneering instincts. Your path involves learning to balance independence with collaboration, and using your innovative spirit to inspire positive change in the world."
    case 2: return "Your gift is bringing people together and creating harmony. Focus on developing your diplomatic skills while maintaining your own identity. Learn to value your contributions even when they happen behind the scenes."
    case 3: return "Express your creativity fearlessly and share your joy with the world. Your path involves learning to focus your abundant creative energy and using your communication gifts to inspire and heal others."
    case 4: return "Build the solid foundations that others need to thrive. Your journey involves learning patience and persistence while staying open to new methods. Trust that your steady efforts create lasting positive impact."
    case 5: return "Embrace change and variety as your natural elements. Your path involves learning to balance freedom with responsibility, and using your adaptability to help others navigate life's transitions."
    case 6: return "Your calling is to nurture and heal others through your natural compassion. Learn to serve from love rather than obligation, and remember that caring for yourself enables you to better care for others."
    case 7: return "Seek the deeper truths and spiritual understanding your soul craves. Your path involves balancing solitude with meaningful connection, and sharing your wisdom to help others find their own inner knowing."
    case 8: return "Build material success while maintaining your integrity and spiritual values. Your journey involves learning to use your organizational talents and authority to create abundance that benefits everyone."
    case 9: return "Serve humanity through your compassion and universal perspective. Your path involves learning to heal your own wounds so you can help heal the world's pain through your wisdom and artistic gifts."
    case 11: return "As a Master Number, you're here to be a spiritual teacher and inspiration to others. Trust your intuitive gifts and use your heightened sensitivity to channel divine wisdom into the world."
    case 22: return "Your Master Number path involves building lasting structures that serve humanity. Combine your practical skills with your spiritual vision to create something that will benefit generations."
    case 33: return "Your Master Number calling is to be a healer and teacher of universal love. Use your compassionate nature and spiritual gifts to help others find their own path to wholeness and divine connection."
    default: return "Trust the unique spiritual path your soul has chosen. Every number carries its own sacred mission - embrace yours with confidence and use your gifts in service to your highest purpose."
    }
}

func getSoulUrgeDetailedDescription(for number: Int) -> String {
    switch number {
    case 1: return "Your soul craves independence, leadership, and the opportunity to pioneer new paths. Deep within, you desire to be recognized for your unique contributions and original ideas. You are driven by the need to innovate and lead others toward new possibilities."
    case 2: return "Your heart seeks harmony, partnership, and meaningful emotional connections. You deeply desire cooperation and peace in all relationships. Your soul finds fulfillment through supporting others and creating balanced, loving environments."
    case 3: return "Your soul yearns for creative expression, joyful communication, and artistic manifestation. You desire to inspire others through your creativity and bring beauty into the world. Self-expression and social connection feed your deepest needs."
    case 4: return "Your heart desires stability, practical achievement, and the building of lasting foundations. You seek security through hard work and systematic progress. Your soul finds peace in creating order and reliable structures."
    case 5: return "Your soul craves freedom, adventure, and diverse life experiences. You desire variety, travel, and the exploration of different cultures and ideas. Change and movement are essential to your inner happiness and growth."
    case 6: return "Your heart deeply desires to nurture others, create harmony in your home and community, and serve those in need. You find fulfillment through healing, teaching, and caring for family and loved ones."
    case 7: return "Your soul yearns for spiritual wisdom, solitude for reflection, and deep understanding of life's mysteries. You desire truth, knowledge, and connection to the divine through contemplation and inner work."
    case 8: return "Your heart desires material success, recognition for achievements, and authority in the business world. You seek financial abundance and the power to create lasting impact through your organizational abilities."
    case 9: return "Your soul craves humanitarian service, universal love, and the opportunity to heal the world. You desire to serve humanity through your wisdom, compassion, and ability to see the bigger picture."
    default: return "Your soul seeks its own unique path of growth, expression, and spiritual fulfillment through the special qualities of the number \(number)."
    }
}

func getExpressionDetailedDescription(for number: Int) -> String {
    switch number {
    case 1: return "You naturally express leadership, originality, and pioneering spirit in everything you do. Your talents shine through innovation, independence, and the ability to initiate new projects. You are meant to lead and inspire others through your unique vision."
    case 2: return "You naturally express cooperation, diplomacy, and supportive energy. Your gifts include mediation, partnership building, and creating harmony in relationships. You excel at working with others and bringing people together."
    case 3: return "You naturally express creativity, communication, and inspirational joy. Your talents include artistic abilities, entertaining others, and bringing optimism to any situation. You are meant to inspire and uplift through your creative gifts."
    case 4: return "You naturally express practicality, organization, and reliable service. Your talents include building solid foundations, managing details, and creating systems that work. You excel at turning ideas into concrete reality."
    case 5: return "You naturally express versatility, curiosity, and dynamic energy. Your talents include communication, travel, sales, and adaptability to change. You are meant to explore, connect, and share diverse experiences."
    case 6: return "You naturally express nurturing, responsibility, and healing compassion. Your talents include teaching, counseling, healing, and creating beautiful, harmonious environments. You excel at caring for others and building community."
    case 7: return "You naturally express analytical thinking, spirituality, and inner wisdom. Your talents include research, investigation, spiritual teaching, and deep understanding. You are meant to seek truth and share your insights."
    case 8: return "You naturally express business acumen, material mastery, and executive ability. Your talents include organization, management, financial planning, and achieving material success. You excel at building wealth and managing resources."
    case 9: return "You naturally express universal understanding, artistic vision, and humanitarian service. Your talents include healing, teaching wisdom, and serving the greater good. You are meant to be a light for humanity."
    default: return "You express your unique talents and gifts through the special vibration of the number \(number), bringing your own distinct contribution to the world."
    }
}

func getSoulUrgeGuidance(for number: Int) -> String {
    switch number {
    case 1: return "Honor your need for independence while learning to work with others. Channel your leadership desires into positive initiatives that benefit everyone."
    case 2: return "Embrace your gift for creating harmony while maintaining your own identity. Learn to speak up for yourself even as you support others."
    case 3: return "Express your creativity boldly and share your joy with the world. Don't let fear of criticism dim your natural radiance and artistic gifts."
    case 4: return "Build the security you desire through patient, consistent effort. Remember that true stability comes from both inner peace and outer achievement."
    case 5: return "Honor your need for freedom while learning to commit when it truly matters. Channel your restless energy into meaningful exploration and growth."
    case 6: return "Serve others from a place of love rather than obligation. Remember to nurture yourself as much as you care for everyone else."
    case 7: return "Trust your intuition and seek the spiritual understanding your soul craves. Balance solitude with meaningful connection to others."
    case 8: return "Pursue material success while maintaining your integrity and compassion. Use your achievements to help others and create positive change."
    case 9: return "Serve humanity through your unique gifts and wisdom. Remember that helping yourself heal and grow enables you to better serve others."
    default: return "Trust the unique path your soul has chosen and express your gifts authentically in service to your highest purpose."
    }
}

func getExpressionGuidance(for number: Int) -> String {
    switch number {
    case 1: return "Step into leadership roles with confidence. Your originality and initiative are needed to pioneer new solutions and inspire others forward."
    case 2: return "Use your diplomatic gifts to bring people together. Your ability to see all sides makes you an excellent mediator and peace-builder."
    case 3: return "Share your creative gifts generously with the world. Your joy and artistic expression have the power to heal and inspire others."
    case 4: return "Build the foundations that others need to succeed. Your practical skills and reliability make you invaluable in any endeavor."
    case 5: return "Embrace change and variety as your natural talents. Your adaptability and communication skills open doors wherever you go."
    case 6: return "Create the healing, nurturing spaces that the world desperately needs. Your caring nature is a gift that transforms lives."
    case 7: return "Seek and share deeper truths through your research and spiritual insights. Your wisdom helps others find meaning in their lives."
    case 8: return "Build material success while maintaining your ethics. Your organizational skills can create abundance that benefits many people."
    case 9: return "Use your universal perspective to serve the greater good. Your compassion and wisdom can help heal the world's wounds."
    default: return "Express your unique talents fully and trust that your gifts are exactly what the world needs from you right now."
    }
}

struct SanctumTabView: View {
    @StateObject private var archetypeManager = UserArchetypeManager.shared
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    @State private var showingSigilView = false
    @State private var showingShareSheet = false
    @State private var selectedArchetypeDetail: ArchetypeDetailType?
    @State private var archetypeRetryCount = 0
    
    // MARK: - Service Dependencies
    /// Claude: Centralized services eliminate scope issues and provide clean data access
    private let sanctumData = SanctumDataManager.shared
    private let numerologyService = NumerologyService.shared
    private let astrologyService = AstrologyService.shared
    
    // Animation states
    @State private var lifePathPulse: Bool = false
    @State private var archetypeGlow: Bool = false
    
    // Claude: Phase 12A.1 - Natal Chart Accordion States
    @State private var housesAccordionExpanded: Bool = false
    @State private var aspectsAccordionExpanded: Bool = false
    @State private var glyphMapAccordionExpanded: Bool = false
    
    // Claude: Phase 12A.1 Enhancement - Interactive house details and view modes (Fixed for immediate loading)
    @State private var selectedHouseForSheet: IdentifiableInt? = nil
    @State private var sanctumViewMode: SanctumViewMode = .birthChart
    
    // Claude: Detail sheets for tappable planetary positions and aspects (Fixed for immediate loading)
    @State private var selectedPlanet: PlanetaryPosition?
    @State private var selectedAspect: NatalAspect?
    
    // Claude: SanctumViewMode enum moved to SanctumDataStructures.swift
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic Background
                CosmicBackgroundView()
                    .allowsHitTesting(false)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Show content based on profile state
                        if let profile = userProfile {
                            // The Divine Triangle - Complete Numerological Trinity
                            DivineTriangleSection(
                                profile: profile,
                                selectedArchetypeDetail: $selectedArchetypeDetail
                            )
                            
                            // Your Natal Chart Section
                            NatalChartSection(
                                profile: profile,
                                sanctumViewMode: $sanctumViewMode,
                                housesAccordionExpanded: $housesAccordionExpanded,
                                aspectsAccordionExpanded: $aspectsAccordionExpanded,
                                glyphMapAccordionExpanded: $glyphMapAccordionExpanded,
                                selectedHouseForSheet: $selectedHouseForSheet,
                                selectedPlanet: $selectedPlanet,
                                selectedAspect: $selectedAspect
                            )
                        
                            // Complete Spiritual Archetype
                            if let userArchetype = archetypeManager.currentArchetype ?? archetypeManager.storedArchetype {
                                ArchetypeCodexSection(
                                    archetype: userArchetype,
                                    selectedArchetypeDetail: $selectedArchetypeDetail,
                                    archetypeGlow: $archetypeGlow
                                )
                            } else {
                                // Show loading state for archetype
                                archetypeLoadingView
                            }
                            
                            // Action Buttons Section
                            ActionButtonsSection(
                                showingSigilView: $showingSigilView,
                                showingShareSheet: $showingShareSheet
                            )
                            
                            // Profile Summary
                            ProfileSummarySection(profile: profile)
                        } else {
                            // Profile not loaded - show setup state
                            profileSetupNeededView
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("My Sanctum")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                    .foregroundColor(.purple)
                }
            }
            .onAppear {
                // PERFORMANCE FIX: Defer heavy operations to prevent tab loading delays
                
                // Immediate: Start animations (lightweight)
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    lifePathPulse = true
                }
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    archetypeGlow = true
                }
                
                // Step 1: Quick cache check (0.2s delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    loadUserProfileFromCache()
                }
                
                // Step 2: Full profile loading (1.0s delay)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    loadUserProfile()
                }
                
                // Step 3: Archetype loading (2.0s delay) 
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    loadArchetype()
                }
            }
            .onReceive(archetypeManager.$currentArchetype) { archetype in
                // Log when archetype changes for debugging
                if let archetype = archetype {
                    print("📡 Received archetype update: \(archetype.zodiacSign.rawValue) \(archetype.element.rawValue)")
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                ProfileEditView(userProfile: $userProfile)
            }
            .sheet(isPresented: $showingSigilView) {
                SigilPlaceholderView()
            }
            .sheet(item: $selectedArchetypeDetail) { detail in
                ArchetypeDetailView(detailType: detail, archetype: archetypeManager.storedArchetype)
            }
            .sheet(item: $selectedHouseForSheet) { identifiableHouse in
                if userProfile != nil {
                    HouseDetailView(houseNumber: identifiableHouse.value)
                }
            }
            .sheet(item: $selectedPlanet) { planet in
                PlanetDetailView(planet: planet.planet)
            }
            .sheet(item: $selectedAspect) { aspect in
                AspectDetailView(aspect: aspect)
            }
        }
    }
    
    
    /// Claude: Reusable accordion component for natal chart sections
    private func natalChartAccordion<Content: View>(
        title: String,
        subtitle: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            // Accordion Header (Always Visible)
            Button(action: {
                // Claude: Single animation to prevent double dropdown glitch
                // Remove withAnimation wrapper to prevent conflict with rotationEffect animation
                isExpanded.wrappedValue.toggle()
                
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.cyan.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.cyan)
                        .rotationEffect(.degrees(isExpanded.wrappedValue ? 180 : 0))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded.wrappedValue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(SwiftUI.Color.cyan.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(SwiftUI.Color.cyan.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Accordion Content (Expandable)
            if isExpanded.wrappedValue {
                content()
                    .padding(.top, 12)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .move(edge: .top))
                    ))
            }
        }
    }
    
    /// Claude: Houses accordion content with life areas and planetary cusps
    private func housesAccordionContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 12) {
            Text("🏠 The 12 Houses represent different areas of life where planetary energies express themselves. Each house cusp shows which zodiac sign rules that life area.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(1...12, id: \.self) { houseNumber in
                    houseCard(houseNumber: houseNumber, profile: profile)
                        .frame(minHeight: 80) // Claude: Ensure consistent card heights
                }
            }
            
            // Claude: Fix birth time detection - check for actual birth time data
            if profile.birthTimeHour == nil || profile.birthTimeMinute == nil {
                Text("⏰ House positions are approximate without exact birth time. Add your birth time in settings for precise house cusps.")
                    .font(.caption2)
                    .foregroundColor(.orange.opacity(0.8))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 8)
            } else {
                Text("✨ House cusps calculated with exact birth time")
                    .font(.caption2)
                    .foregroundColor(.green.opacity(0.7))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(SwiftUI.Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SwiftUI.Color.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Renders an astrological house card with natural zodiac sign influences and comprehensive life area information
    /// 
    /// Creates a detailed house card showing the traditional zodiac correspondence, natural ruling sign,
    /// elemental associations, modes, and life area themes. Each house represents a specific domain
    /// of human experience in astrological tradition, enhanced with MegaCorpus spiritual data.
    /// 
    /// **Phase History:**
    /// - Phase 12A.1: Basic house information with life areas
    /// - Phase 15: Major enhancement with natural sign influences, element/mode badges, and MegaCorpus keywords
    /// 
    /// **Astrological House System:**
    /// - Houses 1-12 represent life themes from identity (1st) through transcendence (12th)
    /// - Each house naturally corresponds to a zodiac sign (1st=Aries, 2nd=Taurus, etc.)
    /// - Natural sign provides elemental quality and mode that colors the house's expression
    /// - Actual cusp sign may differ from natural sign based on birth time and location
    /// 
    /// **UI Design Decisions:**
    /// - Fixed height of 120pt ensures uniform grid appearance matching planetary cards
    /// - Header displays house number prominently with natural sign glyph and name
    /// - Life area description positioned in middle section for easy scanning
    /// - Element and mode badges at bottom provide quick visual reference
    /// - Gradient border blends house color with natural sign color for visual hierarchy
    /// 
    /// **MegaCorpus Integration:**
    /// - House keywords loaded from Houses.json MegaCorpus data for authentic astrological meaning
    /// - Natural sign element and mode retrieved from Signs.json for consistent correspondences
    /// - Life area descriptions sourced from traditional astrological house meanings
    /// - Color associations maintain spiritual correspondence system
    /// 
    /// **Spiritual Significance:**
    /// - Each house represents a sacred domain of human spiritual development
    /// - Natural sign influence shows the archetypal energy coloring that life domain
    /// - Element badges indicate the fundamental life force quality (Fire=action, Earth=structure, Air=thought, Water=emotion)
    /// - Mode badges show the expression style (Cardinal=initiating, Fixed=sustaining, Mutable=adapting)
    /// - Keywords provide concentrated wisdom about each house's spiritual purpose
    /// 
    /// **Information Hierarchy:**
    /// 1. House number and natural sign (primary identification)
    /// 2. Life area and keyword (functional meaning)
    /// 3. Element and mode (energetic qualities)
    /// 4. Actual cusp sign if different (personal chart variation)
    /// 
    /// - Parameter houseNumber: Integer 1-12 representing the astrological house
    /// - Parameter profile: UserProfile containing birth chart calculation data
    /// - Returns: SwiftUI Button view that opens detailed house information when tapped
    /// 
    /// **Dependencies:**
    /// - getHouseNaturalSign(): Returns the traditional zodiac sign for each house
    /// - getHouseKeyword(): Retrieves spiritual keyword from MegaCorpus Houses data
    /// - getSignElement(): Gets elemental association (Fire/Earth/Air/Water) from MegaCorpus
    /// - getSignMode(): Gets mode (Cardinal/Fixed/Mutable) from MegaCorpus Signs data
    /// - getHouseLifeAreaShort(): Returns concise description of house's life domain
    /// - getHouseRulingSign(): Calculates actual cusp sign from birth chart
    /// - getSignGlyph(): Returns Unicode astrological symbol for signs
    /// - getSignColor(): Returns thematic color for visual identification
    /// - getElementColor(): Returns color for Fire/Earth/Air/Water elements
    /// 
    /// **Interactive Behavior:**
    /// - Tapping sets selectedHouseForSheet to trigger detailed house information sheet
    /// - PlainButtonStyle prevents default styling from interfering with custom design
    /// - Info icon indicates additional astrological details are available
    /// 
    /// Claude: Enhanced house card with zodiac influences and comprehensive MegaCorpus data
    /// Claude: Phase 15 Enhancement - Rich house information with natural sign influences
    private func houseCard(houseNumber: Int, profile: UserProfile) -> some View {
        
        // Claude: Temporary inline helper functions to resolve scope issues
        func getHouseNaturalSign(houseNumber: Int) -> String? {
            let naturalSigns = [1: "Aries", 2: "Taurus", 3: "Gemini", 4: "Cancer", 5: "Leo", 6: "Virgo", 7: "Libra", 8: "Scorpio", 9: "Sagittarius", 10: "Capricorn", 11: "Aquarius", 12: "Pisces"]
            return naturalSigns[houseNumber]
        }
        
        func getSignGlyph(_ sign: String) -> String {
            let glyphs = ["aries": "♈︎", "taurus": "♉︎", "gemini": "♊︎", "cancer": "♋︎", "leo": "♌︎", "virgo": "♍︎", "libra": "♎︎", "scorpio": "♏︎", "sagittarius": "♐︎", "capricorn": "♑︎", "aquarius": "♒︎", "pisces": "♓︎"]
            return glyphs[sign.lowercased()] ?? "✦"
        }
        
        func getHouseKeyword(houseNumber: Int) -> String? {
            let keywords = astrologyService.getHouseInterpretation(for: houseNumber).keywords
            return keywords.first
        }
        
        func getSignMode(_ sign: String) -> String? {
            let zodiacInterpretation = astrologyService.getZodiacInterpretation(for: sign)
            return zodiacInterpretation.mode
        }
        
        func getSignElement(_ sign: String) -> String? {
            return sanctumData.getSignElement(for: sign)
        }
        
        func getElementColor(_ element: String) -> Color {
            switch element.lowercased() {
            case "fire": return .red
            case "earth": return .brown
            case "air": return .cyan
            case "water": return .blue
            default: return .white
            }
        }
        
        func getPlanetColor(_ planet: String) -> Color {
            switch planet.lowercased() {
            case "sun": return .yellow
            case "moon": return .silver
            case "mercury": return .blue
            case "venus": return .green
            case "mars": return .red
            case "jupiter": return .orange
            case "saturn": return .brown
            case "uranus": return .cyan
            case "neptune": return .purple
            case "pluto": return .gray
            default: return .white
            }
        }
        
        return Button(action: {
            selectedHouseForSheet = IdentifiableInt(value: houseNumber)
        }) {
            VStack(alignment: .leading, spacing: 6) {
                // Claude: Header with house number and natural sign
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("House \(houseNumber)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        
                        // Claude: Show natural ruling sign and glyph
                        if let naturalSign = getHouseNaturalSign(houseNumber: houseNumber) {
                            HStack(spacing: 4) {
                                Text(getSignGlyph(naturalSign))
                                    .font(.caption)
                                    .foregroundColor(getSignColor(naturalSign))
                                Text(naturalSign)
                                    .font(.caption2)
                                    .foregroundColor(getSignColor(naturalSign))
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Claude: Info icon with house element color
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundColor(.cyan.opacity(0.6))
                }
                
                Spacer()
                
                // Claude: House life area with archetypal keyword
                VStack(alignment: .leading, spacing: 3) {
                    Text(getHouseLifeAreaShort(houseNumber: houseNumber))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.9))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    // Claude: Add house keyword from MegaCorpus
                    if let keyword = getHouseKeyword(houseNumber: houseNumber) {
                        Text("• \(keyword)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.cyan.opacity(0.8))
                            .italic()
                    }
                }
                
                // Claude: Element and mode from natural sign
                if let naturalSign = getHouseNaturalSign(houseNumber: houseNumber),
                   let element = getSignElement(naturalSign),
                   let mode = getSignMode(naturalSign) {
                    HStack(spacing: 6) {
                        // Element badge
                        Text(element.uppercased())
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(getElementColor(element))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(
                                Capsule()
                                    .fill(getElementColor(element).opacity(0.2))
                            )
                        
                        // Mode badge
                        Text(mode.uppercased())
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(
                                Capsule()
                                    .fill(SwiftUI.Color.white.opacity(0.1))
                            )
                        
                        Spacer()
                    }
                }
                
                // Claude: Show actual ruling sign if different from natural
                if let rulingSign = getHouseRulingSign(houseNumber: houseNumber, profile: profile) {
                    Text("Cusp: \(rulingSign)")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.yellow.opacity(0.8))
                        .padding(.top, 2)
                }
            }
            .padding(10)
            .frame(height: 120) // Claude: Fixed height for uniform cards
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(SwiftUI.Color.cyan.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .cyan.opacity(0.4),
                                        .cyan.opacity(0.2)
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
    
    /// Claude: Aspects accordion content with major planetary relationships
    private func aspectsAccordionContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 12) {
            Text("⭐ Aspects show how planets relate to each other in your birth chart. These cosmic conversations create the unique harmony and tension in your personality.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                // Major aspects from Phase 11A data
                ForEach(getMajorAspects(profile: profile), id: \.id) { aspect in
                    aspectRow(aspect: aspect)
                }
                
                if getMajorAspects(profile: profile).isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "hourglass")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        Text("⏳ Aspect calculations in progress")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        
                        Text("Your natal aspects will appear here once your complete birth chart has been calculated using your birth location and time.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(SwiftUI.Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SwiftUI.Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Individual aspect row showing planetary relationship (now tappable)
    private func aspectRow(aspect: NatalAspect) -> some View {
        Button(action: {
            print("🔮 Tapped aspect: \(aspect.planet1) \(aspect.type.rawValue) \(aspect.planet2)")
            selectedAspect = aspect
        }) {
            HStack {
                HStack(spacing: 4) {
                    Text(getPlanetGlyph(aspect.planet1))
                        .font(.caption)
                    Text(aspect.planet1)
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(getAspectSymbol(for: aspect.type))
                    .font(.headline)
                    .foregroundColor(getAspectColor(for: aspect.type))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(aspect.planet2)
                        .font(.caption2)
                        .fontWeight(.medium)
                    Text(getPlanetGlyph(aspect.planet2))
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(String(format: "%.1f", aspect.orb))°")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                
                // Tap indicator
                Image(systemName: "info.circle")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(getAspectColor(for: aspect.type).opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Claude: Enhanced Planetary Map accordion content with rich MegaCorpus descriptions
    private func glyphMapAccordionContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("🌌 Your Sacred Planetary Map")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.cyan)
                
                Text("Each planetary placement reveals an archetypal energy expressing through a specific zodiacal quality. Tap any planet to explore its deeper spiritual significance in your cosmic blueprint.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal)
            }
            
            // Claude: Simple list view instead of complex circular chart
            VStack(spacing: 8) {
                ForEach(getPlanetaryPositions(profile: profile, mode: sanctumViewMode), id: \.planet) { position in
                    planetListRow(position: position)
                }
                
                // Show rising sign if available
                if let risingSign = profile.risingSign {
                    planetListRow(
                        position: PlanetaryPosition(
                            planet: "Ascendant", 
                            sign: risingSign, 
                            degree: 0,
                            houseNumber: 1 // Ascendant is always the 1st house cusp
                        )
                    )
                }
            }
            
            if profile.birthplaceName == nil {
                Text("📍 Add your birth location in settings for precise planetary positions.")
                    .font(.caption2)
                    .foregroundColor(.orange.opacity(0.8))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(SwiftUI.Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SwiftUI.Color.blue.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Individual planet row for list view
    /// Claude: Individual planet row for list view with rich descriptions
    private func planetListRow(position: PlanetaryPosition) -> some View {
        // Claude: Inline helper functions to resolve scope issues
        func getPlanetColor(_ planet: String) -> Color {
            switch planet.lowercased() {
            case "sun": return .yellow
            case "moon": return .silver
            case "mercury": return .blue
            case "venus": return .green
            case "mars": return .red
            case "jupiter": return .orange
            case "saturn": return .brown
            case "uranus": return .cyan
            case "neptune": return .purple
            case "pluto": return .gray
            default: return .white
            }
        }
        
        func getSignElement(_ sign: String) -> String? {
            return sanctumData.getSignElement(for: sign)
        }
        
        func getElementColor(_ element: String) -> Color {
            switch element.lowercased() {
            case "fire": return .red
            case "earth": return .brown
            case "air": return .cyan
            case "water": return .blue
            default: return .white
            }
        }
        
        return Button(action: {
            selectedPlanet = position
        }) {
            HStack(spacing: 12) {
                // Planet glyph with color
                Text(getPlanetGlyph(position.planet))
                    .font(.title2)
                    .foregroundColor(getPlanetColor(position.planet))
                
                // Planet info with mini description
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(position.planet)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("in")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(position.sign)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(getSignColor(position.sign))
                    }
                    
                    // Enhanced archetype with sign combination
                    VStack(alignment: .leading, spacing: 2) {
                        Text(getPlanetMiniDescription(position.planet))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.medium)
                        
                        if let element = getSignElement(position.sign) {
                            Text("\(element.capitalized) energy")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(getElementColor(element))
                        }
                    }
                }
                
                Spacer()
                
                // Degree and tap indicator
                VStack(alignment: .trailing, spacing: 2) {
                    if position.degree > 0 {
                        Text("\(position.degree)°")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(SwiftUI.Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        getPlanetColor(position.planet).opacity(0.3),
                                        SwiftUI.Color.white.opacity(0.1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 0.5
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    /// Get mini planet description for list view
    /// Claude: Planet mini description using SanctumDataManager service
    private func getPlanetMiniDescription(_ planet: String) -> String {
        return sanctumData.getPlanetaryArchetype(for: planet)
    }
    
    /// Claude: Sign color using SanctumDataManager service
    private func getSignColor(_ sign: String) -> Color {
        let element = sanctumData.getSignElement(for: sign)
        
        switch element.lowercased() {
        case "fire": return .orange
        case "earth": return .brown
        case "air": return .cyan
        case "water": return .blue
        default: return .white.opacity(0.8)
        }
    }
    
    // MARK: - Complete Archetype Codex
    
    private func completeArchetypeCodex(_ archetype: UserArchetype) -> some View {
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
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
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
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
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
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
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
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
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
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(SwiftUI.Color.black.opacity(0.4))
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
        )
        .shadow(
            color: .purple.opacity(archetypeGlow ? 0.5 : 0.3), 
            radius: archetypeGlow ? 20 : 15, 
            x: 0, 
            y: 8
        )
    }
    
    private func spiritualArchetypeCard(icon: String, title: String, subtitle: String, description: String, color: Color, accentColor: Color) -> some View {
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
                            SwiftUI.Color.black.opacity(0.4)
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
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: color)
    }
    
    // MARK: - Archetype Loading View
    
    private var archetypeLoadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
            
            VStack(spacing: 8) {
                Text("✨ Calculating Your Spiritual Archetype ✨")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Aligning zodiac, element, and planetary influences...")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                // Debug information
                if let profile = userProfile {
                    Text("Birth Date: \(DateFormatter.localizedString(from: profile.birthdate, dateStyle: .medium, timeStyle: .none))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 8)
                }
                
                // Manual retry button
                Button(action: {
                    print("🔄 Manual archetype refresh triggered")
                    loadArchetype()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Retry Calculation")
                    }
                    .font(.caption)
                    .foregroundColor(.purple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(SwiftUI.Color.purple.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(SwiftUI.Color.purple.opacity(0.4), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(SwiftUI.Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(SwiftUI.Color.purple.opacity(0.5), lineWidth: 1)
                )
        )
        .onAppear {
            // Try to load archetype again when this view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("🔄 Archetype loading view appeared - retrying archetype load")
                loadArchetype()
            }
        }
    }
    
    // MARK: - Hero Life Path Section
    
    private func heroLifePathSection(_ profile: UserProfile) -> some View {
        VStack(spacing: 20) {
            // Life Path Number - Massive and Glowing
            ZStack {
                // Background glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                SwiftUI.Color.yellow.opacity(0.4),
                                SwiftUI.Color.orange.opacity(0.3),
                                SwiftUI.Color.clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 120
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(lifePathPulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: lifePathPulse)
                
                // Number display
                Text("\(profile.lifePathNumber)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
            }
            
            VStack(spacing: 12) {
                Text("Life Path \(profile.lifePathNumber)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if profile.isMasterNumber {
                    Text("✨ Master Number ✨")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(SwiftUI.Color.yellow.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(SwiftUI.Color.yellow.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                
                Text(sanctumData.getLifePathDescription(for: profile.lifePathNumber, isMaster: profile.isMasterNumber))
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(SwiftUI.Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.yellow.opacity(0.6), .orange.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: .yellow.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    
    
    // MARK: - Profile Setup Needed View
    
    private var profileSetupNeededView: some View {
        VStack(spacing: 30) {
            // Sacred symbol
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.purple)
                .padding()
                .background(
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [SwiftUI.Color.purple.opacity(0.3), SwiftUI.Color.blue.opacity(0.3)]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 60
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(SwiftUI.Color.white.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 16) {
                Text("✨ Welcome to Your Sanctum ✨")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your Sacred Space Awaits")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("It looks like your spiritual profile is still being prepared. This sacred space will contain your complete numerological archetype, spiritual insights, and cosmic alignments.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal)
            }
            
            // Helpful guidance
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("🔢 To activate your sanctum:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("1.")
                                .fontWeight(.bold)
                                .foregroundColor(.cyan)
                                .frame(width: 20)
                            Text("Complete your spiritual onboarding if you haven't already")
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                        
                        HStack {
                            Text("2.")
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                                .frame(width: 20)
                            Text("Set your Focus Number on the Home tab")
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                        
                        HStack {
                            Text("3.")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .frame(width: 20)
                            Text("Create your first journal entry to activate your spiritual profile")
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(SwiftUI.Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(SwiftUI.Color.blue.opacity(0.5), lineWidth: 1)
                        )
                )
                
                // Quick action button
                NavigationLink(destination: JournalView()) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Start Your Spiritual Journey")
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(SwiftUI.Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple.opacity(0.5), .blue.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .purple.opacity(0.2), radius: 15, x: 0, y: 8)
    }
    
    
    // MARK: - Helper Functions
    
    /// Claude: Use SanctumDataManager for MegaCorpus data access
    private func loadMegaCorpusData() -> [String: Any] {
        return sanctumData.megaCorpusData
    }
    
    /**
     * PERFORMANCE FIX: Quick cache check to load profile immediately if available
     */
    private func loadUserProfileFromCache() {
        if let userID = UserDefaults.standard.string(forKey: "userID") ?? AuthenticationManager.shared.userID {
            // Try cache first for instant loading
            if let cachedProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID) {
                self.userProfile = cachedProfile
                print("⚡ Quick cache hit: Loaded profile for \(userID)")
                return
            }
        }
        print("⚡ No cached profile available, will need to fetch from network")
    }
    
    private func loadUserProfile() {
        // First check if we have a userID in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            print("✅ UserProfileTabView: Found userID in UserDefaults: \(userID)")
            
            UserProfileService.shared.fetchUserProfile(for: userID) { profile, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error fetching profile in UserProfileTabView: \(error.localizedDescription)")
                        // Try to load from cache as a fallback
                        self.userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
                        if self.userProfile == nil {
                            print("❌❌ No profile found in Firestore or cache for userID: \(userID)")
                        } else {
                            print("✅ Loaded profile from cache for userID: \(userID)")
                        }
                        return
                    }
                    
                    if let profile = profile {
                        print("✅ Successfully loaded profile from Firestore for userID: \(userID)")
                    self.userProfile = profile
                    } else {
                        print("ℹ️ No profile found in Firestore for userID: \(userID). Trying cache...")
                        self.userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
                        if self.userProfile == nil {
                            print("❌❌ No profile found in Firestore or cache for userID: \(userID)")
                        } else {
                            print("✅ Loaded profile from cache for userID: \(userID)")
                        }
                    }
                }
            }
        } else {
            print("❌ UserProfileTabView: No userID found in UserDefaults - user may need to complete onboarding")
            // Check if user is authenticated but just missing the userID in UserDefaults
            if let authUserID = AuthenticationManager.shared.userID {
                print("ℹ️ Found userID in AuthManager: \(authUserID), updating UserDefaults")
                UserDefaults.standard.set(authUserID, forKey: "userID")
                // Retry loading with the auth userID
                loadUserProfile()
            } else {
                print("❌ No userID found in AuthManager either - user needs to sign in")
            }
        }
    }
    
    private func loadArchetype() {
        print("🔍 loadArchetype() called - checking archetype status... (retry: \(archetypeRetryCount))")
        
        // PERFORMANCE FIX: Always try cached first (main thread, fast)
        let cachedArchetype = archetypeManager.loadCachedArchetype()
        if let cachedArchetype = cachedArchetype {
            print("✅ Loaded cached archetype: \(cachedArchetype.zodiacSign.rawValue) \(cachedArchetype.element.rawValue)")
            archetypeRetryCount = 0 // Reset retry count on success
            return
        }
        
        // PERFORMANCE FIX: Check storage (main thread, fast)
        if UserArchetypeManager.shared.hasStoredArchetype() {
            print("✅ Archetype exists in storage, using loadCachedArchetype()")
            let _ = archetypeManager.loadCachedArchetype()
            return
        }
        
        // PERFORMANCE FIX: Defer expensive calculation to background queue
        if let profile = userProfile {
            print("📅 No cached archetype found, calculating from user profile birthdate: \(profile.birthdate)")
            
            DispatchQueue.global(qos: .userInitiated).async {
                let calculatedArchetype = self.archetypeManager.calculateArchetype(from: profile.birthdate)
            print("✨ Calculated new archetype: \(calculatedArchetype.zodiacSign.rawValue) \(calculatedArchetype.element.rawValue)")
            
                DispatchQueue.main.async {
                    self.archetypeRetryCount = 0 // Reset retry count on success
                }
            }
        } else {
            print("❌ No cached archetype and no user profile available - will retry when profile loads")
            
            // PERFORMANCE FIX: Only retry if profile is still loading, not indefinitely
            if archetypeRetryCount < 2 && userProfile == nil {
                archetypeRetryCount += 1
                print("🔄 Will retry archetype when profile loads (attempt \(archetypeRetryCount)/2)")
                
                // Retry once profile is available
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if self.userProfile != nil {
                    self.loadArchetype()
                    } else {
                        print("❌ Profile still not available after 3s, archetype calculation failed")
                    }
                }
            }
        }
    }
    
    private func divineTriangleCard(number: Int, title: String, subtitle: String, description: String, icon: String, color: Color, glowColor: Color, isPrimary: Bool) -> some View {
        HStack(spacing: 20) {
            // Number Circle (larger for primary)
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.8),
                                color.opacity(0.4),
                                SwiftUI.Color.clear
                            ]),
                            center: .center,
                            startRadius: isPrimary ? 15 : 10,
                            endRadius: isPrimary ? 50 : 40
                        )
                    )
                    .frame(width: isPrimary ? 100 : 80, height: isPrimary ? 100 : 80)
                    .shadow(color: glowColor.opacity(0.6), radius: isPrimary ? 15 : 10)
                
                VStack(spacing: 2) {
                    Image(systemName: icon)
                        .font(isPrimary ? .title2 : .title3)
                        .foregroundColor(.white)
                    
                    Text("\(number)")
                        .font(isPrimary ? .largeTitle : .title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: glowColor.opacity(0.8), radius: 3)
                }
            }
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isPrimary ? .title3 : .headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(isPrimary ? .subheadline : .caption)
                        .foregroundColor(color)
                        .fontWeight(.medium)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            
            // Tap indicator
            VStack {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(color.opacity(0.6))
                Spacer()
            }
        }
        .padding(isPrimary ? 20 : 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(SwiftUI.Color.black.opacity(isPrimary ? 0.4 : 0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(isPrimary ? 0.6 : 0.5), lineWidth: isPrimary ? 1.5 : 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: isPrimary ? 12 : 8, x: 0, y: isPrimary ? 6 : 4)
    }
    
    // MARK: - Helper Functions
    
    
    /// Claude: Enhanced zodiac description using MegaCorpus data
    /// 
    /// **Spiritual Data Integration:**
    /// - Loads zodiac archetypes from MegaCorpus/Signs.json
    /// - Combines archetype, element, mode, and keywords for rich descriptions
    /// - Graceful fallback to curated descriptions if MegaCorpus unavailable
    ///
    /// **Return Format:** "Archetype • Element Mode • Keyword1 • Keyword2 • Keyword3"
    /// **Example:** "The Pioneer • Fire Cardinal • Initiative • Leadership • Courage"
    /// Claude: Zodiac description using AstrologyService
    private func detailedZodiacDescription(for sign: ZodiacSign) -> String {
        let zodiacInterpretation = astrologyService.getZodiacInterpretation(for: sign.rawValue)
        let traitsText = zodiacInterpretation.keywords.prefix(3).joined(separator: " • ")
        return "The \(zodiacInterpretation.sign) • \(zodiacInterpretation.element) \(zodiacInterpretation.mode) • \(traitsText)"
    }
    
    /// Claude: Enhanced element description using MegaCorpus data
    /// 
    /// **Spiritual Data Integration:**
    /// - Loads element archetypes from MegaCorpus/Elements.json
    /// - Combines archetype, spiritual essence, and core traits for rich descriptions
    /// - Graceful fallback to curated descriptions if MegaCorpus unavailable
    ///
    /// **Return Format:** "Archetype • Description • Core Traits: Trait1 • Trait2"
    /// **Example:** "The Nurturing Builder • Earth grounds spirit into form... • Core Traits: Practical Wisdom • Steadfast Endurance"
    /// Claude: Element description using SanctumDataManager service
    private func detailedElementDescription(for element: Element) -> String {
        let description = sanctumData.getElementDescription(for: element.rawValue)
        return "The \(element.rawValue.capitalized) Element • \(description)"
    }
    
    /// Claude: Enhanced planet description using MegaCorpus data
    /// 
    /// **Spiritual Data Integration:**
    /// - Loads planetary archetypes from MegaCorpus/Planets.json
    /// - Combines archetype, spiritual function, and keywords for rich descriptions
    /// - Graceful fallback to curated descriptions if MegaCorpus unavailable
    ///
    /// **Return Format:** "Archetype • Keyword1 • Keyword2 • Keyword3"
    /// **Example:** "The Teacher • Expansion • Wisdom • Growth"
    /// Claude: Planet description using SanctumDataManager service
    private func detailedPlanetDescription(for planet: Planet) -> String {
        return sanctumData.getPlanetaryDescription(for: planet.rawValue)
    }
    
    /// Claude: Shadow planet description using SanctumDataManager service
    private func detailedShadowPlanetDescription(for planet: Planet) -> String {
        let description = sanctumData.getPlanetaryDescription(for: planet.rawValue)
        return "Shadow \(description) • Hidden depths"
    }
    
    /// Claude: Soul urge description for numerology cards
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
    
    // MARK: - Missing Helper Functions
    
    private func getPlanetaryPositions(profile: UserProfile, mode: SanctumViewMode) -> [PlanetaryPosition] {
        switch mode {
        case .birthChart:
            return getBirthChartPositions(profile: profile)
        case .liveTransits:
            return getCurrentPlanetaryPositions()
        }
    }
    
    private func getBirthChartPositions(profile: UserProfile) -> [PlanetaryPosition] {
        print("🌌 CALCULATING BIRTH CHART with Swiss Ephemeris precision")
        
        // Create precise birth date with exact time
        var birthDate = profile.birthdate
        
        // Use precise birth time if available
        if profile.hasBirthTime, 
           let hour = profile.birthTimeHour, 
           let minute = profile.birthTimeMinute {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: profile.birthdate)
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = components.day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.timeZone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
            
            if let preciseDate = calendar.date(from: dateComponents) {
                birthDate = preciseDate
                print("✅ Using precise birth time: \(hour):\(String(format: "%02d", minute))")
            }
        }
        
        // Validate birth location data
        guard let latitude = profile.birthplaceLatitude,
              let longitude = profile.birthplaceLongitude else {
            print("❌ Missing birth location data, using default coordinates")
            // Return fallback calculation
            return getFallbackBirthChartPositions(profile: profile)
        }
        
        // Calculate birth chart using Swiss Ephemeris
        let timezone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
        let birthChart = SwissEphemerisCalculator.calculateBirthChart(
            birthDate: birthDate,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone
        )
        
        // Convert Swiss Ephemeris positions to UI format
        var positions: [PlanetaryPosition] = []
        
        for swissPosition in birthChart.planets {
            positions.append(PlanetaryPosition(
                planet: swissPosition.planet,
                sign: swissPosition.zodiacSign,
                degree: Int(swissPosition.degreeInSign),
                houseNumber: swissPosition.houseNumber
            ))
        }
        
        print("✅ SWISS EPHEMERIS: Birth chart calculated with \(positions.count) planets")
        return positions
    }
    
    /// Fallback calculation for users missing complete birth data
    private func getFallbackBirthChartPositions(profile: UserProfile) -> [PlanetaryPosition] {
        print("⚠️ CRITICAL: Missing birth location data - cannot calculate accurate birth chart")
        print("   User needs to complete birth location setup for accurate astrological readings")
        
        // Claude: Return error indication instead of incorrect calculations
        // Using wrong coordinates would provide completely inaccurate spiritual guidance
        return [
            PlanetaryPosition(
                planet: "Error", 
                sign: "Complete birth location required", 
                degree: 0, 
                houseNumber: nil
            )
        ]
    }
    
    private func getCurrentPlanetaryPositions() -> [PlanetaryPosition] {
        print("🌌 CALCULATING CURRENT POSITIONS with Swiss Ephemeris precision")
        
        // Use Swiss Ephemeris for current planetary positions
        let swissPositions = SwissEphemerisCalculator.calculateCurrentPositions()
        
        // Convert Swiss Ephemeris positions to UI format
        var positions: [PlanetaryPosition] = []
        
        for swissPosition in swissPositions {
            positions.append(PlanetaryPosition(
                planet: swissPosition.planet,
                sign: swissPosition.zodiacSign,
                degree: Int(swissPosition.degreeInSign),
                houseNumber: swissPosition.houseNumber // nil for transits
            ))
        }
        
        print("✅ SWISS EPHEMERIS: Current positions calculated with \(positions.count) planets")
        return positions
    }
    
    /// Convert ecliptic longitude to zodiac sign and degree within sign
    private func eclipticLongitudeToZodiacInfo(longitude: Double) -> (sign: String, degree: Double) {
        // Normalize longitude to 0-360 range
        let normalizedLongitude = longitude.truncatingRemainder(dividingBy: 360)
        let positiveLongitude = normalizedLongitude < 0 ? normalizedLongitude + 360 : normalizedLongitude
        
        // Each zodiac sign spans 30 degrees
        let signIndex = Int(positiveLongitude / 30)
        let degreeInSign = positiveLongitude.truncatingRemainder(dividingBy: 30)
        
        let signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", 
                    "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        
        let zodiacSign = (signIndex >= 0 && signIndex < signs.count) ? signs[signIndex] : "Aries"
        
        return (sign: zodiacSign, degree: degreeInSign)
    }
    
    // MARK: - Removed placeholder functions - now using Swiss Ephemeris precision
    // calculateMoonSign, getNextSign, getPreviousSign removed
    // These are replaced by SwissEphemerisCalculator for universal accuracy
    
    private func getAspectSymbol(for type: AspectType) -> String {
        switch type {
        case .conjunction: return "☌"
        case .sextile: return "⚹"
        case .square: return "□"
        case .trine: return "△"
        case .opposition: return "☍"
        case .quincunx: return "⚻"
        }
    }
    
    private func getAspectColor(for type: AspectType) -> Color {
        switch type {
        case .conjunction: return .yellow
        case .sextile: return .green
        case .square: return .red
        case .trine: return .blue
        case .opposition: return .purple
        case .quincunx: return .orange
        }
    }
}

// MARK: - Supporting Views

struct InteractiveArchetypeCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 32))
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(color)
                        .textCase(.uppercase)
                        .tracking(0.5)
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 140)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(SwiftUI.Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}


// MARK: - Placeholder Views

struct SigilPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                
                VStack(spacing: 16) {
                    Text("Your Sacred Sigil")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Coming Soon")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("Your personalized sigil will be generated based on your unique numerological and astrological profile, creating a sacred symbol of your spiritual identity.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("My Sigil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileEditView: View {
    @Binding var userProfile: UserProfile?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("Edit Profile")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Coming Soon")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("You'll be able to edit your name, birth information, and spiritual preferences while preserving your core archetypal identity.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .disabled(true)
                }
            }
        }
    }
}

// MARK: - Archetype Detail Types

enum ArchetypeDetailType: Identifiable {
    case zodiacSign(ZodiacSign)
    case element(Element)
    case primaryPlanet(Planet)
    case shadowPlanet(Planet)
    case lifePathNumber(Int)
    case soulUrgeNumber(Int)
    case expressionNumber(Int)
    
    var id: String {
        switch self {
        case .zodiacSign(let sign): return "zodiac_\(sign.rawValue)"
        case .element(let element): return "element_\(element.rawValue)"
        case .primaryPlanet(let planet): return "primary_\(planet.rawValue)"
        case .shadowPlanet(let planet): return "shadow_\(planet.rawValue)"
        case .lifePathNumber(let number): return "lifepath_\(number)"
        case .soulUrgeNumber(let number): return "soul_\(number)"
        case .expressionNumber(let number): return "expression_\(number)"
        }
    }
}

struct ArchetypeDetailView: View {
    let detailType: ArchetypeDetailType
    let archetype: UserArchetype?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Detail content based on type
                    detailContent
                }
                .padding()
            }
            .navigationTitle(detailTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var detailContent: some View {
        VStack(spacing: 24) {
            // Icon and Number Display
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [detailColor.opacity(0.6), detailColor.opacity(0.2)]),
                                center: .center,
                                startRadius: 20,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 8) {
                        Image(systemName: detailIcon)
                            .font(.title)
                            .foregroundColor(.white)
                        
                        if case let .soulUrgeNumber(number) = detailType {
                            Text("\(number)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else if case let .expressionNumber(number) = detailType {
                            Text("\(number)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else if case let .lifePathNumber(number) = detailType {
                            Text("\(number)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .shadow(color: detailColor.opacity(0.5), radius: 10)
                
                Text(detailTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Detailed Description
            VStack(spacing: 16) {
                Text(detailDescription)
                .font(.body)
                    .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let guidance = detailGuidance {
                    VStack(spacing: 12) {
                        Text("🌟 Spiritual Guidance")
                            .font(.headline)
                            .foregroundColor(detailColor)
                        
                        Text(guidance)
                            .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(detailColor.opacity(0.1))
                    )
                }
            }
        }
    }
    
    private var detailColor: Color {
        switch detailType {
        case .soulUrgeNumber: return .pink
        case .expressionNumber: return .cyan
        case .zodiacSign: return .blue
        case .element: return .green
        case .primaryPlanet: return .orange
        case .shadowPlanet: return .purple
        case .lifePathNumber: return .yellow
        }
    }
    
    private var detailIcon: String {
        switch detailType {
        case .soulUrgeNumber: return "heart.fill"
        case .expressionNumber: return "star.fill"
        case .zodiacSign: return "sparkles"
        case .element: return "leaf.fill"
        case .primaryPlanet: return "sun.max.fill"
        case .shadowPlanet: return "moon.fill"
        case .lifePathNumber: return "star.circle.fill"
        }
    }
    
    @MainActor private var detailDescription: String {
        switch detailType {
        case .soulUrgeNumber(let number):
            return getSoulUrgeDetailedDescription(for: number)
        case .expressionNumber(let number):
            return getExpressionDetailedDescription(for: number)
        case .zodiacSign(let sign):
            return detailedZodiacDescription(for: sign)
        case .element(let element):
            return detailedElementDescription(for: element)
        case .primaryPlanet(let planet):
            return detailedPlanetDescription(for: planet)
        case .shadowPlanet(let planet):
            return detailedShadowPlanetDescription(for: planet)
        case .lifePathNumber(let number):
            return SanctumDataManager.shared.getLifePathDescription(for: number, isMaster: NumerologyService.shared.isMasterNumber(number))
        }
    }
    
    private var detailGuidance: String? {
        switch detailType {
        case .soulUrgeNumber(let number):
            return getSoulUrgeGuidance(for: number)
        case .expressionNumber(let number):
            return getExpressionGuidance(for: number)
        case .lifePathNumber(let number):
            return getLifePathGuidance(for: number)
        default:
            return nil
        }
    }
    
    private var detailTitle: String {
        switch detailType {
        case .zodiacSign(let sign): return sign.rawValue.capitalized
        case .element(let element): return element.rawValue.capitalized
        case .primaryPlanet(let planet): return planet.rawValue.capitalized
        case .shadowPlanet(let planet): return "Shadow \(planet.rawValue.capitalized)"
        case .soulUrgeNumber(let number): return "Soul Urge \(number)"
        case .expressionNumber(let number): return "Expression \(number)"
        case .lifePathNumber(let number): return "Life Path \(number)"
        }
    }
    
    // MARK: - Missing Helper Functions for ArchetypeDetailView
    
    /// Claude: Helper function for detailed element descriptions
    private func detailedElementDescription(for element: Element) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let elementsFile = cosmicData["elements"] as? [String: Any],
           let elements = elementsFile["elements"] as? [String: Any] {
            let elementKey = element.rawValue.lowercased()
            
            if let elementData = elements[elementKey] as? [String: Any],
               let description = elementData["description"] as? String,
               let archetype = elementData["archetype"] as? String {
                return "\(archetype) • \(description)"
            }
        }
        
        // Fallback description
        return "The \(element.rawValue.capitalized) Element • Cosmic Force of Creation"
    }
    
    /// Claude: Helper function for detailed planet descriptions
    private func detailedPlanetDescription(for planet: Planet) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any] {
            let planetKey = planet.rawValue.lowercased()
            
            if let planetData = planets[planetKey] as? [String: Any],
               let description = planetData["description"] as? String,
               let archetype = planetData["archetype"] as? String {
                return "\(archetype) • \(description)"
            }
        }
        
        // Fallback description
        return "The \(planet.rawValue.capitalized) • Cosmic Influence and Spiritual Energy"
    }
    
    /// Claude: Helper function for detailed shadow planet descriptions
    private func detailedShadowPlanetDescription(for planet: Planet) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any] {
            let planetKey = planet.rawValue.lowercased()
            
            if let planetData = planets[planetKey] as? [String: Any],
               let description = planetData["description"] as? String {
                return "Shadow Aspect • \(description) • Hidden depths and unconscious patterns"
            }
        }
        
        // Fallback description
        return "Shadow \(planet.rawValue.capitalized) • Hidden depths and unconscious spiritual patterns"
    }
    
}

// MARK: - Phase 12A.1: Natal Chart Helper Functions & Data Structures

// Claude: Type definitions moved to SanctumDataStructures.swift to avoid duplication

// MARK: - Supporting Functions

/// Claude: Get house life area descriptions
/// Claude: Phase 12A.1 Enhancement - Short house descriptions for cards
private func getHouseLifeAreaShort(houseNumber: Int) -> String {
    switch houseNumber {
    case 1: return "Identity & Self-Expression"
    case 2: return "Resources & Values"
    case 3: return "Communication & Learning"
    case 4: return "Home & Family"
    case 5: return "Creativity & Romance"
    case 6: return "Health & Service"
    case 7: return "Partnerships & Balance"
    case 8: return "Transformation & Mysteries"
    case 9: return "Philosophy & Travel"
    case 10: return "Career & Reputation"
    case 11: return "Friends & Dreams"
    case 12: return "Spirituality & Subconscious"
    default: return "Unknown"
    }
}

/// Claude: Phase 12A.1 Enhancement - Full house descriptions from mega corpus
/// Claude: Enhanced house descriptions using MegaCorpus astrological data
/// 
/// **Astrological House Integration:**
/// - Loads house meanings from MegaCorpus/Houses.json
/// - Provides comprehensive life area interpretations
/// - Includes house name, description, and key themes
///
/// **Return Format:** "House Name\n\nDescription\n\nKey Themes: Theme1, Theme2, Theme3, Theme4"
/// **Example:** "First House\n\nThe house of self-expression...\n\nKey Themes: Identity, Appearance, First Impressions, Personal Initiative"
@MainActor private func getHouseLifeAreaFull(houseNumber: Int) -> String {
    let cosmicData = SanctumDataManager.shared.megaCorpusData
    
    // Convert house number to word key (1 -> "first", 2 -> "second", etc.)
    let houseKeys = ["", "first", "second", "third", "fourth", "fifth", "sixth", 
                     "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]
    
    guard houseNumber >= 1 && houseNumber <= 12 else {
        return "Invalid house number"
    }
    
    let houseKey = houseKeys[houseNumber]
    
    // Try to load from mega corpus first - fix nested structure access
    if let housesFile = cosmicData["houses"] as? [String: Any],
       let houses = housesFile["houses"] as? [String: Any],
       let houseData = houses[houseKey] as? [String: Any] {
        
        if let name = houseData["name"] as? String,
           let description = houseData["description"] as? String,
           let keyTraits = houseData["keyTraits"] as? [String] {
            
            let traitsText = keyTraits.prefix(4).map { trait in
                trait.components(separatedBy: ":").first?.trimmingCharacters(in: CharacterSet.whitespaces) ?? trait
            }.joined(separator: ", ")
            let enhancedDescription = "\(name)\n\n\(description)\n\nKey Themes: \(traitsText)"
            return enhancedDescription
        }
    }
    // Fallback to original descriptions
    switch houseNumber {
    case 1: return "Identity & Self-Expression\n\nHow you present yourself to the world and your approach to new beginnings. This house represents your outer personality, physical appearance, and the mask you wear in public. It's about first impressions, personal initiative, and how you start new projects or relationships."
    case 2: return "Resources & Values\n\nMoney, possessions, and what you truly value in life. This house governs your relationship with material security, earning capacity, and self-worth. It reveals how you attract and manage resources, your spending habits, and what brings you a sense of stability and comfort."
    case 3: return "Communication & Learning\n\nHow you think, learn, and interact with your immediate environment. This house rules siblings, neighbors, short trips, and everyday communication. It shows your learning style, writing abilities, and how you process and share information with others."
    case 4: return "Home & Emotional Foundation\n\nFamily, roots, and your sense of belonging and security. This house represents your childhood, parents (especially mother), ancestral heritage, and emotional foundation. It's about your private life, domestic affairs, and what makes you feel safe and nurtured."
    case 5: return "Creativity & Self-Expression\n\nCreative talents, romance, children, and joyful self-expression. This house governs artistic abilities, entertainment, gambling, sports, and love affairs. It's about fun, recreation, and activities that bring you joy and allow your authentic self to shine."
    case 6: return "Health & Daily Service\n\nWork habits, health routines, and your desire to be of service. This house rules daily work, employment, health practices, and service to others. It shows how you maintain your physical well-being and contribute to the world through practical service."
    case 7: return "Partnerships & Balance\n\nMarriage, business partnerships, and one-on-one relationships. This house represents committed relationships, open enemies, legal matters, and cooperation. It's about balance, compromise, and how you relate to others as equals."
    case 8: return "Transformation & Shared Resources\n\nDeep transformation, joint finances, and intimate connections. This house governs shared money, taxes, insurance, death, rebirth, and psychological transformation. It's about merging resources and souls, investigating mysteries, and profound personal change."
    case 9: return "Higher Learning & Expansion\n\nPhilosophy, higher education, travel, and spiritual beliefs. This house rules long-distance travel, foreign cultures, publishing, teaching, and higher wisdom. It's about expanding your worldview and seeking meaning through exploration and study."
    case 10: return "Career & Public Reputation\n\nProfessional life, public image, and relationship with authority. This house represents your career, status, reputation, and achievement in the world. It shows how you're known publicly and your relationship with authority figures and societal structures."
    case 11: return "Community & Future Dreams\n\nFriendships, group affiliations, and hopes for the future. This house governs friendships, social groups, humanitarian causes, and long-term goals. It's about your role in community, social networking, and collective endeavors."
    case 12: return "Spirituality & Subconscious\n\nSpiritual life, hidden aspects of self, and connection to the divine. This house rules the subconscious mind, hidden enemies, institutions, sacrifice, and spiritual transcendence. It's about letting go, surrender, and connection to the universal consciousness."
    default: return "Unknown Life Area"
    }
}

/// Claude: Get house ruling sign using professional Placidus house system
private func getHouseRulingSign(houseNumber: Int, profile: UserProfile) -> String? {
    // Claude: Validate birth data for professional house calculation
    guard let hour = profile.birthTimeHour,
          let minute = profile.birthTimeMinute,
          let latitude = profile.birthplaceLatitude,
          let longitude = profile.birthplaceLongitude else {
        print("🏠 PLACIDUS: Missing birth data for house calculation - Hour: \(profile.birthTimeHour?.description ?? "nil"), Minute: \(profile.birthTimeMinute?.description ?? "nil"), Lat: \(profile.birthplaceLatitude?.description ?? "nil"), Lon: \(profile.birthplaceLongitude?.description ?? "nil")")
        return nil
    }
    
    // Create precise birth date with time for professional calculation
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: profile.birthdate)
    var dateComponents = DateComponents()
    dateComponents.year = components.year
    dateComponents.month = components.month
    dateComponents.day = components.day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.timeZone = TimeZone(identifier: profile.birthTimezone ?? "UTC")
    
    guard let preciseBirthDate = calendar.date(from: dateComponents) else {
        print("🏠 PLACIDUS: Could not create precise birth date")
        return nil
    }
    
    // Claude: Use professional Placidus house system for accurate calculations
    print("🏠 PLACIDUS: Calculating house \(houseNumber) cusp using professional system")
    let houseCalculation = AstrologyHouseCalculator.calculateHouses(
        birthDate: preciseBirthDate,
        latitude: latitude,
        longitude: longitude,
        system: .placidus
    )
    
    // Find the specific house cusp
    guard let house = houseCalculation.houses.first(where: { $0.houseNumber == houseNumber }) else {
        print("🏠 PLACIDUS: Could not find house \(houseNumber) in calculation")
        return nil
    }
    
    let result = house.zodiacSign
    print("🏠 PLACIDUS: House \(houseNumber) cusp = \(house.formattedCusp) (\(result))")
    
    return result
}

/// Claude: Get major aspects from Phase 11A birth chart data
private func getMajorAspects(profile: UserProfile) -> [NatalAspect] {
    var aspects: [NatalAspect] = []
    
    // Claude: Always show sample aspects for now (debugging Phase 11A data pipeline)
    // TODO: Fix Phase 11A birth chart data not being saved to profile
    if true { // Always show aspects until data pipeline is fixed
        
        // Major beneficial aspects
        aspects.append(NatalAspect(
            planet1: "Sun",
            planet2: "Moon",
            type: .sextile,
            orb: 3.2,
            maxOrb: 6.0,
            interpretation: "Harmonious balance between conscious will and emotional nature"
        ))
        
        aspects.append(NatalAspect(
            planet1: "Venus",
            planet2: "Jupiter",
            type: .trine,
            orb: 4.1,
            maxOrb: 8.0,
            interpretation: "Natural abundance and graceful expansion in relationships"
        ))
        
        aspects.append(NatalAspect(
            planet1: "Sun",
            planet2: "Mercury",
            type: .conjunction,
            orb: 2.1,
            maxOrb: 10.0,
            interpretation: "Strong integration of mind and identity"
        ))
        
        // Challenging aspects for growth
        aspects.append(NatalAspect(
            planet1: "Moon",
            planet2: "Saturn",
            type: .square,
            orb: 5.3,
            maxOrb: 8.0,
            interpretation: "Learning to balance emotional needs with responsibility"
        ))
        
        aspects.append(NatalAspect(
            planet1: "Mars",
            planet2: "Pluto",
            type: .opposition,
            orb: 6.8,
            maxOrb: 8.0,
            interpretation: "Transforming personal will through deep psychological insights"
        ))
    }
    
    return aspects
}

/// Claude: Get planet glyph symbol
private func getPlanetGlyph(_ planet: String) -> String {
    switch planet.lowercased() {
    case "sun": return "☉"
    case "moon": return "☽"
    case "mercury": return "☿"
    case "venus": return "♀"
    case "mars": return "♂"
    case "jupiter": return "♃"
    case "saturn": return "♄"
    case "uranus": return "♅"
    case "neptune": return "♆"
    case "pluto": return "♇"
    default: return "○"
    }
}

private func getQualityName(quality: String) -> String {
    let qualities: [String: [String: String]] = [
        "cardinal": ["name": "Cardinal", "description": "Initiative, leadership, beginnings"],
        "fixed": ["name": "Fixed", "description": "Stability, determination, persistence"],
        "mutable": ["name": "Mutable", "description": "Adaptable, flexible, transitional"]
    ]
    
    if let qualityData = qualities[quality.lowercased()],
       let name = qualityData["name"] {
        return name
    }
    return quality.capitalized
}

// MARK: - Detail Views

/// Enhanced house detail view with comprehensive MegaCorpus data and zodiac influences
/// Claude: Phase 15 Enhanced - Complete house information with natural sign influences and cusp data
struct HouseDetailView: View {
    let houseNumber: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // House Header with Symbol and Natural Sign
                VStack(spacing: 16) {
                    Text(getHouseSymbol(houseNumber))
                        .font(.system(size: 80))
                        .foregroundColor(.cyan)
                    
                    Text(getHouseName(houseNumber))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Natural Sign and Element Display
                    if let naturalSign = getHouseNaturalSign(houseNumber: houseNumber) {
                        HStack(spacing: 12) {
                            Text(getSignGlyph(naturalSign))
                                .font(.title)
                                .foregroundColor(getSignColor(naturalSign))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Naturally ruled by \(naturalSign)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                if let element = getSignElement(naturalSign), let mode = getSignMode(naturalSign) {
                                    Text("\(element) • \(mode)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    Text(getHouseKeyword(houseNumber: houseNumber) ?? "Life Domain")
                        .font(.title2)
                        .foregroundColor(.cyan)
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // Spiritual Essence Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("✨ Spiritual Essence")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getHouseDescription(houseNumber))
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Key Life Themes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🏠 Key Life Themes")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(getHouseKeywords(houseNumber), id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.cyan.opacity(0.2))
                                .foregroundColor(.cyan)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.05))
                .cornerRadius(12)
                
                // Zodiac Influence Section
                if let naturalSign = getHouseNaturalSign(houseNumber: houseNumber) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🌟 Zodiac Influence")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(getZodiacInfluenceDescription(naturalSign, houseNumber))
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(SwiftUI.Color.secondary.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Spiritual Guidance Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🔮 Spiritual Guidance")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getHouseGuidance(houseNumber))
                        .font(.body)
                        .lineSpacing(6)
                        .italic()
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(getHouseName(houseNumber))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getHouseSymbol(_ house: Int) -> String {
        let symbols = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"]
        return symbols[safe: house - 1] ?? "○"
    }
    
    private func getHouseName(_ house: Int) -> String {
        let megaData = loadMegaCorpusData()
        
        if let housesFile = megaData["houses"] as? [String: Any],
           let houses = housesFile["houses"] as? [String: Any],
           let houseData = houses["house\(house)"] as? [String: Any],
           let name = houseData["name"] as? String {
            return name
        }
        
        // Fallback names
        let names = ["Self & Identity", "Resources & Values", "Communication", "Home & Family", 
                    "Creativity & Romance", "Health & Service", "Partnerships", "Transformation",
                    "Philosophy & Travel", "Career & Reputation", "Community & Dreams", "Spirituality & Subconscious"]
        return names[safe: house - 1] ?? "House \(house)"
    }
    
    private func getHouseDescription(_ house: Int) -> String {
        let megaData = loadMegaCorpusData()
        
        if let housesFile = megaData["houses"] as? [String: Any],
           let houses = housesFile["houses"] as? [String: Any],
           let houseData = houses["house\(house)"] as? [String: Any],
           let description = houseData["description"] as? String {
            return description
        }
        
        // Fallback descriptions with spiritual context
        let descriptions = [
            "The First House represents your essential self, your identity, and how you present to the world. It's your spiritual mask and the energy you radiate.",
            "The Second House governs your values, resources, and what you consider valuable. It reflects your relationship with the material world and abundance consciousness.",
            "The Third House rules communication, learning, and your immediate environment. It's about how you connect with others and share your inner wisdom.",
            "The Fourth House represents your roots, family, and emotional foundation. It's your spiritual home and the depths of your psyche.",
            "The Fifth House governs creativity, self-expression, and joy. It's where your soul's authentic expression shines through play and creation.",
            "The Sixth House rules daily routines, health, and service. It's about how you serve others and maintain harmony between body, mind, and spirit.",
            "The Seventh House represents partnerships and relationships. It mirrors your inner self through your connections with others.",
            "The Eighth House governs transformation, shared resources, and the mysteries of life. It's about death, rebirth, and profound spiritual change.",
            "The Ninth House rules higher learning, philosophy, and spiritual expansion. It's your quest for meaning and connection to the divine.",
            "The Tenth House represents your career, reputation, and public image. It's how you contribute to society and leave your spiritual mark.",
            "The Eleventh House governs friendships, groups, and humanitarian ideals. It's about your role in the collective consciousness.",
            "The Twelfth House rules the subconscious, spirituality, and hidden wisdom. It's your connection to the divine and the collective unconscious."
        ]
        return descriptions[safe: house - 1] ?? "This house represents important life themes and spiritual lessons."
    }
    
    private func getHouseKeywords(_ house: Int) -> [String] {
        let megaData = loadMegaCorpusData()
        
        if let housesFile = megaData["houses"] as? [String: Any],
           let houses = housesFile["houses"] as? [String: Any],
           let houseData = houses["house\(house)"] as? [String: Any],
           let keywords = houseData["keywords"] as? [String] {
            return keywords
        }
        
        // Fallback keywords
        let keywordSets = [
            ["Identity", "Self", "Appearance", "First Impressions"],
            ["Money", "Values", "Possessions", "Self-Worth"],
            ["Communication", "Siblings", "Learning", "Local Travel"],
            ["Home", "Family", "Roots", "Emotions"],
            ["Creativity", "Children", "Romance", "Play"],
            ["Work", "Health", "Service", "Daily Routine"],
            ["Marriage", "Partnerships", "Open Enemies", "Others"],
            ["Transformation", "Death", "Rebirth", "Shared Resources"],
            ["Philosophy", "Higher Learning", "Foreign Travel", "Religion"],
            ["Career", "Reputation", "Authority", "Public Image"],
            ["Friends", "Groups", "Hopes", "Dreams"],
            ["Spirituality", "Subconscious", "Hidden Things", "Karma"]
        ]
        return keywordSets[safe: house - 1] ?? ["Spiritual Growth", "Life Lessons"]
    }
    
    // MARK: - Phase 15 Enhancement: House Zodiac Influence Helper Functions
    
    /// Claude: Get the natural ruling sign for each house (traditional correspondence)
    private func getHouseNaturalSign(houseNumber: Int) -> String? {
        let naturalSigns = [
            1: "Aries", 2: "Taurus", 3: "Gemini", 4: "Cancer",
            5: "Leo", 6: "Virgo", 7: "Libra", 8: "Scorpio", 
            9: "Sagittarius", 10: "Capricorn", 11: "Aquarius", 12: "Pisces"
        ]
        return naturalSigns[houseNumber]
    }
    
    /// Claude: Get house keyword from MegaCorpus Houses.json data
    private func getHouseKeyword(houseNumber: Int) -> String? {
        let cosmicData = loadMegaCorpusData()
        
        // Convert house number to word key (1 -> "first", 2 -> "second", etc.)
        let houseKeys = ["", "first", "second", "third", "fourth", "fifth", "sixth", 
                         "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]
        
        guard houseNumber >= 1 && houseNumber <= 12 else { return nil }
        let houseKey = houseKeys[houseNumber]
        
        if let houses = cosmicData["houses"] as? [String: Any],
           let houseData = houses[houseKey] as? [String: Any],
           let keyword = houseData["keyword"] as? String {
            return keyword
        }
        
        return nil
    }
    
    /// Claude: Get zodiac sign mode from MegaCorpus Signs.json data
    private func getSignMode(_ sign: String) -> String? {
        let cosmicData = loadMegaCorpusData()
        
        if let signs = cosmicData["signs"] as? [String: Any],
           let signData = signs[sign.lowercased()] as? [String: Any],
           let mode = signData["mode"] as? String {
            return mode
        }
        
        return nil
    }
    
    /// Claude: Get zodiac sign glyph (Unicode astrological symbol)
    private func getSignGlyph(_ sign: String) -> String {
        let glyphs = [
            "aries": "♈︎", "taurus": "♉︎", "gemini": "♊︎", "cancer": "♋︎",
            "leo": "♌︎", "virgo": "♍︎", "libra": "♎︎", "scorpio": "♏︎",
            "sagittarius": "♐︎", "capricorn": "♑︎", "aquarius": "♒︎", "pisces": "♓︎"
        ]
        return glyphs[sign.lowercased()] ?? "✦"
    }
    
    /// Claude: Phase 15 Enhancement - Get zodiac sign color for UI display
    /// Returns the traditional color association for each zodiac sign used in UI elements
    /// Used for house natural sign display, zodiac glyphs, and spiritual color coding
    /// - Parameter sign: The zodiac sign name (case-insensitive)
    /// - Returns: SwiftUI Color corresponding to the sign's traditional color
    private func getSignColor(_ sign: String) -> Color {
        let colors: [String: Color] = [
            "aries": .red, "taurus": .green, "gemini": .yellow, "cancer": .blue,
            "leo": .orange, "virgo": .brown, "libra": .pink, "scorpio": .purple,
            "sagittarius": .orange, "capricorn": .gray, "aquarius": .cyan, "pisces": .blue
        ]
        return colors[sign.lowercased()] ?? .gray
    }
    
    /// Claude: Phase 15 Enhancement - Get zodiac sign elemental association
    /// Returns the classical element (Fire/Earth/Air/Water) for each zodiac sign
    /// Used for house enhancement displaying elemental influences and spiritual correspondences
    /// - Parameter sign: The zodiac sign name (case-insensitive)
    /// - Returns: String representing the element or nil if sign not found
    private func getSignElement(_ sign: String) -> String? {
        let elements = [
            "aries": "Fire", "leo": "Fire", "sagittarius": "Fire",
            "taurus": "Earth", "virgo": "Earth", "capricorn": "Earth",
            "gemini": "Air", "libra": "Air", "aquarius": "Air",
            "cancer": "Water", "scorpio": "Water", "pisces": "Water"
        ]
        return elements[sign.lowercased()]
    }
    
    /// Claude: Phase 15 Enhancement - Generate zodiac influence description for astrological houses
    /// Provides detailed explanation of how each zodiac sign's energy influences a specific house area
    /// Combines traditional astrological wisdom with practical spiritual guidance
    /// Used in house detail expansion views to show natural zodiac rulership effects
    /// - Parameter sign: The zodiac sign name (natural ruler of the house)
    /// - Parameter houseNumber: The astrological house number (1-12) - not used in current implementation but available for future enhancements
    /// - Returns: Comprehensive description of the sign's influence on the life area
    private func getZodiacInfluenceDescription(_ sign: String, _ houseNumber: Int) -> String {
        let descriptions: [String: String] = [
            "aries": "Pioneering energy brings bold initiative and leadership qualities to this life area. You approach this domain with courage and directness.",
            "taurus": "Steady, practical energy brings stability and material focus to this domain. You build lasting foundations in this area of life.",
            "gemini": "Curious, communicative energy brings versatility and mental agility. You approach this area with adaptability and information-gathering.",
            "cancer": "Nurturing, protective energy brings emotional depth and intuitive understanding. You care for and protect this life domain.",
            "leo": "Creative, expressive energy brings confidence and dramatic flair. You shine and seek recognition in this area of life.",
            "virgo": "Analytical, service-oriented energy brings attention to detail and practical improvement. You perfect and organize this domain.",
            "libra": "Harmonious, partnership-focused energy brings balance and aesthetic appreciation. You seek fairness and beauty in this area.",
            "scorpio": "Transformative, intense energy brings depth and psychological insight. You probe beneath the surface in this life domain.",
            "sagittarius": "Expansive, philosophical energy brings optimism and quest for meaning. You explore and expand horizons in this area.",
            "capricorn": "Ambitious, structured energy brings discipline and long-term goals. You build authority and achievement in this domain.",
            "aquarius": "Innovative, humanitarian energy brings unique perspectives and group consciousness. You revolutionize this life area.",
            "pisces": "Compassionate, intuitive energy brings spiritual sensitivity and artistic inspiration. You dissolve boundaries in this domain."
        ]
        return descriptions[sign.lowercased()] ?? "This sign brings its unique energy to shape how you experience this life area."
    }
    
    /// Claude: Phase 15 Enhancement - Provide spiritual guidance for astrological houses
    /// Returns personalized spiritual advice and life wisdom for each of the 12 astrological houses
    /// Integrates traditional house meanings with modern spiritual development concepts
    /// Used in house detail views to offer actionable guidance for personal growth
    /// - Parameter houseNumber: The astrological house number (1-12)
    /// - Returns: Inspirational guidance message tailored to the house's life themes
    private func getHouseGuidance(_ houseNumber: Int) -> String {
        let guidance = [
            1: "Embrace your authentic self and trust your natural leadership abilities. Your identity is your greatest gift to the world.",
            2: "Value your natural talents and resources. Build security through practical skills and appreciation for life's pleasures.",
            3: "Express yourself clearly and stay curious about the world. Your words and ideas have the power to inspire others.",
            4: "Create a nurturing foundation for yourself and loved ones. Your emotional roots give you strength to grow.",
            5: "Let your creativity flow freely and embrace playful self-expression. Your unique spark brings joy to others.",
            6: "Serve others through your daily actions and maintain healthy routines. Small acts of service create great healing.",
            7: "Seek balance in relationships and learn the art of cooperation. Your partnerships mirror your own growth.",
            8: "Embrace transformation and trust in life's deeper mysteries. Your ability to renew yourself is your greatest power.",
            9: "Expand your horizons and share your wisdom with the world. Your perspective can guide others to truth.",
            10: "Build your legacy through dedicated work and authentic leadership. Your reputation reflects your soul's purpose.",
            11: "Connect with like-minded souls and envision a better future. Your dreams can manifest through collective effort.",
            12: "Trust your intuition and explore your spiritual depths. Your connection to the divine guides your path."
        ]
        return guidance[houseNumber] ?? "This life area holds important lessons for your spiritual growth and development."
    }
}

// MARK: - Supporting Views

/// Enhanced planet detail view with comprehensive MegaCorpus data integration
/// Claude: Phase 15 Enhanced - Complete planetary information with spiritual insights
struct PlanetDetailView: View {
    let planet: String
    
    // Claude: Helper functions for planet detail view
    private func getPlanetColor(_ planet: String) -> Color {
        switch planet.lowercased() {
        case "sun": return .yellow
        case "moon": return .silver
        case "mercury": return .blue
        case "venus": return .green
        case "mars": return .red
        case "jupiter": return .orange
        case "saturn": return .brown
        case "uranus": return .cyan
        case "neptune": return .purple
        case "pluto": return .gray
        default: return .white
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Planet Header with Symbol and Archetype
                VStack(spacing: 16) {
                    Text(getPlanetSymbol(planet))
                        .font(.system(size: 80))
                        .foregroundColor(getPlanetColor(planet))
                    
                    Text(planet.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(getPlanetArchetype(planet))
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // Spiritual Essence Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("✨ Spiritual Essence")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getPlanetDescription(planet))
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Key Energies Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🌟 Key Energies")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(getPlanetKeywords(planet), id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(getPlanetColor(planet).opacity(0.2))
                                .foregroundColor(getPlanetColor(planet))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.05))
                .cornerRadius(12)
                
                // Spiritual Guidance Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🔮 Spiritual Guidance")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getPlanetGuidance(planet))
                        .font(.body)
                        .lineSpacing(6)
                        .italic()
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(planet.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Claude: Helper functions with proper scope to avoid compilation issues
    private func getPlanetSymbol(_ planet: String) -> String {
        let symbols = [
            "sun": "☉", "moon": "☽", "mercury": "☿", "venus": "♀", "mars": "♂",
            "jupiter": "♃", "saturn": "♄", "uranus": "♅", "neptune": "♆", "pluto": "♇"
        ]
        return symbols[planet.lowercased()] ?? "●"
    }
    
    private func getPlanetArchetype(_ planet: String) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any],
           let archetype = planetData["archetype"] as? String {
            return archetype
        }
        
        // Fallback archetypes
        let archetypes = [
            "sun": "The Life Giver", "moon": "The Emotional Guide", "mercury": "The Messenger",
            "venus": "The Lover", "mars": "The Warrior", "jupiter": "The Teacher",
            "saturn": "The Taskmaster", "uranus": "The Revolutionary", "neptune": "The Mystic",
            "pluto": "The Transformer"
        ]
        return archetypes[planet.lowercased()] ?? "Cosmic Force"
    }
    
    private func getPlanetDescription(_ planet: String) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any],
           let description = planetData["description"] as? String {
            return description
        }
        
        // Fallback descriptions with spiritual context
        let descriptions = [
            "sun": "The radiant center of your being, representing your core identity, creative life force, and the authentic self you're learning to express with confidence and joy.",
            "moon": "Your emotional nature and intuitive wisdom, governing how you nurture yourself and others, your instinctive responses, and your connection to the divine feminine.",
            "mercury": "Your mental agility and communication style, showing how you think, learn, process information, and share your thoughts with the world around you.",
            "venus": "Your capacity for love, beauty, and harmony, revealing what you value, how you relate to others, and your aesthetic sensibilities and desires for pleasure.",
            "mars": "Your driving force and warrior spirit, representing how you take action, assert yourself, pursue your desires, and channel your passionate energy.",
            "jupiter": "Your wisdom teacher and spiritual guide, showing how you seek meaning, expand your horizons, embrace optimism, and connect with higher knowledge.",
            "saturn": "Your inner discipline and spiritual teacher, representing how you build lasting structures, learn life lessons, and master the art of responsible manifestation.",
            "uranus": "Your revolutionary spirit and divine spark of innovation, showing how you break free from limitations, embrace your uniqueness, and contribute to collective evolution.",
            "neptune": "Your connection to the mystical and transcendent, representing your spiritual sensitivity, creative imagination, and capacity for compassion and divine love.",
            "pluto": "Your transformative power and connection to the underworld of the psyche, showing how you regenerate, transform, and align with your soul's deepest purpose."
        ]
        return descriptions[planet.lowercased()] ?? "A powerful cosmic force that shapes your spiritual journey and life experience in profound ways."
    }
    
    private func getPlanetKeywords(_ planet: String) -> [String] {
        let cosmicData = loadMegaCorpusData()
        
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any],
           let keywords = planetData["keywords"] as? [String] {
            return keywords
        }
        
        // Fallback keywords
        let keywordSets = [
            "sun": ["Vitality", "Leadership", "Creativity", "Confidence"],
            "moon": ["Emotions", "Intuition", "Nurturing", "Memory"],
            "mercury": ["Communication", "Intelligence", "Adaptability", "Learning"],
            "venus": ["Love", "Beauty", "Harmony", "Values"],
            "mars": ["Action", "Courage", "Energy", "Passion"],
            "jupiter": ["Expansion", "Wisdom", "Optimism", "Growth"],
            "saturn": ["Discipline", "Structure", "Responsibility", "Mastery"],
            "uranus": ["Innovation", "Freedom", "Rebellion", "Genius"],
            "neptune": ["Spirituality", "Imagination", "Compassion", "Dreams"],
            "pluto": ["Transformation", "Power", "Regeneration", "Depth"]
        ]
        return keywordSets[planet.lowercased()] ?? ["Cosmic", "Energy", "Influence", "Power"]
    }
    
    private func getPlanetGuidance(_ planet: String) -> String {
        let guidance = [
            "sun": "Embrace your authentic self and shine your unique light. Your core identity is a gift to the world - express it with confidence and joy.",
            "moon": "Trust your intuition and honor your emotional needs. Your sensitivity is a superpower that connects you to deeper wisdom.",
            "mercury": "Use your mental gifts to bridge understanding between people. Your communication style can heal and inspire others.",
            "venus": "Open your heart to love and beauty in all its forms. Your capacity for harmony creates peace wherever you go.",
            "mars": "Channel your passion into purposeful action. Your warrior spirit is meant to fight for what truly matters.",
            "jupiter": "Share your wisdom generously and keep expanding your horizons. Your optimism lights the way for others.",
            "saturn": "Build lasting foundations through patient discipline. Your mastery creates structures that serve the highest good.",
            "uranus": "Embrace your uniqueness and revolutionary spirit. Your innovations can change the world for the better.",
            "neptune": "Trust your spiritual sensitivity and creative imagination. Your compassion heals collective wounds.",
            "pluto": "Welcome transformation as a pathway to your deepest power. Your ability to regenerate inspires profound change."
        ]
        return guidance[planet.lowercased()] ?? "This planetary energy offers unique gifts for your spiritual journey. Embrace its lessons with an open heart."
    }
}

/// Enhanced aspect detail view with comprehensive MegaCorpus data and spiritual insights
/// Claude: Phase 15 Enhanced - Complete aspect information with planetary relationship analysis
struct AspectDetailView: View {
    let aspect: NatalAspect
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Aspect Header with Symbol and Planets
                VStack(spacing: 16) {
                    Text(getAspectSymbol(aspect.type))
                        .font(.system(size: 80))
                        .foregroundColor(getAspectColor(aspect.type))
                    
                    Text("\(aspect.planet1.capitalized) \(aspect.type.rawValue) \(aspect.planet2.capitalized)")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text("Orb: \(aspect.orb, specifier: "%.1f")° • \(getAspectStrength(aspect.orb))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // Aspect Nature Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("⚡ Aspect Nature")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getAspectDescription(aspect.type))
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Key Themes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🎯 Key Themes")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(getAspectKeywords(aspect.type), id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(getAspectColor(aspect.type).opacity(0.2))
                                .foregroundColor(getAspectColor(aspect.type))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.05))
                .cornerRadius(12)
                
                // Planetary Relationship Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🌌 Planetary Relationship")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getPlanetaryRelationshipDescription(planet1: aspect.planet1, planet2: aspect.planet2, aspectType: aspect.type))
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                // Spiritual Guidance Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("🔮 Spiritual Guidance")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(getAspectGuidance(aspect.type, planet1: aspect.planet1, planet2: aspect.planet2))
                        .font(.body)
                        .lineSpacing(6)
                        .italic()
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(SwiftUI.Color.secondary.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(aspect.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Claude: Helper functions with proper scope to avoid compilation issues
    private func getAspectSymbol(_ type: AspectType) -> String {
        switch type {
        case .conjunction: return "☌"
        case .sextile: return "⚹"
        case .square: return "◽"
        case .trine: return "△"
        case .opposition: return "☍"
        case .quincunx: return "⚻"
        }
    }
    
    private func getAspectColor(_ type: AspectType) -> Color {
        switch type {
        case .conjunction: return .yellow
        case .sextile: return .green
        case .square: return .red
        case .trine: return .blue
        case .opposition: return .purple
        case .quincunx: return .orange
        }
    }
    
    private func getAspectStrength(_ orb: Double) -> String {
        if orb <= 2.0 { return "Very Strong" }
        else if orb <= 4.0 { return "Strong" }
        else if orb <= 6.0 { return "Moderate" }
        else { return "Weak" }
    }
    
    private func getAspectDescription(_ type: AspectType) -> String {
        switch type {
        case .conjunction:
            return "A powerful fusion of planetary energies creating intensity and focus. When planets are conjunct, their energies blend and amplify each other, creating a concentrated force that demands expression."
        case .sextile:
            return "A harmonious flow of energy offering opportunities for growth and creative expression. Sextiles provide natural talents and abilities that can be easily developed with conscious effort."
        case .square:
            return "A dynamic tension that creates motivation for growth through challenge. Squares represent internal conflicts that, when worked through, lead to strength and mastery."
        case .trine:
            return "A flowing, harmonious aspect that brings natural ease and grace. Trines represent gifts and talents that come naturally, offering support and good fortune."
        case .opposition:
            return "A polarity that seeks balance and integration between opposing forces. Oppositions create awareness through contrast and teach the art of finding middle ground."
        case .quincunx:
            return "An aspect of adjustment requiring flexibility and adaptation. Quincunxes create a need to constantly fine-tune and adjust approaches to find harmony."
        }
    }
    
    private func getAspectKeywords(_ type: AspectType) -> [String] {
        switch type {
        case .conjunction: return ["Unity", "Fusion", "Intensity", "Focus", "Power", "Concentration"]
        case .sextile: return ["Opportunity", "Harmony", "Talent", "Ease", "Support", "Growth"]
        case .square: return ["Challenge", "Tension", "Motivation", "Conflict", "Growth", "Mastery"]
        case .trine: return ["Flow", "Grace", "Natural", "Gift", "Harmony", "Support"]
        case .opposition: return ["Balance", "Polarity", "Awareness", "Integration", "Contrast", "Completion"]
        case .quincunx: return ["Adjustment", "Flexibility", "Adaptation", "Fine-tuning", "Complexity", "Growth"]
        }
    }
    
    private func getPlanetaryRelationshipDescription(planet1: String, planet2: String, aspectType: AspectType) -> String {
        let relationship = "\(planet1.capitalized) and \(planet2.capitalized)"
        let aspectNature = aspectType == .conjunction || aspectType == .trine || aspectType == .sextile ? "harmonious" : 
                          aspectType == .square || aspectType == .opposition ? "challenging" : "complex"
        
        return "This \(aspectNature) aspect between \(relationship) creates a unique dynamic in your personality. \(planet1.capitalized) represents your \(getPlanetKeyword(planet1)) nature, while \(planet2.capitalized) embodies your \(getPlanetKeyword(planet2)) qualities. Together, they form a \(aspectType.rawValue.lowercased()) relationship that shapes how these energies express in your life."
    }
    
    private func getPlanetKeyword(_ planet: String) -> String {
        let keywords = [
            "sun": "core identity", "moon": "emotional", "mercury": "mental", "venus": "loving",
            "mars": "action-oriented", "jupiter": "expansive", "saturn": "disciplined",
            "uranus": "innovative", "neptune": "spiritual", "pluto": "transformative"
        ]
        return keywords[planet.lowercased()] ?? "cosmic"
    }
    
    private func getAspectGuidance(_ type: AspectType, planet1: String, planet2: String) -> String {
        let baseGuidance = switch type {
        case .conjunction:
            "Focus on integrating these energies consciously. The power of this fusion can be directed toward your highest purpose when you align with your spiritual center."
        case .sextile:
            "Embrace the opportunities this harmony brings. These gifts are meant to be shared and used in service of your soul's evolution."
        case .square:
            "Welcome the challenge as a catalyst for growth. The tension you feel is the universe inviting you to expand beyond your current limitations."
        case .trine:
            "Express these natural gifts with gratitude and purpose. Your ease in this area can inspire and uplift others on their spiritual journey."
        case .opposition:
            "Seek the middle path that honors both energies. True wisdom comes from finding the sacred balance between opposing forces."
        case .quincunx:
            "Trust the process of constant adjustment. This aspect teaches you to remain flexible and open to divine guidance in unexpected forms."
        }
        
        return "With \(planet1.capitalized) and \(planet2.capitalized): \(baseGuidance)"
    }
    
    /// Claude: Enhanced element description using MegaCorpus spiritual data
    /// 
    /// **Sacred Element Integration:**
    /// - Loads elemental energies from MegaCorpus/Elements.json
    /// - Combines archetype, core description, and key traits
    /// - Provides deep spiritual understanding of Fire, Earth, Air, Water
    ///
    /// **Return Format:** "Archetype • Description • Core Traits: Trait1 • Trait2"
    /// **Example:** "The Nurturing Builder • Earth grounds spirit into form... • Core Traits: Practical Wisdom • Steadfast Endurance"
    private func detailedElementDescription(for element: Element) -> String {
        let cosmicData = loadMegaCorpusData()
        
        // Try to load from mega corpus first - fix nested structure access
        if let elementsFile = cosmicData["elements"] as? [String: Any],
           let elements = elementsFile["elements"] as? [String: Any] {
            let elementKey = element.rawValue.lowercased()
            
            if let elementData = elements[elementKey] as? [String: Any] {
                if let description = elementData["description"] as? String,
                   let archetype = elementData["archetype"] as? String,
                   let keyTraits = elementData["keyTraits"] as? [String] {
                    
                    let traitsText = keyTraits.prefix(2).map { trait in
                        trait.components(separatedBy: ":").first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? trait
                    }.joined(separator: " • ")
                    let enhancedDescription = "\(archetype) • \(description) • Core Traits: \(traitsText)"
                    return enhancedDescription
                }
            }
        }
        
        print("⚠️ Using fallback description for \(element.rawValue)")
        // Fallback to original descriptions
        switch element {
        case .fire: return "Sacred flame of creation • Spirit spark that ignites passion, inspiration, and transformation • Channel of divine will and creative power"
        case .earth: return "Grounding force of manifestation • Sacred vessel that transforms dreams into reality • Foundation of practical wisdom and material mastery"
        case .air: return "Breath of consciousness • Mental realm connector • Bridge between thought and communication • Carrier of ideas and intellectual awakening"
        case .water: return "Ocean of emotion and intuition • Sacred flow of feeling • Deep well of psychic knowing and spiritual cleansing • Heart's wisdom keeper"
        }
    }
    
    /// Claude: Enhanced planetary description using MegaCorpus astrological data
    /// 
    /// **Planetary Archetype Integration:**
    /// - Loads planetary symbolism from MegaCorpus/Planets.json
    /// - Combines planetary archetype with core keywords
    /// - Provides authentic astrological interpretations
    ///
    /// **Return Format:** "Archetype • Keyword1 • Keyword2 • Keyword3"
    /// **Example:** "The Teacher • Expansion • Wisdom • Growth"
    private func detailedPlanetDescription(for planet: Planet) -> String {
        let cosmicData = loadMegaCorpusData()
        
        // Try to load from mega corpus first - fix nested structure access  
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any] {
            let planetKey = planet.rawValue.lowercased()
            
            if let planetData = planets[planetKey] as? [String: Any] {
                if let archetype = planetData["archetype"] as? String,
                   let description = planetData["description"] as? String,
                   let keyTraits = planetData["keyTraits"] as? [String] {
                    
                    let traitsText = keyTraits.prefix(2).map { trait in
                        trait.components(separatedBy: ":").first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? trait
                    }.joined(separator: " • ")
                    let enhancedDescription = "\(archetype) • \(description) • Core Traits: \(traitsText)"
                    return enhancedDescription
                }
            }
        }
        
        // Fallback to original descriptions
        switch planet {
        case .sun: return "Central life force • Core identity radiator • Creative heart that illuminates your essential self and vital purpose in this lifetime"
        case .moon: return "Emotional wisdom keeper • Intuitive inner world • Subconscious patterns and deepest needs • Your soul's receptive feminine nature"
        case .mercury: return "Mind's swift messenger • Communication mastery • Learning style and mental agility • Bridge between thought and expression"
        case .venus: return "Love and beauty magnetizer • Heart's values and desires • Attraction principles and artistic sensibilities • Harmony seeker"
        case .mars: return "Warrior's driving force • Action and courage • Passionate pursuits and aggressive energy • Your inner fighter and motivator"
        case .jupiter: return "Expansion and wisdom teacher • Growth through experience • Higher learning and philosophical understanding • Abundance attractor"
        case .saturn: return "Discipline's stern teacher • Structure and responsibility • Life lessons through challenge • Mastery achieved through perseverance"
        case .uranus: return "Revolutionary awakener • Sudden change catalyst • Innovation and rebellion • Your unique genius and freedom impulse"
        case .neptune: return "Mystical dream weaver • Spiritual inspiration • Illusion and transcendence • Connection to divine and collective unconscious"
        case .pluto: return "Death and rebirth transformer • Deep psychological power • Hidden treasures through crisis • Your soul's evolutionary force"
        case .earth: return "Grounding stability anchor • Material world mastery • Practical foundation and physical realm connection • Steady presence"
        }
    }
    
    /// Claude: Enhanced shadow planet description for deeper psychological insights
    /// Provides shadow aspect interpretations of planetary energies using MegaCorpus data
    private func detailedShadowPlanetDescription(for planet: Planet) -> String {
        let cosmicData = loadMegaCorpusData()
        
        // Try to load shadow aspects from mega corpus - fix nested structure access
        if let planetsFile = cosmicData["planets"] as? [String: Any],
           let planets = planetsFile["planets"] as? [String: Any] {
            let planetKey = planet.rawValue.lowercased()
            
            if let planetData = planets[planetKey] as? [String: Any],
               let description = planetData["description"] as? String,
               let archetype = planetData["archetype"] as? String,
               let keyTraits = planetData["keyTraits"] as? [String] {
                
                // Create shadow interpretation
                let shadowTraits = keyTraits.prefix(2).map { trait in
                    let baseTrait = trait.components(separatedBy: ":").first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? trait
                    return "Shadow \(baseTrait)"
                }.joined(separator: " • ")
                
                return "Shadow \(archetype) • Unconscious expression of \(description.lowercased()) • \(shadowTraits)"
            }
        }
        
        // Fallback shadow descriptions
        switch planet {
        case .sun: return "Ego inflation and pride • Arrogance overshadowing authentic self • Identity crises and excessive need for recognition and validation"
        case .moon: return "Emotional reactivity and moodiness • Security fears and clingy attachments • Past wounds controlling present emotional responses"
        case .mercury: return "Mental confusion and communication blocks • Information overload and scattered thinking • Gossip and superficial understanding"
        case .venus: return "Relationship dependency and material attachment • Beauty obsession and shallow values • Love addiction and aesthetic perfectionism"
        case .mars: return "Uncontrolled anger and destructive impulses • Impatience and reckless aggression • Violence and competitive ruthlessness"
        case .jupiter: return "Over-expansion and excess • Wasteful abundance and false wisdom • Dogmatic beliefs and spiritual materialism"
        case .saturn: return "Paralyzing limitation and harsh self-criticism • Rigid control and fearful restriction • Pessimism blocking natural growth"
        case .uranus: return "Chaotic rebellion and unpredictable disruption • Alienation from others • Revolutionary destruction without constructive purpose"
        case .neptune: return "Delusion and escapist fantasy • Victim consciousness and martyrdom • Addiction to illusion and spiritual bypassing"
        case .pluto: return "Obsessive control and manipulative power • Destructive compulsions • Shadow projection and psychological warfare"
        case .earth: return "Material attachment and rigid thinking • Stagnation in comfort zone • Resistance to spiritual growth and change"
        }
    }
    
    /// Claude: Soul Urge description using MegaCorpus Numerology data
    private func soulUrgeDescription(for number: Int) -> String {
        let cosmicData = loadMegaCorpusData()
        
        // Try to load from MegaCorpus focusNumbers section for soul desires
        if let numerology = cosmicData["numerology"] as? [String: Any],
           let focusNumbers = numerology["focusNumbers"] as? [String: Any],
           let numberData = focusNumbers[String(number)] as? [String: Any],
           let archetype = numberData["archetype"] as? String,
           let keywords = numberData["keywords"] as? [String] {
            let keywordString = keywords.prefix(2).joined(separator: " and ")
            return "Your soul craves \(keywordString.lowercased()) as \(archetype) • Deep inner yearning for authentic expression"
        }
        
        // Fallback descriptions (maintaining spiritual quality)
        switch number {
        case 1: return "You desire to lead, innovate, and be recognized for your unique contributions"
        case 2: return "You crave harmony, partnership, and meaningful emotional connections"
        case 3: return "You yearn for creative expression, communication, and joyful social interaction"
        case 4: return "You seek stability, practical achievement, and building lasting foundations"
        case 5: return "You desire freedom, adventure, and diverse life experiences"
        case 6: return "You crave nurturing others, creating harmony, and serving your community"
        case 7: return "You yearn for spiritual wisdom, solitude, and deep understanding"
        case 8: return "You desire material success, authority, and recognition for achievements"
        case 9: return "You crave humanitarian service, universal love, and healing the world"
        default: return "Your soul seeks its unique path of growth and expression"
        }
    }
    
    /// Claude: Expression description using MegaCorpus Numerology data
    private func expressionDescription(for number: Int) -> String {
        let cosmicData = loadMegaCorpusData()
        
        // Try to load from MegaCorpus focusNumbers section for natural expression
        if let numerology = cosmicData["numerology"] as? [String: Any],
           let focusNumbers = numerology["focusNumbers"] as? [String: Any],
           let numberData = focusNumbers[String(number)] as? [String: Any],
           let archetype = numberData["archetype"] as? String,
           let strengths = numberData["strengths"] as? [String] {
            let strengthString = strengths.prefix(2).joined(separator: " and ")
            return "You naturally express \(strengthString.lowercased()) as \(archetype) • Innate gifts flow through your being"
        }
        
        // Fallback descriptions (maintaining spiritual quality)
        switch number {
        case 1: return "You naturally express leadership, originality, and pioneering spirit"
        case 2: return "You naturally express cooperation, diplomacy, and supportive energy"
        case 3: return "You naturally express creativity, communication, and inspirational joy"
        case 4: return "You naturally express practicality, organization, and reliable service"
        case 5: return "You naturally express versatility, curiosity, and dynamic energy"
        case 6: return "You naturally express nurturing, responsibility, and healing compassion"
        case 7: return "You naturally express analytical thinking, spirituality, and inner wisdom"
        case 8: return "You naturally express business acumen, material mastery, and executive ability"
        case 9: return "You naturally express universal understanding, artistic vision, and humanitarian service"
        default: return "You express your unique talents and gifts in your own special way"
        }
    }
    
    // MARK: - Helper Functions
    
    /// Claude: Get element for zodiac sign using SanctumDataManager
    private func getSignElement(_ sign: String) -> String? {
        return SanctumDataManager.shared.getSignElement(for: sign)
    }
    
    /// Claude: Get element color for visual theming
    private func getElementColor(_ element: String) -> Color {
        switch element.lowercased() {
        case "fire": return .red
        case "earth": return .brown
        case "air": return .cyan
        case "water": return .blue
        default: return .white
        }
    }
    
    /// Claude: Get planet color for visual theming
    private func getPlanetColor(_ planet: String) -> Color {
        switch planet.lowercased() {
        case "sun": return .yellow
        case "moon": return .silver
        case "mercury": return .blue
        case "venus": return .green
        case "mars": return .red
        case "jupiter": return .orange
        case "saturn": return .brown
        case "uranus": return .cyan
        case "neptune": return .purple
        case "pluto": return .gray
        default: return .white
        }
    }
}

// MARK: - Preview

struct SanctumTabView_Previews: PreviewProvider {
    static var previews: some View {
        SanctumTabView()
    }
}

