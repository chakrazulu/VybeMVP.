import SwiftUI

/**
 * UserProfileTabView - The Sacred Digital Altar
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
func detailedZodiacDescription(for sign: ZodiacSign) -> String {
    let cosmicData = loadMegaCorpusData()
    
    // Try to load from mega corpus first
    if let signs = cosmicData["signs"] as? [String: Any] {
        let signKey = sign.rawValue.lowercased()
        
        if let signData = signs[signKey] as? [String: Any] {
            // Extract data from the actual JSON structure for rich description
            let name = signData["name"] as? String ?? sign.rawValue
            let description = signData["description"] as? String ?? ""
            let keyTraits = signData["keyTraits"] as? [String] ?? []
            
            // Create rich description format like other detailed views
            if !description.isEmpty {
                let traitsText = keyTraits.prefix(3).map { trait in
                    trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
                }.joined(separator: " • ")
                
                let richDescription = "\(description)\n\nCore Traits: \(traitsText)"
                return richDescription
            } else {
                // Fallback to basic format if no description
                let element = signData["element"] as? String ?? ""
                let mode = signData["mode"] as? String ?? ""
                let traitsText = keyTraits.prefix(3).map { trait in
                    trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
                }.joined(separator: " • ")
                
                return "\(name) • \(element) \(mode) • \(traitsText)"
            }
        }
    }
    
    print("⚠️ Using fallback zodiac description for \(sign.rawValue)")
    // Fallback to original descriptions
    switch sign {
    case .aries: return "The Pioneer • Fire Cardinal • Initiative • Leadership • Courage"
    case .taurus: return "The Builder • Earth Fixed • Stability • Sensuality • Persistence"
    case .gemini: return "The Communicator • Air Mutable • Communication • Curiosity • Adaptability"
    case .cancer: return "The Nurturer • Water Cardinal • Nurturing • Intuition • Protection"
    case .leo: return "The Performer • Fire Fixed • Creativity • Drama • Generosity"
    case .virgo: return "The Healer • Earth Mutable • Service • Analysis • Perfectionism"
    case .libra: return "The Peacemaker • Air Cardinal • Balance • Harmony • Justice"
    case .scorpio: return "The Transformer • Water Fixed • Transformation • Intensity • Mystery"
    case .sagittarius: return "The Explorer • Fire Mutable • Adventure • Philosophy • Freedom"
    case .capricorn: return "The Achiever • Earth Cardinal • Ambition • Discipline • Structure"
    case .aquarius: return "The Revolutionary • Air Fixed • Innovation • Independence • Humanitarianism"
    case .pisces: return "The Mystic • Water Mutable • Compassion • Intuition • Imagination"
    }
}

// Element Descriptions (Enhanced with MegaCorpus)
/// Claude: Enhanced element description using MegaCorpus spiritual data
/// 
/// **Sacred Element Integration:**
/// - Loads elemental energies from MegaCorpus/Elements.json
/// - Combines archetype, core description, and key traits
/// - Provides deep spiritual understanding of Fire, Earth, Air, Water
///
/// **Return Format:** "Archetype • Description • Core Traits: Trait1 • Trait2"
/// **Example:** "The Nurturing Builder • Earth grounds spirit into form... • Core Traits: Practical Wisdom • Steadfast Endurance"
func detailedElementDescription(for element: Element) -> String {
    let cosmicData = loadMegaCorpusData()
    
    // Try to load from mega corpus first
    if let elements = cosmicData["elements"] as? [String: Any] {
        let elementKey = element.rawValue.lowercased()
        
        if let elementData = elements[elementKey] as? [String: Any] {
            if let description = elementData["description"] as? String,
               let archetype = elementData["archetype"] as? String,
               let keyTraits = elementData["keyTraits"] as? [String] {
                
                let traitsText = keyTraits.prefix(2).map { trait in
                    trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
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

// Planet Descriptions (Enhanced with MegaCorpus)
/// Claude: Enhanced planetary description using MegaCorpus astrological data
/// 
/// **Planetary Archetype Integration:**
/// - Loads planetary symbolism from MegaCorpus/Planets.json
/// - Combines planetary archetype with core keywords
/// - Provides authentic astrological interpretations
///
/// **Return Format:** "Archetype • Keyword1 • Keyword2 • Keyword3"
/// **Example:** "The Teacher • Expansion • Wisdom • Growth"
func detailedPlanetDescription(for planet: Planet) -> String {
    let cosmicData = loadMegaCorpusData()
    
    // Try to load from mega corpus first
    if let planets = cosmicData["planets"] as? [String: Any] {
        let planetKey = planet.rawValue.lowercased()
        
        if let planetData = planets[planetKey] as? [String: Any] {
            if let archetype = planetData["archetype"] as? String,
               let description = planetData["description"] as? String,
               let keyTraits = planetData["keyTraits"] as? [String] {
                
                let traitsText = keyTraits.prefix(2).map { trait in
                    trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
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

// Shadow Planet Descriptions (Enhanced with Mega Corpus)
func detailedShadowPlanetDescription(for planet: Planet) -> String {
    let cosmicData = loadMegaCorpusData()
    
    // Try to load shadow aspects from mega corpus
    if let planets = cosmicData["planets"] as? [String: Any] {
        let planetKey = planet.rawValue.lowercased()
        
        if let planetData = planets[planetKey] as? [String: Any],
           let description = planetData["description"] as? String,
           let archetype = planetData["archetype"] as? String,
           let keyTraits = planetData["keyTraits"] as? [String] {
            
            // Create shadow interpretation
            let shadowTraits = keyTraits.prefix(2).map { trait in
                let baseTrait = trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
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
    
    enum SanctumViewMode: String, CaseIterable {
        case birthChart = "Birth Chart"
        case liveTransits = "Live Transits"
        
        var icon: String {
            switch self {
            case .birthChart: return "person.circle.fill"
            case .liveTransits: return "globe.americas.fill"
            }
        }
        
        var description: String {
            switch self {
            case .birthChart: return "Your natal chart at birth"
            case .liveTransits: return "Current planetary positions"
            }
        }
    }
    
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
                            
                            // Claude: Phase 12A.1 - Your Natal Chart Section
                            natalChartSection(profile)
                        
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
            .sheet(item: $selectedHouseForSheet) { identifiableHouse in
                if let profile = userProfile {
                    HouseDetailView(houseNumber: identifiableHouse.value, profile: profile)
                }
            }
            .sheet(item: $selectedPlanet) { planet in
                PlanetDetailView(position: planet)
            }
            .sheet(item: $selectedAspect) { aspect in
                AspectDetailView(aspect: aspect)
            }
        }
    }
    
    // MARK: - Phase 12A.1: Natal Chart Section
    
    /// Claude: Your Natal Chart section with progressive disclosure accordions
    ///
    /// **🌌 Phase 12A.1: Sanctum Natal Chart Integration**
    /// 
    /// This section transforms the Sanctum into a comprehensive cosmic data center by adding
    /// interactive natal chart information using the Phase 11A birth chart foundation.
    /// Implements progressive disclosure to prevent information overload while providing
    /// deep astrological insights for spiritually curious users.
    ///
    /// **🏗️ Accordion Architecture:**
    /// - **Houses Accordion**: 12 astrological houses with planetary cusps
    /// - **Aspects Accordion**: Major natal aspects table with orbs and meanings  
    /// - **Glyph Map Accordion**: Visual ecliptic wheel with planetary positions
    ///
    /// **📱 UX Design:**
    /// - All accordions collapsed by default to prevent cognitive overload
    /// - Smooth expand/collapse animations using withAnimation
    /// - Consistent styling with existing Sanctum aesthetic
    /// - Tap-to-expand tooltips and detailed explanations
    ///
    /// **🔗 Integration:**
    /// - Uses Phase 11A birth chart properties from UserProfile
    /// - Builds on existing spiritual sanctuary concept
    /// - Maintains performance with lazy loading of complex astrological data
    private func natalChartSection(_ profile: UserProfile) -> some View {
        VStack(spacing: 24) {
            // Section Header with View Mode Toggle
            VStack(spacing: 12) {
                HStack {
                    Text("✦ Your Cosmic Map ✦")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.cyan, .blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 5)
                    
                    Spacer()
                    
                    // View Mode Toggle
                    Picker("View Mode", selection: $sanctumViewMode) {
                        ForEach(SanctumViewMode.allCases, id: \.self) { mode in
                            Label(mode.rawValue, systemImage: mode.icon)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scaleEffect(0.8)
                }
                
                Text(sanctumViewMode.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()
                
                if let birthplace = profile.birthplaceName {
                    Text("📍 \(birthplace)")
                        .font(.caption2)
                        .foregroundColor(.cyan.opacity(0.7))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.cyan.opacity(0.1))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            
            // Claude: Phase 12A.1 Enhancement - Birth Chart Summary
            if !getPlanetaryPositions(profile: profile).isEmpty {
                birthChartSummary(profile)
            }
            
            VStack(spacing: 16) {
                // Houses Accordion
                natalChartAccordion(
                    title: "🏠 Astrological Houses",
                    subtitle: "12 Life Areas & Planetary Cusps",
                    isExpanded: $housesAccordionExpanded,
                    content: {
                        housesAccordionContent(profile)
                    }
                )
                
                // Aspects Accordion  
                natalChartAccordion(
                    title: "⭐ Major Aspects",
                    subtitle: "Planetary Relationships & Orbs",
                    isExpanded: $aspectsAccordionExpanded,
                    content: {
                        aspectsAccordionContent(profile)
                    }
                )
                
                // Planetary Map Accordion
                natalChartAccordion(
                    title: "🌌 Planetary Map",
                    subtitle: "Visual Birth Chart Wheel",
                    isExpanded: $glyphMapAccordionExpanded,
                    content: {
                        glyphMapAccordionContent(profile)
                    }
                )
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
                                gradient: Gradient(colors: [.cyan.opacity(0.6), .blue.opacity(0.4), .purple.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: .cyan.opacity(0.3), radius: 15, x: 0, y: 8)
    }
    
    /// Claude: Phase 12A.1 Enhancement - Birth Chart Summary Section
    private func birthChartSummary(_ profile: UserProfile) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("🌟 Your Planetary Positions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            let positions = getPlanetaryPositions(profile: profile)
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(positions, id: \.planet) { position in
                    planetPositionCard(position: position)
                }
            }
            
            if profile.hasBirthTime {
                Text("✨ Calculated with exact birth time for precision")
                    .font(.caption2)
                    .foregroundColor(.cyan.opacity(0.6))
                    .italic()
            } else {
                Text("🕐 Add birth time for precise house cusps and angles")
                    .font(.caption2)
                    .foregroundColor(.yellow.opacity(0.7))
                    .italic()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Individual planet position card
    /// Claude: Phase 12A.1 Enhancement - Tappable planetary position cards with detail sheets
    private func planetPositionCard(position: PlanetaryPosition) -> some View {
        Button(action: {
            print("🪐 Tapped planet: \(position.planet) in \(position.sign)")
            selectedPlanet = position
        }) {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    HStack {
                        Text(getPlanetGlyph(position.planet))
                            .font(.title2)
                            .foregroundColor(getPlanetColor(position.planet))
                        Spacer()
                    }
                    
                    // Claude: Info icon indicator for tappability
                    Image(systemName: "info.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Text(position.planet)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("in \(position.sign)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(getPlanetColor(position.planet).opacity(0.3), lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Claude: Get planet color for theming
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
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.wrappedValue.toggle()
                }
                
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
                        .fill(Color.cyan.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
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
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Individual house card showing house number, life area, and ruling sign
    /// Claude: Phase 12A.1 Enhancement - Tappable house cards with detail sheets
    private func houseCard(houseNumber: Int, profile: UserProfile) -> some View {
        Button(action: {
            selectedHouseForSheet = IdentifiableInt(value: houseNumber)
        }) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(houseNumber)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Spacer()
                    
                    // Tap indicator
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.cyan.opacity(0.6))
                }
                
                Spacer()
                
                // Claude: Short description that fits in card
                Text(getHouseLifeAreaShort(houseNumber: houseNumber))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // Show ruling sign if available from Phase 11A data
                if let rulingSign = getHouseRulingSign(houseNumber: houseNumber, profile: profile) {
                    Text(rulingSign)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.cyan.opacity(0.8))
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.cyan.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.cyan.opacity(0.3), lineWidth: 0.5)
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
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
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
                
                Text(getAspectSymbol(aspect.type))
                    .font(.headline)
                    .foregroundColor(getAspectColor(aspect.type))
                
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
                    .fill(getAspectColor(aspect.type).opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Claude: Planetary Map accordion content with simple list view
    private func glyphMapAccordionContent(_ profile: UserProfile) -> some View {
        VStack(spacing: 16) {
            Text("🌟 Your planetary map shows where each planet was positioned in the zodiac at your birth moment.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Claude: Simple list view instead of complex circular chart
            VStack(spacing: 8) {
                ForEach(getPlanetaryPositions(profile: profile), id: \.planet) { position in
                    planetListRow(position: position)
                }
                
                // Show rising sign if available
                if let risingSign = profile.risingSign {
                    planetListRow(
                        position: PlanetaryPosition(
                            planet: "Ascendant", 
                            sign: risingSign, 
                            degree: 0
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
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    /// Claude: Individual planet row for list view
    /// Claude: Individual planet row for list view with rich descriptions
    private func planetListRow(position: PlanetaryPosition) -> some View {
        Button(action: {
            print("🪐 Tapped planet: \(position.planet) in \(position.sign)")
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
                    
                    // Mini archetype description
                    Text(getPlanetMiniDescription(position.planet))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
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
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        getPlanetColor(position.planet).opacity(0.3),
                                        Color.white.opacity(0.1)
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
    private func getPlanetMiniDescription(_ planet: String) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planets = cosmicData["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any],
           let archetype = planetData["archetype"] as? String {
            return archetype
        }
        
        // Fallback mini descriptions
        switch planet.lowercased() {
        case "sun": return "The Luminary"
        case "moon": return "The Nurturer"
        case "mercury": return "The Messenger"
        case "venus": return "The Lover"
        case "mars": return "The Warrior"
        case "jupiter": return "The Sage"
        case "saturn": return "The Teacher"
        case "uranus": return "The Awakener"
        case "neptune": return "The Mystic"
        case "pluto": return "The Transformer"
        case "ascendant": return "The Rising Self"
        default: return "Celestial Body"
        }
    }
    
    /// Get sign color for visual distinction
    private func getSignColor(_ sign: String) -> Color {
        let cosmicData = loadMegaCorpusData()
        
        if let signs = cosmicData["signs"] as? [String: Any],
           let signData = signs[sign.lowercased()] as? [String: Any],
           let element = signData["element"] as? String {
            
            switch element.lowercased() {
            case "fire": return .orange
            case "earth": return .brown
            case "air": return .cyan
            case "water": return .blue
            default: return .white
            }
        }
        
        return .white.opacity(0.8)
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

// MARK: - Phase 12A.1: Natal Chart Helper Functions & Data Structures

/// Claude: Data structure for natal aspects
struct NatalAspect: Identifiable {
    let id = UUID()
    let planet1: String
    let planet2: String
    let type: AspectType
    let orb: Double
}

/// Claude: Aspect types for natal chart analysis
enum AspectType: String, CaseIterable {
    case conjunction = "Conjunction"
    case opposition = "Opposition"
    case trine = "Trine"
    case square = "Square"
    case sextile = "Sextile"
}

/// Claude: Data structure for planetary positions on chart wheel
struct PlanetaryPosition: Identifiable {
    let id = UUID()
    let planet: String
    let sign: String
    let degree: Int
}

/// Claude: Identifiable wrapper for Int values in sheets
struct IdentifiableInt: Identifiable {
    let id = UUID()
    let value: Int
}

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
private func getHouseLifeAreaFull(houseNumber: Int) -> String {
    let cosmicData = loadMegaCorpusData()
    
    // Convert house number to word key (1 -> "first", 2 -> "second", etc.)
    let houseKeys = ["", "first", "second", "third", "fourth", "fifth", "sixth", 
                     "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]
    
    guard houseNumber >= 1 && houseNumber <= 12 else {
        return "Invalid house number"
    }
    
    let houseKey = houseKeys[houseNumber]
    
    // Try to load from mega corpus first
    if let houses = cosmicData["houses"] as? [String: Any],
       let houseData = houses[houseKey] as? [String: Any] {
        
        if let name = houseData["name"] as? String,
           let description = houseData["description"] as? String,
           let keyTraits = houseData["keyTraits"] as? [String] {
            
            let traitsText = keyTraits.prefix(4).map { trait in
                trait.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespaces) ?? trait
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

/// Claude: Get house ruling sign from Phase 11A birth chart data
private func getHouseRulingSign(houseNumber: Int, profile: UserProfile) -> String? {
    // This will be populated when full birth chart calculations are implemented
    // For now, show placeholder based on rising sign if available
    if let risingSign = profile.risingSign {
        let signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", 
                    "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        if let risingIndex = signs.firstIndex(of: risingSign) {
            let houseSignIndex = (risingIndex + houseNumber - 1) % 12
            return signs[houseSignIndex]
        }
    }
    return nil
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
            orb: 3.2
        ))
        
        aspects.append(NatalAspect(
            planet1: "Venus",
            planet2: "Jupiter",
            type: .trine,
            orb: 4.1
        ))
        
        aspects.append(NatalAspect(
            planet1: "Sun",
            planet2: "Mercury",
            type: .conjunction,
            orb: 2.1
        ))
        
        // Challenging aspects for growth
        aspects.append(NatalAspect(
            planet1: "Moon",
            planet2: "Saturn",
            type: .square,
            orb: 5.3
        ))
        
        aspects.append(NatalAspect(
            planet1: "Mars",
            planet2: "Pluto",
            type: .opposition,
            orb: 6.8
        ))
    }
    
    return aspects
}

/// Claude: Get planetary positions from Phase 11A birth chart data  
private func getPlanetaryPositions(profile: UserProfile) -> [PlanetaryPosition] {
    var positions: [PlanetaryPosition] = []
    
    // Natal data is properly loaded from profile
    
    // Use existing Phase 11A data if available
    if let sunSign = profile.natalSunSign {
        positions.append(PlanetaryPosition(planet: "Sun", sign: sunSign, degree: 15))
    } else {
        // Fallback sample data for testing
        positions.append(PlanetaryPosition(planet: "Sun", sign: "Leo", degree: 15))
    }
    
    if let moonSign = profile.natalMoonSign {
        positions.append(PlanetaryPosition(planet: "Moon", sign: moonSign, degree: 22))
    } else {
        // Fallback sample data for testing
        positions.append(PlanetaryPosition(planet: "Moon", sign: "Cancer", degree: 22))
    }
    if let mercurySign = profile.natalMercurySign {
        positions.append(PlanetaryPosition(planet: "Mercury", sign: mercurySign, degree: 8))
    } else {
        positions.append(PlanetaryPosition(planet: "Mercury", sign: "Gemini", degree: 8))
    }
    
    if let venusSign = profile.natalVenusSign {
        positions.append(PlanetaryPosition(planet: "Venus", sign: venusSign, degree: 28))
    } else {
        positions.append(PlanetaryPosition(planet: "Venus", sign: "Taurus", degree: 28))
    }
    
    if let marsSign = profile.natalMarsSign {
        positions.append(PlanetaryPosition(planet: "Mars", sign: marsSign, degree: 12))
    } else {
        positions.append(PlanetaryPosition(planet: "Mars", sign: "Aries", degree: 12))
    }
    
    if let jupiterSign = profile.natalJupiterSign {
        positions.append(PlanetaryPosition(planet: "Jupiter", sign: jupiterSign, degree: 18))
    } else {
        positions.append(PlanetaryPosition(planet: "Jupiter", sign: "Sagittarius", degree: 18))
    }
    
    if let saturnSign = profile.natalSaturnSign {
        positions.append(PlanetaryPosition(planet: "Saturn", sign: saturnSign, degree: 5))
    } else {
        positions.append(PlanetaryPosition(planet: "Saturn", sign: "Capricorn", degree: 5))
    }
    
    return positions
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
    default: return "⭐"
    }
}

/// Claude: Get aspect symbol
private func getAspectSymbol(_ aspectType: AspectType) -> String {
    switch aspectType {
    case .conjunction: return "☌"
    case .opposition: return "☍"
    case .trine: return "△"
    case .square: return "□"
    case .sextile: return "⚹"
    }
}

/// Claude: Get aspect color
private func getAspectColor(_ aspectType: AspectType) -> Color {
    switch aspectType {
    case .conjunction: return .yellow
    case .opposition: return .red
    case .trine: return .green
    case .square: return .orange
    case .sextile: return .blue
    }
}

// MARK: - Claude: Phase 12A.1 Enhancement - House Detail View

/// Claude: Detailed house information sheet with full astrological descriptions
struct HouseDetailView: View {
    let houseNumber: Int
    let profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        houseHeaderSection
                        planetsInHouseSection
                        houseDescriptionSection
                    }
                    .padding()
                }
            }
            .navigationTitle("House \(houseNumber)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
    
    private var houseHeaderSection: some View {
        VStack(spacing: 12) {
            HStack {
                houseNumberCircle
                houseInfoColumn
                Spacer()
            }
        }
        .padding()
        .background(headerBackground)
    }
    
    private var houseNumberCircle: some View {
        Text("\(houseNumber)")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.cyan)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(Color.cyan.opacity(0.2))
                    .overlay(
                        Circle()
                            .stroke(Color.cyan.opacity(0.5), lineWidth: 2)
                    )
            )
    }
    
    private var houseInfoColumn: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(getHouseTitle(houseNumber))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if let rulingSign = getHouseRulingSign(houseNumber: houseNumber, profile: profile) {
                Text("Ruled by \(rulingSign)")
                    .font(.subheadline)
                    .foregroundColor(.cyan.opacity(0.8))
            }
        }
    }
    
    private var headerBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var houseDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            descriptionText
            themesSection
        }
        .padding()
        .background(descriptionBackground)
    }
    
    private var descriptionText: some View {
        let fullDescription = getHouseLifeAreaFull(houseNumber: houseNumber)
        return Text(fullDescription)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .lineSpacing(4)
    }
    
    private var themesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Key Themes")
                .font(.headline)
                .foregroundColor(.cyan)
            
            themesGrid
            
            // Add ritual prompt if available
            if let ritualPrompt = getHouseRitualPrompt(houseNumber) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("✨ House Activation Ritual")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                        .padding(.top, 12)
                    
                    Text(ritualPrompt)
                        .font(.caption)
                        .foregroundColor(.yellow.opacity(0.8))
                        .italic()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.yellow.opacity(0.1))
                        )
                }
            }
        }
    }
    
    private var themesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 8) {
            ForEach(getHouseThemes(houseNumber), id: \.self) { theme in
                themeTag(theme)
            }
        }
    }
    
    private func themeTag(_ theme: String) -> some View {
        Text("• \(theme)")
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.cyan.opacity(0.1))
            )
    }
    
    /// Claude: Shows which planets are positioned in this house
    private var planetsInHouseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            planetsInHouseHeader
            planetsInHouseContent
        }
        .padding()
        .background(planetsInHouseBackground)
    }
    
    private var planetsInHouseHeader: some View {
        Text("Planets in This House")
            .font(.headline)
            .foregroundColor(.purple)
    }
    
    private var planetsInHouseContent: some View {
        let planetsInHouse = getPlanetsInHouse(houseNumber: houseNumber, profile: profile)
        
        return Group {
            if planetsInHouse.isEmpty {
                emptyHouseView
            } else {
                planetsListView(planetsInHouse)
            }
        }
    }
    
    private var emptyHouseView: some View {
        HStack {
            Image(systemName: "sparkles.rectangle.stack")
                .font(.title2)
                .foregroundColor(.purple.opacity(0.6))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("No planets in this house")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("This house expresses through your ruling sign: \(getHouseRulingSign(houseNumber: houseNumber, profile: profile) ?? "Unknown")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
    
    private func planetsListView(_ planets: [PlanetaryPosition]) -> some View {
        VStack(spacing: 8) {
            ForEach(planets, id: \.planet) { planetInfo in
                planetInfoRow(planetInfo)
            }
        }
    }
    
    private func planetInfoRow(_ planetInfo: PlanetaryPosition) -> some View {
        HStack(spacing: 12) {
            Text(getPlanetGlyph(planetInfo.planet))
                .font(.title2)
                .foregroundColor(getLocalPlanetColor(planetInfo.planet))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(planetInfo.planet)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("in \(planetInfo.sign)")
                    .font(.caption)
                    .foregroundColor(.purple.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(planetInfoBackground)
    }
    
    private var planetInfoBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.purple.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 0.5)
            )
    }
    
    private var planetsInHouseBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var descriptionBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
    
    private func getHouseTitle(_ houseNumber: Int) -> String {
        switch houseNumber {
        case 1: return "First House"
        case 2: return "Second House"
        case 3: return "Third House"
        case 4: return "Fourth House"
        case 5: return "Fifth House"
        case 6: return "Sixth House"
        case 7: return "Seventh House"
        case 8: return "Eighth House"
        case 9: return "Ninth House"
        case 10: return "Tenth House"
        case 11: return "Eleventh House"
        case 12: return "Twelfth House"
        default: return "Unknown House"
        }
    }
    
    /// Get house ritual prompt from MegaCorpus
    private func getHouseRitualPrompt(_ houseNumber: Int) -> String? {
        let cosmicData = loadMegaCorpusData()
        
        // Convert house number to word key
        let houseKeys = ["", "first", "second", "third", "fourth", "fifth", "sixth", 
                         "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]
        
        guard houseNumber >= 1 && houseNumber <= 12 else { return nil }
        
        let houseKey = houseKeys[houseNumber]
        
        if let houses = cosmicData["houses"] as? [String: Any],
           let houseData = houses[houseKey] as? [String: Any],
           let ritualPrompt = houseData["ritualPrompt"] as? String {
            return ritualPrompt
        }
        
        return nil
    }
    
    /// Claude: Get planets positioned in a specific house
    private func getPlanetsInHouse(houseNumber: Int, profile: UserProfile) -> [PlanetaryPosition] {
        var planetsInHouse: [PlanetaryPosition] = []
        
        // Claude: Distribute available planets across houses based on their natal signs
        // This is a simplified model - real implementation would use house cusp calculations
        
        // Get all available planetary positions
        let allPlanets = getAllAvailablePlanets(profile: profile)
        
        // Distribute planets across houses (simplified distribution for demonstration)
        for (index, planet) in allPlanets.enumerated() {
            let planetHouse = (index % 12) + 1  // Distribute evenly across 12 houses
            if planetHouse == houseNumber {
                planetsInHouse.append(planet)
            }
        }
        
        // Ensure some houses have planets for demonstration
        switch houseNumber {
        case 1:
            if planetsInHouse.isEmpty && profile.risingSign != nil {
                planetsInHouse.append(PlanetaryPosition(planet: "Mars", sign: profile.risingSign!, degree: 5))
            }
        case 5:
            if planetsInHouse.isEmpty && profile.natalSunSign != nil {
                planetsInHouse.append(PlanetaryPosition(planet: "Sun", sign: profile.natalSunSign!, degree: 15))
            }
        case 7:
            if planetsInHouse.isEmpty && profile.natalMoonSign != nil {
                planetsInHouse.append(PlanetaryPosition(planet: "Moon", sign: profile.natalMoonSign!, degree: 22))
            }
        default:
            break
        }
        
        return planetsInHouse
    }
    
    /// Claude: Get all available planets from profile data
    private func getAllAvailablePlanets(profile: UserProfile) -> [PlanetaryPosition] {
        var planets: [PlanetaryPosition] = []
        
        if let sunSign = profile.natalSunSign {
            planets.append(PlanetaryPosition(planet: "Sun", sign: sunSign, degree: 15))
        }
        if let moonSign = profile.natalMoonSign {
            planets.append(PlanetaryPosition(planet: "Moon", sign: moonSign, degree: 22))
        }
        if let mercurySign = profile.natalMercurySign {
            planets.append(PlanetaryPosition(planet: "Mercury", sign: mercurySign, degree: 8))
        }
        if let venusSign = profile.natalVenusSign {
            planets.append(PlanetaryPosition(planet: "Venus", sign: venusSign, degree: 12))
        }
        if let marsSign = profile.natalMarsSign {
            planets.append(PlanetaryPosition(planet: "Mars", sign: marsSign, degree: 18))
        }
        if let jupiterSign = profile.natalJupiterSign {
            planets.append(PlanetaryPosition(planet: "Jupiter", sign: jupiterSign, degree: 25))
        }
        if let saturnSign = profile.natalSaturnSign {
            planets.append(PlanetaryPosition(planet: "Saturn", sign: saturnSign, degree: 3))
        }
        
        return planets
    }
    
    /// Claude: Local planet color function for HouseDetailView
    private func getLocalPlanetColor(_ planet: String) -> Color {
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
        case "ascendant": return .yellow
        default: return .white
        }
    }
    
    private func getHouseThemes(_ houseNumber: Int) -> [String] {
        switch houseNumber {
        case 1: return ["Personal Identity", "First Impressions", "Physical Body", "New Beginnings"]
        case 2: return ["Money & Possessions", "Self-Worth", "Material Security", "Personal Values"]
        case 3: return ["Communication", "Siblings", "Local Environment", "Learning Style"]
        case 4: return ["Home & Family", "Emotional Foundation", "Ancestry", "Private Life"]
        case 5: return ["Creativity", "Romance", "Children", "Recreation", "Self-Expression"]
        case 6: return ["Daily Work", "Health Routines", "Service", "Organization"]
        case 7: return ["Marriage", "Partnerships", "Open Enemies", "Legal Matters"]
        case 8: return ["Transformation", "Shared Resources", "Intimacy", "Mysteries"]
        case 9: return ["Higher Education", "Philosophy", "Travel", "Spiritual Beliefs"]
        case 10: return ["Career", "Public Reputation", "Authority", "Life Direction"]
        case 11: return ["Friends", "Social Groups", "Future Goals", "Humanitarian Causes"]
        case 12: return ["Spirituality", "Subconscious", "Hidden Aspects", "Sacrifice"]
        default: return ["Unknown"]
        }
    }
}

// MARK: - Planet Detail View
struct PlanetDetailView: View {
    let position: PlanetaryPosition
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        planetHeader
                        planetDescriptionSection
                    }
                    .padding()
                }
            }
            .navigationTitle("\(position.planet)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
    
    private var planetHeader: some View {
        VStack(spacing: 12) {
            Text(getPlanetGlyph(position.planet))
                .font(.system(size: 60))
                .foregroundColor(getLocalPlanetColor(position.planet))
            
            Text("\(position.planet) in \(position.sign)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if position.degree > 0 {
                Text("\(position.degree)°")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private var planetDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Planet archetype and description
            planetArchetypeSection
            
            // Planet in sign interpretation
            planetInSignSection
            
            // Key themes and traits
            planetTraitsSection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private var planetArchetypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Planetary Archetype")
                .font(.headline)
                .foregroundColor(.cyan)
            
            let planetDescription = getPlanetDescription(for: position.planet)
            Text(planetDescription)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
    
    private var planetInSignSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(position.planet) in \(position.sign)")
                .font(.headline)
                .foregroundColor(.purple)
            
            let signInfluence = getPlanetInSignDescription(planet: position.planet, sign: position.sign)
            Text(signInfluence)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    private var planetTraitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Influences")
                .font(.headline)
                .foregroundColor(.orange)
            
            let traits = getPlanetKeyTraits(for: position.planet)
            ForEach(traits.prefix(4), id: \.self) { trait in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(.orange)
                    Text(trait)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    /// Get planet description from MegaCorpus data
    private func getPlanetDescription(for planet: String) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let planets = cosmicData["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any] {
            
            if let archetype = planetData["archetype"] as? String,
               let description = planetData["description"] as? String {
                return "\(archetype) • \(description)"
            }
        }
        
        // Fallback descriptions
        switch planet.lowercased() {
        case "sun": return "The Luminary • Center of consciousness and vital force"
        case "moon": return "The Nurturer • Emotional nature and unconscious patterns"
        case "mercury": return "The Messenger • Communication and mental processes"
        case "venus": return "The Lover • Values, relationships, and aesthetic sense"
        case "mars": return "The Warrior • Drive, passion, and assertive energy"
        case "jupiter": return "The Sage • Growth, expansion, and higher wisdom"
        case "saturn": return "The Teacher • Structure, discipline, and life lessons"
        case "uranus": return "The Awakener • Innovation, rebellion, and sudden change"
        case "neptune": return "The Mystic • Dreams, intuition, and transcendence"
        case "pluto": return "The Transformer • Deep change, power, and regeneration"
        default: return "Celestial influence in your birth chart"
        }
    }
    
    /// Get planet's key traits from MegaCorpus
    private func getPlanetKeyTraits(for planet: String) -> [String] {
        let cosmicData = loadMegaCorpusData()
        
        if let planets = cosmicData["planets"] as? [String: Any],
           let planetData = planets[planet.lowercased()] as? [String: Any],
           let keyTraits = planetData["keyTraits"] as? [String] {
            return keyTraits
        }
        
        // Fallback traits
        return ["Influences your chart", "Shapes your personality", "Guides your path"]
    }
    
    /// Generate planet in sign interpretation
    private func getPlanetInSignDescription(planet: String, sign: String) -> String {
        let planetEnergy = getPlanetKeyword(planet)
        let signQuality = getSignKeyQuality(sign)
        
        return "Your \(planetEnergy) expresses through the \(signQuality) qualities of \(sign). This combination creates a unique blend of energies that influences how you \(getPlanetAction(planet)) in life."
    }
    
    private func getPlanetKeyword(_ planet: String) -> String {
        switch planet.lowercased() {
        case "sun": return "core identity"
        case "moon": return "emotional nature"
        case "mercury": return "communication style"
        case "venus": return "way of loving"
        case "mars": return "drive and passion"
        case "jupiter": return "growth potential"
        case "saturn": return "life lessons"
        case "uranus": return "revolutionary spirit"
        case "neptune": return "spiritual connection"
        case "pluto": return "transformative power"
        case "ascendant": return "outer personality"
        default: return "cosmic influence"
        }
    }
    
    private func getSignKeyQuality(_ sign: String) -> String {
        let cosmicData = loadMegaCorpusData()
        
        if let signs = cosmicData["signs"] as? [String: Any],
           let signData = signs[sign.lowercased()] as? [String: Any],
           let element = signData["element"] as? String,
           let mode = signData["mode"] as? String {
            return "\(element) \(mode)"
        }
        
        // Fallback
        return "unique"
    }
    
    private func getPlanetAction(_ planet: String) -> String {
        switch planet.lowercased() {
        case "sun": return "express your identity"
        case "moon": return "feel and nurture"
        case "mercury": return "think and communicate"
        case "venus": return "love and appreciate"
        case "mars": return "act and assert"
        case "jupiter": return "grow and expand"
        case "saturn": return "structure your life"
        case "uranus": return "innovate and rebel"
        case "neptune": return "dream and transcend"
        case "pluto": return "transform and empower"
        default: return "express yourself"
        }
    }
    
    /// Claude: Local planet color function for PlanetDetailView
    private func getLocalPlanetColor(_ planet: String) -> Color {
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
        case "ascendant": return .yellow
        default: return .white
        }
    }
}

// MARK: - Aspect Detail View
struct AspectDetailView: View {
    let aspect: NatalAspect
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        aspectHeader
                        aspectDescriptionSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Aspect")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
    
    private var aspectHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                VStack {
                    Text(getPlanetGlyph(aspect.planet1))
                        .font(.system(size: 40))
                        .foregroundColor(getLocalPlanetColor(aspect.planet1))
                    Text(aspect.planet1)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(getAspectSymbol(aspect.type))
                    .font(.system(size: 50))
                    .foregroundColor(getLocalAspectColor(aspect.type))
                
                VStack {
                    Text(getPlanetGlyph(aspect.planet2))
                        .font(.system(size: 40))
                        .foregroundColor(getLocalPlanetColor(aspect.planet2))
                    Text(aspect.planet2)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Text("\(aspect.type.rawValue)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Orb: \(String(format: "%.1f", aspect.orb))°")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(getAspectColor(aspect.type).opacity(0.1))
        )
    }
    
    private var aspectDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Aspect archetype and meaning
            aspectArchetypeSection
            
            // Planetary interaction details
            planetaryInteractionSection
            
            // Aspect influence and guidance
            aspectInfluenceSection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private var aspectArchetypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aspect Archetype")
                .font(.headline)
                .foregroundColor(.cyan)
            
            let aspectDescription = getAspectDescription(for: aspect.type)
            Text(aspectDescription)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
    
    private var planetaryInteractionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Planetary Dialogue")
                .font(.headline)
                .foregroundColor(.purple)
            
            let interaction = generatePlanetaryInteraction()
            Text(interaction)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    private var aspectInfluenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Personal Expression")
                .font(.headline)
                .foregroundColor(.orange)
            
            let influence = generatePersonalInfluence()
            Text(influence)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
            
            // Ritual prompt if available
            if let ritualPrompt = getAspectRitualPrompt(for: aspect.type) {
                Text("✨ Ritual Suggestion")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                    .padding(.top, 8)
                
                Text(ritualPrompt)
                    .font(.caption)
                    .foregroundColor(.yellow.opacity(0.8))
                    .italic()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.1))
                    )
            }
        }
    }
    
    /// Generate detailed planetary interaction description
    private func generatePlanetaryInteraction() -> String {
        let planet1Energy = getPlanetKeywordFromString(aspect.planet1)
        let planet2Energy = getPlanetKeywordFromString(aspect.planet2)
        
        switch aspect.type {
        case .conjunction:
            return "Your \(planet1Energy) and \(planet2Energy) are fused together, creating an intensified blend where both energies merge into one powerful force. This creates a concentrated area of focus in your personality where these planetary themes are inseparable."
            
        case .opposition:
            return "Your \(planet1Energy) and \(planet2Energy) stand across from each other, creating a dynamic tension that requires balance. This aspect teaches you through the interplay of opposites, helping you integrate seemingly contradictory parts of yourself."
            
        case .trine:
            return "Your \(planet1Energy) and \(planet2Energy) flow together harmoniously, supporting each other with natural ease. This blessed aspect allows these planetary energies to enhance each other effortlessly, creating areas of natural talent."
            
        case .square:
            return "Your \(planet1Energy) and \(planet2Energy) create dynamic friction, challenging you to grow through tension. This aspect generates internal pressure that, when consciously worked with, becomes a source of strength and achievement."
            
        case .sextile:
            return "Your \(planet1Energy) and \(planet2Energy) offer each other opportunities for growth and expression. This supportive aspect creates openings for positive development when you actively engage with its potential."
        }
    }
    
    /// Generate personalized influence description
    private func generatePersonalInfluence() -> String {
        let aspectType = aspect.type
        let orbStrength = aspect.orb <= 3 ? "strongly" : aspect.orb <= 6 ? "moderately" : "subtly"
        
        return "This \(aspectType.rawValue.lowercased()) is \(orbStrength) active in your chart with an orb of \(String(format: "%.1f", aspect.orb))°. The closer the orb, the more powerfully you feel this aspect's influence in your daily life and personality expression."
    }
    
    /// Get aspect energy description
    private func getAspectEnergy(_ type: AspectType) -> String {
        switch type {
        case .conjunction: return "unified"
        case .opposition: return "polarized"
        case .trine: return "harmonious"
        case .square: return "dynamic"
        case .sextile: return "cooperative"
        }
    }
    
    /// Get ritual prompt from MegaCorpus if available
    private func getAspectRitualPrompt(for aspectType: AspectType) -> String? {
        let cosmicData = loadMegaCorpusData()
        
        let aspectKey = getAspectKey(aspectType)
        
        if let aspects = cosmicData["aspects"] as? [String: Any],
           let aspectData = aspects[aspectKey] as? [String: Any],
           let ritualPrompt = aspectData["ritualPrompt"] as? String {
            return ritualPrompt
        }
        
        return nil
    }
    
    /// Get rich aspect description from MegaCorpus data
    private func getAspectDescription(for aspectType: AspectType) -> String {
        let cosmicData = loadMegaCorpusData()
        
        let aspectKey = getAspectKey(aspectType)
        
        // Try to load from mega corpus first
        if let aspects = cosmicData["aspects"] as? [String: Any],
           let aspectData = aspects[aspectKey] as? [String: Any] {
            
            if let description = aspectData["description"] as? String,
               let keyTraits = aspectData["keyTraits"] as? [String] {
                
                let traitsText = keyTraits.prefix(3).joined(separator: " • ")
                return "\(description)\n\nKey Qualities: \(traitsText)"
            }
        }
        
        // Fallback descriptions
        switch aspectType {
        case .conjunction:
            return "The strongest blend of energies represented by the two planets. This aspect intensifies focus and personal power, creating synergy when aligned."
        case .opposition:
            return "Planets on opposite points of the Zodiac, polarizing their energies. This dynamic aspect compels you to find balance by facing what you project onto others."
        case .trine:
            return "Harmonious alignment creating natural ease and support. Trines open channels of creativity, talent, and grace."
        case .square:
            return "Dynamic, challenging aspect where planetary energies conflict, creating internal tension that demands action and growth."
        case .sextile:
            return "Supportive, opportunity-creating alignment that encourages cooperation and mutual growth, offering potentials that unfold when you take initiative."
        }
    }
    
    /// Map AspectType to MegaCorpus key
    private func getAspectKey(_ aspectType: AspectType) -> String {
        switch aspectType {
        case .conjunction: return "conjunction"
        case .opposition: return "opposition" 
        case .trine: return "trine"
        case .square: return "square"
        case .sextile: return "sextile"
        }
    }
    
    /// Get planet keyword for descriptions
    private func getPlanetKeyword(_ planet: Planet) -> String {
        switch planet {
        case .sun: return "core identity"
        case .moon: return "emotional nature"
        case .mercury: return "communication style"
        case .venus: return "values and relationships"
        case .mars: return "drive and action"
        case .jupiter: return "growth and expansion"
        case .saturn: return "discipline and structure"
        case .uranus: return "innovation and change"
        case .neptune: return "intuition and spirituality"
        case .pluto: return "transformation and power"
        case .earth: return "grounding and stability"
        }
    }
    
    /// Get planet keyword for descriptions from string
    private func getPlanetKeywordFromString(_ planetString: String) -> String {
        switch planetString.lowercased() {
        case "sun": return "core identity"
        case "moon": return "emotional nature"
        case "mercury": return "communication style"
        case "venus": return "values and relationships"
        case "mars": return "drive and action"
        case "jupiter": return "growth and expansion"
        case "saturn": return "discipline and structure"
        case "uranus": return "innovation and change"
        case "neptune": return "intuition and spirituality"
        case "pluto": return "transformation and power"
        case "earth": return "grounding and stability"
        default: return "planetary energy"
        }
    }
    
    /// Claude: Local helper functions for AspectDetailView
    private func getLocalPlanetColor(_ planet: String) -> Color {
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
    
    private func getLocalAspectColor(_ type: AspectType) -> Color {
        switch type {
        case .conjunction: return .yellow
        case .opposition: return .red
        case .trine: return .green
        case .square: return .orange
        case .sextile: return .blue
        }
    }
}

// MARK: - Data Loading Functions

/// Singleton cache for MegaCorpus data to avoid repeated loading
class MegaCorpusDataCache {
    static let shared = MegaCorpusDataCache()
    var data: [String: Any]?
    
    private init() {}
}

/// Creates fallback data when MegaCorpus files cannot be loaded
private func createFallbackData(for fileName: String) -> [String: Any] {
    switch fileName.lowercased() {
    case "signs":
        return createFallbackSignsData()
    case "houses":
        return createFallbackHousesData()
    case "planets":
        return createFallbackPlanetsData()
    case "aspects":
        return createFallbackAspectsData()
    case "elements":
        return createFallbackElementsData()
    case "modes":
        return createFallbackModesData()
    default:
        return [:]
    }
}

/// Loads the comprehensive MegaCorpus data containing all astrological information
/// This includes Signs, Houses, Planets, Aspects, Elements, Modes, etc.
func loadMegaCorpusData() -> [String: Any] {
    // Check if data is already cached using a singleton approach
    if let cachedData = MegaCorpusDataCache.shared.data {
        return cachedData
    }
    
    // Loading MegaCorpus data from bundle
    var megaCorpusData: [String: Any] = [:]
    
    // List of all MegaCorpus JSON files
    let dataFiles = [
        "Signs", "Houses", "Planets", "Aspects", 
        "Elements", "Modes", "MoonPhases", "ApparentMotion", "Numerology"
    ]
    
    for fileName in dataFiles {
        var loaded = false
        
        // Try multiple path approaches to find the files
        let pathAttempts = [
            Bundle.main.path(forResource: fileName, ofType: "json"),
            Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "MegaCorpus"),
            Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: "NumerologyData/MegaCorpus")
        ]
        
        // Attempting to load: \(fileName).json
        for (_, path) in pathAttempts.enumerated() {
            if let validPath = path,
               let data = try? Data(contentsOf: URL(fileURLWithPath: validPath)),
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Extract the main data section from each file
                if let mainKey = json.keys.first(where: { $0 != "metadata" }),
                   let mainData = json[mainKey] {
                    megaCorpusData[mainKey] = mainData
                    
                    // Also add individual entries for easier access
                    if let dataDict = mainData as? [String: Any] {
                        for (key, value) in dataDict {
                            megaCorpusData[key] = value
                        }
                    }
                    
                    // Successfully loaded: \(fileName).json
                    loaded = true
                    break
                }
            }
        }
        
        if !loaded {
            print("⚠️ Warning: Could not load MegaCorpus file: \(fileName).json")
            // Load fallback data for this category
            megaCorpusData[fileName.lowercased()] = createFallbackData(for: fileName)
        }
    }
    
    // Cache the data for future calls
    MegaCorpusDataCache.shared.data = megaCorpusData
    // MegaCorpus data cached successfully
    
    return megaCorpusData
}

/// Legacy alias for loadMegaCorpusData to maintain compatibility
func loadCosmicData() -> [String: Any] {
    return loadMegaCorpusData()
}

// MARK: - Fallback Data Functions

/// Creates fallback signs data when MegaCorpus files aren't available
private func createFallbackSignsData() -> [String: Any] {
    return [
        "aries": [
            "name": "Aries",
            "description": "Aries people are energetic, forceful and outgoing. They excel at getting things done—especially when it comes to beginnings—charging headlong into new ventures with a pioneering spirit."
        ],
        "taurus": [
            "name": "Taurus",
            "description": "Taureans revel in life's pleasures. They crave security and comfort, delighting in sensory richness and the warmth of home."
        ],
        "gemini": [
            "name": "Gemini", 
            "description": "Gemini is the archetype of duality and dialogue. Curious and quicksilver-minded, Geminis flit between ideas like butterflies."
        ]
    ]
}

/// Creates fallback houses data
private func createFallbackHousesData() -> [String: Any] {
    return [
        "first": ["name": "First House", "description": "House of Self & Identity"],
        "second": ["name": "Second House", "description": "House of Values & Possessions"],
        "third": ["name": "Third House", "description": "House of Communication & Learning"]
    ]
}

/// Creates fallback planets data
private func createFallbackPlanetsData() -> [String: Any] {
    return [
        "sun": ["name": "Sun", "description": "Planet of self-expression, vitality, and soul purpose"],
        "moon": ["name": "Moon", "description": "Planet of emotions, instincts, and nurturing"],
        "mercury": ["name": "Mercury", "description": "Planet of intellect and communication"]
    ]
}

/// Creates fallback aspects data
private func createFallbackAspectsData() -> [String: Any] {
    return [
        "conjunction": ["name": "Conjunction", "description": "The strongest blend of energies"],
        "opposition": ["name": "Opposition", "description": "Planets on opposite points, polarizing their energies"],
        "trine": ["name": "Trine", "description": "Harmonious alignment creating natural ease"]
    ]
}

/// Creates fallback elements data
private func createFallbackElementsData() -> [String: Any] {
    return [
        "fire": ["name": "Fire", "description": "Energetic, passionate, and action-oriented"],
        "earth": ["name": "Earth", "description": "Practical, grounded, and stable"],
        "air": ["name": "Air", "description": "Intellectual, communicative, and social"],
        "water": ["name": "Water", "description": "Emotional, intuitive, and flowing"]
    ]
}

/// Creates fallback modes data
private func createFallbackModesData() -> [String: Any] {
    return [
        "cardinal": ["name": "Cardinal", "description": "Initiating, leadership-oriented"],
        "fixed": ["name": "Fixed", "description": "Stable, persistent, unchanging"],
        "mutable": ["name": "Mutable", "description": "Adaptable, flexible, transitional"]
    ]
}

// MARK: - Preview

struct UserProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileTabView()
    }
} 