import SwiftUI

/**
 * UserProfileTabView - The Sacred Digital Altar
 * 
 * This is the user's permanent spiritual sanctuary where they can:
 * - View their complete spiritual archetype
 * - Interact with archetypal components for deeper understanding
 * - Access their sigil (future)
 * - Share their spiritual card (future)
 * - Edit core profile information
 */
struct UserProfileTabView: View {
    @StateObject private var archetypeManager = UserArchetypeManager.shared
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    @State private var showingSigilView = false
    @State private var showingShareSheet = false
    @State private var selectedArchetypeDetail: ArchetypeDetailType?
    
    // Animation states
    @State private var lifePathPulse: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic Background
                CosmicBackgroundView()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Hero Life Path Section
                        if let profile = userProfile {
                            heroLifePathSection(profile)
                        }
                        
                        // Complete Spiritual Archetype
                        if let userArchetype = archetypeManager.storedArchetype {
                            completeArchetypeCodex(userArchetype)
                        }
                        
                        // Action Buttons Section
                        actionButtonsSection
                        
                        // Profile Summary
                        if let profile = userProfile {
                            profileSummarySection(profile)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
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
                loadUserProfile()
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    lifePathPulse = true
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
                                Color.yellow.opacity(0.4),
                                Color.orange.opacity(0.3),
                                Color.clear
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
                                .fill(Color.yellow.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                
                Text(lifePathDescription(for: profile.lifePathNumber, isMaster: profile.isMasterNumber))
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
                .fill(Color.black.opacity(0.4))
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
    
    // MARK: - Complete Archetype Codex
    
    private func completeArchetypeCodex(_ archetype: UserArchetype) -> some View {
        VStack(spacing: 24) {
            // Section Header
            VStack(spacing: 12) {
                Text("Your Spiritual Archetype")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Tap any element to explore its sacred meaning")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
            
            // Zodiac & Element Row
            enhancedZodiacElementSection(archetype)
            
            // Planetary Influences
            enhancedPlanetarySection(archetype)
            
            // Enhanced Numerology Section
            if let profile = userProfile {
                enhancedNumerologySection(profile)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
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
    
    private func enhancedZodiacElementSection(_ archetype: UserArchetype) -> some View {
        HStack(spacing: 25) {
            // Zodiac Sign
            Button(action: {
                selectedArchetypeDetail = .zodiacSign(archetype.zodiacSign)
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                InteractiveArchetypeCard(
                    icon: zodiacIcon(for: archetype.zodiacSign),
                    title: archetype.zodiacSign.rawValue.capitalized,
                    subtitle: "Zodiac Sign",
                    description: conciseZodiacDescription(for: archetype.zodiacSign),
                    color: .blue
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Element
            Button(action: {
                selectedArchetypeDetail = .element(archetype.element)
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                InteractiveArchetypeCard(
                    icon: elementIcon(for: archetype.element),
                    title: archetype.element.rawValue.capitalized,
                    subtitle: "Element",
                    description: conciseElementDescription(for: archetype.element),
                    color: elementColor(for: archetype.element)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func enhancedPlanetarySection(_ archetype: UserArchetype) -> some View {
        HStack(spacing: 25) {
            // Primary Planet
            Button(action: {
                selectedArchetypeDetail = .primaryPlanet(archetype.primaryPlanet)
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                InteractiveArchetypeCard(
                    icon: planetIcon(for: archetype.primaryPlanet),
                    title: archetype.primaryPlanet.rawValue.capitalized,
                    subtitle: "Primary Planet",
                    description: concisePlanetDescription(for: archetype.primaryPlanet),
                    color: .orange
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Shadow Planet
            Button(action: {
                selectedArchetypeDetail = .shadowPlanet(archetype.subconsciousPlanet)
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                InteractiveArchetypeCard(
                    icon: planetIcon(for: archetype.subconsciousPlanet),
                    title: archetype.subconsciousPlanet.rawValue.capitalized,
                    subtitle: "Shadow Planet",
                    description: conciseShadowPlanetDescription(for: archetype.subconsciousPlanet),
                    color: .indigo
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func enhancedNumerologySection(_ profile: UserProfile) -> some View {
        VStack(spacing: 16) {
            Text("Sacred Numbers")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                // Soul Urge Number
                if let soulUrge = profile.soulUrgeNumber {
                    Button(action: {
                        selectedArchetypeDetail = .soulUrgeNumber(soulUrge)
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        EnhancedNumerologyRow(
                            icon: "heart.fill",
                            title: "Soul Urge Number",
                            value: String(soulUrge),
                            description: "Your heart's deepest desires",
                            detailedDescription: soulUrgeDescription(for: soulUrge),
                            color: .pink
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Expression Number
                if let expression = profile.expressionNumber {
                    Button(action: {
                        selectedArchetypeDetail = .expressionNumber(expression)
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        EnhancedNumerologyRow(
                            icon: "star.fill",
                            title: "Expression Number",
                            value: String(expression),
                            description: "Your natural talents and abilities",
                            detailedDescription: expressionDescription(for: expression),
                            color: .cyan
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Action Buttons Section
    
    private var actionButtonsSection: some View {
        HStack(spacing: 20) {
            // View Sigil Button
            Button(action: {
                showingSigilView = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "hexagon.fill")
                        .font(.title2)
                    Text("View My Sigil")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .indigo]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            // Share Card Button
            Button(action: {
                showingShareSheet = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                    Text("Share Card")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.teal, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .teal.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    // MARK: - Profile Summary Section
    
    private func profileSummarySection(_ profile: UserProfile) -> some View {
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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Helper Functions
    
    private func loadUserProfile() {
        // Load from UserProfileService
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            UserProfileService.shared.fetchUserProfile(for: userID) { profile, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error fetching profile in UserProfileTabView: \(error.localizedDescription)")
                        // Optionally, try to load from cache as a fallback or show an error state
                        self.userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
                        if self.userProfile == nil {
                            // Handle case where both Firestore and cache fail
                            print("❌❌ No profile found in Firestore or cache for userID: \(userID)")
                        }
                        return
                    }
                    self.userProfile = profile
                    // If profile is nil and no error, it means no profile found in Firestore
                    if profile == nil {
                        print("ℹ️ No profile found in Firestore for userID: \(userID). Attempting to load from cache.")
                        self.userProfile = UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
                        if self.userProfile == nil {
                            print("❌❌ No profile found in Firestore or cache for userID: \(userID)")
                        }
                    }
                }
            }
        }
    }
    
    // Include all the helper description functions from OnboardingCompletionView
    private func lifePathDescription(for number: Int, isMaster: Bool) -> String {
        if isMaster {
            switch number {
            case 11: return "The Intuitive Illuminator • Master of Spiritual Insight • Channel for Divine Wisdom"
            case 22: return "The Master Builder • Architect of Dreams • Creator of Lasting Legacy"
            case 33: return "The Master Teacher • Embodiment of Universal Love • Healer of Hearts"
            default: return "Master Number • Divine Spiritual Mission • Sacred Soul Purpose"
            }
        } else {
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
    
    private func conciseZodiacDescription(for sign: ZodiacSign) -> String {
        switch sign {
        case .aries: return "Bold pioneer • Natural leader • Passionate fire energy"
        case .taurus: return "Grounded builder • Sensual strength • Steady endurance"
        case .gemini: return "Curious communicator • Quick mind • Social connector"
        case .cancer: return "Emotional nurturer • Intuitive healer • Protective soul"
        case .leo: return "Creative performer • Generous heart • Radiant leader"
        case .virgo: return "Practical healer • Analytical mind • Service-oriented"
        case .libra: return "Harmonious diplomat • Beauty seeker • Balance keeper"
        case .scorpio: return "Intense transformer • Psychic depth • Powerful healer"
        case .sagittarius: return "Philosophical explorer • Truth seeker • Freedom lover"
        case .capricorn: return "Ambitious achiever • Natural authority • Mountain climber"
        case .aquarius: return "Innovative humanitarian • Future visionary • Group consciousness"
        case .pisces: return "Compassionate dreamer • Intuitive artist • Spiritual channel"
        }
    }
    
    private func conciseElementDescription(for element: Element) -> String {
        switch element {
        case .fire: return "Dynamic energy • Passion and inspiration • Creative spark"
        case .earth: return "Grounded wisdom • Practical manifestation • Material mastery"
        case .air: return "Mental clarity • Communication flow • Intellectual connection"
        case .water: return "Emotional depth • Intuitive knowing • Spiritual flow"
        }
    }
    
    private func concisePlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Core identity • Life force • Creative expression"
        case .moon: return "Emotional nature • Intuitive wisdom • Inner world"
        case .mercury: return "Communication • Mental agility • Learning style"
        case .venus: return "Love and beauty • Values and attraction • Harmony"
        case .mars: return "Action and drive • Courage and passion • Warrior energy"
        case .jupiter: return "Expansion and growth • Wisdom and abundance • Higher mind"
        case .saturn: return "Structure and discipline • Life lessons • Mastery"
        case .uranus: return "Innovation and freedom • Sudden change • Awakening"
        case .neptune: return "Dreams and spirituality • Illusion and inspiration • Mysticism"
        case .pluto: return "Transformation • Deep power • Regeneration"
        case .earth: return "Grounding • Material wisdom • Stability"
        }
    }
    
    private func conciseShadowPlanetDescription(for planet: Planet) -> String {
        switch planet {
        case .sun: return "Ego challenges • Pride and arrogance • Identity crises"
        case .moon: return "Emotional reactivity • Mood swings • Security fears"
        case .mercury: return "Communication blocks • Mental confusion • Information overload"
        case .venus: return "Relationship struggles • Material attachment • Beauty obsession"
        case .mars: return "Anger and aggression • Impulsiveness • Destructive force"
        case .jupiter: return "Over-expansion • Excess and waste • False wisdom"
        case .saturn: return "Limitation and fear • Harsh criticism • Rigid control"
        case .uranus: return "Rebellion and chaos • Unpredictable disruption • Alienation"
        case .neptune: return "Delusion and escapism • Victim consciousness • Addiction"
        case .pluto: return "Obsession and control • Destructive power • Shadow work"
        case .earth: return "Materialism • Rigidity • Stagnation patterns"
        }
    }
    
    private func soulUrgeDescription(for number: Int) -> String {
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
    
    private func expressionDescription(for number: Int) -> String {
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
    
    // Icon helper functions
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
    
    private func elementIcon(for element: Element) -> String {
        switch element {
        case .fire: return "🔥"
        case .earth: return "🌍"
        case .air: return "💨"
        case .water: return "🌊"
        }
    }
    
    private func elementColor(for element: Element) -> Color {
        switch element {
        case .fire: return .red
        case .earth: return .brown
        case .air: return .yellow
        case .water: return .cyan
        }
    }
    
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
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 120)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

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
    case soulUrgeNumber(Int)
    case expressionNumber(Int)
    
    var id: String {
        switch self {
        case .zodiacSign(let sign): return "zodiac_\(sign.rawValue)"
        case .element(let element): return "element_\(element.rawValue)"
        case .primaryPlanet(let planet): return "primary_\(planet.rawValue)"
        case .shadowPlanet(let planet): return "shadow_\(planet.rawValue)"
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
        VStack(spacing: 20) {
            Text("Detailed information about \(detailTitle) coming soon...")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("This will include comprehensive descriptions, meanings, and guidance for personal growth and understanding.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
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
        }
    }
}

// MARK: - Preview

struct UserProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileTabView()
    }
} 