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

// MARK: - Helper Functions for Spiritual Descriptions

// Life Path Descriptions
func lifePathDescription(for number: Int, isMaster: Bool) -> String {
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

// Zodiac Descriptions
func detailedZodiacDescription(for sign: ZodiacSign) -> String {
    switch sign {
    case .aries: return "Ram of the cosmos • First fire of spring • Courageous pioneer who charges ahead with divine confidence and unstoppable determination"
    case .taurus: return "Sacred bull of abundance • Earth's steadfast guardian • Patient builder who manifests dreams through unwavering persistence and sensual wisdom"
    case .gemini: return "Divine twins of duality • Mercury's quick messenger • Curious communicator who bridges worlds through wit, adaptability, and social connection"
    case .cancer: return "Moon's tender child • Emotional sanctuary keeper • Intuitive nurturer who heals through deep compassion and protective maternal energy"
    case .leo: return "Sun's royal essence • Heart of creative fire • Radiant performer who illuminates the world with generous spirit and natural leadership"
    case .virgo: return "Earth's perfectionist healer • Analytical servant of wholeness • Practical mystic who transforms chaos into sacred order through devoted service"
    case .libra: return "Scales of cosmic balance • Venus's diplomatic artist • Harmonious peace-keeper who seeks beauty, justice, and perfect equilibrium"
    case .scorpio: return "Phoenix of transformation • Pluto's deep mystery • Intense alchemist who transmutes darkness into light through fearless soul excavation"
    case .sagittarius: return "Centaur archer of truth • Jupiter's philosophical explorer • Freedom-loving seeker who expands horizons through adventurous wisdom"
    case .capricorn: return "Mountain goat of mastery • Saturn's disciplined achiever • Ambitious architect who builds lasting legacies through patient determination"
    case .aquarius: return "Water bearer of innovation • Uranus's revolutionary visionary • Humanitarian rebel who serves collective consciousness through unique brilliance"
    case .pisces: return "Fish of infinite depth • Neptune's mystical dreamer • Compassionate empath who channels divine love through artistic spiritual expression"
    }
}

// Element Descriptions
func detailedElementDescription(for element: Element) -> String {
    switch element {
    case .fire: return "Sacred flame of creation • Spirit spark that ignites passion, inspiration, and transformation • Channel of divine will and creative power"
    case .earth: return "Grounding force of manifestation • Sacred vessel that transforms dreams into reality • Foundation of practical wisdom and material mastery"
    case .air: return "Breath of consciousness • Mental realm connector • Bridge between thought and communication • Carrier of ideas and intellectual awakening"
    case .water: return "Ocean of emotion and intuition • Sacred flow of feeling • Deep well of psychic knowing and spiritual cleansing • Heart's wisdom keeper"
    }
}

// Planet Descriptions
func detailedPlanetDescription(for planet: Planet) -> String {
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

// Shadow Planet Descriptions
func detailedShadowPlanetDescription(for planet: Planet) -> String {
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

// Soul Urge and Expression Descriptions
func soulUrgeDescription(for number: Int) -> String {
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

func expressionDescription(for number: Int) -> String {
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

struct UserProfileTabView: View {
    @StateObject private var archetypeManager = UserArchetypeManager.shared
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    @State private var showingSigilView = false
    @State private var showingShareSheet = false
    @State private var selectedArchetypeDetail: ArchetypeDetailType?
    @State private var archetypeRetryCount = 0
    
    // Animation states
    @State private var lifePathPulse: Bool = false
    @State private var archetypeGlow: Bool = false
    
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
                            theDivineTriangleSection(profile)
                        
                        // Complete Spiritual Archetype
                        if let userArchetype = archetypeManager.currentArchetype ?? archetypeManager.storedArchetype {
                            completeArchetypeCodex(userArchetype)
                        } else {
                            // Show loading state for archetype
                            archetypeLoadingView
                        }
                        
                        // Action Buttons Section
                        actionButtonsSection
                        
                        // Profile Summary
                            profileSummarySection(profile)
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
                    .lineLimit(nil)
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
                            .fill(Color.purple.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.purple.opacity(0.4), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.5), lineWidth: 1)
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
                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 60
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
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
                        .fill(Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
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
    
    // MARK: - The Divine Triangle Section (Complete Numerological Trinity)
    
    private func theDivineTriangleSection(_ profile: UserProfile) -> some View {
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
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }) {
                    divineTriangleCard(
                        number: profile.lifePathNumber,
                        title: "Life Path Number",
                        subtitle: "Soul's Journey & Purpose",
                        description: lifePathDescription(for: profile.lifePathNumber, isMaster: profile.isMasterNumber),
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
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
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
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
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
            }
        }
        .padding()
        .background(
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
        )
        .shadow(color: .yellow.opacity(0.3), radius: 15, x: 0, y: 8)
    }
    
    // MARK: - Helper Functions
    
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
                                Color.clear
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
                .fill(Color.black.opacity(isPrimary ? 0.4 : 0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(isPrimary ? 0.6 : 0.5), lineWidth: isPrimary ? 1.5 : 1)
                )
        )
        .shadow(color: color.opacity(0.3), radius: isPrimary ? 12 : 8, x: 0, y: isPrimary ? 6 : 4)
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
    
    private var detailDescription: String {
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
            return lifePathDescription(for: number, isMaster: false)
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
}

// MARK: - Preview

struct UserProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileTabView()
    }
} 